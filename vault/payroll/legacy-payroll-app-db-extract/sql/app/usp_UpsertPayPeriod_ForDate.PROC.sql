CREATE   PROCEDURE app.usp_UpsertPayPeriod_ForDate
    @AnyDate date,
    @PayPeriodID int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Start date = app.fn_PayPeriodStart_SatFri(@AnyDate);
    DECLARE @End   date = DATEADD(DAY, 6, @Start);

    SELECT @PayPeriodID = PayPeriodID
    FROM app.PayPeriod
    WHERE PeriodStartDate = @Start AND PeriodEndDate = @End;

    IF @PayPeriodID IS NULL
    BEGIN
        INSERT app.PayPeriod(PeriodStartDate, PeriodEndDate)
        VALUES (@Start, @End);

        SET @PayPeriodID = SCOPE_IDENTITY();
    END
END
