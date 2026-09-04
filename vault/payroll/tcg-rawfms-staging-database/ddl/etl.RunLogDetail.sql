-- TCG_RawFMS.etl.RunLogDetail  rows=7494  columns=11
CREATE TABLE [etl].[RunLogDetail] (
    [RunDetailId] int IDENTITY NOT NULL,
    [RunId] int NULL,
    [ObjectName] varchar(200) NULL,
    [RowsAffected] int NULL,
    [StartTime] datetime2(7) NULL DEFAULT (sysutcdatetime()),
    [EndTime] datetime2(7) NULL,
    [Status] varchar(20) NULL DEFAULT ('Running'),
    [StepName] nvarchar(256) NOT NULL DEFAULT (N'(unknown)'),
    [StartedAtUTC] datetime2(3) NOT NULL DEFAULT (sysutcdatetime()),
    [EndedAtUTC] datetime2(3) NULL,
    [Notes] nvarchar(4000) NULL
);
-- INDEX IX_etl_RunLogDetail_RunId NONCLUSTERED (RunId,RunDetailId)
-- PRIMARY KEY PK__RunLogDe__D7AFD3961296A935 CLUSTERED (RunDetailId)
