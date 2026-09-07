    @WorkDate date = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CandidateLaborPayrollID int;
    DECLARE @d date;
    DECLARE @CandidateBlockReason varchar(50);

    SELECT TOP (1)
        @CandidateLaborPayrollID =
            b.LaborPayrollID,

        @d =
            CONVERT(date, b.WorkDate),

        @CandidateBlockReason =
            CASE
                WHEN b.TimeStart_Labor IS NULL
                  OR b.TimeEnd_Labor IS NULL
                    THEN 'Missing_Required_Labor_Times'

                ELSE 'Invalid_Labor_Time_Interval'
            END

    FROM app.v_Base_LaborPayroll b

    LEFT JOIN src.FMS_EMPLOYEES_Raw e
        ON e.EmpID = b.EmpID

    WHERE
        ISNULL(e.PayType, '') <> 'S'

        AND ISNULL(b.HoursWorked_Raw, 0) > 0

        AND
        (
               b.TimeStart_Labor IS NULL
            OR b.TimeEnd_Labor   IS NULL
            OR
            (
                TRY_CONVERT(time(0), b.TimeStart_Labor)
                =
                TRY_CONVERT(time(0), b.TimeEnd_Labor)
            )
        )

        AND
        (
            @WorkDate IS NULL
            OR CONVERT(date, b.WorkDate) = @WorkDate
        )

    ORDER BY
        CASE
            WHEN b.TimeStart_Labor IS NULL
              OR b.TimeEnd_Labor IS NULL
                THEN 0
            ELSE 1
        END,

        CONVERT(date, b.WorkDate) DESC,
        b.LaborPayrollID DESC;


    IF @CandidateLaborPayrollID IS NULL
    BEGIN
        SELECT
            TestName =
                'PricingEngine_StrictTime_Block',

            Status =
                'SKIPPED',

            Message =
                'No positive-hour non-salary invalid-time candidate was found.';

        RETURN;
    END;


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


    DECLARE @BlockingErrorRows bigint =
    (
        SELECT COUNT_BIG(*)

        FROM fms.Payroll_CalcException

        WHERE RunId = @RunId

          AND LaborPayrollID =
              @CandidateLaborPayrollID

          AND Reason LIKE
              '%' + @CandidateBlockReason + '%'
    );


    DECLARE @CalculatedRows bigint =
    (
        SELECT COUNT_BIG(*)

        FROM fms.Payroll_Calculated

        WHERE RunId = @RunId

          AND LaborPayrollID =
              @CandidateLaborPayrollID
    );


    DECLARE @ShiftAssumedRows bigint =
    (
        SELECT COUNT_BIG(*)

        FROM fms.Payroll_CalcException

        WHERE RunId = @RunId

          AND LaborPayrollID =
              @CandidateLaborPayrollID

          AND Reason LIKE '%Shift_Assumed%'
    );


    SELECT
        TestName =
            'PricingEngine_StrictTime_Block',

        WorkDate =
            @d,

        RunId =
            @RunId,

        LaborPayrollID =
            @CandidateLaborPayrollID,

        ExpectedBlockReason =
            @CandidateBlockReason,

        BlockingErrorRows =
            @BlockingErrorRows,

        CalculatedRows =
            @CalculatedRows,

        ShiftAssumedRows =
            @ShiftAssumedRows,

        Pass =
            CONVERT
            (
                bit,
                CASE
                    WHEN @BlockingErrorRows >= 1
                     AND @CalculatedRows = 0
                     AND @ShiftAssumedRows = 0
                        THEN 1
                    ELSE 0
                END
            ),

        Notes =
            'Expected: blocking time error >= 1, calculated rows = 0, Shift_Assumed rows = 0.';
END;

