
CREATE   VIEW audit.v_LaborEntry_AuditHeader
AS
SELECT
      P.LaborPayrollID
    , P.JobTicketID
    , P.JobCode
    , P.EmpID
    , P.Employee_Name
    , P.TicketDate
    , P.WorkDate
    , P.Act_Total_Hrs
    , P.Act_Boom_Hrs
    , P.Gap_Hrs_Total
    , P.Gap_Hrs_Boom
    , P.Pay_Total_Hrs
    , P.Hrs_ST
    , P.Hrs_OT
    , P.Hrs_DT
    , P.Pay_Actual_Gross
    , P.Pay_Gap_Add
    , P.Final_Gross_Pay
    , P.Audit_Min_Rule
    , P.Audit_Gap_Mult

    -- Helpful audit math
    , CAST((P.Hrs_ST + (1.5 * P.Hrs_OT) + (2.0 * P.Hrs_DT)) AS decimal(12,4)) AS Audit_WeightedHours
    , CAST(P.Pay_Actual_Gross / NULLIF((P.Hrs_ST + (1.5 * P.Hrs_OT) + (2.0 * P.Hrs_DT)), 0) AS decimal(12,4)) AS Audit_ImpliedBaseRate

    -- Ticket timeline: “what times did we use?”
    , TT.TicketDate               AS TicketTimeline_TicketDate
    , TT.Shift_Window_Start
    , TT.Shift_Window_End
    , TT.Shift_Source_Start
    , TT.Shift_Source_End
    , TT.Boom_Window_Start
    , TT.Boom_Window_End
    , TT.Boom_Source_Start
    , TT.Boom_Source_End
    , TT.Act_BoomStart
    , TT.Act_BoomEnd
    , TT.CalculatedAt             AS TicketTimeline_CalculatedAt

FROM fms.Payroll_Calculated P
LEFT JOIN calc.TicketTimeline TT
    ON TT.JobTicketID = P.JobTicketID;
