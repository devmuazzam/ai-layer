
CREATE   PROCEDURE app.usp_Apply_SubsistencePay
    @WorkDateFrom date = NULL,
    @WorkDateTo   date = NULL,
    @RunId        int  = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FromDate date = COALESCE(@WorkDateFrom, '19000101');
    DECLARE @ToDate   date = COALESCE(@WorkDateTo,   '99991231');

    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
       AND @WorkDateFrom > @WorkDateTo
        THROW 51001, '@WorkDateFrom cannot be greater than @WorkDateTo.', 1;

    IF @RunId IS NULL
        SET @RunId = TRY_CONVERT(int, SESSION_CONTEXT(N'PayrollAPP_RunLogID'));

    IF OBJECT_ID(N'app.v_LaborPayroll_CommentTokens', N'V') IS NULL
        THROW 51002, 'Missing app.v_LaborPayroll_CommentTokens.', 1;

    IF OBJECT_ID(N'fms.Payroll_PayComponent', N'U') IS NULL
        THROW 51003, 'Missing fms.Payroll_PayComponent.', 1;

    /* ------------------------------------------------------------
       Remove existing subsistence rows in this date range.
       Keeps reruns idempotent.
       ------------------------------------------------------------ */

    DELETE p
    FROM fms.Payroll_PayComponent p
    WHERE p.WorkDate >= @FromDate
      AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND p.ComponentGroup = 'SUBSISTENCE';

    DECLARE @DeletedRows int = @@ROWCOUNT;

    /* ------------------------------------------------------------
       Insert subsistence from exact payroll comment tokens only.

       Current rule:
         SUB_SHORT = $85 any day
         SUB_LONG  = $85 weekday, $200 Saturday/Sunday

       This is included in payable gross, but not Final_Gross_Pay.
       ------------------------------------------------------------ */

    ;WITH TokenRows AS
    (
        SELECT
            pc.CalcID,
            pc.LaborPayrollID,
            WorkDate = CONVERT(date, pc.WorkDate),
            pc.JobTicketID,
            pc.JobCode,
            pc.EmpID,
            pc.Employee_Name,

            ct.Has_SUB_SHORT,
            ct.Has_SUB_LONG,
            ct.LaborComments_Clean,

            IsWeekend =
                CONVERT(bit,
                    CASE
                        WHEN DATEDIFF(DAY, CONVERT(date, '19000106'), CONVERT(date, pc.WorkDate)) % 7 = 0 -- Saturday
                          OR DATEDIFF(DAY, CONVERT(date, '19000107'), CONVERT(date, pc.WorkDate)) % 7 = 0 -- Sunday
                        THEN 1 ELSE 0
                    END
                )
        FROM fms.Payroll_Calculated pc
        JOIN app.v_LaborPayroll_CommentTokens ct
            ON ct.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @FromDate
          AND pc.WorkDate <  DATEADD(DAY, 1, @ToDate)
          AND
          (
              ct.Has_SUB_SHORT = 1
              OR ct.Has_SUB_LONG = 1
          )
    ),
    CalcRows AS
    (
        SELECT
            *,
            ComponentCode =
                CASE
                    WHEN Has_SUB_LONG = 1 AND IsWeekend = 1
                        THEN 'SUBSISTENCE_LONG_WEEKEND_200'
                    WHEN Has_SUB_LONG = 1
                        THEN 'SUBSISTENCE_LONG_WEEKDAY_85'
                    ELSE 'SUBSISTENCE_SHORT_85'
                END,

            ComponentLabel =
                CASE
                    WHEN Has_SUB_LONG = 1 AND IsWeekend = 1
                        THEN 'Long Subsistence - Weekend'
                    WHEN Has_SUB_LONG = 1
                        THEN 'Long Subsistence - Weekday'
                    ELSE 'Short Subsistence'
                END,

            SourceRuleCode =
                CASE
                    WHEN Has_SUB_LONG = 1 AND IsWeekend = 1
                        THEN 'SUB_LONG_WEEKEND'
                    WHEN Has_SUB_LONG = 1
                        THEN 'SUB_LONG_WEEKDAY'
                    ELSE 'SUB_SHORT'
                END,

            SourceRuleName =
                CASE
                    WHEN Has_SUB_LONG = 1 AND IsWeekend = 1
                        THEN 'Long subsistence weekend allowance'
                    WHEN Has_SUB_LONG = 1
                        THEN 'Long subsistence weekday allowance'
                    ELSE 'Short subsistence allowance'
                END,

            ComponentAmount =
                CONVERT(decimal(19,4),
                    CASE
                        WHEN Has_SUB_LONG = 1 AND IsWeekend = 1
                            THEN 200.00
                        ELSE 85.00
                    END
                )
        FROM TokenRows
    )
    INSERT fms.Payroll_PayComponent
    (
        RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        JobTicketID,
        JobCode,
        EmpID,
        Employee_Name,
        ComponentCode,
        ComponentGroup,
        ComponentLabel,
        SourceSchema,
        SourceTable,
        SourceID,
        SourceRuleCode,
        SourceRuleName,
        ComponentHours,
        Hrs_ST,
        Hrs_OT,
        Hrs_DT,
        RateBaseUsed,
        RateShiftUsed,
        RateBoomUsed,
        MultiplierUsed,
        ComponentAmount,
        IncludedInFinalGross,
        IncludedInPayableGross,
        DisplaySort,
        Explanation
    )
    SELECT
        @RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        JobTicketID,
        JobCode,
        EmpID,
        Employee_Name,
        ComponentCode,
        'SUBSISTENCE',
        ComponentLabel,
        'app',
        'v_LaborPayroll_CommentTokens',
        LaborPayrollID,
        SourceRuleCode,
        SourceRuleName,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        ComponentAmount,
        CONVERT(bit, 0),
        CONVERT(bit, 1),
        50,
        CONCAT
        (
            SourceRuleName,
            ' from labor comment token. Comment=',
            COALESCE(LaborComments_Clean, '')
        )
    FROM CalcRows;

    DECLARE @InsertedRows int = @@ROWCOUNT;

    PRINT CONCAT('Deleted existing subsistence rows: ', @DeletedRows);
    PRINT CONCAT('Inserted subsistence rows: ', @InsertedRows);
END;
