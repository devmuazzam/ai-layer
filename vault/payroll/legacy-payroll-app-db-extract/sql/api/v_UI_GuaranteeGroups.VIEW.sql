
CREATE   VIEW api.v_UI_GuaranteeGroups
AS
SELECT
    g.GuaranteeGroupID,
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
    g.ActualQualifyingHours,
    g.MinimumHours,
    g.GapHours,
    g.PayComponent,
    g.MultiplierUsed,
    g.TriggeredFlag,
    g.SatisfiedFlag,
    g.WorkDateFrom,
    g.WorkDateTo,
    g.CalculatedAtUTC
FROM fms.Payroll_GuaranteeGroup g;
