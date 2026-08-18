CREATE   FUNCTION api.tvf_Employees_ActiveButNoLabor_ForPayPeriodDate
(
    @AnyDate date
)
RETURNS TABLE
AS
RETURN
(
    WITH pp AS
    (
        SELECT
            PeriodStart = app.fn_PayPeriodStart_SatFri(@AnyDate),
            PeriodEnd   = DATEADD(DAY, 6, app.fn_PayPeriodStart_SatFri(@AnyDate))
    )
    SELECT
        pp.PeriodStart,
        pp.PeriodEnd,
        x.*
    FROM pp
    CROSS APPLY api.tvf_Employees_ActiveButNoLabor(pp.PeriodStart, pp.PeriodEnd) x
);
