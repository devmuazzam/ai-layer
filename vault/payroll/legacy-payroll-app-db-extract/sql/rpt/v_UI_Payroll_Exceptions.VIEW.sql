
CREATE   VIEW [rpt].[v_UI_Payroll_Exceptions]
AS
SELECT
    e.RunId,
    e.CalcRunAt,
    Severity =
        CASE
            WHEN e.Reason LIKE 'Warn_%' THEN 'Warning'
            WHEN e.Reason LIKE 'Shift_Assumed%' THEN 'Warning'
            ELSE 'Error'
        END,
    e.Reason,
    e.LaborPayrollID,
    e.WorkDate,
    e.EmpID,
    e.EmpID_Raw,
    e.Employee_Name,
    e.JobTicketID,
    e.JobCode,
    e.Shift_Start,
    e.Shift_End,

    b.LaborType,
    b.Is_AtomLabor,
    b.Is_AtomLabor_Label,

    TicketExpectation       = COALESCE(tp.TicketExpectation, 'Unknown'),
    TicketExpectation_Notes = tp.Notes
FROM fms.Payroll_CalcException e
LEFT JOIN app.v_Base_LaborPayroll b
  ON b.LaborPayrollID = e.LaborPayrollID
LEFT JOIN cfg.LaborType_TicketPolicy tp
  ON tp.LaborType = b.LaborType
 AND tp.Is_AtomLabor = b.Is_AtomLabor;
