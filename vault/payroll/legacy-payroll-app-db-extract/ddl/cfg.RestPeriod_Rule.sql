CREATE TABLE [cfg].[RestPeriod_Rule] (
    [RestRuleID] int IDENTITY(1,1) NOT NULL,
    [RuleName] varchar(50) NOT NULL CONSTRAINT [DF_cfg_RestPeriod_Rule_RuleName] DEFAULT ('PunitiveUntil8Off'),
    [RequiredRestHours] decimal(9,2) NOT NULL CONSTRAINT [DF_cfg_RestPeriod_Rule_RequiredRestHours] DEFAULT ((8.00)),
    [OTFloorMultiplier] decimal(9,2) NOT NULL CONSTRAINT [DF_cfg_RestPeriod_Rule_OTFloorMultiplier] DEFAULT ((1.50)),
    [StitchGapMinutes] int NOT NULL CONSTRAINT [DF_cfg_RestPeriod_Rule_StitchGapMinutes] DEFAULT ((30)),
    [TriggerMode] varchar(30) NOT NULL CONSTRAINT [DF_cfg_RestPeriod_Rule_TriggerMode] DEFAULT ('ActHoursOver8'),
    [IsEnabled] bit NOT NULL CONSTRAINT [DF_cfg_RestPeriod_Rule_IsEnabled] DEFAULT ((1)),
    [UpdatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_cfg_RestPeriod_Rule_UpdatedAtUTC] DEFAULT (sysutcdatetime())
);

ALTER TABLE [cfg].[RestPeriod_Rule] ADD CONSTRAINT [PK_cfg_RestPeriod_Rule] PRIMARY KEY CLUSTERED ([RestRuleID]);
