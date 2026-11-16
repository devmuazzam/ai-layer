# State — Trello-247 Role editor decisions (linked View grants, hidden modules, per-action toggles)

**Path:** A (G1) · **Branch(es):** `feat/hide-actions-without-permission` — the build lives there, see `../ROLE-EDITOR-PERMISSIONS/state.md` · **Last updated:** 2026-11-16 by Claude Code session (fouzan)

## Phases

- [x] Intent — `intent.md`
- [?] Spec — not written. Blocked on the three answers in `vault/admin/gaps.md` → *Role editor behaviour nobody specified*; no `spec.md` until TCG answers, so §12 is that gap entry
- [ ] Sign-off
- [S] Units — the build already exists as commits on the umbrella branch; units are written only if an answer changes it
- [-] Build — built on the developer's reading, unconfirmed
- [ ] Analyse
- [ ] Merged
- [ ] Reflect
- [ ] Closed

## Resume

The editor is built as: View / Create / Edit / Archive toggles per module; Create, Edit and Archive imply View;
ticking a module the first time also gives View on the modules it links to (one hop, `+N linked` chip, unticking
leaves them); modules and actions nothing enforces are hidden, stored values kept; grant limits; web portal
access derived from permissions in the editor and in the API. All three are G1 — nobody at TCG has seen them.
The question is filed once, in the vault gap entry (updated 2026-11-16 to name this card). Hidden fields (#195)
is the fourth question and is not built.

**Next:** put the three questions to TCG's role owner (the gap's owner is not named — `tcg-scrum` to find it);
on answers, either close the card with a `vault/decisions/` note from `tcg-scrum`, or write `spec.md` and units
for the change. **Blocks:** TCG's answers only. **AI decisions table:** `../ROLE-EDITOR-PERMISSIONS/pr-ai-decisions.md`.
