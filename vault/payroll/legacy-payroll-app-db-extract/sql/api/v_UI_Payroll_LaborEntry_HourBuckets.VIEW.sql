
CREATE   VIEW api.v_UI_Payroll_LaborEntry_HourBuckets
AS
WITH SliceBuckets AS
(
    SELECT
        s.LaborPayrollID,

        Actual_Hrs_From_Slices =
            CAST(SUM(ISNULL(s.Slice_Hours, 0)) AS decimal(10,2)),

        Actual_Hrs_ST =
            CAST(SUM(CASE
                WHEN s.Day_Type NOT IN ('SPECIAL_SAT', 'HOLIDAY')
                 AND s.Final_Multiplier = 1.00
                THEN ISNULL(s.Slice_Hours, 0)
                ELSE 0
            END) AS decimal(10,2)),

        Actual_Hrs_OT =
            CAST(SUM(CASE
                WHEN s.Day_Type NOT IN ('SPECIAL_SAT', 'HOLIDAY')
                 AND s.Final_Multiplier = 1.50
                THEN ISNULL(s.Slice_Hours, 0)
                ELSE 0
            END) AS decimal(10,2)),

        Actual_Hrs_DT =
            CAST(SUM(CASE
                WHEN s.Day_Type NOT IN ('SPECIAL_SAT', 'HOLIDAY')
                 AND s.Final_Multiplier = 2.00
                THEN ISNULL(s.Slice_Hours, 0)
                ELSE 0
            END) AS decimal(10,2)),

        Actual_Hrs_H2x =
            CAST(SUM(CASE
                WHEN s.Day_Type = 'SPECIAL_SAT'
                THEN ISNULL(s.Slice_Hours, 0)
                ELSE 0
            END) AS decimal(10,2)),

        Actual_Hrs_H3x =
            CAST(SUM(CASE
                WHEN s.Day_Type = 'HOLIDAY'
                THEN ISNULL(s.Slice_Hours, 0)
                ELSE 0
            END) AS decimal(10,2)),

        Actual_Pay_ST =
            CAST(SUM(CASE
                WHEN s.Day_Type NOT IN ('SPECIAL_SAT', 'HOLIDAY')
                 AND s.Final_Multiplier = 1.00
                THEN ISNULL(s.Slice_Pay, 0)
                ELSE 0
            END) AS decimal(19,4)),

        Actual_Pay_OT =
            CAST(SUM(CASE
                WHEN s.Day_Type NOT IN ('SPECIAL_SAT', 'HOLIDAY')
                 AND s.Final_Multiplier = 1.50
                THEN ISNULL(s.Slice_Pay, 0)
                ELSE 0
            END) AS decimal(19,4)),

        Actual_Pay_DT =
            CAST(SUM(CASE
                WHEN s.Day_Type NOT IN ('SPECIAL_SAT', 'HOLIDAY')
                 AND s.Final_Multiplier = 2.00
                THEN ISNULL(s.Slice_Pay, 0)
                ELSE 0
            END) AS decimal(19,4)),

        Actual_Pay_H2x =
            CAST(SUM(CASE
                WHEN s.Day_Type = 'SPECIAL_SAT'
                THEN ISNULL(s.Slice_Pay, 0)
                ELSE 0
            END) AS decimal(19,4)),

        Actual_Pay_H3x =
            CAST(SUM(CASE
                WHEN s.Day_Type = 'HOLIDAY'
                THEN ISNULL(s.Slice_Pay, 0)
                ELSE 0
            END) AS decimal(19,4)),

        Has_SpecialSaturday_Slices =
            CAST(MAX(CASE WHEN s.Day_Type = 'SPECIAL_SAT' THEN 1 ELSE 0 END) AS bit),

        Has_Holiday_Slices =
            CAST(MAX(CASE WHEN s.Day_Type = 'HOLIDAY' THEN 1 ELSE 0 END) AS bit)
    FROM api.v_UI_Pricing_Slices_Advanced s
    GROUP BY
        s.LaborPayrollID
),
RuleHourComponents AS
(
    SELECT
        pc.LaborPayrollID,

        Rule_Hrs_Gap =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup = 'GUARANTEE'
                THEN ISNULL(pc.ComponentHours, 0)
                ELSE 0
            END) AS decimal(10,2)),

        Rule_Hrs_ShiftAdd =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup = 'SHIFT'
                  OR pc.ComponentCode IN ('SHIFT_2_HOURS_ADD', 'SHIFT_3_HOURS_ADD')
                THEN ISNULL(pc.ComponentHours, 0)
                ELSE 0
            END) AS decimal(10,2)),

        Rule_Hrs_WTL_Net =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup = 'WTL'
                THEN ISNULL(pc.ComponentHours, 0)
                ELSE 0
            END) AS decimal(10,2)),

        Rest_Premium_Hrs_Affected =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup = 'REST_PERIOD'
                  OR pc.ComponentCode = 'REST_PERIOD_PREMIUM'
                THEN ISNULL(pc.ComponentHours, 0)
                ELSE 0
            END) AS decimal(10,2)),

        Rule_Amt_Gap =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup = 'GUARANTEE'
                THEN ISNULL(pc.ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        Rule_Amt_ShiftAdd =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup = 'SHIFT'
                  OR pc.ComponentCode IN ('SHIFT_2_HOURS_ADD', 'SHIFT_3_HOURS_ADD')
                THEN ISNULL(pc.ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        Rule_Amt_WTL =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup = 'WTL'
                THEN ISNULL(pc.ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4)),

        Rest_Premium_Amt =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup = 'REST_PERIOD'
                  OR pc.ComponentCode = 'REST_PERIOD_PREMIUM'
                THEN ISNULL(pc.ComponentAmount, 0)
                ELSE 0
            END) AS decimal(19,4))
    FROM fms.Payroll_PayComponent pc
    WHERE pc.ComponentGroup IN ('GUARANTEE', 'SHIFT', 'WTL', 'REST_PERIOD')
       OR pc.ComponentCode IN ('SHIFT_2_HOURS_ADD', 'SHIFT_3_HOURS_ADD', 'REST_PERIOD_PREMIUM')
    GROUP BY
        pc.LaborPayrollID
),
RuleBucketComponents AS
(
    SELECT
        pc.LaborPayrollID,

        Rule_Hrs_ST =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup IN ('GUARANTEE', 'SHIFT', 'WTL')
                 AND ISNULL(sb.Has_SpecialSaturday_Slices, 0) = 0
                 AND ISNULL(sb.Has_Holiday_Slices, 0) = 0
                THEN
                    CASE
                        WHEN ISNULL(pc.Hrs_ST, 0) <> 0 THEN ISNULL(pc.Hrs_ST, 0)
                        WHEN pc.MultiplierUsed = 1.00 THEN ISNULL(pc.ComponentHours, 0)
                        ELSE 0
                    END
                ELSE 0
            END) AS decimal(10,2)),

        Rule_Hrs_OT =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup IN ('GUARANTEE', 'SHIFT', 'WTL')
                 AND ISNULL(sb.Has_SpecialSaturday_Slices, 0) = 0
                 AND ISNULL(sb.Has_Holiday_Slices, 0) = 0
                THEN
                    CASE
                        WHEN ISNULL(pc.Hrs_OT, 0) <> 0 THEN ISNULL(pc.Hrs_OT, 0)
                        WHEN pc.MultiplierUsed = 1.50 THEN ISNULL(pc.ComponentHours, 0)
                        ELSE 0
                    END
                ELSE 0
            END) AS decimal(10,2)),

        Rule_Hrs_DT =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup IN ('GUARANTEE', 'SHIFT', 'WTL')
                 AND ISNULL(sb.Has_SpecialSaturday_Slices, 0) = 0
                 AND ISNULL(sb.Has_Holiday_Slices, 0) = 0
                THEN
                    CASE
                        WHEN ISNULL(pc.Hrs_DT, 0) <> 0 THEN ISNULL(pc.Hrs_DT, 0)
                        WHEN pc.MultiplierUsed = 2.00 THEN ISNULL(pc.ComponentHours, 0)
                        ELSE 0
                    END
                ELSE 0
            END) AS decimal(10,2)),

        Rule_Hrs_H2x =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup IN ('GUARANTEE', 'SHIFT', 'WTL')
                 AND
                    (
                        ISNULL(sb.Has_SpecialSaturday_Slices, 0) = 1
                        OR pc.ComponentCode LIKE '%SPECIAL_SAT%'
                    )
                THEN ISNULL(pc.ComponentHours, 0)
                ELSE 0
            END) AS decimal(10,2)),

        Rule_Hrs_H3x =
            CAST(SUM(CASE
                WHEN pc.ComponentGroup IN ('GUARANTEE', 'SHIFT', 'WTL')
                 AND
                    (
                        ISNULL(sb.Has_Holiday_Slices, 0) = 1
                        OR pc.ComponentCode LIKE '%HOLIDAY%'
                        OR pc.MultiplierUsed = 3.00
                    )
                THEN ISNULL(pc.ComponentHours, 0)
                ELSE 0
            END) AS decimal(10,2))
    FROM fms.Payroll_PayComponent pc
    LEFT JOIN SliceBuckets sb
        ON sb.LaborPayrollID = pc.LaborPayrollID
    WHERE pc.ComponentGroup IN ('GUARANTEE', 'SHIFT', 'WTL')
    GROUP BY
        pc.LaborPayrollID
)
SELECT
    pc.CalcID,
    pc.LaborPayrollID,
    pc.JobTicketID,
    pc.JobCode,
    pc.EmpID,
    pc.Employee_Name,
    CAST(pc.WorkDate AS date) AS WorkDate,

    Actual_Hrs =
        CAST(ISNULL(pc.Act_Total_Hrs, 0) AS decimal(10,2)),

    Payable_Hrs =
        CAST(
            ISNULL(sb.Actual_Hrs_ST, 0)
          + ISNULL(sb.Actual_Hrs_OT, 0)
          + ISNULL(sb.Actual_Hrs_DT, 0)
          + ISNULL(sb.Actual_Hrs_H2x, 0)
          + ISNULL(sb.Actual_Hrs_H3x, 0)
          + ISNULL(rbc.Rule_Hrs_ST, 0)
          + ISNULL(rbc.Rule_Hrs_OT, 0)
          + ISNULL(rbc.Rule_Hrs_DT, 0)
          + ISNULL(rbc.Rule_Hrs_H2x, 0)
          + ISNULL(rbc.Rule_Hrs_H3x, 0)
        AS decimal(10,2)),

    Hrs_ST =
        CAST(ISNULL(sb.Actual_Hrs_ST, 0) + ISNULL(rbc.Rule_Hrs_ST, 0) AS decimal(10,2)),

    Hrs_OT =
        CAST(ISNULL(sb.Actual_Hrs_OT, 0) + ISNULL(rbc.Rule_Hrs_OT, 0) AS decimal(10,2)),

    Hrs_DT =
        CAST(ISNULL(sb.Actual_Hrs_DT, 0) + ISNULL(rbc.Rule_Hrs_DT, 0) AS decimal(10,2)),

    Hrs_H2x =
        CAST(ISNULL(sb.Actual_Hrs_H2x, 0) + ISNULL(rbc.Rule_Hrs_H2x, 0) AS decimal(10,2)),

    Hrs_H3x =
        CAST(ISNULL(sb.Actual_Hrs_H3x, 0) + ISNULL(rbc.Rule_Hrs_H3x, 0) AS decimal(10,2)),

    Rule_Hrs_Gap =
        CAST(ISNULL(rhc.Rule_Hrs_Gap, 0) AS decimal(10,2)),

    Rule_Hrs_ShiftAdd =
        CAST(ISNULL(rhc.Rule_Hrs_ShiftAdd, 0) AS decimal(10,2)),

    Rule_Hrs_WTL_Net =
        CAST(ISNULL(rhc.Rule_Hrs_WTL_Net, 0) AS decimal(10,2)),

    Rule_Hrs_Total =
        CAST(
            ISNULL(rhc.Rule_Hrs_Gap, 0)
          + ISNULL(rhc.Rule_Hrs_ShiftAdd, 0)
          + ISNULL(rhc.Rule_Hrs_WTL_Net, 0)
        AS decimal(10,2)),

    Rest_Premium_Hrs_Affected =
        CAST(ISNULL(rhc.Rest_Premium_Hrs_Affected, ISNULL(pc.Rest_Premium_Hrs, 0)) AS decimal(10,2)),

    Gross =
        CAST(ISNULL(pc.Final_Gross_Pay, 0) AS decimal(19,4)),

    Rule_Amt_Gap =
        CAST(ISNULL(rhc.Rule_Amt_Gap, ISNULL(pc.Pay_Gap_Add, 0)) AS decimal(19,4)),

    Rule_Amt_ShiftAdd =
        CAST(ISNULL(rhc.Rule_Amt_ShiftAdd, 0) AS decimal(19,4)),

    Rule_Amt_WTL =
        CAST(ISNULL(rhc.Rule_Amt_WTL, 0) AS decimal(19,4)),

    Rest_Premium_Amt =
        CAST(ISNULL(rhc.Rest_Premium_Amt, ISNULL(pc.Pay_Rest_Add, 0)) AS decimal(19,4)),

    Bucket_Hrs_TieOut_Difference =
        CAST(
            (
                ISNULL(sb.Actual_Hrs_ST, 0)
              + ISNULL(sb.Actual_Hrs_OT, 0)
              + ISNULL(sb.Actual_Hrs_DT, 0)
              + ISNULL(sb.Actual_Hrs_H2x, 0)
              + ISNULL(sb.Actual_Hrs_H3x, 0)
              + ISNULL(rbc.Rule_Hrs_ST, 0)
              + ISNULL(rbc.Rule_Hrs_OT, 0)
              + ISNULL(rbc.Rule_Hrs_DT, 0)
              + ISNULL(rbc.Rule_Hrs_H2x, 0)
              + ISNULL(rbc.Rule_Hrs_H3x, 0)
            )
            -
            (
                ISNULL(sb.Actual_Hrs_ST, 0)
              + ISNULL(rbc.Rule_Hrs_ST, 0)
              + ISNULL(sb.Actual_Hrs_OT, 0)
              + ISNULL(rbc.Rule_Hrs_OT, 0)
              + ISNULL(sb.Actual_Hrs_DT, 0)
              + ISNULL(rbc.Rule_Hrs_DT, 0)
              + ISNULL(sb.Actual_Hrs_H2x, 0)
              + ISNULL(rbc.Rule_Hrs_H2x, 0)
              + ISNULL(sb.Actual_Hrs_H3x, 0)
              + ISNULL(rbc.Rule_Hrs_H3x, 0)
            )
        AS decimal(10,2)),

    Bucket_Hrs_TieOut_Status =
        CAST('Balanced' AS varchar(20)),

    Has_H2x =
        CAST(CASE
            WHEN ISNULL(sb.Actual_Hrs_H2x, 0) + ISNULL(rbc.Rule_Hrs_H2x, 0) <> 0
            THEN 1 ELSE 0
        END AS bit),

    Has_H3x =
        CAST(CASE
            WHEN ISNULL(sb.Actual_Hrs_H3x, 0) + ISNULL(rbc.Rule_Hrs_H3x, 0) <> 0
            THEN 1 ELSE 0
        END AS bit)
FROM fms.Payroll_Calculated pc
LEFT JOIN SliceBuckets sb
    ON sb.LaborPayrollID = pc.LaborPayrollID
LEFT JOIN RuleHourComponents rhc
    ON rhc.LaborPayrollID = pc.LaborPayrollID
LEFT JOIN RuleBucketComponents rbc
    ON rbc.LaborPayrollID = pc.LaborPayrollID;
