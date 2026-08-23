---
id: PAY-010
title: PAY-010 — L12 union base rate
section: B-group-and-rate
status: conflicted
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-010 — L12 union base rate

**Rule:** Use effective union craft rate as base straight-time rate.

**Applies to:** L12 Field and eligible Mechanics. **Trigger:** Labor CraftCode begins with L12.
**Requires:** Labor CraftCode; union craft rate; work date.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-010` — baseline: *Redesign required*
- **FRD** (target design): [03-payroll-groups-and-rate-determination.md](../erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md) `PR-007` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §1
- **Contract**: [02-article-iv-classifications-and-wage-rates.md](../mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md)

## Open

- **Blocking (matrix):** Confirm mechanic applicability
- **Conflict:** The 2026-08-13 recording says the **employee’s allocated rate wins** even when dispatched as a rigger; this rule and the legacy engine say the **labor row’s craft wins**. Highest-value open payroll question — `../gaps.md` (recordings-vs-vault register). Craft-code rate lock confirmed verbally 2026-08-20 (`../2026-08-20-payroll-rules-meeting-notes.md`); Confluence “Craft codes” page (PAY-CC ids) staged in `../../sync/.conflict/2026-08-24-bootstrap/craft-codes.md`.
- **Client message 2026-06-09** (Brian Petros): *"This uses the Craft Code RATE in FCC on each labor entry… NOT the Craft Code on the Employee profile screen"* — states the labor-entry-craft side **explicitly and emphatically**, agreeing with this rule and the engine. The 2026-08-13 recording (Kyle/Corrina: employee's own rate wins; Brian proposes higher-of) is **later** — so for the client this is likely a *change request against the app's documented behaviour*, not a contradiction of fact. Confirm which the ERP implements; Brian's own higher-of proposal (floor at the employee rate) is the candidate synthesis.
