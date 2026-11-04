---
title: "Incident video is a plain file with a presigned link, an undecodable image upload is rejected, the offline queue is left as is, and no incident viewer is built in this work — decision"
source: decision/Syed Haris (CodingCops) — answers Q5 = A (2026-10-27), Q7 = A and Q8 = A (2026-10-28) in MOBILE-TICKET-PRESIGNED-IMAGES spec §12
decided: 2026-10-28
decided_by: >-
  Syed Haris (CodingCops), the requester of MOBILE-TICKET-PRESIGNED-IMAGES and the named
  owner of Q5, Q7 and Q8, answering in live Claude Code sessions: Q5 on 2026-10-27 and Q7
  and Q8 on 2026-10-28. On Q5 and Q8 he accepted the recommended option. The answers are
  recorded in .ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md §12. tcg-scrum did not see
  the sessions and records from the spec's Answer lines. This is a developer and requester
  decision. It binds this build. It is not a TCG client ruling, so the status is reference.
status: reference
resolves:
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#q5
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#q7
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#q8
conflicts_with: []
related_tickets:
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md
  - 2026-10-28-ticket-images-640-px-preview-32-px-blur-original-on-zoom-additive-fields.md
tags: [module/field-ops, kind/decision, safety, offline, ticket-workflow]
---

# Incident evidence, refused uploads and the missing incident viewer

## Decision

Source: `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q5, Q7 and Q8.

- **Q5 = A** (Haris, 2026-10-27). Incident video evidence is stored as a plain file with a
  presigned link, with no variants. An image upload that the server cannot decode is
  rejected with an error (400). Today such uploads are accepted. Spec Q7 records that the
  rejection applies on every migrated ticket image upload route, not on incidents only.
- **Q7 = A** (Haris, 2026-10-28). The offline queue is left as it is. When the server
  refuses a queued upload, the step shows the server's message and the crew retakes the
  photo. That is today's behaviour for every other 4xx. Until the photo is retaken, the
  refused file still stops the ticket's later steps from syncing (spec Q7).
- **Q8 = A** (Haris, 2026-10-28). This work builds no incident viewing screen. It ships the
  API links (incident photos, videos and the customer signature) and the parsed mobile
  contract only. A read-only incident viewer is a follow-up ticket.

## Why

The Answer lines give no reason beyond the choice. The spec gives this context:

- Q7: camera and signature-pad files are always decodable (JPEG, PNG, HEIC), so a refused
  queued upload is a corner case, not a daily one.
- Q8: the mobile app has no screen that shows a filed incident today. Nothing is displayed,
  so nothing breaks. A new screen would be client-facing behaviour that nobody specified
  (guardrail G1).

## What this does not decide

- What the follow-up incident viewer shows, or where the crew opens it.
- Whether a permanent refusal should drop the queued file and let later steps sync. That
  was Q7 option B, and it was not chosen.

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no
  frontmatter.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q5, Q7 and Q8: `Status:` set to
  `resolved — see decisions/2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md`.
  **Done.** The Q8 follow-up-ticket pointer is kept.
- The follow-up ticket is not created by this note. The developer raises it.
