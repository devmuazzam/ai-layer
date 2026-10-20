# State — TCG-237 One role per employee: replace Employee Type with departments and roles

> Where this ticket is in the loop. Progress only: per-unit status stays in the `units.md`
> ledger and open questions in `spec.md` §12.

**Path:** A · **Branch(es):** none yet · **Last updated:** 2026-10-20 by tcg-decomposer

## Phases

- [x] Intent — `intent.md`
- [?] Spec — `spec.md` (`tcg-elaborator`) — written and revised against the 2026-10-20 template; 21 questions open in §12
- [?] Sign-off — `spec.md` §14 checked by *named developer* — blocked on Q1–Q21 (21 open) and the empty §11b rows D1–D11
- [x] Units — `units.md` (`tcg-decomposer`) — 20 stacked units; U4, U13, U14, U17 (union part), U19 blocked on Q26–Q31
- [ ] Build — unit by unit; status per unit in the `units.md` ledger (`tcg-executor`)
- [ ] Analyse — verdict per unit (`tcg-analyst`)
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

## Resume

Decomposed 2026-10-20 into 20 stacked units (`units.md`); nothing is built. First to build: **U1** (remove department from assets; independent) and **U2** (role editor "Dispatchable"; independent of U1) — both can start from `origin/main`. U3 follows U2. **U4 (the data migration) is blocked** on new questions **Q26** (what the fifteen old departments, roles and unmapped-type rows become) and **Q28** (department/role codes, notification codes); **U13** on Q29, **U14** on Q23 + Q31, **U17**'s union check on Q30, **U19** on Q27. Q5 (role permissions, workaround = editable templates), Q6 (out of scope) and Q23 stay open. Before U4 is built: TCG should see the Q1 role list and the Q3 mapping (developer answers, not yet challenged), and a production-copy dry run is needed. Developer to confirm: the U8 size-exception, the U8→U11 transitional double write, and a possible flag for U17/U18.
