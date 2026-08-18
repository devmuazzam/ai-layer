CREATE   VIEW api.v_PricingEngine_Run_Latest
AS
SELECT TOP (1)
    RunId, RunType, StartedAtUTC, EndedAtUTC, Status, HostName, AppName, LoginName, ErrorMessage
FROM etl.RunLog
WHERE RunType = 'PricingEngine'
ORDER BY RunId DESC;
