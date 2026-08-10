---
title: Customer — conflict stub
source: generated/conflict-stub
migrated: 2026-08-10
updated: 2026-08-10
status: unverified
kind: conflict-stub
gap: gaps.md#customer
conflicts_with: [product/customer.md, product/customer-and-job-sites.md, product/discussion-points-with-mohsin.md, product/discussion-points-with-tcg-team.md, product/user-story-and-tasks.md]
jira: []
topics: [customers, job-sites, open-questions]
entities: [customer, job-site, industry-code, fcc]
---

# Customer and Job Site — five sources, three of them copies

**None of these is verified. Do not answer from one of them alone.**

This set is mostly a copy-paste problem, not a disagreement. Resolving it is largely
deletion, not adjudication.

| Candidate | Size | Updated | Kind | What it uniquely covers |
| --- | --- | --- | --- | --- |
| [customer.md](customer.md) | 6.1 KB | 2026-07-16 | Punch list | Mohsin feedback. Largest source. UI consistency across the module — filters, pagination, help-button colour, table widths. Almost entirely presentation-level. |
| [user-story-and-tasks.md](user-story-and-tasks.md) | 4.3 KB | 2026-04-22 | User stories | The only acceptance-criteria-level spec: customer search, pagination defaults, colour-coded activity status (green/yellow/red by inactivity), salesperson & coordinator association, and self-service onboarding via secure link with Pending Approval state. **From a personal space.** |
| [customer-and-job-sites.md](customer-and-job-sites.md) | 1.2 KB | 2026-06-12 | Punch list | JZ feedback. Job-site contacts and certificates, insurance expiry, billing terms/due dates, and a "Feedback on new Design" block (remove forecast, top-10 accounts by revenue, draggable columns). Contains the only non-migrated image in the vault. |
| [discussion-points-with-tcg-team.md](discussion-points-with-tcg-team.md) | 0.8 KB | 2026-06-25 | Open questions | Questions to ask the client, spanning customers, employees, yards, DAS, categories and yard operations. |
| [discussion-points-with-mohsin.md](discussion-points-with-mohsin.md) | 0.2 KB | 2026-06-25 | Open questions | Two job-site questions. |

## This is duplication, not disagreement

- `discussion-points-with-mohsin.md` is **word-for-word the "Job Site" section of
  `customer-and-job-sites.md`**, including the same two typos ("seperate", "its").
  It is a copy-paste fragment, not an independent document.
- The customer bullets in `discussion-points-with-tcg-team.md` are **the same lines**
  as the "Customer" section of `customer-and-job-sites.md`.
- Its yards/billing-code question is duplicated verbatim in
  [billing-code-and-price-list.md](billing-code-and-price-list.md).

So the five files contain roughly three documents' worth of distinct content.

**Unanswered throughout:** all five reference **FCC** as a system of record ("verify
from FCC", "Add all FCC fields", "Customer-FCC") and nothing anywhere in the vault
says what FCC is.

See the full entry in [`gaps.md`](../gaps.md) → *Customer*.
