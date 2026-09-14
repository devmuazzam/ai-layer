# Units — SCRUM-LOADOUT-UNASSIGNED Unassigned slots are not loadable; card warns before Mark Available

> Written to `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/units.md` from the approved `spec.md` beside it.
> Decomposed 2026-09-14. All three spec questions (Q1–Q3) are resolved 2026-09-14; zero open
> requirements. Zero schema/migration in this ticket (spec §3/§0).

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | `complete-loadout` API rejects an unassigned item key or an empty selection, even from a client that bypasses the UI | REQ-06, REQ-07, REQ-08 (api tests) | api | — | S | not started |
| U2 | Start Loadout (Phase-1) modal shows unassigned rows greyed and unselectable, and disables Loadout when nothing selectable remains | REQ-04, REQ-05, REQ-08 (web tests), REQ-09 (2 of 4 test IDs) | web | — | S | not started |
| U3 | Job card shows an unassigned-slot count chip, Mark Available's confirm modal lists unassigned slots needing review, and Mark Available is disabled when nothing is assigned (asset/employee) or loadable (tool qty > 0) | REQ-01, REQ-02, REQ-03, REQ-09 (2 of 4 test IDs) | web | — | M | not started |

- Requirements not covered by any unit: none — all 9 requirements (REQ-01..09) covered. REQ-08 and
  REQ-09 are cross-cutting (tests / test IDs for the other seven requirements) and are split across
  the unit that builds the behaviour they cover, per the ripple rule that a regression/coverage row
  belongs to the unit that touches the code, not to a separate "tests" unit.
- Units blocked on an open question: none — Q1, Q2, Q3 all resolved 2026-09-14 (`spec.md` §12).

**Coverage note on REQ-08/REQ-09's own scope.** REQ-08's statement is self-bounded to "REQ-04
through REQ-07" — it does not name REQ-01, REQ-02 or REQ-03. `spec.md` §10 independently adds a
test row for REQ-03 (Mark Available disable logic) but none for REQ-01 or REQ-02. REQ-09's body
enumerates four elements ("the unassigned-count chip, the Mark Available disabled state, the
Phase-1 unselectable-row state, the Loadout-button disabled-on-unassigned-only state") — REQ-01,
REQ-03, REQ-04, REQ-05 respectively — and does not name REQ-02's "needs review" list. REQ-09's
*statement* is general ("every new interactive/assertable element this ticket adds"), so U3 applies
it to the needs-review list too; that is applying an existing general requirement to a concrete
render, not adding a new one. REQ-02 has **no test requirement from any source** (§10 is silent on
it and REQ-08 excludes it by name) — U3 flags this rather than silently treating a test as mandated.

---

## U1 — API guards on `complete-loadout`

- **Outcome:** A `complete-loadout` call is rejected with `400` when it names an item key with no
  allocation for that shift, or when its combined selection is empty — closing the gap that lets a
  client bypass the web UI's rules entirely.
- **Kind:** vertical
- **Requirements covered:** REQ-06 (fully), REQ-07 (fully), REQ-08 (api-test portion only — web
  portion is U2's)
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | No schema/migration — confirmed by `spec.md` §0 (`prisma.md` consulted, "no schema/migration needed") |
| API (`apps/api`) | `apps/api/src/usecase/das-loadout/das-loadout.service.ts` — `completeLoadout` (~lines 235-338). Add two guard clauses before the call to `this.loadoutRepository.completeLoadout(...)`: (1) REQ-07 — combined selection non-empty, mirroring `completeOffload`'s guard at `das-loadout.service.ts:463-465` (`throw new BadRequestException('Nothing to offload for this shift.')`) with distinct wording (`NOT SPECIFIED` exact text, spec REQ-07 notes — Phase-3 wording must not be reused verbatim); (2) REQ-06 — every `dto.assets`/`dto.employees` `itemKey` matches a row in `subJob.resourceAllocations` for the shift, keyed the same way `buildCatalogItems`'s existing `allocationLabelByKey` map already builds it (`shift-{shiftNumber}:{jobResourceId}`, `das-loadout.service.ts:987-1010`) — distinct from, and does not replace, the existing "Unknown … item" 400s at lines 289/306/318. | REQ-07's own note: decide whether the empty-selection check reads the raw DTO arrays or the assembled `items` array (which can be non-empty via `carryForwardExtras` alone, lines 265-278) — `NOT SPECIFIED`; get it wrong and a legitimate carry-forward-only submission is blocked, or a genuinely empty one is let through. |
| Web (`apps/web`) | N/A | No web change in this unit |
| Mobile (`apps/mobile`) | N/A | `spec.md` §6 — no mobile loadout surface |
| Shared (`packages/shared`) | N/A | `spec.md` §7 — loadout DTOs are web-local, not `@tcg/shared` exports |
| Tests | New spec file colocated in `apps/api/src/usecase/das-loadout/` (exact name `NOT SPECIFIED`; pattern matches `das-loadout-save-photos.spec.ts` / `das-loadout-defer-allocation.spec.ts` — one file per guarded behaviour, hand-mocked `DasLoadoutService`, no DB). Reuse `completeLoadoutDto()` / `baseSubJob()` style helpers already present in `das-loadout-past-date.spec.ts`. Cases: (a) unassigned item key → 400; (b) empty combined selection → 400; (c) carry-forward-only, DTO-empty submission → still succeeds (REQ-07's own open note); (d) **regression** — an item key not in the catalog at all still throws the existing distinct "Unknown … item" message, unaffected by the new guard. Run via `pnpm nx run @tcg/api:test`. |

### Reviewable as

- **Demo:** call `POST /api/v1/das/sub-jobs/:subJobId/loadout/complete-loadout` directly (curl/Postman, or the existing web UI with the network payload edited) with (a) an item key for a `JobResource` slot that has no `resourceAllocations` row for the shift, and (b) `assets: []`, `employees: []`, `tools: []` — both return `400` after this unit; both succeed today.
- **Acceptance:** checked against REQ-06 and REQ-07's Acceptance lines (spec §2), and REQ-07's carry-forward-only note.
- **Reviewer can verify without:** U2, U3 (no UI dependency), a real tenant or seed data beyond the new spec file's hand-built fixtures (mirrors the existing `das-loadout-*.spec.ts` pattern — no DB needed for this unit's own tests).

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-06 and REQ-07 both sourced from `intent.md` (`[UNVERIFIED]`, kind: jira, synthetic ticket) plus corroborating code reads; no independent vault or Jira confirmation.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no — read-only check against `subJob.resourceAllocations`, already loaded for the request; no new query, no writes, no backfill.
- **Blast radius:** if the allocation-key guard's key format does not exactly match `buildCatalogItems`'s `shift-{shiftNumber}:{jobResourceId}` construction, it either false-rejects legitimate submissions (blocking a job from ever completing loadout) or false-accepts everything (no guard at all). If the empty-selection check reads the wrong array (raw DTO vs. assembled `items`), a legitimate carry-forward-only submission can be wrongly blocked.

**`[UNVERIFIED]` + not reversible check:** this is a code-only, additive guard on an existing route with no schema or data change — trivially reversible by reverting the two clauses. Not expensive to undo, so `[UNVERIFIED]` is not a pre-build blocker here. The two ambiguities above (message text, DTO-vs-`items` check) are within-unit implementation choices the executor must pick, not open questions — no new `spec.md` §12 entry needed.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `apps/web/src/features/dylen-dashboard/hooks/use-dylen-loadout-mutations.ts` `completeLoadout` mutation (no `onError`, unlike sibling `savePhotos`) | direct call to `dylenLoadoutApi.completeLoadout` | **none — pre-existing gap, not created by this unit.** The mutation was already silently swallowing the existing "Unknown … item" 400s; this unit adds two more reachable 400s to the same unhandled path, it does not introduce the gap. | `spec.md` §13 — reporter explicitly declined to add an `onError` toast this ticket; named candidate follow-up |
| `das-loadout.service.ts` "Unknown asset/employee/tool item" 400s (existing, `:289,306,318`) | same `completeLoadout` method | test case (d) above — same new spec file asserts this path is unaffected | `spec.md` §11a, direct code read |

### Deliberately not in this unit

- **`onError` toast for the two new 400 responses** — ~~declined~~ **reversed 2026-09-14 after U1 UAT: moved into U2** (`spec.md` REQ-05 addendum / §13). U2 adds `onError: toastMutationError` to the `completeLoadout` mutation in `use-dylen-loadout-mutations.ts`, same pattern as `savePhotos`.
- **Server-side guard mirroring REQ-03** (Mark Available disabled when zero assigned) — explicitly out of scope, `spec.md` §13 ("no server-side Mark Available guard"); REQ-03 stays web-only, built in U3.
- **An override flag accepted by the API for an unassigned item key** — resolved Q2: never selectable, no override; the API always hard-rejects, no exception path.

---

## U2 — Start Loadout (Phase-1) modal: unassigned rows greyed and unselectable

- **Outcome:** Opening Start Loadout on a shift with an unassigned asset/employee slot shows that
  row present but greyed-out and un-tickable; only assigned rows start pre-ticked (fixing the
  `JOB-00009` defect `intent.md` §2 observed); and the Loadout button stays disabled when the only
  rows present are unassigned, same as today's empty-selection case.
- **Kind:** vertical
- **Requirements covered:** REQ-04 (fully, including Q1/Q2's resolved defaults), REQ-05 (fully),
  REQ-08 (web-test portion covering REQ-04/REQ-05), REQ-09 (test IDs for the Phase-1 unselectable-row
  state and the Loadout-button disabled-on-unassigned-only state)
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | N/A | No API change for these two requirements — only REQ-06/07 touch `apps/api` (spec §4) |
| Web (`apps/web`) | `apps/web/src/features/dylen-dashboard/utils/dylen-phase-handover-modal-init.util.ts` — `applyPhase1InitialState` (~lines 99-123): stop pre-selecting every `allAssetRows` unconditionally (current `setSelectedAssetIds(new Set(allAssetRows.map(...)))`), and stop filtering the employee set by shift number alone — both must exclude unassigned slots. Reuse the existing "Unassigned" placeholder computation already in `build-asset-employee-cards.ts` (spec §5) rather than re-deriving assignment a second way; the function's current params (`allAssetRows: Array<{id:string}>`, `assetCardGroups: Array<{employees: Array<{slotId:string}>}>`) do not carry assignment state today, so widening them or passing an `allocationsBySlot`-derived set through is `NOT SPECIFIED` — executor's implementation choice.<br>`apps/web/src/features/dylen-dashboard/hooks/use-dylen-phase-handover-init.ts` — sole other consumer of `applyPhase1InitialState`; passes through whatever new assignment-aware input the util needs.<br>`apps/web/src/features/dylen-dashboard/components/loadout/dylen-phase-handover-modal-phase1-section.tsx` (candidate Phase-1 row-render component, via `find apps/web/src/features/dylen-dashboard/components/loadout -iname '*phase-handover*'`) — render unassigned rows visibly greyed with a disabled checkbox (Q1/Q2 resolved defaults: greyed and shown, never selectable), and attach the new `data-testid` (REQ-09).<br>`apps/web/src/features/dylen-dashboard/hooks/use-dylen-phase-handover-modal.ts` — `canSubmit` (~lines 161-164): no code change expected per REQ-05's own note ("may fall out of REQ-04 with no separate code path") — verify by test that an all-unassigned shift naturally yields an empty `selectedAssetIds`/`selectedEmployeeIds`; if it does not, this file needs the fix instead. | Distinct disabled-Loadout-button copy ("Nothing assigned to load out.", `intent.md` §3 point 3) beyond the existing generic empty-selection message is `NOT SPECIFIED` in placement (spec §5/§9) |
| Mobile (`apps/mobile`) | N/A | `spec.md` §6 |
| Shared (`packages/shared`) | N/A | `spec.md` §7 |
| Tests | New `apps/web/src/features/dylen-dashboard/utils/dylen-phase-handover-modal-init.test.mjs` (pattern per existing `shift-loadout-button-rules.test.mjs` — `node --test`, dynamic `import()` of the `.ts` file). Cases: (a) **regression** — a shift with only assigned rows still pre-ticks them all, exactly as today; (b) a shift with an unassigned row excludes it from the initial ticked set; (c) a shift whose only rows are unassigned yields an empty selection and `canSubmit`/Loadout-button-disabled is true. Run via `pnpm nx run @tcg/web:test`. |

### Reviewable as

- **Demo:** open Start Loadout on a shift with at least one unassigned asset/employee slot (e.g. a `JOB-00009`-style job) — the unassigned row shows greyed/disabled and unticked; assigned rows are pre-ticked; Loadout button is enabled. Open Start Loadout on a shift where every slot is unassigned — Loadout button is disabled.
- **Acceptance:** checked against REQ-04 and REQ-05's Acceptance lines (spec §2).
- **Reviewer can verify without:** U1, U3 (no code dependency on either), a real tenant beyond one seeded shift with a mix of assigned/unassigned slots for the manual demo (the new test file's fixtures cover the logic without one).

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-04/REQ-05 sourced from `intent.md`, plus Q1/Q2's resolutions, which are themselves reporter-in-session decisions explicitly flagged in their own `Status` lines as "not a product-owner decision; Dylan/Lisette may reverse it."
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** wrongly excluding an *assigned* row from pre-selection would block Dylan from loading real, assigned cargo — a regression on exactly the `JOB-00009`-style jobs this ticket exists to fix. Wrongly including an unassigned row leaves the original defect unfixed.

**`[UNVERIFIED]` + not reversible check:** code-only, no schema/data change, trivially revertible; Q1/Q2's own resolutions are explicitly described as "reversible in one file." Not a pre-build blocker — though since only the reporter (not Dylan/Lisette) has confirmed Q1/Q2, a cheap confirmation from them before merge would remove the remaining doubt without blocking the build.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `use-dylen-phase-handover-init.ts` (+ `applyPhase1InitialState`'s own definition) | `applyPhase1InitialState()` | new test file, case (a) above — pre-existing assigned-row-preselect behaviour asserted unchanged | `spec.md` §11a — "2 consumers … no consumer outside the loadout flow" |
| `use-dylen-phase-handover-modal.ts` `canSubmit` | same Phase-1 selection state | new test file, case (c) — only-unassigned shift disables submit, whether it falls out of REQ-04 alone or needs its own fix | `spec.md` REQ-05 note |

### Deliberately not in this unit

- **An override checkbox/affordance for unassigned rows** — resolved Q2: never selectable, no override; this is a resolved default, not a cut.
- **Tool/rigging row selectability** — unaffected; Q3 excludes tools from the unassigned check entirely, and existing tool-quantity logic (`buildPhase1ToolQuantities`, `buildCarryForwardPhotoIds`) is untouched.
- **Distinct disabled-Loadout-button copy** beyond the existing generic empty-selection message — exact placement `NOT SPECIFIED` (spec §5/§9); ships with the existing generic copy unless sourced before build.

---

## U3 — Job card unassigned chip, Mark Available "needs review" list, and disable rule

- **Outcome:** Dylan sees an amber "`<n>` unassigned" chip on the job card and its expanded shift
  row whenever a shift has an unassigned asset/employee slot; pressing Mark Available on a shift
  with unassigned slots opens the confirm modal with a "needs review" list of them alongside
  existing quantity warnings; and Mark Available is disabled entirely when a shift has no assigned
  asset/employee slot **and** no tool/rigging row with quantity > 0 (Q3's resolution — rigging-only
  / trucking-only jobs stay markable).
- **Kind:** vertical
- **Requirements covered:** REQ-01 (fully), REQ-02 (fully), REQ-03 (fully), REQ-09 (test IDs for the
  unassigned-count chip and the Mark Available disabled state)
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | N/A | `spec.md` §13 — no server-side Mark Available guard this ticket |
| Web (`apps/web`) | `apps/web/src/features/dylen-dashboard/utils/build-asset-employee-cards.ts` (~lines 52-80) — add, or layer a sibling selector on top of, a per-shift "unassigned slot" rollup reusing the existing `allocationsBySlot`/"Unassigned"-placeholder computation, for REQ-01's chip.<br>Job-card / shift-row render — attachment point `NOT SPECIFIED` among `dylen-job-card.tsx`, `dylen-job-card-header.tsx`, `dylen-job-card-expanded.tsx`, `dylen-job-shift-section.tsx` (spec §2 REQ-01 notes); render the amber chip + tooltip (theme token only, no hardcoded colour, per `web.md`), `data-testid` per REQ-09.<br>`apps/web/src/features/dylen-dashboard/context/dylen-loadout-workflow-context.tsx` (~line 169, the `resolveJobLoadoutQuantityWarnings` call site that builds the `mark-available-confirm` modal payload) — extend to also compute unassigned-slot rows for REQ-02.<br>`apps/web/src/features/dylen-dashboard/components/loadout/dylen-loadout-confirm-modal.tsx` and `dylen-loadout-modals-host.parts.tsx` (`MarkAvailableConfirmHost`) — render the new "needs review" section alongside the existing `warnings` list (not replacing it); `DylenLoadoutQuantityWarning` (`types/loadout-workflow.types.ts`, currently keyed by `jobToolId`) needs widening, or a second typed list needs its own key field — `NOT SPECIFIED` which (spec REQ-02 notes).<br>**REQ-03 — correction to the spec's named ripple.** `spec.md`'s Ripple row for REQ-03 names `isJobPrimaryActionDisabled`/`resolveJobPrimaryActionLabel` in `loadout-workflow-utils.ts` as "the existing single gate." Verified: `grep -rn "isJobPrimaryActionDisabled(\|resolveJobPrimaryActionLabel(" apps/web/src --include='*.ts*'` returns **no caller outside their own definition file** — both are dead code. The button actually wired to the UI computes `primaryActionDisabled` inline and separately in `dylen-job-card.tsx` (~lines 104-112) and `dylen-job-shift-section.tsx` (~lines 132-136), via `isDasStageLoadoutLocked`, `isShiftWorkflowComplete`, `isJobDispatchScheduleLock`, `isStartLoadoutScheduleLocked`, and labelled via `resolveShiftPrimaryActionLabel` (`shift-loadout-utils.ts:259`). REQ-03's "no assigned slot AND no tool qty > 0" condition must be OR'd into **both** inline computations (or hoisted into one shared helper both files call) — building only against `loadout-workflow-utils.ts` per the spec's literal citation would change nothing Dylan sees. This does not change REQ-03's behaviour or Acceptance line, only which files implement it. | Chip's tooltip list length cap: `NOT SPECIFIED` (spec §9). Both new 400-message and copy strings throughout: `NOT SPECIFIED`. |
| Mobile (`apps/mobile`) | N/A | `spec.md` §6 |
| Shared (`packages/shared`) | N/A | `spec.md` §7 |
| Tests | New `.test.mjs` file(s) colocated with the changed utils (pattern per `shift-loadout-button-rules.test.mjs`, run via `pnpm nx run @tcg/web:test`). Required by spec: REQ-03's disable logic (§10) — cases: zero assigned + zero tool qty → disabled; zero assigned + a tool row with qty > 0 → still pressable (Q3, the rigging-only/trucking-only case); **regression** — pre-existing lock reasons (DAS-stage-locked, schedule-locked, workflow-complete) still disable the button independent of the new assigned/tool check, i.e. the new condition is OR'd in, not substituted. REQ-01 (chip) and REQ-02 (needs-review list) have **no test requirement from any source** (see ledger note above) — recommended but not spec-mandated: chip count/visibility for 0/1/N unassigned slots; needs-review section appears only when ≥1 slot is unassigned and does not replace the existing quantity-warnings list. |

### Reviewable as

- **Demo:** open the Dylen dashboard on a job with an unassigned asset/employee slot — chip reads "`N` unassigned" on the card and the expanded shift row, tooltip lists the slots. Press Mark Available — confirm modal shows a "needs review" section listing them, alongside any existing quantity warnings. Open a shift with zero assigned asset/employee slots and no tool rows — Mark Available is disabled. Open a rigging-only shift (all assets/employees unassigned, ≥1 tool with quantity > 0, per `2026-05-12-loading-figma-demo.md:161-172`) — Mark Available stays pressable.
- **Acceptance:** checked against REQ-01, REQ-02, REQ-03's Acceptance lines (spec §2).
- **Reviewer can verify without:** U1, U2 (no code dependency on either); print-block or read-only-view changes (explicitly out of scope, §13); a server-side Mark Available guard (explicitly out of scope, §13).

### Risk

- **Weakest source:** `[UNVERIFIED]` — all three REQs. REQ-03's "at least one assigned item" threshold is sourced *only* to the reporter's own in-session agreement (spec §2 REQ-03 sources: "`NOT ON TICKET — no origin cited` beyond the in-session agreement itself").
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** the widest of the three units — REQ-03's disable rule sits on the single most-used action button in the dashboard (Mark Available / Start Loadout / Off-load path). Getting the "assigned OR tool-qty>0" condition wrong either blocks a legitimate rigging-only job (exactly the regression Q3's resolution exists to prevent) or leaves a genuinely empty shift markable (the defect this ticket exists to fix). REQ-02's modal change risks breaking `OffloadIncompleteHost`'s unrelated use of `DylenLoadoutConfirmModal` if `warnings`'s type is widened incompatibly — mitigated by keeping `warnings` optional, which `OffloadIncompleteHost` already relies on (it never passes it).

**`[UNVERIFIED]` + not reversible check:** code-only, no schema/data change, trivially revertible. REQ-03's "one" threshold is a one-line condition to change if wrong, so not expensive to undo — worth a second look from Dylan/Lisette before merge, not before build.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `apps/web/src/features/dylen-dashboard/components/print/dylen-print-job-block.tsx` | `buildAssetEmployeeCards()` shared export | none needed — decided unchanged | `spec.md` §13 ("card chip only") |
| `apps/web/src/features/dylen-dashboard/components/jobs/dylen-job-allocation-readonly.tsx` | `buildAssetEmployeeCards()` shared export | none needed — unchanged, existing "Unassigned" placeholder behaviour untouched | `spec.md` §11a; `build-asset-employee-cards.ts:52,72` |
| `apps/web/src/features/dylen-dashboard/hooks/use-dylen-offload-reasons-modal.ts` | `buildAssetEmployeeCards()` shared export | none needed — Phase-3 explicitly out of scope | `intent.md` §5 |
| `OffloadIncompleteHost` (`dylen-loadout-modals-host.parts.tsx`) | `DylenLoadoutConfirmModal`'s `warnings` prop type | none needed — never passes `warnings`; stays optional after the widening | direct code read |
| `dylen-job-card.tsx` / `dylen-job-shift-section.tsx` `primaryActionDisabled` inline computations | existing lock-reason checks (`isDasStageLoadoutLocked`, `isShiftWorkflowComplete`, `isJobDispatchScheduleLock`, schedule lock) | new test file's regression case — pre-existing lock reasons still disable the button, unaffected by the new assigned/tool condition | this unit's Slice-contents correction, above; direct code read |

### Deliberately not in this unit

- **Print block (`dylen-print-job-block.tsx`) and read-only allocation view (`dylen-job-allocation-readonly.tsx`) unassigned-slot flagging** — decided out of scope, `spec.md` §13; named candidate follow-up ticket.
- **Server-side Mark Available guard mirroring REQ-03** — decided out of scope, `spec.md` §13; matches U1's exclusion of the same.
- **Tool/rigging rows appearing in the chip's count/tooltip or the "needs review" list** — resolved Q3: tools excluded from the unassigned check entirely (they still count separately, toward REQ-03's "something to load").

---

## Sequencing

```
U1 (api)
U2 (web) ─ independent of U1; recommended after/with it
U3 (web) ─ independent of U1 and U2
```

- **Parallelisable:** U1 (`apps/api`) shares no files with U2 or U3 (`apps/web`) — trivially
  parallel. U2 and U3 are both `apps/web` but touch disjoint component/hook files: U2 —
  `dylen-phase-handover-modal-init.util.ts`, `use-dylen-phase-handover-init.ts`,
  `use-dylen-phase-handover-modal.ts`, `dylen-phase-handover-modal-phase1-section.tsx`; U3 —
  `dylen-job-card.tsx`, `dylen-job-shift-section.tsx`, `dylen-loadout-confirm-modal.tsx`,
  `dylen-loadout-modals-host.parts.tsx`, `dylen-loadout-workflow-context.tsx`. **The one named
  shared file:** both may add an "unassigned slot" rollup to `build-asset-employee-cards.ts` — U3
  directly for REQ-01's chip, U2 only if it chooses to source REQ-04's filter from the same file
  rather than from the `assetCardGroups`/`allAssetRows` already passed into
  `applyPhase1InitialState`. Not a blocking dependency; whichever of U2/U3 merges second should
  rebase onto the first's addition there instead of duplicating it.
- **Merge order constraint:** none enforced by a migration — this ticket has no schema change
  (spec §0/§3). `spec.md` §11 (Non-functional) names a *recommended, not required* order: "API
  guards (REQ-06/07) before or with the web pre-selection change (REQ-04), so a stale web client
  cannot submit what the API will reject anyway" — i.e., merge U1 at or before U2. U3 has no such
  note and can merge in any order relative to the other two.
- **First unit to ship:** U1 — it proves the guard's core data-matching assumption (that an
  "unassigned" item key can be correctly identified from `subJob.resourceAllocations` using the
  same `shift-{shiftNumber}:{jobResourceId}` key format `buildCatalogItems` already uses) with zero
  UI dependency and the smallest blast radius of the three units. U2 and U3's web-side rules reuse
  the same underlying "is this slot assigned" concept; if the key-matching assumption is wrong,
  proving it server-side first, against real data shapes, is the cheapest place to catch it.
