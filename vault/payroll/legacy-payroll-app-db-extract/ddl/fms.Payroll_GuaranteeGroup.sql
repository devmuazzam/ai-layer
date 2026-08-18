CREATE TABLE [fms].[Payroll_GuaranteeGroup] (
    [GuaranteeGroupID] bigint IDENTITY(1,1) NOT NULL,
    [RunId] int NULL,
    [GroupKey] varchar(220) NOT NULL,
    [RuleCode] varchar(40) NOT NULL,
    [RuleName] varchar(120) NOT NULL,
    [ScopeBasis] varchar(30) NOT NULL,
    [GroupScope] varchar(40) NOT NULL,
    [EmpID] varchar(50) NULL,
    [Employee_Name] varchar(200) NULL,
    [ShiftAnchorDate] date NULL,
    [CalendarDate] date NULL,
    [ActualQualifyingHours] decimal(10,2) NOT NULL,
    [MinimumHours] decimal(10,2) NOT NULL,
    [GapHours] decimal(10,2) NOT NULL,
    [PayComponent] varchar(40) NOT NULL,
    [MultiplierUsed] decimal(10,2) NOT NULL,
    [TriggeredFlag] bit NOT NULL,
    [SatisfiedFlag] bit NOT NULL,
    [WorkDateFrom] date NULL,
    [WorkDateTo] date NULL,
    [CalculatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_Payroll_GuaranteeGroup_CalculatedAtUTC] DEFAULT (sysutcdatetime())
);

ALTER TABLE [fms].[Payroll_GuaranteeGroup] ADD CONSTRAINT [PK_Payroll_GuaranteeGroup] PRIMARY KEY CLUSTERED ([GuaranteeGroupID]);
CREATE NONCLUSTERED INDEX [IX_Payroll_GuaranteeGroup_RuleDate] ON [fms].[Payroll_GuaranteeGroup] ([RuleCode], [ShiftAnchorDate], [CalendarDate], [EmpID]);
CREATE NONCLUSTERED INDEX [IX_Payroll_GuaranteeGroup_GroupKey] ON [fms].[Payroll_GuaranteeGroup] ([GroupKey], [CalculatedAtUTC]);
