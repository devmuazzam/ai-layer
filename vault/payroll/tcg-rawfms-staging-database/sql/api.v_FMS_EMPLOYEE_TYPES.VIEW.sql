CREATE   VIEW [api].[v_FMS_EMPLOYEE_TYPES]
AS
SELECT [EmpTypeID], [Description], [Status], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_EMPLOYEE_TYPES], [Type], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_EMPLOYEE_TYPES_Raw];
