---
title: "Ticket attachment S3 deletion is guaranteed by a transactional outbox: the keys are saved in the same DB transaction as the row delete and a polling worker retries until S3 succeeds; no lifecycle rule, a dedicated table, no new dependency, and existing orphans are not swept here — decision"
source: decision/Syed Haris (CodingCops) — the request that started the MOBILE-OFFLINE-DELETE-QUEUE elaboration and his answers in the same Claude Code session, 2026-10-29
decided: 2026-10-29
decided_by: >-
  Syed Haris (CodingCops), the developer and requester of MOBILE-OFFLINE-DELETE-QUEUE, in
  conversation with Claude Code on 2026-10-29. He gave the outbox, the dedicated table, no
  S3 lifecycle rule, no new dependency, no orphan sweep and one ticket with stacked units in
  the request that started the elaboration (spec §11b D1, "Haris (decided, relayed)"). In the
  same session he confirmed the fifth delete site (D7) and the 204 for a missing id on the
  Attach File delete (D11), and folded the generic DELETE /attachments/:id route into U2 as a
  sixth site (relayed by the coordinator, 2026-10-29). tcg-scrum did not see the session. It records from
  .ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md (§0, §11b, §12, §13) and intent.md. This is a
  developer decision. It binds this build. It is not a TCG client ruling, so the status is
  reference.
status: superseded
superseded_by: decisions/2026-10-30-ticket-attachment-s3-deletion-in-the-row-delete-transaction-no-outbox.md
resolves:
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#q10
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#d1
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#d7
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#d11
conflicts_with: []
related_tickets:
  - MOBILE-OFFLINE-DELETE-QUEUE
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md
  - 2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md
  - 2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md
  - 2026-10-28-ticket-attachment-feature-id-holds-ticket-uuid-old-rows-keep-code.md
tags: [module/field-ops, kind/decision, architecture, ticket-workflow]
---

# Ticket attachment S3 deletion is guaranteed by a transactional outbox

> **Superseded 2026-10-30** by `decisions/2026-10-30-ticket-attachment-s3-deletion-in-the-row-delete-transaction-no-outbox.md`. The developer reviewed the built outbox
> and decided against the extra table and worker: the S3 objects are deleted inside the row
> delete's transaction instead, and a failed S3 delete rolls the delete back. This note is kept
> as the record of the first answer. Everything below it was true on 2026-10-29 and is no longer
> the design. The decisions that stand from it: no S3 lifecycle rule, no new dependency, existing
> orphans not swept here, one ticket with stacked units, the six delete sites, and the 204 for a
> missing id on the Attach File delete (D11).

## Decision

Source: `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md` §11b D1, D7, D11; REQ-03, REQ-04,
REQ-05; §13. Haris, 2026-10-29.

- **A transactional outbox.** When the API deletes a ticket attachment row, it saves the
  row's S3 keys as a deletion job in the **same database transaction** as the row delete. If
  the transaction rolls back, no job exists (REQ-03).
- **A worker retries until S3 succeeds.** After commit the API tries the S3 delete once at
  once. If that fails, a polling worker (`@Interval`) retries the persisted job until the
  S3 delete succeeds (REQ-04, D5). An S3 failure never fails the HTTP request.
- **No S3 lifecycle rule.** No lifecycle rule is relied on (D1). The repo defines none for
  the bucket.
- **A dedicated table.** The outbox gets its own table. It does **not** reuse the payroll
  calculation queue, which is period-bound (a required `periodId` FK and a payroll trigger
  enum, D1).
- **No Redis, no SQS, no new dependency.** The worker mirrors `PayrollCalculationJob` and its
  poller, which are already in the stack (D1).
- **Existing orphans are not swept here.** Sweeping S3 objects that earlier swallowed
  deletes already orphaned is a data operation (guardrail G2). It needs developer approval
  and a run on a copy of staging data, and it is its own ticket (§13).
- **One ticket, stacked units.** The work is one ticket, built as stacked units, each PR
  targeting the previous unit's branch. The developer's decision as relayed named four
  units. The decomposer later added a fifth for the Q4 retry scope (`units.md`, U1 to U5);
  that slicing is the AI's, not the developer's words.

### The six delete sites

All six enqueue the keys instead of swallowing a failed S3 delete (REQ-05). Four are in
`apps/api/src/usecase/ticket-attachment-guard/ticket-attachment-guard.service.ts`:

1. `removeUnreferenced` — signature, identity and WTL-photo removal.
2. `deleteOrphaned` — checklist photo removal. It has no transaction today and gets one.
3. `cleanupReplaced` — resubmission. It calls `deleteOrphaned`, so it is covered by site 2.
4. `discardObjects` — a failed upload. No row was written, so the job is inserted alone (D4).

The fifth is `TicketAttachmentsService.remove` in
`apps/api/src/usecase/ticket-attachments/ticket-attachments.service.ts`, the Attach File
delete route (D7). The developer's list named four sites. A grep for `deleteObject(` found
this fifth one, and **Haris confirmed it** on 2026-10-29.

The sixth is the generic admin route `DELETE /attachments/:id` (`AttachmentsService.delete`
in `apps/api/src/usecase/attachments/attachments.service.ts`, called from
`apps/api/src/presentation/attachments/attachments.controller.ts`). Spec §11c listed it as a
follow-up. **Haris folded it into U2** on 2026-10-29, so it uses the outbox too.

Checked 2026-10-30 (developer answer "Fold into U2", relayed by the coordinator): this note
records the sixth site correctly, and Haris confirmed the shared code name
`TICKET_ATTACHMENT_ERROR_CODES.ATTACHMENT_IN_USE` for the signature-referenced 409 (D14; in
`packages/shared/src/utils/ticket-completion-window.ts` on the U2 branch).

### A missing id on the Attach File delete returns 204

`TicketAttachmentsService.remove` returns `204` when the attachment id does not exist. A
cross-tenant id also answers `204`, because the tenant extension hides the row; a row on
another ticket, or of another feature type, stays `403` (D11). Today a missing id
answers `403`, so a replayed queued delete would fail forever. **Haris confirmed this** on
2026-10-29. The success contract (204) does not change.

### Q10 of MOBILE-TICKET-PRESIGNED-IMAGES, quoted

From `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q10 (raised by the reflector,
2026-10-29):

> **Question:** Ticket-image delete is DB-first and swallows a failed S3 delete (PR #947
> review A-2). Does an S3 lifecycle or sweep rule cover the prefix `tenants/*/job-tickets/*`,
> or should a failed key be logged for a manual sweep?
>
> **Options:** A. A lifecycle rule exists and covers it (say where it is defined) · B. Log
> the failed key; a sweep is a separate ticket · X. Other - say what

**Answer: X, neither A nor B.** A failed key is persisted in the outbox and retried until the
delete succeeds. No lifecycle rule is relied on. The sweep of objects already orphaned stays
a separate ticket.

## Why

- **A database transaction cannot include S3** (`intent.md` §3). Saving the keys in the
  transaction is what makes the cleanup survive a crash or an S3 outage. A delete can no
  longer leave an object that nothing references.
- **Why a dedicated table.** The payroll queue's rows need a pay period and a payroll
  trigger. A storage deletion has neither.
- **Why no new dependency.** Neither BullMQ, SQS nor Redis is in the stack
  (`apps/api/package.json`). The payroll queue already shows the poll, claim and retry shape
  on Postgres alone.
- **Why no lifecycle rule.** The bucket's real configuration is not recorded in the repo.
  The code comments that say a failed object is "swept by S3 lifecycle" cite nothing (D1).
- **Why the fifth site.** Without it, "guaranteed S3 cleanup" would be false for exactly the
  files the Attach File sheet deletes (D7).
- **Why 204 for a missing id.** A queued delete replayed after a lost response must not wedge
  the queue. The checklist and signature routes already return success for a missing id (D10,
  D11).

## What this does not decide

These are the AI's choices or open items. They are not the developer's words:

- **The model and table name.** `StorageDeletionJob`, table `storage_deletion_queue`, is AI
  decision D13. The developer asked "What is best?" and left it to the AI (Q1). He reviews it
  in the PR.
- **The worker numbers.** Poll every 10 s, a batch of 25, `maxAttempts` 8, a 60 s doubling
  backoff, a 5-minute stale claim: all AI decision D3, with no source. The developer can
  change them in the PR.
- **The row shape, where the enqueue happens and the immediate attempt** (D2, D4, D5), and
  the tenant context in the worker (D6): AI decisions, reviewed in the PR.
- **What happens to a job that ends FAILED.** That is Q7, recorded in
  `decisions/2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md`.
- **Other swallowed S3 deletes.** Entity photos (`attachment-photos.service.ts`) and signed
  quotation copies (`signed-copy-attachments.service.ts`) also swallow a failed delete. They
  stay follow-ups (spec §11c), not part of this decision. The generic attachment delete is no
  longer one of them: it is the sixth site above.
- **No product behaviour.** No TCG person ruled on this. It is an engineering rule for this
  build.

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no
  frontmatter.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q10: the `Status:` line is changed
  from `open` to resolved, pointing at this note. **Done** (2026-10-29). No other text in that
  spec is changed.
- `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md`: D1, D7 and D11 are §11b rows, not §12
  questions, so no `Status:` line changes for them. Their rows already name Haris. This note
  does not edit them.
