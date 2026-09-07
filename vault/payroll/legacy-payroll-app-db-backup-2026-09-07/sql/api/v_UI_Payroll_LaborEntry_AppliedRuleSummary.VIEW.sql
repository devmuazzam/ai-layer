AS

WITH RuleAgg AS
(
    SELECT
        d.RunId,
        d.CalcID,
        d.LaborPayrollID,

        AppliedRuleCount =
            COUNT_BIG(*),

        AppliedPayrollRules =
            STRING_AGG
            (
                CONVERT(nvarchar(max), d.RuleText),
                N' | '
            )
            WITHIN GROUP
            (
                ORDER BY d.DisplaySort, d.RuleCode
            )

    FROM api.v_UI_Payroll_LaborEntry_AppliedRuleDetail AS d

    GROUP BY
        d.RunId,
        d.CalcID,
        d.LaborPayrollID
)

SELECT
    pc.RunId,
    pc.CalcID,
    pc.LaborPayrollID,

    WorkDate =
        CONVERT(date, pc.WorkDate),

    pc.EmpID,
    pc.Employee_Name,
    pc.JobTicketID,
    pc.JobCode,

    Hrs_ST =
        CONVERT(decimal(10,2), ISNULL(hb.Hrs_ST, 0)),

    Hrs_OT =
        CONVERT(decimal(10,2), ISNULL(hb.Hrs_OT, 0)),

    Hrs_DT =
        CONVERT(decimal(10,2), ISNULL(hb.Hrs_DT, 0)),

    Hrs_H2x =
        CONVERT(decimal(10,2), ISNULL(hb.Hrs_H2x, 0)),

    Hrs_H3x =
        CONVERT(decimal(10,2), ISNULL(hb.Hrs_H3x, 0)),

    FinalClassification =
        NULLIF
        (
            CONCAT_WS
            (
                ' / ',

                CASE
                    WHEN ABS(ISNULL(hb.Hrs_ST, 0)) > 0.001
                        THEN CONCAT
                        (
                            CONVERT
                            (
                                varchar(20),
                                CONVERT(decimal(10,1), hb.Hrs_ST)
                            ),
                            ' ST'
                        )
                END,

                CASE
                    WHEN ABS(ISNULL(hb.Hrs_OT, 0)) > 0.001
                        THEN CONCAT
                        (
                            CONVERT
                            (
                                varchar(20),
                                CONVERT(decimal(10,1), hb.Hrs_OT)
                            ),
                            ' OT'
                        )
                END,

                CASE
                    WHEN ABS(ISNULL(hb.Hrs_DT, 0)) > 0.001
                        THEN CONCAT
                        (
                            CONVERT
                            (
                                varchar(20),
                                CONVERT(decimal(10,1), hb.Hrs_DT)
                            ),
                            ' DT'
                        )
                END,

                CASE
                    WHEN ABS(ISNULL(hb.Hrs_H2x, 0)) > 0.001
                        THEN CONCAT
                        (
                            CONVERT
                            (
                                varchar(20),
                                CONVERT(decimal(10,1), hb.Hrs_H2x)
                            ),
                            ' H2x'
                        )
                END,

                CASE
                    WHEN ABS(ISNULL(hb.Hrs_H3x, 0)) > 0.001
                        THEN CONCAT
                        (
                            CONVERT
                            (
                                varchar(20),
                                CONVERT(decimal(10,1), hb.Hrs_H3x)
                            ),
                            ' H3x'
                        )
                END
            ),
            ''
        ),

    AppliedRuleCount =
        ISNULL(ra.AppliedRuleCount, 0),

    AppliedPayrollRules =
        ra.AppliedPayrollRules,

    hb.Bucket_Source

FROM fms.Payroll_Calculated AS pc

LEFT JOIN api.v_UI_Payroll_LaborEntry_HourBuckets AS hb
    ON hb.LaborPayrollID = pc.LaborPayrollID

LEFT JOIN RuleAgg AS ra
    ON ra.RunId = pc.RunId
   AND ra.CalcID = pc.CalcID
   AND ra.LaborPayrollID = pc.LaborPayrollID;

