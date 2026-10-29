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

**U4 built and pushed** on `feat/MOBILE-OFFLINE-DELETE-QUEUE-u4-attach-file-queue` (stacked on U3's branch; PR targets U3's branch). After the analyst's MERGE AFTER FIXES verdict, four fix commits sit on top of the pushed tip `1a58c4397`, **local, not pushed**: `4f9c2fb2a` (one `isReservedLedgerKey` helper for both reserved ledger keys: `draftHasLocalProgress`, `derivedOps`, `reportDrainFailure`), `1af490ea5` (a queued upload refused for good with 400/413/415/422 is dropped with the server's message as a toast; a missing local file is released with a warn log), `e6b4d6456` (48 px remove button on a Pending sync row). Push: `git push origin HEAD:feat/MOBILE-OFFLINE-DELETE-QUEUE-u4-attach-file-queue`. F2 confirmed earlier: the sheet only mounts under the open ticket's screens, so the flow store holds the draft; no second queue. Delivered earlier: API `clientUploadId` and `X-Captured-At` on the Attach File upload and delete routes; `__attachFileUploads` queue with `uploadAttachment` ops, `deleteAttachment` target `attachments`, per-file acknowledgment, "Pending sync" rows, cancel-both. Gates ran with throwaway tsconfig and CLI jest mapping (no repo config edits). Next: the developer pushes the fixes; build **U5** (stacked on U4). Open in spec §12: Q8 and Q11 (REQ-13). No unit is blocked.
