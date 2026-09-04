CREATE   VIEW [api].[v_FMS_JOB_CHECKLIST]
AS
SELECT [JobCode], [CheckListID], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_JOB_CHECKLIST], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_JOB_CHECKLIST_Raw];
