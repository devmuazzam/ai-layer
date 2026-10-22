# Proposed units — SLOT-DRIVEN-TICKET-ACCESS

The requesting user authorized construction on 2026-10-22: "start the implementation using AI DLC". U1 is built locally and independently reviewed; U2 remains a separate unit. One unit per PR; no commit/push was requested.

## Gate baseline

Baseline measured 2026-10-22 before source edits on fetched origin/main fc1ef4b17: API build PASS, mobile typecheck PASS, API/mobile/shared lint PASS (0 errors; existing warnings API 707, mobile 409, shared 1); shared/payroll dependency builds PASS. Existing API selection 6 suites / 172 tests PASS; mobile selection 9 suites / 167 tests PASS. Commands/logs: implementation.md. Deployed parity not established. Before the first unit, measure lint, typecheck, build and existing tests on the intended construction base using the repository's pnpm nx commands. Record real failures and compare subsequent gates to that baseline. Do not copy old green counts from AGENTS.md.

New tests: **not requested**. Run existing suites and named manual checks. Do not add cases merely to mirror a helper.

## Unit ledger

| Unit | Outcome | Requirements | Surfaces | Depends on | Estimate | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Operator assigned Oiler can fully complete the shared ticket; paired Operator stays read-only, online/offline | 1–3,5,6 | api, mobile, shared/progress as needed for resolution | None; reproduction precedes edits | 12–20 files; 200–450 source lines, tentative until reproduction | built — fix/SLOT-DRIVEN-TICKET-ACCESS-u1-cross-role-crew |
| U2 | Any employee assigned another slot sees/finishes STANDARD without checklist extras | 1,4,5,6 regression | shared, api, mobile, office-progress consumers | U1 | 8–14 files; 120–300 source lines, tentative | not started |

Coverage: 6 core requirements, 6 covered. No executable unit includes Q1 historical repair, Q2 changed vacancy semantics or Q3 changed legacy fallback. A follow-up repair unit may be defined only after Q1 is answered and a concrete safe repair is reviewed.

## U1 — Complete tickets according to the Oiler/Operator assignment

- **Outcome:** Employee A, main Operator assigned Oiler, can perform all FULL ticket actions under the existing crew labor workflow for A and paired B; B, assigned Operator, sees one shared read-only ticket. A solo Operator can fill FULL. The same rules hold after ordinary offline preparation/reconnect.
- **Kind:** Vertical.
- **Requirements covered:** REQ-01, REQ-02, REQ-03, REQ-05, REQ-06; REQ-04 belongs to U2.
- **Depends on:** None for valid new/populated assignments. Q1 only blocks historical transfer.
- **Branch / PR base:** Proposed `fix/SLOT-DRIVEN-TICKET-ACCESS-u1-cross-role-crew` from verified origin/main at execution time. No branch/PR created during planning. Reconcile any relevant local branch-only behavior before constructing.
- **Size estimate:** 12–20 files, 200–450 source lines. Refine after reproduction; estimate is not a gate.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | None proposed | Existing role, allocation, ticket and roster suffice |
| API | Trace reported ticket; fix demonstrated creation/reassignment/roster issue if any; anchor viewer slot lookup to the ticket's crew; align valid Oiler/Operator resolution across readers | `usecase/job-tickets/{job-tickets.service,crew-roster,ticket-step-flow}.ts`, `service/job-tickets/job-tickets.repository.ts`, field mapper; current code already prefers slot, so do not invent a role-based root cause |
| API security/labor | Keep primary membership authoritative; allow the Oiler-slot primary input and existing paired-Operator auto-population; allow solo Operator primary input; align submit/progress context if helper changes | `getTicketForEmployeeAction`; existing ticket-labor target resolver; no wage/rate change and no blanket unlocking of secondary Operator cards |
| Web/progress | Verify current progress for swapped/solo crew and use corrected shared context where reached | No new screen/component |
| Mobile | Replace profile-derived LaborBody eligibility, Home warmup, checklist inspector heuristics and legacy-draft verification fallback; match resolved policy to current assignment | `field.tsx`, `ticket-step-screen.tsx`, `LaborBody.tsx`, checklist siblings, background-sync and existing store hydration |
| Shared | Reuse current FULL/STANDARD vocabulary and normalized slot policy | Avoid new response fields unless proven necessary; trace all consumers if changed |
| Tests | not requested | Run existing suites and manual checks below; do not add cases without request |

### Required diagnosis before editing

1. Record affected ticket/account and deployed API/mobile builds; compare with the reviewed checkout.
2. Inspect server allocation and its jobResource.role, tenant/sub-job/set/shift, roster primary and current field-ticket response. Do not include credentials or unrelated employee data in artifacts.
3. Compare server isPrimary/stepFlow against mobile cache/draft. A server secondary causes read-only directly. A correct primary with profile-gated labor is a different defect.
4. Read assignment/reassignment history. Establish whether wrong data predates the current slot-first code, follows settings disagreement, a failed reassign path or stale deployed/cache state.
5. If repair would rewrite existing work or payroll sources, stop that repair portion at Q1/G2; finish the normal valid-assignment code path.

### Reviewable as

- **Demo:** Create a fresh populated crew with A main Operator in Oiler slot, B main Oiler or Operator in Operator slot. Send once. Log into each mobile account. A opens FULL, fills inspections/signatures and the Oiler-slot labor input, confirms existing paired-Operator auto-population, and submits; B sees status card only and a direct write is forbidden. Repeat with no Oiler and Operator primary; its own labor input must be usable without an Oiler card to copy from. Observe office progress and distinct employee labor records sharing one ticket.
- **Acceptance:** REQ-01/02/03/05/06 acceptance lines.
- **Reviewer can verify without:** U2 or any historical data repair. Needs a permitted test tenant, eligible employees, jobs/sets and mobile build, not production credentials.

### Existing suites to run

API: `usecase/job-tickets/crew-roster.spec.ts`, `ticket-step-flow.spec.ts`, `job-tickets.service.spec.ts`, `submit-step-guard.spec.ts`, `usecase/field-tickets/field-ticket.mapper.spec.ts`, relevant existing labor and progress suites. Mobile: `data/compose-ticket-detail.test.ts`, `data/ticket-crew.test.ts`, `components/field/ticket-card.test.tsx`, `app/(field)/ticket/edit-wiring.test.tsx`, `features/field-ticket/steps/labor/LaborBody.test.tsx`, `features/field-ticket/sync/verify.test.ts`, existing store/progress suites. These are source paths relative to each application; exact execution commands should use supported pnpm nx flags verified at execution time.

### Manual acceptance matrix

| Case | Expected |
| --- | --- |
| Main Operator -> Oiler; main Oiler -> Operator, same crew | A primary FULL; B secondary read-only; one ticket |
| Main Oiler -> Oiler; main Operator -> Operator | Existing behavior retained |
| Main Oiler -> Operator with no Oiler | Editable FULL by occupied Operator slot |
| Oiler present only in another set or shift | Solo Operator here remains FULL |
| Same employee occupies different sets/shifts | Each ticket resolves its own allocation, independent of query ordering |
| Full primary opens after online warmup, then offline | Checklist/labor data available under existing cache guarantees; captures queue and sync normally |
| Old draft lacks flow but matching server ticket resolves FULL | Verification uses current resolved policy, not main profile |
| Secondary opens step deep link or sends write directly | UI prevents action; server refuses mutation |
| Reassignment through existing supported lifecycle | New primary/context appears; obsolete ticket cannot gain rights by stale draft |
| Crew labor/payroll input | Same ticket; separate employee fields and source rows; no rate/formula differences introduced |

### Risk

- **Weakest source:** Core behavior explicit from USER; slot settings' earlier custom configuration semantics remain developer-reviewed implementation detail.
- **Migration reversible:** N/A, none proposed.
- **Behind a flag:** No new flag proposed; existing write/submit guards remain.
- **Touches existing data:** Normal lifecycle records only; no bulk repair or transfer of started work.
- **Blast radius:** Crew ownership, signer attribution, labor and offline captures. Any misassigned primary can affect both employees; server checks remain mandatory.

### Ripple — existing consumers

| Consumer | Reached via | Regression check | Source |
| --- | --- | --- | --- |
| Ensure/send/reassign | Planner/roster | Existing crew/job-ticket suites + fresh/reassign manual matrix | REQ-01/02/03/06 |
| API reads and authorization | Viewer/primary | Mapper/authorization suites + direct secondary write | REQ-01/02/03 |
| Labor crew save | Primary eligibility | Labor suite + swapped primary edits Oiler-slot input; paired Operator keeps auto-population; solo Operator can fill its own input | REQ-02/06 |
| Checklist signer siblings | Primary identity | Capture checklist with swapped profiles; confirm saved signer is acting primary | REQ-02/05 |
| Home warmup/store/sync | Assignment policy | Offline cold-open/queue/reconnect; existing verify/store suites | REQ-05 |
| Office progress/payroll inputs | Shared ticket and employees | One progress ticket and two distinct employee records | REQ-06 |

### Deliberately not in this unit

- Non-Oiler other-slot inspection removal — U2.
- Historical transfer or merging — Q1; no guessed repair.
- Changed empty-slot or missing-slot semantics — Q2/Q3.

## U2 — Other assigned slots complete plain STANDARD

- **Outcome:** An Oiler/Operator-profile employee assigned Rigger, 3rd Man, Apprentice or another employee slot can complete that slot's STANDARD ticket without hidden or visible inspection/full-flow requirements.
- **Kind:** Vertical.
- **Requirements covered:** REQ-01, REQ-04, REQ-05 and REQ-06 regression.
- **Depends on:** U1's common assignment policy and current-context handling.
- **Branch / PR base:** Proposed `fix/SLOT-DRIVEN-TICKET-ACCESS-u2-standard-slots`; stack on U1 while open, then use merged base. No branch created.
- **Size estimate:** 8–14 files, 120–300 source lines; refine after shared consumer trace.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | None | Do not erase role runsInspections or boom-pay data |
| Shared | Known other assigned slots resolve STANDARD without ownInspections extras | Keep no-slot and standalone functions distinguished; no new enum |
| API | Mapper, submit guard, milestone/labor readers use same assigned-slot policy | No hidden checklist requirement; no Start Work/Labor requirement on plain STANDARD |
| Web/progress | Reflect exact same STANDARD steps and applicable holdover variant | Shared helper changes must land with reached consumers |
| Mobile | Composition/catalog, prefetch, overview, required-step display and sync verification agree on plain STANDARD | Preserve sig1/sig2; deny stale links as existing guards require |
| Tests | not requested | Run existing affected suites; review assertions representing prior 12-step policy; obtain authorization for any new cases |

### Reviewable as

- **Demo:** Repeat a normal job with main Oiler and main Operator each assigned Rigger, 3rd Man and Apprentice slots in turn. Main roles do not alter steps. Each gets its own editable STANDARD ticket, with initial/final signatures and no checklists/JSA/compliance/labor extras. Complete it online and after ordinary offline capture. Check office progress and API submit accept the same required steps.
- **Acceptance:** REQ-04; REQ-01/05 and shared-ticket separation regression under REQ-06.
- **Reviewer can verify without:** Historical repairs, new schema or a new payroll feature. U1 is required.

### Existing suites and manual checks

Run existing shared flow suites (locate via shared package scripts), API slot-flow/mapper/submit/progress suites and mobile composition/total/progress/store/verify suites. Manually confirm known assigned other slots never gain extras from a main Oiler role or runsInspections setting; verify sig1/sig2 remain. Cover normal day plus existing holdover Yard/Home middle/last-day variants. Confirm a valid Oiler and solo Operator remain FULL. No full gate was run during this plan.

### Risk

- **Weakest source:** Current USER direction is explicit. It deliberately supersedes TCG-237 Q47–Q49's earlier working assumption for assigned tickets.
- **Migration reversible:** N/A; no migration.
- **Behind a flag:** No new flag proposed.
- **Touches existing data:** No rewrite; changes displayed/required steps for applicable active assignments. Existing submitted evidence stays intact.
- **Blast radius:** Existing third-man/driver own-inspection flow, mobile required-step counts, API submit validation and office progress. Coordinate release with installed app versions.

### Ripple — existing consumers

| Consumer | Reached via | Regression check | Source |
| --- | --- | --- | --- |
| Mobile routes/totals/progress | Flow + ownInspections | Existing composition/total/progress suites; manual 8-step assigned tickets | REQ-04 |
| API submit | Required steps | Existing submit suite; actual STANDARD submit with no inspection data | REQ-04/05 |
| Prefetch/background verification | Required data and steps | Offline STANDARD capture/reconnect; existing sync suites | REQ-05 |
| Office progress | Shared step helpers | Same steps as mobile, including holdover variants | REQ-04/05 |
| Oiler/solo Operator | Shared resolver | Re-run U1 manual smoke matrix | REQ-02/03 |
| Payroll inputs | Ticket/labor records | Existing separate employee input structure retained; no rate/pricing modifications | REQ-06 |

### Deliberately not in this unit

Historical repair Q1; changed vacancy Q2; changed missing-slot fallback Q3; standalone vehicle/gear inspection feature changes. No pay-rule redesign.

## Sequencing

U1 -> U2. These share flow policy, mapper, mobile router/prefetch/sync and progress readers, so they are sequential. If U1 changes any helper/response contract, every reached caller is corrected in U1; it cannot rely on U2 to repair a broken existing caller.

First to ship: U1, because it proves the reported cross-role crew completion and read-only protection. U2 then changes the separately identified other-slot policy across surfaces.

Before release: rebase against current intended base, rebuild shared dist, run measured gates, verify affected real-world case and a fresh crew, coordinate API/mobile rollout, and inspect an old draft. A released old app is not hotfixed by changing an API boolean; document any mixed-version interval and the actual behavior. Historical exception repair remains a separately approved, guarded task.
