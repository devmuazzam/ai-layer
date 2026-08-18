
CREATE   VIEW api.v_UI_Payroll_LaborEntry_Ledger_Summary
AS
WITH ComponentAgg AS
(
    SELECT
        LaborPayrollID,

        ComponentRowCount =
            COUNT(*),

        LedgerTotalAmount =
            CAST(SUM(ISNULL(ComponentAmount, 0)) AS decimal(19,4)),

        LedgerFinalGross =
            CAST(SUM(CASE
                WHEN IncludedInFinalGross = 1
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        LedgerPayableGross =
            CAST(SUM(CASE
                WHEN IncludedInPayableGross = 1
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        PayableOnlyAmount =
            CAST(SUM(CASE
                WHEN IncludedInPayableGross = 1
                 AND IncludedInFinalGross = 0
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        ActualPayAmount =
            CAST(SUM(CASE
                WHEN ComponentGroup = 'ACTUAL'
                  OR ComponentCode LIKE '%BASE%'
                  OR ComponentCode LIKE '%ACTUAL%'
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        GuaranteeAmount =
            CAST(SUM(CASE
                WHEN ComponentGroup = 'GUARANTEE'
                  OR ComponentCode LIKE '%GUARANTEE%'
                  OR ComponentCode LIKE '%GAP%'
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        RestPeriodAmount =
            CAST(SUM(CASE
                WHEN ComponentGroup = 'REST_PERIOD'
                  OR ComponentCode LIKE '%REST%'
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        ShiftDifferentialAmount =
            CAST(SUM(CASE
                WHEN ComponentGroup IN ('SHIFT', 'SHIFT_DIFFERENTIAL')
                  OR ComponentCode LIKE '%SHIFT%'
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        WTLAmount =
            CAST(SUM(CASE
                WHEN ComponentGroup = 'WTL'
                  OR ComponentCode LIKE 'WTL%'
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        WTLMealDeductAmount =
            CAST(SUM(CASE
                WHEN ComponentCode = 'WTL_MEAL_DEDUCT'
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        WTLAddAmount =
            CAST(SUM(CASE
                WHEN ComponentGroup = 'WTL'
                 AND ComponentCode <> 'WTL_MEAL_DEDUCT'
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        SubsistenceAmount =
            CAST(SUM(CASE
                WHEN ComponentGroup = 'SUBSISTENCE'
                  OR ComponentCode LIKE '%SUBSISTENCE%'
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        RoundingAmount =
            CAST(SUM(CASE
                WHEN ComponentGroup = 'ROUNDING'
                  OR ComponentCode LIKE '%ROUNDING%'
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        OtherAmount =
            CAST(SUM(CASE
                WHEN ComponentGroup NOT IN
                (
                    'ACTUAL',
                    'GUARANTEE',
                    'REST_PERIOD',
                    'SHIFT',
                    'SHIFT_DIFFERENTIAL',
                    'WTL',
                    'SUBSISTENCE',
                    'ROUNDING'
                )
                THEN ISNULL(ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4))
    FROM fms.Payroll_PayComponent
    GROUP BY
        LaborPayrollID
)
SELECT
    pc.LaborPayrollID,
    pc.EmpID,
    pc.Employee_Name,
    pc.WorkDate,
    pc.JobCode,
    pc.JobTicketID,

    pc.Act_Total_Hrs,
    pc.Hrs_ST,
    pc.Hrs_OT,
    pc.Hrs_DT,
    pc.Pay_Actual_Gross,
    pc.Pay_Gap_Add,
    pc.Pay_Rest_Add,

    pc.Final_Gross_Pay AS PayrollCalculated_FinalGross,

    LaborGross_BeforeWTL =
        CAST(ISNULL(pc.Final_Gross_Pay, 0) AS decimal(19,4)),

    WTLAdjustment =
        CAST(ISNULL(ca.WTLAmount, 0) AS decimal(19,4)),

    LaborGross_AfterWTL =
        CAST(ISNULL(ca.LedgerFinalGross, 0) AS decimal(19,4)),

    SubsistenceAllowance =
        CAST(ISNULL(ca.SubsistenceAmount, 0) AS decimal(19,4)),

    PayableOnlyAmount =
        CAST(ISNULL(ca.PayableOnlyAmount, 0) AS decimal(19,4)),

    TotalPayableGross =
        CAST(ISNULL(ca.LedgerPayableGross, 0) AS decimal(19,4)),

    ComponentRowCount =
        ISNULL(ca.ComponentRowCount, 0),

    LedgerTotalAmount =
        CAST(ISNULL(ca.LedgerPayableGross, 0) AS decimal(19,4)),

    ExpectedLedgerTotalAmount =
        CAST(
            ISNULL(ca.LedgerFinalGross, 0)
          + ISNULL(ca.PayableOnlyAmount, 0)
        AS decimal(19,4)),

    LedgerTieOutDifference =
        CAST(
            ISNULL(ca.LedgerPayableGross, 0)
          - (
                ISNULL(ca.LedgerFinalGross, 0)
              + ISNULL(ca.PayableOnlyAmount, 0)
            )
        AS decimal(19,4)),

    LaborGrossTieOutDifference =
        CAST(
            ISNULL(ca.LedgerFinalGross, 0)
          - (
                ISNULL(pc.Final_Gross_Pay, 0)
              + ISNULL(ca.WTLAmount, 0)
            )
        AS decimal(19,4)),

    ActualPayAmount = ISNULL(ca.ActualPayAmount, 0),
    GuaranteeAmount = ISNULL(ca.GuaranteeAmount, 0),
    RestPeriodAmount = ISNULL(ca.RestPeriodAmount, 0),
    ShiftDifferentialAmount = ISNULL(ca.ShiftDifferentialAmount, 0),
    WTLAmount = ISNULL(ca.WTLAmount, 0),
    WTLMealDeductAmount = ISNULL(ca.WTLMealDeductAmount, 0),
    WTLAddAmount = ISNULL(ca.WTLAddAmount, 0),
    SubsistenceAmount = ISNULL(ca.SubsistenceAmount, 0),
    RoundingAmount = ISNULL(ca.RoundingAmount, 0),
    OtherAmount = ISNULL(ca.OtherAmount, 0),

    HasLedgerRows =
        CASE WHEN ca.LaborPayrollID IS NULL THEN 0 ELSE 1 END,

    LedgerTieOutStatus =
        CASE
            WHEN ca.LaborPayrollID IS NULL THEN 'No ledger rows'
            WHEN ABS(
                ISNULL(ca.LedgerPayableGross, 0)
              - (
                    ISNULL(ca.LedgerFinalGross, 0)
                  + ISNULL(ca.PayableOnlyAmount, 0)
                )
            ) <= 0.01
             AND ABS(
                ISNULL(ca.LedgerFinalGross, 0)
              - (
                    ISNULL(pc.Final_Gross_Pay, 0)
                  + ISNULL(ca.WTLAmount, 0)
                )
             ) <= 0.01
            THEN 'Balanced'
            ELSE 'Out of balance'
        END,

    wtl.EntryExpectedMealCount,
    wtl.MealBucket,
    wtl.WTL_TokenState,
    wtl.WTL_TokenCount,
    wtl.WTL_Token_MissedMeals,
    wtl.Has_ConflictingWTLTokens,
    wtl.HasWTLIssue,
    wtl.WTL_ErrorCount,
    wtl.WTL_WarningCount,
    wtl.WTL_ReviewCount,
    wtl.WTL_IssueReasons
FROM fms.Payroll_Calculated pc
LEFT JOIN ComponentAgg ca
    ON ca.LaborPayrollID = pc.LaborPayrollID
LEFT JOIN api.v_UI_WTL_LaborEntry_Status wtl
    ON wtl.LaborPayrollID = pc.LaborPayrollID;
