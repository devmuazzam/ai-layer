# Spec — MOBILE-CERT-VIEW View and download certificates (mobile)

> Path A. Trello card #180, no Jira ticket. Decisions below are **developer decisions (haris,
> chat 2026-11-10), not client rulings.** Code facts read 2026-11-10; nothing was run.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `NOT ON JIRA` (Trello #180, working id `MOBILE-CERT-VIEW`) |
| Intent | `.ai/aidlc/MOBILE-CERT-VIEW/intent.md`, captured 2026-11-10 |
| Elaborated on | 2026-11-10 |
| Vault state at elaboration | Certification rules are unverified/reference; no vault page specifies a mobile certificate viewer. Mobile app topic is under open conflict (`field-ops/field-ops-mobile-INDEX.md`, 4.1 KB, 2026-08-10). Six `domain/` files verified; none relevant. |
| Open questions raised by this spec | 2 (Q1 resolved 2026-11-10; Q2 open, owner haris) |
| Already-shipped behaviour reached | 3 consumers in §11a; 0 with no source |
| Rules consulted | `.ai/claude/contexts/mobile.md` (48px targets, tokens), `.ai/claude/contexts/patterns.md` P3 (presigned links, no bearer to S3) as cited by `MOBILE-REMAINING-PRESIGNED-FILES/spec.md` |

Sources used in this spec:

- **S1** `[UNVERIFIED]` kind: developer decision, haris chat 2026-11-10 (Q1..Q5 of intent). Recorded in `intent.md` §4 (Q1, Q2, no-progress-tracking) and below (Q3, Q4, Q5).
- **S2** `decisions/2026-11-04-mobile-presigned-reads-viewers-approved-employee-files-owner-or-admin.md` — `[UNVERIFIED]` (status `reference`, requester direction, not a TCG client ruling) — kind: decision. Approves "View / Share Document" on the certifications screen and the owner-or-admin rule on `GET /attachments/:id/links`.
- **S3** `.ai/aidlc/MOBILE-REMAINING-PRESIGNED-FILES/spec.md` REQ-04 — `[UNVERIFIED]` — kind: prior spec. "Open an existing certification attachment when present; a certification with no document offers no broken file action. Distinguish certification entity IDs from Attachment IDs."
- **S4** `.ai/aidlc/FIELD-MENU-TRIM/spec.md` REQ-01 — `[UNVERIFIED]` — kind: prior spec (dev request). Field Menu keeps My Certifications as its only row.
- Trello card #180 text, as quoted in `intent.md` §2-3 — `[UNVERIFIED]`.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Employee sees only their own certificates | mobile / api | `[UNVERIFIED]` | S1, S2 | no |
| REQ-02 | One button opens, downloads or shares the document | mobile | `[UNVERIFIED]` | S1, S2, S3 | no (see Q1 for base) |
| REQ-03 | Certification with no document: disabled button plus message | mobile | `[UNVERIFIED]` | S1, S3 | no (see Q1 for base) |
| REQ-04 | The document opened belongs to the certification shown | api | `[UNVERIFIED]` | S1 | no |
| REQ-05 | A document that no longer exists shows a clear message | mobile | `[UNVERIFIED]` | S1 | no |

Counts: 5 total — 0 verified, 5 unverified, 0 conflicted, 0 open.

`field-ops-mobile-INDEX.md` conflict: it covers lunch, tickets, signatures, OTP and payroll
capture. None of the three candidates was found to specify a certificate viewer; the conflict
is not selected or merged here. Searched: `grep -rn -i certif` in the stub and its three
candidate INDEX files was **not run exhaustively** (see §13).

## 2. Requirements

### REQ-01 — Employee sees only their own certificates `[UNVERIFIED]`

- **Statement:** The logged-in employee sees and can open only their own certificates; there is no crew or office-staff certificate view in the mobile app, and certificates do not appear in progress tracking.
- **Surface:** mobile (existing screen), api (existing endpoints; no change expected).
- **Sources:**
  - S1 — `[UNVERIFIED]` — kind: developer decision, 2026-11-10: "employee certificates only; logged-in employee sees only their own; no crew or office-staff view; not in progress tracking". Asset/crane certificates out.
  - S2 — `[UNVERIFIED]` — kind: decision — Decision 2: employee-owned attachment links go only to the owning employee or ADMIN/SUPER_ADMIN; others get 404.
- **Conflict:** none (the mobile-app stub conflict does not cover certificates; not adjudicated).
- **Open question:** none.
- **Ripple:** none — behaviour already so. Established by: `git grep -n "getMyCertifications" -- apps/api/src` (callers: `me.controller.ts`, `me.service.ts`, `me.service.spec.ts`); `getMyCertifications` resolves the employee from the JWT `sub`, not from a request parameter (code, `apps/api/src/usecase/me/me.service.ts`). Unchanged.
- **Acceptance:** My Certifications lists only the logged-in employee's certificates. No new route, menu row or persona exposes anyone else's. Manual check on a real phone with two employees (card: "tested on a real phone").
- **Edges:**
  - **Reached by:** Menu > My Certifications (`apps/mobile/app/(field)/menu/certifications.tsx`) only. `FIELD-MENU-TRIM` (S4) leaves it as the sole Menu row.
  - **Does not apply when:** asset/crane certificates, crew view, office-staff view, web, progress tracking, renewal upload (all out, S1).
  - **When an input is absent:** a user with no linked employee gets `[]` today (`me.service.ts:46-48`) and the existing "No certifications on file" empty state. Unchanged.
  - **Trust boundary:** server-derived (JWT subject; S2 owner-or-admin check on the links route).
  - **Read time:** live.
- **Notes for the executor:** this is a confirm-and-preserve requirement. Do not widen the query.

### REQ-02 — One button opens, downloads or shares the document `[UNVERIFIED]`

- **Statement:** For a certification that has a document, a single button, labelled to cover view, download and share, opens the document by downloading it and handing it to the native share sheet.
- **Surface:** mobile.
- **Sources:**
  - S1 — `[UNVERIFIED]` — kind: developer decision, 2026-11-10. Q3: keep current behaviour, download then native share sheet via `openStoredAttachment` (`apps/mobile/lib/attachment-links.ts`); no in-app preview; no new dependency. Q5: single button renamed to cover view / download / share (example label "View / Download / Share"); no second button.
  - S2 — `[UNVERIFIED]` — kind: decision — Decision 1 approves the existing "View / Share Document" button.
  - S3 — `[UNVERIFIED]` — kind: prior spec — REQ-04 reuse of the native opener.
- **Conflict:** none.
- **Open question:** none. The exact label string is "e.g." in S1; the example is used as written (`ASSUMED — "View / Download / Share", from S1 example`).
- **Ripple:** label text and `testID` `certification-view-${cert.id}` are the only changed or kept surface. Established by: `git grep -n "View / Share Document\|certification-view-" fix/mobile-presigned-reads -- apps qa-automation packages` → one match, `certifications.tsx:166,169`; no test, no `qa-automation` reference. Label changes (S1); testID unchanged. Result for `main` HEAD: no match, because the feature is not on `main` (see Q1).
- **Acceptance:** On a real phone, tapping the button on a certificate with a document downloads it and opens the OS share sheet; from there the user can view, save or send it. Button text covers view / download / share. No second button, no in-app preview, no new package in `apps/mobile/package.json`. Failure shows the existing toast "Could not open the certificate. Please try again." (code on `fix/mobile-presigned-reads`, evidence only).
- **Edges:**
  - **Reached by:** the button's `onPress` only → `openStoredAttachment(cert.attachmentId)` → `GET /attachments/:id/links` → S3 download → `shareDownloadedAttachment`.
  - **Does not apply when:** no `attachmentId` (REQ-03); renewal upload flow (separate button, unchanged).
  - **When an input is absent:** `attachmentId` absent → REQ-03.
  - **Trust boundary:** API issues presigned URLs; S3 request carries no bearer token (patterns P3 via S3 spec); owner-or-admin enforced server-side (S2).
  - **Read time:** live; links are transient, never stored.
- **Notes for the executor:** change the string in `certifications.tsx` only. Do not touch `attachment-links.ts` or the controller. Keep the loading label "Opening document…" unless a developer edits it (`ASSUMED` — unchanged copy).

### REQ-03 — Certification with no document: disabled button plus message `[UNVERIFIED]`

- **Statement:** A certification without a document shows the same button disabled, plus the line "No document on file".
- **Surface:** mobile.
- **Sources:**
  - S1 — `[UNVERIFIED]` — kind: developer decision, 2026-11-10. Q4: certification without `attachmentId` shows the 'View / Share Document' button DISABLED plus the line 'No document on file'. (Per Q5 the button carries the renamed label from REQ-02; S1 Q4 used the old name. `ASSUMED` — the renamed label applies, because Q5 renamed the one button.)
  - S3 — `[UNVERIFIED]` — kind: prior spec — "no document offers no broken file action". Card: "A missing certificate shows a clear message."
  - Trello card #180 — `[UNVERIFIED]`.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** on `fix/mobile-presigned-reads` the footer is rendered only when `attachmentId` is set (`certifications.tsx:159`); after this change every card has the footer. Card height grows for no-document cards. Nothing else consumes it: `menu.tsx` reads `useCertifications` for a badge count only (`git grep -n useCertifications fix/mobile-presigned-reads -- apps/mobile`). Badge logic unchanged.
- **Acceptance:** For a certification with no `attachmentId`, the button renders disabled (`Button disabled`, supported: `design-system/primitives/button.tsx:33`), and "No document on file" shows on the card. Pressing does nothing and fires no request. The "Upload Renewal" button on expiring/expired cards is unchanged. The disabled button meets the 48px target rule (`mobile.md`).
- **Edges:**
  - **Reached by:** any card rendered by `CertificationCard`.
  - **Does not apply when:** certification has `attachmentId`.
  - **When an input is absent:** `attachmentId` is `undefined` (JSON key omitted by the API, optional in the zod contract) → this requirement.
  - **Trust boundary:** server decides presence of `attachmentId`; client does not infer it.
  - **Read time:** live.
- **Notes for the executor:** colours from theme tokens (`colors.textTertiary`, as other muted text in the file); placement and spacing of the "No document on file" line are `ASSUMED — directly under or beside the disabled button, nearest existing footer pattern`. A no-document expiring card carries two footers (disabled button and Upload Renewal); stacking order `ASSUMED` — document button first, as on cards with a document.

### REQ-04 — The document opened belongs to the certification shown `[UNVERIFIED]`

- **Statement:** In `GET /me/certifications`, a certification's `attachmentId` is the attachment of the row shown on the card, not the newest attachment that happens to share its name.
- **Surface:** api (`apps/api/src/usecase/me/me.service.ts`, `getMyCertifications`).
- **Sources:**
  - S1 — `[UNVERIFIED]` — kind: developer decision, haris chat 2026-11-10: fix the name-collision risk in this ticket.
- **Conflict:** none.
- **Notes for the executor:** today `documentsByName` keeps the newest attachment per lower-cased name, while the dedupe keeps the row with the latest expiry, so the expiry and the document can come from different rows of one employee. Cannot cross employees: `employeeAttachmentWhere` scopes the query to the caller. Response shape does not change (`attachmentId` already optional), so no G5 contract trace. See D6.

### REQ-05 — A document that no longer exists shows a clear message `[UNVERIFIED]`

- **Statement:** When opening a certification's document fails because the document is gone, the app shows "This document is no longer available" instead of the generic "Could not open the certificate. Please try again."
- **Surface:** mobile (`certifications.tsx` `openDocument` catch; `attachment-links.ts` if the error needs to be typed).
- **Sources:**
  - S1 — `[UNVERIFIED]` — kind: developer decision, haris chat 2026-11-10: add the missing-file message. The message text is the AI's wording (`ASSUMED`), for review.
- **Conflict:** none.
- **Notes for the executor:** two failure points. (1) `GET /attachments/:id/links` answers 404 when the attachment row is missing or not the caller's: detect `status === 404` from the axios error. (2) The presigned S3 GET for a deleted object: presigning never checks existence (`s3-storage.service.ts:77`), and `File.downloadFileAsync` throws on non-2xx (`ticket-attachment-file.ts:129`). Whether that error carries the HTTP status is **not verified**: inspect it first. If it cannot be told apart from a network failure, keep the generic message for (2) and say so in the PR; never show "no longer available" for a plain network error. The one retry in `openStoredAttachment` stays.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no
- **Migration required:** no
- **Data backfill required:** no
- **Existing models considered:** `EmployeeCertification` and `Attachment` already hold the data (`me.repository.ts:findCertificationsData`). No new model or column.

## 4. API surface — `apps/api`

- **Pattern:** none. One logic change in `getMyCertifications` for REQ-04; response shape unchanged.
- **Existing functions/services to reuse:** `MeService.getMyCertifications` (`apps/api/src/usecase/me/me.service.ts`), `MeRepository.findCertificationsData` (`apps/api/src/service/me/me.repository.ts`), `GET /attachments/:id/links` (`attachments.controller.ts`).
- **New exported functions/services proposed:** none.

State verified about the contract (see §11b D1 and §13 for what was not verified): on `fix/mobile-presigned-reads` the response carries an optional `attachmentId` per certification (`me.service.ts:131`, `certifications.contract.ts:5`), added only when a name-matched attachment row exists. **On `main` (this worktree) the field does not exist** and neither does `attachment-links.ts` or the `:id/links` route.

## 5. Web surface — `apps/web`

N/A — out of scope (intent §6).

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `app/(field)/menu/certifications.tsx` only.
- **Components:** existing `Button`, `Card`, `Text` from `@/design-system`; no new component.
- **Offline / sync behavior:** NOT SPECIFIED. The current open path needs a network connection; this ticket does not change it.
- **Touch targets:** 48px (`mobile.md`).
- **Push / notifications involvement:** N/A.

## 7. Shared package — `packages/shared`

N/A — no change. The contract lives in `apps/mobile/data/contracts/certifications.contract.ts`, not in `packages/shared`.

## 8. Permissions and tenancy

- **Roles permitted:** logged-in employee, own certificates (S1); ADMIN/SUPER_ADMIN may open any employee file via the API (S2) but the mobile screen lists only the caller's own.
- **Roles denied:** crew, office staff — no mobile view (S1).
- **Tenant isolation:** standard; `getMyCertifications` passes `tenantCompanyId` explicitly.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Button label | "View / Download / Share" (example) | S1 | `[UNVERIFIED]` |
| Missing-document line | "No document on file" | S1 | `[UNVERIFIED]` |
| Max lengths, file types, file size | NOT SPECIFIED | — | — |

## 10. Tests

`not requested` (root `CLAUDE.md`; no tests asked). Run the existing suites only; the existing `certifications.test.tsx` on `fix/mobile-presigned-reads` has no reference to the button label.

- Requirements with no automated acceptance: all three; acceptance is a manual check on a real phone (card: "Done when tested on a real phone").

## 11. Non-functional

- **Performance:** NOT SPECIFIED
- **Concurrency:** N/A
- **Audit / activity log:** N/A — no new logging requested.
- **Migration/rollout order:** mobile only, after Q1 is settled (base branch). API unchanged.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `certifications.tsx` view button (label, testID) | label string | REQ-02 | label changes, testID kept | S1 | `git grep -n "View / Share Document\|certification-view-" fix/mobile-presigned-reads -- apps qa-automation packages` |
| `CertificationCard` footer layout | footer now always rendered | REQ-03 | changes deliberately | S1 | read of `certifications.tsx:159-186` on `fix/mobile-presigned-reads` |
| `menu.tsx` badge, `menu.test.tsx` | `useCertifications` | REQ-03 | unchanged (reads status only) | S4 | `git grep -n useCertifications fix/mobile-presigned-reads -- apps/mobile` |

- **Surfaces with no existing behaviour in this area:** `main` has no document-open path at all (`git grep -n openStoredAttachment` returns nothing in `apps/mobile` on this branch; grep run and empty).
- **Consumers with no source for what happens to them:** none.

## 11b. AI decisions — reviewed by a developer

| ID | Decision | Chosen | Why / alternatives (with existing code found) | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | How the app knows which certifications have no document | Use the existing optional `attachmentId` field; absent means no document. No API change, no new flag. | `me.service.ts` adds `attachmentId` only when an attachment matched the name; zod field is `.optional()`. Rejected adding a `hasDocument` boolean (extra field, response-shape change, G5 contract-tracer, no gain). | no | | haris | 2026-11-10 |
| D2 | Where the change lives | Edit `CertificationCard` in `certifications.tsx` only. | Button, `openDocument`, toast and `loading` state already exist on `fix/mobile-presigned-reads`. Rejected a new component (no second use). | no | | haris | 2026-11-10 |
| D3 | Disabled rendering | Reuse `Button` `disabled` prop plus a `Text` line using `styles.meta`-style token colours. | `design-system/primitives/button.tsx:33`. Rejected a custom pressable. | no | | haris | 2026-11-10 |
| D4 | No-document state when `isLoading`/open in flight | Leave the `opening` guard as it is (`if (!cert.attachmentId \|\| opening) return`). | Already blocks double-taps. | no | | haris | 2026-11-10 |
| D5 | Base for the work | `origin/staging` (decided by haris, Q1, 2026-11-10). | `git merge-base --is-ancestor origin/fix/mobile-presigned-reads origin/staging` → true; `attachment-links.ts` present on staging, absent on main. Branch reset to `origin/staging` (`fa83fe40f`). | no | haris | 2026-11-10 |
| D6 | Document-to-row link (REQ-04) | Use the winning row's own attachment id when the winner is an attachment row. When the winner is a name-and-expiry-only row (`dbCerts`), keep the newest same-name attachment as a fallback. Response shape unchanged. Added after analysis (2026-11-10, haris yes): equal-expiry and both-null ties between two attachment rows go to the newest upload, then the highest id, so the result does not depend on DB row order (commit 8bc848789). | `me.service.ts` reads: `documentsByName` vs the dedupe by latest expiry. Rejected dropping the fallback (name-only rows would lose a document they show today, a visible behaviour change). Rejected linking by new column (schema change, no gain). | no | | haris | 2026-11-10 |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Reviewed by | Enumerated by |
| --- | --- | --- | --- | --- |
| Quotation attachment cards, job artifacts, job-walk signatures (other "open stored file" buttons) | none (shared `openStoredAttachment`) | no — label and no-document rule decided for certificates only (S1); follow-up if wanted | | `git grep -n openStoredAttachment fix/mobile-presigned-reads -- apps/mobile` (not re-run for all call sites; list from `analysis-pr-1018.md`) |

## 12. Open questions — the stop-and-ask list

Everything the five developer decisions covered is answered. Q1 (sequencing) is resolved; Q2 (deleted S3 object message) is open.

### Q1 — Base branch for the code this ticket edits

- **Question:** `openStoredAttachment`, `GET /attachments/:id/links`, the `attachmentId` field and the current "View / Share Document" button exist only on unmerged branches (`fix/mobile-presigned-reads`, `fix/strict-ticket-presigned-attachments`, PR #1018 area), not on `main` or this worktree's base. Which base should this ticket build on?
- **Options:**
  - A. Wait until the presigned-reads branch is merged to `main`, then rebase this ticket's branch.
  - B. Stack this ticket's branch on `fix/mobile-presigned-reads`.
  - C. Stack on `fix/strict-ticket-presigned-attachments`.
  - X. Other — say what
- **Answer:** Other — rebase onto `origin/staging` (haris, 2026-11-10). PR targets staging; it can reach main only after the presigned-reads work does.
- **Why it cannot be answered from what is written:** checked `git ls-tree`/`git grep` on both branches and `main`; both branches contain the files, `main` does not; `gh pr view 1018` failed (not authenticated), so PR state was not checked. Which branch is going to merge is not written anywhere I read.
- **Blocked:** REQ-02, REQ-03 cannot start building on this worktree's current base.
- **Candidates:** `.ai/aidlc/MOBILE-REMAINING-PRESIGNED-FILES/spec.md` (22 KB, 2026-11-03), `analysis-pr-1018.md`, `vault/decisions/2026-11-04-mobile-presigned-reads-viewers-approved-employee-files-owner-or-admin.md`; branch tips `fix/mobile-presigned-reads` 350dad0da (2026-11-04), `fix/strict-ticket-presigned-attachments` 1e4e375b5 (2026-11-06).
- **Owner:** haris (developer)
- **Workaround, if any:** none needed to proceed with the spec; build waits on the answer.
- **Status:** resolved — see decisions/2026-11-10-mobile-certificate-view-developer-decisions.md

### Q2 — Can the app tell a deleted S3 object from a network failure?

- **Question:** REQ-05 shows "This document is no longer available" only for a 404 on `GET /attachments/:id/links`. When the presigned S3 GET fails because the object is gone, `File.downloadFileAsync` puts the status only in the error message string, so that path keeps the generic "Could not open the certificate. Please try again." Should that path also say "no longer available" (for example by parsing the message or by checking object existence in the links route)?
- **Options:**
  - A. Keep the generic toast for the S3 path (current, shipped in PR #1063).
  - B. Parse the status from the `expo-file-system` error message in the opener.
  - C. Have `GET /attachments/:id/links` verify the object exists before presigning.
  - X. Other — say what
- **Why it cannot be answered from what is written:** the spec asked to inspect the error first and keep the generic message if it carried no status; it carried none. Option B or C changes the shared opener or a shared API route (spec §11c siblings).
- **Blocked:** nothing; follow-up only.
- **Owner:** haris (developer)
- **Status:** open (raised by the reflector, 2026-11-11)

## 13. What this spec deliberately does not specify

- In-app preview, a separate download action, pinch-zoom: out by S1 (Q3, Q5).
- Asset/crane certificates, crew and office-staff views, progress tracking, web: out by S1.
- Expiry thresholds and the renewal-upload flow: out of scope (intent §6), unchanged.
- Offline behaviour: NOT SPECIFIED.
- Exact copy for the disabled-button helper placement and spacing: `ASSUMED`, REQ-03.
- Not verified:
  - Whether `attachmentId` can be absent for any case other than "certification row with no name-matched attachment". Read from code: attachment-derived rows always get a document id and only `dbCerts` (name plus expiry only) can lack a match, so `dbCerts` without a same-named attachment is the only no-file case I found. That is the code as read on `fix/mobile-presigned-reads`; not run, and the code is not a source of intent.
  - Name matching is by lower-cased trimmed name, so a `dbCerts` row can show another attachment's document when names collide. Whether that is wanted is not specified anywhere; flagged, not raised as a question because the developer's decisions do not touch it.
  - Whether a document whose S3 object is missing or whose link call returns 404 shows the generic error toast only. Not run.
  - PR #1018 merge state (`gh` not authenticated).
  - Field-ops mobile FRDs searched for certificate-viewer requirements: not read exhaustively; the stub was read, the three candidate INDEX files were not.
  - No device run.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [x] Every `[CONFLICT]` (none) requirement has a decision note in `.ai/vault/decisions/`
- [x] Answers written back into `spec.md` with their new sources and flags
- [S] Every §12 question updated — Q1 resolved — see `vault/decisions/2026-11-10-mobile-certificate-view-developer-decisions.md` (a developer decision, not a client ruling)
- [x] Every requirement's **Edges** fields are filled (`ASSUMED` allowed) or point at a §12 question
- [x] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [x] A developer has reviewed §11b and §11c (_Reviewed by_), and answered every `needs developer` row
- [x] Decomposed into vertical units — `units.md`

Answered by: haris (via chat)  Date: 2026-11-10
