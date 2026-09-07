      @PayStartDate       date
    , @PayEndDate         date
    , @RawFMSRunId        int = NULL OUTPUT
    , @PayrollAppRunId    int = NULL OUTPUT
    , @RawFMSStatus       varchar(30) = NULL OUTPUT
    , @PayrollAppStatus   varchar(30) = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -------------------------------------------------------------------------
    -- Initialize outputs
    -------------------------------------------------------------------------
    SET @RawFMSRunId      = NULL;
    SET @PayrollAppRunId  = NULL;
    SET @RawFMSStatus     = NULL;
    SET @PayrollAppStatus = NULL;


    -------------------------------------------------------------------------
    -- Validate exact Saturday-Friday payroll period
    -------------------------------------------------------------------------
    IF @PayStartDate IS NULL
    BEGIN
        THROW 53360,
            'PayStartDate is required.',
            1;
    END;


    IF @PayEndDate IS NULL
    BEGIN
        THROW 53361,
            'PayEndDate is required.',
            1;
    END;


    IF @PayEndDate < @PayStartDate
    BEGIN
        THROW 53362,
            'PayEndDate cannot be earlier than PayStartDate.',
            1;
    END;


    IF DATEDIFF(DAY,@PayStartDate,@PayEndDate) <> 6
    BEGIN
        THROW 53363,
            'Interactive payroll refresh must cover exactly seven calendar days.',
            1;
    END;


    DECLARE @SaturdayOffset int =
        (
            (
                DATEDIFF
                (
                    DAY,
                    CONVERT(date,'20200104'),
                    @PayStartDate
                ) % 7
            ) + 7
        ) % 7;


    IF @SaturdayOffset <> 0
    BEGIN
        THROW 53364,
            'Interactive payroll refresh must begin on Saturday.',
            1;
    END;


    -------------------------------------------------------------------------
    -- Shared user-facing refresh lock
    --
    -- Both Web and Excel will ultimately enter through this same lock.
    -------------------------------------------------------------------------
    DECLARE
        @LockResult int,
        @HaveLock bit = 0;


    EXEC @LockResult =
        sys.sp_getapplock
          @Resource =
              N'api.PayrollInteractiveRefresh'
        , @LockMode =
              N'Exclusive'
        , @LockOwner =
              N'Session'
        , @LockTimeout =
              0;


    IF @LockResult < 0
    BEGIN
        THROW 53365,
            'Another interactive payroll refresh is already running.',
            1;
    END;


    SET @HaveLock = 1;


    BEGIN TRY

        ---------------------------------------------------------------------
        -- STEP 1 - Targeted Payroll RawFMS refresh
        --
        -- Capture the exact RunId directly from the RawFMS wrapper.
        ---------------------------------------------------------------------
        EXEC TCG_RawFMS.etl.usp_Refresh_Payroll_Interactive
              @RunId =
                  @RawFMSRunId OUTPUT;


        IF @RawFMSRunId IS NULL
        BEGIN
            THROW 53366,
                'Payroll RawFMS refresh did not return a RunId.',
                1;
        END;


        SELECT
            @RawFMSStatus =
                r.Status

        FROM TCG_RawFMS.etl.RunLog r

        WHERE r.RunId =
              @RawFMSRunId

          AND r.RunType =
              'PayrollInteractiveRawFMS';


        IF @RawFMSStatus IS NULL
        BEGIN
            THROW 53367,
                'Returned RawFMS RunId is not a PayrollInteractiveRawFMS run.',
                1;
        END;


        IF @RawFMSStatus <> 'Succeeded'
        BEGIN
            DECLARE @RawFailure nvarchar(2048);

            SET @RawFailure =
                LEFT
                (
                    CONCAT
                    (
                        'Payroll RawFMS refresh did not succeed. RunId=',
                        @RawFMSRunId,
                        '; Status=',
                        COALESCE(@RawFMSStatus,'NULL'),
                        '.'
                    ),
                    2048
                );

            THROW 53368,
                @RawFailure,
                1;
        END;


        ---------------------------------------------------------------------
        -- STEP 2 - Exact requested Saturday-Friday PayrollAPP calculation
        --
        -- The prior payroll week remains read-only history/context.
        -- The orchestrator freshness guard blocks execution if that context
        -- is stale or eligible prior labor is missing.
        ---------------------------------------------------------------------
        EXEC etl.usp_RunNightly_PayrollAPP
              @RebuildAll =
                  0
            , @WorkDateFromOverride =
                  @PayStartDate
            , @WorkDateToOverride =
                  @PayEndDate
            , @RequireFreshPriorContext =
                  1
            , @CreatedRunId =
                  @PayrollAppRunId OUTPUT;


        IF @PayrollAppRunId IS NULL
        BEGIN
            THROW 53369,
                'PayrollAPP calculation did not return a RunId.',
                1;
        END;


        SELECT
            @PayrollAppStatus =
                r.Status

        FROM etl.RunLog r

        WHERE r.RunId =
              @PayrollAppRunId

          AND r.RunType =
              'NightlyPayroll'

          AND r.WorkDateFrom =
              @PayStartDate

          AND r.WorkDateTo =
              @PayEndDate;


        IF @PayrollAppStatus IS NULL
        BEGIN
            THROW 53370,
                'Returned PayrollAPP RunId does not have the exact requested 7-day window.',
                1;
        END;


        IF @PayrollAppStatus <> 'Succeeded'
        BEGIN
            DECLARE @PayrollFailure nvarchar(2048);

            SELECT
                @PayrollFailure =
                    LEFT
                    (
                        CONCAT
                        (
                            'PayrollAPP refresh did not succeed. RunId=',
                            r.RunId,
                            '; Status=',
                            COALESCE(r.Status,'NULL'),
                            '; Error=',
                            COALESCE(r.ErrorMessage,'NULL'),
                            '.'
                        ),
                        2048
                    )

            FROM etl.RunLog r

            WHERE r.RunId =
                  @PayrollAppRunId;


            THROW 53371,
                @PayrollFailure,
                1;
        END;


        ---------------------------------------------------------------------
        -- STEP 3 - Require this exact run to resolve as authoritative
        ---------------------------------------------------------------------
        DECLARE @ResolvedRunId int = NULL;


        EXEC api.usp_ResolveAuthoritativePayrollRun
              @PayStartDate =
                  @PayStartDate
            , @PayEndDate =
                  @PayEndDate
            , @RequestedRunId =
                  @PayrollAppRunId
            , @ResolvedRunId =
                  @ResolvedRunId OUTPUT;


        IF @ResolvedRunId <> @PayrollAppRunId
        BEGIN
            THROW 53372,
                'Exact PayrollAPP RunId failed authoritative-run validation.',
                1;
        END;


        ---------------------------------------------------------------------
        -- Release shared interactive workflow lock
        ---------------------------------------------------------------------
        EXEC sys.sp_releaseapplock
              @Resource =
                  N'api.PayrollInteractiveRefresh'
            , @LockOwner =
                  N'Session';


        SET @HaveLock = 0;


        RETURN 0;

    END TRY

    BEGIN CATCH

        IF @HaveLock = 1
        BEGIN
            EXEC sys.sp_releaseapplock
                  @Resource =
                      N'api.PayrollInteractiveRefresh'
                , @LockOwner =
                      N'Session';

            SET @HaveLock = 0;
        END;


        THROW;

    END CATCH;

END;

