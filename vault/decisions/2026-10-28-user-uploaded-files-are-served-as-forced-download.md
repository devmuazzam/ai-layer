---
title: "Presigned links for user-uploaded non-image ticket files (Attach-File documents, incident video) force a download with a neutral content type, and images keep the inline link because the server re-encodes them to WebP — decision"
source: decision/Syed Haris (CodingCops) — his code review of the MOBILE-TICKET-PRESIGNED-IMAGES branch, built in commit 8838aa0e2, 2026-10-28
decided: 2026-10-28
decided_by: >-
  Syed Haris (CodingCops), the developer and requester of MOBILE-TICKET-PRESIGNED-IMAGES, in
  his own code review of the presigned-links PR. He built the fix in commit 8838aa0e2 (author
  haris, 2026-10-28, "fix(api,mobile): code review fixes for presigned-links PR"). One line of
  the commit message is "Add presignDownloadUrl forcing Content-Disposition: attachment for
  non-image files (XSS prevention)". tcg-scrum did not see the review. It records from the
  commit, the current code and .ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/reflection.md SD-3.
  This is a developer decision. It binds this build. It is not a TCG client ruling, so the
  status is reference.
status: reference
resolves:
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#d9
conflicts_with: []
related_tickets:
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md
  - 2026-10-28-ticket-attachment-category-labels.md
  - 2026-10-28-ticket-attachment-feature-id-holds-ticket-uuid-old-rows-keep-code.md
  - 2026-10-28-ticket-images-640-px-preview-32-px-blur-original-on-zoom-additive-fields.md
  - 2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md
  - 2026-10-28-web-ticket-progress-and-meter-reading-images-on-presigned-covers.md
tags: [module/field-ops, kind/decision, architecture, ticket-workflow, safety]
---

# User-uploaded non-image files are served as a forced download

## Decision

Source: commit `8838aa0e2` (Haris, 2026-10-28) and the current code. Spec §11b D9 in
`.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` chose otherwise. This note supersedes D9
for non-image files.

- **Non-image files get a forced-download link.** A presigned link for a user-uploaded file
  that is not an image must force a download. It must not render inline. This applies to:
  - Attach-File documents: the document `url` in
    `apps/api/src/usecase/ticket-attachments/ticket-attachments.service.ts:258`.
  - Incident video and other non-image incident files: `fileUrl` in
    `apps/api/src/usecase/ticket-incidents/ticket-incidents.service.ts:262`, and `files[].url`
    at `:320`.
- **How the link is signed.** `S3StorageService.presignDownloadUrl(key, fileName)` signs a
  GET with these response overrides:
  - `ResponseContentDisposition: attachment; filename="<name>"`. In the name, every double
    quote, backslash, carriage return and line feed is replaced by `_`.
  - `ResponseContentType: application/octet-stream`.
  - The usual `ResponseCacheControl: private, max-age=3600`.
  - The callers pass `row.originalName` as `fileName`, so the download keeps the name the
    file was uploaded with.
- **Images keep the inline link.** Images still use the plain `presignGetUrl`, which serves
  the object inline with its stored type. The reason is that the server re-encodes new image
  uploads to WebP (`ticket-attachments.service.ts:117-119`). The image links are built in
  `apps/api/src/service/attachments/ticket-image.ts` (`toTicketCover`, `:42-57`).
- **Where the code is now.** The current file is
  `apps/api/src/service/storage/s3-storage.service.ts`, read on 2026-10-29 in the working
  tree (`staging`, which contains the branch `feat/MOBILE-TICKET-PRESIGNED-IMAGES-u5-documents`).
  A later refactor, commit `e8039d1bd` (haris, 2026-10-29), extracted a shared private
  `presignUrl`. It does not change the behaviour:
  - `presignGetUrl` is at `:69-72` and passes no overrides.
  - `presignDownloadUrl` is at `:74-86`. It sanitises the name and passes the two overrides.
  - `presignUrl` is at `:88-104`. It sets the cache header and the signing window, and then
    applies the overrides.

## Why

- **A plain presigned GET is stored XSS for user content.** It serves the object with its
  stored content type. A user-uploaded HTML or SVG file would render and run script on the
  S3 origin. A forced attachment disposition and a neutral content type stop the browser
  from rendering it.
- **Images are safe inline because the bytes are ours.** The server decodes every new image
  upload and stores it as WebP. An image it cannot decode is refused with a 400 (spec Q5 = A,
  see `decisions/2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md`).
  So an inline image link serves only bytes that the server wrote.
- **No plan covered it.** Reflection SD-3 records these facts:
  - The unit contracts and the analyst checklist had no item for this.
  - Spec REQ-06 noted that the presign did not control `Content-Disposition`, and treated it
    as a naming detail for the executor (spec.md:177).
  - D9 chose `presignGetUrl(fileName)`, with `Needs developer: no`.
  - Haris found the gap in human code review. The guardian, the tracer and the analyst did
    not find it.
- The follow-ups R4 (rename `presignGetUrl` so that each new caller must choose) and R5 (an
  analyst checklist item) are proposed in reflection.md. Both are `pending`. This note does
  not decide them.

## Effect on behaviour

- A document opened from its link always downloads, as `application/octet-stream`, under
  its original name. It never renders inline.
- On mobile, `openAttachmentFromUrl`
  (`apps/mobile/components/field/ticket-attachment-file.ts:134-149`, called from
  `apps/mobile/components/field/ticket-attachments-sheet.tsx:191`) downloads the file to the
  cache and opens the native share sheet. It passes the row's `mimeType` to the share sheet,
  not the S3 response type. In the same commit, `sharedFileName` was changed to strip path
  separators from the name.
- Incident video: the API returns the forced-download link. No mobile screen opens it yet
  (spec Q8 = A, no incident viewer in this build).

## What this does not decide

- **Image rows stored before the WebP variants existed.** `toTicketCover` serves such a row's
  one stored object inline, with its stored type (`apps/api/src/service/attachments/ticket-image.ts:38-39`, `:46-49`). Spec Q3
  = A says these objects are not rewritten. The reason "the server re-encodes images" does not
  apply to these rows. `isImageMimeType` accepts any `image/*` type
  (`apps/api/src/service/attachments/is-image-mime-type.ts:1-3`). No source says whether any
  old row has a type that can carry script, such as `image/svg+xml`. This note does not decide
  how such a row should be served.
- **Routes that stream bytes through the API.** Examples are the `/download` offline fallback
  and the generic attachments controller. They set their own `Content-Disposition`
  (`apps/api/src/presentation/field-tickets/field-tickets.controller.ts:530`,
  `apps/api/src/presentation/attachments/attachments.controller.ts:211`). This decision covers
  presigned S3 links only.
- **Presigned links outside this ticket.** Asset and other entity photos use `presignGetUrl`
  in `apps/api/src/usecase/attachments/attachment-photos.service.ts`. This note does not
  review them.
- **R4 and R5.** These are the reflection follow-ups. They are proposals and they are not
  applied.
- **No product behaviour.** No TCG person ruled on this. It is a security rule for this build.

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no
  frontmatter.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §11b D9 (`presignGetUrl(fileName)` for
  documents) is **superseded** by this note for non-image files. D9 is a §11b decision row,
  not a §12 question, so no `Status:` line changes. This note does not edit the spec. The
  orchestrator amends the D9 row.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/reflection.md` lists this decision under "Not
  written: 1" and suggests the file name
  `2026-10-29-user-uploaded-files-are-served-as-forced-download.md`. This note is dated
  2026-10-28 instead, because that is the day of the decision (commit `8838aa0e2`). This note
  does not edit the reflection.
