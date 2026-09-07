CREATE   PROCEDURE [etl].[usp_RunNightly_PayrollAPP]
    @RebuildAll bit = 0
    , @WorkDateFromOverride date = NULL
    , @WorkDateToOverride   date = NULL
    , @RequireFreshPriorContext bit = 0
    , @CreatedRunId int = NULL OUTPUT
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

      SET @CreatedRunId = NULL;

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

    DECLARE @WorkDateFrom date =
        DATEADD(DAY, 1 - @LookbackDays, @WorkDateTo);

    -------------------------------------------------------------------------
    
        -------------------------------------------------------------------------
      -- Optional explicit calculation window
      --
      -- Scheduled nightly calls leave the override parameters NULL and retain
      -- the existing cfg.Nightly_RunSettings behavior.
      --
      -- Interactive Web / Excel calls may supply a complete Saturday-Friday
      -- payroll week.
      -------------------------------------------------------------------------
      DECLARE @ExplicitWindowRequested bit =
          CASE
              WHEN @WorkDateFromOverride IS NOT NULL
                OR @WorkDateToOverride   IS NOT NULL
                  THEN 1
              ELSE 0
          END;

      IF
      (
           @WorkDateFromOverride IS NULL
           AND @WorkDateToOverride IS NOT NULL
      )
      OR
      (
           @WorkDateFromOverride IS NOT NULL
           AND @WorkDateToOverride IS NULL
      )
      BEGIN
          THROW 53340,
              'WorkDateFromOverride and WorkDateToOverride must be supplied together.',
              1;
      END;

      IF @ExplicitWindowRequested = 1
      BEGIN
          SET @WorkDateFrom = @WorkDateFromOverride;
          SET @WorkDateTo   = @WorkDateToOverride;

          IF @WorkDateFrom > @WorkDateTo
          BEGIN
              THROW 53341,
                  'Explicit payroll calculation start date cannot be after end date.',
                  1;
          END;
      END;

      -------------------------------------------------------------------------
      -- Prior-period context freshness guard
      --
      -- This is intended for interactive Saturday-Friday refreshes.
      --
      -- The requested week itself is recalculated and persisted.
      -- The preceding payroll week remains read-only context.
      --
      -- Block the requested calculation if:
      --   1. an existing prior-week Payroll_Calculated row is older than the
      --      RawFMS labor row now representing that LaborPayrollID; or
      --   2. a prior-week labor row that the pricing engine would consider
      --      eligible has no Payroll_Calculated row.
      -------------------------------------------------------------------------
      IF @RequireFreshPriorContext = 1
      BEGIN
          IF @ExplicitWindowRequested = 0
          BEGIN
              THROW 53342,
                  'RequireFreshPriorContext requires an explicit calculation window.',
                  1;
          END;

          IF DATEDIFF(DAY, @WorkDateFrom, @WorkDateTo) <> 6
          BEGIN
              THROW 53343,
                  'Interactive payroll calculation must be exactly seven calendar days.',
                  1;
          END;

          DECLARE @InteractiveSaturdayOffset int =
              (
                  (
                      DATEDIFF
                      (
                          DAY,
                          CONVERT(date,'20200104'),
                          @WorkDateFrom
                      ) % 7
                  ) + 7
              ) % 7;

          IF @InteractiveSaturdayOffset <> 0
          BEGIN
              THROW 53344,
                  'Interactive payroll calculation must begin on Saturday.',
                  1;
          END;

          DECLARE
              @PriorContextStartDate date =
                  DATEADD(DAY,-7,@WorkDateFrom),

              @PriorContextEndDate date =
                  DATEADD(DAY,-1,@WorkDateFrom),

              @StalePriorRows bigint = 0,

              @MissingEligiblePriorRows bigint = 0,

              @ContextError nvarchar(2048);


          ---------------------------------------------------------------------
          -- Existing prior-week calculations whose RawFMS source was loaded
          -- after the calculation completed are stale.
          ---------------------------------------------------------------------
          SELECT
              @StalePriorRows =
                  COUNT_BIG(*)

          FROM fms.Payroll_Calculated pc

          LEFT JOIN etl.RunLog r
              ON r.RunId =
                 pc.RunId

          JOIN TCG_RawFMS.stg.FMS_LABOR_PAYROLL_Raw raw
              ON raw.LaborPayrollID =
                 pc.LaborPayrollID

          WHERE pc.WorkDate >= @PriorContextStartDate
            AND pc.WorkDate < DATEADD(DAY,1,@PriorContextEndDate)

            AND
            (
                   r.RunId IS NULL
                OR r.Status <> 'Succeeded'
                OR r.EndedAtUTC IS NULL
                OR raw._LoadedAtUTC > r.EndedAtUTC
            );


          ---------------------------------------------------------------------
          -- Reproduce the pricing-engine eligibility boundary for prior-week
          -- labor rows.
          --
          -- Salary rows are excluded.
          -- Zero-hour/no-time placeholders are excluded using the same
          -- predicates currently used by app.usp_Run_Pricing_Engine.
          ---------------------------------------------------------------------
          ;WITH EligiblePriorBase AS
          (
              SELECT
                  b.LaborPayrollID

              FROM app.v_Base_LaborPayroll b

              LEFT JOIN src.FMS_EMPLOYEES_Raw EPay
                  ON EPay.EmpID =
                     b.EmpID

              WHERE b.WorkDate >= @PriorContextStartDate
                AND b.WorkDate < DATEADD(DAY,1,@PriorContextEndDate)

                AND ISNULL(EPay.PayType,'') <> 'S'

                AND NOT
                (
                    b.JobTicketID IS NULL
                    AND b.JobCode IS NULL
                    AND ISNULL(b.HoursWorked_Raw,0) = 0
                    AND ISNULL(b.Source_Amount_Raw,0) = 0

                    AND
                    (
                        b.TimeStart_Labor IS NULL
                        OR CONVERT(time(0),b.TimeStart_Labor) = '00:00:00'
                    )

                    AND
                    (
                        b.TimeEnd_Labor IS NULL
                        OR CONVERT(time(0),b.TimeEnd_Labor) = '00:00:00'
                    )
                )

                AND NOT
                (
                    ISNULL(b.HoursWorked_Raw,0) = 0
                    AND ISNULL(b.Source_Amount_Raw,0) = 0

                    AND
                    (
                        b.TimeStart_Labor IS NULL
                        OR b.TimeEnd_Labor IS NULL

                        OR
                        (
                            b.TimeStart_Labor IS NOT NULL
                            AND b.TimeEnd_Labor IS NOT NULL

                            AND TRY_CONVERT
                                (
                                    datetime2(0),
                                    b.TimeStart_Labor
                                ) IS NOT NULL

                            AND TRY_CONVERT
                                (
                                    datetime2(0),
                                    b.TimeEnd_Labor
                                ) IS NOT NULL

                            AND TRY_CONVERT
                                (
                                    datetime2(0),
                                    b.TimeEnd_Labor
                                )
                                =
                                TRY_CONVERT
                                (
                                    datetime2(0),
                                    b.TimeStart_Labor
                                )
                        )

                        OR
                        (
                            b.TimeStart_Labor IS NOT NULL
                            AND CONVERT
                                (
                                    time(0),
                                    b.TimeStart_Labor
                                ) = '00:00:00'

                            AND b.TimeEnd_Labor IS NOT NULL
                            AND CONVERT
                                (
                                    time(0),
                                    b.TimeEnd_Labor
                                ) = '00:00:00'
                        )
                    )
                )
          )

          SELECT
              @MissingEligiblePriorRows =
                  COUNT_BIG(*)

          FROM EligiblePriorBase b

          LEFT JOIN fms.Payroll_Calculated pc
              ON pc.LaborPayrollID =
                 b.LaborPayrollID

          WHERE pc.LaborPayrollID IS NULL;


          IF
          (
               ISNULL(@StalePriorRows,0) > 0
               OR ISNULL(@MissingEligiblePriorRows,0) > 0
          )
          BEGIN
              SET @ContextError =
                  CONCAT
                  (
                      'Prior payroll context is not current. Stale calculated rows=',
                      ISNULL(@StalePriorRows,0),
                      '; eligible prior labor rows missing from Payroll_Calculated=',
                      ISNULL(@MissingEligiblePriorRows,0),
                      '. Recalculate/review the prior payroll period before refreshing this week.'
                  );

              THROW 53345,
                  @ContextError,
                  1;
          END;
      END;

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
        ---------------------------------------------------------------------
        -- Record skipped run together with the requested calculation window.
        ---------------------------------------------------------------------
        INSERT INTO etl.RunLog
        (
            RunType,
            StartedAtUTC,
            EndedAtUTC,
            Status,
            HostName,
            AppName,
            LoginName,
            ErrorMessage,
            WorkDateFrom,
            WorkDateTo
        )
        VALUES
        (
            'NightlyPayroll',
            SYSUTCDATETIME(),
            SYSUTCDATETIME(),
            'Skipped',
            HOST_NAME(),
            APP_NAME(),
            ORIGINAL_LOGIN(),
            'Another PayrollAPP run is already in progress.',
            @WorkDateFrom,
            @WorkDateTo
        );

        SET @CreatedRunId =
              CONVERT(int, SCOPE_IDENTITY());

          RETURN 0;
    END;

    SET @HaveLock = 1;

    -------------------------------------------------------------------------
    -- Create authoritative NightlyPayroll run header.
    --
    -- WorkDateFrom / WorkDateTo are persisted here so that the exact
    -- calculation scope remains part of the run lineage even if the
    -- run later fails.
    -------------------------------------------------------------------------
    INSERT INTO etl.RunLog
    (
        RunType,
        StartedAtUTC,
        Status,
        HostName,
        AppName,
        LoginName,
        WorkDateFrom,
        WorkDateTo
    )
    VALUES
    (
        'NightlyPayroll',
        SYSUTCDATETIME(),
        'Running',
        HOST_NAME(),
        APP_NAME(),
        ORIGINAL_LOGIN(),
        @WorkDateFrom,
        @WorkDateTo
    );

    SET @RunId = SCOPE_IDENTITY();

      SET @CreatedRunId = @RunId;

    BEGIN TRY

        ---------------------------------------------------------------------
        -- Make this NightlyPayroll RunId available to downstream procedures.
        ---------------------------------------------------------------------
        EXEC sys.sp_set_session_context
            @key   = N'PayrollAPP_RunLogID',
            @value = @RunId;

        ---------------------------------------------------------------------
        -- Step 1: Refresh Synonyms
        ---------------------------------------------------------------------
        INSERT INTO etl.RunLogDetail
        (
            RunId,
            StepName,
            StartedAtUTC,
            Status
        )
        VALUES
        (
            @RunId,
            'RefreshSynonyms',
            SYSUTCDATETIME(),
            'Running'
        );

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
        SET
            EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            Notes = CONCAT(
                'src synonyms ensured; count=',
                @SynCount
            )
        WHERE RunDetailId = @RunDetailId;

        ---------------------------------------------------------------------
        -- Step 2: Prepare Continuous Labor
        ---------------------------------------------------------------------
        INSERT INTO etl.RunLogDetail
        (
            RunId,
            StepName,
            StartedAtUTC,
            Status
        )
        VALUES
        (
            @RunId,
            'PrepareContinuousLabor',
            SYSUTCDATETIME(),
            'Running'
        );

        SET @RunDetailId = SCOPE_IDENTITY();

        EXEC app.usp_Prepare_Continuous_Labor;

        DECLARE @Total bigint;
        DECLARE @Gap bigint;

        SELECT
            @Total = COUNT_BIG(*),
            @Gap =
                SUM
                (
                    CASE
                        WHEN Is_Gap_Row = 1
                          OR CraftCode = 'GAP-PAY'
                            THEN 1
                        ELSE 0
                    END
                )
        FROM fms.Labor_PreProcessed;

        UPDATE etl.RunLogDetail
        SET
            EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            RowsAffected =
                CONVERT
                (
                    int,
                    CASE
                        WHEN @Total > 2147483647
                            THEN 2147483647
                        ELSE @Total
                    END
                ),
            Notes = CONCAT(
                'Total=',
                @Total,
                '; GapRows=',
                @Gap
            )
        WHERE RunDetailId = @RunDetailId;

        ---------------------------------------------------------------------
        -- Step 3: Run Pricing Engine
        ---------------------------------------------------------------------
        INSERT INTO etl.RunLogDetail
        (
            RunId,
            StepName,
            StartedAtUTC,
            Status
        )
        VALUES
        (
            @RunId,
            'RunPricingEngine',
            SYSUTCDATETIME(),
            'Running'
        );

        SET @RunDetailId = SCOPE_IDENTITY();

        EXEC app.usp_Run_Pricing_Engine
            @WorkDateFrom = @WorkDateFrom,
            @WorkDateTo   = @WorkDateTo;

        DECLARE @CalcRows bigint;

        SELECT @CalcRows = COUNT_BIG(*)
        FROM fms.Payroll_Calculated
        WHERE WorkDate >= @WorkDateFrom
          AND WorkDate < DATEADD(DAY, 1, @WorkDateTo);

        UPDATE etl.RunLogDetail
        SET
            EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            RowsAffected =
                CONVERT
                (
                    int,
                    CASE
                        WHEN @CalcRows > 2147483647
                            THEN 2147483647
                        ELSE @CalcRows
                    END
                ),
            Notes = CONCAT(
                'Window=',
                CONVERT(varchar(10), @WorkDateFrom, 120),
                '->',
                CONVERT(varchar(10), @WorkDateTo, 120),
                '; Payroll_Calculated rows in window=',
                @CalcRows
            )
        WHERE RunDetailId = @RunDetailId;

        ---------------------------------------------------------------------
        -- Step 4: Finalize Payroll Outputs After Pricing
        --
        -- This wrapper owns the full post-pricing chain:
        --
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
        (
            RunId,
            StepName,
            StartedAtUTC,
            Status
        )
        VALUES
        (
            @RunId,
            'FinalizePayrollOutputsAfterPricing',
            SYSUTCDATETIME(),
            'Running'
        );

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

        ---------------------------------------------------------------------
        -- Rows with payable hours but zero actual gross
        ---------------------------------------------------------------------
        SELECT @ZeroPayRemain = COUNT_BIG(*)
        FROM fms.Payroll_Calculated
        WHERE WorkDate >= @WorkDateFrom
          AND WorkDate < DATEADD(DAY, 1, @WorkDateTo)
          AND
          (
              ISNULL(Hrs_ST, 0)
            + ISNULL(Hrs_OT, 0)
            + ISNULL(Hrs_DT, 0)
          ) > 0
          AND ISNULL(Pay_Actual_Gross, 0) = 0;

        ---------------------------------------------------------------------
        -- Guarantee allocations in window
        ---------------------------------------------------------------------
        SELECT @GuaranteeRows = COUNT_BIG(*)
        FROM fms.Payroll_GuaranteeAllocation a
        JOIN fms.Payroll_GuaranteeGroup g
            ON g.GuaranteeGroupID = a.GuaranteeGroupID
        WHERE COALESCE(g.CalendarDate, g.ShiftAnchorDate) >= @WorkDateFrom
          AND COALESCE(g.CalendarDate, g.ShiftAnchorDate) <= @WorkDateTo;

        ---------------------------------------------------------------------
        -- Rest-period premium rows
        ---------------------------------------------------------------------
        SELECT @RestRows = COUNT_BIG(*)
        FROM fms.Payroll_Calculated
        WHERE WorkDate >= @WorkDateFrom
          AND WorkDate < DATEADD(DAY, 1, @WorkDateTo)
          AND ISNULL(Pay_Rest_Add, 0) > 0;

        ---------------------------------------------------------------------
        -- Safety validation:
        -- missing source-rate rows must not retain payroll amounts.
        ---------------------------------------------------------------------
        SELECT @MissingSourceRowsWithPay = COUNT_BIG(*)
        FROM fms.Payroll_Calculated pc
        JOIN app.v_Base_LaborPayroll b
            ON b.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @WorkDateFrom
          AND pc.WorkDate < DATEADD(DAY, 1, @WorkDateTo)
          AND ISNULL(pc.Act_Total_Hrs, 0) > 0
          AND NULLIF
              (
                  CONVERT
                  (
                      decimal(19,6),
                      ISNULL(b.Source_Rate_Raw, 0.0)
                  ),
                  0.0
              ) IS NULL
          AND
          (
                ISNULL(pc.Pay_Actual_Gross, 0) <> 0
             OR ISNULL(pc.Pay_Gap_Add, 0) <> 0
             OR ISNULL(pc.Pay_Rest_Add, 0) <> 0
             OR ISNULL(pc.Final_Gross_Pay, 0) <> 0
          );

        ---------------------------------------------------------------------
        -- Pay-component ledger counts in calculation window
        ---------------------------------------------------------------------
        SELECT
            @LedgerRows = COUNT_BIG(*),
            @LedgerLaborEntryCount =
                COUNT_BIG(DISTINCT pc.LaborPayrollID)
        FROM fms.Payroll_Calculated pc
        JOIN fms.Payroll_PayComponent pcl
            ON pcl.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @WorkDateFrom
          AND pc.WorkDate < DATEADD(DAY, 1, @WorkDateTo);

        UPDATE etl.RunLogDetail
        SET
            EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            RowsAffected =
                CONVERT
                (
                    int,
                    CASE
                        WHEN @CalcRows > 2147483647
                            THEN 2147483647
                        ELSE @CalcRows
                    END
                ),
            Notes = CONCAT(
                'Window=',
                CONVERT(varchar(10), @WorkDateFrom, 120),
                '->',
                CONVERT(varchar(10), @WorkDateTo, 120),
                '; ZeroPayRemaining=',
                @ZeroPayRemain,
                '; GuaranteeAllocations=',
                @GuaranteeRows,
                '; RestPremiumRows=',
                @RestRows,
                '; MissingSourceRowsWithPay=',
                @MissingSourceRowsWithPay,
                '; LedgerRows=',
                @LedgerRows,
                '; LedgerLaborEntries=',
                @LedgerLaborEntryCount
            )
        WHERE RunDetailId = @RunDetailId;

        ---------------------------------------------------------------------
        -- Mark run succeeded
        --
        -- WorkDateFrom / WorkDateTo were already stored when the RunLog
        -- record was created.
        ---------------------------------------------------------------------
        UPDATE etl.RunLog
        SET
            EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            ErrorMessage = NULL
        WHERE RunId = @RunId;

        ---------------------------------------------------------------------
        -- Clear shared run context
        ---------------------------------------------------------------------
        EXEC sys.sp_set_session_context
            @key   = N'PayrollAPP_RunLogID',
            @value = NULL;

        ---------------------------------------------------------------------
        -- Release application lock
        ---------------------------------------------------------------------
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

        ---------------------------------------------------------------------
        -- Always clear shared run context
        ---------------------------------------------------------------------
        EXEC sys.sp_set_session_context
            @key   = N'PayrollAPP_RunLogID',
            @value = NULL;

        SET @Err = CONCAT(
            'Error ',
            ERROR_NUMBER(),
            ' (',
            ERROR_SEVERITY(),
            '/',
            ERROR_STATE(),
            ') ',
            'in ',
            COALESCE(ERROR_PROCEDURE(), '<unknown>'),
            ' at line ',
            ERROR_LINE(),
            ': ',
            ERROR_MESSAGE()
        );

        ---------------------------------------------------------------------
        -- Mark active detail step failed
        ---------------------------------------------------------------------
        IF @RunDetailId IS NOT NULL
        BEGIN
            UPDATE etl.RunLogDetail
            SET
                EndedAtUTC = SYSUTCDATETIME(),
                Status = 'Failed',
                Notes =
                    COALESCE(Notes + '; ', '')
                    + @Err
            WHERE RunDetailId = @RunDetailId
              AND EndedAtUTC IS NULL;
        END;

        ---------------------------------------------------------------------
        -- Mark overall run failed
        --
        -- WorkDateFrom / WorkDateTo remain on the RunLog row so we know
        -- precisely which calculation window the failed run attempted.
        ---------------------------------------------------------------------
        IF @RunId IS NOT NULL
        BEGIN
            UPDATE etl.RunLog
            SET
                EndedAtUTC = SYSUTCDATETIME(),
                Status = 'Failed',
                ErrorMessage = @Err
            WHERE RunId = @RunId;
        END;

        ---------------------------------------------------------------------
        -- Release application lock
        ---------------------------------------------------------------------
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

