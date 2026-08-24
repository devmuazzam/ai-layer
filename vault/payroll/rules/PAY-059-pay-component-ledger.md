---
id: PAY-059
title: PAY-059 — Pay-component ledger
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-059 — Pay-component ledger

**Rule:** Store each amount as a separate explainable component.

**Applies to:** All calculated payroll. **Trigger:** Any earning or adjustment is calculated.
**Requires:** Hours; rate; multiplier; amount; rule; source.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-059` — baseline: *Existing strong baseline*
- **FRD** (target design): [09-data-quality-ledger-and-review.md](../erp-payroll-module-frd/09-data-quality-ledger-and-review.md) `PR-048` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §14
- **SQL**: pay-component ledger objects — `../legacy-payroll-app-db-extract/sql-object-index.md`

## Open

- **Blocking (matrix):** Confirm ERP component taxonomy
- **The bucket model, confirmed (client, after a live correction dance):** **five buckets** for total-hours split — ST · OT · DT · Holiday 2× · Holiday 3× (client's "triple time = holiday triple time" retraction) — plus the **long-boom parallel set** (LB REG/OT/DBL[/TRI]) and **rule-added hours** (guarantees — "not actual work time"). Matches the extract's ADP sheet columns exactly (Reg · OT · DT · Holiday 2x · Holiday 3x · LB REG/OT/DBL/TRI).
- **Reporting purpose confirmed by the client:** "categorized/accounted for any/all results of each rule separately… can report how much each rule increased payroll" — the per-component ledger design goal, which this vault has already exercised (the −$669k WTL-deduct total came straight from component sums).
