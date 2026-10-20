# Units — TCG-237 One role per employee: replace Employee Type with departments and roles

> Written to `.ai/aidlc/TCG-237/units.md` from `spec.md` beside it, 2026-10-20, by `tcg-decomposer`.
> Consumed by an executor, one unit at a time. Field list per `.ai/aidlc/templates/units.md`.

## How to read this plan

- **Input status.** The developer signed the spec off for decomposition on 2026-10-20 ("go A"): §11b D1–D13 and §11c are decided (Syed Haris); §12 is answered or superseded except **Q5, Q6, Q23**. The REQ headers in §2 still carry their elaboration-time `[OPEN]` flags and `spec.md` §14 "answers written back" is unchecked, so this plan treats the **§12 answers and §11b rows as authoritative** and does not re-open the REQ flags. Every §12 answer is a developer answer "open to TCG challenge", i.e. `[UNVERIFIED]` — it does not block a unit, it sets the *Weakest source* line (§2b).
- **New questions raised by this decomposition: Q26–Q31** (`spec.md` §12). Units that need them are marked blocked; nothing was guessed.
- **Stacked PRs, sliced by feature** (D9 = B): each unit's branch is cut from the previous unit's branch it depends on; its PR targets that branch. Every unit leaves the app working. Names below: `feat/TCG-237-u<n>-<slug>`.
- **Coexistence trick that makes "works after every merge" possible** (D10 = B no aliases, D11 = C keep `EmployeeType` until last): **U4** adds a nullable `role_id` beside each `employee_type_id` and backfills it once. Each picker unit then switches one consumer from the old column to the new one (API, web and mobile together, §11c) and stops reading the old column. **U20** drops the old columns and the table. No API alias is ever served.
- **Per-unit gates.** `tcg-prisma-guardian` and `tcg-contract-tracer` are required where marked. Every unit with a migration carries a committed migration (`contexts/prisma.md`). Size is changed source lines / source files (tests, migrations, lockfiles excluded), against ~400 / 25.

## Gate baseline

**Gate baseline:** *`2026-10-20`, local `main` at `a0f49009b` (`git fetch origin main` failed in this session — no `origin/main` ref was available, so this is local `main`, clean tree) — lint: 4 errors, all in `apps/web` test files (`max-lines` in `features/das/middle-section/jobs/allocations/copy-allocation/services/copy-allocation.service.test.mjs`; `require-unicode-regexp` ×2 in `features/employees/utils/invite-channel-preview.test.mjs`) and ~1,540 warnings across projects, typecheck: pass (Nx cache hit, `web` + `mobile`), build: **fail** — `@tcg/api:build` aborts with a Node heap out-of-memory (exit 134) on the default heap; `shared`, `payroll-engine` and `web` build, test: see the line at the bottom of this section.*

The executor reports its gates against this. The `@tcg/api:build` failure is the environment's heap limit (the API also needs a heap flag for `api:dev`), not a code defect: build the API with an enlarged heap and report that run as the unit's build gate.

**Test baseline:** **fail** — `@tcg/api:test`: 1 test failed in 1 suite (`src/usecase/docusign/quotation-pdf.service.spec.ts`), 2,965 passed of 2,966; `@tcg/mobile:test`: 6 tests failed in 3 suites (`app/(field)/ticket/ticket.test.tsx`, `components/field/signer-capture.test.tsx`, `features/field-ticket/steps/shared/time/TimeRecordBody.test.tsx`), 3,089 passed of 3,095 — these suites ran 70–113 s each, so a timeout under load is possible; the executor re-runs them in isolation before blaming a change. `@tcg/web` (139 + 117 node tests), `@tcg/shared` and `@tcg/payroll-engine` pass. Mobile field-ticket tests overlap U6 and U14: a red there is inherited.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Assets no longer carry a department (form, list, filter, sort, stored values) | REQ-01 (asset consumer, D5b) | schema, api, web | — | ~260 lines / 17 files | built — feat/tcg-237-u1-remove-asset-department |
| U2 | Role editor says "Dispatchable" and shows boom pay / inspections only for such roles | REQ-13 | schema, api, web | — | ~210 lines / 13 files | built — feat/tcg-237-u2-role-dispatchable |
| U3 | A new tenant gets the nine departments with their roles | REQ-01, REQ-02, REQ-07, REQ-08, REQ-15 (workaround) | api (seeds), web (Departments screen) | U2 | ~360 lines / 9 files | built — feat/tcg-237-u3a-tenant-departments, feat/tcg-237-u3b-demo-departments, feat/tcg-237-u3c-legacy-seed-departments |
| U4 | Existing tenants are moved to the nine; every employee has a main role; all consumers carry a `role_id` | REQ-01, REQ-02, REQ-03 (backfill), REQ-07, REQ-08, REQ-10 (data), REQ-12 | schema (foundation) | U1, U3 | ~40 lines / 3 files (+ large migration) | built — feat/tcg-237-u4-migrate-existing-tenants |
| U5 | Quotation approval pools and the coordinator/manager checks follow a role setting | REQ-11 (approval part; F4) | api, web, mobile, shared | U4 | ~330 lines / 14 files | built — feat/tcg-237-u5-quote-approval-role-setting, feat/tcg-237-u5b-quote-approval-pickers |
| U6 | Field-ticket inspection steps follow a role setting (Oiler, 3rd Man, Driver) | REQ-11 (inspections part; F3) | api, shared, mobile | U4 | ~230 lines / 12 files | built — feat/tcg-237-u6-inspections-role-setting (U6b **blocked — Q49**) |
| U7 | A craft code points at one role; the craft form has a Role dropdown | REQ-10 (craft code), REQ-12 | schema, api, web | U4 | ~260 lines / 14 files | **blocked — Q27(b)** for the LABORER/ADMIN backfill only |
| U8 | The quotation resource picker (web and mobile) lists roles | REQ-10 | schema, api, web, mobile | U4 | ~380 lines / **~48 files** | not started — **size-exception? yes** |
| U9 | Billing codes pick a role; price-listing resolve takes a role | REQ-10 | schema, api, web | U4 | ~190 lines / 15 files | not started |
| U10 | Sub-category associated resources (and nested setting) pick a role | REQ-10 | schema, api, web | U4 | ~150 lines / 11 files | not started |
| U11 | A job's resources and a project's resources name a role | REQ-10 | schema, api, web | U8, U9, U10 | ~330 lines / 22 files | not started |
| U12 | DAS shows and allocates by the slot's role; no type-name matching in DAS | REQ-10, REQ-11 | api, web | U7, U11 | ~380 lines / 24 files | not started |
| U13 | The salesperson pickers (customer, asset sold-by, quotation, employee list) follow the Q29 answer | REQ-11 | api, web, mobile | U5 | ~250 lines / 14 files | **blocked — Q29** |
| U14 | Mobile features are gated by their own permission modules; persona and `RoleAppPersona` are removed | REQ-14, REQ-11 | schema, api, web, mobile, shared | U6, U13 | ~390 lines / 25 files | **blocked — Q23, Q31** |
| U15 | One main role on the employee form; department comes from the role; the Employee's type and department columns go | REQ-03, REQ-09, REQ-10, REQ-11 | schema, api, web, mobile, shared | U7, U12, U13, U14 | ~390 lines / 25 files | not started — **size-exception? possible** |
| U16 | An employee has a "can also fill" list | REQ-04 | schema, api, web | U15 | ~260 lines / 12 files | not started |
| U17 | Only eligible people can be placed on a ticket; DAS Employees tab shows exactly them | REQ-05, REQ-06 | api, web | U12, U16 | ~340 lines / 16 files | not started — union part **blocked on Q30** |
| U18 | Boom pay is read from the role of the position filled on the job | REQ-10 (pay read) | api, payroll-engine, vault | U11, U12 | ~220 lines / 9 files | not started |
| U19 | `CraftCode.roleType` is removed | REQ-10 | schema, api, web, shared | U7, U18 | ~300 lines / 18 files | **blocked — Q27** |
| U20 | Employee Type is retired: table, six columns, module, web feature, name constants, mobile map | REQ-10, REQ-11 | schema, api, web, mobile, shared | U1–U19 | ~330 lines / 24 files | not started |

- **Status** takes exactly one of: `not started` · `in progress — <branch>` · `built — <branch>` · `merged — PR #<n>` · `cut — <reason>`. Never a commit SHA.
- **Requirements covered:** REQ-01..REQ-15 of the 16 in `spec.md` §2, counted 2026-10-20 (16 in the spec, 15 covered, 1 not). **Not covered:** REQ-16 (per-person access) — `Q6`, pending Ryan Adams, out of build scope by developer instruction; nothing is built from either reply. Partly covered, and where the rest sits: REQ-06 (all of it, U17); REQ-14 (all of it, U14, blocked); REQ-15 — only the labelled workaround (seed each new role from its department's existing template, editable), because **Q5 stays open**.
- **Units blocked on an open question:** U4 (Q26, Q28) · U7's LABORER/ADMIN backfill (Q27b) · U13 (Q29) · U14 (Q23, Q31) · U17 union check (Q30) · U19 (Q27) · U3's codes (Q28). Everything after a blocked unit waits behind it in the stack — see *Sequencing*.
- **Open questions carried but not blocking** (the unit builds the labelled workaround or nothing): **Q5** (U3, U4 — editable template defaults), **Q23** (U14), **Q6** (no unit).
- **Raised before build, per §2b (`[UNVERIFIED]` source + a change that is expensive to undo):**
  - **U1** drops `assets.department_id` and `assets.department` with their stored values. Source is Brian Petros's three replies relayed by the developer (Q24); the FCC codes stay recoverable from the FCC seed files. Settle by: Corrina or Brian confirming nothing reports on asset department; if the vault `assets/gaps.md` future-need entry is read as a requirement, cut U1.
  - **U4** deletes the fifteen departments and re-points every employee's role in one migration. Sources: Q1, Q3 are the developer's lists (not yet seen by TCG, "open to TCG challenge"); Q26 is open. Settle by: TCG sign-off on the Q1 list and the Q3 mapping before U4 is built; an exported "before" snapshot of `employees(role_id, department_id, employee_type_id)` in the migration PR description.
  - **U15 and U20** drop columns and a table. Settle by: U4's mapping being validated on a production copy.
  - **U18** changes a pay rule (boom column follows the position, not the craft). Source: Corrina Bustos 2026-08-13 54:22–55:05 `[UNVERIFIED]` (meeting, not a decision note). Settle by a decision note via `tcg-scrum`; the provenance entry goes in the same commit as the code.

---

## U1 — Remove department from assets

> **Developer decisions 2026-10-20 (Syed Haris):** deploy window accepted (A); layout gap fixed by widening Company/Owner to `lg:col-span-8` (A) — commit `2b4d75a04`.

- **Outcome:** An asset is created, edited, listed, filtered and sorted without a department; nothing asks for one.
- **Kind:** vertical
- **Requirements covered:** REQ-01 — fully for the asset consumer (D5 / D5b = A, Q14, Q24). Not REQ-01's nine departments (U3).
- **Depends on:** —
- **Branch / PR base:** `feat/TCG-237-u1-asset-no-department` from `origin/main`.
- **Size estimate:** ~260 source lines, 17 source files. `size-exception? no`.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | Drop `Asset.departmentId` (+ FK, index) and text `Asset.department`; remove the `Department.assets` back-relation. | Migration `…_drop_asset_department`. One-way. `schema.dbml` regenerated. |
| API (`apps/api`) | `assets.repository.ts` (select `departmentRef`, filter at `:158`, sort `:200`, filter-options `:312-353`), `assets.service.ts` (`resolveDepartmentId` `:244`, create/update `:396-545`, activity-log field list), `create-asset.dto.ts`, `query-asset.dto.ts`, response mapper/types, sub-category "show assets" selects. | Remove the `department` query param, sort key and filter-option. Request/response shape change → tracer. |
| Web (`apps/web`) | `assets-list-view.config.ts:16`, `assets-list-view.columns.tsx`, `assets-list-view.tsx`, `use-assets-list-state.ts`, `assets-list-params.ts`, `asset-row.ts`, `basic-unit-info-section.tsx`, `edit-asset.helpers.tsx`, `edit-asset-view.tsx`, `edit-asset-layout.tsx`, `asset-detail-tabs.tsx`, `create-asset-dialog.tsx`, `sub-category-assets-section.tsx`, `sub-category-show-assets.tsx`. | Remove the field, column, filter chip, sort. Reuse: no new component. |
| Mobile (`apps/mobile`) | N/A — `git grep -il 'asset' apps/mobile` shows no department read; the executor re-runs it. | |
| Shared (`packages/shared`) | N/A — unless `git grep -n department packages/shared/src` finds an asset type; remove if found. | |
| Tests | Update API specs for the repository/service; web asset list tests; `qa-automation/e2e/specs/asset-management/assets/1-lifecycle.spec.ts` (lines 109-139, 284-285, 427, 486-487: creates two departments, picks them in `Search department`, asserts `departmentRef`); `assets.page.ts:42` filter id `'department'`. | One row per test below. |

**Tests the slice must carry:** (1) API: create/update asset with a `department` or `departmentCode` is rejected as an unknown property or ignored — assert the response code the DTO's whitelist gives today; (2) API: list with `sort=department` is rejected; (3) negative — an asset's sub-category, category, yard and status filters and sorts still work (REQ-01 *Does not apply when* is N/A, so this regression row covers the neighbours); (4) migration check — `assets` has neither column afterwards and the row count is unchanged; (5) web: list renders without the Department column/filter; (6) qa: the lifecycle spec no longer creates or picks a department.

### Reviewable as

- **Demo:** Assets list: no Department column, filter or sort; Create asset form has no Department field; `GET /assets?department=x` is not accepted.
- **Acceptance:** `spec.md` §12 Q24 answer + D5/D5b; REQ-01 Edges (*Reached by*).
- **Reviewer can verify without:** any other unit.

### Risk

- **Weakest source:** `[UNVERIFIED]` — Q24 is Brian Petros's relayed reply read by the developer.
- **Migration reversible:** **no** — drops two columns and their data. FCC values stay recoverable from the FCC seed files (Q24).
- **Behind a flag:** no.
- **Touches existing data:** yes — stored `department_id`/`department` values are discarded (D5b = A: "stored values included").
- **Blast radius:** asset list/form/filter, and any report or export that reads asset department. `git grep -n 'departmentRef\|asset.*department' apps packages qa-automation` must be empty at the end.
- **Guardian / tracer:** `tcg-prisma-guardian` **required** (schema); `tcg-contract-tracer` **required** (request/response shape).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Asset list filters/sorts (category, sub-category, yard, status) | same repository `where`/`orderBy` | API repository spec + web list-state test | D5b; Q24 |
| Sub-category "show assets" / create-asset dialog | `departmentRef` select | web test on the dialog | D5b |
| Asset activity log field list (`assets.service.ts:545`) | `['departmentId']` entry | service spec: update without department logs nothing for it | D5b |
| `qa-automation` asset lifecycle | `Search department` placeholder, `departmentApi` | spec updated in this unit | `CLAUDE.md` → data-testid |
| Departments delete guard (`deletion-reference.service.ts`) | counts employees/roles only | none needed — it does not count assets (`grep -n asset apps/api/src/service/deletion-reference`) | n/a |

### Deliberately not in this unit

- Any grouping of assets "by department or something else" for fleet-maintenance inventory — `vault/assets/gaps.md` (Brian's second reply); not a requirement.
- Asset category/type filtering for iPads/phones — already exists via category/sub-category (Q24); out of scope.

---

## U2 — Role editor: "Dispatchable"

> **Developer decisions 2026-10-20 (Syed Haris):** deploy window accepted (A); Quote approval hidden for Dispatchable roles (A); badge "Dispatchable" and suggestion hint "dispatchable" accepted (A); old activity-log rows keep "Used As Employee Type" (A).

- **Outcome:** An administrator opening a role sees a "Dispatchable" switch; boom pay and inspections appear only when it is on; quote approval is hidden when it is on.
- **Kind:** vertical
- **Requirements covered:** REQ-13 — fully (Q16 = A, Q21 = split by time; D3 = B).
- **Depends on:** —
- **Branch / PR base:** `feat/TCG-237-u2-role-editor-dispatchable` from `origin/main`.
- **Size estimate:** ~210 source lines, 13 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | Rename `DepartmentRole.usedAsEmployeeType` → `isDispatchable` (`@map("is_dispatchable")`) and its index `idx_department_roles_tenant_used_as_emp_type` → `idx_department_roles_tenant_dispatchable`. | `ALTER TABLE … RENAME COLUMN` + `ALTER INDEX … RENAME`, lossless. `schema.dbml` regenerated. |
| API | `role-behaviour.dto.ts:33`, `departments.service.ts` (`:38`, `:56`, `:413`, `:431` incl. `findNameSuggestions`), `department-roles.repository.ts:77`, `tenant-seed.service.ts:431`, `tenant-seed.types.ts:35`, `demo-data/data/organisation.ts:30,102-131`, `seed-reference-data.ts:278`. | Field rename in the role request/response → tracer. Hidden stored values are **kept** (Q21 B): the API does not clear `boomPay` / `runsInspections` / `quoteApproval` when `isDispatchable` flips. |
| Web | `role-behaviour.section.tsx` (label + conditional rows), `role-create.tsx`, `role-create.helpers.ts`, `role-form-values.ts`, `departments.service.ts` (web), `department-role-badges.tsx`, `department-role-card.tsx`. | Test IDs keep their names except `departments-role-used-as-employee-type` → rename with the field and update `grep -rn` in qa (no qa spec references it today; the executor re-runs the grep). Copy for the label: Q16 A says "Dispatchable"; any other string is not specified. |
| Mobile | N/A — mobile reads no role setting (`git grep -n usedAsEmployeeType apps/mobile` empty). | |
| Shared | N/A. | |
| Tests | see below | |

**Tests the slice must carry:** (1) API: PATCH a role with `isDispatchable:false` keeps stored `boomPay`/`runsInspections` (Q21 B); (2) negative — `quoteApproval` is still accepted and stored for a non-dispatchable role, and hidden for a dispatchable one only in the UI; (3) migration check — row count and every role's flag value identical before/after the rename; (4) web: boom pay and inspections render only when Dispatchable is on; quote approval renders only when it is off; (5) web: the old `usedAsEmployeeType` key is not sent (`git grep -n usedAsEmployeeType apps packages` empty).

### Reviewable as

- **Demo:** Departments → a department → a role → edit: toggle Dispatchable and watch the dependent rows.
- **Acceptance:** Q16 = A, Q21 answer, D3 = B.
- **Reviewer can verify without:** any other unit.

### Risk

- **Weakest source:** `[UNVERIFIED]` — developer answers to Q16/Q21 (open to TCG challenge).
- **Migration reversible:** yes (rename back).
- **Behind a flag:** no.
- **Touches existing data:** no (rename only).
- **Blast radius:** role create/edit, the role-name suggestions that merge `EmployeeType` names (`findNameSuggestions`), seeds. Q21 history clause ("tickets already completed keep the boom pay they were calculated with") has no effect here because no pay code reads `boomPay` yet; it binds **U18**.
- **Guardian / tracer:** `tcg-prisma-guardian` **required**; `tcg-contract-tracer` **required** (role DTO field renamed).

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source |
| --- | --- | --- | --- |
| Tenant seed + demo seed | `usedAsEmployeeType` in seed role specs | seed spec asserts `isDispatchable` true on Operator/Oiler/Rigger/3rd Man demo roles | D3 |
| Role-name suggestions (`findNameSuggestions`) | `usedAsEmployeeType: true` select `:431` | existing `departments.service` spec updated | D3 |
| Role cards/badges | `department-role-badges.tsx` | web test | Q16 |
| `qa-automation` departments lifecycle | role create/edit flow | run `grep -rn 'used-as-employee-type\|role-behaviour' qa-automation/e2e` — none today; keep none | `CLAUDE.md` → data-testid |

### Deliberately not in this unit

- `appPersona` field and its test ids — removed with mobile gating in **U14** (D7).
- Role settings values for the nine roles — **U3/U4**.

---

## U3 — The nine departments and their roles for new tenants

> **Developer decisions after the U3a–c review, 2026-10-20 (Syed Haris):** (a) seeded boom pay — Operator → OPERATOR column, Oiler → OILER, every other role none: **confirmed**; (b) demo/legacy staff → roles (Alex Morgan → Management/Manager; Dispatch Lead → Dispatcher; Yard Man → Yard Tech; Safety Admin → Safety; Crane Operator → Operator): **confirmed**; (c) `SequenceRepository` called from the seed via cast: **accepted**; (d) **re-running the seed re-syncs `permissions` / `lockedPermissions` on existing system roles, as the old upsert did (restore)**; (e) `appPersona` left at default OFFICE until U14 removes it: **accepted**; `tenant-seed.*` files stay in U3b; **qa mirror `qa-automation/e2e/support/seed/system-departments.ts` re-synced to the nine and Q1 roles in U3a**. Seeded role count is **29** (the brief's "30" was a miscount).

> **Developer decisions 2026-10-20 (Syed Haris):** split into **U3a** (every new tenant gets the nine — commit `cb58b88d3`) and **U3b** (demo tenant uses the nine — `f80089a09`, stacked on U3a); `SYSTEM_DEPARTMENTS` shared export accepted; Q32 A (Payroll Admin seeded without `payroll-admin`); Q33 B (Crane Superintendent Dispatchable); Q34 C (Dispatchable roles: explicit `none` on every web module); **fix** the two broken specs (`crane-supervisor-retired.spec.ts`, `payroll-admin-permission.spec.ts`) minimally; **sibling yes:** legacy `GET /seed/run` (`CRANE_GUYS_DEPARTMENTS`) also uses the nine.

- **Outcome:** A newly created tenant (and the demo tenant) opens Departments and sees exactly Field Operations, Shop, Yard, Dispatch, Sales, Accounting, Safety, HR and Management, each with the Q1 roles, editable.
- **Kind:** vertical
- **Requirements covered:** REQ-01, REQ-02 (Q1 list), REQ-07 (Job Foreman is not seeded), REQ-08 (Payroll Admin under HR), REQ-15 (workaround only; **Q5 open**). Q15 = A.
- **Depends on:** U2.
- **Branch / PR base:** `feat/TCG-237-u3-nine-departments-seed` stacked on U2's branch.
- **Size estimate:** ~360 source lines, 9 source files. `size-exception? no`, but the seed file is 2,932 lines — touch only `SYSTEM_DEPARTMENTS` and its helpers.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | `seed-data.ts` (`SYSTEM_DEPARTMENTS` `:290-…` replaced by the nine; role lists per Q1; `isDispatchable` on Operator, Oiler, 3rd Man, Rigger, Driver, Crane Superintendent per the existing seeds' intent — **only what the developer has stated: F3 `runsInspections` on Oiler, 3rd Man, Driver; F4 `quoteApproval` COORDINATOR on Sales Coordinator, MANAGER on Sales Manager**), `tenant-seed.service.ts` (`seedDepartments`, name-reconcile branch `:416-428`), `utility/demo-data/data/organisation.ts` + `people.ts` (`DEPT-ADMIN/FLEET/RIGGING…` codes), `tenant-seed.types.ts`, `seed-reference-data.ts`. | Department/role **codes**: `NOT SPECIFIED` — **Q28**; the executor stops on this. Seeded permissions per role = the labelled REQ-15 workaround (the old department's template, Q26b) — **Q5 stays open**, do not write a permission matrix. `Job Foreman` is not seeded. |
| Web | Departments list/detail needs no code if it renders from the API; verify. | |
| Mobile / Shared | N/A. | |
| Tests | see below | |

**Tests the slice must carry:** (1) seed spec — tenant provisioning yields exactly nine departments by the names in REQ-01 (case as written) and no tenth; (2) seed spec — each Q1 role present under its department; **no role named Job Foreman** (REQ-07 acceptance); Payroll Admin is under HR (REQ-08); (3) re-running the seed on an existing tenant adds nothing twice (idempotent, the by-name reconcile branch); (4) negative — a tenant seeded earlier is *not* changed by this unit (that is U4); (5) role settings: Oiler, 3rd Man, Driver have inspections on, others off; Sales Coordinator / Sales Manager carry the approval values (F3, F4).

### Reviewable as

- **Demo:** Provision a tenant (`GET /seed/run` or the tenant-create flow) → Departments screen lists nine.
- **Acceptance:** REQ-01 acceptance, REQ-07 and REQ-08 acceptance lines, Q15.
- **Reviewer can verify without:** U4 and any later unit.

### Risk

- **Weakest source:** `[UNVERIFIED]` — Q1 role list and F3/F4 are developer answers; no TCG sign-off.
- **Migration reversible:** N/A — no migration; seed only.
- **Behind a flag:** no.
- **Touches existing data:** no (new tenants, demo).
- **Blast radius:** tenant creation; demo data; `findNameSuggestions` merges `EmployeeType` names into role suggestions — verify it still behaves while the table exists.
- **Guardian / tracer:** `tcg-prisma-guardian` not required (no schema change; the executor confirms tenancy of seeded rows). `tcg-contract-tracer` not required (no shape change).

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source |
| --- | --- | --- | --- |
| Demo-data seeds (`organisation.ts`, `people.ts`, `seed-reference-data.ts`, `demo-flows.service.ts`) | department/role codes | the demo seed test/run still completes; employees get roles from the new list | Q15 |
| `SALES_COORDINATOR_ROLE_NAME` / `SALES_MANAGER_ROLE_NAME` seeds in `seed-data.ts:1135` ("same roleCodes as SYSTEM_DEPARTMENTS") | role codes | seed spec | Q1 |
| Notification recipients by department code | `recipient-resolver.service.ts:189` | not touched here; **Q28** | D5 |
| `qa-automation` departments + assets fixtures that create departments | `departmentApi.create()` | `grep -rn 'DEPT-' qa-automation/e2e` reviewed | `CLAUDE.md` |

### Deliberately not in this unit

- Existing tenants' departments/roles/employees — **U4**.
- Any permission matrix per role — **Q5**.
- ~~`Crane Superintendent` as a ticket slot — it is not (REQ-05 acceptance); only a role.~~ Overridden by **Q33 = B** (Syed Haris, 2026-10-20): every Field Operations role is Dispatchable, Crane Superintendent included, so it can be picked as a slot; REQ-05's acceptance line no longer holds for it.

---

## U4 — Existing tenants move to the nine; main role backfilled; consumers get a `role_id` (foundation)

> **Runbook check added from U5 (2026-10-20):** after the dry run on the production copy, confirm every role that approves quotes today carries the matching setting — `SELECT name, quote_approval FROM department_roles WHERE lower(name) IN ('sales coordinator','sales manager');` — a Sales Coordinator / Sales Manager left at NONE would drop its holders from every approval pool once U5 ships.

> **Developer decision 2026-10-20 (Syed Haris):** U4 is 408 source lines / 5 files vs U3c (8 over ~400) and cannot be split cleanly (guard needs the columns; RESTRICT without the guard turns deletes into 500s; dry run reads the migration) — **A: ship as one PR with the `size-exception` label**, reason stated in the PR description.

> **Developer decisions after the U4 analyst review, 2026-10-20 (Syed Haris):** (Q-a) Q40 duplicates — keep the survivor rule (row whose type names the role, else oldest) **and merge settings**: a boolean setting is on in the kept row if it was on in either row; (Q-b) the `removeRole` in-use guard counts **active** employee holders only — archived holders do not block and lose the role on delete (FK SET NULL), as before; (Q-c) migrated employees get `updated_at = now()` — accepted (their role really changed). Dry run to add: employees whose department is cleared (old → new department), and the differing settings of each Q40 duplicate pair. Recorded as built without a decision, not challenged: craft role_type → role pairs (OPERATOR → Operator, OILER → Oiler, THIRD_MAN → 3rd Man, MECHANIC → Mechanic); "oldest active department of that name is reused"; the dry run's lock/statement timeouts. `schema.dbml` staleness (craft_codes, nested settings tables absent) is a separate follow-up.

> **Developer decisions after the U4 re-review, 2026-10-20 (Syed Haris — accepted the stated lean on each item):** (1) "Operations and Maintenance" spelling added beside "Operated & Maintained" → Field Operations: accepted; (2) a new role that old roles merge into **starts from its template, then takes the highest level per module from each merged role**; (3) Q38e reading — unmapped type: no role *from the type*, existing role kept, review list: accepted; (4) Q40 stop when a deleted duplicate association has nested settings: accepted; (5) backfilled rows keep their `updated_at`: accepted; (6) shorten the 409 "role in use" message so it stays under the 180-character sanitiser cap (count + kinds); (7) the backfill decays when sub-category / quotation-resource / job-resource saves rewrite rows without the role — accepted because U4–U15 ship as one release train (6B); U8–U11 must write the role on save; (8) locked modules are not reconciled with the union — accepted (`lockedPermissions` restricts nothing, decision 2026-09-04); (9) map the FK violation (P2003) on a racing `removeRole` to the same 409; plus a JSDoc note that `countDepartmentRoleReferences` needs a tenant-resolved roleId.

- **Outcome:** After this ships, every existing tenant shows the nine departments; every employee that had a type has the Q3 role as main role; every table that points at an Employee Type also points at a role. (Nothing reads the new columns yet; each later unit switches one consumer.)
- **Kind:** **foundation, schema/data-only.** Justification (template exception): the units **U5, U6, U7, U8, U9, U10, U11, U12, U15** all depend on one backfill; split per unit it would repeat the type→role mapping in nine migrations against the same tables (D4 = A puts the mapping table *in the migration file*, once).
- **Requirements covered:** REQ-01, REQ-02, REQ-03 (backfill), REQ-07, REQ-08, REQ-10 (data), REQ-12.
- **Depends on:** U1 (assets no longer hold a department FK), U3.
- **Branch / PR base:** `feat/TCG-237-u4-migrate-roles` stacked on U3's branch.
- **Size estimate:** ~40 source lines, 3 source files (schema additions, `schema.dbml`, the migration verification script); the migration is excluded from the budget. `size-exception? no`.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | Add nullable `role_id uuid REFERENCES department_roles(id)` (+ index) to `employees`-adjacent consumers: `billing_codes`, `quotation_resources`, `job_resources`, `sub_category_associated_resources` (`associated_role_id`), `sub_category_nested_association_settings`, and `craft_codes`. `employees.role_id` already exists. | New column names are a structural choice — the executor **proposes names and stops for the developer** (`CLAUDE.md`). Each is tenant-scoped via the role; check the `$extends` allowlist note in `contexts/prisma.md`. |
| Migration steps | (1) Create the nine departments and roles per tenant (self-contained copy of the U3 list; rows that exist by name are reused). (2) Mapping table inside the migration (D4 = A): Q3 — Operator, Oiler, 3rd Man, Rigger, Driver → same-named Field Operations roles; Mechanic and Shop → Mechanic; Yard Man → Yard Tech; Dispatch Admin → Dispatcher; Sales Admin → Sales Coordinator; Salesmen → Salesperson; Accounting Admin → Accounting; Safety Admin → Safety; Management → Manager; Job Foreman, Apprentice, Default → none. (3) Set `employees.role_id` from the type (immediate, Q20 = A) and `employees.department_id` from the new role's department; employees with no mappable type keep **no main role**, are written to a review list (Q19 = A) — what happens to a pre-existing role those employees hold is **Q26(a)**. (4) Backfill the six `role_id` columns from their `employee_type_id` through the same mapping (Q13 = B: the mapped role's name now shows). (5) Backfill `craft_codes.role_id` from `role_type` — LABORER and ADMIN have no role in Q1: **Q27(b)**. (6) Delete the fifteen old departments and the roles that emptied (Q26). (7) Apply F3/F4 values to the migrated roles. | One-way. The migration writes a count table (employees by type → role, unmapped count) into the PR description. |
| API / Web / Mobile / Shared | N/A | |
| Tests | Migration check (spec §10): every employee with a type has a main role afterwards; no orphaned FK; per-table `role_id IS NOT NULL` count equals `employee_type_id IS NOT NULL` minus the unmapped types; run twice → no change; run against a copy that has a tenant with a custom-named department. | `tcg-prisma-guardian` replays it. |

### Reviewable as

- **Demo:** `SELECT` counts per table before/after; Departments screen on a migrated copy shows nine.
- **Acceptance:** REQ-01 acceptance (nine, no tenth), REQ-07 (no Job Foreman role, no employee left with one), REQ-12 spec §10 migration check.
- **Reviewer can verify without:** any code unit — the migration is the unit.

### Risk

- **Weakest source:** `[UNVERIFIED]` — Q1, Q3 are developer answers; Q26 and Q28 open. **This is the unit where unconfirmed sources meet an unrecoverable change — see the ledger.**
- **Migration reversible:** **no** — deletes the fifteen departments, rewrites `employees.role_id` and `department_id` (the old values are not kept). Mitigation required before build: export of the old `(employee, role, department, type)` table attached to the PR.
- **Behind a flag:** no.
- **Touches existing data:** yes — all of the above. Q20 = A: on migration day each user gets their new role's permissions immediately. **Q5 is open**, so the permissions are the labelled template workaround and may differ from today's for some users; the PR description lists the users whose permission map changes.
- **Blast radius:** every login (permissions follow the role), notification recipients that resolve by department, DAS exclusion by department name `Sales`.
- **Guardian / tracer:** `tcg-prisma-guardian` **required**; `tcg-contract-tracer` not required (no shape change).

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source |
| --- | --- | --- | --- |
| `PermissionsGuard` / `permissions.service.ts` | `employee.role.permissions` | migration test: a sampled user's effective permissions equal the new role's map | Q20 = A; **Q5 open** |
| `recipient-resolver.service.ts:189` (dispatch, HR notifications) | `employee.department` code | migration test: dispatcher employees land in the Dispatch department; **Q28** for the config code | D5 |
| `das.repository.ts:51-52` (Sales exclusion by department name) | `employee.department` | migration test: Sales Coordinator / Salesperson employees land in Sales | REQ-06 (replaced in U17) |
| Quotation/job/billing/sub-category pickers | `employee_type_id` | unchanged; `role_id` filled but unread | Q13 = B |

### Deploy runbook (Q41 = A, Syed Haris 2026-10-20)

1. **Rehearse on a production copy.** Restore a recent copy, run the dry run against it (`DATABASE_URL=… npx ts-node --transpile-only -r tsconfig-paths/register prisma/scripts/dry-run-nine-departments-migration.ts --snapshot before.csv`, from `apps/api`), have the developer read the review sections, then run `prisma migrate deploy` on the copy and **time it** — that time sizes the window.
2. **Keep the snapshot.** `before.csv` is the only record of today's `(employee, role, department, type)`; it holds names and is **PII** — store it with restricted access, never in the repo or a PR.
3. **Maintenance window, app quiesced.** Stop API pods and workers (cron, queues) so nothing writes; the migration takes strong locks on `employees`, `department_roles`, `departments`, `billing_codes`, `quotation_resources`, `job_resources`, `craft_codes` and both sub-category tables for its whole run. U4–U15 ship as one release train (6B).
4. **Connection.** A direct, non-pooled `DATABASE_URL` (not a transaction-mode pooler) whose role may create TEMP tables; Postgres 13 or later (`gen_random_uuid()`).
5. **Run** `pnpm --filter @tcg/api prisma:deploy` (`migrate-deploy.sh`). The migration is one transaction: a guard RAISE rolls everything back.
6. **On failure:** read the RAISE text, fix the cause, then `prisma migrate resolve --rolled-back 20261020140000_migrate_tenants_to_nine_departments_and_role_ids` before redeploying — otherwise every later deploy stops on P3009.
7. **After:** Departments screen shows nine per tenant; spot-check the users the dry run listed under Q20.

### Deliberately not in this unit

- Reading any `role_id` — each of U5–U12.
- Dropping any old column — **U20** (D11 = C).
- Employees' can-also-fill rows — **U16** (Q4 superseded, no FCC secondary load).

---

## U5 — Quotation approval follows a role setting

> **Developer decisions after the U5 follow-up, 2026-10-20 (Syed Haris):** (1) **split** — U5 = `351e70e8e` + Q43/Q44/Q45; **U5b** stacked on U5 = Q42 (the `GET /employee` `quoteApproval` filter, web and mobile Sales Coordinator pickers, self-defaults, form seed, mobile mock, CC suggestions); (2) **keep accepting `roleName` on `GET /employee` until U20**, treating "Sales Coordinator" as `quoteApproval = COORDINATOR`, so installed mobile builds keep working (no minimum-app-version gate exists); U20 removes it; (3) an approver who starts the app **offline** with a profile cached before the upgrade sees the non-approver view until reconnecting — **accepted**.

> **Developer decisions 2026-10-20 (Syed Haris):** Q42 A (all remaining name matches fixed in U5 via a `quoteApproval` filter on `GET /employee`); Q43 A (names accepted, unused `findApproverPoolByRole` deleted); **Q44 A** — fix `apps/mobile/data/contracts/identity.contract.test.ts` minimally so mobile typecheck passes, leave the other failing specs for the test owner; **Q45 A** — check whether mobile caches the identity profile; if it does, refetch it once after the upgrade so `quoteApproval` is present.

- **Outcome:** Who approves a quotation (coordinator stage, manager stage) is decided by the role's *Quote approval* setting; renaming "Sales Coordinator" no longer breaks approvals.
- **Kind:** vertical
- **Requirements covered:** REQ-11 — the approval-pool part only (F4 = A, Q11, Q17). The salesperson-detection part is **U13** (Q29).
- **Depends on:** U4.
- **Branch / PR base:** `feat/TCG-237-u5-quote-approval-role-setting` stacked on U4.
- **Size estimate:** ~330 source lines, 14 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A (`quoteApproval` exists on the role; set by U3/U4) | |
| API | `approval-routing.ts` (`:45-64`, `:136`), `quotation-approvals.service.ts` (`:560`, `:861`, `:916`, `:1231`, `:1292-1299`), `quotation-signatures.service.ts` (`:3462`, `:3536`), `quotations.controller.ts` (`:117`), `quotations.service.ts` (`:705`), `users.repository.ts` `findApproverPoolByRoles` (by role **name** → by `quoteApproval`), profile mapper in `users.service.ts` (`GET /users/me` gains the role's `quoteApproval`). | The pool query changes key; names are not compared. `SALESPERSON_TYPE_NAME` uses at `approval-routing.ts:45`, `quotation-approvals.service.ts:1292`, `quotations.service.ts:1813` stay for U13. |
| Web | `auth-provider.tsx` `isSalesCoordinator` / `isSalesManager` / `isApprover` read the profile setting. | |
| Mobile | `identity.contract.ts` `isSalesCoordinator/isSalesManager/isApprover` (`:68-100`) read the setting; the `IdentityProfileSchema` gains the field. | |
| Shared | Remove `SALES_COORDINATOR_ROLE_NAME` / `SALES_MANAGER_ROLE_NAME` users in this unit's reach; the constants are deleted in **U20** when the last user goes. | |
| Tests | see below | |

**Tests the slice must carry:** (1) unit — pool resolves COORDINATOR/MANAGER holders regardless of role *name* (rename a role in the fixture; approvals still route); (2) negative — a role with `quoteApproval: NONE` is never in either pool even if named "Sales Manager"; (3) regression for existing consumers (below); (4) API-level — resolving an approval as a non-pool user returns the same status code as today; (5) web + mobile: Approvals entry point shows for the setting, not for a name.

### Reviewable as

- **Demo:** Submit a quotation for approval; the Sales Coordinator-setting role sees the request; rename the role and repeat.
- **Acceptance:** Q11 (F4 = A: approval pools preserved, moved onto role settings), Q17 = A.
- **Reviewer can verify without:** U6–U20.

### Risk

- **Weakest source:** `[UNVERIFIED]` (developer reading, "pending TCG challenge", Q11).
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** quotation approval routing and signature flows — mis-routing leaves quotes stuck.
- **Guardian / tracer:** `tcg-prisma-guardian` not required; `tcg-contract-tracer` **required** (`GET /users/me` gains a field; web + mobile + shared consume it).

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source |
| --- | --- | --- | --- |
| Approver pool (`users.repository.ts`) | role name match | `users.repository` / approvals service specs rewritten around the setting | Q11 F4 |
| Quotation approval routing stages | `approval-routing.ts` | existing routing spec kept; new case for a renamed role | Q11 F4 |
| Signatures flow (`quotation-signatures.service.ts`) | same pools | existing spec rerun | Q11 |
| Mobile Approvals tab | `isApprover` | mobile contract test | Q11 |
| Web approvals UI | `auth-provider.tsx` | web test | Q11 |

### Deliberately not in this unit

- SALESPERSON stage detection and salesperson pickers — **U13 / Q29**.
- Wes Staley's different description of approval (≥ $50k or reduced rate) — for the quotations module, not this ticket (Q11).

---

## U6 — Field-ticket inspections follow a role setting

> **Q47 / Q48 (2026-10-20, Syed Haris):** U6 adds `DepartmentRole.craneInspectionOrder` (nullable Int, `crane_inspection_order`; seed and migrate Oiler = 1, Operator = 2; editor shows it only when Dispatchable) and the no-slot fallback: order 1 → FULL, `isDispatchable && runsInspections` → own-inspections flow (STANDARD + the four inspection steps), else STANDARD. If the new own-inspections flow (step list, holdover variants, mobile rendering, submit guard) pushes U6 over budget, split it into **U6b**.

> **Developer decision 2026-10-20 (Syed Haris), Q46:** U6 is **re-scoped to the no-slot fallback only** (viewer's role `isDispatchable && runsInspections` replaces the "Oiler" name check; `runsInspections` on `GET /users/me` in U5's shape and refetch rule). The set-level crane-inspection rule (46a) moves into **U12**; the 3rd Man / Driver own-inspection steps (46b) wait on Q47 and are built after U12.

- **Outcome:** The Pre-Trip, JSA, Post-Trip and Compliance steps show on a field ticket for roles with "Runs inspections" (Oiler, 3rd Man, Driver), not only for an employee whose type is named Oiler.
- **Kind:** vertical
- **Requirements covered:** REQ-11 — inspections part (F3 = B, Q11).
- **Depends on:** U4. (Order after U5: both edit the `GET /users/me` mapper.)
- **Branch / PR base:** `feat/TCG-237-u6-inspections-role-setting` stacked on U5.
- **Size estimate:** ~230 source lines, 12 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | `field-ticket.mapper.ts`, profile mapper (`runsInspections` on `GET /users/me`), `job-progress.service.ts:105` (Oiler check by type name — **verify first whether it is the inspections rule or a progress rule; if progress, leave and record**). | |
| Web | N/A unless `git grep -n visibleFlowStepKeys apps/web` finds a reader. | |
| Mobile | `features/field-ticket` (3 files + `flow` + `sync` 3 + `steps/labor`), identity contract, `session/store.ts`. | Pickers/lookups that read the type name only for this purpose change; the quote picker is U8. |
| Shared | `ticket-flow-steps.ts` `visibleFlowStepKeys` takes the setting, not `OILER_TYPE_NAME`. | Cross-surface: web+mobile import it → update both consumers here. |
| Tests | see below | |

**Tests the slice must carry:** (1) unit — `visibleFlowStepKeys(runsInspections: true)` includes the four steps for Oiler, 3rd Man and Driver fixtures; (2) negative — an Operator (setting off) does not get them, even though it did not before either (behaviour kept) and a role *named* "Oiler" with the setting off does not; (3) regression — existing ticket-flow tests for an Oiler still pass with the setting on; (4) which checklist each role gets is **out of scope** (Q11).

### Reviewable as

- **Demo:** Mobile field ticket as an Oiler, 3rd Man, Driver vs Operator.
- **Acceptance:** Q11 (F3 = B).
- **Reviewer can verify without:** U7–U20.

### Risk

- **Weakest source:** `[UNVERIFIED]` — meeting-evidence reading (Melissa McNutt 2026-06-04 21:12; 2026-05-19 41:51).
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** 3rd Man and Driver gain inspections steps they did not have — a **deliberate** behaviour change (Q11: "not preserved exactly").
- **Guardian / tracer:** guardian not required; tracer **required** (profile field; shared export signature).

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source |
| --- | --- | --- | --- |
| Mobile field ticket flow | `visibleFlowStepKeys(OILER_TYPE_NAME)` | mobile flow tests rerun for the Oiler case | Q11 F3 |
| Web ticket views (if any) | shared export | `git grep` result recorded; none = `none — grep: visibleFlowStepKeys apps/web` | — |
| Offline/cached session on device | `GET /users/me` shape | **cached sessions lack the new field** — the mobile code treats a missing field as "setting off" and refreshes on next launch; the window is named in *Sequencing* | `spec.md` §6 (offline unspecified) |

### Deliberately not in this unit

- Which checklist applies to Driver / 3rd Man (Q11).
- Dropping `OILER_TYPE_NAME` — **U20**.

---

## U7 — A craft code points at one role

- **Outcome:** In the craft code form the Role-type pick becomes a Role pick; each craft code has one role, a role can have many craft codes.
- **Kind:** vertical
- **Requirements covered:** REQ-10 (craft code consumer; D12 = D), REQ-12 (craft → role backfill from U4).
- **Depends on:** U4.
- **Branch / PR base:** `feat/TCG-237-u7-craft-code-role` stacked on U6.
- **Size estimate:** ~260 source lines, 14 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | `CraftCode.roleId` (column added in U4) made the written/read column; `CraftCode.roleType` **stays** until U19. | Migration only to add NOT NULL once backfilled — blocked for the LABORER/ADMIN crafts on **Q27(b)**; until then nullable and the form requires it on create/edit. |
| API | `craft-code.dto.ts` (`roleId` accepted; `roleType` still accepted and still what payroll reads), `craft-codes.service.ts`, `craft-codes.repository.ts`, `employee-craft-assignments.*` selects, the FCC craft seeder. Role list endpoint for the dropdown: **structural — reuse an existing departments/roles endpoint if it can filter**; executor lists candidates and stops (`CLAUDE.md`). | Response gains `role`. Tracer. |
| Web | craft code form + list (`git grep -il 'craft' apps/web/src/features` for the files), Role dropdown replaces the Role-type select. | Reuse the role select built for the employee form if one exists (`DepartmentRoleSelect`). |
| Mobile | `git grep -n craft apps/mobile` — executor confirms any reader. | |
| Shared | `CraftRoleType` stays. | |
| Tests | see below | |

**Tests the slice must carry:** (1) API: create/update a craft code with a role of another tenant → rejected (the tenant check); (2) a role with many craft codes; (3) negative — payroll output for a fixed payroll week is **identical** (same-result test; `roleType` untouched); (4) web form picks a role.

### Reviewable as

- **Demo:** Edit a craft code → pick a role → saved; open payroll setup warnings unchanged.
- **Acceptance:** D12 = D.
- **Reviewer can verify without:** U8+.

### Risk

- **Weakest source:** `[UNVERIFIED]` — developer decision D12.
- **Migration reversible:** yes while the column is nullable.
- **Behind a flag:** no.
- **Touches existing data:** yes — `craft_codes.role_id` already backfilled in U4.
- **Blast radius:** payroll setup — kept safe by leaving `roleType` as the pay input.
- **Guardian / tracer:** guardian **required**; tracer **required**.

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source |
| --- | --- | --- | --- |
| Payroll pricing (`pay-week-assembly.ts:516-543`, `craft-rate-resolver.service.ts`) | `craft.roleType` | same-result payroll test on a fixture week | `contexts/payroll-engine.md`; D12a deferred to U19 |
| DAS craft pick (`das-allocations.service.ts:1383-1433`) | `craft.roleType` | existing spec rerun | — |
| Employee primary-craft check (`employee.service.ts:549-564`) | `craftRoleTypeForEmployeeTypeName` | unchanged here; replaced in **U15** | D2c |

### Deliberately not in this unit

- Removing `roleType` — **U19 / Q27**.
- Boom read from the role — **U18**.

---

## U8 — The quotation resource picker lists roles (web and mobile)

> **From the U4 re-review (2026-10-20):** this unit's save path must write the role, or the U4 backfill is erased on the next save.

> **Acceptance added from the U4 guardian review (2026-10-20):** the new role FKs are not tenant-composite — every writer in this unit must check the role belongs to the current tenant before saving.

> **Developer decision 2026-10-20 (Syed Haris): U8 = B — split.** API + web ship as U8; mobile ships as its own stacked PR (U8m) right after. No `size-exception`. Accepted consequence: quoting on mobile is broken between the two merges unless the double write covers it (pending).

- **Outcome:** Adding a labour line to a quotation, on web and on mobile, picks from roles; existing quotations show the mapped role's name.
- **Kind:** vertical
- **Requirements covered:** REQ-10 (QuotationResource consumer) — fully; Q13 = B.
- **Depends on:** U4.
- **Branch / PR base:** `feat/TCG-237-u8-quotation-resource-role` stacked on U7.
- **Size estimate:** ~380 source lines, **~48 source files** (api 10, web ~26 incl. `lib/resource-catalog.ts` and `components/molecules/resource-item-select.tsx`, mobile ~12). **Does not fit the 25-file budget. `size-exception? yes` — the field rename `employeeTypeId → roleId` is mechanical (~2 lines per file) and §11c requires web and mobile to change together; a developer confirms or chooses the alternative below.**

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | `QuotationResource.roleId` becomes the written/read column; `employee_type_id` stays until U20. | Migration: none beyond U4 (maybe NOT NULL where the type was non-null — executor decides with guardian). |
| API | `create-quotation.dto.ts`, quotations usecase/service/repository files that carry `employeeTypeId` (10 files by `grep`), `resource-catalog` service/controller (picker data), `price-listings` resolve call. Picker data = dispatchable roles of the tenant. | **Endpoint choice is structural**; D10 = B replaces outright. Tracer. |
| Web | `features/quotations` 36 files (`resources-tab*.ts(x)`, `resource-row.*`, `use-resource-tab-catalogs.ts`, `use-add-custom-type-flow.ts`, `use-billing-code-fanout.ts`, `quotation-api.ts`, `quotation-payloads.ts`, `edit-quotation.mapper.ts` …), `lib/resource-catalog.ts`, `components/molecules/resource-item-select.tsx`. | Reuse `resource-item-select`; no new component. |
| Mobile | `data/services/resource-catalog/*` (3), `data/services/quotations` (2), `data/contracts/employee-type.contract.ts`, `features/sales` (6), `components/sales` (3), `app/(sales)/quotes`. | The contract stops being "employee type". |
| Shared | `types/employee.types.ts` `EmployeeTypeRecord` if used by the picker — removed in U20. | |
| Tests | see below | |

**Alternative if the developer refuses the exception:** split API+web (U8a) from mobile (U8b) and accept a named window in which the mobile quote picker is broken between U8a and U8b — rejected here because that window breaks quoting on devices.

**Tests the slice must carry:** (1) API: create a quotation with a role id not in the tenant → 4xx (same code as other tenant-id checks); (2) negative — a non-dispatchable role (`isDispatchable:false`) is not offered by the picker; (3) regression — quotation total/pricing for an existing quotation is unchanged after the migration (price is not read from the type); (4) existing quotation loaded for edit shows the mapped role name (Q13 = B); (5) web `resources-tab.child-tree.test.mjs` and `resource-pricing-targets.test.mjs` updated (they carry `employeeTypeId` fixtures); (6) mobile contract test; (7) qa: `qa-automation/e2e/support/api/types/quotation.ts`, `fixture-clients.ts`, `global-setup.ts`, `shared-catalogs.ts` — find with `grep -rn 'employeeType' qa-automation/e2e` and update.

### Reviewable as

- **Demo:** Web: create a quotation, add labour from the role picker. Mobile: same on the quote screen. Open a pre-migration quotation.
- **Acceptance:** REQ-10 acceptance ("the quotation resource picker lists roles; existing quotations still display the same resource names" — per Q13 = B, the mapped role's names).
- **Reviewer can verify without:** U9+.

### Risk

- **Weakest source:** `[UNVERIFIED]` — TCG-237 (jira) and the developer's Q13.
- **Migration reversible:** yes (additive; old column kept).
- **Behind a flag:** no.
- **Touches existing data:** reads the `role_id` backfilled by U4; rows whose type had no role (Q26c) have `role_id` null → the editor shows blank for those; **Q26(c) open.**
- **Blast radius:** every quotation screen on two surfaces.
- **Guardian / tracer:** guardian **required** (writes a new FK column); tracer **required** (four search passes; web, mobile and `qa-automation` are not compile-checked).

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source |
| --- | --- | --- | --- |
| Quotation PDF / email / signature rendering of resource names | `QuotationResource` name | snapshot-free test: rendered name equals the mapped role name for a migrated fixture | Q13 = B |
| Billing-code fan-out from a resource line (`use-billing-code-fanout.ts`) | `employeeTypeId` passed on | web test; billing codes themselves move in U9 — **during U8→U9 the fan-out looks up codes by the role id before billing codes carry it: the executor keeps the lookup via `billing_codes.role_id` (backfilled in U4), so the window has no break** | D10 |
| Price listings resolve (`price-listings.controller.ts`) | `employeeTypeId` | API spec | D10; moved fully in U9 |
| Mobile quote picker + quote drafts cached offline | `resource-catalog.*` | drafts saved before the upgrade carry `employeeTypeId` — named window: a draft created pre-upgrade cannot be resubmitted; mobile clears or maps on launch (executor to confirm with the developer) | `spec.md` §6 |
| Job creation from an accepted quotation (copies resources) | `JobResource.employeeTypeId` | Job resources move in U11. Until then the copy needs a type, and D10 forbids an alias, so U8 keeps writing `QuotationResource.employee_type_id` beside `role_id` (transitional double write, named in *Sequencing* window (a); the developer confirms). Test: accept a quotation created after U8 and assert the job's resources keep their positions | D10 / D11 |

### Deliberately not in this unit

- Billing codes, sub-category associations, job resources (U9–U11).

---

## U9 — Billing codes and price-listing resolve use roles

> **From the U4 re-review (2026-10-20):** this unit's save path must write the role, or the U4 backfill is erased on the next save.

> **Acceptance added from the U4 guardian review (2026-10-20):** the new role FKs are not tenant-composite — every writer in this unit must check the role belongs to the current tenant before saving.

- **Outcome:** A billing code is tied to a role; price-listing resolution takes a role.
- **Kind:** vertical
- **Requirements covered:** REQ-10 (BillingCode, price listings consumer).
- **Depends on:** U4. (U8 for the fan-out; order after U8.)
- **Branch / PR base:** `feat/TCG-237-u9-billing-code-role` stacked on U8.
- **Size estimate:** ~190 source lines, 15 source files (api 4, web 9, price-listings service 1 + dto).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | `BillingCode.roleId` read/written; `employee_type_id` retained. | |
| API | `create-billing-code.dto.ts`, `billing-codes.service.ts`, `billing-codes.repository.ts`, `price-listings.controller.ts` + service. | Tracer. |
| Web | `features/billing-codes` (`billing-code-form.tsx`, `billing-code-type-select.tsx`, `billing-code-classification-card.tsx`, `billing-code.schema.ts`, `billing-codes.service.ts`, `create-billing-code-modal.tsx`, `use-billing-code-custom-type-picker.ts`), `features/price-listings/services/price-listings.service.ts`. | |
| Mobile / Shared | N/A — executor re-greps `billing` in `apps/mobile`. | |
| Tests | below | |

**Tests the slice must carry:** (1) API: create a billing code with a role; wrong-tenant role → 4xx; (2) uniqueness: if the code is unique on `(tenant, type)` today, the same constraint on role has an API-level 409 test — executor reads `billing_codes` uniques; (3) negative — an existing billing code with an unmapped type (Q26c) loads and can be edited; (4) price-listing resolve returns the same price for the migrated fixture (regression); (5) qa `price-listing-api.ts`.

### Reviewable as

- **Demo:** Billing codes → create → pick a role; open an old code.
- **Acceptance:** REQ-10; Q13 = B.
- **Reviewer can verify without:** U10+.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** yes.
- **Behind a flag:** no.
- **Touches existing data:** reads U4's backfill.
- **Blast radius:** billing code selection on quotations/jobs.
- **Guardian / tracer:** guardian **required**; tracer **required**.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| Quotation fan-out (U8) | billing code lookup | web test with role-keyed code | D10 |
| Job/DAS billing display | `billing_codes.employee_type` select | api spec | Q13 |
| `staircase-billing.ts` seed, `catalogue-seed.service.ts` | `employeeType` | seed spec | D10 |

### Deliberately not in this unit

- Dropping `employee_type_id` — U20.

---

## U10 — Sub-category associated resources use roles

> **From the U4 re-review (2026-10-20):** this unit's save path must write the role, or the U4 backfill is erased on the next save.

> **Q37 = A:** the nested setting column is `nested_role_id` (not `associated_role_id`); U4 already merged Mechanic/Shop duplicates (Q40 = A), so the (parent, role) unique can be added.

> **Acceptance added from the U4 guardian review (2026-10-20):** the new role FKs are not tenant-composite — every writer in this unit must check the role belongs to the current tenant before saving.

- **Outcome:** A sub-category's associated labour resources, and its nested association setting, pick a role.
- **Kind:** vertical
- **Requirements covered:** REQ-10 (SubCategoryAssociatedResource, SubCategoryNestedAssociationSetting).
- **Depends on:** U4; ordered after U9.
- **Branch / PR base:** `feat/TCG-237-u10-subcategory-association-role` stacked on U9.
- **Size estimate:** ~150 source lines, 11 source files (api 5, web 4 + `associated-resources.ts`, 1 for `missing-required-components.util.ts`).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | `associated_role_id` (associated resources) and `nested_role_id` (nested settings), both added in U4, read/written. | |
| API | `asset-management/sub-categories` usecase/service/presentation DTOs (`sub-category-associated-resource.dto.ts`), `das/missing-required-components.util.ts:44` (`associatedEmployeeTypeId` comparison). | Tracer. |
| Web | `features/assets/sub-category/utils/associated-resources.ts` and the sub-category association form. | |
| Mobile/Shared | N/A | |
| Tests | below | |

**Tests:** (1) API: create association with a role; (2) missing-required-components: a job lacking the associated role is reported exactly as it was for the type (regression, the DAS check at `missing-required-components.util.ts:44`); (3) wrong-tenant role → 4xx; (4) the nested setting round-trips.

### Reviewable as

- **Demo:** Asset sub-category → Associated resources → pick a role; DAS "missing required components" banner on a job.
- **Acceptance:** REQ-10.
- **Reviewer can verify without:** U11+.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** yes.
- **Behind a flag:** no.
- **Touches existing data:** reads U4 backfill.
- **Blast radius:** DAS missing-component warnings.
- **Guardian / tracer:** guardian **required**; tracer **required**.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| DAS missing-required-components | `missing-required-components.util.ts:44` | spec (2) above | Q13 |
| Quotation sub-category defaults (`use-resource-tab-catalogs.ts`) | associated resources feed | web test | D10 |

### Deliberately not in this unit

- Job resources (U11).

---

## U11 — A job's resources name a role

> **From the U4 re-review (2026-10-20):** this unit's save path must write the role, or the U4 backfill is erased on the next save.

> **Acceptance added from the U4 guardian review (2026-10-20):** the new role FKs are not tenant-composite — every writer in this unit must check the role belongs to the current tenant before saving.

- **Outcome:** Resources on a job (created from a quotation or by hand) carry a role; the job screens and the project resource tabs show and edit it.
- **Kind:** vertical
- **Requirements covered:** REQ-10 (JobResource consumer).
- **Depends on:** U8, U9, U10.
- **Branch / PR base:** `feat/TCG-237-u11-job-resource-role` stacked on U10.
- **Size estimate:** ~330 source lines, 22 source files (api `usecase/jobs` 5, `projects` 4, `job-tickets` 5, `service/jobs` + `job-holdover` 2, `replace-job-resources.dto.ts`; web `features/projects` 3 incl. `job-resources.mapper.ts`, `jobs.service.ts`, `job.ts`; seeds). Close to the file limit: `size-exception? possible` — executor measures.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | `JobResource.roleId` read/written. | |
| API | job create-from-quotation copy, `replace-job-resources.dto.ts`, jobs/projects/job-tickets selects of `employeeType { name }`, job-holdover repository, `demo-flows`, staircase seeds. | Tracer. |
| Web | `features/projects/jobs/**` (`job-resources.mapper.ts`, `jobs.service.ts`, `types/job.ts`), `das/middle-section/jobs/utils/build-allocation-sets.ts` (**input only — DAS screens are U12**). | |
| Mobile | `features/field-ticket` reads of the slot type name — **if present**, change here; executor lists. | |
| Tests | below | |

**Tests:** (1) API: replace-job-resources with a role; (2) negative — a sub-category-only resource (no role) stays distinct: `sub-job.mapper.ts:260-264` counts resources by `employeeTypeId === null` — the same split must hold on `roleId`; (3) regression — quotation → job copy produces resources with the mapped role (the U8 window row); (4) job-ticket creation from a job with role resources.

### Reviewable as

- **Demo:** Accept a quotation, create the job, open Resources; hand-add a labour line.
- **Acceptance:** REQ-10; Q13 = B.
- **Reviewer can verify without:** U12+.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** yes.
- **Behind a flag:** no.
- **Touches existing data:** reads U4 backfill; job resources of *completed* jobs keep the mapped role name.
- **Blast radius:** DAS slot kind discrimination (`employee` vs `subCategory`) in `das-allocations.service.ts:201-204`, `das-loadout-catalog.util.ts:104`, `sub-job.mapper.ts` — all key on "has `employeeTypeId`"; they switch to `roleId` in **U12**. **Window (named):** between U11 and U12, those three readers must keep working — U11 therefore keeps `JobResource.employee_type_id` written alongside `role_id` (the only place a double write is allowed, and U12 removes it). The developer must confirm this one transitional double write; otherwise U11 and U12 merge into a unit of ~700 lines.
- **Guardian / tracer:** guardian **required**; tracer **required**.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| DAS slot kind (`das-allocations.service.ts:201-204`) | `employeeTypeId` | existing spec rerun | window above |
| `sub-job.mapper.ts:257-264` counters | `employeeTypeId` | existing spec rerun | window above |
| Job-ticket creation / holdover | job resources copy | specs | D10 |
| Payroll (`JobResourceAllocation` → craft) | allocation craft | untouched | `contexts/payroll-engine.md` |

### Deliberately not in this unit

- DAS read side and allocation logic — U12; boom — U18.

---

## U12 — DAS allocates by the slot's role

> **Q48 (2026-10-20):** in the slot rule, the slot in the set with the **lowest `craneInspectionOrder`** → FULL; `isDispatchable && runsInspections` with no order → own-inspections flow; else STANDARD. Supersedes the "boomPay = OPERATOR" fallback written under Q46a.

> **Added by Q46a (2026-10-20):** replace the name comparison in `resolveTicketStepFlow` (`packages/shared/src/constants/ticket-flow-steps.ts:153`): FULL for the slot whose role has `isDispatchable && runsInspections`; if none in the set, the Operator slot (role `boomPay = OPERATOR`); everyone else STANDARD.

> **Acceptance added from the U4 guardian review (2026-10-20):** the new role FKs are not tenant-composite — every writer in this unit must check the role belongs to the current tenant before saving.

- **Outcome:** DAS slots, loadout, allocation save and the dispatch packet read the slot's role; no DAS code compares a type or department **name**.
- **Kind:** vertical
- **Requirements covered:** REQ-10 (DAS consumers), REQ-11 (`OPERATOR_TYPE_NAME` / `OILER_TYPE_NAME` in `das-allocations.service.ts:1383-1433`; Sales exclusion at `das.repository.ts:38-66` **moves to U17**).
- **Depends on:** U7, U11.
- **Branch / PR base:** `feat/TCG-237-u12-das-role-slots` stacked on U11.
- **Size estimate:** ~380 source lines, 24 source files (api `usecase/das` 6, `das-loadout` 7, `das-allocations` 2, `service/das` 2; web `features/das` 16 incl. `employee-card.helpers.ts`). Near both limits: `size-exception? possible` — if measured over, split API (U12a) and web (U12b) **only** with a named window (the response field `employeeType` on the DAS card changes name; web would break) — so prefer the exception.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | `JobResource.employee_type_id` double write removed (U11 window closes). | |
| API | `das.repository.ts` (`employeeType {name}` selects `:295,766,925,1134`; card field `employeeType` → role), `das-allocations.service.ts` (`slotTypeName`, craft pick), `das-loadout-*`, `das-map.service.ts:56`, `sub-job.mapper.ts`, `das-dispatch-packet.service.ts`. | The DAS card's `employeeType` field becomes the role name (shape change; tracer). The Sales exclusion at `das.repository.ts:51-66` is **left as is** until U17 (it reads the employee's type, which still exists until U15). |
| Web | `features/das/**` (16): card helpers, build-allocation-sets, allocation sets UI. `employee-card.helpers.ts` colour resolver substring-matches the type name — **open item in `payroll/gaps.md` ("keeps substring-matching a name")**: do not decide it; keep matching on the role's name and record. | Test IDs: grep `qa-automation/e2e/specs/das` first. |
| Mobile/Shared | N/A | |
| Tests | below | |

**Tests:** (1) allocation save to an Operator slot picks the operator craft as before (regression of `das-allocations.service.ts:1383-1433`, now keyed on the role's `boomPay`/classification — **no `OPERATOR_TYPE_NAME` literal**); (2) negative — slots with no role (sub-category-only) behave as before; (3) dispatch packet prints the role name; (4) qa `das/das.fixtures.ts:63-109` (`employeeTypeId`, `catalogs.employeeTypes[0]`) and `1-lifecycle.spec.ts:26-59` updated.

### Reviewable as

- **Demo:** DAS board: sets and slots show roles; allocate an employee; print the dispatch packet.
- **Acceptance:** REQ-10; REQ-11 (no name literals in DAS).
- **Reviewer can verify without:** U13+.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** yes (column drop of the double write is the only DDL; reversible by re-adding).
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** dispatch — the board and its print packet.
- **Guardian / tracer:** guardian **required** (drops the double write); tracer **required**.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| DAS craft pick | slot type name | spec above | REQ-11 |
| DAS Employees tab | `das.repository.ts` | unchanged here; U17 | REQ-06 |
| Dispatch packet | `role || employeeType` | spec | Q13 |
| `qa-automation` das | fixtures | updated | `CLAUDE.md` |

### Deliberately not in this unit

- Eligibility/placement rule and the Employees tab — U17.
- The card colour resolver's matching rule — open elsewhere (`payroll/gaps.md`).

---

## U13 — Salesperson pickers follow the Q29 answer

- **Outcome:** The customer salesperson, asset sold-by, quotation salesperson and employee-list "salespeople" pickers list people by the Q29 mechanism, not by the words "Salesmen" / "Salesperson".
- **Kind:** vertical
- **Requirements covered:** REQ-11 (salesperson part).
- **Depends on:** U5; **blocked on Q29**.
- **Branch / PR base:** `feat/TCG-237-u13-salesperson-by-setting` stacked on U12.
- **Size estimate:** ~250 source lines, 14 source files (`assets.service.ts:292`, `customers.service.ts:168`, `customers.repository.ts`, `quotations.controller.ts:108,125`, `quotations.service.ts:693,1813`, `employee-list.helpers.ts:95`, `approval-routing.ts:45`, `quotation-approvals.service.ts:1292`, web `customers.service.ts` + pickers, mobile pickers; plus the Q29 mechanism: a permission module in `permissions.ts` or a role column — **structural, the developer decides in Q29**).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | Depends on Q29 (B adds a column). | `NOT SPECIFIED` until answered. |
| API / Web / Mobile / Shared | the five sites above and `SALESPERSON_*` constants users. | |
| Tests | negative per site: a person whose role is *named* "Salesperson" but lacks the mechanism is not offered; one who has the mechanism under another name is. | |

### Reviewable as

- **Demo:** the four pickers.
- **Acceptance:** Q29 (to be written).
- **Reviewer can verify without:** U14+.

### Risk

- **Weakest source:** `[UNVERIFIED]` + **no source at all until Q29**.
- **Migration reversible:** yes (additive) if B; none if A/C.
- **Behind a flag:** no.
- **Touches existing data:** U4 must have set Salesperson / Sales Coordinator roles (Q3) — the mechanism grant is a seed/migration step decided by Q29.
- **Blast radius:** who can own customers/quotes.
- **Guardian / tracer:** guardian **required if B**; tracer **required** (picker responses, profile).

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| Customers assignment | `requiredTypeName/acceptedRoleName` | spec | **OPEN — Q29** |
| Asset sold-by | `assets.service.ts:292` | spec | **OPEN — Q29** |
| Quotation salesperson | controller/service | spec | **OPEN — Q29** |
| Employee list filter | `employee-list.helpers.ts:95` | spec | **OPEN — Q29** |
| Approval routing SALESPERSON stage | `approval-routing.ts:45` | spec | **OPEN — Q29** |

### Deliberately not in this unit

- Approval pools — U5.

---

## U14 — Mobile features gated by their own permission modules; persona removed

- **Outcome:** The mobile app shows a feature when the signed-in role holds that feature's mobile permission module; there is no persona; users with no mobile module cannot sign in to the app.
- **Kind:** vertical
- **Requirements covered:** REQ-14 — fully (D7, Q23, Q31); REQ-11 (`PERSONA_BY_EMPLOYEE_TYPE`).
- **Depends on:** U6, U13; **blocked on Q23 (open, "developer reading pending Corrina") and Q31**.
- **Branch / PR base:** `feat/TCG-237-u14-mobile-permission-modules` stacked on U13.
- **Size estimate:** ~390 source lines, 25 source files (shared `permissions.ts`; api `GET /users/me` returns permissions and drops `employeeTypeName`; mobile `app-shell/*` 10, `app/(common|field|sales|dispatch)/_layout.tsx`, `session/*`, `data/contracts/identity.contract.ts`, `use-identity.ts`; web role editor permission matrix gains the module rows; schema drops `RoleAppPersona` and `app_persona`). At the limit: `size-exception? possible`.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | Drop `DepartmentRole.appPersona` and enum `RoleAppPersona`. | One-way. |
| API | seeds of the mobile permission modules per role (**Q31**); profile mapper. | Tracer. |
| Web | role editor: permission module rows; remove `departments-role-app-persona`, `departments-role-card-persona-badge`. | qa: no spec references these ids (grepped 2026-10-20). |
| Mobile | `app-shell` gates tabs/routes by module; remove `AppPersona`, `resolvePersona`, `PERSONA_BY_EMPLOYEE_TYPE`, the `(dispatch)` persona-only logic; cached sessions refetch. | Mobile has `(field)`, `(sales)`, `(dispatch)` groups; whether `(dispatch)` is a feature: **Q31(a)**. |
| Shared | `PERMISSION_MODULES` gains the mobile modules (names: Q31); `RoleAppPersona` removed from `enums/index.ts:207`. | Cross-surface: both front-ends. |
| Tests | day-one access matrix test: every role that had a persona keeps exactly its features; none gains one; users without a module get the "role not set up in the app yet" screen. | |

### Reviewable as

- **Demo:** Sign in as an Operator, a Salesperson, a Dispatcher, an accountant.
- **Acceptance:** D7; Q23 (pending client ratification).
- **Reviewer can verify without:** U15+.

### Risk

- **Weakest source:** `[UNVERIFIED]` — Q23 is open.
- **Migration reversible:** **no** (drops the column) — mitigated by Q31(b) starting levels.
- **Behind a flag:** no.
- **Touches existing data:** yes — role permissions JSON gains keys.
- **Blast radius:** who can sign in to mobile on day one.
- **Guardian / tracer:** guardian **required**; tracer **required**.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| Mobile persona shell | `resolvePersona` | day-one matrix test | **OPEN — Q23, Q31** |
| Mobile cached sessions | `GET /users/me` | refetch on upgrade | `spec.md` §6 |
| Web `auth.service.ts` profile typing | `employeeTypeName` | web typecheck | D10 |

### Deliberately not in this unit

- Anything beyond gating (offline behaviour unspecified).

---

## U15 — One main role on the employee form; department from the role

- **Outcome:** The employee create/edit form (web) asks for one thing — the main role — and the department shows from it; temps use the same list; the Employee Type and Department picks are gone.
- **Kind:** vertical
- **Requirements covered:** REQ-03 (acceptance), REQ-09, REQ-10 (Employee consumer), REQ-11 (`isFieldEmployeeTypeName`, `craftRoleTypeForEmployeeTypeName`), D1 = B, D2c = A.
- **Depends on:** U7, U12, U13, U14 (every reader of the employee's type name must already be off it: DAS card, salesperson pickers, persona, inspections, approval pools).
- **Branch / PR base:** `feat/TCG-237-u15-employee-main-role` stacked on U14.
- **Size estimate:** ~390 source lines, 25 source files (api `employee.service.ts` — field-employee craft rule `:549-564, :625-640, :1039-1050` → role-based, D2c check; `employee.repository.ts` `:28,499,564,670,694,888`; `create-employee.dto.ts`; `employee-list.helpers.ts`; `employee-assignment.util.ts`; `invitations.service.ts`; `users.service.ts`/`users.repository.ts` profile; `deletion-reference.service.ts:75`; `recipient-resolver.service.ts:189`; `das.repository.ts:51,764,923`; fcc-seeder `seed-all.ts:666-675`; web `features/employees` 19; mobile identity; shared `employee.types.ts`). `size-exception? possible`.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | Drop `Employee.departmentId` (and relation) and `Employee.employeeTypeId`. | One-way. |
| API | as above; `POST/PATCH /employees` take `roleId`/role code only; D2c: when the employee has a primary craft, `role` must equal the craft's role, else 4xx. | Department is read as `role.department` everywhere; `?department=` filter on the employee list becomes a role-join filter. Notification department resolution uses the role's department (**Q28** for the config codes). |
| Web | `department-role-section.tsx`, `create-employee-main-tab-fields.tsx`, `create-employee-form*.ts`, `create-employee-payload.ts`, `compensation-type-field.tsx:46` (`isFieldEmployeeTypeName` → role-based rule: **how "field" is decided is not specified → keep the existing behaviour by the role's dispatchable flag? That is a new rule — stop and ask (add to Q30/Q31 follow-up)**). | `employees-main-employee-type` test id removed; `employee-department-select` removed. qa: `employees.page.ts:154-210`, `lifecycle.spec.ts`, `temp-employees.spec.ts`, `types/employee.ts`. |
| Mobile | profile no longer carries `employeeType` (identity contract final shape). | |
| Shared | `employee.types.ts` `EmployeeTypeRecord`, `isFieldEmployeeTypeName`, `craftRoleTypeForEmployeeTypeName` users removed (constants file itself in U20). | |
| Tests | below | |

**Tests:** (1) exactly one main role required; (2) temp employee offered the same list (REQ-09), no "Temp" role; (3) D2c mismatch refused, **and passes when no primary craft exists**; (4) wrong-tenant role → 4xx; (5) department filter on the employee list; (6) deletion-reference: a department with roles but no direct employees still counts correctly; (7) notifications resolve dispatch recipients via the role's department.

### Reviewable as

- **Demo:** Create an employee: one Role pick; Department shows read-only.
- **Acceptance:** REQ-03 acceptance, REQ-09 acceptance.
- **Reviewer can verify without:** U16+.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** **no** (drops two columns).
- **Behind a flag:** no.
- **Touches existing data:** drops values that U4 already mirrored into `role_id`.
- **Blast radius:** employee create/edit, invitations, notifications, DAS card department.
- **Guardian / tracer:** guardian **required**; tracer **required**.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| Employee form (19 files) | `employeeTypeId` | web tests + qa | decision 2026-10-20 Q2 |
| Payroll compensation-type default by type name | `compensation-type-field.tsx` | web test | **OPEN — how "field" is decided after the type goes** |
| Notifications by department | `recipient-resolver` | spec `recipient-resolver.service.spec.ts` updated | D1 = B |
| Deletion guard (`countEmployeesByDepartmentId`) | `Employee.departmentId` | spec | D1 = B |
| FCC seeder | `seed-all.ts` | seeder run on fixture | Q3 |

### Deliberately not in this unit

- The can-also-fill list — U16.

---

## U16 — "Can also fill" list per employee

- **Outcome:** An employee record carries zero or more extra roles they may fill; HR edits it on the employee form.
- **Kind:** vertical
- **Requirements covered:** REQ-04 — fully (D2 = F1 C: separate list; audit fields; D2d = A).
- **Depends on:** U15.
- **Branch / PR base:** `feat/TCG-237-u16-can-also-fill` stacked on U15.
- **Size estimate:** ~260 source lines, 12 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | New table: employee + role + `added_by`, `added_at`, `approved_by` (+ `approved_at` if the developer wants it), UUID PK; unique `(employee, role)`; tenant-scoped, **added to the `$extends` allowlist**. | **Table name and any code prefix: the developer names them; the executor proposes and stops** (`CLAUDE.md` — new table; D2 gives shape only). |
| API | create/update employee accepts `canAlsoFillRoleIds`; refuse the main role as a duplicate (REQ-04 acceptance); `ActivityLog` entry on change (spec §11, "should", `NOT SPECIFIED` → write it, flag it). Q8 = A: whoever can edit employees edits the list. | Cap and ordering `NOT SPECIFIED` — none. |
| Web | multi-select on the employee form (reuse the role select; **a new component only after `find-component`**). | |
| Mobile/Shared | N/A. | |
| Tests | empty list valid; duplicates of the main role refused; wrong-tenant role 4xx (API-level uniqueness 409 test for the pair). | |

### Reviewable as

- **Demo:** employee form → add Oiler to an Operator's list.
- **Acceptance:** REQ-04 acceptance.
- **Reviewer can verify without:** U17.

### Risk

- **Weakest source:** `[VERIFIED]` (REQ-04) — decision note; storage shape is the developer's.
- **Migration reversible:** yes (new table).
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** employee save.
- **Guardian / tracer:** guardian **required**; tracer **required** (employee response gains the list).

### Ripple

`none — new surface only` (`grep -n 'secondary\|canAlsoFill' apps/api/prisma/schema.prisma` — no match, established in REQ-04). Payroll reads `EmployeeCraftAssignment`, not this table (D2 reasoning) — a test asserts adding a list entry changes no payroll input.

### Deliberately not in this unit

- Using the list to gate placement — U17. The Dispatcher request / approval flow — out of ticket (Q7, Q8).

---

## U17 — Only eligible people go on a ticket

- **Outcome:** A DAS allocation or job placement is refused unless the position is the person's main role or on their list; yard techs never qualify; the DAS Employees tab shows exactly the eligible people for the slot.
- **Kind:** vertical
- **Requirements covered:** REQ-05, REQ-06 (Q9 = A), D8 = C (union check) — union part blocked.
- **Depends on:** U12, U16; union part **Q30**.
- **Branch / PR base:** `feat/TCG-237-u17-placement-eligibility` stacked on U16.
- **Size estimate:** ~340 source lines, 16 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | one eligibility function (new exported service function — **developer confirms reuse-vs-new**; candidates: `employee-assignment.util.ts`, `das.repository.ts`) called from `PUT sub-jobs/:subJobId/allocations` (`das-allocations.controller.ts:57`), job resources replace, DAS loadout, and every other `JobResourceAllocation` writer (`git grep -il 'jobResourceAllocation' -- apps/api/src`: job-holdover, sub-jobs, demo and staircase seeds). DAS Employees query replaces the hard-coded Sales exclusion (`das.repository.ts:38-66`) with the rule. | New behaviour: DAS today has **no** slot-vs-employee fit check — this adds one (not a replacement). Existing allocations are untouched (Q18 = A). Work-order dispatch is out. |
| Web | DAS Employees tab/allocation pickers pass the slot position. | |
| Mobile/Shared | N/A | |
| Tests | below | |

**Tests:** (1) yard tech never placeable (REQ-05 acceptance); (2) Crane Superintendent placeable as Operator iff Operator is on their list; (3) no slot type named Crane Superintendent exists; (4) negative — Sales, Accounting, Safety, HR, Dispatch staff are not placeable (decision note reading of "only"); (5) negative — work orders unaffected; (6) existing allocation of a now-ineligible person is not removed and still loads (Q18); (7) API-level: refused placement returns a 4xx (code chosen with the developer); (8) union check test when Q30 is answered.

### Reviewable as

- **Demo:** DAS: try to allocate a Yard Tech to an Operator slot.
- **Acceptance:** REQ-05/06 acceptance.
- **Reviewer can verify without:** U18+.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-06 Q9 and Q22 are developer answers).
- **Migration reversible:** N/A.
- **Behind a flag:** recommended — `ENFORCE_TICKET_ELIGIBILITY`; the executor asks the developer (new flag = structural). Not required by the spec.
- **Touches existing data:** no.
- **Blast radius:** dispatch cannot place people — a wrong list blocks dispatching. U4's backfill gives every mapped employee a main role but **empty lists**; an Operator who today fills Oiler is refused until HR adds it. Rollout step: seed lists from craft secondaries *only if the developer says so* (Q4 superseded: not loaded) — **flag to the developer before merge.**
- **Guardian / tracer:** guardian not required; tracer **required** (Employees tab response).

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| DAS Employees tab | `das.repository.ts:38-66` | test (4) | Q9 = A |
| Every `JobResourceAllocation` writer | listed above | one test per writer | REQ-05 Edges |
| Holdover / demo seeds | direct writes | seeds updated to eligible people | REQ-05 |

### Deliberately not in this unit

- Union check until Q30. Work-order dispatch. Colour resolver.

---

## U18 — Boom pay follows the position filled on the job

> **Carried from the U2 review (2026-10-20):** Q21 makes hidden role settings *kept but ignored* — a non-Dispatchable role can still hold a stored `boomPay` / `runsInspections`. Every reader built here (and in U6) must gate on `isDispatchable`, or boom premium is paid on a role the editor shows as off. Add it to this unit's acceptance.

- **Outcome:** The boom column (operator/oiler adder) a person is paid comes from the role of the position they filled on that job, not the craft's role.
- **Kind:** vertical (pay engine)
- **Requirements covered:** REQ-10 (pay read), F2 = B, D12a (read side).
- **Depends on:** U11, U12.
- **Branch / PR base:** `feat/TCG-237-u18-boom-by-position` stacked on U17.
- **Size estimate:** ~220 source lines, 9 source files + `vault/payroll/payroll-rules-provenance.md` entry (same commit).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | `craft-rate-resolver.service.ts` (`BOOM_ROLES` `:138`, `:241`, `:341-355`), `pay-week-assembly.ts:516-543`, `payroll-ingest.ts`, `payroll-run-record.ts`: resolver takes the allocation's role `boomPay` (OPERATOR/OILER/NONE). | **Q21:** completed tickets keep the boom pay they were calculated with — no recalculation of closed weeks; a hidden stored `boomPay` on a non-dispatchable role is ignored. |
| Payroll engine | `packages/payroll-engine` — only if an input type changes; rule order untouched (`rules/PAY-045`). | |
| Vault | `payroll-rules-provenance.md`: Corrina Bustos, `meetings/transcripts/2026-08-13-payroll-process.md` 54:22–55:05 (L358–366), quote *"if they're on the job as an oiler or an operator, they can qualify for boom pay… it's not a lifetime rule… it's per job"*, same commit. | `contexts/payroll-engine.md`. |
| Tests | **same-result tests**: for aligned data (position role = craft's role) every boom adder equals today's; plus the one intentional new case — a person filling a different position is paid the position's column; closed pay weeks unchanged. | |

### Reviewable as

- **Demo:** Price a week where an Operator filled an Oiler slot.
- **Acceptance:** F2 = B; provenance entry exists.
- **Reviewer can verify without:** U19.

### Risk

- **Weakest source:** `[UNVERIFIED]` — meeting transcript, no decision note; settle via `tcg-scrum` before merge.
- **Migration reversible:** N/A.
- **Behind a flag:** recommended; the developer decides.
- **Touches existing data:** no.
- **Blast radius:** wages.
- **Guardian / tracer:** guardian not required; tracer **required** if the resolver response changes.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| Payroll runs / ADP export | boom adder lines | same-result parallel run on a fixture week | `contexts/payroll-engine.md` |
| `PayrollPremium.craftRoleType` filter | `craft_role_type` | unchanged here | **OPEN — Q27** |

### Deliberately not in this unit

- Removing `CraftCode.roleType` — U19.

---

## U19 — Remove `CraftCode.roleType`

> **Dropped 2026-10-20:** Q27 = A (Syed Haris) keeps `CraftCode.roleType` for payroll classification. Nothing in this unit is built.

- **Outcome:** Craft codes carry a role and no separate role-type.
- **Kind:** vertical
- **Requirements covered:** REQ-10 (D12a = B).
- **Depends on:** U7, U18; **blocked on Q27**.
- **Branch / PR base:** `feat/TCG-237-u19-drop-craft-role-type` stacked on U18.
- **Size estimate:** ~300 source lines, 18 source files — not final until Q27.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | Drop `craft_codes.role_type`. | One-way. Not buildable as written in D12a: **six** `RoleType` values drive pay group (`payroll-group.ts:30`), guarantee exemption (`guarantee.ts:46`), `PayrollPremium.craftRoleType` (`schema.prisma:6028`), setup warnings and DAS craft pick; `boomPay` has three. |
| API / Web / Shared | `craft-code.dto.ts`, repository, resolver, `payroll-setup-warnings.ts`, `CraftRoleType` enum users. | per Q27. |
| Tests | same-result payroll tests across all six former values. | |

### Reviewable as / Risk / Ripple

Deferred until Q27. Guardian **required**; tracer **required**; payroll provenance required for any rule change. Weakest source: none.

### Deliberately not in this unit

- Everything, until Q27: **if option A is chosen (keep `roleType`), this unit is cut.**

---

## U20 — Retire Employee Type

- **Outcome:** `EmployeeType` no longer exists anywhere: no table, no column, no endpoint, no picker, no name constant.
- **Kind:** vertical (final slice, D11 = C)
- **Requirements covered:** REQ-10 acceptance (`git grep -n employeeTypeId` empty), REQ-11.
- **Depends on:** U1–U19 (for U19: or its cut).
- **Branch / PR base:** `feat/TCG-237-u20-retire-employee-type` stacked on U19.
- **Size estimate:** ~330 source lines, 24 source files.
- **Note (U5b, 2B — Syed Haris 2026-10-20):** remove the deprecated `roleName` query param on `GET /employee` (kept for installed mobile builds; `query-employee-list.dto.ts`, `employee-list.helpers.ts` `legacyRoleNameQuoteApproval`, `employee.service.ts` `findAll`).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | Drop `employee_type_id` from `billing_codes`, `quotation_resources`, `job_resources`, `sub_category_associated_resources` (+ `associated_employee_type_id`), `sub_category_nested_association_settings`, then table `employee_types`. | One-way. |
| API | delete `usecase/employee-types`, `service/employee-types`, `presentation/employee-types` (+ `app.module.ts`), `findNameSuggestions` merge of type names, `EMPLOYEE_TYPE_NAMES` in `seed-data.ts`, activity-log resolver entries, `cron-trigger.controller.ts` reference, `catalogue-seed*`. | `GET /employee-types` removed (D10 = B). |
| Web | delete `features/employee-types`, `activity-log-format.ts` entries. | |
| Mobile | delete `employee-type.contract.ts`, `PERSONA_BY_EMPLOYEE_TYPE` if any remains, `employee-lookup` type fields. | |
| Shared | `constants/employee-types.ts`: remove the name constants; the craft-classification → type-name map (`CRAFT_ROLE_TYPE_EMPLOYEE_TYPE_NAMES`) is **replaced by a role → craft-classification link, not deleted** (payroll reads it; D11) — the shape of that link follows Q27. Remove `SALES_COORDINATOR_ROLE_NAME` etc. | |
| Tests | `git grep -n 'employeeTypeId\|EmployeeType\|employee_type' -- apps packages qa-automation` returns only migrations; payroll same-result tests; qa suites updated: `qa-automation/README.md`, `docs/testinyCases/das.md`, `e2e/support/*`. | |

### Reviewable as

- **Demo:** the grep above; every picker still works.
- **Acceptance:** REQ-10 acceptance.
- **Reviewer can verify without:** none — last.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** **no** — table and columns dropped. Mitigation: dump of `employee_types` and each `employee_type_id` before the PR merges; U4's count table.
- **Behind a flag:** no.
- **Touches existing data:** yes (drops).
- **Blast radius:** any stray reader; the compile-checked paths are `@tcg/shared` importers only — run the contract tracer's four passes.
- **Guardian / tracer:** guardian **required**; tracer **required**.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| Payroll `craftRoleTypeForEmployeeTypeName` | shared map | same-result payroll tests | D11 |
| qa-automation (14 files) | `employeeType` | updated | `CLAUDE.md` |

### Deliberately not in this unit

- ADP export department (D6 = C, deferred to `ADP-PAYDATA-EXPORT`).

---


## Batch developer decisions — 2026-10-20 evening (Syed Haris, "all ★")

Answered in one batch to build the rest without stops. Each row is the developer's choice.

| # | Unit | Decision |
| --- | --- | --- |
| 0a | all | Over budget → split along the natural line or `size-exception`, recorded per unit |
| 0b | all | Guardian on schema changes (blocking findings only); tracer only for non-additive shape changes; no per-unit lint/build (full gate once at the end) |
| 1 | U7 | Role dropdown reuses the existing roles list endpoint with a Dispatchable filter |
| 2 | U7 | Web role picker: reuse an existing role select, else a new `DepartmentRoleSelect` on the `vendor-select` shape |
| 3 | U7 | `craft_codes.role_id` stays nullable (LABORER / ADMIN crafts have no role) |
| 4 | U8 | Extend `resource-catalog` to return roles where it returned types |
| 5 | U8 | `quotation_resources.role_id` stays nullable |
| 6 | U8m | Replace `employee-type.contract.ts` with a role contract `{id, roleCode, name}` |
| 7 | U8m | Offline drafts from before the upgrade: clear only the old type field, keep the draft |
| 8 | U9 | Mirror any (tenant, type) unique on billing codes as (tenant, role) |
| 9 | U11 | Mobile field-ticket slot-type readers change in U11 |
| 10 | U12 | DAS card field `role: {id, name}` replaces `employeeType` |
| 11 | U13 | Permission key `salesperson`, label "Salesperson", granted to Salesperson and Sales Coordinator roles via seed + migration |
| 12 | U14 | Module keys `mobile-field-tickets`, `mobile-quotations` |
| 13 | U14 | Remove the unused mobile `(dispatch)` route group |
| 14 | U14 | `GET /users/me` adds the `permissions` map and drops `employeeTypeName`; build on the Q23 developer reading |
| 15a | U15 | "Field employee" = role `isDispatchable` |
| 15b | U15 | Employee create/update send `roleCode` |
| 15c | U15 | `?department=` filters through the role's department |
| 16a | U16 | Table `employee_can_also_fill_roles`, model `EmployeeCanAlsoFillRole`, UUID, no business code |
| 16b | U16 | Nullable `approvedById` / `approvedAt` |
| 16c | U16 | Request field `canAlsoFillRoleCodes: string[]`; response lists the roles |
| 16d | U16 | Web: repeated role-select rows |
| 17a | U17 | New exported `PlacementEligibilityService` used by every allocation writer |
| 17b | U17 | Refused placement → 400 with a clear message |
| 17c | U17 | Seed can-also-fill for the TCG tenant from FCC secondary types (`employee-type-assignments.json` via the Q3 map), one-off script |
| 17d | U17 | DAS Employees request passes the slot position |
| 18 | U18 | Payroll-engine input / resolver shape may change; provenance entry quotes Corrina 2026-08-13 54:22; tests skipped per standing instruction |
| 19 | U20 | Role → craft-classification link derived from `CraftCode.roleId` + `roleType`; no new field |
| — | U6 | 509 lines / 36 files vs U5b → **`size-exception`** |
| — | U6b | Q49 = B (boolean on the field ticket adds the four inspection steps) |
| — | Demo | **Demo U1–U6 on production tonight**: gate the U4–U6 stack, dry run on a production copy, then merge and deploy U4–U6 ahead of U7+ (knowingly bends 6B: saves on quotes / jobs / billing / sub-categories rewrite rows without the role until U8–U11 land; reads unchanged). Remaining units build in parallel lanes. |

## Sequencing

> **Developer decisions 2026-10-20 (Syed Haris):** U8 split into U8 (API + web) and U8m (mobile) — no size-exception. **No feature flags** on U17 or U18; they ship with their tests. Double write U8→U11: **B — no double write**; U4 through U15 (U8m included) merge together as **one release train**. Deploy window for the rename/drop migrations (U1, U2 and later): **A — accepted**, deploy at low traffic. U19 dropped (Q27 = A).

```
U1 ──┐
U2 ──┴▶ U3 ──▶ U4 ──▶ U5 ──▶ U6 ──▶ U7 ──▶ U8 ──▶ U9 ──▶ U10 ──▶ U11 ──▶ U12 ──▶ U13* ──▶ U14* ──▶ U15 ──▶ U16 ──▶ U17 ──▶ U18 ──▶ U19* ──▶ U20
(* blocked: U13 Q29 · U14 Q23, Q31 · U19 Q27 · U4 Q26, Q28 · U17 union Q30)
```

- **Parallelisable:** only **U1 ‖ U2** — U1 touches assets (`assets.*`, `features/assets`), U2 touches departments (`departments.service.ts`, `features/departments`); they share no file and no table. Everything else is a stacked chain because it shares `schema.prisma`, `GET /users/me` (U5, U6, U13, U14, U15), `packages/shared` and the `employee-types` module. `U5 ‖ U6 ‖ U7` would not collide on files but would collide on `schema.dbml` and on the profile mapper — keep them stacked.
- **Merge order constraint:** migrations land in unit order; U4's migration needs U1's and U3's merged; every unit with a schema change is checked by `tcg-prisma-guardian`.
- **Windows where two surfaces disagree (named, §7):** (a) **U8→U11:** the quote → job copy needs the type on `JobResource` until U11; U8 writes `employee_type_id` and `role_id` on `QuotationResource`, U11 writes both on `JobResource` (transitional double write, removed in U12) — developer to confirm; (b) **U6, U14, U15:** mobile sessions cached before the upgrade lack the new profile fields — mobile treats missing as "off" and refetches on launch; (c) **U3→U15:** the old employee form (type + role) is live while the readers move: an employee created after U4 and before U15 can end with a role that disagrees with their type. Merge U4–U15 as one release train (each PR stays separate); the PR descriptions say so; (d) **U8:** mobile quote drafts created before the upgrade carry the old field.
- **Shared providers:** `UsersService` / profile mapper is named in U5, U6, U13, U14, U15 — they are chained by `Depends on`; `DepartmentsService` in U2, U3, U4, U14 — chained; `EmployeeService` in U15, U16, U17 — chained; `DasRepository` in U12, U15, U17 — chained (`git grep -ln 'DasRepository' -- apps/api/src` to re-check).
- **First unit to ship:** **U1** (smallest, independent, proves the "remove a department consumer" path, the migration/guardian/tracer flow and the qa update loop). The riskiest assumption is **U4**'s mapping (Q1/Q3/Q26); it is ordered before any code that reads roles precisely so it can be validated on a copy of production before more is built on it — raise it with TCG first.
- **Drift to watch:** `notifications.config.ts` defaults `DEPT-DISP` / `SAFE` do not match the seeded codes `DEPT-DISPATCH` / `DEPT-HR` — an existing defect, outside this ticket's units, recorded as **Q28(b)**.
