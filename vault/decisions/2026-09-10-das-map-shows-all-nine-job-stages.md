---
title: The DAS map shows all nine SubJob stages, not the Yard Operations four-bucket collapse — decision
source: decision/Akif Farooq
decided: 2026-09-10
decided_by: >-
  Akif Farooq (m.akif.farooq@gmail.com) — developer on `scrum-252`. Decided during the branch,
  after the 2026-09-09 review found the four-bucket collapse produced a cancelled job reading
  differently on the two screens. Recorded `status: reference`: binding on implementation now,
  open to being overruled by Lisette Anzaldo, who owns the DAS board.
status: reference
conflicts_with: []
resolves: aidlc/SCRUM-252/spec.md#q5--nine-stages-or-four-on-the-dispatchers-map
jira: [SCRUM-252]
tags: [module/dispatch, kind/decision, das, map-view, job-status]
---

# The DAS map shows the job's own stage, unbucketed

## Decision

**The DAS map's job badge shows the sub-job's own `dasStage`, all nine values, using the same
labels and colours as the DAS jobs board** (`JOB_STAGE_LABELS` / `JOB_STAGE_BADGE_STYLES` in
`apps/web/src/features/das/middle-section/jobs/constants`).

It does **not** collapse them into the Yard Operations board's four display statuses
(*Pending Loadout* / *In Progress* / *Completed*, plus a fall-through).

**This is a change made during the branch, not the behaviour first reviewed.** The earlier
implementation (commit `b69d5406`) did collapse to four; the current implementation
(`fbaebb9f`) does not. Anything citing `das-map.service.ts:21` as the site of a four-bucket
map is reading the superseded version.

## Why

**The four-bucket model is written down, but explicitly for Dylan, and for a stated reason
that does not carry to a dispatcher.**
[`../meetings/transcripts/2026-05-12-loading-figma-demo.md`](../meetings/transcripts/2026-05-12-loading-figma-demo.md):315,
`ehtesham.anwar`:

> They are in transit, they are at the job, they are working or on the break, then coming
> back, then arriving at the yard. **All of those statuses are for Dylan. That's in progress.
> He doesn't need to do anything.**

The collapse exists because the yard manager has **no action to take** while a crane is out.
The Dispatch Manager does — the fine-grained stages are what tell her whether to expect a
ticket, chase a crew, or re-plan the afternoon. The reasoning behind the four buckets is an
argument about Dylan's job, not a taxonomy of job stages.

**The DAS record says the opposite for the dispatcher's own screen.**
[`../dispatch/daily-allocation-system.md`](../dispatch/daily-allocation-system.md):33
(`status: unverified`) has the DAS jobs panel filter *"covering all statuses (Open → Ticket
Submitted)"*, and :60 gives the full progression. The 2026-04-21 demo walks the client through
eight distinct job chips. Nothing in the DAS record asks for four.

**And bucketing actively caused a defect.** The four-bucket version claimed parity with the
Yard Operations board — the code comment read *"a job never reads differently on the two
screens"* — and did not deliver it: `CANCELLED` has no case in
`apps/web/src/features/dylen-dashboard/utils/map-das-job-to-dylen-card.ts`, which falls
through to `default: return 'pending-loadout'`. So a cancelled job read *Cancelled* on the map
and *Pending Loadout* on Dylan's board. Reusing the jobs board's own constants removes the
second list entirely, and with it the thing the first list could disagree with.

### The case against

Two screens now describe the same job with different vocabularies — nine stages on DAS,
four buckets on Yard Ops. That is a real inconsistency, and "the map should match the board
beside it" was the original instinct. The answer is that they are **two boards for two
people**, and each map now matches *its own* board rather than the other one's.

## What this does not settle — and one defect it does not fix

- **The Yard Operations / Dylen bucket set itself stays open.** Which stages fall in which
  bucket, and whether `LOADOUT` reads as *Pending Loadout* or *In Progress*, is unruled —
  [`../dispatch/gaps.md`](../dispatch/gaps.md) → *DAS map job status buckets*. This decision
  narrows that question to the Yard Ops board; it does not answer it.
- **The `CANCELLED` gap on the Yard Operations board — fixed separately, 2026-09-10.**
  Removing the map's bucketing fixed the *map*, not Dylan's board, where a cancelled sub-job
  was still badged *Pending Loadout* and counted in that filter. That board now carries a
  fifth display status, `cancelled`. Detail and the correction to the original framing — the
  loadout actions were never actually available, so it was a labelling defect rather than an
  operational one — in [`aidlc/SCRUM-252/spec.md`](../../aidlc/SCRUM-252/spec.md) §12 Q5a.
  **The fifth bucket is not an answer to the bucket-set question**, which stays open.
- **Whether a cancelled job should be drawn on the map at all** — open,
  [`../dispatch/gaps.md`](../dispatch/gaps.md) → *Cancelled sub-jobs on the DAS map*. Badging
  a stage is not a ruling on whether the row appears.
