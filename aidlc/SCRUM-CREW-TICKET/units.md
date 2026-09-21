# Units — SCRUM-CREW-TICKET One ticket per asset group — Oiler primary, Operator on the same ticket

> Written to `.ai/aidlc/SCRUM-CREW-TICKET/units.md` from the approved `spec.md` beside it.
> Consumed by the decomposer and then by an executor, one unit at a time.

## What a unit is

A unit is a **vertical shippable slice**: schema → API → web and/or mobile → tests, for one
piece of behavior. It is reviewable on its own and it demonstrates something a person can
see working.

A unit is **not** a layer. "Add the Prisma model", "write the endpoints", "build the UI"
are three-eighths of a feature each, and none of them can be reviewed against the spec —
the reviewer has nothing to check the schema against until the UI exists, by which point
all three are in flight. Layer splits also hide integration failures until the last merge,
which is exactly when they cost the most.

**The test:** if the unit ships alone, what can someone do that they could not do before?
If the answer is "nothing, it's the backend half", it is not a unit. Merge it into the
slice it serves.

Legitimate exceptions, and they are narrow:

- A **schema-only foundation unit** when three or more later units all depend on one
  migration and splitting it per-unit would mean three migrations against the same table.
  Mark it `kind: foundation` and say which units consume it.
- A **shared-types unit** in `packages/shared` under the same condition.

Everything else is vertical. **This ticket's schema change (`ticket_employees`, dropping
`primaryTicketId`, the live-pair-collapse + COMPLETE backfill migration) is explicitly not
filed as a foundation unit** — four later units (U2–U5) do consume it, but none of them
needs its *own* copy of the migration; more importantly, the schema change has an
immediately demonstrable vertical slice of its own (one ticket minted per crew set instead
of two, visible on the Oiler's mobile ticket), so it ships as U1, an ordinary vertical unit
that happens to carry a large migration — not a schema-only stub nobody can review against
the spec until U2 exists.

## Fill rules

Every field is required per unit. **Never delete a field.** Unfilled fields take
`NOT SPECIFIED`, `N/A — <reason>`, or `OPEN — <question>`, as in `spec.md`.

A unit may not depend on an `[OPEN]` requirement. If it does, either the question gets
answered first or the unit is cut down to the part that does not depend on it — and the
cut is recorded in *Deliberately not in this unit*.

An `[UNVERIFIED]` requirement is different and much weaker: it **does not** block a unit.
Almost every requirement carries it. It constrains *how* the unit is built, not whether —
see **Risk** below.

**Every unit in this ticket, before being marked done:** run
`grep -rln "primaryTicketId\|linkCrewTickets" apps/ packages/ qa-automation/` and confirm the
result matches what this unit's Ripple table expects to still be present (files not yet
converted, owned by a later unit) versus what should now be gone (files this unit owns). The
full known set at spec time (`spec.md` §11a row 2) is: `ticket-time-entries.repository.ts`,
`job-progress.repository.ts`, `job-tickets.repository.ts`, `job-progress.service.ts`,
`job-tickets.service.spec.ts`, `job-tickets.service.ts`, `field-ticket.mapper.spec.ts`,
`field-ticket.mapper.ts`, `apps/mobile/components/field/ticket-card.test.tsx`,
`apps/mobile/data/contracts/ticket.contract.ts`. The crew-copy code being removed
specifically lives in `job-tickets.service.ts` (`linkCrewTickets`, the
`getTicketForEmployeeAction` write refusal keyed on `primaryTicketId`), `field-ticket.mapper.ts`,
`apps/mobile/components/field/crew-ticket-banner.tsx`, and PR #568's progress-tracking copy
handling (`apps/web/src/features/ticket-progress/` reading `ticket.primaryTicket ?? ticket`) —
do not declare a unit done while any of these still reference the retired shape within that
unit's own surface.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | One `JobTicket` per crew set instead of two; Oiler's mobile ticket shows both crew members; live pairs migrated, COMPLETE pairs backfilled, `primaryTicketId`/`linkCrewTickets` retired | REQ-01, REQ-02, REQ-03, REQ-05 (display only), REQ-09, REQ-10, REQ-12, REQ-13, REQ-14 (schema), REQ-15, REQ-17 | schema, api, mobile, shared | — | L | built, unmerged — feat/SCRUM-CREW-TICKET-one-ticket-per-crew |
| U2 | Oiler enters Labor & Unit / time for each crew member on the one ticket; payroll prices each employee's own line | REQ-04, REQ-05 (entry), REQ-11, REQ-14 (api) | api, schema, mobile, shared | U1 | L | built, unmerged — feat/SCRUM-CREW-TICKET-one-ticket-per-crew |
| U3 | Operator's mobile Jobs/Home shows "On \<Oiler\>'s ticket" with step status only — the PR #561 crew-copy banner and hand-off flow are gone | REQ-06, REQ-16 | mobile, api | U1 | M | built, unmerged — feat/SCRUM-CREW-TICKET-one-ticket-per-crew |
| U4 | Web Job/Progress Tracking shows one card per ticket with every employee listed and the primary marked — no copy rows | REQ-07 | web, shared | U1 | M | built, unmerged — feat/SCRUM-CREW-TICKET-one-ticket-per-crew |
| U5 | DAS/dispatch ticket-listing views (Confirm & Send Tickets, etc.) show one row per asset group with the ticket's employees listed | REQ-08 | web, api | U1 | S | built, unmerged — feat/SCRUM-CREW-TICKET-one-ticket-per-crew |

- Requirements not covered by any unit: **none** — all 17 requirements are placed. (REQ-05 and
  REQ-14 are each split across two units; see their unit entries for which part goes where.)
- Units blocked on an open question: **none** — Q5 (§12, non-blocking) is not depended on by
  any unit; REQ-16 (U3) ships its status-only default regardless of how Q5 is later answered.

---

## U1 — One ticket per crew set; `ticket_employees`; retire `primaryTicketId`

- **Outcome:** A dispatcher/DAS action against an Oiler+Operator crane set now mints exactly
  one `JobTicket` (the Oiler's), not two; the Oiler's mobile ticket screen shows both crew
  members with the Oiler marked primary; every existing PENDING/SENT/IN_PROGRESS linked pair
  is collapsed into this shape and every COMPLETE ticket (paired or not) is backfilled with
  its own `ticket_employees` row; `primaryTicketId` and `linkCrewTickets` no longer exist in
  the code. This is the first thing a reviewer can see working, and it proves the riskiest
  part of the whole plan — the migration — before anything else is built on top of it.
- **Kind:** vertical (see *What a unit is* above for why this is not filed as `foundation`
  despite carrying the ticket's one large migration)
- **Requirements covered:**
  - REQ-01 — fully
  - REQ-02 — fully
  - REQ-03 — fully (write refusal moves from `primaryTicketId` presence to
    `ticket_employees.isPrimary`; read of own crew ticket succeeds)
  - REQ-05 — **partly**: the Oiler's Labor step shows both crew cards (roster read). Entering
    time/Labor & Unit data for each member is **not** in this unit — see U2.
  - REQ-09 — fully
  - REQ-10 — fully
  - REQ-12 — fully (no behavior change; this unit's tests confirm support-load cardinality is
    unaffected by the uniform `ticket_employees` shape)
  - REQ-13 — fully
  - REQ-14 — **partly**: the schema shape (`TicketEmployee` carries the four Labor & Unit
    fields, `TicketTimeEntry` stays untouched). The API-side behavior change
    (`resolveTargetTicket` resolving to a same-ticket row) is U2.
  - REQ-15 — fully
  - REQ-17 — fully
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New `TicketEmployee` model (name to be confirmed by the executor against the `Ticket<Noun>` convention, per REQ-13's note) per spec.md §3's exact field list: `id`, `tenantCompanyId`, `jobTicketId`, `employeeId`, `isPrimary`, `craftModifierBracket`, `craftModifierId`, `laborComments`, `laborCapturedByUserId`, `createdAt`, `updatedAt`. `@@unique([jobTicketId, employeeId])`; partial unique index `(jobTicketId) WHERE is_primary` via raw SQL in the migration (Prisma cannot express it, same pattern as `uq_job_tickets_active_allocation`); `@@index([tenantCompanyId, jobTicketId])`. Drop `JobTicket.employeeId`, `craftModifierBracket`, `craftModifierId`, `laborComments`, `laborCapturedByUserId`, `primaryTicketId` (and its FK/constraint). Confirm `TicketEmployee` against the tenant-scoping client extension's allowlist (`.ai/claude/contexts/prisma.md`) and add it unless a `TicketTimeEntry`-style cross-employee-write exception applies (flag for `tcg-prisma-guardian` either way, per spec.md §8). **One committed migration** under `apps/api/prisma/migrations/`, containing: the DDL above, the data migration (REQ-10: for every PENDING/SENT/IN_PROGRESS linked pair — grouped `(sub_job_id, set_resource_id, shift_number)`, matching the superseded `20260912120000_add_job_ticket_primary_ticket` migration's own grouping key — create the Operator's `ticket_employees` row on the Oiler's ticket carrying the Operator ticket's own Labor & Unit fields, then cancel the Operator's ticket under existing reassignment-cancel semantics), and the backfill (REQ-15: every remaining ticket, including COMPLETE ones and COMPLETE pairs which are **not** collapsed, gets its own single `isPrimary=true` `ticket_employees` row from its former `employeeId`/Labor fields) — **run the backfill before dropping the source columns, in the same migration**. | Precedent migration to read before writing this one: `apps/api/prisma/migrations/20260912120000_add_job_ticket_primary_ticket/migration.sql`. **Not reversible** — see Risk. |
| API (`apps/api`) | `job-tickets.service.ts`: `ensureTickets`/`sendTickets`/`reassignTicket` — within one `(subJobId, setResourceId, shiftNumber)`, once an Oiler-seated allocation is found (reuse `seatOf`/`OILER_TYPE_NAME`/`OPERATOR_TYPE_NAME` from `packages/shared/src/constants/employee-types.ts`), mint the ticket for the Oiler's allocation only and create/absorb the Operator's allocation as a second `ticket_employees` row instead of minting a ticket for it; every other allocation (Operator with no Oiler seat, Third Man, support/counterweight drivers) still mints its own ticket exactly as today. Retire `linkCrewTickets` entirely. `listMyTickets`/`getTicketForEmployeeAction`/`toTicketDto`: resolve "tickets this employee is on" and write/read authorization from `ticket_employees` membership (`isPrimary` gates write) instead of `JobTicket.employeeId`/`primaryTicketId` — this is the read-path change every later unit (U2–U5) builds on. `ticket-labor-entries.service.ts` `getCrewForTicket`: becomes a same-ticket query over `ticket_employees` instead of a cross-ticket query (crew-card-list *shape* stays the same per REQ-05's notes; only its data source changes — full entry-write wiring is U2). | Do not change `RecordTicketLaborEntryDto`/`resolveTargetTicket`'s write-resolution target in this unit — that is U2's slice, even though `getCrewForTicket`'s read side moves here. |
| Web (`apps/web`) | none required by this unit itself (U4, U5 depend on it but are separate units) | — |
| Mobile (`apps/mobile`) | `apps/mobile/app/(field)/ticket/step/[key].tsx`: `crew={laborCrewQuery.data ?? []}` now renders from the new same-ticket `getCrewForTicket` response — rendering contract may not need to change (spec.md REQ-05 note), but confirm against the new response shape. Read-only for this unit: no new entry controls. | `apps/mobile/data/compose-ticket-detail.ts`'s 14-step/9-step `getVisibleSteps` gating is explicitly unchanged (intent §5) — do not touch it here. |
| Shared (`packages/shared`) | `FieldTicket.crewTicket`'s `{ role: 'PRIMARY' \| 'SECONDARY' }` discriminated shape (`field-ticket.mapper.ts`) is retired, replaced by `employees: [{ employeeId, name, isPrimary }]` (REQ-06's notes; labor-field additions to this shape are U2's, not this unit's — keep it roster-only here). `apps/mobile/data/contracts/ticket.contract.ts`'s Zod `primaryTicketId: z.string()` field is dropped. | **Run `tcg-contract-tracer`** — this is the exact kind of `packages/shared` export change intent.md §6 flags it for; mobile is a confirmed consumer (`ticket-card.tsx`, `ticket/step/[key].tsx`), web is not (Progress Tracking's own type change is U4's). |
| Tests | Unit: seat/primary-derivation logic (REQ-02) — replaces/updates `job-tickets.service.spec.ts`'s existing `linkCrewTickets`-era assertions, does not just add new ones alongside them. Unit: `getTicketForEmployeeAction`-equivalent write-refusal for a non-primary employee (REQ-03) — same file, same treatment. Unit: `field-ticket.mapper.spec.ts` updated for the `employees[]` shape, replacing its `role: PRIMARY/SECONDARY` assertions. Mobile: `apps/mobile/components/field/ticket-card.test.tsx` updated for the new crew-card data source. Integration (API): a sub-job with an Oiler+Operator crane set and two support loads yields exactly 3 `JobTicket` rows, never 4, and the crane ticket's `allocationId` is the Oiler's own (REQ-01). Migration test: seeded PENDING/SENT/IN_PROGRESS linked pairs collapse into one ticket + a `ticket_employees` row, Operator ticket `CANCELLED`, Labor & Unit fields carried over; seeded COMPLETE pairs are untouched (both rows remain) and each gets its own `isPrimary=true` row; a support-load ticket (single allocation, no set) is unaffected and gets exactly one `isPrimary=true` row (REQ-10, REQ-12, REQ-15). | These are the regression rows for §11a row 2's consumer list — see Ripple below. |

### Reviewable as

- **Demo:** seed a sub-job with an Oiler+Operator crane set, run `ensureTickets`; exactly one
  `JobTicket` exists for the set, with a `ticket_employees` row for each of the Oiler
  (`isPrimary=true`) and the Operator (`isPrimary=false`). On the mobile app as the Oiler,
  open the ticket's Labor step and see both crew members listed.
- **Acceptance:** REQ-01, REQ-02, REQ-03, REQ-09, REQ-10, REQ-12, REQ-13, REQ-15, REQ-17's
  acceptance lines in full; REQ-05's acceptance line for the "both crew cards visible" half
  only; REQ-14's acceptance line for the schema-shape half only (no `employeeId` on
  `TicketTimeEntry`, a `ticket_employees` row's Labor & Unit fields independently readable
  per employee).
- **Reviewer can verify without:** U2 (no Labor/Unit entry needed to see the roster), U3, U4,
  U5 — this unit is self-contained end to end on the Oiler's own screen.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-05's display-only slice (`SCRUM-CREW-TICKET/intent.md`
  §4) is the weakest tag this unit carries; every schema/migration requirement it covers
  (REQ-01, 02, 03, 09, 10, 13, 15, 17) is `[VERIFIED]` from the two decision notes. The
  `[UNVERIFIED]` piece (exact mobile screen layout) is **not** the piece that is irreversible —
  the irreversible migration is fully `[VERIFIED]`-sourced — so the §2b raise-before-build rule
  does not trigger here; flagged for completeness, not as a blocker.
- **Migration reversible:** **no.** Dropping `JobTicket.employeeId`/Labor-field columns and
  `primaryTicketId`, and cancelling the Operator's former ticket rows, cannot be undone without
  a separate hand-written down-migration that reconstructs which `ticket_employees` rows came
  from which now-cancelled ticket — and once new labor entries land on those rows (U2), that
  reconstruction is lossy. Treat this migration as one-way in practice.
- **Behind a flag:** no — `NOT SPECIFIED` by any source; not proposed here, since minting
  behavior and read paths change together and a flag would need to gate both sides of every
  ticket-creating and ticket-reading code path at once.
- **Touches existing data:** yes — every live PENDING/SENT/IN_PROGRESS linked pair, every
  COMPLETE ticket (paired or not), and every `JobTicket` row's `employeeId`/Labor-field columns.
  Run the migration against a production-shaped snapshot before shipping; confirm the
  `(sub_job_id, set_resource_id, shift_number)` grouping key actually matches every live pair
  1:1 (it is the same key the superseded migration used, but that migration's own backfill is
  the only precedent, not an independent verification).
- **Blast radius:** every ticket-minting and ticket-reading code path in the system
  (`ensureTickets`, `sendTickets`, `reassignTicket`, `listMyTickets`, `getTicketForEmployeeAction`,
  every `primaryTicketId`/`linkCrewTickets` consumer in §11a row 2) plus payroll's read of
  `ticket.employee` (U2 depends on this unit's schema; a wrong migration here corrupts U2's
  starting data). This is the highest-blast-radius unit in the ticket.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `job-tickets.service.ts` (`ensureTickets`, `sendTickets`, `reassignTicket`, `listMyTickets`, `getTicketForEmployeeAction`, `toTicketDto`) | one-ticket-per-allocation minting/reading | `job-tickets.service.spec.ts` updated (not just added to) for the new grouping/absorption logic | `spec.md` REQ-01, REQ-02, REQ-06 / §11a row 1 |
| `linkCrewTickets` retirement — `ticket-time-entries.repository.ts`, `job-progress.repository.ts`, `job-tickets.repository.ts`, `job-progress.service.ts` | shared self-FK + mirroring mechanism | repository/service query updates confirmed via `job-tickets.service.spec.ts` and existing job-progress test coverage — **NOT SPECIFIED which job-progress test file exercises this today; executor locates it via `grep -rln "primaryTicketId" apps/api/src` before declaring this row done** | `spec.md` REQ-09 / §11a row 2 |
| `field-ticket.mapper.ts` (`{role: PRIMARY\|SECONDARY}` shape) | shared type consumed by mobile | `field-ticket.mapper.spec.ts` updated for the `employees[]` shape | `spec.md` REQ-06 notes / §11a row 2 |
| `apps/mobile/components/field/ticket-card.test.tsx` | mobile component consuming the old shape | test file updated for `employees[]` | `spec.md` §11a row 2 |
| `apps/mobile/data/contracts/ticket.contract.ts` (Zod `primaryTicketId`) | mobile runtime contract validation | contract updated; any mobile contract test suite that exercises it re-run — **NOT SPECIFIED whether a dedicated test file exists; confirm via `grep -rln "ticket.contract" apps/mobile`** | `spec.md` REQ-09 / §11a row 2 |
| `apps/api/prisma/migrations/20260912120000_add_job_ticket_primary_ticket/migration.sql` | grouping-key precedent, not a live consumer | migration test asserts the new migration's grouping key produces the same pairing the old one did against live-status tickets | `spec.md` REQ-10 / §11a row 3 |
| Every `primaryTicketId`/`linkCrewTickets` consumer, full list | — | `git grep -n "primaryTicketId\|linkCrewTickets" apps/` returns nothing outside historical migration files, per REQ-09's acceptance line — run this grep before closing the unit | `spec.md` REQ-09 acceptance line |

### Deliberately not in this unit

- Entering Labor & Unit data / time for a crew member (REQ-05's entry half), and
  `RecordTicketLaborEntryDto`/`resolveTargetTicket`'s write-target change (REQ-04, REQ-14's
  api half) — lands in U2. This unit's `getCrewForTicket` change is read-only.
- Payroll's `buildJobDay` per-ticket-employee change and `PayrollJobDay`'s widened unique key
  (REQ-11) — lands in U2. This unit's migration does not touch `PayrollJobDay`.
- The Operator's mobile "On \<Oiler\>'s ticket" labeling, status-only rendering, and the
  crew-copy banner/CTA removal (REQ-06, REQ-16) — lands in U3. This unit changes the API read
  paths those screens will consume but does not touch `crew-ticket-banner.tsx`,
  `jobs.tsx`/`field.tsx`, or `ticket/index.tsx`'s `crewCopy` logic itself.
- Web Progress Tracking's one-row-per-ticket rendering (REQ-07) — lands in U4.
- DAS/dispatch listing views' one-row-per-asset-group rendering (REQ-08) — lands in U5. Note:
  the underlying "only the primary's allocation gets a ticket, so only the primary is sent to
  and accepts" behavior is a direct consequence of this unit's `ensureTickets`/`sendTickets`
  change — U5 only needs to update the *display*, not re-derive this mechanism.

---

## U2 — Oiler enters per-employee Labor & Unit and time; payroll prices per ticket-employee

- **Outcome:** The Oiler, on the one ticket, can submit a Labor & Unit entry targeted at any
  crew member (including themselves), and it is stored and read back as that employee's own
  entry; a payroll run against a two-employee ticket produces two priced `PayrollJobDay`
  lines, one per employee, instead of one.
- **Kind:** vertical
- **Requirements covered:**
  - REQ-04 — fully
  - REQ-05 — **partly**: the entry half (time/Labor & Unit data entry per crew member). The
    display half (both crew cards visible) is U1's.
  - REQ-11 — fully
  - REQ-14 — **partly**: the API-side behavior (`resolveTargetTicket` resolving to a
    same-ticket `ticket_employees` row). The schema shape is U1's.
- **Depends on:** U1 (needs the `ticket_employees` table, the Oiler-anchored ticket shape, and
  the migrated/backfilled data to price against)

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `PayrollJobDay`'s unique key `@@unique([runId, jobTicketId])` widens to `(runId, jobTicketId, employeeId)` or equivalent (decision Q1 point 5). **Backfill `employeeId` on every existing `PayrollJobDay` row before applying the widened constraint** — join through the ticket's single `ticket_employees` row (guaranteed to exist and be unambiguous by U1's REQ-15 backfill, since no COMPLETE ticket is collapsed and every ticket has exactly one row unless it is a two-employee crew ticket created *after* this migration). One committed migration. | **Flag for `tcg-prisma-guardian`** — widening a `@@unique` on a priced, financial table, per the decision note's own instruction. |
| API (`apps/api`) | `ticket-labor-entries.service.ts` `resolveTargetTicket` (line 584 in the pre-change code): change its resolution target from "the target employee's own separate ticket" to "the target employee's own `ticket_employees` row on this ticket," authorized via `setResourceId` as today — `RecordTicketLaborEntryDto.targetEmployeeId`'s shape is unchanged (REQ-04 notes). `payroll.service.ts` `buildJobDay` (line 779, currently reads `const employee = ticket.employee`) iterates `ticket.ticketEmployees` and produces one `PayrollJobDay` row per entry, each keyed `(runId, jobTicketId, employeeId)`. `ticket-time-entries.service.ts`: confirm no change needed (`TicketTimeEntry` stays per-ticket, unchanged, per REQ-14) beyond whatever type updates the widened schema forces. | Reuse the existing Oiler-picks-target-employee mechanism unchanged — only its resolution target moves. |
| Web (`apps/web`) | N/A — no web surface for Labor & Unit entry (spec.md §5) | |
| Mobile (`apps/mobile`) | Wire the Oiler's Labor step entry controls (per-crew-card submit, reusing the existing crew-card-list UI from U1) to the updated `recordEntry`/`targetEmployeeId` endpoint. | Reuse existing entry UI pattern — this is a wiring change (new target resolution), not a new screen. |
| Shared (`packages/shared`) | If the `employees[]` shape U1 introduced needs the four Labor & Unit fields exposed per member for the entry UI to read current values, add them here (`craftModifierBracket`, `craftModifierId`, `laborComments`, `laborCapturedByUserId` per employee). `NOT SPECIFIED` whether this rides on the same `FieldTicket.crewTicket.employees[]` type or a separate labor-entry response — executor's call within the settled data model, per spec.md §7. | **Run `tcg-contract-tracer`** if this shape changes again after U1 already ran it — confirm mobile is the only consumer before assuming a single pass suffices. |
| Tests | Unit: `resolveTargetTicket`-equivalent same-ticket labor targeting (REQ-04). Integration (API): Oiler submits a Labor & Unit entry with `targetEmployeeId` set to the Operator's employee id; it is stored and readable as the Operator's own entry, not the Oiler's (REQ-04 acceptance). Integration (API): a payroll run against a two-employee ticket yields two `PayrollJobDay` rows, each keyed `(runId, jobTicketId, employeeId)`, priced from that employee's own time/labor data (REQ-11 acceptance). Migration test: existing single-employee `PayrollJobDay` rows correctly backfill `employeeId` and remain unique under the widened key; no existing row moves or collides (REQ-11 notes, REQ-15's "already-priced runs untouched" guarantee carried forward). E2E / manual script: mobile Oiler sees two crew cards and can enter each one's time (REQ-05 full acceptance, combined with U1's display half). | |

### Reviewable as

- **Demo:** as the Oiler on a seeded two-employee crew ticket, submit a Labor & Unit entry for
  the Operator via `targetEmployeeId`; `GET` the ticket and see it under the Operator's
  `ticket_employees` row. Run a payroll job against the same ticket; see two `PayrollJobDay`
  rows.
- **Acceptance:** REQ-04, REQ-11's acceptance lines in full; REQ-05's acceptance line in full
  (combined with U1); REQ-14's acceptance line's second half (a `ticket_employees` row's Labor
  & Unit fields independently readable/writable per employee).
- **Reviewer can verify without:** U3, U4, U5 — payroll pricing and labor entry do not depend
  on the Operator's own mobile view or either web listing.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-05's entry-half source is `intent.md` §4 only; REQ-04,
  REQ-11, REQ-14(api) are all `[VERIFIED]`. The `PayrollJobDay` migration (the irreversible
  piece) rests on the `[VERIFIED]` decision, not the `[UNVERIFIED]` piece, so the §2b
  raise-before-build combination does not apply — same reasoning as U1.
- **Migration reversible:** **no** — once a two-employee ticket has been priced under the
  widened key, narrowing `PayrollJobDay`'s unique constraint back to `(runId, jobTicketId)`
  alone would collide on any ticket with more than one priced employee row.
- **Behind a flag:** no — `NOT SPECIFIED`, not proposed.
- **Touches existing data:** yes — every existing `PayrollJobDay` row gets a backfilled
  `employeeId`. This is the second `[UNVERIFIED]`-adjacent-but-actually-`[VERIFIED]`-sourced
  irreversible migration in this ticket; treat the backfill join (through U1's guaranteed
  single `ticket_employees` row per pre-existing ticket) as the thing to verify against a
  real snapshot before shipping, same as U1's migration.
- **Blast radius:** payroll export and weekly payroll calculation for every tenant — a wrong
  `buildJobDay` change either under- or double-prices labor. This is a money-correctness
  surface; the `tcg-prisma-guardian` flag on the schema change is necessary but not
  sufficient — the `buildJobDay` iteration logic itself needs careful review too.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `PayrollJobDay` (`@@unique([runId, jobTicketId])`) + `payroll.service.ts` `buildJobDay`/`calculatePayPeriod` | one-ticket-per-employee pricing assumption | payroll integration test: two-employee ticket → two priced rows; existing single-employee payroll test coverage re-run under the widened key and must still pass unchanged | `spec.md` REQ-11 / §11a row 4 |
| `ticket-labor-entries.service.ts` (`resolveTargetTicket`, `getTicketWorkTimes`, `composeEntry`), `field-ticket.mapper.ts` (`toTimeTracking`) | `TicketTimeEntry` + `JobTicket`-level Labor & Unit fields | `resolveTargetTicket` unit test updated for same-ticket resolution, replacing its cross-ticket assertions | `spec.md` REQ-04, REQ-14 / §11a row 5 |
| `RecordTicketLaborEntryDto.targetEmployeeId` / `resolveTargetTicket`'s cross-**ticket** resolution | Oiler-enters-for-teammate mechanism | integration test above (Operator's entry stored under Operator's own `ticket_employees` row) | `spec.md` REQ-04 / §11a row 9 |

### Deliberately not in this unit

- The `TicketEmployee` schema itself and the migration that populates it — U1's, already
  shipped and depended on here.
- Per-employee start/end time overrides — explicitly `NOT SPECIFIED`/not decided (decision Q1
  point 7); build only if existing labor-hours code already supports the concept, per REQ-14's
  notes. Not attempted in this unit.

---

## U3 — Operator's mobile view: "On \<Oiler\>'s ticket", status only

- **Outcome:** An Operator on a crew ticket sees exactly one entry in their mobile Jobs list
  for that day, labeled "On \<Oiler name\>'s ticket," showing progress/step status only — no
  "View ticket" hand-off, no signatures/checklists/comments, no accept. The PR #561 crew-copy
  banner and CTA no longer exist.
- **Kind:** vertical
- **Requirements covered:** REQ-06 (fully), REQ-16 (fully)
- **Depends on:** U1 (needs `listMyTickets`/`getTicketForEmployeeAction` already resolving
  ticket membership via `ticket_employees` rather than `JobTicket.employeeId`)

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — no schema change in this unit | — |
| API (`apps/api`) | `getTicketForEmployeeAction`'s read path for a non-primary `ticket_employees` row: return progress/step status only (no signature images, checklist results, comment thread, punch-in/accept control) — REQ-16's status-only default. `NOT SPECIFIED` whether this is enforced by filtering the API response or left to the mobile client to not render fields it receives; either satisfies the requirement as written, but filtering server-side is the safer default for a read-only role and is the recommended executor choice — document whichever is chosen. | Do not build toward Q5 (richer view) — ship exactly the status-only default (REQ-16 notes). |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | Retire `apps/mobile/components/field/crew-ticket-banner.tsx` (PR #561, merged 2026-09-12) and its *View ticket* CTA. `apps/mobile/app/(field)/jobs.tsx`, `field.tsx`: render the crew ticket as "On \<Oiler name\>'s ticket" with progress/step status only, sourced from the new `employees[]`/`isPrimary` shape (U1) instead of `crewTicket.role === 'SECONDARY'`. `apps/mobile/app/(field)/ticket/index.tsx`: retire the `crewCopy`/`isReadOnlyTicket` branch built on `primaryTicketId`; the Operator's own crew-ticket view renders status-only directly rather than as a "read-only copy" of a separate ticket. | This is the unit that actually deletes `crew-ticket-banner.tsx` — confirm no other surface still imports it (`grep -rln "crew-ticket-banner" apps/mobile`) before removing the file. |
| Shared (`packages/shared`) | none beyond what U1 already introduced — this unit consumes `employees[]`/`isPrimary`, it does not change the shape | — |
| Tests | Unit: non-primary read-scope (status-only response), if enforced server-side. E2E / manual script: mobile Operator on a crew ticket sees "On \<Oiler\>'s ticket" with status only — no accept, no signatures, no checklists, no comments (REQ-06, REQ-16 acceptance). Mobile: any existing test asserting the PR #561 banner/CTA behavior is removed, not left disabled. | |

### Reviewable as

- **Demo:** as the Operator on a seeded crew ticket, open the mobile Jobs list; see one entry
  labeled "On \<Oiler name\>'s ticket" with status/progress only, no View-ticket button.
- **Acceptance:** REQ-06, REQ-16's acceptance lines in full.
- **Reviewer can verify without:** U2, U4, U5 — this unit only needs U1's roster/membership
  read path, not labor-entry data or either web listing.

### Risk

- **Weakest source:** `[VERIFIED]` — both REQ-06 and REQ-16 are sourced to the engineering
  decision note (Q3), which itself flags the *default* (status-only, not richer) as a
  requester default rather than a confirmed client answer — that residual is Q5, tracked as
  non-blocking, not a source-strength problem for what actually ships here.
- **Migration reversible:** n/a — no schema change.
- **Behind a flag:** no — `NOT SPECIFIED`, not proposed.
- **Touches existing data:** no — this unit changes reads and mobile rendering only.
- **Blast radius:** the Operator persona's mobile Jobs/Home screen, for every tenant with a
  crew ticket. A bug here either over-exposes data Q3 says should stay hidden, or breaks the
  Operator's ability to see their own ticket status at all.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `apps/mobile/app/(field)/jobs.tsx`, `field.tsx`, `components/field/crew-ticket-banner.tsx`, `ticket/index.tsx` (`crewCopy`/`isReadOnlyTicket`) | `crewTicket.role` PRIMARY/SECONDARY shape | E2E/manual script above; any existing unit test on `crew-ticket-banner.tsx` or the `crewCopy` branch is deleted along with the code, not left stale | `spec.md` REQ-06 / §11a row 8, `decisions/2026-09-14-crew-ticket-shape-….md` (Q3) |

### Deliberately not in this unit

- Whether the Operator eventually sees signatures/checklists/comments (Q5) — non-blocking,
  open, owner Wes Staley + client. This unit ships the status-only default regardless; a later
  "yes" is additive (REQ-16 notes) and is a new unit against this ticket or a follow-up, not
  something to build toward here.

---

## U4 — Web Job/Progress Tracking: one row per ticket, employees listed, primary marked

- **Outcome:** A crew's Progress Tracking board shows one card for the crane-set ticket, with
  the Oiler marked primary and the Operator listed on it — not two cards, one of them a
  "copy."
- **Kind:** vertical
- **Requirements covered:** REQ-07 (fully)
- **Depends on:** U1 (needs `ticket_employees` as the roster source and the retirement of the
  `ticket.primaryTicket ?? ticket` indirection)

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — U1 already introduced everything this unit reads | — |
| API (`apps/api`) | `job-progress.service.ts`: `summaryCaptures`/`detailCaptures` — retire the `ticket.primaryTicket ?? ticket` indirection (this is the mechanism PR #568 added for the crew-copy shape); read each ticket's own `ticket_employees` roster directly, since there is only ever one physical ticket per crew set after U1. `getJobProgress`/`getTicketDetail` response gains a plural `employees[]` in place of a singular `person`. | This is the PR #568 progress-tracking copy handling the executor notes call out by name — confirm it is fully gone, not just unreachable, via `grep -rn "primaryTicket" apps/api/src/usecase/job-progress`. |
| Web (`apps/web`) | `apps/web/src/features/ticket-progress/components/crew-identity.tsx`: reused, extended to render a list of employees with the primary marked instead of one `person`. `action-buttons.tsx`, `ticket-banners.tsx`: updated for the plural shape; confirm no "copy row" rendering path remains — REQ-07 explicitly says no copy rows. `derive-ticket-progress-view` (or its equivalent view-derivation function named in the ticket's own instructions) updated for one-row-per-ticket. | Reuse `crew-identity.tsx` — do not create a new component without checking `find-component` first, per `.ai/claude/contexts/web.md`. New component vs. extension is `NOT SPECIFIED` by spec.md §5 — executor's UI-detail choice within the requirement. |
| Mobile (`apps/mobile`) | N/A — this is a web-only requirement (spec.md §6 does not name Progress Tracking as a mobile screen) | — |
| Shared (`packages/shared`) | `ProgressTicketSummary.person`/`.role` (`packages/shared/src/types/job-progress.types.ts:139,141`) — both singular, both become plural (`employees: [{ employeeId, name, isPrimary, role? }]` or equivalent). | **Run `tcg-contract-tracer`** — this is a `packages/shared` type change; confirm which of web/mobile actually import `ProgressTicketSummary` before assuming web-only impact (job-progress types have historically been web-only, but verify, do not assume). |
| Tests | Integration (API): `getJobProgress`/`getTicketDetail` for a crew ticket returns one summary row with two employees, primary marked, not two rows. Web: `crew-identity.tsx` renders a multi-employee row correctly; existing Progress Tracking tests updated for the plural shape, not left asserting singular `person`. `data-testid` check: `grep -rn '<the-id>' qa-automation/e2e` for every testid touched in `crew-identity.tsx`/`action-buttons.tsx`/`ticket-banners.tsx` before renaming any — per `.ai/claude/contexts/web.md` → Test IDs; `qa-automation/e2e` has no existing `primaryTicketId`/`linkCrewTickets` matches (§11a row 10) but may still reference these components' testids directly. | |

### Reviewable as

- **Demo:** open Web Job/Progress Tracking for a crew set with an Oiler+Operator; see one card,
  Oiler marked primary, Operator listed, 14-step Oiler flow shown — not two cards.
- **Acceptance:** REQ-07's acceptance line in full.
- **Reviewer can verify without:** U2, U3, U5 — Progress Tracking does not need labor-entry
  data, the Operator's own mobile view, or the DAS listing.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-07's only source is `SCRUM-CREW-TICKET/intent.md`
  §4. No schema/migration rides with this unit, so there is no irreversible-change pairing to
  raise per §2b — but the `[UNVERIFIED]` tag itself is worth carrying forward: if Progress
  Tracking's exact display shape turns out to matter more precisely than "employees listed,
  primary marked," that is a scope question for this unit specifically, not the ticket as a
  whole.
- **Migration reversible:** n/a — no schema change.
- **Behind a flag:** no — `NOT SPECIFIED`, not proposed.
- **Touches existing data:** no.
- **Blast radius:** Web Progress Tracking for every tenant — a wrong `employees[]` derivation
  either drops a crew member from the board or re-introduces a copy row.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `apps/web/src/features/ticket-progress/` (`crew-identity.tsx`, `action-buttons.tsx`, `ticket-banners.tsx`), `job-progress.types.ts` (`ProgressTicketSummary.person`/`.role`) | singular `person` per ticket row | Web component tests updated for the plural shape; `job-progress.service.ts` integration test above | `spec.md` REQ-07 / §11a row 7 |

### Deliberately not in this unit

- Nothing cut — REQ-07 is fully authorized and has no `[OPEN]` dependency.

---

## U5 — DAS/dispatch ticket-listing views: one row per asset group

- **Outcome:** The "Confirm & Send Tickets" DAS modal (and any other dispatch view that lists
  tickets or their people) shows one row for a crane set with an Oiler and Operator seated,
  not two.
- **Kind:** vertical
- **Requirements covered:** REQ-08 (fully)
- **Depends on:** U1 (needs `ensureTickets`'s `EnsuredTicketRow` return shape already producing
  one row per crew set with a roster, not one row per allocation)

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — U1 already introduced everything this unit reads | — |
| API (`apps/api`) | `job-tickets.service.ts`: `EnsuredTicketRow`'s single `employeeName: string` field becomes an `employees: [{ employeeId, employeeName, isPrimary }]` list (or equivalent), sourced from U1's already-absorbed roster — `ensureTickets` itself does not need further minting-logic changes here, only its response DTO. | The underlying "only the primary is sent/accepts" behavior is already correct after U1 — this unit is display-only. |
| Web (`apps/web`) | `apps/web/src/features/das/middle-section/jobs/tickets/components/send-ticket-modal.tsx`: `tableRows` built one per ticket with its employee list, not one per `t.allocationId`/`t.employeeName`. `use-ensure-tickets.ts`, `das-allocations.service.ts` (web): updated for the new `EnsuredTicketRow` shape. | Match whichever table primitive this module already uses (`WorkspaceTable`/`CommonTable`/bespoke) — `NOT SPECIFIED` by spec.md §5, confirm against `.ai/claude/contexts/web.md`'s Tables guidance before choosing. |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | `NOT SPECIFIED` whether `EnsuredTicketRow` is a `packages/shared` type or hand-mirrored in `apps/web`'s API client types — confirm before starting; **run `tcg-contract-tracer` if it does live in `packages/shared`**, skip it (and note why) if it does not. | |
| Tests | Web: the "Confirm & Send Tickets" modal shows one row for a crane set with an Oiler and Operator seated, listing both employees (REQ-08 acceptance). `data-testid` check per `.ai/claude/contexts/web.md` → Test IDs for any id touched in `send-ticket-modal.tsx` — `grep -rn '<the-id>' qa-automation/e2e` before renaming; §11a row 10 confirms no existing `primaryTicketId`/`linkCrewTickets` E2E coverage exists, but this modal's own testids may still be referenced. | |

### Reviewable as

- **Demo:** in DAS, open "Confirm & Send Tickets" for a crane set with an Oiler and Operator
  seated; see one row listing both.
- **Acceptance:** REQ-08's acceptance line in full.
- **Reviewer can verify without:** U2, U3, U4 — this is a pure display change over U1's already
  -correct minting/roster shape.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-08's only source is `SCRUM-CREW-TICKET/intent.md`
  §4. No schema/migration in this unit, so no §2b pairing to raise.
- **Migration reversible:** n/a.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** DAS dispatch screens for every tenant — smaller than U4's, since DAS ticket
  listing is a narrower surface than Progress Tracking.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `apps/web/src/features/das/middle-section/jobs/tickets/components/send-ticket-modal.tsx`, `use-ensure-tickets.ts`, `das-allocations.service.ts` (web) | `EnsuredTicketRow[]` — one row per allocation | web test above; confirm the modal's existing send/confirm flow (if under test) still works with the multi-employee row shape | `spec.md` REQ-08 / §11a row 6 |

### Deliberately not in this unit

- Nothing cut — REQ-08 is fully authorized and has no `[OPEN]` dependency.

---

## Sequencing

```
U1 ──▶ U2
  ├──▶ U3
  ├──▶ U4
  └──▶ U5
```

- **Parallelisable:** once U1 merges, **U2, U3, U4 and U5 can all run concurrently** — they
  touch disjoint files and disjoint tables:
  - U2: `ticket-labor-entries.service.ts`, `payroll.service.ts`, `PayrollJobDay` (schema),
    mobile Labor-step entry controls.
  - U3: `apps/mobile/app/(field)/jobs.tsx`, `field.tsx`, `ticket/index.tsx`,
    `crew-ticket-banner.tsx`, the read-scope half of `getTicketForEmployeeAction`.
  - U4: `apps/web/src/features/ticket-progress/`, `job-progress.service.ts`,
    `job-progress.types.ts` (shared).
  - U5: `apps/web/src/features/das/middle-section/jobs/tickets/`, `job-tickets.service.ts`'s
    `EnsuredTicketRow` DTO (a different export from the functions U1 changed).
  None of the four touch `apps/api/prisma/schema.prisma` — all schema work for this ticket is
  in U1 (the `ticket_employees` table and `JobTicket` column drops) and U2 (the `PayrollJobDay`
  key widening, a different table). **Not parallel:** U2's `PayrollJobDay` migration and any
  other unit's migration, if one were added later — there is none here, so this is not a live
  constraint, only a note for a future unit. U2 and U3 both touch mobile field-persona screens
  but different files (Labor step vs. Jobs/Home) — safe to run concurrently, rebase-aware.
- **Merge order constraint:** U1's migration must land and its backfill must be verified
  against a production-shaped snapshot before U2's `PayrollJobDay` migration runs, since U2's
  backfill joins through the `ticket_employees` rows U1's migration creates. U3, U4, U5 have no
  migration-order dependency on each other or on U2 — only on U1's schema/API shape existing.
- **First unit to ship:** **U1** — it carries the ticket's one large, one-way migration and
  proves the riskiest assumption in the whole plan (that the existing `(subJobId,
  setResourceId, shiftNumber)` grouping key correctly collapses every live linked pair with no
  orphans, and that the same-shaped backfill correctly stamps every COMPLETE ticket without
  disturbing already-priced payroll). If that assumption is wrong, it is far cheaper to find
  out here, before U2's payroll migration, U3's mobile UI, U4's web UI and U5's DAS UI are all
  also in flight against a shape that turns out to need rework. U1 also ships a demonstrable
  result on its own (one ticket instead of two, visible on the Oiler's mobile screen), so it
  is not a foundation stub — it is the first real proof the plan holds.

I have not implemented anything. Hand U1 to an executor when you are ready.
