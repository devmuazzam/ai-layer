---
title: City permits — section index
source: shared-folder/Project-Repository-2026-09-04 — the __CITY_PERMIT library, the permit trackers and lead-time tables, and the FAA/NOTAM and permit-waiver playbooks
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, kind/index, permits, compliance, reference-data]
entities: []
---

# City permits — section index

Everything about **acquiring** a permit: which jurisdiction, through which channel, in how long,
for what fee, and what TCG already holds. The **quoting** of permits — pricing them onto a
quotation — belongs to `quotations/`; the **in-product** Permits tab is specified in
[../project-module/05-create-and-track-permits.md](../project-module/05-create-and-track-permits.md).

> **Security warning, repeated here because it is the most important thing on this branch.**
> The 153 per-city source notes contain **live portal usernames, passwords and security-question
> answers** in plain text, in a shared SharePoint folder. None were copied into the vault. See
> [permit-acquisition-process.md](permit-acquisition-process.md) for the full statement.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [permit-acquisition-process.md](permit-acquisition-process.md) | How a permit is obtained — the five channels, annuals vs blankets, fees, insurance, the Friday closures, stacked jurisdictions, pole/self-loader rules. **Start here.** | 17.2 |
| [city-permit-reference-a-l.md](city-permit-reference-a-l.md) | Per-jurisdiction detail, Adelanto → Los Alamitos (80 rows) | 21.9 |
| [city-permit-reference-m-z.md](city-permit-reference-m-z.md) | Per-jurisdiction detail, Mammoth Lakes → Yucca Valley (69 rows) | 20.0 |
| [permit-lead-times.md](permit-lead-times.md) | The three lead-time datasets — and the 34 cities where two of them disagree | 9.3 |
| [permit-tracker-workbook.md](permit-tracker-workbook.md) | Which crane holds which annual, where, until when — 338 records, 115 of them expired | 12.4 |
| [permit-waiver.md](permit-waiver.md) | The exception that lets a short-notice job be scheduled, and what the customer signs | 6.4 |
| [faa-permits-and-notams.md](faa-permits-and-notams.md) | Airspace: the 3-mile NOTAM rule, the hotline script, the A1 survey path | 10.0 |

## The three things a reader most often needs

1. **"Can we do this job in this city by Thursday?"** →
   [../scheduling/dispatch-scheduling-path.md](../scheduling/dispatch-scheduling-path.md) for the
   permit clock, then [permit-lead-times.md](permit-lead-times.md) for the city's lead time —
   **and read the caveat there before trusting a number.**
2. **"Do we already have an annual here?"** → [permit-tracker-workbook.md](permit-tracker-workbook.md).
3. **"How do I actually file it?"** → the two city-reference pages.

## What is unsettled

- **Which of the three lead-time datasets is the "approved Permit Lead-Time Chart"** the playbooks
  require. Nothing in the drop says.
- **How the Green/Yellow/Red definitions in the playbook and in the Job Schedule Master workbook
  reconcile** — they are different rules with the same names. See
  [../scheduling/job-schedule-master-workbook.md](../scheduling/job-schedule-master-workbook.md).
- **Which system of record holds permit data** — the drop names NexgenFMS/FCC, iCranetrax and
  HubSpot/CRM in three different playbooks.

## Related

- [../scheduling/INDEX.md](../scheduling/INDEX.md) — the scheduling gate the permit path feeds
- [../quote-to-job-lifecycle.md](../quote-to-job-lifecycle.md) — where a permit sits between quote and job
- [`../../erp-review-log.md`](../../erp-review-log.md) → *Job site and permits* — the client's asks:
  map-based FAA/permit-trigger intelligence, and an annual-permit flag by city/state/zip
