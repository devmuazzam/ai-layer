# State — FIELD-MENU-TRIM Trim field Menu to My Certifications

**Path:** A · **Branch(es):** U1 `refactor/FIELD-MENU-TRIM-u1-remove-menu-screens` (created, no code yet) → U2 `refactor/FIELD-MENU-TRIM-u2-remove-me-endpoints` (not created) · **Last updated:** 2026-10-26 by Claude Code

## Phases

- [x] Intent — `intent.md`
- [?] Spec — `spec.md`; Q1 open (U2 timing), Q2 veto-only
- [ ] Sign-off — `spec.md` §14
- [x] Units — `units.md` (U1, U2)
- [x] Build — U1 `e69721c6e`, U2 built (local, not pushed)
- [ ] Analyse
- [ ] Merged
- [ ] Reflect
- [ ] Closed

## Resume

2026-10-26: Q1/Q2 answered. U1 (mobile) and U2 (API) built and committed locally, no PR. Gates: mobile typecheck pass, lint 0 errors, menu/auth-gate/app-shell jest pass; API eslint clean, me jest pass. Next: tcg-contract-tracer + tcg-analyst, push, PRs (U2 draft stacked on U1).

Planned only; no code changed. Findings: Tasks and Checklist History are local fixtures (no
API, no DB). Labor and Performance use `GET /me/labor` and `GET /me/performance` on existing
tables. Nothing to drop in DB, so G2 is not triggered. Next: answer Q1, then run
`tcg-executor` on U1.
