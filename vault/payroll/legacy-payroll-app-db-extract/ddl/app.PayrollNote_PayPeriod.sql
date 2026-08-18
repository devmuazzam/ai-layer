CREATE TABLE [app].[PayrollNote_PayPeriod] (
    [NoteID] bigint IDENTITY(1,1) NOT NULL,
    [PayPeriodID] int NOT NULL,
    [NoteText] nvarchar(max) NOT NULL,
    [CreatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_app_PayrollNote_PP_CreatedAtUTC] DEFAULT (sysutcdatetime()),
    [CreatedBy] sysname NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_app_PayrollNote_PP_IsDeleted] DEFAULT ((0)),
    [DeletedAtUTC] datetime2(6) NULL,
    [DeletedBy] sysname NULL
);

ALTER TABLE [app].[PayrollNote_PayPeriod] ADD CONSTRAINT [PK_app_PayrollNote_PayPeriod] PRIMARY KEY CLUSTERED ([NoteID]);
CREATE NONCLUSTERED INDEX [IX_app_PayrollNote_PP] ON [app].[PayrollNote_PayPeriod] ([PayPeriodID], [CreatedAtUTC] DESC);
ALTER TABLE [app].[PayrollNote_PayPeriod] ADD CONSTRAINT [FK_app_PayrollNote_PP_PayPeriod] FOREIGN KEY ([PayPeriodID]) REFERENCES [app].[PayPeriod] ([PayPeriodID]);
