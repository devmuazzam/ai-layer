
CREATE   VIEW [rpt].[v_UI_Payroll_Audit] AS
SELECT 
    -- 1. IDs (Hidden context)
    C.LaborPayrollID,
    C.JobTicketID,
    C.EmpID,

    -- 2. Who and When
    C.Employee_Name AS [Employee],
    C.JobCode AS [Job Code],
    
    -- [FIX]: Include BOTH the Raw Date (for Logic) and Formatted Date (for Display)
    C.WorkDate AS [WorkDate_Raw], 
    FORMAT(C.WorkDate, 'MM/dd/yyyy') AS [Work Date],
    
    -- 3. THE "WHY" (Context from Timeline)
    FORMAT(L.Pay_Start_Rounded, 'hh:mm tt') AS [Shift Start],
    FORMAT(L.Pay_End_Rounded, 'hh:mm tt') AS [Shift End],
    
    -- 4. The Calculated Numbers
    C.Act_Total_Hrs AS [Hours Worked],
    C.Gap_Hrs_Total AS [Gap Hours (Min)],
    C.Gap_Hrs_Boom AS [Gap Hours (Boom)],
    
    -- 5. The Audit Flags
    CASE WHEN C.Gap_Hrs_Total > 0 THEN 'YES' ELSE '' END AS [Flag: Min Guarantee],
    CASE WHEN C.Gap_Hrs_Boom > 0 THEN 'YES' ELSE '' END AS [Flag: Boom Premium],
    CASE WHEN C.Final_Gross_Pay = 0 AND C.Pay_Total_Hrs > 0 THEN 'YES' ELSE '' END AS [Flag: Missing Rate],

    -- 6. Financials
    C.Final_Gross_Pay AS [Gross Pay],
    C.Pay_Gap_Add AS [Cost of Guarantee]

FROM fms.Payroll_Calculated C
LEFT JOIN calc.v_Calc_Labor_Timeline L ON C.LaborPayrollID = L.LaborPayrollID;
