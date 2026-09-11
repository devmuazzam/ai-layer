---
title: Progress Tracking actions are contact links and the ticket's comment thread; Send Reminder is deferred — decision
source: decision/Syed Haris
decided: 2026-09-11
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing SCRUM-PROGRESS; picked this
  option in a working session on 2026-09-11 (verbatim in `.ai/aidlc/SCRUM-PROGRESS/intent.md` →
  Session decisions D4). He is **not** the client-side product owner. No owner is declared for
  projects-jobs; the one the vault names is **Lisette Anzaldo** (Dispatch Manager,
  `admin/engagement-directory-and-org-charts.md`), owner on 29 of 34 `projects-jobs/gaps.md`
  entries. **Lisette Anzaldo should ratify it.** `status: reference` for that reason. Same basis
  as the 2026-09-10 SCRUM-PENDING notes.
status: reference
conflicts_with: []
superseded_by: decisions/2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md
resolves: [SCRUM-PROGRESS/intent.md#d4--actions]
jira: []
tags: [module/projects-jobs, module/field-ops, module/dispatch, kind/decision, ticket-workflow, notifications, permissions-roles]
---

# Contact links and the ticket's comments; no reminders yet

Answers D4 of `.ai/aidlc/SCRUM-PROGRESS/intent.md` → *Session decisions*.

> **Chat clause superseded 2026-09-11** by
> `2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md`: the design's Chat button
> renders disabled, and the web neither reads nor posts ticket comments. The Contact clause and the
> Send Reminder deferral below still stand.

## Decision

> **Q:** What should the design's action buttons do (Send Reminder via Email, Contact, Chat)?
> **Chosen:** *Contact + comments (Recommended)* — "Contact is a call/email link from the employee
> record. Chat opens the ticket's existing Comments thread, the one the crew already see on
> mobile, and the web can read and post to it. Send Reminder is left out for now."

**Not chosen:** *Read-only* · *All three* (adds Send Reminder as a push notification — "needs a
new notification type") · *No actions*.

In short:

- **Contact** — call and email links built from the employee record.
- **Chat** — the ticket's existing `TicketComment` thread, the one crew see on mobile. It is
  readable and postable from the web. No new chat system.
- **Send Reminder** — deferred.

## Why

- The thread already exists and crew already use it on mobile
  (`apps/mobile/components/field/ticket-comments-sheet.tsx`). Reusing it adds a web read and a web
  post, not a new channel.
- A push reminder "needs a new notification type", per the option not chosen.

## What is weak about this attribution

- **The decider of record is Syed Haris**, named and dated; binding on the build. Developer/owner,
  not TCG's dispatch owner. **Lisette Anzaldo should ratify it.**
- **Deferring reminders runs against a BRS line.** `brs.md` BRS-NOTIF-002 *Incomplete Ticket
  Reminders* is marked "✓ Confirmed" (unverified, title only). The daily view was also described
  to TCG on 2026-08-13 as the place to "create any action on top of" flagged and incomplete
  tickets (`meetings/transcripts/2026-08-13-payroll-process.md` ~:312 — a record, not a
  commitment). D4 defers reminders. It does not reject them.

## What this does NOT settle

- **Who may post, and who may read another employee's ticket at all.** Open in intent §8: jobs
  routes carry no `@RequirePermission`, and a plain `USER` is granted `jobs:view` by default. The
  nearest vault line is FR-TCG-FOP-001 FR-FOP-031, *"Authorised personnel (e.g. supervisors) may
  review ticket progress before submission, subject to role permissions"*
  (`field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-031-live-ticket-visibility.md`
  — unverified, in the field-ops conflict set). It says permissions apply. It names no role.
- **Crew are not notified.** A comment posted from the web shows up for crew on mobile, but with no
  push and no notification. The app fetches comments only while the comments sheet is open
  (`useTicketComments(ticketId, open)`, `ticket-comments-sheet.tsx`:53). Crew see a dispatcher's
  message the next time they open the sheet. Nobody has said whether that is acceptable.
- **Posting on a Completed job.** `decisions/2026-08-25-completed-job-view-only.md` (verified)
  makes a Completed job "view-only across all Project → Jobs tabs". Read literally, that includes
  a comment box on this tab. D4 does not say.
- Whether the web thread refreshes on its own. No event fires on comment writes (intent
  Appendix C).
- What a reminder would say, to whom, and by which channel, if it is ever picked up.

## Effect on the vault

- **No vault body edited, no frontmatter flipped.** No candidate documents conflicted.
- The permission question belongs in `.ai/aidlc/SCRUM-PROGRESS/spec.md` §12. Intent §8 already
  carries it as `OPEN`. This pass did not write it.
- **`projects-jobs/INDEX.md` → *Decisions that bind this module* gained a line for this note**, on
  explicit instruction and outside `tcg-scrum`'s normal write scope.
