# Units — TCG-241 Asset photos with cover, thumbnail and blur placeholder

> Written to `.ai/aidlc/TCG-241/units.md` from the approved `spec.md` beside it (2026-10-20).
> Consumed by an executor, one unit at a time. Nothing has been built.
> Decomposer run for developer Akif. Sizes are reviewer-load estimates from reading
> `assets.service.ts`, `assets.repository.ts`, `tool-cover-photos-section.tsx` (332 lines for a
> comparable tile/drop UI) and `entity-profile-picture.service.ts` (131 lines) — the executor
> re-measures with the `CLAUDE.md` numstat command before pushing.

## Gate baseline

**Gate baseline:** *`2026-10-20`, `origin/main` at `33074bf3d` — lint: 0 errors (warnings only: web 734, api 468, mobile 337, shared 1), typecheck: pass, build: pass, test: partial: web `node --test` 174 pass / 0 fail and `@tcg/shared` 122 pass / 0 fail; the api and mobile jest targets did not report a result in this run (the run ended without an exit line) so their baseline is NOT recorded: the executor of U1 runs `pnpm nx run @tcg/api:test` on clean `origin/main` first and writes the result here.* Real run of `pnpm lint`, `pnpm typecheck`, `pnpm build`, `pnpm test` on a clean `main`. Note: `CLAUDE.md` says "37 web lint errors as of 2026-08-19" — that is stale; today web has 0 errors. A new lint **error** is therefore yours.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | `EntityImage` table, `Asset.coverImageId`, tenant scoping and shared limits exist (foundation) | REQ-14 (constants only), REQ-10 (scoping part) | schema, shared | — | ~80 lines / 6 files | not started |
| U2 | From an asset's Edit page, a user chooses one photo and it is stored as 3 WebP variants | REQ-01 (edit, one file, click-to-choose), REQ-04 (server side), REQ-05, REQ-06, REQ-15, REQ-17, REQ-14 (server size/type/image params), REQ-10 (upload) | api, web | U1 | ~330 lines / 14 files | built — feat/TCG-241-u2-upload-asset-photo |
| U3 | The Edit page shows the asset's photos as tiles: blurred placeholder first, then the thumbnail | REQ-02 (tile only), REQ-09 (tiles), REQ-10 (list/view), REQ-11 (component extended) | api, web | U2 | ~300 lines / 12 files | in progress — feat/TCG-241-u3-asset-photo-tiles |
| U4 | Drag-and-drop several photos at once with per-file progress and per-file errors | REQ-01 (full for edit), REQ-04 (full), REQ-14 (`maxFiles` prop, client pre-check) | web | U3 | ~190 lines / 6 files | committed — feat/TCG-241-u4-multi-photo-uploader (8205e4df7) |
| U5 | First photo becomes cover; "Set as cover" changes it; no photo cap (D31, Akif 2026-10-21) — U4/U3 limit code removed | REQ-03 (first, change), REQ-02 (Set as cover), REQ-14 (cap removed, D31), REQ-10 (set-cover) | api, web | U4 | ~230 lines / 9 files | committed — feat/TCG-241-u5-asset-photo-cover (acab337af) |
| U6 | Delete a photo (confirm, cover fallback, all 3 files) and View it large | REQ-07 (photo delete), REQ-03 (delete fallback, last photo), REQ-02 (View, Delete), REQ-09 (lightbox) | api, web | U5 | ~290 lines / 11 files | committed — feat/TCG-241-u6-asset-photo-delete-view (1e30d0096) |
| U6b | Photo card redesign: cover hero, corner ✕, hover Preview + lightbox, 6-tile limit (+N) on every screen, detail-page cover card | REQ-02, REQ-09, REQ-11, REQ-13 | web | U6 | ~300 lines / 8 files | committed — feat/TCG-241-u6b-photo-card-redesign (769aec73f) |
| U6c | Photos stored in `attachments` (placeholder column, category Photo, `coverAttachmentId`); `entity_images` dropped; routes → `/attachments/photos` | REQ-05, REQ-07, REQ-10 (storage), D48–D51 | schema, api, shared, web | U6b | ~500 lines | committed — feat/TCG-241-u6c-photos-on-attachments (f6631b770) |
| U7 | The Assets table shows each asset's cover thumbnail avatar (blur first), initials otherwise | REQ-08, REQ-09 (avatar), REQ-10 (list) | api, web | U5 (thumbnail stream from U3) | ~170 lines / 7 files | committed — feat/TCG-241-u7-assets-table-cover-avatar |
| U8 | Photos can be picked on Create; uploaded after the asset saves; failures listed, retry on Edit | REQ-16, REQ-01 (create) | web | U5 (stacked on U7) | ~170 lines / 6 files | committed — feat/TCG-241-u8-asset-photos-on-create |
| U9 | Large phone photos are downscaled in the browser; HEIC converted where decodable, else clearly rejected | REQ-14 (client downscale, 50 MB pick — still applies after D31 removed the photo-count cap, 10 MB post-downscale), REQ-04 (HEIC message) | web | U8 | ~140 lines / 4 files | committed — feat/TCG-241-u9-browser-photo-downscale |
| U10 | Deleting an asset removes its photo rows and S3 files | REQ-07 (asset-delete entry), REQ-03 (asset archive keeps photos: test) | api | U6 | ~80 lines / 5 files | committed — feat/TCG-241-u10-asset-delete-removes-photos |

- **Requirements covered:** REQ-01..REQ-18 counted against `spec.md` §2 on 2026-10-20: 18 in spec, 17 in units, 1 not covered. Recount whenever §2 gains a REQ.
- **Not covered:** REQ-18 (Mobile) — its statement is "out of scope; cover shows in the web Assets table only" (Q9 A). There is nothing to build; every unit carries a regression note that `apps/mobile` is untouched. REQ-12 (Tools unchanged) is a constraint, carried as a negative check in U2, U3, U5, U6, not a build item.
- **Units blocked on an open question:** none. No requirement is `[OPEN]`; all §12 questions Q1–Q7, Q9–Q12 read `resolved`. See "Findings for the spec" at the end for things the elaborator should look at, none of which blocks a unit.
- **Layer-split exception used:** only U1 (`kind: foundation`), see its justification.

---

## U1 — Entity image schema and shared limits

- **Outcome:** The database can hold an asset's photos and cover pointer, tenant scoping covers the new table, and web/API read the same limits from `@tcg/shared` — nothing a user sees yet.
- **Kind:** foundation. Justification (schema-only exception): `EntityImage` and `Asset.coverImageId` are consumed by U2, U3, U5, U6, U7, U10 (six units); splitting the migration per unit would be six migrations against the same two tables. The `packages/shared` constants (D11) are consumed by U2 (API), U4/U9 (web) under the same condition.
- **Requirements covered:** REQ-14 (constants only: 10 MB, 50 MB pick, 20 cap, 2048 px, q82, 160×160, ~24 px, JPEG/PNG/WebP) — part. REQ-10 (allowlist entry) — part.
- **Depends on:** —
- **Branch / PR base:** `feat/TCG-241-u1-entity-image-schema` from `origin/main`.
- **Size estimate:** ~80 source lines, 6 files (`schema.prisma`, `prisma.service.ts`, 2 shared files, index export; migration and tests excluded).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | enum `ImageOwnerType { ASSET }`; model `EntityImage` per D1a (`id` UUID PK = S3 `{imageId}`, `tenantCompanyId`, `entityType`, `entityId` (no FK), `originalName` varchar(255), `width`, `height`, `sizeBytes`, `placeholderDataUrl` Text, `uploadedById` UUID? FK User `SetNull`, `createdAt @db.Timestamptz()`); `@@map("entity_images")`; `@@index([tenantCompanyId, entityType, entityId, createdAt], name: "idx_entity_images_…")`; G-G1 `TenantCompany @relation` like `Attachment`. `Asset.coverImageId String? @db.Uuid` + relation `onDelete: SetNull` (D2) + `@@index([coverImageId], name: "idx_assets_cover_image_id")` (G-B2). | Migration committed (name e.g. `add_entity_images`). No backfill. `Tool.coverAttachmentId` untouched (G-F1). D1a does not state nullability of `placeholderDataUrl`, `width`, `height`, `sizeBytes`, `originalName`; the processor always produces them, so the executor lists "NOT NULL" as a lettered option for Akif rather than assuming. |
| API (`apps/api`) | `TENANT_SCOPED_MODELS` += `'entityimage'` in `apps/api/src/orm/prisma.service.ts` | Guardian must-do. |
| Web | N/A — no UI | |
| Mobile | N/A | |
| Shared (`packages/shared`) | `src/constants/entity-image.ts`: `ENTITY_IMAGE_*` limits + allowed MIME list + response/variant types; export from `src/constants/index.ts` | Named per D11 (generic). Additive export only; do not touch `PROFILE_PICTURE_*` or `ASSETS`. |
| Tests | `prisma.service.spec.ts` already asserts every allowlist entry against `Prisma.ModelName` — run it; add a tenant-scoping assertion that `entityimage` is in the set. | |

### Reviewable as

- **Demo:** `pnpm db:migrate` applies cleanly on a fresh DB; `\d entity_images` and `\d assets` show the shape; `tcg-prisma-guardian` report on the real diff.
- **Acceptance:** D1a / D2 / G-B / G-G rows match the schema; allowlist test green. (REQ-14 has "no testable acceptance" per spec §10.)
- **Reviewer can verify without:** any later unit, seed data, S3.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-10, REQ-14).
- **Migration reversible:** yes — new enum, new empty table, one nullable column and index; drop reverses it. No data exists to lose.
- **Behind a flag:** no
- **Touches existing data:** no — `coverImageId` defaults NULL on every existing asset.
- **Blast radius:** a missing allowlist entry silently stops tenant scoping on the new table (the `contexts/prisma.md` failure). Must run `tcg-prisma-guardian` on the real diff before the PR is opened (isolation first).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Every `asset` query and `Prisma.Asset` type | new nullable column | `pnpm typecheck` + `pnpm build` + existing `assets.service` specs unchanged-green | `spec.md` §11a row 2 (additive), D2 |
| `@tcg/shared` public API (web, mobile `dist/`) | new exports | `pnpm typecheck` across web+mobile; `git grep -n "ENTITY_IMAGE" -- apps` returns only new code | `spec.md` §7 (additive) |
| `TENANT_SCOPED_MODELS` | one new entry | `prisma.service.spec.ts` | guardian must-do, §11b |

Enumerated by: `git grep -ln "prisma.asset\." -- apps/api/src` (consumers read the model; none select `*` into a typed DTO that breaks on an added nullable field — executor confirms with typecheck).

### Deliberately not in this unit

- Any endpoint, S3 write, `sharp`, or UI — U2 onward.
- Cross-tenant cover check (G-A1) is application code — U5.

---

## U2 — Upload one photo from the asset Edit page

- **Outcome:** On an asset's Edit page a user clicks "Add photo", picks one JPEG/PNG/WebP, and the server stores `original.webp`, `thumbnail.webp`, `placeholder.webp` under `tenants/{tenantId}/assets/{assetId}/{imageId}/` and records the photo; the page confirms success or shows the server's reason.
- **Kind:** vertical
- **Requirements covered:** REQ-01 (Edit only, one file, click-to-choose; drag-drop/multi → U4; Create → U8), REQ-04 (server-side rejection of non-image / >10 MB / HEIC; per-file batch behaviour → U4), REQ-05 (full), REQ-06 (full), REQ-14 (server: 10 MB, JPEG/PNG/WebP, 2048 px, q82, 160×160 cover-crop, ~24 px blurred, EXIF stripped after orientation, always re-encode; 20-cap → U5), REQ-15 (upload), REQ-17 (full), REQ-10 (upload), REQ-11 (component begun), REQ-13 (this unit's elements)
- **Depends on:** U1
- **Branch / PR base:** `feat/TCG-241-u2-upload-asset-photo`, stacked on `feat/TCG-241-u1-entity-image-schema`.
- **Size estimate:** ~330 source lines, 14 files. Tight but within ~400 / 25. If the executor measures over 400, the only clean split is not available (it would be a backend-only PR) — stop and ask Akif for a per-PR `size-exception`; do not move processing out.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | uses U1 |
| API (`apps/api`) | `package.json` + lockfile: add `sharp` (D3 A) — **lands here, the first unit that imports it**. `service/storage/s3-storage.service.ts`: additive nested-key helper (`tenants/{tenantId}/assets/{entityId}/{id}/{variant}.webp`); `buildKey` untouched. New `service/entity-images/` image processor (`sharp`: `rotate()` applies orientation, resize inside 2048, WebP q82, no metadata kept; 160×160 `cover`; ~24 px blurred WebP; width/height from decoded output) and `entity-images.repository.ts` (create). New `usecase/entity-images/` module + service (D12 A, P1 layout): validate size/decoder, process synchronously (D9 A: any variant fails → delete already-written objects, no row), write 3 objects, create row in one transaction, log "photo uploaded" via `AssetActivityLogger.logCustom` (Q10). `presentation/asset-management/assets/` new `POST :id/photos` (D4 B), memory `FileInterceptor`, 10 MB limit; same access as asset `PATCH :id` (REQ-15). Register module in `asset-management.module.ts` / `app.module.ts`; barrel `index.ts`. | `:id` is the asset UUID, resolve once, 404 if not in tenant. S3 keys built only from tenant UUID, asset UUID, image UUID (no user text). Check `pnpm-workspace.yaml` `onlyBuiltDependencies` and `apps/api/Dockerfile` (`node:22.22.0-slim`, glibc) for sharp's prebuilt binary. No cap, no lock, no cover in this unit. |
| Web (`apps/web`) | Run `find-component` first (candidates in spec §5: `employee-upload-section.tsx`, `file-upload-card.tsx`, `features/profile-picture/`, `tool-cover-photos-section.tsx`). New generic uploader under `apps/web/src/components/` with **no `features/` imports and no "asset" in its source** (D8 A): props `entityType`, `entityId`, `uploadFn`, callbacks; renders an "Add photo" control with a hidden file input. Asset api client function + mutation hook in `features/assets/asset/` (injects `uploadFn`). Wire into the Edit Main tab as the right-hand card (D8). | Sub-directory under `components/` (`organisms/` vs a new `media/`) is Akif's call — executor lists lettered options after `find-component`. Toast copy NOT SPECIFIED: executor proposes. Create page not touched here. |
| Mobile | N/A (REQ-18) | |
| Shared | consume U1 constants | |
| Tests | Unit: processor yields 3 WebP buffers, original smaller than a sample JPG and PNG, always re-encodes a WebP input, orientation applied and EXIF/GPS absent in output, rejects non-image and 0-byte (decoder failure) and HEIC/GIF/SVG. Unit: key helper uses asset UUID; **regression:** `buildKey` still returns the flat `tenants/{tenantId}/attachments/{fileName}` for existing callers. API integration: tenant B token on tenant A asset → 404; over-10 MB → rejected; failure on 2nd/3rd put leaves no objects and no row. Test: editing `unitCode` does not change keys (REQ-17). Web: `git grep -in asset <uploader dir>` empty. | One negative per "Does not apply when": Tools photos / profile pictures / attachments keep flat keys (REQ-05), Attachments tab lists no photos (REQ-01 / Q10). |

### Reviewable as

- **Demo:** Edit any asset → Add photo → pick a JPG; then inspect the DB row and the three S3 objects (or `GET` via the U3 endpoint later). Swagger `POST /asset-management/assets/:id/photos`.
- **Acceptance:** REQ-05 ("exactly three objects … `image/webp`"), REQ-06 (original smaller for sample JPG/PNG), REQ-04 server side (PDF → named error), REQ-10 (cross-tenant), REQ-17.
- **Reviewer can verify without:** U3+ (photos are not yet displayed), a Create flow.

### Risk

- **Weakest source:** `[UNVERIFIED]`
- **Migration reversible:** N/A — no schema change here.
- **Behind a flag:** no. **Not release-safe alone:** uploaded photos are not visible until U3. Deploy U2–U3 together (no flag exists; `deploy.yml` checks nothing).
- **Touches existing data:** no
- **Blast radius:** `sharp` native binary failing in the Docker image breaks `api` boot/build for everyone — run `pnpm nx run @tcg/api:build --skip-nx-cache` and the Dockerfile build. Orphaned S3 objects if cleanup fails (G-E1: log and accept).
- **`[UNVERIFIED]` + hard to undo:** none — additive; a photo can be deleted in U6. The S3 key layout is the one "published shape" (REQ-05/D6, decided by Akif) — S3 keys are derivable from IDs, so no key columns are stored (D1a).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `S3StorageService.buildKey` callers: `attachments.controller.ts:73`, `quotations.controller.ts:344`, `entity-profile-picture.service.ts:78`, `signed-copy-attachments.service.ts:153,207`, `ticket-attachment-guard.service.ts:77` | same service file edited | flat-key unit test + existing attachments specs green | `spec.md` REQ-05 Ripple, §11a last row |
| Tools & Riggings photos (`tool-cover-photos-section.tsx`, `attachments` upload) | none expected | no diff under `features/assets/tools-riggings/`; `git diff --stat` shown in PR | REQ-12, §11c |
| Asset Edit page Main tab layout (`edit-asset.helpers.tsx` `MainTabContent`, `edit-asset-layout.tsx`) | tab gets a card | existing edit-asset tests / manual save of an asset unchanged | REQ-01 Ripple, D8 |
| Asset module registration | `asset-management.module.ts` | API boots; `pnpm test` api | §4 |
| Create page also renders `MainTabContent` (`create-asset-layout.tsx:130`) | shared helper | executor ensures the card is rendered on Edit only (Create → U8) | REQ-16 |

### Deliberately not in this unit

- Multiple files / drag-and-drop / per-file rows — U4. Cover, 20-cap, lock — U5. List, thumbnails, blur — U3. Delete/View — U6. Downscale/HEIC — U9. Create — U8.
- Server limit is 10 MB on the raw upload; real phone photos above that are rejected until U9.

---

## U3 — See an asset's photos: blur placeholder, then thumbnail

- **Outcome:** The Edit page lists the asset's saved photos as tiles that show the tiny blurred placeholder immediately and swap to the sharp thumbnail once loaded.
- **Kind:** vertical
- **Requirements covered:** REQ-02 (tile only; Set as cover → U5, View/Delete → U6), REQ-09 (tiles; lightbox → U6, avatar → U7), REQ-10 (list and variant stream), REQ-11 (component extended), REQ-13 (new elements)
- **Depends on:** U2
- **Branch / PR base:** `feat/TCG-241-u3-asset-photo-tiles`, stacked on `feat/TCG-241-u2-upload-asset-photo`.
- **Size estimate:** ~300 source lines, 12 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | repository `listByEntity` (ordered `createdAt, id`), `findByIdForEntity`; service `list`, `streamVariant`; controller `GET :id/photos` (items with `id`, `originalName`, `width`, `height`, `placeholderDataUrl`, `createdAt`) and `GET :id/photos/:imageId/:variant` (`original|thumbnail|placeholder`, streams from S3 with `image/webp`). | New endpoints (D4 B, already decided). Image id verified against tenant + entityType + entityId. Selecting `placeholderDataUrl` is allowed in the per-asset list. Add `tcg-contract-tracer` only if an existing response changes — it does not here (new routes). |
| Web | Extend the generic uploader: `listFn` prop, tile grid, tile with placeholder-then-thumbnail transition (short fade, executor's choice). How the generic component obtains authenticated image bytes from a feature-injected function (`loadImageFn` prop vs render prop) is not in D8 → lettered options to Akif at start. Feature-side: list query hook + authenticated blob loading (existing `useAttachmentImageUrl` lives in `features/assets/tools-riggings/` and cannot be imported by `components/`). | TanStack Query key + invalidation after upload (decide with the hook). Next `Image`/`<img>` with a `blob:` URL: check `unoptimized`. |
| Mobile | N/A | |
| Shared | response item type if U1 did not include it | additive |
| Tests | API integration: tenant A cannot list or stream tenant B's photos (404); list ordered; stream returns `image/webp`. Web: tile renders placeholder before thumbnail (node `--test` for the pure state helper). Regression: Attachments tab still lists only attachments. | Negative: archived asset still lists photos (Q11 A). |

### Reviewable as

- **Demo:** Edit an asset that has photos from U2 → tiles show blurred then sharp; throttle the network to watch the swap; network panel shows no `original` request.
- **Acceptance:** REQ-09 ("blurred, then sharp"), REQ-10 (list/view cross-tenant), REQ-02 tile.
- **Reviewer can verify without:** cover, delete, table.

### Risk

- **Weakest source:** `[UNVERIFIED]`
- **Migration reversible:** N/A. **Behind a flag:** no. **Touches existing data:** no.
- **Blast radius:** N authenticated image requests per Edit page (≤20 tiles) — acceptable; the placeholder file-vs-column duplication is Akif's D5 B.
- **Missing-placeholder fallback is NOT SPECIFIED (REQ-09 Edges)** — executor shows a plain tile and records it as a developer decision.

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source |
| --- | --- | --- | --- |
| `use-attachment-image-url.ts` (7 consumers) | pattern copied, not edited | no diff to that file | REQ-12 |
| Asset Edit page | extended card | covered by U2 rows + manual | REQ-01 |
| none other — new routes | `git grep -n "assets/:id/photos\|/photos" -- apps` | N/A | — |

### Deliberately not in this unit

- Actions on tiles (Set as cover U5; View, Delete U6); cover badge U5.

---

## U4 — Multi-photo drag-and-drop with per-file results

- **Outcome:** A user can drag several photos onto the uploader (or choose several); each file shows its own progress and either becomes a tile or shows its own error, and valid files in the same batch still upload.
- **Kind:** vertical (web behaviour over U2's endpoint)
- **Requirements covered:** REQ-01 (full for Edit: drag-drop and click, multiple), REQ-04 (full: PDF + oversize + valid → two named errors, one tile), REQ-14 (`maxFiles` prop default 20, client pre-check; server enforcement of 20 → U5), REQ-11, REQ-13
- **Depends on:** U3
- **Branch / PR base:** `feat/TCG-241-u4-multi-photo-uploader`, stacked on `feat/TCG-241-u3-asset-photo-tiles`.
- **Size estimate:** ~190 source lines, 6 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| API | N/A — U2's endpoint is called once per file | |
| Web | Uploader: drop zone, `multiple`, sequential per-file uploads **in dropped order** (so the first file of a first batch is the first created — required by Q3 for U5), per-file pending/progress/error rows, client pre-check: type (JPEG/PNG/WebP), over-50 MB pick, `maxFiles`; server error text surfaced per file. | Files with `data-testid` per web.md scheme: drop zone, input, each row, retry/dismiss. Copy NOT SPECIFIED: executor proposes. Browser-autofill hooks apply to the raw `<input>` control (`useBrowserAutofillDomAttrs`, `browser-autofill-coverage.test.mjs`). |
| Mobile / Shared / Schema | N/A | |
| Tests | Web `node --test`: batch of PDF + over-limit + valid → 2 errors, 1 uploaded; order preserved; `maxFiles` pre-check. Negative: empty file / HEIC / GIF / SVG rows show a rejection (REQ-04 Edges). | `qa-automation` reads IDs — nothing existing renamed. |

### Reviewable as

- **Demo:** Edit page → drop one PDF, one oversized PNG, one valid JPG → two named errors, one tile.
- **Acceptance:** REQ-04 acceptance line; REQ-01 acceptance (3 valid → 3 tiles).
- **Reviewer can verify without:** cover, delete.

### Risk

- **Weakest source:** `[UNVERIFIED]`. Migration N/A, flag no, existing data no. Blast radius: the Edit page card only.
- **Window:** the 20 cap is client-only until U5 (server) — a scripted client can exceed 20 in the interim.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| U2/U3 single-choose path | same component | web tests from U2/U3 re-run | internal |
| Tools photo UI | none | no diff in `features/assets/tools-riggings/` | REQ-12 |

### Deliberately not in this unit

- Browser downscale and HEIC conversion — U9. Photos on Create — U8.

---

## U5 — Cover photo: first is cover, change cover, ~~cap of 20~~ no cap (D31)

- **Outcome:** The first photo uploaded to an asset becomes its cover automatically (first file of a batch), a tile shows a cover badge, and "Set as cover" moves it. ~~The 21st photo is refused.~~ **No cap; Akif 2026-10-21 (D31)** — the U4 client limit and the U3 list cap are removed in this unit.
- **Kind:** vertical
- **Requirements covered:** REQ-03 (first photo; change cover — delete fallback → U6), REQ-02 (Set as cover), ~~REQ-14 (cap 20 server-side)~~ REQ-14 (cap removed — D31, Akif 2026-10-21; U4 client limit and U3 list cap removed here), REQ-10 (set-cover), REQ-15 (set-cover), REQ-13
- **Depends on:** U4 (ordered sequential uploads)
- **Branch / PR base:** `feat/TCG-241-u5-asset-photo-cover`, stacked on `feat/TCG-241-u4-multi-photo-uploader`.
- **Size estimate:** ~230 source lines, 9 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A (U1) | |
| API | ~~Upload transaction now locks the asset row (`SELECT … FOR UPDATE` with **explicit `tenant_company_id`** — raw SQL is unscoped; G-C1), enforces 20, sets `Asset.coverImageId` only if null (atomic).~~ **D32:** no lock, no count — the upload inserts the row and, in the same transaction, sets the first cover with one tenant-filtered conditional `asset.updateMany({ where: { id, tenantCompanyId, coverImageId: null } })`. List cap of 20 removed (D31). New `PUT :id/photos/:imageId/cover`: G-A1 scoped lookup by id + entityType + entityId before the write; logs "cover changed" (Q10) only when the conditional write (`coverImageId` null or different) changed it (D33, analyst R2). List response carries `isCover` (D34). | ~~Cap error status/message NOT SPECIFIED — executor proposes.~~ No cap (D31). |
| Web | Tile: cover badge, "Set as cover" action (hidden/disabled/marked when already cover is NOT SPECIFIED — executor proposes, design file is reference; `my-docs/asset-image-uploader.html` is 2.8 MB, grep by anchor, never read whole); mutation + invalidation of photo list **and** asset list/detail queries. Shape fixed by D35/D36; U4's `maxFiles`, fresh-count pre-check and limit copy removed (D31). | testids on badge and action. |
| Tests | Unit/integration: cover cases (first upload; batch of several first uploads → first file; change); two parallel uploads on an empty asset → exactly one cover; ~~21st upload refused~~ (no cap, D31: any number of valid files accepted); set-cover on the current cover → no write, no log; cross-tenant or other-asset `imageId` in set-cover → 404 and no write (G-A1); asset with cover keeps it when more are added. | |

### Reviewable as

- **Demo:** new asset → drop 3 photos → first has the cover badge; click Set as cover on the second → badge moves; ~~upload 21 → refused~~ upload 21+ → all accepted (D31).
- **Acceptance:** REQ-03 cases 1–2 of the four scripted cases; ~~REQ-14 cap~~ no cap (D31).
- **Reviewer can verify without:** delete, table.

### Risk

- **Weakest source:** `[UNVERIFIED]`. Migration N/A. ~~Blast radius: lock mistakes either deadlock uploads or leak across tenants (raw SQL) — run `tcg-prisma-guardian` on the raw query.~~ No lock or raw SQL any more (D32); blast radius is the conditional cover update's tenant filter — run `tcg-prisma-guardian` on `createWithFirstCover` and `setCover`.
- Existing consumers of `Asset.coverImageId`: none yet.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| U2 upload transaction | modified | U2 tests re-run | internal |
| `Tool.coverAttachmentId` flow | sibling, not touched | no diff in tools dirs | REQ-03 Ripple, G-F1 |
| Asset detail/update | `Asset.coverImageId` not in `UpdateAssetDto` | existing update spec green; PATCH cannot set cover | D2 |

### Deliberately not in this unit

- Cover fallback on delete — U6. Table avatar — U7.

---

## U6 — Delete and view a photo

- **Outcome:** From a tile, a user can View the photo large (placeholder first) or Delete it after a confirmation; the row and all three S3 files go, and the oldest remaining photo becomes cover (none left → no cover).
- **Kind:** vertical
- **Requirements covered:** REQ-07 (photo delete), REQ-03 (delete cover with others left; delete last), REQ-02 (View, Delete + confirm), REQ-09 (lightbox), REQ-10 (delete), REQ-15 (delete), REQ-13
- **Depends on:** U5
- **Branch / PR base:** `feat/TCG-241-u6-asset-photo-delete-view`, stacked on `feat/TCG-241-u5-asset-photo-cover`.
- **Size estimate:** ~290 source lines, 11 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| API | `DELETE :id/photos/:imageId`: one transaction — delete row, re-pick cover ordered `createdAt, id` if it was the cover (D10 A), then delete the 3 S3 objects after commit, tolerating missing objects; failure of the post-commit delete is logged and accepted (G-E1). Logs "photo removed" (Q10). Reusable "delete variants" helper (U10 reuses it). | Deleting an already-deleted photo: NOT SPECIFIED → 404; executor confirms with Akif. |
| Web | Tile: View → lightbox (existing dialog; placeholder then original), Delete → `ConfirmDeleteModal`; invalidate photo list + asset queries. | Reuse-before-create done in U2's `find-component`; lightbox needs its own justification if none exists. |
| Tests | Delete cover with others left → oldest remaining becomes cover; delete last → no cover; row gone + 3 objects gone; cross-tenant image id → 404/403; S3 failure after commit does not undo the delete. Web: confirm required before delete. | |

### Reviewable as

- **Demo:** delete the cover tile → confirm → next oldest has the badge; delete the final photo → no badge; check S3 prefix empty.
- **Acceptance:** REQ-03 cases 3–4; REQ-07 acceptance; REQ-02.
- **Reviewer can verify without:** table, Create.

### Risk

- **Weakest source:** `[UNVERIFIED]` (Q6 tension with `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` resolved: hard delete, Akif).
- **Hard to undo, `[UNVERIFIED]`:** photo deletion is irreversible (bytes gone). Source is the ticket DoD item 7 + Akif's Q6 A answer; the vault decision note is a developer decision, not product. Raised here for Akif to confirm the product owner agrees; it does not block.
- Blast radius: orphaned S3 objects on failure (accepted G-E1).

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| Generic attachments delete (`attachments.controller.ts:143-150`) | pattern, not edited | no diff; existing specs | REQ-07 Ripple, D10 |
| Asset list/detail show cover | `coverImageId` SetNull on delete | covered by cover-repick test | D2 |

### Deliberately not in this unit

- Asset hard delete cleanup — U10.

---

## U6b — Photo card redesign: cover hero, corner delete, hover preview, 6-tile limit

- **Outcome:** The Photos card shows the cover large on top (16:9), tiles are small capped squares (max 6, then "+N" expands, on every screen size), each tile has a corner ✕ to delete, hover shows "Preview" and opens a lightbox gallery of originals, and the asset detail page shows the cover as a read-only "Asset Image" card.
- **Kind:** vertical (web only; no API change)
- **Requirements covered:** REQ-02, REQ-09, REQ-11, REQ-13 (refines U3/U5/U6 UI per Akif's review 2026-10-21, D41–D43)
- **Depends on:** U6
- **Branch / PR base:** `feat/TCG-241-u6b-photo-card-redesign`, stacked on `feat/TCG-241-u6-asset-photo-delete-view`.
- **Size estimate:** ~300 source lines, ~8 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| API / Schema / Shared | N/A | list already returns `isCover`, `originalUrl`, `placeholderDataUrl` |
| Web (generic `components/organisms/entity-photos/`) | Cover hero: 16:9 rounded, `object-cover`, placeholder then original, above the tiles. Tiles: square, capped size (~96–120 px), responsive wrap; max 6 shown on every screen size, the 6th shows "+N" and expands to all, with "Show less". Cover badge: small, brand blue (`--color-bg-brand-solid`, white text), not shadcn `primary`. Remove the ⋯ menu: corner ✕ (half outside, `translate(50%,-50%)`) → existing confirm; hover overlay "👁 Preview" → lightbox; "Set as cover" button on hover (non-cover tiles), and in the lightbox toolbar for touch devices. Lightbox: `yet-another-react-lightbox` (D42), dark translucent backdrop, originals, zoom, swipe/arrows/keyboard, opens at the clicked photo; replaces `entity-photo-viewer.tsx`; on an expired presigned link refetch once (keep D20 behaviour). | test IDs: keep existing tile IDs; new `-hero`, `-tile-<id>-remove`, `-tile-<id>-preview`, `-more`, `-lightbox`; drop `-actions`/`-view` (no qa-automation refs — grep first). |
| Web (asset feature) | Asset detail view (`asset-detail-view.tsx`): read-only "Asset Image" card with the cover hero (no upload/delete); empty state when no cover. | reuse the hero component; no new endpoint (uses the list endpoint). |
| Tests | `node --test` pure helpers: visible-tiles/+N logic (0, 6, 7, 20 photos; expanded), lightbox start index. | no React renderer in web tests |

### Reviewable as

- **Demo:** Edit page with 8 photos → cover large on top, 6 tiles with "+2", click → all 8, "Show less"; hover → Preview → lightbox with arrows and zoom; ✕ → confirm → deleted; Set as cover on hover; phone width → same 6-tile limit, no stretched tiles. Asset detail page → cover card.

### Risk

- New dependency (`yet-another-react-lightbox` ^3.32.2, React 19 peer OK) — D42.
- Touch devices have no hover: Set as cover lives in the lightbox toolbar there.

### Deliberately not in this unit

- Table avatar — U7. Photos on Create — U8.

---

## U6c — Store photos in `attachments` instead of `entity_images`

- **Outcome:** Asset photos live in the existing `attachments` table (`category = 'Photo'`, new `placeholder_data_url`), the cover is `Asset.coverAttachmentId`, `entity_images` is dropped, and the photo routes are under `/attachments/photos`. Every photo behaviour from U2–U6b works exactly as before, and existing attachment screens are unchanged.
- **Kind:** refactor (schema + api + thin web URL change), per D48–D51
- **Depends on:** U6b
- **Branch / PR base:** `feat/TCG-241-u6c-photos-on-attachments`, stacked on `feat/TCG-241-u6b-photo-card-redesign`.
- **Size estimate:** ~500 source lines (mostly moved code); migration does not count.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | Forward migration: add `attachments.placeholder_data_url` Text NULL; rename `assets.cover_image_id` → `cover_attachment_id`, FK → `attachments(id)` ON DELETE SET NULL, index kept/renamed; drop `entity_images` + enum `ImageOwnerType`; remove `'entityimage'` from `TENANT_SCOPED_MODELS` (`attachment` already scoped). | `tcg-prisma-guardian` before commit. Do not reformat the schema (only the touched lines). |
| API | Move the photo service/repository logic onto attachments (generic over `featureType`, asset is the only owner now): upload (sharp → 3 WebP, S3 keys unchanged shape with the attachment id), list (category Photo, oldest first, `isCover`, presigned thumbnail/original, inline placeholder; no width/height), set-cover, delete (+ re-pick), `deleteStoredFiles` for U10. Routes in `attachments.controller.ts` per D50; remove `/asset-management/assets/:id/photos*`. Owner check: resolve the asset by UUID within the tenant (404), activity log on the asset by `unitCode` as before. Generic `GET /attachments` excludes photo rows; generic `DELETE /attachments/:id` routes photo rows through the photo delete; meter-evidence validation rejects photo rows (D51). | keep tenant explicit filters (D18); keep D32 conditional first-cover, D37 delete semantics, P2025/P2003 → 404 |
| Shared | `EntityImageListItem` loses `width`/`height`; constants kept (rename only if trivial). | |
| Web | Feature utils call the new URLs; lightbox derives the aspect ratio from the placeholder image (no width/height). Generic component otherwise unchanged. | |
| Tests | Move/adapt U2–U6 specs to the new service/routes; add: generic list excludes photos, generic delete of a photo removes 3 objects + re-picks cover, meter evidence rejects a photo id. Full gates run after this unit. | |

### Deliberately not in this unit

- Table avatar (U7). Asset hard-delete cleanup (U10, reuses `deleteStoredFiles`).

---

## U7 — Assets table cover avatar

- **Outcome:** The Assets table's Unit Code cell shows the asset's cover thumbnail as its avatar (blurred placeholder first); assets without photos keep the initials avatar; the table never requests an original.
- **Kind:** vertical
- **Requirements covered:** REQ-08, REQ-09 (avatar), REQ-10 (list)
- **Depends on:** U5 (a cover can exist; thumbnail stream from U3)
- **Branch / PR base:** `feat/TCG-241-u7-assets-table-cover-avatar`, stacked on `feat/TCG-241-u6-asset-photo-delete-view` (linear stack, Akif 2026-10-20).
- **Size estimate:** ~170 source lines, 7 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| API | Paginated list include (`ASSET_LIST_INCLUDE` in `assets.repository.ts`) adds the cover (`id`, `placeholderDataUrl` only) via one `include`/batched query — guardian must-do; `placeholderDataUrl` selected only here and in the per-asset photo list. Additive fields on the paginated list row. | **Run `tcg-contract-tracer`** (response shape). The non-paginated `findAllWithRelations`/detail (`ASSET_INCLUDE`) are not changed — no REQ needs the cover there (see Findings). |
| Web | `Asset` type (`lib/api/asset-management.types.ts`) + `mapAssetRow` + `AssetRow` gain cover id/placeholder; Unit Code cell renders thumbnail via authenticated fetch with placeholder-first and `Avatar` initials fallback; categories/sub-categories lists keep initials (11c). | `Avatar` atom takes `src`; `blob:` URL with `next/image` — check `unoptimized`. Cache invalidation on cover change is NOT SPECIFIED: executor invalidates the list on U5/U6 mutations (decision recorded). |
| Tests | API: list returns cover for K of N assets, none for others; cross-tenant never leaks; payload excludes `placeholderDataUrl` on non-list reads. Web: `mapAssetRow` with/without cover; node `--test`. | Archived-assets table: NOT SPECIFIED → same cell. |

### Reviewable as

- **Demo:** Assets list with N assets, K with covers → K thumbnails, N−K initials; network panel has no `original`.
- **Acceptance:** REQ-08 acceptance line.
- **Reviewer can verify without:** Create, delete.

### Risk

- **Weakest source:** `[UNVERIFIED]`. Migration N/A. Blast radius: list latency (N+1 if not batched) and payload size (~page × placeholder bytes); the assets list is the most-used asset screen.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| Assets table Unit Code cell | `assets-list-view.columns.tsx:63` | web test on cell with/without cover | REQ-08, §11a row 1 |
| Asset list response — 119 web files import `assetManagementApi` | added fields | `tcg-contract-tracer` report; typecheck | Q9 A, §11a row 2 |
| Mobile `apps/mobile/app/(dispatch)/assets.tsx` | same endpoint? (executor greps which endpoint it calls) | mobile typecheck; fields additive | Q9 A, REQ-18 |
| `asset-select.tsx`, detail header | untouched | no diff | Q9 A |
| Categories/sub-categories avatar lists | `Avatar` atom | no change to atom's behaviour | §11c |

### Deliberately not in this unit

- Cover on detail header, picker, mobile — decided out (Q9 A).

---

## U8 — Pick photos on Create; upload after the asset saves

- **Outcome:** On the Create asset page a user picks photos (kept in the browser); after Save they are uploaded, failures are listed, the asset stays created, and retry is from Edit.
- **Kind:** vertical
- **Requirements covered:** REQ-16 (full), REQ-01 (Create), REQ-03 (first of the batch is cover — via U5), REQ-13
- **Depends on:** U5 (stacked on U6 only to avoid uploader file conflicts)
- **Branch / PR base:** `feat/TCG-241-u8-asset-photos-on-create`, stacked on `feat/TCG-241-u7-assets-table-cover-avatar`.
- **Size estimate:** ~170 source lines, 6 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| API | N/A | |
| Web | Uploader gains a queued mode (no `entityId`: holds `File[]`, previews via object URLs, same per-file pre-checks). Create layout renders it (`create-asset-layout.tsx`, `use-create-asset-actions.ts`); after the asset POST succeeds, upload queued files in order via U2's endpoint; list failures; navigate with the asset created (D7 A, Tools pattern `upload-tool-photos.ts` is evidence only). | Decision on whether failed uploads keep the user on the page or navigate with a message: Q5 A says asset stays created, retry from Edit — copy NOT SPECIFIED. |
| Tests | Web: save with 3 queued files → asset POST then 3 uploads in order; one failing upload → listed, asset exists; no files → create flow unchanged (regression). | |

### Reviewable as

- **Demo:** Create asset with 2 photos → after save, Edit shows 2 tiles, first is cover; force one failure (oversized) → listed.
- **Acceptance:** Q5 A behaviour (REQ-16).
- **Reviewer can verify without:** downscale, table.

### Risk

- **Weakest source:** `[UNVERIFIED]`. Migration N/A. Blast radius: Create asset page (a high-use form) — save must not regress when no photos are chosen.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| Create asset save flow (`use-create-asset-actions.ts`, `create-asset-layout.tsx`) | edited | web test: create without photos unchanged; qa-automation grep for existing ids | REQ-16 |
| Tools pending-upload util | pattern only | no diff | REQ-12 |

### Deliberately not in this unit

- Downscale (U9).

---

## U9 — Browser downscale and HEIC handling

- **Outcome:** A user can pick a large phone photo (up to 50 MB) and it is downscaled in the browser to ≤2048 px JPEG before upload (so it fits the 10 MB limit); HEIC works where the browser decodes it and is otherwise rejected with a clear "use JPG or PNG" message.
- **Kind:** vertical (web behaviour)
- **Requirements covered:** REQ-14 (client downscale, 50 MB pick, 10 MB post-downscale), REQ-04 (HEIC rejection message), REQ-13
- **Depends on:** U8 (stacked there; logically needs only U4)
- **Branch / PR base:** `feat/TCG-241-u9-browser-photo-downscale`, stacked on `feat/TCG-241-u8-asset-photos-on-create`.
- **Size estimate:** ~140 source lines, 4 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Web | Private helper in the uploader (D13 A): `createImageBitmap` + canvas `toBlob` JPEG ~0.9, longest side ≤ 2048; applied before both the Edit and the queued-Create paths; post-downscale > 10 MB → per-file error. No new dependency. | `components/` still has no `features/` imports. |
| Tests | Node `--test` for the dimension/size decision helper; manual script: 30 MB JPEG, Safari HEIC, Chrome HEIC rejection message. | Canvas itself is not unit-testable under node — stated, not hidden. |
| API / Schema / Shared / Mobile | N/A | |

### Reviewable as

- **Demo:** pick a 30 MB phone JPG → uploads; pick a HEIC in Chrome → clear message.
- **Acceptance:** Q1b.
- **Reviewer can verify without:** server changes.

### Risk

- **Weakest source:** `[UNVERIFIED]`. Migration N/A. Blast radius: every upload path in the uploader (server still re-validates).

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| U4/U8 file-preparation step | edited | their tests re-run; server rejection path still reachable | Q1b |

### Deliberately not in this unit

- Anything server-side.

---


- **Amended 2026-10-20 (Akif, D15):** U9 also adds server-side HEIC decoding: `heic-decode` (+ lockfile) in `apps/api`, a decode step before `sharp` in `entity-image-processor.ts`, `image/heic` and `image/heif` added to `ENTITY_IMAGE_ALLOWED_MIME_TYPES`, and the uploader sends HEIC as is (no browser downscale). Replaces the earlier "reject HEIC in Chrome" behaviour. Tests: a real HEIC fixture decodes into the three WebP variants; HEIC upload works from Chrome.

## U10 — Deleting an asset removes its photos

- **Outcome:** When an asset is deleted, its photo rows and all their S3 files are removed too; archiving keeps them.
- **Kind:** vertical (change to the existing delete flow)
- **Requirements covered:** REQ-07 (asset-delete entry), REQ-03 (archive keeps photos: test)
- **Depends on:** U6 (reuses the delete-variants helper)
- **Branch / PR base:** `feat/TCG-241-u10-asset-delete-removes-photos`, stacked on `feat/TCG-241-u9-browser-photo-downscale`.
- **Size estimate:** ~80 source lines, 5 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| API | `assets.service.ts` `remove`: rows deleted in the asset-delete transaction, S3 objects deleted after commit (G-D2); same in `sub-categories.repository.ts:607` `deleteAsset` path; `utility/demo-data/clear-tenant-data.ts`: `entityImage.deleteMany` (rows only, no S3 — G-D). | `Asset.coverImageId` SetNull is irrelevant when the asset row itself goes. |
| Tests | Delete asset with 2 photos → rows + 6 objects gone; delete blocked by reference (409) → photos remain; archive/unarchive keep photos and they still list; demo wipe removes rows. | Existing delete-conflict tests (`DELETION_BLOCKED_BY_REFERENCE_MESSAGE`) re-run. |

### Reviewable as

- **Demo:** delete a photo-bearing asset; check `entity_images` and the S3 prefix.
- **Acceptance:** Q11 A.
- **Reviewer can verify without:** any web change.

### Risk

- **Weakest source:** `[UNVERIFIED]`. Irreversible but consistent with U6. Blast radius: the asset delete path — a failed photo cleanup must not turn a successful delete into an error (post-commit, logged; G-E1).

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| `assets.service.ts` `remove` | edited | existing remove specs + 409-with-photos test | Q11 A, §11a row 6 |
| `sub-categories.repository.ts` `deleteAsset` | edited | executor greps its callers (`git grep -n "deleteAsset"`) and adds a test | G-D |
| `clear-tenant-data.ts` / demo reset | edited | demo-data spec | G-D |
| Archive / unarchive | none | test that photos persist | Q11 A |

### Deliberately not in this unit

- A reaper for failed S3 deletes (G-E1 chose "log and accept").

---

## Sequencing

```
U1 ──▶ U2 ──▶ U3 ──▶ U4 ──▶ U5 ──┬──▶ U6 ──┬──▶ U8 ──▶ U9
                                  │         └──▶ U10
                                  └──▶ U7
```

- **Parallelisable:** none — linear stack chosen by Akif 2026-10-20 (was: U7 with U6). U7 touches `assets.repository.ts` (`ASSET_LIST_INCLUDE`), `lib/api/asset-management.types.ts`, `use-assets-list-state.ts`, `assets-list-view.columns.tsx`; U6 touches the entity-images service/controller and the uploader tile — no shared file. U10 with U8/U9 (U10 touches `assets.service.ts` `remove`, `sub-categories.repository.ts`, `clear-tenant-data.ts` — no shared file with the web units). Everything else is sequential: U2–U6 and U8–U9 all edit the uploader component and/or entity-images service.
- **Merge order constraint:** the only migration is U1 and merges first. Stack order must hold: U2←U1, U3←U2, U4←U3, U5←U4, U6←U5, U7←U6, U8←U7, U9←U8, U10←U9. One straight line (Akif 2026-10-20) so the last branch, U10, holds the whole feature for end-to-end testing; PRs still merge into main bottom-up, one unit each. Add `sharp` + lockfile only in U2.
- **Release window (no flag exists):** U2 alone stores photos nobody can see; U4–U5 leave the 20-cap client-only until U5; U9 is what makes real phone photos (>10 MB) uploadable. Deploy U1–U9 as a set; U10 may follow. Between U6 merging and U10, deleting an *asset* leaves photo rows/objects behind (G-D) — the window to avoid in production.
- **Cross-surface ripple:** `@tcg/shared` additive exports (U1); asset list response additive fields (U7) — web updated in U7; mobile does not read them (REQ-18), so no disagreement window.
- **First unit to ship:** U1 merges first for dependency, but **U2 is the first unit that proves anything**: it exercises the riskiest assumptions at once — `sharp` in the Node 22 slim image, the nested S3 key layout, synchronous processing with cleanup (D9), and tenant scoping of a new table. If U2 fails in the Docker image, the plan changes before six more units are built on it.

## Findings for the spec (not units, not blockers)

1. **Spec §1 "Counts" line is stale** — it reads "13 unverified … 5 open" but REQ-14..18 now carry sources and no REQ is `[OPEN]`. Elaborator to recount.
2. **§14 sign-off checkboxes are all unticked** except the Linear re-diff, although §11b/§11c/§12 are filled. Akif / spec owner to tick before executing.
3. **REQ-15 "same permission as asset edit":** `assets.controller.ts` carries no `@RequirePermission`/`@Roles` today (the asset `PATCH :id` is guarded only by the global access-token guard). The photo routes mirror that — i.e. any authenticated tenant user. If Akif meant a DB-driven permission, that is a new decision. Appended to spec §12 as Q13.
4. **§11a row 2 says "list/detail" response shape; no REQ needs the cover on the detail response** (U7 changes the paginated list only). Confirm detail stays unchanged.
5. **NOT SPECIFIED items the executor must put to Akif as lettered options, not decide:** Set-as-cover appearance on the current cover (U5); cap-exceeded error text/status (U5); already-deleted photo behaviour (U6); missing-placeholder fallback (U3); post-save-failure copy (U8); toast/error copy (U2, U4); table cache invalidation (U7); archived-assets table (U7); how the generic `components/` uploader gets authenticated image bytes from feature code, and its sub-directory (U2/U3).
6. **D1a does not state nullability** of `placeholderDataUrl`, `width`, `height`, `sizeBytes`, `originalName` (U1).
