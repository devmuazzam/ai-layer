# State — MOBILE-OFFLINE-DELETE-QUEUE reliable offline deletes on mobile and guaranteed S3 cleanup on the API

**Path:** A · **Branch(es):** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u1-outbox-worker` (U1, from `origin/staging`, not pushed); later `feat/MOBILE-OFFLINE-DELETE-QUEUE-u<n>-<slug>`, stacked U2 to U5 · **Last updated:** 2026-10-29 by tcg-executor (U1 built)

## Phases

Markers: `[ ]` not started · `[-]` in progress · `[?]` blocked on a human — name the §12 Q ·
`[x]` done · `[S]` skipped — say why. Never delete a row; paths B and C mark most rows `[S]`.

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (`tcg-elaborator`); updated 2026-10-29 with the developer's answers
- [?] Sign-off — `spec.md` §14; open in §12 (owner Haris): **Q8** (derived acceptance criteria not confirmed) and **Q11** (does the 3-retry rule and badge cover a failed ticket submit; not answered; workaround: queued ops only; keeps REQ-13 open). Answered: Q1 (AI decision D13), Q2, Q3, Q4, Q5, Q6, Q7, Q9, Q10, Q12, Q13; D7 and D11 confirmed
- [x] Units — `units.md` (`tcg-decomposer`); 5 units, stack order U1, U2, U3, U4, U5 (numeric); REQ-13 unassigned (Q11); no unit blocked
- [-] Build — unit by unit; status per unit in the `units.md` ledger (`tcg-executor`); U1 built, U2 to U5 not started
- [ ] Analyse — verdict per unit (`tcg-analyst`)
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

## Resume

**U1 built** on `feat/MOBILE-OFFLINE-DELETE-QUEUE-u1-outbox-worker` (from `origin/staging`), committed locally, **not pushed** (push: `git push -u origin HEAD:feat/MOBILE-OFFLINE-DELETE-QUEUE-u1-outbox-worker`). Delivered: `StorageDeletionJob` model + migration `20261029120000_add_storage_deletion_queue` + `schema.dbml`, `TENANT_SCOPED_MODELS` entry, `StorageDeletionQueueRepository` / `StorageDeletionQueueService` / `StorageDeletionModule`, `AttachmentsRepository.deleteAndEnqueueStorageDeletion`, guard `deleteOrphaned` (so `cleanupReplaced`) enqueues in the row delete's transaction and tries once after commit; guard constructor takes the queue service, `StorageDeletionModule` imported in the five guard-providing modules and `AppModule`. Gates: api lint 0 errors / 667 warnings (= baseline), build pass, test 293 suites / 3419 tests pass. Boot: DI proven (app started, `StorageDeletionModule` initialised, worker fired at +10 s). **Not done:** the migration was NOT applied to the local dev database (the auto-mode classifier refused `prisma migrate deploy` against the shared `tcg_db`), so the boot's worker poll logged `relation "storage_deletion_queue" does not exist` every 10 s and the Demo (S3 failure, row `PENDING` to `COMPLETED`/`FAILED`) has not been run; `tcg-prisma-guardian` could not be spawned from the executor (no Agent tool), so its checklist was run by hand, no findings. Next: the developer applies the migration locally (`pnpm db:migrate`) and runs the U1 Demo; reviews D3/D13 and the AI decisions in the PR; then build **U2** (stacked on U1's branch). Open in spec §12: Q8 and Q11 (REQ-13). No unit is blocked.
