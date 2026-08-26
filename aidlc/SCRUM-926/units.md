# Units — SCRUM-926 Craft code

> Written to `.ai/aidlc/SCRUM-926/units.md` from the approved `spec.md` beside it.
> Consumed by the decomposer and then by an executor, one unit at a time.
>
> **Nothing here has been implemented.** The decomposer produced this file and stopped.

**Spec revision this `units.md` was cut from: `2026-08-25` (post Q1 / Q14 / Q18 / Q19).**
Requirements ledger at that revision: **28 total — 0 verified, 21 unverified, 4 conflicted
(REQ-01, REQ-02, REQ-07, REQ-20), 0 open, 3 out of scope.** Everything below tracks that
text; there is no divergence between this file and the spec to reconcile.

Product-owner constraints this decomposition was cut under, all from **Syed Haris**:
backend only; units map one-to-one onto the four `SCRUM-926` child tasks, carrying the Jira
key in the heading; every unit demonstrable through the API; no unit depending on an
`[OPEN]` requirement; `tcg-prisma-guardian` on every migration, `tcg-contract-tracer`
wherever a shared contract moves, `pnpm affected` on every unit.

Two things about that revision that shape every unit below, and both are worth knowing
before reading one:

- **There is no data migration in this epic** (REQ-23), with **one narrow exception**:
  `EmployeeUnionCode.kind` is derived for existing rows by label match, because the column
  is required and the table is populated (Q19). That single write is the only business
  column the migration touches, and it is the only irreversible-ish step left anywhere.
- **Nothing is dropped.** `employee_craft_codes`, `Employee.craftCodeId`,
  `Employee.unionCodeId` and `Employee.unionStatus` all survive and are simply no longer
  read by payroll; a **later cleanup ticket** removes them once REQ-07's report endpoint
  shows no employee lacking a PRIMARY. `Employee.hourlyRate` is **not** on that list at
  all — under REQ-10 it is the non-union base rate.

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

**No foundation unit was created, and the `2026-08-25` revision strengthens that.** The
three schema-bearing units touch three different tables — `craft_codes` /
`craft_code_rates` (U1), `craft_modifier_scales` (U2), `employee_craft_assignments` (U3).
The exception applies when three or more units depend on **one** migration against **one**
table; nothing here does. The one-to-one Jira mapping holds with **no slicing deviation**.

## Fill rules

Every field is required per unit. **Never delete a field.** Unfilled fields take
`NOT SPECIFIED`, `N/A — <reason>`, or `OPEN — <question>`, as in `spec.md`.

A unit may not depend on an `[OPEN]` requirement. If it does, either the question gets
answered first or the unit is cut down to the part that does not depend on it — and the
cut is recorded in *Deliberately not in this unit*.

An `[UNVERIFIED]` requirement is different and much weaker: it **does not** block a unit.
Almost every requirement carries it. It constrains *how* the unit is built, not whether —
see **Risk** below.

**`spec.md` carries zero `[OPEN]` requirements** at this revision. No unit below is blocked
on one, and none was cut down to avoid one.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 — `SCRUM-925` | An admin can configure craft codes with a union code, role type and validity window, give union crafts effective-dated base rates, and every union code now carries a kind | REQ-01, REQ-02, REQ-03, REQ-04 *(field)*, REQ-05, REQ-06 *(fields)*, REQ-09, REQ-10 *(the no-rate-rows rule)*, REQ-23 *(its tables + the `kind` derivation)*, REQ-25, REQ-26 *(craft + rate)*, REQ-28 *(CRUD gate)* | schema, api, shared | — | M | not started |
| U2 — `SCRUM-934` | An admin can configure one boom-modifier scale per union code and preview every tier it generates, without a tier row existing anywhere | REQ-04 *(step-rate selection)*, REQ-11, REQ-12, REQ-13, REQ-14, REQ-15 *(fixture only — no seed)*, REQ-16, REQ-23 *(its table)*, REQ-26 *(scale)* | schema, api | U1 *(the `RoleType` enum)* | M | not started |
| U3 — `SCRUM-927` | An employee created or updated from now on carries exactly one PRIMARY craft assignment plus any allowed alternates, one admin endpoint lists everyone who still has none, and the union KPI reads craft kind where a PRIMARY exists and the legacy label where it does not | REQ-07, REQ-08, REQ-23 *(its table)*, REQ-24, REQ-26 *(assignment)*, REQ-27, REQ-28 *(assignment gate)* | schema, api, shared | U1 | M | not started |
| U4 — `SCRUM-935` | The payroll engine has one call that turns an employee + work date + optional secondary craft + optional boom length into a base rate and a boom adder — union priced from the craft rate on the work date, non-union from the employee's own rate — returning Blocked rather than throwing when the data is not there | REQ-06 *(window check)*, REQ-10, REQ-17, REQ-18, REQ-19, REQ-20 | api | U1, U2, U3 | M | not started |

- **Requirements not covered by any unit:**
  - **REQ-15** — L12 scale seed. `[N/A — OUT OF SCOPE]` by Q5. **Not uncovered in substance**:
    its values are U2's test fixture, built in test setup, never in a migration.
  - **REQ-21**, **REQ-22** — L12 craft rate seeds. `[N/A — OUT OF SCOPE]` by Q5. Nothing to
    build. `spec.md` §13 records that REQ-22's FY26-27 contradiction is **unresolved and now
    sits with whoever enters rates** — a release-planning item, not a unit.
  - Count check: **28 requirements in `spec.md` §1 — 25 covered, 3 uncovered, all three
    `[N/A — OUT OF SCOPE]`.** Nothing is covered "partly" in the sense that matters: where a
    requirement spans two units the split is named in that unit's *Requirements covered* line
    and the halves are exhaustive. Five requirements are split that way — REQ-04 (U1 field /
    U2 step-rate selection), REQ-06 (U1 fields / U4 window check), REQ-23 (each unit's own
    tables, plus U1's `kind` derivation), REQ-26 (each unit's own entity), REQ-28 (U1 CRUD
    gate / U3 assignment gate).

- **Units blocked on an open question:** **none**, and at this revision nothing is pending
  that gates a unit at all:
  - **Q1** resolved `2026-08-25` **in `PAY-012`'s favour** — non-union is per person. REQ-10's
    `[CONFLICT]` **cleared**; four sources now agree where two disagreed.
  - **Q14** and **Q17** withdrawn — each protected a migration step that no longer exists.
  - **Q15** answered — `Decimal(10,4)`; cents rounding only in the ledger (`PAY-069`, itself
    `status: open`), and **this epic has no ledger, so nothing here rounds**.
  - **Q16** answered — U4 is reviewed through its test suite plus U2's preview endpoint; no
    HTTP surface added. Now recorded in REQ-17's own notes.
  - **Q18** resolved — the `[VERIFIED]` `decisions/2026-08-20-craft-locked-rate-override.md`
    is read as **scoped to union crafts**, complementary to `PAY-012` rather than contradicted
    by it. **`tcg-scrum` still owes the clarification note**; until it lands, that reading is
    recorded in REQ-19's *Conflict* paragraph and nowhere durable.
  - **Q19** answered — the `kind` label match, with every derived row listed in the PR.
  - **Q2** answered (boom length is chosen on the labor entry at ticket close, never derived
    from the unit) — confirms U4's interface without changing it. **Q3** answered as a
    *working decision* (adder paid **on top**, unmultiplied) with **REQ-20's `[CONFLICT]`
    deliberately kept**. **Q13** moved out of this epic. **Q6** resolved for this epic.
  - Still genuinely open and none of them this epic's: **Q3's confirmation** (labor counsel,
    against MLA Article IV) and **Q6** beyond this epic's scope.

---

## U1 — SCRUM-925 — Craft codes and effective-dated rates

- **Outcome:** A payroll administrator can create, edit, list and deactivate a craft code
  carrying its union code, role type and validity window; can give a **union** craft
  effective-dated base rates; and every existing union code now carries a `kind` — all
  starting from empty tables, through the API, while web and mobile keep compiling on the
  old routes.
- **Kind:** vertical
- **Requirements covered:** REQ-01, REQ-02, REQ-03, REQ-05, REQ-09, REQ-25 — fully. REQ-04 —
  **the field and its required-ness**; the step-rate selection it specifies is U2's. REQ-06 —
  **the `startDate`/`endDate` fields and their validation**; "a lookup outside the window does
  not resolve" is U4's. REQ-10 — **only its schema-side rule**: a non-union craft carries no
  `CraftCodeRate` rows and **validation must not require one**; the resolver branch is U4's.
  REQ-23 — **this unit's tables and enums, plus the `EmployeeUnionCode.kind` derivation**,
  which is the epic's single data write. REQ-26 — **the craft-code and rate entities**.
  REQ-28 — **the CRUD gate**.
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New `CraftCode`, `CraftCodeRate`; new enums `RoleType` (6 values) and `UnionKind` (2 values); `EmployeeUnionCode` gains **required** `kind`, optional `localNumber`, optional `agreement`; `ActivityLogEntityType` gains craft-code and rate members. Add `craftcode` and `craftcoderate` to the `$extends` allowlist in `apps/api/src/orm/prisma.service.ts` (~lines 89–151). | **One migration, `add_craft_codes_rates_and_union_kind`: additive DDL plus the epic's one data write.** `kind` is filled for existing rows by **label match — a label containing `non-union`, `non union` or `nonunion`, case-insensitive → `NON_UNION`; everything else → `UNION`** — then made `NOT NULL` (Q19). **The PR description must list every `(tenant, code, label, derived kind)` row for administrator review before merge**; that review is the control, not a test. **`CraftCodeRate.baseRate` is `Decimal(10,4)`** (Q15) — deliberately wider than `Employee.hourlyRate`'s `Decimal(10,2)` (~3501), so a three-decimal legacy rate (`66.180`) would not truncate. `@db.Timestamptz`; `idx_<table>_<column>` / `uq_<table>_<what>` (`contexts/prisma.md`). **The migration must be reversible without data loss** (REQ-23 acceptance). |
| API (`apps/api`) | New `apps/api/src/presentation/craft-codes/` (`craft-codes.controller.ts` + `dto/`), `apps/api/src/usecase/craft-codes/` (`craft-codes.service.ts`, `craft-codes.module.ts`), `apps/api/src/service/craft-codes/` (`craft-codes.repository.ts`). Routes per `spec.md` §4: `GET/POST/PATCH/DELETE /api/v1/craft-codes`, `GET /api/v1/craft-codes/admin`, `GET/POST/PATCH /api/v1/craft-codes/:id/rates`. `@Roles(Role.ADMIN, Role.SUPER_ADMIN)`, exactly as the three existing reference-code controllers. Existing `apps/api/src/presentation/employee-craft-codes/employee-craft-codes.controller.ts` is **kept as an alias** delegating to the new service, returning the unchanged `{ id, code, label, description }` pick-list shape. Register in `app.module.ts`; barrel `index.ts` at every layer boundary. | There is **no** `apps/api/src/service/employee-craft-codes/` today — the existing module is controller + service only, so the repository layer is new rather than moved. Reuse its CRUD shape (REQ-01 note). **Rate validation is union-only**: rejecting a craft that has no rate row would break REQ-10, since non-union crafts are *meant* to have none. Route param is a **UUID `:id`**, matching the existing reference-code modules and diverging from `CLAUDE.md`'s Identity Convention — `spec.md` §4 says follow the existing pattern and flag it, not change convention inside a payroll ticket. |
| Web (`apps/web`) | **No source change.** Must keep compiling. | `N/A — backend only` (`spec.md` §5). ~19 files under `apps/web/src` read `employee-craft-codes` / `craftCodeId` / `unionStatus`. The alias keeps them green — and **nothing they read is being removed**, which makes this unit's compile risk small rather than merely managed. |
| Mobile (`apps/mobile`) | **No source change.** | `N/A — backend only` (`spec.md` §6). `apps/mobile/data/contracts/identity.contract.ts` and the `(field)` screens are the consumers. |
| Shared (`packages/shared`) | Craft-code DTO shape moves with the rename (REQ-25). | **Exact type list `NOT SPECIFIED`** (`spec.md` §7) — whatever `tcg-contract-tracer` finds is imported. Only `@tcg/shared` importers are compile-checked, so the tracer is the gate, not `tsc`. |
| Tests | **Unit:** rate-window boundaries (day before `effectiveFrom`, day of, day of `effectiveTo`, day after); overlapping windows for one craft rejected; **a rate of `66.1800` and a step rate of `0.7500` round-trip without loss at `Decimal(10,4)`**. **Integration (API):** craft-code CRUD and rate CRUD under tenant scope; **a non-union craft with no rate rows is accepted**; a `USER` rejected and an `ADMIN` accepted on every endpoint; `GET /api/v1/employee-craft-codes` and `GET /api/v1/craft-codes` both resolve; a seventh `roleType` value rejected. **Migration:** `kind` derivation — `Non-Union`, `non union`, `NONUNION` → `NON_UNION`; `L12 — Local 12` and any unrecognised label → `UNION`; **afterwards `employee_craft_codes`, `Employee.craftCodeId`, `unionCodeId` and `unionStatus` are present and unchanged**, and the new tables are empty; **the migration is reversible without data loss**. **E2E / manual:** `pnpm build` passes for `@tcg/web` and `@tcg/mobile` with no source change. | `spec.md` §10 rows 1, 19, 24, 25, 26, 27, 28, 30. |

### Reviewable as

- **Demo:** `POST /api/v1/craft-codes` with `{ code: "L12-G2", label, unionCodeId, roleType: "OPERATOR", startDate }` → 201; a craft with `roleType: "MECHANIC"` → 201 (all six admin-selectable, REQ-05). `POST /api/v1/craft-codes/:id/rates` with `{ baseRate: 66.1800, effectiveFrom }` → 201; a second overlapping rate row → rejected. `POST` a **non-union** craft and add **no** rate → accepted. `GET /api/v1/craft-codes` → all three. `GET /api/v1/employee-craft-codes` → the same crafts in the old pick-list shape, unchanged. `POST` as a `USER` → 403. `GET` any union code → it now carries a `kind`.
- **Acceptance:** REQ-01, REQ-02, REQ-03, REQ-05, REQ-06 (fields), REQ-09, REQ-10 (no-rate-rows clause), REQ-23, REQ-25, REQ-28 (CRUD half) acceptance lines in `spec.md` §2.
- **Reviewer can verify without:** U2, U3, U4; without seed data (there is none by design — Q5); without a modifier scale; without the resolver; without any pre-existing craft data, which is now the normal state.
- **Gates:** **`tcg-prisma-guardian` on the migration** — four new tenant-scoped models are absent from the `$extends` allowlist and `spec.md` §3 records that as *a finding, not a detail*; the guardian also sees the one data write. **`tcg-contract-tracer` before the shared DTO shape moves** — that is this unit, and it is **not** about an alias removal: U1 *adds* the alias and never removes it (which ticket removes it is `NOT SPECIFIED`, REQ-25). **`pnpm affected`** green. **Plus one human gate:** the derived `kind` rows, listed in the PR description, read by someone who knows the tenants' labels.

### Risk

- **Weakest source:** `[CONFLICT]` — REQ-01 and REQ-02. The ticket and the staged Confluence page are **one voice, not two**, and that page is CONFLICT-tier because it has never been read against `payroll/codingcops-rule-matrix.md` §B (`PR-009`–`PR-015`) or `payroll/erp-payroll-module-frd/03-…` (`PR-006`–`PR-011`). REQ-10 no longer contributes a conflict here — **Q1 cleared it on `2026-08-25`**, and it cleared by *agreement*: the plan yielded to `PAY-012`, so the planning decision, the vault rule, Brian Petros's written confirmation and the legacy engine's 21,348 rows now all say the same thing.
- **Migration reversible:** **yes, with one asterisk** — and REQ-23's acceptance requires it in as many words. Every DDL step is additive: new tables, new enums, three new columns. Nothing is dropped, renamed, collapsed or copied. The asterisk is `EmployeeUnionCode.kind`: filling it **writes over existing rows**, so re-running is not automatic. **The input survives** — `EmployeeUnionCode.label` and `Employee.unionStatus` both stay — so a wrong derivation **can** be corrected. That is the difference between an asterisk and a one-way door.
- **Behind a flag:** no. `N/A` — nothing in this epic is flagged. The old routes surviving as aliases (REQ-25) is the compatibility mechanism, not a flag.
- **Touches existing data:** **yes, in exactly one place** — every `EmployeeUnionCode` row gains a `kind` derived by string match. No `Employee` row, no `employee_craft_codes` row and no craft row is read or written.
- **Blast radius:** **concentrated in that one derivation, and it is wider than it looks.** `kind` decides **which rate source an employee is priced from** (U4 branches on it) *and* which side of REQ-24's union headcount they land on. Everything else here is additive and inert until someone creates a craft.

**`[UNVERIFIED]` + one data-touching step — raise the derivation, not the unit.** The unit is routine; the label match is the thing to be precise about, and `spec.md` Q19 already states both of its limits:

1. **The rule fails in the safe direction, and that is a property to preserve rather than an accident to tidy up.** An unrecognised label → `UNION` → the resolver looks for a `CraftCodeRate` → on a system that starts empty there is none → **Blocked** (REQ-18), which is loud. The opposite default would route the employee to `Employee.hourlyRate` and **pay them from the wrong source silently**. If anyone later proposes flipping it "so fewer things block", that is the trade.
2. **Fail-loud covers pay, not reporting.** A mis-derived row still lands on the wrong side of REQ-24's union/non-union headcount with **nothing to Block on** — a number moves on a dashboard and no one is stopped.
3. **The match is against per-tenant free text.** A tenant that wrote *"Open Shop"*, *"Merit"* or *"Non Union Admin"* gets `UNION` from a rule that never saw those strings. **Read the labels in the PR, not just the derived values** — the row-by-row listing exists for exactly that.
4. **REQ-01 and REQ-02's `[CONFLICT]` still comes off with a ~27 KB read and no client at all** — §B `PR-009`–`PR-015` and FRD 03 `PR-006`–`PR-011` against REQ-01/02, plus a `tcg-scrum` decision note. Unchanged by the revision, and still worth doing before this merges.

### Deliberately not in this unit

- **Any FCC copy, `-A`/`-B`/`-C` collapse or prefix→`roleType` mapping** — **withdrawn from the epic** (REQ-05, REQ-23; Q14). `CraftCode` starts empty and admins create crafts through the API. Q14's residual `L12-BG-*` question went away with it.
- **Retiring `employee_craft_codes`** — deferred to a **later cleanup ticket** (REQ-23). The legacy table and `craft_codes` coexist, with U1's alias reading the new one.
- **Alias removal** — still a later ticket; how long the aliases live is `NOT SPECIFIED` (REQ-25).
- **Any rate or scale seed** — out of scope (Q5). *"Do not quietly reintroduce this as a seed because the tests need a scale to exist"* (REQ-15).
- **Requiring a rate row on every craft** — REQ-10: non-union crafts are meant to have none.
- **Rounding a rate to cents** — Q15 puts rounding in the ledger only (`PAY-069`), and this epic has no ledger. Store and return four decimals; do not round on write, on read, or in a DTO serializer to make a response look tidy.
- **Adding `PAYROLL` / `CRANE_SUPERINTENDENT` / `DISPATCH` to the `Role` enum** — REQ-28's NOTE. An auth blast radius well beyond this epic, and **no source has asked for it**.

---

## U2 — SCRUM-934 — Craft modifier scale and the tier function

- **Outcome:** A payroll administrator can configure one boom-modifier scale per union code and see, from one endpoint, every tier it generates — number, foot range, adder, code and label, for both roles — with no tier row persisted anywhere and no seed involved.
- **Kind:** vertical
- **Requirements covered:** REQ-11, REQ-12, REQ-13, REQ-14, REQ-16 — fully. REQ-04 — **the step-rate selection half** (a craft's role type selects `operatorStepRate` or `oilerStepRate`, and a role with no step rate earns no modifier); the field itself is U1's. REQ-15 — `[N/A — OUT OF SCOPE]` as a seed; its L12 values are **this unit's test fixture, built in test setup**. REQ-23 — **this unit's table**. REQ-26 — **the scale entity**.
- **Depends on:** U1 — **for the `RoleType` enum only**, so that `stepRateFor(scale, roleType)` compiles.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New `CraftModifierScale` — `unionCodeId`, `initialFt`, `finalFt`, `gapFt`, `operatorStepRate`, `oilerStepRate`, `codePrefixOperator`, `codePrefixOiler`, `labelSuffix`, `status`. **Partial unique index** enforcing at most one `ACTIVE` scale per union code. `ActivityLogEntityType` gains a scale member. Allowlist entry for `craftmodifierscale`. | Migration `add_craft_modifier_scales` — **purely additive, no data write at all**, and the only unit whose migration has none. **No tier rows and no effective dating** (REQ-11) — `SCRUM-934` justifies dropping effective dating with a fact about the legacy rows (`StartDate=04/10/2020`, no `EndDate`), **not** a product decision that rates never change; `PAY-008` still requires effective dating for configuration generally. Do not add it, and do not treat its absence as settled. **Both step rates are `Decimal(10,4)`** (Q15) — precision matters more here than on a base rate, because a step rate is **multiplied by a tier** (up to 18), so a truncation is magnified rather than absorbed. `gapFt > 0` (divisor); `finalFt > initialFt`; whether `finalFt` must be `initialFt + n×gapFt` is `NOT SPECIFIED`. |
| API (`apps/api`) | New `apps/api/src/presentation/craft-modifier-scales/`, `apps/api/src/usecase/craft-modifier-scales/`, `apps/api/src/service/craft-modifier-scales/`. `GET/POST/PATCH /api/v1/craft-modifier-scales`, `GET /api/v1/craft-modifier-scales/:id/preview`. **The pure tier function lives in the service layer** and is called by the preview and, later, by U4's resolver — one function, two callers. `@Roles(Role.ADMIN, Role.SUPER_ADMIN)`. Register in `app.module.ts`. | REQ-16's point is that *"a second implementation would drift"* — put it in the service layer where U4 can reach it without importing upward (`presentation → usecase → service → orm`). Write the tier as **`max(1, ceil((L − initialFt) / gapFt))`**, capped at `ceil((finalFt − initialFt) / gapFt)` — **not** as a `ceil` with an `if L == initialFt` special case, which invites someone to "simplify" it away and silently restores the bug Q11 fixed (REQ-12 note). Gate the adder on **whether the role has a step rate**, never on a list of role names (REQ-04, REQ-14). |
| Web (`apps/web`) | **No source change.** | `N/A — backend only`. Nothing in web reads a modifier scale; there is no existing contract to break. |
| Mobile (`apps/mobile`) | **No source change.** | `N/A — backend only`. |
| Shared (`packages/shared`) | **Nothing.** | `N/A` — no scale type is consumed by web or mobile, so no contract moves and `tcg-contract-tracer` has nothing to trace. |
| Tests | **Unit:** 79 ft → no modifier; **80 ft → tier 1**, `$0.75` operator / `$0.25` oiler; 100 → 1; 101 → 2; 120 → 2; 195 → 6 (`$4.50` / `$1.50`); 200 → 6; 440 → 18. A craft whose `roleType` carries **no step rate** → **no modifier** at 80 ft and at 195 ft — *not* Blocked, *not* the operator rate. The L12 **fixture** reproduces all **33** legacy codes, adders **and label strings** — including the two-digit zero-padded tier (`OP-BP-01`) and the `080-100` / `101-120` tier-1 irregularity. Preview and the tier function agree tier-for-tier. **Integration (API):** scale CRUD under tenant scope; a second `ACTIVE` scale for one union code is **rejected**. | `spec.md` §10 rows 4–8, 17, 18, 19, 20, 28. **Use the legacy table as the fixture, not as a target to hand-tune toward** (REQ-12 note). 18 × 2 = 36 derivable codes against 33 observed — `OI-BP-16/17/18` are brackets no oiler ever worked; **that is not a defect** (REQ-15 note). |

### Reviewable as

- **Demo:** `POST /api/v1/craft-modifier-scales` with the L12 values — `initialFt: 80, finalFt: 440, gapFt: 20, operatorStepRate: 0.7500, oilerStepRate: 0.2500, codePrefixOperator: "OP-BP", codePrefixOiler: "OI-BP", labelSuffix: "Ft-{role}"` → 201. `GET /api/v1/craft-modifier-scales/:id/preview` → **18 tiers × 2 roles**, first row `OP-BP-01` / `080-100Ft-Operator` / `0.75`, tier 6 `OP-BP-06` / `181-200Ft-Operator` / `4.50`, last `OP-BP-18` / `421-440Ft-Operator` / `13.50`. `POST` a second `ACTIVE` scale for the same union code → rejected.
- **Acceptance:** REQ-11, REQ-12, REQ-13, REQ-14, REQ-16 acceptance lines in `spec.md` §2 — and REQ-12's is the strongest evidence in the whole spec: the function reproduces **every one of the 33 legacy adders**, and REQ-13's every one of the 33 code/label pairs.
- **Reviewer can verify without:** U3, U4; without any craft code existing (the preview is driven by the scale, not by a craft); without seed data; without rates. **Not** without U1's `RoleType` enum on the branch.
- **Gates:** **`tcg-prisma-guardian`** on the migration (new tenant-scoped model, allowlist entry). **`tcg-contract-tracer` — not required**: this unit moves no shared contract. **`pnpm affected`** green.

### Risk

- **Weakest source:** `[UNVERIFIED]` — every requirement in this unit. REQ-12/13/14 rest on the `2026-08-24` planning answers (Q11, Q12) **plus** an independent tie-out to the legacy modifier table and MLA Article IV, which is the best-corroborated corner of this epic. **Worth stating as an observation, next to the tag and not instead of it:** the legacy data agrees with the formula at every sampled tier. That agreement is evidence the formula matches what FCC did; it is not confirmation from a person, and it does not upgrade the tag.
- **Migration reversible:** **yes, without an asterisk.** One new table, no drops, no renames, no backfill, **no data written at all**. The only forward-only commitment is the `ActivityLogEntityType` enum member — additive and cheap, but a member other code will start depending on.
- **Behind a flag:** no. `N/A`.
- **Touches existing data:** **no.** Nothing in this unit reads or writes an existing row — the reason it stays the safe unit to lead with if U1 stalls.
- **Blast radius:** contained until U4 exists. A wrong tier function produces a wrong preview, which is visible in the demo and checked against 33 known-correct strings. Once U4 ships, the same function prices real labour — which is why the tie-out test is the acceptance, not a nicety.

**`[UNVERIFIED]` + reversible is the routine case, and this unit is it.** No raise needed. Two things to carry forward anyway, both from `spec.md` §13, because they are unspecified rather than wrong: **what happens above `finalFt`** — Q11's answer introduced a cap that silently prices a 500 ft boom at tier 18 rather than failing, and *no source states a cap is correct*; and **440 ft has no contractual basis at all** — it is the largest bracket anyone happened to key into FCC (one labor row in 86,728), while the MLA's *"each additional twenty (20) feet"* is open-ended. Build the cap as specified; do not invent an alternative, and do not let the cap become an unexamined fact.

### Deliberately not in this unit

- **Any scale seed** — out of scope (Q5). The L12 values are a **fixture built in test setup**. The consequence of no scale existing in the database is intended and specified — REQ-18 returns Blocked until an administrator creates one.
- **Effective dating on the scale** — REQ-11. Do not add it because `PAY-008` requires it generally; that tension is recorded, not resolved.
- **Composing the adder into the base rate** — REQ-20's note is blunt: *"if you find yourself writing `baseRate + boomAdder` anywhere in this epic, stop."* Q3's working decision lives with the payroll-engine ticket, not here.
- **A day-level or aggregate tier method** — the resolver is per-labor-entry by design (REQ-17). `PR-015`'s higher-rate-for-day true-up is a payroll-engine rule under `SCRUM-920`.
- **Rounding an adder to cents** — Q15: rounding lives in the ledger (`PAY-069`), not here. On the L12 values the adder lands on exact cents anyway (`0.75 × 6 = 4.50`) — a property of those inputs, **not** something to enforce with a rounding call.

---

## U3 — SCRUM-927 — Craft assignments, going forward, and the employees who have none

- **Outcome:** An employee created or updated from now on carries exactly one PRIMARY craft assignment — permanent and temporary alike — plus any number of allowed alternates; one admin endpoint lists every employee who still has none; and the employee-list union count reads the primary craft's union kind wherever a PRIMARY exists, falling back to the legacy label where it does not.
- **Kind:** vertical
- **Requirements covered:** REQ-07, REQ-08, REQ-24, REQ-27 — fully, as the `2026-08-25` spec states them. REQ-23 — **this unit's table**. REQ-26 — **the assignment entity**. REQ-28 — **the assignment gate**, which per its own NOTE collapses to the same admin pair and knowingly over- and under-grants.
- **Depends on:** **U1** — assignments hold an FK to `craft_codes`, and REQ-24's filter reads `EmployeeUnionCode.kind`.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New `EmployeeCraftAssignment` — `employeeId`, `craftCodeId`, `assignmentType` (`PRIMARY \| SECONDARY`), **no effective dates**. **Partial unique index** on `(tenant_company_id, employee_id) WHERE assignment_type = 'PRIMARY'`. Unique on `(tenant_company_id, employee_id, craft_code_id)` so the same craft cannot be added twice. `ActivityLogEntityType` gains an assignment member. Allowlist entry for `employeecraftassignment`. | **One migration, `add_employee_craft_assignments`: purely additive — no backfill, no pre-check, no drops.** `employee_craft_codes`, `Employee.craftCodeId`, `Employee.unionCodeId` and `Employee.unionStatus` **all survive** (REQ-23), and the DAS fallback depends on the last of them still being there. **The partial unique constraint is the right shape precisely because it permits zero and forbids two** (REQ-07 note (a)) — which is what "forward-only" means at the data layer, and not something a read-then-write check gets right under concurrency. The enum's own name (`AssignmentType`?) and whether it is a Prisma enum or a `VarChar(50)` are `NOT SPECIFIED`. |
| API (`apps/api`) | New `apps/api/src/presentation/employee-craft-assignments/`, `apps/api/src/usecase/employee-craft-assignments/`, `apps/api/src/service/employee-craft-assignments/`. `GET/POST/DELETE /api/v1/employees/:id/craft-assignments`. **Employee create *and update* require a primary craft** — same validation for `PERMANENT` and `TEMPORARY` (REQ-07, REQ-27); `VendorEmployee` is a different model and **must not acquire an assignment**. **Admin-gated report endpoint** listing every employee with no PRIMARY (REQ-07). **DAS union filter, both call sites:** `apps/api/src/service/employee/employee.repository.ts` line 485 (KPI count) and `apps/api/src/usecase/employee/employee-list.helpers.ts` line 99 (list filter) — each becomes *"primary craft's union code `kind = UNION`, **or** no PRIMARY assignment and `unionStatus = 'Union'`"*. | **Two call sites, not one.** REQ-24's note names only line 485; a grep finds the same literal in `employee-list.helpers.ts`. Fixing one leaves the list and its KPI disagreeing. **Leave the `unionStatus` denormalisation write at `employee.repository.ts` lines 169–186 alone** — the fallback reads that column, so it must keep being maintained. **Do not sync `Employee.craftCodeId` with the new assignment table** (REQ-23 note (a)): two representations are live at once, nothing keeps them in step, no source says anything should, and a sync leaves the cleanup ticket a two-way merge. **The report endpoint is not optional scaffolding** — without it nobody can tell whether the population is shrinking, and the cleanup ticket cannot know when it is safe to run. Gate on `@Roles(Role.ADMIN, Role.SUPER_ADMIN)` and **record the gap** rather than inventing role values (REQ-28 NOTE). |
| Web (`apps/web`) | **No source change.** | `N/A — backend only`. `Employee.craftCodeId` and `unionStatus` are read across ~19 web files — and **neither is being removed**, so the compile risk here is small. |
| Mobile (`apps/mobile`) | **No source change.** | `apps/mobile/data/contracts/identity.contract.ts` and its mocks read the employee shape. Unchanged fields. |
| Shared (`packages/shared`) | `packages/shared/src/types/employee.types.ts` **gains** whatever assignment shape is actually consumed; it **loses nothing**. | **Exact type list `NOT SPECIFIED`** (`spec.md` §7). The tracer gate on this unit is about **the DTO shape only** — an additive change still moves the contract, and only `@tcg/shared` importers are compile-checked. |
| Tests | **Unit:** a SECONDARY assignment alone changes no rate — a resolver call with no `secondaryCraftId` returns the PRIMARY craft regardless of how many SECONDARY rows exist *(asserted here against the assignment model; the resolver half runs in U4)*. **Integration (API):** assignment CRUD under tenant scope; employee **create or update** without a primary craft rejected, `PERMANENT` **and** `TEMPORARY`; **an existing employee with no PRIMARY still loads, saves and lists, and appears in the report endpoint** until one is assigned; an employee can never hold two PRIMARY rows; reassigning **replaces** the primary rather than adding a second; the same craft twice rejected; **no dates persisted**; a `USER` rejected on the report endpoint. **DAS filter, both call sites:** an employee **with** a PRIMARY is counted by their craft's union kind **even when `unionStatus` says otherwise**; an employee **without** one is counted by the legacy string exactly as today. | `spec.md` §10 rows 9, 19, 21, 22, 23. |

### Reviewable as

- **Demo:** `POST /api/v1/employees` without a primary craft → 400, for both `employeeStatus` values; with one → 201. `PATCH` an existing employee that has no PRIMARY, without supplying one → 400. `GET` that same employee → still loads. `GET` the report endpoint → every employee predating this unit; assign one and it drops off the list. `GET /api/v1/employees/:id/craft-assignments` → one PRIMARY. `POST` a second PRIMARY → rejected. `POST` two SECONDARY rows → both listed, **no dates in the response**. `DELETE` one → gone. `GET /api/v1/employees?…` on a tenant whose union-code label is not spelled `Union`: employees **with** a PRIMARY now count correctly; employees without still count the old way.
- **Acceptance:** REQ-07, REQ-08, REQ-24, REQ-27, REQ-28 (assignment half, as far as the `Role` enum reaches) acceptance lines in `spec.md` §2 — including REQ-24's *"on a tenant where no employee has a PRIMARY yet, the counts are **identical to current behaviour**, including its existing case-sensitivity defect"*, which is **every tenant on day one**.
- **Reviewer can verify without:** U2, U4; without a modifier scale; without any rate row; **without any migration having touched an existing row anywhere in the epic**. **Not** without U1 merged — the FK target and `EmployeeUnionCode.kind` both come from it.
- **Gates:** **`tcg-prisma-guardian`** on the migration. **`tcg-contract-tracer` before the DTO shape moves** — **not** before drops, because there are none. **`pnpm affected`** green.

### Risk

- **Weakest source:** `[CONFLICT]` — REQ-07. Its *existence* half is settled by a `[VERIFIED]` decision (`decisions/2026-08-20-craft-locked-rate-override.md`, Corrina Bustos, confirmed by Brian Petros): *"An employee's default base rate comes from their employee-level craft code."* What is **not** settled is whether a single-PRIMARY-plus-alternates model is a correct reading of rule-matrix §B `PR-015` (*"Employee works at multiple qualifying rates → identify higher qualifying rate and create true-up component"*, marked *New ERP requirement, union/legal interpretation required*). **Nobody has checked.** REQ-08 is `[UNVERIFIED]` and carries its own unconfirmed edge: Q10's two-object reading — undated eligibility row plus a dated per-day choice on the labor entry — is an answer from the acting product owner, and **Corrina Bustos, the decision's own owner, has not confirmed it.**
- **Migration reversible:** **yes.** One additive table, two indexes, one enum member. **Nothing is dropped, backfilled or transformed**, and no existing row is written.
- **Behind a flag:** no. `N/A`.
- **Touches existing data:** **no.** No employee row is read or written by the migration. The *behaviour* change reaches an existing employee only when someone updates them.
- **Blast radius:** the sharp edge is **operational drift, not data loss**. Nothing breaks on merge; instead the system runs in a **split state** — some employees with an assignment, some without, a DAS filter reading two sources depending on which, and two live representations of an employee's craft that nothing keeps in step. Payroll cannot price anyone still in the second group, and the report endpoint is the only thing that makes that population visible.

**`[CONFLICT]` + fully reversible — no pre-build raise is required for the migration.** Three things still want a person, and the third is the one this shape actually costs:

1. **REQ-07's flag comes off with the same ~27 KB read as U1's** — §B `PR-009`–`PR-015` and FRD 03 `PR-006`–`PR-011` against REQ-07, plus a `tcg-scrum` decision note. **`PR-015` specifically**: does single-PRIMARY-with-alternates satisfy the higher-rate true-up requirement, or contradict it? Free, and needs no client.
2. **REQ-08's two-object reading needs Corrina Bustos**, because it reinterprets *her own* verified decision's *"a secondary craft code assigned for that day"* as two objects rather than one. Ask before the assignment table's shape is frozen — adding `effectiveFrom`/`effectiveTo` later is a migration on live payroll data.
3. **"Forward-only" has no defined end, and the cleanup ticket is blocked on it.** Nothing says who works the report endpoint's list down to zero, by when, or what happens if it never reaches zero — and the ticket that drops `Employee.craftCodeId` and the DAS fallback **cannot run until it does**, because REQ-07's invariant is its precondition. On day one *every* existing employee is in that population. `spec.md` §11 makes the same point about the data-entry work generally: it *"has no ticket, no owner and no estimate anywhere in `SCRUM-926`"*. **That is a release-planning commitment, not a build risk, and it is the sort that surfaces a quarter later.**

### Deliberately not in this unit

- **The PRIMARY backfill and the null-`craftCodeId` pre-check** — **withdrawn from the epic** (REQ-23; Q14, Q17). Q17 is moot: it existed to decide what the pre-check did.
- **Retiring `employee_craft_codes`, `Employee.craftCodeId`, `Employee.unionCodeId` and `Employee.unionStatus`** — **deferred to a later cleanup ticket, which runs once REQ-07's report endpoint shows no employee lacking a PRIMARY.** Three things it inherits, recorded here so they are not rediscovered: the tracer must run before its drops; the DAS fallback branch goes with `unionStatus`; and **`Employee.hourlyRate` is not in its scope** — under REQ-10/REQ-19 that column is live, not legacy.
- **Syncing `Employee.craftCodeId` with the new assignment table** — REQ-23 note (a) says plainly not to. Write to the new one; leave the old column alone.
- **Dropping `Employee.hourlyRate` / `payRateOT` / `payRateDB`, and the `payRateDB → payRateDT` rename** — deferred (intent §5), and for `hourlyRate` now **actively wrong**: U4 reads it for non-union employees.
- **Effective dates on `EmployeeCraftAssignment`** — REQ-08: *"dating belongs on the labor entry."*
- **Enforcing that a labor entry's `secondaryCraftId` is one of the employee's SECONDARY rows** — REQ-08: *"enforced by the labor-entry ticket, not here."* This epic supplies the list that ticket validates against.
- **Fixing the union filter's case-sensitivity defect** — REQ-24 preserves it for the un-migrated population **deliberately**. A "fix" here moves numbers on a dashboard with no ticket asking for it.
- **Craft promotion history** — assignments are current state; the activity log is the history (intent §5).
- **A `DISPATCH` path for creating a temporary employee's PRIMARY** — REQ-28's NOTE: the role value does not exist, this **under-grants knowingly**, and inventing the enum value is out of scope.

---

## U4 — SCRUM-935 — `CraftRateResolverService`

- **Outcome:** The payroll engine (later tickets under `SCRUM-920`) has one call that turns an employee, a work date, an optional secondary craft and an optional boom length into a base rate, a boom adder and a modifier code/label — **union priced from the craft's rate row in force on the work date, non-union from that employee's own `hourlyRate`** — returning a Blocked result instead of throwing when the data is not there.
- **Kind:** vertical **— with a demo caveat, settled.** By `SCRUM-935` and REQ-17 this is a **service with no HTTP surface**. It passes the vertical test in the sense that matters (one whole piece of behaviour, reviewable against the spec on its own, and what `SCRUM-929`/`930` are being written against) but it **cannot be demonstrated with curl**. **Q16 is answered and now lives in REQ-17's own notes**: the test suite plus U2's preview endpoint are the review surface, and **no diagnostic endpoint is added**. It is **not** a layer split: there is no other slice to merge it into, because its consumer is a different epic.
- **Requirements covered:** REQ-10, REQ-17, REQ-18, REQ-19, REQ-20 — fully, as the `2026-08-25` spec states them. REQ-06 — **the window-check half**; the fields were U1's.
- **Depends on:** **U1** (craft codes, rate rows, validity windows, and the `kind` the branch reads), **U2** (the scale and the tier function it must call rather than reimplement), **U3** (the PRIMARY/SECONDARY assignments `resolveEmployeeCraft` reads).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | **None.** | `N/A — no schema change, therefore no migration.` The only unit in the epic with neither. It reads U1's, U2's and U3's tables, plus `Employee.hourlyRate`, through repositories. |
| API (`apps/api`) | New `apps/api/src/usecase/craft-rate-resolver/craft-rate-resolver.service.ts` (+ module, barrel). **Exactly the three methods `SCRUM-935` specifies** — `resolveEmployeeCraft(employeeId, secondaryCraftId?)`, `resolveBaseRate(...)`, `resolveBoomAdder(...)`. **No controller, no route, no DTO.** `resolveBaseRate` **branches on `craft.unionCode.kind`**: `UNION` → the `CraftCodeRate` in force **on the work date**; `NON_UNION` → **`Employee.hourlyRate` as it currently stands**. Calls U2's tier function; does **not** reimplement it. | Layering is `presentation → usecase → service → orm`, never upward. **Build exactly three methods; do not add a day-level variant** — that rule belongs to the payroll engine under `SCRUM-920` (REQ-17). **Return `baseRate` and `boomAdder` as distinct values and compose nothing** (REQ-20). **The branch keys on `kind`, never on the craft's code prefix** — `PAY-009` derives payroll *group* from the prefix, a different question, and `ADMIN-*` is a naming convention, not a guarantee. **Every *union* lookup is keyed by the work date; the non-union read is the deliberate exception** (REQ-17). `resolveBoomAdder` takes `boomLengthFt` **from the entry** — Q2 confirms the boom length is chosen on the labor entry at ticket close and **never derived from the unit**; capturing it is the labor-entry ticket's work. The `SCRUM-928` extension point is *left*, not built. |
| Web (`apps/web`) | **No source change.** | `N/A — backend only`, and nothing in web can reach a service with no route. |
| Mobile (`apps/mobile`) | **No source change.** | `N/A — backend only`. |
| Shared (`packages/shared`) | **Nothing.** | `N/A` — the return type is consumed by the API only. No contract moves; the tracer has nothing to trace. |
| Tests | Every resolver row in `spec.md` §10 — rate-window boundaries (day before `effectiveFrom`, day of, day of `effectiveTo`, day after); craft window outside `startDate`/`endDate` → Blocked; secondary craft passed in **overrides** the primary; a SECONDARY row alone changes no rate; boom below `initialFt` → no modifier; 80 ft → tier 1; 195 ft → tier 6 (`$4.50` / `$1.50`); a role with **no step rate** → no modifier, **not** Blocked; missing rate in force → Blocked; missing active scale with a boom length present → Blocked; inactive craft → Blocked. **The branch:** a **union** employee whose `hourlyRate` differs from their craft rate resolves to the **craft rate**; a **non-union** employee resolves to **their own `hourlyRate`**, and two non-union employees on the **same** craft with **different** `hourlyRate` values resolve **differently**; a non-union craft with **no** `CraftCodeRate` rows **resolves successfully rather than Blocking**; **`payRateOT` and `payRateDB` are referenced on no resolver path**. **Integration (API):** on a freshly migrated database every **union** call returns Blocked until rates are entered. | `spec.md` §10 rows 1–3, 10–16, 18, 29. **The union/non-union pair is the acceptance test for the rate model** — it is the assertion that fails if someone later "simplifies" the branch away. |

### Reviewable as

- **Demo:** **`N/A — no HTTP surface by specification` (REQ-17), and that is the settled answer, not an unresolved gap.** Reviewed through **(a)** `pnpm nx run @tcg/api:test` over the cases above, each traceable to a `spec.md` §10 row, and **(b)** `GET /api/v1/craft-modifier-scales/:id/preview` from U2, a genuine curl demo of the adder arithmetic because it calls **the same tier function**. What (b) does not demonstrate — rate resolution, the union/non-union branch, work-date keying, the Blocked paths — is (a)'s alone, so **the test list is the acceptance artefact and no case in it is optional**. REQ-17's notes are explicit that a `craft-rate-resolver` route must **not** be added to make the unit demonstrable.
- **Acceptance:** REQ-06 (window half), REQ-10, REQ-17, REQ-18, REQ-19, REQ-20 acceptance lines in `spec.md` §2 — including REQ-19's mechanical one: *"a grep of the resolver and its repository shows **no reference to `payRateOT` or `payRateDB`** on any path."* Note the schema column is `payRateDB` while `SCRUM-935` writes `payRateDT`; the rename has not happened, so grep the real name.
- **Reviewer can verify without:** a UI, a seed, a real tenant, or a running database for the pure-function cases. **Not** without U1, U2 and U3 merged.
- **Gates:** **`tcg-prisma-guardian` — not required**: no schema change. **`tcg-contract-tracer` — not required**: no shared contract moves. **`pnpm affected`** green. The gate that binds here is the test list.

### Risk

- **Weakest source:** `[CONFLICT]` — **REQ-20 only, and that is a real improvement.** REQ-10's flag cleared on `2026-08-25` when Q1 resolved in `PAY-012`'s favour; the rate-source model is now backed by the planning decision, the vault rule, Brian Petros's written *"very important"* confirmation and the legacy engine's 21,348 rows, which makes it **the best-corroborated requirement in the spec that is not a specific dollar figure**. What remains is REQ-20: `PAY-011` and MLA Article IV say the boom premium goes **into** the base rate before multipliers; the `2026-08-20` meeting notes say **on top**. **Q3 chose "on top, unmultiplied" as a working decision and the `[CONFLICT]` was deliberately kept**, because that sides against contract text, which a planning decision does not amend. **TCG payroll / labor counsel must confirm.** It does not block this epic: the resolver returns two values and composes nothing.
- **Migration reversible:** **`N/A` — no migration.** No column added, dropped or backfilled.
- **Behind a flag:** no. `N/A`.
- **Touches existing data:** **no** — read-only. It now reads a column (`Employee.hourlyRate`) that an earlier plan was going to stop reading, which is why that column must **not** appear in any future cleanup ticket's drop list (REQ-19, REQ-23).
- **Blast radius:** nothing in production calls this service when it ships — its consumer is a later epic. The radius is **forward**, and in two directions. A wrong `EmployeeUnionCode.kind` from U1's label match **routes an employee to the wrong rate source entirely**: `UNION` when they should be `NON_UNION` means Blocked (loud); `NON_UNION` when they should be `UNION` means **paid from `hourlyRate` silently**. And the interface itself is what `SCRUM-929`/`930` are being written against.

**`[CONFLICT]` + no migration — but two things here are expensive to undo, and neither is in the database.** `spec.md` §2b counts *a published API shape* as one-way, and this is one: three signatures and a return type another epic is already writing against. The second is the **rate model in production** — once payroll prices non-union labour from `Employee.hourlyRate`, paid timecards conform to it. What still wants a person:

1. **Q3's confirmation, and it is the only live conflict in this unit.** Someone with labor-counsel standing must confirm "on top, unmultiplied" against MLA Article IV's *"The additional rate added to the regular rate shall be the base rate when computing overtime pay."* Two things go to the `SCRUM-920` ticket with it, from REQ-20's notes: **on-top-unmultiplied means the adder needs *boom hours* as its own quantity**, a different shape from every premium that rides the base rate; and **the ADP export is affected** — `PAY-067` is `status: conflicted`, **no `LB` earning code appears anywhere in the vault**, and the nearest written analogue is the `FRT`/`MLT` REG/OT/DT/TRI shape. **Do not invent the code set.**
2. **Q18's reading is recorded but not durable.** The `[VERIFIED]` `decisions/2026-08-20-…` is read as *scoped to union crafts*, which is what makes reading `Employee.hourlyRate` compatible with it. That reading currently lives in REQ-19's *Conflict* paragraph; **`tcg-scrum` owes the clarification note in `.ai/vault/decisions/`**, and until it exists the next reader of that decision has no way to know it was scoped.
3. **The non-union rate has no history, and `PAY-012`'s own blocking item says so.** Reading `hourlyRate` as it stands means a recalculation of a *past* period returns *today's* rate — which contradicts `PAY-008` (*"Historical recalculation must use rules effective on the work date"*) and is exactly `PAY-012`'s unconfirmed *"rate-effective-date handling"*. **Q1 scoped that out of this epic explicitly; it did not make it untrue.** Whoever builds retroactive correction (`PAY-068`) meets it first.

### Deliberately not in this unit

- **Any HTTP route, controller or DTO** — REQ-17, and Q16 settled it in favour of adding nothing. A diagnostic endpoint is now a decision to reopen with the product owner, not a judgement call for the executor.
- **`baseRate + boomAdder`, anywhere** — REQ-20. The composition belongs to the payroll-engine ticket, which now carries Q3's working decision *and* its unresolved conflict with Article IV.
- **Reading `Employee.payRateOT` or `Employee.payRateDB`** — REQ-19 is absolute for these two: never read, by anyone. Only `hourlyRate`, only on the `NON_UNION` branch.
- **Effective-dating the non-union rate** — REQ-10 states plainly there is none in this epic; the resolver reads the column as it stands.
- **Deriving union-ness from the craft code's prefix** — `PAY-009` uses the prefix for payroll *group*, a different question. Branch on `kind`.
- **A day-level or per-timesheet resolver method** — `PR-015` belongs to the payroll engine. *"Nothing here aggregates a day."*
- **Rejecting an off-list `secondaryCraftId`** — REQ-08: `NOT SPECIFIED`, and `SCRUM-935` does not include it.
- **Severities on the Blocked cases** — `NOT SPECIFIED`; `PAY-060`'s own blocking item is that the severity matrix is unconfirmed. *"Do not assign severities."*
- **A `PayrollIssue` table to store Blocked results in** — `PAY-060`'s scope. Return the result; do not invent a table.
- **An employee-specific rate override** — `SCRUM-928`, out of scope (intent §5). **The revision makes this closer than it was:** a per-person non-union rate *is* an employee-level rate, and `SCRUM-928` / `PAY-CC-03` are the ticket for adjusting it. Leave the extension point; do not let the branch grow an override path.

---

## Sequencing

```
U1 (SCRUM-925) ──┬──────────────▶ U3 (SCRUM-927) ──┐
                 │                                 ├──▶ U4 (SCRUM-935)
                 └──▶ U2 (SCRUM-934) ──────────────┘
```

**Unchanged in shape by the `2026-08-25` revision; substantially weaker in force.** U3 → U1
and U4 → U1+U2+U3 hold: `EmployeeCraftAssignment` holds an FK to `craft_codes` and REQ-24's
filter reads `EmployeeUnionCode.kind` (both U1); the resolver reads rate rows and `kind` (U1),
the scale and tier function (U2) and the assignments (U3). **"U1 and U2 in parallel" remains
corrected to: developable in parallel, merged strictly in order, U1 first.**

- **Parallelisable:** **U1 and U2 only, and only in development.** They share five files and
  one enum, and each is a real collision:
  - `apps/api/prisma/schema.prisma` — both add models. One file, two branches: a textual
    merge conflict, and the second to merge regenerates.
  - `apps/api/prisma/migrations/` — Prisma applies migrations in **lexical folder order**. Two
    branches each generating a timestamped folder apply out of order on any database that
    already ran the first. The second to merge **rebases and regenerates**.
  - `ActivityLogEntityType` (`schema.prisma` line 109) — U1 adds craft-code and rate members,
    U2 a scale member, U3 an assignment member. **Three units, one enum.**
  - `apps/api/src/orm/prisma.service.ts` lines 89–151 — every unit adds to the `$extends`
    allowlist. Same block, four edits.
  - `apps/api/src/app.module.ts` — every unit registers a module.
  - **The `RoleType` enum** — U2's `stepRateFor(scale, roleType)` will not compile without it,
    and U1 owns it. U2 can be *written* against the two step rates and wired to `RoleType` at
    the end, which is what makes parallel development real rather than nominal; it cannot be
    *merged* first.

  U3 and U4 are **not** parallel with anything: U3 needs U1 merged, U4 needs all three.

- **Merge order constraint:** **`U1 → U2 → U3 → U4`, and it is now an ordinary ordering rather
  than a data-safety one.** This is the biggest practical change the revision brought, so it is
  worth being explicit about what went away. An earlier plan carried **four** load-bearing
  constraints — backfill after the FCC collapse, drops after a verified backfill, `kind`
  derived before `unionStatus` was dropped, and a fix window closing on a drop migration.
  **All four are gone**, because nothing is copied, collapsed, backfilled or dropped. What
  remains:
  1. **U1 before U3** — a real FK dependency (`employee_craft_assignments.craft_code_id` →
     `craft_codes.id`) plus `kind` for the DAS filter. Ordinary.
  2. **U1 before U2** — only to keep the `schema.prisma` / migrations-folder conflict window
     short and put `RoleType` on `main` first. A convenience, not a safety property.
  3. **U1's `kind` derivation should still be reviewed before U4 merges**, because U4 is what
     turns a wrong `kind` into a wrong rate source. That review is U1's own PR gate, so
     ordinary merge order satisfies it — but it is the one place where being casual still
     costs money rather than time.

  U2 may merge after U3 without harm; second keeps the schema-conflict window shortest.

- **First unit to ship: U1.** Nothing blocks it, and it still proves the most:
  1. **That the `kind` label match holds against real tenant labels.** This is the epic's only
     data write and, through U4's branch, the thing that decides which rate source each
     employee is priced from. The PR carries every `(tenant, code, label, derived kind)` row;
     **that review is the single highest-value five minutes in the epic**, and `spec.md` Q19
     names its two blind spots — reporting is not fail-loud, and the labels are free text.
  2. **That the alias strategy keeps web and mobile compiling.** ~19 web files and the mobile
     identity contract read the current shape. Lower stakes than before — nothing they read is
     removed — but still the cheapest place to find out.
  3. **That an admin can actually build a craft code from nothing.** With no data migration,
     **every craft code, rate, scale and assignment in the system will be typed in by a
     person.** U1's API is where that starts. `spec.md` §11 is blunt that this work *"has no
     ticket, no owner and no estimate anywhere in `SCRUM-926`"* and is now the whole FCC craft
     catalogue plus one PRIMARY per employee. **Confirm that ticket exists before U1 starts,
     not after U4 merges.**

  Leading with U2 remains the fallback if U1 stalls: it touches no existing row, writes no
  data and is fully reversible.
