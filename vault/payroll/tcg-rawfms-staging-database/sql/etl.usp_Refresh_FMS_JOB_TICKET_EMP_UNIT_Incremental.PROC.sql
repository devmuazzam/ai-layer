
CREATE   PROCEDURE etl.usp_Refresh_FMS_JOB_TICKET_EMP_UNIT_Incremental
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
        @AppLockResource nvarchar(200) = N'etl.usp_Refresh_FMS_JOB_TICKET_EMP_UNIT_Incremental';

    EXEC @LockResult = sp_getapplock
          @Resource    = @AppLockResource
        , @LockMode    = N'Exclusive'
        , @LockOwner   = N'Session'
        , @LockTimeout = 0;

    IF @LockResult < 0
        THROW 50001, 'Could not acquire applock (another run is active).', 1;

    BEGIN TRY
        SELECT @LastWM = ISNULL(LastWatermarkUTC, CONVERT(datetime2(0), '1900-01-01'))
        FROM etl.LoadWatermark
        WHERE TableName = 'FMS_JOB_TICKET_EMP_UNIT';

        SET @LastWM  = DATEADD(SECOND, -5, @LastWM);
        SET @DateStr = CONVERT(varchar(19), @LastWM, 120);

        DECLARE @DataCols nvarchar(max), @SelectCols nvarchar(max), @UpdateSet nvarchar(max);

        SELECT
            @DataCols = STRING_AGG(CAST(QUOTENAME(c.name) AS nvarchar(max)), N', ')
                       WITHIN GROUP (ORDER BY c.column_id)
        FROM sys.columns c
        WHERE c.object_id = OBJECT_ID(N'stg.FMS_JOB_TICKET_EMP_UNIT_Raw')
          AND c.is_computed = 0
          AND c.name NOT IN (N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

        SELECT
            @SelectCols = STRING_AGG(CAST(N's.' + QUOTENAME(c.name) AS nvarchar(max)), N', ')
                          WITHIN GROUP (ORDER BY c.column_id)
        FROM sys.columns c
        WHERE c.object_id = OBJECT_ID(N'stg.FMS_JOB_TICKET_EMP_UNIT_Raw')
          AND c.is_computed = 0
          AND c.name NOT IN (N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

        SELECT
            @UpdateSet = STRING_AGG(
                           CAST(N't.' + QUOTENAME(c.name) + N' = s.' + QUOTENAME(c.name) AS nvarchar(max)),
                           N', '
                         ) WITHIN GROUP (ORDER BY c.column_id)
        FROM sys.columns c
        WHERE c.object_id = OBJECT_ID(N'stg.FMS_JOB_TICKET_EMP_UNIT_Raw')
          AND c.is_computed = 0
          AND c.name NOT IN (N'JobTicketEmpUnitID', N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

        IF @DataCols IS NULL OR @SelectCols IS NULL OR @UpdateSet IS NULL
            THROW 50000, 'Could not build dynamic column lists for stg.FMS_JOB_TICKET_EMP_UNIT_Raw.', 1;

        IF OBJECT_ID('tempdb..#Delta') IS NOT NULL DROP TABLE #Delta;
        SELECT TOP (0) * INTO #Delta FROM stg.FMS_JOB_TICKET_EMP_UNIT_Raw;

        IF COL_LENGTH('tempdb..#Delta', '_SourceExtractedAtUTC') IS NOT NULL
            ALTER TABLE #Delta DROP COLUMN _SourceExtractedAtUTC;
        IF COL_LENGTH('tempdb..#Delta', '_LoadedAtUTC') IS NOT NULL
            ALTER TABLE #Delta DROP COLUMN _LoadedAtUTC;

        SET @RemoteQuery =
            N'SELECT ' + @DataCols + N'
              FROM NexGenFMS.dbo.FMS_JOB_TICKET_EMP_UNIT
              WHERE ModifiedDate > ''' + @DateStr + N'''';

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

        CREATE INDEX IX_Delta_JTEU_ID ON #Delta (JobTicketEmpUnitID);

        IF OBJECT_ID('tempdb..#Delta_Dedup') IS NOT NULL DROP TABLE #Delta_Dedup;

        ;WITH d AS
        (
            SELECT *,
                   rn = ROW_NUMBER() OVER (PARTITION BY JobTicketEmpUnitID ORDER BY ModifiedDate DESC)
            FROM #Delta
        )
        SELECT * INTO #Delta_Dedup
        FROM d
        WHERE rn = 1;

        CREATE INDEX IX_DeltaDedup_JTEU_ID ON #Delta_Dedup (JobTicketEmpUnitID);

        SELECT
            @RowsDelta = COUNT_BIG(*),
            @NewWM     = MAX(ModifiedDate)
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
                FROM stg.FMS_JOB_TICKET_EMP_UNIT_Raw t
                JOIN #Delta_Dedup s
                  ON t.JobTicketEmpUnitID = s.JobTicketEmpUnitID
                WHERE ISNULL(t.ModifiedDate, CONVERT(datetime2(0), ''1900-01-01''))
                    < ISNULL(s.ModifiedDate, CONVERT(datetime2(0), ''1900-01-01''));

                INSERT INTO stg.FMS_JOB_TICKET_EMP_UNIT_Raw (' + @DataCols + N', _SourceExtractedAtUTC, _LoadedAtUTC)
                SELECT ' + @SelectCols + N', @BatchStart, SYSUTCDATETIME()
                FROM #Delta_Dedup s
                WHERE NOT EXISTS
                (
                    SELECT 1
                    FROM stg.FMS_JOB_TICKET_EMP_UNIT_Raw t
                    WHERE t.JobTicketEmpUnitID = s.JobTicketEmpUnitID
                );';

            EXEC sp_executesql @Sql, N'@BatchStart datetime2(0)', @BatchStart = @BatchStart;

            IF EXISTS (SELECT 1 FROM etl.LoadWatermark WHERE TableName = 'FMS_JOB_TICKET_EMP_UNIT')
                UPDATE etl.LoadWatermark
                   SET LastWatermarkUTC = @NewWM,
                       LastRunUTC       = SYSUTCDATETIME()
                 WHERE TableName = 'FMS_JOB_TICKET_EMP_UNIT';
            ELSE
                INSERT etl.LoadWatermark (TableName, LastWatermarkUTC, LastRunUTC)
                VALUES ('FMS_JOB_TICKET_EMP_UNIT', @NewWM, SYSUTCDATETIME());

        COMMIT TRANSACTION;

        EXEC sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        EXEC sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';

        DECLARE @ErrLine int = ERROR_LINE(),
                @ErrMsg  nvarchar(4000) = ERROR_MESSAGE(),
                @ThrowMsg nvarchar(2048);

        SET @ThrowMsg = LEFT(N'etl.usp_Refresh_FMS_JOB_TICKET_EMP_UNIT_Incremental failed (line '
                            + CONVERT(nvarchar(10), @ErrLine) + N'): ' + @ErrMsg, 2048);
        THROW 51000, @ThrowMsg, 1;
    END CATCH
END;
