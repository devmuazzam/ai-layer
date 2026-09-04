CREATE   VIEW [api].[v_FMS_UNIT_CHECK_LIST]
AS
SELECT [UnitCheckListID], [CheckList], [Status], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [EligibleToEmail], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_UNIT_CHECK_LIST_Raw];
