---
id: PAY-014
title: PAY-014 — Rate comparison and validation
section: B-group-and-rate
status: conflicted
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-014 — Rate comparison and validation

**Rule:** Flag missing, zero, expired, duplicate, or materially different rates.

**Applies to:** All paid labor. **Trigger:** More than one rate source exists or rate is missing.
**Requires:** Source rate; craft rate; modifier; employee rate.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-014` — baseline: *Existing partial baseline*
- **FRD** (target design): [03-payroll-groups-and-rate-determination.md](../erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md) `PR-011` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §13
- **SQL**: `app.usp_Apply_BasePay_Fallback_FromSource`
- **Test cases**: [rule-examples-catalog.md](../rule-examples-catalog.md) — rate-review + suppressed-pay rows

## Open

- **Blocking (matrix):** Confirm tolerance thresholds
- **Conflict:** Legacy **suppresses pay to $0** on missing/zero source rate (§13); the kept set only **flags** (this rule + PAY-060). Nobody has decided which behaviour ships. Rate-truth history: `Source_Rate_Raw` demoted to audit-only per the FRD part-03 migration note.
- **As-built semantics confirmed, client message 2026-06-09 (Brian Petros — payroll-group determination + FCC profile screenshot) + extract §13:** `Source_Rate_Raw` is **audit/reference only**; when priced-but-$0 a **duration-weighted fallback** fills gross (`Source_Rate × (ST + 1.5·OT + 2·DT)`, with warning); only when **no** source rate exists is pay suppressed to $0 (≈5,725 rows in "Unknown / Needs Review"). The ERP decision is which of fallback / suppress / flag-only survives.
