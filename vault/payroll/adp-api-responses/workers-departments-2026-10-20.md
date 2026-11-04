---
title: Live ADP response — every worker's home department and job title, crossed with FCC (counts only)
source: live-api/GET https://api.adp.com/hr/v2/workers?$top=100&$skip={0..400} + fcc-seeder/seed-files (FMS_EMPLOYEES, FMS_EMPLOYEE_TYPE_DETAILS)
migrated: 2026-10-20
updated: 2026-10-20
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, module/admin, kind/reference, adp, permissions-roles, reference-data, data-migration]
entities: [employee, worker, department, adp-code, employee-type]
part_of: payroll/adp-api-responses/INDEX.md
---

# Worker home departments — which of the 12 ADP departments are actually used

**Captured 2026-10-20**, production, company `4RZ`. Five pages of `GET /hr/v2/workers`
(`$top=100`, `$skip` 0–400), all `200`. Pulled read-only with the `adp-api-test/get.sh` probe.
Unlike [workers-list.md](workers-list.md) (first page, ~40 records), this is the **whole roster**.

> **Counts only.** The responses carry legal names, home addresses and personal contact details
> for every worker, active and terminated. None of it is recorded here, per this folder's
> conventions. The raw bodies stayed on the capturing machine.

**Why it was pulled:** to decide what the ERP's departments and roles should be when
`EmployeeType` folds into `DepartmentRole`. See
[../../admin/gaps.md → *Departments, roles and their capabilities*](../../admin/gaps.md#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten).

---

## 1. Roster size

| `assignmentStatus` | Workers |
| --- | --- |
| `A` Active | **113** |
| `L` Leave | 2 |
| `T` Terminated | 346 |
| **Total** | **461** |

113 active matches FCC's 114 `ACTIVE` employees in the seed extract
(`apps/api/fcc-seeder/seed-files/employees.json`) closely. The file-number → AOID map captured
2026-10-17 holds 462 entries, so the roster is complete to within one record.

## 2. Nine of the twelve departments are empty

Active workers by `homeOrganizationalUnits` (always `typeCode: Department`), with the
`jobCode` inside each:

| Department | Active | Job titles |
| --- | --- | --- |
| `PPEDEP` Field | **81** | `OILDRV` 33 · `OPERATOR` 22 · `MECHANIC` 10 · `YARD` 5 · none 9 · `SALES` 1 · `MNGMT` 1 |
| `SADMIN` Salary Admin | **26** | `SALES` 8 · `ADM` 6 · `ACCOUNTG` 5 · `MNGMT` 3 · `SAFETY` 2 · `DISPATCH` 2 |
| `SALOFF` Officer | **4** | `MNGMT` 2 · `ADM` 2 |
| none | 2 | `SALES` 1 · none 1 |

**`OPRDEP`, `ODRDEP`, `MECDEP`, `YRDDEP`, `ACTDEP`, `DISDEP`, `SLSDEP`, `SAFDEP` and `MNGDEP`
hold no active worker.** In practice ADP sorts people three ways: **hourly field, shop and yard
(`PPEDEP`) · salaried office (`SADMIN`) · officers (`SALOFF`)**. The function is carried by the
**job title**, not the department. This confirms and extends the first-page observation in
[workers-list.md](workers-list.md) (*"Field staff → `PPEDEP`, salaried → `SADMIN`"*) and
qualifies [codelist-departments.md](codelist-departments.md), which listed the twelve as org
units: the list exists, but only three are in use.

**Consequence for the ERP:** an ADP home department is an **export value** (hourly field /
salaried / officer), not a department list to model the org on.

## 3. Crossed with FCC

Joined to the FCC seed extract by normalised first + last name: **75 of 113 active ADP workers
matched** (74 to an FCC `ACTIVE` record). 38 did not, most likely nicknames, spelling or the
extract's age (it lacks the 2026-02-18 `Job Foreman` type). FCC `employeeCode` is a 4-digit
`EmpID` and ADP's File # is 6-digit; they are **not** the same key.

**FCC classification → ADP department** (matched active):

| FCC classification | ADP department |
| --- | --- |
| `FIELD EMP` | `PPEDEP` 46 · `SADMIN` 1 |
| `MECH LABOR` | `PPEDEP` 5 |
| `YARD LABOR` | `PPEDEP` 1 |
| **`OWNER`** | **`SALOFF` 4 — all four** |
| `ACCOUNTING` · `OFC ADMIN` · `SALES` · `DISPATCH` · `SAFETY DEP` · `HR` · `MANAGEMENT` | `SADMIN` (one `SALES` has no department) |

**FCC primary employee type → ADP job title** (matched active, field crew):

| FCC primary type | ADP job title |
| --- | --- |
| Operator (18) | `OPERATOR` 12 · `OILDRV` 4 · none 2 |
| 3rd Man (14) | `OILDRV` 8 · `OPERATOR` 3 · none 2 · `SALES` 1 |
| Oiler (11) | `OILDRV` 6 · `OPERATOR` 2 · none 3 |
| Mechanic (7) | `MECHANIC` 7 |

**The two systems disagree on a field worker's job about one time in five.** For the field role,
FCC's primary employee type is the better source; ADP's job title is not kept in step with it.

## 4. What FCC adds (same seed extract, active employees)

- **Secondary types mean "can fill any field slot".** 56 of 67 active field crew hold all five
  field types (Operator, 3rd Man, Oiler, Driver, Rigger) in `FMS_EMPLOYEE_TYPE_DETAILS`; only the
  primary type distinguishes them. Bears on
  [../gaps.md → *Employee types — FCC holds several per employee; we store one*](../gaps.md#employee-types--fcc-holds-several-per-employee-we-store-one).
- **FCC's manager/staff split is type + classification.** Department heads are typed
  `Management` and their classification names the function (`HR`, `OFC ADMIN`, `SAFETY DEP`,
  `DISPATCH`, `SALES`, `MANAGEMENT`, and `OWNER` ×4). Three `Management` employees also hold
  `Operator`.
- **FCC's employee `department` field is empty on all 220 records.** Classification is the
  populated per-employee grouping (105 of 114 active).
- **The owners are on both systems** — four `OWNER` records in FCC, the same four in ADP's
  `SALOFF`. An "executive" grouping is present in the data, not only on the org chart.

## Not established here

- Whether ADP's `PPEDEP`/`SADMIN`/`SALOFF` should be derived from the ERP role, from pay type, or
  stored per employee — a developer decision for the ticket that removes `EmployeeType`.
- The 38 unmatched active workers. A reliable join needs the ADP File # stored against the FCC
  employee, which neither extract carries.
- Ventura `4RY` — not pulled.
