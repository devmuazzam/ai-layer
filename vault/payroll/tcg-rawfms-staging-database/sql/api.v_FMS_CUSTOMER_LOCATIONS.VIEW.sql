CREATE   VIEW [api].[v_FMS_CUSTOMER_LOCATIONS]
AS
SELECT [CustLocationID], [CustCode], [LocationName], [Address1], [Address2], [City], [StateCode], [Zip], [Country], [Phone], [AltPhone], [Description], [OrderedBy], [OrdByPhone], [Fax], [ReportTo], [ReportToPhone], [Taxable], [SalesTaxCode], [Directions], [GroupNumb], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [Status], [County], [Flag], [ReportToEmail], [OrderedByEmail], [CountyCode], [OrderedByWP], [ReportToWP], [EmailInvoice], [OrderedByContactID], [ReportedToContactID], [PriceList], [PriceExpires], [MSHA], [Latitude], [Longitude], [ValidationStatus], [EntityUseCode], [CountryCode], [AddressUnknown], [GeoFenceRadius], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_CUSTOMER_LOCATIONS_Raw];
