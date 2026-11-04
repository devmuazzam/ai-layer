---
title: Mobile upload attachment metadata consistency
source: requester direction in this conversation, 2026-11-03
status: reference
superseded_by: decisions/2026-11-03-mobile-presigned-read-implementation.md
provenance_note: >-
  Metadata-only and no-viewer/read-transport exclusions are superseded by the requester implementation direction; metadata consistency remains required. See decisions/2026-11-03-mobile-presigned-read-implementation.md
conflicts_with: []
---

# Current implementation scope

The requester said: "We need to add consistency for these", then clarified that every mobile image/attachment upload must follow patterns.md and save the resource UUID in feature_id with the appropriate feature_type and category.

This authorizes the metadata consistency implementation. It covers all nine binary-upload operations identified by the mobile audit. The current task does not add viewers or change upload/download transport. Earlier presigned-viewing proposals remain archived for separate consideration.

Resolve business-code/legacy user identifiers within the owning tenant before new attachments are saved. Preserve older rows through compatible reads; no data backfill or object rewrite is authorized. Specific category choices and compatibility mechanisms are technical decisions recorded in the current spec/plan.

The requester was not personally named; Git identity is not used to infer their authority. This is developer/requester direction, not adjudication of TCG client business rules.
