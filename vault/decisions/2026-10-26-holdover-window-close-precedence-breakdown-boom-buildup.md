---
title: "Holdover payable-window close precedence — break-down end → boom end → build-up end — decision"
source: decision/owner (Syed Haris) — plan decision 4, relayed in HOLDOVER-PAYROLL spec §12 Q7, 2026-10-26
decided: 2026-10-26
decided_by: >-
  The product owner (Syed Haris, CodingCops), plan decision 4, captured in
  .ai/aidlc/HOLDOVER-PAYROLL/intent.md §3 and answered as §12 Q7 on 2026-10-26,
  relayed by the elaboration coordinator (no direct written owner message in the
  vault). This is the order in which the holdover paid window closes; its reach by
  day is a separate decision (Q1-B, decisions/2026-10-26-holdover-payable-window-close-reach.md)
  and its composition on Home-start days is a third (Q2,
  decisions/2026-10-26-home-start-holdover-payable-start-work-to-end-work.md). A
  pay-rule decision (G4). TCG client ratification (Corrina Bustos / Brian Petros)
  of this chain was not sought — see Why.
status: verified
resolves: HOLDOVER-PAYROLL/spec.md#q7
conflicts_with: []
tags: [module/payroll, module/field-ops, kind/decision, api]
entities: [BREAKDOWN_TIME, BOOM_TIME, BUILDUP_TIME, WORK_TIME]
---

# Holdover payable-window close precedence — the decision

## Decision

On a holdover ticket the instant the paid window closes on — the End Work instant —
is resolved by this precedence:

1. the recorded **break-down end** (`BREAKDOWN_TIME.endedAt`) whenever a break-down
   session is recorded; else
2. the latest closed **boom end** (`BOOM_TIME.endedAt`) whenever a boom session is
   recorded; else
3. the **build-up end** (`BUILDUP_TIME.endedAt`).

This note records only the order of precedence. Which holdover days the chain
reaches is decided separately (Q1-B — every non-Home-start holdover day, Day 1 and
the last day included), and how it composes with a Home-start day is decided
separately (Q2 — Start Work → End Work, where this chain resolves the End Work
instant).

Owner (plan decision 4, spec §12 Q7, 2026-10-26): "Break-down end, else boom end,
else build-up end."

## Why

A holdover ticket's work does not end at a single obvious event: on different days
the crew finishes with a break-down, with the last boom session, or (when neither is
recorded) with build-up. The precedence names which recorded event is the true end
of paid work, in the order of lateness the owner intends, so the window math has one
deterministic rule instead of guessing per ticket.

**Not a client ruling.** The only source is the developer plan, relayed by the
owner; no TCG client member (Corrina Bustos / Brian Petros) has ratified this chain,
and it overrides the client-confirmed yard-to-yard paid-time boundary
(`decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md`, verified) on holdover
days. It is recorded as the owner's product decision for this build, to be confirmed
at payroll sign-off. The fallback when none of break-down / boom / build-up is closed
is the existing `WORK_TIME` end (spec D8, ASSUMED — not part of this decision).

## Effect on the vault

- No existing vault file is superseded by this note — it records a net-new pay-rule
  decision. `decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md` is **not**
  edited: this chain narrows that rule's window *end* on holdover days only; the
  reach note (Q1-B) carries that relationship.
- Provenance: `payroll/payroll-rules-provenance.md` REQ-02 row cites this note (G4),
  added in the same pass.

## Effect on the spec

- `.ai/aidlc/HOLDOVER-PAYROLL/spec.md` §12 Q7 — marked resolved, pointing at this
  note. Unblocks REQ-02.
