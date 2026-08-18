
CREATE   FUNCTION api.tvf_Employees_Active_FieldOnly_ForPayPeriodDate
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
        a.*
    FROM pp
    CROSS APPLY api.tvf_Employees_ActiveInRange(pp.PeriodStart, pp.PeriodEnd) a
    LEFT JOIN cfg.PayrollUI_ExcludedEmpID x
      ON x.EmpID = a.EmpID AND x.IsEnabled = 1
    WHERE x.EmpID IS NULL
      AND ISNULL(a.CraftCode,'') <> 'ADMIN-A'
      AND ISNULL(a.Is_OfficeStaff,'No') NOT IN ('Yes','Y','1','True')
      AND ISNULL(a.InOffice,'N') NOT IN ('Y','1','T')
      AND (
            ISNULL(a.UnionCode,'') = 'L12'
         OR a.CraftCode LIKE 'L12-%'
         OR a.CraftCode LIKE 'HDR-%'
      )
);
