
CREATE   VIEW api.v_UI_GuaranteeAllocations
AS
SELECT
    a.GuaranteeAllocationID,
    a.GuaranteeGroupID,
    g.RunId,
    g.RuleCode,
    g.RuleName,
    g.ScopeBasis,
    g.GroupScope,
    g.EmpID,
    g.Employee_Name,
    g.ShiftAnchorDate,
    g.CalendarDate,
    GuaranteeDate = COALESCE(g.CalendarDate, g.ShiftAnchorDate),

    a.LaborPayrollID,
    pc.JobTicketID,
    pc.JobCode,
    pc.WorkDate,

    a.AllocatedDate,
    a.AllocatedGapHours,
    a.AllocatedGapPay,
    a.AllocationMethod,

    a.RateBaseUsed,
    a.RateShiftUsed,
    a.RateBoomUsed,
    a.MultiplierUsed,
    a.Explanation,
    a.CalculatedAtUTC
FROM fms.Payroll_GuaranteeAllocation a
JOIN fms.Payroll_GuaranteeGroup g
    ON g.GuaranteeGroupID = a.GuaranteeGroupID
LEFT JOIN fms.Payroll_Calculated pc
    ON pc.LaborPayrollID = a.LaborPayrollID;
