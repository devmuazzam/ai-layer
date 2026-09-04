-- TCG_RawFMS.stg.FMS_UNITTYPE_JOBTYPES_Raw  rows=42  columns=9
CREATE TABLE [stg].[FMS_UNITTYPE_JOBTYPES_Raw] (
    [JobTypeYardID] int NOT NULL,
    [JobTypeCode] char(1) NOT NULL,
    [UnitTypeID] int NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
