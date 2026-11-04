# U1 implementation record — SLOT-DRIVEN-TICKET-ACCESS

Authorized by requesting user on 2026-10-22. Branch `fix/SLOT-DRIVEN-TICKET-ACCESS-u1-cross-role-crew`; origin/main base `fc1ef4b17`. No commit/push authorized or performed. U2 remains separate.

## Baseline before source edits

- `NX_DAEMON=false NODE_OPTIONS=--max-old-space-size=4096 pnpm nx run-many -t lint typecheck build -p @tcg/api @tcg/mobile @tcg/shared --parallel=1 --outputStyle=static`: PASS. Seven available targets including dependency build; API build, mobile typecheck, API/mobile/shared lint. No mobile build target exists. API lint 707 pre-existing warnings, mobile 409, shared 1; 0 errors.
- `pnpm nx run @tcg/api:test --runInBand --watch=false --runTestsByPath` selecting crew-roster, ticket-step-flow, job-tickets.service, submit-step-guard, field-ticket.mapper, job-progress.service: PASS, 6 suites / 172 tests.
- `pnpm nx run @tcg/mobile:test --runInBand --watch=false` selecting compose-ticket-detail, ticket-crew, ticket-card, edit-wiring, LaborBody, ChecklistBody, pretrip-submission, sync/verify: PASS, 9 suites / 167 tests.
- Raw logs stored outside the client worktree in `work/u1-baseline-{gates,mobile-tests,api-tests}.log`. First mobile command using route parentheses failed in Nx shell forwarding before Jest; corrected filename-filter run passed. This is a command issue, not a product baseline failure.
- Dependency installation used frozen lockfile; offline cache lacked one package, online install completed locked dependencies only. No dependency or lockfile change. No local environment files/database credentials copied; Prisma generated from its built-in generate-only placeholder without connecting to a database.

## Reproduction evidence

Manual function probe via `TS_NODE_PROJECT=tsconfig.spec.json TS_NODE_TRANSPILE_ONLY=true node -r ts-node/register -r tsconfig-paths/register`: employee-a has a Rigger assignment in set-b first in the allocation list and an Oiler assignment anchoring the target ticket in set-a/shift 2. Viewer has Operator profile. Before change resolver returned `{stepFlow: STANDARD, ownInspections: false}`. This confirms wrong allocation lookup in isolation; it does not establish why the user's actual card is read-only.

## AI decisions / scope

- Keep valid slot-first crew planner, roster primary authorization and API DTOs unchanged. They already implement the ordinary Oiler/Operator pairing rule. No bulk roster repair, live database operation or new schema.
- Anchor viewer slot lookup to ticket allocation before employee-only fallback. Same-set/shift secondary lookup preserves crew boundaries and avoids unrelated assignments influencing the flow.
- Add one mobile `primaryEmployeeNameForTicket` helper in existing ticket-crew module and apply to all three checklist signer siblings. Preserve already captured explicit signature names as evidence; fallback to primary for new/placeholder captures. Legacy role-label fallbacks stay only after no primary is available.
- Home prefetch and router's FULL-flow flag use resolved ticket flow. Background verification uses matching server flow and its ownInspections flag before the saved draft, with profile fallback only when neither carries a resolved flow.
- Main's LaborStepBody ignores isOiler, unlike primary checkout's unmerged labor feature. Do not import that feature. Passing slot-resolved FULL makes the call site compatible when that branch is integrated; Operator auto-population itself stays outside this unit.
- Preserve assigned other-slot ownInspections behavior until U2. Preserve historic started-ticket/vacant-slot/missing-slot boundary decisions until explicitly addressed.
- New tests not requested; no new test cases/files added. Existing tests plus manual function probes are the verification method.

## Execution status

Initial API172/mobile167 regression suites passed after the first diff. First post-change gate found three new mobile complexity errors; corrected without disabling lint by keeping the FULL fallback in a private helper and removing redundant primary checks after the shared primary lookup. Independent analyst identified D1 completeness gap (crew seat vs inspection-order disagreement); extension below is in progress. Final gates must be rerun after that extension.

## Analyst-driven D1 completion

The independent analyst confirmed that crew ownership and step flow could disagree under existing role settings: boomPay OILER with null/higher inspection order can be primary STANDARD, and a paired Operator can appear FULL. Per approved spec §11b D1, shared resolveTicketStepFlow now prefers the dispatchable slot's existing OILER/OPERATOR crew classification whenever provided; explicit NONE stays STANDARD. Inspection-order behavior remains only for legacy slot-role objects without that field, and the no-slot employee fallback is unchanged. Both slot-role repository selects (job-tickets and job-progress) now include existing boomPay internally. Public API response shape, schema, rate values and payroll calculation are unchanged. No role setting or existing record is rewritten. Assigned other-slot own-inspections extras remain U2.

Before shared source edits, existing shared tests passed: 57 suites / 192 tests. All shared consumers (API, mobile and office progress/web typecheck) are included in final checks. Directly affected background-sync suite is also added to existing-suite verification; no new test cases.

## Final validation — 2026-10-22

All final commands completed with exit 0 after D1 completion and lint repair:

| Check | Result |
| --- | --- |
| API/mobile/shared lint; API build; mobile typecheck; shared/payroll dependency builds through pnpm nx run-many | PASS; 7 available targets; no mobile native build target included |
| Web next typegen + tsc through pnpm nx run @tcg/web:typecheck | PASS |
| Expanded API selection including ticket repository and crew labor | 8 suites, 221 tests PASS |
| Expanded mobile selection including background-sync | 10 suites, 196 tests PASS |
| Existing shared package tests | 57 suites, 192 tests PASS |
| Total existing tests in final selections | 609 PASS; no cases added/modified |
| git diff --check | PASS |
| Source diff | 11 files; 82 added / 43 removed lines |

Existing warning counts are unchanged from baseline: API 707, mobile 409, shared 1; zero lint errors. Final logs are `work/u1-final-gates.log`, `u1-final-web-typecheck.log`, `u1-final-api-tests.log`, `u1-final-mobile-tests.log`, `u1-final-shared-tests.log` and `u1-final-shared-build.log` outside the client worktree. Full workspace web build/native mobile build and a live account/device smoke were not run.

Manual function observations after final shared build: Operator-profile primary in Oiler anchor FULL even with null inspection rank and another assignment listed first; Oiler-profile secondary Operator STANDARD even with rank 1; reordered allocations unchanged; solo Operator with null rank FULL; other seat with rank 1 STANDARD; nondispatchable Oiler STANDARD; no-slot legacy rank-1 fallback FULL. Primary signer lookup selects the actual primary even when secondary main-Oiler is first in the roster; explicit already captured signer evidence is preserved. Analyst independently repeated the slot and signer probes.

Independent AI DLC analyst verdict: **ship**, no remaining actionable source findings; see analyst.md. This means U1 code is ready for developer review, not that it was deployed or that the reported live card was reproduced. Existing isPrimary roster authorization, one-ticket crew structure and separate employee labor/payroll sources remain unchanged. No data repair, schema migration, dependency, permission escalation, provider-constructor or public response-shape change.

## Handoff

U1 is built in the isolated worktree and left uncommitted as required by the repository skill. Primary checkout/source branch and its unmerged labor feature remain untouched. Review the patch; run the swapped-profile mobile smoke and inspect the affected real ticket's roster/build versions before release. U2 removes checklist extras from other assigned employee slots, per the approved plan, in its own unit. Q1 historical transfer, Q2 changed vacant-slot semantics and Q3 changed missing-slot policy remain outside U1. Reflection/merge/close phases have not occurred.

Patch integration check: `git apply --check` passed against the untouched primary checkout on `feat/mobile-labor-craft-modifier-oiler-only-and-autopopulate`. No patch was applied there. Client worktree status contains only the 11 intended source changes; no lockfile/test changes.
