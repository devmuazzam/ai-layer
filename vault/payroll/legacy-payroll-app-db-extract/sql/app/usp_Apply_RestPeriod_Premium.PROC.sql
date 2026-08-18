
/* 59B - Patch app.usp_Apply_RestPeriod_Premium gross semantics
   New architecture:
   - Pay_Actual_Gross excludes rest premium.
   - Pay_Rest_Add stores rest premium.
   - Final_Gross_Pay = Pay_Actual_Gross + Pay_Gap_Add + Pay_Rest_Add.
*/

CREATE   PROCEDURE [app].[usp_Apply_RestPeriod_Premium]
      @WorkDateFrom date = NULL
    , @WorkDateTo   date = NULL
    , @RunId        int  = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FromDT  datetime2(0) = CONVERT(datetime2(0), COALESCE(@WorkDateFrom, '19000101'));
    DECLARE @ToExDT  datetime2(0) = DATEADD(DAY, 1, CONVERT(datetime2(0), COALESCE(@WorkDateTo, '99991231')));

    DECLARE @FromDT_Lookback datetime2(0) = DATEADD(DAY, -7, @FromDT);

    IF @RunId IS NULL
        SET @RunId = TRY_CONVERT(int, SESSION_CONTEXT(N'PayrollAPP_RunLogID'));

    IF OBJECT_ID(N'calc.v_Calc_Labor_Timeline', N'V') IS NULL
        THROW 51000, 'Missing view calc.v_Calc_Labor_Timeline (required for rest-period premium).', 1;

    IF COL_LENGTH('calc.v_Calc_Labor_Timeline', 'LaborPayrollID') IS NULL
        THROW 51000, 'calc.v_Calc_Labor_Timeline missing LaborPayrollID.', 1;

    IF COL_LENGTH('calc.v_Calc_Labor_Timeline', 'Pay_Start_Rounded') IS NULL
        THROW 51000, 'calc.v_Calc_Labor_Timeline missing Pay_Start_Rounded (expected canonical start).', 1;

    IF COL_LENGTH('calc.v_Calc_Labor_Timeline', 'Pay_End_Rounded') IS NULL
        THROW 51000, 'calc.v_Calc_Labor_Timeline missing Pay_End_Rounded (expected canonical end).', 1;

    IF COL_LENGTH('calc.v_Calc_Labor_Timeline', 'Duration_Total_Payable') IS NULL
        THROW 51000, 'calc.v_Calc_Labor_Timeline missing Duration_Total_Payable (needed to exclude zero-duration segments).', 1;

    DECLARE @CE_HasReason bit = 0;
    DECLARE @CE_HasWorkDate bit = 0;

    IF OBJECT_ID(N'fms.Payroll_CalcException', N'U') IS NOT NULL
    BEGIN
        SET @CE_HasReason  = CASE WHEN COL_LENGTH('fms.Payroll_CalcException','Reason')   IS NULL THEN 0 ELSE 1 END;
        SET @CE_HasWorkDate = CASE WHEN COL_LENGTH('fms.Payroll_CalcException','WorkDate') IS NULL THEN 0 ELSE 1 END;
    END;

    DECLARE
        @IsEnabled bit,
        @ReqRestHrs decimal(9,2),
        @OTFloor decimal(9,2),
        @StitchGapMin int,
        @TriggerMode varchar(30);

    SELECT TOP (1)
        @IsEnabled     = IsEnabled,
        @ReqRestHrs    = RequiredRestHours,
        @OTFloor       = OTFloorMultiplier,
        @StitchGapMin  = StitchGapMinutes,
        @TriggerMode   = TriggerMode
    FROM cfg.RestPeriod_Rule
    ORDER BY RestRuleID DESC;

    IF ISNULL(@IsEnabled, 0) = 0
    BEGIN
        PRINT 'RestPeriod premium disabled (cfg.RestPeriod_Rule.IsEnabled=0).';
        RETURN;
    END;

    IF @TriggerMode IS NULL OR @TriggerMode NOT IN ('ActHoursOver8','HrsOTDTPositive')
        SET @TriggerMode = 'HrsOTDTPositive';

    IF @ReqRestHrs IS NULL SET @ReqRestHrs = 8.00;
    IF @OTFloor IS NULL SET @OTFloor = 1.50;
    IF @StitchGapMin IS NULL SET @StitchGapMin = 30;

    IF OBJECT_ID('tempdb..#Win') IS NOT NULL DROP TABLE #Win;
    CREATE TABLE #Win
    (
        LaborPayrollID int NOT NULL,
        EmpID          varchar(50) NULL,
        Employee_Name  varchar(100) NULL,
        WorkDate       datetime NULL,
        ActualStart    datetime2(0) NOT NULL,
        ActualEnd      datetime2(0) NOT NULL,
        Act_Total_Hrs  decimal(10,2) NULL,
        Hrs_ST         decimal(10,2) NULL,
        Hrs_OT         decimal(10,2) NULL,
        Hrs_DT         decimal(10,2) NULL
    );

    INSERT #Win
    (
        LaborPayrollID, EmpID, Employee_Name, WorkDate,
        ActualStart, ActualEnd,
        Act_Total_Hrs, Hrs_ST, Hrs_OT, Hrs_DT
    )
    SELECT
        pc.LaborPayrollID,
        pc.EmpID,
        pc.Employee_Name,
        pc.WorkDate,
        MIN(CONVERT(datetime2(0), t.Pay_Start_Rounded)) AS ActualStart,
        MAX(CONVERT(datetime2(0), t.Pay_End_Rounded))   AS ActualEnd,
        pc.Act_Total_Hrs,
        pc.Hrs_ST,
        pc.Hrs_OT,
        pc.Hrs_DT
    FROM fms.Payroll_Calculated pc
    JOIN calc.v_Calc_Labor_Timeline t
        ON t.LaborPayrollID = pc.LaborPayrollID
    WHERE pc.WorkDate >= @FromDT_Lookback
      AND pc.WorkDate <  @ToExDT
      AND ISNULL(t.Duration_Total_Payable, 0) > 0
      AND t.Pay_Start_Rounded < t.Pay_End_Rounded
    GROUP BY
        pc.LaborPayrollID,
        pc.EmpID,
        pc.Employee_Name,
        pc.WorkDate,
        pc.Act_Total_Hrs,
        pc.Hrs_ST,
        pc.Hrs_OT,
        pc.Hrs_DT;

    IF OBJECT_ID('tempdb..#E') IS NOT NULL DROP TABLE #E;

    SELECT
        w.*,
        PrevEnd   = LAG(w.ActualEnd) OVER (PARTITION BY w.EmpID ORDER BY w.ActualStart, w.LaborPayrollID),
        GapMin    = DATEDIFF(MINUTE, LAG(w.ActualEnd) OVER (PARTITION BY w.EmpID ORDER BY w.ActualStart, w.LaborPayrollID), w.ActualStart),
        IsOverlap = CASE
                        WHEN LAG(w.ActualEnd) OVER (PARTITION BY w.EmpID ORDER BY w.ActualStart, w.LaborPayrollID) IS NOT NULL
                         AND w.ActualStart < LAG(w.ActualEnd) OVER (PARTITION BY w.EmpID ORDER BY w.ActualStart, w.LaborPayrollID)
                        THEN 1 ELSE 0
                    END,
        NewChainFlag = CASE
                          WHEN LAG(w.ActualEnd) OVER (PARTITION BY w.EmpID ORDER BY w.ActualStart, w.LaborPayrollID) IS NULL THEN 1
                          WHEN DATEDIFF(MINUTE, LAG(w.ActualEnd) OVER (PARTITION BY w.EmpID ORDER BY w.ActualStart, w.LaborPayrollID), w.ActualStart) > @StitchGapMin THEN 1
                          ELSE 0
                      END
    INTO #E
    FROM #Win w;

    ALTER TABLE #E ADD ChainId int NULL;

    ;WITH x AS
    (
        SELECT
            e.LaborPayrollID,
            ChainIdCalc =
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

    IF OBJECT_ID('tempdb..#C') IS NOT NULL DROP TABLE #C;

    SELECT
        EmpID,
        ChainId,
        ChainStart = MIN(ActualStart),
        ChainEnd   = MAX(ActualEnd),
        ChainActualHours = CONVERT(decimal(10,2), SUM(ISNULL(Act_Total_Hrs, 0.00))),
        ChainHadOT = MAX(
            CASE
                WHEN @TriggerMode = 'ActHoursOver8' AND ISNULL(Act_Total_Hrs,0) > 8.00 THEN 1
                WHEN @TriggerMode = 'HrsOTDTPositive' AND (ISNULL(Hrs_OT,0) + ISNULL(Hrs_DT,0)) > 0 THEN 1
                ELSE 0
            END
        )
    INTO #C
    FROM #E
    GROUP BY EmpID, ChainId;

    ALTER TABLE #C ADD
        ChainSeq int NULL,
        PrevChainEnd datetime2(0) NULL,
        PrevChainHadOT bit NULL,
        GapHrsFromPrev decimal(9,2) NULL,
        OverlapFromPrev bit NULL,
        RestForced bit NULL,
        RestSegmentId int NULL,
        RestHoursBeforeChain decimal(10,2) NULL;

    ;WITH c AS
    (
        SELECT
            EmpID, ChainId, ChainStart, ChainEnd, ChainHadOT,
            ChainSeq = ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY ChainStart, ChainId)
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
            EmpID, ChainId, ChainSeq, ChainStart, ChainEnd, ChainHadOT,
            PrevChainEnd   = LAG(ChainEnd)   OVER (PARTITION BY EmpID ORDER BY ChainSeq),
            PrevChainHadOT = LAG(ChainHadOT) OVER (PARTITION BY EmpID ORDER BY ChainSeq)
        FROM #C
    )
    UPDATE cc
       SET cc.PrevChainEnd   = c2.PrevChainEnd,
           cc.PrevChainHadOT = c2.PrevChainHadOT,
           cc.GapHrsFromPrev =
               CASE
                   WHEN c2.PrevChainEnd IS NULL THEN NULL
                   WHEN cc.ChainStart < c2.PrevChainEnd THEN 0.00
                   ELSE CONVERT(decimal(9,2), DATEDIFF(MINUTE, c2.PrevChainEnd, cc.ChainStart) / 60.0)
               END,
           cc.OverlapFromPrev =
               CASE
                   WHEN c2.PrevChainEnd IS NOT NULL AND cc.ChainStart < c2.PrevChainEnd THEN 1
                   ELSE 0
               END
    FROM #C cc
    JOIN c2
      ON c2.EmpID  = cc.EmpID
     AND c2.ChainId = cc.ChainId;

    ;WITH r AS
    (
        SELECT
            EmpID, ChainId, ChainSeq,
            PrevChainHadOT, GapHrsFromPrev,
            RestForced = CONVERT(bit, 0)
        FROM #C
        WHERE ChainSeq = 1

        UNION ALL

        SELECT
            c.EmpID, c.ChainId, c.ChainSeq,
            c.PrevChainHadOT, c.GapHrsFromPrev,
            RestForced =
                CONVERT(bit,
                    CASE
                        WHEN r.RestForced = 1 THEN
                            CASE WHEN ISNULL(c.GapHrsFromPrev, 9999) >= @ReqRestHrs THEN 0 ELSE 1 END
                        ELSE
                            CASE WHEN ISNULL(c.PrevChainHadOT, 0) = 1 AND ISNULL(c.GapHrsFromPrev, 9999) < @ReqRestHrs THEN 1 ELSE 0 END
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

    ;WITH seg0 AS
    (
        SELECT
            c.EmpID,
            c.ChainId,
            c.ChainSeq,
            c.ChainActualHours,
            SegmentStartFlag =
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
            s.*,
            RestSegmentIdCalc =
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
            s.EmpID,
            s.ChainId,
            s.RestSegmentIdCalc,
            RestHoursBeforeChainCalc =
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
            c.RestSegmentId = seg2.RestSegmentIdCalc,
            c.RestHoursBeforeChain = seg2.RestHoursBeforeChainCalc
    FROM #C c
    JOIN seg2
        ON seg2.EmpID = c.EmpID
       AND seg2.ChainId = c.ChainId;

    IF OBJECT_ID('tempdb..#Apply') IS NOT NULL DROP TABLE #Apply;
    IF OBJECT_ID('tempdb..#SliceBase') IS NOT NULL DROP TABLE #SliceBase;
    IF OBJECT_ID('tempdb..#SliceCalc') IS NOT NULL DROP TABLE #SliceCalc;

    SELECT
        s.LaborPayrollID,
        s.JobTicketID,
        s.JobCode,
        s.EmpID,
        s.Employee_Name,
        s.WorkDate,
        s.SliceIndex,
        s.Slice_Start,
        s.Slice_End,
        Slice_Hours = CONVERT(decimal(10,2), ISNULL(s.Slice_Hours, 0.00)),

        s.Day_Type,
        s.Holiday_Name,
        s.Accumulation_Status,
        s.Is_Outside_Window,
        s.Is_Boom_Active,

        s.Limit_OT,
        s.Mul_DT,
        NormalMultiplier = CONVERT(decimal(10,2), s.Final_Multiplier),
        s.Hourly_Rate_Raw,

        e.ChainId,
        c.ChainSeq,
        c.GapHrsFromPrev,
        IsOverlap = CONVERT(bit, CASE WHEN c.OverlapFromPrev = 1 OR e.IsOverlap = 1 THEN 1 ELSE 0 END),
        c.RestForced,
        c.RestSegmentId,
        c.RestHoursBeforeChain,

        Hrs_ST = ISNULL(e.Hrs_ST, 0.00),
        Hrs_OT = ISNULL(e.Hrs_OT, 0.00),
        Hrs_DT = ISNULL(e.Hrs_DT, 0.00),

        WeightedHrs =
            CONVERT(decimal(19,6),
                ISNULL(e.Hrs_ST, 0.00)
              + 1.5 * ISNULL(e.Hrs_OT, 0.00)
              + 2.0 * ISNULL(e.Hrs_DT, 0.00)
            ),

        ActualGrossBeforeRest =
            CONVERT(decimal(19,6),
                CASE
                    WHEN ISNULL(pc.Pay_Rest_Add, 0.00) <> 0.00
                     AND ABS
                         (
                             CONVERT(decimal(19,4), ISNULL(pc.Final_Gross_Pay, 0.00))
                           - CONVERT(decimal(19,4), ISNULL(pc.Pay_Actual_Gross, 0.00) + ISNULL(pc.Pay_Gap_Add, 0.00))
                         ) < 0.01
                     AND ABS
                         (
                             CONVERT(decimal(19,4), ISNULL(pc.Final_Gross_Pay, 0.00))
                           - CONVERT(decimal(19,4), ISNULL(pc.Pay_Actual_Gross, 0.00) + ISNULL(pc.Pay_Gap_Add, 0.00) + ISNULL(pc.Pay_Rest_Add, 0.00))
                         ) >= 0.01
                        THEN ISNULL(pc.Pay_Actual_Gross, 0.00) - ISNULL(pc.Pay_Rest_Add, 0.00)
                    ELSE ISNULL(pc.Pay_Actual_Gross, 0.00)
                END
            ),

        RestHourlyRateForCalc =
            CONVERT(decimal(19,6),
                CASE
                    WHEN ISNULL(s.Hourly_Rate_Raw, 0.00) > 0.00
                        THEN ISNULL(s.Hourly_Rate_Raw, 0.00)

                    WHEN
                        ISNULL(e.Hrs_ST, 0.00)
                      + 1.5 * ISNULL(e.Hrs_OT, 0.00)
                      + 2.0 * ISNULL(e.Hrs_DT, 0.00) > 0
                        THEN
                            CASE
                                WHEN ISNULL(pc.Pay_Rest_Add, 0.00) <> 0.00
                                 AND ABS
                                     (
                                         CONVERT(decimal(19,4), ISNULL(pc.Final_Gross_Pay, 0.00))
                                       - CONVERT(decimal(19,4), ISNULL(pc.Pay_Actual_Gross, 0.00) + ISNULL(pc.Pay_Gap_Add, 0.00))
                                     ) < 0.01
                                 AND ABS
                                     (
                                         CONVERT(decimal(19,4), ISNULL(pc.Final_Gross_Pay, 0.00))
                                       - CONVERT(decimal(19,4), ISNULL(pc.Pay_Actual_Gross, 0.00) + ISNULL(pc.Pay_Gap_Add, 0.00) + ISNULL(pc.Pay_Rest_Add, 0.00))
                                     ) >= 0.01
                                    THEN ISNULL(pc.Pay_Actual_Gross, 0.00) - ISNULL(pc.Pay_Rest_Add, 0.00)
                                ELSE ISNULL(pc.Pay_Actual_Gross, 0.00)
                            END
                            / NULLIF(
                                ISNULL(e.Hrs_ST, 0.00)
                              + 1.5 * ISNULL(e.Hrs_OT, 0.00)
                              + 2.0 * ISNULL(e.Hrs_DT, 0.00),
                                0.00
                            )

                    ELSE 0.00
                END
            )
    INTO #SliceBase
    FROM api.v_UI_Pricing_Slices_Advanced s
    JOIN #E e
        ON e.LaborPayrollID = s.LaborPayrollID
    JOIN #C c
        ON c.EmpID = e.EmpID
       AND c.ChainId = e.ChainId
    JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = s.LaborPayrollID
    WHERE s.WorkDate >= @FromDT
      AND s.WorkDate <  @ToExDT
      AND ISNULL(s.Slice_Hours, 0) > 0;

    ;WITH ordered AS
    (
        SELECT
            sb.*,
            SliceHoursBeforeInChain =
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
            o.*,
            RestChainHoursBeforeSlice =
                CONVERT(decimal(10,2),
                    ISNULL(o.RestHoursBeforeChain, 0.00)
                  + ISNULL(o.SliceHoursBeforeInChain, 0.00)
                )
        FROM ordered o
    ),
    calc2 AS
    (
        SELECT
            c1.*,
            RestMultiplier =
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
            c2.*,
            FinalEffectiveMultiplier =
                CONVERT(decimal(10,2),
                    CASE
                        WHEN c2.RestMultiplier IS NULL THEN c2.NormalMultiplier
                        WHEN c2.NormalMultiplier >= c2.RestMultiplier THEN c2.NormalMultiplier
                        ELSE c2.RestMultiplier
                    END
                )
        FROM calc2 c2
    )
    SELECT
        c3.*,
        RestPremiumDelta =
            CONVERT(decimal(19,4),
                CASE
                    WHEN ISNULL(c3.FinalEffectiveMultiplier, 0.00) > ISNULL(c3.NormalMultiplier, 0.00)
                        THEN ISNULL(c3.Slice_Hours, 0.00)
                           * ISNULL(c3.RestHourlyRateForCalc, 0.00)
                           * (ISNULL(c3.FinalEffectiveMultiplier, 0.00) - ISNULL(c3.NormalMultiplier, 0.00))
                    ELSE 0.00
                END
            ),
        RestPremiumAffectedHours =
            CONVERT(decimal(10,2),
                CASE
                    WHEN ISNULL(c3.FinalEffectiveMultiplier, 0.00) > ISNULL(c3.NormalMultiplier, 0.00)
                        THEN ISNULL(c3.Slice_Hours, 0.00)
                    ELSE 0.00
                END
            )
    INTO #SliceCalc
    FROM calc3 c3;

    SELECT
        e.LaborPayrollID,
        e.EmpID,
        e.Employee_Name,
        e.WorkDate,
        e.ChainId,
        GapHrsFromPrevChain = MAX(sc.GapHrsFromPrev),
        IsOverlap = CONVERT(bit, MAX(CONVERT(int, ISNULL(sc.IsOverlap, 0)))),
        RestForced = CONVERT(bit, MAX(CONVERT(int, ISNULL(sc.RestForced, 0)))),
        Hrs_ST = MAX(ISNULL(e.Hrs_ST, 0.00)),
        WeightedHrs = MAX(ISNULL(sc.WeightedHrs, 0.00)),
        RateUsed_Est = MAX(ISNULL(sc.RestHourlyRateForCalc, 0.00)),

        RestPremiumHrs =
            CONVERT(decimal(9,2), SUM(ISNULL(sc.RestPremiumAffectedHours, 0.00))),

        RestPremiumAdd =
            CONVERT(decimal(19,4), SUM(ISNULL(sc.RestPremiumDelta, 0.00))),

        ActualGrossBeforeRest =
            CONVERT(decimal(19,4), MAX(ISNULL(sc.ActualGrossBeforeRest, 0.00)))
    INTO #Apply
    FROM #E e
    JOIN #SliceCalc sc
        ON sc.LaborPayrollID = e.LaborPayrollID
    WHERE e.WorkDate >= @FromDT
      AND e.WorkDate <  @ToExDT
    GROUP BY
        e.LaborPayrollID,
        e.EmpID,
        e.Employee_Name,
        e.WorkDate,
        e.ChainId;

    IF OBJECT_ID(N'fms.Payroll_CalcException', N'U') IS NOT NULL
    BEGIN
        DECLARE @CalcRunAt_Rate datetime2(0) = SYSDATETIME();

        DECLARE @InsCols_Rate nvarchar(max) = N'';
        DECLARE @SelCols_Rate nvarchar(max) = N'';

        ;WITH want AS
        (
            SELECT 'RunId' AS Col, 'CAST(@RunId AS int)' AS Expr UNION ALL
            SELECT 'CalcRunAt', 'CAST(@CalcRunAt_Rate AS datetime2(0))' UNION ALL
            SELECT 'Reason', '''RestPeriod_RateMissing (Forced but RateUsed_Est<=0)''' UNION ALL
            SELECT 'LaborPayrollID', 'ap.LaborPayrollID' UNION ALL
            SELECT 'WorkDate', 'ap.WorkDate' UNION ALL
            SELECT 'EmpID', 'TRY_CONVERT(int, ap.EmpID)' UNION ALL SELECT 'EmpID_Raw', 'ap.EmpID' UNION ALL
            SELECT 'Employee_Name', 'ap.Employee_Name'
        )
        SELECT
            @InsCols_Rate = STRING_AGG(QUOTENAME(w.Col), ','),
            @SelCols_Rate = STRING_AGG(w.Expr, ',')
        FROM want w
        WHERE EXISTS
        (
            SELECT 1
            FROM sys.columns c
            WHERE c.object_id = OBJECT_ID(N'fms.Payroll_CalcException', N'U')
              AND c.name = w.Col
        );

        IF @InsCols_Rate IS NOT NULL AND LEN(@InsCols_Rate) > 0
        BEGIN
            DECLARE @InsSql_Rate nvarchar(max) = N'
                INSERT INTO fms.Payroll_CalcException (' + @InsCols_Rate + N')
                SELECT ' + @SelCols_Rate + N'
                FROM #Apply ap
                WHERE ap.RestForced = 1
                  AND ISNULL(ap.RestPremiumHrs,0) > 0
                  AND ISNULL(ap.RateUsed_Est,0) <= 0
                  AND NOT EXISTS
                  (
                      SELECT 1
                      FROM fms.Payroll_CalcException x
                      WHERE x.LaborPayrollID = ap.LaborPayrollID
                ' + CASE WHEN @CE_HasReason = 1 THEN N' AND x.Reason = ''RestPeriod_RateMissing (Forced but RateUsed_Est<=0)'' ' ELSE N'' END + N'
                ' + CASE WHEN @CE_HasWorkDate = 1 THEN N' AND x.WorkDate = ap.WorkDate ' ELSE N'' END + N'
                  );
            ';

            EXEC sp_executesql
                @InsSql_Rate,
                N'@RunId int, @CalcRunAt_Rate datetime2(0)',
                @RunId = @RunId,
                @CalcRunAt_Rate = @CalcRunAt_Rate;
        END
    END;

    /* New clean gross semantics:
       - Keep Pay_Actual_Gross excluding rest.
       - Store rest only in Pay_Rest_Add.
       - Recalculate Final_Gross_Pay from clean components.
    */
    UPDATE pc
       SET
        pc.Rest_IsForced = ap.RestForced,
        pc.Rest_ChainId  = ap.ChainId,
        pc.Rest_Gap_Hrs_FromPrevChain = ap.GapHrsFromPrevChain,
        pc.Rest_IsOverlap = ap.IsOverlap,
        pc.Rest_Premium_Hrs = ap.RestPremiumHrs,
        pc.Rest_Policy = 'PunitiveUntil8Off',

        pc.Pay_Actual_Gross = CONVERT(decimal(12,2), ap.ActualGrossBeforeRest),
        pc.Pay_Rest_Add     = CONVERT(decimal(19,4), ap.RestPremiumAdd),
        pc.Final_Gross_Pay  = CONVERT(decimal(12,2),
                                  ISNULL(ap.ActualGrossBeforeRest, 0.00)
                                + ISNULL(pc.Pay_Gap_Add, 0.00)
                                + ISNULL(ap.RestPremiumAdd, 0.00)
                              )
    FROM fms.Payroll_Calculated pc
    JOIN #Apply ap
      ON ap.LaborPayrollID = pc.LaborPayrollID;

    IF OBJECT_ID(N'fms.Payroll_CalcException', N'U') IS NOT NULL
    BEGIN
        DECLARE @CalcRunAt datetime2(0) = SYSDATETIME();

        DECLARE @InsCols nvarchar(max) = N'';
        DECLARE @SelCols nvarchar(max) = N'';

        ;WITH want AS
        (
            SELECT 'RunId' AS Col, 'CAST(@RunId AS int)' AS Expr UNION ALL
            SELECT 'CalcRunAt', 'CAST(@CalcRunAt AS datetime2(0))' UNION ALL
            SELECT 'Reason', '''RestPeriod_Overlap (Start < PrevEnd)''' UNION ALL
            SELECT 'LaborPayrollID', 'ap.LaborPayrollID' UNION ALL
            SELECT 'WorkDate', 'ap.WorkDate' UNION ALL
            SELECT 'EmpID', 'TRY_CONVERT(int, ap.EmpID)' UNION ALL SELECT 'EmpID_Raw', 'ap.EmpID' UNION ALL
            SELECT 'Employee_Name', 'ap.Employee_Name'
        )
        SELECT
            @InsCols = STRING_AGG(QUOTENAME(w.Col), ','),
            @SelCols = STRING_AGG(w.Expr, ',')
        FROM want w
        WHERE EXISTS
        (
            SELECT 1
            FROM sys.columns c
            WHERE c.object_id = OBJECT_ID(N'fms.Payroll_CalcException', N'U')
              AND c.name = w.Col
        );

        IF @InsCols IS NOT NULL AND LEN(@InsCols) > 0
        BEGIN
            DECLARE @InsSql nvarchar(max) = N'
                INSERT INTO fms.Payroll_CalcException (' + @InsCols + N')
                SELECT ' + @SelCols + N'
                FROM #Apply ap
                WHERE ap.IsOverlap = 1
                  AND NOT EXISTS
                  (
                      SELECT 1
                      FROM fms.Payroll_CalcException x
                      WHERE x.LaborPayrollID = ap.LaborPayrollID
                ' + CASE WHEN @CE_HasReason = 1 THEN N' AND x.Reason = ''RestPeriod_Overlap (Start < PrevEnd)'' ' ELSE N'' END + N'
                ' + CASE WHEN @CE_HasWorkDate = 1 THEN N' AND x.WorkDate = ap.WorkDate ' ELSE N'' END + N'
                  );
            ';

            EXEC sp_executesql @InsSql, N'@RunId int, @CalcRunAt datetime2(0)', @RunId, @CalcRunAt;
        END
    END;

    DECLARE @Forced int   = (SELECT COUNT(*) FROM #Apply WHERE RestForced = 1 AND RestPremiumAdd > 0);
    DECLARE @Overlap int  = (SELECT COUNT(*) FROM #Apply WHERE IsOverlap = 1);

    PRINT CONCAT('RestPeriod punitive applied rows (premium>0): ', @Forced);
    PRINT CONCAT('RestPeriod overlap warnings: ', @Overlap);
END;
