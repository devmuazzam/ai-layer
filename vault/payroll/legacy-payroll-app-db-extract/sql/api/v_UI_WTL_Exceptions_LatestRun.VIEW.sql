
CREATE   VIEW api.v_UI_WTL_Exceptions_LatestRun
AS
WITH LatestWTLRun AS
(
    SELECT LatestCalcRunAt = MAX(e.CalcRunAt)
    FROM fms.Payroll_CalcException e
    WHERE e.Reason LIKE 'WTL%'
)
SELECT
    IssueLevel =
        CASE
            WHEN e.Reason LIKE 'WTL error:%'   THEN 'Error'
            WHEN e.Reason LIKE 'WTL warning:%' THEN 'Warning'
            WHEN e.Reason LIKE 'WTL review:%'  THEN 'Review'
            ELSE 'Unclassified'
        END,
    e.CalcRunAt,
    e.RunId,
    e.Reason,
    e.LaborPayrollID,
    e.WorkDate,
    e.EmpID,
    e.Employee_Name,
    e.JobTicketID,
    e.JobCode,
    e.Shift_Start,
    e.Shift_End,
    e.EmpID_Raw
FROM fms.Payroll_CalcException e
CROSS JOIN LatestWTLRun lr
WHERE e.Reason LIKE 'WTL%'
  AND e.CalcRunAt = lr.LatestCalcRunAt;
