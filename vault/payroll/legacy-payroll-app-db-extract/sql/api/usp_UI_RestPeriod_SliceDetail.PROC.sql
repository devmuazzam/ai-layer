
CREATE   PROCEDURE api.usp_UI_RestPeriod_SliceDetail
      @EmpID varchar(50)
    , @AnyDateInWeek date
    , @LaborPayrollID int = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PeriodStart date = app.fn_PayPeriodStart_SatFri(@AnyDateInWeek);
    DECLARE @PeriodEnd date = DATEADD(DAY, 6, @PeriodStart);

    CREATE TABLE #Detail
    (
        EmpID varchar(50) NULL,
        Employee_Name varchar(200) NULL,
        WorkDate datetime2(7) NULL,
        LaborPayrollID int NULL,
        JobTicketID int NULL,
        JobCode varchar(50) NULL,
        ChainId int NULL,
        ChainSeq int NULL,
        RestSegmentId int NULL,
        ChainStart datetime2(0) NULL,
        ChainEnd datetime2(0) NULL,
        GapHrsFromPrev decimal(9,2) NULL,
        RestForced bit NULL,
        EntryRest_IsForced bit NULL,
        EntryPay_Rest_Add decimal(19,4) NULL,
        EntryRest_Premium_Hrs decimal(10,2) NULL,

        SliceIndex int NULL,
        Slice_Start datetime2(7) NULL,
        Slice_End datetime2(7) NULL,
        Slice_Hours decimal(10,2) NULL,
        Day_Type varchar(50) NULL,
        Holiday_Name nvarchar(200) NULL,
        Accumulation_Status varchar(100) NULL,
        Is_Outside_Window bit NULL,
        Is_Boom_Active bit NULL,

        Hourly_Rate_Raw decimal(19,4) NULL,
        RestHourlyRateForCalc decimal(19,4) NULL,
        RestHourlyRateSource varchar(40) NULL,
        NormalMultiplier decimal(10,2) NULL,
        RestChainHoursBeforeSlice decimal(10,2) NULL,
        RestMultiplier decimal(10,2) NULL,
        FinalEffectiveMultiplier decimal(10,2) NULL,
        RestReason varchar(120) NULL,

        NormalSlicePay decimal(19,4) NULL,
        RestAdjustedSlicePay decimal(19,4) NULL,
        RestPremiumDelta decimal(19,4) NULL
    );

    INSERT INTO #Detail
    EXEC app.usp_Prototype_RestPeriod_SliceChain
          @WorkDateFrom = @PeriodStart
        , @WorkDateTo = @PeriodEnd
        , @EmpID = @EmpID
        , @LaborPayrollID = @LaborPayrollID
        , @IncludeNonForced = 0
        , @OutputMode = 'Detail';

    SELECT
        EmpID,
        Employee_Name,
        WorkDate,
        LaborPayrollID,
        JobTicketID,
        JobCode,
        SliceIndex,
        Slice_Start,
        Slice_End,
        Slice_Hours,
        Day_Type,
        Holiday_Name,
        Accumulation_Status,
        Is_Boom_Active,
        RestForced,
        EntryPay_Rest_Add,
        EntryRest_Premium_Hrs,
        NormalMultiplier,
        RestChainHoursBeforeSlice,
        RestMultiplier,
        FinalEffectiveMultiplier,
        RestReason,
        RestPremiumDelta,
        RestHourlyRateForCalc,
        RestHourlyRateSource
    FROM #Detail
    ORDER BY
        WorkDate,
        Slice_Start,
        LaborPayrollID,
        SliceIndex;
END;
