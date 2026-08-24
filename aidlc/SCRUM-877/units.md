# Units — SCRUM-877 Labor & Unit Details

> Written to `.ai/aidlc/SCRUM-877/units.md` from the approved `spec.md` beside it.
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

Everything else is vertical.

## Fill rules

Every field is required per unit. **Never delete a field.** Unfilled fields take
`NOT SPECIFIED`, `N/A — <reason>`, or `OPEN — <question>`, as in `spec.md`.

A unit may not depend on an `[OPEN]` requirement. If it does, either the question gets
answered first or the unit is cut down to the part that does not depend on it — and the
cut is recorded in *Deliberately not in this unit*.

An `[UNVERIFIED]` requirement is different and much weaker: it **does not** block a unit.
Almost every requirement carries it. It constrains *how* the unit is built, not whether —
see **Risk** below.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | `Asset.capacity` and `Asset.mainBoomLength` become numeric/decimal via a committed migration | REQ-16, REQ-17 | schema | — | S | completed |
| U2 | Oiler opens Labor step, sees the real crew of their set (not mock data), enters Labor data per teammate, and it persists to each employee's own ticket with server-computed Total/Net Billable Hours | REQ-01, REQ-02, REQ-06, REQ-07, REQ-09, REQ-10 | schema, api, mobile | U1 (schema landed first; U2's model can be authored in parallel but must migrate after U1) | L | completed |
| U3 | Oiler picks a Craft Modifier/Boom Pay bracket from the real 16-row rate table, system suggests one from the asset's boom length, selection propagates to the whole set with correct per-role rate | REQ-05, REQ-08 | schema, api, mobile | U1, U2 | M | completed |
| U4 | Oiler's own card shows their real Union Class/Craft Code (read-only), and the Labor screen shows the relevant Asset info instead of nothing | REQ-04, REQ-13 | api, mobile | U2 | S | completed |
| U5 | Employee can edit permitted Labor fields and attach comments to their entry | REQ-12 | api, mobile | U2 | S | completed |
| U6 | A non-Oiler employee can open their own completed ticket and see their Labor/Unit figures, read-only | REQ-15 | api, mobile | U2 | S | completed |

- Requirements not covered by any unit:
  - **REQ-03 (overtime)** — removed from this ticket's scope entirely by explicit product-owner
    instruction (decision `2026-08-21-...-oiler-crew-linking.md`, comment `23066`). Not `[OPEN]`,
    not deferred-pending-an-answer — deliberately dropped. No unit exists for it and none should.
  - **REQ-14 (payroll retention)** — deferred, not resolved, by the same instruction ("skip the
    conflict-related point... payroll... will be addressed as part of the payroll module in the
    future"). Different disposition than an uncovered `[OPEN]` requirement: this one was asked
    about and explicitly waved off, not left unanswered. No unit exists for it. U2's persistence
    design keeps raw timestamps alongside derived figures (per REQ-14's own executor note) so a
    future payroll ticket has what it needs — that is a design constraint on U2, not coverage of
    REQ-14 itself.
  - **REQ-11 (Labor Classification)** — see *Units blocked on an open question* below. Cut to
    nothing: every part of this requirement (the value list, where it's configured, whether the
    four named values are exhaustive) is `NOT SPECIFIED`/blocked on Q8, which the product owner
    was asked about directly and declined to answer ("Skip this point"). There is no unblocked
    remainder to build — a Labor Classification selector with an invented value list would be a
    requirement this decomposition added, not one the spec made.
- Units blocked on an open question:
  - **REQ-11** — blocked on Q8, `.ai/vault/gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking`
    (logged as `Status: open — deferred, not resolved`). No unit cut for it; see above.

---

## U1 — Asset boom-length and capacity go numeric

- **Outcome:** `Asset.capacity` and `Asset.mainBoomLength` are stored as numeric/decimal
  columns instead of free text, via a single committed migration — a person querying or
  reporting off either field now gets a sortable/comparable number instead of a string.
- **Kind:** vertical — see *why this is not a `foundation` unit* below.
- **Requirements covered:** REQ-16 (fully), REQ-17 (fully — migration itself; precision/scale
  and backfill are `NOT SPECIFIED` by any source and are this unit's own executor call, not a
  blocked product question)
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `Asset.capacity String? @db.VarChar(50)` → `Decimal? @db.Decimal(p,s)`; `Asset.mainBoomLength String? @db.VarChar(30)` → `Decimal? @db.Decimal(p,s)`. One migration, both fields (same model, same shape, per spec.md's own note that they were authorized separately but are "reasonable to design and review together"). Precision/scale: `NOT SPECIFIED` — choose per existing measurement/money-field convention in this schema (e.g. `Decimal(8,2)`) and record the choice in the migration's comment. | `apps/api/prisma/schema.prisma:707,758` |
| API (`apps/api`) | Update every existing typed consumer to the new field type: `apps/api/src/usecase/plans/plans.service.ts:309`, `apps/api/src/service/das/das.repository.ts:405`, `apps/api/src/utility/seed-data.ts` (capacity/mainBoomLength literals at multiple lines — convert seed values to numeric literals), `apps/api/src/presentation/asset-management/assets/dto/create-asset.dto.ts:348` (DTO type `string?` → `number?`) | No new endpoint — this is a type-shape change to existing surfaces |
| Web (`apps/web`) | Update every existing typed consumer's TS types/forms to accept a number instead of a string — at minimum `apps/web/src/features/assets/asset/components/asset-form-sections/basic-unit-info-section.tsx`, `.../dimensions-section.tsx`, `apps/web/src/lib/api/asset-management.types.ts`, `apps/web/src/features/das/types/asset.types.ts`, and other confirmed consumers found by `grep -rln "mainBoomLength\|capacity" apps/web/src` | This spec has no web feature for Labor/Unit itself (§5: `N/A`), but this migration's *blast radius* is web-wide because `Asset.capacity`/`mainBoomLength` are already surfaced there today — every existing consumer must keep working, not gain new behavior |
| Mobile (`apps/mobile`) | none required by this unit itself | — |
| Shared (`packages/shared`) | none | — |
| Tests | Migration up/down; a backfill/conversion test against representative existing free-text values (e.g. `"197 ft"`, `"550"`) proving the chosen conversion strategy does not silently drop or corrupt data; existing asset-management API/web tests updated for the new type | |

### Reviewable as

- **Demo:** run `pnpm db:migrate`, then `pnpm db:studio` — `assets.capacity` and
  `assets.main_boom_length` show as numeric columns; existing asset edit forms in
  `apps/web` still load and save without a type error.
- **Acceptance:** REQ-16 and REQ-17's acceptance lines — migration lands, existing consumers
  keep working.
- **Reviewer can verify without:** U2, U3, or any mobile change — this is a self-contained
  schema change with existing (not new) consumers.

### Risk

- **Weakest source:** `[VERIFIED]` for both fields and both migrations (comment `23066` for
  REQ-16, comment `23099` for REQ-17) — the migration authorization itself is not the risk
  here. Precision/scale/backfill strategy is `NOT SPECIFIED` by any source, which is a build
  detail, not a product-tag weakness.
- **Migration reversible:** no — converting existing free-text values (e.g. `"197 ft"`,
  `"Approx 300"`) to numeric is lossy in the down direction unless the original string is
  retained somewhere; a straight `ALTER COLUMN ... TYPE numeric USING ...` on real production
  data with inconsistent formatting can fail outright or silently null out unparseable rows.
- **Behind a flag:** no.
- **Touches existing data:** yes — every existing `Asset` row's `capacity` and
  `mainBoomLength` values, entered as free text over time, must convert or the migration
  fails/nulls them. Backfill strategy `NOT SPECIFIED` — this is the concrete instance of the
  `[VERIFIED]` + one-way-migration combination the spec itself flags for the executor; raise
  the chosen conversion rule (e.g. regex-extract leading numeric, else null + log) for review
  before running against a real environment, not after.
- **Blast radius:** every existing web/api surface that reads or writes `Asset.capacity` or
  `Asset.mainBoomLength` today (plans, DAS, vendors, asset forms, seed data) — confirmed by
  direct grep, listed in *Slice contents* above. A missed consumer is a runtime type error,
  not a silent bug, but it is spread across many files.

### Deliberately not in this unit

- Nothing cut — both fields' migrations are fully authorized. Precision/scale and backfill
  strategy are executor calls within this unit, not an ledger-level cut.

### Why this is not a `kind: foundation` unit

The exception requires **three or more later units** to depend on one migration. Only one
later unit in this ticket (U3, the boom-pay bracket suggestion) reads `mainBoomLength`, and
none reads `capacity` — REQ-05's bracket axis is boom length, not tonnage, and no other
requirement in this spec touches either field. That is below the threshold this template
sets for the foundation exception, so this is filed as an ordinary (small, schema-only)
vertical unit rather than claiming the exception. It still ships first because REQ-16/REQ-17
were both authorized independently of any specific consuming feature and there is no reason
to make U3 carry a schema migration that has nothing to do with boom-pay brackets.

---

## U2 — Oiler enters real crew's Labor data; it persists per employee ticket

- **Outcome:** An Oiler opens the Labor step on their own ticket and sees a card for
  themselves and for every real Operator-type teammate on the boom in their set (not the
  `RAW_CREW` mock); entering hours/lunch/WTL data for any of those cards persists to that
  teammate's own `JobTicket` record, computed server-side via one shared, reusable
  calculation function, and the Labor/Unit steps only ever appear on the Oiler's ticket.
- **Kind:** vertical
- **Requirements covered:** REQ-01 (fully), REQ-02 (fully), REQ-06 (fully), REQ-07 (fully),
  REQ-09 (fully), REQ-10 (mechanism + model shape fully; precision/scale/backfill is U1's
  concern, not this unit's)
- **Depends on:** U1 (schema must exist before this unit's migration for the new labor/unit
  model can safely reference a numeric `mainBoomLength` in its design, though this unit's own
  migration is additive and does not require U1's migration to have already run in the same
  deploy — see *Sequencing*)

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New model (name `NOT SPECIFIED` by any source — e.g. `TicketLaborEntry`), `jobTicketId` + `capturedByUserId` FK pattern per `TicketLunchBreak`/`TicketSignature` precedent (`schema.prisma:4131,4036`); fields for boom/lunch/WTL-derived timestamps or references sufficient to recompute Total/Net Billable Hours, plus the computed hours themselves persisted (not derived-only, per REQ-14's executor note: keep raw + derived so a future payroll ticket can reconcile). Tenant-scoped (`tenantCompanyId`); confirm the tenant-scoping client extension's model allowlist includes it (`.ai/claude/contexts/prisma.md`) — flagged, not assumed. New migration, separate from U1's. | Model shape not proposed by spec.md beyond this — executor's design within the stated FK pattern |
| API (`apps/api`) | New authorization path alongside (not replacing) `getTicketForEmployeeAction` (`apps/api/src/usecase/job-tickets/job-tickets.service.ts:648-657`) keyed on matching `JobResourceAllocation.setResourceId`; new set-resolution repository method (`JobTicket → allocationId → JobResourceAllocation.setResourceId → sibling allocations → sibling tickets`, filtered to Oiler + boom-working Operator employee types) — precedent in the two existing unshared `resolveSetRoot` copies (`das-allocations.service.ts:589-606`, `das-loadout-defer-allocation.util.ts:82-91`), consolidation explicitly out of scope; new dedicated payload-bearing endpoint on `field-tickets.controller.ts` (matching the `ticket-signatures`/`ticket-lunch-breaks` sibling-module pattern, not extending payload-less `PATCH /field/tickets/:id/step-progress`); new framework-agnostic calculation function/service (inputs: timestamps, lunch/WTL events; outputs: Labor Total Hours, Net Billable Hours) unit-testable in isolation, callable from this endpoint and later payroll work | |
| Web (`apps/web`) | N/A — no source describes a web surface for this feature | |
| Mobile (`apps/mobile`) | `apps/mobile/data/compose-ticket-detail.ts`: replace `RAW_CREW` fixture with a real query against the new set-resolution endpoint; add `labor` (and the Unit-step key, confirmed against `resolveStepKind` — today only `labor` exists as a step kind, no separate `unit` key, consistent with the uncited image description's "no separate Unit screen" reading, which this unit does not cite as a source but does not contradict either) to `CHECKLIST_ONLY_FOR_OILER_KEYS`; `LaborBody.tsx` wired to the real endpoint for submit, `computeLaborHours`/display updated to call the same shared calculation function's shape (add the WTL-add term for Labor Total Hours per REQ-01, without removing existing yard/travel display fields) | Reuse `CrewCard`/`AutoHoursCard`/override pattern — do not rebuild |
| Shared (`packages/shared`) | `NOT SPECIFIED` whether the calculation function's DTO shape needs to live here vs. `apps/api`-only — executor's call, not a product requirement, per spec.md §7 | |
| Tests | Unit: calculation function's Total/Net Billable Hours formulas (REQ-01/REQ-02). Integration (API): Oiler can write to a same-`setResourceId` teammate's ticket; a same-`subJobId`-different-`setResourceId` employee is rejected (REQ-10); only Oiler + boom-working Operator get cards, others never gain a Labor/Unit step (REQ-07); non-Oiler ticket omits Checklist/Labor/Unit steps entirely (REQ-06); N employees compute N independent net-billable figures (REQ-09) | |

### Reviewable as

- **Demo:** as the Oiler on a seeded set with one Oiler + N boom-working Operators, open the
  Labor step; submit an entry for a teammate's card; `GET` that teammate's own ticket and see
  the persisted, server-computed figures.
- **Acceptance:** REQ-01, REQ-02, REQ-06, REQ-07, REQ-09, REQ-10's acceptance lines.
- **Reviewer can verify without:** U3 (bracket/rate selection can be stubbed/omitted from the
  persisted record for this unit's demo — the hours calculation does not depend on the
  bracket value), U4, U5, U6.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-06, REQ-09 carry this tag; REQ-07/REQ-10 are
  `[VERIFIED]` mechanism). Routine — not paired with an irreversible change on its own (the new
  model is new, not a conversion of existing data), so this does not trigger the raise-before-
  build rule. The one irreversible piece touching this unit's design (Asset numeric conversion)
  is U1's, tracked there.
- **Migration reversible:** yes — this is a brand-new, empty table; dropping it loses nothing
  that existed before this unit.
- **Behind a flag:** no — `NOT SPECIFIED` by any source; not proposed here either, since
  nothing in the spec asks for staged rollout.
- **Touches existing data:** no — new rows only, no existing table altered by this unit.
- **Blast radius:** the mobile Labor step for every Oiler; a bug here means either a teammate's
  hours are miscomputed/misattributed, or the authorization gap the spec explicitly warns about
  (an Operator's app instance sending a labor payload must be rejected server-side, not merely
  hidden client-side — REQ-06's executor note) goes unenforced.

### Deliberately not in this unit

- Craft Modifier/Boom Pay bracket selection and rate lookup (REQ-05, REQ-08) — lands in U3.
  This unit's persisted record needs a field to hold the eventual bracket selection, but the
  bracket table, suggestion logic, and per-role rate are not built here.
- Oiler card's auto-populated Union Class/Craft Code, and Unit/Asset info display (REQ-04,
  REQ-13) — lands in U4. Not blocked; simply a separate additive display concern layered onto
  the same card this unit builds.
- Employee-adjustment business rules and comments persistence (REQ-12) — lands in U5. The
  comments *field* already has UI precedent (`VoiceTextarea` in `LaborBody.tsx`); this unit
  does not wire it to the new persisted model.
- Non-Oiler read-only view (REQ-15) — lands in U6.
- Consolidating the two existing unshared `resolveSetRoot` implementations into one shared
  utility — spec.md is explicit this is out of scope unless a unit is deliberately cut for it;
  none is cut here.
- Labor Classification (REQ-11) — blocked on Q8, not part of this unit; see the ledger.

---

## U3 — Craft Modifier/Boom Pay bracket suggestion and propagation

- **Outcome:** The Oiler sees a system-suggested Craft Modifier/Boom Pay bracket drawn from
  the real 16-row rate table (matched against the crane's actual numeric boom length),
  ★-marked, can pick any other option with a required reason if they override, and that
  selection applies to every qualifying set member with each person's own role-correct rate.
- **Kind:** vertical
- **Requirements covered:** REQ-05 (fully — bracket-boundary edge semantics is a residual,
  non-blocking detail the executor chooses a convention for and notes, per spec.md), REQ-08
  (fully — propagation mechanism plus REQ-05's now-verified rates)
- **Depends on:** U1 (needs `Asset.mainBoomLength` as numeric to match against), U2 (needs the
  set-resolution query and the persisted per-employee record to write the bracket/rate into)

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | A home for the 16-row `FMS_UNION_CRAFT_MODIFIER` table — storage shape `NOT SPECIFIED` by any source (seed/reference table vs. a config constant read by the calculation function); if a table, follows the `EmployeeCraftCode`/`EmployeeUnionCode` admin-reference pattern. Add a bracket-selection field (and override-reason field) to U2's labor/unit model if not already provisioned there. | Executor's call on storage shape, per spec.md §3 |
| API (`apps/api`) | Bracket-matching function against numeric `mainBoomLength`, clamping above 380 ft to `OI-BP-15`/$3.750 for Oilers (Operators do have an above-380 continuation per the table: `OP-BP-16`, `OP-BP-18` — no clamp needed on the Operator side except the genuine gap at 401–420 ft); propagation: one Oiler write updates the bracket field on every qualifying set member's persisted record (U2), rate looked up per-teammate by their own employee type | Do not hardcode as a client-side constant — treat as reference data per REQ-05's note |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | `LaborBody.tsx`: replace `BOOM_BRACKETS`/`SUGGESTED_BOOM` hardcoded constants with the real table and the server-suggested bracket per asset; keep the existing override-with-reason UI pattern unchanged | Reuse existing bottom-sheet/picker UI |
| Shared (`packages/shared`) | `NOT SPECIFIED` — same open call as U2 | |
| Tests | Unit: bracket matching selects/clamps correctly across the 16-row table, including the above-380ft Oiler fallback and the genuine 401–420ft gap. Integration (API): Oiler's bracket selection propagates to all qualifying set members; per-employee-type rate differs correctly for the same bracket (REQ-08) | |

### Reviewable as

- **Demo:** as the Oiler, open a set whose crane's `mainBoomLength` falls in a known bracket;
  the suggested bracket is pre-marked; override it with a reason; confirm every qualifying
  teammate's record reflects the new bracket with their own correct rate.
- **Acceptance:** REQ-05 and REQ-08's acceptance lines.
- **Reviewer can verify without:** U4, U5, U6.

### Risk

- **Weakest source:** `[VERIFIED]` for the rate table, the above-380ft rule, and REQ-05's
  mechanism (comment `23099`); `[UNVERIFIED]` for REQ-08's propagation mechanism specifically
  (the original ticket comment `22923` was never independently re-confirmed the way most other
  claims in this ticket were — spec.md flags this explicitly as low-risk but unconfirmed).
  Not paired with an irreversible change, so this does not trigger the raise-before-build rule.
- **Migration reversible:** yes, if a reference table is chosen — it is new, seedable data,
  not a conversion of anything existing.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** wrong bracket/rate on a real Oiler ticket is a payroll-adjacent billing
  error, even though payroll itself is out of scope (REQ-14) — the raw + derived data this
  unit produces is exactly what a future payroll reconciliation would need to be correct.
- **Residual, not blocking:** exact bracket-boundary inclusive/exclusive semantics at 380 ft
  and 440 ft — `NOT SPECIFIED` by any source; the executor picks a convention (e.g.
  inclusive-upper) and notes it in the PR, per REQ-05's own instruction.

### Deliberately not in this unit

- Anything about which employee types beyond Oiler/Operator get a card at all — that's U2
  (REQ-07's scope, already resolved there).
- Payroll reconciliation of the applied rate — REQ-14, deferred, no unit exists for it.

---

## U4 — Oiler card auto-populate and Unit/Asset info display

- **Outcome:** The Oiler's own card on the Labor step shows their real Union Class and Craft
  Code, read-only, pulled from their employee profile instead of nothing; the Labor & Unit
  screen shows the relevant Asset info (at minimum `mainBoomLength`, `capacity`, and whatever
  else is obviously relevant per existing asset-detail patterns) instead of nothing.
- **Kind:** vertical
- **Requirements covered:** REQ-04 (display mechanism fully; data-readiness — whether any real
  tenant has an Oiler-appropriate `EmployeeCraftCode` row configured — is `[OPEN — Q3]` but is
  explicitly not build-blocking per spec.md: build the display, it degrades to blank if the FK
  is null), REQ-13 (that Unit/Asset info displays, fully; exact layout is `NOT SPECIFIED`
  pending Q7's unreadable images — build a reasonable field set now, not a guessed pixel layout)
- **Depends on:** U2 (the crew card list must exist to add these fields onto)

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — no schema change; `EmployeeCraftCode`/`EmployeeUnionCode` and `Asset` already carry the needed fields | |
| API (`apps/api`) | Ensure the ticket/crew read endpoint (U2) includes `Employee.craftCodeId → EmployeeCraftCode.label`, `Employee.unionCodeId → EmployeeUnionCode.label`, and the relevant `Asset` fields in its response | |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | `LaborBody.tsx`'s `ReadField` (Union Class, Craft Code) wired to real data instead of the `crew.union`/`crew.craft` mock fields; add an Asset-info section/card to the Labor screen (fields: `mainBoomLength`, `capacity`, plus any other obviously-relevant existing `Asset` field per current asset-detail display patterns — exact layout `NOT SPECIFIED`, flagged rather than guessed) | If FK is null, display blank (spec.md's stated safe default for the unspecified case) |
| Shared (`packages/shared`) | none | |
| Tests | Integration: Oiler card shows real Union Class/Craft Code when the employee's FKs are set, and blank when null; Asset info section renders the confirmed-relevant fields | |

### Reviewable as

- **Demo:** as the Oiler, with an employee record whose `craftCodeId`/`unionCodeId` are set,
  open the Labor step and see those values (not the mock `crew.union`/`crew.craft`); with them
  null, see blank rather than an error.
- **Acceptance:** REQ-04 and REQ-13's acceptance lines, both explicitly `NOT SPECIFIED` beyond
  what's stated here.
- **Reviewer can verify without:** U3, U5, U6.

### Risk

- **Weakest source:** `[OPEN — Q3 data-readiness]` for whether real tenant data actually has a
  usable row (not build-blocking, per spec.md's explicit instruction — display mechanism is
  `[VERIFIED]`); `[UNVERIFIED]`/`NOT SPECIFIED` for REQ-13's exact layout. Not paired with an
  irreversible change — no migration, no data touch — so the raise-before-build rule does not
  apply regardless.
- **Migration reversible:** N/A — no migration in this unit.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** cosmetic — a blank field or an imperfect layout, not a data-correctness or
  authorization failure.

### Deliberately not in this unit

- Adding a code-level `OILER` `EmployeeCraftCode` seed row, or any special-casing of "Oiler" as
  a string — spec.md is explicit this is not required and should not be built; the
  data-readiness gap (Q3) is an operational/ops action item, not an engineering task, and is
  not resolved here or anywhere in this decomposition.
- The exact field layout implied by the two still-unreadable Jira attachment images (Q7) — not
  guessed at; this unit builds the fields independently sourced as obviously relevant, and
  should be revisited if/when those images become a citable source.

---

## U5 — Employee can adjust Labor entries and add comments

- **Outcome:** An employee viewing their own (or, for the Oiler, a teammate's) Labor entry can
  edit the fields business rules permit and attach free-text comments, persisted with the
  record.
- **Kind:** vertical
- **Requirements covered:** REQ-12 (comments fully; "business rules" governing which fields are
  editable is `NOT SPECIFIED` by any source — build comments plus whatever fields U2/U3 already
  make editable through their own UI, do not invent a separate permission model)
- **Depends on:** U2 (the persisted record and its card UI must exist)

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | Add a `comments` field to U2's labor/unit model if not already provisioned there | Small addition to U2's model, not a new model |
| API (`apps/api`) | Extend U2's write endpoint to accept and persist the comments field | |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | Wire the existing `VoiceTextarea` comments field in `LaborBody.tsx` (already built, currently local-only) to the real persisted record | |
| Shared (`packages/shared`) | none | |
| Tests | Integration: comments persist with the Labor/Unit record and round-trip on read | |

### Reviewable as

- **Demo:** submit a Labor entry with a comment; read it back and see the comment persisted.
- **Acceptance:** REQ-12's acceptance line (comments persistence; adjustment-permission rules
  explicitly `NOT SPECIFIED`, not demoed as a separate permission check because none is stated).
- **Reviewer can verify without:** U3, U4, U6.

### Risk

- **Weakest source:** `[UNVERIFIED]` (vault story US-18, uncorroborated by any decision record
  beyond the pre-existing UI). Not paired with an irreversible change.
- **Migration reversible:** yes — additive nullable column on U2's new (not pre-existing) table.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** low — a lost or unpersisted comment, not a billing or authorization defect.

### Deliberately not in this unit

- Any specific business-rule-driven field-lock/edit-permission model — no source names one;
  building one would be inventing a requirement the spec does not make. If this becomes
  necessary, it is a `gaps.md` item and a question back to product, not a build decision here.

---

## U6 — Non-Oiler read-only Labor/Unit view

- **Outcome:** An employee whose Labor/Unit data was entered by their Oiler can open their own
  ticket and see that data — Net Billable Hours and the applied Craft Modifier bracket at
  minimum — read-only, even though their own ticket never carried a Labor/Unit entry step.
- **Kind:** vertical
- **Requirements covered:** REQ-15 (fully — the yes/no and the minimum content are `[VERIFIED]`;
  exact screen/route is `NOT SPECIFIED`, executor's call within the existing app's navigation
  conventions)
- **Depends on:** U2 (the persisted record must exist to read), U3 (for the bracket/rate to be
  part of what's shown — without U3 this unit can still show Net Billable Hours alone, but the
  full REQ-15 acceptance line names "the applied Craft Modifier bracket" too)

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | New read endpoint (or extend an existing ticket-detail read) scoped by the existing, unmodified `getTicketForEmployeeAction` check — this is the ordinary "this is my own ticket" case, not the new `setResourceId` authorization path | |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | A read-only presentation of the employee's own Labor/Unit figures — route/screen `NOT SPECIFIED`; executor picks a reasonable place (e.g. a read-only variant of the same Labor step body, gated off `isOiler`) and notes the choice | |
| Shared (`packages/shared`) | none | |
| Tests | Integration: non-Oiler can read their own Labor/Unit data; cannot write to it; cannot read another employee's | |

### Reviewable as

- **Demo:** as a non-Oiler teammate whose Oiler already submitted a Labor entry for them, open
  the ticket and see the read-only figures.
- **Acceptance:** REQ-15's acceptance line.
- **Reviewer can verify without:** U4, U5.

### Risk

- **Weakest source:** `[VERIFIED]` (Q9, comments `23062`/`23066`/`23025`, independently
  re-verified by the decision record for internal consistency). Screen/route choice is
  `NOT SPECIFIED` but not a source-confidence risk.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no — read-only.
- **Blast radius:** low — worst case is an employee seeing stale or incomplete figures if U3
  hasn't shipped yet; no write path exists to corrupt anything.

### Deliberately not in this unit

- Any live-refresh/concurrency handling if the Oiler edits while the teammate's read view is
  open — `NOT SPECIFIED` by any source (spec.md §11 flags this explicitly and unresolved); not
  built here, not invented here.

---

## Sequencing

```
U1 ──▶ U3
U2 ──▶ U3 ──▶ U6
U2 ──▶ U4
U2 ──▶ U5
U2 ──▶ U6
```

- **Parallelisable:** U4 and U5 can run concurrently once U2 merges — U4 touches
  `LaborBody.tsx`'s `ReadField`/Asset-info section and the crew-read response shape; U5 touches
  `LaborBody.tsx`'s comments wiring and U2's model's `comments` column. Different fields, same
  files (`LaborBody.tsx`, U2's model) — real overlap, so treat as parallel-with-care: land as
  two small, easily-rebased PRs rather than claiming zero collision. U1 can run fully in
  parallel with U2's early schema/API work (different models: `Asset` vs. the new labor/unit
  model) — they only interact at U3, which needs both. **Not parallel:** any two units both
  editing `apps/api/prisma/schema.prisma` in the same window without rebasing — that's U1 vs.
  U2's schema work, and later U3/U5 vs. U2's model once it exists. Migrations land in unit
  order (U1, then U2's new-model migration, then U3's reference-data migration if a table is
  chosen, then U5's `comments` column addition to U2's model).
- **Merge order constraint:** U2 before U3, U4, U5, U6 (all four read or write the model/crew
  list U2 creates). U1 before U3 (needs numeric `mainBoomLength`). U1 has no reason to wait on
  anything and should land first or in parallel with U2's early work.
- **First unit to ship:** **U1** — it is small, fully authorized, has no product ambiguity left
  in it, and proves the migration mechanics (precision/scale choice, backfill strategy for
  real free-text asset data) that U3 will depend on, before any of the genuinely new-model,
  new-authorization-path work in U2 begins. If U1's backfill assumption turns out wrong against
  real data, that is cheap to discover here and expensive to discover after U2/U3 are also in
  flight. **U2 is the riskiest unit** (new model, new authorization path, real crew wiring
  replacing a mock) and should follow immediately — it is the one unit every other vertical
  slice depends on, so proving it early (rather than last) is what makes the rest of the plan
  low-risk.
