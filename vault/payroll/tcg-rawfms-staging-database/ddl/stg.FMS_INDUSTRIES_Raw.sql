-- TCG_RawFMS.stg.FMS_INDUSTRIES_Raw  rows=33  columns=11
CREATE TABLE [stg].[FMS_INDUSTRIES_Raw] (
    [IndustryCode] varchar(5) NOT NULL,
    [Name] varchar(50) NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_INDUSTRIES] bit NULL,
    [Status] bit NOT NULL,
    [NetSuiteID] varchar(100) NULL,
    [_SourceExtractedAtUTC] datetime NOT NULL,
    [_LoadedAtUTC] datetime NOT NULL
);
