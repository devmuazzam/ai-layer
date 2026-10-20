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
- **Sole-unverified-source rule** (decision `2026-10-20-sole-unverified-source-confirmed-structure-not-delegable-api-layering-linted.md` §1): a requirement whose only source is `[UNVERIFIED]` gets a lettered §12 confirmation and is `[OPEN]` until answered. Re-checked across all 16: REQ-11 (Linear ticket only; code is descriptive) -> Q17; REQ-06 (two unconfirmed vault entries restating one reading by an owner who has not confirmed) -> Q9, treated as one chain; REQ-10 has the `[VERIFIED]` decision note as a second source, so the rule does not apply to it.
- **Edges.** The current template requires an `Edges` block on every requirement. Where an edge has no source it is `OPEN — see Q<n>` and the requirement is `[OPEN]` until answered. Several `[VERIFIED]` statements are therefore `[OPEN]` **on Edges only**: their statement stays sourced; each such block says which question.
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
| Open questions raised by this spec | 21, all in §12 (some cite vault entries that are already open rather than restating them) |
| Already-shipped behaviour reached | 21 consumers in §11a; 18 with no source for what happens to them (all raised in §12 or §11b) |
| Rules consulted | `CLAUDE.md` (Identity, Developers decide structure, Siblings, PR size); `.ai/claude/contexts/prisma.md` (migrations mandatory; tenant scoping is an allowlist); `.ai/claude/contexts/patterns.md` (P1, P2 sections only). **Not yet read and binding on the executor:** `api.md`, `web.md`, `mobile.md`, `payroll-engine.md`. |

Ticket re-check: the Linear issue was re-read 2026-10-20 after the template update (`updatedAt` 2026-10-20T00:20Z, unchanged since intent capture). The "What TCG agreed" list was re-diffed against the decision note's
"What this settles" section; see REQ-05 for one place where the ticket flattens the note.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | The nine departments | schema / api | `[OPEN]` (statement `[VERIFIED]`; open on Edges) | decision 2026-10-20 | **yes** — Q14, Q15, Q19 |
| REQ-02 | The role list inside each department | schema / api / web | `[OPEN]` | none | **yes** |
| REQ-03 | One main role per employee; it decides portal access | schema / api / web / mobile | `[OPEN]` (statement `[VERIFIED]`; open on Edges) | decision 2026-10-20 | **yes** — Q8, Q19 |
| REQ-04 | A "can also fill" list per employee | schema / api / web | `[VERIFIED]` | decision 2026-10-20 | no (storage is D2; Q4 is the backfill) |
| REQ-05 | Who may go on a job ticket, in the position they fill | api / web / mobile | `[OPEN]` (statement `[VERIFIED]`; open on Edges) | decision 2026-10-20 | **yes** — Q18 (Local 12 check is D8) |
| REQ-06 | DAS employee list and slot fit follow REQ-05 | api / web | `[OPEN]` (sole-unverified; confirmation Q9) | dispatch/gaps.md, UAT register | **yes** until Q9 |
| REQ-07 | Job Foreman is not a role | schema / api | `[OPEN]` (statement `[VERIFIED]`; open on Edges) | decision 2026-10-20 | **yes** — Q19 |
| REQ-08 | Payroll Administrator sits in HR | schema | `[OPEN]` (statement `[VERIFIED]`; open on Edges) | decision 2026-10-20 | **yes** — Q1 |
| REQ-09 | A temp uses the regular role | api | `[VERIFIED]` | decision 2026-10-20 | no |
| REQ-10 | Roles replace Employee Type wherever it is picked or read | schema / api / web / mobile / shared | `[OPEN]` (sourced; open on Edges) | TCG-237; decision 2026-10-20 | **yes** — Q3, Q13, Q19 |
| REQ-11 | Behaviour keys on role settings, not on names | api / web / mobile / shared | `[OPEN]` (sole-unverified; confirmation Q17) | TCG-237; code (current behaviour only) | **yes** until Q17, Q11 |
| REQ-12 | Migration of existing employee types to roles | schema / api | `[OPEN]` | none | **yes** |
| REQ-13 | Role-behaviour editor changes | web | `[OPEN]` | none | **yes** (for this REQ only) |
| REQ-14 | Mobile app experience per kind of user | mobile / shared / schema | `[OPEN]` | none | **yes** (for persona only) |
| REQ-15 | What each role may see and do | schema / api / web | `[OPEN]` | none | **yes** |
| REQ-16 | Per-person access beyond the role default | n/a | `[OPEN]` | none | deferred — nothing built |

Counts: **16** total — **2** verified (REQ-04, REQ-09), **0** unverified, **0** conflicted, **14** open (8 of them have a sourced statement and are open on Edges or on a sole-unverified confirmation: REQ-01, 03, 05, 06, 07, 08, 10, 11).

## 2. Requirements

### REQ-01 — The nine departments `[OPEN]`

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
- **Edges:**
  - **Reached by:** tenant creation seed (`usecase/seed/tenant-seed.service.ts` `seedDepartments`); demo seed (`utility/demo-data/data/organisation.ts`); admin department create / edit (`usecase/departments/departments.service.ts`); the REQ-12 migration.
  - **Does not apply when:** a tenant other than TCG's — `OPEN — see Q15`; the fifteen seeded cost-code departments — `OPEN — see Q14`.
  - **When an input is absent:** an employee with no department is valid today (`Employee.departmentId` is nullable); what the new model requires for one with no mappable role — `OPEN — see Q19`.
  - **Trust boundary:** N/A — server-derived (seeded).
  - **Read time:** N/A — not shown on a customer-visible record by this requirement (cost-code use of department: Q14).
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
- **Edges:** `OPEN — cannot be stated until Q1 is answered.`
- **Notes for the executor:** blocked.

### REQ-03 — One main role per employee; it decides portal access `[OPEN]`

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
- **Edges:**
  - **Reached by:** `POST /employees` and `PATCH /employees/:employeeCode` (`employee.controller.ts:48,132`); FCC seed load (`fcc-seeder/src/seed-all.ts`); tenant and demo seeds; the Dispatcher request / approval flow is out of this ticket (Q8).
  - **Does not apply when:** a temporary employee follows the same rule (REQ-09); per-person exceptions are REQ-16 / Q6.
  - **When an input is absent:** create / edit needs exactly one main role (decision Q2, "one main role per person"); an existing employee with no mappable role after migration — `OPEN — see Q19`.
  - **Trust boundary:** the role id comes from the client; the server checks it belongs to the caller's tenant (`contexts/prisma.md`); who may set it — `OPEN — see Q8`.
  - **Read time:** live — access follows the role's current permissions on next token resolution (existing behaviour, `permissions.guard.ts`); N/A for customer-visible records.
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
- **Edges:**
  - **Reached by:** `POST /employees` and `PATCH /employees/:employeeCode` (`employee.controller.ts:48,132`); the FCC seed load (`seed-all.ts:666-675`) — whether it feeds the list is Q4; the Dispatcher request flow, out of this ticket (Q8).
  - **Does not apply when:** the list never makes a yard tech ticket-eligible (decision Q5, "NEVER yard techs"; REQ-05); work orders (REQ-05 scope).
  - **When an input is absent:** an empty list is valid (Corrina: "yes sometimes").
  - **Trust boundary:** role ids come from the client; the server accepts only roles of the caller's tenant (acceptance above; `contexts/prisma.md`).
  - **Read time:** N/A — not shown on a customer-visible record.
- **Notes for the executor:** An empty can-also-fill list is valid (Corrina: *"yes sometimes"*
  — not everyone has one). Cap on list length: `NOT SPECIFIED`.

### REQ-05 — Who may go on a job ticket, in the position they fill `[OPEN]`

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
- **Open question:** Q10 (third manager); Q18 (existing allocations). Whether the ERP *checks* Local 12 membership or it
  only explains an entry on a manager's list is a developer decision (D8, per the decision
  note's own wording).
- **Ripple:** the ticket-eligibility rule reaches every place a person is placed on a
  ticket or allocation: see §11a rows for DAS, `das-loadout`, `jobs`, `job-tickets`,
  `JobResourceAllocation`. What happens to people **already allocated** to a slot who would
  not be eligible under the new rule (e.g. a person whose type was Shop, today on a ticket):
  `OPEN — see Q18`.
- **Acceptance:** A yard tech cannot be placed on a job ticket in any position. A
  Crane Superintendent can be placed as Operator or Rigger if and only if that position is on
  their can-also-fill list. No ticket slot type named "Crane Superintendent" exists.
- **Edges:**
  - **Reached by:** DAS allocation save `PUT sub-jobs/:subJobId/allocations` (`das-allocations.controller.ts:57`); job resources replace (`replace-job-resources.dto.ts`); DAS loadout (`usecase/das-loadout`); the DAS Employees list (REQ-06); every other `JobResourceAllocation` writer found by `git grep -il 'jobResourceAllocation' -- apps/api/src` (job-holdover, sub-jobs, demo and staircase seeds) — none of these is yet shown to apply the rule; each is a gap for the decomposer to close, not an executor's call.
  - **Does not apply when:** work-order dispatch (decision "does not settle" item 6); Sales, Accounting, Safety, HR and Dispatch staff are not placed on a ticket (the decision note's reading of Corrina's "only").
  - **When an input is absent:** a person with no main role and an empty list is not eligible (follows from "only in a position that is their main role or on the list").
  - **Trust boundary:** the slot position is supplied by the client; eligibility is computed from the stored role and list, never from the client.
  - **Read time:** live for new placements; allocations already made — `OPEN — see Q18`.
- **Notes for the executor:** Work-order dispatch (yard / mechanic work orders) is **not**
  covered by this rule (decision note "What this does not settle", item 6) and is out of
  scope. Mechanism for "dispatchable": D3. The executor must not silently remove existing
  allocations (Q18).

### REQ-06 — DAS employee list and slot fit follow REQ-05 `[OPEN]`

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
- **Open question:** Q9 (the confirmation of this requirement)
- **Ripple:** see §11a: `das.repository.ts`, `das-loadout` (7 files), `usecase/das` (6),
  `apps/web/src/features/das` (16 files), `employee-card.helpers.ts` (colour resolver
  substring-matches the type name).
- **Acceptance:** `OPEN — pending Q9.` (Statement kept so Q9 can confirm it; it is not decided.) Draft check: no employee whose only positions are
  non-dispatchable appears in the DAS Employees tab, with no department-, type- or
  role-*name* literal in the query.
- **Edges:** `OPEN — cannot be stated until Q9 is answered.`
  - **Matrix** (the statement says "follows"): `OPEN — see Q9` for add / edit / remove of a role or list entry × the DAS Employees tab.
- **Notes for the executor:** the DAS card colour resolver is a separate open item in
  `payroll/gaps.md` → *Field role vs portal role* ("whether the DAS card colour resolver
  keeps substring-matching a name"); do not decide it here.

### REQ-07 — Job Foreman is not a role `[OPEN]`

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
- **Edges:**
  - **Reached by:** tenant seed and demo seed (`utility/demo-data/data/organisation.ts:153`); the REQ-12 migration.
  - **Does not apply when:** the `FOREMAN` premium derivation (`seed-data.ts:534-551`) is untouched.
  - **When an input is absent:** an employee whose only FCC type was Job Foreman — `OPEN — see Q19`.
  - **Trust boundary:** N/A — server-derived (seed and migration).
  - **Read time:** N/A — not a customer-visible catalogue.
- **Notes for the executor:** what becomes of an employee whose only FCC type was Job
  Foreman: Q19.

### REQ-08 — Payroll Administrator sits in HR `[OPEN]`

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
- **Edges:**
  - **Reached by:** tenant seed; the REQ-12 migration.
  - **Does not apply when:** the existing `Payroll Manager` role under `DEPT-ACCOUNTS` (`seed-data.ts`) — whether it is the same role — `OPEN — see Q1`.
  - **When an input is absent:** N/A — a role-to-department placement takes no user input.
  - **Trust boundary:** N/A — server-derived.
  - **Read time:** N/A — not customer-visible.
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
- **Edges:**
  - **Reached by:** `POST /employees` and `PATCH /employees/:employeeCode` with `employeeStatus=TEMPORARY` (`create-employee.dto.ts:230`).
  - **Does not apply when:** pay derivation (`CraftRoleType`) is untouched.
  - **When an input is absent:** a temp needs a role exactly as a permanent employee does (decision Q8, "same role as a regular employee").
  - **Trust boundary:** the role id comes from the client; the server checks tenant (`contexts/prisma.md`).
  - **Read time:** N/A — not shown on a customer-visible record.
- **Notes for the executor:** pay setup follows the role only to the extent pay already
  does; **do not change pay derivation** (`CraftRoleType` is out of scope).

### REQ-10 — Roles replace Employee Type wherever it is picked or read `[OPEN]`

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
- **Open question:** Q13 (existing historical records); Q12, Q3 and Q19 interact.
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
- **Edges:**
  - **Reached by:** writers of `employeeTypeId`: `POST/PATCH /employees`, quotation create (`create-quotation.dto.ts`), job resources (`replace-job-resources.dto.ts`), billing codes (`create-billing-code.dto.ts`), sub-category associated resources (`sub-category-associated-resource.dto.ts`), price-listing resolve (`price-listings.controller.ts`), FCC seeder, catalogue seed, mobile pickers (`git grep -l 'employeeTypeId' -- apps/api/src apps/api/fcc-seeder`).
  - **Does not apply when:** payroll / ADP export is unchanged (developer instruction; `contexts/payroll-engine.md`).
  - **When an input is absent:** a record whose type has no matching role — `OPEN — see Q3, Q19`.
  - **Trust boundary:** ids come from the client; `EmployeeType` is global and roles are per tenant, so who sees which rows changes (§8); the server checks tenant (`contexts/prisma.md`).
  - **Read time:** quotations, jobs and billing codes show a historical record — `OPEN — see Q13`.
- **Notes for the executor:** the ~330-file reach cannot ship as one PR (`CLAUDE.md` → One
  unit per PR, 400 changed source lines / 25 files). `tcg-contract-tracer` is required for
  every response-shape change (`GET /users/me` flattens `employeeTypeName`;
  `GET /employee-types` feeds web and mobile pickers). Only `@tcg/shared` importers are
  compile-checked.

### REQ-11 — Behaviour keys on role settings, not on names `[OPEN]`

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
- **Open question:** Q17 (confirm the statement — sole unverified source); Q11 — whether current behaviour is to be preserved exactly. The names-matching list below is a code fact, not a
  decision about what the new behaviour should be.
- **Ripple:** name-matching sites found (2026-10-20, `git grep -n -E
  'SALESPERSON_TYPE_NAME|SALESPERSON_ROLE_NAME|OILER_TYPE_NAME|OPERATOR_TYPE_NAME|SALES_COORDINATOR_ROLE_NAME|PERSONA_BY_EMPLOYEE_TYPE' -- apps packages`):
  `das.repository.ts`, `assets.service.ts:292`, `customers.service.ts:168`,
  `quotations.controller.ts:108,125`, `employee-list.helpers.ts:95`,
  `users.repository.ts` (quote approver pool by role *name*), `ticket-flow-steps.ts`
  (`visibleFlowStepKeys`: Oiler only), mobile `identity.contract.ts`
  (`PERSONA_BY_EMPLOYEE_TYPE`). What each should do after the change: `OPEN — see Q11`.
- **Acceptance:** `OPEN — pending Q17 and Q11.` (Statement kept so Q17 can confirm it; it is not decided.) Draft check: none of the above sites compares a
  `name` to a string literal.
- **Edges:** `OPEN — cannot be stated until Q17 and Q11 are answered.`
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
- **Open question:** Q3 (mapping), Q19 (Job Foreman / Default / Apprentice only), Q4 (secondary types).
- **Ripple:** `OPEN — cannot be stated until Q3 is answered.` Rows reached: every
  `employees`, `quotation_resources`, `job_resources`, `billing_codes`,
  `sub_category_associated_resources` row with an `employee_type_id`.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Edges:** `OPEN — cannot be stated until Q3 is answered.`
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
- **Open question:** Q16, Q21
- **Ripple:** `OPEN — see Q16.` The editor is `apps/web/src/features/departments/views/role-behaviour.section.tsx`,
  `role-create.tsx`, `role-form-values.ts`, `department-role-badges.tsx`; what happens to
  stored values when a field is hidden is part of Q16.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Edges:** `OPEN — cannot be stated until Q16 is answered.`
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
- **Edges:** `OPEN — cannot be stated until Q12 is answered.`
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
- **Open question:** Q5, Q20
- **Ripple:** `OPEN — every permission check in the app reads role.permissions; what an
  existing user sees after their role changes is part of Q5.`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Edges:** `OPEN — cannot be stated until Q5 is answered.`
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
- **Edges:** `OPEN — cannot be stated until Q6 is answered.`
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
  REQ-15, REQ-16 (the `[OPEN]` set) and REQ-06/REQ-11 until Q9/Q17/Q11.

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
| Job resources / allocations (`JobResource`, `usecase/jobs` 5, `job-tickets` 5, `das-loadout` 7) | FK | REQ-05, 10 | **OPEN — Q18, Q13** | none | `git grep -il employeeType apps/api/src/usecase/{jobs,job-tickets,das-loadout}` |
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
| Existing job-ticket allocations of now-ineligible people | `JobResourceAllocation` | REQ-05 | **OPEN — Q18** | none | `grep -n 'model JobResourceAllocation' apps/api/prisma/schema.prisma` |

- **Surfaces with no existing behaviour in this area:** the can-also-fill list (REQ-04) —
  `grep -n 'secondary\|canAlsoFill' apps/api/prisma/schema.prisma` finds nothing; the
  request / approval flow for role changes — no such code (`admin/gaps.md` Note).
- **Consumers with no source for what happens to them:** the 18 rows marked OPEN above,
  covered by Q4, Q9, Q11, Q12, Q13, Q14, Q15, Q16, Q18 and, for API shapes, D10 / D11. Only the
  employee form, the payroll / ADP export (unchanged by instruction) and the pre-existing
  Sales exclusion's replacement have a stated treatment.

## 11b. Developer decisions — structure is the developer's call

*Agent writes options; a developer writes the choice.* Options are lettered so a developer can
reply with one letter. _Chosen_ and _Decided by_ are blank on every row and the elaborator has
not chosen any option; a blank row blocks sign-off like an open §12 question. "You decide" is
not a choice: it is recorded as `AI proposal — pending developer confirmation` and still
blocks. _AI note_ gives trade-offs only.

| ID | Decision | Options (existing code found) | AI note | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Does `Employee.departmentId` stay, or does department derive from the role? | **A.** keep the column (`schema.prisma:4258`-area; `Department` relation at `:4321`). **B.** drop it and read `role.department`. **C.** keep it nullable and validate it equals `role.department`. **X.** Other — say what. | B removes a way for the two to disagree, which the ticket's "they overlap" complains about; cost is every `employee.department` reader (`das.repository.ts:51`, `employee.repository.ts:499,888`, `deletion-reference.service.ts:75`). A is smallest. | **B** | Syed Haris | 2026-10-20 |
| D2 | Shape of "can also fill", and whether it carries a primary flag | **A.** new join model Employee↔DepartmentRole. **B.** JSON / array column on `Employee`. **C.** generalise `EmployeeCraftAssignment`'s primary/secondary pattern (`:2861`). **D.** join model plus the main role stored in it as `PRIMARY`, with `Employee.roleId` removed. **X.** Other — say what. | A join table matches the one-to-many test in the template and must go into the tenant-scope allowlist. The main role is already `Employee.roleId` (REQ-03 says exactly one), so a primary flag would duplicate it unless D. **Added option E (2026-10-20):** separate table + a check that the person holds a craft code of the matching classification. Developer first chose C, then E after the AI trade-off against C: payroll reads every `EmployeeCraftAssignment` row as payable, crafts have no Rigger/Driver classification, owners differ (payroll vs Dispatcher). **Sub-choice pending:** whether the new row also stores a craft code. | **E**, sub-choice **B**: the row holds employee + role + audit fields (added by / when, approved by — Dispatch Manager approval per the 2026-10-20 decision note); **no craft code stored** — the craft check reads `EmployeeCraftAssignment` live when a role is added or the person is put in a slot | Syed Haris | 2026-10-20 |
| D3 | Keep column name `usedAsEmployeeType` with a new UI label, or rename it | **A.** keep the column, change the label only (`:4545`, migration-free). **B.** rename the column to `isDispatchable` via migration. **C.** keep both during transition. **X.** Other — say what. | The column name will keep describing a concept the ticket retires; B costs a rename across ~8 API / web files written by `c6b0d3dcc`. Label copy is Q16, not this decision. | **B** | Syed Haris | 2026-10-20 |
| D4 | Where the type → role mapping lives, and what happens to FCC types that are not roles | **A.** mapping table in the migration file. **B.** mapping by name at migration time (precedent: `findNameSuggestions` merges by lower-cased name). **C.** leave unmapped employees without a role. **X.** Other — say what. | Mapping **content** is product (Q3, Q19); this row is only *where it lives*. | **A** | Syed Haris | 2026-10-20 |
| D5 | Replace the 15 seeded cost-code departments with the nine, and where cost-code use moves | **A.** replace. **B.** keep fifteen and add nine. **C.** keep both and mark the old as cost codes. **D.** move cost-coding to a separate field on `Asset`. **X.** Other — say what. | `Asset.departmentId` and a string `Asset.department` both exist (`assets.repository.ts:163,338`). Product side is Q14. **After discussion (2026-10-20):** git history shows the asset's department was copied from FCC's unit record — a free-text `department` predates April 2026, and `487790d2c` (2026-04-07, "feat: asset managment") added the `Department` FK beside it; no meeting, ticket or vault requirement asks for it. FCC's code does three jobs the ERP already covers: equipment kind → asset categories (sub-category required on non-draft assets); accounting bucket → accounting module (`ExpenseGlAccount`); responsibility → `EmployeeAsset` "managed by" + yard. | **A** for departments (the nine replace the fifteen) **and** remove department from assets entirely — both `Asset.departmentId` and the text `Asset.department` go; no cost-centre field. Department-addressed notifications (`DEPT-DISP`, `SAFE` in `notifications.config.ts`) move to the new departments. | Syed Haris | 2026-10-20 |
| D6 | ADP export department (PPEDEP / SADMIN / SALOFF): store on the role, or derive | **A.** column on `DepartmentRole`. **B.** derive from pay type / department. **C.** defer to the ADP export ticket (`.ai/aidlc/ADP-PAYDATA-EXPORT/`). **X.** Other — say what. | `workers-departments-2026-10-20.md` "Not established here": a developer decision for the ticket removing `EmployeeType`. No export code reads these values today. | **C** | Syed Haris | 2026-10-20 |
| D7 | `RoleAppPersona` options vs the five kinds of mobile user (enum change) | **A.** keep four values (`FIELD_CREW`, `SALES`, `DISPATCH`, `OFFICE`). **B.** add values. **C.** replace the enum with a per-role app list. **X.** Other — say what. | Product input is Q12. Mobile `AppPersona` has only three values and `appPersona` on the role is read by no mobile code. **After choice:** developer states only two mobile apps are in use — the field-worker app and the quotation (sales) app; mobile still has a `(dispatch)` route group and a `dispatcher` persona. | **Gate mobile features by the existing role permissions** (changed from A, then B, 2026-10-20; developer: it is one mobile app whose features are modules — "it's the crud"). Mobile shows a feature when the role's permission for that module is at least view (quotations → `quotations`); field tickets get their own permission module; a new mobile feature = a new permission module; mobile sign-in allowed when the role has at least one mobile feature. `RoleAppPersona` is removed. | Syed Haris | 2026-10-20 |
| D8 | Local 12 membership: checked by the ERP, or only explains a manager's can-also-fill entry | **A.** explanation only (no new field). **B.** a membership flag on `Employee` (`unionCodeId` / `unionStatus` exist at `:4252-4253`). **C.** rule check at assignment. **X.** Other — say what. | Decision note: treating it as explanation is "the smaller build"; developer's call. **After choice:** C enforces a product rule nobody has stated in general form ("only Local 12 members may fill an operating position") — Corrina gave union membership as the reason for two managers, not as a rule for everyone; needs a §12 confirmation before build. | **C** | Syed Haris | 2026-10-20 |
| D9 | PR / unit structure given ~330 files and the 400-line budget | **A.** stacked PRs sliced by surface (schema → API → web → mobile). **B.** stacked PRs sliced by feature (picker by picker). **X.** Other — say what. | Decomposer's job; recorded so the sign-off box is not forgotten. | **B** | Syed Haris | 2026-10-20 |
| D10 | API contract for the 138/108/69 consumers: endpoint, response field, `GET /users/me` shape | **A.** keep `employeeTypeId` / `employeeTypeName` as aliases of the role during transition. **B.** replace outright. **C.** repoint `GET /employee-types` to return roles. **X.** Other — say what. | A lets the 14 qa-automation specs and mobile cached sessions survive a step; it leaves two names for one thing. Pattern: P2 `UNDECIDED` details apply to any new list endpoint. | **B** — "it's a cleanup task as well" | Syed Haris | 2026-10-20 |
| D11 | Fate of the `EmployeeType` table, its six FKs and the `employee-types` module / web feature | **A.** drop after data migration. **B.** freeze read-only. **C.** keep until D10's aliases are gone. **X.** Other — say what. | With D10 = B there are no aliases, so C reads as: keep the table until the last slice has moved every consumer, then drop it. **Pending:** which "enum" the developer means — the closest match is `packages/shared/src/constants/employee-types.ts` (name constants incl. `CRAFT_ROLE_TYPE_EMPLOYEE_TYPE_NAMES`, which payroll's `craftRoleTypeForEmployeeTypeName` reads). | **C**, plus remove both name maps: the shared name constants in `packages/shared/src/constants/employee-types.ts` (the craft-classification → type-name map must be *replaced* by a role → craft-classification link, not deleted — payroll reads it) and mobile `PERSONA_BY_EMPLOYEE_TYPE` | Syed Haris | 2026-10-20 |
| D12 | How a role relates to craft codes (needed by D2's craft check and by D11's removal of the craft-classification → type-name map) | **A.** one craft classification per role (new optional field on the role). **B.** several classifications per role (link table). **C.** reuse `boomPay`. **D.** *(developer, 2026-10-20)* each **craft code** points at one **role**; a role can have many craft codes. **X.** Other — say what. | With D, "can this person fill role R" can be read from their craft assignments (crafts whose role is R), which overlaps D2's separate list — see the D2/D12 follow-up. `CraftCode.roleType` (`RoleType` enum, read by payroll for the boom modifier) still exists; whether it stays beside the new role link is pending. | **D** — wherever an Employee Type dropdown was used (employee create, craft code form, everywhere) it becomes a Role dropdown; each craft code gets one role, one role can be on many craft codes. **Pending:** fate of `CraftCode.roleType`. | Syed Haris | 2026-10-20 |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Decided by | Enumerated by |
| --- | --- | --- | --- | --- |
| `EmployeeCraftAssignment` (primary / secondary craft per employee) | none — closest precedent for D2 | **No change** — only read by D2's craft check | Syed Haris, 2026-10-20 | `grep -n 'model EmployeeCraft' apps/api/prisma/schema.prisma` |
| Craft code "role type" (`roleType RoleType`, `schema.prisma:2793`) and `CraftRoleType` | none | no — pay derivation is out of scope by instruction; the vault leaves it open (`payroll/gaps.md`) | | `git grep -n CraftRoleType packages apps` |
| Other name-matched role checks (`Sales Coordinator`, `Sales Manager`, `Salesperson`) | none | **Yes** — replaced by role settings in this ticket (REQ-11) | Syed Haris, 2026-10-20 | the REQ-11 grep |
| `Asset.department` / `departmentId` | none | follow Q14 / D5 | | `git grep -n 'departmentId' apps/api/src/service/asset-management` |
| Other reference lists on the employee form (union codes, work-comp codes, craft codes) | P2 | **No change** — not retired by this ticket | Syed Haris, 2026-10-20 | `ls apps/api/src/presentation \| grep employee-` |
| Mobile and web picker implementations (`employee-type-select`, `resource-catalog`) | none | **Yes** — web and mobile pickers change together in the same slice | Syed Haris, 2026-10-20 | `git grep -il employeeType apps/web/src/features/employee-types apps/mobile/data` |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered. Each is
answerable in one line by the person named, and each carries lettered options so the reply
can be a letter (`B`, `A, C`, `X: <text>`). Options are taken from the sources, listed in no
order of preference; **none is recommended or default** — choosing is the owner's call. An
answer alone does not resolve a question: `tcg-scrum` writes the decision note and flips
Status. This section is the ticket's gaps register.
Sweep: `grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/[A-Z]*/spec.md`.

Q17 is the **sole-unverified-source confirmation** required by
`vault/decisions/2026-10-20-sole-unverified-source-confirmed-structure-not-delegable-api-layering-linted.md` §1.
Q9 plays the same role for REQ-06.

### Q1 — The role list inside each department

- **Question:** For each of Field Operations, Shop, Yard, Dispatch, Sales, Accounting, Safety, HR and Management, which roles should exist? (For example: is the Crane Superintendent under Field Operations or Management; are Dispatcher and Dispatch Manager both under Dispatch; is 3rd Man a role of its own?)
- **Options:** free answer — a list of role names under each of the nine departments.
- **Answer:**
- **Why it cannot be answered from what is written:** The decision note gives only the Q1 examples and says the full list "was not asked". `admin/gaps.md` → *Departments, roles and their capabilities* records it as still open.
- **Blocked:** REQ-02, REQ-08, REQ-12, REQ-15.
- **Candidates:** `vault/decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md` (26 KB, 2026-10-20); `vault/admin/gaps.md` lines 951–1051 (2026-10-20 updates); `apps/api/src/utility/seed-data.ts` `SYSTEM_DEPARTMENTS` (old fifteen, not TCG-reviewed). Existing vault entry covers it: `admin/gaps.md#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten`.
- **Owner:** Corrina Bustos with Brian Petros (named in the admin gap).
- **Workaround, if any:** none — seeding any list would be inventing it.
- **Status:** open

### Q2 — What "HDR" means, and whether it is a role

- **Question:** Is "HDR" TCG's name for a Local 12 mechanic, and if so is there one Shop role for them, and what is it called?
- **Options:**
  - A. "HDR" is another name for a Local 12 mechanic; one Shop role, named "Mechanic".
  - B. "HDR" is another name for a Local 12 mechanic; one Shop role, named "HDR".
  - C. "HDR" and "Mechanic" are two different roles.
  - X. Other — say what (including what "HDR" stands for, which no file writes out).
- **Answer:**
- **Why it cannot be answered from what is written:** The expansion of the acronym is written nowhere in the vault. The 2026-09-10 payroll call is the only place that defines the word, and meeting material is retrospective and is not a source for a requirement (`tcg-elaborator.md` §4), so it cannot close this. What it says, as context: Corrina Bustos 43:33 — *"So Local 12 mechanics, or HDRs is what they call them, they follow the same payroll logic as the Local 12 rules"*; 50:23–50:48 — *"Mechanics are always Local 12 … We don't have non-union mechanic … it's only Local 12 Mechanic and then Yard Tech"*; Corrina 49:07 / Kyle Harlow 49:39 — an HDR "in the shop" may go third man on a job. The curated notes (`meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md`, ~lines 153–157) say "mechanics/HDRs (Local 12 …)". Craft codes `HDR-%` are L12 in `payroll/gaps.md` lines 2648, 4091. All point the same way (HDR = Local 12 mechanic), but a role list needs the owner's word, and the decision note uses "HDR mechanic" as if it were a qualifier on Mechanic. *Correction:* the earlier draft of this spec said a grep for HDR in the vault returned nothing; that was wrong.
- **Blocked:** REQ-02, REQ-05.
- **Candidates:** `vault/meetings/transcripts/2026-09-10-payroll-rate-buckets-work-orders-paper-tickets.md` (60 KB) lines 1188, 1309–1322 (not a source); `vault/meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md` (16 KB, 2026-09-10, unverified); `vault/payroll/gaps.md` lines 2648, 4091; `vault/decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md`.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none.
- **Status:** open

### Q3 — What each existing employee type becomes

- **Question:** For each of the 16 seeded types (3rd Man, Accounting Admin, Dispatch Admin, Driver, Management, Mechanic, Oiler, Operator, Rigger, Safety Admin, Sales Admin, Salesmen, Shop, Yard Man, Default, Apprentice), which role does an employee holding it get as their main role?
- **Options:** free answer — a table of type → role (and department).
- **Answer:**
- **Why it cannot be answered from what is written:** The decision settles the shape and maps nothing. No document pairs a type with a role. (Employees whose only type is Job Foreman, Default or Apprentice are Q19.)
- **Blocked:** REQ-12, REQ-10.
- **Candidates:** `vault/payroll/fcc-employee-types-and-crafts.md` (5.5 KB; read §2 this run, §1 not); `payroll/gaps.md` lines 2171–2300; `seed-data.ts:31-48`.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none; mapping by lower-cased name equality (as `findNameSuggestions` does) would settle only names that already match.
- **Status:** open

### Q4 — Do FCC's secondary types load into can-also-fill as they are?

- **Question:** Should the migration load each employee's FCC secondary types into their can-also-fill list as they are?
- **Options:**
  - A. Yes — load every FCC secondary type into the list as it is.
  - B. No — migrate main roles only; TCG fills the lists by hand afterwards.
  - C. Load them as a draft that TCG reviews per employee before it takes effect.
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** Evidence, not a decision: in the 2026-10-20 ADP/FCC extract, 56 of 67 active field crew hold all five field types (Operator, 3rd Man, Oiler, Driver, Rigger) and only the primary distinguishes them (`payroll/adp-api-responses/workers-departments-2026-10-20.md` §4); FCC's secondary types "mean can fill any field slot" there, and `payroll/fcc-employee-types-and-crafts.md` §2 says the seeder extracts all 781 assignment rows and drops the secondaries. Corrina's examples in the decision note are narrower (Operator → Oiler, Rigger, 3rd Man; HDR mechanic → 3rd Man, Rigger). Loading as-is therefore gives most field crew five positions. No source says whether TCG wants that.
- **Blocked:** REQ-04 backfill, REQ-12.
- **Candidates:** `vault/payroll/adp-api-responses/workers-departments-2026-10-20.md` (6 KB, 2026-10-20); `vault/payroll/fcc-employee-types-and-crafts.md` (5.5 KB, 2026-09-04); `payroll/gaps.md` → *Employee types*.
- **Owner:** Corrina Bustos with Lisette Anzaldo (who dispatches).
- **Workaround, if any:** option B is the smallest build (main roles only, lists empty); labelled as a workaround, not a recommendation.
- **Status:** open

### Q5 — What each role may see and do

- **Question:** What permissions does each new role start with?
- **Options:** free answer — a permission set per role (or "same as that department's existing template" per role).
- **Answer:**
- **Why it cannot be answered from what is written:** `admin/gaps.md` says "what each role may do is still unwritten". (What happens to an existing user's access at migration is Q20.)
- **Blocked:** REQ-15.
- **Candidates:** `vault/admin/gaps.md` (existing entry, same anchor as Q1); `decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md` (8 KB, `reference`).
- **Owner:** Corrina Bustos, Melissa McNutt, Joe Schacatano or Lisette Anzaldo (the four named editors).
- **Workaround, if any:** seed each role from its department's existing permission template; labelled workaround.
- **Status:** open

### Q6 — Per-person access beyond the role

- **Question:** Can one person get extra access on top of their role (Ryan Adams's answer, via Corrina)?
- **Options:**
  - A. Yes — a person can have access beyond their role's default.
  - B. No — different access means a different role.
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** Corrina: "I have asked Ryan about the sales coordinator. Will let you know when he responds."
- **Blocked:** REQ-16.
- **Candidates:** existing vault entry `admin/gaps.md#per-person-access-beyond-the-role-default-and-the-approval-flow-for-role-and-permission-changes` Part 1 (open; its own "No" branch needs no code).
- **Owner:** Ryan Adams, through Corrina Bustos.
- **Workaround, if any:** option B needs no code; labelled workaround.
- **Status:** open

### Q7 — Do Sales Coordinators still assign roles?

- **Question:** Besides the Dispatcher, may Sales Coordinators assign someone's role?
- **Options:**
  - A. Dispatcher only.
  - B. Dispatcher and Sales Coordinators.
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** her first reply said Sales Coordinators; the follow-up names only the Dispatcher. The decision note records the tension as unresolved and a confirmation has been sent.
- **Blocked:** the role-change flow (out of this ticket); REQ-15 only through who holds "assign".
- **Candidates:** existing vault entry `admin/gaps.md` Part 2(e) (same anchor as Q6).
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none needed here; the flow is out of scope.
- **Status:** open

### Q8 — Who may set a role and the can-also-fill list until the approval flow exists

- **Question:** Until the Dispatcher-assigns / Dispatch-Manager-approves flow is built in a later ticket, who may set the main role and the can-also-fill list?
- **Options:**
  - A. The people who can edit an employee today keep setting both directly.
  - B. Nobody — they are not editable until the flow is built.
  - C. Only named people (say who).
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** the decision describes the end state; the flow is "new behaviour (Path A), not part of the fold"; nothing says what applies in between.
- **Blocked:** REQ-03, REQ-04 write permissions.
- **Candidates:** `decisions/2026-10-20-…-corrina.md` ("Build impact", last bullets); `admin/gaps.md` Part 2.
- **Owner:** Corrina Bustos (with Lisette Anzaldo as the named approver).
- **Workaround, if any:** option A changes nothing in permissions; labelled workaround.
- **Status:** open

### Q9 — Is the DAS Employees tab exactly the ticket-eligible set?

- **Question:** Does the DAS Employees tab list exactly the people who may go on a job ticket under REQ-05, so Sales (and every other non-ticket group) is excluded by that rule and not by a hard-coded filter? This is also the confirmation of REQ-06, whose sources are two unconfirmed vault entries.
- **Options:**
  - A. Yes, as written.
  - B. No — the tab differs from the eligible set (say how).
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** `dispatch/gaps.md` reads the tab as the eligible set but says its owner has not confirmed; the UAT row only says Sales Persons should not appear.
- **Blocked:** REQ-06.
- **Candidates:** `vault/dispatch/gaps.md` lines 942–1010 (existing entry); `vault/uat/register-2026-09-18.md` (UAT 1).
- **Owner:** Lisette Anzaldo.
- **Workaround, if any:** none.
- **Status:** open

### Q10 — The third manager who also operates

- **Question:** FCC has three `Management`-type employees who also hold `Operator`; Corrina named Jeff Kelley and Kyle Harlow. Does the third also qualify (Local 12)?
- **Options:**
  - A. Yes — name the person.
  - B. No — only Jeff Kelley and Kyle Harlow.
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** the ADP file records counts only.
- **Blocked:** REQ-05 for that one person.
- **Candidates:** `decisions/2026-10-20-…-corrina.md` "What this does not settle" item 2; `workers-departments-2026-10-20.md` §4.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** give the two named managers `Operator` on their lists; leave the third without.
- **Status:** open

### Q11 — Is today's name-based behaviour preserved exactly?

- **Question:** For existing users, is each of these preserved exactly: only Oilers see Pre-Trip / JSA / Post-Trip / Compliance steps; Operators and Oilers earn boom premium as they do; Salesmen are the salespeople in pickers; Sales Coordinators and Sales Managers are the quote-approval pools?
- **Options:**
  - A. Yes — all preserved exactly as listed.
  - B. No — some change (say which).
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** the ticket says replace name matching; no source lists today's behaviour as the requirement. Code shows what happens, not what should. Which new role carries `runsInspections`, `boomPay` and `quoteApproval` is asked after Q1 and Q3 are answered.
- **Blocked:** REQ-11, ripple rows for pickers, approver pools, field ticket.
- **Candidates:** `ticket-flow-steps.ts`, `employee-types.ts`, `users.repository.ts` (code, descriptive); `.ai/aidlc/SCRUM-877/spec.md` (Operator Labor & Unit rule, not re-read).
- **Owner:** product team (Syed Haris to relay to Corrina Bustos).
- **Workaround, if any:** option A is what the code does today; labelled workaround.
- **Status:** open

### Q12 — Which mobile app does each kind of user get?

- **Question:** For the field employee, salesperson, crane superintendent, maintenance team and safety (and dispatch): which app experience does each get, given the app has Field, Sales and Dispatcher and nothing for the rest?
- **Options:** free answer — for each kind of user, one of: Field, Sales, Dispatcher, a new experience (describe), no mobile access.
- **Answer:**
- **Why it cannot be answered from what is written:** the 2026-06-16 recording (Wes Staley 49:14) says five kinds of user will use the app; no decision follows it. Meetings are not sources.
- **Blocked:** REQ-14.
- **Candidates:** `vault/meetings/transcripts/2026-06-16-field-ops-mobile-app-demo.md` (67 KB) line 368; `field-ops/field-ops-mobile-INDEX.md` conflict stub (3 sources, none verified — not read this run).
- **Owner:** Wes Staley (said it); product team to decide.
- **Workaround, if any:** unmapped roles keep `persona = null`, as the code comment says.
- **Status:** open

### Q13 — Do existing quotations, jobs and billing codes keep showing the same resource name?

- **Question:** After the move, should an existing quotation, job or billing code that points at an employee type still display that same name (for example "Operator")?
- **Options:**
  - A. Yes — historical records keep the name they show today.
  - B. They show the name of the role the type became.
  - C. It differs by record type (say which).
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** nothing addresses historical records.
- **Blocked:** REQ-10 and every ripple row marked Q13.
- **Candidates:** none: nothing written.
- **Owner:** product team.
- **Workaround, if any:** option A changes no displayed text; labelled workaround.
- **Status:** open

### Q14 — Do the fifteen FCC cost-code departments still need to exist?

- **Question:** The fifteen seeded departments (Accounts, Admin, Customer Repair, Dispatch, Fleet, HR, Internal Damage, Mechanics, Operations and Maintenance, Rigging, Shop, Storage, Sales, Trucking, Yard) include cost-coding departments that prefix quote, job and PO numbers in FCC and are used by assets. What happens to them?
- **Options:**
  - A. They go; the nine replace them.
  - B. The fifteen stay and the nine are added.
  - C. Cost coding moves to a separate field; the nine are the org structure.
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** `admin/gaps.md` Update 2026-09-04 point (4) says "in FCC, department is cost coding, not org structure"; the decision note does not address them.
- **Blocked:** REQ-01 ripple; D5.
- **Candidates:** `payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md` and `assets/fcc-units-and-schedule-types.md` (named in the admin gap; not read this run); `seed-data.ts` `SYSTEM_DEPARTMENTS`.
- **Owner:** Corrina Bustos / Brian Petros.
- **Workaround, if any:** option B retires nothing; labelled workaround.
- **Status:** open

### Q15 — Does every new tenant get the nine departments and roles?

- **Question:** Are the nine departments and their roles created at tenant creation?
- **Options:**
  - A. Yes — every new tenant gets them.
  - B. Only TCG's tenant has them.
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** existing open vault entry; the 2026-09-04 decision records that an admin-created tenant comes up with zero of both and that `isSystem` is true only in two tenants.
- **Blocked:** REQ-01, REQ-02 provisioning; `EmployeeType` being global means other tenants get no replacement rows otherwise.
- **Candidates:** `admin/gaps.md#what-a-newly-created-tenant-must-contain--provisioned-defaults-or-an-empty-portal` (existing, open); `tenant-seed.service.ts` (code).
- **Owner:** product team.
- **Workaround, if any:** option B (TCG's tenant only); labelled workaround.
- **Status:** open

### Q16 — Role editor label and conditional fields

- **Question:** In the role editor, which of the developer's proposals apply: the label "Dispatchable" instead of "Use as an employee type", and showing boom pay and inspections only for dispatchable roles while hiding quote approval for them?
- **Options:**
  - A. Both the label and the conditional fields.
  - B. The label only.
  - C. The conditional fields only.
  - D. Neither — the editor stays as it is.
  - X. Other — say what (a different label, for example).
- **Answer:**
- **Why it cannot be answered from what is written:** the proposals come from the developer session; no source specifies UI copy or conditional rules. FCC's term is `Dispatchable on` (`payroll/fcc-employee-master-reference-data.md` §2, unverified, via the gap entries).
- **Blocked:** REQ-13.
- **Candidates:** `role-behaviour.section.tsx` (code); `payroll/fcc-employee-master-reference-data.md` §2.
- **Owner:** product team (Syed Haris to confirm with Corrina Bustos).
- **Workaround, if any:** option D changes nothing; labelled workaround.
- **Status:** open

### Q17 — Confirm REQ-11: behaviour keys on role settings, not on names

- **Question:** Is this still how it should work: "Behaviour that today is decided by matching an employee type or role name (Operator, Salesmen, Salesperson, …) is decided by a setting on the role"? (REQ-11's only source of intent is the Linear ticket, which is unverified.)
- **Options:**
  - A. Yes, as written.
  - B. No — say what changed.
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** the ticket restates a developer's goal; no vault file or decision note says it. The repo only shows five unread settings on `DepartmentRole`.
- **Blocked:** REQ-11.
- **Candidates:** `TCG-237` (Linear, `updatedAt` 2026-10-20T00:20Z, re-read this run, unchanged); `apps/api/prisma/schema.prisma:4545-4560` (code, descriptive).
- **Owner:** product team (Syed Haris to relay to Corrina Bustos).
- **Workaround, if any:** none.
- **Status:** open

### Q18 — People already allocated who would not be eligible

- **Question:** What happens to a person already allocated to a job slot who would not be eligible under REQ-05?
- **Options:**
  - A. Existing allocations stay as they are; the rule applies to new placements only.
  - B. They stay but are flagged for dispatch to review.
  - C. They are removed at migration.
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** nothing speaks to existing allocations.
- **Blocked:** REQ-05 (Read time), the `JobResourceAllocation` ripple row.
- **Candidates:** none: nothing written.
- **Owner:** Lisette Anzaldo.
- **Workaround, if any:** option A; labelled workaround. The executor must not silently remove allocations.
- **Status:** open

### Q19 — Employees whose only type is Job Foreman, Default or Apprentice

- **Question:** What main role does an employee get whose only FCC type is Job Foreman, Default or Apprentice (none of which becomes a role of its own, per REQ-07 for Job Foreman)?
- **Options:**
  - A. They are left with no main role until someone sets one by hand.
  - B. TCG names a role for each such person (say who gets which).
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** the decision excludes Job Foreman as a role and maps nothing; Default and Apprentice are not addressed.
- **Blocked:** REQ-03 (absent input), REQ-07, REQ-10, REQ-12.
- **Candidates:** `decisions/2026-10-20-…-corrina.md`; `seed-data.ts:31-48`.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** option A; labelled workaround.
- **Status:** open

### Q20 — Existing users' access on the day their role changes at migration

- **Question:** When an existing user's permissions would differ from their new role's, which applies?
- **Options:**
  - A. The new role's permissions apply at once (REQ-03: the role decides access).
  - B. Each user keeps their current permissions until TCG reviews.
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** REQ-03 says the role decides access; nothing says whether that applies retroactively at migration.
- **Blocked:** REQ-15, REQ-12.
- **Candidates:** `admin/gaps.md` (same anchor as Q1).
- **Owner:** Corrina Bustos.
- **Workaround, if any:** option B; labelled workaround.
- **Status:** open

### Q21 — A stored role setting whose field is hidden

- **Question:** If the editor hides a role setting (for example boom pay on a non-dispatchable role), what becomes of a value already stored?
- **Options:**
  - A. It is cleared.
  - B. It is kept but ignored.
  - X. Other — say what.
- **Answer:**
- **Why it cannot be answered from what is written:** no source; only relevant if Q16 answers A or C.
- **Blocked:** REQ-13.
- **Candidates:** none: nothing written.
- **Owner:** product team.
- **Workaround, if any:** option B (loses nothing); labelled workaround.
- **Status:** open

### Q22 — Only Local 12 members may fill an operating position?

- **Question:** Developer decision D8 = C enforces union membership when someone is put in an operating slot. Corrina gave Local 12 membership as the *reason* Jeff Kelley and Kyle Harlow may operate (decision note 2026-10-20, follow-up Q4) — not as a rule for everyone. Is it a rule for everyone?
- **Options:**
  - A. Yes — only Local 12 members may fill Operator, Oiler, 3rd Man or Rigger; the system refuses anyone else.
  - B. Yes, but warn instead of refuse.
  - C. No — it only explains those managers; no check.
  - X. Other — say what.
- **Answer:** X — Syed Haris (developer), 2026-10-20: not Local 12 specifically; union membership is what lets a person fill a position, and if another union comes later its members can fill too; do not restrict the check to Operator — it applies to every operating/field position. **Developer reading of a product question — pending Corrina Bustos's ratification.**
- **Why it cannot be answered from what is written:** the decision note records the reason for two people; no source states a general rule.
- **Blocked:** D8's build.
- **Candidates:** decision note 2026-10-20 follow-up Q4 (verbatim: "Jeff Kelley and Kyle Harlow are managers but are also in the local 12 union so they are allowed to operate"); Corrina 2026-09-28: "field is all union people".
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none — D8 stays unbuilt until answered.
- **Status:** open

### Q23 — Quotations on mobile for everyone with quotation permission?

- **Question:** Developer decision D7 gates mobile features by role permissions, so anyone whose role can view quotations sees quotations in the mobile app, not only salespeople. Is that intended?
- **Options:**
  - A. Yes — same access on web and mobile.
  - B. No — mobile quotations only for roles that also have a separate mobile switch.
  - X. Other — say what.
- **Answer:** X — Syed Haris (developer), 2026-10-20: "some use web, some use mobile, so it has two different permissions" — mobile features get their **own** permission modules, separate from the web modules (e.g. mobile quotations ≠ web `quotations`). Refines D7. **Developer reading — pending client ratification.**
- **Why it cannot be answered from what is written:** today mobile shows quotations only to the `sales` persona (type names Salesmen / Sales Admin); no source says office staff with quotation access should or should not get it on mobile.
- **Blocked:** the mobile slice of D7.
- **Candidates:** Wes Staley, 2026-06-16 49:14 (the mobile app is for "the field employee, the salesperson, …").
- **Owner:** Corrina Bustos or Brian Petros.
- **Workaround, if any:** none.
- **Status:** open

### Q24 — Does anyone use the asset department today?

- **Question:** Developer decision D5 removes the department from assets (it was copied from FCC's unit record; no requirement asks for it). Does anyone at TCG filter or report assets by department in the ERP today?
- **Options:**
  - A. No — remove it.
  - B. Yes — say who and for what.
  - X. Other — say what.
- **Answer:** **A** — Brian Petros, 2026-10-20 (relayed by Syed Haris), verbatim: *"Not that I know of. Just "The Crane Guys" OM (Operated and Maintained). I can't think of any filtering by department today. Would be nice, however, to have some type of filtering of assets because of all the different types of assets (like iPads, cell phones, etc.)"* Reading: no department filtering in use; remove it. His second point is a separate ask — the asset list **already** filters by category and sub-category (`assets/asset/hooks/use-assets-list-state.ts:12-13`), so asset-type filtering works if iPads/phones are set up as categories; not in this ticket's scope. Removing asset department also removes the list's `department` filter and sort column (`assets-list-view.config.ts:16`, `use-assets-list-state.ts`). **Second message, same day, verbatim:** *"And, I'm thinking when we get into the inventory of the fleet maintenance, then that may be a reason to filter/categorize by department."* Reading: no use today; a possible future need for fleet-maintenance inventory, unspecified. Filed as an open question in [`vault/assets/gaps.md` → *Grouping assets for fleet-maintenance inventory*](../../vault/assets/gaps.md#grouping-assets-for-fleet-maintenance-inventory--by-department-or-something-else). Bears on D5: whether removal keeps the stored FCC values is re-put to the developer. **Third message, verbatim:** *"The Repair Guys has many assets that will need to be put into the system. Equipment/machines/tools for repair... but that will most likely be its own org/company instead of a separate department."* Reading: TRG separates by tenant, not department — supports D5.
- **Why it cannot be answered from what is written:** code shows only a label and a list filter; usage is not observable from code.
- **Blocked:** the asset slice of D5 (removal is irreversible for the stored values).
- **Candidates:** `assets/fcc-units-and-schedule-types.md` (FCC distribution: FL 252, RG 56, OM 37 …).
- **Owner:** Brian Petros.
- **Workaround, if any:** keep the columns until answered; build everything else.
- **Status:** answered 2026-10-20 (Brian Petros)

## 13. What this spec deliberately does not specify

- The role list per department, and HDR — Q1, Q2.
- The mapping of existing types to roles, employees with only a non-role type, and the loading of FCC secondary types — Q3, Q19, Q4.
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
- [ ] Every requirement's **Edges** fields are filled or point at a §12 question
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] Every §11b row has _Chosen_ and _Decided by_ filled by a developer
- [ ] Every §11c sibling has a developer's yes / no / follow-up
- [ ] Re-diff the Linear description against REQ-05 and the "What TCG agreed" list
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________
