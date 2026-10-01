---
title: A job schedule shift may run past 24 hours — no restriction on the Estimated End's date (Syed Haris, 2026-09-30) — decision
source: decision/Syed Haris — answering dispatch/gaps.md *Schedule times on a later day*, question (b)
decided: 2026-09-30
decided_by: >-
  Syed Haris (syed.haris, CodingCops), stated in a Claude Code session on 2026-09-30 while
  building branch `feat/schedule-datetime-holdover`. This is a CodingCops ruling, not a TCG client
  confirmation. The register entry names Lisette Anzaldo (TCG dispatch) as the owner, and she has
  not been asked and has not confirmed it. That is why the status is `reference`: it binds the
  CodingCops build, and TCG can overrule it. The basis is the same as
  decisions/2026-09-25-password-reset-accepts-a-pending-invitation.md and
  decisions/2026-09-09-business-day-starts-at-midnight-local.md.
status: reference
conflicts_with: []
resolves:
  - "dispatch/gaps.md#schedule-times-on-a-later-day--start-and-on-site-shifts-of-24-hours-or-more-and-the-minute-step (question (b) only; (a) and (c) stay open)"
jira: []
tags: [module/projects-jobs, module/dispatch, kind/decision, scheduling, daily-allocation, requirements]
---

# A job schedule shift may run past 24 hours

## Decision

Verbatim, Syed Haris, 2026-09-30:

> "a shift (job>schedule tab) can be greater than 24 hours. So there should be no restrictions on
> the calendar date picker for the estimated end time"

The answer to question (b) of the register entry ("Does any job run a single shift of 24 hours or
more?") is **yes. A shift on the job Schedule tab may run longer than 24 hours.** The date picker
for the **Estimated End** puts no limit on how many days later it can go.

**How the build reads "no restrictions".** It removes the **upper** limit. It does not remove the
ordering. The end cannot go before the row's date, and the end (on its day) must still come after
On Site. The ruling's words do not say this. It is how the build reads them: an end before its
start is a data error, not a long shift.

## Why

The ruling itself gives one reason: a shift can be longer than 24 hours. Syed Haris gave no other
reasoning, and this note does not add any.

The limit it removes was never a product decision. The register records "at most 24 hours" as a
**built default**. It came from deriving each time's day from the `"HH:mm"` strings, where an end
at or before On Site is read as the next day. Nothing more than 24 hours can be expressed that way.
No vault file specifies the limit.

## What the build does (branch `feat/schedule-datetime-holdover`, not merged)

Checked against the working tree on 2026-09-30:

- **Storage.** Two new nullable `DATE` columns, `job_schedule_intervals.estimated_end_date` and
  `second_shift_estimated_end_date` (Prisma `estimatedEndDate` / `secondShiftEstimatedEndDate`).
  They are added by migration `20260930120000_schedule_estimated_end_date`, which is still
  untracked on the branch.
- **Picker.** The Estimated End field accepts any day from the row's date on (`allowLaterDays`, no
  `maxDay`). Its hint reads *"The end can be on the row's date or any later day."* Start and On
  Site still accept only the row's date.
- **Validation.** `@tcg/shared` `validateShiftTimes` no longer returns `SPAN_OVER_24H`. The only
  check is `END_NOT_AFTER_ON_SITE`: the end, on its day, must be after On Site, and its day must
  not be before the shift's day.
- **Older rows.** A row saved before this change has no stored end date. It keeps the derived rule
  (an end at or before On Site means the next day), so it stays capped at 24 hours. No backfill is
  needed.
- **Readers updated on the branch to use the stored date.** `shift-hours.util.ts` (working hours
  in assignment notifications), the shift-end instant in `das-loadout-schedule-lock.util.ts` (which
  the payroll week overlay uses to mark an unstarted ticket Not Worked), the allocation window
  (`allocation-window.util.ts`), and the DAS, loadout, sub-job and payroll repositories that feed
  them.

## What is weak about this attribution

- **Nobody at TCG has asked for a single shift longer than 24 hours.** The only client evidence is
  Ryan Adams, 2026-04-07 Figma demo
  (`meetings/transcripts/2026-04-07-dispatch-scheduling-figma-demo.md`, 24:04, `status:
  reference`): *"Sometimes we have a 24 hour shifts too"*. Read in context, from 24:21 on, he
  describes **round-the-clock coverage by two crews of 12 hours each**, with the crews swapping
  over. That is two shifts on one date, which ehtesham.anwar mapped to the **second shift**. It is
  not one shift longer than 24 hours. So this ruling **goes further than the client evidence**. It
  rests on CodingCops authority alone.
- **A client statement points the other way** (found 2026-10-01). Kyle Harlow, 2026-06-18
  dispatch/permits meeting (`meetings/transcripts/2026-06-18-dispatch-permits.md` 1:35:04,
  `reference`): *"We're putting a limit on allowed work hours and not ever going over 24 hours"*;
  and the verified payroll flag list blocks approval of any shift over 24 hours. Raised in
  dispatch/gaps.md → *Schedule times on a later day* (f) and payroll/gaps.md → *A shift longer
  than 24 hours — how is it paid?*
- **The owner has not spoken.** Lisette Anzaldo (TCG dispatch) owns the register entry and should
  ratify this. Where the answer touches pay, the payroll owner (Corrina Bustos) should too.

## What this does NOT settle

- **Question (a)**: whether **Start** or **On Site** can fall on a later day than the row's date.
  It stays open. The ruling covers the Estimated End only, and Start and On Site still take only
  the row's date.
- **Question (c)**: the minute step. It stays open.
- **A maximum length.** The ruling sets none and the build sets none. Whether there should be a
  sanity limit (for example, against a mistyped end several weeks out) has not been asked.
- **The DAS map shift clock** (dispatch/gaps.md → *Overnight DAS shifts*, still open).
  `apps/web/src/features/das/map-section/utils/shift-time.ts` is not changed on the branch. It still
  builds both ends of a shift from the same `date` and ignores the stored end date, so it shows
  every overnight shift, and every shift longer than 24 hours, as ended that morning.
- **How a shift longer than 24 hours is paid.** The payroll week overlay now reads the stored end
  date to decide when an unstarted ticket goes Not Worked, but pay treatment (day type, overtime,
  rest) belongs to payroll and this ruling does not address it. `decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md` covers a shift
  that crosses one midnight. This note does not claim it covers one that runs for several days.
- **Other readers of schedule times** that the branch did not change were not audited for this
  note.

## Effect on the vault

- **No frontmatter edits.** No vault file specified the 24-hour limit, so no file becomes
  `verified` or `superseded`. This note is `reference`, not `verified`, and it does not adjudicate a
  `conflicts_with:` pair.
- **Register updated in the same change:** dispatch/gaps.md → *Schedule times on a later day* marks
  (b) answered and links this note, and the 2026-09-29 build note under *Overnight DAS shifts* was
  revised. The entry stays **open** for (a), (c) and the two questions the ruling raised: rows
  inside a multi-day shift, and ends shown as a time only.
