# State — TCG-237 One role per employee: replace Employee Type with departments and roles

> Where this ticket is in the loop. Progress only: per-unit status stays in the `units.md`
> ledger and open questions in `spec.md` §12.

**Path:** A · **Branch(es):** none yet · **Last updated:** 2026-10-20 by tcg-elaborator

## Phases

- [x] Intent — `intent.md`
- [?] Spec — `spec.md` (`tcg-elaborator`) — written and revised against the 2026-10-20 template; 21 questions open in §12
- [?] Sign-off — `spec.md` §14 checked by *named developer* — blocked on Q1–Q21 (21 open) and the empty §11b rows D1–D11
- [ ] Units — `units.md` (`tcg-decomposer`)
- [ ] Build — unit by unit; status per unit in the `units.md` ledger (`tcg-executor`)
- [ ] Analyse — verdict per unit (`tcg-analyst`)
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

## Resume

Elaboration is done for now and nothing is decomposed or built. The spec has 16 requirements: 2 verified (REQ-04, REQ-09), 14 open — 6 outright, the rest sourced but open on Edges or on a sole-unverified confirmation (Q9 for REQ-06, Q17 for REQ-11). Next: the owners answer the lettered questions in §12 (Q1, Q3, Q5 and Q12 are free answers; most others take a letter) and a developer picks D1–D11 in §11b; `tcg-scrum` then records decisions and flips Status. Only after that is the spec re-read against the ticket, §14 signed, and `tcg-decomposer` run. Largest blockers: Q1 (role list), Q3 (type → role mapping), Q15 (new tenants), Q13 (historical records). Nothing has been implemented.
