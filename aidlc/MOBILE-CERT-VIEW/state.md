# State — MOBILE-CERT-VIEW View and download certificates (mobile)

**Path:** A · **Branch(es):** `feat/MOBILE-CERT-VIEW-u1-view-download` (worktree `.worktrees/mobile-cert-view`), `feat/MOBILE-CERT-VIEW-u2-mobile-states` (worktree `.worktrees/mobile-cert-view-u2`) · **Last updated:** 2026-11-10 by Claude Code

## Phases

- [x] Intent — `intent.md`
- [x] Spec — `spec.md` (`tcg-elaborator`)
- [x] Sign-off — `spec.md` §14 checked by haris, 2026-11-10
- [x] Units — `units.md` (`tcg-decomposer`)
- [x] Build — `tcg-executor` (U1 76c675a90 + tiebreak 8bc848789, U2 c3fb9b2b5)
- [x] Analyse — `tcg-analyst`: U1 and U2 both ship with follow-ups (see Resume)
- [ ] Merged — PR #…
- [ ] Reflect — `reflection.md`
- [ ] Closed — `close-ticket` run, overlay pushed

## Resume

Both units built, analysed and pushed 2026-11-10 (no PR yet). U1 `feat/MOBILE-CERT-VIEW-u1-view-download`: 76c675a90 (own-row link) + 8bc848789 (deterministic tiebreak for equal-expiry / both-null ties, from the analyst's finding). U2 `feat/MOBILE-CERT-VIEW-u2-mobile-states`: c3fb9b2b5. Gates run by Claude after the last change: api lint 0 errors, api build pass, `me` jest 4/4; mobile typecheck pass, lint 0 errors, jest certifications+menu 28/28. Not run: api typecheck/full suite, mobile build, U1 two-attachment demo against a database, rendering. REQ-05 limit: only a 404 from `/attachments/:id/links` shows "This document is no longer available"; a deleted S3 object gives the generic toast (expo-file-system puts the status only in the message string). Wording approved by haris 2026-11-10. Next: open two PRs targeting staging (independent), real-phone test (card with document, without, expiring without, deleted file), then `close-ticket`. Follow-up: sibling open-file buttons (spec §11c).
