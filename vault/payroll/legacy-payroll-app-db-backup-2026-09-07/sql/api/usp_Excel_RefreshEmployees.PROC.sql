CREATE   PROCEDURE api.usp_Excel_RefreshEmployees
      @PayrollStartDate date
    , @PayrollEndDate   date
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    EXEC TCG_RawFMS.api.usp_Excel_RefreshEmployees
          @PayrollStartDate = @PayrollStartDate
        , @PayrollEndDate   = @PayrollEndDate;
END;

