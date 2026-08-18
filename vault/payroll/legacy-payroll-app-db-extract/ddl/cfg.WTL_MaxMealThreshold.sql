CREATE TABLE [cfg].[WTL_MaxMealThreshold] (
    [WTL_MaxMealThresholdID] int IDENTITY(1,1) NOT NULL,
    [UnionCode] varchar(20) NOT NULL,
    [EffectiveStartDate] date NOT NULL CONSTRAINT [DF_WTL_MaxMealThreshold_EffectiveStartDate] DEFAULT ('2025-01-01'),
    [EffectiveEndDate] date NULL,
    [MinSpanHours] decimal(10,2) NOT NULL,
    [MaxSpanHours] decimal(10,2) NOT NULL,
    [MaxMealPeriods] int NOT NULL,
    [IsEnabled] bit NOT NULL CONSTRAINT [DF_WTL_MaxMealThreshold_IsEnabled] DEFAULT ((1)),
    [Notes] varchar(500) NULL,
    [CreatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_WTL_MaxMealThreshold_CreatedAtUTC] DEFAULT (sysutcdatetime()),
    [ModifiedAtUTC] datetime2(0) NULL
);

ALTER TABLE [cfg].[WTL_MaxMealThreshold] ADD CONSTRAINT [PK_WTL_MaxMealThreshold] PRIMARY KEY CLUSTERED ([WTL_MaxMealThresholdID]);
ALTER TABLE [cfg].[WTL_MaxMealThreshold] ADD CONSTRAINT [CK_WTL_MaxMealThreshold_Span] CHECK ([MinSpanHours]>=(0) AND [MaxSpanHours]>=[MinSpanHours]);
ALTER TABLE [cfg].[WTL_MaxMealThreshold] ADD CONSTRAINT [CK_WTL_MaxMealThreshold_MaxMealPeriods] CHECK ([MaxMealPeriods]>=(0) AND [MaxMealPeriods]<=(4));
ALTER TABLE [cfg].[WTL_MaxMealThreshold] ADD CONSTRAINT [CK_WTL_MaxMealThreshold_EffectiveDates] CHECK ([EffectiveEndDate] IS NULL OR [EffectiveEndDate]>=[EffectiveStartDate]);
