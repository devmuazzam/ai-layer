---
id: PAY-038
title: PAY-038 — Hazardous-material premium
section: D-weekend-holiday-shift
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-038 — Hazardous-material premium

**Rule:** Add configured premium to base for qualifying time.

**Applies to:** Eligible L12 labor. **Trigger:** Employee performs Level A or B regulated work.
**Requires:** Hazard level; work window; approval.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-038` — baseline: *New ERP requirement*
- **FRD** (target design): [06-boom-equipment-and-guaranteed-hours.md](../erp-payroll-module-frd/06-boom-equipment-and-guaranteed-hours.md) `PR-028` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: lattice/hazmat family — **not calculated by the legacy engine** (“Not calculated anywhere”)
- **Contract**: [02-article-iv-classifications-and-wage-rates.md](../mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md)

## Open

- **Blocking (matrix):** Confirm source and approvals
- **Conflict:** Into-the-rate vs on-top (see PAY-011) — MLA: hazmat “shall become the basic hourly rate”. Legacy never calculated it.
- **Into-rate reading adjudicated by contract verbatim — see PAY-011.**
