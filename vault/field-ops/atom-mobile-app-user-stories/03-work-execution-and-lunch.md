---
title: Atom Mobile Application ( User stories )
source: confluence/TCG/Atom Mobile Application ( User stories )
migrated: 2026-08-10
remigrated: 2026-08-13
confluence_version: 10
updated: 2026-08-11
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/frd-new-format-draft/INDEX.md, payroll/wtl-charts.md]
jira: []
topics: [field-ops-mobile, time-tracking, boom-time, lunch-breaks, wtl, labor-payroll]
entities: [boom-time, build-up, breakdown, lunch-record, wtl, signature, field-ticket]
part_of: field-ops/atom-mobile-app-user-stories/INDEX.md
---

> **Migration note.** The source page carries **two sections both numbered `US-11`** — Work
> Execution and Lunch/WTL. Reproduced as written. `US-12` does not exist on the page.
>
> **The lunch thresholds below conflict with the payroll charts.** See the box after the lunch
> section, and [gaps.md](../../gaps.md) → *Field-ops lunch capture vs payroll WTL*.

# US-11 — Work Execution: Start Work, Build-Up, Breakdown & End Work

### User Story

As a field employee, I want to record each stage of my work so that operational work, crane
setup, breakdown activities, and Boom Time are accurately captured.

## Acceptance Criteria

### Start Work

* Employee can select **Start Work** after completing all required pre-work activities (Customer Authorization and JSA/Tailboard).
* Selecting **Start Work** records the **Start Work timestamp**.
* **Start Work** remains separate from **Arrive Job** because arriving at the job site does not mean work has started.
* Employee can modify the Start Work timestamp according to the permitted ticket time-adjustment rules.
* System begins tracking the operational work period when Start Work is recorded.

### Build-Up / Crane Setup

* Employee can record **Build-Up/Crane Setup** for applicable crane jobs.
* Employee can select **Build-Up Complete** when crane setup is finished.
* System records the **Build-Up Complete** timestamp.
* System calculates the total **Build-Up duration**.
* Build-Up information is retained against the ticket.

### Work Execution

* After Build-Up is completed, the employee performs the assigned job.
* Employee can continue working until all job activities are completed.
* Operational work continues until **End Work** is recorded.

### Breakdown

* Employee can record **Breakdown** after the work has been completed.
* Breakdown is recorded as a separate activity from End Work.
* System records the **Breakdown timestamp**.
* System calculates the total **Breakdown duration**.
* Breakdown information is retained against the ticket.

### End Work

* Employee can select **End Work** after completing all work and Breakdown activities.
* Selecting **End Work** records the **End Work timestamp**.
* Employee can modify the End Work timestamp according to the permitted ticket time-adjustment rules.
* System ends the operational work period when End Work is recorded.
* System calculates the total **Boom Time** using **Start Work → End Work**.
* Start Work, Build-Up, Breakdown, End Work, and Boom Time are retained against the ticket.
* After End Work, the employee proceeds to **Customer Final Signature**.

# US-11 — Lunch & Work Through Lunch Management

### User Story

As a field employee, I want to record my lunch and Work Through Lunch activities so that
meal-break compliance, customer authorization, and payroll processing are accurately managed.

## Acceptance Criteria

### Lunch Availability

* System automatically creates the applicable lunch event(s) based on the configured lunch rules.
* Lunch events remain locked until the employee becomes eligible for that lunch.
* System supports multiple lunch events during a shift (Lunch 1, Lunch 2, Lunch 3, Lunch 4, etc.).
* Employee can only record the lunch event that is currently applicable.

### Lunch Timing Rules

* **Lunch 1** must be taken **before completing 5 hours** of work.
* **Lunch 2** must be taken **before completing 10.5 hours** of work.
* **Lunch 3** must be taken **before completing 16.5 hours** of work.
* **Lunch 4** becomes applicable **before completing 22 hours** of work.
* System sends a notification **1 hour before** each applicable lunch is due.
* The employee can continue working until the lunch deadline is reached.

### Taking Lunch

* Employee can select **Take Lunch**.
* System records the applicable lunch against the correct lunch period.
* Lunch activity is stored with the ticket.

### Work Through Lunch (WTL)

* Employee can select **Work Through Lunch** instead of taking lunch.
* WTL is recorded against the applicable lunch period.
* System supports multiple WTL events during the same shift.

### Customer Authorization

* Work Through Lunch requires customer authorization.
* System captures the customer's name.
* System captures the customer's signature.
* System captures the customer's photo.
* Employee can enter comments.
* Customer authorization is stored with the applicable WTL record.

---

> ## ⚠ Conflict with the payroll WTL charts
>
> _Migration note, 2026-08-13 — not part of the source page._
>
> This page and [payroll/wtl-charts.md](../../payroll/wtl-charts.md) both state lunch
> thresholds, and **two of the four disagree**:
>
> | Lunch | This page (Atom v10, 2026-08-11) | Payroll WTL charts (revised 2026-01-23) | |
> | --- | --- | --- | --- |
> | 1 | before completing **5** hours | marker at **5:01** | consistent |
> | 2 | before completing **10.5** hours | marker at **10.5:01** | consistent |
> | 3 | before completing **16.5** hours | marker at **16:01** | **disagree — 0.5 h apart** |
> | 4 | applicable before **22** hours | marker at **21.5:01** | **disagree — 0.5 h apart** |
>
> The payroll charts state they follow the Local 12 Master Labor Agreement, page 26 section F,
> and were revised by Danny Bryan and Mike Vlaming. This page is a CodingCops-authored user
> story. **The contract-derived source and the app specification disagree**, and a missed third
> or fourth meal is a double-time penalty — so this is a money difference, not a UI detail.
>
> **Do not implement either value until it is reconciled.** A notification fired on the wrong
> threshold produces exactly the penalty the notification exists to prevent.
>
> Two further points of contact, both agreeing:
>
> - **Lunch count.** This page now says four (Lunch 1–4), matching payroll's `WTL_0`…`WTL_4`.
>   `BRS-LUNCH-002` in [brs.md](../../brs.md) still says **three** and is marked ✓ Confirmed. The
>   BRS is now the outlier.
> - **Notification timing.** "1 hour before" is new here and answers `BRS-LUNCH-003`
>   (*Lunch Notification Timing*, ⚠ Needs Client Validation) — though nothing says this page
>   *is* that validation.
