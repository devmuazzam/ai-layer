
CREATE   VIEW rpt.v_UI_Payroll_Exceptions_LatestRun
AS
WITH LastRun AS
(
    SELECT MAX(RunId) AS RunId
    FROM fms.Payroll_CalcException
    WHERE RunId IS NOT NULL
)
SELECT e.*
FROM rpt.v_UI_Payroll_Exceptions e
JOIN LastRun r
  ON r.RunId = e.RunId;
