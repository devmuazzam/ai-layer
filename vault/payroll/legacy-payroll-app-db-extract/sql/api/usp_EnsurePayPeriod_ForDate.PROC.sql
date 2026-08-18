
CREATE   PROCEDURE api.usp_EnsurePayPeriod_ForDate
    @AnyDateInWeek date
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PayPeriodID int = NULL;

    EXEC app.usp_UpsertPayPeriod_ForDate
          @AnyDate     = @AnyDateInWeek,
          @PayPeriodID = @PayPeriodID OUTPUT;

    SELECT
        p.PayPeriodID,
        p.PeriodStartDate,
        p.PeriodEndDate,
        p.Status,
        p.ProcessedAtUTC,
        p.ProcessedBy,
        p.CreatedAtUTC
    FROM app.PayPeriod p
    WHERE p.PayPeriodID = @PayPeriodID;
END
