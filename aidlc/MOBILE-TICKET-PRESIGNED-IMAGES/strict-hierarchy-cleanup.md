# Strict ticket attachment hierarchy — 2026-11-05 follow-up

Provisional Path C record, superseded by the developer-requested full Path A lifecycle in
`MOBILE-TICKET-STRICT-S3/state.md`. No new Jira id. Branch: `fix/strict-ticket-presigned-attachments`, based on
`staging` because the original migration is not on `main`. Requester: devmuazzam.

## Requirement source

The developer's 2026-11-05 request explicitly retires flat S3 key compatibility and the
ticket attachment API streaming endpoint. It supersedes this ticket's original D5 legacy
image fallback and D9 streaming fallback for ticket attachments. Historical rows are not
backfilled or rewritten. Invalid or legacy ticket keys are rejected before signing or
deleting; images require `original.webp` and `preview.webp`; documents retain one object.
The mobile flow refreshes attachment metadata after a failed/missing link and retries the
S3 download once. A second failure displays the existing error banner.

## AI decisions

| Decision | Chosen | Why | Alternatives |
| --- | --- | --- | --- |
| Streaming endpoint | Remove controller route, service method, mobile interface/HTTP/mock method | Explicit request; list/upload already return signed links | Deprecate endpoint |
| Validate stored keys | Shared structured-key validation; compare resolved tenant/ticket where available | Removing suffix detection alone would still sign or delete flat rows | Trust stored strings |
| Image vs document cleanup | Strict image helper always returns two variants; common ticket-upload helper returns one plain file or two variants | Guard and generic controller delete both document and image uploads | Apply image deletion to every row |
| Generic ticket upload | Reject ticket feature types before S3 upload | Generic uploader otherwise still creates flat ticket keys | Duplicate ticket upload processing in generic route |
| URL retry | Refresh hook returns fresh rows through query cache; retry download once and share once | Avoid stale cached URL reuse and repeated share dialogs | Refresh for the next tap only |

## Siblings and ripple review

- Contract tracer: one mobile runtime caller of the removed field-ticket streaming route;
  no web or QA caller. HTTP wrapper, interface, mocks, comments and existing tests updated
  together. Older mobile builds that still invoke the removed route lose that compatibility
  intentionally, as requested.
- Prisma guardian: no schema, migration or dependency changes. Existing repository tenant
  scoping and ticket ownership checks retained. Upload configuration must name the resolved
  ticket. Generic upload rejection closes the remaining flat ticket upload path.
- Signature, WTL, incident and checklist uploads already provide image/plain-file configuration.
  Existing signature/WTL/checklist deletion fixtures now expect two structured variants.
- Generic non-ticket documents keep singleton deletion. Entity photos retain their existing
  photo-specific cleanup. Asset meter photos use their own single-file cover mapping instead
  of the strict ticket helper, preserving their existing URLs and response fields.

## Validation

- `pnpm lint`: PASS, zero errors; existing warnings remain.
- Affected mobile attachment tests: PASS, 4 suites / 67 tests. Existing cases cover refreshed
  S3 success, bounded retry failure, sharing, upload, deletion and mock metadata. No new cases.
- `pnpm api:test --maxWorkers=2`: 313 passing suites, 3,663 passing tests; one failure in
  `payroll-open-flags-gate.spec.ts` (incomplete tickets alongside open flags). Reproduced the
  identical failure from a clean `git archive HEAD` snapshot in `/tmp/ticket-attachment-baseline`:
  15 pass, one fails. Payroll files are unchanged.
- `pnpm typecheck`: web passes; mobile reports only existing TS2345 errors in
  `lib/app-version.test.ts:71,83`. That file is unchanged. Attachment code has no type errors.
- `pnpm api:build`: PASS.
- `git diff --check`: PASS.

Review follows `review-pr`; contract tracer and Prisma guardian constraints were applied.
No live device or real S3 check was performed. Changes are uncommitted and unpublished.
