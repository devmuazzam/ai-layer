---
title: TCG – Minutes of Meeting (7 August 2026)
source: user-supplied/meeting-minutes
migrated: 2026-08-13
updated: 2026-08-07
status: unverified
conflicts_with: []
jira: []
topics: [labor-compliance, certified-payroll, davis-bacon, billing, quotations, meeting-minutes]
entities: [labor-compliance, certified-payroll, davis-bacon, lcp-tracker, non-performance-report, compliance-checklist, quotation]
meeting_date: 2026-08-07
---

# TCG – Minutes of Meeting, Friday 7 August 2026

**Labor Compliance / Certified Payroll.** This meeting names a **new module** — Labor
Compliance — that does not exist anywhere else in the vault.

> **Forward-looking.** See the note in
> [2026-08-05-payroll-module-design-review.md](2026-08-05-payroll-module-design-review.md) —
> the `meetings/` retrospective caveat does not apply to these client minutes.

## Discussion points

- Discussed the **Certified Payroll** process and its relationship with customer billing and
  payment processing.
- TCG team explained that Certified Payroll reporting **directly impacts customer payments**, as
  payments may be delayed if the required Certified Payroll reports have not been submitted.
- Discussed the payroll engine design, being developed to automatically apply payroll
  calculation rules, including standard hours, overtime, boom time, rest periods, and other
  payroll rules.
- Discussed whether Certified Payroll or **Davis-Bacon** projects require assigning employees
  from specific local areas.
- TCG team explained that when non-local employees are assigned to projects requesting local
  workers, a **justification form must be completed before the job begins**.
- **Agreed to use "Labor Compliance" as the primary module name**, as it encompasses Certified
  Payroll, Davis-Bacon, and related compliance requirements.
- Discussed improving the quotation process by introducing a **Labor Compliance indicator**,
  ensuring compliance jobs are identified early and included in Certified Payroll reporting.
- Clarified that **if a job is not marked as a Labor Compliance job, it will not appear in
  Certified Payroll reports**, creating a risk of missed compliance reporting.
- Discussed the relationship between Labor Compliance activities and the billing process,
  including compliance fees, Non-Performance reporting, and customer invoicing.
- Discussed the workflow for closing Labor Compliance (Certified Payroll) projects.
- TCG team explained that a Labor Compliance project **can only be closed after the final
  Certified Payroll report and closeout documentation have been submitted**.
- Reviewed scenarios where projects remain open for extended periods, requiring ongoing
  Certified Payroll reporting and Non-Performance reporting until the project is officially
  closed.
- TCG team confirmed that **Non-Performance reporting is currently not billed**, as the Billing
  team is not notified when those reports are completed. The billing model for Non-Performance
  reporting is still under review.
- Reviewed the billing lifecycle for Labor Compliance projects, including the initial processing
  fee, recurring compliance charges, and project closure.
- Discussed the initial Labor Compliance setup process, which begins when the Sales
  Representative or Project Manager sends the quotation together with the **Labor Compliance
  setup form** to the customer.
- Agreed that the completed Labor Compliance setup form should be returned **directly to the
  Labor Compliance team**, with follow-up performed when required information is missing.
- Reviewed the purpose of the **Labor Compliance Tracking Register**, used to manage Certified
  Payroll projects, monitor project status, retain historical records, and support compliance
  tracking.
- Discussed the need to **integrate the Labor Compliance module with the Payroll module** to
  support automatic generation of Certified Payroll reporting forms using payroll data.
- Discussed the integration between the ERP system and the **LCP (Labor Compliance Program)
  Tracker**, including linking projects through the project name and improving project lookup.
- Discussed the challenges of accurately identifying Davis-Bacon projects during quotation
  creation, acknowledging that some cases require additional verification after project
  initiation.
- Discussed capturing Labor Compliance and Davis-Bacon information **as early as possible during
  quotation creation** to support downstream automation.
- Agreed that a **Compliance Checklist with embedded business rules** would help Sales
  Representatives consistently identify Labor Compliance, Davis-Bacon, permits, plans, and other
  project compliance requirements.
- Discussed implementing the agreed business rules into the ERP system to standardize compliance
  identification, improve payroll accuracy, and reduce manual intervention.

## Action items

| Owner | Action |
| --- | --- |
| CC Team | Evaluate introducing a **Compliance Checklist** during the quotation process to help Sales Representatives identify Labor Compliance, Davis-Bacon, permits, plans, and other project compliance requirements before work begins. |
| Corrina (TCG) | Provide Ryan with the **Davis-Bacon business rules and identification criteria** for implementation in the Compliance Checklist. |
| CC Team | Evaluate implementing a **Labor Compliance flag at both the quotation and customer levels** to automatically identify recurring Labor Compliance customers and projects. |
| CC Team | Investigate integrating **Non-Performance reporting with the Billing module** to support future automated billing. |

## Next meeting

Will focus on the **Payroll Module** — payroll processing workflows, payroll calculation rules,
Certified Payroll integration, and payroll automation.

## How this lands against the vault

**Labor Compliance is a module with no vault coverage at all.** Nothing in `product/` or
`payroll/` mentions Certified Payroll, Davis-Bacon, prevailing wage, the LCP Tracker, or
Non-Performance reporting. These minutes are currently the *only* source. That is a large
uncovered area, not a detail — recorded in [gaps.md](../gaps.md).

Two consequences worth stating plainly:

- **It is a payroll consumer.** Certified Payroll reports are generated *from* payroll data, so
  the module depends on [payroll/](../payroll/INDEX.md) — most directly on the pay-component
  ledger, which is the only structure that can explain per-employee, per-job hours and rates at
  the granularity a certified report needs.
- **It starts at the quotation.** The Labor Compliance indicator has to be captured during
  quotation creation, which reaches into the quotations area — already the vault's most
  contested topic ([product/quotations-INDEX.md](../product/quotations-INDEX.md), four sources
  that disagree). None of those four mentions compliance.

The stated failure mode is worth flagging on its own: **an unmarked job silently never appears
in Certified Payroll reports.** That is a missed-compliance risk with a billing consequence, and
it argues the flag cannot be an optional field added later.
