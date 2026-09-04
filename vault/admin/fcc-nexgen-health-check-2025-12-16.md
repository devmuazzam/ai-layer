---
title: FCC NexGen health check assessment, December 2025 — current state and FCC's roadmap
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/2025-12-16_FCC Health Check Assessment - DRAFT.pdf
migrated: 2026-09-04
updated: 2025-12-16
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, module/all, kind/source, permissions-roles, pricing, scheduling, time-tracking, wtl, craft-code, craft-modifier, per-diem, union-agreement, invoicing, ticket-workflow, purchase-orders, reporting, certifications]
entities: []
---

# FCC NexGen health check assessment, December 2025 — current state and FCC's roadmap

**What this is.** A business-process assessment of TCG's NexGen setup, produced by the vendor
**Fleet Cost & Care** at TCG's request "due to concerns about system underutilization and missed
operational benefits". FCC consultant **Courtney Wagner**, supported by **Brooke Kieffer** and
**Maggie Leigh**, ran a virtual assessment **19–21 November 2025** plus on-site work, combining
system review, staff interviews and process observation. Document dated 2025-12-16, marked
**DRAFT**.

**Why it matters.** It is the most detailed independent description of **how TCG actually
operates today** that exists in the vault — written by people who spent three days watching them
do it, three months before the ERP build started. It names, department by department, which parts
of the workflow live in spreadsheets and text messages rather than in the system, and why payroll
and billing are doing rework. Anyone designing dispatch, e-tickets, payroll or invoicing in the
new platform should read it as the problem statement.

> **Status caution — read this carefully.** This document is **FCC's assessment of how to get more
> out of FCC's own product**, produced by the incumbent vendor whose system TCG has since decided
> to replace. Every "recommendation" is a recommendation to configure or adopt NexGen, not a
> requirement for the new ERP. Its value here is the **observations** — the current state — not its
> roadmap. It is also a DRAFT and nothing in it has been adjudicated.

---

## Executive summary and key findings, as written

Four headline findings:

- **Data & configuration** — core setup and defaults need refinement for reporting accuracy,
  revenue tracking and consistent utilisation metrics.
- **System utilisation** — NexGen screens and features (ATOM, scheduling, E-tickets) are
  "underused or misused, creating inefficiencies and gaps in reporting".
- **Processes** — many workflows rely on spreadsheets or manual entry, producing redundant work
  and inconsistent data across dispatch, payroll and billing.
- **Training** — teams asked for more training and documentation to promote consistency,
  accountability and adoption.

FCC's overall view: the challenges "are not the result of system limitations, but rather stem from
inconsistent usage, incomplete setup, or a lack of shared understanding between field and office
teams."

At the time of assessment TCG was running **NexGen and Atom version 2025.1.1.0, last updated
2 October 2025**.

---

## Current state, by area

### System administration and setup

- **System defaults have not been comprehensively reviewed since initial setup.**
- **Atom License Limit is not enabled**, so the number of devices per Atom user is unmanaged; "Enable
  Auto Log Off Users" also noted.
- **Customer contact defaults do not require an email address.** FCC's argument for requiring both
  phone and email: complete records, and "in the event of a salesperson leaving the business, the
  business would still have full access to the contact(s)".
- **Price lists are not set up to be customer-specific.**
- **POs are generally well-configured** and approval limits are already established. FCC recommends
  enabling **"Lock PO Req Line Items on Approval"** so line items cannot change after approval.
- **Security and profiles.** Several employee profiles are on **System Administrator access**, and
  there are **inactive users** under profiles. FCC recommends limiting sysadmin access and auditing
  inactive accounts once or twice a year.
- **Menu security.** FCC recommends disabling **"Add File Links"** for all profiles in favour of
  "Upload File" only, so users cannot attach drive-letter paths instead of UNC paths and produce
  broken links.
- **Profile screen settings** — several profiles are **View Only for certain reports**, which
  prevents users running them, and **Work Through Lunch (WTL) is disabled for some user groups**.
  FCC calls for field-employee profiles to be confirmed as having access to the labour fields:
  **Work Through Lunch (WTL) · Union Code · Craft Code · Craft Modifier · Classification.**

### Employees and union codes

**Union & non-union pay and billing rates, burden, and workers' comp rates need review.** FCC's
recommendation: refine union code configuration so **overtime, double-time and travel rules apply
automatically**, reducing spreadsheet dependency; update burden codes and workers' comp for
accurate reporting. Maintain Units, by contrast, is assessed as "in good condition" with no
recommendation.

### Sales and quoting

- Sales members **export quotes to email instead of sending them from NexGen**, because of
  Outlook/SMTP profile issues.
- **Sales does not enter job dates at the quoting stage**, so Dispatch assigns them manually after
  conversion. Handoffs between Sales and Dispatch are "inconsistent".
- **Job types require refinement**; several unused or outdated types were inactivated during the
  assessment. Unit type configurations and kit setups still need review.
- **Duplicate billing codes are being used in place of structured price lists** — FCC's back-end
  analysis found this, and names it as a cause of inconsistent job pricing. Mobilization, sub-items
  and trucking charges are priced by manual adjustment.
- **Supporting documents** (lift plans, site layouts, utility notifications, traffic plans, vendor
  details) are attached inconsistently — "attachment practices vary between team members, leading
  to inconsistent information for dispatch and field teams".
- **Quote Profit Forecast is not being used.** Enabling it requires billing codes, burden details,
  equipment costing and rate defaults to be validated first; data inconsistencies (inactive codes,
  outdated rates, placeholder items) currently prevent accurate forecasting.

FCC's process recommendation: **convert quotes to jobs as soon as the customer confirms, assigning
preliminary job dates at that moment**, then hand off to Dispatch for scheduling adjustments.

### Scheduling and jobs — the spreadsheet problem

This is the assessment's central finding.

- Dispatch builds the next-day schedule **one day in advance**, and **an Excel spreadsheet, not
  NexGen, is the primary scheduling tool**. Jobs are converted from quotes, but the day's changes
  are logged on the spreadsheet rather than on the Job screen.
- **Cranes, operators and support personnel are assigned on a colour-coded spreadsheet** that
  duplicates NexGen's Unit and Unit/Employee Schedule views. **Operator qualifications and
  certifications are tracked in NexGen but not used during scheduling.**
- Mechanics, Sales and field staff **rely on daily texted snapshots of the spreadsheet** to learn
  their assignments.
- **The "On Job" status is not used.** It should be applied as soon as a job is dispatched; instead
  dispatch confirms operator acknowledgement by text. Because the transition is never recorded,
  mid-day changes — equipment swaps, added labour, start/stop adjustments, delays, permit needs —
  stay outside the job record until after the fact.
- Consequence, as written: "NexGen does not always reflect real-time job activity, which impacts
  visibility for payroll, billing, and project management."

FCC's recommended job status sequence: **Tentative → Confirmed → Transferred → On Job → Finished**
(a later section gives it as Tentative, Confirmed, On Job, Completed — the document is not
consistent about the middle terms).

File links on jobs are the one thing assessed as working: "being used consistently — no
recommendation, keep current process."

### Invoicing

- AR validates against spreadsheets and Samsara data. **Invoice numbers are manually edited to
  match job codes** instead of using automated numbering.
- **Additional charges are added at invoicing rather than during job setup.**
- **E-tickets are approved by billers with no edits made.** FCC's view is that **dispatch should
  review and approve e-tickets**, because dispatch knows the job.
- **Invoice approvals run by email** — routed to Sales and Operations for internal review, then to
  AP for payment through QuickBooks. "It relies heavily on email tracking with no system record of
  who approved what." FCC recommends the in-system invoice approval workflow, the existing Invoice
  Approval Report, and consistent use of the **"Sales Person Review"** status.

### Labor entry and payroll

The longest section, and the one with the most detail on why payroll is doing rework.

- **Validation responsibility has migrated to payroll.** Dispatch is not consistently approving
  e-tickets or validating timestamps, so payroll staff (**Corrina**) must confirm job durations,
  validate start/stop sequences, review checklist completion, decide whether craft modifiers apply,
  manage missing or incorrect timestamps, and reconcile ATOM against spreadsheets.
- **Emergency jobs are sometimes entered in spreadsheets before NexGen**, creating mismatches
  payroll then reconciles by hand.
- **Operator compliance in ATOM is inconsistent** — customer signatures, accurate timestamps (left
  yard / arrived job) and detailed comments are frequently skipped. "Many operators have never
  received formal ATOM training."
- **Specific ATOM defects named:** overlapping timestamps; missing craft-modifier indicators;
  incorrect labour sequences; **checklists that fail to save if signatures are incomplete**; users
  losing progress when navigating between tabs; JSA signature failures.
- **Misalignments between ATOM workflows and union payroll rules**, specifically: **lunch
  penalties, overtime/double-time boundaries, Friday afternoon rules, and secondary craft codes**
  are "not fully configured", and manual workarounds are required.
- **Classification structure needs rebuilding.** Long-boom modifiers, minimums, overtime boundaries
  and lunch-penalty logic are applied inconsistently; missing or outdated classifications force
  payroll to record employee time after the fact; **some classifications exist only in
  spreadsheets maintained by the payroll team**, risking duplicate or conflicting logic; and there
  are ATOM↔NexGen mismatches when exporting payroll.
- **The NexGen payroll export file is not being used at all.** **Per-diem lines are entered
  manually, several times a week.**
- FCC recommends **adding "Per Diem" as both a craft code and a classification** — stated twice.

> Several of these observations bear directly on the payroll rule register. Cross-check against
> [../payroll/rules/](../payroll/rules/INDEX.md) before treating any of them as a statement of the
> rules themselves — this document describes *configuration failures*, not the underlying
> agreement.

### Purchasing / AP

TCG was trained on site on the purchasing module; Courtney trained multiple sales personnel on
creating POs, including the scenario where **a quote has not yet been converted to a job**. FCC's
recommendation is to document internal procedures and **determine who receives POs**.

### Maintenance and inventory

- Work Orders are actively used but the workflow is inconsistent. **Labour hours, start/stop times,
  estimated hours, parts used, vendor work and completion indicators are not consistently
  captured.** **Activities are not always added to Work Orders**, and when they are, labour and
  parts are not reliably allocated to the correct activity.
- FCC recommends enabling **"Require Activity on WO"** in System Defaults.
- **Work Orders from Deficiencies: "not being used."**

### Storage

A recently implemented module. FCC did additional on-site training on it and recommends a
**three-month review** to gather feedback on configuration and usage.

---

## FCC's three-phase improvement roadmap

Recorded because it names the specific items FCC thought had to be fixed first — several of which
became requirements of the replacement system instead.

**Phase One — system cleanup and configuration review.** Comprehensive cleanup of billing codes,
classifications and union/craft configurations · review and correction of user profiles, screen
settings, menu security and default access · validation of Unit Types, Kits, Job Types and workflow
presets · enable foundational features (Require Activity on WO, labor accordion defaults, PO
locking) · review and document ATOM workflow issues · identify development items — **the
"Check All" checklist request is logged as FCC Case #40325** · begin reducing spreadsheet
dependency.

**Phase Two — role-based training, workflow reinforcement, operational adoption.** Targeted
training for operators, dispatch, sales, mechanics and payroll · reinforce the workflow
**quoting → job conversion → scheduling → On Job → E-ticket → closeout** · **dispatch to validate
and approve timestamps and e-tickets daily before payroll review** · standardise **Job Closeout
reviews between Dispatch and Payroll** · retrain maintenance staff on Work Order requirements ·
shift scheduling and job updates fully into NexGen. Also: **rebuild ATOM workflows —
classifications, checklists, timestamps, craft modifiers, per diem, labor prompts** — in a test
domain first, then deploy to live after TCG validation.

**Phase Three — optimisation, reporting, advanced features.** Roll out Quote Profit Forecast after
billing-code and cost cleanup · dashboards, KPI monitoring and advanced reporting · in-system
invoice approvals · automate craft modifiers, labour rules and OT/DT logic · enhance integration
points (**QuickBooks, Samsara, future HRIS/payroll system**) · multi-day scheduling and eliminate
spreadsheet dispatching · three-month Storage review · **quarterly system review cycles**.

---

## Named individuals

FCC side: Courtney Wagner (lead consultant), Brooke Kieffer (payroll–ATOM interaction review),
Maggie Leigh (union rules). TCG side, named in the text: **Corrina** (payroll). Roles for TCG names
are in [engagement-directory-and-org-charts.md](engagement-directory-and-org-charts.md).

## Source

`1.0.2_FCC-RESOURCES-GUIDES/2025-12-16_FCC Health Check Assessment - DRAFT.pdf` — 57.7 KB of
extracted text via `pdftotext -layout`, laid out as two-column Observations/Recommendations tables
per area, plus an executive summary, a three-phase roadmap and a conclusion. Every area section is
represented above. Page numbers are absent from the extraction (the footer renders as "Page" with
no number).
