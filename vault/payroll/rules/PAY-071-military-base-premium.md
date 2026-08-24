---
id: PAY-071
title: PAY-071 — Military-base premium
section: E-guarantees-special-pay
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-071 — Military-base premium

**Rule:** Work on a military base pays **+$10.00/hour** on the base rate. Same provenance and same gaps as PAY-070.

## Sources

- [foreman-and-military-premiums.md](../foreman-and-military-premiums.md)
- Meeting 2026-08-13: “on a military base, $10 more per hour… so it would be $3 plus $3 plus a dollar” (stacking example with shift + foreman)

## Open

- **Blocking:** add to the matrix; confirm stacking order with shift/foreman premiums (the 08-13 example implies additive); confirm base-designation source (job? job site? quote flag).
- **Full specification = [foreman-and-military-premiums.md](../foreman-and-military-premiums.md)** (this rule's origin message located in the backlog — the doc is its faithful capture). Codes confirmed **live in ADP** (8-18 pull): `MLR/MLO/MLD/MLT` — closing the pull's "in no TCG document" flag. The **TRI code's existence implies the premium multiplies through all four buckets** — into-rate treatment (see PAY-011).
- **⚠️ Token-vs-engine contradiction:** the spec says the Payroll App applies the premium by finding `(PAY:MILITARY)` — but the 06-23 extract's whitelist ignores every token outside `SHIFT/SUB/WTL`, and "Not calculated anywhere" lists this premium. Either the app gained the branch after the backup (contradicting "not many changes") or the spec states intent as current. **Verify against the live app before trusting either.**
- **Rule character:** a **union** rule; **job-scoped — all hours, all employees on the job** — structurally the same shape as lattice (PAY-044). ERP capture design candidate: a **job-level flag** alongside Kyle's Boom Configuration field, set at intake (salesperson is first contact; Davis-Bacon site list decides; **Local 12 Business Agent verifies adjacency edge cases**).
