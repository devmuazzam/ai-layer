
CREATE   PROCEDURE test.usp_Test_RestPeriod_SliceChain_Prototype
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#R') IS NOT NULL DROP TABLE #R;

    CREATE TABLE #R
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

    ------------------------------------------------------------
    -- 1) Weekday rest-chain DT uplift:
    --    production should now match prototype.
    ------------------------------------------------------------
    INSERT INTO #R
    EXEC app.usp_Prototype_RestPeriod_SliceChain
          @WorkDateFrom = '2026-04-08'
        , @WorkDateTo = '2026-04-08'
        , @EmpID = '2258'
        , @LaborPayrollID = 82281
        , @IncludeNonForced = 0
        , @OutputMode = 'Rollup';

    IF NOT EXISTS
    (
        SELECT 1
        FROM #R
        WHERE LaborPayrollID = 82281
          AND RestForced = 1
          AND PrototypeRestPremiumAdd > 300
          AND CurrentPayRestAdd > 300
          AND ABS(ISNULL(DifferenceVsCurrentRestAdd, 0)) <= 0.05
    )
        THROW 51000, 'FAIL: 2258 / 82281 production rest-chain DT uplift does not match prototype.', 1;

    TRUNCATE TABLE #R;

    ------------------------------------------------------------
    -- 2) Sunday premium already satisfies rest-chain DT floor.
    ------------------------------------------------------------
    INSERT INTO #R
    EXEC app.usp_Prototype_RestPeriod_SliceChain
          @WorkDateFrom = '2026-04-19'
        , @WorkDateTo = '2026-04-19'
        , @EmpID = '2934'
        , @LaborPayrollID = 82980
        , @IncludeNonForced = 0
        , @OutputMode = 'Rollup';

    IF NOT EXISTS
    (
        SELECT 1
        FROM #R
        WHERE LaborPayrollID = 82980
          AND RestForced = 1
          AND ABS(ISNULL(CurrentPayRestAdd, 0)) <= 0.05
          AND ABS(ISNULL(PrototypeRestPremiumAdd, 0)) <= 0.05
          AND ABS(ISNULL(DifferenceVsCurrentRestAdd, 0)) <= 0.05
    )
        THROW 51000, 'FAIL: 2934 / 82980 Sunday rest-chain floor behavior did not validate.', 1;

    TRUNCATE TABLE #R;

    ------------------------------------------------------------
    -- 3) Special Saturday premium already satisfies rest-chain DT floor.
    ------------------------------------------------------------
    INSERT INTO #R
    EXEC app.usp_Prototype_RestPeriod_SliceChain
          @WorkDateFrom = '2025-12-06'
        , @WorkDateTo = '2025-12-06'
        , @EmpID = '8600'
        , @LaborPayrollID = 74070
        , @IncludeNonForced = 0
        , @OutputMode = 'Rollup';

    IF NOT EXISTS
    (
        SELECT 1
        FROM #R
        WHERE LaborPayrollID = 74070
          AND RestForced = 1
          AND ABS(ISNULL(CurrentPayRestAdd, 0)) <= 0.05
          AND ABS(ISNULL(PrototypeRestPremiumAdd, 0)) <= 0.05
          AND ABS(ISNULL(DifferenceVsCurrentRestAdd, 0)) <= 0.05
    )
        THROW 51000, 'FAIL: 8600 / 74070 Special Saturday rest-chain floor behavior did not validate.', 1;

    TRUNCATE TABLE #R;

    ------------------------------------------------------------
    -- 4) Fallback-rate row:
    --    raw slice rate is zero, production should now match prototype.
    ------------------------------------------------------------
    INSERT INTO #R
    EXEC app.usp_Prototype_RestPeriod_SliceChain
          @WorkDateFrom = '2026-04-23'
        , @WorkDateTo = '2026-04-23'
        , @EmpID = '8305'
        , @LaborPayrollID = 83429
        , @IncludeNonForced = 0
        , @OutputMode = 'Rollup';

    IF NOT EXISTS
    (
        SELECT 1
        FROM #R
        WHERE LaborPayrollID = 83429
          AND RestForced = 1
          AND PrototypeRestPremiumAdd > 80
          AND CurrentPayRestAdd > 80
          AND ABS(ISNULL(DifferenceVsCurrentRestAdd, 0)) <= 0.05
    )
        THROW 51000, 'FAIL: 8305 / 83429 fallback-rate production rest-chain behavior does not match prototype.', 1;

    SELECT 'PASS: test.usp_Test_RestPeriod_SliceChain_Prototype' AS Result;
END;
