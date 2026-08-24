---
title: TCG Payroll App (legacy) - Glossary
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip#11_GLOSSARY.md
migrated: 2026-08-13
updated: 2026-06-23
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, reference-data]
entities: [payroll-group, labor-entry, pay-component, final-gross-pay, wtl, special-saturday]
part_of: payroll/payroll-app-current-state/INDEX.md
---

## Project and system terms

| Term | Meaning |
|---|---|
| Payroll App | The TCG SQL/C#/Next.js application used to calculate and review payroll-related labor entries. |
| `TCG_RawFMS` | Source database containing FCC/FMS-style raw/source data exposed through API views. |
| `TCG_PayrollAPP` | Payroll application database containing calculations, rules, ledger, API views, reporting views, and tests. |
| SQL-first | Design principle that SQL Server is the calculation and audit authority. |
| Source synonym | A `TCG_PayrollAPP.src.*` synonym pointing to a `TCG_RawFMS.api.*` view. |
| Worklist | Primary payroll review page showing employees for a pay period and issue counts. |
| Employee detail page | Weekly employee labor/pay review page at `/worklist/employee/[empID]`. |
| Pay period | Saturday-Friday payroll week. |
| Payroll Group | Application/UI employee classification label. Replaces ambiguous use of "Employee Type." |

## Payroll Groups

| Term | Meaning |
|---|---|
| L12 Labor Union Field | L12 union field employee group. |
| L12 Labor Union Mechanic | L12 union mechanic group, generally Employee.EmpTypeID = 3 with L12 craft. |
| Non-Union Admin Hourly | ADMIN craft/pay type hourly group. Intended California nonexempt hourly rule path. |
| Non-Union Admin Salary | ADMIN craft/pay type salary group. Intended salary/exempt review path. |
| System-Testing-VendorAccess | SYS/testing/default/fake users; excluded from payroll UI. |

## SQL object terms

| Term | Meaning |
|---|---|
| `LaborPayrollID` | Primary raw labor-entry identifier and core join key across calculated, ledger, API, and UI surfaces. |
| `JobTicketID` | Source job ticket identifier. |
| `EmpID` | Employee identifier from source system. |
| `app.v_Base_LaborPayroll` | Enriched base labor view used by calculations and UI. |
| `fms.Payroll_Calculated` | Main current calculated payroll output table, one row per calculated labor entry. |
| `fms.Payroll_PayComponent` | Explainable pay component ledger. |
| `fms.Payroll_CalcException` | Error/warning/review issue table. |
| `calc.TicketTimeline` | Cached ticket shift/boom window table. |
| `api.*` | Stable SQL API-facing schema. |
| `rpt.*` | Reporting and issue-summary schema. |

## Payroll calculation terms

| Term | Meaning |
|---|---|
| Actual worked pay | Pay calculated from priced work time before later guarantees/rest/WTL/subsistence/rounding components. |
| Pay component ledger | Rule/component-level breakdown of pay. |
| Final Gross Pay | Current `fms.Payroll_Calculated.Final_Gross_Pay`; core calculated gross after actual, guarantee, and rest. |
| Payable gross | Full payable concept that may include payable-only components such as subsistence. |
| WTL | Worked Through Lunch / meal-period token and rule family. |
| Source Rate Raw | Source/FMS rate value exposed for pricing/audit depending on Payroll Group and implementation stage. |
| CraftPayRate | Union craft base rate from craft tables. |
| CraftModifierPayRateAdjustment | Boom/modifier rate add from modifier tables. |
| Boom modifier | Hourly premium/modifier tied to boom/craft modifier rules. |
| Guarantee / minimum pay | Additional pay/hours to satisfy minimum-pay rules. |
| Rest premium | Additional premium when required rest after overtime was not received. |
| Subsistence | Token-driven allowance component, currently payable-only. |
| Special Saturday | First Saturday in June or December, treated with special double-time/minimum behavior under L12 rules. |
| Outside-window OT | Overtime behavior for weekday work outside the standard 06:00-17:00 window. |

## Web/API terms

| Term | Meaning |
|---|---|
| `PAYROLL_API_BASE` | Web environment variable pointing to local/API base URL. |
| `PAYROLL_API_KEY` | Shared local API key used between Web and API. Should be generated per environment. |
| `PAYROLL_WEB_AUTH_SECRET` | Web auth secret. Should be generated per environment. |
| `PAYROLL_WEB_USERS_JSON` | Local web-user config containing usernames/password hashes/roles. Should use local dev hashes only. |
| ADP File Number | External ADP employee file number mapped through `app.EmployeeExternalIdentifier`. |

## Issue severity terms

| Term | Meaning |
|---|---|
| Error | Blocking or serious issue requiring correction. |
| Warning | Important review item that may not block calculation. |
| Review | Needs human review/confirmation. |
| Not applicable | Rule intentionally does not apply to a Payroll Group or row. |
| Suppressed | Rule/issue was not surfaced because it was not applicable or was intentionally disabled. |
