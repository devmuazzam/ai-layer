---
title: A held item is loaded out once and offloaded only on the job's last day; the yard shows it disabled with a Holdover pill (Fouzan Shakil, 2026-10-06) — decision
source: decision/Fouzan Shakil — the yard side of Make Holdover (loadout, offload, early return, blocking)
decided: 2026-10-06
decided_by: >-
  Fouzan Shakil (fouzan.shakil, CodingCops), stated in a Claude Code session on 2026-10-06 while
  starting branch `feat/yard-holdover-loadout` (tcg). They wrote a request, then picked one option
  for each of three questions. The option labels and descriptions were written by the session; the
  ruling is the pick. This is a CodingCops ruling, not a TCG client confirmation. Lisette Anzaldo (TCG dispatch)
  owns the related register entries. Loadout and offload are the yard's steps, so Dylan Masterson
  (yard) should also confirm. Neither has been asked, and neither has confirmed it. That is why the
  status is `reference`: it binds the CodingCops build, and TCG can overrule it. The basis is the
  same as decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md.
  Attribution corrected 2026-10-06: first recorded as Syed Haris; the developer confirmed in
  the same session that the ruling was Fouzan Shakil's.
status: reference
conflicts_with: []
provenance_note: >-
  PARTLY SUPERSEDED the same day by
  decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md (Fouzan Shakil,
  `reference`), revised twice that day. Every day of a held job now runs the normal yard flow. In
  Loadout a held item is ticked and locked, so it is loaded out each day. In Off-load it is
  unticked and locked before the last day, and tickable on the last day. SUPERSEDED: rule 1
  (loaded out once) and rule 3's loadout half (middle days now run Mark Available and Loadout).
  RESTORED after a brief supersession: rule 2 (offloaded only on the last day) and the default that
  a day closes with held items out, no reason asked (now ruled). STAND: rule 3's offload half,
  rule 4 (Holdover pill), rule 5 (early return), rule 6 (blocking) and the definitions of held,
  asset lines only and the last day. Body unchanged.
resolves: []
related_decisions:
  - 2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md
  - 2026-08-20-job-completed-on-last-day-offload.md
  - 2026-09-14-yard-unassigned-slots-not-loadable.md
  - 2026-09-15-fix-15-sep-das-and-quotations-as-built.md
jira: []
tags: [module/dispatch, module/assets, kind/decision, yards, daily-allocation, scheduling]
---

# A held item is loaded out once and offloaded on the job's last day; the yard shows it, disabled

## The exchange

Fouzan Shakil, 2026-10-06, verbatim:

> "When holdover items are present on a job.
>  1. They will be undergoing loadout normally on the first day, but the offloading will be disabled
>     on all of the days except the last.
>  2. For the middle days the "holdover" items will have no option to loadout or offload.
> • This will be handled by using disabled checks on modal rather than hiding the item completely as
>   that is confusing.
> • On the modal, the "holdover" will have holdover pills to clearly differentiate between what will
>   stay on yard and what is coming back"

Three questions followed, and one option was picked for each. Labels and descriptions are verbatim
as shown.

| Question | Picked | Rejected |
| --- | --- | --- |
| "Should a held item's loadout/offload follow where the item actually is, or strictly the day number?" | **"Where it actually is"**: *"Loadout is allowed until the item has gone out; offload only on the job's last day. Same as your rule normally, but a crane allocated late or a holdover set mid-job can still be loaded out."* | "Strict day number" |
| "A held crane breaks down or has to come back on a middle day. How does the yard bring it back?" | **"Release it in Make Holdover"**: *"Dispatch unticks it; that day's Off-load then lists it as a normal item. No new controls in the yard modal."* | A yard override with a reason (not in this version) |
| "Should a held crane that's on site block other jobs for the whole hold?" | **"Block the whole hold"**: *"From its day-1 loadout until the last-day offload, any other job is refused, whatever the hours."* | Refuse only overlapping hours (the TCG-186 window); leave as built |

## Decision

**Interpretation, not the ruling's words.**

- "Stay on yard" in the request is read as **"stay on site"**. The pill marks what stays out.
- **Held** means either:
  - the per-line *Make Holdover* tick (`JobResource.isHoldover`), or
  - a day's allocation copied with *Hold over* (`JobResourceAllocation.isHoldover`).
  It does not mean payroll's job-level subsistence holdover (`Job.subsistenceHoldover`).
- **In the yard this applies to asset lines only.**
  - Employees are not loaded out or offloaded (decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md,
    item 1).
  - Tools and rigging cannot be held (dispatch/gaps.md → *Make Holdover — which job lines can be
    held?*).
- **"The last day"** is the job's last active, non-cancelled schedule row, by date and then sort
  order. It is worked out when read, so adding or removing days moves it.
- **"On site"** means loaded out on an earlier day, or an earlier shift of the same job, and not
  offloaded or deferred since.

**The rules, for a held asset:**

1. **Loadout.** It is loaded out normally until it has gone out. That is usually day 1, but a crane
   allocated late, or held from mid-job, is loaded out on the first day it actually goes. Once it is
   on site, the Start Loadout modal shows it **disabled** and it cannot be loaded out again.
2. **Offload.** It is offloaded only on the job's last day. On every other day the Off-load modal
   shows it **disabled**.
3. **Middle days.** No loadout or offload option. It is shown, disabled, not hidden.
4. **Holdover pill.** In both modals a held item carries a *Holdover* pill, so the yard can tell what
   stays on site from what comes back.
5. **Early return.** A held item that must come back on a middle day (breakdown, needed elsewhere)
   is **released by dispatch in Make Holdover**. That day's Off-load then lists it as a normal item.
   The yard gets no override and no new control.
6. **Blocking.** A held item on site blocks every other job for the whole hold, whatever the hours:
   from its day-1 loadout until the last-day offload.

An item that is **not** held is unchanged. Under the 2026-10-01 ruling it goes back to the yard every
day.

**Defaults chosen for the build, not the ruling's words** (branch `feat/yard-holdover-loadout`, not yet
built; see *What is built*):

- On day 1, when only held items are still out, the Off-load modal still opens. It shows them
  disabled, and its button closes the day's offload.
- Why that matters (read from the written rollup, not from Fouzan Shakil): a job completes when every
  non-cancelled day has finished yard offload (decisions/2026-08-20-job-completed-on-last-day-offload.md,
  *Implementation reading*). Without this, a day whose only outstanding items are held could never
  finish offload.

## Why

The request's own reason: hiding a held item "is confusing", so it is shown disabled. The option
descriptions picked add two more:

- following where the item actually is lets "a crane allocated late or a holdover set mid-job" still
  be loaded out;
- releasing in Make Holdover needs "no new controls in the yard modal".

No reason was given for blocking the whole hold.

The record is consistent with the ruling, but none of it rules:

- **Ryan Adams (TCG, Sales Manager), 2026-04-23**,
  meetings/transcripts/2026-04-23-dispatch-scheduling-loading-vendors.md:222 (55:46) *"…that job
  stays ongoing, so it never has to."* continuing at :226 (56:20) *"be labeled for an offload as long
  as it's ongoing. And then as soon as that job's complete on the last day, then it logs it, which
  would then prompt warehouse to offload it."* (Lines 223–225 are one-word interjections.)
  - He was speaking of the whole job, not of a held item.
  - ehtesham.anwar (CodingCops) answered at :227 (56:22) that loading would run *"for each ticket,
    by default means each shift"*. Equipment not brought back at the end of a shift *"by default
    means it is on location"*.
- **Melissa McNutt (TCG, President), 2026-07-01**,
  meetings/transcripts/2026-07-01-erp-sprint-reviews-loading-workflow.md:163 (29:38): *"Dylan really
  only knows, needs to know stuff that's getting loaded, unloading for particular job sites or things
  are going out on job sites for long periods of time."*
- **jahanzaib.nadeem (CodingCops developer)**, same file, :164 (29:55): *"if the same asset is
  assigned to multiple shifts on the same job, then we should not show the offloading of that asset"*.
  This is a developer's proposal, not a TCG statement.
- **"Brian Petros", 2026-04-23**, meetings/transcripts/2026-04-23-dispatch-scheduling-loading-vendors.md:185
  (44:12): *"we should be reassured from the system to let us know that, no, that vehicle is not
  going to be leaving from our yard, it's already on site"*.
  - The speaker label is uncertain. Room-mic recordings mislabel Lisette, Dylan, Liz, Ryan and Wes
    as "Brian Petros" (meetings/transcripts/NORMALIZATION.md, *What was deliberately not done*).
- **UI precedent.** decisions/2026-09-14-yard-unassigned-slots-not-loadable.md (`reference`), Q1: an
  unassigned row in the loadout modal is *"Shown, greyed, unselectable — not hidden"*.
- **Job completion.** decisions/2026-08-20-job-completed-on-last-day-offload.md (`verified`, Umair
  Khan): a multi-day job becomes Completed when its last scheduled day's offload is done. Offloading
  held items on that day fits it.

## Relevant open register entries

This note does not close any entry.

- dispatch/gaps.md → *Which items of a holdover job go back to the yard between working days?*
  - Settled here: the loadout half, and what the yard modals show.
  - Not settled: which items are held by default; the multi-day *shift* without holdover.
- dispatch/gaps.md → *Allocating by shift time (TCG-186) — which window holds a crane or crew
  member?*
  - Question (c) is answered here: a held item on site blocks other jobs for the whole hold, any
    hours.
  - (a), (b) and (d)–(h) are not touched. That includes (e), a crane that is not held and is still
    loaded out.
- dispatch/gaps.md → *Make Holdover — does holding an item carry its allocation forward on its own?*
  - Question (c), releasing, is partly answered: release in Make Holdover brings the item back
    through that day's Off-load.
  - Whether the carried allocations on later days should also be removed is still open.
- dispatch/gaps.md → *Shifts that run past their own day — what is built, what is still missing*,
  item 1.
  - The yard board still lists jobs by row date. The continuing card is not part of this branch.

## What is built

**Not built when this note was written (2026-10-06).**

- tcg branch `feat/yard-holdover-loadout` has no commits beyond `main` (`3b7c18664`).
- `apps/web/src/features/dylen-dashboard/`, `apps/api/src/usecase/das-loadout/` and
  `apps/api/src/service/das-loadout/` still contain no reference to holdover.
- Make Holdover itself is on `main`: branch `feat/schedule-datetime-holdover` merged as PR #708
  (`ca73572d4`), with `JobResource.isHoldover` and `JobResourceAllocation.isHoldover` in
  `apps/api/prisma/schema.prisma`.

## What this does NOT settle

- **Which items are held by default.** Make Holdover pre-ticks nothing. Whether the crane stays and
  the tractor comes back is still the open register question.
- **A tractor or trailer needed only on the first and last day.** Job lines are not day-scoped, so a
  line cannot be "out on day 1 and day n only". See dispatch/gaps.md → *An assist crane needed only
  on some days of a multi-day job — setup and breakdown*.
- **The payroll link.** Whether a held line means anything for subsistence (`Job.subsistenceHoldover`,
  PAY-049). See dispatch/gaps.md → *Is the DAS holdover the same thing as payroll's subsistence
  holdover?*.
- **Holdable rigging.** Tools and rigging cannot be held today, so this ruling does not reach them.
  Whether rigging that stays on site should be holdable is open: dispatch/gaps.md → *Make Holdover —
  which job lines can be held?*.
- **A held item that never went out on day 1.** Its day-1 allocation exists, but it did not
  physically leave. Under the chosen rule it is loaded out on the first day it actually goes.
  Whether the DAS should show it as *on site* before then is not settled.
- **A middle day on which every item is held.** Whether that day needs Mark Available or Start
  Loadout at all, or should appear on the yard board. See dispatch/gaps.md → *Should the yard board
  show jobs that have nothing to load — one-day, no-equipment, trucking-only*.
- **The last day moving into the past.** If later days are removed after the new last day has gone
  by, the held item was disabled for offload on that day. What the yard does then is not stated.
- **A held crane swapped for another mid-job.** The incoming crane is loaded out under rule 1. The
  ruling does not say how the outgoing one comes back: it was replaced, not released.
- **The asset-not-home flag** (assets/gaps.md → *Asset not returned to its home yard at end of
  shift — a requested flag with no owner, no yard geometry and no shift end*, Q6). Whether the flag
  exempts exactly the on-site window defined here is not decided.

## Effect on the vault

- **No frontmatter edits.** No vault file specified the yard side of a holdover. So no file becomes
  `verified` or `superseded`, and no `conflicts_with:` pair is adjudicated. This note is `reference`,
  not `verified`.
- **Register:** dated notes pointing here were appended to the four dispatch/gaps.md entries above,
  and to Q6 of assets/gaps.md → *Asset not returned to its home yard at end of shift*. No `Status:`
  line was changed.
- **Not indexed.** Like the 2026-10-01 decisions, this note is not listed in INDEX.md or
  dispatch/INDEX.md. It is found by its `module/dispatch` tag.
