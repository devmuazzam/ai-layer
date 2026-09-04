---
title: Quote lifecycle with permits and POs — the March 2026 diagram set
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/ — TCG_Quote_Lifecycle_with_Permits_and_POs.svg, TCG_Quote_Lifecycle_with_Permits_and_POs_DB-schema.html, TCG_Quote-Project-Job_diagram-full.html
migrated: 2026-09-04
updated: 2026-03-31
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/projects-jobs, module/vendors-agencies, module/accounting, kind/source, permits, purchase-orders, architecture, invoicing, signatures]
entities: []
---

# Quote lifecycle with permits and POs — the March 2026 diagram set

**What this is.** Three companion artefacts that sat together in `TCG_QUOTES/` in the
2026-09-04 Project Repository drop. They are *design* diagrams — an SVG flowchart, an HTML
entity-relationship sketch and an HTML entity-hierarchy page — footed "Generated March 2026 ·
Custom Operations Platform · Confidential". They are the only place in the vault where the
quote lifecycle is drawn **with permits and purchase orders as first-class steps**, and the only
place a candidate **table-level schema** for quote → job → PO → invoice is written down.

> **Overlaps another page from the same drop.**
> [projects-jobs/quote-to-job-lifecycle.md](../projects-jobs/quote-to-job-lifecycle.md) was
> written from the same SVG and DB-schema HTML in the same ingestion pass, read alongside the ERP
> review log. **Two accounts of one source set now exist.** This page adds the third artefact (the
> Quote→Project→Job hierarchy HTML) and the §4 comparison showing the two diagrams disagree; the
> other reads the same flow from the projects/jobs side. **A human should decide which is the home
> and fold the other in.**

> **Read these as proposals, not as the built system.** Nothing states who authored them or
> whether TCG approved them. Two of the three disagree with each other on whether `Project`
> exists at all (§4), and neither matches the Prisma schema. They are useful because they name
> the moving parts, not because they settle anything.

---

## 1. The lifecycle flow — `TCG_Quote_Lifecycle_with_Permits_and_POs.svg`

Transcribed node by node from the SVG's text elements, top to bottom. Sub-labels are the
diagram's own second lines.

1. **Create quotation** — *customer + price list selected*
2. **Add resources & line items** — *units, third-party services*
   - A dashed coral branch leaves here to **Issue vendor PO** — *optional — early, at quote stage*
3. **Submit to customer** — *digital signature via email*
4. **Customer approved?** — decision
   - **no** → **Revise quote** — *update and resubmit* → back to Submit to customer
   - **yes** ↓
5. **Log customer PO #** — *record on job / schedule tab*
6. **Convert to job** — *quotation locked in system*
7. **Permit required?** — decision
   - **yes** → **Attach permit** — *quote or job stage* → **Issue vendor PO** — *via permit, or directly to job*
   - **no** → skips both
8. **Change order needed?** — decision
   - **yes** → **Update vendor PO** — *revised PO to vendor*
   - **no change** ↓
9. **Dispatch & execute** — *job underway*
10. **Invoice & close** — *customer PO # on final invoice*

The legend states three rules explicitly:

- *Permit — must precede vendor PO when required.*
- *Dashed coral arrow — vendor PO issued early (optional, at quote stage).*
- Two distinct PO directions: *Type 1 PO — customer sends us their PO #*; *Type 2 PO — we send
  a PO to our vendor.*

**Two things this pins down that no other vault page states.** First, the customer PO number is
captured **after customer approval and before conversion to job**, and is *recorded on the job /
schedule tab* — not on the quote. Second, **conversion to job locks the quotation** ("quotation
locked in system"), which is the same claim the ERP review log's 2026-05-05 extraction makes
("the quote must remain static after signature") — see
[erp-review-log.md](../erp-review-log.md) → *Quotations, jobs and projects*.

## 2. The two purchase-order types

The SVG carries a panel headed **Purchase Order Details** with both types spelled out.

### Type 1 — Customer PO (3 steps)

1. **Customer provides their PO #** — *their internal authorization for the job*
2. **Log it on the job (schedule tab)** — *no internal reporting required*
3. **Reference it on our invoice** — *helps the customer process payment*

### Type 2 — Vendor PO (7-step workflow)

1. **Requisition** — *dept. submits request for goods or services*
2. **Approval** — *management reviews and checks budget*
3. **PO creation & sending** — *formal PO issued and sent to the vendor*
4. **Vendor acceptance** — *PO becomes a legally binding contract*
5. **Fulfillment** — *vendor ships goods or performs services*
6. **Goods receipt** — *we confirm delivery matches the PO*
7. **Three-way match & payment** — *AP matches PO + invoice + receipt → pay*

The diagram asserts a **budget check** at step 2 and a **three-way match** at step 7. Neither
appears anywhere else in the vault, and the diagram does not say what the budget is checked
against.

## 3. The proposed database schema — `…_DB-schema.html`

Eleven tables in three groups. Transcribed exactly; `uuid?` means the page marked the FK
nullable.

**Core entities**

| Table | Columns |
| --- | --- |
| `CUSTOMER` | `id` uuid PK · `name` · `contact_email` · `billing_address` · `created_at` |
| `QUOTE` | `id` uuid PK · `customer_id` FK · `status` · `total_amount` · `submitted_at` · `approved_at` · `created_at` |
| `JOB` | `id` uuid PK · `quote_id` FK · `status` · `dispatched_at` · `completed_at` |
| `QUOTE_LINE_ITEM` | `id` uuid PK · `quote_id` FK · `description` · `resource_type` · `quantity` int · `unit_price` |

**POs, permits & vendors**

| Table | Columns |
| --- | --- |
| `CUSTOMER_PO` *(Type 1)* | `id` PK · `job_id` FK · `po_number` · `received_at` |
| `PERMIT` | `id` PK · `quote_id` FK? · `job_id` FK? · `permit_number` · `issuing_authority` · `status` · `issued_at` · `expires_at` |
| `VENDOR` | `id` PK · `name` · `contact_email` · `payment_terms` |
| `VENDOR_PO` *(Type 2)* | `id` PK · `quote_id` FK? · `job_id` FK? · `permit_id` FK? · `vendor_id` FK · `po_number` · `status` · `total_amount` · `issued_at` |

**Change orders & billing**

| Table | Columns |
| --- | --- |
| `CHANGE_ORDER` | `id` PK · `job_id` FK · `description` · `amount_delta` · `approved_at` |
| `VENDOR_PO_REVISION` | `id` PK · `vendor_po_id` FK · `change_order_id` FK · `revised_amount` · `created_at` |
| `INVOICE` | `id` PK · `job_id` FK · `customer_po_id` FK? · `amount` · `status` · `issued_at` |

**Relationships as listed on the page**

`CUSTOMER → QUOTE` (1:many) · `QUOTE → JOB` (1 to 0–1) · `QUOTE → QUOTE_LINE_ITEM` (1:many) ·
`JOB → CUSTOMER_PO` (1 to 0–1) · `QUOTE / JOB → PERMIT` (nullable FKs) · `PERMIT → VENDOR_PO`
(*authorizes*) · `VENDOR → VENDOR_PO` (1:many) · `QUOTE / JOB → VENDOR_PO` (nullable FKs) ·
`JOB → CHANGE_ORDER` (1:many) · `CHANGE_ORDER → VENDOR_PO_REVISION` · `VENDOR_PO →
VENDOR_PO_REVISION` · `JOB → INVOICE` (1:many) · `CUSTOMER_PO → INVOICE` (optional ref).

Three details worth carrying:

- **A permit can hang off either the quote or the job** — both FKs are nullable, so the model
  allows a permit attached at quote stage to survive conversion. The flowchart says the same
  thing in words: *"Attach permit — quote or job stage."*
- **`PERMIT → VENDOR_PO` is labelled *authorizes*.** The permit is not merely related to the
  vendor PO; it is what makes issuing it legitimate. That is the same ordering rule as the
  legend.
- **A change order revises a vendor PO through a join row**, `VENDOR_PO_REVISION`, rather than
  by mutating the PO. The revision keeps `revised_amount` and points at both.

## 4. The entity hierarchy — `TCG_Quote-Project-Job_diagram-full.html`

A second, differently-shaped page: `Customer → Quote → Project → Job → {Unit, Employee, Job
Ticket}`, with attribute "pills" per node.

| Node | Attributes shown |
| --- | --- |
| **Customer** *(top level)* | Company & contact info · Billing terms · Multiple contacts (billing, on-site, etc.) · **Customer price list (optional override)** · Internal comments |
| **Quote** *(belongs to one Customer)* | Auto-generated Quote # · Quoted-to customer & contact · Job site info · **PO number** · Units & equipment · Pricing / estimates · Tools & rigging · Dates & times · Comments / notes · Quote status |
| **Project** *(system generated)* | Linked to Quote · Project reference # · Customer & job site · **Financial overview (budget vs. actuals)** · Phase tracking / status |
| **Job** *(a consecutive date range)* | Job # / reference · Start → end date · Job site details · Dispatch notes · Status |
| **Unit** | Equipment / crane type · Unit ID / asset # · Rate / hours · *Employee optional* |
| **Employee** | Employee ID / name · Role / craft — reachable **via a Unit** or **directly on the Job** |
| **Job Ticket** | Checklists (unit inspection, customer signature capture, custom items) · Job Activity (**~10 phase timestamps, modifiable** — arrival/setup, lift start/end, break times, departure, + additional phases) · Labor components (per employee, craft code entry, hours, labor notes) |

Its three stated rules:

- **Quote / Project rule** — *"A Quote is created for **one Customer only**. The system
  automatically generates a **Project** for each approved Quote — the Project is the operational
  container linking back to that Quote."*
- **Job date range rule** — *"Each Job covers a **consecutive date range**. If work within a
  Project is **non-consecutive** (e.g., two separate mobilizations weeks apart), each period
  becomes its **own separate Job** under the same Project."*
- **Unit & Employee flexibility** — *"Units may be added to a Job **without an Employee**
  assigned. Employees may also be assigned **directly to a Job** independent of any Unit —
  covering labor-only or support roles."*

### These two diagrams do not agree

| | DB-schema page | Entity-hierarchy page |
| --- | --- | --- |
| Is there a `Project`? | **No.** No table; `JOB.quote_id` points straight at the quote | **Yes.** Auto-created per approved quote, and the operational container |
| Quote → Job cardinality | 1 to **0–1** | 1 Quote → 1 Project → **1 or more Jobs** |
| Where the customer PO lives | `CUSTOMER_PO.job_id` — on the job | a `PO Number` pill on the **Quote** |
| Job Tickets | absent from the schema | a first-class child of Job |

The lifecycle SVG sides with the schema on the PO (*"Log customer PO # — record on job /
schedule tab"*) and never mentions Project at all. The entity-hierarchy page is the only one of
the three that carries Project, Job Tickets and the phase-timestamp model.

**The vault's own record is closer to the hierarchy page than to the schema.** The ERP review
log's 2026-05-05 extraction records *"a **project may have multiple quotations**, each
convertible into a job under the same project"* — which is neither of these two shapes
(hierarchy page says one quote → one project; the meeting says one project ← many quotes). See
[erp-review-log.md](../erp-review-log.md) → *Quotations, jobs and projects*. **These documents do
not say which is right, and neither does anything else in the vault.**

## 5. What this adds beyond the existing flow page

[quotation-flow-process.md](quotation-flow-process.md) walks the same lifecycle in 27 numbered
steps from lead intake to "converted into a Project", but stops there. It has **no** permit gate,
**no** purchase order of either type, **no** change order and **no** invoice. Everything from
step 5 of §1 onward is new here.

## Source

- `1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/TCG_Quote_Lifecycle_with_Permits_and_POs.svg` — 54 KB
  SVG (680 × 1360 viewBox); node text extracted programmatically and ordered by y-coordinate.
  No image kept.
- `1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/TCG_Quote_Lifecycle_with_Permits_and_POs_DB-schema.html`
  — 15 KB HTML ERD; all 11 tables and 13 relationship pills transcribed in full.
- `1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/TCG_Quote-Project-Job_diagram-full.html` — 11 KB HTML;
  all nodes, pills and the three rule cards transcribed in full. Footer: "Generated March 2026 ·
  Custom Operations Platform · Confidential".
