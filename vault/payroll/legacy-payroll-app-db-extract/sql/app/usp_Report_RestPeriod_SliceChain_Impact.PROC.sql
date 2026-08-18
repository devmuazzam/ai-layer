
CREATE   PROCEDURE app.usp_Report_RestPeriod_SliceChain_Impact
      @WorkDateFrom     date
    , @WorkDateTo       date
    , @EmpID            varchar(50) = NULL
    , @IncludeNonForced bit = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @WorkDateFrom IS NULL OR @WorkDateTo IS NULL
        THROW 51000, '@WorkDateFrom and @WorkDateTo are required.', 1;

    IF @WorkDateTo < @WorkDateFrom
        THROW 51000, '@WorkDateTo must be >= @WorkDateFrom.', 1;

    IF OBJECT_ID('tempdb..#RestImpact') IS NOT NULL DROP TABLE #RestImpact;

    CREATE TABLE #RestImpact
    (
        EmpID varchar(50) NULL,
        Employee_Name varchar(200) NULL,
        WorkDate datetime2(7) NULL,
        LaborPayrollID int NULL,
        JobTicketID int NULL,
        JobCode varchar(50) NULL,
        RestForced int NULL,
        MinRestChainHoursBeforeSlice decimal(10,2) NULL,
        MaxRestChainHoursBeforeSlice decimal(10,2) NULL,
        SliceHours decimal(10,2) NULL,
        NormalSlicePay decimal(19,4) NULL,
        PrototypeAdjustedSlicePay decimal(19,4) NULL,
        PrototypeRestPremiumAdd decimal(19,4) NULL,
        CurrentPayRestAdd decimal(19,4) NULL,
        DifferenceVsCurrentRestAdd decimal(19,4) NULL,
        CurrentRestPremiumHrs decimal(10,2) NULL
    );

    INSERT INTO #RestImpact
    EXEC app.usp_Prototype_RestPeriod_SliceChain
          @WorkDateFrom = @WorkDateFrom
        , @WorkDateTo = @WorkDateTo
        , @EmpID = @EmpID
        , @IncludeNonForced = @IncludeNonForced
        , @OutputMode = 'Rollup';

    ------------------------------------------------------------
    -- Result set 1: overall summary
    ------------------------------------------------------------
    SELECT
        @WorkDateFrom AS WorkDateFrom,
        @WorkDateTo AS WorkDateTo,
        COUNT(*) AS [RowCount],
        COUNT(DISTINCT EmpID) AS EmployeeCount,
        SUM(SliceHours) AS TotalSliceHours,
        SUM(CurrentPayRestAdd) AS CurrentPayRestAddTotal,
        SUM(PrototypeRestPremiumAdd) AS PrototypeRestPremiumAddTotal,
        SUM(DifferenceVsCurrentRestAdd) AS NetDifference,
        SUM(CASE WHEN ABS(DifferenceVsCurrentRestAdd) <= 0.01 THEN 1 ELSE 0 END) AS NearMatchRows,
        SUM(CASE WHEN DifferenceVsCurrentRestAdd > 0.01 THEN 1 ELSE 0 END) AS PrototypeHigherRows,
        SUM(CASE WHEN DifferenceVsCurrentRestAdd < -0.01 THEN 1 ELSE 0 END) AS PrototypeLowerRows
    FROM #RestImpact;

    ------------------------------------------------------------
    -- Result set 2: impact buckets
    ------------------------------------------------------------
    SELECT
        CASE
            WHEN ABS(DifferenceVsCurrentRestAdd) <= 0.01
                THEN 'Near match / rounding only'
            WHEN PrototypeRestPremiumAdd > 0
             AND CurrentPayRestAdd = 0
                THEN 'New prototype rest premium where current has zero'
            WHEN PrototypeRestPremiumAdd > CurrentPayRestAdd
                THEN 'Prototype higher than current'
            WHEN PrototypeRestPremiumAdd = 0
             AND CurrentPayRestAdd > 0
                THEN 'Current has rest add but prototype is zero'
            WHEN PrototypeRestPremiumAdd < CurrentPayRestAdd
                THEN 'Prototype lower than current'
            ELSE 'Other'
        END AS ImpactBucket,
        COUNT(*) AS [RowCount],
        COUNT(DISTINCT EmpID) AS EmployeeCount,
        SUM(SliceHours) AS SliceHours,
        SUM(CurrentPayRestAdd) AS CurrentPayRestAddTotal,
        SUM(PrototypeRestPremiumAdd) AS PrototypeRestPremiumAddTotal,
        SUM(DifferenceVsCurrentRestAdd) AS NetDifference
    FROM #RestImpact
    GROUP BY
        CASE
            WHEN ABS(DifferenceVsCurrentRestAdd) <= 0.01
                THEN 'Near match / rounding only'
            WHEN PrototypeRestPremiumAdd > 0
             AND CurrentPayRestAdd = 0
                THEN 'New prototype rest premium where current has zero'
            WHEN PrototypeRestPremiumAdd > CurrentPayRestAdd
                THEN 'Prototype higher than current'
            WHEN PrototypeRestPremiumAdd = 0
             AND CurrentPayRestAdd > 0
                THEN 'Current has rest add but prototype is zero'
            WHEN PrototypeRestPremiumAdd < CurrentPayRestAdd
                THEN 'Prototype lower than current'
            ELSE 'Other'
        END
    ORDER BY
        ABS(SUM(DifferenceVsCurrentRestAdd)) DESC;

    ------------------------------------------------------------
    -- Result set 3: employee summary
    ------------------------------------------------------------
    SELECT
        EmpID,
        Employee_Name,
        COUNT(*) AS [RowCount],
        SUM(SliceHours) AS SliceHours,
        SUM(CurrentPayRestAdd) AS CurrentPayRestAddTotal,
        SUM(PrototypeRestPremiumAdd) AS PrototypeRestPremiumAddTotal,
        SUM(DifferenceVsCurrentRestAdd) AS NetDifference
    FROM #RestImpact
    GROUP BY
        EmpID,
        Employee_Name
    ORDER BY
        ABS(SUM(DifferenceVsCurrentRestAdd)) DESC,
        EmpID;

    ------------------------------------------------------------
    -- Result set 4: labor-entry detail
    ------------------------------------------------------------
    SELECT
        EmpID,
        Employee_Name,
        WorkDate,
        LaborPayrollID,
        JobTicketID,
        JobCode,
        RestForced,
        MinRestChainHoursBeforeSlice,
        MaxRestChainHoursBeforeSlice,
        SliceHours,
        CurrentRestPremiumHrs,
        CurrentPayRestAdd,
        PrototypeRestPremiumAdd,
        DifferenceVsCurrentRestAdd
    FROM #RestImpact
    ORDER BY
        ABS(DifferenceVsCurrentRestAdd) DESC,
        EmpID,
        WorkDate,
        LaborPayrollID;
END;
