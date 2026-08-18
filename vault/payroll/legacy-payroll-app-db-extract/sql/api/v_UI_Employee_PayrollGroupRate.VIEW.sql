
CREATE   VIEW api.v_UI_Employee_PayrollGroupRate
AS
WITH Base AS
(
    SELECT
        v.*,
        IsDefaultPlaceholder =
            CAST(
                CASE
                    WHEN UPPER(LTRIM(RTRIM(v.EmpID))) IN ('DFLT', 'DEFAULT') THEN 1
                    WHEN UPPER(LTRIM(RTRIM(ISNULL(v.FName, '')))) = 'DEFAULT'
                     AND UPPER(LTRIM(RTRIM(ISNULL(v.LName, '')))) = 'EMPLOYEE'
                        THEN 1
                    ELSE 0
                END
            AS bit),
        ADP_FileNumber_Clean_Base =
            UPPER(NULLIF(LTRIM(RTRIM(v.ADP_FileNumber)), ''))
    FROM api.v_UI_Employee_TypeRate v
),
Normalized AS
(
    SELECT
        -- FCC employee fields
        EmpID,
        LName,
        FName,
        MName,
        Employee_Name,
        CertPay,
        Phone,
        Mobile,
        Pager,
        CompanyCode,
        YardCode,
        Email,
        PayCycle,
        PayType,
        UnionCode,
        CraftCode,
        PayRate,
        StartDate,
        RehireDate,
        TermDate,
        Status,
        TermReason,
        InOffice,
        Supervisor,
        EmpTypeId,
        EmployeeTypeSourceDescription,
        BurdenCode,
        WorkerCompCode,
        ClassCode,
        BirthDate,
        Comments,

        -- ADP mapping
        ADP_FileNumber,

        -- Employee craft/rate fields
        EmployeeCraftDescription,
        EmployeeCraftBaseRate,

        -- Legacy/base classification names retained for compatibility
        PayrollEmployeeType =
            CASE
                WHEN IsDefaultPlaceholder = 1
                    THEN 'System-Testing-VendorAccess'
                ELSE PayrollEmployeeType
            END,

        PayrollEmployeeTypeSort =
            CASE
                WHEN IsDefaultPlaceholder = 1
                    THEN 90
                ELSE PayrollEmployeeTypeSort
            END,

        BaseHourlyRate =
            CASE
                WHEN IsDefaultPlaceholder = 1
                    THEN CAST(NULL AS decimal(12,4))
                ELSE BaseHourlyRate
            END,

        BaseHourlyRateSource =
            CASE
                WHEN IsDefaultPlaceholder = 1
                    THEN 'System/default placeholder / non-payroll'
                ELSE BaseHourlyRateSource
            END,

        ApproxWeekly =
            CASE
                WHEN IsDefaultPlaceholder = 1
                    THEN CAST(NULL AS decimal(12,2))
                ELSE ApproxWeekly
            END,

        ApproxMonthly =
            CASE
                WHEN IsDefaultPlaceholder = 1
                    THEN CAST(NULL AS decimal(12,2))
                ELSE ApproxMonthly
            END,

        ApproxAnnual =
            CASE
                WHEN IsDefaultPlaceholder = 1
                    THEN CAST(NULL AS decimal(12,2))
                ELSE ApproxAnnual
            END,

        IsSystemTestingVendorAccess =
            CAST(
                CASE
                    WHEN IsDefaultPlaceholder = 1 THEN 1
                    ELSE ISNULL(IsSystemTestingVendorAccess, 0)
                END
            AS bit),

        IsVisibleInPayrollUI =
            CAST(
                CASE
                    WHEN IsDefaultPlaceholder = 1 THEN 0
                    ELSE ISNULL(IsVisibleInPayrollUI, 1)
                END
            AS bit),

        EmployeeTypeReviewFlag =
            CAST(
                CASE
                    WHEN IsDefaultPlaceholder = 1 THEN 0
                    ELSE ISNULL(EmployeeTypeReviewFlag, 0)
                END
            AS bit),

        EmployeeTypeReviewMessage =
            CASE
                WHEN IsDefaultPlaceholder = 1 THEN NULL
                ELSE EmployeeTypeReviewMessage
            END,

        ADP_FileNumber_Clean =
            ADP_FileNumber_Clean_Base
    FROM Base
)
SELECT
    n.*,

    PayrollGroup =
        n.PayrollEmployeeType,

    PayrollGroupSort =
        n.PayrollEmployeeTypeSort,

    PayrollGroupReviewFlag =
        n.EmployeeTypeReviewFlag,

    PayrollGroupReviewMessage =
        CASE
            WHEN n.EmployeeTypeReviewMessage IS NULL THEN NULL
            ELSE REPLACE(n.EmployeeTypeReviewMessage, 'employee-type', 'Payroll Group')
        END,

    ADP_FileNumberMissingFlag =
        CAST(
            CASE
                WHEN ISNULL(n.IsVisibleInPayrollUI, 0) = 1
                 AND n.ADP_FileNumber_Clean IS NULL
                    THEN 1
                ELSE 0
            END
        AS bit),

    ADP_FileNumberInvalidFlag =
        CAST(
            CASE
                WHEN n.ADP_FileNumber_Clean IS NULL THEN 0
                WHEN LEN(n.ADP_FileNumber_Clean) NOT BETWEEN 1 AND 6 THEN 1
                WHEN n.ADP_FileNumber_Clean COLLATE Latin1_General_BIN2
                        LIKE '%[^0-9A-Z]%' THEN 1
                ELSE 0
            END
        AS bit),

    ADP_FileNumberReviewFlag =
        CAST(
            CASE
                WHEN ISNULL(n.IsVisibleInPayrollUI, 0) = 1
                 AND (
                        n.ADP_FileNumber_Clean IS NULL
                        OR LEN(n.ADP_FileNumber_Clean) NOT BETWEEN 1 AND 6
                        OR n.ADP_FileNumber_Clean COLLATE Latin1_General_BIN2
                            LIKE '%[^0-9A-Z]%'
                     )
                    THEN 1
                ELSE 0
            END
        AS bit),

    ADP_FileNumberReviewMessage =
        CASE
            WHEN ISNULL(n.IsVisibleInPayrollUI, 0) = 0 THEN NULL

            WHEN n.ADP_FileNumber_Clean IS NULL
                THEN 'ADP File Number is missing.'

            WHEN LEN(n.ADP_FileNumber_Clean) NOT BETWEEN 1 AND 6
                THEN 'ADP File Number must be 1 to 6 uppercase alphanumeric characters.'

            WHEN n.ADP_FileNumber_Clean COLLATE Latin1_General_BIN2
                    LIKE '%[^0-9A-Z]%'
                THEN 'ADP File Number must contain only uppercase letters and numbers.'

            ELSE NULL
        END
FROM Normalized n;
