---
title: QuickBooks customer table audit — what TCG's accounting system holds per customer
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/QB Table Audit Reports/The Crane Guys, LLC_Customer Contact List - most columns.xlsx and .csv
migrated: 2026-09-04
updated: 2025-12-01
status: unverified
conflicts_with: []
jira: []
tags: [module/customers, module/accounting, kind/source, data-migration, integrations, reference-data, invoicing]
entities: []
---

# QuickBooks customer table audit

**What this is.** An export of TCG's **QuickBooks** customer table, taken on **2025-12-01**, filed
under `QB_Connector/QB Table Audit Reports/` — i.e. produced as part of auditing what the FCC↔QuickBooks
connector has to reconcile. QuickBooks is the third system in the customer picture, alongside FCC
(the operational system of record) and the ERP being built. The report is titled *"Customer
Contact List - most columns"*, and a companion sheet inside the `.xlsx` documents the columns it
deliberately left out.

**6,072 customer rows. Not copied** — this is bulk data; structure, counts and distinct value sets
only. The `.csv` and the `.xlsx` carry the **same** 6,072 rows; the `.xlsx` adds one extra sheet,
`other fields-columns`, which is the actual audit and is the reason both were kept.

## Columns in the export — 40

`Customer ID` · `Company` · `Note` · `Type` · `Customer` · `Customer full name` · `Full name` ·
`Title` · `First name` · `Middle name` · `Last name` · `Suffix` · `Email` · `Phone numbers` ·
`Phone` · `Mobile` · `Fax` · `Additional contact info` · `Billing fax` · `Bill address` ·
`Bill street` · `Bill city` · `Bill state` · `Bill zip` · `Bill country` · `Created By` ·
`Created on` · `Do Not Pre Lien` · `Modified by` · `Modified on` · `Term ID` · `Terms` ·
`Balance` · `Ship address` · `Ship street` · `Ship city` · `Ship state` · `Ship zip` ·
`Ship country` · `Deleted`

Note the shape: QuickBooks keeps **two** addresses per customer (Bill and Ship), each as both a
single composite string and its parsed parts, and it keeps `Phone numbers` as one packed string
(`"Phone:(714) 394-4503 Mobile:818-430-6444 (howard)"`) *as well as* parsed `Phone` / `Mobile` /
`Fax` columns. The packed string is where the free-text annotations live.

## It is the same customer set as FCC, keyed by `AcctIntCode`

`FMS_CUSTOMERS.AcctIntCode` is the QuickBooks `Customer ID`. Checked across both extracts:

- QuickBooks holds **6,072** customers (2025-12-01).
- FCC holds **6,070** customers (2026-07-02) — see
  [fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md).
- **6,057** FCC rows carry an `AcctIntCode`; 13 are blank.
- **5,681** of those resolve to a QuickBooks `Customer ID` in this export — 93.8%.

The residual is what you would expect from seven months' drift between the two extract dates, but
the sources do not say so and nothing here proves the link is maintained rather than one-time.
`AcctIntCode` is marked **exported** in `FCC_CUSTOMERS.sql`, so the ERP migration is carrying the
QuickBooks key across; there is no ERP column for it in `apps/api/prisma/schema.prisma`.

## Distinct value sets

### `Terms` — 8 distinct, and the ids do not match FCC's

| Term ID (QB) | Terms | Customers |
| --- | --- | --- |
| 18 | Net 15 | 4,275 |
| 19 | Net 30 | 825 |
| — | *(blank)* | 523 |
| 27 | COD | 425 |
| 26 | Net 45 | 21 |
| 20 | Net 60 | 2 |
| 25 | Net 10 | 1 |
| 33 | Net 20 | 1 |

FCC's `TermID` for Net 15 is **12**; QuickBooks' is **18**. For Net 30 it is 8 versus 19, for COD
1 versus 27. **The two systems have independent term-id spaces** and can only be reconciled by
name. QuickBooks also has a `Net 20` that FCC's `FMS_TERMS` does not, and FCC has `Credit
Pending`, `HOLD`, `NEW CUSTOMER`, `Due On Receipt`, `Net 90` and `2% Net 15` that appear on no
QuickBooks customer here. The FCC import template's instruction —
*"match how the terms are set up in your accounting software"* (see
[fcc-customer-import-template.md](fcc-customer-import-template.md)) — was evidently not followed,
or was followed and has since drifted.

**Net 15 is the overwhelming default**, on 70% of customers.

### `Type` — 11 distinct, and 83% blank

`Air Conditioning-HVAC` (930) · `Construction` (44) · `Misc` (42) · `Rock plant` (12) ·
`Steel` (4) · `Environmental` (4) · `Telecom` (2) · `Apparel` (1) · `Precast` (1) ·
`Builders` (1) · blank (5,032).

This is QuickBooks' own customer-type list, and it is **not** FCC's industry code list — different
vocabulary, different granularity, and 83% unpopulated. FCC's `FMS_INDUSTRIES` has 33 codes with a
different naming scheme (`AC` = Air Conditioning, `CON` = Concrete, `STE` = Steel…). Where both
systems have a value for the same customer, nothing in these sources says which is authoritative.

### `Deleted`

`No` on every one of the 6,072 rows. Nothing has been soft-deleted in this table.

### `Do Not Pre Lien` — a free-text field being used as a flag

82 of 6,072 rows are non-blank, and they are spelt **eight different ways**: `Do Not Pre Lien`
(72), `DO NOT PRE LIEN` (4), `DO NOT PRELIM` (2), `Do Not Pre lien`, `DO NOT PRELIEN`,
`do not pre lien`, plus two rows using the field for something else entirely —
`PRELIN ONLY OVER 1000` and `NET 20 per Maria`. The audit sheet adds that the **`Note` field also
carries "Do Not Prelien"** for at least one customer, so the same fact is recorded in two places.

This is a data-quality finding, not a requirement. It is the concrete case behind the review log's
data-import policy — *"avoid importing bad or messy legacy data"*
([erp-review-log.md](../erp-review-log.md) → *Data import*).

## The `other fields-columns` audit sheet

The `.xlsx` carries a second sheet listing QuickBooks customer fields the export omitted, split
into two groups.

**Fields every customer record has** but which are not in the "most columns" report:
`Deleted`, `Delivery method`, `Job City`, `Job Name`, `Job Street`, `Job Zip Code`, `PO Number`,
`Project status`, `Project Type`, `Tax rate`, `Project started on`, `Project ended on`,
`Customer tax code`, `Customer tax name`, `Customer tax status`.

Two things stand out. QuickBooks has **job and project fields on the customer record itself** —
`Job Name`, `Job Street`, `Job City`, `Job Zip Code`, `Project status`, `Project Type`, `Project
started on`, `Project ended on` — which is a third representation of a job site, alongside FCC's
`FMS_CUSTOMER_LOCATIONS` and the ERP's `JobSite`. And it has a customer-level **`PO Number`**,
where FCC has a `PORequire` boolean and the ERP has `Customer.poRequired`.

**Fields only a handful of customers use**, with the audit's own counts:

| Field | Customers with a value | What the values look like |
| --- | --- | --- |
| `Pre-Lien` | 1 | the words "Do Not Prelien" |
| `Resale number` | 1 | a tax identifier — *not copied* |
| `Website` | 2 | a URL |
| `Payment method` / `Payment method ID` | 1 | "Check" |
| `Travel Time (inactive)` | 4 | free text: `1HR IN 1HR OUT`, `1 hr in and 1.5 out`, `1.5HRS IN & 1.5HRS OUT` |
| `Preferred Rates` | 6 | free text: `yes`, `Yes`, `yes, OT & DT`, `YES-75 TON & 90 TON`, `5% off for Gold Fortune SuperMa` |

`Travel Time` and `Preferred Rates` are the interesting pair: **per-customer commercial terms held
as unparsed English in a QuickBooks custom field**, and both are marked or read as effectively
dormant (`Travel Time` is labelled *inactive*; `Preferred Rates` overlaps with the customers whose
names carry `(SPECIAL RATES)` in FCC and with entries in `FMS_PARTS_PRICE_LIST_MASTER` —
`Vulcan Materials` appears in both). Several of these customers also encode the same fact **in
their own name** — `Ammco Steel, Inc. (SPECIAL TRAVEL TIME) (NO TRIP PERMIT FEE)`. Nothing here
says how any of it should be modelled in the ERP.

## Source

`1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/QB Table Audit Reports/The Crane Guys, LLC_Customer
Contact List - most columns.xlsx` (2.5 MB as text; 2 sheets — the 6,072-row export and the
`other fields-columns` audit) and `…- most columns.csv` (3.4 MB; the same 6,072 rows, no audit
sheet). Report footer dates the run `Monday, December 01, 2025`, accrual basis.
**Customer rows deliberately not copied** — counts and distinct value sets only. One field
(`Resale number`) holds a tax identifier and was not transcribed.
