CREATE   VIEW [api].[v_FMS_UNION_CRAFT]
AS
SELECT [UnioncraftID], [UnionCode], [CraftCode], [PayRate], [BillingRate], [Comments], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [StartDate], [EndDate], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_UNION_CRAFT_Raw];
