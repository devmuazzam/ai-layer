---
title: A held asset is refused by every other job for the whole planned hold, before its day-1 loadout too; for a held asset this overrides "Reassign anyway?" (Fouzan Shakil, 2026-10-06) — decision
source: decision/Fouzan Shakil — a contradiction found in PR review of tcg branch `feat/yard-holdover-loadout`
decided: 2026-10-06
decided_by: >-
  Fouzan Shakil (fouzan.shakil, CodingCops developer), in a Claude Code session on 2026-10-06, by
  picking one of two options. A PR review of tcg branch `feat/yard-holdover-loadout` (not merged)
  had found the contradiction. The session wrote the question and the option labels and
  descriptions; the ruling is the pick. This is a CodingCops ruling, not a TCG client confirmation.
  Lisette Anzaldo (TCG dispatch) owns the related register entries, and Dylan Masterson (yard) is
  named on the earlier yard notes. Neither was asked, and neither has confirmed it. That is why the
  status is `reference`: it binds the CodingCops build, and TCG can overrule it. Same basis as
  decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md.
status: reference
conflicts_with: []
resolves: []
supersedes_partial:
  - "2026-09-15-fix-15-sep-das-and-quotations-as-built.md (item 4, for a held asset only: a held asset's allocation that is not yet loaded out is refused, not taken over after \"Reassign anyway?\". Item 4 stands for every asset that is not held)"
  - "2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md (rule 6, widened: the block starts on the held job's first held day, not at the day-1 loadout. The rest of rule 6 stands)"
related_decisions:
  - 2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md
  - 2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md
  - 2026-09-15-fix-15-sep-das-and-quotations-as-built.md
jira: []
tags: [module/dispatch, module/assets, kind/decision, daily-allocation, scheduling]
---

# A held asset is refused by every other job for the whole planned hold, even before it is loaded out

## The exchange

The build refuses a held asset to every other job for the whole planned hold. Two written rulings
would let another job take it before it is loaded out:

- **Rule 6** of decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md. The
  option picked there reads *"From its day-1 loadout until the last-day offload, any other job is
  refused, whatever the hours."*
- **Item 4** of decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md. An allocation not yet
  marked available or loaded out (reason `ALLOCATED`) is taken over once the dispatcher confirms
  "Reassign anyway?".

Question shown to Fouzan Shakil, 2026-10-06, verbatim:

> "A held crane, before it has been loaded out on day 1: the branch already refuses any other job
> for the whole planned hold. Your pick said "from its day-1 loadout", and fix-15-sep item 4 says an
> allocation that isn't loaded out yet can be taken over with "Reassign anyway?". Which should
> hold?"

One option was picked. Labels and descriptions are verbatim as shown.

| Picked | Rejected |
| --- | --- |
| **"Block whole hold (Recommended)"**: *"Keep as built. For a held asset this overrides item 4: to move it, release it in Make Holdover first. Avoids a crane being promised to two sites. No code change; I record it in the vault."* | **"Block from loadout only"**: *"Match your pick's words. Before day-1 loadout the normal rules apply, including Reassign anyway?, which deletes the held job's allocation on that day. Another job can book the crane on a middle day before it goes out."* |

## Decision

- **A held asset is refused by every other job for the whole planned hold.** That runs from the held
  job's first held day to its last, whatever the hours, **even before it is loaded out**.
- **For a held asset this overrides item 4** of
  decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md. Its allocation is not taken over
  with "Reassign anyway?". To move it, dispatch first releases it in Make Holdover on the held job.
  Item 4 is unchanged for every asset that is not held.
- **It widens rule 6** of decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md.
  That rule started the block at "its day-1 loadout". It now starts on the held job's first held day.
- **What frees the asset is kept as built.** The last held day's offload frees that day. Releasing
  the hold in Make Holdover frees the later days.

**Interpretation, not the pick's words.**

- "A held crane" is read as **any held asset**, as in the earlier yard notes. *Held* keeps their
  meaning: the Make Holdover tick (`JobResource.isHoldover`) or a day's allocation copied with *Hold
  over* (`JobResourceAllocation.isHoldover`).
- "The whole planned hold" is read as the span the build uses: the first to the last day on which
  the other job holds that asset (`pickHeldOverConflict`).

## Why

From the option description picked: it *"Avoids a crane being promised to two sites."*

The rejected option names what it would have allowed: "Reassign anyway?" *"deletes the held job's
allocation on that day"*, and *"Another job can book the crane on a middle day before it goes out."*

## Still in tension, not settled

Two `unverified` specs say a clash **warns** rather than blocks. This ruling does not adjudicate
either, and TCG has not confirmed it.

- **dispatch/daily-allocation-system.md:47-48** (`unverified`, 9.6 KB, updated 2026-04-30): *"unavailable
  ones are greyed out but still drag-gable with a system warning"*, and *"the same asset can be
  assigned to two non-overlapping jobs on the same day"*. This file is itself in an open conflict
  with projects-jobs/job-project-das.md (dispatch/daily-allocation-INDEX.md).
- **projects-jobs/project-module/03-create-manage-job-schedule.md:43** (`unverified`, 2.2 KB, updated
  2026-04-30): *"If an asset is already assigned to another job during the same time on the same
  date, the system shows a warning"*.

## What this does NOT settle

- **Warn or block**, against the two specs above. That is for TCG (Lisette Anzaldo).
- **A held employee.** The build does not block a held employee on other jobs (dispatch/gaps.md →
  *Which items of a holdover job go back to the yard between working days?*, build note, *Not
  built*). Not asked.
- **How the DAS shows a held asset before it goes out.** Whether it reads as *on site* before day-1
  loadout is still open (decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md
  → *What this does NOT settle*). This ruling is about refusing other jobs, not about what the board
  shows.
- **TCG-186 (a), (b) and (d)–(h)** (dispatch/gaps.md → *Allocating by shift time (TCG-186)*). Not
  touched.

## What is built

**No code change.** The pick keeps the build. tcg branch `feat/yard-holdover-loadout`, not merged:

- `apps/api/src/service/das-allocations/held-over-conflict.util.ts` → `pickHeldOverConflict`. A day
  between the other job's first and last held day is blocked whatever the hours, loaded out or not.
  On the last held day, once that day's rows have come back, the asset is free.
- Reason `HELD_ON_SITE` (`apps/api/src/service/das-allocations/das-allocations.repository.ts`).
  `apps/api/src/usecase/das-allocations/das-allocations.service.ts` refuses it with 409, like the
  yard lock of item 3. It is never offered as "Reassign anyway?". The message
  (`formatHeldOverMessage`) ends *"Release it in Make Holdover on that job first."*
- Spec: `apps/api/src/service/das-allocations/das-allocations.repository.spec.ts` → *held over on
  another job (decision 2026-10-06)*.

## Effect on the vault

- **decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md:** `provenance_note:`
  now says rule 6 is widened here. Done. `status:` stays `reference`. Body unchanged.
- **decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md:** `provenance_note:` added, and a
  dated pointer under item 4. Done. `status:` stays `reference`.
- **decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md:** a dated pointer
  under its rule table. Done.
- **No other frontmatter edits.** No file becomes `verified` or `superseded`, and no
  `conflicts_with:` pair is adjudicated. The two specs above are untouched.
- **Register:** dated notes in dispatch/gaps.md, under the DAS bullet (*"Built default, wider than
  the ruling"*) of *Which items of a holdover job go back to the yard between working days?*, and
  under (c) of *Allocating by shift time (TCG-186)*. Done. No `Status:` line was changed.
- **Not indexed.** Like the other 2026-10-06 decisions, this note is not listed in INDEX.md or
  dispatch/INDEX.md. It is found by its `module/dispatch` tag.
