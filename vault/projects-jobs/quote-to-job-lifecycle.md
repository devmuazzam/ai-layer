---
title: Quote to job — where permits and purchase orders sit in the lifecycle
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/TCG_Quote_Lifecycle_with_Permits_and_POs.svg and TCG_Quote_Lifecycle_with_Permits_and_POs_DB-schema.html, plus THE CRANE GUYS - ERP REVIEW LOG.xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/quotations, module/vendors-agencies, module/accounting, kind/source, permits, purchase-orders, architecture, invoicing, requirements]
entities: []
---

# Quote to job — where permits and purchase orders sit in the lifecycle

**What this is.** Two artefacts that arrived together in `1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/`:
a **flow diagram** (SVG) of the quote lifecycle with permits and POs on it, and a matching
**entity-relationship sketch** (HTML). Neither is signed, dated or attributed. They appear to be a
working sketch produced during requirements discussion rather than an agreed model — **treat both as
a proposal, not as a decision.**

**The quoting half of this belongs to `quotations/`.** This page covers the parts that are
projects-jobs': the **conversion point** where a quote becomes a job, and the **permit and vendor-PO
branches** that hang off it. The quotation-side detail — approvals, signature, line items, pricing —
is not duplicated here.

## The flow, as the diagram draws it

The main spine, top to bottom:

1. **Create quotation** — *customer + price list selected*
2. **Add resources & line items** — *units, third-party services*
3. **Submit to customer** — *digital signature via email*
4. **Customer approved?** — **no** → *Revise quote* (*update and resubmit*), looping back;
   **yes** → continue
5. **Log customer PO #** — *record on job / schedule tab*
6. **Convert to job** — ***quotation locked in system***
7. **Permit required?** — **no** → skip; **yes** → *Attach permit* (*quote or job stage*)
8. **Issue vendor PO** — *via permit, or directly to job*
9. **Change order needed?** — **yes** → *Update vendor PO* (*revised PO to vendor*);
   **no change** → continue
10. **Dispatch & execute** — *job underway*
11. **Invoice & close** — ***customer PO # on final invoice***

A **dashed coral arrow** runs from near the top of the diagram directly to *Issue vendor PO*,
labelled *"optional — early, at quote stage"* and, on the box itself, *"Issue vendor PO — units,
third-party services"*. So the diagram's own legend states: a vendor PO **may be issued at the quote
stage**, before the job exists. The legend also states **"Permit — must precede vendor PO when
required"**.

Two things the diagram asserts that matter to this module:

- **Conversion locks the quotation.** The *Convert to job* box is annotated *"quotation locked in
  system"*.
- **A permit can be attached at either the quote or the job stage.** The *Attach permit* box says so
  explicitly, and the schema below makes both foreign keys nullable to allow it.

## The two kinds of purchase order

The diagram devotes its lower third to distinguishing them, and this is the clearest statement of it
anywhere in the drop.

**Type 1 — Customer PO.** *"The customer provides their PO # — their internal authorization for the
job."* Log it on the job (schedule tab); **no internal reporting is required**; reference it on our
invoice, which *"helps the customer process payment."*

**Type 2 — Vendor PO** — a seven-step workflow TCG runs:

| # | Step | What happens |
| --- | --- | --- |
| 1 | **Requisition** | The department submits a request for goods or services |
| 2 | **Approval** | Management reviews and checks budget |
| 3 | **PO creation & sending** | A formal PO is issued and sent to the vendor |
| 4 | **Vendor acceptance** | **The PO becomes a legally binding contract** |
| 5 | **Fulfillment** | The vendor ships goods or performs services |
| 6 | **Goods receipt** | We confirm delivery matches the PO |
| 7 | **Three-way match & payment** | AP matches PO + invoice + receipt, then pays |

## The entity sketch

Eleven tables. UUID primary keys, `timestamptz` timestamps, nullable FKs written `uuid?`.

**Core:** `CUSTOMER` (name, contact_email, billing_address, created_at) · `QUOTE` (customer_id,
status, total_amount, submitted_at, approved_at, created_at) · `JOB` (**quote_id**, status,
dispatched_at, completed_at) · `QUOTE_LINE_ITEM` (quote_id, description, **resource_type**, quantity,
unit_price).

**POs, permits and vendors:** `CUSTOMER_PO` *(Type 1)* (job_id, po_number, received_at) ·
`PERMIT` (**quote_id `uuid?`**, **job_id `uuid?`**, permit_number, **issuing_authority**, status,
issued_at, **expires_at**) · `VENDOR` (name, contact_email, payment_terms) ·
`VENDOR_PO` *(Type 2)* (**quote_id `uuid?`**, **job_id `uuid?`**, **permit_id `uuid?`**, vendor_id,
po_number, status, total_amount, issued_at).

**Change orders and billing:** `CHANGE_ORDER` (job_id, description, **amount_delta**, approved_at) ·
`VENDOR_PO_REVISION` (vendor_po_id, change_order_id, revised_amount, created_at) ·
`INVOICE` (job_id, **customer_po_id `uuid?`**, amount, status, issued_at).

**Relationships as drawn:** CUSTOMER → QUOTE (1:many) · **QUOTE → JOB (1 to 0–1)** ·
QUOTE → QUOTE_LINE_ITEM (1:many) · JOB → CUSTOMER_PO (1 to 0–1) · QUOTE/JOB → PERMIT (nullable FKs) ·
**PERMIT → VENDOR_PO (authorizes)** · VENDOR → VENDOR_PO (1:many) · QUOTE/JOB → VENDOR_PO (nullable
FKs) · JOB → CHANGE_ORDER (1:many) · CHANGE_ORDER → VENDOR_PO_REVISION · VENDOR_PO →
VENDOR_PO_REVISION · JOB → INVOICE (1:many) · CUSTOMER_PO → INVOICE (optional ref).

## Where this sketch contradicts what the client has since said

**The sketch has no `PROJECT` entity at all**, and it draws **QUOTE → JOB as 1 to 0–1**. The client's
own feedback register, [`../erp-review-log.md`](../erp-review-log.md) → *Quotations, jobs and projects*,
recorded at the 2026-05-05 review, says something different:

- **A project may have multiple quotations**, each convertible into a job **under the same project**.
- A signed quote should **create job/project records while the original quote stays static**.
- **The quote must remain static after signature** — job information may change later without
  modifying the signed quote.
- The job **inherits quote data as a starting point**, then allows operational updates — site
  contact, PO, entrance instructions, actual units.
- An optional **estimated start date/time** on the quote, **carried to the job**.
- **On-site time and estimated ending/leave time**, and possibly yard/leave time, **for dispatch**.
- The quote approval and DocuSign flow — approval, customer signing, and conversion into
  job/project — is **not yet fully built**.

Read together: the diagram's "quotation locked in system" and the review log's "the quote must remain
static after signature" are the same rule. But the diagram's **one quote → at most one job, and no
project** is not the shape the client described. **The project is the container; a quote converts to
a job inside it; several quotes can do so.**

The review log also records, from *Dispatch and scheduling*, a rule that decides which timestamps
matter: **"dispatch uses final job timing, not quote timing — quote timing is tentative, job timing
is the operational source of truth."** That is the reason the estimated start date/time is carried
*from* the quote rather than shared with it, and it is consistent with the Ready to Schedule and
Dispatch Scheduling Path playbooks, where the job's date is what the permit clock is calculated
against.

**None of this resolves the conflict** — the diagram is undated and unattributed, the review log is
an unverified AI summary of one meeting the client marked "for reference only". Both are recorded;
neither is adopted.

## What the permit branch means operationally

The sketch's `PERMIT` table carries `issuing_authority`, `status` and `expires_at` — which is exactly
the shape of the Permit Tracker workbook's master table
([city-permits/permit-tracker-workbook.md](city-permits/permit-tracker-workbook.md)), minus the crane
and the restriction text. **The sketch has no link from a permit to an asset**, so it cannot express
"crane 10001's Anaheim annual" or a fleet-wide blanket permit, which is how TCG actually holds
permits. It models only the per-job single permit, not the annual.

The existing vault page `project-module/05-create-and-track-permits.md` already specifies the
in-product Permits tab — permit requests auto-generated from job publishing, permit form with asset,
agency, fees and status, PO creation inside the permit, job publishing blocked without a valid
permit, and 30-day expiry alerts. **That page's model has the asset link this sketch lacks**, and
`PERMIT → VENDOR_PO (authorizes)` here matches its "PO creation is available within permit". The two
are compatible; the sketch is the thinner of the two.

## Related

- [quotations/quote-lifecycle-permits-and-purchase-orders.md](../quotations/quote-lifecycle-permits-and-purchase-orders.md)
  — **the same two source files read from the quoting side** (the 10-step lifecycle, both PO
  types, the 11-table candidate schema). The two pages were written independently on 2026-09-04
  and overlap; where they differ in emphasis, neither is more authoritative than the other, and a
  future pass should fold them into one.
- [erp-review-log.md](../erp-review-log.md) — the 2026-05-05 client statements this sketch
  contradicts (project holds many quotes; signed quote stays static; job inherits then diverges).

## Source

- `1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/TCG_Quote_Lifecycle_with_Permits_and_POs.svg` — ~55 KB.
  An SVG flowchart; **every text label was extracted, but the connector paths were not traced** —
  the sequence above follows the labels' vertical positions and the explicit yes/no labels on the
  chart. The legend items are quoted verbatim.
- `1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/TCG_Quote_Lifecycle_with_Permits_and_POs_DB-schema.html`
  — ~16 KB, mostly CSS. Eleven table definitions and thirteen relationship pills, all transcribed
  above; nothing was omitted.
- `THE CRANE GUYS - ERP REVIEW LOG.xlsx`, 2026-05-05 sheet — via
  [`../erp-review-log.md`](../erp-review-log.md), sections *Quotations, jobs and projects* and
  *Dispatch and scheduling*.
