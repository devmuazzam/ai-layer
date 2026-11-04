# Intent — MOBILE-TICKET-PRESIGNED-IMAGES

> One intent per ticket. Captures what the ticket asks for, from the ticket. Not a spec and
> not a design. There is no Jira id yet: the folder uses a descriptive slug, to be renamed
> when a Jira id exists (`processed.log` and the branch name follow the rename).

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `MOBILE-TICKET-PRESIGNED-IMAGES` (slug; no Jira id yet) |
| Title | Use the S3 presigned-URL approach for all attachments and images in the mobile ticketing flow |
| Type | Task |
| Status | NOT ON TICKET |
| Epic | NOT ON TICKET |
| Sprint | NOT ON TICKET |
| Reporter | Haris |
| Assignee | NOT ON TICKET |
| Captured on | `2026-10-27` |
| Captured by | Claude Code session, from the developer's request and review of the current code |

## 2. Business intent

- Intent: Ticket photos, signatures and files in the mobile field-ticket flow should load the
  way the profile photo already does, from presigned S3 links returned by the API, instead of
  being streamed through the API as blobs. The developer's stated goal: "implement this
  presigned S3 URL approach for all the attachments and images in the mobile app especially
  the ticketing flow".
- Who benefits (role): field crew (mobile users); the developers who maintain the image code.
- What is worse today without it: `NOT ON TICKET` as a business reason. The code records a
  technical one: several mobile files note that `expo-image` fails to load the
  auth-protected `/attachments/:id/download` route on iOS, and every ticket image is streamed
  through the API with a Bearer header.

## 3. Definition of done, as the ticket states it

```
In Web and mobile (Only profile photo) - We have implemented the S3 presigned approach for images.

Rest of the attachments and images in mobile use old fashioned way of streaming S3 image blob and showing as previewed image

Our goal is to implement this presigned S3 URL approach for all the attchemnts and images in the mobile app espacially the ticketing flow

We have attachments controller and attchments table for this. So, review the current implementation and plan the clean and scable approach to implement this consistenct approach throughout the mobile app in ticketing flow

In web or even in mobile the profile image comes as cover field in response. This is consistent. So, we need to make this consistent as well in mobile api response as well. We need to use the same field name in re sponse that returns these presigned URL and thumb images

And we need to user the attachment table feature_type and c ategory as well
```

- Acceptance criteria present on the ticket: no
- OPEN — the request has no acceptance criteria; per `domain/jira-sop.md` it does not meet
  Definition of Ready. The elaborator derives testable criteria from the stated goal and
  carries them as `[OPEN]` until the developer confirms them.

## 4. In scope

Each line comes from the developer's request or from a decision the developer made while the
plan was reviewed (2026-10-27).

- [ ] Mobile ticketing flow images load from presigned S3 links, not the Bearer `/download` stream.
- [ ] Ticket API responses that reference an image return the existing profile-photo shape
      (`EntityImageCover` / `EntityImageListItem`) under the same field names (`cover`-style,
      `thumbnailUrl`, `originalUrl`, `placeholderDataUrl`).
- [ ] Ticket image uploads store real WebP original and thumbnail variants and an inline blur placeholder.
- [ ] Ticket uploads set the `attachments` row `featureType` and `category` (labels below).
- [ ] Non-image ticket files (documents) open and share through a presigned S3 link.
- [ ] Ticket files are stored in an organised per-ticket S3 folder tree keyed by ticket UUID (new uploads).
- [ ] One shared mobile image component replaces the per-site `resolvePhotoUri` + Bearer rendering.

Developer-chosen `category` labels (written when the attachment is linked, except incident evidence):

| Item | `featureType` | `category` |
| --- | --- | --- |
| Customer signature, step sig1 | `TICKET_SIGNATURE` | `Customer First Signature` |
| Customer signature, step sig2 | `TICKET_SIGNATURE` | `Customer Last Signature` |
| Compliance signature | `TICKET_SIGNATURE` | `Compliance Signature` |
| Identity photo, step sig1 | `TICKET_SIGNATURE` | `Customer First Identity Photo` |
| Identity photo, step sig2 | `TICKET_SIGNATURE` | `Customer Last Identity Photo` |
| Lunch WTL signature 1 to 4 | `TICKET_SIGNATURE` | `Lunch WTL 1` to `Lunch WTL 4` |
| Checklist photo, pre-trip / post-trip / JSA | `CHECKLIST` | `Pre-Trip Checklist` / `Post-Trip Checklist` / `JSA Checklist` |
| Incident evidence | `TICKET_INCIDENT` | `Incident Evidence` |

## 5. Out of scope

- [ ] Presigned upload (client PUT to S3). Uploads stay multipart POSTs to the API.
- [ ] Removing or changing `GET /attachments/:id/download`. It stays as a fallback.
- [ ] Moving or rewriting existing S3 objects and existing `attachments` rows (no backfill, no G2 work).
- [ ] The web app's own attachment screens, except fixing callers broken by a response-shape change. *(Amended 2026-10-28: see the note after §12. Web progress tracking and asset meter-reading photos are now in scope; documents stay out.)*
- [ ] Mobile surfaces outside the ticketing flow, such as sales quotation attachments and job artifacts: OPEN, see §12.
- [ ] Resolving the field-ops FRD conflict (`field-ops-mobile-INDEX.md`). The `Lunch WTL 1` to `4` labels mirror the code's four-slot cap and settle nothing.
- [ ] New tests (none requested; root `CLAUDE.md`).

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS: presentation / usecase / service) | yes | ticket upload and read services, S3 key builder, a shared image-variant helper |
| `apps/api/prisma` (schema + migration) | no | `featureType` and `category` columns already exist; confirm no migration is needed |
| `apps/web` (Next.js) | ? | only if a changed response shape breaks a caller (`tcg-contract-tracer`) |
| `apps/mobile` (Expo Router) | yes | shared image component, contracts, ~10 display sites, file open/share |
| `packages/shared` (types shared across apps) | ? | reuse existing `EntityImageCover` / `EntityImageListItem`; add types only if a gap appears |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `Attachment` | none (UUID `id`) | reads and updates `category` / `placeholderDataUrl`; creates rows with new S3 keys |
| `TicketSignature` | none | reads (image links); no schema change |
| `ChecklistItemAnswer` | none | reads (`photoAttachmentId` link) |
| `JobTicket` | `ticketCode` | reads; its UUID `id` becomes part of new S3 keys |

- New entity introduced by this ticket: no
- New code prefix introduced: no
- Existing rows affected (backfill / migration of data, not just schema): no. Old rows keep their stored `fileName` key and display through a fallback.

## 8. Roles and permissions

- Roles that can perform this: NOT ON TICKET. Existing ticket upload and read permissions are unchanged.
- Roles explicitly excluded: NOT ON TICKET
- Tenant scope: standard per-tenant isolation. Presigned links are built only from keys of rows the caller's tenant owns.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | NOT ON TICKET |
| Jira attachments | NOT ON TICKET |
| Related tickets | `TCG-241` (entity photos, presigned links, decision D20); PHOTO-REUSE U2 (profile pictures, #943) |
| Existing repo docs | `.ai/claude/contexts/patterns.md` P3 (entity photos and profile pictures) |
| Vault area the reader thinks is relevant | `field-ops/field-ops-mobile-INDEX.md` (conflict stub; read, does not gate this work) |

## 10. Terms used that may not be defined

- WTL: used as "Lunch WTL signature". Defined in the payroll vault area; the elaborator verifies.
- cover: used as "the profile image comes as cover field in response". Defined in code as `EntityImageCover`.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| `Lunch WTL 1` to `Lunch WTL 4` (four slots) | The developer chose four labels. The code caps WTL at four (`WTL_TRIGGERS`). The BRS lists three lunch thresholds; see `gaps.md` → Field-ops lunch capture vs payroll WTL. |
| The `category` label strings in §4 | Chosen by the developer on 2026-10-27. |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: Status, Epic, Sprint, Assignee, Design handoff, Jira attachments, Roles (permitted and excluded), why-it-matters business reason.
- Fields left as `OPEN`: acceptance criteria.
- Is this ticket, as written, buildable without a product answer? yes. No new client-facing behaviour is specified: the same images display in the same places. Guardrail G1 is not triggered.
- Open questions for the elaborator to carry into `spec.md` §12:
  1. Are sales quotation attachments and job artifacts (also streamed through the API on mobile) in scope, or ticketing only?
  2. What is the Jira id, so the folder, branch and `processed.log` line can be renamed?
  3. Pre-existing flat ticket images: confirm that a no-blur, original-as-thumbnail fallback is acceptable (no backfill).

---

## Amended 2026-10-28 (Haris)

Web progress tracking (the ticket images on Job -> Progress Tracking: customer signature, identity photo, checklist deficiency photos, checklist signatures, incident photos and signature) and the asset meter-reading photos in the history drawer are now IN scope. They use the same presigned S3 links as mobile and the entity photos. Intent §5's line "The web app's own attachment screens, except fixing callers broken by a response-shape change" is replaced by this: documents and PDF downloads (`downloadAttachmentBlob`, `openAttachmentBlob`, quotation documents, print dispatch packet, entity-notes files) stay out of scope and on `GET /attachments/:id/download`. The original intent text above is kept as first written.

**Next step:** run the elaborator (`.ai/aidlc/agents/inception/tcg-elaborator.md`) against this file.
