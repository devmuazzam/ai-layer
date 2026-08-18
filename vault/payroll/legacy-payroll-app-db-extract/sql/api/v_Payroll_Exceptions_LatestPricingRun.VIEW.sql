CREATE   VIEW api.v_Payroll_Exceptions_LatestPricingRun
AS
WITH lr AS
(
    SELECT TOP (1) RunId
    FROM etl.RunLog
    WHERE RunType = 'PricingEngine'
    ORDER BY RunId DESC
)
SELECT e.*
FROM rpt.v_UI_Payroll_Exceptions e
JOIN lr
  ON lr.RunId = e.RunId;
