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
1. **Custom field** on the worker (`customFieldGroup.codeField` / `stringField`) — created once
   in WFN, then written via `worker.person.custom-field.*.change`; readable back in `/hr/v2/workers`.
2. **Job title** (`jobCode`) — a validation table we can extend via API, but today it holds 10
   generic titles (e.g. `OPERATOR`) and one title cannot carry the nine L12 wage groups.
3. **Labor profile / union local** codes on the work assignment — union membership, not craft.
Craft, craft modifier and rates stay ERP-side (as in the legacy app); ADP receives hours (and
the temp rate for boom lines), not the craft.

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

## Related artifacts (rendered views of the legacy-app findings)
- *TCG Payroll Engine* — https://claude.ai/code/artifact/74b7f0dc-34b4-4415-9839-0281ea3d7878
- *TCG Pay Rules, One at a Time* — https://claude.ai/code/artifact/1a754dab-82d4-4736-b23c-d51593c34c6c
