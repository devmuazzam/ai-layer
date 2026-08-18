

/* 61B-2 - Patch employee/day summary view */

CREATE   VIEW api.v_UI_Payroll_PayComponent_EmployeeDaySummary
AS
SELECT
    EmpID,
    Employee_Name,
    WorkDate = CONVERT(date, WorkDate),

    LaborEntryCount = COUNT_BIG(*),

    Act_Total_Hrs =
        SUM(CONVERT(decimal(19,4), ISNULL(Act_Total_Hrs, 0))),

    Hrs_ST =
        SUM(CONVERT(decimal(19,4), ISNULL(Hrs_ST, 0))),

    Hrs_OT =
        SUM(CONVERT(decimal(19,4), ISNULL(Hrs_OT, 0))),

    Hrs_DT =
        SUM(CONVERT(decimal(19,4), ISNULL(Hrs_DT, 0))),

    Actual_Base_Worked_Pay =
        SUM(CONVERT(decimal(19,4), ISNULL(Actual_Base_Worked_Pay, 0))),

    Actual_Boom_Worked_Pay =
        SUM(CONVERT(decimal(19,4), ISNULL(Actual_Boom_Worked_Pay, 0))),

    Actual_Shift_Differential =
        SUM(CONVERT(decimal(19,4), ISNULL(Actual_Shift_Differential, 0))),

    Actual_Worked_Gross =
        SUM(CONVERT(decimal(19,4), ISNULL(Actual_Worked_Gross, 0))),

    /* Compatibility alias */
    Actual_Worked_Pay =
        SUM(CONVERT(decimal(19,4), ISNULL(Actual_Worked_Pay, 0))),

    Guaranteed_Base_Pay_Add =
        SUM(CONVERT(decimal(19,4), ISNULL(Guaranteed_Base_Pay_Add, 0))),

    Guaranteed_Boom_Pay_Add =
        SUM(CONVERT(decimal(19,4), ISNULL(Guaranteed_Boom_Pay_Add, 0))),

    Guaranteed_Shift_Differential_Add =
        SUM(CONVERT(decimal(19,4), ISNULL(Guaranteed_Shift_Differential_Add, 0))),

    Guaranteed_Total_Pay_Add =
        SUM(CONVERT(decimal(19,4), ISNULL(Guaranteed_Total_Pay_Add, 0))),

    Rest_Period_Premium =
        SUM(CONVERT(decimal(19,4), ISNULL(Rest_Period_Premium, 0))),

    WTL_Adjustment =
        SUM(CONVERT(decimal(19,4), ISNULL(WTL_Adjustment, 0))),

    Shift_Differential =
        SUM(CONVERT(decimal(19,4), ISNULL(Shift_Differential, 0))),

    Sustenance =
        SUM(CONVERT(decimal(19,4), ISNULL(Sustenance, 0))),

    Final_Gross_Pay =
        SUM(CONVERT(decimal(19,4), ISNULL(Final_Gross_Pay, 0))),

    Current_Final_Gross =
        SUM(CONVERT(decimal(19,4), ISNULL(Current_Final_Gross, 0))),

    Payable_Gross_Including_Rest =
        SUM(CONVERT(decimal(19,4), ISNULL(Payable_Gross_Including_Rest, 0))),

    LedgerFinalGross =
        SUM(CONVERT(decimal(19,4), ISNULL(LedgerFinalGross, 0))),

    LedgerPayableGross =
        SUM(CONVERT(decimal(19,4), ISNULL(LedgerPayableGross, 0))),

    OutOfBalanceCount =
        SUM(CASE WHEN ReconciliationStatus <> 'OK' THEN 1 ELSE 0 END)
FROM api.v_UI_Payroll_PayComponent_Summary
GROUP BY
    EmpID,
    Employee_Name,
    CONVERT(date, WorkDate);
