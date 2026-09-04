---
title: TCG ERP Request for Proposal — draft v1.0, February 2026
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_ERP_RFP_first-draft-for-review_2026-02-26.docx
migrated: 2026-09-04
updated: 2026-02-26
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, module/all, kind/source, requirements, integrations, architecture, data-migration, union-agreement, certified-payroll, permissions-roles, reporting]
entities: []
---

# TCG ERP Request for Proposal — draft v1.0, February 2026

**What this is.** The Crane Guys' own Request for Proposal for a custom ERP to replace Fleet
Cost & Care NexGen, written by TCG (submission contact: Brian Petros) and marked *DRAFT v1.0*,
*CONFIDENTIAL — For Vendor Use Only*, issue date February 2026, response deadline TBD. It was
written to be sent to several pre-selected vendors; CodingCops is named in it as one of the
vendors already in discussion.

**Why it matters.** With the CodingCops SOW
([codingcops-sow-and-engagement-terms.md](codingcops-sow-and-engagement-terms.md)) this is the
written scope of the whole engagement — the client's statement, in its own words, of what the
platform is for, what it must replace, what it must integrate with, and in what order. Nothing
equivalent was in the vault before this drop.

> **Status caution.** This is a **first draft for review**, not a signed or issued document. The
> response deadline, submission email and phone are placeholders (`TBD`, `[INSERT EMAIL]`,
> `[INSERT PHONE]`). Nothing here has been adjudicated against what was later built. Treat every
> requirement below as *what TCG asked for in February 2026*, not as a settled specification.

---

## Section 1 — Company and project overview

TCG describes itself as a Southern California mobile crane rental and lifting services company
serving construction, infrastructure, industrial and commercial projects, operating a fleet of
mobile cranes and support vehicles, field crews, and an office team covering sales, scheduling,
payroll, invoicing and compliance.

### The problem, as TCG states it

The current operational backbone is **Fleet Cost & Care (FCC) NexGen**, a third-party fleet
management platform built for the crane and lifting industry. The RFP lists five limitations:

- Limited ability to customise workflows and data structures to TCG's business rules.
- Lack of flexibility integrating with modern cloud services (Samsara GPS, QuickBooks Online,
  Microsoft 365).
- Payroll compliance with the **IUOE Local 12** union agreement "requires workarounds rather than
  native support".
- No ability to extend or build on the platform as the business grows.
- Limited control over data ownership and reporting.

### Project vision

A custom, cloud-based ERP that **fully replaces FCC NexGen**. The stated preferred approach is
**phased and modular**: begin with targeted microservices that run *alongside* NexGen, then build
progressively toward full replacement, so that the two can run in parallel during transition.

## Section 2 — Current state

NexGen runs on **Microsoft SQL Server** and is the central operations database. The RFP tabulates
its modules and how TCG uses each:

| Module | Current usage per the RFP |
| --- | --- |
| Employees | Employee records, roles, credentials |
| Units | Mobile crane and support vehicle fleet records |
| Customers | Customer profiles and account management |
| Quotes | Estimate creation, customer approval, job terms/contracts |
| Jobs / Scheduling | Job creation from quotes, crew and equipment scheduling |
| Job Tickets (ATOM app) | Field mobile app (iOS/Android) — time, details, on-site signatures |
| Labor / Payroll | Labor entry from field tickets; IUOE Local 12 compliance required |
| Invoicing / Billing | Invoice generation from completed jobs |
| Maintenance / Work Orders | In-house crane and equipment service and repair tracking |
| Storage / Warehousing | Parts and inventory management |
| Documents & Attachments | File storage linked to jobs, units and customers |
| Safety / Compliance | Regulatory, insurance and safety documentation |
| Permits & Authorizations | FAA permits, city permits, traffic control authorizations |

**Core workflow — quote to cash**, stated as the primary sequence any replacement must replicate:

`1 Sales / Quote → 2 Job Creation → 3 Scheduling → 4 Job Ticket (Field) → 5 Labor & Payroll → 6 Invoicing`

**Other systems in use:** Samsara (GPS fleet tracking and telematics) · QuickBooks Online
(accounting and financial reporting) · Microsoft 365 (email, file storage, profiles/Active
Directory — OneDrive, SharePoint, Teams) · ATOM mobile app (part of NexGen, used by field crews
for job tickets).

**Hardware environment:** no on-premises servers, fully cloud-dependent; workstations a mix of
Windows and Mac (*primarily Mac*); mobile devices iPhones, iPads and Samsung tablets.

## Section 3 — Scope of work, in three phases

### Phase 1 — Foundation and quick wins (microservices)

Standalone modules that can run alongside NexGen and give immediate value:

- **Scheduling & Dispatch** — visual calendar-based crew and crane assignment.
- **Customer & Quote Management** — CRM-style customer records with a quote/estimate builder.
- **Job Ticket / Field App** — mobile-first field interface, replacing the ATOM app.
- **Microsoft 365 Optimization** — assessment and restructuring of M365 usage for document
  governance and security.

### Phase 2 — Core ERP modules

Jobs & Operations (full job lifecycle linked to quotes, crews, equipment) · Labor & Payroll (time
entry, IUOE Local 12 compliance, payroll export to ADP/Paychex or equivalent) · Invoicing &
Billing (generation, recurring billing, payment tracking) · Maintenance & Work Orders (service
tracking, repair history, parts inventory) · **Purchasing — PO workflow with up to four approval
levels**, vendor invoices, inventory costs.

### Phase 3 — Advanced and compliance modules

Safety & Compliance · Permits & Authorizations (FAA, city/traffic control, tracking and renewals)
· Document Management · Reporting & Analytics (operations, finance and executive KPI dashboards).

### Required integrations

| System | Integration type | Priority |
| --- | --- | --- |
| QuickBooks Online | Bi-directional sync for invoices, payments, GL | High |
| Samsara | GPS/telematics pull for vehicle hours and location | High |
| Microsoft 365 | SSO, user directory, document storage (SharePoint/OneDrive) | High |
| ADP / Paychex | Payroll export from approved labor records | High |
| FCC NexGen (SQL Server) | Data migration from the existing database | One-time |

## Section 4 — Key requirements

**Functional, must-have.** Complete quote-to-cash workflow · union-compliant payroll with full
support for IUOE Local 12 rules (overtime, classifications, pay codes) · mobile-first field app
replacing ATOM, iOS and Android, **works offline**, supports e-signatures · role-based access
control by department/role (dispatcher, field tech, manager, accounting, exec) · equipment
lifecycle tracking including maintenance history, GPS hours and certifications · permit and
compliance tracking with expiration dates, renewals and document uploads · real-time visual
scheduling calendar for crew and equipment · document management with attachments linked to jobs,
units, customers and employees.

**Technical, must-have.** Cloud-hosted with no on-premises infrastructure · full functionality on
Mac, Windows, iOS and Android · a modern but *not bleeding-edge* stack ("stable, widely-supported
frameworks") · modular/microservices architecture with independently deployable modules ·
API-first design · encryption at rest and in transit, role-based access, **audit logging** · full
data migration from the FCC NexGen SQL Server database · Microsoft 365 integration with **SSO via
Azure AD** and SharePoint/OneDrive for document storage.

**Nice to have.** Executive dashboard with real-time KPIs (revenue, active jobs, fleet
utilisation) · automated permit renewal reminders and expiration alerts · **customer portal for
quote approval and invoice review** · DocuSign or similar for digital signatures · AI-assisted
scheduling optimisation · GPS map view of active cranes and jobs.

## Section 5 — User base

| User type | Primary functions | Access method |
| --- | --- | --- |
| Sales / Estimating | Quotes, customer management, job terms | Desktop (Mac/Windows) |
| Dispatch / Operations | Scheduling, job management, job monitoring | Desktop + tablet |
| Field Crew (Operators) | Job tickets, time entry, signatures, safety checklists | iPhone / iPad / Samsung tablet |
| Mechanics | Work orders, maintenance records, parts usage | Desktop + tablet |
| Accounting / Billing | Invoicing, payroll review, QuickBooks sync | Desktop (Mac/Windows) |
| Management / Executives | Reporting, approvals, KPI dashboards | Desktop + mobile |
| IT / Admin | User management, system configuration, integrations | Desktop |

## Section 6 — Proposed timeline

Offered as "a suggested framework"; vendors were invited to propose alternatives, with final
dates to be agreed after selection.

| Phase | Target timeframe | Milestone |
| --- | --- | --- |
| RFP & vendor selection | Q1 2026 (Feb–Mar) | RFP distributed, responses received, vendor selected |
| Discovery & architecture | Q2 2026 (Apr–May) | Requirements deep-dive, architecture finalised, M365 assessment delivered |
| Phase 1 development | Q2–Q3 2026 (May–Aug) | First microservices live: Scheduling, Field App, Customer/Quote |
| Phase 2 development | Q3–Q4 2026 (Sep–Nov) | Jobs, Labor/Payroll, Invoicing, Maintenance, Purchasing |
| Data migration & testing | Q4 2026 (Nov–Dec) | Full migration from NexGen, UAT with key users, parallel running |
| Phase 3 & full go-live | Q1 2027 | Advanced modules, compliance/permits, full NexGen replacement |

## Sections 7–9 — Commercial and evaluation

**Budget.** No fixed ceiling set at RFP stage. Vendors asked for a phase-by-phase cost breakdown,
ongoing support/maintenance estimates, third-party licensing fees, and an hourly or blended rate
for change orders. TCG states it wants "a long-term development partner, not a one-time project
engagement".

**Evaluation weighting.** Technical approach & architecture 25% · relevant industry experience
20% · proposed timeline & phasing 15% · cost & value 15% · team qualifications 10% · references &
prior work 10% · support & long-term partnership 5%.

**Proposal contents required.** Executive summary · technical approach · scope response ·
phase plan · cost proposal · team overview · two to three references · questions and assumptions.

## Section 10 — Additional context

- **Vendor meetings and NDA.** TCG was meeting a small number of pre-selected vendors; all had to
  sign an NDA before receiving detailed system access or data samples. (The template is
  [codingcops-sow-and-engagement-terms.md](codingcops-sow-and-engagement-terms.md).)
- **Existing vendor discussions.** CodingCops is named as one of the vendors under evaluation,
  and the phased-microservices strategy is described as having been discussed with them and as
  TCG's *preferred* path — other vendors were told to reflect it.
- **Data migration.** The NexGen SQL Server database holds "years of historical operational data";
  any replacement must include a migration plan, and vendors were asked to identify what can be
  migrated, in what form, and what the risks and gaps are. See
  [fcc-nexgen-database-catalogue.md](fcc-nexgen-database-catalogue.md) for what that database
  actually contains.
- **Union payroll compliance — stated as non-negotiable.** Payroll must comply with the labor
  agreement between the **International Union of Operating Engineers, Local Union No. 12 (IUOE
  Local 12)** and **Mobile Crane Operators Group, Inc.** Vendors had to demonstrate a clear plan
  for the specific pay rules, classifications and compliance tracking that agreement requires.
- **Long-term partnership expectation.** TCG explicitly says it is not looking for a build-and-walk
  -away vendor and asked proposals to address post-launch support.

---

## What this document does *not* say

- It does not name a budget, a response deadline, or a submission address — all are placeholders.
- It does not state which of the "nice to have" features were later accepted; the RFP lists them
  as optional only.
- It does not define any of the union rules it calls non-negotiable — it names the agreement and
  requires compliance, nothing more. The rules themselves are in
  [payroll/rules/](../payroll/rules/INDEX.md) and
  [erp-review-log.md](../erp-review-log.md).
- It does not say whether TCG issued this draft to anyone, or whether a later version exists.

## Source

`1.0.1_BUSINESS-REQUIREMENTS/TCG_ERP_RFP_first-draft-for-review_2026-02-26.docx` — 16.6 KB as
converted text, ten sections, converted via pandoc to GitHub-flavoured Markdown. Every section is
represented above; the section tables are reproduced in full.
