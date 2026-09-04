CREATE   VIEW [api].[v_FMS_ACTIVITIES]
AS
SELECT [ActivityCode], [Description], [PrevMaint], [ActionList], [MaintEvery], [TimePeriod], [MaintEvery2], [TimePeriod2], [ActivityType], [Status], [CertificationType], [StandardTime], [Category1], [Category2], [Category3], [AcctIntCode], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_ACTIVITIES], [Price], [UnitSales], [ItemTaxCode], [DontPromptExpCert], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_ACTIVITIES_Raw];
