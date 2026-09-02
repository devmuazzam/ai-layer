---
title: Quantity N on a quotation line becomes N DAS/Yard sets
source: Fouzan Shakil (assignee, SCRUM-907 / SCRUM-892)
migrated: 2026-08-20
updated: 2026-08-31
status: superseded
superseded_by: decisions/2026-08-31-quotation-qty-not-das-sets.md
conflicts_with: []
jira: [SCRUM-907, SCRUM-892]
tags: [module/dispatch, module/projects-jobs, module/quotations, kind/decision, daily-allocation]
entities: [QuotationResource, JobResource, DAS]
---

# Quantity-based DAS sets — SUPERSEDED

> **Superseded 2026-08-31** by
> [`decisions/2026-08-31-quotation-qty-not-das-sets.md`](2026-08-31-quotation-qty-not-das-sets.md).
> Quantity is a billing scalar; it must **not** explode into N DAS/Yard sets, and
> parent qty must not carry onto children. Kept for history only.

Decided by **Fouzan Shakil** while implementing SCRUM-907 (duplicates SCRUM-892).
Recorded after a PR review flagged the rules as unsourced. This file is **not**
Confluence; it is a named-human decision.

## What to show (historical — do not implement)

A quotation resource with quantity N (integer ≥ 2) must produce **N independent
sets** on DAS and Yard Operations. The quotation PDF and quote totals stay **one
priced line** (N × rate).

## What each job clone is billed as (historical)

Each of the N job-resource trees is `qty = 1`. **Rate is copied unchanged** (the
unit rate, not N × rate). **Amounts and hours are split across the N clones** so
they **sum to the original quotation line** (remainder cents on the last clone).

This is the 1/N-of-the-line-amount rule, not “each set carries the full line.”
Carrying the full line on every set would multiply invoiced job-resource totals
by N.

## What does not explode (historical)

- Mobilization / Demobilization / Crane Time **group** roots (`isGroup`), even
  when qty > 1. Group totals are the sum of checked children.
- qty < 1 or non-finite qty → **one** set (do not explode; do not error convert).

## Backfill of already-converted jobs (historical)

Default: **do not rewrite jobs that already have allocations** (anything already
dispatched). Clone-1 ids stay put when a job *is* exploded, so allocations on
set 1 would survive — but splitting money under live allocations is still
opt-in.

The explode backfill script was removed when this decision was superseded.

## What this does not authorise

- Re-exploding if someone later edits job-resource qty by hand.
- Changing quotation-line billing (still one line).
