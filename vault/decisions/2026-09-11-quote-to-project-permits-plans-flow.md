---
title: Quote-to-project permits and plans flow — Loom locks — decision
source: decision/Ehtesham Anwar Loom walkthroughs
decided: 2026-09-11
decided_by: >-
  Ehtesham Anwar (CodingCops product manager), demonstrated in two Loom
  walkthroughs of the quotation → project permits/plans flow. Not a TCG
  client-side product-owner sign-off. Recorded `status: reference` — binding
  on the CodingCops build through the 15 Sep 2026 deadline, open to being
  overruled by TCG. Meeting stub:
  meetings/2026-09-11-ehtesham-quote-to-project-permits-plans-looms.md.
status: reference
conflicts_with: []
partially_superseded_by: decisions/2026-09-11-permit-approval-requires-linked-po.md  # point 14, approval only
resolves:
  - projects-jobs/gaps.md#artifact-coverage-model--individual-vs-combined-and-whether-the-choice-is-permanent
  - projects-jobs/gaps.md#open-as-the-starting-trackable-status-and-the-retirement-of-approved_by_others
jira: []
tags: [module/projects-jobs, module/quotations, module/vendors-agencies, kind/decision, permits, lift-plans, purchase-orders]
entities: [Permit, Plan, PurchaseOrder, Quotation, Project, Job, Agency]
---

# Quote → project: permits, plans, PO attach — locks from Ehtesham Looms

Locks only rules that are **clear** in the two walkthroughs. Garbled or
uncertain turns are omitted. Sources:
[meetings/2026-09-11-ehtesham-quote-to-project-permits-plans-looms.md](../meetings/2026-09-11-ehtesham-quote-to-project-permits-plans-looms.md).

Companion scope locks: job-only create until after 15 Sep —
[2026-09-11-permit-classes-job-only-until-sept-15.md](2026-09-11-permit-classes-job-only-until-sept-15.md);
outbound PO modal —
[2026-09-11-outbound-po-subtypes-and-modal-fields.md](2026-09-11-outbound-po-subtypes-and-modal-fields.md).

## Decision

### Conversion minting

1. Converting a quotation (won/approved state) to a project shows project name,
   attaches the quotation, then configures document checklist items: **Lift
   plans**, **Travel permits**, **FAA permits**, **Site plan**, **Encroachment
   permit**, **Sub Hauler permit**.
2. **Site plan**, **Encroachment**, and **Sub Hauler** are **one per job**.
3. **Lift plan coverage:** if **Individual** is selected → mint **one lift-plan
   artifact per asset** (demo: two assets → two artifacts); if **Combined** →
   mint **one** shared lift-plan artifact covering those assets.

### Identifiers and trackers

4. After create, the project/job shows distinct **permit #** and **plan #** on
   the job’s Permits and Plans tabs (manual number entry also allowed where
   shown).
5. Project-minted permits appear in the **Permit Tracker**; plans appear in the
   **Planning Tracker**. Tracker status clicks open the same detail flows.

### Auto-populate on artifact detail

6. **Plans:** assigned planner (logic may auto-attach sales person); **due
   date** defaults from the quotation/job schedule’s **first day**, editable.
7. **Permits:** **Agency** and **city/area** auto-populate; **due date** same
   first-day seed, editable.
8. **Due-date helper (all plans and all permits):** when a job schedule exists,
   show under due date that the **job schedule starts from this date**. Hide
   that helper until the job schedule is present.

Confirms and extends
[2026-09-08-artifact-due-date-seeded-from-first-job-day.md](2026-09-08-artifact-due-date-seeded-from-first-job-day.md)
(seed + editability already locked; this note adds the schedule helper copy).

### Plan status path

9. From Open, clicking Approved / **Upload approved plan** opens upload +
   comments; status advances to Approved.
10. After leaving Open via that path, the user **cannot return the plan to
    Open** (status updates are forward for that axis).

### Permit status path

11. Default Open = application not yet submitted.
12. **Upload application** (required) → status becomes application submitted.
13. Then **Upload approved permit** / final approved permit: permit cost,
    application number, date received (auto current date, editable).
14. ~~Purchase Order on the permit form is **not required** in the current flow~~
    — **superseded for approval 2026-09-11** by
    [2026-09-11-permit-approval-requires-linked-po.md](2026-09-11-permit-approval-requires-linked-po.md)
    (Fouzan Shakil): approving a permit **requires a linked PO**, except
    `TRAVEL_ANNUAL_PURPLE_PERMIT`. **Still stands:** the permit form's two PO
    paths (search/attach an existing PO, or create-and-attach), and removing a
    linked PO restores the create option.

### PO create/attach (from permit)

15. Create shows the locked modal fields (type, number, items, Agency, invoice
    attachment) — see
    [2026-09-11-outbound-po-subtypes-and-modal-fields.md](2026-09-11-outbound-po-subtypes-and-modal-fields.md).
16. PO statuses in this flow: **Open** and **Closed**.

## Effect on the vault

- **Done — partial** on
  [`../projects-jobs/gaps.md#artifact-coverage-model--individual-vs-combined-and-whether-the-choice-is-permanent`](../projects-jobs/gaps.md#artifact-coverage-model--individual-vs-combined-and-whether-the-choice-is-permanent):
  **(a)** resolved — Individual vs Combined minting at conversion is product
  intent (demonstrated for lift plans). **(b) permanence** remains **open**.
- **Done — partial** on
  [`../projects-jobs/gaps.md#open-as-the-starting-trackable-status-and-the-retirement-of-approved_by_others`](../projects-jobs/gaps.md#open-as-the-starting-trackable-status-and-the-retirement-of-approved_by_others):
  **(a)/(b)** lifecycle shape resolved from the Loom (permits:
  Open → application submitted → Approved; plans: Open → Approved). **(c)**
  `APPROVED_BY_OTHERS` history remains unexplained / open.
- **Left open:**
  [`../projects-jobs/gaps.md#cancelled-is-near-terminal--no-route-back-to-open`](../projects-jobs/gaps.md#cancelled-is-near-terminal--no-route-back-to-open)
  — Loom “cannot go back to Open” was about post-advance reopen, not cancel
  revive.
- **Left open:** salesperson plan-approval chain
  (`lift/site plan approval no longer routes through the salesperson`).

## What this does not settle

- Whether Individual/Combined applies identically to Travel/FAA (demo focused
  on lift plans; checklist still configures those permit kinds).
- Whether coverage mode is editable after conversion.
- ~~Whether PO becomes required again for approval after 15 Sep / general work.~~
  **Settled 2026-09-11:** approval **keeps** requiring a linked PO, except
  `TRAVEL_ANNUAL_PURPLE_PERMIT`. See
  [2026-09-11-permit-approval-requires-linked-po.md](2026-09-11-permit-approval-requires-linked-po.md).
- Lead-time / `Latest Permit Submission` computation (still open).
