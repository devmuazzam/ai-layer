# Proposed `patterns.md` change — P3 sub-shape: images that belong to a ticket

> For Haris. `.claude/**` is Haris-only tooling (root `CLAUDE.md`), so this is written out and
> not applied. The overlay's git identity here is not Haris's, so nothing in `.ai/claude/` was
> edited. Source: MOBILE-TICKET-PRESIGNED-IMAGES spec D3, D11 and units U1 to U5.

## Where it goes

`.ai/claude/contexts/patterns.md`, section **P3 — Entity photos and profile pictures**, as a new
sub-section after *Adding photos to a new entity — checklist*, titled **Images that belong to a
ticket (not an owner's cover)**. Also add one line to P3's *Who uses it today* table pointing at it.

## Text

P3 assumes an owner with a cover (`cover_attachment_id`) and the `/attachments/photos` routes.
Ticket images do not fit that: there are many per ticket, no owner cover, and they upload
through the existing ticket-scoped routes. They reuse P3's image pipeline and response shape.

**What is shared with P3 (do not copy it):**

- `EntityImageProcessor.process(buffer, profile)` — the default profile makes the 160 px
  cover-crop thumbnail and 24 px blur; `TICKET_PROFILE` makes a 640 px `fit: 'inside'` WebP
  preview (quality 80) and a 32 px blur. Constants: `packages/shared/src/constants/ticket-image.ts`.
- `storeImageVariants(...)` in `service/attachments` — decode, put both objects, all or nothing.
- `toTicketCover(storage, row)` — turns a row into an `EntityImageCover`
  (`id`, `placeholderDataUrl`, `thumbnailUrl`, `originalUrl`; `originalUrl` was added to the
  shared cover for every entity, amended 2026-10-28, so there is no separate ticket type). A row
  whose key is not in the ticket tree is an old flat object: `thumbnailUrl = originalUrl`, no
  blur.
- `ticketImageObjectKeys(fileName)` — every S3 object a row owns. **Every delete path must use it**,
  or the `preview.webp` is left behind.
- Presigned links are signed locally; never send an `Authorization` header with one (P3 rule).

**What is different:**

- Keys: `tenants/{t}/job-tickets/{ticket.id}/{group}/{attachmentId}/{original,preview}.webp`;
  documents `tenants/{t}/job-tickets/{ticket.id}/documents/{uuid}.{ext}`. Only UUIDs and fixed
  group names (`signatures`, `checklist-photos`, `incident-evidence`, `attachments`); never
  `ticketCode`.
- Rows keep `featureType` (`TICKET_SIGNATURE`, `CHECKLIST`, `TICKET_INCIDENT`, `JOB_TICKET`) and
  `featureId = ticketCode`. The precise link is a direct FK (`TicketSignature`,
  `ChecklistItemAnswer.photoAttachmentId`, `Attachment.incidentReportId`).
- `attachments.category` is a label written **when the attachment is linked**, not at upload (the
  upload route knows no step, checklist type or break number). Use `AttachmentsRepository.setCategory`
  on an id already verified for this ticket; a failed label write is logged, never fails the save.
- Responses add `…Image: EntityImageCover | null` beside the bare ids (additive), loaded with one
  tenant-scoped `findByIds` per read.
- Mobile renders through `AttachmentImage` and refetches the owning query once when a link fails.

## Known gaps to record next to it

- The four copies of the best-effort `labelAttachment` (checklist, incident, lunch, and U1's
  stricter `labelAttachments`) should become one guard method.
- Sales quotation attachments and job artifacts on mobile still stream through `/download`.
- No incident viewer exists on mobile (Q8), so incident links have no display site.
