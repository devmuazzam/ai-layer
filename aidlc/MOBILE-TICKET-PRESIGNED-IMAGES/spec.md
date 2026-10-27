# Spec — MOBILE-TICKET-PRESIGNED-IMAGES presigned S3 images in the mobile ticketing flow

> Written by the elaborator from `intent.md` beside it. No Jira id exists; the "ticket" source
> below is `intent.md` itself (the developer's request, captured 2026-10-27). It is a developer
> request, not a product-adjudicated document, so it is `[UNVERIFIED]` kind: jira-equivalent.
> The approved design plan (`/home/codingcops/.claude/plans/we-are-in-latest-quirky-hejlsberg.md`)
> is treated as AI "how" decisions (§11b), never as a source for what to build.
> **Nothing has been implemented. This spec stops at §12.**

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `MOBILE-TICKET-PRESIGNED-IMAGES` (slug; no Jira id — Q2) |
| Intent | `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/intent.md`, captured `2026-10-27` |
| Elaborated on | `2026-10-27` |
| Vault state at elaboration | `.ai/vault/INDEX.md` read; six `domain/` files verified, all else unverified; the `field-ops-mobile-INDEX.md` conflict stub applies and is unresolved. Jira not consulted (none exists). |
| Open questions raised by this spec | 6, all in §12 |
| Already-shipped behaviour reached | 12 consumers in §11a; 1 with no source for what happens to it (video/undecodable uploads, Q5) |
| Rules consulted | `.ai/claude/contexts/patterns.md` P3; `.ai/claude/contexts/prisma.md`; `apps/api/CLAUDE.md`; `apps/mobile/CLAUDE.md`; root `CLAUDE.md` |

Product-conflict note (`field-ops-mobile-INDEX.md`, 2026-08-10, unverified): three field-ops
documents disagree (FR-TCG-FOP-001 v1.1 REVIEWED 55.6 KB 2026-06-09; FR-TCG-FOP-002 v2.0 DRAFT
46.2 KB 2026-06-16; Atom user stories 34.5 KB 2026-08-11). **None is verified. This work takes
no side and specifies no field-ops product behaviour from any of them.** The only place it
touches the conflict is REQ-05 (WTL labels).

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Ticket images load from presigned S3 links on mobile | api, mobile | `[UNVERIFIED]` | intent.md §2–4 | no |
| REQ-02 | Ticket read responses return the existing `EntityImageCover` / `EntityImageListItem` shape | api, shared, mobile | `[UNVERIFIED]` | intent.md §3–4 | no |
| REQ-03 | Ticket image uploads store WebP original + thumbnail + inline blur placeholder | api | `[UNVERIFIED]` | intent.md §4 | no (Q5, Q6 touch edges) |
| REQ-04 | Ticket uploads set `featureType` and `category` (non-lunch labels) | api | `[UNVERIFIED]` | intent.md §4 | no |
| REQ-05 | Lunch WTL signature labels `Lunch WTL 1`..`4` | api | `[CONFLICT]` | intent.md §4, §11; `field-ops/field-ops-mobile-INDEX.md` | no (labels mirror code; settle nothing) |
| REQ-06 | Ticket documents open and share through a presigned link | api, mobile | `[UNVERIFIED]` | intent.md §4 | no |
| REQ-07 | New ticket files stored in a per-ticket UUID folder tree | api | `[UNVERIFIED]` | intent.md §4 | no |
| REQ-08 | One shared mobile image component | mobile | `[UNVERIFIED]` | intent.md §4 | no |
| REQ-09 | Presentation of ticket images uploaded before this change | api, mobile | `[OPEN]` | none | **yes** (Q3) |
| REQ-10 | Scope beyond the ticketing flow (sales quotation attachments, job artifacts) | mobile | `[OPEN]` | none | **yes for that scope** (Q1) |
| REQ-11 | `category` for items the label table does not name | api | `[OPEN]` | none | **yes for those items** (Q4) |

Counts: 11 total — 0 verified, 7 unverified, 1 conflicted, 3 open.

## 2. Requirements

### REQ-01 — Ticket images load from presigned S3 links on mobile `[UNVERIFIED]`

- **Statement:** Photos and signatures in the mobile field-ticket flow are shown from presigned S3 links returned by the API, not streamed through the API with a Bearer header.
- **Surface:** api, mobile
- **Sources:**
  - `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/intent.md` — `[UNVERIFIED]` — kind: jira-equivalent (developer request) — §2 "should load the way the profile photo already does, from presigned S3 links returned by the API"; §4 first line.
  - `.ai/claude/contexts/patterns.md` → P3 *Links* — `[UNVERIFIED]` — kind: rule — how presigned links work today (24 h, hour-stable); binding on how, not what.
- **Conflict:** none
- **Open question:** none
- **Ripple:** see §11a rows R1–R9 (every mobile display site and every ticket read response).
- **Acceptance:** On iOS, each migrated surface (signature, identity photo, checklist/deficiency photo, incident evidence, lunch-break signature, photo thumbnail, preview modal) displays with no request to `/attachments/:id/download` for display. Derived from the intent's goal; acceptance criteria are absent on the request and must be confirmed by the developer at sign-off (intent.md §3).
- **Edges:**
  - **Reached by:** every mobile display site listed in §11a R1; every API read in §11a R2–R8.
  - **Does not apply when:** a photo is still on the device (`local:<id>`, `file://`) — it previews from the local URI (intent.md §4 does not change offline capture; ASSUMED — local branches of `resolvePhotoUri` unchanged, from the plan, `apps/mobile/lib/attachments.ts`).
  - **When an input is absent:** no image on the record means the response carries no image object. ASSUMED — nearest existing behaviour (the id fields are already nullable in `TicketSignatureResponse`, `ticket-signatures.service.ts:58-59`).
  - **Trust boundary:** server-derived. Links are made only from keys of rows owned by the row's tenant (intent.md §8).
  - **Read time:** `live` (link re-signed per request, hour-stable); N/A for catalogue data.
- **Notes for the executor:** reuse `S3StorageService.presignGetUrl` (`apps/api/src/service/storage/s3-storage.service.ts:69`) unchanged. Never send `Authorization` with a presigned link (P3 Rules).

### REQ-02 — Ticket read responses return the existing cover shape `[UNVERIFIED]`

- **Statement:** Ticket API responses that reference an image return `EntityImageCover` (single image) or `EntityImageListItem` (gallery) under the existing field names (`thumbnailUrl`, `originalUrl`, `placeholderDataUrl`), consistent with the profile-photo `cover`.
- **Surface:** api, shared, mobile
- **Sources:**
  - `intent.md` §3 — `[UNVERIFIED]` — kind: jira-equivalent — "We need to use the same field name in response that returns these presigned URL and thumb images"; §4 line 2.
  - `packages/shared/src/types/entity-image.types.ts` — `[UNVERIFIED]` — kind: code — the shapes that exist today (descriptive only).
- **Conflict:** none
- **Open question:** none for the shape. The exact new property names on each ticket response (for example `signatureImage`) are not stated by the ticket: see §11b D6.
- **Ripple:** §11a R2–R8. This is a **G5 changed response shape**: `tcg-contract-tracer` after the contract change; callers fixed in the same unit.
- **Acceptance:** each response in §4 table below carries the shape; the bare id fields' fate (kept alongside, or removed) is recorded in D6; `pnpm typecheck` passes for web and mobile; `tcg-contract-tracer` reports no unfixed caller.
- **Edges:**
  - **Reached by:** `GET /field/tickets/:id/signatures`, `POST/PATCH` signature responses, checklist reads, lunch-break reads, incident reads, `GET /field/tickets/:id/attachments`.
  - **Does not apply when:** web `ticket-progress` (`job-progress.service.ts`) builds its own response from repository rows and is not these DTOs (§11a R10).
  - **When an input is absent:** null object, not an empty object. ASSUMED — `cover?: EntityImageCover | null` convention (`packages/shared/src/types/employee.types.ts:191`).
  - **Trust boundary:** N/A — server-derived.
  - **Read time:** `live`.
- **Notes for the executor:** reuse the types; add nothing to `@tcg/shared` unless a gap appears (intent.md §6). `@tcg/shared` is consumed as built `dist/`.

### REQ-03 — Ticket image uploads store real WebP variants and a blur placeholder `[UNVERIFIED]`

- **Statement:** An image uploaded through a ticket upload route is stored as a WebP original, a WebP thumbnail and an inline blur placeholder on the `attachments` row.
- **Surface:** api
- **Sources:**
  - `intent.md` §4 line 3 — `[UNVERIFIED]` — kind: jira-equivalent.
  - `.ai/claude/contexts/patterns.md` → P3 *Upload* steps 4–6 — `[UNVERIFIED]` — kind: rule — the pipeline to reuse.
- **Conflict:** none
- **Open question:** how the 160 px square cover-crop thumbnail suits wide signature images, and what happens to video and undecodable uploads on routes that today accept any file — Q5, Q6.
- **Ripple:** every ticket upload route (§11a R11). Uploads that previously stored any file now pass through an image decoder.
- **Acceptance:** after an image upload, the row has `placeholderDataUrl` set and two `.webp` objects exist under the key tree of REQ-07. Existing `attachment-photos.*.spec.ts` still pass (run, do not add).
- **Edges:**
  - **Reached by:** `POST /field/tickets/:id/signatures/attachments`, `…/checklists/attachments`, `…/lunch-breaks/attachments`, `…/incidents/:incidentId/attachments`, `…/attachments` (documents excluded, REQ-06). Enumerated by the grep in §11a.
  - **Does not apply when:** the file is not an image (`mimeType` not `image/*`) — REQ-06 for `JOB_TICKET` documents; incident video: `OPEN — see Q5`.
  - **When an input is absent:** no file → existing 400 `File is required`. ASSUMED — nearest existing behaviour.
  - **Trust boundary:** the file and its `mimetype` are client-supplied and not trusted; decoding is the check.
  - **Read time:** N/A.
- **Notes for the executor:** retry safety by `clientUploadId` must survive (`ticket-attachment-guard.service.ts` `storeUpload`). All-or-nothing with cleanup on failure, as `AttachmentPhotosService.upload`.

### REQ-04 — Ticket uploads set `featureType` and `category` `[UNVERIFIED]`

- **Statement:** Ticket attachment rows carry the developer-chosen `category` label for the item they represent; `featureType` is already correct at every site.
- **Surface:** api
- **Sources:**
  - `intent.md` §3 last line and §4 label table — `[UNVERIFIED]` — kind: jira-equivalent — "we need to user the attachment table feature_type and category". Labels "chosen by the developer on 2026-10-27" (intent.md §11).
  - `apps/api/prisma/schema.prisma` `enum AttachmentFeatureType` — kind: code — `JOB_TICKET`, `TICKET_SIGNATURE`, `CHECKLIST`, `TICKET_INCIDENT` exist; `Attachment.category String? @db.VarChar(100)` exists (descriptive only).
- **Conflict:** none (lunch labels in REQ-05)
- **Open question:** items the label table does not name: REQ-11 / Q4.
- **Ripple:** `attachments.category` readers — `grep -rn "\.category\|category:" apps/api/src/usecase/attachments` — the generic attachment code treats `category` specially for certificates and PO invoices (`attachments.service.ts:160-192`, `isPoInvoiceAttachmentCategory`); the new labels must not collide with `isPoInvoiceAttachmentCategory`. Whether any web list filters on `category` for these feature types: not established, see §11a R12.
- **Acceptance:** the table below holds after the link call; label strings exact.

| Item | `featureType` | `category` | Written at |
| --- | --- | --- | --- |
| Customer signature, step sig1 | `TICKET_SIGNATURE` | `Customer First Signature` | `TicketSignaturesService.recordSignature` (link) |
| Customer signature, step sig2 | `TICKET_SIGNATURE` | `Customer Last Signature` | `recordSignature` |
| Compliance signature | `TICKET_SIGNATURE` | `Compliance Signature` | `recordSignature` |
| Identity photo, step sig1 | `TICKET_SIGNATURE` | `Customer First Identity Photo` | `recordSignature` |
| Identity photo, step sig2 | `TICKET_SIGNATURE` | `Customer Last Identity Photo` | `recordSignature` |
| Checklist photo, pre-trip | `CHECKLIST` | `Pre-Trip Checklist` | `ChecklistAssignmentsService.submitAnswers` via `submitPretrip` |
| Checklist photo, post-trip | `CHECKLIST` | `Post-Trip Checklist` | `submitAnswers` via `submitPosttrip` |
| Checklist photo, JSA | `CHECKLIST` | `JSA Checklist` | `submitAnswers` via `submitJsa` |
| Incident evidence | `TICKET_INCIDENT` | `Incident Evidence` | `TicketIncidentsService.uploadAttachment` (incident known at upload) |

- **Edges:**
  - **Reached by:** `recordSignature`; `submitAnswers` (called from `submitPretrip`, `submitPosttrip`, `submitJsa`); `uploadAttachment` for incidents. Lunch-break WTL does **not** go through `recordSignature`: REQ-05. Incident customer signature and checklist signatures (`saveChecklistSignature`): REQ-11.
  - **Does not apply when:** `unavailable: true` signatures (no attachments); `JOB_TICKET` documents keep `category` as-is (intent.md §4 table has no document label; ASSUMED — unchanged).
  - **When an input is absent:** attachment id absent, no label written. A retaken or re-linked attachment gets the label at its own link time; the replaced one is cleaned up as today (`cleanupReplaced`).
  - **Trust boundary:** label derived server-side from `stepKey` / submit path; the client never sends a label.
  - **Read time:** frozen at link.
- **Notes for the executor:** upload routes carry no step, so `category` is link-time data (verified: `storeUpload` takes `featureType`, `ticketCode`, file, `clientUploadId` only). The intent names `saveSignature`; the method in code is `recordSignature`. Needs a new tenant-scoped `setCategory` repository method: D4.

### REQ-05 — Lunch WTL signature labels `[CONFLICT]`

- **Statement:** A lunch worked-through (WTL) customer signature is labelled `Lunch WTL 1` to `Lunch WTL 4` on its `attachments` row, one label per break slot.
- **Surface:** api
- **Sources:**
  - `intent.md` §4, §11 — `[UNVERIFIED]` — kind: jira-equivalent — developer chose four labels.
  - `field-ops/field-ops-mobile-INDEX.md` — `[UNVERIFIED]` — kind: vault — conflict stub; lists the BRS **three** lunch thresholds against payroll's **four**.
  - `payroll/gaps.md` → *Field-ops lunch capture vs payroll WTL* (line 133 at read time) — `[UNVERIFIED]` — kind: vault.
  - `apps/api/src/usecase/ticket-lunch-breaks/ticket-lunch-breaks.service.ts:51-61` — kind: code — `MAX_LUNCH_BREAK_INDEX = 3`; four because `WTL_TRIGGERS` has four entries (descriptive only).
- **Conflict:** `payroll/gaps.md#field-ops-lunch-capture-vs-payroll-wtl` and `gaps.md#field-operations-mobile-app`; candidates: `field-ops/frd-new-format-draft/INDEX.md` (55.6 KB, 2026-06-09), `field-ops/field-ops-frd/INDEX.md` (46.2 KB, 2026-06-16), `field-ops/atom-mobile-app-user-stories/INDEX.md` (34.5 KB, 2026-08-11). **None is verified. This spec does not choose between them, and neither does this work.** The four labels mirror a code cap; they settle nothing about how many lunch thresholds the product has. If product later decides three, the label set changes and this requirement is revised.
- **Open question:** none raised here (the conflict is pre-existing and recorded in the vault).
- **Ripple:** none beyond REQ-04 (label-only).
- **Acceptance:** a WTL signature saved for break index n (0-based; step key `wtl:<n>` from `wtlStepKeyFor`) is labelled `Lunch WTL <n+1>`. The intent's "1 to 4" and the code's zero-based `breakIndex` 0–3: mapping is by `breakIndex + 1` (ASSUMED — from `MAX_LUNCH_BREAK_INDEX = 3`, a zero-based bound; the plan's note "sequence 1–4" is not what the code stores in `stepKey`, which uses `breakIndex`). A reviewer verifies against the live code before build.
- **Edges:**
  - **Reached by:** `TicketLunchBreaksService.recordWorkedThrough` → `signaturesRepository.upsert` (own path, verified at `ticket-lunch-breaks.service.ts` ~L248-300 and L440-470; it does **not** call `recordSignature`). Returned-ticket correction goes through the same method.
  - **Does not apply when:** a taken lunch (`kind` TAKEN) has no signature; label not written.
  - **When an input is absent:** WTL identity photo is optional there (`identityPhotoAttachmentId?: string`): its label is not in the table — REQ-11 / Q4.
  - **Trust boundary:** break index validated 0–3 server-side already.
  - **Read time:** frozen at link.
- **Notes for the executor:** do not add a fifth label or a third; do not touch `MAX_LUNCH_BREAK_INDEX`.

### REQ-06 — Documents open and share through a presigned link `[UNVERIFIED]`

- **Statement:** Non-image ticket files (the "Attach File" documents) open and share on mobile from a presigned S3 link returned by the API, not an API arraybuffer stream.
- **Surface:** api, mobile
- **Sources:** `intent.md` §4 line 5 — `[UNVERIFIED]` — kind: jira-equivalent.
- **Conflict:** none
- **Open question:** none
- **Ripple:** `GET /field/tickets/:id/attachments` response gains a link (§11a R8); mobile `ticket-attachment-file.ts`, `ticket-attachments.http.ts` `download`. The `/download` route stays (intent.md §5).
- **Acceptance:** opening a document on mobile makes no request to `…/attachments/:attachmentId/download`; the existing route still works.
- **Edges:**
  - **Reached by:** mobile attachments sheet, `openAttachmentFile`.
  - **Does not apply when:** offline — falls back to the existing arraybuffer path (ASSUMED — intent.md §5 keeps the route as fallback; "offline" use stated only in the plan).
  - **When an input is absent:** row without a resolvable key: omit the link, keep the fallback.
  - **Trust boundary:** link built from the server-held `fileName` of a row owned by the ticket.
  - **Read time:** live.
- **Notes for the executor:** documents get no variants and a `Content-Disposition` is not controlled by the presign today (`presignGetUrl` sets only `ResponseCacheControl`): whether the shared file keeps its original name is a detail for the executor (record in the PR).

### REQ-07 — Per-ticket UUID folder tree for new uploads `[UNVERIFIED]`

- **Statement:** New ticket files are stored under an organised per-ticket S3 folder tree keyed by the ticket's UUID.
- **Surface:** api
- **Sources:** `intent.md` §4 line 6 — `[UNVERIFIED]` — kind: jira-equivalent. `patterns.md` P3 Rules (UUID/fixed names only; owner's tenant) — kind: rule.
- **Conflict:** none
- **Open question:** none
- **Ripple:** every reader of `Attachment.fileName` that assumes the flat `tenants/{t}/attachments/` prefix: `grep -rn "buildKey\|attachments/" apps/api/src` (§11a R13). Old rows keep their stored `fileName`.
- **Acceptance:** keys for new uploads contain only the tenant UUID, the ticket UUID (`ticket.id`, not `ticketCode`), fixed group names and generated UUIDs (D1).
- **Edges:**
  - **Reached by:** all routes in REQ-03 and REQ-06.
  - **Does not apply when:** pre-existing rows; profile pictures (keys unchanged).
  - **When an input is absent:** N/A — server-derived.
  - **Trust boundary:** server-derived; no user text in any segment.
  - **Read time:** N/A.
- **Notes for the executor:** the DB `featureId` column still holds `ticketCode`; only the S3 key uses the UUID (D1, D2).

### REQ-08 — One shared mobile image component `[UNVERIFIED]`

- **Statement:** A single shared mobile component renders ticket images, replacing per-site `resolvePhotoUri` + Bearer rendering.
- **Surface:** mobile
- **Sources:** `intent.md` §4 last line — `[UNVERIFIED]` — kind: jira-equivalent.
- **Conflict:** none
- **Open question:** none
- **Ripple:** §11a R1 (display sites). Profile photo `avatar.tsx` unchanged.
- **Acceptance:** each site in §11a R1 renders through the component; no site builds a `/download` URL for display; a presigned URL is rendered with no `Authorization` header.
- **Edges:**
  - **Reached by:** the display sites in R1.
  - **Does not apply when:** `local:` / `file://` / `data:` sources (kept).
  - **When an input is absent:** show the existing placeholder of that site (ASSUMED — nearest existing behaviour).
  - **Trust boundary:** N/A.
  - **Read time:** live; on image error, refetch the owning query at most once (D8).
- **Notes for the executor:** before creating, search all mobile `components/` directories for an existing image component (`mobile.md` has no reuse rule; check the code). `apps/mobile/CLAUDE.md`: StyleSheet + `theme/tokens.ts`, 48 px targets.

### REQ-09 — Presentation of ticket images uploaded before this change `[OPEN]`

- **Statement:** `OPEN — the intent says old rows "display through a fallback" (no backfill) but not what the crew should see; no source specifies whether showing the original with no blur placeholder is acceptable.`
- **Surface:** api, mobile
- **Sources:** none — searched `intent.md` §7 and §12 (states fallback, asks to confirm), the plan, `patterns.md` P3 *Known deviations* (profile rows: "removed by hand during testing", so no precedent for tickets). Nothing written decides acceptability.
- **Conflict:** n/a
- **Open question:** Q3.
- **Ripple:** `OPEN — cannot be stated until Q3 is answered.` Existing consumers enumerated in §11a R1–R8; old rows reach every one of them.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Edges:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. The detection mechanism is a how-decision and is in §11b D5 (not a requirement).

### REQ-10 — Scope beyond the ticketing flow `[OPEN]`

- **Statement:** `OPEN — the request says "all the attachments and images in the mobile app, especially the ticketing flow"; no source says whether sales quotation attachments and job artifacts are in scope.`
- **Surface:** mobile
- **Sources:** none — searched `intent.md` §5, §12 (carried as OPEN), `grep -rn "/download" apps/mobile` which shows `job-artifacts.http.ts` and quotation attachment code also use the stream. Nothing written scopes them.
- **Conflict:** n/a
- **Open question:** Q1.
- **Ripple:** `OPEN — what happens to those surfaces is part of Q1.` Known: `apps/mobile/data/services/job-artifacts/job-artifacts.http.ts`, `data/contracts/job-artifacts.contract.ts`, `data/contracts/quotation-attachment.contract.ts`.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Edges:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked for those surfaces. Ticketing-flow units (REQ-01..08) do not depend on the answer.

### REQ-11 — `category` for items the label table does not name `[OPEN]`

- **Statement:** `OPEN — the developer's label table (intent.md §4) does not name every attachment the ticket flow links; no source gives their category.`
- **Surface:** api
- **Sources:** none — searched `intent.md` §4, the plan matrix, and the link sites in code (`recordSignature`, `recordWorkedThrough`, `TicketIncidentsService.create`, `ChecklistAssignmentsService.saveChecklistSignature`). The unnamed items found: the incident's customer signature (feature `TICKET_SIGNATURE`, step key `incident:<uuid>`); the checklist signatures; the WTL identity photo; an identity photo or signature on a `compliance` step.
- **Conflict:** n/a
- **Open question:** Q4.
- **Ripple:** `OPEN — cannot be stated until the question above is answered.`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Edges:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** workaround, labelled as one: leave `category` null for the unnamed items (their current value) until Q4 is answered.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no
- **Migration required:** no. Verified in `schema.prisma`: `enum AttachmentFeatureType` has `JOB_TICKET`, `TICKET_SIGNATURE`, `CHECKLIST`, `TICKET_INCIDENT` (lines 66–102); `model Attachment` has `category String? @db.VarChar(100)`, `placeholderDataUrl String? @db.Text`, `clientUploadId`, `incidentReportId` (line 4327 onward).
- **Data backfill required:** no (intent.md §5, §7: no rewrite of existing rows or objects; G2 not triggered).
- **Existing models considered:** `Attachment` (holds everything needed); `TicketSignature`, `ChecklistItemAnswer`, `TicketIncidentReport` (hold the direct FKs; no new column needed). No new table: nothing is one-to-many/history/independent-lifecycle that `Attachment` does not already cover. Found by `grep -n 'model Attachment' apps/api/prisma/schema.prisma`.
- **New prefix introduced:** no
- **Child relations:** none new.
- **Fields whose type/precision no source states:** none new. Label strings must fit `VarChar(100)` (the longest, `Customer First Identity Photo`, is 29 characters).
- **Tenant scope (G3):** `attachment` is already in `TENANT_SCOPED_MODELS` (asserted at `apps/api/src/orm/prisma.service.spec.ts:125`). No new model, so no allowlist change.

## 4. API surface — `apps/api`

- **Pattern:** P3 — **sub-shape deviation** (D3): ticket images are multiple per ticket, no `cover_attachment_id`, uploaded via existing ticket-scoped routes, not `/attachments/photos`. A `patterns.md` entry is Haris-only: follow-up (§11c F1).
- **Existing functions/services to reuse:**
  - `S3StorageService.presignGetUrl` — `apps/api/src/service/storage/s3-storage.service.ts:69`
  - `S3StorageService.buildEntityImageKey`, `buildKey` — same file, lines 88–110
  - `EntityImageProcessor` — `apps/api/src/service/attachments/entity-image-processor.ts` (original `fit: 'inside'` max 2048; thumbnail 160 square `fit: 'cover'`)
  - `AttachmentPhotosService.upload` variant logic — `apps/api/src/usecase/attachments/attachment-photos.service.ts:137-168`
  - `TicketAttachmentGuardService.storeUpload / findOwned / cleanupReplaced / removeUnreferenced` — `apps/api/src/usecase/ticket-attachment-guard/ticket-attachment-guard.service.ts`
  - `AttachmentsRepository` — `apps/api/src/service/attachments/attachments.repository.ts`
  - Shared types — `packages/shared/src/types/entity-image.types.ts`, consts in `packages/shared`
- **New exported functions/services proposed** (each a §11b row):
  - `storeImageVariants` helper extracted from `AttachmentPhotosService.upload` (D2)
  - `buildTicketFileKey` and an optional `subfolder` param on `buildEntityImageKey` (D1)
  - presign-shape helper → `EntityImageCover` / `EntityImageListItem` for a row (D5)
  - `AttachmentsRepository.setCategory(attachmentId, category)` (D4)

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/v1/field/tickets/:id/signatures` (+ `POST`, `PATCH :stepKey` responses) | `field-tickets.controller.ts` | `ticket-signatures.service.ts` | `ticket-signatures.repository.ts` | REQ-02, REQ-04 |
| `POST` | `…/signatures/attachments` | same | `ticket-signatures.service.ts` → `ticket-attachment-guard` | `attachments.repository.ts` | REQ-03, REQ-07 |
| `GET` | `…/checklists/{pretrip,jsa,posttrip}` | same | `checklist-assignments.service.ts` | `checklist-assignments.repository.ts` | REQ-02 |
| `POST` | `…/checklists/{pretrip,jsa,posttrip}/submit` | same | `checklist-assignments.service.ts` `submitAnswers` | same | REQ-04 |
| `POST` | `…/checklists/attachments` | same | `checklist-assignments.service.ts` | `attachments.repository.ts` | REQ-03, REQ-07 |
| `GET`/`POST` | `…/lunch-breaks` (+ `/attachments`) | same | `ticket-lunch-breaks.service.ts` | `ticket-signatures.repository.ts` | REQ-02, REQ-03, REQ-05 |
| `GET`/`POST` | incident create/list and `…/incidents/:incidentId/attachments` | same | `ticket-incidents.service.ts` | `ticket-incidents.repository.ts` | REQ-02, REQ-03, REQ-04 |
| `GET` | `…/attachments` | same | `ticket-attachments.service.ts` | `attachments.repository.ts` | REQ-02, REQ-06 |
| `POST` | `…/attachments` | same | `ticket-attachments.service.ts` | same | REQ-06, REQ-07 |

Per endpoint:

- **Request DTO:** unchanged (uploads stay multipart POSTs; presigned upload is out of scope, intent.md §5).
- **Response shape:** `EntityImageCover` / `EntityImageListItem` per REQ-02; exact property names on each response: D6. Document rows carry a presigned download link: property name D6.
- **Guards / roles:** unchanged (intent.md §8): existing `AccessTokenGuard` and `getTicketForEmployeeAction` ownership checks.
- **Route param identity:** unchanged.
- **Errors:** unchanged; unsupported image content: `OPEN — see Q5`.
- **Pagination:** N/A — per-ticket lists, unchanged.
- **Module registration:** any provider constructor change (for example `TicketAttachmentGuardService` gaining `EntityImageProcessor`) requires every module providing it to provide the new dependency; boot `pnpm api:dev` once in any such unit (DI check). Provider/module map to be produced by the executor: `grep -rn "TicketAttachmentGuardService" apps/api/src --include=*.module.ts`.

## 5. Web surface — `apps/web`

`N/A — no web feature is built.` Web is touched only if `tcg-contract-tracer` finds a caller broken by a response-shape change (intent.md §5, §6). Established: `grep -rn "field/tickets" apps/web/src qa-automation` returns nothing, so web does not call the `/field/tickets/*` routes. Web `ticket-progress` reads `job-progress` (a separate response, §11a R10), unchanged.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** no new screens. Display sites touched (from `grep -rln "resolvePhotoUri\|/download" apps/mobile`): `components/field/photo-thumb.tsx`, `photo-preview-modal.tsx`, `signer-capture.tsx`, `signature-capture-field.tsx`, `deficiency-panel.tsx`, `features/field-ticket/steps/sig1/Sig1Body.tsx`, `steps/sig2/Sig2Body.tsx`, `steps/shared/checklist/checklist-units.ts`, `ChecklistEngine.tsx`, `steps/shared/signature/signature-rehydrate.ts`, `steps/start-work/lunch-breaks.tsx`; plus `lib/attachments.ts`.
- **Components:** one shared image component (REQ-08, D7); `design-system/primitives/avatar.tsx` already presigned-aware and unchanged.
- **Offline / sync behavior:** `NOT SPECIFIED` by any source for this change. ASSUMED — `local:<id>` and `file://` previews unchanged (nearest existing behaviour: local branches of `resolvePhotoUri`); after sync the presigned image loads. Uploads stay multipart and keep `clientUploadId` idempotency.
- **Touch targets:** 48 px (`apps/mobile/CLAUDE.md`).
- **Push / notifications involvement:** N/A.
- **Contracts:** zod contracts to update: `data/contracts/ticket-signature.contract.ts`, `checklist.contract.ts`, `ticket-incident.contract.ts`, `ticket-lunch-break.contract.ts`, `ticket-attachment.contract.ts`, and their parsers under `data/services/*`, plus mocks (`ticket-signatures.mock.ts`, `ticket-lunch-breaks.mock.ts`, `ticket-incidents.mock.ts`). Reuse the `cover` schema from `data/contracts/identity.contract.ts` (line 45–47).
- **Product intent:** read `field-ops/field-ops-mobile-INDEX.md`; this work resolves nothing in it.

## 7. Shared package — `packages/shared`

- **Types added / changed:** one new type `TicketImage = EntityImageCover & { originalUrl: string }` and one new constants file `ticket-image.ts` (D11); `EntityImageCover` and `EntityImageListItem` are reused unchanged. If D6 needs a document-link type, it is a G5-adjacent addition and is recorded in the PR.
- Both web and mobile consume `@tcg/shared` built `dist/`; build it before `pnpm typecheck`.

## 8. Permissions and tenancy

- **Roles permitted:** unchanged — existing ticket upload and read permissions (`NOT ON TICKET`, intent.md §8).
- **Roles denied:** `NOT SPECIFIED`.
- **Tenant isolation:** standard Prisma tenant extension; `attachment` is in `TENANT_SCOPED_MODELS`. The new `setCategory` method is tenant-scoped (D4). Presigned keys are built from the row's own `tenantCompanyId` (P3: owner's tenant, not the caller's).
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `category` | one of the labels in REQ-04 / REQ-05, max 100 characters | `intent.md` §4; `schema.prisma` `@db.VarChar(100)` | `[UNVERIFIED]` |
| Image upload size | `NOT SPECIFIED` for ticket routes (profile photos use `ENTITY_IMAGE_MAX_UPLOAD_BYTES` 25 MB, `packages/shared`); ticket routes' current limit is not changed by this spec | — | — |
| Accepted image types | `OPEN — see Q5` | — | — |

## 10. Tests

`not requested`. No new test files or cases (root `CLAUDE.md`; intent.md §5). Run the existing `attachment-photos.{service,read,cover,delete}.spec.ts`, `pnpm api:lint`, `pnpm api:build`, `pnpm api:test`, `pnpm typecheck`.

- Manual script (verification, not tests): on iOS open a field ticket and confirm each surface in R1 loads with no Bearer-on-`/download` request; confirm a WebP thumbnail and blur appear; confirm an image still loads after more than one hour; confirm an induced image error causes one refetch, not a loop; confirm a pre-change image still displays (blocked on Q3 for what "acceptable" means).
- Requirements with no testable acceptance criterion: REQ-09, REQ-10, REQ-11 (the `[OPEN]` ones).

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`. Uploads become synchronous image processing on the request (as profile photos are); the duration limit for a field upload on poor connections is not sourced.
- **Concurrency:** `clientUploadId` retry idempotency must hold when two copies race (`P2002` path in `storeUpload` today).
- **Audit / activity log:** N/A — profile-photo activity logs are owner-coupled and not applied to ticket images.
- **Migration/rollout order:** shared/service helper (U1) → API ticket uploads and reads → mobile. An older mobile build reading a new API: the new shape must not remove the bare id fields until old builds are out (D6 decides to keep both; callers on old builds are `OPEN` as part of rollout, not a product question).

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| R1 Mobile display sites (the 11 files in §6) | `resolvePhotoUri` + `/download` | REQ-01, REQ-08 | migrated to the shared component | intent.md §4 | `grep -rln "resolvePhotoUri\|/download" apps/mobile` |
| R2 `TicketSignatureResponse` and its mobile contract `ticket-signature.contract.ts` and mocks | response fields `signatureAttachmentId`, `identityPhotoAttachmentId` | REQ-02 | changes deliberately (gains image objects) | intent.md §4 | `grep -rln "signatureAttachmentId\|identityPhotoAttachmentId" apps/mobile apps/api/src apps/web/src packages/shared/src qa-automation` |
| R3 Checklist read responses and `checklist.contract.ts`, `checklist-rehydrate.ts`, `checklist-units.ts`, `ChecklistEngine.tsx` | `photoAttachmentId` | REQ-02 | changes deliberately | intent.md §4 | same grep, `photoAttachmentId` |
| R4 Lunch-break responses and `ticket-lunch-break.contract.ts`, `lunch-breaks.tsx`, `lunch-windows.ts`, `use-lunch-corrections.ts` | signature/identity ids | REQ-02 | changes deliberately | intent.md §4 | same grep |
| R5 Incident responses and `ticket-incident.contract.ts`, `use-incident-report.ts`, `incident-sheet.tsx` | `signatureAttachmentId`, evidence attachment ids | REQ-02 | changes deliberately; video evidence `OPEN — Q5` | intent.md §4 | same grep |
| R6 `GET /field/tickets/:id/attachments` and mobile `ticket-attachment.contract.ts`, `ticket-attachments.http.ts` | row shape | REQ-02, REQ-06 | gains link/cover | intent.md §4 | `grep -rn "listAttachments" apps/api/src apps/mobile` |
| R7 Mobile offline sync and local-attachment code (`sync/drain.ts`, `sync/verify.ts`, `local-attachments`, `capture.ts`) | attachment ids, `local:` refs | REQ-01 | unchanged | ASSUMED — only the display branch retires (plan; not a product source) | `grep -rn "local:" apps/mobile/features/field-ticket` |
| R8 Mobile file open/share `components/field/ticket-attachment-file.ts` | arraybuffer download | REQ-06 | changes deliberately; fallback kept | intent.md §4, §5 | `grep -rn "openAttachmentFile" apps/mobile` |
| R9 Profile photo `avatar.tsx`, `lib/profile-picture.ts`, `/users/me` `cover` | `EntityImageCover` | REQ-02 | unchanged (reused, not edited) | intent.md §4 | `grep -rn "cover" apps/mobile/data/contracts/identity.contract.ts` |
| R10 Web `ticket-progress` (`signature-block.tsx`, `jsa-signatures.tsx`, `checklist-results.tsx`, `step-bodies/incident.tsx`) and API `job-progress.service.ts` + `packages/shared/src/types/job-progress.types.ts` | separate `job-progress` response built from repository rows | REQ-02 | unchanged: this is a different response; web does not call `/field/tickets/*` (no match) | intent.md §5 (web out of scope except broken callers) | `grep -rn "field/tickets" apps/web/src qa-automation` returns nothing |
| R11 Web/other callers of `GET /attachments/:id/download` and `AttachmentsController.download` | route | REQ-01 | unchanged (kept as fallback) | intent.md §5 | `grep -rn "/download" apps/mobile apps/web/src` |
| R12 Anything reading `Attachment.category` for ticket feature types, and generic attachment code treating `category` specially (`attachments.service.ts`, `isPoInvoiceAttachmentCategory`) | column | REQ-04 | not established whether any list filters on these categories | none | `grep -rn "\.category" apps/api/src/usecase/attachments apps/web/src` (to be run by the executor; not run to completion here) |
| R13 Readers of `Attachment.fileName` assuming a flat prefix | key shape | REQ-07 | old rows unchanged; new rows have a new shape | intent.md §7 | `grep -rn "buildKey\|fileName" apps/api/src/usecase/attachments apps/api/src/usecase/ticket-*` |

- **Surfaces with no existing behaviour in this area:** none; this is brownfield throughout.
- **Consumers with no source for what happens to them:** old-row presentation (REQ-09, Q3); video evidence and undecodable uploads (Q5); possible `category` readers (R12) — verify at the start of U1.

## 11b. AI decisions — reviewed by a developer

| ID | Decision | Chosen | Why / alternatives (with existing code found) | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | S3 key layout for new ticket files | images `tenants/{t}/job-tickets/{ticketId}/{group}/{attachmentId}/{variant}.webp`; documents `tenants/{t}/job-tickets/{ticketId}/documents/{uuid}.{ext}`; `{group}` fixed per feature (`signatures`, `checklist-photos`, `incident-evidence`); `ticketId` is `ticket.id`; `buildEntityImageKey` gains optional `subfolder` defaulting to `profile-pictures`, plus `buildTicketFileKey` | P3 rules: UUID/fixed names only, owner-tenant keys. `ticketCode` rejected as a key segment because it is user-visible text. Alternative: keep flat `buildKey` (rejected: intent.md §4 asks for an organised tree). Existing `buildKey` stays for old rows. Profile keys remain byte-identical. | no | | |
| D2 | Where variant generation lives | extract `storeImageVariants(keyPrefix, buffer) → { originalKey, thumbnailKey, placeholderDataUrl }` from `attachment-photos.service.ts:137-168` into the service/usecase layer; profile photos and ticket images both call it; all-or-nothing with cleanup | Reuse before new. Alternative: route ticket images through `AttachmentPhotosService` (rejected: coupled to owner, cover, activity log, `SINGLE_PHOTO_FEATURE_TYPES`). Behaviour-preserving for profile photos; guard with the existing specs. | no | | |
| D3 | Pattern placement | P3 sub-shape deviation: multiple images per ticket, no `cover_attachment_id`, existing ticket-scoped upload routes, no `/attachments/photos` | `patterns.md` P3 *Adding photos to a new entity* checklist does not fit (no owner cover). Follow-up: write a P3 sub-shape entry out for Haris (`.ai/**` is Haris-only) — §11c F1. | no | | |
| D4 | Writing `category` | new `AttachmentsRepository.setCategory(attachmentId, category)` that updates inside the tenant-scoped client, called at link time from `recordSignature`, `submitAnswers`; incident evidence sets it in `uploadAttachment` directly | Upload routes carry no step/type/break number (verified in `storeUpload`), so the label is link-time data. Alternative: add `stepKey` to upload requests (rejected: changes request DTOs and mobile offline queue for a metadata label). `Attachment` is already in `TENANT_SCOPED_MODELS`; the update must be keyed by `id` plus tenant so it cannot touch another tenant's row (G3 check by `tcg-prisma-guardian` on the unit). WTL labels written from `recordWorkedThrough` (it has its own path). | no (G3 run by guardian) | | |
| D5 | Presign-shape helper and old-row detection | one helper turns a row into `EntityImageCover` / `EntityImageListItem`; a row whose `fileName` is not a WebP variant key (flat `tenants/{t}/attachments/…`, no `placeholderDataUrl`) yields `thumbnailUrl = originalUrl = presigned original`, `placeholderDataUrl: null` | Mirrors `coverOf` returning the plain file for old covers (`attachment-photos.service.ts` ~L342-365). Detection by key shape / `placeholderDataUrl` null. Alternative: backfill (excluded by intent.md §5). Whether the result is acceptable to the crew is Q3. | no | | |
| D6 | Response property names | new image objects added beside the existing bare id fields (additive), for example `signatureImage`, `identityPhotoImage` on signatures; `cover` on single-image rows; `images: EntityImageListItem[]` for incident evidence; a download link on document rows; bare ids kept | Additive keeps older mobile builds working (mobile ships through stores) and limits G5 breakage. Alternative: replace ids (rejected: breaks old builds and the mobile offline queue that keys on ids). Names are not stated by the ticket ("same field name" is read as the same field **shape** names). Developer to confirm names at sign-off. | yes — G5, via `tcg-contract-tracer` | Haris (confirmed additive, names as listed) | 2026-10-28 |
| D7 | Shared mobile component | new `components/field/attachment-image.tsx` generalising `avatar.tsx` (no `Authorization` on `X-Amz-Signature` URLs; prefer `localUri`; blur beneath; one `onExpired` refetch) | One component per intent.md §4. Alternative: reuse `avatar.tsx` directly (rejected: round avatar, no full-screen/original). Search all mobile component directories before creating. | no | | |
| D8 | Expiry handling | on image error call `onExpired` once so the owning query refetches a fresh link; one retry; no loop | Mirrors `avatar.tsx` and web `photo-tile-stage`. | no | | |
| D9 | Documents | presigned link built from the stored key per document row (`presignGetUrl(fileName)`); `/download` stays as offline fallback | Smallest change; no variants for non-images. | no | | |
| D10 | Generic `POST /attachments` and profile pictures | untouched | P3 Rules: profile category refused on the generic route; out of scope. | no | | |
| D11 | Ticket-only image profile (mobile preview size) | `EntityImageProcessor.process(input, profile = ENTITY_PROFILE)`; the default keeps today's output (160 px square cover crop, 24 px blur), so profile photos stay byte-identical. New ticket profile: preview 640 px longest side, `fit: 'inside'` (aspect kept, no crop), WebP quality 80; placeholder 32 px wide blur; stored variants `original.webp` + `preview.webp`. New shared file `packages/shared/src/constants/ticket-image.ts`: `TICKET_IMAGE_PREVIEW_SIZE = 640`, `TICKET_IMAGE_PREVIEW_WEBP_QUALITY = 80`, `TICKET_IMAGE_PLACEHOLDER_WIDTH = 32`, `TICKET_IMAGE_VARIANTS = ['original','preview']`. New shared type `TicketImage = EntityImageCover & { originalUrl: string }`. Response field names stay `thumbnailUrl` (the presigned preview) and `placeholderDataUrl`; `originalUrl` for full-screen. `ENTITY_IMAGE_THUMBNAIL_SIZE`, `ENTITY_IMAGE_PLACEHOLDER_WIDTH`, `ENTITY_IMAGE_VARIANTS`, `EntityImageCover` and `EntityImageListItem` are not changed. | Web never calls `/field/tickets/*` (elaborator check), so web is untouched; shared only gains exports. A 160 px square crop is too small and lossy for a mobile preview and cuts wide signatures. The three outputs per upload (original, preview, placeholder) match today's count, so processing cost is unchanged. The 640 / 80 / 32 numbers are proposals with no source. Larger placeholder is stored inline in `attachments.placeholder_data_url` and repeats in list responses (32 px is a small step up from 24 px). Alternative: keep 160 px and display from the 2048 px original (Q6 = C; rejected by Haris 2026-10-28: heavy downloads, no placeholder match). Old rows keep the D5 fallback. | yes — numbers 640 / 80 / 32 are unsourced | Haris (yes to the approach and numbers, 2026-10-28) | 2026-10-28 |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Reviewed by | Enumerated by |
| --- | --- | --- | --- | --- |
| F1 `patterns.md` P3 sub-shape entry | P3 | follow-up — write the proposed entry out for Haris (not edited here) | | `.ai/claude/contexts/patterns.md` §P3 |
| Mobile sales quotation attachments | none | `OPEN` — Q1 | | `grep -rln "/download" apps/mobile` |
| Mobile job artifacts (`job-artifacts.http.ts`) | none | `OPEN` — Q1 | | same |
| Web `ticket-progress` image rendering | none | no — out of scope (intent.md §5); separate `job-progress` response | | `grep -rn "AttachmentId" apps/web/src/features/ticket-progress` |
| Other users of `buildEntityImageKey` / the processor | P3 | applied — behaviour-preserving (D1, D2) | | `grep -rn "buildEntityImageKey\|EntityImageProcessor" apps/api/src` |
| Other attachment-owning ticket routes (`ticket-lunch-breaks`, `ticket-incidents`, `checklist-assignments`, `ticket-signatures`, `ticket-attachments`) | none | applied — U2–U4 in the plan | | `grep -rln "storeUpload\|attachmentGuard" apps/api/src` |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Six questions, one batch. None involves a decision the developer already made in intent.md §4.

### Q1 — Mobile scope beyond ticketing

- **Question:** Are sales quotation attachments and job artifacts on mobile (also streamed through the API today) in scope for this ticket, or ticketing only?
- **Options:**
  - A. Ticketing flow only; those surfaces become a follow-up ticket
  - B. Include job artifacts (permits, plans, POs on a ticket) but not sales quotation attachments
  - C. Include both
  - X. Other — say what
- **Answer:** A. Ticketing flow only; sales quotation attachments and job artifacts become a follow-up ticket. (Haris, 2026-10-27, accepted the recommendation)
- **Why it cannot be answered from what is written:** the request says "all the attachments and images in the mobile app, especially the ticketing flow"; intent.md §5 leaves them OPEN; `grep -rn "/download" apps/mobile` shows both still use the stream.
- **Blocked:** REQ-10 (those surfaces only; REQ-01..08 do not depend on it)
- **Candidates:** none: nothing written (searched `intent.md`, plan, `patterns.md` P3).
- **Owner:** Haris (requester)
- **Workaround, if any:** build ticketing flow only (option A) and leave the others untouched.
- **Status:** resolved — see decisions/2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md

### Q2 — Jira id

- **Question:** What is the Jira id for this work, so the folder, branch and `processed.log` line can be renamed?
- **Options:** free answer — a Jira key such as `SCRUM-###`
- **Answer:**
- **Why it cannot be answered from what is written:** the intent states no Jira id exists yet.
- **Blocked:** nothing in the build; blocks the folder rename, branch name and `processed.log` line.
- **Candidates:** none: nothing written.
- **Owner:** Haris
- **Workaround, if any:** continue under the slug.
- **Status:** open

### Q3 — Images uploaded before this change

- **Question:** Is it acceptable that ticket images uploaded before this change show the original image as the thumbnail, with no blur placeholder and no WebP, and are not backfilled?
- **Options:**
  - A. Yes, acceptable
  - B. No — backfill the old images (this is a data rewrite, guardrail G2, and needs separate approval)
  - C. No — hide them behind a plain placeholder until loaded, but show the original
  - X. Other — say what
- **Answer:** A. Yes, acceptable: old ticket images show the original as the thumbnail, with no blur placeholder and no WebP, and are not backfilled. (Haris, 2026-10-27, accepted the recommendation)
- **Why it cannot be answered from what is written:** intent.md §7 says old rows "display through a fallback"; intent.md §12 asks to confirm acceptance; `patterns.md` P3 *Known deviations* handled old profile rows by deleting them, which is no precedent for ticket history.
- **Blocked:** REQ-09
- **Candidates:** none: nothing written.
- **Owner:** Haris
- **Workaround, if any:** implement the fallback of D5 (reads only; nothing destroyed). It is not shipped as accepted until answered.
- **Status:** resolved — see decisions/2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md

### Q4 — Labels for items the table does not name

- **Question:** What `category` should these links get: the incident's customer signature, the checklist signature, the lunch WTL identity photo, and an identity photo or signature on the `compliance` step?
- **Options:**
  - A. Leave `category` empty for all four
  - B. Give each its own label — reply with the four strings
  - C. Reuse the nearest existing label (for example `Incident Evidence` for the incident signature)
  - X. Other — say what
- **Answer:** C. Reuse the nearest existing label. (Haris, 2026-10-28.) Mapping derived from option C, to be confirmed at review: incident customer signature → `Incident Evidence`; checklist signature → the checklist's own label (`Pre-Trip Checklist` / `Post-Trip Checklist` / `JSA Checklist`); lunch WTL identity photo → its `Lunch WTL n` label (n = `breakIndex + 1`); compliance-step identity photo or signature → `Compliance Signature`.
- **Why it cannot be answered from what is written:** intent.md §4 names nine items plus four lunch labels; the code links four more kinds of attachment (`TicketIncidentsService.create` uses a `TICKET_SIGNATURE` attachment with step key `incident:<uuid>`; `ChecklistAssignmentsService.saveChecklistSignature`; `recordWorkedThrough` with optional `identityPhotoAttachmentId`; `recordSignature` allows an identity photo on any step).
- **Blocked:** REQ-11
- **Candidates:** none: nothing written.
- **Owner:** Haris
- **Workaround, if any:** leave those `category` values empty (their current value).
- **Status:** resolved — see decisions/2026-10-28-ticket-attachment-category-labels.md (option C decided; the derived mapping is still to be confirmed at review)

### Q5 — Incident video and unreadable image uploads

- **Question:** Incident evidence can be photo or video. Which presentation is wanted for video evidence, and should an image upload the server cannot decode be rejected (it is accepted today)?
- **Options:**
  - A. Video is stored as a plain file with a presigned link (no variants); an undecodable image is rejected with an error
  - B. Video is stored as a plain file with a presigned link; an undecodable image is stored as a plain file the same way
  - C. Video is out of scope for this change (stays on `/download`)
  - X. Other — say what
- **Answer:** A. Video is stored as a plain file with a presigned link (no variants); an image upload the server cannot decode is rejected with an error. (Haris, 2026-10-27, accepted the recommendation)
- **Why it cannot be answered from what is written:** `incident-sheet.tsx` offers "Add photo/video evidence"; the plan maps incident evidence to image gallery objects only; `EntityImageProcessor` throws `UnsupportedEntityImageError` on content it cannot decode, which the ticket routes do not do today. No source says what the crew should see or whether rejecting is acceptable.
- **Blocked:** REQ-03 edges; REQ-02 incident evidence shape
- **Candidates:** none: nothing written.
- **Owner:** Haris
- **Workaround, if any:** treat non-`image/*` incident files as plain files with a presigned link, labelled a workaround.
- **Status:** resolved — see decisions/2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md

### Q6 — Signature thumbnails

- **Question:** Signatures are wide images, and the shared processor makes a 160 px square thumbnail by cropping. Should signature and identity-photo display use the cropped thumbnail, or a thumbnail that keeps the whole image?
- **Options:**
  - A. Use the existing cropped square thumbnail everywhere
  - B. Use a thumbnail that keeps the whole image for signatures only
  - C. Display signatures from the original (up to 2048 px) rather than the thumbnail
  - X. Other — say what
- **Answer:** revised 2026-10-28 (Haris). First answer was C (display from the 2048 px original). Superseded by D11: ticket images get a ticket-only 640 px aspect-preserving preview (`fit: 'inside'`, no crop) served as `thumbnailUrl`, with a 32 px blur as `placeholderDataUrl`. Signatures and identity photos display from that preview; the original (`originalUrl`) is used only for the full-screen/zoom view. This is option B in effect (a thumbnail that keeps the whole image), applied to every ticket image rather than signatures only.
- **Why it cannot be answered from what is written:** `entity-image-processor.ts` uses `fit: 'cover'` for the thumbnail and `fit: 'inside'` for the original; no source states the aspect or size at which a signature is shown. This affects what the crew sees on a signed legal record.
- **Blocked:** REQ-03 (signature images); REQ-02 signature shape
- **Candidates:** none: nothing written.
- **Owner:** Haris
- **Workaround, if any:** none that avoids the choice; the build can proceed on non-signature images.
- **Status:** resolved — see decisions/2026-10-28-ticket-images-640-px-preview-32-px-blur-original-on-zoom-additive-fields.md

### Q7 — A queued upload the server refuses (raised by U1)

- **Question:** With Q5 = A, an image the server cannot decode now returns 400 on every image upload route that has been migrated (U1: signatures and identity photos). On the phone, `sync/drain.ts` treats any non-409 failure the same way: the step is marked `failed` with the server's message, the run stops at that step, and the same file is sent again at the next drain (reconnect, app open, manual retry). Nothing retries on a timer, but a file that can never decode keeps the ticket's later steps from syncing until the crew retakes the photo. What should happen to such a queued upload?
- **Options:**
  - A. Leave it: the step shows the server's message and the crew retakes the photo (today's behaviour for every other 4xx)
  - B. Treat a 400 on an upload as permanent: drop the queued file, mark the step for retake, and let later steps sync
  - X. Other — say what
- **Answer:** A. Leave it: the step shows the server's message and the crew retakes the photo (today's behaviour for every other 4xx). (Haris, 2026-10-28)
- **Why it cannot be answered from what is written:** spec R7 says the offline queue is "unchanged" (ASSUMED); no source says whether a permanent refusal should block later steps. Camera and signature-pad files are always decodable (JPEG, PNG, HEIC), so this is a corner case, not a daily one.
- **Blocked:** nothing. U1 ships the rejection as Q5 = A requires; only the mobile handling of the refusal waits.
- **Owner:** Haris
- **Workaround, if any:** option A (existing behaviour), labelled as a workaround.
- **Status:** resolved — see decisions/2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md

### Q8 — Where the crew sees filed incident evidence (raised by U3)

- **Question:** The mobile app has no screen that shows an incident after it is filed. `incident-sheet.tsx` is the capture form only (it lists picked file names and closes on submit), and `useTicketIncidents` has no caller. The API now returns presigned links for incident photos, videos and the customer signature, but nothing on the phone displays them, so REQ-01 and REQ-08 have no incident display site to migrate. Should this work add one?
- **Options:**
  - A. No: ship the API links and the parsed contract only; a viewing screen is a separate ticket
  - B. Yes: add a read-only list of the ticket's filed incidents (photo gallery with blur, signature, video opened from its link), reachable from the SOS overlay or the ticket; say where
  - X. Other - say what
- **Answer:** A. No viewing screen in this work: ship the API links and the parsed contract only; a read-only incident viewer is a separate ticket. (Haris, 2026-10-28, accepted the recommendation)
- **Why it cannot be answered from what is written:** units.md U3 says "find how video is shown today before changing (not in spec)". Found: it is not shown anywhere. A new screen is client-facing behaviour nobody specified (G1).
- **Blocked:** the mobile display half of U3 (REQ-01 and REQ-08 incident sites, opening video from the link). The data layer is built: contract, parser, mock and `useRefreshTicketIncidents`.
- **Owner:** Haris
- **Workaround, if any:** none; nothing is displayed today, so nothing is broken.
- **Status:** resolved — see decisions/2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md. Follow-up ticket: read-only incident viewer.

## 13. What this spec deliberately does not specify

- Scope of sales quotation attachments and job artifacts — no source; see Q1.
- Acceptability of old-image fallback — no source; see Q3.
- `category` for incident signature, checklist signature, WTL identity photo, compliance identity photo — no source; see Q4.
- Video evidence and undecodable image handling — no source; see Q5.
- Signature thumbnail aspect — no source; see Q6.
- How many lunch thresholds the product has — sources conflict; see REQ-05 and `payroll/gaps.md#field-ops-lunch-capture-vs-payroll-wtl`. This work takes no side.
- Upload size limits and performance targets for ticket routes — `NOT SPECIFIED`.
- New roles or permissions — none; existing ones unchanged.
- Acceptance criteria — the request has none (intent.md §3); those in this spec are derived and need the developer's confirmation at sign-off.
- Tests — `not requested`.

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person (REQ-09, REQ-10, REQ-11)
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` (REQ-05: this work takes no side; a note is only needed if product decides the lunch threshold count)
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every requirement's **Edges** fields are filled (`ASSUMED` allowed) or point at a §12 question
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] A developer has reviewed §11b and §11c (_Reviewed by_), and answered every `needs developer` row (D6)
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________
