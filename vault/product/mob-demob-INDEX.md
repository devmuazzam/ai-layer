---
title: Mobilization & Demobilization — conflict stub
source: generated/conflict-stub
migrated: 2026-08-11
updated: 2026-08-11
status: unverified
kind: conflict-stub
gap: gaps.md#mobilization-and-demobilization
conflicts_with: [product/mobilization-and-demobilization.md]
detected_by: drift check against Confluence, 2026-08-11 — not the 2026-08-10 migration
jira: []
topics: [mobilization, quotations, assets, jobs, time-tracking, job-sites]
entities: [mob-demob, quotation, asset, job, field-ticket, build-up, fcc]
---

# Mobilization & Demobilization — two live pages, one migrated

**Neither of these is verified, and only one of them is in the vault.**

This conflict was not found by the migration. It appeared afterwards: a second Confluence
page on the same topic, by the same author, created after the snapshot was taken.

| Candidate | Size | Updated | In vault? | What it uniquely covers |
| --- | --- | --- | --- | --- |
| [mobilization-and-demobilization.md](mobilization-and-demobilization.md) | 5.4 KB | 2026-08-10 | **Yes** — migrated | Executive summary; pain point; current state in FCC; prose requirements for the new ERP under a Quotation/Estimating heading. **The only source covering the field ticketing / mobile app relationship to the quotation.** |
| `confluence/TCG/Mob & demob` (page id 143458306) | — | 2026-08-11 | **No** — not migrated | Numbered client functional requirements **FR-01 to FR-12**; a worked 265-ton crane example with component tables; a step-by-step account of how a salesperson uses the current FCC process ("Hourly with Mob" quote type, per-item checkboxes, live total recalculation). Has **no** field-ticketing section. |

## Read this before treating either as settled

**Do not cite `FR-01` … `FR-12` as vault requirement ids.** They exist on the un-migrated
page only. Nothing in the vault defines them, and a ticket citing them cannot be traced to
a vault source.

The two pages are not obviously versions of one another. The newer one is restructured as a
numbered FR set and drops the field-ticketing content the older one carries, so treating the
newer as a replacement would silently lose the only account of how mobilization relates to
field tickets. Same author, one day apart, different shapes — that pattern usually means two
deliverables rather than two drafts, which is the same trap as the two field-ops FRDs.

The newer page skips section 7 — its numbering runs 6 → 8 — so it may still be in progress.
**It has deliberately not been migrated for that reason.** Re-migration waits until it is
stable upstream; see [`README.md`](../README.md) → *How the vault stays in step with
Confluence*.

See the full entry in [`gaps.md`](../gaps.md) → *Mobilization and demobilization*.
