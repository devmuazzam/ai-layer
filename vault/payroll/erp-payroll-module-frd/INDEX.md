---
title: The Crane Guys ERP Payroll Module - Payroll Business Rules and System Requirements
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, requirements, payroll-rules]
entities: [payroll-rule, payroll-group, pay-component, adp-export]
---

# ERP Payroll Module — requirements catalog

**Document status: Draft 0.1 — Initial requirements catalog. Prepared for CodingCops by
The Crane Guys.** This is the closest thing in the vault to a payroll FRD: it defines the
activities, source information, payroll rules, system triggers, calculations, review controls
and outputs required for the Payroll module of the new ERP.

Split into 11 parts on migration. The original is a single 36-page PDF.

> **`PR-###` ids are ambiguous across documents.** This document and
> [../codingcops-rule-matrix.md](../codingcops-rule-matrix.md) both number their rules
> `PR-001…`, independently. `PR-010` is *Non-Union Salary Rate* here and *L12 union
> base rate* there. **Always cite the document as well as the id.** Same failure mode as the
> `FR-FOP-NNN` ambiguity in the main vault index.

> **Not legal advice.** The document says so explicitly: union contract interpretations and
> California payroll rules must be reviewed and approved by TCG management, the payroll team,
> labor counsel, and union representatives.

## Parts

| Part | Sections | Answers |
| --- | --- | --- |
| [01-purpose-scope-and-design-principles.md](01-purpose-scope-and-design-principles.md) | 1–2 | What must the module do, and what are the non-negotiable design principles? (configuration-driven rules, explainable calculations, eligibility before calculation, effective-dating, no unexplained overwriting) |
| [02-payroll-period-and-source-data.md](02-payroll-period-and-source-data.md) | 3–4 | Saturday–Friday workweek, period status workflow, and the required employee / labor / job-ticket master data |
| [03-payroll-groups-and-rate-determination.md](03-payroll-groups-and-rate-determination.md) | 5–6 | How is an employee classified, and which rate wins? |
| [04-work-time-reconstruction.md](04-work-time-reconstruction.md) | 7 | Time-source priority, cross-midnight, half-hour reckoning, the 06:00–17:00 window, daily OT/DT, no pyramiding |
| [05-weekend-holiday-and-shift-rules.md](05-weekend-holiday-and-shift-rules.md) | 9–10 | Holiday calendar and pay, Saturday, Sunday, June/December Special Saturday, the three shifts |
| [06-boom-equipment-and-guaranteed-hours.md](06-boom-equipment-and-guaranteed-hours.md) | 11–12 | Long boom, hazmat, higher-rate-for-the-day, reporting pay, work-provided minimum, crane-remains-on-job |
| [07-rest-meal-and-subsistence.md](07-rest-meal-and-subsistence.md) | 13–15 | Eight-hour rest rule, meal opportunity / WTL, subsistence, tolls, mileage |
| [08-non-union-apprentice-and-fringe.md](08-non-union-apprentice-and-fringe.md) | 16–18 | Non-union hourly and salary paths, apprentice wage steps, fringe contributions, other reimbursements |
| [09-data-quality-ledger-and-review.md](09-data-quality-ledger-and-review.md) | 19–21 | Missing-information rules, duplicate/overlap detection, the pay component ledger, the review interface |
| [10-approval-close-export-and-adjustments.md](10-approval-close-export-and-adjustments.md) | 22–23 | Calculation run, approval, snapshot, ADP export, manual adjustments |
| [11-security-decisions-and-acceptance.md](11-security-decisions-and-acceptance.md) | 24–28 | Roles, the 24 required management/legal decisions, acceptance criteria, and the 5-phase implementation priority |

Note: the source document has **no section 8** — it jumps from 7 to 9.

## The five design principles (section 2)

These constrain every rule below them, so read part 01 before any other part:

1. **Configuration-driven rules** — a rule change should be an effective-dated configuration
   record, not a code change.
2. **Explainable calculations** — every calculated dollar traces to employee, labor entry,
   payroll group, source time, base rate, premium rate, multiplier, hours, the rule, the config
   version, the run, and any manual adjustment.
3. **Rule eligibility before rule calculation** — determine that a rule does *not* apply before
   running it, rather than calculating and then removing. Each rule resolves to one of:
   Calculate / Review only / Warn / Not applicable / Blocked pending missing information.
4. **Effective-dated processing** — recalculating a historical period must use the configuration
   effective on the *work date*, not today's.
5. **No unexplained overwriting** — keep source-reported rate, employee-master rate, union craft
   rate, craft modifier, calculated effective rate, final approved rate, *and the reason the
   final rate was selected*.

## Where the answers are unsettled

Section 25 lists **24 issues that must be resolved before CodingCops treats the rule catalog as
final** — see part 11. Those are open product questions, not implementation detail, and they are
recorded in [payroll/gaps.md](../gaps.md).
