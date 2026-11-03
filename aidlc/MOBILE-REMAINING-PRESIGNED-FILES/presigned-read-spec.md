# Spec — MOBILE-REMAINING-PRESIGNED-FILES

Draft for review, 2026-11-03. Audit/plan only; implementation is not authorized.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | Local slug; no external ticket |
| Intent | Adjacent intent.md, captured 2026-11-03 |
| Elaborated on | 2026-11-03 |
| Vault state at elaboration | INDEX and mobile/quotation conflict stubs consulted; no business conflict adjudicated |
| Open questions raised by this spec | None outstanding; three resolved in §12 |
| Already-shipped behaviour reached | Six groups in §11a; none with unresolved disposition |
| Rules consulted | AGENTS.md; contexts/mobile.md, api.md, prisma.md (tenancy), patterns.md P3 |

Source keys (vault-root-relative unless stated):

- **S1:** `decisions/2026-11-03-mobile-remaining-presigned-files-scope.md` — `[REFERENCE]`, kind: decision; requester planning direction, not client adjudication/build approval.
- **S2:** `decisions/2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md` — `[REFERENCE]`, kind: decision; prior developer scope/no-backfill decision.
- **S3:** `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` REQ-01/02/06/08 — `[UNVERIFIED]`, kind: prior spec; ticket image/display intent. Its state records merge to staging, not runtime proof.

Actual `reference` statuses override the template's old two-tag wording; none is promoted to VERIFIED. Code/audit establishes current state, never intent. No Jira lookup applies. Field-ops/quotation business conflicts are not sources for this transport/display scope.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Job document signed open/share | api, mobile | `[REFERENCE]` | S1/S2 | No scope blocker |
| REQ-02 | Both quotation cards signed open/share | api, mobile | `[REFERENCE]` | S1 | No scope blocker; prospective A |
| REQ-03 | Saved JSA signed rendering | mobile | `[UNVERIFIED]` | S3/S1/S2 | No scope blocker; prospective B |

3 total: 2 reference, 1 unverified, 0 verified/conflicted/open. Separate build request required.

## 2. Requirements

### REQ-01 — Job document signed open/share `[REFERENCE]`

- **Statement:** Mobile opens/shares linked permit, plan and PO files through API-issued signed GET links.
- **Surface:** api, mobile.
- **Sources:** S1 `[REFERENCE]`, kind: decision — remaining read migration; S2 `[REFERENCE]`, kind: decision — job artifacts deferred to follow-up.
- **Conflict:** none in transport scope; no field-ops workflow chosen.
- **Open question:** none.
- **Ripple:** Artifact response/schema/service and job-artifacts-section migrate together; old endpoints, fields and uploads remain compatible (S1/S2, D1). Enumeration: `rg -n 'jobArtifacts|downloadAttachment' apps/mobile apps/api/src`.
- **Acceptance:** Open/share permit, plan and PO files via S3 GET without API bearer headers or primary arraybuffer stream; retain filename/MIME handling. Old responses/flat keys remain usable without rewriting records.
- **Edges:**
  - **Reached by:** Ticket details → job artifacts → permit/plan/PO file rows.
  - **Does not apply when:** Uploading or adding unrequested viewers (S1/S2).
  - **When an input is absent:** No file → existing empty state; no link → byte fallback. ASSUMED — existing artifact UI/ticket-sheet fallback.
  - **Trust boundary:** Authorize ticket assignment, tenant and linked owner before signing server-held keys; no API token on S3.
  - **Read time:** Transient signed link on authorized read; no catalogue snapshot change.
  - **Matrix:** N/A — no synchronization rule.
- **Notes for the executor:** Reuse openAttachmentFromUrl; D1/D3. Guardian/tracer and mobile parser changes accompany API changes.

### REQ-02 — Both quotation cards signed open/share `[REFERENCE]`

- **Statement:** Sales users can open/share files from both quotation plan/document and general attachment cards using signed GET links.
- **Surface:** api, mobile.
- **Sources:** S1 `[REFERENCE]`, kind: decision — explicitly requests new quotation open/share and retains uploads.
- **Conflict:** none in attachment scope; no pricing/lifecycle rule chosen.
- **Open question:** none.
- **Ripple:** Both cards, list/listAll and parser change; preserve uploads/deletes and existing web reads (S1, D2). Enumeration: `rg -n '/attachments|quotationAttachments' apps/mobile apps/web/src`.
- **Acceptance:** A file in either card opens/shares with expected filename; parsing retains links; S3 gets no API token. Existing upload/delete actions and web consumers remain compatible.
- **Edges:**
  - **Reached by:** quotation-attachments-card.tsx and quotation-general-attachments-card.tsx.
  - **Does not apply when:** Generated PDF metadata, upload transport, job-walk signatures, unrelated web migration (S1).
  - **When an input is absent:** Empty list → no file action; missing/expired link → D3. ASSUMED — existing ticket-sheet file handling; no new offline guarantee.
  - **Trust boundary:** Resolve quote in current tenant before selecting/signing its rows, with existing quotation read permissions; featureId alone grants no access.
  - **Read time:** Transient authorized links; no quotation content/snapshot rule changes.
  - **Matrix:** N/A — no sync operation.
- **Notes for the executor:** Prospective Path A: current cards lack opening, so this is new behavior. Reuse native helper and card controls; D2/D3.

### REQ-03 — Saved JSA signed rendering `[UNVERIFIED]`

- **Statement:** Saved JSA photos/signatures display through returned signed covers, retaining local capture behavior.
- **Surface:** mobile.
- **Sources:** S3 `[UNVERIFIED]`, kind: prior spec — ticket photos/signatures and shared rendering; S1/S2 `[REFERENCE]`, kind: decision — read migration/no backfill.
- **Conflict:** none for display; JSA answers/signers/workflow are unchanged.
- **Open question:** none; prior scope supplies intent, not code inference.
- **Ripple:** compose-ticket-detail, checklist-rehydrate, JsaBody and JsaSignatureModal; preserve checklist mutations/local capture (S3). Enumeration: `rg -n 'photoImage|signatureImage|checklist-rehydrate' apps/mobile`.
- **Acceptance:** Reopen saved JSA: remote photo/signature covers render; expiry refreshes query; local captures preview. No new authenticated preview URLs or expiring URLs persisted in drafts.
- **Edges:**
  - **Reached by:** Saved checklist reads → JSA photo rows/signature modal.
  - **Does not apply when:** New processing/categories or incident viewer (S1/S3).
  - **When an input is absent:** Local URI wins when present; otherwise existing empty state. ASSUMED — prior local-preview branch/shared AttachmentImage.
  - **Trust boundary:** API-authorized covers; local IDs are not trusted storage keys.
  - **Read time:** Live query covers over persisted answers/IDs, not persisted signed URLs.
  - **Matrix:** N/A — no synchronization change.
- **Notes for the executor:** Prospective Path B against prior ticket. Reuse AttachmentImage and pre/post-trip pattern; D4.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no.
- **Migration required:** no.
- **Data backfill required:** no (S1/S2).
- **Existing models considered:** Attachment keys/metadata; JobAttachment, Job/JobTicket, Quotation and artifact assignments already hold owners. Search: `rg -n '^model (Attachment|Job|Quotation|PurchaseOrder)' apps/api/prisma/schema.prisma`.
- **New / changed models:** none.

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| None | N/A | N/A | N/A | S1; D1/D2 |

- **New prefix introduced:** no.
- **Child relations:** unchanged.
- **Fields whose type/precision no source states:** N/A — no stored fields added.

## 4. API surface — `apps/api`

- **Pattern:** P3 signing/cover reuse; no new upload lifecycle.
- **Existing functions/services to reuse:** S3StorageService.presignGetUrl/presignDownloadUrl; ticket-attachments service mapping/legacy-key handling; FieldTicketsService.getJobArtifacts; QuotationsService.findOne owner lookup (`:1281–1296`).
- **New exported functions/services proposed:** none required; mapper extraction only within permitted lower layers.

| Method | Route (API prefix omitted) | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| GET | `/field/tickets/:id/job-artifacts` | field-tickets DTO/controller | FieldTicketsService | Existing ticket/job reads | 01 |
| GET | `/quotations/:quoteNo?include=attachments` | quotation DTO/controller | QuotationsService | Scoped quote/attachment lookup | 02 |
| GET | `/field/tickets/:id/checklists/jsa` | unchanged | unchanged | unchanged | 03 |

- **Request DTO:** existing; no client storage-key input.
- **Response shape:** optional signed `url` on artifact/quote files; existing image cover where available; retain all IDs/metadata. Update DTOs/types/Zod parsers together. JSA covers already exist.
- **Guards / roles:** existing auth and quotation read semantics; no new stricter policy. Artifact signing follows roster boundary.
- **Route param identity:** preserve ticket UUID/quotation code boundaries.
- **Errors:** reuse existing errors; new exact copy NOT SPECIFIED.
- **Pagination (list endpoints):** unchanged.
- **Module registration:** no new module; constructor changes require provider/import tracing and API boot.

## 5. Web surface — `apps/web`

- **Routes:** unchanged; verify quote-detail attachment consumers tolerate additions.
- **Existing components to reuse:** N/A.
- **New components proposed:** none.
- **Table (searchPlaceholder; filters/filterValues/onFilterChange; emptyFilterStateMessage/unfilteredItemCount):** N/A.
- **Forms / Server state / Colors and spacing / Responsive / Copy:** unchanged.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `(field)/ticket/index.tsx` details/JSA; sales quotation attachment cards.
- **Components:** existing file helper, AttachmentImage and card controls; StyleSheet/tokens.
- **Offline / sync behavior:** retain local previews/drafts/API multipart queues; no new offline file library. Do not persist signed URLs.
- **Touch targets:** 48px.
- **Push / notifications involvement:** N/A.

## 7. Shared package — `packages/shared`

- **Types added / changed:** none expected; reuse EntityImageCover.
- **Nothing shared:** no new export; if necessary, tracer covers both consumers and dist is built first.

## 8. Permissions and tenancy

- **Roles permitted / denied:** existing feature access; no new matrix.
- **Tenant isolation:** guardian found allowlisted models/JWT context, no established normal-request cross-tenant leak. Generic attachments list/download lacks owner lookup/module permission decorators: do not enrich it blindly. D2 uses quotation owner read instead. Verify extension bypasses and ownership before signing.
- **Cross-tenant reads:** none introduced; no running-DB validation performed.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Key | Server-owned authorized record only | S3; tenancy rules | `[UNVERIFIED]` |
| Upload limits/types | Retain current rules | S1 | `[REFERENCE]` |
| New limits/TTL | NOT SPECIFIED; reuse signer configuration | S1; D3 | `[REFERENCE]` |

## 10. Tests

**New tests: not requested.** Build plan: existing mobile file-helper, both quotation-card and checklist-rehydrate suites; mobile typecheck; API lint/build/tests and affected web checks through `pnpm nx`. Fresh failures need triage. Manual: iOS/Android open/share, old keys/responses, expired/missing links, unauthorized access, JSA reopen/local capture. All checks/runtime **unrun** here. Requirements without testable acceptance: none.

## 11. Non-functional

- **Performance:** no new threshold; sign loaded rows without per-file API round trips.
- **Concurrency:** N/A — no new state.
- **Audit / activity log:** unchanged.
- **Migration/rollout order:** additive API then mobile; retain byte endpoints/fields for older clients. No schema, rewrite, dependency or PUT migration.

## 11a. Ripple — already-shipped behaviour these requirements reach

Commands also recorded in audit.md; file paths there are repository-relative.

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| Job-artifact UI/service/schema | artifact response | 01 | signed-first/fallback | S1/S2 | `rg -n 'jobArtifacts' apps/mobile` |
| Both quotation cards/list schemas | quote-owned read | 02 | new open/share, same mutations | S1 | `rg -n 'quotationAttachments' apps/mobile` |
| Web quotation detail/attachments | additive response | 02 | compatible; generic byte reads retained | S1; D2 | `rg -n 'attachments' apps/web/src/features/quotations` |
| JSA composition/body/modal | checklist covers | 03 | saved rendering/local parity | S3 | `rg -n 'photoImage|signatureImage' apps/mobile` |
| Ticket sheet/file helper | reused helper | 01/02 | retain existing behavior | S3 | `rg -n 'openAttachmentFromUrl' apps/mobile` |
| Uploads/queues | existing APIs | all | same transport | S1 | `rg -n 'FormData|multipart' apps/mobile` |

- **Surfaces with no existing behaviour in this area:** quotation cards lack open handlers (audit F4); their upload/list/delete behavior exists.
- **Consumers with no source for what happens to them:** none found; tracer re-enumerates actual changed shapes during build.

## 11b. AI decisions — reviewed by a developer

| ID | Decision | Chosen | Why / alternatives (existing code) | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Artifact response | Add optional url, retain fields/routes | Reuse ticket mapper; replacing routes breaks clients | G3 guardian; G5 tracer | pending | |
| D2 | Quote boundary | Enrich existing quote detail include=attachments; mobile list/listAll reads it | findOne resolves owner first; reject generic list enrichment/new route | G3 guardian; G5 tracer | pending | |
| D3 | Open/expiry | openAttachmentFromUrl; refresh query + existing byte fallback | Existing ticket sheet/helper; no dependency/TTL change | no | pending | |
| D4 | JSA lifetime | Render live covers over answer/ID/local-URI drafts | Existing checklist/AttachmentImage; reject persisting URLs | no | pending | |

Guardians/tracer are execution gates, not unresolved product questions. No G2/new dependency proposed.

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Reviewed by | Enumerated by |
| --- | --- | --- | --- | --- |
| Permit/plan/PO | signed file | yes, REQ-01 together | pending | `rg -n 'permits|plans|purchaseOrders' apps/mobile/components/field/job-artifacts-section.tsx` |
| Both quote cards | signed file | yes, REQ-02 together | pending | `rg --files apps/mobile/components/sales` |
| Pre/post-trip/ticket/profile | P3 | preserve; JSA parity only | pending | `rg -n 'AttachmentImage|thumbnailUrl' apps/mobile` |
| Certificate/job-walk/incident | upload/no active viewer | no invented viewer | pending | audit F5/F6 and incident search |
| Web generic downloads | files | separate follow-up | pending | `rg -n 'downloadAttachmentBlob' apps/web/src` |

## 12. Open questions — the stop-and-ask list

No outstanding questions. All answers reference S1 (2,552 bytes, 2026-11-03), retained below.

### Q1 — Upload transport

- **Question:** GET viewing/downloads only or uploads too?
- **Options:** A. GET only; B. Include uploads; X. Other.
- **Answer:** A — requester, 2026-11-03.
- **Why it cannot be answered from what is written:** Initial wording ambiguous; explicit reply resolved it.
- **Blocked:** none now; bounds all REQs.
- **Candidates:** S1; intent; S2 (2,875 bytes, 2026-10-27).
- **Owner:** requester.
- **Workaround, if any:** N/A — answered.
- **Status:** resolved — see decisions/2026-11-03-mobile-remaining-presigned-files-scope.md

### Q2 — External ticket

- **Question:** External ticket ID?
- **Options:** A. No ticket; B. Supply ID; X. Other.
- **Answer:** A — requester, 2026-11-03.
- **Why it cannot be answered from what is written:** Original omitted ID; requester confirmed none.
- **Blocked:** none; use local slug.
- **Candidates:** S1; intent.
- **Owner:** requester.
- **Workaround, if any:** N/A — answered.
- **Status:** resolved — see decisions/2026-11-03-mobile-remaining-presigned-files-scope.md

### Q3 — Quotation open/share

- **Question:** Include new quotation open/share?
- **Options:** A. Include; B. Defer; X. Other.
- **Answer:** A — requester, 2026-11-03.
- **Why it cannot be answered from what is written:** Code proves absence only; requester supplies intent.
- **Blocked:** none now; REQ-02 prospective A.
- **Candidates:** S1; audit F4 (code only).
- **Owner:** requester.
- **Workaround, if any:** N/A — answered.
- **Status:** resolved — see decisions/2026-11-03-mobile-remaining-presigned-files-scope.md

## 13. What this spec deliberately does not specify

No certificate/job-walk/incident viewer, direct-S3 uploads, backfill, schema/dependency, pay rule, quotation lifecycle, role matrix or unrelated web conversion. Exact new copy/design NOT SPECIFIED: reuse controls. Prior runtime claims are not a current baseline.

## 14. Sign-off before build

- [x] No OPEN/CONFLICT requirements; answers and actual flags recorded.
- [x] All §12 questions resolved to S1; Edges/ripple filled with assumptions marked.
- [ ] Developer reviewed §11b/§11c and execution guardian/tracer obligations.
- [ ] Separate build request received.
- [ ] Vertical units prepared when authorized; not produced by this elaborator.

Scope answered by requester, 2026-11-03. Developer build sign-off: pending.
