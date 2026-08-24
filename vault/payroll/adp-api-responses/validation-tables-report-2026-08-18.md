---
title: WFN "Validation Tables" standard report — TCG's actual code lists (run 2026-08-18)
source: adp-wfn-ui/Reports & Analytics › Standard › Setup › Validation Tables (Run as PDF, 08/18/2026 09:34 EDT, all company codes)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, adp, reference-data]
entities: [adp-code, department, cost-number, job-title, location, worker-category, deduction-code, hire-reason, adp-company-code]
part_of: payroll/adp-api-responses/INDEX.md
---

# WFN Validation Tables report — what TCG's tenant actually holds

Run from **Reports & Analytics › Standard › Setup › Validation Tables** on 2026-08-18. Companies in
scope: `4RY` (Ventura), `4RZ` (THE CRANE GUYS LLC), "No Company". These are the values behind the
`/codelists/…` and validation-table APIs; where a table shows **no company code** the API's
`?companyCode=4RZ` filter returns `204` (that is why `cost-numbers` looked empty on 2026-08-13).

## Department (12, all `4RZ`) — `codelists/hr/v3/worker-management/departments`, `validation-tables/departments`
| Code | Description | | Code | Description |
|---|---|---|---|---|
| ACTDEP | Accounting Dep | | SADMIN | SALARY ADMIN |
| DISDEP | Dispatch Dep | | SAFDEP | Safety Dep |
| MECDEP | Mechanics Dep | | SALOFF | OFFICER |
| MNGDEP | Management Dep | | SLSDEP | Sales Dep |
| ODRDEP | Oilers / Drivers Dep | | YRDDEP | YARD |
| OPRDEP | Operators Dep | | PPEDEP | Field |

## Cost Number (4, **no company code**) — `cost-numbers` / `validation-tables/cost-centers`
`G1L1` Grade 1 1 · `G1L2` Grade 1 2 · `G2L1` Grade 2 1 · `G2L2` Grade 2 2 (grade × level placeholders;
not used for job attribution).

## Job Title (10, no company code) — `job-titles`
`ACCOUNTG` Accounting · `ADM` Administrator · `DISPATCH` Dispatch · `MECHANIC` Mechanic ·
`MNGMT` Management · `OILDRV` Oilers / Drivers · `OPERATOR` Operator · `SAFETY` Safety ·
`SALES` Sales · `YARD` Yard.

## Location (2) — `locations`
`DEF` DEFAULT LOCATION · `VEN` Ventura.

## Worker Category (18, no company code) — `codelists/hr/v4/worker-management/worker-category`
`F` Full Time · `P` Part Time · `TEMP` Temporary · `SL` Seasonal · `SM` Summer · `ST` Student ·
`INTR` Intern · `TR` Trainee · **`APP` Apprentice** · **`L12` Local 12** · `CAS` Casual ·
`CONS` Consultant · `CONT` Contract · `CT3P` Contractor – 3rd Party · `1099` Contractor – 1099 ·
`EX` Expatriate · `RA` Resident Alien · `RET` Retired.
Note: `L12` and `APP` exist here as worker categories — a second, native place (besides
`laborUnionCode`) to mark union membership / apprenticeship on the worker.

## Deductions (65, all `4RZ`) — same list as the pay-data `/meta` deduction codes
Statutory `65` Medicare surtax; `70`/`90(%)` bankruptcy; `71`,`72`/`91`,`92`(%) tax levy;
`73`,`74`,`GA1`,`XG1–XG4`/`93`,`94`(%) garnishment; `75–79`,`CS1`/`95`,`96`(%) support.
Retirement `K` 401K Employee, `81` 401K Employee%, `82` 401K Roth%, `83` Roth 401K Ee%, `ROT`,
`CAT` Roth catch-up, `40L` 401K loan. Benefits `HEA` Health, `DEN` Dental, `VIS` Vision, `FSA`,
`DC1` Dep Care FSA, `APO`/`APR` accident, `CNC`, `CRT`, `HOS`, `LP1` pretax, `LP2` FSA,
`LPO`/`LPR` Life Post. Banking `CK1–CK5` checking, `SV1–SV5` savings. Allowances `PHN`, `CEL`,
`AUT`, `REI`, `MIS`, `LON` loan, `RES` retro subpay, `SUB` "X subspay nont", `ONC` "X on call",
`VAD` vacation deduc.

## Reason codes the write APIs need
- **Status Change Reasons (71)** — hire reasons for `applicant.onboard.hireReasonCode` /
  `worker.hire.eventReasonCode` and termination/rehire reasons: `NEW` New Position, `CURR`
  Existing Position (rehire sample uses `CURR`), `A` Abandoned Job, `D` Attendance, `H` Layoff,
  `J` Misconduct, `K` Mutual Agreement, `L` No-show, `M` Performance, `N`/`PER` Personal, `O`
  Reduction in Force, `P` Reorganization, `Q` Sale of Business, `R` Strike, `T` Early Retirement,
  `U` Normal Retirement, `G` Deceased, `DIS`, `EDU`, `FAM`, `MED`, `MIL`, `LO` Leave Over, `ER`
  Early Return, `X`/`Z`/`IMPORT`/`ADPYEP` system; plus ADP's global `NL01–NL99` and `UK…` codes.
- **Compensation Change Reasons (32)** — for `base-remuneration.change.reasonCode`: **`L12 CT` L12
  Contract Increase** (the 07/01 union raise), `NH` New Hire, `NEW` New Employee, `INIT` Initial
  Compensation, `MER` Merit, `PRO`/`*PROMO` Promotion, `COL` Cost of Living, `ATB`
  Across-the-Board, `GINC`/`GDEC` general increase/decrease, `ADJ` Adjustment, `COR` Correction,
  `CORDMC`, `REC` Job Reclassification, `REH` Rehire, `XFR` Transfer, `SALSTP` Salary Step, `SPG`
  Step Progression, `STDHR` Co Standard Hours, `FLSAOT` FLSA Overtime, `CDOH` Change Date of Hire,
  `MUL`, `OTH`, `PERF`, `ADL` Additional Job, `DBLOAD`, `IMP`, `IMPORT`, `JOBC@PY`, `REH#PY`.
- **Job Change Reasons (12)** — for `work-assignment.modify.eventReasonCode`: `PAYCH` Pay Change,
  `XFR` Transfer, `ADL` Additional Job, `AAP` Add Another Position, `NH` New Hire, `OTH`, `*PROMO`,
  `*RELO`, `DBLOAD`, `IMPORT`, `JOBC@PS`, `REH#PS`.
- **Corporate Group Change Reasons (9)** — department/location moves: `XFR`, `ADL`, `NH`, `*PROMO`,
  `*RELO`, `DBLOAD`, `IMPORT`, `JOBC@CG`, `REH#CG`.

## Tax jurisdictions (`4RZ`)
State: `AL`, `AZ`, `CA`, `ID`. SUI/SDI: `AL-03`, `AZ-37`, `CA-25` California (Non Taxing),
`CA-75` California (Taxing), `ID-94`.

## Not in this report
Hours & Earnings codes (see [pay-data-input-meta.md](pay-data-input-meta.md) — 52 codes), memo
codes, rate codes, union codes/locals, business units (none configured), pay groups, templates.
