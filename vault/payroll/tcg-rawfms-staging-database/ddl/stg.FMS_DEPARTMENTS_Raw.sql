-- TCG_RawFMS.stg.FMS_DEPARTMENTS_Raw  rows=10  columns=18
CREATE TABLE [stg].[FMS_DEPARTMENTS_Raw] (
    [DeptCode] varchar(6) NOT NULL,
    [Name] varchar(30) NOT NULL,
    [PONumb] numeric(13,0) NULL,
    [Flag] char(1) NULL,
    [InvoiceNumb] numeric(13,0) NULL,
    [JobCode] numeric(13,0) NULL,
    [QuoteNumb] numeric(13,0) NULL,
    [Branch] varchar(25) NULL,
    [Status] bit NOT NULL,
    [GSTNo] varchar(25) NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_DEPARTMENTS] bit NULL,
    [ExpAcct] bit NOT NULL,
    [_SourceExtractedAtUTC] datetime NOT NULL,
    [_LoadedAtUTC] datetime NOT NULL
);
