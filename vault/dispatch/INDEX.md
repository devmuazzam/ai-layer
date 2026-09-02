---
title: Dispatch — module index
status: reference
kind: index
updated: 2026-08-29
tags: [module/dispatch, kind/reference]
---

# Dispatch

DAS, scheduling, yard operations. Backend usecases: `das, das-allocations, das-loadout, job-tickets`. Organized per [STRUCTURE.md](../STRUCTURE.md).

> **Conflict stub first:** [daily-allocation-INDEX.md](daily-allocation-INDEX.md) — competing sources, none verified. Do not answer from a single document while it is non-empty.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [daily-allocation-INDEX.md](daily-allocation-INDEX.md) | **DAS sources — complementary, not rival** | 1.9 |
| [daily-allocation-system.md](daily-allocation-system.md) | The DAS spec: drag & drop allocation, dispatch lifecycle, availability, live asset map | 8.7 |
| [dispatcher-needs.md](dispatcher-needs.md) | What dispatchers said they need (discovery) | 3.9 |
| [yard-operations-jz.md](yard-operations-jz.md) | Yard operations punch list | 0.6 |
| [crane-configurations.md](crane-configurations.md) | **What a crane configuration is** — operator load, `.1/.2/.3` support loads, the dispatch-sheet legend, GPS-verified time | 5.5 |

## Decisions that bind this module

- [2026-08-20-job-completed-on-last-day-offload.md](../decisions/2026-08-20-job-completed-on-last-day-offload.md) — Project Job becomes Completed on last-day yard offload — decision
- [2026-08-20-job-completion-scope-no-vendor-no-backfill.md](../decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md) — Job completion scope — no vendor path and no historical backfill in SCRUM-903 — decision
- [2026-08-25-completed-job-view-only.md](../decisions/2026-08-25-completed-job-view-only.md) — Completed Project Jobs are hard view-only — decision
- [2026-08-31-quotation-qty-not-das-sets.md](../decisions/2026-08-31-quotation-qty-not-das-sets.md) — Quotation qty is billing only; one DAS/Yard set per root; child qty independent
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

24 meeting files carry `module/dispatch` — list them:

```
grep -rl 'module/dispatch' vault/meetings/
```
