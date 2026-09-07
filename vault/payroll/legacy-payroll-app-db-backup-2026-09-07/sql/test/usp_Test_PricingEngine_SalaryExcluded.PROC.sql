    @WorkDate date = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CandidateLaborPayrollID int;
    DECLARE @CandidateEmpID varchar(50);
    DECLARE @CandidateEmployeeName varchar(200);
    DECLARE @d date;


    SELECT TOP (1)
        @CandidateLaborPayrollID =
            b.LaborPayrollID,

        @CandidateEmpID =
            CONVERT(varchar(50), b.EmpID),

        @CandidateEmployeeName =
            b.Employee_Name,

        @d =
            CONVERT(date, b.WorkDate)

    FROM app.v_Base_LaborPayroll b

    JOIN src.FMS_EMPLOYEES_Raw e
        ON e.EmpID = b.EmpID

    WHERE
        e.PayType = 'S'

        AND
        (
            @WorkDate IS NULL
            OR CONVERT(date, b.WorkDate) = @WorkDate
        )

    ORDER BY
        CONVERT(date, b.WorkDate) DESC,
        b.LaborPayrollID DESC;


    IF @CandidateLaborPayrollID IS NULL
    BEGIN
        SELECT
            TestName =
                'PricingEngine_SalaryExcluded',

            Status =
                'SKIPPED',

            Message =
                'No PayType S labor candidate was found.';

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


    DECLARE @CalculatedRows bigint =
    (
        SELECT COUNT_BIG(*)
        FROM fms.Payroll_Calculated
        WHERE RunId = @RunId
          AND LaborPayrollID = @CandidateLaborPayrollID
    );


    DECLARE @ExceptionRows bigint =
    (
        SELECT COUNT_BIG(*)
        FROM fms.Payroll_CalcException
        WHERE RunId = @RunId
          AND LaborPayrollID = @CandidateLaborPayrollID
    );


    SELECT
        TestName =
            'PricingEngine_SalaryExcluded',

        WorkDate =
            @d,

        RunId =
            @RunId,

        LaborPayrollID =
            @CandidateLaborPayrollID,

        EmpID =
            @CandidateEmpID,

        Employee_Name =
            @CandidateEmployeeName,

        CalculatedRows =
            @CalculatedRows,

        ExceptionRows =
            @ExceptionRows,

        Pass =
            CONVERT
            (
                bit,
                CASE
                    WHEN @CalculatedRows = 0
                     AND @ExceptionRows = 0
                        THEN 1
                    ELSE 0
                END
            ),

        Notes =
            'Expected: PayType S labor is excluded before hourly pricing and time validation.';
END;

