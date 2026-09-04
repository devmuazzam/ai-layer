---
title: Admin — module index
status: reference
kind: index
updated: 2026-09-04
tags: [module/admin, kind/reference]
---

# Admin

Auth, users, tenancy, settings, reference data. Backend usecases: `auth, users, permissions, tenant-companies, reference data`. Organized per [STRUCTURE.md](../STRUCTURE.md).

## Files

| File | Answers | KB |
| --- | --- | --- |
| [tcg-documents.md](tcg-documents.md) | Document and attachment handling | 1.8 |

## Decisions

| Decision | What it settles |
| --- | --- |
| [decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md](../decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md) | Seeded (`isSystem`) departments and roles may be edited, archived and deleted like any other — the flag is a display badge, and `lockedPermissions` restricts nothing. `status: reference` (decided by a CodingCops developer in PR review, not by TCG). **Tenant lockout and what a new tenant is provisioned with are not settled** — see [gaps.md](gaps.md) |

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

3 meeting files carry `module/admin` — list them:

```
grep -rl 'module/admin' vault/meetings/
```
