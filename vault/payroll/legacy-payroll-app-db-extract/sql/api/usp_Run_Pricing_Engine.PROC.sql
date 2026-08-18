
CREATE   PROCEDURE [api].[usp_Run_Pricing_Engine]
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    EXEC [app].[usp_Run_Pricing_Engine];
END;
