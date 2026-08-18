
CREATE VIEW api.v_Pricing_Detailed_UI
AS
SELECT
    LaborPayrollID,
    JobTicketID,
    JobCode,
    EmpID,
    Employee_Name,
    TicketDate,
    WorkDate,

    Total_Hours   = Act_Total_Hrs,
    Boom_Hours    = Act_Boom_Hrs,
    Est_Gross_Pay = Final_Gross_Pay,

    Hrs_ST,
    Hrs_OT,
    Hrs_DT
FROM api.v_Payroll_Calculated;
