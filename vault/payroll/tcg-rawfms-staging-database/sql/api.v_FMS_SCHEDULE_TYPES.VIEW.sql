CREATE   VIEW [api].[v_FMS_SCHEDULE_TYPES]
AS
SELECT [UnitSchedCode], [Description], [Status], [TiedTo], [Schedules], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_SCHEDULE_TYPES], [SageEquipType], [UnitOrComponent], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_SCHEDULE_TYPES_Raw];
