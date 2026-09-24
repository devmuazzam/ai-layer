# SCRUM-OFFLINE-SYNC — PR #658 review fix plan

Status: **draft for sign-off, 2026-09-24.** This plan comes from the code review of PR #658
(branch `feat/SCRUM-OFFLINE-SYNC-u6-pre-submit-verification`, head `349982639`). It adds to
[`plan.md`](plan.md) and does not replace it. Unit names (U1–U7) refer to that file.

The review reached a verdict of **do not ship**. Several paths lose data the crew entered
offline. Verification then passes the ticket anyway, which defeats the ticket's purpose. This
plan fixes those paths first, in dependency order. Each fix is one commit with its own tests.

Tags, as in `plan.md`:
- **[V]**: the defect was re-read in the code during the review.
- **[A]**: reported by a review subagent and not re-read line by line. Re-check the code before
  building on an [A] line.

File references are as of `349982639`.

---

## 0. Decisions

**Answered 2026-09-24 by the session user, verbatim:**

> Before ticket submit we check all previous steps and verifiy if all the data is persisted
> ton backedn server. If some thing is not syned then we need to sync it and in case the
> submit ticket step is performed in offline mode then we need to block it untill the
> internet availabiluty becuase at this fiunal step we need to verifiy the all steps data
> persistence in DB before submiting and competomg the ticket

> D2: We need to store the compeltedAt as it is if it is in teh future. No need to perform
> validation. We need to record the completedAt time of checklists as it is

- **D1 → submit is online-only.** Offline, the Review screen blocks the submit until the
  device is online again. There is no background or queued submit. Completion always runs
  the full check first: catch-up, Work Time punch, verify, resend, re-verify. See the F7 revision.
- **D2 → store `completedAt` as sent, with no window.** This is what `349982639` already does:
  the only check left is the DTO's `@IsISO8601`. **F9b is dropped.**
- **D3, D4:** no answer, so the defaults stand (resend-then-block; DELETE callers in a
  follow-up).

**Answered 2026-09-25 by the session user, verbatim:**

> We had changed flow for all photo/attachments upload behaviour in ticket steps.
> This is the behaviour we have implemented:
> When we upload photo/attachment we save it in mobile local storage first and display it with single green ticket. Next when we click on the button to move to the next step then we save these attchments data in the backedn and S3 and show double green ticket in photo preview
> We need to revert back to how we were uploading the images before this branch change which is that we upload to first mobile local storage and then roght away upload the image to backedn and S3 bucket and use S3 preview URL to display the image!
> This chnage we need to do is for only photos and attchments. Nothing else needs to be change!

- **Photo & attachment uploads revert to immediate upload on capture.** The U4 deferral of
  photos and attachments to the Next step is reverted: photos are written to local storage,
  immediately uploaded in-flight to backend and S3, and previewed using the authenticated S3 URL.
- **Signatures untouched:** Drawn signatures (`useSignatureCapture`, `useResumableSignature`)
  remain deferred to step completion.
- **Pre-submit verification untouched:** Step data verification prior to ticket completion
  remains active.

**Review-plan corrections (session review, 2026-09-24):**
- F6: the segment kind is `'boom-sessions'`, not `'booms'`.
- F3: `query.isFetchedAfterMount`, or `dataUpdatedAt` versus launch time, both mark a list
  fetched in this launch. Use whichever fits the call site.
- **Added, F11:** edits to an already-completed step still call the server directly, with
  no online gate:
  - `TimeRecordBody` "Done adjusting";
  - `use-signature-time-adjust`;
  - ReviewBody's Work Time start move (behind the dev flag).
  Offline, these must record locally and queue like the rest.

The original questions, kept for the record:

These block only the fix they name. Every other fix can start now.

| # | Question | Blocks | Default if no answer |
|---|---|---|---|
| D1 | A ticket submitted **offline** fails verification when the catch-up runs in the background. What does the crew see? | F7 | The ticket stays `error`. The Review screen and the ticket card list the failing steps, and the ticket does not complete. |
| D2 | What time window is allowed for a device-supplied checklist `completedAt`? This is the open *Offline capture* entry in `vault/field-ops/gaps.md` (device clocks). | F9b | Ticket's first recorded time − 12 h to server now + 5 min. Outside the window: store the server time and log a warning. |
| D3 | Verification mismatch: resend automatically, or ask the crew (`intent.md` §12, still open). | none | Keep resend-then-block, as built. |
| D4 | Should the new signature and lunch-break DELETE endpoints get a mobile caller in this PR? | F10 | No. Wire them in a follow-up. |

`spec.md` is still owed (`plan.md` header). Either get it written and signed off, or record
that `intent.md` plus these two plan files are the contract for this ticket.

---

## 1. Fixes, in build order

### F1 — Make the drain safe under concurrency (mobile) · HIGH

This fixes review findings 2 and 3.

**Defects**
- **Single-flight is not per ticket.** It is global and not keyed by ticket
  (`sync/drain.ts:48`, `let inFlight`). Each loop iteration re-reads
  `useTicketFlowStore.getState()` (lines 63–65), so after a ticket switch it reads the
  *currently open* ticket. It keeps sending to the `ticketId` it started with. Ticket B's
  steps go to ticket A and are marked synced. Meanwhile a drain for B just returns A's
  promise. **[V]**
- **Marking synced can delete new writes.** `markStepSynced(key)` (line 72) runs after
  `await runStepOps(...)` without checking that the entry is still the one that was sent.
  Suppose Next calls `setStepOps` while a reconnect drain is sending (`[key].tsx:954-956`).
  The in-flight run finishes the old ops, marks the step synced, and `withStepSync(...,
  'synced')` deletes the new ops. Two reviewers found this independently. **[V]**

**Change**
1. Add a revision counter to `StepSyncEntry` in `ticket-flow.store.ts`: `rev: number`,
   incremented by every write to the entry (`withStepSync`, `setStepOps`,
   `completeStepLocally`). `hydrateDraft` defaults a missing `rev` to `0`, so old drafts
   still load.
2. Add a store action `markStepSyncedIfUnchanged(key, rev)`. It marks the step synced only
   when `sync.steps[key]?.rev === rev`. Otherwise it leaves the entry `pending`, because newer
   writes are owed. The drain calls this in place of `markStepSynced`. Leave
   `markStepSynced` for its other callers.
3. Rework `drainPendingSteps(ticketId, storeTicketId, upload)`:
   - Replace `inFlight` with a `Map<storeTicketId, Promise<DrainResult>>`. `storeTicketId`
     is `useTicketFlowStore.getState().ticketId`, the key the draft lives under. Pass it
     from `useDrainTicket` (`use-ticket-outbox.ts`).
   - Before each step and after each `await`, abort if `store().ticketId !== storeTicketId`.
     Return `{ ok: false, aborted: true }` without calling `markStepFailed`. The ledger on
     disk is untouched, so the next open resumes.
   - Snapshot `entry.rev` before sending, and pass it to `markStepSyncedIfUnchanged`.
   - **Re-run instead of dropping.** A call made while a run is in flight sets `rerun =
     true` on that ticket's slot. When the loop ends, it runs again if `rerun` is set and
     `orderedUnsynced` is not empty. Every caller's promise resolves only after that final
     pass, so Next's `void drainTicket()` is never silently dropped.
4. Add `aborted` to `DrainResult`. `useTicketSync`'s `beforeSubmit` and `preSubmitCheck` treat
   an aborted drain as not ok. The submit must not proceed.

**Tests** (`sync/drain.test.ts`)
- Switching tickets mid-drain sends nothing further to A, marks nothing on B, and B's own
  drain then sends B.
- `setStepOps` during an in-flight send leaves the step `pending` with the new ops, and the
  re-run sends them.
- Two callers of the same ticket share one run, and both see the re-run's result.

---

### F2 — Retire only steps whose writes are all done (mobile) · HIGH

This fixes review finding 1.

**Defect.** `retireServerKnownSteps` (`ticket-flow.store.ts:268-276`) marks a step `synced`
whenever the server already knows it (a completion marker or a timestamp). `withStepSync`
then drops its `ops`.
- Scenario: Start Work is completed online, then its lunches or segments are edited offline.
  The queued writes are erased on the next `openTicket` (line 487) or reconcile (line 529).
- Verify only checks the completion marker, so the ticket completes without them. **[V]**

**Change**
- In `retireServerKnownSteps`, skip any entry with `ops?.length`. Only an ack-only step,
  whose single write *is* the marker, can be proven by the server's marker. Steps with
  stored ops are retired only by the drain (F1).
- `dropStaleDraftIfServerReset` and `reconcileWithServerTickets` already refuse to wipe while
  `hasUnsyncedSteps`, so no other change is needed.

**Tests** (`ticket-flow.store.test.ts`)
- A synced `startWork`, followed by `setStepOps`, then `openTicket` with a ticket whose
  `completedStepKeys` includes `startWork`: the ops and the `pending` state survive.
- The same through `reconcileWithServerTickets`.
- An ack-only pending step is still retired.

---

### F3 — Never treat a restored cache as a server reset (mobile) · HIGH (conditional)

This fixes review finding 4.

**Defect**
- The ticket list is now restored from disk, up to 3 days old (`lib/query-persistence.ts`).
  `use-ticket-progress.ts:84` and `ticket/index.tsx:440` reconcile against it straight
  away, and `openTicket` callers pass the cached ticket.
- Scenario: the last refetch before the app was killed failed. The restored ticket then
  shows no progress, so `deriveResumeFloor` returns 1 and the ledger is all `synced`.
- `dropStaleDraftIfServerReset` or the reconcile wipe then deletes the draft, the step's
  local photos and the shift clock. **[A — the path was traced, not reproduced]**

**Change**
1. In `lib/query-client.ts`, export `APP_STARTED_AT = Date.now()` and a helper
   `isFetchedThisLaunch(dataUpdatedAt: number): boolean`. A persisted query keeps its
   original `dataUpdatedAt`, so data restored from disk is always older than launch.
2. Give `reconcileWithServerTickets(tickets, employeeTypeName, { fresh })` and
   `openTicket(id, ticket, employeeTypeName, { fresh })` a `fresh` flag.
   - When `fresh` is false, run only the non-destructive parts: retire (safe since F2), the
     floor move-forward, backfills and the shift-clock sync.
   - When `fresh` is false, skip `dropStaleDraftIfServerReset` and every `wipeDraftKeys` or
     `clearShiftClocks` branch.
3. At the two reconcile sites and the five `openTicket` call sites, pass `fresh` from the
   query's `dataUpdatedAt`. The call sites are `alerts.tsx:46`, `jobs.tsx:101`,
   `field.tsx:87`, `projects/.../[jobCode].tsx:47` and `tickets/[ticketId].tsx:33`.
   A caller with no ticket passes nothing, and no reset logic runs.

**Tests**
- A reconcile against a ticket with no progress, `fresh: false`, and a draft at step 4 with
  an all-synced ledger: the draft is kept.
- The same with `fresh: true`: the draft is wiped (the existing behaviour, still covered).

---

### F4 — Stop stale queued writes from overwriting newer ones (mobile) · MEDIUM

This fixes review findings 8 and 11a.

**Defects**
- **Labor.** An offline entry queued in `sync.steps.labor.ops` (`[key].tsx:148`
  `queueEntry`) is kept when the crew later posts a corrected entry online.
  `buildOfflineOps('labor')` (lines 842–845) re-queues the old one on Next (line 954), and the
  old entry overwrites the new one on the server. **[A]**
- **Photos.** Removing a local photo on a step completed offline calls
  `discardLocalAttachment` (`use-photo-removal.ts:39-42`). The step's stored ops still hold
  the `local:` reference.
  - Every drain then throws `LocalAttachmentMissingError` on that step and stops. Every later
    step and the submit are blocked.
  - An already-uploaded photo (with a `serverId`) takes the local branch too, so its server
    row is orphaned. **[A]**

**Change**
1. Labor: in `LaborStepBody`, when an online submit succeeds, drop any queued `laborEntry` op
   for the same `targetEmployeeId ?? 'self'`. Use `setStepOps`, or a small
   `dropQueuedLaborEntry(who)` action.
2. Photos:
   - In `usePhotoRemoval`, when the `local:` id is referenced by any stored op in
     `sync.steps`, clear only the draft's reference and keep the file and ledger entry.
     Next on that step rebuilds the ops from the new capture.
   - Add `collectUnreferencedLocalAttachments()`, called after `completeStep` or
     `completeStepLocally` and after a drain. It deletes every ledger entry and file that no
     draft, capture or op references.
   - When the entry has a `serverId`, call the existing server delete with that id, then drop
     the entry.

**Tests**
- A queued offline entry followed by a successful online submit for the same member leaves no
  queued entry.
- Removing a photo referenced by queued ops, then draining, does not throw, and the drain
  still sends the step.
- A removed uploaded photo triggers the server delete.

---

### F5 — Require a new signature when answers changed after sign-off (mobile) · MEDIUM

This fixes review finding 9.

**Defect.** The sign-off is invalidated but the stale signature still passes:
- The crew reopen a completed Pre-Trip or Post-Trip, change an answer (which invalidates the
  sign-off in the session), and leave.
- On return the stamped draft outranks the capture (`use-step-draft.ts:51`). But
  `previouslySigned={!!signedCapture}` (`ChecklistBody.tsx:146`) marks the signature valid.
- Next then sends the changed answers under the old signature. **[V]**

**Change**
- `useStepDraft` returns `restoredFromStampedDraft: boolean`.
- `ChecklistBody` passes `previouslySigned={!!signedCapture && !draft.restoredFromStampedDraft}`.
- Optional hardening: the engine writes `signatureInvalidated: true` into the draft when it
  invalidates the sign-off, and the body reads that flag instead. Pick one mechanism, not
  both.

**Tests** (`ChecklistBody.test.tsx`)
- A stamped draft with changed answers, restored over a signed capture: Next is blocked
  until the sign-off is redone.

---

### F6 — Make verification prove what it claims (mobile) · MEDIUM-HIGH

This fixes review finding 7, and the gap between `plan.md` §4 and `verify.ts`.

**Defects**
- **A missing ticket passes.** `if (gaps === null) return true` (`[key].tsx:524`). The
  snapshot fetch `fetchServerSnapshot` (`verify.ts:104-106`) reads only
  `services.tickets.list()` page 1 of 20. A ticket not on page 1 is never verified. **[V]**
- **A resend can pass itself.** For `driving`, `startWork` and `labor` the comparator
  (`verify.ts:72`) checks only the completion marker. A resend built with no local data is
  just `[ack]` (`[key].tsx:529-531`), which creates the marker, so the second verify passes.
  This holds even when the segments, lunches or labor entries never landed, or the step was
  never completed on this device. **[V]**
- **The comparators are weaker than planned.** `plan.md` §4 promised per-row comparison for
  Start Work segments, labor entries and signature fields. `verify.ts` implements markers
  only, which is a gap between plan and code. **[V]**

**Change**
1. **Not found blocks.**
   - `fetchServerSnapshot` pages through `tickets.list(page, 50)` until the ticket is found
     or `page > totalPages`. Use the envelope in `data/contracts/pagination.ts`.
   - `null` blocks the submit with "Could not find this ticket on the server — try again".
2. **Resend only what the device holds.**
   - A discrepancy on a step with no local `summaries[key]` is not resendable. It blocks,
     reason `missing`, with the copy "not completed on this device".
   - A resend whose ops are ack-only does not count as proof for `startWork` or `labor`.
3. **Stronger comparators**, reusing services that already exist and are in the persisted set:
   - `startWork`: `ticketLunchBreaks.list`, `ticketWorkSegments.list('buildups' | 'booms')`
     and `ticketBreakdowns.list`. Every device row exists on the server, matched by the
     client segment id where there is one, with equal start and end to the minute.
   - `labor`: `ticketLaborEntries.getCrew`. Every crew member with a local entry has a
     server entry with the same bracket or modifier.
   - Checklist per-answer and signature-field comparison from §4 stays deferred, as the
     `verify.ts` JSDoc says. Record that deferral in `plan.md` §4 so plan and code agree.
4. Mirror the empty-assignments rule the server guard uses. An empty list passes, and after
   F9a the server judges only the assignments that still apply.

**Tests** (`sync/verify.test.ts`)
- A missing ticket, a ticket on page 2, and a Start Work row missing on the server.
- A labor entry missing for one crew member.
- An ack-only resend of `startWork` does not clear the discrepancy.

---

### F7 — Verify offline-queued submits too (mobile) · MEDIUM-HIGH

**Revised by D1.** The submit does not happen offline at all.
- Review's Submit, while offline, shows "Submitting needs a connection — every step is
  checked against the server first" and does nothing else. The ticket stays where it is.
- `useTicketSync` no longer auto-submits. A draft still in `pendingSync` from an earlier build
  is treated as unsubmitted: the crew tap Submit when online, and the full check runs.
- `preSubmitCheck` stays in the step screen, since it is the only caller. The extraction
  below is not needed, and the background path in the original text below is superseded.

This fixes review finding 6 and depends on D1.

**Defect.** A ticket submitted offline (`submitState: 'pendingSync'`) completes through
`useTicketSync` (`_layout.tsx:23-26`). Its `beforeSubmit` only drains
(`use-ticket-sync.ts:38`): no Review punch ordering, and no `findStepDiscrepancies`.
`intent.md` §4 requires the comparison before every completion. The offline case is the one
this ticket exists for, and the server guard ships switched off. **[V]**

**Change**
1. Extract `preSubmitCheck` (`[key].tsx:497-546`) into a UI-free module,
   `features/field-ticket/sync/pre-submit.ts`:
   ```ts
   runPreSubmitCheck(deps: {
     serverTicketId: string; storeTicketId: string;
     employeeTypeName?: string | null; withChecklists: boolean;
     drain: () => Promise<DrainResult>;
     punchReviewComplete: () => Promise<boolean>;
     onProgress?: (msg: string) => void;
   }): Promise<{ ok: true } | { ok: false; gaps: StepDiscrepancy[]; message?: string }>
   ```
   - It holds the drain → punch → verify → resend → re-verify sequence, including F6's rules.
   - The step screen keeps `blockSubmit` for presenting the result.
2. Move the Review punch into a hook both callers can use, `useReviewCompletePunch(ticketId)`.
   It wraps the same call `punchReviewComplete` makes today, using the stored review instant.
3. The `_layout.tsx` `beforeSubmit` calls `runPreSubmitCheck`. On `{ ok: false }` it stores
   the gaps on the draft as `submitBlockedBy` (persisted) and leaves `submitState: 'error'`.
   The Review screen and the ticket card show the list (D1).
4. Remove the misleading comment at `[key].tsx:553-557`.

**Tests**
- `use-ticket-sync.test.tsx`: going online with a pending, unverifiable submit does not call
  `submitFn`, and records `submitBlockedBy`.
- `pre-submit.test.ts`: the sequence order, and a resend that clears the gaps.

---

### F8 — Reopen offline after a restart (mobile) · HIGH

This fixes review finding 5.

**Defect.** `restore()` (`session/store.ts:163-187`) calls `establish` → `getProfile()`. A
network error sets `status: 'unauthenticated'`, so AuthGate routes to login, and the
persisted identity and ticket cache are never reached. `intent.md` §4 ("the ticket flow can
be reopened offline after an app restart") is unmet. **[V]**

**Change**
1. `lib/query-persistence.ts` exports a `cacheRestored` promise, resolved from
   `PersistQueryClientProvider`'s `onSuccess` (and resolved on `onError` too, so nothing
   hangs).
2. In `restore()`, on a **non-auth** failure (the existing `isAuthRejection` split):
   - Await `cacheRestored`, then read `queryClient.getQueryData(queryKeys.identity)`.
   - If a profile is there, set `status: 'authenticated'` with `tokens`, `profile`,
     `persona`, and a new `offline: true` flag.
   - If no profile is cached, keep today's behaviour.
3. When `onlineManager` next reports online with `offline: true`, re-run `establish` quietly.
   A 401 or 403 then signs out exactly as today, and drafts survive because logout keeps
   `ticket:*`.
4. The API client's refresh-on-401 must not treat a network error as a sign-out. Check
   `lib/api-client` before building; this is an assumption.

**Tests** (`session/store.test.ts`)
- A network error with a cached identity gives `authenticated` with `offline: true`.
- A network error with no cache gives `unauthenticated`.
- A 401 clears the tokens.

**Manual device check** (the author runs it): airplane mode, kill the app, reopen, and the
ticket and its steps open.

---

### F9 — Backend guard and status fixes (api) · MEDIUM (dormant) / LOW

**F9a — stale checklist assignments block the guard for good.** Review finding 10.

**Defect.** `submit-step-guard.ts:61-63` requires *every* assignment of the type to be
`SUBMITTED`.
- Assignments are created lazily on GET, from the allocation at that moment, and nothing
  deletes them.
- After an asset swap or a checklist deactivation, the orphaned row can never be submitted.
  Every submit then returns 400 `TICKET_STEPS_MISSING` once `TICKET_SUBMIT_STEP_GUARD` is on.
- The mobile verify reads the current GET, so it passes while the server refuses, and the
  crew cannot fix it. **[V — no delete path; lazy creation per the API reviewer]**

**Change**
- Build `SubmitStepEvidence.checklistAssignments` from the same resolver the checklist GET
  uses, so only assignments that still match the ticket's allocation, and are on active
  checklists, are judged.
- Put the resolver in the checklist-assignments service and call it from
  `job-tickets.service`. That is usecase → service, so no upward import.
- Add a spec for an assignment orphaned by an asset swap.

**F9b — dropped (D2).** `completedAt` is stored as sent. The original text follows for the record.

**F9b — bound device checklist times** (depends on D2).
- Where: `parseChecklistCompletedAt` in `checklist-assignments.service.ts`. Commit
  `349982639` removed the future-time check, so any valid ISO time is stored.
- Change: clamp to the D2 window. Outside it, store the server time and log a warning with
  `ticketCode`.
- Add a spec for each edge, plus the untested replay path in `markSubmitted`. That is the
  keep-existing-`submittedAt` case when no `completedAt` is sent.

**F9c — a dispatcher cancel can be overwritten.**
- Where: the `completeTicketIfOpen` WHERE clause (`job-tickets.repository.ts`), which is
  `status <> COMPLETE` only.
- Change: `status: { notIn: [COMPLETE, CANCELLED, REJECTED] }`. Check the enum names in
  `schema.prisma` first. A zero-row update returns the current status, so the controller
  answers 409, not 200.

**F9d — attachment delete race** (low).
- Where: `removeUnreferenced` in `ticket-attachment-guard.service.ts`, which counts
  references and then deletes.
- Change: wrap the count and the delete in `$transaction`, and map P2003 to a no-op ("still
  referenced"). Do not return 500.

---

### F10 — Small cleanups (all surfaces) · LOW

- **Online detection.** Change `useOnline` (`components/field/use-online.ts`) and the
  `onlineManager` listener (`providers/query-provider.tsx`) to `isConnected !== false &&
  isInternetReachable !== false`. Start `useOnline` at `null`, treated as offline for Next
  routing only, until the first NetInfo answer. Weak signal then takes the offline path
  instead of hanging on 15 s timeouts.
- **Local-file cleanup after submit.** This is at `[key].tsx:562`. Delete by both the
  server UUID and the store `ticketId`, as `wipeDraftKeys` does, and run the same cleanup
  from the offline submit path (F7).
- **JSDoc.** Move `uploadAttachment`'s JSDoc back above its method in
  `ticket-signatures.service.ts` and `ticket-lunch-breaks.service.ts`.
- **Environment.** Add `TICKET_SUBMIT_STEP_GUARD=false` to `apps/api/.env.example` with a
  comment. Joi accepts only `'true'` or `'false'`.
- **Schema docs.** Regenerate `apps/api/prisma/schema.dbml` (`pnpm db:dbml`) and commit only
  the `client_upload_id` hunk. The uncommitted local copy also carries unrelated `users`
  drift, which does not belong in this PR.
- **Tests.** In the attachment-guard race test, assert that `deleteObject` gets the key that
  was just stored.
- **Endpoints.** D4: wire the signature and lunch-break DELETE endpoints to the retake/remove
  actions, or record them as a follow-up.

---

## 2. Order, commits, release

1. **Build order.** F1 → F2 → F3 → F4 → F5 → F6 → F7 → F8 on mobile. F9 and F10 can run in
   parallel, on the API or separately.
   - F6 comes before F7 because F7 reuses F6's rules.
   - F2 depends on F1, since only the drain retires steps with ops.
2. **Commits.** One conventional commit per fix, via the `commit` skill, under the
   developer's own name, with no AI trailer (`CLAUDE.md` → Code quality).
3. **Deploy order.** The API goes first. `forbidNonWhitelisted: true` (`main.ts:82`) rejects
   the new `completedAt` from a new mobile build with a 400 on the old API. The new DELETE
   routes return 404 there.
4. **The guard flag.** Keep `TICKET_SUBMIT_STEP_GUARD` off until F9a is deployed and every
   crew runs a build with F1–F8.
5. **Walkthrough.** `.ai/claude/skills/demo-walkthrough/WALKTHROUGH.md:938-939` documents the
   old "submit without steps succeeds" behaviour. Update it at `close-ticket` step 5 when the
   flag turns on, not in this PR.

## 3. Verification

The author runs the unit tests named in each fix, plus the device checks below. No
throwaway databases, and no repeated full-gate runs.

The device checks:
- **Mid-drain switch.** Airplane mode, complete two steps, reconnect, and switch tickets
  while it syncs (F1).
- **Offline Start Work edit.** Edit a synced Start Work offline, then reopen the ticket (F2).
- **Offline restart.** Kill the app offline and reopen at step 1 of a ticket with progress
  (F3, F8).
- **Offline submit.** Submit offline with one step deliberately missing on the server (F7).

## 4. Not in this plan

- Per-user or per-tenant draft keys (review 11). Record it in `spec.md` as a single-user
  device assumption (`plan.md` §5).
- Checklist per-answer and signature-field comparison (the deferred rows of `plan.md` §4).
- Conflict resolution between two devices (`intent.md` §5).
- Showing pending-sync state to dispatch on web (`intent.md` §5).
- The web checklist step body now shows the device finish time
  (`apps/web/.../step-bodies/checklist.tsx:12`). That is the intended change, but confirm the
  display wording with product.
