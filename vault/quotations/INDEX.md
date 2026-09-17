---
title: Quotations — module index
status: reference
kind: index
updated: 2026-09-04
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
| [mobilization-and-demobilization.md](mobilization-and-demobilization.md) | Mob/demob process, and what the contract, the billing codes and the FCC manual add | 12 |
| [billing-code-and-price-list.md](billing-code-and-price-list.md) | Billing code and price list punch list — **its yard question now answered** | 3.4 |
| [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) | **The customer-facing rate card and T&Cs** — surcharge arithmetic, minimums, long-boom billing, special equipment, holiday schedule; **plus the second quote OM-36229, the 27 numbered contract terms and the Damage Waiver** | 26 |
| [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) | **Where FCC keeps estimate defaults** — the `FMS_UNIT_TYPE_JOBTYPE_YARD` table map, the 100 Ton crane's `Hourly` and `Hourly w/ Mob` templates transcribed, sub-item vs parent semantics, what TCG has instead, what the seeder already threw away, and the delivered `…ResourceTypes_20260902.xlsx` extract — counts, confirmed FCC behaviours, and the four flagged anomalies | 37.1 |
| [billing-code-types-dropped-2026-09-11.md](billing-code-types-dropped-2026-09-11.md) | **The billing code type master picklist, dropped 2026-09-11, and how to restore it**: the DDL and Prisma model, the 35 default seed types, the demo and FCC code → type links (the FCC values were in none of the three local sources checked; extraction steps given), every removed code path, and the restore recipe. Not the `typeCategory` **Type** field (accessible name "Billing code type"), which stays | 39.9 |

### Added by the 2026-09-04 Project Repository drop

| File | Answers | KB |
| --- | --- | --- |
| [fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) | **The FCC quote screen, field by field** — Main/Unit-People/Estimate/Tools/Lift Info/Line Item tabs, Unit Type Defaults, the `Item` checkbox procedure, trucking quotes and Loads, DocuSign envelope states, Conv Job, Copy Quote, TCG's own annotations, and what the 110 screenshots add (Atom mobile screens, Lift Info fields, `sent`/`Downloaded`/`voided` envelope states, the Sub-Item worked example) | 47 |
| [tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) | **TCG's own quoting procedure** — the six intake questions, the lift-radius formula and safety margin, what each Lift Info field means, the `Checked By = Customer` convention, PDF naming, and the supervisor-approval gate | 15 |
| [quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md) | **Quote → job → invoice with permits and POs** — the March 2026 lifecycle flow, the two PO types (customer 3-step, vendor 7-step), a candidate 11-table schema, and the Quote→Project→Job hierarchy that disagrees with it | 12 |
| [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) | **The billing-code import contract** — every column and its rule, `% Applied` and `Default as Sub-Item`, the ~185-name code catalogue, how a price list reaches a quote, and TCG's asks: **billing codes per yard**, **burden codes**, **pending-quote follow-up** | 21 |
| [quote-profit-forecast.md](quote-profit-forecast.md) | **FCC's margin feature** — Billing Costs (direct/indirect, yard-scoped, effective-dated), gross vs net profit per line, override costs, reports — and the evidence TCG switched it off | 11 |
| [sales-intake-and-job-walk.md](sales-intake-and-job-walk.md) | **The 94-question call sheet and the 64-item job-walk survey**, their 40 dropdown vocabularies, the 22 dispatch adders, the permit-city turnaround list, and the unfinished crane recommendation engine | 24 |
| [sales-operating-system/INDEX.md](sales-operating-system/INDEX.md) | **Ryan Adams' sales governance set** — 6 documents: the operating architecture and its 10 gates, the 13-stage process map, the Sales Coordinator manual, the playbook index and its conflict register, the forms matrix, and the red/yellow/green permit paths | 92 |
| [contracts-and-coi-sop.md](contracts-and-coi-sop.md) | **Contracts and COIs** — what counts as either, what a salesperson may never do, the two structured request blocks, and the urgency triggers | 17 |
| [new-customer-onboarding.md](new-customer-onboarding.md) | **New customer onboarding** — the Tier 1 vs small-customer deposit rule, the packet's six forms and what each captures, the AR handoff, and the packet-vs-playbook payment conflict | 12 |
| [hubspot-sales-playbook.md](hubspot-sales-playbook.md) | **The CRM side** — the 12-stage opportunity lifecycle, opportunity rules, CRM data standards, the 13-value contact-role list, opportunity naming, and quoting/follow-up standards | 17 |
| [sales-commissions.md](sales-commissions.md) | **The commission engine** — FCC + QuickBooks, plan model with monthly thresholds and effective dates, coordinator plans, what is excluded from the base, the 90-day payment condition. **May belong with payroll** | 18 |
| [sales-reporting-workbooks.md](sales-reporting-workbooks.md) | **Four workbooks, structure only** — the FCC quote export's 42 columns, the KPI tracker's failing reconciliation checks, the dispatch board's 7 statuses and utilisation formulas, the training step library, the win-back vocabularies | 20 |
| [sales-expense-report-sop.md](sales-expense-report-sop.md) | Sales expense reports route through the Sales Manager before Accounting. **Administrative; more naturally accounting/payroll** | 5 |

**Extended by the same drop:** [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) (a
second real quote OM-36229, the 27 numbered contract terms, three rate-vs-terms discrepancies, and
the Damage Waiver) · [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md)
(the vendor's 2018 *Unit Type Defaults* section, `Default as Sub-Item`, and the three meanings of
"Job Type") · [mobilization-and-demobilization.md](mobilization-and-demobilization.md) (the
contract's own mob/demob scope, `Mobilization` as a billing type, and the vendor's 2017 worked
example) · [billing-code-and-price-list.md](billing-code-and-price-list.md) (its yard question,
answered).

## Decisions that bind this module

- [2026-08-31-quotation-qty-not-das-sets.md](../decisions/2026-08-31-quotation-qty-not-das-sets.md) — Quotation qty is billing only; one DAS/Yard set per root; child qty independent
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20. A quote created from a project (`?projectId=`) still returns to that project
- [2026-09-14-quotation-mark-won-requires-comment-or-attachment.md](../decisions/2026-09-14-quotation-mark-won-requires-comment-or-attachment.md) — Manual Mark as Won requires comment or dialog `WON_EVIDENCE` (`status: reference`; TCG ratification open in gaps.md)
- [2026-09-15-fix-15-sep-das-and-quotations-as-built.md](../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md) — Print/PDF letterhead is the Lovable seal + Portal Dr fallbacks (Ehtesham Anwar). Does **not** adjudicate [quotations-INDEX.md](quotations-INDEX.md)
- [2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md) — Quote = billing codes only; Unit/People not on the quote; pick the machine directly (Joe Schacatano, `verified`). Conflicts with the 2026-09-04 Always Included note; model open in gaps.md

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

21 meeting files carry `module/quotations` — list them:

```
grep -rl 'module/quotations' vault/meetings/
```
