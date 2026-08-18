
/* ============================================================
   WTL Phase 1D - Diagnostic procedure

   Creates:
   - app.usp_Diagnose_WTL_ReviewGroups

   Purpose:
   - Read-only diagnostic for WTL review cases:
       WTL_REVIEW_NO_MATCHED_SLICE
       Span exceeds threshold
       Grouped labor warning
       Overlap warning
       Multiple WTL token error
       Token exceeds computed max error

   This procedure does not update payroll data.
   ============================================================ */

CREATE   PROCEDURE app.usp_Diagnose_WTL_ReviewGroups
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
        @WeekdaySTStartMode varchar(50),
        @NonSTStartMode varchar(50),
        @SaturdayMode varchar(50),
        @SundayMode varchar(50),
        @SpecialSaturdayMode varchar(50),
        @HolidayMode varchar(50);

    SELECT TOP (1)
        @MealPeriodHours = r.MealPeriodHours,
        @GroupLookbackDays = r.GroupLookbackDays,
        @GroupLookaheadDays = r.GroupLookaheadDays,
        @StitchGapMinutes = r.StitchGapMinutes,
        @MissingTokenBehavior = r.MissingTokenBehavior,
        @WeekdaySTStartMode = r.WeekdaySTStartMode,
        @NonSTStartMode = r.NonSTStartMode,
        @SaturdayMode = r.SaturdayMode,
        @SundayMode = r.SundayMode,
        @SpecialSaturdayMode = r.SpecialSaturdayMode,
        @HolidayMode = r.HolidayMode
    FROM cfg.WTL_Rule r
    WHERE r.UnionCode = @UnionCode
      AND r.IsEnabled = 1
      AND @WorkDateFrom >= r.EffectiveStartDate
      AND (r.EffectiveEndDate IS NULL OR @WorkDateFrom <= r.EffectiveEndDate)
    ORDER BY r.EffectiveStartDate DESC, r.WTL_RuleID DESC;

    IF @MealPeriodHours IS NULL
    BEGIN
        THROW 51002, 'No enabled cfg.WTL_Rule row was found for the requested union/date.', 1;
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
    IF OBJECT_ID('tempdb..#MatchedMealOps') IS NOT NULL DROP TABLE #MatchedMealOps;

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
       3) Pricing slices for labor rows in grouping window
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
        s.Final_Multiplier,
        s.Mul_OT,
        s.Mul_DT,
        s.Rate_Base,
        s.Rate_Shift,
        s.Rate_Boom_Applied,
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
       4) Group aggregate
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
       5) First payable slice and group summary
       ======================================================== */

    ;WITH FirstSlice AS
    (
        SELECT
            ga.WTL_GroupID,
            ps.LaborPayrollID,
            ps.Employee_Name,
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
        Employee_Name = fs.Employee_Name,
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
            CASE WHEN th.MaxMealPeriods IS NULL THEN 1 ELSE 0 END,

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
        gs.Employee_Name,
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
       7) Match meal opportunities to priced slices
       ======================================================== */

    ;WITH Matched AS
    (
        SELECT
            mo.*,
            ps.LaborPayrollID,
            ps.JobTicketID,
            ps.JobCode,
            MatchedEmployeeName = ps.Employee_Name,
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
        *
    INTO #MatchedMealOps
    FROM Matched
    WHERE rn = 1;


    /* ========================================================
       Result set 1: no matched slice diagnostics
       ======================================================== */

    SELECT
        WTL_GroupID,
        EmpID,
        Employee_Name,
        GroupWorkDate,
        GroupStart,
        GroupEnd,
        GroupSpanHours,
        LaborEntryCount,
        GroupedLaborPayrollIDs,
        PrimaryRangeLaborPayrollIDs,
        Computed_Max_Meals,
        WTL_Taken_Meals,
        WTL_Missed_Meals,
        WTL_Mode,
        MealOpportunityNumber,
        MealSlice_Start,
        MealSlice_End,
        MealAction,
        DiagnosticReason = 'WTL_REVIEW_NO_MATCHED_SLICE'
    FROM #MatchedMealOps
    WHERE LaborPayrollID IS NULL
    ORDER BY
        GroupStart,
        EmpID,
        WTL_GroupID,
        MealOpportunityNumber;


    /* ========================================================
       Result set 2: group-level warnings/errors
       ======================================================== */

    SELECT
        WTL_GroupID,
        EmpID,
        Employee_Name,
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
        Warning_MissingWTLToken,
        Error_MultipleWTLTokens,
        Error_TokenExceedsComputedMax,
        Warning_GroupedLaborEntries,
        Warning_SpanExceedsThreshold,
        GroupHasOverlap,
        MinGapMinutesWithinGroup,
        MaxGapMinutesWithinGroup,
        GroupHasLegacyWTL,
        GroupHasConflictingWTLTokens,
        FirstSlice_LaborPayrollID,
        FirstSlice_Start,
        FirstSlice_DayType,
        FirstSlice_Bucket,
        FirstSlice_Multiplier
    FROM #GroupSummary
    WHERE GroupTouchesPrimaryRange = 1
      AND
      (
           Warning_GroupedLaborEntries = 1
        OR Warning_SpanExceedsThreshold = 1
        OR GroupHasOverlap = 1
        OR Error_MultipleWTLTokens = 1
        OR Error_TokenExceedsComputedMax = 1
        OR GroupHasLegacyWTL = 1
        OR GroupHasConflictingWTLTokens = 1
      )
    ORDER BY
        Warning_SpanExceedsThreshold DESC,
        Error_MultipleWTLTokens DESC,
        Error_TokenExceedsComputedMax DESC,
        GroupHasOverlap DESC,
        GroupStart,
        EmpID,
        WTL_GroupID;


    /* ========================================================
       Result set 3: diagnostic summary
       ======================================================== */

    SELECT
        GroupsInScope =
            COUNT(*),

        MissingWTLTokenWarnings =
            SUM(CASE WHEN Warning_MissingWTLToken = 1 THEN 1 ELSE 0 END),

        GroupedLaborWarnings =
            SUM(CASE WHEN Warning_GroupedLaborEntries = 1 THEN 1 ELSE 0 END),

        SpanExceedsThresholdWarnings =
            SUM(CASE WHEN Warning_SpanExceedsThreshold = 1 THEN 1 ELSE 0 END),

        OverlapGroups =
            SUM(CASE WHEN GroupHasOverlap = 1 THEN 1 ELSE 0 END),

        MultipleWTLTokenErrors =
            SUM(CASE WHEN Error_MultipleWTLTokens = 1 THEN 1 ELSE 0 END),

        TokenExceedsComputedMaxErrors =
            SUM(CASE WHEN Error_TokenExceedsComputedMax = 1 THEN 1 ELSE 0 END),

        LegacyWTLGroups =
            SUM(CASE WHEN GroupHasLegacyWTL = 1 THEN 1 ELSE 0 END),

        ConflictingWTLGroups =
            SUM(CASE WHEN GroupHasConflictingWTLTokens = 1 THEN 1 ELSE 0 END),

        NoMatchedSliceRows =
            (
                SELECT COUNT(*)
                FROM #MatchedMealOps
                WHERE LaborPayrollID IS NULL
            )
    FROM #GroupSummary
    WHERE GroupTouchesPrimaryRange = 1
      AND
      (
           Computed_Max_Meals > 0
        OR HasWTLToken = 1
        OR LaborEntryCount > 1
      );
END;
