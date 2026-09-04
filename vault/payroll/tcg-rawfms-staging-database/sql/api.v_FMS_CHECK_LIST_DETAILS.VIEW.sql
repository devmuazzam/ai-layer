CREATE   VIEW [api].[v_FMS_CHECK_LIST_DETAILS]
AS
SELECT [CheckListDtlID], [CheckList], [Name], [LineNumb], [Type], [Description], [Status], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [UnitCode], [Sections], [SignatureRequired], [SortNumb], [CheckListID], [ComponentCode], [RequireComments], [DeficiencyCode], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_CHECK_LIST_DETAILS_Raw];
