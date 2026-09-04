---
title: Admin — module index
status: reference
kind: index
updated: 2026-09-04
tags: [module/admin, kind/reference]
---

# Admin

Auth, users, tenancy, settings, reference data. Backend usecases: `auth, users, permissions, tenant-companies, reference data`. Organized per [STRUCTURE.md](../STRUCTURE.md).

Since the 2026-09-04 Project Repository drop this folder also holds **the engagement itself** —
the RFP and SOW that scope the work — and **the legacy FCC NexGen system as a system**: its
administration and security model, its database, its reports, and FCC's own assessment of how TCG
uses it.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [tcg-documents.md](tcg-documents.md) | Document and attachment handling | 2.2 |
| **The engagement** | | |
| [tcg-erp-rfp-2026-02-26.md](tcg-erp-rfp-2026-02-26.md) | What did TCG ask for? Scope, phases, integrations, must-haves, timeline, evaluation | 12.8 |
| [codingcops-sow-and-engagement-terms.md](codingcops-sow-and-engagement-terms.md) | What was contracted? NDA, dedicated-team model, change requests, and the Sprint 1 feature-by-feature scope | 11.7 |
| [responsive-design-and-security-posture.md](responsive-design-and-security-posture.md) | What did we tell TCG about responsiveness, auth, RBAC, data protection and Samsara, in March 2026? | 8.9 |
| [engagement-directory-and-org-charts.md](engagement-directory-and-org-charts.md) | Who is Melissa, Corrina, Brian, Wes, Lisette? Who does what at TCG and CodingCops? | 5.9 |
| [project-repository-filing-rules.md](project-repository-filing-rules.md) | What do the numbered folder paths in every source citation mean? | 3.9 |
| **FCC NexGen as a system** | | |
| [fcc-nexgen-health-check-2025-12-16.md](fcc-nexgen-health-check-2025-12-16.md) | How does TCG actually operate today, department by department, and where does it work around the system? | 14.7 |
| [fcc-nexgen-database-catalogue.md](fcc-nexgen-database-catalogue.md) | What is in the legacy SQL Server database — objects, columns, keys, the FK graph, data sensitivity — and how has it been classified for migration? | 20.1 |
| [fcc-nexgen-administration-and-security.md](fcc-nexgen-administration-and-security.md) | How does NexGen's permission model work, and what did TCG say it needs from company setup? | 11.5 |
| [fcc-nexgen-reporting-catalogue.md](fcc-nexgen-reporting-catalogue.md) | Which reports does the legacy system ship, and what columns does each print (from the guide's screenshots)? | 22.4 |
| [fcc-activity-code-master-list.md](fcc-activity-code-master-list.md) | What are the work-order activity codes and equipment groups? | 6.8 |

## Elsewhere

- [../erp-review-log.md](../erp-review-log.md) — the client's own cross-module feedback register.
  Its *Project management* items (a shared feedback tracking log; a 2–3 month ERP roadmap; sharing
  the vendor's process with TCG), its *Permissions* items and its *Training* item are admin
  subjects; the log itself is product-wide and lives at the vault root.
- [../domain/fcc-nexgen-fms.md](../domain/fcc-nexgen-fms.md) — what FCC, NexGen and Atom *are*.
  Start there; the four `fcc-nexgen-*` pages here are its detail.
- [../domain/tcg-it-value-engines-and-playbooks.md](../domain/tcg-it-value-engines-and-playbooks.md)
  — TCG IT's own intake, build-vs-buy, security-review and change-management process.

## Decisions

| Decision | What it settles |
| --- | --- |
| [decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md](../decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md) | Seeded (`isSystem`) departments and roles may be edited, archived and deleted like any other — the flag is a display badge, and `lockedPermissions` restricts nothing. `status: reference` (decided by a CodingCops developer in PR review, not by TCG). **Tenant lockout and what a new tenant is provisioned with are not settled** — see [gaps.md](gaps.md) |

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

6 meeting files carry `module/admin` — list them:

```
grep -rl 'module/admin' vault/meetings/
```
