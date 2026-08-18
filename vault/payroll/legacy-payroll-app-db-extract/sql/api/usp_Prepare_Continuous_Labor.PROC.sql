
/* ============================================================
   1) API wrappers (UI surface)
   ============================================================ */
CREATE   PROCEDURE [api].[usp_Prepare_Continuous_Labor]
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    EXEC [app].[usp_Prepare_Continuous_Labor];
END;
