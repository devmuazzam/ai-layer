-- TCG_RawFMS.stg.FMS_ETHNICITY_Raw  rows=7  columns=10
CREATE TABLE [stg].[FMS_ETHNICITY_Raw] (
    [EthnicityCode] char(1) NOT NULL,
    [Description] varchar(25) NOT NULL,
    [Status] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_ETHNICITY] bit NOT NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
