

/* ============================================================
   22 - Patch audit packet after Special Saturday slice fix
   SAFE CHANGE: alters test procedure only
   ============================================================ */

CREATE       PROCEDURE [test].[usp_Get_CorePayrollScenario_AuditPacket]
      @ScenarioCode varchar(80) = NULL
    , @LaborPayrollID int = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @ScenarioCode IS NULL AND @LaborPayrollID IS NULL
        THROW 51000, 'Provide either @ScenarioCode or @LaborPayrollID.', 1;

    IF OBJECT_ID('tempdb..#Scenario') IS NOT NULL
        DROP TABLE #Scenario;

    SELECT
        sc.*
    INTO #Scenario
    FROM test.Case_CorePayrollScenario sc
    WHERE
        (@ScenarioCode IS NULL OR sc.ScenarioCode = @ScenarioCode)
        AND (@LaborPayrollID IS NULL OR sc.LaborPayrollID = @LaborPayrollID);

    IF NOT EXISTS (SELECT 1 FROM #Scenario)
        THROW 51001, 'No matching scenario found in test.Case_CorePayrollScenario.', 1;


    SELECT
        Section = '01 Scenario + Final Calculated Output',
        sc.ScenarioID,
        sc.ScenarioCode,
        sc.ScenarioGroup,
        sc.ScenarioName,
        sc.IsKnownIssue,
        sc.KnownIssueNote,
        sc.Notes,
        pc.LaborPayrollID,
        pc.EmpID,
        pc.Employee_Name,
        WorkDate = CONVERT(date, pc.WorkDate),
        WeekdayName = DATENAME(weekday, pc.WorkDate),
        pc.JobTicketID,
        pc.JobCode,
        pc.Act_Total_Hrs,
        sc.Expected_Act_Total_Hrs,
        pc.Act_Boom_Hrs,
        sc.Expected_Act_Boom_Hrs,
        pc.Gap_Hrs_Total,
        sc.Expected_Gap_Hrs_Total,
        pc.Gap_Hrs_Boom,
        sc.Expected_Gap_Hrs_Boom,
        pc.Pay_Total_Hrs,
        sc.Expected_Pay_Total_Hrs,
        pc.Hrs_ST,
        sc.Expected_Hrs_ST,
        pc.Hrs_OT,
        sc.Expected_Hrs_OT,
        pc.Hrs_DT,
        sc.Expected_Hrs_DT,
        pc.Pay_Actual_Gross,
        pc.Pay_Gap_Add,
        pc.Pay_Rest_Add,
        pc.Final_Gross_Pay,
        Expected_Final_CleanRestSemantics =
            CONVERT(decimal(19,4),
                ISNULL(pc.Pay_Actual_Gross,0) + ISNULL(pc.Pay_Gap_Add,0) + ISNULL(pc.Pay_Rest_Add,0)
            ),
        Difference_Final_Minus_CleanRestSemantics =
            CONVERT(decimal(19,4),
                ISNULL(pc.Final_Gross_Pay,0)
              - (ISNULL(pc.Pay_Actual_Gross,0) + ISNULL(pc.Pay_Gap_Add,0) + ISNULL(pc.Pay_Rest_Add,0))
            ),
        pc.Audit_Min_Rule,
        sc.Expected_Audit_Min_Rule,
        pc.Audit_Gap_Mult,
        sc.Expected_Audit_Gap_Mult,
        pc.Rest_IsForced,
        sc.Expected_Rest_IsForced,
        pc.Rest_IsOverlap,
        sc.Expected_Rest_IsOverlap,
        pc.Rest_Gap_Hrs_FromPrevChain,
        pc.Rest_Premium_Hrs,
        sc.Expected_Rest_Premium_Hrs,
        pc.Rest_Policy,
        pc.CalculatedAt
    FROM #Scenario sc
    LEFT JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = sc.LaborPayrollID
    ORDER BY sc.ScenarioID;


    SELECT
        Section = '02 Base Labor Source',
        sc.ScenarioCode,
        sc.ScenarioName,
        blp.LaborPayrollID,
        blp.EmpID,
        blp.Employee_Name,
        WorkDate = CONVERT(date, blp.WorkDate),
        blp.JobTicketID,
        blp.JobCode,
        blp.Shift_Code_Raw,
        blp.CraftCode,
        blp.CraftPayRate,
        blp.CraftModifierCode,
        blp.CraftModifierDescription,
        blp.CraftModifierPayRateAdjustment,
        blp.Source_Rate_Raw,
        blp.Source_Amount_Raw,
        blp.HoursWorked_Raw,
        blp.TimeStart_Labor,
        blp.TimeEnd_Labor,
        blp.WorkedThruLunch,
        blp.LaborType,
        blp.Is_AtomLabor
    FROM #Scenario sc
    LEFT JOIN app.v_Base_LaborPayroll blp
        ON blp.LaborPayrollID = sc.LaborPayrollID
    ORDER BY sc.ScenarioID;


    SELECT
        Section = '03 Labor Timeline / Rest Continuity',
        sc.ScenarioCode,
        sc.ScenarioName,
        t.*,
        DurationHours =
            CONVERT(decimal(10,2),
                CASE
                    WHEN t.Pay_Start_Rounded IS NULL
                      OR t.Pay_End_Rounded IS NULL
                      OR t.Pay_End_Rounded <= t.Pay_Start_Rounded
                    THEN NULL
                    ELSE DATEDIFF(MINUTE, t.Pay_Start_Rounded, t.Pay_End_Rounded) / 60.0
                END
            )
    FROM #Scenario sc
    LEFT JOIN calc.v_Calc_Labor_Timeline t
        ON t.LaborPayrollID = sc.LaborPayrollID
    ORDER BY
        sc.ScenarioID,
        t.Pay_Start_Rounded,
        t.LaborPayrollID;


    SELECT
        Section = '04 Previous Labor Timeline Row',
        sc.ScenarioCode,
        sc.ScenarioName,
        sc.PrevLaborPayrollID,
        t.*
    FROM #Scenario sc
    LEFT JOIN calc.v_Calc_Labor_Timeline t
        ON t.LaborPayrollID = sc.PrevLaborPayrollID
    WHERE sc.PrevLaborPayrollID IS NOT NULL
    ORDER BY
        sc.ScenarioID,
        t.Pay_Start_Rounded;


    SELECT
        Section = '05 Ticket Timeline',
        sc.ScenarioCode,
        sc.ScenarioName,
        pc.LaborPayrollID,
        pc.JobTicketID,
        tt.TicketDate,
        tt.JobCode,
        tt.Shift_Window_Start,
        tt.Shift_Window_End,
        Shift_Window_Hrs =
            CONVERT(decimal(10,2),
                CASE
                    WHEN tt.Shift_Window_Start IS NULL
                      OR tt.Shift_Window_End IS NULL
                      OR tt.Shift_Window_End <= tt.Shift_Window_Start
                    THEN NULL
                    ELSE DATEDIFF(MINUTE, tt.Shift_Window_Start, tt.Shift_Window_End) / 60.0
                END
            ),
        tt.Boom_Window_Start,
        tt.Boom_Window_End,
        Boom_Window_Hrs =
            CONVERT(decimal(10,2),
                CASE
                    WHEN tt.Boom_Window_Start IS NULL
                      OR tt.Boom_Window_End IS NULL
                      OR tt.Boom_Window_End <= tt.Boom_Window_Start
                    THEN NULL
                    ELSE DATEDIFF(MINUTE, tt.Boom_Window_Start, tt.Boom_Window_End) / 60.0
                END
            ),
        tt.Shift_Source_Start,
        tt.Shift_Source_End,
        tt.Boom_Source_Start,
        tt.Boom_Source_End,
        tt.Act_BoomStart,
        tt.Act_BoomEnd,
        tt.CalculatedAt
    FROM #Scenario sc
    LEFT JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = sc.LaborPayrollID
    LEFT JOIN calc.TicketTimeline tt
        ON tt.JobTicketID = pc.JobTicketID
    ORDER BY sc.ScenarioID;


    SELECT
        Section = '06 Slice Summary',
        sc.ScenarioCode,
        sc.ScenarioName,
        sc.IsKnownIssue,
        sc.KnownIssueNote,

        SliceView_TrustedForPayMath =
            CONVERT(bit,
                CASE
                    WHEN sc.ScenarioCode LIKE 'REST_%' THEN 0
                    ELSE 1
                END
            ),

        SliceView_Caution =
            CASE
                WHEN sc.ScenarioCode LIKE 'REST_%'
                    THEN 'Slice view excludes rest premium add; Pay_Actual_Gross now excludes rest premium and should align to slice pay.'
                ELSE NULL
            END,

        s.LaborPayrollID,
        SliceCount = COUNT_BIG(s.LaborPayrollID),
        SliceHours = SUM(s.Slice_Hours),
        FirstSliceStart = MIN(s.Slice_Start),
        LastSliceEnd = MAX(s.Slice_End),

        Accum_Reg_Daily_Hrs =
            SUM(CASE WHEN s.Accumulation_Status = 'Reg_Daily' THEN s.Slice_Hours ELSE 0 END),
        Accum_OT_Daily_Hrs =
            SUM(CASE WHEN s.Accumulation_Status = 'OT_Daily' THEN s.Slice_Hours ELSE 0 END),
        Accum_DT_Daily_Hrs =
            SUM(CASE WHEN s.Accumulation_Status = 'DT_Daily' THEN s.Slice_Hours ELSE 0 END),

        PayBucket_ST_Hrs =
            SUM(CASE WHEN s.Final_Multiplier = 1.00 THEN s.Slice_Hours ELSE 0 END),
        PayBucket_OT_Hrs =
            SUM(CASE WHEN s.Final_Multiplier = 1.50 THEN s.Slice_Hours ELSE 0 END),
        PayBucket_DT_Hrs =
            SUM(CASE WHEN s.Final_Multiplier >= 2.00 THEN s.Slice_Hours ELSE 0 END),

        Boom_Hrs =
            SUM(CASE WHEN s.Is_Boom_Active = 1 THEN s.Slice_Hours ELSE 0 END),
        Outside_Window_Hrs =
            SUM(CASE WHEN s.Is_Outside_Window = 1 THEN s.Slice_Hours ELSE 0 END),

        Min_Day_Type = MIN(s.Day_Type),
        Max_Day_Type = MAX(s.Day_Type),
        Min_Multiplier = MIN(s.Final_Multiplier),
        Max_Multiplier = MAX(s.Final_Multiplier),
        SlicePay_Total = SUM(s.Slice_Pay)
    FROM #Scenario sc
    LEFT JOIN api.v_UI_Pricing_Slices_Advanced s
        ON s.LaborPayrollID = sc.LaborPayrollID
    GROUP BY
        sc.ScenarioID,
        sc.ScenarioCode,
        sc.ScenarioName,
        sc.IsKnownIssue,
        sc.KnownIssueNote,
        s.LaborPayrollID
    ORDER BY sc.ScenarioID;


    SELECT
        Section = '07 Slice Distribution',
        sc.ScenarioCode,
        sc.ScenarioName,
        s.LaborPayrollID,
        s.Day_Type,
        s.Accumulation_Status,
        PayBucket =
            CASE
                WHEN s.Final_Multiplier IS NULL THEN NULL
                WHEN s.Final_Multiplier >= 2.00 THEN 'DT'
                WHEN s.Final_Multiplier = 1.50 THEN 'OT'
                WHEN s.Final_Multiplier = 1.00 THEN 'ST'
                ELSE CONCAT('MULT_', CONVERT(varchar(20), s.Final_Multiplier))
            END,
        s.Final_Multiplier,
        s.Is_Boom_Active,
        s.Is_Outside_Window,
        SliceCount = COUNT_BIG(*),
        Hours = SUM(s.Slice_Hours),
        SlicePay_Total = SUM(s.Slice_Pay),
        FirstSliceStart = MIN(s.Slice_Start),
        LastSliceEnd = MAX(s.Slice_End)
    FROM #Scenario sc
    LEFT JOIN api.v_UI_Pricing_Slices_Advanced s
        ON s.LaborPayrollID = sc.LaborPayrollID
    GROUP BY
        sc.ScenarioID,
        sc.ScenarioCode,
        sc.ScenarioName,
        s.LaborPayrollID,
        s.Day_Type,
        s.Accumulation_Status,
        s.Final_Multiplier,
        s.Is_Boom_Active,
        s.Is_Outside_Window
    ORDER BY
        sc.ScenarioID,
        s.Day_Type,
        s.Accumulation_Status,
        s.Final_Multiplier,
        s.Is_Boom_Active,
        s.Is_Outside_Window;


    SELECT
        Section = '08 Exceptions / Warnings',
        sc.ScenarioCode,
        sc.ScenarioName,
        e.CalcRunAt,
        e.RunId,
        e.Reason,
        e.LaborPayrollID,
        e.WorkDate,
        e.EmpID,
        e.EmpID_Raw,
        e.Employee_Name,
        e.JobTicketID,
        e.JobCode,
        e.Shift_Start,
        e.Shift_End
    FROM #Scenario sc
    LEFT JOIN fms.Payroll_CalcException e
        ON e.LaborPayrollID = sc.LaborPayrollID
    ORDER BY
        sc.ScenarioID,
        e.CalcRunAt DESC,
        e.RunId DESC;

    SELECT
        Section = '09 Guarantee Allocations',
        sc.ScenarioCode,
        sc.ScenarioName,
        a.GuaranteeAllocationID,
        a.GuaranteeGroupID,
        a.RunId,
        a.RuleCode,
        a.RuleName,
        a.ScopeBasis,
        a.GroupScope,
        a.EmpID,
        a.Employee_Name,
        a.ShiftAnchorDate,
        a.CalendarDate,
        a.GuaranteeDate,
        a.LaborPayrollID,
        a.JobTicketID,
        a.JobCode,
        a.WorkDate,
        a.AllocatedDate,
        a.AllocatedGapHours,
        a.AllocatedGapPay,
        a.AllocationMethod,
        a.RateBaseUsed,
        a.RateShiftUsed,
        a.RateBoomUsed,
        a.MultiplierUsed,
        a.Explanation,
        a.CalculatedAtUTC
    FROM #Scenario sc
    LEFT JOIN api.v_UI_GuaranteeAllocations a
        ON a.LaborPayrollID = sc.LaborPayrollID
    ORDER BY
        sc.ScenarioID,
        a.GuaranteeDate,
        a.RuleCode,
        a.GuaranteeAllocationID;

    SELECT DISTINCT
        Section = '10 Guarantee Groups Related To Scenario',
        sc.ScenarioCode,
        sc.ScenarioName,
        g.GuaranteeGroupID,
        g.RunId,
        g.RuleCode,
        g.RuleName,
        g.ScopeBasis,
        g.GroupScope,
        g.EmpID,
        g.Employee_Name,
        g.ShiftAnchorDate,
        g.CalendarDate,
        g.GuaranteeDate,
        g.ActualQualifyingHours,
        g.MinimumHours,
        g.GapHours,
        g.PayComponent,
        g.MultiplierUsed,
        g.TriggeredFlag,
        g.SatisfiedFlag,
        g.WorkDateFrom,
        g.WorkDateTo,
        g.CalculatedAtUTC
    FROM #Scenario sc
    LEFT JOIN api.v_UI_GuaranteeAllocations a
        ON a.LaborPayrollID = sc.LaborPayrollID
    LEFT JOIN api.v_UI_GuaranteeGroups g
        ON g.GuaranteeGroupID = a.GuaranteeGroupID
    ORDER BY
        sc.ScenarioID,
        g.GuaranteeDate,
        g.RuleCode,
        g.GuaranteeGroupID;

END;
