---
title: Progress Tracking reads need jobs:view, comment posts need jobs:edit — decision
source: decision/Syed Haris
decided: 2026-09-11
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing SCRUM-PROGRESS; picked this
  option in a working session on 2026-09-11, answering `.ai/aidlc/SCRUM-PROGRESS/spec.md` §12 Q1.
  He is **not** the client-side product owner. No owner is declared for projects-jobs; the one the
  vault names is **Lisette Anzaldo** (Dispatch Manager, `admin/engagement-directory-and-org-charts.md`).
  **Lisette Anzaldo should ratify it.** `status: reference` for that reason. Same basis as the four
  earlier 2026-09-11 SCRUM-PROGRESS notes.
status: reference
conflicts_with: []
resolves: [SCRUM-PROGRESS/spec.md#q1]
jira: []
tags: [module/projects-jobs, module/field-ops, module/dispatch, kind/decision, permissions-roles, ticket-workflow, signatures]
---

# Reads need jobs:view, posts need jobs:edit

Answers Q1 of `.ai/aidlc/SCRUM-PROGRESS/spec.md` §12. Unblocks REQ-19 and REQ-14–17.

## Decision

> **Q:** Who may read another crew member's ticket progress, and who may post a comment on it?
> **Chosen:** *jobs:view / jobs:edit (Recommended)* — "Read needs jobs:view, the same audience as
> the job detail page. Posting a comment needs jobs:edit. No admin setup is needed. Field-worker
> accounts with no department role can read it, just as they can already read the job page."

**Not chosen:** *dispatch:view / dispatch:edit* ("Tie it to the Dispatch module instead…") ·
*New progress-tracking module* — the spec's own proposal, REQ-19 workaround ("…every existing
dispatcher is locked out until an admin grants it in their department role").

No new permission key. The existing `@RequirePermission(module, level)` decorator
(`apps/api/src/decorator/require-permission.decorator.ts`) carries it: `('jobs', 'view')` on the
reads, `('jobs', 'edit')` on the comment post.

## Why

The context shown with the question (`packages/shared/src/constants/permissions.ts`):

- A `USER` with no department role gets `view` on every module outside `USER_RESTRICTED_MODULES`,
  and `jobs` is not on that list (`USER_DEFAULTS`). So plain users can read but not post.
- A user with a department role gets `none` for any module the role leaves out
  (`resolveEffectiveLevel`). Admins bypass.
- So nobody needs a new grant. A new key would have locked every existing dispatcher out until an
  admin edited their department role.

## What is weak about this attribution

- **The decider of record is Syed Haris**, named and dated; binding on the build. **Lisette
  Anzaldo should ratify it.**
- **It accepts the exposure `intent.md` §8 warned about:** "gating on `jobs:view` alone would let
  a field-worker account read every colleague's ticket." That includes the captures: customer
  signatures and identity photos (`TicketSignature.identityPhotoAttachmentId`,
  `apps/api/prisma/schema.prisma`). The decider saw this and accepted it as the same audience as
  job detail.
- The nearest vault line, FR-TCG-FOP-001 FR-FOP-031 ("Authorised personnel (e.g. supervisors) may
  review ticket progress…, subject to role permissions",
  `field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-031-live-ticket-visibility.md`,
  unverified, in the field-ops conflict set), reads narrower than this decision.

## What this does NOT settle

- **It is not exactly the job page's audience.** `GET /jobs/:jobId` has no `@RequirePermission`
  (spec §11a), and the web does not gate Projects on `jobs`. So a user whose department role
  leaves out `jobs` can open the job but gets a 403 on this tab. Whether the job page itself
  should be gated is outside this decision.
- **Posting on a Completed job.** `decisions/2026-08-25-completed-job-view-only.md` (verified)
  makes a Completed job "view-only across all Project → Jobs tabs". The build's default is to
  refuse the post on a Completed job whatever the caller's `jobs` level, and the web hides the
  composer when the job is read-only. That is the implementation reading the verified note
  literally. This answer did not decide it.
- Crew get no notification when someone posts from the web
  (`decisions/2026-09-11-progress-tracking-actions-are-contact-links-and-ticket-comments.md`).
  Still open.

## Effect on the vault

- **No vault body edited, no frontmatter flipped.** No candidate documents conflicted.
- `SCRUM-PROGRESS/spec.md` §12 Q1 is marked resolved. REQ-14–17 and REQ-19 were updated in the
  same pass, on explicit instruction and outside §12.
- **`projects-jobs/INDEX.md` → *Decisions that bind this module* gained a line for this note**, on
  explicit instruction and outside `tcg-scrum`'s normal write scope.
