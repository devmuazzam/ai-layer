---
title: Payroll Concepts Reference (Shift - Job - Labor Entry)
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_CURRENT/Payroll Concepts Reference (Shift - Job - Labor Entry).html
migrated: 2026-08-13
updated: 2026-08-11
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, reference-data, architecture]
entities: [shift, job, labor-entry, anchor-date, cross-midnight]
---

# Payroll Concepts Reference

Terminology and hierarchy — generated for Payroll Manager review.

**This is the containment model the whole payroll calculation rests on.** Get the anchor-date
rule wrong and every cross-midnight entry lands in the wrong pay period.

## The three levels

| Level | Also called | What it is |
| --- | --- | --- |
| **Shift** | Dispatch | The highest-level grouping. One shift represents an employee's overall work engagement and can contain **multiple Jobs**. |
| **Job** | JobCode | A specific work assignment within a Shift. One job can have **multiple Labor Entries** attached to it. |
| **Labor Entry** | JobTicket | A single, continuous block of work with a defined **Start** and **End** time. |

## Containment hierarchy

```
Shift (Dispatch)
├── Job A (JobCode)
│   ├── Labor Entry 1 (JobTicket)   08:00 → 10:30    ⚓ anchor: 08:00 date
│   └── Labor Entry 2 (JobTicket)   11:00 → 14:15    ⚓ anchor: 11:00 date
└── Job B (JobCode)
    └── Labor Entry 3 (JobTicket)   22:30 (Day 1) → 02:00 (Day 2)
                                    🌙 spans midnight
                                    ⚓ anchor: 22:30 date (Day 1)
```

A single Shift (Dispatch) contains multiple Jobs (JobCodes), each with their own Labor Entries
(JobTickets).

## The anchor-date rule

> The **anchor date** is always the **start** time, even if the entry spans past midnight into
> the next calendar day.

Worked example from the source document: Labor Entry 3 begins at **22:30 on Day 1** and ends at
**02:00 on Day 2**, crossing midnight. Despite spanning two calendar days, the **anchor date
remains Day 1** (the date of the *start* time). The portion of the entry falling on Day 2's
calendar is still "owned" by Day 1 for payroll purposes.

## Who captures this

**Payroll does not create labor entries — the field-ops mobile app does.** The capture side is
specified separately, in documents migrated from Confluence a month before these:
`FR-FOP-023` Labor Details, `FR-FOP-012` Start Work, `FR-FOP-016` End Work, and the lunch trio
`FR-FOP-013`/`014`/`015`. See
[../field-ops/field-ops-mobile-INDEX.md](../field-ops/field-ops-mobile-INDEX.md) first — three
competing documents describe that app and none is authoritative.

Nothing in those documents states the anchor-date rule below. Whether the mobile app assigns a
cross-midnight entry to its start date is therefore **unstated on the capture side** and merely
*assumed* here.

## Why this matters downstream

- The Saturday–Friday pay period is assigned from the anchor date, not from where the hours fall.
- Daily accumulation thresholds (8 h straight time, 12 h double time) accumulate against the
  anchor date.
- Day type — Saturday, Sunday, holiday, Special Saturday — is resolved against the anchor date.
  The ERP requirements document flags **cross-midnight day-type policy** as an open decision
  (see [erp-payroll-module-frd/04-work-time-reconstruction.md](erp-payroll-module-frd/04-work-time-reconstruction.md),
  `PR-013`), so the anchor rule here should not be assumed to settle day-type treatment for the
  Day 2 portion.
