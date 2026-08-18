CREATE TABLE [test].[ObjectDefinitionBackup] (
    [BackupID] bigint IDENTITY(1,1) NOT NULL,
    [BackupAtUTC] datetime2(7) NOT NULL CONSTRAINT [DF_ObjectDefinitionBackup_BackupAtUTC] DEFAULT (sysutcdatetime()),
    [SchemaName] sysname NOT NULL,
    [ObjectName] sysname NOT NULL,
    [ObjectType] nvarchar(60) NULL,
    [ObjectDefinition] nvarchar(max) NOT NULL,
    [BackupNote] nvarchar(1000) NULL
);

ALTER TABLE [test].[ObjectDefinitionBackup] ADD CONSTRAINT [PK_ObjectDefinitionBackup] PRIMARY KEY CLUSTERED ([BackupID]);
