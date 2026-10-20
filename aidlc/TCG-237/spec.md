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
| D2 | Shape of "can also fill", and whether it carries a primary flag | **A.** new join model Employee↔DepartmentRole. **B.** JSON / array column on `Employee`. **C.** generalise `EmployeeCraftAssignment`'s primary/secondary pattern (`:2861`). **D.** join model plus the main role stored in it as `PRIMARY`, with `Employee.roleId` removed. **X.** Other — say what. | A join table matches the one-to-many test in the template and must go into the tenant-scope allowlist. The main role is already `Employee.roleId` (REQ-03 says exactly one), so a primary flag would duplicate it unless D. **Added option E (2026-10-20):** separate table + a check that the person holds a craft code of the matching classification. Developer first chose C, then E after the AI trade-off against C: payroll reads every `EmployeeCraftAssignment` row as payable, crafts have no Rigger/Driver classification, owners differ (payroll vs Dispatcher). **Sub-choice pending:** whether the new row also stores a craft code. | **Separate "can also fill" list** — **F1 = C (2026-10-20), reverting D2b = B** after meeting evidence: Brian 2026-08-13 24:32 *"any secondary must be a higher rate than the primary"* (Kyle agreed) would stop an Operator holding a lower-paid Oiler/Rigger/3rd-Man secondary, and Kyle 23:57 keeps pay at the person's own rate when filling a different position — eligibility and pay are separate, as in FCC (type list gates allocation, Corrina 2026-06-02 1:02:18). Crafts stay pay-only. The list row holds employee + role + audit fields (added by/when, approved by), as in the earlier sub-choice B. **D2d = A:** no craft check — the list is managed on its own; crafts are pay-only. **D2c = A (re-confirmed after F1):** the main role must equal the primary craft's role; a mismatch is refused; applies only when the employee has a primary craft — so a manager who operates (Jeff Kelley, Kyle Harlow) needs a manager-role primary craft and Operator on the can-also-fill list | Syed Haris | 2026-10-20 |
| D3 | Keep column name `usedAsEmployeeType` with a new UI label, or rename it | **A.** keep the column, change the label only (`:4545`, migration-free). **B.** rename the column to `isDispatchable` via migration. **C.** keep both during transition. **X.** Other — say what. | The column name will keep describing a concept the ticket retires; B costs a rename across ~8 API / web files written by `c6b0d3dcc`. Label copy is Q16, not this decision. | **B** | Syed Haris | 2026-10-20 |
| D4 | Where the type → role mapping lives, and what happens to FCC types that are not roles | **A.** mapping table in the migration file. **B.** mapping by name at migration time (precedent: `findNameSuggestions` merges by lower-cased name). **C.** leave unmapped employees without a role. **X.** Other — say what. | Mapping **content** is product (Q3, Q19); this row is only *where it lives*. | **A** | Syed Haris | 2026-10-20 |
| D5 | Replace the 15 seeded cost-code departments with the nine, and where cost-code use moves | **A.** replace. **B.** keep fifteen and add nine. **C.** keep both and mark the old as cost codes. **D.** move cost-coding to a separate field on `Asset`. **X.** Other — say what. | `Asset.departmentId` and a string `Asset.department` both exist (`assets.repository.ts:163,338`). Product side is Q14. **After discussion (2026-10-20):** git history shows the asset's department was copied from FCC's unit record — a free-text `department` predates April 2026, and `487790d2c` (2026-04-07, "feat: asset managment") added the `Department` FK beside it; no meeting, ticket or vault requirement asks for it. FCC's code does three jobs the ERP already covers: equipment kind → asset categories (sub-category required on non-draft assets); accounting bucket → accounting module (`ExpenseGlAccount`); responsibility → `EmployeeAsset` "managed by" + yard. | **A** for departments (the nine replace the fifteen) **and** remove department from assets entirely — **D5b = A** (after Brian Petros's three replies, Q24): remove now, stored values included; FCC codes remain recoverable from the FCC seed files — both `Asset.departmentId` and the text `Asset.department` go; no cost-centre field. Department-addressed notifications (`DEPT-DISP`, `SAFE` in `notifications.config.ts`) move to the new departments. | Syed Haris | 2026-10-20 |
| D6 | ADP export department (PPEDEP / SADMIN / SALOFF): store on the role, or derive | **A.** column on `DepartmentRole`. **B.** derive from pay type / department. **C.** defer to the ADP export ticket (`.ai/aidlc/ADP-PAYDATA-EXPORT/`). **X.** Other — say what. | `workers-departments-2026-10-20.md` "Not established here": a developer decision for the ticket removing `EmployeeType`. No export code reads these values today. | **C** | Syed Haris | 2026-10-20 |
| D7 | `RoleAppPersona` options vs the five kinds of mobile user (enum change) | **A.** keep four values (`FIELD_CREW`, `SALES`, `DISPATCH`, `OFFICE`). **B.** add values. **C.** replace the enum with a per-role app list. **X.** Other — say what. | Product input is Q12. Mobile `AppPersona` has only three values and `appPersona` on the role is read by no mobile code. **After choice:** developer states only two mobile apps are in use — the field-worker app and the quotation (sales) app; mobile still has a `(dispatch)` route group and a `dispatcher` persona. | **Gate mobile features by the existing role permissions** (changed from A, then B, 2026-10-20; developer: it is one mobile app whose features are modules — "it's the crud"). Mobile shows a feature when the role's permission for that module is at least view (quotations → `quotations`); field tickets get their own permission module; a new mobile feature = a new permission module; mobile sign-in allowed when the role has at least one mobile feature. `RoleAppPersona` is removed. | Syed Haris | 2026-10-20 |
| D8 | Local 12 membership: checked by the ERP, or only explains a manager's can-also-fill entry | **A.** explanation only (no new field). **B.** a membership flag on `Employee` (`unionCodeId` / `unionStatus` exist at `:4252-4253`). **C.** rule check at assignment. **X.** Other — say what. | Decision note: treating it as explanation is "the smaller build"; developer's call. **After choice:** C enforces a product rule nobody has stated in general form ("only Local 12 members may fill an operating position") — Corrina gave union membership as the reason for two managers, not as a rule for everyone; needs a §12 confirmation before build. | **C** | Syed Haris | 2026-10-20 |
| D9 | PR / unit structure given ~330 files and the 400-line budget | **A.** stacked PRs sliced by surface (schema → API → web → mobile). **B.** stacked PRs sliced by feature (picker by picker). **X.** Other — say what. | Decomposer's job; recorded so the sign-off box is not forgotten. | **B** | Syed Haris | 2026-10-20 |
| D10 | API contract for the 138/108/69 consumers: endpoint, response field, `GET /users/me` shape | **A.** keep `employeeTypeId` / `employeeTypeName` as aliases of the role during transition. **B.** replace outright. **C.** repoint `GET /employee-types` to return roles. **X.** Other — say what. | A lets the 14 qa-automation specs and mobile cached sessions survive a step; it leaves two names for one thing. Pattern: P2 `UNDECIDED` details apply to any new list endpoint. | **B** — "it's a cleanup task as well" | Syed Haris | 2026-10-20 |
| D11 | Fate of the `EmployeeType` table, its six FKs and the `employee-types` module / web feature | **A.** drop after data migration. **B.** freeze read-only. **C.** keep until D10's aliases are gone. **X.** Other — say what. | With D10 = B there are no aliases, so C reads as: keep the table until the last slice has moved every consumer, then drop it. **Pending:** which "enum" the developer means — the closest match is `packages/shared/src/constants/employee-types.ts` (name constants incl. `CRAFT_ROLE_TYPE_EMPLOYEE_TYPE_NAMES`, which payroll's `craftRoleTypeForEmployeeTypeName` reads). | **C**, plus remove both name maps: the shared name constants in `packages/shared/src/constants/employee-types.ts` (the craft-classification → type-name map must be *replaced* by a role → craft-classification link, not deleted — payroll reads it) and mobile `PERSONA_BY_EMPLOYEE_TYPE` | Syed Haris | 2026-10-20 |
| D12 | How a role relates to craft codes (needed by D2's craft check and by D11's removal of the craft-classification → type-name map) | **A.** one craft classification per role (new optional field on the role). **B.** several classifications per role (link table). **C.** reuse `boomPay`. **D.** *(developer, 2026-10-20)* each **craft code** points at one **role**; a role can have many craft codes. **X.** Other — say what. | With D, "can this person fill role R" can be read from their craft assignments (crafts whose role is R), which overlaps D2's separate list — see the D2/D12 follow-up. `CraftCode.roleType` (`RoleType` enum, read by payroll for the boom modifier) still exists; whether it stays beside the new role link is pending. | **D** — wherever an Employee Type dropdown was used (employee create, craft code form, everywhere) it becomes a Role dropdown; each craft code gets one role, one role can be on many craft codes. **F2 = B (2026-10-20):** the boom column comes from the role of the **position filled on the job** (the allocation's role), not the craft's role — Corrina Bustos, `meetings/transcripts/2026-08-13-payroll-process.md` 54:22–55:05 (L358–366): *"if they're on the job as an oiler or an operator, they can qualify for boom pay… it's not a lifetime rule… it's per job"*; that quote is to be the `payroll-rules-provenance.md` entry. **D12a reversed by Q27 = A (2026-10-20): `roleType` stays; U19 dropped.** ~~**D12a = B:** `CraftCode.roleType` (`RoleType` enum) is removed in this ticket; payroll reads the boom classification from the craft's role (`DepartmentRole.boomPay`). **Constraint:** this touches the pay engine — `contexts/payroll-engine.md` requires the change to be behaviour-preserving with same-result tests, and any pay-rule change needs its source in `vault/payroll/payroll-rules-provenance.md` in the same commit.~~ | Syed Haris | 2026-10-20 |
| D13 | How the system knows a role is a manager or holds a responsibility (no role-name checks — D11) | **A.** a permission per responsibility, granted to whichever role TCG chooses in Departments, following the existing `payroll-admin` module (`packages/shared/src/constants/permissions.ts`); no manager flag. **B.** A plus a "Department manager" checkbox on the role (one per department) for routing to "this department's manager". **C.** a Manager field on the department pointing at a person. **X.** Other — say what. | Nothing in TCG-237 routes to "a department's manager". Role-change approval (Dispatch Manager, decision note 2026-10-20) is a permission that arrives with the approval-flow ticket; department-head timesheet approval (yard → Dylan, Melissa 2026-05-28 43:55) would be the first user of B. | **A** | Syed Haris | 2026-10-20 |

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
- **Meeting evidence (tcg-scrum search, 2026-10-20):** Corrina, `meetings/transcripts/2026-07-09-adp-and-data-migration.md` 16:58 (L164): *"field is just field. It doesn't granular into operator oiler."* Kyle, `meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md` 20:12 (L133): Sales Coordinator is *"a new position in between dispatch and sales."*
- **Answer:** **B** — seed role list: Field Operations: Operator, Oiler, 3rd Man, Rigger, Driver, Crane Superintendent · Shop: Mechanic, Shop Manager · Yard: Yard Tech, Facility Manager · Dispatch: Dispatcher, Dispatch Manager · Sales: Sales Coordinator, Salesperson, Sales Manager · Accounting: Accounting, CFO, Controller, Accounts Receivable, Accounts Payable · Safety: Safety, Safety Manager, Safety Auditor · HR: HR Manager, Payroll Admin, Certified Payroll · Management: Manager, Owner, President. From the Q3 mapping plus the 16 June 2026 org chart (`vault/admin/engagement-directory-and-org-charts.md`, unverified); TCG adds or renames in the app. Developer note: each department has a manager and employees — whether the system must mark which role is the manager is a separate structural question. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Why it cannot be answered from what is written:** The decision note gives only the Q1 examples and says the full list "was not asked". `admin/gaps.md` → *Departments, roles and their capabilities* records it as still open.
- **Blocked:** REQ-02, REQ-08, REQ-12, REQ-15.
- **Candidates:** `vault/decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md` (26 KB, 2026-10-20); `vault/admin/gaps.md` lines 951–1051 (2026-10-20 updates); `apps/api/src/utility/seed-data.ts` `SYSTEM_DEPARTMENTS` (old fifteen, not TCG-reviewed). Existing vault entry covers it: `admin/gaps.md#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten`.
- **Owner:** Corrina Bustos with Brian Petros (named in the admin gap).
- **Workaround, if any:** none — seeding any list would be inventing it.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q2 — What "HDR" means, and whether it is a role

- **Question:** Is "HDR" TCG's name for a Local 12 mechanic, and if so is there one Shop role for them, and what is it called?
- **Options:**
  - A. "HDR" is another name for a Local 12 mechanic; one Shop role, named "Mechanic".
  - B. "HDR" is another name for a Local 12 mechanic; one Shop role, named "HDR".
  - C. "HDR" and "Mechanic" are two different roles.
  - X. Other — say what (including what "HDR" stands for, which no file writes out).
- **Meeting evidence (tcg-scrum search, 2026-10-20):** Brian Petros, `meetings/transcripts/2026-07-09-adp-and-data-migration.md` 1:04:47 (L462): *"this HDR… it's heavy duty repair. That's the mechanics"*; 57:40 (L422): *"HDR is not used anymore"* (craft codes). Supports A (HDR = Local 12 mechanic, one Shop role).
- **Answer:** **A** — HDR means heavy duty repair, the Local 12 mechanics; one **Mechanic** role in Shop, no separate HDR role. Accepted on the meeting evidence above (Brian Petros 2026-07-09 1:04:47, 57:40). Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Why it cannot be answered from what is written:** The expansion of the acronym is written nowhere in the vault. The 2026-09-10 payroll call is the only place that defines the word, and meeting material is retrospective and is not a source for a requirement (`tcg-elaborator.md` §4), so it cannot close this. What it says, as context: Corrina Bustos 43:33 — *"So Local 12 mechanics, or HDRs is what they call them, they follow the same payroll logic as the Local 12 rules"*; 50:23–50:48 — *"Mechanics are always Local 12 … We don't have non-union mechanic … it's only Local 12 Mechanic and then Yard Tech"*; Corrina 49:07 / Kyle Harlow 49:39 — an HDR "in the shop" may go third man on a job. The curated notes (`meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md`, ~lines 153–157) say "mechanics/HDRs (Local 12 …)". Craft codes `HDR-%` are L12 in `payroll/gaps.md` lines 2648, 4091. All point the same way (HDR = Local 12 mechanic), but a role list needs the owner's word, and the decision note uses "HDR mechanic" as if it were a qualifier on Mechanic. *Correction:* the earlier draft of this spec said a grep for HDR in the vault returned nothing; that was wrong.
- **Blocked:** REQ-02, REQ-05.
- **Candidates:** `vault/meetings/transcripts/2026-09-10-payroll-rate-buckets-work-orders-paper-tickets.md` (60 KB) lines 1188, 1309–1322 (not a source); `vault/meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md` (16 KB, 2026-09-10, unverified); `vault/payroll/gaps.md` lines 2648, 4091; `vault/decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md`.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q3 — What each existing employee type becomes

- **Question:** For each of the 16 seeded types (3rd Man, Accounting Admin, Dispatch Admin, Driver, Management, Mechanic, Oiler, Operator, Rigger, Safety Admin, Sales Admin, Salesmen, Shop, Yard Man, Default, Apprentice), which role does an employee holding it get as their main role?
- **Options:** free answer — a table of type → role (and department).
- **Meeting evidence (tcg-scrum search, 2026-10-20):** Corrina, `meetings/transcripts/2026-06-25-cc-tcg-erp-system.md` 18:22 (L167): Sales Admin's job title *"is sales coordinator."*
- **Answer:** **A** — Operator, Oiler, 3rd Man, Rigger, Driver → same-named roles in Field Operations; Mechanic and Shop → Mechanic (Shop); Yard Man → Yard Tech (Yard); Dispatch Admin → Dispatcher (Dispatch); Sales Admin → Sales Coordinator (Sales); Salesmen → Salesperson (Sales); Accounting Admin → Accounting (Accounting); Safety Admin → Safety (Safety); Management → Manager (Management); Job Foreman, Apprentice, Default → no role (Q19). Syed Haris (developer), 2026-10-20 — developer decision, open to TCG challenge.
- **Why it cannot be answered from what is written:** The decision settles the shape and maps nothing. No document pairs a type with a role. (Employees whose only type is Job Foreman, Default or Apprentice are Q19.)
- **Blocked:** REQ-12, REQ-10.
- **Candidates:** `vault/payroll/fcc-employee-types-and-crafts.md` (5.5 KB; read §2 this run, §1 not); `payroll/gaps.md` lines 2171–2300; `seed-data.ts:31-48`.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none; mapping by lower-cased name equality (as `findNameSuggestions` does) would settle only names that already match.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q4 — Do FCC's secondary types load into can-also-fill as they are?

- **Question:** Should the migration load each employee's FCC secondary types into their can-also-fill list as they are?
- **Options:**
  - A. Yes — load every FCC secondary type into the list as it is.
  - B. No — migrate main roles only; TCG fills the lists by hand afterwards.
  - C. Load them as a draft that TCG reviews per employee before it takes effect.
  - X. Other — say what.
- **Answer:** **Superseded 2026-10-20 by developer decision D2b = B:** fill eligibility comes from craft assignments, not employee types, so FCC secondary types are not loaded into a fill list. What remains is Q25.
- **Why it cannot be answered from what is written:** Evidence, not a decision: in the 2026-10-20 ADP/FCC extract, 56 of 67 active field crew hold all five field types (Operator, 3rd Man, Oiler, Driver, Rigger) and only the primary distinguishes them (`payroll/adp-api-responses/workers-departments-2026-10-20.md` §4); FCC's secondary types "mean can fill any field slot" there, and `payroll/fcc-employee-types-and-crafts.md` §2 says the seeder extracts all 781 assignment rows and drops the secondaries. Corrina's examples in the decision note are narrower (Operator → Oiler, Rigger, 3rd Man; HDR mechanic → 3rd Man, Rigger). Loading as-is therefore gives most field crew five positions. No source says whether TCG wants that.
- **Blocked:** REQ-04 backfill, REQ-12.
- **Candidates:** `vault/payroll/adp-api-responses/workers-departments-2026-10-20.md` (6 KB, 2026-10-20); `vault/payroll/fcc-employee-types-and-crafts.md` (5.5 KB, 2026-09-04); `payroll/gaps.md` → *Employee types*.
- **Owner:** Corrina Bustos with Lisette Anzaldo (who dispatches).
- **Workaround, if any:** option B is the smallest build (main roles only, lists empty); labelled as a workaround, not a recommendation.
- **Status:** superseded 2026-10-20

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
- **Meeting evidence (tcg-scrum search, 2026-10-20):** Ryan Adams, `meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md` 29:52 (L156) — default access plus extra access per employee; Melissa McNutt, `meetings/transcripts/2026-06-17-erp-sprint-review.md` 51:51 (L335) — lifting a restriction for a long-serving coordinator, then *"Right, I know"* when told they should be promoted. Ambiguous between A and B.
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
- **Answer:** **A** — the Dispatcher only assigns roles (Corrina's follow-up answer). Syed Haris (developer), 2026-10-20 — developer decision, open to TCG challenge.
- **Why it cannot be answered from what is written:** her first reply said Sales Coordinators; the follow-up names only the Dispatcher. The decision note records the tension as unresolved and a confirmation has been sent.
- **Blocked:** the role-change flow (out of this ticket); REQ-15 only through who holds "assign".
- **Candidates:** existing vault entry `admin/gaps.md` Part 2(e) (same anchor as Q6).
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none needed here; the flow is out of scope.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q8 — Who may set a role and the can-also-fill list until the approval flow exists

- **Question:** Until the Dispatcher-assigns / Dispatch-Manager-approves flow is built in a later ticket, who may set the main role and the can-also-fill list?
- **Options:**
  - A. The people who can edit an employee today keep setting both directly.
  - B. Nobody — they are not editable until the flow is built.
  - C. Only named people (say who).
  - X. Other — say what.
- **Answer:** **A** — until the approval flow exists, whoever can edit employees today sets a person's role and can-also-fill list. Syed Haris (developer), 2026-10-20 — developer decision, open to TCG challenge.
- **Why it cannot be answered from what is written:** the decision describes the end state; the flow is "new behaviour (Path A), not part of the fold"; nothing says what applies in between.
- **Blocked:** REQ-03, REQ-04 write permissions.
- **Candidates:** `decisions/2026-10-20-…-corrina.md` ("Build impact", last bullets); `admin/gaps.md` Part 2.
- **Owner:** Corrina Bustos (with Lisette Anzaldo as the named approver).
- **Workaround, if any:** option A changes nothing in permissions; labelled workaround.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q9 — Is the DAS Employees tab exactly the ticket-eligible set?

- **Question:** Does the DAS Employees tab list exactly the people who may go on a job ticket under REQ-05, so Sales (and every other non-ticket group) is excluded by that rule and not by a hard-coded filter? This is also the confirmation of REQ-06, whose sources are two unconfirmed vault entries.
- **Options:**
  - A. Yes, as written.
  - B. No — the tab differs from the eligible set (say how).
  - X. Other — say what.
- **Meeting evidence (tcg-scrum search, 2026-10-20):** Melissa, `meetings/transcripts/2026-07-02-mobile-app-dispatch.md` 14:16 (L112): in FCC it is *"your primary function and then all… your secondary"*; Corrina, `meetings/transcripts/2026-06-02-mobile-app-sales-dispatch.md` 1:02:18 (L453): *"if they don't have it in their employee profile, it stops Dispatch from being able to assign them in a certain position."* FCC gated by employee type.
- **Answer:** **A** — the DAS Employees tab and allocation pickers show the people who may fill the position: main role equals it, or it is on their can-also-fill list. Accepted on the meeting evidence above (Melissa 2026-07-02 14:16; Corrina 2026-06-02 1:02:18). Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Why it cannot be answered from what is written:** `dispatch/gaps.md` reads the tab as the eligible set but says its owner has not confirmed; the UAT row only says Sales Persons should not appear.
- **Blocked:** REQ-06.
- **Candidates:** `vault/dispatch/gaps.md` lines 942–1010 (existing entry); `vault/uat/register-2026-09-18.md` (UAT 1).
- **Owner:** Lisette Anzaldo.
- **Workaround, if any:** none.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q10 — The third manager who also operates

- **Question:** FCC has three `Management`-type employees who also hold `Operator`; Corrina named Jeff Kelley and Kyle Harlow. Does the third also qualify (Local 12)?
- **Options:**
  - A. Yes — name the person.
  - B. No — only Jeff Kelley and Kyle Harlow.
  - X. Other — say what.
- **Answer:** **A** — not needed: the can-also-fill list decides who fills operating positions, so the third manager need not be identified. Syed Haris (developer), 2026-10-20 — developer decision, open to TCG challenge.
- **Why it cannot be answered from what is written:** the ADP file records counts only.
- **Blocked:** REQ-05 for that one person.
- **Candidates:** `decisions/2026-10-20-…-corrina.md` "What this does not settle" item 2; `workers-departments-2026-10-20.md` §4.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** give the two named managers `Operator` on their lists; leave the third without.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q11 — Is today's name-based behaviour preserved exactly?

- **Question:** For existing users, is each of these preserved exactly: only Oilers see Pre-Trip / JSA / Post-Trip / Compliance steps; Operators and Oilers earn boom premium as they do; Salesmen are the salespeople in pickers; Sales Coordinators and Sales Managers are the quote-approval pools?
- **Options:**
  - A. Yes — all preserved exactly as listed.
  - B. No — some change (say which).
  - X. Other — say what.
- **Answer:** Developer, Syed Haris, 2026-10-20, on the meeting evidence: **not preserved exactly** for inspections — **F3 = B:** "Runs inspections" on Oiler, 3rd Man and Driver (Melissa McNutt, `meetings/transcripts/2026-06-04-mobile-app-job-lem-tickets.md` 21:12, L173: *"The oiler only does the operator, the crane, and then the first load… All the third man do all their own pre-trips themselves"*; truck drivers, `2026-05-19-crane-configurations-job-tickets.md` 41:51); which checklist each gets stays out of scope. **Preserved** for quote approval — **F4 = A:** today's approval pools move onto role settings unchanged; Wes Staley's different description (`2026-06-17-erp-sprint-review.md` 45:35, 50:36 — salesman approves, manager at ≥ $50k or reduced rate) is for the quotations module, not this ticket. Developer reading — open to TCG challenge.
- **Why it cannot be answered from what is written:** the ticket says replace name matching; no source lists today's behaviour as the requirement. Code shows what happens, not what should. Which new role carries `runsInspections`, `boomPay` and `quoteApproval` is asked after Q1 and Q3 are answered.
- **Blocked:** REQ-11, ripple rows for pickers, approver pools, field ticket.
- **Candidates:** `ticket-flow-steps.ts`, `employee-types.ts`, `users.repository.ts` (code, descriptive); `.ai/aidlc/SCRUM-877/spec.md` (Operator Labor & Unit rule, not re-read).
- **Owner:** product team (Syed Haris to relay to Corrina Bustos).
- **Workaround, if any:** option A is what the code does today; labelled workaround.
- **Status:** answered 2026-10-20 (developer, pending TCG challenge)

### Q12 — Which mobile app does each kind of user get?

- **Question:** For the field employee, salesperson, crane superintendent, maintenance team and safety (and dispatch): which app experience does each get, given the app has Field, Sales and Dispatcher and nothing for the rest?
- **Options:** free answer — for each kind of user, one of: Field, Sales, Dispatcher, a new experience (describe), no mobile access.
- **Answer:** **Superseded 2026-10-20 by developer decision D7:** mobile features are gated by their own permission modules per role (Q23 reading), so there is no per-persona app choice to make.
- **Why it cannot be answered from what is written:** the 2026-06-16 recording (Wes Staley 49:14) says five kinds of user will use the app; no decision follows it. Meetings are not sources.
- **Blocked:** REQ-14.
- **Candidates:** `vault/meetings/transcripts/2026-06-16-field-ops-mobile-app-demo.md` (67 KB) line 368; `field-ops/field-ops-mobile-INDEX.md` conflict stub (3 sources, none verified — not read this run).
- **Owner:** Wes Staley (said it); product team to decide.
- **Workaround, if any:** unmapped roles keep `persona = null`, as the code comment says.
- **Status:** superseded 2026-10-20

### Q13 — Do existing quotations, jobs and billing codes keep showing the same resource name?

- **Question:** After the move, should an existing quotation, job or billing code that points at an employee type still display that same name (for example "Operator")?
- **Options:**
  - A. Yes — historical records keep the name they show today.
  - B. They show the name of the role the type became.
  - C. It differs by record type (say which).
  - X. Other — say what.
- **Answer:** **B** — existing quotations, jobs and billing codes show the mapped role's name after migration. Syed Haris (developer), 2026-10-20 — developer decision, open to TCG challenge.
- **Why it cannot be answered from what is written:** nothing addresses historical records.
- **Blocked:** REQ-10 and every ripple row marked Q13.
- **Candidates:** none: nothing written.
- **Owner:** product team.
- **Workaround, if any:** option A changes no displayed text; labelled workaround.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q14 — Do the fifteen FCC cost-code departments still need to exist?

- **Question:** The fifteen seeded departments (Accounts, Admin, Customer Repair, Dispatch, Fleet, HR, Internal Damage, Mechanics, Operations and Maintenance, Rigging, Shop, Storage, Sales, Trucking, Yard) include cost-coding departments that prefix quote, job and PO numbers in FCC and are used by assets. What happens to them?
- **Options:**
  - A. They go; the nine replace them.
  - B. The fifteen stay and the nine are added.
  - C. Cost coding moves to a separate field; the nine are the org structure.
  - X. Other — say what.
- **Answer:** **Answered 2026-10-20:** Brian Petros (Q24) — no department filtering in use; developer decisions D5 / D5b = A remove department from assets and replace the fifteen with the nine.
- **Why it cannot be answered from what is written:** `admin/gaps.md` Update 2026-09-04 point (4) says "in FCC, department is cost coding, not org structure"; the decision note does not address them.
- **Blocked:** REQ-01 ripple; D5.
- **Candidates:** `payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md` and `assets/fcc-units-and-schedule-types.md` (named in the admin gap; not read this run); `seed-data.ts` `SYSTEM_DEPARTMENTS`.
- **Owner:** Corrina Bustos / Brian Petros.
- **Workaround, if any:** option B retires nothing; labelled workaround.
- **Status:** answered 2026-10-20

### Q15 — Does every new tenant get the nine departments and roles?

- **Question:** Are the nine departments and their roles created at tenant creation?
- **Options:**
  - A. Yes — every new tenant gets them.
  - B. Only TCG's tenant has them.
  - X. Other — say what.
- **Answer:** **A** — every new tenant starts with the nine departments and their roles, editable. Syed Haris (developer), 2026-10-20 — developer decision, open to TCG challenge.
- **Why it cannot be answered from what is written:** existing open vault entry; the 2026-09-04 decision records that an admin-created tenant comes up with zero of both and that `isSystem` is true only in two tenants.
- **Blocked:** REQ-01, REQ-02 provisioning; `EmployeeType` being global means other tenants get no replacement rows otherwise.
- **Candidates:** `admin/gaps.md#what-a-newly-created-tenant-must-contain--provisioned-defaults-or-an-empty-portal` (existing, open); `tenant-seed.service.ts` (code).
- **Owner:** product team.
- **Workaround, if any:** option B (TCG's tenant only); labelled workaround.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q16 — Role editor label and conditional fields

- **Question:** In the role editor, which of the developer's proposals apply: the label "Dispatchable" instead of "Use as an employee type", and showing boom pay and inspections only for dispatchable roles while hiding quote approval for them?
- **Options:**
  - A. Both the label and the conditional fields.
  - B. The label only.
  - C. The conditional fields only.
  - D. Neither — the editor stays as it is.
  - X. Other — say what (a different label, for example).
- **Answer:** **A** — rename the label and show boom pay and inspections only when the role is Dispatchable. Confirmed after the U2 build: Quote approval is also hidden for Dispatchable roles; badge and suggestion-hint copy follow the label. Syed Haris (developer), 2026-10-20 — developer decision, open to TCG challenge.
- **Why it cannot be answered from what is written:** the proposals come from the developer session; no source specifies UI copy or conditional rules. FCC's term is `Dispatchable on` (`payroll/fcc-employee-master-reference-data.md` §2, unverified, via the gap entries).
- **Blocked:** REQ-13.
- **Candidates:** `role-behaviour.section.tsx` (code); `payroll/fcc-employee-master-reference-data.md` §2.
- **Owner:** product team (Syed Haris to confirm with Corrina Bustos).
- **Workaround, if any:** option D changes nothing; labelled workaround.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q17 — Confirm REQ-11: behaviour keys on role settings, not on names

- **Question:** Is this still how it should work: "Behaviour that today is decided by matching an employee type or role name (Operator, Salesmen, Salesperson, …) is decided by a setting on the role"? (REQ-11's only source of intent is the Linear ticket, which is unverified.)
- **Options:**
  - A. Yes, as written.
  - B. No — say what changed.
  - X. Other — say what.
- **Answer:** **A** — answered by the developer's §11c sibling decision (name-matched role checks are replaced by role settings in this ticket) and D11 = C (name maps removed). Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Why it cannot be answered from what is written:** the ticket restates a developer's goal; no vault file or decision note says it. The repo only shows five unread settings on `DepartmentRole`.
- **Blocked:** REQ-11.
- **Candidates:** `TCG-237` (Linear, `updatedAt` 2026-10-20T00:20Z, re-read this run, unchanged); `apps/api/prisma/schema.prisma:4545-4560` (code, descriptive).
- **Owner:** product team (Syed Haris to relay to Corrina Bustos).
- **Workaround, if any:** none.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q18 — People already allocated who would not be eligible

- **Question:** What happens to a person already allocated to a job slot who would not be eligible under REQ-05?
- **Options:**
  - A. Existing allocations stay as they are; the rule applies to new placements only.
  - B. They stay but are flagged for dispatch to review.
  - C. They are removed at migration.
  - X. Other — say what.
- **Answer:** **A** — existing allocations are left as they are; the eligibility check applies to new allocations. Syed Haris (developer), 2026-10-20 — developer decision, open to TCG challenge.
- **Why it cannot be answered from what is written:** nothing speaks to existing allocations.
- **Blocked:** REQ-05 (Read time), the `JobResourceAllocation` ripple row.
- **Candidates:** none: nothing written.
- **Owner:** Lisette Anzaldo.
- **Workaround, if any:** option A; labelled workaround. The executor must not silently remove allocations.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q19 — Employees whose only type is Job Foreman, Default or Apprentice

- **Question:** What main role does an employee get whose only FCC type is Job Foreman, Default or Apprentice (none of which becomes a role of its own, per REQ-07 for Job Foreman)?
- **Options:**
  - A. They are left with no main role until someone sets one by hand.
  - B. TCG names a role for each such person (say who gets which).
  - X. Other — say what.
- **Meeting evidence (tcg-scrum search, 2026-10-20):** Brian, `meetings/transcripts/2026-08-13-payroll-process.md` 1:06:25 (L452): foreman is a $3 premium when designated; Brian, `meetings/transcripts/2026-07-09-adp-and-data-migration.md` 1:04:07 (L458): apprentice steps 1–6 are craft-code levels. Neither is a role; no source names their main role.
- **Answer:** **A** — no main role until set by hand; listed for review after migration. Syed Haris (developer), 2026-10-20 — developer decision, open to TCG challenge.
- **Why it cannot be answered from what is written:** the decision excludes Job Foreman as a role and maps nothing; Default and Apprentice are not addressed.
- **Blocked:** REQ-03 (absent input), REQ-07, REQ-10, REQ-12.
- **Candidates:** `decisions/2026-10-20-…-corrina.md`; `seed-data.ts:31-48`.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** option A; labelled workaround.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q20 — Existing users' access on the day their role changes at migration

- **Question:** When an existing user's permissions would differ from their new role's, which applies?
- **Options:**
  - A. The new role's permissions apply at once (REQ-03: the role decides access).
  - B. Each user keeps their current permissions until TCG reviews.
  - X. Other — say what.
- **Answer:** **A** — on migration day each user gets their new role's permissions immediately. Syed Haris (developer), 2026-10-20 — developer decision, open to TCG challenge.
- **Why it cannot be answered from what is written:** REQ-03 says the role decides access; nothing says whether that applies retroactively at migration.
- **Blocked:** REQ-15, REQ-12.
- **Candidates:** `admin/gaps.md` (same anchor as Q1).
- **Owner:** Corrina Bustos.
- **Workaround, if any:** option B; labelled workaround.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q21 — A stored role setting whose field is hidden

- **Question:** If the editor hides a role setting (for example boom pay on a non-dispatchable role), what becomes of a value already stored?
- **Options:**
  - A. It is cleared.
  - B. It is kept but ignored.
  - X. Other — say what.
- **Answer:** **Split by time:** tickets already completed keep the boom pay they were calculated with (history unchanged); from then on a hidden stored setting is **kept but ignored** (B) — the value stays and returns if the role is made Dispatchable again. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Why it cannot be answered from what is written:** no source; only relevant if Q16 answers A or C.
- **Blocked:** REQ-13.
- **Candidates:** none: nothing written.
- **Owner:** product team.
- **Workaround, if any:** option B (loses nothing); labelled workaround.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q22 — Only Local 12 members may fill an operating position?

- **Question:** Developer decision D8 = C enforces union membership when someone is put in an operating slot. Corrina gave Local 12 membership as the *reason* Jeff Kelley and Kyle Harlow may operate (decision note 2026-10-20, follow-up Q4) — not as a rule for everyone. Is it a rule for everyone?
- **Options:**
  - A. Yes — only Local 12 members may fill Operator, Oiler, 3rd Man or Rigger; the system refuses anyone else.
  - B. Yes, but warn instead of refuse.
  - C. No — it only explains those managers; no check.
  - X. Other — say what.
- **Meeting evidence (tcg-scrum search, 2026-10-20):** Wes Staley, `meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md` 52:32–53:25 (L274–280): *"different types of union employees… pipe fitters… iron workers… We'll need the ability to expand yards and unions."* Supports the developer reading (any union).
- **Answer:** X — Syed Haris (developer), 2026-10-20: not Local 12 specifically; union membership is what lets a person fill a position, and if another union comes later its members can fill too; do not restrict the check to Operator — it applies to every operating/field position. **Accepted 2026-10-20 on Wes Staley's evidence (2026-03-19 52:32–53:25: "different types of union employees… We'll need the ability to expand yards and unions"); open to TCG challenge.**
- **Why it cannot be answered from what is written:** the decision note records the reason for two people; no source states a general rule.
- **Blocked:** D8's build.
- **Candidates:** decision note 2026-10-20 follow-up Q4 (verbatim: "Jeff Kelley and Kyle Harlow are managers but are also in the local 12 union so they are allowed to operate"); Corrina 2026-09-28: "field is all union people".
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none — D8 stays unbuilt until answered.
- **Status:** answered 2026-10-20 (developer, on meeting evidence; open to TCG challenge)

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

### Q25 — Who-can-fill comes from craft codes; do Rigger and Driver craft codes exist?

- **Question:** Developer decision D2b = B derives the positions a person may fill from their craft codes (each craft code now belongs to one role). Two things for TCG: (1) Corrina described the Dispatcher assigning roles with Dispatch Manager approval — under D2b that process covers only the main role, and whoever assigns craft codes decides who can fill a position. Is that acceptable? (2) Craft codes today are classified Operator, Oiler, 3rd Man, Laborer, Admin or Mechanic — none Rigger or Driver. Does TCG have craft codes a Rigger or Driver is paid under?
- **Options:**
  - A. Yes to (1); Rigger and Driver use existing craft codes (say which).
  - B. Yes to (1); new Rigger / Driver craft codes are needed.
  - C. No to (1) — the Dispatcher must control who can fill a position.
  - X. Other — say what.
- **Meeting evidence (tcg-scrum search, 2026-10-20):** `meetings/transcripts/2026-08-13-payroll-process.md`: Corrina 24:27 (L187) *"But then they couldn't be added to a job as a rigger"*; Brian 24:32 (L188) *"any secondary must be a higher rate than the primary"*, Kyle 24:42 *"Yes, yes. Correct."*; Kyle 23:57 (L177) *"Even if they fill a different position, we have to keep it at that rate."* Wes, `meetings/transcripts/2026-09-02-erp-job-tickets-and-payroll.md` 50:17 (L195): rigging *"doesn't change anything for pay."* Led to F1 = C (D2 reverted to a separate list).
- **Answer:** **Superseded 2026-10-20 by F1 = C:** who-can-fill is a separate list again, not derived from craft codes, so part (1) no longer arises; part (2) (Rigger / Driver craft codes) matters only for pay, which stays at the person's own rate when filling another position (Kyle 2026-08-13 23:57; Wes 2026-09-02 50:17).
- **Why it cannot be answered from what is written:** the decision note gives the role-assignment process, not fill eligibility; no source lists a Rigger or Driver craft code.
- **Blocked:** D2b's build; REQ-04, REQ-05.
- **Candidates:** decision note 2026-10-20 (Q2, follow-up Q2); `schema.prisma` `enum RoleType`.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** none.
- **Status:** superseded 2026-10-20

### Q26 — Old departments, old roles and unmapped types: where do they go?

*Raised by `tcg-decomposer` 2026-10-20 while slicing. Q3 maps employee **types** to roles; nothing maps what already exists on the other side.*

- **Question:** (a) The fifteen seeded departments hold roles with employees on them today (Account Manager, Payroll Manager, Company Admin, per-department Managers, FLEET, INTERNAL DAMAGE, CUSTOMER REPAIR …). When the nine replace the fifteen (D5 = A), which new department and role does each old role become, and what happens to an employee whose existing role is not in the Q1 list? (b) Which old department's permission template seeds which new role (the REQ-15 / Q5 workaround needs this)? (c) Quotation, job, billing-code and sub-category rows whose type is Job Foreman, Default or Apprentice (Q19 covers employees only): what do they show after migration? (d) Do tenants other than TCG's (demo, dev) get migrated, or only new ones (Q15)?
- **Options:** free answer — a table: old department → new department; old role → new role; old template → new role; unmapped-type rows → a role or "stay empty".
- **Why it cannot be answered from what is written:** Q3 and Q1 list the target; no source lists what happens to the existing roles, and Q20 makes the answer take effect on migration day.
- **Blocked:** the data migration (U4), and therefore every unit after it.
- **Candidates:** `apps/api/src/utility/seed-data.ts` `SYSTEM_DEPARTMENTS` (the fifteen); `admin/gaps.md` → *Departments, roles and their capabilities*.
- **Owner:** Syed Haris (developer) proposes, Corrina Bustos to challenge.
- **Workaround, if any:** none — a guess here changes what existing users can see on migration day (Q20).
- **Answer:** (a) **A** — an old role whose name matches a new role moves to it; otherwise it is kept, moved to the closest new department, and listed for review. (b) **A** — a new role copies the permissions of the old role it replaces; a role replacing nothing starts from the matching quick-start template. (c) **A** — quotation, job, billing-code and sub-category rows typed Job Foreman, Apprentice or Default get no role and are listed for review. (d) **A** — every existing tenant is migrated. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q27 — Removing `CraftCode.roleType` (D12a = B): what replaces its other uses?

*Raised by `tcg-decomposer` 2026-10-20.*

- **Question:** `CraftCode.roleType` has six values (OPERATOR, OILER, THIRD_MAN, LABORER, ADMIN, MECHANIC). Besides the boom column, payroll reads it for the pay group (MECHANIC → L12 mechanic group, `packages/shared/src/utils/payroll-group.ts`), the guarantee exemption (ADMIN, `packages/payroll-engine/src/guarantee.ts:46`), the premium filter `PayrollPremium.craftRoleType` (`schema.prisma:6028`), the wage-group setup warnings (`payroll-setup-warnings.ts`) and the craft-selection step in `das-allocations.service.ts:1383-1433`. D12a says payroll reads the boom classification from the role's `boomPay`, which has only OPERATOR / OILER / NONE. (a) How are the MECHANIC, ADMIN, LABORER and THIRD_MAN uses derived once the column is gone? (b) Which role does each existing craft code point at, for LABORER and ADMIN crafts that have no role in the Q1 list? (c) For an employee whose primary craft's role differs from the role Q3 gave them (D2c), at migration: refuse, list for review, or re-point?
- **Options:**
  - A. Keep `CraftCode.roleType` for payroll classification; only the boom column moves (revisits D12a).
  - B. Add a payroll-classification setting to the role (developer names it); craft code reads it through its role.
  - C. Derive each use from the department / role (Mechanic role → mechanic group; an Admin department → guarantee exempt).
  - X. Other — say what.
- **Why it cannot be answered from what is written:** D12a names only the boom use; the others are code facts found by `git grep -n 'roleType' -- apps/api/src packages`.
- **Blocked:** U19 (removal of the column). The pay-engine rule order and results must not change (`contexts/payroll-engine.md`).
- **Candidates:** `vault/payroll/payroll-rules-provenance.md`; `payroll/gaps.md` (craft classification entries).
- **Owner:** Syed Haris (developer); Corrina Bustos for any pay-group consequence.
- **Workaround, if any:** option A — nothing is removed, U19 is cut.
- **Answer:** **A** — `CraftCode.roleType` stays for payroll classification; only the boom column moves to the role of the position filled (F2). Reverses D12a = B; U19 dropped. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q28 — Codes for the nine departments and their roles, and the notification departments

*Raised by `tcg-decomposer` 2026-10-20.*

- **Question:** REQ-01 leaves the `DEPT-…` / `ROLE-…` codes `NOT SPECIFIED`. (a) Keep the existing codes where a name survives (`DEPT-SALES`, `DEPT-DISPATCH`, `DEPT-HR`, `DEPT-SHOP`, `DEPT-YARD`) and mint the rest, or mint all nine fresh? (b) Dispatch and HR notifications resolve a department by code from `notifications.config.ts`: the defaults are `DEPT-DISP` and `SAFE`, but the seeded codes are `DEPT-DISPATCH` and `DEPT-HR`, so the defaults match nothing today. Which codes should dispatch and HR notifications use after D5?
- **Options:** A. keep surviving codes, mint the rest from `entity_sequences`; B. mint all fresh; X. other.
- **Why it cannot be answered from what is written:** a coded entity's prefix and codes are a developer decision (`CLAUDE.md` → Identity); (b) is an existing mismatch the spec only touches through D5.
- **Blocked:** U3 (seed codes), U4 (migration), the notification part of U15.
- **Candidates:** `apps/api/src/config/notifications.config.ts:28-29`; `seed-data.ts` `SYSTEM_DEPARTMENTS`.
- **Owner:** Syed Haris (developer).
- **Workaround, if any:** none.
- **Answer:** (a) **B** — mint all nine department codes (and role codes) fresh (developer: "it makes no sense that I create a department with DEPT-SALES"). (b) **B** — dispatch and HR notifications go to roles holding a permission for them (D13 pattern), not to a department code; the `notifications.config.ts` department-code defaults are retired. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q29 — What replaces "type Salesmen / Sales Admin or role Salesperson" in the salesperson pickers?

*Raised by `tcg-decomposer` 2026-10-20.*

- **Question:** Four pickers (customer salesperson, asset sold-by, quotation salesperson, employee list "salespeople" filter) and the SALESPERSON stage of quote-approval routing decide "is a salesperson" by type or role **name** (`SALESPERSON_TYPE_NAME`, `SALESPERSON_ROLE_NAME`). None of the five role settings covers it; Q11 answered inspections (F3) and approval pools (F4) only. What decides it after the change?
- **Options:**
  - A. A permission per responsibility, following `payroll-admin` (D13 = A): a role is a salesperson when it holds that permission.
  - B. A new "Can be a salesperson" setting on the role.
  - C. The role's department is Sales.
  - X. Other — say what.
- **Why it cannot be answered from what is written:** the choice adds a permission module or a column (structural, `CLAUDE.md` → Developers decide structure).
- **Blocked:** U13, and U8's salesperson reads.
- **Candidates:** `git grep -n 'SALESPERSON_TYPE_NAME\|SALESPERSON_ROLE_NAME' -- apps packages`.
- **Owner:** Syed Haris (developer).
- **Workaround, if any:** none.
- **Answer:** **A** — "is a salesperson" is a permission a role holds (D13 / `payroll-admin` pattern); drives the four salesperson pickers and the SALESPERSON stage of quote-approval routing. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q30 — The union check (D8 = C, Q22): what is checked, against what, and where?

*Raised by `tcg-decomposer` 2026-10-20.*

- **Question:** Q22 says union membership is what lets a person fill an operating position, for any union, in every field position. Not stated: (a) which roles are "field positions" (every Dispatchable role; the Field Operations department; a new setting)? (b) What counts as membership (`Employee.unionCodeId` of a union kind; `unionStatus`)? (c) Which writers enforce it — DAS allocation save, job resources replace, and the can-also-fill list entry itself? (d) Does the main role need it too (a non-union Operator)?
- **Options:** free answer, or a letter per sub-question once the developer lists them.
- **Why it cannot be answered from what is written:** Q22 gives the principle (Wes Staley 2026-03-19 52:32-53:25), no rule.
- **Blocked:** the union part of U17 only.
- **Candidates:** `schema.prisma:4252-4253`; `EmployeeUnionCode`.
- **Owner:** Syed Haris (developer); Corrina Bustos or Brian Petros to confirm.
- **Workaround, if any:** U17 ships without the union check.
- **Answer:** **A** — field positions = every Dispatchable role; membership = the employee's union code is of kind UNION; enforced on DAS allocation save, job-resources save, and adding a can-also-fill entry; a Dispatchable main role needs membership too. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q31 — Mobile permission modules: names, which features, and who has them on day one

*Raised by `tcg-decomposer` 2026-10-20. Refines Q23 (open).*

- **Question:** D7 + Q23 say mobile features are gated by their own permission modules. (a) Which modules (for example field tickets, quotations, approvals, dispatch) and what do they gate? (b) Today mobile access follows the type-name persona; after migration it follows these modules, and Q20 applies the new role's permissions at once. Which roles start with which mobile module, so no current mobile user is locked out and no office user gains access? (c) Mobile sign-in rule — "role has at least one mobile feature" (D7): what do users with none see?
- **Options:** free answer; a table role → mobile modules.
- **Why it cannot be answered from what is written:** a new permission module is a structural addition; the starting levels decide who can sign in to the app.
- **Blocked:** U14.
- **Candidates:** `apps/mobile/data/contracts/identity.contract.ts`; `apps/mobile/app-shell/registry.ts`; `packages/shared/src/constants/permissions.ts`.
- **Owner:** Syed Haris (developer); Corrina Bustos or Brian Petros (Q23) to ratify.
- **Workaround, if any:** none.
- **Answer:** **A** — two modules, "Mobile: Field tickets" and "Mobile: Quotations"; day one: Operator, Oiler, 3rd Man, Rigger, Driver, Crane Superintendent get Field tickets; Sales Coordinator and Salesperson get Quotations; a user with no mobile module is refused sign-in with "Your role doesn't include mobile access — ask your admin." Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q32 — Does the seeded Payroll Admin role hold the `payroll-admin` permission?

*Raised by `tcg-executor` 2026-10-20 while building U3.*

- **Question:** The U3 brief says the seeded HR → Payroll Admin role "holds the existing `payroll-admin` permission", but `units.md` U3 does not say so, D13 = A only says responsibilities are permissions, and the shipped rule is the opposite: no seeded role holds `payroll-admin` by default; a tenant admin grants it by hand (PAYROLL-FLAGS REQ-01, decision 2026-09-30 build-plan item E2; enforced by `seed-data.ts` `FULL_PERMISSIONS` and `payroll-admin-permission.spec.ts`). Which applies to the new Payroll Admin role?
- **Options:** A. keep REQ-01: seeded with `payroll-admin: none`, granted by hand (as built in U3). B. seed it with `payroll-admin: edit` (approve and export). C. seed it with `payroll-admin: full`. X. other.
- **Why it cannot be answered from what is written:** the brief and a shipped, tested rule disagree; picking one changes who can approve and export payroll in every new tenant.
- **Blocked:** nothing; U3 built option A, which is reversible in the role editor.
- **Candidates:** `apps/api/src/utility/seed-data.ts` (`FULL_PERMISSIONS`); `apps/api/src/presentation/payroll/payroll-admin-permission.spec.ts`.
- **Owner:** Syed Haris (developer); Corrina Bustos for the payroll consequence.
- **Workaround, if any:** option A.
- **Answer:** **A** — follow the shipped PAYROLL-FLAGS rule (decision 2026-09-30 E2): no seeded role holds `payroll-admin`; a tenant admin grants it by hand. The Payroll Admin role is seeded without it. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q33 — Is the Crane Superintendent role dispatchable?

*Raised by `tcg-executor` 2026-10-20 while building U3.*

- **Question:** `units.md` U3's API row (and the U3 brief) put `isDispatchable` on Crane Superintendent, but REQ-05's acceptance (from the `[VERIFIED]` decision 2026-10-20, F3) says "No ticket slot type named Crane Superintendent exists", and U3's own *Deliberately not in this unit* says "Crane Superintendent as a ticket slot — it is not; only a role". A dispatchable role is offered wherever an employee type is picked (quotation, job and billing-code resources). Should Crane Superintendent be dispatchable?
- **Options:** A. not dispatchable — a Crane Superintendent fills Operator or Rigger through the can-also-fill list (as built in U3). B. dispatchable (it becomes a resource / slot type). X. other.
- **Why it cannot be answered from what is written:** the unit row contradicts a verified acceptance line in the same spec.
- **Blocked:** nothing; U3 built option A (the schema default), reversible in the role editor.
- **Candidates:** REQ-05; `units.md` U3.
- **Owner:** Syed Haris (developer).
- **Workaround, if any:** option A.
- **Answer:** **B** — Crane Superintendent is Dispatchable. Developer: "let use one rule only for all, no exceptions" — every Field Operations role is Dispatchable. **Consequence recorded:** this overrides REQ-05's acceptance line "No ticket slot type named Crane Superintendent exists"; Corrina's verified answer ("assigned in what position he was for that particular job") still holds for how he is usually placed, but he can now also be picked as a Crane Superintendent slot. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q34 — Which template does each seeded role start from (Q26b), and record Q26 / Q28

*Raised by `tcg-executor` 2026-10-20 while building U3.*

- **Question:** (a) Q26 and Q28 are marked answered but carry no **Answer** line; U3 was built on Q28a = **B** (mint all department and role codes fresh) as relayed in the U3 brief — please record it, and Q26's answers. (b) Q26b (which old department's template seeds which new role) has no recorded answer. U3 seeded every role from the template the old system departments all used — `manager`, every module `full` except `payroll-admin` — except Sales Coordinator (`admin`, full) and Salesperson (`contributor`, empty), which keep their old templates. Consequence: in a new tenant, and in the demo, an Operator, Oiler, Rigger, 3rd Man or Driver with a portal login gets full web access (the old demo gave field roles the plain USER baseline). Keep that?
- **Options:** A. keep as built. B. Field Operations, Shop and Yard roles start from the USER baseline (as the old demo's field roles did); office roles as built. C. a per-role template list (free answer).
- **Why it cannot be answered from what is written:** Q5 is open and the REQ-15 workaround names "the department's existing template", which two existing seeds (system and demo) answer differently for the field roles.
- **Blocked:** nothing in U3 (editable defaults); U4 applies the same templates to existing users on migration day (Q20 = A), so it should be settled before U4.
- **Candidates:** `apps/api/src/utility/seed-data.ts` `SYSTEM_DEPARTMENTS`; `apps/web/src/features/departments/constants/role-permissions.ts` `TEMPLATE_PERMISSION_CONFIG`.
- **Owner:** Syed Haris (developer); Q5's four editors to challenge.
- **Workaround, if any:** option A.
- **Answer:** **C** — field (Dispatchable) roles start with **no web access**: an explicit `none` on every web module, so the empty-map USER baseline does not apply; their mobile access arrives with U14 (Q31). Other roles keep the as-built starting templates (Q5 still open). With Q33 = B this includes Crane Superintendent. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q35 — The "closest new department" for each old department whose roles are kept (Q26a)

*Raised by `tcg-executor` 2026-10-20 while building U4.*

- **Question:** Q26a keeps an old role whose name matches no new role and moves it "to the closest new department", but no source says which new department is closest to each old one. Which of the nine does each of these become: Accounts (Account Manager, Payroll Manager), Admin (Company Admin), Operations (Crane Operator — legacy seed), Shop & Maintenance (Yard Man — legacy seed), Customer Repair, FLEET, INTERNAL DAMAGE, MECHANICS, OPERATIONS AND MAINTENANCE, RIGGING, STORAGE, TRUCKING (the last eight hold only `Manager` roles, which merge into Management → Manager, so they matter only if a tenant added roles there) — and what of a department a tenant created itself?
- **Options:** A. a table, one line each: `old department → new department` (for example `Accounts → Accounting, Admin → Management, Operations → Field Operations, Shop & Maintenance → Shop, …`), plus one rule for tenant-made departments. B. every unmatched department → Management. C. no automatic move: the migration aborts per tenant until an admin moves those roles by hand. X. other.
- **Why it cannot be answered from what is written:** Q26a names the rule ("closest") but not the pairs; picking them decides where Company Admin and Payroll Manager holders sit on migration day.
- **Blocked:** U4's migration — it aborts, naming tenant, department and role, for every kept role in a department that is not one of the nine (the `tcg237_department_map` table in the migration is left empty). The dry run (`apps/api/prisma/scripts/dry-run-nine-departments-migration.ts`) lists exactly which departments need a pair, per tenant.
- **Candidates:** `apps/api/src/utility/seed-data.ts` on `main` (`SYSTEM_DEPARTMENTS`, `CRANE_GUYS_DEPARTMENTS`); `utility/demo-data/data/organisation.ts` on `main`.
- **Owner:** Syed Haris (developer); Corrina Bustos to challenge.
- **Workaround, if any:** none — the migration refuses to run instead.
- **Answer:** **A** — Accounts → Accounting · Admin → Management · Dispatch → Dispatch · HR → HR · Sales → Sales · Safety → Safety · Yard, Storage → Yard · Operated & Maintained, Rigging, Trucking, legacy Operations → Field Operations · Mechanics, Shop, Customer Repair, Internal Damage, Fleet, legacy Shop & Maintenance → Shop · any tenant-created department → Management, listed for review. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q36 — Old roles that merge into one new role but hold different permissions (Q26b)

*Raised by `tcg-executor` 2026-10-20 while building U4.*

- **Question:** Under Q26a several old roles can move into the same new role — every old department has a role named `Manager`, and all of them match Management → Manager. Q26b says the new role copies "the permissions of the old role it replaces". When those old roles' permission maps differ (an admin edited one), whose does the new role take?
- **Options:** A. none — the migration aborts and lists them until the maps agree (as built). B. the most permissive level per module across them. C. the map of the old role with the most holders. D. the new role's template, and the role is listed for review. X. other.
- **Why it cannot be answered from what is written:** Q26b assumes one old role per new role; the seeded data has thirteen `Manager` roles. (Seeded maps are identical, so this bites only where an admin edited one.) Also confirm: a new role that already exists in the tenant (reused by name) keeps its own permissions and is not overwritten by the roles merging into it (as built).
- **Blocked:** U4's migration, only for a tenant where the merging maps differ (it aborts, naming them).
- **Candidates:** `tcg237_role_permissions` in the U4 migration.
- **Owner:** Syed Haris (developer).
- **Workaround, if any:** option A.
- **Answer:** **A** — an old role named "Manager" goes to its department's manager role (Dispatch → Dispatch Manager, Sales → Sales Manager, Shop → Shop Manager, Yard → Facility Manager, Safety → Safety Manager, HR → HR Manager, else → Management / Manager); where roles still merge, each module takes the **highest** level any merged role had (union), whether the target is new or reused. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q37 — Names and delete rules of the six new role columns (structural)

*Raised by `tcg-executor` 2026-10-20 while building U4. `units.md` U4: "New column names are a structural choice — the executor proposes names and stops for the developer".*

- **Question:** U4 built these as **AI proposal — pending developer confirmation** (all nullable `uuid` → `department_roles.id`, each with an index): `billing_codes.role_id` (index `(tenant_company_id, role_id)`, ON DELETE SET NULL), `quotation_resources.role_id` (SET NULL), `job_resources.role_id` (SET NULL), `sub_category_associated_resources.associated_role_id` (RESTRICT), `sub_category_nested_association_settings.nested_role_id` (RESTRICT), `craft_codes.role_id` (SET NULL). Each delete rule mirrors the `employee_type_id` beside it; `craft_codes` has none, so SET NULL follows `Employee.role`. No unique constraint was added beside `uq_sc_assoc_res_parent_employee_type` / `uq_sc_nested_assoc_parent_employee_type`, because Mechanic and Shop both map to Mechanic and a parent holding both would collide. Confirm, or name the change.
- **Options:** A. as built. B. as built, but the nested column is `associated_role_id` (U10's wording "associated_role_id … on both tables"). C. `craft_codes.role_id` ON DELETE RESTRICT (a role in use by a craft cannot be deleted). D. add the unique `(parent, role)` constraints now and decide what a Mechanic + Shop collision becomes. X. other.
- **Why it cannot be answered from what is written:** the slice row names `role_id` / `associated_role_id` only loosely and leaves names to the developer; U10 says `associated_role_id` on both tables, the existing nested column is `nested_employee_type_id`.
- **Blocked:** nothing until push — a rename on an unpushed branch is cheap; after U4 merges it is a migration.
- **Candidates:** `units.md` U4, U7, U8, U9, U10, U11 (the later units' names).
- **Owner:** Syed Haris (developer).
- **Workaround, if any:** option A.
- **Answer:** **A** — names accepted: `role_id` on billing_codes, quotation_resources, job_resources, craft_codes; `associated_role_id` and `nested_role_id` on the two sub-category tables (U10 text to follow). **RESTRICT** on all six FKs, plus a "role in use" guard in `DepartmentsService.removeRole` that refuses deletion with a clear message. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q38 — Readings U4 took where two answers meet (confirm or correct)

*Raised by `tcg-executor` 2026-10-20 while building U4.*

- **Question:** U4 is built on these readings; each is reversible on the branch, none after the migration runs. (a) **Q19 vs Q26a:** an employee whose type maps to no role (Job Foreman, Apprentice, Default) gets no role *from the type* but keeps the role they already hold, re-pointed by Q26a — not stripped to "no main role" (stripping would remove, say, a Default-typed Company Admin's access on migration day). (b) An old role that matches no new role is kept even if nobody holds it (Q26a "otherwise it is kept"), although `units.md` step 6 says "delete … the roles that emptied" — only merged roles are deleted. (c) Names match case-insensitively (`SHOP` is reused as `Shop` and renamed to the nine's spelling, per REQ-01 acceptance "case as written"); only active departments are reused; archived ones are dissolved. (d) "Every existing tenant" (Q26d) includes the `PLATFORM` (Super Admin) tenant, which also gets the nine. (e) An employee type absent from the Q3 list (no source maps it) aborts the migration and is named. (f) An employee with no role keeps their department only if it is one of the nine; otherwise it becomes empty (D1 = B).
- **Options:** A. all as built. B. as built except (list the letters and the change). X. other.
- **Why it cannot be answered from what is written:** each pair of sources (Q19/Q26a, Q26a/units step 6, Q26d/the platform tenant) can be read two ways; the rest is not addressed.
- **Blocked:** nothing in the build; all six take effect on migration day (Q20 = A).
- **Candidates:** `units.md` U4 slice row "Migration steps"; Q19, Q26.
- **Owner:** Syed Haris (developer).
- **Workaround, if any:** option A.
- **Answer:** (a), (b), (c), (d), (f) **confirmed as built**; (e) **changed:** an employee type missing from the Q3 list gives that employee **no role** and puts them on the review list (as Q19), instead of aborting. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)


### Q39 — Reused roles: do they take the seeded settings?

*Raised from the U4 prisma-guardian review, 2026-10-20.*

- **Question:** When a tenant already has a role the migration reuses (e.g. Operator in a department named Field Operations), it updated only `runs_inspections` and `quote_approval`. Should reused roles take all seeded settings?
- **Options:**
  - A. Force the seeded settings onto reused roles — `is_dispatchable`, `boom_pay`, `runs_inspections`, `quote_approval`, `role_type`, `locked_permissions`; permissions follow Q36.
  - B. Keep them as they are; the dry run lists them.
  - X. Other — say what.
- **Answer:** **A**. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Owner:** Syed Haris (developer).
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q40 — Mechanic and Shop both become Mechanic: duplicate sub-category rows

*Raised from the U4 prisma-guardian review, 2026-10-20.*

- **Question:** A sub-category holding both a Mechanic and a Shop association (or nested setting) ends up with two rows on one role, blocking U10's (parent, role) unique.
- **Options:**
  - A. Merge duplicates in the U4 migration (one row per parent and role) and list them in the dry run.
  - B. Leave them; the dry run lists them; U10 handles them.
  - X. Other — say what.
- **Answer:** **A**. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Owner:** Syed Haris (developer).
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q41 — Deploying U4: locks, connection, failed-migration recovery

*Raised from the U4 prisma-guardian review, 2026-10-20.*

- **Question:** The migration holds strong locks on quotation_resources, job_resources, billing_codes, craft_codes and the sub-category tables for its whole run, needs a direct (non-pooled) connection with TEMP privilege, and a RAISE leaves it recorded as failed until `prisma migrate resolve --rolled-back`.
- **Options:**
  - A. Maintenance window with the app quiesced, duration measured on a production copy; write the steps into a deploy runbook.
  - X. Other — say what.
- **Answer:** **A**. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Owner:** Syed Haris (developer).
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q42 — The quotation's Sales Coordinator picker and self-default still match the role name

*Raised by tcg-executor building U5, 2026-10-20.*

- **Question:** U5 moves the API check on a quotation's Sales Coordinator field (`quotations.controller.ts` `validateSalesCoordinatorCode`, `quotations.service.ts` `resolveSalesCoordinatorId`) onto the role's *Quote approval* = Coordinator, as its slice rows say. The pickers and the self-default that feed that field are not in U5's rows and still match the role **name** "Sales Coordinator": web `features/quotations/components/organisms/main-tab.tsx:587` (`EmployeeSelect roleName={SALES_COORDINATOR_ROLE_NAME}` → `GET /employee?roleName=`, matched by name in `employee-list.helpers.ts:78-79`), mobile `components/sales/quote-create-main-info.tsx:96` (`roleName: 'Sales Coordinator'`), and the "fill me in as Sales Coordinator" default in web `views/resolve-quotation-employee-defaults.ts:117-118` and `views/use-apply-quotation-employee-defaults.ts:51-52`. After a rename the picker lists nobody and the default stops filling, while the API would accept a Coordinator-setting employee. Where should these move?
- **Options:**
  - A. Add them to U5: the two web defaults read `user.quoteApproval` (no shape change); the pickers need the employee list to filter by the setting — a new `GET /employee` query parameter (structural: name and shape for the developer), web and mobile together (§11c).
  - B. A follow-up unit stacked on U5 (same content as A), so U5 stays as built.
  - C. Leave them on the name until U20 removes the constant; accept the drift after a rename.
  - X. Other — say what.
- **Answer:** **A** — fix every remaining name match in U5: the quotation Sales Coordinator picker (web `main-tab.tsx`, mobile `quote-create-main-info.tsx`), the self-default helpers, `use-create-quotation-form-seed.ts`, the shared employee picker role filter (`employee-select.tsx`, `get-employees.ts`), the mobile mock, the stale mobile comments, and the email CC suggestions that match "coordinator" in the designation — all via a new `quoteApproval` filter on `GET /employee`. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Why it cannot be answered from what is written:** U5's slice rows list the API checks, `auth-provider.tsx` and `identity.contract.ts` only; its Shared row says "users in this unit's reach", which does not say whether the quotation form is in reach. No REQ names the picker.
- **Blocked:** nothing built in U5 depends on it; the drift exists only after a role is renamed.
- **Owner:** Syed Haris (developer).
- **Workaround, if any:** none built — the four sites are unchanged.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q43 — U5's structural choices, built on the AI's reading (confirm or correct)

*Raised by tcg-executor building U5, 2026-10-20. AI proposal — pending developer confirmation.*

- **Question:** U5 was built with these choices, none fixed by a slice row or §11b. Confirm each, or say which to change.
  - (a) `GET /users/me` field is named `quoteApproval` (the row's word), value `COORDINATOR | MANAGER | NONE`, **`null` when the user has no employee or no role** (mirrors `departmentRoleName`); mobile parses it `nullish` so a profile without the field still loads.
  - (b) `employee-assignment.util.ts`: the option `requiredRoleName` (used only by the two Sales Coordinator checks) is **replaced** by `requiredQuoteApproval`; the 400 text stays "is not a sales coordinator" via `ROLE_QUOTE_APPROVAL_LABELS`.
  - (c) `users.repository.ts` `findApproverPoolByRoles` / `findApproverPoolByRole` keep their names and take quote-approval values instead of role names (the singular one has no caller).
  - (d) `approval-routing.ts`: `poolRoleNamesForStage` renamed `poolQuoteApprovalsForStage`; new exported type `QuoteApprovalSetting` (string-compatible with the Prisma enum, as the file's other types are).
- **Options:**
  - A. Keep all four as built.
  - B. Change some — say which (e.g. b: keep `requiredRoleName` beside the new option; c: rename the repository methods).
  - X. Other — say what.
- **Answer:** **A** — (a)–(d) accepted as built; the unused `findApproverPoolByRole` is deleted. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Owner:** Syed Haris (developer).
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q46 — U6: F3 meets the shipped slot-driven step flow — which rule decides the inspection steps?

*Raised by tcg-executor before building U6, 2026-10-20. Nothing built.*

- **Question:** U6 and Q11 were written against `visibleFlowStepKeys(employeeTypeName)` ("only an employee whose type is named Oiler sees Pre-Trip / JSA / Post-Trip / Compliance"). That is no longer how the code decides. TICKET-FLOW-SLOTS-HOLDOVER shipped the developer direction `vault/decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md` (`status: reference`, D1/D4/D5): the **DAS slot** decides, via `resolveTicketStepFlow()` in `packages/shared/src/constants/ticket-flow-steps.ts` — an **Oiler slot → FULL whoever fills it; an Operator slot → FULL when the set has no Oiler slot** (also the `[VERIFIED]` `2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` clause 3); every other slot → STANDARD (8 steps: no Pre-Trip, JSA, Post-Trip, Compliance, Start Work or Labor). The employee-type name "Oiler" survives only as the fallback when no slot is found (`resolveTicketStepFlow` no-slot branch; `ticket-step-flow.ts:39`; `submit-step-guard.ts:118`; `job-progress.service.ts:113` `isOilerFlow` → the deprecated `oilerFlow` in `derive-ticket-progress-view.ts:305,315`; mobile `compose-ticket-detail.ts:86`, `ticket/index.tsx:620`, `ticket-step-screen.tsx:433`, `background-sync.ts:331`, `field.tsx:75`). Three things F3 = B does not settle against that: (1) **slot or person** — does "Runs inspections" apply to the role of the *slot* (D1: "whoever fills it"), or to the *employee's* role? The slot's role (`job_resources.role_id`) is "read from U11" per U4; (2) **FULL or four steps** — the four inspection steps are not separable today: they come only with FULL, which also brings Start Work (build-up, break-down, lunches, WTL) and Labor & Unit. Does a 3rd Man / Driver get FULL, or STANDARD plus the four (a third step list, with holdover variants nobody has written)? (3) **the solo Operator** — the seeded Operator role has `runsInspections = false` (`apps/api/src/utility/seed-data.ts:320-323`), so a pure setting rule takes inspections away from the Operator who fills a ticket with no Oiler, contradicting D1 and the verified clause 3. (U6's negative test (2) says the Operator "did not get them before either" — true of `visibleFlowStepKeys`, false of the shipped slot rule.)
- **Options:**
  - A. **Slot role decides, FULL flow.** FULL when the slot's role has `isDispatchable && runsInspections`, or the slot's role is the Operator's (identified how — say: `boomPay = OPERATOR`?) with no inspections-running slot in the set; else STANDARD. 3rd Man and Driver slots get all 14 steps incl. Start Work and Labor. Needs the slot's role → U6 moves after U11 (stack on U11/U12).
  - B. **Slot rule unchanged for FULL/STANDARD; the setting adds only the four steps.** A STANDARD ticket whose (slot's | employee's — say which) role has `isDispatchable && runsInspections` also shows Pre-Trip, JSA, Post-Trip, Compliance (12 steps), and submit requires them. New step list in shared, the API submit guard, web progress, mobile flow/verify; holdover-day variants for it must be specified first.
  - C. **Only the no-slot fallback moves now.** Where no DAS slot is found, `employeeTypeName === "Oiler"` becomes the viewer's role `isDispatchable && runsInspections` → FULL (adds `runsInspections` to `GET /users/me`, U5 shape and refetch rule). The slot rule keeps comparing slot type names until U12 swaps it to the slot's role. 3rd Man / Driver get inspections only on slot-less tickets; the rest of F3 waits for A or B.
  - D. **Cut U6.** The 2026-10-15 slot rule supersedes F3 for ticket steps; the slot-name comparison is swapped to the slot's role in U12 (same rule, settings instead of names); `runsInspections` stays stored with no reader.
  - X. Other — say what.
- **AI recommendation (not a decision):** C now plus A-or-B decided for U12 — C is the only part of U6 that needs no new step list and no slot role; A or B is a product reading of "inspections" that Melissa McNutt's quote (3rd men "do all their own pre-trips") does not choose between.
- **Why it cannot be answered from what is written:** Q11's question premise (name-based "only Oilers") predates the shipped slot rule; neither Q11, §11b nor `units.md` U6 mentions `resolveTicketStepFlow`, `stepFlow` or the 2026-10-15 note, and that note keys on the slot, not on a role setting.
- **Blocked:** all of U6 (every API, shared and mobile row reads the step-flow decision).
- **Owner:** Syed Haris (developer) — the 2026-10-15 direction is his; TCG for which steps a 3rd Man / Driver must do.
- **Workaround, if any:** none built — the Oiler-name fallback and the slot-name rule are unchanged.
- **Answer:** **46a = A:** the crane inspection (FULL flow) is done by the slot in the set whose role has `isDispatchable && runsInspections`; if no slot in the set has it, the Operator slot does — the Operator is identified by the role's `boomPay = OPERATOR`, not by name. Built in **U12**, once the slot carries a role. **46b = A:** 3rd Man and Driver get their **own** Pre-Trip, JSA, Post-Trip and Compliance steps added to the STANDARD ticket (a new 12-step list) — **pending Corrina Bustos / Lisette Anzaldo confirmation (Q47)**, and the holdover-day variants must be specified before it is built. **U6 = A:** U6 now moves only the **no-slot fallback** — the viewer's role `isDispatchable && runsInspections` replaces the employee-type name "Oiler"; `runsInspections` on `GET /users/me` in U5's shape with U5's refetch rule. The slot rule keeps comparing names until U12. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)


### Q47 — Do 3rd Man and Driver do their own Pre-Trip, JSA, Post-Trip and Compliance on every ticket?

*Raised 2026-10-20 from Q46b.*

- **Question:** The shipped slot-driven flow (decision 2026-10-15) gives 3rd Man and Driver tickets no inspection steps; the developer (Q46b = A) would add Pre-Trip, JSA, Post-Trip and Compliance to their ticket. Confirm which of those steps they must do, and whether on holdover days 2+ too.
- **Options:**
  - A. All four steps, every day, including holdover days.
  - B. All four steps on day 1 only; on holdover days, what Oilers do (per decision 2026-10-15 H8).
  - C. Pre-Trip only (their vehicle / gear), no JSA or Compliance.
  - X. Other — say what.
- **Answer:** **Working assumption (developer, until TCG flags otherwise in testing):** 3rd Man and Driver do the same four inspection steps as the Oiler — Pre-Trip, JSA, Post-Trip, Compliance — on the same days, holdover days included per decision 2026-10-15. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Why it cannot be answered from what is written:** Melissa McNutt (2026-06-04 21:12, `meetings/transcripts/2026-06-04-mobile-app-job-lem-tickets.md` L173): *"All the third man do all their own pre-trips themselves"*; truck drivers do their own (2026-05-19 41:51); neither covers JSA, Compliance or holdover days.
- **Blocked:** the 12-step STANDARD-plus-inspections flow (46b); built after U12.
- **Owner:** Corrina Bustos with Lisette Anzaldo.
- **Workaround, if any:** none — 3rd Man / Driver keep today's STANDARD ticket until answered.
- **Status:** answered 2026-10-20 (developer working assumption — revisit if TCG flags it in testing)


### Q48 — How the system picks who does the crane inspection

*Raised 2026-10-20 from Q46/Q47.*

- **Question:** "Runs inspections" is on for Oiler, 3rd Man and Driver (F3), but only one slot in a set does the crane inspection and labor (FULL flow): the Oiler, or the Operator when the set has no Oiler. 3rd Man and Driver do their own inspections (Q47). How is the crane inspector identified without role names?
- **Options:**
  - A. A per-role **"Crane inspection order"** number (nullable integer, `DepartmentRole.craneInspectionOrder`); the slot in the set with the lowest order does the crane inspection; seeded Oiler = 1, Operator = 2; editor shows it only when the role is Dispatchable.
  - B. Two booleans: "Does the crane inspection" and "Does it when no one else in the set can".
  - C. Derive from the role's boom-pay setting (Oiler column first, Operator column second).
  - X. Other — say what.
- **Answer:** **A.** Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Consequences recorded:** step flow per slot — the lowest `craneInspectionOrder` in the set → FULL; a role with `isDispatchable && runsInspections` and no order (3rd Man, Driver) → STANDARD + Pre-Trip/JSA/Post-Trip/Compliance (the 12-step list, holdover variants per decision 2026-10-15 for the inspection steps); everyone else → STANDARD. No-slot fallback (U6): order 1 → FULL; `isDispatchable && runsInspections` → own inspections; else STANDARD.
- **Owner:** Syed Haris (developer).
- **Status:** answered 2026-10-20 (developer, open to TCG challenge)

### Q49 — U6b: how the own-inspections flow is carried, and its step order

*Raised by tcg-executor after committing U6, 2026-10-20. Nothing built for U6b.*

- **Question:** Q47 = A adds Pre-Trip, JSA, Post-Trip and Compliance to the STANDARD ticket of a Dispatchable role that runs inspections and has no crane inspection order (3rd Man, Driver). Two things are not fixed: (1) **how the flow is carried.** Every surface reads `TicketStepFlow = 'FULL' | 'STANDARD'` (`packages/shared/src/constants/ticket-flow-steps.ts`; the field ticket's `stepFlow`, the submit guard, job progress, crew grouping, `job-tickets.service.ts:1061` closing work time at Left Job). Installed mobile builds parse `stepFlow` with `z.enum(['FULL','STANDARD'])` (`apps/mobile/data/contracts/ticket.contract.ts:229`), so a third value sent to an old build fails its ticket parse. (2) **the step order**, which decision 2026-10-15 does not list for this flow.
- **Options:**
  - A. A third `TicketStepFlow` member (name it — e.g. `INSPECTIONS`) on `stepFlow` everywhere. Clean, but non-additive: old mobile builds reject it until they update (no minimum-app-version gate exists).
  - B. Keep `stepFlow` two-valued and add an additive boolean on the field ticket (name it — e.g. `ownInspections`) that adds the four steps to a STANDARD ticket; the submit guard and progress read both. Old builds ignore the boolean and show plain STANDARD.
  - X. Other — say what.
- **Step order (AI derivation from the canonical order and DN-1 H8/H9 — confirm or correct):** non-holdover 12: pretrip, leftYard, driving, arriveJob, sig1, jsa, sig2, leftJob, arriveYard, posttrip, compliance, review · middle day Yard 10: pretrip, leftYard, driving, arriveJob, sig1, jsa, sig2, posttrip, leftJob, review · middle day Home 8: arriveJob, pretrip, sig1, jsa, sig2, posttrip, leftJob, review · last day Yard 12 (= non-holdover) · last day Home 10 (last day Yard without leftYard, driving). No Labor & Unit, no Start Work (Q47 names four steps).
- **AI recommendation (not a decision):** B — it ships without breaking installed apps; and the order above.
- **Why it cannot be answered from what is written:** Q47 says which steps, not where they sit or how the flow is sent; a new enum member or a new response field is the developer's structural call.
- **Blocked:** U6b (all of it).
- **Owner:** Syed Haris (developer).
- **Workaround, if any:** none built — 3rd Man / Driver keep the STANDARD flow (8 steps) on slot-less tickets, as before U6.
- **Answer:** **B** — an additional boolean on the field ticket adds Pre-Trip, JSA, Post-Trip and Compliance to the STANDARD flow (installed builds ignore it); step order as derived in this question. Syed Haris (developer), 2026-10-20 — open to TCG challenge.
- **Status:** answered 2026-10-20 (developer)


### Q50 — The FCC seeder still posts `employeeTypeId` for employee billing codes

*Raised 2026-10-20 by the U9 build.*

- **Question:** `apps/api/fcc-seeder/src/seed-all.ts` (~L1490) posts `employeeTypeId` when it seeds employee billing codes (and `associatedEmployeeTypeId` for sub-category associations, found by U10); after U9 (D10 = B, no alias, `forbidNonWhitelisted`) that request is a 400. No unit owns the seeder. Who fixes it, and how?
- **Options:**
  - A. Fix it in U9: map the FCC type to the role with the Q3 mapping inside the seeder and post `roleId`.
  - B. A small follow-up unit after U9.
  - X. Other — say what.
- **Answer:** **A** — fix the FCC seeder: map FCC types to roles with the Q3 mapping and post `roleId` (billing codes, in U9) and `associatedRoleId` (sub-category associations, in U10). Syed Haris (developer), 2026-10-20 ("all ★") — open to TCG challenge.
- **Blocked:** re-running the FCC seed for billing codes.
- **Owner:** Syed Haris (developer).
- **Status:** answered 2026-10-20 (developer)


### Q51 — U10 backfills `associatedRoleId` / `nestedRoleId` into stored quotation snapshots

*Raised 2026-10-20 by the U10 build.*

- **Question:** U10's migration step 3 rewrites every `quotations.configuration_snapshot` JSON to add the role ids (per-tenant type→role map from U4's backfilled rows; ambiguous types → null). Without it, quotes snapshotted before U10 lose their labour items in the DAS required-components check and the quote Resources tab. Keep it?
- **Options:**
  - A. Keep the JSON backfill in U10; dry-run it on the production copy before deploy.
  - B. Drop it; readers fall back to the legacy `associatedEmployeeTypeId` in old snapshots until U20.
  - X. Other — say what.
- **Answer:** **A** — keep U10's JSON backfill of quotation snapshots; dry-run it on the production copy before deploy. Syed Haris (developer), 2026-10-20 ("all ★") — open to TCG challenge.
- **Owner:** Syed Haris (developer).
- **Status:** answered 2026-10-20 (developer)

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
