---
title: "Yard-Operations ticket gate: Complete Loadout releases gate 2, the gate is per-shift, and gate 1 locks the whole ticket card — decision"
source: decision/Syed Haris (CodingCops) — owner answers in the Claude Code session of YARD-TICKET-GATE, 2026-11-02 (spec §12 Q1–Q3)
decided: 2026-11-02
decided_by: >-
  Syed Haris (CodingCops), product owner and requester of the YARD-TICKET-GATE build
  (Owner: syedharis14@gmail.com on the spec), answering the lettered options in
  `.ai/aidlc/YARD-TICKET-GATE/spec.md` §12 Q1, Q2 and Q3 on 2026-11-02. tcg-scrum did not
  see the session; it records from the spec's §12 answers and §11b (D1, D2, D10). These are
  owner/developer directions for this build, recorded as `status: reference` the same way
  every other haris direction in this folder is: binding on the YARD-TICKET-GATE build,
  open to being overruled by the TCG product team.
status: reference
resolves:
  - YARD-TICKET-GATE/spec.md#q1
  - YARD-TICKET-GATE/spec.md#q2
  - YARD-TICKET-GATE/spec.md#q3
conflicts_with: []
related_tickets:
  - YARD-TICKET-GATE
related_decisions:
  - 2026-11-02-yard-ticket-gate-client-only-online-enforcement.md
  - 2026-11-02-yard-ticket-gate-legacy-and-no-load-sub-jobs.md
  - 2026-10-20-yard-steps-read-dispatch-and-return-to-yard.md
  - 2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md
tags: [module/field-ops, module/dispatch, kind/decision, ticket-workflow, das, loadout]
---

# Yard-Operations ticket gate: stage, scope, and card lock

The YARD-TICKET-GATE build makes a non-holdover employee ticket depend on its matching
per-day Yard Operations job. Three questions about the shape of that dependency were put to
the owner and answered on 2026-11-02.

## Decision

### Q1 — Which Yard Operations stage releases gate 2 (Left Yard)?

**Complete Loadout.** The event that unlocks the `leftYard` step and every later required
step is the yard's `completeLoadout` action — the one that moves `dasStage` to
`EMPLOYEE_LEFT_YARD`. It is **not** an earlier "loadout started" event. Before this build the
"second stage" on the request was unconfirmed; it is confirmed as Complete Loadout.

So the two gates are:

- **Gate 1** — the ticket cannot be started until the shift is marked **Available for
  Dispatch** (`markAvailable`, `dasStage → LOADOUT`).
- **Gate 2** — `leftYard` and later stay blocked until the shift's loadout is **completed**
  (`completeLoadout`, `dasStage → EMPLOYEE_LEFT_YARD`).

### Q2 — Per-shift or whole-sub-job?

**Per-shift.** Both gates key on the ticket's own shift, not on the whole sub-job. The
whole-sub-job marker (`loadoutCompletedAt`) alone is not enough, so the build adds a symmetric
per-shift completion marker (`loadout_completed_shifts_at`, spec REQ-03 / §11b D1), mirroring
the per-shift `markedAvailableShiftsAt` that already tracked availability. One shift's ticket
unlocks when that shift's loadout completes; another shift of the same sub-job stays gated
until its own shift completes.

### Q3 — What does gate 1 block on mobile?

**It locks the whole ticket card** — it does not merely hide or disable the Start button. The
gated card reuses the existing future-dated-ticket treatment (the card does not open; it shows
the pending message). This is the future-card component parametrised, not a fork (spec §11c).

## Why

- **Complete Loadout, not a start event**, because that is the point at which the crew and
  load are actually released to leave the yard; releasing at "loadout started" would let an
  employee punch Left Yard while the load was still being staged.
- **Per-shift**, because a sub-job can carry more than one shift and they become available and
  load out independently; gating on the whole-sub-job marker would release or hold every
  shift's ticket together, which is wrong when only one shift is ready.
- **Whole-card lock**, because the ticket is simply not actionable yet; reusing the future
  treatment gives the employee a consistent "not ready" state rather than a dead Start button
  with no explanation. The body copy and the "Pending" / "Waiting on the yard" labels are AI
  presentation choices (spec §11b D8), not owner-specified.

## Effect on the vault

- No vault file changes status. This build introduces new behaviour and resolves no vault
  conflict (no conflict stub, no `conflicts_with` to clear); its REQ sources are code plus
  unverified `dispatch/` pages, none of which this note adjudicates.
- `.ai/aidlc/YARD-TICKET-GATE/spec.md` §12 Q1, Q2 and Q3 `Status:` lines now point at this
  note — done in the same pass.
