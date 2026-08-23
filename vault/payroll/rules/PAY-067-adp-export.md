---
id: PAY-067
title: PAY-067 — ADP export
section: G-audit-review-export
status: conflicted
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-067 — ADP export

**Rule:** Validate mappings and generate export-ready records.

**Applies to:** Approved employees/pay period. **Trigger:** Export is requested.
**Requires:** ADP ID; earning codes; hours; amounts.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-067` — baseline: *New ERP requirement*
- **FRD** (target design): [10-approval-close-export-and-adjustments.md](../erp-payroll-module-frd/10-approval-close-export-and-adjustments.md) `PR-055` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Confirm ADP file specification
- **Conflict:** Assumes API submission; `../adp-read-write-boundary-2026-08-18.md` says payroll-output write is **Marketplace-partner-gated** (`pay-data-input.modify` path). Confluence “Payroll management” page (US/PAY-WP ids) staged in `../../sync/.conflict/2026-08-24-bootstrap/payroll-management.md`.
