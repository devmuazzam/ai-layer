---
title: "Presigned ticket images cover the mobile ticketing flow only, and ticket images uploaded before the change are not backfilled — decision"
source: decision/Syed Haris (CodingCops) — answers Q1 = A and Q3 = A in MOBILE-TICKET-PRESIGNED-IMAGES spec §12, 2026-10-27
decided: 2026-10-27
decided_by: >-
  Syed Haris (CodingCops), the requester of MOBILE-TICKET-PRESIGNED-IMAGES and the named
  owner of Q1 and Q3, answering in a live Claude Code session on 2026-10-27. Both times he
  accepted the recommended option. The answers are recorded in
  .ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md §12. tcg-scrum did not see the session
  and records from the spec's Answer lines. This is a developer and requester decision. It
  binds this build. It is not a TCG client ruling, so the status is reference.
status: reference
provenance_note: >-
  Q3's legacy flat-image fallback is retired for MOBILE-TICKET-STRICT-S3 by the
  requester's explicit 2026-11-05 technical direction; see
  decisions/2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md.
  Q1's original ticketing-flow scope and the no-backfill record remain intact.
resolves:
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#q1
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#q3
conflicts_with: []
related_tickets:
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-20-asset-photos-entity-images.md
tags: [module/field-ops, kind/decision, ticket-workflow, requirements]
---

# Ticketing flow only; old ticket images keep a plain fallback

## Decision

Source: `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q1 and Q3 (Haris, 2026-10-27).

- **Q1 = A. The work covers the mobile ticketing flow only.** Sales quotation attachments
  and job artifacts on mobile are not part of it. They become a follow-up ticket. This takes
  spec REQ-10 out of this ticket.
- **Q3 = A. Ticket images uploaded before this change are not backfilled.** They show the
  original image as the thumbnail, with no blur placeholder and no WebP. Only new uploads
  get the variants and the per-ticket key tree.

## Why

The Answer lines record that Haris accepted the recommended option. They give no further
reason. The spec gives this context:

- REQ-01 to REQ-08 do not depend on the other mobile surfaces (spec REQ-10), so Q1 = A
  unblocks the build and does not widen it.
- A backfill would rewrite existing data. That is guardrail G2 (spec Q3, option B), and
  `intent.md` §5 excludes moving or rewriting existing S3 objects and `attachments` rows.
  The fallback only reads (spec §11b D5). Nothing is destroyed.

## What this does not decide

- What the follow-up ticket for sales quotation attachments and job artifacts does. No
  ticket exists yet.
- The Jira id (spec §12 Q2). It stays open.

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no
  frontmatter.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q1 and Q3: `Status:` set to
  `resolved — see decisions/2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md`.
  **Done.**
- The follow-up ticket is not created by this note. The developer raises it.
