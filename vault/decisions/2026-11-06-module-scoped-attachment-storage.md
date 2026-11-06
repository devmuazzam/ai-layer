---
title: Module-scoped attachment storage — new writes only, historical files unchanged
source: decision/requester — explicit directions in the current Codex conversation
decided: 2026-11-06
decided_by: >-
  The requesting developer in this conversation. Their personal name and organizational
  decision-making authority were not supplied; Git identity is not used to infer them.
  This records authorized technical planning scope, not a TCG client business ruling.
status: reference
conflicts_with: []
related_tickets:
  - MODULE-SCOPED-ATTACHMENT-STORAGE
  - MOBILE-TICKET-STRICT-S3
related_decisions:
  - 2026-11-04-quotation-and-job-walk-s3-folder-hierarchy-and-uuid-consistency.md
  - 2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md
tags: [kind/decision, architecture, module/admin, module/quotations, module/projects-jobs, module/assets, module/field-ops]
---

# Module-scoped storage planning applies only to new files

## Source

The requester asked:

> This has been merged, next plan to fix all remaining places that uses legacy tenants attachments path with S3 folder path URLs specific to that module. Analyze the code review and then plan it using AI DLC

After being asked whether historical files should be migrated, retired or both alternatives
planned, the requester answered exactly:

> No need to handle historical files or retire their availability.

## Decision

- Plan module-specific tenant/owner S3 keys for **new uploads and newly generated files**
  produced by the remaining flat-key writers. Canonical folders use server-resolved owner
  UUIDs; technical path choices belong in the spec's AI decisions.
- Existing historical files, stored keys, metadata and their currently supported access
  remain unchanged. This task does not migrate, backfill, move or rewrite them and does
  not retire their availability.
- Historical migration, historical availability retirement and physical prefix/folder
  deletion are **outside this task's scope**, rather than blocked phases that this ticket
  must later execute. The earlier mention of future folder deletion is motivation only;
  it is not deletion approval or evidence that the prefix is safe to remove.
- Preserve current endpoint contracts, permissions, workflow side effects, supported file
  representations and already-structured storage paths while planning the new writers.
  Generic API route names are distinct from object-key paths. No blanket streaming-route
  removal or blanket `featureId` rewrite is authorized.
- The earlier ticket-only strict retirement in the 2026-11-05 decision remains unchanged.
  This answer does not restore already-rejected ticket legacy access or extend that
  retirement to other modules.
- The request remains analysis/planning only; it does not authorize application changes,
  database/S3 mutation, deployment or deletion.

## Effect on the record

This note resolves MODULE-SCOPED-ATTACHMENT-STORAGE spec §12 Q1 by excluding historical
handling from the task. The spec removes the conditional historical migration/retirement
requirements and retains Q1's question, exact answer and this reference as history.
Existing quotation/job-walk preservation decisions and broad module conflict stubs remain
unchanged. No product-vault body, source status or tooling rule is promoted or rewritten.
