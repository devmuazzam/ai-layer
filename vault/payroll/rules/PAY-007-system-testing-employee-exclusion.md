---
id: PAY-007
title: PAY-007 — System/testing employee exclusion
section: A-foundation-source-data
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-007 — System/testing employee exclusion

**Rule:** Exclude from production payroll review and export.

**Applies to:** System, vendor, and placeholder records. **Trigger:** Worklist or export generated.
**Requires:** Employee CraftCode/payroll group.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-007` — baseline: *Existing TCG design*
- **FRD**: — *(matrix-only rule; no FRD counterpart — the FRD is Draft 0.1 and does not cover it)*
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Confirm exclusion codes
