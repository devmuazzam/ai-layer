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
2026-11-03 later: `8e59f0181` — yard geocoding on save + backfill script (D8, §12 Q5 answered); local backfill set
LA and Riverside (10 blank test-yard addresses skipped). `5e6885ee6` — employee Yards multi-select with a starred Home
chip replaces the extra-yard rows (D9); checked live: pick two, star moves Home, removing Home promotes the next, edit
loads both, swap Home on CTE-00001 saved (now Home LA, extra Claude Test Yard). Web tsc/eslint clean, node tests
1018/1022 (same 4); api helper spec 6/6. Not checked live: geocoding through the yard form (unit-tested only).
2026-11-04: `8ef8ec868` — client feedback on the Yards picker (D10): pills inside the field on one scrolling row, a
checkbox on every row, the list stays open between picks, neutral pills, Home reads Primary. Checked live with six
yards: pick, untick, search + Enter, Backspace, Esc, click outside, star, removing Primary, required error, wheel
and open/close scroll. Edit load and save + reload were checked before the last visual changes. Web tsc clean, node
tests 1028/1036 (same 8). Not checked: phone width, qa-automation.
2026-11-04 later: `92f6f1708` — client feedback: separate Primary Yard and Secondary Yards fields (D11); checked live,
including edit save + reload (CTE-00001 restored). `8143b2608` — the employee details page now emits the `info-*` ids
the qa specs look up: 26 of 26 on a temp employee, 25 of 25 on a salaried one. Not run: the qa specs (qa-automation is
not set up on this machine). `lifecycle.spec.ts` still fills the removed `payType` field and never sets Compensation
Type, so it fails before the details page. Pushed with SKIP_GATES=1: web and mobile test targets fail on Windows here.
2026-11-04 later: `f9aa3f78a` — client feedback: the yard suggestion text uses the auto-filled green (#16a34a). Not seen
live (browser session expired); web tsc clean.
2026-11-04 later: reviewed PR #1015. `092699b04` — quote create accepts the yard name (D12), checked on the running API:
name only 201 and linked, unknown name 400, no yard 400 (test row QUOT-00032 archived locally). `54911518f` — single-select
dropdown rows say aria-selected false again. Open from the review: duplicate yard names on staging and production before the
migration; stale coordinates when a yard address is typed over; Secondary-only yards and archive/delete; the API accepts an
inactive Secondary; no processed.log entry; review questions not yet in §12.
Next: optionally split the commits per unit; run the backfill per environment on deploy; PR when the developer says.
