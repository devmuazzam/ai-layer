---
id: PAY-068
title: PAY-068 — Retroactive correction
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-068 — Retroactive correction

**Rule:** Calculate delta adjustment without rewriting original payroll.

**Applies to:** Previously processed payroll. **Trigger:** Historical rate/rule/source correction occurs.
**Requires:** Original snapshot; corrected data; affected periods.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-068` — baseline: *New ERP requirement*
- **FRD**: — *(matrix-only rule; no FRD counterpart — the FRD is Draft 0.1 and does not cover it)*
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Confirm correction workflow
