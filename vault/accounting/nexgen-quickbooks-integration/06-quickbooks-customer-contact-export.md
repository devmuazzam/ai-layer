---
title: QuickBooks customer contact audit export — structure and code lists
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/QB Table Audit Reports/The Crane Guys, LLC_Customer Contact List - most columns.csv and .xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/customers, kind/reference, reference-data, data-migration, integrations, provenance]
entities: []
---

# QuickBooks customer contact audit export — structure and code lists

**What this is.** TCG's own audit export of the **QuickBooks customer file**, taken as part of
the connector review and filed in a folder called `QB Table Audit Reports` alongside the
case-39995 thread ([05-case-39995-data-sync-incident.md](05-case-39995-data-sync-incident.md)).
Same content in CSV and XLSX; the XLSX carries hand-written annotations the CSV does not.

> **Bulk data — not copied.** 6,073 customer records with names, addresses, phone numbers,
> email addresses, balances and free-text collections notes. Per the vault's rule on large data
> dumps, **only structure, counts and code lists are recorded here.** No row data was copied
> into the vault. Read the source files directly if you need records.

## Shape

- **6,073 data rows**, 40 columns, one row per QuickBooks customer.
- XLSX sheet `The Crane Guys, LLC_Customer Co`, dims `B2:AO6082`; the CSV carries the same rows
  with a two-line report title above the header.
- Report title as printed: *"Customer Contact List - most columns"*, *"The Crane Guys, LLC"* —
  a standard QuickBooks report, exported with most-but-not-all columns.

## Columns, and how completely they are populated

Fill counts out of 6,073. This is the useful part: it shows what the QuickBooks customer record
actually holds at TCG, versus what it could hold.

| Column | Filled | Column | Filled |
| --- | ---: | --- | ---: |
| Customer ID | 6,073 | Created By | 6,072 |
| Customer / Customer full name | 6,072 | Created on | 6,072 |
| Company | 5,938 | Modified by / Modified on | 6,072 |
| Phone numbers / Phone | 5,857 / 5,855 | Deleted | 6,072 |
| Bill address / street | 5,819 / 5,815 | Term ID / Terms | 5,550 / 5,550 |
| Bill city / state / zip | 5,707 / 5,694 / 5,296 | Email | 4,024 |
| Ship address / street | 4,145 / 4,138 | Ship city / state / zip | 3,570 / 3,555 / 3,475 |
| Note | 2,123 | Type | 1,041 |
| Additional contact info | 1,033 | Bill country | 994 |
| Billing fax | 616 | Full name | 456 |
| First name / Last name | 453 / 397 | Mobile | 283 |
| Middle name | 196 | Balance | 151 |
| Ship country | 142 | Fax | 121 |
| Do Not Pre Lien | 83 | Title | 71 |
| Suffix | 13 | | |

**Read that top-to-bottom and the customer file's real shape appears:** company, phone,
billing address and terms are near-universal; a **named human contact is present on well under
10%** of records (First name 453, Last name 397, Title 71); shipping address is present on
about two thirds; and only 4,024 records carry an email address at all — on a file whose
invoices are emailed from QuickBooks.

Columns the report **did not include**, listed by the workbook's own annotation: `Tax rate`,
`Project started on`, `Project ended on`, `Customer tax code`, `Customer tax name`,
`Customer tax status`, `Project status`, `Project Type`.

## Code lists worth keeping

### Payment terms — the `Term ID` → `Terms` table

Every distinct pair in the file. This is the QuickBooks terms list the connector's
`TermsRefListID` mapping resolves against
([01-fcc-connector-field-mapping.md](01-fcc-connector-field-mapping.md)):

| Term ID | Terms | Customers on it |
| ---: | --- | ---: |
| 18 | Net 15 | 4,275 |
| 19 | Net 30 | 825 |
| 27 | COD | 425 |
| 26 | Net 45 | 21 |
| 20 | Net 60 | 2 |
| 25 | Net 10 | 1 |
| 33 | Net 20 | 1 |
| — | *(no terms set)* | 523 |

**Net 15 is the default for 70% of the file.** Note that the real invoices in this drop are
mostly Net 30 and Net 45, and Edison is Net 10
([../invoice-packets-2026-04-worked-examples.md](../invoice-packets-2026-04-worked-examples.md))
— i.e. the customers that actually generate invoices are not distributed like the customer file
as a whole.

### `Type` — the customer-industry list

Almost unused: **5,032 of 6,073 records have no Type at all.** The values in use are
`Air Conditioning-HVAC` (930), `Construction` (44), `Misc` (42), `Rock plant` (12), `Steel` (4),
`Environmental` (4), `Telecom` (2), and one each of `Apparel`, `Precast`, `Builders`, `Job
Street`. The dominance of `Air Conditioning-HVAC` on a crane-rental customer file, and the
presence of a value called `Job Street`, both suggest the field has been repurposed or
mis-set; nothing in the file says so.

*(The case-39995 thread names "updating all industry codes for our customers" as a possible
trigger for the November 2025 full sync — this is the field it refers to. The export does not
date the values, so it does not show what changed.)*

### `Do Not Pre Lien` — a free-text flag

Populated on 83 records, with **four different spellings of what is evidently one flag**:
`Do Not Pre Lien` (71), `DO NOT PRE LIEN` (4), `DO NOT PRELIM` (2), and one record reading
`PRELIN ONLY OVER 1000`. It is a text column being used as a boolean, plus one threshold rule
written into it in prose. Pre-liens and the lien alert are part of the AR collections flow
([../ap-ar-value-engine-and-whiteboard-flow.md](../ap-ar-value-engine-and-whiteboard-flow.md)).

### `Created By` — who builds the customer file

`Import Administration` (2,947) · `Fleet Cost Care` (2,087) · then five named TCG staff
(444 / 248 / 165 / 156 / 11 / 4). **83% of customers were created by an import or by the
vendor's own service account**, not by a person — consistent with a file that has been bulk
loaded and bulk synced repeatedly.

`Deleted` is `No` on 6,072 of 6,073 rows: the export contains no deleted customers.

## The `Note` column is a collections log

2,123 records carry a free-text `Note`. Spot-reading the column shows it is used as an
**append-only AR collections journal** — dated entries with the collector's initials, recording
statements sent, calls made, promises given and check numbers received, sometimes a decade of
them in one cell. One record's note is also a test marker (`** Melissa Test for FCC**`).

**That is a finding about the ERP, not about the data:** the collections history the accounting
wishlist wants to report on ([../2026-07-accounting-team-erp-wishlist.md](../2026-07-accounting-team-erp-wishlist.md)
— *payment history with average-days-outstanding*, *AI collections assistant*) currently lives
as unstructured prose inside a QuickBooks customer note field. The individual notes are
customer-identifying and were not copied.

## What this export is not

It is a **QuickBooks-side** report. It is not the NexGen/FCC customer table, and it cannot be
used to answer what NexGen holds — the two are joined by `CustCode` in QuickBooks's
`AccountNumber` field, which **this report does not include** and which the QuickBooks Online
UI does not display
([04-quickbooks-online-setup-guides.md](04-quickbooks-online-setup-guides.md)). For the FCC-side
customer tables see
[../../meetings/2026-08-26-fcc-migration-client-brief.md](../../meetings/2026-08-26-fcc-migration-client-brief.md).

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/QB Table Audit Reports/The Crane Guys, LLC_Customer Contact List - most columns.csv` — 3.5 MB, 6,073 records × 40 columns, copied as-is
- `…/The Crane Guys, LLC_Customer Contact List - most columns.xlsx` — 2.5 MB, one sheet, per-row dump; carries the annotation block listing sparsely-populated and omitted columns. Dates render as Excel serial numbers in the XLSX conversion and as formatted dates in the CSV.
- **Row data deliberately not copied** — see the banner at the top of this page.
