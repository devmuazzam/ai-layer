CREATE TABLE [test].[Case_TimeSourceConsistency] (
    [CaseID] int IDENTITY(1,1) NOT NULL,
    [CaseCode] varchar(80) NOT NULL,
    [LaborPayrollID] int NOT NULL,
    [ExpectedSource] varchar(40) NOT NULL CONSTRAINT [DF_Case_TimeSourceConsistency_Source] DEFAULT ('LaborPayrollTimeline'),
    [Expected_Labor_Hrs] decimal(10,2) NOT NULL,
    [Expected_Ticket_Hrs] decimal(10,2) NULL,
    [Expected_Act_Total_Hrs] decimal(10,2) NOT NULL,
    [Notes] nvarchar(1000) NULL,
    [IsActive] bit NOT NULL CONSTRAINT [DF_Case_TimeSourceConsistency_IsActive] DEFAULT ((1)),
    [CreatedAtUTC] datetime2(7) NOT NULL CONSTRAINT [DF_Case_TimeSourceConsistency_CreatedAtUTC] DEFAULT (sysutcdatetime()),
    [UpdatedAtUTC] datetime2(7) NULL
);

ALTER TABLE [test].[Case_TimeSourceConsistency] ADD CONSTRAINT [PK_Case_TimeSourceConsistency] PRIMARY KEY CLUSTERED ([CaseID]);
ALTER TABLE [test].[Case_TimeSourceConsistency] ADD CONSTRAINT [UX_Case_TimeSourceConsistency_LPID] UNIQUE ([LaborPayrollID]);
ALTER TABLE [test].[Case_TimeSourceConsistency] ADD CONSTRAINT [UX_Case_TimeSourceConsistency_CaseCode] UNIQUE ([CaseCode]);
