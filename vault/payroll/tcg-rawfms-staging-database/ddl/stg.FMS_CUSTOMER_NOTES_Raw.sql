-- TCG_RawFMS.stg.FMS_CUSTOMER_NOTES_Raw  rows=119  columns=13
CREATE TABLE [stg].[FMS_CUSTOMER_NOTES_Raw] (
    [CustomerNotesID] bigint NOT NULL,
    [CustCode] varchar(15) NOT NULL,
    [GroupNumb] char(2) NOT NULL,
    [Name] varchar(30) NULL,
    [PopUpMessage] varchar(max) NULL,
    [DisplayMessage] varchar(50) NULL,
    [Comments] varchar(max) NULL,
    [CreatedBy] varchar(20) NOT NULL,
    [CreatedDate] datetime NOT NULL,
    [ModifiedBy] varchar(20) NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
