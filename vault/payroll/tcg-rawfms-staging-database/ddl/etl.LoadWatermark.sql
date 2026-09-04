-- TCG_RawFMS.etl.LoadWatermark  rows=6  columns=5
CREATE TABLE [etl].[LoadWatermark] (
    [TableName] sysname NOT NULL,
    [WatermarkColumn] sysname NOT NULL,
    [LastWatermarkUTC] datetime2(0) NULL,
    [LastRunUTC] datetime2(0) NULL,
    [Notes] nvarchar(4000) NULL
);
-- PRIMARY KEY PK_LoadWatermark CLUSTERED (TableName)
-- UNIQUE INDEX UX_LoadWatermark_TableName NONCLUSTERED (TableName)
