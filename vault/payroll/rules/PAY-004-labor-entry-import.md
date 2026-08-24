---
id: PAY-004
title: PAY-004 — Labor-entry import
section: A-foundation-source-data
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-004 — Labor-entry import

**Rule:** Preserve source record and create payroll calculation input.

**Applies to:** Employees with labor. **Trigger:** Labor entered or source data refreshed.
**Requires:** Employee; date; time; hours; job; WO; ticket; craft; modifier; comments; rate.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-004` — baseline: *Existing baseline*
- **FRD** (target design): [02-payroll-period-and-source-data.md](../erp-payroll-module-frd/02-payroll-period-and-source-data.md) `PR-004` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0

## Open

- **Blocking (matrix):** Confirm source ERP tables
- **Entry-duration cap, client message 2026-06-09 (follow-up):** the legacy app handles **≤ 23.5 hours per labor entry** — a hard limit of the date/time reconstruction. Longer work must be **split into back-to-back entries**, each < 23.5 h. In no vault document before this message. ERP import validation must either enforce the cap + split convention (FCC-migrated data) or represent long spans natively (ERP-born entries have real timestamps).
- **Source-table choice + rationale (client message, 2026-08-24 batch):** FCC has **two** labor tables. `LABOR_PAYROLL` = raw pre-processed hours — **this is the source** (the extract's feed is literally `src.FMS_LABOR_PAYROLL_Raw`). `LABOR_DETAILS` = FCC's own processed/approved output after Corrina's weekly "process/approve" — **rejected as inaccurate**: FCC's proprietary split cannot produce the five buckets (it only has ST/OT/DT), and FCC has no configuration for several union rules. The vault's total silence on `LABOR_DETAILS` is now explained: it was rejected, not overlooked. The ERP must read raw labor, never FCC's processed output.
- **Payable ≠ billable, stated as a principle (same exhibit):** the drug-test hours are paid but not billed to the customer. The field-ops side already encodes it — Atom US-18: *"Labor time is not restricted solely to customer-billable ticket time where legitimate employee work occurs outside the customer-billable period."* The ERP needs the seam explicit: labor entries carry payroll truth; billing derives its own view.
- **Entered-vs-derived mismatch (same exhibit):** FCC shows *Hours Worked 15.00* vs *Derived Hours 14.50* on one entry — a concept in no vault document until now. Import validation must compare entered totals against derived (start/end) hours and flag the delta.
- **The billing-side taxonomy now exists:** [accounting/2026-07-invoicing-adjustment-taxonomy.md](../../accounting/2026-07-invoicing-adjustment-taxonomy.md) (Tia & Micaela) — company-caused delays deduct from the invoice, customer-caused don't, training bills extra. Payroll pays in every case; the seam is now specified on both sides.
