-- TCG_RawFMS.stg.FMS_CHECK_LIST_Raw  rows=630  columns=15
CREATE TABLE [stg].[FMS_CHECK_LIST_Raw] (
    [CheckList] varchar(50) NOT NULL,
    [Status] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_CHECK_LIST] bit NULL,
    [CheckListID] int NOT NULL,
    [UnitCode] varchar(15) NULL,
    [UnitCheckListID] int NULL,
    [Sections] varchar(5) NULL,
    [EligibleToEmail] bit NOT NULL,
    [ComponentCode] varchar(25) NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
