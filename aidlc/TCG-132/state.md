# State — TCG-132 Create Permit modal on All Permits

**Path:** A · **Branch(es):** feat/tcg-132-u1-permit-create-fields … feat/tcg-132-u16-review-fixes (stacked, local; not pushed/merged) · **Last updated:** 2026-11-03 (prototype re-exploration close-out)

## Phases

Markers: `[ ]` not started · `[-]` in progress · `[?]` blocked on a human — name the §12 Q ·
`[x]` done · `[S]` skipped — say why. Never delete a row; paths B and C mark most rows `[S]`.

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (`tcg-elaborator`)
- [x] Sign-off — `spec.md` §14: Q1–Q5 answered by Syed Haris 2026-10-29 (relayed by coordinator), marked done at the coordinator's instruction. C1 done 2026-10-29 (decision note, vault frontmatter, gaps); still open: INDEX.md rows and the developer review of §11b/§11c
- [x] Units — `units.md` (`tcg-decomposer`, 2026-10-29): U1-U7, 8/8 REQs covered; U8–U10 added during build; U11–U16 added after the prototype re-exploration
- [x] Build — U1–U16 built locally on stacked branches feat/tcg-132-u1-… → feat/tcg-132-u16-review-fixes
- [x] Analyse — PR review 2026-10-29 (tcg-scrum §12 Q7–Q14; review fixes in U10). Prototype re-exploration 2026-10-30: 88-row gap analysis, Q15–Q18 answered by Haris (Addendum 2026-11-03), review fixes in U16. AI decisions D20–D26 and D28–D48 await developer review (spec §14 box unticked)
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md` (`tcg-reflector`)
- [ ] Closed — `close-ticket` run, overlay pushed

## Units added after the prototype re-exploration (2026-10-30 to 2026-11-03)

- **U11** `feat/tcg-132-u11-permit-api-lookups`: API lookups and rules. Type and sub-category filters, vendor in list search, received not before submitted, duplicate-annual 409 removed (Q17), existing `duplicates.spec.ts` updated. Includes U3 cherry-picked in.
- **U12** `feat/tcg-132-u12-modal-reactions`: the modal and edit page react like the prototype. Valid to notes, Agency/City rules, open POs only, type switch keeps values, opens the new permit after create (Q15, Q16, D34, D36, D37, D39).
- **U13** `feat/tcg-132-u13-annual-banners`: the Asset ⓘ popover and the annual banners (D35, D41, D42, D46).
- **U14** `feat/tcg-132-u14-detail-tracker-polish`: detail and tracker polish. Asset in the title and Resource, Track Permits type filter with Annual, KPIs follow the filter (D38, D47, D48).
- **U15** `feat/tcg-132-u15-das-annual-link`: link an annual permit from the DAS All Permits dialog (Q18, D43).
- **U16** `feat/tcg-132-u16-review-fixes`: review fixes. Received-date guard on approve, business-day compare, UUID sub-category filter, safer job permit link (D44, D45).

## Resume

U1–U16 built locally; review fixes in U16 (feat/tcg-132-u16-review-fixes). Spec §0: 18 questions raised, 0 open. Q1–Q7, Q9, Q13 and Q15–Q18 are resolved by Haris; Q8, Q10–Q12 and Q14 await developer review. Before merge, a developer reviews §11b D20–D26 and D28–D48 (needs developer: yes), above all D20 with D43, D25, D26, D31, D36, D42 and D45. A developer also confirms the migration ordering against staging (§13b). Q14 stays a product question at projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete, and Q17's vault counterpart stays open at projects-jobs/gaps.md#permit-rules-the-e2e-suite-asserts-with-no-written-source--pr-488 (d). Follow-ups are listed in spec §13b. Then open the PRs, run Reflect, close.
