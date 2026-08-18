CREATE TABLE [app].[PayrollNote_EmployeePayPeriod] (
    [NoteID] bigint IDENTITY(1,1) NOT NULL,
    [PayPeriodID] int NOT NULL,
    [EmpID] varchar(50) NOT NULL,
    [NoteText] nvarchar(max) NOT NULL,
    [CreatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_app_PayrollNote_EPP_CreatedAtUTC] DEFAULT (sysutcdatetime()),
    [CreatedBy] sysname NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_app_PayrollNote_EPP_IsDeleted] DEFAULT ((0)),
    [DeletedAtUTC] datetime2(6) NULL,
    [DeletedBy] sysname NULL
);

ALTER TABLE [app].[PayrollNote_EmployeePayPeriod] ADD CONSTRAINT [PK_app_PayrollNote_EPP] PRIMARY KEY CLUSTERED ([NoteID]);
CREATE NONCLUSTERED INDEX [IX_app_PayrollNote_EPP] ON [app].[PayrollNote_EmployeePayPeriod] ([PayPeriodID], [EmpID], [CreatedAtUTC] DESC);
ALTER TABLE [app].[PayrollNote_EmployeePayPeriod] ADD CONSTRAINT [FK_app_PayrollNote_EPP_PayPeriod] FOREIGN KEY ([PayPeriodID]) REFERENCES [app].[PayPeriod] ([PayPeriodID]);
