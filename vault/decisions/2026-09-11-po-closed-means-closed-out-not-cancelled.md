---
title: PO CLOSED means closed-out, not cancelled — decision
source: decision/Fouzan Shakil
decided: 2026-09-11
decided_by: >-
  Fouzan Shakil (CodingCops), stated 2026-09-11 in a Claude Code review session
  of branch `fix/das-fixes`, in answer to explicit questions. Not a TCG
  client-side product-owner sign-off. Recorded `status: reference` — binding on
  the CodingCops build, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves:
  # parts (a), (b) and the first half of (c); (c) second half, (e), (f), (g) stay open
  - vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap
jira: []
tags: [module/vendors-agencies, module/projects-jobs, kind/decision, purchase-orders, permits]
---

# PO `CLOSED` means closed-out, not cancelled

Gives the `OPEN | CLOSED` vocabulary its meaning and its transitions.
[2026-09-11-outbound-po-subtypes-and-modal-fields.md](2026-09-11-outbound-po-subtypes-and-modal-fields.md)
locked the two words but nothing about what moves a PO between them. What existing rows become is
in the companion note,
[2026-09-11-legacy-po-and-permit-type-remap.md](2026-09-11-legacy-po-and-permit-type-remap.md).

## Decision

Fouzan Shakil, 2026-09-11:

1. **`CLOSED` means closed-out**, i.e. the PO is done. It does **not** mean cancelled.
2. **Closing changes nothing else about the PO.** A closed PO keeps its permit links and its
   `poType`, and it **stays visible on the permit tracker**.
3. **Auto-close.** A PO closes automatically **only** when an attachment in an **Invoice**
   category is uploaded to it. An invoice number on its own does not close it. Archiving never
   closes it.
4. **Auto-reopen.** When the last Invoice-category attachment is removed, the PO goes back to
   `OPEN`.
5. **Explicit control.** There is an explicit **Close / Reopen** control, so a user can move a PO
   either way by hand.
6. **Archive is the path that unlinks permits.** Unlinking is not a side effect of `CLOSED`.

## Why

No reasoning beyond the rule was recorded in the session. The problem it answers is this: the
branch gave `CLOSED` two meanings.

- When an attachment was uploaded, the PO closed (`purchase-orders.service.ts` `activateIfReady`,
  *"invoice attachment closes the PO"*).
- When `CLOSED` was set from the edit form, it was treated as a cancellation. The PO's permits were
  unlinked, `poType` was reclassified to `VENDOR`, and the tracker filtered the PO out as *"the
  cancelled state"*.

So a permit's PO dropped off its tracker card as soon as an invoice was attached. This decision
keeps the first meaning and gives the unlinking to archive.

It fits the only close-out language in the record. This is context, not a source for the rule:
FCC's *"Vouchers are vendor invoices, used to close out purchase orders"*
([../vendors-agencies/fcc-nexgen-purchasing-guide.md](../vendors-agencies/fcc-nexgen-purchasing-guide.md):44,
`unverified`), and Ryan Adams' *"open PO until it's closed out"*
(`meetings/transcripts/2026-03-12-sales-pricing-in-fcc.md` @ 1:16:59, `reference`).

## Effect on the vault

- **Done (gaps):**
  [`../vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap`](../vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap).
  Resolved: (a), (b) and the first half of (c). Still open: the second half of (c), and (e), (f),
  (g).
- **Done (gaps update):**
  [`../projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete`](../projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete).
  An update line records that closing is not cancellation and that archive is the unlinking path.
  The rest of that entry stays open.
- No vault file body or `status:` changes. This is a CodingCops `reference` call, not an
  adjudication between competing TCG sources.

## What this does not settle

- **Whether a `CLOSED` PO may be newly attached to a permit.** The branch removed the guard that
  used to refuse this. The decision covers links that already exist, not new ones.
- **What archiving a permit-linked PO does to the permit**, beyond unlinking it: trackable status,
  approval, and how many POs a permit may have. Still open at
  [`../projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete`](../projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete).
- **Whether a lost quotation closes its POs.** Ryan Adams says it does, on tape, where "closes out"
  means cancellation. That usage no longer matches `CLOSED`. Still open at
  [`../vendors-agencies/gaps.md#purchase-orders-at-three-levels--joe-and-ryan-on-tape-nothing-written`](../vendors-agencies/gaps.md#purchase-orders-at-three-levels--joe-and-ryan-on-tape-nothing-written).
- **Brian Petros's 7-step vendor cycle**
  ([2026-09-05-po-types-and-quote-to-invoice-workflow.md](2026-09-05-po-types-and-quote-to-invoice-workflow.md))
  closes a PO through goods receipt and a three-way match, not through an upload. This is the
  build's rule. It does not reconcile the two.
- Create-time defaults (whether status and valid-till may be left out, and whether PO fee defaults
  to the line total), and what an `ASSET` PO is for: parts (e) and (f) of the gaps entry.
