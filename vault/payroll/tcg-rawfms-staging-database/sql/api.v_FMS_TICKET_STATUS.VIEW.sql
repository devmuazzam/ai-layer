CREATE   VIEW [api].[v_FMS_TICKET_STATUS]
AS
SELECT [TicketStatusCode], [TicketType], [Viewed], [Download], [EnableWT], [TimeStart], [TimeEnd], [Description], [Comments], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_TICKET_STATUS_Raw];
