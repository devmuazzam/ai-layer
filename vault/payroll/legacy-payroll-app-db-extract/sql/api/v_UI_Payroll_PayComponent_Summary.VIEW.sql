
/* 61B-1 - Patch pay component labor-entry summary view */

CREATE   VIEW api.v_UI_Payroll_PayComponent_Summary
AS
WITH c AS
(
    SELECT
        p.LaborPayrollID,

        Actual_Base_Worked_Pay =
            SUM(CASE
                    WHEN p.ComponentCode IN ('ACTUAL_BASE_WORKED_PAY', 'ACTUAL_WORKED_PAY')
                    THEN p.ComponentAmount ELSE 0
                END),

        Actual_Boom_Worked_Pay =
            SUM(CASE
                    WHEN p.ComponentCode = 'ACTUAL_BOOM_WORKED_PAY'
                    THEN p.ComponentAmount ELSE 0
                END),

        Actual_Shift_Differential =
            SUM(CASE
                    WHEN p.ComponentCode = 'ACTUAL_SHIFT_DIFFERENTIAL'
                    THEN p.ComponentAmount ELSE 0
                END),

        Guaranteed_Base_Pay_Add =
            SUM(CASE
                    WHEN p.ComponentCode IN
                    (
                        'GUARANTEED_BASE_PAY_ADD',
                        'GUARANTEED_HOLIDAY_BASE_PAY_ADD',
                        'GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD',
                        'GUARANTEE_RECONCILIATION_ADJUSTMENT'
                    )
                    THEN p.ComponentAmount ELSE 0
                END),

        Guaranteed_Boom_Pay_Add =
            SUM(CASE
                    WHEN p.ComponentCode = 'GUARANTEED_BOOM_PAY_ADD'
                    THEN p.ComponentAmount ELSE 0
                END),

        Guaranteed_Shift_Differential_Add =
            SUM(CASE
                    WHEN p.ComponentCode = 'GUARANTEED_SHIFT_DIFFERENTIAL_ADD'
                    THEN p.ComponentAmount ELSE 0
                END),

        Guaranteed_Total_Pay_Add =
            SUM(CASE
                    WHEN p.ComponentGroup = 'GUARANTEE'
                    THEN p.ComponentAmount ELSE 0
                END),

        Rest_Period_Premium =
            SUM(CASE
                    WHEN p.ComponentCode = 'REST_PERIOD_PREMIUM'
                    THEN p.ComponentAmount ELSE 0
                END),

        WTL_Adjustment =
            SUM(CASE
                    WHEN p.ComponentCode LIKE 'WTL%'
                    THEN p.ComponentAmount ELSE 0
                END),

        Sustenance =
            SUM(CASE
                    WHEN p.ComponentCode LIKE 'SUSTENANCE%'
                    THEN p.ComponentAmount ELSE 0
                END),

        LedgerFinalGross =
            SUM(CASE
                    WHEN p.IncludedInFinalGross = 1
                    THEN p.ComponentAmount ELSE 0
                END),

        LedgerPayableGross =
            SUM(CASE
                    WHEN p.IncludedInPayableGross = 1
                    THEN p.ComponentAmount ELSE 0
                END),

        ComponentCount = COUNT_BIG(*),
        FirstComponentAtUTC = MIN(p.CalculatedAtUTC),
        LastComponentAtUTC  = MAX(p.CalculatedAtUTC)
    FROM fms.Payroll_PayComponent p
    GROUP BY
        p.LaborPayrollID
)
SELECT
    pc.CalcID,
    pc.LaborPayrollID,
    pc.JobTicketID,
    pc.JobCode,
    pc.EmpID,
    pc.Employee_Name,
    pc.TicketDate,
    pc.WorkDate,

    pc.Act_Total_Hrs,
    pc.Act_Boom_Hrs,
    pc.Gap_Hrs_Total,
    pc.Gap_Hrs_Boom,
    pc.Pay_Total_Hrs,
    pc.Hrs_ST,
    pc.Hrs_OT,
    pc.Hrs_DT,

    Actual_Base_Worked_Pay =
        CONVERT(decimal(19,4), ISNULL(c.Actual_Base_Worked_Pay, 0)),

    Actual_Boom_Worked_Pay =
        CONVERT(decimal(19,4), ISNULL(c.Actual_Boom_Worked_Pay, 0)),

    Actual_Shift_Differential =
        CONVERT(decimal(19,4), ISNULL(c.Actual_Shift_Differential, 0)),

    Actual_Worked_Gross =
        CONVERT(decimal(19,4),
              ISNULL(c.Actual_Base_Worked_Pay, 0)
            + ISNULL(c.Actual_Boom_Worked_Pay, 0)
            + ISNULL(c.Actual_Shift_Differential, 0)
        ),

    /* Compatibility alias for existing API/UI code */
    Actual_Worked_Pay =
        CONVERT(decimal(19,4),
              ISNULL(c.Actual_Base_Worked_Pay, 0)
            + ISNULL(c.Actual_Boom_Worked_Pay, 0)
            + ISNULL(c.Actual_Shift_Differential, 0)
        ),

    Guaranteed_Base_Pay_Add =
        CONVERT(decimal(19,4), ISNULL(c.Guaranteed_Base_Pay_Add, 0)),

    Guaranteed_Boom_Pay_Add =
        CONVERT(decimal(19,4), ISNULL(c.Guaranteed_Boom_Pay_Add, 0)),

    Guaranteed_Shift_Differential_Add =
        CONVERT(decimal(19,4), ISNULL(c.Guaranteed_Shift_Differential_Add, 0)),

    Guaranteed_Total_Pay_Add =
        CONVERT(decimal(19,4), ISNULL(c.Guaranteed_Total_Pay_Add, 0)),

    Rest_Period_Premium =
        CONVERT(decimal(19,4), ISNULL(c.Rest_Period_Premium, 0)),

    WTL_Adjustment =
        CONVERT(decimal(19,4), ISNULL(c.WTL_Adjustment, 0)),

    Shift_Differential =
        CONVERT(decimal(19,4),
              ISNULL(c.Actual_Shift_Differential, 0)
            + ISNULL(c.Guaranteed_Shift_Differential_Add, 0)
        ),

    Sustenance =
        CONVERT(decimal(19,4), ISNULL(c.Sustenance, 0)),

    Final_Gross_Pay =
        CONVERT(decimal(19,4), ISNULL(pc.Final_Gross_Pay, 0)),

    Current_Final_Gross =
        CONVERT(decimal(19,4), ISNULL(pc.Final_Gross_Pay, 0)),

    /* Compatibility field. After redesign this should equal Final_Gross_Pay. */
    Payable_Gross_Including_Rest =
        CONVERT(decimal(19,4), ISNULL(pc.Final_Gross_Pay, 0)),

    LedgerFinalGross =
        CONVERT(decimal(19,4), ISNULL(c.LedgerFinalGross, 0)),

    LedgerPayableGross =
        CONVERT(decimal(19,4), ISNULL(c.LedgerPayableGross, 0)),

    Difference_Final_vs_Ledger =
        CONVERT(decimal(19,4),
            ISNULL(pc.Final_Gross_Pay, 0)
          - ISNULL(c.LedgerFinalGross, 0)
        ),

    Difference_CurrentFinal_vs_Ledger =
        CONVERT(decimal(19,4),
            ISNULL(pc.Final_Gross_Pay, 0)
          - ISNULL(c.LedgerFinalGross, 0)
        ),

    Difference_Payable_vs_Ledger =
        CONVERT(decimal(19,4),
            ISNULL(pc.Final_Gross_Pay, 0)
          - ISNULL(c.LedgerPayableGross, 0)
        ),

    Pay_Actual_Gross_CurrentColumn = pc.Pay_Actual_Gross,
    Pay_Gap_Add_CurrentColumn     = pc.Pay_Gap_Add,
    Pay_Rest_Add_CurrentColumn    = pc.Pay_Rest_Add,
    Final_Gross_Pay_CurrentColumn = pc.Final_Gross_Pay,

    ComponentCount =
        ISNULL(c.ComponentCount, 0),

    HasRestPremium =
        CONVERT(bit, CASE WHEN ISNULL(c.Rest_Period_Premium, 0) <> 0 THEN 1 ELSE 0 END),

    HasGuaranteePay =
        CONVERT(bit, CASE WHEN ISNULL(c.Guaranteed_Total_Pay_Add, 0) <> 0 THEN 1 ELSE 0 END),

    HasShiftDifferential =
        CONVERT(bit,
            CASE
                WHEN ISNULL(c.Actual_Shift_Differential, 0)
                   + ISNULL(c.Guaranteed_Shift_Differential_Add, 0) <> 0
                THEN 1 ELSE 0
            END
        ),

    ReconciliationStatus =
        CASE
            WHEN ABS(ISNULL(pc.Final_Gross_Pay, 0) - ISNULL(c.LedgerFinalGross, 0)) < 0.01
             AND ABS(ISNULL(pc.Final_Gross_Pay, 0) - ISNULL(c.LedgerPayableGross, 0)) < 0.01
                THEN 'OK'
            ELSE 'Out of balance'
        END,

    c.FirstComponentAtUTC,
    c.LastComponentAtUTC
FROM fms.Payroll_Calculated pc
LEFT JOIN c
    ON c.LaborPayrollID = pc.LaborPayrollID;
