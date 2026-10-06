---
title: Every day of a held job runs the normal yard flow; a held item is ticked and locked in Loadout, and locked out of Off-load until the job's last day (Fouzan Shakil, 2026-10-06) — decision
source: decision/Fouzan Shakil — the yard side of Make Holdover, revised twice after seeing the build
decided: 2026-10-06
decided_by: >-
  Fouzan Shakil (fouzan.shakil, CodingCops), in a Claude Code session on 2026-10-06 on tcg branch
  `feat/yard-holdover-loadout`. They ruled in four steps, all that day, after trying the build of
  decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md on local JOB-00053: a
  written ruling on the yard flow, a written question about the yard's button rules, a written
  ruling on Off-load followed by two option picks, and two more option picks on the Off-load
  button and the earlier days' records. The session wrote the option labels and
  descriptions; the ruling is the pick. This is a CodingCops ruling, not a TCG client
  confirmation. Lisette Anzaldo (TCG dispatch) owns the related register entries. Loadout and
  offload are the yard's steps, so Dylan Masterson (yard) should also confirm. Neither has been
  asked, and neither has confirmed it. That is why the status is `reference`: it binds the
  CodingCops build, and TCG can overrule it. Same basis as the earlier yard note.
  Revised 2026-10-06: first recorded with the held item ticked and locked in Off-load too. The
  Off-load ruling below replaced that the same day; the note now records all four exchanges.
status: reference
conflicts_with: []
resolves: []
supersedes_partial:
  - "2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md (rule 1, loaded out once: now loaded out every day, ticked and locked; rule 3's loadout half: middle days now run Mark Available and Loadout. Rule 2, offload only on the last day, and the 'day closes with held items out' default were superseded by this note's first version and are now restored, the default as a ruling. Rules 4, 5 and 6 and the definitions of held, asset lines only and the last day stand)"
related_decisions:
  - 2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md
  - 2026-10-06-cranes-550-ton-and-up-pre-ticked-for-holdover.md
  - 2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md
  - 2026-08-20-job-completed-on-last-day-offload.md
  - 2026-09-14-yard-unassigned-slots-not-loadable.md
jira: []
tags: [module/dispatch, module/assets, kind/decision, yards, daily-allocation, scheduling]
---

# Every day of a held job runs the normal yard flow; a held item is ticked and locked in Loadout, and locked out of Off-load until the last day

## The exchange

The first build followed the earlier yard ruling
(decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md). On a middle day
whose only asset was held (local JOB-00053, 2027-06-02), there was nothing to load, so *Mark
Available for Loadout* was disabled. All quotes below are Fouzan Shakil's, 2026-10-06, verbatim,
spelling as written.

**1. The normal flow.** After seeing the disabled button:

> "but that button should not be disabled then otherwise the user is blocked like i am for june 2,
> so let the user run the complete flow like how it used to before the changes in my branch, except
> the modal that opens up must show that the item is holdover and the checbox must be selected and
> disabled"

**2. The button rules.** Earlier the same day than the Off-load ruling:

> "so now, only those disabling ules exist for the buttons on the yard operations which existed
> previously. And the new rules for the holdout only change the content inside modals, right? I
> dont want you to remove the rules that had been added for a reason"

**3. Off-load.** After seeing held items tickable-and-locked as offloaded:

> "okay, and offload, why is the user being allowed to offload items that cannot be offloaded? that
> modal should have unchecked disabled checkbox along with a message on hover that says something
> like this item is holover and cannot be offloaded"

Two questions followed, and one option was picked for each. Labels and descriptions are verbatim
as shown.

| Question | Picked | Rejected |
| --- | --- | --- |
| "When a held item is left out of the Off-load (unticked, locked) on a day that isn't the last, what should happen to the day?" | **"Stays out, no reason asked"**: *"The day closes once everything else is offloaded; the held item is recorded as still on site and isn't listed in the "not offloaded" reasons step. The Off-load button only counts items that can come back. On the last day it offloads normally."* | "Ask a reason, like any item left out" |
| "On the job's last day, can the held item be offloaded?" | **"Yes, tickable as normal"** | "Ticked and locked" |

**4. The Off-load button and the earlier days' records.** Two more questions, one option picked for
each, verbatim as shown. They settle two points the build had left as defaults.

| Question | Picked | Rejected |
| --- | --- | --- |
| "On a day where the held crane is the only thing out, should Off-load still appear so the yard can close the day?" | **"Yes, keep it"**: *"Off-load shows until that day's off-load is submitted; the modal lists the crane locked and its Continue closes the day, so the yard and DAS both see the day finished."* | "No, pre-existing button rules only" |
| "When the held crane is offloaded on the job's last day, should the earlier days' loadout records of it be closed too?" | **"Yes, close them too"**: *"The last day's offload also marks the crane returned on each earlier day of the job, so no day keeps it recorded as out once the job ends."* | "No, leave them" |

## Decision

**The ruling, from the four exchanges:**

- **Every day of a held job runs the normal yard flow:** Mark Available, Loadout, Off-load.
- **The yard's button rules are the ones that existed before the holdover work**, with one
  exception (exchange 4). Holdover otherwise changes what is inside the modals, not when the
  buttons are enabled.
- **The exception:** on a day where held items are all that is out, Off-load **still shows until
  that day's off-load is submitted**. The modal lists them locked, and its Continue closes the day,
  so the yard and the DAS both see the day finished.
- **Loadout:** the held item is shown as holdover, its checkbox **selected and disabled**.
- **Off-load, before the job's last day:** the held item's checkbox is **unchecked and disabled**,
  with a hover message saying it is held over and cannot be offloaded.
  - It **stays out, no reason asked.** The day closes once everything else is offloaded.
  - It is **recorded as still on site.** It is not listed in the "not offloaded" reasons step.
  - The Off-load button counts only items that can come back.
- **Off-load, on the job's last day:** the held item is **tickable as normal** and offloads like any
  other item.
- **Closing the earlier days:** the last day's offload also marks the held item **returned on each
  earlier day** of the job, so no day keeps it recorded as out once the job ends.

**Interpretation, not Fouzan Shakil's words:**

- The Loadout lock applies on **every** day, the last day included. The last-day pick was about
  Off-load only.
- Under its *Holdover* pill, the row reads *"Stays on site until <last day>"*, or *"Comes back
  today"* on the job's last day. The hover reads *"This item is held over and can't be offloaded
  until <last day>."*
- "The held crane" in exchange 4 is read as **any held asset**, as for the rest of the yard rule.
- A last-day **Force complete** closes the earlier days for every held line, as a submitted
  Off-load does for the held items ticked in it.

## What it supersedes, what it restores, and what stands

Against decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md. The middle
column is this note's first version (exchange 1 only); the right column is the rule now.

| Earlier rule | First version (exchange 1) | Now (exchanges 1–4) |
| --- | --- | --- |
| 1. Loaded out once; then disabled in Start Loadout | Superseded: loaded out every day, ticked and locked | **Superseded**, as in the first version |
| 2. Offloaded only on the job's last day; disabled in Off-load on other days | Superseded: offloaded every day, ticked and locked | **Restored**: unticked and locked before the last day, with a hover message; tickable as normal on the last day |
| 3. Middle days: no loadout or offload option, shown disabled | Superseded: normal flow | **Split.** Loadout half superseded: ticked and locked, so it is loaded out each day. Offload half restored: shown disabled. Mark Available is never disabled because the day's only assets are held |
| 4. *Holdover* pill in both modals | Stands | **Stands**, with the "Stays on site until …" / "Comes back today" line |
| 5. Early return: dispatch releases the line in Make Holdover; that day's Off-load lists it | Moot | **Stands.** A released line is no longer held, so that day's Off-load row is tickable |
| 6. A held item blocks every other job for the whole hold, any hours | Stands | **Stands** (`HELD_ON_SITE`) |
| Built default: a day closes with held items still out, no offload reason asked | Superseded | **Restored, now ruled** ("Stays out, no reason asked") |

**Rule 6, widened 2026-10-06, later the same day.** The block now starts on the held job's first
held day, not at "its day-1 loadout". A held asset is refused to other jobs before it goes out too,
and for a held asset this overrides "Reassign anyway?"
(decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md, item 4). See
decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md (Fouzan Shakil,
`reference`). The build was already this wide; no code changed.

Also standing from the earlier note: **held** means the Make Holdover tick (`JobResource.isHoldover`)
or a day's allocation copied with *Hold over* (`JobResourceAllocation.isHoldover`); the yard rule
applies to **asset lines only**; **the last day** is the job's last active, non-cancelled schedule
row, worked out when read.

## Why

- **Exchange 1:** with Mark Available disabled, "the user is blocked like i am for june 2".
- **Exchange 2:** the earlier button rules "had been added for a reason".
- **Exchange 3:** a held item is an item "that cannot be offloaded", so the user should not be
  allowed to offload it.
- **Exchange 4**, from the option descriptions picked: keeping Off-load lets "the yard and DAS both
  see the day finished"; closing the earlier days means "no day keeps it recorded as out once the
  job ends".

No reason was given for locking the item ticked in Loadout on a day it is already on site.

## Relevant open register entries

This note does not close any entry.

- dispatch/gaps.md → *Which items of a holdover job go back to the yard between working days?*
  Dated notes under its build note point here.
- dispatch/gaps.md → *Shifts that run past their own day — what is built, what is still missing*,
  item 1. A dated note points here.
- dispatch/gaps.md → *Should the yard board show jobs that have nothing to load — one-day,
  no-equipment, trucking-only*. The earlier note left "a middle day on which every item is held"
  open against this entry. For held items that is now answered: the day runs Mark Available and
  Start Loadout like any other. The entry itself is not edited.

## What is built

Branch `feat/yard-holdover-loadout` (tcg), **uncommitted** on top of `a242e308d` when this note was
revised (2026-10-06). The first build is commit `c6f74e315`.

- **Buttons:** the yard's pre-existing button rules are unchanged. Mark Available is no longer
  disabled on a held-only day (`isAlreadyOut` removed from `phase1-selection-rules.ts` and
  `shift-unassigned-summary.ts`). The exchange-4 exception is
  `apps/web/src/features/dylen-dashboard/utils/holdover-loadout-rules.ts` `isHoldoverAwaitingClose`,
  read by `shift-loadout-utils.ts` and `dylen-phase-handover-submit.util.ts`.
- **Loadout:** the held row is ticked and locked
  (`apps/web/src/features/dylen-dashboard/hooks/use-dylen-held-asset-selection.ts`, phase 1). The
  API does not refuse a loadout that leaves a held item out.
- **Off-load:** before the last day the held row is unticked and locked, with a tooltip
  (`offloadLockedMessage`, `dylen-phase-handover-modal-phase3-section.tsx`). On the last day it is
  an ordinary row.
- **The API names the day's held items** in `DasSubJobLoadout.holdover` =
  `{ isLastDay, lastDay, heldResourceIds, stayOnSiteItemKeys }`
  (`apps/api/src/usecase/das-loadout/holdover-loadout.util.ts`). `stayOnSiteItemKeys` is the day's
  held asset rows still out, empty on the last day.
- **The API enforces the Off-load rule** (`apps/api/src/usecase/das-loadout/das-loadout.service.ts`):
  - offloading a held item before the last day is refused (400, `isOffloadHeld`);
  - deferring it in the reasons step is refused (400);
  - it is left out of the reasons step and does not keep the day open;
  - Force complete leaves it out (`das-loadout.repository.ts` `forceCompleteOffload`).
- **Unchanged:** the DAS refuses another job taking a held asset for the whole held span
  (`HELD_ON_SITE`, 409). Only the last held day's offload, or releasing the hold, frees it
  (`pickHeldOverConflict`, `apps/api/src/service/das-allocations/held-over-conflict.util.ts`,
  adjusted earlier the same day; spec in `das-allocations.repository.spec.ts`). Also unchanged: the
  job-card *Holdover · n* pill and the print sheet marker.
- **Closing the earlier days:** `DasLoadoutRepository.closeEarlierHeldRows`
  (`apps/api/src/service/das-loadout/das-loadout.repository.ts`), called through
  `closeEarlierHeldDays` in `das-loadout.service.ts`:
  - from complete-offload on the last day, for the held items offloaded in it;
  - from Force complete on the last day, for every held line.
  It marks the job's rows on earlier dates that are still out (loaded out, not fully offloaded, not
  deferred) as offloaded, stamped with the time of the last day's offload. Spec:
  `das-loadout-close-held.spec.ts`.
- **Removed and not restored:** the first build's carry of held items from earlier days onto the
  last day (`receiveHoldoverCarry` / `applyHoldoverCarry`).

## What this does NOT settle

- **Server-side Loadout lock.** The API does not refuse a loadout that omits a held item. Not asked.
  Registered 2026-10-06 as an open question for Lisette Anzaldo: dispatch/gaps.md → *Holdover
  Loadout lock — should the API refuse a Loadout that leaves a held item behind?*
- **The asset-not-home flag** (assets/gaps.md → *Asset not returned to its home yard at end of
  shift*, Q6). Whether the flag exempts a held item's on-site span is not decided.
- Everything the earlier note listed under *What this does NOT settle* still applies: which items
  are held by default, day-scoped tractor/trailer lines, the payroll link, holdable rigging, the
  last day moving into the past, a held crane swapped mid-job.

## Effect on the vault

- **decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md:** `provenance_note:`
  points here and names the superseded, restored and standing parts. Done. Its `status:` stays
  `reference`, since it is only partly superseded, following the practice for `supersedes_partial`
  notes (for example decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md).
  Body unchanged.
- **No other frontmatter edits.** No file becomes `verified` or `superseded`, and no
  `conflicts_with:` pair is adjudicated. This note is `reference`.
- **Register:** dated notes in dispatch/gaps.md under the build note of *Which items of a holdover
  job go back to the yard between working days?* and under item 1 of *Shifts that run past their
  own day*. Done. No `Status:` line was changed.
- **Not indexed.** Like the earlier yard note, this note is not listed in INDEX.md or
  dispatch/INDEX.md. It is found by its `module/dispatch` tag.
