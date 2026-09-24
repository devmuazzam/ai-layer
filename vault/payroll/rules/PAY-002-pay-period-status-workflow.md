---
id: PAY-002
title: PAY-002 — Pay-period status workflow
section: A-foundation-source-data
status: open
updated: 2026-09-23
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-002 — Pay-period status workflow

**Rule:** Track Open, Calculated, Review, Approved, Exported, Closed, and Reopened statuses.

**Applies to:** All payroll periods. **Trigger:** Period creation, calculation, approval, export, or close.
**Requires:** Period dates; status; user; timestamp.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-002` — baseline: *Partial baseline*
- **FRD** (target design): [02-payroll-period-and-source-data.md](../erp-payroll-module-frd/02-payroll-period-and-source-data.md) `PR-002` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0

## Implemented — the two halves that did not need the missing statuses

Two of this rule's requirements were buildable without touching the enum, and shipped
2026-09-23:

- **User and timestamp on every status change.** `PayrollPeriod.statusChangedAt` /
  `statusChangedById`, additive migration `20260923000000_payroll_period_status_audit`.
  `updatePeriodStatus` now takes the acting user and stamps both on every transition —
  `PayrollEmployeeWeek.approvedAt`/`approvedById` already did this for a week; the period
  now carries the same pair.
- **The web's derived "Closed" deleted.** `payroll-format.ts` used to read a period's
  position in the list — "the newest EXPORTED row is Submitted, an older one is Closed" —
  and relabel itself the moment a later period exported, with nothing about that period
  having changed. It is gone. This was correct regardless of the blocking question below:
  a real `CLOSED` state still would not be *derived from list position*, and if it never
  ships the label was simply false either way.
- **The web's hand-rolled status union replaced.** `apps/web/.../payroll.service.ts`
  re-declared `PayrollPeriodStatus` as a string literal union nothing checked against
  Prisma's. It now imports the real `@tcg/shared` enum, held to Prisma's copy by
  `apps/api/src/usecase/payroll/payroll-status.parity.ts` — a compile-time assertion that
  fails `@tcg/api:build` if the two ever name different members, rather than a client
  silently rendering a status it has never heard of.

## Open

- **Blocking (matrix):** Management approval workflow
- **Operational window (client big summary):** union payroll must be **completed by the Wednesday** after the Friday week-end; Corrina distributes checks **Thursday**. Consistent with the live ADP schedule's six-day close-to-pay gap. The ERP's processing pipeline has a hard Sat–Fri → Wed deadline.
- **Built shape is narrower than this rule (verified 2026-09-04):** `PayrollPeriodStatus` in `apps/api/prisma/schema.prisma:200-206` is `OPEN · CALCULATED · REVIEW · APPROVED · EXPORTED` — **`Closed` and `Reopened` do not exist**. Five of the seven statuses this rule names are built, and the two missing ones are exactly the two the client's 2026-09-04 correction question needs.
