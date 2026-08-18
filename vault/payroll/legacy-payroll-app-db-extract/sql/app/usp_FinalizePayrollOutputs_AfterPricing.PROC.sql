
CREATE   PROCEDURE [app].[usp_FinalizePayrollOutputs_AfterPricing]
    @WorkDateFrom date = NULL,
    @WorkDateTo   date = NULL,
    @RunId        int  = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    /* ------------------------------------------------------------
       1) Base pay fallback
       ------------------------------------------------------------ */
    EXEC app.usp_Apply_BasePay_Fallback_FromSource
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo;

    /* ------------------------------------------------------------
       2) Guaranteed hours / minimum pay
       ------------------------------------------------------------ */
    EXEC app.usp_Apply_GuaranteedHours
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;

    /* ------------------------------------------------------------
       3) Rest period premium
       ------------------------------------------------------------ */
    EXEC app.usp_Apply_RestPeriod_Premium
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;

    /* ------------------------------------------------------------
       4) Suppress calculated pay when Source_Rate_Raw is missing
       ------------------------------------------------------------ */
    EXEC app.usp_SuppressPay_WhenSourceRateMissing
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo;

    /* ------------------------------------------------------------
       4.5) Apply Non-Union Admin Hourly CA Nonexempt OT/DT

            This applies California nonexempt hourly allocation for:
            - PayrollGroup = Non-Union Admin Hourly
            - ADMIN* labor craft rows

            It intentionally runs after the L12-oriented guarantee/rest/
            suppression steps so non-union hourly rows are corrected and
            L12-only additions are cleared before the ledger is rebuilt.
       ------------------------------------------------------------ */
    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
    BEGIN
        EXEC app.usp_Apply_CA_NonUnionAdminHourly_OT
              @WorkDateFrom = @WorkDateFrom,
              @WorkDateTo   = @WorkDateTo,
              @PreviewOnly  = 0,
              @RequestedBy  = N'app.usp_FinalizePayrollOutputs_AfterPricing';
    END
    ELSE
    BEGIN
        PRINT 'Non-union hourly CA OT/DT skipped because app.usp_FinalizePayrollOutputs_AfterPricing was called without an explicit date range.';
    END;

    /* ------------------------------------------------------------
       5) Rebuild pay component ledger from current calculated output

          Important:
          - This deletes/rebuilds fms.Payroll_PayComponent rows
            for the date range.
          - WTL must run after this step.
          - Non-union hourly ledger replacement must run after this step.
       ------------------------------------------------------------ */
    EXEC app.usp_Rebuild_PayComponentLedger
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;

    /* ------------------------------------------------------------
       5.5) Rebuild Non-Union Admin Hourly CA Nonexempt Ledger

            The main ledger rebuild creates generic ACTUAL_BASE_WORKED_PAY
            rows. For non-union hourly employees, replace those generic
            rows with rule-specific explanatory component rows:
            - NONUNION_CA_NONEXEMPT_ST
            - NONUNION_CA_NONEXEMPT_DAILY_OT
            - NONUNION_CA_NONEXEMPT_WEEKLY_OT
            - NONUNION_CA_NONEXEMPT_DAILY_DT
            - NONUNION_CA_NONEXEMPT_7TH_DAY_OT
            - NONUNION_CA_NONEXEMPT_7TH_DAY_DT
       ------------------------------------------------------------ */
    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
    BEGIN
        EXEC app.usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt
              @WorkDateFrom = @WorkDateFrom,
              @WorkDateTo   = @WorkDateTo,
              @PreviewOnly  = 0,
              @RequestedBy  = N'app.usp_FinalizePayrollOutputs_AfterPricing';
    END
    ELSE
    BEGIN
        PRINT 'Non-union hourly CA nonexempt ledger rebuild skipped because app.usp_FinalizePayrollOutputs_AfterPricing was called without an explicit date range.';
    END;

    /* ------------------------------------------------------------
       6) Apply Shift Differential Hours Add

          This adds:
          - SHIFT_2_HOURS_ADD
          - SHIFT_3_HOURS_ADD
       ------------------------------------------------------------ */
    EXEC app.usp_Apply_ShiftDifferentialHoursAdd
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;

    /* ------------------------------------------------------------
       7) Apply Worked Through Lunch / Meal Period rules

          This adds:
          - WTL_MEAL_DEDUCT
          - WTL_DT_FLOOR
          - WTL_APPLICABLE_ADD

          It also writes WTL review/warning/error rows.

          WTL requires an explicit date range because grouping uses
          configured lookback/lookahead days.
       ------------------------------------------------------------ */
    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
    BEGIN
        EXEC app.usp_Apply_WTL_MealPeriods
              @WorkDateFrom      = @WorkDateFrom,
              @WorkDateTo        = @WorkDateTo,
              @UnionCode         = 'L12',
              @RunId             = @RunId,
              @CommitChanges     = 1,
              @UseTestOverrides  = 0,
              @TestOverrideSet   = NULL,
              @ReturnResults     = 0;
    END
    ELSE
    BEGIN
        PRINT 'WTL skipped because app.usp_FinalizePayrollOutputs_AfterPricing was called without an explicit date range.';
    END;

    /* ------------------------------------------------------------
       8) Final-gross ledger reconciliation

          Must run after:
          - Main ledger rebuild
          - Non-union hourly ledger replacement
          - ShiftDifferentialHoursAdd
          - WTL Meal Periods

          WTL-aware finalizer keeps WTL components explicit and
          prevents rounding from offsetting them.
       ------------------------------------------------------------ */
    EXEC app.usp_Finalize_PayComponentLedger_Reconciliation
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo;

    /* ------------------------------------------------------------
       9) Subsistence

          Payable-only component. Does not change Final_Gross_Pay.
       ------------------------------------------------------------ */
    EXEC app.usp_Apply_SubsistencePay
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;

    /* ------------------------------------------------------------
       10) Normalize cents-level rounding
       ------------------------------------------------------------ */
    EXEC app.usp_Normalize_PayComponentLedger_Rounding
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;
END;
