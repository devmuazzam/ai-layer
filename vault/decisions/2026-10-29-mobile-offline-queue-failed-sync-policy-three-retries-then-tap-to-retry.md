---
title: "Failed-sync policy for queued ticket changes on mobile: no retention limit, one send then at most 3 retries counting only server-answered errors, then \"Sync failed — tap to retry\" on the ticket card and the completed rows in Jobs; the tap probes the API, resets the count and starts a drain — decision"
source: decision/Syed Haris (CodingCops) — his answers to MOBILE-OFFLINE-DELETE-QUEUE spec §12 Q4, Q9, Q10, Q12 and the retry count in a Claude Code session, 2026-10-29
decided: 2026-10-29
decided_by: >-
  Syed Haris (CodingCops), the developer and requester of MOBILE-OFFLINE-DELETE-QUEUE, in
  conversation with Claude Code on 2026-10-29. He answered Q4, then the retry count, Q12, Q9
  and Q10, and agreed ("sure") that the tap probes the API first. He did not answer Q11.
  tcg-scrum did not see the session. It records from the spec's §12 Answer lines, REQ-09,
  REQ-12, REQ-13 and §11b D16 to D19. This is a developer decision. It binds this build. It is
  not a TCG client ruling, so the status is reference.
status: reference
resolves:
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q4
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q9
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q10
  - MOBILE-OFFLINE-DELETE-QUEUE/spec.md#q12
conflicts_with: []
related_tickets:
  - MOBILE-OFFLINE-DELETE-QUEUE
related_decisions:
  - 2026-10-29-offline-deletes-and-attach-file-sheet-queued-on-the-phone.md
  - 2026-10-29-ticket-attachment-s3-deletion-guaranteed-by-transactional-outbox.md
  - 2026-10-15-late-and-incomplete-tickets.md
tags: [module/field-ops, kind/decision, offline, ticket-workflow]
---

# Failed-sync policy for queued ticket changes on mobile

## Decision

Source: `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md` §12 Answer lines Q4, Q9, Q10, Q12;
REQ-09, REQ-12; §11b D16, D17, D18, D19. Haris, 2026-10-29.

Q4, verbatim: "No Retention time. 3 re tries. after 3rd failed retry, we need to show a badge
or indicator in mobile ticket card for failed sync".

- **No retention limit (Q4, D16).** A queued item waits on the phone as long as it takes. It is
  never dropped, flagged or wiped because of its age. The server's own window and 72h grace
  still apply, and answer 409 (handled by cause, see the related note).
- **One send, then at most 3 retries (D17).** Haris: "1 send + 3 retries (4 total)". The first
  failed send is not a retry. An item is sent at most 4 times.
- **Only a server-answered error counts (Q12, option B).** Haris: "Only count server-refused
  sends". A send counts toward the 3 retries only when the server answered it with an error.
  These do **not** count:
  - a timeout;
  - no connection;
  - a network error;
  - a 409 (handled by cause, REQ-08).
- **Stated consequence, accepted by the developer.** An item that never reaches the server is
  retried on every scan, with no counter, and **never shows the badge**. For example, an item
  that always times out on a weak link loops on every scan and stays invisible to this rule
  (REQ-09).
- **The failed-sync badge (Q4, Q9, Q10, D18).** After the 3rd failed retry, a badge reading
  exactly "Sync failed — tap to retry" shows on:
  - the active ticket card;
  - the ticket's completed row in Jobs.

  It is **not** shown inside the open ticket's own screens (Q9: "Card + completed rows in
  Jobs").
- **The tap (Q10 and the probe).** The text "tap to retry" adds a retry tap. Haris agreed
  ("sure") that the tap does not trust the NetInfo flag alone:
  1. The tap probes the API with `isApiReachable()` (`apps/mobile/lib/api-reachable.ts`, on
     `origin/staging`).
  2. If the API answers, the tap resets the retry count and starts a drain for that ticket,
     **even when NetInfo says offline**.
  3. If the API does not answer, the app shows the existing offline message and does nothing
     else.

## Why

- **The probe.** On the developer's iPhone the NetInfo flag read "offline" while the API was
  reachable (REQ-12, D19). A tap gated on that flag alone would do nothing.
- **Counting only server answers (Q12).** The spec set out the trade-off. Counting
  connection errors would flag tickets the server never rejected, in poor signal. Counting
  only server answers never flags a ticket that cannot reach the server. Haris chose the
  second, with its consequence stated.
- **The reasons for no retention and for 3 retries were not recorded.** Only the choices were
  given.

## Not answered — Q11

**Q11 is not answered.** It asks whether the 3-retry rule and the failed-sync badge also cover
a ticket submit that fails, or only queued items. Haris did not answer it (session
2026-10-29). REQ-13 stays `[OPEN]` and Q11 stays `open`. The workaround is labelled as one:
this ticket covers queued ops only, and a failed submit keeps today's behaviour. This note
does not decide it.

## Assumptions — NOT the developer's words

These are the AI's assumptions in D19 and REQ-12. Each one is reviewable in the PR:

- One retry is one attempt by the open-ticket drain, the background scan or the badge tap. The
  pacing is the existing reconnect, app-open and manual triggers. There is no timer.
- The count is a new optional field on the persisted `StepSyncEntry`, read as 0 when absent.
- The count is kept per ledger entry, not per op.
- After the 3rd failed retry, automatic retries stop for that entry, and its ops and local
  files are kept. New work written to the step also resets the count.
- A failed entry still blocks later entries and the submit, as a failed step does today.
- The badge ends when the entry becomes `synced`.
- "Server-refused" means any HTTP error status other than 409, including 401, 403 and 5xx.
- The tap resets all of the ticket's exhausted items.
- The badge's look: the shared `Badge` component, as the existing "Offline" badge uses. The
  "Offline" badge may show beside it. Haris gave the text, not the look.

## What this does not decide

- **Q11**, a failed ticket submit (above).
- **Q8**, the derived acceptance criteria. It stays open.
- **The server-side outbox worker's retries.** The developer's 3 retries are for the phone's
  queue. The server worker's `maxAttempts` (8) is AI decision D3. See
  `decisions/2026-10-29-ticket-attachment-s3-deletion-guaranteed-by-transactional-outbox.md`.
- **Any signal for an item that never reaches the server.** It is not part of this ticket.
- **No product behaviour from TCG.** No TCG person ruled on this. The field-ops conflict stub
  (`field-ops/field-ops-mobile-INDEX.md`) is unresolved, and this note takes no side.

## Effect on the vault

- No vault file changes status. This note adjudicates no vault conflict and edits no
  frontmatter.
- `.ai/aidlc/MOBILE-OFFLINE-DELETE-QUEUE/spec.md` §12: the `Status:` lines of Q4, Q9, Q10 and
  Q12 are changed from `answered` to resolved, pointing at this note. **Done** (2026-10-29).
  Q11 is unchanged (`open`). No other text in the spec is changed.
