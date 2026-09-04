---
title: The Crane Guys Operating System — Ryan Adams' sales governance set
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/ — six governance documents
migrated: 2026-09-04
updated: 2026-08-06
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/dispatch, module/projects-jobs, module/accounting, kind/index, requirements, compliance, permits, scheduling, purchase-orders]
entities: []
---

# The Crane Guys Operating System — Ryan Adams' sales governance set

**What this is.** Six documents delivered together by **Ryan Adams on 2026-08-06** that describe
how TCG intends work to move from a customer's first call to a closed job. They are governance
documents, not feature specs: they define **stages, gates, owners, required records and exception
paths**, and they name (but do not contain) about twenty separate playbooks.

**Why this is a folder and not a page.** The six overlap heavily by design — one is explicitly an
index of the others, another is a duplicate register saying which controls where two conflict.
Flattening them would lose exactly the thing that makes them useful, which is *which document is
authoritative for what*.

> **None of this is built, and none of it is adjudicated.** The set is TCG's description of its
> own intended operating model as of August 2026. Several documents carry unsigned approval
> blocks and an explicit list of governance decisions still to make. Where a stage here conflicts
> with [quotation-flow-process.md](../quotation-flow-process.md) or with the 2026-05-05 meeting
> extraction in [erp-review-log.md](../../erp-review-log.md), **nothing in the drop resolves it.**

## Files

| File | Answers | KB |
| --- | --- | --- |
| [01-operating-system-architecture.md](01-operating-system-architecture.md) | **The top-level blueprint** — seven operating manuals, the 10-gate matrix, the Value Engine registry, controlled exception paths, the billing-protection layer, systems of record, metrics, and the eight governance decisions still open | 12 |
| [02-master-process-map.md](02-master-process-map.md) | **The 13-stage sequence** from lead intake to job closeout, each with its owner, exit gate and supporting playbook; the decision points and loop-backs; the exact Dispatch handoff package and Dispatch's four possible responses | 10 |
| [03-sales-coordinator-operations-manual.md](03-sales-coordinator-operations-manual.md) | **The role, in detail** — authority limits, phase-by-phase inputs/outputs/handoffs, compliance trigger table, daily operating rhythm, escalation, quality checklists, the 30/60/90 ramp and the 12-metric scorecard | 11 |
| [04-value-engine-and-playbook-index.md](04-value-engine-and-playbook-index.md) | **Which document controls** — every playbook by operating phase with owner/trigger/output/form/next-process, plus the ten-row duplicate-and-overlap register and the naming standard | 9 |
| [05-forms-and-records-matrix.md](05-forms-and-records-matrix.md) | **The 14 controlled forms** and what "complete" means for each; required records by workflow gate; the Commercial Decision and Invoice Adjustment field sets; nine controlled email templates; the escalation matrix | 12 |
| [06-value-engine-flow-and-lead-workflow.md](06-value-engine-flow-and-lead-workflow.md) | **The red/yellow/green scheduling paths** driven by permit lead time, and the (partially recoverable) hand-drawn Lead Workflow diagram from the earlier 2026-06-23 sample set | 6 |

## The one-line version

> **NO LEAD WITHOUT AN OWNER. NO QUOTE WITHOUT APPROVAL. NO CUSTOMER WITHOUT FINANCIAL CLEARANCE.
> NO JOB WITHOUT A COMPLETE JOB RECORD. NO DISPATCH HANDOFF WITHOUT A READY-TO-SCHEDULE GATE. NO
> COMPLIANCE SURPRISE. NO THIRD PARTY WITHOUT DOCUMENTED COST AND AUTHORIZATION. NO SCHEDULE
> CHANGE WITHOUT OPERATIONAL AND BILLING REVIEW. NO CUSTOMER CONFIRMATION WITHOUT DISPATCH
> COPIED. NO CONCESSION WITHOUT FACTS, MATH, GIVE-GET, AND APPROVAL.**
>
> — *Operating System Architecture* §13, Final Operating Standard

## Playbooks named but not delivered

The set references these repeatedly. **None of them is in this drop**, so nothing in the vault
knows what they say:

3D Lift Plan Playbook · Lift Plan Submission Playbook · Post-Scheduling Lift Plan Completion
Playbook · NOTAMS Playbook (and a duplicate "NOTAMS(1)") · FAA Permit / A1 Survey Playbook ·
Permit Waiver Playbook · Labor Compliance Form Distribution SOP · Davis-Bacon and Federally
Funded Jobs Playbook · Certified Payroll Playbook · **Commercial Decision Playbook** · Ready to
Schedule Playbook · Scheduling Sheet Playbook · Sales Coordinator Scheduling Value Engine ·
Day-Prior Automatic Email Playbook (v1 and v2) · Schedule Change Playbook · Invoice Adjustment
Request · Vendor coordination process.

The **Commercial Decision Playbook** is the most consequential absence: it is cited as the
authority for every discount, price match, free lift plan and concession, and it is the gate the
architecture calls *Gate 3 — Commercially Approved*.

## Related

- [../tcg-creating-quotes-sop.md](../tcg-creating-quotes-sop.md) — *Creating Quotes SOP* and the
  FCC Playbook, both cited as the Quote Development playbooks
- [../contracts-and-coi-sop.md](../contracts-and-coi-sop.md) — the *Contracts and COI SOP* and
  *COI Request Playbook*, both delivered
- [../new-customer-onboarding.md](../new-customer-onboarding.md) — the *New Customer Playbook*
  and *New Customer Packet*, both delivered
- [../hubspot-sales-playbook.md](../hubspot-sales-playbook.md) — the CRM side, with its own
  12-stage opportunity lifecycle that **does not line up** with the 13 stages here
- [../sales-expense-report-sop.md](../sales-expense-report-sop.md) — the *Sales Expense Report
  SOP*, delivered
- [../../erp-review-log.md](../../erp-review-log.md) — what TCG's own people asked the ERP for
