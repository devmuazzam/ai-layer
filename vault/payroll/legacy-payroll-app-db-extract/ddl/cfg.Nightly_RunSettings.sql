CREATE TABLE [cfg].[Nightly_RunSettings] (
    [SettingsID] int IDENTITY(1,1) NOT NULL,
    [LookbackDays] int NOT NULL CONSTRAINT [DF_cfg_Nightly_RunSettings_LookbackDays] DEFAULT ((30)),
    [UseYesterdayAsToDate] bit NOT NULL CONSTRAINT [DF_cfg_Nightly_RunSettings_UseYesterday] DEFAULT ((1)),
    [UpdatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_cfg_Nightly_RunSettings_UpdatedAtUTC] DEFAULT (sysutcdatetime())
);

ALTER TABLE [cfg].[Nightly_RunSettings] ADD CONSTRAINT [PK_cfg_Nightly_RunSettings] PRIMARY KEY CLUSTERED ([SettingsID]);
