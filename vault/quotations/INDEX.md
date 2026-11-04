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
| [mob-demob-current-rules.md](mob-demob-current-rules.md) | **What are the Mob/Demob rules now, and who said each one?** One table per area (quote, Field Assets Configuration, dispatch), every rule linked to its decision note and marked client / ticket owner / CodingCops / interpretation. Read before building TCG-218 / TCG-220 | 6 |
| [billing-code-and-price-list.md](billing-code-and-price-list.md) | Billing code and price list punch list — **its yard question now answered** | 3.4 |
| [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) | **The customer-facing rate card and T&Cs** — surcharge arithmetic, minimums, long-boom billing, special equipment, holiday schedule; **plus the second quote OM-36229, the 27 numbered contract terms and the Damage Waiver** | 26 |
| [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) | **Where FCC keeps estimate defaults** — the `FMS_UNIT_TYPE_JOBTYPE_YARD` table map, the 100 Ton crane's `Hourly` and `Hourly w/ Mob` templates transcribed, sub-item vs parent semantics, what TCG has instead, what the seeder already threw away, and the delivered `…ResourceTypes_20260902.xlsx` extract — counts, confirmed FCC behaviours, and the four flagged anomalies | 37.1 |
| [fcc-billing-resource-configuration-deep-dive-2026-09-16.md](fcc-billing-resource-configuration-deep-dive-2026-09-16.md) | **What does FCC's database actually do with billing templates, price lists and resource recipes — and what does Brian recommend for the ERP?** 16 Sep 2026, written by TCG's AI model: stale template rates, price lists as sparse overrides (11,284 / 458 / 34 / 2 quote-line split), H/Z job types, OM-40439 → OM60788 traced, 36001 as one crane in two configurations; recommends Service Profile + Billing Bundle + Dispatch Requirement Template. Recommendation, not a decision (added 2026-09-17) |
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
- [2026-09-22-public-quotation-pdf-route-deleted.md](../decisions/2026-09-22-public-quotation-pdf-route-deleted.md) — The public quotation PDF route is **deleted**, not gated (Fouzan Shakil, `reference`). Closes gaps Q-01 and Q-03. Carries the standing rule for any future public quotation link: globally unique unguessable key, secret verified before any DB read, never rely on the `$extends` extension, SENT-or-later only
- [2026-10-08-quotation-measuring-unit-stays-locked.md](../decisions/2026-10-08-quotation-measuring-unit-stays-locked.md) — Measuring Unit stays locked once a billing code fills it (`SCRUM-567` stands; TCG-198 criterion 4 dropped), unlocked only when the code's unit maps onto no option (Syed Haris, `reference`)
- [2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md](../decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md) — Mob/Demob on the quote: several billing codes rolled into one line, editable Mobilization quantity, Demob at 0, customer sees mob/demob/main items only, groups at the bottom, add mirrors to Demob (Joe Schacatano, `verified`); 2026-10-08 update: rename/delete mirror (ticket owner)
- [2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md](../decisions/2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md) — Operator Load is one billing code; its tractor/operator hidden on the quote **by default**, configurable (Joe, 2026-10-01 + 2026-10-07, `verified`); tractor/operator keep codes for one-offs; Certified Operator is its own code
- [2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md](../decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md) — Per-association Hourly Show and Mob/Demob Show + Main/Sub item, configurable from the front end (approved by Joe 2026-10-07, `verified`); the two Show settings independent (ticket owner)
- [2026-10-06-employee-type-associations-start-hidden-on-the-quote.md](../decisions/2026-10-06-employee-type-associations-start-hidden-on-the-quote.md) — Employee-type associations start hidden, can be ticked (Joe 2026-10-07, `verified`); backfill keeps saved quotes (ticket owner)
- [2026-10-06-nested-association-quote-visibility-stored-per-parent.md](../decisions/2026-10-06-nested-association-quote-visibility-stored-per-parent.md) — "Also brings along" rows carry the same settings, per parent, hidden by default — configurable (Joe 2026-10-07, `verified`); conflict with the 10-01 Operator Load note closed
- [2026-10-06-quotation-type-hourly-or-hourly-with-mob.md](../decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md) — Quotation Type Hourly / Hourly w/ Mob, once per quote; confirm before a row-changing switch; existing quotes Hourly (Syed Haris, ticket owner, `reference`); point 3 amended 2026-10-16 (next entry)
- [2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md](../decisions/2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md) — Hourly w/ Mob: the item itself is the first line of its own Mobilization group (qty 0), Demob twin at 0, and stays its own line on top; only items with a Sub item get a pair; FCC comments not adopted. **Amends point 3** of the type note above (Syed Haris, ticket owner, `reference`)
- [2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md](../decisions/2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md) — Mobilization quantity = visits; lines per visit; amount = visits × summed lines (**client-confirmed by Joe, Teams, 2026-10-08**, `verified`, exchange quoted verbatim); Demob same, Mob/Demob only, adjustments × visits (ticket owner)
- [2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md](../decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md) — Two cranes on one job: one quote, a Mob/Demob per crane labelled with the crane, one invoice; options/phases are separate quotes under one project (Joe, 2026-10-07, `verified`)
- [2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md](../decisions/2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md) — Only the "Price Adjustment" item (FCC `PA`) is hand-priced inside Mob/Demob, may carry cents (Syed Haris, ticket owner, `reference`); supersedes 2026-10-07 any-custom-type
- [2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md](../decisions/2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md) — **Superseded** 2026-10-08 — any code-less custom line in a group was hand-priced
- [2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md](../decisions/2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md) — Equipment quoted only inside Mob/Demob goes out first and last day (Joe) and on every visit (ticket owner); Operator Load / Sub items the same — interpretation, not confirmed (`reference`)
- [2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md](../decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md) — TCG-218 question log: the ticket owner's answers Q1–Q31 (`reference`); show/hide is quote-only, every billable association is a DAS slot — **conflicts with 2026-09-12**
- [2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md](../decisions/2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md) — Sub-category tab renamed Field Assets Configuration, with its own activity log (ehtesham.anwar, CodingCops, `reference`)
- [2026-10-17-customer-documents-show-no-discount-every-line-net.md](../decisions/2026-10-17-customer-documents-show-no-discount-every-line-net.md) — Customer documents (PDF, print) show no discount: rates shown, discount internal, no discount line (**Joe Schacatano, Teams, 2026-10-17**, `verified`, verbatim); Mob/Demob line Qty = visits, Rate = one visit's total (Joe); every line net of discount and price hike, net Rate to cents, no Discount / Price Hike rows, Surcharge row stays, Subtotal = printed Amounts, approval-reason box off the print (ticket owner). Answers the printed half left open by 2026-09-11; closes the printed half of (c) in [gaps.md → *Branch fix/das-fixes*](gaps.md#branch-fixdas-fixes--archive-gate-rate-error-precedence-discount-and-price-hike-footer-rows) (2026-10-17)
- [2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md](../decisions/2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md) — A quote keeps the asset configuration it went out with: snapshot at first send, at Mark as Won if never sent, or at conversion; never refreshed; conversion, dispatch board and quote builder read it; the job reads its quote's; no snapshot / uncovered sub-category reads live; names live (Syed Haris, ticket owner, `reference`)
- [2026-10-16-mob-demob-twin-rule-is-symmetric.md](../decisions/2026-10-16-mob-demob-twin-rule-is-symmetric.md) — Mob/Demob twins mirror both ways on add, rename and delete (basic rule only); twin into Demob at 0, into Mob at 1, quantities independent; same position; Price Adjustment rate copies both ways; missing billing code warns and clears on both twins; linked pairs only (Syed Haris, ticket owner, `reference`; Mob→Demob add is Joe's, 10-01 pt 8)
- [2026-10-16-quotation-type-switch-re-lays-out-and-keeps-edits.md](../decisions/2026-10-16-quotation-type-switch-re-lays-out-and-keeps-edits.md) — Quotation Type switch re-lays out each item's automatic lines and keeps their edits; asks whenever the quote has lines; hand-added lines stay unless their place goes; unlinked old groups untouched; groups last; removing a crane removes its pair; no "In total" checkbox on web (Syed Haris, ticket owner, `reference`); amends point 4 of the 10-06 type note
- [2026-10-16-visits-are-whole-numbers-and-saved-groups-reset-to-one.md](../decisions/2026-10-16-visits-are-whole-numbers-and-saved-groups-reset-to-one.md) — Visits are whole numbers ≥ 1 (lines keep 2 dp), web + API; saved Mob/Demob groups reset to 1 by a **one-way** migration with no copy of old values; Mob/Demob detected by stored name on any quote type (Syed Haris, ticket owner, `reference`)
- [2026-10-16-dispatch-slots-required-optional-none.md](../decisions/2026-10-16-dispatch-slots-required-optional-none.md) — Job resources are REQUIRED / OPTIONAL / NONE dispatch slots; Mob-only unconfigured or Optional equipment is OPTIONAL, Demob twin / configured / price lines NONE; OPTIONAL allocatable any day, never blocks completion, "Optional" badge, counted apart; Optional association left off the quote is no slot (Syed Haris, ticket owner, `reference` — **assumptions pending Lisette Anzaldo**)
- [2026-10-15-existing-associations-hidden-sub-items-auto-fill-at-zero-one-pair-per-crane.md](../decisions/2026-10-15-existing-associations-hidden-sub-items-auto-fill-at-zero-one-pair-per-crane.md) — Existing non-employee associations start hidden on both quote types; Hourly w/ Mob: Sub items auto-fill Mobilization (Demob twin at 0), new Mobilization lines start at 0 (price list / billing code rate); a crane-named pair per main crane on the Resources tab, PDF and print, each crane's Mob then Demob in crane order; on Hourly a row shows exactly when its Hourly Show is ticked (Syed Haris, ticket owner, TCG-218 Q1/Q3/Q4/Q5/Q6/Q17, `reference`); Mob-at-0 narrowed by the twin note (Demob→Mob twin at 1)

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

21 meeting files carry `module/quotations` — list them:

```
grep -rl 'module/quotations' vault/meetings/
```
