---
title: "Adjust Entries is one correction popup for every entry — direct-mode corrections for never-returned entries — decision"
source: decision/developer direction in Claude Code session, 2026-10-22 (approved by the product owner)
decided: 2026-10-22
decided_by: >-
  Directed in a Claude Code session on 2026-10-22 (branch
  `fix/payroll-adjust-entries-missing-period-id`) and approved by the product owner the
  same day. Reverses the PM-from-Weekly-Payroll / PA-from-Returned-Entries split of
  `decisions/2026-10-13-fix-entry-roundtrip-attribution-and-pm-pa-split.md` for the
  *popup*, not for the roles: both the Payroll Manager (`payroll:edit`) and the Payroll
  Admin (`payroll-admin:edit`) still reach it. A developer direction, product-owner
  approved; `status: reference` on the same basis as the 2026-10-06 and 2026-10-13 notes
  it adjusts.
status: reference
conflicts_with: []
related:
  - decisions/2026-10-13-fix-entry-roundtrip-attribution-and-pm-pa-split.md
  - decisions/2026-10-06-returned-entries-correction-flow-and-send-back.md
tags: [module/payroll, kind/decision, web, api, payroll-review]
entities: [PayrollCorrection, PayrollSendBack, PayrollEntryFix]
---

# One Adjust Entries popup for every entry

## Decision

**Adjust Entries on Weekly Payroll opens the same correction popup (`CorrectionDialog`,
`apps/web` `features/payroll-corrections`) for every entry** — a returned entry (which has
a `PayrollSendBack` record) and a never-returned entry alike.

- A **returned entry** opens by its send-back id, exactly as before.
- A **never-returned entry** opens by its address `(periodId, ticketId, employeeId)` and
  runs the correction flow in a new **direct mode**: the same view, preview and submit
  (times, boom brackets, meals, the rule checks), but with no send-back record. The reason
  / employee-note / send-to-employee UI does not render (there is no send-back).

On submit of a never-returned entry, the backend applies the identical ticket-time and
`ticketEmployee` edits inside one transaction, and — because there is no send-back to close
— writes a `PayrollEntryFix` audit row instead and queues the period recalculation as an
`ENTRY_FIX`. Returned-entry behaviour is unchanged (byte-for-byte when a send-back id is
present).

New backend endpoints on `PayrollCorrectionsController` (all `@RequirePermission('payroll',
'edit')`, so PM and PA both reach them):

- `GET  payroll-corrections/entry/periods/:periodId/tickets/:ticketId/employees/:employeeId`
- `POST payroll-corrections/entry/periods/:periodId/tickets/:ticketId/employees/:employeeId/preview`
- `PATCH payroll-corrections/entry/periods/:periodId/tickets/:ticketId/employees/:employeeId`

## Why

The 2026-10-13 split used two different popups: the returned-entry `CorrectionDialog` for
PA, and a separate `EntryFixDialog` (on the `payroll-entry-fixes` subsystem) for PM editing
a never-returned entry from Weekly Payroll. Two popups for one action is confusing and
double-maintained. This unifies the popup so every entry is adjusted through the correction
flow, keeping the richer correction UI (boom brackets, meals, flag resolution) for entries
that were never returned.

## What this reverses

It reverses the **popup** half of
`decisions/2026-10-13-fix-entry-roundtrip-attribution-and-pm-pa-split.md`: PM no longer
opens a distinct entry-fix dialog from Weekly Payroll. The **role** split is intact — PM
edits from Weekly Payroll, PA from Returned Entries, and the send-back round-trip and
lock-out are unchanged.

## Deferred follow-up

The **`payroll-entry-fixes` backend module is left in place, dormant** (its web dialog tree
is removed). Retiring that backend module — controller, usecase, repository and the
`PayrollEntryFix` writes it still owns elsewhere — is a follow-up, deliberately out of scope
here to limit blast radius. `PayrollEntryFix` rows are still written (now by the direct-mode
correction path), so the model and its audit/history reads stay.

## Effect on the vault

No file's status changes. This adjusts two `reference`-level notes at the same level; no
verified decision is superseded.
