---
title: Atom Mobile Application ( User stories )
source: confluence/TCG/Atom Mobile Application ( User stories )
migrated: 2026-08-10
remigrated: 2026-08-13
confluence_version: 10
updated: 2026-08-11
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/frd-new-format-draft/INDEX.md]
jira: []
topics: [field-ops-mobile, compliance, labor-payroll, subsistence, wtl, boom-premium]
entities: [labor-record, wtl, subsistence, craft-modifier, boom-pay, field-ticket, signature]
part_of: product/atom-mobile-app-user-stories/INDEX.md
---

> **This is where the mobile app hands off to payroll.** US-17 and US-18 produce the compliance
> and labor records the payroll module prices. See
> [payroll/INDEX.md](../../payroll/INDEX.md) → *Where payroll meets the rest of the vault*.

# EPIC 13 — Compliance

## US-17 — Compliance Checklist & Attestation

**User Story**

As a field employee, I want to review and attest to my compliance information so that required
end-of-job compliance information is recorded.

**Acceptance Criteria**

* Compliance displays/records the employee's applicable **Lunch and Work Through Lunch information**.
* Compliance includes the applicable rest-period/break information discussed for the field workflow.
* Employee can select the applicable **Long Sub, Short Sub or N/A** subsistence information.
* Employee reviews the applicable compliance information before attestation.
* Employee provides the required compliance acknowledgement/signature.
* Completed compliance information is retained against the ticket.
* Applicable compliance information is available for downstream Payroll/Operations processing.
* Payroll outcomes are determined downstream using the configured rules rather than requiring the employee to manually calculate payroll treatment.

> _Migration note, 2026-08-13._ **Long Sub / Short Sub** correspond to the payroll components
> `SUBSISTENCE_LONG_WEEKDAY_85`, `SUBSISTENCE_LONG_WEEKEND_200` and `SUBSISTENCE_SHORT_85`
> ([payroll rule catalog](../../payroll/payroll-app-current-state/03-payroll-rule-catalog.md)).
> Note the mismatch in granularity: this page offers **three** choices, payroll models **three
> components but distinguishes weekday from weekend** for the long case — a distinction the
> employee is not asked to make here, and which payroll would have to derive from the work date.
> Whether that derivation is correct is unstated on both sides.
>
> "Rest-period/break information" here is the capture side of `BRS-PAY-003` and the L12
> eight-hour rest rule. The page does not say what is captured, only that it is included.

# EPIC 14 — Labor & Unit Details

## US-18 — Labor & Unit Details

**User Story**

As a field employee, I want to review my Labor and Unit information so that accurate
payroll-related information is submitted with my ticket.

**Acceptance Criteria**

* Applicable ticket timing information automatically carries into the employee's **Labor information**.
* System calculates/displays applicable Labor hours using the captured ticket timing information.
* Employee can adjust Labor information where permitted by the applicable business rules.
* Labor time is not restricted solely to customer-billable ticket time where legitimate employee work occurs outside the customer-billable period.
* Employee selects the applicable **Labor Classification**.
* Available classifications come from the applicable configured system data and can include **Job Site Work, Shop Work, Travel and Site Inspection** where applicable.
* Applicable WTL information automatically carries into Labor rather than requiring duplicate entry.
* Applicable **Craft Modifier/Boom Pay** information is included in the Labor process.
* Applicable Unit/Asset information is displayed.
* Employee can record applicable comments.
* Confirmed Labor information is retained for downstream Payroll processing.

> _Migration note, 2026-08-13._ **"Craft Modifier/Boom Pay information is included in the Labor
> process"** is the capture side of the payroll boom/modifier premium — the rule the payroll
> documents warn is the easiest to double-count, because a source rate may already include craft
> + modifier. See [payroll rule catalog](../../payroll/payroll-app-current-state/03-payroll-rule-catalog.md)
> → *Boom / modifier premium*, and `PR-011` in the
> [rule matrix](../../payroll/codingcops-rule-matrix.md) (*Confirm modifier source and windows*).
>
> **Labor Classification** values here — Job Site Work, Shop Work, Travel, Site Inspection — do
> not appear in any payroll document. Nothing states how a classification maps to a payroll
> group or affects pricing.

# EPIC 15 — Review & Completion

## US-19 — Review & Complete Ticket

**User Story**

As a field employee, I want to review and complete my ticket so that incorrect information can
be corrected before the field record is finalised.

**Acceptance Criteria**

* Final Review displays the applicable **complete ticket workflow history**.
* Review displays applicable workflow timestamps, signatures and recorded activities.
* Review displays applicable calculated durations alongside timestamps so the employee can identify incorrect/unrealistic timing.
* Review displays applicable **Pre-Trip, JSA and Post-Trip** information.
* Review displays applicable **Lunch/WTL and Compliance information**.
* Review displays applicable **Labor & Unit Details**.
* Employee can edit only the fields that remain permitted for correction.
* Fields locked by the applicable workflow rules remain non-editable.
* If an adjusted timestamp conflicts with another workflow timestamp, the application displays the applicable validation error.
* Applicable validation issues must be corrected before ticket completion.
* Required workflow sections must be completed before the ticket can be finalised.
* Employee explicitly selects **Complete/Submit Ticket** after reviewing the information.
* Completing the ticket changes the applicable ticket status to **Completed**.
* Completed ticket information is made available for applicable downstream ERP, Operations, Billing and Payroll processing.
* After successful completion, the employee returns to the applicable Home/Dashboard view.
* System supports applicable reminders/notifications for tickets that have not been completed/finalised.
