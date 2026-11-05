# Intent — HOLDOVER-YARD-GATE

> Captured 2026-11-04 from user request.
> Extends YARD-TICKET-GATE dependency flow to holdover tickets.

## 1. Ticket

| Field       | Value                                                                                            |
| ----------- | ------------------------------------------------------------------------------------------------ |
| Ticket      | `none` — slug `HOLDOVER-YARD-GATE`                                                               |
| Title       | Gate holdover employee tickets on Yard Operations (Day 1 always; Day 2+ when starting from Yard) |
| Type        | Story                                                                                            |
| Status      | INCEPTION                                                                                        |
| Epic        | `FIELD-OPS-TICKETING`                                                                            |
| Sprint      | `NOT ON TICKET`                                                                                  |
| Reporter    | user                                                                                             |
| Assignee    | Antigravity                                                                                      |
| Captured on | `2026-11-04`                                                                                     |
| Captured by | Antigravity                                                                                      |

## 2. Business intent

In the mobile app, non-holdover tickets filled online are currently gated on Yard Operations:

- Gate 1: Employee cannot start ticket until the per-day job is marked Available for Dispatch.
- Gate 2: Left Yard and later steps are blocked until Complete Loadout is finished in Yard Operations.

Holdover jobs (multi-day jobs) were temporarily exempted in `YARD-TICKET-GATE` (`yardGate: null`).
This ticket extends the same gating logic to holdover tickets when filled online:

- **Day 1**: The employee always leaves from the yard. Must be enforced identically to a standard ticket.
- **Day 2 to End Day (middle days & last day)**: The employee chooses between starting from Home or starting from Yard.
  - If **Yard**: Enforce the exact same gate flow (Available for Dispatch before Start; Complete Loadout before Left Yard and later steps).
  - If **Home**: No yard gating is enforced (the crew travels directly to site; there is no Left Yard step).

- Intent: Ensure crew members on holdover tickets do not dispatch from the yard prematurely before yard operations has staged and loaded out the equipment for that day.
- Who benefits: Yard Operations, Dispatch, and Field Crews.
- What is worse today without it: On holdover tickets, employees starting from the yard can start work and record leaving the yard before the yard team has completed loadout.

## 3. Definition of done, as the ticket states it

```
In mobile app, we have add this flow that for non holder over tickets when they are filled online then when employee is assigned a ticket then he cannot start the ticket until the that ticket per day job in yard operation has not completed the first stage available for dispatch

When first stage is completed then employee can see the start work button, then we block the left yard and future steps untill that per day job second stage is completed from yard operations

once second stage loadout is completed then we allow to process with the left yard and remaining steps.

Next, we need to implement this same flow for holdover tickets as well when they are filled online.
In mid days of hold over tickets, this should only get enforced if the ticket is started form the yard. If it is started from home then no need to enforce it. On first day of hold over job, we must enforce it as employee has to left from yard always.

from second day to end day of holdover job -> employee has 2 options -> start from home or yard. If yard then same enforcement is needed else no need
```

- Acceptance criteria present on the ticket: yes (in user statement).

## 4. In scope

- [ ] API mapper `field-ticket.mapper.ts`: expose `yardGate` for holdover tickets (Day 1, and Day 2+ when starting from Yard or when yard gate status is evaluated).
- [ ] Mobile contracts `ticket.contract.ts`: update `isYardStartPending`, `isYardLeaveBlocked`, and `isYardGateLockedStep` to evaluate holdover context and `dayStartFrom`.
- [ ] Mobile card treatment in `active-tickets-section.tsx` and `jobs.tsx`: enforce Gate 1 on Day 1 holdover cards; handle Day 2+ holdover cards where Home vs Yard may not yet be chosen.
- [ ] Mobile step gating in `ticket/index.tsx` and `ticket-step-screen.tsx`: gate `leftYard` and subsequent steps for holdover tickets starting from the Yard when `loadedOut` is false.
- [ ] Maintain Home start exemption: Day 2+ tickets starting from Home have no yard gate and are not blocked.
- [ ] Maintain offline exemption: Offline completion bypasses the gate as established in D11/D12.

## 5. Out of scope

- [ ] Non-holdover ticket flow (already implemented in `YARD-TICKET-GATE`).
- [ ] Server-side 409 guard on `recordTicketStep` (reversal D12 remains in effect: client-only, online-only).
- [ ] Changing the Yard Operations dashboard UI/modals (`apps/web`).
- [ ] Changing how `dayStartFrom` is chosen or stored on `JobTicket`.

## 6. Surfaces touched

| Surface           | Touched | What changes                                                                                                 |
| ----------------- | ------- | ------------------------------------------------------------------------------------------------------------ |
| `apps/api`        | yes     | `field-ticket.mapper.ts` sends `yardGate` for holdover tickets                                               |
| `apps/api/prisma` | no      | Schema already has `SubJobLoadout.loadoutCompletedShiftsAt` and `JobTicket.dayStartFrom`                     |
| `apps/web`        | no      | Web does not consume `yardGate`                                                                              |
| `apps/mobile`     | yes     | `ticket.contract.ts`, `active-tickets-section.tsx`, `jobs.tsx`, `ticket/index.tsx`, `ticket-step-screen.tsx` |
| `packages/shared` | no      | Shared step keys and holdover contracts already exist                                                        |

## 7. Entities and business codes

| Entity          | Code field   | This ticket…                                                |
| --------------- | ------------ | ----------------------------------------------------------- |
| `JobTicket`     | `ticketCode` | Reads `dayStartFrom`, `holdover`, and `subJob.loadout`      |
| `SubJobLoadout` | N/A          | Reads `markedAvailableShiftsAt`, `loadoutCompletedShiftsAt` |

- New entity introduced: no
- New code prefix introduced: no
- Existing rows affected: no

## 8. Roles and permissions

- Standard field crew roles (Oiler, Operator, Secondary crew).
- Tenant isolation: standard; no new queries.

## 9. Designs and references

| Kind              | Reference                                                                                                                                                                                                            |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Related tickets   | `YARD-TICKET-GATE` (`.ai/aidlc/YARD-TICKET-GATE/`)                                                                                                                                                                   |
| Related decisions | `.ai/vault/decisions/2026-11-02-yard-ticket-gate-stage-scope-and-card-lock.md`, `2026-11-02-yard-ticket-gate-client-only-online-enforcement.md`, `2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md` |

## 10. Terms used

- `holdover`: Multi-day job where equipment or crew is held on-site across days.
- `Available for Dispatch`: First stage in yard operations (`markAvailable`).
- `Complete Loadout`: Second stage in yard operations (`completeLoadout`).
- `dayStartFrom`: Home vs Yard choice on holdover Day 2+.

## 11. Numbers, thresholds and enumerated values

| Value  | Where the ticket says it came from                  |
| ------ | --------------------------------------------------- |
| Day 1  | Always starts from Yard; always enforced            |
| Day 2+ | Choice between Home and Yard; enforced only if Yard |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 2 (Sprint, Design handoff)
- Fields left as `OPEN`: 0 in intent; 3 design questions raised for elaboration/user clarification.
- Is this ticket buildable without a product answer? Needs user confirmation on Day 2+ pre-choice card behavior.
