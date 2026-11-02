# State — YARD-TICKET-GATE Yard-Operations dependency for employee tickets

**Path:** A · **Branch(es):** `feat/yard-ops-ticket-start-gate` (off `origin/staging`) · **Last updated:** 2026-11-02 by *AI (close)*

## Phases

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (retrofitted; not via `tcg-elaborator`)
- [x] Sign-off — `spec.md` §14 all checked: D1 (G3), D4 (G5), D12 (G4 reversal) signed, §12 Q1–Q6 resolved with decision notes — haris 2026-11-02
- [x] Units — `units.md` (retrofitted; not via `tcg-decomposer`)
- [x] Build — U1 + U2 built on one branch (deviation from one-unit-one-PR, recorded in `units.md`)
- [x] Analyse — `tcg-prisma-guardian` (G3), `tcg-contract-tracer` (G5), `tcg-analyst` U1 + U2 run; findings fixed (D5–D9) and recorded
- [x] Merged — PR #993 to `staging` (`units.md` ledger flipped). Staging → main later.
- [x] Reflect — `reflection.md` (`tcg-reflector`)
- [x] Closed — `close-ticket` run, overlay pushed

## PR-review round (2026-11-02)

A PR review of `22c650d` raised 7 findings; all confirmed valid against the code. Actioned:
- **Findings 2 & 6 (capturedAt leak + finalization 409)** → **D12**: server enforcement removed;
  gate is now client-only + online-only. Deleted `assertYardGateAllowsStep` / `isLeftYardOrLater`
  / `findYardGateForTicket` and the guard call. Reverses G4 — awaits developer sign-off.
- **Finding 5 (`isShiftMarkedAvailable` fallback)** → fixed (fallback only when per-shift map empty).
- **Finding 3 (nav ignores approved-edit)** → fixed in `isYardLeaveBlocked` (exempts `editRequest`
  APPROVED; returned-correction already exempt as COMPLETE).
- **Finding 1 (no-load shifts)** → §12 **Q6** (owner); code deferred, loadable signal not guessed.
- **Finding 4 (legacy shift-2)** → remains §12 **Q5** (owner).
- **Finding 7 (concurrent merge race)** → follow-up sweep PR (§13).

Gates after: `@tcg/api` build + 388 specs pass; `@tcg/mobile` typecheck 0, lint 0.

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
typecheck 0, lint 0, card/contract/active-tickets 93 pass. A PR review then raised 7 findings —
see the PR-review round above; findings 2/5/6/3 fixed (server enforcement removed, D12), findings
1/4 are §12 Q6/Q5, finding 7 is a follow-up.

**CLOSED — 2026-11-02 (`close-ticket`).** Merged to `staging` via **PR #993** (merge
`37fa7d285`); staging → main later. All seven close steps done: `units.md` ledger flipped to
`merged — PR #993`; `tcg-reflector` wrote `reflection.md` and appended the reflections index;
`tcg-scrum` wrote three decision notes (`vault/decisions/2026-11-02-yard-ticket-gate-*.md`) and
flipped every §12 Status to resolved; §14 fully signed (haris); walkthrough untouched (grep found
no pinned surface); `processed.log` row added (PR #993). Sign-offs: D1 (G3), D4 (G5), D12
(G4-reversal) — haris; §12 Q1–Q6 resolved.

**Post-close:** §12 **Q7** (opened at close — no-load sub-jobs unreachable under Q6=C) was
answered **B** by the owner and implemented: the mapper sends `yardGate: null` for a no-load job
(`buildLoadoutAssetCatalogEntries` empty + no tools). Branch `fix/yard-ticket-gate-no-load`
(commit `637d6d123`), not yet merged. `@tcg/api` build + 388 specs + lint 0. Supersedes Q6=C in
`decisions/2026-11-02-yard-ticket-gate-legacy-and-no-load-sub-jobs.md`.

**Carried-forward follow-up:** PR-review **finding 7** (concurrent `completeLoadout` JSON-merge
race) — make the per-shift merge atomic in SQL, its own sweep PR (`spec.md` §13). Re-confirm on the
staging→main promotion that the `processed.log` row and ledger still read PR #993.
