# Spec — TCG-237 One role per employee: replace Employee Type with departments and roles

> Written to `.ai/aidlc/TCG-237/spec.md` by the elaborator from `intent.md` beside it.
> **Nothing has been implemented, and nothing will be by this run.** Every requirement
> carries its sources and their status. A requirement with no source is an open question and
> is marked as one.
>
> **Scope note that this ticket overrides.** `.ai/aidlc/SCRUM-EMPLOYEE-PROFILE/intent.md` §5
> kept Department / Role / Employee Type "exactly as they are … no
> `DepartmentRole.usedAsEmployeeType` cut-over". That was a scoping instruction for that
> ticket (session instruction 3, 2026-09-15), not a product ruling. TCG-237 supersedes it
> for this area. Nothing in the vault says the three-field split was wanted.

## Fill rules

Markers: `NOT SPECIFIED` (no source says), `N/A — <reason>`, `OPEN — <question>` (must also
be in §12). Tags: `[VERIFIED]` / `[UNVERIFIED]` per source; kinds `vault`, `jira`, `code`,
`decision`, `rule`. A requirement inherits the worst status of its sources.

**How sources were tagged in this spec.**

- `decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md` is
  `status: verified` — Corrina Bustos (TCG HR Manager) in writing, two Teams replies,
  2026-10-20. It is tagged `[VERIFIED]`. Note what that means: it verifies **her words**.
  Lisette Anzaldo, Melissa McNutt and Joe Schacatano are named in it as approver / editors
  and are **not on record agreeing**. The note was relayed by the developer's session;
  `tcg-scrum` did not see the thread.
- `decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md` is
  `status: reference` (a developer decision, not TCG's). Tagged `[UNVERIFIED]` here.
- `payroll/adp-api-responses/workers-departments-2026-10-20.md` is `status: reference`
  (counts from a live ADP pull). Tagged `[UNVERIFIED]`.
- The Linear ticket is `[UNVERIFIED]` by default. Where it only restates the verified
  decision, that is said and the ticket is not counted as an independent source.
- **Meeting transcripts are not cited as sources for any requirement** (`tcg-elaborator.md`
  §4). They appear only as context in §12 "Candidates" and in §13.

---

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-237` (Linear, https://linear.app/the-crane-guys/issue/TCG-237) |
| Intent | `.ai/aidlc/TCG-237/intent.md`, captured 2026-10-20 |
| Elaborated on | 2026-10-20 |
| Vault state at elaboration | Six `domain/` SOP files verified; everything else unverified except the 2026-10-20 decision note. Read by section: `admin/gaps.md` (153 KB) lines 951–1051, 1343–1460; `payroll/gaps.md` (604 KB) lines 2171–2300; `dispatch/gaps.md` (202 KB) lines 942–1010. No `INDEX.md` conflict stub covers departments / roles / employee types. |
| Open questions raised by this spec | 16, all in §12 (some cite vault entries that are already open rather than restating them) |
| Already-shipped behaviour reached | 21 consumers in §11a; 18 with no source for what happens to them (all raised in §12 or §11b) |
| Rules consulted | `CLAUDE.md` (Identity, Developers decide structure, Siblings, PR size); `.ai/claude/contexts/prisma.md` (migrations mandatory; tenant scoping is an allowlist); `.ai/claude/contexts/patterns.md` (P1, P2 sections only). **Not yet read and binding on the executor:** `api.md`, `web.md`, `mobile.md`, `payroll-engine.md`. |

Ticket re-check: the Linear issue was read 2026-10-20 (`updatedAt` 2026-10-20T00:20Z, same
as intent capture). The "What TCG agreed" list was re-diffed against the decision note's
"What this settles" section; see REQ-05 for one place where the ticket flattens the note.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | The nine departments | schema / api | `[VERIFIED]` | decision 2026-10-20 | no (ripple on the fifteen existing departments is Q14) |
| REQ-02 | The role list inside each department | schema / api / web | `[OPEN]` | none | **yes** |
| REQ-03 | One main role per employee; it decides portal access | schema / api / web / mobile | `[VERIFIED]` | decision 2026-10-20 | no |
| REQ-04 | A "can also fill" list per employee | schema / api / web | `[VERIFIED]` | decision 2026-10-20 | no (storage is D2) |
| REQ-05 | Who may go on a job ticket, in the position they fill | api / web / mobile | `[VERIFIED]` | decision 2026-10-20 | no (Local 12 check is D8) |
| REQ-06 | DAS employee list and slot fit follow REQ-05 | api / web | `[UNVERIFIED]` | dispatch/gaps.md, UAT register | **yes** until Q9 |
| REQ-07 | Job Foreman is not a role | schema / api | `[VERIFIED]` | decision 2026-10-20 | no |
| REQ-08 | Payroll Administrator sits in HR | schema | `[VERIFIED]` | decision 2026-10-20 | no (depends on REQ-02) |
| REQ-09 | A temp uses the regular role | api | `[VERIFIED]` | decision 2026-10-20 | no |
| REQ-10 | Roles replace Employee Type wherever it is picked or read | schema / api / web / mobile / shared | `[UNVERIFIED]` | TCG-237; decision 2026-10-20 | **yes** until Q13 |
| REQ-11 | Behaviour keys on role settings, not on names | api / web / mobile / shared | `[UNVERIFIED]` | TCG-237; code (current behaviour only) | **yes** until Q11 |
| REQ-12 | Migration of existing employee types to roles | schema / api | `[OPEN]` | none | **yes** |
| REQ-13 | Role-behaviour editor changes | web | `[OPEN]` | none | **yes** (for this REQ only) |
| REQ-14 | Mobile app experience per kind of user | mobile / shared / schema | `[OPEN]` | none | **yes** (for persona only) |
| REQ-15 | What each role may see and do | schema / api / web | `[OPEN]` | none | **yes** |
| REQ-16 | Per-person access beyond the role default | n/a | `[OPEN]` | none | deferred — nothing built |

Counts: **16** total — **7** verified, **3** unverified, **0** conflicted, **6** open.

## 2. Requirements

### REQ-01 — The nine departments `[VERIFIED]`

- **Statement:** The tenant's departments are Field Operations, Shop, Yard, Dispatch,
  Sales, Accounting, Safety, HR and Management.
- **Surface:** schema / api
- **Sources:**
  - `decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md` —
    `[VERIFIED]` — kind: decision — Q1: *"yes"* to the list of nine; her "yes" also accepts
    the examples (Operators, Oilers, Riggers under Field Operations; Mechanics under Shop;
    "Wes and the owners" under Management).
- **Conflict:** none. (The candidate list was built from FCC classifications, ADP job titles
  and the 16 June 2026 org chart, per `payroll/adp-api-responses/workers-departments-2026-10-20.md`
  `[UNVERIFIED]`; ADP's twelve departments are explicitly not used.)
- **Open question:** none for the list. What happens to the fifteen departments seeded today
  is Q14; whether a newly created tenant gets the nine is Q15.
- **Ripple:** `OPEN — see Q14, Q15`. Consumers of `Department` today: `Employee.departmentId`,
  `Asset.departmentId`, `DepartmentRole.departmentId` (`onDelete: Restrict`), the DAS Sales
  exclusion (`das.repository.ts:38-60`, matches department name `Sales`), `seed-data.ts`
  `SYSTEM_DEPARTMENTS` (15 rows), `utility/demo-data/data/organisation.ts`, and
  `tenant-seed.service.ts`. See §11a.
- **Acceptance:** A tenant provisioned or migrated per Q14/Q15 lists exactly these nine
  departments by name, case as written above. The test that fails: any of the nine missing,
  or a tenth department present that Q14 did not retain.
- **Notes for the executor:** Department codes (`DEPT-…`) for the nine are `NOT SPECIFIED`
  — no source names them. The existing codes `DEPT-SALES`, `DEPT-DISPATCH`, `DEPT-HR`,
  `DEPT-SHOP`, `DEPT-YARD` exist today with the same names; whether the migration keeps those
  rows is D5, not an executor's call. Rule: `contexts/prisma.md`.

### REQ-02 — The role list inside each department `[OPEN]`

- **Statement:** `OPEN — the ticket asks that each of the nine departments hold the roles a
  person can have as their main role or on their can-also-fill list; no source states the
  full list.`
- **Surface:** schema / api / web
- **Sources:** none. Searched: the 2026-10-20 decision note (gives only the Q1 examples and
  names Operator, Oiler, Rigger, 3rd Man, HDR mechanic, Crane Superintendent, Dispatcher,
  Dispatch Manager, Sales Coordinator, Payroll Administrator in passing); `admin/gaps.md`
  *Departments, roles and their capabilities* (**Still open here:** "the full role list
  inside each department beyond the examples"); `seed-data.ts` (a role list exists for the
  old fifteen departments, which TCG did not review). Nothing written enumerates the roles.
- **Conflict:** n/a
- **Open question:** Q1 (the list), Q2 ("HDR" is undefined).
- **Ripple:** `OPEN — cannot be stated until Q1 is answered.` Existing `DepartmentRole`
  rows and the sixteen seeded `EmployeeType` names (`seed-data.ts:31-48`) are the population
  the list will be reconciled with (REQ-12).
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked.

### REQ-03 — One main role per employee; it decides portal access `[VERIFIED]`

- **Statement:** Each employee has exactly one main role; that role is their job and it
  decides what they can see in the system.
- **Surface:** schema / api / web / mobile
- **Sources:**
  - `decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md` —
    `[VERIFIED]` — kind: decision — Q2: *"yes to both"* to "one main role per person … Their
    main role would also decide what they can see in the system."
  - `payroll/gaps.md` → *Field role vs portal role* — `[UNVERIFIED]` — kind: vault — records
    the consequence: "`DepartmentRole` vs `EmployeeType` … are one concept".
- **Conflict:** none
- **Open question:** none for the rule. Per-person exceptions are REQ-16 / Q6. What each
  role may see is REQ-15 / Q5.
- **Ripple:** `Employee.roleId` already exists and `PermissionsGuard` reads
  `employee.role.permissions` today (`apps/api/src/guard/permissions.guard.ts`,
  `usecase/permissions/permissions.service.ts`; shared resolver
  `packages/shared/src/constants/permissions.ts`) — so access already follows the role and
  is **unchanged** by this requirement. What changes is that the employee form stops asking
  for a second pick (REQ-10). Employees with no role today: what they see is `NOT SPECIFIED`
  (see Q3).
- **Acceptance:** On the employee create / edit form there is one job pick (the role) and
  no Employee Type pick; an employee's portal permissions equal their main role's
  permissions; changing the main role changes the permissions on next token resolution.
- **Notes for the executor:** TCG-237 restates this rule; it is not counted as a second
  source. The employee form is `apps/web/src/features/employees/components/form/sections/department-role-section.tsx`.

### REQ-04 — A "can also fill" list per employee `[VERIFIED]`

- **Statement:** Each employee can have a list of other positions they are allowed to fill,
  drawn from the same role list as the main role.
- **Surface:** schema / api / web
- **Sources:**
  - `decisions/2026-10-20-…-corrina.md` — `[VERIFIED]` — kind: decision — Q2 *"yes to both"*
    (Operator can also fill Oiler, Rigger or 3rd Man; an HDR mechanic can also fill 3rd
    Man); Q3: an HDR mechanic *"can also be called out into the field to be a 3rd man or
    rigger"*; F3–F4: the Crane Superintendent and Local 12 managers carry the field
    positions they may fill on this list.
  - `payroll/gaps.md` → *Employee types* — `[UNVERIFIED]` — kind: vault — FCC holds one
    primary plus unlimited secondary types; the seeder drops the secondary ones.
- **Conflict:** none
- **Open question:** who may edit the list (Q8); whether FCC's secondary types load into it
  (Q4). Storage shape is a developer decision (D2).
- **Ripple:** Today `Employee.employeeTypeId` is a single nullable FK (`schema.prisma:4258`)
  and `seed-all.ts` collapses `FMS_EMPLOYEE_TYPE_DETAILS` to one type. Nothing stores a
  list, so nothing existing reads one. `none — new surface only` for the list itself
  (established by: `grep -n 'secondary\|canAlsoFill' apps/api/prisma/schema.prisma` — no
  match; the nearest precedent is `EmployeeCraftAssignment`, a primary/secondary pair for
  craft codes, `schema.prisma:2861`).
- **Acceptance:** An employee record can hold zero or more additional roles; each
  additional role is a role of the same tenant; the main role cannot also appear in the list
  as a duplicate (this last clause is a consistency rule the executor must raise as D2 if
  the chosen shape allows it — not sourced).
- **Notes for the executor:** An empty can-also-fill list is valid (Corrina: *"yes sometimes"*
  — not everyone has one). Cap on list length: `NOT SPECIFIED`.

### REQ-05 — Who may go on a job ticket, in the position they fill `[VERIFIED]`

- **Statement:** A person may be placed on a job ticket only in a position that is their
  main role or is on their can-also-fill list; field crew, HDR mechanics (through their
  list), the Crane Superintendent and Local 12 managers qualify this way; yard techs never
  do.
- **Surface:** api / web / mobile
- **Sources:**
  - `decisions/2026-10-20-…-corrina.md` — `[VERIFIED]` — kind: decision — Q5: *"only crane
    superintendent would also qualify to get a job ticket. NEVER yard techs."*; F3: *"Crane
    super would be assigned in what position he was for that particular job."* ("Crane
    Superintendent" is **not** a ticket slot type); F4: Jeff Kelley and Kyle Harlow are
    managers *"also in the local 12 union so they are allowed to operate"*.
- **Conflict:** none. **Re-diff note:** the ticket says "field crew, HDRs, the Crane
  Superintendent and Local 12 managers, each in the position they fill that day". The
  decision says Local 12 managers are named for two people (Jeff Kelley, Kyle Harlow); FCC
  holds **three** `Management` + `Operator` employees and the third is unidentified (Q10).
  By her "only", Sales, Accounting, Safety, HR and Dispatch staff do not go on a ticket —
  that is the decision note's reading of her word, not a sentence she wrote.
- **Open question:** Q10 (third manager). Whether the ERP *checks* Local 12 membership or it
  only explains an entry on a manager's list is a developer decision (D8, per the decision
  note's own wording).
- **Ripple:** the ticket-eligibility rule reaches every place a person is placed on a
  ticket or allocation: see §11a rows for DAS, `das-loadout`, `jobs`, `job-tickets`,
  `JobResourceAllocation`. What happens to people **already allocated** to a slot who would
  not be eligible under the new rule (e.g. a person whose type was Shop, today on a ticket):
  `OPEN — see Q9`.
- **Acceptance:** A yard tech cannot be placed on a job ticket in any position. A
  Crane Superintendent can be placed as Operator or Rigger if and only if that position is on
  their can-also-fill list. No ticket slot type named "Crane Superintendent" exists.
- **Notes for the executor:** Work-order dispatch (yard / mechanic work orders) is **not**
  covered by this rule (decision note "What this does not settle", item 6) and is out of
  scope. Mechanism for "dispatchable": D3. The executor must not silently remove existing
  allocations (Q9).

### REQ-06 — DAS employee list and slot fit follow REQ-05 `[UNVERIFIED]`

- **Statement:** The DAS Employees tab lists exactly the people eligible under REQ-05, and
  an employee fits a slot when the slot's position is their main role or on their
  can-also-fill list.
- **Surface:** api / web
- **Sources:**
  - `dispatch/gaps.md` → *Sales Persons in the DAS Employees tab* — `[UNVERIFIED]` — kind:
    vault — reads the DAS Employees tab as the ticket-eligible set, and says Sales
    exclusion should follow from the model "not from a hard-coded filter". **Owner Lisette
    Anzaldo has not confirmed this reading.**
  - `uat/register-2026-09-18.md` UAT 1 — `[UNVERIFIED]` — kind: vault — *"In DAS, Sales
    Persons should not be displayed in the Employees tab."* A UAT row is an ask, not
    intent (`uat/INDEX.md`).
  - `apps/api/src/service/das/das.repository.ts:38-60` — kind: code (descriptive) — today
    the exclusion is a three-marker name match (department `Sales`, type `Salesmen`, role
    `Salesperson`).
- **Conflict:** none
- **Open question:** Q9
- **Ripple:** see §11a: `das.repository.ts`, `das-loadout` (7 files), `usecase/das` (6),
  `apps/web/src/features/das` (16 files), `employee-card.helpers.ts` (colour resolver
  substring-matches the type name).
- **Acceptance:** `OPEN — pending Q9.` Draft check: no employee whose only positions are
  non-dispatchable appears in the DAS Employees tab, with no department-, type- or
  role-*name* literal in the query.
- **Notes for the executor:** the DAS card colour resolver is a separate open item in
  `payroll/gaps.md` → *Field role vs portal role* ("whether the DAS card colour resolver
  keeps substring-matching a name"); do not decide it here.

### REQ-07 — Job Foreman is not a role `[VERIFIED]`

- **Statement:** "Job Foreman" is not seeded or migrated as a role; the foreman is chosen
  per job.
- **Surface:** schema / api
- **Sources:**
  - `decisions/2026-10-20-…-corrina.md` — `[VERIFIED]` — kind: decision — Q4: *"Job Foreman
    is something they are picked and assigned PER job"*; FCC's `Job Foreman` type (id 15)
    "should not become a role".
- **Conflict:** none
- **Open question:** none for this REQ. The per-job pick itself is out of scope (separate
  ticket). Who does the picking was not asked.
- **Ripple:** `utility/demo-data/data/organisation.ts:153` lists `'Job Foreman'`;
  the `FOREMAN` payroll premium is "derived — whoever the allocation names"
  (`seed-data.ts:534-551`) and is a pay rule, **unchanged** by this ticket.
- **Acceptance:** After migration no `DepartmentRole` named Job Foreman exists; no employee
  is left with a main role of Job Foreman; the `FOREMAN` premium derivation is untouched.
- **Notes for the executor:** what becomes of an employee whose only FCC type was Job
  Foreman: Q3.

### REQ-08 — Payroll Administrator sits in HR `[VERIFIED]`

- **Statement:** The Payroll Administrator role belongs to the HR department.
- **Surface:** schema
- **Sources:**
  - `decisions/2026-10-20-…-corrina.md` — `[VERIFIED]` — kind: decision — Q6: *"right now,
    Micaela's Payroll Admin is still under HR"*. "Right now" and "still" say the placement
    may change.
- **Conflict:** none
- **Open question:** none; the role's name and permissions are REQ-02 / REQ-15.
- **Ripple:** none — new placement (`grep -n 'Payroll' apps/api/src/utility/seed-data.ts`
  shows a `Payroll Manager` role under `DEPT-ACCOUNTS`; whether that row is the same role is
  part of Q1).
- **Acceptance:** The Payroll Administrator role's department is HR.
- **Notes for the executor:** blocked on REQ-02 for the role's exact name.

### REQ-09 — A temp uses the regular role `[VERIFIED]`

- **Statement:** A temporary fill-in is given the same role as a regular employee in that
  job, so they get the same pay setup and the same access.
- **Surface:** api
- **Sources:**
  - `decisions/2026-10-20-…-corrina.md` — `[VERIFIED]` — kind: decision — Q8: *"yes and
    yes"*.
- **Conflict:** none
- **Open question:** none
- **Ripple:** temps are already employees with `employeeStatus=TEMPORARY`
  (`schema.prisma:4044` comment; `create-employee.dto.ts:230`), so no temp-specific role
  exists to migrate. `none — no temp role found` (established by:
  `git grep -n -i 'temp' apps/api/prisma/schema.prisma`).
- **Acceptance:** Creating a temporary employee offers the same role list as a permanent
  one; no "Temp" role exists.
- **Notes for the executor:** pay setup follows the role only to the extent pay already
  does; **do not change pay derivation** (`CraftRoleType` is out of scope).

### REQ-10 — Roles replace Employee Type wherever it is picked or read `[UNVERIFIED]`

- **Statement:** Every place that asks for or reads an Employee Type — slot / resource
  pickers, billing codes, sub-category associated resources, job resources, DAS, mobile —
  asks for or reads a role instead.
- **Surface:** schema / api / web / mobile / shared
- **Sources:**
  - `TCG-237` — `[UNVERIFIED]` — kind: jira — "This ticket replaces Employee Type with
    roles, so there is one list."
  - `decisions/2026-10-20-…-corrina.md` — `[VERIFIED]` — kind: decision — build impact:
    "`EmployeeType` → `DepartmentRole` fold"; the main role is the job (Q2).
- **Conflict:** none
- **Open question:** Q13 (existing historical records); Q12 and Q3 interact.
- **Ripple:** the largest in this ticket. By `git grep -il -E 'employeeType|EmployeeType|employee_type'`
  (2026-10-20): `apps/api` 138 files (includes migrations, fcc-seeder and prisma scripts),
  `apps/web` 108, `apps/mobile` 69, `packages/shared` 4, `qa-automation` 14. The FKs to
  `employee_types`: `Employee`, `BillingCode`, `QuotationResource`, `JobResource`,
  `SubCategoryAssociatedResource`, `SubCategoryNestedAssociationSetting`. Per-consumer
  treatment: §11a. What each consumer should show for a record whose type has no matching
  role: `OPEN — see Q3, Q13`.
- **Acceptance:** `git grep -n 'employeeTypeId' apps/api/src apps/web/src apps/mobile
  packages/shared/src` returns no read or write outside the migration path once the
  retirement D11 is decided; the quotation resource picker lists roles; existing
  quotations still display the same resource names (Q13).
- **Notes for the executor:** the ~330-file reach cannot ship as one PR (`CLAUDE.md` → One
  unit per PR, 400 changed source lines / 25 files). `tcg-contract-tracer` is required for
  every response-shape change (`GET /users/me` flattens `employeeTypeName`;
  `GET /employee-types` feeds web and mobile pickers). Only `@tcg/shared` importers are
  compile-checked.

### REQ-11 — Behaviour keys on role settings, not on names `[UNVERIFIED]`

- **Statement:** Behaviour that today is decided by matching an employee type or role name
  is decided by a setting on the role.
- **Surface:** api / web / mobile / shared
- **Sources:**
  - `TCG-237` — `[UNVERIFIED]` — kind: jira — "the app decides things by matching names like
    'Operator' or 'Salesmen'."
  - `apps/api/prisma/schema.prisma:4545-4560` and commit `c6b0d3dcc` — kind: code
    (descriptive) — five settings already exist on `DepartmentRole` (`usedAsEmployeeType`,
    `appPersona`, `boomPay`, `runsInspections`, `quoteApproval`); they are written by the
    tenant seed and the role editor and **read by no business rule** (see §11a).
- **Conflict:** none
- **Open question:** Q11 — whether current behaviour is to be preserved exactly, and which
  new role carries which setting. The names-matching list below is a code fact, not a
  decision about what the new behaviour should be.
- **Ripple:** name-matching sites found (2026-10-20, `git grep -n -E
  'SALESPERSON_TYPE_NAME|SALESPERSON_ROLE_NAME|OILER_TYPE_NAME|OPERATOR_TYPE_NAME|SALES_COORDINATOR_ROLE_NAME|PERSONA_BY_EMPLOYEE_TYPE' -- apps packages`):
  `das.repository.ts`, `assets.service.ts:292`, `customers.service.ts:168`,
  `quotations.controller.ts:108,125`, `employee-list.helpers.ts:95`,
  `users.repository.ts` (quote approver pool by role *name*), `ticket-flow-steps.ts`
  (`visibleFlowStepKeys`: Oiler only), mobile `identity.contract.ts`
  (`PERSONA_BY_EMPLOYEE_TYPE`). What each should do after the change: `OPEN — see Q11`.
- **Acceptance:** `OPEN — pending Q11.` Draft check: none of the above sites compares a
  `name` to a string literal.
- **Notes for the executor:** the SCRUM-877 Labor & Unit rule (Operator-type set members)
  is among these; its spec is `.ai/aidlc/SCRUM-877/spec.md`.

### REQ-12 — Migration of existing employee types to roles `[OPEN]`

- **Statement:** `OPEN — existing employees carry one Employee Type each and the ticket
  implies they land on a role; no source says which role each type becomes.`
- **Surface:** schema / api
- **Sources:** none. Searched: the 2026-10-20 decision note (gives the shape; says Job
  Foreman is excluded; "No code is changed by this note"); `payroll/fcc-employee-types-and-crafts.md`
  (named by the decision note; **not read in this run**); `seed-data.ts:31-48` (16
  seeded type names: 3rd Man, Accounting Admin, Dispatch Admin, Driver, Management, Mechanic,
  Oiler, Operator, Rigger, Safety Admin, Sales Admin, Salesmen, Shop, Yard Man, Default,
  Apprentice). Nothing written maps these onto roles or departments.
- **Conflict:** n/a
- **Open question:** Q3 (mapping), Q4 (secondary types).
- **Ripple:** `OPEN — cannot be stated until Q3 is answered.` Rows reached: every
  `employees`, `quotation_resources`, `job_resources`, `billing_codes`,
  `sub_category_associated_resources` row with an `employee_type_id`.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. Migration is mandatory and committed
  (`contexts/prisma.md`).

### REQ-13 — Role-behaviour editor changes `[OPEN]`

- **Statement:** `OPEN — the developer proposes renaming "Use as an employee type", showing
  boom pay and inspections only for dispatchable roles, and hiding quote approval for
  dispatchable roles; no source specifies the label or the conditional rules.`
- **Surface:** web
- **Sources:** none. Searched: the 2026-09-04 decision (templates are starting points;
  `isSystem` a badge); `dispatch/gaps.md` and `payroll/gaps.md` (use FCC's term
  `Dispatchable on`, `[UNVERIFIED]`, but specify no UI copy); `role-behaviour.section.tsx`
  (code — shows what exists, not what should). The session proposals are not product intent.
- **Conflict:** n/a
- **Open question:** Q16
- **Ripple:** `OPEN — see Q16.` The editor is `apps/web/src/features/departments/views/role-behaviour.section.tsx`,
  `role-create.tsx`, `role-form-values.ts`, `department-role-badges.tsx`; what happens to
  stored values when a field is hidden is part of Q16.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked for this REQ only.

### REQ-14 — Mobile app experience per kind of user `[OPEN]`

- **Statement:** `OPEN — the ticket labels `mobile` and the persona is read from the
  employee type name today; no source says which app each role gets.`
- **Surface:** mobile / shared / schema
- **Sources:** none. Searched: `apps/mobile/data/contracts/identity.contract.ts` (code:
  persona = `fieldWorker | sales | dispatcher`, unmapped types → null; `appPersona` on the
  role is read by nothing mobile-side); `RoleAppPersona` (`FIELD_CREW | SALES | DISPATCH |
  OFFICE`); the 2026-06-16 field-ops mobile demo, Wes Staley 49:14, lists five kinds of
  user — meeting, retrospective, **not a source**, named in Q12 as context. Nothing in the
  vault decides.
- **Conflict:** n/a. The enum, the mobile persona type and Wes's five groups do not line
  up; that is a question, not a source conflict.
- **Open question:** Q12; structure D7.
- **Ripple:** `OPEN — mobile reads employeeType.name in session and contracts (see §11a).`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked for persona only. Do not guess personas for unmapped
  roles — the existing comment in `identity.contract.ts` says the same.

### REQ-15 — What each role may see and do `[OPEN]`

- **Statement:** `OPEN — the ticket says "Roles start from templates, and TCG adjusts
  them"; no source gives the permissions the seeded roles start with.`
- **Surface:** schema / api / web
- **Sources:** none. Searched: `admin/gaps.md` → *Departments, roles and their capabilities*
  (**"what each role may do is still unwritten"**); the 2026-09-04 decision (templates are
  starting points, nothing is locked); the Sales Coordinator manual authority table
  (named in the gap; **not read**).
- **Conflict:** n/a
- **Open question:** Q5
- **Ripple:** `OPEN — every permission check in the app reads role.permissions; what an
  existing user sees after their role changes is part of Q5.`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** *Workaround, labelled as one:* seed each new role with the
  permission template its department's existing seed used and leave tuning to the four
  named editors. This is a workaround, not a decision.

### REQ-16 — Per-person access beyond the role default `[OPEN]`

- **Statement:** `OPEN — whether one person can have access beyond their role's default is
  unanswered; Corrina asked Ryan Adams.`
- **Surface:** n/a until answered
- **Sources:** none. `admin/gaps.md` → *Per-person access beyond the role default* Part 1:
  "asked Ryan, awaiting".
- **Conflict:** n/a
- **Open question:** Q6
- **Ripple:** `OPEN — nothing may be built from either reply (decision note, "What this does not settle" item 1).`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked; out of this ticket's scope by developer instruction.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes
- **Migration required:** yes — committed under `apps/api/prisma/migrations/` (`contexts/prisma.md`)
- **Data backfill required:** yes — REQ-12; mapping is `OPEN` (Q3, Q4)
- **Existing models considered:**
  - `EmployeeType` (`schema.prisma:313`) — **global**, `name @unique`, no `tenantCompanyId`;
    FKs from `Employee`, `BillingCode`, `QuotationResource`, `JobResource`,
    `SubCategoryAssociatedResource`, `SubCategoryNestedAssociationSetting`. The thing being
    replaced. Its fate is D11.
  - `DepartmentRole` (`:4523`) — per tenant; already carries `usedAsEmployeeType`,
    `appPersona`, `boomPay`, `runsInspections`, `quoteApproval`.
  - `Department` (`:4467`) — per tenant; `Employee.departmentId` and `Asset.departmentId`.
  - `Employee` (`:4242`) — `departmentId`, `roleId`, `employeeTypeId` all single and nullable.
  - `EmployeeCraftAssignment` (`:2861`) — precedent for a primary + secondary assignment
    per employee (`assignmentType`); the closest existing shape to can-also-fill. Which
    shape fits is D2.
  - `JobResourceAllocation` (`:4044`) — where a person is placed in a slot; reads for
    eligibility.
- **Which of the above hold the can-also-fill data:** a developer decision, §11b D2. No
  schema block is written here.

No `prisma` snippet is included on purpose: every new column / table / enum member is a
§11b decision.

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| none proposed | — | — | — | — |

- **New prefix introduced:** no source names one; if D2 adds a coded entity, the prefix is
  `[OPEN]`, not an executor's choice.
- **Child relations:** FKs by UUID `id`, never by code.
- **Fields whose type/precision no source states:** can-also-fill ordering, a cap on list
  length, and any "primary" flag on the list — `NOT SPECIFIED`.
- **Tenant isolation trap:** a new tenant-data model must be in the `$extends` allowlist
  (`contexts/prisma.md`); `tcg-prisma-guardian` required.

## 4. API surface — `apps/api`

- **Pattern:** departments / roles are not a P1 or P2 reference instance; `patterns.md`
  P2 (reference-code list) is the closest shape for an admin-maintained lookup. Whether
  this follows P2 or not: D10. Nothing built from `UNDECIDED` entries.
- **Existing functions/services to reuse** (found 2026-10-20):
  - `usecase/departments/departments.service.ts` — role create / update with behaviour
    settings, `findNameSuggestions` (already merges `EmployeeType` names into role-name
    suggestions, lines ~395–440).
  - `service/departments/department-roles.repository.ts` — role queries including
    `usedAsEmployeeType`.
  - `presentation/departments/dto/role-behaviour.dto.ts` — role setting DTO.
  - `usecase/employee-types/employee-types.service.ts` + `presentation/employee-types/employee-types.controller.ts` (`GET /`) — the picker endpoint being replaced.
  - `usecase/seed/tenant-seed.service.ts` (`seedDepartments`), `utility/seed-data.ts`
    (`SYSTEM_DEPARTMENTS`, `EMPLOYEE_TYPE_NAMES`), `utility/demo-data/data/organisation.ts`.
  - `usecase/employee/employee-list.helpers.ts`, `service/employee/employee.repository.ts`.
  - `EmployeeCraftAssignment` module (`presentation/employee-craft-assignments`) for the
    primary / secondary precedent.
- **New exported functions/services proposed:** none by the elaborator. Candidate
  endpoints for the picker and the can-also-fill list are D10.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| — | `NOT SPECIFIED` — all endpoint changes are D10 | | | | REQ-04, REQ-10 |

Per endpoint: request / response shapes, guards, errors — `NOT SPECIFIED`. Route-param
identity follows the Identity Convention (code on the boundary, resolve once).

## 5. Web surface — `apps/web`

- **Routes:** no new route proposed. Existing: employee create / edit form, departments
  and role editor, DAS, quotation resource tabs, billing codes, sub-category associations.
- **Existing components to reuse:** `employee-type-select.tsx`
  (`features/employee-types`) is the picker being replaced; `department-role-section.tsx`
  and `create-employee-main-tab-fields.tsx` hold the employee-form picks; role editor
  `role-behaviour.section.tsx`, `role-create.tsx`; reuse-before-create applies across all
  nine `components/` directories (`contexts/web.md`, **not yet read**).
- **New components proposed:** none by the elaborator (a can-also-fill multi-select is the
  likely one; D2/D10 decide).
- **Copy:** `NOT SPECIFIED` — see REQ-13 / Q16. No UI string is written here.
- **`data-testid` contract:** `qa-automation` addresses employee and quotation screens by
  ID; 14 files reference employee type (`git grep -il 'employeeType' qa-automation`).
  Before renaming any ID: `grep -rn '<the-id>' qa-automation/e2e`.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** persona groups `(field)`, `(sales)`, `(dispatch)`; nothing new
  proposed.
- **Components / data:** persona resolution `data/contracts/identity.contract.ts`
  (`resolvePersona` reads `employeeType.name`); quote picker
  `data/services/resource-catalog/*`; `features/field-ticket` (10 files) and
  `features/sales` (9 files) read the type.
- **Offline / sync behavior:** `NOT SPECIFIED` — must not be inferred from web. Role data on
  device is cached via `GET /users/me`; how a cached session behaves when a role changes is
  unspecified.
- **Touch targets:** 48px (rule: `contexts/mobile.md`, not yet read).
- **Push / notifications involvement:** `N/A` — none named.

## 7. Shared package — `packages/shared`

- **Types added / changed:** `OILER_TYPE_NAME`, `OPERATOR_TYPE_NAME`,
  `SALESPERSON_TYPE_NAME`, `SALES_ADMIN_TYPE_NAME`, `isSalespersonEmployee`,
  `visibleFlowStepKeys` (`constants/employee-types.ts`, `constants/ticket-flow-steps.ts`),
  `EmployeeTypeRecord` and employee types (`types/employee.types.ts`), `RoleAppPersona`
  (`enums/index.ts:207`) — all consumed by web **and** mobile. What replaces them is
  decided by REQ-11 / Q11 / D7.
- Any export change reaches both front-ends; `@tcg/shared` is consumed as built `dist/`.

## 8. Permissions and tenancy

- **Roles permitted:** to assign a person's role — Dispatcher, approved by Dispatch Manager
  (decision F2) — **but that flow is out of this ticket** (Q8). To edit what a role can do —
  Corrina Bustos, Melissa McNutt, Joe Schacatano ("Joe" is our reading) or Lisette Anzaldo
  (F2). No approval step for role edits was stated.
- **Roles denied:** `NOT SPECIFIED`.
- **Tenant isolation:** `DepartmentRole` and `Department` are per tenant; `EmployeeType` is
  global. Moving pickers from a global table to per-tenant roles changes who sees which
  rows. Cross-tenant reads: none intended.
- Self-approval (Lisette is both assignment approver and role editor): open in
  `admin/gaps.md` Part 2(d); not this ticket's.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Employee main role | exactly one | decision 2026-10-20 Q2 | `[VERIFIED]` |
| Can-also-fill roles | zero or more; from the role list | decision 2026-10-20 Q2 | `[VERIFIED]` |
| Role name uniqueness within department | exists today (`departments.service.ts`, name suggestions "Already a role in this department") | code | `[UNVERIFIED]` — current behaviour |
| List length cap, ordering, duplicate rules | `NOT SPECIFIED` | — | — |
| Department / role name length | `NOT SPECIFIED` here (existing columns are `VarChar(255)`) | — | — |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | eligibility: yard role never eligible; position on list is eligible; Crane Superintendent eligible via list | REQ-05 |
| Unit | name-matching sites replaced: none compare to a literal | REQ-11 |
| Integration (API) | employee create / update with a main role and a list; picker returns roles; DAS employees query excludes ineligible | REQ-03/04/06/10 |
| Migration check | every employee with a type has a main role after the migration; no orphaned FKs | REQ-12 |
| E2E / manual script | quotation resource pick, billing code, DAS, mobile persona, role editor | REQ-10/13/14 |

- Requirements with no testable acceptance criterion: REQ-02, REQ-12, REQ-13, REQ-14,
  REQ-15, REQ-16 (the `[OPEN]` set) and REQ-06/REQ-11 until Q9/Q11.

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`. `idx_department_roles_tenant_used_as_emp_type` was added
  anticipating picker traffic (code comment). Picker searches are sequential scans today
  (`contexts/prisma.md`).
- **Concurrency:** none identified.
- **Audit / activity log:** a changed main role or can-also-fill list should reach
  `ActivityLog`; whether it must is `NOT SPECIFIED`.
- **Migration/rollout order:** unit ordering is the decomposer's. The elaborator notes only:
  the data migration (REQ-12) cannot precede Q3; pickers (REQ-10) cannot be switched before
  their rows exist; ~330 files and the 400-line PR budget force stacked PRs (D9).

## 11a. Ripple — already-shipped behaviour these requirements reach

Counts via `git grep -il -E 'employeeType|EmployeeType|employee_type' -- <path>` on
2026-10-20; name-matching via the `git grep` in REQ-11.

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| Employee form (`features/employees`, 19 files incl. `employee-type-select`, `department-role-section.tsx`) | `Employee.employeeTypeId` / picker | REQ-03, 10 | one job pick instead of two — changes deliberately | decision 2026-10-20 Q2; TCG-237 | `grep -il employeeType apps/web/src/features/employees` |
| Quotation resources and catalogs (`features/quotations`, 36 files; `QuotationResource.employeeTypeId`) | FK + `use-resource-tab-catalogs.ts` | REQ-10 | **OPEN — Q13** (existing quotes keep which name?) | none | `git grep -il employeeType apps/web/src/features/quotations` |
| Job resources / allocations (`JobResource`, `usecase/jobs` 5, `job-tickets` 5, `das-loadout` 7) | FK | REQ-05, 10 | **OPEN — Q9, Q13** | none | `git grep -il employeeType apps/api/src/usecase/{jobs,job-tickets,das-loadout}` |
| Billing codes (`features/billing-codes` 9 files; `BillingCode.employeeTypeId`) | FK | REQ-10 | **OPEN — Q13** | none | same pattern |
| Sub-category associated resources (+ nested setting) | two FKs | REQ-10 | **OPEN — Q13** | none | `grep -n 'EmployeeType' apps/api/prisma/schema.prisma` |
| DAS (`usecase/das` 6, `features/das` 16, `das.repository.ts:38-60`, `employee-card.helpers.ts`) | hard-coded Sales exclusion; type-name colour resolver | REQ-06 | exclusion replaced by rule (changes deliberately); **colour resolver OPEN — pending `payroll/gaps.md`** and Q9 | dispatch/gaps.md (reading) | `sed -n 38,66p apps/api/src/service/das/das.repository.ts` |
| Salesperson pickers (`assets.service.ts:292`, `customers.service.ts:168`, `quotations.controller.ts:108,125`, `employee-list.helpers.ts:95`) | `SALESPERSON_TYPE_NAME` | REQ-11 | **OPEN — Q11** | none | REQ-11 grep |
| Quote approver pools (`users.repository.ts` `findApproverPoolByRoles`, `quotation-approvals`) | role *name* match | REQ-11 | **OPEN — Q11**; quote-approval setting exists on the role, unread | none | `git grep -n 'findApproverPoolByRoles' apps/api/src` |
| Mobile persona (`identity.contract.ts`, `session/store`, `resolvePersona`) | `employeeType.name` | REQ-14 | **OPEN — Q12** | none | `git grep -il employeeType apps/mobile/session apps/mobile/data/contracts` |
| Mobile field ticket (`features/field-ticket` 10) and `visibleFlowStepKeys` | `OILER_TYPE_NAME` | REQ-11 | **OPEN — Q11** | none | `git grep -il employeeType apps/mobile/features/field-ticket` |
| Mobile sales (`features/sales` 9, `components/sales` 3) and quote picker (`resource-catalog.*`) | type contract | REQ-10 | **OPEN — Q13** | none | `git grep -il employeeType apps/mobile` |
| `GET /users/me` (`employeeTypeName`) | response field | REQ-10 | **OPEN — D10** (shape change reaches web and mobile) | none | `git grep -n employeeTypeName apps packages` |
| `GET /employee-types` (web `features/employee-types`, mobile `employee-type.contract.ts`) | endpoint | REQ-10 | **OPEN — D10/D11** | none | `ls apps/api/src/presentation/employee-types` |
| Role editor (`features/departments`, 8 files; `role-behaviour.dto.ts`) | five role settings | REQ-11, 13 | changes — **OPEN Q16** | none | `git grep -n usedAsEmployeeType apps` |
| Tenant seed and demo seed (`tenant-seed.service.ts`, `seed-data.ts`, `demo-data/*`) | `SYSTEM_DEPARTMENTS`, `EMPLOYEE_TYPE_NAMES` | REQ-01, 02, 12 | **OPEN — Q14, Q15** | none | `grep -n SYSTEM_DEPARTMENTS apps/api/src/utility/seed-data.ts` |
| FCC seeder (`apps/api/fcc-seeder`, 7 files) | collapses `FMS_EMPLOYEE_TYPE_DETAILS` to one type | REQ-04, 12 | **OPEN — Q4** | none | `git grep -il employeeType apps/api/fcc-seeder` |
| `Asset.departmentId` / `assets.repository.ts` | department FK / string | REQ-01 | **OPEN — Q14** | none | `git grep -n departmentId apps/api/src/service/asset-management` |
| `packages/shared` name constants | exported constants | REQ-10, 11 | **OPEN — Q11, D7** | none | `git grep -il employeeType packages/shared` |
| `qa-automation` specs (14 files) | UI IDs / API payloads | REQ-10 | not compile-checked; each affected spec must be found by `grep -rn` | `CLAUDE.md` → data-testid | `git grep -il employeeType qa-automation` |
| Payroll / ADP export | `CraftRoleType`, craft codes | all | **unchanged** — out of scope by developer instruction; `contexts/payroll-engine.md` | rule + session | `git grep -n 'PPEDEP\|SADMIN\|SALOFF' apps packages` (no export code reads them) |
| Existing job-ticket allocations of now-ineligible people | `JobResourceAllocation` | REQ-05 | **OPEN — Q9** | none | `grep -n 'model JobResourceAllocation' apps/api/prisma/schema.prisma` |

- **Surfaces with no existing behaviour in this area:** the can-also-fill list (REQ-04) —
  `grep -n 'secondary\|canAlsoFill' apps/api/prisma/schema.prisma` finds nothing; the
  request / approval flow for role changes — no such code (`admin/gaps.md` Note).
- **Consumers with no source for what happens to them:** the 18 rows marked OPEN above,
  covered by Q4, Q9, Q11, Q12, Q13, Q14, Q15, Q16 and, for API shapes, D10 / D11. Only the
  employee form, the payroll / ADP export (unchanged by instruction) and the pre-existing
  Sales exclusion's replacement have a stated treatment.

## 11b. Developer decisions — structure is the developer's call

*Agent writes options; a developer writes the choice.* All _Chosen_ / _Decided by_ blank.

| ID | Decision | Options (existing code found) | AI note | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Does `Employee.departmentId` stay, or does department derive from the role? | (a) keep column (`schema.prisma:4258`-area; `Department` relation at `:4321`); (b) drop it and read `role.department`; (c) keep nullable and validate it equals `role.department` | (b) removes a way for the two to disagree, which the ticket's "they overlap" complains about; cost is every `employee.department` reader (`das.repository.ts:51`, `employee.repository.ts:499,888`, `deletion-reference.service.ts:75`). (a) is smallest. | | | |
| D2 | Shape of "can also fill", and whether it carries a primary flag | (a) new join model Employee↔DepartmentRole; (b) JSON / array column on `Employee`; (c) generalise `EmployeeCraftAssignment`'s primary/secondary pattern (`:2861`); (d) join model **plus** main role stored in it as `PRIMARY` and `Employee.roleId` removed | A join table matches the one-to-many test in the template. It must go into the tenant-scope allowlist. The main role is already `Employee.roleId` (REQ-03 says exactly one) so a primary flag would duplicate it unless (d). | | | |
| D3 | Keep field name `usedAsEmployeeType` with UI label "Dispatchable", or rename the column | (a) keep column, change label only (`:4545`, migration-free); (b) rename column to `isDispatchable` via migration; (c) keep both during transition | The column name will keep describing a concept the ticket retires; (b) costs a rename across ~8 API / web files already written by `c6b0d3dcc`. Label copy is Q16, not this decision. | | | |
| D4 | How global `EmployeeType` rows map to per-tenant roles — which department each lands in — and what happens to FCC types that are not roles (Job Foreman, Default, Apprentice) | (a) mapping table in the migration file; (b) mapping done by name at migration time (existing precedent: `findNameSuggestions` already merges by lower-cased name); (c) leave unmapped employees without a role | Mapping **content** is product (Q3); this row is only *where it lives*. | | | |
| D5 | Replace the 15 seeded cost-code departments with the nine, and where cost-code use of department moves | (a) replace; (b) keep fifteen and add nine; (c) keep both and mark the old as cost codes; (d) move cost-coding to a separate field on `Asset` | `Asset.departmentId` and a string `Asset.department` both exist (`assets.repository.ts:163,338`). Product side of this is Q14. | | | |
| D6 | Store the ADP export department (PPEDEP / SADMIN / SALOFF) on the role, or derive it | (a) column on `DepartmentRole`; (b) derive from pay type / department; (c) defer to the ADP export ticket (`.ai/aidlc/ADP-PAYDATA-EXPORT/`) | `workers-departments-2026-10-20.md` "Not established here": a developer decision for the ticket removing `EmployeeType`. No export code reads these three values today. | | | |
| D7 | `RoleAppPersona` options vs the five kinds of mobile user (enum change) | (a) keep four values (`FIELD_CREW`, `SALES`, `DISPATCH`, `OFFICE`); (b) add values; (c) replace enum with a per-role app list | Product input is Q12. The mobile `AppPersona` type has only three values, and `appPersona` on the role is read by no mobile code. | | | |
| D8 | Whether Local 12 membership is checked by the ERP or only explains a manager's can-also-fill entry | (a) explanation only (no new field); (b) a membership flag on `Employee` (`unionCodeId` / `unionStatus` already exist at `:4252-4253`); (c) rule check at assignment | Decision note: treating it as explanation is "the smaller build"; developer's call. | | | |
| D9 | PR / unit structure given ~330 files and the 400-line budget | stacked PRs sliced by surface (schema → API → web → mobile) vs by feature (picker by picker) | Decomposer's job; recorded here so the sign-off box is not forgotten. | | | |
| D10 | API contract for the 138/108/69 consumers: endpoint, response field, `GET /users/me` shape | (a) keep `employeeTypeId` / `employeeTypeName` as aliases of the role during transition; (b) replace outright; (c) repoint `GET /employee-types` to return roles | (a) lets the 14 qa-automation specs and mobile cached sessions survive a step; it leaves two names for one thing. Pattern: P2 `UNDECIDED` details apply to any new list endpoint. | | | |
| D11 | Fate of the `EmployeeType` table, its six FKs and the `employee-types` module / web feature | (a) drop after data migration; (b) freeze read-only; (c) keep until D10's aliases are gone | | | | |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Decided by | Enumerated by |
| --- | --- | --- | --- | --- |
| `EmployeeCraftAssignment` (primary / secondary craft per employee) | none — closest precedent for D2 | `NOT SPECIFIED` — payroll scope, out of ticket | | `grep -n 'model EmployeeCraft' apps/api/prisma/schema.prisma` |
| Craft code "role type" (`roleType RoleType`, `schema.prisma:2793`) and `CraftRoleType` | none | no — pay derivation is out of scope by instruction; the vault leaves it open (`payroll/gaps.md`) | | `git grep -n CraftRoleType packages apps` |
| Other name-matched role checks (`Sales Coordinator`, `Sales Manager`, `Salesperson`) | none | yes — REQ-11 covers them; developer to confirm | | the REQ-11 grep |
| `Asset.department` / `departmentId` | none | follow Q14 / D5 | | `git grep -n 'departmentId' apps/api/src/service/asset-management` |
| Other reference lists on the employee form (union codes, work-comp codes, craft codes) | P2 | no — not retired by this ticket | | `ls apps/api/src/presentation \| grep employee-` |
| Mobile and web picker implementations (`employee-type-select`, `resource-catalog`) | none | yes — both must change together | | `git grep -il employeeType apps/web/src/features/employee-types apps/mobile/data` |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered. Each is
answerable in one line by the person named. This section is the ticket's gaps register.
Sweep: `grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/*/spec.md`.

### Q1 — The role list inside each department

- **Question:** For each of Field Operations, Shop, Yard, Dispatch, Sales, Accounting, Safety, HR and Management, which roles should exist? (For example, is the Crane Superintendent under Field Operations or Management; are Dispatcher and Dispatch Manager both under Dispatch; is 3rd Man a role of its own?)
- **Why it cannot be answered from what is written:** The decision note gives only the Q1 examples and says the full list "was not asked". `admin/gaps.md` → *Departments, roles and their capabilities* records it as still open.
- **Blocked:** REQ-02, REQ-08, REQ-12, REQ-15.
- **Candidates:** `vault/decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md` (26 KB, 2026-10-20); `vault/admin/gaps.md` lines 951–1051 (2026-10-20 updates); `apps/api/src/utility/seed-data.ts` `SYSTEM_DEPARTMENTS` (old fifteen, not TCG-reviewed). Existing vault entry covers it: `admin/gaps.md#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten`.
- **Owner:** Corrina Bustos with Brian Petros (named in the admin gap).
- **Workaround, if any:** none — seeding any list would be inventing it.
- **Status:** open

### Q2 — What "HDR" stands for

- **Question:** What is an "HDR" (as in "HDR mechanic")? Is it a role of its own under Shop, or a mechanic who also holds field positions?
- **Why it cannot be answered from what is written:** `git grep -i -w 'HDR' -- .ai/vault` returns nothing; the ticket and decision note use it undefined.
- **Blocked:** REQ-02, REQ-05.
- **Candidates:** none: nothing written.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none.
- **Status:** open

### Q3 — What each existing employee type becomes

- **Question:** For each of the 16 seeded types (3rd Man, Accounting Admin, Dispatch Admin, Driver, Management, Mechanic, Oiler, Operator, Rigger, Safety Admin, Sales Admin, Salesmen, Shop, Yard Man, Default, Apprentice) and FCC's Job Foreman, which role does an employee holding it get as their main role? And for an employee whose only type was Job Foreman, Default or Apprentice?
- **Why it cannot be answered from what is written:** The decision settles the shape and excludes Job Foreman; it maps nothing. No document pairs a type with a role.
- **Blocked:** REQ-12, REQ-10, REQ-07 (employees whose only type was Job Foreman).
- **Candidates:** `vault/payroll/fcc-employee-types-and-crafts.md` (named by the decision; not read this run); `payroll/gaps.md` lines 2171–2300; `seed-data.ts:31-48`.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none; mapping by lower-cased name equality (as `findNameSuggestions` does) would settle only names that already match.
- **Status:** open

### Q4 — Do FCC's secondary types load into can-also-fill?

- **Question:** FCC holds a primary plus unlimited secondary types per employee (56 of 67 active field crew hold all five field types). Should the migration load those secondary types into each employee's can-also-fill list as they are, or does TCG want the lists curated by hand?
- **Why it cannot be answered from what is written:** The client adopted the model (primary + list) but no source says the FCC data is to be loaded as the lists; Corrina's examples (Operator → Oiler, Rigger, 3rd Man; HDR mechanic → 3rd Man, Rigger) are curated.
- **Blocked:** REQ-04 backfill, REQ-12.
- **Candidates:** `payroll/adp-api-responses/workers-departments-2026-10-20.md` §4 (6 KB); `payroll/gaps.md` → *Employee types*.
- **Owner:** Corrina Bustos with Lisette Anzaldo (who dispatches).
- **Workaround, if any:** migrate main roles only; leave lists empty; labelled as a workaround.
- **Status:** open

### Q5 — What each role may see and do

- **Question:** What permissions does each new role start with, and does a person's access change on the day their role changes from their old one?
- **Why it cannot be answered from what is written:** `admin/gaps.md` says "what each role may do is still unwritten".
- **Blocked:** REQ-15, REQ-03 (acceptance on access), REQ-10 for existing users.
- **Candidates:** `vault/admin/gaps.md` (existing entry, same anchor as Q1); `decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md` (8 KB, `reference`).
- **Owner:** Corrina Bustos, Melissa McNutt, Joe Schacatano or Lisette Anzaldo (the four named editors).
- **Workaround, if any:** seed each role from its department's existing permission template; labelled workaround.
- **Status:** open

### Q6 — Per-person access beyond the role

- **Question:** Can one person get extra access on top of their role (Ryan Adams's answer, via Corrina)?
- **Why it cannot be answered from what is written:** Corrina: "I have asked Ryan about the sales coordinator. Will let you know when he responds."
- **Blocked:** REQ-16.
- **Candidates:** existing vault entry `admin/gaps.md#per-person-access-beyond-the-role-default-and-the-approval-flow-for-role-and-permission-changes` Part 1 (open).
- **Owner:** Ryan Adams, through Corrina Bustos.
- **Workaround, if any:** anyone needing different access gets a different role — the entry's own "No" branch; it needs no code.
- **Status:** open

### Q7 — Do Sales Coordinators still assign roles?

- **Question:** Besides the Dispatcher, may Sales Coordinators assign someone's role (her first reply said so; the follow-up names only the Dispatcher)?
- **Why it cannot be answered from what is written:** the two replies differ; the decision note records the tension as unresolved and a confirmation has been sent.
- **Blocked:** the role-change flow (out of this ticket); REQ-15 only through who holds "assign".
- **Candidates:** existing vault entry `admin/gaps.md` Part 2(e) (same anchor as Q6).
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none needed here; the flow is out of scope.
- **Status:** open

### Q8 — Who may set a role and the can-also-fill list until the approval flow exists

- **Question:** Until the Dispatcher-assigns / Dispatch-Manager-approves flow is built in a later ticket, may the people who can edit an employee today keep setting the main role and the can-also-fill list directly?
- **Why it cannot be answered from what is written:** the decision describes the end state; the flow is "new behaviour (Path A), not part of the fold"; nothing says what applies in between.
- **Blocked:** REQ-03, REQ-04 write permissions.
- **Candidates:** `decisions/2026-10-20-…-corrina.md` ("Build impact", last bullets); `admin/gaps.md` Part 2.
- **Owner:** Corrina Bustos (with Lisette Anzaldo as the named approver).
- **Workaround, if any:** keep the current employee-edit permission unchanged; labelled workaround.
- **Status:** open

### Q9 — Is the DAS Employees tab exactly the ticket-eligible set, and what of people already allocated?

- **Question:** Does the DAS Employees tab list exactly the people who may go on a job ticket (REQ-05), and what should happen to people already allocated to a slot who would not be eligible under the new rule?
- **Why it cannot be answered from what is written:** `dispatch/gaps.md` reads the tab as the eligible set but says its owner has not confirmed; nothing speaks to existing allocations.
- **Blocked:** REQ-06; the ripple row for `JobResourceAllocation`.
- **Candidates:** `vault/dispatch/gaps.md` lines 942–1010 (existing entry, remainder "Is the DAS Employees tab exactly the ticket-eligible set?"); `vault/uat/register-2026-09-18.md` (UAT 1).
- **Owner:** Lisette Anzaldo.
- **Workaround, if any:** leave existing allocations untouched; apply the rule to new placements only; labelled workaround.
- **Status:** open

### Q10 — The third manager who also operates

- **Question:** FCC has three `Management`-type employees who also hold `Operator`; Corrina named Jeff Kelley and Kyle Harlow. Does the third also qualify (Local 12), and who is it?
- **Why it cannot be answered from what is written:** the ADP file records counts only.
- **Blocked:** REQ-05 for that one person.
- **Candidates:** `decisions/2026-10-20-…-corrina.md` "What this does not settle" item 2; `workers-departments-2026-10-20.md` §4.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** give the two named managers `Operator` on their lists; leave the third without.
- **Status:** open

### Q11 — Is today's name-based behaviour preserved exactly, and which new role carries which setting?

- **Question:** Confirm that for existing users nothing changes: only Oilers see Pre-Trip / JSA / Post-Trip / Compliance steps; Operators and Oilers earn boom premium as they do; Salesmen are the salespeople in pickers; Sales Coordinators and Sales Managers are the quote-approval pools. If it is not exactly that, which new roles carry `runsInspections`, `boomPay` and `quoteApproval`?
- **Why it cannot be answered from what is written:** the ticket says replace name matching; no source lists today's behaviour as the requirement. Code shows what happens, not what should.
- **Blocked:** REQ-11, ripple rows for pickers, approver pools, field ticket.
- **Candidates:** `ticket-flow-steps.ts`, `employee-types.ts`, `users.repository.ts` (code, descriptive); `.ai/aidlc/SCRUM-877/spec.md` (Operator Labor & Unit rule, not re-read).
- **Owner:** product team (Syed Haris to relay to Corrina Bustos).
- **Workaround, if any:** preserve current behaviour exactly; labelled workaround.
- **Status:** open

### Q12 — Which mobile app does each kind of user get?

- **Question:** For the field employee, salesperson, crane superintendent, maintenance team and safety (and dispatch): which app experience does each role get, given the app has Field, Sales and Dispatcher and no persona for the rest?
- **Why it cannot be answered from what is written:** the 2026-06-16 recording (Wes Staley 49:14) says five kinds of user will use the app; no decision follows it. Meetings are not sources.
- **Blocked:** REQ-14.
- **Candidates:** `vault/meetings/transcripts/2026-06-16-field-ops-mobile-app-demo.md` (67 KB) line 368; `field-ops/field-ops-mobile-INDEX.md` conflict stub (3 sources, none verified — not read this run).
- **Owner:** Wes Staley (said it); product team to decide.
- **Workaround, if any:** unmapped roles keep `persona = null`, as the code comment says.
- **Status:** open

### Q13 — Do existing quotations, jobs and billing codes keep showing the same resource name?

- **Question:** After the move, should an existing quotation, job or billing code that points at an employee type still display that same name (for example "Operator")?
- **Why it cannot be answered from what is written:** nothing addresses historical records.
- **Blocked:** REQ-10 and every ripple row marked Q13.
- **Candidates:** none: nothing written.
- **Owner:** product team.
- **Workaround, if any:** keep the displayed name unchanged; labelled workaround.
- **Status:** open

### Q14 — Do the fifteen FCC cost-code departments still need to exist?

- **Question:** The fifteen seeded departments (Accounts, Admin, Customer Repair, Dispatch, Fleet, HR, Internal Damage, Mechanics, Operations and Maintenance, Rigging, Shop, Storage, Sales, Trucking, Yard) include cost-coding departments that prefix quote, job and PO numbers in FCC and are used by assets. Do they go, stay, or become a separate cost-code field?
- **Why it cannot be answered from what is written:** `admin/gaps.md` Update 2026-09-04 point (4) says "in FCC, department is cost coding, not org structure"; the decision note does not address them.
- **Blocked:** REQ-01 ripple; D5.
- **Candidates:** `payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md` and `assets/fcc-units-and-schedule-types.md` (named in the admin gap; not read this run); `seed-data.ts` `SYSTEM_DEPARTMENTS`.
- **Owner:** Corrina Bustos / Brian Petros.
- **Workaround, if any:** add the nine, retire none; labelled workaround.
- **Status:** open

### Q15 — Does every new tenant get the nine departments and roles?

- **Question:** Are the nine departments and their roles created at tenant creation, or only in TCG's tenant?
- **Why it cannot be answered from what is written:** existing open vault entry; the 2026-09-04 decision records that an admin-created tenant comes up with zero of both and that `isSystem` is true only in two tenants.
- **Blocked:** REQ-01, REQ-02 provisioning; `EmployeeType` being global means other tenants get no replacement rows otherwise.
- **Candidates:** `admin/gaps.md#what-a-newly-created-tenant-must-contain--provisioned-defaults-or-an-empty-portal` (existing, open); `tenant-seed.service.ts` (code).
- **Owner:** product team.
- **Workaround, if any:** seed TCG's tenant only.
- **Status:** open

### Q16 — Role editor label and conditional rules

- **Question:** Is "Dispatchable" the label to show instead of "Use as an employee type", and should boom pay and inspections show only for dispatchable roles and quote approval be hidden for dispatchable roles? What becomes of a stored value when its field is hidden?
- **Why it cannot be answered from what is written:** the proposals come from the developer session; no source specifies UI copy or conditional rules.
- **Blocked:** REQ-13.
- **Candidates:** `role-behaviour.section.tsx` (code); `payroll/fcc-employee-master-reference-data.md` §2 (`Dispatchable on`, `[UNVERIFIED]`, via the gap entries).
- **Owner:** product team (Syed Haris to confirm with Corrina Bustos).
- **Workaround, if any:** change nothing in the editor; the new settings still work through the existing five fields.
- **Status:** open

## 13. What this spec deliberately does not specify

- The role list per department, and HDR — Q1, Q2.
- The mapping of existing types to roles, and the loading of FCC secondary types — Q3, Q4.
- What each role may see and do; per-person access — Q5, Q6.
- The Dispatcher / Dispatch Manager request-approval flow, including self-approval and
  whether role edits need approval — **sourced** (decision F2) but out of this ticket by
  developer instruction; Q7, Q8 record the interim.
- Work orders and yard / mechanic time (Kyle Harlow and Corrina Bustos on the 2026-09-10
  recording describe work orders for yard and mechanics — context, not a source).
- Per-job Job Foreman designation, and who picks the foreman.
- Pay rules, `CraftRoleType`, craft codes, the ADP export department values (PPEDEP /
  SADMIN / SALOFF — D6), `FOREMAN` premium.
- UI copy; endpoint paths; response shapes; list-length limits.
- Brian Petros's 2026-07-09 / 2026-08-26 remarks that an employee has a primary role "and
  then what other types they can be scheduled for" are corroboration of the model and are
  not cited as sources.

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [ ] Every `[CONFLICT]` requirement has a decision note — none exist
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] Every §11b row has _Chosen_ and _Decided by_ filled by a developer
- [ ] Every §11c sibling has a developer's yes / no / follow-up
- [ ] Re-diff the Linear description against REQ-05 and the "What TCG agreed" list
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________
