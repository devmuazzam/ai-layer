---
title: An "Always Included" associated child has no delete control on a quotation — the salesperson cannot remove it
source: design stated to the client on three recordings, acknowledged once by name; recorded 2026-09-04
decided: 2026-03-17
decided_by: >-
  Ehtesham Anwar (CodingCops) stated the rule in the 2026-03-17 sales/quoting Figma review
  and re-stated it against working software on 2026-03-24 (to Kyle Harlow) and 2026-05-05
  (to Brian Petros, Melissa McNutt, Corrina Bustos). Ryan Adams (TCG) is the one named TCG
  voice to acknowledge it — "this is exactly how the other program was I used… I was just
  making sure it had that". No TCG decision-maker ever ratified it as a requirement, and
  Brian Petros flagged the 2026-03-17 screens as mock-ups in the same call, so this is
  status: reference — a sourced, demoed, unobjected design, not an adjudicated decision.
status: reference
conflicts_with: [decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md]
tags: [module/quotations, module/asset-management, kind/decision, resource-hierarchy, requirements]
entities: [QuotationResource, SubCategoryAssociatedResource, quotation]
---

## Decision

A sub-category **associated resource** carries an inclusion type. It drives whether the
salesperson may take the auto-populated row off a quotation:

- **Always Included** — the row is auto-populated and **has no delete control**. The quote
  cannot be created without it.
- **Optional** — the row is auto-populated and the salesperson **may remove it**.

The stated treatment is the absence of the affordance, not a blocked click: *"person is not
going to see this removal button. If it is selected optional then and only then they are
going to see this."* The same rule was said to apply to job dispatchers later.

## Why — it was demoed three times and never objected to

`meetings/transcripts/2026-03-17-sales-quoting-figma-demo.md`, **Ehtesham Anwar @ 14:34**
(line 58), introducing associated field assets:

> *"for example a crane is going, you need an employee. That is an operator, right? So for
> that you will say OK this is **always included**… Based on the inclusion type, for example,
> if the inclusion type is always included, **the salesperson will not be able to remove this
> associated asset. They will have to create quotation with that.** If that is optional,
> they'll be able to remove that asset."*

Same file, **@ 34:28** (line 125), on the quotation screen itself — this is the line that
specifies the *treatment*:

> *"if [it] is always included then person is **not going to see this removal button**. If it
> is selected optional then and only then they are going to see this… people will not just
> have the validations, they are going to be bound by these SOPs that we incorporate within
> this portal."*

**Ryan Adams (TCG) @ 35:06**, immediately after, is the client acknowledgement:

> *"Yep, no, this is perfect. This is exactly how the other program was I used where it just
> had the trash can where you could just delete the line items. So Yep, I was just making
> sure it had that."*

Re-stated twice against running software, to different audiences:

- `meetings/transcripts/2026-03-24-tcg-cc-product-sync-demo.md`:75 — to Kyle Harlow:
  *"this first one was required. **You don't have the delete option**, so that by default means
  it's always going to be added to the quotation and it's always going to be sent. These are
  optional. Salespeople can remove them."*
- `meetings/transcripts/2026-05-05-tcg-erp-system.md`:102 — to Brian Petros, Melissa McNutt and
  Corrina Bustos, clicking through the real system: *"define if they are always included or
  optional… on the quotation end, our salesperson cannot remove if they are always included."*
  (The transcript garbles the polarity mid-sentence; the intent matches the other two and the
  live demo.)

## Why this is `reference` and not `verified`

The rule is stated by **CodingCops, not by TCG**. Ryan Adams accepted it, but his sentence is
about the trash can existing for optional lines rather than an explicit ruling on the locked
case, and Brian Petros said of the 2026-03-17 material in the same call: *"these are mock-ups…
this is still in the planning phase."* Three consistent statements over seven weeks, two of
them against working software with the decision-makers present and no objection, is strong
evidence of intent — it is not the same thing as a named TCG decision-maker adjudicating it.
Treat it as the answer to build against, and upgrade it to `verified` if TCG confirms.

## Implementation as of 2026-09-04

`_childItemRequired` on a resource form row, set from `SubCategoryAssociatedResource.isRequired`:

- `apps/web/src/lib/resource-catalog.ts` and
  `apps/web/src/features/quotations/components/organisms/resources-tab.helpers.ts` carry the flag
  onto generated and virtual child rows, and onto real children matched by normalized item name.
- `resources-tab.child-tree.ts` `ChildTreeNode.isRequired` carries it through the merge described
  in [2026-08-31-quotation-associated-child-merge-semantics.md](2026-08-31-quotation-associated-child-merge-semantics.md),
  so a child pulled in by re-selecting an item arrives already locked.
- The row hides its trash control, and `removeNodeFromTree` in `resources-tab.state.helpers.ts`
  **refuses the removal** if that gate is bypassed — belt and braces, matching *"not going to see
  this removal button"* rather than replacing it with an error.

## What this does not settle

- **The rule for job dispatchers.** Ehtesham said *"same is going to be the functionality later
  on for job dispatchers"* — a forward statement about a surface that was not being demoed.
  Unbuilt and unspecified.
- **What happens to an existing quotation when an admin later flips an association from
  Optional to Always Included**, or removes the association entirely. The merge decision covers
  *adding* a new associated child; it does not say whether a lock is applied retroactively to a
  row already on a saved quote.
- **Whether a required child may be edited** — quantity, rate, comments — as opposed to removed.
  Only removal was ever discussed.
