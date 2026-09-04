---
title: Sub-category names are unique within a tenant, collisions renamed not merged — decision
source: decision/Syed Haris
decided: 2026-09-02
decided_by: Syed Haris (developer on TCG) — stated directly while unblocking the staging deploy that migration 20260901120000 had broken. He is not the client-side product owner, and the underlying product question in assets/gaps.md was never answered by TCG. It stands because the alternative was leaving a constraint that had already failed in production-shaped data, and because duplicates are demonstrably breaking plan-to-template binding today. `status: reference` — binding on implementation now, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: assets/gaps.md#sub-category-names--unique-per-tenant-and-does-an-archived-one-keep-its-name-reserved
jira: []
tags: [module/assets, kind/decision, sub-category, catalog, naming, migration]
entities: [sub-category, template, plan, tenant-company]
---

## Decision

**A sub-category name is unique within a tenant.** Existing collisions are resolved by
**renaming**, never by merging: the oldest row keeps the name, later ones take the lowest
free `"<name> (n)"` suffix.

Shipped as `20260902010000_sub_category_tenant_name_unique_with_dedup` — rename, then
constrain, in one transaction.

## Why renamed rather than merged

Merging was considered first and rejected. `template.sub_category_id` is `@unique`, a strict
one-to-one, so collapsing a group of duplicates **destroys one template per duplicate**. On
staging that meant losing two templates for `"Operator Load"` and two more for
`"90 Ton Hydraulic Truck Crane"`.

Renaming touches no relationships at all. Every asset, billing code, job resource,
substitution, permit request, checklist and template stays attached to the row it was
already on. The 11 foreign-key columns pointing at `sub_categories` are untouched.

## Why uniqueness at all — a live defect, not just tidiness

`Plan.craneCategory` is a `VARCHAR(100)` holding the sub-category **name**, not a foreign
key (`schema.prisma`). Two web call sites resolve it by string match:

- `plan-form-lift-fields.tsx:134` — `subCategoryOptions.find((sub) => sub.name === form.craneCategory)`
- `plan-form-additional-info-validation.ts:36` — the same pattern, driving field validation

`.find()` returns the **first** match. With three sub-categories sharing a name, a plan binds
to whichever the list endpoint returns first — and that ordering changed in PR #459 when
sub-category listing moved to capacity-based sorting. So the template a plan renders, and
the fields it validates against, were order-dependent.

`[INFERRED]` — read from the code, not reproduced against a database. The mechanism is
plain, but nobody has confirmed a specific plan mis-bound in practice.

Uniqueness makes that lookup deterministic. It does **not** make it correct — see below.

## Scope — what this does not decide

- **Question (b) is still open.** The index is deliberately not partial, so an **archived**
  sub-category keeps its name reserved forever. Under
  [2026-08-20-archive-instead-of-delete-app-wide](2026-08-20-archive-instead-of-delete-app-wide.md)
  archiving is the only way to retire a record, so no name is ever released. That is shipped
  behaviour, not a ratified rule.
- **Uniqueness within the parent category** — the other plausible reading, which would allow
  a `"Hydraulic"` under both Cranes and Trucks — was not chosen on evidence. It was not
  chosen because tenant-wide uniqueness is what the code already did and what
  `categories_tenant_company_id_name_key` has done since the baseline.
- **`SCRUM-959` is not the source for this.** It asks for no duplicate rows inside one
  sub-category's associated-resource list, which is a different requirement.
- **`Plan.craneCategory` should key on the FK, not the name.** Uniqueness makes the current
  lookup deterministic but still fragile: any future rename silently orphans a stored plan
  reference. Recorded as a follow-up in [../assets/gaps.md](../assets/gaps.md).

## Basis on which it was taken

Syed Haris stated the staging data is test data, so renaming those specific rows carries no
business cost, and that sub-categories will be unique going forward. That disposes of the
*data* objection to the constraint. It does not by itself answer whether TCG wants the rule —
that remains theirs to overrule.
