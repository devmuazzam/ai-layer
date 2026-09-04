
CREATE PROCEDURE [etl].[usp_RunNightly_RawFMS]
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET DEADLOCK_PRIORITY LOW;

    DECLARE
        @RunId        int = NULL,
        @RunDetailId  int = NULL,
        @Err          nvarchar(2048) = NULL,
        @LockResult   int,
        @RowsDelta    bigint = 0,
        @RowsLoaded   bigint = 0;

    DECLARE @AppLockResource sysname = N'etl.usp_RunNightly_RawFMS';

    /* Prevent overlapping runs */
    EXEC @LockResult = sys.sp_getapplock
        @Resource    = @AppLockResource,
        @LockMode    = N'Exclusive',
        @LockOwner   = N'Session',
        @LockTimeout = 0;

    IF @LockResult < 0
    BEGIN
        DECLARE @utc datetime2(3) = SYSUTCDATETIME();

        INSERT INTO etl.RunLog
            (BatchName, StartTime, EndTime, Status, ErrorMessage, RunType,
             StartedAtUTC, EndedAtUTC, HostName, AppName, LoginName)
        VALUES
            ('NightlyRawFMS', SYSDATETIME(), SYSDATETIME(), 'Skipped',
             'Another RawFMS run is already in progress.',
             'NightlyRawFMS', @utc, @utc, HOST_NAME(), APP_NAME(), ORIGINAL_LOGIN());

        RETURN 0;
    END

    BEGIN TRY
        /* Run header */
        INSERT INTO etl.RunLog
            (BatchName, StartTime, Status, RunType, StartedAtUTC, HostName, AppName, LoginName)
        VALUES
            ('NightlyRawFMS', SYSDATETIME(), 'Running', 'NightlyRawFMS',
             SYSUTCDATETIME(), HOST_NAME(), APP_NAME(), ORIGINAL_LOGIN());

        SET @RunId = SCOPE_IDENTITY();

        /* Step manifest */
        DECLARE @Steps TABLE
        (
            StepOrder     int         NOT NULL PRIMARY KEY,
            ProcSchema    sysname     NOT NULL,
            ProcName      sysname     NOT NULL,
            ObjectName    varchar(200) NULL,
            TargetSchema  sysname     NULL,
            TargetTable   sysname     NULL
        );

        INSERT INTO @Steps (StepOrder, ProcSchema, ProcName, ObjectName, TargetSchema, TargetTable)
        VALUES
          ( 1,'etl','usp_Refresh_FMS_ACTIVITIES_Full',                 'FMS_ACTIVITIES',              'stg','FMS_ACTIVITIES_Raw'),
          ( 2,'etl','usp_Refresh_FMS_CHECK_LIST_Full',                 'FMS_CHECK_LIST',              'stg','FMS_CHECK_LIST_Raw'),
          ( 3,'etl','usp_Refresh_FMS_CHECK_LIST_DETAILS_Full',         'FMS_CHECK_LIST_DETAILS',      'stg','FMS_CHECK_LIST_DETAILS_Raw'),
          ( 4,'etl','usp_Refresh_FMS_CHECKED_TAKEN_Full',              'FMS_CHECKED_TAKEN',           'stg','FMS_CHECKED_TAKEN_Raw'),
          ( 5,'etl','usp_Refresh_FMS_CLASSIFICATIONS_Full',            'FMS_CLASSIFICATIONS',         'stg','FMS_CLASSIFICATIONS_Raw'),
          ( 6,'etl','usp_Refresh_FMS_CRAFT_MODIFIER_Full',             'FMS_CRAFT_MODIFIER',          'stg','FMS_CRAFT_MODIFIER_Raw'),
          ( 7,'etl','usp_Refresh_FMS_CRAFTS_Full',                     'FMS_CRAFTS',                  'stg','FMS_CRAFTS_Raw'),
          ( 8,'etl','usp_Refresh_FMS_CUSTOMER_CONTACTS_Full',          'FMS_CUSTOMER_CONTACTS',       'stg','FMS_CUSTOMER_CONTACTS_Raw'),
          ( 9,'etl','usp_Refresh_FMS_CUSTOMER_LOCATIONS_Full',         'FMS_CUSTOMER_LOCATIONS',      'stg','FMS_CUSTOMER_LOCATIONS_Raw'),
          (10,'etl','usp_Refresh_FMS_CUSTOMER_NOTES_Full',             'FMS_CUSTOMER_NOTES',          'stg','FMS_CUSTOMER_NOTES_Raw'),
          (11,'etl','usp_Refresh_FMS_CUSTOMERS_Full',                  'FMS_CUSTOMERS',               'stg','FMS_CUSTOMERS_Raw'),
          (12,'etl','usp_Refresh_FMS_DEPARTMENTS_Full',                'FMS_DEPARTMENTS',             'stg','FMS_DEPARTMENTS_Raw'),
          (13,'etl','usp_Refresh_FMS_EMPLOYEE_TYPES_Full',             'FMS_EMPLOYEE_TYPES',          'stg','FMS_EMPLOYEE_TYPES_Raw'),
          (14,'etl','usp_Refresh_FMS_EMPLOYEES_Full',                  'FMS_EMPLOYEES',               'stg','FMS_EMPLOYEES_Raw'),
          (15,'etl','usp_Refresh_FMS_ETHNICITY_Full',                  'FMS_ETHNICITY',               'stg','FMS_ETHNICITY_Raw'),
          (16,'etl','usp_Refresh_FMS_ETS_TICKET_SUB_SECTION_Full',     'FMS_ETS_TICKET_SUB_SECTION',  'stg','FMS_ETS_TICKET_SUB_SECTION_Raw'),
          (17,'etl','usp_Refresh_FMS_INDUSTRIES_Full',                 'FMS_INDUSTRIES',              'stg','FMS_INDUSTRIES_Raw'),

          (18,'etl','usp_Refresh_FMS_JOB_CHECKLIST_Incremental',       'FMS_JOB_CHECKLIST',           'stg','FMS_JOB_CHECKLIST_Raw'),
          (19,'etl','usp_Refresh_FMS_JOB_EMPLOYEES_Full',              'FMS_JOB_EMPLOYEES',           'stg','FMS_JOB_EMPLOYEES_Raw'),
          (20,'etl','usp_Refresh_FMS_JOB_MASTER_Incremental',          'FMS_JOB_MASTER',              'stg','FMS_JOB_MASTER_Raw'),
          (21,'etl','usp_Refresh_FMS_JOB_STATUS_Full',                 'FMS_JOB_STATUS',              'stg','FMS_JOB_STATUS_Raw'),
          (22,'etl','usp_Refresh_FMS_JOB_TICKET_Incremental',          'FMS_JOB_TICKET',              'stg','FMS_JOB_TICKET_Raw'),
          (23,'etl','usp_Refresh_FMS_JOB_TICKET_EMP_UNIT_Incremental', 'FMS_JOB_TICKET_EMP_UNIT',     'stg','FMS_JOB_TICKET_EMP_UNIT_Raw'),
          (24,'etl','usp_Refresh_FMS_JOB_TYPES_Full',                  'FMS_JOB_TYPES',               'stg','FMS_JOB_TYPES_Raw'),
          (25,'etl','usp_Refresh_FMS_JOB_UNIT_CHECK_LIST_Incremental', 'FMS_JOB_UNIT_CHECK_LIST',     'stg','FMS_JOB_UNIT_CHECK_LIST_Raw'),
          (26,'etl','usp_Refresh_FMS_JOB_UNITS_Full',                  'FMS_JOB_UNITS',               'stg','FMS_JOB_UNITS_Raw'),
          (27,'etl','usp_Refresh_FMS_LABOR_PAYROLL_Incremental',       'FMS_LABOR_PAYROLL',           'stg','FMS_LABOR_PAYROLL_Raw'),

          (28,'etl','usp_Refresh_FMS_RESOURCE_CHECKLIST_ADHOC_Full',   'FMS_RESOURCE_CHECKLIST_ADHOC','stg','FMS_RESOURCE_CHECKLIST_ADHOC_Raw'),
          (29,'etl','usp_Refresh_FMS_SALES_PERSON_Full',               'FMS_SALES_PERSON',            'stg','FMS_SALES_PERSON_Raw'),
          (30,'etl','usp_Refresh_FMS_SCHEDULE_TYPES_Full',             'FMS_SCHEDULE_TYPES',          'stg','FMS_SCHEDULE_TYPES_Raw'),
          (31,'etl','usp_Refresh_FMS_TERMS_Full',                      'FMS_TERMS',                   'stg','FMS_TERMS_Raw'),
          (32,'etl','usp_Refresh_FMS_TICKET_SECTIONS_SUBLIST_Full',    'FMS_TICKET_SECTIONS_SUBLIST', 'stg','FMS_TICKET_SECTIONS_SUBLIST_Raw'),
          (33,'etl','usp_Refresh_FMS_TICKET_STATUS_Full',              'FMS_TICKET_STATUS',           'stg','FMS_TICKET_STATUS_Raw'),
          (34,'etl','usp_Refresh_FMS_UNION_CRAFT_Full',                'FMS_UNION_CRAFT',             'stg','FMS_UNION_CRAFT_Raw'),
          (35,'etl','usp_Refresh_FMS_UNION_CRAFT_MODIFIER_Full',       'FMS_UNION_CRAFT_MODIFIER',    'stg','FMS_UNION_CRAFT_MODIFIER_Raw'),
          (36,'etl','usp_Refresh_FMS_UNIT_CHECK_LIST_Full',            'FMS_UNIT_CHECK_LIST',         'stg','FMS_UNIT_CHECK_LIST_Raw'),
          (37,'etl','usp_Refresh_FMS_UNIT_TYPE_DETAILS_Full',          'FMS_UNIT_TYPE_DETAILS',       'stg','FMS_UNIT_TYPE_DETAILS_Raw'),
          (38,'etl','usp_Refresh_FMS_UNIT_TYPES_Full',                 'FMS_UNIT_TYPES',              'stg','FMS_UNIT_TYPES_Raw'),
          (39,'etl','usp_Refresh_FMS_UNITS_Full',                      'FMS_UNITS',                   'stg','FMS_UNITS_Raw'),
          (40,'etl','usp_Refresh_FMS_UNITTYPE_JOBTYPES_Full',          'FMS_UNITTYPE_JOBTYPES',       'stg','FMS_UNITTYPE_JOBTYPES_Raw');

        /* Iterate steps safely (gap-proof) */
        DECLARE
            @StepOrder   int,
            @ProcSchema  sysname,
            @ProcName    sysname,
            @ObjectName  varchar(200),
            @TgtSchema   sysname,
            @TgtTable    sysname;

        DECLARE c CURSOR LOCAL FAST_FORWARD FOR
            SELECT StepOrder, ProcSchema, ProcName, ObjectName, TargetSchema, TargetTable
            FROM @Steps
            ORDER BY StepOrder;

        OPEN c;

        FETCH NEXT FROM c INTO @StepOrder, @ProcSchema, @ProcName, @ObjectName, @TgtSchema, @TgtTable;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE
                @ProcObjectId int = OBJECT_ID(CONCAT(@ProcSchema, '.', @ProcName)),
                @HasRowsDelta bit = 0,
                @HasRowsLoaded bit = 0,
                @TotalRows bigint = NULL,
                @StepStartUTC datetime2(3) = SYSUTCDATETIME(),
                @StepEndUTC   datetime2(3),
                @sql nvarchar(max);

            IF @ProcObjectId IS NULL
                THROW 50000, 'NightlyRawFMS: step proc not found.', 1;

            SELECT @HasRowsDelta = CASE WHEN EXISTS (
                SELECT 1 FROM sys.parameters WHERE object_id = @ProcObjectId AND name = N'@RowsDelta'
            ) THEN 1 ELSE 0 END;

            SELECT @HasRowsLoaded = CASE WHEN EXISTS (
                SELECT 1 FROM sys.parameters WHERE object_id = @ProcObjectId AND name = N'@RowsLoaded'
            ) THEN 1 ELSE 0 END;

            INSERT INTO etl.RunLogDetail
                (RunId, ObjectName, StepName, StartTime, StartedAtUTC, Status)
            VALUES
                (@RunId, @ObjectName, @ProcName, SYSDATETIME(), @StepStartUTC, 'Running');

            SET @RunDetailId = SCOPE_IDENTITY();

            BEGIN TRY
                SET @RowsDelta  = 0;
                SET @RowsLoaded = 0;

                IF @HasRowsDelta = 1
                BEGIN
                    SET @sql = N'EXEC ' + QUOTENAME(@ProcSchema) + N'.' + QUOTENAME(@ProcName)
                             + N' @RowsDelta = @p OUTPUT;';
                    EXEC sys.sp_executesql @sql, N'@p bigint OUTPUT', @p = @RowsDelta OUTPUT;
                END
                ELSE IF @HasRowsLoaded = 1
                BEGIN
                    SET @sql = N'EXEC ' + QUOTENAME(@ProcSchema) + N'.' + QUOTENAME(@ProcName)
                             + N' @RowsLoaded = @p OUTPUT;';
                    EXEC sys.sp_executesql @sql, N'@p bigint OUTPUT', @p = @RowsLoaded OUTPUT;
                END
                ELSE
                BEGIN
                    SET @sql = N'EXEC ' + QUOTENAME(@ProcSchema) + N'.' + QUOTENAME(@ProcName) + N';';
                    EXEC sys.sp_executesql @sql;
                END

                /* Fast rowcount (no scans) */
                IF @TgtSchema IS NOT NULL AND @TgtTable IS NOT NULL
                BEGIN
                    SELECT @TotalRows = SUM(ps.row_count)
                    FROM sys.dm_db_partition_stats ps
                    WHERE ps.object_id = OBJECT_ID(CONCAT(@TgtSchema, '.', @TgtTable))
                      AND ps.index_id IN (0,1);
                END

                SET @StepEndUTC = SYSUTCDATETIME();

                DECLARE @RowsToLog bigint =
                    CASE
                        WHEN @HasRowsDelta  = 1 THEN @RowsDelta
                        WHEN @HasRowsLoaded = 1 THEN @RowsLoaded
                        ELSE @TotalRows
                    END;

                IF @RowsToLog IS NULL SET @RowsToLog = 0;

                DECLARE @RowsToLogInt int =
                    CASE WHEN @RowsToLog > 2147483647 THEN 2147483647 ELSE CONVERT(int, @RowsToLog) END;

                DECLARE @Notes nvarchar(4000) =
                    CONCAT(
                        COALESCE(CONCAT(@TgtSchema, '.', @TgtTable, ' '), ''),
                        'rows=', COALESCE(CONVERT(varchar(30), @TotalRows), 'NULL'),
                        CASE WHEN @HasRowsDelta = 1 THEN CONCAT('; delta=', @RowsDelta) ELSE '' END,
                        CASE WHEN @HasRowsLoaded = 1 THEN CONCAT('; loaded=', @RowsLoaded) ELSE '' END,
                        '; durSec=', DATEDIFF(SECOND, @StepStartUTC, @StepEndUTC)
                    );

                UPDATE etl.RunLogDetail
                SET EndTime      = SYSDATETIME(),
                    EndedAtUTC   = @StepEndUTC,
                    Status       = 'Succeeded',
                    RowsAffected = @RowsToLogInt,
                    Notes        = @Notes
                WHERE RunDetailId = @RunDetailId;
            END TRY
            BEGIN CATCH
                SET @Err = LEFT(CONCAT(
                    'Error ', ERROR_NUMBER(), ' (', ERROR_SEVERITY(), '/', ERROR_STATE(), ') at line ',
                    ERROR_LINE(), ': ', ERROR_MESSAGE()
                ), 2048);

                UPDATE etl.RunLogDetail
                SET EndTime    = SYSDATETIME(),
                    EndedAtUTC = SYSUTCDATETIME(),
                    Status     = 'Failed',
                    Notes      = COALESCE(Notes + '; ', '') + @Err
                WHERE RunDetailId = @RunDetailId;

                UPDATE etl.RunLog
                SET EndTime      = SYSDATETIME(),
                    EndedAtUTC   = SYSUTCDATETIME(),
                    Status       = 'Failed',
                    ErrorMessage = @Err
                WHERE RunId = @RunId;

                THROW;
            END CATCH

            FETCH NEXT FROM c INTO @StepOrder, @ProcSchema, @ProcName, @ObjectName, @TgtSchema, @TgtTable;
        END

        CLOSE c;
        DEALLOCATE c;

        UPDATE etl.RunLog
        SET EndTime      = SYSDATETIME(),
            EndedAtUTC   = SYSUTCDATETIME(),
            Status       = 'Succeeded',
            ErrorMessage = NULL
        WHERE RunId = @RunId;

        /* Always release applock on success */
        EXEC sys.sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';

        RETURN 0;
    END TRY
    BEGIN CATCH
        /* Always release applock on failure too */
        EXEC sys.sp_releaseapplock @Resource = @AppLockResource, @LockOwner = N'Session';
        THROW;
    END CATCH
END
