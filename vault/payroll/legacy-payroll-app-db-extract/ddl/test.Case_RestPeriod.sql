CREATE TABLE [test].[Case_RestPeriod] (
    [CaseID] int IDENTITY(1,1) NOT NULL,
    [EmpID] varchar(20) NULL,
    [Prev_LaborPayrollID] int NOT NULL,
    [Curr_LaborPayrollID] int NOT NULL,
    [Expected_GapMinutes] int NULL,
    [Notes] nvarchar(400) NULL,
    [CreatedAtUTC] datetime2(7) NOT NULL CONSTRAINT [DF_Case_RestPeriod_CreatedAtUTC] DEFAULT (sysutcdatetime())
);

ALTER TABLE [test].[Case_RestPeriod] ADD CONSTRAINT [PK_Case_RestPeriod] PRIMARY KEY CLUSTERED ([CaseID]);
CREATE UNIQUE NONCLUSTERED INDEX [UX_Case_RestPeriod_Pair] ON [test].[Case_RestPeriod] ([Prev_LaborPayrollID], [Curr_LaborPayrollID]);
