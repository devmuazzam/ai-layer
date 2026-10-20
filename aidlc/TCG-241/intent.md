# Intent — TCG-241

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-241` (Linear) |
| Title | Assets: upload asset photos with cover, thumbnail and blur placeholder |
| Type | Feature |
| Status | Backlog |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | Akif (created 2026-10-20 from Akif's request in a Claude Code session) |
| Assignee | `NOT ON TICKET` |
| Captured on | `2026-10-20` |
| Captured by | Claude Opus 5.5, session for Akif |

## 2. Business intent

- Intent: give each asset (crane / unit) a recognisable photo, so users can identify units at a glance in the Assets table and on the asset's Main tab. The uploader is to be reusable for other entities' profile pictures later.
- Who benefits (role): `NOT ON TICKET` — presumably anyone managing the fleet (dispatcher / admin); not stated.
- What is worse today without it: the Assets table shows only two-letter initials (`assets-list-view.columns.tsx:63`); assets have no photo at all.

## 3. Definition of done, as the ticket states it

```
- [ ] On Asset create and edit (Main tab, right sidebar), a user can upload one or more PNG, JPG or WEBP photos by drag-and-drop or by clicking.
- [ ] Every uploaded photo appears as a preview tile with Set as cover, View and Delete actions.
- [ ] The first photo becomes the cover automatically. A user can change the cover to any other photo. When the cover is deleted, the next remaining photo becomes the cover. When the last photo is deleted, the asset has no cover.
- [ ] Files that are not images, or are over the size limit, are rejected with a clear message for each file. Valid files in the same batch still upload.
- [ ] For each photo, S3 has original.webp, thumbnail.webp and placeholder.webp under tenants/{tenantId}/assets/{unitCode}/{imageId}/.
- [ ] The original is WebP, visibly as sharp as the upload, and smaller in bytes than the upload for typical JPG and PNG photos.
- [ ] Deleting a photo removes its database record and all three S3 files.
- [ ] The Assets table shows each asset's cover thumbnail as its avatar. Assets without a photo show the initials avatar.
- [ ] Wherever a photo is shown, its blur placeholder appears first and is replaced by the real image once it loads.
- [ ] Photos are tenant-isolated: one tenant cannot list, view or delete another tenant's asset photos.
- [ ] The uploader is a shared component with no asset-specific code inside it, and the asset screen uses it.
- [ ] The Tools & Riggings photo section is unchanged.
- [ ] New UI elements have data-testid attributes.
```

- Acceptance criteria present on the ticket: yes

## 4. In scope

- [ ] Reusable multi-photo uploader component (web): drag-and-drop + click, preview tiles, set as cover, view larger, delete with confirm, per-file progress and errors, blur-placeholder fade-in; generic over entity type + id.
- [ ] Used on Asset create and edit, Main tab, right sidebar.
- [ ] Server-side processing per photo: original re-encoded to high-quality compressed WebP with a capped max size; small square WebP thumbnail; tiny blurred placeholder.
- [ ] S3 layout `tenants/{tenantId}/assets/{assetId}/{imageId}/{original,thumbnail,placeholder}.webp`, via the existing `S3StorageService` (ticket updated 2026-10-20: asset UUID, not unitCode; photos separate from attachments; processing only for asset photos).
- [ ] Cover photo stored on the asset; first upload auto-cover; cover-deletion fallback to next photo.
- [ ] Assets table Unit column shows the cover thumbnail (placeholder first, initials when none); table never downloads originals.

## 5. Out of scope

- [ ] Tools & Riggings photo UI and storage — unchanged.
- [ ] Existing user / employee profile-picture flow (`EntityProfilePictureService`, `features/profile-picture/`) — not migrated by this ticket.
- [ ] Mobile app — `NOT ON TICKET`; ticket names web screens only.
- [ ] Re-processing or migrating any existing attachments.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (presentation / usecase / service) | yes | image processing, S3 key layout, upload / list / delete / set-cover / thumbnail endpoints |
| `apps/api/prisma` (schema + migration) | ? | likely a cover reference on `Asset` and image-variant metadata; shape undecided |
| `apps/web` | yes | new shared uploader component; asset form/detail sidebar; assets table avatar |
| `apps/mobile` | no | — |
| `packages/shared` | ? | possibly shared constants (allowed types, max size) and response types |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `Asset` | `unitCode` (per tenant) | reads (S3 folder name); adds a cover reference (?) |
| `Attachment` | — (UUID only) | creates / deletes (feature type `ASSET` exists) — or a new model; undecided |

- New entity introduced by this ticket: ?
- New code prefix introduced: no
- Existing rows affected: no (no backfill; assets without photos keep initials)

## 8. Roles and permissions

- Roles that can perform this: `NOT ON TICKET`
- Roles explicitly excluded: `NOT ON TICKET`
- Tenant scope: standard per-tenant isolation; S3 keys under `tenants/{tenantId}/`.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `my-docs/asset-image-uploader.html` (client repo, untracked; 2.8 MB) → Assets → create/edit → "Asset Image" card (`assetImageCard`, `assetDrop`). Single image only; ticket asks to extend to multiple + cover and refine the look. |
| Linear | https://linear.app/the-crane-guys/issue/TCG-241 |
| Related tickets | TCG-201 — mobile attachment compression (Done); TCG-204 — Yard Operations & Image Handling (Todo) |
| Existing code | `apps/api/src/service/storage/s3-storage.service.ts`; `apps/api/src/usecase/attachments/entity-profile-picture.service.ts`; `apps/web/src/features/assets/tools-riggings/components/tool-cover-photos-section.tsx` (+ `Tool.coverAttachmentId`); `apps/web/src/features/profile-picture/` |
| Vault area (guess) | asset-management module INDEX |

## 10. Terms used that may not be defined

- "cover photo" — used as: "we can set any one of it as a cover photo" (borrowed from Tools & Riggings).
- "placeholder" — used as: "the blurry version … to show that until the original loads up".

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| Accepted types PNG, JPG, WEBP | Design HTML text "PNG, JPG or WEBP" |
| Max upload size | `NOT ON TICKET — "the size limit", no value` |
| Original max dimensions / WebP quality | `NOT ON TICKET` |
| Thumbnail dimensions | `NOT ON TICKET — "small square"` |
| Placeholder dimensions / format | `NOT ON TICKET — "tiny blurred"`; stored as a file per ticket |
| Max photos per asset | `NOT ON TICKET` |

## 12. Capture completeness

- `NOT ON TICKET`: Epic, Sprint, Assignee, who benefits, roles, max size, dimensions/quality, max photos per asset, mobile.
- `OPEN`: none written as such; see blocking list.
- Buildable without a product answer? no
- Blocking questions (structural — developer decides, per CLAUDE.md):
  1. Where photos and their variants are recorded — reuse `Attachment` (feature type `ASSET`) or a new table; and how the cover is stored on `Asset` (new column?).
  2. Image-processing dependency (none installed today; e.g. `sharp`).
  3. Max upload size, original max dimensions/quality, thumbnail size, placeholder size, max photos per asset.
  4. Endpoints: reuse generic `/attachments/upload` or new asset-photo endpoints; how the table gets thumbnail URLs/streams.
  5. S3 folder when an asset's `unitCode` is renamed.
  6. Who may upload/delete (roles).
  7. Whether photos can be added on Create before the asset exists (pending files uploaded after save, as Tools does).
