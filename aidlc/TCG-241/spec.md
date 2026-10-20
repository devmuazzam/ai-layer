# Spec — TCG-241 Asset photos with cover, thumbnail and blur placeholder

> Written by the elaborator from `.ai/aidlc/TCG-241/intent.md`. Nothing has been built.
> Source tags: `[UNVERIFIED]` = never adjudicated (everything here except `decision` notes);
> kind is stated on every line. Ticket = Linear `TCG-241` (read via intent.md snapshot,
> captured 2026-10-20; the live ticket was not re-fetched this run — see §13).

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-241` (Linear) |
| Intent | `.ai/aidlc/TCG-241/intent.md`, captured `2026-10-20` |
| Elaborated on | `2026-10-20` |
| Vault state at elaboration | assets module read by anchor only (`assets/gaps.md` is 168 KB, grepped); six `domain/` files verified, none relevant; no `<topic>-INDEX.md` conflict stub covers asset photos |
| Open questions raised by this spec | 11 product (Q1–Q7, Q9–Q12; Q8 unused), all in §12; 12 developer decisions (D1–D12) in §11b |
| Already-shipped behaviour reached | 7 consumers in §11a; 4 with no source for what happens to them (Q9, Q10, Q11, Q12) |
| Rules consulted | `.ai/claude/contexts/api.md`, `prisma.md`, `web.md`, `patterns.md`, root `CLAUDE.md` (Identity, Developers decide structure, Siblings) |

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Multi-photo upload on asset Main tab (create + edit) | web, api | `[UNVERIFIED]` | TCG-241; `assets/gaps.md` (Brian 2026-10-20); `assets/asset-record-requested-additions.md` | no |
| REQ-02 | Preview tile with Set as cover / View / Delete | web | `[UNVERIFIED]` | TCG-241 | no |
| REQ-03 | Cover rules (auto, change, delete fallback, none) | api, web, schema | `[UNVERIFIED]` | TCG-241 | no |
| REQ-04 | Per-file rejection, valid files in batch still upload | web, api | `[UNVERIFIED]` | TCG-241 | partly (limit values: REQ-14) |
| REQ-05 | Three WebP variants per photo at fixed S3 layout | api | `[UNVERIFIED]` | TCG-241; D6 | partly (REQ-14) |
| REQ-06 | Original is WebP, as sharp as upload, smaller for typical JPG/PNG | api | `[UNVERIFIED]` | TCG-241 | partly (REQ-14) |
| REQ-07 | Delete removes DB record and all three S3 files | api | `[UNVERIFIED]` | TCG-241; Q6 | no |
| REQ-08 | Assets table shows cover thumbnail avatar, initials fallback | web, api | `[UNVERIFIED]` | TCG-241; `assets/gaps.md` | partly (Q9, D5) |
| REQ-09 | Blur placeholder first wherever a photo is shown | web | `[UNVERIFIED]` | TCG-241 | no |
| REQ-10 | Tenant isolation of list/view/delete | api | `[UNVERIFIED]` | TCG-241; `rule` prisma.md | no |
| REQ-11 | Generic reusable uploader, no asset code inside | web | `[UNVERIFIED]` | TCG-241 | no |
| REQ-12 | Tools & Riggings photo section unchanged | web, api | `[UNVERIFIED]` | TCG-241 | no |
| REQ-13 | New UI elements carry `data-testid` | web | `[UNVERIFIED]` | TCG-241; `rule` root CLAUDE.md | no |
| REQ-14 | Size limit, photo count, original dims/quality, thumbnail and placeholder size | api, shared, web | `[UNVERIFIED]` | §12 (Akif 2026-10-20) | no |
| REQ-15 | Who may upload / delete / set cover | api | `[UNVERIFIED]` | §12 (Akif 2026-10-20) | no |
| REQ-16 | Photos on Create before the asset exists | web | `[UNVERIFIED]` | §12 (Akif 2026-10-20) | no |
| REQ-17 | S3 folder when `unitCode` is edited | api | `[UNVERIFIED]` | D6 (Akif 2026-10-20) | no |
| REQ-18 | Mobile app involvement | mobile | `[UNVERIFIED]` | Q9 (Akif 2026-10-20) | no |

Counts: 18 total — 0 verified, 18 unverified, 0 conflicted, 0 open (REQ-14–18 answered 2026-10-20).

## 2. Requirements

### REQ-01 — Multi-photo upload on asset Main tab `[UNVERIFIED]`

- **Statement:** On Asset create and edit (Main tab, right sidebar) a user can upload one or more PNG, JPG or WEBP photos by drag-and-drop or click.
- **Surface:** web, api
- **Sources:**
  - `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 1.
  - `assets/gaps.md` (anchor *Grouping assets for fleet-maintenance inventory…*, Update 2026-10-20, Brian Petros, fourth message) — `[UNVERIFIED]` — kind: vault — Brian asks: "will I be able to upload pictures of them and get like a 'profile' picture of the asset that shows in the ERP?"
  - `assets/asset-record-requested-additions.md` §`*** Profile Pictures for Asset ***` — `[UNVERIFIED]` — kind: vault — one-line ask, no detail; the 2 MB limit there is FCC's, "not a requirement".
- **Conflict:** none
- **Open question:** none for the behaviour; limits in Q1/Q2; Create-flow in Q5.
- **Ripple:** Asset Main tab layout — `apps/web/src/features/assets/asset/components/edit-asset.helpers.tsx` (`MainTabContent`), `create-asset-layout.tsx`, `edit-asset-layout.tsx`. A "right sidebar" is named by the ticket; the current Main tab has no sidebar that was found (`grep -n "aside\|sidebar" create-asset-layout.tsx asset-form-sections.tsx` returned nothing). Layout placement is a §11b row (D8), not a requirement.
- **Acceptance:** On both create and edit, dropping or choosing 3 valid files yields 3 tiles.
- **Edges:**
  - **Reached by:** drag-drop, click-to-choose (ticket). Paste/camera capture: NOT in any source — not specified.
  - **Does not apply when:** Tools & Riggings (REQ-12); existing "Asset attachments" tab documents (categories General, Product Guide, … — `asset-attachment-categories.ts`) are a different feature; see Q10.
  - **When an input is absent:** no files chosen → nothing happens.
  - **Trust boundary:** client supplies file bytes, name, declared MIME; server must not trust declared MIME (decoder is the check) — D3.
  - **Read time:** `live`.
- **Notes for the executor:** existing mechanisms found, not chosen: generic `POST /attachments/upload` (`attachments.controller.ts:52`), single profile-picture flow (`entity-profile-picture.service.ts`), Tools pending-upload util (`upload-tool-photos.ts`). Choice is D1/D4.

### REQ-02 — Preview tile with actions `[UNVERIFIED]`

- **Statement:** Every uploaded photo appears as a preview tile with Set as cover, View and Delete actions.
- **Surface:** web
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 2; in-scope list adds "view larger, delete with confirm, per-file progress and errors". Design reference `my-docs/asset-image-uploader.html` (untracked, single image only; ticket says "refine the look") — kind: design, not a source of behaviour.
- **Conflict:** none
- **Open question:** none. Copy for confirm dialog, tile labels, error text: NOT SPECIFIED (ticket says only "a clear message for each file").
- **Ripple:** none — new surface only (established by: `git grep -n "assetImageCard\|AssetImage" -- apps/web/src` returns nothing; the design exists only in `my-docs/`).
- **Acceptance:** Each tile exposes the three actions; Delete asks for confirmation before removing.
- **Edges:**
  - **Reached by:** tile buttons only.
  - **Does not apply when:** the photo is already the cover — whether "Set as cover" is hidden, disabled or marked: NOT SPECIFIED (visual detail; the design file is the reference).
  - **When an input is absent:** zero photos → empty drop zone only.
  - **Trust boundary:** N/A — server-derived tile list.
  - **Read time:** `live`.
- **Notes for the executor:** reuse-before-create search (all nine `components/` dirs) is required; candidates found: `components/organisms/employee-upload-section.tsx`, `file-upload-card.tsx`, `features/profile-picture/`, `tool-cover-photos-section.tsx`, `tool-photos-gallery.tsx`. Decision D8.

### REQ-03 — Cover rules `[UNVERIFIED]`

- **Statement:** The first photo becomes cover automatically; the user can change cover to any other photo; deleting the cover promotes the next remaining photo; deleting the last photo leaves the asset with no cover.
- **Surface:** schema, api, web
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 3. Next cover = oldest remaining photo by upload time (Q3 A, Akif 2026-10-20).
- **Conflict:** none
- **Open question:** "next remaining" ordering — Q3.
- **Ripple:** the Tools pattern (`Tool.coverAttachmentId`, schema line ~668) is a sibling, not a consumer; not changed (REQ-12).
- **Acceptance:** four scripted cases: first upload; change; delete cover with others left; delete last.
- **Edges:**
  - **Reached by:** upload, set-cover, delete, (asset archive/delete — Q11).
  - **Does not apply when:** batch of several first uploads — which becomes cover? ticket says "the first photo": the first file in the dropped batch becomes cover (Q3 A).
  - **When an input is absent:** no photos → no cover.
  - **Trust boundary:** server derives cover; client only requests a change to an id of the same tenant+asset.
  - **Read time:** `live`.
- **Notes for the executor:** where cover is stored is D2.

### REQ-04 — Per-file rejection `[UNVERIFIED]`

- **Statement:** Non-images and files over the limit are rejected with a message per file; valid files in the same batch still upload.
- **Surface:** web, api
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 4. Limit value: none (Q1).
- **Conflict:** none
- **Open question:** limit value — Q1.
- **Ripple:** none — new surface only.
- **Acceptance:** drop 1 PDF + 1 over-limit PNG + 1 valid JPG → two named errors, one tile.
- **Edges:**
  - **Reached by:** client-side pre-check and server check (both must exist; client is not trusted).
  - **Does not apply when:** HEIC/HEIF, GIF, SVG — ticket lists PNG, JPG, WEBP only; treatment of others is "not an image/unsupported" per ticket; HEIC from phones is not discussed anywhere — Q1.
  - **When an input is absent:** empty file (0 bytes) — NOT SPECIFIED.
  - **Trust boundary:** server re-validates type and size; decoder failure = rejection.
  - **Read time:** N/A.
- **Notes for the executor:** profile-picture flow shows the existing shape (`PROFILE_PICTURE_*` constants in `packages/shared/src/constants/profile-picture.ts`) — pattern evidence only.

### REQ-05 — Three WebP variants at fixed S3 layout `[UNVERIFIED]`

- **Statement:** For each photo S3 holds `original.webp`, `thumbnail.webp` (small square) and `placeholder.webp` (tiny blurred) under `tenants/{tenantId}/assets/{assetId}/{imageId}/` (`assetId` = asset UUID, not `unitCode`).
- **Surface:** api
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 5 and in-scope list (ticket updated 2026-10-20 to the asset-UUID path). Developer decision D6 — Akif (2026-10-20, Claude Code session). Code today (`s3-storage.service.ts` `buildKey` → `tenants/{tenantId}/attachments/{fileName}`, flat) — kind: code, descriptive only.
- **Conflict:** none
- **Open question:** sizes — Q1; sync vs async processing — D9. (`unitCode` rename no longer affects keys — D6.)
- **Ripple:** `S3StorageService.buildKey` is used by `attachments.controller.ts:73`, `quotations.controller.ts:344`, `entity-profile-picture.service.ts:78`, `signed-copy-attachments.service.ts:153,207`, `ticket-attachment-guard.service.ts:77` — they must keep producing the flat key; a nested-key helper must be additive (enumerated by `git grep -n "buildKey" -- apps/api/src`). Unchanged is the only safe reading but no source says it — treated as the executor's constraint, not a product decision.
- **Acceptance:** after one upload, exactly three objects exist under the folder with those names and `image/webp` content type.
- **Edges:**
  - **Reached by:** upload endpoint only.
  - **Does not apply when:** Tools photos, profile pictures, general attachments keep flat keys.
  - **When an input is absent:** asset UUID always present (PK).
  - **Trust boundary:** all keys server-built from tenant UUID, asset UUID and image UUID; no user text in the path.
  - **Read time:** N/A.
- **Notes for the executor:** no image library is installed (`grep -n "sharp" apps/api/package.json` empty) — D3. Failure mid-way (variant 2 of 3 fails) cleanup behaviour NOT SPECIFIED; see D9.

### REQ-06 — Original is high-quality WebP, smaller for typical JPG/PNG `[UNVERIFIED]`

- **Statement:** The stored original is WebP, visibly as sharp as the upload, and smaller in bytes than the upload for typical JPG and PNG photos.
- **Surface:** api
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 6; in-scope list says "capped max size". Cap and quality value: none (Q1). TCG-201 (mobile compression) — kind: jira, context only, not a source for server values.
- **Conflict:** none
- **Open question:** Q1.
- **Ripple:** none — new surface only.
- **Acceptance:** for a sample JPG and PNG the stored original is WebP and smaller than the upload (ticket). Every upload is re-encoded (Q1); a WebP upload may come out larger, which is accepted.
- **Edges:**
  - **Reached by:** upload only.
  - **Does not apply when:** input already WebP — always re-encoded (Q1).
  - **When an input is absent:** N/A.
  - **Trust boundary:** server re-encodes; orientation applied, then all EXIF (incl. GPS) stripped (Q1).
  - **Read time:** N/A.
- **Notes for the executor:** blocked on Q1 for numbers.

### REQ-07 — Delete removes record and all three files `[UNVERIFIED]`

- **Statement:** Deleting a photo removes its database record and all three S3 files.
- **Surface:** api
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 7. Tension with `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` — decision note (status `reference`, not `[VERIFIED]`; decided by Fouzan Shakil, a developer, not product): "Everything should be archivable instead of deletable". The ticket and the note disagree on whether a photo is hard-deleted; neither mentions photos.
- **Conflict:** not a vault `conflicts_with` conflict; a ticket-vs-decision tension. This spec does not resolve it — Q6.
- **Open question:** Q6.
- **Ripple:** existing attachment delete (`attachments.controller.ts:143-150`) deletes S3 then DB, with an open vault entry about orphaned rows (`dispatch/gaps.md`, anchor *Attachment delete runs S3 before the DB row…*, `Status: open`). A new delete path must choose its own ordering — D10.
- **Acceptance:** hard delete (Q6 A): row gone, all three S3 objects gone; if it was the cover, the oldest remaining photo becomes cover (Q3).
- **Edges:**
  - **Reached by:** tile Delete; asset delete/archive (Q11).
  - **Does not apply when:** n/a.
  - **When an input is absent:** deleting an already-deleted photo — NOT SPECIFIED.
  - **Trust boundary:** server verifies tenant ownership of the image id.
  - **Read time:** N/A.
- **Notes for the executor:** blocked on Q6.

### REQ-08 — Assets table cover thumbnail avatar `[UNVERIFIED]`

- **Statement:** The Assets table shows each asset's cover thumbnail as its avatar; assets without a photo show the initials avatar; the table never downloads originals.
- **Surface:** web, api
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 8 and in-scope list. `assets/gaps.md` (Brian 2026-10-20) — `[UNVERIFIED]` — kind: vault — "get like a 'profile' picture of the asset that shows in the ERP".
- **Conflict:** none
- **Open question:** how the list learns about the cover (D5); what other asset lists/pickers/detail headers show (Q9).
- **Ripple:** see §11a rows 1–4. The Unit Code cell is `assets-list-view.columns.tsx:63` (`<Avatar initials=… size="sm" />`); the `Avatar` atom (`components/atoms/media/avatar.tsx`) already accepts `src`; it is also used by categories and sub-categories lists (unchanged). Other places that render an asset: `asset-select.tsx`, asset detail header — what they show: OPEN — Q9.
- **Acceptance:** list of N assets, K with covers → K thumbnail avatars, N−K initials; network panel shows no `original.webp` request.
- **Edges:**
  - **Reached by:** list endpoint response + image fetch per row.
  - **Does not apply when:** archived assets list (same table? NOT SPECIFIED).
  - **When an input is absent:** no cover → initials (ticket).
  - **Trust boundary:** server-derived.
  - **Read time:** `live` — a changed cover shows on next list load; cache invalidation behaviour: NOT SPECIFIED.
- **Notes for the executor:** images today are streamed through the API with an auth header (`GET /attachments/:id/download`; web uses `useAttachmentImageUrl`, 7 consumers: `git grep -c useAttachmentImageUrl`), so N rows ⇒ N authenticated requests with no presigned URLs; page size matters. D5.

### REQ-09 — Blur placeholder first `[UNVERIFIED]`

- **Statement:** Wherever a photo is shown, its blur placeholder appears first and is replaced by the real image once loaded.
- **Surface:** web
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 9; intent §10: "the blurry version … to show that until the original loads up".
- **Conflict:** none
- **Open question:** how the placeholder reaches the browser without an extra request — inline base64 in the list response (D5 B); transition animation: a short fade, executor's choice.
- **Ripple:** none — new surface only.
- **Acceptance:** with network throttled, tile/avatar shows blurred image, then sharp.
- **Edges:**
  - **Reached by:** tile, View lightbox, table avatar.
  - **Does not apply when:** placeholder missing/failed → fall back (initials or plain tile): NOT SPECIFIED.
  - **When an input is absent:** see above.
  - **Trust boundary:** server-derived.
  - **Read time:** `live`.
- **Notes for the executor:** none beyond D5.

### REQ-10 — Tenant isolation `[UNVERIFIED]`

- **Statement:** One tenant cannot list, view or delete another tenant's asset photos.
- **Surface:** api
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 10; `rule` `.ai/claude/contexts/prisma.md` (tenant scoping via `$extends`, not unconditional — a rule on how, not a source of what).
- **Conflict:** none
- **Open question:** none.
- **Ripple:** none — new surface only. If a new table is chosen it must be added to the scoped-model allowlist (check with `tcg-prisma-guardian`).
- **Acceptance:** tenant A token + tenant B image id → 404/403 on view and delete; list returns only A rows. S3 keys include tenantId but access is mediated by the API.
- **Edges:** Reached by: list/view/delete/set-cover endpoints. Does not apply when: none. When an input is absent: N/A. Trust boundary: image id and asset code come from the client; resolve `(tenant, code) → id` once. Read time: N/A.
- **Notes for the executor:** run `tcg-prisma-guardian` on any schema change.

### REQ-11 — Generic reusable uploader `[UNVERIFIED]`

- **Statement:** The uploader is a shared component with no asset-specific code inside; the asset screen uses it. It is generic over entity type + id so other entities' profile pictures can adopt it later.
- **Surface:** web
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 11, in-scope list; intent §2.
- **Conflict:** none
- **Open question:** none for the behaviour; component location/API is D8.
- **Ripple:** none — new surface only. Existing users/employees profile-picture flow is explicitly out of scope (intent §5) and is not migrated.
- **Acceptance:** `git grep -in "asset" <new component dir>` has no hits except in tests/stories; the asset screen imports it.
- **Edges:** Reached by: asset create/edit now; others later. Does not apply when: profile picture single-image flows. When an input is absent: N/A. Trust boundary: N/A. Read time: N/A.
- **Notes for the executor:** `components/` must not import from `features/` (CLAUDE.md invariant) — if the component sits in `components/`, its API calls are injected by props.

### REQ-12 — Tools & Riggings unchanged `[UNVERIFIED]`

- **Statement:** The Tools & Riggings photo UI and storage are unchanged.
- **Surface:** web, api
- **Sources:** `TCG-241` — `[UNVERIFIED]` — kind: jira — DoD item 12; intent §5.
- **Conflict:** none; **Open question:** none.
- **Ripple:** shared code that must not regress: `attachments.controller.ts` upload/download, `tool-cover-photos-section.tsx`, `use-attachment-image-url.ts`. Enumerated by `git grep -n "coverAttachmentId\|attachmentsApi.upload('TOOL'" -- apps`.
- **Acceptance:** Tools create/edit/detail photo flows behave as before (manual script); no diff in `features/assets/tools-riggings/` unless the developer decides otherwise (§11c).
- **Edges:** Reached by: n/a. Does not apply when: n/a. When an input is absent: N/A. Trust boundary: N/A. Read time: N/A.
- **Notes for the executor:** adopting the new uploader in Tools is a sibling decision, §11c, default out per ticket.

### REQ-13 — `data-testid` on new UI `[UNVERIFIED]`

- **Statement:** New UI elements carry `data-testid`.
- **Surface:** web
- **Sources:** `TCG-241` — jira — DoD item 13; `rule` `.ai/claude/contexts/web.md` → Test IDs (scheme).
- **Conflict:** none; **Open question:** none; **Ripple:** none — new surface only (`qa-automation` addresses by test ID; check `grep -rn` before renaming any existing one).
- **Acceptance:** each interactive element in the uploader has an ID following the web.md scheme.
- **Edges:** N/A — pure test hook.
- **Notes for the executor:** n/a.

### REQ-14 — Limits and image parameters `[UNVERIFIED]`

- **Statement:** Browser downscales each pick to ≤ 2048 px JPEG before upload (picked file ≤ 50 MB; HEIC only where the browser decodes it, else rejected with a message); upload max 10 MB after downscale; server accepts JPEG/PNG/WebP only; max 20 photos per entity (uploader prop, default 20; API enforces 20 for assets). Original: longest side ≤ 2048 px, WebP q82, EXIF stripped after applying orientation, always re-encoded. Thumbnail: 160×160 WebP, cover-cropped. Placeholder: ~24 px wide blurred WebP. (Q1, Q2)
- **Surface:** api, shared, web
- **Sources:** developer/product answer — Akif (2026-10-20, Claude Code session) (§12).
- **Conflict:** none

### REQ-15 — Roles `[UNVERIFIED]`

- **Statement:** Upload, delete and set-cover use the same permission as editing an asset. (Q4)
- **Surface:** api
- **Sources:** developer/product answer — Akif (2026-10-20, Claude Code session) (§12).
- **Conflict:** none

### REQ-16 — Photos on Create before the asset exists `[UNVERIFIED]`

- **Statement:** On Create, chosen photos are held in the browser and uploaded after the asset saves; failed uploads are listed, the asset stays created, retry from Edit. (Q5)
- **Surface:** web
- **Sources:** developer/product answer — Akif (2026-10-20, Claude Code session) (§12).
- **Conflict:** none

### REQ-17 — S3 folder when `unitCode` is edited `[UNVERIFIED]`

- **Statement:** Photo keys use the asset UUID, so editing `unitCode` never moves, renames or orphans photo objects. `unitCode` editing stays as it is today.
- **Surface:** api
- **Sources:** developer decision D6 — Akif (2026-10-20, Claude Code session) — "we can use asset uuid instead of unit code for asset images in s3".
- **Conflict:** none. Q7 resolved by this.
- **Notes for the executor:** no rename handling needed.

### REQ-18 — Mobile `[UNVERIFIED]`

- **Statement:** Out of scope. Cover shows in the web Assets table only. (Q9)
- **Surface:** mobile
- **Sources:** Akif (2026-10-20, Claude Code session).

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes — new `EntityImage` table (D1; shape D1a) and `Asset.coverImageId` (D2).
- **Migration required:** yes if any column/table is added (`pnpm db:migrate`, committed).
- **Data backfill required:** no (intent §7; assets without photos keep initials).
- **Existing models considered:**
  - `Attachment` (schema line 4588): `featureType` incl. `ASSET`, `featureId`, `category`, `fileName` (single S3 key), `mimeType`, `fileSizeBytes`. Holds one file per row — three variants + placeholder metadata do not fit one `fileName`; cover is not expressed. Reuse is possible with a convention (e.g. `fileName` = original key, sibling keys derived) — see D1.
  - `Tool.coverAttachmentId` (~line 668) — the existing cover pattern: a nullable UUID column on the parent pointing at an `Attachment`.
  - `Asset` (line ~913) — no image or cover column today.
- No new prefix/business code is introduced (intent §7). A new table, if chosen, is UUID PK only (like `Attachment`), parent FK by UUID, `onDelete` per D1.
- **Fields whose type/precision no source states:** values fixed by Q1; column shape fixed by D1a.

## 4. API surface — `apps/api`

- **Pattern:** none in `patterns.md` covers media/photos (P1 business-entity CRUD and P2 reference lists only). Nearest P1 for the asset module: `apps/api/src/presentation|usecase|service/asset-management/assets`. Photos pattern is a §11b row (D12).
- **Existing to reuse (found, not chosen):** `S3StorageService.putObject/getObjectStream/deleteObject/buildKey`; `AttachmentsService`; `attachments.controller.ts` (`POST /attachments/upload`, `GET /attachments`, `GET /attachments/:id/download`, `DELETE /attachments/:id`); `EntityProfilePictureService` (validation, cap, MIME allow-list, delete); asset `assets.service.ts` archive/unarchive/update.
- **New exported functions/services proposed:** none decided — D1, D3, D4, D5, D9.
- Endpoints: under `asset-management/assets/:id/photos` (D4 B) — list, upload, set cover, delete, stream a variant. Exact paths/DTOs fixed by the decomposer; `tcg-contract-tracer` on the asset list shape change.
- **Module registration:** whichever module is chosen must be registered in `app.module.ts`; barrel `index.ts`; DI of `S3StorageService` into the new provider.

## 5. Web surface — `apps/web`

- **Routes:** existing `/asset-management/assets`, `/create`, `/[id]`, `/[id]/edit`; no new route.
- **Existing components to reuse (found):** `Avatar` (`components/atoms/media/avatar.tsx`, has `src`), `SectionCard`, `WorkspaceTable`, `employee-upload-section.tsx`, `features/profile-picture/`, `tool-cover-photos-section.tsx`, `tool-photos-gallery.tsx`, `use-attachment-image-url.ts`, `ConfirmDeleteModal`. `find-component` search is required before creating.
- **New components proposed:** shared multi-photo uploader — D8.
- **Table:** change confined to the Unit Code cell (`assets-list-view.columns.tsx`); no new search/filter. `searchPlaceholder` unchanged.
- **Forms:** photos are not a validated form field; failures are shown per file.
- **Server state:** TanStack Query; keys and invalidation (asset list + asset detail on cover change) decided with D4.
- **Colors/responsive:** theme variables; 44px targets.
- **Copy:** NOT SPECIFIED beyond the ticket's action names "Set as cover", "View", "Delete".

## 6. Mobile surface — `apps/mobile`

Out of scope (Q9).

## 7. Shared package — `packages/shared`

- Possible constants (allowed types, limits, response types) consumed by web and mobile — shape pending Q1 and D11. Anything added to the `@tcg/shared` public API reaches web and mobile (§11a).

## 8. Permissions and tenancy

- **Roles permitted/denied:** same as asset edit (Q4).
- **Tenant isolation:** standard `$extends` scoping plus tenant-scoped S3 prefix (REQ-10). Exception check for any new model: `tcg-prisma-guardian`.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Accepted types | PNG, JPG, WEBP | TCG-241 (design text) | `[UNVERIFIED]` |
| Max upload size | 25 MB after in-browser downscale (D17; was 10 MB); picked file ≤ 50 MB | Q1, Q1b, Akif 2026-10-20 | `[UNVERIFIED]` |
| Max photos per entity | 20 (uploader prop, default 20; API enforces 20 for assets) | Q2, Akif 2026-10-20 | `[UNVERIFIED]` |
| Original max dimensions / quality | longest side 2048 px, WebP q82 | Q1 | `[UNVERIFIED]` |
| Thumbnail size | 160×160 WebP | Q1 | `[UNVERIFIED]` |
| Placeholder size | ~24 px wide, blurred WebP | Q1 | `[UNVERIFIED]` |
| Error message text | NOT SPECIFIED ("a clear message for each file") | — | — |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | processor yields 3 WebP buffers; original smaller for sample JPG/PNG; rejects non-image | REQ-04–06 |
| Unit | cover rules: first / change / delete-cover / delete-last | REQ-03 |
| Integration (API) | tenant A cannot list/view/delete tenant B photo; delete removes row + 3 objects | REQ-07, REQ-10 |
| E2E / manual | upload multiple on create + edit; table avatar with and without photo; Tools photos unchanged | REQ-01, 08, 12 |

Requirements with no testable acceptance: REQ-14–18.

## 11. Non-functional

- **Performance:** NOT SPECIFIED; note N authenticated image requests per list page (REQ-08).
- **Concurrency:** first-cover assignment must be atomic (only set cover when the asset has none, in one transaction) so two parallel uploads cannot both become cover (Q3).
- **Audit / activity log:** `AttachmentsService` writes activity entries for `ASSET` attachments today (`AUDITED_ATTACHMENT_FEATURE_TYPES`); asset photos log their own entries on the asset: uploaded, removed, cover changed (Q10, Akif 2026-10-20).
- **Rollout:** schema → API → web.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| Assets table Unit Code cell | `assets-list-view.columns.tsx:63` | REQ-08 | changes deliberately (avatar) | TCG-241 | `git grep -n "Avatar" -- apps/web/src/features/assets` |
| Asset list/detail response shape (cover fields added) | Asset DTO / `mapAssetRow` (`use-assets-list-state.ts:57`) | REQ-08 | additive fields only (cover id, placeholder); other readers ignore them | Q9 A | `git grep -ln "assetManagementApi" -- apps/web/src` (119 files import it) |
| Mobile dispatch assets list | `apps/mobile/app/(dispatch)/assets.tsx` | REQ-08, 18 | unchanged (mobile out of scope) | Q9 A | `git grep -ln "assets" -- apps/mobile` |
| Other asset renderings (`asset-select.tsx`, detail header, PO/permit tabs) | asset identity display | REQ-08 | unchanged | Q9 A | `git grep -n "asset-select\|AssetSelect" -- apps/web/src` |
| Existing `ASSET` attachments (Attachments tab, categories General/Product Guide/…) | `attachments` list by `featureType=ASSET` | REQ-01 | unchanged — photos live in `EntityImage`, never in attachments | D1, Q10 | `git grep -n "featureType=\"ASSET\"\|'ASSET'" -- apps/api/src apps/web/src` |
| Asset archive / unarchive / delete | `assets.controller.ts:64,69,102` | REQ-03, 07 | archive: photos kept and shown; delete (`assets.service.ts` `remove`): photo rows and S3 files removed | Q11 A | `grep -n "@Post\|@Delete" assets.controller.ts` |
| `S3StorageService.buildKey` / `attachments` upload+download | shared storage service | REQ-05, 12 | unchanged (additive key helper only) | executor constraint, see REQ-05 | `git grep -n "buildKey" -- apps/api/src` |

- **Surfaces with no existing behaviour in this area:** photo uploader UI and processing — `git grep -in "sharp\|webp\|blurhash\|thumbnail" -- apps/api/src apps/api/package.json` found no image processing; no `assetImageCard` in `apps/web/src`.
- **Consumers with no source for what happens to them:** none (all answered 2026-10-20).

## 11b. Developer decisions — structure is the developer's call

Chosen/Decided by filled only from Akif's own words. Blank = not yet decided.

| ID | Decision | Options (existing code found) | AI note | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Where photos and variant metadata are recorded | A. Reuse `Attachment` (`featureType=ASSET`), original key in `fileName`, derive thumbnail/placeholder keys by convention (no new table; variants not queryable). B. Reuse `Attachment` plus a small child/side table for variant keys, dims, bytes (one new table). C. New `AssetImage` table (id, tenantCompanyId, assetId FK UUID, three keys, width/height/bytes, position, createdAt; `onDelete` Cascade/Restrict to choose). X. Other | One-to-many with own lifecycle (cover, ordering, 3 keys) argues for C or B; A keeps the generic `/attachments` list and activity log coupling (Q10). Trade-offs only; no pick. | C — a new **generic** table named `EntityImage` (not `Attachment`; attachments unchanged). Column shape: see D1a. | Akif | 2026-10-20 |
| D1a | `EntityImage` column shape | `id` UUID PK (also the `{imageId}` S3 folder) · `tenantCompanyId` UUID · `entityType` new enum `ImageOwnerType { ASSET }` · `entityId` UUID (no FK — generic; asset delete removes rows in the service) · `originalName` varchar(255) · `width` Int · `height` Int · `sizeBytes` Int (stored original) · `placeholderDataUrl` Text (D5) · `uploadedById` UUID? FK User `SetNull` · `createdAt`. Index `(tenantCompanyId, entityType, entityId, createdAt)`. No S3-key columns: keys are derived as `tenants/{tenantId}/assets/{entityId}/{id}/{original,thumbnail,placeholder}.webp`. Must be added to the tenant `$extends` allowlist (guardian check). | Alternative B: same plus three S3-key columns. | A — as listed (no S3-key columns; keys derived from IDs) | Akif | 2026-10-20 |
| D2 | How cover is stored | A. `Asset.coverImageId` nullable UUID FK (mirrors `Tool.coverAttachmentId`). B. `isCover` boolean on the image row with a partial unique index (one cover per asset). C. Lowest `position` is the cover (no flag). X. Other | A matches the Tools reference and is cheap for the list join; B/C avoid a circular FK. | A — `Asset.coverImageId` nullable UUID FK → `EntityImage.id`, `onDelete: SetNull` (mirrors `Tool.coverAttachmentId`) | Akif | 2026-10-20 |
| D3 | Image-processing dependency (none installed) | A. `sharp` (native, widest WebP/blur support). B. `jimp` (pure JS, slower, weaker WebP). C. `@squoosh/lib` or wasm lib. D. Client-side conversion only. X. Other | Server-side conversion is required by the ticket ("server converts"), so D is likely out; check Docker/Node 22 base image for sharp's native binary. | A — `sharp`. Compression, thumbnail and placeholder apply **only to asset profile images** for now; no other upload path changes. | Akif | 2026-10-20 |
| D4 | Endpoints | A. Reuse generic `POST /attachments/upload` and post-process in a hook. B. New asset-photo endpoints under `asset-management/assets/:id/photos` (list, upload, set-cover, delete, variant stream). C. New generic `/entity-images/:entityType/:entityId/...` (matches the "reusable for other entities later" intent). X. Other | Generic uploader (REQ-11) pairs naturally with C; B is simpler now. Any new route is a structural decision. | B — asset-scoped endpoints under `asset-management/assets/:id/photos` (list, upload, set cover, delete, stream variant) | Akif | 2026-10-20 |
| D5 | How the table and tiles get thumbnail + placeholder bytes | A. Stream each variant via authenticated API endpoint (as `useAttachmentImageUrl` does today): N requests per page. B. Inline the tiny placeholder (base64 data URI stored in a DB column) in the list response, stream the thumbnail lazily. C. Introduce presigned S3 GET URLs (a first in this codebase). X. Other | A needs no new infrastructure; B gives the placeholder with zero extra requests but adds a column; C changes the "no presigned URLs" status quo. The ticket also wants the placeholder stored as a file (DoD 5), so B would duplicate it. | B — the list response carries the cover's tiny placeholder inline (base64, from a DB column); the thumbnail is streamed lazily per row. The placeholder file is still written to S3 (DoD 5) | Akif | 2026-10-20 |
| D6 | S3 folder naming (`{unitCode}` per ticket) and rename handling | A. Key by `unitCode` as ticket says; rename is blocked while photos exist. B. Key by `unitCode`; on rename copy+delete all objects (transaction-like job). C. Key by asset UUID instead (deviates from ticket). X. Other | Product side of rename is Q7. `unitCode` is free text up to 50 chars — a path needs encoding/sanitising. | C — key by asset UUID: `tenants/{tenantId}/assets/{assetId}/{imageId}/{original,thumbnail,placeholder}.webp`. Tenant-scoped. | Akif | 2026-10-20 |
| D7 | Create-flow mechanics (after Q5) | A. Pending files held client-side, uploaded after the asset save (Tools pattern). B. Stage uploads to a temp key before save and attach on save. X. Other | Depends on Q5. | A — pending files held client-side and uploaded after the asset save (Tools pattern) | Akif | 2026-10-20 |
| D8 | Uploader component placement and API | A. New component in `components/organisms/` (or a new `components/media/`), props: `uploadFn`, `listFn`, `entityType`, `entityId`, callbacks. B. New `features/media/` feature folder with its own hooks. C. Extend `employee-upload-section.tsx` / `features/profile-picture/`. X. Other | `components/` may not import `features/`; props-injected API calls keep it generic. Where it sits in the Main tab (the current tab has no sidebar) is also yours. | A — shared component under `apps/web/src/components/` (no `features/` imports); list/upload/delete/set-cover functions passed in as props. Placement: Main tab, right-hand card, per design | Akif | 2026-10-20 |
| D9 | Processing mode and failure handling | A. Synchronous in the request; all-or-nothing, cleanup of partial objects on failure. B. Asynchronous job; row `PROCESSING` then `READY`. X. Other | Batch uploads of large phone photos at synchronous CPU cost could hold requests; no queue pattern was checked for this repo. | A — synchronous in the request; if any variant fails, already-written objects are deleted and no row is created | Akif | 2026-10-20 |
| D10 | Delete ordering (DB vs S3) | A. DB row first (transaction), S3 delete after commit, tolerate missing object. B. S3 first (current attachments behaviour — has an open vault entry about orphans). C. Soft-delete row, async reap (depends on Q6). X. Other | Known issue: `dispatch/gaps.md` *Attachment delete runs S3 before the DB row…*. | A — DB row first (transaction, incl. cover re-pick), then S3 deletes after commit, tolerating missing objects | Akif | 2026-10-20 |
| D11 | Shared constants / types in `packages/shared` | A. Add `ASSET_IMAGE_*` constants + response types. B. Keep server-only. C. Generic `IMAGE_UPLOAD_*` constants reusing `PROFILE_PICTURE_*` where equal. X. Other | Anything exported reaches web and mobile. Waits on Q1. | A — limits/types in `packages/shared` so web and API use the same values (names follow the generic table, e.g. `ENTITY_IMAGE_*`) | Akif | 2026-10-20 |
| D12 | Pattern for media-owning entities | A. Follow P1 module layout for a new `asset-images` module. B. Extend the existing asset module. C. Record as a new `patterns.md` entry (Haris-only edit). X. Other | `patterns.md` has no media pattern; the final shape likely becomes the reference for later entities. | A — new module following the P1 layout (presentation/usecase/service), named after the generic table (`entity-images`); asset routes in D4 call it | Akif | 2026-10-20 |
| D13 | Client-side downscale before upload (Q1b) | A. Private helper inside the uploader component using `createImageBitmap` + canvas `toBlob` (no dependency). B. Add a library (`browser-image-compression`). C. No client step. | Nothing in `apps/web` resizes images today; mobile `apps/mobile/lib/image-compression.ts` uses `expo-image-manipulator` and cannot be reused on web | A | Akif | 2026-10-20 |
| D1a-null | Nullability of `EntityImage` columns | A. All NOT NULL except `uploadedById` (nullable, FK SetNull). B. Make metadata columns optional. | Every upload always produces name, size, dimensions and placeholder | A | Akif | 2026-10-20 |
| D1a-enum | Name of the owner-type enum | A. `ImageOwnerType`. B. `ImageEntityType`. C. `EntityImageType`. | Originally `EntityImageEntityType` (redundant); column stays `entity_type`, value `ASSET` | A | Akif | 2026-10-20 |
| D14 | Activity-log shape for photo events (Q14) | A. `UPDATED` + `photo` payload + renderer branch. B. Reuse `QUOT_RESOURCE_ADDED`. C. New enum members + migration. | Mirrors sub-categories' `logCustom('UPDATED', {linkedSubCategory})` | A | Akif | 2026-10-20 |
| D15 | HEIC support everywhere (supersedes Q1b's "Safari only") | A. Server decodes HEIC with `heic-decode` (ISC; depends on `libheif-js`, LGPL) then `sharp` as usual; `image/heic`/`image/heif` added to the allowed types; HEIC skips the browser downscale (files are 2–5 MB). B. Browser converts with `libheif-js`. C. Keep Safari only. | New dependency; ~1–3 s CPU per HEIC on the server. Built in U9 with the MIME change; U2 keeps rejecting HEIC until then | A | Akif | 2026-10-20 |
| D16 | U2 over the PR budget (559 source lines / 19 files) | A. One PR with the `size-exception` label (reason: smallest working slice; ~⅓ comments). B. Trim to under 400. | A backend-only split is not a unit | A — Akif adds the label on the PR | Akif | 2026-10-20 |
| D17 | Upload cap after browser downscale (supersedes Q1's 10 MB) | A. 25 MB (matches the shared "Maximum allowed size is 25MB" message from `all-exceptions.filter.ts`). B. Keep 10 MB, accept up to 50 MB at multer so the service message shows. C. Fix the shared message app-wide. | Analyst U2 F1: multer `LIMIT_FILE_SIZE` returns the shared 25MB text, so a 10 MB cap told users the wrong limit | A — 25 MiB (`ENTITY_IMAGE_MAX_UPLOAD_BYTES`), service text "Photo must be 25 MB or smaller" | Akif | 2026-10-20 |
| D18 | Tenant for a photo upload (analyst U2 F2) | Use the asset's `tenantCompanyId`, never the caller's context — a SUPER_ADMIN is unscoped and could otherwise file a photo under the wrong tenant | Bug fix, not a structural choice; recorded for traceability | asset's tenant | — (fix) | 2026-10-20 |
| D19 | Asset lookup on photo reads (list + stream) | A. New light usecase/repository method returning only the asset's `id` and `tenantCompanyId` (scoped lookup, 404 when missing). B. Keep `assetsService.findById` (`findOneWithRelations`) per request. | U3 executor: up to 21 full-asset loads per Edit page (list + 20 thumbnails) | A | Akif | 2026-10-20 |
| D20 | How the browser gets thumbnail/original bytes (supersedes D5 B) | A. Presigned S3 GET URLs: the photo list returns `placeholderDataUrl` + `thumbnailUrl` + `originalUrl`; plain `<img src>` loads straight from S3; the per-image stream route is removed. B. Keep streaming through the API (D5 B). | A needs `@aws-sdk/s3-request-presigner` (same AWS SDK v3 family already used). Link lifetime 1 h; links signed per fixed time window so the URL is stable inside it and the browser cache works; the list refetches every ~50 min and on window focus, and a tile whose image fails refetches the list once. D19's light lookup stays for list + upload | A | Akif | 2026-10-20 |
| D21 | Presigned link lifetime | A. Sign per 1 h window (date floored to the hour), expiry 7200 s: every link has 1–2 h left and the URL is identical within the hour. B. Exactly 1 h per link with a short 5-min window (URL changes every 5 min). | Executor deviation from "3600 s" in the D20 brief: an hour window with 3600 s would leave a link issued at hh:59 with 1 s | A | Akif | 2026-10-20 |
| D22 | Browser caching of presigned images | A. `ResponseCacheControl: 'private, max-age=3600'` on the presigned GET (not on `getObjectStream`, which attachments use). B. Leave S3 heuristics. | Objects were stored without Cache-Control | A | Akif | 2026-10-20 |
| D8b | Uploader location and how it loads image bytes | A. `apps/web/src/components/organisms/entity-photos/` (precedent: `organisms/entity-notes/`); the feature passes an image-loading function as a prop (no `features/` import). B. New `components/media/` folder, same prop approach. | `useAttachmentImageUrl` lives in `features/` and cannot be imported from `components/` | A | Akif | 2026-10-20 |
| D23 | U4 copy and row behaviour (Q20) | A. Keep the U4 proposal as built. B. Change named items. | Rejections: "Photo must be a JPEG, PNG or WebP image", "Photo must be 25 MB or smaller" (binding client limit until U9 = 25 MiB upload cap), "File is empty", "Limit of {maxFiles} photos reached", "Couldn't check your photo count"; upload failure = server message, fallback "Upload failed". Rows "Waiting" / "Uploading N%" / "Processing…", Retry (upload failures) and Dismiss (any error row). Helper "Up to {maxFiles} photos", button "Add photos", description "JPEG, PNG or WebP, up to 25 MB.". Drop zone, button and Retry disabled while a batch runs | A — copy exactly as proposed; analyst R4 applied: a new batch **keeps** earlier failed/rejected rows until dismissed and appends new rows; uploaded rows are cleared; rows keyed and test-IDed by a monotonic row id (`<prefix>-upload-<id>`) | Akif (2026-10-21) | 2026-10-21 |
| D24 | Batch over the `maxFiles` cap | A. Valid files fill the free places in dropped order; the rest are refused on their own row. B. Refuse the whole batch | Client pre-check only; server cap is U5. Analyst R1/R2: the count is fetched fresh (`fetchQuery`, `staleTime: 0`) before each batch and each retry; if it cannot be fetched the files are refused with "Couldn't check your photo count" — 0 is never assumed; the list is re-fetched (awaited) after each upload | A | Akif (2026-10-21) | 2026-10-21 |
| D25 | Drop zone for the shared uploader | A. Reuse existing `components/atoms/inputs/dropzone-input.tsx` unchanged (outer chrome removed via `className`; zone test ID on a wrapper div). B. Drag handling written inside the uploader. C. Extend `DropzoneInput` with a zone test-ID prop | A adds nothing new; B duplicates drag logic; C changes a shared atom with two other consumers | A | Akif (2026-10-21) | 2026-10-21 |
| D26 | Where the batch logic lives | A. `components/organisms/entity-photos/photo-batch.ts`, pure helpers exported for the uploader and its `node --test` file only, not from the barrel (precedent U3 `photo-tile-stage.ts`). B. Inline private helpers in the uploader (not unit-testable) | — | A | Akif (2026-10-21) | 2026-10-21 |
| D27 | How per-file progress reaches the shared uploader | A. Optional `onProgress(loaded, total)` on `EntityPhotoUploadRequest`; the asset feature forwards axios `onUploadProgress`; `useUploadAssetPhoto`'s mutation argument becomes `{ file, onProgress }` | Analyst R5: "Processing…" only once `loaded >= total`; the percentage is floored (99.5% → "Uploading 99%") | A | Akif (2026-10-21) | 2026-10-21 |
| D28 | Upload concurrency within a batch | A. Sequential, one at a time, in dropped order. B. Limited concurrency (e.g. 2–3 at once) | Sequential order is what makes the first dropped file the first created (Q3, U5 cover rule). B was considered and **rejected** by Akif | A | Akif (2026-10-21) | 2026-10-21 |
| D29 | Toasts for photo uploads | A. Keep U2's per-file success/error toasts. B. No per-file toasts; the rows are the feedback | `useUploadAssetPhoto` was the only consumer of those toasts (`edit-asset-layout.tsx`); the toasts are removed from the hook | B | Akif (2026-10-21) | 2026-10-21 |
| D30 | Keep `placeholder.webp` in S3 although the list serves the DB base64 (D5) and nothing reads the S3 copy | A. Keep writing it (matches the ticket AC "S3 has original, thumbnail and placeholder"). B. Stop writing it; S3 holds original + thumbnail only; ticket AC updated | ~300 bytes and one extra PutObject per photo; the S3 copy is unread | A | Akif (2026-10-21) | 2026-10-21 |

**From `tcg-prisma-guardian` (2026-10-20).** Executor must-dos, not decisions: add `'entityimage'` to `TENANT_SCOPED_MODELS` (`apps/api/src/orm/prisma.service.ts:26`); `createdAt @db.Timestamptz()`; `@@map("entity_images")`, `idx_entity_images_*`; cover re-pick orders by `createdAt, id`; upload, photo delete and asset delete each in one transaction; the assets list loads the cover with one `include`/batched query and selects `placeholderDataUrl` only there.

| ID | Decision | Options | AI note | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| G-A | Cross-tenant cover integrity (guardian) | A1. App check: scoped lookup of the image by id + entityType + entityId before any cover write; spec test. A2. A1 + DB composite FK. | Guardian 2026-10-20 | A1 | Akif | 2026-10-20 |
| G-B | Index on `assets.cover_image_id` | B1. None. B2. Plain `@@index([coverImageId], name: "idx_assets_cover_image_id")`. B3. B2 built CONCURRENTLY. | Without it, every photo delete scans `assets` for the SetNull | B2 | Akif | 2026-10-20 |
| G-C | 20-cap and first-cover race | C1. Lock the asset row (`SELECT … FOR UPDATE` with explicit `tenant_company_id`) in the upload transaction. C2. Advisory lock. C3. Atomic cover only, soft cap. | Raw SQL is unscoped — must filter by tenant | C1 | Akif | 2026-10-20 |
| G-D | Asset hard delete leaves photos | D1. Rows deleted in the asset-delete transaction + `entityImage.deleteMany` in `clear-tenant-data.ts`. D2. D1 + delete each image's three S3 objects after commit. D3. Real FK. | Paths: `sub-categories.repository.ts:607` `deleteAsset`, `clear-tenant-data.ts:202`, `assets.service.ts` `remove` | D2 (demo-tenant wipe deletes rows only) | Akif | 2026-10-20 |
| G-E | S3 objects left after a failed post-commit delete | E1. Log and accept. E2. Reaper job. | | E1 | Akif | 2026-10-20 |
| G-F | `Tool.coverAttachmentId` has no FK, `Asset.coverImageId` will | F1. Keep FK on Asset; Tool untouched. F2. Fix Tool in a separate PR. | D2 mirrors the name, not the integrity | F1 | Akif | 2026-10-20 |
| G-G | `tenantCompany` relation on `EntityImage` | G1. Add `TenantCompany @relation` like `Attachment`. G2. Plain column. | | G1 | Akif | 2026-10-20 |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Decided by | Enumerated by |
| --- | --- | --- | --- | --- |
| Tools & Riggings cover photos (`tool-cover-photos-section.tsx`, `Tool.coverAttachmentId`) | cover photo | **No** — unchanged; WebP/thumbnail/placeholder only for asset profile images for now | Akif 2026-10-20 | `git grep -n "coverAttachmentId" -- apps` |
| Users/employees profile picture (`entity-profile-picture.service.ts`, `features/profile-picture/`) | single profile picture | **No** — unchanged for now; the uploader is reusable later | Akif 2026-10-20 | `git grep -ln "profile-picture\|ProfilePicture" -- apps` |
| Generic attachments (`attachments.controller.ts` upload/download, every `AttachmentFeatureType`) | file upload to S3 | **No** — attachments work exactly as now; asset profile images have nothing to do with them | Akif 2026-10-20 |
| Categories / sub-categories list avatars (initials) | list avatar | **No** — follow-up if wanted; uploader is reusable | Akif 2026-10-20 | `git grep -n "<Avatar" -- apps/web/src/features` |
| Asset detail/other asset renderings (Q9) | asset identity | **No** — Assets table only (Q9 A) | Akif 2026-10-20 | see §11a |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Letters are not ranked and none is a default.

### Q1 — Upload and image parameters

- **Question:** What are the upload size limit, original max dimensions and WebP quality, thumbnail size and placeholder size?
- **Options:**
  - A. One free answer per value (e.g. "10 MB; 2560 px long edge; quality 85; 256x256 square; 24 px wide") — `free answer`
  - B. Reuse the existing profile-picture limit (5 MB) for upload size and decide the rest
  - C. Reuse the general attachment limit (50 MB)
  - X. Other — say what
  - Sub-questions in same reply: accept HEIC? keep or strip EXIF/GPS? how to treat an already-WebP upload (re-encode or store as is)?
- **Answer:** Max upload **10 MB** per file (Akif's value). Rest accepted as proposed: original resized so the longest side is at most **2048 px**, WebP quality **82**; thumbnail **160×160** square (cover-cropped), WebP; placeholder about **24 px** wide, blurred, WebP. Accepted input JPEG/PNG/WebP only; **HEIC rejected**. EXIF (incl. GPS) **stripped**, orientation applied first. **Always re-encode**, including WebP uploads — Akif (2026-10-20, Claude Code session) **[HEIC part superseded by D15, Akif 2026-10-20: HEIC is accepted in every browser and decoded on the server.]** **Q1b (Akif 2026-10-20, option A):** the browser first downscales every picked photo to ≤ 2048 px longest side and re-saves it as JPEG (~0.9) using built-in browser APIs only (`createImageBitmap` + canvas `toBlob`; no new dependency); the **10 MB** cap applies to that downscaled file; a picked file may be up to **50 MB** before downscaling. HEIC works where the browser can decode it (Safari) and is converted to JPEG before upload; where it cannot (e.g. Chrome), the file is rejected with a clear message asking for JPG or PNG. The server still accepts JPEG/PNG/WebP only and does the WebP/thumbnail/placeholder work with `sharp`.
- **Why it cannot be answered from what is written:** intent §11 lists all as NOT ON TICKET; the FCC 2 MB figure is flagged "not a requirement"; profile-picture and general limits belong to other features.
- **Blocked:** REQ-04, 05, 06, 14
- **Candidates:** `assets/asset-record-requested-additions.md` (35 KB, 2026-09-04); `assets/tool-and-rigging.md` ("size limit", no value); `packages/shared/src/constants/profile-picture.ts`, `attachments.ts` (code, descriptive)
- **Owner:** product team (Brian Petros asked for the feature)
- **Workaround, if any:** none
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q2 — Maximum photos per asset

- **Question:** Is there a cap on photos per asset?
- **Options:**
  - A. No cap
  - B. A cap — free answer: the number
  - X. Other — say what
- **Answer:** Max **20** photos per entity by default. The uploader takes the limit as a prop (default 20); the API enforces the same default for assets — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** nothing written.
- **Blocked:** REQ-14
- **Candidates:** none: nothing written
- **Owner:** product team
- **Workaround, if any:** none
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q3 — Cover ordering rules

- **Question:** When the cover is deleted, what is "the next remaining photo", and in a multi-file first drop which file becomes cover?
- **Options:**
  - A. Oldest remaining by upload time; first file in the dropped batch
  - B. Newest remaining; first to finish processing
  - C. User-defined order (drag to reorder) and the first in that order
  - X. Other — say what
- **Answer:** A — next cover is the **oldest remaining** photo by upload time; in a multi-file first drop, the **first file in the batch** becomes cover — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** ticket states the rule without defining order.
- **Blocked:** REQ-03
- **Candidates:** `TCG-241` (intent snapshot); the Tools code behaviour is descriptive only
- **Owner:** product team
- **Workaround, if any:** none
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q4 — Roles

- **Question:** Which roles may upload, delete and set cover?
- **Options:**
  - A. Anyone who can edit an asset
  - B. A named narrower role set — free answer
  - C. Any authenticated user in the tenant
  - X. Other — say what
- **Answer:** A — anyone who may edit an asset may upload, delete and set cover — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** intent §8 NOT ON TICKET; no asset-photo role in vault.
- **Blocked:** REQ-15
- **Candidates:** `assets/INDEX.md` (7 KB); `assets/gaps.md` grepped for photo/picture
- **Owner:** product team
- **Workaround, if any:** none
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q5 — Photos on Create

- **Question:** On Create, may photos be chosen before the asset is saved, and if the asset saves but an upload fails what should the user see?
- **Options:**
  - A. Yes: queued, uploaded after save; failures listed, asset stays created, user retries from Edit
  - B. No: photos only after the asset exists (uploader appears on Edit)
  - C. Yes, and a failed upload blocks navigation until resolved
  - X. Other — say what
- **Answer:** A — photos can be picked on Create; they are queued and uploaded after the asset saves. Failed uploads are listed, the asset stays created, and the user retries from Edit — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** ticket says "On Asset create and edit"; the Tools code does A but code is not intent.
- **Blocked:** REQ-16
- **Candidates:** `TCG-241`; intent §12 item 7
- **Owner:** product team
- **Workaround, if any:** build the Edit path first, labelled as a workaround
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q6 — Hard delete versus archive

- **Question:** Should deleting a photo permanently remove the row and files (as the ticket says), given the app-wide decision that removal is archive?
- **Options:**
  - A. Hard delete of row and all three S3 files, as the ticket states (photos exempt from the archive decision)
  - B. Soft-delete/archive the photo record, remove files later
  - X. Other — say what
- **Answer:** A — hard delete: the photo row and all three S3 files are removed — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` (6 KB) says "everything should be archivable instead of deletable" without mentioning photos; ticket DoD says "removes its database record".
- **Blocked:** REQ-07
- **Candidates:** the decision note above; `dispatch/gaps.md` (attachment delete ordering)
- **Owner:** Fouzan Shakil (decider of the note) with the product team
- **Workaround, if any:** none
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q7 — Editing `unitCode` when photos exist

- **Question:** May `unitCode` be changed on an asset that has photos, and should the photos follow the new code?
- **Options:**
  - A. Rename allowed; photos move with the asset
  - B. Rename blocked while photos exist
  - C. Rename allowed; photos stay where they are, still linked to the asset
  - X. Other — say what
- **Answer:** Moot — keys use the asset UUID (D6), so a `unitCode` rename does not touch photos; rename behaviour stays as today. — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** update path accepts `unitCode` (code fact), nothing says whether that is intended; intent §12 item 5.
- **Blocked:** REQ-05, 17
- **Candidates:** `assets.service.ts` update (code, descriptive)
- **Owner:** product team
- **Workaround, if any:** none
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q9 — Where else should the cover show, and mobile

- **Question:** Besides the Assets table, should the cover show on the asset detail header, the asset picker (`asset-select`), and the mobile dispatch assets list, or are those unchanged (initials/none)?
- **Options:**
  - A. Table only; all else unchanged; mobile out of scope
  - B. Table and web detail header and picker; mobile out of scope
  - C. All of the above plus mobile dispatch assets list
  - X. Other — say what
- **Answer:** A — Assets table only; other asset screens unchanged; mobile out of scope — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** ticket lists the table (and "wherever a photo is shown" for placeholder) but not other surfaces; mobile `NOT ON TICKET`.
- **Blocked:** REQ-08, 18 (ripple rows in §11a)
- **Candidates:** `TCG-241`; `assets/gaps.md` (Brian's ask: "shows in the ERP")
- **Owner:** product team
- **Workaround, if any:** table only
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q10 — Do photos appear in the asset's Attachments tab and activity log?

- **Question:** Should asset photos also be listed under the existing Asset Attachments section and written to the asset's activity log?
- **Options:**
  - A. Photos are separate from attachments and not listed there; activity log entry for upload/cover change/delete
  - B. Photos are separate and not listed there; no activity log
  - C. Photos also appear in the Attachments list
  - X. Other — say what
- **Answer:** Photos are separate from attachments and never listed in the Attachments section. **Activity log entry on the asset for: photo uploaded, photo removed, cover changed** (option A) — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** nothing addresses it; today `ASSET` attachments are audited (code fact).
- **Blocked:** §11a row 5, D1
- **Candidates:** `asset-attachment-categories.ts` (code)
- **Owner:** product team
- **Workaround, if any:** none
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q11 — Photos when the asset is archived or deleted

- **Question:** When an asset is archived, unarchived or deleted, what happens to its photos?
- **Options:**
  - A. Archive: photos kept and shown; delete: photos and S3 files removed with the asset
  - B. Archive: photos kept, hidden in lists; delete: removed
  - C. Delete is blocked while photos exist
  - X. Other — say what
- **Answer:** A — archiving an asset keeps its photos and they still show; deleting an asset removes its photo rows and S3 files — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** ticket is silent; `assets.controller.ts` has archive (`:64`), unarchive (`:69`) and delete (`:102`).
- **Blocked:** REQ-03, 07
- **Candidates:** the decision note in Q6
- **Owner:** product team
- **Workaround, if any:** none
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q12 — Existing photos kept as asset attachments

- **Question:** Is anything done with photos users already attached to assets as documents, or are they left alone?
- **Options:**
  - A. Left alone (no migration) — matches intent §5 "not migrating existing attachments"
  - B. Offer "use as photo" later (new ticket)
  - X. Other — say what
- **Answer:** A — existing attachments are left alone; attachments keep working as now. — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** intent §5 excludes re-processing/migrating; whether that is the final word on assets already holding photos as General attachments (Brian: "I recently took pictures…") is unstated.
- **Blocked:** none
- **Candidates:** `assets/gaps.md` (Brian 2026-10-20)
- **Owner:** product team
- **Workaround, if any:** A
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q13 — What "same permission as editing an asset" means in code (raised by the decomposer, 2026-10-20)

- **Question:** REQ-15 says upload, delete and set-cover use the same permission as editing an asset. `assets.controller.ts` has no `@RequirePermission` or `@Roles` on `PATCH :id` today; only the global access-token guard applies, so "the same" means any authenticated user in the tenant. Is that intended, or should the photo routes carry a DB-driven permission (e.g. assets/edit)?
- **Options:**
  - A. Mirror `PATCH :id` exactly: no extra decorator
  - B. Add `@RequirePermission` for assets edit on the photo routes (also a gap on `PATCH :id`)
  - X. Other, say what
- **Answer:** A — photo routes mirror `PATCH :id` exactly (no extra decorator); any authenticated user of the tenant, same as asset edit today. — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** Q4 answered "anyone who may edit an asset" without saying how that is enforced.
- **Blocked:** none (units U2, U5, U6 build option A and are re-checked when answered)
- **Owner:** Akif
- **Workaround, if any:** A
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q14 — Activity-log entry for "photo uploaded": which action and payload (raised by the U2 executor, 2026-10-20)

- **Question:** Q10 says the asset's activity log records "photo uploaded" (and later "photo removed", "cover changed"). `ActivityLogAction` has no photo member, and the web renderer (`features/activity-logs/components/activity-log-sentence.ts`, `activity-log-utils.ts`) words entries by action + `changes` shape. Which shape should the upload entry use?
- **Options:**
  - A. `QUOT_RESOURCE_ADDED` with `{ attachment: true, fileLabel: <originalName>, imageId, tabName: 'Photos' }` — reuses the attachment rendering (file chip, "Tab: Photos"), but the sentence reads "added a file to **Attachments**" (`fileOrResourceSentence` hard-codes it), which contradicts Q10 unless the renderer is changed
  - B. `UPDATED` via `logCustom` with `{ fields: {}, photo: { imageId, originalName }, tabName: 'Photos' }` — renders "updated this record in Photos"; no enum or renderer change
  - C. New `ActivityLogAction` members (`PHOTO_ADDED`, `PHOTO_REMOVED`, `COVER_CHANGED`) — a migration plus renderer/label/icon entries in `features/activity-logs`; outside U2's slice, so it would become its own unit or be added to U5/U6
  - X. Other — say what
- **Answer:** A — log as `UPDATED` via `logCustom` with `changes: { photo: { event: 'uploaded' | 'removed' | 'coverChanged', id, name }, tabName: 'Photos' }`; the web sentence renderer gains a branch reading "added a photo", "removed a photo", "changed the cover photo". No migration. U5/U6 use the same shape — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** Q10 fixes *that* an entry is written, not its action or payload; every option changes what users read in the activity log.
- **Blocked:** U2's activity-log call (not built; the upload works without it). U5 (cover changed) and U6 (photo removed) need the same answer.
- **Owner:** Akif
- **Workaround, if any:** none — U2 writes no entry until answered
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q15 — U2 copy and small values the spec does not fix (raised by the U2 executor, 2026-10-20)

- **Question:** U2 had to put concrete text and values in code. units.md says "Toast copy NOT SPECIFIED: executor proposes"; these are the proposals as built. Confirm or replace.
- **Options:**
  - A. Keep all as built:
    - API errors (400): no file → "File is required" (existing copy); not JPEG/PNG/WebP, unreadable, 0-byte, HEIC/GIF/SVG → "Photo must be a JPEG, PNG or WebP image"; over 10 MiB reaching the service → "Photo must be 10 MB or smaller". Over 10 MiB at the HTTP layer → Nest's multer default **413 "File too large"**
    - Web: card title "Photos", description "JPEG, PNG or WebP, up to 10 MB.", button "Add photo" / "Uploading...", success toast "Photo uploaded", error toast = server message, fallback "Failed to upload photo"
    - Values: thumbnail WebP quality = sharp default (80); placeholder blur = sharp's default 3×3 box blur; placeholder WebP quality = sharp default (80); `originalName` truncated to 255 chars (column length) rather than rejected; client request timeout 120 s (same as attachment uploads)
    - Layout: photos card is a right-hand column from the `xl` breakpoint, 20rem wide; below `xl` it stacks **under** the Main tab form
  - B. Keep A but change the listed items — say which and to what
  - X. Other — say what
- **Answer:** Accepted as built, with one change: client upload timeout is **5 minutes** (300 000 ms), not 120 s. Upload progress 0–100% then "Processing…" is built in U4 (already in scope there), not U2 — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** §9 "Error message text: NOT SPECIFIED"; Q1 fixes only original quality (82), thumbnail size and placeholder width; D8 says "right-hand card, per design" but the design file has no asset-photo screen.
- **Blocked:** nothing — built as A, reversible copy/constants
- **Owner:** Akif
- **Workaround, if any:** A (AI proposal — pending developer confirmation)
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q16 — Response of `POST asset-management/assets/:id/photos` (raised by the U2 executor, 2026-10-20)

- **Question:** D4 B fixes the route; no row fixes what the upload returns. U2 returns `201 { id }` (the new image UUID) — the smallest shape; fields can be added later without breaking callers.
- **Options:**
  - A. `{ id }` (as built)
  - B. The photo as the U3 list will show it, e.g. `{ id, originalName, width, height, sizeBytes, placeholderDataUrl, createdAt }`
  - C. Nothing (`204`)
  - X. Other — say what
- **Answer:** Accepted — `201 { id }` — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** a response shape is a developer decision (CLAUDE.md → Developers decide structure); §11b has no row for it.
- **Blocked:** nothing — built as A
- **Owner:** Akif
- **Workaround, if any:** A (AI proposal — pending developer confirmation)
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q17 — U3 values and copy the spec does not fix (raised by the U3 executor, 2026-10-20)

- **Question:** U3 had to put concrete behaviour, text and values in code. Confirm or replace.
- **Options:**
  - A. Keep all as built:
    - List response: a **bare JSON array** of `{ id, originalName, width, height, placeholderDataUrl, createdAt }` (shared type `EntityImageListItem`), not `{ items: [...] }`
    - Stream route: unknown variant → **404** "Photo not found" (same as a missing/foreign photo, nothing revealed); image id not a UUID → **400** (Nest `ParseUUIDPipe`); `Content-Type: image/webp`, `Content-Length` from S3, **no `Cache-Control`** header (attachments send `private, max-age=60`); a row whose S3 object is missing → S3 error surfaces as **500** (not mapped)
    - Tile fallback (REQ-09 Edges, NOT SPECIFIED): thumbnail fails → **keep the blurred placeholder**; placeholder fails → **plain tile** (theme `bg-secondary`), thumbnail still fades in if it loads; no retry button, no error icon
    - List fails → inline text **"Could not load photos."** (`<prefix>-list-error`); while loading and with zero photos → nothing but the Add button (REQ-02 "zero photos → empty drop zone only")
    - Tiles: 3 per row in the 20rem card, square, `object-cover`, 300 ms opacity fade; placeholder upscaled with an extra CSS `blur-sm`; `alt` = `originalName`
    - Query caching: app defaults (`staleTime`, `retry: 1`); the list refetches after each upload
  - B. Keep A but change the listed items — say which and to what
  - X. Other — say what
- **Answer:** A — keep as built (3 tiles per row, 300 ms fade, placeholder kept if the thumbnail fails, plain tile if the placeholder fails, "Could not load photos." on list failure). — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** REQ-09 Edges "placeholder missing/failed → fall back (initials or plain tile): NOT SPECIFIED"; units.md U3 Risk says "executor shows a plain tile and records it as a developer decision"; §5 "Copy: NOT SPECIFIED"; the U3 slice row lists the item fields, not the envelope or error statuses.
- **Blocked:** nothing — built as A, all reversible (no stored data, no migration)
- **Owner:** Akif
- **Workaround, if any:** A (AI proposal — pending developer confirmation)
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q18 — U3 structure inside the shared photo card (raised by the U3 executor, 2026-10-20)

- **Question:** D8/D8b fix "functions as props, no `features/` imports". They do not fix where the list query lives. Since D20 the tiles use the presigned `thumbnailUrl` directly (`loadImageFn` and the blob→`data:` URL path are removed), so only list-query ownership remains. U3 built option A; units.md's slice row had said "Feature-side: list query hook", which A does not have.
- **Options:**
  - A. (as built) The shared component owns the list query: `listFn(owner)` is a plain async function from the feature (`features/assets/asset/utils/asset-photos.ts`); the key is exported as `entityPhotoKeys.list` from `components/organisms/entity-photos/` so U5/U6 can invalidate; the component invalidates it after an upload, refetches it every 50 min and on window focus, and once when a tile's presigned link fails (D20).
  - B. A feature hook (`useAssetPhotos(assetId)`) owns the list query and passes `photos` data into the component; `listFn` is dropped; the feature also owns the 50-min/focus refetch and the tile-error refetch.
  - C. (withdrawn — moot after D20: no blob/object URLs remain)
  - X. Other — say what
- **Answer:** A — the shared component owns the photo-list query (as built); `loadImageFn` was removed by D20. — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** a new exported key object and query ownership are structural (CLAUDE.md → Developers decide structure); D8b names only function props; D20 removed the image-loading function.
- **Blocked:** nothing — built as A
- **Owner:** Akif
- **Workaround, if any:** A (AI proposal — pending developer confirmation)
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q19 — U3 is over the PR budget (raised by the U3 executor, 2026-10-20)

- **Question:** U3 measures **477 source lines / 18 files** (after D19) against `feat/TCG-241-u2-upload-asset-photo` (budget ~400 / 25; roughly a third is JSDoc). Split or label?
- **Options:**
  - A. One PR with the `size-exception` label (as D16 for U2): the list, tiles and thumbnail stream are one visible behaviour.
  - B. Split into stacked units that each ship alone: **U3a** `GET :id/photos` + shared type + grid/tiles showing the blurred placeholder only (~260 lines); **U3b** `GET :id/photos/:imageId/:variant` + `loadImageFn` + thumbnail fade-in over the placeholder (~200 lines). An API/web split is not offered (it would not ship alone).
  - X. Other — say what
- **Answer:** A — U3 stays one PR with the `size-exception` label (as D16 for U2). — Akif (2026-10-20, Claude Code session)
- **Why it cannot be answered from what is written:** the executor may not trim a unit or re-slice it on its own (`tcg-executor` §6).
- **Blocked:** pushing U3
- **Owner:** Akif
- **Workaround, if any:** none — uncommitted, waiting
- **Status:** resolved — see decisions/2026-10-20-asset-photos-entity-images.md

### Q20 — U4 copy and small behaviours the spec does not fix (raised by the U4 executor, 2026-10-21)

- **Question:** U4 had to put concrete text and behaviour in the multi-photo uploader. units.md says "Copy NOT SPECIFIED: executor proposes"; REQ-04 Edges leaves the empty file NOT SPECIFIED. Confirm or replace.
- **Options:**
  - A. Keep all as built:
    - Per-file rejection text (client pre-check): not JPEG/PNG/WebP (incl. HEIC, GIF, SVG, PDF, unknown type) → "Photo must be a JPEG, PNG or WebP image" (same as the server's); over 25 MiB → "Photo must be 25 MB or smaller" (same as D17's server text); 0-byte file → "File is empty"; beyond the free places → "Limit of 20 photos reached" (number = `maxFiles`); upload failure → the server's message, fallback "Upload failed"
    - Size pre-check: until U9 adds the downscale, the picked file is the uploaded file, so the binding client limit is the **25 MiB upload cap** (`ENTITY_IMAGE_MAX_UPLOAD_BYTES`); the 50 MiB pick limit becomes active in U9
    - Row texts: "Waiting", "Uploading 45%" with a thin progress bar, "Processing…" once 100% of bytes are sent; buttons "Retry" (upload failures only, not pre-check rejections) and "Dismiss" (any error row); a row disappears when its file has uploaded (it is now a tile)
    - `maxFiles` (default 20) counts the photos already listed: valid files take the free places in dropped order, later valid files get the limit message on their own row; invalid files take no place. If the list has not loaded yet, 0 existing is assumed (server cap in U5)
    - Drop zone: the existing `DropzoneInput` (`components/atoms/inputs/dropzone-input.tsx`) reused unchanged, its outer chrome removed via `className`; helper text "Up to 20 photos"; the U2 button stays (ID `-add` kept), relabelled "Add photos"; card description now "JPEG, PNG or WebP, up to 25 MB."
    - While a batch is uploading, the drop zone, button and Retry are disabled; a new batch replaces the previous batch's rows
    - The asset feature's existing toasts stay as U2 built them: one "Photo uploaded" / error toast **per file**, in addition to the row
  - B. Keep A but change the listed items — say which and to what (e.g. one summary toast per batch, or no toast since rows show the result)
  - X. Other — say what
- **Answer:** A for copy (D23), with B for toasts (D29: no per-file toasts); cap per file (D24), `DropzoneInput` reused (D25), `photo-batch.ts` (D26), `onProgress` (D27), sequential uploads (D28). Analyst R1/R2/R4/R5 applied (D23, D24, D27) — Akif (2026-10-21)
- **Why it cannot be answered from what is written:** §9 "Error message text: NOT SPECIFIED"; REQ-04 Edges "empty file (0 bytes) — NOT SPECIFIED"; REQ-14 fixes the cap (20) but not whether a partly-over batch is refused per file or whole; nothing fixes drop-while-busy, row lifetime or per-file toasts.
- **Blocked:** nothing
- **Owner:** Akif
- **Workaround, if any:** A (AI proposal — pending developer confirmation)
- **Status:** resolved — see §11b D23–D29

## 13. What this spec deliberately does not specify

- All numeric limits and image parameters — Q1, Q2.
- Roles — Q4. Create-flow behaviour — Q5. Hard delete vs archive — Q6. `unitCode` rename — resolved (D6).
- Endpoint list, table/column shapes, dependency choice — §11b, developer.
- UI copy beyond "Set as cover", "View", "Delete".
- Mobile — Q9.
- Live Linear ticket re-diffed and updated 2026-10-20 (asset-UUID path, separate from attachments, limits, activity log).
- The design file `my-docs/asset-image-uploader.html` was not read (2.8 MB, untracked); only grep-located by anchor name.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [x] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/`
- [x] Answers written back into `spec.md` with their new sources and flags
- [x] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [x] Every requirement's **Edges** fields are filled or point at a §12 question
- [x] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [x] Every §11b row has _Chosen_ and _Decided by_ filled by a developer
- [x] Every §11c sibling has a developer's yes / no / follow-up
- [x] Live Linear ticket re-diffed against REQ-01–13 (2026-10-20)


Signed off 2026-10-20 by Akif ("all rec" on the last open items: Q13, D1a-null, D8b). Every §12 question resolved; every §11b row decided by Akif; every §11c sibling answered.
Caveat: seven small UI edges remain NOT SPECIFIED (listed in units.md: set-as-cover look on the current cover, cap error text, re-delete behaviour, missing-placeholder fallback, Create failure copy, table cache invalidation, archived-assets table). The executor puts each to Akif when its unit reaches it and never decides them.
