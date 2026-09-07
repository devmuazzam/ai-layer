      @AnyDateInWeek date
    , @RequestedBy   sysname = NULL
    , @AllowProcessed bit = 0
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @UIRefreshID bigint,
        @LockResult int,
        @Msg nvarchar(4000),
        @RawBefore int,
        @RawRunId int,
        @RawStatus varchar(30),
        @PayrollBefore int,
        @PayrollRunId int,
        @PayrollStatus varchar(30),
        @PeriodStartDate date,
        @PeriodEndDate date;

    IF @AnyDateInWeek IS NULL
        THROW 52000, '@AnyDateInWeek is required.', 1;

    IF @RequestedBy IS NULL
        SET @RequestedBy = ORIGINAL_LOGIN();

    /* Canonical Saturday-Friday payroll period, anchored to known Saturday 2020-01-04 */
    DECLARE @Offset int =
        ((DATEDIFF(DAY, CONVERT(date, '20200104'), @AnyDateInWeek) % 7) + 7) % 7;

    SET @PeriodStartDate = DATEADD(DAY, -@Offset, @AnyDateInWeek);
    SET @PeriodEndDate   = DATEADD(DAY, 6, @PeriodStartDate);

    INSERT INTO etl.UIRefreshLog
    (
        StartedAtUTC,
        RequestedBy,
        AnyDateInWeek,
        PeriodStartDate,
        PeriodEndDate,
        Status,
        Message,
        HostName,
        AppName,
        LoginName
    )
    VALUES
    (
        SYSUTCDATETIME(),
        @RequestedBy,
        @AnyDateInWeek,
        @PeriodStartDate,
        @PeriodEndDate,
        'Running',
        'Refresh requested from Payroll UI.',
        HOST_NAME(),
        APP_NAME(),
        ORIGINAL_LOGIN()
    );

    SET @UIRefreshID = SCOPE_IDENTITY();

    /* Block processed pay periods unless explicitly allowed */
    IF @AllowProcessed = 0
       AND EXISTS
       (
            SELECT 1
            FROM app.PayPeriod
            WHERE PeriodStartDate = @PeriodStartDate
              AND Status = 'Processed'
       )
    BEGIN
        SET @Msg = CONCAT(
            'Refresh blocked. Pay period ',
            CONVERT(varchar(10), @PeriodStartDate, 120),
            ' through ',
            CONVERT(varchar(10), @PeriodEndDate, 120),
            ' is already Processed.'
        );

        UPDATE etl.UIRefreshLog
        SET
            EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Blocked',
            Message = @Msg
        WHERE UIRefreshID = @UIRefreshID;

        SELECT *
        FROM etl.UIRefreshLog
        WHERE UIRefreshID = @UIRefreshID;

        RETURN 0;
    END;

    /* Top-level browser refresh lock */
    EXEC @LockResult = sys.sp_getapplock
          @Resource = N'api.usp_UI_RefreshPayroll_FromNexGen'
        , @LockMode = N'Exclusive'
        , @LockOwner = N'Session'
        , @LockTimeout = 0;

    IF @LockResult < 0
    BEGIN
        UPDATE etl.UIRefreshLog
        SET
            EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Skipped',
            Message = 'Another Payroll UI refresh is already running.'
        WHERE UIRefreshID = @UIRefreshID;

        SELECT *
        FROM etl.UIRefreshLog
        WHERE UIRefreshID = @UIRefreshID;

        RETURN 0;
    END;

    BEGIN TRY
                /*
          Steps 1-3: shared interactive payroll refresh

          The shared core owns:
            - shared Web/Excel workflow lock
            - targeted payroll RawFMS refresh
            - exact RawFMS RunId
            - prior-context freshness validation
            - exact Saturday-Friday PayrollAPP recalculation
            - exact PayrollAPP RunId
            - authoritative-run validation
        */

        SET @RawRunId = NULL;
        SET @RawStatus = NULL;
        SET @PayrollRunId = NULL;
        SET @PayrollStatus = NULL;


        EXEC api.usp_RefreshPayrollWeek_Core
              @PayStartDate =
                  @PeriodStartDate
            , @PayEndDate =
                  @PeriodEndDate
            , @RawFMSRunId =
                  @RawRunId OUTPUT
            , @PayrollAppRunId =
                  @PayrollRunId OUTPUT
            , @RawFMSStatus =
                  @RawStatus OUTPUT
            , @PayrollAppStatus =
                  @PayrollStatus OUTPUT;


        /*
          The shared core does not return successfully unless
          both underlying runs succeeded and the exact PayrollAPP
          run passed authoritative-run validation.
        */

        SET @Msg =
            CONCAT
            (
                'Refresh succeeded. RawFMS RunId=',
                @RawRunId,
                '; PayrollAPP RunId=',
                @PayrollRunId,
                '.'
            );


        UPDATE etl.UIRefreshLog
        SET
            RawFMS_RunId =
                @RawRunId,

            RawFMS_Status =
                @RawStatus,

            PayrollAPP_RunId =
                @PayrollRunId,

            PayrollAPP_Status =
                @PayrollStatus,

            EndedAtUTC =
                SYSUTCDATETIME(),

            Status =
                'Succeeded',

            Message =
                @Msg

        WHERE UIRefreshID =
              @UIRefreshID;


        EXEC sys.sp_releaseapplock
              @Resource = N'api.usp_UI_RefreshPayroll_FromNexGen'
            , @LockOwner = N'Session';

        SELECT *
        FROM etl.UIRefreshLog
        WHERE UIRefreshID = @UIRefreshID;

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @Msg = CONCAT(
            'Error ',
            ERROR_NUMBER(),
            ' in ',
            COALESCE(ERROR_PROCEDURE(), '<unknown>'),
            ' at line ',
            ERROR_LINE(),
            ': ',
            ERROR_MESSAGE()
        );

        UPDATE etl.UIRefreshLog
        SET
            EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Failed',
            Message = @Msg
        WHERE UIRefreshID = @UIRefreshID;

        EXEC sys.sp_releaseapplock
              @Resource = N'api.usp_UI_RefreshPayroll_FromNexGen'
            , @LockOwner = N'Session';

        THROW;
    END CATCH;
END;

