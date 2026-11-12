---
title: Assets — module index
status: reference
kind: index
updated: 2026-11-12
tags: [module/assets, kind/reference]
---

# Assets

Assets, yards-as-records, tools & rigging, categories. Backend usecases: `asset-management, parts, manufacturers, yards, categories`. Organized per [STRUCTURE.md](../STRUCTURE.md).

## Files

| File | Answers | KB |
| --- | --- | --- |
| [user-story-and-tasks.md](user-story-and-tasks.md) | **Only** source for yard management, HubSpot sync, email 2FA. From a personal space — check `provenance_note` | 4.3 |
| [tool-and-rigging.md](tool-and-rigging.md) | Tools & rigging management, incl. the yard dashboard | 3.7 |
| [loading-list.md](loading-list.md) | **Dylan's loadable tool catalog** — 26 items with quantities, in load order; and the permanent per-crane kit it excludes | 4.0 |
| [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) | **The FCC unit data, end to end** — 25 schedule types, 76 resource types, the 156-column unit table and which 78 columns migrate, the one-unit-many-types substitution table, the import contract, and the 444-table schema inventory with a disposition each | 34.0 |
| [crane-fleet-reference.md](crane-fleet-reference.md) | **Which cranes TCG actually has** — unit code → model → tonnage class, the four naming vocabularies that disagree, the operator/support-load trailers, rating & de-rating, wind sail, and the load-chart library (not migrated) | 23.6 |
| [crane-selection-and-load-chart-model.md](crane-selection-and-load-chart-model.md) | Ryan's estimator workbook — the **load-chart data model, 8 recommendation gates and per-manufacturer source authority** TCG has already designed. Rules are the deliverable; the capacity numbers are flagged untranscribed | 15.5 |
| [storage-and-warehouse-operations.md](storage-and-warehouse-operations.md) | **Only** source for storage — FCC storage tickets, rates and invoicing, plus TCG's Receiving / Inventory Audit / Shipping SOPs | 18.2 |
| [asset-record-requested-additions.md](asset-record-requested-additions.md) | What TCG has asked to add to the asset record — emissions and GVWR fields, loan block, asset batches, fuel app, Samsara, 13 dashboards; reconciled against the review log's own list | 9.9 |
| [fcc-atom-iti-integration.md](fcc-atom-iti-integration.md) | FCC ↔ ITI Learning Hub certificate sync, and the Atom Display Menu. *Subject is certifications — filed here by drop group* | 6.9 |
| [equipment-onboarding.md](equipment-onboarding.md) | How a new machine becomes dispatchable — the on-boarding value engine and the (stub) FCC creation playbook | 5.8 |
| [trailer-inspection-form.md](trailer-inspection-form.md) | The paper trailer inspection checklist, version 1 — 24 side-by-side checks plus 8 conditional ones | 4.1 |
| [fcc-samsara-reconciliation-2026-09-21.md](fcc-samsara-reconciliation-2026-09-21.md) | **The FCC ↔ Samsara comparison, re-measured** — FCC has no VIN column, the `LowerGPSID` Samsara link it already carries on 45 units (4 of them shared by two units), which dispatchable cranes are untracked, eight silent gateways, and a per-unit adjudication of every VIN conflict | 11.0 |
| [samsara-data-audit-and-edit-access-brian-2026-11-12.md](samsara-data-audit-and-edit-access-brian-2026-11-12.md) | **Brian's Samsara audit email (2026-11-12)**: locking down who edits asset data in Samsara, his eight "will break the ERP sync" findings checked against our 09-21 measurements, External IDs proposed as the link, and where make, model and DMV make codes come from | 10.1 |
| [categories-and-sub-categories.md](categories-and-sub-categories.md) | Category/sub-category questions (2 tags — thin) | 0.6 |

## Also relevant

- [erp-review-log.md](../erp-review-log.md) §**#7 — Assets** — the client's own asset wish list
  (categories, compliance/expiry, PERP & DOORS, crane attributes, photos, load-chart attachments),
  plus its *Assets and rigging* and *Data import* sections
- [quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md)
  — the estimate-template half of `FCC_UNITS-ASSETS-ResourceTypes_20260902.xlsx`; the assets half is
  in `fcc-units-and-schedule-types.md` §6

## Decisions that bind this module

- [2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) — Archive replaces delete, app-wide — decision
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20
- [2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md) — The resource type's Unit/People set is for dispatch, not the quote; the salesperson picks the resource type directly (Joe Schacatano, `verified`)
- [2026-09-30-sub-category-target-hours-per-month-whole-number-0-to-744.md](../decisions/2026-09-30-sub-category-target-hours-per-month-whole-number-0-to-744.md) — Sub-category Target Hours Per Month: optional, whole number, 0–744 (24 x 31), web + API; developer ruling (Syed Haris, TCG-153), `reference`
- [2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md](../decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md) — Per-association Hourly Show and Mob/Demob Show + Main/Sub item, configurable from the front end (approved by Joe 2026-10-07, `verified`); the two Show settings independent (ticket owner)
- [2026-10-06-employee-type-associations-start-hidden-on-the-quote.md](../decisions/2026-10-06-employee-type-associations-start-hidden-on-the-quote.md) — Employee-type associations start hidden, can be ticked (Joe 2026-10-07, `verified`); backfill keeps saved quotes (ticket owner)
- [2026-10-06-nested-association-quote-visibility-stored-per-parent.md](../decisions/2026-10-06-nested-association-quote-visibility-stored-per-parent.md) — "Also brings along" rows carry the same settings, per parent, hidden by default — configurable (Joe 2026-10-07, `verified`); conflict with the 10-01 Operator Load note closed
- [2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md](../decisions/2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md) — Operator Load is one billing code; its tractor/operator hidden on the quote **by default**, configurable (Joe, 2026-10-01 + 2026-10-07, `verified`); tractor/operator keep codes for one-offs; Certified Operator is its own code
- [2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md](../decisions/2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md) — Sub-category tab renamed Field Assets Configuration, with its own activity log (ehtesham.anwar, CodingCops, `reference`)
- [2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md](../decisions/2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md) — A change to a sub-category's Field Assets Configuration reaches only quotes not yet gone out: a quote keeps a snapshot from its first send (or Mark as Won, or conversion), never refreshed; jobs read their quote's; names stay live (Syed Haris, ticket owner, `reference`)

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

12 meeting files carry `module/assets` — list them:

```
grep -rl 'module/assets' vault/meetings/
```
