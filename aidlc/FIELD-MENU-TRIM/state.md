# State — FIELD-MENU-TRIM Trim field Menu to My Certifications

**Path:** A · **Branch(es):** U1 `refactor/FIELD-MENU-TRIM-u1-remove-menu-screens` (created, no code yet) → U2 `refactor/FIELD-MENU-TRIM-u2-remove-me-endpoints` (not created) · **Last updated:** 2026-10-26 by Claude Code

## Phases

- [x] Intent — `intent.md`
- [?] Spec — `spec.md`; Q1 open (U2 timing), Q2 veto-only
- [ ] Sign-off — `spec.md` §14
- [x] Units — `units.md` (U1, U2)
- [ ] Build — U1 first
- [ ] Analyse
- [ ] Merged
- [ ] Reflect
- [ ] Closed

## Resume

Planned only; no code changed. Findings: Tasks and Checklist History are local fixtures (no
API, no DB). Labor and Performance use `GET /me/labor` and `GET /me/performance` on existing
tables. Nothing to drop in DB, so G2 is not triggered. Next: answer Q1, then run
`tcg-executor` on U1.
