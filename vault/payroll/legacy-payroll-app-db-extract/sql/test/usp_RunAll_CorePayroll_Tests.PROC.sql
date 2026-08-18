
CREATE   PROCEDURE test.usp_RunAll_CorePayroll_Tests
AS
BEGIN
    SET NOCOUNT ON;

    EXEC test.usp_Test_DailyOTDT_Split;

    -- Auto-pick current valid guarantee allocations.
    EXEC test.usp_Test_Holiday_Min8;
    EXEC test.usp_Test_SpecialSaturday_Min8;

    EXEC test.usp_Test_SundayPremium_Bucket @LaborPayrollID = 78294;
    EXEC test.usp_Test_RestPeriod_Cases;

    -- Run BOTH cross-midnight policies deterministically.
    EXEC test.usp_Test_CrossMidnight_DayTypePolicy @PolicyCode = 'CalendarDay';
    EXEC test.usp_Test_CrossMidnight_DayTypePolicy @PolicyCode = 'AnchorFloor';

    PRINT 'All core payroll tests completed successfully.';
END;
