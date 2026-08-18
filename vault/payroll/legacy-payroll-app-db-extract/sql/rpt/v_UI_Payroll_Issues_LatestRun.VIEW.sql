CREATE   VIEW rpt.v_UI_Payroll_Issues_LatestRun
AS
WITH last AS
(
    SELECT MAX(CalcRunAt) AS CalcRunAt
    FROM fms.Payroll_CalcException
)
SELECT i.*
FROM rpt.v_UI_Payroll_Issues i
JOIN last
  ON last.CalcRunAt = i.CalcRunAt;
