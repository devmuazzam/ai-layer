CREATE   VIEW
    [api].[v_UI_Payroll_EmployeeDay_AppliedRuleSummary]
AS

/*==============================================================
  UX-RULE-10C
  EMPLOYEE/DAY APPLIED RULE SUMMARY
  COMPACT DUPLICATE-RULE PRESENTATION

  Purpose:
    Produce one complete payroll-facing Applied Rules explanation
    per employee / work date.

  Presentation rules:
    - Distinct rule messages remain separate.
    - Identical RuleText occurring on multiple labor entries is
      displayed once.
    - Collapsed duplicate lines identify:
          * number of labor entries
          * combined affected hours
    - Duplicate REST_PERIOD_PREMIUM lines also identify:
          * combined rest-premium amount
    - Duplicate annotations use compact wording for Excel.

  Examples:
      (2 entries; 10.0h total)

      (2 entries; 10.0h total; $348.30 premium total)

  IMPORTANT:
    AppliedRuleCount continues to represent the number of
    underlying rule applications, NOT the number of displayed
    text lines.

  NO PAYROLL CALCULATION LOGIC IS CHANGED.
==============================================================*/

WITH DayBase AS
(
    SELECT
        s.RunId,
        s.EmpID,
        s.WorkDate,

        Employee_Name =
            MAX(s.Employee_Name),

        LaborEntryCount =
            COUNT_BIG(*),

        Hrs_ST =
            CONVERT
            (
                decimal(10,2),
                SUM(ISNULL(s.Hrs_ST, 0))
            ),

        Hrs_OT =
            CONVERT
            (
                decimal(10,2),
                SUM(ISNULL(s.Hrs_OT, 0))
            ),

        Hrs_DT =
            CONVERT
            (
                decimal(10,2),
                SUM(ISNULL(s.Hrs_DT, 0))
            ),

        Hrs_H2x =
            CONVERT
            (
                decimal(10,2),
                SUM(ISNULL(s.Hrs_H2x, 0))
            ),

        Hrs_H3x =
            CONVERT
            (
                decimal(10,2),
                SUM(ISNULL(s.Hrs_H3x, 0))
            )

    FROM api.v_UI_Payroll_LaborEntry_AppliedRuleSummary AS s

    GROUP BY
        s.RunId,
        s.EmpID,
        s.WorkDate
),


/*==============================================================
  Group only EXACTLY IDENTICAL employee/day rule messages.

  Different messages under the same RuleCode remain separate.

  Example:
      Outside regular work hours: 1.5h at 1.5x.
      Outside regular work hours: 5.0h at 1.5x.

  remain separate.

  But two identical:
      Outside regular work hours: 5.0h at 1.5x.

  are collapsed into one displayed line with combined totals.
==============================================================*/
RuleTextGroups AS
(
    SELECT
        d.RunId,
        d.EmpID,
        d.WorkDate,

        d.RuleCategory,
        d.RuleCode,
        d.RuleName,
        d.RuleText,

        DisplaySort =
            MIN(d.DisplaySort),

        FirstLaborPayrollID =
            MIN(d.LaborPayrollID),

        Occurrences =
            COUNT_BIG(*),

        LaborEntries =
            COUNT(DISTINCT d.LaborPayrollID),

        TotalAffectedHours =
            CONVERT
            (
                decimal(10,2),
                SUM(ISNULL(d.AffectedHours, 0))
            ),

        TotalAmount =
            CONVERT
            (
                decimal(19,4),
                SUM(ISNULL(d.Amount, 0))
            )

    FROM api.v_UI_Payroll_LaborEntry_AppliedRuleDetail AS d

    GROUP BY
        d.RunId,
        d.EmpID,
        d.WorkDate,
        d.RuleCategory,
        d.RuleCode,
        d.RuleName,
        d.RuleText
),


/*==============================================================
  Build employee/day display text.

  Single applications:
      preserve the existing RuleText exactly.

  Repeated ordinary effects:
      RuleText (2 entries; 10.0h total)

  Repeated rest-period effects:
      RuleText
      (2 entries; 10.0h total; $348.30 premium total)

  This changes presentation only.
==============================================================*/
DisplayRules AS
(
    SELECT
        g.RunId,
        g.EmpID,
        g.WorkDate,

        g.DisplaySort,
        g.FirstLaborPayrollID,
        g.RuleCode,

        g.Occurrences,

        DisplayRuleText =
            CONVERT
            (
                nvarchar(max),

                CASE

                    ----------------------------------------------------------
                    -- Single rule application
                    -- Preserve existing wording exactly.
                    ----------------------------------------------------------
                    WHEN g.Occurrences = 1
                        THEN g.RuleText


                    ----------------------------------------------------------
                    -- Repeated rest-period effect
                    ----------------------------------------------------------
                    WHEN g.RuleCode = 'REST_PERIOD_PREMIUM'
                        THEN
                            CONCAT
                            (
                                g.RuleText,
                                ' (',
                                CONVERT
                                (
                                    varchar(20),
                                    g.LaborEntries
                                ),
                                CASE
                                    WHEN g.LaborEntries = 1
                                        THEN ' entry; '
                                    ELSE
                                        ' entries; '
                                END,
                                CONVERT
                                (
                                    varchar(20),
                                    CONVERT
                                    (
                                        decimal(10,1),
                                        g.TotalAffectedHours
                                    )
                                ),
                                'h total',

                                CASE
                                    WHEN ABS(g.TotalAmount) > 0.005
                                        THEN
                                            CONCAT
                                            (
                                                '; $',
                                                CONVERT
                                                (
                                                    varchar(30),
                                                    CONVERT
                                                    (
                                                        decimal(19,2),
                                                        g.TotalAmount
                                                    )
                                                ),
                                                ' premium total'
                                            )
                                    ELSE
                                        ''
                                END,

                                ')'
                            )


                    ----------------------------------------------------------
                    -- Other repeated effects with meaningful affected hours
                    ----------------------------------------------------------
                    WHEN ABS(g.TotalAffectedHours) > 0.001
                        THEN
                            CONCAT
                            (
                                g.RuleText,
                                ' (',
                                CONVERT
                                (
                                    varchar(20),
                                    g.LaborEntries
                                ),
                                CASE
                                    WHEN g.LaborEntries = 1
                                        THEN ' entry; '
                                    ELSE
                                        ' entries; '
                                END,
                                CONVERT
                                (
                                    varchar(20),
                                    CONVERT
                                    (
                                        decimal(10,1),
                                        g.TotalAffectedHours
                                    )
                                ),
                                'h total)'
                            )


                    ----------------------------------------------------------
                    -- Fallback for repeated effects without meaningful
                    -- AffectedHours
                    ----------------------------------------------------------
                    ELSE
                        CONCAT
                        (
                            g.RuleText,
                            ' (',
                            CONVERT
                            (
                                varchar(20),
                                g.LaborEntries
                            ),
                            CASE
                                WHEN g.LaborEntries = 1
                                    THEN ' entry)'
                                ELSE
                                    ' entries)'
                            END
                        )

                END
            )

    FROM RuleTextGroups AS g
),


/*==============================================================
  Aggregate the displayed rule lines back to employee/day.

  AppliedRuleCount deliberately retains the RAW number of
  underlying rule applications.

  Therefore:
      AppliedRuleCount
          may be greater than
      number of displayed AppliedPayrollRules lines.

  This is intentional.
==============================================================*/
RuleAgg AS
(
    SELECT
        r.RunId,
        r.EmpID,
        r.WorkDate,

        AppliedRuleCount =
            SUM(r.Occurrences),

        AppliedPayrollRules =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    r.DisplayRuleText
                ),
                N' | '
            )
            WITHIN GROUP
            (
                ORDER BY
                    r.DisplaySort,
                    r.FirstLaborPayrollID,
                    r.RuleCode
            )

    FROM DisplayRules AS r

    GROUP BY
        r.RunId,
        r.EmpID,
        r.WorkDate
)


SELECT
    b.RunId,
    b.EmpID,
    b.Employee_Name,
    b.WorkDate,

    b.LaborEntryCount,

    b.Hrs_ST,
    b.Hrs_OT,
    b.Hrs_DT,
    b.Hrs_H2x,
    b.Hrs_H3x,

    FinalClassification =
        NULLIF
        (
            CONCAT_WS
            (
                ' / ',

                CASE
                    WHEN ABS(b.Hrs_ST) > 0.001
                        THEN
                            CONCAT
                            (
                                CONVERT
                                (
                                    varchar(20),
                                    CONVERT
                                    (
                                        decimal(10,1),
                                        b.Hrs_ST
                                    )
                                ),
                                ' ST'
                            )
                END,

                CASE
                    WHEN ABS(b.Hrs_OT) > 0.001
                        THEN
                            CONCAT
                            (
                                CONVERT
                                (
                                    varchar(20),
                                    CONVERT
                                    (
                                        decimal(10,1),
                                        b.Hrs_OT
                                    )
                                ),
                                ' OT'
                            )
                END,

                CASE
                    WHEN ABS(b.Hrs_DT) > 0.001
                        THEN
                            CONCAT
                            (
                                CONVERT
                                (
                                    varchar(20),
                                    CONVERT
                                    (
                                        decimal(10,1),
                                        b.Hrs_DT
                                    )
                                ),
                                ' DT'
                            )
                END,

                CASE
                    WHEN ABS(b.Hrs_H2x) > 0.001
                        THEN
                            CONCAT
                            (
                                CONVERT
                                (
                                    varchar(20),
                                    CONVERT
                                    (
                                        decimal(10,1),
                                        b.Hrs_H2x
                                    )
                                ),
                                ' H2x'
                            )
                END,

                CASE
                    WHEN ABS(b.Hrs_H3x) > 0.001
                        THEN
                            CONCAT
                            (
                                CONVERT
                                (
                                    varchar(20),
                                    CONVERT
                                    (
                                        decimal(10,1),
                                        b.Hrs_H3x
                                    )
                                ),
                                ' H3x'
                            )
                END

            ),
            ''
        ),

    AppliedRuleCount =
        ISNULL
        (
            r.AppliedRuleCount,
            0
        ),

    AppliedPayrollRules =
        r.AppliedPayrollRules

FROM DayBase AS b

LEFT JOIN RuleAgg AS r
    ON r.RunId = b.RunId
   AND r.EmpID = b.EmpID
   AND r.WorkDate = b.WorkDate;

