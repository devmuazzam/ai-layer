---
id: PAY-060
title: PAY-060 — Missing-data issues
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-060 — Missing-data issues

**Rule:** Create Error, Warning, Review, or Informational issue.

**Applies to:** All payroll records. **Trigger:** Required information is unavailable.
**Requires:** Rule-specific required fields.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-060` — baseline: *Existing baseline*
- **FRD** (target design): [09-data-quality-ledger-and-review.md](../erp-payroll-module-frd/09-data-quality-ledger-and-review.md) `PR-045` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §13

## Open

- **Blocking (matrix):** Confirm severity matrix
- **Exhibit-driven case (2026-06-09 message):** identical placeholder times in four customer-interval fields, and 24.00-hour per-person labor rows — both patterns need explicit severity in the issue matrix (flag? block? price with warning?). See PAY-017's exhibit.
