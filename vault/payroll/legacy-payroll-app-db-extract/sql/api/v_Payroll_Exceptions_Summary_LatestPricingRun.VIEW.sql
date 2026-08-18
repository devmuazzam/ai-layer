CREATE   VIEW api.v_Payroll_Exceptions_Summary_LatestPricingRun
AS
WITH lr AS
(
    SELECT TOP (1) RunId
    FROM etl.RunLog
    WHERE RunType = 'PricingEngine'
    ORDER BY RunId DESC
)
SELECT
    e.RunId,
    e.Severity,
    e.Reason,
    Cnt = COUNT_BIG(*)
FROM rpt.v_UI_Payroll_Exceptions e
JOIN lr
  ON lr.RunId = e.RunId
GROUP BY e.RunId, e.Severity, e.Reason;
