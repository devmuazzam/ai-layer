
CREATE   VIEW api.v_Pricing_LaborPayroll_RateHealth
AS
SELECT
    LaborPayrollID,
    SliceCount      = COUNT_BIG(*),
    RateBase_Min    = MIN(CAST(ISNULL(Rate_Base,0) AS decimal(18,6))),
    RateBase_Max    = MAX(CAST(ISNULL(Rate_Base,0) AS decimal(18,6))),
    EffRate_Min     = MIN(CAST(ISNULL(Effective_Rate,0) AS decimal(18,6))),
    EffRate_Max     = MAX(CAST(ISNULL(Effective_Rate,0) AS decimal(18,6))),
    HasZeroRateBase = MAX(CASE WHEN ISNULL(Rate_Base,0) = 0 THEN 1 ELSE 0 END)
FROM api.v_UI_Pricing_Slices_Advanced
GROUP BY LaborPayrollID;
