---
title: Live ADP API responses - captured index
source: live-api/TCG ERP Integration project, ADP API Central
migrated: 2026-08-13
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, adp, reference-data]
entities: [adp-api, adp-code, adp-company-code, code-list]
---

# Live ADP API responses

> **Validity caveat (2026-08-24):** everything here is keyed to **classic WFN**. TCG reports a planned upgrade to WFN **Next Generation** ("soon", undated — Patrick). Re-validate this document when the upgrade lands.


**What this folder is:** actual responses from TCG's production ADP Workforce Now tenant,
captured through the `TCG ERP Integration` API Central project from **2026-08-13** onward.

**Why it exists as its own folder:** everything else under `payroll/` describes what TCG *intends
to send* ADP. This folder records what ADP *actually accepts and returns*. Where the two
disagree, **these files win** — they are observations of the live system, not design intent.

They also do something no document could: ADP shipped its Postman collection with **zero saved
example responses**, so the response shapes are otherwise unrecorded anywhere.

## Files

| File | What it captures |
| --- | --- |
| [pay-data-input-meta.md](pay-data-input-meta.md) | **The live code table.** 52 earning codes, 65 deduction codes, 16 memo codes, company codes, allocation types, field requirements. The single most load-bearing file here |
| [codelist-departments.md](codelist-departments.md) | The 12 departments, and why `cost-numbers` returning `204` decides how job attribution works |
| [validation-tables-report-2026-08-18.md](validation-tables-report-2026-08-18.md) | **WFN "Validation Tables" report (UI, 2026-08-18)** — every code TCG actually holds: 12 departments, 4 cost numbers (no company code → the `204`), 10 job titles, locations `DEF`/`VEN`, 18 worker categories incl. `APP`/`L12`, 65 deductions, hire/termination/comp-change/job-change reason codes (`NEW`, `CURR`, `L12 CT`, `PAYCH`…), tax jurisdictions |
| [codelist-worker-management.md](codelist-worker-management.md) | `union-codes`, `locations`, `business-units`, `eligibility-classes`, `job-titles`. **Also holds the only observed ADP error envelope** — the shape the ERP's error handling must be written against |
| [workers-meta.md](workers-meta.md) | The worker schema. **Every field is read-only**, the File Number regex the crosswalk gets wrong, and the `$select` lever that keeps PII out of the ERP |
| [workers-list.md](workers-list.md) | Real worker records. **No pay rates are returned**, `occupationalClassifications` turns out to be workers' comp, and union membership is recorded two ways that disagree |
| [pay-schedule.md](pay-schedule.md) | The pay calendar. **Saturday-Friday confirmed against production**, `payPeriodID` as the batch key, and why `OPEN` does not mean ADP will accept a batch |
| [codelist-endpoint-catalog.md](codelist-endpoint-catalog.md) | Every valid `{code-type}`, and what `{version-id}` means — the answer the Postman collection does not give |

## What these responses resolved

| Was open | Now |
| --- | --- |
| **D-001** — is the company code `631` or `4RZ`? | **`4RZ`.** `631` is not a company code at all. There is also a second company, **`4RY` Ventura**, previously unknown |
| **D-001** — do `LP*`, `LO*`, `S2*`, `S3*`, `LBT` exist? | **All present.** The June export was partial; the blocking status can drop |
| **D-006** — do `HDD`/`HOL` mean Holiday Double/Triple? | **Yes**, per ADP's own `longName` |
| Military Base premium ADP codes | **`MLR`/`MLO`/`MLD`/`MLT` already exist** — never supplied to CodingCops |
| Can ADP carry job-level attribution? | **No.** TCG allocates by department; 12 org units, not jobs |
| Can craft classification come from ADP? | **No.** 10 job titles against 9 union groups plus apprentice steps — `OPERATOR` alone collapses six groups spanning $3.29/hour |
| Can home yard come from ADP? | **No.** Two locations, one named `DEFAULT`. Subsistence eligibility must be ERP-side |
| Can certified payroll come from ADP? | **No.** No job, no craft, and payroll-output APIs are not sold to WFN clients |
| Is the pay period really Saturday-Friday? | **Yes — verified in production.** 27 consecutive periods, every one Sat->Fri, pay date the following Thursday |
| Does Ventura `4RY` need its own batch? | **No.** It has no payroll schedules at all, so it cannot run payroll |
| Does the event-notification queue exist? | **Yes — `204`, not `403`.** The polling mechanism is entitled and reachable; it is simply empty. Whether anything ever arrives is still open |
| What does an ADP error body look like? | **There are two, and they are incompatible.** The code-list family carries a machine-readable `processMessageID`; the pay-schedule family has `messageCode: null` and only prose. See [pay-schedule.md](pay-schedule.md) §6 |

## What they raised

- **Ventura (`4RY`)** — an entire second company absent from every payroll document
- **`CAO — CA OT`** — a dedicated California OT code exists, while the crosswalk reuses generic OT
- **Code collisions** — `LPR`, `LPO`, `ONC`, `SUB` mean different things in the earning vs
  deduction arrays, and a mistake returns `200 OK`
- **Cost-number vs department allocation** — a Workforce Now configuration decision that belongs
  to Payroll

All recorded in [payroll/gaps.md](../gaps.md).

## Conventions for adding to this folder

One file per endpoint. Record the **exact request** including query parameters, the **date**, and
the **company code**, because every list here is company-scoped. Note the HTTP status explicitly
when it is not `200` — the `204` on `cost-numbers` carried more information than most `200`s.

**Never paste credentials.** No `client_secret`, no token, no certificate or key material. Worker
responses contain personal data — record the *shape* and the identifier fields the ERP needs, not
the roster.

## Related

- [../adp-integration-capabilities.md](../adp-integration-capabilities.md) — what the ADP API
  permits, and the architecture verdict
- [../adp-bucket-crosswalk.md](../adp-bucket-crosswalk.md) — ERP component to ADP code mapping,
  written against the Excel import
- [../adp-hour-earning-codes.md](../adp-hour-earning-codes.md) — the superseded 2026-06-04 CSV
  export
- [../foreman-and-military-premiums.md](../foreman-and-military-premiums.md) — the premiums whose
  codes these responses confirm
