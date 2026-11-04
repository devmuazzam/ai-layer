# State — HOLDOVER-PAYROLL (Trello #108 / p2FpbQZw) Payroll honours holdover: window math, review batch, correction editor

> Where this ticket is in the loop. Progress only: per-unit status stays in the `units.md`
> ledger and open questions in `spec.md` §12.

**Path:** A · **Branch(es):** none yet · **Last updated:** 2026-10-26 by tcg-decomposer

## Phases

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (`tcg-elaborator`) — written and updated 2026-10-26 with the owner's Q1–Q3 answers; 0 questions open in §12 (Q1–Q11 resolved)
- [-] Sign-off — `spec.md` §14 checked by *named developer* — open items are not questions: decision notes + G4 provenance for Q1-B/Q2/Q7 (`tcg-scrum`), D3 (G5 contract-tracer), a developer review of §11b/§11c and the ASSUMED items
- [x] Units — `units.md` (`tcg-decomposer`) — written 2026-10-26; 3 vertical units (U1 pay-math, U2 display batch, U3 correction editor), one per §13 group; 9/9 REQs covered, 0 uncovered, 0 blocked
- [ ] Build — unit by unit; status per unit in the `units.md` ledger (`tcg-executor`)
- [ ] Analyse — verdict per unit (`tcg-analyst`)
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

## Resume

Trello reconciliation recorded 2026-10-26: ticket is Trello #108 (assignee Ali); scope boundary vs TCG-162 (worked-day subsistence), TCG-221/222 (what makes a holdover) in spec §11; dependency notes Q12 (TCG-222, past-midnight one-day job) and Q13 (TCG-234, timezone day index) in §12 — both non-blocking for U1–U3. No requirement status changed. Decomposed 2026-10-26 (Opus tier). `units.md` holds 3 independent vertical units, one per spec §13 group — U1 pay-math (REQ-01/02/03/04/05/07), U2 display batch (REQ-06), U3 correction editor (REQ-08/09). 9/9 REQs covered, 0 uncovered, 0 blocked (§12 has no open question). No schema/migration (G3 N/A). Three G5 shape changes, each in its owning unit (PayrollJobDayInput → U1, employee-week/roster payload → U2, PayrollCorrection boolean → U3). No new tests. Gate baseline was NOT run (operator standing rule: no unprompted builds/lint/test) — units.md records only the known main sha `d266176fc`; the executor must capture a real baseline before U1 with the developer's go-ahead.

Next: build U1 first (it tests the riskiest assumption — the window-close chain overriding the verified yard-to-yard rule), but U1 is gated on G4 — `tcg-scrum` must write the decision note(s) for Q1-B/Q2/Q7 and the provenance rows land in the same commit as the code. U2 and U3 are unblocked and independent of U1, so they can start in parallel immediately while the G4 note is written. Caveat: U1 and U2 both edit `apps/api/src/usecase/payroll/payroll.service.ts` (different regions) — whichever lands second rebases. Also still pending from sign-off: developer review of §11b D3 (G5)/D4 (deviates from plan) and the ASSUMED items in §14.
