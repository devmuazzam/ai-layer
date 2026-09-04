CREATE   PROCEDURE [etl].[usp_Refresh_FMS_RESOURCE_CHECKLIST_ADHOC_Full]
    @RowsLoaded bigint = 0 OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET DEADLOCK_PRIORITY LOW;

    DECLARE
        @BatchStart      datetime2(0) = SYSUTCDATETIME(),
        @LockResult      int,
        @RemoteQuery     nvarchar(max),
        @ExecQuery       nvarchar(max),
        @StagedRows      bigint = 0;

    SET @RowsLoaded = 0;

    EXEC @LockResult = sp_getapplock
          @Resource    = N'[etl].[usp_Refresh_FMS_RESOURCE_CHECKLIST_ADHOC_Full]',
          @LockMode    = N'Exclusive',
          @LockOwner   = N'Session',
          @LockTimeout = 0;

    IF @LockResult < 0
        THROW 50001, 'Could not acquire applock (another run is active).', 1;

    BEGIN TRY
        IF OBJECT_ID('tempdb..#SourceData') IS NOT NULL DROP TABLE #SourceData;

        -- Create #SourceData with stg shape, then remove metadata columns
        SELECT TOP (0) *
        INTO #SourceData
        FROM [stg].[FMS_RESOURCE_CHECKLIST_ADHOC_Raw];

        IF COL_LENGTH('tempdb..#SourceData', '_SourceExtractedAtUTC') IS NOT NULL
            ALTER TABLE #SourceData DROP COLUMN _SourceExtractedAtUTC;
        IF COL_LENGTH('tempdb..#SourceData', '_LoadedAtUTC') IS NOT NULL
            ALTER TABLE #SourceData DROP COLUMN _LoadedAtUTC;

        DECLARE @DataCols nvarchar(max) = N'[ResourceCheckListAdhocID], [ComponentCode], [ResourceCheckListID], [Name], [SignatureRequired], [Status], [CompletedDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [TransactionCode], [UnitCode], [UnitCheckListID], [JobTicketID]';

        -- OPENQUERY pass-through (explicit columns, no SELECT *)
        SET @RemoteQuery = N'SELECT ' + @DataCols + N' FROM [NexGenFMS].[dbo].[FMS_RESOURCE_CHECKLIST_ADHOC]';
        SET @RemoteQuery = REPLACE(@RemoteQuery, '''', ''''''); -- escape single quotes for OPENQUERY literal

        SET @ExecQuery =
            N'INSERT INTO #SourceData (' + @DataCols + N')
              SELECT ' + @DataCols + N'
              FROM OPENQUERY([FCC_NexGen], ''' + @RemoteQuery + N''');';

        EXEC sp_executesql @ExecQuery;

        SET @StagedRows = @@ROWCOUNT;

        BEGIN TRANSACTION;

            TRUNCATE TABLE [stg].[FMS_RESOURCE_CHECKLIST_ADHOC_Raw];

            

            -- FIXED: table hint placement (after table name, before column list)
            INSERT INTO [stg].[FMS_RESOURCE_CHECKLIST_ADHOC_Raw] WITH (TABLOCK)
                ([ResourceCheckListAdhocID], [ComponentCode], [ResourceCheckListID], [Name], [SignatureRequired], [Status], [CompletedDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [TransactionCode], [UnitCode], [UnitCheckListID], [JobTicketID], [_SourceExtractedAtUTC], [_LoadedAtUTC])
            SELECT
                [ResourceCheckListAdhocID], [ComponentCode], [ResourceCheckListID], [Name], [SignatureRequired], [Status], [CompletedDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [TransactionCode], [UnitCode], [UnitCheckListID], [JobTicketID], @BatchStart, SYSUTCDATETIME()
            FROM #SourceData;

            SET @RowsLoaded = @@ROWCOUNT;

            

        COMMIT TRANSACTION;

        -- Best-effort RunLogDetail update (keeps your pattern)
        DECLARE @RunId bigint = (SELECT TOP (1) RunId FROM etl.RunLog ORDER BY RunId DESC);
        IF @RunId IS NOT NULL
        BEGIN
            UPDATE etl.RunLogDetail
               SET RowsAffected = @RowsLoaded
             WHERE RunId = @RunId
               AND ObjectName = N'FMS_RESOURCE_CHECKLIST_ADHOC';
        END

        EXEC sp_releaseapplock @Resource = N'[etl].[usp_Refresh_FMS_RESOURCE_CHECKLIST_ADHOC_Full]', @LockOwner = N'Session';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        EXEC sp_releaseapplock @Resource = N'[etl].[usp_Refresh_FMS_RESOURCE_CHECKLIST_ADHOC_Full]', @LockOwner = N'Session';

        DECLARE
            @ErrLine int = ERROR_LINE(),
            @ErrMsg  nvarchar(4000) = ERROR_MESSAGE(),
            @ThrowMsg nvarchar(2048);

        SET @ThrowMsg = LEFT(CONCAT(N'[etl].[usp_Refresh_FMS_RESOURCE_CHECKLIST_ADHOC_Full] failed (line ', @ErrLine, N'): ', @ErrMsg), 2048);
        THROW 51000, @ThrowMsg, 1;
    END CATCH
END;
