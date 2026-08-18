CREATE TABLE [calc].[TicketTimeline] (
    [JobTicketID] int NOT NULL,
    [TicketDate] datetime2(0) NULL,
    [Boom_Window_Start] datetime2(0) NULL,
    [Boom_Window_End] datetime2(0) NULL,
    [CalculatedAt] datetime2(0) NOT NULL CONSTRAINT [DF_calc_TicketTimeline_CalcAt] DEFAULT (sysdatetime()),
    [JobCode] varchar(50) NULL,
    [Act_BoomStart] datetime2(0) NULL,
    [Act_BoomEnd] datetime2(0) NULL,
    [Shift_Window_Start] datetime2(0) NULL,
    [Shift_Window_End] datetime2(0) NULL,
    [Shift_Source_Start] varchar(10) NULL,
    [Shift_Source_End] varchar(10) NULL,
    [Boom_Source_Start] varchar(10) NULL,
    [Boom_Source_End] varchar(10) NULL
);

ALTER TABLE [calc].[TicketTimeline] ADD CONSTRAINT [PK_calc_TicketTimeline] PRIMARY KEY CLUSTERED ([JobTicketID]);
CREATE NONCLUSTERED INDEX [IX_TicketTimeline_JobTicketID] ON [calc].[TicketTimeline] ([JobTicketID]) INCLUDE ([TicketDate], [Boom_Window_Start], [Boom_Window_End]);
CREATE NONCLUSTERED INDEX [IX_TicketTimeline_JobTicketID_Windows] ON [calc].[TicketTimeline] ([JobTicketID]) INCLUDE ([TicketDate], [Boom_Window_Start], [Boom_Window_End], [Shift_Window_Start], [Shift_Window_End]);
