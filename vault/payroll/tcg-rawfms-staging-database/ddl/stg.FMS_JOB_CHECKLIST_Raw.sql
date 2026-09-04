-- TCG_RawFMS.stg.FMS_JOB_CHECKLIST_Raw  rows=55438  columns=9
CREATE TABLE [stg].[FMS_JOB_CHECKLIST_Raw] (
    [JobCode] varchar(15) NOT NULL,
    [CheckListID] int NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime2(7) NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime2(7) NULL,
    [trgFMS_JOB_CHECKLIST] bit NULL,
    [_SourceExtractedAtUTC] datetime2(0) NOT NULL,
    [_LoadedAtUTC] datetime2(0) NOT NULL
);
-- PRIMARY KEY PK_FMS_JOB_CHECKLIST_Raw CLUSTERED (JobCode,CheckListID)
