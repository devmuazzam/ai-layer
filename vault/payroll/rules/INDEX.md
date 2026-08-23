---
title: Payroll rule register
status: reference
kind: index
updated: 2026-08-24
tags: [module/payroll, kind/reference, payroll-rules]
---

# Payroll rule register — the one canonical list

**73 rules under one namespace: `PAY-###`.** Spine and ordering = the CodingCops rule matrix
(68 rules, sections A–G); PAY-069…073 are register-only rules the 2026-08-24 verification
found missing from every catalog. Each rule file joins all aspects: matrix row, FRD section,
legacy engine behaviour, SQL, contract article, conflicts, test cases.

**Id disambiguation — read once:** `PAY-###` (this register) is the only id to cite bare.
The FRD and the matrix both use `PR-###` **with different meanings** — cite those only with
the document. Confluence adds `PAY-CC-##` and `US/PAY-WP-##`. The register maps them all.

Status: **1 settled · 59 open · 13 conflicted.** The client-question list:
`grep -l 'status: conflicted' vault/payroll/rules/` — or by section below.


## A-foundation-source-data

| Id | Rule | Status |
| --- | --- | --- |
| [PAY-001](PAY-001-saturday-friday-payroll-week.md) | Saturday-Friday payroll week | ✅ settled |
| [PAY-002](PAY-002-pay-period-status-workflow.md) | Pay-period status workflow | · open |
| [PAY-003](PAY-003-employee-master-import.md) | Employee master import | · open |
| [PAY-004](PAY-004-labor-entry-import.md) | Labor-entry import | · open |
| [PAY-005](PAY-005-job-ticket-import.md) | Job-ticket import | · open |
| [PAY-006](PAY-006-adp-file-number-mapping.md) | ADP File Number mapping | · open |
| [PAY-007](PAY-007-system-testing-employee-exclusion.md) | System/testing employee exclusion | · open |
| [PAY-008](PAY-008-effective-dated-configuration.md) | Effective-dated configuration | · open |

## B-group-and-rate

| Id | Rule | Status |
| --- | --- | --- |
| [PAY-009](PAY-009-payroll-group-classification.md) | Payroll group classification | · open |
| [PAY-010](PAY-010-l12-union-base-rate.md) | L12 union base rate | ⚠️ conflicted |
| [PAY-011](PAY-011-l12-modifier-boom-rate.md) | L12 modifier/boom rate | ⚠️ conflicted |
| [PAY-012](PAY-012-non-union-hourly-rate.md) | Non-union hourly rate | · open |
| [PAY-013](PAY-013-non-union-salary-rate.md) | Non-union salary rate | · open |
| [PAY-014](PAY-014-rate-comparison-and-validation.md) | Rate comparison and validation | ⚠️ conflicted |
| [PAY-015](PAY-015-higher-rate-for-day-job.md) | Higher rate for day/job | · open |
| [PAY-016](PAY-016-apprentice-wage-step.md) | Apprentice wage step | · open |

## C-time-and-premium

| Id | Rule | Status |
| --- | --- | --- |
| [PAY-017](PAY-017-time-source-selection.md) | Time-source selection | · open |
| [PAY-018](PAY-018-assumed-shift.md) | Assumed shift | · open |
| [PAY-019](PAY-019-cross-midnight-processing.md) | Cross-midnight processing | ⚠️ conflicted |
| [PAY-020](PAY-020-half-hour-reckoning.md) | Half-hour reckoning | · open |
| [PAY-021](PAY-021-l12-standard-work-window.md) | L12 standard work window | · open |
| [PAY-022](PAY-022-daily-straight-time.md) | Daily straight time | · open |
| [PAY-023](PAY-023-daily-overtime.md) | Daily overtime | · open |
| [PAY-024](PAY-024-daily-double-time.md) | Daily double time | · open |
| [PAY-025](PAY-025-weekly-overtime.md) | Weekly overtime | · open |
| [PAY-026](PAY-026-seventh-consecutive-day.md) | Seventh consecutive day | · open |
| [PAY-027](PAY-027-no-pyramiding.md) | No pyramiding | · open |
| [PAY-028](PAY-028-duplicate-labor-detection.md) | Duplicate labor detection | · open |
| [PAY-029](PAY-029-overlapping-labor-detection.md) | Overlapping labor detection | · open |

## D-weekend-holiday-shift

| Id | Rule | Status |
| --- | --- | --- |
| [PAY-030](PAY-030-ordinary-saturday.md) | Ordinary Saturday | · open |
| [PAY-031](PAY-031-sunday-pay.md) | Sunday pay | · open |
| [PAY-032](PAY-032-l12-holiday-calendar.md) | L12 holiday calendar | · open |
| [PAY-033](PAY-033-holiday-pay.md) | Holiday pay | · open |
| [PAY-034](PAY-034-june-december-special-saturday.md) | June/December Special Saturday | · open |
| [PAY-035](PAY-035-first-shift.md) | First shift | · open |
| [PAY-036](PAY-036-second-shift.md) | Second shift | ⚠️ conflicted |
| [PAY-037](PAY-037-third-shift.md) | Third shift | ⚠️ conflicted |
| [PAY-038](PAY-038-hazardous-material-premium.md) | Hazardous-material premium | ⚠️ conflicted |

## E-guarantees-special-pay

| Id | Rule | Status |
| --- | --- | --- |
| [PAY-039](PAY-039-reporting-pay-no-work.md) | Reporting pay-no work | · open |
| [PAY-040](PAY-040-work-provided-minimum.md) | Work-provided minimum | · open |
| [PAY-041](PAY-041-crane-remains-on-job.md) | Crane remains on job | · open |
| [PAY-042](PAY-042-first-day-travel-assembly-exception.md) | First-day travel/assembly exception | · open |
| [PAY-043](PAY-043-long-boom-premium.md) | Long-boom premium | ⚠️ conflicted |
| [PAY-044](PAY-044-lattice-boom-premium.md) | Lattice-boom premium | ⚠️ conflicted |

## F-contributions-other

| Id | Rule | Status |
| --- | --- | --- |
| [PAY-045](PAY-045-rest-period-premium.md) | Rest-period premium | · open |
| [PAY-046](PAY-046-meal-opportunity.md) | Meal opportunity | · open |
| [PAY-047](PAY-047-worked-through-lunch-adjustment.md) | Worked-through-lunch adjustment | ⚠️ conflicted |
| [PAY-048](PAY-048-standard-subsistence.md) | Standard subsistence | ⚠️ conflicted |
| [PAY-049](PAY-049-weekend-subsistence.md) | Weekend subsistence | ⚠️ conflicted |
| [PAY-050](PAY-050-union-fringe-contributions.md) | Union fringe contributions | · open |
| [PAY-051](PAY-051-step-i-pension-exclusion.md) | Step I pension exclusion | · open |
| [PAY-052](PAY-052-mileage-reimbursement.md) | Mileage reimbursement | · open |
| [PAY-053](PAY-053-toll-reimbursement.md) | Toll reimbursement | · open |
| [PAY-054](PAY-054-parking-reimbursement.md) | Parking reimbursement | · open |
| [PAY-055](PAY-055-cell-phone-reimbursement.md) | Cell-phone reimbursement | · open |
| [PAY-056](PAY-056-injury-day-pay.md) | Injury-day pay | · open |
| [PAY-057](PAY-057-vacation-eligibility-pay.md) | Vacation eligibility/pay | · open |
| [PAY-058](PAY-058-final-wages-waiting-time.md) | Final wages/waiting time | · open |

## G-audit-review-export

| Id | Rule | Status |
| --- | --- | --- |
| [PAY-059](PAY-059-pay-component-ledger.md) | Pay-component ledger | · open |
| [PAY-060](PAY-060-missing-data-issues.md) | Missing-data issues | · open |
| [PAY-061](PAY-061-employee-payroll-worklist.md) | Employee payroll worklist | · open |
| [PAY-062](PAY-062-labor-entry-detail.md) | Labor-entry detail | · open |
| [PAY-063](PAY-063-manual-adjustment.md) | Manual adjustment | · open |
| [PAY-064](PAY-064-calculation-run-log.md) | Calculation run log | · open |
| [PAY-065](PAY-065-payroll-approval.md) | Payroll approval | · open |
| [PAY-066](PAY-066-payroll-snapshot.md) | Payroll snapshot | · open |
| [PAY-067](PAY-067-adp-export.md) | ADP export | ⚠️ conflicted |
| [PAY-068](PAY-068-retroactive-correction.md) | Retroactive correction | · open |
| [PAY-069](PAY-069-money-rounding-and-rounding-adjustment-components.md) | Money rounding and rounding-adjustment components | · open |

## E-guarantees-special-pay

| Id | Rule | Status |
| --- | --- | --- |
| [PAY-070](PAY-070-foreman-premium.md) | Foreman premium | · open |
| [PAY-071](PAY-071-military-base-premium.md) | Military-base premium | · open |

## G-audit-review-export

| Id | Rule | Status |
| --- | --- | --- |
| [PAY-072](PAY-072-certified-payroll-davis-bacon-reporting.md) | Certified payroll / Davis-Bacon reporting | · open |

## F-contributions-other

| Id | Rule | Status |
| --- | --- | --- |
| [PAY-073](PAY-073-sick-pto-on-call-pay.md) | Sick / PTO / on-call pay | · open |
