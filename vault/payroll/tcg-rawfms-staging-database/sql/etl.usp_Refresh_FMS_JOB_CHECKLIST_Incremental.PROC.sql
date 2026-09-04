
CREATE   PROCEDURE etl.usp_Refresh_FMS_JOB_CHECKLIST_Incremental
    @RowsDelta bigint = 0 OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET DEADLOCK_PRIORITY LOW;

    SET @RowsDelta = 0;

    DECLARE
        @LockResult      int,
        @LastWM          datetime2(0),
        @NewWM           datetime2(0),
        @BatchStart      datetime2(0) = SYSUTCDATETIME(),
        @LinkedServer    sysname = N'FCC_NexGen',
        @RemoteQuery     nvarchar(max),
        @ExecQuery       nvarchar(max),
        @DateStr         varchar(19),
        @AppLockResource nvarchar(200) = N'etl.usp_Refresh_FMS_JOB_CHECKLIST_Incremental';

    EXEC @LockResult = sp_getapplock
          @Resource    = @AppLockResource
        , @LockMode    = N'Exclusive'
        , @LockOwner   = N'Session'
        , @LockTimeout = 0;

    IF @LockResult < 0
        THROW 50001, 'Could not acquire applock (another run is active).', 1;

    BEGIN TRY
        -- Watermark with overlap
        SELECT @LastWM = ISNULL(LastWatermarkUTC, CONVERT(datetime2(0), '1900-01-01'))
        FROM etl.LoadWatermark
        WHERE TableName = 'FMS_JOB_CHECKLIST';

        SET @LastWM  = DATEADD(SECOND, -5, @LastWM);
        SET @DateStr = CONVERT(varchar(19), @LastWM, 120); -- yyyy-mm-dd hh:mi:ss

        -- Build column lists from TARGET (stg)
        DECLARE @DataCols nvarchar(max), @SelectCols nvarchar(max), @UpdateSet nvarchar(max);

        SELECT
            @DataCols = STRING_AGG(CAST(QUOTENAME(c.name) AS nvarchar(max)), N', ')
                       WITHIN GROUP (ORDER BY c.column_id)
        FROM sys.columns c
        WHERE c.object_id = OBJECT_ID(N'stg.FMS_JOB_CHECKLIST_Raw')
          AND c.is_computed = 0
          AND c.name NOT IN (N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

        SELECT
            @SelectCols = STRING_AGG(CAST(N's.' + QUOTENAME(c.name) AS nvarchar(max)), N', ')
                          WITHIN GROUP (ORDER BY c.column_id)
        FROM sys.columns c
        WHERE c.object_id = OBJECT_ID(N'stg.FMS_JOB_CHECKLIST_Raw')
          AND c.is_computed = 0
          AND c.name NOT IN (N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

        SELECT
            @UpdateSet = STRING_AGG(
                           CAST(N't.' + QUOTENAME(c.name) + N' = s.' + QUOTENAME(c.name) AS nvarchar(max)),
                           N', '
                         ) WITHIN GROUP (ORDER BY c.column_id)
        FROM sys.columns c
        WHERE c.object_id = OBJECT_ID(N'stg.FMS_JOB_CHECKLIST_Raw')
          AND c.is_computed = 0
          AND c.name NOT IN (N'JobCode', N'CheckListID', N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

        IF @DataCols IS NULL OR @SelectCols IS NULL OR @UpdateSet IS NULL
            THROW 50000, 'Could not build dynamic column lists for stg.FMS_JOB_CHECKLIST_Raw.', 1;

        -- Delta table (stable shape)
        IF OBJECT_ID('tempdb..#Delta') IS NOT NULL DROP TABLE #Delta;
        SELECT TOP (0) * INTO #Delta FROM stg.FMS_JOB_CHECKLIST_Raw;

        IF COL_LENGTH('tempdb..#Delta', '_SourceExtractedAtUTC') IS NOT NULL
            ALTER TABLE #Delta DROP COLUMN _SourceExtractedAtUTC;
        IF COL_LENGTH('tempdb..#Delta', '_LoadedAtUTC') IS NOT NULL
            ALTER TABLE #Delta DROP COLUMN _LoadedAtUTC;

        -- Vendor pull (pass-through)
        SET @RemoteQuery =
            N'SELECT ' + @DataCols + N'
              FROM NexGenFMS.dbo.FMS_JOB_CHECKLIST
              WHERE (ModifiedDate > ''' + @DateStr + N'''
                     OR (ModifiedDate IS NULL AND CreatedDate > ''' + @DateStr + N'''))';

        SET @RemoteQuery = REPLACE(@RemoteQuery, '''', '''''');

        SET @ExecQuery =
            N'INSERT INTO #Delta (' + @DataCols + N')
              SELECT ' + @DataCols + N'
              FROM OPENQUERY(' + QUOTENAME(@LinkedServer) + N', ''' + @RemoteQuery + N''');';

        EXEC sp_executesql @ExecQuery;

        IF NOT EXISTS (SELECT 1 FROM #Delta)
        BEGIN
            EXEC sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';
            RETURN;
        END

        -- Index + dedupe latest per (JobCode, CheckListID)
        CREATE INDEX IX_Delta_JobChecklist_Key ON #Delta (JobCode, CheckListID);

        IF OBJECT_ID('tempdb..#Delta_Dedup') IS NOT NULL DROP TABLE #Delta_Dedup;

        ;WITH d AS
        (
            SELECT
                *,
                rn = ROW_NUMBER() OVER
                     (
                       PARTITION BY JobCode, CheckListID
                       ORDER BY
                         COALESCE(ModifiedDate, CreatedDate) DESC
                     )
            FROM #Delta
        )
        SELECT * INTO #Delta_Dedup
        FROM d
        WHERE rn = 1;

        CREATE INDEX IX_DeltaDedup_JobChecklist_Key ON #Delta_Dedup (JobCode, CheckListID);

        SELECT
            @RowsDelta = COUNT_BIG(*),
            @NewWM = MAX(COALESCE(ModifiedDate, CreatedDate))
        FROM #Delta_Dedup;

        IF @NewWM IS NULL
        BEGIN
            EXEC sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';
            RETURN;
        END

        BEGIN TRANSACTION;

            DECLARE @Sql nvarchar(max) = N'
                UPDATE t
                   SET ' + @UpdateSet + N',
                       t._LoadedAtUTC = SYSUTCDATETIME()
                FROM stg.FMS_JOB_CHECKLIST_Raw t
                JOIN #Delta_Dedup s
                  ON t.JobCode = s.JobCode
                 AND t.CheckListID = s.CheckListID
                WHERE ISNULL(COALESCE(t.ModifiedDate, t.CreatedDate), CONVERT(datetime2(0), ''1900-01-01''))
                    < ISNULL(COALESCE(s.ModifiedDate, s.CreatedDate), CONVERT(datetime2(0), ''1900-01-01''));

                INSERT INTO stg.FMS_JOB_CHECKLIST_Raw (' + @DataCols + N', _SourceExtractedAtUTC, _LoadedAtUTC)
                SELECT ' + @SelectCols + N', @BatchStart, SYSUTCDATETIME()
                FROM #Delta_Dedup s
                WHERE NOT EXISTS
                (
                    SELECT 1
                    FROM stg.FMS_JOB_CHECKLIST_Raw t
                    WHERE t.JobCode = s.JobCode
                      AND t.CheckListID = s.CheckListID
                );';

            EXEC sp_executesql @Sql, N'@BatchStart datetime2(0)', @BatchStart = @BatchStart;

            IF EXISTS (SELECT 1 FROM etl.LoadWatermark WHERE TableName = 'FMS_JOB_CHECKLIST')
                UPDATE etl.LoadWatermark
                   SET LastWatermarkUTC = @NewWM,
                       LastRunUTC       = SYSUTCDATETIME()
                 WHERE TableName = 'FMS_JOB_CHECKLIST';
            ELSE
                INSERT etl.LoadWatermark (TableName, LastWatermarkUTC, LastRunUTC)
                VALUES ('FMS_JOB_CHECKLIST', @NewWM, SYSUTCDATETIME());

        COMMIT TRANSACTION;

        EXEC sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        EXEC sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';

        DECLARE @ErrLine int = ERROR_LINE(),
                @ErrMsg  nvarchar(4000) = ERROR_MESSAGE(),
                @ThrowMsg nvarchar(2048);

        SET @ThrowMsg = LEFT(N'etl.usp_Refresh_FMS_JOB_CHECKLIST_Incremental failed (line '
                            + CONVERT(nvarchar(10), @ErrLine) + N'): ' + @ErrMsg, 2048);
        THROW 51000, @ThrowMsg, 1;
    END CATCH
END;
