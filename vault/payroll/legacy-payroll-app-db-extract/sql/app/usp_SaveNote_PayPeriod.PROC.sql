
-- PayPeriod
CREATE   PROCEDURE app.usp_SaveNote_PayPeriod
      @PeriodStartDate date
    , @NoteText nvarchar(max)
    , @CreatedBy sysname = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PeriodEndDate date = DATEADD(DAY, 6, @PeriodStartDate);
    DECLARE @PayPeriodID int;

    SELECT @PayPeriodID = PayPeriodID
    FROM app.PayPeriod
    WHERE PeriodStartDate = @PeriodStartDate
      AND PeriodEndDate   = @PeriodEndDate;

    IF @PayPeriodID IS NULL
    BEGIN
        INSERT app.PayPeriod(PeriodStartDate, PeriodEndDate)
        VALUES (@PeriodStartDate, @PeriodEndDate);

        SET @PayPeriodID = CONVERT(int, SCOPE_IDENTITY());
    END

    INSERT app.PayrollNote_PayPeriod(PayPeriodID, NoteText, CreatedBy)
    VALUES (@PayPeriodID, @NoteText, COALESCE(@CreatedBy, ORIGINAL_LOGIN()));

    IF COL_LENGTH('app.PayPeriod', 'PayPeriodNote') IS NOT NULL
    BEGIN
        UPDATE app.PayPeriod
        SET PayPeriodNote = @NoteText
        WHERE PayPeriodID = @PayPeriodID;
    END

    SELECT NoteID = CONVERT(int, SCOPE_IDENTITY()), PayPeriodID = @PayPeriodID;
END
