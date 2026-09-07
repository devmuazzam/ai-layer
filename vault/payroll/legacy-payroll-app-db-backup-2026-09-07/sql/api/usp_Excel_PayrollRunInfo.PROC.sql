    @RunId int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @RunId IS NULL
        THROW 52200, 'RunId is required.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM etl.RunLog
        WHERE RunId = @RunId
          AND RunType = 'NightlyPayroll'
          AND Status = 'Succeeded'
    )
    BEGIN
        THROW 52201,
            'The requested RunId is not a successful NightlyPayroll run.',
            1;
    END;

    SELECT
        PayrollAppRun =
            r.RunId,

        PayrollAppRefreshedUTC =
            r.EndedAtUTC,

        PayrollAppRefreshedLocal =
            CAST
            (
                r.EndedAtUTC
                    AT TIME ZONE 'UTC'
                    AT TIME ZONE 'Pacific Standard Time'
                AS datetime2
            ),

        PayrollAppRunStartedUTC =
            r.StartedAtUTC,

        PayrollAppRunStatus =
            r.Status,

        PayrollAppWorkDateFrom =
            r.WorkDateFrom,

        PayrollAppWorkDateTo =
            r.WorkDateTo

    FROM etl.RunLog r
    WHERE r.RunId = @RunId;
END;

