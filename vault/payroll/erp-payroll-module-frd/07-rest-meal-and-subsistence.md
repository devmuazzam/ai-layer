---
title: The Crane Guys ERP Payroll Module - Rest period, meal period / worked-through-lunch, and subsistence
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
topics: [payroll, erp-payroll, rest-period, meal-period, subsistence]
entities: [rest-premium, wtl, subsistence, mileage, tolls]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

## 13. Rest-Period Rule

### PR-034 — Eight Hours of Rest

The L12 agreement requires at least eight hours of rest between the end of an overtime period and the
beginning of another straight-time shift. If the employee does not receive the required rest, the employee is
paid at the applicable overtime rate until eight hours of rest have been received.

Required information

- Actual end of previous work chain
- Whether previous chain contained overtime
- Actual start of next chain
- Gap between chains
- Overlapping entries

- Applicable overtime floor

Trigger

- Previous qualifying chain included overtime.
- The employee returned before receiving eight continuous hours off.

Processing

- Stitch related labor entries into work chains.
- Calculate the rest gap.
- Activate the forced-rest premium.
- Continue the premium until a qualifying eight-hour break occurs.
- Avoid compounding the premium on recalculation.

Outputs

- Rest-rule triggered
- Previous chain
- Return chain
- Rest gap
- Affected hours
- Premium amount
- Overlap warning
- Missing-rate warning

## 14. Meal Period / Worked Through Lunch

### PR-035 — Meal Opportunity

The L12 agreement states that an employee should not be required to work more than five consecutive
hours without a one-half-hour meal period.

The ERP needs to determine:

- continuous work span;
- number of expected meal opportunities;
- actual meal breaks;
- whether a meal was worked;
- day type;
- applicable rate;
- whether labor entries must be grouped.

### PR-036 — Worked Meal Period

The agreement contains different payment language for ordinary days and for Saturday, Sunday, and
holiday worked meal periods.

The existing Payroll App uses WTL comment tokens such as:

- WTL_0
- WTL_1
- WTL_2
- WTL_3
- WTL_4

The ERP should support a more direct meal-period record when possible, but may continue supporting
tokens during the transition.

Required validations:

- missing token or meal record;
- conflicting tokens;
- token exceeds possible meals;
- meal does not align with priced time;
- grouped labor entries overlap;
- continuous span exceeds configured limits.

WTL requirements should apply only to eligible payroll groups. Non-Union Admin Hourly rows should
display “Not applicable” when the union WTL rule does not apply.

## 15. Subsistence and Travel-Related Pay

### PR-037 — Standard Subsistence

The agreement provides an $85 scheduled-workday subsistence allowance when qualifying employees are
required to remain away from home overnight and the equipment/job conditions meet the specified
distance and equipment-remains-on-job requirements.

Required information:

- employee home base;
- equipment home yard;
- job location;
- computed route distance;
- overnight requirement;
- equipment remained on job;
- scheduled workday;

- move-in or move-out status;
- approved exception.

The current Payroll App uses comment tokens. The ERP should preferably calculate eligibility from
structured data and use an override only when necessary.

### PR-038 — Long-Distance Weekend Subsistence

For qualifying subsistence-area work over the specified distance, the agreement provides a $200-per-day
weekend allowance or permits an employer election to pay portal travel instead.

The ERP must capture the employer election and prevent both options from being paid for the same period
unless authorized.

### PR-039 — Toll Roads

Qualifying toll-road costs are employer-paid. The ERP should support:

- toll amount;
- trip;
- employee;
- job;
- receipt or electronic toll record;
- approval;
- reimbursement/export classification.

### PR-040 — Personal Vehicle Mileage

The agreement currently states a contractual mileage amount for qualifying employee-vehicle use.

The ERP should use an effective-dated mileage-rate table rather than hard-code the amount.

Required information:

- approved personal-vehicle use;
- purpose;
- origin and destination;
- actual or approved mileage;
- job;
- approving manager;
- effective contractual rate.
