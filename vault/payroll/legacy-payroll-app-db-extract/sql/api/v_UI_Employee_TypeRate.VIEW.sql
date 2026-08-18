
CREATE   VIEW api.v_UI_Employee_TypeRate
AS
SELECT
    -- FCC employee fields
    e.EmpID,
    e.LName,
    e.FName,
    e.MName,
    Employee_Name =
        LTRIM(RTRIM(CONCAT(ISNULL(e.FName, ''), ' ', ISNULL(e.LName, '')))),

    e.CertPay,
    e.Phone,
    e.Mobile,
    e.Pager,
    e.CompanyCode,
    e.YardCode,
    e.Email,
    e.PayCycle,
    e.PayType,
    e.UnionCode,
    e.CraftCode,
    e.PayRate,
    e.StartDate,
    e.RehireDate,
    e.TermDate,
    e.Status,
    e.TermReason,
    e.InOffice,
    e.Supervisor,
    e.EmpTypeId,
    EmployeeTypeSourceDescription = et.Description,
    e.BurdenCode,
    e.WorkerCompCode,
    e.ClassCode,
    e.BirthDate,
    e.Comments,

    -- ADP mapping
    ADP_FileNumber = adp.ExternalIdentifierValue,

    -- Employee craft description from FMS_CRAFTS
    EmployeeCraftDescription = craft.Description,

    -- Employee craft base rate from UNION_CRAFT
    EmployeeCraftBaseRate = uc.PayRate,

    -- Payroll App derived employee type
    PayrollEmployeeType =
        CASE
            WHEN e.CraftCode LIKE 'SYS%' THEN 'System-Testing-VendorAccess'

            WHEN e.CraftCode LIKE 'L12%' AND ISNULL(e.EmpTypeId, -1) = 3
                THEN 'L12 Labor Union Mechanic'

            WHEN e.CraftCode LIKE 'L12%' AND ISNULL(e.EmpTypeId, -1) <> 3
                THEN 'L12 Labor Union Field'

            WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayType = 'H'
                THEN 'Non-Union Admin Hourly'

            WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayType = 'S'
                THEN 'Non-Union Admin Salary'

            WHEN e.CraftCode LIKE 'ADMIN%'
                THEN 'Non-Union Admin - Unknown PayType'

            ELSE 'Unknown / Needs Review'
        END,

    PayrollEmployeeTypeSort =
        CASE
            WHEN e.CraftCode LIKE 'L12%' AND ISNULL(e.EmpTypeId, -1) <> 3 THEN 10
            WHEN e.CraftCode LIKE 'L12%' AND ISNULL(e.EmpTypeId, -1) = 3 THEN 20
            WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayType = 'H' THEN 30
            WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayType = 'S' THEN 40
            WHEN e.CraftCode LIKE 'SYS%' THEN 90
            ELSE 99
        END,

    BaseHourlyRate =
        CAST(
            CASE
                WHEN e.CraftCode LIKE 'L12%' THEN uc.PayRate
                WHEN e.CraftCode LIKE 'ADMIN%' THEN e.PayRate
                WHEN e.CraftCode LIKE 'SYS%' THEN 0.00
                ELSE NULL
            END
        AS decimal(12,4)),

    BaseHourlyRateSource =
        CASE
            WHEN e.CraftCode LIKE 'L12%' THEN 'Employee.CraftCode -> UNION_CRAFT.PayRate'
            WHEN e.CraftCode LIKE 'ADMIN%' THEN 'Employee.PayRate'
            WHEN e.CraftCode LIKE 'SYS%' THEN 'System access / non-payroll'
            ELSE 'Unknown / Needs Review'
        END,

    ApproxWeekly =
        CAST(
            CASE
                WHEN e.CraftCode LIKE 'L12%' AND uc.PayRate IS NOT NULL
                    THEN uc.PayRate * 40.0
                WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayRate IS NOT NULL
                    THEN e.PayRate * 40.0
                ELSE NULL
            END
        AS decimal(12,2)),

    ApproxMonthly =
        CAST(
            CASE
                WHEN e.CraftCode LIKE 'L12%' AND uc.PayRate IS NOT NULL
                    THEN uc.PayRate * 2080.0 / 12.0
                WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayRate IS NOT NULL
                    THEN e.PayRate * 2080.0 / 12.0
                ELSE NULL
            END
        AS decimal(12,2)),

    ApproxAnnual =
        CAST(
            CASE
                WHEN e.CraftCode LIKE 'L12%' AND uc.PayRate IS NOT NULL
                    THEN uc.PayRate * 2080.0
                WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayRate IS NOT NULL
                    THEN e.PayRate * 2080.0
                ELSE NULL
            END
        AS decimal(12,2)),

    IsSystemTestingVendorAccess =
        CAST(CASE WHEN e.CraftCode LIKE 'SYS%' THEN 1 ELSE 0 END AS bit),

    IsVisibleInPayrollUI =
        CAST(CASE WHEN e.CraftCode LIKE 'SYS%' THEN 0 ELSE 1 END AS bit),

    EmployeeTypeReviewFlag =
        CAST(
            CASE
                WHEN e.CraftCode LIKE 'SYS%' THEN 0
                WHEN e.CraftCode LIKE 'L12%' AND uc.PayRate IS NOT NULL THEN 0
                WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayRate IS NOT NULL AND e.PayType IN ('H', 'S') THEN 0
                ELSE 1
            END
        AS bit),

    EmployeeTypeReviewMessage =
        CASE
            WHEN e.CraftCode LIKE 'SYS%' THEN NULL

            WHEN e.CraftCode LIKE 'L12%' AND uc.PayRate IS NULL
                THEN 'L12 employee craft code did not resolve to UNION_CRAFT.PayRate.'

            WHEN e.CraftCode LIKE 'L12%' THEN NULL

            WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayType NOT IN ('H', 'S')
                THEN 'ADMIN employee has unknown/nonstandard PayType.'

            WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayRate IS NULL
                THEN 'ADMIN employee is missing Employee.PayRate.'

            WHEN e.CraftCode LIKE 'ADMIN%' THEN NULL

            ELSE 'Employee CraftCode does not match configured Payroll App employee-type patterns.'
        END
FROM src.FMS_EMPLOYEES_Raw e

LEFT JOIN src.FMS_CRAFTS_Raw craft
    ON craft.CraftCode = e.CraftCode

LEFT JOIN src.FMS_UNION_CRAFT_Raw uc
    ON uc.CraftCode = e.CraftCode
   AND (
        uc.UnionCode = e.UnionCode
        OR e.UnionCode IS NULL
        OR uc.UnionCode = 'L12'
   )

LEFT JOIN src.FMS_EMPLOYEE_TYPES_Raw et
    ON et.EmpTypeId = e.EmpTypeId

LEFT JOIN app.EmployeeExternalIdentifier adp
    ON adp.EmpID = e.EmpID
   AND adp.ExternalSystemCode = 'ADP'
   AND adp.ExternalIdentifierName = 'FILE_NUMBER'
   AND adp.IsActive = 1;
