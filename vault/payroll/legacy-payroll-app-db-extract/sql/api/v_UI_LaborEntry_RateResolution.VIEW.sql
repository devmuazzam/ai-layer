
CREATE   VIEW api.v_UI_LaborEntry_RateResolution
AS
SELECT
    b.LaborPayrollID,
    b.EmpID,
    b.Employee_Name,
    b.WorkDate,
    b.JobTicketID,
    b.JobCode,
    b.CraftCode,

    CraftPayRate =
        CONVERT(decimal(12,3), b.CraftPayRate),

    CraftModifierPayRateAdjustment =
        CONVERT(decimal(12,3), b.CraftModifierPayRateAdjustment),

    Source_Rate_Raw =
        CONVERT(decimal(12,3), b.Source_Rate_Raw),

    Source_Amount_Raw =
        CONVERT(decimal(12,3), b.Source_Amount_Raw),

    HoursWorked_Raw =
        CONVERT(decimal(12,3), b.HoursWorked_Raw),

    Rate_Base_Resolved =
        COALESCE
        (
            NULLIF(CONVERT(decimal(12,3), ISNULL(b.CraftPayRate, 0.000)), 0.000),
            NULLIF(CONVERT(decimal(12,3), ISNULL(b.Source_Rate_Raw, 0.000)), 0.000),
            CASE
                WHEN ISNULL(b.Source_Amount_Raw, 0.000) > 0.000
                 AND ISNULL(b.HoursWorked_Raw, 0.000) > 0.000
                THEN CONVERT(decimal(12,3), b.Source_Amount_Raw / NULLIF(b.HoursWorked_Raw, 0.000))
                ELSE NULL
            END,
            CONVERT(decimal(12,3), 0.000)
        ),

    Rate_Base_Source_Code =
        CASE
            WHEN NULLIF(CONVERT(decimal(12,3), ISNULL(b.CraftPayRate, 0.000)), 0.000) IS NOT NULL
                THEN 'CRAFT_PAY_RATE'

            WHEN NULLIF(CONVERT(decimal(12,3), ISNULL(b.Source_Rate_Raw, 0.000)), 0.000) IS NOT NULL
                THEN 'SOURCE_RATE_RAW'

            WHEN ISNULL(b.Source_Amount_Raw, 0.000) > 0.000
             AND ISNULL(b.HoursWorked_Raw, 0.000) > 0.000
                THEN 'SOURCE_AMOUNT_IMPLIED_RATE'

            ELSE 'NO_USABLE_RATE'
        END,

    Rate_Base_Source_Label =
        CASE
            WHEN NULLIF(CONVERT(decimal(12,3), ISNULL(b.CraftPayRate, 0.000)), 0.000) IS NOT NULL
                THEN 'Craft pay rate'

            WHEN NULLIF(CONVERT(decimal(12,3), ISNULL(b.Source_Rate_Raw, 0.000)), 0.000) IS NOT NULL
                THEN 'FMS source rate'

            WHEN ISNULL(b.Source_Amount_Raw, 0.000) > 0.000
             AND ISNULL(b.HoursWorked_Raw, 0.000) > 0.000
                THEN 'FMS amount divided by hours'

            ELSE 'No usable rate'
        END,

    Rate_Base_ReviewRequired =
        CONVERT(bit,
            CASE
                WHEN NULLIF(CONVERT(decimal(12,3), ISNULL(b.CraftPayRate, 0.000)), 0.000) IS NOT NULL
                    THEN 0

                WHEN NULLIF(CONVERT(decimal(12,3), ISNULL(b.Source_Rate_Raw, 0.000)), 0.000) IS NOT NULL
                    THEN 0

                WHEN ISNULL(b.Source_Amount_Raw, 0.000) > 0.000
                 AND ISNULL(b.HoursWorked_Raw, 0.000) > 0.000
                    THEN 1

                ELSE 1
            END
        ),

    Rate_Base_Severity =
        CASE
            WHEN NULLIF(CONVERT(decimal(12,3), ISNULL(b.CraftPayRate, 0.000)), 0.000) IS NOT NULL
                THEN 'OK'

            WHEN NULLIF(CONVERT(decimal(12,3), ISNULL(b.Source_Rate_Raw, 0.000)), 0.000) IS NOT NULL
                THEN 'OK'

            WHEN ISNULL(b.Source_Amount_Raw, 0.000) > 0.000
             AND ISNULL(b.HoursWorked_Raw, 0.000) > 0.000
                THEN 'Warning'

            ELSE 'Error'
        END,

    Rate_Base_Display =
        CONCAT
        (
            CONVERT(varchar(30),
                CONVERT(decimal(12,2),
                    COALESCE
                    (
                        NULLIF(CONVERT(decimal(12,3), ISNULL(b.CraftPayRate, 0.000)), 0.000),
                        NULLIF(CONVERT(decimal(12,3), ISNULL(b.Source_Rate_Raw, 0.000)), 0.000),
                        CASE
                            WHEN ISNULL(b.Source_Amount_Raw, 0.000) > 0.000
                             AND ISNULL(b.HoursWorked_Raw, 0.000) > 0.000
                            THEN CONVERT(decimal(12,3), b.Source_Amount_Raw / NULLIF(b.HoursWorked_Raw, 0.000))
                            ELSE NULL
                        END,
                        CONVERT(decimal(12,3), 0.000)
                    )
                )
            ),
            ' - ',
            CASE
                WHEN NULLIF(CONVERT(decimal(12,3), ISNULL(b.CraftPayRate, 0.000)), 0.000) IS NOT NULL
                    THEN 'Craft pay rate'

                WHEN NULLIF(CONVERT(decimal(12,3), ISNULL(b.Source_Rate_Raw, 0.000)), 0.000) IS NOT NULL
                    THEN 'FMS source rate'

                WHEN ISNULL(b.Source_Amount_Raw, 0.000) > 0.000
                 AND ISNULL(b.HoursWorked_Raw, 0.000) > 0.000
                    THEN 'FMS amount divided by hours'

                ELSE 'No usable rate'
            END
        ),

    pc.Act_Total_Hrs,
    pc.Hrs_ST,
    pc.Hrs_OT,
    pc.Hrs_DT,
    pc.Pay_Actual_Gross,
    pc.Pay_Gap_Add,
    pc.Pay_Rest_Add,
    pc.Final_Gross_Pay

FROM app.v_Base_LaborPayroll b
LEFT JOIN fms.Payroll_Calculated pc
    ON pc.LaborPayrollID = b.LaborPayrollID;
