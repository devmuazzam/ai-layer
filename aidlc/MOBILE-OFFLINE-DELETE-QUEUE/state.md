# State — MOBILE-OFFLINE-DELETE-QUEUE reliable offline deletes on mobile and guaranteed S3 cleanup on the API

**Path:** A · **Branch(es):** none yet (`feat/MOBILE-OFFLINE-DELETE-QUEUE-u<n>-<slug>`, stacked U1 to U4) · **Last updated:** 2026-10-29 by tcg-elaborator (second pass: developer answers folded in)

## Phases

Markers: `[ ]` not started · `[-]` in progress · `[?]` blocked on a human — name the §12 Q ·
`[x]` done · `[S]` skipped — say why. Never delete a row; paths B and C mark most rows `[S]`.

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (`tcg-elaborator`); updated 2026-10-29 with the developer's answers
- [?] Sign-off — `spec.md` §14; open in §12 (owner Haris): **Q8** (derived acceptance criteria not confirmed) and **Q11** (does the 3-retry rule and badge cover a failed ticket submit; not answered; workaround: queued ops only; keeps REQ-13 open). Answered: Q1 (AI decision D13), Q2, Q3, Q4, Q5, Q6, Q7, Q9, Q10, Q12, Q13; D7 and D11 confirmed
- [x] Units — `units.md` (`tcg-decomposer`); 5 units, stack order U1, U2, U3, U4, U5 (numeric); REQ-13 unassigned (Q11); no unit blocked
- [ ] Build — unit by unit; status per unit in the `units.md` ledger (`tcg-executor`)
- [ ] Analyse — verdict per unit (`tcg-analyst`)
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

## Resume

Units revised 2026-10-29 (third pass, `units.md`) after Q13 was answered (option A: the Attach File queue is a reserved key in the draft's sync ledger, D9 confirmed). Stack order **U1, U2, U3, U4, U5**, each PR targeting the previous unit's branch: U1 outbox model, worker and the `deleteOrphaned`/`cleanupReplaced` path; U2 the remaining delete sites + D11 + `ATTACHMENT_IN_USE`; U3 mobile `deleteAttachment` op (cancel-both, 409 split, sweep, header read on two routes); U4 Attach File offline queue (executor risk: the sheet gets only a ticket id and sits outside the flow store, so confirm a draft is reachable or creatable, else stop and raise a §12 question, never a second queue); U5 retry counter, stop rule, "Sync failed — tap to retry" badge, tap with `isApiReachable()` and a `syncOnline`-free single-ticket drain. Nothing built. Next: build **U1** from `origin/staging` (not `main`: PR #958 is only on staging) after Haris reviews D3/D13 and `tcg-prisma-guardian` runs. Open in spec §12: Q8 (derived acceptance lines, sign-off) and Q11 (REQ-13, failed submit; workaround queued ops only). No unit is blocked.
