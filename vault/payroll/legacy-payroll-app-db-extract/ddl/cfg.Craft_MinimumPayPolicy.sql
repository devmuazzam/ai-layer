CREATE TABLE [cfg].[Craft_MinimumPayPolicy] (
    [CraftCode] varchar(50) NOT NULL,
    [ApplyMinimumPay] bit NOT NULL,
    [Notes] nvarchar(200) NULL,
    [UpdatedAtUTC] datetime2(3) NOT NULL CONSTRAINT [DF_Craft_MinPay_UpdatedAt] DEFAULT (sysutcdatetime()),
    [UpdatedBy] nvarchar(128) NULL
);

ALTER TABLE [cfg].[Craft_MinimumPayPolicy] ADD CONSTRAINT [PK__Craft_Mi__78454525D01E6FD9] PRIMARY KEY CLUSTERED ([CraftCode]);
