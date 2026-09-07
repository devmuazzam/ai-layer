/* ============================================================
   3. SHADOW EFFECTIVE PRICING-SLICE VIEW

   Existing Final_Multiplier stays untouched.

   New Effective_Final_Multiplier is:
       rest multiplier when applicable
       otherwise original Final_Multiplier.
   ============================================================ */

CREATE   VIEW api.v_UI_Pricing_Slices_Effective
AS

SELECT
    s.*,

    Normal_Final_Multiplier =
        CONVERT
        (
            decimal(10,2),
            s.Final_Multiplier
        ),

    RestSliceAdjustmentFound =
        CONVERT
        (
            bit,
            CASE
                WHEN rsa.LaborPayrollID IS NULL
                    THEN 0
                ELSE 1
            END
        ),

    RestSlice_IsForced =
        CONVERT
        (
            bit,
            ISNULL(rsa.RestForced, 0)
        ),

    rsa.RestSegmentId,

    Rest_GapHrsFromPrev =
        rsa.GapHrsFromPrev,

    rsa.RestChainHoursBeforeSlice,

    rsa.RestMultiplier,

    Effective_Final_Multiplier =
        CONVERT
        (
            decimal(10,2),
            COALESCE
            (
                rsa.EffectiveMultiplier,
                s.Final_Multiplier
            )
        ),

    rsa.RestReason,

    rsa.RestHourlyRateForCalc,

    Normal_Slice_Pay_For_Rest =
        rsa.NormalSlicePay,

    Effective_Slice_Pay =
        CONVERT
        (
            decimal(19,4),
            COALESCE
            (
                rsa.RestAdjustedSlicePay,
                s.Slice_Pay
            )
        ),

    RestPremiumDelta =
        CONVERT
        (
            decimal(19,4),
            ISNULL(rsa.RestPremiumDelta, 0)
        )

FROM api.v_UI_Pricing_Slices_Advanced s

LEFT JOIN fms.Payroll_Calculated pc
    ON pc.LaborPayrollID = s.LaborPayrollID

LEFT JOIN fms.Payroll_RestSliceAdjustment rsa
    ON rsa.LaborPayrollID = s.LaborPayrollID
   AND rsa.SliceIndex     = s.SliceIndex
   AND rsa.CalcID         = pc.CalcID;

