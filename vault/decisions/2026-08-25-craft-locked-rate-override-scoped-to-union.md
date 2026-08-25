---
title: The craft-locked rate-override decision is read as scoped to UNION crafts, and is not overridden — WORKING reading
source: decision/acting-product-owner, relayed via the SCRUM-926 coordinator
decided: 2026-08-25
decided_by: Syed Haris (CodingCops, acting product owner), 2026-08-25, relayed via the SCRUM-926 coordinator and recorded in aidlc/SCRUM-926/spec.md §12 Q18. NOT confirmed by Corrina Bustos or Brian Petros, who took the decision being read. This is a reading of their decision by someone who did not take it.
status: reference
resolves: aidlc/SCRUM-926/spec.md#q18
jira: [SCRUM-926]
tags: [module/payroll, kind/decision, craft-code, pricing, payroll-rules]
---

# The 2026-08-20 craft-locked rate-override decision is union-scoped, and non-union per-person pricing sits beside it

> **`status: reference`, not `verified`.** The decision being *read* here
> (`decisions/2026-08-20-craft-locked-rate-override.md`) is `verified` and stays that way.
> This note is a **reading of its scope**, made by someone other than the people who took
> it. Corrina Bustos and Brian Petros have not confirmed it.

## The question

`SCRUM-926` prices **non-union employees from `Employee.hourlyRate`**
(`decisions/2026-08-25-non-union-base-rate-per-person.md`). The only `[VERIFIED]` source in
the epic — `decisions/2026-08-20-craft-locked-rate-override.md`, decided by Corrina Bustos and
confirmed by Brian Petros — says *"rates always come from craft tables"*, with day-level
deviation *"never a free-text dollar override"*.

Reading a rate off the employee record is **not obviously** *"from craft tables"*. It is also
**not obviously** a *"free-text dollar override"* — `Employee.hourlyRate` is a mastered column,
not free text, and the decision's subject was day-level deviation on **union** work. **A narrow
reading and a broad reading give opposite answers, and nobody had chosen between them.**

## Decision

**The two sit beside each other. The verified decision is not overridden.**

1. `decisions/2026-08-20-craft-locked-rate-override.md` was taken on the **union day-level
   override case** — Corrina Bustos and Brian Petros, in an L12 context — and is **read as
   scoped to UNION crafts**.
2. Non-union per-person pricing on `Employee.hourlyRate` follows
   `payroll/rules/PAY-012-non-union-hourly-rate.md` and FCC practice. It is **not a reversal**
   of the 2026-08-20 decision, because that decision was never about non-union work.
3. Under the narrow reading, **a union employee may not be priced per person.** `SCRUM-926`
   answers that question **no**, on the strength of this reading alone.

## Why

The reversal moved **onto the better-sourced side**, which is why this is a question about the
record rather than an objection to the decision. Three documents pointed three ways, and the
build followed a planning answer relayed on 2026-08-25 rather than any of them by name:

- **`decisions/2026-08-20-craft-locked-rate-override.md`** — `verified`, the only verified
  source in the epic, cited by REQ-19. Subject matter: which craft drives a *day's* rate when
  an employee works a craft other than their own, and who may set it. L12 context throughout.
- **`payroll/rules/PAY-012-non-union-hourly-rate.md`** — *"Use employee-master hourly rate; do
  not use union craft rate"*, with **Brian Petros's written confirmation of 2026-06-09** marked
  *"very important"*, corroborated by the legacy engine's **21,348** `Employee.PayRate` rows.
  The new direction matches this **exactly**.
- **`payroll/codingcops-rule-matrix.md` §B `PR-014`** — treats *"source rate; craft rate;
  modifier; **employee rate**"* as four live rate sources. Consistent with the new direction,
  inconsistent with the old one, and still unadjudicated against either.

The scope reading reconciles all three without any of them losing: the 2026-08-20 decision
governs how a **union** day gets its rate (from craft tables, by controlled assignment, never
free text), and `PAY-012` governs where a **non-union** rate comes from. They were never
answering the same question.

## Why this stays a reading, and the word matters

It is **inferred from the decision's subject matter** — a good inference, and still an
inference. The people who took the decision have not been asked whether they meant it to be
union-scoped. The narrow and broad readings **diverge the first time anyone asks whether a
union employee may be priced per person**, and that question is being answered *no* today on
nothing but this inference.

The one-line-answerable question for Corrina Bustos, and ideally Brian Petros:

> *"When you decided on 2026-08-20 that rates always come from craft tables, did that cover
> non-union employees too, or only union (L12) work?"*

Until that comes back, this note is the record of a reading, not of a confirmation.

## Effect on the vault

- **Not overridden, not superseded, `status:` unchanged:**
  `decisions/2026-08-20-craft-locked-rate-override.md` stays `verified`. Nothing about it is
  wrong; only its scope was ambiguous.
- **Applied in this pass:** `provenance_note:` added to that file's frontmatter pointing at
  this note, so anyone reading it sees the scope reading without having to find
  `SCRUM-926`'s §12. **Its body is unchanged** — it still reads *"rates always come from craft
  tables"* with no qualifier, because that sentence belongs to the people who wrote it and
  `tcg-scrum` does not edit vault bodies. The qualifier lives here and in the frontmatter
  pointer.
- **Companion decision:** `decisions/2026-08-25-non-union-base-rate-per-person.md` — the
  branch itself.
- **Cheap to miss, and worth carrying forward:** intent §5 of `SCRUM-926` said the ticket
  *"only stops payroll reading"* the employee rate columns. **It no longer does.** Any future
  cleanup ticket that drops `hourlyRate` / `payRateOT` / `payRateDB` must now **exclude
  `hourlyRate`** — it is live under this model, not legacy. `SCRUM-928` (employee-specific rate
  adjustments) also moves closer: a per-person non-union rate *is* an employee-level rate.
- `aidlc/SCRUM-926/spec.md` §12 Q18 → resolved as a working reading (see this note).
