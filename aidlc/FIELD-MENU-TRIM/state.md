# State — FIELD-MENU-TRIM Trim field Menu to My Certifications

**Path:** A · **Branch(es):** U1 `refactor/FIELD-MENU-TRIM-u1-remove-menu-screens` → U2 `refactor/FIELD-MENU-TRIM-u2-remove-me-endpoints` (stacked) · **Last updated:** 2026-10-26 by Claude Code

## Phases

- [x] Intent — `intent.md`
- [x] Spec — `spec.md`; Q1 and Q2 answered
- [x] Sign-off — Q1 answered by haris
- [x] Units — `units.md` (U1, U2)
- [x] Build — U1 `e69721c6e` + `f8a684e69`, U2 `ad4dbbbfc`
- [x] Analyse — `tcg-analyst`: ship, no blocking finding; `tcg-contract-tracer`: 0 callers
- [ ] Merged — PR #…
- [ ] Reflect
- [ ] Closed

## Resume

Both units built, analysed, pushed. Merge U1 and U2 together (Q1: old builds 404 on Labor).
After merge: update vault pages in spec §13 via `tcg-scrum`, and PAYROLL-FLAGS REQ-20/REQ-33
text that cites `/me/labor`. Gates: mobile typecheck + lint 0 errors, API lint 0 errors,
touched jest suites pass. Uncommitted `schema.dbml` in the client repo is unrelated.
