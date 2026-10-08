---
title: A quotation line's Measuring Unit stays locked once a billing code fills it (SCRUM-567 stands); TCG-198 criterion 4 dropped (Syed Haris, 2026-10-08) — decision
source: decision/Syed Haris — the TCG-198 fix, choosing between SCRUM-567 and the ticket's criterion 4
decided: 2026-10-08
decided_by: >-
  Syed Haris (CodingCops, the developer working TCG-198), stated 2026-10-08 in a Claude Code
  session on tcg branch `fix/8-oct`, picking one side of an explicit
  choice: keep the SCRUM-567 lock, or follow TCG-198 acceptance criterion 4 and let the unit be
  edited by hand. The implementation detail (unlock only when the code's unit maps onto no
  option) was decided alongside it. This is a CodingCops developer-side ruling, not a TCG
  client sign-off. That is why the status is `reference`: it binds the CodingCops build, and TCG
  can overrule it. Same basis as the other CodingCops decisions in this folder, e.g.
  decisions/2026-09-11-permit-approval-requires-linked-po.md.
status: reference
conflicts_with: []
resolves: []
related_decisions:
  - 2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md
jira: [SCRUM-567]
tags: [module/quotations, kind/decision, pricing, reference-data]
---

# A quotation line's Measuring Unit stays locked once a billing code fills it

## The conflict

Two written requirements disagree:

- **`SCRUM-567`** (Jira, Done, a client requirement), quoted in
  [`../quotations/gaps.md`](../quotations/gaps.md) lines 893–895, inside the entry
  [*Should a per-resource surcharge column be shown on quotation resource rows?*](../quotations/gaps.md#should-a-per-resource-surcharge-column-be-shown-on-quotation-resource-rows):
  *"Unit, Rate, and Amount should remain synchronized based on Billing Code. Unit should be
  displayed as a disabled field."* It was built in client commit `8702390df` (2026-07-03,
  *"lock unit of measure and warn on below-reference rate"*): the unit select is disabled once
  `pricingSource` is `billing_code` or `price_list_item`.
  The punch list [`../quotations/quotation.md`](../quotations/quotation.md) line 14
  (`unverified`) says the same: *"Resources measuring unit should be disabled — billing code"*.
- **TCG-198** (Linear, *"Quotations: Measuring Unit stays empty after choosing a billing
  code"*, <https://linear.app/the-crane-guys/issue/TCG-198>), acceptance criterion 4: *"The user
  can still change the Measuring Unit by hand if they need to."*

## Decision

Syed Haris, 2026-10-08:

1. **Keep the lock. SCRUM-567 stands.** Once a billing code (or price-list item) fills a line's
   Measuring Unit, the select is disabled.
2. **TCG-198 acceptance criterion 4 is dropped.**
3. **One exception, decided alongside:** the lock is lifted only when the billing code's stored
   unit maps onto **no** Measuring Unit option (e.g. FCC `MN`, `SQ`, which could each mean two
   units and are left unmapped rather than guessed). Then the select is blank and editable.

Answered by existing behaviour, not decided anew: the ticket's open question *"billing code with
no unit set up — blank or error?"*. The field stays blank (now editable, by point 3), and the
existing save validation *"Unit Meas is required"* applies.

## Why

- **SCRUM-567 is a shipped client requirement; criterion 4 is not.** A ticket's acceptance
  criterion written to fix an empty field is not a client decision to undo the lock, and the
  developer chose not to reopen a Done client ticket from inside a bug fix.
- **The exception exists because the lock made saving impossible.** A select that is both
  locked and blank cannot satisfy the save-time *"Unit Meas is required"* check, so a line whose
  code carries an unmappable unit could never be saved. Unlocking only that case keeps the
  SCRUM-567 behaviour everywhere a unit actually resolved.

## Background — what TCG-198 actually was

- **Root cause:** `billing_codes.unit_meas` is free text on the API. Seeded billing codes store
  `Hour` (demo, staircase seeds) or FCC abbreviations (`HR`, `EA`, `DY`), none of which is a web
  Measuring Unit option (`Hours`, `Each`, `Days`, ...). A value outside the options renders as the
  placeholder, so the unit looked empty though it was set. Codes created through the billing-code
  form always use the options, so only seeded data showed it.
- **Fix:** client branch `fix/8-oct`, commit `0e6da950b` — maps the stored
  unit onto an option in the browser
  (`apps/web/src/features/quotations/utils/resource-unit-measure.ts`: case, surrounding space,
  singular/plural, and the unambiguous FCC abbreviations), when a rate resolves and when a saved
  quotation loads. The unlock in point 3 is a client-only `unitUnresolved` flag, excluded from the
  payload and the dirty check.
- **No data migration.** Stored billing codes keep their raw values. The API still accepts any
  unit text on billing codes.

## What this does NOT settle

- **TCG's confirmation.** Nobody at TCG was asked whether criterion 4 reflects a real need to
  override a billing code's unit. If it does, this note is overruled and the lock comes off.
- **Whether `billing_codes.unit_meas` should be constrained to the option list** (API validation
  or a data migration of seeded / FCC-imported codes). Not decided; the browser mapping is the
  workaround.
- **What `MN` and `SQ` mean in FCC data.** Left unmapped deliberately.

## Effect on the vault

- **Done:** [`../quotations/INDEX.md`](../quotations/INDEX.md) → *Decisions that bind this
  module* lists this note.
- **Not changed:** [`../quotations/gaps.md`](../quotations/gaps.md). The SCRUM-567 quote there is
  evidence inside the surcharge-column entry, not an open question about the unit lock; that entry
  stays open on its own question. No gaps entry existed for this conflict.
- **Not changed:** [`../quotations/quotation.md`](../quotations/quotation.md) stays
  `unverified`. A `reference` developer ruling does not verify a client punch list.
