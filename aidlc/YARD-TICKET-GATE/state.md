# State — YARD-TICKET-GATE Yard-Operations dependency for employee tickets

**Path:** A · **Branch(es):** `feat/yard-ops-ticket-start-gate` (off `origin/staging`) · **Last updated:** 2026-11-02 by *AI (retrofit)*

## Phases

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (retrofitted; not via `tcg-elaborator`)
- [ ] Sign-off — `spec.md` §14: §11b D1 (G3) and D4 (G5) await a named developer; decision notes for §12 Q1–Q4 not yet written
- [x] Units — `units.md` (retrofitted; not via `tcg-decomposer`)
- [x] Build — U1 + U2 built on one branch (deviation from one-unit-one-PR, recorded in `units.md`)
- [x] Analyse — `tcg-prisma-guardian` (G3), `tcg-contract-tracer` (G5), `tcg-analyst` U1 + U2 run; findings fixed (D5–D9) and recorded
- [ ] Merged — PR not raised
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

## Resume

Code built and green on `feat/yard-ops-ticket-start-gate` (off `origin/staging`, SDK 58),
migration `20261102120000_yard_loadout_completed_shifts_at` applied via `migrate deploy`. Overlay
retrofitted (`intent`/`spec`/`units`/`state`), all four §12 questions answered. The four review
agents ran and surfaced five real defects, all now fixed and recorded in `spec.md` §11b:
D5 (`isShiftLoadedOut` fallback only when the per-shift map is empty — guardian F1),
D6 (mapper sends `{false,false}` not `null` for a missing loadout row — analyst U1 F1 / U2 F2),
D7 (gate scoped to pre-start / non-complete tickets — analyst U2 F3),
D3-corrected + the guard moved below the idempotent-COMPLETE short-circuit and skipped for
returned-correction / approved-edit (analyst U1 F2),
D9 (single-shift re-mark clears the per-shift marker — analyst U1 F3), plus the Jobs-tab sibling
now gated (analyst U2 F1). Gates after fixes: `@tcg/api` build + 388 specs pass; `@tcg/mobile`
typecheck 0, lint 0, card/contract/active-tickets 93 pass. Next: developer sign-off on §11b D1 (G3)
and D4 (G5) and §12 Q5/Q6; `tcg-scrum` writes the §12 Q1–Q4 decision note; raise the PR; then
`close-ticket`. Blocking: nothing for build; sign-off is the human gate.
