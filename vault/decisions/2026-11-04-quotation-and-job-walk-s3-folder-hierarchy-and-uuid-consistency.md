---
title: Quotation and Job Walk S3 folder hierarchy and attachment owner UUID consistency
source: requester direction in this conversation, 2026-11-04
status: reference
conflicts_with: []
related_tickets:
  - MOBILE-REMAINING-PRESIGNED-FILES
related_decisions:
  - 2026-11-03-mobile-upload-attachment-metadata-consistency.md
  - 2026-11-03-mobile-remaining-presigned-files-scope.md
  - 2026-11-04-mobile-presigned-reads-viewers-approved-employee-files-owner-or-admin.md
tags: [module/quotations, module/field-ops, kind/decision, requirements]
---

# Quotation and Job Walk S3 Folder Hierarchy and UUID Consistency

## Context

The requester directed:
"I believe for quotation and job walk attachments or image uploads, we should have quotations S3 folder path. Instead of generic root `tenants/{tenantId}/attachments/{uuid}.{ext}`, it should be in tenant -> quotation. In attachments table, for these `feature_id` is not saving UUIDs? We should have consistency here and always save UUIDs for these uploads as well. Include this fix as well in this plan."

## Decisions

### 1. S3 Folder Scoping for Quotations and Job Walks

Instead of flat keys under `tenants/{tenantId}/attachments/{uuid}.{ext}`, quotation and job-walk files are scoped under the quotation's UUID hierarchy:

- **Quotation documents and plans:**
  `tenants/{tenantId}/quotations/{quotationId}/documents/{fileId}{.ext}`
- **Executed signed DocuSign PDF copies:**
  `tenants/{tenantId}/quotations/{quotationId}/signed/{fileId}.pdf`
- **Job Walk signatures and photos (nested under their parent quotation):**
  `tenants/{tenantId}/quotations/{quotationId}/job-walks/{jobWalkId}/signatures/{fileId}{.ext}`

### 2. UUID Consistency in `attachments.feature_id`

- **Quotation uploads (`POST /quotations/:quoteNo/attachments` and generic `/attachments/upload`):**
  Resolves `quoteNo` to `quotation.id` (UUID) before creating attachment rows.
- **DocuSign signed copy attachments (`SignedCopyAttachmentsService`):**
  Files quotation attachment targets under `quotation.id` (UUID) rather than `quotation.quoteNo`. Checks both `[quotation.id, quotation.quoteNo]` when skipping already-attached records to prevent duplicates on legacy quotations.
- **Job Walk uploads (`JobWalkReportsService.uploadSignature` and generic `/attachments/upload`):**
  `resolveUploadFeatureId` resolves `JOB_WALK` feature IDs (`jobWalkCode` or UUID) to `jobWalkReport.id` (UUID).

### 3. Backward Compatibility

- Existing attachment rows retain their stored `fileName` and `featureId` values.
- `findByFeature` continues dual lookup for `QUOTATION` (`[owner.id, owner.quoteNo]`) and `JOB_WALK` (`[report.id, report.jobWalkCode]`).
- No data migration or S3 object rewrites (Guardrail G2).
