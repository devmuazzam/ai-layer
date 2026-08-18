
CREATE   PROCEDURE [app].[usp_Apply_CA_NonUnionAdminHourly_OT]
    @WorkDateFrom date,
    @WorkDateTo   date,
    @PreviewOnly  bit = 1,
    @RequestedBy  sysname = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @WorkDateFrom IS NULL OR @WorkDateTo IS NULL
    BEGIN
        THROW 51000, 'WorkDateFrom and WorkDateTo are required.', 1;
    END;

    IF @WorkDateTo < @WorkDateFrom
    BEGIN
        THROW 51001, 'WorkDateTo must be greater than or equal to WorkDateFrom.', 1;
    END;

    DECLARE
        @StartedAtUTC datetime2(3) = SYSUTCDATETIME(),
        @RowsUpdated int = 0,
        @Mode varchar(20) = CASE WHEN @PreviewOnly = 1 THEN 'PREVIEW_ONLY' ELSE 'APPLY_UPDATES' END;

    IF OBJECT_ID('tempdb..#LaborBase') IS NOT NULL DROP TABLE #LaborBase;
    IF OBJECT_ID('tempdb..#DailyRule') IS NOT NULL DROP TABLE #DailyRule;
    IF OBJECT_ID('tempdb..#RowDailyAllocated') IS NOT NULL DROP TABLE #RowDailyAllocated;
    IF OBJECT_ID('tempdb..#RowPreview') IS NOT NULL DROP TABLE #RowPreview;
    IF OBJECT_ID('tempdb..#WeekPreview') IS NOT NULL DROP TABLE #WeekPreview;

    /*
        Purpose
        -------
        Applies California nonexempt overtime preview/application logic for:
            PayrollGroup = 'Non-Union Admin Hourly'

        This procedure intentionally does not apply L12 union-only rules:
            - no L12 guarantee/minimum hours
            - no L12 outside-window overtime
            - no L12 holiday/special Saturday override
            - no boom/modifier premium
            - no WTL/meal-period token requirement
            - no rest-period premium
            - no subsistence
            - no ticket validation rule

        Ordering note
        -------------
        WorkDate is the payroll day/week anchor. TimeStart_Labor and TimeEnd_Labor
        supply time-of-day only; their date portions are not trusted for ordering.

        Gross validation note
        ---------------------
        PreviewGross is the cents-rounded row-level gross used for storage and
        validation. PreviewGross_Unrounded is retained as an audit/math reference.
    */

    /* 1) Eligible labor rows plus anchored allocation-order metadata */
    WITH BaseRaw AS
    (
        SELECT
            b.LaborPayrollID,
            b.EmpID,
            Employee_Name =
                COALESCE(NULLIF(LTRIM(RTRIM(pgr.Employee_Name)), ''), b.Employee_Name),
            WorkDate = CAST(b.WorkDate AS date),
            b.TimeStart_Labor,
            b.TimeEnd_Labor,
            PeriodStart =
                DATEADD(day, -((DATEDIFF(day, '19000106', CAST(b.WorkDate AS date)) % 7 + 7) % 7), CAST(b.WorkDate AS date)),
            PeriodEnd =
                DATEADD(day, 6 - ((DATEDIFF(day, '19000106', CAST(b.WorkDate AS date)) % 7 + 7) % 7), CAST(b.WorkDate AS date)),

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
            CurrentPayGapAdd = CAST(ISNULL(pc.Pay_Gap_Add, 0) AS decimal(19,4)),
            CurrentPayRestAdd = CAST(ISNULL(pc.Pay_Rest_Add, 0) AS decimal(19,4)),
            CurrentFinalGross = CAST(ISNULL(pc.Final_Gross_Pay, 0) AS decimal(19,4)),

            Source_Rate_Raw = b.Source_Rate_Raw,
            Source_Amount_Raw = b.Source_Amount_Raw,

            StartTimeOfDay = CAST(b.TimeStart_Labor AS time(0)),
            EndTimeOfDay = CAST(b.TimeEnd_Labor AS time(0))
        FROM app.v_Base_LaborPayroll b
        LEFT JOIN fms.Payroll_Calculated pc
            ON pc.LaborPayrollID = b.LaborPayrollID
        LEFT JOIN api.v_UI_Employee_PayrollGroupRate pgr
            ON pgr.EmpID = b.EmpID
        WHERE b.WorkDate >= @WorkDateFrom
          AND b.WorkDate <= @WorkDateTo
          AND ISNULL(pgr.IsVisibleInPayrollUI, 1) = 1
          AND pgr.PayrollGroup = 'Non-Union Admin Hourly'
    ),
    Anchored AS
    (
        SELECT
            br.*,
            StartSecondsOfDay =
                CASE
                    WHEN br.StartTimeOfDay IS NULL THEN NULL
                    ELSE DATEDIFF(second, CAST('00:00:00' AS time), br.StartTimeOfDay)
                END,
            EndSecondsOfDay =
                CASE
                    WHEN br.EndTimeOfDay IS NULL THEN NULL
                    ELSE DATEDIFF(second, CAST('00:00:00' AS time), br.EndTimeOfDay)
                END,
            IsOvernightByTimeOfDay =
                CAST(
                    CASE
                        WHEN br.StartTimeOfDay IS NOT NULL
                         AND br.EndTimeOfDay IS NOT NULL
                         AND br.EndTimeOfDay < br.StartTimeOfDay
                        THEN 1 ELSE 0
                    END
                AS bit),
            StartDatePartMismatch =
                CAST(
                    CASE
                        WHEN br.TimeStart_Labor IS NOT NULL
                         AND CAST(br.TimeStart_Labor AS date) <> br.WorkDate
                        THEN 1 ELSE 0
                    END
                AS bit),
            EndDatePartMismatch =
                CAST(
                    CASE
                        WHEN br.TimeEnd_Labor IS NOT NULL
                         AND CAST(br.TimeEnd_Labor AS date) <> br.WorkDate
                        THEN 1 ELSE 0
                    END
                AS bit)
        FROM BaseRaw br
    ),
    WithAnchoredDateTimes AS
    (
        SELECT
            a.*,
            AnchoredStartDateTime =
                CASE
                    WHEN a.StartSecondsOfDay IS NULL THEN NULL
                    ELSE DATEADD(second, a.StartSecondsOfDay, CAST(a.WorkDate AS datetime2(0)))
                END,
            AnchoredEndDateTime =
                CASE
                    WHEN a.EndSecondsOfDay IS NULL THEN NULL
                    ELSE DATEADD(
                            second,
                            a.EndSecondsOfDay +
                                CASE WHEN a.IsOvernightByTimeOfDay = 1 THEN 86400 ELSE 0 END,
                            CAST(a.WorkDate AS datetime2(0))
                         )
                END
        FROM Anchored a
    )
    SELECT
        wad.*,
        AllocationSortMethod =
            CASE
                WHEN wad.StartTimeOfDay IS NULL THEN 'LABORPAYROLLID_FALLBACK'
                ELSE 'TIME_OF_DAY_ORDER'
            END,
        AllocationSortRank =
            CASE
                WHEN wad.StartTimeOfDay IS NULL THEN 1
                ELSE 0
            END,
        SortStart =
            COALESCE(wad.AnchoredStartDateTime, CAST(wad.WorkDate AS datetime2(0))),
        SortEnd =
            COALESCE(wad.AnchoredEndDateTime, wad.AnchoredStartDateTime, CAST(wad.WorkDate AS datetime2(0))),
        AllocationOrderReviewFlag =
            CAST(
                CASE
                    WHEN wad.StartTimeOfDay IS NULL
                      OR wad.EndTimeOfDay IS NULL
                      OR wad.IsOvernightByTimeOfDay = 1
                      OR wad.StartDatePartMismatch = 1
                      OR wad.EndDatePartMismatch = 1
                    THEN 1 ELSE 0
                END
            AS bit),
        AllocationOrderReviewMessage =
            NULLIF(
                CONCAT(
                    CASE WHEN wad.StartTimeOfDay IS NULL
                        THEN 'Missing start time; ordered by LaborPayrollID fallback.; ' ELSE '' END,
                    CASE WHEN wad.EndTimeOfDay IS NULL
                        THEN 'Missing end time.; ' ELSE '' END,
                    CASE WHEN wad.IsOvernightByTimeOfDay = 1
                        THEN 'End time-of-day is before start time-of-day; anchored as overnight ending on next day.; ' ELSE '' END,
                    CASE WHEN wad.StartDatePartMismatch = 1
                        THEN 'TimeStart date portion does not match WorkDate; using time-of-day anchored to WorkDate.; ' ELSE '' END,
                    CASE WHEN wad.EndDatePartMismatch = 1
                        THEN 'TimeEnd date portion does not match WorkDate; using time-of-day anchored to WorkDate or next day.; ' ELSE '' END
                ),
                ''
            )
    INTO #LaborBase
    FROM WithAnchoredDateTimes wad;

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
        AnchoredStartDateTime,
        AnchoredEndDateTime,
        AllocationSortMethod,
        AllocationOrderReviewFlag,
        AllocationOrderReviewMessage,
        AllocationSortRank,
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
        CurrentPayGapAdd,
        CurrentPayRestAdd,
        CurrentFinalGross,
        Source_Rate_Raw,
        Source_Amount_Raw,

        PreviewPayActualGross_Unrounded =
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
            AS decimal(19,4)),

        /*
            Stored payroll gross is cents-based. The unrounded value is retained
            for math/audit visibility, but validation and updates compare to the
            row-level rounded amount that SQL Server stores in Payroll_Calculated.
        */
        PreviewPayActualGross =
            CAST(
                ROUND(
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
                    ),
                    2
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
        PreviewGross_Unrounded = SUM(PreviewPayActualGross_Unrounded),
        PreviewGross = SUM(PreviewPayActualGross),

        CurrentST = SUM(CurrentST),
        CurrentOT = SUM(CurrentOT),
        CurrentDT = SUM(CurrentDT),
        CurrentWeightedHours =
            SUM(CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT)),
        CurrentPayActualGross = SUM(CurrentPayActualGross),
        CurrentFinalGross = SUM(CurrentFinalGross),

        DeltaWeightedHours =
            SUM(PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT))
            - SUM(CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT)),
        DeltaPayActualGross =
            SUM(PreviewPayActualGross) - SUM(CurrentPayActualGross),
        DeltaFinalGross =
            SUM(PreviewPayActualGross) - SUM(CurrentFinalGross)
    INTO #WeekPreview
    FROM #RowPreview
    GROUP BY
        EmpID,
        Employee_Name,
        PeriodStart,
        PeriodEnd;

    /* 5) Apply update only when explicitly requested */
    IF @PreviewOnly = 0
    BEGIN
        BEGIN TRANSACTION;

        UPDATE pc
            SET
                pc.Hrs_ST = r.PreviewST,
                pc.Hrs_OT = r.PreviewOT,
                pc.Hrs_DT = r.PreviewDT,
                pc.Pay_Actual_Gross = r.PreviewPayActualGross,

                pc.Gap_Hrs_Total = 0,
                pc.Gap_Hrs_Boom = 0,
                pc.Pay_Total_Hrs = r.Act_Total_Hrs,
                pc.Pay_Gap_Add = 0,

                pc.Pay_Rest_Add = 0,
                pc.Final_Gross_Pay = r.PreviewPayActualGross,

                pc.Audit_Min_Rule = 0,
                pc.Audit_Gap_Mult = 0,

                pc.Rest_IsForced = 0,
                pc.Rest_ChainId = NULL,
                pc.Rest_Gap_Hrs_FromPrevChain = NULL,
                pc.Rest_IsOverlap = 0,
                pc.Rest_Premium_Hrs = 0,
                pc.Rest_Policy = NULL
        FROM fms.Payroll_Calculated pc
        JOIN #RowPreview r
            ON r.LaborPayrollID = pc.LaborPayrollID;

        SET @RowsUpdated = @@ROWCOUNT;

        COMMIT TRANSACTION;
    END;

    /* Result set 1: Apply/preview high-level totals */
    SELECT
        Mode = @Mode,
        PreviewOnly = @PreviewOnly,
        WorkDateFrom = @WorkDateFrom,
        WorkDateTo = @WorkDateTo,
        RequestedBy = COALESCE(@RequestedBy, SUSER_SNAME()),
        StartedAtUTC = @StartedAtUTC,
        CompletedAtUTC = SYSUTCDATETIME(),
        RowsUpdated = @RowsUpdated,

        Employees = COUNT(DISTINCT EmpID),
        Weeks = COUNT(*),
        ActualHours = SUM(ActualHours),

        PreviewST = SUM(PreviewST),
        PreviewOT = SUM(PreviewOT),
        PreviewDT = SUM(PreviewDT),
        PreviewWeightedHours = SUM(PreviewWeightedHours),
        PreviewGross_Unrounded = SUM(PreviewGross_Unrounded),
        PreviewGross = SUM(PreviewGross),

        CurrentST = SUM(CurrentST),
        CurrentOT = SUM(CurrentOT),
        CurrentDT = SUM(CurrentDT),
        CurrentWeightedHours = SUM(CurrentWeightedHours),
        CurrentPayActualGross = SUM(CurrentPayActualGross),
        CurrentFinalGross = SUM(CurrentFinalGross),

        DeltaWeightedHours = SUM(DeltaWeightedHours),
        DeltaPayActualGross = SUM(DeltaPayActualGross),
        DeltaFinalGross = SUM(DeltaFinalGross)
    FROM #WeekPreview;

    /* Result set 2: Review rows */
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
        PreviewGross_Unrounded,
        PreviewGross,

        CurrentST,
        CurrentOT,
        CurrentDT,
        CurrentWeightedHours,
        CurrentPayActualGross,
        CurrentFinalGross,

        DeltaWeightedHours,
        DeltaPayActualGross,
        DeltaFinalGross
    FROM #WeekPreview
    WHERE ABS(DeltaWeightedHours) >= 0.0001
       OR ABS(DeltaPayActualGross) >= 0.005
       OR ABS(DeltaFinalGross) >= 0.005
    ORDER BY
        ABS(DeltaWeightedHours) DESC,
        PeriodStart,
        Employee_Name;

    /* Result set 4: Labor row allocation/update detail */
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
        PreviewPayActualGross_Unrounded,
        PreviewPayActualGross,

        RowST_DailyBase,
        RowOT_BeforeWeekly,
        WeeklyOT_FromThisRow,
        RowDT,

        CurrentST,
        CurrentOT,
        CurrentDT,
        CurrentPayActualGross,
        CurrentPayGapAdd,
        CurrentPayRestAdd,
        CurrentFinalGross,

        DeltaWeightedHours =
            CAST(
                (PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT))
                - (CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT))
            AS decimal(12,4)),
        DeltaPayActualGross =
            CAST(PreviewPayActualGross - CurrentPayActualGross AS decimal(19,4)),
        DeltaFinalGross =
            CAST(PreviewPayActualGross - CurrentFinalGross AS decimal(19,4))
    FROM #RowPreview
    WHERE PreviewOT > 0
       OR PreviewDT > 0
       OR CurrentOT > 0
       OR CurrentDT > 0
       OR ABS(
            (PreviewST + (1.5 * PreviewOT) + (2.0 * PreviewDT))
            - (CurrentST + (1.5 * CurrentOT) + (2.0 * CurrentDT))
          ) >= 0.0001
       OR ABS(PreviewPayActualGross - CurrentPayActualGross) >= 0.005
       OR ABS(PreviewPayActualGross - CurrentFinalGross) >= 0.005
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
    WHERE ISNULL(LaborCraftCode, '') LIKE 'ADMIN%'
      AND Act_Total_Hrs > 0
      AND ISNULL(RegularRate, 0) > 0
    GROUP BY
        AllocationSortMethod,
        AllocationOrderReviewFlag,
        AllocationOrderReviewMessage
    ORDER BY
        AllocationSortMethod,
        AllocationOrderReviewFlag DESC,
        Rows DESC;
END;
