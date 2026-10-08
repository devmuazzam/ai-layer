---
title: "'Also brings along' rows (an association's own associations) get their own Hourly Show and Mob/Demob Show + Main/Sub, stored per parent, hidden by default, cleared while the parent is hidden — configurable, no fixed rule (Syed Haris / ehtesham.anwar; approved by Joe Schacatano, 2026-10-07) — decision"
source: decision/Syed Haris (TCG-218 design, 2026-10-06), reinstated by ehtesham.anwar (2026-10-07), approved by Joe Schacatano on the recorded 2026-10-07 sprint review
decided: 2026-10-06
decided_by: >-
  Designed by Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218) in
  a Claude Code session on 2026-10-06/07, choosing "stored per parent association" over "owned by
  the child association". Withdrawn by him on 2026-10-07 (TCG-218 Q5 "never shown"), then reinstated
  the same day as ehtesham.anwar's decision (CodingCops), relayed by syed haris: "same solution for
  main item and sub-item, so there is no fix rule". Shown to Joe Schacatano (TCG VP of Sales, the
  quotation owner) on the recorded 2026-10-07 sprint review
  (meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md §7,
  48:42–50:30): ehtesham.anwar explained that Operator Load's sub-items carry these settings and
  that "sub-items can never be shown" is not coded in; Joe: "So we can customize it to however we
  want it to be basically… I'd rather have it be that way" (49:55), "I like how that's built out"
  (50:10). The configurable, hidden-by-default rule (points 1, 3, 4) is therefore client-approved.
  Point 2 (stored per parent rather than on the child) is a CodingCops design choice Joe did not
  discuss. Ported to overlay main 2026-10-09. Built on branch feat/association-document-visibility,
  under review.
status: verified
superseded_by: null
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md
  - 2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md
  - 2026-08-31-quotation-associated-child-merge-semantics.md
jira: []
tags: [module/quotations, module/assets, kind/decision, mob-demob]
---

# Nested ("also brings along") association rows: per-parent quote visibility

## Decision

On a sub-category's Associated Field Assets tab (to be renamed Field Assets Configuration), the rows
an association brings along are its own associations, shown as "also brings along" (e.g. Operator
Load → Tractor-Semi, Operator). Each such row:

1. **gets the same quote settings** as a direct association: Hourly Show, and Mob/Demob Show with
   Main item / Sub item while shown — *"same solution for main item and sub-item, so there is no fix
   rule"* (ehtesham.anwar, 2026-10-07). *(Client-approved, Joe 2026-10-07.)*
2. **is stored per parent association**, not on the child's own association row. The same child
   (e.g. Operator) can be shown under one crane's Operator Load and hidden under another's.
   *(CodingCops design — Syed Haris.)*
3. **is hidden by default** — Joe's 2026-10-01 "shouldn't be shown" becomes the default.
   *(Client-approved, Joe 2026-10-07.)*
4. **is disabled and cleared while the parent is hidden** on that quote type; a shown sub-item goes
   on the quote with its parent (nested on Hourly; its own line or into the groups on Hourly w/ Mob).
   *(Ticket owner, "Editable, quoted with parent", 2026-10-07; consistent with what Joe approved.)*

## Why

Joe Schacatano, 2026-10-07, 49:55–50:30: he wants the option to change anything *"just in case the
situation or variables change for us"*, and expects that a restricted rule would run into a case it
cannot handle. ehtesham.anwar (48:42): keeping it configuration rather than code keeps the code
generic.

## History

- 2026-10-06: built as above (Syed Haris).
- 2026-10-07: withdrawn by its author — TCG-218 Q5 answered "never shown", following Joe's
  2026-10-01 statement; per-parent columns to be dropped (Q8).
- 2026-10-07, later: reinstated — "Editable, quoted with parent"; attributed to ehtesham.anwar.
  Conflict with the 2026-10-01 operator-load note reopened, awaiting Joe.
- 2026-10-07, sprint review: Joe approved the configurable approach. **Conflict closed.**

## Conflicts

- **Closed:** [2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md](2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md)
  (`verified`). Joe refined his own 10-01 rule into this default on 2026-10-07. `conflicts_with`
  cleared on both notes.
- **Build question, not product:**
  [2026-08-31-quotation-associated-child-merge-semantics.md](2026-08-31-quotation-associated-child-merge-semantics.md)
  (`reference`) merges grandchildren into a quote by normalised name. Whether the quote layout reads
  the per-parent lists consistently through that merge is for `tcg-analyst`.

## Effect on the vault

- No vault-file status flips.
