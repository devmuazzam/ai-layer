---
title: Live ADP response — Payroll Data Input /meta (company 4RZ)
source: live-api/GET https://api.adp.com/events/payroll/v1/pay-data-input.modify/meta
migrated: 2026-08-13
updated: 2026-08-13
status: reference
conflicts_with: []
jira: []
topics: [payroll, adp-integration, adp-api, earning-codes, deduction-codes, reference-data]
entities: [adp-code, earning-code, deduction-code, memo-code, adp-company-code, pay-allocation]
part_of: payroll/adp-api-responses/INDEX.md
---

# Payroll Data Input `/meta` — the live ADP code table

**Captured 2026-08-13** by Ehtesham Anwar (CodingCops PM) against production, using the
`TCG ERP Integration` API Central project.

```
GET https://api.adp.com/events/payroll/v1/pay-data-input.modify/meta
```

**This is the authoritative record of what ADP will accept from TCG.** It supersedes the
2026-06-04 CSV export in [../adp-hour-earning-codes.md](../adp-hour-earning-codes.md), which was
partial and stamped with a wrong identifier.

> **Read this before the crosswalk.** [../adp-bucket-crosswalk.md](../adp-bucket-crosswalk.md)
> was written against the Excel import and marks many codes `TBD` or unverified. Most of those
> questions are answered here.

---

## Company codes — D-001 resolved

`/data/eventContext/payrollGroupCode` — label **"Company Code"**, `optional: false`.

| `codeValue` | `shortName` |
| --- | --- |
| **`4RY`** | The Crane Guys, LLC - **Ventura** |
| **`4RZ`** | THE CRANE GUYS LLC |

**Two findings, both new.**

1. **`631` is not a company code.** The crosswalk and
   [../adp-hour-earning-codes.md](../adp-hour-earning-codes.md) carry a standing warning to treat
   `631` and `4RZ` as different ADP identifiers until ADP confirms their contexts. ADP has now
   answered: the company codes are `4RY` and `4RZ`. Whatever `631` labelled, it was not this
   field. **Decision D-001's identifier question is closed.**
2. **There is a second company — Ventura, `4RY`.** It appears nowhere else in this vault. Every
   payroll document assumes a single company. Whether Ventura has employees, runs its own
   payroll cycle, and needs its own batch is **unanswered** — see [payroll/gaps.md](../gaps.md).

**Every code list below carries `foreignKey: "4RZ"`** — these are 4RZ's codes. The equivalent
list for `4RY` has not been pulled.

## Batch identifier

`/data/eventContext/payrollProcessingJobID` — label **"Batch ID"**, `optional: false`.
Free text. It is the **only** correlation handle between an ERP submission and anything visible
in WFN, because the success response carries no identifier at all. Make it deterministic
(e.g. `TCG-2026-W33`) and store it against the ERP batch.

---

## Hours & Earnings codes — 52 values

Returned identically for both
`…/payInputs/earningInputs/earningCode` and
`…/payInputs/codedHoursEarningInputs/hoursEarningCode/codeValue`.

`R`, `O` and `T` are ADP-reserved and carry no `foreignKey`. Everything else is TCG-defined.

### Core worked time

| Code | ADP long name |
| --- | --- |
| `R` | Regular *(reserved)* |
| `O` | Overtime *(reserved)* |
| `DT` | Double Time |
| `CAO` | **CA OT** |

### Holiday

| Code | ADP long name |
| --- | --- |
| `HDD` | **Holiday Double** |
| `HOL` | **Holiday Triple** |

**Decision D-006 is answered.** The crosswalk asked TCG to confirm that `HDD` means Holiday
Double and `HOL` means Holiday Triple. ADP's own `longName` says exactly that.

### Foreman premium — Brian Petros, 2026-08-09

| Code | ADP long name |
| --- | --- |
| `FRR` | Foreman REG |
| `FRO` | Foreman OT |
| `FRD` | Foreman DT |
| `FRT` | Foreman TRI |

All four confirmed live. See [../foreman-and-military-premiums.md](../foreman-and-military-premiums.md).

### Military Base premium — **not previously supplied**

| Code | ADP long name |
| --- | --- |
| `MLR` | Military REG |
| `MLO` | Military OT |
| `MLD` | Military DT |
| `MLT` | Military TRI |

**These were never given to CodingCops.** The 2026-08-09 chat listed four Foreman codes and
said nothing for Military. They already exist in ADP, in the same REG/OT/DT/TRI shape. The
presence of `MLT` (TRI) sharpens the open question of whether the $10/hr is a flat adder or is
multiplied along with the base.

### Boom and lattice premiums

| Code | ADP long name | | Code | ADP long name |
| --- | --- | --- | --- | --- |
| `LBH` | BOOM REG | | `LPR` | LATT OP REG |
| `LBO` | BOOM OT | | `LPO` | LATT OP OT |
| `LBD` | BOOM DBL | | `LPD` | LATT OP DT |
| `LBT` | BOOM TRI | | `LPT` | LATT OP TRI |
| `LOR` | LATT OL REG | | `LOD` | LATT OL DT |
| `LOO` | LATT OL OT | | `LOT` | LATT OL TRI |

`OP` = operator, `OL` = oiler.

### Shift differentials

| Code | ADP long name | | Code | ADP long name |
| --- | --- | --- | --- | --- |
| `S2R` | SHIFT 2 REG | | `S3R` | SHIFT 3 REG |
| `S2O` | SHIFT 2 OT | | `S3O` | SHIFT 3 OT |
| `S2D` | SHIFT 2 DT | | `S3D` | SHIFT 3 DT |
| `S2T` | SHIFT 2 TRI | | `S3T` | SHIFT 3 TRI |

### Leave, allowance and other

| Code | ADP long name | | Code | ADP long name |
| --- | --- | --- | --- | --- |
| `SUB` | Substpay NT | | `PTO` | P.T.O. |
| `SIC` | Sick | | `PTP` | PTO Payout |
| `BV` | Bereavement | | `FLA` | FMLA |
| `ANV` | Anniversary | | `UJD` | Unpd Jurydu |
| `BN` | Bonus | | `USR` | UNIFRM SVC |
| `CM` | Commission | | `VT1` | Voting Tim |
| `ONC` | On Call NT | | `T` | Tips *(reserved)* |
| `RET` | Retroactive | | `OTH` | OTH |
| `PPD` | PRIOR PERIO | | `PPO` | PRIOR PERIO |
| `1XQ` | CA SPSL 22 | | `1XX` | CA SUP AVAIL |

### What this settles for the crosswalk

**Every code the crosswalk marked as unverified exists.**
[../adp-hour-earning-codes.md](../adp-hour-earning-codes.md) warned that `LPR/LPO/LPD/LPT`,
`LOR/LOO/LOD/LOT`, `S2R/S2O/S2D/S2T`, `S3R/S3O/S3D/S3T` and `LBT` were **absent** from the June
export and that D-001 required a complete re-export before they could be trusted. All are
present. **D-001's blocking status can drop.**

### Codes present in ADP but absent from the vault

`CAO`, `1XQ`, `1XX`, `VT1`, and the four `ML*` codes appear in no TCG document.

**`CAO — CA OT` needs a decision.** The crosswalk routes all non-union California overtime to
the generic `O/T Hours` field, marked *"APPROVED DESIGN - reuse O/T Hours"*. But a dedicated
California OT code exists, and somebody created it deliberately. Recorded in
[payroll/gaps.md](../gaps.md).

---

## Deduction and reimbursement codes — 65 values

`…/payInputs/deductionInputs/deductionCode/codeValue`, and the **identical** list is returned
for `…/payInputs/reimbursementInputs/reimbursementCode/codeValue` (ADP titles both
`"Deduction Code"`).

The response also links a code-list API not present in the Postman collection:

> `GET https://api.adp.com/payroll/v3/deduction-configurations`

Notable groups — numeric statutory codes `65` (Medicare surtax), `70` (bankruptcy),
`71`/`72`/`91`/`92` (tax levy), `73`/`74`/`93`/`94` (garnishment), `75`–`79`/`95`/`96` (support);
retirement `K`, `40L`, `81`, `82`, `83`, `ROT`, `CAT`; benefits `HEA`, `DEN`, `VIS`, `FSA`,
`DC1`, `APO`, `APR`, `CNC`, `HOS`, `LP1`, `LP2`, `LPO`, `LPR`; banking `CK1`–`CK5`,
`SV1`–`SV5`; allowances `PHN`, `CEL`, `AUT`, `REI`, `MIS`; and `SUB`, `VAD`, `RES`, `LON`,
`ONC`, `CRT`, `CS1`, `GA1`, `XG1`–`XG4`.

### ⚠ Code collisions between arrays — a real defect risk

**The same string means different things depending on which input array it is placed in.**

| Code | As an earning | As a deduction |
| --- | --- | --- |
| `LPR` | **LATT OP REG** | Life Post |
| `LPO` | **LATT OP OT** | Life Post |
| `ONC` | On Call NT | X on call |
| `SUB` | Substpay NT | X subspay nont |

Sending `LPR` in `deductionInputs` instead of `earningInputs` deducts life insurance rather than
paying a lattice-operator premium — **and ADP returns `200 OK`.** Nothing in the response
distinguishes the two.

**Design consequence:** the ERP's ADP mapping configuration must persist the code **and its
target array**. A configuration table keyed on code alone is unsafe. This directly amends
implementation rule 5 in [../adp-bucket-crosswalk.md](../adp-bucket-crosswalk.md) — "never send a
code without its paired amount" is necessary but not sufficient.

---

## Memo codes — 16 values

`…/payInputs/memoInputs/memoCode`

| Code | Name | | Code | Name |
| --- | --- | --- | --- | --- |
| `401` | 401K Match | | `PHA` | PTO AVAILA |
| `X01` | 401K MAX EL | | `SHA` | Sick Availa |
| `B` | HLTH PLAN V | | `VAC` | Vacation |
| `G` | Gtl | | `VAD` | VACDED |
| **`L12`** | **local 12 dues** | | `PER` | Personal |
| `1XX` | Ca Sup Avail | | `$R` | FDQOT |
| `PPB` | PRIOR OT BE | | `PPE` | PRIOR OT EN |
| `ZYA` | FED Q'OT ADJ | | `ZYH` | FED Q'OT OVR |

`L12 — local 12 dues` is the union-dues memo. `PPB`/`PPE` (prior OT begin/end) pair with the
`PPD`/`PPO` prior-period earning codes.

---

## Pay allocation — how hours are attributed to work

`…/payInputs/payAllocation/allocationID`

| `codeValue` | Meaning |
| --- | --- |
| `1` | Allocation Position |
| **`2`** | **Temporary Cost Number** |
| **`3`** | **Temporary Department** |

`allocationTypeCode` then carries the value. For `allocationID = 1` it is a position number
`1`–`99` (with `1` documented as *"Cancel automatic allocations for this transaction"*). For
`2` and `3`, ADP returns no values inline and instead says:

> "Please use parameter companyCode to retrive all available codes"

pointing at the code-list endpoints in
[codelist-endpoint-catalog.md](codelist-endpoint-catalog.md).

**TCG allocates by Department, not Cost Number** — see
[codelist-departments.md](codelist-departments.md) for the evidence and its consequences.

---

## Shift tag

`…/earningInputs/configurationTags/tagCode` — label **"Shift"**
`…/earningInputs/configurationTags/tagValues` — `minItems: 0`, **`maxItems: 1`**, values `2`–`9`.

One shift per earning line. Consistent with the `S2*`/`S3*` code families; values `4`–`9` are
available but unused by any TCG rule in this vault.

## Tax frequency

`…/payInputs/taxInputs/taxCycleCode/codeValue` — `0`–`9` (spread taxes over N weeks),
`B` Bonus, `C` Supplemental Wage Bonus, `D` Daily 7-day, `F` Daily 5-day, `M` Monthly,
`S` Semi-monthly, `H` Teachers 20 payments, `T` Teachers 10 payments.

---

## Field-level facts worth holding

| Path (tail) | ADP label | Required? |
| --- | --- | --- |
| `eventContext/payrollGroupCode` | Company Code | **required** |
| `eventContext/payrollProcessingJobID` | Batch ID | **required** |
| `payeePayInputs/associateOID` | Associate ID | **required** |
| `payeePayInputs/payNumber` | Pay Number | **required** |
| `payrollProfilePayInputs/payrollFileNumber` | **"Field #"** | **required** |
| `payInputs/cancelAutomaticPayIndicator` | Cancel Automatic Pay | required |
| `earningInputs/numberOfHours` | **"Reg Hours"** | optional |
| `earningInputs/rateCode` | Rate Code | optional |
| `payAllocation/*` | — | optional |

Three traps in that table:

- **`payrollFileNumber` is labelled "Field #", not "File #".** ADP's own label. Do not let it
  suggest a different field.
- **`numberOfHours` is labelled "Reg Hours"** but is the hours field for *every* earning code,
  not just regular.
- **`rateCode` has no `codeList`.** This confirms ADP's documented known issue — *"Meta Call is
  not giving any codeList details for ratecodes."* Rate codes are free text over the API and must
  be looked up by hand. The crosswalk's temporary-rate design depends on them.

### Two earning arrays, not one

`earningInputs` and `codedHoursEarningInputs` are separate structures that accept the same code
list. Each has its own `rate/rateValue`, `numberOfHours` and `earningsAmount/amountValue`.

`codedHoursEarningInputs` is the API successor to the crosswalk's `Hours 3` / `Hours 4`
code-and-amount pairs. **The positional slot concept is gone** — there is no "slot 3" or
"slot 4", both are unbounded arrays — but the two-tier structure survives. Which array each ERP
component targets is now a design decision, and given the code collisions above, a consequential
one.

Money fields validate against `^[-]?[0-9]+(.[0-9]{1,2})?$` — signed, two decimal places. Negative
values are permitted.

---

## What is absent

- **No craft code, anywhere in the schema.** Confirms craft is an FCC/ERP concept that never
  reaches ADP.
- **No Hours & Earnings *write*.** Reading codes is possible; creating them is a manual WFN UI
  task at `Setup > Tools > Validation Tables > Payroll > Paydata > Hours & Earnings Codes`.
- **No response identifier.** `/meta` describes the request only. The `.modify` success response
  is `200 OK` with `messageText: NA` and no batch id.
