CREATE   VIEW [api].[v_FMS_ETS_TICKET_SUB_SECTION]
AS
SELECT [TemplateID], [TicketSectionListID], [TicketSectionSubListID], [Visibility], [Printed], [DisplaySectionName], [LineNumb], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_ETS_TICKET_SUB_SECTION_Raw];
