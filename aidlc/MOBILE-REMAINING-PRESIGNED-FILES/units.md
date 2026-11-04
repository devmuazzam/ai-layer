# Units — MOBILE-REMAINING-PRESIGNED-FILES

2026-11-03. Decomposed from the current spec.md after the requester explicitly authorized the remaining read migration and implementation through AI-DLC. No external ticket. One cohesive remaining-mobile-file-read migration, with JSA and incident siblings, is one vertical unit; no foundation split or size budget.

## Gate baseline

**Gate baseline:** pending fresh execution on the actual parent, `codex/attachment-metadata-consistency` at `1d439ae58` (derived from origin/staging because the migrated ticket-image dependency is absent from origin/main). Current continuation branch: `codex/mobile-presigned-reads`. Mobile typecheck passed (14 s; `/tmp/presigned-baseline-typecheck.log`); selected existing suites are running, logs `/tmp/presigned-baseline*`. The first suite command failed at shell quoting before Jest, not in application tests, and is being rerun. No new gate is reported green before its result is observed. Executor records exact baseline and final results in review.md/state.md before handoff.

Historical parent validation is in publication.md: API full tests, web tests, affected lint/typecheck and builds passed; full mobile had baseline failures and the prior user approved a one-time publication exception. That approval does not authorize skipping this continuation's checks and is not a fresh baseline. No new tests requested.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U0 | Every audited mobile upload uses canonical owner UUID/type/category with compatible legacy reads | REQ-01 | api/mobile | Existing ticket-image migration on staging | Completed parent, 19 files | built — codex/attachment-metadata-consistency |
| U1 | Saved mobile files open through signed S3 URLs and saved JSA/incident images render, retaining canonical upload metadata | REQ-01 regression, REQ-02, REQ-03, REQ-04, REQ-05, REQ-06 | api/mobile; web compatibility | U0 | ~600–1100 source lines / 20–35 files | built — fix/mobile-presigned-reads |
| U2 | Quotation documents, signed PDF copies, and Job Walk signatures are stored in scoped S3 paths and consistently persist UUIDs in attachments.feature_id | REQ-07, REQ-08 | api | U1 | ~100–150 source lines / 6 files | built — fix/mobile-presigned-reads |

- Requirements covered: eight in spec.md §1, eight covered on 2026-11-04. REQ-01 is completed U0 plus U1 regression; REQ-02..06 are U1 delivery; REQ-07..08 are U2 delivery. No uncovered or partially omitted requirements.

- Units blocked on an open question: none. Endpoint/reuse choices are AI decisions, already authorized, subject to contract/guardian review.
- U0 is a published parent, not a merged claim. No PR or deployment is asserted.

## U0 — completed attachment metadata parent

- **Outcome:** All nine audited mobile upload operations save the owning resource UUID and appropriate attachment type/category while existing aliases remain readable.
- **Kind:** vertical.
- **Requirements covered:** REQ-01 fully; retained and regression checked by U1.
- **Depends on:** Prior ticket-image migration on staging.
- **Branch / PR base:** `codex/attachment-metadata-consistency` based on origin/staging; published parent, no PR/merge requested or claimed.
- **Size estimate:** Historical implementation 19 source files, approximately 280 added lines.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | Comment only | No migration or stored data rewrite |
| API (`apps/api`) | Employee/quotation/job-walk UUID ownership, category defaults and compatibility readers | Existing implementation retained |
| Web (`apps/web`) | Existing code-based callers preserved | No UI change |
| Mobile (`apps/mobile`) | Certificate renewal uses Employee UUID | Existing multipart upload remains |
| Shared (`packages/shared`) | N/A | No export change |
| Tests | New tests not requested | Existing affected expectations/checks recorded in parent review |

### Reviewable as

- **Demo:** Upload using the nine producers in plan.md; inspect newly saved Attachment metadata and read through existing APIs.
- **Acceptance:** REQ-01 acceptance, including category-driven quotation behavior and uploader-scoped legacy me reads.
- **Reviewer can verify without:** New viewing controls or U1 deployment.

### Risk

- **Weakest source:** REFERENCE — requester direction, spec S1/S3.
- **Migration reversible:** yes — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no backfill; compatible existing reads retained.
- **Blast radius:** Generic attachment ownership/read aliases, logs, notifications and evidence filters.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Upload adapters, employee/quotation lists, Won/Signed evidence, signature FKs and notifications | Owner/category normalization | Existing parent checks in review.md/publication.md; U1 preserves source and reruns affected checks | spec.md REQ-01 |

### Deliberately not in this unit

- Remaining presigned reads and saved-file rendering — U1.
- Historical row rewriting — excluded by spec; not required for compatibility.

## U1 — remaining mobile presigned file reads

- **Outcome:** A mobile user opens saved quotation/certification/job-walk/linked-job/incident files directly from signed S3 links, sees saved JSA and incident images/signatures, and retains the canonical attachment metadata already delivered.
- **Kind:** vertical — one remaining-file-read migration across sibling file types, including API authorization, wire contracts, visible mobile controls and regression checks. A backend-only links provider would deliver no user outcome and is not split off.
- **Requirements covered:** REQ-02..REQ-06 fully; REQ-01 regression/retention.
- **Depends on:** U0, already present in the continuation branch.
- **Branch / PR base:** `codex/mobile-presigned-reads` stacked on `codex/attachment-metadata-consistency` while that parent is unmerged. One branch and one eventual PR for this independent migration; do not combine unrelated web conversion or upload redesign.
- **Size estimate:** ~600–1100 source lines, 20–35 source files; estimates only, no size gate.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | Existing Attachment and role/incident links suffice; no migration/backfill |
| API (`apps/api`) | Add authenticated GET `/attachments/:id/links`; explicitly check tenant; expose certification document Attachment ID separately | Sign only server-loaded fileName; existing download/list/upload responses remain compatible; add optional certification attachmentId without changing certification entity id/status dedup |
| Web (`apps/web`) | Compatibility checks only | Existing generic byte download, blob helper and metadata list contracts remain intact |
| Mobile (`apps/mobile`) | Common on-demand signed-file service/opener; both quotation cards; certification document action; read-only saved operator/foreman job-walk signatures on quotation Attachments tab; linked permit/plan/PO opening; saved JSA/incident display (`JsaBody.tsx`, `JsaSignatureModal.tsx`, `ticket-incident-files-section.tsx` mounted from `ticket-details.tsx`) | Reuse existing file helper and AttachmentImage; no calls to obtain links just to list filenames; no new job-walk edit workflow |
| Shared (`packages/shared`) | Reuse EntityImageCover | No new export/dependency expected; if changed, trace/build dist and fix consumers in this unit |
| Tests | New tests not requested | Run existing affected API/mobile suites, lint/typecheck/build; update existing shape expectations only when required |

### Reviewable as

- **Demo:** On quotation detail open/share a general file and PLAN_OR_DOC, view/open both roles on a saved job-walk report; open an uploaded certificate from certifications, with no action on a certificate lacking a file; from ticket details open a permit, plan and PO; reopen a saved JSA and incident with no local captures and display their saved images/signatures and incident video as a file.
- **Acceptance:** spec.md REQ-01..06 acceptance and edges. Signed S3 requests carry no API Authorization; refresh once after failed/expired signed fetch; preserve filenames, MIME, empty/error states, local captures and existing upload/delete restrictions.
- **Reviewer can verify without:** A data migration, new dependency, new shared export, another unit or a new edit workflow. Real S3/device checks require configured API/storage and mobile runtime; mark unavailable checks explicitly.

### Risk

- **Weakest source:** UNVERIFIED — REQ-05 prior ticket source, reinforced by current requester instruction. Reversible mobile rendering repair; no irreversible operation based on it.
- **Migration reversible:** yes — no schema/data migration; additive endpoint/optional field and client controls.
- **Behind a flag:** no; additive API-first rollout.
- **Touches existing data:** Reads existing attachment/owner records; no backfill or relabeling. Existing upload writes remain U0 behavior.
- **Blast radius:** Generic file access and signing, certification ID/file association, shared native opening, JSA saved/local precedence and incident display. Guardian reviews explicit tenant constraints and current access policy; contract tracer checks the exact new endpoint and optional certification field.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Both quotation cards, wizard upload results and category-driven email evidence | Common opening service and attachment rows | Existing quotation card/service suites; verify upload/list/delete and disabled upload still allow saved file reads | spec.md REQ-01/03 |
| Generic web attachments, entity notes, employee certificates and quotation signature PDF viewer | Existing `/attachments` and `/:id/download` contracts | Contract tracer route/field/type/wrapper passes; existing API attachment controller tests and relevant web checks if shared contracts change | spec.md §5, REQ-03 |
| Certification list/menu/renewal | Additive attachmentId independent of polymorphic id | Existing Me/certification/renewal suites; check db-only and uploaded rows, dedup, uploader-scoped aliases | spec.md REQ-01/04 |
| Job-walk capture/upload/delete and both role FKs | Existing list(quoteNo) and read-only signature card | Existing job-walk API/mobile mapper/storage suites; no edit-form/store mutation; inspect both saved roles after refetch | spec.md REQ-01/04 |
| All three linked job-artifact categories and ticket details entry points | Existing authorized metadata plus common signed opener | Existing job-artifact UI/service tests; open permit/plan/PO; normal new reads avoid API arraybuffer | spec.md REQ-02 |
| Ticket attachments native sharing | Reused file helper | Existing helper/ticket attachment sheet suites; same filename/MIME/cancellation behavior; bounded refresh handles signed fetch failure only | spec.md REQ-02/03/04/06 |
| Pre/post-trip and local checklist captures | Shared JSA/checklist images | Existing JSA/rehydration/checklist/image suites; verify local attachment ID match and no signed URLs copied to drafts | spec.md REQ-05 |
| Incident capture/submission and video classification | Existing incident list images/files/signatureImage | Existing incident sheet/hook/service suites; saved viewer uses current ticket access; video remains file | spec.md REQ-06 |
| Profile/entity/ticket photo readers | Shared existing image components if touched | Existing AttachmentImage/profile/photo suites; no bearer headers sent to S3 | spec.md §11a/11c |

### Deliberately not in this unit

- Direct-to-S3 PUT uploads, schema/data backfill, object moves, new offline file library, universal embedded editor — explicitly excluded by spec.
- Unrelated web blob migration — recorded follow-up.
- New certification approval, incident workflow, job-walk editing or quotation lifecycle rules — excluded by scope.

## U2 — Quotation & Job-Walk S3 folder hierarchy and UUID consistency

- **Outcome:** Quotation documents, signed PDF copies, and Job Walk signatures are stored under structured, tenant-isolated S3 paths (`tenants/{tenantId}/quotations/{quotationId}/...`), and all quotation and job-walk upload pipelines consistently persist UUIDs in `attachments.feature_id`.
- **Kind:** vertical.
- **Requirements covered:** REQ-07, REQ-08.
- **Depends on:** U1.
- **Branch:** `fix/mobile-presigned-reads`.
- **Size estimate:** ~100–150 source lines across 6 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Storage (`apps/api/src/service/storage`) | Add `buildQuotationFileKey` and `buildJobWalkFileKey` | Reuses tenant isolation pattern; creates scoped quotation and job-walk keys |
| API (`apps/api/src/presentation`) | Update `QuotationsController.uploadAttachments` and `AttachmentsController.upload` | Uses scoped quotation and job-walk S3 keys; resolves `JOB_WALK` to UUID |
| API (`apps/api/src/usecase`) | Update `SignedCopyAttachmentsService` and `JobWalkReportsService` | Scopes DocuSign copies and job walk signatures under parent quotation; sets `featureId: quotation.id` (UUID) |
| Tests | Existing test expectations updated for quotation UUID targets | Zero new test files (Haris rule) |

## Sequencing

```text
U0 (built/published metadata parent) → U1 (remaining presigned reads + rendering siblings) → U2 (quotation/job-walk S3 hierarchy + UUIDs)
```


- **Parallelisable:** No independently shippable units remain to parallelize. Specialists may review read-only contracts/tenancy and separate mobile/API files within U1; coordinate common service exports, attachment controller and MeService to avoid concurrent edits.
- **Merge order constraint:** U1 targets U0 while its PR is open; retarget only after parent merge. Deploy additive API endpoint/optional certification field before the new mobile build; existing clients and web retain byte endpoints. No incompatible response window is intended.
- **First unit to ship:** U1 — proves the authorized common links boundary and native opener across all remaining siblings while preserving local capture and upload metadata.
