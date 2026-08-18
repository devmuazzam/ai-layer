
CREATE FUNCTION [api].[tvf_UI_Payroll_Worklist_ForPayPeriodDate]
(
    @AnyDateInWeek date
)
RETURNS TABLE
AS
RETURN
WITH PP AS
(
    SELECT
        PeriodStart = app.fn_PayPeriodStart_SatFri(@AnyDateInWeek),
        PeriodEnd   = DATEADD(day, 6, app.fn_PayPeriodStart_SatFri(@AnyDateInWeek))
),
PayPeriodRow AS
(
    SELECT
        pp.PeriodStart,
        pp.PeriodEnd,
        p.PayPeriodID,
        HasPayPeriodNote =
            CONVERT(bit, CASE
                WHEN EXISTS
                (
                    SELECT 1
                    FROM api.v_PayrollNotes_PayPeriod npp
                    WHERE npp.PayPeriodID = p.PayPeriodID
                      AND npp.IsLatest = 1
                ) THEN 1

                WHEN NULLIF(LTRIM(RTRIM(p.PayPeriodNote)), '') IS NOT NULL THEN 1

                ELSE 0
            END)
    FROM PP pp
    LEFT JOIN app.PayPeriod p
        ON p.PeriodStartDate = pp.PeriodStart
       AND p.PeriodEndDate   = pp.PeriodEnd
),
Issues AS
(
    SELECT
        EmpID_Key = COALESCE(NULLIF(e.EmpID_Raw, ''), CONVERT(varchar(50), e.EmpID)),
        e.Employee_Name,
        e.Severity,
        e.Reason,
        e.WorkDate
    FROM api.v_Payroll_Exceptions_LatestPricingRun e
    CROSS JOIN PP pp
    WHERE e.WorkDate >= pp.PeriodStart
      AND e.WorkDate <  DATEADD(day, 1, pp.PeriodEnd)
),
ActiveEmp AS
(
    /*
        Payroll Manager roster rule #1:
        show every employee whose employee-master status is Active,
        regardless of craft, union, office/admin classification, or labor presence.
    */
    SELECT
        pp.PeriodStart,
        pp.PeriodEnd,
        EmpID = CONVERT(varchar(50), be.EmpID),
        Employee_Name = be.FullName,
        IsActiveEmployee   = 1,
        HasActivityInPeriod = 0,
        HasIssueInPeriod    = 0
    FROM PP pp
    JOIN app.v_Base_Employees be
      ON be.EmploymentStatus = 'Active'
    WHERE be.EmpID IS NOT NULL
      AND NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), be.EmpID))), '') IS NOT NULL
      AND NOT EXISTS
      (
          SELECT 1
          FROM cfg.PayrollUI_ExcludedEmpID x
          WHERE x.EmpID = CONVERT(varchar(50), be.EmpID)
            AND x.IsEnabled = 1
      )
),
ActivityEmp AS
(
    /*
        Payroll Manager roster rule #2:
        also show anyone with labor/payroll activity in the selected pay period,
        even if they are inactive, admin, non-union, non-field, etc.
    */
    SELECT
        pp.PeriodStart,
        pp.PeriodEnd,
        EmpID = CONVERT(varchar(50), d.EmpID),
        Employee_Name = MAX(d.Employee_Name),
        IsActiveEmployee    = 0,
        HasActivityInPeriod = 1,
        HasIssueInPeriod    = 0
    FROM PP pp
    JOIN api.v_Payroll_LaborEntry_WeekDetail d
      ON d.WorkDate_Date >= pp.PeriodStart
     AND d.WorkDate_Date <  DATEADD(day, 1, pp.PeriodEnd)
    WHERE d.EmpID IS NOT NULL
      AND NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), d.EmpID))), '') IS NOT NULL
      AND NOT EXISTS
      (
          SELECT 1
          FROM cfg.PayrollUI_ExcludedEmpID x
          WHERE x.EmpID = CONVERT(varchar(50), d.EmpID)
            AND x.IsEnabled = 1
      )
    GROUP BY
        pp.PeriodStart,
        pp.PeriodEnd,
        CONVERT(varchar(50), d.EmpID)
),
IssueEmp AS
(
    /*
        Safety net:
        show anyone with latest-run issues in the selected pay period,
        even if the issue row is not represented in the active roster.
    */
    SELECT
        pp.PeriodStart,
        pp.PeriodEnd,
        EmpID = i.EmpID_Key,
        Employee_Name = MAX(i.Employee_Name),
        IsActiveEmployee    = 0,
        HasActivityInPeriod = 0,
        HasIssueInPeriod    = 1
    FROM PP pp
    JOIN Issues i
      ON i.WorkDate >= pp.PeriodStart
     AND i.WorkDate <  DATEADD(day, 1, pp.PeriodEnd)
    WHERE i.EmpID_Key IS NOT NULL
      AND NULLIF(LTRIM(RTRIM(i.EmpID_Key)), '') IS NOT NULL
      AND NOT EXISTS
      (
          SELECT 1
          FROM cfg.PayrollUI_ExcludedEmpID x
          WHERE x.EmpID = i.EmpID_Key
            AND x.IsEnabled = 1
      )
    GROUP BY
        pp.PeriodStart,
        pp.PeriodEnd,
        i.EmpID_Key
),
SeedRaw AS
(
    SELECT PeriodStart, PeriodEnd, EmpID, Employee_Name,
           IsActiveEmployee, HasActivityInPeriod, HasIssueInPeriod
    FROM ActiveEmp

    UNION ALL

    SELECT PeriodStart, PeriodEnd, EmpID, Employee_Name,
           IsActiveEmployee, HasActivityInPeriod, HasIssueInPeriod
    FROM ActivityEmp

    UNION ALL

    SELECT PeriodStart, PeriodEnd, EmpID, Employee_Name,
           IsActiveEmployee, HasActivityInPeriod, HasIssueInPeriod
    FROM IssueEmp
),
EmpSeed AS
(
    /*
        Collapse to one row per employee for the selected pay period.
    */
    SELECT
        PeriodStart,
        PeriodEnd,
        EmpID,
        Employee_Name =
            MAX(NULLIF(LTRIM(RTRIM(Employee_Name)), '')),

        IsActiveEmployee =
            CONVERT(bit, MAX(IsActiveEmployee)),

        HasActivityInPeriod =
            CONVERT(bit, MAX(HasActivityInPeriod)),

        HasIssueInPeriod =
            CONVERT(bit, MAX(HasIssueInPeriod))
    FROM SeedRaw
    GROUP BY
        PeriodStart,
        PeriodEnd,
        EmpID
),
Emp AS
(
    SELECT
        e.PeriodStart,
        e.PeriodEnd,
        EmpID = e.EmpID,

        Employee_Name = COALESCE(be.FullName, e.Employee_Name, e.EmpID),

        Employee_FirstName = be.FirstName,
        Employee_LastName  = be.LastName,

        Employee_Name_Display =
            CONVERT(varchar(153),
                CASE
                    WHEN NULLIF(LTRIM(RTRIM(be.LastName)), '') IS NOT NULL
                     AND NULLIF(LTRIM(RTRIM(be.FirstName)), '') IS NOT NULL
                        THEN LTRIM(RTRIM(be.LastName)) + ', ' + LTRIM(RTRIM(be.FirstName))

                    WHEN NULLIF(LTRIM(RTRIM(be.LastName)), '') IS NOT NULL
                        THEN LTRIM(RTRIM(be.LastName))

                    WHEN NULLIF(LTRIM(RTRIM(be.FirstName)), '') IS NOT NULL
                        THEN LTRIM(RTRIM(be.FirstName))

                    ELSE COALESCE(e.Employee_Name, e.EmpID)
                END
            ),

        Employee_Name_Sort =
            CONVERT(varchar(153),
                CASE
                    WHEN NULLIF(LTRIM(RTRIM(be.LastName)), '') IS NOT NULL
                     AND NULLIF(LTRIM(RTRIM(be.FirstName)), '') IS NOT NULL
                        THEN LTRIM(RTRIM(be.LastName)) + ', ' + LTRIM(RTRIM(be.FirstName))

                    WHEN NULLIF(LTRIM(RTRIM(be.LastName)), '') IS NOT NULL
                        THEN LTRIM(RTRIM(be.LastName))

                    WHEN NULLIF(LTRIM(RTRIM(be.FirstName)), '') IS NOT NULL
                        THEN LTRIM(RTRIM(be.FirstName))

                    ELSE COALESCE(e.Employee_Name, e.EmpID)
                END
            ),

        -- Worklist inclusion flags for UI/filtering/debugging.
        e.IsActiveEmployee,
        e.HasActivityInPeriod,
        e.HasIssueInPeriod,

        WorklistSource =
            CONVERT(varchar(50),
                CASE
                    WHEN e.IsActiveEmployee = 1
                     AND e.HasActivityInPeriod = 1 THEN 'Active+Activity'

                    WHEN e.IsActiveEmployee = 1
                     AND e.HasIssueInPeriod = 1 THEN 'Active+Issue'

                    WHEN e.IsActiveEmployee = 1 THEN 'Active'

                    WHEN e.HasActivityInPeriod = 1
                     AND e.HasIssueInPeriod = 1 THEN 'Activity+Issue'

                    WHEN e.HasActivityInPeriod = 1 THEN 'Activity'

                    WHEN e.HasIssueInPeriod = 1 THEN 'Issue'

                    ELSE 'Unknown'
                END
            ),

        -- Employee master fields for browser filtering.
        be.Status_Code,
        be.EmploymentStatus,
        be.StartDate,
        be.RehireDate,
        be.TermDate,
        be.TermReason,

        be.InOffice,
        be.Is_OfficeStaff,

        be.EmpTypeId,
        be.EmployeeType,

        be.CompanyCode,
        be.YardCode,

        be.PayCycle,
        be.PayType,

        be.UnionCode,

        be.ClassCode,
        be.ClassDescription,

        be.LaborType,
        be.UseCertifiedPayroll,
        be.CertPay,
        be.Payroll_Classification,

        be.CraftCode,
        be.CraftDescription
    FROM EmpSeed e
    LEFT JOIN app.v_Base_Employees be
      ON be.EmpID = e.EmpID
),
Agg AS
(
    SELECT
        EmpID_Key,
        ErrorCount   = SUM(CASE WHEN Severity = 'Error'   THEN 1 ELSE 0 END),
        WarningCount = SUM(CASE WHEN Severity = 'Warning' THEN 1 ELSE 0 END),
        TotalIssues  = COUNT_BIG(*)
    FROM Issues
    GROUP BY EmpID_Key
)
SELECT
    pr.PayPeriodID,
    pr.PeriodStart,
    pr.PeriodEnd,

    emp.EmpID,
    emp.Employee_Name,

    -- Clean name fields for UI/API consumers.
    emp.Employee_FirstName,
    emp.Employee_LastName,
    emp.Employee_Name_Display,
    emp.Employee_Name_Sort,

    -- Worklist inclusion fields.
    emp.IsActiveEmployee,
    emp.HasActivityInPeriod,
    emp.HasIssueInPeriod,
    emp.WorklistSource,

    -- Employee master fields for browser filtering.
    emp.Status_Code,
    emp.EmploymentStatus,
    emp.StartDate,
    emp.RehireDate,
    emp.TermDate,
    emp.TermReason,

    emp.InOffice,
    emp.Is_OfficeStaff,

    emp.EmpTypeId,
    emp.EmployeeType,

    emp.CompanyCode,
    emp.YardCode,

    emp.PayCycle,
    emp.PayType,

    emp.UnionCode,

    emp.ClassCode,
    emp.ClassDescription,

    emp.LaborType,
    emp.UseCertifiedPayroll,
    emp.CertPay,
    emp.Payroll_Classification,

    emp.CraftCode,
    emp.CraftDescription,

    ErrorCount   = CONVERT(int, COALESCE(a.ErrorCount, 0)),
    WarningCount = CONVERT(int, COALESCE(a.WarningCount, 0)),
    TotalIssues  = CONVERT(int, COALESCE(a.TotalIssues, 0)),

    TopReasons =
        COALESCE(tr.TopReasons, ''),

    -- Note flags.
    pr.HasPayPeriodNote,

    HasNote_EmployeePayPeriod =
        CONVERT(bit, CASE
            WHEN pr.PayPeriodID IS NULL THEN 0
            WHEN EXISTS
            (
                SELECT 1
                FROM api.v_PayrollNotes_EmployeePayPeriod nepp
                WHERE nepp.PayPeriodID = pr.PayPeriodID
                  AND nepp.EmpID = emp.EmpID
                  AND nepp.IsLatest = 1
            ) THEN 1 ELSE 0 END),

    HasNote_EmployeeDayAny =
        CONVERT(bit, CASE
            WHEN pr.PayPeriodID IS NULL THEN 0
            WHEN EXISTS
            (
                SELECT 1
                FROM api.v_PayrollNotes_EmployeeDay ned
                WHERE ned.PayPeriodID = pr.PayPeriodID
                  AND ned.EmpID = emp.EmpID
            ) THEN 1 ELSE 0 END),

    HasNote_Any =
        CONVERT(bit, CASE
            WHEN pr.PayPeriodID IS NULL THEN 0

            WHEN pr.HasPayPeriodNote = 1 THEN 1

            WHEN EXISTS
            (
                SELECT 1
                FROM api.v_PayrollNotes_EmployeePayPeriod nepp
                WHERE nepp.PayPeriodID = pr.PayPeriodID
                  AND nepp.EmpID = emp.EmpID
            ) THEN 1

            WHEN EXISTS
            (
                SELECT 1
                FROM api.v_PayrollNotes_EmployeeDay ned
                WHERE ned.PayPeriodID = pr.PayPeriodID
                  AND ned.EmpID = emp.EmpID
            ) THEN 1

            ELSE 0
        END)
FROM Emp emp
CROSS JOIN PayPeriodRow pr
LEFT JOIN Agg a
    ON a.EmpID_Key = emp.EmpID
OUTER APPLY
(
    SELECT TopReasons =
        STUFF((
            SELECT '; ' + r.Reason + ' (' + CONVERT(varchar(20), r.Cnt) + ')'
            FROM
            (
                SELECT TOP (3)
                    i.Reason,
                    Cnt = COUNT_BIG(*)
                FROM Issues i
                WHERE i.EmpID_Key = emp.EmpID
                GROUP BY i.Reason
                ORDER BY COUNT_BIG(*) DESC, i.Reason
            ) r
            FOR XML PATH(''), TYPE
        ).value('.', 'nvarchar(max)'), 1, 2, '')
) tr;
