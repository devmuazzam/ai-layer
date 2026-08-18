
/* 61A - Patch pay component ledger for true accounting split */

CREATE   PROCEDURE app.usp_Rebuild_PayComponentLedger
    @WorkDateFrom date = NULL,
    @WorkDateTo   date = NULL,
    @RunId        int  = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FromDate date = COALESCE(@WorkDateFrom, '19000101');
    DECLARE @ToDate   date = COALESCE(@WorkDateTo,   '99991231');

    DELETE pcmp
    FROM fms.Payroll_PayComponent pcmp
    WHERE pcmp.WorkDate >= @FromDate
      AND pcmp.WorkDate <  DATEADD(DAY, 1, @ToDate);

    /* ------------------------------------------------------------
       1) Actual worked pay split from pricing slices
          Pay_Actual_Gross =
              ACTUAL_BASE_WORKED_PAY
            + ACTUAL_BOOM_WORKED_PAY
            + ACTUAL_SHIFT_DIFFERENTIAL

          Base component receives penny/rounding true-up so ledger
          exactly matches fms.Payroll_Calculated.Pay_Actual_Gross.
       ------------------------------------------------------------ */
    ;WITH SliceSplit AS
    (
        SELECT
            ps.LaborPayrollID,

            ActualBaseWorkedPay_Raw =
                SUM(CONVERT(decimal(19,4),
                    ISNULL(ps.Slice_Hours, 0)
                  * ISNULL(ps.Rate_Base, 0)
                  * ISNULL(ps.Final_Multiplier, 1)
                )),

            ActualShiftDifferential =
                SUM(CONVERT(decimal(19,4),
                    ISNULL(ps.Slice_Hours, 0)
                  * ISNULL(ps.Rate_Shift, 0)
                  * ISNULL(ps.Final_Multiplier, 1)
                )),

            ActualBoomWorkedPay =
                SUM(CONVERT(decimal(19,4),
                    ISNULL(ps.Slice_Hours, 0)
                  * ISNULL(ps.Rate_Boom_Applied, 0)
                  * ISNULL(ps.Final_Multiplier, 1)
                )),

            ActualSliceHours =
                SUM(CONVERT(decimal(10,2), ISNULL(ps.Slice_Hours, 0))),

            ShiftSliceHours =
                SUM(CONVERT(decimal(10,2),
                    CASE WHEN ISNULL(ps.Rate_Shift, 0) <> 0
                         THEN ISNULL(ps.Slice_Hours, 0)
                         ELSE 0
                    END
                )),

            BoomSliceHours =
                SUM(CONVERT(decimal(10,2),
                    CASE WHEN ISNULL(ps.Rate_Boom_Applied, 0) <> 0
                         THEN ISNULL(ps.Slice_Hours, 0)
                         ELSE 0
                    END
                )),

            MaxRateBase =
                MAX(CONVERT(decimal(12,4), ISNULL(ps.Rate_Base, 0))),

            MaxRateShift =
                MAX(CONVERT(decimal(12,4), ISNULL(ps.Rate_Shift, 0))),

            MaxRateBoomApplied =
                MAX(CONVERT(decimal(12,4), ISNULL(ps.Rate_Boom_Applied, 0)))
        FROM api.v_UI_Pricing_Slices_Advanced ps
        WHERE ps.WorkDate >= @FromDate
          AND ps.WorkDate <  DATEADD(DAY, 1, @ToDate)
        GROUP BY
            ps.LaborPayrollID
    ),
    ActualSplit AS
    (
        SELECT
            pc.CalcID,
            pc.LaborPayrollID,
            WorkDate = CONVERT(date, pc.WorkDate),
            pc.JobTicketID,
            pc.JobCode,
            pc.EmpID,
            pc.Employee_Name,
            pc.Act_Total_Hrs,
            pc.Hrs_ST,
            pc.Hrs_OT,
            pc.Hrs_DT,
            ss.ActualSliceHours,
            ss.ShiftSliceHours,
            ss.BoomSliceHours,
            ss.MaxRateBase,
            ss.MaxRateShift,
            ss.MaxRateBoomApplied,

            ActualBaseWorkedPay =
                CONVERT(decimal(19,4),
                    ISNULL(ss.ActualBaseWorkedPay_Raw, 0)
                  + (
                        CONVERT(decimal(19,4), ISNULL(pc.Pay_Actual_Gross, 0))
                      - CONVERT(decimal(19,4),
                            ISNULL(ss.ActualBaseWorkedPay_Raw, 0)
                          + ISNULL(ss.ActualShiftDifferential, 0)
                          + ISNULL(ss.ActualBoomWorkedPay, 0)
                        )
                    )
                ),

            ActualShiftDifferential =
                CONVERT(decimal(19,4), ISNULL(ss.ActualShiftDifferential, 0)),

            ActualBoomWorkedPay =
                CONVERT(decimal(19,4), ISNULL(ss.ActualBoomWorkedPay, 0))
        FROM fms.Payroll_Calculated pc
        LEFT JOIN SliceSplit ss
            ON ss.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @FromDate
          AND pc.WorkDate <  DATEADD(DAY, 1, @ToDate)
          AND ISNULL(pc.Pay_Actual_Gross, 0) <> 0
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
        a.CalcID,
        a.LaborPayrollID,
        a.WorkDate,
        a.JobTicketID,
        a.JobCode,
        a.EmpID,
        a.Employee_Name,
        v.ComponentCode,
        v.ComponentGroup,
        v.ComponentLabel,
        v.SourceSchema,
        v.SourceTable,
        v.SourceID,
        v.SourceRuleCode,
        v.SourceRuleName,
        v.ComponentHours,
        v.Hrs_ST,
        v.Hrs_OT,
        v.Hrs_DT,
        v.RateBaseUsed,
        v.RateShiftUsed,
        v.RateBoomUsed,
        v.MultiplierUsed,
        v.ComponentAmount,
        CONVERT(bit, 1),
        CONVERT(bit, 1),
        v.DisplaySort,
        v.Explanation
    FROM ActualSplit a
    CROSS APPLY
    (
        VALUES
        (
            'ACTUAL_BASE_WORKED_PAY',
            'ACTUAL',
            'Actual Base Worked Pay',
            'api',
            'v_UI_Pricing_Slices_Advanced',
            a.CalcID,
            NULL,
            'Actual base worked pay',
            a.ActualSliceHours,
            a.Hrs_ST,
            a.Hrs_OT,
            a.Hrs_DT,
            a.MaxRateBase,
            CONVERT(decimal(12,4), 0),
            CONVERT(decimal(12,4), 0),
            NULL,
            a.ActualBaseWorkedPay,
            10,
            'Actual worked base pay from pricing slices; includes penny true-up to fms.Payroll_Calculated.Pay_Actual_Gross.'
        ),
        (
            'ACTUAL_SHIFT_DIFFERENTIAL',
            'ACTUAL',
            'Actual Shift Differential',
            'cfg',
            'Union_Shift_Rules',
            a.CalcID,
            'SHIFT_DIFFERENTIAL',
            'Actual shift differential',
            a.ShiftSliceHours,
            NULL,
            NULL,
            NULL,
            CONVERT(decimal(12,4), 0),
            a.MaxRateShift,
            CONVERT(decimal(12,4), 0),
            NULL,
            a.ActualShiftDifferential,
            12,
            'Actual worked shift differential from pricing slices: Slice_Hours * Rate_Shift * Final_Multiplier.'
        ),
        (
            'ACTUAL_BOOM_WORKED_PAY',
            'ACTUAL',
            'Actual Boom Worked Pay',
            'api',
            'v_UI_Pricing_Slices_Advanced',
            a.CalcID,
            'BOOM_ACTUAL',
            'Actual boom worked pay',
            a.BoomSliceHours,
            NULL,
            NULL,
            NULL,
            CONVERT(decimal(12,4), 0),
            CONVERT(decimal(12,4), 0),
            a.MaxRateBoomApplied,
            NULL,
            a.ActualBoomWorkedPay,
            14,
            'Actual worked boom premium from pricing slices: Slice_Hours * Rate_Boom_Applied * Final_Multiplier.'
        )
    ) v
    (
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
        DisplaySort,
        Explanation
    )
    WHERE ISNULL(v.ComponentAmount, 0) <> 0;

    /* ------------------------------------------------------------
       2) Guaranteed base pay add
          Split RateBaseUsed from RateShiftUsed.
       ------------------------------------------------------------ */
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
        pc.CalcID,
        ga.LaborPayrollID,
        ga.AllocatedDate,
        pc.JobTicketID,
        pc.JobCode,
        pc.EmpID,
        pc.Employee_Name,
        CASE
            WHEN gg.RuleCode = 'HOLIDAY_MIN_8'
                THEN 'GUARANTEED_HOLIDAY_BASE_PAY_ADD'
            WHEN gg.RuleCode = 'SPECIAL_SAT_MIN_8'
                THEN 'GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD'
            ELSE 'GUARANTEED_BASE_PAY_ADD'
        END,
        'GUARANTEE',
        CASE
            WHEN gg.RuleCode = 'HOLIDAY_MIN_8'
                THEN 'Guaranteed Holiday Base Pay Add'
            WHEN gg.RuleCode = 'SPECIAL_SAT_MIN_8'
                THEN 'Guaranteed Special Saturday Base Pay Add'
            ELSE 'Guaranteed Base Pay Add'
        END,
        'fms',
        'Payroll_GuaranteeAllocation',
        ga.GuaranteeAllocationID,
        gg.RuleCode,
        gg.RuleName,
        ga.AllocatedGapHours,
        NULL,
        NULL,
        NULL,
        ga.RateBaseUsed,
        CONVERT(decimal(12,4), 0),
        CONVERT(decimal(12,4), 0),
        ga.MultiplierUsed,
        CONVERT(decimal(19,4),
            ga.AllocatedGapHours
          * ISNULL(ga.RateBaseUsed, 0)
          * ISNULL(ga.MultiplierUsed, 1)
        ),
        CONVERT(bit, 1),
        CONVERT(bit, 1),
        20,
        ga.Explanation
    FROM fms.Payroll_GuaranteeAllocation ga
    JOIN fms.Payroll_GuaranteeGroup gg
        ON gg.GuaranteeGroupID = ga.GuaranteeGroupID
    JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = ga.LaborPayrollID
    WHERE ga.AllocatedDate >= @FromDate
      AND ga.AllocatedDate <  DATEADD(DAY, 1, @ToDate)
      AND ga.AllocatedGapPay <> 0
      AND ISNULL(ga.RateBaseUsed, 0) <> 0;

    /* ------------------------------------------------------------
       3) Guaranteed shift differential add
       ------------------------------------------------------------ */
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
        pc.CalcID,
        ga.LaborPayrollID,
        ga.AllocatedDate,
        pc.JobTicketID,
        pc.JobCode,
        pc.EmpID,
        pc.Employee_Name,
        'GUARANTEED_SHIFT_DIFFERENTIAL_ADD',
        'GUARANTEE',
        'Guaranteed Shift Differential Add',
        'fms',
        'Payroll_GuaranteeAllocation',
        ga.GuaranteeAllocationID,
        gg.RuleCode,
        gg.RuleName,
        ga.AllocatedGapHours,
        NULL,
        NULL,
        NULL,
        CONVERT(decimal(12,4), 0),
        ga.RateShiftUsed,
        CONVERT(decimal(12,4), 0),
        ga.MultiplierUsed,
        CONVERT(decimal(19,4),
            ga.AllocatedGapHours
          * ISNULL(ga.RateShiftUsed, 0)
          * ISNULL(ga.MultiplierUsed, 1)
        ),
        CONVERT(bit, 1),
        CONVERT(bit, 1),
        22,
        CONCAT(ga.Explanation, ' | Shift differential portion split from guarantee base pay.')
    FROM fms.Payroll_GuaranteeAllocation ga
    JOIN fms.Payroll_GuaranteeGroup gg
        ON gg.GuaranteeGroupID = ga.GuaranteeGroupID
    JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = ga.LaborPayrollID
    WHERE ga.AllocatedDate >= @FromDate
      AND ga.AllocatedDate <  DATEADD(DAY, 1, @ToDate)
      AND ga.AllocatedGapPay <> 0
      AND ISNULL(ga.RateShiftUsed, 0) <> 0;

    /* ------------------------------------------------------------
       4) Guaranteed boom pay add
       ------------------------------------------------------------ */
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
        pc.CalcID,
        ga.LaborPayrollID,
        ga.AllocatedDate,
        pc.JobTicketID,
        pc.JobCode,
        pc.EmpID,
        pc.Employee_Name,
        'GUARANTEED_BOOM_PAY_ADD',
        'GUARANTEE',
        'Guaranteed Boom Pay Add',
        'fms',
        'Payroll_GuaranteeAllocation',
        ga.GuaranteeAllocationID,
        gg.RuleCode,
        gg.RuleName,
        ga.AllocatedGapHours,
        NULL,
        NULL,
        NULL,
        CONVERT(decimal(12,4), 0),
        CONVERT(decimal(12,4), 0),
        ga.RateBoomUsed,
        ga.MultiplierUsed,
        CONVERT(decimal(19,4),
            ga.AllocatedGapHours
          * ISNULL(ga.RateBoomUsed, 0)
          * ISNULL(ga.MultiplierUsed, 1)
        ),
        CONVERT(bit, 1),
        CONVERT(bit, 1),
        30,
        ga.Explanation
    FROM fms.Payroll_GuaranteeAllocation ga
    JOIN fms.Payroll_GuaranteeGroup gg
        ON gg.GuaranteeGroupID = ga.GuaranteeGroupID
    JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = ga.LaborPayrollID
    WHERE ga.AllocatedDate >= @FromDate
      AND ga.AllocatedDate <  DATEADD(DAY, 1, @ToDate)
      AND ga.AllocatedGapPay <> 0
      AND ISNULL(ga.RateBoomUsed, 0) <> 0;

    /* ------------------------------------------------------------
       5) Rest period premium
          New architecture:
          - Pay_Rest_Add is separate.
          - Final_Gross_Pay includes rest.
          - Ledger final gross includes rest.
       ------------------------------------------------------------ */
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
        pc.CalcID,
        pc.LaborPayrollID,
        CONVERT(date, pc.WorkDate),
        pc.JobTicketID,
        pc.JobCode,
        pc.EmpID,
        pc.Employee_Name,
        'REST_PERIOD_PREMIUM',
        'REST_PERIOD',
        'Rest Period Premium',
        'fms',
        'Payroll_Calculated',
        pc.CalcID,
        pc.Rest_Policy,
        'Rest Period Premium',
        pc.Rest_Premium_Hrs,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        CONVERT(decimal(19,4), ISNULL(pc.Pay_Rest_Add, 0)),
        CONVERT(bit, 1),
        CONVERT(bit, 1),
        40,
        CONCAT(
            'Rest premium policy=',
            COALESCE(pc.Rest_Policy, 'NULL'),
            '; forced=',
            COALESCE(CONVERT(varchar(10), pc.Rest_IsForced), 'NULL'),
            '; overlap=',
            COALESCE(CONVERT(varchar(10), pc.Rest_IsOverlap), 'NULL')
        )
    FROM fms.Payroll_Calculated pc
    WHERE pc.WorkDate >= @FromDate
      AND pc.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND ISNULL(pc.Pay_Rest_Add, 0) <> 0;

    PRINT CONCAT('Payroll component ledger rebuilt for ', @FromDate, ' through ', @ToDate, '.');
END;
