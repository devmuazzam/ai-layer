
/* ============================================================
   51K-F - Clean up source-rate issue title priority
   Purpose:
   - In api.v_UI_Payroll_RateResolution_Issues, prioritize:
       1) missing source rate
       2) unusually high source rate
       3) unusually low source rate
       4) craft/source differs by 10%+
   - Does not change calculations.
   ============================================================ */

CREATE   VIEW api.v_UI_Payroll_RateResolution_Issues
AS
SELECT
    LaborPayrollID,
    EmpID,
    Employee_Name,
    WorkDate,
    JobTicketID,
    JobCode,
    CraftCode,

    IssueCode =
        CASE
            WHEN Warn_SourceRateMissing = 1
                THEN 'Warn_SourceRate_Missing'
            WHEN Warn_SourceRate_Outlier = 1 AND SourceRate_Outlier_Code = 'SOURCE_RATE_ABOVE_200'
                THEN 'Warn_SourceRate_UnusuallyHigh'
            WHEN Warn_SourceRate_Outlier = 1 AND SourceRate_Outlier_Code = 'SOURCE_RATE_BELOW_10'
                THEN 'Warn_SourceRate_UnusuallyLow'
            WHEN Warn_CraftVsSource_10Pct = 1
                THEN 'Warn_CraftRate_SourceRate_Diff10Pct'
            ELSE NULL
        END,

    Severity = 'Warning',

    FriendlyTitle =
        CASE
            WHEN Warn_SourceRateMissing = 1
                THEN 'FMS labor payroll source rate missing'
            WHEN Warn_SourceRate_Outlier = 1 AND SourceRate_Outlier_Code = 'SOURCE_RATE_ABOVE_200'
                THEN 'Source rate looks unusually high'
            WHEN Warn_SourceRate_Outlier = 1 AND SourceRate_Outlier_Code = 'SOURCE_RATE_BELOW_10'
                THEN 'Source rate looks unusually low'
            WHEN Warn_CraftVsSource_10Pct = 1
                THEN 'Craft rate differs from source rate'
            ELSE RateReview_Title
        END,

    FriendlyDetail =
        CASE
            WHEN Warn_SourceRateMissing = 1
                THEN RateReview_Detail

            WHEN Warn_SourceRate_Outlier = 1 AND SourceRate_Outlier_Code = 'SOURCE_RATE_ABOVE_200'
                THEN CONCAT(
                    'Source_Rate_Raw is above 200.00. Source_Rate_Raw=',
                    CONVERT(varchar(30), CONVERT(decimal(12,2), Source_Rate_Raw)),
                    '. Comparison rates: CraftPayRate=',
                    COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), CraftPayRate)), 'NULL'),
                    ', EmployeePayRate=',
                    COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), EmployeePayRate)), 'NULL'),
                    ', ImpliedAmountRate=',
                    COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), SourceAmount_ImpliedRate)), 'NULL'),
                    '.'
                )

            WHEN Warn_SourceRate_Outlier = 1 AND SourceRate_Outlier_Code = 'SOURCE_RATE_BELOW_10'
                THEN CONCAT(
                    'Source_Rate_Raw is below 10.00. Source_Rate_Raw=',
                    CONVERT(varchar(30), CONVERT(decimal(12,2), Source_Rate_Raw)),
                    '. Comparison rates: CraftPayRate=',
                    COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), CraftPayRate)), 'NULL'),
                    ', EmployeePayRate=',
                    COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), EmployeePayRate)), 'NULL'),
                    ', ImpliedAmountRate=',
                    COALESCE(CONVERT(varchar(30), CONVERT(decimal(12,2), SourceAmount_ImpliedRate)), 'NULL'),
                    '.'
                )

            WHEN Warn_CraftVsSource_10Pct = 1
                THEN RateReview_Detail

            ELSE RateReview_Detail
        END,

    Rate_Base_Resolved = Rate_Used_SourceOnly,
    Rate_Base_Source_Code = Rate_Used_SourceOnly_Source_Code,
    Rate_Base_Source_Label = Rate_Used_SourceOnly_Source_Label,
    Rate_Base_Display = Rate_Display_SourceOnly,
    Rate_Base_ReviewRequired = CONVERT(bit, 1),
    Rate_Base_Severity = 'Warning',

    CraftPayRate,
    CraftModifierPayRateAdjustment = CONVERT(decimal(12,3), NULL),
    Source_Rate_Raw,
    Source_Amount_Raw,
    HoursWorked_Raw,

    Act_Total_Hrs,
    Hrs_ST,
    Hrs_OT,
    Hrs_DT,
    Pay_Actual_Gross,
    Pay_Gap_Add,
    Pay_Rest_Add,
    Final_Gross_Pay

FROM api.v_UI_LaborEntry_RateSourceReview
WHERE ISNULL(Act_Total_Hrs, 0) > 0
  AND RateReview_Severity = 'Warning';
