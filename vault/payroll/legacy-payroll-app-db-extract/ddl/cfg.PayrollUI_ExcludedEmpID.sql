CREATE TABLE [cfg].[PayrollUI_ExcludedEmpID] (
    [EmpID] varchar(15) NOT NULL,
    [Reason] varchar(200) NULL,
    [IsEnabled] bit NOT NULL CONSTRAINT [DF_cfg_PayrollUI_ExcludedEmpID_IsEnabled] DEFAULT ((1)),
    [UpdatedAtUTC] datetime2(0) NOT NULL CONSTRAINT [DF_cfg_PayrollUI_ExcludedEmpID_UpdatedAtUTC] DEFAULT (sysutcdatetime())
);

ALTER TABLE [cfg].[PayrollUI_ExcludedEmpID] ADD CONSTRAINT [PK_cfg_PayrollUI_ExcludedEmpID] PRIMARY KEY CLUSTERED ([EmpID]);
