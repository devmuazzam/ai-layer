---
title: Accounts Payable / Accounts Receivable value engine — the flow as TCG drew it
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_ACCOUNTS_PAYABLE_2025-08-16.pdf (also under TCG_Value_Engine_SAMPLES-ONLY/…/FLOWCHARTS_VALUE_ENGINES/, identical) and .../zz_ARCHIVE/AP_AR_Flow_from_whiteboard (1).xlsx
migrated: 2026-09-04
updated: 2025-08-16
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/vendors-agencies, module/dispatch, kind/source, invoicing, purchase-orders, reporting, ticket-workflow]
entities: []
---

# Accounts Payable / Accounts Receivable value engine — the flow as TCG drew it

**What this is.** Two renderings of one process map, both TCG-produced:

- **`TCG_VE_ACCOUNTS_PAYABLE_2025-08-16.pdf`** — a **Visio "value engine" flowchart** dated
  **16 August 2025**, one of a series (the others cover payroll, leads/dispatch, field
  safety/storage). It is the finished diagram.
- **`AP_AR_Flow_from_whiteboard (1).xlsx`** — an **earlier archived workbook**, built by
  transcribing a photograph of a whiteboard into the Visio Data Visualizer format: 43 numbered
  process steps with `Next Step ID`, swimlane (`Function`) and stage (`Phase`). Its README says
  so plainly: *"This table was built from your photo. Please review lane names (Function) and
  Phase labels… Areas marked in Notes are assumptions from the image—adjust as needed."*

**Why it matters.** It is the **only end-to-end AP and AR process map** in the vault, drawn by
TCG rather than described in a meeting, and it names the states and decision points a future
module would have to model. The whiteboard workbook additionally carries the **swimlanes** —
who owns which stretch — which the finished diagram does not label.

> **Two caveats, both from the sources themselves.** The workbook is an **unverified
> transcription of a photograph**, flagged as such by its own author, with two steps carrying
> explicit "please verify" notes. And the two renderings are **not identical** — the diagram
> shows branches the workbook does not, and the workbook adds a payment-execution stage the
> diagram compresses. Treat neither as authoritative; treat the overlap as the strongest signal.

---

## Accounts Payable — the diagram's flow

Reading the flowchart's boxes and branches:

```
Receive Bills → Bill Verified? ──Yes──→ Subcontractor? ──Yes──→ Pay Subcontractor
                                              └─No──→ Pay Bill
```

running in parallel with the operational lane that feeds billing:

```
Collect Paperwork / Check FCC-NexGen Complete Tickets
  → Approve Tickets to Bill  → GPS Tracking → E-Tickets Not Invoiced
  → Open Payroll Processor   → Hold Over? ──No──→ Job/Customer Info Update
                                                    ──No──→ Subcontractor?
                                                              ──No──→ Mock Invoice
  → Sales Coordinator → Notify Sales Coordinator → Final QuickBooks Steps → 3rd Party
```

with side branches for **LADWP** — `Send Customer Tickets → Receive Breakdown from Customer →
Verify Customer Breakdown → Bill` — and, off the "Hold Over? Yes" path, **Create Excel**, and
off "Subcontractor? Yes", **FCC** then **Receive Invoice from Sub**. A **Pre Lien** box hangs
off the 3rd-Party end.

Four things worth naming from that:

1. **Billing starts from ticket completeness, not from a job ending.** The first box is
   *Collect Paperwork / Check FCC-NexGen Complete Tickets*, and there is an explicit
   *E-Tickets Not Invoiced* state.
2. **`Approve Tickets to Bill` is a discrete gate** with its own box — it is a step, not an
   implicit consequence.
3. **`Mock Invoice`** is a named artefact in the flow — a draft reviewed before the real one.
   No source in the vault defines it.
4. **LADWP gets its own path**, in which **the customer supplies a breakdown that TCG verifies
   before billing**. That is a customer-specific billing protocol, and it sits beside the
   customer-prefixed billing codes seen on Edison and LAUSD invoices
   ([invoice-packets-2026-04-worked-examples.md](invoice-packets-2026-04-worked-examples.md)).

## Accounts Receivable — the diagram's flow

```
Deposit Determined → Deposit? ─No→ Dispatch
                            └─Yes→ Deposit Collected
Job Cancelled → Check Returned / Return Deposit → Notify Sales Coordinator

Payment method:
  Cash  → Cash to Operate After Confirming with Accounting
  Card / ACH → OP Call Accounting, Gives Total, Sends Customer Invoice
  Check → Call Accounting for Total → Get Check
    → Accounts Receivable Creates Invoice, Marks as Paid → Paid
       → Payment? ─No→ Accounting Calls Customer → Answer? ─Yes→ New Form of Payment → Paid
                                                          └─No→ Lien Alert → Continual Collection Process
```

and the terms-based path underneath:

```
Terms → Confirm Invoice Received → Invoice Issues?
   ├─Yes→ Reach Out to Job Owner → Reach Agreement with Customer
   └─No → Payment? ─No→ Call at Term → Follow Collection Process
                                     → Lien Alert → Ownership → Lien at 90 Days → Court
```

with `Job On Hold` on the unpaid branch and `Invoice Marked as Paid` on the paid one.

**The collections escalation is explicit and terminal:** *call at term → follow collection
process → lien alert → ownership → lien at 90 days → court*. The **90-day** threshold matches
the wishlist's *"hold at 90"* in the AI-collections item
([2026-07-accounting-team-erp-wishlist.md](2026-07-accounting-team-erp-wishlist.md)) — two
independent sources, same number. The pre-lien flag that gates this is the free-text
`Do Not Pre Lien` column in the QuickBooks customer file
([nexgen-quickbooks-integration/06-quickbooks-customer-contact-export.md](nexgen-quickbooks-integration/06-quickbooks-customer-contact-export.md)).

**`Job On Hold` is an operational consequence of a financial state** — non-payment stops work.
That crosses from accounting into dispatch, and no other vault source records the link.

---

## The whiteboard workbook — swimlanes and stages

43 steps. Its value over the diagram is the two classification columns.

**Swimlanes (`Function`):** `AP` · `Accounting` · `Ops/COO` · `Collections`.
**Stages (`Phase`):** `Intake` · `Verification` · `System Entry` · `Payment Scheduling` ·
`Payment Execution` · `Deposit Handling` · `Invoice Terms` · `Collections`.

### AP path, step by step

| Stage | Steps as written |
| --- | --- |
| Intake | `Start: Receive vendor bills` → `Collect approvals, check notations, complete tables` |
| Verification | `Approver reviews bill (AP/Manager/Project)` → **`Bill verified?`** → if no, `Return to submitter for corrections` and **loop back until complete** |
| System Entry | `Create entry in system` → **`Open PO / project?`** → if no, `Open/Update project or PO record` |
| Payment Scheduling | **`Pay now?`** → yes: `Schedule payment (e.g., by cycle date)`; no: `Remove from immediate payment queue` → `Hold / review later` |
| Payment Execution | **`Payment method?`** → `Cash` / `Check` / `EFT` → `Prepare cash disbursement` · `Issue check & obtain signatures` · `Initiate electronic transfer (ACH/Wire/Card)` → `Record payment confirmation` → `Vendor paid` |

Three details the diagram does not give: the **approver is one of AP, Manager or Project**; an
unverified bill **returns to the submitter and loops**; and a bill with no open PO or project
**creates or updates one** rather than being rejected. That last one is the PO-matching step the
2026-08-28 walkthrough describes from the other end — *"PO-based invoices are matched to the
related PO in FCC using the PO number"*
([../meetings/2026-08-28-accounting-process-discussion.md](../meetings/2026-08-28-accounting-process-discussion.md)).

`Issue check & obtain signatures` is plural — signatures, not signature.

### AR path, step by step

| Stage | Steps as written |
| --- | --- |
| Deposit Handling | `Start: Incoming customer payment` → **`Received as?`** → `Cash` (`Count cash, prepare slip`) / `Check` (`Verify check and endorsements`) / `Card` (`Capture card receipt`) → **`Deposit?`** → `Deposit collected` or `No deposit collected` |
| Invoice Terms | `Create/Match customer invoice` → **`Payment received for invoice?`** → `Paid`, or `Job on hold` *(owner: Ops/COO)* → `Set terms` |
| Collections | `Set terms` → `Confirm invoice received` → **`Invoice issues?`** → No: `Invoice OK — continue standard follow-up`; Yes: `Reach out to job owner / customer` *(Ops/COO)* → `Draft agreement with customer (new payment form/plan)` *(Ops/COO)* → `Call out team` → `Follow collection procedures` → `Lien placed` → `Ownership decision/review` → `If > 90 days delinquent` → **`Court`** |

**The swimlane assignment is the finding.** Chasing a disputed invoice and negotiating a payment
plan are **`Ops/COO`**, not Accounting or Collections — and putting a job on hold is `Ops/COO`
too. Collections owns only the escalation from `Call out team` onward. Any permissions model has
to allow an operations role to act on an invoice dispute.

Two steps the transcriber flagged as uncertain: `Deposit?` — *"From whiteboard: Deposit options /
Deposit collected"* — and `Hold / review later` — *"Whiteboard: right-side 'Project?' and other
notes—please verify"*.

---

## How this lands against the vault

- **Confirms and structures** what the 2026-08-28 accounting discovery session described in
  prose, and does it from a document TCG drew a year earlier (2025-08-16).
- **New, not previously in the vault:** the `Mock Invoice` artefact · the LADWP
  customer-breakdown billing path · `Approve Tickets to Bill` as a discrete gate · `Job On Hold`
  as a consequence of non-payment · the four-way AP/Accounting/Ops-COO/Collections swimlane
  split · `Hold / review later` as a payment-queue state.
- **Corroborates** the 90-day lien threshold and the collections escalation already on the
  accounting wishlist.
- **Nothing here is a requirement.** It is a description of how the work is done today, drawn
  for a process-improvement exercise. The accounting boundary decision of 2026-09-01 keeps the
  ledger side of all of this in QuickBooks.

## Source

- `1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_ACCOUNTS_PAYABLE_2025-08-16.pdf` — one-page Visio flowchart, `pdftotext -layout`; box labels recovered in reading order, **connector arrows and swimlane boundaries are not recoverable from the text layer**, so the flows above are reconstructed from label adjacency and are corroborated against the workbook wherever the two overlap.
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/FLOWCHARTS_VALUE_ENGINES/TCG_VE_ACCOUNTS_PAYABLE_2025-08-16.pdf` — **byte-identical duplicate** of the above (same MD5); not separately migrated.
- `…/FLOWCHARTS_VALUE_ENGINES/TCG_VE_ACCOUNTS_PAYABLE_2025-08-16.jpg` — a raster of the same diagram, **no text layer, not converted**. It is the readable form of the arrows; open it if the flow above needs confirming.
- `…/FLOWCHARTS_VALUE_ENGINES/zz_ARCHIVE/AP_AR_Flow_from_whiteboard (1).xlsx` — 2 sheets: `ProcessMap` (43 rows × 9 columns) and `README`. Archived, and by its own account a first pass over a photograph.
