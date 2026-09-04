CREATE   VIEW [api].[v_FMS_JOB_TYPES]
AS
SELECT [JobTypeCode], [Description], [Status], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_JOB_TYPES], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_JOB_TYPES_Raw];
