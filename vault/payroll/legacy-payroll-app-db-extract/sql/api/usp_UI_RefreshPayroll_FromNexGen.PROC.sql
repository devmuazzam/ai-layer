
CREATE   PROCEDURE api.usp_UI_RefreshPayroll_FromNexGen
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
        /* Step 1: refresh RawFMS from FCC NexGen */
        SELECT @RawBefore = ISNULL(MAX(RunId), 0)
        FROM TCG_RawFMS.etl.RunLog;

        EXEC TCG_RawFMS.etl.usp_RunNightly_RawFMS;

        SELECT TOP (1)
            @RawRunId = RunId,
            @RawStatus = Status
        FROM TCG_RawFMS.etl.RunLog
        WHERE RunId > @RawBefore
        ORDER BY RunId DESC;

        IF @RawRunId IS NULL
        BEGIN
            SELECT TOP (1)
                @RawRunId = RunId,
                @RawStatus = Status
            FROM TCG_RawFMS.etl.RunLog
            ORDER BY RunId DESC;
        END;

        UPDATE etl.UIRefreshLog
        SET
            RawFMS_RunId = @RawRunId,
            RawFMS_Status = @RawStatus
        WHERE UIRefreshID = @UIRefreshID;

        IF ISNULL(@RawStatus, '') <> 'Succeeded'
        BEGIN
            SET @Msg = CONCAT(
                'RawFMS refresh did not succeed. RawFMS RunId=',
                COALESCE(CONVERT(varchar(20), @RawRunId), 'NULL'),
                ', Status=',
                COALESCE(@RawStatus, 'NULL'),
                '. PayrollAPP recalculation was not started.'
            );

            UPDATE etl.UIRefreshLog
            SET
                EndedAtUTC = SYSUTCDATETIME(),
                Status = CASE WHEN @RawStatus = 'Skipped' THEN 'Skipped' ELSE 'Failed' END,
                Message = @Msg
            WHERE UIRefreshID = @UIRefreshID;

            EXEC sys.sp_releaseapplock
                  @Resource = N'api.usp_UI_RefreshPayroll_FromNexGen'
                , @LockOwner = N'Session';

            SELECT *
            FROM etl.UIRefreshLog
            WHERE UIRefreshID = @UIRefreshID;

            RETURN 0;
        END;

        /* Step 2: recalculate PayrollAPP using cfg.Nightly_RunSettings = 210 days */
        SELECT @PayrollBefore = ISNULL(MAX(RunId), 0)
        FROM etl.RunLog;

        EXEC etl.usp_RunNightly_PayrollAPP @RebuildAll = 0;

        SELECT TOP (1)
            @PayrollRunId = RunId,
            @PayrollStatus = Status
        FROM etl.RunLog
        WHERE RunId > @PayrollBefore
          AND RunType = 'NightlyPayroll'
        ORDER BY RunId DESC;

        IF @PayrollRunId IS NULL
        BEGIN
            SELECT TOP (1)
                @PayrollRunId = RunId,
                @PayrollStatus = Status
            FROM etl.RunLog
            WHERE RunType = 'NightlyPayroll'
            ORDER BY RunId DESC;
        END;

        UPDATE etl.UIRefreshLog
        SET
            PayrollAPP_RunId = @PayrollRunId,
            PayrollAPP_Status = @PayrollStatus
        WHERE UIRefreshID = @UIRefreshID;

        IF ISNULL(@PayrollStatus, '') <> 'Succeeded'
        BEGIN
            SET @Msg = CONCAT(
                'PayrollAPP recalculation did not succeed. PayrollAPP RunId=',
                COALESCE(CONVERT(varchar(20), @PayrollRunId), 'NULL'),
                ', Status=',
                COALESCE(@PayrollStatus, 'NULL'),
                '.'
            );

            UPDATE etl.UIRefreshLog
            SET
                EndedAtUTC = SYSUTCDATETIME(),
                Status = CASE WHEN @PayrollStatus = 'Skipped' THEN 'Skipped' ELSE 'Failed' END,
                Message = @Msg
            WHERE UIRefreshID = @UIRefreshID;

            EXEC sys.sp_releaseapplock
                  @Resource = N'api.usp_UI_RefreshPayroll_FromNexGen'
                , @LockOwner = N'Session';

            SELECT *
            FROM etl.UIRefreshLog
            WHERE UIRefreshID = @UIRefreshID;

            RETURN 0;
        END;

        SET @Msg = CONCAT(
            'Refresh succeeded. RawFMS RunId=',
            @RawRunId,
            '; PayrollAPP RunId=',
            @PayrollRunId,
            '.'
        );

        UPDATE etl.UIRefreshLog
        SET
            EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            Message = @Msg
        WHERE UIRefreshID = @UIRefreshID;

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
