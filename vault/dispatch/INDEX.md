---
title: Dispatch — module index
status: reference
kind: index
updated: 2026-09-04
tags: [module/dispatch, kind/reference]
---

# Dispatch

DAS, scheduling, yard operations. Backend usecases: `das, das-allocations, das-loadout, job-tickets`. Organized per [STRUCTURE.md](../STRUCTURE.md).

> **Conflict stub first:** [daily-allocation-INDEX.md](daily-allocation-INDEX.md) — competing sources, none verified. Do not answer from a single document while it is non-empty.

> **2026-09-04 drop.** Seven pages below came from the Project Repository drop and are all
> **descriptions of current practice or of the legacy system** — the Excel dispatch board, the
> department's own value engines and playbooks, and FCC's user guides. None of them is a
> requirement, none has been adjudicated, and none bears on the conflict stub above. They are here
> so that a claim about "how dispatch works today" can be checked rather than guessed.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [daily-allocation-INDEX.md](daily-allocation-INDEX.md) | **DAS sources — complementary, not rival** | 2.4 |
| [daily-allocation-system.md](daily-allocation-system.md) | The DAS spec: drag & drop allocation, dispatch lifecycle, availability, live asset map | 9.4 |
| [dispatcher-needs.md](dispatcher-needs.md) | What dispatchers said they need (discovery) | 5.1 |
| [yard-operations-jz.md](yard-operations-jz.md) | Yard operations punch list | 0.9 |
| [crane-configurations.md](crane-configurations.md) | **What a crane configuration is** — operator load, `.1/.2/.3` support loads, the dispatch-sheet legend, GPS-verified time | 8.4 |
| [crane-configuration-rules.md](crane-configuration-rules.md) | **The rules, and where each one came from** — shape, cardinality, load ordering, crew, ticketing, `isRequired` semantics, instance binding, boom dolly; what is enforceable against `SubCategoryAssociatedResource` today and what needs schema | 21 |
| [dispatch-sheet-workbook.md](dispatch-sheet-workbook.md) | **The Excel the ERP replaces** — the blank master grid, 98 filled days, the free-text conventions (`onsite`, `Down`, `Open`, holdover), the fuller legend, the operator qualification matrix | 15.8 |
| [dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) | **What dispatch does, in dispatch's own words** — the value-engine flow, its four playbooks and owners, the sales→dispatch handoff and the Green/Yellow/Red permit-lead-time paths, the superintendent review, sub-out | 18.9 |
| [confirmations-playbook.md](confirmations-playbook.md) | **Confirming tomorrow's jobs** — what is checked, the 1:00/1:30 PM deadlines, oversized-load thresholds, reconciling to the Daily Sheet, the nine email-only customers and the message shape | 14 |
| [travel-permits-playbook.md](travel-permits-playbook.md) | **Getting a travel permit** — the 40-ton threshold, Caltrans annuals and freeway-exit routing, the per-city folder tree, the Daily Permit Sheet, permit agencies, restricted hours and pilot cars | 11.8 |
| [daily-loading-value-engine.md](daily-loading-value-engine.md) | **The yard's morning** — running the Daily Job LEMS report, the four-field loading list and *leave time*, and what happens when rigging, the crane or the trucking does not fit | 9.4 |
| [admin-to-field-communication.md](admin-to-field-communication.md) | **Who tells the field what** — seven admin lanes and their owners, dispatch's five traffic types, "double stacking", the Local 12 union escalation | 9.3 |
| [fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) | **How the legacy system behaves** — the seven statuses at four levels, the Schedule Type → Type → Resource cascade, date/time offset inheritance, soft validations and the universal override, LEM vs Job tickets and one-ticket-per-resource-per-day, labor review, unit down time, trucking loads; screenshot section adds the WinForms screen fields, ticket review grid and printed e-ticket | 48.7 |

## Decisions that bind this module

- [2026-08-20-job-completed-on-last-day-offload.md](../decisions/2026-08-20-job-completed-on-last-day-offload.md) — Project Job becomes Completed on last-day yard offload — decision
- [2026-08-20-job-completion-scope-no-vendor-no-backfill.md](../decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md) — Job completion scope — no vendor path and no historical backfill in SCRUM-903 — decision
- [2026-08-25-completed-job-view-only.md](../decisions/2026-08-25-completed-job-view-only.md) — Completed Project Jobs are hard view-only — decision
- [2026-08-31-quotation-qty-not-das-sets.md](../decisions/2026-08-31-quotation-qty-not-das-sets.md) — Quotation qty is billing only; one DAS/Yard set per root; child qty independent
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20
- [2026-09-14-yard-unassigned-slots-not-loadable.md](../decisions/2026-09-14-yard-unassigned-slots-not-loadable.md) — Unassigned slots not loadable; Partial Loadout label. **Employees-as-loadable / pre-tick superseded** 2026-09-15
- [2026-09-15-fix-15-sep-das-and-quotations-as-built.md](../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md) — `fix/15-sep` as built (Ehtesham Anwar): employees not loaded; handover unchecked; steal of plain allocations; yard lock; Cancel Allocations

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

26 meeting files carry `module/dispatch` — list them:

```
grep -rl 'module/dispatch' vault/meetings/
```
