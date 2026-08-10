---
title: Agencies and vendors — conflict stub
source: generated/conflict-stub
migrated: 2026-08-10
updated: 2026-08-10
status: unverified
kind: conflict-stub
gap: gaps.md#agencies-and-vendors
conflicts_with: [product/agencies.md, product/vendors.md, product/agency-and-vendor.md, product/agencies-module.md]
jira: []
topics: [agencies, vendors, permits, dispatch]
entities: [agency, vendor, permit, attachment]
---

# Agencies and vendors — four sources, two entities

**None of these is verified. Do not answer from one of them alone.**

Note first that **Agencies and Vendors are different entities** — agencies issue
permits, vendors supply services and equipment — but two of the four sources cover
them together, so the set is easy to misread as one topic.

| Candidate | Size | Updated | Kind | What it uniquely covers |
| --- | --- | --- | --- | --- |
| [vendors.md](vendors.md) | 3.7 KB | 2026-04-30 | User stories | The only vendor spec. Vendor directory with search, written from the Dispatch Manager's perspective, with acceptance criteria. |
| [agencies.md](agencies.md) | 1.0 KB | 2026-04-30 | User stories | The only agency spec. Agencies as a central directory whose details **auto-populate into the permit creation form**, with per-agency attachments (plan requirements, submitter applications, business licenses) and full CRUD. |
| [agencies-module.md](agencies-module.md) | 1.4 KB | 2026-07-22 | Punch list | Mohsin feedback, presentation-level: missing KPIs and quick filters, avatar before agency name, restriction column, notes/attachments tabs, sticky footer, draft functionality. Also carries an "Across the app" block (US date format, breadcrumb spacing, activity-log behaviour) that is **not agency-specific**. |
| [agency-and-vendor.md](agency-and-vendor.md) | 0.2 KB | 2026-06-22 | Punch list | JZ feedback, 8 lines. Vendor sub-contractor categorisation, billing terms, taxable fields; agency travel restrictions. |

## Why recency is the wrong rule here

The two **newest** files are the two **smallest**, and both are punch lists. The only
user-story-level content — the acceptance criteria that say what these modules are
*for* — is in the two oldest files. Ordering by date discards the specification and
keeps the bug list.

See the full entry in [`gaps.md`](../gaps.md) → *Agencies and vendors*.
