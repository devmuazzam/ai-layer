---
title: A billing code name is unique per tenant and type category, not tenant-wide — decision
source: decision/Jahanzaib Nadeem
decided: 2026-10-22
decided_by: >-
  Jahanzaib Nadeem (git: Jz-Nd, jahanzaib.nadeem@codingcops.com), CodingCops developer working
  branch fix/quotation-same-name-subcategory-billing-code (no ticket), stated in a Claude Code
  session on 2026-10-22: "they are different things — this shouldn't occur". This is a
  CodingCops developer ruling, not a TCG client confirmation, and it is not certain he holds
  product authority over catalogue naming. `status: reference` — binding on the build now,
  open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: >-
  none (no open §12 or module gaps.md entry asked this; raised directly in the session while
  fixing the quotation resource row's "Billing code already exists" error)
jira: []
tags: [module/quotations, module/assets, kind/decision, pricing, reference-data, architecture]
---

## Decision

**A billing code's name is unique within a tenant *and* type category, not across the whole
tenant.** An ASSETS billing code for sub-category "X" and a CUSTOM billing code for custom type
"X" may both be named "X". Two billing codes of the same type category still may not share a
name.

Developer's words: *"they are different things — this shouldn't occur"* — i.e. a custom type
being blocked from getting its billing code because a sub-category of the same name already has
one is the defect, not the rule.

Shipped on the branch as `@@unique([tenantCompanyId, typeCategory, name])` on `BillingCode`
(was `@@unique([tenantCompanyId, name])`), migration
`20261022150000_billing_code_name_unique_per_type`. The new index is looser than the one it
replaces, so every existing row already satisfies it — no data rewrite.

## Why

- **The defect.** Creating a billing code from a quotation resource row pre-fills the item's
  name. A custom type whose title matches a sub-category name could therefore never get a billing
  code: the create failed with *"Billing code already exists"*.
- **Different things.** A sub-category, a custom type and a role are distinct catalogue items
  with their own billing codes; a shared display name does not make them the same item.
- **Nothing written says otherwise** (searched 2026-10-22): no vault file, Confluence page found
  by search, or ticket spec requires billing code names to be unique tenant-wide. The tenant-wide
  index was an implementation choice with no recorded source. The nearest written hints lean the
  same way: `quotations/billing-code-and-price-list.md` (unverified, 2026-09-04) — *"For custom –
  we should be able to re-use same sub categories multiple times"*; and
  `quotations/gaps.md#sub-category-association-cycles--rejected-at-self-reference-only-not-at-multi-hop`
  (open) already flags name-matching across sub-categories and custom types as a hazard.
  **Jira was not checked** — the Jira API returned 403 (*tenant restricted: suspended-payment*).

## What this does not decide

- **Custom-type titles are not checked against sub-category or role names** — this is current
  behaviour, and **nothing written specifies it either way**. This note does not make it a rule.
- **Sub-category names are unique tenant-wide** — that one *is* written:
  `decisions/2026-09-02-sub-category-names-tenant-unique.md` (`status: reference`). Unaffected.
- The related open question of whether quotation association lookup should match on item
  **name** or on the resolved FK id stays open in `quotations/gaps.md` (anchor above).

## Effect on the vault

- No winner/loser files: this resolves no recorded conflict, so no frontmatter edits were made.
- No gaps entry to close.
