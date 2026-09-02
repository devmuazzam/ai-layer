---
title: Non-union base rate is per person, from Employee.hourlyRate — decision
source: decision/acting-product-owner, relayed via the SCRUM-926 coordinator
decided: 2026-08-25
decided_by: Syed Haris (CodingCops, acting product owner), 2026-08-25, relayed via the SCRUM-926 coordinator and recorded in aidlc/SCRUM-926/spec.md §12 Q1. Converges with Brian Petros's written client statement of 2026-06-09 (marked "very important") carried in payroll/rules/PAY-012-non-union-hourly-rate.md. Withdraws Syed Haris's own 2026-08-24 working decision, below.
status: verified
resolves: aidlc/SCRUM-926/spec.md#q1
jira: [SCRUM-926, SCRUM-925]
tags: [module/payroll, kind/decision, craft-code, pricing, payroll-rules]
---

# Non-union employees are priced per person; union employees are priced per craft

## Decision

The base-rate resolver **branches on the primary craft's union kind**:

1. **`UNION`** → the `CraftCodeRate` in force on the **work date**. Rate lives on the craft
   code, effective-dated, as `SCRUM-925` describes.
2. **`NON_UNION`** → **`Employee.hourlyRate`**, at its **current value**, with **no effective
   dating in this epic**. One rate per *person*, as in FCC today.

Consequences that were decided with it, and are load-bearing:

- **Non-union crafts carry no `CraftCodeRate` rows at all**, and validation must not require
  any. A non-union craft code with no rate row is correct, not incomplete.
- **`Employee.hourlyRate` is not retired.** It is a live rate source under this model, not a
  legacy column. `payRateOT` / `payRateDB` remain derived and unread.
- The **2026-08-24 working decision — "one rate per craft, non-union included", everyone on
  `ADMIN-A` earns `ADMIN-A`'s rate, `Employee.hourlyRate` never read — is withdrawn.** It was
  taken by the same person on the same ticket one day earlier and stood for one day. Anything
  built or written against it is wrong; nothing in `SCRUM-926` still follows it.

## Why

This is the one place in the epic where a **planning decision yielded to the vault** rather
than the other way round, and the reason it did is the reason worth carrying forward.

The 2026-08-24 direction (rate on the craft, for everyone) had `SCRUM-925`'s unqualified
sentence — *"The employee's assigned craft code determines their base payroll rate"* — and
plan-level tidiness behind it. The other side had:

- `payroll/rules/PAY-012-non-union-hourly-rate.md` — *"Use employee-master hourly rate; do not
  use union craft rate"*;
- **a written client confirmation** behind that rule: Brian Petros, 2026-06-09, marked
  *"very important"*, and never asked to reverse it;
- the **legacy engine's own behaviour**: 21,348 labor rows priced from `Employee.PayRate`
  against 59,655 from the union craft table
  (`payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` →
  *Distinct PayrollBaseRateSource*);
- `payroll/codingcops-rule-matrix.md` §B `PR-014`, which independently assumes the employee
  rate is still a live rate source.

Four independent sources, one of them a written client statement, against one unqualified
sentence in a ticket and a plan. **Recency and plan-tidiness are not authority.** The
`[CONFLICT]` on REQ-10 dissolved by *agreement* rather than by adjudication — the plan moved
onto the better-sourced side — which is the outcome that flag exists to make possible.

The practical cost the withdrawn decision would have imposed is also on the record: under
"one rate per craft", every distinct non-union pay rate in the current data has to become its
own craft code. Nobody had counted them. Six would have been easy; six hundred would have been
a migration nobody signed up for.

## What this does not settle

- **Rate effective-dating for non-union.** Reading `Employee.hourlyRate` *as it currently
  stands* means a **recalculation of a past period returns today's rate**. That contradicts
  `payroll/rules/PAY-008-effective-dated-configuration.md` (*"Historical recalculation must use
  rules effective on the work date"*) and is `PAY-012`'s own open blocking item, *"Confirm
  rate-effective-date handling"*. **Deliberately scoped out of this epic**; it lands on
  `PAY-068` retroactive correction, under `SCRUM-920`.
- **Whether the day-level craft-locked-rate decision is overridden.** It is not — see
  `decisions/2026-08-25-craft-locked-rate-override-scoped-to-union.md`, which records the
  scope reading as a *reading*, not a confirmation.
- **`SCRUM-928`** (employee-specific rate adjustments, out of scope here) moves closer: a
  per-person non-union rate *is* an employee-level rate, and the two models will have to be
  reconciled when that ticket runs.

## Effect on the vault

- **Agrees with, and is now the dated record for:** `payroll/rules/PAY-012-non-union-hourly-rate.md`
  (`status: open`, blocking item *"Confirm rate-effective-date handling"* still open — **not**
  flipped to `verified` here, because this decision settles the *source* of the rate and
  explicitly leaves that rule's own open item unsettled).
- **Withdrawn, and superseded by this note:** the 2026-08-24 "one rate per craft, non-union
  included" working decision recorded in `aidlc/SCRUM-926/spec.md` §12 Q1. It never had a file
  in `decisions/`, so there is no frontmatter to flip — this note is the only record that it
  was taken and withdrawn.
- `aidlc/SCRUM-926/spec.md` §12 Q1 → resolved (see this note).
- No vault file body was edited. No `status:` was flipped on any candidate file: the four
  sources listed under *Why* now agree with each other and with the build, but none of them has
  been adjudicated against a competing copy by the human who owns it.
