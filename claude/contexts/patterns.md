# Pattern registry — one way to build each recurring thing

**Same job, same build.** When a feature repeats a shape that already exists elsewhere — a
CRUD, a reference-code list, an archive flow — it is built the way that shape's **reference
implementation** is built, not the way the nearest neighbour happens to be built.

Every entry here is **decided by a developer** and edited by **Haris only** (tooling rule —
root `CLAUDE.md` → _Tooling is Haris-only_). An AI never picks a reference, never edits this
file, and never treats the nearest module as the reference because no entry exists.

## How an agent uses this file

1. **Building something that matches an entry?** Follow its reference. A deviation is
   recorded with its reason in the decisions table (root `CLAUDE.md` → _The AI decides how_) —
   never a silent improvement.
2. **The entry says `UNDECIDED`?** Pick the variant most existing instances use, and record
   the choice and the alternatives. The developer reviews it in the PR.
3. **No entry fits, but the thing will clearly repeat?** Say so in the PR, and propose an
   entry. Haris adds it.
4. **Changing an instance of a pattern?** The other instances are its **siblings**. Name them,
   apply the same change when it fits the PR budget, otherwise list it as a follow-up — and
   record every one (root `CLAUDE.md` → _Siblings get the same change_).

The **Known deviations** list under each entry is consistency debt. Do not fix it in passing
inside an unrelated ticket; it is sibling work and needs the developer's yes like any other.

---

## P1 — Business-entity CRUD (coded, archivable)

Entities with a minted business code, list/detail/create/edit, archive and unarchive.

**Reference — decided by Haris, 2026-10-09:**

- **API: `manufacturers`** (Variant A) — `apps/api/src/presentation/manufacturers/`,
  `usecase/manufacturers/`, `service/manufacturers/`.
- **Web: `agencies`** (W1) — `apps/web/src/features/agencies/` (`schemas/`, `api/`,
  `hooks/`, `views/`, `components/`).

Copy their shape, not their known deviations below — `agencies`' `data as any` (API) and
the `manufacturers` web screen (W1b) are **not** part of the reference.

The variants as surveyed on 2026-10-09:

| Layer | Variant | Modules | Shape |
| --- | --- | --- | --- |
| API | **A** | yards, manufacturers, agencies, vendors, departments, customers | All four layers; repository extends `BaseRepository`; class-validator DTOs; code minted with `SequenceRepository.getNextValue`; code is the route key; `POST :code/archive` / `:code/unarchive` set `archivedAt`; `DELETE` is a hard delete guarded by `DeletionReferenceService`; list returns `{data,total,page,limit}`; `ArchiveReferenceService` + `ArchivedNameConflictService` |
| Web | **W1** | yards, agencies, vendors | `views/<feature>.tsx` switches list/detail/create/edit on pathname; `WorkspaceTable` + `useWorkspaceListQueryState` + `useWorkspaceTableControls`; React Query key factory over an api object on `@/lib/base-api`; full-page react-hook-form + `formZodResolver`; `ConfirmDeleteModal` / `BulkActionConfirmDialog` |

Every other module in the table is a **sibling**: a change to the reference's shape is
offered to them (root `CLAUDE.md` → _Siblings get the same change_).

**Known deviations:**
- `formatInternalId` is copied into each Variant A usecase instead of shared.
- yards keeps both `status` (INACTIVE) and `archivedAt`, and a legacy `{items,total}` list.
- agencies returns `data as any`.
- manufacturers web: create/edit live in `app/(protected)/asset-management/parts/manufacturers/create/page.tsx` with a `useState` form, not react-hook-form (**W1b**).

## P2 — Reference-code list (admin lookup table)

Small admin-maintained lists — a code the user types, a label, active/inactive, a picker.

**Reference — decided by Haris, 2026-10-09:**

- **API: `industries`** (Variant C) — `apps/api/src/presentation/industries/`,
  `usecase/industries/`, `service/industries/`: repository extends `BaseRepository` and wraps
  `utility/reference-code-list.helpers.ts`. **Open:** its controller is unversioned
  (`@Controller('industries')`) while the Variant B modules use `version: '1'` — whether a new
  P2 module copies that is not decided; follow the versioned Variant B modules (the
  majority), record it, and Haris updates this line.
- **Web: the shared manager** (W2) — `apps/web/src/features/settings/views/reference-code-manager.tsx`
  with a ~40-line tab like `industry-codes-tab.tsx`, over `createReferenceCodeService` and the
  hook factories in `features/employee-reference-codes/`. A new reference list is a new tab,
  never a new manager.

**Variant B (no `service/` layer) is not to be copied** — it breaks the layering rule.

The variants as surveyed on 2026-10-09:

| Layer | Variant | Modules | Shape |
| --- | --- | --- | --- |
| API | **B** | quotation-loss-reasons, expense-gl-accounts, employee-union-codes, employee-work-comp-codes, employee-craft-codes, employee-certificates (partly) | **No `service/` layer** — usecase (and the controller, for the public list) inject `PrismaService`; routed by `:id`; `GET /` picker, `GET /admin` list; `DELETE :id` soft-archives to `status: INACTIVE`; `findReferenceCodesPaginated` from `utility/reference-code-list.helpers.ts`; private `mapWriteError` copied per service |
| API | **C** | industries | Same contract as B, **with** a repository extending `BaseRepository` that wraps the reference-code helpers — the only P2 module that respects the layers. Not versioned (`@Controller('industries')`) |
| Web | **W2** | industry-codes, union-codes, work-comp-codes, expense-gl-accounts, certificates tabs | One shared `features/settings/views/reference-code-manager.tsx`; ~40-line tab per entity; `createReferenceCodeService('/path')` + `use{Create,Update,Archive}ReferenceCodeMutation` factories |

The Variant B modules, loss reasons' forked tab and the craft-codes screen are **siblings
carrying consistency debt** (below): bring them to the reference as their own tickets, with
a developer's yes — never in passing.

**Known deviations:**
- Every Variant B module skips the `service/` layer and injects Prisma into the controller.
- Web loss reasons — `features/settings/views/loss-reasons-tab.tsx` (578 lines) is a fork of
  the shared manager, with its service and hooks in `features/quotations/`, outside the factory.
- craft-codes — API hybrid (repository not extending the base, usecase also calls
  `this.prisma`); web **W3** master/detail cards with a hand-built `useState` form, no
  `WorkspaceTable`.
- `features/settings/views/craft-codes-tab.tsx` is imported by no route and targets the old
  `/employee-craft-codes` endpoint.
- industries has two hook files: `use-industries.ts` and `use-industry-codes.ts`.

## P3 — Entity photos and profile pictures

Any entity that has a picture: many photos with one cover (assets, tools), or a single
profile picture (employees, users). All of them use the same storage, the same API routes
and the same way of showing a picture.

**Reference — built by Akif (TCG-241 + PHOTO-REUSE, 2026-10-27).** A new entity that needs
photos plugs into this flow. Do not build a new upload route, table or image component.

### How it works

**Upload**

1. The browser shrinks the picked image to 2048 px at most
   (`components/organisms/entity-photos/prepare-photo-for-upload.ts`).
2. It sends one call: `POST /attachments/photos` with `featureType` (e.g. `TOOL`),
   `featureId` (the owner's UUID) and the file.
3. The API checks that the owner exists in the caller's tenant and that the caller may
   change it.
4. The API makes three versions (`service/attachments/entity-image-processor.ts`):
   - the **original**, as WebP at quality 90;
   - a **160 px square thumbnail**, as WebP;
   - a **tiny 24 px blur**, saved inside the database row as a data URL (not in S3).
5. It writes two files to S3:
   `tenants/{tenantId}/{folder}/{ownerId}/profile-pictures/{photoId}/original.webp` and
   `.../thumbnail.webp`.
6. It saves one `attachments` row. In that row, `featureType` is the owner type,
   `featureId` is the owner's UUID, `category` is 'Profile Picture', and
   `placeholder_data_url` holds the blur.
7. Many-photo owners: the first photo becomes the cover.
   Single-picture owners: the new picture becomes the cover and the old one is deleted, in
   one transaction, with its S3 files removed afterwards. There is no separate
   "replace" route.

**Cover**

The owner table has `cover_attachment_id`, a foreign key to `attachments` that becomes
null when the photo is deleted. `PUT /attachments/photos/:id/cover` changes it.

**Showing a picture**

1. A list or detail response carries `cover: { id, placeholderDataUrl, thumbnailUrl } | null`
   (`EntityImageCover`).
2. Never one request per row:
   - one owner whose row is already loaded: `AttachmentPhotosService.coverOf`;
   - many owners: `coversByOwnerId`, which is one query.
3. The web shows the blur first, then the thumbnail. If the link has expired, it
   refetches once, then shows the fallback (initials or icon).
4. `GET /attachments/photos?featureType&featureId` lists every photo, with thumbnail and
   original links, for the gallery.

**Links**

- Photo links are presigned S3 links, made locally with no call to S3
  (`S3StorageService.presignGetUrl`).
- They are signed at the start of the hour, so the URL stays the same for that hour and
  the browser can cache it.
- Each link is valid for 24 hours.

**Delete**

- `DELETE /attachments/photos/:id` deletes the row and its two files.
- When an owner is deleted, its photo rows are deleted in the same transaction
  (`deleteOwnerPhotosIn`) and the files after the commit (`deleteStoredFiles`).

### Where the code is

| Part | File |
| --- | --- |
| Routes | `apps/api/src/presentation/attachments/attachments.controller.ts` (`/attachments/photos`, declared above the `:id` routes) |
| Main logic (upload, list, cover, delete, permissions) | `apps/api/src/usecase/attachments/attachment-photos.service.ts` |
| Database (owner lookup, cover read and write, covers for many owners) | `apps/api/src/service/attachments/attachment-photos.repository.ts` |
| Image resizing | `apps/api/src/service/attachments/entity-image-processor.ts` |
| S3 keys and presigned links | `apps/api/src/service/storage/s3-storage.service.ts` |
| Sizes and limits (2048 px, 160 px thumbnail, 24 px blur, 25 MB upload, 50 MB pick) | `packages/shared/src/constants/entity-image.ts` |
| Web: photo card with gallery, upload and set cover (many photos) | `apps/web/src/features/entity-photos/entity-photos-card.tsx` |
| Web: upload queued photos after a Create form saves | `apps/web/src/features/entity-photos/upload-queued-entity-photos.ts` |
| Web: show one cover in a table, card or chip | `apps/web/src/components/organisms/entity-photos/entity-photo-thumbnail.tsx` (`EntityPhotoThumbnail`) |
| Web: employee and user avatar, and picture upload | `apps/web/src/features/profile-picture/` (`EntityProfileAvatar`, `profile-picture-queries.ts`) |
| Web: API client and the `PhotoEntityType` list | `apps/web/src/lib/api/entity-photos.ts` |
| Mobile: show a picture | `apps/mobile/lib/profile-picture.ts` (`resolveProfilePhoto`) and the avatar component |

### Who uses it today

| Entity | Photos | Who may change them | Activity log | Where `cover` is returned |
| --- | --- | --- | --- | --- |
| ASSET | many, one cover | anyone who can edit | yes (unit code) | assets list |
| TOOL | many, one cover | anyone who can edit | yes (tool code) | tools list, DAS job tools |
| EMPLOYEE | one (upload replaces) | ADMIN only | no | `GET /employee*`, DAS employees and temps, allocations by sub-job |
| USER | one (upload replaces) | that user only | no | `GET /users/me` (the newer of the user's own picture and the linked employee's) |

### Adding photos to a new entity — checklist

The compiler catches a missing step 1, 2 or 3.

1. Add the type to `PHOTO_FEATURE_TYPES` in `attachment-photos.repository.ts`.
2. Add one `case` to each of `findOwner`, `writeCover` and `readCover` in the same file.
   These switches have no `default` on purpose.
3. Add the S3 folder name to `ENTITY_FOLDER` and the not-found message to `OWNER_NOT_FOUND`
   in `attachment-photos.service.ts`.
4. Schema: add `cover_attachment_id` to the owner, with the relation (`onDelete: SetNull`),
   an index and the back-relation on `Attachment`. Then write a migration.
5. Only one picture allowed? Add the type to `SINGLE_PHOTO_FEATURE_TYPES`.
   Only some people may change it? Add a rule to `assertCanChange`.
   Should uploads be logged? Extend `logPhotoEvent`.
6. When the owner is deleted, delete its photos too: `deleteOwnerPhotosIn` inside the
   transaction, then `deleteStoredFiles` after it.
7. Web: add the type to `PhotoEntityType` in `apps/web/src/lib/api/entity-photos.ts`, and
   add `cover` to the owner's response type.
8. Add `cover` to every API response that shows this entity's picture (use `coverOf` or
   `coversByOwnerId`). Update its web, mobile and qa-automation callers in the same PR.
9. UI:
   - Detail page: `EntityPhotosCard` for many photos, or the profile-picture avatar for
     one picture.
   - Lists and chips: `EntityPhotoThumbnail`.

### Rules

- Never send an `Authorization` header with a presigned link. S3 refuses two auth methods
  in one request, and the image fails to load. This matters on mobile.
- Never put user text in an S3 key. Use only UUIDs and fixed names.
- Use the owner's tenant for the row and the S3 keys, not the caller's tenant (a super
  admin has no tenant).
- Don't send photos through the generic `POST /attachments` upload. It refuses the 'Profile
  Picture' category for photo-owning types.

### Known deviations

- `GET /das/allocations` (by date) returns no `employee.cover`. Only the by-sub-job read
  does (Dylen uses it).
- Asset avatars in Dylen show no picture (they never did).
- Old profile-picture rows (flat `tenants/{t}/attachments/…` keys) are not handled by the
  photo service. They were removed by hand during testing.
- `components/sidebar/sidebar-user-profile.tsx` imports `EntityProfileAvatar` from
  `features/`. The sidebar already imported from `features/` before this work.


## Shared building blocks that already exist — reuse before writing your own

| Need | Use | Adoption today |
| --- | --- | --- |
| A repository | `orm/repository/base.repository.ts` — its doc says every repository extends it | 31 of 80 do (counted 2026-10-09) |
| Paginated reference-code list | `utility/reference-code-list.helpers.ts` | the P2 modules, industries, craft-codes, certificates |
| A business code | `service/sequences/sequence.repository.ts` → `getNextValue` | Variant A, billing-code-custom-types |
| Archive guards | `ArchiveReferenceService`, `ArchivedNameConflictService` | ~20 usecases |
| A list table (web) | `components/templates/workspace-table.tsx` + its hooks | 79 files reference it; no other list table is in use |
| Reference-code web service/hooks | `createReferenceCodeService` + the hook factories | 6 entities |
| Upload / list / set cover / delete photos of an entity | `AttachmentPhotosService` (`usecase/attachments/attachment-photos.service.ts`) | assets, tools, employees, users |
| A cover in an API response | `AttachmentPhotosService.coverOf` / `coversByOwnerId` → `EntityImageCover` | tools, DAS, employees, allocations, `/users/me` |
| A presigned S3 link | `S3StorageService.presignGetUrl` (signed per hour, valid 24 h) | every photo link |
| Show a cover on web | `components/organisms/entity-photos/EntityPhotoThumbnail` | assets, tools, Dylen/DAS, employee and user avatars |

No code generator exists (no `generators` in `nx.json`, no plop/hygen). Until one does, the
reference implementation **is** the template.
