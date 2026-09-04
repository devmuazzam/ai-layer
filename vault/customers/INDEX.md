---
title: Customers — module index
status: reference
kind: index
updated: 2026-09-04
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
| [customer-and-job-sites.md](customer-and-job-sites.md) | JZ punch list: job-site contacts/certs, insurance, billing terms | 1.8 |
| [fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md) | **What FCC actually stores per customer** — the four `FMS_CUSTOMER*` tables, their columns, joins and code lists, the four lookup vocabularies in full, row counts, and the field-by-field mapping onto the ERP's Prisma models | 27.3 |
| [fcc-maintain-customers-tcg-review.md](fcc-maintain-customers-tcg-review.md) | TCG's own annotations on FCC's Maintain Customers screens — what to keep, what is "not needed", the four-value status, job-site contacts and certifications | 8.5 |
| [fcc-customer-import-template.md](fcc-customer-import-template.md) | Which customer fields FCC requires, their formats and length limits; terms and salespeople as import vocabularies | 9.9 |
| [quickbooks-customer-table-audit.md](quickbooks-customer-table-audit.md) | What QuickBooks holds per customer, how it keys to FCC (`AcctIntCode`), its terms and type vocabularies, and where its data is messy | 8.2 |
| [new-customer-packet.md](new-customer-packet.md) | What TCG collects from a first-time customer before the first job — deposit and COD terms, credit application, lien notice, and the fleet hour minimums | 9.9 |
| [customer-onboarding-flow-chart.md](customer-onboarding-flow-chart.md) | Lead → quote → job → credit decision, as a flow chart: which role does what, and how the new-customer packet gates terms vs COD | 7.5 |

### Reading order for the FCC material

The last six rows of that table are all new on 2026-09-04, from the *Project Repository* drop.
Read them in this order: [fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md) first
(it is the schema everything else refers back to), then
[fcc-maintain-customers-tcg-review.md](fcc-maintain-customers-tcg-review.md) for what TCG wants
done with it. The other four are standalone.

Client feedback on the customers module also sits in the cross-module register
[erp-review-log.md](../erp-review-log.md) — entry **#8** (Melissa, 2026-05-02) is entirely
customers: Territory under industry, an attachment section, a note section, and linking the
customer to projects, quotes and invoices. Its *Data import* section is the stated policy behind
the migration extracts.

## Decisions that bind this module

- [2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) — Archive replaces delete, app-wide — decision
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

8 meeting files carry `module/customers` — list them:

```
grep -rl 'module/customers' vault/meetings/
```
