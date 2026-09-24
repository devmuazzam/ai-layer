---
title: SubJob.dasStage is derived forward-only from the ticket lifecycle, with a dispatcher override — decision
source: decision/Syed Haris
decided: 2026-09-22
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing the UAT remediation milestone;
  answered the four sub-questions of TCG-70 §2 in a working session on 2026-09-22. He is **not**
  the client-side product owner, and this note **sits against a `status: verified` ruling by
  Umair Khan** (see *What is weak about this attribution*). It therefore binds nothing yet.
  Ratification needed from **Lisette Anzaldo** (Dispatch Manager, DAS board owner) **and**
  **Umair Khan**, whose SCRUM-903 decision it partly reverses.
status: reference
conflicts_with: [decisions/2026-08-20-job-completed-on-last-day-offload.md]
resolves: []
jira: [TCG-70, TCG-184]
tags: [module/dispatch, module/field-ops, module/projects-jobs, kind/decision, das, job-status, ticket-workflow]
---

# If the DAS stage becomes ticket-derived, this is how

## Status — read this first

**Nothing in the product record settles who or what advances `SubJob.dasStage`, for any of its
nine values.** This note does not change that. It records the answers given on 2026-09-22 so the
question stops being re-derived from scratch each time it surfaces, and so a future ticket has a
concrete proposal to put in front of the two people who can actually rule on it.

**No code implements any of this.** TCG-70 shipped the safe subset instead —
[`2026-09-22-das-card-shows-ticket-status-beside-the-stage.md`](2026-09-22-das-card-shows-ticket-status-beside-the-stage.md).
The derivation is carried by **TCG-184**, which is blocked on the ratification below.

## The answers given

> **Q: Is `dasStage` a derived projection of field/yard events, or a dispatcher-owned field she
> can hold?**
> **Derived, one-way, with a dispatcher override.** The stage advances only if the current stage
> ranks strictly earlier; a sub-job at `LOADOUT` or beyond is never moved backwards. `CANCELLED`
> is absorbing. A dispatcher may still hold or override it, and her value must survive a later
> automatic write from the same trigger.

> **Q: Does "In Progress" mean the existing `WORK_IN_PROGRESS` stage, or a new stage between
> `TICKET_SENT` and `LOADOUT`?**
> **Reuse `WORK_IN_PROGRESS`.** No enum migration, no new filter pill, and no fall-through risk in
> `map-das-job-to-dylen-card.ts`, whose `default:` returns `'completed'`. Dylan's Yard board
> already buckets `TICKET_SENT`, `EMPLOYEE_LEFT_YARD` and `WORK_IN_PROGRESS` alike as
> `'in-progress'`, so reuse is a no-op there and a new stage would not have been.

> **Q: With N tickets on a sub-job, does one crew member starting move the job, or all of them?**
> **First to start.** Any one crew member punching in moves the sub-job. No aggregate rule existed
> anywhere in code or vault before this.

> **Q: Ship the audit trail with it, or separately?**
> **With it.** The audit row lands in the same PR as the derivation, and the existing write sites
> are backfilled so the trail is not half-populated.

## Why the reuse answer needs care

**`WORK_IN_PROGRESS` does not currently mean what its name says.** It is written by
`completeOffload` (`das-loadout.repository.ts`:380) — the crane coming *back* and being partly
unloaded — and `:658` overwrites it with `COMPLETED` in the same transaction when nothing remains
to offload. It therefore survives only on a **partial** offload, and it means *"partially
offloaded after the crew returned."*

So reusing it makes one stage carry two unrelated events — crew starting work, and yard finishing
a partial offload — written by two subsystems at opposite ends of the day. The implementing ticket
must decide explicitly whether that is acceptable or whether the yard write should move to a
different value, and must relabel `JOB_STAGE_LABELS` **and** `JOB_STAGE_DEFINITIONS` together so
the filter pill and the badge cannot diverge.

## What is weak about this attribution

- **The decider is not the product owner.** Same basis as the 2026-09-11 Progress Tracking notes.
- **It sits against a `status: verified` ruling.**
  [`2026-08-20-job-completed-on-last-day-offload.md`](2026-08-20-job-completed-on-last-day-offload.md)
  — **Umair Khan**, SCRUM-903 — states *"Field-ticket submission is not the sole (or required)
  completion trigger"* and explicitly puts wiring `dasStage` from the ticket lifecycle **out of
  scope**. That note is about the *submit* end and this one is about the *start* end, so they do
  not collide head-on — but they point in opposite directions about whether field events may write
  this field at all. **A `reference` note does not overrule a `verified` one.** Umair must be in
  the room.
- **The nearest adjacent question is open and unowned.** [`../dispatch/gaps.md`](../dispatch/gaps.md)
  → *Manual vs automatic offload* holds three unreconciled positions on exactly this
  manual-vs-derived shape, one stage later. **Answer both together or neither.**
- **The one recorded claim that ticket data drives a board transition is developer narration**,
  not a TCG ruling: *"it's also going to get tied to the tickets as well"*
  (`meetings/transcripts/2026-05-12-loading-figma-demo.md`:326-330).

## What the implementing ticket (TCG-184) must carry

Beyond TCG-70's AC1–AC7 and AC9–AC13:

- **`ActivityLogEntityType` has no `SUB_JOB` member** (`schema.prisma`:104-130), so the audit row
  needs an enum migration. `DasAllocationAuditLog` cannot hold it either — it is keyed to
  allocation/ticket ids with no `subJobId` and no stage columns.
- **`PATCH /sub-jobs/:subJobId` is unguarded today** (`sub-jobs.controller.ts`:44-49): no `@Roles`,
  no `@RequirePermission`, no transition validation, no audit. `@IsEnum` is the only check. The
  override in this proposal cannot ship on top of that hole.
- **The ticket-status write is not transactional** (`recordTicketStep` is a bare sequence), so a
  stage write added beside it either needs a transaction or a conscious decision to accept the
  same non-atomicity.
- **`isLocked` must become a stage-rank test**, not `=== TICKET_SENT`, and `useTicketStatuses`'
  `enabled` predicate must move to `HAS_SENT_TICKETS` — which already exists at
  `job-list-item-parts.tsx`. Otherwise the derivation unlocks dispatched jobs and deletes the slot
  pills.
- **`HARD_LOCKED_SUB_JOB_STAGES`** (`jobs.service.ts`:63-71) contains `WORK_IN_PROGRESS`. Reusing
  that stage means a crew punching in blocks the dispatcher's time-only schedule edit. **State it
  or amend the set — do not discover it.**
