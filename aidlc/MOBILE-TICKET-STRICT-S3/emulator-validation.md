# Emulator validation — 2026-11-06

Ticket: MOBILE-TICKET-STRICT-S3. Branch: `fix/strict-ticket-presigned-attachments`.
This is pre-merge QA, not a merge, deployment, or ticket closure.

## Result and remaining scope

Core ticket attachment flows passed on Android emulator `emulator-5554`, against the local
API/database and real S3 objects. Live negative testing found an owner-validation defect;
the correction passed independent executor, guardian/contract-tracer, and analyst checks,
fresh acceptance gates, and a confirmed post-restart emulator API retest.

Office asset-meter/job-progress checks received 403 under the field account. An authorized
admin/test account was requested, but was not available during this run. Those office views
and the dedicated office loadout delete flow are **not manually verified**. SUPER_ADMIN and
same-business-code cross-tenant collisions have source/automated evidence, not a live admin
session demonstration. Missing internal storage configuration and storage-failure transaction
rollback are covered by existing tests; they cannot be submitted through the native picker.

No mobile/web source was changed in this QA followup. The API fix and five existing fixture
updates are committed as `9b8afbf11c50d536b44fd2d58b3ef0fbc34a3491`. The developer subsequently
requested publication of both branches with push gates skipped; see state.md's QA publication
handoff. The earlier published `0232d577c` commit does not contain this followup.

## Method and fixtures

The existing field session first attempted an upload on TK-00028. Its completion window was
closed: the app showed the API refusal and no row/object was created. A disposable local
ticket `QA-S3-20261106` was then created for the same primary employee, with its own schedule,
sub-job, allocation, and UUID. Existing ticket/schedule/roster data was not rewritten.

Native UI checks used Android's real document picker, two uniquely named PNG/PDF fixtures,
the Attach File sheet, and native share sheets. No file was sent to another person/service.
The native download function was observed without changing its network arguments. Additional
API cases ran through the emulator's real axios/services; DB and S3 reads verified ownership,
keys, object presence, and cleanup. These supplementary API cases are not claimed as manual
navigation through every sibling screen.

Failure injection was temporary and in memory: an old `X-Amz-Date` produced a real S3 403;
query-cache/service responses supplied missing-row/link and refresh-failure cases; sharing
rejection was injected after a successful download. Initial service-counter instrumentation
captured the wrong loop variable under debugger evaluation; it was removed before the valid
upload run. Those instrumentation failures are not application defects.

The interactive login expired during the extended run. After app/API restart, final supporting
API checks used a 15-minute local QA JWT with the same existing user's DB role `USER` and
tenant, in the native axios header only. No credentials, database sessions, or privileges were
changed. The temporary header, QA globals, and known test cache files were removed afterward.

## Verified cases

| Case | Observed result |
| --- | --- |
| Native multi-file image/PDF upload | Two files attached; image thumbnail rendered |
| Image storage | `attachments/{attachmentId}/original.webp` and `preview.webp`, both `image/webp` |
| Document storage | One `documents/{fileId}.pdf`; safe alphanumeric extension on unusual encoded filename |
| Normal PDF opening | Direct S3 download, 618 bytes, native filename preserved |
| Normal image opening | Direct S3 `original.webp`, 14,060 bytes; native WebP filename and preview |
| Download credentials | Native S3 downloads had no supplied authorization headers |
| Document response metadata | Actual GET 200, forced attachment filename, neutral `application/octet-stream` |
| Expired PDF and image links | Real S3 403, one metadata refresh, successful direct S3 retry, native share |
| Missing initial link | Refresh before download; native share succeeded |
| Failed second S3 attempt | Exactly two download attempts; visible error; no share/retry loop |
| Failed metadata refresh | One logical refresh, three bounded React Query attempts; visible error; no stream fallback |
| Missing refreshed link / removed refreshed row | Visible unavailable-link error; no share |
| Native sharing failure | One successful download, one sharing attempt, zero metadata refreshes/redownloads |
| Expired thumbnail | Metadata refreshed; valid thumbnail rendered (rerun after transient API restart) |
| Native image/document deletion | Rows gone; both image variants and singleton document absent in S3 |
| Upload replay | Same client upload UUID returned same attachment ID; no duplicate row/pair |
| Signature/lunch/checklist uploads | Structured image variant pairs in existing sibling groups |
| Signature + identity and lunch reads | Signed covers returned for stored captures |
| Incident image + document | Image pair and plain singleton under structured incident evidence; upload/list URLs returned |
| Signature/lunch replacement | Previous rows and both previous variants removed |
| Unused signature/checklist photos | Explicit orphan delete removed rows and both variants |
| Generic ticket upload bypass | All four ticket feature types rejected with 400 |
| Removed field stream route | 404; mobile service has no `download` method |
| Flat image/document/incident keys | Generic links, download, deletion rejected with 400; list/replay rejection verified |
| Wrong tenant, variant, group | Rejected with 400 before storage access |
| Real foreign-tenant attachment | Links/download/delete 404; row preserved |
| Post-fix wrong UUID/code ticket owner | Generic links/download/delete all 400; unknown owner also 400 |
| Valid code-owned structured file | Generic links/download 200, deletion 204 |
| Shared code-owned signature cover | Correct folder 200; wrong ticket folder 400 |
| Non-ticket document | Generic upload 201, links/download 200, delete 204; singleton S3 object absent |
| Loadout covers | Existing cover route 200 with original/thumbnail pair |
| Unlinked loadout deletion | 204; original and thumbnail each returned S3 404 afterward |
| Linked loadout protection | Generic delete 400 with Dispatch/Return to Yard instruction; both objects retained |

Generic structured-file streaming was probed deliberately for existing independent consumers;
it remains in scope under D5. It was never used by the ticket attachment sheet as recovery.
A signed GET URL was initially checked with HEAD and returned 403 because the method is part
of its signature; the corrected actual GET passed. This was a test-method correction.

## QA defect and implementation decision

**ED-1 / Path B:** `Attachment.featureId` was passed structurally into helpers expecting optional
`ticketId`. A valid tenant and structured path therefore did not establish ticket ownership.
Generic signing succeeded for a wrong same-tenant ticket folder; streaming reached S3 and
deletion succeeded. Shared covers/orphan cleanup had the same owner-shape gap.

The fix makes UUID `featureId` constrain the key's ticket segment. Code-owned rows resolve
`(row.tenantCompanyId, row.featureId) -> ticket UUID` before signing/deletion. The repository
performs one explicitly tenant-bound batch query for shared covers; the service exposes the
same resolver to generic routes and orphan cleanup. This implements existing D2/D6 without
changing responses, permissions, schema, dependencies, or code/UUID compatibility. Using the
row tenant preserves intentional SUPER_ADMIN behavior. Independent guardian/tracer and analyst
source review passed.

Early followup requests still reached an older loaded API process, so they are historical
reproductions, not fix verification. After the API watcher had no listener, it was restarted
with `pnpm api:dev`. `owner-retest-confirmed.json` and `cover-owner-results.json` are the final
live evidence against the corrected API. Existing mock ownership fields were completed after
the full suite reached the returned-correction sibling; no new tests or test files were added.

## Final gates

All final commands ran with Nx cache disabled, after source/fixture corrections:

| Command | Result |
| --- | --- |
| `pnpm api:test` | 328 suites / 3,845 tests passed |
| `pnpm lint` | Five projects passed, zero errors; existing warnings remain |
| `pnpm typecheck` | Web/mobile and shared prerequisite passed |
| `pnpm api:build` | API, shared, and payroll prerequisites passed |
| `git diff --check` | Clean |

This supersedes the historical AC4 payroll/typecheck blockers. The earlier mobile selection
(four suites / 67 tests) remains prior evidence; no mobile source changed in this followup.

## Cleanup and evidence

Cleanup verified: original UI deletions removed their three objects; API deletion removed the
non-ticket singleton and loadout pair. Final cleanup removed 14 residual objects from only the
two disposable ticket/sub-job prefixes, removed 17 remaining QA attachment rows, and removed
the temporary ticket/allocation/sub-job/schedule. Both prefixes are empty. The foreign row
still exists; TK-00028's `updated_at` remains 2026-10-28. Device fixture files and temporary
runtime authorization were removed. Local API/web/Metro servers remain running; Expo is at
the login screen after its original session expired.

Local evidence is under `/tmp/tcg-emulator-qa/` (not committed): `scenarios.json`,
`owner-retest-confirmed.json`, `cover-owner-results.json`, `loadout-results.json`,
`loadout-storage-check.json`, `cleanup-api-results.json`, `cleanup-results.json`,
`storage-advanced.json`, `storage-after-ui-delete.json`, sanitized `network.jsonl`, screenshots,
and `final-gate-{api,lint,typecheck,build}.log`. Signed URL query strings and tokens are not
included in this report. The temporary QA scripts are outside the repository.
