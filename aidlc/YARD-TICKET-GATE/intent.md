# Intent — YARD-TICKET-GATE

> Retrofitted intent. No Jira ticket was opened; the work came in as a prose request. Captured
> here so the AI-DLC overlay matches what was built.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `none` — descriptive slug `YARD-TICKET-GATE` |
| Title | Make an employee ticket depend on its per-day Yard Operations progress |
| Type | Story |
| Status | In progress (built, pre-review) |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | syedharis14@gmail.com |
| Assignee | Haris |
| Captured on | `2026-11-02` |
| Captured by | AI (retrofit) |

## 2. Business intent

- Intent: the yard, not the crew, controls when a non-holdover ticket can start. A per-day job
  in DAS mirrors into Yard Operations; the crane and tools are physically in the yard until the
  Yard Manager releases them. Starting the employee ticket (and leaving the yard) before the
  yard is ready produces a ticket whose timeline the yard never authorised.
- Who benefits (role): field crew, Yard Manager, dispatch, accounting (clean timelines).
- What is worse today without it: employees can tap **Start Work** and run the whole flow
  regardless of Yard Operations state, so a ticket can leave the yard before the yard dispatched it.

## 3. Definition of done, as the request states it

```
For non-holdover jobs/tickets, an employee may only start a ticket after the corresponding
per-day Yard Operations job has completed its first required stage and is marked
"Available for Dispatch". Until then the card reuses the future-ticket treatment but shows:
  "Ticket start is pending until the Yard Operation is marked Available for Dispatch."
A second dependency: the "Left Yard" step and all subsequent required steps stay blocked
until the second Yard Operations stage (Load Out / Start Load Out — confirm exact name)
completes. This applies ONLY to non-holdover jobs and tickets; holdover workflows unchanged.
```

- Acceptance criteria present on the ticket: yes (prose request)

## 4. In scope

- [x] Gate 1: block starting a non-holdover ticket until its shift is marked Available for Dispatch.
- [x] Gate 2: block `leftYard` and later steps until that shift completes Loadout.
- [x] Reuse the future-ticket card treatment with a gate-specific message.
- [x] Enforce on both mobile (UI) and API (step-punch guard).

## 5. Out of scope

- [x] Holdover jobs/tickets — behaviour unchanged.
- [x] Any change to the Yard Operations screens themselves (they already mark available / complete loadout).
- [x] Real-time push when the yard releases a job — mobile picks it up on next fetch.
- [x] Offload / return-to-yard dependency — only the first two yard stages gate the ticket.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (presentation / usecase / service) | yes | mapper exposes `yardGate`; `recordTicketStep` guard; repo reads |
| `apps/api/prisma` (schema + migration) | yes | additive `loadout_completed_shifts_at` JSONB on `sub_job_loadouts` |
| `apps/web` | no | — |
| `apps/mobile` | yes | card gate 1, step-screen gate 2, contract type + selectors |
| `packages/shared` | no | gate order read from existing `ALL_TICKET_FLOW_STEP_KEYS` |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `SubJobLoadout` | none (one-to-one child of `SubJob`) | adds one nullable column |
| `JobTicket` | `ticketCode` | reads (gate), no change |

- New entity introduced: no
- New code prefix introduced: no
- Existing rows affected (data backfill): no — column is nullable, legacy rows read via fallback

## 8. Roles and permissions

- Roles that can perform this: unchanged — the signed-in field employee on the ticket roster.
- Roles explicitly excluded: unchanged.
- Tenant scope: standard per-tenant isolation; `SubJobLoadout` inherits it through `SubJob`.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` — reuses the existing future-ticket card |
| Related tickets | `TICKET-FLOW-SLOTS-HOLDOVER` (holdover flow), `SCRUM-LOADOUT-UNASSIGNED` (yard loadout) |
| Vault area | `dispatch/` (DAS + yard operations), `field-ops/` (mobile ticket flow) |

## 10. Terms used that may not be defined

- `das` — the Daily Assignment Sheet; the per-day job lives here and mirrors to Yard Operations.
- `loadout` — the yard's act of loading a per-day job's assets/tools for dispatch.
- Available for Dispatch — UI action label `Mark Available for Dispatch`; sets `markedAvailableAt`.

## 11. Numbers, thresholds and enumerated values on the request

| Value | Where it came from |
| --- | --- |
| Gate 2 = Complete Loadout | owner decision 2026-11-02 (second yard stage confirmed from code) |
| Shift scope = per-shift | owner decision 2026-11-02 |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: epic, sprint, design handoff.
- Fields left as `OPEN`: none — the four build-shaping questions were answered by the owner on
  2026-11-02 (see `spec.md` §12).
- Is this buildable without a product answer? yes, after the four §12 answers.

---

**Next step:** `spec.md` beside this file (retrofitted from the same decisions).
