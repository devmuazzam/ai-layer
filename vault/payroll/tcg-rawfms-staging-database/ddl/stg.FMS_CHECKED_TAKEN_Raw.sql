-- TCG_RawFMS.stg.FMS_CHECKED_TAKEN_Raw  rows=31  columns=14
CREATE TABLE [stg].[FMS_CHECKED_TAKEN_Raw] (
    [CheckTakenID] int NOT NULL,
    [LastName] varchar(20) NOT NULL,
    [FirstName] varchar(20) NULL,
    [EmpID] varchar(15) NULL,
    [Flag] char(1) NOT NULL,
    [Status] bit NOT NULL,
    [GroupNumb] char(2) NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_CHECKED_TAKEN] bit NULL,
    [_SourceExtractedAtUTC] datetime NOT NULL,
    [_LoadedAtUTC] datetime NOT NULL
);
