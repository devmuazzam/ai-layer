    @PayEndDate     date,
    @RequestedRunId int = NULL,
    @ResolvedRunId  int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -------------------------------------------------------------------------
    -- Initialize output
    -------------------------------------------------------------------------
    SET @ResolvedRunId = NULL;

    -------------------------------------------------------------------------
    -- Validate requested payroll period
    -------------------------------------------------------------------------
    IF @PayStartDate IS NULL
    BEGIN
        THROW 52000,
            'PayStartDate is required.',
            1;
    END;

    IF @PayEndDate IS NULL
    BEGIN
        THROW 52001,
            'PayEndDate is required.',
            1;
    END;

    IF @PayEndDate < @PayStartDate
    BEGIN
        THROW 52002,
            'PayEndDate must be greater than or equal to PayStartDate.',
            1;
    END;

    -------------------------------------------------------------------------
    -- Determine how far NightlyPayroll is reasonably expected to have run.
    --
    -- NightlyPayroll processes through the prior day, so an open/current
    -- payroll period may legitimately extend beyond the available nightly
    -- processing window.
    --
    -- Example:
    --     Requested payroll period: 2026-08-08 through 2026-08-14
    --     Today:                    2026-08-13
    --     Required coverage:        through 2026-08-12
    -------------------------------------------------------------------------
    DECLARE @Today date =
        CONVERT(date, GETDATE());

    DECLARE @NightlyAvailableThrough date =
        DATEADD(DAY, -1, @Today);

    DECLARE @RequiredCoverageEnd date =
        CASE
            WHEN @PayEndDate < @NightlyAvailableThrough
                THEN @PayEndDate
            ELSE @NightlyAvailableThrough
        END;

    -------------------------------------------------------------------------
    -- Do not resolve a NightlyPayroll run for a payroll period that has not
    -- reached any date that NightlyPayroll could have processed yet.
    -------------------------------------------------------------------------
    IF @RequiredCoverageEnd < @PayStartDate
    BEGIN
        THROW 52006,
            'The requested payroll period has not yet reached a date eligible for NightlyPayroll processing.',
            1;
    END;

    -------------------------------------------------------------------------
    -- If a RunId was explicitly supplied:
    --
    -- It must be:
    --   * NightlyPayroll
    --   * Succeeded
    --   * Have a persisted work-date window
    --   * Fully cover the required processed portion of the payroll period
    --
    -- For a closed/historical period, RequiredCoverageEnd = PayEndDate.
    -- For an open/current period, RequiredCoverageEnd may be yesterday.
    -------------------------------------------------------------------------
    IF @RequestedRunId IS NOT NULL
    BEGIN
        SELECT
            @ResolvedRunId = r.RunId
        FROM etl.RunLog r
        WHERE r.RunId = @RequestedRunId
          AND r.RunType = 'NightlyPayroll'
          AND r.Status = 'Succeeded'
          AND r.WorkDateFrom IS NOT NULL
          AND r.WorkDateTo IS NOT NULL
          AND r.WorkDateFrom <= @PayStartDate
          AND r.WorkDateTo >= @RequiredCoverageEnd;

        IF @ResolvedRunId IS NULL
        BEGIN
            THROW 52003,
                'The requested RunId is not a successful NightlyPayroll run that covers the required processed portion of the payroll period.',
                1;
        END;
    END;

    -------------------------------------------------------------------------
    -- Otherwise automatically resolve the newest successful NightlyPayroll
    -- run whose persisted calculation window covers the required processed
    -- portion of the payroll period.
    -------------------------------------------------------------------------
    IF @RequestedRunId IS NULL
    BEGIN
        SELECT TOP (1)
            @ResolvedRunId = r.RunId
        FROM etl.RunLog r
        WHERE r.RunType = 'NightlyPayroll'
          AND r.Status = 'Succeeded'
          AND r.WorkDateFrom IS NOT NULL
          AND r.WorkDateTo IS NOT NULL
          AND r.WorkDateFrom <= @PayStartDate
          AND r.WorkDateTo >= @RequiredCoverageEnd
        ORDER BY
            r.EndedAtUTC DESC,
            r.RunId DESC;

        IF @ResolvedRunId IS NULL
        BEGIN
            THROW 52004,
                'No successful NightlyPayroll run covers the required processed portion of the requested payroll period.',
                1;
        END;
    END;

    -------------------------------------------------------------------------
    -- Validate that Payroll_Calculated actually contains data from the
    -- resolved RunId for the portion of the payroll period NightlyPayroll
    -- is expected to have processed.
    --
    -- This protects against selecting a RunLog header whose calculation
    -- results are no longer present.
    -------------------------------------------------------------------------
    IF NOT EXISTS
    (
        SELECT 1
        FROM fms.Payroll_Calculated pc
        WHERE pc.RunId = @ResolvedRunId
          AND pc.WorkDate >= @PayStartDate
          AND pc.WorkDate < DATEADD(DAY, 1, @RequiredCoverageEnd)
    )
    BEGIN
        SET @ResolvedRunId = NULL;

        THROW 52005,
            'The resolved NightlyPayroll run has no Payroll_Calculated rows for the required processed portion of the payroll period.',
            1;
    END;

    -------------------------------------------------------------------------
    -- Do NOT reject the run merely because historical records from other
    -- RunIds exist for the same dates.
    --
    -- Payroll_Calculated, Payroll_PayComponent, and Payroll_CalcException
    -- must instead be filtered by @ResolvedRunId by the Excel export
    -- procedure.
    -------------------------------------------------------------------------
END;

