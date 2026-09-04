-- TCG_RawFMS.stg.FMS_JOB_TYPES_Raw  rows=11  columns=10
CREATE TABLE [stg].[FMS_JOB_TYPES_Raw] (
    [JobTypeCode] char(1) NOT NULL,
    [Description] varchar(15) NOT NULL,
    [Status] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_JOB_TYPES] bit NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
