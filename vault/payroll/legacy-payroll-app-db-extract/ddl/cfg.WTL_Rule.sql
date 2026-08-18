CREATE TABLE [cfg].[WTL_Rule] (
    [WTL_RuleID] int IDENTITY(1,1) NOT NULL,
    [UnionCode] varchar(20) NOT NULL,
    [RuleName] varchar(100) NOT NULL,
    [EffectiveStartDate] date NOT NULL CONSTRAINT [DF_WTL_Rule_EffectiveStartDate] DEFAULT ('2025-01-01'),
    [EffectiveEndDate] date NULL,
    [MealPeriodHours] decimal(10,2) NOT NULL CONSTRAINT [DF_WTL_Rule_MealPeriodHours] DEFAULT ((0.50)),
    [GroupLookbackDays] int NOT NULL CONSTRAINT [DF_WTL_Rule_GroupLookbackDays] DEFAULT ((4)),
    [GroupLookaheadDays] int NOT NULL CONSTRAINT [DF_WTL_Rule_GroupLookaheadDays] DEFAULT ((4)),
    [StitchGapMinutes] int NOT NULL CONSTRAINT [DF_WTL_Rule_StitchGapMinutes] DEFAULT ((0)),
    [MissingTokenBehavior] varchar(50) NOT NULL CONSTRAINT [DF_WTL_Rule_MissingTokenBehavior] DEFAULT ('ASSUME_WTL_0_WARN'),
    [MealAssignmentPolicy] varchar(100) NOT NULL CONSTRAINT [DF_WTL_Rule_MealAssignmentPolicy] DEFAULT ('TAKEN_EARLIEST_THEN_WTL_REMAINDER'),
    [WeekdaySTStartMode] varchar(50) NOT NULL CONSTRAINT [DF_WTL_Rule_WeekdaySTStartMode] DEFAULT ('WTL_DT_FLOOR'),
    [NonSTStartMode] varchar(50) NOT NULL CONSTRAINT [DF_WTL_Rule_NonSTStartMode] DEFAULT ('WTL_APPLICABLE_ADD'),
    [SaturdayMode] varchar(50) NOT NULL CONSTRAINT [DF_WTL_Rule_SaturdayMode] DEFAULT ('WTL_APPLICABLE_ADD'),
    [SundayMode] varchar(50) NOT NULL CONSTRAINT [DF_WTL_Rule_SundayMode] DEFAULT ('WTL_APPLICABLE_ADD'),
    [SpecialSaturdayMode] varchar(50) NOT NULL CONSTRAINT [DF_WTL_Rule_SpecialSaturdayMode] DEFAULT ('WTL_APPLICABLE_ADD'),
    [HolidayMode] varchar(50) NOT NULL CONSTRAINT [DF_WTL_Rule_HolidayMode] DEFAULT ('WTL_APPLICABLE_ADD'),
    [AddRateBasis] varchar(100) NOT NULL CONSTRAINT [DF_WTL_Rule_AddRateBasis] DEFAULT ('BASE_PLUS_SHIFT_EXCLUDE_BOOM'),
    [AddMultiplier] decimal(10,2) NOT NULL CONSTRAINT [DF_WTL_Rule_AddMultiplier] DEFAULT ((2.00)),
    [DeductBasis] varchar(100) NOT NULL CONSTRAINT [DF_WTL_Rule_DeductBasis] DEFAULT ('FULL_SELECTED_PRICED_SLICE'),
    [SuppressComponentsOnTokenError] bit NOT NULL CONSTRAINT [DF_WTL_Rule_SuppressComponentsOnTokenError] DEFAULT ((1)),
    [IsEnabled] bit NOT NULL CONSTRAINT [DF_WTL_Rule_IsEnabled] DEFAULT ((1)),
    [Notes] varchar(1000) NULL,
    [CreatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_WTL_Rule_CreatedAtUTC] DEFAULT (sysutcdatetime()),
    [ModifiedAtUTC] datetime2(0) NULL
);

ALTER TABLE [cfg].[WTL_Rule] ADD CONSTRAINT [PK_WTL_Rule] PRIMARY KEY CLUSTERED ([WTL_RuleID]);
ALTER TABLE [cfg].[WTL_Rule] ADD CONSTRAINT [CK_WTL_Rule_EffectiveDates] CHECK ([EffectiveEndDate] IS NULL OR [EffectiveEndDate]>=[EffectiveStartDate]);
ALTER TABLE [cfg].[WTL_Rule] ADD CONSTRAINT [CK_WTL_Rule_MealPeriodHours] CHECK ([MealPeriodHours]=(0.50));
ALTER TABLE [cfg].[WTL_Rule] ADD CONSTRAINT [CK_WTL_Rule_GroupLookbackDays] CHECK ([GroupLookbackDays]>=(0) AND [GroupLookbackDays]<=(14));
ALTER TABLE [cfg].[WTL_Rule] ADD CONSTRAINT [CK_WTL_Rule_GroupLookaheadDays] CHECK ([GroupLookaheadDays]>=(0) AND [GroupLookaheadDays]<=(14));
ALTER TABLE [cfg].[WTL_Rule] ADD CONSTRAINT [CK_WTL_Rule_StitchGapMinutes] CHECK ([StitchGapMinutes]>=(0) AND [StitchGapMinutes]<=(1440));
ALTER TABLE [cfg].[WTL_Rule] ADD CONSTRAINT [CK_WTL_Rule_AddMultiplier] CHECK ([AddMultiplier]>=(0));
