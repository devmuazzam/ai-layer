---
title: Job Schedule weekend toggles follow the date range — Include Saturdays / Include Sundays switch on when the range contains that day, on saved schedules too
source: decision/CodingCops (Ehtesham Anwar), relayed by Syed Haris in the 2026-09-12 Claude Code session; recorded 2026-09-12
decided: 2026-09-12
decided_by: >-
  Ehtesham Anwar (CodingCops). Not stated first-hand to this record: Syed Haris (CodingCops
  developer, author of PR #537) said in the 2026-09-12 Claude Code session, verbatim, "for
  weekend toggle it was decided by Ehthesham". No recording, no Jira ticket, no Confluence page
  and no written message carries the decision itself. Neither person is a TCG decision-maker;
  the client (Lisette Anzaldo, Ryan Adams, Melissa McNutt) has not confirmed it. Recorded as
  status: reference — a CodingCops-stated rule, shipped, not adjudicated by TCG.
status: reference
conflicts_with: []
resolves: [projects-jobs/gaps.md#branch-fixuat4-schedule-copy-allocation--job-schedule-weekend-toggles-follow-the-date-range-on-saved-schedules-too]
tags: [module/projects-jobs, module/dispatch, kind/decision, scheduling]
---

## Decision

On the Job Schedule tab (`apps/web/src/features/projects/jobs/job-details/schedule/`), the
**Include Saturdays** and **Include Sundays** toggles are **derived from the date range**, not
defaulted off:

- **(a) Picking a range.** When a start and end date are picked, *Include Saturdays* switches
  **on** if the range contains a Saturday, *Include Sundays* switches **on** if it contains a
  Sunday, both if both. A Monday–Friday range touches neither. The derivation is **enable-only**:
  picking a date never switches a toggle **off**. Clearing either date resets **both** toggles off.
- **(b) Reopening a saved schedule.** A saved schedule re-derives the toggles from its saved range
  on load and **adds the missing Saturday/Sunday rows, unchecked** — nothing is regenerated, and
  the additions are **unsaved until Save Schedule**.

Shipped in PR #537 (`fix/uat4-schedule-copy-allocation`, merged 2026-09-11; `aidlc/processed.log`
Path C row, line 92), commits:

- `3879e7727` — *schedule weekend toggles follow the date range; clearable dates reset them* —
  `resolveWeekendToggles` in `utils/schedule-date-range.ts` now uses `weekendDaysInRange`
  (contains-a-weekend-day) instead of the old `weekendOnlyRange` (all-weekend) rule.
- `260f679cc` — *saved schedules open with the weekend rows their range implies* —
  `hooks/use-schedule.ts` applies the same derivation to a saved schedule on load, as
  weekend-only additions.
- `e8fb6bef1` — *weekend rows added on load are unchecked; update the lifecycle E2E to the new
  reopen state* — `utils/schedule-date-utils.ts`; `qa-automation/e2e/specs/projects/1-lifecycle.spec.ts`
  now asserts the reopen state above instead of weekday-only.

## Why

The only reasoning on record is the UAT-4 remark that produced the change: the old rule
(toggles on only when the range was *entirely* weekend) lived in a code comment and nowhere in
the vault, and a dispatcher picking a range that spans a weekend expected the weekend days to be
offered. The nearest written precedent, and the reason this is recorded as a rule rather than a
guess, is Ehtesham Anwar's own framing on the 2026-04-07 dispatch/scheduling Figma demo
(`meetings/transcripts/2026-04-07-dispatch-scheduling-figma-demo.md:118`, 23:26): *"a quick
selection up top to **exclude** all of the weekends"* — weekends present unless excluded — and
the FCC legacy job's `Work Weekends` flag being **on by default**
(`dispatch/fcc-nexgen-dispatch-guide.md:149-152`). Both are consistent with (a); neither is a TCG
ruling, and no TCG voice has spoken to (b) at all.

Both in-product schedule specs — `projects-jobs/project-module/03-create-manage-job-schedule.md:24,
:35` and `projects-jobs/scheduling/ready-to-schedule.md:147` (both `unverified`) — say only that the
user *"can choose to include or exclude Saturdays and Sundays"*: a choice, no default, no reopen
rule. This note is the first written statement of either.

## Why this is `reference` and not `verified`

The rule was decided by **CodingCops, not by TCG**, and it reached this record second-hand: one
developer's report that his lead decided it, with nothing in writing behind it. That is enough to
stop a merge from silently turning a UAT remark into the default — which is what the gaps entry was
recorded to prevent — and not enough to call it adjudicated. Treat it as the answer to build
against; upgrade it to `verified` when Lisette Anzaldo, Ryan Adams or Melissa McNutt confirms it
(the one-line question: *"When a schedule's date range contains a Saturday or Sunday, should
Include Saturdays / Include Sundays default on, and should a saved schedule reopen re-derived from
its range rather than as saved?"*).

The data-loss shape the gaps entry flagged still stands as a **known consequence** of (b), not an
open question: a job saved with a weekend toggle deliberately off now reopens with that toggle on
and the weekend rows showing, unchecked, until Save. A dispatcher may report that as a bug; the
answer is this note until TCG says otherwise.

## What this does not settle

- **(c) The API conversion path.** `createJobFromQuotationInTx`
  (`apps/api/src/usecase/projects/projects.service.ts` ~433-437) still creates a converted job's
  schedule with `includeSaturdays: false`, `includeSundays: false` and **weekday-only** intervals.
  So a converted job's **saved** state and the web's **on-open** state disagree until Save
  Schedule. Syed Haris did not report (c) as decided, and it was not asked of Ehtesham. It stays
  **open**, as its own residual line on the gaps entry, owner Ehtesham Anwar to confirm whether
  conversion should also create weekend intervals (and, if so, whether that is his call or the
  client's).
- **The per-day checkbox default on conversion** —
  `projects-jobs/gaps.md#converted-quotation-schedule-days--checked-by-default-and-what-that-puts-on-the-das-board`
  — is the same "what does a converted job's schedule open with" axis and is **not** settled here;
  (c) above is its weekend twin and should be put to the client in the same breath.
- **TCG's view.** None yet.

## Effect on the vault

- No vault file body is a winner or loser: nothing written stated a default or a reopen rule, so
  there is nothing to mark `verified` or `superseded`. `03-create-manage-job-schedule.md` and
  `ready-to-schedule.md` remain `unverified` and are not contradicted — they said "a choice", and
  this note supplies the default for that choice.
- `projects-jobs/gaps.md` → *Branch fix/uat4-schedule-copy-allocation — Job Schedule weekend
  toggles follow the date range, on saved schedules too*: **Status flipped** to *resolved for (a)
  and (b) — see this note; (c) open* — **done** in the same pass. Its *Asked* line now cites the
  #537 row at `aidlc/processed.log` line 92 (corrected from 91 in the same pass).
- `projects-jobs/gaps.md` → *Converted-quotation schedule days…*: Status untouched; a one-line
  *see also* added pointing here — **done**.
- `decisions/2026-08-28-job-schedule-weekend-empty-state.md` (assignee-level) is unaffected: it
  settles the empty-state copy when the toggles exclude every day, which (a)/(b) can still produce
  by a dispatcher switching both off after the derivation.
