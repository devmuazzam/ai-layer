
CREATE   PROCEDURE app.usp_Apply_ShiftDifferentialHoursAdd
    @WorkDateFrom date = NULL,
    @WorkDateTo   date = NULL,
    @RunId        int  = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FromDate date = COALESCE(@WorkDateFrom, CONVERT(date, '19000101'));
    DECLARE @ToDate   date = COALESCE(@WorkDateTo,   CONVERT(date, '99991231'));

    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
       AND @WorkDateFrom > @WorkDateTo
        THROW 51001, '@WorkDateFrom cannot be greater than @WorkDateTo.', 1;

    IF @RunId IS NULL
        SET @RunId = TRY_CONVERT(int, SESSION_CONTEXT(N'PayrollAPP_RunLogID'));

    IF OBJECT_ID(N'app.v_LaborPayroll_CommentTokens', N'V') IS NULL
        THROW 51002, 'Missing app.v_LaborPayroll_CommentTokens.', 1;

    IF OBJECT_ID(N'api.v_UI_Pricing_Slices_Advanced', N'V') IS NULL
        THROW 51003, 'Missing api.v_UI_Pricing_Slices_Advanced.', 1;

    IF OBJECT_ID(N'fms.Payroll_PayComponent', N'U') IS NULL
        THROW 51004, 'Missing fms.Payroll_PayComponent.', 1;

    IF OBJECT_ID(N'fms.Payroll_Calculated', N'U') IS NULL
        THROW 51005, 'Missing fms.Payroll_Calculated.', 1;

    IF OBJECT_ID('tempdb..#AffectedShiftHoursAdd') IS NOT NULL
        DROP TABLE #AffectedShiftHoursAdd;

    CREATE TABLE #AffectedShiftHoursAdd
    (
        LaborPayrollID int NOT NULL
    );

    /* ------------------------------------------------------------
       Remove existing SD Hrs Add rows for idempotent reruns.
       Capture affected LPIDs so removed-token cases reset Final_Gross.
       ------------------------------------------------------------ */

    DELETE p
        OUTPUT deleted.LaborPayrollID INTO #AffectedShiftHoursAdd(LaborPayrollID)
    FROM fms.Payroll_PayComponent p
    WHERE p.WorkDate >= @FromDate
      AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND p.ComponentGroup = 'SHIFT_DIFFERENTIAL'
      AND p.ComponentCode IN ('SHIFT_2_HOURS_ADD', 'SHIFT_3_HOURS_ADD');

    DECLARE @DeletedRows int = @@ROWCOUNT;

    IF OBJECT_ID('tempdb..#NewShiftHoursAdd') IS NOT NULL
        DROP TABLE #NewShiftHoursAdd;

    ;WITH ShiftEntries AS
    (
        SELECT
            pc.CalcID,
            pc.LaborPayrollID,
            WorkDate = CONVERT(date, pc.WorkDate),
            pc.JobTicketID,
            pc.JobCode,
            pc.EmpID,
            pc.Employee_Name,

            ct.Has_SHIFT_2,
            ct.Has_SHIFT_3,
            ct.Has_ConflictingShiftTokens,
            ct.PayrollShiftCode_FromComments,
            ct.LaborComments_Clean,

            ShiftAddHours =
                CONVERT(decimal(10,2),
                    CASE
                        WHEN ct.PayrollShiftCode_FromComments = 2 THEN 1.00
                        WHEN ct.PayrollShiftCode_FromComments = 3 THEN 1.50
                        ELSE 0.00
                    END
                )
        FROM fms.Payroll_Calculated pc
        JOIN app.v_LaborPayroll_CommentTokens ct
            ON ct.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @FromDate
          AND pc.WorkDate <  DATEADD(DAY, 1, @ToDate)
          AND ISNULL(ct.Has_ConflictingShiftTokens, 0) = 0
          AND ct.PayrollShiftCode_FromComments IN (2, 3)
    ),
    LastSlice AS
    (
        SELECT
            se.*,

            s.SliceIndex,
            s.Slice_Start,
            s.Slice_End,
            s.Day_Type,
            s.Accumulation_Status,
            s.Is_Boom_Active,

            RateBaseUsed =
                CONVERT(decimal(12,4), ISNULL(s.Rate_Base, 0.00)),

            RateShiftUsed =
                CONVERT(decimal(12,4), ISNULL(s.Rate_Shift, 0.00)),

            RateBoomSeenOnLastSlice =
                CONVERT(decimal(12,4), ISNULL(s.Rate_Boom_Applied, 0.00)),

            MultiplierUsed =
                CONVERT(decimal(10,2), ISNULL(s.Final_Multiplier, 1.00)),

            rn = ROW_NUMBER() OVER
            (
                PARTITION BY se.LaborPayrollID
                ORDER BY s.Slice_End DESC, s.SliceIndex DESC
            )
        FROM ShiftEntries se
        JOIN api.v_UI_Pricing_Slices_Advanced s
            ON s.LaborPayrollID = se.LaborPayrollID
        WHERE ISNULL(s.Slice_Hours, 0.00) > 0.00
    )
    SELECT
        CalcID,
        LaborPayrollID,
        WorkDate,
        JobTicketID,
        JobCode,
        EmpID,
        Employee_Name,

        ComponentCode =
            CASE
                WHEN PayrollShiftCode_FromComments = 2 THEN 'SHIFT_2_HOURS_ADD'
                WHEN PayrollShiftCode_FromComments = 3 THEN 'SHIFT_3_HOURS_ADD'
            END,

        ComponentLabel =
            CASE
                WHEN PayrollShiftCode_FromComments = 2 THEN '2nd Shift Hours Add'
                WHEN PayrollShiftCode_FromComments = 3 THEN '3rd Shift Hours Add'
            END,

        SourceRuleCode =
            CASE
                WHEN PayrollShiftCode_FromComments = 2 THEN 'SHIFT_2_HOURS_ADD'
                WHEN PayrollShiftCode_FromComments = 3 THEN 'SHIFT_3_HOURS_ADD'
            END,

        SourceRuleName =
            CASE
                WHEN PayrollShiftCode_FromComments = 2 THEN '2nd shift paid-hours add'
                WHEN PayrollShiftCode_FromComments = 3 THEN '3rd shift paid-hours add'
            END,

        PayrollShiftCode_FromComments,
        ShiftAddHours,
        SliceIndex,
        Slice_Start,
        Slice_End,
        Day_Type,
        Accumulation_Status,
        Is_Boom_Active,

        RateBaseUsed,
        RateShiftUsed,

        /* Important: SD Hrs Add does NOT receive boom pay/rate. */
        RateBoomUsed = CONVERT(decimal(12,4), 0.00),

        RateBoomSeenOnLastSlice,
        MultiplierUsed,

        ComponentAmount =
            CONVERT(decimal(19,4),
                ShiftAddHours
              * (ISNULL(RateBaseUsed, 0.00) + ISNULL(RateShiftUsed, 0.00))
              * ISNULL(MultiplierUsed, 1.00)
            ),

        LaborComments_Clean
    INTO #NewShiftHoursAdd
    FROM LastSlice
    WHERE rn = 1
      AND ShiftAddHours > 0.00
      AND ISNULL(RateBaseUsed, 0.00) > 0.00
      AND ISNULL(RateShiftUsed, 0.00) > 0.00;

    INSERT INTO #AffectedShiftHoursAdd(LaborPayrollID)
    SELECT LaborPayrollID
    FROM #NewShiftHoursAdd;

    /* ------------------------------------------------------------
       Insert ledger rows.
       ------------------------------------------------------------ */

    INSERT fms.Payroll_PayComponent
    (
        RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        JobTicketID,
        JobCode,
        EmpID,
        Employee_Name,
        ComponentCode,
        ComponentGroup,
        ComponentLabel,
        SourceSchema,
        SourceTable,
        SourceID,
        SourceRuleCode,
        SourceRuleName,
        ComponentHours,
        Hrs_ST,
        Hrs_OT,
        Hrs_DT,
        RateBaseUsed,
        RateShiftUsed,
        RateBoomUsed,
        MultiplierUsed,
        ComponentAmount,
        IncludedInFinalGross,
        IncludedInPayableGross,
        DisplaySort,
        Explanation
    )
    SELECT
        @RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        JobTicketID,
        JobCode,
        EmpID,
        Employee_Name,
        ComponentCode,
        'SHIFT_DIFFERENTIAL',
        ComponentLabel,
        'app',
        'v_LaborPayroll_CommentTokens',
        LaborPayrollID,
        SourceRuleCode,
        SourceRuleName,
        ShiftAddHours,

        Hrs_ST =
            CASE WHEN ISNULL(MultiplierUsed, 1.00) = 1.00
                 THEN ShiftAddHours ELSE NULL END,

        Hrs_OT =
            CASE WHEN ISNULL(MultiplierUsed, 1.00) > 1.00
                   AND ISNULL(MultiplierUsed, 1.00) < 2.00
                 THEN ShiftAddHours ELSE NULL END,

        Hrs_DT =
            CASE WHEN ISNULL(MultiplierUsed, 1.00) >= 2.00
                 THEN ShiftAddHours ELSE NULL END,

        RateBaseUsed,
        RateShiftUsed,
        RateBoomUsed,
        MultiplierUsed,
        ComponentAmount,
        CONVERT(bit, 1),
        CONVERT(bit, 1),
        13,
        CONCAT
        (
            SourceRuleName,
            ': ',
            CONVERT(varchar(20), ShiftAddHours),
            ' added hrs * (base ',
            CONVERT(varchar(30), RateBaseUsed),
            ' + shift ',
            CONVERT(varchar(30), RateShiftUsed),
            ') * multiplier ',
            CONVERT(varchar(20), MultiplierUsed),
            '. Last slice ',
            CONVERT(varchar(19), Slice_Start, 120),
            ' - ',
            CONVERT(varchar(19), Slice_End, 120),
            '; day type=',
            COALESCE(Day_Type, 'NULL'),
            '; accumulation=',
            COALESCE(Accumulation_Status, 'NULL'),
            '; boom excluded from SD Hrs Add',
            CASE
                WHEN ISNULL(RateBoomSeenOnLastSlice, 0.00) <> 0.00
                    THEN CONCAT('; last slice boom rate seen but excluded=', CONVERT(varchar(30), RateBoomSeenOnLastSlice))
                ELSE ''
            END,
            '; comment=',
            COALESCE(LaborComments_Clean, '')
        )
    FROM #NewShiftHoursAdd
    WHERE ISNULL(ComponentAmount, 0.00) <> 0.00;

    DECLARE @InsertedRows int = @@ROWCOUNT;

    /* ------------------------------------------------------------
       Update Final_Gross_Pay for affected rows only.

       Clean base formula:
           Final_Gross_Pay =
               Pay_Actual_Gross
             + Pay_Gap_Add
             + Pay_Rest_Add
             + SD Hrs Add
       ------------------------------------------------------------ */

    ;WITH Affected AS
    (
        SELECT DISTINCT LaborPayrollID
        FROM #AffectedShiftHoursAdd
    ),
    NewAgg AS
    (
        SELECT
            LaborPayrollID,
            ShiftHoursAddAmount =
                CONVERT(decimal(19,4), SUM(ISNULL(ComponentAmount, 0.00)))
        FROM #NewShiftHoursAdd
        GROUP BY LaborPayrollID
    )
    UPDATE pc
       SET pc.Final_Gross_Pay =
            CONVERT(decimal(12,2),
                ISNULL(pc.Pay_Actual_Gross, 0.00)
              + ISNULL(pc.Pay_Gap_Add, 0.00)
              + ISNULL(pc.Pay_Rest_Add, 0.00)
              + ISNULL(na.ShiftHoursAddAmount, 0.00)
            )
    FROM fms.Payroll_Calculated pc
    JOIN Affected a
        ON a.LaborPayrollID = pc.LaborPayrollID
    LEFT JOIN NewAgg na
        ON na.LaborPayrollID = pc.LaborPayrollID;

    DECLARE @UpdatedFinalGrossRows int = @@ROWCOUNT;

    PRINT CONCAT('Deleted existing shift differential hours-add rows: ', @DeletedRows);
    PRINT CONCAT('Inserted shift differential hours-add rows: ', @InsertedRows);
    PRINT CONCAT('Updated Final_Gross_Pay rows for shift differential hours add: ', @UpdatedFinalGrossRows);
END;
