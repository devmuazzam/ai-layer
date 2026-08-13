---
title: ADP code-list endpoints — the authoritative {code-type} catalog
source: adp/Validation Table Code List API Guide for ADP Workforce Now
migrated: 2026-08-13
updated: 2026-08-13
status: reference
conflicts_with: []
jira: []
topics: [payroll, adp-integration, adp-api, reference-data, code-lists]
entities: [adp-code, adp-api, code-list, validation-table]
part_of: payroll/adp-api-responses/INDEX.md
---

# ADP code-list endpoints — where `{code-type}` comes from

**The question this file answers:** the Postman collection ships
`GET /codelists/hr/v3/worker-management/{code-type}/WFN/{version-id}` with both path variables
unfilled, and nothing in the collection, the meta response, or the Payroll Data Input guide
enumerates the valid values.

**The authority is a different ADP document:** the *Validation Table Code List API Guide for
ADP Workforce Now*. It is not the Payroll Data Input guide, and it is the only place the full
set is written down.

> `https://marketplace-cdn.adp.com/dev-portal/pdf/protected/Validation_Table_Code_List_API_Guide_for_ADP_Workforce_Now`

Each entry below is one validation table in the Workforce Now UI. **`{code-type}` is the table
id** — so the list of code-types is the list of validation tables, and it grows when ADP adds
one.

---

## The three URL families

They are **not** interchangeable, and the casing differs between them. Copying a path from one
family into another returns 404.

| Family | Path shape | Casing |
| --- | --- | --- |
| Worker management v3 | `/codelists/hr/v3/worker-management/{code-type}/WFN/1` | **upper** `WFN` |
| Worker management v4 | `/codelists/hr/v4/worker-management/{code-type}/wfn/1` | lower `wfn` |
| Payroll instruction v4 | `/codelists/payroll/v4/payroll-instruction-management/{code-type}/wfn/1` | lower `wfn` |

`{version-id}` is **`1`** in every documented example — see *What version-id means* below.

---

## `hr/v3/worker-management` — upper-case `WFN`

**The two that Payroll Data Input actually consumes are `cost-numbers` and `departments`.**
Both are named explicitly in the Payroll Data Input guide's data dictionary, against the
`payAllocation/allocationTypeCode/codeValue` field.

| `{code-type}` | What it is |
| --- | --- |
| **`cost-numbers`** | **Temporary Cost Number** — job/cost attribution. **Returns `204` for TCG**, see [codelist-departments.md](codelist-departments.md) |
| **`departments`** | **Temporary Department Number** — the allocation dimension TCG actually uses |
| `business-units` | Business units |
| `eligibility-classes` | Benefit eligibility classes |
| `locations` | Work locations |
| `union-codes` | **Union codes** — returns exactly one value, `L12` |
| **`union-locals`** | **"Union Local"** — backs `workAssignments/bargainingUnit/bargainingUnitCode`. **Not listed in any ADP guide**; discovered from a `codeList.links` entry in [workers-meta.md](workers-meta.md). Untested |
| `job-titles` | Job titles — 10 values, **not craft** |

## `hr/v4/worker-management` — lower-case `wfn`

| `{code-type}` | What it is |
| --- | --- |
| `worker-category` | Worker category |
| `status-change-reason` | Status change reasons |
| `countries` | Country codes |
| `languages` | Languages |
| `job-function` | Job function |
| `e-verify-work-locations` | E-Verify work locations |
| `eeo-establishments` | EEO establishments |
| `onboard-experience` | Onboarding experience |
| `naics-worker-compensation` | NAICS workers-comp mapping |
| `worker-compensation-status` | Workers-comp status |
| `worker-compensation-type` | Workers-comp type |
| `worker-compensation-class-code-type` | Workers-comp class code type |

Two v4 paths sit outside `worker-management` and take no code-type at all:
`/codelists/hr/v4/worker-status/wfn/1` and `/codelists/hr/v4/worker-territory/wfn/1`,
plus `/codelists/hr/v4/worker-compensation/wfn/1`.

## `payroll/v4/payroll-instruction-management` — lower-case `wfn`

This is the family behind the collection's request named **`Scenario 1 - Data Control API`**
(`{code-type}` = `data-control`).

| `{code-type}` | What it is |
| --- | --- |
| `data-control` | Data Control codes — `Setup > Payroll > Other Pay Settings > Data Control` |
| `payroll-clock` | Clock codes. Note: **Clock is not settable via the Payroll Data Input API** (Appendix B) |
| `pay-groups` | Pay groups |
| `legal-entity` | Legal entities |
| `wage-entities` | Wage entities |
| `currencies` | Currencies — **not client-configurable** |
| `state-tax-jurisdictions` | State tax jurisdictions |
| `state-tax-marital-status` | State tax marital status |
| `local-tax-jurisdictions` | Local tax jurisdictions |
| `local-services-tax-jurisdictions` | Local services tax jurisdictions |
| `sui-sdi-tax-jurisdictions` | SUI/SDI tax jurisdictions |
| `ohio-school-district-tax-jurisdictions` | Ohio school districts |
| `canada-tax-province` | Canadian tax provinces |

Also documented in the same guide, outside the codelist families:
`/codelists/hr/v4/worker-management/new-york-metro-tax-jurisdictions/…` and the deduction
configuration endpoint surfaced in the meta response's `links` block —
`GET https://api.adp.com/payroll/v3/deduction-configurations`.

---

## What `version-id` means

**It is ADP's version of the code-list *definition*, not a version of TCG's data and not
something TCG sets.** Note that two versions appear in one path: `v3`/`v4` is the API version,
the trailing `1` is the code-list version.

Every example in every ADP guide uses **`1`**. No ADP document available to this vault
enumerates other values or describes when the number changes. Treat `1` as the value; if a call
ever returns 404 on an otherwise-correct path, the version is the first thing to ask ADP about.

## Filtering by company code — two different conventions

**This is a real trap.** The two families do not filter the same way.

| Family | How to scope to a company |
| --- | --- |
| `hr/v3/worker-management` | **`?companyCode=4RZ`** — as instructed by the pay-data meta response: *"Please use parameter companyCode to retrive all available codes"* |
| `payroll/v4/payroll-instruction-management` | **`?$filter=category eq '4RZ'`** — an OData filter on `category`, per the Validation Table guide |

Getting this wrong tends to return the unfiltered list rather than an error, so a wrong filter
looks like a working call.

---

---

## Response shapes — ADP is not internally consistent

Observed across the calls made on 2026-08-13. **A single generic client will not work.**

### Three different ways of saying "nothing"

| Pattern | Endpoints observed | Meaning |
| --- | --- | --- |
| **`204 No Content`**, empty body | `cost-numbers`, `business-units`, `core/v1/event-notification-messages` | Entitled, reachable, **no data** |
| **`200`** with `"listItems": []` | `payroll/v4/…/data-control` | Entitled, reachable, **no data** |
| **`403`** + `API_AccessDeniedFeature` | `eligibility-classes` | **Not entitled** — says nothing about the data |

The first two mean the same thing and are returned differently by different families. The third
means something else entirely. **The ERP must distinguish `403` from the other two** — one is a
licensing problem to escalate, the others are just empty tables.

### Two different success envelopes

`hr/v3/worker-management` wraps its payload in an array:

```json
{ "codeLists": [ { "codeListTitle": "departments", "listItems": [ … ] } ] }
```

`payroll/v4/payroll-instruction-management` returns a **bare object with no wrapper**:

```json
{ "codeListTitle": "Data Control", "listItems": [] }
```

Same conceptual resource, two structures. Add `/hr/v2/workers` — which returns
`{ "workers": […], "meta": null, "confirmMessage": null }` — and
`/payroll/v1/pay-schedule/...` — which returns `{ "payrollGroupsPayPeriods": […] }` with no
envelope at all — and there are four shapes across six endpoints.

Error envelopes differ too; see
[pay-schedule.md](pay-schedule.md) §6.

**Design consequence:** write a thin per-family adapter, not one shared response parser. The cost
of getting this wrong is a client that silently reads `undefined` and treats a populated list as
empty.

### `data-control` — TCG has none

```json
{ "codeListTitle": "Data Control", "listItems": [] }
```

Data Control codes *"identify employees for special reasons"*
(`Setup > Payroll > Other Pay Settings > Data Control`). TCG has configured none. Nothing in the
vault referenced them, and nothing needs to.

---

## What is *not* here

**No Hours & Earnings code-type exists in any family.** Earning codes are readable only through
the Payroll Data Input `/meta` call ([pay-data-input-meta.md](pay-data-input-meta.md)), and are
creatable only by hand in the Workforce Now UI at
`Setup > Tools > Validation Tables > Payroll > Paydata > Hours & Earnings Codes`.

**No craft code-type.** Consistent with craft being an FCC/ERP concept that never reaches ADP —
see [../adp-integration-capabilities.md](../adp-integration-capabilities.md).

**No discovery endpoint.** There is no call that lists valid code-types. This file, and the ADP
guide it came from, are the only enumeration.
