CREATE   VIEW rpt.v_UI_Employees_FieldOnly_NoLabor_Count_CurrentPayPeriod
AS
WITH pp AS
(
    SELECT
        PeriodStart = app.fn_PayPeriodStart_SatFri(CONVERT(date, GETDATE())),
        PeriodEnd   = DATEADD(DAY, 6, app.fn_PayPeriodStart_SatFri(CONVERT(date, GETDATE())))
)
SELECT
    pp.PeriodStart,
    pp.PeriodEnd,
    MissingEmpCount = COUNT_BIG(*)
FROM pp
CROSS APPLY api.tvf_Employees_ActiveButNoLabor_FieldOnly(pp.PeriodStart, pp.PeriodEnd) x
GROUP BY pp.PeriodStart, pp.PeriodEnd;
