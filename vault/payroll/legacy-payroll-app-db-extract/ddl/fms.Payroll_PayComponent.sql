CREATE TABLE [fms].[Payroll_PayComponent] (
    [PayComponentID] bigint IDENTITY(1,1) NOT NULL,
    [RunId] int NULL,
    [CalcID] bigint NULL,
    [LaborPayrollID] int NOT NULL,
    [WorkDate] date NULL,
    [JobTicketID] int NULL,
    [JobCode] varchar(50) NULL,
    [EmpID] varchar(50) NULL,
    [Employee_Name] varchar(200) NULL,
    [ComponentCode] varchar(60) NOT NULL,
    [ComponentGroup] varchar(60) NOT NULL,
    [ComponentLabel] varchar(160) NOT NULL,
    [SourceSchema] varchar(50) NULL,
    [SourceTable] varchar(100) NULL,
    [SourceID] bigint NULL,
    [SourceRuleCode] varchar(60) NULL,
    [SourceRuleName] varchar(160) NULL,
    [ComponentHours] decimal(10,2) NULL,
    [Hrs_ST] decimal(10,2) NULL,
    [Hrs_OT] decimal(10,2) NULL,
    [Hrs_DT] decimal(10,2) NULL,
    [RateBaseUsed] decimal(12,4) NULL,
    [RateShiftUsed] decimal(12,4) NULL,
    [RateBoomUsed] decimal(12,4) NULL,
    [MultiplierUsed] decimal(10,2) NULL,
    [ComponentAmount] decimal(19,4) NOT NULL,
    [IncludedInFinalGross] bit NOT NULL,
    [IncludedInPayableGross] bit NOT NULL,
    [DisplaySort] int NOT NULL,
    [Explanation] nvarchar(2000) NULL,
    [CalculatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_Payroll_PayComponent_CalculatedAtUTC] DEFAULT (sysutcdatetime())
);

ALTER TABLE [fms].[Payroll_PayComponent] ADD CONSTRAINT [PK_Payroll_PayComponent] PRIMARY KEY CLUSTERED ([PayComponentID]);
CREATE NONCLUSTERED INDEX [IX_Payroll_PayComponent_LaborPayrollID] ON [fms].[Payroll_PayComponent] ([LaborPayrollID], [ComponentCode]) INCLUDE ([ComponentAmount], [IncludedInFinalGross], [IncludedInPayableGross]);
CREATE NONCLUSTERED INDEX [IX_Payroll_PayComponent_WorkDate_Emp] ON [fms].[Payroll_PayComponent] ([WorkDate], [EmpID], [LaborPayrollID]) INCLUDE ([ComponentCode], [ComponentAmount]);
