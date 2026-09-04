-- TCG_RawFMS.stg.FMS_TERMS_Raw  rows=12  columns=18
CREATE TABLE [stg].[FMS_TERMS_Raw] (
    [TermID] int NOT NULL,
    [TermName] varchar(20) NOT NULL,
    [DaysDiscount] smallint NULL,
    [DateDiscount] smallint NULL,
    [DayDue] smallint NULL,
    [DateDue] smallint NULL,
    [DiscPer] numeric(9,2) NULL,
    [AcctTermsCode] varchar(30) NULL,
    [Status] bit NOT NULL,
    [ShowTerms] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_TERMS] bit NULL,
    [EOM] bit NOT NULL,
    [_SourceExtractedAtUTC] datetime NOT NULL,
    [_LoadedAtUTC] datetime NOT NULL
);
