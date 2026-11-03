# Spec — complete mobile presigned file reads and attachment consistency

Updated 2026-11-03. Path A continuation, no external ticket. This supersedes the metadata-only scope and restores the missing presigned-read delivery. Archived presigned-read-spec.md remains historical. Metadata code 1d439ae58 is completed baseline, not proof that read migration is complete.

## 0. Provenance

- **S1 [REFERENCE], kind: requester direction:** intent.md §3 quotes the latest explicit instruction to add missing work, run all AI-DLC phases and implement. The preceding conversation names quotation files, certification documents, job-walk signatures and incident files. This is developer/requester direction, not adjudication of TCG business conflicts.
- **S2 [REFERENCE], kind: decision:** decisions/2026-11-03-mobile-remaining-presigned-files-scope.md records GET viewing/downloads, current uploads retained, no external ticket, quotation open/share included. Its former planning-only restriction is superseded by S1.
- **S3 [REFERENCE], kind: decision:** decisions/2026-11-03-mobile-upload-attachment-metadata-consistency.md records all-upload UUID/type/category direction. Its former metadata-only exclusion is superseded by S1.
- **S4 [UNVERIFIED], kind: prior spec:** .ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md covers signed ticket/checklist images. Existing implementation is evidence of current state only.
- **S5 [REFERENCE], kind: decision:** decisions/2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md records existing incident MIME behavior and formerly deferred viewer. S1 now includes saved incident-file viewing; reporting workflow/MIME rules are retained.

Rules consulted: AGENTS.md; contexts/api.md (layers/auth), mobile.md (tokens/touch targets), prisma.md (conditional tenant extension), patterns.md P3 (presigned links/no Authorization). Vault INDEX, field-ops/INDEX, field-ops-mobile-INDEX and quotations-INDEX consulted. Their unresolved workflow conflicts are not selected or merged; no payroll, quotation pricing/lifecycle or incident eligibility requirement is derived from them. No Jira lookup applies.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Retain consistent attachment metadata | api/mobile | REFERENCE | S1/S3 | No; completed baseline |
| REQ-02 | Linked job documents signed open/share | api/mobile | REFERENCE | S1/S2 | No |
| REQ-03 | Both quotation cards signed open/share | api/mobile | REFERENCE | S1/S2 | No |
| REQ-04 | Saved certification and job-walk signature reads | api/mobile | REFERENCE | S1 | No |
| REQ-05 | Saved JSA signed rendering | mobile | UNVERIFIED | S1/S4 | No |
| REQ-06 | Saved incident evidence/signature reads | mobile/api as needed | REFERENCE | S1/S5 | No |

Six sourced requirements; zero OPEN/CONFLICT requirements in this read/metadata scope. Reference tags reflect actual recorded requester direction; none is promoted to verified client business intent.

## 2. Requirements

### REQ-01 — Attachment ownership/type/category consistency [REFERENCE]

- **Statement:** Every audited mobile binary upload persists the owning resource UUID in feature_id with appropriate feature_type/category; preserve the completed metadata implementation.
- **Surface:** API/mobile.
- **Sources:** S1/S3 [REFERENCE], kind: requester/decision.
- **Conflict / Open question:** none.
- **Ripple:** All nine upload producers in plan.md; certificate readers, generic employee/quotation readers, logs/notification routes, quotation Won/Signed evidence and job-walk signature FKs stay compatible. Source S1/S3; enumeration `rg -n 'FormData|multipart|uploadSignature|uploadAttachment' apps/mobile`.
- **Acceptance:** New EMPLOYEE/QUOTATION/JOB_WALK rows use tenant-resolved UUID owners. Existing precise categories remain; general files never become PLAN_OR_DOC/profile photos automatically. Ticket incident files retain ticket UUID plus incidentReportId. Old UUID/code/User-ID aliases remain usable; literal me is uploader-scoped. No backfill.
- **Edges:** Reached on upload/link; local staged files have no saved row yet; invalid owner fails before S3 write; trust boundary is explicit tenant/parent resolution; write-time canonical metadata; synchronization matrix N/A.
- **Executor note:** Completed in 1d439ae58; run regression checks and preserve it while adding reads.

### REQ-02 — Linked job documents signed open/share [REFERENCE]

- **Statement:** Open/share ticket-linked permit, plan and purchase-order files using API-issued presigned GET links as the primary path.
- **Surface:** API/mobile.
- **Sources:** S1/S2 [REFERENCE], kind: requester/decision.
- **Conflict / Open question:** none.
- **Ripple:** job-artifacts-section, artifact HTTP/contract and authorized field-ticket artifact service migrate together; old fields/byte endpoints remain compatible (S1/S2). Enumeration `rg -n 'jobArtifacts|downloadAttachment' apps/mobile apps/api/src`.
- **Acceptance:** All three document kinds open/share with expected name/MIME using signed S3 requests without API bearer headers. Do not route normal new reads through API arraybuffer streaming.
- **Edges:** Reached from ticket details; no document retains existing empty state; missing/expired link refreshes signed metadata or existing compatibility fallback (technical assumption D3); retain crew-filtered artifact listing and require explicit tenant on the generic signed-link read; links generated at read-time, never persisted; sync matrix N/A.
- **Executor note:** Reuse existing native file opener and signer.

### REQ-03 — Both quotation attachment cards signed open/share [REFERENCE]

- **Statement:** Saved general quotation attachments and Plans & Documents expose signed open/share actions.
- **Surface:** API/mobile.
- **Sources:** S1/S2 [REFERENCE], kind: requester/decision.
- **Conflict / Open question:** none.
- **Ripple:** Both cards and their common file service change; upload/list/delete, PLAN_OR_DOC/WON_EVIDENCE distinction and web callers remain compatible (S1/S2). Enumeration `rg -n 'quotationAttachments|/attachments' apps/mobile/data apps/mobile/components/sales apps/web/src/features/attachments`.
- **Acceptance:** Every saved row in either card can open/share via an authorized signed URL, correct filename/MIME. Quotation-create wizard files remain device-local until save; no remote URL is required for unsaved picks. Do not relabel general attachments.
- **Edges:** Reached from either detail card; empty list has no file action; missing/expired link refreshes or shows existing file error; require explicit attachment tenant and preserve existing generic download access policy; read-time links stay out of persisted draft/store; sync matrix N/A.
- **Executor note:** On-demand authorized attachment links can preserve list response shapes; contract tracer decides exact shared shape with executor.

### REQ-04 — Saved certification documents and job-walk signatures [REFERENCE]

- **Statement:** Users can open saved certification documents and view/open saved operator/foreman job-walk signatures through signed GET links, including after leaving/reopening the quotation detail.
- **Surface:** API/mobile.
- **Sources:** S1 [REFERENCE], kind: requester direction; explicitly includes the previously missing saved-file surfaces.
- **Conflict / Open question:** none; no certification approval or signature workflow change.
- **Ripple:** certifications contracts/list/detail UI and a read-only saved job-walk signature list on the quotation Attachments tab receive attachment references/read actions; upload endpoints and local SignaturePad capture remain compatible (S1/S2). Enumeration `rg -n 'attachmentId|SignatureAttachmentId|signature' apps/mobile/data/contracts/certifications.contract.ts apps/mobile/app/\(field\)/menu/certifications.tsx apps/mobile/app/\(sales\)/job-walk.tsx apps/mobile/features/sales/job-walk-report.mapper.ts`.
- **Acceptance:** Open an existing certification attachment when present; a certification with no document offers no broken file action. Both saved signature roles remain visible/openable from saved reports loaded through existing list(quoteNo); a fresh local signature still previews locally and uploads through its existing endpoint. No new edit workflow or signature clearing semantics. Distinguish certification entity IDs from Attachment IDs. Use actual employee/report attachment references; signed-link reads require explicit tenant and preserve existing generic download access policy. Old alias ownership remains readable.
- **Edges:** Reached through existing certification/job-walk screens; no saved attachment retains empty/local capture state; invalid/missing saved attachment returns existing not-found behavior; trust boundary is explicit attachment tenant plus existing authenticated download policy; links are transient on-demand; sync matrix N/A.
- **Executor note:** Reuse native opener/AttachmentImage; do not save signed URLs in persisted job-walk draft or replace vector capture semantics.

### REQ-05 — Saved JSA image/signature rendering [UNVERIFIED]

- **Statement:** Saved JSA photos/signatures render returned signed covers while local capture keeps its current behavior.
- **Surface:** Mobile.
- **Sources:** S1 [REFERENCE], kind: requester; S4 [UNVERIFIED], kind: prior spec.
- **Conflict / Open question:** none; no JSA answer/sign-off workflow selected.
- **Ripple:** compose-ticket-detail, checklist-rehydrate, JsaBody and JsaSignatureModal preserve answers, attachment IDs and local capture while supplying live covers (S1/S4). Enumeration `rg -n 'photoImage|signatureImage|checklist-rehydrate' apps/mobile`.
- **Acceptance:** Reopening a saved JSA shows remote photo/signature covers; image expiry refreshes the source query; local captured URI still previews. Do not persist signed links in drafts or construct new authenticated download previews.
- **Edges:** Saved checklist read only; no attachment retains current empty state; local URI takes precedence (ASSUMED from existing capture semantics); trust API-authorized covers; read-time query metadata overlays persisted answer/ID; sync matrix N/A.
- **Executor note:** Reuse AttachmentImage and existing pre/post-trip pattern.

### REQ-06 — Saved incident evidence/signature reads [REFERENCE]

- **Statement:** Existing incident records expose their saved evidence files/images and customer signature through the presigned metadata already returned by the incident API.
- **Surface:** Mobile/API only if gaps found.
- **Sources:** S1/S5 [REFERENCE], kind: requester/decision; S1 supersedes the historical no-viewer exclusion only for saved-file viewing.
- **Conflict / Open question:** none; no incident submission/status/permission or MIME rule change.
- **Ripple:** Existing incident sheet/report hook/contracts reuse signed images/files/signatureImage; preserve local evidence capture, submission and server MIME processing (S1/S5). Enumeration `rg -n 'useTicketIncidents|signatureImage|images|files' apps/mobile/features/field-ticket/incident-sheet.tsx apps/mobile/features/field-ticket/use-incident-report.ts apps/mobile/data/contracts/ticket-incident.contract.ts`.
- **Acceptance:** Previously saved incident evidence and signature can be viewed/opened from the existing incident context, using returned image covers/file URLs without bearer headers; already-working viewer behavior is reused. Non-image video remains a file, not forced through image decoding. No attachment is exposed beyond existing ticket/incident access.
- **Edges:** Reached from existing incident context; no reports/files retains empty state; expired image links refresh authorized query; failed file link refreshes or reports existing error; links remain transient; sync matrix N/A.
- **Executor note:** Verify actual runtime consumers; schema support alone is not completion.

## 3. Data model

Existing Attachment and owner/relation tables are sufficient. No new model, code prefix, schema field, migration, object move or backfill. Maintain existing image cover shape and signature attachment FKs. S3 URLs are response metadata, never stored data. Server-generated signed-copy writers remain the prior documented separate follow-up; this continuation does not rewrite those rows.

## 4. API surface

Reuse S3StorageService.presignGetUrl/presignDownloadUrl and existing feature listings. Preferred technical choice: an authenticated GET /attachments/:id/links endpoint for new saved-file opens, explicitly scoped by attachment tenant and the existing authorized download boundary, reused across quotation/certification/job-walk. Preserve existing download routes and list response fields. Use GET /attachments/:id/links on demand for artifacts too, retaining the existing artifact response and its crew-access boundary. Certification responses add a distinct attachmentId independent of polymorphic certification IDs; incident/checklist covers already exist. Update all affected callers/types/parsers in the same unit. No client-supplied S3 keys. Sign legacy server-held flat keys without rewriting them. Existing guards/module access remain; raw attachment UUID never bypasses authentication or explicit tenant checks. Constructor/module changes require API boot validation.

## 5. Web surface

No unrelated UI/transport conversion. Trace generic download/list, quote detail and shared exported shapes; preserve old routes/fields and metadata behavior. Web generic blob conversion remains separate.

## 6. Mobile surface

Existing ticket job-artifacts, both quotation cards, certifications screen, read-only saved job-walk signatures list on the quotation Attachments tab, JSA and incident context. Reuse StyleSheet/tokens, AttachmentImage and native opener with existing dependencies; touch targets at least 48px. Preserve local captures, multipart queues/drafts and offline fallback. No new offline downloaded-file library; signed URLs never enter persisted stores. No API auth headers on S3. Opening and sharing use existing platform file helper behavior; no new universal embedded document editor.

## 7. Shared package

Reuse EntityImageCover; no shared export expected. If a type is shared, tracer enumerates API/web/mobile consumers and build dist before consumers. No dependency change.

## 8. Permissions and tenancy

Explicit attachment tenant authorization before signing; preserve the current attachment download access policy and feature-specific list visibility; tenant extension is conditional and insufficient on its own. Employee certification and job-walk/quotation/ticket listings keep existing visibility. The generic links endpoint deliberately matches existing tenant-wide authenticated byte-download access; it does not invent parent role/permission policy. Ticket artifact listing remains crew-filtered; incident query retains existing access. Guardian must review tenant data access (G3). No G2 destructive operation or new tenant model.

## 9. Validation rules

Only saved authorized attachment IDs are accepted; certification record IDs are not assumed attachment IDs. Preserve existing MIME/size/category and signed-link TTL configuration. Handle missing/deleted files with current error conventions. S3 signatures use stored keys and never user text. Preserve legacy alias-read predicates including uploader-scoped me rows.

## 10. Tests

New tests: not requested. Run existing affected API suites, mobile helper/card/certification/job-walk/checklist/incident suites, mobile typecheck, API/mobile lint and API/shared builds via pnpm nx. Contract changes also trigger affected web checks. Existing baseline mobile failures from publication.md remain evidence; every new failure is triaged rather than assumed baseline. Manual device/S3/expiry/cross-tenant checks must be explicitly marked performed or unavailable. No runtime success claim from mocked tests alone.

## 11. Non-functional

No new performance threshold; avoid per-row network calls just to list filenames; obtain signed links on demand or in existing batched responses. API-first additive rollout supports older clients; keep existing byte endpoints as compatibility paths rather than primary new mobile reads. No direct-S3 upload, lifecycle/pay rules, data rewrite or new dependency.

## 11a. Ripple — existing consumers

REQ-01 retains nine-upload metadata producers and activity/notification/evidence consumers. REQ-02 reaches artifact UI/service/contract. REQ-03 reaches both quotation cards/common API and web compatibility. REQ-04 reaches certification saved-file identity and read-only saved job-walk role list on the quotation Attachments tab. REQ-05 reaches JSA compose/rehydration/render/modal. REQ-06 reaches incident sheet/hook/response consumer. Existing ticket sheet/file opener and pre/post-trip/profile image consumers must preserve behavior when reused. Enumeration commands are recorded per requirement; audit.md contains historical paths. No missing product disposition found: migrate remaining readers, preserve existing mutations/access/lifecycle, as authorized by S1/S2. Tracer re-enumerates actual changed response shapes before execution completes.

## 11b. AI decisions — developer review record

| ID | Decision | Chosen / rationale | Guardrail / review |
| --- | --- | --- | --- |
| D1 | New file-read boundary | GET /attachments/:id/links for on-demand saved-file actions, including artifacts; explicit tenant check on server-held rows and existing download authorization policy; retain generic list/byte routes | G3 guardian, G5 contract tracer before completion |
| D2 | Image/file reuse | Existing AttachmentImage/native opener and S3 signer; image covers for rendering, original/download URL for opening | No dependency; executor records exact shape |
| D3 | Link lifetime/fallback | Imperative transient on-demand links, refresh once on failure; retain old byte endpoints for compatibility | Technical assumption from existing ticket helper; no new offline promise |
| D4 | Local/saved parity | Local capture URI/strokes remain; job-walk saved signatures are a read-only role list from existing list(quoteNo), with no new edit/clear behavior; never persist signed URLs | Existing draft/store patterns; tracer verifies mapper |
| D5 | Metadata scope | Preserve 1d439ae58 and all nine upload mappings; no backfill or schema change | S1/S3; no G2 |
| D6 | Incident scope override | Saved-file viewing now included, reuse existing incident context; preserve reporting/MIME business behavior | S1 supersedes earlier viewer deferral; not a workflow redesign |

Additional reviewed implementation choices:

| Decision | Chosen | Reason / alternatives |
| --- | --- | --- |
| Signed wire payload | `{id, originalName, mimeType, url, previewUrl?}` | On-demand service validates it; existing metadata/byte contracts stay unchanged |
| Inline preview formats | JPEG, PNG, WebP, GIF, HEIC, HEIF only | Excludes active SVG/HTML; download URL always forces attachment/octet-stream |
| Certification file association | Latest employee-owned upload by createdAt, then UUID tie-break within existing normalized-name group | Credential entity ID/status/expiry dedup stays unchanged; do not mistake credential UUID for file UUID |
| Retry boundary | Separate signed download from native sharing; refresh links and retry download once | Sharing errors/cancellation never trigger a second native share |
| Saved job-walk entry point | Read-only saved role list on quotation Attachments tab using existing report list API | Makes both saved signatures reachable without introducing edit/clear behavior |
| Incident refresh | Invalidate the ticket incident query after each successful evidence upload | Existing created-report cache precedes uploads; new viewer must see completed evidence |

## 11c. Siblings

Permit/plan/PO migrate together; both quotation cards migrate together; both job-walk signature roles migrate together; certification rows with and without document references handled together; saved JSA image/signature parity with pre/post-trip; incident images/files/signature use existing signed response fields. Ticket/profile/entity-photo flows already signed are regression targets. Local wizard picks/captures need no remote URL before upload. Unrelated web blob downloads and generated-document metadata are separate follow-ups, not hidden mobile streaming exemptions. Enumerate with `rg -n 'responseType|arraybuffer|downloadAttachment|openAttachmentFromUrl|AttachmentImage|FormData' apps/mobile` and review each remaining match as migrated/already-signed/local/compatibility-only.

## 12. Questions and scope answers

All resolved by requester in intent.md §3: GET viewing/downloads only, retain uploads; no ticket; include both quotation cards' open/share; preserve UUID/type/category consistency; latest instruction explicitly authorizes missing-work implementation and all AI-DLC phases. Saved certification/job-walk/incident reads are now included; older exclusions are superseded. No outstanding G1 question. Endpoint/type/reuse choices are AI decisions subject to guardian/tracer review, not repeated permission questions.

## 13. Deliberately unspecified

No direct S3 PUT, backfill, schema/dependency addition, expanded role matrix, certification approval, quotation lifecycle, incident workflow redesign, universal embedded viewer or unrelated web conversion. No new copy/design requirement beyond existing controls/error conventions.

## 14. Sign-off before build

- [x] Explicit implementation request received, latest conversation instruction recorded in intent.
- [x] No OPEN/CONFLICT requirement in this scope; previous restrictions superseded explicitly.
- [x] Metadata baseline versus missing work distinguished; edges/ripple/siblings recorded.
- [ ] Units prepared by decomposer; guardian/tracer reviews and final implementation analysis recorded by responsible agents.
- [ ] Existing checks and available runtime verification completed; limitations recorded.

Elaborator delivered intent/spec only. Build/analysis/reflection status belongs in state.md, units and review records; this specification does not claim implementation of the continuation.
