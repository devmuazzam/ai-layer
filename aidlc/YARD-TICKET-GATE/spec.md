# Spec — YARD-TICKET-GATE Yard-Operations dependency for employee tickets

> Retrofitted from the owner decisions of 2026-11-02 and the code/vault sources below. Built
> before this spec existed; this records what was built and where each requirement comes from.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `none` — slug `YARD-TICKET-GATE` |
| Intent | `.ai/aidlc/YARD-TICKET-GATE/intent.md`, captured `2026-11-02` |
| Elaborated on | `2026-11-02` |
| Vault state at elaboration | six `domain/` files verified; field-ops mobile is a known conflict stub (`field-ops/field-ops-mobile-INDEX.md`) |
| Open questions raised | 4, all in §12 — all answered by the owner 2026-11-02 |
| Already-shipped behaviour reached | the mobile dashboard card, the ticket step flow, and `completeLoadout`; enumerated in §11a |
| Rules consulted | `CLAUDE.md`, `contexts/api.md`, `contexts/prisma.md`, `contexts/mobile.md` |

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Gate 1 — block start until Available for Dispatch | mobile, api | `[UNVERIFIED]` | request; `dispatch/daily-allocation-system.md`; code | no |
| REQ-02 | Gate 2 — block Left Yard + later until Complete Loadout | mobile, api | `[UNVERIFIED]` | request; `dispatch/yard-operations-jz.md`; code | no |
| REQ-03 | Per-shift loadout-completion marker | schema, api | `[UNVERIFIED]` | code (`das-loadout-shift-keys.util.ts`); owner decision | no |
| REQ-04 | Expose per-shift yard gate in the field-ticket read model | api | `[UNVERIFIED]` | code (`field-ticket.mapper.ts`) | no |
| REQ-05 | Holdover exemption — behaviour unchanged | mobile, api | `[UNVERIFIED]` | request; `decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md` | no |

Counts: 5 total — 0 verified, 5 unverified, 0 conflicted, 0 open.

## 2. Requirements

### REQ-01 — Gate 1: block start until Available for Dispatch `[UNVERIFIED]`

- **Statement:** a non-holdover employee ticket cannot be started until the matching per-day
  Yard Operations job is marked Available for Dispatch for that ticket's shift.
- **Surface:** mobile, api
- **Sources:**
  - request — `[UNVERIFIED]` — kind: jira — "an employee should only be allowed to start a
    ticket after the corresponding per-day job … is marked Available for Dispatch."
  - `dispatch/daily-allocation-system.md` — `[UNVERIFIED]` — kind: vault — DAS dispatch
    lifecycle and availability.
  - `apps/api/src/service/das-loadout/das-loadout.repository.ts` `markAvailable` — `[UNVERIFIED]`
    — kind: code — sets `markedAvailableAt` + per-shift `markedAvailableShiftsAt`; `dasStage → LOADOUT`.
- **Conflict:** none
- **Open question:** resolved — see §12 Q3 (what is blocked), Q2 (shift scope)
- **Ripple:** the mobile dashboard card and `openFieldTicket`; see §11a.
- **Acceptance:** with the ticket's shift not marked available, the card shows the pending
  message, no Start button, and does not open; `PATCH /field/tickets/:id/steps` returns 409.
- **Edges:**
  - **Reached by:** mobile card tap, `openFieldTicket`, and any `recordTicketStep` call.
  - **Does not apply when:** holdover ticket (REQ-05); a future-dated ticket (already shown as future).
  - **When an input is absent:** no `SubJobLoadout` row ⇒ not available ⇒ blocked.
  - **Trust boundary:** server-derived from `SubJobLoadout`; the client gate is advisory, the API guard authoritative.
  - **Read time:** live.
- **Notes for the executor:** reuse `isShiftMarkedAvailable` (`das-loadout-shift-keys.util.ts`).

### REQ-02 — Gate 2: block Left Yard and later until Complete Loadout `[UNVERIFIED]`

- **Statement:** for a non-holdover ticket, the `leftYard` step and every later required step
  stay blocked until that shift completes Loadout in Yard Operations.
- **Surface:** mobile, api
- **Sources:**
  - request — `[UNVERIFIED]` — kind: jira — "the Left Yard step and all subsequent required
    steps should become available … once that second Yard Operations stage has been completed."
  - `dispatch/yard-operations-jz.md` — `[UNVERIFIED]` — kind: vault — yard loadout punch list.
  - `apps/api/src/service/das-loadout/das-loadout.repository.ts` `completeLoadout` — `[UNVERIFIED]`
    — kind: code — per shift (`dto.shiftNumber`); `dasStage → EMPLOYEE_LEFT_YARD`.
  - `packages/shared/src/constants/ticket-flow-steps.ts` `ALL_TICKET_FLOW_STEP_KEYS` — `[UNVERIFIED]`
    — kind: code — flow order; `leftYard` precedes `driving`, `arriveJob`, `startWork`, ….
- **Conflict:** none — the "second stage" was unconfirmed on the request; confirmed from code as
  Complete Loadout (§12 Q1).
- **Open question:** resolved — see §12 Q1.
- **Ripple:** the ticket step screen; see §11a.
- **Acceptance:** after Available but before Complete Loadout, `pretrip` is allowed, `leftYard`
  shows the locked body and its punch returns 409; after Complete Loadout, `leftYard` and later unlock.
- **Edges:**
  - **Reached by:** `recordTicketStep` for `leftYard`/`arriveJob`/`startWork`/`endWork`/`leftJob`/`arriveYard`/`review`; the step screen render.
  - **Does not apply when:** holdover ticket (REQ-05); steps before `leftYard` in flow order (`pretrip`).
  - **When an input is absent:** no loadout completion for the shift ⇒ blocked.
  - **Trust boundary:** server-derived; API guard authoritative.
  - **Read time:** live.
- **Notes for the executor:** flow-order check against `ALL_TICKET_FLOW_STEP_KEYS` (contains `endWork`); reuse `isShiftLoadedOut`.

### REQ-03 — Per-shift loadout-completion marker `[UNVERIFIED]`

- **Statement:** Yard Operations records loadout completion per shift, so gate 2 can release per shift.
- **Surface:** schema, api
- **Sources:**
  - `apps/api/src/service/das-loadout/das-loadout-shift-keys.util.ts` — `[UNVERIFIED]` — kind:
    code — `markedAvailableShiftsAt` + `isShiftMarkedAvailable` already track availability per shift.
  - owner decision 2026-11-02 — `[UNVERIFIED]` — kind: jira — add the symmetric completion marker (§12 Q2).
- **Conflict:** none
- **Ripple:** `completeLoadout` write path; the existing whole-sub-job `loadoutCompletedAt` is kept. See §11a.
- **Acceptance:** completing loadout for shift N sets `loadout_completed_shifts_at[N]`; other shifts untouched.
- **Edges:**
  - **Reached by:** `DasLoadoutService.completeLoadout` (per `dto.shiftNumber`).
  - **Does not apply when:** N/A — always writes the per-shift marker.
  - **When an input is absent:** legacy rows (null column) read via the shift-1 `loadoutCompletedAt` fallback.
  - **Trust boundary:** server-derived.
- **Notes for the executor:** mirror `markAvailable`'s `mergedShifts` merge; add `isShiftLoadedOut`.

### REQ-04 — Expose the yard gate in the field-ticket read model `[UNVERIFIED]`

- **Statement:** the mobile field-ticket payload carries, for a non-holdover ticket, whether its
  shift is available and loaded out.
- **Surface:** api
- **Sources:**
  - `apps/api/src/usecase/field-tickets/field-ticket.mapper.ts` — `[UNVERIFIED]` — kind: code —
    mapper builds the mobile ticket; `holdover === undefined` is the non-holdover test.
- **Conflict:** none
- **Ripple:** adds optional `yardGate` to the `FieldTicket` response (additive); see §11a — G5.
- **Acceptance:** list/detail responses include `yardGate: {available, loadedOut} | null`; null for holdover.
- **Edges:**
  - **Reached by:** `GET /field/tickets`, `GET /field/tickets/:id`.
  - **Does not apply when:** holdover ticket or no sub-job ⇒ `null`.
  - **When an input is absent:** no loadout row ⇒ `available=false, loadedOut=false`.
  - **Trust boundary:** server-derived.
  - **Read time:** live.
- **Notes for the executor:** add `loadout` to `mobileTicketSelect`; `findYardGateForTicket` for the guard.

### REQ-05 — Holdover exemption `[UNVERIFIED]`

- **Statement:** holdover jobs/tickets are entirely exempt; their flow is unchanged.
- **Surface:** mobile, api
- **Sources:**
  - request — `[UNVERIFIED]` — kind: jira — "This behavior change must apply only to
    non-holdover jobs and tickets. Existing holdover … must remain completely unchanged."
  - `decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md` — `[UNVERIFIED]`
    — kind: decision — the holdover flow.
  - `apps/api/src/usecase/job-tickets/resolve-holdover.ts` — `[UNVERIFIED]` — kind: code —
    non-holdover ⇒ `resolveHoldoverForTicket` returns `undefined`.
- **Conflict:** none
- **Ripple:** none — the gate is skipped when holdover is present.
- **Acceptance:** a holdover ticket carries `yardGate: null`, shows no gate, and the API guard does not fire.
- **Edges:**
  - **Reached by:** every gate check (mapper, mobile selectors, API guard).
  - **Does not apply when:** N/A — this IS the exemption.
  - **When an input is absent:** no holdover repo wired ⇒ API guard skips (fails open) rather than risk gating holdover.
  - **Trust boundary:** server-derived.
- **Notes for the executor:** mapper gate only when `holdover === undefined`; mobile `yardGate == null` ⇒ no gate.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes
- **Migration required:** yes — `20261102120000_yard_loadout_completed_shifts_at` (committed)
- **Data backfill required:** no — nullable; shift-1 reads fall back to `loadoutCompletedAt`
- **Existing models considered:** `SubJobLoadout` is the one-to-one yard workflow row for a
  `SubJob`; the marker belongs on it beside `markedAvailableShiftsAt`. No new table (one-to-one,
  no history, no independent lifecycle) — a column, per `contexts/prisma.md`.

```prisma
// SubJobLoadout — additive
loadoutCompletedShiftsAt Json? @map("loadout_completed_shifts_at") @db.JsonB
```

- New prefix introduced: no
- Child relations: none new
- Fields whose type no source states: none — JSONB map `{ "<shift>": "<iso>" }`, matching `marked_available_shifts_at`

## 4. API surface — `apps/api`

- **Pattern:** none new — extends the existing field-tickets read model and the job-tickets step guard.
- **Existing functions/services to reuse:** `isShiftMarkedAvailable`/`isShiftLoadedOut`
  (`das-loadout-shift-keys.util.ts`), `resolveHoldoverForTicket`, `JobTicketsRepository`.
- **New exported functions proposed:** `isShiftLoadedOut` (util); `JobTicketsRepository.findYardGateForTicket`.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/v1/field/tickets` | `field-tickets.controller.ts` | `field-tickets.service.ts` → `field-ticket.mapper.ts` | `job-tickets.repository.ts` | REQ-04 |
| `PATCH` | `/api/v1/field/tickets/:id/steps` | `field-tickets.controller.ts` | `job-tickets.service.ts` `recordTicketStep` | `job-tickets.repository.ts` | REQ-01, REQ-02 |

- **Response shape:** adds `yardGate: { available: boolean; loadedOut: boolean } | null`.
- **Errors:** gated step punch → `409 Conflict`, message mirrors the card copy (gate 1) / "available once the Yard Operation completes Loadout" (gate 2).
- **Module registration:** no new module; no constructor changes to providers (guard uses already-injected `ticketHoldoverRepository` + `jobTicketsRepository`).

## 5. Web surface — `apps/web`

`N/A — web does not consume the field-ticket read model and the Yard Operations screens are unchanged.`

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `(field)/field.tsx` (dashboard), `(field)/ticket/step/[key]` (step screen).
- **Components:** `components/field/ticket-card.tsx` (future-card treatment reused via `isGated`/`gateMessage`), `active-tickets-section.tsx`.
- **Offline / sync behavior:** no new sync; the gate reads the ticket payload and the API guard rejects a stale/offline gated punch.
- **Touch targets:** unchanged.
- **Push / notifications:** `N/A` — picked up on next fetch; noted as a follow-up.

## 7. Shared package — `packages/shared`

`N/A` — reads existing `ALL_TICKET_FLOW_STEP_KEYS`; no new shared type (mobile keeps its own zod).

## 8. Permissions and tenancy

- **Roles permitted / denied:** unchanged.
- **Tenant isolation:** standard; `SubJobLoadout` inherits isolation through `SubJob` — no `TENANT_SCOPED_MODELS` entry (no new model).
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `loadout_completed_shifts_at` | JSON map keyed by shift number string → ISO instant | code (mirrors `marked_available_shifts_at`) | `[UNVERIFIED]` |

## 10. Tests

`not requested` (root `CLAUDE.md`). Existing suites updated to match the changed `completeLoadout`
signature and the new guard mock; no new spec files added.

## 11. Non-functional

- **Performance:** one extra selected relation on the ticket read; one focused read in the guard.
- **Concurrency:** per-shift JSON merge in `completeLoadout` is a read-modify-write inside a
  `$transaction` at Read Committed with no row lock — two shifts completing at the same instant
  could lose one key (tcg-prisma-guardian finding 3). Same pattern as `markAvailable`, needs two
  yard users acting at once; low risk, report-only unless it recurs.
- **Audit:** unchanged.
- **Migration/rollout order:** schema → API → mobile. Additive column, no gating until the API ships `yardGate`.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `das-loadout.service.ts` `completeLoadout` | repo method signature | REQ-03 | gains a `shiftNumber` arg; passes `dto.shiftNumber` | code | `grep -rn 'completeLoadout(' apps/api/src` |
| `das-loadout-*.spec.ts` (3) | `completeLoadout` assertion arity | REQ-03 | assertions updated (+1 arg) | code | `grep -rn 'completeLoadout).toHaveBeenCalledWith' apps/api/src` |
| `job-tickets.service.spec.ts` | `recordTicketStep` now reads yard gate | REQ-01/02 | mock gains `findYardGateForTicket` | code | `grep -rn 'buildStepService' apps/api/src/usecase/job-tickets` |
| Mobile `FieldTicket` consumers | added optional `yardGate` | REQ-04 | additive; non-consumers unaffected | code | `grep -rn 'FieldTicketSchema' apps/mobile` |
| Future-ticket card path | `isFuture` treatment | REQ-01 | shared with gated card via `futureOrGated` | code | `grep -rn 'isFuture' apps/mobile/components/field/ticket-card.tsx` |

- **Surfaces with no existing behaviour in this area:** web — confirmed `yardGate`/`FieldTicket` not imported by `apps/web` (`grep -rn 'yardGate\|field-ticket.mapper' apps/web/src` → none).
- **Consumers with no source for what happens to them:** none.

## 11b. AI decisions — reviewed by a developer

| ID | Decision | Chosen | Why / alternatives | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | where per-shift completion lives | `loadout_completed_shifts_at` JSONB column on `SubJobLoadout` | one-to-one, symmetric with `marked_available_shifts_at`; rejected deriving from `SubJobLoadoutItem` (heavier read, duplicates yard-board logic) | yes — G3 (tenant data / schema) | | |
| D2 | gate-2 step set | `leftYard` and later by `ALL_TICKET_FLOW_STEP_KEYS` index, **excluding `startWork`** | includes `endWork`; unknown key ⇒ gated (server) / not gated (client UI). `startWork` is the punch-in (gate 1), fires before Left Yard in time though it sorts after it in the flow array — gating it 409'd the dashboard Start Work | no | AI (post-review fix 2026-11-02) | 2026-11-02 |
| D10 | gate-2 UX | block navigation into a gated step with a warn toast, not an in-step locked body | owner feedback 2026-11-02: don't open the step; show "This step will be available once the Yard Operation completes Loadout." on tap. Locked body kept only as a deep-link backstop | no | AI | 2026-11-02 |
| D11 | online-mode only | gate enforced only while online; offline completion bypasses it | owner, 2026-11-02 — "only in online mode … do not enforce … if completed offline". Client: every gate call-site is `online && …` (`useOnline`). **Server half superseded by D12.** | n/a | AI | 2026-11-02 |
| D12 | **server enforcement removed** | the gate is **client-only, online-only**; `recordTicketStep` no longer calls any yard guard | PR-review findings 2 & 6: `capturedAt`/`X-Captured-At` could not tell an offline-captured punch from an online-retry replay op (persisted at `ticket-step-screen.tsx` before the live send), so the server guard both leaked (a 409'd online punch drained later and succeeded) and 409'd the online finalization review punch (sent without `capturedAt`). A guard that leaks and breaks finalization is worse than none. Removed `assertYardGateAllowsStep`, `isLeftYardOrLater`, `findYardGateForTicket`. Supersedes D2, D3-server, D11-server. The client still reads the live `yardGate` and gates while online. | **yes — reverses G4 "client + server"** | | 2026-11-02 |
| D3 | guard placement | in `recordTicketStep`, **below** the idempotent-COMPLETE short-circuit and skipped for returned-correction / approved-edit | corrected after tcg-analyst U1 finding 2: above the short-circuit it 409'd COMPLETE re-drains and blocked payroll corrections/approved edits; it must gate only a live forward punch | no | AI (post-review fix 2026-11-02) | 2026-11-02 |
| D4 | response field | additive optional `yardGate` on `FieldTicket` + mobile zod | G5 contract change; web unaffected | yes — G5 (changed response shape) | | |
| D5 | `isShiftLoadedOut` fallback scope | fallback to `loadoutCompletedAt` only when the per-shift map is empty | fixes tcg-prisma-guardian finding 1 — `completeLoadout` always sets `loadoutCompletedAt`, so an unconditional shift-1 fallback mis-reads shift 1 when only a later shift completed | no | AI (post-review fix 2026-11-02) | 2026-11-02 |
| D6 | missing loadout row → gate value | mapper sends `{available:false, loadedOut:false}`, not `null` | fixes tcg-analyst U2 finding 2 — `null` reads as "no gate" on mobile, so a not-yet-available ticket showed Start then 409'd. REQ-01/04 say no row ⇒ blocked | no | AI (post-review fix 2026-11-02) | 2026-11-02 |
| D7 | gate only pre-start | selectors/step-lock skip started, in-progress, COMPLETE, already-left-yard, correcting and edit-approved tickets | fixes tcg-analyst U2 finding 3 — the gate is a pre-start concept; it must never block viewing/correcting recorded data or lock an in-flight ticket mid-shift | no | AI (post-review fix 2026-11-02) | 2026-11-02 |
| D8 | gated UI copy not on any source | "Pending" status pill; "Waiting on the yard" locked-step title | Q3=A mandated only the future treatment + the body sentence (which is sourced); these labels are AI presentation choices | no | | |
| D9 | single-shift re-mark clears the marker | `markAvailable` single-shift branch sets `loadoutCompletedShiftsAt: Prisma.DbNull` beside `loadoutCompletedAt: null` | fixes tcg-analyst U1 finding 3 — re-marking a shift available must re-close gate 2, matching the pre-existing `loadoutCompletedAt` reset. Multi-shift re-mark completion handling is unchanged from before this ticket (not a regression) | no | AI (post-review fix 2026-11-02) | 2026-11-02 |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Reviewed by | Enumerated by |
| --- | --- | --- | --- | --- |
| Future-ticket card | future-card treatment | yes — parametrized in the same unit (U2), not forked | | `grep -rn 'isFuture' apps/mobile/components/field` |
| `isShiftMarkedAvailable` | per-shift JSON marker + shift-1 fallback | **fixed** — PR-review finding 5 confirmed the unconditional shift-1 fallback let marking shift 2 unlock shift 1. Restricted to an empty per-shift map, matching D5. Other consumer `das-allocations.repository.ts:767` only benefits (correct per-shift reads). | AI 2026-11-02 | `grep -rn 'isShiftMarkedAvailable' apps/api/src` |

## 12. Open questions — answered 2026-11-02

### Q1 — Which Yard Operations stage releases gate 2?
- **Question:** the request says "Load Out / Start Load Out — confirm"; which event unlocks Left Yard?
- **Options:** A. Complete Loadout (`completeLoadout`, `dasStage → EMPLOYEE_LEFT_YARD`) · B. an earlier "loadout started" event · X. Other
- **Answer:** `A — owner, 2026-11-02`
- **Blocked:** REQ-02
- **Owner:** syedharis14@gmail.com
- **Status:** resolved — decision note pending (`tcg-scrum` to write `decisions/2026-11-02-yard-ticket-gate-stages.md`)

### Q2 — Per-shift or whole-sub-job?
- **Question:** gate on the ticket's shift, or the whole sub-job?
- **Options:** A. per-shift · B. whole sub-job (`dasStage`) · X. Other
- **Answer:** `A — owner, 2026-11-02` (requires the REQ-03 marker; `loadoutCompletedAt` alone is whole-sub-job)
- **Blocked:** REQ-01, REQ-02, REQ-03
- **Owner:** syedharis14@gmail.com
- **Status:** resolved — decision note pending

### Q3 — What does gate 1 block on mobile?
- **Question:** lock the whole card, or show Start and block on open?
- **Options:** A. lock the whole card (future treatment) · B. show Start, block on open · X. Other
- **Answer:** `A — owner, 2026-11-02`
- **Blocked:** REQ-01
- **Owner:** syedharis14@gmail.com
- **Status:** resolved — decision note pending

### Q4 — Where is the dependency enforced?
- **Question:** client only, or client + server?
- **Options:** A. client + server guard · B. client only · X. Other
- **Answer:** `A — owner, 2026-11-02`
- **Blocked:** REQ-01, REQ-02
- **Owner:** syedharis14@gmail.com
- **Status:** resolved — decision note pending

### Q5 — Legacy multi-shift loadouts completed before the new column
- **Question:** a sub-job whose shift 2 completed loadout before this deploy has no per-shift
  marker; after deploy `isShiftLoadedOut(…, 2)` is false, so gate 2 blocks that shift-2 ticket's
  Left Yard. Accept, or backfill `loadout_completed_shifts_at` from `SubJobLoadoutItem.loadoutAt`
  grouped by the `shift-N:` prefix?
- **Options:** A. accept — live tickets at deploy are almost all COMPLETE, gate never fires · B.
  backfill (adds data, destroys none; needs a staging-copy dry run) · X. Other
- **Answer:** *blank — developer/owner decision*
- **Blocked:** none for live gating; only historical shift-2 rows.
- **Owner:** syedharis14@gmail.com / dev
- **Status:** open (tcg-prisma-guardian finding 2, 2026-11-02)

### Q6 — No-load / employee-only shifts
- **Question:** a non-holdover ticket whose sub-job has nothing loadable — the yard UI disables
  Mark Available and `completeLoadout` rejects an empty loadout, so the job can never reach
  Available/Loaded. Should such a ticket be gated at all, and if not, what marks it "no-load"?
- **Options:** A. never gate a sub-job with no loadable asset/tool items (mapper sends
  `yardGate: null`); B. a yard "release without loadout" action that marks it available; C. gate
  stays (these tickets wait for a yard action) · X. Other
- **Answer:** *blank — owner decision*
- **Blocked:** REQ-01 for no-load sub-jobs (PR-review finding 1). Code deferred until answered —
  the loadable-item signal is not guessed. Open gap: `vault/dispatch/gaps.md`.
- **Owner:** syedharis14@gmail.com / dispatch
- **Status:** open (PR-review finding 1, 2026-11-02)

## 13. What this spec deliberately does not specify

- Real-time push when the yard releases a job — no source; mobile picks it up on next fetch.
- Per-shift gate 2 for historical multi-shift loadouts completed before the new column — shift-1
  fallback only; irrelevant for live gating (those tickets are COMPLETE).
- Old mobile builds (prior zod) strip the unknown `yardGate` key, so their UI does not gate. With
  server enforcement removed (D12) they are simply ungated — no 409, no error. Acceptable: the gate
  is a dispatch convenience, not a safety control.
- No-load / employee-only sub-jobs (PR-review finding 1) — gating deferred to §12 **Q6**.
- Concurrent `completeLoadout` on two shifts of one sub-job can race the JSON merge and drop a
  shift key (PR-review finding 7 / tcg-prisma-guardian finding 3). Low-risk (two yard users at
  once); follow-up to make the merge atomic in SQL (`col = COALESCE(col,'{}') || jsonb_build_object(...)`),
  same for `markAvailable`. Its own sweep PR.
- Server enforcement is gone (D12): the gate is client-only and online-only, so it is not a
  backstop against a tampered client — accepted trade-off for a dispatch-convenience gate.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement answered — the four §12 questions are resolved
- [ ] Decision notes written in `.ai/vault/decisions/` (pending — `tcg-scrum`)
- [x] Answers written back into this spec
- [x] Edges filled on every requirement
- [x] §11a ripple rows sourced
- [ ] A developer has reviewed §11b/§11c (D1 G3, D4 G5 await developer)
- [x] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________
