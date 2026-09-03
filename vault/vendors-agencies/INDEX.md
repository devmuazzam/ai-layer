---
title: Vendors Agencies — module index
status: reference
kind: index
updated: 2026-08-24
tags: [module/vendors-agencies, kind/reference]
---

# Vendors Agencies

Vendors, agencies, purchase orders. Backend usecases: `vendors, agencies, purchase-orders`. Organized per [STRUCTURE.md](../STRUCTURE.md).

> **Conflict stub first:** [agencies-vendors-INDEX.md](agencies-vendors-INDEX.md) — competing sources, none verified. Do not answer from a single document while it is non-empty.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [agencies-vendors-INDEX.md](agencies-vendors-INDEX.md) | **Which source is authoritative?** (none) | 1.9 |
| [vendors.md](vendors.md) | Vendor directory and search, from Dispatch Manager's view | 3.7 |
| [agencies.md](agencies.md) | Agencies as a directory that auto-populates permit forms | 1.0 |
| [agencies-module.md](agencies-module.md) | Agency UI punch list + cross-app items | 1.4 |
| [agency-and-vendor.md](agency-and-vendor.md) | 8-line punch list: sub-contractor category, travel restrictions | 0.2 |
| [purchase-order.md](purchase-order.md) | Purchase order handling | 4.7 |

## Decisions that bind this module

- [2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) — Archive replaces delete, app-wide — decision
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

6 meeting files carry `module/vendors-agencies` — list them:

```
grep -rl 'module/vendors-agencies' vault/meetings/
```
