CREATE TABLE [test].[Case_CorePayrollScenario] (
    [ScenarioID] int IDENTITY(1,1) NOT NULL,
    [ScenarioCode] varchar(80) NOT NULL,
    [ScenarioGroup] varchar(80) NOT NULL,
    [ScenarioName] varchar(160) NOT NULL,
    [LaborPayrollID] int NOT NULL,
    [PrevLaborPayrollID] int NULL,
    [EmpID] varchar(50) NULL,
    [WorkDate] date NULL,
    [JobTicketID] int NULL,
    [IsActive] bit NOT NULL CONSTRAINT [DF_Case_CorePayrollScenario_IsActive] DEFAULT ((1)),
    [IsKnownIssue] bit NOT NULL CONSTRAINT [DF_Case_CorePayrollScenario_IsKnownIssue] DEFAULT ((0)),
    [KnownIssueNote] nvarchar(1000) NULL,
    [Expected_Act_Total_Hrs] decimal(10,2) NULL,
    [Expected_Act_Boom_Hrs] decimal(10,2) NULL,
    [Expected_Gap_Hrs_Total] decimal(10,2) NULL,
    [Expected_Gap_Hrs_Boom] decimal(10,2) NULL,
    [Expected_Pay_Total_Hrs] decimal(10,2) NULL,
    [Expected_Hrs_ST] decimal(10,2) NULL,
    [Expected_Hrs_OT] decimal(10,2) NULL,
    [Expected_Hrs_DT] decimal(10,2) NULL,
    [Expected_Audit_Min_Rule] decimal(4,1) NULL,
    [Expected_Audit_Gap_Mult] decimal(4,2) NULL,
    [Expected_Rest_IsForced] bit NULL,
    [Expected_Rest_IsOverlap] bit NULL,
    [Expected_Rest_Premium_Hrs] decimal(9,2) NULL,
    [Expected_ExceptionReasonLike] varchar(200) NULL,
    [Notes] nvarchar(1000) NULL,
    [CreatedAtUTC] datetime2(7) NOT NULL CONSTRAINT [DF_Case_CorePayrollScenario_CreatedAtUTC] DEFAULT (sysutcdatetime()),
    [UpdatedAtUTC] datetime2(7) NULL
);

ALTER TABLE [test].[Case_CorePayrollScenario] ADD CONSTRAINT [PK_Case_CorePayrollScenario] PRIMARY KEY CLUSTERED ([ScenarioID]);
ALTER TABLE [test].[Case_CorePayrollScenario] ADD CONSTRAINT [UX_Case_CorePayrollScenario_LaborPayrollID] UNIQUE ([LaborPayrollID]);
ALTER TABLE [test].[Case_CorePayrollScenario] ADD CONSTRAINT [UX_Case_CorePayrollScenario_ScenarioCode] UNIQUE ([ScenarioCode]);
