---
title: Purchase orders in FCC — the December 2025 P&P set
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/
migrated: 2026-09-04
updated: 2025-12-04
status: unverified
conflicts_with: [vendors-agencies/purchase-order.md]
jira: []
tags: [module/vendors-agencies, module/accounting, module/dispatch, kind/index, purchase-orders, invoicing]
entities: []
---

# Purchase orders in FCC — the December 2025 P&P set

**What this is.** Five pages migrated from the `TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)`
folder of the 2026-09-04 Project Repository drop. Together they are the most detailed account
the vault holds of how a purchase order actually moves through TCG today: raised by Sales or
Dispatch against a **Quote Number** before a Job exists, vouchered by AP against that
quote-only PO, then retro-linked to the Job so AR can bill the customer.

**All of it is current-state FCC / NexGen procedure, and all of it is draft.** Brian Petros
wrote the three P&Ps on 1 December 2025 and sent them out to be "picked apart"; every one
leaves its Effective Date as `[fill in]`. Nothing in the drop shows them being approved.

## Why this is a separate folder from `purchase-order.md`

[../purchase-order.md](../purchase-order.md) came from Confluence and describes the **future
ERP**: a Permit Tracker that detects a permit requirement from crane size, quote checkboxes
and city rules, drops a permit record into Liz's queue, and generates the PO from a **Create
PO** button that copies the permit data across and later back-fills the final cost. That is a
design for a system that does not exist yet.

These five pages describe the **system in use now**, with its manual comments-field anchor
and its manual retro-linking step. Folding them into one page would make it impossible to
tell which sentences are a description of today and which are a requirement for tomorrow. So
they sit side by side, cross-linked, and the divergence between them is recorded rather than
resolved.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [po-001-pre-job-purchase-orders.md](po-001-pre-job-purchase-orders.md) | Who raises a pre-job PO, when, and exactly what goes in which field | 7.9 |
| [po-002-vendor-billing-and-customer-invoicing.md](po-002-vendor-billing-and-customer-invoicing.md) | How AP vouchers against a quote-only PO, and how AR holds billing with "Not OK to Export" / "Waiting on Sub" | 5.9 |
| [po-003-linking-pre-job-pos-to-jobs.md](po-003-linking-pre-job-pos-to-jobs.md) | How a pre-job PO gets the Job Number after the quote converts, and how the backlog is audited | 4.7 |
| [fcc-po-entry-walkthrough.md](fcc-po-entry-walkthrough.md) | The click-by-click FCC path, quote → PO → job, with the two anchors (Comments box vs Detail Job Number) | 4.2 |
| [commissioning-email-thread.md](commissioning-email-thread.md) | Who asked for these, why, Melissa's own PO-type definitions, and the objection nobody answered | 7.8 |

## Stated conflict — "the two PO types" means two different things

**The vault cannot currently answer "what are the two types of PO?".** Two unverified sources
use the same phrase for incompatible taxonomies. Do not answer from either alone, and do not
merge them.

| Source | Its "Type 1" | Its "Type 2" | Splits POs by |
| --- | --- | --- | --- |
| [../purchase-order.md](../purchase-order.md) — Confluence, from a 18 June meeting | **Permit & Vendor POs**, owner **Liz Lopez (Dispatch)**: city transportation permits, permit agencies (Quality Permits), encroachment permits, sub haulers (Piazza), third-party crane companies (Bragg, Hydraulic), engineered lift plans | **Parts & Maintenance POs**, owner **Jeff Stricker (Warehouse/Mechanics)**: crane parts and maintenance supplies | what is being bought, and which department owns the process |
| [commissioning-email-thread.md](commissioning-email-thread.md) — Melissa McNutt, 4 December 2025 | *"The PO the customer gives to us. This goes on the schedule job tab- we do not need this for any reporting. We just need it on our invoices for the customer to reference for payment on their side."* | *"The PO that we give to our vendors to track our job cost / billing accurately – The Salesmen would need to reference the quote number within the PO screen."* | direction — inbound customer PO vs outbound vendor PO |

Read across, the two are not variants of one scheme: the Confluence pair are **both** outbound
POs, so both of them are subsets of Melissa's Type 2, and Melissa's Type 1 — the customer's own
PO number — has **no counterpart at all** in the Confluence page. Conversely the Confluence
page's department-ownership split (Liz vs Jeff) is absent from Melissa's account.

Neither source is verified. The Confluence page is a meeting write-up of unknown authorship;
Melissa's is an email in which she says of her own account *"This is by no means an SOP just a
quick over view"* and defers to Sammy. What has **not** been established anywhere in the drop:
whether these are two genuinely different classification schemes both in live use, whether one
supersedes the other, or whether "Type 1 / Type 2" is simply informal shorthand that two
different people reached for independently. **A human has to settle this.**

## Related

- [../fcc-nexgen-purchasing-guide.md](../fcc-nexgen-purchasing-guide.md) — what the FCC/NexGen
  system itself supports: requisition → approval limits → PO → receiver → voucher, and the PO
  Variance control. The P&Ps here describe TCG's use of a subset of it.
- [../outside-trucking-piazza-invoice-sop.md](../outside-trucking-piazza-invoice-sop.md) — the
  sample SOP Melissa attached as the format model, and the only source in the drop carrying
  the Piazza mark-up arithmetic.
- [../sub-out-crane-and-trucking.md](../sub-out-crane-and-trucking.md) — Dispatch's side of
  the same transaction: what happens before the PO number exists, when a job is subbed out.

## Source

`1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/` — four .docx (pandoc
GFM) and one 1.6 MB .msg (UTF-16 string scan; `extract_msg` unavailable). The folder's fifth
file, `User Guide - NexGen - PO Requisition .pdf`, is a byte-identical duplicate of the copy
in `1.0.2_FCC-RESOURCES-GUIDES/` and is covered by
[../fcc-nexgen-purchasing-guide.md](../fcc-nexgen-purchasing-guide.md). No screenshots from
any of these files were converted.
