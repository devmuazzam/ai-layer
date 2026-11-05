# Spec — HOLDOVER-YARD-GATE Yard-Operations dependency for holdover tickets

## 0. Provenance

| Field                             | Value                                                                                                                                                                                                                                                                                                      |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Ticket                            | `none` — slug `HOLDOVER-YARD-GATE`                                                                                                                                                                                                                                                                         |
| Intent                            | `.ai/aidlc/HOLDOVER-YARD-GATE/intent.md`, captured `2026-11-04`                                                                                                                                                                                                                                            |
| Elaborated on                     | `2026-11-04`                                                                                                                                                                                                                                                                                               |
| Vault state at elaboration        | `decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md`, `decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md`, `decisions/2026-11-02-yard-ticket-gate-stage-scope-and-card-lock.md`, `decisions/2026-11-02-yard-ticket-gate-client-only-online-enforcement.md` |
| Open questions raised             | 3 in §12 (Day 2+ pre-choice dashboard behavior, Start Work punch-in timing, API mapper payload structure)                                                                                                                                                                                                  |
| Already-shipped behaviour reached | Mobile holdover flow (`useDayStart`, `HoldoverDayStartCard`), ticket card (`ticket-card.tsx`), ticket overview (`ticket/index.tsx`), and API mapper (`field-ticket.mapper.ts`)                                                                                                                             |
| Rules consulted                   | `AGENTS.md`, `contexts/api.md`, `contexts/mobile.md`                                                                                                                                                                                                                                                       |

## 1. Requirements ledger

| Req    | Title                                                                        | Surface     | Flag           | Sources                                                                         | Blocks build?    |
| ------ | ---------------------------------------------------------------------------- | ----------- | -------------- | ------------------------------------------------------------------------------- | ---------------- |
| REQ-01 | Gate 1 on Day 1 Holdover — block start until Available for Dispatch          | mobile, api | `[UNVERIFIED]` | user request; `YARD-TICKET-GATE`                                                | no               |
| REQ-02 | Gate 2 on Day 1 Holdover — block Left Yard & later until Complete Loadout    | mobile, api | `[UNVERIFIED]` | user request; `YARD-TICKET-GATE`                                                | no               |
| REQ-03 | Gate 1 on Day 2+ Yard Start — block start until Available for Dispatch       | mobile, api | `[UNVERIFIED]` | user request                                                                    | no — Q1 resolved |
| REQ-04 | Gate 2 on Day 2+ Yard Start — block Left Yard & later until Complete Loadout | mobile, api | `[UNVERIFIED]` | user request                                                                    | no               |
| REQ-05 | Home-Start Exemption on Day 2+ — no yard gate enforcement                    | mobile, api | `[UNVERIFIED]` | user request; `decisions/2026-10-15-...`                                        | no               |
| REQ-06 | Expose `yardGate` in API read model for holdover tickets                     | api         | `[UNVERIFIED]` | user request; `field-ticket.mapper.ts`                                          | no               |
| REQ-07 | Client-only, online-only enforcement                                         | mobile      | `[UNVERIFIED]` | `decisions/2026-11-02-yard-ticket-gate-client-only-online-enforcement.md` (D12) | no               |

## 2. Requirements

### REQ-01 — Gate 1 on Day 1 Holdover: block start until Available for Dispatch `[UNVERIFIED]`

- **Statement:** On Day 1 of a holdover job (`holdover.dayNumber === 1`), an employee cannot start the ticket until the matching per-day Yard Operations job is marked Available for Dispatch for that ticket's shift.
- **Surface:** mobile, api
- **Acceptance:** When online and `!ticket.yardGate.available`, Day 1 holdover card shows "Pending" and pending message, Start Work button is hidden, and opening the ticket is blocked.
- **Edges:**
  - Reached by: Dashboard active tickets card, Jobs tab card, `handleOpenTicket`.
  - Does not apply when: Offline mode; ticket is already started (`startedWorkAt` / `IN_PROGRESS`); ticket is COMPLETE.

### REQ-02 — Gate 2 on Day 1 Holdover: block Left Yard & later until Complete Loadout `[UNVERIFIED]`

- **Statement:** On Day 1 of a holdover job, `leftYard` and all later required steps stay blocked until that shift completes Loadout in Yard Operations.
- **Surface:** mobile
- **Acceptance:** After Available for Dispatch but before Complete Loadout, `pretrip` is accessible; tapping `leftYard` or later steps shows toast warning and prevents navigation; step screen renders `YardGateLockedBody`. After Complete Loadout, `leftYard` and remaining steps unlock.

### REQ-03 — Gate 1 on Day 2+ Yard Start: block start until Available for Dispatch `[UNVERIFIED]`

- **Statement:** On Day 2 to End Day of a holdover job (`holdover.dayNumber >= 2`), if the employee starts from the Yard (`dayStartFrom === 'YARD'`), the ticket start is gated on Available for Dispatch.
- **Surface:** mobile, api
- **Resolved edge:** §12 Q1 = B and Q2 = B: before a Home/Yard choice, keep the dashboard card locked until Available for Dispatch; once available, Start Work may punch in before that choice. Named attribution is tracked separately in Q4.

### REQ-04 — Gate 2 on Day 2+ Yard Start: block Left Yard & later until Complete Loadout `[UNVERIFIED]`

- **Statement:** On Day 2 to End Day of a holdover job, if the employee starts from the Yard, `leftYard` and subsequent steps stay blocked until Complete Loadout is finished for that day's shift.
- **Surface:** mobile
- **Acceptance:** When `dayStartFrom === 'YARD'` and `!ticket.yardGate.loadedOut`, `leftYard` and later steps are blocked. Once loaded out, they unlock.

### REQ-05 — Home-Start Exemption on Day 2+ `[UNVERIFIED]`

- **Statement:** On Day 2 to End Day of a holdover job, if the employee starts from Home (`dayStartFrom === 'HOME'`), no yard gating is applied.
- **Surface:** mobile, api
- **Acceptance:** When `dayStartFrom === 'HOME'`, `isYardStartPending` and `isYardLeaveBlocked` evaluate to false regardless of `yardGate` values. Crew can start and navigate steps unhindered.

### REQ-06 — Expose `yardGate` in API read model for holdover tickets `[UNVERIFIED]`

- **Statement:** In `field-ticket.mapper.ts`, compute and include `yardGate: { available: boolean, loadedOut: boolean } | null` for holdover tickets when the sub-job has loadable assets/tools.
- **Surface:** api
- **Acceptance:** `GET /field/tickets` and `GET /field/tickets/:id` include `yardGate` for holdover tickets.

### REQ-07 — Client-only, online-only enforcement `[UNVERIFIED]`

- **Statement:** Enforce the gate client-side only while online, conforming to decision D12 (`2026-11-02-yard-ticket-gate-client-only-online-enforcement.md`). Offline actions queue locally and are not blocked.

## 3. Data model

- No schema change or migration required. `JobTicket.dayStartFrom` and `SubJobLoadout.loadoutCompletedShiftsAt` already exist.

## 4. API surface — `apps/api`

- In `apps/api/src/usecase/field-tickets/field-ticket.mapper.ts`:
  Update `yardGate` calculation:
  ```ts
  const isLoadable =
    buildLoadoutAssetCatalogEntries(jobResources).length > 0 || (job?.tools?.length ?? 0) > 0;
  const loadout = row.subJob?.loadout ?? null;
  // Previously: holdover === undefined && isLoadable
  // Now: include holdover tickets when isLoadable is true
  const yardGate = isLoadable
    ? {
        available: isShiftMarkedAvailable(loadout, shiftNumber ?? 1),
        loadedOut: isShiftLoadedOut(loadout, shiftNumber ?? 1),
      }
    : null;
  ```

## 5. Mobile surface — `apps/mobile`

- `apps/mobile/data/contracts/ticket.contract.ts`:
  Update `isYardStartPending` and `isYardLeaveBlocked` to take holdover into account:
  - If `ticket.holdover`:
    - Day 1 (`ticket.holdover.dayNumber === 1`): Standard yard gate logic applies.
    - Day 2+ (`ticket.holdover.dayNumber >= 2`):
      - If `dayStartFrom === 'HOME'`: return false (no gate).
      - If `dayStartFrom === 'YARD'`: apply standard yard gate logic.
      - If `dayStartFrom` is not yet chosen: see §12 Q1.
- `apps/mobile/app/(field)/ticket/index.tsx`:
  - When `onOpenStep` runs, evaluate `isYardGateLockedStep`.
- `apps/mobile/features/field-ticket/flow/ticket-step-screen.tsx`:
  - In `isYardGate2Locked`, holdover with Yard start is locked until `loadedOut`.

## 12. Open questions for the owner

### Q1 — How should the Dashboard / Jobs Tab card behave on Day 2+ before Home vs Yard is chosen?

- **Context:** On Day 2+, the employee has not yet answered "Where are you starting from?" (Home or Yard). If the yard has NOT marked Available for Dispatch:
- **Options:**
  - **A.** Do NOT lock the card on the dashboard before the choice is made. Tapping the card opens the ticket so the employee can choose "Home" or "Yard" in `HoldoverDayStartCard`. If they pick Home, they proceed without yard gating. If they pick Yard, Gate 1 and Gate 2 then lock until the yard completes the corresponding stage.
  - **B.** Lock the card on the dashboard whenever Available for Dispatch is pending (same as Day 1).
  - **C.** On Day 2+, clicking "Start Work" or tapping the card prompts "Starting from Home or Yard?" via a modal/sheet before starting work or applying the gate.
- **Answer:** **B — user/owner decision (2026-11-04)**. Lock the card on the dashboard until Available for Dispatch is completed (same as Day 1), even before the employee chooses Home or Yard. Once Available for Dispatch is completed, the card unlocks.
- **Status:** resolved

### Q2 — Should tapping "Start Work" directly from the dashboard card on Day 2+ be permitted before choosing Home vs Yard?

- **Context:** On Day 2+, tapping "Start Work" on the dashboard card currently punches in `startWork` before the employee opens the ticket to pick Home vs Yard.
- **Options:**
  - **A.** Require choosing Home or Yard first (by opening the ticket or prompting) before allowing 'Start Work' on Day 2+.
  - **B.** Allow tapping "Start Work" directly on the dashboard card; if they subsequently choose Yard inside the ticket, Gate 2 will still hold Left Yard until Loadout completes.
- **Answer:** **B — user/owner decision (2026-11-04)**. Allow tapping "Start Work" directly on the dashboard card once Available for Dispatch is marked; if they subsequently choose Yard inside the ticket, Gate 2 will still hold Left Yard until Loadout completes. If they choose Home, no Gate 2 is enforced.
- **Status:** resolved

### Q3 — API mapper payload strategy

- **Context:** Does the API send `yardGate` for all holdover days, letting mobile evaluate `dayStartFrom`?
- **Options:**
  - **A. (Recommended)** API sends `yardGate: { available, loadedOut }` for all holdover days when `isLoadable`. Mobile evaluates `isYardStartPending` and `isYardLeaveBlocked` against `dayNumber` and `effectiveDayStart` (which includes local optimistic choices).
  - **B.** API conditionally sets `yardGate: null` if `dayStartFrom === 'HOME'`.
- **Answer:** **A — API sends `yardGate` for all loadable holdover tickets.** Mobile evaluates `dayNumber` and `effectiveDayStart`: if Day 2+ and Home is chosen, mobile treats the ticket as ungated.
- **Status:** resolved

### Q4 — Named attribution for the captured Q1–Q3 answers (closeout follow-up)

- **Question:** Who approved Q1–Q3 on 2026-11-04, in which source conversation, and in what decision-making role?
- **Owner:** Ticket requester — provide the named decision maker and the original answer reference.
- **Context:** The existing capture identifies only “user/owner”; merge and local Git identities do not establish who gave the original answers. The answers remain resolved within this ticket, but `tcg-scrum` §8 requires a named human before recording a verified vault decision.
- **Status:** open — provenance follow-up; not an unimplemented requirement or a reopened Q1–Q3 product choice. No vault source or conflict status was changed at close.
