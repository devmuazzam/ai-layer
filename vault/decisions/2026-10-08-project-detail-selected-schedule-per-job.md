---
title: Project Detail shows each job's selected schedule — one row per job, all three Schedule-tab counts, computed exactly as the Schedule tab does (Syed Haris, 2026-10-08) — decision
source: decision/Syed Haris — the open question on Linear TCG-101, tcg branch `fix/8-oct`
decided: 2026-10-08
decided_by: >-
  Syed Haris (CodingCops developer), stated 2026-10-08 in a Claude Code session on tcg branch
  `fix/8-oct`, answering the open question on Linear TCG-101 ("Project Detail: show which
  schedule days were selected"). The ticket suggested Fouzan Shakil decide and Umair Khan
  confirm; neither was asked. **Umair Khan's confirmation that this is what UAT 4 #21 meant is
  still outstanding.** This is a CodingCops developer-side UI convention, not a TCG client
  sign-off. That is why the status is `reference`: it binds the CodingCops build, and TCG can
  overrule it. Same basis as the other CodingCops decisions in this folder, e.g.
  decisions/2026-10-08-quotation-measuring-unit-stays-locked.md.
status: reference
conflicts_with: []
resolves: []
related_decisions:
  - 2026-08-28-job-schedule-weekend-empty-state.md
jira: []
tags: [module/projects-jobs, kind/decision, scheduling]
---

# Project Detail shows each job's selected schedule — per job, all three counts

## The question

UAT 4 #21 ([`../uat/sessions/uat-session-4.md`](../uat/sessions/uat-session-4.md) line 38):
*"On the **Project Detail** page, we need information showing which schedule was selected in the
quotation."* Register row: [`../uat/register-2026-09-18.md`](../uat/register-2026-09-18.md) line
282, *"Show which schedule was selected on the quotation"* — NOT DONE, *"The specific fields
still need naming"*, and *"a quotation has no multi-schedule selection … There is nothing to
display until someone defines what 'which schedule' means here."*

Linear **TCG-101** (*"Project Detail: show which schedule days were selected"*) narrowed it to
the job schedule and left one question open: a project has many jobs, each with its own
schedule — show it **per job or as one total**, and **which of the three numbers** the job's
Schedule tab shows (Job Duration Days, Selected Working Days, Selected Second Shifts).

No gaps entry existed for this question (the ticket's technical notes say so; confirmed).

## Decision

Syed Haris, 2026-10-08:

1. **Per job.** One row per job on the project — never a single project total.
2. **All three numbers** on each row: **Job Duration Days**, **Selected Working Days**,
   **Selected Second Shifts**.
3. **Computed exactly as the job's Schedule tab computes them.** The two screens share one
   definition, so they cannot disagree.

## Why

- **Per job, because a total needs a rule nobody has written.** Jobs on one project overlap or
  run back to back; summing their days (or counting distinct dates) is a product decision, and a
  per-job row needs none.
- **All three, because the request did not name a field** and the three already exist together
  on the Schedule tab — showing them together is the least-invented reading.
- **Same computation, because two screens counting the same schedule differently would be
  re-reported as a bug.** Sharing the helper removes that possibility.

## As built

Client commit `234e7c7fa` on tcg branch `fix/8-oct` (*"feat(projects): show each job's selected
schedule days on Project Detail (TCG-101)"*):

- Project Detail → **Details** tab → new **"Selected Schedule"** card
  (`apps/web/src/features/projects/components/project-detail-schedule-summary.tsx`).
- Counts come from `summarizeScheduleEntries` in
  `apps/web/src/features/projects/jobs/job-details/schedule/utils/schedule-shift-patch.ts` — the
  Schedule tab's footer counts, moved out of `job-schedule-tab.tsx` so both screens call one
  function. Days are built by the tab's own `resolveInitialState`. Selected Working Days counts
  days that are `isActive` and selectable; Selected Second Shifts counts second shifts among
  those selected days.
- Cost: one job-detail request per job, cached under the Job page's query key.
- Checks: web typecheck and 903 web tests pass (2 new for the shared counts). **Not exercised in
  the running app.**

## What this does NOT settle

- **Umair Khan's confirmation** that "which schedule was selected" in UAT 4 #21 meant these job
  schedule counts. If it meant something else (e.g. the quotation's own dates or a schedule
  type), this card answers a different question and the UAT row stays open on it.
- **What `isActive` defaults to on a converted job.** Owned by the open entry
  [*Converted-quotation schedule days — checked by default, and what that puts on the DAS board*](../projects-jobs/gaps.md#converted-quotation-schedule-days--checked-by-default-and-what-that-puts-on-the-das-board)
  ([`../projects-jobs/gaps.md`](../projects-jobs/gaps.md) line 385). Related, not merged: this
  card displays whatever `isActive` is, so that entry's answer changes what Selected Working Days
  reads on a freshly converted job. That entry stays open.
- **A project-level total.** Not decided; deliberately not built.

## Effect on the vault

- **Done:** [`../projects-jobs/INDEX.md`](../projects-jobs/INDEX.md) → *Decisions that bind this
  module* lists this note.
- **Done:** root [`../INDEX.md`](../INDEX.md) decisions table lists this note.
- **Not changed:** [`../uat/register-2026-09-18.md`](../uat/register-2026-09-18.md) line 282 stays
  NOT DONE — register rows are flipped to DONE when the work merges, and `fix/8-oct` is unmerged.
- **Not changed:** [`../projects-jobs/gaps.md`](../projects-jobs/gaps.md) — the neighbouring
  entry is cross-linked above, not resolved. No gaps entry existed for this question, so none is
  closed.
- **No frontmatter flips.** A `reference` developer ruling verifies no vault source.
