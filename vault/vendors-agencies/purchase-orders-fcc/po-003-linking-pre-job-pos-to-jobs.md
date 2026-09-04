---
title: P&P PO-003 — Linking pre-job POs to jobs after job creation
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/P&P – PO-003 – Linking Pre-Job POs to Jobs After Job Creation.docx
migrated: 2026-09-04
updated: 2025-12-01
status: unverified
conflicts_with: []
jira: []
tags: [module/vendors-agencies, module/accounting, module/projects-jobs, kind/sop, purchase-orders, invoicing]
entities: []
---

# P&P PO-003 — Linking pre-job POs to jobs after job creation

**What this is.** The third of the three draft P&Ps written by Brian Petros and circulated
1 December 2025 (see [commissioning-email-thread.md](commissioning-email-thread.md)). It
closes the loop opened by [PO-001](po-001-pre-job-purchase-orders.md): a PO was raised
against a Quote Number because no Job existed; the Quote has now become a Job; someone has to
go back and put the Job Number on the PO detail lines so the cost lands on the Job. Draft;
Effective Date not stated.

| Field | Value |
| --- | --- |
| Policy ID | PO-003 |
| Owner | Accounting (AP), with support from Sales & Dispatch |
| Systems | FCC / NexGen |

## Scope and triggers

Applies whenever a Quote is converted to an FCC Job **and** prior POs were created using the
Quote Number instead of a Job Number.

The procedure is triggered when a new Job is created or scheduled from a Quote **and** there
is known or likely use of pre-job permits, traffic control (Roadway, RCS, etc.), or
trucking/staking (Piazza, etc.) ordered before Job creation.

> The trigger is a human judgement ("known or likely use"), not a system event. The document
> does not say what system signal, report or queue surfaces the trigger; it relies on the
> notification duty below.

## Roles

- **Sales / Dispatch (originators)** — when a Job is created from a Quote, they must notify
  AP with the **Quote Number**, the **new Job Number**, and the **expected vendors** (Roadway,
  RCS, Piazza, permit vendors).
- **AP / Back office** — find all POs tied to that Quote and update them with the Job Number
  on the detail lines.
- **AR / Billing** — use the POs on the Job screen to ensure subs are billed correctly before
  final invoicing.

## Procedure — find and link POs to a new job

**Step 1 — Gather inputs.** From Sales/Dispatch obtain the Quote Number, the Job Number, and
the vendors known to have been used pre-Job.

**Step 2 — Search for POs in FCC.** In PO search, search by Vendor + Quote Number (in the
Comments/Header), and/or a date range around the quote and the scheduled job, and/or Vendor
Order # if known from the vendor invoice. Identify all POs that reference the Quote Number
**and** belong to that customer/project.

**Step 3 — Update POs with the Job Number.** Open each PO; on each applicable **Detail line**
enter the Job Number in the Job field; save. *If invoices were already vouchered against the
PO*, confirm that job-cost reporting now shows those amounts under the correct Job.

**Step 4 — Verify on the Job screen.** Open the Job in FCC and confirm the POs now appear
under the Job for cost visibility, and that AR will see them when preparing invoices.

**Step 5 — Tracking and cleanup.** If a **Pre-Job PO log** is maintained (the document calls
this "recommended", not required), mark each PO **"Job Linked – [Job Number]"**. Periodically
review any remaining POs that carry a Quote Number but no Job Number and establish whether
the Job was **cancelled, never booked, or still pending**, working with Sales/Dispatch to
resolve.

## Controls

- **Periodic audit** — run a report for POs with Quote Numbers in comments but **no Job
  Number on detail lines**; follow up with Sales/Dispatch to link or close out. The document
  does not name the report or set an audit frequency.
- **AR check** — for larger Jobs (the document's example is "Edison projects with heavy
  subs"), AR should confirm all known sub POs appear on the Job before final billing.

## What this document does not say

- It does not say who maintains the Pre-Job PO log, or where it lives — it is only
  "recommended".
- It does not say what to do with a quote-only PO whose Job was cancelled, beyond
  "resolve" it with Sales/Dispatch.
- It relies on searching the PO **Comments** field for the Quote Number; the commissioning
  email thread records Melissa McNutt's concern that in-house comments do not surface on
  reports, which would make Step 2's search hard to run in bulk. See the caveat block in
  [PO-001](po-001-pre-job-purchase-orders.md).

## Source

`1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/P&P – PO-003 – Linking Pre-Job POs to Jobs After Job Creation.docx`
— .docx converted to GFM by pandoc, ~3.8 KB of text, no images.
