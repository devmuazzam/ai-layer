CREATE TABLE [app].[PayrollSnapshot] (
    [SnapshotID] bigint IDENTITY(1,1) NOT NULL,
    [PayPeriodID] int NOT NULL,
    [SnapshotAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_app_PayrollSnapshot_SnapshotAtUTC] DEFAULT (sysutcdatetime()),
    [SourceRunId] int NULL,
    [SnapshotNote] nvarchar(max) NULL,
    [CreatedBy] sysname NULL
);

ALTER TABLE [app].[PayrollSnapshot] ADD CONSTRAINT [PK_app_PayrollSnapshot] PRIMARY KEY CLUSTERED ([SnapshotID]);
CREATE NONCLUSTERED INDEX [IX_app_PayrollSnapshot_PayPeriod] ON [app].[PayrollSnapshot] ([PayPeriodID], [SnapshotAtUTC] DESC);
ALTER TABLE [app].[PayrollSnapshot] ADD CONSTRAINT [FK_app_PayrollSnapshot_PayPeriod] FOREIGN KEY ([PayPeriodID]) REFERENCES [app].[PayPeriod] ([PayPeriodID]);
