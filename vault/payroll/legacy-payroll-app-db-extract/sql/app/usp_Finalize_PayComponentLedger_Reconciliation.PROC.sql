

/* 62A - Patch ledger finalizer to add explicit final-gross rounding adjustment */

CREATE     PROCEDURE [app].[usp_Finalize_PayComponentLedger_Reconciliation]
    @WorkDateFrom date = NULL,
    @WorkDateTo   date = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FromDate date = COALESCE(@WorkDateFrom, '19000101');
    DECLARE @ToDate   date = COALESCE(@WorkDateTo,   '99991231');

    /* ------------------------------------------------------------
       0) Remove existing rounding adjustments in range.
          This keeps reruns idempotent.
       ------------------------------------------------------------ */
    DELETE p
    FROM fms.Payroll_PayComponent p
    WHERE p.WorkDate >= @FromDate
      AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND p.ComponentCode = 'PAY_COMPONENT_ROUNDING_ADJUSTMENT';

    DECLARE @DeletedRoundingRows int = @@ROWCOUNT;

    /* ------------------------------------------------------------
       1) Remove stale guarantee components where current calculated
          row has no gap/add pay.
       ------------------------------------------------------------ */
    DELETE p
    FROM fms.Payroll_PayComponent p
    JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = p.LaborPayrollID
    WHERE p.WorkDate >= @FromDate
      AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND p.ComponentGroup = 'GUARANTEE'
      AND ISNULL(pc.Pay_Gap_Add, 0) = 0;

    DECLARE @DeletedStaleGuaranteeRows int = @@ROWCOUNT;

    /* ------------------------------------------------------------
       2) If any current Pay_Gap_Add rows have no guarantee ledger
          component, insert a reconciliation component.
       ------------------------------------------------------------ */
    ;WITH g AS
    (
        SELECT
            p.LaborPayrollID,
            GuaranteeLedgerAmount =
                SUM(CONVERT(decimal(19,4), p.ComponentAmount))
        FROM fms.Payroll_PayComponent p
        WHERE p.WorkDate >= @FromDate
          AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
          AND p.ComponentGroup = 'GUARANTEE'
        GROUP BY
            p.LaborPayrollID
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
        NULL,
        pc.CalcID,
        pc.LaborPayrollID,
        CONVERT(date, pc.WorkDate),
        pc.JobTicketID,
        pc.JobCode,
        pc.EmpID,
        pc.Employee_Name,
        'GUARANTEE_RECONCILIATION_ADJUSTMENT',
        'GUARANTEE',
        'Guaranteed Pay Add Reconciliation',
        'fms',
        'Payroll_Calculated',
        pc.CalcID,
        'PAY_GAP_ADD_RECONCILIATION',
        'Pay_Gap_Add reconciliation',
        pc.Gap_Hrs_Total,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        CONVERT(decimal(19,4), pc.Pay_Gap_Add),
        CONVERT(bit, 1),
        CONVERT(bit, 1),
        35,
        'Inserted because Pay_Gap_Add existed but no guarantee ledger component was found.'
    FROM fms.Payroll_Calculated pc
    LEFT JOIN g
        ON g.LaborPayrollID = pc.LaborPayrollID
    WHERE pc.WorkDate >= @FromDate
      AND pc.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND ISNULL(pc.Pay_Gap_Add, 0) <> 0
      AND ISNULL(g.GuaranteeLedgerAmount, 0) = 0;

    DECLARE @InsertedMissingGuaranteeRows int = @@ROWCOUNT;

    /* ------------------------------------------------------------
       3) True-up guarantee components so guarantee ledger equals
          current Pay_Gap_Add exactly.
       ------------------------------------------------------------ */
    ;WITH g AS
    (
        SELECT
            p.LaborPayrollID,
            GuaranteeLedgerAmount =
                SUM(CONVERT(decimal(19,4), p.ComponentAmount))
        FROM fms.Payroll_PayComponent p
        WHERE p.WorkDate >= @FromDate
          AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
          AND p.ComponentGroup = 'GUARANTEE'
        GROUP BY
            p.LaborPayrollID
    ),
    d AS
    (
        SELECT
            pc.LaborPayrollID,
            DiffAmount =
                CONVERT(decimal(19,4), ISNULL(pc.Pay_Gap_Add, 0))
              - CONVERT(decimal(19,4), ISNULL(g.GuaranteeLedgerAmount, 0))
        FROM fms.Payroll_Calculated pc
        JOIN g
            ON g.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @FromDate
          AND pc.WorkDate <  DATEADD(DAY, 1, @ToDate)
          AND ABS
              (
                  CONVERT(decimal(19,4), ISNULL(pc.Pay_Gap_Add, 0))
                - CONVERT(decimal(19,4), ISNULL(g.GuaranteeLedgerAmount, 0))
              ) >= 0.0001
    ),
    target AS
    (
        SELECT
            p.PayComponentID,
            d.DiffAmount,
            rn =
                ROW_NUMBER() OVER
                (
                    PARTITION BY p.LaborPayrollID
                    ORDER BY
                        p.DisplaySort DESC,
                        ABS(p.ComponentAmount) DESC,
                        p.PayComponentID DESC
                )
        FROM fms.Payroll_PayComponent p
        JOIN d
            ON d.LaborPayrollID = p.LaborPayrollID
        WHERE p.ComponentGroup = 'GUARANTEE'
    )
    UPDATE p
       SET p.ComponentAmount =
                CONVERT(decimal(19,4), p.ComponentAmount + t.DiffAmount),
           p.Explanation =
                CONCAT
                (
                    COALESCE(p.Explanation, ''),
                    ' | Ledger guarantee true-up adjustment=',
                    CONVERT(varchar(40), t.DiffAmount)
                )
    FROM fms.Payroll_PayComponent p
    JOIN target t
        ON t.PayComponentID = p.PayComponentID
    WHERE t.rn = 1;

    DECLARE @UpdatedGuaranteeTrueUpRows int = @@ROWCOUNT;

    /* ------------------------------------------------------------
    4) Insert explicit final-gross rounding adjustment.

        WTL-aware behavior:
        - WTL components are explicit payroll adjustments.
        - They should remain in the ledger.
        - They should NOT be offset by rounding adjustment rows.
        - Therefore, this rounding comparison excludes WTL components.

        Result:
        - Non-WTL ledger ties to fms.Payroll_Calculated.Final_Gross_Pay.
        - Full ledger ties to Final_Gross_Pay + WTL components.
    ------------------------------------------------------------ */
    ;WITH ledger AS
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
                            THEN CONVERT(decimal(19,4), p.ComponentAmount)
                        ELSE CONVERT(decimal(19,4), 0)
                    END
                )
        FROM fms.Payroll_PayComponent p
        WHERE p.WorkDate >= @FromDate
        AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
        GROUP BY
            p.LaborPayrollID
    ),
    diff AS
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
                CONVERT(decimal(19,4), ISNULL(pc.Final_Gross_Pay, 0))
            - CONVERT(decimal(19,4), ISNULL(l.LedgerFinalGross_ExcludingWTL, 0))
        FROM fms.Payroll_Calculated pc
        LEFT JOIN ledger l
            ON l.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @FromDate
        AND pc.WorkDate <  DATEADD(DAY, 1, @ToDate)
        AND ABS
            (
                CONVERT(decimal(19,4), ISNULL(pc.Final_Gross_Pay, 0))
                - CONVERT(decimal(19,4), ISNULL(l.LedgerFinalGross_ExcludingWTL, 0))
            ) >= 0.0001
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
        NULL,
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
        d.RoundingDiff,
        CONVERT(bit, 1),
        CONVERT(bit, 1),
        90,
        'Rounding adjustment so non-WTL pay component ledger ties exactly to fms.Payroll_Calculated.Final_Gross_Pay. WTL components remain explicit final-gross adjustments.'
    FROM diff d;

    DECLARE @InsertedRoundingRows int = @@ROWCOUNT;

    PRINT CONCAT('Deleted existing rounding adjustment rows: ', @DeletedRoundingRows);
    PRINT CONCAT('Deleted stale guarantee ledger rows: ', @DeletedStaleGuaranteeRows);
    PRINT CONCAT('Inserted missing guarantee reconciliation rows: ', @InsertedMissingGuaranteeRows);
    PRINT CONCAT('Updated guarantee true-up rows: ', @UpdatedGuaranteeTrueUpRows);
    PRINT CONCAT('Inserted final-gross rounding adjustment rows: ', @InsertedRoundingRows);
END;
