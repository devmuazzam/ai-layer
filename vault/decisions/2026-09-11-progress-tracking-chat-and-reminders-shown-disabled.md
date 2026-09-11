---
title: Progress Tracking shows Send Reminder, Chat and Live Tracking disabled; the web does not read or post ticket comments — decision
source: decision/in-session developer
decided: 2026-09-11
decided_by: >-
  The developer who ran the 2026-09-11 design-rebuild session in
  `.worktrees/scrum-progress-design` (Claude account abdulrehmanbcsf11@gmail.com; client-repo git
  identity `devmohsinakram`, which is the machine's shared identity; no name was given). A
  developer, **not** the client-side product owner — the same basis as D1–D4. **Lisette Anzaldo
  should ratify it** (D4's note says why she is the owner the vault names). `status: reference`
  for that reason.
status: reference
conflicts_with: []
supersedes: [decisions/2026-09-11-progress-tracking-actions-are-contact-links-and-ticket-comments.md]
resolves: []
jira: []
tags: [module/projects-jobs, module/field-ops, kind/decision, ticket-workflow, notifications]
---

# Send Reminder, Chat and Live Tracking are shown disabled

Supersedes **in part** `2026-09-11-progress-tracking-actions-are-contact-links-and-ticket-comments.md`
(D4) — its *Chat* clause only. D4's *Contact* clause stands. Its deferral of *Send Reminder* also
stands; this note only says how the deferred button looks.

## Decision

The instruction that opened the session, verbatim:

> ui should be same as provided design · use reuseable components · ui should be integrated with
> backend · if any functionality is missing in our current system like chat make these button
> disabled

Then asked in session, because the ticket comment thread already exists and D4 had wired Chat to
it:

> **Q:** Chat isn't fully missing: every ticket already has a Comments thread the crew use on
> mobile, and a decision recorded today (D4) wires the design's Chat button to it (web read +
> post). You asked for chat to be disabled. Which do you want?
> **Chosen:** *Disable Chat* — "Chat button shown but disabled, like Send Reminder and Live
> Tracking. Supersedes decision D4, which I'd record in the vault."
> **Not chosen:** *Chat opens ticket comments (Recommended)* — "Chat drawer styled like the design,
> backed by the real ticket comment thread; office users read and post, crew see it on mobile.
> Only Send Reminder and Live Tracking are disabled."

On the Job → Progress Tracking tab this means:

- **Send Reminder via Email** (ticket card and employee card) and **Send Reminder** (the
  *Incomplete* banner) are rendered as the design draws them, **disabled**, with "Sending
  reminders is not available yet." on hover and focus.
- **Chat with &lt;role&gt;** is rendered **disabled**, with "Chat is not available yet."
- The **Live Tracking** card is rendered **disabled**, with no map and "Not available". Nothing
  captures a crew member's live location (D2).
- **Contact &lt;role&gt;** is unchanged from D4: a `tel:` link, else a `mailto:` link, and disabled only
  when the record has neither.
- **The web does not read or post ticket comments.** The first build's
  `GET`/`POST /jobs/:jobId/progress-tracking/tickets/:ticketCode/comments` routes were removed, and so
  were the `TicketCommentsService` changes they needed. Mobile's comment code is as it is on
  `main`.

## Why

- It is the developer's standing instruction for the build: match the design, and show anything
  the platform cannot do as disabled rather than hide it.
- The comment routes were removed rather than left unused. A write endpoint nothing calls is a
  liability, and the service change it needed altered how mobile shows a comment's author.

## What is weak about this attribution

- **Developer, not product owner.** Same basis as D1–D4. Lisette Anzaldo should ratify it.
- **It overrides the recommended option.** The comment thread exists and crew use it. The choice
  here is not to expose it from the web yet. It is not a finding that the thread is unsuitable.

## What this does NOT settle

- Whether web Chat, when it comes, is the ticket's comment thread (D4's reading) or a new channel.
- Reminders: channel, wording, recipient. That is still D4's deferral, and BRS-NOTIF-002 is still
  unanswered.
- Live location for crew. Nothing captures it, and Samsara is vehicle telematics only.

## Effect on the vault

- `2026-09-11-progress-tracking-actions-are-contact-links-and-ticket-comments.md` gains
  `superseded_by`, and its body says that only the Chat clause is superseded.
- `.ai/aidlc/SCRUM-PROGRESS/spec.md`: REQ-14 and REQ-17 are marked superseded.
- `projects-jobs/INDEX.md` → *Decisions that bind this module* gains a line for this note.
- The building session wrote this note directly, not `tcg-scrum`. D1–D4's INDEX line records the
  same exception.
