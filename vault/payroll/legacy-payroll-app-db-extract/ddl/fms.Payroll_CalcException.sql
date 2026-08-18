CREATE TABLE [fms].[Payroll_CalcException] (
    [CalcRunAt] datetime2(0) NOT NULL CONSTRAINT [DF_Payroll_CalcException_CalcRunAt] DEFAULT (sysdatetime()),
    [Reason] varchar(100) NOT NULL,
    [LaborPayrollID] int NOT NULL,
    [WorkDate] datetime2(0) NULL,
    [EmpID] int NULL,
    [Employee_Name] varchar(200) NULL,
    [JobTicketID] int NULL,
    [JobCode] varchar(50) NULL,
    [Shift_Start] datetime2(0) NULL,
    [Shift_End] datetime2(0) NULL,
    [EmpID_Raw] varchar(15) NULL,
    [RunId] int NULL
);

ALTER TABLE [fms].[Payroll_CalcException] ADD CONSTRAINT [PK_Payroll_CalcException] PRIMARY KEY CLUSTERED ([CalcRunAt], [LaborPayrollID]);
CREATE NONCLUSTERED INDEX [IX_Payroll_CalcException_WorkDate] ON [fms].[Payroll_CalcException] ([WorkDate]);
CREATE NONCLUSTERED INDEX [IX_Payroll_CalcException_EmpID] ON [fms].[Payroll_CalcException] ([EmpID]);
CREATE NONCLUSTERED INDEX [IX_Payroll_CalcException_RunId] ON [fms].[Payroll_CalcException] ([RunId], [CalcRunAt]) INCLUDE ([Reason], [LaborPayrollID], [WorkDate], [EmpID], [EmpID_Raw], [Employee_Name], [JobTicketID], [JobCode], [Shift_Start], [Shift_End]);
