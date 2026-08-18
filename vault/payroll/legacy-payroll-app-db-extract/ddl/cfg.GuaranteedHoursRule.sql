CREATE TABLE [cfg].[GuaranteedHoursRule] (
    [GuaranteedHoursRuleID] int IDENTITY(1,1) NOT NULL,
    [RuleCode] varchar(40) NOT NULL,
    [RuleName] varchar(120) NOT NULL,
    [ScopeBasis] varchar(30) NOT NULL,
    [GroupScope] varchar(40) NOT NULL,
    [MinimumHours] decimal(10,2) NOT NULL,
    [PayComponent] varchar(40) NOT NULL,
    [DefaultMultiplier] decimal(10,2) NULL,
    [BoomNoModifierTreatment] varchar(30) NULL,
    [IsEnabled] bit NOT NULL CONSTRAINT [DF_GuaranteedHoursRule_IsEnabled] DEFAULT ((1)),
    [CreatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_GuaranteedHoursRule_CreatedAtUTC] DEFAULT (sysutcdatetime()),
    [UpdatedAtUTC] datetime2(0) NULL
);

ALTER TABLE [cfg].[GuaranteedHoursRule] ADD CONSTRAINT [PK_GuaranteedHoursRule] PRIMARY KEY CLUSTERED ([GuaranteedHoursRuleID]);
ALTER TABLE [cfg].[GuaranteedHoursRule] ADD CONSTRAINT [UQ_GuaranteedHoursRule_RuleCode] UNIQUE ([RuleCode]);
