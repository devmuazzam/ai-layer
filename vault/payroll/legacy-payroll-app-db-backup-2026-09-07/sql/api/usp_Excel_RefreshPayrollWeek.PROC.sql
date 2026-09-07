CREATE   PROCEDURE api.usp_Excel_RefreshPayrollWeek
    @PayStartDate date,
    @PayEndDate   date
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    /* ========================================================
       1 - VALIDATION
       ======================================================== */

    IF @PayStartDate IS NULL
        THROW 52300,
            'PayStartDate is required.',
            1;

    IF @PayEndDate IS NULL
        THROW 52301,
            'PayEndDate is required.',
            1;

    IF @PayEndDate < @PayStartDate
        THROW 52302,
            'PayEndDate cannot be earlier than PayStartDate.',
            1;


    /* ========================================================
       2 - PREVENT OVERLAPPING EXCEL PAYROLL REFRESHES

       This lock is separate from:
         - RawFMS refresh lock
         - PayrollAPP nightly calculation lock

       It controls the complete Excel-triggered workflow.
       ======================================================== */

    DECLARE
        @LockResult int,
        @HaveLock   bit = 0;

    EXEC @LockResult = sys.sp_getapplock
        @Resource    = N'api.usp_Excel_RefreshPayrollWeek',
        @LockMode    = N'Exclusive',
        @LockOwner   = N'Session',
        @LockTimeout = 0;

    IF @LockResult < 0
    BEGIN
        THROW 52303,
            'Another Excel payroll refresh is already running.',
            1;
    END;

    SET @HaveLock = 1;


    BEGIN TRY

        DECLARE
            @WorkflowStartedUTC datetime2(3) =
                SYSUTCDATETIME(),

            @RawFMSRunId int = NULL,

            @BeforeNightlyRunId int = 0,

            @PayrollAppRunId int = NULL,

            @ResolvedRunId int = NULL,

            @PayrollStatus varchar(30) = NULL,

            @PayrollError nvarchar(4000) = NULL;


                /* ====================================================
           3 - RUN SHARED INTERACTIVE PAYROLL REFRESH CORE

           The shared core owns:

             - shared Web / Excel interactive workflow lock
             - targeted payroll RawFMS refresh
             - exact RawFMS RunId
             - prior-period context freshness validation
             - exact Saturday-Friday PayrollAPP recalculation
             - exact PayrollAPP RunId
             - authoritative-run validation

           Excel no longer independently launches RawFMS,
           searches for a newer PayrollAPP RunId, or invokes the
           configured broad PayrollAPP calculation.
           ==================================================== */

        SET @RawFMSRunId =
            NULL;

        SET @PayrollAppRunId =
            NULL;

        SET @PayrollStatus =
            NULL;

        SET @ResolvedRunId =
            NULL;


        EXEC api.usp_RefreshPayrollWeek_Core
              @PayStartDate =
                  @PayStartDate

            , @PayEndDate =
                  @PayEndDate

            , @RawFMSRunId =
                  @RawFMSRunId OUTPUT

            , @PayrollAppRunId =
                  @PayrollAppRunId OUTPUT

            , @PayrollAppStatus =
                  @PayrollStatus OUTPUT;


        IF @RawFMSRunId IS NULL
        BEGIN
            THROW 52304,
                'Shared payroll refresh did not return a RawFMS RunId.',
                1;
        END;


        IF @PayrollAppRunId IS NULL
        BEGIN
            THROW 52305,
                'Shared payroll refresh did not return a PayrollAPP RunId.',
                1;
        END;


        IF ISNULL(@PayrollStatus,'') <> 'Succeeded'
        BEGIN
            THROW 52306,
                'Shared payroll refresh returned a non-successful PayrollAPP status.',
                1;
        END;


        /*
           The shared core already requires this exact PayrollAPP
           RunId to pass authoritative-run validation.
        */

        SET @ResolvedRunId =
            @PayrollAppRunId;


/* ====================================================
           8 - RETURN ONE CLEAN RESULT SET TO EXCEL
           ==================================================== */

        SELECT
            PayStartDate =
                @PayStartDate,

            PayEndDate =
                @PayEndDate,

            RawFMSRunId =
                @RawFMSRunId,

            PayrollAppRunId =
                r.RunId,

            PayrollAppRunStatus =
                r.Status,

            PayrollAppWorkDateFrom =
                r.WorkDateFrom,

            PayrollAppWorkDateTo =
                r.WorkDateTo,

            PayrollAppRunStartedUTC =
                r.StartedAtUTC,

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

            WorkflowStartedUTC =
                @WorkflowStartedUTC,

            WorkflowCompletedUTC =
                SYSUTCDATETIME()

        FROM etl.RunLog r

        WHERE r.RunId =
            @PayrollAppRunId;


        /* ====================================================
           9 - RELEASE EXCEL WORKFLOW LOCK
           ==================================================== */

        IF @HaveLock = 1
        BEGIN
            EXEC sys.sp_releaseapplock
                @Resource =
                    N'api.usp_Excel_RefreshPayrollWeek',
                @LockOwner =
                    N'Session';

            SET @HaveLock = 0;
        END;

    END TRY

    BEGIN CATCH

        IF @HaveLock = 1
        BEGIN
            EXEC sys.sp_releaseapplock
                @Resource =
                    N'api.usp_Excel_RefreshPayrollWeek',
                @LockOwner =
                    N'Session';
        END;

        THROW;

    END CATCH;
END;

