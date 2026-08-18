CREATE TABLE [app].[PayrollSnapshot_Detail] (
    [SnapshotID] bigint NOT NULL,
    [CalcID] bigint NOT NULL,
    [LaborPayrollID] int NOT NULL,
    [JobTicketID] int NULL,
    [JobCode] varchar(50) NULL,
    [EmpID] varchar(50) NULL,
    [Employee_Name] varchar(100) NULL,
    [TicketDate] datetime NULL,
    [WorkDate] datetime NULL,
    [Act_Total_Hrs] decimal(10,2) NULL,
    [Act_Boom_Hrs] decimal(10,2) NULL,
    [Gap_Hrs_Total] decimal(10,2) NULL,
    [Gap_Hrs_Boom] decimal(10,2) NULL,
    [Pay_Total_Hrs] decimal(10,2) NULL,
    [Hrs_ST] decimal(10,2) NULL,
    [Hrs_OT] decimal(10,2) NULL,
    [Hrs_DT] decimal(10,2) NULL,
    [Pay_Actual_Gross] decimal(12,2) NULL,
    [Pay_Gap_Add] decimal(12,2) NULL,
    [Final_Gross_Pay] decimal(12,2) NULL,
    [Audit_Min_Rule] decimal(4,1) NULL,
    [Audit_Gap_Mult] decimal(4,2) NULL,
    [CalculatedAt] datetime2(7) NULL,
    [Pay_Rest_Add] decimal(19,4) NULL,
    [Rest_IsForced] bit NULL,
    [Rest_ChainId] int NULL,
    [Rest_Gap_Hrs_FromPrevChain] decimal(9,2) NULL,
    [Rest_IsOverlap] bit NULL,
    [Rest_Premium_Hrs] decimal(9,2) NULL,
    [Rest_Policy] varchar(50) NULL
);

CREATE NONCLUSTERED INDEX [IX_app_PayrollSnapshot_Detail_Snapshot] ON [app].[PayrollSnapshot_Detail] ([SnapshotID]);
CREATE NONCLUSTERED INDEX [IX_app_PayrollSnapshot_Detail_PayPeriodEmp] ON [app].[PayrollSnapshot_Detail] ([SnapshotID], [EmpID], [WorkDate]);
CREATE NONCLUSTERED INDEX [IX_app_PayrollSnapshot_Detail_LPID] ON [app].[PayrollSnapshot_Detail] ([LaborPayrollID]);
ALTER TABLE [app].[PayrollSnapshot_Detail] ADD CONSTRAINT [FK_app_PayrollSnapshot_Detail_Snapshot] FOREIGN KEY ([SnapshotID]) REFERENCES [app].[PayrollSnapshot] ([SnapshotID]);
