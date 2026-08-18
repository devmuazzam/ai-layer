
CREATE   PROCEDURE calc.usp_Upsert_TicketTimeline_ForTicketIDList
    @IDs calc.JobTicketIDList READONLY
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (SELECT 1 FROM @IDs) RETURN;

    /* 1) Copy to temp table (indexed) */
    IF OBJECT_ID('tempdb..#J') IS NOT NULL DROP TABLE #J;

    SELECT JobTicketID
    INTO #J
    FROM @IDs;

    CREATE UNIQUE CLUSTERED INDEX CX_J ON #J(JobTicketID);

    /* 2) Pull ONLY needed columns for those tickets */
    IF OBJECT_ID('tempdb..#T') IS NOT NULL DROP TABLE #T;

    SELECT
        T.JobTicketID,
        JobCode       = MAX(CONVERT(varchar(50), T.JobCode)),
        TicketDate    = MAX(CONVERT(datetime2(0), T.TicketDate)),
        TimeStart     = MAX(CONVERT(datetime2(0), T.TimeStart)),
        YardOutTime   = MAX(CONVERT(datetime2(0), T.YardOutTime)),
        ArrivedJob    = MAX(CONVERT(datetime2(0), T.ArrivedJob)),
        StartWorkTime = MAX(CONVERT(datetime2(0), T.StartWorkTime)),
        EndWorkTime   = MAX(CONVERT(datetime2(0), T.EndWorkTime)),
        LeftJob       = MAX(CONVERT(datetime2(0), T.LeftJob))
    INTO #T
    FROM src.FMS_JOB_TICKET_Raw T
    JOIN #J J
      ON J.JobTicketID = T.JobTicketID
    GROUP BY T.JobTicketID
    OPTION (RECOMPILE);

    CREATE UNIQUE CLUSTERED INDEX CX_T ON #T(JobTicketID);

    /* 3) Compute boom windows */
    IF OBJECT_ID('tempdb..#TL') IS NOT NULL DROP TABLE #TL;

    ;WITH RawTimes AS
    (
        SELECT
            JobTicketID,
            JobCode,
            AnchorDate = CAST(TicketDate AS date),
            T01_TimeStart     = CAST(TimeStart AS time(0)),
            T02_YardOutTime   = CAST(YardOutTime AS time(0)),
            T03_ArrivedJob    = CAST(ArrivedJob AS time(0)),
            T04_StartWorkTime = CAST(COALESCE(StartWorkTime, ArrivedJob) AS time(0)),
            T07_EndWorkTime   = CAST(COALESCE(EndWorkTime,   LeftJob)    AS time(0))
        FROM #T
        WHERE TicketDate IS NOT NULL
    ),
    DayOffsets AS
    (
        SELECT *,
            Off_04 =
                (CASE WHEN T02_YardOutTime   < T01_TimeStart    THEN 1 ELSE 0 END) +
                (CASE WHEN T03_ArrivedJob    < T02_YardOutTime  THEN 1 ELSE 0 END) +
                (CASE WHEN T04_StartWorkTime < T03_ArrivedJob   THEN 1 ELSE 0 END),
            Off_07 =
                (CASE WHEN T02_YardOutTime   < T01_TimeStart    THEN 1 ELSE 0 END) +
                (CASE WHEN T03_ArrivedJob    < T02_YardOutTime  THEN 1 ELSE 0 END) +
                (CASE WHEN T04_StartWorkTime < T03_ArrivedJob   THEN 1 ELSE 0 END) +
                (CASE WHEN T07_EndWorkTime   < T04_StartWorkTime THEN 1 ELSE 0 END)
        FROM RawTimes
    ),
    ActualTimes AS
    (
        SELECT
            JobTicketID,
            JobCode,
            TicketDate = CAST(AnchorDate AS datetime2(0)),
            Act_BoomStart =
                CASE WHEN AnchorDate IS NULL OR T04_StartWorkTime IS NULL THEN NULL
                     ELSE DATEADD(minute, DATEDIFF(minute, 0, T04_StartWorkTime),
                          DATEADD(day, Off_04, CAST(AnchorDate AS datetime2(0))))
                END,
            Act_BoomEnd =
                CASE WHEN AnchorDate IS NULL OR T07_EndWorkTime IS NULL THEN NULL
                     ELSE DATEADD(minute, DATEDIFF(minute, 0, T07_EndWorkTime),
                          DATEADD(day, Off_07, CAST(AnchorDate AS datetime2(0))))
                END
        FROM DayOffsets
    ),
    RoundedTimes AS
    (
        SELECT *,
            Boom_Window_Start =
                CASE WHEN Act_BoomStart IS NULL THEN NULL
                     ELSE DATEADD(minute, (DATEDIFF(minute, 0, Act_BoomStart) / 30) * 30, 0)
                END,
            Boom_Window_End =
                CASE WHEN Act_BoomEnd IS NULL THEN NULL
                     ELSE DATEADD(minute, (CEILING(DATEDIFF(minute, 0, Act_BoomEnd) / 30.0)) * 30, 0)
                END
        FROM ActualTimes
    )
    SELECT
        JobTicketID,
        JobCode,
        TicketDate,
        Act_BoomStart,
        Act_BoomEnd,
        Boom_Window_Start,
        Boom_Window_End,
        CalculatedAt = SYSDATETIME()
    INTO #TL
    FROM RoundedTimes
    WHERE Act_BoomStart IS NOT NULL
      AND Act_BoomEnd   IS NOT NULL
      AND Act_BoomEnd > Act_BoomStart;

    CREATE UNIQUE CLUSTERED INDEX CX_TL ON #TL(JobTicketID);

    /* 4) Upsert (short transaction) */
    BEGIN TRAN;

        DELETE TT
        FROM calc.TicketTimeline TT
        JOIN #J J ON J.JobTicketID = TT.JobTicketID;

        INSERT INTO calc.TicketTimeline
        (JobTicketID, JobCode, TicketDate, Act_BoomStart, Act_BoomEnd, Boom_Window_Start, Boom_Window_End, CalculatedAt)
        SELECT
            JobTicketID, JobCode, TicketDate, Act_BoomStart, Act_BoomEnd, Boom_Window_Start, Boom_Window_End, CalculatedAt
        FROM #TL;

    COMMIT;
END
