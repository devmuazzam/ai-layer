CREATE     PROCEDURE [api].[usp_Excel_PayrollRecommendations]
    @PayStartDate date,
    @PayEndDate   date,
    @EmpID        varchar(50) = NULL,
    @ADPFileNo    varchar(100) = NULL,
    @RunId        int = NULL
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    /*************************************************************************
      0. NORMALIZE OPTIONAL FILTERS
    *************************************************************************/
    SET @EmpID =
        NULLIF
        (
            LTRIM(RTRIM(@EmpID)),
            ''
        );

    SET @ADPFileNo =
        NULLIF
        (
            UPPER(LTRIM(RTRIM(@ADPFileNo))),
            ''
        );


    /*************************************************************************
      1. RESOLVE AUTHORITATIVE NIGHTLY PAYROLL RUN
    *************************************************************************/
    DECLARE @ResolvedRunId int;

    EXEC api.usp_ResolveAuthoritativePayrollRun
        @PayStartDate   = @PayStartDate,
        @PayEndDate     = @PayEndDate,
        @RequestedRunId = @RunId,
        @ResolvedRunId  = @ResolvedRunId OUTPUT;


    /*************************************************************************
      2. IF BOTH EMPLOYEE FILTERS ARE PROVIDED, REQUIRE THEM TO MATCH
    *************************************************************************/
    IF @EmpID IS NOT NULL
       AND @ADPFileNo IS NOT NULL
       AND NOT EXISTS
       (
           SELECT 1
           FROM api.v_UI_Employee_PayrollGroupRate e
           WHERE e.EmpID = @EmpID
             AND UPPER(LTRIM(RTRIM(e.ADP_FileNumber_Clean))) = @ADPFileNo
       )
    BEGIN
        THROW 52100,
            'EmpID and ADPFileNo do not identify the same employee.',
            1;
    END;


    /*************************************************************************
      3. TEMP TABLE CLEANUP
    *************************************************************************/
    DROP TABLE IF EXISTS #Base;
    DROP TABLE IF EXISTS #ComponentAgg;
    DROP TABLE IF EXISTS #UnhandledComponents;
    DROP TABLE IF EXISTS #ExceptionAgg;
    DROP TABLE IF EXISTS #ActualBoomLedger;
    DROP TABLE IF EXISTS #AppliedBoomSlices;
    DROP TABLE IF EXISTS #GuaranteedBoom;
    DROP TABLE IF EXISTS #Boom;
    DROP TABLE IF EXISTS #Prepared;


    
      /*************************************************************************
        3.5. TARGET-FIRST MATERIALIZATION FOR EXCEL RECOMMENDATIONS

        Performance-only optimization.

        Business-rule behavior remains in Section 4.

        Important:
          * target LPIDs come from Base Labor, not Payroll_Calculated
          * nonzero uncalculated labor entries therefore remain visible
          * the existing Section 4 filters remain authoritative
      *************************************************************************/

      DROP TABLE IF EXISTS #TargetLP;
      DROP TABLE IF EXISTS #WeekDetail;
      DROP TABLE IF EXISTS #TargetEmp;
      DROP TABLE IF EXISTS #EmployeeRate;


      ---------------------------------------------------------------------
      -- Requested payroll-week labor-entry target
      ---------------------------------------------------------------------
      SELECT DISTINCT
          b.LaborPayrollID,
          b.EmpID

      INTO #TargetLP

      FROM app.v_Base_LaborPayroll b

      WHERE b.WorkDate >= @PayStartDate
        AND b.WorkDate < DATEADD(DAY, 1, @PayEndDate)

        AND
        (
            @EmpID IS NULL
            OR b.EmpID = @EmpID
        );


      CREATE UNIQUE CLUSTERED INDEX CX_TargetLP
          ON #TargetLP
             (LaborPayrollID);


      CREATE INDEX IX_TargetLP_EmpID
          ON #TargetLP
             (EmpID);


      ---------------------------------------------------------------------
      -- Materialize the expensive canonical week-detail view only for
      -- labor entries in the requested payroll period.
      ---------------------------------------------------------------------
      SELECT
          w.*

      INTO #WeekDetail

      FROM api.v_UI_Payroll_LaborEntry_WeekDetail_WithBuckets w

      JOIN #TargetLP t
          ON t.LaborPayrollID =
             w.LaborPayrollID;


      CREATE CLUSTERED INDEX CX_WeekDetail_LPID
          ON #WeekDetail
             (LaborPayrollID);


      CREATE INDEX IX_WeekDetail_EmpID
          ON #WeekDetail
             (EmpID);


      ---------------------------------------------------------------------
      -- Limit employee payroll-group/rate expansion to employees that
      -- actually occur in the requested payroll-week population.
      ---------------------------------------------------------------------
      SELECT DISTINCT
          w.EmpID

      INTO #TargetEmp

      FROM #WeekDetail w;


      CREATE UNIQUE CLUSTERED INDEX CX_TargetEmp
          ON #TargetEmp
             (EmpID);


      SELECT
          e.*

      INTO #EmployeeRate

      FROM api.v_UI_Employee_PayrollGroupRate e

      JOIN #TargetEmp t
          ON t.EmpID =
             e.EmpID;


      CREATE INDEX IX_EmployeeRate_EmpID
          ON #EmployeeRate
             (EmpID);


/*************************************************************************
      4. BASE LABOR-ENTRY POPULATION

      Rules:
        * selected authoritative RunId only
        * system/testing/vendor employees excluded
        * PayType S salary employees excluded from hourly export path
        * zero-hour uncalculated placeholders excluded
        * nonzero uncalculated rows retained so they can block export
    *************************************************************************/
    SELECT
        ResolvedRunId =
            @ResolvedRunId,

        PayStartDate =
            @PayStartDate,

        PayEndDate =
            @PayEndDate,


        ---------------------------------------------------------------------
        -- Row identity
        ---------------------------------------------------------------------
        w.LaborPayrollID,

        ResolvedCalcID =
            pc.CalcID,

        ViewCalcID =
            w.CalcID,

        w.JobTicketID,
        w.JobCode,
        w.WoCode,

        WorkDate =
            w.WorkDate_Date,

        w.TimeStart_Labor,
        w.TimeEnd_Labor,


        ---------------------------------------------------------------------
        -- Employee / ADP identity
        ---------------------------------------------------------------------
        w.EmpID,
        w.Employee_Name,

        ADP_FileNumber =
            e.ADP_FileNumber_Clean,

        e.PayrollGroup,
        e.PayrollGroupSort,

        e.PayType,
        e.EmpTypeId,

        Employee_CraftCode =
            e.CraftCode,

        Employee_BaseHourlyRate =
            e.BaseHourlyRate,

        Employee_BaseHourlyRateSource =
            e.BaseHourlyRateSource,

        EmployeeMasterFoundFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN e.EmpID IS NULL THEN 0
                    ELSE 1
                END
            ),

        e.PayrollGroupReviewFlag,
        e.PayrollGroupReviewMessage,

        e.ADP_FileNumberMissingFlag,
        e.ADP_FileNumberInvalidFlag,
        e.ADP_FileNumberReviewFlag,
        e.ADP_FileNumberReviewMessage,


        ---------------------------------------------------------------------
        -- Source FCC labor values
        ---------------------------------------------------------------------
        w.UnitCode,
        w.UnitName,
        w.UnitDescription,

        w.HoursWorked_Raw,
        w.Source_Rate_Raw,
        w.Source_Amount_Raw,

        w.Shift_Code_Raw,

        w.WorkThruLunch,
        w.WorkedThruLunch,

        w.CraftCode,
        w.CraftDescription,
        w.CraftPayRate,

        w.CraftModifierCode,
        w.CraftModifierDescription,
        w.CraftModifierPayRateAdjustment,


        ---------------------------------------------------------------------
        -- Payroll-App resolved rate values
        ---------------------------------------------------------------------
        w.PayrollBaseRate,
        w.PayrollBaseRateSource,

        w.PayrollModifierRate,
        w.PayrollModifierRateSource,

        w.PayrollCombinedRate,
        w.FmsSourceRate,

        w.SourceRateLooksLikePayrollBase,
        w.SourceRateLooksLikePayrollCombined,

        w.SourceRateDifferenceFromPayrollBase,
        w.SourceRateDifferenceFromPayrollCombined,

        w.CraftCodeMismatchFlag,
        w.CraftCodeMismatchMessage,

        w.RateResolutionReviewFlag,
        w.RateResolutionReviewMessage,


        ---------------------------------------------------------------------
        -- Authoritative calculated values
        ---------------------------------------------------------------------
        pc.Act_Total_Hrs,
        pc.Act_Boom_Hrs,
        pc.Gap_Hrs_Total,
        pc.Gap_Hrs_Boom,
        pc.Pay_Total_Hrs,

        pc.Pay_Actual_Gross,
        pc.Pay_Gap_Add,
        pc.Pay_Rest_Add,
        pc.Final_Gross_Pay,


        ---------------------------------------------------------------------
        -- Ordinary payable hour buckets
        ---------------------------------------------------------------------
        Bucket_Actual_Hrs =
            w.Bucket_Actual_Hrs,

        Bucket_Payable_Hrs =
            w.Bucket_Payable_Hrs,

        Bucket_Hrs_ST =
            w.Bucket_Hrs_ST,

        Bucket_Hrs_OT =
            w.Bucket_Hrs_OT,

        Bucket_Hrs_DT =
            w.Bucket_Hrs_DT,

        Bucket_Hrs_H2x =
            w.Bucket_Hrs_H2x,

        Bucket_Hrs_H3x =
            w.Bucket_Hrs_H3x,

        w.Expected_Payable_Hrs,
        w.Bucketed_Payable_Hrs,

        w.Bucket_Hrs_TieOut_Difference,
        w.Bucket_Hrs_TieOut_Status,

        w.Bucket_Source,
        w.Has_Pricing_Slices,
        w.Pricing_Slice_Count,
        w.Pricing_Slice_Hours,

        w.Bucket_Source_Review_Flag,
        w.Bucket_Source_Review_Message,


        ---------------------------------------------------------------------
        -- Rule-level hour / amount audit
        ---------------------------------------------------------------------
        w.Rule_Hrs_Total,
        w.Rule_Hrs_Gap,
        w.Rule_Hrs_ShiftAdd,
        w.Rule_Hrs_WTL_Net,

        w.Rule_Amt_Gap,
        w.Rule_Amt_ShiftAdd,
        w.Rule_Amt_WTL,

        w.Rest_Premium_Hrs_Affected,
        w.Rest_Premium_Amt,

        w.HolidayName,


        ---------------------------------------------------------------------
        -- Existing Payroll App issue state
        ---------------------------------------------------------------------
        w.HasError,
        w.HasWarning,
        w.HasIssue,

        w.ErrorCount,
        w.WarningCount,
        w.TotalIssueCount,

        w.ErrorReasons,
        w.WarningReasons,
        w.AllIssueReasons,


        ---------------------------------------------------------------------
        -- Ticket / source review
        ---------------------------------------------------------------------
        w.Approval_Status,

        w.TicketExpectation,
        w.TicketExpectation_Notes,

        w.JobTicketStatusDisplay,


        ---------------------------------------------------------------------
        -- Current-run calculation control
        ---------------------------------------------------------------------
        HasResolvedCalculatedRow =
            CONVERT
            (
                bit,
                CASE
                    WHEN pc.CalcID IS NULL THEN 0
                    ELSE 1
                END
            ),

        CalcViewMismatchFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN pc.CalcID IS NOT NULL
                     AND
                     (
                            w.CalcID IS NULL
                         OR w.CalcID <> pc.CalcID
                     )
                        THEN 1
                    ELSE 0
                END
            )

    INTO #Base

    FROM #WeekDetail w

    LEFT JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = w.LaborPayrollID
       AND pc.RunId = @ResolvedRunId

    LEFT JOIN #EmployeeRate e
        ON e.EmpID = w.EmpID

    WHERE w.WorkDate_Date >= @PayStartDate
      AND w.WorkDate_Date <= @PayEndDate

      AND
      (
          @EmpID IS NULL
          OR w.EmpID = @EmpID
      )

      AND
      (
          @ADPFileNo IS NULL
          OR UPPER(LTRIM(RTRIM(e.ADP_FileNumber_Clean))) = @ADPFileNo
      )

      ---------------------------------------------------------------------
      -- Payroll UI exclusions
      ---------------------------------------------------------------------
      AND
      (
          e.EmpID IS NULL
          OR ISNULL(e.IsVisibleInPayrollUI, 1) = 1
      )

      AND
      (
          e.EmpID IS NULL
          OR ISNULL(e.IsSystemTestingVendorAccess, 0) = 0
      )

      ---------------------------------------------------------------------
      -- Salary employees are not part of hourly ADP import path
      ---------------------------------------------------------------------
      AND
      (
          e.PayType IS NULL
          OR e.PayType <> 'S'
      )

      ---------------------------------------------------------------------
      -- Exclude zero-hour uncalculated placeholders only
      ---------------------------------------------------------------------
      AND NOT
      (
          pc.CalcID IS NULL
          AND ISNULL(w.HoursWorked_Raw, 0) = 0
      );


    /*************************************************************************
      5. PAY-COMPONENT LEDGER AGGREGATION
    *************************************************************************/
    SELECT
        ppc.LaborPayrollID,

        LedgerRowCount =
            COUNT_BIG(*),


        ---------------------------------------------------------------------
        -- Gross classifications
        ---------------------------------------------------------------------
        LedgerFinalGrossAmount =
            SUM
            (
                CASE
                    WHEN ppc.IncludedInFinalGross = 1
                        THEN ppc.ComponentAmount
                    ELSE 0
                END
            ),

        LedgerPayableGrossAmount =
            SUM
            (
                CASE
                    WHEN ppc.IncludedInPayableGross = 1
                        THEN ppc.ComponentAmount
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- Actual worked pay
        ---------------------------------------------------------------------
        ActualBaseWorkedHours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'ACTUAL_BASE_WORKED_PAY'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        ActualBaseWorkedAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'ACTUAL_BASE_WORKED_PAY'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),

        ActualBoomAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'ACTUAL_BOOM_WORKED_PAY'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- Guarantees
        ---------------------------------------------------------------------
        GuaranteedBaseHours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'GUARANTEED_BASE_PAY_ADD'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        GuaranteedBaseAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'GUARANTEED_BASE_PAY_ADD'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),

        GuaranteedHolidayBaseHours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'GUARANTEED_HOLIDAY_BASE_PAY_ADD'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        GuaranteedHolidayBaseAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'GUARANTEED_HOLIDAY_BASE_PAY_ADD'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),

        GuaranteedSpecialSaturdayBaseHours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        GuaranteedSpecialSaturdayBaseAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- Shift
        ---------------------------------------------------------------------
        ActualShiftDifferentialHours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'ACTUAL_SHIFT_DIFFERENTIAL'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        ActualShiftDifferentialAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'ACTUAL_SHIFT_DIFFERENTIAL'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),

        Shift2HoursAdd =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'SHIFT_2_HOURS_ADD'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        Shift2HoursAddAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'SHIFT_2_HOURS_ADD'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- Rest
        ---------------------------------------------------------------------
        RestPremiumComponentHours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'REST_PERIOD_PREMIUM'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        RestPremiumComponentAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'REST_PERIOD_PREMIUM'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- WTL
        ---------------------------------------------------------------------
        WTLMealDeductHours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'WTL_MEAL_DEDUCT'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        WTLMealDeductAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'WTL_MEAL_DEDUCT'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),

        WTLDTFloorHours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'WTL_DT_FLOOR'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        WTLDTFloorAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'WTL_DT_FLOOR'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),

        WTLApplicableAddHours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'WTL_APPLICABLE_ADD'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        WTLApplicableAddAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'WTL_APPLICABLE_ADD'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),

        WTLNetComponentHours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentGroup = 'WTL'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        WTLNetComponentAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentGroup = 'WTL'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- Subsistence
        ---------------------------------------------------------------------
        SubsistenceShortAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode = 'SUBSISTENCE_SHORT_85'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),

        SubsistenceLongWeekdayAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'SUBSISTENCE_LONG_WEEKDAY_85'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),

        SubsistenceLongWeekendAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'SUBSISTENCE_LONG_WEEKEND_200'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),

        SubsistenceAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentGroup = 'SUBSISTENCE'
                      OR ppc.ComponentCode LIKE 'SUBSISTENCE%'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- Non-union CA nonexempt audit
        ---------------------------------------------------------------------
        NonUnion_ST_Hours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'NONUNION_CA_NONEXEMPT_ST'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        NonUnion_Daily_OT_Hours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'NONUNION_CA_NONEXEMPT_DAILY_OT'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        NonUnion_Weekly_OT_Hours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'NONUNION_CA_NONEXEMPT_WEEKLY_OT'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        NonUnion_7thDay_OT_Hours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'NONUNION_CA_NONEXEMPT_7TH_DAY_OT'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        NonUnion_Daily_DT_Hours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'NONUNION_CA_NONEXEMPT_DAILY_DT'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        NonUnion_7thDay_DT_Hours =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'NONUNION_CA_NONEXEMPT_7TH_DAY_DT'
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- Rounding
        ---------------------------------------------------------------------
        RoundingAdjustmentAmount =
            SUM
            (
                CASE
                    WHEN ppc.ComponentCode =
                         'PAY_COMPONENT_ROUNDING_ADJUSTMENT'
                        THEN ISNULL(ppc.ComponentAmount, 0)
                    ELSE 0
                END
            )

    INTO #ComponentAgg

    FROM fms.Payroll_PayComponent ppc

    JOIN #Base b
        ON b.LaborPayrollID = ppc.LaborPayrollID

    WHERE ppc.RunId = @ResolvedRunId

    GROUP BY
        ppc.LaborPayrollID;


    /*************************************************************************
      6. UNKNOWN / FUTURE COMPONENT PROTECTION

      Any new component code must be reviewed before Excel silently consumes it.
    *************************************************************************/
    SELECT
        ppc.LaborPayrollID,

        UnhandledComponentCount =
            COUNT_BIG(*),

        UnhandledComponentAmount =
            SUM(ISNULL(ppc.ComponentAmount, 0)),

        UnhandledComponentCodes =
            STRING_AGG
            (
                CONVERT(nvarchar(max), ppc.ComponentCode),
                N' | '
            )

    INTO #UnhandledComponents

    FROM fms.Payroll_PayComponent ppc

    JOIN #Base b
        ON b.LaborPayrollID = ppc.LaborPayrollID

    WHERE ppc.RunId = @ResolvedRunId

      AND ppc.ComponentCode NOT IN
      (
          'ACTUAL_BASE_WORKED_PAY',
          'ACTUAL_BOOM_WORKED_PAY',
          'ACTUAL_SHIFT_DIFFERENTIAL',

          'GUARANTEED_BASE_PAY_ADD',
          'GUARANTEED_BOOM_PAY_ADD',
          'GUARANTEED_HOLIDAY_BASE_PAY_ADD',
          'GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD',

          'SHIFT_2_HOURS_ADD',

          'REST_PERIOD_PREMIUM',

          'WTL_MEAL_DEDUCT',
          'WTL_DT_FLOOR',
          'WTL_APPLICABLE_ADD',

          'SUBSISTENCE_SHORT_85',
          'SUBSISTENCE_LONG_WEEKDAY_85',
          'SUBSISTENCE_LONG_WEEKEND_200',

          'NONUNION_CA_NONEXEMPT_ST',
          'NONUNION_CA_NONEXEMPT_DAILY_OT',
          'NONUNION_CA_NONEXEMPT_WEEKLY_OT',
          'NONUNION_CA_NONEXEMPT_7TH_DAY_OT',
          'NONUNION_CA_NONEXEMPT_DAILY_DT',
          'NONUNION_CA_NONEXEMPT_7TH_DAY_DT',

          'PAY_COMPONENT_ROUNDING_ADJUSTMENT'
      )

    GROUP BY
        ppc.LaborPayrollID;


    /*************************************************************************
      7. CURRENT-RUN EXCEPTIONS

      Exception rows are review information unless another explicit blocking
      control makes the labor entry non-exportable.
    *************************************************************************/
    SELECT
        e.LaborPayrollID,

        ExceptionCount =
            COUNT_BIG(*),

        WTLWarningCount =
            SUM
            (
                CASE
                    WHEN e.Reason LIKE 'WTL warning:%'
                        THEN 1
                    ELSE 0
                END
            ),

        ExceptionReasons =
            STRING_AGG
            (
                CONVERT(nvarchar(max), e.Reason),
                N' | '
            )

    INTO #ExceptionAgg

    FROM fms.Payroll_CalcException e

    JOIN #Base b
        ON b.LaborPayrollID = e.LaborPayrollID

    WHERE e.RunId = @ResolvedRunId
      AND e.WorkDate >= @PayStartDate
      AND e.WorkDate < DATEADD(DAY, 1, @PayEndDate)

    GROUP BY
        e.LaborPayrollID;


    /*************************************************************************
      8. ACTUAL BOOM LEDGER AUTHORIZATION
    *************************************************************************/
    SELECT
        ppc.LaborPayrollID,

        BoomLedgerActualRows =
            COUNT_BIG(*),

        BoomLedgerActualHours =
            SUM(ISNULL(ppc.ComponentHours, 0)),

        BoomLedgerActualAmount =
            SUM(ISNULL(ppc.ComponentAmount, 0))

    INTO #ActualBoomLedger

    FROM fms.Payroll_PayComponent ppc

    JOIN #Base b
        ON b.LaborPayrollID = ppc.LaborPayrollID

    WHERE ppc.RunId = @ResolvedRunId
      AND ppc.ComponentCode = 'ACTUAL_BOOM_WORKED_PAY'

    GROUP BY
        ppc.LaborPayrollID;


    /*************************************************************************
      9. PRICING-SLICE ACTUAL BOOM CLASSIFICATION

      Pricing slices classify authorized actual boom hours.

      Final_Multiplier:
          1.00 -> LB ST
          1.50 -> LB OT
          2.00 -> LB DT
          3.00 -> LB 3X

      Temporary ADP add-on rate:
          Rate_Boom_Applied * Final_Multiplier
    *************************************************************************/
    SELECT
        ps.LaborPayrollID,

        AppliedBoomSliceHours =
            SUM(ISNULL(ps.Slice_Hours, 0)),

        AppliedBoomSliceCount =
            COUNT_BIG(*),


        ---------------------------------------------------------------------
        -- Hours
        ---------------------------------------------------------------------
        Actual_LB_ST_Hours =
            SUM
            (
                CASE
                    WHEN ps.Final_Multiplier = 1.00
                        THEN ISNULL(ps.Slice_Hours, 0)
                    ELSE 0
                END
            ),

        Actual_LB_OT_Hours =
            SUM
            (
                CASE
                    WHEN ps.Final_Multiplier = 1.50
                        THEN ISNULL(ps.Slice_Hours, 0)
                    ELSE 0
                END
            ),

        Actual_LB_DT_Hours =
            SUM
            (
                CASE
                    WHEN ps.Final_Multiplier = 2.00
                        THEN ISNULL(ps.Slice_Hours, 0)
                    ELSE 0
                END
            ),

        Actual_LB_3X_Hours =
            SUM
            (
                CASE
                    WHEN ps.Final_Multiplier = 3.00
                        THEN ISNULL(ps.Slice_Hours, 0)
                    ELSE 0
                END
            ),

        UnclassifiedActualBoomHours =
            SUM
            (
                CASE
                    WHEN ps.Final_Multiplier NOT IN
                    (
                        1.00,
                        1.50,
                        2.00,
                        3.00
                    )
                        THEN ISNULL(ps.Slice_Hours, 0)
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- LB ST rate
        ---------------------------------------------------------------------
        Actual_LB_ST_RateMin =
            MIN
            (
                CASE
                    WHEN ps.Final_Multiplier = 1.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ps.Rate_Boom_Applied
                                 * ps.Final_Multiplier
                             )
                END
            ),

        Actual_LB_ST_RateMax =
            MAX
            (
                CASE
                    WHEN ps.Final_Multiplier = 1.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ps.Rate_Boom_Applied
                                 * ps.Final_Multiplier
                             )
                END
            ),


        ---------------------------------------------------------------------
        -- LB OT rate
        ---------------------------------------------------------------------
        Actual_LB_OT_RateMin =
            MIN
            (
                CASE
                    WHEN ps.Final_Multiplier = 1.50
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ps.Rate_Boom_Applied
                                 * ps.Final_Multiplier
                             )
                END
            ),

        Actual_LB_OT_RateMax =
            MAX
            (
                CASE
                    WHEN ps.Final_Multiplier = 1.50
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ps.Rate_Boom_Applied
                                 * ps.Final_Multiplier
                             )
                END
            ),


        ---------------------------------------------------------------------
        -- LB DT rate
        ---------------------------------------------------------------------
        Actual_LB_DT_RateMin =
            MIN
            (
                CASE
                    WHEN ps.Final_Multiplier = 2.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ps.Rate_Boom_Applied
                                 * ps.Final_Multiplier
                             )
                END
            ),

        Actual_LB_DT_RateMax =
            MAX
            (
                CASE
                    WHEN ps.Final_Multiplier = 2.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ps.Rate_Boom_Applied
                                 * ps.Final_Multiplier
                             )
                END
            ),


        ---------------------------------------------------------------------
        -- LB 3X rate
        ---------------------------------------------------------------------
        Actual_LB_3X_RateMin =
            MIN
            (
                CASE
                    WHEN ps.Final_Multiplier = 3.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ps.Rate_Boom_Applied
                                 * ps.Final_Multiplier
                             )
                END
            ),

        Actual_LB_3X_RateMax =
            MAX
            (
                CASE
                    WHEN ps.Final_Multiplier = 3.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ps.Rate_Boom_Applied
                                 * ps.Final_Multiplier
                             )
                END
            )

    INTO #AppliedBoomSlices

    FROM api.v_UI_Pricing_Slices_PayrollEffective ps

    JOIN #Base b
        ON b.LaborPayrollID = ps.LaborPayrollID

    WHERE ps.Is_Boom_Active = 1
      AND ISNULL(ps.Rate_Boom_Applied, 0) <> 0

    GROUP BY
        ps.LaborPayrollID;


    /*************************************************************************
      10. GUARANTEED BOOM

      Guaranteed boom authorization, classification, and rate all come
      directly from fms.Payroll_PayComponent.
    *************************************************************************/
    SELECT
        ppc.LaborPayrollID,

        GuaranteedBoomRows =
            COUNT_BIG(*),

        GuaranteedBoomHours =
            SUM(ISNULL(ppc.ComponentHours, 0)),

        GuaranteedBoomAmount =
            SUM(ISNULL(ppc.ComponentAmount, 0)),


        ---------------------------------------------------------------------
        -- Hours
        ---------------------------------------------------------------------
        Guaranteed_LB_ST_Hours =
            SUM
            (
                CASE
                    WHEN ppc.MultiplierUsed = 1.00
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        Guaranteed_LB_OT_Hours =
            SUM
            (
                CASE
                    WHEN ppc.MultiplierUsed = 1.50
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        Guaranteed_LB_DT_Hours =
            SUM
            (
                CASE
                    WHEN ppc.MultiplierUsed = 2.00
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        Guaranteed_LB_3X_Hours =
            SUM
            (
                CASE
                    WHEN ppc.MultiplierUsed = 3.00
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),

        UnclassifiedGuaranteedBoomHours =
            SUM
            (
                CASE
                    WHEN ppc.MultiplierUsed NOT IN
                    (
                        1.00,
                        1.50,
                        2.00,
                        3.00
                    )
                    OR ppc.MultiplierUsed IS NULL
                        THEN ISNULL(ppc.ComponentHours, 0)
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- LB ST rate
        ---------------------------------------------------------------------
        Guaranteed_LB_ST_RateMin =
            MIN
            (
                CASE
                    WHEN ppc.MultiplierUsed = 1.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ppc.RateBoomUsed
                                 * ppc.MultiplierUsed
                             )
                END
            ),

        Guaranteed_LB_ST_RateMax =
            MAX
            (
                CASE
                    WHEN ppc.MultiplierUsed = 1.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ppc.RateBoomUsed
                                 * ppc.MultiplierUsed
                             )
                END
            ),


        ---------------------------------------------------------------------
        -- LB OT rate
        ---------------------------------------------------------------------
        Guaranteed_LB_OT_RateMin =
            MIN
            (
                CASE
                    WHEN ppc.MultiplierUsed = 1.50
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ppc.RateBoomUsed
                                 * ppc.MultiplierUsed
                             )
                END
            ),

        Guaranteed_LB_OT_RateMax =
            MAX
            (
                CASE
                    WHEN ppc.MultiplierUsed = 1.50
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ppc.RateBoomUsed
                                 * ppc.MultiplierUsed
                             )
                END
            ),


        ---------------------------------------------------------------------
        -- LB DT rate
        ---------------------------------------------------------------------
        Guaranteed_LB_DT_RateMin =
            MIN
            (
                CASE
                    WHEN ppc.MultiplierUsed = 2.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ppc.RateBoomUsed
                                 * ppc.MultiplierUsed
                             )
                END
            ),

        Guaranteed_LB_DT_RateMax =
            MAX
            (
                CASE
                    WHEN ppc.MultiplierUsed = 2.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ppc.RateBoomUsed
                                 * ppc.MultiplierUsed
                             )
                END
            ),


        ---------------------------------------------------------------------
        -- LB 3X rate
        ---------------------------------------------------------------------
        Guaranteed_LB_3X_RateMin =
            MIN
            (
                CASE
                    WHEN ppc.MultiplierUsed = 3.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ppc.RateBoomUsed
                                 * ppc.MultiplierUsed
                             )
                END
            ),

        Guaranteed_LB_3X_RateMax =
            MAX
            (
                CASE
                    WHEN ppc.MultiplierUsed = 3.00
                        THEN CONVERT
                             (
                                 decimal(12,4),
                                 ppc.RateBoomUsed
                                 * ppc.MultiplierUsed
                             )
                END
            )

    INTO #GuaranteedBoom

    FROM fms.Payroll_PayComponent ppc

    JOIN #Base b
        ON b.LaborPayrollID = ppc.LaborPayrollID

    WHERE ppc.RunId = @ResolvedRunId
      AND ppc.ComponentCode = 'GUARANTEED_BOOM_PAY_ADD'

    GROUP BY
        ppc.LaborPayrollID;


    /*************************************************************************
      11. COMBINE ACTUAL + GUARANTEED BOOM
    *************************************************************************/
    SELECT
        b.LaborPayrollID,


        ---------------------------------------------------------------------
        -- Pricing-slice diagnostic
        ---------------------------------------------------------------------
        AppliedBoomSliceHours =
            ISNULL(s.AppliedBoomSliceHours, 0),

        AppliedBoomSliceCount =
            ISNULL(s.AppliedBoomSliceCount, 0),


        ---------------------------------------------------------------------
        -- Ledger actual boom authorization
        ---------------------------------------------------------------------
        BoomLedgerActualRows =
            ISNULL(a.BoomLedgerActualRows, 0),

        BoomLedgerActualHours =
            ISNULL(a.BoomLedgerActualHours, 0),

        BoomLedgerActualAmount =
            ISNULL(a.BoomLedgerActualAmount, 0),

        BoomSliceClassifiedHours =
            ISNULL(s.AppliedBoomSliceHours, 0),

        BoomBucketDifference =
            CONVERT
            (
                decimal(10,2),
                ISNULL(s.AppliedBoomSliceHours, 0)
                - ISNULL(a.BoomLedgerActualHours, 0)
            ),

        UnclassifiedActualBoomHours =
            ISNULL(s.UnclassifiedActualBoomHours, 0),


        ---------------------------------------------------------------------
        -- Actual boom export hours only if ledger-authorized
        ---------------------------------------------------------------------
        Actual_LB_ST_Hours =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN ISNULL(s.Actual_LB_ST_Hours, 0)
                ELSE 0
            END,

        Actual_LB_OT_Hours =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN ISNULL(s.Actual_LB_OT_Hours, 0)
                ELSE 0
            END,

        Actual_LB_DT_Hours =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN ISNULL(s.Actual_LB_DT_Hours, 0)
                ELSE 0
            END,

        Actual_LB_3X_Hours =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN ISNULL(s.Actual_LB_3X_Hours, 0)
                ELSE 0
            END,


        ---------------------------------------------------------------------
        -- Actual rates
        ---------------------------------------------------------------------
        Actual_LB_ST_RateMin =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN s.Actual_LB_ST_RateMin
            END,

        Actual_LB_ST_RateMax =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN s.Actual_LB_ST_RateMax
            END,

        Actual_LB_OT_RateMin =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN s.Actual_LB_OT_RateMin
            END,

        Actual_LB_OT_RateMax =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN s.Actual_LB_OT_RateMax
            END,

        Actual_LB_DT_RateMin =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN s.Actual_LB_DT_RateMin
            END,

        Actual_LB_DT_RateMax =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN s.Actual_LB_DT_RateMax
            END,

        Actual_LB_3X_RateMin =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN s.Actual_LB_3X_RateMin
            END,

        Actual_LB_3X_RateMax =
            CASE
                WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                    THEN s.Actual_LB_3X_RateMax
            END,


        ---------------------------------------------------------------------
        -- Guaranteed boom
        ---------------------------------------------------------------------
        GuaranteedBoomRows =
            ISNULL(g.GuaranteedBoomRows, 0),

        GuaranteedBoomHours =
            ISNULL(g.GuaranteedBoomHours, 0),

        GuaranteedBoomAmount =
            ISNULL(g.GuaranteedBoomAmount, 0),

        Guaranteed_LB_ST_Hours =
            ISNULL(g.Guaranteed_LB_ST_Hours, 0),

        Guaranteed_LB_OT_Hours =
            ISNULL(g.Guaranteed_LB_OT_Hours, 0),

        Guaranteed_LB_DT_Hours =
            ISNULL(g.Guaranteed_LB_DT_Hours, 0),

        Guaranteed_LB_3X_Hours =
            ISNULL(g.Guaranteed_LB_3X_Hours, 0),

        UnclassifiedGuaranteedBoomHours =
            ISNULL(g.UnclassifiedGuaranteedBoomHours, 0),

        g.Guaranteed_LB_ST_RateMin,
        g.Guaranteed_LB_ST_RateMax,

        g.Guaranteed_LB_OT_RateMin,
        g.Guaranteed_LB_OT_RateMax,

        g.Guaranteed_LB_DT_RateMin,
        g.Guaranteed_LB_DT_RateMax,

        g.Guaranteed_LB_3X_RateMin,
        g.Guaranteed_LB_3X_RateMax,


        ---------------------------------------------------------------------
        -- Final long-boom quantities
        ---------------------------------------------------------------------
        LB_ST_Hours =
              CASE
                  WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                      THEN ISNULL(s.Actual_LB_ST_Hours, 0)
                  ELSE 0
              END
            + ISNULL(g.Guaranteed_LB_ST_Hours, 0),

        LB_OT_Hours =
              CASE
                  WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                      THEN ISNULL(s.Actual_LB_OT_Hours, 0)
                  ELSE 0
              END
            + ISNULL(g.Guaranteed_LB_OT_Hours, 0),

        LB_DT_Hours =
              CASE
                  WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                      THEN ISNULL(s.Actual_LB_DT_Hours, 0)
                  ELSE 0
              END
            + ISNULL(g.Guaranteed_LB_DT_Hours, 0),

        LB_3X_Hours =
              CASE
                  WHEN ISNULL(a.BoomLedgerActualRows, 0) > 0
                      THEN ISNULL(s.Actual_LB_3X_Hours, 0)
                  ELSE 0
              END
            + ISNULL(g.Guaranteed_LB_3X_Hours, 0)

    INTO #Boom

    FROM #Base b

    LEFT JOIN #ActualBoomLedger a
        ON a.LaborPayrollID = b.LaborPayrollID

    LEFT JOIN #AppliedBoomSlices s
        ON s.LaborPayrollID = b.LaborPayrollID

    LEFT JOIN #GuaranteedBoom g
        ON g.LaborPayrollID = b.LaborPayrollID;


    /*************************************************************************
      12. PREPARE BLOCKING / REVIEW FLAGS
    *************************************************************************/
    SELECT
        b.*,


        ---------------------------------------------------------------------
        -- Ledger amounts
        ---------------------------------------------------------------------
        LedgerRowCount =
            ISNULL(c.LedgerRowCount, 0),

        LedgerFinalGrossAmount =
            ISNULL(c.LedgerFinalGrossAmount, 0),

        LedgerPayableGrossAmount =
            ISNULL(c.LedgerPayableGrossAmount, 0),


        ---------------------------------------------------------------------
        -- NEW:
        -- Expected final ledger gross

        -- Validated Run 698 relationship:
        --
        --     Payroll_Calculated.Final_Gross_Pay
        --   + WTL ledger adjustments
        --   =
        --     PayComponent IncludedInFinalGross total
        ---------------------------------------------------------------------
        ExpectedLedgerFinalGross =
            CONVERT
            (
                decimal(19,4),
                  ISNULL(b.Final_Gross_Pay, 0)
                + ISNULL(c.WTLNetComponentAmount, 0)
            ),

        LedgerReconciliationDifference =
            CONVERT
            (
                decimal(19,4),
                ISNULL(c.LedgerFinalGrossAmount, 0)
                -
                (
                    ISNULL(b.Final_Gross_Pay, 0)
                    + ISNULL(c.WTLNetComponentAmount, 0)
                )
            ),


        ---------------------------------------------------------------------
        -- NEW:
        -- Informational payable-only amount.

        -- Do NOT treat this as an error.
        -- In Run 698 / July 25-31 this totals $1,020 and is subsistence.
        ---------------------------------------------------------------------
        LedgerAdditionalPayableAmount =
            CONVERT
            (
                decimal(19,4),
                  ISNULL(c.LedgerPayableGrossAmount, 0)
                - ISNULL(c.LedgerFinalGrossAmount, 0)
            ),


        ---------------------------------------------------------------------
        -- Component audit
        ---------------------------------------------------------------------
        ActualBaseWorkedHours =
            ISNULL(c.ActualBaseWorkedHours, 0),

        ActualBaseWorkedAmount =
            ISNULL(c.ActualBaseWorkedAmount, 0),

        ActualBoomAmount =
            ISNULL(c.ActualBoomAmount, 0),

        GuaranteedBaseHours =
            ISNULL(c.GuaranteedBaseHours, 0),

        GuaranteedBaseAmount =
            ISNULL(c.GuaranteedBaseAmount, 0),

        GuaranteedHolidayBaseHours =
            ISNULL(c.GuaranteedHolidayBaseHours, 0),

        GuaranteedHolidayBaseAmount =
            ISNULL(c.GuaranteedHolidayBaseAmount, 0),

        GuaranteedSpecialSaturdayBaseHours =
            ISNULL(c.GuaranteedSpecialSaturdayBaseHours, 0),

        GuaranteedSpecialSaturdayBaseAmount =
            ISNULL(c.GuaranteedSpecialSaturdayBaseAmount, 0),

        ActualShiftDifferentialHours =
            ISNULL(c.ActualShiftDifferentialHours, 0),

        ActualShiftDifferentialAmount =
            ISNULL(c.ActualShiftDifferentialAmount, 0),

        Shift2HoursAdd =
            ISNULL(c.Shift2HoursAdd, 0),

        Shift2HoursAddAmount =
            ISNULL(c.Shift2HoursAddAmount, 0),

        RestPremiumComponentHours =
            ISNULL(c.RestPremiumComponentHours, 0),

        RestPremiumComponentAmount =
            ISNULL(c.RestPremiumComponentAmount, 0),

        WTLMealDeductHours =
            ISNULL(c.WTLMealDeductHours, 0),

        WTLMealDeductAmount =
            ISNULL(c.WTLMealDeductAmount, 0),

        WTLDTFloorHours =
            ISNULL(c.WTLDTFloorHours, 0),

        WTLDTFloorAmount =
            ISNULL(c.WTLDTFloorAmount, 0),

        WTLApplicableAddHours =
            ISNULL(c.WTLApplicableAddHours, 0),

        WTLApplicableAddAmount =
            ISNULL(c.WTLApplicableAddAmount, 0),

        WTLNetComponentHours =
            ISNULL(c.WTLNetComponentHours, 0),

        WTLNetComponentAmount =
            ISNULL(c.WTLNetComponentAmount, 0),

        SubsistenceShortAmount =
            ISNULL(c.SubsistenceShortAmount, 0),

        SubsistenceLongWeekdayAmount =
            ISNULL(c.SubsistenceLongWeekdayAmount, 0),

        SubsistenceLongWeekendAmount =
            ISNULL(c.SubsistenceLongWeekendAmount, 0),

        SubsistenceAmount =
            ISNULL(c.SubsistenceAmount, 0),

        NonUnion_ST_Hours =
            ISNULL(c.NonUnion_ST_Hours, 0),

        NonUnion_Daily_OT_Hours =
            ISNULL(c.NonUnion_Daily_OT_Hours, 0),

        NonUnion_Weekly_OT_Hours =
            ISNULL(c.NonUnion_Weekly_OT_Hours, 0),

        NonUnion_7thDay_OT_Hours =
            ISNULL(c.NonUnion_7thDay_OT_Hours, 0),

        NonUnion_Daily_DT_Hours =
            ISNULL(c.NonUnion_Daily_DT_Hours, 0),

        NonUnion_7thDay_DT_Hours =
            ISNULL(c.NonUnion_7thDay_DT_Hours, 0),

        RoundingAdjustmentAmount =
            ISNULL(c.RoundingAdjustmentAmount, 0),


        ---------------------------------------------------------------------
        -- Exceptions
        ---------------------------------------------------------------------
        ExceptionCount =
            ISNULL(x.ExceptionCount, 0),

        WTLWarningCount =
            ISNULL(x.WTLWarningCount, 0),

        x.ExceptionReasons,


        ---------------------------------------------------------------------
        -- Boom
        ---------------------------------------------------------------------
        bm.AppliedBoomSliceHours,
        bm.AppliedBoomSliceCount,

        bm.BoomLedgerActualRows,
        bm.BoomLedgerActualHours,
        bm.BoomLedgerActualAmount,

        bm.BoomSliceClassifiedHours,
        bm.BoomBucketDifference,

        bm.UnclassifiedActualBoomHours,

        bm.Actual_LB_ST_Hours,
        bm.Actual_LB_OT_Hours,
        bm.Actual_LB_DT_Hours,
        bm.Actual_LB_3X_Hours,

        bm.Actual_LB_ST_RateMin,
        bm.Actual_LB_ST_RateMax,

        bm.Actual_LB_OT_RateMin,
        bm.Actual_LB_OT_RateMax,

        bm.Actual_LB_DT_RateMin,
        bm.Actual_LB_DT_RateMax,

        bm.Actual_LB_3X_RateMin,
        bm.Actual_LB_3X_RateMax,

        bm.GuaranteedBoomRows,
        bm.GuaranteedBoomHours,
        bm.GuaranteedBoomAmount,

        bm.Guaranteed_LB_ST_Hours,
        bm.Guaranteed_LB_OT_Hours,
        bm.Guaranteed_LB_DT_Hours,
        bm.Guaranteed_LB_3X_Hours,

        bm.UnclassifiedGuaranteedBoomHours,

        bm.Guaranteed_LB_ST_RateMin,
        bm.Guaranteed_LB_ST_RateMax,

        bm.Guaranteed_LB_OT_RateMin,
        bm.Guaranteed_LB_OT_RateMax,

        bm.Guaranteed_LB_DT_RateMin,
        bm.Guaranteed_LB_DT_RateMax,

        bm.Guaranteed_LB_3X_RateMin,
        bm.Guaranteed_LB_3X_RateMax,

        bm.LB_ST_Hours,
        bm.LB_OT_Hours,
        bm.LB_DT_Hours,
        bm.LB_3X_Hours,


        ---------------------------------------------------------------------
        -- Unknown future components
        ---------------------------------------------------------------------
        UnhandledComponentCount =
            ISNULL(u.UnhandledComponentCount, 0),

        UnhandledComponentAmount =
            ISNULL(u.UnhandledComponentAmount, 0),

        u.UnhandledComponentCodes,


        /*********************************************************************
          BLOCKING FLAGS
        *********************************************************************/

        EmployeeMasterMissingFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN b.EmployeeMasterFoundFlag = 0
                        THEN 1
                    ELSE 0
                END
            ),

        UncalculatedNonzeroHoursFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN b.ResolvedCalcID IS NULL
                     AND ISNULL(b.HoursWorked_Raw, 0) <> 0
                        THEN 1
                    ELSE 0
                END
            ),

        MissingSourceRateFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN ISNULL(b.HoursWorked_Raw, 0) <> 0
                     AND ISNULL(b.Source_Rate_Raw, 0) = 0
                        THEN 1
                    ELSE 0
                END
            ),

        BucketTieOutBlockingFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN b.ResolvedCalcID IS NOT NULL
                     AND
                     (
                            ISNULL
                            (
                                b.Bucket_Hrs_TieOut_Status,
                                ''
                            ) <> 'Balanced'

                         OR ABS
                            (
                                ISNULL
                                (
                                    b.Bucket_Hrs_TieOut_Difference,
                                    0
                                )
                            ) > 0.01
                     )
                        THEN 1
                    ELSE 0
                END
            ),

        BoomTieOutBlockingFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN
                    (
                        ISNULL(bm.BoomLedgerActualRows, 0) > 0
                        AND
                        (
                               ISNULL(bm.BoomSliceClassifiedHours, 0) = 0

                            OR ABS
                               (
                                   ISNULL
                                   (
                                       bm.BoomBucketDifference,
                                       0
                                   )
                               ) > 0.01

                            OR ABS
                               (
                                   ISNULL
                                   (
                                       bm.UnclassifiedActualBoomHours,
                                       0
                                   )
                               ) > 0.01
                        )
                    )

                    OR ABS
                       (
                           ISNULL
                           (
                               bm.UnclassifiedGuaranteedBoomHours,
                               0
                           )
                       ) > 0.01
                        THEN 1
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- Long-boom temporary rate must resolve to one rate per bucket
        ---------------------------------------------------------------------
        BoomRateBlockingFlag =
            CONVERT
            (
                bit,
                CASE

                    ---------------------------------------------------------
                    -- LB ST
                    ---------------------------------------------------------
                    WHEN
                    (
                        ISNULL(bm.LB_ST_Hours, 0) <> 0

                        AND
                        (
                            (
                                ISNULL(bm.Actual_LB_ST_Hours, 0) <> 0
                                AND
                                (
                                       bm.Actual_LB_ST_RateMin IS NULL
                                    OR bm.Actual_LB_ST_RateMax IS NULL
                                    OR ABS
                                       (
                                           bm.Actual_LB_ST_RateMax
                                           - bm.Actual_LB_ST_RateMin
                                       ) > 0.0001
                                )
                            )

                            OR

                            (
                                ISNULL
                                (
                                    bm.Guaranteed_LB_ST_Hours,
                                    0
                                ) <> 0

                                AND
                                (
                                       bm.Guaranteed_LB_ST_RateMin IS NULL
                                    OR bm.Guaranteed_LB_ST_RateMax IS NULL
                                    OR ABS
                                       (
                                           bm.Guaranteed_LB_ST_RateMax
                                           - bm.Guaranteed_LB_ST_RateMin
                                       ) > 0.0001
                                )
                            )

                            OR

                            (
                                ISNULL(bm.Actual_LB_ST_Hours, 0) <> 0
                                AND ISNULL
                                    (
                                        bm.Guaranteed_LB_ST_Hours,
                                        0
                                    ) <> 0

                                AND ABS
                                    (
                                        bm.Actual_LB_ST_RateMin
                                        - bm.Guaranteed_LB_ST_RateMin
                                    ) > 0.0001
                            )
                        )
                    )


                    ---------------------------------------------------------
                    -- LB OT
                    ---------------------------------------------------------
                    OR
                    (
                        ISNULL(bm.LB_OT_Hours, 0) <> 0

                        AND
                        (
                            (
                                ISNULL(bm.Actual_LB_OT_Hours, 0) <> 0
                                AND
                                (
                                       bm.Actual_LB_OT_RateMin IS NULL
                                    OR bm.Actual_LB_OT_RateMax IS NULL
                                    OR ABS
                                       (
                                           bm.Actual_LB_OT_RateMax
                                           - bm.Actual_LB_OT_RateMin
                                       ) > 0.0001
                                )
                            )

                            OR

                            (
                                ISNULL
                                (
                                    bm.Guaranteed_LB_OT_Hours,
                                    0
                                ) <> 0

                                AND
                                (
                                       bm.Guaranteed_LB_OT_RateMin IS NULL
                                    OR bm.Guaranteed_LB_OT_RateMax IS NULL
                                    OR ABS
                                       (
                                           bm.Guaranteed_LB_OT_RateMax
                                           - bm.Guaranteed_LB_OT_RateMin
                                       ) > 0.0001
                                )
                            )

                            OR

                            (
                                ISNULL(bm.Actual_LB_OT_Hours, 0) <> 0
                                AND ISNULL
                                    (
                                        bm.Guaranteed_LB_OT_Hours,
                                        0
                                    ) <> 0

                                AND ABS
                                    (
                                        bm.Actual_LB_OT_RateMin
                                        - bm.Guaranteed_LB_OT_RateMin
                                    ) > 0.0001
                            )
                        )
                    )


                    ---------------------------------------------------------
                    -- LB DT
                    ---------------------------------------------------------
                    OR
                    (
                        ISNULL(bm.LB_DT_Hours, 0) <> 0

                        AND
                        (
                            (
                                ISNULL(bm.Actual_LB_DT_Hours, 0) <> 0
                                AND
                                (
                                       bm.Actual_LB_DT_RateMin IS NULL
                                    OR bm.Actual_LB_DT_RateMax IS NULL
                                    OR ABS
                                       (
                                           bm.Actual_LB_DT_RateMax
                                           - bm.Actual_LB_DT_RateMin
                                       ) > 0.0001
                                )
                            )

                            OR

                            (
                                ISNULL
                                (
                                    bm.Guaranteed_LB_DT_Hours,
                                    0
                                ) <> 0

                                AND
                                (
                                       bm.Guaranteed_LB_DT_RateMin IS NULL
                                    OR bm.Guaranteed_LB_DT_RateMax IS NULL
                                    OR ABS
                                       (
                                           bm.Guaranteed_LB_DT_RateMax
                                           - bm.Guaranteed_LB_DT_RateMin
                                       ) > 0.0001
                                )
                            )

                            OR

                            (
                                ISNULL(bm.Actual_LB_DT_Hours, 0) <> 0
                                AND ISNULL
                                    (
                                        bm.Guaranteed_LB_DT_Hours,
                                        0
                                    ) <> 0

                                AND ABS
                                    (
                                        bm.Actual_LB_DT_RateMin
                                        - bm.Guaranteed_LB_DT_RateMin
                                    ) > 0.0001
                            )
                        )
                    )


                    ---------------------------------------------------------
                    -- LB 3X
                    ---------------------------------------------------------
                    OR
                    (
                        ISNULL(bm.LB_3X_Hours, 0) <> 0

                        AND
                        (
                            (
                                ISNULL(bm.Actual_LB_3X_Hours, 0) <> 0
                                AND
                                (
                                       bm.Actual_LB_3X_RateMin IS NULL
                                    OR bm.Actual_LB_3X_RateMax IS NULL
                                    OR ABS
                                       (
                                           bm.Actual_LB_3X_RateMax
                                           - bm.Actual_LB_3X_RateMin
                                       ) > 0.0001
                                )
                            )

                            OR

                            (
                                ISNULL
                                (
                                    bm.Guaranteed_LB_3X_Hours,
                                    0
                                ) <> 0

                                AND
                                (
                                       bm.Guaranteed_LB_3X_RateMin IS NULL
                                    OR bm.Guaranteed_LB_3X_RateMax IS NULL
                                    OR ABS
                                       (
                                           bm.Guaranteed_LB_3X_RateMax
                                           - bm.Guaranteed_LB_3X_RateMin
                                       ) > 0.0001
                                )
                            )

                            OR

                            (
                                ISNULL(bm.Actual_LB_3X_Hours, 0) <> 0
                                AND ISNULL
                                    (
                                        bm.Guaranteed_LB_3X_Hours,
                                        0
                                    ) <> 0

                                AND ABS
                                    (
                                        bm.Actual_LB_3X_RateMin
                                        - bm.Guaranteed_LB_3X_RateMin
                                    ) > 0.0001
                            )
                        )
                    )

                        THEN 1
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- Calculated pay exists but ledger does not
        ---------------------------------------------------------------------
        MissingLedgerForPayFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN b.ResolvedCalcID IS NOT NULL
                     AND ISNULL(c.LedgerRowCount, 0) = 0
                     AND
                     (
                            ABS(ISNULL(b.Final_Gross_Pay, 0)) > 0.005
                         OR ABS(ISNULL(b.Pay_Rest_Add, 0)) > 0.005
                     )
                        THEN 1
                    ELSE 0
                END
            ),


        ---------------------------------------------------------------------
        -- NEW:
        -- Calculated final gross + WTL must reconcile to IncludedInFinalGross
        ---------------------------------------------------------------------
        LedgerReconciliationBlockingFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN b.ResolvedCalcID IS NOT NULL
                     AND ISNULL(c.LedgerRowCount, 0) > 0
                     AND ABS
                         (
                             ISNULL(c.LedgerFinalGrossAmount, 0)
                             -
                             (
                                 ISNULL(b.Final_Gross_Pay, 0)
                                 + ISNULL(c.WTLNetComponentAmount, 0)
                             )
                         ) > 0.01
                        THEN 1
                    ELSE 0
                END
            ),


        PayrollAppErrorBlockingFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN ISNULL(b.HasError, 0) = 1
                        THEN 1
                    ELSE 0
                END
            ),

        ADPFileNumberBlockingFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN ISNULL(b.ADP_FileNumberReviewFlag, 0) = 1
                        THEN 1
                    ELSE 0
                END
            ),

        PayrollGroupBlockingFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN ISNULL(b.PayrollGroupReviewFlag, 0) = 1
                        THEN 1
                    ELSE 0
                END
            ),

        UnhandledComponentBlockingFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN ISNULL(u.UnhandledComponentCount, 0) > 0
                        THEN 1
                    ELSE 0
                END
            ),


        /*********************************************************************
          REVIEW-ONLY FLAGS
        *********************************************************************/
        PotentialBoomWithoutLedgerReviewFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN ISNULL(bm.AppliedBoomSliceHours, 0) > 0
                     AND ISNULL(bm.BoomLedgerActualRows, 0) = 0

                     AND NOT
                     (
                         ISNULL(b.HoursWorked_Raw, 0) <> 0
                         AND ISNULL(b.Source_Rate_Raw, 0) = 0
                     )
                        THEN 1
                    ELSE 0
                END
            )

    INTO #Prepared

    FROM #Base b

    LEFT JOIN #ComponentAgg c
        ON c.LaborPayrollID = b.LaborPayrollID

    LEFT JOIN #UnhandledComponents u
        ON u.LaborPayrollID = b.LaborPayrollID

    LEFT JOIN #ExceptionAgg x
        ON x.LaborPayrollID = b.LaborPayrollID

    LEFT JOIN #Boom bm
        ON bm.LaborPayrollID = b.LaborPayrollID;


    /*************************************************************************
      13. FINAL EXCEL RECOMMENDATION CONTRACT

      If ExportBlockingFlag = 1:
          recommendation hours/amounts = 0
          LB recommendation rates = NULL

      Audit fields remain populated for troubleshooting.
    *************************************************************************/
    SELECT

        ---------------------------------------------------------------------
        -- Run / payroll period
        ---------------------------------------------------------------------
        p.ResolvedRunId,
        p.PayStartDate,
        p.PayEndDate,


        ---------------------------------------------------------------------
        -- Employee
        ---------------------------------------------------------------------
        p.EmpID,
        p.Employee_Name,

        p.ADP_FileNumber,
        p.PayrollGroup,

        p.PayType,
        p.EmpTypeId,

        p.Employee_CraftCode,
        p.Employee_BaseHourlyRate,
        p.Employee_BaseHourlyRateSource,


        ---------------------------------------------------------------------
        -- Labor entry
        ---------------------------------------------------------------------
        p.LaborPayrollID,
        p.ResolvedCalcID,

        p.WorkDate,

        p.JobTicketID,
        p.JobCode,
        p.WoCode,

        p.UnitCode,
        p.UnitName,
        p.UnitDescription,

        p.TimeStart_Labor,
        p.TimeEnd_Labor,


        /*********************************************************************
          EXPORT SAFETY
        *********************************************************************/
        ExportBlockingFlag =
            flags.ExportBlockingFlag,

        ExportBlockingReasons =
            NULLIF
            (
                CONCAT_WS
                (
                    ' | ',

                    CASE
                        WHEN p.EmployeeMasterMissingFlag = 1
                            THEN
                            'Employee master/payroll-group record was not found.'
                    END,

                    CASE
                        WHEN p.UncalculatedNonzeroHoursFlag = 1
                            THEN
                            'Nonzero labor entry has no calculated row for the authoritative RunId.'
                    END,

                    CASE
                        WHEN p.MissingSourceRateFlag = 1
                            THEN
                            'Source labor rate is missing or zero for a nonzero-hour labor entry.'
                    END,

                    CASE
                        WHEN p.BucketTieOutBlockingFlag = 1
                            THEN
                            'Ordinary payroll hour buckets do not tie to expected payable hours.'
                    END,

                    CASE
                        WHEN p.BoomTieOutBlockingFlag = 1
                            THEN
                            'Authorized long-boom hours do not reconcile to classified pricing slices.'
                    END,

                    CASE
                        WHEN p.BoomRateBlockingFlag = 1
                            THEN
                            'Long-boom hours require more than one or an unresolved temporary rate in the same bucket.'
                    END,

                    CASE
                        WHEN p.MissingLedgerForPayFlag = 1
                            THEN
                            'Calculated payroll contains pay but no authoritative pay-component ledger rows.'
                    END,

                    CASE
                        WHEN p.LedgerReconciliationBlockingFlag = 1
                            THEN
                            'Calculated final gross plus WTL adjustments does not reconcile to the authoritative pay-component final gross.'
                    END,

                    CASE
                        WHEN p.CalcViewMismatchFlag = 1
                            THEN
                            'Week-detail calculation does not match the authoritative RunId calculation.'
                    END,

                    CASE
                        WHEN p.PayrollAppErrorBlockingFlag = 1
                            THEN CONCAT
                                 (
                                     'Payroll App error: ',
                                     COALESCE
                                     (
                                         NULLIF(p.ErrorReasons, ''),
                                         'unspecified error'
                                     )
                                 )
                    END,

                    CASE
                        WHEN p.ADPFileNumberBlockingFlag = 1
                            THEN COALESCE
                                 (
                                     NULLIF
                                     (
                                         p.ADP_FileNumberReviewMessage,
                                         ''
                                     ),
                                     'ADP File Number requires review.'
                                 )
                    END,

                    CASE
                        WHEN p.PayrollGroupBlockingFlag = 1
                            THEN COALESCE
                                 (
                                     NULLIF
                                     (
                                         p.PayrollGroupReviewMessage,
                                         ''
                                     ),
                                     'Payroll Group requires review.'
                                 )
                    END,

                    CASE
                        WHEN p.UnhandledComponentBlockingFlag = 1
                            THEN CONCAT
                                 (
                                     'Unhandled Payroll App component code(s): ',
                                     COALESCE
                                     (
                                         p.UnhandledComponentCodes,
                                         ''
                                     )
                                 )
                    END
                ),
                ''
            ),


        ---------------------------------------------------------------------
        -- Review / warning
        ---------------------------------------------------------------------
        ReviewWarningFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN
                           ISNULL(p.Bucket_Source_Review_Flag, 0) = 1
                        OR ISNULL(p.RateResolutionReviewFlag, 0) = 1
                        OR ISNULL(p.CraftCodeMismatchFlag, 0) = 1
                        OR ISNULL(p.HasWarning, 0) = 1
                        OR ISNULL(p.HasIssue, 0) = 1
                        OR ISNULL(p.ExceptionCount, 0) > 0
                        OR ISNULL
                           (
                               p.PotentialBoomWithoutLedgerReviewFlag,
                               0
                           ) = 1
                        THEN 1
                    ELSE 0
                END
            ),

        ReviewWarningReasons =
            NULLIF
            (
                CONCAT_WS
                (
                    ' | ',

                    CASE
                        WHEN ISNULL(p.Bucket_Source_Review_Flag, 0) = 1
                            THEN COALESCE
                                 (
                                     NULLIF
                                     (
                                         p.Bucket_Source_Review_Message,
                                         ''
                                     ),
                                     'Payroll bucket source requires review.'
                                 )
                    END,

                    CASE
                        WHEN ISNULL(p.RateResolutionReviewFlag, 0) = 1
                            THEN COALESCE
                                 (
                                     NULLIF
                                     (
                                         p.RateResolutionReviewMessage,
                                         ''
                                     ),
                                     'Payroll rate resolution requires review.'
                                 )
                    END,

                    CASE
                        WHEN ISNULL(p.CraftCodeMismatchFlag, 0) = 1
                            THEN COALESCE
                                 (
                                     NULLIF
                                     (
                                         p.CraftCodeMismatchMessage,
                                         ''
                                     ),
                                     'Employee craft and labor-entry craft differ.'
                                 )
                    END,

                    CASE
                        WHEN ISNULL(p.HasWarning, 0) = 1
                            THEN NULLIF(p.WarningReasons, '')
                    END,

                    CASE
                        WHEN ISNULL(p.HasIssue, 0) = 1
                         AND ISNULL(p.HasWarning, 0) = 0
                         AND ISNULL(p.HasError, 0) = 0
                            THEN NULLIF(p.AllIssueReasons, '')
                    END,

                    CASE
                        WHEN ISNULL(p.ExceptionCount, 0) > 0
                            THEN CONCAT
                                 (
                                     'Current-run exception(s): ',
                                     COALESCE
                                     (
                                         p.ExceptionReasons,
                                         ''
                                     )
                                 )
                    END,

                    CASE
                        WHEN ISNULL
                             (
                                 p.PotentialBoomWithoutLedgerReviewFlag,
                                 0
                             ) = 1
                            THEN
                            'Applied boom pricing slices exist but no ACTUAL_BOOM_WORKED_PAY ledger authorization exists; boom hours are not recommended.'
                    END
                ),
                ''
            ),


        /*********************************************************************
          SAFE ORDINARY HOUR RECOMMENDATIONS
        *********************************************************************/
        Recommended_ST_Hours =
            CONVERT
            (
                decimal(10,2),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.Bucket_Hrs_ST, 0)
                END
            ),

        Recommended_OT_Hours =
            CONVERT
            (
                decimal(10,2),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.Bucket_Hrs_OT, 0)
                END
            ),

        Recommended_DT_Hours =
            CONVERT
            (
                decimal(10,2),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.Bucket_Hrs_DT, 0)
                END
            ),

        Recommended_H2x_Hours =
            CONVERT
            (
                decimal(10,2),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.Bucket_Hrs_H2x, 0)
                END
            ),

        Recommended_H3x_Hours =
            CONVERT
            (
                decimal(10,2),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.Bucket_Hrs_H3x, 0)
                END
            ),


        /*********************************************************************
          SAFE LONG-BOOM RECOMMENDATIONS
        *********************************************************************/
        Recommended_LB_ST_Hours =
            CONVERT
            (
                decimal(10,2),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.LB_ST_Hours, 0)
                END
            ),

        Recommended_LB_ST_Rate =
            CONVERT
            (
                decimal(12,4),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN NULL
                    ELSE COALESCE
                         (
                             p.Actual_LB_ST_RateMin,
                             p.Guaranteed_LB_ST_RateMin
                         )
                END
            ),

        Recommended_LB_OT_Hours =
            CONVERT
            (
                decimal(10,2),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.LB_OT_Hours, 0)
                END
            ),

        Recommended_LB_OT_Rate =
            CONVERT
            (
                decimal(12,4),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN NULL
                    ELSE COALESCE
                         (
                             p.Actual_LB_OT_RateMin,
                             p.Guaranteed_LB_OT_RateMin
                         )
                END
            ),

        Recommended_LB_DT_Hours =
            CONVERT
            (
                decimal(10,2),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.LB_DT_Hours, 0)
                END
            ),

        Recommended_LB_DT_Rate =
            CONVERT
            (
                decimal(12,4),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN NULL
                    ELSE COALESCE
                         (
                             p.Actual_LB_DT_RateMin,
                             p.Guaranteed_LB_DT_RateMin
                         )
                END
            ),

        Recommended_LB_3X_Hours =
            CONVERT
            (
                decimal(10,2),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.LB_3X_Hours, 0)
                END
            ),

        Recommended_LB_3X_Rate =
            CONVERT
            (
                decimal(12,4),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN NULL
                    ELSE COALESCE
                         (
                             p.Actual_LB_3X_RateMin,
                             p.Guaranteed_LB_3X_RateMin
                         )
                END
            ),

        Recommended_LB_Total_Hours =
            CONVERT
            (
                decimal(10,2),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE
                          ISNULL(p.LB_ST_Hours, 0)
                        + ISNULL(p.LB_OT_Hours, 0)
                        + ISNULL(p.LB_DT_Hours, 0)
                        + ISNULL(p.LB_3X_Hours, 0)
                END
            ),


        /*********************************************************************
          SAFE COMPONENT-AMOUNT RECOMMENDATIONS

          ADP code selection remains downstream/configurable.
        *********************************************************************/
        Recommended_Subsistence_Amount =
            CONVERT
            (
                decimal(19,4),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.SubsistenceAmount, 0)
                END
            ),

        Recommended_RestPremium_Amount =
            CONVERT
            (
                decimal(19,4),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.RestPremiumComponentAmount, 0)
                END
            ),

        Recommended_WTL_Net_Amount =
            CONVERT
            (
                decimal(19,4),
                CASE
                    WHEN flags.ExportBlockingFlag = 1 THEN 0
                    ELSE ISNULL(p.WTLNetComponentAmount, 0)
                END
            ),


        /*********************************************************************
          ORDINARY BUCKET AUDIT
        *********************************************************************/
        p.Bucket_Actual_Hrs,
        p.Bucket_Payable_Hrs,

        p.Bucket_Hrs_ST,
        p.Bucket_Hrs_OT,
        p.Bucket_Hrs_DT,
        p.Bucket_Hrs_H2x,
        p.Bucket_Hrs_H3x,

        p.Expected_Payable_Hrs,
        p.Bucketed_Payable_Hrs,

        p.Bucket_Hrs_TieOut_Difference,
        p.Bucket_Hrs_TieOut_Status,

        p.Bucket_Source,
        p.Has_Pricing_Slices,
        p.Pricing_Slice_Count,
        p.Pricing_Slice_Hours,


        /*********************************************************************
          BOOM AUDIT
        *********************************************************************/
        p.BoomLedgerActualRows,
        p.BoomLedgerActualHours,
        p.BoomLedgerActualAmount,

        p.BoomSliceClassifiedHours,
        p.BoomBucketDifference,

        p.UnclassifiedActualBoomHours,

        p.Actual_LB_ST_Hours,
        p.Actual_LB_OT_Hours,
        p.Actual_LB_DT_Hours,
        p.Actual_LB_3X_Hours,

        p.GuaranteedBoomRows,
        p.GuaranteedBoomHours,
        p.GuaranteedBoomAmount,

        p.Guaranteed_LB_ST_Hours,
        p.Guaranteed_LB_OT_Hours,
        p.Guaranteed_LB_DT_Hours,
        p.Guaranteed_LB_3X_Hours,

        p.UnclassifiedGuaranteedBoomHours,

        BoomBucketReviewFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN p.BoomTieOutBlockingFlag = 1
                      OR p.BoomRateBlockingFlag = 1
                      OR p.PotentialBoomWithoutLedgerReviewFlag = 1
                        THEN 1
                    ELSE 0
                END
            ),

        BoomBucketReviewMessage =
            NULLIF
            (
                CONCAT_WS
                (
                    ' | ',

                    CASE
                        WHEN p.BoomTieOutBlockingFlag = 1
                            THEN
                            'Boom ledger authorization and pricing-slice classification do not reconcile.'
                    END,

                    CASE
                        WHEN p.BoomRateBlockingFlag = 1
                            THEN
                            'Boom bucket has a missing or mixed temporary rate.'
                    END,

                    CASE
                        WHEN p.PotentialBoomWithoutLedgerReviewFlag = 1
                            THEN
                            'Boom pricing slices exist without ledger authorization; boom recommendation suppressed.'
                    END
                ),
                ''
            ),


        /*********************************************************************
          LEDGER / COMPONENT AUDIT
        *********************************************************************/
        p.LedgerRowCount,

        ---------------------------------------------------------------------
        -- NEW reconciliation fields
        ---------------------------------------------------------------------
        p.ExpectedLedgerFinalGross,
        p.LedgerFinalGrossAmount,
        p.LedgerReconciliationDifference,
        p.LedgerReconciliationBlockingFlag,

        ---------------------------------------------------------------------
        -- Payable gross is intentionally separate from final gross.
        --
        -- LedgerAdditionalPayableAmount identifies amounts included in
        -- payable gross but not final gross.
        ---------------------------------------------------------------------
        p.LedgerPayableGrossAmount,
        p.LedgerAdditionalPayableAmount,

        p.ActualBaseWorkedHours,
        p.ActualBaseWorkedAmount,

        p.GuaranteedBaseHours,
        p.GuaranteedBaseAmount,

        p.GuaranteedHolidayBaseHours,
        p.GuaranteedHolidayBaseAmount,

        p.GuaranteedSpecialSaturdayBaseHours,
        p.GuaranteedSpecialSaturdayBaseAmount,

        p.ActualShiftDifferentialHours,
        p.ActualShiftDifferentialAmount,

        p.Shift2HoursAdd,
        p.Shift2HoursAddAmount,

        p.RestPremiumComponentHours,
        p.RestPremiumComponentAmount,

        p.WTLMealDeductHours,
        p.WTLMealDeductAmount,

        p.WTLDTFloorHours,
        p.WTLDTFloorAmount,

        p.WTLApplicableAddHours,
        p.WTLApplicableAddAmount,

        p.WTLNetComponentHours,
        p.WTLNetComponentAmount,

        p.SubsistenceShortAmount,
        p.SubsistenceLongWeekdayAmount,
        p.SubsistenceLongWeekendAmount,
        p.SubsistenceAmount,

        p.NonUnion_ST_Hours,
        p.NonUnion_Daily_OT_Hours,
        p.NonUnion_Weekly_OT_Hours,
        p.NonUnion_7thDay_OT_Hours,
        p.NonUnion_Daily_DT_Hours,
        p.NonUnion_7thDay_DT_Hours,

        p.RoundingAdjustmentAmount,


        /*********************************************************************
          SOURCE / CALC AUDIT
        *********************************************************************/
        p.HoursWorked_Raw,
        p.Source_Rate_Raw,
        p.Source_Amount_Raw,

        p.PayrollBaseRate,
        p.PayrollBaseRateSource,

        p.PayrollModifierRate,
        p.PayrollModifierRateSource,

        p.PayrollCombinedRate,
        p.FmsSourceRate,

        p.Act_Total_Hrs,
        p.Act_Boom_Hrs,
        p.Gap_Hrs_Total,
        p.Gap_Hrs_Boom,
        p.Pay_Total_Hrs,

        p.Pay_Actual_Gross,
        p.Pay_Gap_Add,
        p.Pay_Rest_Add,
        p.Final_Gross_Pay,

        p.Rule_Hrs_Total,
        p.Rule_Hrs_Gap,
        p.Rule_Hrs_ShiftAdd,
        p.Rule_Hrs_WTL_Net,

        p.Rule_Amt_Gap,
        p.Rule_Amt_ShiftAdd,
        p.Rule_Amt_WTL,

        p.Rest_Premium_Hrs_Affected,
        p.Rest_Premium_Amt,

        p.HolidayName,


        /*********************************************************************
          INDIVIDUAL CONTROL FLAGS
        *********************************************************************/
        p.EmployeeMasterMissingFlag,
        p.UncalculatedNonzeroHoursFlag,
        p.MissingSourceRateFlag,

        p.BucketTieOutBlockingFlag,

        p.BoomTieOutBlockingFlag,
        p.BoomRateBlockingFlag,

        p.MissingLedgerForPayFlag,

        ---------------------------------------------------------------------
        -- NEW
        ---------------------------------------------------------------------
        -- p.LedgerReconciliationBlockingFlag is already exposed above
        -- with the ledger reconciliation fields.
        ---------------------------------------------------------------------

        p.CalcViewMismatchFlag,

        p.PayrollAppErrorBlockingFlag,
        p.ADPFileNumberBlockingFlag,
        p.PayrollGroupBlockingFlag,
        p.UnhandledComponentBlockingFlag,

        p.PotentialBoomWithoutLedgerReviewFlag,

        p.Bucket_Source_Review_Flag,
        p.Bucket_Source_Review_Message,

        p.RateResolutionReviewFlag,
        p.RateResolutionReviewMessage,

        p.CraftCodeMismatchFlag,
        p.CraftCodeMismatchMessage,


        /*********************************************************************
          EXISTING ISSUE / EXCEPTION DETAILS
        *********************************************************************/
        p.HasError,
        p.HasWarning,
        p.HasIssue,

        p.ErrorCount,
        p.WarningCount,
        p.TotalIssueCount,

        p.ErrorReasons,
        p.WarningReasons,
        p.AllIssueReasons,

        p.ExceptionCount,
        p.WTLWarningCount,
        p.ExceptionReasons,


        /*********************************************************************
          UNKNOWN FUTURE COMPONENT PROTECTION
        *********************************************************************/
        p.UnhandledComponentCount,
        p.UnhandledComponentAmount,
        p.UnhandledComponentCodes,

        /*********************************************************************
            PAYROLL-FACING APPLIED RULE EXPLANATION

            Shared employee/day explanation source used by Excel and Web UI.

            Intentionally appended to the END of the existing result contract
            so all pre-existing output-column ordinals remain unchanged.
        *********************************************************************/
        AppliedPayrollRules =
            appliedRules.AppliedPayrollRules,


        /*********************************************************************
            PAYROLL-FACING CALCULATION / REVIEW NOTES

            Shared employee/day explanation source used by Excel and Web UI.

            IMPORTANT:
            - PayrollCalculationReviewNotes combines REVIEW first, then INFO.
            - PayrollReviewReasons contains actionable REVIEW notes only.
            - CalculationInfoNotes contains informational calculation context.
            - HasPayrollReview is the canonical Payroll-facing review flag.
            - HasCalculationInfo does NOT imply Payroll action is required.
            - Existing ReviewWarningFlag / ReviewWarningReasons remain
                unchanged as legacy technical diagnostics.

            These fields are appended after AppliedPayrollRules so every
            pre-existing output-column ordinal remains unchanged.
        *********************************************************************/
        PayrollCalculationReviewNotes =
            calcReview.PayrollCalculationReviewNotes,

        CalculationInfoNotes =
            calcReview.CalculationInfoNotes,

        PayrollReviewReasons =
            calcReview.PayrollReviewReasons,

        HasCalculationInfo =
            CONVERT
            (
                bit,
                ISNULL(calcReview.HasCalculationInfo, 0)
            ),

        HasPayrollReview =
            CONVERT
            (
                bit,
                ISNULL(calcReview.HasPayrollReview, 0)
            )

        FROM #Prepared p

        LEFT JOIN api.v_UI_Payroll_EmployeeDay_AppliedRuleSummary AS appliedRules
            ON appliedRules.RunId = p.ResolvedRunId
        AND appliedRules.EmpID = p.EmpID
        AND appliedRules.WorkDate = CONVERT(date, p.WorkDate)

        LEFT JOIN api.v_UI_Payroll_EmployeeDay_CalculationReviewSummary AS calcReview
            ON calcReview.RunId = p.ResolvedRunId
        AND calcReview.EmpID = p.EmpID
        AND calcReview.WorkDate = CONVERT(date, p.WorkDate)

        CROSS APPLY
        (
        SELECT
            ExportBlockingFlag =
                CONVERT
                (
                    bit,
                    CASE
                        WHEN
                               p.EmployeeMasterMissingFlag = 1
                            OR p.UncalculatedNonzeroHoursFlag = 1
                            OR p.MissingSourceRateFlag = 1
                            OR p.BucketTieOutBlockingFlag = 1
                            OR p.BoomTieOutBlockingFlag = 1
                            OR p.BoomRateBlockingFlag = 1
                            OR p.MissingLedgerForPayFlag = 1
                            OR p.LedgerReconciliationBlockingFlag = 1
                            OR p.CalcViewMismatchFlag = 1
                            OR p.PayrollAppErrorBlockingFlag = 1
                            OR p.ADPFileNumberBlockingFlag = 1
                            OR p.PayrollGroupBlockingFlag = 1
                            OR p.UnhandledComponentBlockingFlag = 1
                            THEN 1
                        ELSE 0
                    END
                )
    ) flags

    ORDER BY
        p.Employee_Name,
        p.WorkDate,
        p.LaborPayrollID;


    /*************************************************************************
      14. CLEANUP
    *************************************************************************/
    DROP TABLE IF EXISTS #Prepared;
    DROP TABLE IF EXISTS #Boom;
    DROP TABLE IF EXISTS #GuaranteedBoom;
    DROP TABLE IF EXISTS #AppliedBoomSlices;
    DROP TABLE IF EXISTS #ActualBoomLedger;
    DROP TABLE IF EXISTS #ExceptionAgg;
    DROP TABLE IF EXISTS #UnhandledComponents;
    DROP TABLE IF EXISTS #ComponentAgg;
    DROP TABLE IF EXISTS #Base;
END;

