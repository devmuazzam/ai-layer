
CREATE         PROCEDURE [app].[usp_ProcessPayroll_PayPeriod]
    @PeriodStartDate date,          -- Saturday
    @ProcessedBy sysname = NULL,
    @SnapshotNote nvarchar(max) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @PeriodEndDate date = DATEADD(DAY, 6, @PeriodStartDate);
    DECLARE @PayPeriodID int;

    -- Ensure PayPeriod row exists
    SELECT @PayPeriodID = PayPeriodID
    FROM app.PayPeriod
    WHERE PeriodStartDate = @PeriodStartDate
      AND PeriodEndDate   = @PeriodEndDate;

    IF @PayPeriodID IS NULL
    BEGIN
        INSERT app.PayPeriod(PeriodStartDate, PeriodEndDate)
        VALUES (@PeriodStartDate, @PeriodEndDate);

        SET @PayPeriodID = SCOPE_IDENTITY();
    END

    -- Run calc chain for the period
    EXEC app.usp_Run_Pricing_Engine
        @WorkDateFrom = @PeriodStartDate,
        @WorkDateTo   = @PeriodEndDate;

    EXEC app.usp_FinalizePayrollOutputs_AfterPricing
        @WorkDateFrom = @PeriodStartDate,
        @WorkDateTo   = @PeriodEndDate,
        @RunId        = NULL;

    -- Create snapshot header
    DECLARE @SnapshotID bigint;
    INSERT app.PayrollSnapshot(PayPeriodID, SourceRunId, SnapshotNote, CreatedBy)
    VALUES (@PayPeriodID, NULL, @SnapshotNote, COALESCE(@ProcessedBy, ORIGINAL_LOGIN()));

    SET @SnapshotID = SCOPE_IDENTITY();

    -- Snapshot detail (freeze rows for this pay period)
    INSERT app.PayrollSnapshot_Detail
    (
        SnapshotID,
        CalcID, LaborPayrollID, JobTicketID, JobCode, EmpID, Employee_Name, TicketDate, WorkDate,
        Act_Total_Hrs, Act_Boom_Hrs, Gap_Hrs_Total, Gap_Hrs_Boom, Pay_Total_Hrs,
        Hrs_ST, Hrs_OT, Hrs_DT,
        Pay_Actual_Gross, Pay_Gap_Add, Final_Gross_Pay,
        Audit_Min_Rule, Audit_Gap_Mult, CalculatedAt,
        Pay_Rest_Add, Rest_IsForced, Rest_ChainId, Rest_Gap_Hrs_FromPrevChain, Rest_IsOverlap, Rest_Premium_Hrs, Rest_Policy
    )
    SELECT
        @SnapshotID,
        CalcID, LaborPayrollID, JobTicketID, JobCode, EmpID, Employee_Name, TicketDate, WorkDate,
        Act_Total_Hrs, Act_Boom_Hrs, Gap_Hrs_Total, Gap_Hrs_Boom, Pay_Total_Hrs,
        Hrs_ST, Hrs_OT, Hrs_DT,
        Pay_Actual_Gross, Pay_Gap_Add, Final_Gross_Pay,
        Audit_Min_Rule, Audit_Gap_Mult, CalculatedAt,
        Pay_Rest_Add, Rest_IsForced, Rest_ChainId, Rest_Gap_Hrs_FromPrevChain, Rest_IsOverlap, Rest_Premium_Hrs, Rest_Policy
    FROM fms.Payroll_Calculated
    WHERE WorkDate >= @PeriodStartDate
      AND WorkDate <  DATEADD(DAY, 1, @PeriodEndDate);

    -- Mark period processed
    UPDATE app.PayPeriod
    SET Status = 'Processed',
        ProcessedAtUTC = SYSUTCDATETIME(),
        ProcessedBy = COALESCE(@ProcessedBy, ORIGINAL_LOGIN())
    WHERE PayPeriodID = @PayPeriodID;

    SELECT
        PayPeriodID = @PayPeriodID,
        SnapshotID  = @SnapshotID,
        PeriodStartDate = @PeriodStartDate,
        PeriodEndDate   = @PeriodEndDate;
END
