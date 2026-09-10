---
title: Vendors Agencies — module index
status: reference
kind: index
updated: 2026-09-04
tags: [module/vendors-agencies, kind/reference]
---

# Vendors Agencies

Vendors, agencies, purchase orders. Backend usecases: `vendors, agencies, purchase-orders`. Organized per [STRUCTURE.md](../STRUCTURE.md).

> **Conflict stub first:** [agencies-vendors-INDEX.md](agencies-vendors-INDEX.md) — competing sources, none verified. Do not answer from a single document while it is non-empty.

> **Second, unrelated conflict — purchase orders.** Two unverified sources define "the two PO
> types" incompatibly: [purchase-order.md](purchase-order.md) splits them by what is bought and
> who owns the process (permit/vendor — Liz Lopez; parts/maintenance — Jeff Stricker), while
> Melissa McNutt's email of 4 December 2025 splits them by direction (the PO the customer gives
> us; the PO we give vendors). Set out in
> [purchase-orders-fcc/INDEX.md](purchase-orders-fcc/INDEX.md) → *Stated conflict*. This is
> separate from the agencies/vendors stub above and has no stub of its own.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [agencies-vendors-INDEX.md](agencies-vendors-INDEX.md) | **Which source is authoritative?** (none) | 1.9 |
| [vendors.md](vendors.md) | Vendor directory and search, from Dispatch Manager's view | 3.7 |
| [agencies.md](agencies.md) | Agencies as a directory that auto-populates permit forms | 1.0 |
| [agencies-module.md](agencies-module.md) | Agency UI punch list + cross-app items | 1.4 |
| [agency-and-vendor.md](agency-and-vendor.md) | 8-line punch list: sub-contractor category, travel restrictions | 0.2 |
| [purchase-order.md](purchase-order.md) | Purchase order handling — **future-ERP** design, permit-tracker driven | 7.7 |
| [purchase-orders-fcc/](purchase-orders-fcc/INDEX.md) | **Current-state FCC POs.** The Dec-2025 draft P&P set — quote-anchored pre-job POs, AP vouchering, retro-linking to the job — plus the FCC walkthrough and the commissioning email. Carries the *two PO types* conflict | 36.7 (6 files) |
| [fcc-nexgen-purchasing-guide.md](fcc-nexgen-purchasing-guide.md) | What NexGen itself supports: requisition → approval limits → PO → receiver → voucher, PO variance, Export OK | 14.2 |
| [outside-trucking-piazza-invoice-sop.md](outside-trucking-piazza-invoice-sop.md) | Piazza invoice → FCC customer invoice, with the 10% / $35 / $58.50 mark-up arithmetic | 5.5 |
| [sub-out-crane-and-trucking.md](sub-out-crane-and-trucking.md) | Subbing a job out to another crane or trucking company — approved-vendor gate, what the sub is sent, dispatch sheet (also `module/dispatch`) | 7.0 |

## The 2026-09-04 Project Repository drop

Twelve files on purchase orders and sub-out landed in that drop. They added nine pages — the
six in `purchase-orders-fcc/` and the three module-level files above — and two banners plus a
Related section on `purchase-order.md`. Three of the twelve produced no page: an images-only
PPTX with no text layer, a byte-identical duplicate of the NexGen PO Requisition PDF, and the
walkthrough that PO-001 and the sales-PO example share verbatim (recorded once). The dividing line worth remembering:
**`purchase-order.md` is the ERP we are building; `purchase-orders-fcc/` is FCC as it runs
today.** Both are unverified and they disagree about PO types.

## Decisions that bind this module

- [2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) — Archive replaces delete, app-wide — decision
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20
- [2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md) — Brian Petros: Customer (inbound) vs Vendor (outbound) PO direction taxonomy
- [2026-09-11-outbound-po-subtypes-and-modal-fields.md](../decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md) — Outbound PO subtypes Permit|Vendor|Asset; modal fields (Agency not Vendor); OPEN|CLOSED

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

6 meeting files carry `module/vendors-agencies` — list them:

```
grep -rl 'module/vendors-agencies' vault/meetings/
```
