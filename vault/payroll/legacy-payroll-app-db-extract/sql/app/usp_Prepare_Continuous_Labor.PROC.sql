
/* 
Purpose:
    Rebuild fms.Labor_PreProcessed from raw labor rows, creating:
      - REAL worked labor rows only (one per valid source record)
    This procedure does NOT materialize "gap/ghost" rows.

Key rules:
    - Anchor date is WorkDate (date-only)
    - TimeStart/TimeEnd: use time-of-day only; ignore source date portion
    - Cross-midnight: End is WorkDate+1 when end time-of-day < start time-of-day
    - Rounding: Start down to 30-min, End up to 30-min
*/

CREATE PROCEDURE [app].[usp_Prepare_Continuous_Labor]
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;  -- if a runtime error occurs, SQL Server auto-aborts the transaction

    BEGIN TRY
        BEGIN TRAN;

        /* ============================================================
           A) Clear target table (full rebuild pattern)
           ------------------------------------------------------------
           This is a destructive refresh by design.
           Every run recreates the entire preprocessed timeline.
           ============================================================ */
        TRUNCATE TABLE fms.Labor_PreProcessed;

        /* ============================================================
           B) Build all timeline prep rows once into #Final (no recursion)
           ------------------------------------------------------------
           to make later real-row and gap-row inserts simple and fast.
           ============================================================ */
        IF OBJECT_ID('tempdb..#Final') IS NOT NULL
            DROP TABLE #Final;

        ;WITH 
        Base AS
        (
            /* ============================================================
            Base (REWRITTEN)
            ------------------------------------------------------------
            Normalize raw labor times using WorkDate as the anchor date:
                - Use ONLY the time portion of TimeStart / TimeEnd
                - Anchor both to WorkDate
                - If end time is earlier than start time, treat as cross-midnight
                and anchor end to WorkDate + 1 day
                - Round Start DOWN to nearest 30 minutes
                - Round End   UP   to nearest 30 minutes

            Important:
                We do NOT trust the DATE portion of raw TimeStart/TimeEnd.
                We only trust:
                - WorkDate (date anchor)
                - time-of-day from TimeStart / TimeEnd
            ============================================================ */
            SELECT
                P.LaborPayrollID,
                P.EmpID,
                P.JobCode,
                P.CraftCode,
                P.UnionCode,

                /* Force WorkDate to DATE only */
                W.WorkDate_Anchor AS WorkDate,

                /* Anchored + rounded datetimes (datetime2(0), minute-aligned to :00/:30) */
                A.Pay_Start,
                A.Pay_End,

                /* Adjacency helpers for continuity chaining / gap generation */
                LAG(A.Pay_End)
                    OVER (
                        PARTITION BY P.EmpID
                        ORDER BY A.Pay_Start, P.LaborPayrollID
                    ) AS Prev_End

            FROM src.FMS_LABOR_PAYROLL_Raw AS P

            /* 1) Normalize source fields to the pieces we trust */
            CROSS APPLY
            (
                SELECT
                    WorkDate_Anchor = CAST(P.WorkDate AS date),
                    StartTOD        = CAST(P.TimeStart AS time(7)),   -- time only (ignore raw date)
                    EndTOD          = CAST(P.TimeEnd   AS time(7))    -- time only (ignore raw date)
            ) AS W

            /* 2) Convert time-of-day to seconds since midnight (preserves seconds for proper "round up") */
            CROSS APPLY
            (
                SELECT
                    StartSecOfDay = CASE
                                    WHEN P.TimeStart IS NULL THEN NULL
                                    ELSE DATEDIFF(SECOND, CAST('00:00:00' AS time(0)), W.StartTOD)
                                    END,
                    EndSecOfDay   = CASE
                                    WHEN P.TimeEnd IS NULL THEN NULL
                                    ELSE DATEDIFF(SECOND, CAST('00:00:00' AS time(0)), W.EndTOD)
                                    END
            ) AS S

            /* 3) Anchor end to next day if it crosses midnight (end time-of-day < start time-of-day) */
            CROSS APPLY
            (
                SELECT
                    EndSecAnchored = CASE
                                    WHEN S.StartSecOfDay IS NULL OR S.EndSecOfDay IS NULL THEN NULL
                                    WHEN S.EndSecOfDay < S.StartSecOfDay THEN S.EndSecOfDay + 86400
                                    ELSE S.EndSecOfDay
                                    END
            ) AS X

            /* 4) Round Start DOWN and End UP to nearest 30-minute boundary (1800 seconds) */
            CROSS APPLY
            (
                SELECT
                    StartSecRoundedDown = CASE
                                            WHEN S.StartSecOfDay IS NULL THEN NULL
                                            ELSE (S.StartSecOfDay / 1800) * 1800
                                        END,
                    EndSecRoundedUp     = CASE
                                            WHEN X.EndSecAnchored IS NULL THEN NULL
                                            ELSE ((X.EndSecAnchored + 1799) / 1800) * 1800
                                        END
            ) AS R

            /* 5) Rebuild anchored datetime values from WorkDate + rounded seconds offset */
            CROSS APPLY
            (
                SELECT
                    Pay_Start = CASE
                                WHEN W.WorkDate_Anchor IS NULL OR R.StartSecRoundedDown IS NULL THEN NULL
                                ELSE CAST(
                                        DATEADD(SECOND, R.StartSecRoundedDown, CAST(W.WorkDate_Anchor AS datetime2(0)))
                                    AS datetime2(0))
                                END,

                    Pay_End   = CASE
                                WHEN W.WorkDate_Anchor IS NULL OR R.EndSecRoundedUp IS NULL THEN NULL
                                ELSE CAST(
                                        DATEADD(SECOND, R.EndSecRoundedUp, CAST(W.WorkDate_Anchor AS datetime2(0)))
                                    AS datetime2(0))
                                END
            ) AS A

            /* 6) Keep only rows that can produce a valid anchored interval */
            WHERE P.WorkDate IS NOT NULL
            AND P.TimeStart IS NOT NULL
            AND P.TimeEnd   IS NOT NULL
            AND A.Pay_End   > A.Pay_Start
        ),
        MarkBreaks AS
        (
            /* --------------------------------------------------------
               MarkBreaks = flag whether this row starts a NEW chain
               
               BreakFlag = 1 when:
                 - this is the first row for EmpID (Prev_End is NULL), OR
                 - gap from previous end to current start is >= 8 hours (480 min)
               
               Otherwise BreakFlag = 0, meaning it belongs to the current chain.
               -------------------------------------------------------- */
            SELECT
                B.*,
                CASE
                    WHEN B.Prev_End IS NULL THEN 1
                    WHEN DATEDIFF(MINUTE, B.Prev_End, B.Pay_Start) >= 480 THEN 1
                    ELSE 0
                END AS BreakFlag
            FROM Base AS B
        ),
        Grouped AS
        (
            /* --------------------------------------------------------
               Grouped = assign a running chain/group number per EmpID
               
               SUM(BreakFlag) cumulative window creates chain identifiers:
                 1,1,1,2,2,3,...
               
               This is the "continuous labor chain" grouping.
               -------------------------------------------------------- */
            SELECT
                M.*,
                SUM(M.BreakFlag) OVER
                (
                    PARTITION BY M.EmpID
                    ORDER BY M.Pay_Start, M.LaborPayrollID
                    ROWS UNBOUNDED PRECEDING
                ) AS ChainGroup
            FROM MarkBreaks AS M
        ),
        FinalCTE AS
        (
            /* --------------------------------------------------------
               FinalCTE = anchor each chain to a Pricing_Date
               
               Pricing_Date = FIRST WorkDate in the chain
               (based on Pay_Start/LaborPayrollID ordering)
               
               NOTE:
               This anchors to source WorkDate, not CAST(Pay_Start AS date).
               If source WorkDate differs from timestamp date, this preserves
               source behavior.
               -------------------------------------------------------- */
            SELECT
                G.*,
                FIRST_VALUE(G.WorkDate) OVER
                (
                    PARTITION BY G.EmpID, G.ChainGroup
                    ORDER BY G.Pay_Start, G.LaborPayrollID
                    ROWS UNBOUNDED PRECEDING
                ) AS Pricing_Date
            FROM Grouped AS G
        )
        SELECT
            F.LaborPayrollID,
            F.EmpID,
            F.JobCode,
            F.CraftCode,
            F.UnionCode,
            F.Pricing_Date,
            F.WorkDate,
            F.Pay_Start,
            F.Pay_End
        INTO #Final
        FROM FinalCTE AS F;

        /* ------------------------------------------------------------
           Helpful temp-table index:
           Supports efficient ordered scans for the insert steps below.
           ------------------------------------------------------------ */
        CREATE CLUSTERED INDEX IX_Final_Emp_Start
            ON #Final (EmpID, Pay_Start, LaborPayrollID);

        /* ============================================================
           C) Insert REAL labor rows into fms.Labor_PreProcessed
           ------------------------------------------------------------
           One row per valid source labor entry.
           Total_Hrs is computed from Pay_Start/Pay_End duration in minutes.
           ============================================================ */
        INSERT INTO fms.Labor_PreProcessed
        (
            Original_LaborID,
            EmpID,
            JobCode,
            CraftCode,
            UnionCode,
            Pricing_Date,
            Actual_WorkDate,
            Pay_Start,
            Pay_End,
            Total_Hrs,
            Is_Gap_Row
        )
        SELECT
            F.LaborPayrollID              AS Original_LaborID,
            F.EmpID,
            F.JobCode,
            F.CraftCode,
            F.UnionCode,
            F.Pricing_Date,
            F.WorkDate                    AS Actual_WorkDate,
            F.Pay_Start,
            F.Pay_End,
            DATEDIFF(MINUTE, F.Pay_Start, F.Pay_End) / 60.0 AS Total_Hrs,
            CONVERT(bit, 0)               AS Is_Gap_Row
        FROM #Final AS F;

        /* Cleanup temp object before commit */
        DROP TABLE #Final;

        COMMIT;
    END TRY
    BEGIN CATCH
        /* Best-effort cleanup */
        IF OBJECT_ID('tempdb..#Final') IS NOT NULL
            DROP TABLE #Final;

        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;
    END CATCH
END;
