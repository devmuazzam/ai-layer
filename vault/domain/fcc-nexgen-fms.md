---
title: FCC / NexGen FMS
type: glossary
status: reference        # not a migrated SOP; orientation only
source: team (Haris) + public web (fleetcostcare.com) — NOT a migrated doc; extended 2026-09-04 with FCC's own documentation from shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/ and 2.0.1_DATABASE-SCHEMA/
updated: 2026-09-04
tags: [module/admin, kind/reference, fcc, nexgen, atom, legacy-system]
---

FCC = Fleet Cost & Care, the Detroit fleet-management software vendor
(affiliate of the JJ Curran Crane Company) whose products this platform
is a from-scratch rebuild of.

- NexGen (a.k.a. NexGen FMS): FCC's desktop system — the application the
  business used before this platform. Covers dispatch, scheduling,
  quoting, invoicing, fleet maintenance, purchasing, parts/service,
  accounting, and safety/certification management.
- Atom: FCC's companion mobile app (work orders, labour entry, on-site
  signatures, safety checklists). This platform's Expo app corresponds
  to it — see field-ops/atom-mobile-app-user-stories/.

When "FCC" appears in a ticket or doc, it refers to this legacy system.


## Where the detail is — added 2026-09-04

- **The tables themselves, with real types and row counts** — 40 of FCC's core tables as SQL Server DDL, plus the nightly incremental ETL that copies them and the full rows of the small lookups (ticket status, checklists, craft modifiers, job/department codes): [../payroll/tcg-rawfms-staging-database/INDEX.md](../payroll/tcg-rawfms-staging-database/INDEX.md) (restored from the 2026-06-23 backup on 2026-09-04).

The 2026-09-04 Project Repository drop brought FCC's own documentation of NexGen. Four `admin/`
pages now hold it. **They do not change the rule below**; they are background for the rebuild.

| Page | Answers |
| --- | --- |
| [../admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md) | How NexGen's four-layer permission model works — Profiles, Menu Security, Profile Screen Settings, Users — and how NexGen changes reach Atom |
| [../admin/fcc-nexgen-health-check-2025-12-16.md](../admin/fcc-nexgen-health-check-2025-12-16.md) | How TCG actually uses (and works around) the system today — FCC's own November 2025 assessment |
| [../admin/fcc-nexgen-database-catalogue.md](../admin/fcc-nexgen-database-catalogue.md) | What is in the `NexGenFMS` SQL Server database — 444 tables, 248 views, 8.5 M rows — and the migration classification scheme |
| [../admin/fcc-nexgen-reporting-catalogue.md](../admin/fcc-nexgen-reporting-catalogue.md) | Which reports NexGen ships, by module |

Two further pages carry FCC-originated reference data:
[../admin/fcc-activity-code-master-list.md](../admin/fcc-activity-code-master-list.md) (work-order
activity codes) and the version facts below.

**Versions, from those documents.** TCG ran **NexGen and Atom 2025.1.1.0**, last updated
2 October 2025 (FCC health check). The modernised "WPF" screens — `Schedule > Job – WPF`,
`Invoices – WPF`, `Billing Codes – WPF` — began arriving in NexGen **2020.4.0.0** and are enabled
per-system by a feature flag that hides the legacy screens. Atom's Android build documented in the
drop is 2021.2.4.0.

NOT a requirement source. This entry resolves the term only. It records
what NexGen and Atom are, not how they behave. No spec may cite
"FCC/NexGen does X" as the basis for a requirement unless that behaviour
is written down in the vault or a ticket. Orientation, not spec content.

## FCC's own map of itself — the NexGen Quote-to-Cash Workflow (read 2026-09-04)

`1.0.2_FCC-RESOURCES-GUIDES/DIAGRAM_NexGen_Quote-to-Cash_Workflow.png` is Fleet Cost & Care's
marketing one-pager — a seven-segment arc. It is the vendor's statement of what the product
covers, in the vendor's order, and is useful as the shortest correct description of the system
TCG is leaving:

| # | Module | Vendor's bullet list |
| --- | --- | --- |
| 01 | **Sales/Quoting** | Estimate · Customer Approval · Job Terms/Contract · Track Quote · Salesman Task Management · DocuSign Interface · Mobile App Access · Store/Share Files |
| 02 | **Jobs/Operations** | Schedule People/Equipment · Monitor Jobs Real Time · Unit/Employee Schedule Displays · Generate Electronic Tickets |
| 03 | **Field Ops/Atom** | iOS or Android · Tablets or Phones · E-Ticket Access · Complete Safety Checklist · Customer Signatures on Job Site |
| 04 | **Invoicing** | Reduce Barrier to Collecting Payments · Utilize Completed E-tickets for Invoice Creation · Recurring Invoicing · Service Invoicing · Mobile App Access · Store/Share Files |
| 05 | **Maintenance** | Work Orders · Preventive Maintenance · GPS Interface for Hours/Miles · Complete Repair History · Deficiency Tracking/Resolution · Mobile App Access · Store/Share Files |
| 06 | **Labor/Payroll** | Automated Entry of Labor from Atom · Automated Application of Union Rules · Interfaces with Major Payroll Processors (ADP, Paychex, etc.) · Labor Review & Approval Workflow · Mobile App Access · Store/Share Files |
| 07 | **Purchasing** | PO Req > PO > Receiver · PO Approval Levels (up to 4) · Vendor Invoice · Cost to Job/WO/Unit/Ovhd · Strict Purchasing Controls · Inventory Tracking Capability · Mobile App Access · Store/Share Files |

Two claims on it bear directly on this project: **"Automated Application of Union Rules"** under
Labor/Payroll — which TCG demonstrably does *not* rely on, since it runs payroll through a
separate Excel/ADP process ([../payroll/adp-sop-v3.8.md](../payroll/adp-sop-v3.8.md)) — and **"PO
Approval Levels (up to 4)"** under Purchasing, of which TCG's requisition screen shows two
([../vendors-agencies/purchase-orders-fcc/fcc-po-entry-walkthrough.md](../vendors-agencies/purchase-orders-fcc/fcc-po-entry-walkthrough.md)).
