---
title: A DAS shift runs until its Estimated End and shows on every day it runs, greyed on the days after its own (Syed Haris, 2026-10-01) — decision
source: decision/Syed Haris — answering dispatch/gaps.md *Overnight DAS shifts*
decided: 2026-10-01
decided_by: >-
  Syed Haris (syed.haris, CodingCops), stated in a Claude Code session on 2026-10-01 while building
  branch `feat/schedule-datetime-holdover`. This is a CodingCops ruling, not a TCG client
  confirmation. The register entry names Lisette Anzaldo (TCG dispatch, DAS board) as the owner,
  and she has not been asked and has not confirmed it. That is why the status is `reference`: it
  binds the CodingCops build, and TCG can overrule it. The basis is the same as
  decisions/2026-09-30-schedule-shift-may-run-past-24-hours.md, the ruling this one follows from.
status: reference
conflicts_with: []
resolves:
  - "dispatch/gaps.md#overnight-das-shifts--may-a-shift-cross-midnight-and-what-does-the-board-show-when-it-does (CodingCops ruling, pending Lisette Anzaldo's ratification)"
related_decisions:
  - 2026-09-30-schedule-shift-may-run-past-24-hours.md
  - 2026-09-09-business-day-starts-at-midnight-local.md
  - 2026-09-04-cross-midnight-day-type-and-holiday-minimum.md
jira: []
tags: [module/dispatch, module/projects-jobs, kind/decision, daily-allocation, scheduling, yards]
---

# A DAS shift runs until its Estimated End and shows on every day it runs

## The exchange

Syed Haris, 2026-10-01, verbatim:

> "why does the DAS map clock ends it on the morning and run just days schedules? It should end on
> the estimated end time."

He was then given this recommendation (D1): "Should a shift still running on day X show on day
X's DAS board, yard board and map? — Yes, as a read-only 'Continuing · ends Oct 7 6:00 PM' card
on each day it runs. Its actions open the original day."

Syed Haris, reply to D1, verbatim:

> "you are right, just show it a bit shaded as in grey highlight on the other days"

## Decision

The open question was "may a DAS shift cross midnight, and what does the board show when it does?".
The answer is the **"may cross midnight, and the board must carry it into the next day"** reading,
extended to shifts that run for several days (allowed since 2026-09-30).

1. **The shift clock ends at the Estimated End.** The clock uses the stored end date and time. It
   does not rebuild the end from the row's date. So an 18:00 → 02:00 shift is running until 02:00
   the next morning, and a shift ending Oct 7 at 6:00 PM is running until then.
2. **A shift shows on every calendar day its window touches.** The window runs from Start / On Site
   to the Estimated End.
   - Start and On Site can only take the row's date today (question (a) of *Schedule times on a
     later day* is still open). So the first day is always the row's own date.
   - The ruling matters for the days **after** that date.
3. **On the days after its own row's date, the shift is shown greyed (shaded).** It is a continuing,
   read-only card.
   - "A bit shaded as in grey highlight" is his own addition to the recommendation.
   - "You are right" is read as accepting the rest of the recommendation as worded: the card is
     read-only, it says it is continuing and when it ends ("Continuing · ends Oct 7 6:00 PM"), and
     its actions open the original day.
   - That reading is this note's interpretation of "you are right". He did not repeat each part.

## Why

The ruling gives one reason, in the question itself: the clock ended the shift "on the morning",
while the shift actually ends at its Estimated End. Syed Haris gave no other reasoning, and this note
does not add any.

It also follows from the 2026-09-30 ruling. Once an Estimated End may fall any number of days later,
a board that builds both ends from the row's date shows every such shift as `Completed` while it is
being worked. It also drops the shift from the board on every day after the first.

The written record already leaned this way, though none of it ruled on the board display. The
register entry lists the sources:

- decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md (`verified`) adjudicates how a
  cross-midnight shift is *paid*.
- Brian Petros said *"a lot of the jobs go past midnight"* (admin/gaps.md → *Time display*,
  assets/gaps.md → *The fleet day*).

## What is built (branch `feat/schedule-datetime-holdover`, not merged)

**Built 2026-10-01, on the DAS only** (map, jobs board, side panels). The detail is in
dispatch/gaps.md → *Overnight DAS shifts* (build note of 2026-10-01). In short:

- A shift is live on every calendar day its window (Start or On Site → Estimated End) touches:
  `@tcg/shared` `shiftWindowTouchesDay`, and in the API `liveOnDayIntervalsFilter` /
  `shiftLiveOnDay` (`apps/api/src/service/das-allocations/allocation-window.util.ts`).
- **Map:** `DasMapAsset` carries `startAt` / `endAt` / `scheduleDate` / `continuing`; the clock
  (`apps/web/src/features/das/map-section/utils/shift-time.ts` `shiftBounds`) counts to the
  Estimated End on its own day, and continuing units are greyed.
- **Jobs board:** `GET /das/sub-jobs?includeContinuing=true` adds earlier days' sub-jobs still
  running into the date; the board renders them greyed and read-only
  (`continuing-job-list-item.tsx`), with a link to their own day.
- **Side panels:** bookings still running into the date count as bookings that date.

Not shipped until the branch merges — check the branch, not this note, for current behaviour.

**The yard board is NOT changed.** The recommendation named it, and the ruling did not exclude it.
But nothing in the yard dashboard (`apps/web/src/features/dylen-dashboard/`) or the loadout API
(`apps/api/src/usecase/das-loadout/`) carries a shift onto the days after its row's date. It still
lists a shift only on its row's date.

## What is weak about this attribution

- **The owner has not spoken.** Lisette Anzaldo owns the register entry and the DAS board, and
  should ratify this. Dylan Masterson should ratify the yard-board half, because the board is his.
- **Nobody at TCG has asked for a shift longer than 24 hours.** The same weakness is recorded in the
  2026-09-30 note. The multi-day half of this ruling inherits it.
- **The overnight half (one midnight) is much better supported** than the multi-day half. Overnight
  work is treated as ordinary in every source the register lists.

## What this does NOT settle

- **Rows inside a multi-day shift.** This is question (d) of dispatch/gaps.md → *Schedule times on a
  later day*.
  - A multi-day shift now appears greyed on dates that may also have their own rows and shifts. So
    day X can show the continuing card **and** day X's own shifts.
  - Whether those rows should be switched off, or a second crew on them is expected, is still open.
- **Ends shown as a time only** on tickets, notifications and ticket progress. This is question (e)
  of the same entry.
  - The "Continuing · ends Oct 7 6:00 PM" wording puts the date on the **DAS card** only.
  - Other surfaces are not covered.
- **Whether a continuing card counts on the later day.** The ruling does not say whether it counts
  toward that day's KPI counters, job counts, stage buckets or allocation completion. It also does
  not say whether the card's crane and crew show as working in that day's resource lists.
- **An end at exactly 00:00.** The ruling does not say whether such a shift "touches" the next day.
- **Pay.** The ruling covers the board display only. How a multi-day shift is paid belongs to
  payroll, and this note does not address it.
- **The yard board build** (above). It is decided here, at CodingCops-ruling level, but it is
  unbuilt and unratified by Dylan Masterson.

## Effect on the vault

- **No frontmatter edits.** No vault file specified the old same-day clock, so no file becomes
  `verified` or `superseded`. dispatch/daily-allocation-system.md (`unverified`, the DAS
  specification) has a `conflicts_with:` pair, and this note does not adjudicate it. This note is
  `reference`, not `verified`.
- **Register: not edited by this note's author.** The note was written under an instruction not to
  touch any `gaps.md`. Another agent in the same session is updating dispatch/gaps.md → *Overnight
  DAS shifts* to link this note. Until that lands, the entry still reads `open`, with no pointer
  here.
