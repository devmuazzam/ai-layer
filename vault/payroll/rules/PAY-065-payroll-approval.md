---
id: PAY-065
title: PAY-065 — Payroll approval
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-065 — Payroll approval

**Rule:** Block approval for configured critical errors.

**Applies to:** Payroll period. **Trigger:** Review is complete.
**Requires:** Outstanding issues; approvals.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-065` — baseline: *Partial baseline*
- **FRD** (target design): [10-approval-close-export-and-adjustments.md](../erp-payroll-module-frd/10-approval-close-export-and-adjustments.md) `PR-053` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Management confirmation
- **FCC approval status now surfaces as a warning in Brian's app (2026-09-13, FYI).** FCC labor
  entries start *Pending* and are approved by checkbox; his app still calculates unapproved
  entries but flags *"FCC Not Approved… Review the FCC approval status before payroll is
  finalized"* on the web view and in the Excel recommendations. His own framing: *"not really
  something you need to worry about… in case it is relevant."* ERP equivalent is the ticket's
  completion/review state feeding the payroll worklist — this rule's own blocking item (approval
  levels) is unchanged. No action.
