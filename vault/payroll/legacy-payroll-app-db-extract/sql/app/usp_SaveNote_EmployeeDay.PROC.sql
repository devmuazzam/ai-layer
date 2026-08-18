
-- Employee Day
CREATE   PROCEDURE app.usp_SaveNote_EmployeeDay
      @PeriodStartDate date
    , @EmpID varchar(15)
    , @WorkDate date
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

    INSERT app.PayrollNote_EmployeeDay(PayPeriodID, EmpID, WorkDate, NoteText, CreatedBy)
    VALUES (@PayPeriodID, @EmpID, @WorkDate, @NoteText, COALESCE(@CreatedBy, ORIGINAL_LOGIN()));

    SELECT NoteID = CONVERT(int, SCOPE_IDENTITY()), PayPeriodID = @PayPeriodID;
END
