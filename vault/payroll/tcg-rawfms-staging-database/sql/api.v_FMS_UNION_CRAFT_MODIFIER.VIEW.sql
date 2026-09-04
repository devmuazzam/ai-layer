CREATE   VIEW [api].[v_FMS_UNION_CRAFT_MODIFIER]
AS
SELECT [UnionCraftModifierID], [UnionCode], [CraftModifierCode], [PayRateChange], [PayRateChangeOT], [PayRateChangeDB], [Status], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [StartDate], [EndDate], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_UNION_CRAFT_MODIFIER_Raw];
