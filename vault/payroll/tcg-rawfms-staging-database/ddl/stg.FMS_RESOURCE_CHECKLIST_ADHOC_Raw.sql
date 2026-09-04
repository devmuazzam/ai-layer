-- TCG_RawFMS.stg.FMS_RESOURCE_CHECKLIST_ADHOC_Raw  rows=1237  columns=17
CREATE TABLE [stg].[FMS_RESOURCE_CHECKLIST_ADHOC_Raw] (
    [ResourceCheckListAdhocID] int NOT NULL,
    [ComponentCode] varchar(25) NULL,
    [ResourceCheckListID] int NULL,
    [Name] varchar(50) NOT NULL,
    [SignatureRequired] bit NOT NULL,
    [Status] char(1) NULL,
    [CompletedDate] datetime NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [TransactionCode] varchar(50) NULL,
    [UnitCode] varchar(15) NULL,
    [UnitCheckListID] int NULL,
    [JobTicketID] int NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
