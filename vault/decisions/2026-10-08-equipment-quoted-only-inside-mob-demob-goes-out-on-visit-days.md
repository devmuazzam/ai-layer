---
title: "Equipment quoted only inside Mobilization/Demobilization (a supporting crane, a build-only support load) goes out to build and to break down — first and last day — and on every visit (Joe Schacatano 2026-10-01/07; every-visit rule Syed Haris 2026-10-08); extending it to Operator Load and every Sub item is an interpretation — decision"
source: decision/Syed Haris — answer to Linear TCG-218 question Q31, 2026-10-08, building on Joe Schacatano's recorded statements of 2026-10-01 and 2026-10-07
decided: 2026-10-08
decided_by: >-
  The client basis is Joe Schacatano (TCG VP of Sales) on two recorded calls: 2026-10-01 "Quotes and
  Billing Codes", 52:08–52:54 (a support load that only goes to build sits inside mob/demob, goes with
  the crane, builds it and returns to the yard; on a holdover "it has to go, come back, then go on the
  last day" — "Correct.") and the 2026-10-07 sprint review, 43:10 (a supporting crane "is associated
  in the mob and demob"). The every-visit rule is Syed Haris's (syed.haris, CodingCops developer,
  assignee and owner of Linear TCG-218), stated 2026-10-08 in a Claude Code session as a CodingCops
  decision, not asked of Joe: "if crane have to come back 3 times, then support crane will go three
  times". Applying the same dispatch rule to Operator Load and to every association set as a Sub item
  is a developer interpretation recorded with the build, not confirmed by anyone at TCG. Status
  `reference`: it binds the build, and TCG can overrule it. Built on branch
  feat/association-document-visibility (kept in TCG-218 at the ticket owner's request), under review.
status: reference
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md
  - 2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md
  - 2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md
  - 2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md
jira: []
tags: [module/quotations, module/dispatch, module/projects-jobs, kind/decision, mob-demob, holdover]
---

# Equipment quoted only inside Mob/Demob goes out on visit days

## Decision

| # | Rule | Authority |
| --- | --- | --- |
| 1 | **A support load that only goes to build the machine sits inside Mob/Demob**; one that stays on site is a Main item, its own line beside the crane. | **Client** — Joe, 2026-10-01 52:08–52:30 |
| 2 | **A supporting crane** (e.g. a 90 ton helping set up a 350 or 550) **sits inside Mob/Demob** — it is not a second main crane. | **Client** — Joe, 2026-10-07 43:10 |
| 3 | **Such equipment goes out to build and to break down: the job's first and last day.** On a holdover it goes, comes back to the yard, and goes again on the last day. | **Client** — Joe, 2026-10-01 52:40–52:54 (*"Correct."*) |
| 4 | **It goes out on every visit of its Mobilization.** Three visits → three trips. | Ticket owner — Syed Haris, 2026-10-08 (Q31), not asked of Joe |
| 5 | Treat **Operator Load**, and **every association set as a Sub item**, the same way (needed on visit days only). | **Interpretation — not confirmed.** Developer reading of Joe 2026-10-01 39:09 (Operator Load *"is only needed to really build up the machine… we only bring it back into our charges on the last day"*) and 52:30. Joe spoke about how Operator Load is **charged**, not how it is dispatched |
| 6 | Price lines inside the groups (Price Adjustment, crew overtime and the like) are not dispatched at all. | Ticket owner — follows from rule 4's build; no TCG statement |

**Defect this fixes (found 2026-10-08):** converting an Hourly w/ Mob quote had copied every
Mobilization/Demobilization line onto the job as its own DAS slot, so the main crane was a slot
three times and a supporting crane twice, and a day completed only once every copy was allocated.
Under these rules each machine is one slot, required on the job's first and last working day and
allocatable on other days for extra visits.

## The client's words

- **Joe, 2026-10-01, 52:08–52:30** (`meetings/transcripts/2026-10-01-quotes-and-billing-codes.md`):
  *"scenario A is if the support load stays on site, it's going to match the crane hours. And then
  what we would have to do then is add it as an item on the quotation with the crane. If option B or
  scenario B, the support loads only go in there to build the machine, then in that case, this amount
  of time is going to be more than the crane because it has to go with the crane, build it up, and
  then it has to come back to our yard as opposed to staying on site."*
- **ehtesham.anwar 52:40:** *"And then again, if we have multiple holdover job. Then it has to go,
  come back, then go on the last day."* **Joe 52:54:** *"Correct."*
- **Joe, 2026-10-07, 43:10**
  (`meetings/transcripts/2026-10-07-erp-sprint-review-offline-tickets-holdover-and-mob-demob.md`):
  *"Yeah, but that's associated in the mob and demob. They're talking about specifically if two
  cranes go to do 2 separate things."*

## Why

The ticket owner's reason for rule 4: a visit means the main crane comes back, and the equipment
that builds it has to come with it each time. That is consistent with Joe's 2026-10-08 statement
that the lines inside Mobilization are per visit and the Mobilization quantity is the number of
visits ([2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md](2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md)),
but Joe did not say it.

## Conflicts and interactions

- **No decision-note conflict.**
- **Sits beside** [2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md](2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md)
  (`reference`): that note governs offload of held and not-held items; this one governs which days a
  Mob/Demob-only machine is required. Holdover handling of a visit-days item (Make Holdover, Copy
  Allocations on middle days) is not settled here.
- **Partly answers** [../dispatch/gaps.md → *An assist crane needed only on some days of a multi-day
  job*](../dispatch/gaps.md#an-assist-crane-needed-only-on-some-days-of-a-multi-day-job--setup-and-breakdown):
  (a) the assist crane is a line inside the main crane's Mob/Demob on the same quote (client);
  (b) first and last day, plus every visit (client + ticket owner); (d) "required on these days
  only" (ticket owner). (c), whether its crew follows the same days, is not stated. The entry stays
  open for Lisette Anzaldo.

## The one-line questions for TCG, if they need confirming

- Joe Schacatano: *"If a mobilization is set to 3 visits, does the supporting crane inside it go out
  3 times?"* The ticket owner answers **yes**.
- Joe Schacatano / Lisette Anzaldo: *"Is Operator Load (and its tractor and operator) dispatched on
  the first and last day only, like a build-only support load, or every day the crane works?"*
  Unanswered — rule 5 is an interpretation.

## Effect on the vault

- No status flips. No register entry closed.
