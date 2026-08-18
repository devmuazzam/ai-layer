
CREATE   VIEW api.v_Payroll_LaborEntry_WeekDetail
AS
SELECT
    W.*,

    /* --- Job Ticket Status UI fields --- */
    js.Is_JobTicket_Expected,
    js.Is_MissingExpectedJobTicket,
    js.Is_UnexpectedJobTicketPresent,
    js.TicketExpectationFinding,
    js.TicketExpectationSeverity,

    js.RawJobTicket_TicketType,
    js.StatusLookupTicketTypeUsed,
    js.JobTicketStatusCode,
    js.JobTicketStatusDescription,
    js.JobTicketStatusCategory,
    js.JobTicketStatusDisplay,
    js.Is_Status_Known,
    js.Is_Ticket_Started,
    js.Is_Ticket_Ended,
    js.Is_Ticket_Completed,
    js.Is_Ticket_Cancelled,

    JobTicket_Viewed = js.Viewed,
    JobTicket_Downloaded = js.Downloaded,
    JobTicket_Has_TimeStart = js.Has_TimeStart,
    JobTicket_Has_TimeEnd = js.Has_TimeEnd,
    JobTicket_TimeStart = js.TimeStart,
    JobTicket_TimeEnd = js.TimeEnd,
    JobTicket_StartWorkTime = js.StartWorkTime,
    JobTicket_EndWorkTime = js.EndWorkTime,
    JobTicket_Approved = js.Approved,
    JobTicket_ApprovedDate = js.ApprovedDate,
    JobTicket_Invoiced = js.Invoiced,
    JobTicket_MarkedInvoice = js.MarkedInvoice,
    JobTicket_ETicketStatus = js.ETicketStatus,

    /* --- Boom breakdown UI fields --- */
    bb.HasCraftModifier,
    bb.BoomEligible,
    bb.Boom_Window_Start,
    bb.Boom_Window_End,
    bb.Boom_Source_Start,
    bb.Boom_Source_End,
    bb.Act_BoomStart,
    bb.Act_BoomEnd,
    bb.Ticket_Boom_Window_Hrs,
    bb.Slice_Boom_Window_Hrs,
    bb.Slice_Boom_Hrs,
    bb.Boom_Actual_Add_Amt,
    bb.Boom_Gap_Add_Amt,
    bb.Boom_Total_Add_Amt,
    bb.Boom_Rate_Min,
    bb.Boom_Rate_Max,
    bb.Boom_Multiplier_Min,
    bb.Boom_Multiplier_Max,
    bb.First_Boom_Window_Slice_Start,
    bb.Last_Boom_Window_Slice_End,
    bb.First_Boom_Slice_Start,
    bb.Last_Boom_Slice_End,
    bb.BoomDisplayStatus

FROM rpt.v_Payroll_LaborEntry_WeekDetail AS W
LEFT JOIN api.v_UI_LaborEntry_JobTicketStatus AS js
    ON js.LaborPayrollID = W.LaborPayrollID
LEFT JOIN api.v_UI_LaborEntry_BoomBreakdown AS bb
    ON bb.LaborPayrollID = W.LaborPayrollID;
