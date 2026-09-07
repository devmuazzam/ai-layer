AS

SELECT
    ------------------------------------------------------------
    -- Existing employee/labor/payroll detail fields
    ------------------------------------------------------------
    d.*,

    ------------------------------------------------------------
    -- Final Payroll App hour-bucket results
    ------------------------------------------------------------
    hb.Actual_Hrs              AS Bucket_Actual_Hrs,
    hb.Payable_Hrs             AS Bucket_Payable_Hrs,

    hb.Hrs_ST                  AS Bucket_Hrs_ST,
    hb.Hrs_OT                  AS Bucket_Hrs_OT,
    hb.Hrs_DT                  AS Bucket_Hrs_DT,
    hb.Hrs_H2x                 AS Bucket_Hrs_H2x,
    hb.Hrs_H3x                 AS Bucket_Hrs_H3x,

    hb.Rule_Hrs_Total,
    hb.Rule_Hrs_Gap,
    hb.Rule_Hrs_ShiftAdd,
    hb.Rule_Hrs_WTL_Net,
    hb.Rest_Premium_Hrs_Affected,

    hb.Rule_Amt_Gap,
    hb.Rule_Amt_ShiftAdd,
    hb.Rule_Amt_WTL,
    hb.Rest_Premium_Amt,

    hb.Has_H2x,
    hb.Has_H3x,

    ------------------------------------------------------------
    -- Employee type and rate-resolution fields
    ------------------------------------------------------------
    rr.LaborEntryEmployeeType,
    rr.LaborEntryEmployeeTypeSort,

    rr.Employee_CraftCode,
    rr.Employee_CraftDescription,
    rr.Employee_PayType,
    rr.Employee_EmpTypeId,
    rr.Employee_EmpTypeDescription,
    rr.Employee_PayRate,
    rr.Employee_CraftBaseRate,

    rr.Labor_CraftCode,
    rr.Labor_CraftDescription,
    rr.Labor_CraftPayRate,
    rr.Labor_CraftModifierCode,
    rr.Labor_CraftModifierDescription,
    rr.Labor_CraftModifierPayRateAdjustment,
    rr.Labor_Source_Rate_Raw,

    PayrollBaseRate =
        rr.ResolvedBaseRate,

    PayrollBaseRateSource =
        rr.ResolvedBaseRateSource,

    PayrollModifierRate =
        rr.ResolvedModifierRate,

    PayrollModifierRateSource =
        rr.ResolvedModifierRateSource,

    PayrollCombinedRate =
        rr.ResolvedCombinedRate,

    FmsSourceRate =
        rr.Labor_Source_Rate_Raw,

    SourceRateLooksLikePayrollBase =
        rr.SourceRateLooksLikeResolvedBase,

    SourceRateLooksLikePayrollCombined =
        rr.SourceRateLooksLikeBasePlusModifier,

    SourceRateDifferenceFromPayrollBase =
        rr.SourceRateDifferenceFromResolvedBase,

    SourceRateDifferenceFromPayrollCombined =
        rr.SourceRateDifferenceFromResolvedCombined,

    rr.CraftCodeMismatchFlag,
    rr.CraftCodeMismatchMessage,

    rr.RateResolutionReviewFlag,
    rr.RateResolutionReviewMessage,

    ------------------------------------------------------------
    -- Shared hour-bucket validation fields
    ------------------------------------------------------------
    hb.Expected_Payable_Hrs,
    hb.Bucketed_Payable_Hrs,
    hb.Bucket_Hrs_TieOut_Difference,
    hb.Bucket_Hrs_TieOut_Status,

    ------------------------------------------------------------
    -- New bucket-source traceability fields
    ------------------------------------------------------------
    hb.Bucket_Source,
    hb.Has_Pricing_Slices,
    hb.Pricing_Slice_Count,
    hb.Pricing_Slice_Hours,
    hb.Bucket_Source_Review_Flag,
    hb.Bucket_Source_Review_Message

FROM api.v_Payroll_LaborEntry_WeekDetail AS d

LEFT JOIN api.v_UI_Payroll_LaborEntry_HourBuckets AS hb
    ON hb.LaborPayrollID = d.LaborPayrollID

LEFT JOIN api.v_UI_LaborEntry_TypeRateResolution AS rr
    ON rr.LaborPayrollID = d.LaborPayrollID;

