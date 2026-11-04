# Reflection — MOBILE-OFFLINE-DELETE-QUEUE reliable offline deletes on mobile and guaranteed S3 cleanup on the API

> Written to `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/reflection.md` after the units shipped, before the ticket closes.
> Filled by `tcg-reflector`. Rule changes are proposed, never applied.
> Evidence tags: VERIFIED means a command was run in this session; INFERRED means taken from the close-ticket brief or from an overlay file without re-running the check.

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `MOBILE-OFFLINE-DELETE-QUEUE` (slug, no Jira id), Path A |
| Spec | `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md`, elaborated `2026-10-29`; revised 2026-10-30 (D20 to D24, REQ-13 to REQ-15) |
| Units | U1 cut (outbox, D20). U2 to U8 shipped together in PR #985, merge commit `819483fdb` on `origin/staging` (VERIFIED: `git diff e9d24eabd 819483fdb --stat` = 59 files, 1961 insertions, 279 deletions). One combined PR, not the planned one-PR-per-unit stack. |
| Reflected on | `2026-10-30` |
| Reviewer(s) | Haris (developer, requester, device tester); PR #982 review (U5) |
| Open questions at build time | 16 raised in §12 (13 at elaboration, Q14 to Q16 during build). 11 answered before the executor started (Q1 by an AI decision, D13). At merge: Q8 open, Q16 open (uncommitted edit in the working tree), Q11 answered in part on 2026-10-30, Q15(a) not resolved in the decision note. §14 sign-off: 1 of 12 boxes ticked at merge (VERIFIED by reading §14). |
| `[UNVERIFIED]` requirements built | 15 REQs at the end: 13 `[UNVERIFIED]`, 2 `[CONFLICT]`, 0 verified. 3 of 15 were superseded (REQ-03, REQ-04, REQ-11, by D20). None of the 3 was superseded because a source was found wrong: the developer reversed the mechanism. See §3. |
| Unverified x irreversible | 1. U1's table, enum names and worker numbers were flagged before the build (U1 *Risk*: "Unverified plus costly to undo"), but the same block rated the migration "reversible in practice". The real cost was not the migration: it was five pushed branches rebuilt (SD-1). |

## 1. Spec defects — what the spec missed

### SD-1 — A new table and worker were built before the developer saw their cost

- **Where:** `intent.md` §3 ("use a transactional outbox ... a worker retries"); spec D1 to D6, D13; REQ-03, REQ-04, REQ-11; U1.
- **What the executor needed to know:** whether the developer wanted a dedicated table, a migration, a `TENANT_SCOPED_MODELS` entry and a polling worker, or only the guarantee. (INFERRED from the brief: the developer had already asked "why a new table, I need a solid reason".)
- **What the spec said:** D1 "Developer decision 2026-10-29, relayed", with no quoted words. Its rejected alternatives were the payroll queue, BullMQ/SQS and an S3 lifecycle rule. The lightest option, "delete the S3 objects inside the row-delete transaction and roll back on failure", was not listed. Q1 asked the table's **name**, not whether to have one. D13 records the developer's "What is best?" as the AI's choice.
- **What was decided instead, and by whom:** the AI built U1 and pushed it. The developer rejected the table after review (D20, 2026-10-30, quoted: "I do not think we need this extra table ... we just delete the object from S3 and our DB in a transaction").
- **Was the decision right:** no. The in-transaction design (D20) is smaller. Its stated trade-off: a commit that fails after S3 deleted leaves a row pointing at a missing file until a retried delete finishes it.
- **Cost:** U1 (table, migration, worker, DI in five modules, `TENANT_SCOPED_MODELS`) built and pushed, then cut. U2 rebuilt. U3 to U5 re-stacked as v2 branches. v1 branches deleted from `origin`. The local `storage_deletion_queue` table still exists and its drop needs the developer's approval (state.md).
- **Class:** over-built (the class says "can be decided and still be over-built"). Second row in this class.
- **Fix:** R1.

### SD-2 — The phone's "completed" state was never listed as a consumer of the sync change

- **Where:** §11a (20 consumers) does not list `isSubmittedLocally` (`use-ticket-progress.ts`) or `isTicketComplete` (`step-status.ts`, three call sites). REQ-13 was added on 2026-10-30, after the device test.
- **What the executor needed to know:** which screens decide "done" from the draft's step counter, and what the server holds.
- **What the spec said:** nothing. U5 edited `use-ticket-progress.ts` and the *Ripple* rows named `useTicketProgress` and the `TicketProgress` type, not the completed derivation. The one open consumer row (a failed ticket submit, Q11) took a labelled workaround, which is correct but does not cover this.
- **What was decided instead, and by whom:** found by the developer on a device. TK-00031 and TK-00032 showed completed with an Offline icon while the server held them `IN_PROGRESS`, because `step > total` counted as completed. The AI fixed it in U7 and recorded the rule as D22 ("the rule is the AI's reading of the developer's direction").
- **Was the decision right:** unknown. D22 is `Needs developer: yes`, Reviewed by `pending`.
- **Cost:** one follow-up unit (U7), one review round. Not found by the analyst or any unit's Demo.
- **Class:** missing-requirement.
- **Fix:** R2, R6, R8.

### SD-3 — "Guaranteed S3 cleanup" was scoped by grep of delete calls, so replace paths were invisible

- **Where:** REQ-05, §11c enumerated by `grep -rn "deleteObject(" apps/api/src`; D7 ("six delete sites").
- **What the executor needed to know:** which paths replace a reference to an attachment and never call a delete at all.
- **What the spec said:** every server path that deletes S3 objects deletes them inside the row delete's transaction. A grep for the delete call cannot find a path that never calls it.
- **What was decided instead, and by whom:** found on a device. Pre-Trip, Post-Trip and JSA submit upserted the signature row without `cleanupReplaced`, so 8 of 9 signature uploads for TK-00099 were orphaned (units.md U6 to U8 notes). Commit `c165917b1` fixed it. **It is not in staging**: `git branch -a --contains c165917b1` prints nothing and `git merge-base --is-ancestor c165917b1 819483fdb` says not an ancestor (VERIFIED). The developer's reflog shows `reset: moving to HEAD^1` at 16:09:45. Whether that was deliberate is open (D24, "re-apply or drop").
- **Was the decision right:** the fix is plausible and unreviewed. As merged, the ticket's headline guarantee (no orphaned ticket-attachment objects) is still false on these three paths.
- **Cost:** orphaned S3 objects continue to accumulate on every re-sign until D24 is settled.
- **Class:** missing-requirement. Second row of the same defect: MOBILE-TICKET-PRESIGNED-IMAGES SD-4 (preview.webp orphaned on replace), whose proposal R6 is still `proposed`.
- **Fix:** R3, together with the pending R6 of the previous reflection.

### SD-4 — Which server answers count as "refused" was an AI assumption on a client-facing rule

- **Where:** REQ-09 *Edges* "What counts: any HTTP error status other than 409 ... ASSUMED from 'server-refused'; reviewable"; D19; Q16.
- **What the executor needed to know:** whether a 502/503/504, 401/403, 408 or 429 counts toward the 4-send limit, which decides when the crew sees "Sync failed".
- **What the spec said:** the developer's words were "Only count server-refused sends". The set of statuses is the AI's. The same ticket's Attach File "refused for good" list (400, 413, 415, 422) treats those other statuses as not refused, so two sourced-by-nobody lists disagree.
- **What was decided instead, and by whom:** the AI chose "any status but 409". The PR #982 review raised Q16. Under that choice a 30-minute deploy outage can exhaust every queued entry and badge tickets the server never rejected (spec Q16).
- **Was the decision right:** still unknown. Q16 is open and its edit is uncommitted.
- **Cost:** a review round now. A behaviour question for the crew later.
- **Class:** invented-value. **Third occurrence.**
- **Fix:** R4, R5.

### SD-5 — The derived acceptance lines were never confirmed and the sign-off stayed open through merge

- **Where:** Q8; §14; Q11.
- **What the spec said:** every Acceptance line is "DERIVED, `[OPEN]` until confirmed (Q8)". Q8 was never answered. Q11 stayed open until the developer's direction on 2026-10-30, after U5 was built.
- **What was decided instead:** units were built and merged against derived lines. The device testing then acted as the acceptance review (SD-2, ED-1, SD-3).
- **Class:** open-built-anyway. Second row (MOBILE-TICKET-PRESIGNED-IMAGES SD-6, proposal R7 still `proposed`). The Q11 workaround itself was labelled and correct (see §6).
- **Fix:** apply the pending R7 of the previous reflection; no new text here. R12 adds a close-time check.

### SD-6 — The units plan still describes the stack that no longer exists

- **Where:** `units.md` *Sequencing* ("U1 ... First unit to ship: U1"), the ledger's `Depends on` for U2 (U1), and the *Ledger notes* line that still reads "each PR targets the previous unit's branch".
- **What the spec said:** the plan before D20 and before the developer collapsed U2 to U8 into one tip branch and one PR.
- **Cost:** a reader of units.md after merge is told the wrong shape. No build cost.
- **Class:** stale-reference. Eighth row.
- **Fix:** R12.

## 2. Executor defects — what was built against the spec

### ED-1 — Single tick stayed after a landed offline upload (U6)

- **Where:** `ChecklistEngine.tsx`, `deficiency-panel.tsx`, `signer-capture.tsx` read the saved `local:<id>` reference. The sync ledger's `serverId` was the source of truth (fix: `isAttachmentOnServer`, D21).
- **Spec said:** REQ-14 did not exist. The tick's meaning is in `sync-status-badge.tsx` ("local: single tick; server: double tick").
- **Built:** U4 added queued uploads. The indicator was not re-pointed at the ledger. Reproduced on the emulator: 201 about 3 s after reconnect, tick unchanged.
- **Caught by:** the developer on a device. Not by the executor, the Demo steps or the analyst.
- **Class:** stale-ui-state. **Third occurrence** (MOBILE-TICKET-PRESIGNED-IMAGES ED-2 and ED-3). The thing that outlives its input here is a saved copy of a value the sync later changes.
- **Fix:** R6, R8, R9.

### ED-2 — The analyst and the gates could not see derived state

- **Where:** `tcg-analyst.md` §3b hazard list has no row for a UI state derived from a saved copy. U2 has a recorded verdict (MERGE). U3 to U5 findings F1 to F12 were fixed or listed (F1, F2, F3, F7 VERIFIED in units.md; the rest INFERRED from the brief). U6 to U8 have no recorded analyst pass.
- **Spec said:** units.md *Gate baseline*: nine inherited failing mobile suites, including `use-ticket-progress.test.ts`, the suite for the function U7 changed. Jest ran out of memory with and without the change (units.md U7 note). U7 was checked by tsc, lint and the emulator only.
- **Built / unrun:** U8's API behaviour was "not run live: the running API was an old build that ignores the field". U2's transaction rollback path was unrun against Postgres (U2 analyser note). Neither is recorded as run since. No new tests were added, as the root rule requires.
- **Caught by:** the developer, for the tick (ED-1) and the ticket state (SD-2).
- **Class:** gate-illusion. Seventeenth row.
- **Fix:** R7, R8.

### ED-3 — A destructive local-database step left rows that broke the app and S3 objects that cannot be cleaned

- **Where:** the developer's local `tcg_db`, session 2026-10-30 (state.md Resume).
- **Spec said:** root `CLAUDE.md` G2: destroying or rewriting existing data needs developer approval and a guard run on a copy. The record does not show whether approval was asked for the local database (OPEN, see §3).
- **Built:** `attachments` was emptied by nulling FK columns. That left 59 `ticket_signatures` rows with null image ids. The checklist read then failed the mobile zod schema (`signatureAttachmentId` must be a string) and held "Preparing step..." for about 20 s. The developer read it as a code regression. The S3 keys were not recorded before the delete, so those objects cannot now be cleaned.
- **Caught by:** the developer, as a suspected regression.
- **Class:** env-lesson (new class, see §5). Process lesson, not a product defect.
- **Fix:** R10.

### ED-4 — Test-environment facts were learned one at a time

- **Where:** facts from the brief unless marked VERIFIED. (a) Expo Go's camera app takes about 25 s to start and looked like a hang. (b) A worktree's `node_modules` resolved `@tcg/shared` to the primary checkout's older `dist`. (c) `apps/api/src/main.ts` imports `express` and `apps/api/package.json` has no `express` entry (VERIFIED at `819483fdb` and at `e9d24eabd`, so it predates this ticket), so the API boots only with `NODE_PATH`. (d) Jest runs out of memory on the mobile suite. (e) Nine inherited failing mobile suites (VERIFIED: units.md *Gate baseline*). (f) A 500 on the checklist photo delete on the v1 build was never root-caused; the v2 rewrite changed that path.
- **Caught by:** the executor and developer, by time lost.
- **Class:** env-lesson.
- **Fix:** R11. Item (c) is a separate fix for a human (adding a dependency is G5).

### ED-5 — Work built, then lost off the branch; plan and PR shape changed late

- **Where:** commit `c165917b1` (SD-3); the five v1 branches; the stack plan.
- **Spec said:** units.md and the *commit* skill: one unit per PR, dependent units stacked.
- **Built:** the developer collapsed the stack to one tip branch and one PR (#985) late, deleted the v1 branches from `origin`, and a `reset` dropped `c165917b1`. The overlay names the SHA, but nothing at close compared the overlay's SHAs with the merge.
- **Caught by:** the AI noticed the missing commit and recorded D24. No check found it.
- **Class:** branch-ops. Fourth row (TCG-218 ED-2, ED-3; MOBILE-TICKET-PRESIGNED-IMAGES ED-5).
- **Fix:** R12.

## 3. Source and vault findings

Each disposition is a proposal for close-ticket step 3, written by `tcg-scrum`. No vault source is edited by this reflection.

- **Sources that turned out to be wrong or stale:**
  1. `vault/decisions/2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md`, sections "Not answered — Q11" (line 84) and "Still not answered — Q8 and Q11" (line 172), says REQ-13 stays `[OPEN]`. On 2026-10-30 the developer directed "real fix here" and "the ticket state should be consistent"; U7 built it (D22). Status `reference`; the spec REQ-13 was `[UNVERIFIED]`. Disposition: **amend** with an "Added 2026-10-30 — Q11 in part" section; Q11 keeps `open` for the counting of a failed submit.
  2. `vault/field-ops/gaps.md`, section "Offline capture, committed on a recorded call" (line 757, `resolved 2026-09-25`, item 2 "advances locally without blocking the crew"). The advance-locally behaviour is what let a step counter past the last step read as completed while the server held `IN_PROGRESS` (SD-2). The resolution stays true for what it claims. Disposition: **append a follow-up line** pointing at spec REQ-13 and D22; do not reopen.
  3. Count for the `[UNVERIFIED]` tag: of 15 requirements, 3 were superseded, and for a reason other than a wrong source (D20, a developer reversal). 0 were found wrong when checked. One sample; it does not show the tag predicts anything.
- **Conflicts that surfaced only during build:**
  1. Two unsourced definitions of "refused" in one ticket: "any status but 409" (REQ-09, D19) against 400/413/415/422 for a refused Attach File upload (decision note "Added later"). Already recorded as spec Q16 (open, uncommitted). Disposition: **keep in §12 until answered**; when answered, tcg-scrum writes one decision note covering both lists.
  2. The delete-site count in `intent.md` (four) against the code (six). Resolved on 2026-10-30 in spec, units and the outbox note.
- **Questions answered by a named human during the build:** written to `vault/decisions/` means yes. Written: D1 (superseded note), D20 (`2026-10-30-...-no-outbox.md`, `status: reference`, the 2026-10-29 note carries `superseded_by`, VERIFIED), Q2 to Q7, Q9, Q10, Q12, Q13, Q14, Q15(b). **Not written: 5.** (1) The 2026-10-30 tick report and its fix (D21, REQ-14). (2) The "ticket state should be consistent" direction (D22, REQ-13, Q11 in part). (3) Category at upload (D23, REQ-15). (4) The developer's change to one tip branch and one PR. (5) D24 (re-sign deletes the replaced image), which waits on the developer. Disposition: **write one note** `decisions/2026-10-30-mobile-ticket-state-tick-and-category-follow-ups.md` for (1) to (3); (4) goes to the proposal list (R12), not the vault; (5) after the developer answers. `grep -rln 'TK-00031\|D21\|D22\|checklistType' vault/decisions` finds none (VERIFIED).
- **`gaps.md` entries this ticket should close:** none in a module `gaps.md`. In-ticket: `MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q10 is already `resolved` (VERIFIED) by the 2026-10-30 note. Spec Q14 and Q15(b): `resolved`, no edit. Spec Q15(a): the decision note says "not resolved by this note"; it was built as counted (U5 notes). Disposition: **carry**, ask the developer to confirm.
- **`gaps.md` entries this ticket opened:** none. Spec §12 Q16 is open and Q8 is still open. Neither belongs in a module `gaps.md` (they belong to this ticket). I wrote no §12 question, because both already exist.
- **Undefined terms hit:** "completed" on the phone. It means three different things in the code: server `COMPLETE`, a recorded local submission, a step counter past the last step. Not in the known nine. Disposition: **propose** a one-line definition in the field-ops glossary once D22 is confirmed.
- **OPEN, for a human:** (1) Was G2 approval asked for the local-database step in ED-3? The record does not say. (2) The Attach File delete from another tenant now answers 204 instead of 403 (U2 analyser note); the mechanism was left for the PR author to confirm. No later entry confirms it. (3) The 500 on the v1 checklist photo delete (ED-4 f) was never root-caused.

## 4. Rule changes proposed

All `proposed`. Nothing is applied. Tooling is Haris-only.

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/aidlc/templates/spec.md` | §11b, paragraph after the table title | Replace "Only a guardrail row — destroying data (G2), tenant data (G3), a new dependency (G5) — is marked `needs developer` and waits for an answer." with: "Only a guardrail row — destroying data (G2), tenant data (G3), a new dependency (G5) — or a row that adds a table together with a worker, cron or queue is marked `needs developer` and waits for an answer. That row's *Why* names the cheapest alternative that adds neither (usually: do the work inside the request or its transaction), what that alternative gives up, and what the table adds (migration, `TENANT_SCOPED_MODELS` entry, files). If the developer's request named the mechanism, quote the words; a quoted mechanism is still confirmed against this cost before it is built." | SD-1 | pending |
| R2 | `.ai/aidlc/templates/spec.md` | §11a, first paragraph | Replace "The enumeration is a repo fact and must name the command that produced it;" with "The enumeration is a repo fact and must name the command that produced it. For a requirement that changes when data is saved, queued, synced or submitted, it includes every screen, badge, icon, tick or read-only state that derives 'done', 'synced' or 'completed' from the same field (`git grep -n '<field>' apps/<surface>`), with the source of truth it must follow (server status, sync ledger or draft);" | SD-2 | pending |
| R3 | `.ai/aidlc/templates/spec.md` | §11c, line under the heading | Add: "A requirement that promises something is cleaned up, released or deleted enumerates the **writers** of the reference (`git grep -nE 'upsert\|update\|create' apps/api/src` filtered to the FK column), not only the callers of the delete function. A path that replaces a reference and never calls delete does not appear in a grep for the delete. Apply together with R6 of the MOBILE-TICKET-PRESIGNED-IMAGES reflection (`templates/units.md`); that rule is the unit-side half." | SD-3 | pending |
| R4 | `.ai/aidlc/templates/spec.md` | §2, requirement block, *Edges* intro | Replace "A field nobody can source takes `ASSUMED — <value, from where>` (the nearest existing behaviour), unless it is client-facing (guardrail G1), which becomes `OPEN — see Q<n>`" with "A field nobody can source takes `ASSUMED — <value>, from <where>; client-facing: no` (the nearest existing behaviour). A set that decides when a user sees a badge, toast, block, message or state (which statuses, kinds or counts trigger it) is client-facing: it takes `OPEN — see Q<n>`" | SD-4 | pending |
| R5 | `.ai/aidlc/agents/inception/tcg-elaborator.md` | Output shape, before the report block | Add: "Run `grep -n 'ASSUMED' .ai/aidlc/<TICKET>/spec.md \| grep -v 'client-facing: no'` and paste the result. It must be empty." | SD-4 | pending |
| R6 | `.ai/aidlc/templates/units.md` | *Reviewable as*, **Demo** bullet | Replace "**Demo:** *the exact thing to click or call to see it work — a route, a request, a screen*" with "**Demo:** *the exact thing to click or call to see it work — a route, a request, a screen. For a unit that adds or reroutes a tick, badge, icon or status: **Indicator source:** the store field or query it reads, and the event that changes it; the Demo triggers that event and watches the indicator change without leaving the screen.*" | ED-1, ED-2 | pending |
| R7 | `.ai/aidlc/agents/construction/tcg-executor.md` | Output shape, `Demo:` line | Replace "Demo: <the exact thing to click or call>" with "Demo: <the exact thing to click or call> — ran: <where and result> \| not run: <why>" | ED-2 | pending |
| R8 | `.ai/aidlc/agents/construction/tcg-analyst.md` | §3b hazard table, new row | Add row: "**Derived state** \| A tick, badge, icon or 'completed' that reads a saved copy of a value the sync later changes (a `local:` reference, a step counter, a draft flag). `git grep` every reader of the field the diff writes; does each follow the live source (sync ledger, server status)? A reader with no check is a finding" | ED-1, ED-2, SD-2 | pending |
| R9 | `.ai/claude/contexts/mobile.md` | new sentence under *Structure* | Replaces the sentence proposed as R10 in the MOBILE-TICKET-PRESIGNED-IMAGES reflection (not yet applied). Text: "A loading, failed, synced or completed indicator is keyed on the input it shows (url, id, ledger entry) and reads the live source, never a saved copy; it re-reads when that input changes." | ED-1 | pending |
| R10 | `.claude/CLAUDE.md` | guardrail list, G2 | Replace "**G2** destroying or rewriting existing data → developer approval + guard run on a copy of staging data" with "**G2** destroying or rewriting existing data, including rows in a developer's local database → developer approval; first write the ids and S3 keys the statement touches to a file; remove rows through the app's own delete path or children first, never by nulling a foreign key to empty a table; guard run on a copy of staging data" | ED-3 | pending |
| R11 | `.ai/claude/contexts/mobile.md` | new section "Running on a device", before *Caveat on this file* | Add 5 bullets: Expo Go's camera app takes about 25 s to open the first time. In a worktree, build `@tcg/shared` and check `ls -l node_modules/@tcg/shared` before trusting a missing export. The API boots from `origin/staging` only with `NODE_PATH` set until `express` is declared in `apps/api/package.json` (known; separate fix). Mobile jest needs `NODE_OPTIONS=--max-old-space-size=4096` and one suite at a time. The inherited failing suites are listed in the ticket's `units.md` *Gate baseline*. | ED-4 | pending |
| R12 | `.ai/claude/skills/close-ticket/SKILL.md` | §1, after the bash block | Add: "For every commit SHA the overlay names (`grep -ohE '\b[0-9a-f]{9}\b' .ai/aidlc/<TICKET>/{spec,units,state}.md`), run `git merge-base --is-ancestor <sha> <merge commit>`. A SHA that is not an ancestor goes in the reflection as built-not-merged. Also list each §12 `Status: open` and each `Depends on` or *Sequencing* line that names a unit whose Status is `cut`." | ED-5, SD-5, SD-6 | pending |

Per proposal (adds / removes / does it prevent the defect):

- **R1.** Adds 3 lines, removes 1 (the replaced sentence). A new table plus a worker would have reached the question batch with its cost beside the in-transaction option. Q1 would have asked "table or in-transaction", not "what name". Likely, not certain: the developer rejected it on seeing it built, and the cost list is what he lacked. The existing rule (a new table needs a stated reason: one-to-many, history, independent lifecycle) did not stop this, since a queue has an independent lifecycle.
- **R2.** Adds 2 lines, removes 1 clause. Prevents SD-2 only if the elaborator greps the right field; partial. R6 and R8 are the backstop.
- **R3.** Adds 3 lines, removes 0. Nothing can go: no sentence in §11c covers how the enumeration is built. It would have found the three signature paths by their FK column.
- **R4.** Adds 1 line, removes 0 words net. The existing text already said a client-facing assumption becomes `OPEN`; it was written and not applied, because "client-facing" was left to the writer. The token makes the writer state it.
- **R5.** Adds 1 line, removes 0. The grep is the rail. A writer can still type `client-facing: no` on a badge trigger, but it is now one visible line for the reviewer.
- **R6.** Adds 2 lines, removes 0 (replaces one bullet). Would have forced a Demo step "upload lands, watch the tick" for U4; fails the demo as built.
- **R7.** Adds 0, replaces a line. A bare "Demo" could be left unrun with no trace; this makes "not run" explicit.
- **R8.** Adds 1 row. Nothing in §3b covers derived state. It would have flagged `step > total` and the `local:` read in the unit that wrote the field. The tag is INFERRED-or-VERIFIED per the analyst's own rule.
- **R9.** Adds 1 sentence; removes 1 pending sentence of the previous reflection's R10 (net 0 once applied). The previous R10 was shaped for spinners ("URL-keyed, capped loading state") and would not have covered the tick.
- **R10.** Adds 1 line, removes 0 (replaces the G2 clause). Passes the test: the AI's move (nulling FKs to empty a table) is named and refused. It is not clear that G2 was in play for a local database; that is the hole it closes.
- **R11.** Adds 6 lines, removes 0. Nothing can go: no file records local-run facts. Items (b) and (a) are INFERRED from the brief.
- **R12.** Adds 2 lines, removes 0. The SHA check would have listed `c165917b1` at close (VERIFIED: it is named in spec D24 and state.md and is not an ancestor of `819483fdb`). It detects the loss at close, not earlier; commit-per-step (R12 of the previous reflection) remains the earlier guard.

- **Rejected proposals, and why:**
  1. A lint rule against comparisons like `step > total`: the defect is the meaning of the comparison, not its syntax; no lint can know the server status exists.
  2. A new test requirement for derived state: root `CLAUDE.md` says no new tests unless asked.
  3. Making every new table a `needs developer` stop: most tables are fine and the loop depends on the AI deciding structure. R1 is limited to table + worker/cron/queue.
  4. A "device test required before PR" gate: not checkable by a script. R6 and R7 make the claim visible instead.

## 5. Recurrence check

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | over-built | TCG-218 SD-7 | 2nd | Applied 2026-10-20 (prisma.md redundancy test) but it asks "is this a column"; a queue passes that test. |
| SD-2 | missing-requirement | 22 prior rows, none on derived UI state | 1st for this shape | N/A |
| SD-3 | missing-requirement | MOBILE-TICKET-PRESIGNED-IMAGES SD-4 (replace path orphans objects) | 2nd | Not written: its R6 is still `proposed`. |
| SD-4 | invented-value | TCG-218 ED-1, TICKET-FLOW-SLOTS-HOLDOVER SD-1 | **3rd** | Written and not applied: the *Edges* text already said a client-facing assumption becomes `OPEN`; the writer judged it not client-facing. |
| SD-5 | open-built-anyway | MOBILE-TICKET-PRESIGNED-IMAGES SD-6 | 2nd | Not written: R7 still `proposed`. |
| SD-6 | stale-reference | 7 prior rows | 8th | Written where nobody reads at close; no check. |
| ED-1 | stale-ui-state | MOBILE-TICKET-PRESIGNED-IMAGES ED-2, ED-3 | **3rd** | Not written (R10 still `proposed`) and shaped for spinners, not for derived indicators. |
| ED-2 | gate-illusion | 16 prior rows | 17th | Long escalated; this row adds the missing hazard-list entry. |
| ED-3 | env-lesson | none | 1st (new class) | N/A |
| ED-4 | env-lesson | none | 1st (new class) | N/A |
| ED-5 | branch-ops | TCG-218 ED-2, ED-3; MOBILE-TICKET-PRESIGNED-IMAGES ED-5 | 4th | R9, R10 of TCG-218 applied; R12 of the last ticket not applied; none checks the overlay against the merge. |

- **Escalate:**
  - **stale-ui-state (3rd).** This is not a reminder problem. The previous fix was one prose sentence in `mobile.md`, never applied, and a file the layer calls "wired to nothing". Mechanism: a required **Indicator source** field and a Demo step in the unit (R6), an analyst hazard row (R8) and a `Demo: ran / not run` line in the executor's own output (R7). R9 keeps one sentence in `mobile.md` as the rule's home, and everything else links to it.
  - **invented-value (3rd).** The rule existed and was read as optional. Mechanism: the `client-facing:` token in the spec (R4) and a grep the elaborator must paste empty (R5).
  - **A fourth cross-ticket pattern, for a human:** 4 of this ticket's defects (SD-3, SD-5, ED-1, ED-5) repeat defects whose proposals from MOBILE-TICKET-PRESIGNED-IMAGES were still `proposed` when this ticket ran, one day earlier. The queue, not the rule wording, is the failure. Applying R6, R7, R10 and R12 from that ticket first would have been the cheapest prevention.
- **New class added to the index?** yes: `env-lesson`. No existing class fits: the 24 existing classes describe a diff, a spec, a branch or a gate. `env-lesson` covers a dev or test environment fact, or a destructive local step, that cost time or misled the developer and sits outside the product diff. Its row is added to the class table in the same change.
- **Rows appended to `reflections/INDEX.md`:** yes, 11 (SD-1 to SD-6, ED-1 to ED-5).
- **Model tier:** two classes hit a third occurrence, so this run should have been Opus (reflector §Model tier). It ran Sonnet-class. A human may want to re-read R4 and R6 with that in mind.

## 6. Kept as-is

- **The outbox supersession is recorded correctly.** The 2026-10-29 note has `status: superseded` and `superseded_by` the 2026-10-30 note (VERIFIED). `MOBILE-TICKET-PRESIGNED-IMAGES` §12 Q10 reads `resolved`. D1 to D6 and D13 are marked superseded, not deleted.
- **Q11's workaround ("queued ops only") was labelled and correct.** It did not cause the completed-state defect (that predates it). Leaving a question open with a labelled workaround is what the loop asks for.
- **No new tests were added.** Correct under root `CLAUDE.md`. The consequence (U7's function has no runnable test; its suite is inherited red) is recorded in ED-2, not a violation.
- **`express` missing from `apps/api/package.json` predates this ticket** (present at `e9d24eabd`). Not this ticket's defect and not fixed here (adding a dependency is G5).
- **D19's visible AI assumptions** (D19 listed what was assumed) are the loop working. The defect (SD-4) is that one of them was client-facing, not that it was recorded.
- **U2's analyser notes** (cross-tenant 204, window-closed ordering, `identityPhotoAttachment` is `SetNull`) were carried to the PR and not blockers. The cross-tenant item is still unconfirmed (§3 OPEN).
- **Rebuilding U2 to U5 as v2 branches and deleting the v1 branches** was the developer's call (state.md: pushing needs the developer).
