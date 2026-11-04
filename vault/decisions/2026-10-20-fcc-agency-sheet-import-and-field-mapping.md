---
title: "FCC agency sheet (Ben's 500-row list) imported into the seeder, with its field mapping"
source: decision/developer direction in a Claude Code session, 2026-10-20 (committer devmohsinakram); client sheet pasted by the developer in-session
decided: 2026-10-20
decided_by: >-
  Developer direction in a Claude Code session on 2026-10-20 (git committer devmohsinakram). The
  developer supplied the client agency sheet and directed that it be seeded with dummy/derived
  values for the fields the sheet does not carry ("add them in agencies", "add dummy data for
  empty fields"). The field-derivation rules below were AI-proposed and accepted by that
  direction; they are mechanical data mapping, not product intent, so recorded status: reference.
status: reference
conflicts_with: []
resolves:
  - "vendors-agencies/gaps.md — Agency import of Ben's 500-row sheet (seed/CSV import question)"
  - "vendors-agencies/gaps.md — jurisdiction values on Ben's sheet the dropdown cannot hold"
  - "vendors-agencies/gaps.md — the sheet's Estimated TCG Planning Lead Time has no field"
related_tickets: []
jira: []
tags: [module/vendors-agencies, module/projects-jobs, kind/decision, agencies, data-migration, seed, permits]
---

# FCC agency sheet imported into the seeder

## Decision

Ben's client agency sheet — **500 CA/NV cities and communities** (columns: City/Community, Permit
Lead Time, County/Area, State, Jurisdiction Type, Notes, Coverage Note, Estimated TCG Planning
Lead Time) — is seeded into the FCC tenant via the FCC seeder. It lives at
`apps/api/fcc-seeder/seed-files/agencies.json` (500 records) and is POSTed to `/agencies` by
`seed-all.ts`. FCC has no agency master table, so this sheet is the source of truth for agencies.

The sheet carries only 6 of the fields `POST /agencies` requires. The developer directed that the
rest be filled with dummy/derived values rather than left for manual entry. The mapping applied:

| Agency field | Source / rule |
| --- | --- |
| `agencyName` | City/Community name. The 3 names that appear in both CA and NV (Paradise, Spring Valley, Winchester) are disambiguated as `"<name> (CA)"` / `"<name> (NV)"` because agency names are unique per tenant. All 500 names are unique. |
| `agencyType` | Derived from Jurisdiction Type: City & Town & "Community / Jurupa Valley Area" → `CITY_MUNICIPALITY`; "Unincorporated / CDP" & "Unincorporated Community" → `COUNTY` (the county is the permit authority for unincorporated areas). Result: 245 CITY_MUNICIPALITY, 255 COUNTY. |
| `jurisdictionType` | City → `CITY`; Town → `TOWN` (3); "Unincorporated / CDP" & "Unincorporated Community" → `UNINCORPORATED_CDP` (255); "Community / Jurupa Valley Area" → `CITY` (annexed into City of Jurupa Valley). |
| `permitLeadTimeDays` | The sheet's **Permit Lead Time** column when numeric (Chalfant 10, Garnet 10, Laguna Beach 0, Fullerton 10), otherwise the **Estimated TCG Planning Lead Time** (the always-present last column). Clamped to [0, 365]. |
| `country` / `state` | `"United States"`; `CA`→`"California"`, `NV`→`"Nevada"`. |
| `countyArea` / `city` / `coverageArea` | County/Area; City/Community name; City/Community name (coverageArea = the locality covered). |
| `coverageNote` | The sheet's Coverage Note (the "Local 12 District 6 / Las Vegas area" / "Southern Nevada / verify Local 12 dispatch coverage" lines) or `""`. |
| `timeRestrictions` | `[]`. Optional fields (website, TCP, no-parking, hours, submission, cost, attachments) are not set. |

## Why these choices, and what to revisit

These are **mechanical migration defaults**, not ratified product rules:

- **Unincorporated → COUNTY `agencyType`.** The sheet's unincorporated/CDP rows are not their own
  permit authority; the county is. Each row is still kept as a distinct agency (named for the
  community) so its lead time and coverage note survive, rather than collapsing ~255 rows into a
  handful of county agencies.
- **`permitLeadTimeDays` borrows the planning estimate** where the agency's own permit lead time
  is blank (most rows). The vault flagged these as two different numbers (the planning estimate is
  "not an official agency commitment"); using it as the lead time is a seed default, not a claim
  that the two are the same. If a real agency permit lead time is obtained, it replaces the row's
  value.
- **`coverageArea`** is set to the locality name as a placeholder; the sheet has no true coverage
  area. Revisit if the agency form grows a distinct meaning for it.

## Where it lives

- Data: `apps/api/fcc-seeder/seed-files/agencies.json` (500 records).
- Seeding: `apps/api/fcc-seeder/src/seed-all.ts` → `apiCreateMany('agencies', …)` → `POST /agencies`.
- Enum values: `packages/shared/src/constants/agencies.ts` (`AGENCY_*_VALUES`).
