---
title: Field Ops — module index
status: reference
kind: index
updated: 2026-09-04
tags: [module/field-ops, kind/reference, safety, compliance, certifications, ticket-workflow, inspections]
---

# Field Ops

The Atom field-worker mobile app. Backend usecases: `field-tickets, ticket-*, pre-checklist, checklist-assignments`. Organized per [STRUCTURE.md](../STRUCTURE.md).

**Safety and compliance live here too.** The ten-module scheme has no safety module, so TCG's safety
programme is a subfolder of this one — [safety-compliance/](safety-compliance/INDEX.md) — tagged
`safety` · `compliance` · `certifications`.

> **Conflict stub first:** [field-ops-mobile-INDEX.md](field-ops-mobile-INDEX.md) — competing sources, none verified. Do not answer from a single document while it is non-empty.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [field-ops-mobile-INDEX.md](field-ops-mobile-INDEX.md) | **Which field-ops document is authoritative?** (none) | 2.3 |
| [e-ticket-worked-example.md](e-ticket-worked-example.md) | **A completed e-ticket** — four phases, per-unit checklists incl. the operator load, time stamps, lunch slots, signatures | 8.5 |
| [field-ops-frd/INDEX.md](field-ops-frd/INDEX.md) | FR-TCG-FOP-**002** v2.0 DRAFT — 12 sections, 30 requirements | 1.5 |
| [frd-new-format-draft/INDEX.md](frd-new-format-draft/INDEX.md) | FR-TCG-FOP-**001** v1.1 REVIEWED — 9 sections, 40 requirements | 1.1 |
| [atom-mobile-app-user-stories/INDEX.md](atom-mobile-app-user-stories/INDEX.md) | Same app as user stories — **re-migrated 2026-08-13 from Confluence v10: now 22 stories, EPIC 1–17** | 4.0 |
| [e-ticket-worked-example-44944.md](e-ticket-worked-example-44944.md) | **A complete e-ticket set** — customer ticket, checklist *and* Labor & Unit Details: union/craft/craft-modifier, `161-180Ft-Oiler`, WTL to payroll, and **two parallel time records** | 22.2 |
| [fcc-e-ticket-and-atom-guides.md](fcc-e-ticket-and-atom-guides.md) | **How the current e-ticket actually behaves** — FCC's own manuals: three tabs, checklist `Section` phases, ad-hoc checklists, editable times / "as recorded for customer", statuses, offline limits, MFA | 26.8 |
| [field-app-demo-2026-06.md](field-app-demo-2026-06.md) | **What the June 2026 prototype implements** — 15 steps, 30-min rounding with reasons, 3 lunches on a rolling 5-h clock with a mandatory third, boom brackets, per-diem tokens, SOS | 23.4 |
| [field-paper-forms.md](field-paper-forms.md) | **The paper being replaced** — the TCG ticket and its LADWP variant, the T&C rules (30-min increments, 12% surcharge, show-up minima, meal periods), the daily log, crew intake and certification list, sling inspection | 16.1 |
| [safety-compliance/INDEX.md](safety-compliance/INDEX.md) | **Safety and compliance** — the safety platform brief, three JSA forms, the audit and Safety Value programme, incident investigation, and what SCE and Mesa require of TCG | 5.1 |
| [fcc-nexgen-service-guide.md](fcc-nexgen-service-guide.md) | **Where a field deficiency goes** — work orders from deficiencies, unit certifications as activities, unit down-time. Mostly `module/assets`; screenshot section adds the Units, Work Orders and Due-PM screen fields | 21.6 |
| [value-engine-field-safety-storage.md](value-engine-field-safety-storage.md) | **TCG's own flow of a crew day** (2025-08-16) — two tailboards, a COD decision, escalation to accounting, and the paper close-out | 7.9 |

## The 2026-09-04 Project Repository drop

Seven new pages and one new subfolder, all above. Three things it settled or sharpened:

- The **PDF FRD** in the drop is the *same* FR-TCG-FOP-002 already migrated from Confluence — see the
  note in [field-ops-frd/INDEX.md](field-ops-frd/INDEX.md). No second copy was written.
- The **two DEMO HTML files** dated a week apart are **byte-identical**: one build, filed twice.
- **Safety is a first-class ask** and the FRDs barely cover it — see
  [safety-compliance/INDEX.md](safety-compliance/INDEX.md) against
  [erp-review-log.md](../erp-review-log.md) entry #11.

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

16 meeting files carry `module/field-ops` — list them:

```
grep -rl 'module/field-ops' vault/meetings/
```
