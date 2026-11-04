---
title: Projects Jobs — module index
status: reference
kind: index
updated: 2026-09-04
tags: [module/projects-jobs, kind/reference]
---

# Projects Jobs

Projects, jobs, plans, permits. Backend usecases: `projects, jobs, sub-jobs, plans*, permits*, job-*-assignments`. Organized per [STRUCTURE.md](../STRUCTURE.md).

## Files

| File | Answers | KB |
| --- | --- | --- |
| [job-project-das.md](job-project-das.md) | Cross-module punch list; DAS is 1 of 9 sections | 1.7 |
| [project-module/INDEX.md](project-module/INDEX.md) | Project module — **its own section numbering is unreliable, see index** | 2.2 |
| [quote-to-job-lifecycle.md](quote-to-job-lifecycle.md) | Where permits and the two kinds of PO sit between quote and job; the undated ER sketch, and where the client has since contradicted it | 9.8 |
| [city-permits/INDEX.md](city-permits/INDEX.md) | **Permits, 7 pages** — 153-jurisdiction reference, lead times, the annual/blanket tracker, waivers, FAA/NOTAM | 3.9 |
| [scheduling/INDEX.md](scheduling/INDEX.md) | **Scheduling, 6 pages** — the Ready to Schedule gate, the permit clock, Green/Yellow/Red, the Job Schedule Master workbook | 3.6 |
| [lift-plans/INDEX.md](lift-plans/INDEX.md) | **Lift plans, 3 pages** — requesting, building, the pending-plan exception, package anatomy | 2.7 |

### Added by the Project Repository drop, 2026-09-04

Sixteen new pages arrived in one drop of TCG's SharePoint "Project Repository". They document the
**current manual process** — the Value Engine playbooks, the per-city permit library, the permit and
scheduling workbooks, and two complete lift-plan packages. Where they touch a subject the Confluence
pages already cover, each new page says explicitly how the two differ rather than overwriting either.

**Three things they establish that the vault did not have:**

- **The permit clock.** Thursday 12:00 noon through Monday start of business does not count toward
  permit lead time — roughly 3.5 countable days a week. It drives the whole Green / Yellow / Red
  scheduling decision.
- **TCG holds 338 annual and blanket permit records across 29 units and 49 agencies, and 115 of them
  are expired.** That register is what an "is there an annual here?" flag would have to read.
- **A lift plan is a bound multi-source package**, not a form — with four priced deliverable tiers,
  a 24-hour standard turnaround, and four categories of expiring credential inside it.

> **Security finding from this drop, for a human to act on.** The 153 per-city permit notes carry
> **live portal usernames, passwords and security-question answers in plain text** in a shared
> folder, plus one captured OAuth token pair. None were copied into the vault; every occurrence is
> marked and the source path given. See
> [city-permits/permit-acquisition-process.md](city-permits/permit-acquisition-process.md).

## Decisions that bind this module

- [2026-08-12-plan-comments-page-scope.md](../decisions/2026-08-12-plan-comments-page-scope.md) — Scope of "the Plan Comments page" in SCRUM-757 — decision
- [2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) — Archive replaces delete, app-wide — decision
- [2026-08-20-job-completed-on-last-day-offload.md](../decisions/2026-08-20-job-completed-on-last-day-offload.md) — Project Job becomes Completed on last-day yard offload — decision
- [2026-08-20-job-completion-scope-no-vendor-no-backfill.md](../decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md) — Job completion scope — no vendor path and no historical backfill in SCRUM-903 — decision
- [2026-08-25-completed-job-view-only.md](../decisions/2026-08-25-completed-job-view-only.md) — Completed Project Jobs are hard view-only — decision
- [2026-08-20-planning-tracker-archived-filter.md](../decisions/2026-08-20-planning-tracker-archived-filter.md) — Planning Tracker must have a filter that shows archived plans — decision
- [2026-08-20-post-save-navigation-convention.md](../decisions/2026-08-20-post-save-navigation-convention.md) — Post-save navigation — edit goes to detail, create goes to listing — decision. **Create half superseded 2026-09-01**; the edit half stands
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20
- [2026-08-31-quotation-qty-not-das-sets.md](../decisions/2026-08-31-quotation-qty-not-das-sets.md) — Quotation qty is billing only; one DAS/Yard set per root; child qty independent
- [2026-08-28-job-schedule-weekend-empty-state.md](../decisions/2026-08-28-job-schedule-weekend-empty-state.md) — Job Schedule weekend-empty empty state — decision
- [2026-09-08-artifact-due-date-seeded-from-first-job-day.md](../decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md) — A permit/plan artifact's `dueDate` is seeded from the job's first scheduled day and is freely editable thereafter. Settles the seed and editability only — whether the app should compute or warn on a lead-time deadline (`Latest Permit Submission`) stays open in [gaps.md](gaps.md)
- [2026-09-10-permit-create-types-mockup-document-types.md](../decisions/2026-09-10-permit-create-types-mockup-document-types.md) — Permit document kinds = Travel | FAA | Encroachment | Sub Hauler (mockup); global-create claim superseded 2026-09-11
- [2026-09-10-permit-association-scope-asset-job-vendor.md](../decisions/2026-09-10-permit-association-scope-asset-job-vendor.md) — **Superseded** — was Asset|Permit|Vendor create types; association exclusivity still applies via the superseding decision
- [2026-09-11-permit-classes-job-only-until-sept-15.md](../decisions/2026-09-11-permit-classes-job-only-until-sept-15.md) — Permit classes general|job; hide Create Permit until after 15 Sep; only job-class via quote→project
- [2026-09-11-outbound-po-subtypes-and-modal-fields.md](../decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md) — Outbound PO subtypes Permit|Vendor|Asset; modal fields; OPEN|CLOSED
- [2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md) — Quote→project permits/plans/PO flow locks from Ehtesham Looms
- [2026-09-11-progress-tracking-ships-as-the-job-tab-first.md](../decisions/2026-09-11-progress-tracking-ships-as-the-job-tab-first.md) — SCRUM-PROGRESS D1: Job → Progress Tracking tab first, ticket timeline built reusable; the Daily Progress Tracking module and PDF report deferred. `reference`
- [2026-09-11-progress-timeline-follows-the-real-mobile-flow-with-schedule-times.md](../decisions/2026-09-11-progress-timeline-follows-the-real-mobile-flow-with-schedule-times.md) — SCRUM-PROGRESS D2: timeline is the real mobile flow (14 steps Oiler / 9 others), not the design's 15; schedule times display only; uncaptured data left out. `reference`
- [2026-09-11-progress-tracking-ticket-status-rules.md](../decisions/2026-09-11-progress-tracking-ticket-status-rules.md) — SCRUM-PROGRESS D3: ticket status rules (Not opened … Incomplete, progress %, current step). Precedence and step states still open; the null-end clause is this screen only. `reference`
- [2026-09-11-progress-tracking-actions-are-contact-links-and-ticket-comments.md](../decisions/2026-09-11-progress-tracking-actions-are-contact-links-and-ticket-comments.md) — SCRUM-PROGRESS D4: Contact = call/email links; Chat = the ticket's existing comment thread, web read + post; Send Reminder deferred. Permissions open. **Chat clause superseded 2026-09-11** (see the chat-and-reminders note below). `reference`
- [2026-09-11-progress-tracking-reads-need-jobs-view-and-posts-need-jobs-edit.md](../decisions/2026-09-11-progress-tracking-reads-need-jobs-view-and-posts-need-jobs-edit.md) — SCRUM-PROGRESS §12 Q1: web reads of another crew member's ticket need `jobs:view`, comment posts need `jobs:edit`; no new permission key. Settles the permission question D4 left open. `reference`
- [2026-09-11-progress-tracking-status-precedence-step-states-and-boom-hours.md](../decisions/2026-09-11-progress-tracking-status-precedence-step-states-and-boom-hours.md) — SCRUM-PROGRESS §12 Q2–Q4, Q6: badge precedence Incomplete → Flagged → Rejected → Completed → In progress → Not opened; Completed can still be Flagged; step states with inference; boom hours = closed build-up + boom + break-down. Settles the precedence and step-state items D3 left open; Q5 (null end time) still open. `reference`
- [2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md](../decisions/2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md) — SCRUM-PROGRESS: Send Reminder, Chat and the Live Tracking map render as in the design but disabled; the web does not read or post ticket comments. Supersedes D4's Chat clause only — Contact links and the reminder deferral stand. `reference`
- [2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md](../decisions/2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md) — PO Fee typed by the user: permit approval no longer writes it and leaves a `CLOSED` PO untouched; PO total = line items − discount, no computation. Create-time fee default still open. Syed Haris, TCG-89. `reference`
- [2026-10-08-project-detail-selected-schedule-per-job.md](../decisions/2026-10-08-project-detail-selected-schedule-per-job.md) — Project Detail "Selected Schedule" card: one row per job, Job Duration Days / Selected Working Days / Selected Second Shifts, counted by the Schedule tab's own `summarizeScheduleEntries`. No project total. Umair Khan's confirmation of the UAT 4 #21 reading outstanding. Syed Haris, TCG-101. `reference`
- [2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md](../decisions/2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md) — Conversion builds the job from its quote's configuration snapshot; the job reads its quote's snapshot (no copy on the job); a job with no quote reads the live configuration (Syed Haris, ticket owner, `reference`)
- [2026-10-16-dispatch-slots-required-optional-none.md](../decisions/2026-10-16-dispatch-slots-required-optional-none.md) — On conversion each job resource is marked REQUIRED / OPTIONAL / NONE for dispatch; rows added later on the job's Resources tab are REQUIRED (Syed Haris, ticket owner, `reference` — **assumptions pending Lisette Anzaldo**)

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

6 meeting files carry `module/projects-jobs` — list them:

```
grep -rl 'module/projects-jobs' vault/meetings/
```
