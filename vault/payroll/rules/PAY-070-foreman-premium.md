---
id: PAY-070
title: PAY-070 — Foreman premium
section: E-guarantees-special-pay
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-070 — Foreman premium

**Rule:** Employees designated foreman receive **+$3.00/hour** on the base rate. In **no other catalog**: legacy never calculated it, matrix (2026-08-05) predates the source, FRD omits it.

## Sources

- [foreman-and-military-premiums.md](../foreman-and-military-premiums.md) — supplied by Brian Petros 2026-08-09, “in no other document”
- Meeting 2026-08-13 (payroll process): “designated as the foreman, it’s $3 more per hour”

## Open

- **Blocking:** add to the matrix; decide into-rate vs on-top (see PAY-011) since MLA premium language may apply; confirm designation source field.
- **Full specification = [foreman-and-military-premiums.md](../foreman-and-military-premiums.md)** (this rule's origin message located in the backlog — the doc is its faithful capture). Codes confirmed **live in ADP** (8-18 pull): `FRR/FRO/FRD/FRT` — closing the pull's "in no TCG document" flag. The **TRI code's existence implies the premium multiplies through all four buckets** — into-rate treatment (see PAY-011).
- **⚠️ Token-vs-engine contradiction:** the spec says the Payroll App applies the premium by finding `(PAY:FOREMAN)` — but the 06-23 extract's whitelist ignores every token outside `SHIFT/SUB/WTL`, and "Not calculated anywhere" lists this premium. Either the app gained the branch after the backup (contradicting "not many changes") or the spec states intent as current. **Verify against the live app before trusting either.**
- **Rule character:** a **company** rule that applies only to union employees (not an MLA term) — its adjudication path is TCG management, not the contract. Foreman chosen per job by the crane superintendent (**Jeff Kelley**) → ERP capture design candidate: a **dispatch role assignment** (foreman flag on the job's crew), not a comment token.
