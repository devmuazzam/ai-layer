
/* ------------------------------------------------------------
   1) Detail view: one row per pay component
   ------------------------------------------------------------ */
CREATE   VIEW api.v_UI_Payroll_PayComponent_Detail
AS
SELECT
    p.PayComponentID,
    p.RunId,
    p.CalcID,
    p.LaborPayrollID,

    p.WorkDate,
    p.JobTicketID,
    p.JobCode,
    p.EmpID,
    p.Employee_Name,

    p.ComponentCode,
    p.ComponentGroup,
    p.ComponentLabel,

    p.SourceSchema,
    p.SourceTable,
    p.SourceID,
    p.SourceRuleCode,
    p.SourceRuleName,

    p.ComponentHours,
    p.Hrs_ST,
    p.Hrs_OT,
    p.Hrs_DT,

    p.RateBaseUsed,
    p.RateShiftUsed,
    p.RateBoomUsed,
    p.MultiplierUsed,

    p.ComponentAmount,

    p.IncludedInFinalGross,
    p.IncludedInPayableGross,
    p.DisplaySort,
    p.Explanation,
    p.CalculatedAtUTC,

    ComponentAmount_Display =
        CONVERT(varchar(30), CONVERT(decimal(19,2), p.ComponentAmount)),

    IncludeStatusLabel =
        CASE
            WHEN p.IncludedInFinalGross = 1 AND p.IncludedInPayableGross = 1
                THEN 'Included in current final gross and payable gross'
            WHEN p.IncludedInFinalGross = 0 AND p.IncludedInPayableGross = 1
                THEN 'Included in payable gross only'
            WHEN p.IncludedInFinalGross = 1 AND p.IncludedInPayableGross = 0
                THEN 'Included in current final gross only'
            ELSE 'Not included in gross totals'
        END

FROM fms.Payroll_PayComponent p;
