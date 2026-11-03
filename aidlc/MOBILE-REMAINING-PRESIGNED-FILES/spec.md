# Spec — mobile upload attachment metadata consistency

Current requester direction, 2026-11-03. Path C, no external ticket. The prior presigned-reading draft is retained in presigned-read-spec.md and is not the implementation scope.

## 0. Provenance

Source: requester explicitly requires every mobile upload to use attachments, save the resource UUID in feature_id, and use appropriate feature_type/category under patterns.md. Status: reference, developer/requester direction; no client business conflict is adjudicated.

## 1. Requirements ledger

| Req | Requirement | Source | Status |
| --- | --- | --- | --- |
| M1 | All mobile uploads store correct type and owning-resource UUID | Current requester | reference |
| M2 | All new uploads have appropriate categories, preserving specific link-time labels | Current requester | reference |
| M3 | Existing records/callers remain usable without a backfill | Compatibility needed by M1/M2; technical decision | assumed, recorded below |

## 2. Requirements

M1 applies to all nine upload operations in plan.md. Resolve business codes/User-ID aliases within the tenant, then persist the resource UUID. Ticket-owned incident files retain the documented ticket UUID; incidentReportId is their specific incident link. Job-walk signature role columns continue referencing attachment UUIDs.

M2 retains certification names, PLAN_OR_DOC, WON_EVIDENCE, Incident Evidence and existing signature/checklist/lunch labels. Generic/unlinked uploads get the neutral defaults listed in plan.md; existing linking replaces them with the specific label. Never classify a general quotation file as PLAN_OR_DOC or an arbitrary file as a P3 profile photo.

M3 preserves legacy code/User-ID reads and code-based activity/notification routes. Literal me rows are constrained by uploader. Missing/invalid owners fail; supplied UUIDs/codes never bypass tenant filters. No existing rows are rewritten.

Acceptance: each upload producer writes the matrix in plan.md; old and new owner formats both list through the current APIs; logs/notification links retain business codes; Won/Signed evidence still checks tenant, owner, type and category; existing image processing, presigned fields and upload transport remain intact.

## 3. Data model

No schema fields, migration or data rewrite. A schema comment documents new versus legacy job-walk owner identifiers.

## 4. API surface

Existing routes and DTO request shapes. Lower-layer employee/quotation owner resolvers normalize writes and enable alias reads; guard defaults cover ticket-upload categories. Parent validation is performed before S3 writes. Generic list response field names stay unchanged; featureId values on new rows become UUIDs.

## 5. Web surface

No UI changes. Existing code-based callers rely on compatible API owner resolution; Mark Won/Mark Signed evidence validation must accept new UUID-owned rows.

## 6. Mobile surface

Certificate renewal uses the linked Employee UUID and fails before upload if profile resolution/employee linkage is unavailable. All remaining producers keep their existing APIs; server normalization supplies canonical metadata.

## 7. Shared package

No shared API/type export changes expected.

## 8. Permissions and tenancy

Explicit tenant predicates on owner resolution and legacy alias reads. Preserve existing permission policy; this task introduces no viewer or new access grant.

## 9. Validation rules

Resource must resolve within tenant; no literal me/User UUID persisted on new EMPLOYEE rows. Existing upload MIME/size/processing rules remain unchanged.

## 10. Tests

New tests: not requested. Existing affected metadata expectations are updated. Run existing API/mobile checks; no runtime database/device/S3 claim without execution.

## 11. Non-functional

No new dependency, transport or storage layout. No data backfill. API-first deployment remains compatible with old mobile clients sending codes/User UUIDs.

## 11a. Ripple

Generic employee/quotation uploads and readers, employee certification reader, activity logs, expiry links/recipients, quotation send/sign evidence, job-walk signature storage, and shared ticket-upload guard. Exact locations are in audit.md and the implementation diff.

## 11b. AI decisions

| Decision | Chosen | Rationale |
| --- | --- | --- |
| Stored owner | Resource UUID; accept historical aliases on reads | Current requester; avoids data rewrite |
| Neutral category | Employee Attachment / Quotation Attachment / Ticket Attachment / Ticket Signature / Checklist Photo | Labels the known resource without inventing final signature/checklist context |
| Job-walk category | Job Walk Operator Signature / Job Walk Foreman Signature | Validated role is known at upload |
| Presentation identity | Convert owner UUID to business code for logs/expiry links | Preserves existing code-based caller contracts |
| Old me rows | Uploader-scoped reads only | Prevents cross-employee grouping |

## 11c. Siblings

All mobile upload producers are covered by the plan matrix. Web generic callers of shared functions get compatible resolution in this task. Server-generated signed-copy direct writers are a follow-up; arbitrary non-mobile attachment features are outside this upload audit.

## 12. Questions and scope answers

Resolved: metadata consistency is the current implementation goal, all mobile upload places, resource UUIDs, correct type and category. No external ticket. No new viewer or upload/download transport change in this implementation. No outstanding product question; technical choices are recorded in §11b.

## 13. Deliberately unspecified

Viewing features, presigned PUT architecture, backfilling/relabeling old objects, and unrequested business workflows. None is implemented.

## 14. Execution status

Implementation authorized by the requester's consistency instruction and clarification. Build in progress on codex/attachment-metadata-consistency; current gate results in state.md. No merge, commit or deployment claimed.
