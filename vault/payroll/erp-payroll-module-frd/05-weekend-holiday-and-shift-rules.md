---
title: The Crane Guys ERP Payroll Module - Weekend, holiday, special-day and shift rules
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/frd, holidays, shift-differential]
entities: [holiday, special-saturday, shift-premium]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

## 9. Weekend, Holiday, and Special-Day Rules

### PR-018 — Holiday Calendar

The ERP must maintain an effective-dated holiday calendar.

The L12 agreement identifies:

- New Year’s Day
- Presidents’ Day
- Memorial Day
- Independence Day
- Labor Day
- Veterans’ Day
- Thanksgiving Day
- Day after Thanksgiving
- Christmas Day

The agreement also contains observed-day rules for holidays falling on Sunday and for Christmas or New
Year’s Day falling on Saturday.

Each holiday record should include:

- holiday date;
- holiday name;
- observed date;
- union/agreement;
- multiplier;
- minimum paid hours;
- whether work is prohibited except for emergency;
- effective date;
- source agreement section.

### PR-019 — Holiday Pay

For covered L12 work, the agreement requires a minimum of eight hours at triple time for work performed
on listed holidays, subject to specified exceptions.

Trigger

- Employee is eligible for the L12 holiday rule.
- Work date matches the applicable holiday calendar.

Processing

- Apply the holiday multiplier.
- Determine whether the eight-hour minimum applies.
- Calculate any guaranteed holiday hours.
- Record actual hours and guaranteed hours separately.
- Flag Labor Day work for confirmation of extreme urgency.

### PR-020 — Sunday

Current L12 design uses double time for Sunday hours.

The current Payroll App has also used Sunday minimum-pay behavior in configuration. The union
agreement and TCG policy should be reviewed to confirm whether the ERP should apply:

- a Sunday minimum;
- only the general reporting/minimum rules;
- different treatment for no-work reporting time.

This must be documented explicitly rather than inferred from the multiplier.

### PR-021 — Saturday

Ordinary Saturday work should use the configured L12 Saturday multiplier unless another rule—such as
holiday, special Saturday, or daily double time—controls the segment.

### PR-022 — June and December Special Saturday

The first Saturday following the first Friday in June and December receives special treatment under the L12
agreement.

Current requirement:

- minimum eight paid hours;
- double-time rate;
- separate identification from an ordinary holiday.

The ERP should label this rule December Special Saturday or June Special Saturday, not simply “Holiday.”

## 10. Shift Rules

### PR-023 — First Shift

- Eight working hours
- Eight paid hours
- No shift premium

### PR-024 — Second Shift

- Seven working hours
- Eight paid hours
- Additional $3.00 per hour
- The premium becomes part of the base rate for the shift

### PR-025 — Third Shift

- Six and one-half working hours
- Eight paid hours
- Additional $4.00 per hour
- The premium becomes part of the base rate for the shift

These multiple-shift provisions, including the requirement for multiple shifts to operate for three or more
consecutive days and the notification requirements, come from the L12 agreement.

Required information

- Shift code
- Shift start and end
- Work date
- Job or operation
- Consecutive-shift operation dates
- Confirmation that the union notification requirement was satisfied

Outputs

- Actual worked hours
- Paid shift hours
- Shift premium rate
- Shift premium pay
- Additional paid-hours component
- Shift-rule exception
