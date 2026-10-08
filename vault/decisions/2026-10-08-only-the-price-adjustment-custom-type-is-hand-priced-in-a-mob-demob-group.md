---
title: "Inside a Mob/Demob group only the 'Price Adjustment' custom type is priced by hand without a billing code; any other code-less custom line needs a billing code; the hand-priced rate may carry cents (Syed Haris, 2026-10-08) — decision"
source: decision/Syed Haris — answer to Linear TCG-218 question Q13, 2026-10-08
decided: 2026-10-08
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218), answering
  TCG-218 Q13 in a Claude Code session on 2026-10-08. The reply recorded in the ticket's question
  log was one word ("q13: no" — no, not every code-less custom line is a Price Adjustment); the log
  wrote its reading as "only the specific Price Adjustment item is hand-priced". Confirmed by syed
  haris on 2026-10-09: asked "Q13: did your 'no' mean that only the Price Adjustment item can be
  priced by hand inside Mob/Demob, and every other custom line needs a billing code?", he replied
  verbatim "q13: yes". The rate rule (Q12)
  is his 2026-10-07 answer. Builds on Joe Schacatano's 2026-10-01 37:16, which named one line. This
  is the ticket owner's ruling, not a TCG client confirmation, so the status is `reference`.
status: reference
conflicts_with: []
resolves: []
supersedes: decisions/2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md
related_decisions:
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md
  - 2026-08-31-quotation-resource-rate-whole-dollars.md
  - 2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md
jira: []
tags: [module/quotations, kind/decision, mob-demob, pricing]
---

# Only the Price Adjustment item is hand-priced inside Mob/Demob

## Decision

Syed Haris, ticket owner:

1. **Inside a Mobilization or Demobilization group, only the "Price Adjustment" custom type is
   priced by hand without a billing code.** Its rate is entered on the line and it is not flagged
   *"Billing Code missing."* (2026-10-08, Q13.)
2. **Any other code-less custom line, inside a group or outside one, needs a billing code.**
   (2026-10-08, Q13.)
3. **The Price Adjustment rate may carry cents.** The whole-dollar rule of
   [2026-08-31-quotation-resource-rate-whole-dollars.md](2026-08-31-quotation-resource-rate-whole-dollars.md)
   does not apply to it. (2026-10-07, Q12.)

"Price Adjustment" is FCC's item: billing code `PA`, *Price Adjustment*, in the FCC code catalogue
(`quotations/fcc-billing-data-and-price-lists.md`, code table), and a line in FCC's 100 Ton
*Hourly w/ Mob* template (`quotations/fcc-estimate-templates-by-job-type.md`).

## Why

Joe Schacatano, 2026-10-01, 37:16 named **one** line: *"there was a line item price adjustment… a
hotel, food, just random stuff that we don't really generate billing codes for, or if we want to just
add extra money in there, that's what the price adjustment is."* The earlier generalisation to any
code-less custom type went beyond that. Narrowing it keeps the `verified` 2026-09-16 rule
(*"every line that does populate on the estimate is its own billing code"*) intact, with the one
exception Joe stated himself.

## Conflicts

- **Supersedes** [2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md](2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md)
  (same author; marked `superseded` in this pass).
- None with a `verified` source.

## What this does not settle

- **How the item is identified** — by a dedicated custom type named "Price Adjustment", or by the
  `PA` code. A build matter; the product rule is "the Price Adjustment item only".
- **Accounting** — the GL / invoice treatment of a line with no billing code. Not discussed.

## Effect on the vault

- `decisions/2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md` →
  `status: superseded`, `superseded_by:` this note. **Done.**
