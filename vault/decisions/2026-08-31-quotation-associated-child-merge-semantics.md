---
title: Re-selecting a quotation item merges associated children — add missing, keep existing, never duplicate
source: Jahanzaib Nadeem (in-session decision while fixing quotation resource nesting)
migrated: 2026-08-31
updated: 2026-08-31
status: reference
conflicts_with: []
tags: [module/quotations, module/asset-management, kind/decision, resource-hierarchy]
entities: [QuotationResource, SubCategoryAssociatedResource]
---

# Associated-child merge semantics

Decided by **Jahanzaib Nadeem** on 2026-08-31, while fixing duplicated and wrongly
nested child rows on the quotation Resources tab.

## The rule

When a resource row's item is selected — including **re-selecting the value it already
has** — its catalog associations are **merged** into the row's children, keyed by
normalized item name:

- an associated item **not** already a child is **added**
- an existing child is **kept**, with its own id and edits intact
- nothing is ever added twice
- a manually added child that is not in the catalog is **left alone**
- the merge recurses, so a newly associated **grandchild** appears under an existing child

So if an admin adds "Oiler" to "275 Ton Crane" after a quotation was built, re-picking
that item on the row pulls "Oiler" in without disturbing the Operator and Rigger rows
already there.

## Why this needed deciding

The old code **appended** the whole association subtree on every write to the `item`
field. Because re-selecting the same value is a real code path — the billing-code
creation flow deliberately re-fires the selection to refresh pricing — children were
duplicated, and the duplicates **reused the existing ids**. That produced repeated React
keys, edits that hit several rows at once, and rows that silently collapsed on save
because the API upserts by id.

The fix could have been either "make the re-fire a no-op" or "make the merge
idempotent". Idempotent merge was chosen because it also delivers the newly-associated
case above; a no-op guard at the trigger would have blocked it.

Implemented as `mergeChildTree` in
`apps/web/src/features/quotations/components/organisms/resources-tab.child-tree.ts`,
covered by `resources-tab.child-tree.test.mjs`.

## Related, decided at the same time

Catalog association expansion now carries a **cycle guard** on the ancestor path. The
API rejects a sub-category associated to itself but not a loop through a second one
(`A -> B -> A`), which previously recursed to the depth cap and materialised levels of
alternating unrelated rows.

**Still open:** whether the API should reject multi-hop association cycles at
configuration time rather than leaving each consumer to guard. Logged in the quotations
module gaps register.
