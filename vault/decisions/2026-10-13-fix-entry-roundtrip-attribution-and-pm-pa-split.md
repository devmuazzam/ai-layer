---
title: "Fix entry round-trip — PM/PA split, cumulative Changes with per-row attribution — decision"
source: decision/Ali Riaz — developer direction in Claude Code session, 2026-10-13
decided: 2026-10-13
decided_by: >-
  Ali Riaz (CodingCops developer, git user devmohsinakram). Answered the 17
  blocking questions raised by tcg-elaborator for the fix-entry round-trip spec
  on 2026-10-13 in a Claude Code session. This is a developer direction
  answering gaps in the existing correction flow, not a client-side TCG
  product decision.
status: reference
conflicts_with: []
related:
  - decisions/2026-10-06-returned-entries-correction-flow-and-send-back.md
  - decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md
tags: [module/payroll, kind/decision, web, api, permissions, data-model]
entities: [PayrollSendBack, PayrollCorrection, PayrollEntryFix]
---

# Fix entry round-trip — the decision

Fix entry on Weekly Payroll becomes a two-choice action for the Payroll Manager,
and the Changes list on an entry shows every change attributed to its author
across every round of correction.

## The flow

**Payroll Manager (`payroll:edit`) has two options per entry on Weekly Payroll:**

1. **Fix entry** — opens the correction popup. PM edits directly; the change is
   immediate and no hand-off happens.
2. **Send Back To Payroll Admin** — hands the entry to PA via the existing
   `PayrollSendBack` mechanism.

While a send-back is in state `SENT_BACK`, `RESPONDED`, or `RESUBMITTED`, the PM
is **locked out** of editing that entry. PA edits in the Returned Entries page
(`/payroll/corrections`). When PA marks the entry `CORRECTED`, PM can edit it
again or re-send. The cycle can repeat indefinitely.

**PM can withdraw an open send-back at any time** to reclaim the entry. The
Withdraw button is visible to anyone with `payroll:edit`.

**Payroll Admin (`payroll-admin:edit`) only acts on returned entries** — PA
never initiates a correction.

## Permissions

Lowered to `payroll:edit`:

- `POST /payroll/periods/:id/tickets/:ticketId/send-back` (preview + send)
- `POST /payroll/send-backs/:id/withdraw`
- All four `/payroll/.../entry-fixes/...` endpoints (already shipped Stage 1)
- `GET/POST/PATCH /payroll-corrections/:id` and preview
  (already shipped Stage 1)

Stays `payroll-admin:edit`:

- `POST /payroll/send-backs/:id/close` — PA closes the loop
- `send-to-employee` — unchanged, employee-leg workflow

## Attribution — role is derived from the page

Each write carries a client `role` hint. The role is determined by the page
the user clicked from:

- Weekly Payroll → `Payroll Manager`
- Returned Entries → `Payroll Admin`
- Mobile reply / resubmit (employee leg) → `Employee`

The server validates that the authenticated user actually holds the permission
that role requires; it does not warn on role mismatch when a user holds both.

### Enum (amendment, 2026-10-13, after original note was committed)

The log row's `authorRole` is a Prisma enum, not a free string:

```prisma
enum AuthorRole {
  PAYROLL_MANAGER
  PAYROLL_ADMIN
  EMPLOYEE
}
```

The schema carries **both**: `authorRole AuthorRole` (for filtering) and
`authorRoleLabel VARCHAR` (the human-readable string resolved at write time).
PM/PA rows store `"Payroll Manager"` / `"Payroll Admin"` on `authorRoleLabel`;
`EMPLOYEE` rows store the employee's **craft code label** at write time (e.g.
`"Oiler"`, `"Rigger"`, `"Operator"`) rather than the generic `"Employee"`, so
the Changes list reads naturally to a Payroll Admin reviewing a mobile reply.

U1 writes PA/PM rows only; the `EMPLOYEE` branch lands with the employee
write path (U2 or whichever unit wires the mobile-reply log).

## Changes list — cumulative across every round and every path

Each row in the Changes list stores author name, author role, and timestamp,
and renders them in the UI.

Rows written before this feature ships display a grey **Legacy** chip because
no author was captured. The old JSON `correctionChanges` column is **not
backfilled**.

## Data model

A new table (name to be set by `tcg-decomposer`, working name
`payroll_correction_change_log`):

- **Entry triple** for the unified timeline:
  `(tenantCompanyId, periodId, employeeId, ticketId)`
- **Source reference** — two nullable FKs (`sendBackId` XOR `entryFixId`), plus
  a DB `CHECK` constraint enforcing the XOR
- **Author snapshot**: `authorId`, `authorName`, `authorRole` (strings written
  at the time of the change, never joined back)
- **Change fields**: `changedAt`, `round`, `field`, `label`, `before`, `after`

The existing `correctionChanges` JSON column is not migrated.

## Scope boundaries

- **No change** to the employee-leg workflow (`SENT_BACK` → employee responds →
  `RESPONDED`). Employee replies still route to PA via Returned Entries.
- **No change** to `close` — stays PA-only.
- **No automation** of role conflicts — if a user has both permissions, the
  page they are on defines their role.
- **No historical backfill** of old `correctionChanges` JSON data.

## Why

This unifies the two existing correction paths — the send-back-based
`CorrectionDialog` and the direct-edit `EntryFixView` — behind a routed PM
choice that fits the Payroll Manager workflow, and gives the Changes list the
author trail an audit needs. The 2026-10-06 note only covered the
PA → employee → PA leg; this adds the PM-initiated hand-off path and the
per-row attribution the earlier design left open.

## Effect on the spec

- `.ai/aidlc/UNRANKED-fix-entry-roundtrip-attribution/spec.md` — once this
  note lands on main, the ticket owner flips the elaborator's `[VERIFIED*]`
  markers on the 17 answered requirements to `[VERIFIED]` and cites this
  file in each.

## Effect on the vault

No existing vault file is superseded. This note stands alongside the 2026-10-06
Returned Entries decision, which it extends rather than replaces.

## Addendum (2026-10-13, after U1 implementation)

The `AuthorRole` enum shipped with U1 carries a third member, `EMPLOYEE`, held
in reserve for the crew's own replies on the unified timeline (REQ-01 across
both paths). The enum backs filtering; the display string lives in a sibling
column `authorRoleLabel` (VARCHAR), which stores:

- `"Payroll Manager"` for `PAYROLL_MANAGER`,
- `"Payroll Admin"` for `PAYROLL_ADMIN`,
- the author's craft-code label (e.g. `"Oiler"`, `"Rigger"`) for `EMPLOYEE`.

The label is snapshotted at write time, so later permission or craft-code
changes do not rewrite history. U1 writes PM / PA rows only; the employee leg
is a later unit.
