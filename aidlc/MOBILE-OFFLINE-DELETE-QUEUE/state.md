# State — MOBILE-OFFLINE-DELETE-QUEUE reliable offline deletes on mobile and guaranteed S3 cleanup on the API

**Path:** A · **Branch(es):** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u1-outbox-worker` (U1, from `origin/staging`, pushed); `feat/MOBILE-OFFLINE-DELETE-QUEUE-u2-delete-sites` (U2, stacked on U1, not pushed); `feat/MOBILE-OFFLINE-DELETE-QUEUE-u3-mobile-delete-op` (U3, stacked on U2, not pushed); `feat/MOBILE-OFFLINE-DELETE-QUEUE-u4-attach-file-queue` (U4, stacked on U3, not pushed); later `feat/MOBILE-OFFLINE-DELETE-QUEUE-u<n>-<slug>`, stacked U4 to U5 · **Last updated:** 2026-10-30 by tcg-executor (U4 built)

## Phases

Markers: `[ ]` not started · `[-]` in progress · `[?]` blocked on a human — name the §12 Q ·
`[x]` done · `[S]` skipped — say why. Never delete a row; paths B and C mark most rows `[S]`.

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (`tcg-elaborator`); updated 2026-10-29 with the developer's answers
- [?] Sign-off — `spec.md` §14; open in §12 (owner Haris): **Q8** (derived acceptance criteria not confirmed) and **Q11** (does the 3-retry rule and badge cover a failed ticket submit; not answered; workaround: queued ops only; keeps REQ-13 open). Answered: Q1 (AI decision D13), Q2, Q3, Q4, Q5, Q6, Q7, Q9, Q10, Q12, Q13; D7 and D11 confirmed
- [x] Units — `units.md` (`tcg-decomposer`); 5 units, stack order U1, U2, U3, U4, U5 (numeric); REQ-13 unassigned (Q11); no unit blocked
- [-] Build — unit by unit; status per unit in the `units.md` ledger (`tcg-executor`); U1 to U4 built, U5 not started
- [-] Analyse — verdict per unit (`tcg-analyst`); **U2 analysed: verdict MERGE** (findings in the U2 block of `units.md`, none blocking); U1 and U3 to U5 not analysed here. `tcg-contract-tracer` on U2 (spec §14 box, left unticked): done by hand in the executor report
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

- **U2 scope note (2026-10-29):** U2 covers six delete sites in all with U1 (the generic `DELETE /attachments/:id` was folded into U2, commit `7d826e40e`; U2 = `3626d1295` + `7d826e40e`). `units.md` U2 now says so and the Ledger row, Outcome, Slice contents, Ripple and Demo include it.

## Resume

**U4 built** on `feat/MOBILE-OFFLINE-DELETE-QUEUE-u4-attach-file-queue` (stacked on U3's branch), two local commits, **not pushed** (push: `git push -u origin HEAD:feat/MOBILE-OFFLINE-DELETE-QUEUE-u4-attach-file-queue`; PR targets U3's branch). F2 confirmed: the sheet is mounted only from `TicketDetails`, which only the open ticket's screens render, so the flow store holds the ticket and its draft (`queueSyncOp` persists it); no second queue. Delivered: API (`POST` and `DELETE /field/tickets/:id/attachments`: optional `clientUploadId` on the upload, `X-Captured-At` on both, passed to the window guard); mobile: reserved ledger key `__attachFileUploads` (`sync/attach-file-queue.ts`) holding `uploadAttachment` ops (local file copy in the ticket's document folder, local id as `clientUploadId`), `deleteAttachment` target `attachments` under the existing delete key, per-file acknowledgment through a new `onAttachmentUploaded` hook (drain and background sync), "Pending sync" rows with a remove button (cancel both), queued deletes hidden from the list, cached list updated when ops land, the two offline blocks removed, `ticket-attachments-sheet.test.tsx` updated. Caveat: temporary `@tcg/shared` path mappings to the worktree dist were used for gates and reverted, not committed. Not decided (reported): a permanently refused queued upload (400) wedges its key until the crew removes the row; U5's counter will stop retries but not unblock it. Next: the developer pushes U4; build **U5** (stacked on U4). Open in spec §12: Q8 and Q11 (REQ-13). No unit is blocked.
