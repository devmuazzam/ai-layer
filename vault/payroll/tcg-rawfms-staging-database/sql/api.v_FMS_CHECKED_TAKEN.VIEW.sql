CREATE   VIEW [api].[v_FMS_CHECKED_TAKEN]
AS
SELECT [CheckTakenID], [LastName], [FirstName], [EmpID], [Flag], [Status], [GroupNumb], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_CHECKED_TAKEN], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_CHECKED_TAKEN_Raw];
