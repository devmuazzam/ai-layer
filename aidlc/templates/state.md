# State — SCRUM-### <feature name>

> Written to `.ai/aidlc/SCRUM-###/state.md`. **Where this ticket is in the loop**, so the next
> session — or the next developer — resumes from one file instead of rebuilding it from
> `spec.md` §12, `units.md` and `processed.log`.
>
> Created from this template by whoever opens the ticket folder (the elaborator on path A).
> Every phase agent, and `close-ticket`, updates it **once, at the end of its run**: mark its
> row, rewrite **Resume**, set **Last updated**.
>
> **Progress only.** Per-unit status stays in the `units.md` ledger and open questions in
> `spec.md` §12 — this file points at them and never copies them, so it cannot drift from them.

**Path:** A | B | C · **Branch(es):** `<type>/SCRUM-###-u<n>-<slug>` · **Last updated:** YYYY-MM-DD by *agent or person*

## Phases

Markers: `[ ]` not started · `[-]` in progress · `[?]` blocked on a human — name the §12 Q ·
`[x]` done · `[S]` skipped — say why. Never delete a row; paths B and C mark most rows `[S]`.

- [ ] Intent — `intent.md`
- [ ] Spec — `spec.md` (`tcg-elaborator`)
- [ ] Sign-off — `spec.md` §14 checked by *named developer*
- [ ] Units — `units.md` (`tcg-decomposer`)
- [ ] Build — unit by unit; status per unit in the `units.md` ledger (`tcg-executor`)
- [ ] Analyse — verdict per unit (`tcg-analyst`)
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

## Resume

*One paragraph, rewritten — not appended — at the end of every run: what was last done, what
comes next, and what blocks it (by §12 Q number or unit id). The next session reads this
first.*
