---
title: Quotation quantity is a billing scalar — not DAS/Yard set count
source: Fouzan Shakil (assignee, SCRUM-907 / SCRUM-892 — reversing prior approach)
migrated: 2026-08-31
updated: 2026-08-31
status: reference
conflicts_with: []
supersedes: [decisions/2026-08-20-quantity-based-das-sets.md]
jira: [SCRUM-907, SCRUM-892]
tags: [module/dispatch, module/projects-jobs, module/quotations, kind/decision, daily-allocation]
entities: [QuotationResource, JobResource, DAS]
---

# Quotation quantity does not create DAS/Yard sets

Decided by **Fouzan Shakil** on 2026-08-31: the SCRUM-907 / SCRUM-892 approach of
exploding quantity N into N DAS/Yard sets was **not** the right product behaviour.
This note supersedes `decisions/2026-08-20-quantity-based-das-sets.md`.

## What quantity means

Quantity on a quotation resource is a **billing scalar** (`qty × rate` on that line).
Convert-to-job copies the tree **1:1**: one quotation root → one job-resource root
→ **one** DAS / Yard Operations set, with the quoted qty preserved on that root.

Multiple sets come from **multiple root resources** on the quotation, not from
raising qty on a single line.

## Child quantity

Parent quantity must **not** cascade onto associated / child resources, and new
children must **not** inherit the parent's quantity. Each child keeps its own qty
(default `1` when created empty).

## Already-converted jobs

Jobs already exploded under the superseded decision are **left as-is** unless a
named owner later accepts a reverse backfill. Forward convert behaviour only.

## What this does not change

- Quotation PDF / quote totals remain one priced line per resource row.
- Mobilization / Demobilization / Crane Time group billing rules are unchanged.
