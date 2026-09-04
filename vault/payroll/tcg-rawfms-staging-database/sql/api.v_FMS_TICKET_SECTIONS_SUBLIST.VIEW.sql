CREATE   VIEW [api].[v_FMS_TICKET_SECTIONS_SUBLIST]
AS
SELECT [TicketSectionSubListID], [TicketSectionListID], [SubSectionName], [LineNumb], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_TICKET_SECTIONS_SUBLIST_Raw];
