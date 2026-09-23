---
id: PAY-064
title: PAY-064 — Calculation run log
section: G-audit-review-export
status: open
updated: 2026-09-23
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-064 — Calculation run log

**Rule:** Preserve calculation-run audit history.

**Applies to:** All payroll runs. **Trigger:** Calculation starts or ends.
**Requires:** Run ID; period; version; counts; status.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-064` — baseline: *Existing baseline*
- **FRD** (target design): [10-approval-close-export-and-adjustments.md](../erp-payroll-module-frd/10-approval-close-export-and-adjustments.md) `PR-052` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Implemented

Retention was never the missing half — `payroll_runs` has always kept every run
(`@@unique([periodId, runNumber])`, a create-only write path, no delete anywhere). What was
missing was that **none of it was readable**: every period read took `runs: { take: 1 }`, so
only the newest run was reachable, and the audit screen was a "Coming soon" stub.

Shipped 2026-09-23:

- **The four columns** the rule requires, on `PayrollRun` — `status`, `engineVersion`,
  the counts (`employeeCount` / `issueCount` / `warningCount` / `errorCount`) and
  `completedAt`, plus `failureReason`. Additive migration
  `20260923010000_payroll_run_audit_log`; existing rows backfill to `COMPLETED`, which is
  what they are by construction.
- **The counts are persisted rather than discarded.** The calculation already computed them
  and returned them once. They are stored, not re-derived on read: they describe the run *as
  it executed*, and recomputing them later from the ledger answers a different question.
- **`status` is real, not near-constant.** The run row is opened `STARTED` in its own
  committed transaction *before* the engine runs, and finalised `COMPLETED` or `FAILED`.
  Previously the row was created alongside its figures, so a calculation that threw rolled
  the row back and left no trace — a log that could not record a failure.
- **`GET /payroll/periods/:id/runs`** — paged, newest first, every status. The `take: 1`
  reads stay, now filtered to `COMPLETED`: they mean "the figures in force", and since a
  failed run can hold the highest run number they would otherwise empty the worklist.
- **The audit page** (`/payroll/audit`) renders it, replacing the stub.

**`engineVersion` is a discipline, not a build stamp.** `PAYROLL_ENGINE_VERSION` in
`packages/payroll-engine/src/version.ts` names the *rule set* and is hand-bumped in the same
commit as any pay-rule change — the same commit that records that change's source in
[payroll-rules-provenance.md](../payroll-rules-provenance.md). `package.json`'s `0.0.1`
never moves and a git SHA identifies a build rather than a rule set, so neither answers the
question a retained run exists to answer. **Nothing enforces the bump.**

The **rounding-adjustment** half of PAY-069 remains closed — inapplicable; unrelated to this.

## Open

- **Blocking (matrix):** Confirm retention period — still open, and still owned by TCG. It
  blocks *pruning*, not exposing: nothing here deletes a run, and the read path above does
  not depend on the answer. Registered in [gaps.md](../gaps.md) as one of the 24 decisions
  ("the **record-retention period**").
- **Golden-week fixture available:** the client preserved a complete real processed week (July 25–31 workbook + `EPI4RZ32.csv` export, `sources/`). ERP acceptance: replay that week, diff the generated export against the preserved one — the strongest single end-to-end test the record offers.
- **Acceptance baseline reconciled:** the client's "~30 scenarios" = the `Examples_Catalog` sheet in `PayrollAPP_LABOR-LOGIC-EXAMPLES.xlsx` = the vault's 28-row catalog (same variations, same employees — Travis Garrett is the 08-20 WTL worked example). Baseline agreed by construction: 28 scenarios + the July 25–31 golden week.
