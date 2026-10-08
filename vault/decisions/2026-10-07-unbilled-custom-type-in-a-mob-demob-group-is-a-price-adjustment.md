---
title: "A custom type with no billing code inside a Mob/Demob group is a hand-priced line (Price Adjustment), not 'Billing Code missing' (Syed Haris, 2026-10-07) — decision [SUPERSEDED 2026-10-08]"
source: decision/Syed Haris — TCG-218 design, 2026-10-07
decided: 2026-10-07
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218), in a Claude
  Code session that ran 2026-10-06 to 07, relayed to tcg-scrum on 2026-10-07. It implemented Joe
  Schacatano's 2026-10-01 37:16 description of the Price Adjustment line; the rule that any custom
  type without a code qualifies was the developer's generalisation. Superseded on 2026-10-08 by the
  same ticket owner's answer to TCG-218 Q13. Ported to overlay main 2026-10-09 as a record.
status: superseded
superseded_by: decisions/2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-08-31-quotation-resource-rate-whole-dollars.md
  - 2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md
jira: []
tags: [module/quotations, kind/decision, mob-demob, pricing]
---

# A code-less custom line inside a Mob/Demob group is priced by hand

> ## SUPERSEDED 2026-10-08 — do not build from this note.
>
> Syed Haris answered TCG-218 Q13 on 2026-10-08: **only the "Price Adjustment" custom type** (FCC
> code `PA`) is hand-priced inside Mobilization/Demobilization; any other code-less custom line
> needs a billing code. The rule is
> [2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md](2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md).
> The text below is kept as the record of what was first decided.

## Decision (as first recorded)

Syed Haris, 2026-10-07. A quotation line that:

- sits **inside a group** (Mobilization / Demobilization),
- is a **custom type** (not a sub-category and not an employee type), and
- has **no billing code**

is a **hand-priced line**, FCC's *Price Adjustment*. Its rate is entered on the line, and it is
**not** flagged *"Billing Code missing."*. The same row **outside** a group still is.

## Why

Joe Schacatano, 2026-10-01, 37:16 (`meetings/transcripts/2026-10-01-quotes-and-billing-codes.md`):
*"if you noticed in the [mob demob; ASR "mode demo"], there was a line item price adjustment. So
that's basically like if we want to add extra money in there… a hotel, food, just random stuff that
we don't really generate billing codes for, or if we want to just add extra money in there, that's
what the price adjustment is."* Recorded as point 6 of
[2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md](2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md)
(`verified`).

## What was left open, and how it ended

- **Which custom type** — any, or a dedicated Price Adjustment item? Answered 2026-10-08 (Q13):
  the dedicated item only. This is what superseded the note.
- **Rate rule** — answered 2026-10-07 (Q12): a hand-priced line inside a group may carry cents;
  carried into the superseding note.
- **Accounting** — the GL / invoice treatment of a line with no billing code. Not discussed.
