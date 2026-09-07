---
id: PAY-017
title: PAY-017 — Time-source selection
section: C-time-and-premium
status: open
updated: 2026-09-07
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
- **Exhibit (client message 2026-06-09, "creative-magic" FYI):** Job `OM58178` / ticket `45888`, Sat 2026-06-06 — three sources on one ticket: customer-recorded intervals → **0.00 h** (placeholder 2:00 PM in four fields), workflow timestamps → **0.98 h** (rolling into 6/7 — cross-midnight), labor rows → **24.00 h × 2 employees = 48.00 h**. Not previously in the vault.
- **Sharpened blocking question:** the legacy engine has **no configured source-priority mechanism** — its actual behaviour is *punches when usable, else hours + assumed 06:00 start* (extract, "Shift assumed"). "Configured priority" is a new ERP design. For the exhibit: which of 0.00 / 0.98 / 24.00-per-person should the ERP have selected, and what gets flagged vs priced?
- **Paid span confirmed on the record (2026-09-03 call — Kyle Harlow, Joe Schacatano, Corrina
  Bustos):** paid time starts at the **dispatch start time at the yard** (pre-trip is paid; the crane
  leaves 15–30 min later) and ends when the crane is **back at the yard, fuelled, parked and the
  paperwork done**, rounded up to the next 30 minutes. Decision note [../../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md);
  notes [../../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md](../../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md) §3. The ERP's schedule fields (start · on-site · estimated job end)
  were confirmed as the right set.
