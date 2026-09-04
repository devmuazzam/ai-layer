CREATE   VIEW [api].[v_FMS_DEPARTMENTS]
AS
SELECT [DeptCode], [Name], [PONumb], [Flag], [InvoiceNumb], [JobCode], [QuoteNumb], [Branch], [Status], [GSTNo], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_DEPARTMENTS], [ExpAcct], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_DEPARTMENTS_Raw];
