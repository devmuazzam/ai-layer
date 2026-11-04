---
title: "Late and incomplete tickets — 24h window, approval flow, audit trail — decision"
source: decision/Syed Haris (CodingCops) — developer direction in Claude Code session, 2026-10-15/16
decided: 2026-10-16
decided_by: >-
  Syed Haris (CodingCops, syed.haris@codingcops.com). Decided L2–L18 on 2026-10-15 and
  2026-10-16 in a Claude Code planning session, point by point on Melissa McNutt's provisional
  Teams answers (decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md,
  status: reference). Where Haris's answer differs from hers, his stands until TCG ratifies or
  supersedes it. L5 reverses decision 2026-09-30 E2 (developer-answers-multi-day-and-flagged-entry-gaps.md).
status: reference
conflicts_with: []
resolves:
  - field-ops/gaps.md#late-and-incomplete-tickets--where-the-24-hour-window-starts-what-it-allows-and-how-reminders-are-anchored
  - payroll/gaps.md#who-may-complete-or-correct-a-ticket-on-a-workers-behalf-and-who-approves-a-late-or-post-submit-edit--manager-or-payroll
related_decisions:
  - 2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md
  - 2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md
  - 2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md
  - 2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md
jira: []
tags: [module/field-ops, module/payroll, kind/decision, ticket-workflow, time-tracking, permissions-roles, notifications, offline, data-model]
---

# Late and incomplete tickets — the decision

Developer direction from Haris (CodingCops), deciding each point of the late-ticket and
incomplete-ticket flow. This is `status: reference` — a developer direction, not a TCG
product decision. Melissa McNutt's provisional answers
(decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md)
are the context; where Haris differs, his answer governs the build.

## Decisions

### L2 — Completion window

The ticket's **scheduled end + 24h**. The scheduled end is computed when read, from the
per-day job's `JobScheduleInterval` (`estimatedEndTime` on `estimatedEndDate`, using the
shift-2 fields for shift 2), in business time. Inside the window the worker can complete
**every step** and enter actual times on the original date.

### L3 — Post-window approval

After the window, the worker raises an in-app request with one reason. Any
`payroll-admin:edit` holder (Payroll Admin or Payroll Manager) sees it and approves or
denies it in one tap. An approval opens a **4h** window; when it runs out, the ticket locks
again and a new request is allowed.

### L4 — Submit locks immediately

**Submit locks the ticket at once**, even inside the 24h. Editing a COMPLETE ticket goes
through the same request flow (kind `SUBMITTED_EDIT`). On approval the ticket stays
COMPLETE and the request grants a write exemption, like a returned correction; resubmitting
re-queues payroll.

### L5 — Approver permission is payroll-admin:edit

The Payroll Manager role gets it in the seed **and** through a SQL data migration for
existing tenants.

**Reverses decision 2026-09-30 E2** ("Who is 'Payroll Admin' is a Department Roles setting"
— no fixed permission seeded). Under L5, the permission is seeded.

### L6 — Push reminders

Push reminders go to the worker at scheduled end **+12h and +20h**, only while the ticket is
still incomplete.

### L7 — Only the worker and payroll

Only the worker (inside the window, or inside an approved 4h window) and
`payroll-admin` holders may complete or correct a ticket. No dispatcher or supervisor acts on
the worker's behalf.

### L8 — Payroll-locked tickets are untouchable

A ticket whose employee week is APPROVED or EXPORTED is **never** updated. Requests are
refused, and payroll's own paths are refused too. Nothing holds week approval; the write is
refused when it happens.

### L9 — Reason on the request only

The reason goes on the request only. Edits inside the window keep today's per-step reason
rules.

### L10 — Audit trail reuses ActivityLog

Entity JOB_TICKET, `changes` JSON. New `ActivityLogAction` members:
`TICKET_EDIT_REQUESTED`, `TICKET_EDIT_APPROVED`, `TICKET_EDIT_DENIED`,
`TICKET_EDIT_EXPIRED`, `TICKET_LATE_COMPLETED`, `TICKET_EDITED_UNDER_APPROVAL`. A
snapshot-diff interceptor on FieldTicketsController records field, from, to, actor and time
for writes made under an approval.

### L11 — TicketEditRequest model

New model `TicketEditRequest`: kind, status (PENDING / APPROVED / DENIED / EXPIRED), reason,
requestedBy, decidedBy, decidedAt, windowEndsAt, submittedAt. A partial unique index allows
only one open request per ticket. New column `JobTicket.completedAt`, set from the client's
time capped at the server's clock. **Late = completedAt after the scheduled end**, shown
internally only, never in customer emails or on signatures.

### L12 — Web late-tickets page

New page `/payroll/late-tickets` (WorkspaceTable) for `payroll-admin` holders, with tabs
Overdue, Requests and Locked, plus Approve / Deny. A Late badge appears on payroll entries.

### L13 — API enforces the window

One check in `getTicketForEmployeeAction(…,'write')` returns 409
`TICKET_WINDOW_CLOSED` (never 403, which the outbox would swallow). Comments are exempt;
rejecting a ticket after the window is refused.

### L14 — Notifications

Payroll admins get **in-app and push** notifications for new requests, and in-app only for
late completions and approved edits. The worker gets a push on approval or denial.

### L15 — Mobile Home incomplete section

Incomplete tickets whose scheduled end falls in the last 14 days. Payroll-locked tickets are
hidden. The section shows a countdown, then **Request approval**, then **Waiting for
approval**, then a 4h countdown once approved.

### L16 — Inspections

Inside the window, no approval is needed; after it, they go through a request. Part 1's
submit block already stops a ticket being submitted with an inspection skipped.

### L17 — Offline

Each queued op carries `capturedAt` (sent as `X-Captured-At`). It is accepted when it was
captured before the window ended and arrives within a **72h grace**; the acceptance is
audited. Ops with no tag are judged by the server's clock.

### L18 — Payroll overlay sibling

The payroll week overlay (`payroll-week-overlay.ts:131`, which uses UTC) moves onto the
shared business-time `ticketScheduledEnd`.

## Tensions resolved

| Tension | Resolution |
|---------|------------|
| T2 — Who may complete on a worker's behalf | L7: only the worker and payroll-admin holders. No dispatcher or supervisor. |
| T3 — Who is "manager" for approvals | L5: payroll-admin:edit holders (Payroll Admin, Payroll Manager). |
| T7 — Window anchor | L2: scheduled end, not ticket time or first capture. |
| T8 — Same-day paperwork vs editable times | L2: inside 24h, all steps with original-date times. L4: submit locks immediately. |
| T9 — Reminder anchor | L6: scheduled end + 12h and + 20h. |
| T10 — Late inspections | L16: inside 24h, no approval needed; after 24h, through a request. |
| T11 — 4h window mechanics | L3: from the approver's click; expiry allows a new request. |
| T13 — Who gets notices | L14: payroll admins for requests/late completions; worker for approval/denial. |

## Tensions still open

| Tension | Status |
|---------|--------|
| T12 — Employee leaves with incomplete tickets | Open — not designed. |
| T14 — Previous-ticket enforcement (warn / soft / hard block) | Open — not designed. |
| T1 — Oiler fills the shared ticket; Operators complete their own? | Open — the verified one-ticket rule still governs. |

## Supersedes

This note supersedes the late-ticket portions of
decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md
(`status: reference`). That note stays as the record of what was first said.

L5 reverses E2 in
decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md: the
`payroll-admin:edit` permission is now seeded, not left to Department Roles.

## Effect on the vault

**Gaps resolved (done):**
- field-ops/gaps.md line 855: "Late and incomplete tickets — where the 24-hour window starts" — answered by L2–L18
- payroll/gaps.md line 5818: "Who may complete or correct a ticket on a worker's behalf" — answered by L5, L7

**No frontmatter changes.** The Melissa provisional note (2026-10-06) stays
`status: reference`. The 2026-09-30 developer-answers note stays `status: reference`. Neither
was `verified`; neither changes status from a developer direction. The reversal of E2 is
recorded here and governs the build; E2's note is not edited because a developer direction
supersedes another developer direction by recording the newer one, not by editing the older.
