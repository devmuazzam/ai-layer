---
title: Remaining mobile presigned file reads — implementation authorization
source: decision/requester — explicit instruction in this Codex conversation
decided: 2026-11-03
decided_by: >-
  The requester in this Codex session. Their personal name and organizational
  decision-making authority were not established. No identity is inferred from
  Git configuration. This records implementation direction from the requester,
  not adjudication of TCG client business rules.
status: reference
conflicts_with: []
related_tickets:
  - MOBILE-REMAINING-PRESIGNED-FILES
related_decisions:
  - 2026-11-03-mobile-remaining-presigned-files-scope.md
  - 2026-11-03-mobile-upload-attachment-metadata-consistency.md
  - 2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md
tags: [module/field-ops, module/quotations, kind/decision, requirements]
---

# Implementation direction for the remaining mobile presigned reads

## Decision

After the assistant explicitly confirmed that the metadata-only implementation
had not completed the remaining presigned URL migration, the requester said:

> add this missing work in plan and update it as per AI DLC and perform all phases of AI DLC and implement it

This authorizes updating the plan and implementing the missing read migration
through AI-DLC. It supersedes the planning-only limitation in
[the original scope note](2026-11-03-mobile-remaining-presigned-files-scope.md)
and the metadata-only/no-viewer/read-transport exclusion in
[the metadata implementation note](2026-11-03-mobile-upload-attachment-metadata-consistency.md).
Those notes remain historical records of the earlier direction; their retained
GET-only, upload and metadata requirements continue to apply.

## Scope retained and restored

The requester had already answered “Presigned viewing/downloads; keep current
uploads”, “No ticket” and “Include open/share in this follow-up”. Keep existing
API multipart uploads; direct-to-S3 presigned PUT uploads are outside this work.
Preserve the completed resource-UUID feature_id normalization and appropriate
feature_type/category for all audited mobile uploads.

The current ticket spec includes the missing signed GET opening/sharing in both
quotation cards, linked permit/plan/purchase-order files, saved certification
documents and saved operator/foreman job-walk signatures. It also includes saved
JSA image/signature rendering and saved incident evidence/signature viewing,
which the requester raised in this same conversation. The previous incident
viewer deferral does not exclude this current saved-file read scope. Existing
incident reporting, MIME processing and permission/lifecycle rules remain the
boundary; this does not authorize an incident workflow redesign.

Implementation choices, exact acceptance and completed-versus-pending status
belong in `.ai/aidlc/MOBILE-REMAINING-PRESIGNED-FILES/spec.md`, `plan.md`,
`units.md` and `state.md`. This note records authorization, not runtime proof,
deployment, merge or verified client business intent.

## Why

Metadata consistency alone did not complete the original presigned viewing and
download objective. The requester explicitly asked to restore and implement the
missing work after that distinction was stated. Their latest instruction replaces
the earlier delivery restrictions without changing the previously resolved upload
transport decision.

## Effect on the vault

- Created this requester-direction note with status `reference`; no human name or
  authority was inferred and no source was promoted to `verified`.
- Added explicit partial-supersession pointers in the frontmatter of
  `2026-11-03-mobile-remaining-presigned-files-scope.md` and
  `2026-11-03-mobile-upload-attachment-metadata-consistency.md`. Historical bodies
  and still-applicable requirements are intact.
- No field-ops or quotation source conflict is adjudicated, no tooling/rule file
  changed, and no historical attachment data rewrite is authorized.
