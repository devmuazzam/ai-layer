---
title: "Holdover payable-window close chain reaches every non-Home-start holdover day — decision"
source: decision/owner — answer Q1 = B in HOLDOVER-PAYROLL spec §12, 2026-10-26
decided: 2026-10-26
decided_by: >-
  The product owner (Syed Haris, CodingCops), answer Q1 = B, captured in
  .ai/aidlc/HOLDOVER-PAYROLL/spec.md §12 Q1 on 2026-10-26, relayed by the elaboration
  coordinator (no direct written owner message in the vault). This is the day-reach
  of the window-close precedence recorded in
  decisions/2026-10-26-holdover-window-close-precedence-breakdown-boom-buildup.md
  (Q7); Home-start days are governed by Q2
  (decisions/2026-10-26-home-start-holdover-payable-start-work-to-end-work.md). A
  pay-rule decision (G4) that overrides the verified yard-to-yard rule on holdover
  days. TCG client ratification was not sought — see Why.
status: verified
resolves: HOLDOVER-PAYROLL/spec.md#q1
conflicts_with: []
tags: [module/payroll, module/field-ops, kind/decision, api]
entities: [BREAKDOWN_TIME, BOOM_TIME, BUILDUP_TIME, WORK_TIME]
---

# Holdover window-close chain — which days it reaches — the decision

## Decision

The window-close precedence (break-down end → boom end → build-up end,
`decisions/2026-10-26-holdover-window-close-precedence-breakdown-boom-buildup.md`)
governs **every non-Home-start holdover day — Day 1 and the last day included**, not
only Yard-start middle days (option A was rejected).

The chain resolves to the recorded **break-down end whenever one is recorded, on any
day** — a break-down CAN occur on a middle (non-last) day in a holdover job, so the
recorded break-down end is used whenever it exists; a day with no break-down is not a
rule, it is simply the next step of the chain (boom, then build-up). On Day 1 and the
last day, whose paid end today is the `WORK_TIME` end (yard return), the paid end now
follows the same chain.

Owner (answer Q1 = B, spec §12, 2026-10-26): the chain governs every non-Home-start
holdover day, Day 1 and the last day included, and resolves to the break-down end
whenever one is recorded; "in holdover jobs a break-down CAN occur on middle
(non-last) days too".

## Why

The developer plan gave the chain with no day scope. GAP-HO2 sub-questions 3–5 (Day 1
end / Days 2+ end / last-day end) were open with TCG, and the verified yard-to-yard
note (`decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md`) has no holdover
exception at all. The owner decided the chain applies uniformly across all
non-Home-start holdover days rather than carving out the first and last, so the window
math has one derivation with no per-day branching (spec REQ-04 notes for the executor).

**Not a client ruling, and it overrides a verified rule.** This answer overrides the
client-confirmed yard-to-yard paid-time boundary (verified, Kyle Harlow / Joe
Schacatano, 2026-09-03) on holdover days. No TCG client member has ratified the
override; the 2026-10-06 Melissa McNutt provisional note is held by TCG, not in this
vault. It is recorded as the owner's product decision for this build and
`payroll/gaps.md` is not edited by this decision; to be confirmed at payroll sign-off.

## Effect on the vault

- No vault file is flipped to `superseded`: `decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md`
  (DEC-YARD) remains the rule for non-holdover tickets. This note records that the owner
  narrowed its window *end* on holdover days; DEC-YARD's body is not edited (bodies are
  never edited) and the narrowing lives here and in the provenance register.
- Provenance: `payroll/payroll-rules-provenance.md` REQ-04 row cites this note (G4),
  added in the same pass.

## Effect on the spec

- `.ai/aidlc/HOLDOVER-PAYROLL/spec.md` §12 Q1 — marked resolved, pointing at this
  note. Unblocks REQ-02, REQ-04.
