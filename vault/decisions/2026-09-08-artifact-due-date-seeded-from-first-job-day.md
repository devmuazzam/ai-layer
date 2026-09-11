---
title: Artifact due date is seeded from the job's first scheduled day and is then freely editable — decision
source: decision/Syed Haris
decided: 2026-09-08
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing the
  `feat/permits-plans-project-artifacts` work; stated directly in a working session on
  2026-09-08 while reviewing the artifact detail screen. He is not the client-side product
  owner, and the gaps entry this answers nominated Lisette Anzaldo (dispatch/permits) with
  Ryan Adams (scheduling gate) as its owners. Recorded `status: reference` rather than
  `verified` for that reason — binding on implementation now, open to being overruled by
  TCG. Same basis as `2026-09-01-subsistence-not-a-craft-attribute.md`.
status: reference
conflicts_with: []
resolves: projects-jobs/gaps.md#artifact-due-date--the-jobs-first-scheduled-day-with-no-permit-lead-time
related_decisions:
  - 2026-09-11-quote-to-project-permits-plans-flow.md
jira: []
tags: [module/projects-jobs, module/dispatch, kind/decision, permits, lift-plans, scheduling]
---

# Artifact due date: seeded from the first scheduled job day, editable to anything

Settles the semantics of `dueDate` on a permit or plan artifact — and **only** that field.

## Decision

Syed Haris, verbatim:

> The due date will be initially set as the first scheduled job, but is editable to any
> other date of course.

Two clauses, and the second is what makes the first safe:

1. **Seed.** At quotation → project/job conversion the artifact's `dueDate` is set from the
   job's first scheduled day. No lead-time arithmetic is applied at seeding.
2. **Editable.** The value is a **user-owned field thereafter**, freely settable to any date
   on the artifact detail screen. It is a default, not a derived or locked value.

## Why

The gap was raised because the seeding rule looked like it contradicted the written record:
[`../projects-jobs/scheduling/job-schedule-master-workbook.md`](../projects-jobs/scheduling/job-schedule-master-workbook.md)
(`status: unverified`) computes a **`Latest Permit Submission`** *backwards* from the job
date — its shipped worked example pairs job date `2026-08-16` with `2026-08-12 17:00` (:34,
:37-41) — and
[`../projects-jobs/scheduling/dispatch-scheduling-path.md`](../projects-jobs/scheduling/dispatch-scheduling-path.md):24-26
makes the full lead time a Red/Green gate.

The contradiction dissolves once the two are recognised as **two different fields**, not two
answers to one question:

- `Latest Permit Submission` is a **computed dispatch deadline** — when the application must
  be filed for the crane to roll on time. It is an input to the Green/Yellow/Red scheduling
  test.
- The artifact's `dueDate` is a **plain editable date on a work item**, defaulted to
  something sensible so the field is never blank. Whoever owns the permit moves it.

An editable field cannot contradict a computed one, because nothing forces the two to agree.
That is why the answer is a seed plus editability rather than a formula: the formula question
is a *separate* question, and it stays open below.

The seed choice itself is corroborated as the right default by the record —
[`../projects-jobs/quote-to-job-lifecycle.md`](../projects-jobs/quote-to-job-lifecycle.md):126-130
(`unverified`): *"the job's date is what the permit clock is calculated against"*. The job
date is the anchor everything else is measured from, so anchoring the default on it is
consistent with the record even though no vault file ever named a `dueDate` field.

For **plans**, this also aligns with the only written statement there was: a plan due date is
a **collected** field, not a derived one —
[`../quotations/sales-operating-system/05-forms-and-records-matrix.md`](../quotations/sales-operating-system/05-forms-and-records-matrix.md):100
(`unverified`) lists *"required plan due date"* in the Lift Plan Request minimum data set and
never says how the value is arrived at. "Collected" and "editable" are the same claim.

## How the build maps to it

**The implementing function is `resolveFirstJobScheduledDate`**, in
`apps/api/src/usecase/projects/generate-project-artifacts.ts:217`. It resolves, in order:

1. the earliest active `JobScheduleInterval.date` for the job,
2. else `JobSchedule.startDate`,
3. else `Job.startDate`,
4. else `null`.

Its single caller is line 461 (`const dueDate = await resolveFirstJobScheduledDate(...)`),
which supplies the same value to **both** permit and plan artifact creation in the same
generation pass. Clause 1 is therefore already built and correct as built.

Clause 2 is also already built: `dueDate` is optional and nullable on both update DTOs —
`apps/api/src/presentation/permits/dto/update-permit.dto.ts:80` and
`apps/api/src/presentation/plans/dto/update-plan.dto.ts:71` — over `Permit.dueDate` and
`Plan.dueDate`, both `DateTime? @db.Date` (`apps/api/prisma/schema.prisma`:2874, :3166).

**No code change is authorised or implied by this note.** It sources what already ships.

## What this does not settle

The decision fixes the **seed** and confirms **editability**. It does not touch the
lead-time question the gap also raised, and that residue is now tracked as its own open entry:
[`../projects-jobs/gaps.md#latest-permit-submission--should-the-app-compute-or-warn-on-a-lead-time-deadline-and-from-which-dataset`](../projects-jobs/gaps.md#latest-permit-submission--should-the-app-compute-or-warn-on-a-lead-time-deadline-and-from-which-dataset).

**UI helper copy (added 2026-09-11, does not change the seed rule):** Ehtesham’s Loom
walkthrough requires that when a job schedule exists, due date on **all plans and permits**
shows that the job schedule starts from that date — see
[2026-09-11-quote-to-project-permits-plans-flow.md](2026-09-11-quote-to-project-permits-plans-flow.md).

Specifically **still open**:

- **Whether the app should ever compute or warn about a lead-time-derived latest-submission
  date at all** — as a second field, a badge, or a scheduling gate. Syed answered what
  `dueDate` means; he did not say the workbook's `Latest Permit Submission` should or should
  not exist in the ERP. Nothing here retires it.
- **Which lead-time dataset would be authoritative if it did.**
  [`../projects-jobs/city-permits/permit-lead-times.md`](../projects-jobs/city-permits/permit-lead-times.md)
  is titled *"three datasets that disagree"*, and
  [`../projects-jobs/city-permits/INDEX.md`](../projects-jobs/city-permits/INDEX.md):44-47
  records that **nobody has said which is the approved Permit Lead-Time Chart** the playbooks
  require, with **34 cities differing** between two of them. This is unchanged by this
  decision and is the harder half of the original question.
- **Whether the artifact tracker's overdue / at-risk signalling keys off this editable
  `dueDate` or off a computed deadline.** An editable field can be moved to silence a
  warning, which is fine for a work-item due date and not fine for a compliance gate. Nobody
  has said which one the tracker is.
- **Whether plans and permits should date the same way at all** — plans carry a 24-hour
  standard turnaround
  ([`../projects-jobs/lift-plans/lift-plan-request-and-3d-lift-plan.md`](../projects-jobs/lift-plans/lift-plan-request-and-3d-lift-plan.md)),
  which the shared seed ignores.
- **Whether the permit-waiver path**
  ([`../projects-jobs/city-permits/permit-waiver.md`](../projects-jobs/city-permits/permit-waiver.md))
  changes the date or only the gate.
- **Green/Yellow/Red** (`dispatch-scheduling-path.md`:75) still cannot be computed from this
  field, because this field ignores lead time by design.

`job-schedule-master-workbook.md` is **not superseded** by this note and keeps
`status: unverified`. Its `Latest Permit Submission` column describes a field this decision
does not cover; treating it as overruled would discard the only lead-time arithmetic the
vault has.

## Effect on the vault

- **Done:** [`../projects-jobs/gaps.md`](../projects-jobs/gaps.md) §*Artifact due date = the
  job's first scheduled day, with no permit lead time* → `Status: answered` (partially),
  pointing here, with its heading and anchor preserved so the open-question sweep keeps
  working.
- **Done:** a new entry, §*"Latest Permit Submission" — should the app compute or warn on a
  lead-time deadline, and from which dataset?*, opened in the same file at
  `Status: open`, carrying the residue above. Splitting it is what keeps
  `grep -rn '^- \*\*Status:\*\* open' vault/*/gaps.md` finding the unanswered half; folding
  it into an answered entry would have hidden it.
- **No winner/loser flip applies, and no frontmatter was edited on any product file.** This
  gap was never a conflict set between vault documents — no vault file specifies an artifact
  `dueDate` at all, which is why the entry recorded that *"no source names a 'due date' field
  on a permit or plan artifact"*. The four-step closure in `README.md` → *How a gap gets
  closed* is written for conflict sets; here only the decision note and the `gaps.md` status
  change apply. `job-schedule-master-workbook.md`, `dispatch-scheduling-path.md`,
  `quote-to-job-lifecycle.md` and `05-forms-and-records-matrix.md` all keep
  `status: unverified` and gain no `superseded_by:`.
- **Done.** Listed under *Decisions that bind this module* in
  [`../projects-jobs/INDEX.md`](../projects-jobs/INDEX.md):47-59, appended 2026-09-08 by the
  session that recorded this note — `tcg-scrum` has no write access to that body, so it flagged
  the row and it was added separately.
