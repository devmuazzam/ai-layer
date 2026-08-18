
CREATE     PROCEDURE [etl].[usp_RunNightly_PayrollAPP]
    @RebuildAll bit = 0
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @RunId int = NULL,
        @RunDetailId int = NULL,
        @Err nvarchar(max) = NULL,
        @LockResult int,
        @HaveLock bit = 0;

    -------------------------------------------------------------------------
    -- Window config
    -------------------------------------------------------------------------
    DECLARE @LookbackDays int = 30;
    DECLARE @UseYesterday bit = 1;

    SELECT TOP (1)
        @LookbackDays = LookbackDays,
        @UseYesterday = UseYesterdayAsToDate
    FROM cfg.Nightly_RunSettings
    ORDER BY SettingsID DESC;

    IF @LookbackDays IS NULL OR @LookbackDays < 1
        SET @LookbackDays = 30;

    DECLARE @WorkDateTo date =
        CASE
            WHEN @UseYesterday = 1
                THEN DATEADD(DAY, -1, CONVERT(date, GETDATE()))
            ELSE CONVERT(date, GETDATE())
        END;

    DECLARE @WorkDateFrom date = DATEADD(DAY, 1 - @LookbackDays, @WorkDateTo);

    -------------------------------------------------------------------------
    -- Prevent overlapping nightly/UI-triggered PayrollAPP runs
    -------------------------------------------------------------------------
    EXEC @LockResult = sys.sp_getapplock
        @Resource = N'etl.usp_RunNightly_PayrollAPP',
        @LockMode = N'Exclusive',
        @LockOwner = N'Session',
        @LockTimeout = 0;

    IF @LockResult < 0
    BEGIN
        INSERT INTO etl.RunLog
            (RunType, StartedAtUTC, EndedAtUTC, Status, HostName, AppName, LoginName, ErrorMessage)
        VALUES
            ('NightlyPayroll', SYSUTCDATETIME(), SYSUTCDATETIME(), 'Skipped',
             HOST_NAME(), APP_NAME(), ORIGINAL_LOGIN(),
             'Another PayrollAPP run is already in progress.');

        RETURN 0;
    END;

    SET @HaveLock = 1;

    INSERT INTO etl.RunLog
        (RunType, StartedAtUTC, Status, HostName, AppName, LoginName)
    VALUES
        ('NightlyPayroll', SYSUTCDATETIME(), 'Running', HOST_NAME(), APP_NAME(), ORIGINAL_LOGIN());

    SET @RunId = SCOPE_IDENTITY();

    BEGIN TRY
        ---------------------------------------------------------------------
        -- Step 1: Refresh Synonyms
        ---------------------------------------------------------------------
        INSERT INTO etl.RunLogDetail
            (RunId, StepName, StartedAtUTC, Status)
        VALUES
            (@RunId, 'RefreshSynonyms', SYSUTCDATETIME(), 'Running');

        SET @RunDetailId = SCOPE_IDENTITY();

        EXEC etl.usp_RebuildSynonyms_RawFMS
            @TargetSchema = N'src',
            @DoIt = 1,
            @Quiet = 1;

        DECLARE @SynCount int;

        SELECT @SynCount = COUNT(*)
        FROM sys.synonyms
        WHERE SCHEMA_NAME(schema_id) = N'src'
          AND name LIKE N'FMS%_Raw';

        UPDATE etl.RunLogDetail
        SET EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            Notes = CONCAT('src synonyms ensured; count=', @SynCount)
        WHERE RunDetailId = @RunDetailId;

        ---------------------------------------------------------------------
        -- Step 2: Prepare Continuous Labor
        ---------------------------------------------------------------------
        INSERT INTO etl.RunLogDetail
            (RunId, StepName, StartedAtUTC, Status)
        VALUES
            (@RunId, 'PrepareContinuousLabor', SYSUTCDATETIME(), 'Running');

        SET @RunDetailId = SCOPE_IDENTITY();

        EXEC app.usp_Prepare_Continuous_Labor;

        DECLARE @Total bigint;
        DECLARE @Gap bigint;

        SELECT
            @Total = COUNT_BIG(*),
            @Gap = SUM(CASE WHEN Is_Gap_Row = 1 OR CraftCode = 'GAP-PAY' THEN 1 ELSE 0 END)
        FROM fms.Labor_PreProcessed;

        UPDATE etl.RunLogDetail
        SET EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            RowsAffected = CONVERT(int, CASE WHEN @Total > 2147483647 THEN 2147483647 ELSE @Total END),
            Notes = CONCAT('Total=', @Total, '; GapRows=', @Gap)
        WHERE RunDetailId = @RunDetailId;

        ---------------------------------------------------------------------
        -- Step 3: Run Pricing Engine
        ---------------------------------------------------------------------
        INSERT INTO etl.RunLogDetail
            (RunId, StepName, StartedAtUTC, Status)
        VALUES
            (@RunId, 'RunPricingEngine', SYSUTCDATETIME(), 'Running');

        SET @RunDetailId = SCOPE_IDENTITY();

        EXEC app.usp_Run_Pricing_Engine
            @WorkDateFrom = @WorkDateFrom,
            @WorkDateTo   = @WorkDateTo;

        DECLARE @CalcRows bigint;

        SELECT @CalcRows = COUNT_BIG(*)
        FROM fms.Payroll_Calculated
        WHERE WorkDate >= @WorkDateFrom
          AND WorkDate <  DATEADD(DAY, 1, @WorkDateTo);

        UPDATE etl.RunLogDetail
        SET EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            RowsAffected = CONVERT(int, CASE WHEN @CalcRows > 2147483647 THEN 2147483647 ELSE @CalcRows END),
            Notes = CONCAT(
                'Window=', CONVERT(varchar(10), @WorkDateFrom, 120),
                '->', CONVERT(varchar(10), @WorkDateTo, 120),
                '; Payroll_Calculated rows in window=', @CalcRows
            )
        WHERE RunDetailId = @RunDetailId;

        ---------------------------------------------------------------------
        -- Step 4: Finalize Payroll Outputs After Pricing
        --
        -- This wrapper now owns the full post-pricing chain:
        --   app.usp_Apply_BasePay_Fallback_FromSource
        --   app.usp_Apply_GuaranteedHours
        --   app.usp_Apply_RestPeriod_Premium
        --   app.usp_SuppressPay_WhenSourceRateMissing
        --   app.usp_Rebuild_PayComponentLedger
        --   app.usp_Finalize_PayComponentLedger_Reconciliation
        --   app.usp_Apply_SubsistencePay
        --   app.usp_Normalize_PayComponentLedger_Rounding
        ---------------------------------------------------------------------
        INSERT INTO etl.RunLogDetail
            (RunId, StepName, StartedAtUTC, Status)
        VALUES
            (@RunId, 'FinalizePayrollOutputsAfterPricing', SYSUTCDATETIME(), 'Running');

        SET @RunDetailId = SCOPE_IDENTITY();

        EXEC app.usp_FinalizePayrollOutputs_AfterPricing
            @WorkDateFrom = @WorkDateFrom,
            @WorkDateTo   = @WorkDateTo,
            @RunId        = @RunId;

        DECLARE @ZeroPayRemain bigint;
        DECLARE @GuaranteeRows bigint;
        DECLARE @RestRows bigint;
        DECLARE @MissingSourceRowsWithPay bigint;
        DECLARE @LedgerRows bigint;
        DECLARE @LedgerLaborEntryCount bigint;

        SELECT @ZeroPayRemain = COUNT_BIG(*)
        FROM fms.Payroll_Calculated
        WHERE WorkDate >= @WorkDateFrom
          AND WorkDate <  DATEADD(DAY, 1, @WorkDateTo)
          AND (ISNULL(Hrs_ST, 0) + ISNULL(Hrs_OT, 0) + ISNULL(Hrs_DT, 0)) > 0
          AND ISNULL(Pay_Actual_Gross, 0) = 0;

        SELECT @GuaranteeRows = COUNT_BIG(*)
        FROM fms.Payroll_GuaranteeAllocation a
        JOIN fms.Payroll_GuaranteeGroup g
            ON g.GuaranteeGroupID = a.GuaranteeGroupID
        WHERE COALESCE(g.CalendarDate, g.ShiftAnchorDate) >= @WorkDateFrom
          AND COALESCE(g.CalendarDate, g.ShiftAnchorDate) <= @WorkDateTo;

        SELECT @RestRows = COUNT_BIG(*)
        FROM fms.Payroll_Calculated
        WHERE WorkDate >= @WorkDateFrom
          AND WorkDate <  DATEADD(DAY, 1, @WorkDateTo)
          AND ISNULL(Pay_Rest_Add, 0) > 0;

        SELECT @MissingSourceRowsWithPay = COUNT_BIG(*)
        FROM fms.Payroll_Calculated pc
        JOIN app.v_Base_LaborPayroll b
            ON b.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @WorkDateFrom
          AND pc.WorkDate <  DATEADD(DAY, 1, @WorkDateTo)
          AND ISNULL(pc.Act_Total_Hrs, 0) > 0
          AND NULLIF(CONVERT(decimal(19,6), ISNULL(b.Source_Rate_Raw, 0.0)), 0.0) IS NULL
          AND
          (
                ISNULL(pc.Pay_Actual_Gross, 0) <> 0
             OR ISNULL(pc.Pay_Gap_Add, 0) <> 0
             OR ISNULL(pc.Pay_Rest_Add, 0) <> 0
             OR ISNULL(pc.Final_Gross_Pay, 0) <> 0
          );

        SELECT
            @LedgerRows = COUNT_BIG(*),
            @LedgerLaborEntryCount = COUNT_BIG(DISTINCT pc.LaborPayrollID)
        FROM fms.Payroll_Calculated pc
        JOIN fms.Payroll_PayComponent pcl
            ON pcl.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @WorkDateFrom
          AND pc.WorkDate <  DATEADD(DAY, 1, @WorkDateTo);

        UPDATE etl.RunLogDetail
        SET EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            RowsAffected = CONVERT(int, CASE WHEN @CalcRows > 2147483647 THEN 2147483647 ELSE @CalcRows END),
            Notes = CONCAT(
                'Window=', CONVERT(varchar(10), @WorkDateFrom, 120),
                '->', CONVERT(varchar(10), @WorkDateTo, 120),
                '; ZeroPayRemaining=', @ZeroPayRemain,
                '; GuaranteeAllocations=', @GuaranteeRows,
                '; RestPremiumRows=', @RestRows,
                '; MissingSourceRowsWithPay=', @MissingSourceRowsWithPay,
                '; LedgerRows=', @LedgerRows,
                '; LedgerLaborEntries=', @LedgerLaborEntryCount
            )
        WHERE RunDetailId = @RunDetailId;

        ---------------------------------------------------------------------
        -- Mark run succeeded
        ---------------------------------------------------------------------
        UPDATE etl.RunLog
        SET EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            ErrorMessage = NULL
        WHERE RunId = @RunId;

        IF @HaveLock = 1
        BEGIN
            EXEC sys.sp_releaseapplock
                @Resource = N'etl.usp_RunNightly_PayrollAPP',
                @LockOwner = N'Session';

            SET @HaveLock = 0;
        END;

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @Err = CONCAT(
            'Error ', ERROR_NUMBER(), ' (', ERROR_SEVERITY(), '/', ERROR_STATE(), ') ',
            'in ', COALESCE(ERROR_PROCEDURE(), '<unknown>'),
            ' at line ', ERROR_LINE(),
            ': ', ERROR_MESSAGE()
        );

        IF @RunDetailId IS NOT NULL
        BEGIN
            UPDATE etl.RunLogDetail
            SET EndedAtUTC = SYSUTCDATETIME(),
                Status = 'Failed',
                Notes = COALESCE(Notes + '; ', '') + @Err
            WHERE RunDetailId = @RunDetailId
              AND EndedAtUTC IS NULL;
        END;

        IF @RunId IS NOT NULL
        BEGIN
            UPDATE etl.RunLog
            SET EndedAtUTC = SYSUTCDATETIME(),
                Status = 'Failed',
                ErrorMessage = @Err
            WHERE RunId = @RunId;
        END;

        IF @HaveLock = 1
        BEGIN
            EXEC sys.sp_releaseapplock
                @Resource = N'etl.usp_RunNightly_PayrollAPP',
                @LockOwner = N'Session';

            SET @HaveLock = 0;
        END;

        RAISERROR(@Err, 16, 1);
        RETURN 1;
    END CATCH;
END;
