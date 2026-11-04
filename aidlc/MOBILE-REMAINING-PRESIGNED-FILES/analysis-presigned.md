# Independent analysis — U1 remaining mobile presigned reads

2026-11-03. Reviewer: tcg-analyst role, read-only source review. Actual branch `codex/mobile-presigned-reads`, uncommitted diff against metadata parent. Current spec/units read; API/mobile contexts and review-pr thermo-nuclear/ponytail rubrics applied. No source edits by this reviewer.

## Verdict

**Source review: ship with follow-ups, subject to the executor's final observed gates.** No unresolved blocking source finding remains after the incident-cache fix below. Real device/S3/native sharing/expiry/cross-tenant execution was not performed by this reviewer; this is not deployment or runtime sign-off. Construction completion must cite final gate results separately in review/state, not infer them from this verdict.

## Checks actually run by this reviewer

- **VERIFIED:** `git diff --check` passed with no output on the reviewed diff.
- **VERIFIED:** `git diff --stat`, `git status --short`, full API/mobile diff reads and reads of all three new source files established the review surface, including untracked files.
- **VERIFIED:** `git diff --name-only -- apps/api/prisma packages/shared apps/web` returned no changed paths. No schema migration, shared export or web source change is in this continuation.
- **VERIFIED:** Python script enumerating tracked diff plus untracked TS/TSX, comparing `git show HEAD:<path>` with current line counts, found no <=1000 to >1000 source-file crossing. Largest changed source is JsaBody 854 → 940 lines.
- **VERIFIED:** `rg -n 'openStoredAttachment|downloadAttachment\(' apps/mobile --glob '*.{ts,tsx}' --glob '!*.test.*'` found six new opening consumers through the common helper and no remaining job-artifact downloadAttachment producer.
- **VERIFIED:** Route/field/type/wrapper searches (`/me/certifications`, ApiCertificationResponse, CertificationSchema, openAttachmentFromUrl, downloadAttachmentFromUrl, shareDownloadedAttachment, findForSignedAccess) established the additive contract and pre-existing helper caller. No new shared wire type exists; local Zod parsing explicitly models the new endpoint.
- Application lint/typecheck/build/test runs are owned by the executor/root. This reviewer did not rerun competing resource-intensive gates and does not claim their outcome here.

## Findings and disposition

1. **INFERRED, P2, resolved:** New incident viewer could omit evidence uploaded immediately after report creation. `useSubmitTicketIncident` caches a created report before evidence uploads; the original upload hook did not invalidate that list, so details reopening within staleTime could reuse attachments=[]. Reasoned from use-incident-report.ts and use-ticket-incidents.ts, not a device reproduction.
   - **VERIFIED resolution:** `git diff -- apps/mobile/data/hooks/use-ticket-incidents.ts` now shows onSuccess invalidating queryKeys.ticketIncidents(ticketId) after successful evidence uploads. Mutation/submission/MIME behavior is otherwise retained. Runtime immediate refresh remains in the named manual checks.
2. **INFERRED, resolved:** Exact MeService expected response needed the additive attachmentId. An existing `toEqual` expectation omitted it. `git diff -- apps/api/src/usecase/me/me.service.spec.ts` now shows the existing expectation updated. No new test case was requested or added by this change.

## Requirement coverage — source conclusions, not runtime claims

| Requirement | Source conclusion | Evidence / limits |
| --- | --- | --- |
| REQ-01 metadata | INFERRED retained | Continuation does not alter existing upload owner/category logic or schema; final regression suite results belong to executor |
| REQ-02 job documents | INFERRED implemented | JobArtifactsSection now uses common signed opener for its shared file action, covering permit/plan/PO; old metadata authorization response unchanged, obsolete primary binary adapter removed |
| REQ-03 quotation cards | INFERRED implemented | Both saved-file rows open through helper; upload disabled prop does not disable read action; upload/list/delete and category logic retained |
| REQ-04 certification/job walk | INFERRED implemented | MeService maps separate uploaded attachmentId by normalized name, independent of existing credential expiry winner; optional mobile schema/button. SavedJobWalkSignaturesCard lists existing reports for quote and both role IDs, mounted on quotation Attachments tab; capture/edit form untouched |
| REQ-05 JSA | INFERRED implemented | Live assignments map covers by matching attachment ID; saved signatures supplement local capture; local URI priority retained in AttachmentImage; readonly photo/modal actions render remote content and refetch on expiry |
| REQ-06 incident | INFERRED implemented | Ticket details mounts existing incident-query viewer; images/signature use returned covers, non-image files use signed opener; upload invalidation fixes new evidence visibility; preview derives current cover by ID after query refresh |

## Tenant and file access

- **INFERRED:** `findForSignedAccess` rejects missing context and selects by both id and explicit tenantCompanyId. This remains effective independent of tenant-extension bypasses, including SUPER_ADMIN behavior. Only the returned row.fileName is signed; the client supplies no storage key. No new tenant model, impersonation route or data-write permission is introduced.
- **INFERRED:** The new endpoint deliberately retains current generic authenticated tenant-wide download authorization; it does not add owner/module/crew checks. This policy is now explicitly documented in spec §8/D1. Existing feature lists retain their own visibility checks; do not describe the links endpoint as narrower parent authorization.
- **INFERRED:** Attachment MIME preview allowlist excludes SVG/active document formats; downloads use presignDownloadUrl with safe attachment/octet-stream overrides. Existing byte route remains available to old apps/web.
- Guardian's independent review and any runtime isolation probes must be cited separately by the executor. Static predicates are not proof from a real database request.

## Contract and error behavior

- **INFERRED:** GET /attachments/:id/links is additive `{id, originalName, mimeType, url, previewUrl?}`. Existing generic list/upload/download contracts remain unchanged, so web generic attachment/blob users and old mobile calls remain compatible.
- **INFERRED:** Optional certification attachmentId is modeled by the mobile parser and omitted when no uploaded document exists; certification id/status/expiry dedup remain unchanged. Existing API interface gains an optional field; shared compile-time coupling is not assumed.
- **INFERRED:** Common helper fetches links per open, validates matching ID and current session epoch, downloads without API bearer headers and retries only the signed download once. Native sharing happens outside retry, so cancellation/error cannot cause a second share prompt. Session transition before share suppresses it.
- **INFERRED:** Signed links in the new helper are imperative locals, not persisted state. JSA merges attachment IDs/names/GPS into draft capture, not covers/URLs. Incident previews resolve live covers rather than freezing a signed object in component state.
- Existing openAttachmentFromUrl now delegates separate download/share functions with the same public API; its pre-existing ticket attachment sheet remains a regression target in executor checks.

## Decisions and maintainability

- Structural decisions trace to spec D1-D6 and plan.md common implementation decisions: shared endpoint/opener, read-only job-walk card, incident viewer and JSA covers. Exact MIME allowlist, payload fields, latest-created certification document selection with UUID tie-break and download/share split should be recorded in the executor's detailed decisions table.
- **INFERRED advisory:** Quote card opening/loading/error blocks are close siblings and duplicate approximately the same small UI flow. Both use one canonical network/opening helper, so there is no divergent storage policy now; extracting a row/action primitive is a future cleanup only if more consumers need it. Do not grow this migration for broad restructuring.
- **VERIFIED:** No 1k crossing; no added dependency/model/enum or new payroll rule in reviewed diff. No web test-ID contract changed.
- **INFERRED:** New readonly controls/empty states correspond to explicit saved-file requirements; no certification approval, job-walk editing, incident lifecycle or quotation price/status behavior was silently selected.

## Scope and remaining uncertainty

Complete at source-review level: yes for current U1 matrix. Contained: yes. Demo works: **not established** — configured device/API/S3 unavailable to this reviewer. iOS/Android native share behavior, legacy object availability, expiry retry and cross-tenant runtime checks remain explicit validation limits, not claimed passes.

Out-of-scope follow-ups remain unrelated web blob conversion and server-generated signed-copy attachment writer canonicalization. No historical rows were rewritten. No new product question was written to spec §12.

Least confidence: native file opening across iOS/Android and real stored MIME/object combinations; existing mocked suites cannot establish those outcomes. If this breaks later, the most likely drift is a new upload/file type or a sibling bypassing the common opener/optional attachment identity convention (INFERRED).
