CREATE   VIEW [api].[v_FMS_CHECK_LIST]
AS
SELECT [CheckList], [Status], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_CHECK_LIST], [CheckListID], [UnitCode], [UnitCheckListID], [Sections], [EligibleToEmail], [ComponentCode], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_CHECK_LIST_Raw];
