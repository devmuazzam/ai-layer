
CREATE   PROCEDURE [etl].[usp_Refresh_FMS_JOB_TICKET_Incremental]
    @RowsDelta bigint = 0 OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @RowsDelta = 0;

    DECLARE
        @LastWM          datetime2(0),
        @NewWM           datetime2(0),
        @BatchStart      datetime2(0) = SYSUTCDATETIME(),
        @RemoteQuery     nvarchar(max),
        @ExecQuery       nvarchar(max),
        @LinkedServer    sysname = N'FCC_NexGen';

    SELECT @LastWM = ISNULL(LastWatermarkUTC, '1900-01-01')
    FROM etl.LoadWatermark
    WHERE TableName = 'FMS_JOB_TICKET';

    -- Small overlap to avoid missing same-second updates due to datetime2(0) watermark
    DECLARE @LastWM_Overlap datetime2(0) = DATEADD(SECOND, -5, @LastWM);

    IF OBJECT_ID('tempdb..#Delta_Ticket') IS NOT NULL
        DROP TABLE #Delta_Ticket;

    -- Temp delta table matches your source shape
    SELECT TOP (0) *
    INTO #Delta_Ticket
    FROM [src].[FMS_JOB_TICKET];

    DECLARE @DateStr varchar(19) = CONVERT(varchar(19), @LastWM_Overlap, 120); -- yyyy-mm-dd hh:mi:ss

    SET @RemoteQuery =
        N'SELECT * FROM NexGenFMS.dbo.FMS_JOB_TICKET WHERE ModifiedDate > ''' + @DateStr + N'''';

    -- escape quotes for OPENQUERY
    SET @RemoteQuery = REPLACE(@RemoteQuery, '''', '''''');

    SET @ExecQuery =
        N'INSERT INTO #Delta_Ticket
          SELECT *
          FROM OPENQUERY(' + QUOTENAME(@LinkedServer) + N', ''' + @RemoteQuery + N''')';

    -- Pull delta from vendor
    EXEC sp_executesql @ExecQuery;

    IF NOT EXISTS (SELECT 1 FROM #Delta_Ticket)
        RETURN;

    -- OPTIONAL PERFORMANCE IMPROVEMENT: speeds joins / NOT EXISTS checks
    CREATE INDEX IX_Delta_Ticket_JobTicketID ON #Delta_Ticket (JobTicketID);

    SELECT
        @RowsDelta = COUNT_BIG(*),
        @NewWM     = MAX(ModifiedDate)
    FROM #Delta_Ticket;

    IF @NewWM IS NULL
        RETURN;

    DECLARE
        @UpdateSet  nvarchar(max),
        @InsertCols nvarchar(max),
        @SelectCols nvarchar(max);

    ----------------------------------------------------------------------------
    -- Build column lists from TARGET (stg), excluding metadata
    -- FIXES:
    --  1) Cast to NVARCHAR(MAX) inside STRING_AGG to avoid 8000-byte limit
    --  2) ORDER BY column_id for deterministic list order
    ----------------------------------------------------------------------------

    SELECT
        @UpdateSet =
            STRING_AGG(
                CAST(CONCAT(N't.', QUOTENAME(c.name), N' = s.', QUOTENAME(c.name)) AS nvarchar(max)),
                N', '
            ) WITHIN GROUP (ORDER BY c.column_id)
    FROM sys.columns c
    WHERE c.object_id = OBJECT_ID(N'stg.FMS_JOB_TICKET_Raw')
      AND c.is_computed = 0
      AND c.name NOT IN (N'JobTicketID', N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

    SELECT
        @InsertCols =
            STRING_AGG(
                CAST(QUOTENAME(c.name) AS nvarchar(max)),
                N', '
            ) WITHIN GROUP (ORDER BY c.column_id),
        @SelectCols =
            STRING_AGG(
                CAST(CONCAT(N's.', QUOTENAME(c.name)) AS nvarchar(max)),
                N', '
            ) WITHIN GROUP (ORDER BY c.column_id)
    FROM sys.columns c
    WHERE c.object_id = OBJECT_ID(N'stg.FMS_JOB_TICKET_Raw')
      AND c.is_computed = 0
      AND c.name NOT IN (N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

    IF @UpdateSet IS NULL OR @InsertCols IS NULL OR @SelectCols IS NULL
        THROW 50000, 'Could not build dynamic column lists for stg.FMS_JOB_TICKET_Raw.', 1;

    BEGIN TRANSACTION;

        DECLARE @Sql nvarchar(max) = N'
            UPDATE t
                SET ' + @UpdateSet + N',
                    t._LoadedAtUTC = SYSUTCDATETIME()
            FROM stg.FMS_JOB_TICKET_Raw t
            JOIN #Delta_Ticket s
              ON t.JobTicketID = s.JobTicketID;

            INSERT INTO stg.FMS_JOB_TICKET_Raw (' + @InsertCols + N', _SourceExtractedAtUTC, _LoadedAtUTC)
            SELECT ' + @SelectCols + N', @BatchStart, SYSUTCDATETIME()
            FROM #Delta_Ticket s
            WHERE NOT EXISTS (
                SELECT 1
                FROM stg.FMS_JOB_TICKET_Raw t
                WHERE t.JobTicketID = s.JobTicketID
            );
        ';

        EXEC sp_executesql @Sql, N'@BatchStart datetime2(0)', @BatchStart = @BatchStart;

        IF EXISTS (SELECT 1 FROM etl.LoadWatermark WHERE TableName = 'FMS_JOB_TICKET')
            UPDATE etl.LoadWatermark
               SET LastWatermarkUTC = @NewWM,
                   LastRunUTC       = SYSUTCDATETIME()
             WHERE TableName = 'FMS_JOB_TICKET';
        ELSE
            INSERT INTO etl.LoadWatermark (TableName, LastWatermarkUTC, LastRunUTC)
            VALUES ('FMS_JOB_TICKET', @NewWM, SYSUTCDATETIME());

    COMMIT TRANSACTION;
END;
