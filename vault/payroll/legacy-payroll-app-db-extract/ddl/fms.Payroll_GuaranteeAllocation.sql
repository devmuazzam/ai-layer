CREATE TABLE [fms].[Payroll_GuaranteeAllocation] (
    [GuaranteeAllocationID] bigint IDENTITY(1,1) NOT NULL,
    [GuaranteeGroupID] bigint NOT NULL,
    [RunId] int NULL,
    [LaborPayrollID] int NOT NULL,
    [AllocatedDate] date NULL,
    [AllocatedGapHours] decimal(10,2) NOT NULL,
    [AllocatedGapPay] decimal(12,2) NOT NULL,
    [AllocationMethod] varchar(60) NOT NULL,
    [RateBaseUsed] decimal(12,4) NULL,
    [RateShiftUsed] decimal(12,4) NULL,
    [RateBoomUsed] decimal(12,4) NULL,
    [MultiplierUsed] decimal(10,2) NOT NULL,
    [Explanation] nvarchar(1000) NULL,
    [CalculatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_Payroll_GuaranteeAllocation_CalculatedAtUTC] DEFAULT (sysutcdatetime())
);

ALTER TABLE [fms].[Payroll_GuaranteeAllocation] ADD CONSTRAINT [PK_Payroll_GuaranteeAllocation] PRIMARY KEY CLUSTERED ([GuaranteeAllocationID]);
CREATE NONCLUSTERED INDEX [IX_Payroll_GuaranteeAllocation_LPID] ON [fms].[Payroll_GuaranteeAllocation] ([LaborPayrollID], [GuaranteeGroupID]);
ALTER TABLE [fms].[Payroll_GuaranteeAllocation] ADD CONSTRAINT [FK_Payroll_GuaranteeAllocation_Group] FOREIGN KEY ([GuaranteeGroupID]) REFERENCES [fms].[Payroll_GuaranteeGroup] ([GuaranteeGroupID]);
