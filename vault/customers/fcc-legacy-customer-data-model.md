---
title: FCC (NexGen FMS) legacy customer data model — tables, columns, code lists and the ERP mapping
source: shared-folder/Project-Repository-2026-09-04/2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/ — the five CUSTOMERS export scripts under `__VS_CODE_DataMigration/SQL_FCC_CORE_TABLES/CUSTOMERS/`, the four `lkup_*.sql` pointers beside them, and the `FCC_CUSTOMERS_20260705.xlsx` extract they produced
migrated: 2026-09-04
updated: 2026-07-05
status: unverified
conflicts_with: []
jira: []
tags: [module/customers, kind/source, data-migration, architecture, reference-data, provenance]
entities: []
---

# FCC (NexGen FMS) legacy customer data model

**What this is.** The actual shape of the customer record in **FCC / NexGen FMS**, the system
TCG is migrating off. It comes from the migration workstream's own extract scripts — T-SQL that
reads `[NexGenFMS].[dbo].*` on the FCC database and writes an Excel-safe result set — plus the
workbook those scripts produced on **2026-07-02** and shipped as `FCC_CUSTOMERS_20260705.xlsx`.
The scripts are the specification of *what is being carried across*; the workbook is the data.
This page records the structure, the joins, the code lists and the row counts, and maps them onto
the ERP's own Prisma models. **No customer rows are copied here** — the workbook is 3.5 MB of
records and the ingestion rule is structure and counts only.

Nothing on this page is a product requirement. It says what the legacy system stores, not what
the ERP should do with it.

> **Bearing on the [customers-INDEX.md](customers-INDEX.md) conflict stub.** That stub is open
> partly because five vault sources use **FCC** as a system of record without saying what it is,
> and because two of them ask *"need to verify from FCC if its customer contact or seperate job
> site contact"* and the same question for certificates. This page answers the first half of that
> factually: in FCC, contacts live in one table hanging off the customer, and a job site
> (`FMS_CUSTOMER_LOCATIONS`) points **back into that same contact table** by id for its
> Ordered-By and Report-To roles — there is no separate job-site contact table. It does **not**
> answer the certificates question: no certificate table appears anywhere in this export set.
> **This is evidence, not an adjudication.** The stub's verdict is unchanged and none of these
> sources is verified.

## Where the material comes from

| Artefact | What it is |
| --- | --- |
| `FCC_CUSTOMERS.sql` | Exports `dbo.FMS_CUSTOMERS`, with salesperson / industry / terms names joined in |
| `CustomerContacts.sql` | Exports `dbo.FMS_CUSTOMER_CONTACTS` |
| `CustomerLocations.sql` | Exports `dbo.FMS_CUSTOMER_LOCATIONS` — FCC's job sites |
| `CustomerNotes.sql` | Exports `dbo.FMS_CUSTOMER_NOTES` |
| `lkup_INDUSTRIES.sql`, `lkup_TERMS.sql`, `lkup_SALES_PERSON.sql`, `lkup_PARTS_PRICE_LIST_MASTER.sql` | **One comment line each**, naming the source table (`FMS_INDUSTRIES`, `FMS_TERMS`, `FMS_SALES_PERSON`, `FMS_PARTS_PRICE_LIST_MASTER`). They contain no SQL — they are placeholders that say "this lookup comes from here". |
| `FCC_CUSTOMERS_20260705.xlsx` | 12 sheets. Four `*_SQL` sheets carry the same scripts verbatim; four data sheets carry their output; four more carry the lookup tables in full. |

The workbook is the output of exactly these scripts: each `*_SQL` sheet is a copy of the matching
`.sql` file, and each data sheet is headed `FROM [NexGenFMS].[dbo].[<table>]` and `ran: 2026-07-02`.

**Types are not in the source.** The scripts never publish a per-column data type. They branch
only on whether a column is one of six text types (`text`, `ntext`, `varchar`, `char`,
`nvarchar`, `nchar`) — those get line breaks replaced with ` | ` and tabs with a space so the
result survives Excel — and pass everything else through untouched. So a column's type can be
inferred as *text* or *not text* and no further. Lengths, nullability and defaults are unknown
from this drop.

**A per-column migration disposition exists but did not survive conversion.** Every data sheet
carries a legend — `keep` / `lookup` / `n/a` / `system` — applied to the header row as cell
**colours**. Only the `INDUSTRIES` sheet also spells the classification out in a text row
(`IndustryCode` = keep, `Name` = keep, the audit columns = system, `NetSuiteID` = n/a). For the
other sheets the disposition is colour-only and is lost in the text conversion; read the original
`.xlsx` if you need it.

## Row counts, as extracted 2026-07-02

| Table | Data rows |
| --- | --- |
| `FMS_CUSTOMERS` | 6,070 |
| `FMS_CUSTOMER_CONTACTS` | 9,587 |
| `FMS_CUSTOMER_LOCATIONS` | 26,199 |
| `FMS_CUSTOMER_NOTES` | 121 |
| `FMS_SALES_PERSON` | 33 |
| `FMS_INDUSTRIES` | 33 |
| `FMS_TERMS` | 12 |
| `FMS_PARTS_PRICE_LIST_MASTER` | 16 |

> These are **production** counts. They are not the same numbers as the first-pass seeder brief in
> [meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md),
> which reports 5,742 customers / 8,571 contacts / 23,158 job sites / 108 notes — that brief is
> explicit that it loaded from `NexGenFMS-Test`, never production. Both sets of numbers are
> internally consistent with their stated source; the ~5% gap is what you would expect between a
> test copy and the live database three months apart. The source documents do not say which
> extract the eventual production migration will use.

## The join graph

```
FMS_CUSTOMERS ──┬── FMS_CUSTOMER_CONTACTS      on (CustCode, GroupNumb)
                ├── FMS_CUSTOMER_LOCATIONS     on (CustCode, GroupNumb)
                └── FMS_CUSTOMER_NOTES         on (CustCode, GroupNumb)

FMS_CUSTOMER_LOCATIONS ──┬── FMS_CUSTOMER_CONTACTS  as OrderedByContactID
                         └── FMS_CUSTOMER_CONTACTS  as ReportedToContactID
                              both on (CustContactID, CustCode, GroupNumb)

FMS_CUSTOMERS ──┬── FMS_SALES_PERSON  on SpersonCode
                ├── FMS_INDUSTRIES    on IndustryCode
                └── FMS_TERMS         on TermID

FMS_CUSTOMER_CONTACTS ── FMS_SALES_PERSON  on SpersonCode
```

Two things in that graph are load-bearing.

**The customer key is composite: `(CustCode, GroupNumb)`.** Every child table joins on both
columns, and `FCC_CUSTOMERS.sql` orders its output by `CustCode, GroupNumb`. `GroupNumb` is
nevertheless marked *not exported* on every table that has it — so the extract carries the key's
first half only. The scripts do not say what `GroupNumb` means (company, division, ledger). In the
extracted rows it is absent from the output entirely, so this drop gives no way to tell whether
any `CustCode` is reused across groups.

**A job site's Ordered-By and Report-To are customer contacts, by id.** `FMS_CUSTOMER_LOCATIONS`
carries `OrderedByContactID` and `ReportedToContactID`, both resolved against
`FMS_CUSTOMER_CONTACTS` (and joined on the customer key as well, so a location can only point at
its own customer's contacts). The same table *also* carries free-text `OrderedBy` / `OrdByPhone` /
`ReportTo` / `ReportToPhone` / `OrderedByEmail` / `ReportToEmail` columns. Both mechanisms are
exported; the source does not say which one wins when they disagree, or whether the free-text
columns are legacy.

## `FMS_CUSTOMERS`

The script declares **100 columns** and marks each one exported or not. **37 are exported**, plus
**3 derived** name columns joined in from lookups (`SalespersonName` after `SpersonCode`,
`IndustryName` after `IndustryCode`, `TermName` after `TermID`) — 40 columns in the workbook.

**Exported**, in the script's ordinal order:

`CustCode` · `Name1` · `Name2` · `Address1` · `Address2` · `City` · `StateCode` · `Zip` ·
`Country` · `Email` · `WebSite` · `Phone` · `Fax` · `BillContact1` · `BillPhone1` ·
`BillContact2` · `BillPhone2` · `SpersonCode` · *(SalespersonName)* · `PORequire` ·
`IndustryCode` · *(IndustryName)* · `Taxable` · `StatementType` · `TermID` · *(TermName)* ·
`Status` · `Comments` · `AcctUpdated` · `AcctIntCode` · `PriceList` · `PriceExpires` ·
`ListMarkUp` · `EmailDocOK` · `CreatedBy` · `CreatedDate` · `ModifiedBy` · `ModifiedDate` ·
`ApplyEnvironmentalLevy` · `ProspectStatus`

**Present in FCC but deliberately not exported** (63 columns). Grouped by what they are:

| Group | Columns |
| --- | --- |
| Tax | `SalesTaxCode`, `TaxExempt`, `BillingTaxable`, `FederalTaxID`, `EntityUseCode`, `AvalaraSent` |
| Insurance | `Insurance`, `Expires`, `ContractNumb`, `BlanketInsuranceAmt`, `PerOccurrenceAmt` |
| Credit / AR | `CreditLimit`, `CurrentBalance`, `FinChgPercent` |
| Lease | `LeaseAgreement`, `LeaseExpire`, `LeaseNo` |
| Legal | `Legal1`…`Legal12`, `LegalDate1`…`LegalDate12` (24 columns) |
| Classification | `ClassID`, `CustTypeCode`, `ProspectCode`, `PricingMatrixCode`, `SubContractor` |
| Pricing | `PartsDisc`, `MarkUpPerc` |
| Hierarchy / linkage | `ParentCustCode`, `InterCompanyAcct`, `GroupNumb`, `HRTempID`, `TmwCityStateID`, `BillContact1ID`, `BillContact2ID` |
| Other | `LastNameFirst`, `Notes`, `POBeforeTicket`, `USDOT`, `BPay`, `DBAName`, `CountryCode`, `trgFMS_CUSTOMERS` |

**`AcctIntCode` is the QuickBooks customer id.** It is exported, and 5,681 of the 6,057 FCC rows
that carry one resolve to a `Customer ID` in TCG's QuickBooks customer table — see
[quickbooks-customer-table-audit.md](quickbooks-customer-table-audit.md), which works the join
through. The scripts do not name the column's meaning; the match is what establishes it. The ERP
has no column for it.

Three of those are worth calling out because the vault argues about them elsewhere. FCC **does**
carry `Insurance` / `Expires` / `ContractNumb` — the exact triple
[customer-and-job-sites.md](customer-and-job-sites.md) asks for ("Insurance - if checked -- show
expiry / contract number") — and the migration is choosing not to bring them. Same for
`CreditLimit`. Same for `ParentCustCode`, which is the only evidence in this drop that FCC
supports a customer hierarchy at all. The scripts give no reason for any exclusion.

### `Status` code list

Given in the script header and applied as a `CASE` in the export.

| Code | Meaning |
| --- | --- |
| `A` | Active |
| `T` | Inactive |
| `P` | Prospect |

Anything else is emitted as `Review: <value>` — the extract flags unknown codes rather than
dropping them. The same `Review:` convention is used for every coded column in this set.

Note that the FCC status set has **three** values. The `FCC_MAINTAIN_CUSTOMERS` deck TCG
reviewed asks for **four** — Active, Inactive, Prospect and **On Hold**; see
[fcc-maintain-customers-tcg-review.md](fcc-maintain-customers-tcg-review.md). `ProspectStatus` is
a separate exported column from `Status` and the source does not say how the two interact.

## `FMS_CUSTOMER_CONTACTS`

23 columns, of which 2 are derived (`CustomerName1` from the customer, `SalespersonName` from the
salesperson lookup). The script selects them explicitly rather than from a declared list, so
there is no "not exported" set for this table.

`CustContactID` (the key) · `CustCode` · *(CustomerName1)* · `ContactName` · `Position` ·
`SpersonCode` · *(SalespersonName)* · `Email` · `Phone` · `Fax` · `Mobile` · `Pager` ·
`ContactAddress` · `ContactCity` · `StateProv` · `OtherInfo` · `Status` · `ContactType` ·
`AddressSameAsCust` · `CreatedBy` · `CreatedDate` · `ModifiedBy` · `ModifiedDate`

`ContactName` is a **single field**, not first/last. `AddressSameAsCust` is a flag, so the
contact's own address block is optional and conditional. A contact carries its **own**
salesperson, independently of the customer's.

### `ContactType` code list

| Code | Meaning |
| --- | --- |
| `B` | Both |
| `N` | None |
| `O` | Ordered By |
| `R` | Report To |

This is the answer to "what kind of contact is this" in FCC: a contact is flagged as eligible to
be the Ordered-By party, the Report-To party, both, or neither. It is **not** a billing-contact
flag — billing contacts are two denormalised name/phone pairs on the customer itself
(`BillContact1`/`BillPhone1`, `BillContact2`/`BillPhone2`), with id columns
(`BillContact1ID`, `BillContact2ID`) that exist in FCC but are not exported.

## `FMS_CUSTOMER_LOCATIONS` — FCC's job sites

The script declares **48 columns**; **37 are exported**, plus 3 derived (`CustomerName1`,
`OrderedByContactName`, `ReportedToContactName`) — 40 in the workbook.

**Exported:** `CustLocationID` (the key) · `CustCode` · *(CustomerName1)* · `LocationName` ·
`Address1` · `Address2` · `City` · `StateCode` · `Zip` · `Country` · `Phone` · `AltPhone` ·
`Description` · `OrderedBy` · `OrdByPhone` · `Fax` · `ReportTo` · `ReportToPhone` · `Directions` ·
`CreatedBy` · `CreatedDate` · `ModifiedBy` · `ModifiedDate` · `Status` · `ReportToEmail` ·
`OrderedByEmail` · `CountyCode` · `OrderedByWP` · `ReportToWP` · `EmailInvoice` ·
`OrderedByContactID` · *(OrderedByContactName)* · `ReportedToContactID` ·
*(ReportedToContactName)* · `PriceList` · `PriceExpires` · `MSHA` · `Latitude` · `Longitude` ·
`AddressUnknown`

**Not exported:** `Taxable`, `SalesTaxCode`, `GroupNumb`, `County`, `Flag`, `ValidationStatus`,
`EntityUseCode`, `CountryCode`, `GeoFenceRadius`, `LocationID`, `AddressValidationStatus`.

What this tells you about a job site in FCC, none of which the source states as a rule — these
are just the columns that exist:

- It has its **own price list and expiry** (`PriceList`, `PriceExpires`), separately from the
  customer's. This is the same pair of columns, by name, on both tables.
- It has **`Directions`** as a first-class text column — the ask in
  [customer-and-job-sites.md](customer-and-job-sites.md) ("Add directions in job sites") is a
  feature FCC already has.
- It has **`MSHA`**, a flag for Mine Safety and Health Administration sites.
- It is **geocoded** (`Latitude`, `Longitude`) and carries an `AddressUnknown` escape hatch, plus
  a `GeoFenceRadius` that FCC has but the migration is dropping.
- `OrderedByWP` / `ReportToWP` are exported and the scripts do not say what `WP` stands for.

### `EmailInvoice` code list

| Code | Meaning |
| --- | --- |
| `C` | Customer Only |
| `B` | Customer & Ordered By |
| `O` | Ordered By Only |

So in FCC, **who receives the invoice is decided per job site**, not per customer.

## `FMS_CUSTOMER_NOTES`

10 columns, one derived.

`CustomerNotesID` (the key) · `CustCode` · *(CustomerName1)* · `PopUpMessage` · `DisplayMessage` ·
`Comments` · `CreatedBy` · `CreatedDate` · `ModifiedBy` · `ModifiedDate`

A customer note in FCC is **a pop-up rule, not a free comment thread**. `PopUpMessage` is the
text; `DisplayMessage` is where it fires. `Comments` is a separate longer field. With 121 rows
against 6,070 customers, roughly 2% of customers have one.

### `DisplayMessage` code list

`DisplayMessage` is **multi-valued** — the export script upper-cases it, strips whitespace,
normalises `;` to `,` and then tests for each code as a comma-delimited member, so one note can
fire on several surfaces.

| Code | Fires on |
| --- | --- |
| `All` | All |
| `I` | Invoices |
| `J` | Jobs |
| `O` | Order Entry |
| `Q` | Quotes |
| `W` | Work Orders |

That list is itself a statement about FCC's surfaces: invoices, jobs, order entry, quotes and
work orders are the five places a customer warning can appear.

## Lookup tables, in full

### `FMS_INDUSTRIES` — 33 codes, all `Status = 1`

Columns: `IndustryCode`, `Name`, `CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`,
`trgFMS_INDUSTRIES`, `Status`, `NetSuiteID` (empty on every row). The workbook's own note row says
rename `Name` → `IndustryName` on migration, keep both key columns, treat the audit columns as
system and `NetSuiteID` as n/a.

| Code | Name |
| --- | --- |
| `AC` | Air Conditioning |
| `AGR` | Agriculture and Nursery |
| `ART` | Arts Entertainment and Media |
| `ASP` | Asphalt Plant |
| `CON` | Concrete |
| `CRN` | Crane Operated |
| `DEMO` | Demolition |
| `EDU` | Education |
| `ELE` | Electrical |
| `ENG` | Engineering or Design |
| `GC` | General Contractor |
| `GOV` | Government and Public Admin |
| `HLT` | Healthcare |
| `HOS` | Hospitality and Hotels |
| `LOG` | Logistics Transport and Warehousing |
| `LS` | Landscape |
| `MEC` | Mechanical |
| `MFG` | Manufacturing General |
| `MIN` | Mining |
| `MOV` | Machinery Moving |
| `NPO` | Religious and Nonprofit |
| `PRO` | Professional and Technical Services |
| `REAL` | Real Estate Property and Leasing |
| `REB` | Rebar |
| `REF` | Refinery |
| `RET` | Retail and Restaurants |
| `ROO` | Roofing |
| `SIG` | Signs and Awnings |
| `SOL` | Solar or Energy Systems |
| `STE` | Steel |
| `TEL` | Telecom |
| `UTL` | Utility |
| `WST` | Waste and Environmental Services |

The audit columns date the list in two waves: eleven codes created 2019-09-11 by the original FCC
implementation, two more in 2025-09 (`GC`, `LS`), and twenty added in one batch on 2025-10-27.
`DEMO` is four characters and `REAL` is four — everything else is two or three, and the FCC import
template caps an industry code at five characters.

### `FMS_TERMS` — 12 rows

Columns: `TermID`, `TermName`, `DaysDiscount`, `DateDiscount`, `DayDue`, `DateDue`, `DiscPer`,
`AcctTermsCode`, `Status`, `ShowTerms`, `CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`,
`trgFMS_TERMS`, `EOM`.

| TermID | TermName | DayDue | DaysDiscount | DiscPer | ShowTerms |
| --- | --- | --- | --- | --- | --- |
| 0 | Credit Pending | — | — | — | 0 |
| 1 | COD | — | — | — | 0 |
| 2 | HOLD | — | — | — | 0 |
| 7 | Net 10 | 10 | — | — | 1 |
| 8 | Net 30 | 30 | — | — | 1 |
| 9 | Net 60 | 60 | — | — | 1 |
| 10 | Net 90 | 90 | — | — | 1 |
| 11 | Due On Receipt | — | — | — | 1 |
| 12 | Net 15 | 15 | — | — | 1 |
| 13 | NEW CUSTOMER | — | — | — | 1 |
| 14 | 2% Net 15 | — | 15 | 2 | 1 |
| 15 | Net 45 | 45 | — | — | 1 |

All 12 are `Status = 1`. **`TermID` 3–6 are missing** — four terms were deleted at some point, and
any legacy row still pointing at them would export a null `TermName`. `AcctTermsCode`,
`DateDiscount`, `DateDue` and `EOM` are populated on no row: the day-of-month and end-of-month
branches of FCC's terms model are unused here. `ShowTerms` distinguishes the three
credit-control pseudo-terms (Credit Pending, COD, HOLD) from the nine real ones.

The ERP's `Customer` model splits this differently — see the mapping below.

### `FMS_PARTS_PRICE_LIST_MASTER` — 16 rows

Columns: `PriceList` (the key, a name not a number), `Description`, `Status`, `SalesDiscount`,
`CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`, `trgFMS_PARTS_PRICE_LIST_MASTER`.

Every row's `Description` is the literal string **"Special Rates"** and every row's
`SalesDiscount` is 0 or empty — the discount is not held here. The names are customer or
programme names.

| Price list | Status |
| --- | --- |
| `BIGGE` | active |
| `DUNKEL BROS` | active |
| `FAITH ELECTRIC` | inactive |
| `HENKELS & MCCOY` | inactive |
| `HW POWER` | inactive |
| `JENSEN` | active |
| `JULY 2021 RATES` | active |
| `MINTZ CONCRETE` | active |
| `PAR` | active |
| `POLE CONTRACTOR` | inactive |
| `PREFERRED 1` | active |
| `PREMIER` | active |
| `SHARED CRANE` | active |
| `SO CAL EDISON` | active |
| `VULCAN MATERIAL` | active |
| `WA RASIC` | active |

This is the **parts** price list master. The FCC deck TCG reviewed says of it: *"Currently not
using but need ability to have pricing for Parts per Customer."* Both `FMS_CUSTOMERS` and
`FMS_CUSTOMER_LOCATIONS` carry `PriceList` + `PriceExpires` pointing at it. Crane/service rates
are a different mechanism and are not in this export set — see
[quotations/billing-code-and-price-list.md](../quotations/billing-code-and-price-list.md).

### `FMS_SALES_PERSON` — 33 rows

Columns: `SpersonCode` (numeric), `LName`, `FName`, `MName`, `Phone`, `Fax`, `Email`, `Status`,
`GroupNumb`, `UserID`, `ConvertToJob`, `ViewRestriction`, `CreatedBy`, `CreatedDate`,
`ModifiedBy`, `ModifiedDate`, `trgFMS_SALES_PERSON`, `SalesForceID`, `Title`, `EmpID`, `ExpAcct`.

**The rows are named individuals with direct phone numbers and work email addresses — deliberately
not copied into the vault.** Read them from the source workbook's `SALES_PERSON` sheet if you need
them.

Three columns are worth knowing about structurally: `EmpID` links a salesperson to an employee
record (null on the sampled rows, so the link is not populated), `ViewRestriction` and
`ConvertToJob` are per-salesperson permission flags, and `SalesForceID` is an integration hook
that is empty. The export joins `SalespersonName` as `FName + ' ' + LName` — first name first —
whereas the FCC import template asks for salespeople as **"Last Name, First Name"**.

## How this maps onto the ERP

Cross-checked against `apps/api/prisma/schema.prisma` on 2026-09-04. This mapping is derived by
reading both schemas side by side; **no source in this drop states it**, and the migration's own
field mapping is the seeder brief in
[meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md),
not this page.

| FCC | ERP |
| --- | --- |
| `FMS_CUSTOMERS` | `Customer` |
| `FMS_CUSTOMER_CONTACTS` | `CustomerContact` |
| `FMS_CUSTOMER_LOCATIONS` | `JobSite` (+ `Address`) |
| `FMS_CUSTOMER_NOTES` | *no table* — `Customer.comments String[]` |
| `FMS_INDUSTRIES` | `Industry` |
| `FMS_TERMS` | *no table* — `Customer.billingTerms` is a `VarChar(50)` plus four interval columns |
| `FMS_PARTS_PRICE_LIST_MASTER` | *not this* — `PriceListing` is the ERP's price list, and `Customer.priceList` is a `VarChar(100)` |
| `FMS_SALES_PERSON` | *no table* — `Customer.salespersonId → Employee` |

### Where the shapes differ, and why it matters for the migration

**Identity.** FCC keys a customer on `(CustCode, GroupNumb)`; the ERP keys on a UUID with
`@@unique([tenantCompanyId, customerCode])`. `GroupNumb` has no ERP counterpart at all — the
tenant is the only grouping. If `CustCode` is reused across groups in FCC, the ERP's per-tenant
uniqueness will collide, and this drop contains nothing that says whether it is.

**Email.** The ERP declares `Customer.email` **non-null** and `@@unique([tenantCompanyId, email])`.
FCC's `Email` is exported as an ordinary nullable text column, and the sampled rows include
customers with no email. A one-to-one load is not possible without inventing addresses — which is
exactly what the seeder brief says it does (`fcc-…@migrated.invalid`).

**Addresses.** FCC denormalises one address onto the customer row (`Address1`, `Address2`, `City`,
`StateCode`, `Zip`, `Country`) and one onto each location. The ERP has a separate polymorphic
`Address` model with `isPrimary` and `addressType`, so a customer or a job site can have many.
That is a widening, not a loss.

**Contacts.** FCC's `ContactName` is one field; the ERP's `CustomerContact.name` is also one field
— these line up. But FCC's `ContactType` (Both / None / Ordered By / Report To) has **no column**
in the ERP: `CustomerContact` has `designation` (free text) and `isBillingContact` (boolean)
instead, and the Ordered-By / Report-To distinction lives on the *quotation and job* as
`QuotationQuotedToContact` / `QuotationReportToContact` and `JobQuotedToContact` /
`JobReportToContact` relations. So FCC records the roles a contact is *eligible* for on the
contact; the ERP records the roles a contact *was given* on the transaction. There is no lossless
target for `ContactType`. FCC also carries `Mobile`, `Fax`, `Pager` and a contact-level address;
the ERP's `CustomerContact` has `workPhone` and `emailAddress` only.

**Job sites.** FCC's location carries 40 exported columns; the ERP's `JobSite` carries eight
(`jobSiteCode`, `customerId`, `name`, `status`, `latitude`, `longitude`, timestamps) with the
address pushed out to `Address`. There is no ERP column for `Directions`, `MSHA`, `Description`,
`CountyCode`, `EmailInvoice`, the job site's own `PriceList`/`PriceExpires`, or the Ordered-By /
Report-To contact links. Latitude/longitude do line up — the ERP geocodes on create/update
(SCRUM-414) at the same `Decimal(9,6)` precision FCC uses.

**Notes.** FCC has a table with a pop-up message, a multi-valued display scope and audit columns;
the ERP has `Customer.comments String[]` — a bare array of strings with no author, no timestamp
and no scope. The pop-up behaviour has no target. (The ERP does have `AttachmentFeatureType`
values `CUSTOMER` and `CUSTOMER_NOTE`, so a note can carry files even though it is only a string.)

**Terms.** FCC points at a terms table by `TermID`. The ERP stores the *name* as text
(`billingTerms VarChar(50)`) and then re-derives the arithmetic into four columns —
`dueDateValue`/`dueDateType` and `discountDateValue`/`discountDateType`, where the type column
holds `DAYS` or `DAY_OF_MONTH`. That is a superset of the FCC columns that are actually populated
(`DayDue`, `DaysDiscount`, `DiscPer`) but drops `DiscPer` itself — the ERP has no discount
*percentage* column on the customer. FCC's `EOM` flag also has no target.

**Fields the ERP has that FCC's export does not carry**, even though FCC has the column:
`taxExemptNumber`, `federalTaxId`, `creditLimit`, `insurance`, `insuranceExpiryDate`,
`insuranceContractNumber`. All six are `IncludeInReport = 0` in `FCC_CUSTOMERS.sql`. So the ERP
built the fields and the migration is not filling them. Nothing in this drop says whether that is
deliberate.

**Fields the ERP has that FCC has no counterpart for at all:** `status = DRAFT` (FCC has only
A/T/P), `archivedAt` (FCC uses `Status = T`; see
[decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md)),
and `preQuoteData` / `preQuoteDataCompletedAt` — the JSON compliance/onboarding blob that
corresponds to the paper packet in [new-customer-packet.md](new-customer-packet.md).

**Territory.** [erp-review-log.md](../erp-review-log.md) entry #8 (Melissa, 2026-05-02) asks to
"add Territory under industry". There is **no Territory column anywhere in the FCC customer
schema** and none in the ERP's `Customer` model. It is a new requirement, not a legacy carry-over.

**Customer → projects / quotes / invoices.** The same review-log entry asks that the customer link
to the project tab, quote tab and invoices. The ERP's `Customer` already declares
`quotations Quotation[]`, `jobs Job[]` and `projects Project[]`; there is **no `Invoice` model in
the Prisma schema at all** (only an `invoiceNo` string on `Yard` and an `invoiceNumber` on
`PurchaseOrder`), so the invoice third of that ask has no entity to hang off. On the FCC side the
`DisplayMessage` code list confirms invoices exist there as a customer-linked surface. The
review-log entry's other two items — an attachment section and a note section — are both present
in the ERP as `AttachmentFeatureType.CUSTOMER` and `AttachmentFeatureType.CUSTOMER_NOTE`.

## Source

`2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/__VS_CODE_DataMigration/SQL_FCC_CORE_TABLES/CUSTOMERS/FCC_CUSTOMERS.sql`
(11 KB T-SQL) · `CustomerContacts.sql` (7.4 KB) · `CustomerLocations.sql` (11 KB) ·
`CustomerNotes.sql` (4.8 KB) · `lkup_INDUSTRIES.sql`, `lkup_PARTS_PRICE_LIST_MASTER.sql`,
`lkup_SALES_PERSON.sql`, `lkup_TERMS.sql` (one comment line each) — all copied as-is.

`2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/FCC_CUSTOMERS_20260705.xlsx` (3.5 MB as text, 12 sheets)
— converted by per-sheet row dump. **Row data deliberately not copied**; the four data sheets hold
~42,000 customer records. The text conversion also truncates each sheet at ~4,000 rows, so the
row counts above were taken from the original workbook, not from the converted text. Cell
**colours** carry a per-column keep/lookup/n-a/system disposition that the conversion loses.
