
CREATE   PROCEDURE test.usp_RunAll_PricingEngine_Tests
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Running test.usp_Test_PricingEngine_HoursOnly...';
    EXEC test.usp_Test_PricingEngine_HoursOnly;

    PRINT 'Running test.usp_Test_PricingEngine_TicketedDay...';
    EXEC test.usp_Test_PricingEngine_TicketedDay;
END
