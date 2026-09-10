---
title: Two PO types and the quote-to-invoice workflow — Brian Petros
source: Brian Petros (TCG), written message + workflow diagram, 2026-09-05
migrated: 2026-09-05
updated: 2026-09-11
status: reference
conflicts_with: []
related_decisions:
  - 2026-09-11-outbound-po-subtypes-and-modal-fields.md
jira: [SCRUM-478]
tags: [module/quotations, module/projects-jobs, module/dispatch, module/vendors-agencies, module/accounting, kind/decision, permits, purchase-orders, invoicing]
entities: [PurchaseOrder, Permit, Quotation, Job, Project, Vendor, Customer, Invoice]
---

# Two PO types, and where each one sits in the quote-to-invoice flow

Stated by **Brian Petros (TCG)** on **2026-09-05**, in a written message with an
accompanying end-to-end workflow diagram. This is the **first named-human statement**
on purchase orders in the vault. Until now every PO source was either an unverified
Confluence page, an unverified meeting record, or CodingCops narrating its own build.

Verbatim:

> "Here is Quote to Job to Invoice workflow (including Permits and both types of POs)...
>
> **PO Type 1 (Customer PO):** Simple and passive on our end... the customer sends it, we
> log it, we put it on the invoice. It shows up at the moment the customer approves the
> quote, and again at invoicing.
>
> **PO Type 2 (Vendor PO):** This is the full 7-step procurement cycle... we are the buyer,
> the vendor is the seller. It kicks off when the Quote is created and/or after the Job is
> created (when third-party services are involved), and loops again if there's a change order."

## The two types

| | **Type 1 — Customer PO** | **Type 2 — Vendor PO** |
| --- | --- | --- |
| Direction | Inbound — customer sends it to us | Outbound — we send it to a vendor |
| Our role | Passive recipient | Buyer (vendor is seller) |
| Purpose | The customer's internal authorization for the job | Procure third-party goods/services |

This confirms **Melissa McNutt's 4 December 2025 email** taxonomy (inbound vs outbound)
and settles it against the competing split in `vendors-agencies/purchase-order.md`
(which divides POs by *what is bought and who owns the process* — permit/vendor POs under
Dispatch vs parts/maintenance POs under the warehouse). Brian's split is by **direction**.

It also **supersedes the `Internal / Customer` pair** in
`meetings/2026-06-22-sprint-4-additional.md:81`, which was never defined.

## Type 1 — Customer PO: three steps

1. **Customer provides their PO #** — their internal authorization for the job
2. **Log it on the job (schedule tab)** — no internal reporting required
3. **Reference it on our invoice** — helps the customer process payment

It surfaces at exactly two moments: **on customer approval of the quote**, and **again at
invoicing**.

**This resolves the open question in `quotations/gaps.md`** — *"Customer PO on the
quotation — which of three things does it mean?"* It is **not** a quotation field. It is
logged on the **job / schedule tab** and printed on the **final invoice**.

## Type 2 — Vendor PO: the 7-step procurement cycle

1. **Requisition** — department submits a request for goods or services
2. **Approval** — management reviews and **checks budget**
3. **PO creation & sending** — formal PO issued and sent to the vendor
4. **Vendor acceptance** — the PO becomes a **legally binding contract**
5. **Fulfillment** — vendor ships goods or performs services
6. **Goods receipt** — we confirm delivery matches the PO
7. **Three-way match & payment** — AP matches PO + invoice + receipt, then pays

Steps 2 and 7 independently corroborate the **budget check** and **three-way match** in the
March 2026 design diagrams (`quotations/quote-lifecycle-permits-and-purchase-orders.md`),
which the vault had flagged as appearing nowhere else.

## Where each PO sits in the flow

The diagram's main path:

```
Create quotation (customer + price list)
  → Add resources & line items (units, third-party services)   ←── Issue vendor PO
  → Submit to customer (digital signature via email)                (OPTIONAL, early,
  → Customer approved?  ── no ──→ Revise quote ──┐                   at quote stage)
        │ yes                                    └──→ back to Add resources
  → Log customer PO #  (record on job / schedule tab)      [TYPE 1]
  → Convert to job (quotation locked in system)
  → Permit required?  ── no ──────────────┐
        │ yes                             │
  → Attach permit (quote or job stage)    │
  → Issue vendor PO  ←────────────────────┘  (via permit, or directly to job)   [TYPE 2]
  → Change order needed? ── yes ──→ Update vendor PO ──→ back to Submit to customer
        │ no change
  → Dispatch & execute (job underway)
  → Invoice & close (customer PO # on final invoice)        [TYPE 1 again]
```

Two rules stated in the diagram legend:

- **"Permit — must precede vendor PO when required."**
- **"Vendor PO issued early (optional, at quote stage)"** — the dashed path from
  *Add resources & line items*.

A vendor PO may therefore be raised **either** at quote stage (optional, early) **or**
after the job exists — and when a permit is required, the permit comes **first**.

## What this settles

| Question | Answer |
| --- | --- |
| PO type taxonomy | **Type 1 Customer (inbound) / Type 2 Vendor (outbound)** |
| Where the customer PO lives | **Job / schedule tab**, and on the final invoice — not the quotation |
| When the customer PO appears | On quote approval, and again at invoicing |
| When a vendor PO is raised | Optionally at quote stage; and/or after job creation for third-party services; again on change order |
| Permit vs vendor PO ordering | The **permit record comes first**, then the vendor PO is raised *"via permit"* — i.e. from it. Consistent with the built generate-PO-from-a-pending-permit path |
| Vendor PO lifecycle | The 7 steps above |

## What this does NOT settle

- **PO status values (partially settled 2026-09-11).** Outbound `PurchaseOrder` statuses used
  in the permit attach/create flow are now locked as **`OPEN` | `CLOSED`** — see
  [2026-09-11-outbound-po-subtypes-and-modal-fields.md](2026-09-11-outbound-po-subtypes-and-modal-fields.md).
  Older vocabularies (`Pending / Confirmed / Paid` in
  `meetings/2026-06-22-sprint-4-additional.md:88`; Ryan Adams' *"open PO until it's closed out"*
  at `meetings/transcripts/2026-03-12-sales-pricing-in-fcc.md` @ 1:16:59) are not fully
  reconciled to a seven-step procurement model, but the shipped two-status set is product-locked
  for the current modal.
- **Whether permit *approval* requires a linked PO.** (Which permit types need a PO at all is
  answered by the 2026-06-18 decision — annual vs single.) The diagram
  has **no permit-approval step at all** — it goes *Attach permit → Issue vendor PO* and moves
  on. So the built gate (approval blocked until a PO is linked) is neither confirmed nor
  contradicted by it. *"Permit must precede vendor PO"* is about the permit record existing
  before the PO is raised from it — which the build already does — not about approval.
  Ehtesham’s 2026-09-11 Loom walkthrough treats PO as **optional** on the current permit form —
  see [2026-09-11-quote-to-project-permits-plans-flow.md](2026-09-11-quote-to-project-permits-plans-flow.md).
- **The `area`, `city`, `PO fee`, `discount %` and `invoice #` fields** now built and mocked
  up. Still unspecified as a full field dictionary. The **locked modal field set** for outbound
  create/attach is PO type, PO number, PO items, Agency (not Vendor), invoice attachment —
  [2026-09-11-outbound-po-subtypes-and-modal-fields.md](2026-09-11-outbound-po-subtypes-and-modal-fields.md).
- **Joe Schacatano's quotation-level / job-level / standalone PO split** and his audit-trail
  requirement (`vendors-agencies/gaps.md`) — the diagram shows quote-stage and job-stage
  vendor POs, which is consistent, but standalone POs and the audit trail are untouched.
- ~~**The vendor-PO sub-type**~~ — **settled 2026-09-11** as outbound `PERMIT` | `VENDOR` |
  `ASSET` in
  [2026-09-11-outbound-po-subtypes-and-modal-fields.md](2026-09-11-outbound-po-subtypes-and-modal-fields.md).
  That is a subtype of Brian’s Type 2 (outbound document), not a replacement for Type 1 vs
  Type 2 direction.

## Conflicts with what is currently built

1. **Approval gating — not contradicted, but not confirmed either.** The shipped system
   blocks permit **approval** until a PO is linked
   (`apps/api/src/usecase/permits/permits.service.ts:202`). Brian's diagram is compatible with
   the *ordering* the build uses (permit record → PO raised via it), but it **never models
   approval**, so it says nothing about whether approval must wait for a PO. The gate's only
   stated source remains CodingCops describing it — `ERP Sprint
   Reviews-20260729_190026UTC-Meeting Recording` at **13:52** (transcript
   `meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md`, speaker turn labelled
   13:18): *"another check automatically system is going to handle that, that PO is required
   before a permit is approved and it's going to show up that error to whoever is dealing with
   the permit tracker."* Brian's reply at 14:09 — *"I love the idea of being able to drag and
   drop to change the status and then plus there's rules tied into it that restricts it"* — is
   praise for rule-gated drag-and-drop in general, not a decision on this rule. The 2026-09-05
   UI mockup carries the same gate verbatim: *"Attach or create a PO before approving this
   permit."* Mockup, build and demo agree; the diagram is silent. **Still needs Brian.**
2. **The vendor-PO sub-type — settled 2026-09-11 for the outbound document.** Brian's Type 1 /
   Type 2 remain two different *objects* (customer-supplied number vs document we issue). The
   subtype dropdown *within* outbound POs is now locked as `PERMIT` | `VENDOR` | `ASSET` —
   [2026-09-11-outbound-po-subtypes-and-modal-fields.md](2026-09-11-outbound-po-subtypes-and-modal-fields.md).
   Older mockup lists (`General / Permit / Asset / Service`, `General / Blanket / Service /
   Rental`) and `meetings/2026-06-22-sprint-4-additional.md:81` *"Internal or Customer"* are
   superseded for that dropdown. Brian's message itself still does not name subtypes; the lock
   is CodingCops PM/designer-directed (`status: reference`).
3. **The travel-permit PO exemption is over-broad.** Its client source is the 2026-06-18
   recording — see
   [2026-06-18-annual-permits-no-po-single-permits-need-po.md](2026-06-18-annual-permits-no-po-single-permits-need-po.md):
   the client rule is **annual permits → no PO; single-job transportation permits → PO**. The
   build exempts both travel types, so `TRAVEL_ANNUAL_PURPLE_PERMIT` is right and
   `TRAVEL_CITY_STREET_PERMIT` is wrong — and the latter is what the quotation's
   `needTravelPermit` flag generates. The mockup's PO-on-Travel-Permit is consistent with the
   client; the build is not.
4. **The customer PO is unbuilt.** `Project.poNumber` and `Job.poNumber` exist but no DTO
   writes them, and `Quotation` has no such column — so the number Brian says must reach the
   invoice currently cannot be captured at all.
5. **Six of the seven vendor-PO steps do not exist** — no requisition, approval/budget check,
   vendor acceptance, goods receipt, or three-way match.

## Asset

Brian's diagram is transcribed in full — every box, edge, legend entry and panel item, plus a
mermaid rendering — at
[meetings/assets/2026-09-05_quote-to-job-to-invoice-po-workflow.md](../meetings/assets/2026-09-05_quote-to-job-to-invoice-po-workflow.md).
**That transcription is the copy of record:** the original is a raster image that was pasted into a
working session rather than supplied as a file, so no `.png` exists in the vault. If the image is
later supplied, file it beside the transcription as
`meetings/assets/2026-09-05_quote-to-job-to-invoice-po-workflow.png` and keep both.
