---
title: FCC ↔ Samsara asset reconciliation — the 2026-09-21 comparison, measured
source: Teams message from Brian Petros 2026-09-21; shared-folder Project Repository → 2.1.1_DATA-MIGRATION/{FCC_Samsara_Asset_Comparison_2026-09-21.xlsx, "FCC_Samsara_Asset_Compare - starting data.xlsx", Samsara Asset Vehicle_2026-09-21_0910.csv}
migrated: 2026-09-22
updated: 2026-11-12
status: reference
conflicts_with: []
jira: []
tags: [module/assets, module/dispatch, kind/reference, samsara, gps, vin, fcc, data-migration, master-data, provenance]
entities: [asset, unit, samsara-asset, gateway, vin]
---

# FCC ↔ Samsara asset reconciliation, 2026-09-21

Brian Petros ran an AI comparison of FCC's unit table against a Samsara vehicle export and
shared the workbook to ask **which fields the ERP needs cleaned up first**. Every number in
this file was **re-derived by direct measurement** of the three supplied files on 2026-09-22
(Python/openpyxl over all nine sheets and the CSV), not taken from the workbook's own
`00_Summary`. Where a claim is the workbook's rather than measured, it says so.

**This is a record of two client systems' state, not a spec.** It settles no product
question. The questions it raises live in [gaps.md](gaps.md) → *One Asset ↔ one Samsara asset*
and *Which dispatchable cranes are untracked*.

**Follow-up 2026-11-12:** Brian Petros's own audit, which also proposes Samsara External IDs as
the link, is recorded in [samsara-data-audit-and-edit-access-brian-2026-11-12.md](samsara-data-audit-and-edit-access-brian-2026-11-12.md).

## The two snapshots are 81 days apart

| Side | Extract date | Rows |
| --- | --- | --- |
| FCC `FMS_UNITS` | **2026-07-02** (the sheet's own `ran:` cell) | 358 units — 296 active, 62 inactive |
| Samsara vehicle export | **2026-09-21 09:05** | 79 rows, **78 distinct vehicles** |

Any difference between them can be staleness rather than error. A same-day pair has been
requested and not yet supplied.

## FCC has no VIN column

The extract's 86 columns contain **no VIN field**. VIN is carried inside **`SerialNumber`**,
together with the manufacturer serial, in free text:

- `27501` → `095526/ WLFA54CZ6PEZZ0635` (serial, then VIN)
- `35001` → `W09300663PWG12118 / 63006118` (VIN, then serial — opposite order)
- `4004` → `1NKD2L40X5FJ445919 / 218001` (18 characters — a VIN is 17)

**33 of 358** rows hold two identifiers in that one field; **81** are empty. So "correct the
VINs in FCC" has nowhere to land until the field is split. TCG's ERP already stores them
apart — `Asset.vin` and `Asset.serialNumber` are separate columns
(`apps/api/prisma/schema.prisma` → `model Asset` → *Registration / Identity*).

Consequence for our own pipeline, verified by reading it: `fcc-seeder` reads a column named
`VIN` (`apps/api/fcc-seeder/src/extract-seed-files.ts:218`), which the extract does not
contain, so **`Asset.vin` seeds null for every unit**.

## FCC already carries the Samsara link — half-filled, and not one-to-one

`FMS_UNITS` has the provider/id pairs described in
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §Identity. Measured
population:

| Column | Populated (of 358) | Values |
| --- | --- | --- |
| `LowerGPS` | 46 | **`SA`** only |
| `LowerGPSID` | 49 | 15-digit ids, e.g. `281474982740719` |
| `UpperGPS` | **0** | — |
| `UpperGPSID` | **0** | — |

Two things fall out of that, both load-bearing:

**1. The empty upper pair corroborates the client's written statement** that only lower
engines are tracked and upper hours are keyed by hand
([asset-record-requested-additions.md](asset-record-requested-additions.md) §*Meter (slide 9)*).
It is the first *data-side* confirmation of it.

**2. The 49 ids are only 45 distinct ids.** Four are on two units each, and every collision
has the same shape — one active unit, one inactive:

| Samsara id | FCC units |
| --- | --- |
| `281474982740246` | **10004** (Status=1) + **AT07** (Status=0) |
| `281474982740393` | ST12 (Status=1) + 2202 (Status=0) |
| `281474982740153` | SL03 (Status=1) + AT03 (Status=0) |
| `281474982740155` | SL04 (Status=1) + AT05 (Status=0) |

The consistent shape reads as a gateway moved to a replacement unit with the old record never
cleared — one rule would resolve all four without physically checking anything: *where an id
sits on two units and only one is active, clear it from the inactive one.* **That reading is
inference, not a client statement.**

This also explains the workbook's highest-severity finding. Its `10004 identity collision`
("Samsara says 10004 but the VIN points at inactive AT07") is downstream of FCC itself
claiming that one device for both units.

**It bears directly on the schema.** `Asset.samsaraAssetId` carries
`@@unique([tenantCompanyId, samsaraAssetId])`. FCC's own data contains four cases of two units
sharing one id, and Brian Petros has separately stated that a crane's device may sit on its
support tractor (2026-08-26 sprint review 18:11–18:49). See [gaps.md](gaps.md) →
*One Asset ↔ one Samsara asset*.

Second pipeline consequence: **the seeder never maps `LowerGPSID` → `samsaraAssetId`**, so
every seeded asset arrives with a null Samsara link, and
`apps/api/src/usecase/das/das-map.service.ts` joins the live feed on exactly that field.

## Samsara side — presence is not tracking

Of the 79 rows, **61 reported on the day of the export**. Eight gateways had not reported in
over 250 days:

| Unit | Last connected | Days |
| --- | --- | --- |
| 6001 | 2024-04-15 | 888 |
| UT03 | 2024-09-11 | 740 |
| Re Rent Bragg Flatbed (`GBZ5-3SS-6SN`) | 2024-11-15 | 674 |
| **35001** | 2025-08-06 | 411 |
| **20001** | 2025-10-16 | 339 |
| UT-02 Mazda — Parts Truck | 2025-11-15 | 309 |
| AT16 | 2026-01-05 | 258 |
| **55001** | 2026-01-14 | 249 |

`6001` and `UT03` are two of the four units the workbook flags as *"Samsara-linked but FCC
inactive"* — their gateways died around retirement, which explains the flag. The three bold
rows are 200-ton-plus cranes: **linked, and silent for eight to thirteen months.** Whether
that is a dead gateway, an unpowered machine in the yard, or a unit out of service is
**unestablished** — nobody has been asked.

The **Re Rent Bragg Flatbed** duplicate resolves on the same column: two records, identical
VIN `1FDRF3G64FED17871` and plate `74530W1`, two gateways — one reported the morning of the
export, the other 674 days earlier. The stale one is a leftover of a gateway swap. Both match
FCC `RE-RENT PT2`.

Other measured Samsara gaps: `Tags` empty on **78 of 79**; `License Plate` empty on **48**;
`Current Driver` on **78**; `Make`/`Model`/`Year` empty on 15/17/15. `Installed` is `true` on
all 79. **No vehicle-ID column** in either the CSV or the workbook's `Assets_Samsara` sheet —
which is why the 49 FCC ids above **cannot be verified against Samsara from these files**.

## Dispatchable-crane coverage

Brian supplied a list of **34 "main" cranes that can be dispatched** (Teams, 2026-09-21,
qualified by him as *"very close to 100%"*). Matched by unit code against the export:
**27 present, 7 absent.**

Absent: **6002, RT9001, 27501, CC330.01, RE-RENT RT8065, RE-RENT RT9001, TWC001.**

His working heuristic — *"I think only 40 ton and above get the Samsara tracking"* — **does
not hold in either direction:**

- tracked and **under** 40 ton: `2204` (22 T), `SL01`, `SL02`, `SL03` (30 T)
- **over** 40 ton and absent: `6002` (60 T), `RT9001`, `27501` (275 T), `CC330.01` (330 T)

`6002` is a distinct case: FCC holds a `LowerGPSID` for it, but no Samsara record matches —
and its id (`…645`) is sequential with retired `6001`'s (`…644`), which suggests the FCC ids
were loaded in bulk at some point rather than maintained per unit. Inference.

Two of the seven are re-rents (not owned) and one is a tower crane (does not travel), so the
untracked **owned, travelling** set is **6002, RT9001, 27501, CC330.01** — four, where TCG's
earlier guess to Brian was two (27501 and CC330.01).

## Per-unit adjudications

Where the data points one way. **All still want a physical plate/title check** — none of this
is confirmed by a human.

| Unit | Reading | Evidence |
| --- | --- | --- |
| `4003` | Samsara right, FCC has a typo | FCC `1NKDL40X5EJ420680` fails the VIN check digit; Samsara `1NKZL40X5EJ420680` passes (`D`→`Z`) |
| `4004` | Samsara right | FCC's value is 18 characters (`1NKD2L40X5FJ445919`) |
| `AT21` | Samsara right | FCC `…49X7HJ…` fails the check digit; Samsara `…49X6HJ…` passes |
| `9002` | **FCC right** | Samsara's `9002` carries `9001`'s VIN `1F9N3J89X8L028858`; FCC has `1F9N3J7917L028490` |
| `55001` / `27501` | `WLFA54CZ6PEZZ0635` is **27501's**; 55001's is Samsara's `W09450798SWG12025` | FCC has one VIN and one plate (`9HPR477`) on both units. `WLFA5x` matches the Liebherr AT series of 11001/19001/26502/36001; and 55001's own FCC serial `74509025` appears inside the Samsara VIN. **Which unit owns plate `9HPR477` is unresolved** |
| `9001`, `10002` | Samsara's descriptive fields are wrong, VIN agrees | Samsara calls 9001 a *2011 Chevrolet Silverado* and 10002 a *2023 Nissan Altima*; FCC has Link-Belt cranes |

Also measured, and not previously recorded: FCC holds **double-entered masters** — `FBT 1.12`
vs `FBT-1.12` and `FBT 4.24` vs `FBT-4.24` (same plate, same VIN, punctuation apart, one of
each inactive), a unit literally named **`PT02 - DUPLICAT`** sharing `ST14`'s VIN, and
`20001`/`20001BD` sharing plate `6WGT415` — the last probably a crane and its boom dolly, i.e.
intentional. Three further FCC VINs fail the check digit on non-crane units: `11001 OL`,
`26502BD`, `Q58218`.

## Field priority put to the client

Sent to Brian Petros 2026-09-22, as TCG's answer to *"what would you like us to focus on?"* —
**our recommendation, not an agreed decision**: Samsara vehicle id first, then VIN, then
`Name` (set to exactly the unit code, nothing appended, so unit code remains a fallback match
key), then licence plate. Make/Model/Year deprioritised — 14 of the year mismatches are off by
a single year, and the ERP displays FCC's values.

## What this does not establish

- **No physical verification** of any adjudication above.
- **Support-vehicle pairing** — which vehicle travels with each untracked crane, whether it is
  fixed per crane or per job, and whether one truck can serve several cranes. Asked twice,
  unanswered both times. One Samsara record is named `ST09 (AT for SL03)`, so the pairings are
  known informally and recorded nowhere structured.
- **Whether the 49 `LowerGPSID` values are current Samsara vehicle ids.** Needs an export with
  the ID column, or the API.
- **FCC live data.** Read-only credentials for `209.221.9.136:1433` were issued 2026-09-21
  (catalog named `FCCNexgenFMSTest`, a different name from the `NexGenFMS-Test` the seeder and
  staging secrets use — unresolved). TCP connect from the whitelisted IP times out with no
  response; outbound 1433 verified open on our side against an unrelated host. So every number
  here comes from the supplied files, and the column inventory above is the July extract's, not
  necessarily the live table's.
