---
title: Holdover is not allowed on a single-day job; Make / Edit Holdover stays disabled and says why on hover (Fouzan Shakil, 2026-10-07) — decision
source: decision/Fouzan Shakil — a request while building tcg branch `feat/holdover-single-day-block`
decided: 2026-10-07
decided_by: >-
  Fouzan Shakil (fouzan.shakil, CodingCops developer), stated in a Claude Code session on
  2026-10-07 as a one-line request. No options were offered; the ruling is his sentence, quoted
  below. Three readings of it are the build's, and are marked as interpretation. This is a
  CodingCops ruling, not a TCG client confirmation. Lisette Anzaldo (TCG dispatch) owns the related
  register entries. She was not asked, and has not confirmed it. That is why the status is
  `reference`: it binds the CodingCops build, and TCG can overrule it. Same basis as
  decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md.
status: reference
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-06-cranes-550-ton-and-up-pre-ticked-for-holdover.md
  - 2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md
  - 2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md
  - 2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md
  - 2026-09-30-schedule-shift-may-run-past-24-hours.md
jira: []
tags: [module/dispatch, module/projects-jobs, kind/decision, scheduling, daily-allocation]
---

# Holdover is not allowed on a single-day job

## The exchange

Fouzan Shakil, 2026-10-07, verbatim:

> "I just want to add a check that if a job is only of one day the holover modal buttons must stay
> disabled and on hover tell the user that for a single day job holdover is not allowed"

No question or options were put to him. The rest of this note is the build's reading of that
sentence.

## Decision

**The ruling, from his words:**

- On a job of **one day**, the buttons that open Make Holdover **stay disabled**.
- **Hovering** a disabled button tells the user that holdover is not allowed on a single-day job.

**Interpretation, not his words.**

- **"One day" means one working day:** one active (ticked) schedule row whose sub-job is not
  cancelled. An active row with no sub-job yet also counts. The calendar span of the schedule is
  not used.
- **Zero working days is blocked too.** A job with no active, non-cancelled row cannot be held
  either. It gets its own hover text, below. He spoke of one day only.
- **The API enforces it as well as the UI.** He asked for disabled buttons. The build also has the
  API refuse a holdover set on such a job, so a stale page or a direct call cannot get round it.
- **"The holdover modal buttons"** is read as the two buttons that open the modal: *Make Holdover*,
  and *Edit Holdover* once something is held. Both surfaces that offer them are covered: the job
  Schedule tab footer and the DAS board.

## Why

He gave no reason. The commit's reason (tcg `20a7f5cbc`, not his words): *"Holdover keeps items on
site between working days, so a job of one working day has nothing to hold over."*

## What is built

**tcg branch `feat/holdover-single-day-block`, commit `20a7f5cbc`, not merged.**

- **The count.** `GET` and `PUT /jobs/:jobId/holdover` return `workingDays`, computed from the
  saved schedule by `JobHoldoverRepository.countWorkingDays`
  (`apps/api/src/service/job-holdover/job-holdover.repository.ts`).
- **The buttons.** Make / Edit Holdover is disabled when `workingDays` is below 2, on the Schedule
  tab footer
  (`apps/web/src/features/projects/jobs/job-details/schedule/components/schedule-holdover-action.tsx`)
  and on the DAS board (`apps/web/src/features/das/middle-section/jobs/components/job-expanded-actions.tsx`).
  The hover text sits on a wrapper, because a disabled button receives no pointer events.
- **The hover text.** One helper, `holdoverUnavailableReason`
  (`apps/web/src/features/job-holdover/utils/holdover-selection.ts`), so both surfaces agree:
  - one working day: *"Holdover is not allowed on a single-day job."*
  - zero working days: *"Holdover needs a schedule of two or more working days."*
- **The API.** `MIN_HOLDOVER_DAYS = 2` in `apps/api/src/usecase/jobs/job-holdover.service.ts`. A
  non-empty holdover set on a job below 2 working days is refused with 400, *"Holdover is not
  allowed on a single-day job."* (the same text for zero days). **Releasing, an empty set, stays
  allowed.**
- Tests: `holdover-selection.test.mjs` (web) and `job-holdover.service.spec.ts` (api).
- **Same branch, no ruling needed** (commit `58bb0ee49`): hovering the Schedule tab's *Holdover*
  pill lists the held items by name, as "Operator (550 Ton Crane)".
- **Built, then dropped after review:** a lock on removing or replacing a held line on the job's
  middle days. It also locked crew lines, against dispatch/daily-allocation-system.md:64
  (`unverified`), and had a guard-ordering bug. Not on the branch. Filed as an open question:
  dispatch/gaps.md → *Make Holdover — may a held line be removed or replaced on a middle day?*

## What this does NOT settle

- **A held job later cut to one day.** Edit Holdover is disabled there too, so the held lines
  cannot be released from the UI. The API would accept the release (an empty set). Messages
  elsewhere still tell the user to *"Release it in Make Holdover on that job first."*
  (`formatHeldOverMessage`, `apps/api/src/service/das-allocations/held-over-conflict.util.ts`).
  Not asked.
- **Copy Allocations with *Hold over*.** It marks the line held through `markHeld`
  (`apps/api/src/usecase/das-allocations/das-allocations.service.ts`), and that path does not
  check the working-day count. A single-day job can still become held that way. Not asked.
- **A single schedule row whose shift runs several days**
  (decisions/2026-09-30-schedule-shift-may-run-past-24-hours.md) counts as **one working day**, so
  it cannot be held.
  - In practice this settles the holdover half of an open item: *"A single multi-day shift without
    holdover"* (decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md →
    *What this does NOT settle*; dispatch/gaps.md → *Which items of a holdover job go back to the
    yard between working days?* and *Shifts that run past their own day* (f)). Such a shift is now
    always "without holdover".
  - **Nobody asked about it.** It follows from counting rows, not from the ruling. Whether a crane
    on such a shift comes back to the yard each night mid-shift is still not answered.
- **A stale count on the DAS board.** No socket event refreshes `workingDays` there, so the button
  can be out of date for up to the board's 30-second stale time
  (`apps/web/src/providers/query-provider.tsx`) after a schedule change. The API's 400 is the
  backstop.
- **The 550 t pre-tick on a one-day job.** The button is disabled, so the pre-tick of
  decisions/2026-10-06-cranes-550-ton-and-up-pre-ticked-for-holdover.md is never shown there. That
  ruling is otherwise unchanged.

## Effect on the vault

- **No frontmatter edits.** No vault file specified a minimum length for a holdover job. So no file
  becomes `verified` or `superseded`, and no `conflicts_with:` pair is adjudicated. This note is
  `reference`, not `verified`.
- **decisions/2026-10-06-cranes-550-ton-and-up-pre-ticked-for-holdover.md:** a dated pointer under
  *What this does NOT settle*. Done. `status:` stays `reference`.
- **decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md:** a dated
  pointer under the multi-day *shift* bullet of *What this does NOT settle*. Done. `status:` stays
  `reference`.
- **Register (dispatch/gaps.md), dated 2026-10-07 notes, no `Status:` line changed:**
  - *Make Holdover — every unit of a line, who may set it, and at what stage?*, under (c)'s built
    default. Done.
  - *Which items of a holdover job go back to the yard between working days?*, under the
    *Partly answered 2026-10-01* bullet (the multi-day shift). Done.
  - *Shifts that run past their own day*, under (f). Done.
- **Register, new open entry:** *Make Holdover — may a held line be removed or replaced on a middle
  day?* (`Status: open`, owner Lisette Anzaldo). Done.
- **Not indexed.** Like the other 2026-10-06 decisions, this note is not listed in INDEX.md or
  dispatch/INDEX.md. It is found by its `module/dispatch` tag.
