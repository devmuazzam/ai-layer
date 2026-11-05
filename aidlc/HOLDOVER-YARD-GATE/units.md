# Units — HOLDOVER-YARD-GATE

**Path:** A · **Branch:** `feat/holdover-yard-gate` · **Total units:** 2

## Unit ledger

| Unit | Title                                                             | Surface | Status            | PR                                                                    | Target    |
| ---- | ----------------------------------------------------------------- | ------- | ----------------- | --------------------------------------------------------------------- | --------- |
| U1   | Expose `yardGate` for holdover tickets in field-ticket read model | API     | merged — PR #1042 | [#1042](https://github.com/TheCraneGuys/craneguys-platform/pull/1042) | `staging` |
| U2   | Mobile holdover ticket gating & Home-start exemption              | Mobile  | merged — PR #1042 | [#1042](https://github.com/TheCraneGuys/craneguys-platform/pull/1042) | `staging` |

Both units merged together on 2026-11-05 as `c98b670da`, containing implementation commit `5f42143fd`. Platform `main` does not yet contain this change. The planned API/mobile split was not delivered as separate PRs; see `reflection.md`.

---

### Unit 1 — Expose `yardGate` for holdover tickets in API read model

- **Surface:** `apps/api`
- **Files touched:**
  - `apps/api/src/usecase/field-tickets/field-ticket.mapper.ts`
- **Changes:**
  - In `toFieldTicket`, remove `holdover === undefined` restriction from `yardGate` generation.
  - Compute `yardGate = isLoadable ? { available: isShiftMarkedAvailable(loadout, shiftNumber ?? 1), loadedOut: isShiftLoadedOut(loadout, shiftNumber ?? 1) } : null`.
  - Update `field-ticket.mapper.spec.ts` (if existing) or run API specs.

---

### Unit 2 — Mobile holdover ticket gating & Home-start exemption

- **Surface:** `apps/mobile`
- **Files touched:**
  - `apps/mobile/data/contracts/ticket.contract.ts`
  - `apps/mobile/components/field/active-tickets-section.tsx`
  - `apps/mobile/app/(field)/jobs.tsx`
  - `apps/mobile/app/(field)/ticket/index.tsx`
  - `apps/mobile/features/field-ticket/flow/ticket-step-screen.tsx`
- **Changes:**
  - In `ticket.contract.ts`:
    - Extend `YardGateTicket` to include `holdover?: FieldTicketHoldover | null`.
    - Update `isYardStartPending(ticket, effectiveDayStart?)`:
      - If `ticket.holdover?.dayNumber >= 2` and `(effectiveDayStart ?? ticket.holdover?.dayStartFrom) === 'HOME'`: return `false`.
      - Otherwise, if `ticket.yardGate`, check `!ticket.yardGate.available`.
    - Update `isYardLeaveBlocked(ticket, effectiveDayStart?)`:
      - If `ticket.holdover?.dayNumber >= 2` and `(effectiveDayStart ?? ticket.holdover?.dayStartFrom) === 'HOME'`: return `false`.
      - Otherwise, if `ticket.yardGate`, check `!ticket.yardGate.loadedOut`.
  - In `ticket/index.tsx`:
    - Pass `effectiveDayStart` to `isYardGateLockedStep`.
  - In `ticket-step-screen.tsx`:
    - Ensure `isYardGate2Locked` respects `effectiveDayStart === 'HOME'`.
  - Update `ticket.contract.test.ts` to verify holdover Day 1 gate, Day 2+ Yard gate, and Day 2+ Home exemption.
