
/* ============================================================
   26 - Patch Boom Breakdown API View v2

   Purpose:
     Distinguish ticket/reference boom window hours from payable boom
     premium hours.

   Key definitions:
     Ticket_Boom_Window_Hrs = Job Ticket boom window duration.
     Slice_Boom_Window_Hrs  = slice hours inside ticket boom window.
     Slice_Boom_Hrs         = payable boom slice hours only.
     Boom_Actual_Add_Amt    = payable boom premium amount only.
   ============================================================ */

CREATE   VIEW api.v_UI_LaborEntry_BoomBreakdown
AS
WITH SliceBoom AS
(
    SELECT
        s.LaborPayrollID,

        Slice_Boom_Window_Hrs =
            CAST(SUM(CASE WHEN s.Is_Boom_Active = 1 THEN s.Slice_Hours ELSE 0 END) AS decimal(10,2)),

        Slice_Boom_Hrs =
            CAST(SUM(
                CASE
                    WHEN s.Is_Boom_Active = 1
                     AND ISNULL(s.Rate_Boom_Applied,0) <> 0
                    THEN s.Slice_Hours ELSE 0
                END
            ) AS decimal(10,2)),

        Boom_Actual_Add_Amt =
            CAST(SUM(
                CASE
                    WHEN s.Is_Boom_Active = 1
                     AND ISNULL(s.Rate_Boom_Applied,0) <> 0
                    THEN ISNULL(s.Rate_Boom_Applied,0)
                       * ISNULL(s.Slice_Hours,0)
                       * ISNULL(s.Final_Multiplier,1)
                    ELSE 0
                END
            ) AS decimal(12,2)),

        Boom_Rate_Min =
            CAST(MIN(
                CASE
                    WHEN s.Is_Boom_Active = 1
                     AND ISNULL(s.Rate_Boom_Applied,0) <> 0
                    THEN s.Rate_Boom_Applied
                END
            ) AS decimal(10,3)),

        Boom_Rate_Max =
            CAST(MAX(
                CASE
                    WHEN s.Is_Boom_Active = 1
                     AND ISNULL(s.Rate_Boom_Applied,0) <> 0
                    THEN s.Rate_Boom_Applied
                END
            ) AS decimal(10,3)),

        Boom_Multiplier_Min =
            CAST(MIN(
                CASE
                    WHEN s.Is_Boom_Active = 1
                     AND ISNULL(s.Rate_Boom_Applied,0) <> 0
                    THEN s.Final_Multiplier
                END
            ) AS decimal(10,2)),

        Boom_Multiplier_Max =
            CAST(MAX(
                CASE
                    WHEN s.Is_Boom_Active = 1
                     AND ISNULL(s.Rate_Boom_Applied,0) <> 0
                    THEN s.Final_Multiplier
                END
            ) AS decimal(10,2)),

        First_Boom_Window_Slice_Start =
            MIN(CASE WHEN s.Is_Boom_Active = 1 THEN s.Slice_Start END),

        Last_Boom_Window_Slice_End =
            MAX(CASE WHEN s.Is_Boom_Active = 1 THEN s.Slice_End END),

        First_Boom_Slice_Start =
            MIN(
                CASE
                    WHEN s.Is_Boom_Active = 1
                     AND ISNULL(s.Rate_Boom_Applied,0) <> 0
                    THEN s.Slice_Start
                END
            ),

        Last_Boom_Slice_End =
            MAX(
                CASE
                    WHEN s.Is_Boom_Active = 1
                     AND ISNULL(s.Rate_Boom_Applied,0) <> 0
                    THEN s.Slice_End
                END
            )
    FROM api.v_UI_Pricing_Slices_Advanced s
    GROUP BY
        s.LaborPayrollID
)
SELECT
    pc.LaborPayrollID,
    pc.JobTicketID,
    pc.JobCode,
    pc.EmpID,
    pc.Employee_Name,
    WorkDate = CONVERT(date, pc.WorkDate),

    blp.CraftCode,
    blp.CraftPayRate,
    blp.CraftModifierCode,
    blp.CraftModifierDescription,
    blp.CraftModifierPayRateAdjustment,

    HasCraftModifier =
        CONVERT(bit,
            CASE
                WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), blp.CraftModifierCode))), '') IS NOT NULL
                THEN 1 ELSE 0
            END
        ),

    BoomEligible =
        CONVERT(bit,
            CASE
                WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), blp.CraftModifierCode))), '') IS NOT NULL
                THEN 1 ELSE 0
            END
        ),

    tt.Boom_Window_Start,
    tt.Boom_Window_End,
    tt.Boom_Source_Start,
    tt.Boom_Source_End,
    tt.Act_BoomStart,
    tt.Act_BoomEnd,

    Ticket_Boom_Window_Hrs =
        CAST(
            CASE
                WHEN tt.Boom_Window_Start IS NULL
                  OR tt.Boom_Window_End IS NULL
                  OR tt.Boom_Window_End <= tt.Boom_Window_Start
                THEN NULL
                ELSE DATEDIFF(MINUTE, tt.Boom_Window_Start, tt.Boom_Window_End) / 60.0
            END
        AS decimal(10,2)),

    pc.Act_Total_Hrs,
    pc.Act_Boom_Hrs,
    pc.Gap_Hrs_Total,
    pc.Gap_Hrs_Boom,
    pc.Pay_Total_Hrs,

    Slice_Boom_Window_Hrs =
        ISNULL(sb.Slice_Boom_Window_Hrs, 0.00),

    Slice_Boom_Hrs =
        ISNULL(sb.Slice_Boom_Hrs, 0.00),

    Boom_Actual_Add_Amt =
        ISNULL(sb.Boom_Actual_Add_Amt, 0.00),

    Boom_Gap_Add_Amt =
        CAST(
            ISNULL(pc.Gap_Hrs_Boom,0)
          * ISNULL(blp.CraftModifierPayRateAdjustment,0)
          * ISNULL(pc.Audit_Gap_Mult,1)
        AS decimal(12,2)),

    Boom_Total_Add_Amt =
        CAST(
            ISNULL(sb.Boom_Actual_Add_Amt,0)
          + (
                ISNULL(pc.Gap_Hrs_Boom,0)
              * ISNULL(blp.CraftModifierPayRateAdjustment,0)
              * ISNULL(pc.Audit_Gap_Mult,1)
            )
        AS decimal(12,2)),

    sb.Boom_Rate_Min,
    sb.Boom_Rate_Max,
    sb.Boom_Multiplier_Min,
    sb.Boom_Multiplier_Max,

    sb.First_Boom_Window_Slice_Start,
    sb.Last_Boom_Window_Slice_End,
    sb.First_Boom_Slice_Start,
    sb.Last_Boom_Slice_End,

    pc.Audit_Gap_Mult,

    BoomDisplayStatus =
        CASE
            WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), blp.CraftModifierCode))), '') IS NULL
             AND ISNULL(pc.Act_Boom_Hrs,0) > 0
             AND ISNULL(sb.Boom_Actual_Add_Amt,0) = 0
                THEN 'Review: calculated boom hours without modifier'

            WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), blp.CraftModifierCode))), '') IS NULL
             AND ISNULL(sb.Slice_Boom_Window_Hrs,0) > 0
                THEN 'Ticket boom window only - no modifier'

            WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), blp.CraftModifierCode))), '') IS NULL
             AND ISNULL(pc.Act_Boom_Hrs,0) = 0
             AND ISNULL(pc.Gap_Hrs_Boom,0) = 0
                THEN 'No boom modifier'

            WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), blp.CraftModifierCode))), '') IS NOT NULL
             AND ISNULL(pc.Act_Boom_Hrs,0) > 0
             AND ISNULL(pc.Gap_Hrs_Boom,0) > 0
                THEN 'Boom actual + gap'

            WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), blp.CraftModifierCode))), '') IS NOT NULL
             AND ISNULL(pc.Act_Boom_Hrs,0) > 0
                THEN 'Boom actual'

            WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), blp.CraftModifierCode))), '') IS NOT NULL
             AND ISNULL(pc.Gap_Hrs_Boom,0) > 0
                THEN 'Boom gap'

            WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), blp.CraftModifierCode))), '') IS NOT NULL
                THEN 'Modifier present, no boom hours'

            ELSE 'Review'
        END
FROM fms.Payroll_Calculated pc
LEFT JOIN app.v_Base_LaborPayroll blp
    ON blp.LaborPayrollID = pc.LaborPayrollID
LEFT JOIN calc.TicketTimeline tt
    ON tt.JobTicketID = pc.JobTicketID
LEFT JOIN SliceBoom sb
    ON sb.LaborPayrollID = pc.LaborPayrollID;
