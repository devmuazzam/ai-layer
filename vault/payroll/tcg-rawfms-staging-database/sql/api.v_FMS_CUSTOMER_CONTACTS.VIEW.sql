CREATE   VIEW [api].[v_FMS_CUSTOMER_CONTACTS]
AS
SELECT [CustContactID], [CustCode], [GroupNumb], [ContactName], [Position], [SpersonCode], [Email], [Phone], [Fax], [Mobile], [Pager], [Nextel], [HomePhone], [ContactAddress], [ContactCity], [StateProv], [OtherInfo], [DLReg], [Status], [ContactType], [AddressSameAsCust], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AccountingID], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_CUSTOMER_CONTACTS_Raw];
