---
title: Daily Allocation System (DAS) — conflict stub
source: generated/conflict-stub
migrated: 2026-08-10
updated: 2026-08-10
status: unverified
kind: conflict-stub
gap: gaps.md#daily-allocation-system-das
conflicts_with: [product/daily-allocation-system.md, product/job-project-das.md]
jira: []
topics: [daily-allocation, quotations, jobs, categories, projects, assets, dispatch, inspections]
entities: [das, job, quotation, employee, category, project, asset, field-ticket, vendor, agency]
---

# Daily Allocation System — two sources that barely overlap

**Neither of these is verified.**

This set is weaker than the other four. The two files are probably **complementary
rather than competing**, and treating them as rivals would be a misreading.

| Candidate | Size | Updated | Kind | What it uniquely covers |
| --- | --- | --- | --- | --- |
| [daily-allocation-system.md](daily-allocation-system.md) | 8.7 KB | 2026-04-30 | User stories | The only DAS specification. Seven user stories: three-panel allocation screen, drag & drop with multi-day copy, ticket dispatch lifecycle with tracking, employee & asset availability, pre-checklist management, live asset map view, vendor management in DAS, temporary employee management in DAS. |
| [job-project-das.md](job-project-das.md) | 1.7 KB | 2026-07-16 | Punch list | Mohsin feedback. **DAS is one of nine sections** — the file also covers Billing code, Price list, Project, PO, Sub category, Permit, Plan and Agency. Its DAS items are: document all non-dispatchable scenarios, asset category driven by sub-category, employee categorisation by type, quick filters, remove card/grid toggle, wording consistency for resources vs employees, "sub jobs" → "jobs". |

## Read this before treating it as a conflict

The newer file is a fifth the size and **only about a fifth of it concerns DAS at
all**. It is a cross-module punch list that happens to include DAS items, not a
competing DAS specification. The likely resolution is to split the punch list by
module and attach each part to the right spec, rather than to choose between the two.

The same is true of [quotations.md](quotations.md) and [quotation.md](quotation.md) —
cross-module punch lists filed under a single module name. That pattern is worth
fixing across the whole feedback set, not just here.

See the full entry in [`gaps.md`](../gaps.md) → *Daily Allocation System (DAS)*.
