CREATE   VIEW [api].[v_FMS_CLASSIFICATIONS]
AS
SELECT [ClassCode], [Description], [Labor], [Status], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_CLASSIFICATIONS], [UseCertifiedPayroll], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_CLASSIFICATIONS_Raw];
