
CREATE   PROCEDURE app.usp_Preview_CA_NonUnionAdminHourly_OT
    @WorkDateFrom date,
    @WorkDateTo   date
AS
BEGIN
    SET NOCOUNT ON;

    IF @WorkDateFrom IS NULL OR @WorkDateTo IS NULL
    BEGIN
        THROW 51000, 'WorkDateFrom and WorkDateTo are required.', 1;
    END;

    IF @WorkDateTo < @WorkDateFrom
    BEGIN
        THROW 51001, 'WorkDateTo must be greater than or equal to WorkDateFrom.', 1;
    END;

    IF OBJECT_ID('tempdb..#LaborBase') IS NOT NULL DROP TABLE #LaborBase;
    IF OBJECT_ID('tempdb..#DailyRaw') IS NOT NULL DROP TABLE #DailyRaw;
    IF OBJECT_ID('tempdb..#DailyBaseRule') IS NOT NULL DROP TABLE #DailyBaseRule;
    IF OBJECT_ID('tempdb..#DayPreview') IS NOT NULL DROP TABLE #DayPreview;
    IF OBJECT_ID('tempdb..#WeekPreview') IS NOT NULL DROP TABLE #WeekPreview;

    SELECT
        b.LaborPayrollID,
        b.EmpID,
        Employee_Name =
            COALESCE(NULLIF(LTRIM(RTRIM(pgr.Employee_Name)), ''), '(Unknown Employee)'),
        b.WorkDate,
        PeriodStart =
            DATEADD(day, -((DATEDIFF(day, '19000106', b.WorkDate) % 7 + 7) % 7), b.WorkDate),
        PeriodEnd =
            DATEADD(day, 6 - ((DATEDIFF(day, '19000106', b.WorkDate) % 7 + 7) % 7), b.WorkDate),

        PayrollGroup = pgr.PayrollGroup,
        LaborCraftCode = b.CraftCode,
        EmployeeCraftCode = pgr.CraftCode,
        EmployeePayType = pgr.PayType,
        RegularRate = CAST(pgr.BaseHourlyRate AS decimal(19,4)),

        Act_Total_Hrs = CAST(ISNULL(pc.Act_Total_Hrs, 0) AS decimal(12,4)),
        Hrs_ST_Current = CAST(ISNULL(pc.Hrs_ST, 0) AS decimal(12,4)),
        Hrs_OT_Current = CAST(ISNULL(pc.Hrs_OT, 0) AS decimal(12,4)),
        Hrs_DT_Current = CAST(ISNULL(pc.Hrs_DT, 0) AS decimal(12,4))
    INTO #LaborBase
    FROM app.v_Base_LaborPayroll b
    LEFT JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = b.LaborPayrollID
    LEFT JOIN api.v_UI_Employee_PayrollGroupRate pgr
        ON pgr.EmpID = b.EmpID
    WHERE b.WorkDate >= @WorkDateFrom
      AND b.WorkDate <= @WorkDateTo
      AND ISNULL(pgr.IsVisibleInPayrollUI, 1) = 1
      AND pgr.PayrollGroup = 'Non-Union Admin Hourly';


    /* Result set 1: Review rows */
    SELECT
        ReviewType = 'Non-Union Admin Hourly with non-ADMIN labor craft',
        EmpID,
        Employee_Name,
        WorkDate,
        PeriodStart,
        PeriodEnd,
        LaborPayrollID,
        LaborCraftCode,
        Act_Total_Hrs,
        RegularRate
    FROM #LaborBase
    WHERE ISNULL(LaborCraftCode, '') NOT LIKE 'ADMIN%'
    ORDER BY
        WorkDate,
        Employee_Name,
        LaborPayrollID;


    /* Daily raw actual worked hours */
    SELECT
        EmpID,
        Employee_Name,
        WorkDate,
        PeriodStart,
        PeriodEnd,
        DayOffset = DATEDIFF(day, PeriodStart, WorkDate),
        DailyActualHours = SUM(Act_Total_Hrs),
        LaborRows = COUNT(*),
        RegularRate = MAX(RegularRate),
        MissingRateRows =
            SUM(CASE WHEN ISNULL(RegularRate, 0) <= 0 THEN 1 ELSE 0 END),
        CurrentST = SUM(Hrs_ST_Current),
        CurrentOT = SUM(Hrs_OT_Current),
        CurrentDT = SUM(Hrs_DT_Current)
    INTO #DailyRaw
    FROM #LaborBase
    WHERE ISNULL(LaborCraftCode, '') LIKE 'ADMIN%'
      AND Act_Total_Hrs > 0
    GROUP BY
        EmpID,
        Employee_Name,
        WorkDate,
        PeriodStart,
        PeriodEnd;


    /* Daily base rule before weekly OT */
    SELECT
        d.EmpID,
        d.Employee_Name,
        d.WorkDate,
        d.PeriodStart,
        d.PeriodEnd,
        d.DayOffset,
        WorkedDayCount = wc.WorkedDayCount,
        IsSeventhConsecutiveDay =
            CAST(CASE WHEN wc.WorkedDayCount = 7 AND d.DayOffset = 6 THEN 1 ELSE 0 END AS bit),
        d.LaborRows,
        d.DailyActualHours,
        d.RegularRate,
        d.MissingRateRows,
        d.CurrentST,
        d.CurrentOT,
        d.CurrentDT,

        ST_DailyBase =
            CAST(
                CASE
                    WHEN wc.WorkedDayCount = 7 AND d.DayOffset = 6 THEN 0
                    WHEN d.DailyActualHours <= 8 THEN d.DailyActualHours
                    ELSE 8
                END
            AS decimal(12,4)),

        OT_Daily =
            CAST(
                CASE
                    WHEN wc.WorkedDayCount = 7 AND d.DayOffset = 6 THEN 0
                    WHEN d.DailyActualHours > 8
                        THEN CASE WHEN d.DailyActualHours <= 12 THEN d.DailyActualHours - 8 ELSE 4 END
                    ELSE 0
                END
            AS decimal(12,4)),

        DT_Daily =
            CAST(
                CASE
                    WHEN wc.WorkedDayCount = 7 AND d.DayOffset = 6 THEN 0
                    WHEN d.DailyActualHours > 12 THEN d.DailyActualHours - 12
                    ELSE 0
                END
            AS decimal(12,4)),

        OT_SeventhDay =
            CAST(
                CASE
                    WHEN wc.WorkedDayCount = 7 AND d.DayOffset = 6
                        THEN CASE WHEN d.DailyActualHours <= 8 THEN d.DailyActualHours ELSE 8 END
                    ELSE 0
                END
            AS decimal(12,4)),

        DT_SeventhDay =
            CAST(
                CASE
                    WHEN wc.WorkedDayCount = 7 AND d.DayOffset = 6 AND d.DailyActualHours > 8
                        THEN d.DailyActualHours - 8
                    ELSE 0
                END
            AS decimal(12,4))
    INTO #DailyBaseRule
    FROM #DailyRaw d
    JOIN
    (
        SELECT
            EmpID,
            PeriodStart,
            WorkedDayCount = COUNT(*)
        FROM #DailyRaw
        GROUP BY
            EmpID,
            PeriodStart
    ) wc
        ON wc.EmpID = d.EmpID
       AND wc.PeriodStart = d.PeriodStart;


    /* Final day preview with weekly OT allocated to later straight-time days */
    SELECT
        d.EmpID,
        d.Employee_Name,
        d.WorkDate,
        d.PeriodStart,
        d.PeriodEnd,
        d.DayOffset,
        d.WorkedDayCount,
        d.IsSeventhConsecutiveDay,
        d.LaborRows,
        d.DailyActualHours,
        d.RegularRate,
        d.MissingRateRows,

        d.ST_DailyBase,
        d.OT_Daily,
        d.DT_Daily,
        d.OT_SeventhDay,
        d.DT_SeventhDay,

        CumSTBeforeDay =
            CAST(ISNULL(prev.CumSTBeforeDay, 0) AS decimal(12,4)),

        CumSTThroughDay =
            CAST(ISNULL(prev.CumSTBeforeDay, 0) + d.ST_DailyBase AS decimal(12,4)),

        WeeklyOT_FromThisDay =
            CAST(
                CASE
                    WHEN ISNULL(prev.CumSTBeforeDay, 0) + d.ST_DailyBase <= 40 THEN 0
                    WHEN ISNULL(prev.CumSTBeforeDay, 0) >= 40 THEN d.ST_DailyBase
                    ELSE ISNULL(prev.CumSTBeforeDay, 0) + d.ST_DailyBase - 40
                END
            AS decimal(12,4)),

        PreviewST =
            CAST(
                d.ST_DailyBase -
                CASE
                    WHEN ISNULL(prev.CumSTBeforeDay, 0) + d.ST_DailyBase <= 40 THEN 0
                    WHEN ISNULL(prev.CumSTBeforeDay, 0) >= 40 THEN d.ST_DailyBase
                    ELSE ISNULL(prev.CumSTBeforeDay, 0) + d.ST_DailyBase - 40
                END
            AS decimal(12,4)),

        PreviewOT =
            CAST(
                d.OT_Daily
                + d.OT_SeventhDay
                + CASE
                    WHEN ISNULL(prev.CumSTBeforeDay, 0) + d.ST_DailyBase <= 40 THEN 0
                    WHEN ISNULL(prev.CumSTBeforeDay, 0) >= 40 THEN d.ST_DailyBase
                    ELSE ISNULL(prev.CumSTBeforeDay, 0) + d.ST_DailyBase - 40
                  END
            AS decimal(12,4)),

        PreviewDT =
            CAST(d.DT_Daily + d.DT_SeventhDay AS decimal(12,4)),

        d.CurrentST,
        d.CurrentOT,
        d.CurrentDT
    INTO #DayPreview
    FROM #DailyBaseRule d
    OUTER APPLY
    (
        SELECT
            CumSTBeforeDay = SUM(p.ST_DailyBase)
        FROM #DailyBaseRule p
        WHERE p.EmpID = d.EmpID
          AND p.PeriodStart = d.PeriodStart
          AND p.WorkDate < d.WorkDate
    ) prev;


    SELECT
        EmpID,
        Employee_Name,
        PeriodStart,
        PeriodEnd,
        WorkedDayCount = MAX(WorkedDayCount),
        LaborRows = SUM(LaborRows),
        ActualHours = SUM(DailyActualHours),
        RegularRate = MAX(RegularRate),
        MissingRateRows = SUM(MissingRateRows),

        PreviewST = SUM(PreviewST),
        PreviewOT = SUM(PreviewOT),
        PreviewDT = SUM(PreviewDT),
        PreviewTotalBuckets = SUM(PreviewST + PreviewOT + PreviewDT),

        PreviewWeightedHours =
            SUM(PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT)),

        PreviewGross =
            SUM(RegularRate * (PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT))),

        CurrentST = SUM(CurrentST),
        CurrentOT = SUM(CurrentOT),
        CurrentDT = SUM(CurrentDT),
        CurrentTotalBuckets = SUM(CurrentST + CurrentOT + CurrentDT),

        CurrentWeightedHours =
            SUM(CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT)),

        DeltaWeightedHours =
            SUM(PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT))
            - SUM(CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT))
    INTO #WeekPreview
    FROM #DayPreview
    GROUP BY
        EmpID,
        Employee_Name,
        PeriodStart,
        PeriodEnd;


    /* Result set 2: High-level preview totals */
    SELECT
        Employees = COUNT(DISTINCT EmpID),
        Weeks = COUNT(*),
        ActualHours = SUM(ActualHours),

        PreviewST = SUM(PreviewST),
        PreviewOT = SUM(PreviewOT),
        PreviewDT = SUM(PreviewDT),
        PreviewWeightedHours = SUM(PreviewWeightedHours),
        PreviewGross = SUM(PreviewGross),

        CurrentST = SUM(CurrentST),
        CurrentOT = SUM(CurrentOT),
        CurrentDT = SUM(CurrentDT),
        CurrentWeightedHours = SUM(CurrentWeightedHours),

        DeltaWeightedHours = SUM(DeltaWeightedHours),
        WeeksWithMissingRate = SUM(CASE WHEN MissingRateRows > 0 THEN 1 ELSE 0 END)
    FROM #WeekPreview;


    /* Result set 3: Week-level comparison */
    SELECT
        EmpID,
        Employee_Name,
        PeriodStart,
        PeriodEnd,
        WorkedDayCount,
        LaborRows,
        ActualHours,
        RegularRate,

        PreviewST,
        PreviewOT,
        PreviewDT,
        PreviewWeightedHours,
        PreviewGross,

        CurrentST,
        CurrentOT,
        CurrentDT,
        CurrentWeightedHours,

        DeltaWeightedHours
    FROM #WeekPreview
    WHERE ABS(DeltaWeightedHours) >= 0.0001
       OR MissingRateRows > 0
    ORDER BY
        ABS(DeltaWeightedHours) DESC,
        PeriodStart,
        Employee_Name;


    /* Result set 4: Day-level detail */
    SELECT
        EmpID,
        Employee_Name,
        WorkDate,
        PeriodStart,
        PeriodEnd,
        DayOffset,
        WorkedDayCount,
        IsSeventhConsecutiveDay,
        LaborRows,
        DailyActualHours,
        RegularRate,

        PreviewST,
        PreviewOT,
        PreviewDT,

        OT_Daily,
        DT_Daily,
        OT_SeventhDay,
        DT_SeventhDay,
        WeeklyOT_FromThisDay,

        CurrentST,
        CurrentOT,
        CurrentDT,

        PreviewWeightedHours =
            CAST(PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT) AS decimal(12,4)),

        CurrentWeightedHours =
            CAST(CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT) AS decimal(12,4))
    FROM #DayPreview
    WHERE PreviewOT > 0
       OR PreviewDT > 0
       OR IsSeventhConsecutiveDay = 1
    ORDER BY
        WorkDate,
        Employee_Name;


    /* Result set 5: Weeks that use weekly OT reclassification */
    SELECT
        EmpID,
        Employee_Name,
        PeriodStart,
        PeriodEnd,
        ActualHours = SUM(DailyActualHours),
        PreviewST = SUM(PreviewST),
        PreviewOT = SUM(PreviewOT),
        PreviewDT = SUM(PreviewDT),
        WeeklyOT_Total = SUM(WeeklyOT_FromThisDay)
    FROM #DayPreview
    GROUP BY
        EmpID,
        Employee_Name,
        PeriodStart,
        PeriodEnd
    HAVING SUM(WeeklyOT_FromThisDay) > 0
    ORDER BY
        PeriodStart,
        Employee_Name;


    /* Result set 6: Seventh-consecutive-day cases */
    SELECT
        EmpID,
        Employee_Name,
        WorkDate,
        PeriodStart,
        PeriodEnd,
        DailyActualHours,
        PreviewST,
        PreviewOT,
        PreviewDT,
        OT_SeventhDay,
        DT_SeventhDay
    FROM #DayPreview
    WHERE IsSeventhConsecutiveDay = 1
    ORDER BY
        PeriodStart,
        Employee_Name;

END;
