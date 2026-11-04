---
title: "Mobile ticket follow-ups after device testing: a ticket the server has not completed is never shown completed and a failed submit raises the Sync failed badge (Q11 in part), the double tick reads the sync ledger, and a checklist photo gets its category at upload — developer direction and AI decisions, kept apart"
source: decision/Syed Haris (CodingCops) — his direction, report and request in the Claude Code session of MOBILE-OFFLINE-DELETE-QUEUE, 2026-10-30; the rules are the AI's (spec §11b D21, D22, D23)
decided: 2026-10-30
decided_by: >-
  Syed Haris (CodingCops), the developer and requester of MOBILE-OFFLINE-DELETE-QUEUE, in
  conversation with Claude Code on 2026-10-30, while testing the U3 to U5 build on a device. He
  gave a direction ("real fix here"; "the ticket state should be consistent!"), a report (the
  single tick stayed) and a request (the category at upload). He did not state the rules below:
  each rule is the AI's decision, recorded in spec §11b D21, D22 and D23 with "Reviewed by:
  pending". tcg-scrum did not see the session. It records from spec REQ-13 to REQ-15, §11b D21
  to D23, §12 Q11 and units.md U6 to U8. This is a developer direction for this build. It is not
  a TCG client ruling, so the status is reference.
status: reference
resolves:
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q11 # in part; whether a failed submit counts against the 4-send limit is not resolved here
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#d21
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#d22
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#d23
conflicts_with: []
related_tickets:
  - MOBILE-OFFLINE-DELETE-QUEUE
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md
  - 2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md
  - 2026-10-30-ticket-attachment-s3-deletion-in-the-row-delete-transaction-no-outbox.md
tags: [module/field-ops, kind/decision, offline, ticket-workflow]
---

# Mobile ticket follow-ups after device testing: ticket state, the double tick, category at upload

Source: `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md` REQ-13, REQ-14, REQ-15; §11b D21, D22,
D23; §12 Q11 Status line. `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/units.md` section "U6 to U8".
Haris, 2026-10-30. Built in PR #985 (merge commit `819483fdb` on `staging`): U6 `8f3801ea5`,
U7 `d7be07945`, U8 `77b16664d`.

Each part below keeps two things apart:

- **The developer's words** — what Haris said, quoted as the spec records it.
- **The AI's decision** — the rule the AI chose to meet it. The developer has not reviewed these
  rules. Each is reviewable in the PR.

## 1. What "completed" means on the phone (REQ-13, D22, Q11 in part)

### The developer's words

Haris, verbatim (spec REQ-13 *Sources*): "real fix here" and "if these tickets are not saved on
server side due to any issue then these should not show as completed on mobile. The ticket
state should be consistent!"

The evidence he reacted to: TK-00031 and TK-00032 showed as completed, with an "Offline" icon,
while the server held them as `IN_PROGRESS` (`completed_at` null). Their drafts were clean
(`submitState: idle`, nothing to sync), so nothing was ever going to send (units.md U7).

### The AI's decision — D22, NOT the developer's words

The spec says: "The rule is the AI's reading of the developer's direction." D22 has
"Needs developer: yes — the reading is the AI's".

- A recorded local submission always counts as completed: `submitState` is `submitted` or
  `pendingSync`, or the draft holds an `OFFLINE-` ref.
- A step counter past the last step counts as completed **only** while the server status is
  unknown or `COMPLETE`. It does not by itself make a ticket completed while the server holds it
  as anything else.
- A ticket past the last step that is not completed opens on its last step, editable.
- A submit the server never accepted (`submitState: 'error'`) raises the same
  "Sync failed — tap to retry" badge as an exhausted step. The tap already drains and finalizes.

Built in U7 (`use-ticket-progress.ts`, `step-status.ts` `isTicketComplete(active, total,
serverStatus?)`, `ticket-step-screen.tsx`, `app/(field)/ticket/index.tsx`).

### What this does NOT decide

- **Whether a failed submit counts against the 4-send limit.** It is not built: there is no
  4-send counter for a submit. The badge reads `submitState: 'error'` alone. Q11 stays
  **answered in part**; this note does not resolve option B's counting.

## 2. The double tick after an offline upload lands (REQ-14, D21)

### The developer's words

Haris, report (spec REQ-14 *Sources*): "it did not sync … I still see the single green tick".
The spec records the quote with an ellipsis; the full sentence is not written down.

Reproduced on the emulator: the upload answered 201 about 3 s after reconnect, and the tick
stayed single. The tick meanings are in `sync-status-badge.tsx`: "local: single tick; server:
double tick".

This is a report of a defect. Haris did not state a rule.

### The AI's decision — D21, NOT the developer's words

- The tick reads the sync ledger. A `local:` reference counts as on the server once
  `sync.attachments[localId].serverId` is set (`isAttachmentOnServer`, in
  `local-attachments.ts`).
- The three tick sites subscribe to `sync.attachments`: the `ChecklistEngine` photo grid and
  preview, `deficiency-panel`, `signer-capture`.
- Rejected: rewriting the saved capture to the server id after the upload. The open screen's
  React state would not update, and the store holds the capture that the next send resolves.

Built in U6.

## 3. The category of a checklist photo, at upload (REQ-15, D23)

### The developer's words

Haris, request (spec REQ-15 *Sources*): "It should assign the category right away … we do not
have to wait for continuing to next step". The spec records the quote with an ellipsis.

The labels already existed. The submit route wrote them (`labelAttachment`).

### The AI's decision — D23, NOT the developer's words

- The phone sends an optional `checklistType` body field (`pretrip`, `jsa`, `posttrip`, from the
  step key) on `POST /field/tickets/:id/checklists/attachments`.
- The API maps it with the existing `CHECKLIST_CATEGORIES` ("Pre-Trip Checklist",
  "JSA Checklist", "Post-Trip Checklist") and passes `category` to `storeUpload`. The phone never
  sends the label itself.
- The field is optional. An older build that does not send it still gets the label at submit.
- An invalid `checklistType` is a 400 (`ParseEnumPipe`).
- A repeated upload (same `clientUploadId`) returns the stored row unchanged.
- A queued upload stores the type (`LocalAttachmentEntry.checklistType`).
- Rejected: the API inferring the checklist from the ticket's current step. The request carries
  no step.
- **Signatures are not included.** A signature image is still labelled when its step is saved.
  The request did not name signatures.

Built in U8.

## Assumptions — every AI-made choice in this note

None of these is the developer's words. Each is reviewable in the PR (§11b "Reviewed by:
pending").

- **D22, the reading itself.** "Consistent" was read as: the server's status wins over the step
  counter, but a recorded local submission wins over the server's status.
- **D22, a recorded local submission always counts.** A ticket submitted offline
  (`pendingSync`) still shows as completed, with the "Offline" icon, before the server holds it as
  `COMPLETE`. This is a deliberate exception to "not saved on server side … should not show as
  completed".
- **D22, server status unknown.** When the list has not loaded (an offline cold start), the step
  counter is trusted as before.
- **D22, the last step.** A ticket past the last step that is not completed opens on its last
  step, editable.
- **D22, the failed submit reuses the existing badge.** Same text, same tap; no separate message.
- **D22, no counter for a submit.** A failed submit shows the badge at once, not after 4 sends.
- **D21, the ledger is the source of truth** for the tick, not the saved capture.
- **D21, scope.** The checklist, deficiency and signature photo ticks.
- **D23, the field name and values.** `checklistType` with `pretrip`, `jsa`, `posttrip`, taken
  from the step key.
- **D23, optional, with the submit-time label kept** as the fallback for older builds.
- **D23, signatures excluded.**
- **D23, a 400 for an invalid value; a repeated upload returns the stored row unchanged.**

## Not decided

- **Whether a failed submit counts against the 4-send limit** (Q11, option B's counting). Q11
  stays answered in part.
- **The developer's review of D21, D22 and D23.** All three read "Reviewed by: pending".
- **U8 against a live API.** units.md U8: "Not run live: the running API was an old build that
  ignores the field".
- **What "completed" means across the field-ops docs.** The phone's code uses three meanings
  (server `COMPLETE`, a recorded local submission, a step counter past the last step). This note
  records only the build rule. No glossary entry is written.
- **D24, re-signing a step deletes the signature image it replaced.** Commit `c165917b1` is not
  in `staging`. It waits for the developer and is not recorded here.
- **Q16**, which server answers count as a refused send. It is open in spec §12.
- **Q8**, the derived acceptance criteria. It is open.
- **No product behaviour from TCG.** No TCG person ruled on this. The field-ops conflict stub
  (`field-ops/field-ops-mobile-INDEX.md`) is unresolved, and this note takes no side.

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no frontmatter.
- `decisions/2026-10-29-mobile-offline-queue-failed-sync-policy-three-retries-then-tap-to-retry.md`
  gains a section "Added 2026-10-30 — Q11 in part" pointing here. **Done** (2026-10-30). Its
  original text is unchanged.
- `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md` §12 Q11: its `Status:` line already reads
  "answered in part 2026-10-30". Not edited by this note.
