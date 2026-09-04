-- TCG_RawFMS.stg.FMS_JOB_STATUS_Raw  rows=7  columns=8
CREATE TABLE [stg].[FMS_JOB_STATUS_Raw] (
    [JobStatusCode] char(1) NOT NULL,
    [Description] varchar(30) NOT NULL,
    [CreatedBy] varchar(20) NOT NULL,
    [CreatedDate] datetime NOT NULL,
    [ModifiedBy] varchar(20) NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [_SourceExtractedAtUTC] datetime NOT NULL,
    [_LoadedAtUTC] datetime NOT NULL
);
