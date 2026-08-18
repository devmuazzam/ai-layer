CREATE TABLE [cfg].[Union_Shift_Rules] (
    [ShiftRuleID] int IDENTITY(1,1) NOT NULL,
    [UnionCode] varchar(10) NOT NULL,
    [ShiftCode] int NOT NULL,
    [Description] varchar(50) NOT NULL,
    [Premium_Hourly_Add] decimal(4,2) NOT NULL CONSTRAINT [DF_cfg_Union_Shift_Rules_Premium_Hourly_Add] DEFAULT ((0.00)),
    [Is_Base_Rate_Modifier] bit NOT NULL CONSTRAINT [DF_cfg_Union_Shift_Rules_Is_Base_Rate_Modifier] DEFAULT ((1)),
    [Full_Shift_Work_Hours] decimal(4,1) NOT NULL,
    [Full_Shift_Paid_Hours] decimal(4,1) NOT NULL,
    [_CreatedDate] datetime2(7) NULL CONSTRAINT [DF_cfg_Union_Shift_Rules__CreatedDate] DEFAULT (sysutcdatetime())
);

ALTER TABLE [cfg].[Union_Shift_Rules] ADD CONSTRAINT [PK_cfg_Union_Shift_Rules] PRIMARY KEY CLUSTERED ([ShiftRuleID]);
