# State — ADP-PAYDATA-EXPORT ADP paydata export

> Created 2026-10-27 at P5, after the fact: the folder predates this file. Progress only — per-unit
> status is in the `units.md` ledger and P-series table, open questions in `spec.md` §12.

**Path:** A · **Branch(es):** `feat/ADP-PAYDATA-EXPORT-p5-reexport` (P5; earlier P1–P4 and U-series branches merged) · **Last updated:** 2026-10-27 by Claude Code session (Syed Haris)

## Phases

- [x] Intent — `intent.md` (absent; the ticket was a provisional folder, Q17)
- [x] Spec — `spec.md` (`tcg-elaborator`)
- [x] Sign-off — `spec.md` §14 (Ali Riaz, 2026-10-15 resolutions)
- [x] Units — `units.md` (`tcg-decomposer`); P1–P5 added outside the U-series (Q35)
- [-] Build — P5 built on `feat/ADP-PAYDATA-EXPORT-p5-reexport`, PR not yet opened
- [S] Analyse — not run on P5 (developer-directed one-flag change; gates: web lint 0 errors, web typecheck, api lint 0 errors, api tsc clean outside spec files)
- [ ] Merged — P5 PR #…
- [ ] Reflect — `reflection.md`
- [ ] Closed — `close-ticket` run, overlay pushed

## Resume

**2026-11-02:** all or nothing replaces the partial send (P1–P4) and the re-send (P5), per [2026-11-02-adp-send-whole-week-only-no-re-send-export-of-a-sent-week-developer-direction.md](../../vault/decisions/2026-11-02-adp-send-whole-week-only-no-re-send-export-of-a-sent-week-developer-direction.md). The change is uncommitted on app branch `feat/payroll-weekly-design-alignment`; the existing partial-send and re-export tests in `payroll.service.spec.ts` still expect the old behaviour. The text below predates this.

P5 (re-export of a sent week, spec §12 Q39) is built and gated on `feat/ADP-PAYDATA-EXPORT-p5-reexport`; next is push + PR against `main`, then `close-ticket` to fill the ledger row and flip this file. Open from P-series: Q38a–c (frozen-employee flags, run counts, auto-recalc after a partial send) and Q39's two residuals (amended-week re-export; ADP duplicate batch) — all owned by Ali Riaz / Brian.
