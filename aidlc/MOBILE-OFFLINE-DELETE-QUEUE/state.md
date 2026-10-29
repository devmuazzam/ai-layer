# State — MOBILE-OFFLINE-DELETE-QUEUE reliable offline deletes on mobile and guaranteed S3 cleanup on the API

**Path:** A · **Branch(es):** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u1-outbox-worker` (U1, from `origin/staging`, pushed); `feat/MOBILE-OFFLINE-DELETE-QUEUE-u2-delete-sites` (U2, stacked on U1, not pushed); later `feat/MOBILE-OFFLINE-DELETE-QUEUE-u<n>-<slug>`, stacked U2 to U5 · **Last updated:** 2026-10-29 by tcg-executor (U2 built)

## Phases

Markers: `[ ]` not started · `[-]` in progress · `[?]` blocked on a human — name the §12 Q ·
`[x]` done · `[S]` skipped — say why. Never delete a row; paths B and C mark most rows `[S]`.

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (`tcg-elaborator`); updated 2026-10-29 with the developer's answers
- [?] Sign-off — `spec.md` §14; open in §12 (owner Haris): **Q8** (derived acceptance criteria not confirmed) and **Q11** (does the 3-retry rule and badge cover a failed ticket submit; not answered; workaround: queued ops only; keeps REQ-13 open). Answered: Q1 (AI decision D13), Q2, Q3, Q4, Q5, Q6, Q7, Q9, Q10, Q12, Q13; D7 and D11 confirmed
- [x] Units — `units.md` (`tcg-decomposer`); 5 units, stack order U1, U2, U3, U4, U5 (numeric); REQ-13 unassigned (Q11); no unit blocked
- [-] Build — unit by unit; status per unit in the `units.md` ledger (`tcg-executor`); U1 and U2 built, U3 to U5 not started
- [ ] Analyse — verdict per unit (`tcg-analyst`)
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

## Resume

**U2 built** on `feat/MOBILE-OFFLINE-DELETE-QUEUE-u2-delete-sites` (stacked on U1's branch), committed locally (`3626d1295`, then the generic-delete commit on top), **not pushed** (push: `git push -u origin HEAD:feat/MOBILE-OFFLINE-DELETE-QUEUE-u2-delete-sites`; PR targets U1's branch). Delivered: `removeIfUnreferenced` enqueues in its transaction and returns `{ deleted, jobId }` (signature-referenced 409 now `code: ATTACHMENT_IN_USE`, no job); `discardObjects` queues the leftover keys as a job of its own (`StorageDeletionQueueService.enqueueAndAttempt`, repo `enqueue`), falling back to the direct best-effort delete plus an error log if the insert fails; `TicketAttachmentsService.remove` goes through `deleteOrphaned` and a missing id answers 204 (an id on another ticket or feature still 403); `TICKET_ATTACHMENT_ERROR_CODES` in `@tcg/shared` (name confirmed by the developer); sixth site, folded in by the developer: the generic `DELETE /attachments/:id` goes through `AttachmentsService.delete` (row delete + keys in one transaction, `attemptNow` after the log and PO-reopen side effects, controller no longer calls S3; the photo/cover path is unchanged). Gates: api lint 0 errors / 667 warnings (= baseline), build pass, test 293 suites / 3419 tests pass (four existing specs updated), mobile + web typecheck pass, boot OK (DI, worker polling with no errors). Caveat: the worktree's `node_modules` symlinks to the primary checkout, so api build and jest were run with a temporary `@tcg/shared` path mapping to the worktree dist (reverted, not committed); the primary checkout's `packages/shared/dist` was NOT rebuilt. `tcg-contract-tracer` could not be spawned (no Agent tool): four-pass search done by hand, no mobile reader of any 409 `code`. **Out of scope (§11c):** entity photos (`attachment-photos.service.ts:446`), reachable through the generic delete when the row is a photo (it keeps its existing photo delete), and the quotation signed copy. Next: the developer pushes U2; build **U3** (stacked on U2). Open in spec §12: Q8 and Q11 (REQ-13). No unit is blocked.
