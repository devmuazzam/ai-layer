# Intent — MOBILE-OFFLINE-DELETE-QUEUE

> One intent per ticket. Captures what the ticket asks for, from the ticket. Not a spec and
> not a design. There is no Jira id yet: the folder uses a descriptive slug, to be renamed
> when a Jira id exists (`processed.log` and the branch name follow the rename).

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `MOBILE-OFFLINE-DELETE-QUEUE` (slug; no Jira id yet) |
| Title | Reliable offline deletes on mobile and guaranteed S3 cleanup on the API |
| Type | Task |
| Status | NOT ON TICKET |
| Epic | NOT ON TICKET |
| Sprint | NOT ON TICKET |
| Reporter | Haris |
| Assignee | NOT ON TICKET |
| Captured on | `2026-10-29` |
| Captured by | Claude Code session, from the developer's request and review of the current code |

## 2. Business intent

- Intent: A photo or file a crew member deletes on a ticket must really be deleted, whether
  the phone is online or not. Today an offline delete of an already-uploaded photo is lost,
  and an online delete can leave the S3 object behind. The developer's stated goals: offline
  deletion should "remove from the UI, persist the deletion, then delete from S3 after
  reconnect", and "for ticket changes that are done offline we need to add them in a queue in
  mobile async storage and local storage and when mobile comes up online then we sync those
  changes at backend ... We need to make this mechanism more reliable".
- Who benefits (role): field crew (mobile users); whoever pays for and audits S3 storage.
- What is worse today without it: `NOT ON TICKET` as a business reason. The code records the
  technical one: no delete kind exists in the mobile sync queue, and the API swallows a failed
  S3 delete (`ticket-attachment-guard.service.ts`), leaving an object nothing references.

## 3. Definition of done, as the ticket states it

```
Partly—offline uploads work, but offline deletions are not reliably queued in this PR.
  Delete an uploaded checklist photo while offline: It disappears from the local UI, but the server delete fails. There is no persistent delete queue to retry it on reconnect, so the S3 copy can remain.
  Add/delete through "Attach File" while offline: Both operations are blocked with a reconnect message. This sheet does not queue uploads or deletions.

Your expected offline-delete behavior—remove from the UI, persist the deletion, then delete from S3 after reconnect—is a gap in the current implementation.

We should coordinate both, but a database transaction cannot include S3. ...
For reliable deletion, use a transactional outbox:
1. In one DB transaction, unlink/delete the attachment and save a deletion job containing its S3 keys.
2. After commit, attempt S3 deletion immediately.
3. If it fails, a worker retries the persisted job until cleanup succeeds.
Offline mobile deletion needs a separate persistent mobile queue, which sends the deletion request when connectivity returns. The backend outbox then handles S3 cleanup.

Yes, we need to plan these fixes
Also, for ticket changes that are done offline we need to add them in a queue in mobile async storage and local storage and when mobile comes up online then we sync those changes at backend. Are we maintaining the queue in mobile for all tickets that are changed offline in mobile.
We need to make this mechanism more reliable
```

- Acceptance criteria present on the ticket: no
- OPEN — the request has no acceptance criteria; per `domain/jira-sop.md` it does not meet
  Definition of Ready. The elaborator derives testable criteria from the stated goal and
  carries them as `[OPEN]` until the developer confirms them.

## 4. In scope

Each line comes from the developer's request or from a decision the developer made while the
plan was reviewed (2026-10-29).

- [ ] A delete of an already-uploaded ticket photo (checklist, signature) made offline is
      persisted on the device and sent to the server when the phone is back online.
- [ ] The photo disappears from the UI at once, offline or not.
- [ ] The API removes the S3 object(s) a deleted attachment owned reliably: the S3 keys are
      saved in the same database transaction as the row delete, and a worker retries until the
      S3 delete succeeds (the developer's decision: transactional outbox, no S3 lifecycle rule).
- [ ] The "Attach File" sheet queues uploads and deletes offline (the developer's decision:
      include it), instead of blocking them with a reconnect message.
- [ ] A review of whether the mobile queue holds every ticket's offline changes — answered in
      the plan: it does, per ticket draft, drained globally on reconnect. Any change needed to
      make it "more reliable" beyond deletes is `OPEN`.

## 5. Out of scope

- [ ] Sweeping S3 objects already orphaned by past swallowed deletes. A data operation
      (guardrail G2: developer approval and a run on a copy of staging data); the developer
      chose to defer it to its own ticket.
- [ ] A new broker or dependency (Redis, BullMQ, SQS): none is in the stack today; the worker
      reuses the existing `@nestjs/schedule` poller pattern.
- [ ] An S3 lifecycle rule (the developer chose the outbox instead).
- [ ] Changing the payroll calculation queue (`payroll_calculation_queue`): it is period-bound
      and stays as is; the outbox gets its own table.
- [ ] Offline capture/upload of step photos and signatures: already works; not changed.
- [ ] Web (`apps/web`): no change expected.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | S3-deletion worker and repository; delete sites in `ticket-attachment-guard.service.ts` enqueue instead of swallowing |
| `apps/api/prisma` (schema + migration) | yes | new outbox model + committed migration |
| `apps/web` (Next.js — atoms → pages) | no | |
| `apps/mobile` (Expo Router) | yes | delete op in the sync queue; photo-removal wiring; Attach File sheet queue |
| `packages/shared` (types shared across apps) | ? | only if the delete op or a status shape needs a shared type |

Notes for the elaborator:

- A `yes` on `apps/api/prisma` means a committed migration under
  `apps/api/prisma/migrations/` is mandatory (`.ai/claude/contexts/prisma.md`).
- A new tenant model goes in `TENANT_SCOPED_MODELS` (guardrail G3).

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `Attachment` | none (UUID) | reads and deletes rows; no schema change |
| new outbox model (name `OPEN`) | none | creates |

- New entity introduced by this ticket: yes
- New code prefix introduced: no — an internal queue row, not a business entity
- Existing rows affected (backfill / migration of data, not just schema): no — the sweep of
  existing orphans is out of scope

## 8. Roles and permissions

- Roles that can perform this: whoever may delete a ticket attachment today (unchanged);
  `NOT ON TICKET` for any new rule
- Roles explicitly excluded: `NOT ON TICKET`
- Tenant scope: standard per-tenant isolation for the new model; the worker has no request
  context, so it must run under the row's own tenant (as the payroll queue worker does)

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | N/A — no new screen; the Attach File sheet keeps its layout |
| Jira attachments | NOT ON TICKET |
| Related tickets | `MOBILE-TICKET-PRESIGNED-IMAGES` — the shipped work; its spec §12 Q10 asks exactly the S3-cleanup question this answers. `SCRUM-OFFLINE-SYNC` — the design ancestor of the mobile queue (intent and design only, never elaborated) |
| Existing repo docs | `.ai/aidlc/SCRUM-OFFLINE-SYNC/design/` |
| Vault area the reader thinks is relevant | `field-ops/field-ops-mobile-INDEX.md` — a guess; the elaborator verifies it |

## 10. Terms used that may not be defined

- outbox — used on the ticket as: "use a transactional outbox". A pattern name, not a domain term.
- orphan — used as: "the S3 copy can remain" / "an unused file remains in S3". An S3 object no
  database row references.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| retry count, poll interval, backoff for the worker | `NOT ON TICKET — no origin cited` |
| how long an offline delete may wait on the device | `NOT ON TICKET — no origin cited` |

The existing payroll queue uses a 10 s poll and 3 attempts; that is code, not a source for
this ticket.

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: Status, Epic, Sprint, Assignee, business reason, Jira
  attachments, excluded roles, worker numbers (2 in §11)
- Fields left as `OPEN`: acceptance criteria (§3), outbox model name (§7), any further
  queue-reliability change beyond deletes (§4)
- Is this ticket, as written, buildable without a product answer? yes, for the delete queue
  and the outbox. `OPEN`: what "more reliable" means for the rest of the offline queue.
- If no, the blocking questions are: none for the units; the reliability scope question is
  carried into `spec.md` §12.
