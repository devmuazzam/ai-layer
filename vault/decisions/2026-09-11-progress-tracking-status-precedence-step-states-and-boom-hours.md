---
title: Progress Tracking badge precedence, step states and boom hours — decision
source: decision/Syed Haris
decided: 2026-09-11
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing SCRUM-PROGRESS; picked this
  option in a working session on 2026-09-11 (`.ai/aidlc/SCRUM-PROGRESS/spec.md` §12 Q2–Q4, Q6).
  **Not** the client-side product owner. The vault's projects-jobs owner is
  **Lisette Anzaldo** (Dispatch Manager, `admin/engagement-directory-and-org-charts.md`), and **she
  should ratify it.** `status: reference` for that reason. Same basis as the other 2026-09-11 notes.
status: reference
conflicts_with: []
resolves: [SCRUM-PROGRESS/spec.md#q2, SCRUM-PROGRESS/spec.md#q3, SCRUM-PROGRESS/spec.md#q4, SCRUM-PROGRESS/spec.md#q6]
jira: []
tags: [module/projects-jobs, module/payroll, module/dispatch, kind/decision, ticket-workflow, time-tracking, boom, inspections, safety]
---

# Badge precedence, step states and boom hours

Answers spec §12 Q2, Q3, Q4, Q6. **Q5 stays open.**

## Decision

> **Q:** Adopt the spec's proposed defaults for its other open questions? (Q2 badge precedence
> Incomplete → Flagged → Rejected → Completed → In progress → Not opened; Q3 a Completed ticket
> can still be Flagged; Q4 a step is done once any capture exists, the first step without one is
> current, and a later step's capture implies the earlier ones were passed; Q6 boom hours = closed
> build-up + boom + break-down time)
> **Chosen:** *Adopt all four (Recommended)* — "Build with Q2, Q3, Q4 and Q6 exactly as described.
> Q5 … stays open, since it only matters once Incomplete ships."

**Not chosen:** *Adopt, but no inference* — "…a step with no capture of its own reads 'Not
recorded' even when a later step proves it was passed."

- **Q2:** badge precedence is Incomplete → Flagged → Rejected → Completed → In progress → Not
  opened. Incomplete does not apply until REQ-13 ships.
- **Q3:** yes. A Completed ticket with an incident or deficiency reads Flagged.
- **Q4:** a step is **done** once any capture exists for it (spec REQ-06). A step with no capture
  of its own is also **done** when a later step has one, and shows no time of its own. The first
  step that is neither is **current**; steps after it are **not reached**. Inferred steps count
  as done in D3's progress %.
- **Q6:** boom hours are the **closed** windows of all three `BOOM_PAY_TYPES`: `BUILDUP_TIME`,
  `BOOM_TIME`, `BREAKDOWN_TIME` (`apps/api/src/usecase/ticket-time-entries/derive-ticket-times.ts`).
  An open window counts nothing.

## Why

- **Q2/Q3:** the spec's reasoning. Rejected sits beside Flagged as the other exception; In
  progress is the default active state. Flagged is a condition, not a transition, so Completed
  does not clear it.
- **Q4:** he chose inference over "Not recorded". A later capture is evidence the earlier step
  was passed.
- **Q6:** payroll's boom pay (PAY-043) uses these three windows and drops open ones
  (`apps/api/src/usecase/payroll/payroll.service.ts` ~:792). The card follows payroll, not the
  design's mock "elapsed − paused" (`SCRUM-PROGRESS/design/progress-tracking.design-extract.js:636`).

## What is weak about this attribution

- **The decider of record is Syed Haris**, binding on the build. **Lisette Anzaldo should ratify.**
- **Q4 goes further than the spec's own default.** The spec's Q4 workaround had no inference: a
  step with no capture of its own was current or not reached. Under the approved wording, a step
  before a captured one is done instead.
- **Two parts carry by reference only.** The summary he saw omitted Q4's per-step **flagged**
  ("that step's own capture shows a deficiency/incident/refusal") and Q6's **1-decimal
  rounding**. The question adopted "the spec's proposed defaults", so both carry.
- **Q6 says "closed"**, narrower than the spec's workaround, which summed `boomSegments` (open
  segments included).

## What this does NOT settle

- **Q5** (the null end time, shared with SCRUM-PENDING) is still open, so REQ-13 stays `[OPEN]`.
- **Two "current" rules.** The timeline's current row (Q4) and the summary card's current-step
  text (D3's 2026-09-10 phase rule) are derived differently and can name different things.
  Nobody has said if that is acceptable.
- **Sum or union.** Payroll credits a slice that falls in two overlapping windows only once (the
  `BOOM_PAY_TYPES` comment). "Closed … time" does not say which to use. The two differ only if
  windows overlap.
- **Where an incident flags.** An incident is not a step (REQ-06), so the per-step flagged clause
  names no row for it.

## Effect on the vault

- **No vault body edited, no frontmatter flipped.** No documents conflicted.
- Spec §12 Q2, Q3, Q4, Q6 resolved; Q5 left open. Dependent REQ lines updated in the same pass,
  on explicit instruction.
- **`projects-jobs/INDEX.md` gained a line for this note**, on explicit instruction and outside
  `tcg-scrum`'s normal write scope.
