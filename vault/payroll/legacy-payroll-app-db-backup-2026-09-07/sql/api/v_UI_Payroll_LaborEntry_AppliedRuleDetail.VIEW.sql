CREATE     VIEW [api].[v_UI_Payroll_LaborEntry_AppliedRuleDetail]
AS

WITH CurrentPayroll AS
(
    SELECT
        pc.RunId,
        pc.CalcID,
        pc.LaborPayrollID,

        WorkDate =
            CONVERT(date, pc.WorkDate),

        pc.EmpID,
        pc.Employee_Name,
        pc.JobTicketID,
        pc.JobCode

    FROM fms.Payroll_Calculated AS pc
),


/***********************************************************************
 CURRENT PAY-COMPONENT AGGREGATE

 Tied to the current authoritative Payroll_Calculated RunId + CalcID
 so historical/stale pay-component rows cannot leak into the UI.
***********************************************************************/

ComponentAgg AS
(
    SELECT
        cp.RunId,
        cp.CalcID,
        cp.LaborPayrollID,
        cp.WorkDate,
        cp.EmpID,
        cp.Employee_Name,
        cp.JobTicketID,
        cp.JobCode,

        p.ComponentCode,
        p.ComponentGroup,

        ComponentLabel =
            MIN(p.ComponentLabel),

        ComponentHours =
            CONVERT
            (
                decimal(10,2),
                SUM(ISNULL(p.ComponentHours, 0))
            ),

        ComponentAmount =
            CONVERT
            (
                decimal(19,4),
                SUM(ISNULL(p.ComponentAmount, 0))
            )

    FROM CurrentPayroll AS cp

    JOIN fms.Payroll_PayComponent AS p
      ON p.RunId = cp.RunId
     AND p.CalcID = cp.CalcID
     AND p.LaborPayrollID = cp.LaborPayrollID

    GROUP BY
        cp.RunId,
        cp.CalcID,
        cp.LaborPayrollID,
        cp.WorkDate,
        cp.EmpID,
        cp.Employee_Name,
        cp.JobTicketID,
        cp.JobCode,
        p.ComponentCode,
        p.ComponentGroup
),


/***********************************************************************
 BASE PRICING-SLICE RULE

 Mirrors current pricing precedence for explanation purposes.

 IMPORTANT:
 Normal_Final_Multiplier is used here so the base calculation and
 later rest-period reclassification remain separately explainable.
***********************************************************************/

SliceRuleSeed AS
(
    SELECT
        cp.RunId,
        cp.CalcID,
        cp.LaborPayrollID,
        cp.WorkDate,
        cp.EmpID,
        cp.Employee_Name,
        cp.JobTicketID,
        cp.JobCode,

        s.SliceIndex,
        s.Slice_Start,
        s.Slice_End,
        s.Slice_Hours,

        s.Day_Type,
        s.Accumulation_Status,
        s.Is_Outside_Window,

        s.Mul_OT,
        s.Mul_DT,
        s.Mul_Sat,
        s.Mul_Sun,
        s.Mul_Hol,

        s.Normal_Final_Multiplier,

        BaseRuleCode =
            CASE

                WHEN UPPER(ISNULL(s.Day_Type, '')) = 'HOLIDAY'
                    THEN 'HOLIDAY'

                WHEN UPPER(ISNULL(s.Day_Type, '')) = 'SUNDAY'
                    THEN 'SUNDAY'

                WHEN UPPER(ISNULL(s.Day_Type, '')) = 'SPECIAL_SAT'
                    THEN 'SPECIAL_SATURDAY'

                WHEN UPPER(ISNULL(s.Accumulation_Status, '')) =
                     'DT_DAILY'
                    THEN 'DAILY_DT'

                WHEN ISNULL(s.Is_Outside_Window, 0) = 1
                 AND UPPER(ISNULL(s.Day_Type, '')) = 'WEEKDAY'
                    THEN 'OUTSIDE_WINDOW'

                /*
                   Payroll-facing representation of production
                   Is_PrevDay_ST_Reentry_Block.

                   UX-RULE-7 validated this against all 5,691 current
                   pricing slices with zero multiplier mismatches.
                */
                WHEN UPPER(ISNULL(s.Day_Type, '')) = 'WEEKDAY'
                 AND UPPER(ISNULL(s.Accumulation_Status, '')) =
                     'REG_DAILY'
                 AND ISNULL(s.Is_Outside_Window, 0) = 0
                 AND CONVERT(date, s.Slice_Start) > cp.WorkDate
                 AND ABS
                     (
                         ISNULL(s.Normal_Final_Multiplier, 0)
                         -
                         ISNULL(s.Mul_OT, 0)
                     ) < 0.0001
                    THEN 'CROSS_MIDNIGHT_OT_CARRYOVER'

                WHEN UPPER(ISNULL(s.Accumulation_Status, '')) =
                     'OT_DAILY'
                    THEN 'DAILY_OT'

                WHEN UPPER(ISNULL(s.Day_Type, '')) = 'SATURDAY'
                    THEN 'SATURDAY'

                ELSE 'REGULAR_ST'
            END

    FROM CurrentPayroll AS cp

    JOIN api.v_UI_Pricing_Slices_PayrollEffective AS s
      ON s.LaborPayrollID = cp.LaborPayrollID

    WHERE ISNULL(s.Slice_Hours, 0) > 0

    AND EXISTS
    (
        SELECT 1

        FROM api.v_UI_Payroll_LaborEntry_HourBuckets AS hb

        WHERE hb.LaborPayrollID = cp.LaborPayrollID
            AND hb.Bucket_Source = 'PRICING_SLICES'
    )
),


BaseRuleAgg AS
(
    SELECT
        RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        EmpID,
        Employee_Name,
        JobTicketID,
        JobCode,

        BaseRuleCode,

        RuleHours =
            CONVERT
            (
                decimal(10,2),
                SUM(Slice_Hours)
            ),

        RuleMultiplier =
            CONVERT
            (
                decimal(10,2),
                MAX(Normal_Final_Multiplier)
            )

    FROM SliceRuleSeed

    WHERE BaseRuleCode <> 'REGULAR_ST'

    GROUP BY
        RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        EmpID,
        Employee_Name,
        JobTicketID,
        JobCode,
        BaseRuleCode
),


/***********************************************************************
 REST-PERIOD EFFECTIVE RECLASSIFICATION
***********************************************************************/

RestSliceAgg AS
(
    SELECT
        cp.RunId,
        cp.CalcID,
        cp.LaborPayrollID,

        RaisedToOT =
            CONVERT
            (
                decimal(10,2),
                SUM
                (
                    CASE
                        WHEN ISNULL(s.RestSliceAdjustmentFound, 0) = 1
                         AND s.Effective_Final_Multiplier
                               > s.Normal_Final_Multiplier
                         AND ABS
                             (
                                 s.Effective_Final_Multiplier
                                 - s.Mul_OT
                             ) < 0.0001
                            THEN ISNULL(s.Slice_Hours, 0)

                        ELSE 0
                    END
                )
            ),

        RaisedToDT =
            CONVERT
            (
                decimal(10,2),
                SUM
                (
                    CASE
                        WHEN ISNULL(s.RestSliceAdjustmentFound, 0) = 1
                         AND s.Effective_Final_Multiplier
                               > s.Normal_Final_Multiplier
                         AND s.Effective_Final_Multiplier >= s.Mul_DT
                            THEN ISNULL(s.Slice_Hours, 0)

                        ELSE 0
                    END
                )
            )

    FROM CurrentPayroll AS cp

    JOIN api.v_UI_Pricing_Slices_PayrollEffective AS s
      ON s.LaborPayrollID = cp.LaborPayrollID

    GROUP BY
        cp.RunId,
        cp.CalcID,
        cp.LaborPayrollID
),


/***********************************************************************
 WTL ENTRY SUMMARY
***********************************************************************/

WTLAgg AS
(
    SELECT
        RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        EmpID,
        Employee_Name,
        JobTicketID,
        JobCode,

        MealDeduct =
            CONVERT
            (
                decimal(10,2),
                ABS
                (
                    SUM
                    (
                        CASE
                            WHEN ComponentCode = 'WTL_MEAL_DEDUCT'
                                THEN ComponentHours
                            ELSE 0
                        END
                    )
                )
            ),

        DTFloor =
            CONVERT
            (
                decimal(10,2),
                SUM
                (
                    CASE
                        WHEN ComponentCode = 'WTL_DT_FLOOR'
                            THEN ComponentHours
                        ELSE 0
                    END
                )
            ),

        ApplicableAdd =
            CONVERT
            (
                decimal(10,2),
                SUM
                (
                    CASE
                        WHEN ComponentCode = 'WTL_APPLICABLE_ADD'
                            THEN ComponentHours
                        ELSE 0
                    END
                )
            ),

        NetWTLHours =
            CONVERT
            (
                decimal(10,2),
                SUM(ComponentHours)
            )

    FROM ComponentAgg

    WHERE ComponentGroup = 'WTL'

    GROUP BY
        RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        EmpID,
        Employee_Name,
        JobTicketID,
        JobCode
)


/***********************************************************************
 FINAL RULE DETAIL
***********************************************************************/


/* ================================================================
   UNION / PRICING-SLICE BASE CLASSIFICATION
   ================================================================ */

SELECT
    b.RunId,
    b.CalcID,
    b.LaborPayrollID,
    b.WorkDate,
    b.EmpID,
    b.Employee_Name,
    b.JobTicketID,
    b.JobCode,

    DisplaySort =
        CASE b.BaseRuleCode
            WHEN 'HOLIDAY'                      THEN 100
            WHEN 'SUNDAY'                       THEN 110
            WHEN 'SPECIAL_SATURDAY'             THEN 120
            WHEN 'SATURDAY'                     THEN 130
            WHEN 'OUTSIDE_WINDOW'               THEN 140
            WHEN 'CROSS_MIDNIGHT_OT_CARRYOVER'  THEN 145
            WHEN 'DAILY_OT'                     THEN 150
            WHEN 'DAILY_DT'                     THEN 160
            ELSE 199
        END,

    RuleCategory =
        CONVERT(varchar(50), 'BASE_CLASSIFICATION'),

    RuleCode =
        CONVERT(varchar(100), b.BaseRuleCode),

    RuleName =
        CONVERT
        (
            varchar(150),
            CASE b.BaseRuleCode
                WHEN 'HOLIDAY'
                    THEN 'Holiday premium'

                WHEN 'SUNDAY'
                    THEN 'Sunday premium'

                WHEN 'SPECIAL_SATURDAY'
                    THEN 'Special Saturday'

                WHEN 'SATURDAY'
                    THEN 'Saturday premium'

                WHEN 'OUTSIDE_WINDOW'
                    THEN 'Outside regular work hours'

                WHEN 'CROSS_MIDNIGHT_OT_CARRYOVER'
                    THEN 'Cross-midnight OT carryover'

                WHEN 'DAILY_OT'
                    THEN 'Daily overtime'

                WHEN 'DAILY_DT'
                    THEN 'Daily double time'

                ELSE b.BaseRuleCode
            END
        ),

    AffectedHours =
        b.RuleHours,

    Amount =
        CONVERT(decimal(19,4), NULL),

    RuleText =
        CONVERT
        (
            nvarchar(1000),

            CASE b.BaseRuleCode

                WHEN 'HOLIDAY'
                    THEN CONCAT
                    (
                        'Holiday premium: ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleHours)
                        ),
                        'h at ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleMultiplier)
                        ),
                        'x.'
                    )

                WHEN 'SUNDAY'
                    THEN CONCAT
                    (
                        'Sunday premium: ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleHours)
                        ),
                        'h at ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleMultiplier)
                        ),
                        'x.'
                    )

                WHEN 'SPECIAL_SATURDAY'
                    THEN CONCAT
                    (
                        'Special Saturday: ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleHours)
                        ),
                        'h at ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleMultiplier)
                        ),
                        'x.'
                    )

                WHEN 'SATURDAY'
                    THEN CONCAT
                    (
                        'Saturday premium: ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleHours)
                        ),
                        'h at ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleMultiplier)
                        ),
                        'x.'
                    )

                WHEN 'OUTSIDE_WINDOW'
                    THEN CONCAT
                    (
                        'Outside regular work hours: ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleHours)
                        ),
                        'h at ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleMultiplier)
                        ),
                        'x.'
                    )

                WHEN 'CROSS_MIDNIGHT_OT_CARRYOVER'
                    THEN CONCAT
                    (
                        'Cross-midnight OT carryover: ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleHours)
                        ),
                        'h remained OT after re-entering the regular work window.'
                    )

                WHEN 'DAILY_OT'
                    THEN CONCAT
                    (
                        'Daily overtime rule: ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleHours)
                        ),
                        'h at ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleMultiplier)
                        ),
                        'x.'
                    )

                WHEN 'DAILY_DT'
                    THEN CONCAT
                    (
                        'Daily double-time rule: ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleHours)
                        ),
                        'h at ',
                        CONVERT
                        (
                            varchar(20),
                            CONVERT(decimal(10,1), b.RuleMultiplier)
                        ),
                        'x.'
                    )
            END
        ),

    TechnicalSource =
        CONVERT
        (
            varchar(200),
            'api.v_UI_Pricing_Slices_PayrollEffective'
        )

FROM BaseRuleAgg AS b


UNION ALL


/* ================================================================
   NON-UNION CA DAILY OT
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    200,
    'CA_NONEXEMPT',
    'CA_DAILY_OT',
    'CA daily overtime',

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),
        CONCAT
        (
            'CA daily overtime: ',
            CONVERT
            (
                varchar(20),
                CONVERT(decimal(10,1), c.ComponentHours)
            ),
            'h classified as OT.'
        )
    ),

    'fms.Payroll_PayComponent'

FROM ComponentAgg AS c

WHERE c.ComponentCode =
      'NONUNION_CA_NONEXEMPT_DAILY_OT'


UNION ALL


/* ================================================================
   NON-UNION CA DAILY DT
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    210,
    'CA_NONEXEMPT',
    'CA_DAILY_DT',
    'CA daily double time',

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),
        CONCAT
        (
            'CA daily double time: ',
            CONVERT
            (
                varchar(20),
                CONVERT(decimal(10,1), c.ComponentHours)
            ),
            'h classified as DT.'
        )
    ),

    'fms.Payroll_PayComponent'

FROM ComponentAgg AS c

WHERE c.ComponentCode =
      'NONUNION_CA_NONEXEMPT_DAILY_DT'


UNION ALL


/* ================================================================
   NON-UNION CA WEEKLY OT
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    220,
    'CA_NONEXEMPT',
    'CA_WEEKLY_OT',
    'CA weekly overtime',

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),
        CONCAT
        (
            'CA weekly overtime: ',
            CONVERT
            (
                varchar(20),
                CONVERT(decimal(10,1), c.ComponentHours)
            ),
            'h moved from ST to OT after the weekly threshold.'
        )
    ),

    'fms.Payroll_PayComponent'

FROM ComponentAgg AS c

WHERE c.ComponentCode =
      'NONUNION_CA_NONEXEMPT_WEEKLY_OT'


UNION ALL


/* ================================================================
   NON-UNION CA SEVENTH DAY
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    CASE
        WHEN c.ComponentCode =
             'NONUNION_CA_NONEXEMPT_7TH_DAY_OT'
            THEN 230
        ELSE 240
    END,

    'CA_NONEXEMPT',

    c.ComponentCode,

    CASE
        WHEN c.ComponentCode =
             'NONUNION_CA_NONEXEMPT_7TH_DAY_OT'
            THEN 'CA seventh-day overtime'
        ELSE 'CA seventh-day double time'
    END,

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),
        CONCAT
        (
            'CA seventh-day rule: ',

            CONVERT
            (
                varchar(20),
                CONVERT(decimal(10,1), c.ComponentHours)
            ),

            CASE
                WHEN c.ComponentCode =
                     'NONUNION_CA_NONEXEMPT_7TH_DAY_OT'
                    THEN 'h classified as OT.'
                ELSE 'h classified as DT.'
            END
        )
    ),

    'fms.Payroll_PayComponent'

FROM ComponentAgg AS c

WHERE c.ComponentCode IN
(
    'NONUNION_CA_NONEXEMPT_7TH_DAY_OT',
    'NONUNION_CA_NONEXEMPT_7TH_DAY_DT'
)


UNION ALL


/* ================================================================
   REST PERIOD
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    300,
    'REST_PERIOD',
    'REST_PERIOD_PREMIUM',
    '8-hour rest rule',

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),

        CONCAT
        (
            '8-hour rest rule: ',

            CASE
                WHEN ISNULL(r.RaisedToOT, 0) > 0.001
                  OR ISNULL(r.RaisedToDT, 0) > 0.001

                    THEN CONCAT_WS
                    (
                        '; ',

                        CASE
                            WHEN ISNULL(r.RaisedToOT, 0) > 0.001
                                THEN CONCAT
                                (
                                    CONVERT
                                    (
                                        varchar(20),
                                        CONVERT
                                        (
                                            decimal(10,1),
                                            r.RaisedToOT
                                        )
                                    ),
                                    'h raised to OT'
                                )
                        END,

                        CASE
                            WHEN ISNULL(r.RaisedToDT, 0) > 0.001
                                THEN CONCAT
                                (
                                    CONVERT
                                    (
                                        varchar(20),
                                        CONVERT
                                        (
                                            decimal(10,1),
                                            r.RaisedToDT
                                        )
                                    ),
                                    'h raised to DT'
                                )
                        END
                    )

                ELSE CONCAT
                (
                    CONVERT
                    (
                        varchar(20),
                        CONVERT(decimal(10,1), c.ComponentHours)
                    ),
                    'h affected'
                )
            END,

            '; rest premium $',

            CONVERT
            (
                varchar(30),
                CONVERT(decimal(12,2), c.ComponentAmount)
            ),

            '.'
        )
    ),

    'fms.Payroll_PayComponent + api.v_UI_Pricing_Slices_PayrollEffective'

FROM ComponentAgg AS c

LEFT JOIN RestSliceAgg AS r
  ON r.RunId = c.RunId
 AND r.CalcID = c.CalcID
 AND r.LaborPayrollID = c.LaborPayrollID

WHERE c.ComponentCode = 'REST_PERIOD_PREMIUM'


UNION ALL


/* ================================================================
   GUARANTEED HOURS
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    400,
    'GUARANTEE',
    c.ComponentCode,

    CASE c.ComponentCode
        WHEN 'GUARANTEED_HOLIDAY_BASE_PAY_ADD'
            THEN 'Holiday minimum guarantee'

        WHEN 'GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD'
            THEN 'Special Saturday minimum guarantee'

        WHEN 'GUARANTEE_RECONCILIATION_ADJUSTMENT'
            THEN 'Guarantee reconciliation'

        ELSE 'Guaranteed hours'
    END,

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),

        CONCAT
        (
            CASE c.ComponentCode

                WHEN 'GUARANTEED_HOLIDAY_BASE_PAY_ADD'
                    THEN 'Holiday minimum guarantee: '

                WHEN 'GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD'
                    THEN 'Special Saturday minimum guarantee: '

                WHEN 'GUARANTEE_RECONCILIATION_ADJUSTMENT'
                    THEN 'Guarantee reconciliation: '

                ELSE 'Guaranteed-hours rule: '
            END,

            CASE
                WHEN c.ComponentHours > 0
                    THEN '+'
                ELSE ''
            END,

            CONVERT
            (
                varchar(20),
                CONVERT(decimal(10,1), c.ComponentHours)
            ),

            ' payable hour',

            CASE
                WHEN ABS(ABS(c.ComponentHours) - 1.0) < 0.001
                    THEN ''
                ELSE 's'
            END,

            '.'
        )
    ),

    'fms.Payroll_PayComponent'

FROM ComponentAgg AS c

WHERE c.ComponentCode IN
(
    'GUARANTEED_BASE_PAY_ADD',
    'GUARANTEED_HOLIDAY_BASE_PAY_ADD',
    'GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD',
    'GUARANTEE_RECONCILIATION_ADJUSTMENT'
)


UNION ALL


/* ================================================================
   SHIFT DIFFERENTIAL
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    500,
    'SHIFT',
    'ACTUAL_SHIFT_DIFFERENTIAL',
    'Shift differential',

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),
        CONCAT
        (
            'Shift differential: ',
            CONVERT
            (
                varchar(20),
                CONVERT(decimal(10,1), c.ComponentHours)
            ),
            ' worked hours received a $',
            CONVERT
            (
                varchar(30),
                CONVERT(decimal(12,2), c.ComponentAmount)
            ),
            ' premium.'
        )
    ),

    'fms.Payroll_PayComponent'

FROM ComponentAgg AS c

WHERE c.ComponentCode = 'ACTUAL_SHIFT_DIFFERENTIAL'


UNION ALL


/* ================================================================
   SHIFT HOURS ADD
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    CASE
        WHEN c.ComponentCode = 'SHIFT_2_HOURS_ADD'
            THEN 510
        ELSE 520
    END,

    'SHIFT',

    c.ComponentCode,

    CASE
        WHEN c.ComponentCode = 'SHIFT_2_HOURS_ADD'
            THEN '2nd Shift hours add'
        ELSE '3rd Shift hours add'
    END,

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),
        CONCAT
        (
            CASE
                WHEN c.ComponentCode = 'SHIFT_2_HOURS_ADD'
                    THEN '2nd Shift rule: +'
                ELSE '3rd Shift rule: +'
            END,

            CONVERT
            (
                varchar(20),
                CONVERT(decimal(10,1), c.ComponentHours)
            ),

            ' payable hour',

            CASE
                WHEN ABS(c.ComponentHours - 1.0) < 0.001
                    THEN ''
                ELSE 's'
            END,

            '.'
        )
    ),

    'fms.Payroll_PayComponent'

FROM ComponentAgg AS c

WHERE c.ComponentCode IN
(
    'SHIFT_2_HOURS_ADD',
    'SHIFT_3_HOURS_ADD'
)


UNION ALL


/* ================================================================
   WTL
   ================================================================ */

SELECT
    w.RunId,
    w.CalcID,
    w.LaborPayrollID,
    w.WorkDate,
    w.EmpID,
    w.Employee_Name,
    w.JobTicketID,
    w.JobCode,

    600,
    'WTL',
    'WTL',
    'WTL / meal-period rule',

    w.NetWTLHours,

    CONVERT(decimal(19,4), NULL),

    CONVERT
    (
        nvarchar(1000),

        CONCAT
        (
            'WTL: ',

            CONCAT_WS
            (
                '; ',

                CASE
                    WHEN w.MealDeduct > 0.001
                        THEN CONCAT
                        (
                            'meal deduction -',
                            CONVERT
                            (
                                varchar(20),
                                CONVERT(decimal(10,1), w.MealDeduct)
                            ),
                            'h'
                        )
                END,

                CASE
                    WHEN ABS(w.DTFloor) > 0.001
                        THEN CONCAT
                        (
                            'DT floor +',
                            CONVERT
                            (
                                varchar(20),
                                CONVERT(decimal(10,1), w.DTFloor)
                            ),
                            'h'
                        )
                END,

                CASE
                    WHEN ABS(w.ApplicableAdd) > 0.001
                        THEN CONCAT
                        (
                            'applicable add +',
                            CONVERT
                            (
                                varchar(20),
                                CONVERT(decimal(10,1), w.ApplicableAdd)
                            ),
                            'h'
                        )
                END
            ),

            '; net ',

            CASE
                WHEN w.NetWTLHours > 0.001
                    THEN '+'
                ELSE ''
            END,

            CONVERT
            (
                varchar(20),
                CONVERT(decimal(10,1), w.NetWTLHours)
            ),

            'h.'
        )
    ),

    'fms.Payroll_PayComponent'

FROM WTLAgg AS w


UNION ALL


/* ================================================================
   LONG BOOM - ACTUAL
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    700,
    'LONG_BOOM',
    'ACTUAL_BOOM_WORKED_PAY',
    'Long boom premium',

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),
        CONCAT
        (
            'Long boom premium: ',
            CONVERT
            (
                varchar(20),
                CONVERT(decimal(10,1), c.ComponentHours)
            ),
            'h; premium $',
            CONVERT
            (
                varchar(30),
                CONVERT(decimal(12,2), c.ComponentAmount)
            ),
            '.'
        )
    ),

    'fms.Payroll_PayComponent'

FROM ComponentAgg AS c

WHERE c.ComponentCode = 'ACTUAL_BOOM_WORKED_PAY'


UNION ALL


/* ================================================================
   LONG BOOM - GUARANTEE
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    710,
    'LONG_BOOM',
    'GUARANTEED_BOOM_PAY_ADD',
    'Long boom minimum guarantee',

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),
        CONCAT
        (
            'Long boom minimum guarantee: +',

            CONVERT
            (
                varchar(20),
                CONVERT(decimal(10,1), c.ComponentHours)
            ),

            ' boom hour',

            CASE
                WHEN ABS(c.ComponentHours - 1.0) < 0.001
                    THEN ''
                ELSE 's'
            END,

            '.'
        )
    ),

    'fms.Payroll_PayComponent'

FROM ComponentAgg AS c

WHERE c.ComponentCode = 'GUARANTEED_BOOM_PAY_ADD'


UNION ALL


/* ================================================================
   SUBSISTENCE
   ================================================================ */

SELECT
    c.RunId,
    c.CalcID,
    c.LaborPayrollID,
    c.WorkDate,
    c.EmpID,
    c.Employee_Name,
    c.JobTicketID,
    c.JobCode,

    800,
    'SUBSISTENCE',
    c.ComponentCode,
    'Subsistence',

    c.ComponentHours,
    c.ComponentAmount,

    CONVERT
    (
        nvarchar(1000),
        CONCAT
        (
            'Subsistence: $',

            CONVERT
            (
                varchar(30),
                CONVERT(decimal(12,2), c.ComponentAmount)
            ),

            ' - ',
            c.ComponentLabel,
            '.'
        )
    ),

    'fms.Payroll_PayComponent'

FROM ComponentAgg AS c

WHERE c.ComponentGroup = 'SUBSISTENCE';

