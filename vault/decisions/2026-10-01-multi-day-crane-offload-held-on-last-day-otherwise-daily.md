---
title: A held-over item is offloaded on the job's last day, an item not held over every day (Syed Haris, 2026-10-01) — decision
source: decision/Syed Haris — answering "When is a multi-day crane offloaded?" (D2)
decided: 2026-10-01
decided_by: >-
  Syed Haris (syed.haris, CodingCops), stated in a Claude Code session on 2026-10-01 while building
  branch `feat/schedule-datetime-holdover`. This is a CodingCops ruling, not a TCG client
  confirmation. The related register entries name Lisette Anzaldo (TCG dispatch) as the owner.
  Offload is the yard's step, so Dylan Masterson (yard) should also confirm the offload rule.
  Neither has been asked, and neither has confirmed it. That is why the status is `reference`: it
  binds the CodingCops build, and TCG can overrule it. The basis is the same as
  decisions/2026-09-30-schedule-shift-may-run-past-24-hours.md.
status: reference
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-01-das-shift-runs-to-estimated-end-and-shows-on-every-day.md
  - 2026-09-30-schedule-shift-may-run-past-24-hours.md
jira: []
tags: [module/dispatch, module/assets, kind/decision, yards, daily-allocation, scheduling]
---

# A held-over item is offloaded on the job's last day; otherwise every day

## The exchange

Asked (D2): "When is a multi-day crane offloaded?"

Syed Haris, 2026-10-01, verbatim:

> "If holdover is applied then the last day of the job, otherwise if its without the holdover check
> then everyday"

## Decision

**Interpretation, not his words.** "Holdover applied" and "the holdover check" are read as the
per-line *Make Holdover* setting (`JobResource.isHoldover`, the tick in the Make Holdover modal and
in Copy Allocations' *Hold over*). They are not read as payroll's job-level subsistence holdover
(`Job.subsistenceHoldover`).

1. **An item that is held over is offloaded once, on the job's last day.** It stays on site between
   working days.
2. **An item that is not held over goes back to the yard every working day.** It is offloaded at the
   end of each day.

Read this way, the rule works **per item, not per job**. On a holdover job, a crane that is held
stays out. A tractor that is not ticked comes back each day.

That matches the two sources in the register:

- Lisette's description in dispatch/crane-configuration-rules.md §10 (`reference`): *"they bring
  back the tractor and sometimes the trailer comes back or sometimes it stays"*.
- The built modal banner: *"Selected assets and resources stay on site between working days and
  don't return to the yard until the job ends"*.

The ruling does not say "per item". That reading comes from "the holdover check" being a per-line
tick.

## Why

Syed Haris gave no reasoning, and this note does not add any.

The ruling is consistent with the written record, but that record does not rule:

- dispatch/dispatch-sheet-workbook.md §4 (`unverified`) marks a holdover's load or tractor `onsite`:
  *"already at the job site and is not leaving the yard that day"*.
- dispatch/crane-configuration-rules.md §10 (`reference`) says the crew uses personal vehicles until
  the last day, *"when the tractor and trailer must go back out"*.

## Relevant open register entries

This note does not close either entry.

- dispatch/gaps.md → *Which items of a holdover job go back to the yard between working days?*
  (`#which-items-of-a-holdover-job-go-back-to-the-yard-between-working-days`).
  - Settled here: what happens to an item **according to** its hold tick. It stays until the last
    day, or it returns daily.
  - Not settled: **which items** normally stay, and whether the modal should pre-tick a default.
  - Not settled: whether the first/last-day pattern needs its own configuration variant.
- dispatch/gaps.md → *Make Holdover — does holding an item carry its allocation forward on its own?*
  (`#make-holdover--does-holding-an-item-carry-its-allocation-forward-on-its-own`).
  - The ruling assumes a held item is on site every day of the job. That fits the built
    carry-forward.
  - It does not ratify the carry-forward mechanics, or sub-questions (a) to (d) of that entry.

## What is built (branch `feat/schedule-datetime-holdover`, not merged)

**Not built.** The yard dashboard and loadout are unchanged on the branch. Checked 2026-10-01:

- `apps/web/src/features/dylen-dashboard/`, `apps/api/src/usecase/das-loadout/` and
  `apps/api/src/service/das-loadout/` contain no reference to holdover.
- Offload today is per sub-job (day) and per shift (`DasLoadoutService.getOffloadOptions` /
  `completeOffload`, `apps/api/src/usecase/das-loadout/das-loadout.service.ts`).
- Today an item stays out only when the yard crew chooses, item by item, at offload. They give a
  reason and defer it to the next shift or schedule (`das-loadout-defer-allocation.util.ts`). The
  hold tick plays no part in that.
- Offload itself is manual. Whether it should be manual is a separate open question:
  dispatch/gaps.md → *Manual vs automatic offload*. This ruling says **when** an item is offloaded,
  not **how**.

**Update 2026-10-06: built** on tcg branch `feat/yard-holdover-loadout` (not merged), through
decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md (`reference`). A held asset
is not offloaded before the job's last day: its Off-load row is unticked and locked, and the API
refuses offloading it (`isOffloadHeld`, `apps/api/src/usecase/das-loadout/das-loadout.service.ts`).
On the last day it offloads like any other item. An item not held offloads every day, as before.
The *Loadout* point under *What this does NOT settle* is answered there too: every day runs the
normal flow, the held item ticked and locked in Loadout.

## What this does NOT settle

- **A single multi-day *shift* without holdover.** This is different from a multi-day *job*.
  - Since 2026-09-30, one shift on one row may run for several days.
  - Does "everyday" mean an item not held over returns to the yard **every night, mid-shift**? Or is
    it offloaded once, at the shift's Estimated End?
  - The ruling was given about a multi-day *job* and does not say.
  - **Update 2026-10-07: such a shift can no longer be held.** Holdover now needs two or more
    working days, counted as active, non-cancelled schedule rows, and a multi-day shift on one row
    counts as one
    ([2026-10-07-holdover-not-allowed-on-a-single-day-job.md](2026-10-07-holdover-not-allowed-on-a-single-day-job.md),
    `reference`, Fouzan Shakil; tcg branch `feat/holdover-single-day-block`, not merged). So in
    practice it is always "without holdover". Nobody asked about this case; it follows from how
    days are counted. Whether the crane comes back each night mid-shift, or once at the Estimated
    End, is still not answered.
- **Employee lines.** A held employee line exists. What does "offloaded" mean for a person: no daily
  yard return, personal vehicle to site? Does it differ from equipment?
- **"The last day of the job"** when the schedule changes after the hold:
  - days are added or removed;
  - the job ends early;
  - the hold is **released** mid-job. Is the item offloaded that same day?
- **Loadout.** The ruling speaks of offload only. It does not say whether a held item is loaded out
  once on day 1 and then skipped on the yard board until the last day, or what the yard board shows
  for it in between.
- **The asset-not-home flag.** Corrina Bustos's flag (dispatch/gaps.md → *Pointer — asset-not-home
  flag depends on the holdover definition*) is worded for an asset **not on a holdover job**.
  - Under this per-item reading, an item **not held** on a holdover job is also expected home each
    night.
  - So the flag would key on the item, not the job. That is an inference for Corrina Bustos and
    Lisette Anzaldo to confirm. It is not decided here.
- **DAS holdover vs payroll subsistence holdover** (dispatch/gaps.md → *Is the DAS holdover the same
  thing as payroll's subsistence holdover?*). Not addressed.

## Effect on the vault

- **No frontmatter edits.** No vault file specified when a multi-day crane is offloaded. So no file
  becomes `verified` or `superseded`, and no `conflicts_with:` pair is adjudicated. This note is
  `reference`, not `verified`.
- **Register: not edited by this note's author.** The note was written under an instruction not to
  touch any `gaps.md`. Another agent in the same session is updating dispatch/gaps.md to link this
  note from the two entries above. Until that lands, neither entry points here.
- **Update 2026-10-06:** dispatch/gaps.md → *Which items of a holdover job go back to the yard
  between working days?* now points here (its *Partly answered 2026-10-01* bullet), and so does
  item 1 of *Shifts that run past their own day*. *Make Holdover — does holding an item carry its
  allocation forward on its own?* still does not. Built: see the 2026-10-06 update under *What is
  built*.
