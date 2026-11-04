# U2 — assigned non-crane slots use plain STANDARD

## Authorization and stack

Requesting user explicitly asked to create a new U2 branch on top of U1 and complete implementation. U1's exact verified 11-file patch was checkpointed as client commit cf09fae27, with matching AI DLC checkpoint 3c24663. Git hooks ran normally and retained U1's 82 additions / 43 removals. U2 source branch is fix/SLOT-DRIVEN-TICKET-ACCESS-u2-standard-slots, directly based on that U1 commit. U2 overlay uses the identical branch, directly based on the U1 overlay checkpoint. No branch was pushed or deployed; original primary checkout/labor feature remains untouched.

## Baseline

U2 starts at the exact source revision verified at U1 completion: API221 + mobile196 + shared192 = 609 existing tests passed; API/mobile/shared lint zero errors with existing warnings (707/409/1), API build, mobile/web type checks and dependency builds passed. The checkpoint hook did not alter the patch; git diff --cached matched the delivered U1 patch before commit and committed stats match. Dependencies installed from the existing frozen lockfile/local cache; no dependency change.

## Implementation decisions

- Extend existing shared hasOwnInspections with an optional boolean indicating that a resolved assignment slot exists. It returns false for known assigned slots. Two-argument legacy/no-slot callers keep their prior behavior; no enum, DTO or database column is added.
- Pass assignment presence in the API viewer resolver and submit guard. Mobile receives stepFlow STANDARD / ownInspections false for known other slots; the submit guard derives the same requirement set rather than requiring hidden checklists.
- Reuse one private office-progress helper for both summary and detail, so the office timeline and mobile steps agree.
- Preserve initial/final customer signatures, holdover day variations, Oiler/solo-Operator FULL flow, secondary read-only authorization, existing records, payroll inputs and legacy missing-slot fallback.
- Existing mobile composition, prefetch, route, store hydration and background verification already consume the resolved flow/ownInspections flag (U1 fixed profile-only paths). No duplicate client policy or new UI component is needed. Verify those consumers with existing suites and manual probes.
- No new tests requested; no cases/files added. Existing tests and runtime function probes verify the change. No live database/account or native device session is accessed.

## Status

Implementation complete locally; independent U2 analyst verdict: ship for the bounded source change. No push, merge or deployment performed. See analyst-u2.md for independent probes and remaining live QA limits.

## Manual runtime observations

Actual API viewer resolver and submit guard were invoked with Oiler and Operator main profiles occupying Rigger, 3rd Man and Apprentice slots, each with runsInspections=true. All six combinations returned STANDARD / ownInspections=false, exactly eight ordinary steps including sig1/sig2, and no missing submit steps after standard evidence was supplied (even with an old unsubmitted checklist assignment present). The guard also resolves slotRole before employeeRole when an explicit stepFlow is absent. No checklist/labor/full-step requirement leaked from the main Oiler role. Holdover STANDARD counts remained middle Yard 7, middle Home 5, last Yard 8, last Home 6, with both customer signatures and no extras. Legacy no-slot inspecting role still returns ownInspections=true and 12 steps. These are function-level probes, not a native mobile or live tenant run; raw output in work/u2-manual-probes.log.

Independent analyst additionally verified 15 normal/holdover matrices, FULL and paired-Operator regressions, and mobile current-policy consumers; no actionable source findings. No new tests or test cases were written.

## Final verification

- Existing suites: API 221 / 8 suites, mobile 283 / 13 suites, shared 192 / 57 suites: **696 tests passed**. No new tests or cases added.
- API/mobile/shared lint: zero errors, existing warnings retained. API/shared builds and mobile/web type checks passed. Prettier and git diff --check passed.
- Expanded mobile selection including use-ticket-progress.test.ts exhausted the 3 GB Node heap. The unchanged U1 hook suite separately failed to finish within a 90-second bounded run (timeout exit 124). Hook and test are byte-identical on U1/U2. This establishes a baseline noncompletion, not an identical baseline OOM or a proven root cause. The extra suite remains an explicit verification limitation; no unrelated hook/test fix was included.
- Raw logs: work/u2-final-api-tests.log, u2-final-mobile-tests-core.log, u2-final-shared-tests.log, u2-final-gates.log, u2-final-api-gates.log, u2-final-web-typecheck.log, u2-final-mobile-tests.log and u1-progress-suite-baseline.log.
- Native mobile/live account acceptance, deployment parity, old installed app rollout and the originally reported read-only account remain unverified. Historical repair and changed vacancy/missing-slot rules remain excluded. Before release, perform the ticket's live acceptance matrix and coordinate API/mobile delivery.

## Local reflection

The policy could reuse the existing FULL/STANDARD and ownInspections contract. Explicit assignment presence at the shared helper prevents profile settings from reintroducing hidden requirements in API submit or office progress. All reached callers were traced; existing mobile consumers already honor the resolved server policy. U2 needs only five source files, 34 additions / 31 removals. No dependency, response field, database migration, payroll formula or stored role setting changed.

Source checkpoint: 8a3d24164 on U2, parent cf09fae27 on U1. Normal pre-commit lint/format hooks completed; committed diff remains five files, 34 additions / 31 removals.
