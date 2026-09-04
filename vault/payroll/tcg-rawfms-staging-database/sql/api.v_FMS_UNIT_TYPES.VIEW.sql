CREATE   VIEW [api].[v_FMS_UNIT_TYPES]
AS
SELECT [UnitTypeID], [Description], [TargetMonthHrs], [UnitSchedType], [Status], [AdditionalInfo], [PeakHours], [NonPeakHours], [TransportClass], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [TrackUnit], [SortNumb], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_UNIT_TYPES_Raw];
