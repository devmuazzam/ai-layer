# Spec — MOBILE-OFFLINE-DELETE-QUEUE reliable offline deletes on mobile and guaranteed S3 cleanup on the API

> Written by the elaborator from `intent.md` beside it. No Jira id exists; the "ticket" source
> below is `intent.md` itself (the developer's request, captured 2026-10-29). It is a developer
> request, not a product-adjudicated document, so it is `[UNVERIFIED]`, kind: jira-equivalent.
> The developer decisions of 2026-10-29 (outbox, dedicated table, four stacked units, no orphan
> sweep) were relayed in the request that started this elaboration. They are not yet written
> to `.ai/vault/decisions/` (`tcg-scrum` writes that). They are recorded here as §11b decisions
> D1 to D4 and cited as "developer decision 2026-10-29, relayed".
> **Folded 2026-10-29 (second pass):** the developer's answers to §12 were relayed in the same
> session and are cited as "developer answer, session 2026-10-29, status reference": Q2, Q3, Q5,
> Q6, Q7 answered; Q1 left to the AI (decided as D13); D7 and D11 confirmed. Q4 was answered in the third
> pass (below); Q8 stays open. The answers are not yet in `.ai/vault/decisions/`; `tcg-scrum` writes that note and flips
> the Status lines.
> **Folded 2026-10-29 (third pass):** the developer's Q4 answer ("No Retention time. 3 re tries.
> after 3rd failed retry, we need to show a badge or indicator in mobile ticket card for failed
> sync") is recorded as REQ-09 and REQ-12, decisions D16 to D18 and assumptions D19. It leaves
> four details unanswered (Q9 to Q12); the fourth-pass answers below settle Q9, Q10 and Q12, and Q11
> alone keeps REQ-13 `[OPEN]`.
> **Folded 2026-10-29 (fourth pass):** the developer answered the retry count ("1 send + 3
> retries (4 total)", confirming D19 item 2), Q12 ("Only count server-refused sends"), Q9 ("Card +
> completed rows in Jobs") and Q10 (text "Sync failed — tap to retry", which adds a retry tap),
> and agreed ("sure") that the tap probes the API before it trusts the NetInfo flag. Q11 and Q8 stay
> open; Q13 (new, raised from the decomposer's finding F2 in `units.md`, read only) was then
> answered: the Attach File queue is a reserved key in the draft's sync ledger (D9).
> **Nothing has been implemented. This spec stops at §12.**
> **Revised 2026-10-30 — the S3 outbox is dropped (decision D20).** The developer reviewed the
> built U1 (`StorageDeletionJob`, table `storage_deletion_queue`, the `@Interval` worker) and
> decided the extra table is not needed: the API deletes the S3 objects **inside the row
> delete's database transaction, before it commits**. If S3 fails, the transaction rolls back,
> the row stays, and the caller gets an error (503); the mobile delete queue (U3) and the manual
> retry already resend it, and a delete of an id already gone answers success. No table, no
> worker, no migration. U1 is dropped; U2 is rebuilt as the first API unit. REQ-03, REQ-04 and
> REQ-11, decisions D1 to D6 and D13, Q1 and Q7 are **superseded** (kept below as the record of
> what was decided and why it was reversed). REQ-05, D4 and D7 stand with the in-transaction
> delete in place of the enqueue. The trade-off the developer accepted: S3 and Postgres cannot
> share one transaction, so a commit that fails after S3 has deleted leaves a row pointing at a
> missing file until the delete is retried (rare, and the retry finishes it); and a delete that
> keeps failing is not retried by the server (it surfaces to the user or the phone's queue).
> Q10 of `MOBILE-TICKET-PRESIGNED-IMAGES` is answered as best effort with rollback on S3 failure
> (decision note revised 2026-10-30).

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `MOBILE-OFFLINE-DELETE-QUEUE` (slug; no Jira id) |
| Intent | `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/intent.md`, captured `2026-10-29` |
| Elaborated on | `2026-10-29` |
| Vault state at elaboration | `.ai/vault/INDEX.md` read; six `domain/` files verified, all else unverified; the `field-ops/field-ops-mobile-INDEX.md` conflict stub applies and is unresolved. Jira not consulted (none exists, and no Jira tool was available to this run). |
| Open questions raised by this spec | 13, all in §12: 11 answered 2026-10-29 (Q1 by AI decision D13; Q2, Q3, Q4, Q5, Q6, Q7, Q9, Q10, Q12, Q13 by the developer), 1 open (Q8); Q11 answered in part 2026-10-30 (D22) |
| Already-shipped behaviour reached | 20 consumers in §11a; 1 whose rule the developer directed on 2026-10-30 (a failed ticket submit: Q11, D22) |
| Rules consulted | `.ai/claude/contexts/api.md`; `.ai/claude/contexts/prisma.md`; `.ai/claude/contexts/mobile.md`; `.ai/claude/contexts/patterns.md` (P3 read; this ticket is not an entity-photo feature, see D12); root `CLAUDE.md` |

Product-conflict note (`field-ops/field-ops-mobile-INDEX.md`, 2026-08-10, unverified): three
field-ops documents disagree: FR-TCG-FOP-001 v1.1 REVIEWED (55.6 KB, 2026-06-09),
FR-TCG-FOP-002 v2.0 DRAFT (46.2 KB, 2026-06-16), and the Atom user stories (34.5 KB,
2026-08-11). **None is verified. This spec takes no side.** Offline behaviour is written only in
FR-TCG-FOP-001 (the NFR table row "Offline capability", `field-ops/frd-new-format-draft/07-non-functional-requirements.md`,
and the two requirements named in REQ-01). A search of `field-ops/field-ops-frd/` and
`field-ops/atom-mobile-app-user-stories/` for "offline" returned nothing, so FR-TCG-FOP-002 and
the Atom stories are silent on it. The requirements that touch offline behaviour are flagged
`[CONFLICT]` for that reason, and their behaviour is sourced from the ticket and the decision
notes, not from FR-TCG-FOP-001.

**Correction to the brief (verified 2026-10-29).** The request said no source exists for a
"72h offline grace" or for "REQ-28". One does:

- `decisions/2026-10-15-late-and-incomplete-tickets.md` clause **L17** (Haris, decided
  2026-10-16, `status: reference`, 8.9 KB): each queued op carries `capturedAt`, sent as
  `X-Captured-At`; it is accepted when captured before the window ended and it arrives within a
  **72h grace**; the acceptance is audited. Clause L2 sets the completion window at scheduled
  end plus 24h.
- `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` **REQ-28** (`[UNVERIFIED]`, source "DN-2 L17")
  restates it. The code comments that cite "REQ-28" mean that REQ-28, not a requirement of this
  ticket (`apps/api/src/usecase/job-tickets/ticket-write-window.util.ts:47-50`,
  `apps/mobile/features/field-ticket/sync/step-ops.ts:67`).

The 24h window and the 72h grace are therefore both sourced (a developer direction, not a TCG
ruling, not verified). What is **not** sourced: that L17 was meant to cover delete operations and
Attach File uploads. Its words say "each queued op", and this spec reads it that way in REQ-01
and REQ-06, flagged `[UNVERIFIED]`. If that reading is wrong, say so at sign-off.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | An offline delete of an uploaded checklist or signature photo is persisted on the device and sent on reconnect | mobile, api | `[CONFLICT]` | intent.md §3-4; `decisions/2026-10-15-late-and-incomplete-tickets.md` L17; FR-TCG-FOP-001 NFR row | no |
| REQ-02 | The photo disappears from the UI at once, online or offline | mobile | `[UNVERIFIED]` | intent.md §3-4 | no |
| REQ-03 | ~~The S3 keys of a deleted attachment are saved in the same database transaction as the row delete~~ **superseded 2026-10-30 (D20): the S3 objects are deleted inside that transaction, before it commits; no table** | api | `[UNVERIFIED]` | intent.md §3-4; developer decision 2026-10-29, relayed | no |
| REQ-04 | ~~A worker retries the S3 delete until it succeeds~~ **superseded 2026-10-30 (D20): no worker; a failed S3 delete rolls the row delete back and the caller or the phone's queue retries** | api | `[UNVERIFIED]` | intent.md §3-4; developer decision 2026-10-29, relayed | no |
| REQ-05 | Every server path that deletes a ticket attachment's S3 objects deletes them inside the row delete's transaction (D20); the two 409 causes carry distinct error codes | api, shared | `[UNVERIFIED]` | intent.md §2, §4; developer answers 2026-10-29 (Q2, D7, D11) | no |
| REQ-06 | The Attach File sheet queues uploads and deletes offline instead of blocking them | mobile, api | `[CONFLICT]` | intent.md §3-4; L17; FR-TCG-FOP-001 NFR row; developer answers 2026-10-29 | no (storage settled: Q13 answered, D9) |
| REQ-07 | An offline delete of a photo whose upload is still queued cancels both | mobile | `[UNVERIFIED]` | developer answer 2026-10-29 (Q3) | no |
| REQ-08 | A queued delete the server refuses with 409 is handled by cause | mobile | `[UNVERIFIED]` | developer answer 2026-10-29 (Q2) | no |
| REQ-09 | A queued item waits with no age limit; it is sent once and retried at most 3 times, counting only sends the server refused, then marked failed-sync | mobile | `[UNVERIFIED]` | developer answers 2026-10-29 (Q4, retry count, Q12) | no |
| REQ-10 | Attach File queue: 50 MB per file, no other cap, and a "Pending sync" marker on a queued row | mobile | `[UNVERIFIED]` | developer answers 2026-10-29 (Q5, Q6) | no |
| REQ-11 | ~~An outbox job that ends FAILED is kept and logged at error level~~ **superseded 2026-10-30 (D20): no job; a failed S3 delete is logged at error level and answered 503** | api | `[UNVERIFIED]` | developer answer 2026-10-29 (Q7) | no |
| REQ-12 | After the 3rd failed retry the ticket card and the completed row in Jobs show "Sync failed — tap to retry"; the tap probes the API, resets the count and starts a drain | mobile | `[UNVERIFIED]` | developer answers 2026-10-29 (Q4, Q9, Q10, probe) | no |
| REQ-13 | A ticket the server has not completed is never shown as completed on the phone; a submit the server never accepted raises the failed-sync badge | mobile | `[UNVERIFIED]` | developer direction 2026-10-30 ("real fix here"; "the ticket state should be consistent"), D22 | no |
| REQ-14 | A photo whose upload has landed shows the double tick at once | mobile | `[UNVERIFIED]` | developer report 2026-10-30, D21 | no |
| REQ-15 | A checklist photo is labelled with its checklist when it is uploaded | mobile, api | `[UNVERIFIED]` | developer request 2026-10-30, D23 | no |

Counts: `15` total — `0` verified, `13` unverified, `2` conflicted, `0` open. *(2026-10-30: REQ-13 left `[OPEN]` on the developer's direction, D22; REQ-14 and REQ-15 added, D21 and D23.)* *(History: 11 total with 4 unverified, 2 conflicted, 5 open before the first 2026-10-29 answers; 8 / 2 / 1 after them; the Q4 answer made REQ-09 defined and added REQ-12 and REQ-13; the fourth pass answered Q9, Q10 and Q12, so REQ-12 is fully defined and REQ-13 narrowed to the failed-submit question, Q11. The totals did not move.)*

## 2. Requirements

### REQ-01 — An offline delete of an uploaded checklist or signature photo is persisted and sent on reconnect `[CONFLICT]`

- **Statement:** When a crew member removes a photo that capture already uploaded (a checklist item photo or a signature or identity photo) while the phone is offline, the removal is stored on the device and sent to the server when the phone is back online.
- **Surface:** mobile (queue), api (existing DELETE routes, receive header)
- **Sources:**
  - `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/intent.md` §3, §4 — `[UNVERIFIED]` — kind: jira — "Offline mobile deletion needs a separate persistent mobile queue, which sends the deletion request when connectivity returns"; "remove from the UI, persist the deletion, then delete from S3 after reconnect".
  - `decisions/2026-10-15-late-and-incomplete-tickets.md` L17 — `[UNVERIFIED]` (`status: reference`, a developer direction) — kind: decision — each queued op carries `capturedAt`, accepted within 72h of the window end. Read here as covering the new delete op (see §0).
  - `field-ops/frd-new-format-draft/07-non-functional-requirements.md` ("Offline capability": "Progress is queued and synced on reconnection"), `field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-039-auto-save.md` (FR-TCG-FOP-001 FR-FOP-039 Auto-Save) and `field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-026-incomplete-ticket-handling.md` (FR-TCG-FOP-001 FR-FOP-026 Incomplete Ticket Handling) — `[UNVERIFIED]` — kind: vault — context only. None names deletes. These say progress is saved and queued; they do not say a removal is.
  - `field-ops/gaps.md#offline-capture--committed-on-a-recorded-call-with-no-ticket-and-no-written-scope` — `[UNVERIFIED]` — kind: vault — resolved 2026-09-25, "specified and implemented under SCRUM-OFFLINE-SYNC"; item 3 says photos upload at once when online and are held on the device as `local:<id>` references when offline. Describes uploads only.
- **Conflict:** `field-ops/field-ops-mobile-INDEX.md` (gap `gaps.md#field-operations-mobile-app`). Candidates: `field-ops/frd-new-format-draft/INDEX.md` (55.6 KB, 2026-06-09, FR-TCG-FOP-001 v1.1 REVIEWED — the only one that writes offline); `field-ops/field-ops-frd/INDEX.md` (46.2 KB, 2026-06-16, FR-TCG-FOP-002 v2.0 DRAFT — silent on offline); `field-ops/atom-mobile-app-user-stories/INDEX.md` (34.5 KB, 2026-08-11 — silent on offline). None is verified. This spec does not choose between them and does not use any of them to decide the behaviour above.
- **Open question:** none. The edges were open on Q2 (refused with 409) and Q3 (photo whose upload is still queued); both are answered (REQ-08, REQ-07).
- **Ripple:** `use-ticket-outbox.ts`, `StepSyncOp` consumers, the three photo-removal callers and the four DELETE routes; see §11a rows 1 to 7. What happens to each is stated there.
- **Acceptance:** DERIVED from the stated goal, `[OPEN]` until the developer confirms (Q8). With the phone in airplane mode, remove an uploaded checklist photo: it leaves the screen; force-quit and reopen the app: the photo is still gone and a delete is still pending; restore the connection: within one drain the delete request reaches the server, the row is gone, and its S3 keys are in the outbox.
- **Edges:**
  - **Reached by:** `usePhotoRemoval('checklist')` (callers: `components/field/deficiency-panel.tsx:156`, `features/field-ticket/steps/shared/checklist/ChecklistEngine.tsx:1301`); `usePhotoRemoval('signatures')` (`components/field/signer-capture.tsx:118`); the post-step sweep in `features/field-ticket/sync/use-ticket-outbox.ts:41-65`. The Attach File delete is REQ-06. The lunch-break attachment delete (`ticketLunchBreaks.deleteAttachment`) has no mobile caller (`grep -rn deleteAttachment apps/mobile`); not in scope, and not changed.
  - **Does not apply when:** the photo was never uploaded (a `local:` id with no `serverId`): today's local-only discard stays (`use-photo-removal.ts:48-55`; the queued-upload case is REQ-07). Mock camera mode (`mode !== 'real'`, `use-photo-removal.ts:46`) stays a no-op. The phone is online and the request succeeds: no queue entry.
  - **When an input is absent:** no `ticketId` yields `{ ok: true }` as today (`use-photo-removal.ts:46`). A queue entry always carries the server attachment id; an entry without one is not created.
  - **Trust boundary:** the attachment id and the op's `capturedAt` come from the phone. The server believes `capturedAt` only inside the L17 rule (captured before the window ended, arriving within 72h) and re-checks that the attachment belongs to the ticket (existing checks in `removeUnreferenced` and `removeItemPhoto`).
  - **Read time:** N/A — no catalogue data.
- **Notes for the executor:** the three DELETE routes the queue calls do not read `X-Captured-At` today (only three routes in `field-tickets.controller.ts` do, lines 211, 238, 274), so a queued delete that arrives after the 24h window is refused with 409 even inside the 72h grace. Reading the header on the delete routes (as `parseCapturedAtHeader` does for those three) is what makes REQ-01 consistent with L17. The server refuses a delete the window forbids through `getTicketForEmployeeAction(…,'write')`; a 409 is handled by cause (REQ-08). Governing rules: `contexts/mobile.md`, `contexts/api.md`. Design in §11b D8 to D10.

### REQ-02 — The photo disappears from the UI at once, online or offline `[UNVERIFIED]`

- **Statement:** The removed photo leaves the screen immediately, whether the phone is online or not and whether or not the server delete has happened.
- **Surface:** mobile
- **Sources:**
  - `intent.md` §3, §4 — `[UNVERIFIED]` — kind: jira — "The photo disappears from the UI at once, offline or not."
- **Conflict:** none
- **Open question:** none
- **Ripple:** the three `usePhotoRemoval` callers (§11a row 2). They already clear their local UI whatever the outcome; the hook's documented contract says so (`use-photo-removal.ts:23-26`). The return type stays `{ ok } | { ok:false, message }`.
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). Offline or online, immediately after Remove the photo is not on screen, and no spinner waits on the server.
- **Edges:**
  - **Reached by:** same entry points as REQ-01.
  - **Does not apply when:** the delete is refused before queueing (no ticket id, mock mode).
  - **When an input is absent:** N/A — the id is required.
  - **Trust boundary:** N/A — local UI only.
  - **Read time:** N/A.
- **Notes for the executor:** a photo removed offline must also stay out of the lists the app rebuilds from cached server data until the delete lands (the cached ticket and attachment queries still contain the row). Whether a refetch can bring it back on screen is an executor check, not a product question: the user's intent is that it is gone.

### REQ-03 — SUPERSEDED 2026-10-30 (D20): the S3 keys of a deleted attachment are saved in the same database transaction as the row delete `[UNVERIFIED]`

- **Superseded 2026-10-30 (D20):** nothing is saved. The row delete and the S3 deletes of the objects it owned (`ticketImageObjectKeys`) run in one transaction; the S3 deletes run before it commits (`AttachmentsRepository.deleteWithObjects`, `removeIfUnreferenced`). The text below is the earlier requirement, kept as the record.

- **Statement:** When the API deletes an attachment row, it writes a deletion job that holds the attachment's S3 keys in the same database transaction; if the transaction rolls back, no job exists.
- **Surface:** schema, api
- **Sources:**
  - `intent.md` §3 — `[UNVERIFIED]` — kind: jira — "In one DB transaction, unlink/delete the attachment and save a deletion job containing its S3 keys."
  - Developer decision 2026-10-29, relayed — `[UNVERIFIED]` — kind: decision (unrecorded) — transactional outbox; dedicated table; no S3 lifecycle rule.
- **Conflict:** none
- **Open question:** none. The name was Q1, left to the AI and decided as D13 (`StorageDeletionJob`, `storage_deletion_queue`).
- **Ripple:** the attachment-delete paths in REQ-05; `TENANT_SCOPED_MODELS` (`apps/api/src/orm/prisma.service.ts:26`); `prisma.service.spec.ts` (§11a rows 5 and 9). No existing consumer reads the new table.
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). Delete a ticket photo: afterwards one outbox row exists holding every key the row owned (the original and, for an image, its preview — `ticketImageObjectKeys(fileName)`). Force the row delete to fail inside the transaction: no outbox row is left.
- **Edges:**
  - **Reached by:** the delete paths of REQ-05.
  - **Does not apply when:** the attachment id is not found (the existing idempotent return: no row deleted, no job). The row is still referenced by a saved signature (`removeIfUnreferenced` throws 409 before deleting): no job.
  - **When an input is absent:** a row whose `fileName` yields no keys creates no job.
  - **Trust boundary:** N/A — server-derived keys from the stored row.
  - **Read time:** N/A.
- **Notes for the executor:** structure in §3 and §11b D1, D2, D4, D13. `removeIfUnreferenced` already deletes inside `this.prisma.$transaction` (`apps/api/src/service/attachments/attachments.repository.ts:66-84`); the enqueue joins that transaction. `deleteOrphaned` (`ticket-attachment-guard.service.ts:347-354`) deletes through `attachmentsRepository.delete` with no transaction, and needs one.

### REQ-04 — SUPERSEDED 2026-10-30 (D20): a worker retries the S3 delete until it succeeds `[UNVERIFIED]`

- **Superseded 2026-10-30 (D20):** no worker. If an S3 delete fails the transaction rolls back, the row stays and the request fails with a 503 (`S3StorageService.deleteObjects`); a retry (the phone's queue, the user, the next delete) finishes it, because S3 answers success for a key already deleted. The internal cleanups (`cleanupReplaced`, after a resubmission already committed) log a warning and leave the stale row in place instead of failing the resubmission. The text below is the earlier requirement, kept as the record.

- **Statement:** After the transaction commits the API tries to delete the S3 objects at once; if that fails, a background worker retries the persisted job until the delete succeeds.
- **Surface:** api
- **Sources:**
  - `intent.md` §3 — `[UNVERIFIED]` — kind: jira — steps 2 and 3 of the outbox plan.
  - Developer decision 2026-10-29, relayed — `[UNVERIFIED]` — kind: decision (unrecorded) — "an @Interval worker retries deleteObject until success".
- **Conflict:** none
- **Open question:** none for the mechanism (numbers are AI decisions, §11b D3). What happens to a job that exhausts its attempts is Q7 (REQ-11).
- **Ripple:** none — new surface only (established by: `grep -rn "Interval(" apps/api/src --include=*.ts` lists the existing pollers; none touches attachment objects).
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). With S3 unreachable, delete a photo: the request still succeeds, a pending job exists and its attempts grow on the worker's schedule; restore S3: within one poll after the next retry time the objects are gone and the job is completed.
- **Edges:**
  - **Reached by:** the immediate attempt after commit; the worker poll (`@Interval`); a stale-claim reclaim after a process death.
  - **Does not apply when:** a key is already absent in S3 (the delete counts as success; ASSUMED — S3 DeleteObject on an absent key succeeds, an AWS behaviour not verified in this repo).
  - **When an input is absent:** an empty key list completes the job with no S3 call.
  - **Trust boundary:** N/A — server-only.
  - **Read time:** N/A.
- **Notes for the executor:** mirror `PayrollCalculationJob` (`apps/api/prisma/schema.prisma:6100`) and its poller (`apps/api/src/usecase/payroll/payroll-calculation-queue.service.ts`: `@Interval`, `reclaimStaleJobs`, `claimNextJob` with `FOR UPDATE SKIP LOCKED`, `markCompleted`, `markFailed`). Numbers are §11b D3. The module that provides the new worker must be registered in `app.module.ts`, and the DI graph booted once (`contexts/api.md` → Testing).

### REQ-05 — Every server path that deletes a ticket attachment's S3 objects deletes them inside the row delete's transaction (revised 2026-10-30, D20); the two 409 causes carry distinct codes `[UNVERIFIED]`

- **Statement:** The four delete sites in `ticket-attachment-guard.service.ts`, the Attach File route and the generic admin route `DELETE /attachments/:id` (six sites in all) delete the S3 objects inside the row delete's transaction, before it commits, instead of swallowing a failed S3 delete (a failure rolls the row delete back and answers 503; `discardObjects`, for a row never written, stays a best-effort delete; `cleanupReplaced` logs and leaves the stale row); an Attach File delete of an id that does not exist succeeds; and a delete refused because a saved signature still points at the image carries an error code distinct from the window-closed code.
- **Surface:** api, shared (one error-code constant)
- **Sources:**
  - `intent.md` §2, §4 — `[UNVERIFIED]` — kind: jira — "the API swallows a failed S3 delete (`ticket-attachment-guard.service.ts`), leaving an object nothing references"; "The API removes the S3 object(s) a deleted attachment owned reliably".
  - Developer decision 2026-10-29, relayed — `[UNVERIFIED]` — kind: decision (unrecorded) — U2 enqueues at the four sites `removeUnreferenced`, `deleteOrphaned`, `cleanupReplaced`, `discardObjects`.
  - Developer answer, session 2026-10-29, status `reference` — `[UNVERIFIED]` — kind: decision (unrecorded) — D7 confirmed (`TicketAttachmentsService.remove` is a fifth site, in U2); D11 confirmed (a missing id returns 204); and a sixth site folded into U2 the same day: the generic admin route `DELETE /attachments/:id` (`attachments.controller.ts`, via `AttachmentsService.delete`), which can delete a ticket attachment and swallowed a failed S3 delete; the error-code constant `TICKET_ATTACHMENT_ERROR_CODES.ATTACHMENT_IN_USE` is confirmed; Q2 "split by cause": the API returns a distinguishable code for the two 409 causes.
- **Conflict:** none
- **Open question:** none.
- **Ripple:** the DELETE routes' callers on mobile; the services that call `cleanupReplaced`; the mobile reading of 409; see §11a rows 4 to 6 and 11 to 12. **The success contract does not change (204).** The error body of one 409 gains a `code` (§4, D14).
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). `grep -rn "deleteObject(" apps/api/src/usecase apps/api/src/service apps/api/src/presentation` shows no call outside the outbox worker and its immediate attempt on the ticket attachment paths; the only matches left are the two follow-ups of §11c (`attachment-photos.service.ts`, `signed-copy-attachments.service.ts`). Each path above, with S3 failing, leaves a pending job and an HTTP success. `DELETE` on the Attach File route with an unknown id answers 204. A delete of an image a saved signature points at answers 409 with the new code; a delete after the window closed answers 409 with `TICKET_WINDOW_CLOSED`.
- **Edges:**
  - **Reached by:** `removeUnreferenced` (signature, identity and WTL-photo removal: `ticket-signatures.service.ts:259`, `ticket-lunch-breaks.service.ts:566`); `deleteOrphaned` (checklist photo removal: `checklist-assignments.service.ts:521`); `cleanupReplaced` (resubmission: `ticket-signatures.service.ts:239`, `ticket-lunch-breaks.service.ts:321` and `383`, `checklist-assignments.service.ts:662`); `discardObjects` (a failed upload: `ticket-attachment-guard.service.ts:191` and `199`); the Attach File route (`TicketAttachmentsService.remove`, `ticket-attachments.service.ts:150-166`, the fifth site, found by `grep -rn "deleteObject(" apps/api/src`); the generic admin route `DELETE /attachments/:id` (`attachments.controller.ts` `remove`, which called `deleteObject` itself at `:260` before U2, via `AttachmentsService.delete`, `attachments.service.ts:300` at U2 commit `7d826e40e`; the sixth site, folded into U2 by the developer 2026-10-29). A photo-feature row on the generic route still goes to `photos.remove`, unchanged (`attachments.controller.ts`, the `isPhoto` branch). The signature-referenced 409 is thrown inside `removeIfUnreferenced` (`attachments.repository.ts:77-80`).
  - **Does not apply when:** entity photos (assets, tools, employees, users: `attachment-photos.service.ts:446`, reached from the generic route through `photos.remove`) and `signed-copy-attachments.service.ts:223` also swallow a failed delete; they are not ticket attachments and are listed in §11c as follow-ups. The window-closed 409 (`code: 'TICKET_WINDOW_CLOSED'`, already distinguishable: `job-tickets.service.ts:1873-1876`) is not changed.
  - **When an input is absent:** `discardObjects` runs when the row was never written, so there is no row delete to share a transaction with; the job is inserted alone (D4). A missing attachment id on the Attach File route returns 204 (D11); a row that exists but belongs to another ticket still returns 403.
  - **Trust boundary:** N/A — server-derived.
  - **Read time:** N/A.
- **Notes for the executor:** `cleanupReplaced` calls `deleteOrphaned` (`ticket-attachment-guard.service.ts:383`), so enqueueing inside `deleteOrphaned` covers both. The new code is added to the 409 `ConflictException` in `removeIfUnreferenced` as an object body `{ message, code }`, the same shape the window guard throws; the existing message text is kept. The constant lives in `@tcg/shared` beside `TICKET_WINDOW_ERROR_CODES` (D14). Existing orphans are not swept (§13).

### REQ-06 — The Attach File sheet queues uploads and deletes offline `[CONFLICT]`

- **Statement:** Adding or deleting a file through the Attach File sheet while offline is accepted and queued on the device, and sent when the phone is back online, instead of being blocked with a reconnect message.
- **Surface:** mobile, api
- **Sources:**
  - Developer answers, session 2026-10-29, status `reference` — `[UNVERIFIED]` — kind: decision (unrecorded) — Q3, Q5, Q6, D7, D11: see REQ-05, REQ-07, REQ-10.
  - `intent.md` §3, §4 — `[UNVERIFIED]` — kind: jira — "Add/delete through 'Attach File' while offline: Both operations are blocked with a reconnect message. This sheet does not queue uploads or deletions."; §4 "the developer's decision: include it".
  - `decisions/2026-10-15-late-and-incomplete-tickets.md` L17 — `[UNVERIFIED]` — kind: decision — as REQ-01.
  - `field-ops/frd-new-format-draft/07-non-functional-requirements.md` — `[UNVERIFIED]` — kind: vault — as REQ-01, context only.
- **Conflict:** same stub and candidates as REQ-01. None is verified; this spec does not choose.
- **Open question:** none. Where the Attach File queue is stored was Q13: answered, a reserved key in the ticket draft's sync ledger sent by the existing sync (D9), not a separate durable queue. Limits and the queued-row marker are REQ-10 (Q5, Q6 answered); deleting a file whose upload is still queued is REQ-07 (Q3 answered); a refused delete is REQ-08 (Q2 answered).
- **Ripple:** `components/field/ticket-attachments-sheet.tsx:118-121` and `:209-212` (the two blocks that change), the existing sheet test that asserts the blocking messages (`ticket-attachments-sheet.test.tsx`), the cached attachment list. §11a rows 8 and 9.
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). Offline: Attach File accepts a picked file with no reconnect message; Delete removes the row from the list. After reconnect the file exists on the server (or is gone), the list matches the server, and no duplicate was created by a retry.
- **Edges:**
  - **Reached by:** the sheet's pick-and-upload action and its delete action only.
  - **Does not apply when:** `readOnly` (the sheet returns before any queueing, `ticket-attachments-sheet.tsx:116`, `:207`). Online: the current direct upload and delete stay.
  - **When an input is absent:** a picked file whose size the picker did not report passes the size gate today (`components/field/ticket-attachment-file.ts`); offline it is queued the same way. Caps: REQ-10 (50 MB per file, nothing else).
  - **Trust boundary:** the file and its name come from the phone; the server applies its existing upload checks. A queued upload carries a stable client upload id so a retry after a lost response does not duplicate it (the ticket-attachment upload route's current idempotency is an executor check; `storeUpload` in the guard has `clientUploadId` handling for the image routes, `ticket-attachment-guard.service.ts:117`).
  - **Read time:** N/A.
- **Storage and the executor's risk (Q13 answered, D9 confirmed):** the queue is a reserved key in the ticket draft's sync ledger and is sent by the existing sync. The sheet receives only a ticket id (`ticket-details.tsx:182`, per `units.md` F2) and sits outside the field-ticket flow store, so a draft may not be reachable from it, or may not exist when the sheet is used before the ticket is started. The executor must confirm that a draft exists or can be created for the ticket. **If it cannot, stop and raise a new §12 question; do not build a second queue.**
- **Notes for the executor:** the Attach File delete route is not idempotent for a missing id (it answers 403, `ticket-attachments.service.ts:208-229`); a queued delete replayed after a lost response would wedge the queue. D11. Uploads and deletes of Attach File go through the same queue as REQ-01 (D8, D9). The existing per-file cap is `TICKET_ATTACHMENT_MAX_BYTES` = 50 MB (`packages/shared/src/constants/attachments.ts:5`). The route also reaches the window guard, so a late upload arrives under L17 only if the route reads `X-Captured-At`; it does not today.

### REQ-07 — An offline delete of a photo whose upload is still queued cancels both `[UNVERIFIED]`

- **Statement:** When the crew removes a photo while offline and that photo's upload op is still queued (it never reached the server), the queued upload and the delete are both dropped; nothing is sent and nothing reaches S3.
- **Surface:** mobile
- **Sources:**
  - Developer answer, session 2026-10-29 (Haris, relayed), status `reference` — `[UNVERIFIED]` — kind: decision (unrecorded) — Q3: "Cancel both — drop the queued upload and the delete; nothing reaches S3."
- **Conflict:** none. (The offline requirement sits under the field-ops conflict, §0; this requirement takes no behaviour from any of the three documents.)
- **Open question:** none.
- **Ripple:** `usePhotoRemoval` (`use-photo-removal.ts:48-57`) and the post-step sweep (`use-ticket-outbox.ts:41-65`); §11a rows 1 and 2. The upload ops live in the draft's sync ledger and in the `local:` attachment registry (`features/field-ticket/local-attachments.ts`, `discardLocalAttachment` at line 91).
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). Offline, take a photo (its upload is queued), then remove it before reconnecting: after reconnect no upload request and no delete request for that photo reach the server, and no object exists in S3.
- **Edges:**
  - **Reached by:** `usePhotoRemoval` for a `local:` id (checklist and signature targets); not the Attach File sheet (REQ-06 queues its own upload ops; a queued Attach File upload removed before reconnect is cancelled the same way, ASSUMED — same answer, same behaviour).
  - **Does not apply when:** the photo already reached the server (`serverId` present): that is REQ-01 (a queued delete). The phone is online and the upload has completed.
  - **When an input is absent:** a `local:` id with no ledger entry is treated as already gone: nothing to cancel.
  - **Trust boundary:** N/A — local only.
  - **Read time:** N/A.
- **Notes for the executor:** the existing code already discards a never-uploaded local photo (`use-photo-removal.ts:52-55`) but leaves one that a completed step's stored writes still name (`:51`), then lets the sweep delete it from the server after it is uploaded (upload then delete). The answer says nothing is sent. For that sub-case the stored step op that names the photo must not upload it; rewriting a stored step op's photo reference is not covered by the answer. Until the developer says otherwise this spec ASSUMES the nearest existing behaviour for that sub-case only (upload, then the sweep's delete, now as a queued delete op), because no customer sees the difference; the executor reports it in the PR if the stored op cannot be rewritten safely.

### REQ-08 — A queued delete the server refuses with 409 is handled by cause `[UNVERIFIED]`

- **Statement:** When the server refuses a queued delete with 409, the phone acts on the cause: if a saved signature still points at the image, the queued delete is dropped, the photo is restored in the UI and the crew is told; if the completion window has closed, the delete stays queued and the existing "Request approval" path is shown.
- **Surface:** mobile (and api for the distinguishing code, REQ-05)
- **Sources:**
  - Developer answer, session 2026-10-29 (Haris, relayed), status `reference` — `[UNVERIFIED]` — kind: decision (unrecorded) — Q2 "Split by cause", with the API returning "a distinguishable code for the two 409 causes".
  - `decisions/2026-10-15-late-and-incomplete-tickets.md` L3, L13 — `[UNVERIFIED]` (`status: reference`) — kind: decision — the window-closed 409 and the post-window request flow that the "Request approval" path serves.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `drain.ts:162-170` (any 409 becomes `needsEditRequest`), `background-sync.ts` drain path, the "Request approval" call to action, the restored photo's screens (`deficiency-panel.tsx`, `signer-capture.tsx`, `ChecklistEngine.tsx`). §11a rows 11 and 12.
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). (1) Queue an offline delete of an image that a saved signature points at; reconnect: the op is gone from the queue, the photo is back on screen, the crew sees a message, and later queued ops still drain. (2) Queue an offline delete after the window closed: the op stays queued, the existing "Request approval" path is shown, and a later approval lets the same op send.
- **Edges:**
  - **Reached by:** the drain of the reserved ledger key (D9), from both the open-ticket drain (`drain.ts`) and the background scan (`background-sync.ts`).
  - **Does not apply when:** a 409 with `code: 'DAY_START_LOCKED'` (a day-start op, unchanged); a 403 or 404 (D10, D11: gone counts as done). A 409 with neither code: ASSUMED — keep the op and show the existing "Request approval" path, which is what any 409 does today (`drain.ts:169`).
  - **When an input is absent:** a 409 body with no `code` is the last case above.
  - **Trust boundary:** the server decides the cause; the phone believes the `code` in the body.
  - **Read time:** N/A.
- **Notes for the executor:** the crew message is `NOT SPECIFIED` as copy: no source gives wording. ASSUMED — show the server's existing message through the app's current error display (`formatApiError`, as `drain.ts:164` does); the server's text for this cause is "This image is part of a saved signature and cannot be removed" (`attachments.repository.ts:78-80`). Do not write new copy. "Restore the photo in the UI" is ASSUMED to mean re-reading the ticket's server data and putting the local reference back; the photo's presigned link comes from the refetch. While a window-closed delete stays queued the photo stays hidden (REQ-02), ASSUMED from the nearest behaviour (a step's local work is kept while its ops are `failed`).

### REQ-09 — A queued item waits with no age limit; it is sent once and retried at most 3 times, counting only sends the server refused, then marked failed-sync `[UNVERIFIED]`

- **Statement:** An item in the offline queue (a step's ops, the new delete op, an Attach File queue item) is never dropped because of how long it has waited. It is sent once and then retried at most 3 times, so it is sent at most 4 times in all. A send counts toward the 3 retries only when the server answered it with an error (other than 409). After the 3rd failed retry the app stops retrying the item by itself, keeps its op and local files, and marks it a failed sync.
- **Surface:** mobile
- **Sources:**
  - Developer answer, session 2026-10-29 (Haris, relayed), status `reference` — `[UNVERIFIED]` — kind: decision (unrecorded) — Q4, verbatim: "No Retention time. 3 re tries. after 3rd failed retry, we need to show a badge or indicator in mobile ticket card for failed sync".
  - Developer answer, same session — retry count, verbatim: "1 send + 3 retries (4 total)".
  - Developer answer, same session — Q12, verbatim: "Only count server-refused sends".
  - `intent.md` §4, §11 — `[UNVERIFIED]` — kind: jira — "Any change needed to make it 'more reliable' beyond deletes is `OPEN`"; "how long an offline delete may wait on the device: NOT ON TICKET".
- **Conflict:** none. (The offline topic sits under the field-ops conflict, §0; this requirement takes no behaviour from any of the three documents.)
- **Open question:** none. Whether a failed ticket submit is covered is REQ-13 (Q11).
- **Ripple:** every op kind the drain and the scan send, because the counter lives in the shared drain. §11a rows 13 to 17 and 19 to 20. It changes what happens to a step that fails today: it is retried at every drain and every scan with no limit; it will stop after the 3rd failed retry.
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). (1) Make an op fail with a 500 on every send. Send 1 fails and is not a retry; scans 2, 3 and 4 each resend it and fail (retries 1 to 3); scan 5 does not resend it; the entry is marked failed-sync. Force-quit and reopen between the scans: the count is not lost. (2) Leave an op queued offline for 30 days: it and its local files are still on the device, and it sends on reconnect. (3) A 409 (REQ-08) does not advance the count. (4) With the server unreachable (airplane mode, or requests timing out) for 20 scans: the item is resent on every scan, its count stays 0, and no failed-sync badge appears.
- **Edges:**
  - **Reached by:** the open-ticket drain (`drain.ts:133-179`, `onePass`, via `useDrainTicket` and `drainPendingSteps`) and the background scan (`background-sync.ts:232-252` `replayPendingStep`, `:254-263` `replayDraftSteps`, `:548-567` `runScan`, on reconnect and app open), and the badge tap (REQ-12). One counter serves all. The first send of a step from the foreground (`ticket-step-screen.tsx:1092` `markStepFailed`) is the first send, not a retry.
  - **Does not apply when:** (a) a 409 refusal (REQ-08: window closed keeps the op, signature-referenced drops it; neither advances the count). (b) A send the server never answered: a timeout, no connection or a network error. The existing helper `getHttpStatus` returns `null` when there is no response (`lib/api-error-formatter.ts:135-149`), so "the server answered" is a non-null status. (c) A failure that is not a server answer at all (for example a local file that has gone): not counted, ASSUMED. (d) An interrupted or aborted run (`Ticket sync interrupted`, `drain.ts:123-131`). (e) A step already `synced`.
  - **What counts:** any HTTP error status other than 409, including 4xx (401 and 403 too) and 5xx. ASSUMED from "server-refused"; reviewable.
  - **When an input is absent:** an entry from before this change has no counter; it reads as 0 (the same convention as `rev`, `ticket-flow.store.ts:80-87`).
  - **Trust boundary:** N/A — the count is local.
  - **Read time:** N/A.
- **Stated consequence of the Q12 answer (not hidden):** an item that never reaches the server (no connection, or every request timing out) is retried on every scan with no counter and never shows the failed-sync badge. The API client has a 15 s timeout (`ticket-flow.store.ts:1192` comment), so an item that always times out (for instance a file too large to upload in that time on a weak link) loops on every scan and stays invisible to this rule. The developer chose this; a different signal for it is not part of this ticket.
- **Notes for the executor — what exists today, and what is new.**
  - *Exists today.* A step is `pending`, `synced` or `failed` with `lastError`, `ops`, `rev` (`ticket-flow.store.ts:69-88`). A failed send is marked by `markStepFailed` (`drain.ts:165`; store `:1032`) or `markRejectedStep` (`background-sync.ts:177-201`). `orderedUnsynced` takes every entry whose state is not `synced` (`drain.ts:89-91`), and `hasUnsyncedSteps` is true for `failed` (`lib/ticket-draft-sync.ts:13`), so a failed entry is resent at every drain and every scan, with no attempt counter, whatever the failure was. The run stops at the first failure (`drain.ts:162-171`, `background-sync.ts` `replayDraftSteps`), so a failed step also holds every later step and the submit (`canFinalizeDraft` requires `!hasUnsyncedSteps`). A 409 in the open-ticket drain sets `needsEditRequest` and stops (`drain.ts:169`); the background scan has no 409 handling (`grep -n 409 background-sync.ts` returns nothing). No age-based drop of a draft or an op exists: a draft with unsynced work is never wiped (`ticket-flow.store.ts:548` and `:820`, both guarded by `ticketNeedsSync`); the only age constant is a 30-minute floor before unreferenced local files are swept (`local-attachments.ts:135` `SWEEP_MIN_AGE_MS`), which is not a retention limit. The server still refuses a very old op (the 24h window plus 72h grace, L2 and L17), which comes back as a 409 and is handled by REQ-08.
  - *New.* A persisted retry count on the ledger entry, carried across state changes (`withStepSync` rebuilds the entry from scratch at `ticket-flow.store.ts:381-398`, so a new field is lost there unless it is copied); a test of "did the server answer" at the two places a failure is recorded (`drain.ts:162-171` and `background-sync.ts` `markRejectedStep`, which today both mark `failed` for any error); the stop rule in both paths; the failed-sync reading derived from the count (REQ-12).

### REQ-10 — Attach File queue: 50 MB per file, no other cap, and a "Pending sync" marker on a queued row `[UNVERIFIED]`

- **Statement:** The Attach File sheet queues files while offline subject only to the existing 50 MB per-file cap, with no cap on the number of files or on the total size; a queued row carries a small marker with the text "Pending sync" until the file reaches the server.
- **Surface:** mobile
- **Sources:**
  - Developer answers, session 2026-10-29 (Haris, relayed), status `reference` — `[UNVERIFIED]` — kind: decision (unrecorded) — Q5: "per-file 50 MB cap only, no count or total cap"; Q6: "yes, a small 'Pending sync' marker on a queued Attach File row (copy: 'Pending sync')".
  - `intent.md` §9 — `[UNVERIFIED]` — kind: jira — "the Attach File sheet keeps its layout".
- **Conflict:** none. (REQ-06 carries the offline conflict flag.)
- **Open question:** none.
- **Ripple:** `ticket-attachments-sheet.tsx` rows and status banner; the cached attachment list (§11a rows 8 and 9).
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). Offline, add three files: three rows appear, each with "Pending sync"; add a file over 50 MB: it is refused with the existing size message; reconnect: the markers disappear as each file reaches the server.
- **Edges:**
  - **Reached by:** the sheet's add action only.
  - **Does not apply when:** online uploads (no queue, no marker beyond the existing progress display); a queued **delete** (the row is simply removed at once, REQ-02; no marker was asked for).
  - **When an input is absent:** a file whose size the picker does not report passes the gate, as today (`ticket-attachment-file.ts`).
  - **Trust boundary:** the file and its name come from the phone; the server applies its existing upload checks when the file is sent.
  - **Read time:** N/A.
- **Notes for the executor:** the marker uses the exact text "Pending sync"; style from `theme/tokens.ts`, 48px touch targets for anything tappable. The developer chose no count or total cap: queued files occupy device storage until sent, and a very large offline session is not bounded by this spec. Say so in the PR; do not add a cap.

### REQ-11 — SUPERSEDED 2026-10-30 (D20): an outbox job that ends FAILED is kept and logged at error level `[UNVERIFIED]`

- **Superseded 2026-10-30 (D20):** there is no job. `S3StorageService.deleteObjects` logs a failed S3 delete at error level and throws a 503. The text below is the earlier requirement, kept as the record.

- **Statement:** When a deletion job uses up its attempts and ends FAILED, the row is kept with its last error and the transition is logged at error level; no list is built and no notification is sent.
- **Surface:** api
- **Sources:**
  - Developer answer, session 2026-10-29 (Haris, relayed), status `reference` — `[UNVERIFIED]` — kind: decision (unrecorded) — Q7 option A: "keep the FAILED row and log at error level; no list, no notification".
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** none — new surface only (established by: the table is new, §3; `grep -rn "StorageDeletionJob" apps` finds nothing today).
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). With S3 refusing every call, a job reaches `maxAttempts`, its status is FAILED, `lastError` holds the last error, and one error-level log line names the job id.
- **Edges:**
  - **Reached by:** the worker's mark-failed step; the stale-claim reclaim when attempts are already spent (as `reclaimStaleJobs` does for the payroll queue).
  - **Does not apply when:** a job that succeeds (COMPLETED) or is still retrying.
  - **When an input is absent:** a job with no recorded error logs "unknown error".  ASSUMED — nearest existing behaviour is the payroll worker's `markFailed` reason string.
  - **Trust boundary:** N/A — server-only.
  - **Read time:** N/A.
- **Notes for the executor:** nothing re-queues a FAILED row in this ticket; a manual sweep is a later ticket (§13).

### REQ-12 — After the 3rd failed retry the ticket card and the completed row in Jobs show "Sync failed — tap to retry"; the tap probes the API, resets the count and starts a drain `[UNVERIFIED]`

- **Statement:** When any item in a ticket's offline queue has failed its 3rd retry, the active ticket card and that ticket's completed-ticket row in Jobs show a badge reading "Sync failed — tap to retry". Tapping it first asks the API whether it is reachable; if it answers, the retry count is reset and a drain starts for that ticket, even when the phone's network flag says offline; if it does not answer, the app shows the existing offline message and does nothing else. The badge goes away when the item has been sent. It is not shown inside the open ticket's own screens.
- **Surface:** mobile
- **Sources:**
  - Developer answer, session 2026-10-29 (Haris, relayed), status `reference` — `[UNVERIFIED]` — kind: decision (unrecorded) — Q4: "after 3rd failed retry, we need to show a badge or indicator in mobile ticket card for failed sync".
  - Developer answer, same session — Q9: "Card + completed rows in Jobs". Q10: the badge text is "Sync failed — tap to retry", which adds a retry tap that resets the item's retry count and starts a drain.
  - Developer answer, same session — "sure", to the AI's proposal that the tap probes the API with `isApiReachable()` before it trusts the network flag. His reason, relayed: the NetInfo flag read "offline" on his iPhone while the API was reachable.
- **Conflict:** none (as REQ-09).
- **Open question:** none. A failed ticket submit is REQ-13 (Q11). "The badge goes away when the item has been sent" is ASSUMED: the badge is derived from the ledger, so it ends when the entry becomes `synced`.
- **Ripple:** the active ticket card and the progress map that feeds it; the completed-ticket row in Jobs; the background sync's online gate. §11a rows 14 to 16 and 19 to 20.
- **Acceptance:** DERIVED, `[OPEN]` until confirmed (Q8). (1) After the third failed retry of any queued item, the ticket's card and its completed row in Jobs show "Sync failed — tap to retry"; before it they show only what they show today; the open ticket's own screens show nothing new. (2) Tap with the API reachable: the count is reset, a drain for that ticket starts, and the badge goes when the item lands; this works while the phone's network flag says offline. (3) Tap with the API unreachable: the existing offline message appears, the count is not reset and nothing is sent. (4) After the item is sent, the badge is gone.
- **Edges:**
  - **Reached by:** the ledger of any ticket draft on the device, read by `useTicketProgress` (`use-ticket-progress.ts:129`, which already builds `hasOfflineData` per ticket from `computeHasOfflineData`, `:96-113`) and shown by `ticket-card.tsx` (where the warn-tone "Offline" badge shows, `:168-172`) and by `app/(field)/jobs.tsx` (where the completed row's "Offline" badge shows, `:260`).
  - **Does not apply when:** a ticket with no exhausted item (shows nothing new); a 409-refused item (REQ-08: never counted, so never flagged; the window-closed item keeps the existing "Request approval" path); the open ticket's own screens (Q9); a failed ticket submit (REQ-13).
  - **When an input is absent:** a draft with no counters reads as zero failures.
  - **Trust boundary:** the probe asks the server; the phone trusts a `200` from `/health` and nothing else (`lib/api-reachable.ts`).
  - **Read time:** N/A.
- **What the tap does (settled by the developer's "sure"):** (1) call `isApiReachable()`; (2) if it returns `true`, reset the retry count of the ticket's exhausted items and start a drain for that ticket without waiting on the NetInfo flag; (3) if it returns `false`, show the existing offline message and do nothing else. This replaces the earlier assumption that the tap while offline only shows a message: the message now follows a failed probe, not the NetInfo flag.
- **Notes for the executor — what exists today, and what is new.**
  - *Exists today.* The card header shows a warn-tone "Offline" badge with a wifiOff icon when `hasOfflineData` is true (`components/field/ticket-card.tsx:108-110` prop, `:168-172` render, test id `ticket-card-offline-badge`); the completed-ticket row in Jobs shows the same badge (`app/(field)/jobs.tsx:260`, test id `completed-ticket-offline-badge`). `hasOfflineData` is true for an offline-submitted ticket, for any ledger entry that still has ops (so a `failed` step with ops also reads as "Offline"), or for any unsent local attachment (`use-ticket-progress.ts:96-113`, set at `:302`, returned at `:321`). There is no failed-sync indicator and no field that says an entry has been retried. The badge is not tappable today. The whole card body is pressable (`ticket-card.tsx:372`, `:391`, `onPress={onOpen}`), so a tappable badge is a nested press target (48px, `contexts/mobile.md`). The helper `isApiReachable()` already exists on `staging` (`apps/mobile/lib/api-reachable.ts`: one `GET /health`, 4 s timeout, only a `200` counts, never throws; it arrived with the merge of `fix/mobile-error-toast-and-offline-submit-probe`; `git cat-file -e origin/staging:apps/mobile/lib/api-reachable.ts` succeeds). The background sync gates on its own copy of the NetInfo flag, `syncOnline` (`background-sync.ts:55`, set at `:605`; read at `:101` in the draft context's `canContinue`, at `:529` in `syncSingleDraft`, at `:557` in `runScan`, and at `:630`).
  - *New.* A separate failed-sync reading per ticket (derived from the retry counts), passed through `TicketProgress` to the card and the Jobs row; the badge with the exact text above; the tap handler; and a way for the background sync to run a drain that does not wait on `syncOnline` (§11a row 20). Do not reuse "Offline" for the new badge. Its look is not given: ASSUMED the shared `Badge` component as the existing badge uses (`tone="warn"`), with the new text; reviewable. The existing "Offline" badge is unchanged and may show beside it (a failed item has ops, so it reads as "Offline" today); ASSUMED, reviewable.

### REQ-13 — A ticket the server has not completed is never shown as completed on the phone; a submit the server never accepted raises the failed-sync badge `[UNVERIFIED]`

- **Statement:** The phone shows a ticket as completed only when the server says `COMPLETE`, or when the draft records a local submission (submitted, or waiting to sync); a step counter past the last step does not by itself make a ticket completed while the server holds it as anything else. A submit the server never accepted (`submitState: 'error'`) raises the same "Sync failed — tap to retry" badge as an exhausted step. *(Replaces the earlier `[OPEN]` statement; the history is in Q11.)*
- **Surface:** mobile
- **Sources:** developer direction, session 2026-10-30: "real fix here" and "if these tickets are not saved on server side due to any issue then these should not show as completed on mobile. The ticket state should be consistent!" Status `reference`; the exact rule is the AI's reading (D22).
- **Conflict:** n/a
- **Open question:** Q11, answered in part (the retry counting for a failed submit is still unspecified).
- **Ripple:** `isSubmittedLocally` feeds the Recently Completed partition (`partitionDashboardTickets`), the card status, the status filter and the "Offline" icon; `isTicketComplete` feeds the ticket screen's read-only state (three call sites). Evidence: TK-00031 and TK-00032 on the emulator, server `IN_PROGRESS`, shown as completed with an Offline icon.
- **Acceptance (derived, unconfirmed):** a ticket the server holds as `IN_PROGRESS` with no recorded local submission appears under Active, not Recently Completed, with no Offline icon, and opens editable on its last step; a ticket with `submitState: pendingSync` still shows as completed with the Offline icon; a ticket with `submitState: error` shows the Sync failed badge.
- **Edges:** server status unknown (list not loaded, offline cold start): the counter is trusted as before. A ticket just submitted online whose list has not refreshed: `submitState: submitted` keeps it completed.
- **Notes for the executor:** built in U7.

### REQ-14 — A photo whose upload has landed shows the double tick at once `[UNVERIFIED]`

- **Statement:** A checklist, deficiency or signature photo held on the device shows one tick; once its file is uploaded (the sync ledger entry has a `serverId`) it shows two, without leaving or reopening the step.
- **Surface:** mobile
- **Sources:** developer report 2026-10-30 ("it did not sync … I still see the single green tick"); reproduced on the emulator (upload 201 about 3 s after reconnect, tick unchanged). The tick meanings are in `sync-status-badge.tsx` ("local: single tick; server: double tick").
- **Conflict:** n/a
- **Open question:** none.
- **Ripple:** `ChecklistEngine` photo grid and preview, `deficiency-panel`, `signer-capture`; all read `sync.attachments` through one helper (D21).
- **Acceptance (derived, unconfirmed):** capture offline: single tick; reconnect and stay on the screen: double tick within seconds.
- **Edges:** the saved step still holds `local:<id>` until sent; the next send replaces it with the server id as before.
- **Notes for the executor:** built in U6.

### REQ-15 — A checklist photo is labelled with its checklist when it is uploaded `[UNVERIFIED]`

- **Statement:** The `category` of a checklist photo's `attachments` row ("Pre-Trip Checklist", "JSA Checklist", "Post-Trip Checklist") is written when the photo is uploaded, online or from the offline queue, not only when the checklist is submitted.
- **Surface:** mobile, api
- **Sources:** developer request 2026-10-30 ("It should assign the category right away … we do not have to wait for continuing to next step"). The labels already exist (`CHECKLIST_CATEGORIES`, written at submit by `labelAttachment`).
- **Conflict:** n/a
- **Open question:** none. Signature images are still labelled when the step is saved (not requested here).
- **Ripple:** `POST /field/tickets/:id/checklists/attachments` gains an optional `checklistType` body field (an addition, no response change: G5 not triggered); the queued entry stores it (`LocalAttachmentEntry.checklistType`).
- **Acceptance (derived, unconfirmed):** upload a Pre-Trip photo online: the row shows "Pre-Trip Checklist" at once; an upload without the field is still labelled at submit.
- **Edges:** a repeated upload (`clientUploadId`) returns the stored row unchanged. An invalid `checklistType` is a 400.
- **Notes for the executor:** built in U8; not yet exercised against a rebuilt API.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no — **revised 2026-10-30 (D20)**; the earlier plan added one model, `StorageDeletionJob` (table `storage_deletion_queue`), and it is dropped. Everything under this heading below, up to §4, is the earlier design, kept as the record; nothing in it is built.
- **Migration required:** no (revised 2026-10-30; earlier plan: yes) — `pnpm db:migrate`, committed under `apps/api/prisma/migrations/`, mandatory (`contexts/prisma.md` → Migrations). The generated `schema.dbml` is regenerated as in recent commits (`c0d18f9de`).
- **Data backfill required:** no. Existing orphans are not swept (G2; §13).
- **Existing models considered:**
  - `PayrollCalculationJob` (`schema.prisma:6100`, table `payroll_calculation_queue`): the nearest queue. Rejected as the table to reuse: `periodId` is a required FK with `onDelete: Cascade` to `PayrollPeriod`, `trigger` is the payroll enum `PayrollCalcTrigger`, and the poller claims jobs by period (developer decision 2026-10-29). Its columns and indexes are mirrored (D1).
  - `Attachment`: the row being deleted. A soft-delete flag was considered and rejected: the intent says the row is deleted, and a flag would leave rows that every list query must then filter (the `contexts/prisma.md` scope-filter warning, SCRUM-252).
  - `ActivityLog`: an audit trail, not a work queue with retry state. Rejected.
  - A lifecycle rule in S3: ruled out by the developer's decision.
  - Why a new table: a lifecycle independent of its parent (the attachment row is deleted while the job lives on) and a one-to-many shape (one job holds several keys).

```prisma
// Structural proposal (D1, D2, D13). Reviewable by the developer in the PR.
// model StorageDeletionJob {
//   id              String   @id @default(uuid()) @db.Uuid
//   tenantCompanyId String   @map("tenant_company_id") @db.Uuid
//   objectKeys      String[] @map("object_keys")          // every S3 key the deleted row owned
//   status          StorageDeletionJobStatus @default(PENDING)   // PENDING | PROCESSING | COMPLETED | FAILED
//   attempts        Int      @default(0)
//   maxAttempts     Int      @default(8) @map("max_attempts")   // D3
//   lastError       String?  @map("last_error")
//   nextRetryAt     DateTime? @map("next_retry_at") @db.Timestamptz()
//   completedAt     DateTime? @map("completed_at") @db.Timestamptz()
//   createdAt       DateTime @default(now()) @map("created_at") @db.Timestamptz()
//   updatedAt       DateTime @updatedAt @map("updated_at") @db.Timestamptz()
//   tenantCompany   TenantCompany @relation(fields: [tenantCompanyId], references: [id])
//   @@index([status, nextRetryAt], name: "idx_storage_deletion_queue_poll")
//   @@index([tenantCompanyId], name: "idx_storage_deletion_queue_tenant")
//   @@map("storage_deletion_queue")
// }
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `StorageDeletionJob` | none (internal queue row) | none | N/A | REQ-03 |

- **New prefix introduced:** no — an internal queue row, not a business entity (`intent.md` §7).
- **Child relations:** `tenantCompanyId → TenantCompany.id` (UUID FK, as `PayrollCalculationJob`). No FK to `attachments`: the row is deleted in the same transaction, so a reference could not exist (D2). `onDelete` for the tenant FK: the default, as `PayrollCalculationJob` (`schema.prisma:6115`).
- **Fields whose type/precision no source states:** `maxAttempts`, backoff, batch size: AI decisions D3, no source. Retention of COMPLETED rows: `NOT SPECIFIED` (no purge in this ticket; a follow-up). FAILED rows are kept (REQ-11, Q7 = A).
- **Tenant scoping (G3):** a new tenant-data model goes in `TENANT_SCOPED_MODELS` (`apps/api/src/orm/prisma.service.ts:26`; `payrollcalculationjob` is at line 201 for reference). `prisma.service.spec.ts` fails otherwise. `tcg-prisma-guardian` runs on U1. The worker runs outside a request, where scoping is skipped by design (`contexts/prisma.md` → Tenant scoping is conditional); D6 runs each job under its own tenant anyway.

## 4. API surface — `apps/api`

Layering is `presentation → usecase → service → orm`, never upward.

- **Pattern:** none in `patterns.md` fits (P1 is a coded business CRUD, P2 a reference list, P3 entity photos; this is a background queue). Nearest existing instance, not a registry entry: `PayrollCalculationJob` and `payroll-calculation-queue.{service,repository}.ts`. Recorded as D12 and offered to Haris as a possible new entry. This is not a deviation from a pattern.
- **Existing functions/services to reuse** (checked): `PayrollCalculationQueueRepository` shapes (`enqueue`, `claimNextJob`, `reclaimStaleJobs`, `markCompleted`, `markFailed` with `RETRY_DELAYS_MS`) at `apps/api/src/service/payroll/payroll-calculation-queue.repository.ts`; `TenantContextService.run` (`@context/tenant-context`); `S3StorageService.deleteObject` (`apps/api/src/service/storage/s3-storage.service.ts:106`); `ticketImageObjectKeys` (key list of an attachment row); `AttachmentsRepository.removeIfUnreferenced` (`attachments.repository.ts:66`); `ScheduleModule.forRoot()` (already in `app.module.ts:155`, with `@nestjs/schedule` ^6.1.3). No new dependency: `grep -nE '"@aws-sdk|bullmq|ioredis|redis|sqs' apps/api/package.json` finds only `client-s3`, `client-sesv2`, `client-sns` and the presigner.
- **New exported functions/services proposed:** (1) `StorageDeletionQueueRepository` in `service/storage-deletion/` with `enqueueIn(tx, …)`, claim, reclaim and mark methods; (2) `StorageDeletionQueueService` (the worker) in `usecase/storage-deletion/` with the `@Interval` poll and an `attemptNow(id)` for the immediate try; (3) one method on `AttachmentsRepository` that deletes a row and enqueues in one transaction; (4) one error-code constant in `@tcg/shared` (D14). File and class names follow `payroll-calculation-queue.{service,repository}.ts` and are reviewable. Nothing existing fits: the payroll queue is period-bound (§3). Each is a §11b decision (D1, D4, D5).

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/api/v1/field/tickets/:id/checklists/attachments/:attachmentId` | `field-tickets.controller.ts:398` (unchanged route) | `checklist-assignments.service.ts` `removeItemPhoto` | `attachments.repository.ts` | REQ-01, REQ-05 |
| `DELETE` | `/api/v1/field/tickets/:id/signatures/attachments/:attachmentId` | `field-tickets.controller.ts:590` | `ticket-signatures.service.ts` `removeAttachment` | same | REQ-01, REQ-05 |
| `DELETE` | `/api/v1/field/tickets/:id/lunch-breaks/attachments/:attachmentId` | `field-tickets.controller.ts:674` | `ticket-lunch-breaks.service.ts` `removeAttachment` | same | REQ-05 |
| `DELETE` | `/api/v1/field/tickets/:id/attachments/:attachmentId` | `field-tickets.controller.ts:540` | `ticket-attachments.service.ts` `remove` | same | REQ-05, REQ-06 |
| `DELETE` | `/api/v1/attachments/:id` (the generic admin route; the global prefix is assumed) | `attachments.controller.ts` `remove` | `attachments.service.ts` `delete` | same | REQ-05 |

No new route. The five above keep their paths and their `204`. Per endpoint:

- **Request DTO:** none new. Each route gains an optional `X-Captured-At` header read through `parseCapturedAtHeader` (REQ-01 notes). No body change.
- **Response shape:** unchanged — `204 No Content`. No G5 shape change.
- **Guards / roles:** `AccessTokenGuard` (global); the existing `getTicketForEmployeeAction` ownership checks. Unchanged.
- **Route param identity:** unchanged (ticket id from the route, attachment UUID).
- **Errors:** unchanged, except (a) D11, confirmed: Attach File delete of a missing id answers `204`, was `403`; (b) D14: the 409 for "image is part of a saved signature" (`removeIfUnreferenced`, `attachments.repository.ts:77-80`) becomes an object body `{ message, code }` with a new code, so the phone can tell it from the window-closed 409 (`code: 'TICKET_WINDOW_CLOSED'`, unchanged). **This is an error-body change only: no success shape changes (204 stays).** Message text is kept. G5: the trigger is a *changed response shape*; an error body gaining a field on one 409 is additive, and the only consumer that reads these 409s is the mobile drain, which U3 changes in the same stack. `tcg-contract-tracer` is nonetheless run on U2 as a precaution, with the consumer list in §11a row 12.
- **Pagination:** N/A.
- **Module registration:** none new (revised 2026-10-30, D20; earlier plan: a `StorageDeletionModule`); barrel `index.ts` in each new folder; `TicketAttachmentGuardService`, `TicketAttachmentsService` and any provider that gains the outbox repository in its constructor need it provided in their modules: `grep -rn "TicketAttachmentGuardService" apps/api/src --include=*.module.ts` for the DI graph; boot the API once after U2 (`contexts/api.md` → Testing).

## 5. Web surface — `apps/web`

N/A — no web change. Established by: `grep -rn "field/tickets" apps/web/src` and `grep -rn "checklists/attachments\|signatures/attachments" qa-automation` returned no match (2026-10-29), so no web or E2E caller of the four DELETE routes exists.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** none new. Touched: `components/capture/use-photo-removal.ts`, `components/field/deficiency-panel.tsx`, `components/field/signer-capture.tsx` and `features/field-ticket/steps/shared/checklist/ChecklistEngine.tsx` (callers), `components/field/ticket-attachments-sheet.tsx`, `features/field-ticket/sync/step-ops.ts`, `drain.ts`, `background-sync.ts`, `use-ticket-outbox.ts`.
- **Components:** reuse the existing sheet and `Badge` (`components/field/ticket-card.tsx:168`). Tokens from `theme/tokens.ts`. The queued-row marker is the text "Pending sync" (REQ-10).
- **Offline / sync behavior:** specified in REQ-01, REQ-02, REQ-06, with design in §11b D8 to D10. The existing queue, as read on 2026-10-29: per ticket draft in AsyncStorage under the owner's `ticket:` prefix; `runScan` visits every draft and drains it on reconnect (`background-sync.ts:548-567`); a step's ops are sent in order by `runStepOps` (`step-ops.ts:197-214`); the first failure stops the draft (`drain.ts:162-171`); a 409 is read as "window closed, request approval" (`drain.ts:169`). The product-level offline requirement is written only in FR-TCG-FOP-001 and sits under the unresolved conflict (§0). Retention, the retry limit and the failed-sync indicator come from the developer's Q4 answer (REQ-09, REQ-12): no age limit; 3 retries; a badge on the ticket card. How the retry count is kept and counted is D19. The developer later set: 1 send + 3 retries (4 in all), only server-refused sends count, the badge reads "Sync failed — tap to retry" on the ticket card and the completed rows in Jobs, and the tap probes the API first (REQ-09, REQ-12).
- **Touch targets:** 48px (`contexts/mobile.md`).
- **Push / notifications involvement:** N/A.

## 7. Shared package — `packages/shared`

- **Types added / changed:** one error-code constant for the signature-referenced 409 (D14), beside `TICKET_WINDOW_ERROR_CODES` in `packages/shared/src/utils/ticket-completion-window.ts:62`, exported through `packages/shared/src/utils/index.ts`. Consumed by the API (throws it) and mobile (reads it); web does not call these routes (§5). Nothing else: the new op kind and the queue entry are mobile-local types in `step-ops.ts`, and the API gains no new response shape. Shared is consumed as built `dist/` (root `CLAUDE.md`): build it before mobile.

## 8. Permissions and tenancy

- **Roles permitted:** whoever may delete a ticket attachment today (unchanged; `intent.md` §8). `NOT ON TICKET` for any new rule.
- **Roles denied:** `NOT ON TICKET`. No new denial.
- **Tenant isolation:** no new model (D20; earlier plan: a tenant-scoped queue table, G3). The deletes run inside the request's own tenant context and the existing tenant extension.
- **Cross-tenant reads:** none (D20; earlier plan: a cross-tenant poll).

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Queued attachment size (each file) | the existing online cap `TICKET_ATTACHMENT_MAX_BYTES` = 50 MB applies unchanged | developer answer 2026-10-29 (Q5), status `reference`; `packages/shared/src/constants/attachments.ts:5` (code, descriptive) | `[UNVERIFIED]` |
| Queued attachment count and total bytes | none — the developer chose no count or total cap | developer answer 2026-10-29 (Q5), status `reference` | `[UNVERIFIED]` |
| Outbox `maxAttempts`, backoff, batch size | AI decision D3, no source | — | not a requirement |
| Queue age before a queued op is abandoned | none — no retention limit; a queued item waits as long as it takes | developer answer 2026-10-29 (Q4), status `reference` | `[UNVERIFIED]` |
| Retries before an item is marked failed-sync | 3 retries after the first send, 4 sends in all (D17); only a send the server answered with an error other than 409 counts (D19, Q12 answered) | developer answers 2026-10-29 (Q4, retry count, Q12) | `[UNVERIFIED]` |
| Failed-sync badge text | "Sync failed — tap to retry" | developer answer 2026-10-29 (Q10), status `reference` | `[UNVERIFIED]` |

## 10. Tests

`not requested` (root `CLAUDE.md`; the ticket does not ask). Existing tests are run, not added. Two existing tests are known to assert today's behaviour and will fail when it changes: `components/field/ticket-attachments-sheet.test.tsx` (the blocking messages) and, depending on D9, `features/field-ticket/sync/drain.test.ts` / `background-sync.test.ts` (union exhaustiveness). Updating a test the change breaks is not adding a test; say so in the PR.

- Requirements with no confirmed testable criterion: every criterion is derived and unconfirmed (Q8); REQ-13 has none (`[OPEN]`, Q11).

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`. The S3 deletes now run inside the row delete's transaction, so a delete holds a database connection for the S3 round trip (two `DeleteObject` calls in parallel for an image); the transaction timeout is 20 s (D20).
- **Concurrency:** claim with `FOR UPDATE SKIP LOCKED` so two API processes never take the same job; reclaim a PROCESSING job whose process died; the immediate attempt claims its own row by id (D5). A duplicate S3 delete is harmless (ASSUMED, see REQ-04). On the phone, deletes drain under the same per-ticket sync lock as other ops (`coordinator.ts`, `runWithTicketSyncLock`).
- **Audit / activity log:** N/A for the S3 delete (D20). A late-captured delete accepted under L17 is audited by the existing window guard (`TICKET_LATE_CAPTURE_ACCEPTED`, `job-tickets.service.ts` `enforceTicketWriteWindow`) once the delete routes pass `capturedAt`.
- **Migration/rollout order (revised 2026-10-30, D20):** the in-transaction S3 delete at the delete sites (U2) → mobile delete op (U3) → Attach File queue (U4) → failed-sync badge (U5). No schema or migration step. U2 before U3 so a queued delete reaches an API that already guards the two 409 causes.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `features/field-ticket/sync/use-ticket-outbox.ts:41-65` (post-drain sweep: fire-and-forget DELETE of uploaded, unreferenced photos; failure is lost) | the new delete op | REQ-01 | changes deliberately: the sweep enqueues the same op instead of a one-shot request (D9) | `intent.md` §3 ("no persistent delete queue") | `grep -rn "deleteItemPhoto\|deleteAttachment" apps/mobile --include=*.ts --include=*.tsx` |
| `usePhotoRemoval` callers: `deficiency-panel.tsx:156`, `signer-capture.tsx:118`, `ChecklistEngine.tsx:1301` | hook contract | REQ-01, REQ-02 | unchanged: same return type, still clear local UI regardless of outcome (`use-photo-removal.ts:23-26`) | `intent.md` §4 | `grep -rn "usePhotoRemoval(" apps/mobile --include=*.tsx --include=*.ts` |
| `StepSyncOp` union and its consumers: `step-ops.ts` (`sendOp` switch), `drain.ts`, `background-sync.ts`, `repair-ops.ts`, `checklist-ops.ts`, `start-work-ops.ts`, `ticket-flow.store.ts`, `ticket-step-screen.tsx` | a 12th kind | REQ-01, REQ-06 | changes deliberately: every exhaustive switch and filter gains the kind | `intent.md` §6 | `grep -rln "StepSyncOp\|runStepOps\|sendOp" apps/mobile --include=*.ts --include=*.tsx` |
| the four DELETE routes and the mobile service methods that call them | route behaviour | REQ-05, REQ-01 | unchanged success contract (204); gains the optional `X-Captured-At` header; D11 (confirmed) changes one error case; D14 adds a `code` to one 409 body | `intent.md` §4; L17 | `grep -n "@Delete" apps/api/src/presentation/field-tickets/field-tickets.controller.ts` |
| `cleanupReplaced` callers: `ticket-signatures.service.ts:239`, `ticket-lunch-breaks.service.ts:321, 383`, `checklist-assignments.service.ts:662`; `discardObjects` callers `ticket-attachment-guard.service.ts:191, 199` | the four sites | REQ-05 | changes deliberately: failure no longer swallowed, the job is enqueued; callers' results unchanged | `intent.md` §2 | `grep -rn "cleanupReplaced\|removeUnreferenced\|deleteOrphaned\|discardObjects" apps/api/src --include=*.ts` |
| `TicketAttachmentsService.remove` (`ticket-attachments.service.ts:150`) and its mobile caller `useDeleteTicketAttachment` | fifth delete site | REQ-05, REQ-06 | changes deliberately (D7, confirmed 2026-10-29) |
| the generic admin route `DELETE /attachments/:id` (`attachments.controller.ts` `remove`; `AttachmentsService.delete`, `attachments.service.ts:300`) and its callers | sixth delete site | REQ-05 | changes deliberately: the S3 delete goes through the outbox; the 204 contract and the photo-feature branch (`photos.remove`) are unchanged | developer answer 2026-10-29 (folded into U2), status `reference` | `grep -rn "attachments/" apps/web/src apps/mobile qa-automation --include=*.ts --include=*.tsx -l \| head` (callers of the generic route to be listed by the executor) | `intent.md` §2 ("an unused file remains in S3"); developer answer 2026-10-29, status `reference` | `grep -rn "deleteObject(" apps/api/src --include=*.ts` |
| mobile pre-submit check and draft sync flag: `features/field-ticket/sync/verify.ts` (`findStepDiscrepancies`), `lib/ticket-draft-sync` (`ticketNeedsSync`, `hasUnsyncedSteps`, `hasUnsyncedAttachments`) | the reserved ledger key (D9) | REQ-01, REQ-06 | must treat a pending delete as unsynced work and must not read it as a step; an executor check | `intent.md` §4 | `grep -rn "ticketNeedsSync\|hasUnsyncedSteps\|findStepDiscrepancies" apps/mobile --include=*.ts` |
| `components/field/ticket-attachments-sheet.tsx:118-121`, `:209-212` and its test | the two offline blocks | REQ-06 | changes deliberately: the blocks go; queued rows show "Pending sync" (REQ-10) | `intent.md` §3-4; developer answer 2026-10-29 (Q6), status `reference` | `grep -n "Offline — reconnect" apps/mobile/components/field/ticket-attachments-sheet.tsx` |
| the cached attachment list and cached ticket queries on the phone | `useTicketAttachments`, persisted query cache (`lib/query-persistence.ts`, 3 days) | REQ-02, REQ-06 | a removed file must not reappear from the cache before the delete lands; a queued add shows "Pending sync" (REQ-10) | `intent.md` §4; developer answer 2026-10-29 (Q6), status `reference` | `grep -rn "ticketAttachments(" apps/mobile --include=*.ts --include=*.tsx` |
| `TENANT_SCOPED_MODELS` and `prisma.service.spec.ts` | new model | REQ-03 | changes: one entry added (G3) | `contexts/prisma.md`, root `CLAUDE.md` G3 | `grep -n "payrollcalculationjob" apps/api/src/orm/prisma.service.ts` |
| the mobile drain's reading of every 409 as "request approval" (`drain.ts:162-170`; `needsEditRequest`) | a refused delete | REQ-08 | changes deliberately: window-closed keeps the op and the existing "Request approval" path; signature-referenced drops the op, restores the photo and tells the crew | developer answer 2026-10-29 (Q2), status `reference` | `grep -n "409" apps/mobile/features/field-ticket/sync/*.ts` |
| readers of the 409 body on the DELETE routes: the mobile drain and background scan only (web and `qa-automation` do not call the routes, §5) | the new `code` on the signature-referenced 409 (D14) | REQ-05, REQ-08 | error body gains a field; success shape unchanged; `tcg-contract-tracer` run on U2 | developer answer 2026-10-29 (Q2), status `reference` | `grep -rn "getHttpStatus\|=== 409" apps/mobile --include=*.ts --include=*.tsx \| grep -v test` |

| every step entry that fails today and is resent at each drain and each scan without limit (`drain.ts:89-91`, `:162-171`; `background-sync.ts:232-263`, `:548-567`) | the new counter and stop rule | REQ-09 | changes deliberately: after the 3rd failed retry (4 sends in all) the entry is no longer resent by itself; it stays on the device with its ops; a send the server never answered is not counted and keeps being resent on every scan | developer answers 2026-10-29 (Q4, retry count, Q12), status `reference` | `grep -rn "markStepFailed\|markRejectedStep\|orderedUnsynced" apps/mobile --include=*.ts --include=*.tsx \| grep -v test` |
| the ticket card and its "Offline" badge (`ticket-card.tsx:168-172`) and the completed-ticket row (`jobs.tsx:260`) | `hasOfflineData` and the new failed-sync reading | REQ-12 | the active card and the completed row in Jobs each gain the "Sync failed — tap to retry" badge; the existing "Offline" badge is unchanged; the open ticket's own screens do not change | developer answers 2026-10-29 (Q4, Q9, Q10), status `reference` | `grep -rn "hasOfflineData" apps/mobile --include=*.ts --include=*.tsx \| grep -v test` |
| `useTicketProgress` and its `TicketProgress` type (`use-ticket-progress.ts:36`, `:96-113`, `:293-321`) | the failed-sync reading added to the progress map | REQ-12 | changes: a new field on `TicketProgress`; callers that spread the map ignore it | developer answer 2026-10-29 (Q4) | `grep -rn "useTicketProgress\|TicketProgress" apps/mobile --include=*.ts --include=*.tsx \| grep -v test` |
| the pre-submit manual drain (`useDrainTicket`, `use-ticket-outbox.ts:24-68`, used in `ticket-step-screen.tsx:513`, `:695`) and the submit gate (`canFinalizeDraft` requires `!hasUnsyncedSteps`, `background-sync.ts`) | the stop rule | REQ-09 | the manual drain stays; the badge tap is a second way to retry and resets the count (REQ-12); a failed item still blocks the submit as a failed step does today | developer answer 2026-10-29 (Q10), status `reference`; nearest existing behaviour | `grep -rn "useDrainTicket\|canFinalizeDraft" apps/mobile --include=*.ts --include=*.tsx \| grep -v test` |
| ticket drafts already stored on devices (`StepSyncEntry`, `ticket-flow.store.ts:69-88`; `withStepSync` `:381-398`) | a new persisted field | REQ-09 | migrated by reading a missing count as 0; `withStepSync` must carry the count, or every write to the step resets it | ASSUMED, D19 | `grep -n "withStepSync" apps/mobile/features/field-ticket/ticket-flow.store.ts` |
| a ticket submit that fails (`submitState: 'error'`, `submissionPending`; `background-sync.ts:354-362`) | the failed-sync rule | REQ-13 | **OPEN — Q11**; until answered the submit keeps today's behaviour | none | `grep -n "submitState: 'error'" apps/mobile/features/field-ticket/sync/background-sync.ts` |

| the badge tap's reachability check: `isApiReachable()` (`apps/mobile/lib/api-reachable.ts`; on `origin/staging`) and its existing callers | the new tap handler | REQ-12 | unchanged; one more caller. The helper is an existing helper on `staging`, not an unmerged dependency | developer answer 2026-10-29 ("sure"), status `reference`; the coordinator verified the file on `origin/staging` | `grep -rn "isApiReachable" apps/mobile --include=*.ts --include=*.tsx \| grep -v test` |
| the background sync's online gate `syncOnline` (`background-sync.ts:55`, `:101`, `:529`, `:557`, `:630`) and `scanAndSyncTickets` (`:570-583`) | the tap must start a drain for one ticket although the NetInfo flag says offline | REQ-12 | **needs from `background-sync.ts`: a way to run a drain for one ticket that does not wait on `syncOnline`** (today `syncSingleDraft` returns without sending when `syncOnline` is false, and `canContinue` stops a run when it turns false). How it is built is for the decomposer and executor; every other caller keeps the gate. A tap that starts a drain while NetInfo says offline is also the path that the open-ticket drain (`drain.ts`, which has no `syncOnline` check) already allows | developer answer 2026-10-29 ("sure"), status `reference` | `grep -n "syncOnline" apps/mobile/features/field-ticket/sync/background-sync.ts` |

- **Surfaces with no existing behaviour in this area:** (none server-side after D20; the outbox table and worker were dropped). Web and `qa-automation`: no caller of the DELETE routes (`grep` returned no match, §5).
- **Consumers with no source for what happens to them:** a failed ticket submit (Q11). Assumed, not sourced: which HTTP errors count (D19); a photo still named by a completed step's stored write (REQ-07 notes).

## 11b. AI decisions — reviewed by a developer

Rows D1 to D4 record the developer's decisions of 2026-10-29 (relayed in the request). D7 and D11 were confirmed by the developer the same day. D16 to D18 record the developer's Q4 answer and the answers that followed. D5, D6, D8 to D10, D12 to D15 and the still-assumed items of D19 are decided or assumed by the AI and wait for review in the PR; D13 to D15 and D19 were added when the developer's answers were folded in. No row waits for an answer.

| ID | Decision | Chosen | Why / alternatives (with existing code found) | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | S3 cleanup mechanism and table — **superseded 2026-10-30 (D20)** | Transactional outbox in a **dedicated table**, mirroring `PayrollCalculationJob` (`status`, `attempts`, `maxAttempts`, `lastError`, `nextRetryAt`; `@Interval` poll with reclaim, claim, mark). No Redis, no SQS, no new dependency, no S3 lifecycle rule. **This answers Q10 of `MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12** (see below). | Developer decision 2026-10-29, relayed. Rejected: reusing `payroll_calculation_queue` (period-bound: required `periodId` FK, payroll trigger enum, `schema.prisma:6100-6122`); BullMQ/SQS/Redis (not in the stack: `apps/api/package.json` has only `client-s3`, `client-sesv2`, `client-sns`); an S3 lifecycle rule (no S3 bucket lifecycle rule is defined in the repo: `grep -rli lifecycle --include=*.tf --include=*.yml --include=*.yaml --include=*.json --include=*.sh` finds only an ECR image policy at `deploy/setup-infra.sh:222-238`; the bucket's real configuration is not recorded in the repo, and the code comments that say a failed object is "swept by S3 lifecycle" cite nothing). Model name: D13. | no | Haris (decided, relayed) | 2026-10-29 |
| D2 | Outbox row shape — **superseded 2026-10-30 (D20)** | One row per deleted attachment, holding `objectKeys String[]` (from `ticketImageObjectKeys`), `tenantCompanyId` FK, and the payroll queue's retry columns; no FK to `attachments`; indexes `[status, nextRetryAt]` and `[tenantCompanyId]` | The row is gone when the job runs, so an FK is impossible; a key array avoids a child table. Alternative: one row per key (rejected: more rows, and the pair original + preview belong together). | no | | |
| D3 | Worker numbers (not escalated, per the brief) — **superseded 2026-10-30 (D20)** | poll every 10 s (`POLL_INTERVAL_MS = 10_000`, the payroll queue's beat); claim up to 25 jobs per poll with `FOR UPDATE SKIP LOCKED`; `maxAttempts` 8; wait after attempt *n* = 60 s doubling (60 s, 2 m, 4 m, 8 m, 16 m, 32 m, 64 m: about 2 h 7 m in total); a job PROCESSING for more than 5 minutes is put back (`STALE_CLAIM_MS` analogue) | Nearest code: `payroll-calculation-queue.service.ts:25-26` (10 s poll) and `payroll-calculation-queue.repository.ts:18-19` (`RETRY_DELAYS_MS = [2_000, 5_000]`, 3 attempts). Deviation: payroll's 3 attempts over 7 seconds cannot "retry until cleanup succeeds" through an S3 outage; a longer budget is chosen. Batch 25 because each job is one S3 call and one poll per job would drain 360 jobs an hour. **All of these numbers have no source**; they are proposals the developer can change in the PR. | no | | |
| D4 | Where the enqueue happens — **revised 2026-10-30 (D20): the S3 delete replaces the job insert** | A new `AttachmentsRepository` method deletes the row and inserts the outbox row inside one `$transaction`; `removeIfUnreferenced` inserts inside its existing transaction; `discardObjects` (no row exists) inserts the job alone, and if that insert itself fails, falls back to today's best-effort delete and logs | Precedent: `removeIfUnreferenced`'s transaction, and P3's `deleteOwnerPhotosIn` inside the transaction then delete files after commit. A cross-repository transaction is avoided by giving the outbox repository an `enqueueIn(tx, …)`. | no | | |
| D5 | Immediate attempt after commit — **superseded 2026-10-30 (D20)** | After commit the service tries to delete the keys at once; it first claims its own row by id with the same conditional update the worker uses, so the worker and the request never both take it; on success the job is COMPLETED, on failure it stays PENDING with the next retry time. S3 failure never fails the HTTP request | `intent.md` §3 step 2. Alternative: leave every delete to the worker (rejected: adds up to one poll of delay for every delete in the normal case). | no | | |
| D6 | Tenant context in the worker — **superseded 2026-10-30 (D20)** | Each job runs inside `TenantContextService.run({ tenantCompanyId: job.tenantCompanyId, userId: <nil UUID>, userRole: ADMIN })` as the payroll worker does (`payroll-calculation-queue.service.ts:93-100`) | `intent.md` §8 asks for it. The S3 keys are complete, so the work needs no tenant data; running under the tenant keeps any scoped read honest. | no | | |
| D7 | The extra delete sites | `TicketAttachmentsService.remove` (`ticket-attachments.service.ts:150-166`, the Attach File delete route) deletes its S3 objects in the row delete's transaction too (D20; was: enqueues), as part of U2; and so does the generic admin route `DELETE /attachments/:id` (`AttachmentsService.delete`). **The delete sites are therefore six**: `removeUnreferenced`, `deleteOrphaned` (which covers `cleanupReplaced`), `discardObjects`, `TicketAttachmentsService.remove`, and the generic `AttachmentsService.delete` (the first four named by the developer, `cleanupReplaced` counted apart from `deleteOrphaned` it calls). | The developer's list names four sites in `ticket-attachment-guard.service.ts`. A grep for `deleteObject(` found a fifth that swallows the same way, on the route U4 queues; leaving it would make "guaranteed S3 cleanup" false for exactly the files U4 deletes. Confirmed by the developer 2026-10-29. The generic route was folded into U2 by a later developer decision the same day (developer answer, session 2026-10-29, status `reference`) because it can delete a ticket attachment and swallowed a failed S3 delete; a photo-feature row on it still goes to `photos.remove`, unchanged. Entity-photo (`attachment-photos.service.ts:446`) and signed-copy (`signed-copy-attachments.service.ts:223`) swallows stay §11c follow-ups. Built in U2 commits `3626d1295` and `7d826e40e`. | no | Haris (confirmed, session 2026-10-29) | 2026-10-29 |
| D8 | Mobile delete op | A new `StepSyncOp` kind `deleteAttachment` with the target (`checklist` / `signatures` / `attachments`) and the server attachment id, stamped with `capturedAt` when queued like every other op (`step-ops.ts:67-75`); `sendOp` calls the existing service methods `checklists.deleteItemPhoto`, `ticketSignatures.deleteAttachment`, `ticketAttachments.remove` | Developer decision: use the existing sync queue, no second queue. These service methods already exist and are what the sweep calls (`use-ticket-outbox.ts:50-61`). | no | | |
| D9 | Where a queued delete is stored on the phone | In the draft's sync ledger under a reserved non-step key (one for deletes, one for Attach File), not under the step that owned the photo. They drain after the flow steps, in queue order within the key | `orderedUnsynced` already ranks any ledger key that is not a flow step last (`drain.ts:88-104`; `drain.ts:100-101`). Rejected: appending to the owning step's ops (the removal call does not know the step key, and a synced step has dropped its ops); a separate AsyncStorage queue with its own drain and lock (a second mechanism, against the decision). **Confirmed by the developer (Q13, 2026-10-29): the Attach File queue is a reserved key in the ticket draft's sync ledger, sent by the existing sync; not a separate durable queue.** **Executor risk, kept:** the Attach File sheet receives only a ticket id and sits outside the flow store, so a draft may not be reachable from it; confirm it, and if it cannot be reached or created, stop and raise a new §12 question rather than invent a second queue. **Risk to check in U3:** a delete draining after a step that references the same image; the server refuses with 409 when a saved signature still points at it (Q2). Also `ticketNeedsSync`, `findStepDiscrepancies`, `markStepSyncedIfUnchanged` must tolerate a non-step key. | no | Haris (confirmed for the Attach File queue, Q13, session 2026-10-29); the delete key was part of his 2026-10-29 decision to use the existing sync queue | 2026-10-29 |
| D10 | A delete the server no longer knows | A queued delete answered "gone" counts as done: the checklist and signature routes already return success for a missing id (`removeItemPhoto` returns when the row is absent, `checklist-assignments.service.ts:509-510`; `removeUnreferenced`, `ticket-attachment-guard.service.ts:337-338`) | A replay after a lost response must not wedge the queue (`step-ops.ts` header: ops are upserts, replay is safe). | no | | |
| D11 | Attach File delete made idempotent | `TicketAttachmentsService.remove` returns `204` when the id does not exist, and keeps `403` for a row that exists but belongs to another ticket (the same split as `removeItemPhoto`) | Today a missing id answers `403` ("deliberately Forbidden", `ticket-attachments.service.ts:223-225`), so a replayed queued delete would fail forever and block the later ops in its key. This changes one existing error case on an existing route, response shape unchanged. Confirmed by the developer 2026-10-29. | no | Haris (confirmed, session 2026-10-29) | 2026-10-29 |
| D12 | Pattern placement | No `patterns.md` entry fits; this follows the payroll queue as the nearest instance. A queue-with-poller entry could be proposed to Haris; not edited here (`.ai/**` is Haris-only) | `patterns.md` rule 3: "No entry fits, but the thing will clearly repeat." The sweep of other swallowed S3 deletes (§11c) would be the second instance. | no | | |
| D13 | Model and table name (Q1, left to the AI) — **superseded 2026-10-30 (D20)** | Model `StorageDeletionJob`, table `storage_deletion_queue`, enum `StorageDeletionJobStatus`, indexes `idx_storage_deletion_queue_poll` and `idx_storage_deletion_queue_tenant`; code in `service/storage-deletion/` and `usecase/storage-deletion/` | The developer answered "What is best?" and left it to the AI (session 2026-10-29). Mirrors the nearest instance: `PayrollCalculationJob` / `payroll_calculation_queue` / `PayrollCalcJobStatus` / `idx_calc_queue_poll` (`schema.prisma:6100-6122`); "storage" instead of "attachment" because the keys could belong to any stored object, not only an attachment. Alternatives passed over: `ObjectDeletionOutbox`, `AttachmentObjectDeletion`. Cheap to change before the migration is committed. | no | | 2026-10-29 |
| D14 | Distinguishing the two 409 causes (Q2 "split by cause") | The signature-referenced refusal in `removeIfUnreferenced` throws `new ConflictException({ message, code })` with the message text unchanged and a new code constant (`TICKET_ATTACHMENT_ERROR_CODES.ATTACHMENT_IN_USE`, in `@tcg/shared` beside `TICKET_WINDOW_ERROR_CODES`; the name is confirmed by the developer 2026-10-29); the window-closed 409 keeps `TICKET_WINDOW_CLOSED`. Mobile branches on `body.code` in the delete path of `sendOp`, falling back to today's behaviour for a 409 with no code | The developer decided the split and that the API returns a distinguishable code; the window-closed 409 already carries one (`job-tickets.service.ts:1873-1876`) while the other has none (`attachments.repository.ts:77-80`). Same body shape as the window guard, so mobile reads both the same way. The constant's name and home were the AI's choice and are now confirmed by the developer (2026-10-29). Alternative: a string literal in the service like `DAY_START_LOCKED` (`ticket-holdover.service.ts:139`); rejected because mobile reads it too. | no (G5: error body only, see §4; `tcg-contract-tracer` on U2) | | 2026-10-29 |
| D15 | How "cancel both" (REQ-07) works | When the removed photo's id is a `local:` id whose upload is still queued, delete its ledger upload reference and its local file (`discardLocalAttachment`, `local-attachments.ts:91`) and queue no delete op; the post-step sweep keeps handling the sub-case where a completed step's stored write still names the photo (REQ-07 notes, ASSUMED) | Smallest change on the existing local-attachment registry, which already discards a never-uploaded photo (`use-photo-removal.ts:52-55`). | no | | 2026-10-29 |
| D16 | Retention of queued items (Q4 (a)) | No retention limit: a queued item waits on the device as long as it takes and is never dropped, flagged or wiped because of its age | Developer answer 2026-10-29, status `reference`: "No Retention time." No code found drops an op or a draft by age (§REQ-09 notes). The server's own window and 72h grace still apply and answer 409 (REQ-08). | no | Haris (decided, session 2026-10-29) | 2026-10-29 |
| D17 | Retry limit (Q4 (b)) | 1 send + 3 retries: an item is sent at most 4 times | Developer answers 2026-10-29: "3 re tries" and, to the AI's reading, "1 send + 3 retries (4 total)". Confirmed: the first failed send is not a retry. Nearest numbers in the code are the payroll queue's 3 attempts (`schema.prisma:6108`) and the outbox `maxAttempts` (D3, 8); the developer's number is for the phone's queue, not the server's worker. | no | Haris (decided, session 2026-10-29) | 2026-10-29 |
| D18 | Failed-sync state (Q4 (c), Q9, Q10) | After the 3rd failed retry the active ticket card and the ticket's completed row in Jobs show a badge reading "Sync failed — tap to retry"; not inside the open ticket's own screens | Developer answers 2026-10-29: Q4 ("a badge or indicator in mobile ticket card"), Q9 ("Card + completed rows in Jobs"), Q10 (the text). The look is not given; the nearest pattern is the shared `Badge` (REQ-12 notes, ASSUMED). | no | Haris (decided, session 2026-10-29) | 2026-10-29 |
| D19 | How the retries are counted and what the tap does (the developer's answers, then AI assumptions, each reviewable) | **Confirmed by the developer:** (2) the first failed send is not a retry, so an item is sent at most 4 times; (12) only a send the server answered with an error counts, so a timeout, no connection or a network error does not (a 409 does not either, item 6); the badge tap resets the item's count and starts a drain (replacing the earlier assumption that there is no control on the badge and that a manual drain resets the count); the tap first probes the API with `isApiReachable()` and, if it answers, resets the count and starts the drain even when the NetInfo flag says offline, and if it does not, shows the existing offline message and does nothing else. **Stated consequence of item 12:** an item that never reaches the server is retried on every scan with no counter and never shows the badge. **Still assumed:** (1) one retry = one attempt by the open-ticket drain, the background scan or the badge tap; the pacing is the existing reconnect, app-open and manual triggers, with no timer; (3) the count is a new optional field on the persisted `StepSyncEntry`, read as 0, and `withStepSync` carries it across state changes; (4) granularity is one ledger entry (a step's op list, or the reserved key's list for deletes or Attach File items, D9), not one count per op inside a list; (5) after the 3rd failed retry automatic retries stop for that entry and the ops and local files are kept; new work written to the step also resets the count; (6) scope is every queued op type; a 409 (REQ-08) is not a retry, and `needsEditRequest` and the signature-referenced drop stay as they are; (7) a failed entry still blocks later entries and the submit, as a failed step does today (`drain.ts:162-171`); (8) the badge ends when the entry becomes `synced`; (9) "server-refused" is any HTTP error status other than 409, including 401, 403 and 5xx; (10) the tap resets all of the ticket's exhausted items; (11) the badge uses the shared `Badge` as the existing badge does, and the "Offline" badge can show beside it. | Nearest existing behaviour for each: `markStepFailed` / `markRejectedStep` already record the failure on the entry; `rev` is the precedent for an optional counter read as 0 (`ticket-flow.store.ts:80-87`); `getHttpStatus` already tells "the server answered" from "no answer" (`lib/api-error-formatter.ts:135-149`); `isApiReachable()` exists on `staging` (`lib/api-reachable.ts`); the queue is driven by connectivity events, `background-sync.ts:596-621`. Rejected: a timer-based retry (not asked for); a count per op (more state, not asked for). The probe exists because the NetInfo flag read "offline" while the API was reachable on the developer's iPhone. | no | Haris (items 2, 12, the tap and the probe confirmed, session 2026-10-29); assumed items wait for review | 2026-10-29 |
| D20 | S3 cleanup mechanism, revised (reverses D1 to D6 and D13) | **No outbox, no new table.** The row delete and the S3 deletes of its objects run in one `$transaction`; the S3 deletes run before it commits (`S3StorageService.deleteObjects`: every key tried on its own, then a 503 if any failed). A failure rolls the row delete back, so the row is never gone while its objects remain, and the caller gets the error. `AttachmentsRepository.deleteWithObjects` and `removeIfUnreferenced` take the S3 delete as a callback (so the repository, provided in seven modules, gets no S3 dependency); the transaction timeout is 20 s, not Prisma's 5 s. `cleanupReplaced` (after a committed resubmission) logs a warning and leaves the stale row on a 503, rather than failing the resubmission. `discardObjects` (no row exists) is unchanged: a best-effort delete. | Developer decision, session 2026-10-30: "I do not think we need this extra table to track the S3 object keys … we just delete the object from S3 and our DB in a transaction with catch and return pattern" (the sample code did not arrive; this is the AI's reading of that pattern). **Trade-off accepted:** S3 and Postgres cannot share one transaction, so a commit that fails after S3 deleted leaves a row pointing at a missing file until a retried delete finishes it; and a delete that keeps failing is surfaced, not retried by the server. Existing orphans are still out of scope (G2). What it saves: a table, a migration, a worker, a tenant-scoped model (G3), a claim/reclaim/backoff loop. | yes — the reading of "catch and return" is the AI's | developer, in session 2026-10-30 (decision); PR review pending | 2026-10-30 |
| D21 | How the double tick is decided | The tick reads the sync ledger: a `local:` reference counts as on the server once `sync.attachments[localId].serverId` is set (`isAttachmentOnServer`); the three tick sites subscribe to `sync.attachments`. Rejected: rewriting the saved capture to the server id after the upload (the open screen's React state would not update, and the store holds the capture the next send resolves). | no, review in the PR | pending | 2026-10-30 |
| D22 | What "completed" means on the phone, and the failed submit (Q11, in part) | A recorded local submission (`submitState` submitted or pendingSync, or an `OFFLINE-` ref) always counts. A step counter past the last step counts only while the server status is unknown or `COMPLETE`. A ticket past the last step that is not completed shows its last step. `submitState: 'error'` raises the Sync failed badge (the tap already drains and finalizes). Not built: a 4-send counter for a submit. The rule is the AI's reading of the developer's direction. | yes — the reading is the AI's | pending | 2026-10-30 |
| D23 | Where the category is decided | The phone sends `checklistType` (from the step key: pretrip, jsa, posttrip); the API maps it with the existing `CHECKLIST_CATEGORIES` and passes `category` to `storeUpload`. Optional, so older builds still get the submit-time label. Rejected: the API inferring the checklist from the ticket's current step (the request carries no step). Signatures excluded (not requested). | no, review in the PR | pending | 2026-10-30 |
| D24 | Replacing a signature deletes the image it replaced (built, then not on the branch) | Re-point the step's signature row at the new image, then delete the previous one through `cleanupReplaced` (row and S3 files). Never delete first: the row's foreign key is `Restrict`, and a failed save would leave no signature. Applies to Pre-Trip, Post-Trip and JSA, which called neither before (`recordSignature` and the lunch-break path already did). Commit `c165917b1` is no longer reachable from the branch (`reset: moving to HEAD^1`, 16:09:45); whether that was deliberate is open. | yes — re-apply or drop | pending | 2026-10-30 |

**Q10 of `MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12, quoted:** "*Ticket-image delete is DB-first and swallows a failed S3 delete (PR #947 review A-2). Does an S3 lifecycle or sweep rule cover the prefix `tenants/*/job-tickets/*`, or should a failed key be logged for a manual sweep?* Options: A. A lifecycle rule exists and covers it; B. Log the failed key; a sweep is a separate ticket; X. Other." **This ticket answers it with D20 (revised 2026-10-30; D1, the outbox, was the first answer): neither A nor B.** The S3 delete runs inside the row delete's transaction, so a failed S3 delete rolls the delete back and surfaces as a 503, and a retry finishes it; no lifecycle rule is relied on and nothing is persisted for a worker. Best effort with rollback, not a server-side guarantee. The sweep of objects already orphaned stays a separate ticket (§13). That spec was not edited; `tcg-scrum` records the resolution there.

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Reviewed by | Enumerated by |
| --- | --- | --- | --- | --- |
| `ticket-attachments.service.ts` `remove` (Attach File delete) | none | yes — unit U2 (D7) | | `grep -rn "deleteObject(" apps/api/src --include=*.ts` |
| `attachment-photos.service.ts:446` `deleteStoredFiles` (asset, tool, employee, user photos; callers `assets.service.ts:1027`, `tools.service.ts:618`) | P3 | no — follow-up ticket: same swallow, entity photos, a different feature | | same |
| `AttachmentsService.delete` / `DELETE /attachments/:id` (generic admin route; swallowed at `attachments.controller.ts:260` before U2) | none | yes — unit U2 (developer decision 2026-10-29; built in `7d826e40e`) | | same |
| `quotation-signatures/signed-copy-attachments.service.ts:223` | none | no — follow-up | | same |
| Mobile: other fire-and-forget server calls the crew triggers offline | none | no — the developer's Q4 answer names retention, retries and the badge only; he gave no other queue change. Other swallowed calls (`grep -rn "\.catch(() => {" apps/mobile/features/field-ticket`) are untouched here | | `grep -rn "\.catch(() => {" apps/mobile/features/field-ticket --include=*.ts` |
| Mobile lunch-break (WTL) attachment delete `ticketLunchBreaks.deleteAttachment` | none | no — no mobile caller exists; wire it when a caller exists | | `grep -rn "ticketLunchBreaks.deleteAttachment" apps/mobile` |
| Foreground first-send failure of a step (`ticket-step-screen.tsx:1092` `markStepFailed`) | none | applied as the first attempt of the count (D19) | | `grep -n "markStepFailed" apps/mobile/features/field-ticket/flow/ticket-step-screen.tsx` |
| `PayrollCalculationJob` queue | none | no — unchanged by decision | | `grep -rn "PayrollCalculationJob" apps/api/src` |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Eight questions, one batch. None reopens a decision the developer made on 2026-10-29. The worker numbers were not escalated (D3).

**Folded 2026-10-29.** Eleven are answered: Q1 by AI decision D13 (the developer left it to the AI); Q2, Q3, Q5, Q6, Q7 by the developer in session; Q4 (retention, retries, badge); Q9, Q10 and Q12 in the fourth pass; and Q13 (the Attach File queue is a reserved ledger key, D9) in the fifth. Two remain open (owner Haris): **Q8** (derived acceptance criteria) and **Q11** (does the rule cover a failed ticket submit; he did not answer it). An answered question's `Status` reads `answered`, not `resolved`: only `tcg-scrum` flips a Status to `resolved`, in the same pass as the decision note. The open-question sweep (`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/[A-Z]*/spec.md`) finds only Q8 and Q11 here.

**Unit blockers after the answers:**

| Unit | Scope | Blocked by |
| --- | --- | --- |
| U1 | ~~`StorageDeletionJob` model + migration + worker~~ **dropped 2026-10-30 (D20)** | — |
| U2 | in-transaction S3 delete at the six delete sites (was: enqueue; D20) (the four in the guard, the Attach File route, the generic `DELETE /attachments/:id`); D11; `code` on the signature-referenced 409; `tcg-contract-tracer` | nothing (D7, D11 confirmed; the generic route folded in; `ATTACHMENT_IN_USE` confirmed; Q2 answered); sign-off waits on Q8 |
| U3 | mobile `deleteAttachment` op, split-by-cause handling, cancel-both | nothing (Q2, Q3 answered); sign-off waits on Q8 |
| U4 | Attach File offline queue, 50 MB cap, "Pending sync" | nothing (Q13 answered: the reserved ledger key, D9; Q5, Q6 answered); the executor must confirm a draft is reachable from the sheet and, if not, stop and raise a §12 question; sign-off waits on Q8 |
| New scope from Q4 (a new unit is needed; `tcg-decomposer` slices it): retry counter, "server answered" test, stop rule, failed-sync state (REQ-09); the badge on the card and the Jobs row, the tap with the API probe, and a `syncOnline`-free drain for one ticket (REQ-12) | mobile only; same files as U3 and U4 (`drain.ts`, `background-sync.ts`, `ticket-flow.store.ts`) plus `ticket-card.tsx`, `jobs.tsx`, `use-ticket-progress.ts`; stacks on them | nothing for REQ-09 and REQ-12 (text, screens, retry count and counting rule are all answered); a failed submit is **Q11**, workaround "queued ops only"; sign-off waits on Q8 |

### Q1 — Name of the outbox model and table (superseded 2026-10-30: no outbox, D20)

- **Question:** What should the new outbox model and its table be called?
- **Options:**
  - A. `StorageDeletionJob`, table `storage_deletion_jobs`
  - B. `ObjectDeletionOutbox`, table `object_deletion_outbox`
  - C. `AttachmentObjectDeletion`, table `attachment_object_deletions`
  - X. Other — say what
- **Answer:** Left to the AI: the developer asked "What is best?" (Haris, session 2026-10-29). Decided as `StorageDeletionJob`, table `storage_deletion_queue` (§11b D13), matching `PayrollCalculationJob` / `payroll_calculation_queue` and storage-generic. A reviewable AI decision, not a product ruling.
- **Why it cannot be answered from what is written:** `intent.md` §7 marks the name `OPEN`. The code uses `PayrollCalculationJob` / `payroll_calculation_queue` for the payroll queue, a model name that does not match its table name; no convention covers a generic queue. The options are candidates, not a ranking.
- **Blocked:** nothing now (was REQ-03).
- **Candidates:** none: nothing written. Consulted `schema.prisma:6100-6122`.
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** answered — by AI decision D13 (§11b); the developer reviews it in the PR. `tcg-scrum` flips to resolved with the decision note.

### Q2 — A queued delete the server refuses with 409

- **Question:** When a queued delete is refused with 409 (the completion window has closed, or the image is part of a saved signature), should the phone keep the delete queued, or drop it?
- **Options:**
  - A. Keep it queued and retry at each drain, as a step does today, until payroll's approval re-opens the window (a signature-referenced image would keep failing)
  - B. Drop it and leave the file on the server, with no message to the crew
  - C. Drop it and tell the crew the file could not be removed
  - X. Other — say what (for example, a different answer for each of the two 409s)
- **Answer:** "Split by cause" (Haris, session 2026-10-29). The API returns a distinguishable code for the two 409 causes. Signature-referenced refusal: the phone drops the op, restores the photo in the UI and tells the crew. Window closed: the op stays queued and the existing "Request approval" path is shown. Recorded as REQ-08, REQ-05, D14.
- **Why it cannot be answered from what is written:** the late-ticket decision (L3, L13, L17) and TICKET-FLOW-SLOTS-HOLDOVER REQ-28 define the 409 for step writes (a call to action, not a retry); none mentions deletes. The mobile drain reads every 409 as "window closed" (`drain.ts:169`), but the delete path also returns 409 for a signature-referenced image (`attachments.repository.ts:77-80`). Which is right for a delete the crew already saw disappear is a product call.
- **Blocked:** nothing now (was REQ-08).
- **Candidates:** `decisions/2026-10-15-late-and-incomplete-tickets.md` (8.9 KB, 2026-10-16); `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` REQ-28; `field-ops/gaps.md#late-and-incomplete-tickets--where-the-24-hour-window-starts-what-it-allows-and-how-reminders-are-anchored` (resolved by that decision).
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md (developer answer, session 2026-10-29, status `reference`; recorded in REQ-08, REQ-05, §11b D14).

### Q3 — Deleting a photo whose upload is still queued

- **Question:** If the crew removes a photo offline whose upload op is still queued (it never reached the server), should the removal cancel both the queued upload and the delete, so nothing is sent?
- **Options:**
  - A. Yes — drop the queued upload and queue no delete; the photo never reaches the server
  - B. No — send the upload first, then the delete, so the server records both
  - X. Other — say what
- **Answer:** "Cancel both" (Haris, session 2026-10-29): drop the queued upload and the delete; nothing reaches S3. Option A. Recorded as REQ-07, D15.
- **Why it cannot be answered from what is written:** no source describes removal of a not-yet-uploaded photo. The code today discards a never-uploaded local photo (`use-photo-removal.ts:48-55`) but leaves one still named by a completed step's stored writes (`:51`). Which of these an offline removal should follow is not written anywhere.
- **Blocked:** nothing now (was REQ-07).
- **Candidates:** none: nothing written. Consulted `intent.md`; `field-ops/gaps.md#offline-capture--committed-on-a-recorded-call-with-no-ticket-and-no-written-scope`; `.ai/aidlc/SCRUM-OFFLINE-SYNC/design/review-fix-plan.md` (29.5 KB, headings and the delete lines only).
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md (developer answer, session 2026-10-29, status `reference`; recorded in REQ-07, §11b D15).

### Q4 — What "more reliable" means for the rest of the offline queue

- **Question:** Beyond deletes and the Attach File sheet, does this ticket change anything else in the offline queue (for example retention, retry limits, a visible failure state)?
- **Options:**
  - A. No — the queue already holds every ticket's offline changes per draft and drains them all on reconnect; only deletes and Attach File are added here
  - B. Yes — name each change (a list)
  - X. Other — say what
- **Answer:** B. Yes, with a list (Haris, session 2026-10-29), given verbatim: "No Retention time. 3 re tries. after 3rd failed retry, we need to show a badge or indicator in mobile ticket card for failed sync". That is: no retention limit (D16), 3 retries (D17), a failed-sync badge or indicator on the mobile ticket card after the 3rd failed retry (D18). Recorded as REQ-09 and REQ-12. Details the answer did not give: Q9 to Q12.
- **Why it cannot be answered from what is written:** `intent.md` §4 leaves it `OPEN`. The code answers the factual question ("are we maintaining the queue for all tickets"): `runScan` visits every `ticket:` draft (`background-sync.ts:548-567`). It cannot say what the developer wants beyond that.
- **Blocked:** nothing now (was REQ-09). The details it left open were Q9 to Q12; Q9, Q10 and Q12 are now answered, and Q11 alone blocks REQ-13.
- **Candidates:** `.ai/aidlc/SCRUM-OFFLINE-SYNC/design/offline-implementation-review.md` (19.0 KB), `.ai/aidlc/SCRUM-OFFLINE-SYNC/design/review-fix-plan.md` (29.5 KB): design files for the same queue, never elaborated; they list findings and a remediation status but are not a source of intent.
- **Owner:** Haris
- **Workaround, if any:** option A for this ticket.
- **Status:** resolved — see decisions/2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md (developer answer, session 2026-10-29, status `reference`; recorded in REQ-09, REQ-12, §11b D16 to D19).

### Q5 — Limits on files queued from the Attach File sheet

- **Question:** Is there a limit on how many files, or how many bytes in total, the Attach File sheet may queue on the phone while offline?
- **Options:**
  - free answer — a count and/or a total size, or "none beyond the 50 MB per file that applies online today"
- **Answer:** The 50 MB per-file cap only; no count cap and no total cap (Haris, session 2026-10-29). Recorded as REQ-10.
- **Why it cannot be answered from what is written:** only the per-file online cap exists (`TICKET_ATTACHMENT_MAX_BYTES` = 50 MB). Queued files live in device storage; no source says how many are acceptable.
- **Blocked:** nothing now (was REQ-10).
- **Candidates:** none: nothing written. Consulted `packages/shared/src/constants/attachments.ts`, `apps/mobile/components/field/ticket-attachment-file.ts`.
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md (developer answer, session 2026-10-29, status `reference`; recorded in REQ-10, §9).

### Q6 — What the crew sees for a queued Attach File row

- **Question:** Scope first: while offline, should the crew see any sign that an added file has not reached the server yet?
- **Options:**
  - A. Yes — queued rows carry a visible marker (say what it says)
  - B. No — a queued row looks like any other row
  - X. Other — say what
- **Answer:** A. Yes: a small "Pending sync" marker on a queued Attach File row; the copy is "Pending sync" (Haris, session 2026-10-29). Recorded as REQ-10.
- **Why it cannot be answered from what is written:** `intent.md` §9 says only that the sheet "keeps its layout". No source says whether a pending state is shown. This is what a customer-facing user sees, so no copy is written here.
- **Blocked:** nothing now (was REQ-10).
- **Candidates:** none: nothing written.
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md (developer answer, session 2026-10-29, status `reference`; recorded in REQ-10).

### Q7 — Who looks at outbox rows that end FAILED (superseded 2026-10-30: no outbox, D20)

- **Question:** When an S3 delete job exhausts its attempts and ends FAILED, who is told or who acts?
- **Options:**
  - A. No one yet — the row is kept and logged at error level; a sweep or an admin list is a later ticket
  - B. A list for administrators is part of this ticket (say who sees it)
  - C. A notification is sent (say to whom)
  - X. Other — say what
- **Answer:** A. Keep the FAILED row and log at error level; no list, no notification (Haris, session 2026-10-29). Recorded as REQ-11.
- **Why it cannot be answered from what is written:** the intent is silent. The payroll queue has a failed-calculations list for Payroll, but that is a payroll feature with its own owner, not a precedent.
- **Blocked:** nothing now (was REQ-11).
- **Candidates:** none: nothing written.
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md (developer answer, session 2026-10-29, status `reference`; recorded in REQ-11).

### Q8 — Confirm the derived acceptance criteria

- **Question:** The ticket has no acceptance criteria. Are the criteria derived in the Acceptance lines of REQ-01 to REQ-06 right?
- **Options:**
  - A. Yes, as written
  - B. No — say what changed
  - X. Other — say what
- **Answer:** None yet. Not confirmed by the developer.
- **Why it cannot be answered from what is written:** `intent.md` §3 lists none; they were derived from the stated goal.
- **Blocked:** sign-off for REQ-01 to REQ-06 (none is a build blocker).
- **Candidates:** none: nothing written.
- **Owner:** Haris
- **Workaround, if any:** build to the derived lines and mark them unconfirmed.
- **Status:** open — waiting for the developer to confirm the derived criteria.

### Q9 — Where the failed-sync indicator is shown (raised by the Q4 answer)

- **Question:** Scope first: besides the active ticket card, should the failed-sync indicator also appear on the completed-ticket rows in Jobs, or inside the open ticket's own screens?
- **Options:**
  - A. The ticket card only, as the developer said
  - B. The ticket card and the completed-ticket rows in Jobs (where the "Offline" badge is also shown today)
  - C. The ticket card and the open ticket's own screens
  - X. Other — say what
- **Answer:** "Card + completed rows in Jobs" (Haris, session 2026-10-29): the failed-sync indicator appears on the active ticket card (`ticket-card.tsx`, where the warn-tone "Offline" badge shows today) and on the completed-ticket rows in Jobs (`jobs.tsx:260`); not inside the open ticket's own screens. Recorded as REQ-12, D18.
- **Why it cannot be answered from what is written:** the answer says "mobile ticket card" and nothing else. The existing "Offline" badge appears in two places (`ticket-card.tsx:168-172`, `jobs.tsx:260`), and a completed ticket can still hold an unsent item, so the ticket card alone may not be the only place a crew looks.
- **Blocked:** nothing now.
- **Candidates:** none: nothing written. Consulted `field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-026-incomplete-ticket-handling.md` (FR-TCG-FOP-001 FR-FOP-026; about incomplete tickets, not failed syncs).
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md (developer answer, session 2026-10-29, status `reference`; recorded in REQ-12, §11a, D18).

### Q10 — What the failed-sync indicator says and how it looks (raised by the Q4 answer)

- **Question:** What text does the failed-sync indicator show, and is it the same warn-tone badge as "Offline" or a different look?
- **Options:**
  - A. The same warn-tone badge style as "Offline", with text to be given
  - B. An error-tone badge, with text to be given
  - X. Other — say what (give the exact text; say whether tapping it does anything)
- **Answer:** The text is "Sync failed — tap to retry" (Haris, session 2026-10-29). This adds a retry tap: tapping resets the item's retry count and starts a drain. The developer also agreed ("sure") that the tap first probes the API with `isApiReachable()` and does not trust the NetInfo flag alone. Look: not given; the shared `Badge` is ASSUMED (REQ-12 notes). Recorded as REQ-12, D18, D19.
- **Why it cannot be answered from what is written:** the developer asked for "a badge or indicator" with no text or design; `intent.md` §9 has no design handoff. No copy is written here. Today a failed item already shows the "Offline" badge, so the new one must be told apart from it.
- **Blocked:** nothing now.
- **Candidates:** none: nothing written. The nearest pattern is the existing `Badge` (`tone="warn"`, `icon="wifiOff"`) at `components/field/ticket-card.tsx:168`.
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md (developer answer, session 2026-10-29, status `reference`; recorded in REQ-12, D18, D19).

### Q11 — Does the failed-sync rule cover a failed ticket submit? (raised by the Q4 answer)

- **Question:** Does the 3-retry rule and the failed-sync indicator also apply to a ticket submit that fails, or only to queued items?
- **Options:**
  - A. Queued items only; a failed submit keeps today's behaviour
  - B. Both: a failed submit is counted and flagged the same way
  - X. Other — say what
- **Answer:** None yet. The developer did not answer this question (session 2026-10-29).
- **Why it cannot be answered from what is written:** the answer speaks of "failed sync" without naming the submit. In the code a submit that fails is a separate state (`submitState: 'error'`, `submissionPending`, `background-sync.ts:354-362`), outside the step ledger, and the card's "Offline" badge does not read it.
- **Blocked:** REQ-13 (the submit case only).
- **Candidates:** none: nothing written.
- **Owner:** Haris
- **Workaround, if any:** no: this ticket covers queued ops only, not a failed submit (option A), labelled as a workaround.
- **Status:** answered in part 2026-10-30 — the developer directed a real fix and a consistent ticket state ("real fix here"; "the ticket state should be consistent"). Built as D22 (REQ-13, U7): a submit the server never accepted raises the existing badge; a ticket the server has not completed is never shown completed. **Still unspecified:** whether a failed submit is counted against the 4-send limit (option B's counting is not built; the badge reads `submitState: 'error'`).

### Q12 — Does a send that fails for lack of connection count as a retry? (raised by the Q4 answer)

- **Question:** If a resend fails because the phone had no usable connection (a timeout or network error, with no answer from the server), does it count as one of the 3 retries?
- **Options:**
  - A. Yes: every failed send counts, except a 409
  - B. No: only a send the server answered with an error counts
  - X. Other — say what
- **Answer:** B. "Only count server-refused sends" (Haris, session 2026-10-29). A timeout, no connection or a network error does not count as a retry; a 409 does not either (REQ-08). Consequence, stated and accepted: an item that never reaches the server is retried on every scan with no counter and never shows the badge. Recorded as REQ-09, D19.
- **Why it cannot be answered from what is written:** the answer gives the number but not what a failure is. In poor signal a connection error could use up 3 retries and show a failed-sync indicator for a ticket the server never rejected; the other reading never flags a ticket that cannot reach the server. Which the crew should see is not written. Today any non-409 failure marks the step failed (`drain.ts:162-171`).
- **Blocked:** nothing now.
- **Candidates:** none: nothing written.
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md (developer answer, session 2026-10-29, status `reference`; recorded in REQ-09, D19).

### Q13 — Where the Attach File offline queue is stored (raised from `units.md` F2)

- **Question:** Should the Attach File offline queue live as a reserved key in the ticket draft's sync ledger and be drained by the existing sync (the design recorded as D9), or in its own separate durable queue with its own drain?
- **Options:**
  - A. A reserved key in the draft's sync ledger, drained by the existing sync, no second queue (D9)
  - B. Its own separate durable queue, with its own storage and drain
  - X. Other — say what
- **Answer:** A. A reserved key in the ticket draft's sync ledger, sent by the existing sync: not a separate durable queue (Haris, session 2026-10-29). Confirms D9. Recorded in REQ-06, D9.
- **Why it cannot be answered from what is written:** the decomposer (`units.md` F2, read only) reports that its brief called the Attach File queue "its own durable queue", while D9 chose a reserved ledger key and rejected a separate AsyncStorage queue "with its own drain and lock". The intent says deletion needs "a separate persistent mobile queue" and the developer wants offline changes "in a queue in mobile async storage and local storage" (`intent.md` §3), and the 2026-10-29 decision as relayed puts the delete op in the existing sync queue; none of these names the Attach File queue's storage, and the words "its own durable queue" are in no source I can read. There is also a technical doubt: the sheet receives only a ticket id and sits outside the field-ticket flow store (`units.md` F2), so a draft may not exist when it is used. This spec does not decide between the two.
- **Blocked:** nothing now. Executor risk kept: the sheet receives only a ticket id and sits outside the flow store; if a draft cannot be reached or created from it, the executor stops and raises a new question (REQ-06).
- **Candidates:** `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/units.md` F2 (54.6 KB, read only); `intent.md` §3 (9.2 KB); spec §11b D8 and D9.
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md (developer answer, session 2026-10-29, status `reference`; recorded in REQ-06, §11b D9).

### Q14 — What the failed-sync badge tap says when the API does not answer (raised by the U5 executor, from `units.md` F9)

- **Question:** When the badge tap's probe finds the API unreachable, the tap shows "the existing offline message". The only generic one is the Field tab's header refresh text, "Offline — will sync when reconnected" (`app/(field)/field.tsx`); the others name an action ("Offline — reconnect to save this step"). The generic text says it will sync on reconnect, but an exhausted entry is no longer retried by itself, so it does not. Keep that text?
- **Options:**
  - A. Keep "Offline — will sync when reconnected"
  - B. Use another existing text — say which
  - X. New copy — say what
- **Answer:** Two cases (Haris, session 2026-10-30): "if we try to click on this while connected to internet then we should say server not responding or something went wrong, try after a few minutes; in offline mode, clicking on it should say Offline - will sync when reconnected". So: probe fails while the phone's network flag says offline: "Offline — will sync when reconnected" (option A for that case); probe fails while the flag says online: "Server not responding. Please try again in a few minutes." (the sense is the developer's; the exact sentence is the executor's and can be reworded).
- **Why it cannot be answered from what is written:** REQ-12 and F9 say "the existing offline message" without naming it, and forbid new copy; no existing text fits both "the API is unreachable" and "tap again later".
- **Blocked:** nothing.
- **Candidates:** `apps/mobile/app/(field)/field.tsx` (handleRefresh); `apps/mobile/features/field-ticket/use-retry-failed-sync.ts` (`FAILED_SYNC_OFFLINE_MESSAGE`, the one place to change).
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md (developer answer, session 2026-10-30, status `reference`; the exact second sentence is the AI's; built in U5, `use-retry-failed-sync.ts`).

### Q15 — Is the first foreground send counted, and does the pre-submit drain resend an exhausted entry? (raised by the U5 executor)

- **Question:** (a) §11c says the foreground first-send failure (`ticket-step-screen.tsx` `ackStepProgress` → `markStepFailed`) "applies as the first attempt of the count"; the U5 brief counted only inside the drain's and the scan's generic failure paths. A step whose progress ack fails in the foreground is therefore sent 5 times, not 4, before it stops. Count it too? (b) The open ticket's pre-submit check (`useDrainTicket`) goes through the same drain, so it now skips an exhausted entry and reports it as a failed step; the badge is not shown inside the open ticket (Q9), so the crew must leave the ticket and tap the badge on the card or the Jobs row. Should the pre-submit check resend an exhausted entry instead?
- **Options:**
  - A. (a) count the foreground ack failure; (b) keep skipping
  - B. (a) leave uncounted; (b) pre-submit check resends an exhausted entry (without resetting its count)
  - C. A for (a), B for (b); or the reverse
  - X. Other — say what
- **Answer:** "Implement which is best; but if the retries are blocked and the ticket is not getting submitted then instead of a generic message we need to show a specific message indicating the actual issue" (Haris, session 2026-10-30). (a) the foreground ack failure is counted as the entry's first send when the server answered with an error other than 409 (changed after the U5 analyst's finding F2, so spec §11c holds and this is no longer a workaround). (b) AI decision, option B with a specific message: the pre-submit check resends each exhausted entry once per attempt (a user pressing Complete is a real attempt), a failed resend leaves it exhausted with the count capped at 4, and the blocked-submit alert names the step and shows the entry's stored server message instead of the generic line.
- **Why it cannot be answered from what is written:** REQ-09 says the first foreground send "is the first send, not a retry" and that automatic retries stop; it does not say whether the user-initiated pre-submit check is automatic.
- **Blocked:** nothing.
- **Candidates:** `apps/mobile/features/field-ticket/flow/ticket-step-screen.tsx` (`ackStepProgress`); `apps/mobile/features/field-ticket/sync/drain.ts` (`onePass`).
- **Owner:** Haris
- **Workaround, if any:** none needed.
- **Status:** (b) resolved — see decisions/2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md (developer answer, session 2026-10-30, status `reference`; the one-resend rule is an AI decision the developer delegated; built in U5, `drain.ts` `retryExhausted`, `ticket-step-screen.tsx` `blockSubmit`). (a) unchanged: answered — left as built (the foreground ack failure is not counted); not resolved by that note.

### Q16 — Which server answers count as a "server-refused send" toward the 4-send limit (raised by the PR #982 review, U5)

- **Question:** Your Q12 answer was "Only count server-refused sends". Does a 5xx (502, 503, 504 — gateway or deploy outage), 401/403 (auth) or 408/429 (timeout, rate limit) count as a refused send, or only a 4xx that rejects the request itself?
- **Options:**
  - A. Every HTTP error status except 409 counts, including 5xx, 401, 403, 408 and 429 (as built: `countsAsRefusedSend` in `apps/mobile/features/field-ticket/sync/retry-limit.ts`)
  - B. Only a 4xx counts, except 401, 408, 409 and 429; a 5xx is treated like no connection (retried on every scan, not counted)
  - C. A fixed list of statuses — say which
  - X. Other — say what
- **Answer:**
- **Why it cannot be answered from what is written:** the Q12 options set "no connection" against "the server answered with an error"; they did not separate an outage or auth answer from a refusal. "Any status except 409" is recorded as an AI assumption, not the developer's words (decision note, *Assumptions*; §13 above). In the same ticket, the Attach File "refused for good" list (400, 413, 415, 422) treats 5xx, 401, 403, 404, 408 and 429 as *not* refused. That is also an AI reading, so the two readings of "refused" disagree and neither is sourced. Under A, a 30-minute deploy outage can exhaust every queued entry and show the badge on tickets the server never rejected.
- **Blocked:** PR #982 (U5) review sign-off on `countsAsRefusedSend`.
- **Candidates:** decisions/2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md (11.0 KB, 2026-10-29, `reference`; *Assumptions* line "Server-refused means any HTTP error status other than 409"); decisions/2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md (`reference`; *Added later*, AI status list); admin/responsive-design-and-security-posture.md (unverified, 2026-03-09; a 401 is refreshed and replayed by the client). No vault file or FRD states which statuses count.
- **Owner:** Haris
- **Workaround, if any:** keep A as built, labelled an assumption in the PR's *AI decisions* table, pending this answer.
- **Status:** open

## 13. What this spec deliberately does not specify

- Sweeping S3 objects that earlier swallowed deletes already orphaned: out of scope by the developer's decision (guardrail G2, needs developer approval and a run on a copy of staging data); a separate ticket.
- An S3 lifecycle rule: ruled out by the developer's decision (D1).
- Any change to the payroll calculation queue: unchanged by decision.
- Offline capture and upload of step photos and signatures: already works; unchanged.
- The product behaviour of offline in general: written only in FR-TCG-FOP-001, under the unresolved three-way conflict; this spec takes no side.
- Anything about the offline queue beyond deletes, Attach File, retention, the 3-retry limit and the failed-sync indicator — the developer gave no other change (Q4).
- Whether a failed ticket submit is counted and flagged like a queued item — no source; see REQ-13, Q11 (open; the workaround covers queued ops only).
- The failed-sync badge's look (colour and icon) — the developer gave the text only; the shared `Badge` is ASSUMED (REQ-12).
- Whether a ticket draft is reachable from the Attach File sheet — not known; an executor check with a stop rule (REQ-06), not a decision.
- How a retry is counted (D19): the retry count and "server-refused only" are answered; the pacing, per-entry granularity, which HTTP errors count (any status except 409), and the tap resetting all of a ticket's exhausted items are assumed and reviewable, not sourced.
- An item that never reaches the server is not counted and never shows the badge: the developer's Q12 choice, not a gap.
- The wording of the message the crew sees when a signature-referenced delete is refused — `NOT SPECIFIED`; the server's existing message is reused (REQ-08, ASSUMED).
- A photo removed after a completed step's stored write already names it — the answer "cancel both" does not say how a stored step op is rewritten; the nearest existing behaviour is ASSUMED (REQ-07 notes).
- A total or count limit on files queued offline — the developer chose none (Q5); device storage is unbounded by this spec.
- Who handles a delete that keeps failing — nothing beyond the error log and the 503 the caller sees (D20); there is no job to list or sweep (was Q7 = A).
- How long a queued op may wait on the phone — `NOT SPECIFIED` (`intent.md` §11).
- Retention of COMPLETED outbox rows — n/a, there is no outbox (D20).
- Whether L17's 72h grace was meant to cover deletes and Attach File uploads — read as yes from "each queued op" (REQ-01, REQ-06); confirm at sign-off.
- The "REQ-28" in code comments: it is `TICKET-FLOW-SLOTS-HOLDOVER` REQ-28 (§0), not a requirement here.
- Worker numbers (D3): n/a, there is no worker (D20). The S3-delete transaction timeout (20 s) is an AI number, no source, reviewable.
- Tests: `not requested`.

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person (REQ-13, waiting on Q11; its workaround is queued ops only)
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` (REQ-01, REQ-06: this work takes no side; a note is needed only if product settles the offline requirement)
- [ ] `tcg-contract-tracer` run on U2 for the error-body change (D14)
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every requirement's **Edges** fields are filled (`ASSUMED` allowed) or point at a §12 question
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] A developer has reviewed §11b and §11c (_Reviewed by_), including the AI decisions D14, D15, D20 and the assumptions in D19, (items 2, 12, the tap and the probe are confirmed; the rest of D19 is assumed) (D7 and D11 are confirmed)
- [ ] Q8 answered (derived acceptance criteria confirmed) and Q11 answered (failed submit)
- [x] `tcg-prisma-guardian`: n/a — no schema change after D20 (U1 dropped)
- [ ] The developer decisions and answers of 2026-10-29 are written to `.ai/vault/decisions/` by `tcg-scrum`, which flips the answered §12 Status lines to resolved
- [ ] Decomposed into vertical units — `units.md` (U1 outbox model and worker, dropped 2026-10-30; U2 in-transaction S3 delete at the delete sites; U3 mobile delete op; U4 Attach File queue; U5 retry limit and failed-sync badge)

Answered by: ______________  Date: ______________
