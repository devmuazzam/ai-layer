---
title: Quotations — module index
status: reference
kind: index
updated: 2026-09-03
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
| [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) | **The customer-facing rate card and T&Cs** — surcharge arithmetic, minimums, long-boom billing, special equipment, holiday schedule | 7.4 |
| [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) | **Where FCC keeps estimate defaults** — per (resource type, job type, yard); the 100 Ton crane's `Hourly` and `Hourly w/ Mob` templates transcribed, sub-item semantics, and what TCG has instead | 11.4 |

## Decisions that bind this module

- [2026-08-31-quotation-qty-not-das-sets.md](../decisions/2026-08-31-quotation-qty-not-das-sets.md) — Quotation qty is billing only; one DAS/Yard set per root; child qty independent
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20. A quote created from a project (`?projectId=`) still returns to that project

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

19 meeting files carry `module/quotations` — list them:

```
grep -rl 'module/quotations' vault/meetings/
```
