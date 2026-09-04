---
title: The Field, Safety & Storage value engine — TCG's own flow of a crew day
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_FIELD_SAFETY_STORAGE_2025-08-16.pdf (duplicate at TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/FLOWCHARTS_VALUE_ENGINES/, same file + a .jpg render)
migrated: 2026-09-04
updated: 2025-08-16
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/dispatch, module/accounting, module/assets, kind/sop, ticket-workflow, safety, inspections, yards, reporting, compliance]
entities: []
---

# The Field, Safety & Storage value engine

**What this is.** One page of Visio swim-lanes, dated **2025-08-16**, showing three TCG processes as
the company itself draws them: **Field Personnel**, **Safety & Audits**, and **Storage** (incoming
and outgoing). A *value engine* is TCG's own name for a departmental process flow — see
[dispatch/dispatch-value-engine-and-playbooks.md](../dispatch/dispatch-value-engine-and-playbooks.md)
for the same artefact type on the dispatch side.

**Why it matters.** It is a **pre-ERP** description of the crew day written by TCG, a full ten months
before the first Field Ops FRD. Read against the FRD it shows what the requirement documents kept and
what they dropped.

> **A flowchart is not a requirement.** Nothing here has been adjudicated. It also describes the
> world with paperwork in it — several boxes are about physically returning paper — which is the
> world the app is meant to replace.
>
> **Only the node labels survive conversion.** `pdftotext -layout` gives the shape text but not the
> connectors, so the *order within a lane* below is read off the layout and is reliable; **branch
> targets are not recoverable** except where a decision node's Yes/No labels appear next to it.

---

## Lane 1 — Field Personnel

The crew day, front to back, as two rows of boxes:

```
Paperwork → Pre Trip → Yard Crew Tailboard → Leave for Job → Arrive at Job Site
   → Walk Job Site / Contact Customer → Safety Tailboard → Complete Lift
```

with a **decision** hanging off *Complete Lift* labelled **`COD` — Yes / No**, and two off-ramps
mid-flow:

- from **Arrive at Job Site**: `Call Dispatch`
- from **Walk Job Site / Contact Customer**: `Call Accounting`

Then the return leg:

```
Customer Final Signature → Drive to Yard → Fuel & Submit Paperwork
   → Park Equipment → Return Paperwork to Box
```

**Five things here that no FRD carries:**

1. **Two tailboards, not one.** A **`Yard Crew Tailboard`** *before leaving the yard*, and a
   **`Safety Tailboard`** on site after walking the job. Both FRDs and the demo have exactly one JSA,
   on arrival. Nothing in the drop says what the yard tailboard covers or who runs it.
2. **`Walk Job Site / Contact Customer`** is its own step between arrival and the tailboard — a site
   walk *before* the safety briefing, feeding it.
3. **`COD` is a decision on the job**, taken at completion. Cash-on-delivery collection is a field
   responsibility in this flow; no field-ops requirement mentions payment.
4. **`Call Accounting` is a field escalation path**, alongside `Call Dispatch`. `FR-FOP-026
   Escalation Handling` (FOP-002) and `FR-FOP-028 Blocking Issue / Emergency Escalation` (FOP-001)
   describe escalation without naming accounting as a destination.
5. **`Fuel & Submit Paperwork` and `Return Paperwork to Box`** are two distinct end-of-day steps, and
   **`Park Equipment` sits between them**. The paper hand-back is a physical checkpoint the app has
   to displace, and the flow shows fuelling as part of it.

Note also what is **absent**: no post-trip inspection box, no lunch, no labor entry, no compliance
checklist. The lane ends at the paperwork box.

## Lane 2 — Safety & Audits

Not a sequence but a cluster, with two feeder types on the left:

```
Self Audits ┐
            ├→ Job Site Audit → OFI → Track Audit Trends → Monthly Customer Reporting
Requested   ┘                    ├→ EE Disciplinary Action
  Audits                         └→ Coaching Moment
```

and, to the right:

```
Training → Develop Training & Safety Meetings → Safety Meeting
```

- **Audits arrive two ways** — `Self Audits` and `Requested Audits`. Nothing says who requests one.
- **`OFI`** — *Opportunity for Improvement* — is the finding type, and it forks to either an
  **`EE Disciplinary Action`** or a **`Coaching Moment`**. Both terms are printed on TCG's own audit
  forms: `Opportunity for Improvement` and `Coaching Moment Name / Topic` are fields on the Safety
  Value Assessment, and `Opportunity for Improvement Submitted` is a counted leading indicator on the
  Quarterly Safety Value Report. See
  [safety-compliance/03-field-audit-and-safety-value.md](safety-compliance/03-field-audit-and-safety-value.md).
- **`Track Audit Trends` → `Monthly Customer Reporting`.** Audit findings are aggregated and
  **reported to the customer**, monthly in this flow. The quarterly report form in the same drop is
  the artefact of that step, at a different cadence — the flow says monthly, the form says
  `Reporting Period`. Melissa's 2026-05-03 requirement in
  [erp-review-log.md](../erp-review-log.md) asks for exactly this: *"audit forms for safety that
  attach to the jobs, with pictures, and the data compiled to track trends."*
- Training is a **loop**: `Training` → `Develop Training & Safety Meetings` → `Safety Meeting`.

## Lane 3 — Storage

Two flows, both ending at billing.

**Receive incoming order:**

```
Receive Incoming Order → Appointment? ─No→ Figure Out Customer
                              └─Yes→ Accept Delivery Picture? → Unload → Place Equipment
                                      → Fill Out Storage Sheet → Enter Into Excel → Contact Billing
```

with a `Forklift` / `Crane` choice on the unload.

**Loading outgoing**, three originating parties — `TCG`, `Storage Customer`, and a `Return to Shop`
path — each resolving to a `Forklift` or `Crane` load and then `Contact Billing`:

```
TCG → Load → Delivery Accepted → Contact Billing
Crane → Return to Shop → Unload → Contact Customer → Contact Billing
Storage Customer → Receive Order → Load → Contact Billing
```

The storage process runs on a **paper `Storage Sheet` re-keyed into Excel**, and every branch ends by
contacting billing by hand. Storage is not one of the ten vault modules and appears in no FRD in the
vault; it is recorded here because it shipped on this page. Its natural homes are `assets/` (yards)
and `accounting/`.

## What this suggests for the field app, without stating it

The flow shows a crew day that **begins and ends with paper**, contains **two safety briefings**, and
routes exceptions to **dispatch, accounting and billing by phone**. The FRDs keep the middle of that
day and drop both ends. Whether the ERP is meant to absorb the yard tailboard, the COD decision, the
fuel/paperwork close-out and the storage sheet, or leave them outside, is **not stated anywhere in
this drop**.

## Source

- `1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_FIELD_SAFETY_STORAGE_2025-08-16.pdf` — 60 KB, 1 page, `pdftotext -layout`. Node text only; connectors and swim-lane boundaries are not recoverable from the text layer.
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/FLOWCHARTS_VALUE_ENGINES/TCG_VE_FIELD_SAFETY_STORAGE_2025-08-16.pdf` — **the same file**, converted text identical; migrated once.
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/FLOWCHARTS_VALUE_ENGINES/TCG_VE_FIELD_SAFETY_STORAGE_2025-08-16.jpg` — 376 KB raster render of the same chart; **not converted** (image). It is the only copy that shows the connectors, and is worth opening by hand if the branch logic matters.
