CREATE   VIEW [api].[v_FMS_SALES_PERSON]
AS
SELECT [SpersonCode], [LName], [FName], [MName], [Phone], [Fax], [Email], [Status], [GroupNumb], [UserID], [ConvertToJob], [ViewRestriction], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_SALES_PERSON], [SalesForceID], [Title], [EmpID], [ExpAcct], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_SALES_PERSON_Raw];
