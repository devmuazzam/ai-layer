
/* ============================================================
   32B - Patch Labor Entry UI Display Readiness Test
   SAFE CHANGE: creates/updates test procedure only

   Fix:
     Avoids referencing calculated Pass_* aliases in the same query
     block where they are created.
   ============================================================ */

CREATE   PROCEDURE test.usp_Run_LaborEntryUIDisplay_Readiness_Tests
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Base AS
    (
        SELECT
            sc.ScenarioID,
            sc.ScenarioCode,
            sc.ScenarioGroup,
            sc.ScenarioName,
            sc.LaborPayrollID,

            d.WorkDate_Date,
            d.EmpID,
            d.Employee_Name,
            d.JobTicketID,
            d.JobCode,
            d.Has_JobTicket,

            d.CraftCode,
            d.CraftDescription,
            d.CraftPayRate,
            d.CraftModifierCode,
            d.CraftModifierDescription,
            d.CraftModifierPayRateAdjustment,

            d.TimeStart_Labor,
            d.TimeEnd_Labor,
            d.HoursWorked_Raw,

            b.HasCraftModifier,
            b.BoomEligible,
            b.BoomDisplayStatus,
            b.Ticket_Boom_Window_Hrs,
            b.Slice_Boom_Window_Hrs,
            b.Slice_Boom_Hrs,
            b.Boom_Actual_Add_Amt,
            b.Boom_Gap_Add_Amt,
            b.Boom_Total_Add_Amt
        FROM test.Case_CorePayrollScenario sc
        LEFT JOIN api.v_Payroll_LaborEntry_WeekDetail d
            ON d.LaborPayrollID = sc.LaborPayrollID
        LEFT JOIN api.v_UI_LaborEntry_BoomBreakdown b
            ON b.LaborPayrollID = sc.LaborPayrollID
        WHERE sc.IsActive = 1
    ),
    Flags AS
    (
        SELECT
            Base.*,

            Pass_WeekDetailRow =
                CONVERT(bit, CASE WHEN WorkDate_Date IS NOT NULL THEN 1 ELSE 0 END),

            Pass_CraftCode =
                CONVERT(bit, CASE WHEN NULLIF(LTRIM(RTRIM(CraftCode)), '') IS NOT NULL THEN 1 ELSE 0 END),

            Pass_CraftDescription =
                CONVERT(bit, CASE WHEN NULLIF(LTRIM(RTRIM(CraftDescription)), '') IS NOT NULL THEN 1 ELSE 0 END),

            Pass_CraftRate =
                CONVERT(bit, CASE WHEN CraftPayRate IS NOT NULL THEN 1 ELSE 0 END),

            Pass_BoomBreakdownRow =
                CONVERT(bit, CASE WHEN BoomDisplayStatus IS NOT NULL THEN 1 ELSE 0 END),

            Pass_BoomStatus =
                CONVERT(bit, CASE WHEN NULLIF(LTRIM(RTRIM(BoomDisplayStatus)), '') IS NOT NULL THEN 1 ELSE 0 END),

            Pass_BoomAmounts =
                CONVERT(bit,
                    CASE
                        WHEN Boom_Actual_Add_Amt IS NOT NULL
                         AND Boom_Gap_Add_Amt IS NOT NULL
                         AND Boom_Total_Add_Amt IS NOT NULL
                        THEN 1 ELSE 0
                    END
                )
        FROM Base
    ),
    Results AS
    (
        SELECT
            Flags.*,

            Pass =
                CONVERT(bit,
                    CASE
                        WHEN Pass_WeekDetailRow = 1
                         AND Pass_CraftCode = 1
                         AND Pass_CraftDescription = 1
                         AND Pass_CraftRate = 1
                         AND Pass_BoomBreakdownRow = 1
                         AND Pass_BoomStatus = 1
                         AND Pass_BoomAmounts = 1
                        THEN 1 ELSE 0
                    END
                ),

            Finding =
                CASE
                    WHEN Pass_WeekDetailRow = 0 THEN 'FAIL: Missing api.v_Payroll_LaborEntry_WeekDetail row.'
                    WHEN Pass_CraftCode = 0 THEN 'FAIL: CraftCode missing.'
                    WHEN Pass_CraftDescription = 0 THEN 'FAIL: CraftDescription missing.'
                    WHEN Pass_CraftRate = 0 THEN 'FAIL: CraftPayRate missing.'
                    WHEN Pass_BoomBreakdownRow = 0 THEN 'FAIL: Missing api.v_UI_LaborEntry_BoomBreakdown row.'
                    WHEN Pass_BoomStatus = 0 THEN 'FAIL: BoomDisplayStatus missing.'
                    WHEN Pass_BoomAmounts = 0 THEN 'FAIL: Boom amount fields missing.'
                    ELSE 'PASS'
                END
        FROM Flags
    )
    SELECT
        TotalScenarios = COUNT_BIG(*),
        PassedScenarios = SUM(CASE WHEN Pass = 1 THEN 1 ELSE 0 END),
        FailedScenarios = SUM(CASE WHEN Pass = 0 THEN 1 ELSE 0 END),
        OverallPass =
            CONVERT(bit,
                CASE
                    WHEN COUNT_BIG(*) > 0
                     AND SUM(CASE WHEN Pass = 0 THEN 1 ELSE 0 END) = 0
                    THEN 1 ELSE 0
                END
            )
    FROM Results;

    ;WITH Base AS
    (
        SELECT
            sc.ScenarioID,
            sc.ScenarioCode,
            sc.ScenarioGroup,
            sc.ScenarioName,
            sc.LaborPayrollID,

            d.WorkDate_Date,
            d.EmpID,
            d.Employee_Name,
            d.JobTicketID,
            d.JobCode,
            d.Has_JobTicket,

            d.CraftCode,
            d.CraftDescription,
            d.CraftPayRate,
            d.CraftModifierCode,
            d.CraftModifierDescription,
            d.CraftModifierPayRateAdjustment,

            d.TimeStart_Labor,
            d.TimeEnd_Labor,
            d.HoursWorked_Raw,

            b.HasCraftModifier,
            b.BoomEligible,
            b.BoomDisplayStatus,
            b.Ticket_Boom_Window_Hrs,
            b.Slice_Boom_Window_Hrs,
            b.Slice_Boom_Hrs,
            b.Boom_Actual_Add_Amt,
            b.Boom_Gap_Add_Amt,
            b.Boom_Total_Add_Amt
        FROM test.Case_CorePayrollScenario sc
        LEFT JOIN api.v_Payroll_LaborEntry_WeekDetail d
            ON d.LaborPayrollID = sc.LaborPayrollID
        LEFT JOIN api.v_UI_LaborEntry_BoomBreakdown b
            ON b.LaborPayrollID = sc.LaborPayrollID
        WHERE sc.IsActive = 1
    ),
    Flags AS
    (
        SELECT
            Base.*,

            Pass_WeekDetailRow =
                CONVERT(bit, CASE WHEN WorkDate_Date IS NOT NULL THEN 1 ELSE 0 END),

            Pass_CraftCode =
                CONVERT(bit, CASE WHEN NULLIF(LTRIM(RTRIM(CraftCode)), '') IS NOT NULL THEN 1 ELSE 0 END),

            Pass_CraftDescription =
                CONVERT(bit, CASE WHEN NULLIF(LTRIM(RTRIM(CraftDescription)), '') IS NOT NULL THEN 1 ELSE 0 END),

            Pass_CraftRate =
                CONVERT(bit, CASE WHEN CraftPayRate IS NOT NULL THEN 1 ELSE 0 END),

            Pass_BoomBreakdownRow =
                CONVERT(bit, CASE WHEN BoomDisplayStatus IS NOT NULL THEN 1 ELSE 0 END),

            Pass_BoomStatus =
                CONVERT(bit, CASE WHEN NULLIF(LTRIM(RTRIM(BoomDisplayStatus)), '') IS NOT NULL THEN 1 ELSE 0 END),

            Pass_BoomAmounts =
                CONVERT(bit,
                    CASE
                        WHEN Boom_Actual_Add_Amt IS NOT NULL
                         AND Boom_Gap_Add_Amt IS NOT NULL
                         AND Boom_Total_Add_Amt IS NOT NULL
                        THEN 1 ELSE 0
                    END
                )
        FROM Base
    ),
    Results AS
    (
        SELECT
            Flags.*,

            Pass =
                CONVERT(bit,
                    CASE
                        WHEN Pass_WeekDetailRow = 1
                         AND Pass_CraftCode = 1
                         AND Pass_CraftDescription = 1
                         AND Pass_CraftRate = 1
                         AND Pass_BoomBreakdownRow = 1
                         AND Pass_BoomStatus = 1
                         AND Pass_BoomAmounts = 1
                        THEN 1 ELSE 0
                    END
                ),

            Finding =
                CASE
                    WHEN Pass_WeekDetailRow = 0 THEN 'FAIL: Missing api.v_Payroll_LaborEntry_WeekDetail row.'
                    WHEN Pass_CraftCode = 0 THEN 'FAIL: CraftCode missing.'
                    WHEN Pass_CraftDescription = 0 THEN 'FAIL: CraftDescription missing.'
                    WHEN Pass_CraftRate = 0 THEN 'FAIL: CraftPayRate missing.'
                    WHEN Pass_BoomBreakdownRow = 0 THEN 'FAIL: Missing api.v_UI_LaborEntry_BoomBreakdown row.'
                    WHEN Pass_BoomStatus = 0 THEN 'FAIL: BoomDisplayStatus missing.'
                    WHEN Pass_BoomAmounts = 0 THEN 'FAIL: Boom amount fields missing.'
                    ELSE 'PASS'
                END
        FROM Flags
    )
    SELECT
        ScenarioID,
        ScenarioCode,
        ScenarioGroup,
        ScenarioName,
        LaborPayrollID,

        WorkDate_Date,
        EmpID,
        Employee_Name,
        JobTicketID,
        JobCode,
        Has_JobTicket,

        CraftCode,
        CraftDescription,
        CraftPayRate,
        CraftModifierCode,
        CraftModifierDescription,
        CraftModifierPayRateAdjustment,

        TimeStart_Labor,
        TimeEnd_Labor,
        HoursWorked_Raw,

        HasCraftModifier,
        BoomEligible,
        BoomDisplayStatus,
        Ticket_Boom_Window_Hrs,
        Slice_Boom_Window_Hrs,
        Slice_Boom_Hrs,
        Boom_Actual_Add_Amt,
        Boom_Gap_Add_Amt,
        Boom_Total_Add_Amt,

        Pass_WeekDetailRow,
        Pass_CraftCode,
        Pass_CraftDescription,
        Pass_CraftRate,
        Pass_BoomBreakdownRow,
        Pass_BoomStatus,
        Pass_BoomAmounts,
        Pass,
        Finding
    FROM Results
    ORDER BY
        ScenarioGroup,
        ScenarioCode;
END;
