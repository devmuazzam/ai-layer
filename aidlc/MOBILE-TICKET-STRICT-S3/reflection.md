# Reflection — MOBILE-TICKET-STRICT-S3 — strict ticket S3 hierarchy

> **POST-MERGE QUALIFICATION — 2026-11-06:** PR #1049 is merged into `staging` as
> `2e2ff31d91a231e3d8d4f8e1e756e6e6b0c90dbd`, including cleanup correction
> `1e4e375b52a3d1997f060e740f6c478d25357e87`. The final addendum supersedes the
> historical zero-ED, AC4-only blocker, unpublished and pre-merge conclusions below.
> Final totals: 1 spec defect and 2 executor defects, corrected before merge;
> 3 prevention proposals remain proposed, none applied. Office/admin screen checks
> remain not checked. A staging merge does not establish deployment or production acceptance.

> **PRE-MERGE IMPLEMENTATION REFLECTION — 2026-11-05.** Requested explicitly before
> publishing. U1 is uncommitted and unmerged; nothing is claimed shipped or closed.
> Analyst verdict remains **DO NOT SHIP: AC4 UNFULFILLED, no waiver**.
>
> **Structural recurrence:** `missing-requirement` has 27 prior index rows, including
> 3 withdrawn rows (24 non-withdrawn). SD-1 is a corrected interim ripple gap, not a
> defect in the accepted final spec or a surviving source defect. R1 proposes a required
> storage-entry-point enumeration in the elaborator's existing step; no rule was applied.

## What this is for

Review what the planning artifacts missed, what construction built against the final
spec, and what would prevent recurrence. Findings describe artifacts, not people.
This early reflection records local implementation evidence; post-merge close-ticket
writeback is outside the current authorization.

## Fill rules

Every required section/field is retained. `NONE FOUND` does not imply runtime proof.
The provisional Path C implementation was permitted before the later explicit request
for full Path A role execution. It then re-entered the lifecycle for independent planning,
reconciliation and analysis. This chronology is not a `phase-skipped` defect.

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `MOBILE-TICKET-STRICT-S3` — local identifier; no external issue supplied |
| Spec | `.ai/aidlc/MOBILE-TICKET-STRICT-S3/spec.md`, elaborated 2026-11-05, reconciled with inception tracer findings |
| Units | U1 implemented locally; uncommitted, unmerged, **not shipped**; AC4 unfulfilled |
| Reflected on | 2026-11-05 |
| Reviewer(s) | Automated roles: tcg-scrum, tcg-elaborator, tcg-decomposer, tcg-executor, tcg-contract-tracer, tcg-prisma-guardian, tcg-analyst, tcg-reflector. Normal human §11b/§11c review remains pending; no human review invented |
| Open questions at build time | 0 in final spec §12; no product answer needed for the explicit technical direction |
| `[UNVERIFIED]` requirements built | 0 of 5; all five sourced to the requester's recorded technical direction. No vault product document promoted |
| Unverified × irreversible | 0; no schema, backfill, persistent-data rewrite or bulk deletion introduced |

Verification evidence is in `analysis.md` and `specialist-audits.md`. The final API
selection passed 11 existing suites / 158 tests; API build and workspace lint passed
(5 projects, 0 errors). Compiled local smoke passed without network/data writes. Earlier
mobile evidence is 4 suites / 67 tests, with no subsequent mobile edit. These are bounded
checks, not a device/S3 demo.

Earlier full API evidence is 313 suites / 3,663 tests passing and one unchanged payroll
failure at `payroll-open-flags-gate.spec.ts:403`, reproduced on clean HEAD. Typecheck fails
at unchanged `apps/mobile/lib/app-version.test.ts:71,83` (TS2345); web passes. Those full
gates were not rerun after the final isolated API changes. They remain failures, not a
waiver or a measured clean origin/main baseline. The independent analyst found no
actionable implementation defect but correctly withheld shipment under AC4.

## 1. Spec defects — what the spec missed

### SD-1 — Interim ripple enumerated helpers but missed direct ticket-file access

- **Where:** Initial §11a/REQ-02–03 ripple enumeration, subsequently reconciled in
  `spec.md` C6, D2 and `units.md` U1. See `specialist-audits.md` inception findings.
- **What the executor needed to know:** Strict hierarchy checks must precede generic
  ticket `/attachments/:id/links` and `/attachments/:id/download` access, plus BOTH
  incident non-image response paths: `toResponses` files[].url and `uploadAttachment`
  fileUrl. Searching only cover/delete-helper callers cannot enumerate direct signing
  and streaming that bypass those helpers.
- **What the spec said:** The first planned helper change omitted these direct access
  paths (the inception tracer report records the omission; no absent historical text is
  reconstructed as a quote). Final REQ-03 now says: “Flat/outside-hierarchy ticket keys
  are never presigned, streamed or deleted, including incident evidence and generic
  links/download routes for ticket feature rows.”
- **What was decided instead, and by whom:** The inception contract tracer enumerated
  the omitted entry points. The elaborator amended requirements/ripple/D2 and the
  decomposer amended U1 before executor acceptance. The executor then validated the
  actual direct access paths; final tracer, guardian and independent analyst checked them.
- **Was the decision right:** Yes within the specified scope, supported by source review
  and local compiled smoke. This is not proof of live tenant/S3/device behavior.
- **Cost:** One planning reconciliation and isolated API correction/verification pass;
  no shipped regression or data repair is evidenced. The accepted final spec has no
  corresponding unresolved gap.
- **Class:** missing — indexed as `missing-requirement`; interim omission of required
  read-entry-point coverage, not a new unspecified business requirement.
- **Fix:** R1 replaces the current elaborator enumeration step with an operation-based
  storage-entry-point/search-result ledger. Status: **corrected in final artifacts and
  source; preventive rule proposal pending**.

No other final-spec defect found. D1–D6 record the implementation choices, including
bounded retry, non-ticket preservation and generic transport scope, before acceptance.
Pending routine human review is not an unanswered G1 requirement.

## 2. Executor defects — what was built against the spec

**NONE FOUND in the reconciled implementation.** No ED row is manufactured from the
historical migration's deliberate fallback, the initially permitted Path C pass, or
baseline failures outside this unit. Independent analysis matched all five requirements,
D1–D6 and all ten ripple groups. This reports a source-review result, not full runtime
acceptance or a clean test/typecheck result.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:** Two historical fallback directions
  in `MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` D5/Q3 (flat reads) and D9 (scoped stream)
  are superseded for this task by the requester's explicit direction, recorded in
  `vault/decisions/2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md`.
  They were historical choices, not falsely verified product requirements. Scrum already
  added the scoped provenance note to the 2026-10-27 no-backfill decision. **Disposition:
  recorded; no additional vault edit required.** Unverified requirements proven stale:
  0/0. The incident service's obsolete D5 fallback comment was removed in construction;
  the historical record remains historical.
- **Conflicts that surfaced only during build:** NONE FOUND. The broader unverified
  field-ops conflict remains untouched at
  `field-ops/field-ops-mobile-INDEX.md` → `gaps.md#field-operations-mobile-app`.
  This task neither selects a product source nor needs a new gap entry.
- **Questions answered by a named human during the build:** NONE FOUND. Requester identity
  is not inferred from Git. The explicit technical instruction is written in the decision
  note above with `status: reference`; 0 known decisions remain unwritten in this ticket.
- **`gaps.md` entries this ticket should close:** NONE FOUND in the consulted conflict
  disposition. No winning/losing-file frontmatter edits are warranted; the broader
  conflict is outside scope. No gaps file was read whole.
- **`gaps.md` entries this ticket opened:** NONE FOUND. AC4 is an acceptance limitation
  already recorded in this ticket, not an invented product question or follow-up ticket.
- **Undefined terms hit:** NONE newly blocking. Existing `thumbnailUrl` names the ticket
  `preview.webp`; no field rename or new glossary term is required here.

Vault finding count: **2 superseded historical directions, both already dispositioned;
0 newly discovered wrong product sources, 0 outstanding vault actions**.

## 4. Rule changes proposed

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/aidlc/agents/inception/tcg-elaborator.md` | §9, step 1 opening paragraph, before the existing table | Replace the two-line opening paragraph with: “**Enumerate the consumers, with commands and a result ledger**, and record both. For storage-layout/access changes, enumerate entry points by operation (upload, read/link/stream, replace, delete), not only by the helper being edited. Search direct `presignGetUrl`, `presignDownloadUrl`, `getObjectStream` and key-bearing `fileName` use alongside helper callers in the reached feature and generic controllers; give every reached result a §11a disposition, including exclusions. An unclassified result makes enumeration incomplete. The kinds that ripple furthest in this repo, in order of how badly they have hurt:” Adds 6 wrapped lines, removes 2; replaces the existing step rather than duplicating it elsewhere | SD-1 | pending — proposal only, Haris to review/apply |

**Applicability test:** A ledger of the direct storage calls would expose the generic
controller's link/download calls and both incident `presignDownloadUrl` uses before
“helper callers complete” could be accepted. The required disposition creates a reviewable
completion condition; it does not mechanically prove a search had perfect coverage.
No new test/dependency is proposed or added by this unit. The existing contract tracer
remains the independent backstop; this run demonstrates that it caught the gap.

- **Rejected proposals, and why:** A generic “remember siblings” reminder duplicates §9
  without surfacing direct calls. Removing all generic streaming would expand beyond the
  scoped field-ticket route/mobile sheet and contradict final D5. Requiring a backfill,
  globally strict meter-photo keys, or deleting UUID/ticketCode compatibility would change
  independent preserved behavior. Another blanket “all checks must pass” rule adds
  nothing: AC4 and the analyst already block shipment. None was built.

## 5. Recurrence check

Checked `.ai/aidlc/reflections/INDEX.md` by class grep after checking its size. Read the
relevant earlier reflection sections, not whole large files:
`TCG-218` SD-2/R2; `MOBILE-TICKET-PRESIGNED-IMAGES` SD-4/R6; and
`MOBILE-OFFLINE-DELETE-QUEUE` SD-3/R3. These distinguish omitted state-entry paths,
omitted storage lifecycle paths, and searches that cannot find a bypass of the searched
helper. Prior rows are evidence about the process, not new current-ticket source defects.

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | `missing-requirement` | 27 class rows, 3 withdrawn; closest storage rows: MOBILE-TICKET-PRESIGNED-IMAGES SD-4, MOBILE-OFFLINE-DELETE-QUEUE SD-3; analogous alternate entry point: TCG-218 SD-2 | 28th recorded class row / 25th non-withdrawn; 3rd+ structural escalation | General `Reached by`/ripple requirements exist, but the initial enumeration followed named helpers and missed direct byte-access/signing calls. Prior storage proposals R6 and R3 remain `proposed` in the index and concern writers/deletes, not a read/link/stream result ledger. This run's specialist backstop held; no final executor violation is inferred |

- **Escalate:** This recurring class needs a structural completion field, not another
  reminder. R1 requires operation/search-result accounting in the existing elaborator
  step. No claim is made that a new top-tier model was launched; the available runtime's
  procedural applicability check is recorded above.
- **New class added to the index?** No; use existing `missing-requirement` vocabulary.
- **Rows appended to `reflections/INDEX.md`:** Yes — one SD-1 row, `proposed`, explicitly
  labeled interim/corrected. Zero executor-defect rows.

## 6. Kept as-is

- The original migration fallback and meter-helper coupling are historical design context;
  their presence alone is not a current final-spec/executor defect. Non-ticket meter
  covers preserve singleton behavior separately; generic ticket rows validate hierarchy
  before retained generic access.
- Valid structured generic streams serve independent existing callers under D5. The
  removed scoped field route and current mobile ticket sheet no longer stream API bytes.
- S3 layout uses resolved UUID while existing ticketCode/UUID ownership matching stays.
  This is a distinct identity compatibility boundary, not flat storage compatibility.
- Existing deletion transactions/failure semantics and upload idempotency stay. No schema,
  dependency, new test cases, backfill, historical-object sweep or payroll-rule change.
- Final mobile refresh is bounded to one metadata refresh and one direct S3 retry;
  native sharing is outside expiration recovery. Real device cache/share behavior and
  concurrent refresh behavior remain least-confidence areas, as the analyst records.
- All requested lifecycle roles ran; provisional work was independently reconciled.
  No reclassification of the permitted early Path C work as a process violation.
- AC4 remains unfulfilled despite failure attribution and focused green checks. A reviewer
  must not infer acceptance, full workspace build, live demo, merge or close-ticket.
- Human §11b/§11c review stays pending. No commit, push, PR, merge, deployment or overlay
  publishing has occurred under this request.

**What the developer could have done differently:** Put the lifecycle instruction in the
initial task if full Path A role execution is required from the first edit. In planning,
ask for the operation-based access ledger alongside helper callers; this reduces the
reconciliation round without inventing a new product approval gate.

**One unrequested idea:** Attachment metadata could include a documented link-expiration
instant so clients can refresh just before opening rather than wait for fetch failure.
Not built, not added to a unit, and not a follow-up ticket; a human may choose to scope it.

**Handoff:** Local implementation and lifecycle evidence are ready for user review.
Shipment remains blocked solely by the recorded AC4 failures, with no waiver. Normal
AI-decision review and any later publish/merge/close-ticket steps remain outstanding.
I proposed rule changes; I did not apply them.

## 2026-11-06 addendum — live emulator QA and owner-boundary correction

### ED-1 — Attachment row owner shape silently skipped ticket-folder isolation

- **Requirement already present:** REQ-02 trust boundary requires comparison with
  known owner tenant/ticket identifiers; REQ-03 likewise requires owner validation.
  No new product requirement or owner answer was needed.
- **Built:** Generic ticket attachment paths passed an `Attachment` row carrying
  `featureId` to a helper that checked optional `ticketId`. TypeScript structural
  compatibility accepted the argument. Tenant validation ran, but a same-tenant
  different-ticket folder was not compared to the row's actual ticket owner. Shared
  cover/orphan-cleanup paths had the same shape boundary.
- **Caught by:** Coordinator's live adversarial QA, after the original source/targeted
  reviews. This supersedes §2's earlier bounded zero-executor-defect conclusion.
- **Cause of the review miss:** The earlier inventory established that validation
  calls existed, but did not establish that callers populated the identity field the
  helper consumed. Valid structured-key and tenant cases could pass while the
  same-tenant wrong-parent case remained unchecked. This is an implementation and
  verification gap, not a missing requirement.
- **Correction:** UUID ownership is inferred from row `featureId`; ticket-code aliases
  are batch-resolved explicitly within each row's tenant before signing or deletion.
  Shared cover and orphan paths use the same resolved ownership. The correction
  preserves ticketCode identity compatibility without preserving flat storage keys.
- **Class:** `tenancy-gap` — owner isolation was not fully checked. Status:
  **corrected locally, verified before merge; prevention proposal pending**.

### Verification and its limits

The reflector inspected the corrected helper source and the existing live-QA outputs,
without rerunning tests or mutating data. `owner-retest-confirmed.json` records valid
ticket-code owner links/download/delete returning 200/200/204, and wrong-code,
wrong-UUID and unknown-code owner operations returning 400. The file contains a
device-runner preamble before its JSON payload. `cover-owner-results.json` records
valid-code signature covers returning 200 (three covers) and wrong-folder covers 400.
`loadout-results.json` records cover access 200, unlinked deletion 204 and linked-item
deletion 400. The coordinator additionally verified both deleted loadout objects 404.

The coordinator reports independent guardian/tracer/analyst PASS, native direct-S3
normal opening, expiry refresh, failure and deletion checks PASS, and fresh full API
tests (328 suites / 3,845 tests), lint, typecheck and API build PASS. These fresh results
supersede the earlier AC4-only blocker statement; historical failures remain historical
evidence rather than a current failure claim. The reflector did not independently run
those gates or replay the native screen interactions.

`cleanup-results.json` was inspected: 14 residual S3 objects removed, no remaining
objects in the checked QA prefixes, 17 residual test attachment rows removed,
QA ticket/attachment counts zero, non-ticket object absent and the foreign
attachment preserved. The coordinator verified historical TK-28 `updatedAt` remains
2026-10-28. Cleanup is complete for the recorded fixtures, not a historical-data sweep.

The field interactive session expired. Final supporting API probes used a 15-minute
local JWT carrying the same existing database user's USER role and tenant, held only
in memory and removed afterward. These probes are API evidence, not an uninterrupted
native-session claim. Office meter/job-progress screens returned 403 to the field
role; an authorized office/admin session was unavailable, so those screens remain
**not checked**. No merge, deployment, close-ticket, or commit/push of the QA fix has
occurred as part of this addendum.

### Role-boundary lesson and prevention proposal

The executor must establish the caller's concrete identity shape; the tracer follows
its mapping across the helper boundary; the guardian checks same-tenant wrong-parent
rejection alongside cross-tenant isolation; the analyst repeats that adversarial case
against the running application when available. A helper-call inventory alone cannot
establish owner enforcement.

**R2 — proposal only:** In `.ai/aidlc/agents/construction/tcg-analyst.md`, the checklist
row `Isolation`, replace the existing row with:

> | **Isolation** | Any new or modified model: does it hold tenant data, and is it in the scoping allowlist in `prisma.service.ts`? Scoping is conditional. A model outside the allowlist is not isolated. For changed owner-bound file/data access, map the caller's concrete identity fields into the guard and record evidence for both cross-tenant and same-tenant wrong-parent rejection, including UUID/code aliases where supported; an optional guard field or green happy path is not isolation evidence. An unchecked case is reported NOT CHECKED, never PASS — this is the highest-severity finding available to you |

Adds one Markdown table row, removes one existing row; it replaces the current check
rather than copying it into multiple roles. Applicability: tracing `featureId` into
optional `ticketId` and requiring the wrong-parent case would have exposed ED-1 before
the earlier review verdict. This is a required evidence field, not a new test mandate
or an automatic source verifier. No tooling was edited and no new test was requested
by this proposal. Haris review remains required for applying it.

Recurrence checked by class grep in `reflections/INDEX.md`: one prior `tenancy-gap`
defect, SCRUM-877 ED-1 (Prisma allowlist conflict on rebase), whose relevant section was
read. This is the second recorded occurrence. The earlier allowlist correction was
applied but concerns model scoping, not row-to-storage parent identity; no evidence
shows that an applied same-parent verification rule was ignored. No new class and no
third-occurrence escalation. One ED-1 index row appended, status `proposed` for R2;
the local source correction is separately recorded above.

No new vault findings, unanswered product questions, or unwritten human decisions were
identified by this QA addendum. The historical SD-1 and R1 remain as recorded. The
earlier zero-executor-defect claim is superseded, not silently erased. The developer
could have requested the same-tenant wrong-ticket fixture alongside cross-tenant QA
at the start; no additional approval step was necessary. The earlier unrequested
link-expiration idea remains unbuilt. Normal review/merge/closure work remains pending.


## 2026-11-06 final addendum — PR #1049 merged and post-save cleanup correction

### ED-2 — Strict stale-key validation escaped after a replacement had already saved

- **Where:** `TicketAttachmentGuardService.cleanupReplaced` and its four existing
  post-save call sites across signatures, lunch breaks and checklist answers.
- **Existing contract:** Replacement metadata is saved before orphan cleanup. The
  helper already treated unavailable S3 cleanup as nonfatal because that save had
  committed. Strict key refusal required preventing legacy signing/deletion, not
  converting successful replacement persistence into a failed response.
- **Built:** `deleteOrphaned` began validating stale row ownership and key hierarchy,
  introducing an expected `BadRequestException`. Its post-save caller still caught
  only `ServiceUnavailableException`. A stale flat/malformed key could therefore
  produce 400 after a replacement saved. Checklist processing could stop before
  subsequent answers and `markSubmitted`.
- **Caught by:** Independent PR review, then the coordinator's source validation and
  the executor's temporary before-patch runtime reproduction. Earlier emulator
  replacement checks used valid structured old keys; they did not cover this case.
- **Cause of the miss:** Shared-helper callers were enumerated, but the changed
  exception contract was not traced through the callers' persistence ordering.
  Structured replacement success and strict direct rejection each passed while
  their combination on post-save cleanup remained unchecked. This is an executor
  regression in an existing consumer, not a newly discovered product requirement.
- **Correction:** Commit `1e4e375b5` catches expected bad-request validation in
  `cleanupReplaced`, alongside the existing storage-unavailable exception. It warns
  and retains rejected stale rows/objects. Direct reads/deletes still reject before
  S3 access, valid structured cleanup still removes both variants, and unexpected
  errors still propagate. D7 records this narrow decision; legacy access was not
  restored and no historical rows or objects were rewritten.
- **Class:** `refactor-untested`. Status: corrected and merged; R3 prevention proposal
  remains proposed. No new repository test cases were requested or introduced.

### Verification, merge evidence and limits

**VERIFIED in this reflector run:** `git show -s origin/staging` identifies merge
`2e2ff31d91a231e3d8d4f8e1e756e6e6b0c90dbd`, subject “Merge pull request #1049
from TheCraneGuys/fix/strict-ticket-presigned-attachments”. Its second parent is
`1e4e375b52a3d1997f060e740f6c478d25357e87`; `git merge-base --is-ancestor`
for that correction against `origin/staging` exits 0. This verifies application
merge ancestry, not any deployment or overlay publication.

**Previously VERIFIED by this executor; after-patch smoke independently rerun by the coordinator:**
`node /tmp/tcg-stale-cleanup-smoke.cjs before` reproduced the rejected stale key
escaping and stopping continuation. The after-patch invocation verified continuation,
one warning, no deletion of rejected stale rows/objects, strict direct rejection,
both structured variants deleted, expected 503 suppression and unexpected-error
propagation. It runs the actual source guard with the compiled key validator and
mocked repository/storage; it does not reproduce an endpoint, database, S3 or
emulator failure. Six existing suite files were selected through cache-disabled
Nx and the target exited 0; that targeted log did not retain Jest suite/test counts.

`review-cleanup-fix.md` records the independent Path B analyst PASS, fresh API build
and lint PASS, and full API tests PASS (328 suites / 3,845 tests) after allowing the
local ports required by existing HTTP suites. The coordinator checked those outputs;
the reflector did not rerun the full gates at close. The successful rerun supersedes
sandbox `listen EPERM` failures. Earlier web/mobile checks and emulator evidence remain
historical evidence; the stale-key correction was not rerun on an emulator. Authorized
office/admin meter and job-progress screens remain **NOT CHECKED**, as already recorded.

### R3 — Required failure-path evidence for existing shared-helper consumers

**Proposal only; third-occurrence structural escalation.** Replace the current
`Complete?` bullet in `.ai/aidlc/agents/construction/tcg-analyst.md` §4 with:

> - **Complete?** Every row delivered, requested tests included, migration committed if the schema moved.
>   For a changed shared helper, require an existing-consumer ledger: caller, changed success/error contract, persistence before/after the call, resulting response/state on each newly introduced failure, and command/output or NOT CHECKED. A consumer list or green happy path alone is insufficient; do not request or add new tests without developer authorization.

Adds 2 source lines and removes 1 bullet. The required ledger replaces a weak completion
assertion instead of adding the same rule to multiple roles. **Applicability:** the
`BadRequestException` row for checklist `upsertAnswer → cleanupReplaced → markSubmitted`
would show the save precedes the new exception and the final submission write is skipped.
A temporary runtime reproduction, existing test, or explicitly NOT CHECKED entry meets
the evidence format without violating the no-new-tests policy. This is a structural
review-artifact requirement, not an implemented runtime/static checker. No tooling was
edited; only Haris may decide/apply the proposal.

### Recurrence and why the earlier prevention did not hold

Class grep finds exactly two prior `refactor-untested` rows: SCRUM-900 SD-1 and
SCRUM-252 ED-4. Their relevant reflection sections and proposals were read. The index
marks both earlier proposals applied (2026-08-28 / 2026-10-20). This is the **third
recorded occurrence**, requiring structural escalation rather than another reminder.
The earlier mechanisms emphasized covering existing consumers and confirming behavior;
this run did enumerate consumers and verify structured happy paths, but failed to expose
the new exception after persistence. R3 therefore requires the missing failure/persistence
artifact explicitly. No evidence establishes whether an older instruction was ignored;
its existence and the previous green checks do not establish that failure paths were
covered. No new class is invented. One ED-2 row is appended, never rewriting ED-1 or SD-1.

Rejected interpretations: do not classify this as `missing-requirement` merely because
D7 now clarifies implementation, and do not broaden `gate-illusion` solely because
passing gates missed it. No documented-convention breach needs to be invented. Do not
restore legacy signing/deletion or swallow every exception to fix this case. The early
zero-executor-defect and all-cases/merge-ready conclusions are superseded; they remain
historical evidence of the verification gap.

### §3 disposition and close handoff

§3's two historical fallback directions were already dispositioned by the scoped
requester decision. ED-2 introduces no stale/wrong vault source, new conflict, unwritten
human product answer, undefined term, or ticket/vault question. No new vault action,
§12 question or gaps-file edit is warranted. The wider field-ops conflict remains outside
this technical ticket. Final totals: **SD-1 plus ED-1/ED-2; 0 outstanding source actions**.
R1, R2 and R3 are proposed only; the source fixes are separately merged. No preventive
rule has been applied by this reflection.

Stale queue check: the immediately preceding recorded ticket close is HOLDOVER-YARD-GATE,
2026-11-05 (`state.md` Closed line). Parsing only date-bearing Markdown index rows with
status beginning `proposed` and date strictly before `2026-11-05` finds **33 rows**
(2026-10-19 through 2026-11-04): branch-ops 2; contract-drift 1; contradicted-source 1;
duplicated-logic 1; env-lesson 2; gate-illusion 4; ignored-spec-edge 2; layer-violation 1;
missing-requirement 6; open-built-anyway 2; over-broad-condition 1; over-built 1;
pattern-drift 2; phase-skipped 1; stale-reference 2; stale-ui-state 3; unbounded-scan 1.
Dates have no intra-day timestamps, so same-day rows are conservatively excluded.

The close coordinator owns state, units/processed ledger, office-check disposition and
overlay publication. This reflection does not claim those writes are pushed. No source,
tooling or product-vault file was changed by this close reflection.
