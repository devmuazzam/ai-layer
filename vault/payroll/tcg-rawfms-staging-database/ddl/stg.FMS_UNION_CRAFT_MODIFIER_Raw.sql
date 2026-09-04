-- TCG_RawFMS.stg.FMS_UNION_CRAFT_MODIFIER_Raw  rows=52  columns=15
CREATE TABLE [stg].[FMS_UNION_CRAFT_MODIFIER_Raw] (
    [UnionCraftModifierID] int NOT NULL,
    [UnionCode] varchar(10) NULL,
    [CraftModifierCode] varchar(10) NULL,
    [PayRateChange] numeric(7,3) NULL,
    [PayRateChangeOT] numeric(7,3) NULL,
    [PayRateChangeDB] numeric(7,3) NULL,
    [Status] bit NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime2(7) NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime2(7) NULL,
    [StartDate] datetime2(7) NULL,
    [EndDate] datetime2(7) NULL,
    [_SourceExtractedAtUTC] datetime2(0) NOT NULL,
    [_LoadedAtUTC] datetime2(0) NOT NULL
);
-- PRIMARY KEY PK_FMS_UNION_CRAFT_MODIFIER_Raw CLUSTERED (UnionCraftModifierID)
