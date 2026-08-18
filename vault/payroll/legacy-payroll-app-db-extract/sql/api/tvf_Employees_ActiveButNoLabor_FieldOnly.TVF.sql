CREATE   FUNCTION api.tvf_Employees_ActiveButNoLabor_FieldOnly
(
    @FromDate date,
    @ToDate   date
)
RETURNS TABLE
AS
RETURN
(
    WITH ActiveEmp AS
    (
        SELECT *
        FROM api.tvf_Employees_ActiveInRange(@FromDate, @ToDate)
    ),
    ActiveField AS
    (
        SELECT a.*
        FROM ActiveEmp a
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
    ),
    EmpLabor AS
    (
        SELECT
            EmpID = CONVERT(varchar(15), blp.EmpID),
            LaborDays = COUNT(DISTINCT CONVERT(date, blp.WorkDate)),
            LaborRows = COUNT_BIG(*)
        FROM app.v_Base_LaborPayroll blp
        WHERE blp.WorkDate >= CONVERT(datetime2(7), @FromDate)
          AND blp.WorkDate <  CONVERT(datetime2(7), DATEADD(DAY, 1, @ToDate))
        GROUP BY CONVERT(varchar(15), blp.EmpID)
    )
    SELECT
        a.EmpID,
        a.FullName,
        a.EmploymentStatus,
        a.CraftCode,
        a.UnionCode,
        a.StartDate,
        a.TermDate,
        LaborRows = ISNULL(l.LaborRows, 0),
        LaborDays = ISNULL(l.LaborDays, 0)
    FROM ActiveField a
    LEFT JOIN EmpLabor l
      ON l.EmpID = a.EmpID
    WHERE ISNULL(l.LaborRows, 0) = 0
);
