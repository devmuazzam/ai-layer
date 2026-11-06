# Ownership audit — MODULE-SCOPED-ATTACHMENT-STORAGE

2026-11-06 · tcg-prisma-guardian / source audit · planning only.

**Scope update:** The requester excluded historical-file handling and availability
retirement. Any unresolved historical disposition, data inventory or migration/deletion
recommendation in this original audit is out of scope, not an open blocker. New writes
use canonical owners; existing files and their current access remain unchanged.

## Verdict and evidence limits

The remaining flat writers can use the existing `Attachment` model with a resolved owner
UUID in the storage key. No new table or column is required by the storage change alone.
This is an implementation recommendation, not an approved schema decision. Existing-row
disposition remains an open product/data decision; this audit authorizes no backfill or
deletion. No DB, S3, emulator, migration, or runtime check was run.

VERIFIED by source search: the only production callers of `S3StorageService.buildKey` are
the generic upload controller and the signed-copy filing service. Search performed:
`rg -n 'buildKey\\(' apps/api/src --glob '!*.spec.ts'`, followed by a separate search for
literal `attachments/` paths and all `putObject` callers. The builder is at
`apps/api/src/service/storage/s3-storage.service.ts:132`.

INFERRED from those callers: changing the generic controller alone would leave project/job
DocuSign copies writing to the retired prefix.

## Remaining writers

| Source | What is written today | Required planning treatment |
| --- | --- | --- |
| `apps/api/src/presentation/attachments/attachments.controller.ts:219` | A defensive JOB_WALK missing-quotation branch uses a flat object. The schema requires the report's quotation. | Resolve the report UUID and required authoritative quotation UUID before writing; missing/inconsistent ownership rejects before storing bytes. Remove the defensive flat fallback, without introducing a standalone report workflow. |
| `apps/api/src/presentation/attachments/attachments.controller.ts:222` | Every other generic non-ticket/non-quotation upload uses a flat object. | Exhaustive feature-to-owner dispatch, no default flat branch. Resolve and authorize the owner before S3 writes. |
| `apps/api/src/usecase/quotation-signatures/signed-copy-attachments.service.ts:175` | Copies of a signed quotation filed on PROJECT and JOB records use flat objects. QUOTATION copies already use `quotations/{uuid}/signed/`. | Extend selected target fields with UUID identity, retain target code metadata where consumers need it, and write each destination's own canonical object. |

Already structured writers must stay separate: quotation upload
(`apps/api/src/presentation/quotations/quotations.controller.ts:353`), ticket image/plain
storage (`apps/api/src/usecase/ticket-attachment-guard/ticket-attachment-guard.service.ts:235`),
dedicated job-walk signatures (`apps/api/src/usecase/job-walk-reports/job-walk-reports.service.ts:258`),
entity photos (`apps/api/src/usecase/attachments/attachment-photos.service.ts:525`), loadout
photos (`apps/api/src/usecase/attachments/loadout-photos.service.ts:180`), and DocuSign master
copy (`apps/api/src/usecase/quotation-signatures/signed-copy-attachments.service.ts:233`).

## Complete polymorphic feature mapping

VERIFIED enum inventory: `apps/api/prisma/schema.prisma:66` through its JOB_WALK member.
The following proposed keys are relative to `tenants/{tenantUUID}/`. `{fileUUID}` denotes
a server-generated object identifier; extensions must use the existing sanitisation policy.
Folders are fixed server values, never original filenames, categories, note text, or codes.
These are proposed AI implementation choices for spec §11b, not existing requirements.

| Enum feature | Owner resolution | Proposed canonical ordinary-file path |
| --- | --- | --- |
| YARD | `Yard.id`, or tenant + `yardId` business code | `yards/{yardUUID}/documents/{fileUUID}.{ext}` |
| ASSET | `Asset.id` UUID; do not assume a legacy unit code uniquely identifies an archived row | `assets/{assetUUID}/documents/{fileUUID}.{ext}` |
| CUSTOMER | `Customer.id`, or tenant + `customerCode` | `customers/{customerUUID}/documents/{fileUUID}.{ext}` |
| CUSTOMER_NOTE | Same customer owner; current note attachment featureId is the customer code | `customers/{customerUUID}/notes/{fileUUID}.{ext}` |
| QUOTATION | Existing quotation resolver: UUID or tenant + `quoteNo` | Preserve `quotations/{quotationUUID}/documents/{fileUUID}.{ext}` and `signed/{fileUUID}.pdf` |
| PROJECT | `Project.id`, or tenant + `projectId` business code | `projects/{projectUUID}/documents/{fileUUID}.{ext}`; generated copies may use `signed/{fileUUID}.pdf` |
| EMPLOYEE | Reuse employee resolver: employee UUID/code, linked User UUID, or `me` with uploader | `employees/{employeeUUID}/documents/{fileUUID}.{ext}` |
| EMPLOYEE_NOTE | Employee owner; current note attachment featureId is employee code | `employees/{employeeUUID}/notes/{fileUUID}.{ext}` |
| AGENCY | `Agency.id`, or tenant + `agencyCode` | `agencies/{agencyUUID}/documents/{fileUUID}.{ext}` |
| JOB | Distinguish Job business code/UUID from existing SubJob UUID loadout ownership | Ordinary files: `jobs/{jobUUID}/documents/{fileUUID}.{ext}`; retain established nested sub-job paths for existing loadout/offload photos |
| USER | Existing user UUID, matched to tenant; generic non-photo use is not established | If supported: `users/{userUUID}/documents/{fileUUID}.{ext}`; otherwise reject generic uploads explicitly |
| PERMIT | `Permit.id`, or tenant + `permitId` business code | `permits/{permitUUID}/documents/{fileUUID}.{ext}` |
| PROJECT_NOTE | Same Project owner; current note attachment featureId is project code | `projects/{projectUUID}/notes/{fileUUID}.{ext}` |
| PLAN | `Plan.id`, or tenant + `planId` business code | `plans/{planUUID}/documents/{fileUUID}.{ext}` |
| TOOL | `Tool.id`, or tenant + `toolCode`; generic non-photo use is not established | If supported: `tools/{toolUUID}/documents/{fileUUID}.{ext}` |
| PURCHASE_ORDER | `PurchaseOrder.id`, or tenant + `poId` business code | `purchase-orders/{purchaseOrderUUID}/documents/{fileUUID}.{ext}` |
| CHECKLIST | Existing resolved JobTicket UUID, code aliases retained in metadata | Preserve structured ticket `checklist-photos` variants; generic upload stays rejected |
| JOB_TICKET | Existing resolved JobTicket UUID | Preserve structured ticket `attachments` image variants and `documents` plain files; generic upload stays rejected |
| TICKET_SIGNATURE | Existing resolved JobTicket UUID | Preserve structured ticket `signatures` variants; generic upload stays rejected |
| TICKET_INCIDENT | Existing resolved JobTicket UUID plus precise incident FK | Preserve structured ticket `incident-evidence` files/variants; generic upload stays rejected |
| JOB_WALK | `JobWalkReport.id`, or tenant + `jobWalkCode`, plus its required Quotation UUID | Preserve `quotations/{quotationUUID}/job-walks/{reportUUID}/signatures/…`; missing/inconsistent required quotation rejects before writes, no standalone folder |

The ordinary-file proposal does not convert arbitrary uploaded image documents into photo
variants. Entity photo paths remain the established
`{assets|tools|employees|users}/{ownerUUID}/profile-pictures/{attachmentUUID}/{variant}.webp`.
Folder mapping: `apps/api/src/usecase/attachments/attachment-photos.service.ts:54`; key
construction: same file `:525`. Ticket previews and entity-photo thumbnails are distinct.

No VENDOR feature exists in this enum. Do not invent vendor attachment ownership from
Permit.vendorId or PurchaseOrder.vendorId. No standalone note entity/UUID is established by
the generic attachment protocol: CUSTOMER_NOTE, EMPLOYEE_NOTE, PROJECT_NOTE point to their
parent entity. Evidence: `apps/web/src/features/customers/components/organisms/CustomerNotesTab.tsx:51`,
`apps/web/src/features/employees/components/organisms/EmployeeNotesTab.tsx:52`, and
`apps/web/src/features/projects/components/project-detail-comments-tab.tsx:31`.

The dedicated job-walk writer contains a defensive `unknown-quotation` substitute
(`apps/api/src/usecase/job-walk-reports/job-walk-reports.service.ts:260`). The schema actually
requires `JobWalkReport.quotationId` (`apps/api/prisma/schema.prisma:1875`) and its Quotation
relation (`:1933`). CreateJobWalkReportDto requires quoteNo and service.create resolves that
quotation before insertion (`apps/api/src/usecase/job-walk-reports/job-walk-reports.service.ts:149`,
`:176`); the update DTO does not expose parent reassociation. Neither this sentinel nor the
generic defensive fallback proves a supported parentless workflow. Remove both branches and
require a real quotation UUID. Any malformed historical sentinel key remains report-only
under the unanswered existing-file policy.

Audit correction during independent review: the initial suggestion of a standalone
JOB_WALK path was based on defensive fallback syntax, not schema/workflow evidence, and is
superseded by this required-parent finding. No new parentless capability is proposed.

## UUID/code hazards and downstream contracts

VERIFIED: Attachment.featureId is `VarChar(255)`, not an owner FK
(`apps/api/prisma/schema.prisma:4641`). Its meaning is feature-dependent. Existing generic
upload canonicalisation handles only EMPLOYEE, QUOTATION and JOB_WALK; all other feature
values pass through (`apps/api/src/usecase/attachments/attachments.service.ts:127`).
Existing listing special-cases those same three and otherwise lists the supplied value
(`apps/api/src/usecase/attachments/attachments.service.ts:315`).

Do not replace all persisted featureId values with UUIDs merely to construct a storage key.
Resolve a separate canonical UUID for key construction while preserving existing metadata
until the whole dependent contract is deliberately updated. Specific hazards:

- EMPLOYEE aliases are implemented in
  `apps/api/src/service/attachments/employee-attachment-owner.ts:15`: employee UUID or code,
  linked User UUID, and literal `me` bound to uploadedById. Listing includes aliases without
  sharing all literal `me` rows (`:42`). A `me` row missing its uploader is unresolved,
  not permission to guess an employee.
- QUOTATION resolver names tenant and branches UUID/code without sending a business code
  into a PostgreSQL UUID comparison
  (`apps/api/src/service/attachments/quotation-attachment-owner.ts:6`). Follow this pattern;
  `apps/api/src/utility/uuid.util.ts:33` documents why an OR against UUID/code columns fails.
- JOB generic editability currently resolves a Job code, then a SubJob UUID
  (`apps/api/src/usecase/attachments/attachments.service.ts:194`). Simply storing a Job UUID
  in featureId would fall through to the SubJob lookup. Existing loadout photos use JOB
  rows with featureId equal to SubJob.id, not Job.id.
- PURCHASE_ORDER invoice-driven closing/reopening expects a PO code in featureId.
  Upload hook: `apps/api/src/usecase/attachments/attachments.service.ts:297`; delete hook:
  same file `:496`. Code lookup and remaining invoice count:
  `apps/api/src/usecase/purchase-orders/purchase-orders.service.ts:1030` through `:1067`.
  A partial UUID metadata conversion can silently fail to close/reopen, or miscount the
  last remaining invoice.
- Notification URL context and recipients resolve PROJECT/JOB/PLAN/PERMIT by business code:
  `apps/api/src/usecase/attachments/attachment-notification-recipients.service.ts:127`,
  `:190`; links are built from those values in
  `apps/api/src/usecase/attachments/attachment-link.util.ts:8`. Storage keys must not alter
  these routing values accidentally.
- Asset.unitCode has a tenant index, not a schema uniqueness constraint
  (`apps/api/prisma/schema.prisma:1105`). Application active/archive conflict logic is
  `apps/api/src/usecase/asset-management/assets/assets.service.ts:199`. Historical code
  resolution must reject/report ambiguity; an arbitrary findFirst would select an owner
  without proving identity. Current meter evidence uses the asset UUID
  (`apps/web/src/features/assets/asset/utils/upload-meter-reading-evidence.ts:18`).

Schema owner/code references: Yard `:2146/:2187`; Customer `:1401/:1467`; Quotation
`:1700/:1842`; Project `:2988/:3028`; Agency `:2275/:2316`; Job `:3545/:3650`; Permit
`:3075/:3179`; Plan `:3413/:3507`; PO `:3253/:3293`; Employee `:4188/:4326`; Tool
`:676/:702`; JobWalkReport `:1871/:1939` in `apps/api/prisma/schema.prisma`.
Codes are tenant-local; folder UUIDs must come from resolved records, not a code's prefix.

## Parent association and copy/sharing lifecycle

**Prefer immutable direct-owner folders for ordinary permits, plans and POs.** Their optional
or changeable associations do not make their documents owned by the associated record:

- Permit has optional project-code, asset UUID, job UUID, vendor UUID and source-quotation
  UUID fields (`apps/api/prisma/schema.prisma:3075`, `:3111`). The schema explicitly
  documents standalone permits and nullable jobId. Parent records use SetNull on deletion
  (`:3165`). Nesting under whichever parent happens to exist would make key identity depend
  on reassociation and can exclude valid standalone records.
- PurchaseOrder has optional project-code/job/vendor/permit references
  (`apps/api/prisma/schema.prisma:3253`). One PO can cover multiple permits through
  PurchaseOrderPermitLink (`:3303`). A permit-specific object folder would falsely suggest
  exclusive ownership of a shared PO's invoice.
- Plan.projectId is a required business string, not a Project UUID relation; Plan.jobId
  and sourceQuotationId are nullable (`apps/api/prisma/schema.prisma:3413`). It is not safe
  to insert projectId verbatim into a UUID hierarchy or infer that every plan has a job.
- Job.projectId is optional; existing loadout photos deliberately require a project and
  reject when absent (`apps/api/src/usecase/attachments/loadout-photos.service.ts:75`).
  Retain their established nested shape rather than changing already structured objects.

**Signed copies own independent objects.** The signed-copy service explicitly keeps an
independent master plus one object per attachment destination
(`apps/api/src/usecase/quotation-signatures/signed-copy-attachments.service.ts:43`). Targets
currently select project/job business codes (`:123`, `:195`). Select canonical UUIDs too,
without replacing the existing codes used for tabs/dedup/activity. Do not reuse the master
key or one copied destination key across all rows: deleting one attachment would otherwise
destroy other records' file. Current general quotation conversion does not copy arbitrary
attachment rows; its explicit copiedAttachmentCount is zero
(`apps/api/src/usecase/projects/projects.service.ts:473`). Do not introduce copying as an
assumed requirement of this storage task.

**Other references to retain.** Attachment has direct relations from covers, ticket
signatures, checklist answers, incident evidence, loadout item photos, meter-reading photos,
and job-walk signatures (`apps/api/prisma/schema.prisma:4672`). JSON note data stores
attachmentIds (`apps/api/src/usecase/projects/project-notes.utils.ts:7`); those IDs must not
change. Asset meter evidence ownership checks featureType + asset UUID before creating
links (`apps/api/src/usecase/asset-management/assets/assets.service.ts:764`). A prefix cleanup
must not assume the polymorphic feature pair is the only reference to a file.

**Direct stored-key registry.** Schema search for key/URL fields established three storage
locations: `Attachment.fileName` (`apps/api/prisma/schema.prisma:4643`),
`QuotationSignature.signedDocumentUrl` (`:2079`), and legacy `JobAttachment.fileName/fileUrl`
(`:3781`). The latter model remains present even though current conversion does not populate
it; its actual historical values are not known without a separate data inventory. JSON
payloads, logs, integrations and externally persisted links are not exhaustively enumerable
from these schema columns alone and remain inventory work, not assumed empty.

**Shared physical keys.** The schema has no uniqueness constraint on Attachment.fileName,
and the master-copy field is independent, so source alone cannot prove that any old physical
object has a single referencing row. Before any physical delete, group all references by
bucket + exact key, including direct fields above and any discovered external stores. If
another live row/master still references an object, remove only the intended logical
attachment/reference or retain the object for deferred cleanup; never delete bytes still
needed by another owner. Migration must retain or create independently owned destination
copies before breaking a shared legacy-key group. The signed-copy writer's intended
independence is not proof that historical data always follows it.

## Isolation and privileged contexts

VERIFIED: Attachment and the ordinary owner models are in TENANT_SCOPED_MODELS
(`apps/api/src/orm/prisma.service.ts:79` onward, JobTicket at `:172`). No model/allowlist
change is required merely to use different S3 keys. Extension scope is skipped without
request context (`:366`), for SUPER_ADMIN (`:370`), and outside the allowlist (`:376`).
Public DocuSign handlers intentionally operate without request context and the signed-copy
service documents explicitly naming signature.tenantCompanyId (`:50`).

Required implementation checks:

1. Upload owner lookup uses the authorized request tenant explicitly. Resolve owner before
   writing any object; derive stored row tenant and key tenant from that validated owner.
2. Existing-row signing/deletion uses row.tenantCompanyId plus the canonical owner UUID;
   verify owner tenant matches row tenant, including SUPER_ADMIN and background contexts.
   Never validate a privileged row against an unrelated ambient tenant or omit checking the
   tenant altogether because Prisma usually injects it.
3. Retain endpoint-specific authorization: generic signed access explicitly requires current
   tenant and employee-specific access
   (`apps/api/src/usecase/attachments/attachments.service.ts:377`). This is stricter than
   unscoped generic findById (`:412`). Do not turn owner resolution into broader read access.
4. Batch alias resolution for multiple covers/files. Empty/unresolved owner, cross-tenant
   owner, ambiguous alias, unsupported feature, malformed/traversal key, or mismatched
   module/owner key must stop before presigning, streaming or deletion.

## Read/delete design and failure ordering

**Upload preflight and rollback.** Current generic upload calls putObject before create
(`apps/api/src/presentation/attachments/attachments.controller.ts:225`, `:227`). create
performs another owner resolution, job editability check, and certificate metadata lookups
and writes before inserting the row
(`apps/api/src/usecase/attachments/attachments.service.ts:213`, `:221`, `:223`, `:275`).
Resolving only the owner in a new key builder is therefore insufficient: a completed job or
metadata failure could still reject after bytes have been stored.

Plan a preparation step that validates file/DTO, feature support, tenant owner existence,
authorization, job editability, and certificate/category metadata before S3 put. Keep
preflight read-only; apply certificate expiry updates and attachment creation in an
appropriate DB transaction rather than committing certificate changes early. Capture the
newly owned object key(s); if a later row/metadata transaction fails, compensate only those
new objects, record failed compensating cleanup for retry, and retain the original failure.
Recheck mutable authorization/editability where needed to avoid treating an old preflight as
a permanent lock. A successful save followed by stale-object cleanup failure has different
semantics from a failed creation; handle them separately. Existing dedicated job-walk
creation demonstrates new-row/object compensation
(`apps/api/src/usecase/job-walk-reports/job-walk-reports.service.ts:286`); DocuSign master
recording conditionally claims the key and cleans a losing object (`signed-copy-attachments.service.ts:247`).
The signed-copy attachment loop currently puts then inserts (`same file :176`), so its
per-destination compensation/idempotency must also be included, not only the controller.

Today only ticket features receive strict row-owner key validation before generic signing
and streaming (`apps/api/src/presentation/attachments/attachments.controller.ts:264`,
`:292`). Generic deletion preserves photo and loadout special handling, then dispatches
ticket validation or the permissive subJobImageObjectKeys fallback (`:340`, `:356`).

The planned non-ticket key validator must therefore cover all ordinary-file module paths
and all actual file readers, not just new writers. It must validate stored key segments
against the resolved row owner and return the exact owned object set:

- Plain module file: exactly one stored object.
- Entity photo: existing original + thumbnail logic and cover replacement semantics.
- Loadout image: existing original + thumbnail plus linked-loadout guard; no arbitrary
  structured key inferred from a permissive regex.
- Ticket image: existing original + preview strict helper, unchanged.
- Signed copy: exactly its attachment's independent object; the master is separately owned.

The linked-loadout guard is at controller `:349`. Generic row/S3 deletion keeps
`AttachmentsRepository.deleteWithObjects` rollback behavior
(`apps/api/src/service/attachments/attachments.repository.ts:142`). Reference-aware
`removeIfUnreferenced` is a different operation (`:166`) and currently checks signature
references; do not presume it protects every relation listed above. Existing schema FK
behavior and module-specific ownership must be reviewed before new destructive paths.

For replacement, a successful metadata save must not become a failed user action because
post-save old-object cleanup fails. Keep new row/object consistency, record retryable stale
cleanup, and preserve error reporting for genuine pre-save failures. Plan this explicitly
using the prior ticket's reviewed cleanup correction; do not restore its original error
propagation accidentally.

## Future migration / prefix-retirement fence (G2)

This section describes a future procedure only. Existing-file preservation versus retirement
is unresolved; no migration/deletion unit can be accepted without the developer's explicit
data decision. Rewriting existing DB keys or deleting old S3 objects invokes G2: developer
approval and the guard run against a copy of staging data are both required.

If preservation/migration is selected, plan a bounded, resumable manifest that:

1. Inventories actual flat objects and **all persisted key references**, including
   Attachment.fileName and QuotationSignature.signedDocumentUrl; do not infer coverage from
   one table. Related IDs, JSON note references and object-sharing groups stay intact.
2. Resolves each row owner within its stored tenant, identifies invalid/ambiguous/orphaned
   rows, and reports them for disposition. No arbitrary owner, UUID rewrite or silent drop.
3. Computes deterministic destination keys and an ownership/reference manifest. Audit
   duplicate old keys: fileName is not unique in the schema, so independence of historical
   rows is not proven by the model. Keep destination attachment copies independent when
   their lifecycle is independent.
4. Copies first, verifies object size/checksum/content type, and conditionally updates the
   row only if its old key still matches. Avoid races with upload, delete, replacement and
   active presigned links. A retry must not create new random copies indefinitely.
5. Removes old objects only after every referencing owner has moved (or an approved
   retirement policy applies), with a rollback/grace policy supplied by the developer.
   Bucket/environment/versioning/retention and scheduled integrations must be explicit.
6. Produces dry-run counts, unresolved rows and reference evidence before mutation; runs
   its safety guard on the staging copy; verifies migration consistency and direct-client
   access after mutation; preserves an audit/rollback manifest.

Prefix deletion is a separate acceptance gate: no production flat writers, no active DB/
master-copy references, no remaining readers/background integrations requiring the prefix,
all unresolved ownership cases disposed by an approved policy, real object inventory
reconciled, and the old-link grace/rollback policy satisfied. A code grep or successful new
upload alone does not prove that the bucket prefix is safe to delete.

## Not established / decisions still needed

- Actual DB/S3 row/object counts, stale keys, duplicate references, missing owners and asset
  alias ambiguity: **not queried**.
- Historical files preserved, migrated, or retired; target environments and grace/rollback
  period: **not decided by this audit**.
- USER and TOOL ordinary non-photo attachment use: enum/API permit it, active workflows
  were not established here. Specify support/rejection explicitly; no default flat fallback.
- JOB_WALK missing-parent branches are defensive debt, not a supported parentless workflow.
  Current schema and creation require the quotation; reject inconsistent new ownership
  before writes. Actual historical sentinel/invalid-key rows are not queried and remain
  subject to approved reconciliation, with no guessed new parent.
- PERMIT/PLAN/PO category semantics and current UI availability are not redefined here;
  vault indexes disclose historical conflicts. Direct-owner storage is an implementation
  recommendation derived from current nullable schema associations, not a new product rule.
