CREATE   VIEW [api].[v_FMS_JOB_STATUS]
AS
SELECT [JobStatusCode], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_JOB_STATUS_Raw];
