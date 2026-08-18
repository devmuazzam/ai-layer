
CREATE   VIEW rpt.v_UI_Payroll_Issues_Enriched
AS
WITH LP AS
(
    SELECT DISTINCT LaborPayrollID
    FROM fms.Payroll_CalcException
    WHERE LaborPayrollID IS NOT NULL
),
TAgg AS
(
    SELECT
        t.LaborPayrollID,
        ShiftStart = MIN(CONVERT(datetime2(0), t.Pay_Start_Rounded)),
        ShiftEnd   = MAX(CONVERT(datetime2(0), t.Pay_End_Rounded))
    FROM calc.v_Calc_Labor_Timeline t
    JOIN LP
      ON LP.LaborPayrollID = t.LaborPayrollID
    WHERE ISNULL(t.Duration_Total_Payable,0) > 0
      AND t.Pay_Start_Rounded < t.Pay_End_Rounded
    GROUP BY t.LaborPayrollID
)
SELECT
    i.RunId,
    i.CalcRunAt,
    i.Reason,
    i.Severity,
    i.LaborPayrollID,
    i.WorkDate,
    i.EmpID,
    i.Employee_Name,
    i.JobTicketID,
    i.JobCode,
    Shift_Start = COALESCE(i.Shift_Start, ta.ShiftStart),
    Shift_End   = COALESCE(i.Shift_End,   ta.ShiftEnd)
FROM rpt.v_UI_Payroll_Issues i
LEFT JOIN TAgg ta
  ON ta.LaborPayrollID = i.LaborPayrollID;
