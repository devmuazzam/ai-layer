CREATE TABLE [etl].[UIRefreshLog] (
    [UIRefreshID] bigint IDENTITY(1,1) NOT NULL,
    [RequestedAtUTC] datetime2(3) NOT NULL CONSTRAINT [DF_UIRefreshLog_RequestedAtUTC] DEFAULT (sysutcdatetime()),
    [StartedAtUTC] datetime2(3) NULL,
    [EndedAtUTC] datetime2(3) NULL,
    [RequestedBy] sysname NULL,
    [AnyDateInWeek] date NULL,
    [PeriodStartDate] date NULL,
    [PeriodEndDate] date NULL,
    [Status] varchar(30) NOT NULL,
    [Message] nvarchar(4000) NULL,
    [RawFMS_RunId] int NULL,
    [RawFMS_Status] varchar(30) NULL,
    [PayrollAPP_RunId] int NULL,
    [PayrollAPP_Status] varchar(30) NULL,
    [HostName] sysname NULL,
    [AppName] nvarchar(128) NULL,
    [LoginName] sysname NULL
);

ALTER TABLE [etl].[UIRefreshLog] ADD CONSTRAINT [PK_UIRefreshLog] PRIMARY KEY CLUSTERED ([UIRefreshID]);
