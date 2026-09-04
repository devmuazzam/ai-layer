-- TCG_RawFMS.stg.FMS_EMPLOYEE_TYPES_Raw  rows=15  columns=11
CREATE TABLE [stg].[FMS_EMPLOYEE_TYPES_Raw] (
    [EmpTypeID] int NOT NULL,
    [Description] varchar(60) NOT NULL,
    [Status] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_EMPLOYEE_TYPES] bit NULL,
    [Type] char(1) NULL,
    [_SourceExtractedAtUTC] datetime NOT NULL,
    [_LoadedAtUTC] datetime NOT NULL
);
