# Spec — MOBILE-TICKET-STRICT-S3: strict ticket attachment hierarchy

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `MOBILE-TICKET-STRICT-S3` — local identifier; external Jira id NOT ON TICKET |
| Intent | `.ai/aidlc/MOBILE-TICKET-STRICT-S3/intent.md`, captured 2026-11-05 from the current developer request |
| Elaborated on | 2026-11-05 by tcg-elaborator |
| Vault state at elaboration | Root index and field-ops index/conflict stub consulted by section. Field-ops' three competing product documents remain unverified and unresolved; this technical request does not choose among them. |
| Open questions raised by this spec | none |
| Already-shipped behaviour reached | 10 consumer groups in §11a; none lacks a source for its scoped disposition; inception trace added generic read and incident plain-evidence entry points |
| Rules consulted | Root AGENTS.md; `.ai/claude/contexts/api.md` §§Layers, Auth and access control, Tenancy, Testing; `mobile.md` §§Structure, Tokens and secrets, Product intent; `patterns.md` §P3; AI-DLC elaborator and template |

**Source convention.** Source S is `decisions/2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md` (`[VERIFIED]`, kind: decision), the durable record of the current developer's explicit technical direction, captured in `intent.md` §§3–5. Its vault status is **reference**, not a verified TCG product ruling. The flag means the requester has expressly decided this task's behavior; it does not promote any field-ops source. No Jira issue was supplied, so no live issue was fetched or invented. Provisional uncommitted code is implementation evidence only, never a requirement source.

The historical migration's D5/Q3 flat-image fallback and D9 field-ticket streaming fallback are superseded for this task by S. No backfill is introduced. UUID/ticketCode ownership matching is a separate identity compatibility concern and stays in scope only as a constraint to preserve.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Structured uploads are mandatory | api | `[VERIFIED]` | S, intent §4 | no |
| REQ-02 | Ticket images always have two structured variants | api | `[VERIFIED]` | S, intent §§3–4 | no |
| REQ-03 | Plain ticket files stay in their structured hierarchy | api | `[VERIFIED]` | S, intent §§3–4 | no |
| REQ-04 | Retire ticket-scoped API streaming | api, mobile | `[VERIFIED]` | S, intent §4 | no |
| REQ-05 | Mobile refreshes and opens directly from S3 | mobile | `[VERIFIED]` | S, intent §4 | no |

Counts: 5 total — 5 verified requester directions, 0 unverified, 0 conflicted, 0 open.

## 2. Requirements

### REQ-01 — Structured uploads are mandatory `[VERIFIED]`

- **Statement:** Every ticket upload requires image or plain-file configuration and stores objects in the resolved ticket's structured S3 hierarchy; no ticket upload writes a flat `tenants/{tenantId}/attachments/{uuid}{ext}` object.
- **Surface:** api.
- **Sources:** `decisions/2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md` — `[VERIFIED]` — kind: decision — mandates configuration and retires flat storage; `intent.md` §3 acceptance 1 and §4 capture the same explicit request.
- **Conflict:** none for this technical instruction; old D5/Q3 compatibility is explicitly superseded by S. Broader field-ops conflict remains outside the decision.
- **Open question:** none.
- **Ripple:** Shared guard callers in signatures, lunch breaks, checklists, incidents and Attach File all must provide structured configuration. Generic upload must not bypass the ticket requirement. Enumerated by C1/C3 in §11a; disposition follows S's “Ticket uploads require image or plain-file storage configuration” and acceptance 1.
- **Acceptance:** `storeFlatObject` is absent; absent configuration rejects before persistence. Each ticket-producing upload path either supplies structured configuration or refuses the upload. The old flat key builder is unreachable for ticket feature types.
- **Edges:**
  - **Reached by:** `TicketAttachmentGuardService.storeUpload`; all five existing ticket upload callers; generic `POST /attachments` when submitted a ticket feature type.
  - **Does not apply when:** Non-ticket uploads and entity/profile photos: S's Boundaries preserves unrelated flows. Do not globally remove the generic storage builder.
  - **When an input is absent:** Neither configuration present → reject (`BadRequestException` is explicitly allowed by the request). Existing required-file handling remains.
  - **Trust boundary:** Filename/MIME and configuration enter from callers; resolved tenant/ticket identity is authoritative. Generated UUIDs/fixed folders and the existing sanitized extension builder produce keys.
  - **Read time:** N/A — upload behavior.
  - **Matrix:** N/A — no mirror/sync requirement.
- **Notes for the executor:** Reuse existing image processing and `buildTicketFileKey`, retain upload idempotency and cleanup. Record guard and generic-route implementation choices in §11b. Do not add a dependency.

### REQ-02 — Ticket images always have two structured variants `[VERIFIED]`

- **Statement:** Ticket image reads use distinct `original.webp` and `preview.webp` keys in the structured ticket folder, and image deletion addresses both keys without a legacy singleton branch.
- **Surface:** api.
- **Sources:** `decisions/2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md` — `[VERIFIED]` — kind: decision — mandates variants, strict hierarchy and retirement of flat-key reads/deletes; `intent.md` §§3–4 captures the explicit task.
- **Conflict:** none; historical migration D5/Q3 is superseded by S for flat ticket image compatibility.
- **Open question:** none.
- **Ripple:** `toTicketCover`, `loadTicketCovers`, guard cleanup/deletes, generic links/download/delete of ticket rows, and all their ticket consumers adopt strict key validation (C1/C2/C3/C6). Generic modern structured-ticket downloads retain existing transport for non-sheet callers; flat ticket keys cannot bypass validation. Asset meter photos are non-ticket files: preserve their existing single-object representation separately, consistent with S's Boundaries.
- **Acceptance:** Remove `TICKET_IMAGE_ORIGINAL_KEY` and its flat-file fallback. `toTicketCover` signs original and sibling preview; `ticketImageObjectKeys` returns both for every accepted ticket-image key. Out-of-hierarchy keys are rejected before signing/deleting. No backfill or historical-object sweep runs.
- **Edges:**
  - **Reached by:** Ticket attachment lists; signature, checklist, incident, lunch and job-progress covers; explicit deletion and shared replacement cleanup; generic links/download/delete for ticket feature types. Validate before either generic presigning call or `getObjectStream`.
  - **Does not apply when:** Non-images (REQ-03), entity/profile photos and non-ticket meter-reading photos. Keep existing ticket image groups (`attachments`, `signatures`, `checklist-photos`, `incident-evidence`); the change is strictness, not renaming sibling folders.
  - **When an input is absent:** A missing attachment row keeps the existing no-cover/no-op treatment; a present flat/malformed ticket storage key is refused. Placeholder may remain null; do not invent a database backfill.
  - **Trust boundary:** Database key is validated before it is signed or deleted; compare known owner tenant/ticket identifiers where available. Do not accept a key merely because it ends with `original.webp`.
  - **Read time:** Live presigned links are regenerated from stored metadata at response time; stored image bytes/placeholder are not reprocessed by this task.
  - **Matrix:** N/A — no mirror/sync requirement.
- **Notes for the executor:** Keep existing shared `EntityImageCover` shape. Preserve transaction and failure semantics from `decisions/2026-10-30-ticket-attachment-s3-deletion-in-the-row-delete-transaction-no-outbox.md` (kind: decision, `[VERIFIED]`, developer direction/reference); change the key set, not the deletion architecture.

### REQ-03 — Plain ticket files stay in their structured hierarchy `[VERIFIED]`

- **Statement:** Ticket document/non-image reads and deletions address only their structured job-ticket file keys, and documents expose their direct presigned S3 `url`.
- **Surface:** api.
- **Sources:** `decisions/2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md` — `[VERIFIED]` — kind: decision — structured document path and rejection of legacy/outside-hierarchy keys; `intent.md` §§3–4 captures the requested document behavior.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** Attach File document responses, incident non-image evidence list/upload responses, ticket guard cleanup and generic links/download/delete of ticket rows distinguish one plain object from image variants (C1/C3/C6). Keep incident plain evidence's existing `incident-evidence` folder as a structured sibling group. Inception trace found direct incident `presignDownloadUrl(row.fileName, ...)` calls bypassing the first planned helper change; cover both and remove stale D5 fallback documentation.
- **Acceptance:** Attach File documents use `tenants/{tenantId}/job-tickets/{ticketId}/documents/{fileId}.{ext}` with sanitized extension; permitted structured plain files delete their one object. Flat/outside-hierarchy ticket keys are never presigned, streamed or deleted, including incident evidence and generic links/download routes for ticket feature rows. Valid structured ticket files remain readable through existing generic routes for their existing non-sheet callers.
- **Edges:**
  - **Reached by:** Ticket list/upload responses and remove; `TicketIncidentsService.toResponses` non-image evidence `files[].url` and `uploadAttachment` plain evidence `fileUrl`; shared replacement/orphan cleanup; generic links/download/delete on ticket feature types.
  - **Does not apply when:** Images (REQ-02); non-ticket documents, quotation attachments and job artifacts (S Boundaries).
  - **When an input is absent:** Retain existing missing-file/row behavior; extension sanitization stays in the existing builder, including its extensionless output. No new extension allow-list is specified.
  - **Trust boundary:** Original filename is user supplied; stored keys and owner identities are validated. Use the original display name only as download metadata, not unsanitized key material.
  - **Read time:** Live URL generation from the existing stored row.
  - **Matrix:** N/A — no mirror/sync requirement.
- **Notes for the executor:** Keep forced-download links via `presignDownloadUrl`, per `decisions/2026-10-28-user-uploaded-files-are-served-as-forced-download.md` (`[VERIFIED]`, kind: decision, developer direction/reference). Keep neutral content type and existing filename handling; do not replace documents with inline links.

### REQ-04 — Retire ticket-scoped API streaming `[VERIFIED]`

- **Statement:** Mobile ticket attachment downloads use the response's presigned S3 links instead of a field-ticket route that streams file bytes through NestJS.
- **Surface:** api, mobile.
- **Sources:** `decisions/2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md` — `[VERIFIED]` — kind: decision — explicitly retires the field-ticket stream method/route and mobile fallback; `intent.md` §4 records the requested removal/deprecation.
- **Conflict:** none; original migration D9's field-ticket streaming fallback is superseded by S.
- **Open question:** none.
- **Ripple:** Remove `TicketAttachmentsService.download`, controller `downloadAttachment` scoped route, mobile service-interface/HTTP/mock `download`, and sheet call sites (C4). Retain other services' independent API download routes per S Boundaries, after tracing callers.
- **Acceptance:** The scoped `GET /field/tickets/:ticketId/attachments/:attachmentId/download` route and its streaming service are removed (chosen over a dormant deprecated implementation). The mobile ticket attachment service exposes no byte-streaming `download` and has no live caller of that removed endpoint.
- **Edges:**
  - **Reached by:** Ticket sheet open/share and mobile HTTP service calls; old scoped route requests cease matching this controller endpoint.
  - **Does not apply when:** Existing web generic stream fallback, sales attachments, job artifacts and historical mobile draft-URI header resolution outside the named sheet open flow. No wholesale generic endpoint or URI-auth removal is requested. Generic reads still validate ticket-feature keys under REQ-02/03; preserving transport does not preserve flat-key compatibility.
  - **When an input is absent:** Missing/expired response link follows REQ-05; never fall back to the removed stream.
  - **Trust boundary:** Ticket metadata requests retain existing authentication/authorization; S3 URL requests do not carry API bearer credentials.
  - **Read time:** Use current attachment metadata to obtain the signed link.
  - **Matrix:** N/A — no mirror/sync requirement.
- **Notes for the executor:** Route removal is a deliberate contract break authorized by this task. Run `tcg-contract-tracer`; enumerate repository callers and explicitly record the released mobile-version limitation. No new response shape is needed.

### REQ-05 — Mobile refreshes and opens directly from S3 `[VERIFIED]`

- **Statement:** When a ticket attachment's S3 link fails, mobile refreshes attachment metadata and opens the file from the refreshed presigned link, without API payload streaming.
- **Surface:** mobile.
- **Sources:** `decisions/2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md` — `[VERIFIED]` — kind: decision — refresh/retry the direct link; `intent.md` §4 captures the developer's explicit `refreshAttachments()` instruction.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** Ticket sheet open handler, refresh hook, direct file helper, HTTP service and mock contract (C4/C5) migrate together; existing local cache/share behavior stays. Offline upload/delete queues are outside this transport change (S Boundaries).
- **Acceptance:** Opening uses `url` for a document or `image.originalUrl` for an image. A failed link fetch refreshes metadata, resolves the same attachment id and retries directly against S3. Missing link/missing refreshed row or retry failure reaches the existing failure handling. There is no API array-buffer fallback.
- **Edges:**
  - **Reached by:** Attachments sheet row open/share; failed direct S3 download, including expiration; image expiry refresh using the same query cache.
  - **Does not apply when:** Native sharing fails after a successful download: do not refetch/redownload as an expiration recovery. Existing offline queued upload/delete behavior stays.
  - **When an input is absent:** No usable initial link → refresh once; no refreshed attachment/link → existing error handling. No ticket/query client → refresh returns no metadata and opening fails normally.
  - **Trust boundary:** Links come from authorized API metadata. Direct S3 requests send no API `Authorization` header (P3 rule). No mobile transformation into a legacy API download URL.
  - **Read time:** Refresh must return fresh rows, not only invalidate an inactive query; resolve replacement URLs from that returned list.
  - **Matrix:** N/A — no mirror/sync requirement.
- **Notes for the executor:** Reuse the existing Expo file cache/native share helper and query key; bounded retry is D3. Keep response types and UI layout stable. Update existing affected cases only.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no.
- **Migration required:** no.
- **Data backfill required:** no — explicitly excluded by S and intent §5.
- **Existing models considered:** Existing `Attachment` has key, MIME, originalName, placeholder, tenant and polymorphic feature identity; `JobTicket` supplies UUID and per-tenant ticketCode. Established by `rg -n '^model (Attachment|JobTicket)' apps/api/prisma/schema.prisma` and reading the matching model ranges. No new model/column is justified.
- **New/changed models:** N/A — no Prisma edits.

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| Attachment | UUID id; no new business code | N/A | existing upload UUID generation | Existing schema; no identity change |
| JobTicket | existing ticketCode | NOT SPECIFIED by this task; not changed | existing ticket service | S Boundaries |

- **New prefix introduced:** no.
- **Child relations:** existing relations unchanged.
- **Fields whose type/precision no source states:** N/A — no fields introduced.

## 4. API surface — `apps/api`

- **Pattern:** P3 storage/presigned principles, existing ticket subgroup variant (not entity cover ownership CRUD). No new entity-photo module.
- **Existing functions/services to reuse:** `TicketAttachmentGuardService`; image processor/variant store; `S3StorageService.buildTicketFileKey`, `presignGetUrl`, `presignDownloadUrl`, `deleteObjects`; `AttachmentsRepository`; existing job-ticket authorization; `toTicketCover` and batch `loadTicketCovers`.
- **New exported functions/services proposed:** A focused structured ticket-file key dispatcher may distinguish plain singleton keys from image pairs; justified in D2. No new module/provider.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| GET / POST | `/field/tickets/:id/attachments` | existing field-tickets controller | ticket-attachments service | AttachmentsRepository | REQ-01–03 |
| DELETE | `/field/tickets/:id/attachments/:attachmentId` | same | same + guard | same | REQ-02–03 |
| GET (removed) | `/field/tickets/:id/attachments/:attachmentId/download` | remove scoped handler | remove download | N/A | REQ-04 |
| POST / DELETE | existing sibling ticket upload/delete routes | existing controller | signatures, lunch, incidents, checklist + guard | existing repositories | REQ-01–03 |
| POST / DELETE | existing generic attachments routes | attachments controller | existing attachments service | existing repository | REQ-01–03 bypass/dispatch |
| GET | `/attachments/:id/links`, `/attachments/:id/download` | attachments controller | existing signed-access/findById policies | existing repository | REQ-02–03 ticket-key validation before file access |

Per endpoint:

- **Request DTO:** unchanged multipart file/metadata; no new fields.
- **Response shape:** existing attachment metadata with optional document `url` or image `EntityImageCover`; no type shape addition.
- **Guards / roles:** existing global auth/role guards and ticket assignment/window rules unchanged.
- **Route param identity:** existing ticket route parameter resolution stays; S3 hierarchy uses resolved ticket UUID.
- **Errors:** missing storage config/outside structured hierarchy → reject; exact messages NOT SPECIFIED (D2 chooses 400). Retain existing authorization and missing-row outcomes. Generic ticket-feature reads validate after authorized row lookup and before signing or `getObjectStream`; generic permission policies do not change.
- **Pagination:** N/A — no list/pagination change.
- **Module registration:** no new module; if constructors change, audit DI graph and boot API under the existing API context rule.

## 5. Web surface — `apps/web`

- **Routes:** unchanged; no web source edit planned.
- **Existing components to reuse:** existing ticket-progress attachment thumbnail and meter-reading thumbnail remain consumers of existing cover fields; no component introduced.
- **New components proposed:** none.
- **Table:** N/A.
- **Forms:** N/A.
- **Server state:** existing job-progress/meter reads; no key/invalidation change.
- **Colors / spacing:** N/A — no styling change.
- **Responsive:** N/A — no layout change.
- **Copy:** NOT SPECIFIED; no copy change required.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** existing Ticket Details attachment sheet; no Expo route added.
- **Components:** existing `ticket-attachments-sheet.tsx`, direct cache/share file helper; no new UI component or styling.
- **Offline / sync behavior:** existing upload/delete queue unchanged. Opening a remote file still requires network; this task removes API streaming rather than creating offline viewing.
- **Touch targets:** existing targets unchanged; 48px rule applies if edited.
- **Push / notifications involvement:** N/A.

## 7. Shared package — `packages/shared`

- **Types added / changed:** none; existing `EntityImageCover` reused.
- **Nothing shared:** N/A — shared output types are consumed unchanged.

## 8. Permissions and tenancy

- **Roles permitted:** existing assigned-ticket authorization and existing generic routes; no new permission.
- **Roles denied:** existing denial rules unchanged.
- **Tenant isolation:** existing tenant repository extension, including its documented exceptions; do not assume unconditional scope. Storage key validation must compare known owner identifiers before use (D2). `tcg-prisma-guardian` audits tenant read/delete paths even though schema is unchanged.
- **Cross-tenant reads:** none newly authorized.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| storage configuration | Require image or plainFile | S / REQ-01 | `[VERIFIED]` |
| ticket key | Structured ticket hierarchy only; images original+preview, documents plain file | S / REQ-02–03 | `[VERIFIED]` |
| extension | Existing sanitized extension builder; no new allowed-type list | intent §11 / S | `[VERIFIED]` |
| new lengths/size limits | NOT SPECIFIED — retain existing limits | No change requested | N/A |

## 10. Tests

**New tests: not requested.** Explicitly update affected existing guard/attachment cases and mocks; do not add spec files or new test cases. Run the existing suites, `pnpm api:test`, `pnpm lint`, `pnpm typecheck`, plus existing targeted mobile tests and API build as appropriate through Nx-backed workspace scripts.

| Level | What it proves | Req |
| --- | --- | --- |
| Existing API cases | Config rejection/idempotency, strict image/document keys, deletion behavior and reached ticket siblings | REQ-01–04 |
| Existing mobile cases | Direct S3 file open, fresh-link recovery, service/mock contract and sharing | REQ-04–05 |
| Existing build/lint/typecheck | Reachable consumers compile and lint; separate baseline failures by reproduction | All |
| Manual existing runtime checks | Variant pair vs plain singleton, reject flat keys, preserve non-ticket meter covers and generic delete | REQ-01–03 |

- **Requirements with no testable acceptance criterion:** none.
- **Evidence status at elaboration:** Coordinator reports API build pass, lint pass, targeted mobile 4 suites/67 tests pass. Full API has 313 suites/3663 tests passing and one unchanged payroll failure reproduced from clean HEAD; typecheck has unchanged `app-version.test.ts:71,83` TS2345 errors. Acceptance 4 remains unfulfilled: no waiver was granted, and unrelated payroll/app-version fixes do not belong to this attachment unit. These are provisional evidence, not analyst sign-off. Executor/analyst must verify exact results. Logs: `/tmp/ticket-api-test-verified.log`, `/tmp/ticket-api-payroll-baseline.log`, `/tmp/ticket-typecheck-verified.log`, `/tmp/ticket-lint-final.log`, `/tmp/ticket-api-build.log`, `/tmp/ticket-mobile-test-final.log`.

## 11. Non-functional

- **Performance:** retain local presigning/direct S3 transfer; no benchmark requested.
- **Concurrency:** preserve clientUploadId idempotency/race cleanup; no identity migration.
- **Audit / activity log:** no new event/metadata behavior.
- **Migration/rollout order:** no schema deployment. API route removal intentionally ends compatibility with old clients that still call it; no unsupported claim of a hotfix to installed builds. No deployment/commit/PR requested. Historical flat objects stay untouched and lose ticket read/delete compatibility deliberately.

## 11a. Ripple — already-shipped behaviour these requirements reach

Commands actually run during elaboration:

- C1: `rg -n 'storeUpload\(|toTicketCover\(|ticketImageObjectKeys\(|loadTicketCovers\(' apps/api/src`
- C2: `rg -n 'attachmentGuard\.deleteOrphaned|attachmentGuard\.cleanupReplaced' apps/api/src/usecase/{ticket-signatures,ticket-lunch-breaks,ticket-incidents,checklist-assignments,ticket-attachments}`
- C3: `git diff -- apps/api/src/usecase/asset-management/assets/assets.service.ts apps/api/src/presentation/attachments/attachments.controller.ts` and `git show HEAD:apps/api/src/service/attachments/ticket-image.ts` distinguish pre-task consumers from provisional edits.
- C4: `rg -n 'ticketAttachments\.|TicketAttachmentService|/field/tickets/.*/attachments|/attachments/.*download' apps/mobile/data apps/mobile/components/field apps/api/src/presentation/field-tickets/field-tickets.controller.ts apps/web/src/features/ticket-progress apps/api/src/usecase/job-progress` plus `git show HEAD:apps/api/src/presentation/field-tickets/field-tickets.controller.ts` scoped route range.
- C5: `rg -n 'openAttachment|refreshAttachments|download' apps/mobile/components/field/ticket-attachments-sheet.tsx apps/mobile/components/field/ticket-attachment-file.ts apps/mobile/data/hooks/use-ticket-attachments.ts`
- C6 (inception-tracer reconciliation): `rg -n 'presignDownloadUrl|presignGetUrl|getObjectStream|ticketImageObjectKeys|ticketAttachmentObjectKeys' apps/api/src/usecase/ticket-* apps/api/src/usecase/checklist-assignments apps/api/src/usecase/job-progress apps/api/src/presentation/attachments`; read incident service §§uploadAttachment/toResponses, generic controller §§links/download, `AttachmentsService.findForSignedAccess/findById`, mobile `lib/attachments.ts` and web ticket-progress `attachment-thumbnail.tsx`. Consumer observations are not behavior sources.

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| Ticket signatures + lunch-break services | guard upload, batch cover, cleanup | 01–03 | Apply strict keys to the same ticket groups; existing auth/linking stays | S Decision/Boundaries | C1/C2 |
| Checklist assignment service | guard upload, covers, explicit delete/cleanup | 01–03 | Apply same strict ticket behavior | S Decision | C1/C2 |
| Ticket incident service | guard upload, image cover, plain evidence | 01–03 | Validate evidence list/upload URLs before signing; strict image/plain-file dispatch; remove stale D5 comment; existing subgroup stays | S acceptance 2/Boundaries | C1/C2/C6 |
| Ticket attachments + field controller | upload/list/delete/download | 01–04 | Strict hierarchy and remove scoped streaming route | S Decision | C1/C4 |
| Job-progress API + web ticket-progress displays | shared ticket covers | 02 | Receive same cover shape using strict ticket variants; no web redesign | S Decision/Boundaries | C1/C4 |
| AssetsService meter-reading photos + web drawer | previously ticket helper | 02 | Preserve non-ticket flat single-object covers separately | S Boundaries; D4 | C1/C3 |
| Generic attachment upload/read/delete + non-ticket consumers | flat builder, links/download, delete helper | 01–03 | Reject upload bypass; validate ticket keys before links/download/delete; preserve structured generic reads and non-ticket singleton operations | S acceptance 1–2/Boundaries; D1/D2/D4 | C3/C4/C6 |
| Mobile sheet, file helper and refresh hook | stream fallback/direct open | 04–05 | Refresh metadata and retry S3 only; keep cache/share UI | S Decision | C4/C5 |
| Mobile service interface/HTTP/mock, existing cases | removed download method | 04–05 | Remove byte-streaming contract, align existing mocks/cases with direct-link use | S Decision; intent §5 | C4/C5 |
| Web ticket-progress generic stream fallback; mobile saved-draft URI header resolver | independent generic download URL consumers | 02–04 | Preserve mechanisms outside named sheet flow; server rejects flat ticket keys before access; no generic endpoint or URI-auth sweep | S acceptance 2/Boundaries; D2/D5 | C4/C6 |

- **Surfaces with no existing behavior in this area:** No shared package change required; existing shared cover is consumed unchanged. Web has generic attachment downloads but no scoped field-ticket attachment endpoint caller found in C4; the specialist must validate this finding.
- **Consumers with no source for what happens to them:** none within the stated transport/hierarchy scope. Old installed mobile releases are a rollout limitation, not silently assumed migrated.

## 11b. AI decisions — reviewed by a developer

These are implementation choices for review, not additional product requirements. No row authorizes data rewrite/new schema/dependency. Review may adjust them without another product confirmation batch.

| ID | Decision | Chosen | Why / alternatives (with existing code found) | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Close generic ticket upload bypass | Reject the four ticket feature types (`JOB_TICKET`, `TICKET_SIGNATURE`, `CHECKLIST`, `TICKET_INCIDENT`) at generic POST; use their existing guarded ticket routes | Generic controller uses a flat builder, so removing only guard fallback would not meet acceptance 1. Alternative: duplicate ticket processing/ownership into generic route; more complexity with existing dedicated routes | no | pending review | 2026-11-05 |
| D2 | Strict key validation and file/image dispatch | Validate structured tenant/job-ticket path and known owner ids; image original returns original+preview, plain file returns singleton; reject invalid keys with 400. Apply before ALL ticket link minting/byte access: ticket responses, incident list/upload plain-evidence responses, generic links/download/delete for ticket feature types. Live-QA correction: UUID featureId constrains the folder; code featureId resolves under the row tenant via one repository batch query for shared covers. Generic access/orphan cleanup use the same resolved owner | Direct incident/generic signing and streaming also bypassed the permissive helper (C6). Live ED-1 showed structural Attachment-to-optional-owner typing omitted ticketId checks. Explicit UUID/code mapping closes that gap while preserving D6 and SUPER_ADMIN row ownership. No response/schema/dependency change; see emulator-validation.md | no — guardian and tracer source audits pass; routine human review pending | pending review | 2026-11-06 |
| D3 | Expiration recovery | One metadata refresh and one direct-S3 retry per open; use returned rows to find same attachment id; download stage separated from native sharing | Reuses query key/file helper, prevents retry loops and avoids refetching on share failures. Missing link follows same refresh once. Alternative: unlimited retries or query invalidation without returned metadata cannot reliably obtain a fresh inactive-sheet URL | no | pending review | 2026-11-05 |
| D4 | Non-ticket consumers of ticket helper | Meter photos build their existing plain cover locally; generic delete branches by ticket feature type, preserving non-ticket singleton deletion | C3 proves both reused the permissive helper. Scope is ticket cleanup, so entity/profile/non-ticket files retain established storage paths. Alternative: enforcing ticket hierarchy globally would break unrelated files | no | pending review | 2026-11-05 |
| D5 | Streaming deprecation strategy | Remove scoped endpoint/usecase and sheet service download completely; retain generic structured-file stream for existing web/other callers and historical mobile draft URI header support | Request removes field-ticket stream and sheet fallback, not every generic route/URI auth helper. Generic ticket reads still pass D2 hierarchy validation. Tracer checks removed route/callers and old-client limitation | no — explicit requester authorization | pending review | 2026-11-05 |
| D6 | Identity/data boundaries | Keep ticketCode/UUID feature ownership matching and deletion transaction semantics; no backfill | Separate existing identity/deletion decisions remain valid. Alternative: removing every historical feature_id match broadens the task beyond S and would alter ownership/idempotency | no | pending review | 2026-11-05 |
| D7 | Rejected stale keys after a saved replacement | Only `cleanupReplaced` treats `BadRequestException` from stale attachment validation as nonfatal, alongside the existing storage-unavailable case; log and leave the rejected row/object untouched. Direct reads/deletes remain strict; unexpected errors still propagate | PR #1049 review identified cleanup validation escaping after signature/checklist/lunch writes. Strict legacy refusal does not require reporting an already-saved replacement as failed. Alternative: prevalidate all stale attachments before writing; unnecessary coupling between a valid replacement and an inaccessible historical file. Developer requested this patch on 2026-11-06 | no — explicit patch request | pending review | 2026-11-06 |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Reviewed by | Enumerated by |
| --- | --- | --- | --- | --- |
| Ticket signature, lunch, checklist, incident image uploads/reads/deletes | Ticket P3 subgroup | yes — same vertical unit as Attach File strict helper changes | pending review | C1/C2 |
| Structured incident non-images | Plain ticket-file subgroup | yes — validate list/upload presigning and singleton deletion; existing group preserved | pending review | C1/C2/C6 |
| Generic ticket upload/read/delete | Alternate persistence/byte-access entry | yes — reject upload bypass; validate links/download/delete; preserve structured generic transport/non-ticket paths | pending review | C3/C6 |
| Meter-reading photos | Non-ticket single-object cover | Preserve existing behavior separately; no storage migration | pending review | C1/C3 |
| Entity/profile photos | P3 | no — independent hierarchy/processor remains | pending review | P3 code table; C1 |
| Sales quotation attachments, job artifacts, unrelated generic streams | Independent document flows | no — outside S Boundaries; no follow-up work invented | pending review | C4 |

## 12. Open questions — the stop-and-ask list

None. The current developer explicitly specified retirement of historical ticket key/stream compatibility. A repeated “confirm this request” question would not resolve a missing requirement. Scrum's decision note S makes that reversal durable. No G1–G5 unanswered question was identified; contract and tenancy specialists still audit implementation.

The broader field-ops conflict remains at `field-ops/field-ops-mobile-INDEX.md` → `gaps.md#field-operations-mobile-app`: FR-TCG-FOP-001 (55.6 KB, 2026-06-09), FR-TCG-FOP-002 (46.2 KB, 2026-06-16) and Atom user stories (34.5 KB, 2026-08-11) are all unverified. None is used to invent storage behavior or to decide a workflow here.

## 13. What this spec deliberately does not specify

- External Jira id, requester personal identity, release/deployment date: NOT ON TICKET.
- New workflow/business rules, new MIME allow-list, new validation limits, schema/data rewrites or historical object sweeps: outside scope.
- Changes to UUID/ticketCode identity compatibility, non-ticket storage, general download transport, historical mobile draft URI headers or queued offline writes: outside this cleanup. Generic endpoints still require ticket-key validation; they are not exempt read paths.
- Exact retry error copy and platform-native share UI: retain existing behavior; no UI redesign requested.
- Clean overall test/typecheck status despite known baseline failures: not established; record honest remaining failures and avoid unrelated fixes in this unit.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement answered/deferred — none.
- [x] Every scoped conflict has a decision note — S explicitly supersedes old migration fallbacks; broader field-ops conflict remains outside scope.
- [x] Answers written into spec with sources/flags — direct request and scrum note cited.
- [x] Every §12 question resolved — none raised.
- [x] Requirement Edges are filled and scoped implementation choices marked in §11b.
- [x] Every §11a consumer group has a sourced disposition.
- [ ] Developer review of §11b/§11c — pending normal review; no `needs developer` guardrail row. The current request authorizes this technical implementation without another permission round.
- [ ] Decomposed into vertical units — tcg-decomposer next.

Behavior authorized by: requesting developer's explicit task and lifecycle instruction, 2026-11-05. AI decision review is not represented as completed.

**Elaborator stop:** This stage produced the specification only; it did not edit application code. No open questions require a reply. Hand back to the coordinator for decomposition; provisional code remains subject to executor/analyst reconciliation.
