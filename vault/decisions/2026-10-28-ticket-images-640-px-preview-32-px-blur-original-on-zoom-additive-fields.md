---
title: "Ticket images get a 640 px whole-image preview and a 32 px blur, the original only on zoom, and image objects are added beside the existing id fields — decision"
source: decision/Syed Haris (CodingCops) — Q6 revised by D11, and D6, in MOBILE-TICKET-PRESIGNED-IMAGES spec §11b and §12, 2026-10-28
decided: 2026-10-28
decided_by: >-
  Syed Haris (CodingCops), the requester of MOBILE-TICKET-PRESIGNED-IMAGES and the named
  owner of Q6, in a live Claude Code session on 2026-10-28. He first answered Q6 = C, then
  replaced it the same day with spec §11b D11 ("yes to the approach and numbers"). He also
  confirmed D6 (additive response fields, names as listed). The answers are recorded in
  .ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md §11b (D6, D11 Reviewed by) and §12 Q6.
  tcg-scrum did not see the session and records from the spec. This is a developer and
  requester decision. It binds this build. It is not a TCG client ruling, so the status is
  reference.
status: reference
resolves:
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#q6
conflicts_with: []
related_tickets:
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md
  - 2026-10-20-asset-photos-entity-images.md
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
- Profile photos do not change. The default processor profile keeps the 160 px square
  cover crop and the 24 px blur. `ENTITY_IMAGE_*` constants, `EntityImageCover` and
  `EntityImageListItem` are not changed. The new shared constants and the `TicketImage`
  type are listed in spec D11.
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

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no
  frontmatter.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q6: `Status:` set to
  `resolved — see decisions/2026-10-28-ticket-images-640-px-preview-32-px-blur-original-on-zoom-additive-fields.md`.
  **Done.** D6 and D11 have no §12 entry. Their §11b rows already carry Haris as reviewer.
