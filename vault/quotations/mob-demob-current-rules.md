---
title: Mob/Demob — current rules (index of decisions)
source: generated/decision-index — tcg-scrum, 2026-10-09
status: reference
kind: index
updated: 2026-10-17
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
| Adding a line to Demob adds its twin to Mob too (at 1; Mob→Demob twin at 0); twin quantities independent; a hand-added twin takes the same position; Price Adjustment rate copies both ways; a missing billing code warns and clears on both twins; linked crane pairs only; rename/delete = basic rule only | ticket owner, 2026-10-15/16 (Q8, Q38, Q39, Q50, Q53) | [twins both ways](../decisions/2026-10-16-mob-demob-twin-rule-is-symmetric.md) |
| Lines inside Mobilization are entered as for one visit; the Mobilization quantity is the number of visits and multiplies the line | **client — Joe, Teams, 2026-10-08** | [visits](../decisions/2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md) 1–3, [*The exchange*](../decisions/2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md#the-exchange) |
| Same for Demobilization; only Mob/Demob multiply (Crane Time ×1); discount, surcharge, price hike scale × visits; one total on every surface; margin × visits | ticket owner | visits 4–8 |
| A one-off cost that must not repeat per visit goes on its own line outside the group | ticket owner | visits 9 |
| Visits are a whole number ≥ 1 (lines keep 2 dp), web + API; saved Mob/Demob groups were reset to 1 by a **one-way** migration that kept no old values; Mob/Demob detected by stored name, linked or not, any quote type | ticket owner, 2026-10-14–16 (Q2, Q20, Q40, Q41) | [visits bounds + reset](../decisions/2026-10-16-visits-are-whole-numbers-and-saved-groups-reset-to-one.md) |
| Only the "Price Adjustment" item (FCC `PA`) is hand-priced without a billing code inside Mob/Demob; may carry cents | ticket owner, confirmed 2026-10-09 "q13: yes" (client named the line) | [Price Adjustment](../decisions/2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md) — supersedes [10-07 any custom type](../decisions/2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md) |
| Quotation Type Hourly / Hourly w/ Mob, chosen once per quote; confirm before a switch that changes rows; existing quotes are Hourly | ticket owner | [type](../decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md) (point 3 amended 2026-10-16) |
| Hourly w/ Mob: the item itself is the first line of its own Mobilization group (qty 0, priced like any new group line), Demob twin at 0; it also stays its own line on top; only an item with a Sub item gets a pair; no FCC per-block comments | ticket owner, 2026-10-16 (Q42) | [item in its pair](../decisions/2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md) — amends type point 3 |
| Hourly w/ Mob: Sub-item associations fill Mobilization automatically on pick, mirrored into Demob at 0; new Mobilization lines start at qty 0, rate from price list else billing code (a Demob→Mob twin starts at 1, twin note); a crane-named pair per main crane on the Resources tab, PDF and print; with two cranes each crane's Mob then Demob, in crane order, at the bottom | ticket owner, 2026-10-14/15 (Q3, Q4, Q5, Q17) | [auto-fill + per-crane pairs](../decisions/2026-10-15-existing-associations-hidden-sub-items-auto-fill-at-zero-one-pair-per-crane.md) 2–6 |
| Hourly: an association or "also brings along" row appears exactly when its Hourly Show is ticked; hidden rows never appear | ticket owner, 2026-10-15 (Q6) | same, 7 |
| Switching type re-lays out each item's automatic lines and keeps their edits; asks whenever the quote has lines; hand-added lines stay unless their place goes; unlinked old groups untouched; groups stay last; removing a crane removes its pair; no "In total" checkbox on web | ticket owner, 2026-10-15/16 (Q30, Q31, Q34–Q37) | [type switch](../decisions/2026-10-16-quotation-type-switch-re-lays-out-and-keeps-edits.md) — amends type point 4 |
| On customer documents a Mob/Demob line prints Qty = visits, Rate = one visit's total, Amount = Qty × Rate; no discount line shows to the customer (discount kept internal) | **client — Joe, Teams, 2026-10-17** | [no discount](../decisions/2026-10-17-customer-documents-show-no-discount-every-line-net.md) 1–3, [*The exchange*](../decisions/2026-10-17-customer-documents-show-no-discount-every-line-net.md#the-exchange) |
| Every line (Mob/Demob included) prints net of discount and price hike; net Rate rounded to cents, Amount = stored net; no Discount / Price Hike rows; Surcharge row stays; customer Subtotal = sum of printed Amounts; approval-reason box off the print | ticket owner, 2026-10-17 (Q45, Q62, Q63) | no discount 4–10 |
| Two cranes on one job: one quote, a Mob/Demob per crane, labelled e.g. "100 Ton Crane – Mobilization"; one invoice | client (label form: ticket owner) | [two cranes](../decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md) 1–3 |
| Alternative options and phases are separate quotes under one project | client | same, 5 |

## Field Assets Configuration (sub-category)

| Rule | Status | Note |
| --- | --- | --- |
| Each association has Hourly Show and Mob/Demob Show + Main item / Sub item, configurable from the front end | client — Joe, 2026-10-07 | [settings](../decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md) 1–2 |
| The two Show settings are independent; quote follows the page's association order | ticket owner | settings 3, Q16 |
| Employee types start hidden, can be ticked; existing rows backfilled hidden, saved quotes unchanged | client (default, configurable) / ticket owner (backfill) | [employee types](../decisions/2026-10-06-employee-type-associations-start-hidden-on-the-quote.md) |
| Existing non-employee associations (custom-type included) start hidden on both quote types when the settings arrive (new picks: spec Q21(a) "Hidden, like everything" — no decision note yet) | ticket owner, 2026-10-14 (Q1) — Joe not asked | [existing hidden](../decisions/2026-10-15-existing-associations-hidden-sub-items-auto-fill-at-zero-one-pair-per-crane.md) 1 |
| "Also brings along" rows (e.g. Operator Load's tractor, operator) carry the same settings, per parent, hidden by default; Operator Load is one billing code; tractor/operator keep codes for one-offs | client — Joe, 2026-10-01 and 2026-10-07 | [nested](../decisions/2026-10-06-nested-association-quote-visibility-stored-per-parent.md), [Operator Load](../decisions/2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md) |
| Tab renamed "Field Assets Configuration", with its own activity log | CodingCops (ehtesham.anwar) | [rename + log](../decisions/2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md) |
| A configuration change reaches only quotes not yet gone out: snapshot at first send, at Mark as Won if never sent, or at conversion; never refreshed; conversion, dispatch board and quote builder read it; the job reads its quote's; no snapshot / uncovered sub-category reads live; names live | ticket owner, 2026-10-16/17 (Q51, Q56–Q58, Q61, Q64; Q59 PATCH-to-Won left open) | [config snapshot](../decisions/2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md) |

## Dispatch

| Rule | Status | Note |
| --- | --- | --- |
| Show/hide is for the quote only; every billable association of a quoted item becomes a DAS slot | ticket owner — **conflicts** with [09-12](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md) for Optional associations | [ticket-owner log](../decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md) Q6/U8 |
| A build-only support load / supporting crane sits inside Mob/Demob and goes out on the first and last day | client — Joe, 2026-10-01 / 2026-10-07 | [visit days](../decisions/2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md) 1–3 |
| …and on every visit (3 visits → 3 trips) | ticket owner | visit days 4 |
| Operator Load and every Sub-item association dispatched the same way | **interpretation — not confirmed** | visit days 5 |
| Job resources are REQUIRED / OPTIONAL / NONE: equipment quoted only in Mob that conversion would not create (unconfigured, Optional association) is OPTIONAL; its Demob twin, configured machines in a group, price lines and the item's own group line are NONE; everything else REQUIRED | ticket owner, 2026-10-16 (Q10, Q47–Q49) | [dispatch slots](../decisions/2026-10-16-dispatch-slots-required-optional-none.md) 1–5 |
| An Optional association left off the quote is not a DAS slot (takes 09-12's side; reverses Q6/U8 for Optional) | **ticket-owner assumption, pending Lisette Anzaldo** (Q12, 2026-10-15) | dispatch slots 7 |
| An OPTIONAL slot is allocatable on any day and never blocks allocation completed / Send Tickets; no day restriction for Mob-only equipment, Operator Load or Sub items; one-day job = one trip; holdover items go to all days | **ticket-owner assumption, pending Lisette Anzaldo** (Q13–Q16) | dispatch slots 9–10 — visit-days 4–5 not built as day rules |
| OPTIONAL shown as its own Set with an "Optional" badge, never red when empty; counted apart from the required numbers | ticket owner (Q52, Q54, Q55) | dispatch slots 11–13 |

## Still open

Charged operator by ticking vs Certified Operator code (TCG-218 Q19); Optional associations and DAS
(09-12 vs Q6/U8 — the ticket owner took 09-12's side on 2026-10-15, Q12, pending Lisette Anzaldo); Operator Load and Mob-only equipment dispatch days (no restriction, pending Lisette Anzaldo); invoice lines vs quote lines
([../accounting/gaps.md](../accounting/gaps.md#does-the-invoice-carry-exactly-the-quotations-lines--including-the-lines-hidden-inside-mobilizationdemobilization));
which mob/demob source page is authoritative ([mob-demob-INDEX.md](mob-demob-INDEX.md)).
