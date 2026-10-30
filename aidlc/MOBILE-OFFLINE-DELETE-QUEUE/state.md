# State — MOBILE-OFFLINE-DELETE-QUEUE reliable offline deletes on mobile and guaranteed S3 cleanup on the API

**Path:** A · **Tip branch (merged 2026-10-30 as PR #985, `819483fdb`): `feat/MOBILE-OFFLINE-DELETE-QUEUE-u6-synced-tick-v2` — held U2 to U8; the five outbox-version branches are deleted from `origin`.** · **Branch(es) — the per-unit v2 branches it was built from (revised 2026-10-30, D20: outbox dropped, U1 cut), local only, not pushed:** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u2-delete-sites-v2` (U2, from `origin/staging`, PR base `staging`); `feat/MOBILE-OFFLINE-DELETE-QUEUE-u3-mobile-delete-op-v2` (U3, on U2); `feat/MOBILE-OFFLINE-DELETE-QUEUE-u4-attach-file-queue-v2` (U4, on U3); `feat/MOBILE-OFFLINE-DELETE-QUEUE-u5-failed-sync-badge-v2` (U5, on U4). **Superseded, already pushed, do not merge:** `feat/MOBILE-OFFLINE-DELETE-QUEUE-u1-outbox-worker`, `-u2-delete-sites`, `-u3-mobile-delete-op`, `-u4-attach-file-queue`, `-u5-failed-sync-badge` (the outbox stack). · **Last updated:** 2026-10-30 (U6 to U8 added on the tip branch)

## Phases

Markers: `[ ]` not started · `[-]` in progress · `[?]` blocked on a human — name the §12 Q ·
`[x]` done · `[S]` skipped — say why. Never delete a row; paths B and C mark most rows `[S]`.

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (`tcg-elaborator`); updated 2026-10-29 with the developer's answers
- [?] Sign-off — `spec.md` §14 was never completed (1 of 12 boxes ticked at merge). Open in §12 (owner Haris): **Q8** (derived acceptance criteria) and **Q16** (which HTTP statuses count as server-refused). **Q11** answered in part (D22)
- [x] Units — `units.md` (`tcg-decomposer`); 5 units, stack order U1, U2, U3, U4, U5 (numeric); REQ-13 built in U7, REQ-14 in U6, REQ-15 in U8 (2026-10-30); no unit blocked
- [x] Build — U2 to U8 built and merged (PR #985); U1 cut
- [x] Analyse — `tcg-analyst` verdicts are in the unit blocks of `units.md` (U2 MERGE; U3 to U5 findings fixed or listed); U6 to U8 were developer-directed follow-ups found on a device and were not analysed
- [x] Merged — PR #985 (2026-10-30, merge `819483fdb` on `staging`): U2 to U8 in one combined PR from `feat/MOBILE-OFFLINE-DELETE-QUEUE-u6-synced-tick-v2`; U1 was cut (D20), so nothing of the outbox shipped
- [x] Reflect — `reflection.md` (`tcg-reflector`), 2026-10-30: 6 spec defects, 5 executor defects; 11 rows appended to `reflections/INDEX.md` (two escalated: invented-value, stale-ui-state); 12 rule changes proposed for Haris, none applied
- [x] Closed — `close-ticket` run 2026-10-30; the items still open are listed under Resume

- **U2 scope note (2026-10-29):** U2 covers six delete sites in all with U1 (the generic `DELETE /attachments/:id` was folded into U2, commit `7d826e40e`; U2 = `3626d1295` + `7d826e40e`). `units.md` U2 now says so and the Ledger row, Outcome, Slice contents, Ripple and Demo include it.

## Resume

**closed — shipped as PR #985 (2026-10-30). Items this close left open, each with an owner:**

- **D24, owner Haris:** the fix that makes a Pre-Trip, Post-Trip or JSA re-sign delete the signature image it replaces (`c165917b1`) is **not in staging**: it was reset off the branch at 16:09:45 and is on no branch (the object still exists). Staging still leaves an orphan signature image on every checklist re-sign. Re-apply with `git cherry-pick c165917b1` or drop it.
- **Q8 and Q16, owner Haris:** unanswered. Q16 (which statuses count toward the 4-send limit) is uncommitted in the working copy of `spec.md`. Q11 is answered in part (whether a failed submit is counted against the limit is not decided).
- **Never verified:** U8 (category at upload) was not run against a rebuilt API; U2's transaction rollback path was not run against Postgres; the 500 on the v1 checklist photo delete was never root-caused; the cross-tenant Attach File delete now answers 204 instead of 403 (U2 analyser note) and the mechanism was not confirmed.
- **Outside this ticket:** `apps/api/src/main.ts` imports `express`, which `apps/api/package.json` does not declare (G5, separate fix).
- **Reflection:** 12 proposed rule changes (R1 to R12) wait for Haris in `reflection.md` and `reflections/INDEX.md`; none applied.
- **Overlay:** `docs/MOBILE-OFFLINE-DELETE-QUEUE` needs its PR into overlay `main` (which has moved).

## Drift notes

- **Delete sites are six (developer decision, session 2026-10-29, status `reference`):** the generic admin route `DELETE /attachments/:id` (`AttachmentsService.delete`) was folded into U2 at `7d826e40e`. Resolved 2026-10-30: `spec.md` (REQ-05, D7, §11a/§11c), `units.md` (U2) and the outbox decision note now all say six.

