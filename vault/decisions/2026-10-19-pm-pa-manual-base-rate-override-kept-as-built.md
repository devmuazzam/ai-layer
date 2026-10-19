---
title: The PM/PA manual base-rate override for union-field (L12_FIELD) employees — a per-employee/per-period override rate that emits BASE_RATE_OVERRIDE rows in the ADP paydata CSV — is kept as built in PR #788 (Ali Riaz, interim, 2026-10-19) — decision
source: decision/Ali Riaz — ADP-PAYDATA-EXPORT, keep the U5a–U5d manual override as shipped in PR #788
decided: 2026-10-19
decided_by: >-
  Ali Riaz (CodingCops developer, ADP-PAYDATA-EXPORT), 2026-10-19, keeping the manual base-rate
  override built in units U5a–U5d (PR #788) as-is rather than reverting it. This is a developer
  call made WITHOUT client sign-off, and it overrides a `status: verified` payroll ruling (see
  conflicts_with). The team will explain it to the client and seek ratification from Corrina
  Bustos and Brian Petros. Recorded by tcg-scrum 2026-10-19.
status: reference
pending_ratification: >-
  Corrina Bustos (TCG payroll) and Brian Petros — the two humans who made/confirmed the verified
  2026-08-20 ruling this contradicts. Until they (and the client) ratify, this is a developer
  override of a verified decision, not settled product truth. MUST be explained to the client.
conflicts_with:
  - decisions/2026-08-20-craft-locked-rate-override.md
related:
  - decisions/2026-08-20-craft-locked-rate-override.md
  - decisions/2026-08-25-craft-locked-rate-override-scoped-to-union.md
  - aidlc/ADP-PAYDATA-EXPORT/spec.md#q12--base_rate_override-rows
  - aidlc/ADP-PAYDATA-EXPORT/spec.md#q32--raised-by-the-executor-u5b-does-a-base-rate-override-apply-to-all-the-employees-hours-or-carry-an-explicit-scope
  - aidlc/ADP-PAYDATA-EXPORT/spec.md#q33--raised-by-the-executor-u5b-is-the-overrides-notereason-field-required-and-is-there-a-length-cap
  - aidlc/ADP-PAYDATA-EXPORT/spec.md#q34--raised-by-the-executor-u5b-which-bound-does-the-override-rate-carry--the-column-bound-or-the-adp-temp-rate-bound
  - payroll/gaps.md#base-rate-override--a-per-row-base-rate-mechanism-in-the-live-workbook-purpose-unstated
tags: [module/payroll, kind/decision, adp, payroll-rules, craft-code, pricing, open-questions]
---

# Decision

The manual **PM/PA base-rate override** for **union-field (`L12_FIELD`)** employees — a
per-employee / per-period override rate, entered by PM/PA, that the ADP paydata exporter
emits as `BASE_RATE_OVERRIDE` rows in the CSV (pays the employee's hours at the override
rate) — built across units **U5a–U5d** and shipped in **PR #788**, is **kept as built**.

Decided by **Ali Riaz, 2026-10-19**, as an **interim developer call**. The team will
explain the feature to the client and seek ratification.

**This is not settled product truth.** It is recorded `status: reference` because:

1. It **contradicts a `status: verified` decision** (see *The conflict* below) that no
   verified decision overturns.
2. The client has **not** been consulted; the two humans behind the verified ruling
   (Corrina Bustos, Brian Petros) have **not** ratified it.
3. The spec question it implements (ADP-PAYDATA-EXPORT §12.5 Q12) was **deferred**, and the
   three executor questions it was built against (Q32, Q33, Q34) are **open**.

Until ratification, treat this as a **merge/ship risk**: the feature pays union employees a
free-text dollar rate that a verified payroll ruling says must never exist.

# The conflict — stated plainly, not softened

**This decision contradicts `decisions/2026-08-20-craft-locked-rate-override.md`**
(`status: verified`, decided by **Corrina Bustos**, confirmed by **Brian Petros** — "that
makes it easier" — on the 2026-08-20 payroll-rules Zoom call).

That verified decision rules, verbatim:

> "When an employee works a different craft on a given day, the day's rate is driven by a
> **secondary craft code assigned for that day** — **never a free-text dollar override.**
> **'Locked to a craft-code amount'** (Corrina Bustos; Brian Petros: 'that makes it
> easier')."

Its scope was later read as **union crafts only**
(`decisions/2026-08-25-craft-locked-rate-override-scoped-to-union.md`, SCRUM-926 §12 Q18) —
i.e. exactly the `L12_FIELD` population this override now targets. So the override does not
fall in the non-union gap the 2026-08-25 reading carved out; it lands squarely inside the
verified ruling's scope.

**The override is the free-text dollar override the verified decision prohibits.** A PM/PA
types an arbitrary `overrideRate` for a union employee; it is not locked to any craft-code
amount, and it is not assigned by a crane superintendent or payroll (the verified decision
restricts even who may set a day's rate). On all three counts — free-text vs craft-locked,
arbitrary vs craft-table-sourced, PM/PA vs super/payroll — it runs against the 2026-08-20
ruling.

# Why it was kept anyway (and how thin the justification is)

The only prior justification on record is the phrase **"special agreement"** — and it is
**not a decision**:

- It appears as a one-line Teams answer: **Micaela Dipane, 2026-10-08, Teams** — asked
  about a live-workbook row paying `135.14` on 25 regular hours (week 38), she said *"That
  is a special agreement for that employee."*
  (`payroll/gaps.md#base-rate-override--a-per-row-base-rate-mechanism-in-the-live-workbook-purpose-unstated`,
  `status: unverified`, gap **open**).
- The ERP **has no field** for a special-agreement rate (noted in the same gap and in
  SCRUM-928 / PAY-CC-03, unadjudicated); U5a–U5b added one (`payroll_base_rate_override`)
  to hold it.
- ADP-PAYDATA-EXPORT §12.5 **Q12** itself notes "at least two purposes" for the live
  `BASE RATE OVERRIDE` mechanism (a job/craft-group rate, vs a per-employee special
  agreement) and that the purpose is still open.

So the keep rests on an unverified Teams aside interpreting one workbook row — not on any
adjudicated rule, and against one that *was* adjudicated.

# What the spec actually says (deferred and open, not resolved)

- **§12.5 Q12** resolved to *emit* `BASE_RATE_OVERRIDE` rows but then **deferred** them:
  "**Phase-1 ships without override rows.**" Row semantics (full base rate vs difference)
  were left **(→ Brian)**. The manual-override feature ships the rows Q12 deferred.
- **Q32** (apply to ALL hours vs an explicit scope) — **open**; built always-all with no
  scope column. Owner: Ali Riaz.
- **Q33** (is the note/reason required; length cap) — **open**; built optional, 1000-char
  cap (an executor assumption the spec does not state). Owner: Ali Riaz.
- **Q34** (which bound: the `DECIMAL(10,4)` column bound vs the ADP Temp-Rate bound
  `0 < rate ≤ 999.9999`) — **open**; built to the wider column bound. Owner: Ali Riaz /
  Brian.

None of these is resolved by this note. This note records only that the shipped feature is
kept pending ratification; it does not answer Q32/Q33/Q34 or lift the Q12 deferral.

# Effect on the vault

**No frontmatter was changed, and that is deliberate.** There is **no verified winner**
here — this is a `reference` developer override of a verified ruling, pending human
ratification.

- `decisions/2026-08-20-craft-locked-rate-override.md` — **NOT touched.** Stays
  `status: verified`. Not superseded, no `superseded_by`, no flag flipped. Its ruling still
  stands as product truth; this note is the thing that must be reconciled against it, not
  the other way round.
- ADP-PAYDATA-EXPORT §12 — Q12 stays **deferred**, Q32/Q33/Q34 stay **open**. Not marked
  resolved.
- `payroll/gaps.md#base-rate-override…` — stays **open**, `status: unverified`.
- This note itself — `status: reference`, `conflicts_with` the 2026-08-20 verified decision,
  `pending_ratification` naming Corrina Bustos and Brian Petros.

**Next step (owner: the team / Ali Riaz):** explain the manual override to the client and
obtain ratification from Corrina Bustos and Brian Petros. If they uphold the 2026-08-20
ruling, the override must be reverted or re-scoped; if they ratify, a follow-up verified
decision supersedes 2026-08-20 for this case and answers Q12/Q32/Q33/Q34. Until then, the
feature is a developer override of a verified ruling and a ship risk.
