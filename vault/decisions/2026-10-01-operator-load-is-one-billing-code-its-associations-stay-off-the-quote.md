---
title: "Operator Load is one billing code; its tractor-semi and operator are not quote lines by default; tractor and operator keep codes for one-offs; a certified operator is its own code (Joe Schacatano, 2026-10-01; default-not-rule per Joe, 2026-10-07) — decision"
source: decision/client recorded call (Joe Schacatano, 2026-10-01)
decided: 2026-10-01
decided_by: >-
  Joe Schacatano (TCG executive). admin/engagement-directory-and-org-charts.md lists him as "VP of
  Operations" in its directory table (line 33) and as "Vice President of Sales", over the Sales
  Manager and the sales team, in its reporting chart (line 133). Either way he is the executive who
  owns how TCG quotes, as decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md
  also treats him. Stated on the recorded 2026-10-01 "Quotes and Billing Codes" call. 13:37 was
  unprompted, a correction of a prototype on screen. 14:23 ("Correct.") and 14:27 ("Exactly.")
  answered ehtesham.anwar (CodingCops) directly. 17:25–17:50, 18:24 and 18:52–19:30 answered direct
  questions. Brian Petros and Melissa McNutt (TCG) were present and did not object. Not confirmed in
  writing. Point 1 was refined by Joe himself on the recorded 2026-10-07 sprint review
  (49:55–50:30): "not shown" is the default, and the setting stays configurable from the front end.
  Written 2026-10-07; ported to overlay main 2026-10-09.
status: verified
conflicts_with: []
resolves: []
related_decisions:
  - 2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md
  - 2026-09-04-always-included-associated-children-cannot-be-removed.md
  - 2026-10-06-nested-association-quote-visibility-stored-per-parent.md
  - 2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md
jira: []
tags: [module/quotations, module/assets, module/dispatch, kind/decision, pricing, requirements]
---

# Operator Load is one billing code, and what it brings along stays off the quote (by default)

> **Read with the 2026-10-07 refinement below.** Point 1 is now a **default** (hidden), not a hard
> rule: Joe Schacatano approved per-association, front-end-configurable quote visibility on
> 2026-10-07. Current Mob/Demob rules:
> [../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md).

## Decision

Joe Schacatano, 2026-10-01:

1. **Operator Load's own associations are not quote lines.** On the 100 Ton crane, Operator Load
   brings along a Tractor-Semi and an Operator, and the prototype showed them as *"Always
   Included · Shown · Main item"*. Joe: they should not be shown on the quote and should not be a
   main item. They are always included **on the job, when it is dispatched**. *(Refined 2026-10-07
   by Joe: hidden by default, configurable — see below.)*
2. **Operator Load is a single billing code.** The tractor, trailer and operator are *"combined
   into what the operator load is"*. The charge is the Operator Load alone. The tractor *"wouldn't
   be a billing code on it"*. It feeds equipment-utilisation reporting, and the operator feeds
   labour hours.
3. **Tractor and operator still keep billing codes, for one-offs.** They need *"the option to add
   them in as a billing code… in case there are one-offs"*.
4. **A certified operator is a separate billing code.** It is used where the machine is charged
   monthly or weekly (a crawler crane, a rough-terrain machine) and an operator charge is tied to
   it. On a 100 ton quote, *"we would add the billing code certified operator"*.
5. **For dispatch, the operator is the one configured in the associated field assets** (19:51,
   *"Exactly."*).

## The client's words

From `meetings/transcripts/2026-10-01-quotes-and-billing-codes.md` (`reference`, verbatim Teams
ASR). Curated in `meetings/2026-10-01-quotes-and-billing-codes-associated-assets-mob-demob-and-holdover.md`
§2 and §4 (`unverified`):

- **13:37.** *"So where operator load shows where it has a tractor semi operator and it says always
  included shown main item. It shouldn't be shown and it shouldn't be a main item. Always included
  on the job end when it's dispatched is how it should be."*
- **14:07 → 14:23.** ehtesham.anwar: *"these sub items should not be shown in quotation."* Joe:
  **"Correct."** ehtesham.anwar (14:25): *"It should be only operator load."* Joe (14:27):
  **"Exactly.** So the tractor and the operator, right, and the trailer, that's combined into what
  the operator load is… The operator load itself, the charges, is just the operator load."*
- **17:25 – 17:50.** *"It's just a single billing code… There wouldn't be a billing code on it…
  the billing code itself, since those are incorporated into it, is only going to be the single
  billing code for that item… and that would be the only thing we're looking at from like pricing
  standpoint."*
- **18:24.** *"having the option to add them in as a billing code… in case there are one-offs or
  something, yes."*
- **18:52 – 19:30.** *"that would be a separate billing code in and of itself that would be
  specific to an operator… with like a crawler crane or something or a rough terrain machine where
  we're charging for the machine on a monthly, weekly… then we tie in the operator charge to it."*
  *"If you're dropping down the 100 ton and let's say we want to add an operator to it, then yes,
  we would add the billing code certified operator."*

## Why

Joe, 14:27: the tractor, trailer and operator are *"what's associated with it in order for it to go
out and actually perform the work"*. The customer is charged for Operator Load, and the
physical resources are a dispatch concern. This is the 2026-09-16 principle (`verified`),
*"resources exist for dispatch"*, applied one level down to a load's own associations.

## Scope — what Joe said, and what he did not

- **He spoke about one case:** Operator Load's Tractor-Semi and Operator. ehtesham.anwar's
  restatement (*"these sub items should not be shown"*) and his close at 1:05:05 generalise it to
  every association's own associations. Joe agreed to the restatement but did not speak to other
  loads.
- **On 2026-10-01 he did not say "by default".** On 2026-10-07 he did, in effect — see below.

## Refinement 2026-10-07 — hidden by default, configurable (Joe Schacatano)

On the recorded 2026-10-07 sprint review
(`meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md` §7;
transcript `meetings/transcripts/2026-10-07-erp-sprint-review-offline-tickets-holdover-and-mob-demob.md`
48:42–50:30), ehtesham.anwar showed that the oiler and Operator Load's sub-items carry the same
Show and Main/Sub settings as direct associations, starting hidden, changeable from the front end
by anyone with the permission, with no "sub-items are never shown" rule in code. Joe:

- **49:55** *"So we can customize it to however we want it to be basically. Yeah, and that's, I'd
  rather have it be that way with more…"* **50:03** *"the option to everything just in case the
  situation or variables change for us."*
- **50:10** *"I like how that's built out because it just, you can do whatever you want with it."*
- **50:20–50:25** *"because I feel like if we took the other route where we completely restricted
  it… We're gonna run into a scenario where, like, yeah..."*

So point 1 now reads: **Operator Load's own associations start hidden on the quote; an authorised
user can show them.** Points 2–5 are unchanged. The one-off route of point 3 (add the tractor or
operator as its own billing code) still stands beside the configurable setting.

History, for the record: the ticket owner first answered TCG-218 Q5 "never shown" (2026-10-07,
following this note), then reversed it the same day ("Editable, quoted with parent"), a decision
attributed to ehtesham.anwar (CodingCops). Joe's 2026-10-07 approval is what settles it. See
[2026-10-06-nested-association-quote-visibility-stored-per-parent.md](2026-10-06-nested-association-quote-visibility-stored-per-parent.md).

## Conflicts

- **Closed: [2026-10-06-nested-association-quote-visibility-stored-per-parent.md](2026-10-06-nested-association-quote-visibility-stored-per-parent.md).**
  That note made these rows configurable, hidden by default. Joe approved exactly that on
  2026-10-07. `conflicts_with` cleared on both.
- **[2026-09-04-always-included-associated-children-cannot-be-removed.md](2026-09-04-always-included-associated-children-cannot-be-removed.md)**
  (`reference`). This conflict is already logged against 2026-09-16 and is not new here. Joe's
  13:37 places "Always Included" on the job end, not the quote.
- **Not a conflict:** [2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md).
  This note extends it. Its point 3 (*"a resource has no billing code of its own"*) is **qualified**
  by point 3 above: tractor and operator do keep billing codes, used only for one-offs.

## What this does not settle

- **Other loads.** Whether Support Load's tractor and trailer follow the same default. Likely, and
  the configurable setting covers it either way, but nobody said it.
- **How a certified operator reaches the quote.** Whether it is a separate line the salesperson
  adds, or an employee-type association ticked to show. Open — see
  [2026-10-06-employee-type-associations-start-hidden-on-the-quote.md](2026-10-06-employee-type-associations-start-hidden-on-the-quote.md).
- **Where the dispatch requirement lives.** `quotations/gaps.md` → *Quote line items vs dispatch
  resources* (a). Joe's 19:51 *"Exactly"* points at the sub-category's associated field assets, but
  it answers a narrower question than (a). That entry stays **open**.

## Effect on the vault

- **No vault-file status flips.** The meeting records stay `unverified`, as records, per the
  meetings rule.
- `conflicts_with` on this note and on the nested-association note: cleared (Joe, 2026-10-07).
