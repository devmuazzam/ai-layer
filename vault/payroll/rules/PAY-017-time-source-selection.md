---
id: PAY-017
title: PAY-017 — Time-source selection
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-017 — Time-source selection

**Rule:** Select authoritative source using configured priority and record source used.

**Applies to:** Labor entries. **Trigger:** Entry has one or more time sources.
**Requires:** Labor times; ticket times; schedule; source hours.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-017` — baseline: *Existing partial baseline*
- **FRD** (target design): [04-work-time-reconstruction.md](../erp-payroll-module-frd/04-work-time-reconstruction.md) `PR-012` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0

## Open

- **Blocking (matrix):** Confirm source priority
