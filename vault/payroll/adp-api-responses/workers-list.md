---
title: Live ADP response — /hr/v2/workers (real records, structure only)
source: live-api/GET https://api.adp.com/hr/v2/workers
migrated: 2026-08-13
updated: 2026-08-13
status: reference
conflicts_with: []
jira: []
topics: [payroll, adp-integration, adp-api, employee-master, craft-code, data-quality, privacy]
entities: [employee, worker, adp-file-number, craft-code, payroll-group, union-code]
part_of: payroll/adp-api-responses/INDEX.md
---

# Worker records — what ADP actually holds

**Captured 2026-08-13**, production, company `4RZ`. Roughly 40 records, first page, sorted by
surname.

> **No personal data is recorded in this file.** The response contained full legal names, home
> addresses, personal email addresses and personal mobile numbers for ~40 people, active and
> terminated. Only structure, codes and counts are kept here — see *Privacy* below.

---

## 1. ⚠ No pay rates are returned

`baseRemuneration` comes back with the **shape** but not the money:

```json
"baseRemuneration": {
  "hourlyRateAmount": { "nameCode": {"codeValue": "Hourly"}, "currencyCode": "USD" },
  "annualRateAmount": { "nameCode": {"codeValue": "ANNUAL"}, "currencyCode": "USD" },
  "effectiveDate": "2026-07-01"
}
```

**`amountValue` is absent on every rate, for every worker** — hourly, annual, pay-period salary,
and every `additionalRemunerations` entry (`Rate 2`, `Rate 3`). Currency and effective date come
through; the number does not.

Almost certainly a use-case entitlement boundary: the project is scoped to **Payroll Input**, not
compensation. Same mechanism as the `403` on `eligibility-classes`, expressed as omission rather
than error.

**Consequence for PR-009 Non-Union Hourly Rate.** The requirements document sources the non-union
rate from *"Employee master PayRate"*
([erp-payroll-module-frd/03](../erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md)).
That value is **not readable from ADP**. Union rates were always going to come from the craft
table, but non-union rates now have no upstream source either — they must be mastered in the ERP,
migrated from FCC. Recorded in [payroll/gaps.md](../gaps.md).

`effectiveDate` **is** returned, and is genuinely useful: many active workers show
`2026-07-01`, which is the MLA wage-increase date. That is evidence the 1 July 2026 union
increase was applied, even though the amount is invisible.

## 2. `occupationalClassifications` is workers' comp, not craft

The last craft candidate is now closed. Observed values:

| `nameCode` | `classificationCode` | Seen on |
| --- | --- | --- |
| `NAICS` | `7219` — **Mobile Crane** | operators, oilers/drivers, field |
| `NAICS` | `8810` — **Clerical** | safety, admin |
| `NAICS` | `8742` — **Salesperson** | sales |
| **`Job Class`** | `MG` — **Management** | one management record |

Labelled `NAICS`, but `7219` / `8810` / `8742` are **California workers' compensation class
codes**, not NAICS industry codes. Whatever the label says, this is the burden/WC classification.

**Two consequences:**

1. **It answers a different requirement than expected.** FRD 02 requires *"Burden and workers'
   compensation codes, when needed"* on the employee master — **this is that field**, and it is
   readable. Nobody had connected the two.
2. **It is not craft, and it cannot become craft.** Three values across the whole workforce,
   against nine union groups plus apprentice steps. Craft stays in `FMS_UNION_CRAFT`.

The `Job Class` scheme is a second, sparsely-used classification (`maxItems: 2` allows both).
Seen once. Whether TCG intends to use it is unknown.

## 3. `premiumRateMultipliers` is not populated

**Absent from every record.** The double-multiplication risk flagged from the schema is not live —
ADP is not holding per-worker multipliers. The ERP can own OT/DT/TRI multipliers without
contention.

Worth re-checking if anyone ever configures it, but as of 2026-08-13 the gap is closed.

## 4. ⚠ Union membership is recorded in two fields, inconsistently

Two independent places say "Local 12":

- `workAssignments/workerTypeCode` → `L12 — Local 12`
- `workAssignments/laborUnion/laborUnionCode` → `L12 — Local 12`

Across the sampled records, **all four combinations occur**:

| `workerTypeCode` | `laborUnion` | Occurrences |
| --- | --- | --- |
| `L12` | `L12` | several |
| `L12` | *absent* | several |
| *absent* | `L12` | several |
| *absent* | *absent* | field workers in `PPEDEP` with `OILDRV`/`OPERATOR` job codes |

That last row is the problem: workers who look unmistakably like union field staff — Field
department, Oiler/Driver job code, Mobile Crane WC class — carry **no union marker at all**.

**The ERP cannot determine union membership from ADP.** Neither field is reliable alone, and they
disagree. This reinforces the existing rule: Payroll Group derives from `CraftCode` prefix plus
`EmpTypeID` plus `PayType`, all FCC-side. **Do not sync union membership inbound from ADP** — it
would be wrong for a meaningful fraction of the workforce.

`workerTypeCode` also carries `F — Full Time` on non-union staff, so the field is doing two jobs
at once: employment type *and* union membership, mutually exclusive in one enum.

## 4b. `associateOID` — structured, not random, and easy to confuse

**Format:** 16 characters, uppercase alphanumeric, no hyphens. **Not a UUID.**

**It clusters.** Grouping the ~50 observed AOIDs by their first 12 characters gives shared
prefixes with only the last 4 characters varying:

| Prefix | Workers sharing it |
| --- | --- |
| `G3EK3AH3WCC6` | **11** |
| `G3MC9KDKEW4P` | 8 |
| `G33256B8EMH2` | 6 |
| `G32A11RMAXSN` | 6 |
| `G3FY197V49CJ` | 5 |
| `G31R9HJA4SCN` | 4 |
| 13 further prefixes | 1 each |

Worker records all begin `G3`; two `reportsTo` entries begin `G5`. The prefix appears to encode a
creation batch or era, nothing semantic.

**Consequences for the ERP:**

- Store the **full 16 characters**. Never truncate, never index on a prefix — one prefix covers
  eleven people.
- Case-sensitive opaque text. `CHAR(16)` / `VARCHAR(16)`.
- **The AOID does not encode the company code.** `positionID` does; the AOID does not. A `4RY`
  worker is not distinguishable from a `4RZ` one by their AOID.
- Two AOIDs differing only in the last four characters is **normal**, not a data defect.

### ⚠ Three identifiers, and `workerID` is labelled "Associate ID"

| Field | Shape | Role |
| --- | --- | --- |
| `associateOID` | 16 chars | **The API key.** Required on every pay-data submission |
| `workerID/idValue` | 9 chars | A *different* identifier |
| `payrollFileNumber` | 6 digits | The human-facing ADP File # |

In `reportsTo` blocks, `workerID` carries
`schemeCode: { codeValue: "Associate ID", shortName: "Associate ID" }`.

**ADP labels `workerID` as "Associate ID" — and it is not the `associateOID`.** Both fields are
fully populated on every record, and their names are near-identical. Reading "Associate ID" off a
Workforce Now screen and using it as the AOID produces
`Label not found, missing following key: access.invalid associateOid` on every submission.

**The ERP employee record needs two ADP columns**, because the pay-data payload consumes both at
different nesting levels:

```
payeePayInputs[].associateOID                                 ← 16-char
payeePayInputs[].payrollProfilePayInputs[].payrollFileNumber  ← 6-digit
```

`positionID` is derivable (below) and `workerID` can be ignored unless someone needs to reconcile
against a WFN screen.

## 5. `positionID` is derived, not independent

Every record satisfies:

```
positionID = payrollGroupCode + payrollFileNumber
```

e.g. File Number `000310` → `4RZ000310`; `000550` → `4RZ000550`. Holds across all ~40 records
including `reportsTo` entries.

**The ERP does not need to store `positionID`** — it is computable from two fields it already
holds. It also means the company code is embedded in every position identifier, so a Ventura
(`4RY`) worker would be visibly distinguishable.

## 6. The default query returns terminated workers

Most records in the first page are **terminated**, some as far back as 2016. The endpoint returns
the full historical roster, not the current workforce.

**Every ERP read must filter:**

```
$filter=workers/workAssignments/assignmentStatus/statusCode/codeValue eq 'A'
```

### Two status fields with different vocabularies

| Field | Values observed |
| --- | --- |
| `workerStatus/statusCode/codeValue` | `Active`, `Terminated`, **`Inactive`** |
| `workAssignments/assignmentStatus/statusCode/codeValue` | `A`, `T`, `L` |

They can disagree. One record shows worker status **`Inactive`** while the assignment shows
**`L` — Leave**, reason `DIS — Disability`. **`Inactive` does not exist** in the schema's
assignment status code list (`A`/`D`/`L`/`T`).

**Filter on `assignmentStatus`, not `workerStatus`** — it is the coded, documented one, and it is
the one the `$filter` criteria expose.

Termination reason codes seen: `H` Layoff, `O` Reduction in Force, `M` Performance,
`K` Mutual Agreement, `G` Deceased, `X` Import Created Action, `CURR` Existing Position,
`DIS` Disability.

`X — Import Created Action` appears on many older records — a data-migration artefact, not a real
business reason.

## 7. A successful response *does* carry `confirmMessage`

```json
{ "workers": [ … ], "meta": null, "confirmMessage": null }
```

The envelope exists on success — **null, but present**. So the earlier reading that "only failures
carry an envelope" was too strong: the field is always there, and populated only on failure.

This still does **not** settle whether a successful `POST` to `pay-data-input.modify` returns a
populated `confirmMessage` with a GUID. It does make it more plausible, since the field is part of
the standard response envelope rather than an error-only structure. Remains open in
[payroll/gaps.md](../gaps.md).

---

## 8. Fields confirmed by real data

| Field | Observed |
| --- | --- |
| `payrollGroupCode` | **`4RZ` on every record** — no `4RY` in the first page |
| `payrollFileNumber` | 6-digit zero-padded, all ≥ `000051`, matching the regex |
| `payCycleCode` | **`W` — Weekly on every record**, active and terminated |
| `payrollScheduleGroupID` | constant string `"Use Period End Date 1 on checks"` — a sentence, not an id |
| `payrollProcessingStatusCode` | `"Paid"` on every record |
| `wageLawCoverage/coverageCode` | `N` Non-exempt (field/hourly), `E` Exempt (salaried admin) — populated and plausible |
| `homeOrganizationalUnits` | one entry, always `typeCode: Department`. Field staff → `PPEDEP`, salaried → `SADMIN` |
| `assignedOrganizationalUnits` | **always identical to `homeOrganizationalUnits`** in this sample |
| `homeWorkLocation` | `DEF — DEFAULT LOCATION` wherever present. **No worker on `VEN`** |
| `standardPayPeriodHours` | only on salaried records; values 40 and 32 |
| `jobCode` | absent on many older/terminated records; present on most active |

### Custom payroll fields TCG uses for something

| Field | Value |
| --- | --- |
| `payrollCustomArea3` | **`A8906799` — identical on every record.** A policy or account number of some kind |
| `payrollCustomArea4` | a varying 3–4 digit number, one per worker. **Purpose unknown** |
| `person/customFieldGroup` → `Shirt Size` | free text: `XL`, `2XL`, `3XL`, `4XL`, `Medium`, `Large`, `2 XLarge` — inconsistent vocabulary |

`payrollCustomArea4` is worth asking Payroll about. A per-worker code held in ADP that nobody has
documented is exactly the kind of thing that turns out to be load-bearing.

---

## 9. Data-quality defects visible in production

Relevant because the ERP will consume this, and because it shows ADP is not authoritative for
address data:

- **County field containing a street address.** One record has
  `legalAddress/countrySubdivisionLevel2` set to a street address string.
- **County field containing `"Usa"`.**
- Misspelled city names.
- `Shirt Size` uses seven different spellings of four sizes.
- One worker's hire date on the assignment (`2026-04-08`) is **later** than the worker-level
  `originalHireDate` (`2022-05-23`), with termination two weeks after — a rehire recorded without
  a `rehireDate`.

None of this blocks the integration. It does mean **the ERP should not treat ADP address or
demographic data as clean**, and should not sync it inbound.

---

## Privacy

**What ADP masks:** `governmentIDs/idValue` returns `XXX-XX-XXXX`; `birthDate` returns
`0000-00-00`.

**What ADP does not mask:** full legal names, home street addresses, personal email addresses,
personal mobile numbers, gender, race/ethnicity, marital status, and photo URLs.

**Therefore:** the unfiltered `GET /hr/v2/workers` is a bulk personal-data export. The ERP has no
use for any of it. Every read must use `$select`, restricted to:

```
workers/associateOID
workers/workAssignments/payrollFileNumber
workers/workAssignments/assignmentStatus
workers/workAssignments/payrollGroupCode
```

Recorded as a closed decision in [payroll/gaps.md](../gaps.md).
