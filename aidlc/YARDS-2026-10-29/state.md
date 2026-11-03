# State — YARDS-2026-10-29

> Where this ticket is in the loop. Progress only: open questions stay in `spec.md` §12.

**Path:** A · **Branch(es):** `fixes/yards-2026-10-29` (platform and `.ai`, from `main`; local only, not pushed) · **Last updated:** 2026-11-03 by Claude Code (session with Asad Amanullah)

## Phases

- [x] Intent — `intent.md` (from the 2026-10-29 meeting and the developer's Trello text)
- [x] Spec — `spec.md` — 13 requirements; §12 Q1–Q4 open, none blocking (decisions D1–D5 cover them for now)
- [x] Units — `units.md` — 4 units
- [x] Build — U1–U4 built as one local commit `2f32af194` (not pushed); checked live 2026-11-03
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
Live checks 2026-11-03 (Chrome, signed in as admin): U1 — quote without yardId 400; yardId sets the yard name
(QUOT-00027); draft yard change ok; jobs filter by yard; yard delete blocked; rename rewrote quote + job names and back;
convert QUOT-00027 → PROJ-00004 / JOB-00006 with the quote's yard linked. U2 — extra yard saved, list untouched when not
sent, Home yard refused on the list, Home→extra swap refused; form shows "Also works out of" rows. U3 — "Quoted from ABC"
chips, Yard filter, asset/employee card yards, slot marker "From Los Angeles Main Yard · quoted from ABC" (test
allocation removed). U4 — crane-size ranking (Riverside first for a Tower Crane), unknown job site 404, distance
ranking with temporary yard coordinates (removed after), "Suggested: … — Use" fills the Yard.
Left in local tcg_db from the checks: QUOT-00027 (Won) → PROJ-00004 / JOB-00006; CTE-00001's extra yard (LA).
Next: decide §12 Q5 (yard coordinates); optionally split the commit per unit; PR when the developer says.
