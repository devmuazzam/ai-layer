---
title: "A Mobilization's quantity is the number of visits (default 1); its lines are entered as for one visit; amount = visits × the summed lines (client-confirmed by Joe Schacatano, 2026-10-08). Same for Demobilization, Mob/Demob only, adjustments scale by visits (ticket owner) — decision"
source: decision/client written reply (Joe Schacatano, Microsoft Teams, 2026-10-08), confirming Syed Haris's 2026-10-07 ruling
decided: 2026-10-07
decided_by: >-
  First ruled by Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218)
  in a Claude Code session on 2026-10-07: "the amount is sum, and the mob demob quantity multiplied
  to that amount", as his reading of Joe Schacatano's 2026-10-01 29:15 ("multiply the mobilization
  as many times as we want because we might be doing 5 different visits"). Confirmed by Joe
  Schacatano (TCG VP of Sales, the quotation owner) in a written Microsoft Teams reply on 2026-10-08
  to a question syed haris sent him the same day; both messages relayed verbatim by syed haris and
  quoted under "The exchange". Joe's reply confirms points 1–3 for Mobilization. Applying the same
  to Demobilization, limiting the multiplier to Mob/Demob groups, and scaling discount, surcharge
  and price hike by visits are the ticket owner's rulings (TCG-218 Q3, Q4, Q2, Q25), which Joe did
  not address. Ported to overlay main 2026-10-09. Built on branch feat/association-document-visibility,
  under review.
status: verified
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-09-11-quotation-footer-discount-and-price-hike-rows.md
  - 2026-09-02-one-surcharge-per-quote.md
  - 2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md
  - 2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md
jira: []
tags: [module/quotations, kind/decision, mob-demob, pricing]
---

# Mob/Demob group quantity = visits

Current Mob/Demob rules, with status per rule:
[../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md).

## Decision

| # | Rule | Authority |
| --- | --- | --- |
| 1 | **The Mobilization line's own quantity is the number of visits.** It defaults to 1 and can be edited. | **Client-confirmed** — Joe Schacatano, 2026-10-08 (and 2026-10-01 29:15) |
| 2 | **The lines inside stay as for one visit.** Group rate = the sum of its ticked lines, i.e. the per-visit cost. | **Client-confirmed** — Joe, 2026-10-08 |
| 3 | **Group amount = visits × that sum.** | **Client-confirmed** — Joe, 2026-10-08 |
| 4 | Demobilization's quantity works the same way. | Ticket owner — Syed Haris (TCG-218 Q4). Joe spoke of Mobilization only |
| 5 | **Only Mobilization and Demobilization multiply.** Any other group parent (e.g. Crane Time) rolls up at ×1. | Ticket owner — Q4 |
| 6 | **The lines' discount, surcharge and price hike scale × visits**, so the footer adjustments agree with the multiplied amount. | Ticket owner — Q3. Joe did not address adjustments |
| 7 | **One quote, one total**: every server surface (customer metrics, project revenue, approval and signature emails, repository reads) shows the visits-multiplied total. | Ticket owner — Q2 |
| 8 | **Approval margin** multiplies a Mob/Demob group's lines (revenue and cost) by visits and leaves out lines unticked inside a group. | Ticket owner — Q25 |
| 9 | **A one-off cost that must not repeat per visit** (e.g. a permit) is added as its own line outside the group. | Ticket owner — Syed Haris, 2026-10-08 (TCG-218 Q30, before Joe replied). Joe's rule covers every line in the group and did not address a one-off |

## The exchange

**Question** — sent by syed haris to Joe Schacatano (VP of Sales, TCG) via Microsoft Teams on
2026-10-08, verbatim:

> Hi Joe, one quick question on mob/demob, following up on what we discussed yesterday:
> When Mobilization is set to more than one visit, should every line inside it be charged that many
> times? For example, 3 visits with Tractor travel 3 hr and a Travel Permit: is that 9 hr of travel
> and 3 permits, or 9 hr of travel and 1 permit?

**Answer** — Joe Schacatano, Teams reply on 2026-10-08, relayed verbatim by syed haris:

> If we have mobilizations set to more than one visit, we only want to multiply the mobilization
> single line item by increasing the quantities. So all of the items within the mob stay the same as
> if they are for one visit. We set the mobilization line item quantity to how many we want to
> reflect.
> Example for 1 and 3 mobilization :
> 1 mobilization
> Crane = 3 hrs
> Support load = 3 hrs
> Mobilization = 1
> 3 mobilizations
> Crane = 3 hrs
> Support load = 3 hrs
> Mobilization = 3

**What it settles, and what it does not.** It confirms rules 1–3: lines per visit, the Mobilization
line's quantity is the visits and multiplies the line. The question's permit example (a one-off line)
was **not addressed directly**; Joe's rule as stated covers every line in the group, so a one-off
that must be charged once goes outside the group (rule 9, ticket owner). The ticket owner afterwards
decided (2026-10-08) that a supporting crane inside Mobilization goes out on every visit — see
[2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md](2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md).

## Why

Joe Schacatano, 2026-10-01, 29:15–29:35: *"We need the option to be able to multiply the
mobilization as many times as we want because we might be doing 5 different visits to the job…
this mobilization quantity, we want to be able to change that as much as we want."* At 1:01:56 he
spoke of *"taking it from one to three"*. The 2026-10-07 sprint review showed the quantity going
from 1 to 3 with the amount updating (§7). His 2026-10-08 reply settles what the quantity multiplies.
The adjustment scaling (rule 6) keeps the footer consistent with the multiplied amount.

## Conflicts

- **Settled: [2026-09-11-quotation-footer-discount-and-price-hike-rows.md](2026-09-11-quotation-footer-discount-and-price-hike-rows.md)**
  (`reference`, Fouzan Shakil), point 2: a *"Mob/Demob group parent shows the sum of its included
  children"*. For a Mob/Demob group that holds at quantity 1 only; at any other quantity the amount
  is visits × that sum, on Joe's 2026-10-08 confirmation. For every other group parent (rule 5) the
  09-11 figure stands unchanged. The 09-11 note is not superseded — its footer-row rules stand — and
  carries a `provenance_note:` pointing here.
- **Surcharge base.** [2026-09-02-one-surcharge-per-quote.md](2026-09-02-one-surcharge-per-quote.md)
  (`verified`, Melissa McNutt) puts one surcharge row on the quote. Scaling a group's surcharge by
  visits (rule 6) is consistent with mobilization being inside the surcharge base (FCC
  `% Applied = Y`, [../quotations/mobilization-and-demobilization.md](../quotations/mobilization-and-demobilization.md)),
  but no TCG person said it.

## Effect on the vault

All done in this pass.

- This note: `status: verified` (rules 1–3, Joe 2026-10-08); `conflicts_with` cleared.
- `decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md`: `provenance_note:` added
  recording that its point 2 holds for a Mob/Demob group only at quantity 1. Status stays
  `reference`; `conflicts_with` stays `[]`. **Done.**
