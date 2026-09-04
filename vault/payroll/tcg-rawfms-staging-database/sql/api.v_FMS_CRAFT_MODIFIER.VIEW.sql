CREATE   VIEW [api].[v_FMS_CRAFT_MODIFIER]
AS
SELECT [CraftModifierCode], [Description], [Status], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_CRAFT_MODIFIER], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_CRAFT_MODIFIER_Raw];
