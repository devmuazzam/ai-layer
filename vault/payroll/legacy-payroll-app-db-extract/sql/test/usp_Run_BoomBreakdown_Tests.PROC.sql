
CREATE   PROCEDURE test.usp_Run_BoomBreakdown_Tests
    @Tol decimal(10,4) = 0.01
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Cases AS
    (
        SELECT
            sc.ScenarioID,
            sc.ScenarioCode,
            sc.ScenarioGroup,
            sc.ScenarioName,
            sc.LaborPayrollID,
            sc.Expected_Act_Boom_Hrs,
            sc.Expected_Gap_Hrs_Boom
        FROM test.Case_CorePayrollScenario sc
        WHERE sc.IsActive = 1
          AND sc.ScenarioGroup IN ('Boom', 'Special Saturday', 'Weekend', 'Time buckets', 'Slice classification')
    ),
    GuaranteeAgg AS
    (
        SELECT
            a.LaborPayrollID,
            Guarantee_BoomGap_Hrs =
                CAST(SUM(CASE WHEN a.RuleCode = 'LONG_BOOM_MIN_4' THEN a.AllocatedGapHours ELSE 0 END) AS decimal(10,4)),
            Guarantee_BoomGap_Pay =
                CAST(SUM(CASE WHEN a.RuleCode = 'LONG_BOOM_MIN_4' THEN a.AllocatedGapPay ELSE 0 END) AS decimal(12,4)),
            Guarantee_BoomAllocCount =
                SUM(CASE WHEN a.RuleCode = 'LONG_BOOM_MIN_4' THEN 1 ELSE 0 END),
            Guarantee_MaxBoomMultiplier =
                CAST(MAX(CASE WHEN a.RuleCode = 'LONG_BOOM_MIN_4' THEN a.MultiplierUsed END) AS decimal(10,4))
        FROM api.v_UI_GuaranteeAllocations a
        GROUP BY
            a.LaborPayrollID
    ),
    Base AS
    (
        SELECT
            c.*,
            b.JobTicketID,
            b.EmpID,
            b.Employee_Name,
            b.WorkDate,
            b.CraftCode,
            b.CraftModifierCode,
            b.CraftModifierDescription,
            b.CraftModifierPayRateAdjustment,
            b.BoomEligible,
            b.BoomDisplayStatus,
            b.Act_Boom_Hrs,
            b.Gap_Hrs_Boom,
            b.Slice_Boom_Window_Hrs,
            b.Slice_Boom_Hrs,
            b.Boom_Actual_Add_Amt,
            b.Boom_Gap_Add_Amt,
            b.Boom_Total_Add_Amt,
            b.Ticket_Boom_Window_Hrs,
            b.Boom_Window_Start,
            b.Boom_Window_End,
            b.First_Boom_Window_Slice_Start,
            b.Last_Boom_Window_Slice_End,
            b.First_Boom_Slice_Start,
            b.Last_Boom_Slice_End,

            Guarantee_BoomGap_Hrs = ISNULL(g.Guarantee_BoomGap_Hrs, 0),
            Guarantee_BoomGap_Pay = ISNULL(g.Guarantee_BoomGap_Pay, 0),
            Guarantee_BoomAllocCount = ISNULL(g.Guarantee_BoomAllocCount, 0),
            g.Guarantee_MaxBoomMultiplier,

            HasCraftModifier =
                CONVERT(bit,
                    CASE
                        WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), b.CraftModifierCode))), '') IS NOT NULL
                        THEN 1 ELSE 0
                    END
                )
        FROM Cases c
        LEFT JOIN api.v_UI_LaborEntry_BoomBreakdown b
            ON b.LaborPayrollID = c.LaborPayrollID
        LEFT JOIN GuaranteeAgg g
            ON g.LaborPayrollID = c.LaborPayrollID
    )
    SELECT
        ScenarioID,
        ScenarioCode,
        ScenarioGroup,
        ScenarioName,
        LaborPayrollID,

        JobTicketID,
        EmpID,
        Employee_Name,
        WorkDate,

        CraftCode,
        CraftModifierCode,
        CraftModifierDescription,
        CraftModifierPayRateAdjustment,

        BoomEligible,
        BoomDisplayStatus,

        Expected_Act_Boom_Hrs,
        Actual_Act_Boom_Hrs = Act_Boom_Hrs,

        Expected_Gap_Boom_Hrs = Expected_Gap_Hrs_Boom,
        Actual_Gap_Boom_Hrs = Gap_Hrs_Boom,

        Guarantee_BoomGap_Hrs,
        Guarantee_BoomGap_Pay,
        Guarantee_BoomAllocCount,
        Guarantee_MaxBoomMultiplier,

        Ticket_Boom_Window_Hrs,
        Slice_Boom_Window_Hrs,
        Slice_Boom_Hrs,
        Boom_Actual_Add_Amt,
        Boom_Gap_Add_Amt,
        Boom_Total_Add_Amt,

        Boom_Window_Start,
        Boom_Window_End,
        First_Boom_Window_Slice_Start,
        Last_Boom_Window_Slice_End,
        First_Boom_Slice_Start,
        Last_Boom_Slice_End,

        Pass_ActualBoomHours =
            CONVERT(bit,
                CASE
                    WHEN Expected_Act_Boom_Hrs IS NULL THEN 1
                    WHEN ABS(ISNULL(Act_Boom_Hrs,0) - Expected_Act_Boom_Hrs) <= @Tol THEN 1
                    ELSE 0
                END
            ),

        Pass_GapBoomHours =
            CONVERT(bit,
                CASE
                    WHEN Expected_Gap_Hrs_Boom IS NULL THEN 1
                    WHEN ABS(ISNULL(Gap_Hrs_Boom,0) - Expected_Gap_Hrs_Boom) <= @Tol THEN 1
                    ELSE 0
                END
            ),

        Pass_GuaranteeBoomCompat =
            CONVERT(bit,
                CASE
                    WHEN ABS(ISNULL(Gap_Hrs_Boom,0) - ISNULL(Guarantee_BoomGap_Hrs,0)) <= @Tol THEN 1
                    ELSE 0
                END
            ),

        Pass_PayableSliceBoomHours =
            CONVERT(bit,
                CASE
                    WHEN HasCraftModifier = 1
                     AND ABS(ISNULL(Slice_Boom_Hrs,0) - ISNULL(Act_Boom_Hrs,0)) <= @Tol
                        THEN 1

                    WHEN HasCraftModifier = 0
                     AND ISNULL(Slice_Boom_Hrs,0) = 0
                     AND ISNULL(Boom_Actual_Add_Amt,0) = 0
                        THEN 1

                    ELSE 0
                END
            ),

        Pass =
            CONVERT(bit,
                CASE
                    WHEN LaborPayrollID IS NOT NULL

                      AND (
                            Expected_Act_Boom_Hrs IS NULL
                         OR ABS(ISNULL(Act_Boom_Hrs,0) - Expected_Act_Boom_Hrs) <= @Tol
                      )

                      AND (
                            Expected_Gap_Hrs_Boom IS NULL
                         OR ABS(ISNULL(Gap_Hrs_Boom,0) - Expected_Gap_Hrs_Boom) <= @Tol
                      )

                      AND ABS(ISNULL(Gap_Hrs_Boom,0) - ISNULL(Guarantee_BoomGap_Hrs,0)) <= @Tol

                      AND (
                            (
                                HasCraftModifier = 1
                                AND ABS(ISNULL(Slice_Boom_Hrs,0) - ISNULL(Act_Boom_Hrs,0)) <= @Tol
                            )
                         OR (
                                HasCraftModifier = 0
                                AND ISNULL(Slice_Boom_Hrs,0) = 0
                                AND ISNULL(Boom_Actual_Add_Amt,0) = 0
                            )
                      )
                    THEN 1 ELSE 0
                END
            ),

        Finding =
            CASE
                WHEN LaborPayrollID IS NULL
                    THEN 'FAIL: Missing boom breakdown row.'

                WHEN Expected_Act_Boom_Hrs IS NOT NULL
                 AND ABS(ISNULL(Act_Boom_Hrs,0) - Expected_Act_Boom_Hrs) > @Tol
                    THEN 'FAIL: Act_Boom_Hrs mismatch.'

                WHEN Expected_Gap_Hrs_Boom IS NOT NULL
                 AND ABS(ISNULL(Gap_Hrs_Boom,0) - Expected_Gap_Hrs_Boom) > @Tol
                    THEN 'FAIL: Gap_Hrs_Boom mismatch.'

                WHEN ABS(ISNULL(Gap_Hrs_Boom,0) - ISNULL(Guarantee_BoomGap_Hrs,0)) > @Tol
                    THEN 'FAIL: Gap_Hrs_Boom does not match LONG_BOOM_MIN_4 guarantee allocation.'

                WHEN HasCraftModifier = 1
                 AND ABS(ISNULL(Slice_Boom_Hrs,0) - ISNULL(Act_Boom_Hrs,0)) > @Tol
                    THEN 'FAIL: Payable slice boom hours do not match calculated actual boom hours.'

                WHEN HasCraftModifier = 0
                 AND (ISNULL(Slice_Boom_Hrs,0) <> 0 OR ISNULL(Boom_Actual_Add_Amt,0) <> 0)
                    THEN 'FAIL: No modifier but payable boom hours/amount were shown.'

                WHEN HasCraftModifier = 0
                 AND ISNULL(Slice_Boom_Window_Hrs,0) > 0
                    THEN 'PASS: Ticket boom window shown as reference-only because no modifier exists.'

                ELSE 'PASS'
            END
    FROM Base
    ORDER BY
        ScenarioGroup,
        ScenarioCode;
END;
