
/* ============================================================
   Pricing slice API reconstruction

   Important:
   - This view is diagnostic/UI reconstruction.
   - It must mirror app.usp_Run_Pricing_Engine rate logic.

   L12 union labor:
   - Source_Rate_Raw may already include CraftPayRate + modifier.
   - Use labor-entry CraftCode -> UNION_CRAFT.PayRate as Rate_Base.
   - Use labor-entry CraftModifierCode -> UNION_CRAFT_MODIFIER.PayRateChange
     as Rate_Boom / Rate_Boom_Applied.
   - Treat Source_Rate_Raw as audit/reference only.

   Non-L12 rows:
   - Preserve existing fallback behavior for now until non-union rules
     are finalized.
   ============================================================ */

CREATE   VIEW [calc].[v_Calc_Pricing_Slices_API]
AS
WITH x AS
(
    SELECT
        v.LaborPayrollID,
        v.JobTicketID,
        v.JobCode,
        v.EmpID,
        v.Employee_Name,
        v.TicketDate,
        v.WorkDate,
        v.Shift_Start,
        v.Shift_End,
        v.Boom_Start,
        v.Boom_End,
        v.SliceIndex,
        v.Slice_Start,
        v.Slice_End,
        v.Slice_Hours,
        v.Holiday_Name,
        v.Week_Day,
        v.Day_Type,
        v.Accumulation_Status,
        v.Is_Boom_Active,
        v.Is_Outside_Window,
        v.Cfg_Start_Time,
        v.Cfg_End_Time,
        v.Limit_Reg,
        v.Limit_OT,

        HasSourceRate =
            CASE
                WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(b.Source_Rate_Raw, 0.0)), 0.0) IS NOT NULL
                    THEN 1
                ELSE 0
            END,

        HasResolvedPricingBaseRate =
            CASE
                WHEN b.CraftCode LIKE 'L12%'
                 AND b.CraftPayRate IS NOT NULL
                    THEN 1

                WHEN NULLIF(CONVERT(decimal(19,6), ISNULL(b.Source_Rate_Raw, 0.0)), 0.0) IS NOT NULL
                    THEN 1

                ELSE 0
            END,

        Rate_Base =
            CONVERT(decimal(12,3),
                CASE
                    WHEN b.CraftCode LIKE 'L12%'
                     AND b.CraftPayRate IS NOT NULL
                        THEN b.CraftPayRate

                    ELSE COALESCE(
                            NULLIF(CONVERT(decimal(19,6), ISNULL(b.Source_Rate_Raw, 0.0)), 0.0),
                            0.0
                         )
                END
            ),

        Rate_Shift =
            CONVERT(decimal(4,2),
                ISNULL(v.Rate_Shift, 0.00)
            ),

        Rate_Boom =
            CONVERT(decimal(7,3),
                CASE
                    WHEN b.CraftCode LIKE 'L12%'
                     AND NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), b.CraftModifierCode))), '') IS NOT NULL
                        THEN ISNULL(b.CraftModifierPayRateAdjustment, 0.000)
                    ELSE 0.000
                END
            ),

        Rate_Boom_Applied =
            CONVERT(decimal(7,3),
                CASE
                    WHEN b.CraftCode LIKE 'L12%'
                     AND v.Is_Boom_Active = 1
                     AND NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), b.CraftModifierCode))), '') IS NOT NULL
                        THEN ISNULL(b.CraftModifierPayRateAdjustment, 0.000)
                    ELSE 0.000
                END
            ),

        v.Mul_OT,
        v.Mul_DT,
        v.Mul_Sat,
        v.Mul_Sun,
        v.Mul_Hol,
        v.Final_Multiplier

    FROM calc.v_Calc_Pricing_Slices_API_Legacy_Pre51K v
    LEFT JOIN app.v_Base_LaborPayroll b
        ON b.LaborPayrollID = v.LaborPayrollID
),
rated AS
(
    SELECT
        *,
        Hourly_Rate_Raw =
            CONVERT(decimal(14,3),
                COALESCE(Rate_Base, 0.0)
              + COALESCE(Rate_Shift, 0.0)
              + COALESCE(Rate_Boom_Applied, 0.0)
            )
    FROM x
)
SELECT
    LaborPayrollID,
    JobTicketID,
    JobCode,
    EmpID,
    Employee_Name,
    TicketDate,
    WorkDate,
    Shift_Start,
    Shift_End,
    Boom_Start,
    Boom_End,
    SliceIndex,
    Slice_Start,
    Slice_End,
    Slice_Hours,
    Holiday_Name,
    Week_Day,
    Day_Type,
    Accumulation_Status,
    Is_Boom_Active,
    Is_Outside_Window,
    Cfg_Start_Time,
    Cfg_End_Time,
    Limit_Reg,
    Limit_OT,
    Rate_Base,
    Rate_Shift,
    Rate_Boom,
    Rate_Boom_Applied,
    Mul_OT,
    Mul_DT,
    Mul_Sat,
    Mul_Sun,
    Mul_Hol,
    Final_Multiplier,
    Hourly_Rate_Raw,
    Effective_Rate = CAST(Hourly_Rate_Raw * Final_Multiplier AS decimal(12,4)),
    Slice_Pay      = CAST(Slice_Hours * Hourly_Rate_Raw * Final_Multiplier AS decimal(12,4))
FROM rated;
