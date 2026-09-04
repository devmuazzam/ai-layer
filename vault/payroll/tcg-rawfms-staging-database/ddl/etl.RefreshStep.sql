-- TCG_RawFMS.etl.RefreshStep  rows=40  columns=4
CREATE TABLE [etl].[RefreshStep] (
    [StepOrder] int NOT NULL,
    [ProcName] sysname NOT NULL,
    [IsEnabled] bit NOT NULL DEFAULT ((1)),
    [Notes] nvarchar(2000) NULL
);
-- PRIMARY KEY PK_etl_RefreshStep CLUSTERED (StepOrder)
