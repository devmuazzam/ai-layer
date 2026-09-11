---
title: Billing code type master dropped — decision
source: decision/Fouzan Shakil
decided: 2026-09-11
decided_by: >-
  Fouzan Shakil (CodingCops), stated 2026-09-11 in a Claude Code review session
  of branch `fix/das-fixes`, in answer to explicit questions. Not a TCG
  client-side product-owner sign-off. Recorded `status: reference` — binding on
  the CodingCops build, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: []
supersedes_partial:
  # the line "Add billing code type CRUD" only; the rest of the file is untouched
  - quotations/billing-code-and-price-list.md
jira: []
tags: [module/quotations, module/admin, kind/decision, pricing, reference-data]
---

# Billing code type master dropped

## Decision

Fouzan Shakil, 2026-09-11:

1. **Dropped:**
   - the `billing_code_types` table;
   - the `BillingCodeTypeStatus` enum;
   - the `billing_codes.billing_code_type_id` column.

   Migration:
   `apps/api/prisma/migrations/20260911040000_drop_billing_code_types/migration.sql`. The commit
   is `12c3c4e30`, which is `b4cef85b1` on `fix/das-fixes` after a rebase (same patch-id).
2. **Everything dropped is recorded in the vault**, so it can be re-seeded if it is ever needed:
   the DDL, the default seeds, the FCC billing types and code→type links, and the removed code
   with a restore recipe. The record is
   [../quotations/billing-code-types-dropped-2026-09-11.md](../quotations/billing-code-types-dropped-2026-09-11.md).
   It was being written in parallel and **did not yet exist when this note was written**.
3. **This supersedes the ask *"Add billing code type CRUD"*** in
   [../quotations/billing-code-and-price-list.md](../quotations/billing-code-and-price-list.md):23.
   The line stays in that file, because migrated bodies are not edited. Its frontmatter
   `provenance_note:` points here. For the CodingCops build, the conflict between that ask and
   the drop is now decided.

## Why

Fouzan gave no reason in the session beyond the drop itself. The code describes the master as
*"unused"* (commit message) and *"optional … (display/metadata only)"* (migration comment). Those
are the code's own descriptions, not a product reason. The drop is reversible because of the
reference record.

## What TCG's own sources say (surfaced, not resolved)

Nothing written from TCG says the lookup is not needed:

- **TCG's reviewed FCC slides show Billing Code Types as a live lookup**: 37 rows, all Active
  ([../quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md)
  §*Billing Code Types (slide 12)*, `unverified`). TCG did **not** mark it *"don't use/need"*. On
  the same deck they did reject Taxable, Exceptions and Billing Costs
  ([../quotations/billing-code-and-price-list.md](../quotations/billing-code-and-price-list.md):61-67).
- **FCC's import template has a `Billing Types` sheet**, with no TCG values supplied
  (`fcc-billing-data-and-price-lists.md`:100).
- **The punch list asks for CRUD on it** (`billing-code-and-price-list.md`:23, `unverified`).

This is a CodingCops call, recorded as `reference`. TCG may overrule it, and the reference record
is how the master would be restored.

## Effect on the vault

- **Done (frontmatter):** [../quotations/billing-code-and-price-list.md](../quotations/billing-code-and-price-list.md)
  gets a `provenance_note:` pointing here. Its body is unchanged. `status:` stays `unverified`.
  `conflicts_with:` is unchanged, because its one conflict is about yards, not types.
- **Done (gaps update):**
  [`../admin/gaps.md#what-a-newly-created-tenant-must-contain--provisioned-defaults-or-an-empty-portal`](../admin/gaps.md#what-a-newly-created-tenant-must-contain--provisioned-defaults-or-an-empty-portal).
  In the current build, item (b) no longer has a table to seed. Items (a), (c) and (d) are
  unaffected.
- **Done (gaps update):**
  [`../dispatch/gaps.md#crane-configuration--is-a-support-load-an-asset-or-a-line-on-the-crane`](../dispatch/gaps.md#crane-configuration--is-a-support-load-an-asset-or-a-line-on-the-crane).
  Its 2026-09-01 correction cites the `CWT` / `OPL` / `SUPP` billing-code-type seeds in
  `seed-data.ts`, and this drop removes them.

## What this does not settle

- **Whether TCG needs a billing-type classification at all.** See the section above.
