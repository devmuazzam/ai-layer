# Proposed units — MODULE-SCOPED-ATTACHMENT-STORAGE

2026-11-06 · tcg-decomposer · **planning only; not approved for build**.

Input: final spec.md REQ-01–06 and D1–D9 (2026-11-06), code-review.md,
ownership-audit.md and the PR #1049 review-cleanup-fix.md; wording reconciled to the final spec.
This file applies the guardian's corrected source fact: JobWalkReport.quotationId is a
required UUID, create resolves a required quotation and update does not reparent it. Missing
quotation fallback/sentinel states are invalid, **not a supported standalone job-walk flow**.
No independent job-walk folder or new business capability is proposed.

## What a unit is

A unit delivers one independently demonstrable user/file flow across its existing route,
owner resolution, object persistence and reached clients. These three are vertical slices,
not API layers or a foundation project. Helpers are introduced inside the first real upload
flow, then reused. Per developer decision (Muazzam, 2026-11-06) all units share one branch, `fix/module-scoped-attachment-storage`, one commit per unit, one PR.

## Fill rules

Every template field is retained. New tests/cases are **not requested**. Existing fixtures
may be updated only where implementation requires them; existing suites/manual checks are
required evidence. No code, schema/data change, runtime test, commit, push or deployment is
authorized by this document. `[UNVERIFIED]` technical sources remain unverified; code is
evidence about current consumers, not a new product requirement.

The ledger covers the complete selected future-upload/generated-file scope and its new-family
access, lifecycle and contract closure. Q1 is resolved by the requester's exact answer,
“No need to handle historical files or retire their availability.” (S9/D7). Existing stored
rows, keys, readers, ordinary deletes and current availability remain unchanged; already-strict
ticket behavior stays strict. Historical handling is excluded, not a blocked later stage.
No unresolved requirement remains.

## Gate baseline

**Measured 2026-11-06 on `fa83fe40f` (= `origin/staging`, clean tree, no code change):**
`NODE_OPTIONS=--max-old-space-size=4096 pnpm nx run-many -t lint,build,test --skip-nx-cache`
(fresh, uncached, 7m42s, exit 1). Log: scratchpad `baseline.log`, not committed.

| Project | lint | build | test |
| --- | --- | --- | --- |
| @tcg/shared | 0 errors, 1 warning | pass | 249 pass |
| @tcg/payroll-engine | pass | pass | **FAIL pre-existing:** 101 pass / 28 fail; `SyntaxError: Named export 'toPacific' not found ... '../dist/index.js' is a CommonJS module` (shared dist import) |
| @tcg/api | 0 errors, 433 warnings | pass | 3845 pass (328 suites) |
| @tcg/web | 0 errors, 1 warning | pass | 1053 pass |
| @tcg/mobile | 0 errors, 259 warnings | not a target | **FAIL pre-existing:** 3347 pass / 2 fail: `signer-capture.test.tsx` "Retake via preview modal..." (5000 ms timeout) and `step-dispatch.test.tsx` "renders the review body for a review-kind step..." |

Nx reported `@tcg/web:build` and `@tcg/api:test` as flaky; both passed here. The two
failing suites are unrelated to attachment storage and fail on untouched staging. Mobile
timeouts may be load-related (not re-run in isolation). Any U1–U3 result is compared against
this table; a failure outside it is ours.

## Unit ledger

These statuses mean proposed work has not started; they do not approve implementation.

| Unit | Outcome | Reqs — allocation within selected future-write scope | Surfaces | Depends on | Size estimate | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Ordinary new module files upload, open and delete through existing clients with canonical owner paths and consistent failure handling | 01 family inventory; 02 ordinary writers; 03–06 new-file/access/contract closure | API, existing web/mobile flows; shared regressions | — | ~400–700 source lines / 8–14 source files | built — fix/module-scoped-attachment-storage |
| U2 | Newly filed signed PDFs on projects/jobs have independent canonical objects without breaking quotation/master/signing behavior | 01 family inventory; 02 generated fanout; 03–06 generated-copy/master closure | API, web/mobile signed-file consumers | U1 | ~140–260 source lines / 2–5 source files | built — fix/module-scoped-attachment-storage |
| U3 | Job-walk signature uploads use their verified real quotation hierarchy; invalid parent states fail before mutation, replacement/clear preserve success semantics | 01 final source audit; 02 defensive flat writer; 03–06 job-walk closure | API, existing mobile/web job-walk consumers | U2 (transitively U1) | ~120–240 source lines / 3–6 source files | built — fix/module-scoped-attachment-storage |

### Requirement accounting — all 6 selected requirements allocated

| Requirement | Assigned coverage |
| --- | --- |
| REQ-01 | Delivered by current inventory/planning artifacts and planning-review.md, not an artificial implementation-only unit; developer review remains pending. U1–U3 maintain family operation/ripple evidence and U3 repeats bounded source-producer searches |
| REQ-02 | Fully allocated across U1–U3: all 15 ordinary generic types, PROJECT/JOB generated fanout and invalid JOB_WALK flat fallback; structured siblings remain regression checks. Not implemented or accepted yet |
| REQ-03 | Fully allocated across U1–U3: new-owner preflight and new-family access/cleanup ownership, explicit tenant predicates and unchanged existing-row access/deletion contracts |
| REQ-04 | Fully allocated across U1–U3: existing routes/shapes/metadata/authorization/variants and old-file availability/deletion remain unchanged while only future writes relocate |
| REQ-05 | Fully allocated across U1–U3: caller/error ledgers, create/replace/delete consistency and compensation for the changed producer families and all reached consumers; no catch-all or unrelated lifecycle redesign |
| REQ-06 | Fully allocated across U1–U3: existing suites/gates and authorized per-family QA, including new-file ownership/failure outcomes and existing-access compatibility |

Count: **6/6 selected requirements covered by the plan, 0 uncovered, 0 open**. REQ-01 is
planning work; REQ-02–06 are assigned across three future units. Assigned coverage does
**not** mean implemented, tested or accepted code. No historical stage is missing or blocked:
the requester explicitly excluded it.

**Units blocked on an open question:** none. All three still await explicit implementation
instruction, a measured baseline and normal developer/guardian review. No build is authorized.

## U1 — Ordinary module documents through existing upload/access flows

- **Outcome:** A user can upload a new ordinary module attachment through the existing
  web/mobile workflow, open/delete it with existing clients and find its bytes under that
  module's verified owner UUID rather than the generic flat prefix.
- **Kind:** vertical — includes real upload/access/lifecycle behavior, no foundation-only PR.
- **Requirements covered:** REQ-01 ordinary-family inventory; REQ-02 ordinary writers;
  REQ-03 new-family access with existing photo/sub-job guards retained; REQ-04 reached clients/contracts; REQ-05
  ordinary creation/metadata/cleanup ordering; REQ-06 these flows. This fully assigns U1's selected family scope; existing-file access/deletes remain unchanged under S9/D7.
- **Depends on:** —.
- **Branch / PR base:** `fix/module-scoped-attachment-storage` (shared by U1–U3), based on
  `origin/staging` (`fa83fe40f`, verified 2026-11-06). One commit for U1.
- **Size estimate:** ~400–700 source lines, 8–14 source files; information, not a budget.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — existing Attachment/owner models suffice | No schema migration, existing-row pointer rewrite or blanket UUID metadata conversion |
| API (`apps/api`) | Replace only ordinary generic upload's flat branch with exhaustive module preparation/key dispatch; extend existing owner helpers/repository access at their correct layer and export needed symbols through barrels | `presentation/attachments/attachments.controller.ts`; `usecase/attachments/attachments.service.ts`; focused `service/attachments` owner/classifier helper(s); `service/storage/s3-storage.service.ts`. Introduce helper as part of this functioning vertical flow, not a separate foundation unit |
| API preflight/persistence | Resolve supported tenant owner and immutable UUID, file/category/certificate inputs and JOB editability before any S3/related metadata mutation. Preserve current featureId aliases. Apply metadata+row persistence consistently and compensate only newly owned objects if creation fails, retaining original failure | D1–D5. Preserve EMPLOYEE/me/uploader rules, note-parent identity, PO-code close/reopen, sparse USER/TOOL generic support, staged owner-create-before-upload. Never use code/category/originalName as a key segment |
| API new-family access | Validate newly introduced structured files against concrete owner before links/stream/delete; retain existing profile/sub-job/ticket guards | Direct plan/quotation email, meter evidence and public cover consumers must remain compatible. New-file public/SUPER_ADMIN/background checks derive authoritative row/source tenant. Rejected new-family keys cannot fall through to an unvalidated singleton branch |
| API existing-access preservation | Existing stored rows, keys, readers, ordinary deletes and availability remain unchanged; strict ticket refusal remains unchanged | S9/D7 is resolved. Retain current compatibility and endpoint authorization; do not apply new owner/key checks globally to old rows or turn prior flat ordinary deletes into rejection. Demonstrate existing-format open/delete compatibility without rewriting those rows |
| Web (`apps/web`) | Existing wrappers/components and staging/upload sequence retained; no new UI. Include any strictly necessary caller adjustment to preserve existing supported owner-create-before-upload flow in this same unit | `features/attachments` hooks/API; notes; certificate/meter; permit/plan/PO/customer/project/yard/agency/job forms. No changed test IDs or public metadata contract planned |
| Mobile (`apps/mobile`) | Existing certification uploader, quotation/source-artifact link viewers retain their interfaces; no new screen | Certification EMPLOYEE upload and `lib/attachment-links.ts` direct-S3 refresh/share flow checked on emulator after authorization. Old cached API download URI policy unchanged |
| Shared (`packages/shared`) | N/A — no public type change planned; existing cover/loadout types remain consumers | Build `dist` through Nx prerequisite; if a response/type change becomes necessary, tracer and all callers belong here |
| Tests | **New tests/cases: not requested.** Discover/run affected existing API/web/mobile suites; update only necessary existing fixtures. Record actual QA evidence separately | Plan targets in reviewable/ripple rows; no green baseline inherited from prior ticket |

The ordinary set is exhaustive: YARD, ASSET, CUSTOMER, CUSTOMER_NOTE, PROJECT, EMPLOYEE,
EMPLOYEE_NOTE, AGENCY, JOB, USER, PERMIT, PROJECT_NOTE, PLAN, TOOL, PURCHASE_ORDER.
QUOTATION remains structured; four ticket feature types remain rejected by generic upload.
JOB root-document ownership is distinct from existing JOB/SubJob photo identity: an ID
must be resolved against its actual family and never guessed from UUID syntax alone.

### Reviewable as

- **Demo:** From existing module pages upload a disposable file; call existing list/links/
  stream/delete endpoints and open the same ID through mobile where applicable. Inspect
  authorized test DB metadata and actual S3 object key after implementation, proving owner
  UUID/module path without altering featureId/certificate/PO/note identity. Repeat once for
  every ordinary enum family, not only a CUSTOMER example.
- **Acceptance:** REQ-02 ordinary-path acceptance; REQ-03 explicit tenant/owner preflight
  and recognized modern-key mismatch rejection; REQ-04 existing interfaces; REQ-05
  failure-order ledger; REQ-06 per-family evidence. Show unauthorized/wrong-owner failures
  before bytes/metadata, failed insert compensation, unknown-error propagation, and no
  newly accepted ticket flat path.
- **Reviewer can verify without:** U2/U3, production data or any historical-data operation. QA still requires an authorized local/disposable tenant and
  reachable configured storage; unavailable roles/environment are NOT CHECKED.

### Risk

- **Weakest source:** `[UNVERIFIED]` S1/S2/S4/S5/S6; D1–D5/D9 are implementation decisions
  for developer/guardian review, not client-confirmed product facts.
- **Migration reversible:** N/A — no schema or historical-data migration. New objects use
  the new hierarchy; rollback must retain reading those objects and cannot blindly deploy a
  version that cannot open them.
- **Behind a flag:** no flag specified/proposed; do not invent a rollout mechanism.
- **Touches existing data:** existing normal single-owner attachment/metadata operations
  only; no backfill, key rewrite or historical sweep. Compensation must be limited to the
  newly created operation's objects.
- **Blast radius:** all generic upload clients, PO/certificate effects, aliases and direct
  byte readers; misclassification can break otherwise unrelated profiles or sub-job photos.

### Ripple — what already works that this unit reaches

All checks below are **planned, NOT RUN**. Source anchors are code-review §§1–3 and
ownership-audit §§UUID/code hazards/Read-delete design, enumerated with their recorded rg
commands; spec §11a supplies the intended preserved behavior.

| Existing consumer | Reached via | How we know it still works — required future check | Source for what happens to it |
| --- | --- | --- | --- |
| All generic web module upload/list/download/delete/expiry and notes | Shared AttachmentsController/Service, attachment hooks and pending upload helper | Existing `attachments.service.spec.ts`, controller photo-read/delete suites, existing web attachment helpers; manually create/upload/open/bulk-delete each mapped ordinary type and note parent; disposable existing-format ordinary file still opens/deletes under prior policy | REQ-02/03/04/06; S9/D7; §11a generic/web/notes rows |
| Mobile certification EMPLOYEE upload and employee expiry/certificate references | Same generic upload and owner resolver | Existing mobile certification contract/mock/hook/menu suites; emulator own certification upload/open; wrong-employee/admin checks; API certificate metadata before/after | REQ-03/04/05; D3/D5; employee owner contract |
| PO invoice close/reopen and generic JOB view-only guard | `AttachmentsService.create/delete` workflow hooks | Existing purchase-orders and attachments suites; manually upload invoice, delete last invoice, completed-JOB rejection before S3; verify existing code metadata retained | REQ-04/05; D3/D5; §11a certificate/PO row |
| Plans/quotation additional email/envelope documents | Direct `getObjectStream` callers outside controller | Existing plans/quotation-signatures suites; authorized disposable send/envelope preparation or safe captured provider run proving selected file bytes/filenames, owner mismatch rejection before provider action | REQ-03/04/05; §11a email row; no external message authorization inferred |
| Meter history and public tool cover | Direct presigning/public stream | Existing assets/tools suites; old evidence and QR covers still open unchanged; new-file owner mismatch refused where applicable without old-row policy tightening; new-file tenant derived authoritatively | REQ-03/04; S9; §11a meter/public-cover rows |
| Profile ASSET/TOOL/EMPLOYEE/USER and sub-job loadout/offload | Generic classifier and delete dispatcher | Existing photo read/cover/delete/controller suites and `das-loadout-save-photos.spec.ts`; manually cover/replace/delete pairs, carried-forward loadout guard, preserve thumbnail vs preview distinction | REQ-03/04/05; §11c structured siblings |
| Source PLAN/PERMIT/PO files inside mobile ticket artifacts | Generic links invoked by `job-artifacts-section` | Existing field-tickets suite; emulator open same source attachment ID from ticket and source module, preserving source owner and live-link recovery | REQ-04/06; §11a mobile/inherited-artifact rows |
| Expiry notifications, note references and renamed employee codes | Metadata/feature aliases | Existing scheduled-job service/tenant-window suites; inspect dry-run notification context and current notes/certificate IDs; code rename does not move UUID-key object | REQ-03/04; D3; §11a metadata rows |
| Strict ticket uploads/reads/deletes and post-save replacement | Shared storage/classification helpers only | Existing guard/signature/checklist/lunch/returned-correction/incident/attachment suites; manual original stale-key counterexample, direct invalid-key rejection and no field streaming fallback restored | REQ-03/04/05/06; S3/S6; D7 |

### Deliberately not in this unit

- PROJECT/JOB generated-copy writer conversion and independent signed master handling — U2.
- Generic JOB_WALK defensive fallback and dedicated synthetic quotation sentinel — U3;
  existing job-walk functionality remains unchanged until then. U1 must not break its
  already-structured rows or route contracts in the interim.
- Physical flat-prefix builder removal/assertion for **all** producers — only possible once
  U2/U3 have removed their remaining calls; U1 claims ordinary branch elimination only.
- Historical migration/handling/availability retirement, blanket old-row read/delete tightening,
  data manifests and prefix deletion — explicitly out of scope under S9, with no dependent later stage.

## U2 — Independently owned generated signed PDFs for projects/jobs

This redirects the existing backend DocuSign-completion/project-conversion fanout. It does
not introduce a new signed-copy workflow or copy files that the application did not already file.

- **Outcome:** Completing/converting a quotation can file new signed PDFs on existing
  project/job attachment tabs under each destination's canonical UUID folder; deleting one
  copy does not remove another destination or the master.
- **Kind:** vertical — actual signing/conversion/generated-file behavior and client access.
- **Requirements covered:** REQ-01 generated-family inventory; REQ-02 generated writer; REQ-03/04 new generated owner/master and
  existing signed-file contracts; REQ-05 per-destination persistence/compensation/dedup;
  REQ-06 this complete family scope. Existing source/master access and deletion behavior remain unchanged under S9, not deferred work.
- **Depends on:** U1 (its canonical ordinary owner/key/access family helpers and contracts).
- **Branch / PR base:** same shared branch `fix/module-scoped-attachment-storage`; one commit,
  on top of U1's commit.
- **Size estimate:** ~140–260 source lines, 2–5 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — retain current rows/master field and references | No data migration/metadata rewrite |
| API (`apps/api`) | Select canonical PROJECT/JOB UUID and tenant alongside existing code metadata in signed target collection; write independent `signed` object per target; eliminate fanout flat branch | `usecase/quotation-signatures/signed-copy-attachments.service.ts`, existing repository selection if needed; extend U1 builder/classifier's fixed signed group at service/storage boundaries |
| API lifecycle/access | Review master/generated read, write, dedup and loser cleanup order. Validate new target ownership before mutation/access; compensate only failed-target new objects and retain original error; preserve never-fail-signing wrapper/master fallback | Trace quotation completion/download/email and project conversion callers. Existing master/copy keys, references, reads and ordinary deletion policy stay unchanged; no retroactive checks on stored files |
| Web (`apps/web`) | Existing signed-details/quotation/project/job attachment views unchanged; include necessary contract fixes in this unit if discovered | No new screen/route/blob transport |
| Mobile (`apps/mobile`) | Existing quotation cards and source artifact viewers unchanged; verify opening generated copy by existing ID/link | No persisted signed URLs |
| Shared (`packages/shared`) | N/A — no public shape change planned | Existing generic/local contracts traced |
| Tests | **New tests/cases: not requested.** Existing signed-copy/quotation-signatures/project conversion and attachment suites plus authorized manual flow | No S3/DB/signature request executed in planning |

### Reviewable as

- **Demo:** In an authorized disposable signing fixture, obtain/store the master, file on
  quotation/project/job and repeat conversion/reconciliation. Inspect object keys and row
  code metadata; open each existing tab/link. Delete one target copy and prove remaining
  target/master bytes still readable. Simulate per-target failed insert and retry/dedup
  through existing provider mocks/manual harness, proving no leaked new flat object.
- **Acceptance:** REQ-02 fanout path; REQ-03 row/source-tenant and target UUID ownership;
  REQ-04 master/attachment separation and signing contracts; REQ-05 failure-order ledger;
  REQ-06 provider/real-byte evidence with its limits stated.
- **Reviewer can verify without:** U3, any historical-data operation or a real customer
  signature/email. Use existing mocks/authorized QA providers; unavailable external
  integration stays NOT CHECKED and no message is sent without explicit authorization.

### Risk

- **Weakest source:** `[UNVERIFIED]` S1/S2/S6; D2/D3/D5/D6/D9 reviewed as technical choices.
- **Migration reversible:** N/A — no schema/pointer migration. Retain access to new signed
  keys on rollback; independently created target objects are not shared rollback collateral.
- **Behind a flag:** no flag specified/proposed.
- **Touches existing data:** ordinary signing/conversion inserts and master reconciliation
  only; no mass historical key updates or old shared-key deletion.
- **Blast radius:** customer signing/public webhook, server-side document/email reads,
  quote-to-project/job conversion and independently deletable signed copies.

### Ripple — what already works that this unit reaches

All checks planned, **NOT RUN**.

| Existing consumer | Reached via | How we know it still works — required future check | Source for what happens to it |
| --- | --- | --- | --- |
| Completion/webhook/on-demand signed retrieval | `storeAndAttach/getSignedPdf/storeMasterCopy` | Existing signed-copy and quotation-signatures suites; repeat provider-failure, missing master and new-store flows, asserting existing response behavior and correct explicit signature tenant | REQ-02/03/04/05; §11a signed master; D6 |
| Project/job conversion/reconciliation | `projects.service.ts:182,777,937,1105` generated fanout | Existing conversion/signing suites; invoke each applicable conversion path, repeat it, verify target codes/UUID keys and duplicate/loser cleanup; no arbitrary-quotation-attachment copy introduced | REQ-02/04/05; §11a fanout; D3/D6 |
| Quote/project/job web tabs and mobile quotation/general cards | Generic list/link/download/delete preserved by U1 | Existing attachment/card suites; manually open same copied ID in client, delete only one destination and read other/master; preserve signed category and original filename | REQ-04/06; §11a web/mobile rows |
| Public/background/SUPER_ADMIN source tenancy | Signature tenant + selected target owner relations, not ambient request | Guardian query review plus authorized mismatched-target/tenant probe; no per-item DB lookup loop or cross-tenant target code ambiguity | REQ-03/06; §8; D2 |

### Deliberately not in this unit

- Changing existing master/source retention, access/deletion policy or moving an existing
  signed key — outside scope under S9, not a blocked unit.
- Reusing one physical object across independently deletable destinations — excluded by D6,
  not a deferred optimization.
- JOB_WALK fallback/sentinel closure and final no-flat-producer evidence — U3.
- Unrelated quotation workflows, external integration deployment or customer notifications —
  not part of this storage patch; current contracts are checked, not redesigned.

## U3 — Verified quotation-owned job-walk signature storage

- **Outcome:** Existing job-walk upload/replace/clear operations use a real resolved
  quotation/report UUID hierarchy, and invalid missing/inconsistent parent states fail
  before new bytes or metadata are written instead of creating flat/synthetic-parent files.
- **Kind:** vertical — generic/dedicated producer paths and existing saved-signature views
  ship together for one module.
- **Requirements covered:** REQ-01 job-walk/final source audit; REQ-02 remaining JOB_WALK flat writer and sentinel correction;
  REQ-03/04 verified new ownership and saved-signature contracts; REQ-05 upload/replace/clear
  consistency; REQ-06 all changed writers and final producer inventory. Existing stored files, access and ordinary deletes remain unchanged under S9; no historical handling stage is deferred.
- **Depends on:** U2, transitively U1; intentional sequential editing of shared storage/
  owner helpers, no parallel helper variant.
- **Branch / PR base:** same shared branch `fix/module-scoped-attachment-storage`; one commit,
  on top of U2's commit.
- **Size estimate:** ~120–240 source lines, 3–6 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — retain required JobWalkReport.quotationId FK | No nullable-parent model, standalone-path feature or migration |
| API (`apps/api`) | Require actual tenant-bound report/quotation UUID before either generic JOB_WALK upload or dedicated signature write; remove generic flat fallback and dedicated `unknown-quotation` sentinel | `presentation/attachments/attachments.controller.ts`; `usecase/attachments/attachments.service.ts`; `usecase/job-walk-reports/job-walk-reports.service.ts`; existing owner/helper exports reused |
| API read/replace/clear | Validate newly introduced canonical report/quotation files before access/deletion; trace upload/save/clear failure order. Preserve expected post-save cleanup handling; new-family invalid direct deletion rejects before mutation; unexpected errors remain errors | Existing flat/sentinel signatures, reads, ordinary deletes and availability stay unchanged. No global legacy validator or late failure after saving; validate new-family keys before destructive cleanup, without redesigning existing history |
| API source-producer closure | Repeat bounded writer searches across audited application/runtime source and generated producers; remove unused flat-write builder if no runtime writer remains, otherwise reconcile the missed producer | Source review only: no global DB/S3 inventory, migration manifest, operational rehearsal or folder-deletion stage. Preserve existing reader/deletion compatibility helpers even after flat writes cease |
| Web (`apps/web`) | Existing saved signature/job-walk consumers checked; no UI/route/metadata shape change | Preserve generic link/download access contract |
| Mobile (`apps/mobile`) | Existing job-walk HTTP/hook/store/capture and saved-signature card operate with report IDs and fresh links | No invented parentless workflow, no permanent URL persistence, no API auth on S3 |
| Shared (`packages/shared`) | N/A — no type change planned | Existing local report/signature contracts retained |
| Tests | **New tests/cases: not requested.** Existing job-walk API, mobile mapper/store/screen and generic access fixtures/suites; manual original invalid-parent and post-save cleanup cases | Record exact ref/tenant/device evidence after authorization |

### Reviewable as

- **Demo:** With a normally created quotation-linked report, upload both operator/foreman
  signatures using existing flows, list/open saved files, replace and clear each. Inspect
  owner UUID key/metadata and deletion objects. With an isolated mocked invalid parent
  state, demonstrate rejection before S3 put/DB mutation through both writer entry points.
  Reproduce the failure-order counterexample using a valid replacement and an invalid
  new-family stale key (retain existing strict-ticket stale-key regression separately),
  proving success continuation and unchanged rejected stale data; direct new-family invalid delete
  remains refused. No actual referentially invalid DB row need be manufactured.
- **Acceptance:** REQ-02 last flat producer and synthetic-parent removal; REQ-03 resolved
  report/quotation identity, no late preflight failure; REQ-04 existing route/role/alias and
  two signature roles; REQ-05 caller/error ledger; REQ-06 refreshed whole-source writer
  inventory and relevant existing/full gates.
- **Reviewer can verify without:** Any historical-data handling, production rows or corrupted real DB FKs. Invalid state may be checked with existing
  mocked provider/manual runtime harness; label it as such rather than a live DB result.

### Risk

- **Weakest source:** `[UNVERIFIED]` S1/S2/S6 plus corrected schema/caller evidence in
  ownership-audit; D4 is the real-parent validation choice, not client authority for a new
  parentless feature.
- **Migration reversible:** N/A — new writes only; no existing sentinel/flat pointer rewrite.
  Preserve existing-file read and ordinary-delete behavior, as already selected by S9.
- **Behind a flag:** no flag specified/proposed.
- **Touches existing data:** normal report/signature save/clear references only; no invalid
  historical row repair or sweep. Stale invalid objects/rows remain untouched when retained.
- **Blast radius:** sales job-walk captures, generic links/upload, shared helper dispatch and
  error ordering after saved report changes.

### Ripple — what already works that this unit reaches

All checks planned, **NOT RUN**.

| Existing consumer | Reached via | How we know it still works — required future check | Source for what happens to it |
| --- | --- | --- | --- |
| Generic/dedicated signature producers, both roles | Report/quotation resolver and key builder | Existing `job-walk-reports.service.spec.ts` plus generic attachment suite; demonstrate real parent path and invalid parent preflight on each writer; existing flat/sentinel signatures retain open/delete availability under prior policy | REQ-02/03/04/05; S9; corrected D4; §11a job-walk |
| Replace/clear and failed-insert compensation | `deleteOrphanedSignature`, normal report write sequence | Existing job-walk suite; explicit caller/error ledger and manual stale-rejection-after-save continuation, direct invalid canonical delete, failed put/insert, unexpected error propagation | REQ-05/06; S6 PR1049 failure record |
| Mobile job-walk form/store and saved signatures | JobWalk HTTP/hook and generic links | Existing `features/sales/job-walk.store.test.ts`, `job-walk-report.mapper.test.ts`, `app/(sales)/job-walk.test.tsx`; emulator capture/save/reopen/replace/clear and failed-link refresh without share retry | REQ-04/06; §11a mobile; D9 |
| All U1/U2 clients and strict/structured siblings | Shared builder/classifier changed again | Existing API acceptance suites/build/lint/typecheck, affected existing web/mobile tests; representative ordinary/certificate/PO/meter/public-cover/fanout/profile/loadout/ticket read/delete recheck where helper behavior changed | REQ-03/04/06; §11c siblings |
| Whole producer inventory | Last audited flat branch / synthetic key removal | Repeat code-review writer/literal-key/SDK searches across app/runtime scripts; every hit classified. Any missed live producer is incomplete U3 work, not a future compatibility default | REQ-01/02/06; code-review §1; D1/D4 |

### Deliberately not in this unit

- Standalone job-walk path or parentless creation capability — not requested and contradicted
  by required quotation relation; no such unit is proposed.
- Existing flat/sentinel row correction, changed read/delete/availability policy, shared-key
  cleanup and prefix deletion — outside scope under S9; no later stage is proposed.
- New provider/integration/framework, dependency or test cases — not requested.

## Explicit exclusions

Historical migration/backfill, old-key/reference reconciliation, historical availability
retirement and physical folder/prefix deletion are outside the selected scope under S9.
They are not blocked later units or a roadmap. No global data/object inventory, operational
rehearsal or future ticket is required by this plan; existing stored files/access/ordinary
deletes remain unchanged. G2 would apply only if a later request actually changed this scope.
New-write completion alone makes no prefix-deletion safety claim.

## Sequencing

```text
Authorization + measured baseline
             │
             ▼
 U1 ordinary documents ──▶ U2 generated signed copies ──▶ U3 job-walk producer closure
```

- **Parallelisable:** none of U1–U3 as currently proposed. U1/U3 both edit
  `AttachmentsController`, `AttachmentsService`, owner classifiers and S3 helpers; U2/U3
  extend/reuse fixed storage groups and generated/new-owner classification. Parallel
  domain labels do not establish file/provider independence. Read-only specialist reviews
  may run together if the coordinator assigns them.
- **Merge order constraint:** U1 → U2 → U3, one branch and one commit per vertical unit, one
  PR (developer decision, Muazzam, 2026-11-06; overrides the one-PR-per-unit default). No schema migrations are planned; if one becomes necessary,
  re-elaborate and include its migration/guardian analysis in its owning vertical unit.
- **Shared providers:** `S3StorageService`, `AttachmentsService` and
  `AttachmentsRepository`/owner helpers are consumed across these flows. Constructor/
  provider/module changes require the affected provider/barrel list and API boot check in
  the same unit, not a deferred integration task. No new module is presumed necessary.
- **First unit to ship, if later authorized:** U1, because it demonstrates the broadest
  contract/tenant/preflight risk on actual ordinary uploads and their existing consumers.
  It deliberately leaves only the named generated/JOB_WALK producer gaps for U2/U3; it is
  not advertised as complete no-flat-write coverage until U3 closes the inventory.
- **Interface windows:** no response/DTO/shared-type change or transport removal is
  planned, so no intentional broken web/mobile interval exists. If implementation needs
  one, repair consumers in the same unit or revise dependencies before shipping.
- **Source/authorization gate:** all selected technical requirements are `[UNVERIFIED]`;
  no destructive data work is in the ledger. Before build, developer reviews AI decisions
  and guardian checks tenant queries; root must reconcile final spec wording with this file.
  Q1 is resolved by S9. Branch proposals or prior test results do not authorize implementation
  or alter the explicit existing-file exclusion.
