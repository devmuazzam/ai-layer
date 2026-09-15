# Units — SCRUM-EMPLOYEE-PROFILE Employee Profile

> Written to `.ai/aidlc/SCRUM-EMPLOYEE-PROFILE/units.md` from the approved `spec.md` beside
> it (revision 2, all 31 requirements `[UNVERIFIED]`, zero `[OPEN]` — every §12 question
> `resolved — see decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md`,
> cited below as **DEC-0915**). Consumed by `tcg-executor`, one unit at a time.
>
> **Standing constraints carried from the ticket, binding on every unit below:**
> (1) the whole document is one ticket landing on `main`; (2) sections are `SectionCard`
> accent-header cards, the agency-form look; (3) Department, Role and Employee Type are
> moved, never changed; (4) **no unit touches `qa-automation/`** — the existing employee
> E2E specs are expected to break on `employee-wizard-*` IDs, the fifth required field and
> detail-page InfoRow labels, per instruction 4 and spec §11a/§13, and that breakage is not
> this ticket's to fix; (5) **no unit touches `packages/payroll-engine`** —
> `contexts/payroll-engine.md` forbids a pay-rule change without a provenance entry, and
> none of DEC-0915's pricing questions (over-scale, salary amount, subsistence) has one; the
> two REQ-31 worklist filters live in `apps/api/src/usecase/payroll` and ship with their
> `payroll/payroll-rules-provenance.md` rows in the same commit as the only exception to
> "no provenance work this ticket."

## What a unit is

A unit is a vertical shippable slice, reviewable on its own. Two of the eight below are
justified deviations from that rule and say so in their own block: **U1** is a
`kind: foundation` schema/shared unit (eight later units share its one migration on
`employees`), and five of the API units (U2–U6) are demonstrated by direct API call
(integration test or `curl`/Postman against the running endpoint) rather than a browser
click — legitimate here because every REQ-06…REQ-31 acceptance line in `spec.md` §2 is
written as request/response behaviour, independently of whether the web form has caught up
yet. Where that creates a real rollout gap against the *still-live* wizard, it is named in
that unit's **Risk** block and in **Sequencing**, not hidden.

## Fill rules

Every field is required per unit. Unfilled fields take `NOT SPECIFIED`, `N/A — <reason>`.
No unit here depends on an `[OPEN]` requirement — the spec has none. Every requirement
carries `[UNVERIFIED]`; per §2b of the decomposer's own rules this does not block a unit,
it constrains reversibility — see each unit's **Risk** block, and U1's in particular, where
`[UNVERIFIED]` meets a `NOT NULL` backfill.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Schema, migration+backfill and shared enums/derivation for the whole profile | REQ-06(schema), REQ-07(schema), REQ-08(schema/shared), REQ-09(shared/backfill), REQ-11(schema), REQ-12(schema), REQ-13(schema), REQ-18(schema), REQ-19(schema), REQ-25(confirm no drop), REQ-27(shared) | schema, shared | — | M | not started |
| U2 | Employee status vocabulary + payroll status field + SSN masking, at the API | REQ-04(api), REQ-06(api), REQ-07(api field), REQ-26(confirm) | api | U1 | M | not started |
| U3 | Compensation Type becomes the source of Pay Type/Payroll Group; exceptions + hide-never-clear | REQ-08(api), REQ-09(api), REQ-18(api), REQ-20(api) | api | U1, U2 | M | not started |
| U4 | Craft-Based Hourly payroll profile — validation, eligibility, secondary crafts, union, over-scale, subsistence | REQ-10(api), REQ-13(api), REQ-14(api), REQ-15(api), REQ-16(api), REQ-19(api) | api | U1, U2, U3 | L | not started |
| U5 | Salaried and Hourly Non-Craft payroll profiles — validation, union, salary frequency | REQ-11(api), REQ-12(api), REQ-17(api), REQ-27(api) | api | U1, U2, U3 | M | not started |
| U6 | Payroll worklist and export exclude Hold/ineligible employees, with a visible issue | REQ-31, REQ-07(worklist effect), REQ-18(week-card display) | api, web (payroll feature) | U1, U2 | M | not started |
| U7 | The employee create/edit page becomes one sectioned form, wizard removed | REQ-01, REQ-02, REQ-03(web), REQ-05(web), REQ-08(web), REQ-10(web), REQ-11(web), REQ-12(web), REQ-13(web), REQ-14(web), REQ-15(web), REQ-16(web), REQ-17(web), REQ-18(web), REQ-19(web), REQ-20(web), REQ-21, REQ-22, REQ-23, REQ-25(web), REQ-26(web), REQ-27(web), REQ-28, REQ-29, REQ-30(form IDs) | web | U1, U2, U3, U4, U5 | L | not started |
| U8 | Detail page mirrors the sections; list and status controls follow the new vocabulary | REQ-24, REQ-06(web), REQ-04(web) | web | U1, U2, U3, U4, U5 | M | not started |

- Requirements not covered by any unit: **none** — all 31 appear above (several across more
  than one unit, by surface).
- Units blocked on an open question: **none** — `spec.md` §12 has zero `[OPEN]` rows.

---

## U1 — Foundation: schema, migration/backfill, shared enums and derivation

- **Outcome:** every employee row carries a Compensation Type and a Payroll Status, and
  `packages/shared` exposes the enums, labels and the compensation-type-aware
  `derivePayrollGroup`/`payrollSetupWarnings` that every later unit builds on. Nothing is
  reachable from a browser or an API call yet — that is the justified exception below.
- **Kind:** `foundation` — eight later units (U2–U8, plus U6's worklist filter) all read
  columns this one migration adds to `employees`, and all read the shared enums/derivation
  this unit adds. Splitting the migration per-unit means up to eight migrations against the
  same table; splitting `derivePayrollGroup`'s three branches (SALARIED, HOURLY_NON_CRAFT,
  CRAFT_HOURLY) across units is not possible — it is one pure function with one test matrix.
- **Requirements covered:** REQ-06 (schema — no column change, but this unit's migration
  carries the `status = 'TERMINATED'` backfill), REQ-07 (schema — `payroll_status` column),
  REQ-08 (schema `compensation_type` column + enum; shared enum + labels), REQ-09 (shared
  `derivePayrollGroup` gains `compensationType`; migration backfill), REQ-11 (schema —
  `salary_amount`, `salary_effective_from/to`), REQ-12 (schema —
  `hourly_rate_effective_from/to`), REQ-13 (schema — `over_scale_rate`), REQ-18 (schema —
  `payroll_exception_note`), REQ-19 (schema — the three subsistence columns), REQ-25 (confirm
  only — no column in this table is dropped or renamed), REQ-27 (shared —
  `SALARY_FREQUENCY_OPTIONS`; `PAY_CYCLE_OPTIONS` gains a shared home).
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `enum CompensationType { CRAFT_HOURLY, HOURLY_NON_CRAFT, SALARIED }`, `enum PayrollStatus { ELIGIBLE, HOLD }`; `Employee` gains `compensationType` (initially nullable), `payrollStatus @default(ELIGIBLE)`, `salaryAmount Decimal(12,2)?`, `salaryEffectiveFrom/To Date?`, `hourlyRateEffectiveFrom/To Date?`, `overScaleRate Decimal(10,4)?`, `payrollExceptionNote Text?`, `subsistenceShortOverride/LongOverride Decimal(10,2)?`, `subsistenceAgreementNote Text?`; two indexes `idx_employees_tenant_compensation_type`, `idx_employees_tenant_payroll_status` | migration name e.g. `20260916000000_employee_compensation_type_and_payroll_profile`; the backfill SQL ships **in this same migration folder** per `prisma.md` → Migrations: `UPDATE employees SET compensation_type = CASE WHEN pay_type ILIKE '%SALARY%' THEN 'SALARIED' WHEN EXISTS (SELECT 1 FROM employee_craft_assignments a WHERE a.employee_id = employees.id AND a.assignment_type = 'PRIMARY') THEN 'CRAFT_HOURLY' ELSE 'HOURLY_NON_CRAFT' END; ALTER TABLE employees ALTER COLUMN compensation_type SET NOT NULL;` then `UPDATE employees SET status = 'TERMINATED' WHERE terminated = true;` (REQ-06, idempotent, no column change) |
| API (`apps/api`) | none | this unit stops at the ORM boundary; no DTO/service edits |
| Web (`apps/web`) | none | — |
| Mobile (`apps/mobile`) | none | `employee.types.ts` gains fields additively in the shared-package row below; mobile source is untouched |
| Shared (`packages/shared`) | `enum CompensationType` + `COMPENSATION_TYPE_LABELS`; `enum PayrollStatus` + labels; `EMPLOYEE_STATUSES` + `EMPLOYEE_STATUS_LABELS` (five values); `SALARY_FREQUENCY_OPTIONS` (WEEKLY/BIWEEKLY/SEMI_MONTHLY/MONTHLY); `PAY_CYCLE_OPTIONS` added here (six values) as the new canonical source; `derivePayrollGroup({ compensationType, craftCode, roleType, unionKind })` — SALARIED → NON_UNION_SALARY, HOURLY_NON_CRAFT → NON_UNION_HOURLY, CRAFT_HOURLY → today's craft-prefix derivation unchanged; `payrollSetupWarnings` skips `UNION_STATUS_DISAGREES_WITH_CRAFT` when `compensationType = CRAFT_HOURLY`; `employee.types.ts` gains the ten new fields + `resolvedUnionKind` (additive) | `apps/web`'s existing local `PAY_CYCLE_OPTIONS` (`employee-form-options.ts`) is **left in place, not deleted** — the wizard that still ships until U7 lands imports it; U7 is responsible for the import-site swap and deleting the local copy |
| Tests | `packages/shared` unit tests (`node --test`): `derivePayrollGroup` — SALARIED → NON_UNION_SALARY; HOURLY_NON_CRAFT → NON_UNION_HOURLY; CRAFT_HOURLY with `SYS*` → SYS, MECHANIC → L12_MECHANIC, UNION → L12_FIELD, else NON_UNION_HOURLY (regression: today's three craft cases, unchanged); `payrollSetupWarnings` still fires `UNION_STATUS_DISAGREES_WITH_CRAFT` for non-craft-based mismatched input (regression) and skips it for craft-based; label maps cover every enum value. Migration test/script: apply the migration + backfill against a fixture covering the three row shapes in REQ-09's acceptance line (`payType = 'Salary'` mixed case, a row with a PRIMARY craft, a row with neither) and assert the resulting `compensation_type` and that no row is left null | REQ-08, 09, 16 |

### Reviewable as

- **Demo:** run `pnpm db:migrate` against a staging-shaped copy of the `employees` table and
  `SELECT compensation_type, COUNT(*) FROM employees GROUP BY 1` — the split should roughly
  match the tenant's known salaried/craft/non-craft mix; `pnpm nx run @tcg/shared:test`
  green on the new derivation/warning matrix.
- **Acceptance:** checked against REQ-08, REQ-09, REQ-13, REQ-18, REQ-19, REQ-27's
  data-model statements in `spec.md` §3, and the migration acceptance line in REQ-09.
- **Reviewer can verify without:** any API or web change — this is the one unit in the
  ledger whose demo is a database query and a `node --test` run, not a request or a click.

### Risk

- **Weakest source:** `[UNVERIFIED]` — every requirement this unit covers carries it; the
  backfill rule specifically is DEC-0915 Q4, a developer's reading (`status: reference`),
  named as overridable by Corrina Bustos, Brian Petros or Lisette Anzaldo.
- **Migration reversible:** **no, for the backfill.** The new nullable columns are trivially
  reversible (`DROP COLUMN`). The `compensation_type` backfill is not: it classifies every
  existing row by a heuristic nobody at TCG has confirmed, then makes the column `NOT NULL`.
  A misclassified row's only stated remedy is an admin correcting it by hand on the form
  (spec §Q4), which is not a rollback — the original "no compensation type" state cannot be
  recovered once real edits land on top of a wrong guess.
- **Behind a flag:** no — `spec.md` §11 states "No feature flag."
- **Touches existing data:** yes — every row in `employees`, described above.
- **Blast radius:** if the heuristic is wrong at scale (e.g. tenants where craft assignment
  data lags employee creation), a chunk of craft-based employees get silently classified
  `HOURLY_NON_CRAFT` and lose the craft-required validation U4 adds, until someone notices
  and corrects them one at a time.

**This is the flag rule 2b describes exactly: `[UNVERIFIED]` + a `NOT NULL` backfill.**
Recommend the executor confirm the backfill heuristic's expected row counts with Corrina
Bustos or Brian Petros against real tenant data before this unit merges to `main`, not after.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `derivePayrollGroup` (today's `payType`-only signature) | `packages/shared/src/utils/payroll-group.ts` | `pnpm nx run @tcg/shared:test` — the three existing craft-prefix cases (SYS/MECHANIC/UNION) asserted unchanged | `spec.md` REQ-09; DEC-0915 Q4 |
| `payrollSetupWarnings` union-disagree warning | same file | test asserts the warning still fires for non-craft-based mismatched input | `spec.md` REQ-16; DEC-0915 Q9 |
| `employee.types.ts` importers in `apps/web`, `apps/mobile` | shared type | **none — additive only**; `git grep -n -E "employeeType|payrollGroup|hourlyRate|unionCode|craftCode|departmentRole" apps/mobile` (spec §6) shows mobile reads only name-based/craft fields, none removed or retyped | `spec.md` §6, §7 |
| `apps/web` local `PAY_CYCLE_OPTIONS` (still imported by the live wizard) | `employee-form-options.ts` | **none needed** — this unit adds a shared copy but does not touch or delete the web-local one, so the still-shipping wizard is untouched | this unit's own scope decision, stated above |

### Deliberately not in this unit

- Deleting `apps/web`'s local `PAY_CYCLE_OPTIONS` and switching its importers to the shared
  one — lands in U7, alongside the wizard replacement that owns those import sites.
- Any DTO, service or controller change — every later API unit (U2–U6) builds on this
  schema without touching it further.

---

## U2 — Employee status vocabulary, payroll status field, SSN masking

- **Outcome:** an admin can set an employee's status to any of the five values (or leave a
  draft), termination requires a date and revokes a pending portal invite, and every
  non-admin caller of the employee API gets a masked SSN instead of the real one — all
  callable today via the existing routes, before any web change.
- **Kind:** vertical. **Demo is API-level** (integration test or a direct `PATCH
  /employee/:code` / `GET /employee` call) — legitimate here because REQ-04 and REQ-06's
  acceptance lines in `spec.md` §2 are written entirely as request/response behaviour.
- **Requirements covered:** REQ-04 (api — fully), REQ-06 (api — fully), REQ-07 (api — the
  field, validation and default only; the worklist *effect* is U6), REQ-26 (confirm — no
  behaviour change, verified unchanged).
- **Depends on:** U1

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — U1 already added `payroll_status`; `status` stays `VarChar(50)`, its value set enforced at the DTO | — |
| API (`apps/api`) | `create-employee.dto.ts` / `UpdateEmployeeDto`: `status` from free `@IsString` to `@IsIn([...EMPLOYEE_STATUSES, 'DRAFT'])`; `payrollStatus @IsEnum(PayrollStatus) @IsOptional` (service defaults `ELIGIBLE`). `employee.service.ts`: `terminated` becomes service-written from `status === 'TERMINATED'`, never accepted from the DTO directly; termination date required when `status = TERMINATED` (existing message, existing rule, now gated on the new enum instead of a free string); portal-invite revoke on `TERMINATED` reuses the existing `employee.controller.ts:207` path — confirmed, not re-implemented. SSN masking: `EmployeeService` response mapping uses `@GetCurrentUser()`'s role — full value for `ADMIN`/`SUPER_ADMIN`, `***-**-<last4>` (via `maskSsnForLog`, reused) for everyone else, on `findOne`, `findAll` and the temp-employee list; update DTO treats a value matching `^\*{3}-\*{2}-\d{4}$` as "unchanged" and does not write it | files: `apps/api/src/presentation/employee/dto/create-employee.dto.ts`, `update-employee.dto.ts`, `apps/api/src/usecase/employee/employee.service.ts`, `apps/api/src/utility/employee-ssn.util.ts` (reused, not changed) |
| API — rollout bridge | `compensationType` accepted + defaulted on create; pulled forward from U3 because U1's NOT NULL column broke `POST /employee` on the ORM cast; U3 still owns the derivation | `create-employee.dto.ts` / `UpdateEmployeeDto` gain `compensationType @IsEnum(CompensationType) @IsOptional`; `employee.service.ts#create` defaults it when absent — `payType` contains `SALARY` → `SALARIED`; else `primaryCraftCodeId` supplied → `CRAFT_HOURLY`; else `HOURLY_NON_CRAFT` (DEC-0915 Q4/Q5's rule, applied at create time only). No per-type validation, no `payType`/`payrollGroup` derivation here |
| Web (`apps/web`) | none | the still-live wizard already sends `status` as a free string within the five-plus-DRAFT set it already offers, so this unit's `@IsIn` tightening does not break it; `payrollStatus` is simply not sent yet (service default `ELIGIBLE` applies) |
| Mobile (`apps/mobile`) | none | — |
| Shared (`packages/shared`) | none beyond U1 | — |
| Tests | Integration (jest): `USER`-role session sees masked SSN on list/detail, `ADMIN` sees full; saving an edit as admin without touching SSN leaves the stored value unchanged; `status = TERMINATED` without a termination date 400s on that field (existing message); saving `TERMINATED` sets `terminated = true` and revokes a pending invite (regression against the existing revoke path); `status` outside the five-plus-DRAFT set 400s | REQ-04, 06 |

### Reviewable as

- **Demo:** `curl -H "Authorization: Bearer <user-token>" GET /employee/<code>` shows masked
  SSN; the same call with an admin token shows the real value; `PATCH /employee/<code>` with
  `status: 'TERMINATED'` and no `termDate` 400s; with a date, the portal invite is revoked
  (`GET /employee/<code>` shows `portalInvite: null` or equivalent).
- **Acceptance:** checked against REQ-04 and REQ-06's acceptance lines in `spec.md` §2.
- **Reviewer can verify without:** the web form — every assertion above is an HTTP call.

### Risk

- **Weakest source:** `[UNVERIFIED]` — DEC-0915 Q1 (SSN masking, no new permission) and Q2
  (status vocabulary) are both developer readings, `status: reference`.
- **Migration reversible:** N/A — no schema change in this unit.
- **Behind a flag:** no.
- **Touches existing data:** no new writes beyond what today's save already does; masking
  is response-shaping only.
- **Blast radius:** a mis-scoped `@IsIn` would reject an existing valid save from the live
  wizard (which still sends today's status strings) — the test above is the guard.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `GET /employee` list, `GET /employee/:code`, temp-employee list SSN column | API response shape | jest: masked for `USER`, full for `ADMIN` (table above) | `spec.md` REQ-04; DEC-0915 Q1 |
| Portal invite revoke path (`DELETE /employee/:code/invite`) | called from `employee.service.ts` on `TERMINATED` | jest: revoke asserted on the existing path | `spec.md` REQ-06; DEC-0915 Q2 |
| Still-live wizard's `PATCH`/`POST /employee` calls | today's `status` free string | jest: today's five values (`Active`/`Inactive`/etc., however the wizard currently cases them) still validate — **executor must confirm the wizard's current string casing matches `EMPLOYEE_STATUSES` exactly before tightening `@IsString` → `@IsIn`**, or add a normalising step | code (`create-employee.tsx` still shipping until U7) |
| Employee-code minting (REQ-26) | `employee.service.ts` | confirm-only — no test needed beyond the existing suite staying green | `spec.md` REQ-26 |

### Deliberately not in this unit

- The worklist/export exclusion `payrollStatus = HOLD` is meant to drive — that is U6, which
  depends on this unit's field existing but not on any code here.
- `EMPLOYEE_STATUSES` per-value UI gating (list filter semantics, DAS greying, `EmployeeSelect`
  defaults) — U8, since those are read-only consumers of the value this unit writes, not
  writers of it.

---

## U3 — Compensation Type becomes the source of Pay Type/Payroll Group

- **Outcome:** saving any employee now derives `payType` and `payrollGroup` from
  Compensation Type instead of from a freely-typed `payType`; a manual `payrollGroup`
  override plus a free-text exception note still win; changing an employee's type never
  clears their other-type data.
- **Kind:** vertical, API-level demo (same justification as U2).
- **Requirements covered:** REQ-08 (api — fully), REQ-09 (api — fully), REQ-18 (api —
  fully), REQ-20 (api — fully).
- **Depends on:** U1, U2

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — U1 already added every column this unit writes | — |
| API (`apps/api`) | DTO: `compensationType @IsEnum(CompensationType)`, required on non-DRAFT `create` (service-checked, not `@IsNotEmpty`, so `DRAFT` is exempt); `payrollExceptionNote @IsString @IsOptional`; `payrollGroup` override field kept as today's optional select. `employee.service.ts` / `employee.repository.ts` `syncPayrollGroup`: calls `derivePayrollGroup({ compensationType, … })` (U1); an explicit `payrollGroup` in the payload still wins over the derivation (unchanged precedence, now exercised by a new caller); `payType` stays accepted on the DTO for compatibility and is **overwritten** by the service (`SALARY` for `SALARIED`, else `HOURLY`) — never read back from the payload. Hide-never-clear (REQ-20): the service ignores payload fields that do not belong to the submitted `compensationType` instead of rejecting them (e.g. a `salaryAmount` sent while `compensationType = CRAFT_HOURLY` is dropped, not 400'd; a stale `primaryCraftCodeId` on a now-Salaried save is ignored); the previous type's stored row values are never nulled by this path. Activity log: `compensationType`, `payrollStatus`, `salaryAmount`, `payCycle`, `overScaleRate`, `subsistenceShortOverride`, `subsistenceLongOverride`, `payrollExceptionNote` join the tracked field set in `employee.service.ts:741-757` | files: `create-employee.dto.ts`, `update-employee.dto.ts`, `employee.service.ts`, `employee.repository.ts` |
| Web | none | — |
| Mobile | none | — |
| Shared | none beyond U1 | — |
| Tests | Integration (jest): a `SALARIED` create yields `payType = SALARY`, `payrollGroup = NON_UNION_SALARY`; a `CRAFT_HOURLY` create with an L12 UNION craft yields `L12_FIELD`; a row with a manual `payrollGroup` override keeps it after a later save that changes nothing else; switch `CRAFT_HOURLY` → `SALARIED` → back — the retained primary craft, secondaries and over-scale reappear unchanged and the activity log shows two `compensationType` entries; create with no `compensationType` on a non-DRAFT payload 400s *"Compensation type is required"*; the same payload with `status: 'DRAFT'` succeeds | REQ-08, 09, 18, 20 |

### Reviewable as

- **Demo:** `POST /employee` with `compensationType: 'SALARIED'`, no `payType` — response
  shows `payType: 'SALARY'`, `payrollGroup: 'NON_UNION_SALARY'`; `PATCH` the same employee
  to `CRAFT_HOURLY` with a `primaryCraftCodeId`, then back to `SALARIED` — `GET` shows the
  craft assignment is still present server-side (`craft-assignments` endpoint) even though
  the salaried response does not surface it.
- **Acceptance:** checked against REQ-08, REQ-09, REQ-18, REQ-20's acceptance lines.
- **Reviewer can verify without:** the web form.

### Risk

- **Weakest source:** `[UNVERIFIED]` — DEC-0915 Q4, Q7, Q12, all developer readings.
- **Migration reversible:** N/A — no schema change here.
- **Behind a flag:** no.
- **Touches existing data:** no new writes beyond what today's save does; this changes
  *which* values a save computes, not a bulk update.
- **Blast radius:** **this is the unit that makes `compensationType` required on non-DRAFT
  create.** The still-live wizard (until U7 ships) never sends `compensationType` — see
  named gap below.

**Named rollout gap (rule 7):** between this unit merging and U7 merging, a **new** employee
created as non-draft through the still-shipping wizard will 400 with *"Compensation type is
required"*, because the old form has no field to send it. Existing employees being *edited*
are unaffected (Prisma partial update; `compensationType` is not required on `update`, only
`create`, per the DTO note in `spec.md` §4). Two things to do about it, not one silent gap:
sequence U3 and U7 to merge in the same release window (see **Sequencing**), and confirm
with whoever owns the release that "create employee" is not exercised through the old
wizard in that window — draft-first creates (which do not require the field) are the
existing default path per `spec.md` §5, which narrows, but does not close, the gap.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `payType` field on the DTO (still accepted) | `create-employee.dto.ts` | jest asserts a payload with `payType` set is overwritten, not honoured | `spec.md` REQ-09 |
| Payroll UI group filters / export column / worklist (read `payrollGroup`) | unchanged consumers | confirm-only, no code change — `payrollGroup`'s meaning is unchanged, only its derivation source | `spec.md` §11a *Payroll UI group filters…* row |
| `seed-payroll-demo.ts` | reads `payrollGroup` | confirm-only — unaffected, it seeds the field directly | `spec.md` §11a |
| Still-live wizard's create flow | `compensationType` omitted | **named gap above, not a silent one** — no regression test can cover "the field doesn't exist yet on the caller"; the gap is a sequencing risk, tracked in Sequencing | this unit's Risk block |

### Deliberately not in this unit

- The per-type required-field checks (primary craft for `CRAFT_HOURLY`, salary amount for
  `SALARIED`, hourly rate for `HOURLY_NON_CRAFT`) — U4 and U5, which need this unit's
  `compensationType` field to exist first.

---

## U4 — Craft-Based Hourly payroll profile

- **Outcome:** a Craft-Based Hourly employee's primary craft is required and filtered to
  their operational role, secondary crafts require a reason, union status and payroll group
  are derived and shown, and over-scale/subsistence overrides can be stored — all enforced
  and returned by the API.
- **Kind:** vertical, API-level demo. **Not split further** despite size: REQ-10, 13, 14,
  15, 16 and 19 are one cohesive rule set exercised by the same `CRAFT_HOURLY` branch of
  `employee.service.ts` against the same craft; two units both needing to touch that one
  branch would add merge risk (same file, same `if (compensationType === 'CRAFT_HOURLY')`)
  without adding anything a reviewer could check independently — REQ-14's eligibility check
  and REQ-16's union derivation both read the same primary-craft lookup REQ-10 already does.
- **Requirements covered:** REQ-10 (api — fully), REQ-13 (api — fully), REQ-14 (api —
  fully), REQ-15 (api — fully), REQ-16 (api — fully), REQ-19 (api — fully).
- **Depends on:** U1, U2, U3

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | — |
| API (`apps/api`) | `employee.service.ts`: primary craft required iff `compensationType = CRAFT_HOURLY` (replaces the retired `assertCraftNotRequired`/`isFieldEmployeeTypeName` hard check — `FIELD_EMPLOYEE_TYPE_NAMES` stays only for the create-time default, built in U7); eligibility check — the craft's `roleType` must match `craftRoleTypeForEmployeeTypeName(employeeType)` when the type maps to one, else 400 naming both craft and employee type; hourly rate required only when the primary craft's union kind is `NON_UNION` (existing `NO_HOURLY_RATE_FOR_NON_UNION_CRAFT` warning path, now type-gated); over-scale (`overScaleRate @IsNumberString @IsOptional`) and subsistence overrides accepted and stored, `≥ 0`; union derivation — on save, `unionCodeId`/`unionStatus` are written from the primary craft's union code, ignoring any `unionCodeId` in the payload for this type. `GET /v1/craft-assignments/missing-primary` filtered to `compensationType = CRAFT_HOURLY`. `employee-craft-assignments` DTO: `reason @IsNotEmpty` when `assignmentType = SECONDARY` (PRIMARY unaffected) | files: `employee.service.ts`, `create-employee.dto.ts`, `employee-craft-assignments.controller.ts`'s DTO, `employee-craft-assignments.service.ts` |
| Web | none | — |
| Mobile | none | — |
| Shared | none beyond U1 | — |
| Tests | Integration (jest): `CRAFT_HOURLY` with no primary craft → 400 *"Payroll craft is required"*; an Oiler-type employee with an OPERATOR craft → 400 naming both; a UNION craft save writes `unionCodeId`/`unionStatus` from the craft and hides the need for `hourlyRate`; a NON_UNION craft with blank `hourlyRate` saves with the existing warning, not a 400; over-scale and subsistence overrides round-trip; a SECONDARY craft assignment with no `reason` → 400; `missing-primary` no longer lists a `SALARIED` employee (regression: it used to, per the old type-based rule) | REQ-10, 13, 14, 15, 16, 19 |

### Reviewable as

- **Demo:** `POST /employee` with `compensationType: 'CRAFT_HOURLY'`, no
  `primaryCraftCodeId` → 400; with a mismatched-`roleType` craft → 400 naming both; with a
  correct craft → 201 and the response shows derived `unionCodeId`/`unionStatus`;
  `POST /employee/:code/craft-assignments` with `assignmentType: 'SECONDARY'`, no `reason`
  → 400.
- **Acceptance:** checked against REQ-10, 13, 14, 15, 16, 19's acceptance lines.
- **Reviewer can verify without:** the web form.

### Risk

- **Weakest source:** `[UNVERIFIED]` — DEC-0915 Q5 (the retired hard check), Q6
  (over-scale shape), Q7 (secondary-craft reason), Q11 (subsistence).
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** same named rollout gap as U3 — a craft-based employee created through
  the still-live wizard between this unit and U7 will fail the same *"Compensation type is
  required"* 400 before it even reaches this unit's checks (U3's gap subsumes this one).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `assertCraftNotRequired` / `isFieldEmployeeTypeName` hard check | `employee.service.ts:346-356` | jest: a `SALARIED` employee whose Employee Type is a field type (e.g. Rigger) saves with no craft — the retired check no longer fires | `spec.md` REQ-10; DEC-0915 Q5 |
| `GET /v1/craft-assignments/missing-primary` | filter | jest: no longer lists `SALARIED`/`HOURLY_NON_CRAFT` employees | `spec.md` REQ-10 |
| `PayrollSetupWarnings` / `payrollSetupWarnings` (U1) | craft-based input | jest: `UNION_STATUS_DISAGREES_WITH_CRAFT` no longer produced for `CRAFT_HOURLY` saves (it structurally cannot disagree once derived) | `spec.md` REQ-16; DEC-0915 Q9 |
| `craft-rate-resolver.service.ts:360-371` | `Employee.hourlyRate` via NON_UNION craft | **none — unchanged**, confirmed by the existing resolver test suite staying green; this unit adds no new resolver input | `spec.md` REQ-10 ripple row |
| `employee-craft-assignments` existing PRIMARY/SECONDARY callers (DAS pickers, `payroll-secondary-craft.ts`) | craft assignment rows | **none — unchanged**, only the SECONDARY `reason` field gains a requiredness check; PRIMARY rows and all readers are untouched | `spec.md` REQ-15 ripple row |

### Deliberately not in this unit

- Pricing with over-scale or the subsistence overrides — `SCRUM-928` and a `PAY-###`
  provenance change respectively, per `contexts/payroll-engine.md` and spec §13.

---

## U5 — Salaried and Hourly Non-Craft payroll profiles

- **Outcome:** a Salaried employee's salary amount and frequency are required and
  effective-dated; an Hourly Non-Craft employee's hourly rate is required and
  effective-dated; both types can carry an optional, informational union status.
- **Kind:** vertical, API-level demo.
- **Requirements covered:** REQ-11 (api — fully), REQ-12 (api — fully), REQ-17 (api —
  fully), REQ-27 (api — fully).
- **Depends on:** U1, U2, U3

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | — |
| API (`apps/api`) | `employee.service.ts` per-type checks: `salaryAmount`/`payCycle` required iff `SALARIED` (400 *"Salary amount is required for Salaried employees"* / *"Salary frequency is required for Salaried employees"*); `payCycle` for `SALARIED` restricted to `WEEKLY`/`BIWEEKLY`/`SEMI_MONTHLY`/`MONTHLY` — a stored `QUARTERLY`/`DAILY` value is displayed as-is but rejected on the next save that doesn't correct it; `hourlyRate` required iff `HOURLY_NON_CRAFT` (400 *"Hourly rate is required for Hourly Non-Craft employees"*); effective-to ≥ effective-from when both set, for both the salary and hourly-rate date pairs (400 *"Effective end date must be on or after the start date"*); union status for both non-craft types is selected from the existing union-code picker, optional, and `resolvedUnionKind` is the picked code's kind (null when none) — nothing derived, nothing priced | file: `employee.service.ts`, same DTOs U3/U4 touch (`@IsIn(PAY_CYCLE_VALUES)` on `payCycle`) |
| Web | none | — |
| Mobile | none | — |
| Shared | none beyond U1 | — |
| Tests | Integration (jest): `SALARIED` with no `salaryAmount` → 400 on that field; no `payCycle` → 400; `payCycle: 'QUARTERLY'` on a `SALARIED` save → 400; `HOURLY_NON_CRAFT` with no `hourlyRate` → 400; `HOURLY_NON_CRAFT` create returns `primaryCraftCodeId: null` without error; effective-to before effective-from → 400; a `SALARIED` employee saved with a UNION code returns `resolvedUnionKind: 'UNION'` and changes no payroll week total | REQ-11, 12, 17, 27 |

### Reviewable as

- **Demo:** `POST /employee` with `compensationType: 'SALARIED'`, no `salaryAmount` → 400;
  with amount and frequency → 201; `GET` shows `resolvedUnionKind` reflecting the picked
  union code.
- **Acceptance:** checked against REQ-11, 12, 17, 27's acceptance lines.
- **Reviewer can verify without:** the web form.

### Risk

- **Weakest source:** `[UNVERIFIED]` — `PAY-013`/`PAY-012` are themselves `status: open` in
  the vault; DEC-0915 Q8, Q9, Q14 are developer readings.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** same U3-inherited rollout gap for *new* creates through the old wizard
  during the window before U7 lands; narrower here since Salaried/Hourly-Non-Craft creates
  are a smaller share of traffic than craft-based ones per `payroll/gaps.md` → *Payroll has
  three populations*.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `packages/payroll-engine` `NON_UNION_SALARY` week pricing | reads `Employee.hourlyRate` as the weekly amount (`SALARY_AMOUNT_ASSUMED`) | **none — unchanged, and must stay that way**: this unit adds `salaryAmount` as a stored field but does not wire it into the engine, per `contexts/payroll-engine.md`; a regression test here would be testing a change this unit is forbidden from making | `spec.md` REQ-11; `contexts/payroll-engine.md` |
| `craft-rate-resolver.service.ts` `Blocked` state for craft-less employees | unchanged | confirm-only — an `HOURLY_NON_CRAFT` employee with no craft is still `Blocked` at resolution, as today | `spec.md` REQ-12 ripple row |
| `UnionStatusField` | moved in U7, not this unit | N/A here | `spec.md` REQ-17 |

### Deliberately not in this unit

- Wiring `salaryAmount` or the hourly-rate effective dates into `packages/payroll-engine` —
  forbidden here; `PAY-013`/`PAY-068` own it, each needing its own provenance entry.
- The salary earning-code / export-mapping fields EPF §6–7 mention — DEC-0915 Q14 drops
  them from the employee profile entirely; not deferred, not built anywhere.

---

## U6 — Payroll worklist and export exclude Hold/ineligible employees

- **Outcome:** the weekly payroll worklist build and the ADP export skip an employee who is
  on payroll hold or whose employee status excludes them, and surface a visible issue on the
  week instead of silently dropping their hours if they have labor that week.
- **Kind:** vertical — this one is demonstrable through the **existing** worklist UI (no new
  screen), so it does not need the API-level-demo justification the others do.
- **Requirements covered:** REQ-31 (fully), REQ-07 (worklist/export effect — the field
  itself is U2's), REQ-18 (the exception-note display on the payroll-week employee card).
- **Depends on:** U1, U2

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | — |
| API (`apps/api`) | `apps/api/src/usecase/payroll/payroll.service.ts:806-918` worklist build: filter to `payrollStatus = ELIGIBLE AND status IN ('ACTIVE','ON_LEAVE')`; an excluded employee with job-ticket labor in the week raises `EMPLOYEE_ON_PAYROLL_HOLD` (payroll-status cause) or `EMPLOYEE_STATUS_EXCLUDED` (status cause) on that week, not both if both apply — payroll-status wins per the spec's ordering (`EMPLOYEE_ON_PAYROLL_HOLD` listed first in REQ-31); `payroll-export.ts` / `xlsx-rows.ts` skip the same excluded employees; two entries added to `payroll-issue-catalog.ts` (web, since the catalog lives in `apps/web/src/features/payroll`) | **`packages/payroll-engine` is not touched** — the filter runs before `PayrollEmployeeInput` is built, per `contexts/payroll-engine.md` and this unit's own scope |
| Web (`apps/web`, payroll feature only) | `payroll-issue-catalog.ts` gains the two issue codes with their display copy; `payroll-employee-card.tsx` / `payroll-overlay-employee-card.tsx` show `payrollExceptionNote` (REQ-18) and a Hold indicator | this is the payroll feature, not the employees feature — kept in this unit because it is the natural home for "payroll week" UI, not split into U7/U8 which own the employees feature |
| Mobile | none | — |
| Shared | none | — |
| Tests | Integration (jest, payroll): a `HOLD` employee with ticket labor in the week is absent from the worklist and the week carries `EMPLOYEE_ON_PAYROLL_HOLD`; a `TERMINATED` employee with labor is absent and the week carries `EMPLOYEE_STATUS_EXCLUDED`; an `ON_LEAVE` employee is included; flipping `HOLD` → `ELIGIBLE` and recalculating includes the employee; the ADP CSV omits both excluded groups; over-scale/subsistence overrides (U4) change no week total (regression, confirms U4's "stored only" claim from the payroll side) | REQ-31, 07, 13, 19 |
| Provenance | `payroll/payroll-rules-provenance.md` gains two scoping rows (payroll hold; employee-status exclusion), citing DEC-0915, **in the same commit** | required by `contexts/payroll-engine.md`'s provenance discipline, extended here per spec §11 even though this code lives in the usecase layer, not the engine package |

### Reviewable as

- **Demo:** on the existing payroll worklist screen, build a week that includes a `HOLD`
  employee with ticket hours that week — the worklist excludes them and the week shows the
  new issue chip; flip them back to `ELIGIBLE` and rebuild — they appear.
- **Acceptance:** checked against REQ-31's acceptance lines.
- **Reviewer can verify without:** U7/U8 (the employee form/detail pages) — this reads
  fields U2/U1 already expose via direct DB/API access or fixtures, independent of whether
  the web form can set them yet.

### Risk

- **Weakest source:** `[UNVERIFIED]` — DEC-0915 Q2/Q3, developer readings; the legacy
  `cfg.PayrollUI_ExcludedEmpID` precedent in `payroll/gaps.md` is itself unverified.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** a filter bug here silently drops or silently includes payroll-week
  hours for held/excluded employees — the highest-stakes unit in the ticket outside U1,
  which is why it carries the provenance requirement.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `payroll.service.ts` worklist build (today's exclusions: `SYS` group, missing ADP number) | same function, new filter added alongside | jest: today's two exclusions still apply, unaffected by the new filter (regression) | `spec.md` REQ-31 ripple row; `packages/payroll-engine/src/calculate.ts:978,996` |
| `payroll-export.ts` / `xlsx-rows.ts` | export skip | jest: an `ELIGIBLE`/`ACTIVE` employee's export row is unchanged | `spec.md` REQ-31 |
| `packages/payroll-engine` `PayrollEmployeeInput` | engine contract | **none — must stay unchanged**, confirmed by the engine's own test suite staying green with no new input added | `contexts/payroll-engine.md`; DEC-0915 |

### Deliberately not in this unit

- Any change inside `packages/payroll-engine` — forbidden by this ticket's standing
  constraint.
- The web indicator on the employee's own payroll-profile section showing their Hold status
  — that is U7 (the field itself; U6 only builds the worklist-side effect and the week-card
  display).

---

## U7 — The employee create/edit page becomes one sectioned form

- **Outcome:** `/employees/create` and `/employees/<code>/edit` (and the temp-employee
  variant) render as one scrolling page of eight accent-header `SectionCard`s — the agency
  form's look — with the Payroll Profile section switching its body by Compensation Type.
  The five-tab wizard is gone.
- **Kind:** vertical. **Not split further** despite being the largest unit in the ledger:
  splitting the page shell from the three payroll bodies (the shape this decomposition's
  first draft considered) would mean shipping a live page that has lost the ability to
  manage a craft-based employee's secondary crafts, union status and over-scale until a
  second unit lands — an unstated regression window on an *existing* consumer, which rule 7
  forbids more strongly than rule 6 discourages a large unit. The wizard is swapped out in
  one commit specifically to avoid that gap.
- **Requirements covered:** REQ-01, REQ-02, REQ-21, REQ-22, REQ-23, REQ-28, REQ-29 (fully);
  REQ-03, REQ-05, REQ-08, REQ-10, REQ-11, REQ-12, REQ-13, REQ-14, REQ-15, REQ-16, REQ-17,
  REQ-18, REQ-19, REQ-20, REQ-25, REQ-26, REQ-27 (web side); REQ-30 (the form's test IDs —
  U8 adds the detail/list ones).
- **Depends on:** U1, U2, U3, U4, U5 — every API unit must be merged first; the page's
  Payroll Profile section exercises all three type bodies from the first commit.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | — |
| API | N/A | already built in U1–U5; this unit is a pure consumer |
| Web (`apps/web`) | New: `features/employees/components/form/employee-form.tsx` (page shell, replaces `create-employee.tsx`'s wizard shell — reuses `AgencyForm`'s skeleton: `FormProvider`, `useForm`/`formZodResolver`, `mode: 'onBlur'`, `useSubmitPipeline`, `useUnsavedChangesGuard`); `sections/basic-information-section.tsx`, `department-role-section.tsx`, `employee-status-section.tsx`, `employment-details-section.tsx`, `payroll-profile-section.tsx`, `managed-assets-section.tsx`, `emergency-contact-section.tsx`, `attachments-certifications-section.tsx`; `payroll/compensation-type-field.tsx`, `payroll-status-field.tsx`, `craft-hourly-fields.tsx`, `salaried-fields.tsx`, `hourly-non-craft-fields.tsx` (the three bodies, switched on `watch('compensationType')`), `secondary-craft-rows.tsx` (repeat-row pattern per `web.md` → Multi-select — no multi-select picker exists, so N independent rows), `resolved-union-status.tsx`, `payroll-advanced-fields.tsx` (the *Advanced* disclosure — `find-component` first for an existing collapsible before hand-rolling one). Moved into the new sections, not reimplemented: `PersonalInformationFields`, `ContactDetailsFields`, SMS opt-in, `AddressSection`, `DepartmentSelect`/`RoleSelect`/`EmployeeTypeSelect`, `PayrollCraftCodeSelect`, `UnionStatusField`, `EmployeeCraftCard`, `CreateEmployeeManagedAssetsSection`, `CreateEmployeeAttachmentsSection`, `EmployeeCertificatesSection`. Deleted: the tab stepper (`resolveInitialEmployeeTab`, `findEmployeeTabForErrors`, `requestValidationFocus`, `employee-wizard-*` IDs, `create-employee-actions.tsx`'s wizard nav), `assertCraftNotRequired`'s web-side mirror if one exists. `PAY_CYCLE_OPTIONS` import site swaps from the local `employee-form-options.ts` to `@tcg/shared` (U1); the local copy is deleted here. Zod: type-aware `superRefine` on `compensationType` (REQ-29); failed submit scrolls/focuses the first invalid control in DOM order, expanding a collapsed *Advanced* disclosure first if the invalid field is inside it | files per `spec.md` §5's component list; temp-employee variant keeps its single `variant` flag, omits Managed Assets |
| Mobile | N/A | — |
| Shared | N/A beyond U1 | — |
| Tests | Unit (web, `node --test`): type-aware Zod schema — each type's required set, DRAFT exemption, effective-date ordering, `TERMINATED` ⇒ term date, payload strips other-type fields on submit, salaried frequency subset vs hourly six-value set. Integration/manual: create one employee per compensation type through the new page; switch types on an existing employee's edit page and confirm the hidden type's values are retained (visually gone, present on next switch-back) | REQ-06, 10/11/12, 20, 27, 29 |

### Reviewable as

- **Demo:** `/employees/create` renders eight `SectionCard`s with the accent header, no tab
  strip; picking each Compensation Type swaps the Payroll Profile body live; submitting with
  an empty required field in a later section scrolls to and focuses it; saving lands on the
  new employee's detail page.
- **Acceptance:** checked against REQ-01, 02, 29's acceptance lines directly, and every
  web-side acceptance line of REQ-03…REQ-28 via the fields now on the page.
- **Reviewer can verify without:** U8 (the detail page can still be the old tabbed one for
  this unit's review — U7 only needs its own create/edit round trip and the redirect target
  to exist, which it does today).

### Risk

- **Weakest source:** `[UNVERIFIED]` — every web-side requirement here, plus instruction 2
  (`[UNVERIFIED]`, kind: jira) for the `SectionCard` look itself.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** this is the unit that actually removes the wizard — the highest
  user-visible-change unit in the ticket. `qa-automation/e2e/specs/employees/*` breaks here
  (11 specs, `employees.page.ts` — see Ripple below); that is accepted, not a defect of this
  unit.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `create-employee.tsx` wizard and its tab components | component, deleted | **N/A — replaced, not regressed**; every field the wizard carried is re-homed and covered by the manual create-one-per-type script above | `spec.md` REQ-01; instruction 2 |
| `views/employees.tsx` tab ↔ route mapping (`useUrlTab`) | route param | detail tabs stay; the form's tab param is simply no longer produced — confirmed by the create/edit round-trip test | `spec.md` REQ-01 ripple row |
| `qa-automation/e2e/specs/employees/*` (11 specs) | wizard IDs, `#create-employee-form`, InfoRow labels, "five required fields" | **none — accepted break, not deferred.** Instruction 4 and `spec.md` §11a/§13 already record this as a decided, sourced outcome, not an unbuilt regression test; `git grep -n 'employee-wizard-' apps/web` after this unit should return only `cancel`/`save`/`save-draft`/`submit`, listed in the PR description per REQ-30 | instruction 4; `spec.md` §11a, §13 |
| `PayrollFields` (all-employees grid), `EmploymentDetailsFields`, `PayrollSetupWarnings` | components | replaced by the three type bodies + `PayrollSetupWarnings` reused craft-only, per REQ-10/16 | `spec.md` §11a |
| `create-employee-archived-conflict.ts`, `EntityProfilePictureSection` | components | kept, reused unchanged inside the new shell | `spec.md` REQ-01 Notes |
| `decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md` | create flow | honoured — save redirects to detail, confirmed in the manual script | decision (reference) |

### Deliberately not in this unit

- The detail page's restructuring (REQ-24) and the list/status-control changes (REQ-06 web,
  REQ-04 web) — U8, a separate read surface with its own files.
- Updating `qa-automation/` — out of scope for the whole ticket (instruction 4), not deferred
  to a later unit.

---

## U8 — Detail page mirrors the sections; list and status controls follow the new vocabulary

- **Outcome:** `/employees/<code>` shows the same eight sections read-only, with the SSN
  masked and only the employee's own Compensation Type's payroll fields shown; the employee
  list's status toggle and filters follow the five-value vocabulary instead of the old
  Active/not-Active binary.
- **Kind:** vertical.
- **Requirements covered:** REQ-24 (fully), REQ-06 (web — list/status controls), REQ-04
  (web — masked display confirmation), REQ-30 (detail/list-side test IDs).
- **Depends on:** U1, U2, U3, U4, U5 — needs the full field set in the `GET` response.
  Independent of U7 (different files — `employee-detail-*` vs `employee-list*` against
  `components/form/*`), so it can ship before, after, or alongside U7.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | — |
| API | N/A | consumer only |
| Web (`apps/web`) | `employee-detail-general-tab.tsx` restructured into the eight-section `SectionCard` + `FieldGrid`/`Field` read-only layout; payroll section shows only the employee's own type's fields, the resolved union status, the derived payroll group, masked SSN (full for admin sessions); `EmployeeCraftCard` stays inside the payroll section for craft-based employees; Employment History/Leaves/Activity Logs/Notes keep their existing tabs; status quick-action select offers the five values. `employee-list.helpers.ts`: the Inactive view narrows to `INACTIVE` only (each status becomes its own filter, not a not-DRAFT/not-ACTIVE catch-all — no new views added, `NOT SPECIFIED` per spec); `use-employee-status-controls.ts` — the Active/Inactive switch stays for those two values; a row in any other status renders the switch disabled with the status label; temp-employee list SSN column masked per REQ-04 | files: `employee-detail-general-tab.tsx`, `employee-list.helpers.ts`, `use-employee-status-controls.ts`, `employee-list-columns.tsx` |
| Mobile | N/A | — |
| Shared | N/A | — |
| Tests | Unit (web, `node --test`): list filter — `Inactive` view returns only `INACTIVE` rows, not `TERMINATED`/`PENDING_ONBOARDING`; status toggle disabled state for the three non-Active/Inactive statuses. Manual/integration: a Salaried employee's detail payroll block shows salary amount/frequency/effective dates and no craft card; a Craft-Based Hourly employee's shows the craft card and no salary fields | REQ-24, 06 |

### Reviewable as

- **Demo:** `/employees/<code>` for one employee of each type shows the type-appropriate
  read-only payroll block; the list's status filter dropdown offers all five values and each
  narrows correctly; a `PENDING_ONBOARDING` row's Active/Inactive switch renders disabled.
- **Acceptance:** checked against REQ-24 and REQ-06's web-side acceptance lines.
- **Reviewer can verify without:** U7 — the detail page and list are separate files from the
  create/edit form; this unit's review does not require the wizard to already be gone.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-24's sources are `EPF §Purpose`/`§11`, both
  `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** a filter-semantics bug here changes who appears on an existing list view
  an operator relies on daily — narrower than U6/U7 but user-facing.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `EmployeeSelect` default `status = ACTIVE`, `resolveAssignableEmployeeId` | unchanged filters | **none — confirmed unchanged**, both already filter to `ACTIVE` only and need no new code for the two added status values to be correctly excluded | `spec.md` REQ-06 ripple row |
| DAS availability (`das.repository.ts`) | treats non-`ACTIVE` as unavailable | **none — confirmed unchanged**; `ON_LEAVE` already gets the existing "Leave" tag through the same non-ACTIVE branch | `spec.md` REQ-06 ripple row |
| `qa-automation/e2e/specs/employees/create.spec.ts:313-358` (InfoRow label assertions) | detail page structure | **none — accepted break**, same instruction-4 disposition as U7's | instruction 4; `spec.md` §11a |
| Employee list Union column/views, DAS union readers, mobile crew display | `unionStatus` denormalised label | **none — confirmed unchanged**, U4 writes the same field through the same path they already read | `spec.md` REQ-16 ripple row |

### Deliberately not in this unit

- New list views for the two added statuses — `NOT SPECIFIED` by the spec, not built here or
  anywhere in this ticket.
- Wiring `ON_LEAVE` to the leave-request module — DEC-0915 Q2 leaves it unwired; not this
  ticket's.

---

## Sequencing

```
U1 ──▶ U2 ──▶ U3 ──▶ U4 ──▶ U5 ──┬──▶ U7
                                  └──▶ U8
U1 ──▶ U6
```

- **Parallelisable:**
  - **U6** (`apps/api/src/usecase/payroll/*`, `apps/web/src/features/payroll/*`) shares no
    file with U2/U3/U4/U5 (`apps/api/src/usecase/employee/*`,
    `apps/api/src/presentation/employee/*`) and can be branched and merged independently as
    soon as U1 lands.
  - **U7** (`apps/web/src/features/employees/components/form/*`) and **U8**
    (`apps/web/src/features/employees/views/employee-detail-*`,
    `employee-list*`) touch different files and can run concurrently once U1–U5 have merged.
- **Merge order constraint:** **U2 → U3 → U4 → U5 must land in that exact order.** All four
  edit the same regions of `apps/api/src/usecase/employee/employee.service.ts` and
  `apps/api/src/presentation/employee/dto/create-employee.dto.ts` (the create/update
  validation-and-derivation path) — out-of-order merges will conflict or silently drop an
  earlier unit's check, most dangerously U3's `compensationType`-required gate being dropped
  by a careless rebase of U4/U5 on top of it. U1's migration must land before anything else
  in the ledger. **U3 and U7 should be scheduled into the same release window** — see U3's
  Risk block for the named rollout gap (a new employee created through the still-live wizard
  400s once U3 lands, until U7 removes the wizard).
- **First unit to ship:** **U1** — it proves the riskiest single change in the ticket, the
  `compensation_type` backfill making a column `NOT NULL` from an `[UNVERIFIED]` heuristic
  over live tenant data, before seven later units build API and web behaviour on top of it.
  If the backfill's classification is wrong at scale, that is far cheaper to discover before
  U2–U8 exist than after.
