CREATE   VIEW [api].[v_FMS_UNITTYPE_JOBTYPES]
AS
SELECT [JobTypeYardID], [JobTypeCode], [UnitTypeID], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_UNITTYPE_JOBTYPES_Raw];
