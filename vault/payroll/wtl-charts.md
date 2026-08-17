---
title: Worked Through Lunch (WTL) Charts - Payroll / Billing
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_CURRENT/Worked Through Lunch Charts- Payroll_Billing.pdf
migrated: 2026-08-13
updated: 2026-01-23
status: unverified
conflicts_with: []
jira: []
topics: [payroll, wtl, meal-period, overtime, billing]
entities: [wtl, meal-period, lunch-break-marker, overtime, double-time]
---

# Worked Through Lunch (WTL) Charts

Revised by **Danny Bryan and Mike Vlaming, 2026-01-23**. The charts state they follow the
ruling in the Local 12 Master Labor Agreement book, **page 26, section F**.

These are the hand-built payroll/billing lookup charts — the closest thing in this document
set to a worked reference for how WTL penalties land against the Reg / OT / DT buckets. They
cover the same rule the legacy Payroll App implements as `WTL_MEAL_DEDUCT`, `WTL_DT_FLOOR`
and `WTL_APPLICABLE_ADD`
(see [payroll-app-current-state/03-payroll-rule-catalog.md](payroll-app-current-state/03-payroll-rule-catalog.md)).

> **Reproduced as written.** The source charts contain arithmetic that does not always
> reconcile — e.g. on the Monday–Friday chart several rows in the 14.5–16 hour band repeat a
> "12.5 + 1 (.5hr) WTL Penalties" billed figure that does not follow the column, and the
> Saturday chart's 19-hour row jumps to 21.5 total. These are left exactly as they appear.
> Do not treat the charts as an arithmetic authority without a payroll-team confirmation.

## Lunch break markers

| Meal | Triggered at |
| --- | --- |
| First lunch break | 5:01 hour mark |
| Second lunch break | 10.5:01 hour mark |
| Third lunch break | 16:01 hour mark |
| Fourth lunch break | 21.5:01 hour mark |

> **These four values are the thing the field-ops BRS says it does not have.**
> `BRS-LUNCH-005` *Lunch Threshold Values* in [../product/brs.md](../product/brs.md) is marked
> **📄 Needs Supporting Documentation**. This table, plus the 5-consecutive-hour rule in
> [mcog-l12-mla-2025-2028/01-article-iii-working-rules.md](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md),
> is that documentation — arriving from a different source, four months later, unreconciled.
>
> **And they do not agree on how many lunches exist.** `BRS-LUNCH-002` lists three (First,
> Second, Third). This chart and the Payroll App's `WTL_0`…`WTL_4` token states model **four**.
> Do not silently pick one. See [payroll/gaps.md](gaps.md) → *Field-ops lunch capture vs payroll WTL*.

**Qualifying-lunch verbiage (as written):** "You are not eligible for a lunch break unless you
work 5.5 hours or more, in accordance with California / Union meal period requirements."

## Day-type notes (as written on the Monday–Friday chart)

- `WORK TIME + (0.5 DBL 1ST WTL) = COLUMN B TOTAL`
- **Saturday:** applicable rate (e.g. 8 hrs plus 1 missed lunch = 8 hrs plus an extra 0.5 hr). WTL are **OVERTIME until 12.5 hours worked**.
- **Sunday:** applicable rate (e.g. 8 hrs plus 1 missed lunch = 8 hrs plus an extra 0.5 hr).
- Not applicable if the crew only works 5 hours.


## Monday–Friday (straight-time day)

| WTL amounts | Actual Time | TOTAL Hours with WTL included | Paid Hours | Notes | Billed Hours |
| --- | --- | --- | --- | --- | --- |
| NA | 5 Hours | 5 | 5 | Not applicable if guys only work 5 hours | 5 hours |
| 1 WTL | 5.5 Hours | 5.5 | 5 Reg + (0.5 DBL 1ST WTL) | Regular Hours decrease by .5 to add lunch dbl time | 5.5 Hours + WTL Penality |
|   | 6 Hours | 6 | 5.5 Reg + (0.5 DBL 1ST WTL) | Regular Hours decrease by .5 to add lunch dbl time | 6 Hours +WTL Penality |
|   | 6.5 Hours | 6.5 | 6 reg + (0.5 DBL 1ST WTL) | Regular Hours decrease by .5 to add lunch dbl time | 6.5 Hours + WTL Penality |
|   | 7 Hours | 7 | 6.5 reg + (0.5 DBL 1ST WTL) | Regular Hours decrease by .5 to add lunch dbl time | 7 Hours + WTL Penality |
|   | 7.5 Hours | 7.5 | 7 reg +(0.5 DBL 1ST WTL) | Regular Hours decrease by .5 to add lunch dbl time | 7.5 + WTL Penality |
|   | 8 Hours | 8 | 7.5 Reg + (0.5 DBL 1ST WTL) | Regular Hours decrease by .5 to add lunch dbl time | 8 + WTL Penality |
|   | 8.5 Hours | 8.5 | 8 Reg + (0.5 DBL 1ST WTL) | Regular Hours decrease by .5 to add lunch dbl time | 8.5 + WTL Penality |
|   | 9 Hours | 9 | 8 Reg +.5 OT + (0.5 DBL 1ST WTL) | OT decreased by .5 hours and add .5 for DBL | 9 + WTL Penality |
|   | 9.5 hours | 9.5 | 8 Reg + 1 OT +(0.5 DBL 1ST WTL) | OT decreased by .5 hours and add .5 for DBL | 10 + WTL Penality |
|   | 10 Hours | 10 | 8 Reg + 1.5 OT + (0.5 DBL 1ST WTL) | OT decreased by .5 hours and add .5 for DBL | 10 + WTL Penality |
|   | 10.5 Hours | 10.5 | 8 Reg + 2 OT + (0.5 DBL 1ST WTL) | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (OT) | 10.5 + 2 WTL Penalities |
| 2 WTL | 11 Hours | 11.5 | 8 Reg + 2.5 OT + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL) | OT decreased by .5 hours and add .5 for DBL | 11 + 1 (.5hr) WTL Penalties, 8 Reg, 2.5 OT, .5HR PT |
|   | 11.5 Hours | 12 | 8 Reg +3 OT + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL) | OT decreased by .5 hours and add .5 for DBL | 11.5 + 1 (.5hr) WTL Penalties, 8 Reg,3 OT, .5HR PT |
|   | 12 Hours | 12.5 | 8 Reg + 3.5 OT + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL) | OT decreased by .5 hours and add .5 for DBL | 12+ 1 (.5hr) WTL Penalties, 8 Reg,3.5 OT, .5HR PT |
|   | 12.5 Hours | 13 | 8 Reg + 4 OT ( work time )+ (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 12.5 + 1 (.5hr) WTL Penalties |
|   | 13 Hours | 13.5 | 8 Reg + 4 OT + 0.5 DBL ( work time) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 13 + 1 (.5hr) WTL Penalties |
|   | 13.5 Hours | 14 | 8 Reg + 4 OT + 1 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 14 + 1 (.5hr) WTL Penalties |
|   | 14 Hours | 14.5 | 8 Reg + 4 OT + 1.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 15 + 1 (.5hr) WTL Penalties |
|   | 14.5 Hours | 15 | 8 Reg + 4 OT + 2 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 12.5 + 1 (.5hr) WTL Penalties |
|   | 15 Hours | 15.5 | 8 Reg + 4 OT + 2.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 12.5 + 1 (.5hr) WTL Penalties |
|   | 15.5 Hours | 16 | 8 Reg + 4 OT + 3 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 12.5 + 1 (.5hr) WTL Penalties |
|   | 16 Hours | 16.5 | 8 Reg + 4 OT + 3.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 12.5 + 1 (.5hr) WTL Penalties |
| 3 WTL | 16.5 | 17.5 | 8 Reg + 4 OT +4 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 16.5 + 1 (.5hr) WTL Penalties |
|   | 17 | 18 | 8 Reg + 4 OT + 4.5 DBL ( work time ) +(0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 17 + 1 (.5hr) WTL Penalties |
|   | 17.5 | 18.5 | 8 Reg + 4 OT +5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 17.5 + 1 (.5hr) WTL Penalties |
|   | 18 | 19 | 8 Reg + 4 OT + 5.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 18 + 1 (.5hr) WTL Penalties |
|   | 18.5 | 19.5 | 8 Reg + 4 OT + 6 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 18.5+ 1 (.5hr) WTL Penalties |
|   | 19 | 20 | 8 Reg + 4 OT + 6.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 19+ 1 (.5hr) WTL Penalties |
|   | 19.5 | 20.5 | 8 Reg + 4 OT +7 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 19.5 + 1 (.5hr) WTL Penalties |
|   | 20 | 21 | 8 Reg + 4 OT + 7.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 20+ 1 (.5hr) WTL Penalties |
|   | 20.5 | 21.5 | 8 Reg + 4 OT, 8 dbl (work) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 20.5 + 1 (.5hr) WTL Penalties |
|   | 21 | 22 | 8 Reg + 4 OT, 8.5 dbl (work) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours | 21.5 + 1 (.5hr) WTL Penalties |
|   | 21.5 | 22.5 | 8 reg + 4 OT 9DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours |   |
| 4 WTL | 22 | 23.5 | 8 reg + 4 OT, 9.5 DBL ( work time ) +(0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours |   |
|   | 22.5 | 24 | 8 reg + 4 OT, 10 DBL ( work time )+ (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |
|   | 23 | 24.5 | 8 reg + 4 OT, 10.5 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |
|   | 23.5 | 25 | 8 reg + 4 OT, 11 DBL +( work time ) (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) | 1st DBL time WTL is already included into DBL time hours, additional WTL penalties get added accordingly as additional DBL hours |   |
|   | 24 | 25.5 | 8 reg + 4 OT, 11.5 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |
|   | 24.5 | 26 | 8 reg + 4 OT, 12 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |
|   | 25 | 26.5 | 8 reg + 4 OT, 12.5 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |
|   | 25.5 | 27 | 8 reg + 4 OT, 13 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |
|   | 26 | 27.5 | 8 reg + 4 OT, 13.5 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |
|   |   |   | Third Lunch break : at 16:01 hour mark |   |   |

## Saturday / overtime day

| WTL amounts | Actual Time | TOTAL Hours with WTL included | Paid Hours | WTL | Notes | Billed Hours |
| --- | --- | --- | --- | --- | --- | --- |
| NA | 5 Hours | 5 | 5 | x | Not applicable if guys only work 5 hours | 5 hours |
| 1 WTL | 5.5 Hours | 6 | 5.5 OT + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 5.5 Hours + WTL Penality |
|   | 6 Hours | 6.5 | 6 OT + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 6 Hours +WTL Penality |
|   | 6.5 Hours | 7 | 6.5 OT + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 6.5 Hours + WTL Penality |
|   | 7 Hours | 7.5 | 7 OT + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 7 Hours + WTL Penality |
|   | 7.5 Hours | 8 | 7.5 OT +(0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 7.5 + WTL Penality |
|   | 8 Hours | 8.5 | 8 OT + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 8 + WTL Penality |
|   | 8.5 Hours | 9 | 8.5 OT + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 8.5 + WTL Penality |
|   | 9 Hours | 9.5 | 9 OT + (0.5 DBL 1ST WTL) | x | OT decreased by .5 hours and add .5 for DBL | 9 + WTL Penality |
|   | 9.5 Hours | 10 | 9.5 DBL + (0.5 DBL 1ST WTL) |   |   |   |
|   | 10 Hours | 10.5 | 10 OT + (0.5 DBL 1ST WTL) | x | OT decreased by .5 hours and add .5 for DBL | 10 + WTL Penality |
|   | 10.5 Hours | 11 | 10.5 OT + (0.5 DBL 1ST WTL) | x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (OT) | 10.5 + 2 WTL Penalities |
| 2 WTL | 11 Hours | 12 | 11 OT + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL) | x ,x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (OT) | 11 + 2 WTL Penalities |
|   | 11.5 Hours | 12.5 | 11.5 OT + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL) | x ,x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (OT) | 11.5 +2 WTL Penalities |
|   | 12 Hours | 13 | 12 OT + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL) | x ,x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (OT) | 12 +2 WTL Penalities |
|   | 12.5 Hours | 13.5 | 12 OT 0.5 DBL + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (DBL) | 12.5 + 2 WTL Penalities |
|   | 13 Hours | 14 | 12 OT + 1 DBL ( work time )+ (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (DBL) | 13 + 2 WTL Penalities |
|   | 13.5 Hours | 14.5 | 12 OT + 1.5 DBL ( work time) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 13.5 + 2 WTL Penalities |
|   | 14 Hours | 15 | 12 OT + 2 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 14 + 2 WTL Penalities |
|   | 14.5 Hours | 15.5 | 12 OT + 2.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 14.5 + 2 WTL Penalities |
|   | 15 Hours | 16 | 12 OT + 3 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 15 + 2 WTL Penalities |
|   | 15.5 Hours | 16.5 | 12 OT + 3.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 15.5 + 2 WTL Penalities |
|   | 16 Hours | 17 | 12 OT + 4 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 16 + 2 WTL Penalities |
| 3 WTL | 16.5 | 18 | 12 OT + 4.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 16.5 + 3 WTL Penalities |
|   | 17 | 18.5 | 12 OT + 5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 17 + 3 WTL Penalities |
|   | 17.5 | 19 | 12 OT + 5.5 DBL ( work time ) +(0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 17.5 + 3 WTL Penalities |
|   | 18 | 19.5 | 12 OT +6 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 18 + 3 WTL Penalities |
|   | 18.5 | 20 | 12 OT + 6.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 18.5 + 3 WTL Penalities |
|   | 19 | 21.5 | 12 OT + 7 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 19 + 3 WTL Penalities |
|   | 19.5 | 21 | 12 OT + 7.5 DBL( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 19.5 + 3 WTL Penalities |
|   | 20 | 21.5 | 12 OT + 8 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 20 + 3 WTL Penalities |
|   | 20.5 | 22 | 12 OT + 8.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 20.5 + 3 WTL Penalities |
|   | 21 | 22.5 | 12 OT +9 DBL (work time) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) |   |   | 21 + 3 WTL Penalities |
|   | 21.5 | 22.5 | 12 OT +9.5 DBL (work time) + (0.5 dbl 1st WTL + .5 DBL 2nd WTL + 0.5 DBL 3RD WTL) |   |   |   |
| 4 WTL | 22 | 23.5 | 12 OT + 10 DBL (work time) + (0.5 dbl 1st WTL + .5 DBL 2nd WTL+ 0.5 DBL 3RD WTL + 0.5 DBL (4th WTL) |   |   |   |
|   | 22.5 | 24 | 12 OT + 10.5 DBL ( work time )+ (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 23 | 24.5 | 12 OT + 11 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 23.5 | 25 | 12 OT + 12 DBL ( work time ) (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 24 | 25.5 | 12 OT + 12.5 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 24.5 | 26 | 8 reg + 16 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 25 | 26.5 | 8 reg + 16.5 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 25.5 | 27 | 8 reg + 17 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 26 | 27.5 | 8 reg + 17.5 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |

## Sunday / double-time day

| WTL amounts | Worked Hours | TOTAL Hours with WTL included | Paid Hours | WTL | Notes | Billed Hours |
| --- | --- | --- | --- | --- | --- | --- |
| NA | 5 Hours | 5 | 5 | x | Not applicable if guys only work 5 hours | 5 hours |
| 1 WTL | 5.5 Hours | 6 | 5.5 DBL + (0.5 DBL1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 5.5 Hours + WTL Penality |
|   | 6 Hours | 6.5 | 6 DBL + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 6 Hours +WTL Penality |
|   | 6.5 Hours | 7 | 6.5 DBL + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 6.5 Hours + WTL Penality |
|   | 7 Hours | 7.5 | 7 DBL + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 7 Hours + WTL Penality |
|   | 7.5 Hours | 8 | 7.5 DBL +(0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 7.5 + WTL Penality |
|   | 8 Hours | 8.5 | 8 DBL + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 8 + WTL Penality |
|   | 8.5 Hours | 9 | 8.5 DBL + (0.5 DBL 1ST WTL) | x | Regular Hours decrease by .5 to add lunch dbl time | 8.5 + WTL Penality |
|   | 9 Hours | 9.5 | 9 DBL + (0.5 DBL 1ST WTL) | x | OT decreased by .5 hours and add .5 for DBL | 9 + WTL Penality |
|   | 9.5 Hours | 10 | 9.5 DBL + (0.5 DBL 1ST WTL) | x | OT decreased by .5 hours and add .5 for DBL | 9 + WTL Penality |
|   | 10 Hours | 10.5 | 10 DBL+ (0.5 DBL 1ST WTL) | x | OT decreased by .5 hours and add .5 for DBL | 10 + WTL Penality |
|   | 10.5 Hours | 11 | 10.5 DBL + (0.5 DBL 1ST WTL) | x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (OT) | 10.5 + 2 WTL Penalities |
| 2 WTL | 11 Hours | 12 | 11 DBL + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL) | x ,x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (OT) | 11 + 2 WTL Penalities |
|   | 11.5 Hours | 12.5 | 11.5 DBL + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL) | x ,x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (OT) | 11.5 +2 WTL Penalities |
|   | 12 Hours | 13 | 12 DBL + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL) | x ,x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (OT) | 12 +2 WTL Penalities |
|   | 12.5 Hours | 13.5 | 12.5 DBL + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (DBL) | 12.5 + 2 WTL Penalities |
|   | 13 Hours | 14 | 13 DBL ( work time )+ (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x | OT decreased by .5 hours and add .5 for DBL for 1st lunch then add an additional half hour at applicable rate for 2nd lunch (DBL) | 13 + 2 WTL Penalities |
|   | 13.5 Hours | 14.5 | 13.5 DBL ( work time) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 13.5 + 2 WTL Penalities |
|   | 14 Hours | 15 | 14 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 14 + 2 WTL Penalities |
|   | 14.5 Hours | 15.5 | 14.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 14.5 + 2 WTL Penalities |
|   | 15 Hours | 16 | 15 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 15 + 2 WTL Penalities |
|   | 15.5 Hours | 16.5 | 15.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 15.5 + 2 WTL Penalities |
|   | 16 Hours | 17 | 16 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL) | x ,x |   | 16 + 2 WTL Penalities |
| 3 WTL | 16.5 | 17.5 | 16.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 16.5 + 3 WTL Penalities |
|   | 17 | 18 | 17 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 17 + 3 WTL Penalities |
|   | 17.5 | 18.5 | 17.5 DBL ( work time ) +(0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 17.5 + 3 WTL Penalities |
|   | 18 | 19 | 18 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 18 + 3 WTL Penalities |
|   | 18.5 | 19.5 | 18.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 18.5 + 3 WTL Penalities |
|   | 19 | 20 | 19 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 19 + 3 WTL Penalities |
|   | 19.5 | 20.5 | 19.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 19.5 + 3 WTL Penalities |
|   | 20 | 21 | 20 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 20 + 3 WTL Penalities |
|   | 20.5 | 21.5 | 20.5 DBL ( work time ) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) | x,x,x |   | 20.5 + 3 WTL Penalities |
|   | 21 | 22 | 21 dbl (work time) + (0.5 DBL 1st WTL + 0.5 DBL 2nd WTL + 0.5 DBL 3RD WTL) |   |   | 21 + 3 WTL Penalities |
|   | 21.5 | 22.5 | 21.5 DBL (work time) + (0.5 dbl 1st WTL + .5 DBL 2nd WTL + 0.5 DBL 3RD WTL) |   |   |   |
| 4 WTL | 22 | 23.5 | 22 DBL (work time) + (0.5 dbl 1st WTL + .5 DBL 2nd WTL+ 0.5 DBL 3RD WTL + 0.5 DBL (4th WTL) |   |   |   |
|   | 22.5 | 24 | 22.5 DBL ( work time )+ (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 23 | 24.5 | 23 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 23.5 | 25 | 23.5 DBL ( work time ) (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 24 | 25.5 | 24 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 24.5 | 26 | 24.5 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 25 | 26.5 | 25 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 25.5 | 27 | 25.5 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
|   | 26 | 27.5 | 26 DBL ( work time ) + (0.5 dbl (1st WTL) + .5 DBL ( 2nd WTL) + 0.5 DBL (3RD WTL)+ 0.5 DBL (4th WTL) |   |   |   |
