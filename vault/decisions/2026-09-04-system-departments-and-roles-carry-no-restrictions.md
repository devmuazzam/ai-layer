---
title: Seeded (isSystem) departments and roles carry no restrictions — the flag is a badge, not a lock
source: decision/developer confirmation in PR review of fix/customer-quotation-3sep (CodingCops)
decided: 2026-09-04
decided_by: >-
  The developer working branch `fix/customer-quotation-3sep` (CodingCops), acting for the
  product owner, stated the rule directly in PR review on 2026-09-04 and asked for it to be
  locked in. No individual TCG name is on it. The gap it closes nominated Fouzan Shakil as
  owner for parts (a)–(c) and Ehtesham Anwar for the lockout half, and neither is recorded as
  having decided this. `status: reference` rather than `verified` — binding on implementation
  now, open to being overruled by TCG — matching every other developer-side decision in this
  folder (`2026-08-20-archive-instead-of-delete-app-wide.md`,
  `2026-09-01-post-save-navigation-create-goes-to-detail.md`,
  `2026-09-01-subsistence-not-a-craft-attribute.md`).
status: reference
conflicts_with: []
resolves: admin/gaps.md#system-departments-and-roles-are-now-fully-editable--was-issystem-ever-meant-to-protect-anything
tags: [module/admin, module/payroll, kind/decision, permissions-roles, reference-data, requirements]
---

## Decision

**Seeded departments and department roles carry no restrictions.** A tenant admin may edit,
rename, archive and delete a row with `isSystem: true` exactly as they may one they created
themselves. There is no protected set.

`isSystem` survives as a **display flag only** — it drives the "System" badge on the
department card, the role card and the role edit header, and it governs nothing else. It does
not gate a mutation in the API and it does not gate a control in the UI.

`lockedPermissions` likewise **imposes no restriction on the role edit screen**. A seeded
role's "core" modules may be changed or removed like any other role's.

## Why

**Nothing written ever asked for a protected set, and the one recorded walkthrough describes
the opposite.** In `meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md`:70
Ehtesham Anwar walks the entire flow as user-created — *"you will be able to create
departments… to create a department role itself you will have the role name, description of
the role and all of the permissions"* — and introduces the six named presets (manager, admin,
editor, viewer, contributor, guest) as a **"quick start template that is going to prefill
everything and preselect everything for you guys just for the ease of usage"**. A template is
a starting point. No participant in that call or any other asked for a locked department or a
locked role.

**Predefined is not protected.** Two closed Jira tickets say the seeded set is deliberate —
`SCRUM-467` *Seed Departments & Roles* (*"System should include predefined, hardcoded
departments and their roles"*) and `SCRUM-593` (*"Seed default departments; seed manager
default permissions as per our best understanding"*). Both are about **creating** the rows.
Neither says a word about what a tenant may afterwards do to them. The protection was an
implementation reading of *predefined*, not a requirement anyone wrote.

**Protection carved an exception into a convention that has none.** Archive-replaces-delete is
app-wide (`2026-08-20-archive-instead-of-delete-app-wide.md`), and PR #422 had already removed
`DELETE /departments/:code` in favour of archive. Leaving seeded rows unarchivable meant the
one removal path in the module did not apply to fifteen of its rows.

**The protected set barely exists.** Departments and roles are not provisioned at tenant
creation — an admin-created tenant comes up with zero of both, and `isSystem: true` is true
only in `PLATFORM` and `TCG-DEFAULT` (observed 2026-09-01, recorded in
[admin/gaps.md](../admin/gaps.md#what-a-newly-created-tenant-must-contain--provisioned-defaults-or-an-empty-portal)).
Blocking renames in the two tenants that happen to have seeded rows bought nothing and cost a
legitimate operation.

## What this settles

Parts (a), (b) and (c) of the gap, in order:

- **(a)** A tenant may edit, rename and archive a system department. All fifteen seeded
  departments (`DEPT-ACCOUNTS` … `DEPT-SALES`) behave like any other.
- **(b)** A system role may be deleted, `ROLE-ADMIN-CA` and the Sales manager roles included.
- **(c)** `lockedPermissions` is not a restriction on the edit screen. "A role cannot be
  stripped of the modules core to its job" is **not** a rule.

## What this does not settle

- **Whether a tenant can lock itself out — part (d) of the gap — is still open**, and this
  decision does not answer it. Role delete is a hard delete, so removing the last role
  carrying admin permissions is a route to a tenant nobody can administer. That is not an
  `isSystem` question: it applies identically to an admin role a tenant created itself, and
  `isSystem` was only ever shielding it by accident. Carried forward as its own entry —
  [admin/gaps.md](../admin/gaps.md#deleting-the-last-admin-capable-role-can-lock-a-tenant-out--is-a-floor-required).
- **What a newly created tenant must contain.** Untouched and deliberately so. This decision
  governs what may be done to seeded rows **that exist**; it says nothing about whether they
  should be created in the first place. See the entry linked above.
- **Whether `lockedPermissions` should remain in the schema.** The decision makes it inert:
  unenforced in the UI, and — since the rule is *no restrictions* — it must not be enforced in
  the API either. Dropping the column or keeping it as inert data is a cleanup call, not a
  product one. But **populated and unenforced is the one state that guarantees the next reader
  guesses wrong**, so it should be settled rather than left.
- **Whether this generalises to other seeded reference data** — billing code types, industries,
  craft codes are all seeded by the same file. Only departments and roles were decided.

## Implementation as of 2026-09-04 (branch `fix/customer-quotation-3sep`)

Already matches this decision:

- `apps/api/src/usecase/departments/departments.service.ts` — `update()`, `archive()` and
  `deleteRole()` no longer throw `ForbiddenException` on `isSystem`.
- `apps/web/.../department-card.tsx`:161, `department-role-card.tsx`:82,138 and
  `role-create.sections.tsx`:109 read `isSystem` **only** to render the "System" badge.
  `isProtected` in the role card gates the badge and nothing else.
- `role-create.tsx` no longer passes `role.lockedPermissions` into `ModulePermissionsSection`.
- `isSystem` and `lockedPermissions` remain in `apps/api/prisma/schema.prisma`:3964, 3991-3992
  and are still written by `apps/api/src/utility/seed-data.ts`.

One loose end, reported not fixed: `ForbiddenException` is still imported at
`departments.service.ts`:5 and no longer used anywhere in the file.

## Effect on the vault

**No content file changes status.** The gap's *Sources checked* records a vault-wide grep for
`isSystem|system-seeded|system department|system role|seeded (department|role|reference)`
returning nothing outside the gaps register itself, so there is no competing document to mark
`superseded` and no winner to promote to `verified`. The four-step gap-closing procedure in
[README.md](../README.md) reduces to its bookkeeping half here.

- [admin/gaps.md](../admin/gaps.md#system-departments-and-roles-are-now-fully-editable--was-issystem-ever-meant-to-protect-anything)
  → `Status: resolved`, pointing here; entry body left intact as the record of what was in
  question. **Done.**
- [admin/gaps.md](../admin/gaps.md#deleting-the-last-admin-capable-role-can-lock-a-tenant-out--is-a-floor-required)
  → new entry carrying the unresolved part (d). **Done.**
- [admin/INDEX.md](../admin/INDEX.md) → *Decisions* section listing this note. **Done.**
- [INDEX.md](../INDEX.md) → the `decisions/` table there is a **curated** set (7 rows against
  27 notes) that carries app-wide conventions only. No row added: this decision is scoped to
  departments and roles, and whether it generalises to all seeded reference data was not
  decided. **A human should add one if TCG confirms the wider rule.**
