CREATE TABLE [app].[PayrollNote_EmployeeDay] (
    [NoteID] bigint IDENTITY(1,1) NOT NULL,
    [PayPeriodID] int NOT NULL,
    [EmpID] varchar(50) NOT NULL,
    [WorkDate] date NOT NULL,
    [NoteText] nvarchar(max) NOT NULL,
    [CreatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_app_PayrollNote_ED_CreatedAtUTC] DEFAULT (sysutcdatetime()),
    [CreatedBy] sysname NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_app_PayrollNote_ED_IsDeleted] DEFAULT ((0)),
    [DeletedAtUTC] datetime2(6) NULL,
    [DeletedBy] sysname NULL
);

ALTER TABLE [app].[PayrollNote_EmployeeDay] ADD CONSTRAINT [PK_app_PayrollNote_ED] PRIMARY KEY CLUSTERED ([NoteID]);
CREATE NONCLUSTERED INDEX [IX_app_PayrollNote_ED] ON [app].[PayrollNote_EmployeeDay] ([PayPeriodID], [EmpID], [WorkDate], [CreatedAtUTC] DESC);
ALTER TABLE [app].[PayrollNote_EmployeeDay] ADD CONSTRAINT [FK_app_PayrollNote_ED_PayPeriod] FOREIGN KEY ([PayPeriodID]) REFERENCES [app].[PayPeriod] ([PayPeriodID]);
