-- TCG_RawFMS.stg.FMS_ETS_TICKET_SUB_SECTION_Raw  rows=42  columns=13
CREATE TABLE [stg].[FMS_ETS_TICKET_SUB_SECTION_Raw] (
    [TemplateID] int NOT NULL,
    [TicketSectionListID] int NOT NULL,
    [TicketSectionSubListID] int NOT NULL,
    [Visibility] bit NOT NULL,
    [Printed] bit NOT NULL,
    [DisplaySectionName] varchar(100) NULL,
    [LineNumb] int NOT NULL,
    [CreatedBy] varchar(20) NOT NULL,
    [CreatedDate] datetime NOT NULL,
    [ModifiedBy] varchar(20) NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
