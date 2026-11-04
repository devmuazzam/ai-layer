---
title: The yard steps read "Dispatch" and "Return to Yard", not "Loadout" and "Offload" — user-visible text only, no backfill (Fouzan Shakil, 2026-10-20, developer-confirmed) — decision
source: decision/Fouzan Shakil — developer confirmation while building Linear TCG-239, tcg branch `feat/tcg-239-dispatch-return-to-yard-wording`
decided: 2026-10-20
decided_by: >-
  Fouzan Shakil (CodingCops developer, assignee of Linear TCG-239), confirmed in a Claude Code
  session on 2026-10-20. He confirmed the wording and its scope, and that stored activity-log rows
  get no backfill. The terms are not his own invention: TCG (Joe Schacatano, Melissa McNutt, Brian
  Petros) floated them at the 2026-10-07 sprint review, but did not choose one. Melissa said
  (24:54) "we'll come back to you guys on that one". This note records a developer confirming the
  direction the room leaned. TCG has not confirmed it, and may overrule it. That is why the status
  is `reference`, not `verified`. Same basis as
  decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md.
status: reference
conflicts_with: []
resolves: []
related_tickets:
  - TCG-239 (Linear)
related_decisions:
  - 2026-09-14-yard-unassigned-slots-not-loadable.md
  - 2026-09-15-fix-15-sep-das-and-quotations-as-built.md
  - 2026-08-20-job-completed-on-last-day-offload.md
jira: []
tags: [module/dispatch, kind/decision, yards, daily-allocation]
---

# The yard steps read "Dispatch" and "Return to Yard"

## Where this came from

At the 2026-10-07 sprint review, TCG said "Loadout" and "Offload" are the wrong words
(meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md §5;
transcript 22:55–27:00, `unverified`):

- **Joe Schacatano (23:15–23:26):** *"Can we try to think of a different word than loaded and
  offloaded?"* TCG uses loading and offloading for real loading, *"for like storage or… spreader
  bars"*. He wants those words kept for that.
- **Ideas floated, none chosen:**
  - Melissa McNutt: *"return to yard"* (24:31).
  - syed.haris: *"start dispatch"* (25:50). Joe liked it (26:05).
  - Brian Petros named the terms TCG uses (26:19–26:28): **available**, **unavailable**,
    **return to the yard**.
- **Melissa (24:54):** *"we'll think about it. We'll come back to you guys on that one."*
  TCG has not come back with a choice.

On 2026-10-20 Fouzan Shakil confirmed the wording below for TCG-239. He took "Dispatch" from
syed.haris's proposal, which Joe liked, and "Return to Yard" from Melissa and Brian.

## Decision

**The words "loading" and "offloading" are kept for real loading**, such as storage or spreader
bars (Joe, 23:26). The Yard Operations / DAS steps are renamed in user-visible text.

**Loadout becomes Dispatch:**

| Was | Now |
| --- | --- |
| Loadout (the step) | Dispatch |
| Start Loadout | Start Dispatch |
| Mark Available for Loadout | Mark Available for Dispatch |
| Phase 1: Ready for Loadout | Phase 1: Ready for Dispatch |
| Phase 2: Loadout | Phase 2: Dispatch |
| Pending Loadout / Partial Loadout | Pending Dispatch / Partial Dispatch |
| loaded out | dispatched |
| Loadout completed | Dispatch completed |

**Offload becomes Return to Yard:**

| Was | Now |
| --- | --- |
| Offload / Off-load (the step) | Return to Yard |
| Phase 3: Off-load | Phase 3: Return to Yard |
| Pending Offload | Pending Return to Yard |
| offloaded | returned to yard |
| Not offloaded | Not returned to yard |
| Marked as Offloaded | Marked as Returned to Yard |
| Confirm & close offload | Confirm & close Return to Yard |
| Offload completed | Return to Yard completed |
| Offload force-completed | Return to Yard force-completed |

**Scope: user-visible text only.** That means web UI labels, toasts and API error messages.

**These keep their current names:** identifiers, routes, query keys, `data-testid`s, CSS
variables, stored markers and Swagger summaries. So `LOADOUT` / `OFFLOAD` enum members, the
`das-loadout` service and its routes do not change. The `qa-automation/` selectors stay valid.

**No backfill (also Fouzan Shakil).** Activity-log rows already stored keep their old wording.
Only rows written after the change use the new words.

## Why

- **The client's own reason (Joe, 23:26):** "loading" and "offloading" mean physical loading at
  TCG. Using them for a step that only means *the job's resources go out* or *come back* confuses
  the two.
- **Why user-visible text only (the developer's scope, not TCG's words):** renaming identifiers,
  routes, test IDs or stored markers changes nothing for the user. It would break `qa-automation/`
  selectors and stored data. And TCG may still pick other words.
- **Why no backfill (the developer's choice):** the stored rows are a record of what was shown
  when they were written.

## What this does NOT settle

- **TCG's choice.** TCG said it would come back with words and has not. If TCG picks other words,
  that overrules this note, and the same user-visible strings change again.
- **Mobile.** The scope above names the web UI, toasts and API errors. Per syed.haris (26:39),
  mobile already says *left job site* and *arrived at yard*. Mobile was not asked about.
- **Part 2 of TCG-239: collapse asset statuses to Available / Unavailable. Still open.**
  Joe (25:39): *"It should just be unavailable available"*. Brian (26:19–26:28): *available* means
  free to dispatch, *unavailable* means down or on a job. Nobody chose a status set. Open questions:
  1. **Which status set is collapsed?** The DAS dispatch status, `Asset.status`, or both?
  2. **How do today's values map?** Which of Assigned, Off Site, Maintenance and Out of Service
     become *Unavailable*? Is any of them *Available*?
  3. **Does the reason stay visible?** If Maintenance and Out of Service both show as
     *Unavailable*, is the underlying reason still shown somewhere, for example as a sub-label or
     tooltip, or is it hidden?

  These are not filed in a register yet. TCG-239 has no `.ai/aidlc/` folder, so they have no
  `spec.md` §12. Owner: product team, Brian Petros / Joe Schacatano (dispatch).

## Effect on the vault

- **No frontmatter edits.** No vault file fixed the wording of these steps, so no file becomes
  `verified` or `superseded`, and no `conflicts_with:` pair is adjudicated. This note is
  `reference`, not `verified`.
- **dispatch/gaps.md:** a dated 2026-10-20 note under item 6 of *Yard loadout — client asks recorded
  on tape, never ticketed*. It says *"Offload forcefully – rename"*
  (dispatch/yard-operations-jz.md:20) is now covered: force-complete reads "Return to Yard
  force-completed". The entry's `Status:` stays `open`, because items 1–5 and item 6's second half
  are unanswered. Done.
- **meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md** §5 *Not
  decided*: **not edited.** Curated meeting notes are content, and decision notes do not edit their
  bodies. That bullet stays correct as a record, because TCG did not decide.
- **Indexed:** INDEX.md → *decisions/*, and dispatch/INDEX.md → *Decisions that bind this module*.
  Done.
