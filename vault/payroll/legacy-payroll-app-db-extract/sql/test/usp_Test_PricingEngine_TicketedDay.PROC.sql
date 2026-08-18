
CREATE   PROCEDURE test.usp_Test_PricingEngine_TicketedDay
    @WorkDate date = '2026-02-18'  -- known-good day; override if needed
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @d date = @WorkDate;

    EXEC sys.sp_set_session_context @key=N'PayrollAPP_RunLogID', @value=NULL;

    EXEC app.usp_Run_Pricing_Engine
        @WorkDateFrom = @d,
        @WorkDateTo   = @d;

    DECLARE @RunId int =
        (SELECT MAX(RunId) FROM etl.RunLog WHERE RunType='PricingEngine');

    DECLARE @ShiftStartNullErrors int =
    (
        SELECT COALESCE(SUM(CASE WHEN Reason='Shift_Start NULL' THEN 1 ELSE 0 END), 0)
        FROM fms.Payroll_CalcException
        WHERE RunId = @RunId
    );

    DECLARE @TotalErrors int =
    (
        SELECT COALESCE(SUM(CASE WHEN Reason NOT LIKE 'Shift_Assumed%' THEN 1 ELSE 0 END), 0)
        FROM fms.Payroll_CalcException
        WHERE RunId = @RunId
    );

    DECLARE @TicketWindowCnt bigint =
    (
        SELECT COUNT_BIG(*)
        FROM calc.TicketTimeline tt
        JOIN
        (
            SELECT DISTINCT JobTicketID
            FROM app.v_Base_LaborPayroll
            WHERE CONVERT(date, WorkDate) = @d
              AND JobTicketID IS NOT NULL
        ) t
          ON t.JobTicketID = tt.JobTicketID
        WHERE tt.Shift_Window_Start IS NOT NULL
          AND tt.Shift_Window_End   IS NOT NULL
          AND tt.Shift_Window_End > tt.Shift_Window_Start
    );

    SELECT
        TestName             = 'PricingEngine_TicketedDay',
        WorkDate             = @d,
        RunId                = @RunId,
        TicketShiftWindows   = @TicketWindowCnt,
        ShiftStartNullErrors = @ShiftStartNullErrors,
        TotalErrors          = @TotalErrors,
        Pass                 = CASE
                                 WHEN @ShiftStartNullErrors = 0
                                  AND @TotalErrors = 0
                                  AND @TicketWindowCnt > 0
                                 THEN 1 ELSE 0
                               END,
        Notes                = 'Expected: TotalErrors=0, ShiftStartNullErrors=0, TicketShiftWindows>0.';
END
