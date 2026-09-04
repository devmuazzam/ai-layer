CREATE   VIEW [api].[v_FMS_INDUSTRIES]
AS
SELECT [IndustryCode], [Name], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_INDUSTRIES], [Status], [NetSuiteID], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_INDUSTRIES_Raw];
