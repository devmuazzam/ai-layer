-- TCG_RawFMS.stg.FMS_TICKET_SECTIONS_SUBLIST_Raw  rows=21  columns=10
CREATE TABLE [stg].[FMS_TICKET_SECTIONS_SUBLIST_Raw] (
    [TicketSectionSubListID] int NOT NULL,
    [TicketSectionListID] int NOT NULL,
    [SubSectionName] varchar(100) NOT NULL,
    [LineNumb] int NOT NULL,
    [CreatedBy] varchar(20) NOT NULL,
    [CreatedDate] datetime NOT NULL,
    [ModifiedBy] varchar(20) NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
