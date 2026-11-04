---
title: "New ticket attachment rows store the ticket UUID in attachments.feature_id, rows written before 2026-10-28 keep the ticketCode and are not rewritten, and every read accepts either value — decision"
source: decision/Syed Haris (CodingCops) — spec §11b D12 in MOBILE-TICKET-PRESIGNED-IMAGES, 2026-10-28, after device testing
decided: 2026-10-28
decided_by: >-
  Syed Haris (CodingCops), the requester and owner of MOBILE-TICKET-PRESIGNED-IMAGES, in a
  live Claude Code session on 2026-10-28. He saw feature_id = 'TK-00028' on rows the mobile
  app had uploaded to the local DB and decided the value was incorrect. The decision is
  recorded in .ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md §11b D12 ("Haris (decided in
  session)") and state.md, and it is built in commit 51f233353 (author haris). tcg-scrum did
  not see the session. It records from the spec, state.md and the commit. This is a
  developer and requester decision. It binds this build. It is not a TCG client ruling, so
  the status is reference.
status: reference
resolves:
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#d12
conflicts_with: []
related_tickets:
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md
  - 2026-10-28-web-ticket-progress-and-meter-reading-images-on-presigned-covers.md
tags: [module/field-ops, kind/decision, architecture, ticket-workflow]
---

# Ticket attachment rows reference the ticket by UUID

## Decision

Source: `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §11b D12 and REQ-07 (Notes for the
executor, amended 2026-10-28). Haris, 2026-10-28.

- **New rows store the ticket UUID.** New `attachments` rows of the four ticket feature types
  store the ticket's UUID (`ticket.id`) in `feature_id`. They no longer store the per-tenant
  `ticketCode`. The four types are `JOB_TICKET`, `TICKET_SIGNATURE`, `CHECKLIST` and
  `TICKET_INCIDENT`.
- **Old rows are not rewritten.** Rows written before 2026-10-28 keep their `ticketCode` in
  `feature_id`. There is no backfill.
- **Every read and ownership check accepts either value.** As built (D12):
  - `ticketFeatureIds(ticket) = [ticket.id, ticket.ticketCode]` and `isTicketFeatureId` in
    `TicketAttachmentGuardService`.
  - A new tenant-scoped `AttachmentsRepository.findByFeatureIds`.
  - `clientUploadId` idempotency matches either form.
- **No schema change and no migration.** Only the comments in
  `apps/api/prisma/schema.prisma` change. They now say that `featureId` holds the ticket's
  UUID, and that rows written before 2026-10-28 hold its `ticketCode`.
- Built in commit `51f233353` on `feat/MOBILE-TICKET-PRESIGNED-IMAGES-u5-documents`.

**This reverses a documented choice.** Before this change, the schema comments recorded
`ticketCode` in `featureId` on purpose: "the generic per-ticket listing convention" (spec D12).
Spec REQ-07 also said the DB `featureId` column still held `ticketCode` and only the S3 key
used the UUID. That REQ-07 line is amended and the old text is kept there.

## Why

As recorded in D12:

- Haris saw `feature_id = 'TK-00028'` on rows that the mobile app had uploaded to the local
  DB, and decided it was incorrect.
- His reason is the root `CLAUDE.md` identity rule. Children reference the parent by UUID.
  Routes and DTOs use the code.
- Rows written before 2026-10-28 stay readable without a backfill, because every read and
  ownership check matches both values.

Alternatives recorded in D12:

- **Backfill old rows to the UUID.** Not done. It is a data rewrite, which is guardrail G2. A
  backfill can follow later, with developer approval and a dry run on a staging copy.
- **Store the code and keep the UUID only in S3 keys.** That was the previous state. Haris
  rejected it.

## What this does not decide

- **Whether old rows will be backfilled, or when.** Nobody has approved or scheduled a
  backfill, and no ticket exists for one. Any backfill is G2: it needs developer approval and
  a guard run on a copy of staging data.
- **When the dual match can be removed.** D12 says the dual match is what keeps rows written
  before 2026-10-28 visible. No source says when it can be removed.
- **Any `feature_id` value outside the four ticket feature types.** D12 covers only
  `JOB_TICKET`, `TICKET_SIGNATURE`, `CHECKLIST` and `TICKET_INCIDENT`.
- **The S3 key layout.** It already used the ticket UUID (spec D1). This decision does not
  change it.
- **No product behaviour.** No TCG person ruled on this. It is a data-identity rule for this
  build.

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no
  frontmatter.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md`: there is no §12 question for D12, so no
  `Status:` line changes. The D12 row already names Haris as reviewer, and the REQ-07
  amendment was already made. This note edits neither.
- Like Q3 (`decisions/2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md`),
  this decision leaves existing rows as they are. That note covers old image objects and
  variants. This note covers the `feature_id` value.
