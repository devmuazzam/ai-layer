---
title: Job Schedule weekend-empty empty state — decision
source: decision/assignee
decided: 2026-08-28
decided_by: Fouzan Shakil (assignee / reviewer, PR #391 `fix/job-schedule-weekend-empty-hint`) — approved the recommended answer by approving the implementation plan "Recommended decision for the weekend-empty Schedule hint" in a Cursor review session, 2026-08-28 (workspace user `mfouzan`). An assignee-level product call made during review; no Jira comment and no client (TCG) confirmation exists.
status: verified
resolves: projects-jobs/gaps.md#job-schedule-tab--what-to-show-when-the-date-range-yields-zero-days
jira: []
tags: [module/projects-jobs, kind/decision, scheduling]
---

# Job Schedule tab — empty state when weekend toggles exclude every day

Settles the empty state for one specific edge case: Start Date and End Date are
both set, but Include Saturdays / Include Sundays exclude every calendar day in
the range, so schedule generation yields zero rows.

## Decision

1. **A toggle-specific hint replaces the generic copy.** When
   `enumerateScheduleDates` (the shared range walker behind schedule generation)
   returns zero dates *because* of the weekend toggles — the range is non-empty
   with both toggles on — the Schedule tab must not show the default
   *"No schedule entries. Select a start and end date above to generate the
   schedule."* That copy tells the user to do something they have already done.
2. **Title:** `No schedule days in this range`.
3. **The description has three modes**, keyed on two separate booleans —
   `isEditMode` (the job permits Schedule edits at all) and `isEditing` (the tab
   is currently in edit mode):

   | State | Description |
   | --- | --- |
   | `isEditMode && isEditing` | Actionable — *"Your date range only includes Saturday. Turn on Include Saturdays above to generate schedule days."* (Sunday and both-days variants follow the same shape.) |
   | `isEditMode && !isEditing` | *"Your date range only includes Saturday. Enter edit mode and turn on Include Saturdays to generate schedule days."* |
   | `!isEditMode` (read-only, e.g. `COMPLETED`) | Factual only — *"Your date range only includes Saturday, and Include Saturdays is off."* **No CTA.** |

4. **The read-only variant must not offer a CTA.** A `COMPLETED` job is a hard
   view-only block with no unlock path, so *"Enter edit mode"* would instruct the
   user to do something the API rejects. This clause is bound by
   [`decisions/2026-08-25-completed-job-view-only.md`](2026-08-25-completed-job-view-only.md).
5. **Do not block this edge case on Figma.** SCRUM-234 node `2964-119958` may
   carry a designed empty state, but it was not checked against this case and
   SCRUM-234 has been Done since 2026-06-01. Diagnostic copy naming the
   responsible toggle is implied by the generation rules already written down;
   ship it now and revise if design later supplies canonical copy.

## Why

The behaviour that produces the zero-row state **is** sourced:
`projects-jobs/project-module/03-create-manage-job-schedule.md` (status:
`unverified`) sets the generation contract at AC 1–2 — the system auto-creates
every date between start and end, and *"User can choose to include or exclude
Saturdays and Sundays before generating the schedule."* A Saturday-only range
with Include Saturdays off is that contract working correctly, not an error. So
the empty state is a **diagnostic of the user's own inputs**, and naming the
toggle that emptied the table is the minimum that makes the screen
self-explanatory. Nothing in the vault contradicts this; the gap was that no
document said what the copy should be, not that a document said something else.

The three-mode split exists because a single `isEditing` flag cannot distinguish
*"not editing right now"* from *"editing is permanently blocked"*. The first
review pass of PR #391 keyed only on `isEditing` and would have told the operator
of a `COMPLETED` job to enter edit mode — advice the hard block in
`2026-08-25-completed-job-view-only.md` makes impossible to follow. Splitting on
`isEditMode` is what keeps the two decisions consistent.

The Figma clause is a scoping call, not a claim about design. Waiting on a node
nobody has opened, for an edge case a Done ticket never named, would have blocked
a one-file fix indefinitely.

## Effect on the vault

- **Winner:** this decision, for this edge case only.
- `projects-jobs/project-module/03-create-manage-job-schedule.md` is **not
  superseded** — it remains `unverified` and its generation rules still stand.
  This note adds the empty state it never covered; it contradicts nothing in it,
  so no `status:` or `superseded_by:` change is warranted. **Done:** no
  frontmatter edited on that file, deliberately.
- **Done:** `projects-jobs/gaps.md` § *Job Schedule tab — what to show when the
  date range yields zero days* → `Status: resolved`, pointing here.
- **Done:** listed under *Decisions that bind this module* in
  `projects-jobs/INDEX.md`.

## What this does not settle

- **The copy is not client-confirmed.** This is an assignee call recorded so the
  shipped strings are sourced, not a TCG product ruling. If design or Lisette
  Anzaldo / Ryan Adams later supply canonical copy, it wins over the strings
  above and this note should be superseded, not amended.
- Whether Figma node `2964-119958` contains a designed empty state for the
  ordinary no-dates-yet case (the generic copy at
  `apps/web/.../schedule/components/schedule-table-section.tsx`), which this
  decision leaves untouched.
- Any other zero-row cause — an inverted range (`start > end`), or a range with
  no calendar days at all. Those still fall through to the generic copy by
  design, because no toggle is responsible for them.
- Whether `CANCELLED` or `INVOICED` jobs are read-only, which
  `2026-08-25-completed-job-view-only.md` explicitly left open and which decides
  whether they get the CTA-less variant too.
