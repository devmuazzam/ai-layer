---
title: Scope of "the Plan Comments page" in SCRUM-757 — decision
source: decision/assignee
decided: 2026-08-12
decided_by: syed haris (assignee, SCRUM-757) — answered directly in a working session on 2026-08-12, against the spec's Q1. The gap nominated Aiman Farooq (reporter) as owner "or anyone who can open the ticket's attachments"; the assignee answered instead, from knowledge of the screen rather than from the attachments, which remain unopened.
status: verified
resolves: gaps.md#scope-of-the-plan-comments-page-in-scrum-757
topics: [lift-plans, projects, navigation-ui]
entities: [lift-plan, project]
---

## Decision

"The Plan Comments page" in `SCRUM-757` is the **plan detail view** at the route
`/projects/{id}/plans/{id}`.

It is **not** the project **In-House Comments** tab.

Confirmed against the codebase on 2026-08-12: the route resolves to
`apps/web/src/app/(protected)/projects/[id]/plans/[planId]/page.tsx`, whose default export
`PlanViewPage` renders `PlanViewPageContent` and `AddCommentModal` and reads comment data
through `useActivityLogs`. That is the spec's candidate 1.

## Why

The ticket names a page that no vault file, Jira ticket or repo route defines by that name,
and the repo offers two plausible comment surfaces. The elaborator declined to choose
between them because they are different features with different owners — picking wrong
would have scoped every other requirement in the spec to the wrong screen, and the error
would not have surfaced until someone tried to reproduce the bug.

The answer matters beyond naming a file. It settles which of the two open comment problems
this ticket is:

- **`SCRUM-763`** ("Inhouse comments – design update needed", Task, **Blocked**, same epic
  `SCRUM-232`) is open against the *other* screen. These are now confirmed to be two
  separate concerns, and neither blocks the other.
- `product/job-project-das.md` carries two adjacent punch-list one-liners — under **Plan**,
  `rich text field - UI issue`; under **Project**, `in house comments – design update
  needed`. The second belongs to `SCRUM-763`'s screen, not this one. Whether the first
  describes this ticket's defect is **still unknown** and was not decided here.

## Effect on the vault

- **No winner/loser flip applies.** This gap is not a conflict set between vault documents —
  no vault file specifies a Plan Comments page at all, which is why the gap recorded
  `Candidates: none` and the question went to a person. The four-step closure in
  `README.md` → *How a gap gets closed* is written for conflict sets; here only the
  decision note and the `gaps.md` status change apply. No `status:`, `superseded_by:` or
  `conflicts_with:` field on any product file changes.
- `gaps.md#scope-of-the-plan-comments-page-in-scrum-757` → `Status: resolved`.

## Effect on SCRUM-757

- **REQ-01** moves from `[OPEN]` to `[VERIFIED]`, sourced to this note.
- Every other requirement is now **scoped** to the plan detail view, and the two code
  observations the spec recorded as questions are confirmed to sit on the right screen —
  comments persisting as project activity-log entries, and `useAddPlanComment` invalidating
  three query keys per comment. They remain observations. **Neither is a diagnosis and
  neither is authorised as a fix by this decision.**
- **The ticket is still blocked.** Q2, Q3, Q4 and Q5 are unanswered, and four of seven
  requirements remain `[OPEN]`. This decision makes the remaining questions answerable
  against a known screen; it does not make anything buildable.
