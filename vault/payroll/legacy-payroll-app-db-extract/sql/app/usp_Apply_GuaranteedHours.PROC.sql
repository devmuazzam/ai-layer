

CREATE     PROCEDURE [app].[usp_Apply_GuaranteedHours]
      @WorkDateFrom date = NULL
    , @WorkDateTo   date = NULL
    , @RunId        int  = NULL
    , @BoomNoModifierTreatment varchar(30) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
       AND @WorkDateFrom > @WorkDateTo
        THROW 51001, '@WorkDateFrom cannot be greater than @WorkDateTo.', 1;

    DECLARE @FromDT datetime2(0) =
        CONVERT(datetime2(0), COALESCE(@WorkDateFrom, CONVERT(date, '19000101')));

    DECLARE @ToExDT datetime2(0) =
        CASE
            WHEN @WorkDateTo IS NULL THEN CONVERT(datetime2(0), '99991231')
            ELSE DATEADD(DAY, 1, CONVERT(datetime2(0), @WorkDateTo))
        END;

    DECLARE @CalcRunAtUTC datetime2(0) = SYSUTCDATETIME();

    IF @RunId IS NULL
        SET @RunId = TRY_CONVERT(int, SESSION_CONTEXT(N'PayrollAPP_RunLogID'));

    IF @BoomNoModifierTreatment IS NULL
    BEGIN
        SELECT TOP (1)
            @BoomNoModifierTreatment = BoomNoModifierTreatment
        FROM cfg.GuaranteedHoursRule
        WHERE RuleCode = 'LONG_BOOM_MIN_4';
    END;

    IF @BoomNoModifierTreatment IS NULL
        SET @BoomNoModifierTreatment = 'EXCLUDE_NO_MODIFIER';

    IF @BoomNoModifierTreatment NOT IN ('EXCLUDE_NO_MODIFIER', 'COUNT_TOWARD_MIN')
        THROW 51002, '@BoomNoModifierTreatment must be EXCLUDE_NO_MODIFIER or COUNT_TOWARD_MIN.', 1;

    IF OBJECT_ID(N'api.v_UI_Pricing_Slices_Advanced', N'V') IS NULL
        THROW 51003, 'Missing api.v_UI_Pricing_Slices_Advanced.', 1;

    IF OBJECT_ID(N'fms.Payroll_Calculated', N'U') IS NULL
        THROW 51004, 'Missing fms.Payroll_Calculated.', 1;

    IF OBJECT_ID(N'app.v_Base_LaborPayroll', N'V') IS NULL
        THROW 51005, 'Missing app.v_Base_LaborPayroll.', 1;


    /* ============================================================
       Clear previous guarantee audit rows for the target window
       ============================================================ */

    DELETE a
    FROM fms.Payroll_GuaranteeAllocation a
    JOIN fms.Payroll_GuaranteeGroup g
        ON g.GuaranteeGroupID = a.GuaranteeGroupID
    WHERE
        (
            g.ShiftAnchorDate >= CONVERT(date, @FromDT)
            AND g.ShiftAnchorDate < CONVERT(date, @ToExDT)
        )
        OR
        (
            g.CalendarDate >= CONVERT(date, @FromDT)
            AND g.CalendarDate < CONVERT(date, @ToExDT)
        );

    DELETE g
    FROM fms.Payroll_GuaranteeGroup g
    WHERE
        (
            g.ShiftAnchorDate >= CONVERT(date, @FromDT)
            AND g.ShiftAnchorDate < CONVERT(date, @ToExDT)
        )
        OR
        (
            g.CalendarDate >= CONVERT(date, @FromDT)
            AND g.CalendarDate < CONVERT(date, @ToExDT)
        );


    /* ============================================================
       Reset compatibility fields before applying new allocations
       ============================================================ */

    UPDATE pc
       SET
            pc.Gap_Hrs_Total = 0.00,
            pc.Gap_Hrs_Boom  = 0.00,
            pc.Pay_Gap_Add   = 0.00,
            pc.Pay_Total_Hrs = pc.Act_Total_Hrs,
            pc.Final_Gross_Pay =
                CONVERT(decimal(12,2),
                    ISNULL(pc.Pay_Actual_Gross, 0.00)
                + ISNULL(pc.Pay_Rest_Add, 0.00)
                ),
            pc.Audit_Min_Rule = 0.0,
            pc.Audit_Gap_Mult = 1.0
    FROM fms.Payroll_Calculated pc
    WHERE
        pc.WorkDate >= @FromDT
        AND pc.WorkDate < @ToExDT;


    /* ============================================================
       Build source temp tables
       ============================================================ */

    IF OBJECT_ID('tempdb..#PcBase') IS NOT NULL DROP TABLE #PcBase;

    SELECT
        pc.LaborPayrollID,
        pc.CalcID,
        pc.JobTicketID,
        pc.JobCode,
        pc.EmpID,
        pc.Employee_Name,
        ShiftAnchorDate = CAST(pc.WorkDate AS date),

        pc.Act_Total_Hrs,
        pc.Act_Boom_Hrs,

        pc.Pay_Actual_Gross,
        pc.Hrs_ST,
        pc.Hrs_OT,
        pc.Hrs_DT,

        bl.CraftCode,
        bl.CraftPayRate,
        bl.CraftModifierCode,
        bl.CraftModifierPayRateAdjustment,

        ApplyMinimumPay = CONVERT(tinyint, ISNULL(mp.ApplyMinimumPay, 1))
    INTO #PcBase
    FROM fms.Payroll_Calculated pc
    LEFT JOIN app.v_Base_LaborPayroll bl
        ON bl.LaborPayrollID = pc.LaborPayrollID
    LEFT JOIN cfg.Craft_MinimumPayPolicy mp
        ON mp.CraftCode = bl.CraftCode
    WHERE
        pc.WorkDate >= @FromDT
        AND pc.WorkDate < @ToExDT;

    CREATE UNIQUE CLUSTERED INDEX CX_PcBase
        ON #PcBase(LaborPayrollID);

    CREATE INDEX IX_PcBase_EmpShift
        ON #PcBase(EmpID, ShiftAnchorDate);


    IF OBJECT_ID('tempdb..#LaborWin') IS NOT NULL DROP TABLE #LaborWin;

    SELECT
        t.LaborPayrollID,
        Labor_Start = MIN(t.Pay_Start_Rounded),
        Labor_End   = MAX(t.Pay_End_Rounded)
    INTO #LaborWin
    FROM calc.v_Calc_Labor_Timeline t
    JOIN #PcBase p
        ON p.LaborPayrollID = t.LaborPayrollID
    GROUP BY
        t.LaborPayrollID;

    CREATE UNIQUE CLUSTERED INDEX CX_LaborWin
        ON #LaborWin(LaborPayrollID);


    IF OBJECT_ID('tempdb..#SliceBase') IS NOT NULL DROP TABLE #SliceBase;

    SELECT
        s.LaborPayrollID,
        p.EmpID,
        p.Employee_Name,
        p.ShiftAnchorDate,
        p.ApplyMinimumPay,
        p.CraftModifierCode,
        p.CraftModifierPayRateAdjustment,

        CalendarDate = CAST(s.Slice_Start AS date),

        s.Slice_Start,
        s.Slice_End,
        s.Slice_Hours,
        s.Is_Boom_Active,

        s.Rate_Base,
        s.Rate_Shift,
        s.Rate_Boom_Applied,
        s.Final_Multiplier,

        IsHolidayCalendar =
            CASE WHEN h.[Date] IS NOT NULL THEN 1 ELSE 0 END,

        HolidayName =
            h.HolidayName,

        HolidayMultiplier =
            h.PayRateMultiplier,

        IsSpecialSaturdayCalendar =
            CASE
                WHEN MONTH(CAST(s.Slice_Start AS date)) IN (6, 12)
                 AND DATENAME(weekday, CAST(s.Slice_Start AS date)) = 'Saturday'
                 AND DAY(CAST(s.Slice_Start AS date)) <= 7
                THEN 1 ELSE 0
            END
    INTO #SliceBase
    FROM api.v_UI_Pricing_Slices_Advanced s
    JOIN #PcBase p
        ON p.LaborPayrollID = s.LaborPayrollID
    LEFT JOIN dim.LU12_Holiday h
        ON h.[Date] = CAST(s.Slice_Start AS date);

    CREATE INDEX IX_SliceBase_LPID
        ON #SliceBase(LaborPayrollID);

    CREATE INDEX IX_SliceBase_EmpShift
        ON #SliceBase(EmpID, ShiftAnchorDate);

    CREATE INDEX IX_SliceBase_EmpCalendar
        ON #SliceBase(EmpID, CalendarDate);


    IF OBJECT_ID('tempdb..#EntryRate') IS NOT NULL DROP TABLE #EntryRate;

    SELECT
        LaborPayrollID,
        RateBaseUsed  = CAST(MAX(ISNULL(Rate_Base, 0.00)) AS decimal(12,4)),
        RateShiftUsed = CAST(MAX(ISNULL(Rate_Shift, 0.00)) AS decimal(12,4)),
        BaseShiftRateUsed =
            CAST(MAX(ISNULL(Rate_Base, 0.00) + ISNULL(Rate_Shift, 0.00)) AS decimal(12,4))
    INTO #EntryRate
    FROM #SliceBase
    GROUP BY
        LaborPayrollID;

    CREATE UNIQUE CLUSTERED INDEX CX_EntryRate
        ON #EntryRate(LaborPayrollID);


    IF OBJECT_ID('tempdb..#BoomShiftAgg') IS NOT NULL DROP TABLE #BoomShiftAgg;

    SELECT
        EmpID,
        ShiftAnchorDate,

        PayableBoomHours =
            CAST(SUM(
                CASE
                    WHEN Is_Boom_Active = 1
                     AND CraftModifierCode IS NOT NULL
                     AND ISNULL(Rate_Boom_Applied, 0.00) <> 0.00
                    THEN Slice_Hours
                    ELSE 0.00
                END
            ) AS decimal(10,2)),

        QualifyingBoomHours =
            CAST(SUM(
                CASE
                    WHEN Is_Boom_Active = 1
                     AND
                     (
                         @BoomNoModifierTreatment = 'COUNT_TOWARD_MIN'
                         OR
                         (
                             CraftModifierCode IS NOT NULL
                             AND ISNULL(Rate_Boom_Applied, 0.00) <> 0.00
                         )
                     )
                    THEN Slice_Hours
                    ELSE 0.00
                END
            ) AS decimal(10,2)),

        BoomMultiplierUsed =
            CAST(MAX(
                CASE
                    WHEN Is_Boom_Active = 1
                     AND CraftModifierCode IS NOT NULL
                     AND ISNULL(Rate_Boom_Applied, 0.00) <> 0.00
                    THEN ISNULL(Final_Multiplier, 1.00)
                END
            ) AS decimal(10,2))
    INTO #BoomShiftAgg
    FROM #SliceBase
    GROUP BY
        EmpID,
        ShiftAnchorDate;

    CREATE UNIQUE CLUSTERED INDEX CX_BoomShiftAgg
        ON #BoomShiftAgg(EmpID, ShiftAnchorDate);


    IF OBJECT_ID('tempdb..#BoomEligibleLaborRows') IS NOT NULL DROP TABLE #BoomEligibleLaborRows;

    SELECT
        LaborPayrollID,
        EmpID,
        ShiftAnchorDate,
        LastEligibleBoomSliceEnd = MAX(Slice_End),
        BoomRateUsed = CAST(MAX(ISNULL(Rate_Boom_Applied, 0.00)) AS decimal(12,4)),
        BoomMultiplierUsed = CAST(MAX(ISNULL(Final_Multiplier, 1.00)) AS decimal(10,2))
    INTO #BoomEligibleLaborRows
    FROM #SliceBase
    WHERE
        Is_Boom_Active = 1
        AND CraftModifierCode IS NOT NULL
        AND ISNULL(Rate_Boom_Applied, 0.00) <> 0.00
    GROUP BY
        LaborPayrollID,
        EmpID,
        ShiftAnchorDate;

    CREATE INDEX IX_BoomEligibleLaborRows_EmpShift
        ON #BoomEligibleLaborRows(EmpID, ShiftAnchorDate);


    /* ============================================================
       Build guarantee groups
       ============================================================ */

    IF OBJECT_ID('tempdb..#AllGroups') IS NOT NULL DROP TABLE #AllGroups;

    ;WITH Daily4Groups AS
    (
        SELECT
            RuleCode       = CONVERT(varchar(40), 'DAILY_MIN_4'),
            RuleName       = CONVERT(varchar(120), 'Daily 4-hour minimum'),
            ScopeBasis     = CONVERT(varchar(30), 'ShiftAnchorDate'),
            GroupScope     = CONVERT(varchar(40), 'EmployeeShift'),
            EmpID,
            Employee_Name  = MAX(Employee_Name),
            ShiftAnchorDate,
            CalendarDate   = CONVERT(date, NULL),

            ActualQualifyingHours =
                CAST(SUM(ISNULL(Act_Total_Hrs, 0)) AS decimal(10,2)),

            MinimumHours =
                CAST(4.00 AS decimal(10,2)),

            GapHours =
                CAST(
                    CASE
                        WHEN MAX(CONVERT(tinyint, ApplyMinimumPay)) = 0 THEN 0.00
                        WHEN SUM(ISNULL(Act_Total_Hrs, 0)) > 0
                         AND SUM(ISNULL(Act_Total_Hrs, 0)) < 4.00
                        THEN 4.00 - SUM(ISNULL(Act_Total_Hrs, 0))
                        ELSE 0.00
                    END
                AS decimal(10,2)),

            PayComponent   = CONVERT(varchar(40), 'BaseShift'),
            MultiplierUsed = CAST(1.00 AS decimal(10,2))
        FROM #PcBase
        WHERE EXISTS
        (
            SELECT 1
            FROM cfg.GuaranteedHoursRule r
            WHERE r.RuleCode = 'DAILY_MIN_4'
              AND r.IsEnabled = 1
        )
        GROUP BY
            EmpID,
            ShiftAnchorDate
    ),
    BoomGroups AS
    (
        SELECT
            RuleCode       = CONVERT(varchar(40), 'LONG_BOOM_MIN_4'),
            RuleName       = CONVERT(varchar(120), 'Long boom 4-hour premium minimum'),
            ScopeBasis     = CONVERT(varchar(30), 'ShiftAnchorDate'),
            GroupScope     = CONVERT(varchar(40), 'EmployeeShiftBoom'),
            EmpID          = p.EmpID,
            Employee_Name  = MAX(p.Employee_Name),
            ShiftAnchorDate = p.ShiftAnchorDate,
            CalendarDate   = CONVERT(date, NULL),

            ActualQualifyingHours =
                CAST(ISNULL(MAX(bsa.QualifyingBoomHours), 0.00) AS decimal(10,2)),

            MinimumHours =
                CAST(
                    CASE
                        WHEN SUM(ISNULL(p.Act_Total_Hrs, 0)) < 4.00
                        THEN SUM(ISNULL(p.Act_Total_Hrs, 0))
                        ELSE 4.00
                    END
                AS decimal(10,2)),

            GapHours =
                CAST(
                    CASE
                        WHEN MAX(CONVERT(tinyint, p.ApplyMinimumPay)) = 0 THEN 0.00

                        WHEN ISNULL(MAX(bsa.PayableBoomHours), 0.00) <= 0.00 THEN 0.00

                        WHEN ISNULL(MAX(bsa.QualifyingBoomHours), 0.00) > 0.00
                         AND ISNULL(MAX(bsa.QualifyingBoomHours), 0.00)
                             <
                             CASE
                                 WHEN SUM(ISNULL(p.Act_Total_Hrs, 0)) < 4.00
                                 THEN SUM(ISNULL(p.Act_Total_Hrs, 0))
                                 ELSE 4.00
                             END
                        THEN
                             CASE
                                 WHEN SUM(ISNULL(p.Act_Total_Hrs, 0)) < 4.00
                                 THEN SUM(ISNULL(p.Act_Total_Hrs, 0))
                                 ELSE 4.00
                             END
                             - ISNULL(MAX(bsa.QualifyingBoomHours), 0.00)

                        ELSE 0.00
                    END
                AS decimal(10,2)),

            PayComponent   = CONVERT(varchar(40), 'BoomOnly'),
            MultiplierUsed = CAST(ISNULL(MAX(bsa.BoomMultiplierUsed), 1.00) AS decimal(10,2))
        FROM #PcBase p
        LEFT JOIN #BoomShiftAgg bsa
            ON bsa.EmpID = p.EmpID
            AND bsa.ShiftAnchorDate = p.ShiftAnchorDate
        WHERE EXISTS
        (
            SELECT 1
            FROM cfg.GuaranteedHoursRule r
            WHERE r.RuleCode = 'LONG_BOOM_MIN_4'
              AND r.IsEnabled = 1
        )
        GROUP BY
            p.EmpID,
            p.ShiftAnchorDate
    ),
    HolidayGroups AS
    (
        SELECT
            RuleCode       = CONVERT(varchar(40), 'HOLIDAY_MIN_8'),
            RuleName       = CONVERT(varchar(120), 'Holiday 8-hour minimum'),
            ScopeBasis     = CONVERT(varchar(30), 'CalendarDate'),
            GroupScope     = CONVERT(varchar(40), 'EmployeeCalendarDate'),
            EmpID,
            Employee_Name  = MAX(Employee_Name),
            ShiftAnchorDate = CONVERT(date, NULL),
            CalendarDate,

            ActualQualifyingHours =
                CAST(SUM(ISNULL(Slice_Hours, 0)) AS decimal(10,2)),

            MinimumHours =
                CAST(8.00 AS decimal(10,2)),

            GapHours =
                CAST(
                    CASE
                        WHEN MAX(CONVERT(tinyint, ApplyMinimumPay)) = 0 THEN 0.00
                        WHEN SUM(ISNULL(Slice_Hours, 0)) > 0
                         AND SUM(ISNULL(Slice_Hours, 0)) < 8.00
                        THEN 8.00 - SUM(ISNULL(Slice_Hours, 0))
                        ELSE 0.00
                    END
                AS decimal(10,2)),

            PayComponent   = CONVERT(varchar(40), 'Holiday'),
            MultiplierUsed = CAST(COALESCE(MAX(HolidayMultiplier), 3.00) AS decimal(10,2))
        FROM #SliceBase
        WHERE
            IsHolidayCalendar = 1
            AND IsSpecialSaturdayCalendar = 0
            AND EXISTS
            (
                SELECT 1
                FROM cfg.GuaranteedHoursRule r
                WHERE r.RuleCode = 'HOLIDAY_MIN_8'
                  AND r.IsEnabled = 1
            )
        GROUP BY
            EmpID,
            CalendarDate
    ),
    SpecialSatGroups AS
    (
        SELECT
            RuleCode       = CONVERT(varchar(40), 'SPECIAL_SAT_MIN_8'),
            RuleName       = CONVERT(varchar(120), 'Special Saturday 8-hour minimum'),
            ScopeBasis     = CONVERT(varchar(30), 'CalendarDate'),
            GroupScope     = CONVERT(varchar(40), 'EmployeeCalendarDate'),
            EmpID,
            Employee_Name  = MAX(Employee_Name),
            ShiftAnchorDate = CONVERT(date, NULL),
            CalendarDate,

            ActualQualifyingHours =
                CAST(SUM(ISNULL(Slice_Hours, 0)) AS decimal(10,2)),

            MinimumHours =
                CAST(8.00 AS decimal(10,2)),

            GapHours =
                CAST(
                    CASE
                        WHEN MAX(CONVERT(tinyint, ApplyMinimumPay)) = 0 THEN 0.00
                        WHEN SUM(ISNULL(Slice_Hours, 0)) > 0
                         AND SUM(ISNULL(Slice_Hours, 0)) < 8.00
                        THEN 8.00 - SUM(ISNULL(Slice_Hours, 0))
                        ELSE 0.00
                    END
                AS decimal(10,2)),

            PayComponent   = CONVERT(varchar(40), 'SpecialSaturday'),
            MultiplierUsed = CAST(2.00 AS decimal(10,2))
        FROM #SliceBase
        WHERE
            IsSpecialSaturdayCalendar = 1
            AND EXISTS
            (
                SELECT 1
                FROM cfg.GuaranteedHoursRule r
                WHERE r.RuleCode = 'SPECIAL_SAT_MIN_8'
                  AND r.IsEnabled = 1
            )
        GROUP BY
            EmpID,
            CalendarDate
    ),
    RawGroups AS
    (
        SELECT * FROM Daily4Groups
        UNION ALL
        SELECT * FROM BoomGroups
        UNION ALL
        SELECT * FROM HolidayGroups
        UNION ALL
        SELECT * FROM SpecialSatGroups
    )
    SELECT
        TempGroupID = IDENTITY(bigint, 1, 1),
        GroupKey =
            CONVERT(varchar(220),
                CONCAT
                (
                    RuleCode,
                    '|',
                    EmpID,
                    '|',
                    COALESCE(CONVERT(char(10), ShiftAnchorDate, 120), 'NULL'),
                    '|',
                    COALESCE(CONVERT(char(10), CalendarDate, 120), 'NULL')
                )
            ),
        RuleCode,
        RuleName,
        ScopeBasis,
        GroupScope,
        EmpID,
        Employee_Name,
        ShiftAnchorDate,
        CalendarDate,
        ActualQualifyingHours,
        MinimumHours,
        GapHours,
        PayComponent,
        MultiplierUsed
    INTO #AllGroups
    FROM RawGroups
    WHERE GapHours > 0;

    CREATE UNIQUE CLUSTERED INDEX CX_AllGroups
        ON #AllGroups(TempGroupID);

    CREATE INDEX IX_AllGroups_Key
        ON #AllGroups(GroupKey);


    /* ============================================================
       Build allocations
       ============================================================ */

    IF OBJECT_ID('tempdb..#AllAlloc') IS NOT NULL DROP TABLE #AllAlloc;

    CREATE TABLE #AllAlloc
    (
        TempGroupID bigint NOT NULL,
        GroupKey varchar(220) NOT NULL,

        RuleCode varchar(40) NOT NULL,
        RuleName varchar(120) NOT NULL,
        ScopeBasis varchar(30) NOT NULL,
        GroupScope varchar(40) NOT NULL,

        EmpID varchar(50) NULL,
        Employee_Name varchar(200) NULL,

        ShiftAnchorDate date NULL,
        CalendarDate date NULL,

        ActualQualifyingHours decimal(10,2) NOT NULL,
        MinimumHours decimal(10,2) NOT NULL,
        GapHours decimal(10,2) NOT NULL,

        PayComponent varchar(40) NOT NULL,
        MultiplierUsed decimal(10,2) NOT NULL,

        AllocatedLaborPayrollID int NOT NULL,
        AllocatedDate date NULL,
        AllocationMethod varchar(60) NOT NULL,

        RateBaseUsed decimal(12,4) NULL,
        RateShiftUsed decimal(12,4) NULL,
        RateBoomUsed decimal(12,4) NULL,

        AllocatedGapPay decimal(12,2) NOT NULL,
        AllocationRank bigint NOT NULL
    );
    ;WITH AllocCandidates AS
    (
        SELECT
            g.TempGroupID,
            g.GroupKey,
            g.RuleCode,
            g.RuleName,
            g.ScopeBasis,
            g.GroupScope,
            g.EmpID,
            g.Employee_Name,
            g.ShiftAnchorDate,
            g.CalendarDate,
            g.ActualQualifyingHours,
            g.MinimumHours,
            g.GapHours,
            g.PayComponent,
            g.MultiplierUsed,

            AllocatedLaborPayrollID = p.LaborPayrollID,
            AllocatedDate = g.ShiftAnchorDate,
            AllocationMethod = CONVERT(varchar(60), 'LastLaborEntryInShift'),

            RateBaseUsed  = ISNULL(er.RateBaseUsed, 0.00),
            RateShiftUsed = ISNULL(er.RateShiftUsed, 0.00),
            RateBoomUsed  = CONVERT(decimal(12,4), 0.00),

            AllocatedGapPay =
                CAST
                (
                    g.GapHours
                    * ISNULL(er.BaseShiftRateUsed, 0.00)
                    * g.MultiplierUsed
                AS decimal(12,2)),

            AllocationRank =
                ROW_NUMBER() OVER
                (
                    PARTITION BY g.TempGroupID
                    ORDER BY w.Labor_End DESC, p.LaborPayrollID DESC
                )
        FROM #AllGroups g
        JOIN #PcBase p
            ON p.EmpID = g.EmpID
            AND p.ShiftAnchorDate = g.ShiftAnchorDate
        LEFT JOIN #LaborWin w
            ON w.LaborPayrollID = p.LaborPayrollID
        LEFT JOIN #EntryRate er
            ON er.LaborPayrollID = p.LaborPayrollID
        WHERE g.RuleCode = 'DAILY_MIN_4'

        UNION ALL

        SELECT
            g.TempGroupID,
            g.GroupKey,
            g.RuleCode,
            g.RuleName,
            g.ScopeBasis,
            g.GroupScope,
            g.EmpID,
            g.Employee_Name,
            g.ShiftAnchorDate,
            g.CalendarDate,
            g.ActualQualifyingHours,
            g.MinimumHours,
            g.GapHours,
            g.PayComponent,
            g.MultiplierUsed,

            AllocatedLaborPayrollID = ber.LaborPayrollID,
            AllocatedDate = g.ShiftAnchorDate,
            AllocationMethod = CONVERT(varchar(60), 'LastEligibleBoomEntryInShift'),

            RateBaseUsed  = CONVERT(decimal(12,4), 0.00),
            RateShiftUsed = CONVERT(decimal(12,4), 0.00),
            RateBoomUsed  = ber.BoomRateUsed,

            AllocatedGapPay =
                CAST
                (
                    g.GapHours
                    * ISNULL(ber.BoomRateUsed, 0.00)
                    * g.MultiplierUsed
                AS decimal(12,2)),

            AllocationRank =
                ROW_NUMBER() OVER
                (
                    PARTITION BY g.TempGroupID
                    ORDER BY ber.LastEligibleBoomSliceEnd DESC, ber.LaborPayrollID DESC
                )
        FROM #AllGroups g
        JOIN #BoomEligibleLaborRows ber
            ON ber.EmpID = g.EmpID
            AND ber.ShiftAnchorDate = g.ShiftAnchorDate
        WHERE g.RuleCode = 'LONG_BOOM_MIN_4'

        UNION ALL

        SELECT
            g.TempGroupID,
            g.GroupKey,
            g.RuleCode,
            g.RuleName,
            g.ScopeBasis,
            g.GroupScope,
            g.EmpID,
            g.Employee_Name,
            g.ShiftAnchorDate,
            g.CalendarDate,
            g.ActualQualifyingHours,
            g.MinimumHours,
            g.GapHours,
            g.PayComponent,
            g.MultiplierUsed,

            AllocatedLaborPayrollID = s.LaborPayrollID,
            AllocatedDate = g.CalendarDate,
            AllocationMethod = CONVERT(varchar(60), 'LastHolidaySliceEntry'),

            RateBaseUsed  = MAX(ISNULL(s.Rate_Base, 0.00)),
            RateShiftUsed = MAX(ISNULL(s.Rate_Shift, 0.00)),
            RateBoomUsed  = CONVERT(decimal(12,4), 0.00),

            AllocatedGapPay =
                CAST
                (
                    g.GapHours
                    * MAX(ISNULL(s.Rate_Base, 0.00) + ISNULL(s.Rate_Shift, 0.00))
                    * g.MultiplierUsed
                AS decimal(12,2)),

            AllocationRank =
                ROW_NUMBER() OVER
                (
                    PARTITION BY g.TempGroupID
                    ORDER BY MAX(s.Slice_End) DESC, s.LaborPayrollID DESC
                )
        FROM #AllGroups g
        JOIN #SliceBase s
            ON s.EmpID = g.EmpID
            AND s.CalendarDate = g.CalendarDate
            AND s.IsHolidayCalendar = 1
            AND s.IsSpecialSaturdayCalendar = 0
        WHERE g.RuleCode = 'HOLIDAY_MIN_8'
        GROUP BY
            g.TempGroupID,
            g.GroupKey,
            g.RuleCode,
            g.RuleName,
            g.ScopeBasis,
            g.GroupScope,
            g.EmpID,
            g.Employee_Name,
            g.ShiftAnchorDate,
            g.CalendarDate,
            g.ActualQualifyingHours,
            g.MinimumHours,
            g.GapHours,
            g.PayComponent,
            g.MultiplierUsed,
            s.LaborPayrollID

        UNION ALL

        SELECT
            g.TempGroupID,
            g.GroupKey,
            g.RuleCode,
            g.RuleName,
            g.ScopeBasis,
            g.GroupScope,
            g.EmpID,
            g.Employee_Name,
            g.ShiftAnchorDate,
            g.CalendarDate,
            g.ActualQualifyingHours,
            g.MinimumHours,
            g.GapHours,
            g.PayComponent,
            g.MultiplierUsed,

            AllocatedLaborPayrollID = s.LaborPayrollID,
            AllocatedDate = g.CalendarDate,
            AllocationMethod = CONVERT(varchar(60), 'LastSpecialSatSliceEntry'),

            RateBaseUsed  = MAX(ISNULL(s.Rate_Base, 0.00)),
            RateShiftUsed = MAX(ISNULL(s.Rate_Shift, 0.00)),
            RateBoomUsed  = CONVERT(decimal(12,4), 0.00),

            AllocatedGapPay =
                CAST
                (
                    g.GapHours
                    * MAX(ISNULL(s.Rate_Base, 0.00) + ISNULL(s.Rate_Shift, 0.00))
                    * g.MultiplierUsed
                AS decimal(12,2)),

            AllocationRank =
                ROW_NUMBER() OVER
                (
                    PARTITION BY g.TempGroupID
                    ORDER BY MAX(s.Slice_End) DESC, s.LaborPayrollID DESC
                )
        FROM #AllGroups g
        JOIN #SliceBase s
            ON s.EmpID = g.EmpID
            AND s.CalendarDate = g.CalendarDate
            AND s.IsSpecialSaturdayCalendar = 1
        WHERE g.RuleCode = 'SPECIAL_SAT_MIN_8'
        GROUP BY
            g.TempGroupID,
            g.GroupKey,
            g.RuleCode,
            g.RuleName,
            g.ScopeBasis,
            g.GroupScope,
            g.EmpID,
            g.Employee_Name,
            g.ShiftAnchorDate,
            g.CalendarDate,
            g.ActualQualifyingHours,
            g.MinimumHours,
            g.GapHours,
            g.PayComponent,
            g.MultiplierUsed,
            s.LaborPayrollID
    )
    INSERT INTO #AllAlloc
    (
        TempGroupID,
        GroupKey,
        RuleCode,
        RuleName,
        ScopeBasis,
        GroupScope,
        EmpID,
        Employee_Name,
        ShiftAnchorDate,
        CalendarDate,
        ActualQualifyingHours,
        MinimumHours,
        GapHours,
        PayComponent,
        MultiplierUsed,
        AllocatedLaborPayrollID,
        AllocatedDate,
        AllocationMethod,
        RateBaseUsed,
        RateShiftUsed,
        RateBoomUsed,
        AllocatedGapPay,
        AllocationRank
    )
    SELECT
        TempGroupID,
        GroupKey,
        RuleCode,
        RuleName,
        ScopeBasis,
        GroupScope,
        EmpID,
        Employee_Name,
        ShiftAnchorDate,
        CalendarDate,
        ActualQualifyingHours,
        MinimumHours,
        GapHours,
        PayComponent,
        MultiplierUsed,
        AllocatedLaborPayrollID,
        AllocatedDate,
        AllocationMethod,
        RateBaseUsed,
        RateShiftUsed,
        RateBoomUsed,
        AllocatedGapPay,
        AllocationRank
    FROM AllocCandidates
    WHERE AllocationRank = 1;

    CREATE INDEX IX_AllAlloc_GroupKey
        ON #AllAlloc(GroupKey);

    CREATE INDEX IX_AllAlloc_LPID
        ON #AllAlloc(AllocatedLaborPayrollID);


    /* ============================================================
       Insert audit rows
       ============================================================ */

    INSERT INTO fms.Payroll_GuaranteeGroup
    (
        RunId,
        GroupKey,
        RuleCode,
        RuleName,
        ScopeBasis,
        GroupScope,
        EmpID,
        Employee_Name,
        ShiftAnchorDate,
        CalendarDate,
        ActualQualifyingHours,
        MinimumHours,
        GapHours,
        PayComponent,
        MultiplierUsed,
        TriggeredFlag,
        SatisfiedFlag,
        WorkDateFrom,
        WorkDateTo,
        CalculatedAtUTC
    )
    SELECT
        @RunId,
        GroupKey,
        RuleCode,
        RuleName,
        ScopeBasis,
        GroupScope,
        EmpID,
        Employee_Name,
        ShiftAnchorDate,
        CalendarDate,
        ActualQualifyingHours,
        MinimumHours,
        GapHours,
        PayComponent,
        MultiplierUsed,
        TriggeredFlag = CONVERT(bit, CASE WHEN GapHours > 0 THEN 1 ELSE 0 END),
        SatisfiedFlag = CONVERT(bit, CASE WHEN GapHours = 0 THEN 1 ELSE 0 END),
        @WorkDateFrom,
        @WorkDateTo,
        @CalcRunAtUTC
    FROM #AllGroups;

    INSERT INTO fms.Payroll_GuaranteeAllocation
    (
        GuaranteeGroupID,
        RunId,
        LaborPayrollID,
        AllocatedDate,
        AllocatedGapHours,
        AllocatedGapPay,
        AllocationMethod,
        RateBaseUsed,
        RateShiftUsed,
        RateBoomUsed,
        MultiplierUsed,
        Explanation,
        CalculatedAtUTC
    )
    SELECT
        gg.GuaranteeGroupID,
        @RunId,
        a.AllocatedLaborPayrollID,
        a.AllocatedDate,
        a.GapHours,
        a.AllocatedGapPay,
        a.AllocationMethod,
        a.RateBaseUsed,
        a.RateShiftUsed,
        a.RateBoomUsed,
        a.MultiplierUsed,
        Explanation =
            CONCAT
            (
                a.RuleCode,
                ': ',
                CONVERT(varchar(30), a.ActualQualifyingHours),
                ' actual qualifying hrs / ',
                CONVERT(varchar(30), a.MinimumHours),
                ' required; gap=',
                CONVERT(varchar(30), a.GapHours)
            ),
        @CalcRunAtUTC
    FROM #AllAlloc a
    JOIN fms.Payroll_GuaranteeGroup gg
        ON gg.GroupKey = a.GroupKey
        AND gg.CalculatedAtUTC = @CalcRunAtUTC;


    /* ============================================================
       Apply compatibility fields back to Payroll_Calculated
       ============================================================ */

    ;WITH AllocAgg AS
    (
        SELECT
            AllocatedLaborPayrollID = a.LaborPayrollID,

            Gap_Hrs_Total =
                CAST(SUM(CASE WHEN g.PayComponent <> 'BoomOnly' THEN a.AllocatedGapHours ELSE 0.00 END) AS decimal(10,2)),

            Gap_Hrs_Boom =
                CAST(SUM(CASE WHEN g.PayComponent = 'BoomOnly' THEN a.AllocatedGapHours ELSE 0.00 END) AS decimal(10,2)),

            Pay_Gap_Add =
                CAST(SUM(a.AllocatedGapPay) AS decimal(12,2)),

            Audit_Min_Rule =
                CAST(MAX(g.MinimumHours) AS decimal(4,1)),

            Audit_Gap_Mult =
                CAST(MAX(g.MultiplierUsed) AS decimal(4,2))
        FROM fms.Payroll_GuaranteeAllocation a
        JOIN fms.Payroll_GuaranteeGroup g
            ON g.GuaranteeGroupID = a.GuaranteeGroupID
        WHERE g.CalculatedAtUTC = @CalcRunAtUTC
        GROUP BY
            a.LaborPayrollID
    )
    UPDATE pc
       SET
            pc.Gap_Hrs_Total = ISNULL(a.Gap_Hrs_Total, 0.00),
            pc.Gap_Hrs_Boom  = ISNULL(a.Gap_Hrs_Boom, 0.00),
            pc.Pay_Total_Hrs = ISNULL(pc.Act_Total_Hrs, 0.00) + ISNULL(a.Gap_Hrs_Total, 0.00),
            pc.Pay_Gap_Add   = ISNULL(a.Pay_Gap_Add, 0.00),
            pc.Audit_Min_Rule = ISNULL(a.Audit_Min_Rule, 0.0),
            pc.Audit_Gap_Mult = ISNULL(a.Audit_Gap_Mult, 1.0),
            pc.Final_Gross_Pay =
                CONVERT(decimal(12,2),
                    ISNULL(pc.Pay_Actual_Gross, 0.00)
                + ISNULL(a.Pay_Gap_Add, 0.00)
                + ISNULL(pc.Pay_Rest_Add, 0.00)
                )
    FROM fms.Payroll_Calculated pc
    LEFT JOIN AllocAgg a
        ON a.AllocatedLaborPayrollID = pc.LaborPayrollID
    WHERE
        pc.WorkDate >= @FromDT
        AND pc.WorkDate < @ToExDT;

    DECLARE @GroupRows int = (SELECT COUNT(*) FROM #AllGroups);
    DECLARE @AllocRows int = (SELECT COUNT(*) FROM #AllAlloc);

    PRINT CONCAT('Guaranteed-hours groups created: ', @GroupRows);
    PRINT CONCAT('Guaranteed-hours allocations created: ', @AllocRows);
END;
