CREATE TABLE [etl].[RunLog] (
    [RunId] int IDENTITY(1,1) NOT NULL,
    [RunType] varchar(50) NOT NULL,
    [StartedAtUTC] datetime2(3) NOT NULL CONSTRAINT [DF__RunLog__StartedA__2B0A656D] DEFAULT (sysutcdatetime()),
    [EndedAtUTC] datetime2(3) NULL,
    [Status] varchar(20) NOT NULL CONSTRAINT [DF__RunLog__Status__2BFE89A6] DEFAULT ('Running'),
    [HostName] sysname NULL CONSTRAINT [DF__RunLog__HostName__2CF2ADDF] DEFAULT (host_name()),
    [AppName] sysname NULL CONSTRAINT [DF__RunLog__AppName__2DE6D218] DEFAULT (app_name()),
    [LoginName] sysname NULL CONSTRAINT [DF__RunLog__LoginNam__2EDAF651] DEFAULT (original_login()),
    [ErrorMessage] nvarchar(max) NULL
);

ALTER TABLE [etl].[RunLog] ADD CONSTRAINT [PK__RunLog__A259D4DD1C0CE07E] PRIMARY KEY CLUSTERED ([RunId]);
