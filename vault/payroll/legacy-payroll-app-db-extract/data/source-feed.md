---
title: Legacy Payroll App - the 40 src.* synonyms into TCG_RawFMS: base object, columns, row counts, masked samples
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
topics: [payroll, legacy-payroll-app, reference-data]
entities: [pay-component, craft-modifier]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# A4 - Source Feed (src.* synonyms)

Every `src.*` synonym, its base object in `TCG_RawFMS`, column list, row count, and up to 3 masked sample rows.
PII (names, SSN, address, phone, email, DOB, bank) masked; EmpID shown as E***NN keeping last 2 digits.

## src.FMS_ACTIVITIES_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_ACTIVITIES]`

Row count: **100**. Columns (27):

`ActivityCode String, Description String, PrevMaint Boolean, ActionList String, MaintEvery Int32, TimePeriod String, MaintEvery2 Int32, TimePeriod2 String, ActivityType String, Status Boolean, CertificationType String, StandardTime Decimal, Category1 String, Category2 String, Category3 String, AcctIntCode String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_ACTIVITIES Boolean, Price Decimal, UnitSales Boolean, ItemTaxCode String, DontPromptExpCert Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** ActivityCode=1000; Description=NEW EQUIPMENT / In-Service Inspection; PrevMaint=False; ActivityType=A; Status=True; CreatedBy=mbsi; CreatedDate=08/12/2019 14:14:14; ModifiedBy=mbsi; ModifiedDate=08/12/2019 14:14:14; trgFMS_ACTIVITIES=False; UnitSales=False; DontPromptExpCert=False; _SourceExtractedAtUTC=06/23/2026 08:00:04; _LoadedAtUTC=06/23/2026 08:00:04
- **row 2:** ActivityCode=1001; Description=PIP's / Campaign's / Service Bulletin's / Update's; PrevMaint=False; ActivityType=A; Status=True; CreatedBy=mbsi; CreatedDate=08/29/2019 13:16:42; ModifiedBy=mbsi; ModifiedDate=09/13/2019 13:19:40; trgFMS_ACTIVITIES=False; UnitSales=False; DontPromptExpCert=False; _SourceExtractedAtUTC=06/23/2026 08:00:04; _LoadedAtUTC=06/23/2026 08:00:04
- **row 3:** ActivityCode=1002; Description=Warranty - Parts and/or Labor; PrevMaint=False; ActivityType=A; Status=True; CreatedBy=mbsi; CreatedDate=09/03/2019 11:55:57; ModifiedBy=mbsi; ModifiedDate=09/03/2019 11:55:57; trgFMS_ACTIVITIES=False; UnitSales=False; DontPromptExpCert=False; _SourceExtractedAtUTC=06/23/2026 08:00:04; _LoadedAtUTC=06/23/2026 08:00:04

## src.FMS_CHECK_LIST_DETAILS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_CHECK_LIST_DETAILS]`

Row count: **7728**. Columns (21):

`CheckListDtlID Int32, CheckList String, Name String, LineNumb Int16, Type String, Description String, Status Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, UnitCode String, Sections String, SignatureRequired Boolean, SortNumb Int32, CheckListID Int32, ComponentCode String, RequireComments Boolean, DeficiencyCode String, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** CheckListDtlID=1; CheckList=Pre Trip Inspection; Name=L***; LineNumb=1; Type=C; Status=True; CreatedBy=melissam; CreatedDate=09/26/2019 15:03:17; ModifiedBy=melissam; ModifiedDate=04/14/2020 14:48:57; Sections=BLY; SignatureRequired=True; SortNumb=1; CheckListID=2; RequireComments=False; _SourceExtractedAtUTC=06/23/2026 08:00:06; _LoadedAtUTC=06/23/2026 08:00:11
- **row 2:** CheckListDtlID=2; CheckList=Pre Trip Inspection; Name=C***; LineNumb=2; Type=C; Status=True; CreatedBy=melissam; CreatedDate=09/26/2019 15:03:17; ModifiedBy=melissam; ModifiedDate=04/14/2020 14:48:57; Sections=BLY; SignatureRequired=True; SortNumb=1; CheckListID=2; RequireComments=False; _SourceExtractedAtUTC=06/23/2026 08:00:06; _LoadedAtUTC=06/23/2026 08:00:11
- **row 3:** CheckListDtlID=3; CheckList=Pre Trip Inspection; Name=S***; LineNumb=3; Type=C; Status=True; CreatedBy=melissam; CreatedDate=09/26/2019 15:03:17; ModifiedBy=melissam; ModifiedDate=04/14/2020 14:48:57; Sections=BLY; SignatureRequired=True; SortNumb=1; CheckListID=2; RequireComments=False; _SourceExtractedAtUTC=06/23/2026 08:00:06; _LoadedAtUTC=06/23/2026 08:00:11

## src.FMS_CHECK_LIST_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_CHECK_LIST]`

Row count: **630**. Columns (15):

`CheckList String, Status Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_CHECK_LIST Boolean, CheckListID Int32, UnitCode String, UnitCheckListID Int32, Sections String, EligibleToEmail Boolean, ComponentCode String, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** CheckList=Job Safety Analysis; Status=False; CreatedBy=mbsi; CreatedDate=09/25/2019 12:47:07; ModifiedBy=melissam; ModifiedDate=07/09/2020 18:28:30; trgFMS_CHECK_LIST=False; CheckListID=1; EligibleToEmail=***masked***; _SourceExtractedAtUTC=06/23/2026 08:00:05; _LoadedAtUTC=06/23/2026 08:00:05
- **row 2:** CheckList=Pre Trip Inspection; Status=False; CreatedBy=melissam; CreatedDate=09/26/2019 15:03:17; ModifiedBy=tharmeyer; ModifiedDate=06/02/2020 14:55:44; trgFMS_CHECK_LIST=False; CheckListID=2; EligibleToEmail=***masked***; _SourceExtractedAtUTC=06/23/2026 08:00:05; _LoadedAtUTC=06/23/2026 08:00:05
- **row 3:** CheckList=Crane Pre- Trip Inspection; Status=True; CreatedBy=melissam; CreatedDate=04/22/2020 08:53:10; ModifiedBy=melissam; ModifiedDate=07/10/2020 13:40:50; trgFMS_CHECK_LIST=False; CheckListID=5; EligibleToEmail=***masked***; _SourceExtractedAtUTC=06/23/2026 08:00:05; _LoadedAtUTC=06/23/2026 08:00:05

## src.FMS_CHECKED_TAKEN_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_CHECKED_TAKEN]`

Row count: **31**. Columns (14):

`CheckTakenID Int32, LastName String, FirstName String, EmpID String, Flag String, Status Boolean, GroupNumb String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_CHECKED_TAKEN Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** CheckTakenID=1; LastName=N***; FirstName=M***; Flag=B; Status=False; GroupNumb=00; CreatedBy=mbsi; CreatedDate=09/05/2019 14:18:16; ModifiedBy=joes; ModifiedDate=05/17/2022 16:00:22; trgFMS_CHECKED_TAKEN=False; _SourceExtractedAtUTC=06/23/2026 08:00:11; _LoadedAtUTC=06/23/2026 08:00:11
- **row 2:** CheckTakenID=2; LastName=C***; Flag=C; Status=True; GroupNumb=00; CreatedBy=melissam; CreatedDate=09/13/2019 21:13:35; ModifiedBy=tharmeyer; ModifiedDate=04/28/2020 15:23:59; trgFMS_CHECKED_TAKEN=False; _SourceExtractedAtUTC=06/23/2026 08:00:11; _LoadedAtUTC=06/23/2026 08:00:11
- **row 3:** CheckTakenID=3; LastName=A***; FirstName=L***; Flag=B; Status=True; GroupNumb=00; CreatedBy=melissam; CreatedDate=09/13/2019 21:13:35; ModifiedBy=melissam; ModifiedDate=09/13/2019 21:13:35; trgFMS_CHECKED_TAKEN=False; _SourceExtractedAtUTC=06/23/2026 08:00:11; _LoadedAtUTC=06/23/2026 08:00:11

## src.FMS_CLASSIFICATIONS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_CLASSIFICATIONS]`

Row count: **24**. Columns (12):

`ClassCode String, Description String, Labor String, Status Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_CLASSIFICATIONS Boolean, UseCertifiedPayroll Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** ClassCode=ACCOUNTING; Description=Accounting; Labor=L; Status=True; CreatedBy=corrinab; CreatedDate=01/25/2022 18:36:15; ModifiedBy=corrinab; ModifiedDate=01/25/2022 18:36:15; trgFMS_CLASSIFICATIONS=False; UseCertifiedPayroll=True; _SourceExtractedAtUTC=06/23/2026 08:00:12; _LoadedAtUTC=06/23/2026 08:00:12
- **row 2:** ClassCode=ADMIN PTO; Description=Admin PTO; Labor=L; Status=True; CreatedBy=corrinab; CreatedDate=01/25/2022 18:39:48; ModifiedBy=corrinab; ModifiedDate=08/17/2023 12:43:21; trgFMS_CLASSIFICATIONS=False; UseCertifiedPayroll=True; _SourceExtractedAtUTC=06/23/2026 08:00:12; _LoadedAtUTC=06/23/2026 08:00:12
- **row 3:** ClassCode=ANNIVERSAR; Description=L12 Anniversary; Labor=L; Status=True; CreatedBy=corrinab; CreatedDate=01/15/2026 19:52:08; ModifiedBy=corrinab; ModifiedDate=01/15/2026 19:52:08; trgFMS_CLASSIFICATIONS=False; UseCertifiedPayroll=False; _SourceExtractedAtUTC=06/23/2026 08:00:12; _LoadedAtUTC=06/23/2026 08:00:12

## src.FMS_CRAFT_MODIFIER_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_CRAFT_MODIFIER]`

Row count: **52**. Columns (10):

`CraftModifierCode String, Description String, Status Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_CRAFT_MODIFIER Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** CraftModifierCode=OI-BP-01; Description=080-100Ft-Oiler; Status=True; CreatedBy=melissam; CreatedDate=04/10/2020 01:10:46; ModifiedBy=bpetros; ModifiedDate=01/20/2026 13:37:22; trgFMS_CRAFT_MODIFIER=False; _SourceExtractedAtUTC=06/23/2026 08:00:13; _LoadedAtUTC=06/23/2026 08:00:13
- **row 2:** CraftModifierCode=OI-BP-02; Description=101-120Ft-Oiler; Status=True; CreatedBy=melissam; CreatedDate=04/10/2020 01:10:46; ModifiedBy=bpetros; ModifiedDate=01/20/2026 13:37:22; trgFMS_CRAFT_MODIFIER=False; _SourceExtractedAtUTC=06/23/2026 08:00:13; _LoadedAtUTC=06/23/2026 08:00:13
- **row 3:** CraftModifierCode=OI-BP-03; Description=121-140Ft-Oiler; Status=True; CreatedBy=melissam; CreatedDate=04/10/2020 01:10:46; ModifiedBy=bpetros; ModifiedDate=01/20/2026 13:37:22; trgFMS_CRAFT_MODIFIER=False; _SourceExtractedAtUTC=06/23/2026 08:00:13; _LoadedAtUTC=06/23/2026 08:00:13

## src.FMS_CRAFTS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_CRAFTS]`

Row count: **74**. Columns (23):

`CraftCode String, Description String, PayType String, PromptText String, BurdenYN Boolean, WCYN Boolean, UnionYN Boolean, AcctPayType String, Billable Boolean, Status Boolean, GLAcctCode String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_CRAFTS Boolean, AcctIntCode String, PayTypeOrder Byte, Earnings Boolean, EarningsType String, ExemptApprentice Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** CraftCode=ADMIN-A; Description=ADMIN; PayType=R; PromptText=Hours; BurdenYN=True; WCYN=True; UnionYN=True; AcctPayType=HOURLY; Billable=False; Status=True; CreatedBy=corrinab; CreatedDate=01/20/2022 11:38:15; ModifiedBy=bpetros; ModifiedDate=06/06/2026 06:42:53; trgFMS_CRAFTS=False; PayTypeOrder=1; Earnings=False; ExemptApprentice=False; _SourceExtractedAtUTC=06/23/2026 08:00:13; _LoadedAtUTC=06/23/2026 08:00:13
- **row 2:** CraftCode=ADMIN-B; Description=ADMIN; PayType=O; PromptText=Hours; BurdenYN=True; WCYN=True; UnionYN=True; AcctPayType=OVERTIME; Billable=False; Status=True; CreatedBy=corrinab; CreatedDate=01/20/2022 11:38:15; ModifiedBy=bpetros; ModifiedDate=06/06/2026 06:42:53; trgFMS_CRAFTS=False; PayTypeOrder=2; Earnings=False; ExemptApprentice=False; _SourceExtractedAtUTC=06/23/2026 08:00:13; _LoadedAtUTC=06/23/2026 08:00:13
- **row 3:** CraftCode=ADMIN-C; Description=ADMIN; PayType=D; PromptText=Hours; BurdenYN=True; WCYN=True; UnionYN=True; AcctPayType=DOUBLE TIME; Billable=False; Status=True; CreatedBy=corrinab; CreatedDate=01/20/2022 11:38:15; ModifiedBy=bpetros; ModifiedDate=06/06/2026 06:49:12; trgFMS_CRAFTS=False; PayTypeOrder=3; Earnings=False; ExemptApprentice=False; _SourceExtractedAtUTC=06/23/2026 08:00:13; _LoadedAtUTC=06/23/2026 08:00:13

## src.FMS_CUSTOMER_CONTACTS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_CUSTOMER_CONTACTS]`

Row count: **9546**. Columns (28):

`CustContactID Int32, CustCode String, GroupNumb String, ContactName String, Position String, SpersonCode String, Email String, Phone String, Fax String, Mobile String, Pager String, Nextel String, HomePhone String, ContactAddress String, ContactCity String, StateProv String, OtherInfo String, DLReg String, Status Boolean, ContactType String, AddressSameAsCust Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, AccountingID String, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** CustContactID=***masked***; CustCode=MIN004; GroupNumb=00; ContactName=R***; Email=***masked***; Mobile=***masked***; StateProv=CA; Status=False; ContactType=***masked***; AddressSameAsCust=***masked***; CreatedBy=tharmeyer; CreatedDate=04/28/2020 15:02:42; ModifiedBy=joes; ModifiedDate=08/22/2023 19:31:03; _SourceExtractedAtUTC=06/23/2026 08:00:14; _LoadedAtUTC=06/23/2026 08:00:18
- **row 2:** CustContactID=***masked***; CustCode=AIR067; GroupNumb=00; ContactName=R***; Email=***masked***; Mobile=***masked***; StateProv=CA; Status=True; ContactType=***masked***; AddressSameAsCust=***masked***; CreatedBy=tharmeyer; CreatedDate=05/07/2020 16:46:22; ModifiedBy=tharmeyer; ModifiedDate=05/07/2020 16:46:22; _SourceExtractedAtUTC=06/23/2026 08:00:14; _LoadedAtUTC=06/23/2026 08:00:18
- **row 3:** CustContactID=***masked***; CustCode=AIR067; GroupNumb=00; ContactName=H***; Email=***masked***; Mobile=***masked***; StateProv=CA; Status=True; ContactType=***masked***; AddressSameAsCust=***masked***; CreatedBy=tharmeyer; CreatedDate=05/07/2020 17:09:38; ModifiedBy=tharmeyer; ModifiedDate=05/07/2020 17:09:38; _SourceExtractedAtUTC=06/23/2026 08:00:14; _LoadedAtUTC=06/23/2026 08:00:18

## src.FMS_CUSTOMER_LOCATIONS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_CUSTOMER_LOCATIONS]`

Row count: **26060**. Columns (48):

`CustLocationID Int32, CustCode String, LocationName String, Address1 String, Address2 String, City String, StateCode String, Zip String, Country String, Phone String, AltPhone String, Description String, OrderedBy String, OrdByPhone String, Fax String, ReportTo String, ReportToPhone String, Taxable Boolean, SalesTaxCode String, Directions String, GroupNumb String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, Status Boolean, County String, Flag String, ReportToEmail String, OrderedByEmail String, CountyCode String, OrderedByWP String, ReportToWP String, EmailInvoice String, OrderedByContactID Int32, ReportedToContactID Int32, PriceList String, PriceExpires DateTime, MSHA Boolean, Latitude Decimal, Longitude Decimal, ValidationStatus String, EntityUseCode String, CountryCode String, AddressUnknown Boolean, GeoFenceRadius Decimal, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** CustLocationID=13710; CustCode=HIG010; LocationName=[***; Address1=***masked***; Address2=***masked***; City=***masked***; StateCode=CA; Zip=***masked***; Phone=***masked***; Fax=***masked***; Taxable=False; GroupNumb=00; CreatedBy=jflores; CreatedDate=08/14/2023 12:09:19; ModifiedBy=jflores; ModifiedDate=08/14/2023 12:09:19; Status=True; PriceExpires=08/14/2023 00:00:00; MSHA=False; Latitude=34.053800; Longitude=-117.304100; AddressUnknown=***masked***; _SourceExtractedAtUTC=06/23/2026 08:00:19; _LoadedAtUTC=06/23/2026 08:00:35
- **row 2:** CustLocationID=13711; CustCode=HOT001; LocationName=T***; Address1=***masked***; City=***masked***; StateCode=CA; OrderedBy=Pete Santibanez; ReportTo=Pete Santibanez; Taxable=False; GroupNumb=00; CreatedBy=joes; CreatedDate=08/14/2023 12:16:46; ModifiedBy=joes; ModifiedDate=08/14/2023 12:16:47; Status=True; EmailInvoice=***masked***; OrderedByContactID=***masked***; ReportedToContactID=***masked***; PriceList=POLE CONTRACTOR; MSHA=False; Latitude=34.057800; Longitude=-118.159500; AddressUnknown=***masked***; _SourceExtractedAtUTC=06/23/2026 08:00:19; _LoadedAtUTC=06/23/2026 08:00:35
- **row 3:** CustLocationID=13712; CustCode=SOU050; LocationName=N***; Address1=***masked***; Address2=***masked***; City=***masked***; StateCode=CA; OrderedBy=Darryl Kinnane; ReportTo=Juan Morales; ReportToPhone=***masked***; Taxable=False; GroupNumb=00; CreatedBy=joes; CreatedDate=08/14/2023 12:25:15; ModifiedBy=joes; ModifiedDate=06/11/2025 18:37:19; Status=True; EmailInvoice=***masked***; OrderedByContactID=***masked***; ReportedToContactID=***masked***; MSHA=False; Latitude=34.090085; Longitude=-118.067114; AddressUnknown=***masked***; _SourceExtractedAtUTC=06/23/2026 08:00:19; _LoadedAtUTC=06/23/2026 08:00:35

## src.FMS_CUSTOMER_NOTES_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_CUSTOMER_NOTES]`

Row count: **119**. Columns (13):

`CustomerNotesID Int64, CustCode String, GroupNumb String, Name String, PopUpMessage String, DisplayMessage String, Comments String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** CustomerNotesID=2; CustCode=ACC015; GroupNumb=00; PopUpMessage=Include Vendor # on all invoices #416399; DisplayMessage=I; CreatedBy=melissam; CreatedDate=07/12/2020 20:55:42; ModifiedBy=melissam; ModifiedDate=07/12/2020 20:55:42; _SourceExtractedAtUTC=06/23/2026 08:00:36; _LoadedAtUTC=06/23/2026 08:00:36
- **row 2:** CustomerNotesID=3; CustCode=BEC001; GroupNumb=00; PopUpMessage=Let Sammy know we are schdueling a job with them before the ...; DisplayMessage=All; CreatedBy=melissam; CreatedDate=05/11/2021 12:57:31; ModifiedBy=sammym; ModifiedDate=09/03/2021 13:07:19; _SourceExtractedAtUTC=06/23/2026 08:00:36; _LoadedAtUTC=06/23/2026 08:00:36
- **row 3:** CustomerNotesID=4; CustCode=PAR016; GroupNumb=00; PopUpMessage=PO Required (TD# ); DisplayMessage=J; CreatedBy=sammym; CreatedDate=05/17/2021 13:44:18; ModifiedBy=sammym; ModifiedDate=05/17/2021 13:44:18; _SourceExtractedAtUTC=06/23/2026 08:00:36; _LoadedAtUTC=06/23/2026 08:00:36

## src.FMS_CUSTOMERS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_CUSTOMERS]`

Row count: **6057**. Columns (103):

`CustCode String, Name1 String, Name2 String, Address1 String, Address2 String, City String, StateCode String, Zip String, Country String, Email String, WebSite String, Phone String, Fax String, BillContact1 String, BillPhone1 String, BillContact2 String, BillPhone2 String, ClassID String, SpersonCode String, LastNameFirst Boolean, PartsDisc Decimal, PORequire Boolean, IndustryCode String, Taxable Boolean, SalesTaxCode String, Insurance Boolean, Expires DateTime, ContractNumb String, StatementType String, TermID Int32, Status String, Comments String, GroupNumb String, AcctUpdated Boolean, FinChgPercent Decimal, AcctIntCode String, CreditLimit Decimal, PriceList String, PriceExpires DateTime, Notes String, BillingTaxable Boolean, CurrentBalance Decimal, LeaseAgreement Boolean, LeaseExpire DateTime, LeaseNo String, Legal1 Boolean, Legal2 Boolean, Legal3 Boolean, Legal4 Boolean, Legal5 Boolean, Legal6 Boolean, Legal7 Boolean, Legal8 Boolean, Legal9 Boolean, Legal10 Boolean, Legal11 Boolean, Legal12 Boolean, LegalDate1 DateTime, LegalDate2 DateTime, LegalDate3 DateTime, LegalDate4 DateTime, LegalDate5 DateTime, LegalDate6 DateTime, LegalDate7 DateTime, LegalDate8 DateTime, LegalDate9 DateTime, LegalDate10 DateTime, LegalDate11 DateTime, LegalDate12 DateTime, TaxExempt String, ListMarkUp String, MarkUpPerc Decimal, EmailDocOK Boolean, CustTypeCode String, BlanketInsuranceAmt Decimal, PerOccurrenceAmt Decimal, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_CUSTOMERS Boolean, FederalTaxID String, TmwCityStateID Int32, BillContact1ID Int32, BillContact2ID Int32, POBeforeTicket Boolean, COI String, USDOT String, ApplyEnvironmentalLevy Boolean, SubContractor Boolean, BPay String, AvalaraSent Boolean, EntityUseCode String, ProspectCode String, ProspectStatus Boolean, CountryCode String, InterCompanyAcct Boolean, DBAName String, HRTempID String, ParentCustCode String, PricingMatrixCode String, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** CustCode=[]; Name1=D***; LastNameFirst=F***; PartsDisc=0.00; PORequire=False; Taxable=False; Insurance=False; StatementType=O; Status=A; GroupNumb=00; AcctUpdated=False; BillingTaxable=False; CurrentBalance=0.000; LeaseAgreement=False; Legal1=False; Legal2=False; Legal3=False; Legal4=False; Legal5=False; Legal6=False; Legal7=False; Legal8=False; Legal9=False; Legal10=False; Legal11=False; Legal12=False; ListMarkUp=M; EmailDocOK=***masked***; CreatedBy=sa; CreatedDate=04/09/2019 10:22:44; ModifiedBy=sa; ModifiedDate=04/09/2019 10:22:44; trgFMS_CUSTOMERS=False; POBeforeTicket=False; ApplyEnvironmentalLevy=True; SubContractor=False; AvalaraSent=False; ProspectStatus=True; InterCompanyAcct=False; _SourceExtractedAtUTC=06/23/2026 08:00:36; _LoadedAtUTC=06/23/2026 08:00:42
- **row 2:** CustCode=100001; Name1=1***; Address1=***masked***; City=***masked***; StateCode=CA; Zip=***masked***; Country=USA; Phone=***masked***; LastNameFirst=F***; PartsDisc=0.00; PORequire=False; Taxable=False; Insurance=False; StatementType=O; TermID=8; Status=A; GroupNumb=00; AcctUpdated=True; AcctIntCode=8985; BillingTaxable=False; CurrentBalance=0.000; LeaseAgreement=False; Legal1=False; Legal2=False; Legal3=False; Legal4=False; Legal5=False; Legal6=False; Legal7=False; Legal8=False; Legal9=False; Legal10=False; Legal11=False; Legal12=False; ListMarkUp=M; MarkUpPerc=0.00; EmailDocOK=***masked***; CreatedBy=tharmeyer; CreatedDate=04/06/2020 12:14:12; ModifiedBy=aschacatano; ModifiedDate=09/18/2025 16:37:14; trgFMS_CUSTOMERS=False; POBeforeTicket=False; ApplyEnvironmentalLevy=True; SubContractor=False; AvalaraSent=False; ProspectStatus=False; InterCompanyAcct=False; _SourceExtractedAtUTC=06/23/2026 08:00:36; _LoadedAtUTC=06/23/2026 08:00:42
- **row 3:** CustCode=123001; Name1=1***; Address1=***masked***; City=***masked***; StateCode=CA; Zip=***masked***; Country=USA; Email=***masked***; Phone=***masked***; LastNameFirst=F***; PartsDisc=0.00; PORequire=False; Taxable=False; Insurance=False; StatementType=O; TermID=1; Status=A; GroupNumb=00; AcctUpdated=True; AcctIntCode=8927; BillingTaxable=False; CurrentBalance=0.000; LeaseAgreement=False; Legal1=False; Legal2=False; Legal3=False; Legal4=False; Legal5=False; Legal6=False; Legal7=False; Legal8=False; Legal9=False; Legal10=False; Legal11=False; Legal12=False; ListMarkUp=M; MarkUpPerc=0.00; EmailDocOK=***masked***; CreatedBy=tharmeyer; CreatedDate=04/06/2020 12:14:12; ModifiedBy=aschacatano; ModifiedDate=09/23/2025 11:49:12; trgFMS_CUSTOMERS=False; POBeforeTicket=False; ApplyEnvironmentalLevy=True; SubContractor=False; AvalaraSent=False; ProspectStatus=False; InterCompanyAcct=False; _SourceExtractedAtUTC=06/23/2026 08:00:36; _LoadedAtUTC=06/23/2026 08:00:42

## src.FMS_DEPARTMENTS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_DEPARTMENTS]`

Row count: **10**. Columns (18):

`DeptCode String, Name String, PONumb Decimal, Flag String, InvoiceNumb Decimal, JobCode Decimal, QuoteNumb Decimal, Branch String, Status Boolean, GSTNo String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_DEPARTMENTS Boolean, ExpAcct Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** DeptCode=CR; Name=C***; Status=True; CreatedBy=jstricker; CreatedDate=08/13/2025 17:02:05; ModifiedBy=jstricker; ModifiedDate=08/13/2025 17:02:05; trgFMS_DEPARTMENTS=False; ExpAcct=False; _SourceExtractedAtUTC=06/23/2026 08:00:43; _LoadedAtUTC=06/23/2026 08:00:43
- **row 2:** DeptCode=FL; Name=F***; Status=True; CreatedBy=mbsi; CreatedDate=07/03/2019 12:04:08; ModifiedBy=mbsi; ModifiedDate=07/03/2019 12:04:08; trgFMS_DEPARTMENTS=False; ExpAcct=True; _SourceExtractedAtUTC=06/23/2026 08:00:43; _LoadedAtUTC=06/23/2026 08:00:43
- **row 3:** DeptCode=ID; Name=I***; Status=True; CreatedBy=jstricker; CreatedDate=06/10/2024 10:34:23; ModifiedBy=jstricker; ModifiedDate=06/10/2024 10:34:39; trgFMS_DEPARTMENTS=False; ExpAcct=True; _SourceExtractedAtUTC=06/23/2026 08:00:43; _LoadedAtUTC=06/23/2026 08:00:43

## src.FMS_EMPLOYEE_TYPES_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_EMPLOYEE_TYPES]`

Row count: **15**. Columns (11):

`EmpTypeID Int32, Description String, Status Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_EMPLOYEE_TYPES Boolean, Type String, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** EmpTypeID=1; Description=Operator; Status=True; CreatedBy=mbsi; CreatedDate=07/03/2019 13:51:22; ModifiedBy=mbsi; ModifiedDate=07/03/2019 13:51:22; trgFMS_EMPLOYEE_TYPES=False; Type=B; _SourceExtractedAtUTC=06/23/2026 08:00:43; _LoadedAtUTC=06/23/2026 08:00:43
- **row 2:** EmpTypeID=2; Description=Oiler; Status=True; CreatedBy=mbsi; CreatedDate=07/03/2019 13:51:22; ModifiedBy=mbsi; ModifiedDate=07/03/2019 13:51:22; trgFMS_EMPLOYEE_TYPES=False; Type=B; _SourceExtractedAtUTC=06/23/2026 08:00:43; _LoadedAtUTC=06/23/2026 08:00:43
- **row 3:** EmpTypeID=3; Description=Mechanic; Status=True; CreatedBy=mbsi; CreatedDate=07/03/2019 13:51:22; ModifiedBy=mbsi; ModifiedDate=07/03/2019 13:51:22; trgFMS_EMPLOYEE_TYPES=False; Type=B; _SourceExtractedAtUTC=06/23/2026 08:00:43; _LoadedAtUTC=06/23/2026 08:00:43

## src.FMS_EMPLOYEES_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_EMPLOYEES]`

Row count: **242**. Columns (129):

`EmpID String, LName String, FName String, MName String, Address1 String, Address2 String, City String, StateCode String, Zip String, Ssn String, CertPay Boolean, Phone String, Mobile String, Pager String, CompanyCode String, YardCode String, Email String, PayCycle String, PayType String, UnionCode String, CraftCode String, PayRate Decimal, BillingRate Decimal, PayRateOT Decimal, PayRateDB Decimal, BillRateOT Decimal, BillRateDB Decimal, StartDate DateTime, RehireDate DateTime, TermDate DateTime, Status Boolean, TermReason String, InOffice String, Supervisor Boolean, EmpTypeId Int32, BurdenCode String, WorkerCompCode String, ClassCode String, ClassID String, GLAcctCode String, BirthDate DateTime, Gender String, Ethnic String, Apprentice Boolean, UnionOpt1 Boolean, UnionOpt2 Boolean, UnionOpt3 Boolean, UnionOpt4 Boolean, UnionOpt5 Boolean, UnionOpt6 Boolean, UnionOpt7 Boolean, Comments String, AcctUpdated Boolean, AcctIntCode String, StateTax String, CityTax String, JobTitleCode String, MaritalStatus String, GroupNumb String, DeptCode String, SutaState String, UnionOverScale Decimal, UnionOverScaleDB Decimal, UnionOverScaleOT Decimal, UnionApprenticePerc Decimal, MailBoxNo String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, OTEligible String, OTHours Decimal, DTEligible String, DTHours Decimal, SatOTAlltimeHW String, SatOTAllTimeHours Decimal, SunOTAlltimeHW String, SunOTAllTimeHours Decimal, SunDTAlltimeHW String, SunDTAllTimeHours Decimal, PerDiem String, PerDiemCraftCode String, PerDiemMinHours Decimal, PerDiemEveryHr Boolean, Meals String, MealsCraftCode String, MealsMinHours Decimal, trgFMS_EMPLOYEES Boolean, RecFAAEmail Boolean, ECName String, ECAddress String, ECCity String, ECStateCode String, ECZip String, ECWorkPhone String, ECCellPhone String, ECHomePhone String, ECEmail String, EC2Name String, EC2Address String, EC2City String, EC2StateCode String, EC2Zip String, EC2WorkPhone String, EC2CellPhone String, EC2HomePhone String, EC2Email String, PayrollExportedDate DateTime, RoundLimit Int32, ApprenticeRegNo String, TelematicsGUID String, MinimumRate Boolean, OTWeekHours Decimal, DTWeekHours Decimal, SplitMultipleDays Boolean, EldUserName String, CraftModifierCode String, ITIID String, ITIModifiedDate DateTime, ITICreatedDate DateTime, ITICreatedBy String, ITIModifiedBy String, SendEmpITI Boolean, DLNumber String, DLStateCode String, PayrollNo String, STPriority Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** EmpID=E***04; LName=B***; FName=K***; CertPay=True; CompanyCode=CG; YardCode=MY; PayCycle=W; PayType=H; UnionCode=L12; CraftCode=L12-G7-A; PayRate=0.000; BillingRate=0.000; PayRateOT=0.000; PayRateDB=0.000; BillRateOT=0.000; BillRateDB=0.000; StartDate=05/24/2024 00:00:00; Status=True; InOffice=N; Supervisor=False; EmpTypeId=1; BurdenCode=STD; WorkerCompCode=OPERATOR RATE; ClassCode=FIELD EMP; BirthDate=***masked***; Apprentice=False; UnionOpt1=False; UnionOpt2=False; UnionOpt3=False; UnionOpt4=False; UnionOpt5=False; UnionOpt6=False; UnionOpt7=False; AcctUpdated=False; GroupNumb=00; UnionOverScale=0.000; UnionOverScaleDB=0.000; UnionOverScaleOT=0.000; CreatedBy=corrinab; CreatedDate=05/24/2024 14:44:36; ModifiedBy=corrinab; ModifiedDate=11/21/2025 14:58:06; OTHours=0.00; DTHours=0.00; SatOTAllTimeHours=0.00; SunOTAllTimeHours=0.00; SunDTAllTimeHours=0.00; PerDiemEveryHr=False; trgFMS_EMPLOYEES=False; RecFAAEmail=***masked***; MinimumRate=False; OTWeekHours=0.00; DTWeekHours=0.00; SplitMultipleDays=False; SendEmpITI=True; STPriority=False; _SourceExtractedAtUTC=06/23/2026 08:00:44; _LoadedAtUTC=06/23/2026 08:00:44
- **row 2:** EmpID=E***11; LName=M***; FName=L***; CertPay=True; Pager=***masked***; CompanyCode=CG; YardCode=MY; PayCycle=W; PayType=H; UnionCode=L12; CraftCode=L12-G6-A; PayRate=0.000; BillingRate=0.000; PayRateOT=0.000; PayRateDB=0.000; BillRateOT=0.000; BillRateDB=0.000; StartDate=01/20/2025 00:00:00; Status=True; InOffice=N; Supervisor=False; EmpTypeId=14; BurdenCode=STD; WorkerCompCode=OPERATOR RATE; ClassCode=FIELD EMP; BirthDate=***masked***; Gender=***masked***; Ethnic=***masked***; Apprentice=False; UnionOpt1=False; UnionOpt2=False; UnionOpt3=False; UnionOpt4=False; UnionOpt5=False; UnionOpt6=False; UnionOpt7=False; AcctUpdated=False; MaritalStatus=***masked***; GroupNumb=00; UnionOverScale=0.000; UnionOverScaleDB=0.000; UnionOverScaleOT=0.000; CreatedBy=corrinab; CreatedDate=01/20/2025 21:12:56; ModifiedBy=corrinab; ModifiedDate=11/21/2025 15:02:20; OTHours=0.00; DTHours=0.00; SatOTAllTimeHours=0.00; SunOTAllTimeHours=0.00; SunDTAllTimeHours=0.00; PerDiemEveryHr=False; trgFMS_EMPLOYEES=False; RecFAAEmail=***masked***; ECName=K***; ECCellPhone=***masked***; MinimumRate=False; OTWeekHours=0.00; DTWeekHours=0.00; SplitMultipleDays=False; SendEmpITI=True; STPriority=False; _SourceExtractedAtUTC=06/23/2026 08:00:44; _LoadedAtUTC=06/23/2026 08:00:44
- **row 3:** EmpID=E***53; LName=V***; FName=W***; CertPay=True; Pager=***masked***; CompanyCode=CG; YardCode=MY; PayCycle=W; PayType=H; UnionCode=L12; CraftCode=L12-G8-A; PayRate=0.000; BillingRate=0.000; PayRateOT=0.000; PayRateDB=0.000; BillRateOT=0.000; BillRateDB=0.000; StartDate=03/05/2025 00:00:00; Status=True; InOffice=N; Supervisor=False; EmpTypeId=1; BurdenCode=STD; WorkerCompCode=OPERATOR RATE; ClassCode=FIELD EMP; BirthDate=***masked***; Apprentice=False; UnionOpt1=False; UnionOpt2=False; UnionOpt3=False; UnionOpt4=False; UnionOpt5=False; UnionOpt6=False; UnionOpt7=False; AcctUpdated=False; GroupNumb=00; UnionOverScale=0.000; UnionOverScaleDB=0.000; UnionOverScaleOT=0.000; CreatedBy=corrinab; CreatedDate=03/05/2025 19:25:36; ModifiedBy=srangel; ModifiedDate=05/27/2025 19:13:11; OTHours=0.00; DTHours=0.00; SatOTAllTimeHours=0.00; SunOTAllTimeHours=0.00; SunDTAllTimeHours=0.00; PerDiemEveryHr=False; trgFMS_EMPLOYEES=False; RecFAAEmail=***masked***; ECName=J***; ECCellPhone=***masked***; EC2Name=S***; EC2CellPhone=***masked***; MinimumRate=False; OTWeekHours=0.00; DTWeekHours=0.00; SplitMultipleDays=False; SendEmpITI=True; STPriority=False; _SourceExtractedAtUTC=06/23/2026 08:00:44; _LoadedAtUTC=06/23/2026 08:00:44

## src.FMS_ETHNICITY_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_ETHNICITY]`

Row count: **7**. Columns (10):

`EthnicityCode String, Description String, Status Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_ETHNICITY Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** EthnicityCode=***masked***; Description=Asian; Status=True; trgFMS_ETHNICITY=***masked***; _SourceExtractedAtUTC=06/23/2026 08:00:45; _LoadedAtUTC=06/23/2026 08:00:45
- **row 2:** EthnicityCode=***masked***; Description=Black; Status=True; trgFMS_ETHNICITY=***masked***; _SourceExtractedAtUTC=06/23/2026 08:00:45; _LoadedAtUTC=06/23/2026 08:00:45
- **row 3:** EthnicityCode=***masked***; Description=Caucasian; Status=True; trgFMS_ETHNICITY=***masked***; _SourceExtractedAtUTC=06/23/2026 08:00:45; _LoadedAtUTC=06/23/2026 08:00:45

## src.FMS_ETS_TICKET_SUB_SECTION_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_ETS_TICKET_SUB_SECTION]`

Row count: **42**. Columns (13):

`TemplateID Int32, TicketSectionListID Int32, TicketSectionSubListID Int32, Visibility Boolean, Printed Boolean, DisplaySectionName String, LineNumb Int32, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** TemplateID=1; TicketSectionListID=3; TicketSectionSubListID=1; Visibility=False; Printed=False; LineNumb=1; CreatedBy=sa; CreatedDate=02/18/2022 15:52:49; ModifiedBy=melissam; ModifiedDate=03/26/2026 20:41:28; _SourceExtractedAtUTC=06/23/2026 08:00:45; _LoadedAtUTC=06/23/2026 08:00:46
- **row 2:** TemplateID=1; TicketSectionListID=3; TicketSectionSubListID=2; Visibility=False; Printed=False; LineNumb=2; CreatedBy=sa; CreatedDate=02/18/2022 15:52:49; ModifiedBy=melissam; ModifiedDate=03/26/2026 20:41:28; _SourceExtractedAtUTC=06/23/2026 08:00:45; _LoadedAtUTC=06/23/2026 08:00:46
- **row 3:** TemplateID=1; TicketSectionListID=3; TicketSectionSubListID=3; Visibility=False; Printed=False; LineNumb=3; CreatedBy=sa; CreatedDate=02/18/2022 15:52:49; ModifiedBy=melissam; ModifiedDate=03/26/2026 20:41:28; _SourceExtractedAtUTC=06/23/2026 08:00:45; _LoadedAtUTC=06/23/2026 08:00:46

## src.FMS_INDUSTRIES_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_INDUSTRIES]`

Row count: **33**. Columns (11):

`IndustryCode String, Name String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_INDUSTRIES Boolean, Status Boolean, NetSuiteID String, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** IndustryCode=AC; Name=A***; CreatedBy=mbsi; CreatedDate=09/11/2019 13:03:19; ModifiedBy=mbsi; ModifiedDate=09/11/2019 13:03:19; trgFMS_INDUSTRIES=False; Status=True; _SourceExtractedAtUTC=06/23/2026 08:00:46; _LoadedAtUTC=06/23/2026 08:00:46
- **row 2:** IndustryCode=AGR; Name=A***; CreatedBy=bpetros; CreatedDate=10/27/2025 17:08:08; ModifiedBy=bpetros; ModifiedDate=10/27/2025 17:08:08; trgFMS_INDUSTRIES=False; Status=True; _SourceExtractedAtUTC=06/23/2026 08:00:46; _LoadedAtUTC=06/23/2026 08:00:46
- **row 3:** IndustryCode=ART; Name=A***; CreatedBy=bpetros; CreatedDate=10/27/2025 17:08:08; ModifiedBy=bpetros; ModifiedDate=10/27/2025 17:08:08; trgFMS_INDUSTRIES=False; Status=True; _SourceExtractedAtUTC=06/23/2026 08:00:46; _LoadedAtUTC=06/23/2026 08:00:46

## src.FMS_JOB_CHECKLIST_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_JOB_CHECKLIST]`

Row count: **55438**. Columns (9):

`JobCode String, CheckListID Int32, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_JOB_CHECKLIST Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** JobCode=1; CheckListID=81; CreatedBy=lisettea; CreatedDate=08/02/2022 14:46:22; ModifiedBy=lizettel; ModifiedDate=08/03/2022 13:05:06; trgFMS_JOB_CHECKLIST=True; _SourceExtractedAtUTC=01/22/2026 23:58:32; _LoadedAtUTC=01/22/2026 23:58:32
- **row 2:** JobCode=1; CheckListID=129; CreatedBy=lisettea; CreatedDate=08/02/2022 14:46:22; ModifiedBy=lizettel; ModifiedDate=08/03/2022 13:05:06; trgFMS_JOB_CHECKLIST=True; _SourceExtractedAtUTC=01/22/2026 23:58:32; _LoadedAtUTC=01/22/2026 23:58:32
- **row 3:** JobCode=MC37564; CheckListID=81; CreatedBy=lizettel; CreatedDate=01/10/2022 12:57:13; ModifiedBy=lizettel; ModifiedDate=01/10/2022 12:57:13; trgFMS_JOB_CHECKLIST=False; _SourceExtractedAtUTC=01/22/2026 23:58:32; _LoadedAtUTC=01/22/2026 23:58:32

## src.FMS_JOB_EMPLOYEES_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_JOB_EMPLOYEES]`

Row count: **56486**. Columns (26):

`JobEmpID Int32, EmpTypeID Int32, EmpID String, JobCode String, DateStart DateTime, DateEnd DateTime, TimeStart DateTime, TimeEnd DateTime, CraftCode String, Comments String, BillingRate Decimal, TalkedTo Boolean, UnitCode String, LineNumb Int16, GroupNumb String, Status String, LoadNo String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, EmpDownCode String, JobEmpStatus String, PrimaryResource Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** JobEmpID=20730; EmpTypeID=1; EmpID=E***74; JobCode=OM41987; DateStart=01/23/2023 00:00:00; DateEnd=01/23/2023 00:00:00; TimeStart=01/23/2023 20:00:00; TimeEnd=01/23/2023 20:00:00; TalkedTo=False; LineNumb=4; GroupNumb=00; CreatedBy=melissam; CreatedDate=01/20/2023 19:12:30; ModifiedBy=lisettea; ModifiedDate=01/23/2023 18:12:19; JobEmpStatus=R; PrimaryResource=False; _SourceExtractedAtUTC=06/23/2026 08:00:47; _LoadedAtUTC=06/23/2026 08:01:15
- **row 2:** JobEmpID=20731; EmpTypeID=2; EmpID=E***55; JobCode=OM41987; DateStart=01/23/2023 00:00:00; DateEnd=01/23/2023 00:00:00; TimeStart=01/23/2023 20:00:00; TimeEnd=01/23/2023 20:00:00; TalkedTo=False; LineNumb=5; GroupNumb=00; CreatedBy=melissam; CreatedDate=01/20/2023 19:12:30; ModifiedBy=lisettea; ModifiedDate=01/23/2023 18:12:19; JobEmpStatus=R; PrimaryResource=False; _SourceExtractedAtUTC=06/23/2026 08:00:47; _LoadedAtUTC=06/23/2026 08:01:15
- **row 3:** JobEmpID=20732; EmpTypeID=14; EmpID=E***00; JobCode=OM41987; DateStart=01/23/2023 00:00:00; DateEnd=01/23/2023 00:00:00; TimeStart=01/23/2023 20:00:00; TimeEnd=01/23/2023 20:00:00; TalkedTo=False; LineNumb=6; GroupNumb=00; CreatedBy=melissam; CreatedDate=01/20/2023 19:12:30; ModifiedBy=melissam; ModifiedDate=01/20/2023 19:12:30; JobEmpStatus=R; PrimaryResource=False; _SourceExtractedAtUTC=06/23/2026 08:00:47; _LoadedAtUTC=06/23/2026 08:01:15

## src.FMS_JOB_MASTER_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_JOB_MASTER]`

Row count: **29609**. Columns (192):

`JobCode String, CompanyCode String, YardCode String, DeptCode String, CustCode String, CustLocationID Int32, ShipFromLocation Int32, Travel DateTime, SortNumb Decimal, ReportedBy String, OrderedBy String, PoNumb String, JobSdate DateTime, JobEdate DateTime, DateFlex Boolean, JobStime DateTime, JobEtime DateTime, TimeFlex Boolean, WorkWeekend Boolean, Dispatched Boolean, JobTypeCode String, CheckID Int32, SpersonCode String, TakenID Int32, TimeEntered DateTime, Status String, EquipRequired String, Comments String, WorkDescription String, InHouse String, Insurance Boolean, InsureExpire DateTime, SignContract Boolean, ContractNumb String, BillingType String, RetainPercent Decimal, CertPay Boolean, LiftBack String, LiftUp String, LiftIn String, LiftPieces String, TotalWeight String, DistanceHauled String, HeaviestPick String, SrtBackFrBlg String, Radius String, Height String, GLAcctCode String, QuoteNumb String, NextAppNumb Int32, GroupNumb String, MarkUpPerc Decimal, Directions String, ReoccurEvery Int32, TimePeriod String, OrigDate DateTime, NextInvDate DateTime, DaysInAdvance Int32, LastInvDate DateTime, PaymentType String, PaymentInfo String, ExpirationDate DateTime, PaymentDate DateTime, PaymentAmount Decimal, DiscountAmt Decimal, Payment2Type String, Payment2Info String, Expiration2Date DateTime, Payment2Date DateTime, Payment2Amount Decimal, CustCodeFrom String, PaymentUser String, Payment2User String, PaymentExported Boolean, Payment2Exported Boolean, CustContractNo String, MinimumStartDate DateTime, OCIP Boolean, PayApp Boolean, OwnerSameAsCust Boolean, OwnerName String, OwnerName2 String, OwnerAddress1 String, OwnerAddress2 String, OwnerCity String, OwnerState String, OwnerZip String, OwnerCountry String, OwnerPhone String, OwnerLegalDesc String, MinRentalMonths Int32, EquipHrsAllowed Int32, ContractType String, TerminationCode String, USCurrency Boolean, BillingDescription String, ScheduleID String, JobCreatedExternally Boolean, LeaseAgreement Boolean, LeaseExpires DateTime, LeaseNo String, Collect Boolean, ContactPriorToDelivery Boolean, HazardousMaterials Boolean, ItemsToShip String, Instructions String, PriceList String, WcGroup String, PrelienDate DateTime, PrelienAmount Decimal, ApprovedBy Int32, ApprovedDate DateTime, LocOrdByPhone String, LocReportToPhone String, LienDate DateTime, LienAmount Decimal, OverLimitOK Boolean, OverLimitOkUser String, OverLimitOKDate DateTime, TransportOption String, Distance Decimal, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_JOB_MASTER Boolean, JobOK Boolean, JobDirectionsURL String, JobEstimate Decimal, ReportToEmail String, OrderedByEmail String, TermCondID Int32, Opportunity String, CarrierPro String, ShipperBOL String, SCAC String, NotifyName String, NotifyPhone String, NotifyFax String, NotifyEmail String, Hours Int32, DeclaredValue Decimal, PerInch Decimal, CheckList String, CashSales Boolean, Bond String, FreightRate Decimal, AgreementEmailed Boolean, AgreementPrinted Boolean, FAAPermit Boolean, FAADays Byte, ReportedToWP String, OrderedByWP String, TruckingLength String, TruckingWidth String, TruckingHeight String, TruckingPieces String, TruckingTotalWt String, Complexity String, OrderedByContactID Int32, ReportedToContactID Int32, BillToID Int32, DefaultBillToID Int32, JobLeaseTermCondID Int32, LockedUserID Int32, LockedDatetime DateTime, HookReady DateTime, LiftPlan String, PriceExpires DateTime, MSHA Boolean, IndustryCode String, JobSiteIndustryID Int32, JobSiteWorkTypeID Int32, CancelationNote String, CancelationBy String, CancelationDate DateTime, BillingCompleted Boolean, PrintDisclaimer Boolean, EmpID String, JobEndDateUnkown Boolean, SantosMSG String, SantosDeptMain String, SantosDeptSub String, StandBy Boolean, CustPOAmount Decimal, ExpAcct Boolean, ReqSignatureOnTickets Boolean, FooterID Int32, NonBillable Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime, EffectiveModifiedUTC DateTime`

Sample rows (masked):

- **row 1:** JobCode=1; CompanyCode=CG; YardCode=MY; DeptCode=OM; CustCode=TRI012; CustLocationID=9415; SortNumb=1; ReportedBy=alfred; OrderedBy=Scott; PoNumb=612271; JobSdate=08/04/2022 00:00:00; JobEdate=08/04/2022 00:00:00; DateFlex=False; JobStime=08/02/2022 06:00:00; JobEtime=08/02/2022 07:00:00; TimeFlex=False; WorkWeekend=True; Dispatched=False; JobTypeCode=H; CheckID=2; SpersonCode=5010; TakenID=3; TimeEntered=08/02/2022 11:39:00; Status=R; EquipRequired={\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1033{\fonttb...; Comments={\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1033{\fonttb...; WorkDescription={\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1033{\fonttb...; Insurance=False; SignContract=False; BillingType=N; CertPay=False; LiftPieces=55; TotalWeight=500; Height=25; NextAppNumb=1; GroupNumb=00; ReoccurEvery=0; TimePeriod=Days; DaysInAdvance=0; DiscountAmt=0.000; PaymentExported=False; Payment2Exported=False; OCIP=False; OwnerSameAsCust=True; USCurrency=False; JobCreatedExternally=False; LeaseAgreement=False; Collect=False; ContactPriorToDelivery=***masked***; HazardousMaterials=False; PrelienDate=08/02/2022 00:00:00; PrelienAmount=0.0000; LienDate=08/02/2022 00:00:00; LienAmount=0.0000; CreatedBy=lisettea; CreatedDate=08/02/2022 14:46:22; ModifiedBy=bpetros; ModifiedDate=04/15/2026 04:38:11; trgFMS_JOB_MASTER=False; JobEstimate=0.0000; TermCondID=2; CashSales=False; AgreementEmailed=***masked***; AgreementPrinted=False; FAAPermit=False; OrderedByContactID=***masked***; ReportedToContactID=***masked***; MSHA=False; BillingCompleted=False; JobEndDateUnkown=False; StandBy=False; ExpAcct=False; ReqSignatureOnTickets=True; NonBillable=False; _SourceExtractedAtUTC=01/21/2026 08:59:14; _LoadedAtUTC=04/16/2026 08:06:47; EffectiveModifiedUTC=04/15/2026 04:38:11
- **row 2:** JobCode=DC; CustCode=[]; SortNumb=0; DateFlex=False; TimeFlex=False; WorkWeekend=True; Dispatched=False; Status=D; Insurance=False; SignContract=False; BillingType=N; CertPay=False; NextAppNumb=1; GroupNumb=00; DiscountAmt=0.000; PaymentExported=False; Payment2Exported=False; OCIP=False; PayApp=False; OwnerSameAsCust=False; USCurrency=False; JobCreatedExternally=False; LeaseAgreement=False; Collect=False; ContactPriorToDelivery=***masked***; HazardousMaterials=False; OverLimitOK=False; TransportOption=C; CreatedBy=sa; CreatedDate=06/22/2021 04:55:02; ModifiedBy=sa; ModifiedDate=06/22/2021 04:55:02; trgFMS_JOB_MASTER=False; JobOK=False; CashSales=False; AgreementEmailed=***masked***; AgreementPrinted=False; FAAPermit=False; MSHA=False; BillingCompleted=False; JobEndDateUnkown=False; StandBy=False; ExpAcct=False; ReqSignatureOnTickets=True; NonBillable=False; _SourceExtractedAtUTC=01/21/2026 08:47:17; _LoadedAtUTC=01/21/2026 08:47:17; EffectiveModifiedUTC=06/22/2021 04:55:02
- **row 3:** JobCode=DE; CustCode=[]; SortNumb=0; DateFlex=False; TimeFlex=False; WorkWeekend=True; Dispatched=False; Status=D; Insurance=False; SignContract=False; BillingType=N; CertPay=False; NextAppNumb=1; GroupNumb=00; DiscountAmt=0.000; PaymentExported=False; Payment2Exported=False; OCIP=False; PayApp=False; OwnerSameAsCust=False; USCurrency=False; JobCreatedExternally=False; LeaseAgreement=False; Collect=False; ContactPriorToDelivery=***masked***; HazardousMaterials=False; OverLimitOK=False; TransportOption=C; CreatedBy=sa; CreatedDate=06/22/2021 04:55:03; ModifiedBy=sa; ModifiedDate=06/22/2021 04:55:03; trgFMS_JOB_MASTER=False; JobOK=False; CashSales=False; AgreementEmailed=***masked***; AgreementPrinted=False; FAAPermit=False; MSHA=False; BillingCompleted=False; JobEndDateUnkown=False; StandBy=False; ExpAcct=False; ReqSignatureOnTickets=True; NonBillable=False; _SourceExtractedAtUTC=01/21/2026 08:47:17; _LoadedAtUTC=01/21/2026 08:47:17; EffectiveModifiedUTC=06/22/2021 04:55:03

## src.FMS_JOB_STATUS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_JOB_STATUS]`

Row count: **7**. Columns (8):

`JobStatusCode String, Description String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** JobStatusCode=C; Description=Confirmed; CreatedBy=sa; CreatedDate=02/18/2026 22:44:28; ModifiedBy=sa; ModifiedDate=02/18/2026 22:44:28; _SourceExtractedAtUTC=06/23/2026 08:01:17; _LoadedAtUTC=06/23/2026 08:01:17
- **row 2:** JobStatusCode=F; Description=Finished; CreatedBy=sa; CreatedDate=02/18/2026 22:44:28; ModifiedBy=sa; ModifiedDate=02/18/2026 22:44:28; _SourceExtractedAtUTC=06/23/2026 08:01:17; _LoadedAtUTC=06/23/2026 08:01:17
- **row 3:** JobStatusCode=O; Description=On Job; CreatedBy=sa; CreatedDate=02/18/2026 22:44:28; ModifiedBy=sa; ModifiedDate=02/18/2026 22:44:28; _SourceExtractedAtUTC=06/23/2026 08:01:17; _LoadedAtUTC=06/23/2026 08:01:17

## src.FMS_JOB_TICKET_EMP_UNIT_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_JOB_TICKET_EMP_UNIT]`

Row count: **129742**. Columns (44):

`JobTicketEmpUnitID Int32, JobTicketID Int32, JobCode String, JobUnitID Int32, UnitCode String, JobEmpID Int32, EmpID String, GroupNumb String, Downloaded Boolean, PrimaryEmp Boolean, Comments String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, Viewed Boolean, HoursUtilized Decimal, WorkDescription String, EquipRequired String, JobComments String, LiftBack String, LiftUp String, LiftIn String, LiftPieces String, TotalWeight String, DistanceHauled String, HeaviestPick String, SrtBackFrBlg String, Radius String, Height String, TruckingLength String, TruckingWidth String, TruckingHeight String, TruckingPieces String, TruckingTotalWt String, JobUnitComments String, JobOperComments String, JobOilerComments String, HookReady DateTime, ComponentCode String, JobComponentID Int32, SpecificationComments String, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** JobTicketEmpUnitID=115662; JobTicketID=42359; JobCode=OM57521; JobEmpID=53337; EmpID=E***92; GroupNumb=00; Downloaded=True; PrimaryEmp=True; CreatedBy=ddeitrick; CreatedDate=03/03/2026 17:48:16; ModifiedBy=jaldridge; ModifiedDate=03/04/2026 07:36:26; Viewed=True; _SourceExtractedAtUTC=03/04/2026 09:02:00; _LoadedAtUTC=03/05/2026 09:02:11
- **row 2:** JobTicketEmpUnitID=115663; JobTicketID=42359; JobCode=OM57521; JobEmpID=53338; EmpID=E***18; GroupNumb=00; Downloaded=False; PrimaryEmp=False; CreatedBy=ddeitrick; CreatedDate=03/03/2026 17:48:16; ModifiedBy=danag; ModifiedDate=04/28/2026 12:31:14; Viewed=True; _SourceExtractedAtUTC=03/04/2026 09:02:00; _LoadedAtUTC=04/29/2026 08:02:07
- **row 3:** JobTicketEmpUnitID=115664; JobTicketID=42359; JobCode=OM57521; JobEmpID=53339; EmpID=E***18; GroupNumb=00; Downloaded=False; PrimaryEmp=False; CreatedBy=ddeitrick; CreatedDate=03/03/2026 17:48:16; ModifiedBy=danag; ModifiedDate=04/28/2026 12:31:14; Viewed=True; _SourceExtractedAtUTC=03/04/2026 09:02:00; _LoadedAtUTC=04/29/2026 08:02:07

## src.FMS_JOB_TICKET_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_JOB_TICKET]`

Row count: **46336**. Columns (135):

`JobTicketID Int32, JobCode String, TicketDate DateTime, GroupNumb String, EstStartTime DateTime, EstEndTime DateTime, ActStartTime DateTime, ActEndTime DateTime, Qty Decimal, Signature String, JobTicketStatus String, Comments String, UnitCode String, CustCode String, AmountCollected Decimal, JobUnitID Int32, JobDtlID Int32, MeasureCode String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_JOB_TICKET Boolean, SignatureIn Byte[], SignatureOut Byte[], YardInTime DateTime, InvoiceCode String, EmpID String, SignatureInName String, SignatureOutName String, Downloaded Boolean, StdTerms String, YardOutTime DateTime, LeftJob DateTime, ArrivedJob DateTime, AcceptTerms Boolean, WorkThruLunch Boolean, OilerEmpID String, CustCodeFrom String, LoadNo String, Invoiced Boolean, MarkedInvoice Boolean, TicketType String, LastEmailSent DateTime, Approved Boolean, SignatureInTime DateTime, SignatureOutTime DateTime, TT String, STHours Decimal, OTHours Decimal, DBHours Decimal, ETicketStatus Int32, TimeStart DateTime, TimeEnd DateTime, ApprovedDate DateTime, LiftBack String, LiftUp String, LiftIn String, LiftPieces String, TotalWeight String, DistanceHauled String, HeaviestPick String, SrtBackFrBlg String, Radius String, Height String, TruckingLength String, TruckingWidth String, TruckingHeight String, TruckingPieces String, TruckingTotalWt String, Viewed Boolean, SubContractor Boolean, EstStartTimeUTC DateTime, EstEndTimeUTC DateTime, ActStartTimeUTC DateTime, ActEndTimeUTC DateTime, TimeStartUTC DateTime, TimeEndUTC DateTime, YardInTimeUTC DateTime, YardOutTimeUTC DateTime, SignatureInTimeUTC DateTime, SignatureOutTimeUTC DateTime, LeftJobUTC DateTime, ArrivedJobUTC DateTime, EstStartTimeTZ String, EstEndTimeTZ String, ActStartTimeTZ String, ActEndTimeTZ String, TimeStartTZ String, TimeEndTZ String, YardInTimeTZ String, YardOutTimeTZ String, SignatureInTimeTZ String, SignatureOutTimeTZ String, LeftJobTZ String, ArrivedJobTZ String, HoursUtilized Decimal, JobEmpID Int32, OilerJobEmpID Int32, HookReady DateTime, YardOutTimeOrig DateTime, YardOutTimeTZOrig String, YardOutTimeUTCOrig DateTime, YardInTimeOrig DateTime, YardInTimeTZOrig String, YardInTimeUTCOrig DateTime, TimeStartOrig DateTime, TimeStartTZOrig String, TimeStartUTCOrig DateTime, TimeEndOrig DateTime, TimeEndTZOrig String, TimeEndUTCOrig DateTime, LeftJobOrig DateTime, LeftJobTZOrig String, LeftJobUTCOrig DateTime, ArrivedJobOrig DateTime, ArrivedJobTZOrig String, ArrivedJobUTCOrig DateTime, TimeChangeJustification String, StartWorkTime DateTime, StartWorkTimeTZ String, StartWorkTimeUTC DateTime, StartWorkTimeOrig DateTime, StartWorkTimeTZOrig String, StartWorkTimeUTCOrig DateTime, EndWorkTime DateTime, EndWorkTimeTZ String, EndWorkTimeUTC DateTime, EndWorkTimeOrig DateTime, EndWorkTimeTZOrig String, EndWorkTimeUTCOrig DateTime, PostedToGeoTab Boolean, ReqSignatureOnTickets Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** JobTicketID=21; JobCode=OM30033; TicketDate=04/15/2020 00:00:00; GroupNumb=00; EstStartTime=04/14/2020 08:00:00; EstEndTime=04/14/2020 16:30:00; JobTicketStatus=Z; UnitCode=9001; JobUnitID=66; CreatedBy=melissam; CreatedDate=04/15/2020 01:57:00; ModifiedBy=sammym; ModifiedDate=09/15/2020 14:45:08; trgFMS_JOB_TICKET=False; EmpID=E***36; Downloaded=False; StdTerms={\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1033{\fonttb...; AcceptTerms=False; WorkThruLunch=False; Invoiced=True; MarkedInvoice=True; TicketType=Operator; Approved=False; ETicketStatus=0; Viewed=False; SubContractor=False; PostedToGeoTab=False; ReqSignatureOnTickets=True; _SourceExtractedAtUTC=01/22/2026 23:07:31; _LoadedAtUTC=01/22/2026 23:07:31
- **row 2:** JobTicketID=25; JobCode=OM30034; TicketDate=05/11/2020 00:00:00; GroupNumb=00; EstStartTime=05/07/2020 08:00:00; EstEndTime=05/07/2020 16:30:00; JobTicketStatus=T; CustCode=AIR067; CreatedBy=tharmeyer; CreatedDate=05/11/2020 18:19:07; ModifiedBy=sammym; ModifiedDate=09/15/2020 14:45:08; trgFMS_JOB_TICKET=False; EmpID=E***18; Downloaded=False; StdTerms={\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1033{\fonttb...; AcceptTerms=False; WorkThruLunch=False; Invoiced=True; MarkedInvoice=True; TicketType=LEM; Approved=False; ETicketStatus=0; Viewed=True; SubContractor=False; PostedToGeoTab=False; ReqSignatureOnTickets=True; _SourceExtractedAtUTC=01/22/2026 23:07:31; _LoadedAtUTC=01/22/2026 23:07:31
- **row 3:** JobTicketID=26; JobCode=TEST; TicketDate=06/09/2020 00:00:00; GroupNumb=00; EstStartTime=05/26/2020 11:00:00; EstEndTime=05/26/2020 16:30:00; ActStartTime=06/09/2020 12:15:00; JobTicketStatus=S; CustCode=100001; CreatedBy=melissam; CreatedDate=06/09/2020 14:48:16; ModifiedBy=sammym; ModifiedDate=09/15/2020 14:45:08; trgFMS_JOB_TICKET=False; SignatureIn=137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 4 128 0 0 ...; EmpID=E***27; SignatureInName=m***; Downloaded=True; StdTerms={\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1033{\fonttb...; YardOutTime=06/09/2020 11:58:00; ArrivedJob=06/09/2020 12:15:00; AcceptTerms=True; WorkThruLunch=False; Invoiced=True; MarkedInvoice=True; TicketType=LEM; Approved=False; SignatureInTime=06/09/2020 12:17:00; ETicketStatus=0; TimeStart=06/09/2020 11:58:00; Viewed=True; SubContractor=False; ActStartTimeUTC=06/09/2020 19:15:00; TimeStartUTC=06/09/2020 18:58:00; YardOutTimeUTC=06/09/2020 18:58:00; SignatureInTimeUTC=06/09/2020 19:17:00; ArrivedJobUTC=06/09/2020 19:15:00; ActStartTimeTZ=PDT; TimeStartTZ=PDT; YardOutTimeTZ=PDT; SignatureInTimeTZ=PDT; ArrivedJobTZ=PDT; YardOutTimeOrig=06/09/2020 11:58:00; YardOutTimeTZOrig=PDT; YardOutTimeUTCOrig=06/09/2020 18:58:00; TimeStartOrig=06/09/2020 11:58:00; TimeStartTZOrig=PDT; TimeStartUTCOrig=06/09/2020 18:58:00; ArrivedJobOrig=06/09/2020 12:15:00; ArrivedJobTZOrig=PDT; ArrivedJobUTCOrig=06/09/2020 19:15:00; PostedToGeoTab=False; ReqSignatureOnTickets=True; _SourceExtractedAtUTC=01/22/2026 23:07:31; _LoadedAtUTC=01/22/2026 23:07:31

## src.FMS_JOB_TYPES_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_JOB_TYPES]`

Row count: **11**. Columns (10):

`JobTypeCode String, Description String, Status Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_JOB_TYPES Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** JobTypeCode=B; Description=Bare; Status=True; CreatedBy=SA; CreatedDate=04/09/2019 10:22:44; ModifiedBy=melissam; ModifiedDate=04/03/2021 15:17:12; trgFMS_JOB_TYPES=False; _SourceExtractedAtUTC=06/23/2026 08:01:58; _LoadedAtUTC=06/23/2026 08:01:58
- **row 2:** JobTypeCode=C; Description=Contract; Status=False; CreatedBy=SA; CreatedDate=04/09/2019 10:22:44; ModifiedBy=tharmeyer; ModifiedDate=05/11/2020 17:35:45; trgFMS_JOB_TYPES=False; _SourceExtractedAtUTC=06/23/2026 08:01:58; _LoadedAtUTC=06/23/2026 08:01:58
- **row 3:** JobTypeCode=H; Description=Hourly; Status=True; CreatedBy=SA; CreatedDate=04/09/2019 10:22:44; ModifiedBy=SA; ModifiedDate=04/09/2019 10:22:44; trgFMS_JOB_TYPES=False; _SourceExtractedAtUTC=06/23/2026 08:01:58; _LoadedAtUTC=06/23/2026 08:01:58

## src.FMS_JOB_UNIT_CHECK_LIST_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_JOB_UNIT_CHECK_LIST]`

Row count: **4132600**. Columns (35):

`JobUnitCheckListID Int32, JobTicketID Int32, JobCode String, UnitCode String, CheckList String, LineNumb Int16, Type String, Checked Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, NotApplicable Boolean, CheckedBy String, JobLemID Int32, CheckListID Int32, Sections String, SortNumb Int32, JobOrUnit String, Deficiency Boolean, ConvertedWoCode String, AssignedActivity String, DeficiencyCode String, NoRepair Boolean, RepairCheckedBy String, RepairCheckedDate DateTime, OpenActivityCode String, RepairUnCheckedBy String, RepairUnCheckedDate DateTime, DeficiencyReportedDate DateTime, RequireComments Boolean, ComponentCode String, ResourceCheckListAssignID Int32, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** JobUnitCheckListID=111; JobTicketID=21; JobCode=OM30033; UnitCode=9001; CheckList=Pre Trip Inspection; LineNumb=1; Type=C; Checked=False; CreatedBy=melissam; CreatedDate=04/15/2020 01:57:00; ModifiedBy=melissam; ModifiedDate=04/15/2020 01:57:00; NotApplicable=False; CheckListID=2; Sections=BLY; SortNumb=1; JobOrUnit=J; Deficiency=False; NoRepair=False; DeficiencyReportedDate=04/15/2020 00:00:00; RequireComments=False; _SourceExtractedAtUTC=01/23/2026 01:19:01; _LoadedAtUTC=01/23/2026 01:19:01
- **row 2:** JobUnitCheckListID=112; JobTicketID=21; JobCode=OM30033; UnitCode=9001; CheckList=Pre Trip Inspection; LineNumb=2; Type=C; Checked=False; CreatedBy=melissam; CreatedDate=04/15/2020 01:57:00; ModifiedBy=melissam; ModifiedDate=04/15/2020 01:57:00; NotApplicable=False; CheckListID=2; Sections=BLY; SortNumb=1; JobOrUnit=J; Deficiency=False; NoRepair=False; DeficiencyReportedDate=04/15/2020 00:00:00; RequireComments=False; _SourceExtractedAtUTC=01/23/2026 01:19:01; _LoadedAtUTC=01/23/2026 01:19:01
- **row 3:** JobUnitCheckListID=113; JobTicketID=21; JobCode=OM30033; UnitCode=9001; CheckList=Pre Trip Inspection; LineNumb=3; Type=C; Checked=False; CreatedBy=melissam; CreatedDate=04/15/2020 01:57:00; ModifiedBy=melissam; ModifiedDate=04/15/2020 01:57:00; NotApplicable=False; CheckListID=2; Sections=BLY; SortNumb=1; JobOrUnit=J; Deficiency=False; NoRepair=False; DeficiencyReportedDate=04/15/2020 00:00:00; RequireComments=False; _SourceExtractedAtUTC=01/23/2026 01:19:01; _LoadedAtUTC=01/23/2026 01:19:01

## src.FMS_JOB_UNITS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_JOB_UNITS]`

Row count: **76312**. Columns (64):

`JobUnitID Int32, JobCode String, UnitTypeID Int32, UnitCode String, UnitSchedType String, EmpID String, DateStart DateTime, DateEnd DateTime, TimeStart DateTime, TimeEnd DateTime, Comments String, TiedUnitCode String, LineNumb Int16, PickedUp Boolean, DailyRate Decimal, WeeklyRate Decimal, MonthlyRate Decimal, OneTimeRate Decimal, DefaultBill String, PickupRate Decimal, DeliveryRate Decimal, HourlyRate Decimal, PermitIn Decimal, PermitOut Decimal, OperOrBare String, GroupNumb String, Reoccur Boolean, ReoccurEvery Decimal, TimePeriod String, ExpireType String, ExpirationDate DateTime, ExpirationNumber Int32, NextReoccurDate DateTime, ReturnDestination Boolean, TerminationCode String, JobUnitStatus String, JobUnitTag Int32, ConfigType String, UnitOutDate DateTime, UnitOutTime DateTime, UnitInDate DateTime, UnitInTime DateTime, InsuranceAmt Decimal, InsuranceEndDate DateTime, InsurancePolicyNo String, GLExpDate DateTime, GLPolicyNo String, ReturnToYard String, BillOfLadingNo String, LoadNo String, IsCollateral Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, UnitDownCode String, EmpIDOiler String, UnitHookReady DateTime, AssociatedFlag Boolean, JobEmpID Int32, IsLegacy Boolean, WoCode String, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** JobUnitID=66; JobCode=OM30033; UnitTypeID=6; UnitCode=9001; UnitSchedType=C; EmpID=E***36; DateStart=04/15/2020 00:00:00; DateEnd=04/15/2020 00:00:00; TimeStart=04/14/2020 08:00:00; TimeEnd=04/14/2020 16:30:00; LineNumb=1; PickedUp=False; GroupNumb=00; JobUnitStatus=T; IsCollateral=False; CreatedBy=melissam; CreatedDate=04/15/2020 01:55:33; ModifiedBy=melissam; ModifiedDate=04/15/2020 01:55:33; AssociatedFlag=False; IsLegacy=True; _SourceExtractedAtUTC=06/23/2026 08:02:01; _LoadedAtUTC=06/23/2026 08:02:43
- **row 2:** JobUnitID=67; JobCode=OM30033; UnitTypeID=10; UnitCode=AT02; UnitSchedType=TR; DateStart=04/15/2020 00:00:00; DateEnd=04/15/2020 00:00:00; TimeStart=04/14/2020 08:00:00; TimeEnd=04/14/2020 16:30:00; LineNumb=2; PickedUp=False; GroupNumb=00; JobUnitStatus=T; IsCollateral=False; CreatedBy=melissam; CreatedDate=04/15/2020 01:55:33; ModifiedBy=melissam; ModifiedDate=04/15/2020 01:55:33; AssociatedFlag=False; IsLegacy=True; _SourceExtractedAtUTC=06/23/2026 08:02:01; _LoadedAtUTC=06/23/2026 08:02:43
- **row 3:** JobUnitID=68; JobCode=OM30033; UnitTypeID=11; UnitCode=9001 OL; UnitSchedType=R; DateStart=04/15/2020 00:00:00; DateEnd=04/15/2020 00:00:00; TimeStart=04/14/2020 08:00:00; TimeEnd=04/14/2020 16:30:00; LineNumb=3; PickedUp=False; GroupNumb=00; JobUnitStatus=T; IsCollateral=False; CreatedBy=melissam; CreatedDate=04/15/2020 01:55:33; ModifiedBy=jstricker; ModifiedDate=10/13/2025 09:18:51; AssociatedFlag=False; IsLegacy=True; _SourceExtractedAtUTC=06/23/2026 08:02:01; _LoadedAtUTC=06/23/2026 08:02:43

## src.FMS_LABOR_PAYROLL_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_LABOR_PAYROLL]`

Row count: **86728**. Columns (84):

`LaborPayrollID Int32, EmpID String, WorkDate DateTime, UnionCode String, CraftCode String, CustUnitCode String, WorkedHrs Decimal, Rate Decimal, Amount Decimal, JobCode String, WoCode String, JobLineItemID Int32, WoDetailID Int32, UnitCode String, ActivityCode String, WorkerCompCode String, BurdenCode String, StateTaxCode String, CityTaxCode String, SutaState String, ClassCode String, WcAmt Decimal, BurdenAmt Decimal, UnionAmt Decimal, EmpUnionDed Decimal, EmpVacDed Decimal, EmpUnionEarn Decimal, EmpVacEarn Decimal, CertPay Boolean, GLAcctCode String, GroupNumb String, PayrollDept String, PayrollJobTitle String, PayBegDate DateTime, PayEndDate DateTime, LaborTransID Int32, QtyToBill Decimal, RateToBill Decimal, ExpAcct Boolean, CheckDate DateTime, CraftModifierCode String, ShiftInfo String, UnionCraftModifierID Int32, UnionApprenticePerc Decimal, ScreenID String, Processed Boolean, CheckedBy Int32, UnitActivityID Int32, Approval Boolean, ApprovalBy String, ApprovalDate DateTime, JobTicketID Int32, DeptCode String, TimeStart DateTime, TimeEnd DateTime, StdJobTicketHours Boolean, WorkThruLunch Boolean, Billable Boolean, NotifyQtyChg Boolean, NotifyRateChg Boolean, NotifyCommentsChg Boolean, NotifyCraftChg Boolean, NotifyCraftModifierChg Boolean, NotifyShiftInfoChg Boolean, NotifyNewRow Boolean, Perdiem Decimal, ProcessedDate DateTime, TimeStartUTC DateTime, TimeEndUTC DateTime, TimeStartTZ String, TimeEndTZ String, AtomLabor Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, OCIP Boolean, SubClassCode String, ComponentCode String, JobEmpID Int32, ProjectCostCode String, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime, Comments String`

Sample rows (masked):

- **row 1:** LaborPayrollID=24; EmpID=E***79; WorkDate=07/06/2020 00:00:00; UnionCode=L12; CraftCode=L12-G3-A; WorkedHrs=3.00; Rate=50.520; Amount=151.560; JobCode=OM30097; UnitCode=2201; WorkerCompCode=OPERATOR RATE; WcAmt=0.000000; BurdenAmt=0.000; UnionAmt=0.000; EmpUnionDed=0.000; EmpVacDed=0.000; EmpUnionEarn=0.000; EmpVacEarn=0.000; CertPay=True; GroupNumb=00; ExpAcct=False; ShiftInfo=0; UnionApprenticePerc=0.00; Processed=False; Approval=False; JobTicketID=29; TimeStart=07/06/2020 09:30:00; TimeEnd=07/06/2020 12:30:00; StdJobTicketHours=False; WorkThruLunch=False; Billable=True; NotifyQtyChg=False; NotifyRateChg=False; NotifyCommentsChg=False; NotifyCraftChg=False; NotifyCraftModifierChg=False; NotifyShiftInfoChg=False; NotifyNewRow=False; Perdiem=0.00; TimeStartUTC=07/06/2020 16:30:00; TimeEndUTC=07/06/2020 19:30:00; TimeStartTZ=PDT; TimeEndTZ=PDT; AtomLabor=True; CreatedBy=tylerh; CreatedDate=07/06/2020 12:45:38; ModifiedBy=tylerh; ModifiedDate=07/06/2020 13:00:02; OCIP=False; _SourceExtractedAtUTC=01/23/2026 23:18:00; _LoadedAtUTC=01/23/2026 23:18:00
- **row 2:** LaborPayrollID=25; EmpID=E***79; WorkDate=07/06/2020 00:00:00; UnionCode=L12; CraftCode=L12-G3-A; WorkedHrs=3.00; Rate=51.270; Amount=153.810; JobCode=OM30097; UnitCode=2201; WorkerCompCode=OPERATOR RATE; WcAmt=0.000000; BurdenAmt=0.000; UnionAmt=0.000; EmpUnionDed=0.000; EmpVacDed=0.000; EmpUnionEarn=0.000; EmpVacEarn=0.000; CertPay=True; GroupNumb=00; ExpAcct=False; CraftModifierCode=OP-BP-01; ShiftInfo=0; UnionApprenticePerc=0.00; Processed=False; Approval=False; JobTicketID=29; TimeStart=07/06/2020 09:30:00; TimeEnd=07/09/2020 15:00:00; StdJobTicketHours=True; WorkThruLunch=False; Billable=True; NotifyQtyChg=False; NotifyRateChg=False; NotifyCommentsChg=False; NotifyCraftChg=False; NotifyCraftModifierChg=False; NotifyShiftInfoChg=False; NotifyNewRow=False; Perdiem=0.00; TimeStartUTC=07/06/2020 16:30:00; TimeEndUTC=07/09/2020 22:00:00; TimeStartTZ=PDT; TimeEndTZ=PDT; AtomLabor=True; CreatedBy=tylerh; CreatedDate=07/06/2020 12:45:39; ModifiedBy=bpetros; ModifiedDate=07/23/2025 03:48:40; OCIP=False; _SourceExtractedAtUTC=01/23/2026 23:18:00; _LoadedAtUTC=01/23/2026 23:18:00
- **row 3:** LaborPayrollID=26; EmpID=E***79; WorkDate=07/06/2020 00:00:00; UnionCode=L12; CraftCode=L12-G3-A; WorkedHrs=6.00; Rate=58.770; Amount=352.620; JobCode=OM30124; UnitCode=26503; WorkerCompCode=OPERATOR RATE; WcAmt=0.000000; BurdenAmt=0.000; UnionAmt=0.000; EmpUnionDed=0.000; EmpVacDed=0.000; EmpUnionEarn=0.000; EmpVacEarn=0.000; CertPay=True; GroupNumb=00; ExpAcct=False; CraftModifierCode=OP-BP-11; ShiftInfo=0; UnionApprenticePerc=0.00; Processed=False; Approval=False; JobTicketID=34; TimeStart=07/09/2020 09:30:00; TimeEnd=07/09/2020 15:30:00; StdJobTicketHours=True; WorkThruLunch=False; Billable=True; NotifyQtyChg=False; NotifyRateChg=False; NotifyCommentsChg=False; NotifyCraftChg=False; NotifyCraftModifierChg=False; NotifyShiftInfoChg=False; NotifyNewRow=False; Perdiem=0.00; TimeStartUTC=07/09/2020 16:30:00; TimeEndUTC=07/09/2020 22:30:00; TimeStartTZ=PDT; TimeEndTZ=PDT; AtomLabor=True; CreatedBy=tylerh; CreatedDate=07/09/2020 12:46:19; ModifiedBy=tylerh; ModifiedDate=07/09/2020 18:50:00; OCIP=False; _SourceExtractedAtUTC=01/23/2026 23:18:00; _LoadedAtUTC=01/23/2026 23:18:00

## src.FMS_RESOURCE_CHECKLIST_ADHOC_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_RESOURCE_CHECKLIST_ADHOC]`

Row count: **1237**. Columns (17):

`ResourceCheckListAdhocID Int32, ComponentCode String, ResourceCheckListID Int32, Name String, SignatureRequired Boolean, Status String, CompletedDate DateTime, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, TransactionCode String, UnitCode String, UnitCheckListID Int32, JobTicketID Int32, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** ResourceCheckListAdhocID=1; ResourceCheckListID=1; Name=W***; SignatureRequired=True; CreatedBy=garrettm; CreatedDate=10/02/2025 19:57:33; ModifiedBy=garrettm; ModifiedDate=10/02/2025 19:57:33; JobTicketID=37654; _SourceExtractedAtUTC=06/23/2026 08:02:45; _LoadedAtUTC=06/23/2026 08:02:45
- **row 2:** ResourceCheckListAdhocID=2; ResourceCheckListID=1; Name=W***; SignatureRequired=True; CreatedBy=garrettm; CreatedDate=10/02/2025 19:58:23; ModifiedBy=garrettm; ModifiedDate=10/02/2025 19:58:23; JobTicketID=37654; _SourceExtractedAtUTC=06/23/2026 08:02:45; _LoadedAtUTC=06/23/2026 08:02:45
- **row 3:** ResourceCheckListAdhocID=3; ResourceCheckListID=1; Name=W***; SignatureRequired=True; CreatedBy=garrettm; CreatedDate=10/02/2025 20:02:23; ModifiedBy=garrettm; ModifiedDate=10/02/2025 20:02:23; JobTicketID=37654; _SourceExtractedAtUTC=06/23/2026 08:02:45; _LoadedAtUTC=06/23/2026 08:02:45

## src.FMS_SALES_PERSON_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_SALES_PERSON]`

Row count: **32**. Columns (23):

`SpersonCode String, LName String, FName String, MName String, Phone String, Fax String, Email String, Status Boolean, GroupNumb String, UserID Int32, ConvertToJob Boolean, ViewRestriction Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_SALES_PERSON Boolean, SalesForceID String, Title String, EmpID String, ExpAcct Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** SpersonCode=0258; LName=L***; FName=L***; Phone=***masked***; Fax=***masked***; Email=***masked***; Status=True; GroupNumb=00; ConvertToJob=True; ViewRestriction=True; CreatedBy=melissam; CreatedDate=09/14/2019 20:40:00; ModifiedBy=bpetros; ModifiedDate=04/15/2026 04:39:57; trgFMS_SALES_PERSON=False; ExpAcct=True; _SourceExtractedAtUTC=06/23/2026 08:02:46; _LoadedAtUTC=06/23/2026 08:02:46
- **row 2:** SpersonCode=1017; LName=C***; FName=B***; Phone=***masked***; Email=***masked***; Status=True; GroupNumb=00; ConvertToJob=True; ViewRestriction=True; CreatedBy=joes; CreatedDate=09/11/2024 15:05:11; ModifiedBy=bpetros; ModifiedDate=04/15/2026 04:06:58; trgFMS_SALES_PERSON=False; ExpAcct=True; _SourceExtractedAtUTC=06/23/2026 08:02:46; _LoadedAtUTC=06/23/2026 08:02:46
- **row 3:** SpersonCode=1252; LName=L***; FName=R***; Phone=***masked***; Fax=***masked***; Email=***masked***; Status=False; GroupNumb=00; ConvertToJob=True; ViewRestriction=True; CreatedBy=mbsi; CreatedDate=09/11/2019 16:58:06; ModifiedBy=bpetros; ModifiedDate=04/15/2026 04:46:47; trgFMS_SALES_PERSON=False; ExpAcct=True; _SourceExtractedAtUTC=06/23/2026 08:02:46; _LoadedAtUTC=06/23/2026 08:02:46

## src.FMS_SCHEDULE_TYPES_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_SCHEDULE_TYPES]`

Row count: **25**. Columns (14):

`UnitSchedCode String, Description String, Status Boolean, TiedTo String, Schedules Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_SCHEDULE_TYPES Boolean, SageEquipType String, UnitOrComponent String, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** UnitSchedCode=B; Description=Bare Rental; Status=True; Schedules=True; CreatedBy=melissam; CreatedDate=04/03/2021 15:19:07; ModifiedBy=melissam; ModifiedDate=04/03/2021 15:19:07; trgFMS_SCHEDULE_TYPES=False; UnitOrComponent=U; _SourceExtractedAtUTC=06/23/2026 08:02:46; _LoadedAtUTC=06/23/2026 08:02:46
- **row 2:** UnitSchedCode=C; Description=Crane; Status=False; Schedules=True; CreatedBy=SA; CreatedDate=04/09/2019 10:22:44; ModifiedBy=tharmeyer; ModifiedDate=05/07/2020 17:00:31; trgFMS_SCHEDULE_TYPES=False; UnitOrComponent=U; _SourceExtractedAtUTC=06/23/2026 08:02:46; _LoadedAtUTC=06/23/2026 08:02:46
- **row 3:** UnitSchedCode=CR; Description=Crawler Crane; Status=True; Schedules=True; CreatedBy=joes; CreatedDate=11/03/2022 19:11:35; ModifiedBy=joes; ModifiedDate=11/03/2022 19:11:35; trgFMS_SCHEDULE_TYPES=False; UnitOrComponent=U; _SourceExtractedAtUTC=06/23/2026 08:02:46; _LoadedAtUTC=06/23/2026 08:02:46

## src.FMS_TERMS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_TERMS]`

Row count: **12**. Columns (18):

`TermID Int32, TermName String, DaysDiscount Int16, DateDiscount Int16, DayDue Int16, DateDue Int16, DiscPer Decimal, AcctTermsCode String, Status Boolean, ShowTerms Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_TERMS Boolean, EOM Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** TermID=0; TermName=C***; Status=True; ShowTerms=False; CreatedBy=SA; CreatedDate=04/09/2019 10:22:44; ModifiedBy=SA; ModifiedDate=04/09/2019 10:22:44; trgFMS_TERMS=False; EOM=False; _SourceExtractedAtUTC=06/23/2026 08:02:47; _LoadedAtUTC=06/23/2026 08:02:47
- **row 2:** TermID=1; TermName=C***; Status=True; ShowTerms=False; CreatedBy=SA; CreatedDate=04/09/2019 10:22:44; ModifiedBy=SA; ModifiedDate=04/09/2019 10:22:44; trgFMS_TERMS=False; EOM=False; _SourceExtractedAtUTC=06/23/2026 08:02:47; _LoadedAtUTC=06/23/2026 08:02:47
- **row 3:** TermID=2; TermName=H***; Status=True; ShowTerms=False; CreatedBy=SA; CreatedDate=04/09/2019 10:22:44; ModifiedBy=SA; ModifiedDate=04/09/2019 10:22:44; trgFMS_TERMS=False; EOM=False; _SourceExtractedAtUTC=06/23/2026 08:02:47; _LoadedAtUTC=06/23/2026 08:02:47

## src.FMS_TICKET_SECTIONS_SUBLIST_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_TICKET_SECTIONS_SUBLIST]`

Row count: **21**. Columns (10):

`TicketSectionSubListID Int32, TicketSectionListID Int32, SubSectionName String, LineNumb Int32, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** TicketSectionSubListID=1; TicketSectionListID=3; SubSectionName=J***; LineNumb=1; CreatedBy=sa; CreatedDate=04/09/2019 10:37:24; ModifiedBy=sa; ModifiedDate=04/09/2019 10:37:24; _SourceExtractedAtUTC=06/23/2026 08:02:48; _LoadedAtUTC=06/23/2026 08:02:48
- **row 2:** TicketSectionSubListID=2; TicketSectionListID=3; SubSectionName=R***; LineNumb=2; CreatedBy=sa; CreatedDate=04/09/2019 10:37:24; ModifiedBy=sa; ModifiedDate=04/09/2019 10:37:24; _SourceExtractedAtUTC=06/23/2026 08:02:48; _LoadedAtUTC=06/23/2026 08:02:48
- **row 3:** TicketSectionSubListID=3; TicketSectionListID=3; SubSectionName=C***; LineNumb=3; CreatedBy=sa; CreatedDate=04/09/2019 10:37:24; ModifiedBy=sa; ModifiedDate=04/09/2019 10:37:24; _SourceExtractedAtUTC=06/23/2026 08:02:48; _LoadedAtUTC=06/23/2026 08:02:48

## src.FMS_TICKET_STATUS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_TICKET_STATUS]`

Row count: **53**. Columns (15):

`TicketStatusCode String, TicketType String, Viewed Boolean, Download Boolean, EnableWT Boolean, TimeStart Boolean, TimeEnd Boolean, Description String, Comments String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** TicketStatusCode=T; TicketType=Operator; Viewed=False; Download=False; EnableWT=False; TimeStart=False; TimeEnd=False; Description=Sent; Comments=Viewed=0, Download=0; CreatedBy=sa; CreatedDate=01/31/2022 21:45:31; ModifiedBy=sa; ModifiedDate=01/31/2022 21:45:31; _SourceExtractedAtUTC=06/23/2026 08:02:48; _LoadedAtUTC=06/23/2026 08:02:48
- **row 2:** TicketStatusCode=T; TicketType=Operator; Viewed=True; Download=False; EnableWT=False; TimeStart=False; TimeEnd=False; Description=Viewed; Comments=Viewed=1, Download=0; CreatedBy=sa; CreatedDate=01/31/2022 21:45:31; ModifiedBy=sa; ModifiedDate=01/31/2022 21:45:31; _SourceExtractedAtUTC=06/23/2026 08:02:48; _LoadedAtUTC=06/23/2026 08:02:48
- **row 3:** TicketStatusCode=T; TicketType=Operator; Viewed=True; Download=True; EnableWT=False; TimeStart=False; TimeEnd=False; Description=Downloaded; Comments=Viewed=1 Download =1; CreatedBy=sa; CreatedDate=01/31/2022 21:45:31; ModifiedBy=sa; ModifiedDate=01/31/2022 21:45:31; _SourceExtractedAtUTC=06/23/2026 08:02:48; _LoadedAtUTC=06/23/2026 08:02:48

## src.FMS_UNION_CRAFT_MODIFIER_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_UNION_CRAFT_MODIFIER]`

Row count: **52**. Columns (15):

`UnionCraftModifierID Int32, UnionCode String, CraftModifierCode String, PayRateChange Decimal, PayRateChangeOT Decimal, PayRateChangeDB Decimal, Status Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, StartDate DateTime, EndDate DateTime, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** UnionCraftModifierID=1; UnionCode=L12; CraftModifierCode=OP-BP-01; PayRateChange=0.750; PayRateChangeOT=1.125; PayRateChangeDB=1.500; Status=True; CreatedBy=melissam; CreatedDate=04/10/2020 01:11:58; ModifiedBy=bpetros; ModifiedDate=07/23/2025 03:48:40; StartDate=04/10/2020 00:00:00; _SourceExtractedAtUTC=06/23/2026 08:02:50; _LoadedAtUTC=06/23/2026 08:02:50
- **row 2:** UnionCraftModifierID=2; UnionCode=L12; CraftModifierCode=OP-BP-02; PayRateChange=1.500; PayRateChangeOT=2.250; PayRateChangeDB=3.000; Status=True; CreatedBy=melissam; CreatedDate=04/10/2020 01:11:58; ModifiedBy=bpetros; ModifiedDate=07/23/2025 03:48:41; StartDate=04/10/2020 00:00:00; _SourceExtractedAtUTC=06/23/2026 08:02:50; _LoadedAtUTC=06/23/2026 08:02:50
- **row 3:** UnionCraftModifierID=3; UnionCode=L12; CraftModifierCode=OP-BP-03; PayRateChange=2.250; PayRateChangeOT=3.375; PayRateChangeDB=4.500; Status=True; CreatedBy=melissam; CreatedDate=04/14/2020 19:06:31; ModifiedBy=bpetros; ModifiedDate=07/23/2025 03:48:41; StartDate=04/14/2020 00:00:00; _SourceExtractedAtUTC=06/23/2026 08:02:50; _LoadedAtUTC=06/23/2026 08:02:50

## src.FMS_UNION_CRAFT_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_UNION_CRAFT]`

Row count: **53**. Columns (14):

`UnioncraftID Int32, UnionCode String, CraftCode String, PayRate Decimal, BillingRate Decimal, Comments String, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, StartDate DateTime, EndDate DateTime, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** UnioncraftID=4; UnionCode=L12; CraftCode=L12-G2-A; PayRate=66.180; BillingRate=0.000; CreatedBy=melissam; CreatedDate=04/09/2020 18:22:57; ModifiedBy=corrinab; ModifiedDate=08/26/2025 21:23:13; StartDate=04/09/2020 00:00:00; _SourceExtractedAtUTC=06/23/2026 08:02:49; _LoadedAtUTC=06/23/2026 08:02:49
- **row 2:** UnioncraftID=5; UnionCode=L12; CraftCode=L12-G2-B; PayRate=99.270; BillingRate=0.000; CreatedBy=melissam; CreatedDate=04/09/2020 18:22:57; ModifiedBy=corrinab; ModifiedDate=08/26/2025 21:23:13; StartDate=04/09/2020 00:00:00; _SourceExtractedAtUTC=06/23/2026 08:02:49; _LoadedAtUTC=06/23/2026 08:02:49
- **row 3:** UnioncraftID=6; UnionCode=L12; CraftCode=L12-G2-C; PayRate=132.360; BillingRate=0.000; CreatedBy=melissam; CreatedDate=04/09/2020 18:22:57; ModifiedBy=corrinab; ModifiedDate=08/26/2025 21:23:13; StartDate=04/09/2020 00:00:00; _SourceExtractedAtUTC=06/23/2026 08:02:49; _LoadedAtUTC=06/23/2026 08:02:49

## src.FMS_UNIT_CHECK_LIST_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_UNIT_CHECK_LIST]`

Row count: **14**. Columns (10):

`UnitCheckListID Int32, CheckList String, Status Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, EligibleToEmail Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** UnitCheckListID=1; CheckList=Pre-Trip Inspection; Status=False; CreatedBy=mbsi; CreatedDate=09/25/2019 12:45:04; ModifiedBy=mbsi; ModifiedDate=04/22/2020 09:05:59; EligibleToEmail=***masked***; _SourceExtractedAtUTC=06/23/2026 08:02:50; _LoadedAtUTC=06/23/2026 08:02:50
- **row 2:** UnitCheckListID=2; CheckList=Post-Trip Inspection; Status=True; CreatedBy=mbsi; CreatedDate=09/25/2019 12:45:04; ModifiedBy=mbsi; ModifiedDate=03/09/2023 13:50:56; EligibleToEmail=***masked***; _SourceExtractedAtUTC=06/23/2026 08:02:50; _LoadedAtUTC=06/23/2026 08:02:50
- **row 3:** UnitCheckListID=3; CheckList=Crane Pre-Trip Inspection; Status=True; CreatedBy=melissam; CreatedDate=04/22/2020 09:11:01; ModifiedBy=melissam; ModifiedDate=04/22/2020 09:11:01; EligibleToEmail=***masked***; _SourceExtractedAtUTC=06/23/2026 08:02:50; _LoadedAtUTC=06/23/2026 08:02:50

## src.FMS_UNIT_TYPE_DETAILS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_UNIT_TYPE_DETAILS]`

Row count: **563**. Columns (13):

`UnitTypeDtlID Int32, UnitCode String, UnitTypeID Int32, UnitSchedCode String, PrimaryType Boolean, Status Boolean, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_UNIT_TYPE_DETAILS Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** UnitTypeDtlID=1; UnitCode=14001 OL; UnitTypeID=31; UnitSchedCode=R; PrimaryType=True; Status=True; CreatedBy=mbsi; CreatedDate=07/03/2019 14:16:29; ModifiedBy=jstricker; ModifiedDate=10/13/2025 09:58:50; trgFMS_UNIT_TYPE_DETAILS=False; _SourceExtractedAtUTC=06/23/2026 08:02:51; _LoadedAtUTC=06/23/2026 08:02:51
- **row 2:** UnitTypeDtlID=7; UnitCode=14001; UnitTypeID=8; UnitSchedCode=C; PrimaryType=False; Status=False; CreatedBy=mbsi; CreatedDate=07/03/2019 14:19:26; ModifiedBy=melissam; ModifiedDate=04/04/2020 16:46:43; trgFMS_UNIT_TYPE_DETAILS=False; _SourceExtractedAtUTC=06/23/2026 08:02:51; _LoadedAtUTC=06/23/2026 08:02:51
- **row 3:** UnitTypeDtlID=8; UnitCode=14002; UnitTypeID=8; UnitSchedCode=C; PrimaryType=False; Status=False; CreatedBy=melissam; CreatedDate=07/05/2019 14:49:24; ModifiedBy=melissam; ModifiedDate=04/04/2020 16:46:43; trgFMS_UNIT_TYPE_DETAILS=False; _SourceExtractedAtUTC=06/23/2026 08:02:51; _LoadedAtUTC=06/23/2026 08:02:51

## src.FMS_UNIT_TYPES_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_UNIT_TYPES]`

Row count: **71**. Columns (17):

`UnitTypeID Int32, Description String, TargetMonthHrs Int32, UnitSchedType String, Status Boolean, AdditionalInfo String, PeakHours Int32, NonPeakHours Int32, TransportClass Byte, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, TrackUnit Boolean, SortNumb Int64, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** UnitTypeID=1; Description=118' Crane; TargetMonthHrs=80; UnitSchedType=MC; Status=False; CreatedBy=sa; CreatedDate=04/09/2019 10:22:44; ModifiedBy=melissam; ModifiedDate=07/01/2021 14:00:12; TrackUnit=True; SortNumb=118; _SourceExtractedAtUTC=06/23/2026 08:02:52; _LoadedAtUTC=06/23/2026 08:02:52
- **row 2:** UnitTypeID=3; Description=40 Ton; TargetMonthHrs=160; UnitSchedType=MC; Status=True; CreatedBy=sa; CreatedDate=04/09/2019 10:22:44; ModifiedBy=joes; ModifiedDate=08/12/2022 14:37:11; TrackUnit=True; SortNumb=40; _SourceExtractedAtUTC=06/23/2026 08:02:52; _LoadedAtUTC=06/23/2026 08:02:52
- **row 3:** UnitTypeID=4; Description=60 Ton Hydraulic Truck Crane; TargetMonthHrs=160; UnitSchedType=MC; Status=True; CreatedBy=mbsi; CreatedDate=07/03/2019 12:10:07; ModifiedBy=melissam; ModifiedDate=08/25/2021 17:23:18; TrackUnit=True; SortNumb=60; _SourceExtractedAtUTC=06/23/2026 08:02:52; _LoadedAtUTC=06/23/2026 08:02:52

## src.FMS_UNITS_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_UNITS]`

Row count: **356**. Columns (158):

`UnitCode String, UnitName String, DeptCode String, CompanyCode String, YardCode String, UnitSchedType String, UnitTypeID Int32, ModelYear String, Capacity Decimal, VehicleMake String, VehicleModel String, UpEngMake String, UpEngModel String, LowEngMake String, LowEngModel String, TransModel String, TransMake String, Status Int32, InsuranceValue Decimal, Insured Boolean, HourUpper Double, DateHrUpper DateTime, HourLower Double, DateHrLower DateTime, MilesKM Double, DateMilesKM DateTime, License String, LicenseExpiry DateTime, SerialNumber String, TiresType String, AxleType String, FuelName String, Gvm Double, VehicleWidthFt Decimal, VehicleWidthIn Int16, VehicleHeightFt Decimal, VehicleHeightIn Int16, VehicleLengthFt Decimal, VehicleLengthIn Int16, VehicleGageFt Int16, VehicleGageIn Int16, JibLengthFt Int16, JibLengthIn Int16, BoomLength String, Comments String, FuelCapacity String, MastHeight String, LiftHeight String, FreeLift String, ForkLength String, Carriage String, Tires String, ExtCapacity String, Accessories String, Attachment String, RentalRequirement String, DatePurchased DateTime, PurchasePrice Decimal, StartHrMiles Double, NewUsed String, DateSold DateTime, SalePrice Decimal, DatePriced DateTime, SoldInfo String, HourlyCost Decimal, HourlyRate Decimal, MonthlyTarget Decimal, MonthlyPayment Decimal, GlAcctTm String, GLAcctBare String, GLAcctOper String, GLAcctDelPickup String, GLAcctPermit String, MeasureCode String, YtdSalesTax Decimal, SalesTaxLife Decimal, PercentAmount String, SplitPercentage Decimal, SplitAmount Decimal, NeedsPickUp Boolean, CheckOverlap Boolean, SpersonCode String, WarrantyExpDate DateTime, Category1 String, Category2 String, Category3 String, BarCode String, SkytelID String, HoursAdjLower Double, HoursAdjUpper Double, DepreciationValue Decimal, DepStartDate DateTime, DepNextDate DateTime, NoOfMonths Int32, ResidualValue Decimal, InsureStartDate DateTime, InsurancePeriod DateTime, ResidualInsureAmt Decimal, RedectionAmt Decimal, TransportClass Byte, HireDate DateTime, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, trgFMS_UNITS Boolean, AdditionalInfo1 String, AdditionalInfo2 String, AdditionalInfo3 String, AdditionalInfo4 String, AdditionalInfo5 String, AdditionalInfo6 String, AdditionalInfo7 String, AdditionalInfo8 String, AdditionalInfo9 String, AdditionalInfo10 String, AdditionalInfo11 String, UpperGPS String, LowerGPS String, UpperGPSID String, LowerGPSID String, CurrentValue Decimal, FuelPerc Decimal, Field1 Decimal, Field2 Decimal, Field3 String, Field4 String, Field5 String, SplInvComments Boolean, MilesOrKm String, UpperEngSerialNo String, LowerEngSerialNo String, TransSerialNo String, CurrencyCode String, YardCodePL String, HasMeterHrsUp Boolean, HasMeterHrsLo Boolean, HasOdometerMiles Boolean, OwnedOrRent String, StateCode String, RevenueAsOfDate DateTime, Revenue Decimal, LaborExpenses Decimal, PartsExpenses Decimal, VIN String, Chassis String, ManufacturerID Int32, ApplySMMTax Boolean, Date1 DateTime, Date2 DateTime, EquipmentID String, AcceleratedTaxPaid Boolean, HeavyMachinery Boolean, TerpEligible Boolean, EquipmentIDUpper String, ExpAcct Boolean, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** UnitCode=10001; UnitName=1***; DeptCode=FL; CompanyCode=CG; YardCode=MY; UnitSchedType=MC; UnitTypeID=7; ModelYear=2013; Capacity=100.00; VehicleMake=Link-Belt; VehicleModel=HTC-86100; LowEngMake=CUMMINS; LowEngModel=ISX11.9; TransModel=12-AS-2535; TransMake=ZF; Status=1; InsuranceValue=850000.000; Insured=False; HourUpper=0; HourLower=17265; DateHrLower=06/19/2026 00:00:00; MilesKM=227896; DateMilesKM=04/20/2026 00:00:00; License=***masked***; LicenseExpiry=***masked***; SerialNumber=1F9N3K330DL028774 / N3K3-3774; TiresType=445/65R22.5 -12R22.5; FuelName=D***; VehicleWidthFt=8.00; VehicleWidthIn=6; VehicleHeightFt=11.00; VehicleHeightIn=5; VehicleLengthFt=45.00; VehicleLengthIn=7; BoomLength=140; DatePurchased=08/09/2013 00:00:00; PurchasePrice=850000.000; NewUsed=U; HourlyCost=85.930; HourlyRate=450.000; MonthlyTarget=72000.000; MonthlyPayment=8000.000; MeasureCode=T ; YtdSalesTax=0.00; SalesTaxLife=0.00; PercentAmount=P; SplitPercentage=0.00; SplitAmount=0.000; NeedsPickUp=False; CheckOverlap=True; RedectionAmt=0.000; CreatedBy=mbsi; CreatedDate=07/03/2019 13:09:33; ModifiedBy=jstricker; ModifiedDate=06/19/2026 21:31:34; trgFMS_UNITS=False; LowerGPS=SA; LowerGPSID=281474982740719; CurrentValue=850000.000; SplInvComments=False; MilesOrKm=Mi; LowerEngSerialNo=75014625; TransSerialNo=00-817719; YardCodePL=MY; HasMeterHrsUp=False; HasMeterHrsLo=True; HasOdometerMiles=True; StateCode=CA; ApplySMMTax=False; AcceleratedTaxPaid=False; HeavyMachinery=False; TerpEligible=False; ExpAcct=True; _SourceExtractedAtUTC=06/23/2026 08:02:52; _LoadedAtUTC=06/23/2026 08:02:53
- **row 2:** UnitCode=10001 OL; UnitName=1***; DeptCode=FL; CompanyCode=CG; YardCode=MY; UnitSchedType=R; UnitTypeID=31; ModelYear=2018; VehicleMake=Fontaine; VehicleModel=Old Trailer # 10002.1; Status=1; Insured=False; HourUpper=0; HourLower=0; MilesKM=0; License=***masked***; SerialNumber=13N1482C9J1524205; YtdSalesTax=0.00; SalesTaxLife=0.00; PercentAmount=P; SplitPercentage=0.00; SplitAmount=0.000; NeedsPickUp=False; CheckOverlap=True; CreatedBy=mbsi; CreatedDate=07/03/2019 13:09:33; ModifiedBy=jstricker; ModifiedDate=10/13/2025 09:18:01; trgFMS_UNITS=False; SplInvComments=False; MilesOrKm=Mi; HasMeterHrsUp=False; HasMeterHrsLo=False; HasOdometerMiles=False; StateCode=CA; ApplySMMTax=False; AcceleratedTaxPaid=False; HeavyMachinery=False; TerpEligible=False; ExpAcct=True; _SourceExtractedAtUTC=06/23/2026 08:02:52; _LoadedAtUTC=06/23/2026 08:02:53
- **row 3:** UnitCode=10002; UnitName=1***; DeptCode=FL; CompanyCode=CG; YardCode=MY; UnitSchedType=MC; UnitTypeID=7; ModelYear=2014; Capacity=100.00; VehicleMake=Link-Belt; VehicleModel=HTC86100; LowEngMake=CUMMINS; LowEngModel=ISX12; TransMake=ZF; Status=1; InsuranceValue=600000.000; Insured=False; HourUpper=0; HourLower=12093; DateHrLower=06/19/2026 00:00:00; MilesKM=119876; DateMilesKM=02/19/2026 00:00:00; License=***masked***; LicenseExpiry=***masked***; SerialNumber=N3K4-4233 / 1F9N3K449EL028233; TiresType=445/65R22.5 -12R22.5; FuelName=D***; VehicleWidthFt=8.00; VehicleWidthIn=6; VehicleHeightFt=11.00; VehicleHeightIn=5; VehicleLengthFt=45.00; VehicleLengthIn=7; JibLengthFt=58; BoomLength=140; DatePurchased=02/05/2020 00:00:00; PurchasePrice=601560.000; NewUsed=U; HourlyCost=62.070; HourlyRate=450.000; MonthlyTarget=72000.000; MonthlyPayment=10978.490; MeasureCode=T ; YtdSalesTax=0.00; SalesTaxLife=0.00; PercentAmount=P; SplitPercentage=0.00; SplitAmount=0.000; NeedsPickUp=False; CheckOverlap=True; RedectionAmt=0.000; CreatedBy=melissam; CreatedDate=03/26/2020 13:43:37; ModifiedBy=jstricker; ModifiedDate=06/19/2026 21:31:07; trgFMS_UNITS=False; LowerGPS=SA; LowerGPSID=281474982740720; CurrentValue=600000.000; SplInvComments=False; MilesOrKm=Mi; LowerEngSerialNo=75025480; YardCodePL=MY; HasMeterHrsUp=False; HasMeterHrsLo=True; HasOdometerMiles=True; OwnedOrRent=Owned; StateCode=CA; ApplySMMTax=False; AcceleratedTaxPaid=False; HeavyMachinery=False; TerpEligible=False; ExpAcct=True; _SourceExtractedAtUTC=06/23/2026 08:02:52; _LoadedAtUTC=06/23/2026 08:02:53

## src.FMS_UNITTYPE_JOBTYPES_Raw

Base object: `[TCG_RawFMS].[api].[v_FMS_UNITTYPE_JOBTYPES]`

Row count: **42**. Columns (9):

`JobTypeYardID Int32, JobTypeCode String, UnitTypeID Int32, CreatedBy String, CreatedDate DateTime, ModifiedBy String, ModifiedDate DateTime, _SourceExtractedAtUTC DateTime, _LoadedAtUTC DateTime`

Sample rows (masked):

- **row 1:** JobTypeYardID=4; JobTypeCode=H; UnitTypeID=3; CreatedBy=melissam; CreatedDate=10/17/2020 19:09:01; ModifiedBy=melissam; ModifiedDate=10/17/2020 19:09:01; _SourceExtractedAtUTC=06/23/2026 08:02:53; _LoadedAtUTC=06/23/2026 08:02:53
- **row 2:** JobTypeYardID=6; JobTypeCode=Z; UnitTypeID=9; CreatedBy=melissam; CreatedDate=10/17/2020 19:16:21; ModifiedBy=melissam; ModifiedDate=10/17/2020 19:16:21; _SourceExtractedAtUTC=06/23/2026 08:02:53; _LoadedAtUTC=06/23/2026 08:02:53
- **row 3:** JobTypeYardID=7; JobTypeCode=Z; UnitTypeID=7; CreatedBy=melissam; CreatedDate=10/17/2020 19:13:17; ModifiedBy=melissam; ModifiedDate=10/17/2020 19:13:17; _SourceExtractedAtUTC=06/23/2026 08:02:53; _LoadedAtUTC=06/23/2026 08:02:53

