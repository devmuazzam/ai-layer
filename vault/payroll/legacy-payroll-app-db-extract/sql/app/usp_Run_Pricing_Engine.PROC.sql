









CREATE                     PROCEDURE [app].[usp_Run_Pricing_Engine]
      @WorkDateFrom date = NULL
    , @WorkDateTo   date = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    /* ------------------------------------------------------------
       Concurrency guard (prevents overlapping runs)
       ------------------------------------------------------------ */
    DECLARE @HasAppLock bit = 0;
    DECLARE @LockResult int;

    EXEC @LockResult = sp_getapplock
          @Resource    = N'app.usp_Run_Pricing_Engine'
        , @LockMode    = 'Exclusive'
        , @LockOwner   = 'Session'
        , @LockTimeout = 0;

    IF @LockResult < 0
        THROW 51000, 'Pricing Engine is already running (applock).', 1;

    SET @HasAppLock = 1;

    BEGIN TRY

        /* ------------------------------------------------------------
           Validate params
           ------------------------------------------------------------ */
        IF @WorkDateFrom IS NOT NULL AND @WorkDateTo IS NOT NULL AND @WorkDateFrom > @WorkDateTo
            THROW 51001, '@WorkDateFrom cannot be greater than @WorkDateTo.', 1;

        DECLARE @IsRange bit =
            CASE WHEN @WorkDateFrom IS NOT NULL OR @WorkDateTo IS NOT NULL THEN 1 ELSE 0 END;

        /* ------------------------------------------------------------
           Build sargable datetime2 bounds (avoid DATEADD overflow)
           ------------------------------------------------------------ */
        DECLARE @FromDT datetime2(0) =
            CONVERT(datetime2(0), COALESCE(@WorkDateFrom, CONVERT(date,'19000101')));

        DECLARE @ToExDT datetime2(0) =
            CASE
                WHEN @WorkDateTo IS NULL
                    THEN CONVERT(datetime2(0), '99991231')              -- effectively “no upper bound”
                ELSE
                    DATEADD(DAY, 1, CONVERT(datetime2(0), @WorkDateTo)) -- exclusive upper bound
            END;

        DECLARE @StartTime datetime2(3) = SYSDATETIME();

        /* ------------------------------------------------------------
          Run logging: create RunId if missing (manual SSMS runs)
          ------------------------------------------------------------ */
        DECLARE @CalcRunAt datetime2(0) = SYSDATETIME();

        DECLARE @RunId int = TRY_CONVERT(int, SESSION_CONTEXT(N'PayrollAPP_RunLogID'));
        DECLARE @OwnRunLog bit = 0;

        IF @RunId IS NULL
        BEGIN
            SET @OwnRunLog = 1;

            DECLARE @NewRun TABLE (RunId int);

            INSERT INTO etl.RunLog
            (
                RunType, StartedAtUTC, Status,
                HostName, AppName, LoginName,
                ErrorMessage
            )
            OUTPUT inserted.RunId INTO @NewRun(RunId)
            VALUES
            (
                N'PricingEngine',
                SYSUTCDATETIME(),
                N'Running',
                HOST_NAME(),
                APP_NAME(),
                ORIGINAL_LOGIN(),
                NULL
            );

            SELECT TOP (1) @RunId = RunId FROM @NewRun;

            EXEC sys.sp_set_session_context @key = N'PayrollAPP_RunLogID', @value = @RunId;
        END

        /* ============================================================
           STEP A: Build base set (#LP) with EARLY, SARGABLE filter
           ============================================================ */
        PRINT 'A) Building #LP (filtered LaborPayroll base set)...';

        IF OBJECT_ID('tempdb..#LP') IS NOT NULL DROP TABLE #LP;

        SELECT
            P.LaborPayrollID,
            P.JobTicketID,
            P.JobCode,
            P.EmpID,
            P.Employee_Name,
            P.UnionCode,
            P.WorkDate,
            WorkDateDate = CONVERT(date, P.WorkDate),

            P.TimeStart_Labor,
            P.TimeEnd_Labor,
            P.HoursWorked_Raw,

            -- PATCH: bring craft + source rate for policy + rate fallback
            P.CraftCode,
            P.CraftPayRate,
            P.Source_Rate_Raw,

            P.CraftModifierCode        AS CraftModifierCode_Raw,
            P.CraftModifierDescription AS CraftModifierDescription_Raw,

            Has_Boom_Modifier =
                CONVERT(bit,
                    CASE
                        WHEN NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), P.CraftModifierCode))), '') IS NOT NULL
                            THEN 1
                        ELSE 0
                    END
                ),

            P.Shift_Code_Raw,

            ShiftCode_ForPricing =
                CONVERT(int,
                    CASE
                        WHEN ISNULL(CT.Has_ConflictingShiftTokens, 0) = 1 THEN 1
                        ELSE ISNULL(CT.PayrollShiftCode_FromComments, 1)
                    END
                ),

            Has_SHIFT_2_FromComments =
                CONVERT(bit, ISNULL(CT.Has_SHIFT_2, 0)),

            Has_SHIFT_3_FromComments =
                CONVERT(bit, ISNULL(CT.Has_SHIFT_3, 0)),

            Has_ConflictingShiftTokens =
                CONVERT(bit, ISNULL(CT.Has_ConflictingShiftTokens, 0)),

            P.CraftModifierPayRateAdjustment

        INTO #LP
        FROM app.v_Base_LaborPayroll P
        LEFT JOIN app.v_LaborPayroll_CommentTokens CT
          ON CT.LaborPayrollID = P.LaborPayrollID
        WHERE P.WorkDate >= @FromDT
          AND P.WorkDate <  @ToExDT;

        CREATE UNIQUE CLUSTERED INDEX CX_LP ON #LP (LaborPayrollID);
        CREATE INDEX IX_LP_JobTicketID ON #LP (JobTicketID);

        /* ------------------------------------------------------------
           Drop clearly non-work placeholder rows (prevents Shift_End<=Shift_Start)
           ------------------------------------------------------------ */
        DECLARE @SkippedPlaceholders int = 0;

        DELETE lp
        FROM #LP lp
        JOIN app.v_Base_LaborPayroll b
            ON b.LaborPayrollID = lp.LaborPayrollID
        WHERE b.JobTicketID IS NULL
          AND b.JobCode     IS NULL
          AND ISNULL(b.HoursWorked_Raw, 0) = 0
          AND ISNULL(b.Source_Amount_Raw, 0) = 0
          AND (b.TimeStart_Labor IS NULL OR CONVERT(time(0), b.TimeStart_Labor) = '00:00:00')
          AND (b.TimeEnd_Labor   IS NULL OR CONVERT(time(0), b.TimeEnd_Labor)   = '00:00:00');

        SET @SkippedPlaceholders = @@ROWCOUNT;

        IF @SkippedPlaceholders > 0
            PRINT CONCAT('   Skipped placeholder zero-hour/no-time rows: ', @SkippedPlaceholders);

        /* ------------------------------------------------------------
           Drop additional placeholder rows:
           - HoursWorked_Raw = 0
           - no usable labor start/end times
           ------------------------------------------------------------ */
        DECLARE @SkippedZeroHourPlaceholders int = 0;

        DELETE lp
        FROM #LP lp
        JOIN app.v_Base_LaborPayroll b
          ON b.LaborPayrollID = lp.LaborPayrollID
        WHERE ISNULL(b.HoursWorked_Raw, 0) = 0
          AND ISNULL(b.Source_Amount_Raw, 0) = 0
          AND
          (
              (b.TimeStart_Labor IS NULL OR b.TimeEnd_Labor IS NULL)
              OR
              (
                  b.TimeStart_Labor IS NOT NULL
                  AND b.TimeEnd_Labor IS NOT NULL
                  AND TRY_CONVERT(datetime2(0), b.TimeStart_Labor) IS NOT NULL
                  AND TRY_CONVERT(datetime2(0), b.TimeEnd_Labor)   IS NOT NULL
                  AND TRY_CONVERT(datetime2(0), b.TimeEnd_Labor) = TRY_CONVERT(datetime2(0), b.TimeStart_Labor)
              )
              OR
              (
                  b.TimeStart_Labor IS NOT NULL AND CONVERT(time(0), b.TimeStart_Labor) = '00:00:00'
                  AND b.TimeEnd_Labor   IS NOT NULL AND CONVERT(time(0), b.TimeEnd_Labor)   = '00:00:00'
              )
          );

        SET @SkippedZeroHourPlaceholders = @@ROWCOUNT;

        IF @SkippedZeroHourPlaceholders > 0
            PRINT CONCAT('   Skipped zero-hour placeholder rows (no usable times): ', @SkippedZeroHourPlaceholders);

        PRINT '   #LP done in ' + CAST(DATEDIFF(SECOND, @StartTime, SYSDATETIME()) AS varchar(10)) + ' sec';
        SET @StartTime = SYSDATETIME();

        /* ============================================================
           PATCH: Minimum-pay eligibility table for this run
           ============================================================ */
        IF OBJECT_ID('tempdb..#MinPayPolicy') IS NOT NULL DROP TABLE #MinPayPolicy;

        SELECT
            lp.LaborPayrollID,
            lp.CraftCode,
            ApplyMinimumPay = ISNULL(pol.ApplyMinimumPay, 1)
        INTO #MinPayPolicy
        FROM #LP lp
        LEFT JOIN cfg.Craft_MinimumPayPolicy pol
          ON pol.CraftCode = lp.CraftCode;

        CREATE UNIQUE CLUSTERED INDEX CX_MinPayPolicy ON #MinPayPolicy (LaborPayrollID);

        /* ============================================================
           B0) Exception table housekeeping (do ONCE per run, before inserts)
           ============================================================ */
        IF @OwnRunLog = 1 AND @RunId IS NOT NULL
        BEGIN
            DELETE e
            FROM fms.Payroll_CalcException e
            WHERE e.RunId = @RunId;
        END
        ELSE IF @IsRange = 1
        BEGIN
            DELETE e
            FROM fms.Payroll_CalcException e
            WHERE e.WorkDate >= @FromDT
              AND e.WorkDate <  @ToExDT;
        END
        ELSE
        BEGIN
            DELETE e
            FROM fms.Payroll_CalcException e
            WHERE e.CalcRunAt < DATEADD(DAY, -30, SYSDATETIME());
        END

        /* ============================================================
        B0.5) WARNINGS — Duplicate exact window (same Emp + rounded Start/End)
        ------------------------------------------------------------
        This usually indicates FCC edits created duplicate LaborPayroll rows.
        We do NOT auto-fix; we flag for Payroll review.
        ============================================================ */

        ;WITH Dups AS
        (
            SELECT
                EmpID_Raw = t.EmpID,
                t.Pay_Start_Rounded,
                t.Pay_End_Rounded,
                DupCount = COUNT_BIG(*)
            FROM calc.v_Calc_Labor_Timeline t
            WHERE t.Pay_Start_Rounded >= @FromDT
            AND t.Pay_Start_Rounded <  @ToExDT
            GROUP BY
                t.EmpID,
                t.Pay_Start_Rounded,
                t.Pay_End_Rounded
            HAVING COUNT_BIG(*) > 1
        ),
        DupRows AS
        (
            SELECT
                t.EmpID,
                t.LaborPayrollID,
                WorkDateDT = CAST(t.Actual_WorkDate AS datetime2(0)),
                t.JobCode,
                Shift_Start = t.Pay_Start_Rounded,
                Shift_End   = t.Pay_End_Rounded,
                d.DupCount
            FROM calc.v_Calc_Labor_Timeline t
            JOIN Dups d
            ON d.EmpID_Raw = t.EmpID
            AND d.Pay_Start_Rounded = t.Pay_Start_Rounded
            AND d.Pay_End_Rounded   = t.Pay_End_Rounded
        )
        INSERT INTO fms.Payroll_CalcException
        (
            RunId, CalcRunAt, Reason,
            LaborPayrollID, WorkDate,
            EmpID, EmpID_Raw,
            Employee_Name, JobTicketID, JobCode,
            Shift_Start, Shift_End
        )
        SELECT
            @RunId,
            SYSUTCDATETIME(),
            CONCAT(
                'Warn_DuplicateWindow (Cnt=', CONVERT(varchar(20), dr.DupCount),
                '; Start=', CONVERT(varchar(16), dr.Shift_Start, 120),
                '; End=',   CONVERT(varchar(16), dr.Shift_End,   120),
                ')'
            ),
            dr.LaborPayrollID,
            dr.WorkDateDT,
            TRY_CONVERT(int, dr.EmpID),
            dr.EmpID,
            b.Employee_Name,
            b.JobTicketID,
            COALESCE(b.JobCode, dr.JobCode),
            dr.Shift_Start,
            dr.Shift_End
        FROM DupRows dr
        LEFT JOIN app.v_Base_LaborPayroll b
        ON b.LaborPayrollID = dr.LaborPayrollID
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM fms.Payroll_CalcException e
            WHERE e.RunId = @RunId
            AND e.LaborPayrollID = dr.LaborPayrollID
            AND e.Reason LIKE 'Warn_DuplicateWindow%'
        );

        /* ============================================================
        B0.6) WARNINGS — Overlap (Prev_End > Start)
        ------------------------------------------------------------
        Less definitive than DuplicateWindow, but still indicates bad/duplicated data.
        Excludes rows already flagged as Warn_DuplicateWindow.
        ============================================================ */

        ;WITH O AS
        (
            SELECT
                t.EmpID,
                t.LaborPayrollID,
                WorkDateDT = CAST(t.Actual_WorkDate AS datetime2(0)),
                t.JobCode,
                Shift_Start = t.Pay_Start_Rounded,
                Shift_End   = t.Pay_End_Rounded,
                t.Prev_End_Rounded,
                t.Prev_LaborPayrollID,
                t.Gap_Minutes_Raw
            FROM calc.v_Calc_Labor_Timeline t
            WHERE t.Pay_Start_Rounded >= @FromDT
            AND t.Pay_Start_Rounded <  @ToExDT
            AND t.Is_Overlap = 1
        )
        INSERT INTO fms.Payroll_CalcException
        (
            RunId, CalcRunAt, Reason,
            LaborPayrollID, WorkDate,
            EmpID, EmpID_Raw,
            Employee_Name, JobTicketID, JobCode,
            Shift_Start, Shift_End
        )
        SELECT
            @RunId,
            SYSUTCDATETIME(),
            CONCAT(
                'Warn_Overlap (PrevLPID=',
                COALESCE(CONVERT(varchar(20), o.Prev_LaborPayrollID), '?'),
                '; PrevEnd=', CONVERT(varchar(16), o.Prev_End_Rounded, 120),
                '; GapMinRaw=', CONVERT(varchar(20), o.Gap_Minutes_Raw),
                ')'
            ),
            o.LaborPayrollID,
            o.WorkDateDT,
            TRY_CONVERT(int, o.EmpID),
            o.EmpID,
            b.Employee_Name,
            b.JobTicketID,
            COALESCE(b.JobCode, o.JobCode),
            o.Shift_Start,
            o.Shift_End
        FROM O o
        LEFT JOIN app.v_Base_LaborPayroll b
        ON b.LaborPayrollID = o.LaborPayrollID
        WHERE NOT EXISTS
        (
            -- don't double-flag overlaps that are already in DuplicateWindow
            SELECT 1
            FROM fms.Payroll_CalcException e
            WHERE e.RunId = @RunId
            AND e.LaborPayrollID = o.LaborPayrollID
            AND (e.Reason LIKE 'Warn_DuplicateWindow%' OR e.Reason LIKE 'Warn_Overlap%')
        );

        /* ============================================================
           STEP B1: Collapse labor timeline to 1 row per LaborPayrollID
           ============================================================ */
        PRINT 'B1) Building #LaborAgg (1 row per LaborPayrollID)...';

        IF OBJECT_ID('tempdb..#LaborAgg') IS NOT NULL DROP TABLE #LaborAgg;

        ;WITH Agg AS
        (
            SELECT
                p.LaborPayrollID,
                p.WorkDateDate,
                p.UnionCode,
                p.TimeStart_Labor,
                p.TimeEnd_Labor,
                p.HoursWorked_Raw,
                Timeline_Start = MIN(l.Pay_Start_Rounded),
                Timeline_End   = MAX(l.Pay_End_Rounded)
            FROM #LP p
            LEFT JOIN calc.v_Calc_Labor_Timeline l
              ON l.LaborPayrollID = p.LaborPayrollID
            GROUP BY
                p.LaborPayrollID, p.WorkDateDate, p.UnionCode,
                p.TimeStart_Labor, p.TimeEnd_Labor, p.HoursWorked_Raw
        )
        SELECT
            a.LaborPayrollID,
            Shift_Start = COALESCE(a.Timeline_Start, lt.LaborStart_Rounded, fb.FallbackStart_Rounded),
            Shift_End   = COALESCE(a.Timeline_End,   lt.LaborEnd_Rounded,   fb.FallbackEnd_Rounded),

            Shift_Source_Start =
                CASE
                    WHEN a.Timeline_Start IS NOT NULL THEN 'Timeline'
                    WHEN lt.LaborStart_Rounded IS NOT NULL THEN 'LaborTimes'
                    WHEN fb.FallbackStart_Rounded IS NOT NULL THEN 'StdStart+Hours'
                    ELSE NULL
                END,
            Shift_Source_End =
                CASE
                    WHEN a.Timeline_End IS NOT NULL THEN 'Timeline'
                    WHEN lt.LaborEnd_Rounded IS NOT NULL THEN 'LaborTimes'
                    WHEN fb.FallbackEnd_Rounded IS NOT NULL THEN 'StdStart+Hours'
                    ELSE NULL
                END
        INTO #LaborAgg
        FROM Agg a
        LEFT JOIN cfg.Union_Master_Rules m
          ON m.UnionCode = a.UnionCode

        OUTER APPLY
        (
            SELECT
                LaborStart_Rounded =
                    CASE WHEN sdt IS NULL OR edt2 IS NULL OR edt2 <= sdt THEN NULL
                         ELSE DATEADD(MINUTE, (DATEDIFF(MINUTE, 0, sdt) / 30) * 30, 0)
                    END,
                LaborEnd_Rounded =
                    CASE WHEN sdt IS NULL OR edt2 IS NULL OR edt2 <= sdt THEN NULL
                         ELSE DATEADD(MINUTE, ((DATEDIFF(MINUTE, 0, edt2) + 29) / 30) * 30, 0)
                    END
            FROM
            (
                SELECT
                    sdt =
                        CASE
                            WHEN a.TimeStart_Labor IS NULL THEN NULL
                            WHEN TRY_CONVERT(datetime2(0), a.TimeStart_Labor) < '19500101'
                                THEN DATEADD(MINUTE,
                                             DATEDIFF(MINUTE, 0, CAST(a.TimeStart_Labor AS datetime2(0))),
                                             CAST(a.WorkDateDate AS datetime2(0)))
                            ELSE CAST(a.TimeStart_Labor AS datetime2(0))
                        END,
                    edt =
                        CASE
                            WHEN a.TimeEnd_Labor IS NULL THEN NULL
                            WHEN TRY_CONVERT(datetime2(0), a.TimeEnd_Labor) < '19500101'
                                THEN DATEADD(MINUTE,
                                             DATEDIFF(MINUTE, 0, CAST(a.TimeEnd_Labor AS datetime2(0))),
                                             CAST(a.WorkDateDate AS datetime2(0)))
                            ELSE CAST(a.TimeEnd_Labor AS datetime2(0))
                        END
            ) x
            CROSS APPLY
            (
                SELECT edt2 = CASE WHEN x.edt IS NOT NULL AND x.sdt IS NOT NULL AND x.edt < x.sdt
                                   THEN DATEADD(DAY, 1, x.edt)
                                   ELSE x.edt
                              END
            ) y
        ) lt

        OUTER APPLY
        (
            SELECT
                FallbackStart_Rounded =
                    CASE WHEN a.HoursWorked_Raw IS NULL OR a.HoursWorked_Raw <= 0 THEN NULL
                         ELSE DATEADD(MINUTE, (DATEDIFF(MINUTE, 0, BaseStart) / 30) * 30, 0)
                    END,
                FallbackEnd_Rounded =
                    CASE WHEN a.HoursWorked_Raw IS NULL OR a.HoursWorked_Raw <= 0 THEN NULL
                         ELSE DATEADD(MINUTE,
                                      CAST(CEILING(CONVERT(float, a.HoursWorked_Raw) * 2.0) * 30 AS int),
                                      DATEADD(MINUTE, (DATEDIFF(MINUTE, 0, BaseStart) / 30) * 30, 0))
                    END
            FROM
            (
                SELECT BaseStart =
                    DATEADD(
                        MINUTE,
                        DATEDIFF(MINUTE, 0,
                            CAST(COALESCE(TRY_CONVERT(time(0), m.Standard_Start_Time), CONVERT(time(0), '06:00:00')) AS datetime2(0))
                        ),
                        CAST(a.WorkDateDate AS datetime2(0))
                    )
            ) b
        ) fb
        OPTION (RECOMPILE);

        CREATE UNIQUE CLUSTERED INDEX CX_LaborAgg ON #LaborAgg (LaborPayrollID);

        PRINT '   #LaborAgg done in ' + CAST(DATEDIFF(SECOND, @StartTime, SYSDATETIME()) AS varchar(10)) + ' sec';
        SET @StartTime = SYSDATETIME();

        /* ============================================================
           B1.6) Warning: Shift window was assumed (CONSOLIDATED)
           ============================================================ */
        DECLARE @WarnReason_Std varchar(100)  = 'Shift_Assumed (StdStart+HoursWorked)';
        DECLARE @WarnReason_Bad varchar(120)  = 'Shift_Assumed (LaborTimesInvalid End<=Start)';

        IF OBJECT_ID('tempdb..#AssumedWarn') IS NOT NULL DROP TABLE #AssumedWarn;

        SELECT
            Reason =
                CASE
                    WHEN x.sdt IS NOT NULL AND y.edt2 IS NOT NULL AND y.edt2 <= x.sdt
                        THEN @WarnReason_Bad
                    ELSE @WarnReason_Std
                END,
            p.LaborPayrollID,
            WorkDate   = CONVERT(datetime2(0), p.WorkDate),

            EmpID      = TRY_CONVERT(int, p.EmpID),
            EmpID_Raw  = NULLIF(LEFT(LTRIM(RTRIM(CONVERT(varchar(50), p.EmpID))), 15), ''),
            p.Employee_Name,

            JobTicketID = TRY_CONVERT(int, p.JobTicketID),
            p.JobCode,

            la.Shift_Start,
            la.Shift_End
        INTO #AssumedWarn
        FROM #LP p
        JOIN #LaborAgg la
          ON la.LaborPayrollID = p.LaborPayrollID

        CROSS APPLY
        (
            SELECT
                sdt =
                    CASE
                        WHEN p.TimeStart_Labor IS NULL THEN NULL
                        WHEN TRY_CONVERT(datetime2(0), p.TimeStart_Labor) < '19500101'
                            THEN DATEADD(MINUTE,
                                         DATEDIFF(MINUTE, 0, CAST(p.TimeStart_Labor AS datetime2(0))),
                                         CAST(p.WorkDateDate AS datetime2(0)))
                        ELSE CAST(p.TimeStart_Labor AS datetime2(0))
                    END,
                edt =
                    CASE
                        WHEN p.TimeEnd_Labor IS NULL THEN NULL
                        WHEN TRY_CONVERT(datetime2(0), p.TimeEnd_Labor) < '19500101'
                            THEN DATEADD(MINUTE,
                                         DATEDIFF(MINUTE, 0, CAST(p.TimeEnd_Labor AS datetime2(0))),
                                         CAST(p.WorkDateDate AS datetime2(0)))
                        ELSE CAST(p.TimeEnd_Labor AS datetime2(0))
                    END
        ) x
        CROSS APPLY
        (
            SELECT edt2 =
                CASE
                    WHEN x.edt IS NOT NULL AND x.sdt IS NOT NULL AND x.edt < x.sdt
                        THEN DATEADD(DAY, 1, x.edt)
                    ELSE x.edt
                END
        ) y
        WHERE la.Shift_Source_Start = 'StdStart+Hours'
          AND la.Shift_Source_End   = 'StdStart+Hours'
          AND la.Shift_Start IS NOT NULL
          AND la.Shift_End   IS NOT NULL
          AND la.Shift_End > la.Shift_Start;

        INSERT INTO fms.Payroll_CalcException
        (
            RunId, CalcRunAt,
            Reason, LaborPayrollID, WorkDate,
            EmpID, EmpID_Raw, Employee_Name,
            JobTicketID, JobCode,
            Shift_Start, Shift_End
        )
        SELECT
            @RunId, @CalcRunAt,
            aw.Reason, aw.LaborPayrollID, aw.WorkDate,
            aw.EmpID, aw.EmpID_Raw, aw.Employee_Name,
            aw.JobTicketID, aw.JobCode,
            aw.Shift_Start, aw.Shift_End
        FROM #AssumedWarn aw
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM fms.Payroll_CalcException e
            WHERE e.CalcRunAt      = @CalcRunAt
              AND e.LaborPayrollID = aw.LaborPayrollID
        );

        PRINT CONCAT('   Warnings written (assumed shifts): ', @@ROWCOUNT);

        /* ============================================================
        B1.7) Rest-rule metadata (1 row per LaborPayrollID)
        - used only to decide whether the special pre-6 AM weekday
            ST-bank logic should apply
        ============================================================ */
        IF OBJECT_ID('tempdb..#RestMeta') IS NOT NULL DROP TABLE #RestMeta;

        SELECT
            p.LaborPayrollID,

            Prev_End_Rounded =
                MAX(t.Prev_End_Rounded),

            Gap_Minutes_Raw =
                MIN(CASE WHEN t.Gap_Minutes_Raw IS NOT NULL THEN t.Gap_Minutes_Raw END),

            AnyOverlap =
                MAX(CASE WHEN ISNULL(t.Is_Overlap, 0) = 1 THEN 1 ELSE 0 END),

            Is_RestRule_Active =
                CASE
                    WHEN MAX(CASE WHEN ISNULL(t.Is_Overlap, 0) = 1 THEN 1 ELSE 0 END) = 1 THEN 1
                    WHEN MIN(CASE WHEN t.Gap_Minutes_Raw IS NOT NULL THEN t.Gap_Minutes_Raw END) >= 0
                    AND MIN(CASE WHEN t.Gap_Minutes_Raw IS NOT NULL THEN t.Gap_Minutes_Raw END) < 480
                        THEN 1
                    ELSE 0
                END
                
        INTO #RestMeta
        FROM #LP p
        LEFT JOIN calc.v_Calc_Labor_Timeline t
        ON t.LaborPayrollID = p.LaborPayrollID
        GROUP BY
            p.LaborPayrollID;

        CREATE UNIQUE CLUSTERED INDEX CX_RestMeta ON #RestMeta (LaborPayrollID);

        /* ============================================================
           STEP B2: Ticket windows via TicketTimeline cache (TVP)
           ============================================================ */
        PRINT 'B2) Building #TicketAgg via calc.TicketTimeline (cache for this run, TVP)...';

        IF OBJECT_ID('tempdb..#JT') IS NOT NULL DROP TABLE #JT;

        SELECT DISTINCT JobTicketID
        INTO #JT
        FROM #LP
        WHERE JobTicketID IS NOT NULL;

        CREATE UNIQUE CLUSTERED INDEX CX_JT ON #JT (JobTicketID);

        DECLARE @IDs calc.JobTicketIDList;

        INSERT INTO @IDs (JobTicketID)
        SELECT JobTicketID
        FROM #JT;

        IF EXISTS (SELECT 1 FROM @IDs)
        BEGIN
            EXEC calc.usp_Upsert_TicketTimeline_ForTicketIDList @IDs;
            EXEC calc.usp_Apply_TicketWindows_FromJobTicketTimes @IDs;
        END

        IF OBJECT_ID('tempdb..#TicketAgg') IS NOT NULL DROP TABLE #TicketAgg;

        SELECT
            TT.JobTicketID,
            TicketDate  = TT.TicketDate,

            Shift_Start = CASE
                            WHEN TT.Shift_Window_Start IS NOT NULL
                             AND TT.Shift_Window_End   IS NOT NULL
                             AND TT.Shift_Window_End   > TT.Shift_Window_Start
                            THEN TT.Shift_Window_Start
                          END,
            Shift_End   = CASE
                            WHEN TT.Shift_Window_Start IS NOT NULL
                             AND TT.Shift_Window_End   IS NOT NULL
                             AND TT.Shift_Window_End   > TT.Shift_Window_Start
                            THEN TT.Shift_Window_End
                          END,

            Boom_Start  = CASE
                            WHEN TT.Boom_Window_Start IS NOT NULL
                             AND TT.Boom_Window_End   IS NOT NULL
                             AND TT.Boom_Window_End   > TT.Boom_Window_Start
                            THEN TT.Boom_Window_Start
                          END,
            Boom_End    = CASE
                            WHEN TT.Boom_Window_Start IS NOT NULL
                             AND TT.Boom_Window_End   IS NOT NULL
                             AND TT.Boom_Window_End   > TT.Boom_Window_Start
                            THEN TT.Boom_Window_End
                          END
        INTO #TicketAgg
        FROM calc.TicketTimeline TT
        JOIN #JT J
          ON J.JobTicketID = TT.JobTicketID
        WHERE
              (TT.Shift_Window_Start IS NOT NULL AND TT.Shift_Window_End IS NOT NULL AND TT.Shift_Window_End > TT.Shift_Window_Start)
           OR (TT.Boom_Window_Start  IS NOT NULL AND TT.Boom_Window_End  IS NOT NULL AND TT.Boom_Window_End  > TT.Boom_Window_Start);

        CREATE UNIQUE CLUSTERED INDEX CX_TicketAgg ON #TicketAgg (JobTicketID);

        PRINT '   #TicketAgg done in ' + CAST(DATEDIFF(SECOND, @StartTime, SYSDATETIME()) AS varchar(10)) + ' sec';
        SET @StartTime = SYSDATETIME();

        /* ============================================================
           STEP B2.5: Capturing invalid/zero-duration shifts (exceptions)
           ============================================================ */
        PRINT 'B2.5) Capturing invalid/zero-duration shifts (exceptions)...';

        IF OBJECT_ID('tempdb..#BadShift') IS NOT NULL DROP TABLE #BadShift;

        CREATE TABLE #BadShift
        (
              Reason         varchar(50)   NOT NULL
            , LaborPayrollID int           NOT NULL
            , WorkDate       datetime2(0)  NOT NULL
            , EmpID          int           NULL
            , EmpID_Raw      varchar(15)   NULL
            , Employee_Name  varchar(200)  NULL
            , JobTicketID    int           NULL
            , JobCode        varchar(15)   NULL
            , Shift_Start    datetime2(0)  NULL
            , Shift_End      datetime2(0)  NULL
        );

        INSERT INTO #BadShift
        (
            Reason, LaborPayrollID, WorkDate,
            EmpID, EmpID_Raw,
            Employee_Name, JobTicketID, JobCode,
            Shift_Start, Shift_End
        )
        SELECT
            Reason =
                CASE
                    WHEN fs.Shift_Start IS NULL THEN 'Shift_Start NULL'
                    WHEN fs.Shift_End   IS NULL THEN 'Shift_End NULL'
                    WHEN fs.Shift_End  <= fs.Shift_Start THEN 'Shift_End <= Shift_Start'
                    ELSE 'Unknown'
                END,
            la.LaborPayrollID,
            WorkDate      = CONVERT(datetime2(0), p.WorkDate),

            EmpID         = TRY_CONVERT(int, p.EmpID),
            EmpID_Raw     = NULLIF(LEFT(LTRIM(RTRIM(CONVERT(varchar(50), p.EmpID))), 15), ''),

            Employee_Name = p.Employee_Name,
            JobTicketID   = TRY_CONVERT(int, p.JobTicketID),
            JobCode       = p.JobCode,

            Shift_Start   = CONVERT(datetime2(0), fs.Shift_Start),
            Shift_End     = CONVERT(datetime2(0), fs.Shift_End)
        FROM #LP p
        JOIN #LaborAgg la
          ON la.LaborPayrollID = p.LaborPayrollID
        LEFT JOIN #TicketAgg ta
          ON ta.JobTicketID = p.JobTicketID
        CROSS APPLY
        (
            SELECT
                Shift_Start = la.Shift_Start,
                Shift_End   = la.Shift_End
        ) fs
        WHERE fs.Shift_Start IS NULL
           OR fs.Shift_End   IS NULL
           OR fs.Shift_End  <= fs.Shift_Start;

        DECLARE @BadCnt int = (SELECT COUNT(*) FROM #BadShift);

        IF @BadCnt > 0
        BEGIN
            INSERT INTO fms.Payroll_CalcException
            (
                RunId, CalcRunAt,
                Reason, LaborPayrollID, WorkDate,
                EmpID, EmpID_Raw, Employee_Name,
                JobTicketID, JobCode,
                Shift_Start, Shift_End
            )
            SELECT
                @RunId, @CalcRunAt,
                Reason, LaborPayrollID, WorkDate,
                EmpID, EmpID_Raw, Employee_Name,
                JobTicketID, JobCode,
                Shift_Start, Shift_End
            FROM #BadShift;

            PRINT CONCAT('   Exceptions written: ', @BadCnt);
        END
        ELSE
        BEGIN
            PRINT '   No exceptions.';
        END

        /* ============================================================
           STEP C: Build RawRange (#RawRange)
           - Payroll shift timing comes ONLY from LaborPayroll-derived LaborAgg
           - JobTicket shift timing is carried for audit/reference only
           - Boom timing is carried ONLY when labor row has Craft Code Modifier
           ============================================================ */
        PRINT 'C) Building #RawRange (base + collapsed timelines)...';

        IF OBJECT_ID('tempdb..#RawRange') IS NOT NULL DROP TABLE #RawRange;

        SELECT
            P.LaborPayrollID,
            P.JobTicketID,
            P.JobCode,
            P.EmpID,
            P.Employee_Name,
            P.CraftCode,
            P.CraftModifierCode_Raw,
            P.CraftModifierDescription_Raw,
            P.Has_Boom_Modifier,

            TicketDate = COALESCE(TA.TicketDate, CONVERT(datetime2(0), P.WorkDateDate)),
            P.WorkDate,

            /* Payroll pricing shift window: LaborPayroll only */
            Shift_Start = LA.Shift_Start,
            Shift_End   = LA.Shift_End,

            /* JobTicket windows: audit/reference only */
            JT_Shift_Start = TA.Shift_Start,
            JT_Shift_End   = TA.Shift_End,
            JT_Boom_Start  = TA.Boom_Start,
            JT_Boom_End    = TA.Boom_End,

            /* Boom pricing window: only if labor row has modifier */
            Boom_Eligible =
                CONVERT(bit,
                    CASE
                        WHEN ISNULL(P.Has_Boom_Modifier, 0) = 1 THEN 1
                        ELSE 0
                    END
                ),

            Boom_Start =
                CASE
                    WHEN ISNULL(P.Has_Boom_Modifier, 0) = 1 THEN TA.Boom_Start
                    ELSE NULL
                END,

            Boom_End =
                CASE
                    WHEN ISNULL(P.Has_Boom_Modifier, 0) = 1 THEN TA.Boom_End
                    ELSE NULL
                END,

            /* Rates
            L12 union labor:
            - Source_Rate_Raw may already include CraftPayRate + CraftModifierPayRateAdjustment.
            - Use the labor-entry CraftCode resolved craft rate as the base rate when available.
            - Keep Source_Rate_Raw as audit/reference only for L12 pricing.
            */
            Rate_Base =
                CONVERT(decimal(12,3),
                    CASE
                        WHEN P.CraftCode LIKE 'L12%'
                        AND P.CraftPayRate IS NOT NULL
                            THEN P.CraftPayRate

                        /*
                        Temporary fallback for unresolved L12 craft rates.
                        These should remain review items and should be cleaned up in FCC.
                        After source cleanup, we can make this stricter if desired.
                        */
                        ELSE COALESCE(
                                NULLIF(CONVERT(decimal(19,6), ISNULL(P.Source_Rate_Raw, 0.0)), 0.0),
                                0.0
                            )
                    END
                ),

            Rate_Shift = ISNULL(S.Premium_Hourly_Add, 0.00),

            Rate_Boom =
                CASE
                    WHEN P.CraftCode LIKE 'L12%'
                    AND ISNULL(P.Has_Boom_Modifier, 0) = 1
                        THEN ISNULL(P.CraftModifierPayRateAdjustment, 0.00)
                    ELSE 0.00
                END,

            /* Day-type / rule config */
            Holiday_Name = ISNULL(H.HolidayName, 'Standard'),
            Week_Day     = DATENAME(weekday, P.WorkDateDate),

            Cfg_Start_Time = COALESCE(TRY_CONVERT(time(0), M.Standard_Start_Time), CONVERT(time(0), '06:00:00')),
            Cfg_End_Time   = COALESCE(TRY_CONVERT(time(0), M.Standard_End_Time),   CONVERT(time(0), '17:00:00')),

            Mul_OT  = ISNULL(M.OT_Multiplier,       1.50),
            Mul_DT  = ISNULL(M.DT_Multiplier,       2.00),
            Mul_Sat = ISNULL(M.Saturday_Multiplier, 1.50),
            Mul_Sun = ISNULL(M.Sunday_Multiplier,   2.00),

            Mul_Hol = COALESCE(H.PayRateMultiplier, ISNULL(M.Holiday_Multiplier, 3.00), 3.00),

            Limit_Reg = ISNULL(M.Standard_Hours_Daily,       8.0),
            Limit_OT  = ISNULL(M.DoubleTime_Threshold_Daily, 12.0),

            Is_Special_Saturday =
                CASE
                    WHEN MONTH(P.WorkDateDate) IN (6, 12)
                     AND DATENAME(weekday, P.WorkDateDate) = 'Saturday'
                     AND DAY(P.WorkDateDate) <= 7
                    THEN 1 ELSE 0
                END,

            Is_RestRule_Active = ISNULL(RM.Is_RestRule_Active, 0),
            Rest_Gap_Minutes   = RM.Gap_Minutes_Raw

        INTO #RawRange
        FROM #LP P
        JOIN #LaborAgg LA
          ON LA.LaborPayrollID = P.LaborPayrollID
        LEFT JOIN #TicketAgg TA
          ON TA.JobTicketID = P.JobTicketID
        LEFT JOIN cfg.Union_Shift_Rules S
          ON S.UnionCode = 'L12'
         AND S.ShiftCode = ISNULL(P.ShiftCode_ForPricing, 1)
        LEFT JOIN cfg.Union_Master_Rules M
          ON M.UnionCode = 'L12'
        LEFT JOIN dim.LU12_Holiday H
          ON P.WorkDateDate = CONVERT(date, H.[Date])
        LEFT JOIN #RestMeta RM
          ON RM.LaborPayrollID = P.LaborPayrollID
        WHERE LA.Shift_Start IS NOT NULL
          AND LA.Shift_End   IS NOT NULL
          AND LA.Shift_End   > LA.Shift_Start;

        CREATE CLUSTERED INDEX CX_RawRange ON #RawRange (LaborPayrollID, Shift_Start);

        PRINT '   #RawRange done in ' + CAST(DATEDIFF(SECOND, @StartTime, SYSDATETIME()) AS varchar(10)) + ' sec';
        SET @StartTime = SYSDATETIME();

        /* ============================================================
           STEP D: Generate 30-min slices (bounded tally)
           ============================================================ */
        PRINT 'D) Generating 30-min slices...';

        IF OBJECT_ID('tempdb..#CalculatedSlices') IS NOT NULL DROP TABLE #CalculatedSlices;

        ;WITH
        E1(N) AS (SELECT 1 FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v(n)),
        E2(N) AS (SELECT 1 FROM E1 a CROSS JOIN E1 b),
        E3(N) AS (SELECT 1 FROM E2 a CROSS JOIN E1 b),
        Tally(N) AS (SELECT TOP (500) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 FROM E3),
        CalculatedSlices AS
        (
            SELECT
                R.LaborPayrollID,
                R.Boom_Eligible,

                DATEADD(minute, 30 * T.N,       R.Shift_Start) AS Slice_Start,
                DATEADD(minute, 30 * (T.N + 1), R.Shift_Start) AS Slice_End,

                CASE
                    WHEN ISNULL(R.Boom_Eligible, 0) = 1
                     AND R.Boom_Start IS NOT NULL
                     AND R.Boom_End   IS NOT NULL
                     AND DATEADD(minute, 30 * T.N,       R.Shift_Start) >= R.Boom_Start
                     AND DATEADD(minute, 30 * (T.N + 1), R.Shift_Start) <= R.Boom_End
                    THEN 1 ELSE 0
                END AS Is_Boom_Active,

                /* keep the raw clock-window test as-is */
                CASE
                    WHEN CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS time(0)) <  R.Cfg_Start_Time
                      OR CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS time(0)) >= R.Cfg_End_Time
                    THEN 1 ELSE 0
                END AS Is_Outside_Window,

                /* block ST re-entry on next calendar day for weekday slices */
                CASE
                    WHEN R.Is_Special_Saturday = 0
                     AND R.Holiday_Name = 'Standard'
                     AND R.Week_Day NOT IN ('Saturday', 'Sunday')
                     AND CAST(R.Shift_Start AS date) < CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS date)
                     AND CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS time(0)) >= R.Cfg_Start_Time
                     AND CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS time(0)) <  R.Cfg_End_Time
                    THEN 1 ELSE 0
                END AS Is_PrevDay_ST_Reentry_Block,

                /* ST anchor start for weekday single-shift logic
                   - normal pre-6 AM weekday rule delays ST bank to cfg start time
                   - BUT if rest rule is active, pre-6 AM start behaves like legacy logic:
                     use actual Shift_Start as the daily accumulation anchor
                */
                CASE
                    /* pre-6 AM + no rest rule -> ST bank begins at regular start */
                    WHEN R.Is_Special_Saturday = 0
                     AND R.Holiday_Name = 'Standard'
                     AND R.Week_Day NOT IN ('Saturday', 'Sunday')
                     AND CAST(R.Shift_Start AS date) = CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS date)
                     AND CAST(R.Shift_Start AS time(0)) < R.Cfg_Start_Time
                     AND ISNULL(R.Is_RestRule_Active, 0) = 0
                    THEN DATEADD(
                            SECOND,
                            DATEDIFF(SECOND, CAST('00:00:00' AS time), R.Cfg_Start_Time),
                            CAST(CAST(R.Shift_Start AS date) AS datetime2(0))
                         )

                    /* pre-6 AM + rest rule active -> use actual start (legacy behavior) */
                    WHEN R.Is_Special_Saturday = 0
                     AND R.Holiday_Name = 'Standard'
                     AND R.Week_Day NOT IN ('Saturday', 'Sunday')
                     AND CAST(R.Shift_Start AS date) = CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS date)
                     AND CAST(R.Shift_Start AS time(0)) < R.Cfg_Start_Time
                     AND ISNULL(R.Is_RestRule_Active, 0) = 1
                    THEN CAST(R.Shift_Start AS datetime2(0))

                    /* same-day start already inside regular window */
                    WHEN R.Is_Special_Saturday = 0
                     AND R.Holiday_Name = 'Standard'
                     AND R.Week_Day NOT IN ('Saturday', 'Sunday')
                     AND CAST(R.Shift_Start AS date) = CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS date)
                     AND CAST(R.Shift_Start AS time(0)) >= R.Cfg_Start_Time
                     AND CAST(R.Shift_Start AS time(0)) <  R.Cfg_End_Time
                    THEN CAST(R.Shift_Start AS datetime2(0))

                    ELSE NULL
                END AS ST_Anchor_Start,

                /* DT still based on total continuous hours from actual Shift_Start
                   - pre-6 AM weekday rule is bypassed when rest rule is active
                */
                CASE
                    WHEN ((T.N + 1) * 0.5) > R.Limit_OT
                        THEN 'DT_Daily'

                    WHEN
                        R.Is_Special_Saturday = 0
                        AND R.Holiday_Name = 'Standard'
                        AND R.Week_Day NOT IN ('Saturday', 'Sunday')
                        AND
                        (
                            /* pre-6 AM + no rest rule -> 8 ST hours begin at cfg start */
                            (
                                CAST(R.Shift_Start AS date) = CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS date)
                                AND CAST(R.Shift_Start AS time(0)) < R.Cfg_Start_Time
                                AND ISNULL(R.Is_RestRule_Active, 0) = 0
                                AND DATEADD(minute, 30 * (T.N + 1), R.Shift_Start) >
                                    DATEADD(
                                        SECOND,
                                        DATEDIFF(SECOND, CAST('00:00:00' AS time), R.Cfg_Start_Time),
                                        CAST(CAST(R.Shift_Start AS date) AS datetime2(0))
                                    )
                                AND
                                (
                                    DATEDIFF(
                                        MINUTE,
                                        DATEADD(
                                            SECOND,
                                            DATEDIFF(SECOND, CAST('00:00:00' AS time), R.Cfg_Start_Time),
                                            CAST(CAST(R.Shift_Start AS date) AS datetime2(0))
                                        ),
                                        DATEADD(minute, 30 * (T.N + 1), R.Shift_Start)
                                    ) / 60.0
                                ) > R.Limit_Reg
                            )

                            OR

                            /* pre-6 AM + rest rule active -> legacy 8-hour bank from actual start */
                            (
                                CAST(R.Shift_Start AS date) = CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS date)
                                AND CAST(R.Shift_Start AS time(0)) < R.Cfg_Start_Time
                                AND ISNULL(R.Is_RestRule_Active, 0) = 1
                                AND ((T.N + 1) * 0.5) > R.Limit_Reg
                            )

                            OR

                            /* same-day start already inside regular window */
                            (
                                CAST(R.Shift_Start AS date) = CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS date)
                                AND CAST(R.Shift_Start AS time(0)) >= R.Cfg_Start_Time
                                AND CAST(R.Shift_Start AS time(0)) <  R.Cfg_End_Time
                                AND ((T.N + 1) * 0.5) > R.Limit_Reg
                            )
                        )
                        THEN 'OT_Daily'

                    ELSE 'Reg_Daily'
                END AS Accumulation_Status,

                CASE
                    WHEN R.Is_Special_Saturday = 1 THEN 'SPECIAL_SAT'
                    WHEN R.Holiday_Name <> 'Standard' THEN 'HOLIDAY'
                    WHEN R.Week_Day = 'Sunday'        THEN 'SUNDAY'
                    WHEN R.Week_Day = 'Saturday'      THEN 'SATURDAY'
                    ELSE 'WEEKDAY'
                END AS Day_Type,

                R.Rate_Base,
                R.Rate_Shift,
                R.Rate_Boom,
                R.Mul_OT,
                R.Mul_DT,
                R.Mul_Sat,
                R.Mul_Sun,
                R.Mul_Hol
            FROM #RawRange R
            JOIN Tally T
              ON DATEADD(minute, 30 * T.N, R.Shift_Start) < R.Shift_End
        )
        SELECT *
        INTO #CalculatedSlices
        FROM CalculatedSlices;

        CREATE INDEX IX_CalcSlices_LPID ON #CalculatedSlices (LaborPayrollID);

        PRINT '   #CalculatedSlices done in ' + CAST(DATEDIFF(SECOND, @StartTime, SYSDATETIME()) AS varchar(10)) + ' sec';
        SET @StartTime = SYSDATETIME();

        /* ============================================================
           STEP E: Build final rows into #FinalInsert (NO TARGET TOUCH YET)
           ============================================================ */
        PRINT 'E) Building final result set (#FinalInsert)...';

        IF OBJECT_ID('tempdb..#FinalInsert') IS NOT NULL DROP TABLE #FinalInsert;

        ;WITH FinalRates AS
        (
            SELECT
                LaborPayrollID,
                Is_Boom_Active,
                CASE
                    WHEN Day_Type = 'HOLIDAY'      THEN Mul_Hol
                    WHEN Day_Type = 'SUNDAY'       THEN Mul_Sun
                    WHEN Day_Type = 'SPECIAL_SAT'  THEN Mul_DT
                    WHEN Accumulation_Status = 'DT_Daily' THEN Mul_DT
                    WHEN Is_Outside_Window = 1 AND Day_Type = 'WEEKDAY' THEN Mul_OT
                    WHEN Is_PrevDay_ST_Reentry_Block = 1 THEN Mul_OT
                    WHEN Accumulation_Status = 'OT_Daily' THEN Mul_OT
                    WHEN Day_Type = 'SATURDAY'     THEN Mul_Sat
                    ELSE 1.0
                END AS Final_Multiplier,
                (COALESCE(Rate_Base,0.00) + COALESCE(Rate_Shift,0.00)
                    + CASE WHEN Is_Boom_Active = 1 THEN COALESCE(Rate_Boom,0.00) ELSE 0.00 END
                ) AS Hourly_Rate_Raw,
                Mul_OT,
                Mul_DT
            FROM #CalculatedSlices
        ),
        Pricing AS
        (
            SELECT
                R.LaborPayrollID, R.JobTicketID, R.JobCode, R.EmpID, R.Employee_Name, R.TicketDate, R.WorkDate,
                SUM(0.5) AS Act_Total_Hrs,
                SUM(CASE WHEN F.Is_Boom_Active = 1 THEN 0.5 ELSE 0.0 END) AS Act_Boom_Hrs,
                CAST(SUM(COALESCE(0.5 * F.Hourly_Rate_Raw * F.Final_Multiplier, 0.0)) AS decimal(12,2)) AS Pay_Actual_Gross,
                SUM(CASE WHEN F.Final_Multiplier = 1.0 THEN 0.5 ELSE 0 END) AS Hrs_ST,
                SUM(CASE WHEN F.Final_Multiplier = F.Mul_OT THEN 0.5 ELSE 0 END) AS Hrs_OT,
                SUM(CASE WHEN F.Final_Multiplier >= F.Mul_DT THEN 0.5 ELSE 0 END) AS Hrs_DT,
                MAX(R.Holiday_Name) AS Holiday_Name,
                MAX(R.Week_Day) AS Week_Day,
                MAX(R.Rate_Base) AS Rate_Base,
                MAX(R.Rate_Shift) AS Rate_Shift,
                MAX(R.Rate_Boom) AS Rate_Boom,
                MAX(R.Is_Special_Saturday) AS Is_Special_Saturday,
                -- FIX: bit is not a valid type for MAX(); cast through tinyint
                CONVERT(bit, MAX(CONVERT(tinyint, R.Boom_Eligible))) AS Boom_Eligible
            FROM FinalRates F
            JOIN #RawRange R
                ON F.LaborPayrollID = R.LaborPayrollID
            GROUP BY R.LaborPayrollID, R.JobTicketID, R.JobCode, R.EmpID, R.Employee_Name, R.TicketDate, R.WorkDate
        ),
        GapRules AS
        (
            SELECT
                p.LaborPayrollID, p.JobTicketID, p.JobCode, p.EmpID, p.Employee_Name, p.TicketDate, p.WorkDate,
                p.Act_Total_Hrs, p.Act_Boom_Hrs, p.Pay_Actual_Gross, p.Hrs_ST, p.Hrs_OT, p.Hrs_DT,
                p.Holiday_Name, p.Week_Day, p.Rate_Base, p.Rate_Shift, p.Rate_Boom, p.Boom_Eligible,

                -- PATCH: gate minimum hours by craft policy
                Rule_Min_Hours =
                    CASE
                        WHEN ISNULL(mp.ApplyMinimumPay, 1) = 0 THEN 0.0
                        ELSE
                            CASE
                                -- Special Saturday first (not treated as Holiday)
                                WHEN p.Is_Special_Saturday = 1 THEN 8.0

                                -- Holidays (incl observed) min-8
                                WHEN p.Holiday_Name <> 'Standard' THEN 8.0

                                -- General minimums (legacy behavior)
                                WHEN p.Act_Total_Hrs > 0 THEN 4.0 ELSE 2.0
                            END
                    END,

                Gap_Multiplier =
                    CASE
                        -- Special Saturday is 2.0
                        WHEN p.Is_Special_Saturday = 1 THEN 2.0
                        -- Holiday multiplier (already encoded into actual slice pay; for gap we match day mult)
                        WHEN p.Holiday_Name <> 'Standard' THEN 3.0
                        WHEN p.Week_Day = 'Sunday' THEN 2.0
                        ELSE 1.0
                    END
            FROM Pricing p
            LEFT JOIN #MinPayPolicy mp
              ON mp.LaborPayrollID = p.LaborPayrollID
        )
        SELECT
            GR.LaborPayrollID, GR.JobTicketID, GR.JobCode, GR.EmpID, GR.Employee_Name,
            GR.TicketDate, GR.WorkDate,
            GR.Act_Total_Hrs, GR.Act_Boom_Hrs,

            /* Guaranteed-hours fields are now applied by app.usp_Apply_GuaranteedHours */
            Gap_Hrs_Total = CONVERT(decimal(10,2), 0.00),
            Gap_Hrs_Boom  = CONVERT(decimal(10,2), 0.00),

            Pay_Total_Hrs = GR.Act_Total_Hrs,

            GR.Hrs_ST, GR.Hrs_OT, GR.Hrs_DT,
            GR.Pay_Actual_Gross,

            Pay_Gap_Add = CONVERT(decimal(12,2), 0.00),

            Final_Gross_Pay = GR.Pay_Actual_Gross,

            Audit_Min_Rule = CONVERT(decimal(4,1), 0.0),
            Audit_Gap_Mult = CONVERT(decimal(4,2), 1.0),
            CalculatedAt   = SYSDATETIME()
        INTO #FinalInsert
        FROM GapRules GR
        CROSS APPLY
        (
            SELECT
                Boom_Guarantee =
                    CASE WHEN GR.Act_Total_Hrs < 4.0 THEN GR.Act_Total_Hrs ELSE 4.0 END,

                Gap_Total =
                    CASE WHEN GR.Rule_Min_Hours > GR.Act_Total_Hrs
                        THEN GR.Rule_Min_Hours - GR.Act_Total_Hrs
                        ELSE 0.0 END,

                Gap_Boom =
                    CASE
                        WHEN ISNULL(GR.Boom_Eligible, 0) = 1
                        AND GR.Act_Boom_Hrs > 0
                        AND GR.Act_Boom_Hrs < (CASE WHEN GR.Act_Total_Hrs < 4.0 THEN GR.Act_Total_Hrs ELSE 4.0 END)
                        THEN (CASE WHEN GR.Act_Total_Hrs < 4.0 THEN GR.Act_Total_Hrs ELSE 4.0 END) - GR.Act_Boom_Hrs
                        ELSE 0.0
                    END
        ) GA;

        PRINT '   #FinalInsert done in ' + CAST(DATEDIFF(SECOND, @StartTime, SYSDATETIME()) AS varchar(10)) + ' sec';
        SET @StartTime = SYSDATETIME();

        /* ============================================================
           STEP F: SHORT TRANSACTION load (atomic + minimal blocking)
           ============================================================ */
        PRINT 'F) Loading fms.Payroll_Calculated (short transaction)...';

        BEGIN TRY
            BEGIN TRAN;

            IF @IsRange = 0
            BEGIN
                TRUNCATE TABLE [fms].[Payroll_Calculated];
            END
            ELSE
            BEGIN
                DELETE f
                FROM [fms].[Payroll_Calculated] f
                WHERE f.WorkDate >= @FromDT
                  AND f.WorkDate <  @ToExDT;
            END

            INSERT INTO [fms].[Payroll_Calculated] WITH (TABLOCK)
            (
                LaborPayrollID, JobTicketID, JobCode, EmpID, Employee_Name,
                TicketDate, WorkDate,
                Act_Total_Hrs, Act_Boom_Hrs,
                Gap_Hrs_Total, Gap_Hrs_Boom, Pay_Total_Hrs,
                Hrs_ST, Hrs_OT, Hrs_DT,
                Pay_Actual_Gross, Pay_Gap_Add, Final_Gross_Pay,
                Audit_Min_Rule, Audit_Gap_Mult,
                CalculatedAt
            )
            SELECT
                LaborPayrollID, JobTicketID, JobCode, EmpID, Employee_Name,
                TicketDate, WorkDate,
                Act_Total_Hrs, Act_Boom_Hrs,
                Gap_Hrs_Total, Gap_Hrs_Boom, Pay_Total_Hrs,
                Hrs_ST, Hrs_OT, Hrs_DT,
                Pay_Actual_Gross, Pay_Gap_Add, Final_Gross_Pay,
                Audit_Min_Rule, Audit_Gap_Mult,
                CalculatedAt
            FROM #FinalInsert;

            DECLARE @RowsInserted int = @@ROWCOUNT;

            COMMIT TRAN;

            /* ============================================================
               STEP F.5: Reconstruction audit warnings
               - outside the load transaction
               - uses rpt.v_UI_Payroll_Reconstruction_Audit
               - because fms.Payroll_CalcException allows only ONE row per
                 CalcRunAt + LaborPayrollID, we:
                   1) UPDATE existing row to prepend warning text
                   2) INSERT only when no row exists yet
               ============================================================ */
            PRINT 'F.5) Writing reconstruction audit warnings...';

            IF OBJECT_ID('tempdb..#ReconAudit') IS NOT NULL
                DROP TABLE #ReconAudit;

            SELECT
                ra.LaborPayrollID,
                ra.JobTicketID,
                ra.JobCode,
                ra.EmpID,
                ra.Employee_Name,
                ra.WorkDate,
                ra.HoursWorked_Raw,
                ra.LA_Start,
                ra.LA_End,
                ra.LA_Total_Hrs,
                ra.TT_Shift_Hrs,
                ra.Act_Total_Hrs,
                ra.Flag_LA_TT_Shift_Mismatch,
                ra.Flag_Possible_24Plus_Reconstruction_Issue,
                Reason =
                    CASE
                        WHEN ra.Flag_LA_TT_Shift_Mismatch = 1
                         AND ra.Flag_Possible_24Plus_Reconstruction_Issue = 1
                        THEN 'Warn_Reconstruction_ShiftMismatch+Possible24Plus'
                        WHEN ra.Flag_Possible_24Plus_Reconstruction_Issue = 1
                        THEN 'Warn_Reconstruction_Possible24Plus'
                        WHEN ra.Flag_LA_TT_Shift_Mismatch = 1
                        THEN 'Warn_Reconstruction_ShiftMismatch'
                    END
            INTO #ReconAudit
            FROM rpt.v_UI_Payroll_Reconstruction_Audit ra
            WHERE ra.WorkDate >= @FromDT
              AND ra.WorkDate <  @ToExDT
              AND ra.Needs_Manager_Review = 1
              AND (
                    ra.Flag_LA_TT_Shift_Mismatch = 1
                    OR ra.Flag_Possible_24Plus_Reconstruction_Issue = 1
                  );

            /* 1) Prepend onto existing exception row for this run/LPID */
            UPDATE e
            SET e.Reason =
                LEFT(
                    CASE
                        WHEN e.Reason LIKE '%Warn_Reconstruction%'
                            THEN e.Reason
                        ELSE CONCAT(ra.Reason, ' | ', e.Reason)
                    END,
                    100
                )
            FROM fms.Payroll_CalcException e
            JOIN #ReconAudit ra
              ON ra.LaborPayrollID = e.LaborPayrollID
            WHERE e.CalcRunAt = @CalcRunAt;

            DECLARE @ReconUpdated int = @@ROWCOUNT;

            /* 2) Insert only for LPIDs that do not yet have any exception row for this run */
            INSERT INTO fms.Payroll_CalcException
            (
                RunId, CalcRunAt,
                Reason, LaborPayrollID, WorkDate,
                EmpID, EmpID_Raw, Employee_Name,
                JobTicketID, JobCode,
                Shift_Start, Shift_End
            )
            SELECT
                @RunId,
                @CalcRunAt,
                LEFT(ra.Reason, 100),
                ra.LaborPayrollID,
                CONVERT(datetime2(0), ra.WorkDate),
                TRY_CONVERT(int, ra.EmpID),
                NULLIF(LEFT(LTRIM(RTRIM(CONVERT(varchar(50), ra.EmpID))), 15), ''),
                ra.Employee_Name,
                TRY_CONVERT(int, ra.JobTicketID),
                ra.JobCode,
                CONVERT(datetime2(0), ra.LA_Start),
                CONVERT(datetime2(0), ra.LA_End)
            FROM #ReconAudit ra
            WHERE NOT EXISTS
            (
                SELECT 1
                FROM fms.Payroll_CalcException e
                WHERE e.CalcRunAt = @CalcRunAt
                  AND e.LaborPayrollID = ra.LaborPayrollID
            );

            DECLARE @ReconInserted int = @@ROWCOUNT;

            DROP TABLE #ReconAudit;

            PRINT '   Reconstruction warnings appended to existing rows: ' + CAST(@ReconUpdated AS varchar(20));
            PRINT '   Reconstruction warnings inserted as new rows: ' + CAST(@ReconInserted AS varchar(20));

            IF @OwnRunLog = 1 AND @RunId IS NOT NULL
            BEGIN
                UPDATE etl.RunLog
                SET
                    EndedAtUTC   = SYSUTCDATETIME(),
                    Status       = N'Succeeded',
                    ErrorMessage = NULL
                WHERE RunId = @RunId;

                EXEC sys.sp_set_session_context @key = N'PayrollAPP_RunLogID', @value = NULL;
            END

            PRINT '   Load done in ' + CAST(DATEDIFF(SECOND, @StartTime, SYSDATETIME()) AS varchar(10)) + ' sec';
            PRINT 'Update Complete. Records processed: ' + CAST(@RowsInserted AS varchar(20));
        END TRY
        BEGIN CATCH
            IF XACT_STATE() <> 0 ROLLBACK TRAN;

            IF @OwnRunLog = 1 AND @RunId IS NOT NULL
            BEGIN
                UPDATE etl.RunLog
                SET
                    EndedAtUTC   = SYSUTCDATETIME(),
                    Status       = N'Failed',
                    ErrorMessage = LEFT(ERROR_MESSAGE(), 4000)
                WHERE RunId = @RunId;

                EXEC sys.sp_set_session_context @key = N'PayrollAPP_RunLogID', @value = NULL;
            END

            ;THROW;
        END CATCH

        IF @HasAppLock = 1
            EXEC sp_releaseapplock @Resource = N'app.usp_Run_Pricing_Engine', @LockOwner = N'Session';

    END TRY
    BEGIN CATCH
        IF @HasAppLock = 1
            EXEC sp_releaseapplock @Resource = N'app.usp_Run_Pricing_Engine', @LockOwner = N'Session';

        ;THROW;
    END CATCH
END;
