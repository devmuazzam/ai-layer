-- TCG_RawFMS.stg.FMS_UNIT_CHECK_LIST_Raw  rows=14  columns=10
CREATE TABLE [stg].[FMS_UNIT_CHECK_LIST_Raw] (
    [UnitCheckListID] int NOT NULL,
    [CheckList] varchar(50) NOT NULL,
    [Status] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [EligibleToEmail] bit NOT NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
