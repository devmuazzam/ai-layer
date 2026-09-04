---
title: Crane fleet reference — models, tonnage classes, loads and de-rating
source: shared-folder/Project-Repository-2026-09-04 — 3.4.1_MODULE-FLEET-MAINTENANCE/CRANE LOAD CHARTS/from Ryan (2026-06-30)/ (load charts, TCG spec sheets, Equipment Rating-De Rating, LoadTrailerInventory, Wind Sail Calculations Master), 3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/New Updated Crane Chart Sheet.xlsx, 2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/FCC_UNITS-ASSETS_20260706.xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/quotations, module/dispatch, kind/reference, reference-data, lift-plans, pricing, provenance, safety]
entities: []
---

# Crane fleet reference

**What this is.** The one page that answers *"which cranes does TCG actually have, what are they
called, and what does the ERP need to know about them"* — assembled from three unrelated parts of
the 2026-09-04 drop: the **FCC unit table** (what the legacy system holds), Ryan Adams' **crane
selection workbook** (what the sales side holds), and the **load-chart / spec-sheet library** that
came with both. It exists because the same crane is named four different ways across those
sources, and nothing else in the vault reconciles them.

> **The load charts themselves are engineering reference and are not migrated.** §6 says why, and
> lists every file with its text-layer status. No capacity table is transcribed here — see
> [crane-selection-and-load-chart-model.md](crane-selection-and-load-chart-model.md) for the one
> artefact that *does* hold capacity values, and for how much it says you may trust them.

---

## 1. The fleet, as FCC records it

Source: `FCC_UNITS-ASSETS_20260706.xlsx` → `UNITS` sheet (358 units, exported 2026-07-02). Of
those, **51 carry a crane-family schedule type** — Mobile Crane, Rough Terrain Crane, Crawler
Crane, Tower Crane, Self Loader. The other 307 are trailers, tractors, trucks, radios, material
baskets and Misc rows; see
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md).

Every unit in the export is `CompanyCode = CG` (one row is `RG`, The Repair Guys) and
`YardCode = MY` (Main Yard) — **there is exactly one yard in the data**, which matters for any
yard-scoped feature built against migrated data.

**Unit code → model → tonnage class**, active units only. `Class` is the FCC *unit type*
(resource type), `Model` is `VehicleMake` + `VehicleModel` as typed in FCC:

| Unit code | Model year | Make / model | FCC unit type (class) | Schedule type |
| --- | ---: | --- | --- | --- |
| `2204` | 2015 | KW T800 | 22 Ton Boom Truck | Mobile Crane |
| `SL01` | 2019 | Manitex / Kenworth TM3051 / T880 | 30 Ton Self Loader | Self Loader |
| `SL02` | 2022 | Peterbilt / Manitex 567 / 3051T | 30 Ton Self Loader | Self Loader |
| `SL03` | 2022 | Peterbilt / Manitex 567 / 3051 | 30 Ton Self Loader | Self Loader |
| `SL04` | 2017 | Kenworth *(model blank)* | 30 Ton Self Loader | Self Loader |
| `4001` | 2013 | KW T800 | 40 Ton | Mobile Crane |
| `4002` | 2014 | KW T800 | 40 Ton | Mobile Crane |
| `4003` | 2014 | KW / Manitex T880 / 40124SHL | 40 Ton | Mobile Crane |
| `4004` | 2015 | KW T880 / 4004S | 40 Ton | Mobile Crane |
| `4005` | 2020 | Liebherr LMT 1040 2.1 *(sic)* | 40 Ton *(also 45 Ton AT — §3)* | Mobile Crane |
| `4006` | 2025 | Liebherr LTM 1040 2.1 | 40 Ton | Mobile Crane |
| `6002` | 2004 | LINK HTT8660 | 60 Ton Hydraulic Truck Crane | Mobile Crane |
| `9001` | 2008 | LINK HTC8690 | 90 Ton Hydraulic Truck Crane | Mobile Crane |
| `9002` | 2007 | LINK HTC8690 | 90 Ton Hydraulic Truck Crane | Mobile Crane |
| `RT9001` | 2015 | Link-Belt RTC8090-ll | RT Crane | Rough Terrain Crane |
| `RE-RENT RT9001` | — | Link-Belt | 90 Ton RT | Rough Terrain Crane |
| `RE-RENT RT8065` | — | *(blank)* | RT Crane | Rough Terrain Crane |
| `10001` | 2013 | Link-Belt HTC-86100 | 100 Ton Hydraulic Truck Crane | Mobile Crane |
| `10002` | 2014 | Link-Belt HTC86100 | 100 Ton Hydraulic Truck Crane | Mobile Crane |
| `10003` | 2015 | Link-Belt HTT-86100 | 100 Ton Hydraulic Truck Crane | Mobile Crane |
| `10004` | 2013 | Link-Belt HTC-86100 | 100 Ton Hydraulic Truck Crane | Mobile Crane |
| `11001` | 2024 | Liebherr LTM1100-5.3 | 110 Ton All Terrain Crane | Mobile Crane |
| `11002` | 2025 | Liebherr LTM 1100-5.5 | 110 Ton All Terrain Crane | Mobile Crane |
| `14001` | 2015 | LINK HTC3140 *(LB)* | 140 Ton Hydralic Truck Crane *(sic)* | Mobile Crane |
| `14002` | 2011 | LINK HTC3140 *(SB)* | 140 Ton Hydralic Truck Crane | Mobile Crane |
| `19001` | 2025 | Liebherr LTM 1160-5.2 | 190 Ton All Terrain Crane | Mobile Crane |
| `20001` | 2006 | LBELT ATC3200 | **140 Ton Hydralic Truck Crane** | Mobile Crane |
| `26502` | 2015 | Liebherr LTM1220-5.2 | 265 Ton All Terrain Crane | Mobile Crane |
| `26503` | 2018 | Liebherr LTM1220-5.2 | 265 Ton All Terrain Crane | Mobile Crane |
| `27501` | 2022 | Liebherr LTM1230-5.1 | 275 Ton All Terrain Crane | Mobile Crane |
| `CC330.01` | 2016 | Liebherr LR1300 SX | 330 Ton Crawler Crane | Crawler Crane |
| `35001` | 2024 | Grove GMK6300l-1 | 350 Ton All Terrain Crane | Mobile Crane |
| `36001` | 2015 | Liebherr LTM 1300-6.2 | 360 Ton All Terrain Crane | Mobile Crane |
| `55001` | 2025 | Grove **GMK 7450** | 550 Ton Crane | Mobile Crane |
| `TWC001` | — | *(blank)* | Tower Crane | Tower Crane |

Inactive rows in the same export, kept because they explain codes that appear elsewhere:
`301`/`302`/`303` (118' Stinger Cranes), `2201`–`2203` (22 Ton Boom Trucks, two marked
"Sold 11-23"), `6001` (60 Ton), `90 TON RT`, `RE-RENT 50001` (500 Ton Liebherr LTM1400-7.1),
`450`, `550`, `275 TON`, `450 TON`, `SL05`, `SE` ("Sub Jobs"), `CR` ("Craw;er Crane" *sic*).

**Four observations the data forces, none of which the source explains:**

1. **`20001` is filed under two different unit types by two different FCC tables.** Its
   `UnitName` and `Capacity` both say 200 and its model is the Link-Belt ATC-3200, but
   `FMS_UNITS.UnitTypeID` resolves to *140 Ton Hydralic Truck Crane* — while its **primary** row
   in `FMS_UNIT_TYPE_DETAILS` says *200 Ton All Terrain Crane*. The two tables disagree, and the
   export does not say which FCC screens read which. See
   [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §5.
2. **`36001` has `Capacity = 0`** while every sibling carries its tonnage.
3. **Placeholder units exist.** `450`, `550`, `275 TON`, `450 TON`, `SE`, `CR`, `TWC001` carry a
   unit type and nothing else — no make, model, year or capacity. Whether these are stubs held
   open for future machines, or scheduling placeholders, is not stated.
4. **`Capacity` and `UnitMeasure` disagree with the measure lookup.** 25 units carry
   `UnitMeasure = "Ton"`, but `FMS_UNIT_MEASURES` in the same workbook lists only
   `C` CFM · `F` Feet · `N` None · `P` Pound. No `Ton` row is present in the extract.

---

## 2. The 16 models the sales side holds

Source: `New Updated Crane Chart Sheet.xlsx` → `Crane Database` sheet. This is Ryan Adams'
estimator workbook, and it is the only place in the drop where a crane model is described in
terms a dispatcher or estimator would use. **It is per *model*, not per unit** — it has no unit
codes and does not know that TCG owns four HTC-86100s.

| Model | Class (tons) | Type | Main boom (ft) | Main max radius (ft) | Min setup width (ft) | Full setup width (ft) | Counterweight |
| --- | ---: | --- | ---: | ---: | ---: | ---: | --- |
| Manitex 22101S | 22 | Boom Truck | 101 | 55 | 7.4 | 19.8 | None/standard |
| Manitex 3051T | 30 | Boom Truck | 102 | 60 | 8 | 20 | None/standard |
| Manitex 40124SHL | 40 | Boom Truck | 124 | 115 | 7.2 | 22 | None/standard |
| Liebherr LTM 1040-2.1 | **45** | All Terrain | 115 | 100 | 7.8 | 19 | Up to 14,330 lb |
| Link-Belt RTC-8090 II | 90 | Rough Terrain | 140 | 130 | 10.7 | 24 | 19,200 std / 28,800 opt |
| Link-Belt HTC-8690 | 90 | Truck Crane | 140 | 130 | 8.2 | 24 | 8,500 / 11,500 / 32,500 / 39,500 lb |
| Link-Belt HTC-86100 | 100 | Truck Crane | 140 | 150 | 8.2 | 21.7 | Up to 39,500 lb |
| Liebherr LTM 1100-5.3 | 110 | All Terrain | 203 | 175 | 8.5 | 24 | Up to 49,600 lb |
| Link-Belt HTC-3140LB | 140 | Truck Crane | 195 | 190 | 8.5 | 24 | Heavy CW package |
| Liebherr LTM 1160-5.2 | 190 | All Terrain | 203 | 190 | 8.5 | 24 | Up to 123,500 lb |
| Link-Belt ATC-3200 | 200 | All Terrain | 197 | 190 | 10 | 28 | Heavy CW options |
| Liebherr LTM 1220-5.2 | 265 | All Terrain | 197 | 185 | 8.5 | 26.5 | Up to 97,000 lb |
| Liebherr LTM 1230-5.1 | 275 | All Terrain | 243 | 220 | 8.5 | 27 | Heavy CW / VarioBallast |
| Grove GMK6300L-1 | 350 | All Terrain | 263 | 240 | 10.5 | 27.75 | Up to 203,900 lb |
| Liebherr LTM 1300-6.2 | 360 | All Terrain | 256 | 240 | 8.5 | 27.9 | Up to 211,600 lb |
| Grove GMK7550 | 550 | All Terrain | 197 | 180 | 10.2 | 29.2 | Up to 264,500 lb / MegaWingLift |

Each row also carries `Main Hook Height`, `Overall Hook Height`, `Overall Max Radius` and a free
text `Support / Truck Notes` column — that last one is where the workbook records things like
*"Counterweight trucks required; route/mat review"*, which is the same fact the FCC resource-type
configuration records structurally (§5).

**`Type` here is a fourth vocabulary.** Boom Truck / All Terrain / Rough Terrain / Truck Crane is
neither the FCC schedule type nor the FCC unit type nor the load-chart filename convention.

---

## 3. The same crane, four names

Nothing in the drop reconciles these, and the ERP will have to. Examples, all verifiable in the
sources cited above:

| Machine | Load-chart / spec-sheet filename | FCC unit type | Sales workbook | FCC unit code |
| --- | --- | --- | --- | --- |
| Liebherr LTM 1040-2.1 | `045 ton` / *TCG Spec Sheet - 45 ton* | **40 Ton** | **45** tons | `4005`, `4006` |
| Link-Belt ATC-3200 | `200 ton` | **140 Ton Hydralic Truck Crane** | 200 | `20001` |
| Grove GMK7550 | `550 ton` / *TCG Spec Sheet - 550 ton - Grove GMK7550* | 550 Ton Crane | 550 | `55001`, whose `VehicleModel` reads **GMK 7450** |
| Link-Belt HTC-3140 | `140 ton - HTC-3140 LB` and `… SB` — two charts | one unit type for both | one row, `HTC-3140LB` | `14001` (LB), `14002` (SB) |
| Link-Belt HTC-8675 | `HTC-8675-Technical-Data.pdf` | **no unit type, no unit** | **not in the workbook** | — |

The 45-vs-40 ton case is the one with a business consequence attached: *Equipment
Rating-De Rating* (§7) charges the same Liebherr as a 40-ton or a 45-ton **depending on how much
counterweight it carries**. So the two numbers are not a mistake — they are two products from one
machine. The FCC unit type records the lower one **as primary and the higher one as a secondary
type**: unit `4005` carries `40 Ton` (primary) plus `45 Ton All Terrain Crane`, `60 Ton Hydraulic
Truck Crane` and `22 Ton Boom Truck` in `FMS_UNIT_TYPE_DETAILS`. The de-rating rule is already in
the data — see [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §5.

`HTC-8675` appears only as a manufacturer technical-data PDF. No unit, unit type or workbook row
references it. Whether TCG once ran one, is looking at one, or filed it by accident is unstated.

---

## 4. Trailers: every crane's operator load and support loads

Source: `LoadTrailerInventory.pdf` — **41 "Trailer Survey Sheet" pages**, one per trailer.
The trailer IDs are the crane unit code plus a suffix, which makes this the physical counterpart
of the FCC *Operator Load* / *Support Load 1…10* resource types (§5 and
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md)):

```
36001 OL · 36001 .1 · .2 · .3 · .4          (360 Ton — 5 trailers)
35001 OL · 35001 .01 · .2 · .3              (350 Ton — 4)
27501 OL · 27501 .1 · .2 · .3               (275 Ton — 4)
26503 OL · 26503 .1 · .2 · .3               (265 Ton — 4)
26502 OL · 26502 .1 · . 2 · .3              (265 Ton — 4)
20001 OL · 20001 .1                         (200 Ton — 2)
19001 OL · 19001 .1                         (190 Ton — 2)
14001 OL · 14002 OL · 11001 OL · 11002 OL   (one each)
10001 OL · 10002 OL · 10003 OL · 10004 OL
 9001 OL ·  9002 OL
Q58499 · Q58206 · Q58500 · Q56590 · Q58498 · Q58487   (six with no crane prefix)
```

**`OL` is the operator load; the numbered suffixes are the support loads.** The bigger the crane,
the more trailers — which is exactly the shape of the FCC resource-requirement rows, where a 550
Ton configuration drags 12 tractors and 11 numbered support loads.

Each survey sheet records: trailer ID, plate, VIN, deck class (High Deck / Low Deck / Chassis),
deck length, wheel base, tire size, block and ball (weight, load capacity, serial, sheaves, line
size), ladders, **up to four counterweights with individual weights**, wood blocks and mats. Worked
example, `36001 OL`: 53' 8" low deck, 10' 4" wheel base, 255/70/22.5 tires, one 8 ft ladder,
counterweight 1 at 22,000 lb and counterweight 2 at 13,500 lb, 50 wood blocks 48"×6"×8",
4 DICA FiberMax mats 8'×5'×10", plate marked `(RENTAL)`.

**Per-sheet data is not transcribed here** — 41 sheets of plate/VIN/weight detail is asset-register
data, not specification. What matters for the ERP is the shape: a trailer is a unit, it belongs to
a crane by code, and it carries a counted, weighed inventory of counterweights, blocks and mats.
The six `Q…` trailers carry no crane prefix and the document does not say what they belong to.

---

## 5. Where the FCC configuration says the same thing

The load-out that §4 photographs is also *configuration* in FCC, and that side is written up in
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §5 and in
[quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md):
each resource type (crane class) carries required *Unit/People* rows naming a Tractor - Semi, an
Operator Load and Support Load 1…10. A crane in FCC is never one row.

---

## 6. The load-chart and spec-sheet library — engineering reference, not migrated

**39 PDFs, delivered twice** (see the dedupe note below). They are manufacturer capacity charts,
manufacturer technical data, and TCG-branded spec sheets built from them. They contain capacity
tables, winch line-pull tables, outline dimensions and boom-angle geometry. **None of it is
product specification and none of it is transcribed into the vault.** What the ERP needs from
this library is that it exists and must be *attached to the asset record* — which is precisely
what the client asked for: [erp-review-log.md](../erp-review-log.md) §#7 item 15, *"Attachments
for manuals and load charts."*

| File | What it is | Text layer |
| --- | --- | --- |
| `022 ton - Manitex 22101S Load Chart (1).pdf` | manufacturer load chart | **NO TEXT LAYER — scanned image, needs OCR** |
| `022 ton - Manitex 22101S Specs (1).pdf` | manufacturer outline dimensions | yes |
| `022 ton - Manitowoc 22101S Load Chart (1).pdf` | load chart, filed under Manitowoc for a Manitex machine | yes |
| `030 Ton Self Loader - Manitex-3051T (1).pdf` | load chart | **NO TEXT LAYER — scanned image, needs OCR** |
| `040 Ton - Manitex 40124SHL Load Charts (1).pdf` | load chart | **NO TEXT LAYER — scanned image, needs OCR** |
| `045 ton - 1040 2.1 Load Chart Manual (1).pdf` | Liebherr chart manual | yes |
| `045 ton - Liebherr 1040 2.1 Load Chart (1).pdf` | load chart | yes |
| `090 ton - HTC-8690 Load Chart (1).pdf` | load chart | yes |
| `090 ton RT - RTC-8090 Load Chart (1).pdf` | load chart | yes |
| `100 ton - HTC-86100 Load Chart (1).pdf` | load chart | yes |
| `110 ton - LTM 1100 5.3 Load Chart (1).pdf` | load chart | yes |
| `140 ton - HTC-3140 LB Load Chart (1).pdf` | load chart (long boom) | yes |
| `140 ton - HTC-3140 SB Load Chart (1).pdf` | load chart (short boom) | yes |
| `190 ton - LTM 1160-5.2 Load Chart (1).pdf` | load chart | yes |
| `200 ton - ATC-3200 Load Chart (1).pdf` | load chart | yes |
| `265 ton - LTM 1220-5.2 Load Chart (1).pdf` | load chart | yes |
| `275 Ton - LTM 1230-5.1 Load Chart (1).pdf` | load chart | yes |
| `350 Ton - GMK6300L-1 Load Chart (1).pdf` | load chart | yes |
| `360 Ton - LTM 1300-6.2 Load Chart (1).pdf` | load chart | yes |
| `550 ton - GMK7550 Load Chart (1).pdf` | load chart | yes |
| `HTC-8675-Technical-Data.pdf` | Link-Belt technical data for a machine TCG has no unit for | yes |
| `TCG Spec Sheet - …` × 14 | TCG-branded customer-facing spec sheets: 22, 40, 45, 90-100, 110, 140 LB, 140 SB, 190, 200, 265, 275, 350, 360, 550 ton | yes |

**The 140 SB / 140 LB pair is the one modelling fact worth taking from the library:** two separate
charts and two separate TCG spec sheets exist for what FCC holds as one unit type and two units
(`14001`, `14002`). Short boom and long boom are different products with different capacity, and
the *Equipment Rating-De Rating* sheet prices `14002` differently again when it travels with its
deck weight removed.

**Dedupe.** `3.4.1_MODULE-FLEET-MAINTENANCE/CRANE LOAD CHARTS/from Ryan (2026-06-30)/` and
`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/` both contain this
library. **26 files are byte-identical between the two folders** (verified by MD5). The
fleet-maintenance folder additionally holds ten TCG spec sheets (110, 140 LB, 140 SB, 190, 200,
22, 265, 275, 350, 360 ton); the sales folder additionally holds the 45-ton spec sheet and the
`New Updated Crane Chart Sheet.xlsx`. The one file present in both that is *not* byte-identical is
`Wind Sail Calculations Master(39).xlsx` (101,696 vs 101,689 bytes) — **their extracted text is
identical**, so the difference is in workbook metadata, not content. The fleet-maintenance copy is
treated as canonical throughout this page.

---

## 7. Equipment rating / de-rating — selling a machine as a smaller one

Source: `Equipment Rating-De Rating (1).pdf`, 4 pages, TCG letterhead (The Crane Guys, LLC,
10850 Portal Dr., Los Alamitos CA 90720, CA Lic #967520). Undated.

This is the business rule behind the FCC substitution table
([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §5): a physical crane may be
**quoted and charged as a smaller class**, at a stated counterweight and boom configuration.

| Physical machine | May be sold as | At counterweight | With boom / jib |
| --- | --- | --- | --- |
| Liebherr 40 Ton (LTM 1040-2.1) | **40 Ton** | 7,300 lb (the standard load it always carries when not crossing scales) | — |
| Liebherr 40 Ton (LTM 1040-2.1) | **45 Ton** | 7,300 – 14,330 lb | — |
| 90 / 100 Ton | **75 Ton** | 8,500 lb deck weight – 32,500 lb | 140' main boom and/or 35' jib only |
| 140 Ton | **120 Ton** | 20,000 lb deck weight – 45,000 lb | 162' main boom and/or 55' jib |
| 200 Ton | **175 Ton** | 28,660 lb deck weight – 81,570 lb | 196.9' main boom and/or 43.3' jib |
| 265 Ton | **175 Ton** | 26,500 lb deck weight – 75,000 lb | 197' main boom and/or 72' jib |
| 265 Ton | **200 Ton** | 119,000 lb | 197' main boom and/or 72' jib |

**The rules attached to it, in the document's own words:**

- **The 85% rule.** *"Make it a habit for charging the appropriate size crane when you are within
  85% unless a lower percentage is required (Example: staying within 75%)."* Stated verbatim on
  the 75-, 120-, 175- and 200-ton de-rates.
- **De-rating is the exception, not the default.** *"Do not make it a habit of charging for a
  75 ton… Typically, we charge the 75 ton if a 90 ton is overkill, and we do not have a smaller
  machine that can do the lift, but the next machine down cannot do it."* Same wording for
  120/175/200. *"Use your best judgement and ask your sales Supervisor if needed"* — so this is a
  judgement call with an escalation path, not a computable rule.
- **Capability pulls the price back up.** If the job needs the machine's real abilities — the
  All-Terrain feature, 50% outriggers, an HTT model — *"that is what we quote/charge for."*
- **Counterweight preparation is a billable line.** For the Liebherr 45-ton case: counterweight,
  floats and large block must come off for scales, mountain areas or steep hills; trucking is
  quoted separately (Crane + Trucking); and prep is *"Misc. line item at $500/flat with comment
  'Crane pre and post preparation'"*. If only 3,300 lb of counterweight is required, only the
  floats need the extra truck, and the $500 prep still applies. `4.24` may be used for up to
  10,000 lb on the deck in tight areas *"if the crane configuration allows"* — the document does
  not say what `4.24` is.
- **`14002` (140 SB) travelling boom-over-front** with deck weight removed onto a trailer is
  charged **Crane + Op Load + Trucking**, plus **1 hour of crane time on the front and 1 hour on
  the back end**, including OT/DT where applicable.
- Closing instruction, emphasised in the source: *"Always keep safety in mind and sell a machine
  when needed/required. If we need to use a machine for its abilities and/or capacity, we need to
  charge full machine price for it. We do not want to under sale our machines and/or service."*

**What this document does not say:** whether the ERP is expected to enforce any of it, whether the
counterweight ranges are validation bounds or guidance, who "sales Supervisor" is as a role, or
how the 85% figure relates to the ASME/manufacturer 85% rating that
[crane-selection-and-load-chart-model.md](crane-selection-and-load-chart-model.md) warns must not
be applied twice. Those are different 85%s in different documents and this page does not assume
they are the same rule.

---

## 8. Wind sail calculation

Source: `Wind Sail Calculations Master(39).xlsx`, one sheet, `Wind Sail Calculation`. The workbook
is a blank calculator. **Its 17 formulas were read on 2026-09-04**: total wind area is the sum of
the side areas (`O27 = M27 × N27`, summed in `O31`), then **`O32 = 1.25 × O31`** (the drag
coefficient applied to area); wind load `N11 = area × pressure` (`K10 × M10`); `P11 = N11 / N12`
and **`Q11 = SQRT(P11)`** back-solves the maximum wind speed from the crane's allowable load, and
the STOP / CAUTION / GO bands are **`Q11`, `ROUND(Q11 × 0.8)` and `ROUND(Q11 × 0.7)`** — caution at
80% and go at 70% of the limiting speed. `P18 = L18 × M18²` is wind pressure from speed squared
(the `0.004` factor), and `P22 = P20 / M22` guards a divide-by-zero. What follows is the
structure the formulas sit in.

**Inputs:** crane's rated capacity (lb) · wind speed (MPH) · load height (ft) · max load radius
(ft) · and up to three load **sides**, each as height (ft) × width (ft), summed to a total area.
The sample sheet has side 1 at 5 ft × 6 ft = 30 sq ft.

**Constants named on the sheet:**

| Constant | Value | Label |
| --- | ---: | --- |
| Telescopic Crane Use | **0.03** | select-factor by crane type |
| Lattice Boom Crane Use | **0.02** | select-factor by crane type |
| Wind pressure factor | **0.004** | applied to wind speed |
| Coefficient of Drag | **1.25** | applied to total area |
| — | 0.15 | unlabelled, sits beside the pressure factor |

**Outputs:** `WL` wind load (lbs) · `WP` wind pressure (psf) · `WLM` wind load moment (ft-lbs) ·
`EGL` effective gross load (lbs), annotated *"Add this weight to the gross load calculation"* ·
and three maximum allowable wind speeds, banded **MPH STOP / MPH CAUTION / MPH GO**, annotated
*"This is the maximum allowable wind speed for this configuration"*.

So: a lift-planning or dispatch feature that wants a wind rule needs (a) the crane's boom type —
telescopic or lattice — as an asset attribute, because the factor differs; (b) the load's face
dimensions per side; and (c) a three-band stop/caution/go output rather than a single limit. The
sheet does not say who sets the bands, whether they are per crane or global, or where the 0.15
enters.

---


> **Manitex scans, OCR'd 2026-09-04.** The three Manitex PDFs with no text layer (22101S load
> chart, 3051T self-loader, 40124SHL load chart — the last also present as `3.3.1…/40 Ton Load
> Charts.pdf`, byte-identical) were rendered and run through tesseract. They are **range-diagram
> and capacity-table pages** (*"RANGE DIAGRAM – FULLY EXTENDED OUTRIGGER CONFIGURATION"*); the
> OCR recovers the diagram gridlines as noise and no usable text. The 3051T chart is a
> **Bigge Crane and Rigging** distributor reprint (*"This information is for reference use only.
> Operators manual should be consulted"*). Nothing beyond model identity is recoverable from these
> three without manual reading of the capacity tables, which this vault does not transcribe.

## Source

- `3.4.1_MODULE-FLEET-MAINTENANCE/CRANE LOAD CHARTS/from Ryan (2026-06-30)/` — 37 files: 20
  manufacturer load charts, 1 manufacturer spec sheet, 1 manufacturer technical-data sheet,
  14 TCG spec sheets, `Equipment Rating-De Rating (1).pdf` (4 pp, `pdftotext -layout`),
  `LoadTrailerInventory.pdf` (41 survey sheets), `Wind Sail Calculations Master(39).xlsx` (1 sheet)
- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/` — the same library
  minus ten TCG spec sheets, plus the 45-ton spec sheet and `New Updated Crane Chart Sheet.xlsx`
  (30 sheets); 26 files byte-identical to the fleet-maintenance copies
- `2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/FCC_UNITS-ASSETS_20260706.xlsx` — `UNITS` sheet,
  358 rows × 86 exported columns, ran 2026-07-02; row data not copied beyond the crane-family
  subset tabulated in §1

> **Spec-sheet annotations, read 2026-09-04.** Seventeen of the TCG spec-sheet PDFs carry PDF
> annotations (`Line`, `Polygon`, `Stamp`, `FreeText`) authored by **LeoLopez** — hand-drawn
> outrigger-pad and mat dimensions on the crane drawing (e.g. on the HTC-3140 SB sheet: *"Wood
> Mats"*, *6'*, *4'*, *1'*, and the title *"140-ton Link-Belt HTC-3140 SB Specification Sheet"*
> as a text box). They are drawing mark-ups, not data; recorded here so nobody re-discovers
> them as "hidden content".
