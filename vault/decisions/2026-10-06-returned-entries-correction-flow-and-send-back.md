---
title: "Returned Entries correction flow — Payroll sends back, Payroll Admin adjusts or forwards to employee — decision"
source: decision/Ali Riaz — developer direction in Claude Code session, 2026-10-06
decided: 2026-10-06
decided_by: >-
  Ali Riaz (CodingCops developer, git user devmohsinakram). Directed the restore of
  the Returned Entries tab and correction components that were removed in commit
  e431cc5f2 (the PAYROLL-FLAGS U1–U21 squash). The UI was working at commits
  0fc5cc14a and 25c415f2b0. The permission model was updated from the retired
  `crane-supervisor` to `payroll-admin`. This is a developer direction, not a
  client-side product decision.
status: reference
conflicts_with: []
related:
  - decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md
  - decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md
  - decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md
tags: [module/payroll, kind/decision, web, api, permissions]
entities: [PayrollSendBack, PayrollCorrection]
---

# Returned Entries — the correction flow

## The flow

1. **Payroll role** users view and edit payroll entries. They can **send entries back**
   to users with the **Payroll Admin** role.

2. **Payroll Admin** sees entries in the **Returned Entries** sidebar tab
   (`/payroll/corrections`). From there they can:
   - **Adjust the entry directly** — edit times, boom sessions, meals, craft modifier,
     and submit with a correction note. This is the same correction form the retired
     Crane Supervisor role used, gated by `can('payroll-admin', 'edit')`.
   - **Send the entry one step further back** to the actual employee (oiler, rigger)
     for adjustment.

3. **Employee** receives the returned ticket, adjusts it, and sends it back to the
   Payroll Admin.

4. **Payroll Admin** reviews and approves. After approval, the ticket is marked as
   **adjusted** (`CORRECTED` status).

## Permission model

| Action | Old (retired) | Current |
| --- | --- | --- |
| View Returned Entries | `crane-supervisor` | `payroll-admin` (view) |
| Adjust entries | `crane-supervisor` (edit) | `payroll-admin` (edit) |
| API access | `@RequirePermission('crane-supervisor', ...)` | `@RequirePermission('payroll', 'view')` |

The Crane Supervisor routing is superseded by
`decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md`.

## Send-back is crew-wide

A send-back returns the **whole ticket roster** (every crew member on that job ticket),
not a single employee. One `returnGroupId` ties all members together. This is the
PAYROLL-FLAGS REQ-25 pattern — not the old per-employee-to-supervisor routing.

## Sidebar

The **Returned Entries** item appears in the Payroll sidebar group. It navigates to
`/payroll/corrections`, which lists entries by status (open / corrected). Clicking an
entry opens the correction dialog or navigates to `/payroll/corrections/[id]`.

## Implementation (web)

| File | Role |
| --- | --- |
| `features/payroll-corrections/components/returned-entries-list.tsx` | List page |
| `features/payroll-corrections/components/correction-dialog.tsx` | Dialog wrapper |
| `features/payroll-corrections/components/correction-form.tsx` | Full-page form |
| `features/payroll-corrections/components/correction-times-section.tsx` | Time editing |
| `features/payroll-corrections/components/correction-meals-parts.tsx` | Meal editing |
| `features/payroll-corrections/components/correction-review-panels.tsx` | Preview panels |
| `features/payroll-corrections/hooks/use-payroll-corrections.ts` | React Query hooks |
| `features/payroll-corrections/lib/build-correction-payload.ts` | Payload builder |
| `features/payroll-corrections/lib/correction-times.ts` | Timezone conversion |
| `features/payroll/services/payroll-send-backs.service.ts` | API service + types |
| `components/sidebar/sidebar-routing.ts` | Sidebar route entry |
| `app/(protected)/payroll/corrections/page.tsx` | Route page |
| `app/(protected)/payroll/corrections/[id]/page.tsx` | Detail route page |

## What was restored and changed

The Returned Entries tab, all correction components, and the `correction-times.ts` lib
were deleted in commit `e431cc5f2`. They were restored from commits `0fc5cc14a` and
`25c415f2b0` with two changes:

1. **Permission**: `can('crane-supervisor', 'edit')` → `can('payroll-admin', 'edit')`
   in `correction-dialog.tsx`.
2. **Supervisor guard removed**: `returned-entries-list.tsx` had an `isSupervisor`
   guard that said "Returned Entries are for Crane Supervisors" — removed because the
   API gates access via `@RequirePermission('payroll', 'view')`.

The `next.config.ts` redirect that blocked `/payroll/corrections` was also removed,
and the guard test `returned-entries-retired.test.mjs` was deleted.
