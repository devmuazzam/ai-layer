CREATE TABLE [app].[StoredProcedureDefinitionBackup] (
    [BackupID] int IDENTITY(1,1) NOT NULL,
    [BackupAt] datetime2(0) NOT NULL CONSTRAINT [DF__StoredPro__Backu__01DFC956] DEFAULT (sysdatetime()),
    [SchemaName] sysname NOT NULL,
    [ObjectName] sysname NOT NULL,
    [ObjectDefinition] nvarchar(max) NOT NULL
);

ALTER TABLE [app].[StoredProcedureDefinitionBackup] ADD CONSTRAINT [PK__StoredPr__EB9069E2A2A211B0] PRIMARY KEY CLUSTERED ([BackupID]);
