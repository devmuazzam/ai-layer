# State — Trello-246 Employees: a role with only View access could change an employee's picture, and edit-only roles were refused

**Path:** B · **Branch(es):** `feat/hide-actions-without-permission` (commit `46ff517b0`, local, not pushed) · **Last updated:** 2026-11-16 by Claude Code session (fouzan)

Card: https://trello.com/c/linvo4N7 (created 2026-11-16, In Review, assigned fouzanshakil). No intent.md — the
card is the capture and the developer's direction is recorded below.

## Phases

- [S] Intent — path B; the bug is the deviation
- [S] Spec — path B
- [S] Sign-off — path B
- [S] Units — path B
- [x] Build — repro, fix, check (below)
- [ ] Analyse — `review-pr` not run
- [ ] Merged — PR #…, not opened
- [ ] Reflect — not run
- [ ] Closed — `close-ticket` not run

## Repro (2026-11-13, local TCG-DEFAULT tenant, Claude in Chrome)

An Edit-only user opens the employee edit form, sees "Upload photo", uploads — the API answers 403
`You cannot change this profile picture`. Cause: `attachment-photos.service.ts` decided an employee's picture
by `EMPLOYEE_PHOTO_ROLES` (portal admins only), shipped as PHOTO-REUSE U2 (TCG-241 U13), while the form showed
the control to anyone who can open it.

## Developer direction (2026-11-13, in session)

"A user is able to upload an employee's picture when that user has employee edit access, but they shouldn't
be able to do the same when they have view access only." — the rule follows the Employees permission. This is
a developer direction, not a TCG answer; recorded as an AI decision in the PR table, status "confirm".

## Fix

`PHOTO_ACCESS.EMPLOYEE.change = { anyOf: [employees create, employees edit] }`; the admin-only branch and
`EMPLOYEE_PHOTO_ROLES` are removed; portal admins still pass any web module's check. Web needed no change.

## Check (what was run)

Corrupt-PNG upload (no S3 write): view and archive-only users 403; create and edit users pass the access check
and reach the file-type error. In Chrome the Edit user now gets the file-type error instead of the 403; the
view-only user cannot open the edit form and the detail page has no upload. API jest 92/92 on 2026-11-16.
**Not run:** a real upload (writes to the S3 bucket named in the local env); staging.

## Resume

Done locally. Next: staging check with an Edit role and a View role; PR. **Stale docs to fix:**
`.ai/claude/contexts/patterns.md` P3 row EMPLOYEE says "ADMIN only", and `TCG-241/spec.md` line 318 and
`TCG-241/state.md` U13 say the same — `patterns.md` is Haris-only, so the proposed text is in
`aidlc/proposals/2026-11-16-employee-photo-follows-employees-permission.md`.
