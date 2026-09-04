-- TCG_RawFMS.etl.RunLog  rows=214  columns=12
CREATE TABLE [etl].[RunLog] (
    [RunId] int IDENTITY NOT NULL,
    [BatchName] varchar(100) NULL,
    [StartTime] datetime2(7) NULL DEFAULT (sysutcdatetime()),
    [EndTime] datetime2(7) NULL,
    [Status] varchar(20) NULL DEFAULT ('Running'),
    [ErrorMessage] nvarchar(max) NULL,
    [RunType] nvarchar(100) NOT NULL DEFAULT (N'NightlyRawFMS'),
    [StartedAtUTC] datetime2(3) NOT NULL DEFAULT (sysutcdatetime()),
    [EndedAtUTC] datetime2(3) NULL,
    [HostName] nvarchar(128) NULL,
    [AppName] nvarchar(256) NULL,
    [LoginName] nvarchar(256) NULL
);
-- PRIMARY KEY PK__RunLog__15B9FD221398B44D CLUSTERED (RunId)
