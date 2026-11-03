# Review — mobile upload attachment metadata consistency

2026-11-03. Path C, no external ticket. Source: latest requester directive in decisions/2026-11-03-mobile-upload-attachment-metadata-consistency.md (reference). Reviewed the uncommitted working diff on codex/attachment-metadata-consistency against its staging dependency, the current plan/spec, API/mobile/Prisma contexts, P3 rules and the review-pr maintainability/ripple checklists.

## Result

Primary review found no remaining blocking source-level issue in the implemented scope. This is not a claim of independently completed analyst review: specialist agents performed the upload inventory, source/contract and guardian passes, but final follow-up review turns reached their account usage limits. The primary agent completed the final pass.

## Verified by code and commands

- Nine mobile binary-upload operations cover employee renewals, both quotation uploads, job-walk signatures, ticket documents, shared signatures/lunch/checklist images and incident evidence. Metadata and final category lifecycle match plan.md.
- Employee/quotation owner resolution has explicit tenant predicates. Only valid linked owner UUIDs are newly persisted. Legacy me reads require matching uploadedById and linked user; they are never a tenant-wide alias.
- Generic and quotation batch controllers resolve parent ownership before writing S3 bytes. Existing P3 profile-photo upload code is unchanged.
- Shared ticket guard continues storing the ticket UUID and appropriate feature type. Neutral categories cover unlinked files; existing link-time labels override them.
- Quotation PLAN_OR_DOC and WON_EVIDENCE categories are retained. General attachments never become customer-send documents by default.
- Code/UUID readers, code-based employee/quotation logs and expiry links/recipients are updated together. Won/Signed evidence checks retain tenant/type/category/ID restrictions and accept the resolved quote UUID or historical quote code.
- No web UI, viewer, transport, new dependency, stored field, data migration or existing-row rewrite. The Prisma schema change is a comment only. No new test cases; two existing assertions reflect the intended metadata.
- No source file was pushed across the 1,000-line boundary; no unrelated formatting sweep was included.

## Checks executed

All commands ran in the attached checkout via pnpm nx.

| Check | Result |
| --- | --- |
| @tcg/shared:build | passed |
| @tcg/api:build (final controller state) | passed |
| @tcg/api:lint | 0 errors, 669 warnings |
| @tcg/mobile:lint | 0 errors, 392 warnings |
| @tcg/mobile:typecheck | passed |
| @tcg/api:test, 12 existing feature suites | 174 tests passed |
| @tcg/api:test, 4 existing attachment-controller suites | 21 tests passed |
| @tcg/mobile:test, 5 existing certification/quotation suites | 29 passed, 1 timing timeout initially; isolated modal suite retry 9/9 passed; 30 unique selected cases passed across runs |
| git diff --check | passed |

API tests used --runInBand and --runTestsByPath for attachments service/photo reads, job-walk, ticket guard/documents/signatures/lunch/incidents, checklist assignments, me certification reads, Mark Won and quotation-signature flows. Controller suites cover existing photo upload/read/cover/delete. Mobile suites cover certification mocks/contracts/hooks, renewal modal and quotation upload HTTP behavior. The retry used the same 5-second timeout, not a raised threshold.

## Inferred/runtime limits and follow-ups

- No live database, cross-tenant requests, S3 traffic, native-device or browser session was exercised. Source filters and mocked regression suites do not establish production data contents.
- Historical rows are deliberately not relabeled or rewritten. Aliases preserve their ownership reads; a backfill would require separate G2 approval and staging-copy checks.
- Server-generated Signed Quotation copies are not a mobile binary-upload producer. Their direct-writer UUID normalization remains a separate sibling follow-up; current alias reads retain their visibility.
- Earlier presigned read/open-share/JSA-rendering proposals are archived and not implemented in this task.

User subsequently requested commit and push. Code commit 1d439ae58 passed the repository pre-commit lint/format hooks; the hook changes were re-read and remain within scope. The initial pre-push hook rejected publication on full mobile test failures. The requester explicitly approved a one-time SKIP_GATES=1 exception, and the code branch was pushed. See publication.md for full-suite results, unchanged-staging reproductions and the approval. No PR or deployment was requested.
