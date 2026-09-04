---
title: P&P PO-002 — Using pre-job POs for vendor billing and customer invoicing
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/P&P – PO-002 – Using Pre-Job POs for Vendor Billing & Customer Invoicing.docx
migrated: 2026-09-04
updated: 2025-12-01
status: unverified
conflicts_with: []
jira: []
tags: [module/vendors-agencies, module/accounting, kind/sop, purchase-orders, invoicing, permits]
entities: []
---

# P&P PO-002 — Using pre-job POs for vendor billing and customer invoicing

**What this is.** The second of the three draft P&Ps written by Brian Petros and circulated
1 December 2025 (see [commissioning-email-thread.md](commissioning-email-thread.md)). Where
[PO-001](po-001-pre-job-purchase-orders.md) tells Sales and Dispatch how to raise a pre-job
PO, PO-002 tells **Accounting** what to do with it: how AP vouchers a vendor invoice against
a PO that has no Job Number yet, and how AR holds customer billing while waiting on
subcontractor bills. Draft; Effective Date left as `[fill in]`.

| Field | Value |
| --- | --- |
| Policy ID | PO-002 |
| Owner | Accounting (AP & AR) |
| Systems | FCC / NexGen, QuickBooks (current), Sage (future) |
| Effective Date | `[fill in]` — never set in the draft |

Scope: invoices from traffic control (e.g. Roadway, RCS), trucking / staking (e.g. Piazza),
and permits and similar pre-job services.

> The frontmatter "Systems" line is the drop's clearest statement that **QuickBooks is the
> current accounting export target and Sage is the future one**. The document does not say
> when the move happens or what it depends on.

## Key rules

1. **The PO is the control document.** All subcontractor invoices must be matched to a PO.
2. **Quote-anchored POs are valid even if no Job exists yet.** AP may receive/voucher
   invoices against POs that carry only a Quote Number, provided the vendor is correct, the
   description matches, and the Quote Number is present.
3. **Use the correct GL and department mappings.** Traffic Control and Permits must map to
   **Subcontractor Expense** — explicitly *not* "LLC Safety". The document says "department
   codes must be cleaned up to support this", i.e. it records the mapping as a known defect
   still to be fixed; it does not say who owns that cleanup or when it is due.
4. **Status "Not OK to Export" controls customer billing when waiting on subs.** If AR is
   waiting for subcontractor bills to match to a PO, AR must set the customer invoice status
   to **"Not OK to Export"** and use a status such as **"Waiting on Sub"** for reporting.

## AP procedure — a vendor invoice arrives, pre-job or early in the job

**Step 1 — Identify the PO.** Read the vendor invoice for a PO Number (ideal), the vendor's
Estimate/Quote # (which lives in the **Vendor Order #** field in FCC), or a customer Quote
Number if indicated. Then search the FCC PO module by PO Number, **or** Vendor + Vendor
Order #, **or** Vendor + Quote Number (from the PO comments).

**Step 2 — Confirm the PO.** Verify the vendor matches, the description aligns (Trucking,
Traffic Control, Permit), and the amount is within the expected range against the PO
estimate.

> **If no matching PO is found**, AP contacts the originating Sales or Dispatch person, who
> **creates the PO retroactively using the Quote Number** and gives the PO Number back to AP.
> This is the drop's only statement that retroactive PO creation is sanctioned rather than
> an exception.

**Step 3 — Receive and voucher.** Open the PO in FCC; receive the appropriate
quantity/amount against it; voucher the vendor invoice, charging the correct
subcontractor/permit GL and department per the corrected mapping. If a Job exists and is
already on the PO detail, confirm the job cost is flowing to the Job. If the Job does not
exist yet, **it is acceptable that the Job Number is blank at this stage** — the Quote Number
plus PO will be used later to link to the Job, per
[PO-003](po-003-linking-pre-job-pos-to-jobs.md).

## AR procedure — customer invoicing with related POs

**Step 1 — Invoice readiness.** AR only sees tickets after Dispatch/Payroll has approved
them. By the time a ticket reaches **"Tickets Not Invoiced"**, it is *assumed fully correct*.

**Step 2 — Check for POs on the Job.** Open the Job in FCC and confirm whether any POs are
linked (subcontractor costs). If yes, ensure vendor bills have been received/vouchered
against those POs. If no POs are linked but AR knows subs were used, reach out to
Sales/Dispatch and AP to confirm POs and invoices.

**Step 3 — Holding invoices when waiting on subs.** Mark the invoice **"Not OK to Export"**,
set a status such as **"Waiting on Sub"** or **"Waiting on Approval"**, and use that status
for backlog reporting.

**Step 4 — Invoice approval workflow (Sales).** Use the **Invoice Approval** feature: drop
the salesperson's name into the approval field; they run a report of invoices awaiting their
approval and click **Approve** in the system — "no more 'text approval' threads". Once
approved and subs are reconciled, set the invoice to **"OK to Export"** so it flows to
accounting (QuickBooks/Sage).

## What this document does not say

- It does not list the full set of customer-invoice statuses, only that "Not OK to Export"
  and "OK to Export" are the two that gate the accounting export, and that "Waiting on Sub"
  and "Waiting on Approval" are *examples* of holding statuses ("a status such as").
- It does not say who may set "OK to Export", nor how the Invoice Approval feature routes to
  the right salesperson.
- It does not say what happens if a Job is cancelled after AP has already vouchered against a
  quote-only PO. PO-003's cleanup step touches the neighbouring case but not this one.

## Source

`1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/P&P – PO-002 – Using Pre-Job POs for Vendor Billing & Customer Invoicing.docx`
— .docx converted to GFM by pandoc, ~4.7 KB of text, no images.
