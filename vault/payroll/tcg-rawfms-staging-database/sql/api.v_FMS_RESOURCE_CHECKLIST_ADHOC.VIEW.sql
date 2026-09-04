CREATE   VIEW [api].[v_FMS_RESOURCE_CHECKLIST_ADHOC]
AS
SELECT [ResourceCheckListAdhocID], [ComponentCode], [ResourceCheckListID], [Name], [SignatureRequired], [Status], [CompletedDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [TransactionCode], [UnitCode], [UnitCheckListID], [JobTicketID], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_RESOURCE_CHECKLIST_ADHOC_Raw];
