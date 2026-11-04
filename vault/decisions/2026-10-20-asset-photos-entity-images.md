---
title: "Asset photos: multi-upload with a cover, stored as WebP original + thumbnail + blur placeholder in a generic EntityImage table, hard delete (Akif, TCG-241) — decision"
source: decision/Akif (developer, CodingCops)
decided: 2026-10-20
decided_by: >-
  Akif (developer on TCG-241, m.akif.farooq@gmail.com), answering the lettered and free-answer
  options in `.ai/aidlc/TCG-241/spec.md` §11b (D1–D12, D1a), §11c and §12 (Q1–Q7, Q9–Q12) in a
  Claude Code session on 2026-10-20. The structure choices (§11b, §11c) are his to make. The
  product answers (§12) are not clearly his: the spec names the product team, with Brian Petros
  as the person who asked for the feature, as owner of Q1–Q5 and Q7–Q12, and Fouzan Shakil (decider of
  `decisions/2026-08-20-archive-instead-of-delete-app-wide.md`) with the product team as owner
  of Q6. Recorded as `status: reference`, not `verified`, for that reason, the same way
  developer direction is recorded elsewhere in this folder: binding on the TCG-241 build, open
  to being overruled by Brian Petros or the product team. Relayed to tcg-scrum from the spec
  file. tcg-scrum did not see the session itself. Recorded by tcg-scrum on 2026-10-20.
status: reference
conflicts_with: []
resolves:
  - "TCG-241/spec.md#q1 … #q7, #q9 … #q12 (Q8 unused)"
related_tickets:
  - TCG-241
related_decisions:
  - 2026-08-20-archive-instead-of-delete-app-wide.md
tags: [module/assets, kind/decision, requirements, architecture, permissions-roles]
---

## Decision

Asset photos are a new feature on the asset record. They are **not** attachments. Source for
every line below: `.ai/aidlc/TCG-241/spec.md` §11b, §11c and §12, Akif, 2026-10-20.

### Product answers

- **Q1. Upload and image parameters.** Max upload **10 MB** per file. Input is JPEG, PNG or
  WebP only. **HEIC is rejected.** The server **always re-encodes**, including WebP uploads.
  Orientation is applied first, then EXIF (including GPS) is **stripped**. Three files are
  stored per photo, all WebP:
  - **original**: resized so the longest side is at most **2048 px**, quality **82**
  - **thumbnail**: **160×160** square, cover-cropped
  - **placeholder**: about **24 px** wide, blurred
- **Q2. Cap.** Max **20** photos per entity by default. The uploader takes the limit as a
  prop (default 20), and the API enforces the same default for assets.
- **Q3. Cover order.** In a multi-file first drop, the **first file in the batch** becomes
  the cover. When the cover is deleted, the **oldest remaining** photo by upload time becomes
  the cover.
- **Q4. Roles.** Anyone who may edit an asset may upload, delete and set the cover.
- **Q5. Photos on Create.** Photos can be picked on Create. They are queued and uploaded
  after the asset saves. If an upload fails, the failures are listed, the asset stays created,
  and the user retries from Edit.
- **Q6. Delete.** **Hard delete**: removing a photo deletes its row and all three S3 files.
- **Q7. `unitCode` rename.** Moot. Keys use the asset UUID (D6), so a rename does not touch
  photos. Rename behaviour stays as it is today.
- **Q9. Where the cover shows.** In the **Assets table only**. Other asset screens are
  unchanged, and mobile is out of scope.
- **Q10. Attachments and activity log.** Photos are never listed in the asset's Attachments
  section. The asset's activity log gets an entry when a photo is **uploaded**, when one is
  **removed**, and when the **cover changes**.
- **Q11. Asset archive and delete.** Archiving an asset keeps its photos, and they still
  show. Deleting an asset removes its photo rows and S3 files.
- **Q12. Photos already attached as documents.** Left alone. No migration, and attachments
  keep working as they do now.

### Key structure choices (developer's call)

- **A separate generic `EntityImage` table, not `Attachment`** (D1 C, D1a A). Columns: `id`
  (UUID), `tenantCompanyId`, `entityType` (new enum `ImageOwnerType { ASSET }`),
  `entityId` (UUID, no FK; the service removes rows when the asset is deleted),
  `originalName`, `width`, `height`, `sizeBytes`, `placeholderDataUrl`, `uploadedById?` and
  `createdAt`. There are no S3-key columns, because the keys are derived from IDs. The table
  must go on the tenant `$extends` allowlist.
- **The S3 key uses the asset UUID under the tenant prefix** (D6 C), not `unitCode` as the
  ticket wrote:
  `tenants/{tenantId}/assets/{assetId}/{imageId}/{original,thumbnail,placeholder}.webp`.
- **`sharp` does the processing, for asset photos only** (D3 A). No other upload path
  changes.
- **The cover** is `Asset.coverImageId`, a nullable FK to `EntityImage.id` with
  `onDelete: SetNull`. This mirrors `Tool.coverAttachmentId` (D2 A).
- **Endpoints** are asset-scoped, under `asset-management/assets/:id/photos`: list, upload,
  set cover, delete and stream variant (D4 B). They call a new `entity-images` module that
  follows the P1 layout (D12 A).
- **The list response** carries the cover's placeholder inline, as base64 from the DB column.
  The thumbnail is streamed lazily for each row. The placeholder file is still written to S3
  (D5 B).
- **Processing runs synchronously, all-or-nothing** (D9 A). If any variant fails, the objects
  already written are deleted and no row is created.
- **Delete order** (D10 A): the DB row goes first, in a transaction that includes picking the
  next cover. The S3 deletes run after commit and tolerate missing objects.
- **Create flow** (D7 A): files are held on the client and uploaded after the asset saves
  (the Tools pattern).
- **Uploader** (D8 A): a shared component under `apps/web/src/components/` that never imports
  `features/`. The list, upload, delete and set-cover functions come in as props. It sits in
  the Main tab, in the right-hand card.
- **Shared limits and types** (D11 A) live in `packages/shared`, named `ENTITY_IMAGE_*`.
- **Siblings unchanged** (§11c). Tools & Riggings cover photos, user and employee profile
  pictures, generic attachments, and category/sub-category avatars all stay as they are.

## Why

- **A separate table instead of reusing attachments.** A photo has its own lifecycle (a
  cover, an order, three stored variants), which `Attachment` does not model. Keeping photos
  out of attachments also leaves the Attachments list and its audit behaviour exactly as they
  are (Q10, Q12). The table is generic (`entityType`) because the ticket wants the uploader
  reusable for other entities later.
- **The asset UUID instead of `unitCode` in the key.** `unitCode` is free text up to 50
  characters and can be edited. A UUID key needs no sanitising, and a rename never moves
  objects, which is why Q7 became moot.
- **Hard delete for photos.** The ticket's DoD says deleting a photo "removes its database
  record". A photo is a stored file, not a business record that someone would need to
  restore.
- **`sharp` only for asset photos.** This keeps the new native dependency to the one path
  that needs it until another entity opts in.

## Scope: what this does not decide

- **It does not conflict with the archive-instead-of-delete decision.**
  `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` settles that *entities* are
  archived instead of deleted. Under *What this does NOT settle* it explicitly leaves open
  "what 'everything' includes at the sub-record level — notes, contacts, attachments, …".
  An asset photo is a sub-record of that kind, so this note answers, **for asset photos
  only**, a question that note left open. It does not reverse anything that note decided.
  The asset itself still archives (Q11), and its photos survive the archive. This note does
  not answer the sub-record question for attachments, notes, contacts or any other child row.
  The owner named for Q6 (Fouzan Shakil with the product team) has not confirmed it.
- **Asset delete.** The asset's existing delete endpoint is not changed by this note. Q11
  only says what happens to photos when that endpoint runs. Whether asset delete should exist
  at all is the open question in the archive note.
- **Photos anywhere other than the Assets table.** This covers the asset detail header, the
  asset picker and mobile (Q9 A). Any of those needs a new ticket.
- **Other entities.** Tools, users and employees, categories and generic attachments are
  unchanged (§11c). The generic table and uploader make them possible later; this note does
  not decide them.
- **Reordering photos.** No drag-to-reorder was chosen (Q3 A uses upload time).
- **A pattern entry.** No `patterns.md` media pattern is recorded. That is a Haris-only edit
  (D12 option C was not chosen).

## Effect on the vault

- **No winner or loser flip applies.** No vault documents conflict on asset photos, and no
  `status:`, `superseded_by:` or `conflicts_with:` field changed on any product file.
- `.ai/aidlc/TCG-241/spec.md` §12: Q1–Q6 and Q9–Q11 → `Status: resolved — see
  decisions/2026-10-20-asset-photos-entity-images.md`. **Done.** Q7 (`resolved — Akif
  2026-10-20 via D6`) and Q12 (`resolved — Akif 2026-10-20`) were already written in a
  different form and keep their own lines. This note still records both. Q8 is unused.
- `assets/gaps.md` →
  *Grouping assets for fleet-maintenance inventory — by department, or something else?*
  **Not closed.** Brian Petros's 2026-10-20 photo ask is part (c) of an *Update* line inside
  that entry, not a separate entry. The entry's own question (how to group assets for
  fleet-maintenance inventory) is not answered by TCG-241, so its `Status:` stays `open`.

## Amendment 2026-10-20 — large phone photos (Akif)

Recent iPhones produce 5–25 MB JPEGs (more for 48 MP / ProRAW) and `.heic` files on desktop. Decided (option A): the browser downscales each picked photo to ≤ 2048 px and re-saves it as JPEG with built-in APIs before upload (no new dependency). The 10 MB cap applies to the downscaled file; a picked file may be up to 50 MB. HEIC is accepted only where the browser can decode it (Safari) and is converted before upload; elsewhere it is rejected with a message asking for JPG or PNG. Server-side HEIC support (custom `sharp` build) was declined. Spec: `aidlc/TCG-241/spec.md` Q1, D13.

## Amendment 2026-10-20 (later) — HEIC in every browser, activity log, timeout (Akif)

- **HEIC:** reverses the "Safari only" part of the amendment above. HEIC/HEIF uploads are accepted from any browser; the API decodes them with `heic-decode` (ISC, depends on `libheif-js`, LGPL) and then runs the same `sharp` pipeline. HEIC files skip the browser downscale (they are already 2–5 MB). Spec D15; built in U9.
- **Activity log:** photo events are logged as `UPDATED` with a `photo` payload (`uploaded`, `removed`, `coverChanged`) on a "Photos" tab, read as "added a photo", "removed a photo", "changed the cover photo". No new enum members. Spec Q14 / D14.
- **Upload wait:** the browser waits up to 5 minutes for one upload. Upload progress 0–100% then "Processing…" ships with multi-upload (U4). Spec Q15.

## Amendment 2026-10-20 (U2 review) — upload cap 25 MB (Akif)

The upload cap after browser downscale is **25 MB** (was 10 MB), so it agrees with the app-wide "File is too large. Maximum allowed size is 25MB." message the API returns when a file is over the limit. Picked files stay ≤ 50 MB. Spec D17.

## Amendment 2026-10-20 (U3) — presigned URLs instead of streaming (Akif)

Replaces "stream each variant through the API" (D5 B). The photo list returns a short-lived presigned S3 link for the thumbnail and the original, plus the inline blurred placeholder. The browser loads images directly from S3 with plain `<img>` tags, so a page makes one API request instead of one per photo. Links live 1 hour, are signed per time window so the browser can cache them, and are refreshed in the background before they expire. The bucket stays private. New dependency: `@aws-sdk/s3-request-presigner`. Spec D20.

