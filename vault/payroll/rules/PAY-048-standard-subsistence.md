---
id: PAY-048
title: PAY-048 — Standard subsistence
section: F-contributions-other
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-048 — Standard subsistence

**Rule:** Add effective allowance as payable component.

**Applies to:** Eligible L12 employees. **Trigger:** Overnight/distance/equipment conditions are met.
**Requires:** Home yard; job; distance; overnight; equipment status.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-048` — baseline: *Existing token baseline*
- **FRD** (target design): [07-rest-meal-and-subsistence.md](../erp-payroll-module-frd/07-rest-meal-and-subsistence.md) `PR-037` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §11
- **Contract**: [travel](../mcog-l12-mla-2025-2028/INDEX.md)
- **Test cases**: [rule-examples-catalog.md](../rule-examples-catalog.md) — subsistence rows

## Open

- **Blocking (matrix):** Confirm structured eligibility
- **Conflict:** Trigger changes shape: legacy is **token-driven** (`SUB_SHORT`/`SUB_LONG`, amounts hard-coded); target is distance/overnight **conditions**. `SUB` collides as earnings + deduction code (C-19, `../source-attribution-and-conflicts.md`).
- **Client naming + ADP shape (big summary):** "sustenance pay… subsidized pay for spending the night away" — subsistence; goes to ADP as a **dollar amount only, no hours**, matching the crosswalk's `SUB` payable-only row.
- **Upstream capture mechanism identified (e-ticket item 8):** *"If Subsistence is applicable please click deficiency and note long or short sub in the comments"* — the origin of the `SUB_SHORT`/`SUB_LONG` tokens is a checklist deficiency-click plus free comment. The Atom app's structured Long/Short/N-A selection (US-17) replaces exactly this.
- **C-05 ANSWERED (08-20 SME + 08-21 minutes):** **short subsistence = $85/day, 45–77.5 mi, only days actually worked**; the union wording's obscured distinction is worked-days (short) vs calendar-days (long). The legacy token path and amounts stand; the trigger basis for the ERP is yard-to-job distance + holdover status.
