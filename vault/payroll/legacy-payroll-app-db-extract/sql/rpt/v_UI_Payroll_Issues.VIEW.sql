CREATE   VIEW rpt.v_UI_Payroll_Issues
AS
SELECT
    ce.RunId,
    ce.CalcRunAt,
    ce.Reason,
    Severity =
        CASE
            WHEN ce.Reason LIKE 'RestPeriod_Overlap%' THEN 'Warning'
            WHEN ce.Reason LIKE 'RestPeriod_RateMissing%' THEN 'Warning'
            WHEN ce.Reason LIKE 'Shift_Assumed%' THEN 'Warning'
            ELSE 'Error'
        END,
    ce.LaborPayrollID,
    ce.WorkDate,
    ce.EmpID,
    ce.Employee_Name,
    ce.JobTicketID,
    ce.JobCode,
    ce.Shift_Start,
    ce.Shift_End
FROM fms.Payroll_CalcException ce;
