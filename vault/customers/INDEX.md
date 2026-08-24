---
title: Customers — module index
status: reference
kind: index
updated: 2026-08-24
tags: [module/customers, kind/reference]
---

# Customers

Customers, customer contacts, job sites. Backend usecases: `customers, customer-contacts, job-site`. Organized per [STRUCTURE.md](../STRUCTURE.md).

> **Conflict stub first:** [customers-INDEX.md](customers-INDEX.md) — competing sources, none verified. Do not answer from a single document while it is non-empty.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [customers-INDEX.md](customers-INDEX.md) | **Which customer source is authoritative?** (none) | 2.5 |
| [customer.md](customer.md) | Mohsin punch list — mostly UI consistency | 6.1 |
| [customer-and-job-sites.md](customer-and-job-sites.md) | JZ punch list: job-site contacts/certs, insurance, billing terms | 1.2 |

## Decisions that bind this module

- [2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) — Archive replaces delete, app-wide — decision

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

7 meeting files carry `module/customers` — list them:

```
grep -rl 'module/customers' vault/meetings/
```
