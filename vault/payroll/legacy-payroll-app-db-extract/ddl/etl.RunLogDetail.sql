CREATE TABLE [etl].[RunLogDetail] (
    [RunDetailId] int IDENTITY(1,1) NOT NULL,
    [RunId] int NOT NULL,
    [StepName] varchar(100) NOT NULL,
    [StartedAtUTC] datetime2(3) NOT NULL CONSTRAINT [DF__RunLogDet__Start__31B762FC] DEFAULT (sysutcdatetime()),
    [EndedAtUTC] datetime2(3) NULL,
    [RowsAffected] bigint NULL,
    [Notes] nvarchar(4000) NULL,
    [Status] varchar(20) NOT NULL CONSTRAINT [DF_etl_RunLogDetail_Status] DEFAULT ('Running')
);

ALTER TABLE [etl].[RunLogDetail] ADD CONSTRAINT [PK__RunLogDe__7BF1D872832437D1] PRIMARY KEY CLUSTERED ([RunDetailId]);
CREATE NONCLUSTERED INDEX [IX_etl_RunLogDetail_RunId] ON [etl].[RunLogDetail] ([RunId]) INCLUDE ([StepName], [Status], [StartedAtUTC], [EndedAtUTC], [RowsAffected], [Notes]);
ALTER TABLE [etl].[RunLogDetail] ADD CONSTRAINT [FK_etl_RunLogDetail_RunLog] FOREIGN KEY ([RunId]) REFERENCES [etl].[RunLog] ([RunId]);
