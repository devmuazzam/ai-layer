# Reflection — MOBILE-TICKET-STRICT-S3 — strict ticket S3 hierarchy

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
