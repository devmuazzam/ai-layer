CREATE TABLE [app].[LaborBreakOverride] (
    [LaborPayrollID] int NOT NULL,
    [Breaks_NotTaken_Count] tinyint NULL,
    [Notes] nvarchar(500) NULL,
    [UpdatedAt] datetime2(0) NOT NULL CONSTRAINT [DF_LaborBreakOverride_UpdatedAt] DEFAULT (sysutcdatetime()),
    [UpdatedBy] sysname NOT NULL CONSTRAINT [DF_LaborBreakOverride_UpdatedBy] DEFAULT (original_login())
);

ALTER TABLE [app].[LaborBreakOverride] ADD CONSTRAINT [PK_LaborBreakOverride] PRIMARY KEY CLUSTERED ([LaborPayrollID]);
ALTER TABLE [app].[LaborBreakOverride] ADD CONSTRAINT [CK_LaborBreakOverride_Count] CHECK ([Breaks_NotTaken_Count] IS NULL OR [Breaks_NotTaken_Count]>=(0) AND [Breaks_NotTaken_Count]<=(9));
