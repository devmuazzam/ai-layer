---
title: Projects Jobs — module index
status: reference
kind: index
updated: 2026-09-04
tags: [module/projects-jobs, kind/reference]
---

# Projects Jobs

Projects, jobs, plans, permits. Backend usecases: `projects, jobs, sub-jobs, plans*, permits*, job-*-assignments`. Organized per [STRUCTURE.md](../STRUCTURE.md).

## Files

| File | Answers | KB |
| --- | --- | --- |
| [job-project-das.md](job-project-das.md) | Cross-module punch list; DAS is 1 of 9 sections | 1.7 |
| [project-module/INDEX.md](project-module/INDEX.md) | Project module — **its own section numbering is unreliable, see index** | 2.2 |
| [quote-to-job-lifecycle.md](quote-to-job-lifecycle.md) | Where permits and the two kinds of PO sit between quote and job; the undated ER sketch, and where the client has since contradicted it | 9.8 |
| [city-permits/INDEX.md](city-permits/INDEX.md) | **Permits, 7 pages** — 153-jurisdiction reference, lead times, the annual/blanket tracker, waivers, FAA/NOTAM | 3.9 |
| [scheduling/INDEX.md](scheduling/INDEX.md) | **Scheduling, 6 pages** — the Ready to Schedule gate, the permit clock, Green/Yellow/Red, the Job Schedule Master workbook | 3.6 |
| [lift-plans/INDEX.md](lift-plans/INDEX.md) | **Lift plans, 3 pages** — requesting, building, the pending-plan exception, package anatomy | 2.7 |

### Added by the Project Repository drop, 2026-09-04

Sixteen new pages arrived in one drop of TCG's SharePoint "Project Repository". They document the
**current manual process** — the Value Engine playbooks, the per-city permit library, the permit and
scheduling workbooks, and two complete lift-plan packages. Where they touch a subject the Confluence
pages already cover, each new page says explicitly how the two differ rather than overwriting either.

**Three things they establish that the vault did not have:**

- **The permit clock.** Thursday 12:00 noon through Monday start of business does not count toward
  permit lead time — roughly 3.5 countable days a week. It drives the whole Green / Yellow / Red
  scheduling decision.
- **TCG holds 338 annual and blanket permit records across 29 units and 49 agencies, and 115 of them
  are expired.** That register is what an "is there an annual here?" flag would have to read.
- **A lift plan is a bound multi-source package**, not a form — with four priced deliverable tiers,
  a 24-hour standard turnaround, and four categories of expiring credential inside it.

> **Security finding from this drop, for a human to act on.** The 153 per-city permit notes carry
> **live portal usernames, passwords and security-question answers in plain text** in a shared
> folder, plus one captured OAuth token pair. None were copied into the vault; every occurrence is
> marked and the source path given. See
> [city-permits/permit-acquisition-process.md](city-permits/permit-acquisition-process.md).

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
- [2026-09-08-artifact-due-date-seeded-from-first-job-day.md](../decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md) — A permit/plan artifact's `dueDate` is seeded from the job's first scheduled day and is freely editable thereafter. Settles the seed and editability only — whether the app should compute or warn on a lead-time deadline (`Latest Permit Submission`) stays open in [gaps.md](gaps.md)

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

6 meeting files carry `module/projects-jobs` — list them:

```
grep -rl 'module/projects-jobs' vault/meetings/
```
