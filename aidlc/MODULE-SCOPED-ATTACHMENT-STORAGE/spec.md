# Spec — MODULE-SCOPED-ATTACHMENT-STORAGE

2026-11-06 · Path A · **planning only; implementation, historical-data mutation and prefix deletion are not authorized by this document.** Root coordinator owns state. Read ownership-audit.md and code-review.md alongside this spec; they describe current code, not product intent.

## Fill rules and source tagging

All template sections and requirement fields are retained. `NOT SPECIFIED` and `N/A — reason` remain visible; resolved questions retain their history. `[UNVERIFIED]` here includes requester technical direction and dated notes whose actual frontmatter is `status: reference`; writing a dated note does not promote it to a client-verified requirement. Code evidence sources describe existing consumers only. Rules constrain implementation, not product behavior. Exact server key groups and helper design are AI decisions in §11b.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket / Intent | `MODULE-SCOPED-ATTACHMENT-STORAGE`, local ID; intent.md §3 captures request 2026-11-06; no Jira ID supplied |
| Elaborated on | 2026-11-06 |
| Vault state | Root INDEX 63,923 bytes read by section; module indexes/stubs consulted, totals not recounted; no product source promoted |
| Open questions | 0; Q1 resolved by requester, S9: existing files/access unchanged, historical handling excluded |
| Shipped behavior reached | §11a/S7 operation inventory; existing-file policy unchanged under S9 |
| Rules consulted | User AGENTS; contexts api/prisma/patterns P3/web Test IDs/mobile; elaborator procedure and spec template |

Source register (vault paths are vault-root-relative):

- **S1 `[UNVERIFIED]`, kind requester:** intent.md §3 verbatim current request: analyze/review and **plan** all remaining module-scoped paths before future prefix deletion. Historical scope now clarified by S9; environment/date and named authority not supplied.
- **S2 `[UNVERIFIED]`, kind decision, status reference:** `decisions/2026-11-04-quotation-and-job-walk-s3-folder-hierarchy-and-uuid-consistency.md` §§1–3: quote/document/signed/walk layouts, UUID ownership, old names/aliases preserved; no backfill.
- **S3 `[UNVERIFIED]`, kind decision, status reference:** `decisions/2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md`: strict ticket-only retirement; excludes unrelated generic-route removal/data rewrite.
- **S4 `[UNVERIFIED]`, kind decision, status reference:** `decisions/2026-11-04-mobile-presigned-reads-viewers-approved-employee-files-owner-or-admin.md` Decision 2: employee links owner/admin, other links existing tenant policy; generic download-policy change undecided.
- **S5 `[UNVERIFIED]`, kind decision, status reference:** `decisions/2026-11-03-mobile-upload-attachment-metadata-consistency.md`: mobile identity/type/category consistency. Later implementation supersedes only metadata-only/read exclusions.
- **S6 `[UNVERIFIED]`, kind accepted correction:** `.ai/aidlc/MOBILE-TICKET-STRICT-S3/review-cleanup-fix.md`, spec D7, merged `1e4e375b5`: preserve expected post-save cleanup failure handling, unexpected errors propagate.
- **S7 `[UNVERIFIED]`, kind code/audit:** ownership-audit.md and code-review.md beside this spec; exact source anchors/commands, descriptive only.
- **S8 `[UNVERIFIED]`, kind vault/index:** consulted admin/assets/projects-jobs/quotations/vendors-agencies/field-ops INDEX files. admin/tcg-documents.md contains workflow links, not storage policy.

- **S9 `[UNVERIFIED]`, kind decision, status reference:** `decisions/2026-11-06-module-scoped-attachment-storage.md`: exact requester answer “No need to handle historical files or retire their availability.” New uploads/generated files only; historical files/access unchanged; no migration/backfill/retirement/folder deletion.

Unresolved workflow conflicts: field-ops/field-ops-mobile-INDEX.md (3 candidates), quotations/quotations-INDEX.md (4), vendors-agencies/agencies-vendors-INDEX.md (4); none verified, no winner selected here. S9 now excludes historical handling; S2/S5 preservation and S3 ticket-only retirement remain scoped and unchanged. These boundaries do not create a conflicted business requirement for this technical plan.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Complete storage-operation inventory and reviewed plan | api/web/mobile/shared | `[UNVERIFIED]` | S1/S9 | Planning deliverable; no execution authorization |
| REQ-02 | Module-scoped new writes without a flat fallback | api | `[UNVERIFIED]` | S1/S2/S3/S9 | Candidate after explicit build instruction |
| REQ-03 | Resolve and validate new-file owner and object access | api | `[UNVERIFIED]` | S1/S2/S4/S5/S9 | Guardian/contract review; existing access unchanged |
| REQ-04 | Preserve contracts, existing access and representation | api/web/mobile/shared | `[UNVERIFIED]` | S1/S2/S4/S5/S9 | Existing-file behavior unchanged |
| REQ-05 | Trace persistence and cleanup failure ordering for every caller | api | `[UNVERIFIED]` | S1/S6/S9 | Required evidence before lifecycle changes |
| REQ-06 | Verify each module and adversarial boundary with existing checks | all | `[UNVERIFIED]` | S1/S6/S9 | No acceptance claim without evidence |

Counts: 6 total — 0 verified, 6 unverified, 0 conflicted requirements selecting product sources, 0 open. `[UNVERIFIED]` is not a claimed client decision. No historical stage is planned; nothing is built in this turn.

## 2. Requirements

**S9 boundary:** additional owner/key checks apply to new-write preparation and newly introduced structured files. Existing stored rows, keys, readers and deletion policy retain their current behavior; do not tighten all historical non-ticket reads/deletes under a universal validator. Already-strict ticket and existing photo guards stay intact.

### REQ-01 — Complete storage-operation inventory and reviewed plan `[UNVERIFIED]`

- **Statement:** Plan every remaining flat-prefix dependency with an operation/module disposition.
- **Surface:** api/web/mobile/shared/operations.
- **Sources:** S1/S9 `[UNVERIFIED]`, requester/reference — analyze and plan new files only, historical handling excluded.
- **Conflict:** none; historical handling excluded by S9.
- **Open question:** none; Q1 resolved by S9.
- **Ripple:** Generic/specialized uploads, signing/email/generated bytes, references, replace/delete and all client wrappers; S7/§11a commands.
- **Acceptance:** All 21 enum members and every storage operation have owner, new-write target, verification and existing-file exclusion. External/data coverage unknowns are explicit; API route text is not an S3 key.
- **Edges:**
  - **Reached by:** HTTP, webhook, conversion, background, staged-owner and note flows.
  - **Does not apply when:** Unrelated workflows/storage; structured families are preserved regression siblings.
  - **When an input is absent:** Unknown owner/producer is an inventory gap, never fallback.
  - **Trust boundary:** Search proves code locations only; no actual data counts queried.
  - **Read time:** N/A — named code baseline, not business configuration.
  - **Matrix:** N/A — no synchronization.
- **Notes for the executor:** Planning only; classify exclusions and dead-code hits explicitly.

### REQ-02 — Module-scoped new writes without flat fallback `[UNVERIFIED]`

- **Statement:** New remaining flat-writer files use server-selected tenant/module/owner UUID paths; preserve structured layouts.
- **Surface:** api.
- **Sources:** S1/S2/S3/S9 `[UNVERIFIED]`, requester/reference — new module paths, existing layouts/access preserved.
- **Conflict:** none; historical handling excluded by S9.
- **Open question:** none; Q1 resolved by S9.
- **Ripple:** Generic upload dispatcher, both signed-copy target families, generic/dedicated job-walk invalid-parent branches; S7 §§1–2.
- **Acceptance:** Every mapped producer emits only its structured target. All owner/job/file/certificate checks precede object and metadata writes; no default flat buildKey. Existing format/layout unchanged.
- **Edges:**
  - **Reached by:** Uploads and generated signed fanout, including conversion/webhook.
  - **Does not apply when:** Historical objects/access (S9); existing structured photos/tickets/quotation; local unsaved picks.
  - **When an input is absent:** Missing/inconsistent owner rejects before writes. JobWalkReport requires quotation UUID; no flat, unknown-quotation or phantom parent.
  - **Trust boundary:** Derive tenant/owner/groups server-side; sanitized optional extension, never user filename/category/code in key.
  - **Read time:** Immutable UUID fixed at write, code rename does not move object.
  - **Matrix:** N/A — no synchronization.
- **Notes for the executor:** §3 map/D1 chosen technical layout; API /attachments routes remain.

### REQ-03 — Resolve owner before writes and object access `[UNVERIFIED]`

- **Statement:** Resolve canonical owner/tenant before new writes and validate newly introduced structured files against their row/master owner.
- **Surface:** api.
- **Sources:** S1/S2/S4/S5/S9 `[UNVERIFIED]`, requester/reference: paths, identity, access.
- **Conflict:** none; historical handling excluded by S9.
- **Open question:** none; Q1 resolved by S9.
- **Ripple:** Generic links/stream/delete, notes, certificates, root-job/sub-job photos, generated/master files and privileged callers.
- **Acceptance:** For new files, wrong tenant/parent, ambiguous aliases, note-owner mismatch and Job/SubJob confusion fail before writes/access. Existing stored rows/access unchanged; audit observations authorize no reconciliation or mutation.
- **Edges:**
  - **Reached by:** Every write/read/sign/stream/delete and parent/replace cleanup; S7 §2.
  - **Does not apply when:** No new role policy; existing non-ticket historical access/enforcement remains unchanged under S9. Strict ticket rejection remains.
  - **When an input is absent:** New unresolved owner fails preflight; old unresolved rows/access remain unchanged; descriptive audit classification is not runtime quarantine.
  - **Trust boundary:** Explicit stored-row tenant plus resolved owner, even SUPER_ADMIN/public/background; Prisma scoping conditional.
  - **Read time:** Authoritative ownership per operation; key UUID immutable; association changes must not silently move old files.
  - **Matrix:** N/A — no synchronization.
- **Notes for the executor:** Storage UUID separate from featureId metadata. Batch aliases; trace concrete fields into validator.

### REQ-04 — Preserve contracts and representation `[UNVERIFIED]`

- **Statement:** Storage relocation preserves APIs, authorized consumers, metadata, file representation and workflows.
- **Surface:** api/web/mobile/shared.
- **Sources:** S1/S2/S4/S5/S9 `[UNVERIFIED]`, requester/reference: storage, identity, access/metadata.
- **Conflict:** none; historical handling excluded by S9.
- **Open question:** none; Q1 resolved by S9.
- **Ripple:** All wrappers/viewers, certificates, source job artifacts, notes, email/DocuSign; S7 §3.
- **Acceptance:** No DTO/response/route/category/filename/MIME/certificate/expiry/workflow/permission change. Preserve singleton, profile thumbnail, ticket preview and loadout variants. No generic stream removal or bearer auth on S3.
- **Edges:**
  - **Reached by:** Every frontend and server consumer in §11a.
  - **Does not apply when:** New key/URL text naturally differs; no public/permanent URL, TTL change, UI redesign or forced image decoding.
  - **When an input is absent:** Existing empty/no-file/errors retained; staged picks remain local until valid upload.
  - **Trust boundary:** Existing route-specific access first; safe existing filename/disposition policy retained.
  - **Read time:** Fresh transient presigns; persist Attachment IDs, never signed URLs.
  - **Matrix:** N/A — no synchronization.
- **Notes for the executor:** Local web/Zod contracts need tracer review even when shared build passes.

### REQ-05 — Preserve save/cleanup consistency `[UNVERIFIED]`

- **Statement:** Trace changed success/error contracts through persistence and cleanup for every existing caller.
- **Surface:** api.
- **Sources:** S1/S6/S9 — `[UNVERIFIED]`, requester/accepted correction — analyze review and preserve post-save cleanup fix.
- **Conflict:** none; historical handling excluded by S9.
- **Open question:** none; Q1 resolved by S9.
- **Ripple:** Generic upload/certificate mutations, note linking, signed fanout races, explicit/parent deletes, replacements; S7 §2/5.
- **Acceptance:** Ledger records validation/S3/DB order, compensation and outcome. Preflight read-only; row/metadata commit consistent; failed-create compensation touches only new objects. Retain existing expected stale-key/storage best-effort handling after save; new-family invalid direct delete rejects. Existing non-ticket delete policy unchanged; unexpected errors propagate.
- **Edges:**
  - **Reached by:** Every explicit/implicit save/replace/delete and generated copy retry.
  - **Does not apply when:** No catch-all BadRequest policy; business validation stays strict. No unrelated transaction/lifecycle redesign, outbox/dependency or historical deletion; D5 consistency refactor remains in scope.
  - **When an input is absent:** Preserve missing-row idempotency; unresolved new owner fails before effects; existing-row behavior unchanged, no historical reconciliation.
  - **Trust boundary:** Resolve concrete row owner before delete; no client key/current-uploader tenant assumption.
  - **Read time:** Per-operation persistence ordering, not a live setting.
  - **Matrix:** N/A — no synchronization.
- **Notes for the executor:** PR1049 upsertAnswer → cleanupReplaced → markSubmitted is the counterexample; independently green happy/reject paths do not cover it.

### REQ-06 — Evidence-based verification `[UNVERIFIED]`

- **Statement:** Plan repeatable module checks and report source inference versus actual runtime evidence honestly.
- **Surface:** all.
- **Sources:** S1/S6/S9 — `[UNVERIFIED]`, requester/accepted correction — reviewed plan and failure reproduction.
- **Conflict:** none; historical handling excluded by S9.
- **Open question:** none; Q1 resolved by S9.
- **Ripple:** Existing suites and module/device/background consumers, §10/S7 §6.
- **Acceptance:** Each family has new key/metadata/read/open/replace/delete checks plus mismatched ownership and before/after-save errors. Fix claims repeat symptom; unavailable role/device/data is NOT CHECKED. No new test cases without request.
- **Edges:**
  - **Reached by:** Construction acceptance, independent analyst/tracer/guardian and cutover.
  - **Does not apply when:** Planning turn: no new-ticket tests/runtime/data/S3 evidence claimed; old ticket PASS cannot certify new modules.
  - **When an input is absent:** Record missing scenario/reason; source review does not substitute for endpoint/device/data evidence.
  - **Trust boundary:** Authorized QA tenant/role and owned fixtures; no secrets in artifacts.
  - **Read time:** Evidence tied to ref/environment/tenant/date, not perpetual plan proof.
  - **Matrix:** N/A — no synchronization.
- **Notes for the executor:** Run existing checks through pnpm nx after implementation instruction; no new tests requested.

## 3. Data model — apps/api/prisma/schema.prisma

- **Schema change required:** no; reuse Attachment and owner relations.
- **Migration required:** no; historical pointer mutation outside scope (S9).
- **Data backfill required:** no; expressly outside scope (S9).
- **Existing models considered:** Attachment (:4637), QuotationSignature (:2058), legacy JobAttachment (:3776), owner/cover/signature/checklist/incident/loadout/meter FKs and JSON note attachmentIds. No new table/column/enum.
- **New/changed models:** N/A — none.

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| Existing owners/Attachment | Feature-dependent; ownership-audit §UUID/code hazards lists schema anchors | Existing, none added | Existing sequences unchanged | REQ-03/S7 |

- **New prefix introduced:** no business code; fixed storage folders only.
- **Child relations:** UUID FKs/onDelete unchanged. Canonical S3 owner is separate from existing featureId; no blanket metadata rewrite.
- **Fields with unspecified precision/type:** N/A — no persisted field added; manifest is an operator artifact.
- **Hard reference registry:** Attachment.fileName; QuotationSignature.signedDocumentUrl; JobAttachment.fileName/fileUrl; discovered direct/JSON/integration/external references and Attachment-ID relations. fileName is not unique; independent new object ownership is required. This descriptive registry does not mandate historical DB/S3 inventory, grouping, reconciliation or deletion work.

### Canonical new storage map — D1; all 21 enum members

Prefix all paths with `tenants/{ownerTenantUUID}/`. `id` is the resolved owner UUID; `f` server file UUID plus sanitized optional extension. Preserve featureId alias conventions and formats. Schema enum :66; detailed lookup fields/anchors S7 ownership-audit §Complete polymorphic feature mapping.

| Feature | Canonical new path / distinct family |
| --- | --- |
| YARD | `yards/{id}/documents/{f}`; resolve yardId code/UUID |
| ASSET | `assets/{id}/documents/{f}`; meter singleton; ambiguous unitCode not sufficient |
| CUSTOMER | `customers/{id}/documents/{f}` |
| CUSTOMER_NOTE | `customers/{id}/notes/{f}`; owner is customer, not note UUID |
| QUOTATION | Existing `quotations/{id}/documents/{f}` and `signed/{fileUUID}.pdf` |
| PROJECT | `projects/{id}/documents/{f}`; generated PDFs `signed/{fileUUID}.pdf` |
| EMPLOYEE | `employees/{id}/documents/{f}`; resolve code/employee/linked User/me+uploader |
| EMPLOYEE_NOTE | `employees/{id}/notes/{f}`; owner employee, not note UUID |
| AGENCY | `agencies/{id}/documents/{f}`; no inferred VENDOR type |
| JOB | Root Job `jobs/{id}/documents/{f}`; generated `signed/{fileUUID}.pdf`; SubJob UUID loadout is separate family below |
| USER | `users/{id}/documents/{f}`; preserve generic capability, profile separate |
| PERMIT | `permits/{id}/documents/{f}`; optional job/asset/vendor is not owner |
| PROJECT_NOTE | `projects/{id}/notes/{f}`; owner project, not note UUID |
| PLAN | `plans/{id}/documents/{f}`; projectId business string not folder UUID |
| TOOL | `tools/{id}/documents/{f}`; preserve generic capability, profile separate |
| PURCHASE_ORDER | `purchase-orders/{id}/documents/{f}`; retain PO-code metadata/status effects |
| CHECKLIST | Existing `job-tickets/{id}/checklist-photos/{photoUUID}/{original,preview}.webp` |
| JOB_TICKET | Existing `job-tickets/{id}/attachments/{photoUUID}/{original,preview}.webp` or `documents/{f}` |
| TICKET_SIGNATURE | Existing `job-tickets/{id}/signatures/{photoUUID}/{original,preview}.webp` |
| TICKET_INCIDENT | Existing `job-tickets/{id}/incident-evidence/...` image/plain layouts and incident FK |
| JOB_WALK | Existing `quotations/{quoteUUID}/job-walks/{reportUUID}/signatures/{f}`; required real quotation owner chain |

Four ticket types stay rejected by generic upload; no historical ticket compatibility restored. Remove invalid-parent flat fallback and dedicated `unknown-quotation` sentinel. Schema JobWalkReport.quotationId is required UUID (:1875); create resolves required quoteNo and update cannot reparent. Missing/mismatched parent rejects preflight, not a new standalone workflow. Historical sentinel rows/access remain unchanged (S9), not automatically moved or failed after saving.

Preserve structured profile `{assets,tools,employees,users}/{id}/profile-pictures/{photoUUID}/{original,thumbnail}.webp` and loadout `projects/{projectUUID}/jobs/{jobUUID}/sub-jobs/{subJobUUID}/{loadout,offload}/{photoUUID}/{original,thumbnail}.webp`. No VENDOR enum or new vendor workflow. Root JOB documents and JOB-feature SubJob photos require distinct resolution.

## 4. API surface — apps/api

- **Pattern:** presentation → usecase → service → orm; P3 only existing photo families.
- **Reuse checked:** S3StorageService key/put/presign/stream helpers, AttachmentsRepository CRUD/deleteWithObjects, employee/quotation-owner resolvers, ticket-image, AttachmentPhotosService, LoadoutPhotosService, JobWalkReportsService compensation, SignedCopyAttachmentsService. S7 exact anchors.
- **New exported functions/services proposed:** extend/reuse tenant-bound owner preparation + typed object-family validation at service/usecase boundaries (D2); no business lookup in raw storage, new module/controller/endpoint or dependency.

| Method | Existing route/operation | Layers | Req |
| --- | --- | --- | --- |
| POST | `/attachments/upload` | AttachmentsController → AttachmentsService → AttachmentsRepository | 02–05 |
| GET | `/attachments`, `/:id/links`, `/:id/download` | Same existing layers; routes/auth retained | 03–04 |
| DELETE/PATCH | `/:id`, expiry/category | Same; reference/PO/certificate effects retained | 03–05 |
| Existing | photos/loadout, job-walk upload/save/clear | Dedicated module services unchanged publicly | 02–06 |
| Existing/internal | quotation signing/master/fanout/conversion, email, meter, public tool cover | Existing scoped services; S7 §2 | 02–06 |

Per endpoint: **Request DTO/response shape:** unchanged, including cover variants/metadata. **Guards/roles:** current route-specific policy, S4 employee-link restriction, explicit tenant in public/background flows. **Route identity:** current code/UUID/me aliases; storage UUID separate. **Errors:** existing auth/not-found/permission behavior; invalid new owner/key preflight rejects before writes using existing bad-request/not-found style; exact new copy NOT SPECIFIED. **Pagination:** unchanged. **Module registration:** reuse providers/barrels; list DI provider sites and boot API if constructors change. No shape change planned; any proposal invokes G5/tracer and same-unit callers.

## 5. Web surface — apps/web

- **Routes:** existing module pages and generic attachment wrappers, S7 §3 Web; no page/layout addition.
- **Existing components to reuse:** current attachment/categorized attachment sections, shared entity-notes editor/grid, entity-photo components, existing download hooks; no new UI, so new-component discovery not needed for this plan.
- **New components proposed:** none.
- **Table:** N/A — no table redesign; existing columns/search/filter props and empty states unchanged.
- **Forms:** unchanged; staged/create uploads must retain valid-owner sequencing; require the existing real quotation owner chain before bytes; no standalone workflow invented.
- **Server state:** existing query keys/invalidation; no new public state shape.
- **Colors/spacing:** N/A — no visual edit; theme-only if an incidental future fix is separately scoped.
- **Responsive:** unchanged; existing touch targets remain.
- **Copy:** no new UI strings specified; no changed test IDs.

## 6. Mobile surface — apps/mobile

- **Screens/routes:** certifications EMPLOYEE upload; quotation attachment/general cards; saved job-walk signatures; source-module job artifacts; ticket/incident/JSA structured siblings (S7 §3 Mobile).
- **Components:** reuse existing attachment-links/openStoredAttachment and field/sales viewers; no new component or image-format conversion.
- **Offline/sync:** preserve attachment IDs, local picks and current retry/share flow. Old cached authenticated generic download URIs remain supported; do not remove generic API route or persist presigned URLs. Historical object availability remains unchanged (S9).
- **Touch targets:** unchanged; 48px rule if future UI changes.
- **Push/notifications:** no new catalog/notify action; retain existing metadata expiry notifications/deep links.

## 7. Shared package — packages/shared

- **Types added/changed:** none planned. EntityImageCover/loadout and attachment metadata shapes unchanged; local web model/mobile Zod contracts need tracing even if shared build passes.
- **Nothing shared:** N/A — shared types are regression consumers, no new shape proposed. Always consume built dist.

## 8. Permissions and tenancy

- **Roles permitted:** existing per-endpoint roles, including public barcode cover and explicit DocuSign/background tenant context; no broader access.
- **Roles denied:** existing denials preserved; S4 employee links owner/admin restriction remains. Different generic download access policy is not silently expanded/narrowed.
- **Tenant isolation:** explicit owner/row tenant predicates before object action; no-context and SUPER_ADMIN bypass ambient extension, so guardian verifies concrete filters. Batch list resolution to avoid per-file query loops.
- **Cross-tenant reads:** no new read authority; existing approved public/background operations must derive exact owner tenant, not omit validation.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| New module owner/key | Resolved tenant+owner UUID; fixed server groups; no traversal or user path/category interpolation | S1/S2; §11b D1–D2 | `[UNVERIFIED]` |
| Existing featureId | Preserve aliases/codes and workflow metadata; separate canonical storage owner | S2/S5; S7 hazards | `[UNVERIFIED]` |
| Uploaded file | Existing size/MIME/category/certificate and safe extension rules retained; no new limit | S1 scope; S4/S5 | `[UNVERIFIED]` |
| FileName/master object | New-family exact segments/owner/variants before access; existing policy unchanged (S9) | S1/S2/S3 | `[UNVERIFIED]`; old behavior unchanged |
| New independent copies | Never share newly owned physical keys across independently deletable attachments/master; existing shared references unchanged | S1/S9; D6 | `[UNVERIFIED]` |
| New arbitrary limits/deadline | NOT SPECIFIED — none invented | No source | — |

## 10. Tests

**New tests/cases: not requested.** Existing fixtures only if required by implementation shape. No new-ticket tests, API/device/data/S3 checks run. S7 §6 lists discovered existing suite families, not passing results; verify exact files before running through pnpm nx.

| Level | Planned evidence | Req |
| --- | --- | --- |
| Existing API/client suites | Generic docs/photos, walks, signed copies, plans/permits/PO, meter/loadout, tickets, notifications and web/mobile contracts. API tests/lint/build, workspace lint/typecheck, affected targets; record cache/baseline | 02–06 |
| Authorized QA | New file per 15 ordinary generic types; valid/invalid walk parent; generated PROJECT/JOB copies; PO close/reopen, certificates/notes; same/cross-tenant mismatch; S3 and retained API consumers | 02–06 |
| Lifecycle | Failure before/after save; expected stale cleanup retention versus strict delete; independent signed-copy/shared-reference safety | 03/05/06 |

No open requirement remains; historical migration/deletion has no acceptance stage in this plan. Unavailable roles/device/data are NOT CHECKED; earlier ticket emulator PASS cannot certify this ticket.

## 11. Non-functional

- **Performance:** batch alias resolution for lists; use existing presign TTL/caching; no new latency/cap invented. Historical inventory is out of scope.
- **Concurrency:** immutable storage owner UUID; new object IDs server-generated; per-target signed-copy dedup/loser cleanup and preflight/commit race rechecks retained. Historical pointer mutation excluded (S9).
- **Audit/activity log:** existing file upload/delete/certificate/PO/notification behavior preserved. Manifest/error reports contain IDs/key ownership without secrets or presigned credentials.
- **Migration/rollout order:** planning → explicit implementation instruction → new writers/validated new families with consumer compatibility → existing checks/runtime → authorized release. Existing-file access stays unchanged; no historical rollout, migration or deletion stage. Release date/environment NOT SPECIFIED.

## 11a. Ripple — already-shipped behavior

Baseline application `fa83fe40f` (staging before planning branch), not merely PR1049 head. S7 code-review §§1–3 and ownership-audit carry commands/exact anchors, read during elaboration. Enumeration: `rg -n 'buildKey\(' apps/api/src --glob '!*.spec.ts'`; all put/sign/stream/delete and SDK operations; literal routes on both clients; wrapper/metadata/shared-type/lifecycle passes. Search-hit counts are not independent consumers.

| Existing consumer | Reached via / enumeration | Req | Disposition and source |
| --- | --- | --- | --- |
| Generic upload/create/list | controller :173–242/service; S7 §2 | 02–05 | Structured new paths, readonly preflight then metadata+row consistency; S1/S5 |
| Generic links/stream/delete | controller :259–357; S7 §2 | 03–05 | Routes/auth retained, validation for newly introduced keys; old policy unchanged (S9); S1/S4 |
| Signed PROJECT/JOB fanout/conversion | signed-copy :123–195/projects call sites; S7 §2 | 02–05 | Independent UUID target objects, code metadata/dedup unchanged; S1/S2 |
| Master document/direct stores | signed-copy :68,116,232–279/signature field, JobAttachment; ownership registry | 03/05 | Separate master owner, new-object isolation; old references unchanged (S9); S1/S2 |
| Plan/quotation email/envelope | plans :897/909; quotation-signatures :1276–1384; S7 §2 | 03–05 | Validate direct byte-read owners, preserve send behavior; S1 |
| Job-walk save/replace/clear | service :258–336; S7 §2 | 02–05 | Required quotation UUID, invalid-parent preflight rejection; safe cleanup order; S1/S2/S6 |
| Meter/public tool cover | assets :659/677/761/public-tools :40/48; S7 §2 | 03–05 | Asset singleton/tool profile family, authoritative owner tenant; S1 |
| Profiles/owner delete | attachment-photos and assets/tools repos; S7 §2 | 03–06 | Existing variants/after-commit cleanup retained; S1 |
| Sub-job loadout/offload | loadout-photos/sub-job-image; S7 §2 | 03–06 | Exact owner chain, carry-forward/linked guards retained; S1 |
| Strict tickets +4 post-save callers | ticket-image/guard; S7 §5 | 03–06 | No restored flat access/field stream; D7 retained; S3/S6 |
| Notes/certificates/PO lifecycle | note IDs, create/delete, PO :1030–1067; ownership hazards | 03–05 | Parent-code metadata, Attachment IDs/expiry and invoice close/reopen retained; S1/S5 |
| Expiry/deeplink metadata | scheduled jobs :295/318/346; S7 background | 03–04 | No new bytes/list crashes/alias route changes; S1 |
| Web wrappers/module callers | attachments API/entity-photos, hooks/notes/forms/quote-signing; S7 §3 Web four-pass closure | 04/06 | Existing IDs/shapes/routes/test IDs, opaque new keys; S1 |
| Mobile upload/viewers/artifacts | certifications/quotation/walk HTTP, attachment-links, old draft URI lib; S7 §3 Mobile | 04/06 | Direct S3 + existing API compatibility; source artifact stays source-owned; S1/S4/S5 |
| Shared/local schemas | shared covers, local web Attachment/mobile Zod; S7 shared pass | 04/06 | Shapes unchanged; shared build alone insufficient; S1 |

No new page/workflow/VENDOR feature. Ordinary quotation conversion copies zero arbitrary attachments (projects.service:473); no new copy workflow. Historical flat/noncanonical/shared references are outside handling scope and retain existing access (S9); actual data/external coverage NOT CHECKED. S7's complete lists are part of this spec's inventory, not optional examples.

## 11b. AI decisions — developer review

| ID | Decision | Chosen / rationale; rejected alternative | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- |
| D1 | Paths | §3 map: immutable direct-owner UUID, fixed document/note/signed groups; reject code/optional-association folders | no | Muazzam | 2026-11-06 |
| D2 | Owner/family dispatch | Reuse aliases and existing family validators; new-family typed checks, batch reads; no raw-storage DB lookup/new-write flat default; no old-row policy tightening | G3 guardian | Muazzam | 2026-11-06 |
| D3 | Metadata | Storage UUID separate from featureId; preserve PO/job/note codes, list/dedup/notification aliases; no blanket rewrite | no | Muazzam | 2026-11-06 |
| D4 | Job walk/staging | Required real quotation UUID via schema/create; reject inconsistent parent before bytes, remove flat/sentinel branches. Existing owner-create-before-upload; no standalone walk/synthetic parent | no | Muazzam | 2026-11-06 |
| D5 | Failure order | Readonly preflight; consistent metadata+row commit; failed creation cleans only new objects, original error retained. Expected post-save cleanup failure logs/retains, no catch-all | no | Muazzam | 2026-11-06 |
| D6 | Copy/reference ownership | Independent new signed objects/master; no new shared-key lifecycles. Existing shared objects/references/access unchanged; no historical rewrite/delete | no | Muazzam | 2026-11-06 |
| D7 | History | S9 excludes migration/backfill/availability retirement; preserve current non-ticket access and already-strict ticket refusal | no — requester answered | Muazzam | 2026-11-06 |
| D8 | Folder deletion | Out of scope, not an executable or blocked later stage; new-writer completion does not establish prefix deletion safety | no — excluded | Muazzam | 2026-11-06 |
| D9 | Interfaces | No schema/dependency/DTO/route changes, preserve formats and transports; reject global stream removal/photo conversion | no | Muazzam | 2026-11-06 |
| D10 | Generic JOB upload owner | Only a Job resolves (the job code in practice: the editability check looks up `jobId`, so a Job UUID also 404s, as the old create did); a sub-job UUID returns 404 "Job not found" before bytes. No web/mobile caller found; sub-job photos use their own routes. Rejected: filing sub-job files under the job folder (no canonical path) | no | Muazzam | 2026-11-06 |
| D11 | EMPLOYEE_NOTE `me` | `me` is an EMPLOYEE-documents alias; a note needs an explicit employee code, `me` returns 404. Web notes tab sends the employee code | no | Muazzam | 2026-11-06 |
| D12 | Error copy | "<Thing> not found", 400 "Invalid attachment storage key", 400 "Job walk report has no valid quotation": existing bad-request style, wording NOT SPECIFIED by any source | no | Muazzam | 2026-11-06 |
| D13 | Staged web uploads | Owner must exist before bytes. Web create flows for plans, assets and permits upload after create (read 2026-11-06); other families to be confirmed in the UI pass | no | Muazzam | 2026-11-06 |
| D14 | Signed copy, cross-tenant target | A project/job in another tenant than the signature rejects the whole filing before any write. Alternative (skip only that target) rejected: data-corruption case, loud is safer | no | Muazzam | 2026-11-06 |
| D15 | Code rename exposure | New-layout ownership checks resolve the owner by the row's `featureId` code; a post-filing code rename would 400 on that file. Employee codes ARE renamed (`renameEmployeeCodeWithReferences` repoints EMPLOYEE/EMPLOYEE_NOTE featureIds, and EMPLOYEE rows store the UUID, so they stay valid). No rename path was found for the other types (not checked exhaustively); accepted | no | Muazzam | 2026-11-06 |
| D16 | Job-walk keys on direct access | **Dropped from U3.** Existing job-walk-layout rows keep unchanged links/download/delete/expiry (D2, D7, S9: no old-row tightening). The owner check stays only on the post-save stale-replacement cleanup (PR #1049 lesson) | no | Muazzam | 2026-11-06 |
| D17 | Review fixes and `buildKey` | `tcg-analyst` verdicts: U1 PASS WITH FINDINGS, U2 PASS, U3 PASS WITH FINDINGS. Fixed in commit `21a5cdcf8`: key-owner dedup (F1), explicit tenant on upload-preflight reads and expiry updates (F2), dead wrapper removed. Flat `S3StorageService.buildKey` removed (no callers; follows the U3 slice row); its one existing test removed with it. Stale `buildKey` mocks in other existing specs left alone | no | Muazzam (delegated: best option) | 2026-11-06 |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Reviewed by | Enumerated by |
| --- | --- | --- | --- | --- |
| All 15 ordinary generic types | Generic attachments | Planned module-owner new writes together; notes and sparse USER/TOOL capability included | | Enum + S7 writer search |
| Quotation/job-walk + generated project/job copies | Existing scoped document builder | Retain quotation paths; reject invalid-parent/sentinel before writes; fix flat fanout writers; do not duplicate masters | | S7 §1/2 |
| Entity profiles ASSET/TOOL/EMPLOYEE/USER | P3 | Structured paths unchanged; recognize family at generic access/public cover boundaries | | S7 storage/four-pass |
| JOB sub-job loadout/offload | Existing variant shape | Preserve path/variants/linked reference guard; classify separately from Job documents | | S7 §2 |
| Ticket 4 feature families | Strict ticket shape | No new storage migration; regression checks preserve no-flat and D7 behavior | | S3/S6; S7 §5 |
| Historical module keys | Prior compatibility | Unchanged; no migration/backfill/retirement/deletion stage | | S9/S2/S5 |

## 12. Open questions — stop-and-ask list

### Q1 — Historical non-ticket attachment disposition (G1/G2)

- **Question:** For existing non-ticket files in the generic prefix, should the plan preserve access by migrating them, retire historical access, or compare both approaches before selection?
- **Options:** A. Preserve access and plan migration. B. Retire historical access explicitly. C. Plan both alternatives before deciding. X. Other — say what.
- **Answer:** “No need to handle historical files or retire their availability.” — requester in current conversation, 2026-11-06; identity not inferred. Recorded in S9.
- **Why it initially could not be answered:** Original planning request did not select historical disposition; S2 preservation and S3 ticket-only retirement could not answer globally. Requester now explicitly excludes historical handling/availability retirement (S9).
- **Blocked:** none remaining. Former REQ-07/08 historical alternatives removed, not carried as blocked stages. Current request still authorizes planning only.
- **Candidates:** S2 decision (2,733 bytes, 2026-11-04), S3 decision (4,355 bytes, 2026-11-05), S5 metadata note (1,519 bytes, 2026-11-03); consulted module indexes/stubs and admin/tcg-documents (2,277 bytes, updated 2026-07-08) do not supply global policy. Vault README §What this vault does not contain identifies deliberate personnel exclusions, not a hidden storage-retirement decision.
- **Owner:** Requesting developer/product-data owner; personal name/retention authority NOT ON TICKET.
- **Workaround, if any:** N/A — resolved. New uploads/generated files only; preserve existing access and strict ticket policy.
- **Status:** resolved — see decisions/2026-11-06-module-scoped-attachment-storage.md.

## 13. Deliberate exclusions / unspecified details

S9 explicitly excludes historical migration/backfill/key or metadata rewrite, historical availability retirement and physical folder/prefix deletion. These are not blocked later stages of this plan. Existing historical reads/deletes and previously strict ticket behavior remain unchanged. No new role/workflow/retention rule, public URL, global streaming removal, forced image conversion, schema/dependency or test cases. New structured keys may receive exact-family validation without applying a new global rejection rule to old non-ticket objects. Release date/environment NOT SPECIFIED. Module business conflicts remain unresolved/outside scope. Existing-row audit observations do not authorize hiding/deleting records or failure after saving.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person — none `[OPEN]`; Q1 answered by the requester (S9), identity not supplied
- [x] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — N/A, no requirement is `[CONFLICT]`; the three module conflict stubs are not selected here (§0)
- [x] Answers written back into `spec.md` with their new sources and flags — S9 `[UNVERIFIED]`, cited by REQ-01–06, §12 Q1, §13
- [x] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md` — Q1 → `decisions/2026-11-06-module-scoped-attachment-storage.md`
- [x] Every requirement's **Edges** fields are filled (`ASSUMED` allowed) or point at a §12 question — REQ-01–06
- [x] Every §11a ripple row has a source for what happens to that consumer, or a §12 question — 15 rows, each cites S-sources
- [x] A developer has reviewed §11b and §11c (_Reviewed by_), and answered every `needs developer` row — Muazzam, 2026-11-06: D1–D9 accepted as written, including D2 (G3) and the D7/D8 consequence that existing flat-prefix files remain and prefix deletion needs separate handling
- [x] Decomposed into vertical units — `units.md` (U1–U3, 6/6 requirements allocated)

Answered by: requester (Q1 only; identity not supplied) · Date: 2026-11-06
Developer sign-off: Muazzam · Date: 2026-11-06 — build authorized: one branch, one commit per unit, base `origin/staging`.
