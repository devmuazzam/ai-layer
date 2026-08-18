
CREATE   VIEW api.v_UI_LaborEntry_RateSourceReview
AS
WITH Base AS
(
    SELECT
        b.LaborPayrollID,
        b.EmpID,
        b.Employee_Name,
        b.WorkDate,
        b.JobTicketID,
        b.JobCode,
        b.WoCode,
        b.UnionCode,
        b.CraftCode,
        b.CraftDescription,

        Source_Rate_Raw =
            CONVERT(decimal(12,3), b.Source_Rate_Raw),

        CraftPayRate =
            CONVERT(decimal(12,3), b.CraftPayRate),

        EmployeePayRate =
            CONVERT(decimal(12,3), e.PayRate),

        Source_Amount_Raw =
            CONVERT(decimal(12,3), b.Source_Amount_Raw),

        HoursWorked_Raw =
            CONVERT(decimal(12,3), b.HoursWorked_Raw),

        SourceAmount_ImpliedRate =
            CASE
                WHEN ISNULL(b.Source_Amount_Raw, 0) > 0
                 AND ISNULL(b.HoursWorked_Raw, 0) > 0
                THEN CONVERT(decimal(12,3), b.Source_Amount_Raw / NULLIF(b.HoursWorked_Raw, 0))
                ELSE NULL
            END,

        pc.Act_Total_Hrs,
        pc.Hrs_ST,
        pc.Hrs_OT,
        pc.Hrs_DT,
        pc.Pay_Actual_Gross,
        pc.Pay_Gap_Add,
        pc.Pay_Rest_Add,
        pc.Final_Gross_Pay

    FROM app.v_Base_LaborPayroll b
    LEFT JOIN src.FMS_EMPLOYEES_Raw e
        ON CONVERT(varchar(50), e.EmpID) = CONVERT(varchar(50), b.EmpID)
    LEFT JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = b.LaborPayrollID
),
Calc AS
(
    SELECT
        *,

        HasSourceRate =
            CONVERT(bit,
                CASE
                    WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(Source_Rate_Raw, 0)), 0) IS NOT NULL
                    THEN 1 ELSE 0
                END
            ),

        HasCraftPayRate =
            CONVERT(bit,
                CASE
                    WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(CraftPayRate, 0)), 0) IS NOT NULL
                    THEN 1 ELSE 0
                END
            ),

        HasEmployeePayRate =
            CONVERT(bit,
                CASE
                    WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(EmployeePayRate, 0)), 0) IS NOT NULL
                    THEN 1 ELSE 0
                END
            ),

        HasImpliedSourceAmountRate =
            CONVERT(bit,
                CASE
                    WHEN SourceAmount_ImpliedRate IS NOT NULL
                    THEN 1 ELSE 0
                END
            ),

        Rate_Used_SourceOnly =
            CASE
                WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(Source_Rate_Raw, 0)), 0) IS NOT NULL
                THEN CONVERT(decimal(12,3), Source_Rate_Raw)
                ELSE CONVERT(decimal(12,3), 0.000)
            END,

        Rate_Used_SourceOnly_Source_Code =
            CASE
                WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(Source_Rate_Raw, 0)), 0) IS NOT NULL
                    THEN 'SOURCE_RATE_RAW'
                ELSE 'NO_SOURCE_RATE'
            END,

        Rate_Used_SourceOnly_Source_Label =
            CASE
                WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(Source_Rate_Raw, 0)), 0) IS NOT NULL
                    THEN 'FMS labor payroll source rate'
                ELSE 'No FMS labor payroll source rate'
            END,

        CraftVsSource_Difference =
            CASE
                WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(Source_Rate_Raw, 0)), 0) IS NOT NULL
                 AND NULLIF(CONVERT(decimal(19,6), ISNULL(CraftPayRate, 0)), 0) IS NOT NULL
                THEN CONVERT(decimal(12,3), CraftPayRate - Source_Rate_Raw)
                ELSE NULL
            END,

        CraftVsSource_PctDifference =
            CASE
                WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(Source_Rate_Raw, 0)), 0) IS NOT NULL
                 AND NULLIF(CONVERT(decimal(19,6), ISNULL(CraftPayRate, 0)), 0) IS NOT NULL
                THEN CONVERT(decimal(12,4),
                    ABS(CONVERT(decimal(19,6), CraftPayRate) - CONVERT(decimal(19,6), Source_Rate_Raw))
                    / NULLIF(ABS(CONVERT(decimal(19,6), Source_Rate_Raw)), 0)
                )
                ELSE NULL
            END,

        SourceRate_Outlier_Code =
            CASE
                WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(Source_Rate_Raw, 0)), 0) IS NULL
                    THEN 'MISSING_SOURCE_RATE'
                WHEN Source_Rate_Raw < 10.000
                    THEN 'SOURCE_RATE_BELOW_10'
                WHEN Source_Rate_Raw > 200.000
                    THEN 'SOURCE_RATE_ABOVE_200'
                ELSE 'SOURCE_RATE_IN_RANGE'
            END

    FROM Base
)
SELECT
    LaborPayrollID,
    EmpID,
    Employee_Name,
    WorkDate,
    JobTicketID,
    JobCode,
    WoCode,
    UnionCode,
    CraftCode,
    CraftDescription,

    /* Proposed calculation rate */
    Rate_Used_SourceOnly,
    Rate_Used_SourceOnly_Source_Code,
    Rate_Used_SourceOnly_Source_Label,

    /* All available comparison rates */
    Source_Rate_Raw,
    CraftPayRate,
    EmployeePayRate,
    Source_Amount_Raw,
    HoursWorked_Raw,
    SourceAmount_ImpliedRate,

    HasSourceRate,
    HasCraftPayRate,
    HasEmployeePayRate,
    HasImpliedSourceAmountRate,

    CraftVsSource_Difference,
    CraftVsSource_PctDifference,

    Warn_SourceRateMissing =
        CONVERT(bit,
            CASE WHEN HasSourceRate = 0 THEN 1 ELSE 0 END
        ),

    Warn_CraftVsSource_10Pct =
        CONVERT(bit,
            CASE
                WHEN CraftVsSource_PctDifference >= 0.1000
                THEN 1 ELSE 0
            END
        ),

    Warn_SourceRate_Outlier =
        CONVERT(bit,
            CASE
                WHEN SourceRate_Outlier_Code IN ('SOURCE_RATE_BELOW_10', 'SOURCE_RATE_ABOVE_200')
                THEN 1 ELSE 0
            END
        ),

    SourceRate_Outlier_Code,

    RateReview_Severity =
        CASE
            WHEN HasSourceRate = 0
                THEN 'Warning'
            WHEN CraftVsSource_PctDifference >= 0.1000
                THEN 'Warning'
            WHEN SourceRate_Outlier_Code IN ('SOURCE_RATE_BELOW_10', 'SOURCE_RATE_ABOVE_200')
                THEN 'Warning'
            ELSE 'OK'
        END,

    RateReview_Title =
        CASE
            WHEN HasSourceRate = 0
                THEN 'FMS labor payroll source rate missing'
            WHEN CraftVsSource_PctDifference >= 0.1000
                THEN 'Craft rate differs from source rate'
            WHEN SourceRate_Outlier_Code = 'SOURCE_RATE_BELOW_10'
                THEN 'Source rate looks unusually low'
            WHEN SourceRate_Outlier_Code = 'SOURCE_RATE_ABOVE_200'
                THEN 'Source rate looks unusually high'
            ELSE 'Rate source OK'
        END,

    RateReview_Detail =
        CASE
            WHEN HasSourceRate = 0
                THEN CONCAT(
                    'No Source_Rate_Raw exists on the FMS labor payroll row. ',
                    'Comparison rates available: CraftPayRate=',
                    COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), CraftPayRate)), 'NULL'),
                    ', EmployeePayRate=',
                    COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), EmployeePayRate)), 'NULL'),
                    ', ImpliedAmountRate=',
                    COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), SourceAmount_ImpliedRate)), 'NULL'),
                    '.'
                )

            WHEN CraftVsSource_PctDifference >= 0.1000
                THEN CONCAT(
                    'CraftPayRate differs from Source_Rate_Raw by ',
                    CONVERT(varchar(30), CONVERT(decimal(12,2), CraftVsSource_PctDifference * 100.0)),
                    '%. Source_Rate_Raw=',
                    CONVERT(varchar(30), CONVERT(decimal(12,2), Source_Rate_Raw)),
                    ', CraftPayRate=',
                    CONVERT(varchar(30), CONVERT(decimal(12,2), CraftPayRate)),
                    '.'
                )

            WHEN SourceRate_Outlier_Code = 'SOURCE_RATE_BELOW_10'
                THEN CONCAT(
                    'Source_Rate_Raw is below 10.00. Source_Rate_Raw=',
                    CONVERT(varchar(30), CONVERT(decimal(12,2), Source_Rate_Raw)),
                    '. Review before relying on source-only calculation.'
                )

            WHEN SourceRate_Outlier_Code = 'SOURCE_RATE_ABOVE_200'
                THEN CONCAT(
                    'Source_Rate_Raw is above 200.00. Source_Rate_Raw=',
                    CONVERT(varchar(30), CONVERT(decimal(12,2), Source_Rate_Raw)),
                    '. Review before relying on source-only calculation.'
                )

            ELSE 'Source_Rate_Raw is available and no major comparison warning was detected.'
        END,

    Rate_Display_SourceOnly =
        CONCAT(
            CONVERT(varchar(30), CONVERT(decimal(12,2), Rate_Used_SourceOnly)),
            ' - ',
            Rate_Used_SourceOnly_Source_Label
        ),

    Rate_Display_AllSources =
        CONCAT(
            'Source ',
            COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), Source_Rate_Raw)), 'NULL'),
            ' | Craft ',
            COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), CraftPayRate)), 'NULL'),
            ' | Employee ',
            COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), EmployeePayRate)), 'NULL'),
            ' | Amount/Hrs ',
            COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), SourceAmount_ImpliedRate)), 'NULL')
        ),

    Act_Total_Hrs,
    Hrs_ST,
    Hrs_OT,
    Hrs_DT,
    Pay_Actual_Gross,
    Pay_Gap_Add,
    Pay_Rest_Add,
    Final_Gross_Pay

FROM Calc;
