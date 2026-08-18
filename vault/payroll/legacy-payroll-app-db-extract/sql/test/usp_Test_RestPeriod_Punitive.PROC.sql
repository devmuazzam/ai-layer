
CREATE   PROCEDURE test.usp_Test_RestPeriod_Punitive
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Existing known case:
    -- 0823 / prior LPID 76564 / return LPID 76606
    ------------------------------------------------------------
    DECLARE @CurrLaborPayrollID int = 76606;

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

    INSERT INTO #R
    EXEC app.usp_Prototype_RestPeriod_SliceChain
          @WorkDateFrom = '2026-01-22'
        , @WorkDateTo = '2026-01-22'
        , @EmpID = '0823'
        , @LaborPayrollID = @CurrLaborPayrollID
        , @IncludeNonForced = 0
        , @OutputMode = 'Rollup';

    IF NOT EXISTS
    (
        SELECT 1
        FROM fms.Payroll_Calculated pc
        WHERE pc.LaborPayrollID = @CurrLaborPayrollID
          AND ISNULL(pc.Rest_IsForced, 0) = 1
    )
        THROW 51000, 'RestPeriod punitive test failed: expected Rest_IsForced = 1 for LPID 76606.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM fms.Payroll_Calculated pc
        WHERE pc.LaborPayrollID = @CurrLaborPayrollID
          AND ISNULL(pc.Pay_Rest_Add, 0) > 0
    )
        THROW 51000, 'RestPeriod punitive test failed: expected Pay_Rest_Add > 0 for LPID 76606.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM fms.Payroll_Calculated pc
        WHERE pc.LaborPayrollID = @CurrLaborPayrollID
          AND ISNULL(pc.Rest_Premium_Hrs, 0) > 0
    )
        THROW 51000, 'RestPeriod punitive test failed: expected Rest_Premium_Hrs > 0 for LPID 76606.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM #R
        WHERE LaborPayrollID = @CurrLaborPayrollID
          AND RestForced = 1
          AND CurrentPayRestAdd > 0
          AND PrototypeRestPremiumAdd > 0
          AND ABS(ISNULL(DifferenceVsCurrentRestAdd, 0)) <= 0.05
    )
        THROW 51000, 'RestPeriod punitive test failed: production rest premium does not match slice-chain prototype for LPID 76606.', 1;

    DECLARE @AppliedRows int =
    (
        SELECT COUNT(*)
        FROM fms.Payroll_Calculated
        WHERE ISNULL(Rest_IsForced, 0) = 1
          AND ISNULL(Pay_Rest_Add, 0) > 0
    );

    DECLARE @OverlapRows int =
    (
        SELECT COUNT(*)
        FROM fms.Payroll_Calculated
        WHERE ISNULL(Rest_IsOverlap, 0) = 1
    );

    PRINT CONCAT('RestPeriod punitive applied rows (premium>0): ', @AppliedRows);
    PRINT CONCAT('RestPeriod overlap warnings: ', @OverlapRows);

    SELECT 'PASS: test.usp_Test_RestPeriod_Punitive' AS Result;
END;
