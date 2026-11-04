# Reflection — MOBILE-REMAINING-PRESIGNED-FILES

First written 2026-11-03; post-merge close-ticket update 2026-11-04. U0/U1/U2 merged to staging in platform PR #1018, merge `330cedd99` including reviewed head `350dad0da`. The overlay merged to main in PR #228, merge `73d8662`, including U2 record `47f0284`. Merge references were verified by the coordinator; deployment and device behavior are not established.

## What this is for

Review what the specification omitted, what execution contradicted, and which concrete process change would prevent recurrence. Findings attach to artifacts, not people. This reflection uses the existing template fields and distinguishes reviewed source from observed runtime behavior.

## Fill rules

All required fields are retained. Proposed tooling changes below are proposals for Haris; no rule, context, template or agent file was edited.

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `MOBILE-REMAINING-PRESIGNED-FILES`; no external ticket |
| Spec | `.ai/aidlc/MOBILE-REMAINING-PRESIGNED-FILES/spec.md`, restored full remaining-read scope 2026-11-03 |
| Units | U0 metadata consistency; U1 presigned reads/viewers and employee owner-or-admin links; U2 quotation/job-walk hierarchy and UUID consistency; all merged in PR #1018 to staging. Combined PR boundary deviation recorded in ED-2 |
| Reflected on | 2026-11-03; post-merge update 2026-11-04 |
| Reviewer(s) | Original reflector synthesis used independent analyst (`analysis-presigned.md`) and guardian (`guardian-presigned.md`); original reflector also implemented U1 UI. Post-merge reflector uses independent `analysis-pr-1018.md` and coordinator-verified merges; no fresh runtime verification |
| Open questions at build time | 0; prior viewing/download, upload preservation, quotation open/share and metadata answers recorded; latest explicit implementation request settled inclusion of saved certification/job-walk/incident reads |
| `[UNVERIFIED]` requirements built | 1, REQ-05 saved JSA rendering; no demonstrated false/stale product requirement. Source review indicates coverage, not device verification |
| Unverified × irreversible | 0; no migration, data rewrite, new enum, dependency or permanent signed URLs |

Historical reported gates at the original pre-merge reflection: fresh baseline 13 mobile suites/137 tests plus 5 API suites/25 tests passed; API final build/lint and 114 selected API tests passed; UI focused suites reported 54 passing tests; final JSA selected suites reported 58 passing tests. Focused runs with open handles are explicitly qualified in review.md; printed passing results do not imply normal process exit. Final mobile lint reported 0 errors/410 warnings by the coordinating executor. Aggregate full mobile tests and final typecheck were still running at the original reflection; later state.md reports affected API suites 33/33, API lint/build and mobile typecheck passing. These are historical executor reports, not fresh closure gate results. Quote-detail regression separately reported 51 passes and one pricing expectation failure, requiring baseline disposition rather than an assumed new regression. Configured-device/S3/native sharing/cross-tenant checks were not performed. Independent PR #1018 static review (`analysis-pr-1018.md`) found no blocking contract/isolation defect and returned ship with follow-ups. The requester excluded builds, tests and typechecking from this review/closure; none were rerun. Runtime sign-off remains unavailable.

## 1. Spec defects — what the spec missed

### SD-1 — Narrower metadata clarification displaced the original viewing/download goal

- **Where:** Earlier metadata-only plan/spec and archived `presigned-read-plan.md` / `presigned-read-spec.md`; requester correction preserved in intent.md §3.
- **What the executor needed to know:** Whether attachment UUID/type/category consistency supplemented or cancelled the original presigned viewing/download and quotation open/share request.
- **What the spec said:** The previous current plan excluded viewing/transport changes and treated the presigned proposal as archived separate consideration, despite the conversation already specifying presigned viewing/downloads and quotation open/share.
- **What was decided instead, and by whom:** The earlier scope translation treated the later consistency clarification as a replacement objective. The requester subsequently confirmed missing work must be restored, planned and implemented through all phases; current spec/units now map REQ-01 through REQ-06 across the completed parent and U1.
- **Was the decision right:** No. The later explicit instruction and the assistant's acknowledgment establish the omitted original objective. U0 itself correctly implemented metadata; the error was presenting that narrower scope as the working plan for the overall goal.
- **Cost:** Extra clarification, archived active work, a second planning/build round and avoidable uncertainty about whether quotation/job-walk viewing was complete.
- **Class:** missing; index `missing-requirement`. An inherited request obligation disappeared before the unit coverage count, so counting only the reduced spec could not catch it.
- **Fix:** R1 requires explicit dispositions for inherited requester obligations before coverage is declared; updated U1 now records the full matrix. Do not infer cancellation from an additional consistency instruction.

## 2. Executor defects — what was built against the spec

### ED-1 — New incident viewer could reuse an empty pre-upload report cache

- **Where:** `apps/mobile/data/hooks/use-ticket-incidents.ts`, with the preexisting submission sequence in `use-incident-report.ts`; independent analysis finding 1.
- **Spec said:** REQ-06 requires saved incident evidence/signatures to display from existing incident context while preserving submission behavior.
- **Built:** Initial U1 added the saved viewer, but the inherited submit sequence cached the newly created report before evidence uploads and successful evidence upload did not invalidate that list. Reopening within staleTime could therefore show no evidence even after a successful upload. This was inferred from source, not reproduced on a device.
- **Caught by:** Independent analyst review; fixed before handoff by invalidating `queryKeys.ticketIncidents(ticketId)` on successful evidence upload. Analyst verified the diff; immediate device refresh remains an unperformed manual check.
- **Class:** other; index `stale-ui-state`. Cached empty report state outlived the later evidence mutation.
- **Fix:** R2 makes query source and mutation invalidation part of the existing analyst sibling check. Existing build/type checks cannot demonstrate post-upload visibility.

### ED-2 — Historical passing gates did not enforce declared PR and test scope

- **Where:** units.md U0/U1/U2 and Tests rows; `analysis-pr-1018.md` SCOPE; `apps/api/src/service/storage/s3-storage.service.spec.ts` adds two cases at reviewed-head lines 35 and 57.
- **Spec said:** One unit per PR with dependent units stacked; spec §10 and U0/U1 Tests rows say new tests not requested. U2's “zero new test files” is weaker than the governing prohibition on new cases.
- **Built:** Three declared units landed together in PR #1018, and two storage test cases were added without authorization in the reviewed records. Existing expectation updates would be distinct.
- **Caught by:** Independent PR review after historical checks had been reported. Subsequent merge/closure authorization does not establish missing test authorization retroactively.
- **Class:** `gate-illusion`; normal build/lint/test gates do not check these process contracts.
- **Disposition / fix:** Record the combined merge; do not rewrite merged code/history during closure. R3 requires reviewable PR/unit and added-test authorization evidence. No tooling change applied.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:** The historical planning-only/metadata-only notes now both have partial-supersession frontmatter pointing to `decisions/2026-11-03-mobile-presigned-read-implementation.md`; the prior writeback finding is resolved. November 4 decision notes record viewers/employee owner-or-admin links and quotation/job-walk hierarchy/UUID persistence including signed copies. Zero product sources were proved false; none is a promoted verified TCG ruling. Pre-U2 wording that calls signed-copy normalization a follow-up is superseded by merged U2; closure must use the current ledger.
- **Conflicts that surfaced only during build:** NONE FOUND in the product vault. Field-ops and quotation conflict stubs remain unresolved and were not adjudicated by this technical migration. The scope translation mismatch was within task records, not a new business conflict.
- **Questions answered by a named human during the build:** NONE FOUND with an established personal name. Requester direction is recorded in intent.md/spec.md; Git identity must not manufacture decision-maker identity. Requester-direction notes and supersession pointers are present. The current “leave it” disposition concerns a minor implementation finding, creates no business rule and needs no scrum decision note.
- **`gaps.md` entries this ticket should close:** NONE FOUND; no winning/losing source frontmatter changes are justified. Ticket §12 has no open question; close-ticket must preserve runtime limitations and separate follow-ups after actual merge.
- **`gaps.md` entries this ticket opened:** NONE FOUND. Unrelated web blob conversion remains separate; signed-copy canonicalization is delivered by U2. The November 4 access note leaves generic byte-download employee restrictions and incident/job-walk role restrictions undecided; this ticket does not settle them.
- **Undefined terms hit:** Existing certification `id` is polymorphic across credential and attachment rows; U1 introduces separate optional `attachmentId` instead of assuming all IDs are file IDs. This is a contract identity clarification, not a new business term or model.

## 4. Rule changes proposed

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/aidlc/templates/units.md` | Requirements covered, below unit ledger | Replace the four-line `Requirements covered: REQ-01..REQ-nn... Not covered...` bullet with: `- Coverage ledger: one row per current and inherited requester obligation: source/message → REQ → unit → implemented/pending/explicitly withdrawn. A later clarification adds detail unless it explicitly cancels an earlier obligation; quote the cancellation for every withdrawn row. Recount on each scope change. Any pending row prevents reporting the overall request complete, even when every current unit is built.` Adds 1 line, removes 4. Required ledger structure prevents the original viewing/download obligation from disappearing before the REQ count; a mere reminder to reread the spec would not catch SD-1. | SD-1 | pending — Haris review |
| R2 | `.ai/aidlc/agents/construction/tcg-analyst.md` | §3b Pattern and siblings hazard row | Replace that row's check text with: `Built like its contexts/patterns.md reference? Every recorded sibling marked applied must be changed or verified unchanged. For each new saved-data viewer, report its query key, every mutation that changes displayed children, and the invalidation/update path after each mutation; missing evidence is a finding. State whether the immediate post-save/reopen scenario was run or remains unverified. Unrecorded reached siblings are findings. Method: review-pr §4c.` Adds 1 table row, removes 1 table row. This extends the actual review artifact to expose the create-before-upload cache window; it does not require unsolicited new tests. | ED-1 | pending — Haris review |
| R3 | `.ai/aidlc/agents/construction/tcg-analyst.md` | §4 Complete? bullet | Replace `- **Complete?** Every row delivered, tests included, migration committed if the schema moved.` with `- **Complete?** Every slice row delivered; map this PR to exactly one declared unit or cite a requester-approved exception. For each added test case, cite the developer request or report a scope violation; updated existing expectations are separate. New tests default to not requested. Migration committed if the schema moved.` Adds 1 line, removes 1. Required evidence would expose both ED-2 deviations without new tests or rerunning gates. | ED-2 | pending — Haris review |

- **Rejected proposals, and why:** Do not require a new test suite for this ticket: the repository explicitly prohibits new tests unless requested. Do not invent direct S3 PUT uploads, backfill old attachment rows, add stricter role policy or create a universal embedded viewer to solve a GET-read migration. Do not copy the same rule into mobile context, executor and analyst; each proposal has one home. Rule files were not edited.

## 5. Recurrence check

Original run checked index size (44,259 bytes), vocabulary and missing-requirement/stale-ui-state rows. Post-merge run checked current size (45,076 bytes), read vocabulary by section and grepped gate-illusion; read relevant sections of MOBILE-TICKET-PRESIGNED-IMAGES ED-4 and MOBILE-OFFLINE-DELETE-QUEUE ED-2. Original SD-1/ED-1 rows remain untouched.

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | `missing-requirement` | 26 prior class rows; related scope/coverage lessons in MOBILE-OFFLINE-DELETE-QUEUE SD-2/SD-3 and inherited slice coverage in TICKET-EDIT-AFTER-24H ED-1 | 27th broad class occurrence; first recorded instance of this exact clarification-as-cancellation shape | Existing coverage counts operate on current spec REQs; an omitted original request is invisible to that count. Required source-obligation disposition rows address the structural gap instead of another reminder |
| ED-1 | `stale-ui-state` | MOBILE-TICKET-PRESIGNED-IMAGES ED-2/ED-3; MOBILE-OFFLINE-DELETE-QUEUE ED-1 | 4th | Prior proposals remain proposed/escalated and focused on image/error state or derived sync indicators. The current analyst hazard table has no required saved-query/mutation-invalidation trace. This source window was caught in review, not a demonstrated runtime failure |
| ED-2 | `gate-illusion` | 17 prior index rows including withdrawn historical rows; related MOBILE-TICKET-PRESIGNED-IMAGES ED-4 and MOBILE-OFFLINE-DELETE-QUEUE ED-2 | 18th broad-class row | Earlier fixes/proposals target baselines, gate execution and derived-state review. Current analyst §4 says “tests included” while repository rules default new tests to not requested; no explicit PR/unit or test-authorization evidence is required. R3 replaces that ambiguous completion check |

- **Escalate:** All three classes exceed the recurrence threshold. This is not a reminder problem: R1 requires a reviewable source-to-disposition ledger; R2 replaces an existing reviewer check with a query/mutation trace. R3 requires PR/unit and added-test authorization evidence. These are report/template mechanisms, not claims of automated enforcement. No new rule has been applied by this reflection.
- **New class added to the index?** No; existing vocabulary covers all three findings.
- **Rows appended to `reflections/INDEX.md`:** Original SD-1/ED-1 rows preserved; append ED-2 only. All three proposals await Haris; none applied.

## 6. Kept as-is

- U0 metadata consistency remains the parent: owning resource UUID/type/category, legacy compatible reads and no historical data rewrite. U1 adds viewing/downloads and preserves current multipart upload transport.
- New authenticated `/attachments/:id/links` explicitly constrains attachment UUID and current tenant before signing only the stored key. Its deliberately tenant-wide generic-download policy is not described as employee-self or crew-only permission. Guardian static approval is separate from unperformed live cross-tenant validation.
- Forced-download document URLs and a raster-only optional preview allowlist reuse existing signers. No new image-cover contract, shared export, schema column or dependency was needed.
- Credential metadata winner remains expiry-based; separately selected latest uploaded document identity is exposed as optional `attachmentId`. DB-only credentials have no broken file action. Exact selection/tie-break is a technical decision for the current spec decisions table, not a new approval workflow.
- Signed links remain transient and are fetched on demand; one retry surrounds failed signed downloads only. Native sharing happens after that retry block, so a sharing cancellation/error cannot trigger another share prompt. Session epoch checks suppress opening after account transition.
- Saved job-walk roles use the existing report list and stored attachment FKs; local SignaturePad capture/edit behavior stays unchanged. Saved JSA and incident covers reuse existing image components and retain local capture precedence.
- **P3 JSA duplication explicitly deferred by requester 2026-11-04 (“leave it”):** Independent source review infers repeated ticket-level saved signatures across multiple JSA forms can show `2/1` and submit repeated upserts. Selection/upsert keys refute signature-loss claims. Not reproduced, not fixed, and not a closure blocker under the requester disposition. No new rule proposal is justified for this deferred minor finding.
- Merged U2 scopes new quotation documents/signed copies and job-walk files under quotation UUID paths, normalizes owner UUIDs and preserves legacy keys/alias reads. No data rewrite, object move or migration.
- Independent source review is complete with follow-ups. Native sharing, expiry recovery and fresh-device rendering remain unverified. Historical gates were not rerun; platform/overlay merges are verified, deployment is not asserted. Remaining closure state/ledger/demo/processed/push actions belong to the coordinator.

Process improvement: maintain the full obligation ledger when the requester adds consistency requirements, and verify saved-file UI against post-upload cache state before calling the overall migration complete. Unrequested idea, not built: a compact attachment provenance panel could help support staff distinguish credential identity, attachment identity and last upload without inspecting database rows; a human may ticket or discard it.
