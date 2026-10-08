---
title: Mob/Demob — current rules (index of decisions)
source: generated/decision-index — tcg-scrum, 2026-10-09
status: reference
kind: index
updated: 2026-10-09
conflicts_with: []
tags: [module/quotations, module/assets, module/dispatch, kind/reference, mob-demob, pricing]
---

# Mob/Demob — current rules

A pointer list, not a source: each rule's authority is the linked decision note. **Status key:**
**client** = a TCG person (Joe Schacatano) said it, on tape or in writing · **ticket owner** = Syed
Haris (CodingCops, Linear TCG-218/TCG-220) · **CodingCops** = another CodingCops decision ·
**interpretation** = a developer reading, nobody confirmed. Built on overlay/code branch
`feat/association-document-visibility`, under review. The source conflict stub
[mob-demob-INDEX.md](mob-demob-INDEX.md) is **not** adjudicated by any of these.

## On the quote

| Rule | Status | Note |
| --- | --- | --- |
| A Mob or Demob group holds several billing codes, each with its own editable quantity, rolled into one line | client | [10-01 mob/demob](../decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md) 1–2 |
| The customer sees Mobilization, Demobilization and main items only (PDF and print) | client | same, 3 |
| Demob lines start at 0; a 0 line stays out of the total; fractional quantities (2 dp) | client (2 dp: ticket owner) | same, 4–5 |
| Mob/Demob groups sit at the bottom of the quote | client (stated preference) | same, 9 |
| Adding a line to Mob adds it to Demob | client | same, 8 |
| Renaming or deleting a line mirrors to its twin, both directions | ticket owner | same, *Update 2026-10-08* |
| Lines inside Mobilization are entered as for one visit; the Mobilization quantity is the number of visits and multiplies the line | **client — Joe, Teams, 2026-10-08** | [visits](../decisions/2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md) 1–3, [*The exchange*](../decisions/2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md#the-exchange) |
| Same for Demobilization; only Mob/Demob multiply (Crane Time ×1); discount, surcharge, price hike scale × visits; one total on every surface; margin × visits | ticket owner | visits 4–8 |
| A one-off cost that must not repeat per visit goes on its own line outside the group | ticket owner | visits 9 |
| Only the "Price Adjustment" item (FCC `PA`) is hand-priced without a billing code inside Mob/Demob; may carry cents | ticket owner, confirmed 2026-10-09 "q13: yes" (client named the line) | [Price Adjustment](../decisions/2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md) — supersedes [10-07 any custom type](../decisions/2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md) |
| Quotation Type Hourly / Hourly w/ Mob, chosen once per quote; confirm before a switch that changes rows; existing quotes are Hourly | ticket owner | [type](../decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md) |
| Two cranes on one job: one quote, a Mob/Demob per crane, labelled e.g. "100 Ton Crane – Mobilization"; one invoice | client (label form: ticket owner) | [two cranes](../decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md) 1–3 |
| Alternative options and phases are separate quotes under one project | client | same, 5 |

## Field Assets Configuration (sub-category)

| Rule | Status | Note |
| --- | --- | --- |
| Each association has Hourly Show and Mob/Demob Show + Main item / Sub item, configurable from the front end | client — Joe, 2026-10-07 | [settings](../decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md) 1–2 |
| The two Show settings are independent; quote follows the page's association order | ticket owner | settings 3, Q16 |
| Employee types start hidden, can be ticked; existing rows backfilled hidden, saved quotes unchanged | client (default, configurable) / ticket owner (backfill) | [employee types](../decisions/2026-10-06-employee-type-associations-start-hidden-on-the-quote.md) |
| "Also brings along" rows (e.g. Operator Load's tractor, operator) carry the same settings, per parent, hidden by default; Operator Load is one billing code; tractor/operator keep codes for one-offs | client — Joe, 2026-10-01 and 2026-10-07 | [nested](../decisions/2026-10-06-nested-association-quote-visibility-stored-per-parent.md), [Operator Load](../decisions/2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md) |
| Tab renamed "Field Assets Configuration", with its own activity log | CodingCops (ehtesham.anwar) | [rename + log](../decisions/2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md) |

## Dispatch

| Rule | Status | Note |
| --- | --- | --- |
| Show/hide is for the quote only; every billable association of a quoted item becomes a DAS slot | ticket owner — **conflicts** with [09-12](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md) for Optional associations | [ticket-owner log](../decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md) Q6/U8 |
| A build-only support load / supporting crane sits inside Mob/Demob and goes out on the first and last day | client — Joe, 2026-10-01 / 2026-10-07 | [visit days](../decisions/2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md) 1–3 |
| …and on every visit (3 visits → 3 trips) | ticket owner | visit days 4 |
| Operator Load and every Sub-item association dispatched the same way | **interpretation — not confirmed** | visit days 5 |

## Still open

Charged operator by ticking vs Certified Operator code (TCG-218 Q19); Optional associations and DAS
(09-12 vs Q6/U8); Operator Load dispatch days; invoice lines vs quote lines
([../accounting/gaps.md](../accounting/gaps.md#does-the-invoice-carry-exactly-the-quotations-lines--including-the-lines-hidden-inside-mobilizationdemobilization));
which mob/demob source page is authoritative ([mob-demob-INDEX.md](mob-demob-INDEX.md)).
