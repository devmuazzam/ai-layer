# Payroll engine context — `packages/payroll-engine/`

Pure TypeScript, no I/O. Prices one employee-week from job-day inputs into half-hour slices,
buckets (ST / OT / DT / H2X / H3X), and a per-day ledger of `PayComponent`s. Consumed by
`apps/api` (payroll usecase) and exported to ADP through `xlsx-rows.ts`. Loads when working
here; open by path on tools that do not auto-load.

## The one rule that governs every other rule here

**No pay rule changes in this package without its source.** Before you change how a
half-hour is bucketed, what a guarantee pays, when a premium fires, or what an adder
multiplies, the change must be traceable to a named human or a contract clause — and that
source must be written into
[`.ai/vault/payroll/payroll-rules-provenance.md`](../../vault/payroll/payroll-rules-provenance.md)
**in the same commit**. Who said it, where, when, at which timestamp or clause, linking to
the verbatim quote. A rule change with no source is not a rule change; it is a guess with a
commit hash, and the parallel run against the client's app will find it.

This is not a documentation nicety. Two things have already gone wrong here without it:
`ad9041bc` fixed one worked example and silently regressed the before-midnight case the
legacy engine had right; PR #531's cross-midnight fix floored holiday-start shifts at 3×
through midnight — a rule the union then said does not exist — and overpaid $960 a shift.
Both were caught by executing the engine against a client's stated breakdown, not by review.

## Where the rules live, and in what order they outrank each other

| Question | Read |
| --- | --- |
| Is this rule right, and what says so | `vault/payroll/payroll-rules-provenance.md` — status and source per rule |
| Does the engine do it, verified by running | `vault/payroll/payroll-engine-status-2026-09-12.md` |
| The full history of one rule | `vault/payroll/rules/PAY-###-*.md` |
| The ruling itself, verbatim | `vault/decisions/` |
| What is still open, and who owes the answer | `vault/payroll/gaps.md` |

On contract meaning: the union business agent › Corrina Bustos (Payroll Manager) › the
Local 12 agreement's text › Brian Petros' Payroll App. A lower source never overrides a
higher one. Two TCG-side sources that disagree get a *Contested* row, not a choice.

## Things you will be tempted to "fix" from reading the code — don't

- **23:00 → 13:00** prices 0 ST / 12 OT / 2 DT (the categorical before-midnight reading). The
  legacy engine gives 1 h ST. Corrina has not ruled. Leave it.
- **`REST_STITCH_MINUTES = 30`** is wrong and client-confirmed wrong (back-to-back or overlap
  only) — but the fix is 0 **measured on the PAY-020 rounded window**, not raw minutes, or two
  tickets a minute apart get rest-forced. Audit item A7.
- **Guarantee hours advance the 12-hour DT rung** (`premiumDayTopUpHours`) and nothing else.
  That single cell is a union ruling contested by Brian. Do not generalise it to rest, weekly OT
  or meals; do not remove it because his objection reads well.
- **The rest trigger requires OT/DT in the prior chain.** It is MLA Art. III Rest Periods §1,
  not a leftover.
- **`sliceDayType` is gone on purpose.** Never-downgrade is the ladder's 12-hour rung, not the
  anchor day's premium carried forward.

## Conventions in this package

- **Rule order is load-bearing** and documented in `rules/PAY-045` — slice pricing per chain →
  premium-day minimums per date → rest per chain → shift hours-add per chain → daily/boom
  minimums per calendar day → meals per gapless group → subsistence → totals restated from the
  ledger. Do not reorder without a reason in the provenance register.
- **Added hours are components, never slices.** `actualHours`, the timesheet and the ADP export
  carry worked time only. Anything the engine adds (guarantee, rest premium, WTL add,
  hours-add) is a `PayComponent` with a `ruleId`.
- **Regression tests carry the client's breakdown verbatim** as a comment above the assertion
  — the speaker, the date, the words. A test that asserts a number with no quoted source is
  asserting the code, not the rule.
- **Times in specs are UTC; Pacific is the payroll clock.** PDT is UTC−7 until 2026-11-01,
  PST is UTC−8 after. Veterans' Day (Wed 11 Nov 2026) is the holiday used for holiday cases
  because it has a plain weekday on each side.
- **`explain.ts` mirrors `calculate.ts`.** Any counter or bump added to the pricing loop is
  added to the explain loop in the same change — a reason on screen that disagrees with the
  money is worse than no reason.
- `pnpm test` here is `node --test` over `src/*.spec.ts` against `dist/`; **build first**
  (`pnpm nx run @tcg/payroll-engine:build`), or the tests run yesterday's code.
