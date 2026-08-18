CREATE TABLE [fms].[Labor_PreProcessed] (
    [PreProcessID] int IDENTITY(1,1) NOT NULL,
    [Original_LaborID] int NULL,
    [EmpID] varchar(50) NULL,
    [JobCode] varchar(50) NULL,
    [Pricing_Date] date NULL,
    [Actual_WorkDate] date NULL,
    [Is_Gap_Row] bit NULL CONSTRAINT [DF_fms_Labor_PreProcessed_Is_Gap_Row] DEFAULT ((0)),
    [Pay_Start] datetime NULL,
    [Pay_End] datetime NULL,
    [Total_Hrs] decimal(10,2) NULL,
    [CraftCode] varchar(50) NULL,
    [UnionCode] varchar(50) NULL
);

ALTER TABLE [fms].[Labor_PreProcessed] ADD CONSTRAINT [PK_fms_Labor_PreProcessed] PRIMARY KEY CLUSTERED ([PreProcessID]);
CREATE NONCLUSTERED INDEX [IX_LaborPre_Emp_Start] ON [fms].[Labor_PreProcessed] ([EmpID], [Pay_Start]) INCLUDE ([Pay_End], [Pricing_Date], [Actual_WorkDate], [Is_Gap_Row], [Total_Hrs], [JobCode], [CraftCode], [UnionCode], [Original_LaborID]);
CREATE NONCLUSTERED INDEX [IX_LaborPre_Pricing] ON [fms].[Labor_PreProcessed] ([Pricing_Date], [EmpID], [Pay_Start]) INCLUDE ([Pay_End], [Is_Gap_Row], [Total_Hrs], [JobCode]);
CREATE NONCLUSTERED INDEX [IX_LaborPre_OriginalLaborID] ON [fms].[Labor_PreProcessed] ([Original_LaborID]) INCLUDE ([Pay_Start], [Pay_End], [Pricing_Date], [Actual_WorkDate], [EmpID], [JobCode], [Total_Hrs], [CraftCode], [UnionCode]);
