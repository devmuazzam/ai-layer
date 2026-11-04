# Spec — TCG-124 Odometer fields separated; crane-name typos fixed in seed data

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-124` — "Assets: crane names and Upper/Lower meter fields are not consistent" |
| Elaborated on | `2026-10-16`, in a working session with devmohsinakram |
| Product source | `.ai/vault/uat/register-2026-09-18.md:281` — UAT 4 #25 (NOT DONE) |
| Code read at | `fixes/TCG-15-OCT` @ `8e0637b79` |
| Built in | `craneguys-platform`: `95d36671d` (a — Odometer field names, +53 / −40), `1324896e0` (b — typos, 27 lines) |

## 1. Requirements

| Req | Requirement | Source |
| --- | --- | --- |
| REQ-01 | The Odometer's reading and unit have their own names in code: `odometerReading` / `odometerUnit` (formerly `lowerMilesKm` / `lowerUnit`) — Prisma model, API DTO and responses, web form and types, FCC seeder, qa-automation. "lower" now names only the Lower Meter (`lowerHoursHpan`, `lowerAsOfDate`) | ticket "Done when"; §12 Q1 |
| REQ-02 | No database change: the fields keep `@map("lower_miles_km")` / `@map("lower_unit")`; `prisma migrate diff` reports an empty migration; existing readings untouched | §12 Q1 |
| REQ-03 | Comments at the schema, DTO, web type, E2E type and seeder record the former names | §12 Q1 |
| REQ-04 | `odoAsOfDate` unchanged | §12 Q1 |
| REQ-05 | "Truk" → "Truck" and "Hydralic" → "Hydraulic" in seed and demo data (`seed-data.ts`, demo `billing.ts`, `demo-scenarios.ts`, `staircase-scenarios.ts`, FCC `assets-units.json` / `sub-categories.json`) — all together, as they are lookup keys | ticket "Done when"; §12 Q2 |

## 2. Verification

- API, web and FCC seeder typecheck clean; ESLint: no errors, no warnings in touched files.
- Asset service specs 18 / 18; seed / demo / staircase / utility specs 115 / 115 (the staircase
  spec cross-checks crane names against the seed).
- `qa-automation` not run (no `node_modules`); grep confirms no old field names remain.
- **API contract changed:** asset request / response fields `lowerMilesKm` / `lowerUnit` are now
  `odometerReading` / `odometerUnit`. The API rejects unknown fields (`forbidNonWhitelisted`), so a
  client still sending the old names gets a 400. Web and qa-automation updated; mobile does not use them.

## 12. Open questions

- **Q1 — How to separate the Odometer without a migration?** The ticket expected a migration.
  Decided 2026-10-16 by devmohsinakram (developer): rename in code only via Prisma `@map`, columns
  keep their legacy names, with comments recording the former names; `odoAsOfDate` left as is.
  **Status:** resolved for build.
- **Q2 — Fix the typos in existing data too?** Decided by devmohsinakram: seed and demo data only.
  Existing databases keep "Truk" / "Hydralic" until edited in the UI; re-running the catalogue seed
  on a tenant seeded earlier creates the corrected sub-category beside the old one
  (`catalogue-seed.service.ts` matches by exact name). **Status:** resolved for build.
- **Q3 — Cranes 4005 / 4006 tonnage.** Seed data says "40 Ton All Terrain Crane", capacity 40; the
  ticket says they are 45 Ton. Must be checked with the yard. **Status:** open.
- **Q4 — Crane / sub-category naming rule** ("Rt 9001" vs "RT", "Hydro" vs "Hydraulic"). Product to
  decide. Until then the asset form stays as is: Sub-Category is already a picker over the admin-made
  list, Description is free text. **Status:** open.
- **Q5 — Which name each screen shows, and FCC cranes showing only the unit code.** Product to decide.
  **Status:** open.
- **Q6 — Remove the old Unit table?** Not done: it has relations to 7 tables and the legacy
  `/asset-management/units` page; better as its own ticket. **Status:** open.

## 13. Deliberately out of scope

- Database column renames and data migrations.
- Screen labels — unchanged; the form already says Odometer / Miles vs Lower Meter / Hours.
