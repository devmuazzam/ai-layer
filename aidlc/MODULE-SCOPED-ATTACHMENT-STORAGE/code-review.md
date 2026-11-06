# Code and contract audit — MODULE-SCOPED-ATTACHMENT-STORAGE

2026-11-06 · tcg-contract-tracer · planning only · application baseline `fa83fe40f`.

**Scope update:** The requester subsequently excluded historical-file handling and
retirement of existing availability. Inventory/migration/retirement recommendations below
are audit context for a separate future task, not requirements or blockers here. This
ticket changes new uploads/generated files and preserves existing-file access.

## Evidence and limits

**VERIFIED by search:** Four passes were run against current API, web, mobile and shared
source: route literals; storage/key/response fields; shared image types; hook/service wrapper
callers. Representative commands:

```bash
rg -n '[\x22\x27\x60]/attachments' apps/web/src apps/mobile --glob '!*.test.*' --glob '!*.spec.*'
rg -n '\.buildKey\(|presignDownloadUrl\(|presignGetUrl\(|getObjectStream\(|\.putObject\(|\.deleteObjects?\(' apps/api/src --glob '!*.spec.ts'
rg -n 'PutObjectCommand|GetObjectCommand|DeleteObjectCommand|S3Client|signedDocumentUrl' apps/api/src --glob '!*.spec.ts'
rg -n 'attachmentsApi\.|useAttachments\(|useUploadAttachment\(|useDeleteAttachment\(|useAttachmentDownload\(|uploadPendingItems\(' apps/web/src --glob '!*.test.*'
rg -n 'EntityImageCover|EntityImageListItem|LoadoutPhotoCover|AttachmentLinksSchema|AttachmentSchema' apps/web/src apps/mobile packages/shared/src --glob '!*.test.*'
rg -n 'cleanupReplaced\(|deleteOrphaned\(|deleteOrphanedSignature|deleteOwnerPhotosIn|deleteStoredFiles' apps/api/src --glob '!*.spec.ts'
```

The broad `/attachments` substring pass matched 111 web and 28 mobile files, including
imports/comments; those are search hits, **not** counts of independent HTTP callers. The
narrow literal-route pass identifies two web route-wrapper files and four active mobile
route-wrapper files, plus mobile's historical URL-header resolver. Their consumer closure is
listed below. SDK object operations are centralized in `service/storage/s3-storage.service.ts`.

**INFERRED** below means behavior/risk concluded from reading those hits. No application
change, test execution, DB query, S3 access, migration, prefix deletion, or live-flow check
was performed for this planning audit. Existing suites named below are validation targets,
not new evidence of passing tests. One preliminary search output was written to
`/tmp/tcg-flat-key-locations.txt`; no application source was edited. This report was written
after the coordinator explicitly authorized the artifact.

## 1. Remaining flat writers — complete current builder-call inventory

**VERIFIED by `rg -n '\.buildKey\(' apps/api/src --glob '!*.spec.ts'`:** Three call sites
remain, representing three writer branches. `S3StorageService.buildKey` at
`apps/api/src/service/storage/s3-storage.service.ts:132` produces
`tenants/{tenantId}/attachments/{fileName}`.

| Writer | Current output / owner | Planning consequence [INFERRED] |
| --- | --- | --- |
| `apps/api/src/presentation/attachments/attachments.controller.ts:222` | Generic upload's final branch writes every ordinary non-ticket/non-quotation feature to the flat prefix | Replace storage dispatch for all 15 feature types below; resolve the real owner UUID before writing bytes, while preserving existing request aliases/permissions/categories |
| Same controller `:219` | `JOB_WALK` uploads fall back to flat when no parent quotation UUID resolves | Define an explicit supported owner hierarchy or reject an unresolved parent before upload; no silent flat fallback |
| `apps/api/src/usecase/quotation-signatures/signed-copy-attachments.service.ts:175` | Signed-copy fanout writes independent flat PDF objects for PROJECT and JOB targets; QUOTATION target uses its structured builder | Update generated copies too. Keep independent object ownership: deleting a project/job attachment must not delete the quotation/master or another record's object |

Required-parent correction from independent ownership review: JobWalkReport.quotationId is
required (`apps/api/prisma/schema.prisma:1875`), and create resolves a required quoteNo
(`apps/api/src/usecase/job-walk-reports/job-walk-reports.service.ts:146`). The generic flat
branch and dedicated `unknown-quotation` sentinel do not establish a standalone workflow.
Require the real tenant-bound quotation UUID before storage; do not add a parentless path.

The generic route is **not** synonymous with flat storage. That same controller already
writes QUOTATION documents structurally (`:201`) and JOB_WALK files structurally when the
parent resolves (`:211`). Removing `/attachments/upload` or `/attachments/:id/download`
would be a separate transport change with a substantially larger client contract impact.

### Full feature enumeration

**VERIFIED:** `apps/api/prisma/schema.prisma:66` defines 21 `AttachmentFeatureType` values.
Their storage classification is **INFERRED** from the writer branches and specialized
services; no enum entry is treated as nonexistent simply because a current UI is sparse.

| Feature | Current write family / important consumer |
| --- | --- |
| YARD | Flat generic documents; yard form/detail attachment sections |
| ASSET | Flat generic documents and meter evidence; structured profile images separately |
| CUSTOMER | Flat generic documents; customer detail/edit |
| CUSTOMER_NOTE | Flat generic note files; note attachment IDs stored on customer note records |
| QUOTATION | Structured `quotations/{uuid}/documents` and `signed`; historical flat readers remain |
| PROJECT | Flat generic documents and generated signed-copy fanout |
| EMPLOYEE | Flat generic documents/certifications; structured profile image separately |
| EMPLOYEE_NOTE | Flat generic note files; employee note grid/editor |
| AGENCY | Flat generic documents; agency create attachments |
| JOB | Flat generic job documents and generated signed-copy fanout; structured sub-job loadout/offload images separately |
| USER | Generic non-profile uploads still reach flat branch even though web generic union excludes USER; structured profile image separately |
| PERMIT | Flat generic application/approved/final documents; inherited ticket artifact references |
| PROJECT_NOTE | Flat generic note files; project notes and shared note UI |
| PLAN | Flat generic drawings/final documents; email attachments and inherited ticket artifacts |
| TOOL | Flat generic documents; structured profile image separately; public cover byte access |
| PURCHASE_ORDER | Flat generic documents/invoices; invoice upload/delete changes PO status; inherited ticket artifacts |
| CHECKLIST | Strict structured ticket image path; generic upload rejects |
| JOB_TICKET | Strict structured ticket images/documents; generic upload rejects |
| TICKET_SIGNATURE | Strict structured ticket signature images; generic upload rejects |
| TICKET_INCIDENT | Strict structured ticket evidence images/plain files; generic upload rejects |
| JOB_WALK | Structured quotation/job-walk signatures when parent resolves; generic null-parent flat fallback remains |

`AttachmentsService.resolveUploadFeatureId` (`apps/api/src/usecase/attachments/attachments.service.ts:127`)
currently normalizes EMPLOYEE, QUOTATION and JOB_WALK only; other feature IDs are passed
through. JOB is deliberately ambiguous: job business code for documents versus sub-job UUID
for loadout photos (`:186`). A new module dispatcher must resolve these meanings rather than
placing raw `featureId` strings into folders. Note feature IDs identify their owning entity,
not necessarily a separate note UUID. Derive concrete owner code fields from schema and
repositories during implementation; do not infer them from enum names.

## 2. Operation inventory and validation boundaries

Every row is **VERIFIED as a source location by the search commands above**. Behavioral
descriptions and recommended changes are **INFERRED from reading**.

| Operation | Files / exact anchors | Boundary to plan |
| --- | --- | --- |
| Upload/list metadata | `presentation/attachments/attachments.controller.ts:173,242`; `usecase/attachments/attachments.service.ts:127,210,315` | Resolve canonical owner and owner tenant before bytes; keep current metadata response/aliases and feature-specific business side effects |
| Presigned generic links | Same controller `:259,268,280`; same service `:375` (`findForSignedAccess`) | Currently only ticket types get strict key ownership checks. Validate module document/profile/sub-job families before either download or preview signing; preserve employee-specific signed-access policy |
| Generic byte stream | Same controller `:287,297`; service `:411` (`findById`) | Validate the stored row's key/owner before `getObjectStream`; preserving this route does not require preserving flat keys |
| Generic explicit delete | Same controller `:335,357`; service `:460`; `service/attachments/attachments.repository.ts:141` | Dispatch ticket/profile/sub-job/module-document ownership correctly. Current non-ticket `subJobImageObjectKeys` falls back to any singleton; eliminate this as a universal storage validator. Retain row-delete transaction and JOB loadout/editability guards |
| Generic expiry/category/certification and PO effects | `usecase/attachments/attachments.service.ts:210,425,460`; `usecase/purchase-orders/purchase-orders.service.ts:1030,1044` | Metadata changes and invoice close/reopen are not storage-key builders. Preserve them when replacing upload/delete dispatch |
| Asset meter evidence links | `usecase/asset-management/assets/assets.service.ts:659,677,761`; `service/asset-management/assets/assets.repository.ts:388` | Current single stored image supplies both sizes. Validate ASSET source-owner key before signing, preserve existing image shape; do not silently require profile-photo WebP variants |
| Public tool cover stream | `presentation/asset-management/tools/public-tools.controller.ts:40,48` | Public/no ambient tenant. Derive tenant and tool owner from barcode result and attachment relation before byte access; an Attachment-only/request-tenant validator is insufficient |
| Plan email document bytes | `usecase/plans/plans.service.ts:897,909`; callers `:804,871` | Validate PLAN document owner before loading SMTP attachments; both salesperson notification and customer send reach this path |
| Quotation DocuSign / email bytes | `usecase/quotation-signatures/quotation-signatures.service.ts:1276,1337,1362,1384` | Both `buildAdditionalDocuments` and `buildLinkedEmailAttachments` read stored keys directly; wrapper-only validation misses them |
| Signed master read / generated attachment read | `usecase/quotation-signatures/signed-copy-attachments.service.ts:68,116,164,279` | Master key lives on `QuotationSignature.signedDocumentUrl`, outside `attachments`. Validate using signature tenant/quotation, separately from generated target attachment owners; keep DocuSign-unavailable and existing external-source behavior distinct from flat-key compatibility |
| Signed master/fanout write / failed-write cleanup | Same signed-copy service `:168,175,232,255,267` | Use canonical target UUIDs and source tenant in public webhook/no-context flows. Generated project/job copies currently use business codes; keep their tab/list aliases compatible while resolving keys by UUID |
| Conversion-triggered signed fanout | `usecase/projects/projects.service.ts:182,777,937,1105` | Conversion/reconciliation can create new flat objects without a manual upload; test all callsites. Ordinary quotation attachment copy is currently explicitly zero at `:473`, so do not invent an additional generic copy writer |
| Job-walk signature upload/replace/clear | `usecase/job-walk-reports/job-walk-reports.service.ts:258,290,305,329,334,336` | `deleteOrphanedSignature` deletes row before trying the stored key. New validation must happen before destructive cleanup, but expected stale-key rejection after a saved replacement must not fail the saved operation |
| Entity profile photos | `usecase/attachments/attachment-photos.service.ts:51,169,255,389,441,449,460,525,542`; `service/attachments/attachment-photos.repository.ts:233` | ASSET/TOOL/EMPLOYEE/USER already use owner-UUID `profile-pictures` original/thumbnail. Preserve owner-derived reads/deletes, employee/user replacement and photo category rejection. Generic links/streams also reach these rows and must recognize this family |
| Asset/tool owner delete | `service/asset-management/assets/assets.repository.ts:343`; `service/asset-management/tools/tools.repository.ts:223`; `usecase/asset-management/assets/assets.service.ts:1013,1037`; `usecase/asset-management/tools/tools.service.ts:620` | Existing profile rows removed transactionally, S3 files cleaned after commit with best-effort logging. Do not impose explicit-file-delete rollback semantics on owner deletion accidentally |
| Sub-job loadout/offload | `usecase/attachments/loadout-photos.service.ts:145,176,180,221,226`; `service/attachments/sub-job-image.ts:27,46`; `service/attachments/attachments.repository.ts:68` | Already structured `projects/{project}/jobs/{job}/sub-jobs/{subjob}/{loadout|offload}/{photo}/{original|thumbnail}.webp`. Cover query filters structured rows, but generic helper retains flat-singleton fallback; validate exact owner chain and preserve carry-forward links/linked-loadout delete guard |
| Ticket families | `service/attachments/ticket-image.ts:37,50,75,91,123,137`; `usecase/ticket-attachment-guard/ticket-attachment-guard.service.ts:359,377` | Keep current strict variants/plain dispatch and tenant/code/UUID owner validation; no regression to a generic singleton fallback |

All paths in this table are relative to `apps/api/src/`.

### Background, metadata-only and inherited references

- **VERIFIED:** `usecase/notifications/notification-scheduled-jobs.service.ts:295,318,346`
  enumerates expiring attachment metadata and builds a module navigation link through
  `usecase/attachments/attachment-notification-recipients.service.ts`. It does not read,
  sign, write or delete S3 objects. **INFERRED:** keep row tenant, owner aliases, expiry and
  deep-link semantics; do not turn a metadata reminder into a storage-byte read.
- **VERIFIED:** `usecase/field-tickets/field-tickets.service.ts:567,584,601,675,714,746`
  retrieves PERMIT/PLAN/PURCHASE_ORDER rows by UUID/code aliases and returns their IDs and
  stored metadata as job artifacts. **INFERRED:** these files remain owned by their source
  module when opened inside a ticket. They must not be rewritten or validated as ticket files.
- **VERIFIED:** customer/employee note/detail reads use
  `usecase/customers/customers.service.ts:468,471` and
  `usecase/employee/employee.service.ts:1067,1070`; employee-code changes reassign attachment
  feature IDs in `service/employee/employee.repository.ts:991,995`.
  **INFERRED:** canonical UUID keys must survive business-code changes; do not introduce
  storage moves merely because an alias changes. JSON note attachment ID collections must
  remain intact.
- **VERIFIED:** `service/me/me.repository.ts:78,88` and `usecase/me/me.service.ts:96`
  consume certification metadata/fileName as a last-resort label. No S3 bytes are accessed there.
- **VERIFIED:** SDK searches found no independent bucket SDK outside S3StorageService.
  The dispatch-packet print hook
  `apps/web/src/features/das/header/components/print-dispatch-packet/use-print-dispatch-packet.ts:121`
  only reuses a browser blob-download helper for a generated packet; payroll
  `apps/api/src/usecase/payroll/adp-batch.ts:67` uses an unrelated export filename.
  **INFERRED:** neither hit is a remaining flat attachment writer/reader.

## 3. Web and mobile contract closure

No API response change is required to change object-key hierarchy. **INFERRED:** current
clients are SAFE for an opaque `fileName`/presigned URL change if their existing IDs, field
shapes, aliases, status codes and transport routes stay supported. Removing generic routes
instead would BREAK the following active wrappers and their listed consumers.

### Web

**VERIFIED route pass:**

- `apps/web/src/features/attachments/api/attachments.service.ts:63,86,121,135,140,144,148`:
  list, document/certificate upload, loadout covers, blob download, delete and expiry.
- `apps/web/src/lib/api/entity-photos.ts:16,36,53,64`: profile photo list/upload/cover/delete.

**VERIFIED wrapper/field passes:**

- `features/attachments/hooks/use-attachments.ts:43,57,98`, `use-modal-attachments.ts:35`,
  `use-attachment-download.ts:19`, `use-attachment-bulk-delete.ts:48`,
  `utils/upload-pending-items.ts:21`, `utils/download-attachments-sequential.ts:22` and
  `components/subcomponents/use-attachment-uploads.ts:146,170` under `apps/web/src/`.
- Shared render/edit controls: `features/attachments/components/attachments-section.tsx:81`,
  `categorized-attachments-section.tsx:116`,
  `components/molecules/categorized-attachment-card.tsx:83`; all
  `components/organisms/entity-notes/{entity-notes-actions,entity-notes-controller,use-entity-notes-grid,entity-notes-grid,entity-notes-editor,EntityNotesTab}`
  consume those wrappers. Notes download files and delete attachment ID collections.
- Concrete module roots: `features/yards/views/{yard-form,yard-details}.tsx`,
  `features/assets/asset/components/asset-attachments-section.tsx`,
  `features/assets/asset/utils/upload-meter-reading-evidence.ts:17`,
  `features/assets/tools-riggings/hooks/use-attachment-image-url.ts:25`,
  `features/customers/views/customer-details.tsx:124`,
  `features/customers/workspace/edit/customer-edit-tab-panels.tsx:123`,
  `features/agencies/views/create-agency-attachments-section.tsx:28`,
  `features/projects/components/project-detail-dashboard.tsx:158`,
  `features/projects/jobs/job-details/attachments/job-attachments-tab.tsx:18`,
  `features/employees/components/{create/create-employee-attachments-section,certificates/employee-certificates-section,detail/employee-detail-body}.tsx`.
- Plans/permits/PO: `features/plans/components/{plan-category-attachments,plan-create-attachments-save}.tsx`
  (save helper is `.ts`), `features/permits/lib/create-permit-attachments.ts:52`,
  `features/permits/components/permit-category-attachments.tsx:108`,
  `features/permits-plans/components/{artifact-detail,upload-approved-plan-modal,upload-approved-permit-modal,submit-application-modal}.tsx`,
  `features/purchase-orders/lib/po-attachments.ts:33`,
  `features/purchase-orders/components/{po-detail-view,po-edit-form-card}.tsx`;
  permit create pages under protected `/permits`, `/projects/[id]/permits`, and
  `/asset-management/assets/[id]/permits` directly upload through attachmentsApi too.
- Quotation/signing: `features/quotations/views/create-quotation-save.ts:318`,
  `views/{create-quotation,view-quotation}.tsx`,
  `components/organisms/confirm-won-dialog.tsx:78,141,174`,
  `features/quotation-signatures/components/{upload-plan-action,signed-details-modal}.tsx`.
- Ticket progress's `features/ticket-progress/components/attachment-thumbnail.tsx` prefers
  supplied cover links but retains generic blob transport for bare attachment IDs. Asset
  meter drawer and Dylen loadout consumers use structured cover fields rather than flat
  paths (`features/assets/asset/components/asset-meter-reading-history-drawer.tsx`,
  `features/dylen-dashboard/hooks/use-loadout-photo-covers.ts`).

### Mobile (separate route/release surface)

**VERIFIED route and wrapper passes:**

- `apps/mobile/data/services/certifications/certifications.http.ts:69` uploads EMPLOYEE
  certificate files through generic upload; its owner resolution and certificates UI are a
  remaining real flat-writer consumer.
- `apps/mobile/data/services/quotation-attachments/quotation-attachments.http.ts:24,49,67,83,98`
  lists quotation files, uses quotation batch/email upload and generic single upload, and
  generic delete. New quotation writes are already structured; historical rows are not thereby migrated.
- `apps/mobile/lib/attachment-links.ts:20,23,34,38` obtains fresh generic links and downloads
  straight from S3, then shares. It is used by
  `components/sales/{quotation-attachments-card,quotation-general-attachments-card,saved-job-walk-signatures-card}.tsx`,
  `components/field/{job-artifacts-section,ticket-incident-files-section}.tsx`.
- `apps/mobile/data/services/job-walk-reports/job-walk-reports.http.ts:56` separately calls
  generic links for saved signatures; `data/hooks/use-job-walk-reports.ts` carries the links.
- `apps/mobile/components/field/job-artifacts-section.tsx:94` opens source-module PLAN,
  PERMIT and PURCHASE_ORDER attachment IDs with openStoredAttachment; changing their source
  storage must not require a ticket-specific URL or ownership rewrite.
- `apps/mobile/lib/attachments.ts:60` retains authenticated-image headers for an old
  `/attachments/:id/download` URI already stored in an earlier draft. It does not construct
  new download URIs. A generic-route removal has offline/installed-build consequences even
  if current live screens use direct S3.
- Strict ticket paths already use dedicated field services and
  `components/field/ticket-attachments-sheet.tsx:236`, `ticket-attachment-file.ts:123`,
  `attachment-image.tsx:33`. Preserve one logical metadata refresh/direct S3 retry and no
  bearer header on S3. This is a regression boundary, not a remaining flat writer.

### Shared-type pass

**VERIFIED:** `packages/shared/src/types/entity-image.types.ts`, `job-progress.types.ts`
and `employee.types.ts` carry image/loadout covers consumed by the web entity-photo,
profile, DAS/Dylen and ticket-progress surfaces and mobile identity/ticket/checklist/
signature/incident contracts. Those shared fields are COMPILE-CAUGHT if retyped. Web
`features/attachments/api/attachments.service.ts` defines its own Attachment model;
mobile `lib/attachment-links.ts` uses a local Zod schema and quotation-attachment contracts
are local too. **INFERRED:** a changed generic link/metadata response can still break those
at runtime despite a shared build passing. Prefer no shape change for this storage task.

## 4. Validator design recommendations (AI decisions for the spec, not product facts)

1. Resolve `(row tenant, feature type, UUID-or-supported-code)` to the canonical owner once.
   Use explicit tenant constraints even for public/background/SUPER_ADMIN paths. Batch
   resolution for lists; no query per attachment. Preserve current request aliases unless a
   separate product requirement changes them.
2. Dispatch by a typed storage family, including module document, entity profile,
   ticket image/plain, sub-job image and signed master. Parse exact segment counts, fixed
   folders, owner UUIDs and allowed variant names before signing, streaming or deleting.
   Ending in `original.webp` or starting with a tenant prefix is insufficient validation.
3. Validate at every storage boundary listed in section 2. Generic controller validation
   alone misses direct email, public cover, meter evidence, signed master and replacement
   cleanup consumers. Avoid placing business-owner lookups inside the raw S3 utility.
4. A source artifact opened through a ticket retains its source owner; a signed PDF copied
   to several modules has independent objects. Do not use viewer context as object ownership
   and do not deduplicate independently deletable objects by reusing one key.
5. Preserve existing image families and formats. Documents that happen to be images, meter
   evidence, profile photos, ticket images and loadout images have different variant rules;
   a module-scoped folder does not authorize converting all of them to one image format.
6. Metadata-only enumeration/expiry notifications are separate from byte authorization.
   Specify old-row presentation explicitly; do not inadvertently make one rejected historical
   row crash an unrelated list or scheduled reminder.

## 5. PR #1049 P2 — failure order is part of the contract

**VERIFIED:** The merged patch is recorded in
`.ai/aidlc/MOBILE-TICKET-STRICT-S3/review-cleanup-fix.md` and spec D7. Current
`TicketAttachmentGuardService.cleanupReplaced` catches expected stale validation rejection
and storage-unavailable errors after a replacement has committed; `deleteOrphaned` remains
strict. Callers are signature `:239`, checklist `:676`, lunch `:321` and returned-lunch
removal `:383`. The previously executed standalone smoke is historical evidence for that
ticket, not a new execution in this planning pass.

**INFERRED planning rule:** A valid replacement must not be reported as failed because a
historical stale key is rejected during subsequent cleanup. Validate stale keys before any
row/object deletion; rejected keys must never reach S3. Expected rejection should log and
retain the stale row/object; unexpected errors remain distinguishable. Explicit user delete
must still reject invalid ownership rather than silently succeed. Carry this distinction to
job-walk replacement/clear and any new module cleanup helper. Preserve each existing
transaction boundary rather than making all cleanup paths share one catch-all policy.

## 6. Existing-suite and manual validation matrix (not run for planning)

No new tests/cases are proposed. Update existing fixtures if owner resolution requires
additional fields/mocks, then run the existing suites plus acceptance gates through Nx.

| Family | Existing suites / manual flow |
| --- | --- |
| Generic docs, links, delete/expiry | `apps/api/src/usecase/attachments/attachments.service.spec.ts`; `presentation/attachments/attachments.controller.photo-{reads,delete,cover}.spec.ts`; manually upload/list/open/delete one file per all 15 generic owner types, including note and certificate IDs, invalid owner/type and tenant collision |
| Profile photos/owner delete | `usecase/attachments/attachment-photos.{service,read,cover,delete}.spec.ts`; existing web `components/organisms/entity-photos/*.test.mjs`; manually ASSET/TOOL multi-photo cover, EMPLOYEE/USER replacement, owner delete, public tool QR cover |
| Sub-job/loadout | `usecase/das-loadout/das-loadout-save-photos.spec.ts`; no dedicated loadout-photos service suite found. Manually check loadout/offload plus carry-forward, guard linked-photo deletion, ensure two-variant deletion and unrelated job documents remain separate |
| Asset evidence | `usecase/asset-management/assets/assets.service.spec.ts`; web `features/assets/asset/utils/meter-reading-changes.test.mjs`; manually create/edit/read evidence and link source attachment to meter history |
| Quote/signing/generated copies | `usecase/quotation-signatures/{quotation-signatures,signed-copy-attachments}.service.spec.ts`; manually customer signing completion, master retrieval, DocuSign outage behavior, project/job conversion, independent attachment deletion and selected plan/docs email/envelope inclusion |
| Job-walk signatures | `usecase/job-walk-reports/job-walk-reports.service.spec.ts`; mobile `features/sales/{job-walk.store,job-walk-report.mapper}.test.ts`, `app/(sales)/job-walk.test.tsx`; manually upload/replace/clear operator and foreman signatures, reject missing/inconsistent required quotation before writes, verify stale cleanup retention |
| Plans/permits/PO and inherited artifacts | `usecase/{plans/plans,permits/permits,purchase-orders/purchase-orders,field-tickets/field-tickets}.service.spec.ts`; manually approved/final upload and status prerequisites, plan salesperson/customer email, PO invoice close/reopen, open same source files from mobile ticket artifact tabs |
| Background metadata | `usecase/notifications/notification-scheduled-jobs.{service,tenant-window}.spec.ts`; no dedicated attachment-recipient suite found. Manually dry-run/inspect planned expiry notification owner/deep link behavior without requiring file bytes |
| Mobile generic/S3 recovery | `data/services/quotation-attachments/*.test.ts`, `components/sales/quotation-{attachments,general-attachments}-card.test.tsx`, `lib/attachments.test.ts`, existing certification/job-walk suites; emulator fresh and expired links, missing source attachment, share error, no API auth headers sent to S3 |
| Ticket regression / post-save cleanup | Existing guard/signature/checklist/lunch/returned-correction/incident/attachment suites; manually valid replacement of stale flat/foreign key succeeds without deleting stale object; direct invalid read/delete rejects; unexpected errors are not silently swallowed |

API suite paths in this table are relative to `apps/api/src/`. Exact existing-suite discovery
must precede execution; table family labels are not permission to invent a missing spec file.
Run `pnpm api:test`, `pnpm lint`, `pnpm typecheck`, API build and affected existing web/mobile
targets; record fresh/cache status and baseline failures honestly. Storage mutation guards
must be tested on disposable QA data after implementation authorization.

## 7. Folder-retirement gate remains a separate data decision

**INFERRED:** Finishing new writers does not prove the flat prefix is unused. Stored
Attachment.fileName values, QuotationSignature.signedDocumentUrl, profile cover FKs, meter
photo FKs, job-walk signature FKs, JSON note IDs, source artifacts, old draft URIs and
generated signed fanout all need inventory and disposition. This audit deliberately made no
DB/S3 query, so it cannot establish object counts, orphan counts or migration completeness.

Historical-file disposition remains open in intent/state. A future retirement gate needs an
approved preserve/migrate/retire policy, reference inventory, ownership/collision checks,
copy-and-verify/rollback procedures if migration is chosen, repeated zero flat-writer and
zero live flat-reference checks, and environment-specific approval before deletion. Do not
mark the physical prefix safe to delete from this source audit or from passing unit tests.
