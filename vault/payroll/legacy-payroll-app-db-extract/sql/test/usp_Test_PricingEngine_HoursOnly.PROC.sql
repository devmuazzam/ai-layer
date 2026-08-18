
/* 3A) Test: Hours-only day should produce warnings (no errors) */
CREATE   PROCEDURE test.usp_Test_PricingEngine_HoursOnly
    @WorkDate date = NULL  -- optional override
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @d date =
        COALESCE
        (
            @WorkDate,
            (
                SELECT TOP (1) CONVERT(date, WorkDate)
                FROM app.v_Base_LaborPayroll
                WHERE JobTicketID IS NULL
                  AND TimeStart_Labor IS NULL
                  AND TimeEnd_Labor IS NULL
                  AND HoursWorked_Raw > 0
                ORDER BY WorkDate DESC
            )
        );

    IF @d IS NULL
    BEGIN
        SELECT
            TestName = 'PricingEngine_HoursOnly',
            Status = 'SKIPPED',
            Message = 'No hours-only candidate date found (JobTicketID NULL + no labor start/end + HoursWorked_Raw > 0).';
        RETURN;
    END

    EXEC sys.sp_set_session_context @key=N'PayrollAPP_RunLogID', @value=NULL;

    EXEC app.usp_Run_Pricing_Engine
        @WorkDateFrom = @d,
        @WorkDateTo   = @d;

    DECLARE @RunId int =
        (SELECT MAX(RunId) FROM etl.RunLog WHERE RunType='PricingEngine');

    DECLARE @Errors int =
    (
        SELECT COALESCE(SUM(CASE WHEN Reason NOT LIKE 'Shift_Assumed%' THEN 1 ELSE 0 END), 0)
        FROM fms.Payroll_CalcException
        WHERE RunId = @RunId
    );

    DECLARE @Warnings int =
    (
        SELECT COALESCE(SUM(CASE WHEN Reason LIKE 'Shift_Assumed%' THEN 1 ELSE 0 END), 0)
        FROM fms.Payroll_CalcException
        WHERE RunId = @RunId
    );

    SELECT
        TestName   = 'PricingEngine_HoursOnly',
        WorkDate   = @d,
        RunId      = @RunId,
        Errors     = @Errors,
        Warnings   = @Warnings,
        Pass       = CASE WHEN @Errors = 0 AND @Warnings >= 1 THEN 1 ELSE 0 END,
        Notes      = 'Expected: Errors=0 and Warnings>=1 (Shift_Assumed).';
END
