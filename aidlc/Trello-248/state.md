# State — Trello-248 Departments & Roles: make the screens work on phones and tablets

**Path:** C · **Branch(es):** `feat/hide-actions-without-permission` (commits `9757b9b90` departments and roles, `200f4e7be` shared header, tabs and projects toggle; local, not pushed) · **Last updated:** 2026-11-16 by Claude Code session (fouzan)

Card: https://trello.com/c/FENqTrZt (created 2026-11-16, In Review, assigned fouzanshakil). No intent.md —
the card text is the capture; its "To confirm" line says it was written as the web app, not the Expo app.

## Phases

- [S] Intent — path C; the card is the capture
- [S] Spec — path C
- [S] Sign-off — path C
- [S] Units — path C
- [-] Build — done and checked locally; staging not checked
- [ ] Analyse — `review-pr` not run
- [ ] Merged — PR #…, not opened
- [ ] Reflect — not run
- [ ] Closed — `close-ticket` not run

## Resume

**Departments & Roles (`9757b9b90`):** permission grid gives the module name the full width on a phone (chips on
a line below, narrower action columns); approver rows (Department full line, Role beside its remove button); boom
pay choice stacks; crane inspection order number under its label; role card Edit Permissions full width beside
its menu; department tabs and New Role button fill the row.
**Shared (`200f4e7be`) — app-wide, see below:** `PageHero` stacks its action buttons full width below `md` and
shows its stats as a wrapping grid below `lg` (values and captions no longer cut off or overlapping);
segmented `SectionTabs` share the bar equally on a phone; the Projects list/grid toggle fills its row.

Checked in headless Chrome at 375, 430, 768 (and 1280 for the header) on the six department screens, the
Dashboard, Quotations, Customers, Projects, Yard Operations: no sideways scroll, screenshots read. Claude in
Chrome could not be sized below 1626px (the window resize does not apply; the app sends `X-Frame-Options: DENY`),
so phone widths were not checked there; desktop width was.

**Shared UI rule:** `apps/web/CLAUDE.md` — a deliberate app-wide change gets its own ticket and PR, lists the
screens it affects, and is approved by Umer Islam. `PageHero`, `SectionTabs` and the Projects toggle change every
screen that uses them; they are in this branch only because the developer asked for them to be fixed "across
all modules". **Next:** split `200f4e7be`'s shared parts into their own PR, with Umer's approval, before pushing.
Not done: touch targets under 44px on the permission toggles (32px) and menu icons; tablet check of every
module header (only a sample was scanned); the stale Notification recipients copy ("use its Notifications
section").

**PR gate:** `.claude/hooks/guard-shared-ui.mjs` (proposal `proposals/2026-11-05-shared-ui-ripple.md`) refuses `gh pr create` when the branch changes `apps/web/src/components/` and the PR text has no "Shared UI changed" section listing the files and their importers — this branch trips it through `page-hero.tsx` and `section-tabs.tsx`.
