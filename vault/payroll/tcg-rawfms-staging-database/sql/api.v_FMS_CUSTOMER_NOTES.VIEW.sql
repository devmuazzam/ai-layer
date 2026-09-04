CREATE   VIEW [api].[v_FMS_CUSTOMER_NOTES]
AS
SELECT [CustomerNotesID], [CustCode], [GroupNumb], [Name], [PopUpMessage], [DisplayMessage], [Comments], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_CUSTOMER_NOTES_Raw];
