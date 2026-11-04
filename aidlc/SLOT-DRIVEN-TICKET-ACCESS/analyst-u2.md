# U2 independent analyst review — 2026-10-22

Unit reviewed: U2 — other assigned slots complete plain STANDARD (SLOT-DRIVEN-TICKET-ACCESS).

Verdict: **ship** for the bounded source implementation, with the progress-hook verification limitation below. No actionable functional defect found. This is not a live mobile/offline acceptance demonstration.

## Evidence and findings

- **VERIFIED:** `git log -1 --format='%h %s'` and `git merge-base HEAD fix/SLOT-DRIVEN-TICKET-ACCESS-u1-cross-role-crew` identify U1 commit cf09fae277e7702abbb8d549dac6f46e72ac737d as U2's base. `git diff --check` passes. `git diff --stat` contains five source files, no schema/migration/dependency/test change.
- **VERIFIED:** Independent runtime probe from apps/api using `TS_NODE_PROJECT=tsconfig.spec.json TS_NODE_TRANSPILE_ONLY=true node -r ts-node/register -r tsconfig-paths/register` called the actual viewer resolver, rebuilt shared functions and submit guard. For main Oiler, Operator and own-inspecting other-role profiles in an assigned NONE slot, all three resolutions returned `{stepFlow:'STANDARD', ownInspections:false}`. Fifteen normal/holdover combinations (normal; middle/last day × Yard/Home for each profile) retained sig1/sig2 and omitted Pre-Trip, JSA, Post-Trip, Compliance, Start Work and Labor. Three complete STANDARD submissions returned no missing steps despite pending checklist assignments. The same probe preserved Oiler FULL, solo Operator FULL, paired Operator STANDARD and the legacy two-argument own-inspection fallback.
- **VERIFIED:** `rg -n 'hasOwnInspections|ownInspections|hasAssignedSlot' apps packages/shared/src` enumerated assigned-policy producers in viewer flow, submit guard and office summary/detail plus mobile consumers. The assigned producers supply slot presence. Two-argument calls remain on legacy/mobile fallback paths. This establishes call-site coverage, not device behavior.
- **INFERRED:** Mobile composition/catalog, totals, overview, prefetch and verification agree with the server policy. `compose-ticket-detail.ts`, `ticket-flow.store.ts:878`, `ticket-step-screen.tsx:453`, `background-sync.ts:333` and `sync/verify.ts:194` prefer resolved server flow and its ownInspections flag. U1 hydration resets an old true flag to server false; ordinary offline drafts retain the last resolved policy until normal refresh. No duplicate mobile policy implementation is necessary.
- **INFERRED:** Submission will not demand hidden inspections for valid assigned STANDARD tickets. The repository's findSubmitEvidence selects the real allocation slot role; job-tickets.service resolves its flow before findMissingSubmitSteps; the guard now suppresses extras on that known slot. Pending checklist evidence is checked only for required checklist steps.
- **INFERRED:** Office summary and detail use the same private helper and shared holdover arrays, so their required visible steps match mobile. The main-role-derived oilerFlow remains a legacy fallback; derive-ticket-progress-view prefers stepFlow on resolved tickets.
- **INFERRED:** No authorization, tenant-scoping, payroll calculation or data-rewrite behavior changes in U2. FULL never grants write permission; existing primary/roster/status/window guards remain authoritative. One shared Oiler/Operator ticket and distinct employee labor sources remain U1 behavior.

## Gates and limits

No heavy gates were rerun by the analyst. **VERIFIED:** log inspection using head/tail/rg records completed executor gates:

- `pnpm nx run-many -t lint typecheck build -p @tcg/api @tcg/mobile @tcg/shared --parallel=2 --outputStyle=static`: seven targets successful; two cache hits (`../u2-final-gates.log`).
- `pnpm nx run @tcg/web:typecheck --outputStyle=static`: successful; dependency build cached (`../u2-final-web-typecheck.log`).
- `pnpm nx run-many -t lint build -p @tcg/api @tcg/shared --parallel=2 --outputStyle=static`: latest guard-change gates successful; two of five tasks cached (`../u2-final-api-gates.log`).
- `pnpm nx run @tcg/api:test --runInBand --watch=false --runTestsByPath ... --outputStyle=static`: eight suites / 221 tests pass; no cache hits (`../u2-final-api-tests.log`, command header contains all paths).
- `pnpm nx run @tcg/shared:test --outputStyle=static`: 192 tests pass, zero fail; dependency build cached (`../u2-final-shared-tests.log`).
- `pnpm nx run @tcg/mobile:test --runInBand --watch=false compose-ticket-detail.test.ts ticket-crew.test.ts ticket-card.test.tsx edit-wiring.test.tsx LaborBody.test.tsx ChecklistBody.test.tsx pretrip-submission.test.ts sync/verify.test.ts background-sync.test.ts ticket-total.test.ts ticket-flow.store.test.ts holdover-start-mode.test.ts --outputStyle=stream`: 13 suites / 283 tests pass; dependency build cached (`../u2-final-mobile-tests-core.log`).

**VERIFIED:** The expanded mobile command additionally selecting use-ticket-progress.test.ts failed after 4m40s with `FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory` (`rg -n 'FATAL|heap' ../u2-final-mobile-tests.log`). The isolated unchanged-U1 baseline command `pnpm nx run @tcg/mobile:test --runInBand --watch=false --verbose use-ticket-progress.test.ts --outputStyle=stream` produced no suite result within its bounded run; its log ends with ELIFECYCLE failure (`../u1-progress-suite-baseline.log`). The executor confirmed the enclosing 90-second timeout completed with exit code 124 (exec session 25638); the analyst did not launch this baseline run. `sha256sum` confirms the hook and test byte-identical in U1/U2. This establishes an unresolved progress-hook verification gap reproducible as baseline noncompletion; it does not prove baseline would eventually emit the exact same OOM or prove the root cause.

**INFERRED:** Hook-test noncompletion likely predates U2. Inline `[ticket]` inputs in tests change array identity per render, while the existing shift-clock effect depends on tickets; a publish/render cycle is a plausible cause. This remains a hypothesis, not a diagnosed defect or U2 source finding. No hook/test fix is included.

**VERIFIED:** A second independent inline probe using the same ts-node command exercised final submit-guard fallback without stepFlow: known assigned NONE slot + main Oiler + complete STANDARD evidence returned no missing steps. The final internal optional boomPay field and slot-first fallback were read against REQ-01/04; no response DTO change.

Existing tests were read, including API ticket-step-flow/submit-step-guard/progress and shared normal/holdover step suites. No new test cases or files were added, following AGENTS.md. The bounded inline probe creates no persisted data.

## Scope and maintainability

- Complete: bounded U2 source slice yes; live demonstration unverified. Contained: yes. Demo works: not established on a device or permitted live tenant.
- Unsourced decisions: none found. Optional slot-presence suppression and compatibility fallback are recorded in implementation-u2.md and trace to REQ-01/04/05, spec §11b D2 and Q3. Q1 historical repair and Q2 vacancy semantics remain excluded.
- **VERIFIED:** `git show HEAD:<path> | wc -l` and `wc -l` for all five changed files show no 1,000-line crossing: mapper 404→400, progress service 612→613, submit guard 149→152, viewer resolver 89→92, shared flow 559→559 after final clarification.
- **INFERRED:** Applying review-pr §4d's thermo-nuclear and ponytail rubrics found no structural, load, security or avoidable mutation regression. The change is a constant-time check in an existing shared policy helper; office summary/detail reuse one private adapter.
- The contradictory shared resolver JSDoc claiming assigned 3rd Man/Driver extras was reported during review and corrected by the executor. No remaining documentation finding.
- Open questions written to spec §12: none; existing Q1–Q3 boundaries preserved. No source/spec/state edits made by this analyst.

## Release follow-ups and uncertainty

- **INFERRED:** Least confident about actual installed app/cache and the originally reported ticket roster. No live affected account, ticket allocation history or native mobile session was available; this review cannot establish the historical read-only symptom's cause or repair old primary membership.
- **INFERRED:** Coordinate API and mobile rollout, then verify a fresh swapped-role crew plus assigned Rigger/3rd Man/Apprentice online/offline in a permitted tenant. An entirely offline old draft cannot learn a newly deployed policy until its normal refresh.
- **INFERRED:** The most likely future drift is a new assigned-ticket reader calling the intentionally compatible two-argument hasOwnInspections fallback, or a selector omitting slot context. Keep assigned producers explicit about slot presence.
