-- TCG_RawFMS.stg.FMS_TICKET_STATUS_Raw  rows=53  columns=15
CREATE TABLE [stg].[FMS_TICKET_STATUS_Raw] (
    [TicketStatusCode] char(1) NOT NULL,
    [TicketType] varchar(10) NOT NULL,
    [Viewed] bit NOT NULL,
    [Download] bit NOT NULL,
    [EnableWT] bit NOT NULL,
    [TimeStart] bit NOT NULL,
    [TimeEnd] bit NOT NULL,
    [Description] varchar(30) NOT NULL,
    [Comments] varchar(max) NULL,
    [CreatedBy] varchar(20) NOT NULL,
    [CreatedDate] datetime NOT NULL,
    [ModifiedBy] varchar(20) NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [_SourceExtractedAtUTC] datetime NOT NULL,
    [_LoadedAtUTC] datetime NOT NULL
);
