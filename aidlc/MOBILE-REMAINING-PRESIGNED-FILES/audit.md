# Mobile presigned file audit — 2026-11-03

Source review of client branch `staging` at `da84cf463ec12cdd53271ac3bec3778b17031127`; overlay before this work `aa828a99caaaecea8c7f8d9e4b76c662cdac4e6b`. These are observed local revisions, not a claim about deployment.

## Result

**One active primary API-stream download flow remains**, serving linked job documents across permits, plans and purchase orders. **One additional API-stream service is a deliberate ticket-attachment fallback.** No current mobile image renderer was found newly constructing an authenticated `/attachments/:id/download` preview URL. JSA has a separate gap: signed metadata arrives but is not connected to saved-image rendering.

Uploads still pass through the API throughout mobile, including migrated ticket features. The requester explicitly confirmed that these uploads stay. `as unknown as Blob` in React Native FormData is not evidence of streaming downloads.

## Findings and reachability

All paths below are repository-relative. VERIFIED means a source search/read established the code fact; behavioral consequences are explicitly INFERRED. No device, running API or real S3 traffic was exercised.

| ID | Classification | Reachable code and evidence | Proposed disposition |
| --- | --- | --- | --- |
| F1 | VERIFIED active primary stream | Field ticket route `apps/mobile/app/(field)/ticket/index.tsx:943`, shared `features/field-ticket/steps/shared/StepBodyShell.tsx:253` → `components/field/ticket-details.tsx:129` → `job-artifacts-section.tsx:87` → `data/services/job-artifacts/job-artifacts.http.ts:20`; unconditional authenticated `/attachments/:id/download`, `responseType: 'arraybuffer'`, then `openAttachmentFile`. | Migrate linked permit, plan and PO files together to signed links. |
| F2 | VERIFIED compatibility fallback | `components/field/ticket-attachments-sheet.tsx:235` tries `image.originalUrl ?? url`, then `ticket-attachments.http.ts:63` streams if absent or failed. | Keep compatibility endpoint; reuse signed-first pattern. Do not describe ticket files as unmigrated. |
| F3 | VERIFIED incomplete JSA integration; missing remote display is INFERRED | `data/contracts/checklist.contract.ts:27,53,72` accepts photo/signature covers; `data/compose-ticket-detail.ts:318` only forwards checklist items; `features/field-ticket/steps/shared/checklist/checklist-rehydrate.ts:29` copies answers/IDs without covers/signatures; `steps/jsa/JsaBody.tsx:662` omits `photoImage` and expiry callback; `JsaSignatureModal.tsx:161` renders local URI only. | Separate repair for the already specified ticket migration; use live query covers without persisting expiring URLs in drafts. |
| F4 | VERIFIED upload/list/delete only; new open/share now requested | Sales `quotation-attachments-card.tsx:151` and `quotation-general-attachments-card.tsx:134` render filename rows with delete/upload actions, no open/download. `data/services/quotation-attachments/quotation-attachments.http.ts:22,64,76` lists generic attachment rows and posts files; contract at `data/contracts/quotation-attachment.contract.ts:107` has no signed URL/image. | Add signed-link open/share to BOTH cards. It is new behavior, not an existing stream replacement. |
| F5 | VERIFIED upload-only certification surface | `app/(field)/menu/certifications.tsx:89` → renewal modal → `data/services/certifications/certifications.http.ts:39`; multipart `/attachments/upload`. No remote viewer found. | Upload transport stays; viewer is not required for this migration. |
| F6 | VERIFIED upload-only job-walk signatures | `app/(sales)/job-walk.tsx:384` captures local PNG, `job-walk-reports.http.ts:39` posts multipart; saved contract carries IDs (`job-walk-report.contract.ts:49`), local signature pads at screen line 681. | Upload transport stays; adding saved-signature viewing is separate behavior and is not inferred. |

`JobArtifactFileSchema` (`data/contracts/job-artifacts.contract.ts:3`) lacks `url` and `image`. Both it and the quotation attachment Zod schema strip unmodeled response fields: API-only signing changes will not enable mobile opening.

## Already migrated, dormant code and false positives

- VERIFIED profile uses `lib/profile-picture.ts:15` → `identity.cover.thumbnailUrl`; `design-system/primitives/avatar.tsx:57` omits bearer headers for S3 URLs.
- VERIFIED ticket customer signatures/identity photos, lunch captures, pre/post-trip and attachment thumbnails use covers through `components/field/attachment-image.tsx:48`. New attachment-ID-to-download preview generation was removed in `lib/attachments.ts:20`.
- VERIFIED incident contracts accept image/file/signature links (`data/contracts/ticket-incident.contract.ts:46`); there is no current runtime incident gallery consumer. A new viewer was explicitly deferred by prior Q8=A; absence is not streaming.
- VERIFIED `lib/attachments.ts:52` still recognizes old authenticated URLs saved in drafts. This is compatibility handling, not a new primary download producer.
- VERIFIED `steps/shared/fallback/SignatureBody.tsx:26` documents itself as currently unreachable; exclude from the active defect list.
- Local capture PNGs, `file://` previews, inline blur `data:` URLs, image compression, mock bytes and JWT base64 are not S3 streaming. No production mobile generated-PDF binary download was found; quotation PDF chips are display metadata.

## Follow-up: attachment ownership metadata (requester question, 2026-11-03)

All three upload-only/incident surfaces use the same `attachments` table (`schema.prisma:4441`), with S3 bytes addressed by `file_name`. VERIFIED write mappings:

| Surface | feature_type | feature_id | category | Precise link |
| --- | --- | --- | --- | --- |
| Certification renewal | EMPLOYEE | Mobile profile.id = User UUID; literal `me` if profile fetch fails | Certification name when supplied; server may derive it | Optional certificateId/completionDate/expiresAt; service normalizes certificateId depending on selected row kind |
| Job-walk operator/foreman signature | JOB_WALK | jobWalkCode | Not set, therefore null | JobWalkReport.operatorSignatureAttachmentId / foremanSignatureAttachmentId |
| Incident evidence | TICKET_INCIDENT | Ticket UUID for current writes | Incident Evidence | Attachment.incidentReportId |
| Incident customer signature | TICKET_SIGNATURE | Ticket UUID for current writes | Incident Evidence, set when incident links signature | TicketSignature attachment FK, referenced by incident.signatureId |
| Ticket signature comparison | TICKET_SIGNATURE | Ticket UUID for current writes | Step-specific label set at link time | TicketSignature.signatureAttachmentId / identityPhotoAttachmentId |

Evidence: `apps/api/src/usecase/job-walk-reports/job-walk-reports.service.ts:153`; `usecase/ticket-incidents/ticket-incidents.service.ts:201,238`; `usecase/ticket-attachment-guard/ticket-attachment-guard.service.ts:176`; `usecase/ticket-signatures/ticket-signature-step.constants.ts:23`; `apps/mobile/data/services/certifications/certifications.http.ts:31–52`. Job-walk code ownership and direct role FKs are explicitly documented in the schema; null category is a difference from ticket labeling, not proof of a broken relation.

**Certification inconsistency:** `identityHttp.getProfile` reads `/users/me`, whose id is the User UUID. Mobile `/me/certifications` deliberately searches user UUID, employee UUID and employee code (`apps/api/src/service/me/me.repository.ts:57–78`). Web employee attachment/certificate panels pass only employeeCode (`apps/web/src/features/employees/components/detail/employee-detail-body.tsx:247–256`), and generic attachment listing matches feature_id exactly (`apps/api/src/service/attachments/attachments.repository.ts:141–149`). INFERRED consequence: a renewal stored under User UUID does not appear in that web code-based attachment list. In addition, the literal `me` upload fallback is not normalized by the generic upload path, and the mobile certification reader does not include it. This is a separate ownership/read-compatibility defect to account for before adding signed certification reads; it does not authorize rewriting existing rows. No live records were inspected and no repair was implemented.

Additional certification relation detail: `/me/certifications` can return an EmployeeCertification or existing Attachment ID. `AttachmentsService.create:149–193` normalizes that input; for a legacy EmployeeCertification it clears certificateId after updating expiry. Web's dedicated `employee-certificates-section.tsx:107–109` filters for non-null certificateId. Therefore normalizing feature_id alone would not settle all legacy renewal visibility; certificate linkage must be traced separately before any repair. This is an existing read mismatch, not a requirement to backfill data.

## API and web boundary

- `apps/api/src/usecase/field-tickets/field-tickets.service.ts:246` authorizes ticket membership and assembles job artifacts; attachment projections/mapping currently contain metadata only. Extend the existing job-artifact response, its DTO/types and mobile parser together.
- `apps/api/src/usecase/attachments/attachments.service.ts:237` returns repository rows from generic `findByFeature`; quotation list callers do not receive a signed file field today. Guardian VERIFIED that generic attachment list/download routes lack owner lookup/module-permission checks (`presentation/attachments/attachments.controller.ts:180`, `guard/permissions.guard.ts:25`). This is existing same-tenant behavior, not an established cross-tenant leak. Do not sign every generic list by default: resolve the quotation in the caller's tenant, select its files, and sign at a quote-specific boundary while preserving existing permissions. `usecase/quotations/quotations.service.ts:1281` provides an owner-resolution precedent.
- Reuse `apps/api/src/service/storage/s3-storage.service.ts:71` (`presignGetUrl`) and `:77` (`presignDownloadUrl`). Current signer uses a one-hour stable signing window and 24-hour validity (`:21–22`), not the stale approximately-one-hour wording in some mobile comments.
- Reuse ticket response shaping in `apps/api/src/usecase/ticket-attachments/ticket-attachments.service.ts:258`: original/image cover versus signed download URL, including legacy stored keys. Old flat objects need no backfill.
- VERIFIED web entity/profile photos and ticket progress images use signed covers. **Web general attachment downloads still use blobs**, e.g. `apps/web/src/features/attachments/api/attachments.service.ts:132`. The reference architecture is not universal across web. Unrelated web transport conversion is a follow-up, while affected web callers must stay compatible.
- INFERRED rollout risk: removing old fields/download endpoints breaks older shipped mobile. Use additive responses, API-first rollout and retain fallback routes. Signed requests must not carry the API bearer token.
- INFERRED security risk: possession of an attachment ID or an S3 key is not file-access authorization. Sign only records fetched through the authorized tenant/owner scope, and separately verify Prisma extension bypass conditions.

## Sources and process

- `GUIDE.md` §2: reviews/exploration do not start a build loop. This session performs inception planning only. The proposed quotation opening behavior warrants Path A; behavior-preserving artifact transport work can be Path C and the missed JSA migration can be Path B against prior requirements.
- Prior ticket `MOBILE-TICKET-PRESIGNED-IMAGES/state.md:22` explicitly left quotation attachments and job artifacts as follow-ups. Its old deployment/runtime notes are historical, not current validation.
- `vault/decisions/2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md:30` — status reference, prior developer decision: follow-up scope and no backfill.
- `vault/decisions/2026-11-03-mobile-remaining-presigned-files-scope.md` — status reference, current requester direction: GET reads only, retain uploads, include quotation open/share, no external ticket.
- Field-ops source documents remain unverified and conflicting; the conflict stub was consulted without choosing a candidate. This technical plan does not adjudicate business rules.

Specialist passes: read-only Explore mobile audit, tcg-contract-tracer, tcg-scrum source/scope review, tcg-prisma-guardian and candidate decomposition review; independent tracer corroborated the JSA gap. Guardian verified ordinary HTTP tenant scoping and its missing-context/SUPER_ADMIN/non-allowlisted-model bypasses, without database testing.

## Reproduce the source searches

```bash
rg -n 'download|blob|arraybuffer|base64|presign|uploadAsync|FileSystemUploadType|FormData|multipart|fetch\(' apps/mobile --glob '*.{ts,tsx}'
rg -n 'responseType|ArrayBuffer|downloadAttachment|openAttachmentFile|openAttachmentFromUrl' apps/mobile --glob '*.{ts,tsx}'
rg -n 'Image|source=|getAuthHeadersForUri|resolvePhotoUri|photoImage|signatureImage|thumbnailUrl|originalUrl' apps/mobile --glob '*.{ts,tsx}'
rg -n 'jobArtifacts|quotationAttachments|useTicketIncidents|useJobArtifacts|Linking|downloadFileAsync|shareAsync' apps/mobile --glob '*.{ts,tsx}'
rg -n '/attachments|job-artifacts|downloadAttachmentBlob|openAttachmentBlob' apps/web/src apps/api/src packages/shared/src
```

Inventory from `rg --files apps/mobile`: 1,006 non-ignored mobile JS/TS-family source files; 998 TS/TSX, including 678 non-test TS/TSX files (the latter still includes mocks/configuration). Search was across the full mobile tree, followed by reachability inspection; these counts do not mean 678 independent production callers. Ignored generated router declarations are not part of this count.

Tracer passes: route literals, response fields, shared-type use and wrapper consumers. Mobile-local file schemas require explicit parser updates; importing an image cover type alone does not compile-check the endpoint response. Tests/build/lint and runtime checks were not run: no application change was made. Execute gates and device checks during implementation; do not reuse historical green/red claims as a baseline.
