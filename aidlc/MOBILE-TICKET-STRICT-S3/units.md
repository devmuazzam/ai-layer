# Units — MOBILE-TICKET-STRICT-S3: strict ticket attachment hierarchy

Written by tcg-decomposer on 2026-11-05 from the five requester-sourced requirements in
`spec.md`. Application changes already present are provisional; this plan does not accept
them as complete. Executor reconciliation and independent analysis remain required.

## What a unit is

A vertical slice delivers a reviewable behavior across its affected surfaces. Here, strict
ticket storage, removal of the API streaming route and mobile fresh-link access belong in
one unit: shipping only the server removal would break its existing mobile consumer.

## Fill rules

Every required unit field is present below. No unit depends on an open requirement; no new
requirement or test case is introduced by decomposition. Each unit is one branch and one PR
if publishing is subsequently requested; current authorization ends at local implementation.

## Gate baseline

**Gate baseline:** 2026-11-05, `origin/main` at
`09a11fea717240ff7077679fad9ba4085c57027f`: full lint/typecheck/build/test baseline **not
measured**. Do not describe the following as an origin/main baseline. This branch is
intentionally based on `origin/staging`/clean HEAD at
`2d523af27c55ba13dc9d2ed5c915e4ee5843deb8`, which contains the original attachment migration
absent from main; rebasing to main during this unit would remove the feature being refined.

Actual inspected provisional run evidence, supplied by the coordinator and read by the
decomposer (not independently rerun at this planning stage):

| Gate | Observed result | Evidence and limits |
| --- | --- | --- |
| `pnpm api:test` | FAIL: 313 suites / 3663 tests pass; 1 suite / 1 test fails | `/tmp/ticket-api-test-verified.log`; sole failure `payroll-open-flags-gate.spec.ts:403` |
| Clean HEAD payroll reproduction | FAIL: same payroll case; 15 other cases pass | `/tmp/ticket-api-payroll-baseline.log`, clean archive `/tmp/ticket-attachment-baseline`; this proves the isolated failure predates the attachment diff, not that full baseline gates passed |
| `pnpm lint` | PASS for all 5 projects, 0 errors | `/tmp/ticket-lint-final.log`; warnings do not establish a clean test/typecheck result |
| `pnpm typecheck` | FAIL: only `apps/mobile/lib/app-version.test.ts:71,83`, TS2345 | `/tmp/ticket-typecheck-verified.log`; existing unchanged cases, web passes; executor/analyst must preserve baseline evidence |
| `pnpm api:build` | PASS | `/tmp/ticket-api-build.log`; full workspace build not measured by this evidence |
| Targeted existing mobile tests | PASS: 4 suites / 67 tests | `/tmp/ticket-mobile-test-final.log`; sheet, file helper, HTTP service and mock suites |

The requested acceptance criterion 4 remains **UNFULFILLED**: no waiver was granted. Passing
attachment-focused checks does not turn failing full API/typecheck commands green. Do not
silently expand this PR into unrelated payroll or app-version repairs. Any fresh edit or
newly discovered failure requires relevant verification; otherwise inspect the established
logs and avoid repeating unchanged long runs without cause.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Field crew upload/read/delete structured ticket files and open fresh presigned S3 links without API byte streaming | REQ-01, REQ-02, REQ-03, REQ-04, REQ-05 | api, mobile; existing web consumers checked | — | ~600 changed lines / 24 existing files, including existing cases | merged — PR #1049 into staging, 2026-11-06 |

- Requirements covered: **5 in spec §2, 5 fully covered, 0 uncovered**, counted 2026-11-05.
- Units blocked on an open question: **none**; `spec.md` §12 has no unanswered question.
- Existing source edits are provisional; `not started` means the executor has not yet
  reconciled and accepted them against this lifecycle's U1, not that the working tree is empty.
- One vertical unit, zero foundation units. No schema/shared-type foundation is needed.

## U1 — Enforce the structured ticket-file and direct-S3 flow

- **Outcome:** Field crew can upload, list, delete and open ticket attachments through their
  structured S3 keys, with one fresh-link retry when access fails and no field-ticket API stream.
- **Kind:** vertical.
- **Requirements covered:** REQ-01, REQ-02, REQ-03, REQ-04, REQ-05 — all fully.
- **Depends on:** —.
- **Branch / PR base:** existing `fix/strict-ticket-presigned-attachments` from
  `origin/staging` at `2d523af27c55ba13dc9d2ed5c915e4ee5843deb8`, deliberately preserving
  the migrated implementation. One unit/branch/PR if requested later; no commit, push or PR
  creation is authorized by this unit. Do not reset existing work or rebase onto main.
- **Size estimate:** ~600 changed source/test lines across 24 existing files, including the
  current 23-file provisional diff and newly traced incident read sibling; information only,
  not a budget. Ticket lifecycle records are additional.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — no schema, migration or backfill | Existing attachment and ticket identities remain |
| API (`apps/api`) | Reconcile guard, strict key helpers/barrel, Attach File service and field controller; close generic ticket upload bypass; validate generic ticket links/download/delete; validate incident plain-evidence response links; preserve meter photo cover behavior separately | `ticket-attachment-guard.service.ts`, `service/attachments/ticket-image.ts`, `service/attachments/index.ts`, `ticket-attachments.service.ts`, `field-tickets.controller.ts`, `attachments.controller.ts`, `ticket-incidents.service.ts`, `asset-management/assets/assets.service.ts`; inspect sibling signature/lunch/checklist/job-progress callers |
| Web (`apps/web`) | N/A — no planned source change; trace ticket-progress and meter photo consumers | Existing `EntityImageCover` shape remains; verify no scoped stream caller |
| Mobile (`apps/mobile`) | Remove ticket service/HTTP/mock stream method; direct-S3 download helper; sheet refresh/retry; hook returns fresh rows; align contract comment | Existing sheet/file-helper, contract, hook and ticket attachment service files; preserve cache/share and queued writes |
| Shared (`packages/shared`) | N/A — no export/type change | Reuse built `EntityImageCover` |
| Tests | New tests **not requested**; update affected existing cases only and run existing checks | Guard, attachments, checklist, signature and both lunch suites; existing mobile sheet/file-helper/HTTP/mock suites; API suite, lint, typecheck, API build |

Required implementation details, all already specified by REQ-01–05 / §11b:

- Remove `storeFlatObject`; reject missing image/plainFile config before any persistence,
  including idempotency shortcuts. Keep guarded callers and clientUploadId race cleanup.
- Validate ticket image keys before signing/deleting, returning original/preview pairs;
  validate structured plain keys and return one object. Reject flat/malformed/foreign keys.
  Preserve existing structured groups (`attachments`, `signatures`, `checklist-photos`,
  `incident-evidence`) and sanitized document extensions, including extensionless output.
- Apply the same validation before generic `/attachments/:id/links` presigning and
  `/attachments/:id/download` byte streaming for ticket feature rows. Validate both incident
  `toResponses` plain-evidence `files[].url` and `uploadAttachment` `fileUrl` before signing;
  remove the incident service's obsolete D5 legacy-fallback comment. No ticket read entry
  point may bypass the hierarchy through a direct `row.fileName` presign/stream call.
- Use known **row-owner** tenant identity in generic deletion and shared covers, preserving
  intentionally unscoped SUPER_ADMIN access. The field-only attachment service can compare
  current tenant after its existing tenant/employee ticket resolver. Guardian checks this.
- Retain ticketCode/UUID feature ownership matching, auth and S3 deletion transaction/failure
  semantics. No backfill, historical-object sweep, schema, dependency or payroll rule edit.
- Remove scoped controller/service download and mobile byte-streaming contract together;
  preserve independently scoped generic/sales/job-artifact downloads, including generic
  streaming for valid structured ticket rows used by existing non-sheet callers. Contract tracer audits
  existing callers and records older installed-mobile compatibility limitations.
- On failed S3 fetch or missing initial link, refresh metadata once, find the same attachment
  id in the returned rows and retry its new document `url` or image `originalUrl` directly.
  Missing refreshed row/link and second failure use existing error handling. Native-share
  failure after a successful fetch does not trigger expiration recovery. No API auth header
  accompanies S3 requests.

AI choices for normal review remain `spec.md` §11b D1–D6: reject generic ticket upload
bypass, strict key validation/dispatch, bounded refresh, preserve non-ticket siblings,
remove stream completely, preserve identity/deletion boundaries. §11c records sibling
dispositions. Executor must record any changed choice there, without inventing product scope.

### Reviewable as

- **Demo:** With an existing assigned ticket and tenant, POST an image and PDF to
  `/field/tickets/:ticketId/attachments`, GET the list, inspect/sign original+preview image
  keys and the documents key, then delete each and inspect its pair/singleton object set.
  Generic ticket feature uploads must reject. A legacy flat key must reject before signing
  or deletion, including incident evidence and generic links/download routes; valid structured
  rows still work through the generic routes. No stored row/object is rewritten. GET the former scoped download route to
  confirm no matching handler. In the attachment sheet, open an image/document, then use a
  stale/missing initial URL and confirm one metadata refresh plus direct-S3 retry, no API
  payload request, and no retry on native-share-only failure.
- **Acceptance:** REQ-01–05 acceptance/edges and requester AC1–3; AC4 requires the exact
  `pnpm api:test`, `pnpm lint`, `pnpm typecheck` commands to all pass. Present evidence
  establishes AC4 unfulfilled due the baseline failures above; no waiver or clean claim.
  Executor and independent analyst validate scope and gate attribution separately.
- **Reviewer can verify without:** Another unit, schema migration, database backfill, new
  dependencies or a PR. Existing suites and local key/contract review require no live S3;
  the full end-to-end demo requires an authorized tenant/ticket, S3 access and mobile runtime.
  Record unavailable live checks honestly rather than asserting them from mocks.

### Risk

- **Weakest source:** `[VERIFIED]` requester directions for all five requirements. Broader
  field-ops sources remain unverified/conflicted and do not supply extra behavior here.
- **Migration reversible:** N/A — no migration; source changes can be reverted. No data is
  rewritten or purged; historical flat ticket objects intentionally lose supported access.
- **Behind a flag:** no — direct requested retirement of compatibility branches.
- **Touches existing data:** Reads/deletes existing metadata through established user actions;
  **no backfill or bulk rewrite**. Existing deletion transaction behavior is preserved.
- **Blast radius:** All ticket image cover producers, document deletion, generic ticket-file
  entry points and mobile opens. Older installed mobile clients calling the removed stream
  endpoint will no longer download through that endpoint; current source consumers are
  updated in this unit. Non-ticket meter/generic storage must retain existing behavior.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Ticket signatures and lunch services | Shared guard, batch covers, replacement cleanup | Existing `ticket-signatures.service.spec.ts`, `ticket-lunch-breaks.service.spec.ts`, `ticket-lunch-breaks.returned-correction.spec.ts`; inspect caller config and key pairs | REQ-01–03; spec §11a; S Boundaries |
| Checklist assignments | Guard upload/read/delete | Existing `checklist-assignments.service.spec.ts`; inspect structured owner keys and explicit deletion path | REQ-01–03; spec §11a |
| Incident image and plain evidence | Guard upload/cleanup plus direct list/upload presigning | Existing incident service cases in full API suite; inspect `toResponses files[].url` and `uploadAttachment fileUrl` validation before signing, original+preview vs singleton dispatch, retained incident folder and removal of obsolete D5 comment | REQ-01–03; spec §11a C6; D2 |
| Attach File service and field controller | Upload/list/remove and removed stream route | Existing guard/attachment service cases plus route/caller search; inspect image/document metadata signing and removed handler | REQ-01–04; spec §4/§11a |
| Job-progress API and web ticket-progress | Shared covers | Existing job-progress cases/full API suite, API build and web typecheck; trace unchanged cover field consumption and structured variants | REQ-02; spec §11a; S Boundaries |
| Meter-reading photos and web drawer | Former permissive ticket-cover helper | Existing asset service cases/full API suite; inspect independent singleton-cover construction and unchanged web fields | REQ-02 boundary; spec D4 / §11c |
| Generic attachments and non-ticket consumers | Upload bypass, links/download and delete dispatch | Inspect ticket feature-type rejection branches; verify hierarchy validation precedes BOTH links presigning and `getObjectStream`, strict delete dispatch and non-ticket singleton branch; existing controller/API cases and API build | REQ-01–03; spec §11a C6 / D1/D2/D4; P3 owner-tenant rule |
| Mobile sheet, file helper and hook | Direct transfer and fresh metadata | Existing sheet/file-helper tests; inspect refresh return rows, bounded retry and share separation; direct-S3/auth-header trace | REQ-04–05; spec D3 / §11a |
| Mobile service interface, HTTP and mock | Removed streaming contract | Existing HTTP/mock tests; repository search for `ticketAttachments.download`, obsolete stream route and removed service member; mobile compiler checked against known baseline | REQ-04–05; spec §11a |
| Web ticket-progress generic stream fallback and mobile saved-draft URI header resolver | Existing generic download URL consumers | Trace `attachment-thumbnail.tsx` and `apps/mobile/lib/attachments.ts`; preserve valid structured generic reads and independent draft URI handling; inspect server ticket-key rejection before stream/sign; existing web typecheck/mobile gates with baseline attribution | REQ-02–04 scoped boundaries; spec §11a C6 / D2/D5 |

All ten groups carry a check and a source; executor/analyst must actually verify them. A
planned check is not evidence it has run. Contract tracer and Prisma guardian independently
audit their respective route/caller and tenant boundaries during execution/analysis.

### Deliberately not in this unit

- New field workflow/business rules — not requested; broader field-ops conflict unchanged.
- Wholesale removal of web generic-stream fallback or historical mobile draft URI header
  support — outside the named sheet transport cleanup. Existing mechanisms remain subject
  to strict server validation for ticket feature rows; legacy flat keys cannot bypass it.
- Schema/backfill/historical-object sweep/new dependency/new test cases — not requested.
- Unrelated payroll test or app-version typecheck repairs — independent tasks; AC4 remains
  unfulfilled while they fail. No follow-up ticket or waiver invented by this plan.
- Commit/push/PR/merge/deploy/close-ticket publishing — not requested. Reflection can record
  the local implementation and limitations without asserting a merge or closed ticket.

## Sequencing

```text
U1: reconcile provisional implementation → specialist audits → existing gates → independent analysis → reflection
```

- **Parallelisable:** No parallel units. Within U1, independent read-only contract and
  tenancy audits may run together; API and mobile edit ownership must be explicit because
  both meet at the removed route/service contract. Shared `ticket-image.ts`/guard and
  `units.md`/`state.md` mutations are serialized to avoid collisions.
- **Merge order constraint:** No migration or stacked units. API removal and current mobile
  consumer change belong in the same eventual PR. Released mobile binaries remain a rollout
  limitation; no deployment ordering or installed-client repair is claimed here.
- **First unit to ship:** U1 — proves the complete structured upload/read/delete and
  refresh/direct-S3 path while preserving its ticket siblings and non-ticket consumers.
  Executor reconciles first, analyst checks independently, reflector records limitations;
  clean acceptance is not claimed while AC4 fails.


## Post-analysis commit authorization

The developer subsequently requested commits on 2026-11-05 after renaming the branch to
`fix/strict-ticket-presigned-attachments`. Application U1 is committed as `90c2f7734`.
This supersedes earlier commit-authorization limits in this planning snapshot; push/PR/merge
remain unrequested. AC4 remains unfulfilled without waiver.


## Staging synchronization — 2026-11-06

Application U1 was rebased onto `origin/staging` at `0d6c794b2`; its commit changed from
`90c2f7734` to `0232d577c`. The generic controller combines strict ticket cleanup with the
upstream TCG-162 sub-job cleanup and linked-loadout guard. Fresh API build, 158 affected
API tests and runtime deletion checks passed. The earlier separate push request remains
authorized; merge/deployment and a full-gate acceptance waiver remain unrequested.
