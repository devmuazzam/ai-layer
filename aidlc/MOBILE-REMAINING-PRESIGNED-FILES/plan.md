# Plan — consistent mobile upload metadata

Updated 2026-11-03 to the requester's latest scope. This replaces the earlier viewing/open-share execution proposal; that proposal is retained in presigned-read-plan.md for reference.

## Current goal and path

No external ticket. Path C: a stated consistency change, one independent task on `codex/attachment-metadata-consistency`. Implementation checkout: `/home/codingcops/.codex/worktrees/attachment-metadata-consistency/craneguys-platform`, based on `origin/staging` because the ticket-image migration dependency is absent from `origin/main`.

Every mobile image/document upload must create an attachment row with the owning resource UUID in feature_id, the appropriate feature_type and a useful category. Routes may still accept business codes; the API resolves them within the tenant before storage. Existing category-driven behaviors must remain intact.

No new viewers, presigned upload transport, read/download transport changes, data backfill, new schema fields or dependencies. Existing records remain readable through aliases. New tests were not requested; update affected expectations in existing cases only.

## Complete mobile upload coverage

Nine binary-upload operations across eight HTTP adapters; several signature consumers share an uploader.

| Upload | feature_type | New feature_id | Category |
| --- | --- | --- | --- |
| Certificate renewal | EMPLOYEE | Employee UUID | Certification name; server retains catalog/legacy reference normalization |
| Quotation general/create attachment | QUOTATION | Quotation UUID | Quotation Attachment when none supplied |
| Quotation plans/documents batch | QUOTATION | Quotation UUID | PLAN_OR_DOC retained |
| Job-walk operator/foreman signature | JOB_WALK | JobWalkReport UUID | Job Walk Operator Signature / Job Walk Foreman Signature |
| Ticket Attach File | JOB_TICKET | Ticket UUID | Ticket Attachment |
| Customer/compliance/JSA/checklist signature and identity upload | TICKET_SIGNATURE | Ticket UUID | Ticket Signature until linking assigns the precise existing label |
| Lunch WTL signature/identity upload | TICKET_SIGNATURE | Ticket UUID | Ticket Signature until linking assigns Lunch WTL 1..4 |
| Pretrip/posttrip/JSA checklist photo | CHECKLIST | Ticket UUID | Existing checklist label, or Checklist Photo until submit identifies the type |
| Incident evidence image/video | TICKET_INCIDENT | Ticket UUID | Incident Evidence; incidentReportId holds the incident UUID |

Incident customer signatures reuse the TICKET_SIGNATURE upload, then become Incident Evidence on linking. No mobile profile-photo or meter-photo upload producer was found. Their read-only use does not introduce another uploader.

## Implementation steps and status

1. **Implemented:** resolve employee/code/legacy User UUID inputs to Employee UUID; remove the mobile literal `me`/User-ID upload fallback. Legacy `me` rows are read only when their uploader matches the employee's linked user.
2. **Implemented:** resolve generic and batch quotation uploads to Quotation UUID, retaining PLAN_OR_DOC and WON_EVIDENCE. General files never inherit PLAN_OR_DOC, which would wrongly include them in customer emails.
3. **Implemented:** store job-walk signature owner UUID and role-derived category. Keep routes by code and role attachment UUID references.
4. **Implemented:** supply neutral categories for new ticket uploads that previously started null; retain all existing link-time specific labels.
5. **Implemented:** preserve code/UUID alias reads, employee/quotation code-based activity logs, expiry links and recipients, and UUID/code Won/Signed evidence checks. No existing attachment rows are rewritten.
6. **Completed:** validate owners before writing S3 objects; API build, API/mobile lint, mobile typecheck and selected existing regressions passed. Primary final review completed; independent agents supplied static audit/guardian feedback but later review turns hit usage limits.
7. **Completed:** verification results are recorded below and in review.md. User subsequently requested commit/push; code commit 1d439ae58 passed pre-commit hooks. The requester approved a one-time SKIP_GATES=1 publication exception after reviewing the mobile baseline failures; code is pushed and these records accompany it on the matching overlay branch. See publication.md for the gate results and approval. No PR or merge requested.

## Technical decisions and siblings

- Shared lower-layer resolvers use explicit tenant predicates; never treat a supplied UUID as authorization.
- Employee attachment reads accept owner UUID, employee code and linked User UUID. Literal `me` additionally requires the matching uploadedById; it is never a global alias.
- Quotation/job-walk list reads accept both new UUID and historical code rows. Existing code-based routes and notification labels remain code based.
- Generic attachment activity logs convert UUID owners back to employeeCode/quoteNo. Existing expiry notifications resolve the owner before constructing links and recipients.
- Won/Signed evidence validation accepts only IDs on the resolved quotation, with existing tenant/type/WON_EVIDENCE restrictions.
- Generic profile-photo categories remain reserved for P3. Arbitrary ticket/quotation images are not labeled Profile Picture or Photo.
- Web callers of the same upload/list functions keep working with codes. No web UI changes are included.
- Server-generated Signed Quotation copies are not a mobile binary-upload producer; their separate direct-writer canonicalization is a follow-up. Current reads preserve them.

## Verification

Completed checks:

- Shared build and final API build (including Prisma generation): passed.
- API lint: passed, 0 errors / 669 warnings. Mobile lint: passed, 0 errors / 392 warnings.
- Mobile typecheck: passed.
- API upload/compatibility regressions: 12 existing suites / 174 tests passed.
- Existing attachment-controller/photo regressions: 4 suites / 21 tests passed.
- Mobile certification/quotation regressions: 29 of 30 tests passed on the combined run; the first modal test timed out at 5 seconds. Rerunning that whole existing modal suite alone passed all 9 tests, leaving all 30 unique selected mobile tests passing across the runs. The timeout was not hidden by increasing its limit.
- Diff whitespace and final source review: passed. No new test cases were added; two existing metadata expectations were updated.

No real device, database or S3 validation was performed. This validates code and existing regressions, not historical production row contents.

Relevant existing coverage: job-walk signature storage/cleanup; ticket attachment guard, ticket attachments and ticket signatures; checklist assignments and lunch breaks; incidents; quotation Mark Won/Mark Signed and send/signature paths; generic attachments and mobile certification contracts/renewal flow. Run through `pnpm nx`, using a 4096 MB Node heap for API lint/build where needed.

## Handoff

Implementation is restricted to upload persistence and its required compatibility callers. The previous presigned viewing/open-share/JSA-rendering proposals remain archived and are not silently implemented by this task. Review results and exact gate outcomes belong in state.md before handoff.
