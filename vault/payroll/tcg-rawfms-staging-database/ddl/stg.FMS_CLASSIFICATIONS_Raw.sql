-- TCG_RawFMS.stg.FMS_CLASSIFICATIONS_Raw  rows=24  columns=12
CREATE TABLE [stg].[FMS_CLASSIFICATIONS_Raw] (
    [ClassCode] varchar(15) NOT NULL,
    [Description] varchar(50) NOT NULL,
    [Labor] char(1) NOT NULL,
    [Status] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_CLASSIFICATIONS] bit NULL,
    [UseCertifiedPayroll] bit NOT NULL,
    [_SourceExtractedAtUTC] datetime NOT NULL,
    [_LoadedAtUTC] datetime NOT NULL
);
