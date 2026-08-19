---
title: Quantity N on a quotation line becomes N DAS/Yard sets
source: Fouzan Shakil (assignee, SCRUM-907 / SCRUM-892)
migrated: 2026-08-20
updated: 2026-08-20
status: reference
conflicts_with: []
jira: [SCRUM-907, SCRUM-892]
topics: [quotations, daily-allocation, jobs]
entities: [QuotationResource, JobResource, DAS]
---

# Quantity-based DAS sets

Decided by **Fouzan Shakil** while implementing SCRUM-907 (duplicates SCRUM-892).
Recorded after a PR review flagged the rules as unsourced. This file is **not**
Confluence; it is a named-human decision.

## What to show

A quotation resource with quantity N (integer ≥ 2) must produce **N independent
sets** on DAS and Yard Operations. The quotation PDF and quote totals stay **one
priced line** (N × rate).

## What each job clone is billed as

Each of the N job-resource trees is `qty = 1`. **Rate is copied unchanged** (the
unit rate, not N × rate). **Amounts and hours are split across the N clones** so
they **sum to the original quotation line** (remainder cents on the last clone).

This is the 1/N-of-the-line-amount rule, not “each set carries the full line.”
Carrying the full line on every set would multiply invoiced job-resource totals
by N.

## What does not explode

- Mobilization / Demobilization / Crane Time **group** roots (`isGroup`), even
  when qty > 1. Group totals are the sum of checked children.
- qty < 1 or non-finite qty → **one** set (do not explode; do not error convert).

## Backfill of already-converted jobs

Default: **do not rewrite jobs that already have allocations** (anything already
dispatched). Clone-1 ids stay put when a job *is* exploded, so allocations on
set 1 would survive — but splitting money under live allocations is still
opt-in.

Run `prisma/scripts/backfill-job-quantity-sets.ts` with `--include-allocated`
only when a named owner has accepted rewriting dispatched jobs. Optional
`--tenant=<uuid>` limits the run to one tenant.

## What this does not authorise

- Re-exploding if someone later edits job-resource qty by hand.
- Changing quotation-line billing (still one line).
