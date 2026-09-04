-- TCG_RawFMS.stg.FMS_UNIT_TYPES_Raw  rows=71  columns=17
CREATE TABLE [stg].[FMS_UNIT_TYPES_Raw] (
    [UnitTypeID] int NOT NULL,
    [Description] varchar(60) NULL,
    [TargetMonthHrs] int NULL,
    [UnitSchedType] varchar(5) NULL,
    [Status] bit NOT NULL,
    [AdditionalInfo] varchar(max) NULL,
    [PeakHours] int NULL,
    [NonPeakHours] int NULL,
    [TransportClass] tinyint NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [TrackUnit] bit NOT NULL,
    [SortNumb] bigint NULL,
    [_SourceExtractedAtUTC] datetime2(7) NULL,
    [_LoadedAtUTC] datetime2(7) NULL DEFAULT (sysutcdatetime())
);
