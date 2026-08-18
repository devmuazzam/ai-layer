
CREATE   VIEW api.v_UI_LaborEntry_TypeRateResolution
AS
WITH Base AS
(
    SELECT
        lp.LaborPayrollID,
        lp.JobTicketID,
        lp.JobCode,
        lp.WorkDate,
        lp.EmpID,
        lp.Employee_Name,

        -- Labor-entry values
        Labor_CraftCode = lp.CraftCode,
        Labor_CraftDescription = lp.CraftDescription,
        Labor_CraftPayRate = lp.CraftPayRate,
        Labor_CraftModifierCode = lp.CraftModifierCode,
        Labor_CraftModifierDescription = lp.CraftModifierDescription,
        Labor_CraftModifierPayRateAdjustment = lp.CraftModifierPayRateAdjustment,
        Labor_Source_Rate_Raw = lp.Source_Rate_Raw,
        Labor_Source_Amount_Raw = lp.Source_Amount_Raw,
        Labor_HoursWorked_Raw = lp.HoursWorked_Raw,
        Labor_UnionCode = lp.UnionCode,
        Labor_ClassCode = lp.ClassCode,
        Labor_ClassDescription = lp.ClassDescription,
        Labor_Type = lp.LaborType,

        -- Employee master values
        Employee_EmpID = e.EmpID,
        Employee_LName = e.LName,
        Employee_FName = e.FName,
        Employee_Name_FromMaster =
            LTRIM(RTRIM(CONCAT(ISNULL(e.FName, ''), ' ', ISNULL(e.LName, '')))),
        Employee_PayType = e.PayType,
        Employee_UnionCode = e.UnionCode,
        Employee_CraftCode = e.CraftCode,
        Employee_CraftDescription = ec.Description,
        Employee_PayRate = e.PayRate,
        Employee_InOffice = e.InOffice,
        Employee_EmpTypeId = e.EmpTypeId,
        Employee_EmpTypeDescription = et.Description,
        Employee_BurdenCode = e.BurdenCode,
        Employee_WorkerCompCode = e.WorkerCompCode,
        Employee_ClassCode = e.ClassCode,

        Employee_CraftBaseRate = euc.PayRate
    FROM app.v_Base_LaborPayroll lp
    LEFT JOIN src.FMS_EMPLOYEES_Raw e
        ON e.EmpID = lp.EmpID
    LEFT JOIN src.FMS_EMPLOYEE_TYPES_Raw et
        ON et.EmpTypeId = e.EmpTypeId
    LEFT JOIN src.FMS_CRAFTS_Raw ec
        ON ec.CraftCode = e.CraftCode
    LEFT JOIN src.FMS_UNION_CRAFT_Raw euc
        ON euc.CraftCode = e.CraftCode
       AND (
            euc.UnionCode = e.UnionCode
            OR e.UnionCode IS NULL
            OR euc.UnionCode = 'L12'
       )
),
Resolved AS
(
    SELECT
        b.*,

        LaborEntryEmployeeType =
            CASE
                WHEN b.Employee_CraftCode LIKE 'SYS%'
                  OR b.Labor_CraftCode LIKE 'SYS%'
                    THEN 'System-Testing-VendorAccess'

                WHEN b.Labor_CraftCode LIKE 'L12%' AND ISNULL(b.Employee_EmpTypeId, -1) = 3
                    THEN 'L12 Labor Union Mechanic'

                WHEN b.Labor_CraftCode LIKE 'L12%' AND ISNULL(b.Employee_EmpTypeId, -1) <> 3
                    THEN 'L12 Labor Union Field'

                WHEN b.Labor_CraftCode LIKE 'ADMIN%' AND b.Employee_PayType = 'H'
                    THEN 'Non-Union Admin Hourly'

                WHEN b.Labor_CraftCode LIKE 'ADMIN%' AND b.Employee_PayType = 'S'
                    THEN 'Non-Union Admin Salary'

                WHEN b.Labor_CraftCode LIKE 'ADMIN%'
                    THEN 'Non-Union Admin - Unknown PayType'

                ELSE 'Unknown / Needs Review'
            END,

        LaborEntryEmployeeTypeSort =
            CASE
                WHEN b.Labor_CraftCode LIKE 'L12%' AND ISNULL(b.Employee_EmpTypeId, -1) <> 3 THEN 10
                WHEN b.Labor_CraftCode LIKE 'L12%' AND ISNULL(b.Employee_EmpTypeId, -1) = 3 THEN 20
                WHEN b.Labor_CraftCode LIKE 'ADMIN%' AND b.Employee_PayType = 'H' THEN 30
                WHEN b.Labor_CraftCode LIKE 'ADMIN%' AND b.Employee_PayType = 'S' THEN 40
                WHEN b.Employee_CraftCode LIKE 'SYS%' OR b.Labor_CraftCode LIKE 'SYS%' THEN 90
                ELSE 99
            END,

        ResolvedBaseRate =
            CAST(
                CASE
                    WHEN b.Labor_CraftCode LIKE 'L12%' THEN b.Labor_CraftPayRate
                    WHEN b.Labor_CraftCode LIKE 'ADMIN%' THEN b.Employee_PayRate
                    WHEN b.Employee_CraftCode LIKE 'SYS%' OR b.Labor_CraftCode LIKE 'SYS%' THEN 0.00
                    ELSE NULL
                END
            AS decimal(12,4)),

        ResolvedBaseRateSource =
            CASE
                WHEN b.Labor_CraftCode LIKE 'L12%' THEN 'Labor.CraftCode -> UNION_CRAFT.PayRate'
                WHEN b.Labor_CraftCode LIKE 'ADMIN%' THEN 'Employee.PayRate'
                WHEN b.Employee_CraftCode LIKE 'SYS%' OR b.Labor_CraftCode LIKE 'SYS%' THEN 'System access / non-payroll'
                ELSE 'Unknown / Needs Review'
            END,

        ResolvedModifierRate =
            CAST(
                CASE
                    WHEN b.Labor_CraftCode LIKE 'L12%'
                        THEN ISNULL(b.Labor_CraftModifierPayRateAdjustment, 0.00)
                    ELSE 0.00
                END
            AS decimal(12,4)),

        ResolvedModifierRateSource =
            CASE
                WHEN b.Labor_CraftCode LIKE 'L12%' AND b.Labor_CraftModifierCode IS NOT NULL
                    THEN 'Labor.CraftModifierCode -> UNION_CRAFT_MODIFIER.PayRateChange'
                WHEN b.Labor_CraftCode LIKE 'L12%'
                    THEN 'No labor craft modifier'
                WHEN b.Labor_CraftCode LIKE 'ADMIN%'
                    THEN 'Not applicable to non-union admin'
                WHEN b.Employee_CraftCode LIKE 'SYS%' OR b.Labor_CraftCode LIKE 'SYS%'
                    THEN 'System access / non-payroll'
                ELSE 'Unknown / Needs Review'
            END
    FROM Base b
)
SELECT
    r.*,

    ResolvedCombinedRate =
        CAST(ISNULL(r.ResolvedBaseRate, 0) + ISNULL(r.ResolvedModifierRate, 0) AS decimal(12,4)),

    SourceRateLooksLikeResolvedBase =
        CAST(
            CASE
                WHEN r.Labor_Source_Rate_Raw IS NOT NULL
                 AND r.ResolvedBaseRate IS NOT NULL
                 AND ABS(r.Labor_Source_Rate_Raw - r.ResolvedBaseRate) <= 0.01
                THEN 1 ELSE 0
            END
        AS bit),

    SourceRateLooksLikeBasePlusModifier =
        CAST(
            CASE
                WHEN r.Labor_Source_Rate_Raw IS NOT NULL
                 AND r.ResolvedBaseRate IS NOT NULL
                 AND ABS(r.Labor_Source_Rate_Raw - (ISNULL(r.ResolvedBaseRate, 0) + ISNULL(r.ResolvedModifierRate, 0))) <= 0.01
                 AND ISNULL(r.ResolvedModifierRate, 0) <> 0
                THEN 1 ELSE 0
            END
        AS bit),

    SourceRateDifferenceFromResolvedBase =
        CAST(
            CASE
                WHEN r.Labor_Source_Rate_Raw IS NOT NULL
                 AND r.ResolvedBaseRate IS NOT NULL
                THEN r.Labor_Source_Rate_Raw - r.ResolvedBaseRate
                ELSE NULL
            END
        AS decimal(12,4)),

    SourceRateDifferenceFromResolvedCombined =
        CAST(
            CASE
                WHEN r.Labor_Source_Rate_Raw IS NOT NULL
                 AND r.ResolvedBaseRate IS NOT NULL
                THEN r.Labor_Source_Rate_Raw - (ISNULL(r.ResolvedBaseRate, 0) + ISNULL(r.ResolvedModifierRate, 0))
                ELSE NULL
            END
        AS decimal(12,4)),

    CraftCodeMismatchFlag =
        CAST(
            CASE
                WHEN ISNULL(r.Employee_CraftCode, '') <> ''
                 AND ISNULL(r.Labor_CraftCode, '') <> ''
                 AND r.Employee_CraftCode <> r.Labor_CraftCode
                THEN 1 ELSE 0
            END
        AS bit),

    CraftCodeMismatchMessage =
        CASE
            WHEN ISNULL(r.Employee_CraftCode, '') <> ''
             AND ISNULL(r.Labor_CraftCode, '') <> ''
             AND r.Employee_CraftCode <> r.Labor_CraftCode
            THEN CONCAT('Employee craft ', r.Employee_CraftCode, ' differs from labor-entry craft ', r.Labor_CraftCode, '.')
            ELSE NULL
        END,

    RateResolutionReviewFlag =
        CAST(
            CASE
                WHEN r.Employee_CraftCode LIKE 'SYS%' OR r.Labor_CraftCode LIKE 'SYS%' THEN 0

                WHEN r.Labor_CraftCode LIKE 'L12%' AND r.ResolvedBaseRate IS NULL THEN 1

                WHEN r.Labor_CraftCode LIKE 'ADMIN%' AND r.Employee_PayRate IS NULL THEN 1
                WHEN r.Labor_CraftCode LIKE 'ADMIN%' AND r.Employee_PayType NOT IN ('H', 'S') THEN 1

                WHEN r.Labor_CraftCode IS NULL THEN 1
                WHEN r.LaborEntryEmployeeType = 'Unknown / Needs Review' THEN 1

                ELSE 0
            END
        AS bit),

    RateResolutionReviewMessage =
        CASE
            WHEN r.Employee_CraftCode LIKE 'SYS%' OR r.Labor_CraftCode LIKE 'SYS%' THEN NULL

            WHEN r.Labor_CraftCode LIKE 'L12%' AND r.ResolvedBaseRate IS NULL
                THEN 'L12 labor-entry craft code did not resolve to UNION_CRAFT.PayRate.'

            WHEN r.Labor_CraftCode LIKE 'ADMIN%' AND r.Employee_PayRate IS NULL
                THEN 'ADMIN labor entry could not resolve Employee.PayRate.'

            WHEN r.Labor_CraftCode LIKE 'ADMIN%' AND r.Employee_PayType NOT IN ('H', 'S')
                THEN 'ADMIN labor entry has unknown/nonstandard employee PayType.'

            WHEN r.Labor_CraftCode IS NULL
                THEN 'Labor entry CraftCode is missing.'

            WHEN r.LaborEntryEmployeeType = 'Unknown / Needs Review'
                THEN 'Labor entry CraftCode does not match configured Payroll App labor-entry employee-type patterns.'

            ELSE NULL
        END
FROM Resolved r;
