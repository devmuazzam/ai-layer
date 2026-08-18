
/* ============================================================
   WTL Phase 1C - Permanent preview procedure

   Creates:
   - app.usp_Preview_WTL_PayComponents

   Purpose:
   - Uses cfg.WTL_Rule
   - Uses cfg.WTL_MaxMealThreshold
   - Uses app.v_LaborPayroll_CommentTokens WTL fields
   - Groups labor using configured lookback/lookahead
   - Returns WTL candidate components and warning/error summaries

   This procedure is read-only.
   It does not update payroll tables.
   ============================================================ */

CREATE   PROCEDURE app.usp_Preview_WTL_PayComponents
    @WorkDateFrom date,
    @WorkDateTo   date,
    @UnionCode    varchar(20) = 'L12'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @MealPeriodHours decimal(10,2),
        @GroupLookbackDays int,
        @GroupLookaheadDays int,
        @StitchGapMinutes int,
        @MissingTokenBehavior varchar(50),
        @MealAssignmentPolicy varchar(100),
        @WeekdaySTStartMode varchar(50),
        @NonSTStartMode varchar(50),
        @SaturdayMode varchar(50),
        @SundayMode varchar(50),
        @SpecialSaturdayMode varchar(50),
        @HolidayMode varchar(50),
        @AddRateBasis varchar(100),
        @AddMultiplier decimal(10,2),
        @DeductBasis varchar(100),
        @SuppressComponentsOnTokenError bit;

    SELECT TOP (1)
        @MealPeriodHours = r.MealPeriodHours,
        @GroupLookbackDays = r.GroupLookbackDays,
        @GroupLookaheadDays = r.GroupLookaheadDays,
        @StitchGapMinutes = r.StitchGapMinutes,
        @MissingTokenBehavior = r.MissingTokenBehavior,
        @MealAssignmentPolicy = r.MealAssignmentPolicy,
        @WeekdaySTStartMode = r.WeekdaySTStartMode,
        @NonSTStartMode = r.NonSTStartMode,
        @SaturdayMode = r.SaturdayMode,
        @SundayMode = r.SundayMode,
        @SpecialSaturdayMode = r.SpecialSaturdayMode,
        @HolidayMode = r.HolidayMode,
        @AddRateBasis = r.AddRateBasis,
        @AddMultiplier = r.AddMultiplier,
        @DeductBasis = r.DeductBasis,
        @SuppressComponentsOnTokenError = r.SuppressComponentsOnTokenError
    FROM cfg.WTL_Rule r
    WHERE r.UnionCode = @UnionCode
      AND r.IsEnabled = 1
      AND @WorkDateFrom >= r.EffectiveStartDate
      AND (r.EffectiveEndDate IS NULL OR @WorkDateFrom <= r.EffectiveEndDate)
    ORDER BY r.EffectiveStartDate DESC, r.WTL_RuleID DESC;

    IF @MealPeriodHours IS NULL
    BEGIN
        THROW 51001, 'No enabled cfg.WTL_Rule row was found for the requested union/date.', 1;
    END;

    DECLARE @GroupDateFrom date = DATEADD(DAY, -@GroupLookbackDays, @WorkDateFrom);
    DECLARE @GroupDateTo   date = DATEADD(DAY,  @GroupLookaheadDays, @WorkDateTo);

    IF OBJECT_ID('tempdb..#BaseLabor') IS NOT NULL DROP TABLE #BaseLabor;
    IF OBJECT_ID('tempdb..#GroupedLabor') IS NOT NULL DROP TABLE #GroupedLabor;
    IF OBJECT_ID('tempdb..#PricingSlices') IS NOT NULL DROP TABLE #PricingSlices;
    IF OBJECT_ID('tempdb..#GroupAgg') IS NOT NULL DROP TABLE #GroupAgg;
    IF OBJECT_ID('tempdb..#GroupSummary') IS NOT NULL DROP TABLE #GroupSummary;
    IF OBJECT_ID('tempdb..#MealOpportunitySeed') IS NOT NULL DROP TABLE #MealOpportunitySeed;
    IF OBJECT_ID('tempdb..#MealOpportunities') IS NOT NULL DROP TABLE #MealOpportunities;
    IF OBJECT_ID('tempdb..#WTL_PrototypeComponents') IS NOT NULL DROP TABLE #WTL_PrototypeComponents;

    /* ========================================================
       1) Base labor rows in grouping window
       ======================================================== */

    SELECT
        LaborPayrollID = lp.Original_LaborID,
        lp.EmpID,
        lp.JobCode,
        lp.Pricing_Date,
        lp.Actual_WorkDate,
        lp.Pay_Start,
        lp.Pay_End,
        lp.Total_Hrs,
        lp.CraftCode,
        lp.UnionCode
    INTO #BaseLabor
    FROM fms.Labor_PreProcessed lp
    WHERE lp.Is_Gap_Row = 0
      AND lp.UnionCode = @UnionCode
      AND lp.Actual_WorkDate >= @GroupDateFrom
      AND lp.Actual_WorkDate <= @GroupDateTo
      AND lp.Pay_Start IS NOT NULL
      AND lp.Pay_End IS NOT NULL
      AND lp.Pay_End > lp.Pay_Start;

    CREATE INDEX IX_BaseLabor_Emp_Start
    ON #BaseLabor (EmpID, Pay_Start, Pay_End, LaborPayrollID);

    CREATE INDEX IX_BaseLabor_LaborPayrollID
    ON #BaseLabor (LaborPayrollID);


    /* ========================================================
       2) Group back-to-back or overlapping labor entries
       ======================================================== */

    ;WITH OrderedLabor AS
    (
        SELECT
            b.*,
            PrevPayEnd =
                LAG(b.Pay_End) OVER
                (
                    PARTITION BY b.EmpID
                    ORDER BY b.Pay_Start, b.Pay_End, b.LaborPayrollID
                )
        FROM #BaseLabor b
    ),
    GroupedSeed AS
    (
        SELECT
            o.*,
            GapMinutesFromPrev =
                CASE
                    WHEN o.PrevPayEnd IS NULL THEN NULL
                    ELSE DATEDIFF(MINUTE, o.PrevPayEnd, o.Pay_Start)
                END,
            NewGroupFlag =
                CASE
                    WHEN o.PrevPayEnd IS NULL THEN 1
                    WHEN DATEDIFF(MINUTE, o.PrevPayEnd, o.Pay_Start) <= @StitchGapMinutes THEN 0
                    ELSE 1
                END
        FROM OrderedLabor o
    )
    SELECT
        gs.*,
        WTL_GroupSeq =
            SUM(gs.NewGroupFlag) OVER
            (
                PARTITION BY gs.EmpID
                ORDER BY gs.Pay_Start, gs.Pay_End, gs.LaborPayrollID
                ROWS UNBOUNDED PRECEDING
            )
    INTO #GroupedLabor
    FROM GroupedSeed gs;

    CREATE INDEX IX_GroupedLabor_Group
    ON #GroupedLabor (EmpID, WTL_GroupSeq, Pay_Start, LaborPayrollID);

    CREATE INDEX IX_GroupedLabor_LaborPayrollID
    ON #GroupedLabor (LaborPayrollID);


    /* ========================================================
       3) Pull pricing slices only for labor rows in scope
       ======================================================== */

    SELECT
        s.LaborPayrollID,
        s.JobTicketID,
        s.JobCode,
        s.EmpID,
        s.Employee_Name,
        s.TicketDate,
        s.WorkDate,
        s.SliceIndex,
        s.Slice_Start,
        s.Slice_End,
        s.Slice_Hours,
        s.Day_Type,
        s.Accumulation_Status,
        s.Is_Boom_Active,
        s.Is_Outside_Window,
        s.Rate_Base,
        s.Rate_Shift,
        s.Rate_Boom,
        s.Rate_Boom_Applied,
        s.Mul_OT,
        s.Mul_DT,
        s.Mul_Sat,
        s.Mul_Sun,
        s.Mul_Hol,
        s.Final_Multiplier,
        s.Hourly_Rate_Raw,
        s.Effective_Rate,
        s.Slice_Pay,
        Slice_Bucket =
            CASE
                WHEN s.Final_Multiplier >= s.Mul_DT THEN 'DT'
                WHEN s.Final_Multiplier =  s.Mul_OT THEN 'OT'
                ELSE 'ST'
            END
    INTO #PricingSlices
    FROM api.v_UI_Pricing_Slices_Advanced s
    JOIN #BaseLabor b
        ON b.LaborPayrollID = s.LaborPayrollID
    WHERE s.Slice_Hours > 0;

    CREATE INDEX IX_PricingSlices_LPID_Start
    ON #PricingSlices (LaborPayrollID, Slice_Start, SliceIndex);

    CREATE INDEX IX_PricingSlices_Start_End
    ON #PricingSlices (Slice_Start, Slice_End, LaborPayrollID);


    /* ========================================================
       4) Group summary
       ======================================================== */

    SELECT
        WTL_GroupID =
            CONCAT
            (
                gl.EmpID,
                ':',
                CONVERT(varchar(8), MIN(gl.Actual_WorkDate), 112),
                ':',
                gl.WTL_GroupSeq
            ),
        gl.EmpID,
        gl.WTL_GroupSeq,
        GroupWorkDate = MIN(gl.Actual_WorkDate),
        GroupStart = MIN(gl.Pay_Start),
        GroupEnd = MAX(gl.Pay_End),
        GroupSpanHours =
            CONVERT(decimal(10,2), DATEDIFF(MINUTE, MIN(gl.Pay_Start), MAX(gl.Pay_End)) / 60.0),

        LaborEntryCount = COUNT(*),

        GroupedLaborPayrollIDs =
            STRING_AGG(CONVERT(varchar(20), gl.LaborPayrollID), ','),

        PrimaryRangeLaborPayrollIDs =
            STRING_AGG
            (
                CASE
                    WHEN gl.Actual_WorkDate >= @WorkDateFrom
                     AND gl.Actual_WorkDate <= @WorkDateTo
                    THEN CONVERT(varchar(20), gl.LaborPayrollID)
                    ELSE NULL
                END,
                ','
            ),

        GroupTouchesPrimaryRange =
            MAX
            (
                CASE
                    WHEN gl.Actual_WorkDate >= @WorkDateFrom
                     AND gl.Actual_WorkDate <= @WorkDateTo
                    THEN 1 ELSE 0
                END
            ),

        GroupHasOverlap =
            MAX(CASE WHEN gl.GapMinutesFromPrev < 0 THEN 1 ELSE 0 END),

        MinGapMinutesWithinGroup =
            MIN(CASE WHEN gl.NewGroupFlag = 0 THEN gl.GapMinutesFromPrev END),

        MaxGapMinutesWithinGroup =
            MAX(CASE WHEN gl.NewGroupFlag = 0 THEN gl.GapMinutesFromPrev END),

        GroupTokenCount =
            SUM(ISNULL(ct.WTL_TokenCount, 0)),

        GroupTokenValue =
            MAX(ct.WTL_Token_MissedMeals),

        GroupTokenValues =
            STRING_AGG
            (
                CASE
                    WHEN ct.WTL_Token_MissedMeals IS NULL THEN NULL
                    ELSE CONVERT(varchar(10), ct.WTL_Token_MissedMeals)
                END,
                ','
            ),

        GroupHasLegacyWTL =
            MAX(CASE WHEN ISNULL(ct.Has_WTL_Legacy, 0) = 1 THEN 1 ELSE 0 END),

        GroupHasConflictingWTLTokens =
            MAX(CASE WHEN ISNULL(ct.Has_ConflictingWTLTokens, 0) = 1 THEN 1 ELSE 0 END)

    INTO #GroupAgg
    FROM #GroupedLabor gl
    LEFT JOIN app.v_LaborPayroll_CommentTokens ct
        ON ct.LaborPayrollID = gl.LaborPayrollID
    GROUP BY
        gl.EmpID,
        gl.WTL_GroupSeq;

    CREATE INDEX IX_GroupAgg_Group
    ON #GroupAgg (EmpID, WTL_GroupSeq);


    /* ========================================================
       5) First payable slice for WTL mode decision
       ======================================================== */

    ;WITH FirstSlice AS
    (
        SELECT
            ga.WTL_GroupID,
            ps.LaborPayrollID,
            ps.Slice_Start,
            ps.Slice_End,
            ps.Day_Type,
            ps.Slice_Bucket,
            ps.Final_Multiplier,
            rn =
                ROW_NUMBER() OVER
                (
                    PARTITION BY ga.WTL_GroupID
                    ORDER BY ps.Slice_Start, ps.LaborPayrollID, ps.SliceIndex
                )
        FROM #GroupAgg ga
        JOIN #GroupedLabor gl
            ON gl.EmpID = ga.EmpID
           AND gl.WTL_GroupSeq = ga.WTL_GroupSeq
        JOIN #PricingSlices ps
            ON ps.LaborPayrollID = gl.LaborPayrollID
    )
    SELECT
        ga.WTL_GroupID,
        ga.EmpID,
        ga.WTL_GroupSeq,
        ga.GroupWorkDate,
        ga.GroupStart,
        ga.GroupEnd,
        ga.GroupSpanHours,
        ga.LaborEntryCount,
        ga.GroupedLaborPayrollIDs,
        ga.PrimaryRangeLaborPayrollIDs,
        ga.GroupTouchesPrimaryRange,

        th.MaxMealPeriods AS Computed_Max_Meals,

        HasWTLToken =
            CASE WHEN ISNULL(ga.GroupTokenCount, 0) > 0 THEN 1 ELSE 0 END,

        ga.GroupTokenCount,
        WTL_Token_MissedMeals = ga.GroupTokenValue,
        ga.GroupTokenValues,
        ga.GroupHasLegacyWTL,
        ga.GroupHasConflictingWTLTokens,

        Error_MultipleWTLTokens =
            CASE
                WHEN ISNULL(ga.GroupTokenCount, 0) > 1
                  OR ISNULL(ga.GroupHasConflictingWTLTokens, 0) = 1
                THEN 1 ELSE 0
            END,

        Error_TokenExceedsComputedMax =
            CASE
                WHEN th.MaxMealPeriods IS NOT NULL
                 AND ga.GroupTokenValue > th.MaxMealPeriods
                THEN 1 ELSE 0
            END,

        Warning_SpanExceedsThreshold =
            CASE
                WHEN th.MaxMealPeriods IS NULL THEN 1 ELSE 0
            END,

        Warning_MissingWTLToken =
            CASE
                WHEN th.MaxMealPeriods > 0
                 AND ISNULL(ga.GroupTokenCount, 0) = 0
                 AND @MissingTokenBehavior = 'ASSUME_WTL_0_WARN'
                THEN 1 ELSE 0
            END,

        Warning_GroupedLaborEntries =
            CASE WHEN ga.LaborEntryCount > 1 THEN 1 ELSE 0 END,

        ga.GroupHasOverlap,
        ga.MinGapMinutesWithinGroup,
        ga.MaxGapMinutesWithinGroup,

        FirstSlice_LaborPayrollID = fs.LaborPayrollID,
        FirstSlice_Start = fs.Slice_Start,
        FirstSlice_End = fs.Slice_End,
        FirstSlice_DayType = fs.Day_Type,
        FirstSlice_Bucket = fs.Slice_Bucket,
        FirstSlice_Multiplier = fs.Final_Multiplier,

        WTL_Mode =
            CASE
                WHEN th.MaxMealPeriods IS NULL THEN 'MANUAL_REVIEW'
                WHEN fs.Day_Type = 'SATURDAY' THEN @SaturdayMode
                WHEN fs.Day_Type = 'SUNDAY' THEN @SundayMode
                WHEN fs.Day_Type = 'SPECIAL_SAT' THEN @SpecialSaturdayMode
                WHEN fs.Day_Type = 'HOLIDAY' THEN @HolidayMode
                WHEN fs.Slice_Bucket IN ('OT', 'DT') THEN @NonSTStartMode
                ELSE @WeekdaySTStartMode
            END
    INTO #GroupSummary
    FROM #GroupAgg ga
    LEFT JOIN cfg.WTL_MaxMealThreshold th
        ON th.UnionCode = @UnionCode
       AND th.IsEnabled = 1
       AND ga.GroupWorkDate >= th.EffectiveStartDate
       AND (th.EffectiveEndDate IS NULL OR ga.GroupWorkDate <= th.EffectiveEndDate)
       AND ga.GroupSpanHours >= th.MinSpanHours
       AND ga.GroupSpanHours <= th.MaxSpanHours
    LEFT JOIN FirstSlice fs
        ON fs.WTL_GroupID = ga.WTL_GroupID
       AND fs.rn = 1;

    /* ========================================================
    5B) Add derived WTL fields to #GroupSummary

    Use normal columns + UPDATE because SQL Server does not
    allow local variables inside computed-column definitions.
    ======================================================== */

    ALTER TABLE #GroupSummary ADD
        HasTokenBlockingError bit NULL,
        WTL_Missed_Meals int NULL,
        WTL_Taken_Meals int NULL,
        Meal_Deduct_Hrs decimal(10,2) NULL,
        WTL_Worked_Hrs decimal(10,2) NULL;

    UPDATE gs
    SET
        HasTokenBlockingError =
            CASE
                WHEN gs.Error_MultipleWTLTokens = 1
                OR gs.Error_TokenExceedsComputedMax = 1
                THEN 1 ELSE 0
            END,

        WTL_Missed_Meals =
            CASE
                WHEN gs.Error_MultipleWTLTokens = 1
                OR gs.Error_TokenExceedsComputedMax = 1
                OR gs.Warning_SpanExceedsThreshold = 1
                THEN NULL
                WHEN gs.Computed_Max_Meals IS NULL THEN NULL
                WHEN gs.HasWTLToken = 0 THEN 0
                ELSE gs.WTL_Token_MissedMeals
            END,

        WTL_Taken_Meals =
            CASE
                WHEN gs.Error_MultipleWTLTokens = 1
                OR gs.Error_TokenExceedsComputedMax = 1
                OR gs.Warning_SpanExceedsThreshold = 1
                THEN NULL
                WHEN gs.Computed_Max_Meals IS NULL THEN NULL
                WHEN gs.HasWTLToken = 0 THEN gs.Computed_Max_Meals
                ELSE gs.Computed_Max_Meals - gs.WTL_Token_MissedMeals
            END,

        Meal_Deduct_Hrs =
            CONVERT(decimal(10,2),
                CASE
                    WHEN gs.Error_MultipleWTLTokens = 1
                    OR gs.Error_TokenExceedsComputedMax = 1
                    OR gs.Warning_SpanExceedsThreshold = 1
                    THEN NULL
                    WHEN gs.Computed_Max_Meals IS NULL THEN NULL
                    WHEN gs.HasWTLToken = 0 THEN gs.Computed_Max_Meals * @MealPeriodHours
                    ELSE (gs.Computed_Max_Meals - gs.WTL_Token_MissedMeals) * @MealPeriodHours
                END
            ),

        WTL_Worked_Hrs =
            CONVERT(decimal(10,2),
                CASE
                    WHEN gs.Error_MultipleWTLTokens = 1
                    OR gs.Error_TokenExceedsComputedMax = 1
                    OR gs.Warning_SpanExceedsThreshold = 1
                    THEN NULL
                    WHEN gs.Computed_Max_Meals IS NULL THEN NULL
                    WHEN gs.HasWTLToken = 0 THEN 0
                    ELSE gs.WTL_Token_MissedMeals * @MealPeriodHours
                END
            )
    FROM #GroupSummary gs;

    CREATE INDEX IX_GroupSummary_Group
    ON #GroupSummary (WTL_GroupID, EmpID, WTL_GroupSeq);


    /* ========================================================
       6) Modeled meal opportunities
       ======================================================== */

    CREATE TABLE #MealOpportunitySeed
    (
        MealOpportunityNumber int NOT NULL,
        MealStartOffsetMinutes int NOT NULL
    );

    INSERT #MealOpportunitySeed (MealOpportunityNumber, MealStartOffsetMinutes)
    VALUES
        (1,  300),
        (2,  630),
        (3,  960),
        (4, 1290);

    SELECT
        gs.WTL_GroupID,
        gs.EmpID,
        gs.WTL_GroupSeq,
        gs.GroupWorkDate,
        gs.GroupStart,
        gs.GroupEnd,
        gs.GroupSpanHours,
        gs.LaborEntryCount,
        gs.GroupedLaborPayrollIDs,
        gs.PrimaryRangeLaborPayrollIDs,
        gs.Computed_Max_Meals,
        gs.HasWTLToken,
        gs.GroupTokenCount,
        gs.WTL_Token_MissedMeals,
        gs.WTL_Missed_Meals,
        gs.WTL_Taken_Meals,
        gs.WTL_Mode,

        mo.MealOpportunityNumber,
        MealSlice_Start = DATEADD(MINUTE, mo.MealStartOffsetMinutes, gs.GroupStart),
        MealSlice_End   = DATEADD(MINUTE, mo.MealStartOffsetMinutes + 30, gs.GroupStart),

        MealAction =
            CASE
                WHEN mo.MealOpportunityNumber <= ISNULL(gs.WTL_Taken_Meals, 0)
                    THEN 'TAKEN_DEDUCT'
                ELSE 'WORKED_THROUGH'
            END
    INTO #MealOpportunities
    FROM #GroupSummary gs
    JOIN #MealOpportunitySeed mo
        ON mo.MealOpportunityNumber <= ISNULL(gs.Computed_Max_Meals, 0)
    WHERE gs.GroupTouchesPrimaryRange = 1
      AND gs.Computed_Max_Meals > 0
      AND ISNULL(gs.HasTokenBlockingError, 0) = 0
      AND ISNULL(gs.Warning_SpanExceedsThreshold, 0) = 0;

    CREATE INDEX IX_MealOpportunities_Group
    ON #MealOpportunities (WTL_GroupID, MealOpportunityNumber, MealSlice_Start, MealSlice_End);


    /* ========================================================
       7) Match each meal opportunity to the actual priced slice
       ======================================================== */

    ;WITH Matched AS
    (
        SELECT
            mo.*,
            ps.LaborPayrollID,
            ps.JobTicketID,
            ps.JobCode,
            ps.Employee_Name,
            ps.WorkDate,
            ps.SliceIndex,
            ps.Slice_Start,
            ps.Slice_End,
            ps.Slice_Hours,
            ps.Day_Type,
            ps.Slice_Bucket,
            ps.Rate_Base,
            ps.Rate_Shift,
            ps.Rate_Boom_Applied,
            ps.Hourly_Rate_Raw,
            ps.Final_Multiplier,
            ps.Effective_Rate,
            ps.Slice_Pay,
            rn =
                ROW_NUMBER() OVER
                (
                    PARTITION BY mo.WTL_GroupID, mo.MealOpportunityNumber
                    ORDER BY ps.Slice_Start, ps.LaborPayrollID, ps.SliceIndex
                )
        FROM #MealOpportunities mo
        JOIN #GroupedLabor gl
            ON gl.EmpID = mo.EmpID
           AND gl.WTL_GroupSeq = mo.WTL_GroupSeq
        LEFT JOIN #PricingSlices ps
            ON ps.LaborPayrollID = gl.LaborPayrollID
           AND ps.Slice_Start < mo.MealSlice_End
           AND ps.Slice_End   > mo.MealSlice_Start
    )
    SELECT
        WTL_GroupID,
        EmpID,
        WTL_GroupSeq,
        GroupWorkDate,
        GroupStart,
        GroupEnd,
        GroupSpanHours,
        LaborEntryCount,
        GroupedLaborPayrollIDs,
        PrimaryRangeLaborPayrollIDs,
        Computed_Max_Meals,
        HasWTLToken,
        GroupTokenCount,
        WTL_Token_MissedMeals,
        WTL_Missed_Meals,
        WTL_Taken_Meals,
        WTL_Mode,

        MealOpportunityNumber,
        MealSlice_Start,
        MealSlice_End,
        MealAction,

        LaborPayrollID,
        JobTicketID,
        JobCode,
        Employee_Name,
        WorkDate,
        SliceIndex,
        Slice_Start,
        Slice_End,
        Slice_Hours,
        Day_Type,
        Slice_Bucket,
        Rate_Base,
        Rate_Shift,
        Rate_Boom_Applied,
        Hourly_Rate_Raw,
        Final_Multiplier,
        Effective_Rate,
        Slice_Pay,

        ComponentCode =
            CASE
                WHEN LaborPayrollID IS NULL THEN 'WTL_REVIEW_NO_MATCHED_SLICE'
                WHEN MealAction = 'TAKEN_DEDUCT' THEN 'WTL_MEAL_DEDUCT'
                WHEN MealAction = 'WORKED_THROUGH' AND WTL_Mode = 'WTL_DT_FLOOR' THEN 'WTL_DT_FLOOR'
                WHEN MealAction = 'WORKED_THROUGH' AND WTL_Mode = 'WTL_APPLICABLE_ADD' THEN 'WTL_APPLICABLE_ADD'
                ELSE 'WTL_REVIEW'
            END,

        ComponentGroup = 'WTL',

        ComponentHours =
            CONVERT(decimal(10,2),
                CASE
                    WHEN LaborPayrollID IS NULL THEN NULL
                    WHEN MealAction = 'TAKEN_DEDUCT' THEN -1.00 * @MealPeriodHours
                    ELSE @MealPeriodHours
                END
            ),

        ComponentAmount =
            CONVERT(decimal(19,4),
                CASE
                    WHEN LaborPayrollID IS NULL THEN NULL

                    WHEN MealAction = 'TAKEN_DEDUCT'
                        THEN -1.00 * ISNULL(Slice_Pay, 0)

                    WHEN MealAction = 'WORKED_THROUGH'
                     AND WTL_Mode = 'WTL_DT_FLOOR'
                        THEN
                            @MealPeriodHours
                          * (ISNULL(Rate_Base, 0) + ISNULL(Rate_Shift, 0))
                          * CASE
                                WHEN @AddMultiplier - ISNULL(Final_Multiplier, 0) > 0
                                THEN @AddMultiplier - ISNULL(Final_Multiplier, 0)
                                ELSE 0
                            END

                    WHEN MealAction = 'WORKED_THROUGH'
                     AND WTL_Mode = 'WTL_APPLICABLE_ADD'
                        THEN
                            @MealPeriodHours
                          * (ISNULL(Rate_Base, 0) + ISNULL(Rate_Shift, 0))
                          * @AddMultiplier

                    ELSE NULL
                END
            ),

        RateBaseUsed = Rate_Base,
        RateShiftUsed = Rate_Shift,

        RateBoomUsed =
            CASE
                WHEN LaborPayrollID IS NULL THEN NULL
                WHEN MealAction = 'TAKEN_DEDUCT' THEN Rate_Boom_Applied
                ELSE CONVERT(decimal(12,4), 0)
            END,

        MultiplierUsed =
            CASE
                WHEN LaborPayrollID IS NULL THEN NULL
                WHEN MealAction = 'TAKEN_DEDUCT' THEN Final_Multiplier
                WHEN MealAction = 'WORKED_THROUGH' THEN @AddMultiplier
                ELSE NULL
            END,

        Explanation =
            CASE
                WHEN LaborPayrollID IS NULL
                    THEN 'No priced slice matched the modeled meal opportunity. Review manually.'
                WHEN MealAction = 'TAKEN_DEDUCT'
                    THEN 'Taken meal deducted using earliest available modeled meal opportunity. Entire priced slice removed, including base, shift, boom, and multiplier.'
                WHEN MealAction = 'WORKED_THROUGH'
                 AND WTL_Mode = 'WTL_DT_FLOOR'
                    THEN 'Worked-through meal for weekday ST-start block. Added DT floor premium using selected meal opportunity slice base + shift only; boom excluded.'
                WHEN MealAction = 'WORKED_THROUGH'
                 AND WTL_Mode = 'WTL_APPLICABLE_ADD'
                    THEN 'Worked-through meal for applicable-add block. Added 0.5 hour at DT using selected meal opportunity slice base + shift only; boom excluded.'
                ELSE 'Review.'
            END
    INTO #WTL_PrototypeComponents
    FROM Matched
    WHERE rn = 1;


    /* ========================================================
       Result set 1: group-level summary
       ======================================================== */

    SELECT
        WTL_GroupID,
        EmpID,
        GroupWorkDate,
        GroupStart,
        GroupEnd,
        GroupSpanHours,
        LaborEntryCount,
        GroupedLaborPayrollIDs,
        PrimaryRangeLaborPayrollIDs,
        GroupTouchesPrimaryRange,
        Computed_Max_Meals,
        HasWTLToken,
        GroupTokenCount,
        WTL_Token_MissedMeals,
        GroupTokenValues,
        GroupHasLegacyWTL,
        GroupHasConflictingWTLTokens,
        WTL_Missed_Meals,
        WTL_Taken_Meals,
        Meal_Deduct_Hrs,
        WTL_Worked_Hrs,
        FirstSlice_LaborPayrollID,
        FirstSlice_Start,
        FirstSlice_DayType,
        FirstSlice_Bucket,
        FirstSlice_Multiplier,
        WTL_Mode,
        Warning_MissingWTLToken,
        Error_MultipleWTLTokens,
        Error_TokenExceedsComputedMax,
        Warning_GroupedLaborEntries,
        Warning_SpanExceedsThreshold,
        GroupHasOverlap,
        MinGapMinutesWithinGroup,
        MaxGapMinutesWithinGroup
    FROM #GroupSummary
    WHERE GroupTouchesPrimaryRange = 1
      AND
      (
           Computed_Max_Meals > 0
        OR HasWTLToken = 1
        OR LaborEntryCount > 1
      )
    ORDER BY
        GroupStart DESC,
        EmpID,
        WTL_GroupID;


    /* ========================================================
       Result set 2: preview WTL component rows
       ======================================================== */

    SELECT
        *
    FROM #WTL_PrototypeComponents
    ORDER BY
        GroupStart DESC,
        EmpID,
        WTL_GroupID,
        MealOpportunityNumber;


    /* ========================================================
       Result set 3: totals by component code
       ======================================================== */

    SELECT
        ComponentCode,
        [RowCount] = COUNT(*),
        TotalComponentHours = SUM(ComponentHours),
        TotalComponentAmount = SUM(ComponentAmount)
    FROM #WTL_PrototypeComponents
    GROUP BY
        ComponentCode
    ORDER BY
        ComponentCode;


    /* ========================================================
       Result set 4: warning/error summary
       ======================================================== */

    SELECT
        GroupsInScope = COUNT(*),
        MissingWTLTokenWarnings = SUM(Warning_MissingWTLToken),
        MultipleWTLTokenErrors = SUM(Error_MultipleWTLTokens),
        TokenExceedsComputedMaxErrors = SUM(Error_TokenExceedsComputedMax),
        GroupedLaborWarnings = SUM(Warning_GroupedLaborEntries),
        SpanExceedsThresholdWarnings = SUM(Warning_SpanExceedsThreshold),
        OverlapGroups = SUM(GroupHasOverlap)
    FROM #GroupSummary
    WHERE GroupTouchesPrimaryRange = 1
      AND
      (
           Computed_Max_Meals > 0
        OR HasWTLToken = 1
        OR LaborEntryCount > 1
      );


    /* ========================================================
       Result set 5: WTL error/manual-review groups
       ======================================================== */

    SELECT
        WTL_GroupID,
        EmpID,
        GroupWorkDate,
        GroupStart,
        GroupEnd,
        GroupSpanHours,
        LaborEntryCount,
        GroupedLaborPayrollIDs,
        PrimaryRangeLaborPayrollIDs,
        Computed_Max_Meals,
        HasWTLToken,
        GroupTokenCount,
        WTL_Token_MissedMeals,
        WTL_Missed_Meals,
        WTL_Taken_Meals,
        WTL_Mode,
        Error_MultipleWTLTokens,
        Error_TokenExceedsComputedMax,
        Warning_SpanExceedsThreshold,
        Warning_GroupedLaborEntries,
        GroupHasOverlap,
        GroupHasLegacyWTL,
        GroupHasConflictingWTLTokens
    FROM #GroupSummary
    WHERE GroupTouchesPrimaryRange = 1
      AND
      (
           ISNULL(Error_MultipleWTLTokens, 0) = 1
        OR ISNULL(Error_TokenExceedsComputedMax, 0) = 1
        OR ISNULL(Warning_SpanExceedsThreshold, 0) = 1
      )
    ORDER BY
        GroupStart,
        EmpID,
        WTL_GroupID;
END;
