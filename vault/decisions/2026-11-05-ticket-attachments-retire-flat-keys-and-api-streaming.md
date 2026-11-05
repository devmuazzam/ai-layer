---
title: Ticket attachments retire legacy flat S3 keys and API streaming — implementation direction
source: decision/requester — explicit task in the current Codex conversation
decided: 2026-11-05
decided_by: >-
  The requesting developer in the current Codex conversation. Their personal name
  and organizational decision-making authority were not explicitly supplied. Git
  identity is not evidence of requester identity. This records the explicit technical
  scope authorized for this build, not a TCG client ruling on business behavior.
status: reference
conflicts_with: []
related_tickets:
  - MOBILE-TICKET-STRICT-S3
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md
  - 2026-10-28-ticket-attachment-feature-id-holds-ticket-uuid-old-rows-keep-code.md
tags: [module/field-ops, kind/decision, architecture, ticket-workflow, requirements]
---

# Strict ticket S3 hierarchy and direct presigned reads

## Decision

Source: the developer's task, captured in
`.ai/aidlc/MOBILE-TICKET-STRICT-S3/intent.md` §§3–5, and their follow-up instruction
to plan and implement through the AI-DLC lifecycle with its role agents.

The developer explicitly says historical pre-migration compatibility is no longer
needed. For this build:

- Ticket uploads require image or plain-file storage configuration. Remove the
  fallback writing `tenants/{tenantId}/attachments/{uuid}{ext}`.
- Ticket images use only
  `tenants/{tenantId}/job-tickets/{ticketId}/attachments/{attachmentId}/original.webp`
  and `preview.webp`; reads expect both variants and deletion addresses both.
- Ticket documents/non-images use
  `tenants/{tenantId}/job-tickets/{ticketId}/documents/{fileId}.{ext}` with a
  sanitized extension. Reads and deletions reject legacy/outside-hierarchy keys
  rather than accessing them through a compatibility branch.
- Ticket attachment opening/download uses direct S3 presigned URLs. Remove the
  field-ticket API byte-streaming method/route and mobile streaming fallback.
  When opening an expired link fails, refresh attachment metadata and retry with
  its fresh S3 URL. Retry mechanics belong in the ticket's AI decisions.
- Historical objects and rows are not backfilled, rewritten or deleted by a
  migration in this task. Historical flat objects lose compatibility deliberately.

This replaces the flat-file fallback accepted in
`MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §11b D5 and §12 Q3, and the retained
field-ticket stream fallback in D9, only for the ticket hierarchy/transport scope
of the current task. The original decisions remain historical records.

## Why

The requester identifies the compatibility branches as technical debt that makes
storage behavior ambiguous and bypasses the intended direct S3 presigned access
architecture. Their acceptance criteria explicitly require structured ticket keys
and no ticket attachment payload streaming through the API.

## Boundaries

- Existing ticket authorization, tenant scope, metadata and database identity stay
  within existing rules. The ticketCode/UUID `feature_id` dual ownership match in
  the 2026-10-28 identity decision is not retired by this S3-key cleanup.
- No schema/data rewrite, new dependency, payroll rule, unrelated generic download
  endpoint removal, or field-ops workflow redesign is authorized here.
- The broader field-ops sources still conflict:
  `field-ops/field-ops-mobile-INDEX.md` names all three unverified candidates. This
  technical instruction does not choose a winner or close that conflict.
- This note records requested behavior, not completion, runtime proof, deployment
  or a named client's verified product decision.

## Effect on the vault

- Created this implementation-direction note with status `reference`; no source is
  promoted to `verified` and no requester name is inferred. **Done.**
- Added a scoped `provenance_note` to
  `2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md`
  pointing here for the retirement of Q3's fallback. Its Q1 scope and no-backfill
  record remain applicable; historical body and `status: reference` stay intact.
  **Done.**
- The 2026-10-28 `feature_id` identity decision and the broad field-ops conflict
  remain unchanged. No tooling or source-code file is changed by this note.
