---
title: TCG Payroll App (legacy) - API and UI contract guide
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip#07_API_UI_CONTRACT.md
migrated: 2026-08-13
updated: 2026-06-23
status: reference
conflicts_with: []
jira: []
topics: [payroll, payroll-app, api-contract, web-ui]
entities: [worklist, employee-detail, pay-component, wtl]
part_of: payroll/payroll-app-current-state/INDEX.md
---

## Principle

The C# API should expose stable SQL outputs. The Next.js UI should format and navigate those outputs. Payroll calculations should remain in SQL unless a rule is intentionally moved and revalidated.

## Current Web routes

Observed successful Next.js build routes:

```text
/
/login
/worklist
/worklist/employee/[empID]
/payrollWeek
/api/auth/login
/api/auth/logout
/api/auth/me
/api/worklist
/api/employee-day-totals
/api/employee-week-daily-summary
/api/employee-week-guarantees
/api/employee-week-pay-components
/api/labor-entry-audit
/api/labor-entry-ledger
/api/labor-entry-week-detail
/api/payroll/refresh-from-nexgen
/api/rest-period-slice-detail
/api/employee-external-identifier
```

`/payrollWeek` is old/unused relative to the current `/worklist` primary route.

## Current page roles

| Web route/file | Role |
|---|---|
| `app/page.tsx` | Redirects to worklist. |
| `app/worklist/page.tsx` | Primary landing page / payroll worklist. |
| `app/worklist/employee/[empID]/page.tsx` | Employee weekly labor/pay review detail page. |
| `app/payrollWeek/page.tsx` | Old page; likely removable later. |

## Key SQL API surfaces

| Area | SQL object(s) | UI purpose |
|---|---|---|
| Worklist | `api.tvf_UI_Payroll_Worklist_ForPayPeriodDate` | Employee/pay-period worklist, issue counts, notes, status. |
| Payroll Group / rate | `api.v_UI_Employee_PayrollGroupRate` | Worklist-facing Payroll Group and base-rate context. |
| ADP File Number | `app.EmployeeExternalIdentifier`, save procedure/API route | Display/edit ADP File Number mapping. |
| Employee day totals | `api.tvf_UI_Payroll_EmployeeDayTotals_ForDateRange`, `api.tvf_EmployeeWeekDailySummary` | Daily summary card. |
| Labor entry detail | `api.v_Payroll_LaborEntry_WeekDetail` | Labor entry table and selected labor entry. |
| Pricing slices | `api.v_UI_Pricing_Slices`, `api.v_UI_Pricing_Slices_Advanced` | 30-minute slice detail and rate/multiplier audit. |
| Labor-entry ledger | `api.usp_UI_Payroll_LaborEntry_Ledger`, `api.v_UI_Payroll_LaborEntry_Ledger_Summary`, `api.v_UI_Payroll_LaborEntry_Ledger_Detail` | Component ledger summary/detail. |
| Pay component summary | `api.v_UI_Payroll_PayComponent_Summary`, `api.v_UI_Payroll_PayComponent_Detail`, `api.v_UI_Payroll_PayComponent_EmployeeDaySummary` | Week/day/component ledger totals. |
| WTL | `api.v_UI_WTL_LaborEntry_Status`, `api.v_UI_WTL_EmployeeDay_Summary`, `api.v_UI_WTL_Component_Detail`, `api.v_UI_WTL_Exceptions_LatestRun` | WTL token/status/components/issues. |
| Guarantees | `api.usp_UI_Payroll_EmployeeWeek_Guarantees`, `api.v_UI_GuaranteeGroups`, `api.v_UI_GuaranteeAllocations` | Minimum/guarantee review. |
| Rest period | `api.usp_UI_RestPeriod_SliceDetail` | Rest premium chain/slice details. |
| Rate review | `api.v_UI_LaborEntry_RateResolution`, `api.v_UI_LaborEntry_RateSourceReview`, `api.v_UI_Payroll_RateResolution_Issues` | Source/craft/rate warnings and review. |
| Boom/ticket status | `api.v_UI_LaborEntry_BoomBreakdown`, `api.v_UI_LaborEntry_JobTicketStatus` | Boom windows/pay and ticket expectation/status. |
| Refresh | `api.usp_UI_RefreshPayroll_FromNexGen` | Browser-triggered RawFMS + PayrollAPP refresh. |

## API/Web environment variables

The Web `.env.local` should not be shared directly. Share `.env.local.example`.

Expected variables:

```env
PAYROLL_API_BASE=http://localhost:5080
PAYROLL_API_KEY=REPLACE_WITH_LOCAL_API_KEY
PAYROLL_WEB_AUTH_SECRET=REPLACE_WITH_LOCAL_WEB_AUTH_SECRET
PAYROLL_WEB_COOKIE_SECURE=false
PAYROLL_WEB_USERS_JSON=REPLACE_WITH_LOCAL_USERS_JSON
```

The API config must use the same API key value that the Web UI sends through `PAYROLL_API_KEY`.

## Local Web build/run

Run from:

```powershell
cd C:\TCG\TCG.PayrollWeb\payroll-ui
```

Observed versions:

```text
Node.js v24.14.0
npm 11.9.0
Next.js 16.1.6
```

Commands:

```powershell
npm install
npm run build
npm run dev
```

Observed local URL:

```text
http://localhost:3000
```

Observed network URL:

```text
http://192.168.1.35:3000
```

## Known UI notes

- Update Special Saturday row badge wording from `Holiday: December Special Saturday` to `Special Saturday: December` or `December Special Saturday`.
- For Non-Union Admin Hourly selected labor entry WTL card, prefer `Not applicable` and `WTL rule does not apply to Non-Union Admin Hourly rows` instead of missing-token wording.
- For no-modifier rows, display modifier/boom add as `-` rather than `$0.00`.
- For zero entries/issues in summary cards, display `-` rather than `0` where that improves readability.
- Ledger/UI should distinguish `Final_Gross_Pay`, WTL-aware final-gross ledger total, and payable gross including subsistence.
