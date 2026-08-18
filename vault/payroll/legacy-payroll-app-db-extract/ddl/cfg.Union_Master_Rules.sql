CREATE TABLE [cfg].[Union_Master_Rules] (
    [RuleID] int IDENTITY(1,1) NOT NULL,
    [UnionCode] varchar(10) NOT NULL,
    [Description] varchar(100) NOT NULL,
    [EffectiveDate] date NOT NULL,
    [ExpirationDate] date NULL,
    [Standard_Start_Time] time(0) NOT NULL CONSTRAINT [DF_cfg_Union_Master_Rules_Standard_Start_Time] DEFAULT ('06:00:00'),
    [Standard_End_Time] time(0) NOT NULL CONSTRAINT [DF_cfg_Union_Master_Rules_Standard_End_Time] DEFAULT ('17:00:00'),
    [Standard_Hours_Daily] decimal(4,1) NOT NULL CONSTRAINT [DF_cfg_Union_Master_Rules_Standard_Hours_Daily] DEFAULT ((8.0)),
    [DoubleTime_Threshold_Daily] decimal(4,1) NOT NULL CONSTRAINT [DF_cfg_Union_Master_Rules_DoubleTime_Threshold_Daily] DEFAULT ((12.0)),
    [OT_Multiplier] decimal(4,2) NOT NULL CONSTRAINT [DF_cfg_Union_Master_Rules_OT_Multiplier] DEFAULT ((1.50)),
    [DT_Multiplier] decimal(4,2) NOT NULL CONSTRAINT [DF_cfg_Union_Master_Rules_DT_Multiplier] DEFAULT ((2.00)),
    [Saturday_Multiplier] decimal(4,2) NOT NULL CONSTRAINT [DF_cfg_Union_Master_Rules_Saturday_Multiplier] DEFAULT ((1.50)),
    [Sunday_Multiplier] decimal(4,2) NOT NULL CONSTRAINT [DF_cfg_Union_Master_Rules_Sunday_Multiplier] DEFAULT ((2.00)),
    [Holiday_Multiplier] decimal(4,2) NOT NULL CONSTRAINT [DF_cfg_Union_Master_Rules_Holiday_Multiplier] DEFAULT ((3.00)),
    [_CreatedDate] datetime2(7) NULL CONSTRAINT [DF_cfg_Union_Master_Rules__CreatedDate] DEFAULT (sysutcdatetime())
);

ALTER TABLE [cfg].[Union_Master_Rules] ADD CONSTRAINT [PK_cfg_Union_Master_Rules] PRIMARY KEY CLUSTERED ([RuleID]);
