---
title: "Offline deletes of uploaded ticket photos and the Attach File sheet are queued on the phone: a 409 is handled by cause, a photo whose upload is still queued cancels both, Attach File has only the 50 MB per-file cap and a \"Pending sync\" marker, failed outbox rows are kept and logged, and the Attach File queue is a reserved key in the draft's sync ledger — decision"
source: decision/Syed Haris (CodingCops) — his answers to MOBILE-OFFLINE-DELETE-QUEUE spec §12 in a Claude Code session, 2026-10-29
decided: 2026-10-29
amended: '2026-10-30 — section "Added later — a queued Attach File upload the server refuses for good"'
decided_by: >-
  Syed Haris (CodingCops), the developer and requester of MOBILE-OFFLINE-DELETE-QUEUE, in
  conversation with Claude Code on 2026-10-29. He answered Q2, Q3, Q5, Q6, Q7 and Q13 of
  .ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md §12 and confirmed D7 and D11. tcg-scrum did not
  see the session. It records from the spec's §12 Answer lines, REQ-01 and REQ-05 to REQ-11,
  and §11b. This is a developer decision. It binds this build. It is not a TCG client ruling,
  so the status is reference.
status: reference
resolves:
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q2
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q3
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q5
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q6
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q7
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q13
conflicts_with: []
related_tickets:
  - MOBILE-OFFLINE-DELETE-QUEUE
related_decisions:
  - 2026-10-29-ticket-attachment-s3-deletion-guaranteed-by-transactional-outbox.md
  - 2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md
  - 2026-10-15-late-and-incomplete-tickets.md
tags: [module/field-ops, kind/decision, offline, ticket-workflow, signatures]
---

# Offline deletes and the Attach File sheet are queued on the phone

## Decision

Source: `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md` §12 Answer lines Q2, Q3, Q5, Q6, Q7,
Q13; REQ-01, REQ-05 to REQ-11; §11b D7, D9, D11, D14, D15. Haris, 2026-10-29.

- **Scope.** An offline delete of an uploaded checklist, signature or identity photo is
  persisted on the phone and sent on reconnect (REQ-01). The photo leaves the screen at once
  (REQ-02). The Attach File sheet queues uploads and deletes offline instead of blocking them
  with a reconnect message (REQ-06). On the server, the five delete sites enqueue S3 keys,
  and a missing id on the Attach File delete returns 204: **D7 and D11, confirmed by Haris.**
  See `decisions/2026-10-29-ticket-attachment-s3-deletion-guaranteed-by-transactional-outbox.md`.
- **Q2 — a 409 is handled by cause.** Haris: "Split by cause". REQ-08, REQ-05, D14.
  - The API returns a distinguishable code for each of the two 409 causes.
  - **Signature-referenced** (a saved signature still points at the image): the 409 carries
    a distinct code. The phone drops the queued op, restores the photo in the UI and tells
    the crew.
  - **Window closed** (`TICKET_WINDOW_CLOSED`): the op stays queued, and the existing
    "Request approval" path is shown.
- **Q3 — cancel both.** Haris: "Cancel both". If the crew removes a photo offline whose
  upload op is still queued, the queued upload and the delete are both dropped. Nothing is
  sent and nothing reaches S3 (option A). REQ-07, D15.
- **Q5 — the per-file 50 MB cap only.** The Attach File queue keeps the existing 50 MB cap per
  file (`TICKET_ATTACHMENT_MAX_BYTES`). There is no cap on the number of files and no cap on
  the total size. REQ-10.
- **Q6 — a "Pending sync" marker.** A queued Attach File row carries a small marker. The copy
  is exactly "Pending sync" (option A). REQ-10.
- **Q7 — failed outbox rows are kept and logged only.** **Superseded 2026-10-30:** there is no
  outbox (see `decisions/2026-10-30-ticket-attachment-s3-deletion-in-the-row-delete-transaction-no-outbox.md`); a failed S3 delete is logged at error level and fails the
  delete with a 503. Earlier answer: when a server-side S3 deletion job uses up its attempts and
  ends FAILED, the row is kept with its last error and the event is logged at error level. No
  list, no notification (option A). REQ-11.
- **Q13 — the Attach File queue is a reserved ledger key.** The Attach File offline queue is a
  reserved key in the ticket draft's sync ledger, sent by the existing sync. It is **not** a
  separate durable queue (option A). This confirms D9. REQ-06.

## Why

- **The split by cause (Q2).** The two 409s mean different things. A signature-referenced
  image will be refused on every retry, so keeping the op would wedge the queue. A
  window-closed refusal can succeed after payroll's approval reopens the window. Today the
  mobile drain reads every 409 as "window closed" (`drain.ts:169`), and the
  signature-referenced 409 has no code (`attachments.repository.ts:77-80`). So the API gives
  it one.
- **Cancel both (Q3).** A photo that never reached the server has nothing to delete there.
  Uploading it only to delete it again would put an object in S3 for no reason.
- **One queue (Q13).** The developer's decision is to use the existing sync queue, with no
  second queue. The ledger already ranks any non-step key after the flow steps
  (`drain.ts:88-104`).
- **The reasons for Q5, Q6 and Q7 were not recorded.** Only the choices were given.

## Gaps the AI filled — these are NOT the developer's words

Do not read these as decisions. They are assumptions written into the spec, and each one can
be reviewed in the PR:

- **The crew message for a signature-referenced refusal has no wording.** Q2 says "tell the
  crew" but gives no copy. The spec ASSUMES the server's existing message is shown through
  the app's current error display (`formatApiError`). The server's text is "This image is
  part of a saved signature and cannot be removed" (REQ-08 notes). No new copy is written.
- **The completed-step photo sub-case is an assumption.** Q3 covers a photo whose upload op
  is still queued. It does not cover a photo still named by a **completed** step's stored
  writes. For that sub-case only, the spec ASSUMES the nearest existing behaviour: the photo
  is uploaded, then deleted by the sweep, now as a queued delete op (REQ-07 notes, D15). The
  executor reports it in the PR if the stored op cannot be rewritten safely.

Smaller assumptions in the same spec, also not decisions:

- "Restore the photo in the UI" is read as re-reading the ticket's server data (REQ-08).
- A window-closed delete that stays queued keeps the photo hidden (REQ-08).
- A 409 with neither code is treated like today's 409: keep the op and show "Request
  approval" (REQ-08).
- A queued Attach File upload removed before reconnect is cancelled the same way as Q3
  (REQ-07).
- The error-code name `ATTACHMENT_IN_USE` and its home in `@tcg/shared` are the AI's choice
  (D14).
- The Attach File sheet receives only a ticket id and sits outside the flow store. If no draft
  can be reached or created from it, the executor stops and raises a new §12 question. It does
  not build a second queue (REQ-06, `units.md` F2).

## Added later — a queued Attach File upload the server refuses for good

Source: Haris, in conversation with Claude Code (the U4 "wedge question"; recorded in
`.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/units.md`, U4 block, *AI decisions made in U4*, and
relayed by the coordinator, session 2026-10-29/30). It is not a §12 question, so no `Status:`
line changes for it. Status `reference`, as for the rest of this note.

- **The developer's choice:** "Drop it and tell the crew".
- **Dropped** means: the queued `uploadAttachment` op is removed from the ledger and the
  local copy of the file is deleted. Later files under the same key still send.
- **Told** means: the server's own message is shown through the existing error display
  (`showGlobalToast` with `formatApiError`). No new copy is written and nothing is prepended.
- **Refused for good** means a server-answered HTTP **400, 413, 415 or 422**
  (`UPLOAD_REFUSED_FOR_GOOD` in `apps/mobile/features/field-ticket/sync/step-ops.ts`). This
  list is the **AI's concrete reading** of "refused permanently", not the developer's words.
- **Not dropped:** a 5xx, no answer from the server, 401, 403, 404, 408, 429 and 409. They
  keep their existing handling. A window-closed 409 still keeps the op and the "Request
  approval" path (Q2).

**Also confirmed by Haris (relayed, 2026-10-30):** the shared code name
`TICKET_ATTACHMENT_ERROR_CODES.ATTACHMENT_IN_USE`. The line above under *Gaps the AI filled*
that calls `ATTACHMENT_IN_USE` "the AI's choice (D14)" is kept as the record; the name is now
developer-confirmed.

### AI choices in this section — NOT the developer's words

- The status list 400, 413, 415, 422 for "refused for good", and the list of statuses that
  are not dropped.
- Continuing with later files in the key after a drop (the drop itself, op and local file,
  is the developer's).
- Showing the server's message as it stands, with no file name prepended.

## What this does not decide

- **Q8**, the derived acceptance criteria. It stays open.
- **Retry limits and the failed-sync badge.** See
  `decisions/2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md`.
- **That L17 covers deletes and Attach File uploads.** The 72h grace in
  `decisions/2026-10-15-late-and-incomplete-tickets.md` L17 says "each queued op". The spec
  reads it as covering the new ops. That reading is flagged `[UNVERIFIED]` (spec §0). Haris
  did not rule on it.
- **The field-ops conflict.** Offline behaviour sits under the unresolved
  `field-ops/field-ops-mobile-INDEX.md` stub. This note takes no side and adjudicates nothing
  there.
- **No product behaviour from TCG.** No TCG person ruled on this.

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no
  frontmatter.
- `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md` §12: the `Status:` lines of Q2, Q3, Q5, Q6, Q7
  and Q13 are changed from `answered` to resolved, pointing at this note. **Done**
  (2026-10-29). No other text in the spec is changed.
- Q1 is not resolved by this note. It was left to the AI and decided as D13. Its `Status:`
  line is unchanged.
