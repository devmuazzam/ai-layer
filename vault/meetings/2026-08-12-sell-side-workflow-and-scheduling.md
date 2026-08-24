---
title: TCG – Meeting Minutes (12 August 2026)
source: user-supplied/meeting-minutes
migrated: 2026-08-13
updated: 2026-08-12
status: unverified
conflicts_with: []
jira: []
tags: [module/customers, module/dispatch, module/projects-jobs, module/quotations, kind/meeting-notes, scheduling, permits, integrations]
entities: [job-schedule-master, permit, crane, support-truck, customer-intake, ready-to-schedule-checklist, geographic-heat-map, red-path]
meeting_date: 2026-08-12
---

# TCG – Meeting Minutes, 12 August 2026

**Sell-side workflow.** Brian Petros walked the team through documentation and workflow files
covering how a job gets sold and scheduled, ahead of designing the end-to-end workflow.

> **Forward-looking.** See the note in
> [2026-08-05-payroll-module-design-review.md](2026-08-05-payroll-module-design-review.md) —
> the `meetings/` retrospective caveat does not apply to these client minutes.

## Discussion points

- Discussed the documentation and workflow files shared by **Brian Petros** to provide the team
  with the necessary information and a clear direction for the sell-side workflow.
- Brian explained that the purpose of compiling the information was to ensure the team has the
  correct process, sufficient details, and does not miss important requirements when designing
  the workflow.
- Discussed the challenge of connecting the large amount of available information into **one
  coherent end-to-end workflow** and ensuring that all the individual pieces work together
  correctly.
- Brian introduced the **Job Schedule Master**, used by the sales team to schedule the required
  crane with the customer.
- Discussed different **permit types**, including annual permits that remain valid for one year
  and may cover specific cranes.
- Discussed capturing **Sales Coordinator, Salesperson, job location, scheduled hours**, and job
  status such as *Scheduled, Tentative, Hold, Cancelled, or Maintenance*.
- The system should **prevent selection of cranes under maintenance** and **support double
  booking** when short jobs allow the same crane to perform multiple jobs in one day.
- Discussed **linking required support trucks to cranes/jobs** so Dispatch can see the required
  support resources and reduce dependency on a single person for scheduling decisions.
- Discussed identifying which cities allow annual permits and the differences between annual and
  job-specific permits.
- Reviewed the **Geographic Heat Map** to analyze company activity by city.
- Discussed the **One-Page Customer Intake** to quickly capture key customer, project, permit,
  and lifting requirements during the initial customer call.
- Discussed the permit process for crane travel.
- Discussed the **Ready-to-Schedule Checklist** used by Sales to confirm all required job
  information before handing the job over to Dispatch.
- Discussed involving Dispatch earlier for **Red Path** opportunities to identify feasibility
  issues before significant quotation and documentation work is completed.
- Discussed the ongoing **HubSpot, Microsoft 365, Dialpad, and Mapsly** integrations.

## Action items

| Owner | Action |
| --- | --- |
| — | Include **Patrick** in the next meeting to explain the current integration work and demonstrate the working solution. |
| — | Review the existing integrations to determine what functionality can be incorporated into the ERP. |
| CC Team | Review the new **Customer Intake** requirements and identify what needs to be added to the ERP. |
| TCG Team | Provide/confirm the required **intake questions, fields, and business rules**. |

*Two action items are recorded in the source without a named owner.*

## How this lands against the vault

Mostly **new ground**, and it reaches into the vault's most contested area.

- **Job Schedule Master, Ready-to-Schedule Checklist, One-Page Customer Intake, Geographic Heat
  Map, and "Red Path"** appear nowhere in the vault. No definition exists for *Red Path* — treat
  it as an undefined domain term.
- **Permits** — annual vs job-specific, city-by-city eligibility, crane-travel permits — have no
  vault coverage. The field-ops FRD's BRS References table lists permits only as a *Pending*
  compliance topic.
- **Customer intake** touches the customers area, where the vault already has **five sources,
  three of them copies** ([customers/customers-INDEX.md](../customers/customers-INDEX.md)). New
  intake fields should not be specified without reading that stub first.
- **Crane maintenance state blocking selection, and deliberate double-booking**, are scheduling
  rules that belong with the Daily Allocation System
  ([dispatch/daily-allocation-INDEX.md](../dispatch/daily-allocation-INDEX.md)) — which is itself
  an unresolved 2-source conflict. Neither source covers either rule.
- **HubSpot** appears in the vault only once, in `assets/user-story-and-tasks.md`, which was
  migrated from an individual's *personal* Confluence space and carries a `provenance_note`
  warning that it may be one person's draft rather than agreed specification. **Dialpad, Mapsly
  and Microsoft 365 appear nowhere.** Patrick's demo is currently the only route to what these
  integrations actually do.

Recorded in [gaps.md](../gaps.md).
