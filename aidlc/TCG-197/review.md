# TCG-197 / TCG-99 — shared quotation pricing, PR #749

Recorded 2026-10-08 after static review using `claude/skills/review-pr/SKILL.md`.
This is a retrospective implementation and review record, not a claim that the
full AI-DLC loop or runtime validation was completed.

- Platform PR: [#749](https://github.com/TheCraneGuys/craneguys-platform/pull/749).
- Platform and overlay branch: `fixes/TCG-99-shared-quotation-pricing`.
- Reviewed platform commit: `9b038e2acfcd5ad31e9a7cd5ca0ea4bb7cb3731e`.
- Tickets: [TCG-197](https://linear.app/the-crane-guys/issue/TCG-197/mobile-quotation-pricing-round-amounts-to-cents-same-as-web-tcg-99),
  the mobile follow-up to [TCG-99](https://linear.app/the-crane-guys/issue/TCG-99/quotation-resources-total-shows-3-decimals-in-one-place-2-in-another).

## Problem and resulting behavior

[INFERRED — code read] Web and mobile had separate copies of the quotation pricing
and resource-rollup functions. Web rounded each pricing adjustment to cents;
mobile's copy did not. PR #749 moves web's existing implementation into
`packages/shared/src/utils/quotation-pricing.ts`, exports it through the shared
barrels, and makes both existing application helpers re-export those functions.

The shared functions are `calculateResourceAmount`, `calculateResourcePricing`,
`isIncludedGroupChild`, `getGroupTotal`, `getResourceFinalAmount`, and
`sumResourceAmounts`, with the structural `PricedResource` type. The raw
`calculateResourceAmount` multiplication remains unrounded; `calculateResourcePricing`
rounds the base, discount, price hike, surcharge and final amount in web's existing
order. Discount and hike apply to the base; surcharge applies after those adjustments.
Group inclusion and nested-resource aggregation retain their existing behavior.

[INFERRED — code read] Web keeps its existing import surface and pricing behavior.
Mobile quotation pricing gains web's cent rounding. Mobile changes are limited to
`features/sales/quotation-pricing.ts` and its quotation-related tests. No mobile
ticketing files or API implementation files are changed by this PR.

## Product source and scope

[VERIFIED — read-only Linear queries] `get_issue(TCG-197)` and
`list_comments(TCG-197)` specify parity with web, including each adjustment's rounding
order and the exact `round2` helper. Syed Haris's technical comment dated 2026-09-29
(ID `35790f72-d759-4fd3-9050-51ec717beb7b`) explicitly permits considering shared
extraction to prevent future drift. This is a written implementation contract;
it is not a new adjudicated client pricing decision.

The ticket requires $138.24 for quantity 1, rate $137, discount 2.5%, surcharge 3.5%,
and $15,609.38 for quantity 5, rate $3,000, discount 7.5%, surcharge 12.5%.
These are expected results and assertions read from the PR, not executed results.

The `tcg-scrum` source handoff confirmed the mobile rounding change is sourced.
The broader question of whether resource rates may carry cents remains open in
`vault/quotations/gaps.md` under "Resources Total Value — UAT asks for exact decimals,
the code deliberately strips cents". PR #749 does not settle that question or
adjudicate the competing quotation documents listed in `quotations-INDEX.md`.

## Review evidence and ripple

[VERIFIED — static Git/search commands] `git diff origin/main...HEAD --stat` showed
8 changed files. A source-text comparison against the pre-PR web helper confirmed
the seven extracted calculation/normalization/rollup functions are identical after
ignoring comments and parameter type names; the `round2` body was inspected directly.
No application code was executed for this comparison.

[VERIFIED — consumer enumeration] Searched pricing symbols across `apps/web/src`,
`apps/mobile`, and `packages/shared/src`, and searched imports of `quotation-pricing`,
`resources-tab.helpers`, and `job-resources.mapper`. Consumers include web quotation
create/save, edit mapping and resource rows; Project Job resource mapping/display;
and mobile quotation state, resource rows, create/edit save payloads and wizard totals.
No mobile ticketing consumer was found.

[INFERRED — code read] No actionable code defect or unintended consumer behavior
change was identified. Project Job pricing continues through the existing web
helper with unchanged calculations. The shared calculation tests and mobile
quotation tests exercise rounding, payload components and rollups in source;
their results have not been verified. Direct web save and Project Job pricing
regression coverage remains a follow-up.

## Validation and verdict

Tests, builds and typechecking were explicitly excluded by the requester and were
not run. No passing gate or runtime parity claim is made.

Static-review verdict: **ship with follow-ups**. Follow-ups are direct regression
coverage for existing web save and Project Job pricing consumers. This record and
the appended `aidlc/processed.log` entry address the missing PR-specific loop trail.
Neither the ticket nor PR is marked complete or merged by this writeback.
