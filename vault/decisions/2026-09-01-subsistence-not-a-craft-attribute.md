---
title: Subsistence eligibility is not an attribute of a craft code — decision
source: decision/Syed Haris
decided: 2026-09-01
decided_by: Syed Haris (developer on TCG, author of SCRUM-961) — stated directly while reviewing the craft-code form. He is not the client-side product owner, and this reverses a control a named TCG person (Kyle Harlow) asked to expand on 2026-08-13. It stands because the governing document is the MLA, not a preference: Article V conditions subsistence on coverage, distance and an overnight stay, and never on classification. `status: reference` rather than `verified` — binding on implementation now, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: SCRUM-961/spec.md#11
jira: [SCRUM-961, SCRUM-926]
tags: [module/payroll, kind/decision, subsistence, craft-code, union-agreement, requirements]
entities: [craft-code, subsistence, employee, union-code, job]
---

## Decision

**Subsistence eligibility is not a property of a craft code.** The per-craft *"eligible for
per diem / subsistence"* toggle is removed from the craft-code form and is not to be
reintroduced there.

## Why — the agreement, not a preference

Subsistence is an **IUOE Local 12 MLA benefit**, so the agreement governs. Two clauses, both
in [`payroll/mcog-l12-mla-2025-2028/`](../payroll/mcog-l12-mla-2025-2028/INDEX.md):

- **Article V** — *"Employees covered by this Agreement who are required by the Employer to
  remain away from home overnight will be paid a subsistence allowance"*, at 45+ miles
  yard-to-job with the equipment remaining on the job. Grepped for `group|classification|
  craft|operator|oiler|apprentice|mechanic`: **no hits.** The article never names a
  classification.
- **Article III §2, *Craft Pay Rate*** — the only other subsistence mention in the extract:
  *"they shall receive the same overtime pay and subsistence as **the building trades craft
  with which they are working** if such provisions of that craft's agreement are more
  advantageous."* Even here the variable is **another trade's agreement on that job**, not
  the employee's own classification.

The structural reason: **subsistence is a property of the trip, not the trade.** All three
conditions are facts about a particular job on a particular night. Two people on the same
crew, the same crane and the same motel, differing only in craft, would otherwise receive
different travel allowances. It is an expense allowance; a craft code is a wage
classification.

## What this supersedes

`meetings/transcripts/2026-08-13-payroll-process.md:127` — Ehtesham Anwar demonstrates the
craft-code form with a subsistence modifier on it: *"if their craft code says they are not
eligible, we won't calculate for them."* At **18:07 Kyle Harlow (TCG)** asks to expand it:
*"under the modifiers… there probably should be short sub, long sub, and then custom."*

That ask was not ignored — **TCG relocated both halves in the same call**:

- **19:56, Corrina Bustos:** *"that would be per job, not per craft code."* Ehtesham agrees;
  they settle on computing mileage per job, on the **permitted** route (Kyle: you cannot use
  a Google route for an overweight crane), possibly from Samsara.
- **20:34, Kyle Harlow:** *"in the employee's profile, you could modify the sub according to
  the agreement, because usually those people who have a different agreement for sub pay,
  that's based on an agreement of employment."*

So short-vs-long is **job-level** and custom amounts are **employee-level**. Nothing was left
that belonged on the craft.

## What it does not settle

- **Whether any union craft is covered by the agreement yet never eligible.** Provisionally
  no, from the two clauses above — but our MLA copy is headed *"Payroll-relevant sections
  only"*, and an agreement is a floor: TCG may pay more by past practice or individual
  employment agreement. Open as `SCRUM-961/spec.md` §12 Q3, owner Corrina Bustos, for what
  is **paid** rather than what is **owed**.
- **Where the job-level distance calculation lives**, or whether Samsara supplies it.
- **Where per-employee custom subsistence lives** on the employee record.
- The amounts and thresholds, which are already settled: `payroll/gaps.md` → *Subsistence —
  the recording and the engine disagree*, corroborated 2026-09-01 by quote OM-35140's terms
  ($85 at ≥45 mi, $200/man/day above 77.5 mi, measured yard-to-job).

## Related

- [`payroll/rules/PAY-048-standard-subsistence.md`](../payroll/rules/PAY-048-standard-subsistence.md)
  — `status: open`. *"Applies to: Eligible L12 employees. Trigger: Overnight/distance/
  equipment conditions are met."* No craft term, consistent with this decision.
- [`payroll/rules/PAY-049-weekend-subsistence.md`](../payroll/rules/PAY-049-weekend-subsistence.md)
- [`quotations/quote-terms-and-rate-card.md`](../quotations/quote-terms-and-rate-card.md) §3
  — the customer-billing side of the same allowance.
