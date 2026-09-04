
CREATE   PROCEDURE [etl].[usp_Refresh_FMS_LABOR_PAYROLL_Incremental]
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
        @RemoteQuery     nvarchar(max),
        @ExecQuery       nvarchar(max),
        @LinkedServer    sysname = N'FCC_NexGen',
        @DateStr         varchar(19),
        @AppLockResource nvarchar(200) = N'etl.usp_Refresh_FMS_LABOR_PAYROLL_Incremental';

    -------------------------------------------------------------------------
    -- Prevent overlapping executions
    -------------------------------------------------------------------------
    EXEC @LockResult = sp_getapplock
          @Resource    = @AppLockResource
        , @LockMode    = N'Exclusive'
        , @LockOwner   = N'Session'
        , @LockTimeout = 0;

    IF @LockResult < 0
        THROW 50001, 'Could not acquire applock (another run is active).', 1;

    BEGIN TRY
        ---------------------------------------------------------------------
        -- Watermark (UTC) with small overlap
        ---------------------------------------------------------------------
        SELECT @LastWM = ISNULL(LastWatermarkUTC, CONVERT(datetime2(0), '1900-01-01'))
        FROM etl.LoadWatermark
        WHERE TableName = 'FMS_LABOR_PAYROLL';

        SET @LastWM = DATEADD(SECOND, -5, @LastWM);
        SET @DateStr = CONVERT(varchar(19), @LastWM, 120); -- yyyy-mm-dd hh:mi:ss

        ---------------------------------------------------------------------
        -- Build deterministic, LOB-safe column lists from TARGET (stg)
        ---------------------------------------------------------------------
        DECLARE
            @DataCols    nvarchar(max),
            @SelectCols  nvarchar(max),
            @UpdateSet   nvarchar(max);

        SELECT
            @DataCols =
                STRING_AGG(CAST(QUOTENAME(c.name) AS nvarchar(max)), N', ')
                WITHIN GROUP (ORDER BY c.column_id)
        FROM sys.columns c
        WHERE c.object_id = OBJECT_ID(N'stg.FMS_LABOR_PAYROLL_Raw')
          AND c.is_computed = 0
          AND c.name NOT IN (N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

        SELECT
            @SelectCols =
                STRING_AGG(CAST(CONCAT(N's.', QUOTENAME(c.name)) AS nvarchar(max)), N', ')
                WITHIN GROUP (ORDER BY c.column_id)
        FROM sys.columns c
        WHERE c.object_id = OBJECT_ID(N'stg.FMS_LABOR_PAYROLL_Raw')
          AND c.is_computed = 0
          AND c.name NOT IN (N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

        SELECT
            @UpdateSet =
                STRING_AGG(
                    CAST(CONCAT(N't.', QUOTENAME(c.name), N' = s.', QUOTENAME(c.name)) AS nvarchar(max)),
                    N', '
                ) WITHIN GROUP (ORDER BY c.column_id)
        FROM sys.columns c
        WHERE c.object_id = OBJECT_ID(N'stg.FMS_LABOR_PAYROLL_Raw')
          AND c.is_computed = 0
          AND c.name NOT IN (N'LaborPayrollID', N'_SourceExtractedAtUTC', N'_LoadedAtUTC');

        IF @DataCols IS NULL OR @SelectCols IS NULL OR @UpdateSet IS NULL
            THROW 50000, 'Could not build dynamic column lists for stg.FMS_LABOR_PAYROLL_Raw.', 1;

        ---------------------------------------------------------------------
        -- Temp delta table based on stg shape (stable), drop metadata columns
        ---------------------------------------------------------------------
        IF OBJECT_ID('tempdb..#Delta_LP') IS NOT NULL DROP TABLE #Delta_LP;

        SELECT TOP (0) *
        INTO #Delta_LP
        FROM stg.FMS_LABOR_PAYROLL_Raw;

        IF COL_LENGTH('tempdb..#Delta_LP', '_SourceExtractedAtUTC') IS NOT NULL
            ALTER TABLE #Delta_LP DROP COLUMN _SourceExtractedAtUTC;

        IF COL_LENGTH('tempdb..#Delta_LP', '_LoadedAtUTC') IS NOT NULL
            ALTER TABLE #Delta_LP DROP COLUMN _LoadedAtUTC;

        ---------------------------------------------------------------------
        -- Vendor pull (explicit columns; no SELECT *)
        ---------------------------------------------------------------------
        SET @RemoteQuery =
            N'SELECT ' + @DataCols + N'
              FROM NexGenFMS.dbo.FMS_LABOR_PAYROLL
              WHERE ModifiedDate > ''' + @DateStr + N'''';

        SET @RemoteQuery = REPLACE(@RemoteQuery, '''', '''''');

        SET @ExecQuery =
            N'INSERT INTO #Delta_LP (' + @DataCols + N')
              SELECT ' + @DataCols + N'
              FROM OPENQUERY(' + QUOTENAME(@LinkedServer) + N', ''' + @RemoteQuery + N''');';

        EXEC sp_executesql @ExecQuery;

        ---------------------------------------------------------------------
        -- Early exit (release applock first)
        ---------------------------------------------------------------------
        IF NOT EXISTS (SELECT 1 FROM #Delta_LP)
        BEGIN
            EXEC sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';
            RETURN;
        END

        ---------------------------------------------------------------------
        -- Index delta for join/dedupe performance
        ---------------------------------------------------------------------
        IF COL_LENGTH('tempdb..#Delta_LP', 'ModifiedDate') IS NOT NULL
            CREATE INDEX IX_DeltaLP_LaborPayrollID_ModifiedDate
            ON #Delta_LP (LaborPayrollID, ModifiedDate);
        ELSE
            CREATE INDEX IX_DeltaLP_LaborPayrollID
            ON #Delta_LP (LaborPayrollID);

        ---------------------------------------------------------------------
        -- Dedupe safety: keep latest row per LaborPayrollID by ModifiedDate
        ---------------------------------------------------------------------
        IF OBJECT_ID('tempdb..#Delta_LP_Dedup') IS NOT NULL DROP TABLE #Delta_LP_Dedup;

        ;WITH d AS
        (
            SELECT
                *,
                rn = ROW_NUMBER() OVER (
                        PARTITION BY LaborPayrollID
                        ORDER BY
                            CASE WHEN ModifiedDate IS NULL THEN 0 ELSE 1 END DESC,
                            ModifiedDate DESC
                     )
            FROM #Delta_LP
        )
        SELECT *
        INTO #Delta_LP_Dedup
        FROM d
        WHERE rn = 1;

        CREATE INDEX IX_DeltaLPDedup_LaborPayrollID
        ON #Delta_LP_Dedup (LaborPayrollID);

        ---------------------------------------------------------------------
        -- Delta metrics + next watermark
        ---------------------------------------------------------------------
        SELECT
            @RowsDelta = COUNT_BIG(*),
            @NewWM     = MAX(ModifiedDate)
        FROM #Delta_LP_Dedup;

        IF @NewWM IS NULL
        BEGIN
            EXEC sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';
            RETURN;
        END

        ---------------------------------------------------------------------
        -- Upsert
        -- Efficiency: only UPDATE if incoming ModifiedDate is newer
        ---------------------------------------------------------------------
        BEGIN TRANSACTION;

            DECLARE @Sql nvarchar(max) = N'
                UPDATE t
                    SET ' + @UpdateSet + N',
                        t._LoadedAtUTC = SYSUTCDATETIME()
                FROM stg.FMS_LABOR_PAYROLL_Raw t
                JOIN #Delta_LP_Dedup s
                  ON t.LaborPayrollID = s.LaborPayrollID
                WHERE ISNULL(t.ModifiedDate, CONVERT(datetime2(0), ''1900-01-01''))
                      < ISNULL(s.ModifiedDate, CONVERT(datetime2(0), ''1900-01-01''));

                INSERT INTO stg.FMS_LABOR_PAYROLL_Raw (' + @DataCols + N', _SourceExtractedAtUTC, _LoadedAtUTC)
                SELECT ' + @SelectCols + N', @BatchStart, SYSUTCDATETIME()
                FROM #Delta_LP_Dedup s
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM stg.FMS_LABOR_PAYROLL_Raw t
                    WHERE t.LaborPayrollID = s.LaborPayrollID
                );
            ';

            EXEC sp_executesql
                @Sql,
                N'@BatchStart datetime2(0)',
                @BatchStart = @BatchStart;

            -----------------------------------------------------------------
            -- Advance watermark only after successful upsert
            -----------------------------------------------------------------
            IF EXISTS (SELECT 1 FROM etl.LoadWatermark WHERE TableName = 'FMS_LABOR_PAYROLL')
                UPDATE etl.LoadWatermark
                   SET LastWatermarkUTC = @NewWM,
                       LastRunUTC       = SYSUTCDATETIME()
                 WHERE TableName = 'FMS_LABOR_PAYROLL';
            ELSE
                INSERT etl.LoadWatermark (TableName, LastWatermarkUTC, LastRunUTC)
                VALUES ('FMS_LABOR_PAYROLL', @NewWM, SYSUTCDATETIME());

        COMMIT TRANSACTION;

        EXEC sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        -- Always release applock in error case too
        EXEC sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';

        DECLARE
            @ErrLine int = ERROR_LINE(),
            @ErrMsg  nvarchar(4000) = ERROR_MESSAGE(),
            @ThrowMsg nvarchar(2048);

        -- THROW requires message to be a literal or variable (not an expression)
        SET @ThrowMsg = LEFT(CONCAT('etl.usp_Refresh_FMS_LABOR_PAYROLL_Incremental failed (line ', @ErrLine, '): ', @ErrMsg), 2048);

        THROW 51000, @ThrowMsg, 1;
    END CATCH
END;
