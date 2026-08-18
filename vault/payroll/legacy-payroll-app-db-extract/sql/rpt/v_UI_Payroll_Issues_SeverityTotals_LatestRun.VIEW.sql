
CREATE   VIEW rpt.v_UI_Payroll_Issues_SeverityTotals_LatestRun
AS
WITH last AS
(
    SELECT MAX(CalcRunAt) AS CalcRunAt
    FROM fms.Payroll_CalcException
)
SELECT
    i.Severity,
    IssueCount = COUNT_BIG(*),
    EmpCount   = COUNT(DISTINCT i.EmpID),
    WorkDays   = COUNT(DISTINCT CONVERT(date, i.WorkDate))
FROM rpt.v_UI_Payroll_Issues i
JOIN last
  ON last.CalcRunAt = i.CalcRunAt
GROUP BY i.Severity;
