# Spec — SCRUM-LOADOUT-UNASSIGNED Unassigned slots are not loadable; card warns before Mark Available

> Written to `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/spec.md` by the elaborator
> (`.ai/aidlc/agents/inception/tcg-elaborator.md`) from `intent.md` beside it.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-LOADOUT-UNASSIGNED` — no Jira issue; folder name only, same device as `SCRUM-PROGRESS` / `SCRUM-PENDING` / `SCRUM-TZ` |
| Intent | `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/intent.md`, captured `2026-09-14` |
| Elaborated on | `2026-09-14` |
| Vault state at elaboration | ~514 vault content files (excluding `decisions/` and `meetings/`), 6 `domain/` files verified; `dispatch/gaps.md` (79.8 KB) has 18 open entries, none about unassigned loadout items — the adjacent one is *DAS map job status buckets*, not duplicated here; `assets/gaps.md` has 28 open entries, not searched in full (not this ticket's surface) |
| Open questions raised by this spec | 3, all in §12 — carried forward from `intent.md` §12 with the reporter-agreed defaults; none resolved |
| Already-shipped behaviour reached | 6 consumers in §11a; 1 has no source for what happens to it (raised as a question, though not blocking) |
| Rules consulted | `.ai/claude/contexts/api.md`, `.ai/claude/contexts/prisma.md` (confirms no schema/migration needed), `.ai/claude/contexts/web.md` → Test IDs, `CLAUDE.md` → Architecture, Identity Convention |

**Jira MCP was unavailable this session** (`claude.ai Atlassian Rovo` requires authorization not available non-interactively). This does not block elaboration — the ticket has no Jira issue by design (folder-name-only synthetic ticket) — but it means `SCRUM-812` and `SCRUM-903`, named in `intent.md` §9 as related tickets, could not be read directly from Jira. Both are corroborated instead from other sources already in this repo: `SCRUM-812` only as a code comment tag (`apps/api/src/usecase/das-loadout/das-loadout.service.ts:249` "SCRUM-812: gate invalid / empty offload actions", `:200` "SCRUM-812: Mark Available is blocked..."), which is `kind: code` — evidence of what shipped, not of what was decided; `SCRUM-903` has a ticket folder (`.ai/aidlc/SCRUM-903/spec.md`), and its Q3 (`Jobs that never go through yard loadout/offload`, line 47) was confirmed to exist and be unanswered, matching the intent's citation.

**A finding on the DoD's own internal scope split.** `intent.md` §3's four-point agreed behaviour is explicit that point 4 (the API guard) is a mirror of *point 3* (the Phase-1/Start-Loadout modal) only — "so 3 holds even if the UI is bypassed." Point 2 (Mark Available disabled when nothing is assigned) has **no stated API-level mirror** anywhere in the intent. That asymmetry is carried through below as-is (REQ-03 is web-only) rather than silently added to, because inventing a `mark-available` API guard nobody asked for is exactly the kind of unsourced addition this spec must not make; it is flagged in §13.

---

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Unassigned-slot count chip on job card / shift section, with tooltip | web | `[UNVERIFIED]` | intent.md; `dispatch/yard-operations-jz.md`; code | no |
| REQ-02 | Mark Available confirm modal lists unassigned slots under "needs review" | web | `[UNVERIFIED]` | intent.md; code | no |
| REQ-03 | Mark Available disabled when a shift has zero assigned items | web | `[UNVERIFIED]` | intent.md | no |
| REQ-04 | Start Loadout (Phase-1) modal — unassigned rows not pre-selected | web | `[UNVERIFIED]` | intent.md; code; default per Q1/Q2 | no |
| REQ-05 | Start Loadout modal — Loadout button disabled when nothing selectable remains | web | `[UNVERIFIED]` | intent.md; code | no |
| REQ-06 | API `complete-loadout` rejects item keys whose slot has no allocation | api | `[UNVERIFIED]` | intent.md; code; default per Q3 | no |
| REQ-07 | API `complete-loadout` rejects an empty selection | api | `[UNVERIFIED]` | intent.md; code (mirror of `completeOffload` guard) | no |
| REQ-08 | Tests for the API guard and the web button/pre-selection rules | api, web | `[UNVERIFIED]` | intent.md | no |
| REQ-09 | `data-testid`s on the new chip and the new disabled states | web | `[UNVERIFIED]` | intent.md; rule (`web.md` → Test IDs) | no |

Counts: `9` total — `0` verified, `9` unverified, `0` conflicted, `0` open.

No requirement is flagged `[OPEN]` outright: every one of the nine is buildable to a stated default, per the reporter's own instruction in `intent.md` §12 ("buildable without a product answer: yes, with defaults"). Three of the nine (REQ-01, REQ-04, REQ-06) carry an unresolved default inside them — see their `Open question` field and §12.

## 2. Requirements

### REQ-01 — Unassigned-slot count chip on job card / expanded shift section `[UNVERIFIED]`

- **Statement:** When a shift has one or more resource slots (asset or employee) with no DAS allocation, the job card and its expanded shift row show an amber chip reading "`<n>` unassigned" with a tooltip listing the unassigned slots, visible before *Mark Available* is pressed.
- **Surface:** web
- **Sources:**
  - `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/intent.md` §3 point 1 — `[UNVERIFIED]` — kind: jira (synthetic-ticket capture; no Jira issue exists) — states the chip, its colour ("amber"), copy ("`<n>` unassigned"), tooltip, and that it must be visible before Mark Available. This exact wording is the reporter's in-session agreement, not an independent vault or Jira source.
  - `dispatch/yard-operations-jz.md:16,19` — `[UNVERIFIED]` — kind: vault (2026-07-15 yard punch list) — *"if assets / people are not assigned – we should not be able to loadout that particular item"*; *"Employee - unassigned – weird ghost employees"*. Corroborates the underlying problem (unassigned slots reaching loadout) but specifies no chip, colour, copy or tooltip — those details rest on `intent.md` alone.
  - `apps/web/src/features/dylen-dashboard/utils/build-asset-employee-cards.ts:52,72` — kind: code — the card builder **already** renders an `"Unassigned"` placeholder (`assetCode`/`name`) for any slot with no matching `DasAllocationRecord`. Evidence that "assigned" is already computable per slot on the web side from `allocationsBySlot`; it does not currently count or roll those up into a chip.
- **Conflict:** none
- **Open question:** whether a tool/rigging row counts toward "assigned" for this chip, or only asset/employee slots — Q3, logged in §12. Built to the default: tools do not count (they have no allocation concept — see REQ-06's sourcing) and do not appear in the chip's count or tooltip.
- **Ripple:** `build-asset-employee-cards.ts` (the function that already computes per-slot unassigned state) has 4 existing consumers found via `grep -rln "buildAssetEmployeeCards(" apps/web/src --include='*.ts*'`: `hooks/use-dylen-phase-handover-derived.ts` (feeds REQ-04/05), `components/print/dylen-print-job-block.tsx` (print output), `components/jobs/dylen-job-allocation-readonly.tsx` (a read-only allocation view), `hooks/use-dylen-offload-reasons-modal.ts` (Phase-3 offload, explicitly out of scope per `intent.md` §5). None of these four sources says whether a new "assigned" rollup added for the chip should also change the print block's or the read-only view's output. **OPEN — see Q3's note below**: not itself one of the three carried-forward questions, so raised here directly rather than duplicated as a fourth §12 entry — see §13.
- **Acceptance:** On a job with `N` unassigned asset/employee slots in a shift, the card (collapsed) and the expanded shift row both show a chip reading "`N` unassigned"; hovering/tapping the chip lists the unassigned slot labels; the chip is absent when `N` is 0; no chip changes appear on a Phase-3 (offload) view.
- **Notes for the executor:** Reuse the existing `allocationsBySlot` computation in `build-asset-employee-cards.ts` (or a sibling selector layered on top of it) rather than re-deriving allocation state a second way. Candidate render sites, found via `find apps/web/src/features/dylen-dashboard/components/jobs -iname '*.tsx'`: `dylen-job-card.tsx`, `dylen-job-card-header.tsx`, `dylen-job-card-expanded.tsx`, `dylen-job-shift-section.tsx` — none of these is named by any source as *the* attachment point; pick per the existing card/shift-row split. Chip colour: no CSS variable is named by any source — follow `.ai/claude/contexts/web.md` (theme tokens only, no hardcoded colour) and use the existing amber/warning token already used elsewhere in `dylen-dashboard` (e.g. `FeaturedIcon color="warning"` in `dylen-loadout-confirm-modal.tsx`).

### REQ-02 — Mark Available confirm modal lists unassigned slots under "needs review" `[UNVERIFIED]`

- **Statement:** The *Mark Available* confirmation modal lists unassigned resource slots alongside the existing quantity warnings, under a "needs review" heading, when at least one slot is unassigned.
- **Surface:** web
- **Sources:**
  - `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/intent.md` §3 point 2 — `[UNVERIFIED]` — kind: jira — *"the confirm modal lists the unassigned slots under 'needs review' alongside the quantity warnings."*
  - `apps/web/src/features/dylen-dashboard/components/loadout/dylen-loadout-confirm-modal.tsx:15,22,37,63-80` — kind: code — `DylenLoadoutConfirmModal` already accepts a `warnings?: DylenLoadoutQuantityWarning[]` prop and renders it as a bulleted list under the title/description. The existing warning list is populated by `resolveJobLoadoutQuantityWarnings` in `apps/web/src/features/dylen-dashboard/utils/loadout-workflow-utils.ts`. No source specifies whether unassigned-slot rows extend this same `warnings` array (recasting `DylenLoadoutQuantityWarning` to cover both kinds) or render as a second, separately-headed list ("needs review" as intent's own words suggest a distinct heading from the existing unlabelled quantity-warning list) — `NOT SPECIFIED`, left to the executor as a presentation choice, not a product one, since the intent names the "needs review" label but not the exact modal layout.
- **Conflict:** none
- **Open question:** none — depends indirectly on Q3 (does a tool row ever appear in this "needs review" list — default: no, tools have no allocation concept).
- **Ripple:** `DylenLoadoutConfirmModal` has 2 consumers found via `grep -rln "DylenLoadoutConfirmModal" apps/web/src --include='*.ts*'`: `dylen-loadout-modals-host.parts.tsx` (the Mark Available confirm flow — this requirement's target) and the component's own file. No other modal instance reuses it for a different flow per that grep, so widening its `warnings` handling carries no cross-flow ripple.
- **Acceptance:** Marking a shift available where at least one slot is unassigned opens the confirm modal with a "needs review" section naming each unassigned slot, shown alongside (not replacing) any existing quantity warnings; a shift with no unassigned slots and no quantity warnings still opens with no such section (existing behaviour, per current `warnings.length > 0` guard at `dylen-loadout-confirm-modal.tsx:63`).
- **Notes for the executor:** `DylenLoadoutQuantityWarning` (`apps/web/src/features/dylen-dashboard/types/loadout-workflow.types.ts`) is keyed by `jobToolId` today (`dylen-loadout-confirm-modal.tsx:66`, `key={warning.jobToolId}`) — an unassigned asset/employee slot has no `jobToolId`, so this type needs to widen or a second list needs its own key field. Not specified which; flagged so it is not missed.

### REQ-03 — Mark Available disabled when a shift has zero assigned items `[UNVERIFIED]`

- **Statement:** *Mark Available for Loadout* remains pressable when at least one resource slot in the shift is assigned; when zero are assigned, the button is disabled and shows the message used for the empty case.
- **Surface:** web
- **Sources:**
  - `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/intent.md` §3 point 2 and §11 — `[UNVERIFIED]` — kind: jira — *"Mark Available — still allowed when at least one item is assigned; ... If nothing is assigned, the button is disabled with the same message."* §11 records the "at least one assigned item" threshold as `NOT ON TICKET — no origin cited` beyond the in-session agreement itself — i.e. this is the only source for the number "one", and it is the reporter's own agreement, not a separately-cited number.
- **Conflict:** none
- **Open question:** none
- **Ripple:** `isJobPrimaryActionDisabled` / `resolveJobPrimaryActionLabel` in `apps/web/src/features/dylen-dashboard/utils/loadout-workflow-utils.ts` are the existing single gate for the Mark Available / Start Loadout / Off-load button's disabled state and label (only consumer found via `grep -rln "resolveJobPrimaryActionLabel\|isJobPrimaryActionDisabled" apps/web/src/features/dylen-dashboard --include='*.ts*'`: the same `loadout-workflow-utils.ts` file is where callers would extend the check). No other component computes this independently, so the ripple is contained to that one utility and its caller.
- **Acceptance:** A shift with zero assigned asset/employee slots shows *Mark Available for Loadout* disabled with the message from REQ-02/§3's shared wording ("nothing assigned" — exact string `NOT SPECIFIED`, see §9). A shift with at least one assigned slot and the rest unassigned still allows the press (subject to REQ-02's review list appearing). **Per Q3 (resolved):** a shift with zero assigned asset/employee slots but at least one tool/rigging row with quantity > 0 also allows the press — tools count as something to load.
- **Notes for the executor:** No source states whether "assigned" here includes tool/rigging quantity (see Q3 — default: no, mirrors REQ-01/06). **No API-side mirror of this rule is requested anywhere in `intent.md`** — see §0's finding and §13. A developer adding one on their own initiative would be building past the spec.

### REQ-04 — Start Loadout (Phase-1) modal: unassigned rows not pre-selected `[UNVERIFIED]`

- **Statement:** When the Phase-1 handover modal opens, only rows for assigned asset/employee slots are pre-ticked. Unassigned rows still appear in the list (per the Q1 default below) but start unticked and cannot be ticked (per the Q2 default below).
- **Surface:** web
- **Sources:**
  - `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/intent.md` §3 point 3 — `[UNVERIFIED]` — kind: jira — *"Start Loadout modal — unassigned rows are not pre-selected. Only assigned rows are."*
  - `apps/web/src/features/dylen-dashboard/utils/dylen-phase-handover-modal-init.util.ts:99-123` (`applyPhase1InitialState`) — kind: code — **current behaviour is the opposite of the requirement.** `setSelectedAssetIds(new Set(allAssetRows.map((asset) => asset.id)))` pre-selects every asset row unconditionally, with no filter for whether an allocation exists. Employee pre-selection (`employeeIds`) filters only by shift number (`isShiftAssetItemKey`), not by assignment. This is the exact defect `intent.md` §2 describes being observed on `JOB-00009`.
- **Conflict:** none
- **Open question:** two of the three carried-forward questions apply here directly:
  - Q1 — are unassigned rows shown greyed-and-unselectable, or hidden entirely? Built to the default: **greyed, still shown.**
  - Q2 — may Dylan override and tick an unassigned row anyway? Built to the default: **never selectable, no override.**
  Both logged in §12.
- **Ripple:** `applyPhase1InitialState` has 2 consumers, both within `dylen-dashboard`, found via `grep -rln "applyPhase1InitialState" apps/web/src --include='*.ts*'`: its own definition file and `hooks/use-dylen-phase-handover-init.ts`. No consumer outside the loadout flow, so no cross-feature ripple.
- **Acceptance:** Opening Start Loadout on a shift with an unassigned slot shows that row present but unticked and not user-selectable (checkbox disabled); assigned rows are pre-ticked as today. Toggling any other row does not affect the unassigned row's state.
- **Notes for the executor:** The existing carry-forward and on-site-from-prior-schedule logic in the same file (`buildPhase1ToolQuantities`, `buildCarryForwardPhotoIds`) is tool-scoped and untouched by this requirement per Q3's default (tools have no allocation concept, so nothing about them is "unassigned").

### REQ-05 — Start Loadout modal: Loadout button disabled when nothing selectable remains `[UNVERIFIED]`

- **Statement:** The Loadout button in the Phase-1 modal is disabled both when the current selection is empty (existing behaviour) and when the only rows present are unassigned ones — i.e. no selectable row exists to select.
- **Surface:** web
- **Sources:**
  - `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/intent.md` §3 point 3 and §4 — `[UNVERIFIED]` — kind: jira — *"Loadout button disabled when nothing selectable is selected (already true for an empty selection — must also hold when the only rows are unassigned)."*
  - `apps/web/src/features/dylen-dashboard/hooks/use-dylen-phase-handover-modal.ts:161-164` — kind: code — confirms the "already true for an empty selection" half: `canSubmit = phase === 3 ? hasVisibleItems : selectedAssetIds.size > 0 || selectedEmployeeIds.size > 0 || selectedToolIds.size > 0`. For phase 1/2 this already disables the button on zero selection.
- **Conflict:** none
- **Open question:** none directly — this requirement is a direct consequence of REQ-04 (once unassigned rows can never be selected, a shift with only unassigned rows naturally yields an empty `selectedAssetIds`/`selectedEmployeeIds`, and the existing `canSubmit` check per `use-dylen-phase-handover-modal.ts:161-164` already disables the button). Whether a distinct message ("Nothing assigned to load out.", per `intent.md` §3 point 3) should replace the generic disabled state is `NOT SPECIFIED` — see §9.
- **Ripple:** none beyond REQ-04's — same `canSubmit` computation, no other consumer found (see REQ-04's grep).
- **Acceptance:** A shift whose only resource rows are unassigned opens the Phase-1 modal with the Loadout button disabled, same as today's empty-selection case; distinguishing copy, if any, is `NOT SPECIFIED`.
- **Added 2026-09-14 (reporter, after U1 UAT):** the web `completeLoadout` mutation surfaces an API rejection as an error toast (same `toastMutationError` pattern as `savePhotos`), so the U1 400s (`Unassigned … item`, `Nothing to load out for this shift.`) are visible instead of swallowed.
- **Notes for the executor:** This requirement may fall out of REQ-04 with no separate code path — flagged as its own requirement only because `intent.md` calls it out as its own in-scope checklist line.

### REQ-06 — API `complete-loadout` rejects item keys whose slot has no allocation `[UNVERIFIED]`

- **Statement:** `POST das/sub-jobs/:subJobId/loadout/complete-loadout` rejects the request when any `assets`/`employees` item key in the payload corresponds to a `JobResource` slot with no matching row in `subJob.resourceAllocations` for that shift.
- **Surface:** api
- **Sources:**
  - `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/intent.md` §3 point 4 — `[UNVERIFIED]` — kind: jira — *"API — complete-loadout rejects item keys whose slot has no allocation ... so 3 holds even if the UI is bypassed."*
  - `apps/api/src/usecase/das-loadout/das-loadout.service.ts:987-1010` (`buildCatalogItems`) — kind: code — the service already builds `allocationLabelByKey`, a `Map` keyed by `shift-{shiftNumber}:{jobResourceId}` from `subJob.resourceAllocations`, used today only to resolve a display label. This is the exact existing lookup an "assigned" check would test membership against — ground truth that the data needed for this guard is already loaded into the service, not a new query.
  - `apps/api/src/usecase/das-loadout/das-loadout-catalog.util.ts:1-6` — kind: code — doc comment confirms *"catalog is built from JobResource slots, not allocations"*; the catalog util itself carries no assignment state, which is why the check has to happen in the service against `resourceAllocations` separately, as `buildCatalogItems` already does for labels.
- **Conflict:** none
- **Open question:** Q3 — does this check apply only to `SubJobLoadoutItemType.ASSET`/`EMPLOYEE` item keys, or also to `JOB_TOOL`? Built to the default: **asset/employee slots only.** `subJob.job.tools` (the source of `JOB_TOOL` catalog entries, `das-loadout.service.ts:1034`) has no allocation relation at all in the code read for this spec — there is nothing to check a tool against, which is the code-level reason the default reads the way it does. Logged in §12.
- **Ripple:** `completeLoadout` (the mapped usecase method behind this route) has exactly one caller found via `grep -rn "completeLoadout\b" apps/web/src --include='*.ts*'`: `apps/web/src/features/dylen-dashboard/hooks/use-dylen-loadout-mutations.ts:49-57`, which wires the mutation with **no `onError` handler** — unlike the sibling `savePhotos` mutation three lines below it, which calls `toastMutationError(error, 'Failed to save photos')`. Once REQ-04/REQ-05 ship, this new 400 should only ever be reachable by a client bypassing the UI (stale state, direct API call) — but today a rejection here would fail with no visible feedback to Dylan. **OPEN — no source specifies whether this needs a toast; see §13** (not one of the three carried-forward questions, since it is a UX-completeness finding from ripple analysis, not a fact `intent.md` left undecided).
- **Acceptance:** A `complete-loadout` call whose `assets`/`employees` array includes an item key with no corresponding `resourceAllocations` row for that shift returns `400 Bad Request`; the existing "Unknown asset/employee item" path (`das-loadout.service.ts:289,318`, for item keys not in the catalog at all) is unaffected — this is a new, distinct rejection for keys that exist in the catalog but have no allocation.
- **Notes for the executor:** Message text is `NOT SPECIFIED` — no source gives exact copy for this rejection (contrast with the empty-selection message in REQ-07, which the offload guard's exact string sources). Mirror the existing `BadRequestException` pattern already used for the "Unknown … item" cases in the same method.

### REQ-07 — API `complete-loadout` rejects an empty selection `[UNVERIFIED]`

- **Statement:** `POST das/sub-jobs/:subJobId/loadout/complete-loadout` rejects the request when the combined `assets` + `employees` + `tools` selection is empty, mirroring the existing guard on `completeOffload`.
- **Surface:** api
- **Sources:**
  - `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/intent.md` §3 point 4 — `[UNVERIFIED]` — kind: jira — *"rejects an empty selection (mirror of the SCRUM-812 offload guard)."*
  - `apps/api/src/usecase/das-loadout/das-loadout.service.ts:463-465` — kind: code — `completeOffload` (Phase 3) already has this exact shape of guard: `if (selectedItems.length === 0) { throw new BadRequestException('Nothing to offload for this shift.'); }`, tagged `// SCRUM-812: gate invalid / empty offload actions (nothing selected to return).` in a comment on the line above.
  - `apps/api/src/usecase/das-loadout/das-loadout.service.ts:235-338` (`completeLoadout`) — kind: code — **read in full for this spec; no equivalent guard exists on `completeLoadout` today.** The `items` array built from `dto.assets`/`dto.tools`/`(dto.employees ?? [])`/`carryForwardExtras` is passed straight to `this.loadoutRepository.completeLoadout(...)` with no length check. This confirms the requirement is genuinely new work, not a restatement of something that already exists (the intent's parenthetical "mirror of the SCRUM-812 offload guard" names the pattern to copy, not a claim that `completeLoadout` already has it).
- **Conflict:** none
- **Open question:** none
- **Ripple:** same caller as REQ-06 (`use-dylen-loadout-mutations.ts:49-57`, no `onError`) — same finding, not repeated as a second question.
- **Acceptance:** A `complete-loadout` call with `assets: []`, `employees: []` (or omitted) and `tools: []` returns `400 Bad Request`. Exact message text: `NOT SPECIFIED` by `intent.md` — it says only "mirror of the SCRUM-812 offload guard," not that the string must be identical; `'Nothing to offload for this shift.'` is Phase-3-specific wording and reusing it verbatim for Phase 1 would misdescribe the action, so this is flagged rather than assumed.
- **Notes for the executor:** Note `carryForwardExtras` (`das-loadout.service.ts:265-278`) can populate `items` even when `dto.assets`/`dto.tools`/`dto.employees` are all empty — carried-forward tool rows from a prior incomplete handover. Whether the guard should check the raw DTO arrays or the final assembled `items` array (which could be non-empty via carry-forward alone) is `NOT SPECIFIED`; get this wrong and the guard either blocks a legitimate carry-forward-only submission or lets a genuinely empty one through.

### REQ-08 — Tests for the API guard and the web button/pre-selection rules `[UNVERIFIED]`

- **Statement:** REQ-04 through REQ-07's behaviour is covered by tests: web tests for the Phase-1 pre-selection and button-disable rules, API tests for both new `complete-loadout` rejections.
- **Surface:** api, web
- **Sources:**
  - `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/intent.md` §4 — `[UNVERIFIED]` — kind: jira — in-scope checklist line: *"Tests for the API guard and the web button/pre-selection rules."*
- **Conflict:** none
- **Open question:** none
- **Ripple:** n/a — new tests only
- **Acceptance:** `pnpm api:test` covers REQ-06 and REQ-07 (unassigned item key rejected; empty selection rejected; carry-forward-only submission still succeeds per REQ-07's open note). Web coverage (`pnpm test` for `apps/web`, per `CLAUDE.md` → Commands, `web` runs on `node --test`) covers REQ-04's pre-selection filter and REQ-05's disabled state.
- **Notes for the executor:** No source specifies unit vs. integration split, or exact test file names — `NOT SPECIFIED`; follow the existing test layout already present alongside `das-loadout.service.ts` and the `dylen-dashboard` hooks/utils being changed.

### REQ-09 — `data-testid`s on the new chip and the new disabled states `[UNVERIFIED]`

- **Statement:** Every new interactive/assertable element this ticket adds — the unassigned-count chip, the Mark Available disabled state, the Phase-1 unselectable-row state, the Loadout-button disabled-on-unassigned-only state — carries a `data-testid`.
- **Surface:** web
- **Sources:**
  - `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/intent.md` §4 — `[UNVERIFIED]` — kind: jira — in-scope checklist line: *"`data-testid`s on the new chip and disabled states (qa-automation contract)."*
  - `.ai/claude/contexts/web.md` → *Test IDs* — `[UNVERIFIED]` — kind: rule — binding on *how*: kebab-case `<module>-<flow>-<element>[-<modifier>]`, and "before you rename one, `grep -rn '<the-id>' qa-automation/e2e`." Existing `dylen-dashboard` test IDs (`grep -rn 'data-testid' apps/web/src/features/dylen-dashboard`) use module segment `dylen` (`dylen-add-tool-select`, `dylen-jobs-filter-city`, `dylen-jobs-filter-shift`, `dylen-jobs-filter-state`), not `dispatch` — the precedent to follow for new IDs on this feature.
- **Conflict:** none
- **Open question:** none
- **Ripple:** n/a — new IDs only; no existing ID is renamed or removed by this ticket, so the pre-rename grep in the rule does not apply here.
- **Acceptance:** Each of the four new UI states above has a `data-testid` following the `dylen-<flow>-<element>` pattern used elsewhere in the feature.
- **Notes for the executor:** Exact ID strings are `NOT SPECIFIED` — no source names them; the naming *pattern* is sourced (above), the literal strings are an executor choice within that pattern.

### REQ-10 — Job card shows "Partial Loadout" while some but not all items are out `[UNVERIFIED]`

- **Added:** 2026-09-14 by the reporter during U2 UAT on `JOB-00009` — *"we should've a status of partial loadout as well, as one is loadout it says pending offload"*.
- **Requirement:** when a shift's loadout has started (`hasShiftLoadoutStarted`) but is not fully loaded (`isShiftFullyLoadedOut`), and the day is not force-completed/completed, the card's status pill reads **Partial Loadout** (in-progress badge style) instead of *Pending Offload*. Multi-shift: any partial shift → Partial Loadout. Print block inherits via `resolveJobStatusLabel`.
- **Decisions (reporter, reversible):** (a) unassigned asset/employee slots count as *not loaded* — the pill stays Partial until offload completes; the REQ-01 chip explains why. (b) Label only — **no new filter bucket / chip**; the Yard Ops bucket set stays with the open `dispatch/gaps.md` question (*DAS map job status buckets … LOADOUT counted as pending*).
- **Source:** none in the vault; nearest is the punch list *"Different assets can be loaded out at different times"* (`dispatch/yard-operations-jz.md:13`), which implies a state between loaded and not.
- **Built:** `apps/web/src/features/dylen-dashboard/utils/loadout-workflow-utils.ts` (`isPartialLoadoutState`, `resolveJobStatusLabel`), `components/jobs/dylen-job-card-header-parts.tsx`.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no
- **Migration required:** no
- **Data backfill required:** no

`NOT SPECIFIED` — n/a. Sourced by `intent.md` §7 (*"New entity introduced by this ticket: no ... Existing rows affected: no"*) and confirmed by code: "assigned" is derivable entirely from the existing `subJob.resourceAllocations` relation already loaded by `das-loadout.service.ts`'s `buildCatalogItems` (`.ai/claude/contexts/prisma.md` consulted; nothing here touches identity, codes or `entity_sequences`).

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| N/A — no new model | — | — | — | — |

- **New prefix introduced:** no
- **Child relations:** n/a
- **Fields whose type/precision no source states:** n/a

## 4. API surface — `apps/api`

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/api/v1/das/sub-jobs/:subJobId/loadout/complete-loadout` | `das-loadout.controller.ts` (`completeLoadout`, existing) | `das-loadout.service.ts` (`completeLoadout`, existing method, new guards added) | `das-loadout.repository.ts` (`completeLoadout`, existing, unchanged) | REQ-06, REQ-07 |

No new route. Both requirements add guard clauses to the existing `completeLoadout` use-case method, following the layering already in place (`presentation → usecase → service → orm`, `.ai/claude/contexts/api.md`).

- **Request DTO:** `CompleteLoadoutHandoverDto` — existing, unchanged shape (per `intent.md` §6, no schema/DTO field addition named).
- **Response shape:** existing `mapSubJobLoadout` response — unchanged on success; two new `400` failure cases added.
- **Guards / roles:** `AccessTokenGuard` (global) only — confirmed via `apps/api/src/presentation/das-loadout/das-loadout.controller.ts`, no `@Roles`/`@RequirePermission` on `completeLoadout`. `intent.md` §8 explicitly leaves role gating out of scope; unchanged by this ticket.
- **Route param identity:** `subJobId` — existing, unchanged.
- **Errors:**
  - REQ-06: `400` — unassigned item key in `assets`/`employees`. Message: `NOT SPECIFIED`.
  - REQ-07: `400` — empty combined selection. Message: `NOT SPECIFIED` (see REQ-07's note on reusing vs. not reusing the offload guard's exact string).
- **Module registration:** no new module — existing `DasLoadoutModule` registration in `app.module.ts` is unaffected.

## 5. Web surface — `apps/web`

**Feature-first.** All work lands in `apps/web/src/features/dylen-dashboard/`.

- **Routes:** none new — this ticket changes existing components/hooks reached from the Yard Operations (Dylen) dashboard route already in the app; no new route.
- **Existing components to reuse** *(checked before proposing anything new)*:
  - `DylenLoadoutConfirmModal` (`components/loadout/dylen-loadout-confirm-modal.tsx`) — extend for REQ-02's "needs review" list.
  - `build-asset-employee-cards.ts` (`buildAssetEmployeeCards`) — already computes per-slot "Unassigned" state; reuse for REQ-01's chip and REQ-04's pre-selection filter rather than re-deriving allocation membership a second way.
  - `loadout-workflow-utils.ts` (`isJobPrimaryActionDisabled`, `resolveJobPrimaryActionLabel`) — single existing gate for REQ-03.
  - `dylen-phase-handover-modal-init.util.ts` (`applyPhase1InitialState`) — the function REQ-04 changes directly.
  - `use-dylen-phase-handover-modal.ts` (`canSubmit`) — REQ-05's existing empty-selection check.
- **New components proposed:** none required by any source. The chip (REQ-01) and the "needs review" list (REQ-02) can plausibly be built as small additions to existing card/modal components rather than new top-level components — `NOT SPECIFIED` which; left to the executor within the "extend before create" rule (`.ai/claude/contexts/web.md`).
- **Table (if any):** n/a — no table surface touched.
- **Forms:** n/a — no form surface touched; the Phase-1 modal is a selection list, not a react-hook-form/Zod form, per the files read.
- **Server state:** TanStack Query v5, existing — `completeLoadout`/`markAvailable` mutations in `use-dylen-loadout-mutations.ts`, unchanged query keys. See REQ-06/07's ripple note on the missing `onError` handler.
- **Colors / spacing:** CSS variables only, per `.ai/claude/contexts/web.md`. No hex value is sourced for the chip's amber colour — see REQ-01's executor note.
- **Responsive:** `NOT SPECIFIED` — no source describes mobile/tablet layout for the chip or the modal changes; `intent.md` §6 states mobile has no loadout surface at all, so this is desktop/tablet web only, per existing `dylen-dashboard` layout.
- **Copy:** exact strings mostly `NOT SPECIFIED` — see each REQ's Acceptance/Notes. The only string with a citable near-verbatim source is the chip's `"<n> unassigned"` pattern (`intent.md` §3 point 1) and the DoD's parenthetical `"Nothing assigned to load out."` for REQ-05 (`intent.md` §3 point 3) — carried as the DoD's own wording, not independently verified against any UI copy source.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `N/A — mobile has no loadout surface`, per `intent.md` §6, confirmed by no mobile references found in any file read for this spec.
- **Components:** n/a
- **Offline / sync behavior:** n/a
- **Touch targets:** n/a
- **Push / notifications involvement:** `N/A`

## 7. Shared package — `packages/shared`

- **Types added / changed:** `N/A` — `intent.md` §6 flagged this with a "?" (whether the loadout item DTO gains an `isAssigned` flag that web reads from `packages/shared`). Checked directly: `find packages/shared/src -iname '*loadout*'` returns nothing. The loadout item types (`DasSubJobLoadoutItem`, `CompleteLoadoutHandoverPayload`, etc.) live entirely in `apps/web/src/features/das/middle-section/jobs/types/das-loadout.api.ts` — a web-local, hand-typed mirror of the API response shape, not an import from `@tcg/shared`. This ticket's "assigned" flag, if the API response is extended to carry one (not required by REQ-06/07, which reject rather than annotate), would follow the same existing web-local-type pattern, not a new shared export.
- **Nothing shared:** `N/A — the loadout DTOs are web-local types, not `@tcg/shared` exports; confirmed by direct search, not inferred`

## 8. Permissions and tenancy

- **Roles permitted:** unchanged — no role/permission gate exists on the loadout routes today (`intent.md` §8; confirmed in `das-loadout.controller.ts`), and this ticket adds none.
- **Roles denied:** n/a
- **Tenant isolation:** standard — `SubJobLoadout` / `SubJob` / `JobResource` reads already run through the existing tenant-scoped repository calls this ticket adds guard clauses inside of; no new query is introduced.
- **Cross-tenant reads:** none

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `complete-loadout` `assets`/`employees` item keys | must correspond to an allocated `JobResource` slot for the shift | `intent.md` §3 point 4; `das-loadout.service.ts:987-1010` (existing allocation lookup) | `[UNVERIFIED]` |
| `complete-loadout` combined selection | must not be empty | `intent.md` §3 point 4; `das-loadout.service.ts:463-465` (sibling offload guard) | `[UNVERIFIED]` |
| Unassigned-chip count threshold | `NOT SPECIFIED` — no source states a display cap on the tooltip's list length | — | — |
| Error message strings (both new `400`s) | `NOT SPECIFIED` — no source gives exact copy | — | — |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit (web) | `applyPhase1InitialState` excludes unassigned rows from pre-selection | REQ-04 |
| Unit (web) | `canSubmit`/button-disabled logic returns false when only unassigned rows exist | REQ-05 |
| Unit (web) | Mark Available disable logic returns disabled when zero slots assigned | REQ-03 |
| Integration (API) | `complete-loadout` returns 400 for an unassigned item key | REQ-06 |
| Integration (API) | `complete-loadout` returns 400 for an empty combined selection | REQ-07 |
| Integration (API) | `complete-loadout` still succeeds for a carry-forward-only, DTO-empty submission | REQ-07 (its own open note) |
| E2E / manual script | `NOT SPECIFIED` — no source names a `qa-automation/e2e` scenario for this ticket; REQ-09's new test IDs make one buildable but none is specified here |

- Requirements with no testable acceptance criterion: none — every REQ above has a stated Acceptance line, even where exact copy is `NOT SPECIFIED`.

## 11. Non-functional

- **Performance:** `NOT SPECIFIED` — no source states a requirement; the new checks reuse data already loaded (`subJob.resourceAllocations`), so no new query is anticipated, but that is an implementation observation, not a sourced NFR.
- **Concurrency:** n/a — no code minting, no new writes.
- **Audit / activity log:** `NOT SPECIFIED` — no source says whether a rejected `complete-loadout` attempt (REQ-06/07) should write an `ActivityLog` entry.
- **Migration/rollout order:** `NOT SPECIFIED` — no source states one; the natural order given the ripple analysis is API guards (REQ-06/07) before or with the web pre-selection change (REQ-04), so a stale web client cannot submit what the API will reject anyway, but this is not a sourced requirement.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `apps/web/src/features/dylen-dashboard/components/print/dylen-print-job-block.tsx` | `buildAssetEmployeeCards()` shared export | REQ-01 | **OPEN — see §13**; no source says whether print output changes | none | `grep -rln "buildAssetEmployeeCards(" apps/web/src --include='*.ts*'` |
| `apps/web/src/features/dylen-dashboard/components/jobs/dylen-job-allocation-readonly.tsx` | `buildAssetEmployeeCards()` shared export | REQ-01 | unchanged — a read-only view already rendering "Unassigned" per slot; no source asks for a chip there | `apps/web/.../build-asset-employee-cards.ts:52,72` (existing behaviour) | same grep |
| `apps/web/src/features/dylen-dashboard/hooks/use-dylen-offload-reasons-modal.ts` | `buildAssetEmployeeCards()` shared export | REQ-01 | unchanged — Phase 3 (offload) is explicitly out of scope, `intent.md` §5 | `intent.md` §5 | same grep |
| `apps/web/src/features/dylen-dashboard/hooks/use-dylen-phase-handover-derived.ts` | `buildAssetEmployeeCards()` shared export | REQ-01, REQ-04, REQ-05 | changes deliberately — this is the feed for the Phase-1 modal REQ-04 targets | `intent.md` §3 point 3 | same grep |
| `apps/web/src/features/dylen-dashboard/hooks/use-dylen-loadout-mutations.ts` (`completeLoadout` mutation, no `onError`) | direct call to `dylenLoadoutApi.completeLoadout` | REQ-06, REQ-07 | **OPEN — see §13**; no source specifies whether the two new 400s need a toast, unlike the sibling `savePhotos` mutation which has one | none | `grep -rn "completeLoadout\b" apps/web/src --include='*.ts*'` |
| `.../das-loadout.service.ts` "Unknown asset/employee/tool item" 400s (existing, `:289,306,318`) | same `completeLoadout` method | REQ-06 | unchanged — REQ-06 is a distinct new rejection for keys that exist in the catalog but lack an allocation, not a replacement for the existing not-in-catalog check | `das-loadout.service.ts:289,306,318` (existing behaviour) | direct read |

- **Surfaces with no existing behaviour in this area:** `packages/shared` and `apps/mobile` — confirmed absent (§6, §7), not merely unrun.
- **Consumers with no source for what happens to them:** `dylen-print-job-block.tsx`'s print output, and the `completeLoadout` mutation's silent-failure gap — both listed above, neither treated as a blocking §12 question because they are ripple findings from this elaboration rather than gaps `intent.md` itself flagged; see §13.

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered — though, per `intent.md` §12, this ticket is stated as buildable to the defaults given, so "stop" here means: build to the default, and treat each default as reversible in one file until confirmed.

```bash
grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md
```

### Q1 — Unassigned row visibility in the Phase-1 modal

- **Question:** In the Start Loadout (Phase-1) modal, are unassigned rows shown greyed-out and unselectable, or hidden entirely from the list?
- **Why it cannot be answered from what is written:** `intent.md`'s own capture (§12, item 1) already logged this as open: the reporter's wording "only those are selected which are assigned" is read there as "shown but unselected," but that reading is not confirmed. No vault file (`dispatch/yard-operations-jz.md`, `assets/tool-and-rigging.md` Story 5) or transcript hit describes row visibility in this modal at this level of detail.
- **Blocked:** REQ-04 (which rendering the unassigned row uses)
- **Candidates:** `dispatch/yard-operations-jz.md` (952 bytes, updated 2026-07-15) — silent on this; `assets/tool-and-rigging.md` (4.2 KB, updated 2026-05-26) Story 4/5 — describes the loading checklist screen generally, not row-visibility rules for unassigned slots; `2026-05-12-loading-figma-demo.md` transcript, lines 90-175 — describes the *Mark Available* → *Continue Anyway* quantity-warning flow and Dylan's "no equipment required" idea, neither of which addresses unassigned-row visibility.
- **Owner:** Syed Haris (reporter; `hariscops`) — the person who agreed the four-point behaviour in-session.
- **Workaround, if any:** build to the default from `intent.md` §12: **greyed, still shown** — reversible in one file (the Phase-1 row-render component).
- **Status:** resolved 2026-09-14 — Syed Haris (reporter, in-session): **greyed, still shown**. Not a product-owner decision; Dylan/Lisette may reverse it — reversible in one file (Phase-1 row-render).

### Q2 — Override for unassigned rows

- **Question:** May Dylan manually tick an unassigned row anyway (an override), or is it never selectable?
- **Why it cannot be answered from what is written:** `intent.md` §12 item 2 logged this as open: the July 2026 punch list (`dispatch/yard-operations-jz.md:16`) reads as "never" ("we should not be able to loadout that particular item"), but the reporter has not confirmed this for the specific UI control being built, and an override is a materially different feature (an explicit exception path) from a hard block.
- **Blocked:** REQ-04 (whether the row's checkbox is ever interactive); indirectly REQ-06 (whether the API should accept an override flag, or must always hard-reject — the current spec assumes the latter)
- **Candidates:** `dispatch/yard-operations-jz.md:16` (952 bytes, 2026-07-15) — the only vault statement, reads as "never," not adjudicated; no Jira ticket to check further this session (Jira MCP unavailable, see §0).
- **Owner:** Syed Haris (reporter)
- **Workaround, if any:** build to the default from `intent.md` §12: **never selectable, no override** — reversible in one file (same Phase-1 row-render component as Q1).
- **Status:** resolved 2026-09-14 — Syed Haris (reporter, in-session): **never selectable, no override**. Consistent with `dispatch/yard-operations-jz.md:16`. REQ-06 therefore hard-rejects; no override flag on the API.

### Q3 — Do tool/rigging rows count toward "assigned"?

- **Question:** Does a tool/rigging row count as "assigned" for the chip (REQ-01), the Phase-1 pre-selection filter (REQ-04), and the API guard (REQ-06) — or does the unassigned check apply only to asset/employee resource slots?
- **Why it cannot be answered from what is written:** `intent.md` §12 item 3 logged this as open. Tools have no allocation concept in the code read for this spec (`subJob.job.tools` is quantity-based inventory, not a `JobResource` slot with a `resourceAllocations` row) — which is *evidence the current system has no way to answer "tool assigned or not,"* not a decision that tools should be excluded from the ticket's definition of "assigned." `assets/tool-and-rigging.md` Story 4/5 describes tools as quantity/checklist items, never framed as "assigned" or "unassigned" the way asset/employee slots are.
- **Blocked:** REQ-01 (chip count/tooltip scope), REQ-04 (pre-selection scope), REQ-06 (API guard scope)
- **Candidates:** `assets/tool-and-rigging.md` (4.2 KB, 2026-05-26) Story 1 ("System warns if requested tool already exists on assigned crane", "System alerts if required lift component is missing" — neither is an assigned/unassigned state for the tool itself) and Story 4/5 (loading checklist, live In-Use/Total/Available counters — inventory-level, not slot-level); `dispatch/yard-operations-jz.md` — silent on tools specifically.
- **Owner:** Syed Haris (reporter)
- **Workaround, if any:** build to the default from `intent.md` §12: **tools always count as assigned** (i.e., excluded from the unassigned check entirely) — reversible in one file per surface (the chip's rollup, `applyPhase1InitialState`'s tool branch, and `buildCatalogItems`'s tool loop).
- **Status:** resolved 2026-09-14 — Syed Haris (reporter, in-session) accepted the recommendation: **tool/rigging rows are excluded from the unassigned check** (chip, Phase-1 pre-selection, REQ-06 guard apply to asset/employee slots only — a tool row has nothing to assign; its failure mode is stock, already covered by the existing "exceeds available stock" warning). **But tools count as "something to load"**: REQ-03's disable rule is *no assigned asset/employee slot **and** no tool row with quantity > 0*, so rigging-only / trucking-only jobs (Dylan, `2026-05-12-loading-figma-demo.md:161-172`) remain markable.

### Q4 — Placement and trigger of "Nothing assigned to load out." (REQ-05)

- **Question:** Where does the Phase-1 modal show "Nothing assigned to load out.", and under exactly which condition? Built (U2, 2026-09-14) to the default relayed by the reporter's orchestrator: **in the modal footer, left of the Loadout button**, shown only when the modal lists at least one asset/employee row, **every** listed asset/employee row is unassigned, and **no tool row** is listed (tools are always loadable per Q3). The pre-existing generic "No assets or tools are available for loadout." body message still covers the no-rows-at-all case, unchanged.
- **Why it cannot be answered from what is written:** REQ-05's Acceptance and §5 *Copy* both mark placement `NOT SPECIFIED`; `intent.md` §3 point 3 gives the string only as a DoD parenthetical. `units.md` U2 said "ships with the existing generic copy unless sourced before build"; the build-time instruction sourced the footer placement, but from the orchestrator, not from a vault or ticket document.
- **Blocked:** nothing — built to the default; reversible in one file (`components/loadout/dylen-phase-handover-modal.tsx`, plus `isPhase1NothingAssigned` in `utils/phase1-selection-rules.ts` if the trigger condition changes).
- **Candidates:** none beyond `intent.md` §3 point 3.
- **Owner:** Syed Haris (reporter)
- **Workaround, if any:** as built; `data-testid="dylen-loadout-nothing-assigned"` marks the region so a change of placement is a one-line E2E update.
- **Status:** open — built to the default above 2026-09-14 (U2); one-line confirmation or correction resolves it.

### Q5 — Camera button on an unassigned Phase-1 row

- **Question:** On a greyed/unselectable (unassigned) row in the Phase-1 modal, is the per-row camera/photo button hidden, shown-but-disabled, or left interactive? Built (U2, 2026-09-14) as **hidden** — nothing exists to photograph for a slot with no allocation.
- **Why it cannot be answered from what is written:** REQ-04 covers the checkbox only. The nearest source is the yard-operations punch list, `dispatch/yard-operations-jz.md:18` — *"Hide camera when not applicable"* — which is not adjudicated and does not name the unassigned case explicitly.
- **Blocked:** nothing — built to the default; reversible in one file (`components/loadout/dylen-phase-handover-modal-phase1-section.tsx`, the `isSelectable ? <DylenLoadoutPhotoButton …/> : null` branch in both row components).
- **Candidates:** `dispatch/yard-operations-jz.md:18` (952 bytes, 2026-07-15).
- **Owner:** Syed Haris (reporter)
- **Workaround, if any:** as built.
- **Status:** open — built to the default above 2026-09-14 (U2).

### Q6 — Fallback copy for the `completeLoadout` error toast (REQ-05 addendum)

- **Question:** When the `completeLoadout` mutation fails and the API supplies no usable message (network error, sanitised technical message), what does the toast say? Built (U2, 2026-09-14) as **"Failed to complete loadout"**, derived from the sibling `savePhotos` fallback "Failed to save photos" that the addendum names as the pattern to copy. The two U1 400 messages (`Unassigned … item: …`, `Nothing to load out for this shift.`) are shown verbatim by `toastMutationError` and are unaffected by this fallback.
- **Why it cannot be answered from what is written:** the 2026-09-14 addendum to REQ-05 / §13 specifies the mechanism (`toastMutationError`, same pattern as `savePhotos`) but not the fallback string; §9 marks all error copy `NOT SPECIFIED`.
- **Blocked:** nothing — one string in `hooks/use-dylen-loadout-mutations.ts`.
- **Candidates:** none.
- **Owner:** Syed Haris (reporter)
- **Workaround, if any:** as built.
- **Status:** open — built to the default above 2026-09-14 (U2).

## 13. What this spec deliberately does not specify

> 2026-09-14, reporter's call on the two ripple findings below: **card chip only** (print block and read-only allocation view unchanged this ticket) and **no server-side Mark Available guard** (REQ-03 stays web-only). Both remain candidates for a follow-up ticket.

- **Whether `Mark Available` needs an API-side guard mirroring REQ-03** (zero-assigned shifts) — `intent.md` names this only as a web button-disable rule; no source asks for a server-side mirror, and REQ-06/07's server guards are scoped to `complete-loadout` only, per `intent.md` §3 point 4's own wording ("so **3** holds even if the UI is bypassed" — REQ-03 is point 2, not point 3). See §0's finding.
- **Whether the print block (`dylen-print-job-block.tsx`) and the read-only allocation view (`dylen-job-allocation-readonly.tsx`) should visually flag unassigned slots** the way REQ-01's chip does — both already consume the same "Unassigned" placeholder data (§11a) but no source asks for a chip or flag there, and print designs are explicitly flagged as a separate open item in `dispatch/yard-operations-jz.md:15` ("print designs required") that this ticket does not resolve.
- ~~Whether the `completeLoadout` mutation needs an `onError` toast~~ — **2026-09-14, reporter: in scope for U2.** After U1 shipped, UAT on `JOB-00009` showed the modal sitting silently on the API's 400; the toast (copy the sibling `savePhotos` mutation's `toastMutationError` pattern in `use-dylen-loadout-mutations.ts`) is the only way the user learns the server refused. Folded into REQ-05's acceptance.
- **Exact copy** for: the chip's tooltip list format, the "needs review" section heading/body text beyond the words "needs review," both new API 400 messages, and the Phase-1 "Nothing assigned to load out." string's exact placement — see each REQ's Acceptance/Notes.
- **A Jira ticket for this work** — `intent.md` §3 records this as its own open item: *"per `domain/jira-sop.md` it does not meet Definition of Ready. The reporter chose to proceed under a synthetic folder; a Jira key should be attached before merge."* Not re-litigated here; carried forward as a pre-merge requirement, not a build requirement.
- **Per-asset planned leave times, offload-completed loadout flagging, the "no equipment required" job flag, whether a no-yard job auto-completes, quotation over-request blocking, hiding the Mark Available button, and any Phase-3/offload change** — all explicitly out of scope per `intent.md` §5, restated here only so this section is a complete account of what the ticket does not cover, not a partial one.

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person — *n/a: no requirement is flagged `[OPEN]`; Q1–Q3 are defaults pending confirmation, not build blockers*
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — *n/a: no `[CONFLICT]` requirement*
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question — *two rows remain OPEN per §13 (print block; `completeLoadout` mutation error UX) — not carried as formal Q4/Q5 because they are ripple findings, not gaps `intent.md` itself raised; a reviewer may choose to promote them to questions before build*
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________
