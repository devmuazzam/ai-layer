
CREATE   VIEW rpt.v_UI_Payroll_Issues_Enriched_LatestRun
AS
WITH last AS
(
    SELECT MAX(CalcRunAt) AS CalcRunAt
    FROM fms.Payroll_CalcException
)
SELECT e.*
FROM rpt.v_UI_Payroll_Issues_Enriched e
JOIN last
  ON last.CalcRunAt = e.CalcRunAt;
