---
title: Live ADP response — /hr/v2/workers/meta (the worker schema)
source: live-api/GET https://api.adp.com/hr/v2/workers/meta
migrated: 2026-08-13
updated: 2026-08-13
status: reference
conflicts_with: []
jira: []
topics: [payroll, adp-integration, adp-api, employee-master, reference-data, privacy]
entities: [employee, adp-api, worker, craft-code, adp-file-number, payroll-group]
part_of: payroll/adp-api-responses/INDEX.md
---

# Worker schema — `/hr/v2/workers/meta`

**Captured 2026-08-13**, production. No `companyCode` parameter.

This is ADP's complete worker record definition: every field the ERP could read, its validation
rules, and which code list backs it.

---

## 1. Every field is `readOnly: true`

**Every single one.** `associateOID`, `payrollFileNumber`, names, dates, assignments, rates —
all `readOnly: true`.

This settles the employee-sync direction **at the schema level**, not by inference. The ERP
cannot create or update a worker in ADP through this API. Hiring happens in ADP; the ERP reads.
See [../adp-integration-capabilities.md](../adp-integration-capabilities.md).

## 2. ⚠ `payrollFileNumber` — the crosswalk rule is wrong

```
shortLabelName: "File Number"
maxLength: 6
pattern: ^0*(5[1-9]|[6-9][0-9]|[1-9][0-9]{2,5})$
```

Two corrections to [../adp-bucket-crosswalk.md](../adp-bucket-crosswalk.md) implementation
rule 8, which states the File Number *"allows uppercase alphanumeric characters"*:

1. **Digits only.** The pattern admits no letters at all. An alphanumeric File Number will be
   rejected.
2. **Minimum value is 51.** Reading the alternation: `5[1-9]` = 51–59, `[6-9][0-9]` = 60–99,
   `[1-9][0-9]{2,5}` = 100–999999. **Numbers 1–50 are invalid** — presumably reserved by ADP.

Leading zeros are permitted (`0*`) and do not count toward the 6-character limit, so `000123`
and `123` both pass. The crosswalk is right that leading zeros must be preserved as text.

**The ERP must validate File Numbers against this regex before submitting**, or the batch fails
with `payrollFileNumber:NNNN is invalid` and no indication of which rule was broken.

## 3. `$select` is supported — use it

`queryCriteria` declares OData `$select` over ~130 resource paths, and `$filter` over four.

**The ERP should never fetch whole worker records.** The join key is two fields:

```
GET /hr/v2/workers?$select=workers/associateOID,workers/workAssignments/payrollFileNumber
```

Everything else in this schema is personal data the ERP has no reason to hold — SSN
(`person/governmentIDs`, pattern `\d{9}`), birth date, home address, race, gender, marital
status, military status, personal email and phone. Pulling it "because it was in the response"
would be a data-protection failure with no functional benefit.

**Filterable fields** (`$filter`): `workAssignments/reportsTo/positionID`,
`homeOrganizationalUnits/nameCode/codeValue`, `homeOrganizationalUnits/typeCode/codeValue`,
`assignmentStatus/statusCode/codeValue`.

That last one is how the ERP scopes to current employees:

| Code | Meaning |
| --- | --- |
| `A` | Active |
| `L` | Leave |
| `T` | Terminated |
| `D` | Deceased |

## 4. ⚠ The meta response itself contains personal data

The `$filter` criteria for `reportsTo/positionID` enumerate **11 named supervisors** with their
position IDs — real employee names, returned by a call that looks like pure schema.

**Not recorded here**, per this folder's convention. Two structural facts are worth keeping:

- **`positionID` format is `4RZ` + six digits** — the company code is embedded in the identifier.
  Pattern on the field: `^[A-Z0-9]+$`.
- **One of the eleven cross-references a person already in this vault** — a supervisor who
  appears in the [2026-08-07 Labor Compliance minutes](../../meetings/2026-08-07-labor-compliance-certified-payroll.md).
  Useful to know the org chart is reachable; not a reason to copy it.

Anyone sharing meta responses should treat them as containing PII, not just structure.

---

## 5. Fields that matter to payroll rules

### `wageLawCoverage/coverageCode` — the FLSA flag

| Code | Meaning |
| --- | --- |
| `E` | Exempt |
| `N` | Non-exempt |

Labelled **"FLSA Code"**. This is the exempt/non-exempt determination the requirements document
needs for the `Non-Union Admin Salary` review path and the California non-exempt overtime rules
([../erp-payroll-module-frd/08-non-union-apprentice-and-fringe.md](../erp-payroll-module-frd/08-non-union-apprentice-and-fringe.md)).
The vault derives it from `Employee.PayType`; **ADP holds an explicit flag.** Whether they agree
is unverified and worth checking against real records.

### `workerTypeCode` — "Worker Category", and it carries `APP`

18 values: `1099` `APP` `CAS` `CONS` `CONT` `CT3P` `EX` `F` `INTR` **`L12`** `P` `RA` `RET`
`SL` `SM` `ST` `TEMP` `TR`.

Two are load-bearing:

- **`APP — Apprentice`.** The MLA prices apprentices as Steps I–VI at 60/65/70/75/80/90% of the
  Group 5 rate. This is the only ADP field found so far that distinguishes an apprentice — but
  it is a **boolean-ish category, not a step**. The step (and therefore the percentage) is not
  representable. Apprentice rate determination stays ERP-side.
- **`L12 — Local 12`** appears here *as well as* in `laborUnion/laborUnionCode`. Two fields can
  say the same thing, which is exactly how they drift.

### `payCycleCode` — "Pay Frequency", `optional: false`

`W` Weekly, `B` Biweekly, `S` SemiMonthly, `M` Monthly, `D` Daily, plus twelve unusual cycles.
Required on every assignment. Confirms weekly at the worker level, alongside the vault's
Saturday–Friday period.

### `premiumRateMultipliers` — new, and unexplained

```
workAssignments/premiumRateMultipliers/premiumRateMultiplierItem/rateMultiplier
workAssignments/premiumRateMultipliers/premiumRateMultiplierItem/premiumRateTypeCode
```

**A per-worker rate multiplier, held in ADP.** Nothing in the vault mentions worker-level
multipliers — every multiplier in the payroll design (1.5x OT, 2x DT, 3x TRI) is a *rule*
outcome computed by the ERP, not an employee attribute.

If TCG has populated these, two systems are holding multiplier logic and the ERP's output could
be multiplied twice. **Check whether any worker has a value here before designing the OT/DT
calculation.** Recorded in [../../gaps.md](../../gaps.md).

### `occupationalClassifications` — the last craft candidate

`minItems: 0, maxItems: 2`, with `nameCode` and `classificationCode`. **No inline code list**, so
the values are unknown until real records are read.

This is the one field left that could plausibly carry a craft or Davis-Bacon classification.
`maxItems: 2` is suggestive — a worker could hold two. Given that
[job titles collapse six union operator groups into one value](codelist-worker-management.md),
this is worth checking explicitly rather than assuming.

Alongside it, `industryClassifications` (also `maxItems: 2`) — likely NAICS, relating to the
`naics-worker-compensation` code list.

---

## 6. Org units — up to four per worker

`homeOrganizationalUnits`, `minItems: 0, maxItems: 4`, with `typeCode`:

| `codeValue` | `shortName` |
| --- | --- |
| `Department` | Home Department |
| `Business Unit` | Business Unit |
| `Cost Number` | Home Cost Number |
| `Location` | Location |

**`Cost Number` exists as an org-unit type even though the cost-numbers code list returns
`204`** ([codelist-departments.md](codelist-departments.md)). The type is available; TCG has not
populated it. That supports the reading that this is configuration, not an ADP limitation — and
that switching Labor Distribution to Cost Number is a live option.

### The company-scoping mechanism, stated by ADP

The `Department` branch links to:

```
/codelists/hr/v3/worker-management/departments/WFN/1?$filter=foreignKey eq {payrollGroupCode}
```

So the canonical way to scope a `hr/v3` code list to a company is **`$filter=foreignKey eq '4RZ'`**,
not `?companyCode=`. Both appear to work — the pay-data meta instructs `companyCode`, this
instructs `$filter` — but this is ADP's own templated form. Note that `Business Unit` and
`Location` link **unfiltered**, which matches those lists being tenant-wide.

## 7. Two code-list endpoints the guide never listed

Discovered through `codeList.links` in this response:

| Field | Endpoint |
| --- | --- |
| `bargainingUnit/bargainingUnitCode` — **"Union Local"** | `/codelists/hr/v3/worker-management/union-locals/WFN/1` |
| `workerGroups/groupCode` | `/codelists/hr/v3/worker-management/eligibility-classes/WFN/1` |

**`union-locals` appears in no ADP guide available to this vault** — the Validation Table Code
List guide does not list it. Add it to
[codelist-endpoint-catalog.md](codelist-endpoint-catalog.md)'s known set. It is distinct from
`union-codes`, and given the vault's constant references to *Local 12*, worth calling.

The second confirms **`workerGroups` is backed by eligibility classes** — the code list that
returned `403 API_AccessDeniedFeature`. So `workerGroups` will likely be unreadable for this
project too.

---

## 8. What is present but unused by TCG

- **`payGradeCode`** — code list contains a single blank entry. Pay grades unconfigured.
  `payGradePayRange` (min/mid/max) therefore carries nothing.
- **`workerTimeProfile`** — `badgeID`, `timeAndAttendanceIndicator`, `blackoutCalendarID`,
  `timeServiceSupervisor`, `timeZoneCode`. ADP Time & Attendance fields. TCG captures labour in
  the Atom mobile app, so these should be empty — worth confirming, because a populated
  `timeAndAttendanceIndicator` would mean a second time system exists.
- **`tippedWorkerIndicator`**, `wageEntityID`, `customFieldGroup` (amount/code/date/indicator/
  number/percent/string/telephone — all generic, all unlabelled here).

`timeZoneCode` includes `PST — America/Los_Angeles`, consistent with a California employer.

---

## What ADP holds about a worker, against what payroll needs

| Payroll requirement (FRD 02) | In ADP? |
| --- | --- |
| ADP File Number | ✅ `payrollFileNumber` — digits only, ≥51 |
| Union code | ✅ `laborUnion/laborUnionCode` → `L12` |
| Pay type hourly/salary | ✅ `wageLawCoverage/coverageCode` E/N, plus `payCycleCode` |
| Hire / termination date | ✅ `hireDate`, `terminationDate`, `workerDates/*` |
| Apprentice status **and step** | ⚠ category `APP` only — **no step** |
| Employee CraftCode | ❌ |
| Employee Type ID (field vs mechanic) | ❌ |
| Home yard / reporting location | ❌ two locations, one is `DEFAULT` |
| Payroll group | ❌ derived ERP-side from craft + type + pay type |
| Burden / workers' comp codes | ⚠ `occupationalClassifications` unread; `worker-compensation-*` lists unread |
| Eligibility for union rules and fringe | ⚠ `workerGroups` → eligibility classes → `403` |
