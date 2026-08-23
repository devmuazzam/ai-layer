---
title: Quotations — module index
status: reference
kind: index
updated: 2026-08-24
tags: [module/quotations, kind/reference]
---

# Quotations

Quotations, pricing, billing codes, mob/demob. Backend usecases: `quotations, quotation-*, billing-code*, price-listings, surcharges, docusign`. Organized per [STRUCTURE.md](../STRUCTURE.md).

> **Conflict stub first:** [quotations-INDEX.md](quotations-INDEX.md) — competing sources, none verified. Do not answer from a single document while it is non-empty.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [quotations-INDEX.md](quotations-INDEX.md) | **Which quotation source is authoritative?** (none) | 2.1 |
| [quotation-flow-process.md](quotation-flow-process.md) | Lead → job walk → approval → DocuSign → Project. Steps 1–27 | 1.9 |
| [quotations.md](quotations.md) | Mohsin punch list: DocuSign defects, revisions, email templates | 1.8 |
| [quotation.md](quotation.md) | JZ punch list: industry codes, pre-quote package, Customer PO | 0.8 |
| [mobilization-and-demobilization.md](mobilization-and-demobilization.md) | Mob/demob process — newest content in the vault | 5.0 |
| [billing-code-and-price-list.md](billing-code-and-price-list.md) | Billing code and price list punch list | 0.5 |

## Decisions that bind this module

- [2026-08-20-quantity-based-das-sets.md](../decisions/2026-08-20-quantity-based-das-sets.md) — Quantity N on a quotation line becomes N DAS/Yard sets

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

19 meeting files carry `module/quotations` — list them:

```
grep -rl 'module/quotations' vault/meetings/
```
