---
title: "A payroll calculation run records the rates and settings in effect and the ticket data it used — not only an engine version — decision"
source: decision/Syed Haris (CodingCops) — review of PR #656 (PAY-064 calculation run log, Linear TCG-171)
decided: 2026-09-24
decided_by: >-
  Syed Haris (syed.haris, CodingCops), in review of PR #656
  (https://github.com/TheCraneGuys/craneguys-platform/pull/656), 2026-09-24. He stated
  this is his decision and that client sign-off is not needed. It is a CodingCops design
  decision on how the ERP satisfies an FRD requirement; TCG may still overrule it.
status: verified
supersedes: []
conflicts_with: []
resolves: [PAY-064]
tags: [module/payroll, kind/decision, audit, payroll-rules, effective-dating]
entities: []
---

# Decision

What a payroll calculation run records as its **"version"** (PAY-064 *"version"*; FRD PR-052
*"source-data version"* and *"configuration version"*) is:

1. **Configuration in effect** — the union/craft rates and pay settings that were in effect for
   the week being calculated, as the run used them.
2. **Source data used** — which ticket/source data the run calculated from: the tickets included,
   and each one's last-changed time.

An engine code version on its own does **not** satisfy this. It may be recorded in addition, but
it is not the answer to *"what version was this run?"*

Syed Haris, verbatim:

> eventually the rules will stay the same, so we need to show the union rates and pay settings in
> effect at the time, plus which ticket data it used, as if the craft code rate is updated on
> july 1 so it shouldn't affect the salary of june 30 and before.

# Why

- **The rule set stops moving; the inputs never do.** Once the pay rules settle, an engine version
  stays constant across every run and distinguishes nothing. What makes two runs of the same
  period differ is a changed rate or setting, or a changed ticket. A run log that cannot say which
  of those it saw cannot explain a changed number.
- **A rate change must not reach backwards.** A craft code rate updated on July 1 must not alter
  pay for June 30 and before. Calculating with the right rate is already handled — see below —
  but the *record* of the run has to show which rate it used, so a later reader can confirm that.
- **It is what the FRD asks for.** PR-052 lists *source-data version* and *configuration version*
  as two separate items; neither is a code version.

# Context — what this is and is not about

- **Per-day rate selection already works.** `CraftCodeRate` is effective-dated
  (`effectiveFrom` / `effectiveTo`); `findRateInForce(craftCodeId, date)` in
  `apps/api/src/service/craft-codes/craft-codes.repository.ts:160` returns the rate in force on
  a given date. This decision does not change calculation — it is about the run **recording**
  what it used.
- **PR #656 as submitted does not meet it.** Its `engineVersion` column carries a hand-bumped
  `PAYROLL_ENGINE_VERSION` (`packages/payroll-engine/src/version.ts`) that names the rule set.
  That is at most a supplement; the configuration and source-data records are still to build.
- **Not decided here — employee craft-assignment history.** Whether an employee's *craft
  assignment* becomes effective-dated remains open:
  [payroll/gaps.md → *Craft assignment has no history*](../payroll/gaps.md#craft-assignment-has-no-history).
  This decision records the rate *for* a craft; which craft an employee held on a date is that
  gap's question.

# Sources this matches

- FRD [payroll/erp-payroll-module-frd/10-approval-close-export-and-adjustments.md](../payroll/erp-payroll-module-frd/10-approval-close-export-and-adjustments.md)
  §22 PR-052 — every calculation run records *source-data version* and *configuration version*
  (status: unverified FRD; target design).
- Context only, not a commitment:
  [meetings/transcripts/2026-09-02-erp-job-tickets-and-payroll.md](../meetings/transcripts/2026-09-02-erp-job-tickets-and-payroll.md)
  25:28–26:26 — Brian Petros asks for craft-code history per employee; Corrina Bustos likens it
  to ADP's automatic change history (*"the date it was changed and what was changed"*).

# Effect on the vault

- [`payroll/rules/PAY-064-calculation-run-log.md`](../payroll/rules/PAY-064-calculation-run-log.md)
  — **not edited by this pass** (a rule file's body is outside the recording agent's write scope).
  Needs a pointer under **Open**: *"Version = configuration in effect + source data used — see
  this note; PR #656's `engineVersion` alone does not meet it."* Its `status: open` stays open
  (retention period, and this note's build work).
- No file is verified or superseded by this decision; no frontmatter changed.
- [`payroll/gaps.md#craft-assignment-has-no-history`](../payroll/gaps.md#craft-assignment-has-no-history)
  — untouched; still open.
