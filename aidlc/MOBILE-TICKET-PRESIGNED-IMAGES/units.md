# Units — MOBILE-TICKET-PRESIGNED-IMAGES presigned S3 images in the mobile ticketing flow

> Written 2026-10-28 by `tcg-decomposer` from the approved `spec.md` beside it (no Jira id; slug
> stands in for `SCRUM-###`, Q2). Consumed by an executor, one unit at a time.
> **Nothing has been implemented.**

## Answers that resolve the `[OPEN]` rows

The spec's ledger rows REQ-09, REQ-10, REQ-11 still read `[OPEN]` because the elaborator has not
re-run. They are treated here as **resolved by Haris's in-session answers** (spec.md §12 and §11b D6):

| Row | Answer | Effect on slicing |
| --- | --- | --- |
| REQ-09 | Q3 = A | Old flat ticket images use the no-blur original-as-thumbnail fallback (D5); no backfill. Built once in U1's presign-shape helper; every unit checks one old-row image by hand. |
| REQ-10 | Q1 = A | Sales quotation attachments and job artifacts are **out**. Follow-up ticket, not a unit. `job-artifacts.http.ts` and quotation attachment code are not touched. |
| REQ-11 | Q4 = C | Nearest-label mapping (spec Q4 Answer line, derived, flagged to confirm at review) is distributed to the unit that owns each link site: compliance to U1, checklist signature to U2, incident signature to U3, WTL identity photo to U4. |
| Q5 = A | video plain file + presigned link; undecodable image rejected | Rejection applies to every image-group upload route (U1 builds it); video handling is U3. |
| Q6 (revised) | superseded by spec D11 (Haris, 2026-10-28): ticket-only 640 px aspect-preserving preview as `thumbnailUrl`, 32 px blur as `placeholderDataUrl`; signatures and identity photos display from the preview, original only on zoom | Responses use the shared `EntityImageCover`, which gains `originalUrl` for every cover *(amended 2026-10-28, Haris: was "the new `TicketImage` type (`EntityImageCover & { originalUrl }`)", now removed)*; see A1 below. |
| D6 | confirmed additive: new fields beside the bare ids | Bare ids stay in every response; older mobile builds and the offline queue keep working. No cross-surface break window. |

Derived acceptance criteria in the spec are accepted as definition of done.

## Pre-build gates (not blocking the slicing, blocking the build)

> **Waived by Haris, 2026-10-28:** "For gates just skip them". The items below are recorded as
> skipped, not done: they stay unticked so the record shows they did not run. U1 may be built
> without them. The `tcg-analyst` pass on each unit still applies, and the D1 key tree is
> still a data-rewrite risk (G2) if it changes after objects exist.

- [ ] `spec.md` §14 sign-off boxes are **not yet ticked**. Haris ticks them before U1 is handed over.
- [ ] `tcg-scrum` decision notes for Q1, Q3, Q4, Q5, Q6 are **not yet written** (§12 Status lines say pending).
- [ ] §11b **Reviewed by** is blank on D1–D5 and D7–D10. D1 (the S3 key tree) matters most: it
  is `[UNVERIFIED]` and every new object conforms to it, so a later change is a data rewrite (G2).
  Haris reviews D1 before U1 is built. Settle it by reading the D1 row; nothing else sources it.
- [ ] Q4 mapping is derived from option C: confirm at review.
- [ ] The three `[OPEN]` ledger rows in `spec.md` still read `[OPEN]` — elaborator to re-run and
  restate them from the answers (the spec is read-only here).
- Q2 (Jira id) is non-blocking: branches use the slug.

## Findings for the elaborator (not units)

- **A1 — shape for ticket images (resolved by spec D11, Haris 2026-10-28; amended 2026-10-28).**
  Image fields on tickets, single or in a gallery, use the shared **`EntityImageCover`**
  (`id`, `placeholderDataUrl`, `thumbnailUrl`, `originalUrl`). `EntityImageCover` itself gains
  `originalUrl`, so every cover the API returns carries it (profile `/users/me`, employee, DAS,
  tool and asset lists, and field-ticket images). For a ticket image `thumbnailUrl` is the
  presigned 640 px preview and `placeholderDataUrl` the 32 px blur; entity covers keep the
  160 px thumbnail and 24 px blur. `originalUrl` feeds the full-screen/zoom view. Galleries
  (incident evidence) are `EntityImageCover[]`. `EntityImageListItem` is unchanged. Mobile's
  zod cover schema marks `originalUrl` optional and falls back to `thumbnailUrl`. Property
  names follow D6 (`signatureImage`, `identityPhotoImage`, and the same `…Image` suffix
  elsewhere). Record in the PR AI-decisions table and show it to `tcg-contract-tracer`.
  - *Amended 2026-10-28 (Haris; commit `9f19d41e9`):* this finding first read "the new shared type `TicketImage = EntityImageCover & { originalUrl: string }`", galleries `TicketImage[]`, and "`EntityImageCover` and `EntityImageListItem` are unchanged, so web and profile photos are not disturbed". That type is removed. Why, as Haris put it: the extra type was not needed because `cover` should carry the original, and this should be generic for all cover objects. Effect: every list response carries one more presigned URL per cover (about 600 characters, estimate); web ignores the field at runtime.
- **A2 — rejected uploads and the offline queue.** Q5 = A makes ticket upload routes return an
  error for an undecodable image (they accepted any file before). Whether mobile `sync/drain.ts`
  retries or drops a 4xx on a queued upload is not in the spec (R7 says "unchanged"). U1
  checks this before shipping (see U1 Ripple).
- **A3 — Attach-File images.** D1 names three groups (`signatures`, `checklist-photos`,
  `incident-evidence`) plus `documents`. An image sent through `…/attachments` has no group.
  U5 uses a fourth fixed group, `attachments` (an AI decision, recorded in the PR).
- **A4 — step keys the label table does not name.** `recordSignature` accepts any step key.
  Only `sig1`, `sig2`, `compliance` get a label (Q4). Any other step key keeps `category` null.
- **A5 — REQ-05 mapping.** The spec says `breakIndex + 1`; the plan says `wtl:1..4`. U4 verifies
  against `wtlStepKeyFor` in live code before writing labels.

## Gate baseline

**Gate baseline:** *`2026-10-28`, local `main` at `329fd2a56` (clean; `origin/main` is `6cebfc32f`, one web-only fix ahead, not pulled) — `pnpm lint`: 0 errors (warnings only: 678 / 404 / 336 across projects); `pnpm typecheck`: pass; `pnpm build`: pass; `pnpm test`: **fail** — api 292 suites / 3393 tests pass; mobile 9 suites / 18 tests fail (`notifications-sheet`, `needs-attention-section`, `returned-correction-dispatch`, `start-work-returned-correction`, `step-dispatch`, `alerts`, `field`, `quotes/[id]`, `use-ticket-progress`), several with 25-50 s runtimes, so some may be load timeouts from running the gates back to back; `@tcg/web:test` reported failed by Nx while its runner printed pass 192 / fail 0 and pass 122 / fail 0 (cause not isolated).* Run with `NODE_OPTIONS=--max-old-space-size=4096`. These test failures are inherited: an executor reports failures **vs this list**. Re-run the mobile suites in isolation before blaming a unit.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Crew sees customer signatures and identity photos (sig1, sig2, compliance) load from presigned links on iOS, with labelled rows and WebP variants; carries the shared helpers and `AttachmentImage` | REQ-01, 02, 03, 04, 07, 08, 09, 11 (part) | api, mobile | — | ~900 lines / ~22 files | built — feat/MOBILE-TICKET-PRESIGNED-IMAGES-u1-signatures |
| U2 | Crew sees checklist and deficiency photos (pre-trip, post-trip, JSA) and checklist signatures load from presigned links, labelled by checklist type | REQ-01, 02, 03, 04, 07, 08, 11 (part) | api, mobile | U1 | ~600 lines / ~14 files | built — feat/MOBILE-TICKET-PRESIGNED-IMAGES-u2-checklist |
| U3 | Crew sees incident evidence and the incident signature load from presigned links; video evidence opens by presigned link | REQ-01, 02, 03, 04, 07, 08, 11 (part) | api, mobile | U1 | ~550 lines / ~12 files | built — feat/MOBILE-TICKET-PRESIGNED-IMAGES-u3-incident |
| U4 | Crew sees lunch worked-through signatures load from presigned links, labelled `Lunch WTL 1`..`4`; display-by-`/download` branch retired | REQ-01, 02, 03, 05, 07, 08, 11 (part) | api, mobile | U1 (stack after U3) | ~450 lines / ~10 files | built — feat/MOBILE-TICKET-PRESIGNED-IMAGES-u4-lunch-wtl |
| U5 | Crew opens and shares Attach-File documents from a presigned link; image attachments get variants | REQ-02, 03, 06, 07 | api, mobile | U1 | ~450 lines / ~10 files | built — feat/MOBILE-TICKET-PRESIGNED-IMAGES-u5-documents |

- **Status** takes exactly one of: `not started` · `in progress — <branch>` · `built — <branch>`
  · `merged — PR #<n>` · `cut — <reason>`. Never a commit SHA.
- Requirements covered: REQ-01..REQ-11, counted against `spec.md` §2 on 2026-10-28: **11 in spec,
  10 covered, 1 not covered.** Partial entries: REQ-04 is split by link site (U1 signatures and
  identity, U2 checklist, U3 incident, U4 WTL is REQ-05); REQ-11 is split by item (compliance U1,
  checklist signature U2, incident signature U3, WTL identity photo U4); REQ-03 and REQ-07 are
  split by upload route. REQ-09 is built once in U1 (helper) and checked by hand in every unit.
  Not covered: **REQ-10** (sales quotation attachments, job artifacts) — out of scope by Q1 = A;
  follow-up ticket, no unit.
- Units blocked on an open question: **none.** (Pre-build gates above are sign-off, not open questions.)
- Per-unit ripple: every unit touches already-shipped behaviour and carries a regression row.
  Rows with a named source and check: all. Rows with no source: none (R12 `category` readers is
  an enumeration the executor runs at the start of U1; if it finds a list that filters on these
  labels, stop and add a §12 question).

---

## U1 — Signatures and identity photos, end to end (carries the shared helpers)

- **Outcome:** a crew member capturing a customer signature, identity photo or compliance
  signature sees them load on iOS from presigned links (original, blur beneath), with WebP
  variants stored under the per-ticket key tree and the row labelled.
- **Kind:** vertical. U1 also introduces the helpers every later unit uses (variant store,
  presign-shape, key builders, `setCategory`, `AttachmentImage`). They are not split out
  because a helper with no caller proves nothing and cannot be reviewed against the spec.
- **Requirements covered:** REQ-01, REQ-02 (signature responses), REQ-03 (signature upload
  route), REQ-04 (rows 1–5 of the label table), REQ-07 (`signatures` group), REQ-08 (component
  and signature/identity sites), REQ-09 (D5 helper), REQ-11 (compliance-step photo and signature only).
- **Depends on:** —
- **Branch / PR base:** `feat/MOBILE-TICKET-PRESIGNED-IMAGES-u1-signatures` from `origin/main`.
- **Size estimate:** ~900 source lines, ~22 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — none | `Attachment.category`, `placeholderDataUrl` and the feature types already exist (spec §3) |
| API: key tree | `S3StorageService.buildEntityImageKey` gains optional `subfolder` (default `profile-pictures`); add `buildTicketFileKey` (D1) | profile keys byte-identical |
| API: processor profile | `EntityImageProcessor.process(input, profile = ENTITY_PROFILE)`; add the ticket profile: preview 640 px `fit: 'inside'` WebP q80, placeholder 32 px blur (D11) | default profile = today's output; profile photos byte-identical |
| API: variant store | extract `storeImageVariants(keyPrefix, buffer, profile)` from `attachment-photos.service.ts:137-168` (D2); `AttachmentPhotosService.upload` calls it with the default profile; ticket routes pass the ticket profile (variants `original`, `preview`) | behaviour-preserving for profile photos; guard with existing `attachment-photos.*.spec.ts` |
| API: presign-shape | helper: row to `EntityImageCover` (`toTicketCover`) with the flat-object fallback (D5, Q3 = A) *(amended 2026-10-28: was "row to `TicketImage`" via `toTicketImage`, now removed)* | old row: `thumbnailUrl = originalUrl = presigned fileName`, `placeholderDataUrl: null` |
| API: repository | `AttachmentsRepository.setCategory(attachmentId, category)`, tenant-scoped (D4) | `tcg-prisma-guardian` on this method |
| API: guard service | `TicketAttachmentGuardService.storeUpload` gains optional image path (`ticketId`, `group`): decode, store variants, set `placeholderDataUrl`, reject undecodable with an error (Q5 = A). Legacy flat path stays for callers that pass no `group` | keeps `clientUploadId` idempotency and `P2002` race path; all-or-nothing cleanup. Constructor gains `EntityImageProcessor`: update all four modules providing it |
| API: signatures | `ticket-signatures.service.ts`: `recordSignature` writes `category` via `setCategory` (sig1: `Customer First Signature`, `Customer First Identity Photo`; sig2: `Customer Last …`; compliance: `Compliance Signature` for both signature and identity photo); upload route passes `group: signatures`; `TicketSignatureResponse` gains `signatureImage`, `identityPhotoImage` (A1); bare ids kept (D6) | other step keys: category null (A4). `cleanupReplaced` unchanged |
| Mobile: component | new `components/field/attachment-image.tsx` (D7, D8): `expo-image`, no `Authorization` on `X-Amz-Signature` URLs, `localUri` first, blur beneath, one `onExpired` refetch | search all mobile `components/` dirs for an existing image component first; StyleSheet + `theme/tokens.ts` |
| Mobile: contracts | `ticket-signature.contract.ts`, its parser under `data/services/*`, `ticket-signatures.mock.ts`; reuse the `cover` zod schema from `identity.contract.ts:45-47`, which itself gains `originalUrl` (optional on the wire, falls back to `thumbnailUrl`) *(amended 2026-10-28: was "extended with `originalUrl` for `TicketImage`", a separate schema, now removed)* | additive optional fields |
| Mobile: display sites | `signature-capture-field.tsx`, `signer-capture.tsx` (optional `image` prop; callers that pass none keep the legacy path), `photo-preview-modal.tsx` (optional image prop), `Sig1Body.tsx`, `Sig2Body.tsx`, `ComplianceBody.tsx`, `signature-rehydrate.ts`; signature and identity photo show the 640 px **preview** (`thumbnailUrl`), the original only on zoom (D11) | `local:` / `file://` branches of `resolvePhotoUri` untouched |
| Shared (`packages/shared`) | new `constants/ticket-image.ts` (`TICKET_IMAGE_PREVIEW_SIZE = 640`, `TICKET_IMAGE_PREVIEW_WEBP_QUALITY = 80`, `TICKET_IMAGE_PLACEHOLDER_WIDTH = 32`, `TICKET_IMAGE_VARIANTS`), exported from the barrels; `EntityImageCover` gains `originalUrl` (A1, D11) *(amended 2026-10-28: was "new type `TicketImage` (A1, D11), both exported from the barrels; existing entity-image exports unchanged"; that type is removed)* | build `@tcg/shared` before `pnpm typecheck` |
| Category labels | five rows of the REQ-04 table + compliance labels per Q4 | strings exact, longest 29 chars |
| Key tree | `tenants/{t}/job-tickets/{ticketId}/signatures/{attachmentId}/{original,preview}.webp` | `ticketId` is `ticket.id` |
| Tests | not requested | run existing specs only |

### Reviewable as

- **Demo:** on iOS, run a field ticket through sig1 and sig2 with identity photos, and the
  compliance step. Each loads with no request to `…/attachments/:id/download` for display
  (proxy or API log). `GET /api/v1/field/tickets/:id/signatures` returns `signatureImage` and
  `identityPhotoImage` with presigned links beside the bare ids. Check the rows: `category`
  labelled, `placeholder_data_url` set, two `.webp` objects under the key tree.
- **Acceptance:** REQ-01 iOS acceptance (signature and identity sites); REQ-02 (signature responses, tracer clean); REQ-03 (placeholder set, two `.webp` objects); REQ-04 rows 1–5; REQ-07 (key has only tenant UUID, ticket UUID, `signatures`, generated UUID); REQ-08 for the migrated sites.
- **Reviewer can verify without:** U2–U5, seed data beyond one open ticket, a real tenant other than a test one.

### Risk

- **Weakest source:** `[UNVERIFIED]`
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no. Old rows are read through the D5 fallback; nothing rewritten (G2 not triggered).
- **Unverified plus costly to undo:** the D1 key tree and the label strings are written onto every new object and row; changing them later means rewriting data. D1 has no reviewer yet. It sits behind a pre-build gate, not a question. Settle by Haris reviewing D1 in spec §11b before U1 builds.
- **Blast radius:** every ticket signature upload now runs an image decoder on the request thread; a decode failure rejects an upload that used to succeed (A2). The extraction of `storeImageVariants` touches profile photos (specs guard it). The `TicketAttachmentGuardService` constructor change breaks DI in any module that omits `EntityImageProcessor`.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Profile photo upload and read (`AttachmentPhotosService`, web entity-photos, `/users/me` `cover`, `avatar.tsx`) | `buildEntityImageKey`, extracted `storeImageVariants` | existing `attachment-photos.{service,read,cover,delete}.spec.ts` via `pnpm api:test`; by hand: upload a profile picture, key still under `profile-pictures` | spec R9, D2, D10; `intent.md` §4 |
| Lunch, checklist, incident signature uploads that share `storeUpload` | `TicketAttachmentGuardService` constructor and `storeUpload` | upload one signature through each of the lunch, checklist and incident routes by hand: still succeeds through the legacy path | spec R5, R4, R3; D2 |
| `TicketSignatureResponse` and mobile `ticket-signature.contract.ts`, mocks, `Sig1Body`, `Sig2Body`, `ComplianceBody`, `SignatureBody.tsx` (fallback) | response fields `signatureAttachmentId`, `identityPhotoAttachmentId` (kept) | `tcg-contract-tracer`; `pnpm typecheck`; open the fallback `SignatureBody` step on a build with no `signatureImage` and confirm it still renders | spec R2; D6 |
| `SignatureCaptureField` callers in checklist; `SignerCapture` caller in lunch; `PhotoPreviewModal` callers in checklist and deficiency | shared component props | open each by hand (checklist signature, lunch WTL, deficiency preview): unchanged, because new props are optional | spec R1, R3, R4 |
| Offline queue (`sync/drain.ts`, `sync/verify.ts`, `local-attachments`, `capture.ts`) | rejected undecodable upload (A2); `local:` refs | read `drain.ts` for 4xx handling; capture offline, sync, confirm the photo loads from the presigned link | spec R7 (ASSUMED unchanged) — **the 4xx case has no source: if `drain.ts` retries forever, stop and add a spec §12 question** |
| Readers of `Attachment.category` (generic attachment code, `isPoInvoiceAttachmentCategory`, any web list) | new labels | run `grep -rn "\.category" apps/api/src/usecase/attachments apps/web/src` before starting (R12); labels do not match `isPoInvoiceAttachmentCategory` | spec R12 — enumeration not yet run |
| Readers of flat `Attachment.fileName` | key shape | `grep -rn "buildKey\|fileName" apps/api/src/usecase/attachments apps/api/src/usecase/ticket-*`; old rows unchanged | spec R13 |
| `GET /attachments/:id/download` | route | untouched; open one old signature by hand if the display fallback hits it | spec R11 |
| Web `ticket-progress` | separate `job-progress` response | `grep -rn "field/tickets" apps/web/src qa-automation` returns nothing; not edited | spec R10 |

**Gates:** `pnpm api:lint`, `pnpm api:build`, `pnpm api:test` (incl. existing `attachment-photos.*.spec.ts`), `pnpm --filter @tcg/shared build` then `pnpm typecheck`, mobile lint/test as the repo has them, `tcg-contract-tracer` on the signature response shape, `tcg-prisma-guardian` on `setCategory`, boot `pnpm api:dev` once (provider constructor changed in four modules: ticket-signatures, ticket-lunch-breaks, checklist-assignments, ticket-incidents).

### Deliberately not in this unit

- Checklist, incident and lunch WTL photo and signature display and labels — U2, U3, U4. (Their API routes still work through the legacy upload path meanwhile; that is a deferred slice, not a broken consumer.)
- Attach-File documents and image attachments — U5.
- Retiring the `attachmentId` to `/download` branch in `resolvePhotoUri` — U4, after the last image caller migrates.
- Sales quotation attachments, job artifacts — out of scope (Q1 = A).
- Backfill of old rows — excluded (Q3 = A).

---

## U2 — Checklist and deficiency photos, end to end

- **Outcome:** a crew member sees pre-trip, post-trip and JSA checklist photos, and checklist signatures, load from presigned links, and the rows are labelled by checklist type.
- **Kind:** vertical.
- **Requirements covered:** REQ-01, REQ-02 (checklist responses), REQ-03 (checklist upload route and checklist signature upload), REQ-04 (rows 6–8), REQ-07 (`checklist-photos`, plus `signatures` for the checklist signature), REQ-08 (checklist sites), REQ-11 (checklist signature to the checklist's own label).
- **Depends on:** U1
- **Branch / PR base:** `feat/MOBILE-TICKET-PRESIGNED-IMAGES-u2-checklist` stacked on U1's branch while its PR is open.
- **Size estimate:** ~600 source lines, ~14 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — none | |
| API | `checklist-assignments.service.ts`: item photo upload route passes `group: checklist-photos`; `submitAnswers` calls `setCategory` on each answer's `photoAttachmentId` (`Pre-Trip Checklist` via `submitPretrip`, `Post-Trip Checklist` via `submitPosttrip`, `JSA Checklist` via `submitJsa`); `saveChecklistSignature` passes `group: signatures` and labels the signature with its checklist's label (Q4); checklist read responses (`GET …/checklists/{pretrip,jsa,posttrip}`) gain `photoImage` per answer (and a signature image field for the checklist signature), `EntityImageCover` (A1) *(amended 2026-10-28: was `TicketImage`, now removed)*; bare `photoAttachmentId` kept | uses U1 helpers, no new helper |
| Web (`apps/web`) | N/A — no web call to `/field/tickets/*` (spec §5) | |
| Mobile | `checklist.contract.ts` + parser + checklist mocks; `checklist-rehydrate.ts`, `checklist-units.ts`, `ChecklistEngine.tsx`, `deficiency-panel.tsx`, `photo-thumb.tsx`, `photo-preview-modal.tsx` (checklist callers), the checklist `SignatureCaptureField` caller; render through `AttachmentImage`, `onExpired` refetches the checklist query | `local:` previews unchanged; thumbnails and previews use `thumbnailUrl` (640 px), full-screen uses `originalUrl` |
| Shared (`packages/shared`) | none | |
| Category labels | `Pre-Trip Checklist`, `Post-Trip Checklist`, `JSA Checklist` (photos and checklist signature) | |
| Key tree | `…/job-tickets/{ticketId}/checklist-photos/{attachmentId}/{variant}.webp` | |
| Tests | not requested | |

### Reviewable as

- **Demo:** on iOS submit a pre-trip with a deficiency photo; thumbnail and blur show, preview opens the original, no `/download` request for display. Check the row label after submit. Repeat for JSA and post-trip. Reopen a ticket submitted before this change and confirm the old photo still shows (fallback, Q3).
- **Acceptance:** REQ-01 (checklist and deficiency sites); REQ-02 (checklist responses, tracer clean); REQ-03 on the checklist route; REQ-04 rows 6–8; REQ-07; REQ-11 checklist signature.
- **Reviewer can verify without:** U3–U5.

### Risk

- **Weakest source:** `[UNVERIFIED]`
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Unverified plus costly to undo:** the same D1 and label considerations as U1; this unit adds three labels and one key group. Nothing new beyond U1's gate.
- **Blast radius:** `submitAnswers` gains a write per answer photo; a failure there must not lose the submit (executor: label write after the existing link, same transaction or tolerated failure, record which). Checklist screens on iOS.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Checklist read responses, `checklist.contract.ts`, `checklist-rehydrate.ts`, `checklist-units.ts`, `ChecklistEngine.tsx` | `photoAttachmentId` (kept) | `tcg-contract-tracer`; `pnpm typecheck`; open an existing submitted checklist on mobile | spec R3; D6 |
| Pre-trip, post-trip and JSA submit flows | `submitAnswers` | submit each type with and without a photo by hand; row labelled, submit unaffected | spec REQ-04 |
| Offline checklist photo capture and sync | `local:<id>` refs | capture offline, sync, photo loads from presigned link | spec R7 (ASSUMED unchanged) |
| Checklist photos uploaded before this change | D5 fallback | open one old checklist photo by hand | spec REQ-09 (Q3 = A) |
| Shared `PhotoThumb`, `PhotoPreviewModal`, `SignatureCaptureField` used by other units' screens | optional props from U1 | open the lunch WTL and incident screens by hand: still legacy-correct until U3, U4 | spec R1 |
| Web `ticket-progress` checklist results | separate `job-progress` response | not edited; grep in U1 | spec R10 |

**Gates:** `pnpm api:lint`, `pnpm api:build`, `pnpm api:test`, `pnpm --filter @tcg/shared build` then `pnpm typecheck`, mobile checks as in U1, `tcg-contract-tracer` on the checklist response shape. Provider constructors and modules are not changed (U1 did them): no `pnpm api:dev` boot required unless a module changes.

### Deliberately not in this unit

- Incident and lunch screens — U3, U4.
- Retiring the `/download` display branch — U4.

---

## U3 — Incident evidence and incident signature, end to end

- **Outcome:** a crew member sees incident photo evidence and the incident customer signature load from presigned links, and video evidence opens from a presigned link instead of the API stream.
- **Kind:** vertical.
- **Requirements covered:** REQ-01, REQ-02 (incident responses), REQ-03 (incident upload route; video excluded from variants by Q5 = A), REQ-04 (row 9), REQ-07 (`incident-evidence`, plus `signatures` for the incident signature), REQ-08 (incident sites), REQ-11 (incident signature to `Incident Evidence`).
- **Depends on:** U1 (stacked after U2 if U2's PR is still open; no code dependency on U2)
- **Branch / PR base:** `feat/MOBILE-TICKET-PRESIGNED-IMAGES-u3-incident` stacked on U1 (or U2) branch while open.
- **Size estimate:** ~550 source lines, ~12 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — none | |
| API | `ticket-incidents.service.ts`: `uploadAttachment` passes `group: incident-evidence` for `image/*` (variants, undecodable rejected) and stores non-image evidence as a plain file with a presigned link (Q5 = A), sets `category = Incident Evidence` directly (incident known at upload); `create` labels the linked customer signature `Incident Evidence` via `setCategory` (Q4); incident create/list responses gain `images: EntityImageCover[]` for evidence *(amended 2026-10-28: was `images: TicketImage[]`, now removed)*, a link field for video files, and a signature image field (names chosen by executor, D6 style, recorded in PR); bare ids kept | video key under `incident-evidence/` with a UUID name and extension, per D9 pattern |
| Web (`apps/web`) | N/A | |
| Mobile | `ticket-incident.contract.ts` + parser + `ticket-incidents.mock.ts`; `use-incident-report.ts`, `incident-sheet.tsx`, photo preview; evidence gallery and signature through `AttachmentImage`; video opens from the presigned link, with the existing path as fallback | find how video is shown today before changing (not in spec) |
| Shared (`packages/shared`) | none | |
| Category labels | `Incident Evidence` (evidence and incident signature) | |
| Key tree | `…/job-tickets/{ticketId}/incident-evidence/{attachmentId}/{variant}.webp`; video `…/incident-evidence/{uuid}.{ext}` | |
| Tests | not requested | |

### Reviewable as

- **Demo:** on iOS file an incident with photo evidence, a video, and a customer signature. Gallery thumbnails show with blur; the video opens with no `/download` request; labels set on the rows. An incident filed before this change still shows its photos.
- **Acceptance:** REQ-01 (incident sites); REQ-02 (incident responses, tracer clean); REQ-03 incident route; REQ-04 row 9; REQ-07; REQ-11 incident signature. Q5 = A: a corrupt image upload returns an error.
- **Reviewer can verify without:** U2, U4, U5.

### Risk

- **Weakest source:** `[UNVERIFIED]`
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Unverified plus costly to undo:** video evidence path is new and rests on Q5 = A (answered); the `incident-evidence` key group follows D1. No extra gate.
- **Blast radius:** incident filing is an emergency-adjacent flow; a rejected upload (Q5 = A) now blocks it where it did not. Ties to A2: confirm the queue behaviour recorded in U1.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Incident responses, `ticket-incident.contract.ts`, `use-incident-report.ts`, `incident-sheet.tsx`, mocks | evidence attachment ids and `signatureAttachmentId` (kept) | `tcg-contract-tracer`; `pnpm typecheck`; open an existing incident on mobile | spec R5; D6 |
| Video evidence display | `/download` stream | record a video incident by hand, open it, confirm it plays from the presigned link and the fallback still works offline | spec Q5 = A; R5 |
| Incidents filed before this change | D5 fallback | open one old incident by hand | spec REQ-09 (Q3 = A) |
| Web `ticket-progress` `step-bodies/incident.tsx` | separate `job-progress` response | not edited | spec R10 |
| Offline incident capture | `local:` refs | capture offline, sync, evidence loads | spec R7 (ASSUMED unchanged) |

**Gates:** `pnpm api:lint`, `pnpm api:build`, `pnpm api:test`, `pnpm --filter @tcg/shared build` then `pnpm typecheck`, mobile checks, `tcg-contract-tracer` on the incident response shape. No provider or module changed in this unit (U1 did): no boot unless one is.

### Deliberately not in this unit

- Lunch WTL and checklist screens — U4, U2.
- Video variants or transcoding — excluded (Q5 = A).

---

## U4 — Lunch worked-through signatures, end to end, and retire the display `/download` branch

- **Outcome:** a crew member sees lunch WTL signatures (and the optional WTL identity photo) load from presigned links, labelled `Lunch WTL 1`..`4`; after this unit no mobile ticket image display builds a `/download` URL.
- **Kind:** vertical.
- **Requirements covered:** REQ-01, REQ-02 (lunch responses), REQ-03 (lunch upload route), REQ-05, REQ-07 (`signatures`), REQ-08 (lunch site; whole-component acceptance), REQ-11 (WTL identity photo to its `Lunch WTL n` label).
- **Depends on:** U1; stacks after U3 so the `/download` display branch retires after every image caller (U2, U3 must be merged or stacked below it)
- **Branch / PR base:** `feat/MOBILE-TICKET-PRESIGNED-IMAGES-u4-lunch` stacked on U3's branch while open.
- **Size estimate:** ~450 source lines, ~10 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — none | |
| API | `ticket-lunch-breaks.service.ts`: upload route passes `group: signatures`; `recordWorkedThrough` (own path through `signaturesRepository.upsert`, not `recordSignature`) calls `setCategory` on the signature and on the optional `identityPhotoAttachmentId` with `Lunch WTL <breakIndex + 1>`; lunch responses gain signature and identity image fields (A1); bare ids kept | verify the zero-based `breakIndex` vs `wtlStepKeyFor` mapping in live code first (A5); do not add a fifth label, do not touch `MAX_LUNCH_BREAK_INDEX`; returned-ticket correction goes through the same method |
| Web (`apps/web`) | N/A | |
| Mobile | `ticket-lunch-break.contract.ts` + parser + `ticket-lunch-breaks.mock.ts`; `lunch-breaks.tsx` (`SignerCapture` caller), `lunch-windows.ts`, `use-lunch-corrections.ts`; then remove the `attachmentId` to `/download` display branch of `resolvePhotoUri` in `lib/attachments.ts` and the legacy path in migrated components | keep `file://`, `local:`, `data:` branches and `serverFallbackUri`; `/download` stays for documents' offline fallback (U5) and for artifacts/quotations (out of scope) |
| Shared (`packages/shared`) | none | |
| Category labels | `Lunch WTL 1`..`Lunch WTL 4` | REQ-05 is `[CONFLICT]` in the vault: takes no side on how many thresholds exist |
| Key tree | `…/job-tickets/{ticketId}/signatures/{attachmentId}/{variant}.webp` | |
| Tests | not requested | |

### Reviewable as

- **Demo:** on iOS record a worked-through lunch signature for break 1 and break 4; signature loads from a presigned link, row labelled `Lunch WTL 1` and `Lunch WTL 4`. `grep -rn "download" apps/mobile --include=*.ts --include=*.tsx` shows no display caller outside the document fallback and the out-of-scope artifact and quotation code.
- **Acceptance:** REQ-05 acceptance (label by `breakIndex + 1`, verified against live code); REQ-01, REQ-02, REQ-03, REQ-07 on the lunch route; REQ-08 acceptance (no site builds a `/download` URL for display).
- **Reviewer can verify without:** U2, U3 data, U5.

### Risk

- **Weakest source:** `[CONFLICT]` for REQ-05 (labels mirror a code cap and settle nothing); `[UNVERIFIED]` otherwise.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Unverified plus costly to undo:** four label strings on rows, chosen by the developer; if product later fixes the threshold count at three, the set is revised (spec REQ-05). No extra gate; no decision note needed unless product decides.
- **Blast radius:** lunch worked-through feeds payroll WTL capture; the label write must not disturb the upsert. Retiring the display branch breaks any caller missed in U1–U3.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Lunch responses, `ticket-lunch-break.contract.ts`, `lunch-breaks.tsx`, `lunch-windows.ts`, `use-lunch-corrections.ts`, mocks | signature and identity ids (kept) | `tcg-contract-tracer`; `pnpm typecheck`; open a ticket with a recorded lunch | spec R4; D6 |
| Taken lunch (no signature) and returned-ticket correction | `recordWorkedThrough`, TAKEN kind | record a taken lunch (no label written) and correct a returned ticket by hand | spec REQ-05 edges |
| Payroll WTL capture | same lunch rows | not edited; the label write is the only addition | `payroll/gaps.md#field-ops-lunch-capture-vs-payroll-wtl` (no side taken) |
| `resolvePhotoUri` display branch removal | `lib/attachments.ts`, `lib/index.ts` | `grep -rn "resolvePhotoUri\|/download" apps/mobile` shows only `local:`/`file://`/`data:` uses, the document fallback and out-of-scope code; open each earlier unit's screen once more | spec REQ-08 acceptance, R1 |
| Lunch signatures uploaded before this change | D5 fallback | open one old lunch signature by hand | spec REQ-09 (Q3 = A) |

**Gates:** `pnpm api:lint`, `pnpm api:build`, `pnpm api:test`, `pnpm --filter @tcg/shared build` then `pnpm typecheck`, mobile checks, `tcg-contract-tracer` on the lunch response shape. No provider or module changed in this unit.

### Deliberately not in this unit

- Three versus four lunch thresholds — product conflict, not ours (REQ-05).
- Documents' `/download` use — U5 keeps it as offline fallback.

---

## U5 — Attach-File documents open and share through a presigned link

- **Outcome:** a crew member opens and shares an Attach-File document from a presigned link with no API stream, new document uploads land in the per-ticket tree, and image attachments get thumbnails and blur.
- **Kind:** vertical.
- **Requirements covered:** REQ-06, REQ-02 (`GET …/attachments` rows), REQ-03 (image files sent through `…/attachments`; documents excluded), REQ-07 (`documents/` and `attachments` groups).
- **Depends on:** U1
- **Branch / PR base:** `feat/MOBILE-TICKET-PRESIGNED-IMAGES-u5-documents` from U1's branch (stacked) — not behind U2–U4.
- **Size estimate:** ~450 source lines, ~10 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — none | |
| API | `ticket-attachments.service.ts`: `upload` stores non-image files under `buildTicketFileKey` (`documents/{uuid}.{ext}`), and `image/*` through `storeImageVariants` in group `attachments` (A3; undecodable image rejected, Q5 = A); `listForTicket` rows gain a presigned download link for documents (D9, `presignGetUrl(fileName)`) and `EntityImageCover` for images *(amended 2026-10-28: was `TicketImage`, now removed)*; `category` unchanged (no label for documents); the constructor gains `EntityImageProcessor`, so update its module; `/download` route untouched | property names chosen by executor, D6 style, recorded in PR; `ticketId` (UUID) must be passed in: check `resolveTicketCode` |
| Web (`apps/web`) | N/A | |
| Mobile | `ticket-attachment.contract.ts` + parser; `ticket-attachments.http.ts` `download`; `ticket-attachment-file.ts` `openAttachmentFile` fetch/download the presigned link then `Sharing.shareAsync`, arraybuffer path as offline fallback; attachments sheet image rows through `AttachmentImage` | whether the shared file keeps its original name is the executor's call; record in PR |
| Shared (`packages/shared`) | none | |
| Category labels | none (documents keep `category` as-is) | |
| Key tree | `…/job-tickets/{ticketId}/documents/{uuid}.{ext}`; `…/attachments/{attachmentId}/{variant}.webp` | |
| Tests | not requested | |

### Reviewable as

- **Demo:** on iOS attach a PDF and a photo to a ticket, open and share the PDF: no request to `…/attachments/:attachmentId/download`; the photo shows thumbnail and blur. Put the device offline: the fallback path still opens a previously downloaded file or fails as it did before.
- **Acceptance:** REQ-06 acceptance (no `/download` request; the route still works); REQ-02 for the attachments list; REQ-07 keys.
- **Reviewer can verify without:** U2–U4.

### Risk

- **Weakest source:** `[UNVERIFIED]`
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no. Old documents resolve through their stored flat `fileName`.
- **Unverified plus costly to undo:** the `documents/` key tree follows D1 (reviewed in U1's gate). The new `attachments` image group (A3) is an AI decision; same exposure as D1.
- **Blast radius:** the attachments sheet and share flow; images sent with a non-image `mimetype` (client-supplied, untrusted) go to the document path.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `GET /field/tickets/:id/attachments`, `ticket-attachment.contract.ts`, `ticket-attachments.http.ts` | row shape (additive) | `tcg-contract-tracer`; `grep -rn "listAttachments" apps/api/src apps/mobile`; open the attachments sheet on a ticket with old and new files | spec R6; D6 |
| `openAttachmentFile` | arraybuffer download | open an old (flat key) document and a new one by hand; offline fallback exercised once | spec R8, REQ-06 edges |
| `GET /attachments/:id/download` and any web caller | route | untouched; `grep -rn "/download" apps/mobile apps/web/src` | spec R11 |
| Documents uploaded before this change | flat `fileName` | open one by hand | spec REQ-09 (Q3 = A), R13 |
| Generic attachment code treating `category` specially | not changed (no label written for documents) | N/A for this unit; R12 grep ran in U1 | spec R12 |
| Job artifacts, quotation attachments | share `/download` | not edited (Q1 = A); confirm `git diff --stat` touches neither | spec Q1 |

**Gates:** `pnpm api:lint`, `pnpm api:build`, `pnpm api:test`, `pnpm --filter @tcg/shared build` then `pnpm typecheck`, mobile checks, `tcg-contract-tracer` on the attachments row shape, boot `pnpm api:dev` once (provider constructor changes: `TicketAttachmentsService` module).

### Deliberately not in this unit

- Presigned upload (PUT): out of scope, `intent.md` §5.
- Sales quotation attachments and job artifacts: Q1 = A, follow-up ticket.

---

## Non-unit note — Haris-only follow-up (spec §11c F1, D3)

Write out a `patterns.md` P3 sub-shape entry for Haris (ticket images: multiple per ticket, no
`cover_attachment_id`, existing ticket-scoped upload routes, no `/attachments/photos`; reuse the
processor, `EntityImageCover`/`EntityImageListItem`, UUID-only keys under `job-tickets/{ticketId}/`).
*(Amended 2026-10-28, D11: ticket responses use `EntityImageCover` only, which now carries `originalUrl` on every cover.)*
`.ai/claude/**` is changed only when `git -C .ai config user.email` is `syed.haris@codingcops.com`.
Not a unit; no executor edits it. Also a follow-up ticket for REQ-10 (quotation attachments, job artifacts).

## Sequencing

```
U1 ──▶ U2 ──▶ U3 ──▶ U4
  └──▶ U5
```

- **Parallelisable:** U5 with U2–U4, in principle. U5 touches `ticket-attachments.*` (API and mobile), `ticket-attachment-file.ts`, `ticket-attachment.contract.ts` and one module. U2–U4 touch `checklist-assignments.*`, `ticket-incidents.*`, `ticket-lunch-breaks.*` and their mobile contracts. Possible shared file: `photo-thumb.tsx` / `photo-preview-modal.tsx` (check with `git grep -ln 'PhotoThumb' apps/mobile` before running U5 in parallel; if the attachments sheet uses it, serialise). No unit touches `schema.prisma`. U2, U3, U4 are sequential by default because they share `photo-preview-modal.tsx`, `signature-capture-field.tsx` / `signer-capture.tsx` props and, in U4, `lib/attachments.ts`.
- **Merge order constraint:** U1 first. U4 last among image units (it retires the `/download` display branch). No migrations in any unit.
- **Shared providers:** `TicketAttachmentGuardService` is provided in four modules (ticket-signatures, ticket-lunch-breaks, checklist-assignments, ticket-incidents; `grep -rn "TicketAttachmentGuardService" apps/api/src --include=*.module.ts`). U1 changes its constructor and updates all four; U2–U4 depend on U1 for that reason. `TicketAttachmentsService` (U5) is a separate provider: its constructor change is U5's own, and it is not in the guard's module list.
- **Cross-surface window:** none. Every response change is additive (D6); bare ids stay; mobile and API in the same unit. A mobile build older than a unit reads the old fields; an API older than a mobile build leaves the new optional fields absent, so the legacy path runs.
- **First unit to ship:** U1. It tests the two riskiest assumptions: that the image processor on the request path and the key tree work for ticket uploads (including DI across four modules, and the A2 rejection behaviour), and that presigned images load on iOS through the shared component, which was the original pain. Every later unit repeats the pattern on a different feature.
