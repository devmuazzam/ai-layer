-- TCG_RawFMS.stg.FMS_SCHEDULE_TYPES_Raw  rows=25  columns=14
CREATE TABLE [stg].[FMS_SCHEDULE_TYPES_Raw] (
    [UnitSchedCode] varchar(5) NOT NULL,
    [Description] varchar(30) NULL,
    [Status] bit NOT NULL,
    [TiedTo] varchar(5) NULL,
    [Schedules] bit NOT NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime NULL,
    [trgFMS_SCHEDULE_TYPES] bit NULL,
    [SageEquipType] varchar(10) NULL,
    [UnitOrComponent] char(1) NOT NULL,
    [_SourceExtractedAtUTC] datetime NOT NULL,
    [_LoadedAtUTC] datetime NOT NULL
);
