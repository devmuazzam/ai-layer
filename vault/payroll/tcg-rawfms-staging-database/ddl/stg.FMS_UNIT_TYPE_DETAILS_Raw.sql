-- TCG_RawFMS.stg.FMS_UNIT_TYPE_DETAILS_Raw  rows=563  columns=13
CREATE TABLE [stg].[FMS_UNIT_TYPE_DETAILS_Raw] (
    [UnitTypeDtlID] int NOT NULL,
    [UnitCode] varchar(15) NOT NULL,
    [UnitTypeID] int NOT NULL,
    [UnitSchedCode] varchar(5) NULL,
    [PrimaryType] bit NOT NULL,
    [Status] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_UNIT_TYPE_DETAILS] bit NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
