---
title: "After a failed recalculation, payroll shows the last successful run with a warning and blocks approve/export until it succeeds or the manager confirms — decision"
source: decision/Syed Haris (CodingCops) — review of PR #656 (PAY-064 calculation run log, Linear TCG-171)
decided: 2026-09-24
decided_by: >-
  Syed Haris (syed.haris, CodingCops), in review of PR #656
  (https://github.com/TheCraneGuys/craneguys-platform/pull/656), 2026-09-24. He stated
  this is his decision and that client sign-off is not needed. It deliberately departs from
  the legacy app's behaviour; TCG may still overrule it.
status: verified
supersedes: []
conflicts_with: []
resolves: [PAY-064]
tags: [module/payroll, kind/decision, audit, approval, export, recalculation]
entities: []
---

# Decision

When the latest recalculation of a pay period **fails**:

1. **The worklist keeps showing the last successful run's numbers**, with a clear warning that the
   latest recalculation failed — stating **when** it failed and **which run** the numbers shown
   come from.
2. **Approve and export are blocked** until either
   - a recalculation succeeds, **or**
   - the payroll manager **explicitly confirms** proceeding with the previous numbers.
3. **The failed attempt and its reason appear on the audit log.**

# Why

The legacy app resolves the "current" run by silently taking the newest `Succeeded` run
([payroll/legacy-payroll-app-db-backup-2026-09-07/sql/api/usp_ResolveAuthoritativePayrollRun.PROC.sql](../payroll/legacy-payroll-app-db-backup-2026-09-07/sql/api/usp_ResolveAuthoritativePayrollRun.PROC.sql)
L106–128: `WHERE r.Status = 'Succeeded' … ORDER BY r.EndedAtUTC DESC`). A failure is therefore
invisible: payroll can be approved and exported on figures that predate the data the failed
recalculation was meant to pick up, and nobody is told.

Syed Haris chose not to copy that, in his words: the legacy app *"is only a source, but if we can
propose a better solution we should."* Showing the last good numbers keeps the worklist usable;
the warning and the approve/export block stop stale figures going out unnoticed; the explicit
manager confirmation keeps a deliberate override possible without making it the silent default.

# Context

- [meetings/transcripts/2026-06-09-payroll-app-demo-01.md](../meetings/transcripts/2026-06-09-payroll-app-demo-01.md)
  19:55 — Brian Petros on the Refresh button: it *"pulls in new information and recalculates
  it"*, and only the payroll manager may trigger it. Context only, not a commitment.
- PR #656 as submitted keeps the "figures in force" reads filtered to `COMPLETED`, so a failed run
  no longer empties the worklist, and records `FAILED` runs with `failureReason`. That covers the
  audit-log half (point 3, provided the page surfaces the reason). It does **not** yet show the
  failure warning on the worklist, and does **not** block approve/export — points 1 and 2 are
  still to build.

# Effect on the vault

- [`payroll/rules/PAY-064-calculation-run-log.md`](../payroll/rules/PAY-064-calculation-run-log.md)
  — **not edited by this pass** (a rule file's body is outside the recording agent's write scope).
  Needs a pointer under **Open**: *"Failed recalculation — last good run shown with a warning;
  approve/export blocked until success or manager confirmation — see this note; PR #656 meets
  only the audit-log part."*
- No file is verified or superseded by this decision; no frontmatter changed. No existing gap
  entry covered this question.
