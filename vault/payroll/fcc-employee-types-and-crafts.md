---
title: FCC employees report — employee types, multi-type assignment, craft code updates
source: shared-folder/OneDrive_1_8-31-2026; corrected 2026-09-04 from shared-folder/Project-Repository-2026-09-04/2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/FCC_EMPLOYEES_20260705.xlsx
migrated: 2026-08-31
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: [SCRUM-914]
tags: [module/payroll, module/dispatch, kind/reference, fcc, migration, craft-code, employee-type]
entities: [employee, employee-type, craft-code, certificate]
---

# FCC employees report

`2026-05-29_FCC_EMPLOYEES_REPORT.xlsx`, delivered 2026-08-31. Thirteen sheets:
`FMS_EMPLOYEES`, `FMS_EMPLOYEE_TYPES`, `FMS_EMPLOYEE_TYPE_DETAILS`,
`FMS_EMP_CERTIFICATES`, `other_lookup_fields`, `FCC_vs_ERP_(Employees)`, and five
craft-code working sheets — `CraftCode_UPDATES`, `CraftCode_BEFORE-AFTER`,
`L12-CraftCode_UPDATES`, `Apprentice Craft Code UPDATES`, `FMS_EMPLOYEES_(Types)`.

---

## 1. FCC's employee types mix field roles and portal roles in one list

`FMS_EMPLOYEE_TYPES` — **15 rows**, one flat list, all active:

| Field roles | Portal / admin roles |
| --- | --- |
| Operator, Oiler, Mechanic, Yard Man, Rigger, Driver, Shop, **3rd Man**, **Job Foreman** | Management, Sales Admin, Accounting Admin, Dispatch Admin, Safety Admin, **Salesmen** |

This is the distinction raised in the departments-and-roles discussion — *"there are
system level roles and there are field roles."* FCC never separated them, which is
why the migrated data cannot answer the question on its own.

**Rigger** is `EmpTypeID` 5 and has existed since 2019.

> **⚠️ Corrected 2026-09-04.** This section previously said *"16 rows"* and *"**Third Man is not in
> this list** — so Third Man is a craft-code concept in FCC, not an employee type."* **Both
> statements were wrong.** The list has **15** rows and **`3rd Man` is `EmpTypeID` 14**, created
> 2021-11-09 by `melissam`. Verified against two independent extracts that agree row for row: the
> `FMS_EMPLOYEE_TYPES` sheet of `2026-05-29_FCC_EMPLOYEES_REPORT.xlsx` (the file this page was
> written from) and the `EMPLOYEE_TYPES` sheet of `FCC_EMPLOYEES_20260705.xlsx`, extracted
> 2026-07-02. So `CraftRoleType.THIRD_MAN` in `@tcg/shared` and the UAT request for Third Man
> **do** have an FCC employee-type counterpart — the migration does not have to invent one.
>
> Two further rows the original text did not mention: **`Salesmen`** (13, 2019-08-01) and
> **`Job Foreman`** (15, created **2026-02-18 by `corrinab`** — during the ERP engagement).
> `Job Foreman` bears on [PAY-070](rules/PAY-070-foreman-premium.md), which the register notes is
> *"in no other document"*: FCC now has a foreman employee type.
>
> Full table with ids and creation dates:
> [fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §2.

---

## 2. An employee holds several types, one flagged primary — and we discard the rest

`FMS_EMPLOYEE_TYPE_DETAILS` — **781 rows** over ~354 employees. It is a join table:
`EmpID` × `EmpTypeID` with a **`PrimaryType`** flag. Real rows:

```
EmpID 5073 → Operator (primary), Driver, Rigger
EmpID 2679 → Operator (primary), Rigger
```

**This is exactly the UAT request** — *"In Resources, we need to add a multi-select option
for whether the resource is an Operator or Rigger"* — and it is not a new feature. It is how
FCC has worked since 2019.

**What the code does with it today:**

1. The seeder **extracts it in full**, `primaryType` included —
   `fcc-seeder/src/linked-seed-files.ts:302`, written as `employee-type-assignments`.
2. `seed-all.ts:666-675` then collapses it: `primaryTypeByEmp` is a `Map<employee, type>`
   holding **one** value. Every secondary type is dropped on load.
3. It has to, because `Employee.employeeTypeId` in `schema.prisma` is a **single nullable
   FK**. There is no join table on the TCG side.

So the multi-role data is already pulled from FCC on every sync and thrown away at the
door. Restoring it is a join table plus a UI, not a discovery exercise.

**This bears on SCRUM-914**, which proposes Operator / Oiler / Supervisor / Rigger as
sub-categories under an Employee category — a third representation, alongside
`EmployeeType` and `CraftRoleType`. See [gaps.md](gaps.md).

---

## 3. Craft-code working sheets

Five sheets track craft-code changes rather than current state —
`CraftCode_BEFORE-AFTER` and `L12-CraftCode_UPDATES` look like a remap the client
performed, and `Apprentice Craft Code UPDATES` is separate again, matching
[rules/PAY-016-apprentice-wage-step.md](rules/PAY-016-apprentice-wage-step.md).
`FCC_vs_ERP_(Employees)` is the client's own field-by-field comparison of FCC against
what we built. **None of these has been read line by line** — they are named here so the
next person knows they exist.

---

## 4. Where the rest of the FCC employee vocabulary lives

Added 2026-09-04 from the Project Repository drop:
[fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) — the live code
lists (craft codes and the `-A`/`-B`/`-C` ST/OT/DT convention, union craft rates, classifications,
certificates, ethnicity), the FCC import template's employee schema and enumerations, the
migration SQL, and TCG's annotated Maintain-Employees deck. That page also carries the vendor's
own statement of the multi-type rule — *"at least one primary… unlimited secondary"* — which
confirms §2 above is FCC policy rather than a TCG local custom.
