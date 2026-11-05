---
title: Outbound PO subtypes Permit|Vendor|Asset and PO modal fields — decision
source: decision/Syed Haris after Umer Islam
decided: 2026-09-11
decided_by: >-
  Syed Haris (CodingCops), locked after discussion with Umer Islam (Product
  Designer). Not a TCG client-side product-owner sign-off. Recorded
  `status: reference` — binding on the CodingCops build through the 15 Sep
  2026 deadline, open to being overruled by TCG. PO statuses OPEN|CLOSED also
  demonstrated in Ehtesham Anwar's 2026-09-11 Loom walkthroughs.
status: reference
provenance_note: >-
  Partly superseded 2026-10-29 by decisions/2026-10-29-all-permits-create-permit-modal.md (Syed
  Haris, TCG-132 Q1, `reference`). The locked modal field set (point 2) does not apply to the
  Create Permit modal's nested "Create new" PO, which follows the prototype: PO date, PO fee,
  Description, Invoice, Bill to customer, with no Agency and no PO items. Point 2 stands for the
  other PO screens, which also gain the two new optional PurchaseOrder columns, `po_date` and
  `bill_to_customer`. Points 1 and 3 stand. Recorded by tcg-scrum.
conflicts_with: []
resolves: []
jira: []
tags: [module/vendors-agencies, module/projects-jobs, kind/decision, purchase-orders, permits]
entities: [PurchaseOrder, Permit, Agency, Vendor, Asset]
---

# Outbound PO subtypes: Permit | Vendor | Asset — and the locked modal fields

Settles the **outbound** `PurchaseOrder` subtype dropdown and the fields on the
PO create/attach modal used from the permit/project flow. Orthogonal to Brian
Petros’s **direction** taxonomy (Customer inbound vs Vendor outbound) in
[2026-09-05-po-types-and-quote-to-invoice-workflow.md](2026-09-05-po-types-and-quote-to-invoice-workflow.md).

## Decision

Syed Haris after Umer Islam, locked 2026-09-11:

1. **Outbound PO types (three):** **Permit**, **Vendor**, **Asset** — stored as
   `PoType` = `PERMIT` | `VENDOR` | `ASSET`.
2. **PO modal fields (locked set):**
   - **PO type**
   - **PO number**
   - **PO items**
   - **Agency** dropdown (**not** Vendor)
   - **Invoice attachment** space
3. **PO statuses** in the permit attach / create flow: **`OPEN` | `CLOSED`**
   only (demonstrated in the Ehtesham Loom walkthrough — see
   [2026-09-11-quote-to-project-permits-plans-flow.md](2026-09-11-quote-to-project-permits-plans-flow.md)).

## Cross-link — permit form parity

In the **projects / quote→project artifact flow**, the permit form must surface
**the same fields as this PO modal** (Ehtesham Anwar,
[2026-09-11-permit-classes-job-only-until-sept-15.md](2026-09-11-permit-classes-job-only-until-sept-15.md)
point 5). Agency / items / attachment parity is one citation chain across these
two notes.

## Why

Brian’s 2026-09-05 note settled **direction** (customer-supplied number vs
document we issue) and left the outbound **subtype** and **status vocabulary**
unspecified. The build already carries `PERMIT | VENDOR | ASSET` and
`OPEN | CLOSED`; Haris/Umer lock that as product intent for the modal. The
counterparty on a permit-driven PO is an **agency**, not a vendor picker — hence
Agency on the modal.

## Effect on the vault

- **Done — annotate**
  [2026-09-05-po-types-and-quote-to-invoice-workflow.md](2026-09-05-po-types-and-quote-to-invoice-workflow.md):
  outbound subtype + OPEN|CLOSED status are settled here; Brian’s Customer vs
  Vendor **direction** decision stands unchanged.
- **Done — gaps update** on
  [`../vendors-agencies/gaps.md`](../vendors-agencies/gaps.md) (three-levels /
  taxonomy entry) pointing at this note for outbound subtypes.
- Document kinds vs PO subtypes remain separate — see
  [2026-09-10-permit-create-types-mockup-document-types.md](2026-09-10-permit-create-types-mockup-document-types.md).

## What this does not settle

- Whether Agency is always required for `VENDOR` / `ASSET` PO types (lock is for
  the permit-flow modal field set).
- Brian’s remaining opens: permit-approval gating on a linked PO; Customer PO
  capture on job/schedule; the full 7-step procurement cycle.
- Joe/Ryan standalone PO + quote-lost→PO-closed (still open in vendors-agencies
  gaps).
