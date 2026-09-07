/* ============================================================
   2. REBUILD PROCEDURE

   Uses the tested rest prototype to obtain its slice-level
   interpretation, then keeps only rows that production ultimately
   considers Rest_IsForced.

   This is important because Non-Union Admin Hourly employees are
   cleared by their own CA OT/DT process.
   ============================================================ */

CREATE   PROCEDURE app.usp_Rebuild_RestSliceAdjustment
      @WorkDateFrom date
    , @WorkDateTo   date
    , @RunId        int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @WorkDateFrom IS NULL
       OR @WorkDateTo IS NULL
        THROW 51000,
            'WorkDateFrom and WorkDateTo are required.',
            1;

    IF @WorkDateTo < @WorkDateFrom
        THROW 51001,
            'WorkDateTo must be >= WorkDateFrom.',
            1;

    SET @RunId =
        COALESCE
        (
            @RunId,
            TRY_CONVERT
            (
                int,
                SESSION_CONTEXT(N'PayrollAPP_RunLogID')
            )
        );


    DROP TABLE IF EXISTS #Detail;

    CREATE TABLE #Detail
    (
        EmpID                         varchar(50)    NULL,
        Employee_Name                 varchar(200)   NULL,
        WorkDate                      datetime2(7)   NULL,
        LaborPayrollID                int            NULL,
        JobTicketID                   int            NULL,
        JobCode                       varchar(50)    NULL,

        ChainId                       int            NULL,
        ChainSeq                      int            NULL,
        RestSegmentId                 int            NULL,
        ChainStart                    datetime2(0)   NULL,
        ChainEnd                      datetime2(0)   NULL,
        GapHrsFromPrev                decimal(9,2)   NULL,
        RestForced                    bit            NULL,

        EntryRest_IsForced            bit            NULL,
        EntryPay_Rest_Add             decimal(19,4)  NULL,
        EntryRest_Premium_Hrs         decimal(10,2)  NULL,

        SliceIndex                    int            NULL,
        Slice_Start                   datetime2(7)   NULL,
        Slice_End                     datetime2(7)   NULL,
        Slice_Hours                   decimal(10,2)  NULL,

        Day_Type                      varchar(50)    NULL,
        Holiday_Name                  nvarchar(200)  NULL,
        Accumulation_Status           varchar(100)   NULL,
        Is_Outside_Window             bit            NULL,
        Is_Boom_Active                bit            NULL,

        Hourly_Rate_Raw               decimal(19,4)  NULL,
        RestHourlyRateForCalc         decimal(19,6)  NULL,
        RestHourlyRateSource          varchar(40)    NULL,

        NormalMultiplier              decimal(10,2)  NULL,
        RestChainHoursBeforeSlice     decimal(10,2)  NULL,
        RestMultiplier                decimal(10,2)  NULL,
        FinalEffectiveMultiplier      decimal(10,2)  NULL,
        RestReason                    varchar(120)   NULL,

        NormalSlicePay                decimal(19,4)  NULL,
        RestAdjustedSlicePay          decimal(19,4)  NULL,
        RestPremiumDelta              decimal(19,4)  NULL
    );


    INSERT INTO #Detail
    EXEC app.usp_Prototype_RestPeriod_SliceChain
          @WorkDateFrom     = @WorkDateFrom
        , @WorkDateTo       = @WorkDateTo
        , @EmpID            = NULL
        , @LaborPayrollID   = NULL
        , @IncludeNonForced = 0
        , @LookbackDays     = 7
        , @OutputMode       = 'Detail';


    /* --------------------------------------------------------
       Safety: SliceIndex must be unique inside each labor entry.
       -------------------------------------------------------- */

    IF EXISTS
    (
        SELECT
            LaborPayrollID,
            SliceIndex
        FROM #Detail
        WHERE RestForced = 1
        GROUP BY
            LaborPayrollID,
            SliceIndex
        HAVING COUNT(*) > 1
    )
    BEGIN
        THROW 51002,
            'Duplicate LaborPayrollID/SliceIndex found in rest slice output.',
            1;
    END;


    BEGIN TRANSACTION;


    /* --------------------------------------------------------
       Replace only the requested calculation window.
       -------------------------------------------------------- */

    DELETE rsa
    FROM fms.Payroll_RestSliceAdjustment rsa
    WHERE rsa.WorkDate >= @WorkDateFrom
      AND rsa.WorkDate <= @WorkDateTo;


    /* --------------------------------------------------------
       Production authorization:

       Keep a slice only when Payroll_Calculated still says the
       labor entry is Rest_IsForced AFTER all current employee-
       group corrections have been applied.

       This naturally excludes the Non-Union Admin Hourly rows.
       -------------------------------------------------------- */

    INSERT INTO fms.Payroll_RestSliceAdjustment
    (
        LaborPayrollID,
        SliceIndex,
        CalcID,
        RunId,

        EmpID,
        WorkDate,

        Slice_Start,
        Slice_End,
        Slice_Hours,

        RestSegmentId,
        GapHrsFromPrev,
        RestForced,

        RestChainHoursBeforeSlice,

        NormalMultiplier,
        RestMultiplier,
        EffectiveMultiplier,

        RestReason,

        RestHourlyRateForCalc,

        NormalSlicePay,
        RestAdjustedSlicePay,
        RestPremiumDelta
    )
    SELECT
        d.LaborPayrollID,
        d.SliceIndex,
        pc.CalcID,
        COALESCE(@RunId, pc.RunId),

        d.EmpID,
        CONVERT(date, d.WorkDate),

        d.Slice_Start,
        d.Slice_End,
        d.Slice_Hours,

        d.RestSegmentId,
        d.GapHrsFromPrev,
        CONVERT(bit, 1),

        d.RestChainHoursBeforeSlice,

        d.NormalMultiplier,
        d.RestMultiplier,
        d.FinalEffectiveMultiplier,

        d.RestReason,

        d.RestHourlyRateForCalc,

        d.NormalSlicePay,
        d.RestAdjustedSlicePay,
        d.RestPremiumDelta

    FROM #Detail d

    JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = d.LaborPayrollID

    WHERE ISNULL(d.RestForced, 0) = 1
      AND ISNULL(pc.Rest_IsForced, 0) = 1
      AND CONVERT(date, d.WorkDate)
            BETWEEN @WorkDateFrom AND @WorkDateTo;


    DECLARE @InsertedRows int = @@ROWCOUNT;

    COMMIT TRANSACTION;


    PRINT CONCAT
    (
        'Rest slice adjustment rows rebuilt: ',
        @InsertedRows,
        '.'
    );
END;

