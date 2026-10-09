---
title: "Midnight split display — overnight entries show as two rows in weekly payroll view — decision"
source: decision/Ali Riaz — developer direction in Claude Code session, 2026-10-06
decided: 2026-10-06
decided_by: >-
  Ali Riaz (CodingCops developer, git user devmohsinakram). Directed the restore of
  midnight-split display that was accidentally removed in commit e431cc5f2 (the
  PAYROLL-FLAGS U1–U21 squash). The behaviour was working at commit 0fc5cc14a and
  commit 25c415f2b0. This is a developer direction, not a client-side product decision.
status: reference
conflicts_with: []
tags: [module/payroll, kind/decision, web, display]
entities: [PayrollJobDay, PayrollPricingSlice]
---

# Midnight split display — overnight entries show as two rows

When a job ticket's labor entry spans midnight (e.g. 6 PM Sep 5 → 6 AM Sep 6), the
weekly payroll employee view (`/payroll/:id`) displays it as **two separate table rows**,
one per calendar date, split at midnight. Each row shows that date's share of actual
hours, payable hours, hour-type buckets (ST/OT/DT/H2X/H3X) and pay.

## Rules

1. **Split at midnight in the payroll timezone** (`PAYROLL_TIMEZONE`,
   America/Los_Angeles). The engine's `dateSplits` field on each `PayrollJobDay`
   carries the per-date breakdown from the server; the display never recomputes it.

2. **One entry, two rows.** The two rows share the same `PayrollJobDay.id` — they are
   the same priced entry. `tableId` (the React key) is `datePartKey(id, date)` for
   split rows, so each row can expand independently.

3. **Send-back treats splits as one ticket.** `onSendBack` uses `day.jobTicketId`,
   which is the same on both rows. A crew-wide send-back returns the whole ticket
   roster, not one date.

4. **Entry selection for calc panels.** `onSelect(day.id)` selects the same entry
   from either row. The Calculation Panels show the whole entry's pricing breakdown.

5. **Daily summary cards.** `payableHoursOnDate()` reads `dateSplits` and attributes
   each date's hours correctly. An entry that crosses the period boundary attributes
   overflow hours to the anchor date.

6. **Stale entries are not split.** An entry whose ticket has been corrected
   (`CORRECTED`, `RESPONDED`, `RESUBMITTED` status on its send-back) is marked stale
   and displayed as a single row, because the split figures may no longer match the
   corrected data.

## Implementation (web)

| File | Role |
| --- | --- |
| `features/payroll/services/payroll-date-split.types.ts` | `PayrollJobDayDates` — the `dateSplits` field on `PayrollJobDay` |
| `features/payroll/lib/payroll-entry-split.ts` | `splitEntryByDate()` — splits one entry's totals across date rows |
| `features/payroll/lib/payroll-date-rows.ts` | `jobDayDateRows()`, `payableHoursByDate()` — per-date row data |
| `features/payroll/lib/payroll-timesheet-rows.ts` | `timesheetRows()`, `TimesheetRow`, `TableJobDay` — the row builder |
| `features/payroll/components/payroll-job-day-dates.ts` | `timesheetRowsOf()`, `tableJobDaysFromRows()` — the bridge |
| `features/payroll/hooks/use-payroll-employee.ts` | `tableEntries` / `shownTableEntries` — calls `timesheetRowsOf` |
| `features/payroll/components/payroll-employee-table.cells.tsx` | `CELL_RENDERERS` — checks `day._part` for split-specific values |

## Why this was restored

Commit `e431cc5f2` (PAYROLL-FLAGS U1–U21 squash) deleted the split display files and
rewired the hook to use the non-split `splitJobDaysForTable()`. The table was rewritten
for PAYROLL-FLAGS features between `0fc5cc14a` and HEAD, so a wholesale revert was not
possible. Instead, `TableJobDay` was extended with optional `_part` / `_split` / `_dates`
fields, and `CELL_RENDERERS` was updated to check `_part` — existing non-split code
works unchanged while split-aware rendering activates when `_part` is present.
