
CREATE   PROCEDURE [app].[usp_Preview_CA_NonUnionAdminHourly_OT_LaborRow]
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
    IF OBJECT_ID('tempdb..#DailyRule') IS NOT NULL DROP TABLE #DailyRule;
    IF OBJECT_ID('tempdb..#RowDailyAllocated') IS NOT NULL DROP TABLE #RowDailyAllocated;
    IF OBJECT_ID('tempdb..#RowPreview') IS NOT NULL DROP TABLE #RowPreview;
    IF OBJECT_ID('tempdb..#WeekPreview') IS NOT NULL DROP TABLE #WeekPreview;

    /*
        Key allocation-order change:
        - WorkDate is the trusted payroll day/week anchor.
        - TimeStart_Labor / TimeEnd_Labor contribute only the time-of-day portion.
        - If end time-of-day is earlier than start time-of-day, the anchored end is moved to WorkDate + 1 day.
        - Rows without TimeStart_Labor use LaborPayrollID fallback ordering and are flagged for review.
    */

    /* 1) Eligible labor rows */
    SELECT
        b.LaborPayrollID,
        b.EmpID,
        Employee_Name =
            COALESCE(NULLIF(LTRIM(RTRIM(pgr.Employee_Name)), ''), b.Employee_Name),
        WorkDate = td.WorkDateDate,
        b.TimeStart_Labor,
        b.TimeEnd_Labor,

        StartTimeOfDay = td.StartTOD,
        EndTimeOfDay = td.EndTOD,
        TimeStartDatePart = td.StartDatePart,
        TimeEndDatePart = td.EndDatePart,
        AnchoredStartDateTime = an.AnchoredStartDateTime,
        AnchoredEndDateTime = an.AnchoredEndDateTime,
        IsOvernightByTimeOfDay = CAST(ov.IsOvernightByTimeOfDay AS bit),
        TimeStartDateMismatch = CAST(CASE WHEN td.StartDatePart IS NOT NULL AND td.StartDatePart <> td.WorkDateDate THEN 1 ELSE 0 END AS bit),
        TimeEndDateMismatch = CAST(CASE WHEN td.EndDatePart IS NOT NULL AND td.EndDatePart <> td.WorkDateDate THEN 1 ELSE 0 END AS bit),
        AllocationSortMethod = ar.AllocationSortMethod,
        AllocationSortRank = ar.AllocationSortRank,
        AllocationOrderReviewFlag = ar.AllocationOrderReviewFlag,
        AllocationOrderReviewMessage = ar.AllocationOrderReviewMessage,

        PeriodStart =
            DATEADD(day, -((DATEDIFF(day, '19000106', td.WorkDateDate) % 7 + 7) % 7), td.WorkDateDate),
        PeriodEnd =
            DATEADD(day, 6 - ((DATEDIFF(day, '19000106', td.WorkDateDate) % 7 + 7) % 7), td.WorkDateDate),

        PayrollGroup = pgr.PayrollGroup,
        LaborCraftCode = b.CraftCode,
        EmployeeCraftCode = pgr.CraftCode,
        EmployeePayType = pgr.PayType,
        RegularRate = CAST(pgr.BaseHourlyRate AS decimal(19,4)),

        Act_Total_Hrs = CAST(ISNULL(pc.Act_Total_Hrs, 0) AS decimal(12,4)),

        CurrentST = CAST(ISNULL(pc.Hrs_ST, 0) AS decimal(12,4)),
        CurrentOT = CAST(ISNULL(pc.Hrs_OT, 0) AS decimal(12,4)),
        CurrentDT = CAST(ISNULL(pc.Hrs_DT, 0) AS decimal(12,4)),
        CurrentPayActualGross = CAST(ISNULL(pc.Pay_Actual_Gross, 0) AS decimal(19,4)),
        CurrentFinalGross = CAST(ISNULL(pc.Final_Gross_Pay, 0) AS decimal(19,4)),

        Source_Rate_Raw = b.Source_Rate_Raw,
        Source_Amount_Raw = b.Source_Amount_Raw,

        SortStart = COALESCE(an.AnchoredStartDateTime, CAST(td.WorkDateDate AS datetime2(0))),
        SortEnd = COALESCE(an.AnchoredEndDateTime, an.AnchoredStartDateTime, CAST(td.WorkDateDate AS datetime2(0)))
    INTO #LaborBase
    FROM app.v_Base_LaborPayroll b
    LEFT JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = b.LaborPayrollID
    LEFT JOIN api.v_UI_Employee_PayrollGroupRate pgr
        ON pgr.EmpID = b.EmpID
    CROSS APPLY
    (
        SELECT
            WorkDateDate = CAST(b.WorkDate AS date),
            StartTOD = CAST(b.TimeStart_Labor AS time(0)),
            EndTOD = CAST(b.TimeEnd_Labor AS time(0)),
            StartDatePart = CAST(b.TimeStart_Labor AS date),
            EndDatePart = CAST(b.TimeEnd_Labor AS date)
    ) td
    CROSS APPLY
    (
        SELECT
            StartSecondOfDay =
                CASE
                    WHEN td.StartTOD IS NULL THEN NULL
                    ELSE DATEDIFF(second, CAST('00:00:00' AS time(0)), td.StartTOD)
                END,
            EndSecondOfDay =
                CASE
                    WHEN td.EndTOD IS NULL THEN NULL
                    ELSE DATEDIFF(second, CAST('00:00:00' AS time(0)), td.EndTOD)
                END
    ) sec
    CROSS APPLY
    (
        SELECT
            IsOvernightByTimeOfDay =
                CASE
                    WHEN sec.StartSecondOfDay IS NOT NULL
                     AND sec.EndSecondOfDay IS NOT NULL
                     AND sec.EndSecondOfDay < sec.StartSecondOfDay
                    THEN 1 ELSE 0
                END
    ) ov
    CROSS APPLY
    (
        SELECT
            AnchoredStartDateTime =
                CASE
                    WHEN sec.StartSecondOfDay IS NULL THEN NULL
                    ELSE DATEADD(second, sec.StartSecondOfDay, CAST(td.WorkDateDate AS datetime2(0)))
                END,
            AnchoredEndDateTime =
                CASE
                    WHEN sec.EndSecondOfDay IS NULL THEN NULL
                    ELSE DATEADD(second, sec.EndSecondOfDay, CAST(DATEADD(day, ov.IsOvernightByTimeOfDay, td.WorkDateDate) AS datetime2(0)))
                END
    ) an
    CROSS APPLY
    (
        SELECT
            AllocationSortMethod =
                CASE
                    WHEN td.StartTOD IS NULL THEN 'LABORPAYROLLID_FALLBACK'
                    ELSE 'TIME_OF_DAY_ORDER'
                END,
            AllocationSortRank =
                CASE
                    WHEN td.StartTOD IS NULL THEN 1
                    ELSE 0
                END,
            AllocationOrderReviewFlag =
                CAST(
                    CASE
                        WHEN td.StartTOD IS NULL THEN 1
                        WHEN td.EndTOD IS NULL THEN 1
                        WHEN ov.IsOvernightByTimeOfDay = 1 THEN 1
                        WHEN td.StartDatePart IS NOT NULL AND td.StartDatePart <> td.WorkDateDate THEN 1
                        WHEN td.EndDatePart IS NOT NULL AND td.EndDatePart <> td.WorkDateDate THEN 1
                        ELSE 0
                    END
                AS bit),
            AllocationOrderReviewMessage =
                NULLIF(
                    CONCAT_WS('; ',
                        CASE WHEN td.StartTOD IS NULL
                            THEN 'Missing start time; ordered by LaborPayrollID fallback.' END,
                        CASE WHEN td.EndTOD IS NULL
                            THEN 'Missing end time.' END,
                        CASE WHEN ov.IsOvernightByTimeOfDay = 1
                            THEN 'End time-of-day is before start time-of-day; anchored as overnight ending on next day.' END,
                        CASE WHEN td.StartDatePart IS NOT NULL AND td.StartDatePart <> td.WorkDateDate
                            THEN 'TimeStart date portion does not match WorkDate; using time-of-day anchored to WorkDate.' END,
                        CASE WHEN td.EndDatePart IS NOT NULL AND td.EndDatePart <> td.WorkDateDate
                            THEN 'TimeEnd date portion does not match WorkDate; using time-of-day anchored to WorkDate or next day.' END
                    ),
                    ''
                )
    ) ar
    WHERE b.WorkDate >= @WorkDateFrom
      AND b.WorkDate <= @WorkDateTo
      AND ISNULL(pgr.IsVisibleInPayrollUI, 1) = 1
      AND pgr.PayrollGroup = 'Non-Union Admin Hourly';


    /* Result set 1: Review rows */
    SELECT
        ReviewType =
            CASE
                WHEN ISNULL(LaborCraftCode, '') NOT LIKE 'ADMIN%' THEN 'NONUNION_CA_NONEXEMPT_NON_ADMIN_LABOR_CRAFT'
                WHEN Act_Total_Hrs > 0 AND ISNULL(RegularRate, 0) <= 0 THEN 'NONUNION_CA_NONEXEMPT_MISSING_OR_ZERO_RATE'
                WHEN Act_Total_Hrs > 0 AND TimeStart_Labor IS NULL THEN 'NONUNION_CA_NONEXEMPT_MISSING_START_TIME'
                WHEN Act_Total_Hrs > 0 AND AllocationOrderReviewFlag = 1 THEN 'NONUNION_CA_NONEXEMPT_ALLOCATION_ORDER_REVIEW'
                ELSE 'NONUNION_CA_NONEXEMPT_REVIEW'
            END,
        EmpID,
        Employee_Name,
        WorkDate,
        PeriodStart,
        PeriodEnd,
        LaborPayrollID,
        LaborCraftCode,
        TimeStart_Labor,
        TimeEnd_Labor,
        StartTimeOfDay,
        EndTimeOfDay,
        AnchoredStartDateTime,
        AnchoredEndDateTime,
        AllocationSortMethod,
        AllocationOrderReviewFlag,
        AllocationOrderReviewMessage,
        Act_Total_Hrs,
        RegularRate
    FROM #LaborBase
    WHERE ISNULL(LaborCraftCode, '') NOT LIKE 'ADMIN%'
       OR (Act_Total_Hrs > 0 AND ISNULL(RegularRate, 0) <= 0)
       OR (Act_Total_Hrs > 0 AND TimeStart_Labor IS NULL)
       OR (Act_Total_Hrs > 0 AND AllocationOrderReviewFlag = 1)
    ORDER BY
        WorkDate,
        Employee_Name,
        AllocationSortRank,
        SortStart,
        SortEnd,
        LaborPayrollID;


    /* 2) Daily rule totals */
    WITH DailyRaw AS
    (
        SELECT
            EmpID,
            Employee_Name,
            WorkDate,
            PeriodStart,
            PeriodEnd,
            DayOffset = DATEDIFF(day, PeriodStart, WorkDate),
            DailyActualHours = SUM(Act_Total_Hrs),
            LaborRows = COUNT(*),
            RegularRate = MAX(RegularRate)
        FROM #LaborBase
        WHERE ISNULL(LaborCraftCode, '') LIKE 'ADMIN%'
          AND Act_Total_Hrs > 0
          AND ISNULL(RegularRate, 0) > 0
        GROUP BY
            EmpID,
            Employee_Name,
            WorkDate,
            PeriodStart,
            PeriodEnd
    ),
    DailyWithWorkedDays AS
    (
        SELECT
            d.*,
            WorkedDayCount =
                COUNT(*) OVER
                (
                    PARTITION BY EmpID, PeriodStart
                )
        FROM DailyRaw d
    )
    SELECT
        EmpID,
        Employee_Name,
        WorkDate,
        PeriodStart,
        PeriodEnd,
        DayOffset,
        WorkedDayCount,
        IsSeventhConsecutiveDay =
            CAST(CASE WHEN WorkedDayCount = 7 AND DayOffset = 6 THEN 1 ELSE 0 END AS bit),
        DailyActualHours,
        LaborRows,
        RegularRate,

        DailySTQuota =
            CAST(
                CASE
                    WHEN WorkedDayCount = 7 AND DayOffset = 6 THEN 0
                    WHEN DailyActualHours <= 8 THEN DailyActualHours
                    ELSE 8
                END
            AS decimal(12,4)),

        DailyOTQuota =
            CAST(
                CASE
                    WHEN WorkedDayCount = 7 AND DayOffset = 6
                        THEN CASE WHEN DailyActualHours <= 8 THEN DailyActualHours ELSE 8 END
                    WHEN DailyActualHours > 8
                        THEN CASE WHEN DailyActualHours <= 12 THEN DailyActualHours - 8 ELSE 4 END
                    ELSE 0
                END
            AS decimal(12,4)),

        DailyDTQuota =
            CAST(
                CASE
                    WHEN WorkedDayCount = 7 AND DayOffset = 6 AND DailyActualHours > 8
                        THEN DailyActualHours - 8
                    WHEN WorkedDayCount = 7 AND DayOffset = 6
                        THEN 0
                    WHEN DailyActualHours > 12
                        THEN DailyActualHours - 12
                    ELSE 0
                END
            AS decimal(12,4))
    INTO #DailyRule
    FROM DailyWithWorkedDays;


    /* 3) Allocate daily ST/OT/DT quotas to labor rows in anchored chronological order */
    WITH OrderedRows AS
    (
        SELECT
            lb.*,
            dr.WorkedDayCount,
            dr.IsSeventhConsecutiveDay,
            dr.DailyActualHours,
            dr.DailySTQuota,
            dr.DailyOTQuota,
            dr.DailyDTQuota,

            RowHoursBefore =
                CAST(
                    ISNULL(
                        SUM(lb.Act_Total_Hrs) OVER
                        (
                            PARTITION BY lb.EmpID, lb.WorkDate
                            ORDER BY lb.AllocationSortRank, lb.SortStart, lb.SortEnd, lb.LaborPayrollID
                            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                        ),
                        0
                    )
                AS decimal(12,4)),

            RowHoursThrough =
                CAST(
                    SUM(lb.Act_Total_Hrs) OVER
                    (
                        PARTITION BY lb.EmpID, lb.WorkDate
                        ORDER BY lb.AllocationSortRank, lb.SortStart, lb.SortEnd, lb.LaborPayrollID
                        ROWS UNBOUNDED PRECEDING
                    )
                AS decimal(12,4))
        FROM #LaborBase lb
        JOIN #DailyRule dr
            ON dr.EmpID = lb.EmpID
           AND dr.WorkDate = lb.WorkDate
        WHERE ISNULL(lb.LaborCraftCode, '') LIKE 'ADMIN%'
          AND lb.Act_Total_Hrs > 0
          AND ISNULL(lb.RegularRate, 0) > 0
    )
    SELECT
        *,
        RowST_DailyBase =
            CAST(
                CASE
                    WHEN RowHoursThrough <= 0 OR RowHoursBefore >= DailySTQuota THEN 0
                    WHEN RowHoursThrough <= DailySTQuota THEN RowHoursThrough - RowHoursBefore
                    ELSE DailySTQuota - RowHoursBefore
                END
            AS decimal(12,4)),

        RowOT_BeforeWeekly =
            CAST(
                CASE
                    WHEN RowHoursThrough <= DailySTQuota OR RowHoursBefore >= DailySTQuota + DailyOTQuota THEN 0
                    WHEN RowHoursThrough <= DailySTQuota + DailyOTQuota
                        THEN RowHoursThrough - CASE WHEN RowHoursBefore > DailySTQuota THEN RowHoursBefore ELSE DailySTQuota END
                    ELSE DailySTQuota + DailyOTQuota - CASE WHEN RowHoursBefore > DailySTQuota THEN RowHoursBefore ELSE DailySTQuota END
                END
            AS decimal(12,4)),

        RowDT =
            CAST(
                CASE
                    WHEN RowHoursThrough <= DailySTQuota + DailyOTQuota THEN 0
                    WHEN RowHoursBefore >= DailySTQuota + DailyOTQuota + DailyDTQuota THEN 0
                    WHEN RowHoursThrough <= DailySTQuota + DailyOTQuota + DailyDTQuota
                        THEN RowHoursThrough - CASE WHEN RowHoursBefore > DailySTQuota + DailyOTQuota THEN RowHoursBefore ELSE DailySTQuota + DailyOTQuota END
                    ELSE DailySTQuota + DailyOTQuota + DailyDTQuota - CASE WHEN RowHoursBefore > DailySTQuota + DailyOTQuota THEN RowHoursBefore ELSE DailySTQuota + DailyOTQuota END
                END
            AS decimal(12,4))
    INTO #RowDailyAllocated
    FROM OrderedRows;


    /* 4) Reclassify weekly OT from latest remaining ST hours after daily/7th-day rules */
    WITH WeekST AS
    (
        SELECT
            r.*,

            WeekSTBefore =
                CAST(
                    ISNULL(
                        SUM(r.RowST_DailyBase) OVER
                        (
                            PARTITION BY r.EmpID, r.PeriodStart
                            ORDER BY r.WorkDate, r.AllocationSortRank, r.SortStart, r.SortEnd, r.LaborPayrollID
                            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                        ),
                        0
                    )
                AS decimal(12,4)),

            WeekSTThrough =
                CAST(
                    SUM(r.RowST_DailyBase) OVER
                    (
                        PARTITION BY r.EmpID, r.PeriodStart
                        ORDER BY r.WorkDate, r.AllocationSortRank, r.SortStart, r.SortEnd, r.LaborPayrollID
                        ROWS UNBOUNDED PRECEDING
                    )
                AS decimal(12,4))
        FROM #RowDailyAllocated r
    )
    SELECT
        LaborPayrollID,
        EmpID,
        Employee_Name,
        WorkDate,
        TimeStart_Labor,
        TimeEnd_Labor,
        StartTimeOfDay,
        EndTimeOfDay,
        TimeStartDatePart,
        TimeEndDatePart,
        AnchoredStartDateTime,
        AnchoredEndDateTime,
        IsOvernightByTimeOfDay,
        TimeStartDateMismatch,
        TimeEndDateMismatch,
        AllocationSortMethod,
        AllocationSortRank,
        AllocationOrderReviewFlag,
        AllocationOrderReviewMessage,
        SortStart,
        SortEnd,
        PeriodStart,
        PeriodEnd,
        PayrollGroup,
        LaborCraftCode,
        RegularRate,
        Act_Total_Hrs,

        WorkedDayCount,
        IsSeventhConsecutiveDay,
        DailyActualHours,
        DailySTQuota,
        DailyOTQuota,
        DailyDTQuota,

        RowHoursBefore,
        RowHoursThrough,
        RowST_DailyBase,
        RowOT_BeforeWeekly,
        RowDT,

        WeekSTBefore,
        WeekSTThrough,

        WeeklyOT_FromThisRow =
            CAST(
                CASE
                    WHEN WeekSTThrough <= 40 THEN 0
                    WHEN WeekSTBefore >= 40 THEN RowST_DailyBase
                    ELSE WeekSTThrough - 40
                END
            AS decimal(12,4)),

        PreviewST =
            CAST(
                RowST_DailyBase -
                CASE
                    WHEN WeekSTThrough <= 40 THEN 0
                    WHEN WeekSTBefore >= 40 THEN RowST_DailyBase
                    ELSE WeekSTThrough - 40
                END
            AS decimal(12,4)),

        PreviewOT =
            CAST(
                RowOT_BeforeWeekly +
                CASE
                    WHEN WeekSTThrough <= 40 THEN 0
                    WHEN WeekSTBefore >= 40 THEN RowST_DailyBase
                    ELSE WeekSTThrough - 40
                END
            AS decimal(12,4)),

        PreviewDT = RowDT,

        CurrentST,
        CurrentOT,
        CurrentDT,
        CurrentPayActualGross,
        CurrentFinalGross,
        Source_Rate_Raw,
        Source_Amount_Raw,

        PreviewPayActualGross =
            CAST(
                RegularRate *
                (
                    RowST_DailyBase -
                    CASE
                        WHEN WeekSTThrough <= 40 THEN 0
                        WHEN WeekSTBefore >= 40 THEN RowST_DailyBase
                        ELSE WeekSTThrough - 40
                    END
                    + 1.5 *
                    (
                        RowOT_BeforeWeekly +
                        CASE
                            WHEN WeekSTThrough <= 40 THEN 0
                            WHEN WeekSTBefore >= 40 THEN RowST_DailyBase
                            ELSE WeekSTThrough - 40
                        END
                    )
                    + 2.0 * RowDT
                )
            AS decimal(19,4))
    INTO #RowPreview
    FROM WeekST;


    SELECT
        EmpID,
        Employee_Name,
        PeriodStart,
        PeriodEnd,
        LaborRows = COUNT(*),
        ActualHours = SUM(Act_Total_Hrs),
        RegularRate = MAX(RegularRate),

        PreviewST = SUM(PreviewST),
        PreviewOT = SUM(PreviewOT),
        PreviewDT = SUM(PreviewDT),
        PreviewWeightedHours =
            SUM(PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT)),
        PreviewGross = SUM(PreviewPayActualGross),

        CurrentST = SUM(CurrentST),
        CurrentOT = SUM(CurrentOT),
        CurrentDT = SUM(CurrentDT),
        CurrentWeightedHours =
            SUM(CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT)),

        DeltaWeightedHours =
            SUM(PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT))
            - SUM(CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT))
    INTO #WeekPreview
    FROM #RowPreview
    GROUP BY
        EmpID,
        Employee_Name,
        PeriodStart,
        PeriodEnd;


    /* Result set 2: High-level row allocation totals */
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

        DeltaWeightedHours = SUM(DeltaWeightedHours)
    FROM #WeekPreview;


    /* Result set 3: Week-level comparison */
    SELECT
        EmpID,
        Employee_Name,
        PeriodStart,
        PeriodEnd,
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
    ORDER BY
        ABS(DeltaWeightedHours) DESC,
        PeriodStart,
        Employee_Name;


    /* Result set 4: Labor row allocation detail */
    SELECT
        LaborPayrollID,
        EmpID,
        Employee_Name,
        WorkDate,
        TimeStart_Labor,
        TimeEnd_Labor,
        StartTimeOfDay,
        EndTimeOfDay,
        AnchoredStartDateTime,
        AnchoredEndDateTime,
        AllocationSortMethod,
        AllocationOrderReviewFlag,
        AllocationOrderReviewMessage,
        PeriodStart,
        PeriodEnd,
        RegularRate,
        Act_Total_Hrs,

        PreviewST,
        PreviewOT,
        PreviewDT,
        PreviewPayActualGross,

        RowST_DailyBase,
        RowOT_BeforeWeekly,
        WeeklyOT_FromThisRow,
        RowDT,

        CurrentST,
        CurrentOT,
        CurrentDT,
        CurrentPayActualGross,
        CurrentFinalGross,

        DeltaWeightedHours =
            CAST(
                (PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT))
                - (CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT))
            AS decimal(12,4))
    FROM #RowPreview
    WHERE PreviewOT > 0
       OR PreviewDT > 0
       OR CurrentOT > 0
       OR CurrentDT > 0
       OR ABS(
            (PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT))
            - (CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT))
          ) >= 0.0001
    ORDER BY
        EmpID,
        WorkDate,
        AllocationSortRank,
        SortStart,
        SortEnd,
        LaborPayrollID;


    /* Result set 5: Weekly OT row allocations */
    SELECT
        LaborPayrollID,
        EmpID,
        Employee_Name,
        WorkDate,
        TimeStart_Labor,
        TimeEnd_Labor,
        StartTimeOfDay,
        EndTimeOfDay,
        AnchoredStartDateTime,
        AnchoredEndDateTime,
        AllocationSortMethod,
        AllocationOrderReviewFlag,
        AllocationOrderReviewMessage,
        PeriodStart,
        PeriodEnd,
        Act_Total_Hrs,
        RowST_DailyBase,
        WeeklyOT_FromThisRow,
        PreviewST,
        PreviewOT,
        PreviewDT
    FROM #RowPreview
    WHERE WeeklyOT_FromThisRow > 0
    ORDER BY
        PeriodStart,
        Employee_Name,
        WorkDate,
        AllocationSortRank,
        SortStart,
        SortEnd,
        LaborPayrollID;


    /* Result set 6: Seventh-consecutive-day row allocations */
    SELECT
        LaborPayrollID,
        EmpID,
        Employee_Name,
        WorkDate,
        TimeStart_Labor,
        TimeEnd_Labor,
        StartTimeOfDay,
        EndTimeOfDay,
        AnchoredStartDateTime,
        AnchoredEndDateTime,
        AllocationSortMethod,
        AllocationOrderReviewFlag,
        AllocationOrderReviewMessage,
        PeriodStart,
        PeriodEnd,
        Act_Total_Hrs,
        PreviewST,
        PreviewOT,
        PreviewDT,
        RowOT_BeforeWeekly,
        RowDT
    FROM #RowPreview
    WHERE IsSeventhConsecutiveDay = 1
    ORDER BY
        PeriodStart,
        Employee_Name,
        WorkDate,
        AllocationSortRank,
        SortStart,
        SortEnd,
        LaborPayrollID;


    /* Result set 7: Allocation-order review summary */
    SELECT
        AllocationSortMethod,
        AllocationOrderReviewFlag,
        AllocationOrderReviewMessage,
        Rows = COUNT(*),
        Employees = COUNT(DISTINCT EmpID),
        ActualHours = SUM(Act_Total_Hrs),
        MinWorkDate = MIN(WorkDate),
        MaxWorkDate = MAX(WorkDate)
    FROM #LaborBase
    WHERE Act_Total_Hrs > 0
      AND ISNULL(LaborCraftCode, '') LIKE 'ADMIN%'
      AND ISNULL(RegularRate, 0) > 0
    GROUP BY
        AllocationSortMethod,
        AllocationOrderReviewFlag,
        AllocationOrderReviewMessage
    ORDER BY
        AllocationOrderReviewFlag DESC,
        AllocationSortMethod,
        AllocationOrderReviewMessage;
END;
