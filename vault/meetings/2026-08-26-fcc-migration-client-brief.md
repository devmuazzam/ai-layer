---
title: FCC → TCG migration client brief, as annotated by TCG (26 August 2026)
source: user-supplied/meeting-document — CodingCops brief (apps/api/fcc-seeder/docs/FCC-to-TCG-Client-Brief.docx) with client annotations from the 2026-08-26 ERP sprint review
original_file: "FCC-to-TCG-Client-Brief.pdf" (= "FCC-to-TCG-ERP migration.pdf", text-identical)
migrated: 2026-08-27
updated: 2026-08-26
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

PDF: [assets/2026-08-26_fcc-to-tcg-client-brief.pdf](assets/2026-08-26_fcc-to-tcg-client-brief.pdf).
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
