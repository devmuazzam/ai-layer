
CREATE   PROCEDURE app.usp_Normalize_PayComponentLedger_Rounding
    @WorkDateFrom date = NULL,
    @WorkDateTo   date = NULL,
    @RunId        int  = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FromDate date = COALESCE(@WorkDateFrom, '19000101');
    DECLARE @ToDate   date = COALESCE(@WorkDateTo,   '99991231');

    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
       AND @WorkDateFrom > @WorkDateTo
        THROW 51001, '@WorkDateFrom cannot be greater than @WorkDateTo.', 1;

    IF @RunId IS NULL
        SET @RunId = TRY_CONVERT(int, SESSION_CONTEXT(N'PayrollAPP_RunLogID'));

    IF OBJECT_ID(N'fms.Payroll_PayComponent', N'U') IS NULL
        THROW 51002, 'Missing fms.Payroll_PayComponent.', 1;

    IF OBJECT_ID(N'fms.Payroll_Calculated', N'U') IS NULL
        THROW 51003, 'Missing fms.Payroll_Calculated.', 1;

    IF OBJECT_ID(N'app.fn_RoundMoney', N'FN') IS NULL
        THROW 51004, 'Missing app.fn_RoundMoney.', 1;

    /* ------------------------------------------------------------
       1) Round compatibility/calculated pay fields that are amounts.
          Keep rates untouched elsewhere.
       ------------------------------------------------------------ */

    UPDATE pc
       SET
            pc.Pay_Actual_Gross  = app.fn_RoundMoney(CONVERT(decimal(38,10), ISNULL(pc.Pay_Actual_Gross, 0))),
            pc.Pay_Gap_Add       = app.fn_RoundMoney(CONVERT(decimal(38,10), ISNULL(pc.Pay_Gap_Add, 0))),
            pc.Pay_Rest_Add      = app.fn_RoundMoney(CONVERT(decimal(38,10), ISNULL(pc.Pay_Rest_Add, 0))),
            pc.Final_Gross_Pay   = app.fn_RoundMoney(CONVERT(decimal(38,10), ISNULL(pc.Final_Gross_Pay, 0)))
    FROM fms.Payroll_Calculated pc
    WHERE pc.WorkDate >= @FromDate
      AND pc.WorkDate <  DATEADD(DAY, 1, @ToDate);

    DECLARE @RoundedPayrollCalculatedRows int = @@ROWCOUNT;

    /* ------------------------------------------------------------
       2) Remove old rounding adjustment rows.
       ------------------------------------------------------------ */

    DELETE p
    FROM fms.Payroll_PayComponent p
    WHERE p.WorkDate >= @FromDate
      AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND p.ComponentCode = 'PAY_COMPONENT_ROUNDING_ADJUSTMENT';

    DECLARE @DeletedRoundingRows int = @@ROWCOUNT;

    /* ------------------------------------------------------------
       3) Round all non-rounding pay component amounts to cents.
          Rates stay at audit precision.

          WTL rows are rounded here too. That is okay.
          The balancing comparison below is WTL-aware.
       ------------------------------------------------------------ */

    UPDATE p
       SET p.ComponentAmount =
            CONVERT(decimal(19,4),
                app.fn_RoundMoney(CONVERT(decimal(38,10), ISNULL(p.ComponentAmount, 0)))
            )
    FROM fms.Payroll_PayComponent p
    WHERE p.WorkDate >= @FromDate
      AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND p.ComponentCode <> 'PAY_COMPONENT_ROUNDING_ADJUSTMENT'
      AND ABS
          (
              CONVERT(decimal(19,4), ISNULL(p.ComponentAmount, 0))
            - CONVERT(decimal(19,4), app.fn_RoundMoney(CONVERT(decimal(38,10), ISNULL(p.ComponentAmount, 0))))
          ) >= 0.0001;

    DECLARE @RoundedComponentRows int = @@ROWCOUNT;

    /* ------------------------------------------------------------
       4) Insert one clean cents-level final-gross rounding adjustment
          per labor entry only when needed.

          WTL-aware behavior:
          - WTL components are explicit payroll adjustments.
          - They remain included in the full pay component ledger.
          - They are excluded from this rounding comparison so they
            are not offset by PAY_COMPONENT_ROUNDING_ADJUSTMENT.

          Result:
          - Non-WTL ledger ties to fms.Payroll_Calculated.Final_Gross_Pay.
          - Full ledger ties to Final_Gross_Pay + WTL components.
       ------------------------------------------------------------ */

    ;WITH Ledger AS
    (
        SELECT
            p.LaborPayrollID,
            LedgerFinalGross_ExcludingWTL =
                SUM
                (
                    CASE
                        WHEN p.IncludedInFinalGross = 1
                         AND p.ComponentCode NOT IN
                            (
                                'WTL_MEAL_DEDUCT',
                                'WTL_DT_FLOOR',
                                'WTL_APPLICABLE_ADD'
                            )
                            THEN CONVERT(decimal(19,4), ISNULL(p.ComponentAmount, 0))
                        ELSE CONVERT(decimal(19,4), 0)
                    END
                )
        FROM fms.Payroll_PayComponent p
        WHERE p.WorkDate >= @FromDate
          AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
        GROUP BY
            p.LaborPayrollID
    ),
    Diff AS
    (
        SELECT
            pc.CalcID,
            pc.LaborPayrollID,
            WorkDate = CONVERT(date, pc.WorkDate),
            pc.JobTicketID,
            pc.JobCode,
            pc.EmpID,
            pc.Employee_Name,
            RoundingDiff =
                app.fn_RoundMoney
                (
                    CONVERT(decimal(38,10), ISNULL(pc.Final_Gross_Pay, 0))
                  - CONVERT(decimal(38,10), ISNULL(l.LedgerFinalGross_ExcludingWTL, 0))
                )
        FROM fms.Payroll_Calculated pc
        LEFT JOIN Ledger l
            ON l.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @FromDate
          AND pc.WorkDate <  DATEADD(DAY, 1, @ToDate)
    )
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
        d.CalcID,
        d.LaborPayrollID,
        d.WorkDate,
        d.JobTicketID,
        d.JobCode,
        d.EmpID,
        d.Employee_Name,
        'PAY_COMPONENT_ROUNDING_ADJUSTMENT',
        'ROUNDING',
        'Pay Component Rounding Adjustment',
        'fms',
        'Payroll_Calculated',
        d.CalcID,
        'FINAL_GROSS_LEDGER_ROUNDING',
        'Final gross ledger rounding',
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        CONVERT(decimal(19,4), d.RoundingDiff),
        CONVERT(bit, 1),
        CONVERT(bit, 1),
        90,
        'Cents-level rounding adjustment so non-WTL pay component ledger ties exactly to fms.Payroll_Calculated.Final_Gross_Pay. WTL components remain explicit final-gross adjustments.'
    FROM Diff d
    WHERE ABS(d.RoundingDiff) >= 0.01;

    DECLARE @InsertedRoundingRows int = @@ROWCOUNT;

    PRINT CONCAT('Rounded Payroll_Calculated rows: ', @RoundedPayrollCalculatedRows);
    PRINT CONCAT('Deleted old rounding adjustment rows: ', @DeletedRoundingRows);
    PRINT CONCAT('Rounded non-rounding pay component rows: ', @RoundedComponentRows);
    PRINT CONCAT('Inserted cents-level rounding adjustment rows: ', @InsertedRoundingRows);
END;
