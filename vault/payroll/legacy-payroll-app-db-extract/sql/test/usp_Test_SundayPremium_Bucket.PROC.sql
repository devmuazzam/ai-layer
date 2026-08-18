CREATE   PROCEDURE test.usp_Test_SundayPremium_Bucket
    @LaborPayrollID int = 78294,         -- Travis Garrett 2026-02-15
    @Tol decimal(10,4) = 0.01
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkDate date, @Act decimal(10,4), @ST decimal(10,4), @OT decimal(10,4), @DT decimal(10,4);

    SELECT
        @WorkDate = CAST(WorkDate AS date),
        @Act = CAST(Act_Total_Hrs AS decimal(10,4)),
        @ST  = CAST(Hrs_ST        AS decimal(10,4)),
        @OT  = CAST(Hrs_OT        AS decimal(10,4)),
        @DT  = CAST(Hrs_DT        AS decimal(10,4))
    FROM fms.Payroll_Calculated
    WHERE LaborPayrollID = @LaborPayrollID;

    IF @WorkDate IS NULL THROW 51090, 'SundayPremium test failed: LaborPayrollID not found.', 1;

    SELECT
        LaborPayrollID = @LaborPayrollID,
        WorkDate = @WorkDate,
        IsSunday = CASE WHEN (DATEDIFF(DAY,'19000107', @WorkDate) % 7) = 0 THEN 1 ELSE 0 END,
        Act_Total_Hrs = @Act,
        Hrs_ST = @ST,
        Hrs_OT = @OT,
        Hrs_DT = @DT;

    IF (DATEDIFF(DAY,'19000107', @WorkDate) % 7) <> 0
        THROW 51091, 'SundayPremium test failed: WorkDate is not Sunday.', 1;

    IF ABS(@ST - 0.0) > @Tol OR ABS(@OT - 0.0) > @Tol
        THROW 51092, 'SundayPremium test failed: Expected Hrs_ST and Hrs_OT to be ~0 under current Sunday modeling.', 1;

    IF ABS(@DT - @Act) > @Tol
        THROW 51093, 'SundayPremium test failed: Expected Hrs_DT ~ Act_Total_Hrs under current Sunday modeling.', 1;

    PRINT 'Sunday premium bucket behavior validated successfully.';
END
