---
title: "Employee-type associations start hidden on both quote types, for new picks and existing rows; a ticked employee type does show — there is no hard 'employees never on the quote' rule (Syed Haris, 2026-10-06; default and configurability approved by Joe Schacatano, 2026-10-07) — decision"
source: decision/Syed Haris (TCG-218 design, 2026-10-06) — default and configurability approved by Joe Schacatano on the recorded 2026-10-07 sprint review
decided: 2026-10-06
decided_by: >-
  Decided by Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218) in
  a Claude Code session on 2026-10-06 ("Employee types default hidden — not from the client"),
  relayed to tcg-scrum on 2026-10-07. On the recorded 2026-10-07 sprint review
  (meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md §7) the
  quote-visibility settings were shown with "sub-items and employees start unticked", and
  ehtesham.anwar (48:42) named the oiler's Hourly and Mob/Demob Show settings as configurable from
  the front end. Joe Schacatano (TCG VP of Sales) approved the configurable approach (49:55–50:30).
  Points 1 and 3 are therefore client-approved. Point 2 (backfill of existing rows; saved quotes
  unchanged) is the ticket owner's alone. Written 2026-10-07; ported to overlay main 2026-10-09.
status: verified
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md
  - 2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md
  - 2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md
jira: []
tags: [module/quotations, module/assets, kind/decision, pricing]
---

# Employee-type associations start hidden on the quote

## Decision

1. **An association to an employee type starts hidden** on both quote types: Hourly Show off, and
   Mob/Demob Show off. *(Syed Haris 2026-10-06; shown to and approved by Joe 2026-10-07.)*
2. **This applies to new picks and to existing rows**: existing employee-type associations are
   backfilled hidden. **Already-saved quotes keep their current lines when reopened** — the backfill
   changes how new quotes are laid out, never what a saved quote carries. *(Ticket owner — Syed
   Haris, TCG-218 Q7, 2026-10-07.)*
3. **It is a default, not a rule.** An authorised user may tick Show on an employee type, and it then
   appears on the quote. There is **no** hard-coded "employees are never quote lines". *(Joe,
   2026-10-07: "So we can customize it to however we want it to be basically.")*

## Why

Joe Schacatano's `verified` 2026-09-16 rule says personnel (oiler, operator) are dispatch resources
priced inside a load's code, not quote lines. On 2026-10-01 he added that a **certified operator**
is a separate billing code that *is* charged
([2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md](2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md),
point 4). A hidden default follows the first rule; leaving it switchable keeps room for the second,
and Joe asked on 2026-10-07 for settings he can change rather than a restricted rule.

## Conflicts

- **None found.** It moves the product toward the `verified` 2026-09-16 rule.
- **Caution, not a conflict.** Joe described the certified operator as **a billing code the
  salesperson adds** (2026-10-01, 19:30), not as a ticked association.

## Still open

*"Should a charged operator reach the quote by an admin ticking Show on the employee-type
association, or only as a separately added billing code such as Certified Operator?"* (TCG-218 Q19,
unanswered.) Joe's 2026-10-07 approval establishes that ticking is **possible**; it does not say
which route sales should use for a charged operator. Owner: Joe Schacatano.

## Effect on the vault

- No vault-file status flips.
