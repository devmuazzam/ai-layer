# Units — MOBILE-CERT-VIEW View and download certificates (mobile)

> Written 2026-11-10 from the signed-off `spec.md` (§14 signed by haris, 2026-11-10). Path A, Trello #180, no Jira ticket.
> Base for every unit: `origin/staging` (spec D5 / Q1). PRs target `staging`.

## Gate baseline

**Gate baseline:** *2026-11-10, `origin/staging` at `fa83fe40f` — U1 (`@tcg/api`, executor, after `pnpm install`): `pnpm api:lint` pass, `@tcg/api:build` pass, `me` jest 4 passed. U2 (`@tcg/mobile`, executor, untouched base): typecheck pass, lint pass, jest certifications+menu 28 passed. After the changes: see state.md Resume.* (Original note: NOT RUN.) The worktree has no `node_modules` (`ls node_modules` fails), so lint, typecheck, build and test were not run and no number is copied from `CLAUDE.md`. Each executor runs `pnpm install` in the worktree, then lint, typecheck, build and test on the untouched base (`@tcg/api` for U1, `@tcg/mobile` for U2), writes the result here, and only then reports its gates against it.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | The document a certificate card opens is the one on the row the card shows, not the newest same-named upload | REQ-04 (REQ-01 preserved, no change) | api | — | ~15 lines / 1 file | merged — PR #1062 |
| U2 | Certificate screen: one "View / Download / Share" button, disabled with "No document on file" when none, and "This document is no longer available" when the file is gone | REQ-02, REQ-03, REQ-05 | mobile | — | ~50 lines / 1-2 files | merged — PR #1063 |

- **Status** takes exactly one of: `not started` · `in progress — <branch>` · `built — <branch>` · `merged — PR #<n>` · `cut — <reason>`. Never a commit SHA.
- Requirements covered: REQ-01..REQ-05, counted against `spec.md` §2 on 2026-11-10: **5 in spec, 5 in ledger.** REQ-01 is confirm-and-preserve: no unit changes it, both units must not widen the query or add a view (the check is in each unit's Ripple). Not covered: none.
- Units blocked on an open question: none. Spec Q1 is answered (base `origin/staging`). No `[OPEN]` requirement exists.
- One unit or two: two. One merged unit would also ship alone, but it would mix an API ranking change with a mobile UI change in one PR, and U1 is the only part with a data-behaviour risk. Neither depends on the other: the mobile screen reads the already-optional `attachmentId` either way. Both are small; if the developer prefers one PR, merge U1 into U2 with no other change.

---

## U1 — Certificate card opens its own row's document

- **Outcome:** An employee who has two same-named certificate uploads (for example an older one with the later expiry) taps the card and gets the document for the row the card shows, not the newest upload of that name.
- **Kind:** vertical (api only; the existing mobile button is the consumer, so the change is visible without U2)
- **Requirements covered:** REQ-04 fully. REQ-01 preserved (no change).
- **Depends on:** —
- **Branch / PR base:** `feat/MOBILE-CERT-VIEW-u1-view-download` from `origin/staging` (this worktree's branch). One unit, one branch, one PR. Not stacked.
- **Size estimate:** ~15 source lines, 1 source file (`apps/api/src/usecase/me/me.service.ts`).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | No schema change (spec §3). |
| API (`apps/api`) | `MeService.getMyCertifications`: the final map links `attachmentId` to the winning row's own id when the winner came from an attachment row (the combined entry's `id` is `att.id`). When the winner is a `dbCerts` row (name and expiry only), keep today's `documentsByName` newest-same-name lookup as the fallback. | D6. `me.service.ts`, the final `uniqueCerts.map` and the combined list. To tell winner source, mark combined entries from attachments (for example a local `attachmentId` field on the combined entry); local type only, response shape unchanged. |
| Web (`apps/web`) | N/A | Out of scope (intent §6). |
| Mobile (`apps/mobile`) | N/A | Consumer unchanged; contract already has optional `attachmentId`. |
| Shared (`packages/shared`) | N/A | |
| Tests | not requested | Run the existing `me.service.spec.ts` only. |

### Reviewable as

- **Demo:** As an employee with two attachments of the same certificate name, different expiries (older upload has the later expiry), call `GET /me/certifications` with that employee's token. The `attachmentId` returned equals the later-expiry row's attachment id. Before: it equalled the newest upload.
- **Acceptance:** REQ-04 statement. Also: a `dbCerts`-only winner with a same-named attachment still returns that attachment's id (D6 fallback); a `dbCerts` winner with no same-named attachment still omits `attachmentId`.
- **Reviewer can verify without:** U2, a device, S3. Response is checked as JSON.

### Risk

- **Weakest source:** `[UNVERIFIED]` — S1 developer decision, no vault page.
- **Migration reversible:** yes — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no — read path only.
- **Blast radius:** wrong logic opens the wrong document under a certificate's name. Cannot cross employees (`employeeAttachmentWhere` scopes to caller). Not irreversible, so the `[UNVERIFIED]` plus irreversible rule does not fire.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `GET /me/certifications` callers: `apps/mobile/data/services/certifications/certifications.http.ts`, `use-certifications.ts`, `menu.tsx` badge, `certifications.tsx` | response `attachmentId` value (shape unchanged) | Existing `me.service.spec.ts` run; by hand, list the screen for an employee with one document per name and confirm the same document opens as before. | `spec.md` REQ-04, D6 |
| Employee scoping (REQ-01) | `getMyCertifications` JWT subject, `employeeAttachmentWhere` | Query not touched; diff shows no change to `findCertificationsData` or the `user` lookup. | `spec.md` REQ-01 |
| Other callers of `getMyCertifications` | `me.controller.ts`, `me.service.spec.ts` | `git grep -n getMyCertifications -- apps/api/src` run during this decomposition: only those two plus the service. | `spec.md` REQ-01 Ripple |

### Deliberately not in this unit

- Any button, label or message change — lands in U2.
- Changing name-based matching or dedupe rules beyond the winner link — not requested (spec §13).

---

## U2 — Certificate screen label, no-document state, gone-document message

- **Outcome:** On My Certifications an employee sees a "View / Download / Share" button on every card; for a certificate without a document it is disabled with "No document on file"; if the file is gone, tapping shows "This document is no longer available".
- **Kind:** vertical (mobile only; the API already supplies the optional `attachmentId`)
- **Requirements covered:** REQ-02, REQ-03, REQ-05 fully. REQ-01 preserved (no change).
- **Depends on:** — (independent of U1; reads the same optional field either way)
- **Branch / PR base:** `feat/MOBILE-CERT-VIEW-u2-mobile-states` from `origin/staging`. One unit, one branch, one PR. Not stacked on U1.
- **Size estimate:** ~50 source lines, 1-2 source files (`apps/mobile/app/(field)/menu/certifications.tsx`; `apps/mobile/lib/attachment-links.ts` only if the 404 error must be typed, and only if REQ-05 needs it).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | N/A | `GET /attachments/:id/links` untouched. |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | `CertificationCard` in `certifications.tsx`. (a) REQ-02: button text `View / Download / Share` (loading text "Opening document…" kept; testID `certification-view-${cert.id}` kept). (b) REQ-03: always render the document footer; `Button disabled` when `!cert.attachmentId`, plus `Text` "No document on file" in `colors.textTertiary`, placed under the button, document button above Upload Renewal; 48px target. (c) REQ-05: in the `openDocument` catch, show "This document is no longer available" for a 404 from `GET /attachments/:id/links`; keep the generic toast for everything else. | D2, D3, D4. `Button` disabled prop at `design-system/primitives/button.tsx:33`. No new component, no new package. |
| Shared (`packages/shared`) | N/A | |
| Tests | not requested | Run existing mobile jest (`certifications.test.tsx`, `menu.test.tsx`, `use-certifications.test.tsx`) only. |

### Reviewable as

- **Demo:** On a real phone as an employee with at least one certificate with a document and one without: Menu > My Certifications. With document: button reads "View / Download / Share", tap opens the OS share sheet. Without: button disabled, "No document on file" shows, tap does nothing and fires no request. Expiring card with no document shows both footers. For REQ-05, point a card at a deleted attachment (404 on the links call) and tap: "This document is no longer available".
- **Acceptance:** REQ-02, REQ-03, REQ-05 acceptance lines. REQ-05 edge (2), the S3 object missing after presign: inspect the error thrown by `File.downloadFileAsync` first. If it carries no HTTP status, keep the generic message for that path and say so in the PR. Never show "no longer available" for a plain network error. The wording is AI-proposed (`ASSUMED`), for review.
- **Reviewer can verify without:** U1 and its API change; a seeded 404 case needs one attachment id that does not exist (or deleted row), or can be verified by reading the catch branch if no device is at hand (say which in the PR).

### Risk

- **Weakest source:** `[UNVERIFIED]` — S1 developer decisions, S2/S3 reference-level.
- **Migration reversible:** yes — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** wrong 404 detection could hide a real failure behind "no longer available" (mitigated by detecting status 404 only). Footer now renders on every card: layout change for no-document cards. Not irreversible.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `certifications.tsx` view button (label, testID) | label string | `git grep -n "View / Share Document\|certification-view-" -- apps qa-automation packages` on `origin/staging`: re-run by executor; spec found one match, no test or qa reference. Existing `certifications.test.tsx` run. | `spec.md` REQ-02, §11a |
| `CertificationCard` footer layout | footer always rendered | Screen check on a device: card with document, card without, expiring card without. | `spec.md` REQ-03, §11a |
| `menu.tsx` badge, `menu.test.tsx` | `useCertifications` | Existing `menu.test.tsx` run; badge reads status only, untouched. | `spec.md` §11a (S4) |
| `openStoredAttachment` other call sites (quotation, job artifacts, job-walk signatures) | `lib/attachment-links.ts` | If the error is typed in `attachment-links.ts`, behaviour for other callers must not change: the executor greps `git grep -n openStoredAttachment -- apps/mobile` and checks each caller still gets the same thrown error unless it opts in. Prefer detecting 404 in `certifications.tsx` only. | `spec.md` REQ-02 notes, §11c |
| Employee-only scope (REQ-01) | route, menu | No new route, menu row or persona added; manual check with two employees on a phone. | `spec.md` REQ-01 |

### Deliberately not in this unit

- The document-to-row link fix — lands in U1.
- Same label or no-document rule on other "open stored file" buttons — follow-up if wanted (spec §11c).
- In-app preview, separate download action — out by S1.

---

## Sequencing

```
U1   (api)
U2   (mobile)
```

- **Parallelisable:** yes. U1 touches only `apps/api/src/usecase/me/me.service.ts`. U2 touches only `apps/mobile/app/(field)/menu/certifications.tsx` (and possibly `apps/mobile/lib/attachment-links.ts`). No shared file, table, provider or `packages/shared` export. The response shape is unchanged, so no cross-surface window exists.
- **Merge order constraint:** none. No migration.
- **First unit to ship:** U1 is the riskier assumption (changes which document opens); it proves the winner-link logic with a one-request demo. U2 can go first or in parallel without affecting it. Real-phone test across both is still owed before merge (card: "Done when tested on a real phone").
