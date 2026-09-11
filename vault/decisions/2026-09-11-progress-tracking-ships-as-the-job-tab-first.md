---
title: Progress Tracking ships as the Job tab first; the Daily Progress Tracking module follows — decision
source: decision/Syed Haris
decided: 2026-09-11
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing SCRUM-PROGRESS; picked this
  option in a working session on 2026-09-11 (question, option and description verbatim in
  `.ai/aidlc/SCRUM-PROGRESS/intent.md` → Session decisions D1). He is **not** the client-side
  product owner. No owner is declared for projects-jobs; the one the vault names is **Lisette
  Anzaldo** (Dispatch Manager, `admin/engagement-directory-and-org-charts.md`) — owner on 29 of
  34 `projects-jobs/gaps.md` entries — with Brian Petros for the job-detail screen
  (`projects-jobs/gaps.md` → *Job Main "Quick Access"*). **Lisette Anzaldo should ratify it.**
  `status: reference` for that reason: binding on the build, open to being overruled by TCG.
  Same basis as the 2026-09-10 SCRUM-PENDING notes.
status: reference
conflicts_with: []
resolves: [SCRUM-PROGRESS/intent.md#d1--scope]
jira: []
tags: [module/projects-jobs, module/dispatch, kind/decision, ticket-workflow, requirements]
---

# Progress Tracking: the Job tab now, the daily module later

Answers D1 of `.ai/aidlc/SCRUM-PROGRESS/intent.md` → *Session decisions*. There is no Jira issue.

## Decision

> **Q:** Which surfaces should this build cover?
> **Chosen:** *Job tab first (Recommended)* — "Projects → Job → Progress Tracking tab, as you
> described. The ticket timeline is built as its own reusable feature, so the top-level Daily
> Progress Tracking module can reuse it in a follow-up."

**Not chosen:** *Job tab + Daily module* — "Also build the top-level sidebar module now: date
navigator, project rail, job accordions, and the full-ticket view with the printable PDF report."

## Why

- The request was for the tab: *"we need to implement projects=>job=>progress tracking"* (intent
  §2). The vault lists Progress Tracking among the job-detail tabs
  (`projects-jobs/project-module/02-view-manage-job-details.md`:24, :57 — unverified).
- Building the ticket timeline as its own feature makes the daily module a second consumer of it
  rather than a second implementation.

## What is weak about this attribution

- **The decider of record is Syed Haris**, named and dated; the decision binds the build. He is a
  developer/owner, not TCG's dispatch owner. **Lisette Anzaldo should ratify it.**
- **The deferred surface is the one TCG was shown.** On the 2026-08-13 call
  (`meetings/transcripts/2026-08-13-payroll-process.md`, ~:252 and ~:310–318 — a record, not a
  commitment) a *daily* progress tracking view was demoed to Corrina Bustos, Kyle Harlow and Brian
  Petros as the place where "all of the flagged and all of the incomplete will be showing", with
  the same data "also housed into the project jobs … progress tracking". Corrina asked for a
  flagged-only filter there. Nobody at TCG has been asked which surface should come first.
- Nothing is relayed second-hand. No TPM or client approval is claimed.

## What this does NOT settle

- When the daily module is built, or under which ticket.
- What the printable ticket report / Download PDF contains — deferred with the module.
- Whether the flagged-only filter Corrina Bustos asked for on 2026-08-13 is a requirement.
- Who may open this tab and read another employee's ticket — intent §8, open; see
  `decisions/2026-09-11-progress-tracking-actions-are-contact-links-and-ticket-comments.md`.

## Effect on the vault

- **No vault body edited, no frontmatter flipped.** No documents conflict on this: the vault's
  only lines are `projects-jobs/project-module/02-view-manage-job-details.md`:24, :57 and
  `projects-jobs/project-module/07-create-and-manage-jobs-excluded.md`:51, both unverified, neither
  contradicting. `README.md` → *How a gap gets closed* does not apply.
- **`projects-jobs/INDEX.md` → *Decisions that bind this module* gained a line for this note**, on
  explicit instruction and outside `tcg-scrum`'s normal write scope.
- No `gaps.md` entry. Questions this ticket raises belong in `.ai/aidlc/SCRUM-PROGRESS/spec.md` §12,
  which this pass did not edit.
