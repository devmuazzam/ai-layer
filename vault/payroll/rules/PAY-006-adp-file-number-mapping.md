---
id: PAY-006
title: PAY-006 — ADP File Number mapping
section: A-foundation-source-data
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-006 — ADP File Number mapping

**Rule:** Preserve leading zeros; maximum six alphanumeric characters; enforce uniqueness.

**Applies to:** Employees exported to ADP. **Trigger:** Employee included in payroll export.
**Requires:** EmpID; ADP File Number; active status.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-006` — baseline: *Partial baseline*
- **FRD**: — *(matrix-only rule; no FRD counterpart — the FRD is Draft 0.1 and does not cover it)*
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Confirm CodingCops/ADP mapping design
