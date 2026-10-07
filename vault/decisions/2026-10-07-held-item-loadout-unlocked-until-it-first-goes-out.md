---
title: A held item can go out on any day of the job; in Loadout it is unticked and tickable until it first goes out, then ticked and locked (Jz-Nd, 2026-10-07) — decision
source: decision/Jz-Nd — the Loadout half of the yard holdover rule, revised while building tcg branch `feat/holdover-improvements`
decided: 2026-10-07
decided_by: >-
  The developer committing as git user `Jz-Nd` (syedharis14@gmail.com), CodingCops, in a Claude
  Code session on 2026-10-07 on tcg branch `feat/holdover-improvements`. Their real name was not
  stated in the session and is not guessed here; they are recorded by that git identity. They wrote
  a request, then picked one option for each of three questions. The session wrote the option
  labels and descriptions; the ruling is the pick. This is a CodingCops ruling, not a TCG client
  confirmation. Lisette Anzaldo (TCG dispatch) owns the related register entries. Loadout is the
  yard's step, so Dylan Masterson (yard) should also confirm. Neither has been asked, and neither
  has confirmed it. That is why the status is `reference`: it binds the CodingCops build, and TCG
  can overrule it. Same basis as
  decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md (Fouzan Shakil).
status: reference
conflicts_with: []
resolves: []
supersedes_partial:
  - "2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md (the Loadout rule only: 'the held item is shown as holdover, its checkbox selected and disabled', and its interpretation that the Loadout lock applies on every day, the last day included. Now: unticked and tickable until the item has first gone out; ticked and locked only on days after it went out and while it is still out. Every Off-load rule, the button rules and the exchange-4 rulings stand)"
related_decisions:
  - 2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md
  - 2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md
  - 2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md
  - 2026-10-06-cranes-550-ton-and-up-pre-ticked-for-holdover.md
  - 2026-10-07-holdover-not-allowed-on-a-single-day-job.md
jira: []
tags: [module/dispatch, module/assets, kind/decision, yards, daily-allocation, scheduling]
---

# A held item can go out on any day of the job; Loadout leaves it unticked and tickable until it first goes out

## The exchange

Under decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md, the held item's
Loadout checkbox was ticked and locked on every day, from the first. Quotes below are the
developer's (`Jz-Nd`), 2026-10-07, verbatim, spelling as written.

**1. The request:**

> "when loading out, on the first day, the holover item checkbox must not be disabled, since the
> user can send it later as well, right? ask me if you do not understand this change: holdover
> items can be sent any day"

**2. Three questions**, one option picked for each. Labels and descriptions are as shown in the
session.

| Question | Picked | Rejected |
| --- | --- | --- |
| "On which days should the held item's Loadout checkbox be unlocked?" | **"Until it first goes out"**: *"Unlocked on every day until the item is loaded out. After that it is on site, so on later days it shows ticked and locked as today."* | "Every day, always" (unlocked even after it has gone out on an earlier day); "First day only" (unlocked on day 1 only, ticked and locked from day 2 whether or not it went out) |
| "When the checkbox is unlocked, should it start ticked or unticked?" | **"Unticked"**: *"Starts unticked; the yard ticks it on the day it actually goes out."* | "Pre-ticked" |
| "Should I record your ruling in the vault?" | **"Yes, record it"** | — |

## Decision

- **A held item can go out on any day of the job.** It does not have to go out on day 1.
- **Until it has gone out**, in Yard Operations Loadout it is an **ordinary row: unticked and
  tickable**. The modal opens with nothing ticked; the yard ticks it on the day it actually goes out.
- **Once it has been loaded out on an earlier day and is still out** (not yet back), on later days
  it is shown **ticked and locked**, as before, because it is already on site.
- **Everything else in decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md
  stands**, including:
  - Off-load before the last day: unticked and locked, with the hover message;
  - it stays on site, with no "not offloaded" reason asked;
  - Off-load still shows on a day where held items are all that is out;
  - Off-load on the last day: tickable as normal;
  - the last day's offload closes the earlier days' records;
  - the yard's pre-existing button rules, and the *Holdover* pill.

**Interpretation, not the developer's words:**

- **"Gone out"** means: for that job line, an asset loadout row exists on an **earlier open
  schedule day of the job** with `loadoutAt` set, **not deferred**, and with a remaining
  not-offloaded quantity **greater than 0**.
- **The last day is included.** A held item never sent before can go out on the job's last day,
  and its Loadout row is tickable there. (This replaces the 2026-10-06 note's interpretation that
  the Loadout lock applies on every day, the last day included.)

## Why

From exchange 1: "the user can send it later as well" — "holdover items can be sent any day". A
lock from day 1 forced the item out on day 1. From the picked descriptions: once it has gone out
"it is on site", so later days lock it ticked; unlocked rows start unticked because "the yard ticks
it on the day it actually goes out".

## What it supersedes, and what stands

Against decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md:

| Rule there | Now |
| --- | --- |
| Loadout: held item selected and disabled | **Superseded.** Unticked and tickable until it first goes out; ticked and locked only after it has gone out on an earlier day and is still out |
| Interpretation: Loadout lock on every day, last day included | **Superseded.** No lock on any day, the last day included, until the item has gone out |
| Every day runs the normal flow; pre-existing button rules; Off-load exception on a held-only day | **Stand** |
| Off-load before the last day: unticked, locked, hover message; stays out, no reason asked | **Stand** |
| Off-load on the last day: tickable as normal | **Stands** |
| Last day's offload closes earlier days' records | **Stands** |
| *Holdover* pill and "Stays on site until …" / "Comes back today" line | **Stand** |

## What is built

Branch `feat/holdover-improvements` (tcg), commit `99d27ba17` (2026-10-07), not yet merged.

- **API:** `DasSubJobLoadoutHoldover.outOnEarlierDayResourceIds`
  (`apps/api/src/usecase/das-loadout/holdover-loadout.util.ts`), computed in `toHoldoverPayload`
  from `DasLoadoutRepository.findHoldoverJobDays`
  (`apps/api/src/service/das-loadout/das-loadout.repository.ts`), which now selects each day's
  loaded-out asset rows.
- **Web:** `isLoadoutLocked` in
  `apps/web/src/features/dylen-dashboard/utils/holdover-loadout-rules.ts` locks a held row only
  when its resource is in `outOnEarlierDayResourceIds`; read by
  `apps/web/src/features/dylen-dashboard/hooks/use-dylen-held-asset-selection.ts`. Type in
  `apps/web/src/features/das/middle-section/jobs/types/das-loadout.api.ts`.

## What this does NOT settle

- **Server-side Loadout lock.** Still not asked. dispatch/gaps.md → *Holdover Loadout lock — should
  the API refuse a Loadout that leaves a held item behind?* stays open. This ruling narrows what
  such a lock would cover: only a held item already out from an earlier day.
- **A held item that goes out mid-job and its other-job block.** Unchanged:
  decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md refuses it to
  other jobs from the job's first held day, whether or not it has gone out yet.
- Everything the 2026-10-06 note lists under *What this does NOT settle*.

## Effect on the vault

- **decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md:** `provenance_note:`
  added, pointing here and naming the superseded Loadout rule and what stands. Done. Its `status:`
  stays `reference`, since it is only partly superseded, following the same practice it used for
  its own predecessor. Body unchanged.
- **No other frontmatter edits.** No file becomes `verified` or `superseded`, and no
  `conflicts_with:` pair is adjudicated. This note is `reference`.
- **Register:** no entry closed or edited.
- **Not indexed.** Like the two earlier yard holdover notes, this note is not listed in INDEX.md or
  dispatch/INDEX.md (decisions/ has no INDEX.md). It is found by its `module/dispatch` tag.
