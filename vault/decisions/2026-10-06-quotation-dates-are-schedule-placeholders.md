---
title: A converted quotation's dates only seed the job Schedule tab as placeholder days; the Schedule tab's range is what the DAS and Yard Operations use (Fouzan Shakil, 2026-10-06) — decision
source: decision/Fouzan Shakil — a bug report on the job Schedule tab of a converted quotation
decided: 2026-10-06
decided_by: >-
  Fouzan Shakil (fouzan.shakil, CodingCops), stated in a Claude Code session on 2026-10-06 while
  working on tcg branch `feat/yard-holdover-loadout`. They filed a bug report, picked one
  option for one question, and then gave the ruling in their own words. The option labels and
  descriptions were written by the session. The ruling is the pick plus their follow-up message.
  This is a CodingCops ruling, not a TCG client confirmation. Lisette Anzaldo (TCG dispatch) owns
  the related register entries and should confirm it. She has not been asked and has not
  confirmed it. That is why the status is `reference`: it binds the CodingCops build, and TCG can
  overrule it. The basis is the same as
  decisions/2026-09-30-schedule-shift-may-run-past-24-hours.md and
  decisions/2026-10-06-cranes-550-ton-and-up-pre-ticked-for-holdover.md (the latter is on overlay
  branch `feat/yard-holdover-loadout`, not on this branch).
status: reference
conflicts_with: []
resolves: []
related_decisions:
  - 2026-09-12-job-schedule-weekend-toggles-follow-the-date-range.md
  - 2026-09-08-artifact-due-date-seeded-from-first-job-day.md
jira: []
tags: [module/projects-jobs, module/quotations, module/dispatch, kind/decision, scheduling, daily-allocation, yards]
---

# A quotation's dates are placeholders on the job Schedule tab; the Schedule tab's days are the real ones

## The exchange

The bug report from Fouzan Shakil, 2026-10-06, verbatim (spelling as written):

> "If the user has selected quotation start date and end dates and times when creating a quotaiton.
> Then converting it to a project > job > schedule. When the dates on the schedule page are changed
> (fir instance entirely) sometimes the days below are not visible and sometimes the days are
> visible but when setting a time a saving a schedule the days then vanish completely."

The session then asked one question, and they picked one option. The label and description are
verbatim as shown.

| Question | Picked | Rejected |
| --- | --- | --- |
| "When Start is moved past End, what should the schedule do?" | **"Move End to keep the length"**: *"End shifts so the range keeps its number of days (a 5-day job moved to Oct 26 runs Oct 26–30). Rows show immediately; you adjust End if needed."* | "Set End to Start"; "Keep as is, explain it" |

Their next message, verbatim (spelling as written). This is the ruling:

> "the problem is something else. While a quotation craetion for instance the dates were 1-5
> september, but on the schedule page if i change that from 10-15th either the individual days dont
> show up below, which should be shown as that initial day is just placeholder for that quotation
> schedule page and any changes in schedule page are the ones which should actually be used for the
> DAS and yard operations"

## Decision

**The ruling, from their words and the pick:**

- When a quotation is converted, its start and end dates **only seed** the job's **Schedule** tab.
  The days they create are **placeholder days**.
- The **Schedule tab's** range and days are the ones the **DAS** and **Yard Operations** use. Any
  change made on the Schedule tab replaces what the quotation seeded.
- When the dates are changed on the Schedule tab, the new days must show in the list below.
- If Start is moved past End, the **whole range moves and keeps its length**. A 5-day range moved
  to start Oct 26 runs Oct 26–30. The rows show immediately, and the user can then adjust End.

**Interpretation, not their words.**

- **Days with no DAS work (no allocations, sub-job not past Open) are dropped without the "Remove
  Schedule Dates?" prompt** when the range changes. The ruling calls the seeded days "just
  placeholder", so asking before replacing them only got in the way.
- **Days with DAS work still prompt.** That means a sub-job with allocations, or a sub-job past
  Open. Dropping one deletes its sub-job, and allocations may be lost with it. The prompt's own
  text already says so (`buildDropDescription`,
  `apps/web/src/features/projects/jobs/job-details/schedule/utils/schedule-validation.ts`).
- **Why "no DAS work" and not "no sub-job".** Conversion seeds every day **active**.
  `ensureSubJobsForDate` (`apps/api/src/usecase/jobs/jobs.service.ts:1444`) creates a sub-job for
  every active interval on a date that lacks one, and `DasService.getSummary` / `getSubJobs`
  (`apps/api/src/usecase/das/das.service.ts:282`, `:318`) call it on every board fetch. So simply
  viewing the DAS board on a placeholder day gives it an empty Open sub-job. Keying the prompt on
  "has a sub-job" would have asked again for every placeholder day anyone had looked at. An empty
  Open sub-job is therefore treated as no work.
- **"Keeps its length"** means the same number of calendar days from Start to End. A Start at or
  before End leaves End alone. So does a range with no End yet.

## Why

They gave the reason in the ruling itself: the quotation's day is *"just placeholder for that
quotation schedule page"*, and *"any changes in schedule page are the ones which should actually be
used for the DAS and yard operations."* For the range move, the picked option's description says
*"Rows show immediately; you adjust End if needed."*

The record has related material. It points the same way, but none of it is TCG ruling on this
screen:

- **"Quote timing is tentative."** erp-review-log.md:204-206 (`unverified`, the client feedback
  register) under *Dispatch and scheduling*: *"dispatch uses final job timing, not quote timing —
  quote timing is tentative, job timing is the operational source of truth"*. Carried into
  projects-jobs/quote-to-job-lifecycle.md:126-128 (`unverified`), which notes that the log is an
  unverified AI summary of one meeting the client marked "for reference only".
- **The quotation's schedule is called tentative.** quotations/quotation-flow-process.md:30
  (`unverified`): *"Step 7: Enter general quotation details (description, tentative schedule,
  customer contact, notes, etc.)."*
- **The only written schedule spec is manual.** projects-jobs/project-module/03-create-manage-job-schedule.md
  (`unverified`, SCRUM-234) has the dispatcher click **Create Schedule** and pick the start and end
  dates (:22-23). It ends *"Scheduled job becomes available in dispatch (DAS)"* (:30) and *"Each
  scheduled date appears as a separate job card in DAS on that specific date"* (:42). It does not
  mention a quotation-seeded schedule at all.
- **Conversion does seed the schedule, in code.** `createJobFromQuotationInTx`
  (`apps/api/src/usecase/projects/projects.service.ts:467-510`) creates the job schedule and one
  interval per day of the quotation's range, weekends included, every one `isActive: true`. Its
  comment says *"Selected by default: the quotation's date range says these are the job's working
  days"*. That is the seed this ruling calls a placeholder. Whether conversion should create a
  schedule at all is still open (see below).

## Background — what the local data showed

Read-only queries against the local dev database, 2026-10-06. Jobs created on 2026-10-01 (UTC)
whose dates were then changed on the Schedule tab:

- **JOB-00045 (Oct 22–24), JOB-00049 (Dec 8–10), JOB-00051 (Jan 1–3 2027):** every schedule day
  was saved **inactive** (unticked).
  - JOB-00049's days were first saved with **no times**. That is only possible for unticked days,
    because a ticked day requires times. They were given times later.
  - JOB-00051 was saved with times, and with every day unticked, in one save.
  - JOB-00045 had one save with **zero days**.
- View mode lists only ticked days. So on all three jobs the days "vanished", which is the second
  half of the bug report.
- **JOB-00046, JOB-00047, JOB-00050** moved their dates and saved ticked days correctly.
- The data does **not** show what unticked the days on JOB-00045/49/51. It could have been the
  header select-all, "Clear selection" or the row boxes. That question is in the register entry
  below.

The first half of the bug report was reproduced by running the real `useSchedule` hook in a
react-test-renderer harness, on the code before this branch. Picking a Start past the End and
confirming the prompt emptied the day list until End was picked again.

## Relevant open register entries

This note does not close any entry.

- projects-jobs/gaps.md → *Schedule tab — what unticks a day, and should a day with times always be
  worked?* — opened with this note. It holds the branch's other built default (a time ticks the
  day) and the questions the data could not answer.
- projects-jobs/gaps.md → *Converted-quotation schedule days — checked by default, and what that
  puts on the DAS board*.
  - This ruling bears on its Ask 3 (should conversion create the schedule at all). It treats the
    seeded days as placeholders the Schedule tab replaces.
  - It does **not** answer Ask 1 (checked or unchecked on arrival) or Ask 2 (whether checked means
    on the DAS board).
- projects-jobs/gaps.md → *Schedule day deactivate orphans SubJob / allocations*. This is the same
  sub-job question for an unticked day rather than a dropped one.

## What is built

**Built on tcg branch `feat/yard-holdover-loadout`, not merged** (committed on
2026-10-06). All of it is in `apps/web/src/features/projects/jobs/job-details/schedule/`:

- `utils/schedule-range-shift.ts` → `endForStartPick(newStart, oldStart, oldEnd)`. A Start past End
  returns an End that keeps the old span. Otherwise it returns the old End. Covered by
  `utils/schedule-range-shift.test.mjs`.
- `hooks/use-schedule.ts` → `setStartDate` moves End with `endForStartPick`. The weekend toggles
  are derived over the moved range, as decisions/2026-09-12-job-schedule-weekend-toggles-follow-the-date-range.md
  (`reference`) requires.
- `hooks/use-range-change-guard.ts` uses the same End when predicting dropped days. It prompts only
  when a dropped day `hasDasWork`.
- `utils/schedule-range-shift.ts` → `hasDasWork(subJob)`. It is true for a sub-job whose `dasStage`
  is past `OPEN`, or one with at least one resource allocation. If the API sends no allocation
  count (an older API), the day is treated as having work, so it still asks. The count comes from
  `subJob._count.resourceAllocations` on the job detail response
  (`apps/api/src/service/jobs/jobs.repository.ts`).
- `hooks/use-schedule.ts` → `patchShift`: giving an unticked, editable day a time ticks it. This is
  the register entry's built default, **not** part of this ruling.

## What this does NOT settle

- **Whether conversion should create the schedule at all**, and whether the seeded days should
  arrive ticked (that is, on the DAS board). Both are open in *Converted-quotation schedule days…*.
- **What counts as DAS work.** The build counts allocations and the sub-job's stage only. A
  sub-job can also carry `jobTickets` and a `loadout` (`SubJob` in `apps/api/prisma/schema.prisma`).
  The stage check stands in for those, but nobody verified that a sub-job still at Open can never
  have them.
- **Other values seeded from the quotation's dates.** decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md
  (`reference`) seeds a permit or plan artifact's `dueDate` from the job's first scheduled day at
  conversion, which is now a placeholder day. Whether that seed should follow a Schedule tab change
  is not decided. Whether the build re-seeds it was not checked.
- **Moving End before Start.** The pick covers a Start moved past End only.
- **The quotation's own times.** The bug report says the quotation had dates *and times*. This
  ruling is about the days. How the quotation's times reach the Schedule tab is not settled here.

## Effect on the vault

- **No frontmatter edits.** No vault file specified what happens to a converted quotation's days on
  the Schedule tab. So no file becomes `verified` or `superseded`, and no `conflicts_with:` pair is
  adjudicated. This note is `reference`, not `verified`.
- **Register:** a new entry was appended to projects-jobs/gaps.md → *Schedule tab — what unticks a
  day, and should a day with times always be worked?*, status open. No existing entry's `Status:`
  line was changed.
- **Not indexed.** Like the 2026-10-01 and 2026-10-05 decisions, this note is not listed in
  INDEX.md or projects-jobs/INDEX.md. It is found by its `module/projects-jobs` tag.
