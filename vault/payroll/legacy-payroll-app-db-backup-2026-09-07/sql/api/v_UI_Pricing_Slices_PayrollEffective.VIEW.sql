/* ============================================================
   REST PERIOD - PHASE RP-6B2
   CORRECTED EFFECTIVE BUCKET CUTOVER

   Step 1:
   CREATE VIEW must be first statement in its batch.
   ============================================================ */

CREATE   VIEW api.v_UI_Pricing_Slices_PayrollEffective
AS
SELECT
    e.LaborPayrollID,
    e.JobTicketID,
    e.JobCode,
    e.EmpID,
    e.Employee_Name,
    e.TicketDate,
    e.WorkDate,

    e.SliceIndex,
    e.Slice_Start,
    e.Slice_End,
    e.Slice_Hours,

    e.Day_Type,
    e.Accumulation_Status,

    e.Is_Boom_Active,
    e.Is_Outside_Window,

    e.Rate_Base,
    e.Rate_Shift,
    e.Rate_Boom,
    e.Rate_Boom_Applied,

    e.Mul_OT,
    e.Mul_DT,
    e.Mul_Sat,
    e.Mul_Sun,
    e.Mul_Hol,

    /* Authoritative multiplier for downstream classification */
    Final_Multiplier =
        e.Effective_Final_Multiplier,

    e.Hourly_Rate_Raw,

    Effective_Rate =
        CONVERT
        (
            decimal(19,6),
            CASE
                WHEN ISNULL(e.Slice_Hours, 0) <> 0
                    THEN
                        e.Effective_Slice_Pay
                        / NULLIF(e.Slice_Hours, 0)
                ELSE e.Effective_Rate
            END
        ),

    /* Authoritative slice pay for WTL deductions */
    Slice_Pay =
        e.Effective_Slice_Pay,

    /* Audit / trace fields */
    e.Normal_Final_Multiplier,
    e.RestSliceAdjustmentFound,
    e.RestSlice_IsForced,
    e.RestSegmentId,
    e.Rest_GapHrsFromPrev,
    e.RestChainHoursBeforeSlice,
    e.RestMultiplier,
    e.Effective_Final_Multiplier,
    e.RestReason,
    e.RestPremiumDelta

FROM api.v_UI_Pricing_Slices_Effective AS e;

