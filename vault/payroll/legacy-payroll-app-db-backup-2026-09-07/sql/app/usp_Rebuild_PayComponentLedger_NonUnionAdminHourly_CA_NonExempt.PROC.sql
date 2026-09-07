CREATE     PROCEDURE [app].[usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt]
    @WorkDateFrom date,
    @WorkDateTo   date,
    @PreviewOnly  bit = 1,
    @RequestedBy  sysname = NULL,
    @RunId        int = NULL,
    @ReturnResults bit = 1
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @RunId =
        COALESCE
        (
            @RunId,
            TRY_CONVERT
            (
                int,
                SESSION_CONTEXT(N'PayrollAPP_RunLogID')
            )
        );

    DECLARE @StartedAtUTC datetime2(3) = SYSUTCDATETIME();
    DECLARE @RowsDeleted int = 0;
    DECLARE @RowsInserted int = 0;

    IF @WorkDateFrom IS NULL OR @WorkDateTo IS NULL
    BEGIN
        THROW 51000, 'WorkDateFrom and WorkDateTo are required.', 1;
    END;

    IF @WorkDateTo < @WorkDateFrom
    BEGIN
        THROW 51001, 'WorkDateTo must be greater than or equal to WorkDateFrom.', 1;
    END;

    DROP TABLE IF EXISTS #LaborBase;
    DROP TABLE IF EXISTS #DailyDay;
    DROP TABLE IF EXISTS #DailyRule;
    DROP TABLE IF EXISTS #DailyRows;
    DROP TABLE IF EXISTS #RowDailyAllocated;
    DROP TABLE IF EXISTS #RowPreview;
    DROP TABLE IF EXISTS #ComponentInitial;
    DROP TABLE IF EXISTS #ComponentFinal;
    DROP TABLE IF EXISTS #ExistingLedgerRows;
    DROP TABLE IF EXISTS #LedgerReconciliation;

    ;WITH Base AS
    (
        SELECT
            calc.CalcID,
            calc.LaborPayrollID,
            calc.WorkDate,
            calc.JobTicketID,
            calc.JobCode,
            calc.EmpID,
            calc.Employee_Name,
            Act_Total_Hrs = CAST(ISNULL(calc.Act_Total_Hrs, 0) AS decimal(18,4)),
            CurrentHrs_ST = CAST(ISNULL(calc.Hrs_ST, 0) AS decimal(18,4)),
            CurrentHrs_OT = CAST(ISNULL(calc.Hrs_OT, 0) AS decimal(18,4)),
            CurrentHrs_DT = CAST(ISNULL(calc.Hrs_DT, 0) AS decimal(18,4)),
            CurrentPayActualGross = CAST(ISNULL(calc.Pay_Actual_Gross, 0) AS decimal(19,4)),
            CurrentFinalGross = CAST(ISNULL(calc.Final_Gross_Pay, 0) AS decimal(19,4)),
            LaborCraftCode = blp.CraftCode,
            blp.TimeStart_Labor,
            blp.TimeEnd_Labor,
            StartTimeOfDay = TRY_CONVERT(time(0), blp.TimeStart_Labor),
            EndTimeOfDay   = TRY_CONVERT(time(0), blp.TimeEnd_Labor),
            RegularRate = CAST(pgr.BaseHourlyRate AS decimal(12,4)),
            PeriodStart = DATEADD(day, -DATEDIFF(day, CONVERT(date, '19000106'), calc.WorkDate) % 7, calc.WorkDate),
            PeriodEnd   = DATEADD(day,  6 - DATEDIFF(day, CONVERT(date, '19000106'), calc.WorkDate) % 7, calc.WorkDate)
        FROM fms.Payroll_Calculated calc
        JOIN api.v_UI_Employee_PayrollGroupRate pgr
            ON pgr.EmpID = calc.EmpID
        LEFT JOIN app.v_Base_LaborPayroll blp
            ON blp.LaborPayrollID = calc.LaborPayrollID
        WHERE calc.WorkDate >= @WorkDateFrom
          AND calc.WorkDate <= @WorkDateTo
          AND pgr.PayrollGroup = 'Non-Union Admin Hourly'
          AND ISNULL(pgr.IsVisibleInPayrollUI, 1) = 1
          AND ISNULL(calc.Act_Total_Hrs, 0) > 0
          AND ISNULL(pgr.BaseHourlyRate, 0) > 0
          AND ISNULL(blp.CraftCode, '') LIKE 'ADMIN%'
    ), Anchored AS
    (
        SELECT
            b.*,
            StartSecondsOfDay = CASE WHEN b.StartTimeOfDay IS NULL THEN NULL ELSE DATEDIFF(second, CONVERT(time(0), '00:00:00'), b.StartTimeOfDay) END,
            EndSecondsOfDay   = CASE WHEN b.EndTimeOfDay   IS NULL THEN NULL ELSE DATEDIFF(second, CONVERT(time(0), '00:00:00'), b.EndTimeOfDay) END
        FROM Base b
    )
    SELECT
        a.*,
        AnchoredStartDateTime = CASE
            WHEN a.StartTimeOfDay IS NULL THEN NULL
            ELSE DATEADD(second, a.StartSecondsOfDay, CAST(a.WorkDate AS datetime2(0)))
        END,
        AnchoredEndDateTime = CASE
            WHEN a.EndTimeOfDay IS NULL THEN NULL
            WHEN a.StartTimeOfDay IS NOT NULL AND a.EndSecondsOfDay < a.StartSecondsOfDay
                THEN DATEADD(day, 1, DATEADD(second, a.EndSecondsOfDay, CAST(a.WorkDate AS datetime2(0))))
            ELSE DATEADD(second, a.EndSecondsOfDay, CAST(a.WorkDate AS datetime2(0)))
        END,
        SortStartSeconds = CASE WHEN a.StartTimeOfDay IS NULL THEN 86400 ELSE a.StartSecondsOfDay END,
        SortEndSeconds   = CASE WHEN a.EndTimeOfDay   IS NULL THEN 86400 ELSE a.EndSecondsOfDay END,
        AllocationSortMethod = CASE WHEN a.StartTimeOfDay IS NULL THEN 'LABORPAYROLLID_FALLBACK' ELSE 'TIME_OF_DAY_ORDER' END,
        AllocationOrderReviewFlag = CONVERT(bit, CASE
            WHEN a.StartTimeOfDay IS NULL THEN 1
            WHEN a.EndTimeOfDay IS NULL THEN 1
            WHEN a.EndSecondsOfDay < a.StartSecondsOfDay THEN 1
            WHEN CONVERT(date, a.TimeStart_Labor) <> a.WorkDate THEN 1
            WHEN CONVERT(date, a.TimeEnd_Labor) NOT IN (a.WorkDate, DATEADD(day, 1, a.WorkDate)) THEN 1
            ELSE 0
        END),
        AllocationOrderReviewMessage = CONCAT(
            CASE WHEN a.StartTimeOfDay IS NULL THEN 'Missing start time; ordered by LaborPayrollID fallback.; ' ELSE '' END,
            CASE WHEN a.EndTimeOfDay IS NULL THEN 'Missing end time.; ' ELSE '' END,
            CASE WHEN a.StartTimeOfDay IS NOT NULL AND a.EndTimeOfDay IS NOT NULL AND a.EndSecondsOfDay < a.StartSecondsOfDay
                 THEN 'End time-of-day is before start time-of-day; anchored as overnight ending on next day.; ' ELSE '' END,
            CASE WHEN a.StartTimeOfDay IS NOT NULL AND CONVERT(date, a.TimeStart_Labor) <> a.WorkDate
                 THEN 'TimeStart date portion does not match WorkDate; using time-of-day anchored to WorkDate.; ' ELSE '' END,
            CASE WHEN a.EndTimeOfDay IS NOT NULL AND CONVERT(date, a.TimeEnd_Labor) NOT IN (a.WorkDate, DATEADD(day, 1, a.WorkDate))
                 THEN 'TimeEnd date portion does not match WorkDate; using time-of-day anchored to WorkDate or next day.; ' ELSE '' END
        )
    INTO #LaborBase
    FROM Anchored a;

    CREATE INDEX IX_LaborBase_Key ON #LaborBase(EmpID, PeriodStart, WorkDate, SortStartSeconds, SortEndSeconds, LaborPayrollID);
    CREATE INDEX IX_LaborBase_LPID ON #LaborBase(LaborPayrollID);

    SELECT
        EmpID,
        PeriodStart,
        PeriodEnd = MAX(PeriodEnd),
        WorkDate,
        DayOffset = DATEDIFF(day, PeriodStart, WorkDate),
        DayActualHours = SUM(Act_Total_Hrs)
    INTO #DailyDay
    FROM #LaborBase
    GROUP BY EmpID, PeriodStart, WorkDate;

    SELECT
        dd.*,
        WorkedDayCount = COUNT(*) OVER (PARTITION BY dd.EmpID, dd.PeriodStart),
        IsSeventhConsecutiveDay = CONVERT(bit, CASE
            WHEN dd.DayOffset = 6
             AND COUNT(*) OVER (PARTITION BY dd.EmpID, dd.PeriodStart) = 7
            THEN 1 ELSE 0 END)
    INTO #DailyRule
    FROM #DailyDay dd;

    SELECT
        lb.*,
        dr.DayActualHours,
        dr.WorkedDayCount,
        dr.IsSeventhConsecutiveDay,
        DailyHoursBeforeThisRow = CAST(
            ISNULL(SUM(lb.Act_Total_Hrs) OVER (
                PARTITION BY lb.EmpID, lb.WorkDate
                ORDER BY lb.SortStartSeconds, lb.SortEndSeconds, lb.LaborPayrollID
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ), 0) AS decimal(18,4)),
        DailyHoursThroughThisRow = CAST(
            SUM(lb.Act_Total_Hrs) OVER (
                PARTITION BY lb.EmpID, lb.WorkDate
                ORDER BY lb.SortStartSeconds, lb.SortEndSeconds, lb.LaborPayrollID
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS decimal(18,4))
    INTO #DailyRows
    FROM #LaborBase lb
    JOIN #DailyRule dr
        ON dr.EmpID = lb.EmpID
       AND dr.PeriodStart = lb.PeriodStart
       AND dr.WorkDate = lb.WorkDate;

    ;WITH Alloc AS
    (
        SELECT
            d.*,
            Non7_ST_End = CASE WHEN d.DailyHoursThroughThisRow < 8 THEN d.DailyHoursThroughThisRow ELSE CAST(8 AS decimal(18,4)) END,
            Non7_ST_Start = CASE WHEN d.DailyHoursBeforeThisRow < 8 THEN d.DailyHoursBeforeThisRow ELSE CAST(8 AS decimal(18,4)) END,
            Non7_OT_End = CASE
                WHEN d.DailyHoursThroughThisRow <= 8 THEN CAST(0 AS decimal(18,4))
                WHEN d.DailyHoursThroughThisRow <= 12 THEN d.DailyHoursThroughThisRow - 8
                ELSE CAST(4 AS decimal(18,4))
            END,
            Non7_OT_Start = CASE
                WHEN d.DailyHoursBeforeThisRow <= 8 THEN CAST(0 AS decimal(18,4))
                WHEN d.DailyHoursBeforeThisRow <= 12 THEN d.DailyHoursBeforeThisRow - 8
                ELSE CAST(4 AS decimal(18,4))
            END,
            Non7_DT_End = CASE WHEN d.DailyHoursThroughThisRow > 12 THEN d.DailyHoursThroughThisRow - 12 ELSE CAST(0 AS decimal(18,4)) END,
            Non7_DT_Start = CASE WHEN d.DailyHoursBeforeThisRow > 12 THEN d.DailyHoursBeforeThisRow - 12 ELSE CAST(0 AS decimal(18,4)) END,
            Seventh_OT_End = CASE WHEN d.DailyHoursThroughThisRow < 8 THEN d.DailyHoursThroughThisRow ELSE CAST(8 AS decimal(18,4)) END,
            Seventh_OT_Start = CASE WHEN d.DailyHoursBeforeThisRow < 8 THEN d.DailyHoursBeforeThisRow ELSE CAST(8 AS decimal(18,4)) END,
            Seventh_DT_End = CASE WHEN d.DailyHoursThroughThisRow > 8 THEN d.DailyHoursThroughThisRow - 8 ELSE CAST(0 AS decimal(18,4)) END,
            Seventh_DT_Start = CASE WHEN d.DailyHoursBeforeThisRow > 8 THEN d.DailyHoursBeforeThisRow - 8 ELSE CAST(0 AS decimal(18,4)) END
        FROM #DailyRows d
    )
    SELECT
        a.*,
        RowST_DailyBase = CAST(CASE
            WHEN a.IsSeventhConsecutiveDay = 1 THEN 0
            ELSE a.Non7_ST_End - a.Non7_ST_Start
        END AS decimal(18,4)),
        RowOT_BeforeWeekly = CAST(CASE
            WHEN a.IsSeventhConsecutiveDay = 1 THEN a.Seventh_OT_End - a.Seventh_OT_Start
            ELSE a.Non7_OT_End - a.Non7_OT_Start
        END AS decimal(18,4)),
        RowDT = CAST(CASE
            WHEN a.IsSeventhConsecutiveDay = 1 THEN a.Seventh_DT_End - a.Seventh_DT_Start
            ELSE a.Non7_DT_End - a.Non7_DT_Start
        END AS decimal(18,4))
    INTO #RowDailyAllocated
    FROM Alloc a;

    ;WITH Weekly AS
    (
        SELECT
            rda.*,
            WeeklySTBeforeThisRow = CAST(
                ISNULL(SUM(rda.RowST_DailyBase) OVER (
                    PARTITION BY rda.EmpID, rda.PeriodStart
                    ORDER BY rda.WorkDate, rda.SortStartSeconds, rda.SortEndSeconds, rda.LaborPayrollID
                    ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                ), 0) AS decimal(18,4)),
            WeeklySTThroughThisRow = CAST(
                SUM(rda.RowST_DailyBase) OVER (
                    PARTITION BY rda.EmpID, rda.PeriodStart
                    ORDER BY rda.WorkDate, rda.SortStartSeconds, rda.SortEndSeconds, rda.LaborPayrollID
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                ) AS decimal(18,4))
        FROM #RowDailyAllocated rda
    )
    SELECT
        w.*,
        WeeklyOT_FromThisRow = CAST(CASE
            WHEN w.RowST_DailyBase <= 0 THEN 0
            WHEN w.WeeklySTBeforeThisRow >= 40 THEN w.RowST_DailyBase
            WHEN w.WeeklySTThroughThisRow <= 40 THEN 0
            ELSE w.WeeklySTThroughThisRow - 40
        END AS decimal(18,4)),
        PreviewST = CAST(w.RowST_DailyBase - CASE
            WHEN w.RowST_DailyBase <= 0 THEN 0
            WHEN w.WeeklySTBeforeThisRow >= 40 THEN w.RowST_DailyBase
            WHEN w.WeeklySTThroughThisRow <= 40 THEN 0
            ELSE w.WeeklySTThroughThisRow - 40
        END AS decimal(18,4)),
        PreviewOT = CAST(w.RowOT_BeforeWeekly + CASE
            WHEN w.RowST_DailyBase <= 0 THEN 0
            WHEN w.WeeklySTBeforeThisRow >= 40 THEN w.RowST_DailyBase
            WHEN w.WeeklySTThroughThisRow <= 40 THEN 0
            ELSE w.WeeklySTThroughThisRow - 40
        END AS decimal(18,4)),
        PreviewDT = CAST(w.RowDT AS decimal(18,4))
    INTO #RowPreview
    FROM Weekly w;

    CREATE INDEX IX_RowPreview_LPID ON #RowPreview(LaborPayrollID);

    ;WITH C AS
    (
        SELECT
            rp.*,
            ComponentCode = CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_ST'),
            ComponentGroup = CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT'),
            ComponentLabel = CONVERT(varchar(160), 'Non-Union CA Nonexempt Straight Time'),
            SourceRuleCode = CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_ST'),
            SourceRuleName = CONVERT(varchar(160), 'Non-union CA nonexempt straight time'),
            ComponentHours = CAST(rp.PreviewST AS decimal(18,4)),
            ComponentHrs_ST = CAST(rp.PreviewST AS decimal(18,4)),
            ComponentHrs_OT = CAST(0 AS decimal(18,4)),
            ComponentHrs_DT = CAST(0 AS decimal(18,4)),
            MultiplierUsed = CAST(1.00 AS decimal(10,2)),
            DisplaySort = 110,
            Explanation = CONVERT(nvarchar(4000), 'Non-union hourly straight-time hours after California daily, weekly, and seventh-day overtime allocation.')
        FROM #RowPreview rp
        WHERE rp.PreviewST > 0

        UNION ALL

        SELECT
            rp.*,
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_DAILY_OT'),
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT'),
            CONVERT(varchar(160), 'Non-Union CA Nonexempt Daily Overtime'),
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_DAILY_OT'),
            CONVERT(varchar(160), 'California daily overtime over 8 and through 12 hours'),
            CAST(CASE WHEN rp.IsSeventhConsecutiveDay = 0 THEN rp.RowOT_BeforeWeekly ELSE 0 END AS decimal(18,4)),
            CAST(0 AS decimal(18,4)),
            CAST(CASE WHEN rp.IsSeventhConsecutiveDay = 0 THEN rp.RowOT_BeforeWeekly ELSE 0 END AS decimal(18,4)),
            CAST(0 AS decimal(18,4)),
            CAST(1.50 AS decimal(10,2)),
            120,
            CONVERT(nvarchar(4000), 'Non-union hourly daily overtime generated by California daily overtime rules; excludes weekly overtime and seventh-day overtime.')
        FROM #RowPreview rp
        WHERE rp.IsSeventhConsecutiveDay = 0
          AND rp.RowOT_BeforeWeekly > 0

        UNION ALL

        SELECT
            rp.*,
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_WEEKLY_OT'),
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT'),
            CONVERT(varchar(160), 'Non-Union CA Nonexempt Weekly Overtime'),
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_WEEKLY_OT'),
            CONVERT(varchar(160), 'California weekly overtime over 40 straight-time hours'),
            CAST(rp.WeeklyOT_FromThisRow AS decimal(18,4)),
            CAST(0 AS decimal(18,4)),
            CAST(rp.WeeklyOT_FromThisRow AS decimal(18,4)),
            CAST(0 AS decimal(18,4)),
            CAST(1.50 AS decimal(10,2)),
            130,
            CONVERT(nvarchar(4000), 'Non-union hourly weekly overtime generated after daily overtime and double-time hours are excluded from the weekly straight-time pool.')
        FROM #RowPreview rp
        WHERE rp.WeeklyOT_FromThisRow > 0

        UNION ALL

        SELECT
            rp.*,
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_DAILY_DT'),
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT'),
            CONVERT(varchar(160), 'Non-Union CA Nonexempt Daily Double Time'),
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_DAILY_DT'),
            CONVERT(varchar(160), 'California daily double time over 12 hours'),
            CAST(CASE WHEN rp.IsSeventhConsecutiveDay = 0 THEN rp.RowDT ELSE 0 END AS decimal(18,4)),
            CAST(0 AS decimal(18,4)),
            CAST(0 AS decimal(18,4)),
            CAST(CASE WHEN rp.IsSeventhConsecutiveDay = 0 THEN rp.RowDT ELSE 0 END AS decimal(18,4)),
            CAST(2.00 AS decimal(10,2)),
            140,
            CONVERT(nvarchar(4000), 'Non-union hourly daily double time generated by California daily double-time rules; excludes seventh-day double time.')
        FROM #RowPreview rp
        WHERE rp.IsSeventhConsecutiveDay = 0
          AND rp.RowDT > 0

        UNION ALL

        SELECT
            rp.*,
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_7TH_DAY_OT'),
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT'),
            CONVERT(varchar(160), 'Non-Union CA Nonexempt Seventh-Day Overtime'),
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_7TH_DAY_OT'),
            CONVERT(varchar(160), 'California seventh consecutive day overtime first 8 hours'),
            CAST(CASE WHEN rp.IsSeventhConsecutiveDay = 1 THEN rp.RowOT_BeforeWeekly ELSE 0 END AS decimal(18,4)),
            CAST(0 AS decimal(18,4)),
            CAST(CASE WHEN rp.IsSeventhConsecutiveDay = 1 THEN rp.RowOT_BeforeWeekly ELSE 0 END AS decimal(18,4)),
            CAST(0 AS decimal(18,4)),
            CAST(1.50 AS decimal(10,2)),
            150,
            CONVERT(nvarchar(4000), 'Non-union hourly seventh consecutive workday overtime for the first 8 hours on the seventh day of the Saturday-Friday workweek.')
        FROM #RowPreview rp
        WHERE rp.IsSeventhConsecutiveDay = 1
          AND rp.RowOT_BeforeWeekly > 0

        UNION ALL

        SELECT
            rp.*,
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_7TH_DAY_DT'),
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT'),
            CONVERT(varchar(160), 'Non-Union CA Nonexempt Seventh-Day Double Time'),
            CONVERT(varchar(60), 'NONUNION_CA_NONEXEMPT_7TH_DAY_DT'),
            CONVERT(varchar(160), 'California seventh consecutive day double time over 8 hours'),
            CAST(CASE WHEN rp.IsSeventhConsecutiveDay = 1 THEN rp.RowDT ELSE 0 END AS decimal(18,4)),
            CAST(0 AS decimal(18,4)),
            CAST(0 AS decimal(18,4)),
            CAST(CASE WHEN rp.IsSeventhConsecutiveDay = 1 THEN rp.RowDT ELSE 0 END AS decimal(18,4)),
            CAST(2.00 AS decimal(10,2)),
            160,
            CONVERT(nvarchar(4000), 'Non-union hourly seventh consecutive workday double time after 8 hours on the seventh day of the Saturday-Friday workweek.')
        FROM #RowPreview rp
        WHERE rp.IsSeventhConsecutiveDay = 1
          AND rp.RowDT > 0
    )
    SELECT
        C.*,
        ComponentAmountRounded = CAST(ROUND(C.ComponentHours * C.RegularRate * C.MultiplierUsed, 2) AS decimal(19,4))
    INTO #ComponentInitial
    FROM C
    WHERE C.ComponentHours > 0;

    ;WITH WithTrueUp AS
    (
        SELECT
            ci.*,
            RowRoundedComponentAmount = SUM(ci.ComponentAmountRounded) OVER (PARTITION BY ci.LaborPayrollID),
            TrueUpComponentRN = ROW_NUMBER() OVER (PARTITION BY ci.LaborPayrollID ORDER BY ci.DisplaySort DESC, ci.ComponentCode DESC)
        FROM #ComponentInitial ci
    )
    SELECT
        RunId = @RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        JobTicketID,
        JobCode,
        EmpID,
        Employee_Name,
        ComponentCode,
        ComponentGroup,
        ComponentLabel,
        SourceSchema = CONVERT(varchar(50), 'app'),
        SourceTable = CONVERT(varchar(100), 'usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt'),
        SourceID = CAST(CalcID AS bigint),
        SourceRuleCode,
        SourceRuleName,
        ComponentHours = CAST(ComponentHours AS decimal(10,2)),
        Hrs_ST = CAST(ComponentHrs_ST AS decimal(10,2)),
        Hrs_OT = CAST(ComponentHrs_OT AS decimal(10,2)),
        Hrs_DT = CAST(ComponentHrs_DT AS decimal(10,2)),
        RateBaseUsed = CAST(RegularRate AS decimal(12,4)),
        RateShiftUsed = CAST(0 AS decimal(12,4)),
        RateBoomUsed = CAST(0 AS decimal(12,4)),
        MultiplierUsed = CAST(MultiplierUsed AS decimal(10,2)),
        ComponentAmount = CAST(ComponentAmountRounded + CASE WHEN TrueUpComponentRN = 1 THEN CurrentPayActualGross - RowRoundedComponentAmount ELSE 0 END AS decimal(19,4)),
        IncludedInFinalGross = CONVERT(bit, 1),
        IncludedInPayableGross = CONVERT(bit, 1),
        DisplaySort,
        Explanation = CONCAT(
            Explanation,
            CASE WHEN TrueUpComponentRN = 1 AND CurrentPayActualGross - RowRoundedComponentAmount <> 0
                 THEN CONCAT(' Includes row-level rounding true-up of ', CONVERT(varchar(40), CAST(CurrentPayActualGross - RowRoundedComponentAmount AS decimal(19,4))), ' to reconcile to fms.Payroll_Calculated.Pay_Actual_Gross.')
                 ELSE '' END
        ),
        CalculatedAtUTC = SYSUTCDATETIME()
    INTO #ComponentFinal
    FROM WithTrueUp;

    CREATE INDEX IX_ComponentFinal_LPID ON #ComponentFinal(LaborPayrollID);

    SELECT pc.*
    INTO #ExistingLedgerRows
    FROM fms.Payroll_PayComponent pc
    JOIN #LaborBase lb
        ON lb.LaborPayrollID = pc.LaborPayrollID;

    SELECT
        rp.LaborPayrollID,
        rp.EmpID,
        rp.Employee_Name,
        rp.WorkDate,
        CurrentHrs_ST = MAX(rp.CurrentHrs_ST),
        LedgerHrs_ST = SUM(cf.Hrs_ST),
        CurrentHrs_OT = MAX(rp.CurrentHrs_OT),
        LedgerHrs_OT = SUM(cf.Hrs_OT),
        CurrentHrs_DT = MAX(rp.CurrentHrs_DT),
        LedgerHrs_DT = SUM(cf.Hrs_DT),
        CurrentPayActualGross = MAX(rp.CurrentPayActualGross),
        LedgerComponentAmount = SUM(cf.ComponentAmount),
        DeltaHrs_ST = MAX(rp.CurrentHrs_ST) - SUM(cf.Hrs_ST),
        DeltaHrs_OT = MAX(rp.CurrentHrs_OT) - SUM(cf.Hrs_OT),
        DeltaHrs_DT = MAX(rp.CurrentHrs_DT) - SUM(cf.Hrs_DT),
        DeltaPayActualGross = MAX(rp.CurrentPayActualGross) - SUM(cf.ComponentAmount)
    INTO #LedgerReconciliation
    FROM #RowPreview rp
    LEFT JOIN #ComponentFinal cf
        ON cf.LaborPayrollID = rp.LaborPayrollID
    GROUP BY rp.LaborPayrollID, rp.EmpID, rp.Employee_Name, rp.WorkDate;

    IF @PreviewOnly = 0
    BEGIN
        BEGIN TRAN;

        DELETE pc
        FROM fms.Payroll_PayComponent pc
        JOIN #LaborBase lb
            ON lb.LaborPayrollID = pc.LaborPayrollID;

        SET @RowsDeleted = @@ROWCOUNT;

        INSERT INTO fms.Payroll_PayComponent
        (
            RunId,
            CalcID,
            LaborPayrollID,
            WorkDate,
            JobTicketID,
            JobCode,
            EmpID,
            Employee_Name,
            ComponentCode,
            ComponentGroup,
            ComponentLabel,
            SourceSchema,
            SourceTable,
            SourceID,
            SourceRuleCode,
            SourceRuleName,
            ComponentHours,
            Hrs_ST,
            Hrs_OT,
            Hrs_DT,
            RateBaseUsed,
            RateShiftUsed,
            RateBoomUsed,
            MultiplierUsed,
            ComponentAmount,
            IncludedInFinalGross,
            IncludedInPayableGross,
            DisplaySort,
            Explanation,
            CalculatedAtUTC
        )
        SELECT
            RunId,
            CalcID,
            LaborPayrollID,
            WorkDate,
            JobTicketID,
            JobCode,
            EmpID,
            Employee_Name,
            ComponentCode,
            ComponentGroup,
            ComponentLabel,
            SourceSchema,
            SourceTable,
            SourceID,
            SourceRuleCode,
            SourceRuleName,
            ComponentHours,
            Hrs_ST,
            Hrs_OT,
            Hrs_DT,
            RateBaseUsed,
            RateShiftUsed,
            RateBoomUsed,
            MultiplierUsed,
            ComponentAmount,
            IncludedInFinalGross,
            IncludedInPayableGross,
            DisplaySort,
            Explanation,
            CalculatedAtUTC
        FROM #ComponentFinal;

        SET @RowsInserted = @@ROWCOUNT;

        COMMIT TRAN;
    END;

    IF @ReturnResults = 1
    BEGIN

    SELECT
        Mode = CASE WHEN @PreviewOnly = 1 THEN 'PREVIEW_ONLY' ELSE 'APPLIED' END,
        PreviewOnly = @PreviewOnly,
        WorkDateFrom = @WorkDateFrom,
        WorkDateTo = @WorkDateTo,
        RequestedBy = @RequestedBy,
        StartedAtUTC = @StartedAtUTC,
        CompletedAtUTC = SYSUTCDATETIME(),
        Employees = COUNT(DISTINCT lb.EmpID),
        LaborRows = COUNT(DISTINCT lb.LaborPayrollID),
        ExistingLedgerRowsToReplace = (SELECT COUNT(*) FROM #ExistingLedgerRows),
        NewComponentRows = (SELECT COUNT(*) FROM #ComponentFinal),
        RowsDeleted = @RowsDeleted,
        RowsInserted = @RowsInserted,
        CurrentPayActualGross = SUM(lb.CurrentPayActualGross),
        PreviewLedgerAmount = (SELECT SUM(ComponentAmount) FROM #ComponentFinal),
        DeltaPayActualGross = SUM(lb.CurrentPayActualGross) - (SELECT SUM(ComponentAmount) FROM #ComponentFinal)
    FROM #LaborBase lb;

    SELECT
        ComponentCode,
        ComponentGroup,
        ComponentLabel,
        Rows = COUNT(*),
        ComponentHours = SUM(ComponentHours),
        Hrs_ST = SUM(Hrs_ST),
        Hrs_OT = SUM(Hrs_OT),
        Hrs_DT = SUM(Hrs_DT),
        ComponentAmount = SUM(ComponentAmount),
        MinWorkDate = MIN(WorkDate),
        MaxWorkDate = MAX(WorkDate)
    FROM #ComponentFinal
    GROUP BY ComponentCode, ComponentGroup, ComponentLabel
    ORDER BY MIN(DisplaySort), ComponentCode;

    SELECT
        ComponentCode,
        ExistingRows = COUNT(*),
        ExistingComponentHours = SUM(ComponentHours),
        ExistingHrs_ST = SUM(Hrs_ST),
        ExistingHrs_OT = SUM(Hrs_OT),
        ExistingHrs_DT = SUM(Hrs_DT),
        ExistingComponentAmount = SUM(ComponentAmount)
    FROM #ExistingLedgerRows
    GROUP BY ComponentCode
    ORDER BY ComponentCode;

    SELECT TOP (200)
        *
    FROM #LedgerReconciliation
    WHERE ABS(ISNULL(DeltaHrs_ST, 0)) > 0.005
       OR ABS(ISNULL(DeltaHrs_OT, 0)) > 0.005
       OR ABS(ISNULL(DeltaHrs_DT, 0)) > 0.005
       OR ABS(ISNULL(DeltaPayActualGross, 0)) > 0.005
    ORDER BY WorkDate, EmpID, LaborPayrollID;

    SELECT TOP (200)
        LaborPayrollID,
        EmpID,
        Employee_Name,
        WorkDate,
        ComponentCode,
        ComponentLabel,
        ComponentHours,
        Hrs_ST,
        Hrs_OT,
        Hrs_DT,
        RateBaseUsed,
        MultiplierUsed,
        ComponentAmount,
        DisplaySort,
        Explanation
    FROM #ComponentFinal
    ORDER BY WorkDate, EmpID, LaborPayrollID, DisplaySort;
    END;
END;


