---
title: FCC → TCG migration client brief, as annotated by TCG (26 August 2026)
source: user-supplied/meeting-document — CodingCops brief (apps/api/fcc-seeder/docs/FCC-to-TCG-Client-Brief.docx) with client annotations from the 2026-08-26 ERP sprint review
original_file: "FCC-to-TCG-Client-Brief.pdf" (= "FCC-to-TCG-ERP migration.pdf", text-identical)
migrated: 2026-08-27
updated: 2026-08-31
status: unverified
conflicts_with: []
jira: []
tags: [module/customers, module/assets, module/payroll, module/accounting, module/admin, module/vendors-agencies, kind/meeting-notes, migration, fcc, integrations]
entities: [customer, customer-contact, job-site, asset, customer-owned-asset, meter-reading, category, sub-category, yard, department, employee, employee-type, craft-code, union-code, work-comp-code, certificate, salesperson, vendor, billing-code, gl-account, part, purchase-order, checklist, agency]
meeting_date: 2026-08-26
---

# FCC → TCG migration client brief, as annotated by TCG — 26 August 2026

**What this is.** CodingCops' *FCC (NexGen FMS) to TCG — client brief* describes what the
first-pass test extract (`NexGenFMS-Test`, never production) loads into the ERP, what is
deliberately not migrated, and the field gaps in both directions. The copy TCG returned carries
**their annotations** (highlighted cells in the PDF, quoted below as *"…"*). The brief's own
content is CodingCops-authored and lives in the platform repo (`apps/api/fcc-seeder/docs/`);
**this file records the client's reactions to it**, which are the action items.

> **Forward-looking.** Client annotations are asks or questions, not decisions — none has been
> adjudicated. The `meetings/` retrospective caveat does not apply.

PDF: [assets/2026-08-31_fcc-to-tcg-client-brief.pdf](assets/2026-08-31_fcc-to-tcg-client-brief.pdf)
— **latest copy, saved 2026-08-31**, same annotations plus the `FMS_UNIT_MILEAGE` odometer mock-up
rendered inline. Supersedes [assets/2026-08-26_fcc-to-tcg-client-brief.pdf](assets/2026-08-26_fcc-to-tcg-client-brief.pdf),
kept for the 2026-08-26 record.
Discussion: [transcripts/2026-08-26-erp-sprint-review.md](transcripts/2026-08-26-erp-sprint-review.md).
Brian's follow-up message of 2026-08-27 restates six of these — see
[payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros).

## Safety changes in the extract (uncontested)

Emails → `fcc-…@migrated.invalid`; phones/fax → `+1-555-…`; SSN not copied; PII in notes →
`[redacted-email]` / `[redacted-phone]`; tenant admin → `admin@{tenant-code}.invalid`. Names,
addresses and tax IDs are **real FCC values** — a migrated tenant is not production-safe for
outbound mail.

## Loaded modules — with TCG's annotations

| TCG feature | FCC table | Rows | TCG annotation (verbatim) | Routed to |
| --- | --- | --- | --- | --- |
| Customers | `FMS_CUSTOMERS` | 5,742 | *"Show legacy ID on UI — Brian. Process Hubspot integration with Patrick Mckiernan — Microsoft contacts"* | **A1**, [admin/gaps.md → Integrations](../admin/gaps.md#integrations--hubspot-microsoft-365-dialpad-mapsly) |
| Customer contacts / job sites / notes | `FMS_CUSTOMER_*` | 8,571 / 23,158 / 108 | — | |
| Assets | `FMS_UNITS` | 249 | — | |
| **Customer-owned assets** | `FMS_CUSTOMER_UNITS` | 12 | *"Customer units in FCC — we do not have a module for this. Need to scope this functionality."* | [assets/gaps.md → Customer-owned assets](../assets/gaps.md#customer-owned-assets--what-they-are-and-whether-the-erp-tracks-them) |
| Asset meter readings | `FMS_UNIT_MILEAGE` | 5,313 | *"Inside Assets — not all assets have Mileage. Need to scope this functionality. Need to update UX for this"* (odometer + lower-meter card mock-up attached) | **A2** |
| Categories / Sub-categories | `FMS_SCHEDULE_TYPES` / `FMS_UNIT_TYPES` | 25 / 68 | *"Categories now have general categories — need to fix"* (both rows) | **A3** |
| Sub-category associated equipment / employees | `FMS_UNIT_TYPE_EQUIPMENT` / `_EMPLOYEES` | 161 / 117 | highlighted, no text | **A3** |
| Manufacturers | `FMS_MANUFACTURERS` | 79 | *"Jeff will update us"* | **A4** |
| Yards | `FMS_YARD_MASTER` | 2 | *"How to handle Yards in the New ERP?"* | **A5**; see payroll/gaps.md → *Employee yard and company cardinality* |
| Departments | `FMS_DEPARTMENTS` | 10 | *"Need to Connect Departments with Types/Roles — Need info from TCG Team."* | **A6** |
| Employees / types | `FMS_EMPLOYEES` / `_TYPES` | 220 / 14 | dummy email/phone; SSN omitted | |
| Employee type on the employee | `FMS_EMPLOYEE_TYPE_DETAILS` | 720 | primary type → `employeeTypeId`; *"Brian: More information on this."* | **A7** |
| Craft codes / craft on employee / union on employee | `FMS_CRAFTS` / `FMS_EMPLOYEE_CRAFTS` / `FMS_EMPLOYEE_UNIONS` | 71 / 19 / 84 | *"Not Imported correctly."* ×3 | **D1** (defect, CodingCops) |
| Work-comp codes | `FMS_WORKERS_COMP` | 4 | *"What are these? Brian to check with team."* | **A8** |
| Certificate catalog | `FMS_CERTIFICATES` | 14 | *"Need discussion with TCG Team"* | [payroll/gaps.md → Employee certifications](../payroll/gaps.md#employee-certifications--types-and-scope-per-job-per-unit-other) |
| Employee certifications | `FMS_EMP_CERTIFICATES` | 446 | *"Certificate number not stored"* | same, + **D2** |
| Salespersons | `FMS_SALES_PERSON` | 31 | *"Linked as employees"* (highlighted) | **A9** |
| Vendors / contacts, billing code types / codes / price lists, industries, lost reasons | various | 833 / 4 · 35 / 365 / 20 · 33 · 8 | — | |
| Expense GL accounts | `FMS_GL_ACCOUNTS` | 296 | *"Need Clarification from TCG Team"* | [accounting/gaps.md → GL codes](../accounting/gaps.md#gl-codes--fccerp-chart-vs-quickbooks-and-who-owns-the-mapping) |
| Parts | `FMS_PARTS` | 4,797 | catalog only (no stock) — *"Need to revisit Functionality CC"* | **A10** |
| Purchase orders + lines | `FMS_PURCHASE_MASTER` / `_DETAILS` | 1,638 / 3,400 | *"What are the lines?"* | **A11** |
| Checklists + items | `FMS_CHECK_LIST` / `_DETAILS` | 617 | definitions only — *"Need clarifications from TCG Team"* | **A12** |
| States / countries | — | 73 / 252 | *"Agencies ??? Agencies are mentioned in Rayn Updated Sheets, please look into them."* | **A13** |

Lookups copied as text on the parent, not as their own screens: billing terms, measures, fuels,
classifications, purchase types, part types.

## Not migrated (brief §3, unannotated)

History deliberately left behind: quotations (~24k/131k), jobs (~26k), DAS/job tickets (~40k),
job/quote units, FAA/job permits, yard operations, projects (empty), invoices/AR, payroll history
(~654k), work orders/PM, signed checklist runs (~112k), documents/file links, FCC users/screens,
logs. Extracted but with **no TCG home**: part stock/serials/bins, unit-type estimate templates,
unit downtime reasons, unit measures, sub-category×yard, asset checklist types, **union benefit
lines (7), union×craft pay rates (51), craft modifiers (34)**, GL account per company (592),
storage locations, tools (empty), agencies (unmapped), temps (share the employee table).

The payroll-shaped ones (union×craft rates, craft modifiers, union benefits) are not a migration
gap: `SCRUM-925/926` model them natively. Field-level gaps per module are in the brief §4 and in
`apps/api/fcc-seeder/docs/field-gaps.md`; not repeated here.

## Action items

**TCG owes CodingCops**

| # | Item | Owner (as annotated) |
| --- | --- | --- |
| A1 | HubSpot ↔ Microsoft contacts integration walkthrough; customer legacy-ID to show on UI | Brian Petros; Patrick McKiernan |
| A4 | Manufacturer list corrections | Jeff |
| A5 | How yards work in the new ERP (2 in FCC) | TCG |
| A6 | How departments relate to employee types/roles | TCG |
| A7 | What employee-type details (720 rows, multi-type per employee) mean | Brian Petros |
| A8 | What the 4 workers'-comp codes are | Brian Petros, with team |
| A11 | What purchase-order lines represent | TCG |
| A12 | Checklist definitions — which are still in use | TCG |
| A13 | Agencies — the "Rayn Updated Sheets" that mention them | TCG (Ryan?) |
| — | Certificate catalog, GL accounts, customer-owned units: discussions already registered as gaps (links above) | TCG |

**CodingCops owes TCG**

| # | Item |
| --- | --- |
| D1 | Craft codes (71), employee crafts (19), employee unions (84) **not imported correctly** — fix the seeder |
| D2 | Employee certification **certificate number** dropped by the mapping — store it |
| A2 | Meter readings: scope which assets carry meters; UX per the odometer/lower-meter card mock-up |
| A3 | Categories and sub-categories now sit under "general categories" — mapping needs fixing; associated equipment/employees rows flagged with them |
| A9 | Confirm salespersons-as-employees is acceptable (highlighted, no text) |
| A10 | Parts: catalog imported without stock — revisit what functionality is wanted |
| — | Show FCC legacy ID on the customer UI (A1) |

**Every item above is outstanding** unless someone has confirmed otherwise.

## Brief accuracy against live FCC — checked 2026-08-31

Read directly from `NexGenFMS-Test` (read-only). Every row count the brief prints matches live:
`FMS_PURCHASE_DETAILS` 3,400 · `FMS_CHECK_LIST_SIGNATURES` 112,500 · `FMS_QUOTE_MASTER` 24,232 ·
`FMS_QUOTE_DETAILS` 131,139 · `FMS_LABOR_UNION_DETAILS` 654,423 · `FMS_PROJECTS` and `FMS_TOOLS`
empty. Three things the brief now gets wrong or omits — **none adjudicated, none actioned**:

1. **§3 is stale on payroll crafts.** It lists `FMS_UNION_CRAFT` (51) and `FMS_CRAFT_MODIFIER` (34)
   under *"Extracted from FCC but not inserted"*. Commit `b8f1ce3f` inserts both on FCC sync as
   `CraftCode` + `CraftCodeRate` + `CraftModifier` (SCRUM-925). They belong in §2.
2. **`FMS_UNION_CRAFT_MODIFIER` (34 rows) is not in the brief at all.** It holds the live boom-pay
   adders per union × modifier — `PayRateChange` / `OT` / `DB`, effective-dated (`L12 / OP-BP-01 =
   0.75 / 1.125 / 1.50`). The seeder reads ranges from FCC's `FMS_CRAFT_MODIFIER` but takes the
   adders from the hardcoded `CRAFT_MODIFIER_BRACKETS` in `packages/shared/src/constants/craft-modifiers.ts`
   (decision 23099). TCG lists this table in their data-warehouse set, so expect the question.
3. **The non-union gap behind D1 is undocumented.** `FMS_NON_UNION_CRAFT` exists but is **empty**,
   and `FMS_CRAFTS.UnionYN` is `true` on all 71 rows — so FCC has no usable non-union flag. The real
   split is whether a craft has an `FMS_UNION_CRAFT` rate row: **51 do, 20 do not**. `resolvePayrollCrafts()`
   skips any craft without one, so `ADMIN-A` — primary craft for **44 non-union employees** and 18,326
   of 18,380 non-union labor lines — becomes no payroll craft and no assignment. Non-union pay lives on
   `FMS_EMPLOYEES.PayRate` / `PayRateOT` / `PayRateDB` with `PayType` H/S, not in any rate table.
   This is the mechanism behind D1's three *"Not Imported correctly."* annotations.

**TCG's data-warehouse table list (40 tables, supplied 2026-08-31).** The brief accounts for 29 of
them; **11 appear nowhere in it**: `FMS_JOB_UNIT_CHECK_LIST` (**3,792,678 rows — the largest table in
the catalog**; §3 names only `FMS_CHECK_LIST_SIGNATURES` at 112,500), `FMS_UNION_CRAFT_MODIFIER` (34),
and nine small job/ticket lookups — `FMS_ACTIVITIES` 99, `FMS_TICKET_STATUS` 53, `FMS_ETS_TICKET_SUB_SECTION`
52, `FMS_UNITTYPE_JOBTYPES` 43, `FMS_CHECKED_TAKEN` 29, `FMS_TICKET_SECTIONS_SUBLIST` 26, `FMS_JOB_TYPES`
12, `FMS_JOB_STATUS` 7, `FMS_ETHNICITY` 7. Two more are covered only implicitly by the Jobs row's
*"details, resources, checklists, comments"* and never named: `FMS_JOB_CHECKLIST` 52,007 and
`FMS_JOB_EMPLOYEES` 48,237.

**Two defects in the document itself**, both client-facing: the §1 SSN cell has a stray local path
pasted into it (*"TCG ssn stays empty/home/codingcops/Desktop/Projects/craneguys-platform/apps/api/fcc-seeder/docs/FCC-to-TCG-Client-Brief.docx"*),
and the header ships a live credential in plain text (`fccdata@tcg.com` / the `FCC_ADMIN_PASSWORD`).
