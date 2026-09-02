---
title: Projects Jobs — module index
status: reference
kind: index
updated: 2026-08-24
tags: [module/projects-jobs, kind/reference]
---

# Projects Jobs

Projects, jobs, plans, permits. Backend usecases: `projects, jobs, sub-jobs, plans*, permits*, job-*-assignments`. Organized per [STRUCTURE.md](../STRUCTURE.md).

## Files

| File | Answers | KB |
| --- | --- | --- |
| [job-project-das.md](job-project-das.md) | Cross-module punch list; DAS is 1 of 9 sections | 1.7 |
| [project-module/INDEX.md](project-module/INDEX.md) | Project module — **its own section numbering is unreliable, see index** | 2.2 |

## Decisions that bind this module

- [2026-08-12-plan-comments-page-scope.md](../decisions/2026-08-12-plan-comments-page-scope.md) — Scope of "the Plan Comments page" in SCRUM-757 — decision
- [2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) — Archive replaces delete, app-wide — decision
- [2026-08-20-job-completed-on-last-day-offload.md](../decisions/2026-08-20-job-completed-on-last-day-offload.md) — Project Job becomes Completed on last-day yard offload — decision
- [2026-08-20-job-completion-scope-no-vendor-no-backfill.md](../decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md) — Job completion scope — no vendor path and no historical backfill in SCRUM-903 — decision
- [2026-08-25-completed-job-view-only.md](../decisions/2026-08-25-completed-job-view-only.md) — Completed Project Jobs are hard view-only — decision
- [2026-08-20-planning-tracker-archived-filter.md](../decisions/2026-08-20-planning-tracker-archived-filter.md) — Planning Tracker must have a filter that shows archived plans — decision
- [2026-08-20-post-save-navigation-convention.md](../decisions/2026-08-20-post-save-navigation-convention.md) — Post-save navigation — edit goes to detail, create goes to listing — decision. **Create half superseded 2026-09-01**; the edit half stands
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20
- [2026-08-31-quotation-qty-not-das-sets.md](../decisions/2026-08-31-quotation-qty-not-das-sets.md) — Quotation qty is billing only; one DAS/Yard set per root; child qty independent
- [2026-08-28-job-schedule-weekend-empty-state.md](../decisions/2026-08-28-job-schedule-weekend-empty-state.md) — Job Schedule weekend-empty empty state — decision

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

6 meeting files carry `module/projects-jobs` — list them:

```
grep -rl 'module/projects-jobs' vault/meetings/
```
