# Proposed plan — remaining mobile presigned files

2026-11-03. **Review draft, not an approved execution handoff.** Read state.md first on resume; audit.md contains the evidence and spec.md the sourced requirements. No external ticket. The requester authorized audit/planning and answered the scope questions; application implementation has not been requested.

## Triage and agreed scope

Current activity is review/exploration and does not enter a build loop (GUIDE.md §2). The candidates below are separate reviewable tasks/PRs: artifact transport parity is Path C; new quotation open/share is Path A; missed JSA rendering is Path B against the prior ticket's image requirements. Do not reopen the closed MOBILE-TICKET-PRESIGNED-IMAGES ticket.

Requester direction: signed GET viewing/downloads, existing multipart uploads retained, quotation attachment open/share included. No direct-to-S3 PUT design. No backfill, S3 object moves, certificate/job-walk viewers or new incident viewer. Web consumers reached by an API change remain compatible; the unrelated web blob migration is recorded as a follow-up.

## Candidate ledger

These are candidate slices, not formal units. No units.md is produced before spec review. One independent task per PR; no backend-only foundation is needed.

| Candidate | Draft requirement | Visible outcome | Prospective path | Surfaces | Dependency | Estimate |
| --- | --- | --- | --- | --- | --- | --- |
| C1 | REQ-01 | Crew opens linked permit, plan and PO files directly from signed S3 links | C | API + mobile | Existing migrated ticket baseline | roughly 6–10 files, 150–300 source lines |
| C2 | REQ-02 | Sales opens/shares files from BOTH quotation attachment cards | A | API + mobile; web compatibility checks | Existing signer/opener; C1 is useful validation, not a code dependency | roughly 8–14 files, 250–500 source lines |
| C3 | REQ-03 | Saved JSA deficiency photos and signatures render when local copies are absent | B | Mobile | Existing checklist response covers | roughly 4–8 files, 150–350 source lines |

Estimates are planning ranges, not budgets. C1 and C2 can ship independently; sequence them to simplify file-contract review. C3 is independent and can be prioritized separately. If a shared helper or export is changed, its existing consumers are checked in the introducing PR and any dependent PR stacks on it. Never assume the historical baseline is on origin/main: inspect the target branch before branching. Use the commit skill and `codex/` branch prefix at implementation time.

## C1 — linked job documents

- **Slice:** extend the existing authorized `GET /field/tickets/:ticketId/job-artifacts` response's file metadata for permits, plans and purchase orders with an optional signed download `url`. Update `job-artifacts.types.ts`, presentation DTO, all three API mappings and mobile `JobArtifactFileSchema` in the same task. Reuse `presignDownloadUrl`; old flat keys are signed directly.
- **Mobile:** `JobArtifactsSection` opens through existing `openAttachmentFromUrl`; use the current authenticated byte downloader for absent/failed links and refresh list metadata after signed-link failure, matching ticket attachment compatibility. Do not send bearer headers to S3.
- **Authorization:** sign only records assembled after `FieldTicketsService.getJobArtifacts` resolves the tenant-scoped ticket and checks existing crew membership. No new client-supplied key or unrelated attachment ID signing route.
- **Ripple:** all three artifact categories, TicketDetails in the ticket route and shared step shell, old mobile builds, web callers of generic `/attachments/:id/download`, and the existing ticket attachment opener. Keep response metadata and stream routes compatible.
- **Check:** open old flat-key and current-key PDF/image files from each category; verify signed S3 requests in network evidence, filename/MIME/native sharing; exercise absent/expired URL and existing error behavior, unauthorized crew, other tenant and non-employee access under existing rules. Source review alone cannot establish runtime access.
- **Schema/shared/tests:** no schema/migration/shared export expected. New tests not requested; run existing relevant API/mobile targets and manual checks.

## C2 — sales quotation open/share

- **Slice:** enrich the existing `GET /quotations/:quoteNo?include=attachments` response after `QuotationsService.findOne` resolves the quotation in the current tenant, loading only its matching attachments before signing. Reuse the existing repository lookup and storage signer. Update the mobile quotation attachment list/listAll wrappers to extract that additive response; do not enrich every polymorphic `GET /attachments` list. This choice is recorded for review in spec §11b; no new endpoint is expected.
- **Mobile:** model the optional signed `url` in the local Zod contract and wire the existing file opener to both `QuotationAttachmentsCard` (PLAN_OR_DOC) and `QuotationGeneralAttachmentsCard`. Preserve each card's category filtering, upload/delete controls, validation and signed/lost quote upload restrictions. Read/open behavior must not inherit an upload-only disabling condition.
- **Compatibility/error behavior:** preserve raw metadata lists, upload result shapes and generic byte routes. Reuse the existing signed-first/native-share behavior and file error handling; missing/failing URL can use the existing authorized byte flow. No extra thumbnail/gallery requirement is invented by open/share.
- **Authorization concern:** generic attachment list/download routes currently have tenant filtering but no owner/module-permission check. A metadata list becoming reusable signed byte access deserves explicit review. Preserve current quotation visibility; do not silently introduce a stricter role policy, public signing, or URLs on unrelated entity lists.
- **Ripple:** both cards, create-time uploads that later appear in general attachments, quotation quick action, upload response parser, and web attachment hooks/notes/certificates using generic byte download. Existing upload-only certification/job-walk surfaces stay upload-only.
- **Check:** upload a plan/doc and general file, refetch, open/share each; check original names, MIME, spaces/unicode names, missing/deleted object, expired/missing URL, and existing upload/delete restrictions. Exercise identical business codes in separate tenants, unknown quotation, signed/lost quotation read permissions, and old API/mobile compatibility. Baseline old generic endpoints must keep returning bytes.
- **Schema/shared/tests:** no schema/migration/new dependency/new shared type expected. New tests not requested. Run contract tracer again against the exact proposed endpoint before implementation.

## C3 — saved JSA images

- **Slice:** connect existing live JSA assignment covers to the deficiency preview and saved-signature modal, with attachment-ID matching and the existing checklist refetch callback. Server already returns `photoImage` and `signatureImage`; no API change is expected.
- **Local/offline:** prefer an existing local capture file, then the matching live cover. Keep IDs and local paths in persisted captures; do not persist expiring signed URLs or replace a new unsynced capture with an older server image. Do not repair the gap by rebuilding authenticated `/download` preview URLs.
- **Ripple:** JSA composition/rehydration, deficiency panel, signature modal, shared image components; pre/post-trip/signature/lunch readers are checked if shared code changes. Dormant generic SignatureBody is not an active reader to migrate.
- **Repro/check:** save a JSA deficiency photo and signature, remove only local draft/cache copies or reopen on a second device, refetch assignments and verify display using covers. Then check sign again, new unsynced photo, cancelled capture, offline local preview, deleted photo and expired URL refresh. Source evidence identifies the gap; a device repro still needs to be captured for Path B.
- **Schema/shared/tests:** none expected; no new tests requested. Run existing JSA/rehydration and shared-image cases, plus mobile lint/typecheck.

## Verification and rollout

**Gate baseline: NOT RUN.** This is a documentation/source audit. Before building a candidate, record a real baseline for its actual PR base; do not copy the previous ticket's skipped gates or historical failures.

Existing target names were checked in root/app package.json. Implementation checks, selected per candidate:

```bash
pnpm nx run @tcg/shared:build
pnpm nx run @tcg/mobile:lint
pnpm nx run @tcg/mobile:typecheck
pnpm nx run @tcg/mobile:test
NODE_OPTIONS=--max-old-space-size=4096 pnpm nx run @tcg/api:lint
NODE_OPTIONS=--max-old-space-size=4096 pnpm nx run @tcg/api:build
pnpm nx run @tcg/api:test
```

If an endpoint or export consumed by web changes, run relevant existing web lint/typecheck/build/test targets and the named manual attachment checks. No test files/cases are added without developer request. The nx-workspace skill was absent from available skill roots; no dependency/skill installation was attempted for this audit.

Deploy additive API changes before new mobile reads; retain old stream endpoints for older builds and compatibility fallbacks. Verify old mobile/new API and new mobile/old API. Signed links expire (current signer: 24 hours, hour-stable signing); local persistence lives longer, so refresh from the authorized API rather than treating a saved URL as permanent. Verify iOS and Android file sharing and real S3 requests. No browser/device/S3/DB validation has been performed in this session.

## AI-DLC next handoff

Review spec §11b choices and §11c siblings. Once the scope/spec is accepted for execution, run formal decomposition into units.md, keeping the independent task/PR boundaries above. Before execution: Path B gets a concrete JSA repro; each API contract change reruns tracer; tenant/signing boundary reruns guardian against the actual diff. Executor builds one candidate, analyst checks it independently, and reflector/close-ticket records shipped outcomes after merge. No construction or merge status is claimed by this plan.
