CREATE   VIEW [api].[v_FMS_UNIT_TYPE_DETAILS]
AS
SELECT [UnitTypeDtlID], [UnitCode], [UnitTypeID], [UnitSchedCode], [PrimaryType], [Status], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_UNIT_TYPE_DETAILS], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_UNIT_TYPE_DETAILS_Raw];
