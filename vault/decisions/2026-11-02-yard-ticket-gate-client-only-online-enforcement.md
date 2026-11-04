---
title: "Yard-Operations ticket gate is client-only and online-only: server enforcement removed because capturedAt could not tell offline capture from online retry (reverses the client+server intent) — decision"
source: decision/Syed Haris (CodingCops) — owner answer (§12 Q4) and PR-review sign-off (§11b D11, D12) in the Claude Code session of YARD-TICKET-GATE, 2026-11-02
decided: 2026-11-02
decided_by: >-
  Syed Haris (CodingCops), product owner and requester of the YARD-TICKET-GATE build
  (Owner: syedharis14@gmail.com). He first answered §12 Q4 "A — client + server guard" and
  directed "only in online mode … do not enforce … if completed offline" (§11b D11). During
  PR review he then signed off removing the server guard entirely (§11b D12), reversing his
  own Q4 answer. tcg-scrum did not see the session; it records from spec §12 Q4, §11b D11
  and D12, and §13. This is an owner/developer direction for this build, recorded as
  `status: reference` the same way haris directions are recorded elsewhere in this folder:
  binding on the YARD-TICKET-GATE build, open to being overruled by the TCG product team.
status: reference
resolves:
  - YARD-TICKET-GATE/spec.md#q4
conflicts_with: []
related_tickets:
  - YARD-TICKET-GATE
related_decisions:
  - 2026-11-02-yard-ticket-gate-stage-scope-and-card-lock.md
  - 2026-11-02-yard-ticket-gate-legacy-and-no-load-sub-jobs.md
  - 2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md
tags: [module/field-ops, module/dispatch, kind/decision, ticket-workflow, mobile, api]
---

# Yard-Operations ticket gate is client-only and online-only

## Decision

**The gate is enforced on the client only, and only while the device is online.** The server
no longer enforces it: `recordTicketStep` calls no yard guard. `assertYardGateAllowsStep`,
`isLeftYardOrLater` and `findYardGateForTicket` were removed (spec §11b D12). The mobile client
still reads the live `yardGate` field on the ticket and gates both start (gate 1) and the
`leftYard`/later steps (gate 2) while online; every gate call-site is `online && …` (`useOnline`).
A step punched offline is not gated at all.

This **reverses** the owner's first answer to §12 Q4 (A — client + server guard) and the server
half of §11b D11. The client-only, online-only half of D11 stands.

## Why

The server guard keyed on a `capturedAt` / `X-Captured-At` header to tell an offline-captured
punch (which must bypass the gate) from a live online punch (which must be gated). It could not:
the mobile replay op is persisted at `ticket-step-screen.tsx` **before** the live send, so the
header could not distinguish an offline capture from an online retry of a punch. The guard was
therefore wrong in both directions (PR-review findings 2 and 6):

- **It leaked.** An online punch that the server 409'd was drained later from the offline queue
  and succeeded — the gate it was supposed to enforce was bypassed by the retry path.
- **It broke finalization.** The online finalization/review punch is sent without `capturedAt`,
  so the guard 409'd a legitimate punch.

A guard that both leaks the thing it guards and breaks a correct operation is worse than no
guard. The gate is a **dispatch convenience, not a safety control** (spec §13), so removing the
server backstop is an accepted trade-off rather than a lost safeguard.

## What this does not decide

- **Tampered or old clients.** With no server enforcement, a tampered client, or an old mobile
  build whose zod strips the unknown `yardGate` key, is simply ungated — no 409, no error
  (spec §13). Accepted, because the gate is not a safety control.
- **The mechanism details are the AI's** — which call-sites carry `online &&`, the removed
  helper names, and the `yardGate` read model (spec §11b D4, D5, D6). The developer reviews
  them in the PR.

## Effect on the vault

- No vault file changes status. This build resolves no vault conflict; it records a reversal
  internal to the YARD-TICKET-GATE spec.
- `.ai/aidlc/YARD-TICKET-GATE/spec.md` §12 Q4 `Status:` line now points at this note — done in
  the same pass.
