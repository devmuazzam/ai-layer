# State — MOBILE-OFFLINE-DELETE-QUEUE reliable offline deletes on mobile and guaranteed S3 cleanup on the API

**Path:** A · **Branch(es):** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u1-outbox-worker` (U1, from `origin/staging`, pushed); `feat/MOBILE-OFFLINE-DELETE-QUEUE-u2-delete-sites` (U2, stacked on U1, not pushed); `feat/MOBILE-OFFLINE-DELETE-QUEUE-u3-mobile-delete-op` (U3, stacked on U2, not pushed); later `feat/MOBILE-OFFLINE-DELETE-QUEUE-u<n>-<slug>`, stacked U3 to U5 · **Last updated:** 2026-10-29 by tcg-executor (U3 built)

## Phases

Markers: `[ ]` not started · `[-]` in progress · `[?]` blocked on a human — name the §12 Q ·
`[x]` done · `[S]` skipped — say why. Never delete a row; paths B and C mark most rows `[S]`.

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (`tcg-elaborator`); updated 2026-10-29 with the developer's answers
- [?] Sign-off — `spec.md` §14; open in §12 (owner Haris): **Q8** (derived acceptance criteria not confirmed) and **Q11** (does the 3-retry rule and badge cover a failed ticket submit; not answered; workaround: queued ops only; keeps REQ-13 open). Answered: Q1 (AI decision D13), Q2, Q3, Q4, Q5, Q6, Q7, Q9, Q10, Q12, Q13; D7 and D11 confirmed
- [x] Units — `units.md` (`tcg-decomposer`); 5 units, stack order U1, U2, U3, U4, U5 (numeric); REQ-13 unassigned (Q11); no unit blocked
- [-] Build — unit by unit; status per unit in the `units.md` ledger (`tcg-executor`); U1, U2 and U3 built, U4 and U5 not started
- [-] Analyse — verdict per unit (`tcg-analyst`); **U2 analysed: verdict MERGE** (findings in the U2 block of `units.md`, none blocking); U1 and U3 to U5 not analysed here. `tcg-contract-tracer` on U2 (spec §14 box, left unticked): done by hand in the executor report
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

- **U2 scope note (2026-10-29):** U2 covers six delete sites in all with U1 (the generic `DELETE /attachments/:id` was folded into U2, commit `7d826e40e`; U2 = `3626d1295` + `7d826e40e`). `units.md` U2 now says so and the Ledger row, Outcome, Slice contents, Ripple and Demo include it.

## Resume

**U3 built** on `feat/MOBILE-OFFLINE-DELETE-QUEUE-u3-mobile-delete-op` (stacked on U2's branch), committed locally (API header commit, then the mobile commit), **not pushed** (push: `git push -u origin HEAD:feat/MOBILE-OFFLINE-DELETE-QUEUE-u3-mobile-delete-op`; PR targets U2's branch). Delivered: `deleteAttachment` op (`checklist` / `signatures`) under the reserved ledger key `__deleteAttachments` (`DELETE_QUEUE_LEDGER_KEY`, `sync/step-ops.ts`), store action `queueSyncOp`, `sync/delete-queue.ts` (`queueAttachmentDelete`), `usePhotoRemoval` and the `use-ticket-outbox` sweep queue the op (offline and online one path), cancel-both unchanged in effect (a never-uploaded `local:` photo drops its upload and queues nothing), the 409 split (`ATTACHMENT_IN_USE` dropped inside `sendOp` with the server message via the global toast and the signature reference put back in the draft, `sync/refused-delete.ts`; every other 409 keeps the op and `needsEditRequest` in `refusedByWindow` / `markConflictedStep`, apart from the generic `failedStep` / `markRejectedStep` U5 will count in), `getApiErrorCode`, and `X-Captured-At` read on the checklist and signature DELETE routes. Caveat: the worktree's `node_modules` symlinks to the primary checkout, so mobile typecheck/jest and api build/jest ran with a temporary `@tcg/shared` mapping to the worktree dist (reverted, not committed). Known edge: a replayed delete of a photo already gone gets 409 `TICKET_WINDOW_CLOSED` if the window closed in between (the API resolves the ticket before the lookup), so that op waits behind approval (REQ-08 as written). Next: the developer pushes U3; build **U4** (stacked on U3). Open in spec §12: Q8 and Q11 (REQ-13). No unit is blocked.
