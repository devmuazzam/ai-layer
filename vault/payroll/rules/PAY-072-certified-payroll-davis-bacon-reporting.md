---
id: PAY-072
title: PAY-072 — Certified payroll / Davis-Bacon reporting
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-072 — Certified payroll / Davis-Bacon reporting

**Rule (scope open):** certified-payroll jobs need prevailing-wage handling and certified reporting. Legacy scoped it out; matrix and FRD have no rule; the 2026-08-06 meeting says the vault has **no labor-compliance coverage at all**.

## Sources

- Meeting 2026-08-06 (certified payroll / labor compliance) — `module/payroll` tagged
- [2026-08-07-labor-compliance-certified-payroll.md](../../meetings/2026-08-07-labor-compliance-certified-payroll.md) — curated write-up

## Open

- **Blocking:** decide the owning module (payroll vs a compliance module) and whether quote-level flags (PAY-CC/quotation side) drive it. Currently **nobody owns this**.
- **New evidence, client message 2026-06-09 (Brian Petros — payroll-group determination + FCC profile screenshot):** the FCC employee profile carries a **"Certified Pay" checkbox** (screenshot) — a per-employee certified-pay flag exists upstream today and appears in **no vault document**. Whoever scopes this module should start from what that flag actually drives in FCC.
- **Third demand signal (accounting wishlist, July 2026):** the accounting team's ERP list names certified payroll, Davis-Bacon **and prevailing wage** under *Payroll Integration* — the third independent constituency asking for this module. Still ownerless; the scoping question sharpens every time.
- **First process documentation (the Certified Payroll Playbook, ~post-2026-08-04):** [certified-payroll-playbook.md](../certified-payroll-playbook.md). Reshapes the rule's scope: identification happens at **sales intake** (checklist + red flags + Unknown-and-escalate), a **Labor Compliance** function gates scheduling (hard NO-GO), documents live on the job record, and the reporting deliverable is the **WH-347** class with DIR Project IDs and wage determinations. The FCC "Certified Pay" flag (2026-06-09 screenshot) is the playbook's "mark Labor compliance in FCC." The ownership question narrows: Labor Compliance owns the *business* process — the open decision is which parts the ERP automates (intake workflow + gate → quotations/jobs; weekly report generation → this rule).

