# U1 independent analyst review — 2026-10-22

Verdict: **ship** for U1 source implementation. Final recorded gates pass. This is a source review and bounded function verification, not a live mobile acceptance demonstration. U2 is deliberately separate.

## Findings

- **VERIFIED:** `git diff --check` passes. `git diff --name-only` shows eleven source files, with no schema, migration, dependency, response DTO or test-file edits.
- **VERIFIED:** An independent API function probe, run with `TS_NODE_PROJECT=tsconfig.spec.json TS_NODE_TRANSPILE_ONLY=true node -r ts-node/register -r tsconfig-paths/register`, returned FULL for the ticket's primary Oiler allocation even when the same employee's unrelated allocation appeared first or allocation order was reversed. A folded Operator returned STANDARD; a solo Operator returned FULL.
- **VERIFIED:** The same probe through rebuilt `@tcg/shared` returned FULL for canonical OILER with a null inspection rank, STANDARD for paired OPERATOR with rank 1, FULL for solo OPERATOR with null rank, and STANDARD for NONE with rank 1 or a nondispatchable OILER. Legacy role objects without `boomPay` and the no-slot profile fallback retained their previous rank-based result.
- **VERIFIED:** A mobile function probe using `TS_NODE_PROJECT=tsconfig.json TS_NODE_TRANSPILE_ONLY=true TS_NODE_COMPILER_OPTIONS='{"module":"Node16","moduleResolution":"Node16","baseUrl":".","rootDir":".","ignoreDeprecations":"6.0"}' node -r ../api/node_modules/ts-node/register -r ../api/node_modules/tsconfig-paths/register` called `checklistSignatureFor` with secondary main-Oiler first, primary main-Operator second, and a legacy Oiler crew label. New and placeholder captures used the primary's name; an explicit captured name was preserved. An earlier probe failed on harness compiler settings before loading product code; the corrected probe passed.
- **INFERRED:** Shared canonical slot classification now matches crew ownership. `packages/shared/src/constants/ticket-flow-steps.ts:259` resolves from the dispatchable slot's OILER/OPERATOR classification; `apps/api/src/usecase/job-tickets/ticket-step-flow.ts:57` anchors the viewer to this ticket's allocation/set/shift. The added job-ticket and job-progress internal selectors feed the canonical field to mapper, submit, milestone and office-progress consumers. The initial D1 omission identified during review is resolved.
- **INFERRED:** No authorization widening is introduced. Existing tenant-qualified ticket queries and `getTicketForEmployeeAction` roster/primary checks remain authoritative (`apps/api/src/service/job-tickets/job-tickets.repository.ts:507`, `apps/api/src/usecase/job-tickets/job-tickets.service.ts:1743`). The change does not infer write rights from FULL or the employee's profile.
- **INFERRED:** Ordinary stale-draft policy is covered: `ticket-flow.store.ts:841–879` already hydrates current server flow on reopen, while `background-sync.ts:333–337` now uses matching server policy before persisted draft policy. Session-owner and canonical ticket lookup guards remain unchanged. This does not transfer captured work between historical owners.
- **INFERRED:** Checklist body, engine and submission siblings consistently prefer the primary identity while submission preserves explicit captured signer evidence. Only legacy payloads without an available primary retain role-label fallbacks.

No remaining actionable source defect was found after the D1 and lint-complexity repairs. This does not prove the originally reported read-only card's runtime cause: no affected live account/ticket or deployment/cache trace was supplied, and the diff does not change `isPrimary` creation or repair historical roster data.

## Gate evidence boundary

The analyst did not rerun heavy gates. **VERIFIED:** log inspection with `head`, `tail` and `rg` records successful completion of the executor's final checks:

- `pnpm nx run-many -t lint typecheck build -p @tcg/api @tcg/mobile @tcg/shared --parallel=2 --outputStyle=static`: seven available targets pass; one dependency task was a cache hit. API build and mobile typecheck pass. API/mobile/shared lint each has zero errors; warnings remain 707/409/1.
- `pnpm nx run @tcg/web:typecheck --outputStyle=static`: pass, dependency build reused.
- `pnpm nx run @tcg/api:test --runInBand --watch=false --runTestsByPath ... --outputStyle=static`: the eight paths listed in `work/u1-final-api-tests.log` pass, 221 tests.
- `pnpm nx run @tcg/mobile:test --runInBand --watch=false ... --outputStyle=static`: the selected patterns listed in `work/u1-final-mobile-tests.log` pass, ten suites / 196 tests.
- `pnpm nx run @tcg/shared:test --outputStyle=static`: 192 tests pass.

Test targets executed; dependency-build cache hits are stated in their logs. The first combined attempt had three new complexity errors; the final retry passes after removing redundant signer predicates and extracting the private FULL-flow calculation, with no lint suppression. Consult `implementation.md` for the executor's complete commands and logs. None of these checks is a device/offline/reassignment acceptance demonstration.

## Scope and maintainability

- Complete: source implementation of U1 yes; real mobile/offline/payroll acceptance demonstration unverified.
- Contained: yes. U2's other-slot own-inspection removal is not included. Historical repair, vacancy semantics and missing-slot fallback remain Q1–Q3 boundaries.
- Unsourced decisions: none found. Canonical classification, anchored lookup, signer priority and server-policy precedence trace to spec §11b / REQ-01–03/05 and the implementation record.
- **VERIFIED:** No 1,000-line threshold crossing: `git show HEAD:<path> | wc -l` and `wc -l` show ticket-step-screen already exceeded 1,000 lines before this unit (1,550); ChecklistEngine already exceeded it (1,827). The small changes do not create that condition.
- **INFERRED:** Applying the thermo-nuclear and ponytail rubrics found no remaining structural regression, avoidable data mutation or load-sensitive addition in the unit. Existing large screen decomposition belongs to a separate task.
- No new test cases were added, per AGENTS.md. No new boundary question was written to spec §12.

## Release risks and follow-ups

- **INFERRED:** The least certain area is the real reported ticket's roster/deployment/cache state. Reproduce the fresh swapped-profile crew in a permitted tenant and inspect the affected historical ticket before claiming that specific read-only symptom is resolved.
- **INFERRED:** API and mobile rollout must be coordinated: older installed apps retain their old profile-based cache/signing behavior. This source change does not update installed clients by itself.
- **INFERRED:** The most likely future drift is a new API reader failing to select the canonical slot classification, falling back to the intentionally retained legacy rank path. Keep internal selectors and sibling readers aligned.

No application code was changed by this analyst.
