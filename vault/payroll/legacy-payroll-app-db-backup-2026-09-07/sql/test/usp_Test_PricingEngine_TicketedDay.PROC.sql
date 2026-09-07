    @WorkDate date = '2026-02-18'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @d date = @WorkDate;


    EXEC sys.sp_set_session_context
        @key   = N'PayrollAPP_RunLogID',
        @value = NULL;


    EXEC app.usp_Run_Pricing_Engine
        @WorkDateFrom      = @d,
        @WorkDateTo        = @d,
        @StrictLaborTimes  = 1;


    DECLARE @RunId int =
    (
        SELECT MAX(RunId)
        FROM etl.RunLog
        WHERE RunType = 'PricingEngine'
    );


    DECLARE @TotalErrors bigint =
    (
        SELECT COUNT_BIG(*)

        FROM rpt.v_UI_Payroll_Exceptions x

        JOIN app.v_Base_LaborPayroll b
            ON b.LaborPayrollID = x.LaborPayrollID

        LEFT JOIN src.FMS_EMPLOYEES_Raw e
            ON e.EmpID = b.EmpID

        WHERE
            x.RunId = @RunId

            AND CONVERT(date, b.WorkDate) = @d

            AND b.JobTicketID IS NOT NULL

            AND ISNULL(e.PayType, '') <> 'S'

            AND x.Severity = 'Error'
    );


    DECLARE @RequiredTimeErrors bigint =
    (
        SELECT COUNT_BIG(*)

        FROM fms.Payroll_CalcException x

        JOIN app.v_Base_LaborPayroll b
            ON b.LaborPayrollID = x.LaborPayrollID

        LEFT JOIN src.FMS_EMPLOYEES_Raw e
            ON e.EmpID = b.EmpID

        WHERE
            x.RunId = @RunId

            AND CONVERT(date, b.WorkDate) = @d

            AND b.JobTicketID IS NOT NULL

            AND ISNULL(e.PayType, '') <> 'S'

            AND
            (
                   x.Reason LIKE '%Missing_Required_Labor_Times%'
                OR x.Reason LIKE '%Invalid_Labor_Time_Interval%'
            )
    );


    DECLARE @TicketWindowCnt bigint =
    (
        SELECT COUNT_BIG(*)

        FROM calc.TicketTimeline tt

        JOIN
        (
            SELECT DISTINCT
                b.JobTicketID

            FROM app.v_Base_LaborPayroll b

            LEFT JOIN src.FMS_EMPLOYEES_Raw e
                ON e.EmpID = b.EmpID

            WHERE
                CONVERT(date, b.WorkDate) = @d

                AND b.JobTicketID IS NOT NULL

                AND ISNULL(e.PayType, '') <> 'S'
        ) t
            ON t.JobTicketID = tt.JobTicketID

        WHERE
            tt.Shift_Window_Start IS NOT NULL

            AND tt.Shift_Window_End IS NOT NULL

            AND tt.Shift_Window_End
                > tt.Shift_Window_Start
    );


    SELECT
        TestName =
            'PricingEngine_TicketedDay_StrictTime',

        WorkDate =
            @d,

        RunId =
            @RunId,

        TicketShiftWindows =
            @TicketWindowCnt,

        RequiredTimeErrors =
            @RequiredTimeErrors,

        TotalTicketedErrors =
            @TotalErrors,

        Pass =
            CONVERT
            (
                bit,
                CASE
                    WHEN @TotalErrors = 0
                     AND @TicketWindowCnt > 0
                        THEN 1
                    ELSE 0
                END
            ),

        Notes =
            'Errors are scoped to ticketed, non-salary labor. Strict time mode is enabled for this test.';
END;

