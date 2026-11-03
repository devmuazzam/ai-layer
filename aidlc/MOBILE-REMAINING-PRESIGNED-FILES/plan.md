# Plan — complete mobile presigned reads and consistent attachment metadata

Updated 2026-11-03. No external ticket. **Current work is Path A continuation**, explicitly authorized by the requester to add the missing work, follow all AI-DLC phases and implement. The former metadata-only exclusion is superseded. See current spec.md and units.md; archived presigned-read-plan/spec are history, not the current scope.

## Outcome and delivery boundary

Preserve completed upload metadata consistency and finish presigned GET viewing/opening/sharing across the remaining mobile file surfaces. Uploads retain current multipart API transport. No schema migration, dependency, object move or existing-row backfill. This is one remaining-mobile-file-read migration with shared signing/opening and rendering siblings, on `codex/mobile-presigned-reads`, stacked on published `codex/attachment-metadata-consistency`. Prior ticket-image dependency is on staging, so do not rebase away onto an incompatible main baseline.

## AI-DLC phases

| Phase | Deliverable / current disposition |
| --- | --- |
| Triage / intent | Path A continuation; intent.md records latest explicit implementation request and superseded exclusions |
| Elaborate | spec.md REQ-01..06, acceptance/edges/sources; zero OPEN requirements |
| Decompose | units.md: completed U0 metadata parent, one vertical U1 remaining read migration; all six requirements covered |
| Execute | U1 implements API authorization/links, mobile consumers and required compatible contract changes together |
| Analyse | Independent contract/tenant/source review plus existing checks; record exact results and runtime limits in review.md/state.md |
| Reflect | Record actual outcome, residual gaps and follow-ups after construction; no merge/deployment claim without evidence |

The requester has authorized implementation. Technical endpoint/reuse choices are AI decisions for review, not another confirmation gate. No PR, merge, deployment or automatic check bypass is inferred.

## Complete upload metadata coverage — completed baseline retained

Nine binary-upload operations across eight HTTP adapters; shared signature uploaders serve multiple screens.

| Upload | feature_type | Canonical feature_id | Category |
| --- | --- | --- | --- |
| Certificate renewal | EMPLOYEE | Employee UUID | Certification name; preserve catalog/legacy linkage normalization |
| Quotation general/create attachment | QUOTATION | Quotation UUID | Quotation Attachment when none supplied |
| Quotation plans/documents batch | QUOTATION | Quotation UUID | PLAN_OR_DOC |
| Job-walk operator/foreman signature | JOB_WALK | JobWalkReport UUID | Job Walk Operator Signature / Job Walk Foreman Signature |
| Ticket Attach File | JOB_TICKET | Ticket UUID | Ticket Attachment |
| Customer/compliance/JSA/checklist signature and identity upload | TICKET_SIGNATURE | Ticket UUID | Ticket Signature until precise link-time label |
| Lunch WTL signature/identity upload | TICKET_SIGNATURE | Ticket UUID | Ticket Signature until Lunch WTL 1..4 linking |
| Pretrip/posttrip/JSA checklist photo | CHECKLIST | Ticket UUID | Existing checklist label or Checklist Photo until submit |
| Incident evidence image/video | TICKET_INCIDENT | Ticket UUID | Incident Evidence; incidentReportId identifies incident UUID |

Incident customer signatures reuse TICKET_SIGNATURE then receive Incident Evidence when linked. Existing UUID/code/User-ID aliases and uploader-scoped legacy me reads remain; no backfill. General quotation files never become PLAN_OR_DOC or profile photos by default. Completed metadata code is the parent, not evidence that presigned reading was already delivered.

## Remaining reads — U1 delivery matrix

| Surface | Planned visible behavior | Existing route/data retained |
| --- | --- | --- |
| Quotation general attachments | Open/share every saved file with signed S3 GET | Existing list/upload/delete and category distinction |
| Quotation Plans & Documents | Same open/share, including when upload is disabled | PLAN_OR_DOC and send restrictions |
| Create/edit wizard picks | Continue local name/type/size until save; saved files use migrated cards | No remote request for unsaved files |
| Certification documents | Open uploaded saved document; no broken action when none exists | Certification id/status/dedup, optional distinct attachmentId, current-user employee visibility |
| Saved job-walk signatures | Read-only saved report list/card on quotation Attachments tab; view/open operator and foreman | Existing list(quoteNo), role attachment IDs, local SignaturePad upload workflow untouched |
| Linked job documents | Signed open/share for permit, plan and PO files | Existing crew-authorized artifact response and metadata fields |
| Saved JSA | Remote saved deficiency photos/signatures render from live covers; local capture preferred when matching | Existing assignments/answers/attachment IDs, no expiring URLs in draft |
| Saved incidents | View saved evidence images/signature; open/share non-image files such as video | Existing incident API signed fields, ticket access, MIME/submission behavior |
| Ticket/profile/entity photos already signed | Regression-check existing behavior | Existing cover/signature fields and upload processing |

## Common implementation decisions

1. Add authenticated `GET /attachments/:id/links` returning `{ id, originalName, mimeType, url, previewUrl? }`. Explicitly constrain the loaded row to current tenant, retain existing generic attachment download access policy, sign only its server-stored key, and return no user-supplied S3 key capability. Guardian reviews tenant/access boundary; contract tracer reviews exact response.
2. `url` uses `presignDownloadUrl`; an image-only `previewUrl` uses `presignGetUrl`. Reuse current signer/TTL and existing native opener/AttachmentImage. Legacy flat keys sign directly without moving objects.
3. Mobile asks for links on demand when opening. Reuse the same helper for linked job artifacts, so their response/DTO need no signed-URL addition. No per-row link requests merely to list filenames. Component preview state is transient and cleared when its owner changes.
4. Request fresh links on opening and refresh once after a signed fetch fails. Keep API byte routes compatible with older clients; no normal new mobile read uses arraybuffer as its primary path. Do not send API bearer headers to S3. Preserve share cancellation/error behavior; do not mistake native sharing errors for link expiry.
5. Certification `id` can identify EmployeeCertification or Attachment. Add optional `attachmentId` independently, associate the matching uploaded document without changing existing certification identity/status/expiry dedup, and preserve rows without documents. New attachment IDs are not guessed from certificate IDs.
6. Use existing job-walk list(quoteNo) and saved role IDs for a read-only signature card on quotation detail. Do not add edit hydration or change clearing semantics. Persist no signed URLs in the job-walk store.
7. Feed JSA existing live photo/signature covers into current components with attachment-ID matching and refetch callbacks. Incident saved viewer consumes existing images/files/signatureImage. Keep local captures, video classification and reporting workflows intact.
8. Generic list/upload/download routes and web blob consumers remain compatible. No new shared export expected; if one changes, update all callers in this unit and rebuild shared dist before consumers.

## Checks and truthful status

Fresh continuation baseline is **pending execution/results**, not inferred from the parent. Mobile typecheck passed (14 s; `/tmp/presigned-baseline-typecheck.log`); selected existing suites are running under `/tmp/presigned-baseline*`. The initial suite command had a shell quoting failure before Jest and is being rerun; no application failure is inferred. Executor records exact results. Historical parent gates and approved one-time publication exception remain in publication.md and are not authorization to skip current checks.

Run existing checks appropriate to the final diff through pnpm nx: shared build; API lint/build and affected attachment/Me/job-walk/ticket/incident/checklist suites; mobile lint/typecheck and existing card/service/helper/certification/JSA/incident suites. Run affected web checks for any changed shared response/export. New tests are **not requested**. Constructor/module changes require an API boot check. Every failure is triaged against an observed baseline rather than assumed pre-existing.

Named runtime checks: iOS/Android open/share names and MIME; signed S3 requests without bearer headers; both quote cards and both job-walk roles; certificates with/without documents; all three artifact types; saved JSA/incident content absent local cache; video opens as file; bounded expiry refresh; missing/deleted objects; cross-tenant access; existing upload/delete/category/metadata behavior. Mark unavailable device/API/S3/DB checks explicitly; passing mocked suites is not runtime evidence.

## Handoff

Execute U1 in units.md, then analyse and reflect with exact evidence. Keep state/ledger current. The overall migration is complete only when the new controls and renderers consume signed links across the delivery matrix; API schemas or upload metadata alone do not establish completion. Unrelated web blob conversion and server-generated signed-copy metadata writers remain recorded follow-ups.
