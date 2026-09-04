---
id: PAY-068
title: PAY-068 — Retroactive correction
section: G-audit-review-export
status: open
updated: 2026-09-04
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
- **Client raised it, 2026-09-04 (Brian Petros → ehtesham.anwar):** *"if an employee has a labor entry that is 48 hours long… and the end of that labor entry is at the very beginning of the payroll week"* — payroll rules read surrounding entries, so *"there could be no change to the data of that individual labor entry, and yet the surrounding labor entries impact its calculated results."* He asks how the ERP handles automatic **and** manual adjustments to previously processed/approved/closed periods. This is the blocking item, now asked by the client in his own words. **Built state: the ERP refuses** — `payroll.service.ts:139-148` throws on recalculating an `APPROVED`/`EXPORTED` period and no reopen or delta path exists. See [gaps.md → *A labor-entry edit can reprice an approved week*](../gaps.md#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it).
