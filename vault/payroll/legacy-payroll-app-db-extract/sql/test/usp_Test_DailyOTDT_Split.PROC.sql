
CREATE   PROCEDURE test.usp_Test_DailyOTDT_Split
    @LaborPayrollID int = NULL,
    @Tol decimal(10,4) = 0.01
AS
BEGIN
    SET NOCOUNT ON;

    IF @LaborPayrollID IS NULL
    BEGIN
        SELECT TOP (1)
            @LaborPayrollID = LaborPayrollID
        FROM test.Case_CorePayrollScenario
        WHERE ScenarioCode = 'WEEKDAY_DAILY_DT'
          AND IsActive = 1
        ORDER BY ScenarioID;
    END;

    IF @LaborPayrollID IS NULL
        THROW 51060, 'DailyOTDT test failed: no active WEEKDAY_DAILY_DT scenario found.', 1;

    DECLARE
        @Act decimal(10,4),
        @ST decimal(10,4),
        @OT decimal(10,4),
        @DT decimal(10,4),
        @ExpectedST decimal(10,4),
        @ExpectedOT decimal(10,4),
        @ExpectedDT decimal(10,4);

    SELECT
        @Act = CAST(Act_Total_Hrs AS decimal(10,4)),
        @ST  = CAST(Hrs_ST AS decimal(10,4)),
        @OT  = CAST(Hrs_OT AS decimal(10,4)),
        @DT  = CAST(Hrs_DT AS decimal(10,4))
    FROM fms.Payroll_Calculated
    WHERE LaborPayrollID = @LaborPayrollID;

    IF @Act IS NULL
        THROW 51061, 'DailyOTDT test failed: LaborPayrollID not found in fms.Payroll_Calculated.', 1;

    SET @ExpectedST =
        CASE
            WHEN @Act <= 8.0 THEN @Act
            ELSE 8.0
        END;

    SET @ExpectedOT =
        CASE
            WHEN @Act <= 8.0 THEN 0.0
            WHEN @Act <= 12.0 THEN @Act - 8.0
            ELSE 4.0
        END;

    SET @ExpectedDT =
        CASE
            WHEN @Act > 12.0 THEN @Act - 12.0
            ELSE 0.0
        END;

    SELECT
        TestName = 'DailyOTDT_Split',
        LaborPayrollID = @LaborPayrollID,
        Act_Total_Hrs = @Act,
        Hrs_ST = @ST,
        Expected_ST = @ExpectedST,
        Hrs_OT = @OT,
        Expected_OT = @ExpectedOT,
        Hrs_DT = @DT,
        Expected_DT = @ExpectedDT;

    IF ABS(@ST - @ExpectedST) > @Tol
        THROW 51062, 'DailyOTDT test failed: Hrs_ST does not match expected daily split.', 1;

    IF ABS(@OT - @ExpectedOT) > @Tol
        THROW 51063, 'DailyOTDT test failed: Hrs_OT does not match expected daily split.', 1;

    IF ABS(@DT - @ExpectedDT) > @Tol
        THROW 51064, 'DailyOTDT test failed: Hrs_DT does not match expected daily split.', 1;

    IF @Act <= 12.0
        THROW 51065, 'DailyOTDT test failed: selected scenario is not a >12 hour DT scenario.', 1;

    PRINT 'Daily OT/DT split validated successfully.';
END;
