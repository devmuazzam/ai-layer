# State — Trello-178 Hide Create and Edit buttons without the permission

**Path:** C · **Branch(es):** `feat/hide-actions-without-permission` (local, rebased onto `origin/staging` `f0676b6b3` on 2026-11-16, not pushed, no PR) · **Last updated:** 2026-11-16 by Claude Code session (fouzan)

## Phases

- [S] Intent — path C; `intent.md` captures the card
- [S] Spec — path C
- [S] Sign-off — path C
- [S] Units — path C
- [-] Build — web done and checked locally; mobile not started
- [ ] Analyse — `review-pr` not run (a manual branch review was done 2026-11-16, see below)
- [ ] Merged — PR #…, not opened
- [ ] Reflect — not run
- [ ] Closed — `close-ticket` not run

## Resume

Web: every module's Create / Add / Edit / Archive / upload control follows the role's grant. Commits
(post-rebase): `2440fd134` shared `Can` gate + customers, yards, agencies, vendors, price lists, POs, parts,
billing codes, craft codes · `421cf5a71` employees · `08bac8424` quotations, assets, categories, sub-categories,
tools, projects, permits, plans, POs, price lists, employees, yards · `28bb679cf` departments and roles ·
`2631f25d3` quotation detail actions · `971faf48d` asset and tool detail · `b569c25e1` yard tools panel ·
`b493d0a8d` notes and comments read-only · `7e5890e7b` project and job pages, read-only attachments.
Checked locally: 13 scripted personas (`ROLE-EDITOR-PERMISSIONS/state.md` has the matrix), headless Chrome and
Claude in Chrome, lists, detail pages and direct create / edit URLs. Gates 2026-11-16: web tests 1051/1051,
eslint 0 errors on the 126 changed web files, API departments / attachments / strategy / seed-data jest 92/92.

**Next:** (1) mobile pass — each Expo screen, same module and action as the API, mobile routes also accept
the `mobile-*` module; (2) the card's open question — Delete / Approve / Export; (3) check on staging with a
role that has the permission and one that does not, as the card requires; (4) `review-pr`, PR with the
AI-decisions table (`ROLE-EDITOR-PERMISSIONS/pr-ai-decisions.md`).

**Not checked:** staging; mobile; the Playwright suite; DAS and yard drag-and-drop for roles without edit (the
API refuses it); plan Submit / Approve / Reject buttons.
**Comment posted on the card 2026-11-16** with the web status and the mobile gap.
