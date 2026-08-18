---
title: Live ADP response — departments code list, and the cost-numbers 204
source: live-api/GET https://api.adp.com/codelists/hr/v3/worker-management/{departments,cost-numbers}/WFN/1
migrated: 2026-08-13
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
topics: [payroll, adp-integration, adp-api, labor-allocation, certified-payroll, reference-data]
entities: [adp-code, pay-allocation, department, cost-number, job, certified-payroll]
part_of: payroll/adp-api-responses/INDEX.md
---

# Departments code list — and what the cost-numbers `204` means

**Captured 2026-08-13** against production, company `4RZ`.

```
GET /codelists/hr/v3/worker-management/departments/WFN/1?companyCode=4RZ    → 200
GET /codelists/hr/v3/worker-management/cost-numbers/WFN/1?companyCode=4RZ   → 204 No Content
```

---

## The 204 is the finding

`204 No Content` is **not an error**. The request was valid, authenticated and authorised —
ADP is stating there is no data.

**Correction (2026-08-18, from the WFN Validation Tables report):** TCG *does* have four cost
numbers — `G1L1`, `G1L2`, `G2L1`, `G2L2` (grade × level placeholders) — but they carry **no
company code**, so the `?companyCode=4RZ` filter excludes them and the API answers `204`. Call
`cost-numbers` without the company filter to see them. They are not used for job attribution;
the department conclusion below still stands. See
[validation-tables-report-2026-08-18.md](validation-tables-report-2026-08-18.md).

~~TCG has no cost numbers defined in ADP.~~ It allocates by department.

The absence under `4RZ` is configuration rather than an unpopulated table. The Payroll Data Input
guide requires, for cost-number allocation:

> `Setup > Payroll > Company Options > Labor Distribution` → **Cost Number**
> `Setup > Payroll > Company Options > Allocations` → **Cost Number**

Departments returning data while cost numbers return nothing indicates TCG's Labor Distribution
is set to **Department**.

### What that changes in the build

| | Assumed | Actual |
| --- | --- | --- |
| `payAllocation/allocationID` | `2` — Temporary Cost Number | **`3` — Temporary Department** |
| Postman request | `5 … Temp Allocation Cost Number` | **`6 … Temp Allocation Department`** |
| Environment variable | `costNumberCodeValue` | **`departmentCodeValue`** |

---

## The 12 departments

| `codeValue` | `shortName` |
| --- | --- |
| `ACTDEP` | Accounting Dep |
| `DISDEP` | Dispatch Dep |
| `MECDEP` | Mechanics Dep |
| `MNGDEP` | Management Dep |
| `ODRDEP` | Oilers / Drivers Dep |
| `OPRDEP` | Operators Dep |
| `PPEDEP` | **Field** |
| `SADMIN` | SALARY ADMIN |
| `SAFDEP` | Safety Dep |
| `SALOFF` | OFFICER |
| `SLSDEP` | Sales Dep |
| `YRDDEP` | YARD |

All carry `foreignKey: "4RZ"`. The equivalent list for the Ventura company `4RY` has not been
pulled.

---

## These are org units, not jobs

**This is the consequential part.** Twelve departments describe *what kind of worker* absorbed
the hours — Operators, Oilers/Drivers, Mechanics, Yard, Field. They do not identify **which
job**, and TCG runs far more jobs than twelve.

Two conclusions follow.

### 1. Certified payroll cannot come from ADP

Davis-Bacon reporting needs hours attributed to a **specific job site**, per worker, with the
worker's classification. ADP's allocation dimension for TCG carries neither — the department is
an org unit and the craft never reaches ADP at all
([../adp-integration-capabilities.md](../adp-integration-capabilities.md)).

Combined with the finding that ADP's Payroll Output APIs are not sold to Workforce Now clients,
**certified payroll is unambiguously an ERP report**. It is not an ADP export and not a
connector. This closes an assumption that both architecture drafts left open.

### 2. The department list mirrors the Payroll Groups — imperfectly

`OPRDEP` / `ODRDEP` / `PPEDEP` / `MECDEP` map recognisably onto the field and mechanic
populations, and `SADMIN` / `SALOFF` onto salaried admin. But the vault's five Payroll Groups
([../INDEX.md](../INDEX.md)) are derived from **`CraftCode` prefix plus `EmpTypeID` plus
`PayType`**, not from department. Nothing states how the two relate, and **the ERP must not infer
a Payroll Group from an ADP department** — the derivation rule is already written and does not
mention departments.

---

## The open decision

TCG could switch Labor Distribution to **Cost Number** and mint cost numbers **as job numbers**.
The Postman collection already carries the write endpoint —
`Add new code to a validation table - Cost Centers`
(`POST /hcm/v1/validation-tables/cost-centers`) — so the ERP could create one per job as jobs
are opened, giving ADP true job-level attribution.

**That is a company-wide Workforce Now payroll configuration change**, affecting every existing
labour-distribution report and any historical comparison. It belongs to Payroll, not to
development. Recorded in [payroll/gaps.md](../gaps.md).

> **Naming caution.** The code-list path says **`cost-numbers`**; the validation-table write
> endpoint says **`cost-centers`**. ADP uses both words. Do not assume they address the same
> table until one has been observed returning the other's values.
