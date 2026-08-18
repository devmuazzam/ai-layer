---
title: ADP Workforce Now — what the ERP can read, what it can write, what it must send weekly (checked 2026-08-18)
source: research/ADP official sample payloads (github.com/adpllc/marketplace-sample-payloads, wfn/*), Payroll Output API Guide (Turbo), Applicant Onboard WFN guide, apps.adp.com API Central for WFN feature page, TCG ERP Integration Postman collection, ADP WFN screenshots 2026-08-18; Confluence searched (only BRS-INT-003 and FOP FRD mention ADP)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
topics: [payroll, adp-integration, adp-api, earning-codes, onboarding, worker-hire, payroll-output]
entities: [adp-api, adp-code, earning-code, adp-file-number, craft-code, applicant-onboard, worker-hire, payroll-output]
part_of: payroll/INDEX.md
---

# ADP Workforce Now — read / write boundary for the ERP (2026-08-18)

Answers to the TPM's questions, from ADP's own documents and samples plus the API Central
project TCG holds (*TCG ERP Integration*). Confluence has no ADP content beyond
`BRS-INT-003 "ADP Payroll Integration — needs supporting documentation"`.

## 1. "We can get gross from ADP for what's processed" — only as a Marketplace Partner

- The API that returns processed results is the **Payroll Output API** (`/payroll/v2/payroll-output`,
  levels default / pay / payDetails / acc / acc-all / details). It **does** support Workforce Now
  and returns company gross, per-associate payment summaries with earnings by code, hours,
  deductions, memos, YTD accumulations. But its guide states: **"This API's availability is
  limited for use by Marketplace Partner's only."** API Central for WFN (what TCG has) lists
  Employee Sync, Time, PTO, **Payroll Input**, Onboarding, Recruiting — not payroll output.
- What TCG *can* read after processing via API Central: workers (`/hr/v2/workers`, no pay
  amounts), the pay calendar (`/payroll/v1/pay-schedule/...`), and event notifications. So the
  ERP should keep its own gross (it already computes it) and treat ADP as write-mostly for
  payroll; if a processed-gross read is required, that is a Marketplace-partner engagement or a
  practitioner report, not an API Central call.

## 2. "Static and dynamic codes" — what that means in ADP's API

Every ADP `/meta` response describes each field either with an inline `codeList` — **static**,
ADP-shipped enumerations (pay-allocation IDs `1/2/3`, tax-cycle codes `0–9,B,C,D,F,M,S,H,T`,
shift tag values `2–9`, reserved earning codes `R`, `O`, `T`) — or with a `links` entry / the
note *"Please use parameter companyCode to retrieve all available codes"* — **dynamic**,
company-configured lists that live in WFN validation tables and are read from `/codelists/...`
(departments, cost numbers, business units, locations, job titles, union codes, union locals,
pay groups, data control…) or come back company-scoped in the meta with `foreignKey: 4RZ`
(the 52 earning codes, 65 deduction codes, 16 memo codes TCG has defined).

## 3. What we can SET in ADP through the API, and what we cannot

| Area | Can we write it? | API | Notes |
| --- | --- | --- | --- |
| Department code | **Yes** | `POST /hcm/v1/validation-tables/departments` | body `listItems[{payrollGroupCode, nameCode{code,name}, inactiveIndicator}]`; code length must equal Company Options setting |
| Cost number | **Yes** | `POST /hcm/v1/validation-tables/cost-centers` | same shape |
| Business unit, job title, location | Yes | `POST /hcm/v1/validation-tables/business-units` / `.../job-titles` (`jobs`) / `.../locations` | ADP sample collections exist for each |
| **Hours & Earnings codes** (R, O, DT, LBH…, S2R…, FRR…, MLR…) | **No API** | — | created by hand in WFN *Setup › Tools › Validation Tables › Payroll › Paydata › Hours & Earnings Codes*; readable only via `pay-data-input.modify/meta` |
| Deduction / memo codes | No API | — | validation tables in WFN UI |
| Rate codes | No API, no code list | — | free text on the API; documented ADP known issue |
| Hire a worker | **Yes** | `POST /events/hr/v1/worker.hire` | person (name, SSN, DOB, gender, address, contacts) + workAssignment (hireDate, workerTypeCode, jobCode, wageLawCoverage FLSA, standardPayPeriodHours, homeOrganizationalUnits, homeWorkLocation, payCycleCode, baseRemuneration, **payrollGroupCode**, **payrollFileNumber**, payGradeCode) |
| Onboard a new hire (template) | **Yes** | `POST /hcm/v2/applicant.onboard` (V2) | see §5 |
| Rehire / terminate / add position | Yes | `worker.rehire`, `worker.terminate`, Employee Job Change | samples exist |
| Change pay rate | **Yes** | `worker.work-assignment.base-remuneration.change` | `baseRemuneration.hourlyRateAmount.amount`, `effectiveDate`, `payCycleCode`, `standardHours`, `wageLawCoverage`, `premiumRateFactor` |
| Change job / org unit / EEO class | Yes | `work-assignment.modify` | `jobTitle`, `jobFunctionCode`, `payGradeCode`, `occupationalClassifications` (EEOC, Job Class), `industryClassifications` |
| Additional remuneration (Rate 2/3) | Yes | `worker.work-assignment.additional-remuneration.add/remove` | |
| **Custom fields on the worker** | **Yes** | `worker.person.custom-field.{string,code,number,amount,date,indicator,percentage,telephone}.change` | requires the custom field to exist in WFN first (`itemID`) |
| Direct deposit | Yes | `worker.pay-distribution.change` | |
| Recurring deductions | Yes | `payroll-instructions` v1/v2 (start / change / stop) | |
| Pay data for a cycle | **Yes** | `POST /events/payroll/v1/pay-data-input.modify` | §4 |
| Employee craft code | **No native field** | — | see §6 |
| Company / pay group / earning-code setup | No | — | WFN UI, ADP service |

## 4. What we will send as JSON for a weekly payroll (classic WFN body, from our collection)

One request per batch (`payrollProcessingJobID` = our batch id, e.g. `TCG-2026-W31`), company
`payrollGroupCode = 4RZ`, one `payeePayInputs[]` entry per employee keyed by **`associateOID`
+ `payrollFileNumber`**, `payNumber "1"`, and inside `payInputs[]`:

```json
{ "events": [ { "data": {
  "eventContext": { "payrollGroupCode": { "codeValue": "4RZ" }, "payrollProcessingJobID": "TCG-2026-W31" },
  "transform": { "payDataInput": { "payeePayInputs": [
    { "associateOID": "<AOID>", "payNumber": "1",
      "payrollProfilePayInputs": [ { "payrollFileNumber": "000480", "payInputs": [ {
        "earningInputs": [
          { "earningCode": { "codeValue": "R"   }, "numberOfHours": 35.5 },
          { "earningCode": { "codeValue": "O"   }, "numberOfHours": 13   },
          { "earningCode": { "codeValue": "DT"  }, "numberOfHours": 4    },
          { "earningCode": { "codeValue": "LBH" }, "numberOfHours": 4,  "rate": { "rateValue": 0.25 } },
          { "earningCode": { "codeValue": "LBH" }, "numberOfHours": 5,  "rate": { "rateValue": 1.00 } },
          { "earningCode": { "codeValue": "LBO" }, "numberOfHours": 4,  "rate": { "rateValue": 1.50 } },
          { "earningCode": { "codeValue": "SUB" }, "earningsAmount": { "amountValue": 85, "currencyCode": "USD" } },
          { "earningCode": { "codeValue": "R" }, "numberOfHours": 8,
            "configurationTags": [ { "tagCode": "Shift Code", "tagValues": [ "2" ] } ] }
        ],
        "deductionInputs": [], "memoInputs": [], "reportableEarningAndBenefitInputs": [], "taxInputs": [],
        "payAllocation": { "allocationID": "3", "allocationTypeCode": { "codeValue": "<department>" } },
        "_modificationTypeCode": "Add"
      } ] } ] } ] } } } } ] }
```

- Hours codes take `numberOfHours` (and optionally `rate.rateValue` — the boom adder — or
  `rateCode`); dollar codes take `earningsAmount`. Sending hours in an amount field is a 400.
- `_modificationTypeCode`: `Add` (new batch), `Append` (add to an existing batch id), `Replace`.
- The response is `200 OK` with no batch identifier; keep our own batch id. Wrong-array code
  collisions (`LPR` earning vs deduction) also return 200.
- Header `roleCode: employee` is what the collection uses on this call; auth `Bearer` + mTLS.
- The ADP worksheet then shows exactly these lines: Reg / OT / DT Hours, one row per boom rate
  under Temporary Rate + LB REG/OT/DBL/TRI, Shift Diff 2/3, SUB PAY (screenshots 2026-08-18).

## 5. New-hire onboarding — what `applicant.onboard` V2 provides

`POST /hcm/v2/applicant.onboard`, driven by an **onboarding template** (`onboardingTemplateCode`,
read from `/hcm/v2/applicant.onboard/meta?$filter=meta/applicantOnboarding/onboardingTemplateCode/code eq '…'`),
`onboardingStatus.statusCode` = `inprogress` (creates an in-progress hire the practitioner
finishes in WFN) or `complete` (creates the employee), `preHireIndicator`,
`onboardingExperienceCode` (`default_w2`). Body sections:
- `applicantPersonalProfile` — names, legal + other addresses, phones/emails (with
  `notificationIndicator` to trigger the onboarding email), language, marital status, race,
  ethnicity, birth date, government IDs (SSN, incl. `AppliedFor`), gender;
- `applicantWorkerProfile` — hireDate, officerType, homeWorkLocation, **homeOrganizationalUnits**
  (LegalEntity, LaborProfile, BusinessUnit, HomeDepartment, HomeCostNumber), managementPosition,
  reportsTo position, workerClassification, payGrade, **job** (jobCode/title, FLSA wageLaw,
  EEO/NAICS classifications), hireReason, business contacts, benefits eligibility class,
  workerType (F/P…), **laborUnion.laborUnionCode**, ACA code;
- `applicantPayrollProfile` — **payrollGroupCode** (company), `baseRemuneration`
  (`recordingBasisCode` hourly/salary + `payPeriodRateAmount.amount`);
- `employmentEligibilityProfile` (I-9 employer location), `applicantTimeProfile` (badge, time zone).
Everything it references (departments, locations, union codes, job titles, pay groups, tax
jurisdictions…) is validated against the **dynamic** code lists above.

## 6. Can the employee craft code be set in ADP? — no native field; three carriers

ADP has **no craft/classification field** in worker or pay-data schemas (confirmed against
`/hr/v2/workers/meta` and the pay-data `/meta`). Options, all of which the ERP must own the
meaning of:
1. **Custom field** on the worker — the payroll profile's `CustomArea1–4` string fields (writable at
   onboarding, `applicantPayrollProfile.customFieldGroup.stringFields`) or an HR custom field
   (`worker.person.custom-field.*.change`); readable back in `/hr/v2/workers`.
2. **Job title** (`jobCode`) — a validation table we can extend via API, but today it holds 10
   generic titles (e.g. `OPERATOR`) and one title cannot carry the nine L12 wage groups.
3. **Labor profile / union local** codes on the work assignment — union membership, not craft.
Craft, craft modifier and rates stay ERP-side (as in the legacy app); ADP receives hours (and
the temp rate for boom lines), not the craft.

## 6a. Groups in ADP — which exist, which we can create

| "Group" | What it is in WFN | Create via API? |
| --- | --- | --- |
| Company / payroll group code (`4RZ`, `4RY`) | the legal payroll company; every batch and code list is scoped to it | No — ADP sets it up |
| Pay group (`codelists/payroll/v4/…/pay-groups`) | pay-frequency group inside a company | No — WFN setup |
| Department, cost number, business unit, location | organisational units; a worker's home units, and pay-data allocation dimensions | **Yes** — validation-table POSTs |
| Job title | job code table (10 values today) | Yes — validation-table POST |
| Union code / union local / labor profile / bargaining unit | membership fields on the work assignment | No API to create the codes; assignable per worker |
| Benefits eligibility class, pay grade | worker groupings | codes not creatable via API (`eligibility-classes` is 403 for TCG); assignable per worker |
| Custom fields (`CustomArea1–4` payroll, `customFieldGroup` HR) | free string/code fields on the worker | field created in WFN once; values writable via API |

There is **no ADP concept matching TCG's payroll groups** (L12 Field / Mechanic / Non-Union Admin
Hourly…). If ADP must know them, carry the value in a custom field or a department/business unit
— the ERP stays the owner of the meaning.

## 6b. Do the codes carry a rate? — no; rates live on the employee or on the pay line

- Earning / deduction / memo codes in `/meta` are `codeValue + longName` only — **no rate**.
  Department / cost-number / job-title lists likewise.
- Rates exist in two places: **on the employee** — `baseRemuneration.hourlyRateAmount` plus up to
  eight additional rates `Rate2Amount … Rate9Amount` (`additionalRemunerations`), settable at
  onboarding or via `base-remuneration.change` / `additional-remuneration.add`; and **on the pay
  line** — `earningInputs[].rate.rateValue` (what the ADP sheet calls *Temporary Rate*, used for the
  boom adder) or `rateCode` (points at an employee rate slot; no code list via API).
- Reading rates back: `/hr/v2/workers` returned `baseRemuneration` **without `amountValue`** for
  TCG (entitlement) — so the ERP cannot rely on reading rates from ADP.

## 6c. New-hire onboarding — what to send (`POST /hcm/v2/applicant.onboard`)

**Minimum that ADP accepts (creates an in-progress hire the practitioner completes in WFN):**
`onboardingTemplateCode.code`, `onboardingStatus.statusCode "inprogress"`,
`applicantPersonalProfile.birthName{givenName, familyName}`, `applicantWorkerProfile.hireDate`,
`applicantPayrollProfile.payrollGroupCode` (= `4RZ`).

**What TCG should send for a field employee (status `complete`, from the ERP employee record):**

| Section | Fields | TCG source |
| --- | --- | --- |
| Template / status | `onboardingTemplateCode` (from `/meta`), `onboardingStatus complete`, `preHireIndicator`, `onboardingExperienceCode` (`default_w2`) | fixed |
| Personal | legal/birth name, `birthDate`, `genderCode`, SSN (`governmentIDs`, or `AppliedFor`), `legalAddress`, phones, personal email (`notificationIndicator true` sends the onboarding invite), marital status, race/ethnicity (EEO), language | employee master |
| Worker | `hireDate`, `hireReasonCode`, `homeWorkLocation`, `homeOrganizationalUnits` (BusinessUnit, **HomeDepartment**, HomeCostNumber, LegalEntity, LaborProfile), `reportsTo.positionID`, `job.jobCode` (job title), `wageLawCoverages` (FLSA E/N), EEO/NAICS classifications, `workerTypeCode` (F/P), `benefitsEligibilityClassCode`, `payGradeCode`, **`laborUnion.laborUnionCode`** (`L12`), `bargainingUnit`, ACA code, business email/phone | employee master + yard/department |
| Payroll | **`payrollGroupCode 4RZ`**, **`payrollFileNumber`** (our ADP File Number), `overtimeEligibilityIndicator`, `standardHours`, `baseRemuneration{recordingBasisCode hourly, payPeriodRateAmount}` (union rate = craft rate at hire), `additionalRemunerations Rate2…Rate9`, `wageEntityCode`, **`customFieldGroup.stringFields CustomArea1–4`** — the natural home for **craft code / craft modifier / TCG payroll group** | employee master, craft table |
| Tax | federal W-4 (`applicantTaxProfile.usFederalTaxInstruction`), state (`usStateTaxInstructions`, `suiTaxInstruction`), local | usually left to the employee's onboarding tasks; optional |
| I-9 / time | `employmentEligibilityProfile.employerOrganization.locationNameCode`, `applicantTimeProfile` (badge, time zone) | optional |

Everything coded above must already exist in the corresponding WFN validation table
(department, location, job title, union code, pay group, template).

## 7. What we need to connect

- API Central project *TCG ERP Integration* (exists): `client_id` / `client_secret` (env
  *TCG ADP*), the project **mTLS certificate + private key** presented on the token call and every
  API call, `POST https://api.adp.com/auth/oauth/v2/token` `grant_type=client_credentials`.
- Each API added to the project's scope by a practitioner (Payroll Input, Workers, Onboarding /
  Worker Hire, Validation Tables, Event Notifications; Time/PTO if used); `403 API_AccessDeniedFeature`
  means not entitled (seen on `eligibility-classes`).
- Company code `4RZ` (Ventura `4RY` has no schedules); every employee's **AOID + ADP File
  Number** (digits, ≥ 51); the earning codes already exist in WFN.
- Design decisions before the first batch: `earningInputs` vs `codedHoursEarningInputs`, allocation
  by department (TCG's current) vs cost number, batch-id convention from `payPeriodID`, and how
  rest premium / WTL are represented (no column on the current worksheets).

## API Central use cases (screenshot 2026-08-18) — none of this needs Marketplace
"Create new project for ADP Workforce Now" offers nine use cases: Worker Demographic Data (Read
Only) · Time & Attendance (Read Only) · **Worker Demographics & Pay Profile (Read/Write)** — "update
existing employee data, including pay rates and deductions" · Time & Attendance (Read/Write) ·
**New Hire Onboarding (Read/Write)** — "send new hires, onboard completed hires, read and rehire
existing employees" · **Payroll Input (Read/Write)** — "read worker demographic data, receive event
notifications, read and write validation tables departments and cost numbers, send payroll inputs"
· Paid Time Off · Recruitment and Staffing · Talent and Skills. Onboarding and editing employees are
therefore API Central; only Payroll Output is Marketplace-partner-only.

The onboarding field-by-field reference (required / template / optional / not-via-API, payloads,
and the change API for each part of the record) is the artifact *ADP Employee Onboarding via API
Central* — https://claude.ai/code/artifact/cd806009-fd67-4c55-b23a-6850c4e0df25. Two constraints
from ADP's guide worth holding: an in-progress hire cannot be completed by re-POSTing (F154681,
creates a second record), and HR-level custom fields are not supported by the onboard API (payroll
Custom Area 1–4 are).

## Related artifacts (rendered views of the legacy-app findings)
- *TCG Payroll Engine* — https://claude.ai/code/artifact/74b7f0dc-34b4-4415-9839-0281ea3d7878
- *TCG Pay Rules, One at a Time* — https://claude.ai/code/artifact/1a754dab-82d4-4736-b23c-d51593c34c6c
