-- TCG_RawFMS.stg.FMS_CRAFT_MODIFIER_Raw  rows=52  columns=10
CREATE TABLE [stg].[FMS_CRAFT_MODIFIER_Raw] (
    [CraftModifierCode] varchar(10) NOT NULL,
    [Description] varchar(30) NULL,
    [Status] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_CRAFT_MODIFIER] bit NULL,
    [_SourceExtractedAtUTC] datetime NOT NULL,
    [_LoadedAtUTC] datetime NOT NULL
);
