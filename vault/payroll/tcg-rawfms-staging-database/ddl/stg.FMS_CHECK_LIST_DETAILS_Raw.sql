-- TCG_RawFMS.stg.FMS_CHECK_LIST_DETAILS_Raw  rows=7728  columns=21
CREATE TABLE [stg].[FMS_CHECK_LIST_DETAILS_Raw] (
    [CheckListDtlID] int NOT NULL,
    [CheckList] varchar(50) NULL,
    [Name] varchar(max) NULL,
    [LineNumb] smallint NULL,
    [Type] char(1) NULL,
    [Description] varchar(max) NULL,
    [Status] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [UnitCode] varchar(15) NULL,
    [Sections] varchar(5) NULL,
    [SignatureRequired] bit NOT NULL,
    [SortNumb] int NULL,
    [CheckListID] int NULL,
    [ComponentCode] varchar(25) NULL,
    [RequireComments] bit NULL,
    [DeficiencyCode] varchar(15) NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
