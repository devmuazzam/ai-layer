CREATE TABLE [fms].[Payroll_Calculated] (
    [CalcID] bigint IDENTITY(1,1) NOT NULL,
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
    [CalculatedAt] datetime2(7) NULL CONSTRAINT [DF_fms_Payroll_Calculated_CalculatedAt] DEFAULT (sysutcdatetime()),
    [Pay_Rest_Add] decimal(19,4) NULL,
    [Rest_IsForced] bit NULL,
    [Rest_ChainId] int NULL,
    [Rest_Gap_Hrs_FromPrevChain] decimal(9,2) NULL,
    [Rest_IsOverlap] bit NULL,
    [Rest_Premium_Hrs] decimal(9,2) NULL,
    [Rest_Policy] varchar(50) NULL
);

ALTER TABLE [fms].[Payroll_Calculated] ADD CONSTRAINT [PK_fms_Payroll_Calculated] PRIMARY KEY CLUSTERED ([CalcID]);
CREATE NONCLUSTERED INDEX [IX_Payroll_Calculated_WorkDate] ON [fms].[Payroll_Calculated] ([WorkDate]) INCLUDE ([LaborPayrollID], [JobTicketID], [EmpID], [JobCode]);
CREATE UNIQUE NONCLUSTERED INDEX [UX_Payroll_Calculated_LaborPayrollID] ON [fms].[Payroll_Calculated] ([LaborPayrollID]);
CREATE NONCLUSTERED INDEX [IX_Payroll_Calculated_WorkDate_LPID] ON [fms].[Payroll_Calculated] ([WorkDate], [LaborPayrollID]) INCLUDE ([EmpID], [Employee_Name], [JobTicketID], [JobCode], [Pay_Total_Hrs], [Final_Gross_Pay], [CalculatedAt]);
CREATE NONCLUSTERED INDEX [IX_Payroll_Calculated_LPID] ON [fms].[Payroll_Calculated] ([LaborPayrollID]) INCLUDE ([WorkDate], [EmpID], [Employee_Name], [JobTicketID], [JobCode], [Pay_Total_Hrs], [Final_Gross_Pay], [CalculatedAt]);
CREATE NONCLUSTERED INDEX [IX_Payroll_Calculated_JobTicketID] ON [fms].[Payroll_Calculated] ([JobTicketID], [WorkDate]) INCLUDE ([LaborPayrollID], [JobCode]);
CREATE NONCLUSTERED INDEX [IX_Payroll_Calculated_JobCode] ON [fms].[Payroll_Calculated] ([JobCode], [WorkDate]) INCLUDE ([LaborPayrollID], [JobTicketID]);
