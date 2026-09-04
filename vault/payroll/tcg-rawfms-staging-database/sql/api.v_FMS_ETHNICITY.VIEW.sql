CREATE   VIEW [api].[v_FMS_ETHNICITY]
AS
SELECT [EthnicityCode], [Description], [Status], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_ETHNICITY], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_ETHNICITY_Raw];
