# State — YARDS-2026-10-29

> Where this ticket is in the loop. Progress only: open questions stay in `spec.md` §12.

**Path:** A · **Branch(es):** `fixes/yards-2026-10-29` (platform and `.ai`, from `main`; local only, not pushed) · **Last updated:** 2026-11-03 by Claude Code (session with Asad Amanullah)

## Phases

- [x] Intent — `intent.md` (from the 2026-10-29 meeting and the developer's Trello text)
- [x] Spec — `spec.md` — 13 requirements; §12 Q1–Q4 open, none blocking (decisions D1–D5 cover them for now)
- [x] Units — `units.md` — 4 units
- [-] Build — U1–U4 built as one local commit `2f32af194` (not pushed); live checks pending
- [ ] Analyse
- [ ] Merged — PR #…
- [ ] Closed

## Resume

2026-11-03: U1–U4 built, one local commit `2f32af194` on `fixes/yards-2026-10-29` (not split per unit yet). Migrations
`20261103120000_quotation_job_yard_link` and `20261103130000_employee_extra_yards` applied to local `tcg_db` (34 quotes, 6 jobs linked, none unmatched).
Gates: api tsc 0 errors; jest quotations/projects/yards/jobs/field-tickets/employee/orm/das 506 pass; web tsc clean, eslint 0 errors,
node tests 1018/1022 (same 4 pre-existing); mobile tsc clean (mobile jest cannot run on this Windows machine). qa parse-checked.
Decision added in build: D6 — Home yard required in the web create form only; the API keeps it optional (qa helper and tenant seed
create employees without one). Web suggestion sends the job site only (crane sizes are chosen after the yard).
Next: live checks in the browser (user must sign in), optionally split the commit per unit, record D6 in spec.md.
