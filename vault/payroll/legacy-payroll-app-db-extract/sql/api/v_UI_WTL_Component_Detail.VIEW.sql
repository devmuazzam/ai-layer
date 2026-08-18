

CREATE   VIEW api.v_UI_WTL_Component_Detail
AS
SELECT
    pc.LaborPayrollID,
    pc.EmpID,
    pc.Employee_Name,
    pc.WorkDate,
    pc.JobCode,
    pc.JobTicketID,
    ComponentCode = pc.ComponentCode,
    ComponentHours = pc.ComponentHours,
    ComponentAmount = pc.ComponentAmount
FROM fms.Payroll_PayComponent pc
WHERE pc.ComponentCode LIKE 'WTL%';
