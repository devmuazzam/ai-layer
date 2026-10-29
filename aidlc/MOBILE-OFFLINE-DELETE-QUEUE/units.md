# Units — MOBILE-OFFLINE-DELETE-QUEUE reliable offline deletes on mobile and guaranteed S3 cleanup on the API

> Written 2026-10-29 by `tcg-decomposer` from the approved-in-substance `spec.md` beside it (no
> Jira id; the slug stands in for `SCRUM-###`). Consumed by an executor, one unit at a time.
> **Nothing has been implemented.**
>
> **Revised 2026-10-29 (third pass).** The spec changed after the first pass: Q4 is answered
> (REQ-09 and REQ-12 defined, D16 to D19), REQ-13 is new and `[OPEN]` (Q11), and Q13 (where the
> Attach File queue is stored) is **answered: option A, a reserved key in the draft's sync ledger,
> sent by the existing sync; D9 is a confirmed developer decision, not a workaround.** A fifth unit
> **U5** was added for REQ-09 and REQ-12. Stack order is **U1, U2, U3, U4, U5** (numeric; reasons in
> *Slicing decision*, moves 6 and 7).
>
> Sign-off state: `spec.md` §14 is not ticked. **Open: Q8, Q11.** Q8 (confirm the derived
> acceptance lines) is sign-off, not a build blocker. Q11 holds REQ-13 (a failed ticket submit),
> which no unit covers. **No unit U1 to U5 is blocked by an open question**; U4 carries an executor
> risk (F2), which is a stop-and-ask condition, not a block. Every *Acceptance* line below is a
> DERIVED line, unconfirmed.

## Slicing decision — what changed from the planned U1 to U4, and why

The developer's decision stands: **one ticket, stacked units, one PR each** (four planned, five after the second pass) (U2's PR targets
U1's branch, and so on). The first four unit ids are kept (a fifth was added in the second pass, moves 6 and 7). One boundary moved, and two cuts the
plan did not ask about were tried and rejected.

**Test applied to each planned unit — "if this ships alone, what can someone do that they could
not do before?"**

| Planned unit | Honest answer | Verdict |
| --- | --- | --- |
| U1: model + migration + `TENANT_SCOPED_MODELS` + repository + worker + module | Nothing. A table and a worker with no caller. Only an operator reading an empty table sees a difference. | **Fails the test.** Foundation is allowed only when three or more later units consume the migration; only U2 does. So it cannot be a bare foundation. |
| U2: enqueue at five sites + D11 + `ATTACHMENT_IN_USE` | Delete a ticket photo with S3 down and the object is still removed later. Backend-only, but a real behaviour change (S3 cleanup guaranteed). | Passes, but only because it contains the half U1 lacks. |
| U3: mobile delete op, wiring, sweep, cancel-both, 409 split | **First crew-visible value**: a photo removed offline stays removed across a restart and reaches the server on reconnect. | Passes. |
| U4: Attach File offline queue | Crew attach and delete files offline. | Passes. |

**Move 1 (the one change to the plan): the boundary between U1 and U2 is cut by delete site, not
by layer.** Merging U1 into U2 was considered and rejected: it makes one very large API unit that
proves the migration, worker, DI across five modules and five sites in one PR. Instead:

- **U1 = outbox + the first complete path.** Model, migration, repository, worker, module, the
  immediate attempt (D5), the FAILED handling (REQ-11), **and** the `deleteOrphaned` site, which
  `cleanupReplaced` also reaches. Demo: delete a checklist photo with S3 refusing, see the job
  retried until the object is gone. That is a vertical slice (schema, API, behaviour) and it
  tests the riskiest assumptions first (a one-way migration, the DI graph, a worker that runs
  outside any request).
- **U2 = the remaining sites and the two small contract items.** `removeUnreferenced`,
  `discardObjects`, the fifth site (`TicketAttachmentsService.remove`), D11 (missing id, 204) and
  D14 (`ATTACHMENT_IN_USE`).

Effect on coverage: **REQ-03 and REQ-05 are split by site across U1 and U2** (each unit's
*Requirements covered* names its part). Every other REQ sits in exactly one unit. If the
developer prefers the plan's literal boundary (U1 = model + worker with no site; U2 = all five
sites) it is a re-cut of the same work, but U1 would then fail the shipped-alone test; this file
does not do that.

**Rejected cut A: split U3 into "checklist and signatures" and "the sweep".** Both call the same
new op kind, the same reserved ledger key and the same drain; a middle state would ship the op
with the sweep still fire-and-forget (the offline-loss defect left in place for one caller). The
409 split (REQ-08) cannot ship later than the op: without it a signature-referenced refusal is
read as "window closed" and the op sits behind the "Request approval" path for ever. So U3 stays
one unit. If its PR proves too large to review, the carve-out is the sweep call site in
`use-ticket-outbox.ts` (a small second PR depending on U3), recorded then.

**Rejected cut B: move D14 (`ATTACHMENT_IN_USE`) into U3 so the crew-visible value lands one PR
earlier.** The throw lives in `removeIfUnreferenced`, whose transaction U2 is already editing in
the same lines. Splitting that function across two PRs creates a merge conflict for no value.
U3 depends on U2 only for the shared constant; the delivery order U1 then U2 then U3 is also the
spec's rollout order (§11), so a queued delete always reaches an API that already guarantees
cleanup.

**Two smaller placement choices (reviewable):**

- The `attachments` target of the `deleteAttachment` op (the Attach File delete) is added in
  **U4**, not U3. A `sendOp` branch with no caller in U3 would be dead code that no reviewer can
  exercise. U3 builds the kind with `checklist` and `signatures`; U4 widens the union.
- **The API reads `X-Captured-At` on the delete routes** (spec REQ-01 notes). The plan's list
  did not give it a unit. It is placed with the mobile change that sends the header: the
  checklist and signature DELETE routes in **U3**, the Attach File DELETE and upload routes in
  **U4**. This is not new scope; it is REQ-01 and REQ-06 as the spec writes them.

**Move 6 (second pass): new unit U5 for REQ-09 and REQ-12, and the counter is NOT moved into U3.**
The question asked was whether the retry counter belongs in U3 (the first unit to touch
`drain.ts`) so the delete op is born with it. Decided: **no, it stays with the badge in U5**, for
three reasons.

1. *The stop rule without the badge strands work silently.* REQ-09 stops automatic retries after
   the 4th counted send; only REQ-12 tells the crew. Shipping the counter in U3 and the badge in a
   later unit would create a middle state where a ticket quietly stops syncing and nothing says so.
   Counter, stop rule, badge and tap are one behaviour and ship together.
2. *The counter changes every existing op kind, not just the new one.* REQ-09 scope is "every
   queued op type": today a failed step is resent at every drain and scan with no limit
   (spec §11a). Putting that rewrite into U3 mixes a new op kind with a change to the failure
   semantics of the whole queue, in the unit that is already the largest, and its regression
   radius (a failed entry now blocks later entries and the submit differently) would hide inside
   a delete-op review.
3. *The delete op is covered the moment U5 lands without being "born" with it.* The counter lives
   on the ledger entry (`StepSyncEntry`), and the delete op's entry is a ledger entry under the
   reserved key (D9), so the counter applies to it automatically. Between U3 and U5 the delete key
   behaves exactly like a failed step does today (retried every drain and scan), which is the
   existing behaviour, not a regression.

**The same lines are edited by two units, stated here:** the failure branch in `drain.ts`
(`:162-171`, where the 409 test sits) and `markRejectedStep` / `replayPendingStep` in
`background-sync.ts` (`:177-201`, `:232-252`). **U3** edits them to split a 409 by cause (REQ-08).
**U5** edits them again to add the "did the server answer" test and the count. To keep the two edits
from fighting, U3 keeps the 409 branches *separate from* the generic failure-marking path, so U5
inserts the count only into the generic path and a 409 never reaches it (REQ-09: a 409 is never
counted). U5 builds on U3's branches for that reason (it is stacked behind U3 and U4). U3 also adds
the reserved delete key that U5's counter later covers.

**Move 7 (third pass): numeric stack order restored, U4 then U5 (U5 stacked on U4).**
In the second pass U4 was moved behind U5 only because it was held by Q13. Q13 is now answered
(option A, D9 confirmed), so that reason is gone and the order returns to U1, U2, U3, U4, U5. The two
units' contents do not change with the order: U5's counter, badge and tap read the ledger generically,
so they cover the Attach File key once U4 has created it; U4 does not touch the counter. With U4
first, U5's acceptance and demo can exercise all three queue kinds (step ops, the delete key, the
Attach File key), and no unit sits behind an unmerged unit for a reason that no longer exists.

*A concrete reason for the reverse was looked for and found weak.* U4 carries one executor risk (F2:
the sheet receives only a ticket id and sits outside the flow store, so a draft may not be reachable).
If the executor must stop on it and raise a §12 question, U4 stalls and U5 waits behind it. That is a
possibility, not a known fact, and a stall of U4 is itself the signal to re-order. **Fallback if it
happens:** U5 is re-based onto U3 and ships first; its contents are unchanged (only the stack parent and
the `drain.ts` / `ticket-draft-sync.ts` merge order move, and Demo steps for the Attach File key move to
U4's PR).

## Findings for the elaborator and the developer (not units)

- **F1 - base branch is `staging`, not `main`.** `ticketImageObjectKeys` (the key list every
  outbox row is built from) exists on `staging` (PR #958, MOBILE-TICKET-PRESIGNED-IMAGES) and
  **not on `origin/main`** (`git grep -c ticketImageObjectKeys origin/main -- apps/api/src`
  returns nothing). U1 branches from `origin/staging`, not `origin/main`. If #958 reaches `main`
  first, branch from `main` instead and say so in the PR.
- **F2 - executor risk in U4: can a draft be reached from the Attach File sheet?** (Was a blocker
  while Q13 was open; now only a risk.) Spec Q13 is answered: the Attach File queue is a **reserved
  key in the ticket draft's sync ledger, sent by the existing sync** (D9, a confirmed developer
  decision). The first-pass brief's "its own durable queue" is superseded. `TicketAttachmentsSheet`
  receives only `ticket.id` from `ticket-details.tsx:182` and sits outside the field-ticket flow
  store, so a draft may not be reachable from it, or may not exist when the sheet is used before the
  ticket is started. **The executor of U4 confirms a draft exists or can be created for the ticket.
  If it cannot, stop and raise a new spec §12 question; do not build a second queue.** (spec REQ-06,
  Storage and the executor's risk.)
- **F3 - `TicketAttachmentGuardService` is provided in five modules, not four:**
  `ticket-signatures`, `ticket-lunch-breaks`, `checklist-assignments`, `ticket-attachments`,
  `ticket-incidents` (`grep -rln "TicketAttachmentGuardService" apps/api/src --include=*.module.ts`).
  U1 changes its constructor, so U1 updates all five and boots the API.
- **F4 - REQ-07 sub-case stays ASSUMED** (spec REQ-07 notes): a photo still named by a completed
  step's stored write is uploaded, then deleted by the sweep as a queued op. The answer "nothing
  is sent" is not met for that sub-case. The executor of U3 reports in the PR whether a stored
  step op could be rewritten safely. This is a spec gap already recorded, not new.
- **F5 - existing tests that assert today's behaviour** (spec §10). U3 may need
  `drain.test.ts` / `background-sync.test.ts` updated (union exhaustiveness); U4 must update
  `ticket-attachments-sheet.test.tsx` (the two blocking messages). Updating a test the change
  breaks is not adding a test; say so in the PR.
- **F6 - no cap on queued Attach File bytes** (Q5, the developer's choice). Device storage is
  unbounded by this plan. Say so in U4's PR; do not add a cap.

- **F7 - U3 must keep the 409 branches separate from the generic failure path** (see move 6).
  U5 later inserts the retry count into the generic path only. If U3 merges them, U5 has to
  untangle the 409 handling it never owned.
- **F8 - two inherited-red suites sit in U5's path.** `features/field-ticket/use-ticket-progress.test.ts`
  and `app/(field)/field.test.tsx` are in the nine inherited mobile failures (gate baseline), and
  U5 changes `use-ticket-progress.ts` and the active card that `field.tsx` renders. They cannot
  prove U5 did no harm. The regression checks for those consumers are by hand (U5 *Ripple*), and
  `ticket-card.test.tsx`, `jobs.test.tsx` (both green today) are the existing tests to run.
- **F9 - the "existing offline message" in REQ-12 is not named in the spec.** The tap's failed-probe
  branch shows "the existing offline message". The executor finds the one the Jobs and field screens
  already show for an offline action (`grep -rn "offline" apps/mobile/app/\(field\) apps/mobile/components/field`) and reuses
  its wording; if none fits, stop and raise a spec §12 question. Do not write new copy.
- **F10 - the 15 s timeout loop is the developer's stated consequence, not a bug in U5.** An item
  that always times out (e.g. a large file on a weak link) is resent on every scan, never counted and
  never badged (spec REQ-09, Q12 answer). Say so in the PR; do not add a second signal.

## Gate baseline

**Gate baseline:** *`2026-10-29`, local `staging` at `d87b95c27` (clean tree; contains PR #958,
which `origin/main` at `261db413e` does not; `origin/staging` at `84df053a2` is one web-only
commit ahead, not pulled; `git fetch` could not be relied on, refs as last fetched) — run with
`NODE_OPTIONS=--max-old-space-size=4096`:*

- *`pnpm lint`: **1 error**, in `apps/web` (`ConfirmWonDialog` has too many lines (203, max 200),
  `max-lines-per-function`); api 0 errors (667 warnings), mobile 0 errors (398 warnings), shared
  0 errors (1 warning), web 1 error (336 warnings). Exit 1, from web only.*
- *`pnpm typecheck`: pass (mobile and web).*
- *`pnpm build`: pass.*
- *`pnpm test`: **fail** — api 293 suites / 3419 tests pass; web runners print pass 192 / pass 184,
  fail 0 each, yet Nx reports `@tcg/web:test` failed (cause not isolated, same as the
  2026-10-28 baseline); mobile 9 of 319 suites fail (18 of 3175 tests): `needs-attention-section`,
  `start-work-returned-correction`, `alerts`, `step-dispatch`, `returned-correction-dispatch`,
  `notifications-sheet`, `field`, `quotes/[id]`, `use-ticket-progress`. These nine are the same
  nine as the MOBILE-TICKET-PRESIGNED-IMAGES baseline, several with 15 to 37 s runtimes.*

An executor reports **vs this list**. Re-run a failing mobile suite in isolation before blaming a
unit. None of the nine is a suite U3 or U4 touches (`drain`, `background-sync`,
`ticket-attachments-sheet` all pass today). The web lint error is inherited and is not in any
unit's path.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | A checklist photo (or a replaced signature, lunch or checklist record) deleted on the API leaves its S3 objects removed even when S3 fails at the time: the keys are saved in the same transaction and a worker retries | REQ-03 (mechanism, `deleteOrphaned` and `cleanupReplaced` paths), REQ-04, REQ-05 (part: `deleteOrphaned`, `cleanupReplaced`), REQ-11 | schema, api | — | ~450 lines / ~14 files | built — feat/MOBILE-OFFLINE-DELETE-QUEUE-u1-outbox-worker |
| U2 | The same guarantee holds on every other ticket-attachment delete path (signature, identity, WTL photo, failed upload, Attach File, and the generic `DELETE /attachments/:id` — six sites, folded in by the developer 2026-10-29); a replayed Attach File delete succeeds; a signature-referenced refusal carries its own code | REQ-03 (remaining sites), REQ-05 (the rest: `removeUnreferenced`, `discardObjects`, `TicketAttachmentsService.remove`, D11, D14) | api, shared | U1 | ~250 lines / ~8 files | built — feat/MOBILE-OFFLINE-DELETE-QUEUE-u2-delete-sites |
| U3 | A crew member removes an uploaded checklist or signature photo offline: it vanishes at once, survives an app restart, reaches the server on reconnect; removing a not-yet-uploaded photo cancels both; a refused delete is handled by cause | REQ-01, REQ-02, REQ-07, REQ-08 | mobile, api (header read on two routes) | U2 | ~600 lines / ~16 files | not started |
| U4 | A crew member adds and deletes Attach File files offline; queued rows show "Pending sync"; 50 MB per file, no other cap | REQ-06, REQ-10 | mobile, api (header read on two routes, upload idempotency check) | U3 | ~550 lines / ~9 files | not started |
| U5 | A ticket whose queued item was refused by the server on 4 sends stops retrying by itself and its card (and its completed row in Jobs) shows "Sync failed — tap to retry"; tapping probes the API, resets the count and drains that ticket even when the network flag says offline | REQ-09, REQ-12 | mobile | U4 | ~500 lines / ~10 files | not started |

- **Status** takes exactly one of: `not started` · `in progress — <branch>` · `built — <branch>`
  · `merged — PR #<n>` · `cut — <reason>`. **Never a commit SHA.** `tcg-executor` writes this
  cell for its own unit at the end of every run (its only write to `units.md`, up to `built`);
  `close-ticket` §1 flips `built` to `merged — PR #<n>`.
- Requirements covered: REQ-01..REQ-13, counted against `spec.md` §2 on 2026-10-29 (second pass):
  **13 in spec, 12 covered, 1 not covered.** Each REQ has one owning unit except two split by site:
  **REQ-03** (U1 the mechanism and two paths, U2 the rest) and **REQ-05** (U1 `deleteOrphaned` and
  `cleanupReplaced`, U2 `removeUnreferenced`, `discardObjects`, `remove`, D11, D14). Owners:
  REQ-01, 02, 07, 08 in U3; REQ-09 and REQ-12 in U5; REQ-06 and REQ-10 in U4; REQ-04 and REQ-11 in
  U1. Nothing in a unit lacks a REQ behind it.
- Not covered: **REQ-13** (whether the failed-sync rule covers a failed ticket submit) — `[OPEN]`,
  **Q11**. Spec workaround, honoured by U5: queued ops only; a failed submit
  (`submitState: 'error'`, `submissionPending`, `background-sync.ts:354-362`) keeps today's
  behaviour, is not counted and shows no failed-sync badge. U5 states this in its own
  *Deliberately not in this unit*. REQ-09 (previously unassigned, waiting on Q4) is now assigned to U5.
- Units blocked on an open question: **none.** Q13 is answered (option A, D9 confirmed), so U4 is
  blocked by nothing except Q8 sign-off. U4 carries the executor risk F2 (stop and raise a §12
  question if no draft is reachable from the sheet). Q11 blocks REQ-13 only (no unit). Q8 is sign-off
  of derived acceptance lines, not a build blocker.
- Per-unit ripple: all five units touch already-shipped behaviour. Every ripple row below has a
  named check and a source. **Rows with no source: none.** The assumed sub-case is F4; U5's
  checks on two inherited-red suites are by hand (F8).
- Provider/file overlap: U1 and U2 both edit `ticket-attachment-guard.service.ts` and
  `attachments.repository.ts`, so U2 `Depends on` U1. U3 and U5 both edit the failure branch of
  `drain.ts` and `markRejectedStep` / `replayPendingStep` in `background-sync.ts` (move 6); U5 is
  stacked behind U4 but still builds on U3's 409 branches, so it `Depends on` U4 (and through it U3).
  U3 and U4 both edit `step-ops.ts`, `drain.ts`, the reserved-key ledger code and
  `lib/ticket-draft-sync.ts`, so U4 `Depends on` U3. U4 and U5 both edit `drain.ts`, the ledger code
  in `ticket-flow.store.ts` and `lib/ticket-draft-sync.ts`, so U5 `Depends on` U4 (stack order
  U1, U2, U3, U4, U5).
  U1 and U2 both rely on the new `StorageDeletionQueueRepository`, which U1 creates.

---

## U1 - Outbox table, worker and the first complete delete path (`deleteOrphaned`, `cleanupReplaced`)

- **Outcome:** a checklist photo removed on the phone (or a stale attachment replaced on
  resubmission) has its S3 objects removed even if S3 fails at that moment; the keys are saved in
  the delete's own transaction and a background worker retries until the objects are gone.
- **Kind:** vertical. The model, migration and worker have exactly one consumer after U1 (U2), so
  the foundation exception does not apply; they ship with the first path that uses them.
- **Requirements covered:** REQ-03 (the mechanism; the `deleteOrphaned` and `cleanupReplaced`
  paths), REQ-04 (fully), REQ-05 (part: `deleteOrphaned`, and `cleanupReplaced` through it),
  REQ-11 (fully).
- **Depends on:** —
- **Branch / PR base:** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u1-outbox-worker` from `origin/staging`
  (F1: `origin/main` lacks PR #958).
- **Size estimate:** ~450 source lines, ~14 source files (plus the migration SQL and the
  regenerated `schema.dbml`).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New model `StorageDeletionJob` (`@@map("storage_deletion_queue")`) and enum `StorageDeletionJobStatus` (`PENDING`, `PROCESSING`, `COMPLETED`, `FAILED`) as in spec §3 and D2/D13: `id` UUID, `tenantCompanyId` FK, `objectKeys String[]`, `status`, `attempts`, `maxAttempts` (8), `lastError`, `nextRetryAt`, `completedAt`, `createdAt`, `updatedAt`; indexes `idx_storage_deletion_queue_poll` on `[status, nextRetryAt]` and `idx_storage_deletion_queue_tenant`; **no FK to `attachments`** | Committed migration under `apps/api/prisma/migrations/` (`pnpm db:migrate`), and regenerate `schema.dbml` (`pnpm db:dbml`, as `c0d18f9de`). Additive, no backfill |
| Tenant scope (G3) | Add `storagedeletionjob` to `TENANT_SCOPED_MODELS` in `apps/api/src/orm/prisma.service.ts:26` (`payrollcalculationjob` is at line 201 for reference) | `prisma.service.spec.ts` fails otherwise. **`tcg-prisma-guardian` runs on this unit** |
| API: repository | `StorageDeletionQueueRepository` in `apps/api/src/service/storage-deletion/` (+ barrel `index.ts`): `enqueueIn(tx, tenantCompanyId, keys)`, claim by id (conditional update, for the immediate attempt), `claimNextJob` batch of 25 with `FOR UPDATE SKIP LOCKED`, `reclaimStaleJobs` (PROCESSING over 5 min), `markCompleted`, `markFailed` with the doubling backoff (60 s, 2, 4, 8, 16, 32, 64 min; `maxAttempts` 8) | Mirror `payroll-calculation-queue.repository.ts`. Numbers are D3 (AI decisions, reviewable); do not re-derive |
| API: worker | `StorageDeletionQueueService` in `apps/api/src/usecase/storage-deletion/` (+ barrel): `@Interval(10_000)` poll that reclaims stale claims, claims a batch, runs each job under `TenantContextService.run` (D6), calls `S3StorageService.deleteObject` per key, completes or marks failed; `attemptNow(jobId)` for the immediate try (D5); empty key list completes with no S3 call; an absent key counts as success | **REQ-11:** when a job reaches `maxAttempts` the row stays `FAILED` with `lastError` and **one error-level log line naming the job id**; a job with no recorded error logs "unknown error"; nothing re-queues a FAILED row. Mirror `payroll-calculation-queue.service.ts` |
| API: module | `StorageDeletionModule` (repository + worker), registered in `app.module.ts` (`ScheduleModule.forRoot()` is already there, `app.module.ts:155`) | Barrel `index.ts` at each new folder |
| API: first site | `AttachmentsRepository` gains one method that deletes the attachment row and calls `enqueueIn(tx, …)` in a single `$transaction`; `TicketAttachmentGuardService.deleteOrphaned` uses it and then calls `attemptNow` after commit, never failing the request on an S3 error; `cleanupReplaced` is covered because it calls `deleteOrphaned` (`ticket-attachment-guard.service.ts:383`) | The private `deleteObjects` swallow is removed from this path. Keys come from `ticketImageObjectKeys(fileName)`. A row whose `fileName` yields no keys creates no job; an unknown attachment id keeps today's idempotent return (no row, no job) |
| API: DI | `TicketAttachmentGuardService` gains the outbox repository/service in its constructor; import `StorageDeletionModule` in all five modules that provide the guard: `ticket-signatures`, `ticket-lunch-breaks`, `checklist-assignments`, `ticket-attachments`, `ticket-incidents` | F3. **Boot `pnpm api:dev` once**: a missing provider fails only at boot, not at lint, build or jest (`contexts/api.md` → Testing) |
| Web / Mobile / Shared | N/A — none | no web or E2E caller of the DELETE routes (spec §5); mobile is untouched in this unit |
| Tests | not requested | run the existing suites; `prisma.service.spec.ts` and the guard's existing spec must stay green |

### Reviewable as

- **Demo:** on a dev database with S3 made to fail (invalid credentials or a stubbed
  `deleteObject`), upload a checklist photo, then `DELETE /api/v1/field/tickets/:id/checklists/attachments/:attachmentId`.
  The call answers `204`; the attachment row is gone; one `storage_deletion_queue` row is `PENDING`
  holding the original key and its preview key, `attempts` growing on the worker's beat. Restore S3:
  within one poll after `nextRetryAt` the objects are gone and the row is `COMPLETED`. With S3
  failing for every attempt the row ends `FAILED` with `lastError` and a single error log line.
  Force the row delete to throw inside the transaction: no job row exists.
- **Acceptance:** REQ-03 (job holds every key; rollback leaves no job), REQ-04 (request succeeds with
  S3 down; retries; completes after recovery), REQ-11 (FAILED kept and logged), REQ-05 for the
  `deleteOrphaned` and `cleanupReplaced` paths. All derived, unconfirmed (Q8).
- **Reviewer can verify without:** U2, U3, U4, any mobile build, any seed data beyond one ticket
  with a checklist photo.

### Risk

- **Weakest source:** `[UNVERIFIED]` (every covered REQ). REQ-03, 04, 05, 11 rest on the
  developer's 2026-10-29 decision and answers, relayed and not yet in `.ai/vault/decisions/`.
- **Migration reversible:** yes in practice — the migration only adds a table and an enum; nothing
  reads or writes it before this unit, so a revert drops them. Not a one-way migration.
- **Behind a flag:** no.
- **Touches existing data:** no. No backfill; existing orphaned objects are not swept (G2, spec §13).
- **Unverified plus costly to undo:** the **table and enum names** (D13, "cheap to change before the
  migration is committed", expensive after another migration references them) and the **worker
  numbers** (D3, no source). Both are AI decisions awaiting review; the developer reviews D3 and D13
  in this PR before it merges. Settle by reading spec §11b D3 and D13; nothing else sources them.
- **Blast radius:** a worker that errors on every tick floods logs and S3 calls; a missing
  `StorageDeletionModule` import breaks boot of any module that provides the guard. Checklist photo
  deletion on a request path now writes one extra row inside its transaction; if the insert fails,
  the delete fails (by design, D4).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `checklist-assignments.service.ts:521` `removeItemPhoto` and the mobile checklist-photo remove | `deleteOrphaned` | existing `pnpm api:test` suites for the guard and checklist assignments; by hand: the Demo above, then `DELETE` again with the same id (still `204`) | `spec.md` REQ-05; `intent.md` §3 |
| Resubmission cleanup callers: `ticket-signatures.service.ts:239`, `ticket-lunch-breaks.service.ts:321` and `383`, `checklist-assignments.service.ts:662` | `cleanupReplaced` then `deleteOrphaned` | results unchanged (callers do not read the outcome); by hand: resubmit a signature, confirm the replaced row's objects are queued then removed and the new one is untouched | `spec.md` REQ-05, §11a row 5 |
| `TicketAttachmentGuardService` constructor in all five modules | constructor change | `pnpm api:dev` boots with no DI error; `pnpm api:build` | `spec.md` §4 Module registration |
| `TENANT_SCOPED_MODELS` and `prisma.service.spec.ts` | new model | `pnpm api:test` runs `prisma.service.spec.ts` | `contexts/prisma.md`; root `CLAUDE.md` G3; `spec.md` §11a row 9 |
| Existing `@Interval` pollers (`payroll-calculation-queue.service.ts`, `quotation-expiry.service.ts`) | `ScheduleModule` | `grep -rn "Interval(" apps/api/src --include=*.ts` before starting; no shared state with the new worker | `spec.md` REQ-04 Ripple (new surface) |
| Web and `qa-automation` | the DELETE routes | `grep -rn "checklists/attachments\|signatures/attachments" qa-automation` and `grep -rn "field/tickets" apps/web/src` return nothing (spec §5) | `spec.md` §5 |

**Gates (vs baseline):** `NODE_OPTIONS=--max-old-space-size=4096` then `pnpm api:lint`,
`pnpm api:build`, `pnpm api:test` (incl. `prisma.service.spec.ts` and the existing guard and
checklist specs); `pnpm db:migrate` then confirm the migration folder is committed and
`pnpm db:dbml` leaves `schema.dbml` regenerated; `tcg-prisma-guardian` on the model and the
`TENANT_SCOPED_MODELS` entry; boot `pnpm api:dev` once. No mobile or shared change, so no
`pnpm typecheck` run is required beyond `pnpm api:build`.

### Deliberately not in this unit

- `removeUnreferenced`, `discardObjects` and `TicketAttachmentsService.remove` enqueueing, D11 and
  D14 — **U2**. Until U2 merges these three still swallow a failed S3 delete exactly as today
  (deferred slices, not broken consumers).
- Any mobile change — U3 and U4.
- Purging COMPLETED rows, a list or notification for FAILED rows, re-queuing a FAILED row — spec
  §13, later tickets (retention is `NOT SPECIFIED`).
- Sweeping objects already orphaned — spec §13, separate ticket (G2).
- The sibling entity-photo swallows (`attachment-photos.service.ts:446`, `attachments.controller.ts:260`,
  `signed-copy-attachments.service.ts:223`) — spec §11c follow-ups.

---

## U2 - Every other ticket-attachment delete path uses the outbox; replayed Attach File delete succeeds; own code for the signature-referenced 409

- **Outcome:** a signature, identity photo, lunch WTL photo, failed upload or Attach File file
  deleted on the API also has its S3 objects removed with retry; an Attach File delete replayed
  after a lost response answers `204`; a delete refused because a saved signature still points at
  the image carries `code: 'ATTACHMENT_IN_USE'`, distinct from `TICKET_WINDOW_CLOSED`.
- **Kind:** vertical (API behaviour change at the remaining delete sites plus the error body).
- **Requirements covered:** REQ-03 (the remaining sites), REQ-05 (the rest: `removeUnreferenced`,
  `discardObjects`, `TicketAttachmentsService.remove`, D11, D14).
- **Depends on:** U1 (the repository, worker and module; both units edit
  `ticket-attachment-guard.service.ts` and `attachments.repository.ts`).
- **Branch / PR base:** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u2-delete-sites` stacked on
  `feat/MOBILE-OFFLINE-DELETE-QUEUE-u1-outbox-worker` while U1's PR is open.
- **Size estimate:** ~250 source lines, ~8 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — none | the model exists from U1 |
| API: `removeUnreferenced` | `AttachmentsRepository.removeIfUnreferenced` inserts the outbox row **inside its existing `$transaction`** (`attachments.repository.ts:66-84`) via `enqueueIn(tx, …)`; the service calls `attemptNow` after commit; the swallowing `deleteObjects` call goes | The signature-referenced 409 throws before the delete, so **no job** in that case; an unknown id still returns with no job |
| API: D14 | The signature-referenced refusal throws `new ConflictException({ message, code })` with the existing message text unchanged ("This image is part of a saved signature and cannot be removed") and `code: TICKET_ATTACHMENT_ERROR_CODES.ATTACHMENT_IN_USE` | Same body shape as the window guard (`job-tickets.service.ts:1873-1876`). The window-closed 409 is not changed |
| Shared (`packages/shared`) | `TICKET_ATTACHMENT_ERROR_CODES` (`ATTACHMENT_IN_USE`) beside `TICKET_WINDOW_ERROR_CODES` in `packages/shared/src/utils/ticket-completion-window.ts:62`, exported through `packages/shared/src/utils/index.ts` | One constant. `@tcg/shared` is consumed as built `dist/`: build it before API and mobile gates. Name and home are AI-chosen (D14), reviewable |
| API: `discardObjects` | `discardObjects` (the failed-upload cleanup, callers `ticket-attachment-guard.service.ts:191` and `:199`) inserts the job **alone** (no row exists to share a transaction with, D4); if that insert itself fails it falls back to today's best-effort delete and logs | Keeps the upload error path from failing a second time |
| API: fifth site (D7) | `TicketAttachmentsService.remove` (`ticket-attachments.service.ts:150-166`) deletes the row and enqueues in one transaction, then `attemptNow`; the inline per-key swallow loop goes | Uses the repository method from U1 where it fits |
| API: D11 | `TicketAttachmentsService.remove`: a **missing attachment id returns `204`** (no throw); a row that exists but belongs to another ticket still returns `403` (the same split as `removeItemPhoto`) | Today a missing id answers `403` (`ticket-attachments.service.ts:208-229`, "deliberately Forbidden"); this is the one changed error case on an existing route |
| API: DI | `TicketAttachmentsService` constructor gains the outbox provider; `ticket-attachments.module.ts` already imports `StorageDeletionModule` from U1 (it provides the guard) | **Boot `pnpm api:dev` once** |
| Web / Mobile | N/A — none | The only reader of the new `code` is the mobile drain, changed in U3 (below, **Sequencing**) |
| Tests | not requested | existing `ticket-attachments.service.spec.ts` asserts today's `403` on a missing id and is expected to need updating (spec §10: updating a test the change breaks is not adding one) — check and say so in the PR |

### Reviewable as

- **Demo:** with S3 failing, (1) delete a signature's identity photo that no signature row points at
  via `DELETE …/signatures/attachments/:id` -> `204` and a pending job; (2) `DELETE
  /api/v1/field/tickets/:id/attachments/:id` for a real Attach File file -> `204` and a pending job;
  repeat the same call with the now-unknown id -> `204` (was `403`); (3) `DELETE` an image a saved
  signature points at -> `409` whose body is `{ message, code: 'ATTACHMENT_IN_USE' }`, no job; (4)
  after the window closes, `DELETE` -> `409` with `TICKET_WINDOW_CLOSED`, unchanged; (5) force a
  failed upload (`storeUpload` after objects were written) -> a pending job for the leftover keys.
  `grep -rn "deleteObject(" apps/api/src/usecase apps/api/src/service` shows no call on a ticket
  attachment path outside the outbox worker and its immediate attempt.
- **Acceptance:** REQ-05 acceptance lines (grep result, each path with S3 failing, unknown id `204`,
  new code on the signature 409, `TICKET_WINDOW_CLOSED` unchanged); REQ-03 for these sites.
  Derived, unconfirmed (Q8).
- **Reviewer can verify without:** U3, U4, any mobile build.

### Risk

- **Weakest source:** `[UNVERIFIED]`. D7 and D11 are confirmed by the developer (session
  2026-10-29), D14 is an AI decision; REQ-05's sources are all relayed answers.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Unverified plus costly to undo:** the **`ATTACHMENT_IN_USE` string** becomes part of a published
  error body that a shipped mobile build will branch on (U3). It is additive and the constant is
  one line to rename before U3 merges, expensive after a mobile build ships. Settle by the
  developer confirming the constant name (spec D14, "reviewable") before U3 is built.
- **Blast radius:** D11 turns a `403` into `204` for a missing id on the Attach File route; any
  client that relied on the `403` to learn the id was gone sees success instead (none known: the only
  mobile caller is `useDeleteTicketAttachment`). A bad transaction edit in `removeIfUnreferenced`
  could stop signature photos from being deletable.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `removeUnreferenced` callers: `ticket-signatures.service.ts:259`, `ticket-lunch-breaks.service.ts:566` | `AttachmentsRepository.removeIfUnreferenced` | existing signature and lunch specs via `pnpm api:test`; by hand: remove a lunch WTL photo and an unreferenced signature photo, both `204` | `spec.md` REQ-05 |
| `discardObjects` callers inside `storeUpload` (`ticket-attachment-guard.service.ts:191`, `:199`) used by all five modules | failed-upload path | upload a file that fails validation after write; upload still returns its original error | `spec.md` REQ-05, §11a row 5 |
| `TicketAttachmentsService.remove` and mobile `useDeleteTicketAttachment` / the Attach File sheet | fifth site, D11 | `ticket-attachments.service.spec.ts`; by hand: delete a file from the sheet online (still removed), cross-ticket id still `403` | `spec.md` D7, D11 (confirmed 2026-10-29); §11a row 6 |
| Mobile drain's reading of every 409 as "request approval" (`drain.ts:162-170`) | the new `code` on the signature-referenced 409 (D14) | `tcg-contract-tracer` on U2 (precaution, G5: error body only); the old app still reads any 409 as it does today — not made worse (spec §11); read `grep -rn "getHttpStatus\|=== 409" apps/mobile --include=*.ts --include=*.tsx \| grep -v test` | `spec.md` D14, §11a row 12 |
| Other readers of `TICKET_WINDOW_ERROR_CODES` / `packages/shared` utils barrel | shared export added, none changed | `pnpm --filter @tcg/shared build` then `pnpm typecheck` | `spec.md` §7 |

**Gates (vs baseline):** `NODE_OPTIONS=--max-old-space-size=4096` then `pnpm api:lint`,
`pnpm api:build`, `pnpm api:test`; `pnpm --filter @tcg/shared build` then `pnpm typecheck`;
`tcg-contract-tracer` on the changed 409 body (precaution); boot `pnpm api:dev` once.

**Cross-surface window (Sequencing rule):** between U2 and U3 merging, the API sends
`ATTACHMENT_IN_USE` and no shipped mobile build reads it. During that window a mobile build reads
the signature-referenced 409 as "window closed", exactly as today. Nothing is broken that works
now.

### Deliberately not in this unit

- The mobile reading of the new code (drop the op, restore the photo, tell the crew) — **U3**.
- `X-Captured-At` on the delete routes — U3 (checklist, signature) and U4 (Attach File).
- Entity-photo and other swallows (§11c) — follow-ups.

---

## U3 - Offline delete of an uploaded checklist or signature photo, end to end

- **Outcome:** a crew member removes an already-uploaded checklist or signature photo with the
  phone offline: the photo is gone from the screen at once, the removal survives force-quitting the
  app, it is sent when the phone is back online, and its S3 objects end up deleted; removing a
  photo whose upload is still queued cancels both; a delete the server refuses is handled by cause.
- **Kind:** vertical (mobile op, its drain, and the two API routes that now honour the capture
  time). **First unit with crew-visible value.**
- **Requirements covered:** REQ-01, REQ-02, REQ-07, REQ-08 — fully. (REQ-08's API half, the code,
  shipped in U2.)
- **Depends on:** U2 (the `TICKET_ATTACHMENT_ERROR_CODES` constant in built `@tcg/shared`, and the
  rollout order of spec §11).
- **Branch / PR base:** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u3-mobile-delete-op` stacked on
  `feat/MOBILE-OFFLINE-DELETE-QUEUE-u2-delete-sites` while U2's PR is open.
- **Size estimate:** ~600 source lines, ~16 source files. The largest unit; see *Slicing decision*
  for the carve-out if review demands it.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Mobile: op kind | `apps/mobile/features/field-ticket/sync/step-ops.ts`: new `StepSyncOpBody` kind `deleteAttachment` with `target: 'checklist' \| 'signatures'` and the **server** attachment id (D8); stamped with `capturedAt` like every op; `sendOp` calls the existing service methods `services.checklists.deleteItemPhoto` / `services.ticketSignatures.deleteAttachment` with the capture time as `X-Captured-At` (`RequestOptions.capturedAt`) | An entry is never created without a server id. U4 later adds the `attachments` target |
| Mobile: where it is stored | In the draft's sync ledger under **one reserved non-step key** for deletes (D9); drains after the flow steps, in queue order inside the key (`orderedUnsynced`, `drain.ts:88-104`) | Executor checks (D9 risk): `ticketNeedsSync`, `hasUnsyncedSteps`, `findStepDiscrepancies` (`verify.ts`), `markStepSyncedIfUnchanged`, `repair-ops.ts`, `checklist-ops.ts`, `start-work-ops.ts`, `ticket-flow.store.ts`, `ticket-step-screen.tsx` must treat the key as unsynced work and never read it as a step; every exhaustive switch gains the kind (`grep -rln "StepSyncOp\|runStepOps\|sendOp" apps/mobile`) |
| Mobile: hook | `components/capture/use-photo-removal.ts`: for an uploaded photo (a `local:` id with `serverId`, or a server id) queue the delete op and return `{ ok: true }` at once (REQ-01/02); online success leaves no queue entry; mock mode (`mode !== 'real'`) and no `ticketId` stay no-ops; return type unchanged | Callers `deficiency-panel.tsx:156`, `signer-capture.tsx:118`, `ChecklistEngine.tsx:1301` keep their contract (clear local UI whatever the outcome, `use-photo-removal.ts:23-26`) |
| Mobile: hidden until it lands | A removed photo stays out of the lists rebuilt from cached ticket and attachment queries until the delete lands (REQ-02) | Executor check: pull-to-refresh and the persisted query cache (`lib/query-persistence.ts`, 3 days) must not bring it back |
| Mobile: cancel both (REQ-07, D15) | `use-photo-removal.ts`: a `local:` id with no `serverId` whose upload is still queued: drop its ledger upload reference and local file (`discardLocalAttachment`, `local-attachments.ts:91`) and queue **no** delete; a `local:` id with no ledger entry is treated as already gone | The completed-step sub-case (id still named by a stored step write, `isLocalAttachmentStillSent`) keeps today's behaviour (F4, ASSUMED) |
| Mobile: sweep | `features/field-ticket/sync/use-ticket-outbox.ts:41-65`: replace the fire-and-forget `deleteItemPhoto` / `deleteAttachment` calls with queueing the same op | The `.catch(() => {})` swallow goes. Entries with `target` other than `checklist` / `signatures` are left alone |
| Mobile: 409 split (REQ-08, D14) | `sendOp`'s delete branch and `drain.ts:162-170` (+ the `background-sync.ts` drain path): on `409` with `code === TICKET_ATTACHMENT_ERROR_CODES.ATTACHMENT_IN_USE` drop the op, restore the photo in the UI by re-reading the ticket's server data and putting the local reference back, show the server's existing message through `formatApiError`, and keep draining later ops; on `409` with `code: 'TICKET_WINDOW_CLOSED'` keep the op queued and show the existing "Request approval" path (`needsEditRequest`), photo stays hidden; a `409` with **no** code keeps today's behaviour; `DAY_START_LOCKED` unchanged; `403`/`404`/"gone" counts as done (D10) | No new copy (message text `NOT SPECIFIED`, spec REQ-08 notes). Both drain callers: open-ticket drain and the background scan. **Keep these 409 branches separate from the generic failure-marking path** (`markStepFailed` / `markRejectedStep`): U5 later adds the retry count to the generic path only, and a 409 must never reach it (F7, move 6). Lines `drain.ts:162-171` and `background-sync.ts:177-201`, `:232-252` are edited again by U5 |
| API: header read | `field-tickets.controller.ts:398` (checklist photo DELETE) and `:590` (signature attachment DELETE) read `@Headers('x-captured-at')` through `parseCapturedAtHeader` (as lines 211, 238, 274 do) and pass it down as `TicketWriteWindowOptions` to `getTicketForEmployeeAction(…,'write')` in `checklist-assignments.service.ts` `removeItemPhoto` and `ticket-signatures.service.ts` `removeAttachment` | Makes a queued delete that arrives after 24h but inside the 72h L17 grace be accepted and audited (`TICKET_LATE_CAPTURE_ACCEPTED`). Additive header, `204` unchanged, no G5 shape change. The lunch-break route (`:674`) has no mobile caller and is not changed |
| Shared (`packages/shared`) | N/A — none (the constant shipped in U2) | build `@tcg/shared` before mobile gates |
| Tests | not requested | `drain.test.ts` and `background-sync.test.ts` may fail on union exhaustiveness (spec §10): updating them is not adding tests; say so in the PR |

### Reviewable as

- **Demo:** on a device or simulator with a real-camera build: (1) airplane mode on, open a ticket
  with an uploaded checklist photo, tap Remove: it leaves the screen immediately; force-quit and
  reopen: still gone; restore the connection: within one drain a `DELETE` reaches the API (API log),
  the row is gone and a `storage_deletion_queue` job exists (U1/U2). (2) Airplane mode on, take a
  photo, remove it before reconnecting: after reconnect no upload and no delete request for it reach
  the server and no S3 object exists. (3) Queue a delete of an image a saved signature points at:
  after reconnect the op is gone, the photo is back, the crew sees the server's message, later ops
  still drain. (4) Queue a delete, let the window close, reconnect: the op stays, "Request approval"
  shows, and an approval lets the same op send. (5) Online, tap Remove: the photo goes and no queue
  entry remains.
- **Acceptance:** REQ-01, REQ-02, REQ-07, REQ-08 acceptance lines (all derived, unconfirmed: Q8).
- **Reviewer can verify without:** U4, any Attach File screen, the web app.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-07, 08, 02) and `[CONFLICT]` (REQ-01 sits under the
  field-ops three-way conflict; this work takes no side and takes its behaviour from the ticket and
  the 2026-10-29 answers, not from FR-TCG-FOP-001).
- **Migration reversible:** N/A — no migration. The on-device ledger shape gains a reserved key; an
  older app build ignores it (it never wrote one).
- **Behind a flag:** no.
- **Touches existing data:** device-local only. Existing drafts have no reserved key; none is added
  until a delete is queued.
- **Unverified plus costly to undo:** the **persisted shape of the queued delete op** (and its reserved
  ledger key name) is written into users' AsyncStorage and survives app updates. Changing it later
  needs a migration of stored drafts. The shape is D8/D9 (AI decisions, reviewable). The developer
  reviews D8 and D9 before this unit is built; settle by reading spec §11b D8 and D9.
- **Blast radius:** `StepSyncOp` is read by the drain for every ticket step; a missed exhaustive
  switch or a ledger reader that treats the reserved key as a step could stall draining of real step
  ops (the first failure stops a draft, `drain.ts:162-171`). A mis-handled 409 could drop a
  window-closed delete or wedge the queue behind it.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `use-ticket-outbox.ts:41-65` post-drain sweep | the new op | by hand: take a photo, retake it after its step was stored, reconnect: the stale upload is queued for delete and sent; the existing `use-ticket-outbox` flows still sync steps | `spec.md` §11a row 1, D9; `intent.md` §3 |
| `usePhotoRemoval` callers `deficiency-panel.tsx:156`, `signer-capture.tsx:118`, `ChecklistEngine.tsx:1301` | hook contract (same return type) | remove a photo from each of the three screens, online and offline | `spec.md` §11a row 2; `intent.md` §4 |
| `StepSyncOp` consumers: `step-ops.ts`, `drain.ts`, `background-sync.ts`, `repair-ops.ts`, `checklist-ops.ts`, `start-work-ops.ts`, `ticket-flow.store.ts`, `ticket-step-screen.tsx` | a 12th kind | `pnpm typecheck` (exhaustive switches); existing `drain.test.ts` / `background-sync.test.ts` run in isolation; by hand: a full ticket flow offline then online still drains every step | `spec.md` §11a row 3 |
| `verify.ts` `findStepDiscrepancies` and `lib/ticket-draft-sync.ts` (`ticketNeedsSync`, `hasUnsyncedSteps`, `hasUnsyncedAttachments`) | reserved ledger key | by hand: queue a delete, open Review: the pre-submit check does not flag a phantom step and `ticketNeedsSync` is true until the delete lands | `spec.md` §11a row 7 |
| The drain's reading of every 409 as "request approval" (`drain.ts:162-170`) and the background scan | REQ-08 | by hand: the four-case Demo (3), (4); a day-start 409 (`DAY_START_LOCKED`) still takes its own path | `spec.md` REQ-08, §11a rows 11 and 12 |
| Cached ticket / attachment queries (`useTicketAttachments`, `lib/query-persistence.ts`) | hidden-until-landed | by hand: remove offline, pull to refresh offline: photo stays gone | `spec.md` §11a row 9, REQ-02 |
| The checklist and signature DELETE routes and `getTicketForEmployeeAction` | new optional header | by hand: `DELETE` with and without `X-Captured-At` both `204`; a delete inside 72h of the window's end and 24h past it is accepted and audited | `spec.md` REQ-01 notes, L17 |

**Gates (vs baseline):** `NODE_OPTIONS=--max-old-space-size=4096` then `pnpm api:lint`,
`pnpm api:build`, `pnpm api:test` (controller and service specs for the two routes);
`pnpm --filter @tcg/shared build` then `pnpm typecheck`; `pnpm mobile:lint`; mobile `jest` for
the touched suites (`features/field-ticket/sync`, `components/capture`, the three caller screens),
each run in isolation and compared with the nine inherited failures. Boot `pnpm api:dev` only if
a provider or module changed (not expected). No new tests.

### Deliberately not in this unit

- The Attach File sheet (add and delete offline, "Pending sync", the `attachments` target of the op) — **U4**.
- The lunch-break attachment delete (`ticketLunchBreaks.deleteAttachment`) — no mobile caller exists; wire it when one does (spec §11c).
- Rewriting a stored step op that still names a removed photo — F4, ASSUMED, reported in the PR.
- The retry counter, the "did the server answer" test, the stop rule, the failed-sync badge and the retry tap (REQ-09, REQ-12) — **U5**. Until U5 merges, the reserved delete key is retried at every drain and scan exactly as a failed step is today (existing behaviour, not a regression).
- A failed ticket submit under the failed-sync rule — REQ-13, **blocked on Q11**; not in any unit.

---

## U4 - Attach File sheet queues uploads and deletes offline

- **Outcome:** a crew member adds files to a ticket and deletes files through Attach File with
  the phone offline: no reconnect message, the row appears (or disappears) at once, queued rows
  show "Pending sync", and the changes reach the server when the phone is back online without
  duplicates.
- **Kind:** vertical (mobile sheet, queue, and the two API routes that honour the capture time).
- **Requirements covered:** REQ-06, REQ-10 — fully. (The cancel-both rule for a queued Attach File
  upload removed before reconnect is REQ-07 "same answer, same behaviour", ASSUMED in the spec for
  this sheet; built here, flagged in the PR.)
- **Depends on:** U3 (the op kind, the drain, the 409 split and the reserved-key ledger code; both
  units edit `step-ops.ts`, `drain.ts` and `lib/ticket-draft-sync.ts`). Also relies on U2's D11 (a
  replayed Attach File delete answers `204`). Blocked by nothing except Q8 sign-off: Q13 is answered
  (option A, D9 confirmed by the developer).
- **Executor risk (F2):** the sheet receives only `ticket.id` and sits outside the flow store. The
  executor confirms a draft exists or can be created for the ticket from the sheet. **If it cannot,
  stop and raise a new spec §12 question; do not build a second queue.** (First pass: U4 on U3;
  second pass: on U5 while Q13 was open; restored to U3, move 7.)
- **Branch / PR base:** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u4-attach-file-queue` stacked on
  `feat/MOBILE-OFFLINE-DELETE-QUEUE-u3-mobile-delete-op` while U3's PR is open.
- **Size estimate:** ~550 source lines, ~9 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Mobile: queue storage | **Follow spec D9 (confirmed by the developer, Q13 answered A):** a second reserved non-step ledger key in the draft's sync ledger holds Attach File upload ops, beside the delete key from U3 | F2 executor risk: confirm a draft exists or can be created when the sheet is used. If not, **stop and raise a new §12 question; do not build a second queue** |
| Mobile: delete | `deleteAttachment` op gains `target: 'attachments'`; `sendOp` calls `services.ticketAttachments.remove` with `X-Captured-At`; the sheet's `deleteAttachment` (`ticket-attachments-sheet.tsx:209-212` block removed) queues the op when offline and removes the row from the list at once; a queued delete is not marked | A delete replayed after a lost response must succeed: it relies on U2's D11 |
| Mobile: upload | New upload op for a picked file: holds the local file reference and a **stable client upload id** so a retry after a lost response does not duplicate it; `pickAndUpload` (`ticket-attachments-sheet.tsx:118-121` block removed) queues instead of returning "Offline — reconnect to attach files"; online keeps today's direct upload and progress display | Executor check: the ticket-attachment upload route's current idempotency (`TicketAttachmentsService` at `ticket-attachments.service.ts:121` calls `storeUpload`; `clientUploadId` handling exists for the image routes, `ticket-attachment-guard.service.ts:117`). If the route is not idempotent, the fix to the route is part of **this** unit and is named in the PR |
| Mobile: limits and marker (REQ-10) | The existing per-file cap `TICKET_ATTACHMENT_MAX_BYTES` = 50 MB (`packages/shared/src/constants/attachments.ts:5`) applies offline too, using the existing refusal message (`partitionUploads`, `ticket-attachment-file.ts`); **no count cap, no total cap**; a file with no reported size passes as today; a queued upload row carries the text **"Pending sync"** (exact) until it reaches the server, styled from `theme/tokens.ts`, 48 px for anything tappable | Say in the PR that device storage is unbounded by this plan (F6); do not add a cap. A queued delete shows no marker (the row is removed at once) |
| Mobile: cached list | `useTicketAttachments` / persisted query cache: a removed file does not reappear before its delete lands; a queued add shows in the list with the marker; on reconnect the marker disappears per file and the list matches the server | Executor check (REQ-02 applied to this sheet) |
| Mobile: cancel both | A queued Attach File upload removed before reconnect: drop the upload op and its local file; nothing is sent | REQ-07 applied to this sheet (ASSUMED in the spec; confirm in review) |
| Mobile: 409 | The U3 split applies to the `attachments` target: `409` with `TICKET_WINDOW_CLOSED` keeps the op and shows "Request approval"; `403`/`404` counts as done | `ATTACHMENT_IN_USE` is not thrown on this route |
| Mobile: read-only | `readOnly` still returns before any queueing (`ticket-attachments-sheet.tsx:116`, `:207`) | unchanged |
| API: header read | `field-tickets.controller.ts:540` (Attach File DELETE) and the Attach File upload route read `X-Captured-At` through `parseCapturedAtHeader` and pass it to the window guard in `ticket-attachments.service.ts` | Without it a late queued upload or delete would be refused after 24h even inside the 72h grace (spec REQ-06 notes). Additive header, no shape change |
| Shared (`packages/shared`) | N/A — none | the cap constant already exists |
| Tests | not requested | the existing `components/field/ticket-attachments-sheet.test.tsx` asserts the two blocking messages and will fail: update it (not a new test); say so in the PR |

### Reviewable as

- **Demo:** airplane mode on, open a ticket, Attach File: pick three files -> three rows, each with
  "Pending sync", no reconnect message; pick a file over 50 MB -> the existing size message; delete an
  existing file -> the row goes at once; force-quit and reopen: queue intact. Restore the connection:
  markers disappear as each file reaches the server, the deleted file is gone on the server, the list
  matches the server and no duplicate exists (retry a drain after a simulated lost response and recount).
  Remove a queued (not yet sent) file before reconnecting: nothing is sent for it.
- **Acceptance:** REQ-06 and REQ-10 acceptance lines (derived, unconfirmed: Q8).
- **Reviewer can verify without:** the checklist and signature screens, U1/U2 beyond a running API.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-10) and `[CONFLICT]` (REQ-06, same field-ops stub as REQ-01).
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** device-local only; queued files occupy device storage until sent.
- **Unverified plus costly to undo:** the **persisted shape of a queued upload op** and its reserved
  key are written to AsyncStorage like U3's delete op. D9 decides them; changing later needs a stored-draft
  migration. D9 is a confirmed developer decision (Q13 answered A, 2026-10-29).
- **Blast radius:** a duplicate upload after a retry (no idempotency) leaves two files; a draft that
  cannot be reached from the sheet (F2) stops the unit until a §12 question is answered; unbounded queued bytes can fill a phone
  (accepted by the developer, Q5).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `components/field/ticket-attachments-sheet.tsx` online upload and delete, and its caller `ticket-details.tsx:182` | the two offline blocks removed | online: add and delete a file as today; `ticket-attachments-sheet.test.tsx` (updated) run in isolation; `readOnly` sheet still blocks | `spec.md` REQ-06 Ripple, §11a row 8 |
| `ticket-attachment-file.ts` (`partitionUploads`, the 50 MB gate) and `compressImageFile` | reused offline | pick an over-50 MB file online and offline: same message | `spec.md` REQ-10; §9 |
| `deleteAttachment` op, drain, ledger readers (U3's rows) | a second target and a second reserved key | `pnpm typecheck`; `drain.test.ts` / `background-sync.test.ts`; the U3 Demo still passes | `spec.md` §11a rows 3 and 7 |
| The Attach File DELETE and upload routes | optional `X-Captured-At` | by hand: both with and without the header succeed; one late-captured op is accepted and audited | `spec.md` REQ-06 notes, L17 |
| `use-incident-report.ts` and `app/(sales)/quotes/create.tsx` (comment-only references to the sheet's `pickAndUpload`) | none — they do not import the sheet | `grep -rn "ticket-attachments-sheet\|TicketAttachmentsSheet" apps/mobile` finds only `ticket-details.tsx` and the sheet's own test as importers | `spec.md` §11a row 8 |
| Cached attachment list on the phone | marker + hidden-until-landed | by hand: offline add/delete then pull to refresh | `spec.md` §11a row 9 |

**Gates (vs baseline):** `NODE_OPTIONS=--max-old-space-size=4096` then `pnpm api:lint`, `pnpm api:build`,
`pnpm api:test` (incl. `ticket-attachments.service.spec.ts`); `pnpm --filter @tcg/shared build`
then `pnpm typecheck`; `pnpm mobile:lint`; mobile `jest` for `components/field/ticket-attachments-sheet.test.tsx`
and `features/field-ticket/sync` in isolation, compared with the nine inherited failures.
No new tests.

### Deliberately not in this unit

- Any cap on file count or total bytes — the developer chose none (Q5).
- Any marker on a queued delete — none was asked (Q6).
- Copy beyond the exact text "Pending sync" and the existing messages — `NOT SPECIFIED`.
- Offline behaviour of any other sheet or screen — no source; Q4 was answered as the retry rule (REQ-09, U5), not as a list of further queue changes.
- The retry counter and the failed-sync badge for Attach File items — **U5** (stacked on U4; it covers the Attach File key through the ledger without touching the sheet).

---

## U5 - Retry limit and "Sync failed - tap to retry" (counter, stop rule, badge, tap with API probe)

- **Outcome:** a crew member whose queued item the server has refused on four sends (the first
  send and three retries) sees the ticket's active card and its completed row in Jobs show "Sync
  failed — tap to retry" instead of the app retrying silently for ever; tapping it asks the API
  whether it is reachable, and if it answers, resets the count and drains that ticket, even when the
  phone's network flag says offline. An item the server never answered (timeout, no connection) keeps
  being retried on every scan, uncounted and un-badged.
- **Kind:** vertical, mobile only (ledger, drain, background sync, progress map, two screens).
- **Requirements covered:** REQ-09, REQ-12 — fully. **Not** REQ-13 (a failed ticket submit, Q11).
- **Depends on:** U4 (stack parent; and through it U3). U3 owns the 409 branches and the reserved
  delete key in the lines U5 edits again (move 6); U4 creates the Attach File key and touches the same
  `drain.ts` and ledger files, so U5 stacks behind it. U5 does not change the sheet or the upload op: the
  counter, badge and tap read the ledger generically, so the Attach File key is covered because U4 has
  created it (move 7).
- **Branch / PR base:** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u5-failed-sync-badge` stacked on
  `feat/MOBILE-OFFLINE-DELETE-QUEUE-u4-attach-file-queue` while U4's PR is open.
- **Size estimate:** ~500 source lines, ~10 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Mobile: ledger field | `StepSyncEntry` (`features/field-ticket/ticket-flow.store.ts:69-88`) gains one optional persisted field for the count of **server-refused sends** (read as 0 when absent, the convention of `rev`, lines 80-87). `withStepSync` (`:381-398`) rebuilds the entry from scratch and **must copy the field across state changes**, or every write to the step resets it. New work written to the step (fresh ops queued) resets it (D19 item 5) | Field name is an AI choice, reviewable. Exhausted when the count reaches 4 (1 send + 3 retries, D17). Granularity is one ledger entry, a step's op list or a reserved key's list, not one count per op (D19 item 4) |
| Mobile: "did the server answer" | A small helper used at both failure sites: a failure counts only when `getHttpStatus(err)` (`lib/api-error-formatter.ts:135-149`) is non-null **and** not 409. `null` (timeout, no connection, network error, a local failure such as a gone file) is not counted; an interrupted or aborted run (`Ticket sync interrupted`, `drain.ts:123-131`) is not counted; any other HTTP error status counts, including 401, 403 and 5xx (D19 item 9) | Uncounted failures still mark the entry `failed` with `lastError` as today and are still resent on every scan |
| Mobile: foreground drain | `features/field-ticket/sync/drain.ts`: in the catch at `:162-171` the count is advanced for a counted failure; `orderedUnsynced` / `onePass` (`:89-91`, `:133-179`) skip an exhausted entry so the drain does not resend it | **Same lines U3 edited** for the 409 split: insert the count in the generic path only; a 409 never reaches it. The first foreground send (`ticket-step-screen.tsx:1092` `markStepFailed`) is the first send, not a retry. A failed entry still blocks later entries and the submit as a failed step does today (D19 item 7) |
| Mobile: background scan | `features/field-ticket/sync/background-sync.ts`: `markRejectedStep` (`:177-201`) applies the same test and advances the count; `replayDraftSteps` / `replayPendingStep` (`:232-263`) and `runScan` (`:548-567`) skip exhausted entries so a scan stops resending them | **Same lines U3 edited** (move 6) |
| Mobile: single-ticket drain with no `syncOnline` wait | `background-sync.ts` gains one exported way to run a drain for one ticket that does **not** read `syncOnline` (read at `:55`, `:101` in the draft context's `canContinue`, `:529` in `syncSingleDraft`, `:557` in `runScan`, `:630`; set at `:605`). Every other caller keeps the gate | spec §11a row 20: how it is built is the executor's call; a `canContinue` that omits the NetInfo flag but keeps the session-epoch and owner checks (`isCurrentSession`, `sameTicketOwner`) is the nearest shape. It still takes the per-ticket sync lock (`runWithTicketSyncLock`) so it cannot run beside the open-ticket drain |
| Mobile: ledger reading | `lib/ticket-draft-sync.ts` gains a helper for "this draft has an exhausted entry". `hasUnsyncedSteps` stays true for a failed entry (it still blocks the submit) and `ticketNeedsSync` stays true (a draft with unsynced work is never wiped, `ticket-flow.store.ts:548`, `:820`) | |
| Mobile: progress map | `features/field-ticket/use-ticket-progress.ts`: `SyncSummaryInfo` (`:46`) carries the count; `TicketProgress` (`:36`) gains a failed-sync field derived in the same place `hasOfflineData` is (`:96-113`, `:302`, `:321`); a draft with no counts reads as zero failures | Callers that spread the map ignore the new field |
| Mobile: active card | `components/field/ticket-card.tsx`: the shared `Badge` (`tone="warn"`, as the "Offline" badge at `:168-172`) with the exact text **"Sync failed — tap to retry"**, shown when the ticket has an exhausted entry; it is a **tappable** badge, 48 px touch target (`contexts/mobile.md`), and a nested press target inside the card's own `onPress={onOpen}` (`:372`, `:391`) so tapping it does not open the ticket; a test id in the style of `ticket-card-offline-badge` | The "Offline" badge is unchanged and may show beside it (a failed item has ops). Not shown inside the open ticket's own screens (Q9). Reuse `Badge`; no new component |
| Mobile: Jobs row | `app/(field)/jobs.tsx`: the same badge and tap on the completed-ticket row (beside the "Offline" badge at `:260`), fed by `progressById[other.id]` (`:234`); also the active-ticket card path at `:214` | A test id in the style of `completed-ticket-offline-badge` |
| Mobile: the tap | One shared handler used by both screens: (1) `await isApiReachable()` (`lib/api-reachable.ts`, already on `origin/staging`, one `GET /health`, 4 s timeout, never throws); (2) `true` -> reset the count of **all** of the ticket's exhausted entries and start the single-ticket drain above, regardless of the NetInfo flag; (3) `false` -> show the existing offline message and do nothing else (nothing reset, nothing sent). The badge goes when the entry becomes `synced` (derived from the ledger) | F9: find the existing offline message; no new copy. `ticket-step-screen.tsx:831` is the one existing `isApiReachable()` caller and a pattern to follow |
| Shared / API / Web | N/A — none | no API change, no new route |
| Tests | not requested | none new. `ticket-card.test.tsx`, `jobs.test.tsx` and the `sync/` suites are run, not extended. Updating one the change breaks is not adding one |

### Reviewable as

- **Demo:** (1) Make one queued op fail with a 500 on every send (a dev API stub or a temporary
  server fault). Send 1 fails (not a retry); scans 2, 3 and 4 each resend it and fail; scan 5 does
  not resend it and the ticket's card and its completed row in Jobs now read "Sync failed — tap to
  retry". Force-quit and reopen between scans: the count is kept. (2) Before the 4th counted failure
  the card shows only what it shows today; the open ticket's own screens never show the badge. (3)
  With the API reachable, tap the badge (also with the phone in airplane mode while the API is
  reachable over another path, or NetInfo reading offline): the count resets, a drain for that
  ticket starts, and the badge goes when the item lands. (4) With the API unreachable, tap: the
  existing offline message, count unchanged, nothing sent. (5) Leave an op queued offline for 30
  days (set the device clock or edit `updatedAt`): it and its files are still there and it sends on
  reconnect. (6) A 409 never advances the count. (7) With the server unreachable for 20 scans: the
  item is resent each time, count stays 0, no badge. (8) A failed ticket submit shows no new badge
  (REQ-13 workaround). (9) Repeat (1) with a queued Attach File upload (U4's key): it stops after 4
  counted failures and the card shows the badge; a timeout never counts.
- **Acceptance:** REQ-09 acceptance lines (1) to (4) and REQ-12 lines (1) to (4); all derived,
  unconfirmed (Q8).
- **Reviewer can verify without:** any API change beyond a reachable dev API that can be made to
  return 500, the web app.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-09, REQ-12). Both rest on the developer's 2026-10-29
  answers, relayed, not yet in `.ai/vault/decisions/`; the Q4, retry-count, Q9, Q10, Q12 and probe
  answers are all `reference`.
- **Migration reversible:** N/A — no schema migration. The new persisted ledger field is optional
  and read as 0; an older app build ignores it.
- **Behind a flag:** no.
- **Touches existing data:** device-local only. Existing drafts carry no counter and read as 0. No
  backfill.
- **Unverified plus costly to undo:** the **persisted counter field** is written into users'
  AsyncStorage drafts and survives app updates; renaming it later needs a stored-draft migration.
  The name, and which HTTP statuses count (D19 item 9: every non-409 status), are AI-assumed and
  reviewable. The developer reviews D19 items 1, 3 to 5 and 9 to 11 before this unit is built.
- **Blast radius:** this unit **changes what happens to every step that fails today**: it is no longer
  resent by itself after 4 counted failures, and being held blocks later entries and the submit
  (`canFinalizeDraft` requires `!hasUnsyncedSteps`) until the crew taps the badge. A wrong
  "did the server answer" test either strands real work (counting a timeout, so the badge appears
  for a bad signal) or loops for ever (not counting a server error). A `withStepSync` that drops the
  field resets the count on every write and the badge never appears.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Every step entry that fails today and is resent without limit: `drain.ts:89-91`, `:162-171`; `background-sync.ts:232-263`, `:548-567`; callers `markStepFailed`, `markRejectedStep`, `orderedUnsynced` (`grep -rn "markStepFailed\|markRejectedStep\|orderedUnsynced" apps/mobile --include=*.ts --include=*.tsx \| grep -v test`) | the new counter and stop rule | existing `sync/` suites (`drain`, `background-sync`) run in isolation; by hand: Demo 1, 6 and 7 for each of a step op, the U3 delete key and an Attach File key | `spec.md` REQ-09, §11a row 13; developer answers 2026-10-29 (Q4, retry count, Q12) |
| `StepSyncEntry` / `withStepSync` and drafts already stored on devices | a new persisted field | by hand: install over a draft written before the change, confirm it reads as 0 and syncs as before; write to a step after a counted failure and confirm the count survives a state change (carry) and resets on fresh ops | `spec.md` §11a row on stored drafts; ASSUMED D19 items 3 and 5 |
| The card's "Offline" badge (`ticket-card.tsx:168-172`) and the completed row's (`jobs.tsx:260`), and `hasOfflineData` | the new badge beside it | `ticket-card.test.tsx` and `jobs.test.tsx` (both green on the baseline); by hand: a ticket with queued ops shows "Offline"; with an exhausted item shows both | `spec.md` §11a row 14; D18 |
| `useTicketProgress` / `TicketProgress` (`use-ticket-progress.ts`) and its consumers `app/(field)/field.tsx`, `jobs.tsx` | a new field on the progress map | `use-ticket-progress.test.ts` and `app/(field)/field.test.tsx` are **inherited red** (F8), so they prove nothing; by hand: open the Field tab and Jobs with and without a failed item | `spec.md` §11a row 15 |
| The pre-submit manual drain (`useDrainTicket`, `use-ticket-outbox.ts:24-68`; `ticket-step-screen.tsx:513`, `:695`) and the submit gate (`canFinalizeDraft`) | the stop rule | by hand: with an exhausted item the manual drain still runs and the submit stays blocked as for a failed step today; the tap and the manual drain both reset/retry | `spec.md` §11a row 16; D19 item 7 |
| `isApiReachable()` and its caller `ticket-step-screen.tsx:831` | one more caller | unchanged helper; `grep -rn "isApiReachable" apps/mobile --include=*.ts --include=*.tsx \| grep -v test` shows two callers | `spec.md` §11a row 19 |
| `syncOnline` gate (`background-sync.ts:55`, `:101`, `:529`, `:557`, `:630`), `scanAndSyncTickets` (`:570-583`) and the reconnect listener | the new single-ticket drain | by hand: reconnect scan still waits on the flag; the new path alone ignores it; a tap during a running scan joins the per-ticket lock rather than doubling the send | `spec.md` §11a row 20 |
| A failed ticket submit (`submitState: 'error'`, `submissionPending`; `background-sync.ts:354-362`) | **not reached** | unchanged by construction; Demo 8 | `spec.md` REQ-13 / Q11 workaround ("queued ops only") |

**Gates (vs baseline):** `pnpm typecheck`; `pnpm mobile:lint`; mobile `jest` for
`features/field-ticket/sync` (`drain`, `background-sync`), `components/field/ticket-card.test.tsx`,
`app/(field)/jobs.test.tsx`, each run in isolation and compared with the nine inherited failures
(`use-ticket-progress.test.ts` and `field.test.tsx` are among them: report their result as
unchanged-red, and rely on the by-hand checks). No API or shared change, so no `pnpm api:*` run and
no boot. No new tests.

### Deliberately not in this unit

- A failed ticket submit counted and badged — REQ-13, **blocked on Q11**; U5 leaves the submit paths untouched.
- Any signal for an item that never reaches the server (the 15 s timeout loop) — the developer's stated consequence of Q12 (F10); not added.
- The badge inside the open ticket's own screens — excluded by Q9.
- New copy for the failed-probe message — reuse the existing offline message (F9).
- A timer-based retry pacing — retries are the existing reconnect, app-open, manual and badge-tap triggers (D19 item 1).

---

## Sequencing

```
U1 ──▶ U2 ──▶ U3 ──▶ U4 ──▶ U5
```

- **Parallelisable:** **strictly sequential, by the developer's stacked decision and by the files.**
  - U1 and U2 both edit `ticket-attachment-guard.service.ts` and `attachments.repository.ts`, and U2
    uses the repository U1 creates.
  - U2 and U3 share the built `@tcg/shared` constant.
  - U3 and U4 both edit `step-ops.ts`, `drain.ts`, `background-sync.ts` and `lib/ticket-draft-sync.ts`
    (U4 widens U3's op union and reuses its drain and 409 split).
  - U4 and U5 both edit `drain.ts`, the ledger code in `ticket-flow.store.ts` and
    `lib/ticket-draft-sync.ts`; U5 also edits `background-sync.ts`, `use-ticket-progress.ts`,
    `ticket-card.tsx` and `jobs.tsx`, none of which U4 touches except `background-sync.ts`.
  - U3 and U5 (not adjacent) both edit the failure branch of `drain.ts` (`:162-171`) and
    `markRejectedStep` / `replayPendingStep` in `background-sync.ts` (`:177-201`, `:232-252`): U3 for
    the 409 split, U5 for the count (move 6).
  - U1 and U5 would not collide on files (api vs mobile), but U5 sits behind U4, U3, U2, U1. No two
    units touch `schema.prisma`; only U1 does.
- **Merge order constraint:** U1, U2, U3, U4, then U5. The one migration lands with U1 and
  `pnpm db:migrate` must run before U1's API boots. Spec §11 rollout order (API cleanup guaranteed
  before mobile queues deletes) is met by the same order. Fallback if U4 stalls on F2: U5 is re-based
  onto U3 and ships first (move 7).
- **Shared providers:** `TicketAttachmentGuardService` is provided in five modules (F3); U1 changes
  its constructor and imports `StorageDeletionModule` into all five. `TicketAttachmentsService`
  (U2) is provided by `ticket-attachments.module.ts`, already among the five. `grep -rln
  "TicketAttachmentGuardService" apps/api/src --include=*.module.ts` and
  `grep -rln "TicketAttachmentsService" apps/api/src --include=*.module.ts` find them. U5 adds no
  provider (mobile only).
- **Cross-surface windows:** (1) between U2 and U3: the API sends `ATTACHMENT_IN_USE` and no shipped
  mobile reads it; old behaviour (read as "window closed") continues, nothing breaks. (2) Between U3
  and U4: the `attachments` target does not exist; the Attach File sheet is unchanged and still blocks
  offline. (3) Between U3 and U5 (U4 included): the reserved delete and Attach File keys are retried at
  every drain and scan with no limit and no badge, exactly as a failed step is today. (4) An old mobile build against the new API keeps
  working: the DELETE routes keep their `204`, the header is additive, one 409 body gains a field, and
  D11 turns a `403` into `204` for a missing id only. U5 changes nothing on the API.
- **First unit to ship:** U1. It tests the riskiest assumptions in the plan: that a one-way-looking
  migration, the tenant-scope registration, DI across five modules and a worker that runs outside a
  request all work on a real path (`deleteOrphaned`), before four more units depend on them. U3 is the
  first unit a crew member can see work; U5 is the first that changes what the crew sees about work
  that is stuck.
- **If the developer prefers the plan's literal boundary** (U1 = model + worker only, U2 = all five
  sites), the work is identical but U1 ships nothing alone. This file keeps the thin vertical cut.

## Ledger notes for `close-ticket`

- All five units belong to one ticket and are stacked; each opens one PR. A PR per unit,
  never a combined branch. The stack order is U1, U2, U3, U4, U5 (numeric): each PR targets the
  previous unit's branch.
- The slug `MOBILE-OFFLINE-DELETE-QUEUE` stands in for the Jira id. When one exists the folder, the
  `processed.log` entry and the branch names are renamed together.
- REQ-13 stays unassigned until Q11 is answered. U4 is blocked by nothing except Q8 sign-off; its
  executor risk (F2) is a stop-and-ask condition. If Q11 or a new §12 question changes the work, the
  decomposer re-runs for the affected unit and recounts §2.
