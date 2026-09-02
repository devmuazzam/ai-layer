---
title: FCC employees report — employee types, multi-type assignment, craft code updates
source: shared-folder/OneDrive_1_8-31-2026
migrated: 2026-08-31
updated: 2026-05-29
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

`FMS_EMPLOYEE_TYPES` — 16 rows, one flat list:

| Field roles | Portal / admin roles |
| --- | --- |
| Operator, Oiler, Mechanic, Yard Man, Rigger, Driver, Shop | Management, Sales Admin, Accounting Admin, Dispatch Admin, Safety Admin |

This is the distinction raised in the departments-and-roles discussion — *"there are
system level roles and there are field roles."* FCC never separated them, which is
why the migrated data cannot answer the question on its own.

Note **Rigger** is `EmpTypeID` 5 and has existed since 2019. **Third Man is not in this
list** — despite `CraftRoleType.THIRD_MAN` existing in `@tcg/shared` and the client asking
for it in UAT. So Third Man is a craft-code concept in FCC, not an employee type.

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
