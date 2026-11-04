---
title: "Web progress tracking and the asset meter-reading history drawer show images from presigned EntityImageCover links, /download stays as the fallback and for documents, and DAS loadout photos are not done — decision"
source: decision/Syed Haris (CodingCops) — intent.md "Amended 2026-10-28 (Haris)", spec REQ-12, REQ-13 and §11b D13 in MOBILE-TICKET-PRESIGNED-IMAGES, 2026-10-28
decided: 2026-10-28
decided_by: >-
  Syed Haris (CodingCops), the requester and owner of MOBILE-TICKET-PRESIGNED-IMAGES, in a
  live Claude Code session on 2026-10-28. He widened the scope to the web ("web images too",
  state.md). This is recorded in .ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/intent.md under
  "Amended 2026-10-28 (Haris)", in spec REQ-12 and REQ-13 ("added 2026-10-28, Haris"), and in
  spec §11b D13 ("Haris (requested 2026-10-28)"). Haris decided the scope. The
  implementation in D13 is an AI decision recorded in §11b, and its row reads "Needs
  developer: no". tcg-executor built it as units U6 and U7, in commits 53e62bf19 and fd9330e76
  (author haris). tcg-scrum did not see the session. It records from intent.md, spec.md,
  units.md, state.md and the commits. This is a developer and requester decision. It binds
  this build. It is not a TCG client ruling, so the status is reference.
status: reference
resolves:
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#req-12
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#req-13
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#d13
conflicts_with: []
related_tickets:
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-28-ticket-images-640-px-preview-32-px-blur-original-on-zoom-additive-fields.md
  - 2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md
  - 2026-10-28-ticket-attachment-feature-id-holds-ticket-uuid-old-rows-keep-code.md
  - 2026-10-20-asset-photos-entity-images.md
tags: [module/field-ops, module/projects-jobs, module/assets, module/dispatch, kind/decision, signatures, inspections, architecture]
---

# Web ticket-progress and meter-reading images on presigned covers

## Decision

### Scope (Haris, 2026-10-28)

Source: `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/intent.md`, "Amended 2026-10-28 (Haris)".

- **Now in scope.** Two web surfaces use the same presigned S3 links as mobile and the entity
  photos:
  - Job -> Progress Tracking ticket images: the customer signature, the identity photo,
    checklist deficiency photos, checklist signatures, and incident photos and signature.
  - Asset meter-reading photos in the history drawer.
- **Still out of scope.** Documents and PDF downloads stay on `GET /attachments/:id/download`.
  These are `downloadAttachmentBlob`, `openAttachmentBlob`, quotation documents, the print
  dispatch packet and entity-notes files.
- This replaces intent §5's line "The web app's own attachment screens, except fixing callers
  broken by a response-shape change". The original intent text is kept as first written.
- `GET /attachments/:id/download` is not removed or changed (intent §5). It stays as the
  fallback.

### REQ-12: web ticket progress tracking

Source: spec REQ-12 and §5, units.md U6.

- The ticket detail response `GET /jobs/:jobId/progress-tracking/tickets/:ticketCode` returns
  an `EntityImageCover | null` beside every bare attachment id it already returns:
  - the signature and identity photo of every signature
  - the checklist answer photo
  - the incident signature
  - each incident evidence image
- The bare ids stay (spec D6).
- The web renders the cover: placeholder, thumbnail, and the original (`originalUrl`) in the
  existing modal. It makes no request to `GET /attachments/:id/download` for these images.
- On an image error, the web refetches the ticket-detail queries once.
- A row stored before the variants existed returns the D5 fallback: one object for both
  sizes, and no blur.
- With no cover, the web falls back to `/download`. That happens with an older API, a row that
  is gone, or a file that is not an image.
- Edges (REQ-12):
  - Links are made only from rows of the caller's tenant, through the tenant-scoped
    repository.
  - An id with no row yields `null`.
  - Incident evidence that is not an image (video) yields `image: null` and keeps the
    `/download` fallback.
  - Authorisation of the route does not change.

### REQ-13: asset meter-reading photos

Source: spec REQ-13 and §5, units.md U7.

- `GET /asset-management/assets/:id/meter-readings` and the create response return
  `image: EntityImageCover | null` on each photo, beside `attachmentId`.
- The web history drawer renders it through `EntityPhotoThumbnail`. On an image error it
  refetches once for fresh links. It falls back to `/download` when `image` is absent.
- These are flat-key rows, so the D5 fallback applies (no blur). A photo whose file is not an
  image yields `image: null`.

### DAS loadout photos: not done

Source: spec REQ-13 and D13, units.md U6 and U7 (*Deliberately not in this unit*).

- DAS loadout photos (`photos[].attachmentId`) are also shown on the web through `/download`,
  by `DylenLoadoutAttachmentThumb`. units.md U7 also names `das-loadout.mapper.ts`. They are
  **not built** in this change, so they stay on `/download`.
- Reason recorded in D13: the work crosses `DasService` (a loop over every sub-job),
  `DasLoadoutService` and about six web components.
- D13 proposes a follow-up unit. No such unit is in the `units.md` ledger, and no ticket
  exists for it.

### How it is built (spec D13, an AI decision)

- It reuses `EntityImageCover`. That is the same cover shape as profile, asset and tool
  covers.
- It reuses the entity-photos refetch-once behaviour: the `photo-tile-stage` state machine,
  and `EntityPhotoThumbnail` for the meter drawer. No new web image component.
- The `/download` fallback stays through `useAttachmentImageUrl`. It is called with
  `enabled = false` when a cover exists.
- One shared API loader, `loadTicketCovers(attachmentsRepository, storage, ids)` in
  `apps/api/src/service/attachments/ticket-image.ts`. `JobProgressService` and the checklist
  service use it.
- `JobProgressModule` gains `AttachmentsRepository` and `StorageModule`.
- Meter readings build the cover with `toTicketCover`, from the attachment row that the query
  already includes. There is no second read.
- New fields, all additive and optional:
  - `@tcg/shared` (`packages/shared/src/types/job-progress.types.ts`):
    `ProgressSignature.signatureImage` and `identityPhotoImage`,
    `ProgressChecklistAnswer.photoImage`, `ProgressIncident.signatureImage`, and
    `ProgressAttachment.image` (one per evidence file, `null` for non-images).
  - Web: `AssetMeterReadingPhoto.image`, in
    `apps/web/src/lib/api/asset-management.meter.types.ts`.
- Test IDs: U6 keeps every `data-testid`. U7 adds the new `data-testid`
  `asset-meter-history-photo`.

## Why

- **Scope.** The intent amendment states the scope and gives no further reason. The
  amendment's own wording is: "They use the same presigned S3 links as mobile and the entity
  photos."
- **How (D13).** It is the smallest change that follows D5, D6 and D8. A new web image
  component was rejected, because the entity-photos state machine already does the
  placeholder and one refetch.
- **DAS loadout.** It was left out because of the size of the change, as listed above.

## What this does not decide

- **DAS loadout photos.** Only a follow-up unit is proposed. Nobody has decided its scope or
  timing.
- **Whether documents and PDFs ever move off `/download`.** They stay there in this work.
  Nothing decides a later change.
- **When the `/download` fallback or route can be removed.** Both stay.
- **Browser check.** state.md records that U6 and U7 were not verified in a browser when they
  were built. The demos in units.md U6 and U7 are the check.
- **No product behaviour.** REQ-12 and REQ-13 are `[UNVERIFIED]`, kind jira-equivalent.
  Their source is the developer's request. No TCG person ruled on them.

## Notes for the reader

- **Spec D13 has one wrong location.** The D13 row lists `AssetMeterReadingPhoto.image` among
  the fields "optional in `@tcg/shared`". units.md U7 says "Shared: none". The type is in the
  web file `apps/web/src/lib/api/asset-management.meter.types.ts`, and commit `fd9330e76`
  touches no `packages/shared` file. This note records the location as built. It does not
  edit the spec row.
- **The D11 note now has a narrower web statement.** Its 2026-10-28 amendment says web reads
  `thumbnailUrl` and `placeholderDataUrl` from a cover and ignores `originalUrl` at runtime.
  That was written about the web covers of the time (`AssetListCover`). Since U6, the
  progress-tracking `AttachmentThumbnail` opens `originalUrl` in its modal. See
  `decisions/2026-10-28-ticket-images-640-px-preview-32-px-blur-original-on-zoom-additive-fields.md`.
  That note is not edited here.

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no
  frontmatter.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md`: REQ-12, REQ-13 and D13 have no §12
  question, so no `Status:` line changes. The D13 row already names Haris ("requested
  2026-10-28"). This note edits nothing in spec.md, units.md or intent.md.
- The DAS loadout follow-up unit is not created by this note. The developer raises it.
