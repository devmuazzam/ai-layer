CREATE TABLE [app].[PayPeriod] (
    [PayPeriodID] int IDENTITY(1,1) NOT NULL,
    [PeriodStartDate] date NOT NULL,
    [PeriodEndDate] date NOT NULL,
    [Status] varchar(20) NOT NULL CONSTRAINT [DF_app_PayPeriod_Status] DEFAULT ('Open'),
    [ProcessedAtUTC] datetime2(0) NULL,
    [ProcessedBy] sysname NULL,
    [PayPeriodNote] nvarchar(max) NULL,
    [CreatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_app_PayPeriod_CreatedAtUTC] DEFAULT (sysutcdatetime())
);

ALTER TABLE [app].[PayPeriod] ADD CONSTRAINT [PK_app_PayPeriod] PRIMARY KEY CLUSTERED ([PayPeriodID]);
CREATE UNIQUE NONCLUSTERED INDEX [UX_app_PayPeriod_Period] ON [app].[PayPeriod] ([PeriodStartDate], [PeriodEndDate]);
CREATE NONCLUSTERED INDEX [IX_app_PayPeriod_Status] ON [app].[PayPeriod] ([Status], [PeriodEndDate] DESC);
