---
title: "Ticket attachment S3 deletion runs inside the row delete's database transaction, before it commits: a failed S3 delete rolls the row delete back and surfaces as an error; no outbox table, no worker, no lifecycle rule — decision"
source: decision/Syed Haris (CodingCops) — his message in the Claude Code session of MOBILE-OFFLINE-DELETE-QUEUE, 2026-10-30
decided: 2026-10-30
decided_by: >-
  Syed Haris (CodingCops), the developer and requester of MOBILE-OFFLINE-DELETE-QUEUE, in
  conversation with Claude Code on 2026-10-30: "I do not think we need this extra table to
  track the S3 object keys, storage_deletion_queue. We just delete the object from S3 and our
  DB in a transaction with catch and return pattern something like this", then "yes" to the
  plan the AI stated back to him. The code sample he meant to attach did not arrive; the
  mechanism below is the AI's reading of "a transaction with catch and return" and the
  developer reviews it in the PR. This is a developer decision. It binds this build. It is not
  a TCG client ruling, so the status is reference.
status: reference
resolves:
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#q10
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#d20
conflicts_with: []
related_tickets:
  - MOBILE-OFFLINE-DELETE-QUEUE
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-29-ticket-attachment-s3-deletion-guaranteed-by-transactional-outbox.md
  - 2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md
  - 2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md
tags: [module/field-ops, kind/decision, architecture, ticket-workflow]
---

# Ticket attachment S3 deletion runs inside the row delete's transaction

## Decision

Source: `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md` §11b D20 (reverses D1 to D6 and D13);
REQ-05; the revision note at the top of that spec. Haris, 2026-10-30.

- **No outbox, no new table, no worker.** The `storage_deletion_queue` table, its model, its
  migration, the `@Interval` worker and the `TENANT_SCOPED_MODELS` entry are not built. Unit
  U1 is cut.
- **The S3 delete is inside the transaction.** The row delete and the S3 deletes of the
  objects it owned (the file and, for a ticket image, its preview) run in one database
  transaction; the S3 deletes run before it commits. If any S3 delete fails, the transaction
  rolls back, the row stays, and the caller gets an error (503, logged at error level). The row
  is therefore never gone while its objects remain.
- **A retry finishes it.** S3 answers success for a key that is already deleted, so a delete
  repeated after a failure (the phone's queue, the user, the next delete) completes. The phone's
  queue already resends a failed delete with its 4-send limit and "Sync failed — tap to retry".
- **Internal cleanups do not fail the request.** `cleanupReplaced` runs after a resubmission has
  already committed: on a failed S3 delete it logs a warning and leaves the stale row (and its
  objects) in place. `discardObjects` (an upload whose row was never written) stays a
  best-effort delete.
- **Unchanged from the 2026-10-29 note:** no S3 lifecycle rule, no new dependency, existing
  orphans are not swept here (G2, its own ticket), the six delete sites, and the 204 for a
  missing id on the Attach File delete (D11).

### Q10 of MOBILE-TICKET-PRESIGNED-IMAGES

**Answer: X, neither A nor B — best effort with rollback.** A failed S3 delete is not
swallowed and not queued for a worker: it fails the delete and rolls it back. No lifecycle
rule is relied on. The sweep of objects already orphaned stays a separate ticket. This is not a
server-side guarantee that every object is eventually removed.

## Why

- **Simplicity.** A table, a migration, a tenant-scoped model (G3), a claim/reclaim/backoff
  loop and a worker are more machinery than the developer wants for this.
- **The retry already exists.** The mobile delete queue retries a failed delete, so the case the
  worker covered (a delete that fails once) is covered by the caller.

## What this does not decide

- **The trade-off the developer accepted.** S3 and Postgres cannot share one transaction. If the
  commit fails after S3 has deleted, the row points at a missing file until a retried delete
  finishes it. A delete that keeps failing is not retried by the server; web and admin callers
  have no retry queue, so the user sees the error and retries by hand.
- **The mechanism's details are the AI's** (D20): the 503, the 20 s transaction timeout, the
  `deleteObjects` helper, the callback shape, the `cleanupReplaced` rule. The developer reviews
  them in the PR.
- **Other swallowed S3 deletes.** Entity photos (`attachment-photos.service.ts`) and signed
  quotation copies (`signed-copy-attachments.service.ts`) still swallow a failed delete; they
  stay follow-ups (spec §11c).
- **No product behaviour.** No TCG person ruled on this. It is an engineering rule for this
  build.

## Effect on the vault

- No vault file changes status. The 2026-10-29 outbox note gains `status: superseded` and
  `superseded_by` pointing here.
- `MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q10: the `Status:` line points at this note.
