---
title: FCC customer import template — the fields NexGen accepts, and their rules
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-IMPORT-Templates/Customer Data v.6.25_TEMPLATE.xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/customers, kind/reference, data-migration, reference-data, requirements]
entities: []
---

# FCC customer import template — the fields NexGen accepts, and their rules

**What this is.** Fleet Cost & Care's own onboarding workbook, version 6.25, for loading customer
data **into** NexGen FMS. A customer fills it in and FCC imports it. It is not a TCG document and
it is not part of the ERP migration — it is the *other* direction. It matters here for one reason:
it is the only source in the drop that states **which customer fields are required, which are
optional, and what each one's format and length limit is**. The extract scripts in
[fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md) tell you what columns
exist; this tells you what FCC considers mandatory and well-formed.

**Every data row in the workbook is blank.** What looks like thousands of rows is validation
machinery: each real column is followed by a hidden "Match Length" or "Match Option" formula
column that reports `OK` / `Too Short` / `No Match` against an empty cell. The instruction row
under each header is the substance.

Nine sheets. Two are screenshot-only placeholders (`4. Terms Example`, `7. Industry Codes
Example`) with no text. Two are reference-data scratch sheets carrying **another company's**
customer list — see the caveat at the end.

## Sheet 1 — Customer Information

The header row plus its instruction row, in order. "Required or optional" is FCC's own wording and
appears to mean *conditionally required*; the template does not say on what condition.

| Field | Rule |
| --- | --- |
| Customer Code | **Required** — customer Code in NexGen |
| Customer Name | **Required** — up to 50 characters, including spaces |
| Customer Name 2 | Optional — up to 50 characters |
| Address 1 | Required or optional — up to 50 characters |
| Address 2 | Optional — up to 50 characters |
| City | Required or optional — up to 30 characters |
| State | Required or optional — **2 characters** |
| Zip Code | Required or optional — up to 12 characters |
| Country | Optional — up to 30 characters |
| Phone | Required or optional — **10 digits, no spaces or other characters** |
| Fax | Optional — 10 digits, no spaces or other characters |
| Comments | Optional |
| Internal Salesperson | Required or optional — use **"Last Name, First Name"** from the *Salespeople* tab |
| Billing Terms | Optional — use terms entered exactly as in the *Customer and Vendor Terms* tab |
| PO number required? | Optional — `Y` or `N` |
| Last Name First? | Optional — `Y` or `N` |
| Taxable? | Optional — `Y` or `N` |
| Sales Tax Code | Optional — "complete this once sales tax codes are created in NexGen" |
| Status | **Required** — Active (`A`), Inactive (`T`) or Prospect (`P`) |
| Email Address | Optional |
| Email Documents? | Optional — `Y` or `N` |
| Insurance? | Optional — `Y` or `N` |
| Insurance Expiration Date | Optional — date of expiration |
| Insurance Contract No | Optional — up to 20 characters |
| Tax Exempt # | Optional — up to 20 characters |
| Industry Code | Required or optional — use the code entered exactly as in the *Industry Codes* tab |
| Inter-Company? | Optional — `Y` or `N` |
| Price List | Optional — "complete this once price lists are created in NexGen" |
| Price List Expiration Date | Optional — same note |
| Credit Limit | Optional — dollar amount in `XXXX.XX` format |
| Federal Tax ID | Optional — up to 30 characters |
| Website | Optional |

**Only three fields are unconditionally required: Customer Code, Customer Name and Status.**
Everything else is optional or conditional. Note that the ERP's `Customer.email` is non-null and
unique per tenant while FCC treats Email Address as plain optional — the mismatch already flagged
in [fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md).

Three fields carry a "complete this once … are created in NexGen" note — Sales Tax Code, Price
List and Price List Expiration Date. That is FCC saying the import is **two-pass**: load customers
first, wire up the coded references afterwards.

## Sheet 2 — Customer Contacts

| Field | Rule |
| --- | --- |
| Customer Code | Use the code from the *Customer Information* tab |
| Customer Name | **Required** — up to 50 characters |
| Contact's Name | **Required** — up to 50 characters (one field, not first/last) |
| Address | Required or optional — up to 50 characters |
| City | Required or optional — up to 30 characters |
| State | Required or optional — 2 characters |
| Zip Code | Optional — up to 12 characters |
| Email Address | Required or optional |
| Cell Phone | Required or optional — 10 digits |
| Work Phone | Required or optional — 10 digits |
| Work Fax | Required or optional — 10 digits |
| **"Can contact place orders for jobs and be report-to contact on jobsites?"** | `Y` or `N` |
| Internal Salesperson | Required or optional — "Last Name, First Name" from the *Salespeople* tab |
| Position | Required or optional — up to 50 characters |
| Status | **Required** — Active (`A`) or Inactive (`T`) |
| "Is their address the same as the customer's address?" | **Required** — `Y` or `N` |
| Comments | Optional |

The eleventh row is worth reading twice. FCC's import collapses the four-valued `ContactType`
(Both / None / Ordered By / Report To) into **one yes/no question**, and its wording is the
plainest statement in the whole drop of what the field means: *can this contact place orders for
jobs, and be the report-to contact on job sites?* That is a customer-level flag governing
**job-site** behaviour — relevant to the job-site-contact question the
[customers-INDEX.md](customers-INDEX.md) conflict stub leaves open, though the template is FCC's
document and says nothing about what the ERP should do.

The contact sheet has **no job-site column**. A contact is imported against a customer code and
nothing finer.

**There is no job-site / location tab in this template at all.** FCC's
`FMS_CUSTOMER_LOCATIONS` holds 26,199 rows in TCG's database and the vendor's own customer-import
workbook has no way to load one. The template does not say how locations get created.

## Sheet 3 — Customer and Vendor Terms

Free-text instructions, not a grid:

> "Enter ALL of the terms used for customers AND vendors. Match how the terms are set up in your
> accounting software. If there are terms that apply to both customers and vendors and match
> EXACTLY, only enter it once on this list."

Examples given: `Net 30`, `Net 60`, `COD`, `Credit Pending`, `2% Net 10`. Four of those five are
in TCG's live `FMS_TERMS` (see
[fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md)); TCG has `2% Net 15`
rather than `2% Net 10`.

Two facts follow from the wording. **Terms are a shared vocabulary across customers and vendors**
in FCC — one list, not two. And **the terms list is meant to mirror the accounting system**, which
for TCG is QuickBooks; the QB audit export in
[quickbooks-customer-table-audit.md](quickbooks-customer-table-audit.md) carries its own `Term ID`
and `Terms` columns whose ids do not match FCC's.

## Sheet 5 — Salespeople

`Code` (required, up to 15 characters) · `First Name` (required, up to 30) · `Last Name`
(required, up to 30) · `Middle Name` (required, up to 30) · `Phone` (optional, 10 digits) ·
`Fax` (optional, 10 digits) · `Email` (optional, up to 50) · `Last Name, First Name` (derived —
"no need to enter information in this field, used in the Customer Information tab") ·
`Employee Profile in NexGen` ("complete this once employee profiles are created in NexGen").

So FCC's own import treats **salesperson and employee as separate records** joined afterwards —
matching `FMS_SALES_PERSON.EmpID`, which is empty in TCG's data. The ERP does the opposite:
`Customer.salespersonId` points straight at `Employee`.

Middle Name being marked **required** is what the template says; whether FCC enforces it is not
stated.

## Sheet 6 — Industry Codes

`Industry Code` — **required, up to 5 characters including spaces**. `Description` — **required,
up to 20 characters including spaces**. Nothing else.

TCG's live list has 33 codes, all within 4 characters, but eleven of the 33 descriptions exceed
20 characters (*"Logistics Transport and Warehousing"* is 35). Either the limit was raised after
v6.25 of the template, or those names were entered through the UI rather than this import. The
sources do not say which.

## The reference-data sheets carry someone else's customers

Sheets `Reference Data` (26,050 rows) and `Reference Data 2` (2,674 rows) are working sheets
behind the validation formulas, and they are **not blank**. They hold a customer list — codes,
company names, salesperson names, terms, PO-required flags, AP contact names and **AP contact
email addresses** — for what is plainly a different company from TCG: the names are San Antonio
and Texas HVAC and plumbing contractors, and one of the columns contains an `@americraneusa.com`
address.

**Not copied.** This looks like leftover data from another FCC customer's onboarding, shipped
inside the blank template. It is worth flagging to whoever handles the drop: if TCG's own filled
copy of this template is ever circulated, it may carry the same residue.

## The validation formulas, exactly (read 2026-09-04)

The 26,002 formulas reduce to 12 patterns, one per validated column: a length check `IF(LEN(x) <
N, "OK", "Too Long")` — customer name ≤ 50, city ≤ 30, phone ≤ 12, an address-2/attention field
≤ 20 — two exact-length checks (**state = 2 characters**, **zip = exactly 10**, i.e. `12345-6789`),
a `VLOOKUP` "No Match" test against the reference sheets for **salesperson** (`5. Salespeople`,
column O), **terms** (`3. Customer and Vendor Terms`, rows 111–130 — so only twenty term codes
are valid), **industry code** (`6. Industry Codes`), two `Y/N` flags, a **status of `A` / `T` /
`P`** (Active / Terminated / Prospect), and a numeric two-decimal check on a rate field. The
hidden `Reference Data` sheets (`A1:R26050`) are the lookup source and hold the foreign customer
list noted below.

## Source

`1.0.2_FCC-RESOURCES-GUIDES/FCC-IMPORT-Templates/Customer Data v.6.25_TEMPLATE.xlsx` — 9 sheets,
1.0 MB as text, converted by per-sheet row dump. Sheets `4. Terms Example` and `7. Industry Codes
Example` are single-cell screenshot placeholders and produced no text. The data rows of sheets 1,
2, 5 and 6 are empty by design; **the `Reference Data` and `Reference Data 2` sheets contain a
third party's customer and AP-contact records and were deliberately not copied.**
