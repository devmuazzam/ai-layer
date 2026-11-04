# PR #1018 — AI-DLC review

Reviewed `fix/mobile-presigned-reads` → `staging`, head `350dad0dac361c8d04cb6a03f413d35de909dbf0`: four commits, 43 files. The fetched PR merge ref identifies base `2984afa63`; the three-dot diff starts at merge-base `5656e5471`. Ticket: no external ticket; local identifier `MOBILE-REMAINING-PRESIGNED-FILES`.

**Verdict: ship with follow-ups.** One minor code defect survived refutation. No blocking contract or tenant-isolation defect was found by static review. This is not runtime sign-off.

## CODE

1. **[P3] [INFERRED] Deduplicate restored JSA signatures by step key.** `apps/mobile/features/field-ticket/steps/jsa/JsaBody.tsx:429–432` flattens signatures from every assignment, then removes only entries already present in local state. `ChecklistAssignmentsService.getJsaForTicket` places the same ticket-level signatures on every JSA assignment (`apps/api/src/usecase/checklist-assignments/checklist-assignments.service.ts:242–244`). With two active JSA forms and no local signature capture, each saved signature is therefore merged twice. The crew counter at `JsaBody.tsx:246` can show `2/1`; `buildJsaSignatures` subsequently forwards duplicate entries, causing repeated upserts. Deduplicate the saved collection by `stepKey` before merging, retaining local precedence. Reasoned from those producers and consumers; not reproduced by executing the UI. Refutation: cards select by `stepKey` and server upserts use the same unique key, so this does not imply signature loss.

## SCOPE

- **[VERIFIED] Multiple declared units share this PR.** `git log --no-merges --oneline origin/pr-1018-merge^1..HEAD` lists the metadata, viewer, access-rule and S3 hierarchy commits; `units.md:15–17` identifies U0, U1 and U2 separately. The repository requires dependent units to use stacked PRs. Reconcile the review boundary with that rule.
- **[VERIFIED] Two new test cases appear in the diff.** `git diff origin/pr-1018-merge^1...HEAD -- apps/api/src/service/storage/s3-storage.service.spec.ts` adds cases at lines 35 and 57. The local intent explicitly excludes new test cases. No separate approval was available in the reviewed records; reconcile that scope discrepancy. Existing expectation updates are distinct from these new cases.

## LOOP TRAIL

**[VERIFIED]** `rg -n 'MOBILE-REMAINING-PRESIGNED-FILES' .ai/aidlc/processed.log` finds metadata Path C, restored-read Path A, and a retrospective PR #1018 entry. The current state records the Path A continuation through U2. This work has an AI-DLC trail; it is not an untracked change. Historical gate results in that trail were not rerun or independently adopted as current results.

## TOOLING

**[VERIFIED]** The 43-file diff does not change AI-layer tooling or add dependencies. Prisma changes only comments; DBML synchronizes enums already present in Prisma. No database migration or historical data rewrite is introduced.

## DECISIONS AND PRODUCT SOURCES

**[INFERRED]** The main behavior changes trace to the local spec REQ-01 through REQ-08, §11b and the requester records below:

- `vault/decisions/2026-11-03-mobile-upload-attachment-metadata-consistency.md` — canonical owner metadata and legacy reads; status `reference`.
- `vault/decisions/2026-11-04-mobile-presigned-reads-viewers-approved-employee-files-owner-or-admin.md` — viewers approved; employee signed links limited to the owner or ADMIN/SUPER_ADMIN; other owner types retain tenant-wide reads; status `reference`.
- `vault/decisions/2026-11-04-quotation-and-job-walk-s3-folder-hierarchy-and-uuid-consistency.md` — quotation/job-walk S3 hierarchy and UUID persistence, including signed copies; status `reference`.
- Saved JSA rendering also cites the prior `MOBILE-TICKET-PRESIGNED-IMAGES` specification as `unverified`.

These are requester/developer records, not adjudicated TCG client requirements. The field-ops conflict stub still names `field-ops-frd/INDEX.md`, `frd-new-format-draft/INDEX.md` and `atom-mobile-app-user-stories/INDEX.md`; the quotation stub still names `quotation.md`, `quotations.md`, `quotation-flow-process.md` and `assets/user-story-and-tasks.md`. This review does not choose between them. The dated requester records cover this change without resolving those broader workflow conflicts. No new unsourced client-facing policy was established, so no scrum escalation was needed.

Documentation follow-up: spec §3 and older analysis/review files still describe signed-copy normalization as a separate follow-up, whereas the current ledger, state and November 4 decision include U2. Align the historical versus current scope wording.

## PATTERN AND SIBLINGS

**[INFERRED]** The implementation reuses the P3 signer and mobile image component, keeps signed URLs transient, and sends no API bearer header with S3 downloads. Both quotation cards, permit/plan/PO opening, both job-walk signature roles, incident images/files/signature and JSA images/signatures are covered together. §11c records already-signed ticket/profile flows as regression targets and unrelated web blob conversion as a separate follow-up. No new web controls or shared-package exports are introduced.

## RIPPLE

The contract tracer ran the route, field, shared-type and wrapper search passes across web and mobile, using searches for `/attachments`, `/me/certifications`, `featureId`, `attachmentId`, signature attachment IDs and the associated wrappers. Wrapper tracing reached 28 web feature files and 13 mobile production files. Contract compatibility below is inferred from reading, not execution:

- Employee lists accept employee UUID/code, User UUID and uploader-scoped legacy `me` rows.
- Quotation/job-walk lists accept canonical UUID and legacy code owners. Existing mobile quotation parsers do not depend on a returned business-code `featureId`.
- Both Won-evidence callers supply the quotation UUID; validation accepts UUID/code. Signed-copy dedup normalizes legacy quotation codes.
- Certification `attachmentId` is additive and optional; the mobile parser/action distinguishes a document ID from a credential ID.
- The removed job-artifact byte-download wrapper has no remaining production caller.
- The existing ticket attachment sheet reaches the extracted download/share helpers via `openAttachmentFromUrl`.

Coverage limitation **[VERIFIED]**: `rg` across `*.test.*` and `*.spec.*` found no references to `openStoredAttachment`, `openAttachmentFromUrl`, `downloadAttachmentFromUrl`, `shareDownloadedAttachment`, `findForSignedAccess`, `resolveUploadFeatureId` or `employeeAttachmentWhere`. Existing quotation-card, certification, JSA, Me, Won-evidence, job-walk and storage tests cover adjacent behavior, but the signed path and old signed-helper consumer lack direct regression coverage. Under the review skill this caps the verdict at ship with follow-ups. No new tests are requested by this review; device/manual validation remains a follow-up.

## MAINTAINABILITY

- **[VERIFIED]** A Python line-count comparison of changed TypeScript source files at merge-base and head found no file crossing from at most 1,000 lines to over 1,000.
- Thermo-nuclear rubric: **[INFERRED]** no consequential structural regression; shared signing, image rendering and opening helpers are reused. Broader decomposition is outside this PR.
- Ponytail rubric: **[INFERRED]** deduplicating restored JSA signatures removes repeated state and repeated submission work; see CODE. No blocking security/data-loss/load issue survived refutation.

## GATES AND DELEGATION

Builds, tests, typechecking, lint, API boot and live device/S3 checks were not run. Source files and the AI overlay were not edited.

- `tcg-contract-tracer`: no high-confidence contract break found; additive fields and alias compatibility preserved.
- `tcg-prisma-guardian`: explicit tenant predicates and employee owner rules inspected; no actionable isolation finding. Existing conditional extension behavior was checked rather than assumed.
- `tcg-analyst`: independent U1 review; ship with follow-ups, with the JSA duplication issue above.

PR head and base were retrieved through Git. GitHub CLI was unauthenticated and the browser showed a logged-out 404, so the PR description/review conversation could not be inspected. The local AI-DLC records supplied the contract. Refreshing the AI overlay remote failed with DNS resolution; its current local records were reviewed.

**Least confident about:** native sharing, expired-link recovery and fresh-device rendering, because no runtime/device exercise was performed.

**If this breaks in three months [INFERRED]:** the weakest area is the signed-download/native-sharing path without direct regression coverage, or legacy owner aliases drifting from their canonical readers.
