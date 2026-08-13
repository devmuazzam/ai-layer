---
title: Live ADP responses — union-codes, locations, business-units, eligibility-classes, job-titles
source: live-api/GET https://api.adp.com/codelists/hr/v3/worker-management/{code-type}/WFN/1
migrated: 2026-08-13
updated: 2026-08-13
status: reference
conflicts_with: []
jira: []
topics: [payroll, adp-integration, adp-api, reference-data, union-rules, craft-code]
entities: [adp-code, union-code, job-title, location, craft-code, adp-company-code]
part_of: payroll/adp-api-responses/INDEX.md
---

# Worker-management code lists — the remaining five

**Captured 2026-08-13**, production, `hr/v3/worker-management`.

> **These were called *without* `?companyCode=`.** None of the returned items carries a
> `foreignKey`, whereas [departments](codelist-departments.md) — called *with* `companyCode=4RZ` —
> tagged every item `foreignKey: "4RZ"`. **The likeliest reading is that these lists are
> tenant-wide rather than company-scoped**, but that is inference, not observation. Re-running any
> of them with `?companyCode=4RY` would settle it, and matters because Ventura is a real second
> company.

| `{code-type}` | Result |
| --- | --- |
| `union-codes` | `200` — **1 value** |
| `locations` | `200` — **2 values** |
| `business-units` | **`204 No Content`** — unconfigured |
| `eligibility-classes` | **`403 API_AccessDeniedFeature`** — not an empty table, a denied entitlement |
| `job-titles` | `200` — **10 values** |

---

## `union-codes` — exactly one

| `codeValue` | `shortName` |
| --- | --- |
| `L12` | Local 12 |

**One union. This settles two things.**

**1. Union code cannot distinguish Field from Mechanic.** The vault defines five Payroll Groups,
two of which are `L12 Labor Union Field` and `L12 Labor Union Mechanic`
([payroll-app-current-state/04](../payroll-app-current-state/04-payroll-group-and-rule-applicability.md)).
Both would carry union code `L12`. The split comes from **`Employee.EmpTypeID = 3`**, and the
derivation rule already says so — this confirms there is no alternative source. **Do not attempt
to derive a Payroll Group from ADP's union code.**

**2. The open product question shrinks.**
[discussion-points-with-tcg-team.md](../../product/discussion-points-with-tcg-team.md) asks:

> "Need to think if we need to give ability to add Union codes"

With exactly one union code in existence, a CRUD screen for union codes is close to pointless.
The real question is narrower: does the ERP master `L12`, or read it from ADP? Given it never
changes, hard configuration is defensible.

Consistent with the memo code `L12 — local 12 dues` in
[pay-data-input-meta.md](pay-data-input-meta.md).

## `locations` — two, and neither is a yard

| `codeValue` | `shortName` |
| --- | --- |
| `DEF` | DEFAULT LOCATION |
| `VEN` | **Ventura** |

**ADP locations are not TCG yards.** [FRD 02](../erp-payroll-module-frd/02-payroll-period-and-source-data.md)
requires **"Home yard or reporting location"** on the employee master, and **PR-048 Standard
Subsistence** turns on *home yard, job, distance, overnight and equipment status*. Two values —
one of them literally named "DEFAULT" — cannot express that.

**Consequence: subsistence eligibility cannot be sourced from ADP.** Home yard must live in the
ERP. Add it to the list of things ADP does not carry, alongside craft and job.

### Ventura now appears in two different shapes

| Representation | Value |
| --- | --- |
| Company code | `4RY` — The Crane Guys, LLC - Ventura |
| Location | `VEN` — Ventura |

Two parallel encodings of the same place, and **`business-units` returned `204`**, so it is not a
business unit. Which of the two ADP actually uses for Ventura workers — separate company, or a
location within `4RZ` — is unresolved and matters: the company code is a **required** field on
every pay-data submission, so the ERP must choose one per batch.

## `business-units` — `204`, unconfigured

Empty, exactly as `cost-numbers` was. TCG does not use business units. Nothing in the vault
referenced them, and now nothing needs to.

## `eligibility-classes` — `403`, and the most useful response of the five

```json
"processMessageID": { "idValue": "API_AccessDeniedFeature" },
"messageTypeCode":  { "codeValue": "error" },
"userMessage":      { "messageTxt": "You do not have access to this feature." }
```

**This is an entitlement denial, not an empty table.** `204` says "TCG has none of these";
`403 API_AccessDeniedFeature` says "this API Central project is not licensed for this". The
project was created against the **Payroll Input (Read/Write)** use case; eligibility classes are
benefits data, which sits under a different use case. It says nothing about TCG's configuration.

### It also gives us the error envelope ADP never documented

The Postman collection ships **zero saved responses**, and the Payroll Data Input guide only ever
quotes a bare `messageText`. This is the first complete ADP error body observed, and the ERP's
error handling should be written against **this** shape:

```
confirmMessage
├── confirmMessageID.idValue          ← GUID, unique per request
├── createDateTime / requestReceiptDateTime
├── protocolStatusCode.codeValue      ← "403"  (HTTP status, echoed in the body)
├── requestStatusCode.codeValue       ← "failed"
├── requestMethodCode.codeValue       ← "GET"
├── sessionID.idValue
├── requestETag
├── requestLink.href                  ← the resolved internal URL
└── resourceMessages[]
    ├── resourceMessageID.idValue     ← the endpoint path
    ├── resourceStatusCode.codeValue  ← "failed"
    └── processMessages[]
        ├── processMessageID.idValue  ← "API_AccessDeniedFeature"  ← the machine-readable code
        ├── messageTypeCode.codeValue ← "error"
        └── userMessage.messageTxt    ← human text
```

Three things worth acting on:

- **`processMessageID.idValue` is the machine-readable error code.** Branch on that, never on
  `userMessage.messageTxt`, which is prose and will change.
- **`confirmMessageID.idValue` is a per-request GUID** — the closest thing ADP offers to a support
  correlation id. Log it on every failure. Note it appears on *failures*; whether a `200` on
  `pay-data-input.modify` returns one is **still untested** and worth checking, because if it does
  it would partly answer the "no receipt" problem.
- **`requestLink.href` leaks an internal ADP host** (`pulsar-marketplace-prod.es.oneadp.com`).
  Do not persist or display it.

## `job-titles` — 10, and they are not craft

| `codeValue` | `shortName` |
| --- | --- |
| `ACCOUNTG` | Accounting |
| `ADM` | ADMINISTRATOR |
| `DISPATCH` | Dispatch |
| `MECHANIC` | Mechanic |
| `MNGMT` | Management |
| `OILDRV` | Oilers / Drivers |
| `OPERATOR` | Operator |
| `SAFETY` | Safety |
| `SALES` | Sales |
| `YARD` | Yard |

### They near-duplicate the departments

| Job title | Department |
| --- | --- |
| `ACCOUNTG` | `ACTDEP` Accounting Dep |
| `DISPATCH` | `DISDEP` Dispatch Dep |
| `MECHANIC` | `MECDEP` Mechanics Dep |
| `MNGMT` | `MNGDEP` Management Dep |
| `OILDRV` | `ODRDEP` Oilers / Drivers Dep |
| `OPERATOR` | `OPRDEP` Operators Dep |
| `SAFETY` | `SAFDEP` Safety Dep |
| `SALES` | `SLSDEP` Sales Dep |
| `YARD` | `YRDDEP` YARD |
| `ADM` | `SADMIN` / `SALOFF` |
| — | **`PPEDEP` Field** |

Two parallel taxonomies of the same distinction. Only `PPEDEP — Field` has no job-title
counterpart. **The ERP should treat them as one concept with two ADP encodings**, not as
independent attributes, or they will drift.

### ⚠ `job-titles` is not a substitute for craft code

ADP has **one** `OPERATOR`. The Local 12 agreement has **six** operator classifications, priced
differently:

| Union group | Classification | 7/1/2025 rate |
| --- | --- | --- |
| Group 3 | Operator — up to 40 tons | $67.87 |
| Group 4 | Operator — over 40 to 80 ton | $67.99 |
| Group 6 | Operator — over 80 to 200 ton | $68.41 |
| Group 7 | Operator — over 200 to 350 ton | $68.66 |
| Group 8 | Operator — over 350 to 550 ton | $69.16 |
| Group 9 | Operator — over 550 ton | $71.16 |

A $3.29/hour spread collapsed into a single ADP value. Same for `OILDRV`, which spans Groups 1
and 2. And nothing here expresses apprentice steps, craft modifiers, or boom tiers.

**This closes the question definitively: craft classification cannot be sourced from, stored in,
or reconciled against ADP.** It lives in `FMS_UNION_CRAFT` and must move to the ERP. See
[../adp-integration-capabilities.md](../adp-integration-capabilities.md).

---

## Summary — what ADP does and does not carry

| TCG payroll concept | In ADP? |
| --- | --- |
| Union membership | ✅ one code, `L12` |
| Field vs Mechanic split | ❌ derive from `EmpTypeID` |
| Craft code / union group | ❌ **10 job titles vs 9 groups + apprentices + modifiers** |
| Craft modifier / boom tier | ❌ |
| Home yard / reporting location | ❌ 2 locations, one named DEFAULT |
| Job / job site | ❌ 12 departments are org units |
| Department attribution | ✅ `allocationID: 3` |
| Benefits eligibility class | ⚠ `403` — different use case, unknown |
| Business unit | ❌ unconfigured |
