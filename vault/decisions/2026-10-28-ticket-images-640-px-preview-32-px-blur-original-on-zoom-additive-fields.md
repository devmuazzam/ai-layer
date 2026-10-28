---
title: "Ticket images get a 640 px whole-image preview and a 32 px blur, the original only on zoom, every image cover carries the original as originalUrl (no separate ticket type), and image objects are added beside the existing id fields — decision"
source: decision/Syed Haris (CodingCops) — Q6 revised by D11, and D6, in MOBILE-TICKET-PRESIGNED-IMAGES spec §11b and §12, 2026-10-28; D11 amended the same day (commit 9f19d41e9)
decided: 2026-10-28
decided_by: >-
  Syed Haris (CodingCops), the requester of MOBILE-TICKET-PRESIGNED-IMAGES and the named
  owner of Q6, in a live Claude Code session on 2026-10-28. He first answered Q6 = C, then
  replaced it the same day with spec §11b D11 ("yes to the approach and numbers"). He also
  confirmed D6 (additive response fields, names as listed). The answers are recorded in
  .ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md §11b (D6, D11 Reviewed by) and §12 Q6.
  tcg-scrum did not see the session and records from the spec. Later on 2026-10-28, in a
  live session, he amended D11: no separate ticket image type, and the shared
  EntityImageCover carries originalUrl for every cover. That change is built in commit
  9f19d41e9 (author haris). tcg-scrum did not see that session either. It records the
  amendment from the session agent's relay and from the commit. This is a developer and
  requester decision. It binds this build. It is not a TCG client ruling, so the status is
  reference.
status: reference
provenance_note: >-
  AMENDED 2026-10-28 by the same developer (Haris), the day it was written. The first version
  recorded a new ticket-only image type and said EntityImageCover was not changed. Now there
  is no separate type, and EntityImageCover itself gains originalUrl for every cover. The
  sizes (640 / 80 / 32) and D6 stand. Status stays reference; the note is amended, not
  superseded. The replaced text is kept under "Amended 2026-10-28" below.
resolves:
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#q6
conflicts_with: []
related_tickets:
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md
  - 2026-10-20-asset-photos-entity-images.md
  - 2026-10-28-web-ticket-progress-and-meter-reading-images-on-presigned-covers.md
tags: [module/field-ops, kind/decision, signatures, architecture, integrations]
---

# Ticket image sizes and response shape

## Decision

Source: `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q6 and §11b D11 and D6
(Haris, 2026-10-28).

**Q6, revised by D11.** The first answer was C: display signatures from the 2048 px
original. D11 replaced it the same day:

- Every ticket image gets a ticket-only **preview**: 640 px on the longest side, aspect
  kept, no crop (`fit: 'inside'`), WebP quality 80. It is served as `thumbnailUrl`.
- The placeholder is a **32 px wide blur**, served as `placeholderDataUrl`.
- Signatures and identity photos display from the preview. The original (`originalUrl`)
  is used only for the full-screen or zoom view.
- Stored variants are `original.webp` and `preview.webp`.
- In effect this is option B (a thumbnail that keeps the whole image), applied to every
  ticket image, not to signatures only.
- Profile photos are processed as before. The default processor profile keeps the 160 px
  square cover crop and the 24 px blur. The `ENTITY_IMAGE_*` constants and
  `EntityImageListItem` are not changed. The new shared constants are listed in spec D11.
- **Every image cover carries its original** (amended 2026-10-28, see below). There is no
  separate ticket image type. The shared `EntityImageCover` itself gains `originalUrl`. Every
  cover object the API returns is `{ id, placeholderDataUrl, thumbnailUrl, originalUrl }`:
  the profile (`/users/me`), employee, DAS, tool and asset list covers, and field-ticket
  images. `originalUrl` is the presigned S3 link to the stored original (up to 2048 px WebP).
  - For a ticket image, `thumbnailUrl` is the presigned 640 px preview (`preview.webp`) and
    `placeholderDataUrl` is the 32 px blur. The ticket processor profile is kept.
  - Entity covers (profile, asset, tool, employee) keep the 160 px thumbnail and the 24 px
    blur.
  - Mobile preview and zoom views show `originalUrl` from the cover. Lists and thumbnails
    use `thumbnailUrl` and `placeholderDataUrl`.
  - Mobile's zod schema marks `originalUrl` optional, so a new app build against an older
    API still parses. The preview then falls back to `thumbnailUrl`.
  - Because the field is on every cover, list responses carry one more presigned URL per
    cover, about 600 characters each. Web reads `thumbnailUrl` and `placeholderDataUrl` from
    a cover and ignores `originalUrl` at runtime. *(Out of date since U6 and U7, 2026-10-28:
    web progress tracking and the meter-reading drawer now read `originalUrl`. The sentence is
    kept as written. See "Amended 2026-10-28, second: web reads originalUrl (U6, U7)" below.)*
- Ticket images uploaded before this change keep the D5 fallback
  (`decisions/2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md`).

**D6. Response fields are additive.** New image objects are added beside the existing bare
id fields, and the id fields stay: `signatureImage` and `identityPhotoImage` on signatures,
`cover` on single-image rows, `images` for incident evidence, and a download link on
document rows. Haris confirmed additive and the names as listed.

## Why

As recorded in D11 and D6:

- A 160 px square crop is too small and lossy for a mobile preview, and it cuts wide
  signatures.
- Displaying from the 2048 px original (Q6 = C) was rejected by Haris: the downloads are
  heavy and the placeholder does not match.
- An upload still makes three outputs (original, preview, placeholder), so processing cost
  does not change.
- Additive fields keep older mobile builds working (mobile ships through the stores) and
  keep the offline queue, which keys on the ids, working.

## What this does not decide

- **The 640 / 80 / 32 numbers have no product source.** Haris approved them as the
  developer. No TCG person has seen them. Spec Q6 notes that this affects what the crew
  sees on a signed legal record.
- When the bare id fields can be removed. Spec §11 leaves that to rollout, after old builds
  are gone.
- The response-shape change is still guardrail G5: `tcg-contract-tracer` runs, and callers
  are fixed in the same unit.
- The "about 600 characters" per presigned URL is an estimate recorded with the amendment.
  It was not measured, and the real length depends on the key and the signing credentials.

## Amended 2026-10-28

**What changed.** Haris amended D11 in a live Claude Code session on 2026-10-28, after units
U1 to U5 were built. The change is in commit `9f19d41e9` on branch
`feat/MOBILE-TICKET-PRESIGNED-IMAGES-u5-documents`. That branch also has a rebased history, so
commit ids quoted earlier in the ticket's documents may not match.

- Before (removed 2026-10-28): a new shared type `TicketImage = EntityImageCover & { originalUrl: string }` for ticket images only, with `EntityImageCover` itself not changed.
- After: no separate type. `EntityImageCover` gains `originalUrl`, so every cover carries
  it, as stated under Decision above.
- Not changed: the ticket processor profile (640 px preview, quality 80, 32 px blur), the
  entity profile (160 px thumbnail, 24 px blur), `EntityImageListItem`, the D5 fallback for
  old rows, and D6.

**Why, in the developer's words.** This is a paraphrase relayed from the session, not a
verbatim quote:

- The extra type was not needed, because `cover` should carry the original.
- This should be generic for all cover objects.

**What it costs.** These are effects of the change, recorded with it. Haris did not give them
as reasons.

- `originalUrl` is now part of every cover, not ticket images only. Each list response
  carries one more presigned URL per cover, about 600 characters each.
- Web ignores the extra field at runtime. Web's `AssetListCover` type gains the field, and
  the web list still shows the thumbnail only.

**Text replaced in this note.** It is kept here for the record. The Decision list said:

> Profile photos do not change. The default processor profile keeps the 160 px square cover crop and the 24 px blur. `ENTITY_IMAGE_*` constants, `EntityImageCover` and `EntityImageListItem` are not changed. The new shared constants and the `TicketImage` type are listed in spec D11. *(Replaced and removed 2026-10-28.)*

## Amended 2026-10-28, second: web reads originalUrl (U6, U7)

**What changed.** This corrects a statement of fact about the web. It changes no decision.
D11 and D6 stand. The 640 / 80 / 32 numbers stand, and they still have no product source.

- When this note was written, and when it was first amended, web ignored `originalUrl` at
  runtime. That was true of the web covers of the time, such as `AssetListCover`.
- Haris then widened the ticket's scope to two web surfaces. Units U6 and U7 built them on
  branch `feat/MOBILE-TICKET-PRESIGNED-IMAGES-u5-documents`. Since then, web progress tracking
  and the asset meter-reading drawer consume `EntityImageCover` from presigned URLs, and that
  includes `originalUrl`. The scope decision is recorded in
  `decisions/2026-10-28-web-ticket-progress-and-meter-reading-images-on-presigned-covers.md`.
- **U6, web progress tracking** (spec REQ-12 and §11b D13, commit `53e62bf19`).
  `apps/web/src/features/ticket-progress/components/attachment-thumbnail.tsx` shows the
  cover's `placeholderDataUrl` and `thumbnailUrl` on the page. It opens `image.originalUrl` in
  its on-page modal (`const src = image ? image.originalUrl : download.src;`, line 225). With
  no cover, it falls back to `/download`.
- **U7, asset meter-reading drawer** (spec REQ-13 and §11b D13, commit `fd9330e76`).
  `apps/web/src/features/assets/asset/components/asset-meter-reading-history-drawer.tsx`
  renders the photo's cover through `EntityPhotoThumbnail`. It links the photo to
  `image.originalUrl`, which opens in a new tab. With no `image`, it falls back to `/download`.
- **Not changed.** Every other web cover consumer still reads only `thumbnailUrl` and
  `placeholderDataUrl`. This includes the asset list cover (`AssetListCover`, in
  `apps/web/src/lib/api/asset-management.types.ts`). On 2026-10-28,
  `grep -rn 'originalUrl' apps/web/src` found no other cover read. Its `entity-photos` hits
  read `EntityImageListItem`, which is not a cover.

**Text superseded in this note.** It is kept above, as written. The Decision list says:

> Web reads `thumbnailUrl` and `placeholderDataUrl` from a cover and ignores `originalUrl` at runtime.

The first amendment, under "What it costs", says:

> Web ignores the extra field at runtime. Web's `AssetListCover` type gains the field, and the web list still shows the thumbnail only.

Both are now true only of the web covers other than progress tracking and the meter-reading
drawer. The second sentence of the second quote is still true.

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no
  frontmatter.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q6: `Status:` set to
  `resolved — see decisions/2026-10-28-ticket-images-640-px-preview-32-px-blur-original-on-zoom-additive-fields.md`.
  **Done.** D6 and D11 have no §12 entry. Their §11b rows already carry Haris as reviewer.
- **Amended 2026-10-28.** No vault file changes status, and no frontmatter outside this note
  is edited. The ticket's records are amended in the same pass to say the same thing, each
  edit marked "amended 2026-10-28", with the earlier text kept. **Done:**
  - `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md`: the REQ-02 ledger row, REQ-02,
    REQ-03, §4, §6 contracts, §7 types, §11a R9, §11b D5, D6 and D11, and the §12 Q6 Answer
    line. No question is renumbered. No §14 box is ticked.
  - `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/units.md`: the Q6 row, finding A1, and the U1,
    U2, U3 and U5 slice rows.
  - `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/state.md`: Resume and Last updated.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/patterns-p3-proposal.md` was amended on
  2026-10-28 in another session, not by this note: its helper and response lines now name
  `toTicketCover` and `EntityImageCover`. `.ai/claude/contexts/patterns.md` P3 read step 1
  still shows the cover as `{ id, placeholderDataUrl, thumbnailUrl }`. It is Haris-only
  tooling and is not edited here.
- The other decision notes for this ticket name no ticket image type, so they are not changed:
  `decisions/2026-10-28-ticket-attachment-category-labels.md`,
  `decisions/2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md`
  and `decisions/2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md`.
- **Amended 2026-10-28, second (U6, U7).** No vault file changes status. In this note's
  frontmatter, `related_decisions` gains
  `2026-10-28-web-ticket-progress-and-meter-reading-images-on-presigned-covers.md`. No other
  file is edited. The ticket's spec still has the older web wording, and it is not edited here:
  - the §11b D11 row: "web ignores it at runtime and still shows the thumbnail"
  - the §11a R9 row: "web covers read `thumbnailUrl` only"
