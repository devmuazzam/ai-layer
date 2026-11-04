# Guardian review — remaining presigned reads

2026-11-03. Read-only review of U1 API source against `tcg-prisma-guardian` and `contexts/prisma.md`; no API changes made by this reviewer. The reviewer separately implemented the assigned mobile quotation/certification/job-walk UI slice, so this report does not claim independent review of that UI.

## Verdict

No tenant-isolation or schema blocker found in the reviewed API diff. This is static source inspection, not a live cross-tenant or S3 execution result.

## Isolation

- **VERIFIED:** `Attachment`, `EmployeeCertification` and `JobWalkReport` are tenant-bearing models in `TENANT_SCOPED_MODELS` (`apps/api/src/orm/prisma.service.ts`). The Prisma extension deliberately skips missing request contexts and SUPER_ADMIN, so allowlisting alone is not accepted as proof.
- **VERIFIED:** `AttachmentsService.findForSignedAccess` obtains the request tenant and uses `findFirst({ where: { id, tenantCompanyId } })`. The new route therefore explicitly constrains tenant ownership even when the extension bypasses SUPER_ADMIN. The base repository forwards those arguments to the attachment delegate.
- **VERIFIED:** `/attachments/:id/links` is not public, accepts a UUID through `ParseUUIDPipe`, and loads its row before signing. `AccessTokenGuard` is globally registered in `app.module.ts`; request tenant context is established by the existing interceptor.
- **INFERRED:** The route preserves the generic download's existing authenticated tenant-wide file access policy. It does not introduce employee-self, crew-only or parent module permission restrictions. This deliberate boundary is recorded in spec.md §8/D1; the endpoint must not be described as enforcing those stricter policies.
- **VERIFIED:** The controller signs only `attachment.fileName`, never a caller-supplied S3 key. Every file receives `presignDownloadUrl`; only the explicit raster image MIME whitelist receives an optional `presignGetUrl` preview. Existing storage download signing forces attachment disposition and octet-stream response type.
- **VERIFIED:** Certification `attachmentId` association consumes the already-loaded `attachmentCerts`. `MeRepository.findCertificationsData` constructs that set with `employeeAttachmentWhere`, which explicitly includes tenant, EMPLOYEE type, canonical/legacy employee aliases and uploader-constrained literal `me` rows. No new name-only database query or cross-employee association was added.
- **VERIFIED:** Credential id, status and expiry deduplication remain unchanged. Document identity is selected separately by the same normalized name, newest createdAt then UUID tie-breaker; this technical choice was sent to the primary agent for the decisions table.
- **VERIFIED:** Job-artifact API queries and crew gate were not changed in U1. New file opens use the authorized generic links route; existing artifact listing retains its current crew filter. The generic endpoint is tenant-wide by the explicit policy above, not a claim of crew authorization on every file open.

## Necessity / identity / migration

No new model, column, enum, relation, migration, stored signed URL, backfill or data rewrite. Existing UUID attachment identity and U0 canonical `feature_id`/`feature_type`/`category` upload behavior remain intact. Optional certification `attachmentId` is response metadata, distinct from its existing polymorphic credential `id`.

## Queries

No new database N+1: one attachment lookup per deliberate open; certification association is an in-memory map over the existing owner-scoped query. Existing unbounded per-owner certification reads and legacy job-artifact alias queries are unchanged. No raw SQL or outside-request signing path was introduced by the reviewed diff.

## Evidence and limits

Reviewed `git diff` for attachment controller/service and MeService; inspected BaseRepository, employee owner predicate, MeRepository, global guard/interceptor registrations, S3 signing implementation and Prisma allowlist. `git diff --name-only -- apps/api/prisma apps/api/src/service/me apps/api/src/usecase/field-tickets` returned no changes. Live auth, cross-tenant requests, signed URL expiry and real object download remain runtime checks for the primary handoff. No new tests requested or added.
