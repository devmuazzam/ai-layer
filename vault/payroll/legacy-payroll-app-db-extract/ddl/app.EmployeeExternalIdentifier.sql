CREATE TABLE [app].[EmployeeExternalIdentifier] (
    [EmployeeExternalIdentifierID] int IDENTITY(1,1) NOT NULL,
    [EmpID] varchar(50) NOT NULL,
    [ExternalSystemCode] varchar(50) NOT NULL,
    [ExternalIdentifierName] varchar(100) NOT NULL,
    [ExternalIdentifierValue] varchar(100) NULL,
    [IsActive] bit NOT NULL CONSTRAINT [DF_EmployeeExternalIdentifier_IsActive] DEFAULT ((1)),
    [Notes] varchar(500) NULL,
    [CreatedAtUTC] datetime2(3) NOT NULL CONSTRAINT [DF_EmployeeExternalIdentifier_CreatedAtUTC] DEFAULT (sysutcdatetime()),
    [UpdatedAtUTC] datetime2(3) NULL
);

ALTER TABLE [app].[EmployeeExternalIdentifier] ADD CONSTRAINT [PK_EmployeeExternalIdentifier] PRIMARY KEY CLUSTERED ([EmployeeExternalIdentifierID]);
CREATE UNIQUE NONCLUSTERED INDEX [UX_EmployeeExternalIdentifier_Active] ON [app].[EmployeeExternalIdentifier] ([EmpID], [ExternalSystemCode], [ExternalIdentifierName]);
CREATE UNIQUE NONCLUSTERED INDEX [UX_EmployeeExternalIdentifier_ADP_FILE_NUMBER_Value_Active] ON [app].[EmployeeExternalIdentifier] ([ExternalIdentifierValue]);
CREATE UNIQUE NONCLUSTERED INDEX [UX_EmployeeExternalIdentifier_ADP_FILE_NUMBER_EmpID_Active] ON [app].[EmployeeExternalIdentifier] ([EmpID]);
ALTER TABLE [app].[EmployeeExternalIdentifier] ADD CONSTRAINT [CK_EmployeeExternalIdentifier_ADPFileNumber_Format] CHECK ([IsActive]=(0) OR [ExternalSystemCode]<>'ADP' OR [ExternalIdentifierName]<>'FILE_NUMBER' OR [ExternalIdentifierValue] IS NOT NULL AND (len(ltrim(rtrim([ExternalIdentifierValue])))>=(1) AND len(ltrim(rtrim([ExternalIdentifierValue])))<=(6)) AND (ltrim(rtrim([ExternalIdentifierValue]))) collate Latin1_General_BIN2=(upper(ltrim(rtrim([ExternalIdentifierValue])))) collate Latin1_General_BIN2 AND NOT (ltrim(rtrim([ExternalIdentifierValue]))) collate Latin1_General_BIN2 like '%[^0-9A-Z]%');
