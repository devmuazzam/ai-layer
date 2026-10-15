# Units — ADP-PAYDATA-EXPORT (provisional id; Q17 — no ticket, feature branches only)

> Written 2026-10-15 from `spec.md` beside it, **including §12.5 (developer resolutions, Ali Riaz,
> 2026-10-15)**. Phase 1 = **union field (`L12_FIELD`) only, CSV only**. Nothing here is built.
>
> **Read before slicing further.** §12 carries five questions the decomposer added (Q19-Q23). Two of
> them gate units (Q22 gates U3; Q23 shapes U2/U8/U9) and are structural, so they are a developer's
> call, not mine. Items marked **(→ Brian)** stay `[UNVERIFIED]`; no unit resolves one by inference.
> Branch names use the folder name because Q17 says no ticket id exists: `feat/ADP-PAYDATA-EXPORT-u<n>-<slug>`.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | A tenant has an ADP code / Hours-slot mapping table, seeded with the documented codes and placeholder rows (foundation) | REQ-12, REQ-14 (tables only), REQ-19 (placeholder rows only) | schema, api | — | M | not started |
| U2 | `GET periods/:id/export.csv` returns the real ADP paydata CSV for primary rows (Reg/OT, DT, HOL, SUB) with the derived file name and Batch ID | REQ-01, 02, 04, 05, 06, 07 (verbatim), 08, 09, 10, 17, 18 (omit), 20 (primary part), 22 (L12_FIELD filter) | api | U1 | M | not started |
| U3 | Lattice oiler hours reach the exporter as `LATTICE_OI`, not folded into operator; every premium component carries a structured code + bucket | REQ-15 (operator/oiler part; bucket = engine as-is) | engine, api, schema (if Q22 = a) | U2 | M | **blocked on Q22 (developer)** |
| U4 | The CSV carries temp-rate rows for boom, lattice, shift, foreman and military hours, with the right Hours-4 slot and Temp Rate | REQ-12, 13, 14, 20 (row order) | api | U1, U3 | M | not started |
| U5 | The CSV carries `BASE_RATE_OVERRIDE` rows where the labor-entry craft rate differs from the employee's base rate | REQ-16 | api | U4 | M | not started |
| U6 | The export refuses, naming the employee, when the file would be wrong (missing/duplicate primary, unpaired code, hours with no rate, non-zero hours on a placeholder or unmapped code) | REQ-21, REQ-11 (refusal only), REQ-19 (refusal only), REQ-07 (non-empty only) | api | U5 | M | not started |
| U7 | A payroll admin can view and edit the ADP mapping rows in the ERP (reference-code-list pattern) | REQ-12/14/19 (editability, §12.5 Q5-Q9) | api, web | U1 | M | not started |
| U8 | The web Download button produces the ADP CSV, per-employee export UI is gone, and the EXPORTED stamp moves to CSV generation | REQ-23 (web part), REQ-22 | api, web | U6 | S | not started |
| U9 | The readable xlsx workbook, per-employee export, `toAdpWorkbookRows` and `exceljs` are removed; seed path retargeted | REQ-23 (remainder), REQ-22 (NON_UNION_SALARY row), REQ-03 (dropped) | api, engine | U8 | M | not started |

**Counts.** 9 units — 1 foundation (U1), 8 vertical.

- **Requirements in spec: 23. In the ledger: 23.** Requirements not covered by any unit:
  - **REQ-03 (xlsx form)** — dropped by developer decision, Q2 (§12.5). U9 removes the xlsx; no unit builds one.
  - **Parts of REQ-11 / REQ-19** — the *emission* of H2x/Special-Saturday/2x-boom hours and of guarantee, rest, WTL, accumulator and added-hours components. Covered only as **rows in the table (U1) and a refusal (U6)**. Real codes and emission shape are (→ Brian) and Q19. No unit sends them.
  - **REQ-07 format check** — only today's non-empty gate; the format rule is Q20.
  - **REQ-21 full list** — only the conditions in the spec's acceptance line and PQ engine section 6 categories; the 22 code names are (→ Brian), Q18.
  - **REQ-18** — omit `SIC` (Q15). No unit builds a sick-hours source.
- **Units blocked on an open question:** **U3 — Q22** (how a component carries its code/bucket; structural, developer's call). U4, U5, U6, U8, U9 inherit that block through the stack. U2, U1, U7 are not blocked. Q19, Q20, Q21, Q23 do **not** block: each unit states the stated assumption it builds against.
- **Ripple:** 7 of 9 units touch already-shipped behaviour (U1 and U7 are new surface only, apart from a settings tab / tenant seed). Every one carries a regression row in *Slice contents -> Tests*; the ones that retarget behaviour with **no existing test** are named in *Ripple* as `none — unbuilt` and are part of the unit.

---

## U1 — ADP mapping reference table (schema + migration + seed + repository)

- **Outcome:** The API can read, for a tenant, which real ADP code and which slot (Reg, O/T, Hours-3 pair n, Hours-4 slot n, Earnings 3) each internal pay component maps to — seeded so a new and an existing tenant both have the documented codes.
- **Kind:** foundation — one migration consumed by **U2, U4, U5, U6, U7** (five units). Splitting it per consumer would be five migrations against one table. Not "cleaner" — avoided duplication.
- **Requirements covered:** REQ-12, REQ-14 (the code/slot tables as data), REQ-19 (placeholder rows for D-002/003/004/005/009 only — no emission).
- **Depends on:** —
- **Branch / PR base:** `feat/ADP-PAYDATA-EXPORT-u1-adp-code-map` from `origin/main`.
- **Size estimate:** ~190 source lines, 7 source files (seed constants are the bulk). Within 400 / 25.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New tenant-scoped model for the mapping (UUID PK, `tenantCompanyId`, internal component code, ADP code, slot kind + index, active flag, placeholder marker, `@@unique([tenantCompanyId, <componentCode>])`). **Exact columns/types/nullability are the developer's call (CLAUDE.md) — executor lists options and stops.** | Migration `<ts>_adp_code_map`, committed. Tenant-scope allowlist entry in the `$extends` client. Insert of seed rows per existing tenant lives in the migration SQL (excluded from budget). |
| API (`apps/api`) | Repository (read: list active by tenant, find by component code); tenant-seed constants + wiring in `tenant-seed.service.ts` for new tenants. | Business code mint: this is a config table, no `entity_sequences` prefix unless the developer says otherwise. Reuse check: `EmployeeUnionCode`/`Industry` are the nearest reference tables (patterns.md P2). |
| Web | N/A — U7. | |
| Mobile | N/A | |
| Shared | N/A | |
| Tests | Repository test: tenant A cannot read tenant B rows; seed produces the documented rows; placeholder rows are marked and inactive. | Tenant isolation test is the guardian's first question. |

**Seed content (stated, each from the spec).** Known codes `[UNVERIFIED]`: `DT` (REQ-10), `HOL` (REQ-10), `LBH/LBO/LBD/LBT` (REQ-13), lattice `LPR/LPO/LPD/LPT` and `LOR/LOO/LOD/LOT`, shift `S2*/S3*`, foreman `FR*`, military `ML*` with their slots (REQ-12/14), `SUB` (REQ-17), `SIC` (inactive — Q15 omits it). **The caller's list named `DT, LBH, LBO, LBD, MLR/MLO/MLD, SUB, SIC`; the spec documents the rest too (REQ-10/12/14), and U4 cannot emit lattice/shift/foreman without them. Seeding the whole documented set is my reading — confirm or trim.** Placeholder rows (no real ADP code, inactive): guaranteed hours (D-002), rest premium (D-003), WTL/missed meal (D-004), Special Saturday (D-005), accumulators (D-009), `H2x`, `LB 2x`. Temp-rate values are **not** stored here (U4 uses the engine component's own `rate`; REQ-14 table values are reconciliation targets) — whether to store them is structural, flagged.

### Reviewable as

- **Demo:** run the migration on a seeded DB; `select * from <table> where tenant_company_id = …` shows the documented rows; a second tenant shows its own copy.
- **Acceptance:** REQ-12 slot map (20 slots + FR/ML = 28) resolves code -> slot; REQ-14 code families present; no placeholder row carries a guessed ADP code.
- **Reviewer can verify without:** U2-U9; no export needed.

### Risk

- **Weakest source:** `[UNVERIFIED]` (every code and slot is vault-sourced, never human-adjudicated).
- **Migration reversible:** yes — new table; `DROP TABLE` reverses it. The per-tenant seed insert is deleted with it.
- **Behind a flag:** no — nothing reads it until U2.
- **Touches existing data:** adds rows for existing tenants (backfill in the migration); modifies none.
- **Blast radius:** a wrong code row here is wrong in ADP only once U2 reads it; editable in U7.
- **`[UNVERIFIED]` + hard to undo?** No (reversible, editable). Routine. Re-confirm source: `payroll/adp-api-responses/pay-data-input-meta.md`, and (→ Brian) the golden file (Q18).
- **Triggers:** `tcg-prisma-guardian` (new table, tenant allowlist, migration). No contract-tracer (no response shape). No provenance.

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| none — new surface only | `git grep -n -i adp apps/api/prisma/schema.prisma` found only `Employee.adpFileNumber` (spec section 3); no existing ADP code/slot table | N/A | `spec.md` section 3 |
| Tenant seed (`tenant-seed.service.ts`, `utility/tenant-seed.types.ts`) | extended seed list | existing tenant-seed spec stays green + new rows asserted | `spec.md` section 12.5 Q5-Q9 |

### Deliberately not in this unit

- Admin CRUD / web tab — U7.
- Real codes for D-002/003/004/005/009, H2x -> HDD, Special-Saturday boom code — (→ Brian); the rows exist as placeholders only.

---

## U2 — ADP paydata CSV, primary rows

- **Outcome:** A payroll admin calling `GET periods/:id/export.csv` on an approved period gets `EPI4RZnn.csv` with one primary row per `L12_FIELD` employee: Co Code, Batch ID, File #, Reg Hours, O/T Hours, DT and HOL Hours-3 pairs, SUB Earnings 3 — unused pairs omitted, zeros blank.
- **Kind:** vertical.
- **Requirements covered:** REQ-01 (decided: CSV target, Q1), REQ-02, REQ-04, REQ-05, REQ-06, REQ-07 (File # emitted verbatim), REQ-08, REQ-09, REQ-10, REQ-17, REQ-18 (omit `SIC`), REQ-20 (primary rows + name/File # sort), REQ-22 (filter to `L12_FIELD`). Not REQ-11/12-16 (U3-U5), REQ-21 (U6).
- **Depends on:** U1.
- **Branch / PR base:** `feat/ADP-PAYDATA-EXPORT-u2-paydata-csv` stacked on U1's branch.
- **Size estimate:** ~330 source lines, 8 source files (batch fn ~45, CSV builder ~170, service method + gate extraction ~80, controller ~20, module wiring ~15). If the gate extraction makes this exceed 400, split the batch/filename function into its own PR first — do not take a `size-exception`.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | no schema change |
| API (`apps/api`) | (1) **One isolated function** `deriveAdpBatch(periodEnd: Date/ISO) -> { fileWeek: 'nn', batchId: 'YYMMWW', fileName }` — Q3: from the pay-period **end (Friday)** date, week = ISO week, Batch = YY+MM+WW. Pure, no I/O, own file. (2) Pure CSV builder under `usecase/payroll/` taking the engine result + the tenant mapping rows (U1) and returning text: dynamic header (a pair is written only if some row uses it), repeated header names literal, zero -> blank, code never without amount, `csvField` RFC 4180 quoting (reuse the existing `csvField`, do not duplicate). (3) `PayrollService.exportPaydata(periodId, userId)`: the existing gates (R6) **extracted** into a private `assertExportable(period)` shared with `exportWorkbook`, then `rebuildEngineResult`, filter to `payrollGroup === L12_FIELD`, build, return `{ filename, csv }`. **Does not stamp `EXPORTED`** (see Risk). (4) Controller `exportCsv` retargeted to `exportPaydata`; content type `text/csv`, `.csv` extension. | **Engine is not touched and does not import the mapping.** `ADP_COMPANY_CODE` stays a constant (D3 default; not changed here). Assumes Q23 option "keep `export.csv` path"; if the developer answers differently the controller line moves. |
| Web | N/A — U8 | web still calls the xlsx route until U8. |
| Mobile | N/A | |
| Shared | N/A | |
| Tests | Unit: `deriveAdpBatch` (the two documented examples `260936` for 2026-08-22 -> 08-28 and week `36` are *observations the vault records, not an oracle* — the vault itself says they conflict with the PQ rule, REQ-04; the test pins the Q3 decision, not ADP truth). Unit: header/order/pair omission/zero-blanking on a synthetic fixture (REQ-08), `SUB` is one weekly sum in Earnings 3, no `SIC`. Integration: `exportPaydata` respects every gate in `exportWorkbook`'s regression suite. | **Regression for the extracted gates**: the existing `payroll.service.spec.ts` blocks at 991, 1301 (TCG-163 missing file), 1557, 2279 and `payroll-incomplete-tickets.spec.ts:914` must stay green *and* a parallel case must hit `exportPaydata` for each gate. |

### Reviewable as

- **Demo:** approve a seeded `L12_FIELD` week, `GET /v1/payroll/periods/:id/export.csv` — header `Co Code,Batch ID,File #,Reg Hours,O/T Hours,…`, one row per employee, file name `EPI4RZnn.csv`.
- **Acceptance:** REQ-02/04/06/08/09/10/17 acceptance lines; REQ-05 and REQ-04 *as decided by Q3* (scheme is (→ Brian)).
- **Reviewer can verify without:** U3-U9 — premium hours are absent but the file is internally consistent.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-02/04/06/08/09/10/17 all); Batch ID and File # are decided-but-(→ Brian).
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no — but the route is unreachable from the web until U8, and **`exportPaydata` deliberately does not set `EXPORTED`**. Reason: `[UNVERIFIED]` file format + an irreversible stamp ("once EXPORTED nothing in it can be priced again", `payroll.service.ts` comment) = commitment is delayed to U8. The old xlsx path keeps stamping until then.
- **Touches existing data:** no.
- **Blast radius:** the CSV is **incomplete** (no premium rows) until U4-U6 land. A person who calls `export.csv` directly and imports it into ADP before U6 would under-pay premium hours. **Do not release U2-U7 to a production tenant individually; ship U2-U9 together.** Stated as the cross-PR window.
- **Q21 assumption:** the extracted File # gate keeps looking at *every* employee (today's behaviour, R6), pending Q21.
- **Triggers:** none of prisma-guardian (no schema), contract-tracer (`export.csv` response is `text/csv` text — its body changes shape; web does not consume it: `git grep export.csv -- apps/web` empty, to be re-run), provenance (no pay rule). Executor runs a body-shape grep of consumers.

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `GET periods/:id/export.csv` readable-layout CSV (`payroll.controller.ts`) | retargeted body | integration test on new body; the *old* body has **no test today -> none — unbuilt, and not needed** (replaced) | `spec.md` section 12.5 Q16 |
| `exportWorkbook` gates (R6) | extracted into `assertExportable` | existing specs listed above + parallel `exportPaydata` cases | `spec.md` R6 "unchanged" |
| `exportWorkbook` itself (R1) | shared helper | existing specs unchanged | removed in U9 |
| `findEmployeesMissingAdpFile` | called by `exportPaydata` | `xlsx-rows.spec.ts` stays green | `spec.md` R6 |
| `csvField` (R2) | reused from `payroll-export.ts` | covered by the builder test | removed/moved in U9 |

### Deliberately not in this unit

- Temp-rate rows and `Temp Rate` column — U4. Override rows — U5. Validation refusals — U6.
- `EXPORTED` stamp — U8.
- File # format check — Q20. `SIC` — Q15 (omit).

---

## U3 — Component identity and the lattice operator/oiler split (TCG-163) — **blocked on Q22**

- **Outcome:** An oiler's lattice hours are exported as `LATTICE_OI`, an operator's as `LATTICE_OP`; the legacy workbook's `Lattice Oiler` column stops reading 0 (it is removed in U9, so this is the observable proof until U4). Every premium component also carries the structured hour bucket U4 needs.
- **Kind:** vertical (engine -> persisted component -> exporter-visible result; the legacy workbook column is the visible proof).
- **Requirements covered:** REQ-15 — **the operator/oiler part only** (decided Q11 / D-lattice). Bucket attribution = the engine's per-component hours as-is (decided Q10). Which cranes trigger lattice stays (→ Joe/Kyle) and is not touched.
- **Depends on:** U2 (stack/ordering only; any schema it adds must migrate after U1). Gate: **Q22 answered by a developer**.
- **Branch / PR base:** `feat/ADP-PAYDATA-EXPORT-u3-component-identity` stacked on U2's branch.
- **Size estimate:** ~180 source lines, 9 source files (types, `addComponent` + ~8 call sites, `xlsx-rows` lattice, `rebuildEngineResult` mapping, repository persist, `week-pricing-override`/`payroll-explain` if option (a)).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | **Only if Q22 = (a):** add the structured code and bucket columns to the persisted pay-component row; migration `<ts>_pay_component_code_bucket`. If Q22 = (b) none. | **Do not choose.** Options: (a) structured `componentCode` + `bucket` on `PayComponent` and the row; (b) a distinct `ruleId` for `LATTICE_OI` by data change, bucket stays in the label (then U4 cannot select Hours-4 slots without parsing the label — I do not offer label parsing). Existing rows would need a backfill under (a); executor must state it. |
| API (`apps/api`) | `rebuildEngineResult` maps the new field(s) back into engine components; repository persists them; `week-pricing-override` (fold key `[ruleId,label,rate]`) and `payroll-explain` read components — both must not merge an operator and an oiler into one line. | `payroll.repository.ts:1289-1313` is where components are written/matched. |
| Web | N/A | |
| Mobile | N/A | |
| Shared | N/A — `PayComponent` is exported by `@tcg/payroll-engine`, not `packages/shared`. Confirm with `git grep PayComponent -- packages/shared apps/web apps/mobile` (expected empty; if not, contract-tracer). | |
| Engine (`packages/payroll-engine`) | `PayComponent` gains the identity field(s) per Q22; `addComponent` takes them; premium call sites (`PAY-043`, `-044`/job-premium loop, `-036/-037`, `-070`, `-071`) pass them. `xlsx-rows.ts`: `latticeOper` sums `LATTICE_OP` components, `latticeOiler` sums `LATTICE_OI`; the "KNOWN MIS-MAPPING" comment is deleted. | **No dependency on the DB mapping** — the engine emits internal codes only. |
| Provenance | New or amended row in `.ai/vault/payroll/payroll-rules-provenance.md` section 3 for the operator/oiler lattice attribution, **same commit** as the engine change. Sources to cite: the engine's own comment (Corrina, 2026-08-04 payroll-process call — the two columns are the client's intended shape; "ruled by syed haris 2026-09-22 — log it, leave the code"), `payroll/gaps.md` TCG-163 entry (line ~4811), the developer decision 2026-10-15 (Ali Riaz, `spec.md` section 12.5 Q11). **Status cannot be `Confirmed`: no client member ruled on this; mark `Pending` with owner (→ Joe/Kyle for which cranes, → Brian for the ADP codes).** | `contexts/payroll-engine.md` rule: no engine pay-rule change without its source in the same commit. No amount changes (both premiums were already priced $1.00 / $0.50); the change is attribution. |
| Tests | Engine: operator and oiler on the same day produce two separately-coded components; ST/OT/DT buckets carried structurally; `calculate.spec.ts:989` (the existing `toAdpWorkbookRows` lattice assertion) updated. Persist round-trip: write -> `rebuildEngineResult` -> same codes. | Engine tests run against `dist/` — `pnpm nx run @tcg/payroll-engine:build` first. |

### Reviewable as

- **Demo:** a seeded job with one operator and one oiler on a lattice crane; the legacy workbook (still present) shows $1.00 hours under `Lattice Oper` and $0.50 hours under `Lattice Oiler`, where before both were under Oper.
- **Acceptance:** REQ-14 operator/oiler distinction; Q11 decision; provenance row present in the same commit.
- **Reviewer can verify without:** U4 (no Hours-4 rows yet).

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-14/15); the split itself is a developer decision, not a client ruling.
- **Migration reversible:** yes if (a) — a nullable column drop; backfill (if any) is derivable. Executor states it.
- **Behind a flag:** no.
- **Touches existing data:** (a) adds a column on persisted components; old rows read as "no code" and U4 must treat that as a stated condition (recalculate vs. refuse — decide with Q22). Not decided here.
- **Blast radius:** wrong attribution here sends oiler hours under operator's code at $1.00 instead of $0.50 once U4 runs — a money error. This is why it is its own unit and precedes U4.
- **`[UNVERIFIED]` + hard to undo?** Mild: a persisted column plus rows already carrying codes. Settling source: Joe/Kyle on triggering cranes; Brian on `LPx/LOx`.
- **Triggers:** `tcg-prisma-guardian` (if (a)); `tcg-contract-tracer` (exported `PayComponent` type: grep apps/web, apps/mobile, packages/shared); **provenance entry required** (`payroll-engine.md`).

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `toAdpWorkbookRows` lattice columns (R3), `calculate.spec.ts:989`, `xlsx-rows.spec.ts` | `PAY-044` filter | updated assertions on both columns | `spec.md` Q11 |
| `week-pricing-override.ts` component fold (key `[ruleId,label,rate]`) | persisted components | **none — unbuilt**: add a test that operator + oiler lines are not merged | `spec.md` Q11 (inferred need; executor confirms by reading the file) |
| `payroll-explain.ts` | component rows with `ruleId` regex checks | **none — unbuilt** | same |
| Persisted `PayrollComponent` rows (existing periods) | repository | round-trip test; backfill test if (a) | Q22 |
| `seed-payroll-demo.ts`, `seed-data.ts` (LATTICE_OP/LATTICE_OI premium rows) | premium type rows | unchanged; assertion that both stay `PAY-044` | no change decided |

### Deliberately not in this unit

- Which cranes trigger lattice (→ Joe/Kyle). Shift/foreman/military *code* emission — U4.

---

## U4 — Temp-rate rows for boom, lattice, shift, foreman, military

- **Outcome:** An employee with boom, lattice, shift, foreman or military hours gets a temp-rate row in the CSV per File # + ADP code + Temp Rate, each with exactly one Hours-4 pair in the slot the mapping gives.
- **Kind:** vertical.
- **Requirements covered:** REQ-12, REQ-13, REQ-14, REQ-20 (within-employee row order: primary, then temp-rate rows; sort of equal codes by rate — v5.1 rule, noting the PQ v3.8 within-type order differs and the vault does not say which holds; the v5.1 sort is used and flagged).
- **Depends on:** U1 (slots), U3 (component code + bucket), U2 (builder).
- **Branch / PR base:** `feat/ADP-PAYDATA-EXPORT-u4-temp-rate-rows` stacked on U3's branch.
- **Size estimate:** ~260 source lines, 5 source files. Within budget.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API (`apps/api`) | Extend the pure builder: group components by `(File #, ADP code, Temp Rate)` summing hours over the week; look up code + slot from the mapping; `Temp Rate` column present when any row carries one; Hours-4 pairs 01-28 written only if used; same code at two rates -> two rows. Primary row's Reg/O-T hours are **not** reduced by premium hours (boom/lattice/shift hours are a subset of worked hours — column-rules). | `Temp Rate` = the engine component's `rate` (premium x multiplier, `calculate.ts` lines ~301/324/365). Whether the engine's rates reconcile with the workbook's REQ-14 table (e.g. shift/foreman "folded into base rate") is something the executor can only check against a real week — **(→ Brian)**, Q18; a reconciliation test is written with the table values as expected numbers and *any mismatch is reported, not adjusted*. |
| Web / Mobile / Shared | N/A | |
| Tests | Unit: two adders -> two rows; same adder two days -> one row summed; one pair per rate row; `LBH 4` at `0.75` and `LBO` at `1.125` (REQ-13 acceptance); lattice operator and oiler on separate rows/codes (U3). | |

### Reviewable as

- **Demo:** seeded week with a boom day: CSV has the extra row with `Temp Rate` and one Hours-4 pair.
- **Acceptance:** REQ-12 and REQ-13 acceptance lines, REQ-14 "each code resolves to its slot".
- **Reviewer can verify without:** U5, U6.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A. **Behind a flag:** no. **Touches existing data:** no.
- **Blast radius:** wrong Temp Rate or code = wrong pay in ADP after import. Mitigation is U6's refusals and the human ADP import (REQ-02 manual acceptance), (→ Brian).
- **Triggers:** none of the three guardians (no schema/shape/rule change). Boom hours here: executor re-reads the unit's section 11a with `git grep`.

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `lbSt/lbOt/lbDt/lb2x/lb3x`, `craftModifier` columns (R1/R3) | same fields feed the new rows; old columns removed in U9 | primary-row tests from U2 remain green | `spec.md` Q16 |
| The U2 builder | extended | U2's builder tests stay green | — |

### Deliberately not in this unit

- `lb2x` (Special-Saturday boom) and `h2x` (HDD) rows: **no code** (Q8, (→ Brian)). U6 refuses on them.
- Guarantee, rest, WTL, accumulators: Q5-Q7, Q9, (→ Brian).

---

## U5 — `BASE_RATE_OVERRIDE` rows

- **Outcome:** Where an employee worked at a labor-entry craft rate different from their ADP base rate, the CSV carries an override row — hours with a dollar `Temp Rate` and no Hours-4 pair — and those hours leave the primary row.
- **Kind:** vertical.
- **Requirements covered:** REQ-16 (decided D-override / Q12), REQ-20 (override row order: after PRIMARY, before TEMP_RATE).
- **Depends on:** U4.
- **Branch / PR base:** `feat/ADP-PAYDATA-EXPORT-u5-base-rate-override` stacked on U4.
- **Size estimate:** ~230 source lines, 5 files — **assuming the labor-entry craft rate and the employee base rate are already on the persisted data the exporter reads.** If either is not, the executor stops: that would be a schema change nobody has decided, and this unit becomes two.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A (unless the stop above applies) | |
| API (`apps/api`) | Builder: group job-day hours by `(File #, override rate)`; emit a row with Reg/O-T/DT/HOL hours and `Temp Rate` = the rate; subtract those hours from the primary row; rule-of-thumb from the v5.1 engine doc section 2 (merge rules; bounds `0 < rate <= 999.9999`; five `BASE_OVERRIDE_*` error codes) is read by the executor from `payroll/adp-workbook-v5.1-engine.md` section 2 — I did not re-read it. | **Row semantics — full base rate vs difference — are (→ Brian).** Build the documented structure (v5.1 section 2 as the vault states it: the override is the dollar rate); a test pins it; flagged `[UNVERIFIED pending Brian]`, easy to change in one function. H2x hours on an override row are not emitted (Q8). |
| Web / Mobile / Shared | N/A | |
| Tests | Unit: same employee, two craft rates -> primary + one override; hours conserved (primary + override = week total); rate bound; no override when rates equal. | |

### Reviewable as

- **Demo:** seeded employee with a labor entry at a craft rate above their base: CSV has the override row, primary hours reduced by exactly that amount.
- **Acceptance:** REQ-16 mechanism as documented (`spec.md` REQ-16 Sources); conservation of hours.
- **Reviewer can verify without:** U6.

### Risk

- **Weakest source:** `[UNVERIFIED]`, row semantics (→ Brian).
- **Migration reversible:** N/A. **Behind a flag:** no. **Touches existing data:** no.
- **Blast radius:** high — an override at the wrong semantics pays the whole row at a wrong rate. This is the unit most likely to be wrong against ADP; schedule the human ADP import against it (REQ-02 manual).
- **`[UNVERIFIED]` + hard to undo?** The file is regenerable until the period is stamped (U8) — reversible until then.
- **Triggers:** none by rule; flag to `tcg-prisma-guardian` only if the stop fires.

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Primary row from U2/U4 | hours subtraction | U2/U4 tests stay green; new conservation test | `spec.md` REQ-16 |
| `NON_UNION_SALARY` row (R5) | n/a | untouched | removed in U9 |

### Deliberately not in this unit

- Full-rate vs difference semantics — (→ Brian). The "special agreement" per-employee rate (SCRUM-928) — no ERP field; not built.

---

## U6 — Pre-export validation that refuses

- **Outcome:** The export refuses to produce a file, naming the employee and the condition, when the file would be wrong — missing or duplicate primary, an unpaired code/amount, hours with no rate, a code not active in the tenant's mapping, or non-zero hours on an unmapped/placeholder component (H2x, 2x boom, guarantee, rest, WTL).
- **Kind:** vertical.
- **Requirements covered:** REQ-21 (the conditions in its acceptance line and PQ engine section 6 categories), REQ-11 and REQ-19 (**refusal only**), REQ-07 (non-empty only, Q20).
- **Depends on:** U5 (needs all row types to validate), U1.
- **Branch / PR base:** `feat/ADP-PAYDATA-EXPORT-u6-paydata-validation` stacked on U5.
- **Size estimate:** ~210 source lines, 5 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API (`apps/api`) | Pure validator over the assembled rows + mapping; ERROR vs WARNING; `exportPaydata` throws a `BadRequestException` naming at most three employees (match `adpFileMissingException` / web `adp-export-refused-error.ts` wording style) when any ERROR; produces nothing. Existing refusals (R6) retained as-is. | **Stated assumption on Q19:** a non-zero hour/dollar on a placeholder or absent mapping row is an **ERROR (refuse)**. Sourced to crosswalk rule 7 and `spec.md` REQ-19 ("the ERP must not report phantom hours"), both `[UNVERIFIED]`; it is the least-harm behaviour, not a decision. If Q19 = omit+warn it is a three-line change. |
| Web | The existing web refusal parser (`adp-export-refused-error.ts`) already surfaces the API message; confirm it does not key on the old text. | |
| Tests | Integration: one case per condition, export refused and `EXPORTED` not set (stamp is in U8; test asserts no file). Unit: validator table. | |

### Reviewable as

- **Demo:** seed an employee with `h2x` hours: export returns 400 naming the employee and "Special Saturday hours have no ADP code".
- **Acceptance:** REQ-21 acceptance line verbatim.
- **Reviewer can verify without:** the web.

### Risk

- **Weakest source:** `[UNVERIFIED]`; the full 22-code list is not in the vault (→ Brian, Q18).
- **Migration reversible:** N/A. **Behind a flag:** no. **Touches existing data:** no.
- **Blast radius:** a too-aggressive ERROR blocks every export for the tenant; a too-lax one lets a short file through. Both visible at demo time.
- **Triggers:** none.

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Export gates (R6), `adpFileMissingException` | validator runs after them | existing gate specs stay green | `spec.md` R6 |
| Web refusal handling (`adp-export-refused-error.ts`, `payroll-export-blockers.ts` + `.test.mjs`) | message text | existing `.test.mjs` stays green; **none — unbuilt** for the new message shape; add a web lib test if the parser keys on text | `spec.md` R6 |

### Deliberately not in this unit

- File # format check — Q20. Remaining validation codes — (→ Brian).

---

## U7 — Edit the ADP mapping in the ERP

- **Outcome:** A payroll admin can see the mapping rows in Settings, change a code or slot, activate a placeholder once Brian supplies the real code, and archive a row.
- **Kind:** vertical.
- **Requirements covered:** §12.5 Q5-Q9 "editable in the ERP (reference-code-list pattern)"; REQ-12/14/19 as editable data.
- **Depends on:** U1. (Independent of U2-U6 — parallel, see Sequencing.)
- **Branch / PR base:** `feat/ADP-PAYDATA-EXPORT-u7-adp-map-admin` stacked on U1 (or from `origin/main` once U1 merges).
- **Size estimate:** ~330 source lines, 10 source files (controller, usecase service, module, 2 DTOs, app.module registration; web tab + service/hook factories + settings tab registration). Within budget.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API (`apps/api`) | List (picker/admin), update, soft-archive, create — per `patterns.md` P2 (`findReferenceCodesPaginated`, `mapWriteError`, soft-archive to `INACTIVE`). **Variant B (no repository layer) vs C (industries — repository extending `BaseRepository`) is structural: the developer picks; candidates: `employee-union-codes`, `industries`.** Permission: `payroll-admin` `edit` (same as the export) unless the developer says otherwise. | Placeholder -> real code activation is an ordinary edit; no special endpoint. Siblings (CLAUDE.md): the other P2 modules are siblings of the *pattern*, not of this change; confirm none needs this change. |
| Web (`apps/web`) | A tab via the shared `reference-code-manager.tsx` + `createReferenceCodeService` / hook factories (W2). Reuse before creating: run `find-component`. `data-testid` scheme per `contexts/web.md`; autofill hooks on any raw control. | UI copy not specified — executor asks. |
| Mobile / Shared | N/A | |
| Tests | API: tenant isolation on the list; archive keeps the row; unique-per-tenant error surfaced. Web: `browser-autofill-coverage` stays green. | |

### Reviewable as

- **Demo:** Settings -> ADP codes tab; edit the Special-Saturday placeholder row's code; reload shows it; it appears for no other tenant.
- **Acceptance:** §12.5 Q5-Q9 "editable".
- **Reviewer can verify without:** U2-U6.

### Risk

- **Weakest source:** `[UNVERIFIED]` (data it edits); the editing pattern itself is sourced (`patterns.md` P2).
- **Migration reversible:** N/A. **Behind a flag:** no. **Touches existing data:** no.
- **Blast radius:** an admin changing a live mapping changes the next export; no history of edits is specified (audit: `NOT SPECIFIED`, `spec.md` section 11).
- **Triggers:** `tcg-prisma-guardian` not needed (no schema); `tcg-contract-tracer` for the new list shape is cheap (new surface).

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Settings tab list / shared manager | registration of one new tab | existing settings tab test/coverage stay green | `patterns.md` W2 |
| none else — new surface | `git grep -i adp -- apps/web/src/features/settings` to re-confirm before build | N/A | — |

### Deliberately not in this unit

- Effective-dating of mappings (crosswalk rules 1 and 12) — not requested in section 12.5.

---

## U8 — Web Download produces the CSV; EXPORTED stamp moves to the CSV

- **Outcome:** The payroll worklist Download button saves `EPI4RZnn.csv`; the per-employee export action is gone; the period is stamped `EXPORTED` when the CSV is generated.
- **Kind:** vertical.
- **Requirements covered:** REQ-23 (web part; Q16), REQ-22 (Phase 1 scope visible: the download is the field file only).
- **Depends on:** U6 (the CSV must be complete before the button points at it).
- **Branch / PR base:** `feat/ADP-PAYDATA-EXPORT-u8-web-csv-cutover` stacked on U6.
- **Size estimate:** ~130 source lines, 8 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API (`apps/api`) | `exportPaydata` now calls `updatePeriodStatus(EXPORTED)` (Q16: "EXPORTED stamp stays on CSV generation"); the *old* `exportWorkbook` stops stamping in the same PR so a period is never stamped twice. | The only API change; one commit, one place. |
| Web (`apps/web`) | `payroll.service.ts` `downloadExport(periodId)`: GET the CSV route, fallback name `EPI4RZ.csv`, drop the `employeeId` branch; `use-payroll.ts` remove `useExportEmployee`; `use-payroll-employee.ts` remove the per-employee export action + `isExporting`; `use-payroll-worklist.ts` unchanged call; `payroll-download.ts` (`saveWorkbook`) CSV mime; `payroll-adp-submit-dialog.tsx` text/comment if it says "workbook". | **UI copy for the button/dialog is not specified (`spec.md` section 5) — executor lists current strings and asks.** `grep -rn 'data-testid' <removed button>` against `qa-automation/e2e` before removing any id (CLAUDE.md contract). |
| Mobile | N/A (`git grep export -- apps/mobile` empty, re-run) | |
| Shared | N/A | |
| Tests | Web lib test for the download filename/mime (the existing `payroll-export-blockers.test.mjs` stays green); API: stamp is set exactly once, and not set when validation refuses. | |

### Reviewable as

- **Demo:** approve a week in the UI, click Download -> `EPI4RZnn.csv` saved; period shows `EXPORTED`; no per-employee export on the employee screen.
- **Acceptance:** Q16 (web Download = CSV, stamp on CSV).
- **Reviewer can verify without:** U9.

### Risk

- **Weakest source:** `[UNVERIFIED]`; the CSV's ADP-importability has never been tested by a human with ADP access — REQ-02 manual acceptance. **This is the first unit that stamps, so it is the unit where an unconfirmed source becomes costly to undo.** Settle before U8 is merged: a human imports a generated file (needs the ADP import docs and golden file, Q18, (→ Brian)).
- **Migration reversible:** N/A. **Behind a flag:** no — recommend the developer treats the U8 merge as the go-live point.
- **Touches existing data:** stamps periods `EXPORTED` (irreversible per the code comment).
- **Blast radius:** an exported-but-wrong period cannot be repriced.
- **Triggers:** `tcg-contract-tracer` (response of the download route changed content type: re-run the four searches; web and mobile).

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| R4 `downloadExport`, `useExportPeriod`, `use-payroll-worklist.ts:255` | web service | web test for the new service + manual demo | `spec.md` Q16 |
| R4 `useExportEmployee`, `use-payroll-employee.ts:217` | hook | **none — unbuilt**: removal; assert no import remains (typecheck + grep) | `spec.md` Q16 "per-employee export replaced entirely" |
| `payroll-adp-submit-dialog.tsx` (comment/copy) | import | typecheck | Q16 |
| API `exportWorkbook` stamp (R1) | one-time move | existing specs that assert the status stamp updated | Q16 |

### Deliberately not in this unit

- Deleting the API xlsx/per-employee routes and builders — U9. Window: between U8 and U9 the routes exist but nothing calls them.

---

## U9 — Remove the readable workbook, per-employee export and `toAdpWorkbookRows`

- **Outcome:** The old xlsx workbook, the per-employee export route, `buildAdpWorkbook`, `toAdpWorkbookRows`/`AdpWorkbookRow` and `exceljs` no longer exist; the demo seed exports through the CSV.
- **Kind:** vertical (removal; the visible proof is that every export path is the CSV and the seeded demo still reaches `EXPORTED`).
- **Requirements covered:** REQ-23 remainder, REQ-22 (the `NON_UNION_SALARY` row goes), REQ-03 dropped (Q2).
- **Depends on:** U8.
- **Branch / PR base:** `feat/ADP-PAYDATA-EXPORT-u9-remove-workbook` stacked on U8.
- **Size estimate:** ~310 source lines (mostly deletions), 8 source files. Within budget.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API (`apps/api`) | Delete `payroll-export.ts` (`buildAdpWorkbook`; move `csvField` into the U2 builder if it lives there), `exportWorkbook`, `exportEmployeeWorkbook`, controller `exportEmployee` / `exportPeriod` (xlsx) routes (per Q23's answer); `staircase-seed.service.ts:331` calls `exportPaydata` instead; drop `exceljs` from `apps/api/package.json` after `git grep exceljs` shows no other user. | If the seed's export now refuses (U6) the seed fails — the executor fixes the seed data, never the validator. |
| Engine (`packages/payroll-engine`) | Remove `toAdpWorkbookRows`, `AdpWorkbookRow`, their `index.ts` exports and spec. **Keep `findEmployeesMissingAdpFile`** (the gate uses it); it lives in `xlsx-rows.ts` — renaming that file is a structural choice for the developer, not done silently. `calculate.spec.ts:989` retargeted to assert the component-level facts instead. | After removal rebuild `dist` (`@tcg/payroll-engine:build`); `@tcg/payroll-engine` is consumed as built `dist/`. |
| Web | N/A (done in U8) | |
| Mobile | N/A | |
| Shared | `packages/shared/src/constants/payroll-issue-severity.ts` comments mention `toAdpWorkbookRows` — update the comments only. | |
| Tests | Remove tests for deleted code; add: grep-level check that no symbol is left dangling (typecheck of api, web, engine); the seed path test (`staircase-seed` spec if present, else the executor adds one) proves the demo tenant reaches `EXPORTED` via the CSV. | |

### Reviewable as

- **Demo:** run the staircase seed; the period ends `EXPORTED`; `git grep -n -E 'buildAdpWorkbook|toAdpWorkbookRows|AdpWorkbookRow|exportEmployeeWorkbook|exceljs'` returns nothing.
- **Acceptance:** Q16 "replaced entirely"; the 8 consumers below all resolved.
- **Reviewer can verify without:** ADP access.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-23 was `[OPEN]`, now decided).
- **Migration reversible:** N/A. **Behind a flag:** no. **Touches existing data:** no.
- **Blast radius:** an external caller of the xlsx route breaks (API users outside the web). `git grep` finds none in this repo; unknown outside it.
- **Triggers:** `tcg-contract-tracer` (removed routes and exports; four independent searches).

### Ripple — the 8 consumers in `spec.md` section 11a

| # | Existing consumer | Resolved by | Regression proof | Source |
| --- | --- | --- | --- | --- |
| R1 | `exportWorkbook` / `exportEmployeeWorkbook`, `EPI4RZ<YYYYMMDD>` name | deleted (U9); replaced by `exportPaydata` (U2) with the Q3 name | `exportPaydata` suite from U2 | Q16 |
| R2 | `buildAdpWorkbook` / `csvField` | deleted; `csvField` reused from U2 | U2 builder tests | Q16 |
| R3 | `toAdpWorkbookRows`, `findEmployeesMissingAdpFile`, `AdpWorkbookRow`, `xlsx-rows.spec.ts`, `calculate.spec.ts:989` | first two: `toAdpWorkbookRows` + type deleted; `findEmployeesMissingAdpFile` kept; specs retargeted | `findEmployeesMissingAdpFile` tests kept | Q16 |
| R4 | web `downloadExport`, `useExportPeriod`, `use-payroll-worklist.ts`, `use-payroll-employee.ts` | retargeted in U8 | U8 | Q16 |
| R5 | `NON_UNION_SALARY` workbook row | deleted with the builder; salary stays hand-keyed | n/a | Q13, Q14 |
| R6 | export gates + `adpFileMissingException` | **kept** (U2 extraction) | existing specs + parallel cases (U2) | `spec.md` R6 |
| R7 | `GET …/employees/:employeeId/export` | route deleted | typecheck + route grep | Q16, Q23 |
| R8 | `staircase-seed.service.ts:331` | retargeted | seed test | Q16 |

### Deliberately not in this unit

- Renaming `xlsx-rows.ts` / moving `findEmployeesMissingAdpFile` — developer's call.

---

## Sequencing

```
U1 ──▶ U2 ──▶ U3* ──▶ U4 ──▶ U5 ──▶ U6 ──▶ U8 ──▶ U9
  └──▶ U7                  (* blocked on Q22)
```

- **Parallelisable:** **U7 with U2-U6.** U7 touches `app.module.ts`, a new `usecase/adp-code-map/` folder, `features/settings/*`; U2-U6 touch `usecase/payroll/*`, `presentation/payroll/payroll.controller.ts`, and (U3) `packages/payroll-engine` + `payroll.repository.ts`. The only shared file is `app.module.ts` (one import line each); the shared **table** is read-only for U2-U6 and written only by U7 — no schema collision. **No other pair is parallel:** U2-U6 all extend the same builder file and `payroll.service.ts`; U3 may add a migration, and U1's migration is first.
- **Merge order constraint:** migrations land in unit order — **U1 (`adp_code_map`), then U3 (`pay_component_code_bucket`, only if Q22 = a)**. Stacked PRs: each unit branches from the one it depends on; when U1 merges GitHub retargets U2 to `main`.
- **Cross-PR windows (stated, per rule):**
  1. **U2 -> U8:** `export.csv` returns a CSV that lacks premium and override rows until U4-U5 and refuses nothing until U6; web does not call it and it does not stamp. **Do not release U2-U7 to a production tenant individually.**
  2. **U8 -> U9:** the xlsx and per-employee routes still exist but nothing in `apps/web` calls them.
  3. **U3 (if Q22 = a):** old persisted components have no code; U4 must refuse or recalculate such periods — the answer belongs with Q22.
- **First unit to ship:** **U1** is the only possible first (foundation). The first *user-visible* unit is **U2**; it tests the riskiest assumption cheaply — that a file with the layout in the vault imports into ADP without "Reject values" — because a human with ADP access can import U2's output for a no-premium week long before U4-U6 exist. **Recommend that import happen at U2**, not at U8: it needs the golden file and import docs (Q18, (→ Brian)) and is where the file format `[UNVERIFIED]` + the (not yet irreversible) design is cheapest to correct. The second riskiest assumption — that a persisted component can carry identity — is U3, and is gated on Q22.

## Decisions I am not making (for the developer)

| Where | Decision | Options found |
| --- | --- | --- |
| U1 | Table columns / types / nullability; whether temp-rate values live in the table | spec section 11b D-map fixes only "component -> ADP code + Hours-slot" |
| U3 / Q22 | How a component carries its code + bucket | (a) structured fields + migration, (b) distinct `ruleId`, no bucket |
| U7 | Pattern variant | P2 B (`employee-union-codes`) vs C (`industries`) |
| U9 | Where `findEmployeesMissingAdpFile` lives after the workbook is gone | stay in `xlsx-rows.ts` / move |
| Q23 | Final route shape | keep `export.csv` / make `export` return CSV / both |
| D3 | `4RZ` constant vs tenant setting | left as the existing constant, unchanged |
