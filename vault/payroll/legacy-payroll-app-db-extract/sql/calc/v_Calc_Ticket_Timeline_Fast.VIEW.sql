
CREATE   VIEW calc.v_Calc_Ticket_Timeline_Fast
AS
    SELECT
        JobTicketID,
        TicketDate,
        Boom_Window_Start,
        Boom_Window_End
    FROM calc.TicketTimeline;
