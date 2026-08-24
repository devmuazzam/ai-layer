---
title: Payroll time rounding — start down, end up, 30-minute increments, all employees — decision
source: decision/client written statement (Brian Petros, payroll summary message, backlog batch) + as-built engine + MLA
decided: 2026-08-24
decided_by: Brian Petros stated the rule in writing ("starting times get rounded down/back to 30 minute increments… ending times get rounded up/forward… that's for all Union and non-union"); the as-built engine implements exactly this (usp_Prepare_Continuous_Labor — start down, end up, then 30-minute slices); the MLA requires half-hour reckoning. Three independent sources, zero disagreement.
status: verified
resolves: []
tags: [module/payroll, kind/decision, time-tracking, payroll-rules]
---

# Decision

Labor start times round **down** and end times round **up** to 30-minute increments, for
**all employees, union and non-union**, before pricing in half-hour slices.

This closes the FRD's open approval item (part 04 PR-014 alternatives / part 11 decision 6):
the interpretation is **start-down/end-up**, not total-duration or per-segment rounding.
Client statement, engine behaviour and contract reckoning agree; PAY-020 is settled.
