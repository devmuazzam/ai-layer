---
id: PAY-044
title: PAY-044 — Lattice-boom premium
section: E-guarantees-special-pay
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-044 — Lattice-boom premium

**Rule:** Add operator/oiler premium according to agreement.

**Applies to:** Eligible Group 6+ employees. **Trigger:** Qualifying lattice boom is used.
**Requires:** Equipment group; employee role.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-044` — baseline: *New ERP requirement*
- **FRD** (target design): [06-boom-equipment-and-guaranteed-hours.md](../erp-payroll-module-frd/06-boom-equipment-and-guaranteed-hours.md) `PR-027` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: **not calculated by the legacy engine**
- **Contract**: [02-article-iv-classifications-and-wage-rates.md](../mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md)

## Open

- **Blocking (matrix):** Confirm interaction with long boom
- **Conflict:** Into-the-rate vs on-top (see PAY-011); legacy never calculated lattice premium.
- **Rates confirmed four ways (message 19 + client's page-39 scan):** Corrina (Teams, 2026-05-18): *"$1 per hour over the wage rate for the operator group 6 and above; $0.50 for oiler group 6 and above"* — **verbatim** against the vault's MLA extraction (02-article-iv:48), the client's own scan of the page, and this rule's existing Group-6+ trigger. Contract text, named human, and register all agree.
- **⚠️ Luffer classification — two named sources disagree:** Jeff Stricker (via Brian): add-on **luffers are "technically lattice"** (→ lattice premium). Joe, 2026-08-04 recording: lattice on any non-crawler crane is a *jib extension / luffing jib* earning **boom pay only**. **Kyle adjudicates.** Fleet fact both agree on: exactly **one** lattice-boom vehicle today — the Crawler — so the base case is narrow but the luffer answer decides how it scales.
- **Identification design (client proposal):** carry **Boom Type on the asset subcategory** (assets module has categories/sub-categories) — aligning with Joe's "every dispatch of the crawler qualifies" (asset-driven, not per-job entry); per-job capture is the fallback candidate. "Not in the code I provided so far" ✅ — the legacy engine has no lattice concept at all; the ERP builds this from the contract + the two July ADP codes (message 18).
- **Kyle's answers (message 20):** (1) **Group 6+ is a qualification reality, not just a pay threshold** — only Group 6+ field employees are qualified to work lattice cranes, so dispatch self-enforces the premium's condition. (2) Lattice jobs run **≥ 1 week, up to a month+** (setup effort). (3) **Boom configuration is per-job and stable for the job's duration** — so identification belongs at the **job level**: a "Boom Configuration" field set by sales/dispatch. This supersedes the asset-subcategory idea from message 19 (the same crane reconfigures between jobs; the asset can carry *capability*, the job carries the *actual* configuration).
- **Scope clarified (Corrina, from the contract): lattice pay applies to the ENTIRE JOB** — not just boom-operating time. Sharp contrast with long-boom (PAY-043: boom-window slices only), and they stack. Implementation collapses to: job flagged lattice + employee Group ≥ 6 → premium on **all** job hours. 
- **Still unruled: the luffer question.** Kyle was consulted but the relay does not address Jeff-vs-Joe on luffers — question 21 stays open, now addressed to a Kyle who is already engaged.
- **Luffer question — contract evidence found:** the MLA classification table (Groups 5/7) reads *"Long Boom pay **including combined total mast and Luffing Boom** applicable"* — the contract itself treats luffing boom under **long-boom pay**, siding with Joe's 08-04 classification against Jeff's "technically lattice". Kyle's confirmation is now a formality with text behind it.
