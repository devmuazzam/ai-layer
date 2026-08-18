


CREATE       PROCEDURE [app].[usp_Prototype_RestPeriod_SliceChain]
      @WorkDateFrom     date
    , @WorkDateTo       date
    , @EmpID            varchar(50) = NULL
    , @LaborPayrollID   int = NULL
    , @IncludeNonForced bit = 1
    , @LookbackDays     int = 7
    , @OutputMode       varchar(20) = 'Both' -- Both, Detail, Rollup
AS
BEGIN
    SET NOCOUNT ON;

    IF @WorkDateFrom IS NULL OR @WorkDateTo IS NULL
        THROW 51000, '@WorkDateFrom and @WorkDateTo are required.', 1;

    IF @WorkDateTo < @WorkDateFrom
        THROW 51000, '@WorkDateTo must be >= @WorkDateFrom.', 1;

    IF @LookbackDays IS NULL OR @LookbackDays < 2
        SET @LookbackDays = 7;

    SET @OutputMode = UPPER(LTRIM(RTRIM(ISNULL(@OutputMode, 'Both'))));

    IF @OutputMode NOT IN ('BOTH', 'DETAIL', 'ROLLUP')
        THROW 51000, '@OutputMode must be Both, Detail, or Rollup.', 1;

    DECLARE @FromDT datetime2(0) = CONVERT(datetime2(0), @WorkDateFrom);
    DECLARE @ToExDT datetime2(0) = DATEADD(DAY, 1, CONVERT(datetime2(0), @WorkDateTo));
    DECLARE @FromDT_Lookback datetime2(0) = DATEADD(DAY, -@LookbackDays, @FromDT);

    IF @LaborPayrollID IS NOT NULL AND NULLIF(LTRIM(RTRIM(@EmpID)), '') IS NULL
    BEGIN
        SELECT @EmpID = pc.EmpID
        FROM fms.Payroll_Calculated pc
        WHERE pc.LaborPayrollID = @LaborPayrollID;
    END;

    ------------------------------------------------------------
    -- Load active rest-period rule
    ------------------------------------------------------------
    DECLARE
          @ReqRestHrs decimal(9,2)
        , @OTFloor decimal(9,2)
        , @StitchGapMin int
        , @TriggerMode varchar(30)
        , @IsEnabled bit;

    SELECT TOP (1)
          @IsEnabled    = IsEnabled
        , @ReqRestHrs   = RequiredRestHours
        , @OTFloor      = OTFloorMultiplier
        , @StitchGapMin = StitchGapMinutes
        , @TriggerMode  = TriggerMode
    FROM cfg.RestPeriod_Rule
    ORDER BY RestRuleID DESC;

    IF ISNULL(@IsEnabled, 0) = 0
        THROW 51000, 'Rest period rule is disabled in cfg.RestPeriod_Rule.', 1;

    IF @ReqRestHrs IS NULL SET @ReqRestHrs = 8.00;
    IF @OTFloor IS NULL SET @OTFloor = 1.50;
    IF @StitchGapMin IS NULL SET @StitchGapMin = 30;

    IF @TriggerMode IS NULL OR @TriggerMode NOT IN ('ActHoursOver8', 'HrsOTDTPositive')
        SET @TriggerMode = 'HrsOTDTPositive';

    ------------------------------------------------------------
    -- 1) Build canonical labor-entry windows.
    --    Same source pattern as production rest procedure.
    ------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Win') IS NOT NULL DROP TABLE #Win;

    SELECT
          pc.LaborPayrollID
        , pc.EmpID
        , pc.Employee_Name
        , pc.WorkDate
        , ActualStart = MIN(CONVERT(datetime2(0), t.Pay_Start_Rounded))
        , ActualEnd   = MAX(CONVERT(datetime2(0), t.Pay_End_Rounded))
        , pc.Act_Total_Hrs
        , pc.Hrs_ST
        , pc.Hrs_OT
        , pc.Hrs_DT
    INTO #Win
    FROM fms.Payroll_Calculated pc
    JOIN calc.v_Calc_Labor_Timeline t
        ON t.LaborPayrollID = pc.LaborPayrollID
    WHERE pc.WorkDate >= @FromDT_Lookback
      AND pc.WorkDate <  @ToExDT
      AND ISNULL(t.Duration_Total_Payable, 0) > 0
      AND t.Pay_Start_Rounded < t.Pay_End_Rounded
      AND (@EmpID IS NULL OR pc.EmpID = @EmpID)
    GROUP BY
          pc.LaborPayrollID
        , pc.EmpID
        , pc.Employee_Name
        , pc.WorkDate
        , pc.Act_Total_Hrs
        , pc.Hrs_ST
        , pc.Hrs_OT
        , pc.Hrs_DT;

    ------------------------------------------------------------
    -- 2) Stitch labor entries into work chains.
    ------------------------------------------------------------
    IF OBJECT_ID('tempdb..#E') IS NOT NULL DROP TABLE #E;

    ;WITH Ordered AS
    (
        SELECT
              w.*
            , PrevEnd = LAG(w.ActualEnd) OVER
                (
                    PARTITION BY w.EmpID
                    ORDER BY w.ActualStart, w.LaborPayrollID
                )
        FROM #Win w
    )
    SELECT
          o.*
        , GapMin =
            CASE
                WHEN o.PrevEnd IS NULL THEN NULL
                ELSE DATEDIFF(MINUTE, o.PrevEnd, o.ActualStart)
            END
        , IsOverlap =
            CONVERT(bit,
                CASE
                    WHEN o.PrevEnd IS NOT NULL
                     AND o.ActualStart < o.PrevEnd
                        THEN 1
                    ELSE 0
                END
            )
        , NewChainFlag =
            CASE
                WHEN o.PrevEnd IS NULL THEN 1
                WHEN DATEDIFF(MINUTE, o.PrevEnd, o.ActualStart) > @StitchGapMin THEN 1
                ELSE 0
            END
    INTO #E
    FROM Ordered o;

    ALTER TABLE #E ADD ChainId int NULL;

    ;WITH x AS
    (
        SELECT
              e.LaborPayrollID
            , ChainIdCalc =
                SUM(e.NewChainFlag) OVER
                (
                    PARTITION BY e.EmpID
                    ORDER BY e.ActualStart, e.LaborPayrollID
                    ROWS UNBOUNDED PRECEDING
                )
        FROM #E e
    )
    UPDATE e
        SET e.ChainId = x.ChainIdCalc
    FROM #E e
    JOIN x
        ON x.LaborPayrollID = e.LaborPayrollID;

    ------------------------------------------------------------
    -- 3) Chain summary.
    ------------------------------------------------------------
    IF OBJECT_ID('tempdb..#C') IS NOT NULL DROP TABLE #C;

    SELECT
          e.EmpID
        , e.ChainId
        , ChainStart = MIN(e.ActualStart)
        , ChainEnd   = MAX(e.ActualEnd)
        , ChainActualHours =
            CONVERT(decimal(10,2), SUM(ISNULL(e.Act_Total_Hrs, 0.00)))
        , ChainHadOT =
            CONVERT(bit,
                MAX(
                    CASE
                        WHEN @TriggerMode = 'ActHoursOver8'
                         AND ISNULL(e.Act_Total_Hrs, 0.00) > 8.00
                            THEN 1
                        WHEN @TriggerMode = 'HrsOTDTPositive'
                         AND (ISNULL(e.Hrs_OT, 0.00) + ISNULL(e.Hrs_DT, 0.00)) > 0
                            THEN 1
                        ELSE 0
                    END
                )
            )
    INTO #C
    FROM #E e
    GROUP BY
          e.EmpID
        , e.ChainId;

    ALTER TABLE #C ADD
          ChainSeq int NULL
        , PrevChainEnd datetime2(0) NULL
        , PrevChainHadOT bit NULL
        , GapHrsFromPrev decimal(9,2) NULL
        , OverlapFromPrev bit NULL
        , RestForced bit NULL
        , RestSegmentId int NULL
        , RestHoursBeforeChain decimal(10,2) NULL;

    ;WITH c AS
    (
        SELECT
              EmpID
            , ChainId
            , ChainSeq = ROW_NUMBER() OVER
                (
                    PARTITION BY EmpID
                    ORDER BY ChainStart, ChainId
                )
        FROM #C
    )
    UPDATE cc
        SET cc.ChainSeq = c.ChainSeq
    FROM #C cc
    JOIN c
        ON c.EmpID = cc.EmpID
       AND c.ChainId = cc.ChainId;

    ;WITH c2 AS
    (
        SELECT
              EmpID
            , ChainId
            , ChainSeq
            , ChainStart
            , ChainEnd
            , ChainHadOT
            , PrevChainEnd =
                LAG(ChainEnd) OVER
                (
                    PARTITION BY EmpID
                    ORDER BY ChainSeq
                )
            , PrevChainHadOT =
                LAG(ChainHadOT) OVER
                (
                    PARTITION BY EmpID
                    ORDER BY ChainSeq
                )
        FROM #C
    )
    UPDATE cc
        SET
              cc.PrevChainEnd = c2.PrevChainEnd
            , cc.PrevChainHadOT = c2.PrevChainHadOT
            , cc.GapHrsFromPrev =
                CASE
                    WHEN c2.PrevChainEnd IS NULL THEN NULL
                    WHEN cc.ChainStart < c2.PrevChainEnd THEN 0.00
                    ELSE CONVERT(decimal(9,2), DATEDIFF(MINUTE, c2.PrevChainEnd, cc.ChainStart) / 60.0)
                END
            , cc.OverlapFromPrev =
                CASE
                    WHEN c2.PrevChainEnd IS NOT NULL
                     AND cc.ChainStart < c2.PrevChainEnd
                        THEN 1
                    ELSE 0
                END
    FROM #C cc
    JOIN c2
        ON c2.EmpID = cc.EmpID
       AND c2.ChainId = cc.ChainId;

    ------------------------------------------------------------
    -- 4) RestForced state machine.
    --    Same high-level trigger as production:
    --    previous chain had OT and gap < required rest,
    --    then stays on until gap >= required rest.
    ------------------------------------------------------------
    ;WITH r AS
    (
        SELECT
              EmpID
            , ChainId
            , ChainSeq
            , PrevChainHadOT
            , GapHrsFromPrev
            , RestForced = CONVERT(bit, 0)
        FROM #C
        WHERE ChainSeq = 1

        UNION ALL

        SELECT
              c.EmpID
            , c.ChainId
            , c.ChainSeq
            , c.PrevChainHadOT
            , c.GapHrsFromPrev
            , RestForced =
                CONVERT(bit,
                    CASE
                        WHEN r.RestForced = 1 THEN
                            CASE
                                WHEN ISNULL(c.GapHrsFromPrev, 9999) >= @ReqRestHrs THEN 0
                                ELSE 1
                            END
                        ELSE
                            CASE
                                WHEN ISNULL(c.PrevChainHadOT, 0) = 1
                                 AND ISNULL(c.GapHrsFromPrev, 9999) < @ReqRestHrs THEN 1
                                ELSE 0
                            END
                    END
                )
        FROM #C c
        JOIN r
            ON r.EmpID = c.EmpID
           AND r.ChainSeq = c.ChainSeq - 1
    )
    UPDATE c
        SET c.RestForced = r.RestForced
    FROM #C c
    JOIN r
        ON r.EmpID = c.EmpID
       AND r.ChainId = c.ChainId
    OPTION (MAXRECURSION 32767);

    ------------------------------------------------------------
    -- 5) Rest segment and hours-before-chain.
    --    Segment resets only after a true 8-hour rest break.
    ------------------------------------------------------------
    ;WITH seg0 AS
    (
        SELECT
              c.EmpID
            , c.ChainId
            , c.ChainSeq
            , c.ChainActualHours
            , SegmentStartFlag =
                CASE
                    WHEN c.PrevChainEnd IS NULL THEN 1
                    WHEN ISNULL(c.GapHrsFromPrev, 9999) >= @ReqRestHrs THEN 1
                    ELSE 0
                END
        FROM #C c
    ),
    seg1 AS
    (
        SELECT
              s.*
            , RestSegmentIdCalc =
                SUM(s.SegmentStartFlag) OVER
                (
                    PARTITION BY s.EmpID
                    ORDER BY s.ChainSeq
                    ROWS UNBOUNDED PRECEDING
                )
        FROM seg0 s
    ),
    seg2 AS
    (
        SELECT
              s.EmpID
            , s.ChainId
            , s.RestSegmentIdCalc
            , RestHoursBeforeChainCalc =
                CONVERT(decimal(10,2),
                    ISNULL(
                        SUM(s.ChainActualHours) OVER
                        (
                            PARTITION BY s.EmpID, s.RestSegmentIdCalc
                            ORDER BY s.ChainSeq
                            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                        ),
                        0.00
                    )
                )
        FROM seg1 s
    )
    UPDATE c
        SET
              c.RestSegmentId = seg2.RestSegmentIdCalc
            , c.RestHoursBeforeChain = seg2.RestHoursBeforeChainCalc
    FROM #C c
    JOIN seg2
        ON seg2.EmpID = c.EmpID
       AND seg2.ChainId = c.ChainId;

    ------------------------------------------------------------
    -- 6) Load advanced pricing slices.
    ------------------------------------------------------------
    IF OBJECT_ID('tempdb..#SliceBase') IS NOT NULL DROP TABLE #SliceBase;

    SELECT
          s.LaborPayrollID
        , s.JobTicketID
        , s.JobCode
        , s.EmpID
        , s.Employee_Name
        , s.WorkDate
        , s.Shift_Start
        , s.Shift_End
        , s.Boom_Start
        , s.Boom_End
        , s.SliceIndex
        , s.Slice_Start
        , s.Slice_End
        , Slice_Hours = CONVERT(decimal(10,2), ISNULL(s.Slice_Hours, 0.00))
        , s.Holiday_Name
        , s.Week_Day
        , s.Day_Type
        , s.Accumulation_Status
        , s.Is_Boom_Active
        , s.Is_Outside_Window
        , s.Limit_OT
        , s.Rate_Base
        , s.Rate_Shift
        , s.Rate_Boom
        , s.Rate_Boom_Applied
        , s.Mul_OT
        , s.Mul_DT
        , s.Mul_Sat
        , s.Mul_Sun
        , s.Mul_Hol
        , NormalMultiplier = CONVERT(decimal(10,2), s.Final_Multiplier)
        , s.Hourly_Rate_Raw

        , RestHourlyRateForCalc =
            CONVERT(decimal(19,6),
                CASE
                    WHEN ISNULL(s.Hourly_Rate_Raw, 0.00) > 0.00
                        THEN ISNULL(s.Hourly_Rate_Raw, 0.00)

                    WHEN
                          ISNULL(e.Hrs_ST, 0.00)
                        + 1.5 * ISNULL(e.Hrs_OT, 0.00)
                        + 2.0 * ISNULL(e.Hrs_DT, 0.00) > 0.00
                        THEN
                            ROUND(
                                (ISNULL(pc.Pay_Actual_Gross, 0.00) - ISNULL(pc.Pay_Rest_Add, 0.00))
                                / NULLIF(
                                      ISNULL(e.Hrs_ST, 0.00)
                                    + 1.5 * ISNULL(e.Hrs_OT, 0.00)
                                    + 2.0 * ISNULL(e.Hrs_DT, 0.00),
                                    0.00
                                  ),
                                6
                            )

                    ELSE 0.00
                END
            )

        , RestHourlyRateSource =
            CONVERT(varchar(40),
                CASE
                    WHEN ISNULL(s.Hourly_Rate_Raw, 0.00) > 0.00
                        THEN 'SliceHourlyRate'

                    WHEN
                          ISNULL(e.Hrs_ST, 0.00)
                        + 1.5 * ISNULL(e.Hrs_OT, 0.00)
                        + 2.0 * ISNULL(e.Hrs_DT, 0.00) > 0.00
                        THEN 'DerivedFromEntryWeightedGross'

                    ELSE 'ZeroOrMissingRate'
                END
            )

        , s.Effective_Rate
        , s.Slice_Pay
        , e.ChainId
        , c.ChainSeq
        , c.ChainStart
        , c.ChainEnd
        , c.ChainHadOT
        , c.GapHrsFromPrev
        , c.RestForced
        , c.RestSegmentId
        , c.RestHoursBeforeChain
        , EntryRest_IsForced = pc.Rest_IsForced
        , EntryRest_ChainId = pc.Rest_ChainId
        , EntryRest_Gap_Hrs_FromPrevChain = pc.Rest_Gap_Hrs_FromPrevChain
        , EntryRest_Premium_Hrs = pc.Rest_Premium_Hrs
        , EntryPay_Rest_Add = pc.Pay_Rest_Add
    INTO #SliceBase
    FROM api.v_UI_Pricing_Slices_Advanced s
    JOIN #E e
        ON e.LaborPayrollID = s.LaborPayrollID
    JOIN #C c
        ON c.EmpID = e.EmpID
       AND c.ChainId = e.ChainId
    JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = s.LaborPayrollID
    WHERE ISNULL(s.Slice_Hours, 0) > 0
      AND (@LaborPayrollID IS NULL OR s.LaborPayrollID = @LaborPayrollID);

    ------------------------------------------------------------
    -- 7) Slice-level rest floor.
    ------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Prototype') IS NOT NULL DROP TABLE #Prototype;

    ;WITH ordered AS
    (
        SELECT
              sb.*
            , SliceHoursBeforeInChain =
                CONVERT(decimal(10,2),
                    ISNULL(
                        SUM(sb.Slice_Hours) OVER
                        (
                            PARTITION BY sb.EmpID, sb.ChainId
                            ORDER BY sb.Slice_Start, sb.LaborPayrollID, sb.SliceIndex
                            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                        ),
                        0.00
                    )
                )
        FROM #SliceBase sb
    ),
    calc1 AS
    (
        SELECT
              o.*
            , RestChainHoursBeforeSlice =
                CONVERT(decimal(10,2),
                    ISNULL(o.RestHoursBeforeChain, 0.00)
                    + ISNULL(o.SliceHoursBeforeInChain, 0.00)
                )
        FROM ordered o
    ),
    calc2 AS
    (
        SELECT
              c1.*
            , RestMultiplier =
                CONVERT(decimal(10,2),
                    CASE
                        WHEN ISNULL(c1.RestForced, 0) = 0 THEN NULL
                        WHEN c1.RestChainHoursBeforeSlice >= ISNULL(c1.Limit_OT, 12.00)
                            THEN ISNULL(c1.Mul_DT, 2.00)
                        ELSE @OTFloor
                    END
                )
        FROM calc1 c1
    ),
    calc3 AS
    (
        SELECT
              c2.*
            , FinalEffectiveMultiplier =
                CONVERT(decimal(10,2),
                    CASE
                        WHEN c2.RestMultiplier IS NULL THEN c2.NormalMultiplier
                        WHEN c2.NormalMultiplier >= c2.RestMultiplier THEN c2.NormalMultiplier
                        ELSE c2.RestMultiplier
                    END
                )
            , RestReason =
                CONVERT(varchar(120),
                    CASE
                        WHEN ISNULL(c2.RestForced, 0) = 0 THEN NULL

                        WHEN c2.RestMultiplier IS NULL THEN NULL

                        WHEN c2.NormalMultiplier > c2.RestMultiplier
                        AND UPPER(ISNULL(c2.Day_Type, '')) = 'SPECIAL_SAT'
                        AND c2.RestMultiplier >= ISNULL(c2.Mul_DT, 2.00)
                            THEN 'Special Saturday premium exceeds rest-chain DT floor'

                        WHEN c2.NormalMultiplier = c2.RestMultiplier
                        AND UPPER(ISNULL(c2.Day_Type, '')) = 'SPECIAL_SAT'
                        AND c2.RestMultiplier >= ISNULL(c2.Mul_DT, 2.00)
                            THEN 'Special Saturday premium meets rest-chain DT floor'

                        WHEN c2.NormalMultiplier > c2.RestMultiplier
                        AND UPPER(ISNULL(c2.Day_Type, '')) = 'SPECIAL_SAT'
                            THEN 'Special Saturday premium exceeds rest floor'

                        WHEN c2.NormalMultiplier = c2.RestMultiplier
                        AND UPPER(ISNULL(c2.Day_Type, '')) = 'SPECIAL_SAT'
                            THEN 'Special Saturday premium meets rest floor'

                        WHEN c2.NormalMultiplier > c2.RestMultiplier
                         AND (
                                UPPER(ISNULL(c2.Day_Type, '')) = 'HOLIDAY'
                                OR (
                                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), c2.Holiday_Name))), '') IS NOT NULL
                                    AND UPPER(LTRIM(RTRIM(CONVERT(nvarchar(200), c2.Holiday_Name)))) <> 'STANDARD'
                                )
                             )
                         AND c2.RestMultiplier >= ISNULL(c2.Mul_DT, 2.00)
                            THEN 'Holiday premium exceeds rest-chain DT floor'

                        WHEN c2.NormalMultiplier = c2.RestMultiplier
                         AND (
                                UPPER(ISNULL(c2.Day_Type, '')) = 'HOLIDAY'
                                OR (
                                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), c2.Holiday_Name))), '') IS NOT NULL
                                    AND UPPER(LTRIM(RTRIM(CONVERT(nvarchar(200), c2.Holiday_Name)))) <> 'STANDARD'
                                )
                             )
                         AND c2.RestMultiplier >= ISNULL(c2.Mul_DT, 2.00)
                            THEN 'Holiday premium meets rest-chain DT floor'

                        WHEN c2.NormalMultiplier > c2.RestMultiplier
                         AND (
                                UPPER(ISNULL(c2.Day_Type, '')) = 'HOLIDAY'
                                OR (
                                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), c2.Holiday_Name))), '') IS NOT NULL
                                    AND UPPER(LTRIM(RTRIM(CONVERT(nvarchar(200), c2.Holiday_Name)))) <> 'STANDARD'
                                )
                             )
                            THEN 'Holiday premium exceeds rest floor'

                        WHEN c2.NormalMultiplier = c2.RestMultiplier
                         AND (
                                UPPER(ISNULL(c2.Day_Type, '')) = 'HOLIDAY'
                                OR (
                                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), c2.Holiday_Name))), '') IS NOT NULL
                                    AND UPPER(LTRIM(RTRIM(CONVERT(nvarchar(200), c2.Holiday_Name)))) <> 'STANDARD'
                                )
                             )
                            THEN 'Holiday premium meets rest floor'

                        WHEN c2.NormalMultiplier > c2.RestMultiplier
                         AND UPPER(ISNULL(c2.Day_Type, '')) = 'SUNDAY'
                         AND c2.RestMultiplier >= ISNULL(c2.Mul_DT, 2.00)
                            THEN 'Sunday premium exceeds rest-chain DT floor'

                        WHEN c2.NormalMultiplier = c2.RestMultiplier
                         AND UPPER(ISNULL(c2.Day_Type, '')) = 'SUNDAY'
                         AND c2.RestMultiplier >= ISNULL(c2.Mul_DT, 2.00)
                            THEN 'Sunday premium meets rest-chain DT floor'

                        WHEN c2.NormalMultiplier > c2.RestMultiplier
                         AND UPPER(ISNULL(c2.Day_Type, '')) = 'SUNDAY'
                            THEN 'Sunday premium exceeds rest floor'

                        WHEN c2.NormalMultiplier = c2.RestMultiplier
                         AND UPPER(ISNULL(c2.Day_Type, '')) = 'SUNDAY'
                            THEN 'Sunday premium meets rest floor'

                        WHEN c2.NormalMultiplier > c2.RestMultiplier
                            THEN 'Normal premium exceeds rest floor'

                        WHEN c2.NormalMultiplier = c2.RestMultiplier
                            THEN 'Normal already meets rest floor'

                        WHEN c2.RestChainHoursBeforeSlice >= ISNULL(c2.Limit_OT, 12.00)
                            THEN 'Rest chain over 12 hrs'

                        ELSE 'Rest floor to OT'
                    END
                )
        FROM calc2 c2
    )
    SELECT
          c3.*
        , NormalSlicePay =
            CONVERT(decimal(19,4),
                ISNULL(c3.Slice_Hours, 0.00)
                * ISNULL(c3.RestHourlyRateForCalc, 0.00)
                * ISNULL(c3.NormalMultiplier, 0.00)
            )
        , RestAdjustedSlicePay =
            CONVERT(decimal(19,4),
                ISNULL(c3.Slice_Hours, 0.00)
                * ISNULL(c3.RestHourlyRateForCalc, 0.00)
                * ISNULL(c3.FinalEffectiveMultiplier, 0.00)
            )
        , RestPremiumDelta =
            CONVERT(decimal(19,4),
                CASE
                    WHEN ISNULL(c3.FinalEffectiveMultiplier, 0.00) > ISNULL(c3.NormalMultiplier, 0.00)
                        THEN ISNULL(c3.Slice_Hours, 0.00)
                           * ISNULL(c3.RestHourlyRateForCalc, 0.00)
                           * (ISNULL(c3.FinalEffectiveMultiplier, 0.00) - ISNULL(c3.NormalMultiplier, 0.00))
                    ELSE 0.00
                END
            )
    INTO #Prototype
    FROM calc3 c3;

    ------------------------------------------------------------
    -- Result set 1: slice-level prototype detail.
    ------------------------------------------------------------
    IF @OutputMode IN ('BOTH', 'DETAIL')
    BEGIN
        SELECT
              p.EmpID
            , p.Employee_Name
            , p.WorkDate
            , p.LaborPayrollID
            , p.JobTicketID
            , p.JobCode
            , p.ChainId
            , p.ChainSeq
            , p.RestSegmentId
            , p.ChainStart
            , p.ChainEnd
            , p.GapHrsFromPrev
            , p.RestForced
            , p.EntryRest_IsForced
            , p.EntryPay_Rest_Add
            , p.EntryRest_Premium_Hrs

            , p.SliceIndex
            , p.Slice_Start
            , p.Slice_End
            , p.Slice_Hours
            , p.Day_Type
            , p.Holiday_Name
            , p.Accumulation_Status
            , p.Is_Outside_Window
            , p.Is_Boom_Active

            , p.Hourly_Rate_Raw
            , p.RestHourlyRateForCalc
            , p.RestHourlyRateSource
            , p.NormalMultiplier
            , p.RestChainHoursBeforeSlice
            , p.RestMultiplier
            , p.FinalEffectiveMultiplier
            , p.RestReason

            , p.NormalSlicePay
            , p.RestAdjustedSlicePay
            , p.RestPremiumDelta
        FROM #Prototype p
        WHERE p.WorkDate >= @FromDT
          AND p.WorkDate <  @ToExDT
          AND (@IncludeNonForced = 1 OR ISNULL(p.RestForced, 0) = 1 OR ISNULL(p.RestPremiumDelta, 0) <> 0)
        ORDER BY
              p.EmpID
            , p.Slice_Start
            , p.LaborPayrollID
            , p.SliceIndex;
    END;

    ------------------------------------------------------------
    -- Result set 2: labor-entry rollup comparison.
    ------------------------------------------------------------
    IF @OutputMode IN ('BOTH', 'ROLLUP')
    BEGIN
        ;WITH filtered AS
        (
            SELECT *
            FROM #Prototype p
            WHERE p.WorkDate >= @FromDT
              AND p.WorkDate <  @ToExDT
              AND (@IncludeNonForced = 1 OR ISNULL(p.RestForced, 0) = 1 OR ISNULL(p.RestPremiumDelta, 0) <> 0)
        )
        SELECT
              f.EmpID
            , f.Employee_Name
            , f.WorkDate
            , f.LaborPayrollID
            , f.JobTicketID
            , f.JobCode
            , RestForced = MAX(CONVERT(int, ISNULL(f.RestForced, 0)))
            , MinRestChainHoursBeforeSlice = MIN(f.RestChainHoursBeforeSlice)
            , MaxRestChainHoursBeforeSlice = MAX(f.RestChainHoursBeforeSlice)
            , SliceHours = CONVERT(decimal(10,2), SUM(f.Slice_Hours))
            , NormalSlicePay = CONVERT(decimal(19,4), SUM(f.NormalSlicePay))
            , PrototypeAdjustedSlicePay = CONVERT(decimal(19,4), SUM(f.RestAdjustedSlicePay))
            , PrototypeRestPremiumAdd = CONVERT(decimal(19,4), SUM(f.RestPremiumDelta))
            , CurrentPayRestAdd = CONVERT(decimal(19,4), MAX(ISNULL(f.EntryPay_Rest_Add, 0.00)))
            , DifferenceVsCurrentRestAdd =
                CONVERT(decimal(19,4),
                    SUM(f.RestPremiumDelta) - MAX(ISNULL(f.EntryPay_Rest_Add, 0.00))
                )
            , CurrentRestPremiumHrs = CONVERT(decimal(10,2), MAX(ISNULL(f.EntryRest_Premium_Hrs, 0.00)))
        FROM filtered f
        GROUP BY
              f.EmpID
            , f.Employee_Name
            , f.WorkDate
            , f.LaborPayrollID
            , f.JobTicketID
            , f.JobCode
        ORDER BY
              f.EmpID
            , f.WorkDate
            , f.LaborPayrollID;
    END;
END;
