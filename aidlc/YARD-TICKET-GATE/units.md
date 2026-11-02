# Units — YARD-TICKET-GATE Yard-Operations dependency for employee tickets

> Retrofitted from `spec.md`. The work shipped on a single branch before decomposition, so both
> units below were built together on `feat/yard-ops-ticket-start-gate` — a deviation from
> one-unit-one-PR, recorded honestly here rather than re-sliced after the fact.

## Gate baseline

**Gate baseline:** `2026-11-02`, `origin/staging` at `7ddd0f30c` — lint: 0 errors (`apps/web`
not run), typecheck: mobile pass (0 errors), build: `@tcg/api` pass, test: `@tcg/api` affected
pass (228), `@tcg/mobile` card/contract/active-tickets pass (93). Measured on this branch after
the change; the pre-change baseline on `origin/staging` was green for the same targets.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | API gates the ticket on yard state and exposes it to mobile | REQ-01, REQ-02, REQ-03, REQ-04, REQ-05 (api) | schema, api | — | ~150 lines / 7 files | built — `feat/yard-ops-ticket-start-gate` |
| U2 | Mobile locks the card and the Left-Yard steps per the gate | REQ-01, REQ-02, REQ-05 (mobile) | mobile | U1 | ~215 lines / 5 files | built — `feat/yard-ops-ticket-start-gate` |

- Requirements covered: REQ-01..REQ-05, counted against `spec.md` §2 on 2026-11-02. Not covered: none.
- Units blocked on an open question: none (all §12 resolved).

---

## U1 — API yard gate

- **Outcome:** a non-holdover ticket's step punches are rejected by the API until its shift is
  Available for Dispatch (any step) and Complete Loadout (`leftYard`+), and the field-ticket read
  model reports that gate; holdover tickets are untouched.
- **Kind:** vertical (schema + API behaviour observable via the field-ticket API).
- **Requirements covered:** REQ-03, REQ-04 fully; REQ-01/REQ-02/REQ-05 — their API halves.
- **Depends on:** —
- **Branch / PR base:** `feat/yard-ops-ticket-start-gate` from `origin/staging` (shipped with U2).
- **Size estimate:** ~150 source lines, 7 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `loadout_completed_shifts_at` JSONB on `sub_job_loadouts` | migration `20261102120000_yard_loadout_completed_shifts_at` |
| API | `das-loadout-shift-keys.util.ts` `isShiftLoadedOut`; `das-loadout.repository.ts`/`.service.ts` per-shift write in `completeLoadout`; `job-tickets.repository.ts` `loadout` select + `findYardGateForTicket`; `field-ticket.mapper.ts` `yardGate`; `job-tickets.service.ts` guard in `recordTicketStep` | layering respected |
| Web | — | N/A |
| Mobile | — | U2 |
| Shared | — | reads existing `ALL_TICKET_FLOW_STEP_KEYS` |
| Tests | updated existing `das-loadout-*.spec.ts` (3) and `job-tickets.service.spec.ts` | `not requested` — no new specs |

### Reviewable as

- **Demo:** `PATCH /api/v1/field/tickets/:id/steps` for a non-holdover ticket whose shift is not
  marked available → 409; after Mark Available → `pretrip` ok, `leftYard` → 409; after Complete
  Loadout → `leftYard` ok. `GET /api/v1/field/tickets` shows `yardGate`.
- **Acceptance:** REQ-01/02/03/04 acceptance lines.
- **Reviewer can verify without:** U2 (API-only, via HTTP).

### Risk

- **Weakest source:** `[UNVERIFIED]` (normal case).
- **Migration reversible:** yes — additive nullable column; drop to reverse.
- **Behind a flag:** no.
- **Touches existing data:** no — legacy rows read via shift-1 fallback.
- **Blast radius:** a wrong gate would block legitimate step punches (409). Mitigated: holdover
  exempt, no-loadout-row only reached pre-dispatch, guard above the COMPLETE short-circuit.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `das-loadout.service.ts` `completeLoadout` | repo signature +`shiftNumber` | `das-loadout` specs pass (228) | `spec.md` REQ-03 |
| yard board loadout/offload | `SubJobLoadout` reads | unchanged columns; new column only added | `spec.md` §11a |
| `recordTicketStep` existing flows | new guard | `job-tickets.service.spec.ts` 97 pass (mock returns available+loaded) | `spec.md` REQ-01/02 |

### Deliberately not in this unit

- Mobile UI — U2.

---

## U2 — Mobile gate

- **Outcome:** on the phone, a non-holdover ticket whose yard job is not Available for Dispatch
  shows the locked future-style card with the pending message and will not open; once available,
  `leftYard` and later steps stay locked until Complete Loadout.
- **Kind:** vertical.
- **Requirements covered:** REQ-01, REQ-02 mobile halves; REQ-05 (holdover shows no gate).
- **Depends on:** U1 (reads `yardGate` from the API).
- **Branch / PR base:** `feat/yard-ops-ticket-start-gate` (shipped with U1).
- **Size estimate:** ~215 source lines, 5 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | — | N/A |
| API | — | U1 |
| Web | — | N/A |
| Mobile | `ticket.contract.ts` `yardGate` + `isYardStartPending`/`isYardLeaveBlocked`; `ticket-card.tsx` `isGated`/`gateMessage` via future treatment; `active-tickets-section.tsx` gate 1 wiring; `app/(field)/field.tsx` block open; `ticket-step-screen.tsx` gate-2 locked body | tokens from `theme/tokens.ts` |
| Shared | — | — |
| Tests | existing card/contract tests pass | `not requested` |

### Reviewable as

- **Demo:** dashboard card shows "Ticket start is pending until the Yard Operation is marked
  Available for Dispatch." with no Start button; after Mark Available it opens and starts; the
  `leftYard` step shows "available once the Yard Operation completes Loadout" until Complete Loadout.
- **Acceptance:** REQ-01/02/05 acceptance lines.
- **Reviewer can verify without:** a real tenant if the API is stubbed to return `yardGate`.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** a wrong `yardGate` read could hide a startable ticket; the API guard is the
  backstop, and holdover tickets carry `yardGate: null` so they are never gated.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Future-ticket card | `isFuture` → `futureOrGated` | card/contract tests pass (93) | `spec.md` §11c |
| `openFieldTicket` (notification nav) | added gate-1 early return | manual: gated ticket does not open | `spec.md` REQ-01 |
| holdover ticket flow | `yardGate == null` ⇒ selectors false | contract tests; holdover branch untouched | `spec.md` REQ-05 |

### Deliberately not in this unit

- Real-time push on yard release — out of scope (`spec.md` §13); next-fetch pickup.

---

## Sequencing

```
U1 ──▶ U2
```

- **Parallelisable:** no — U2 reads `yardGate` from U1.
- **Merge order constraint:** migration (U1) lands first; both shipped on one branch here.
- **First unit to ship:** U1 — proves the gate and the read model; U2 is pure presentation on top.
