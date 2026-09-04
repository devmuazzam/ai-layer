---
title: FCC activity code master list — maintenance activity codes and equipment groups
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Activity Code Master List.xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, module/assets, kind/reference, reference-data, inspections, certifications]
entities: []
---

# FCC activity code master list — maintenance activity codes and equipment groups

**What this is.** The code list that drives Work Order **Activities** in FCC NexGen: a four-band
numeric scheme covering critical documentation, preventative maintenance and general repairs, plus
a six-group equipment classification saying which activities apply to which kind of machine. It
came to TCG from FCC in a OneDrive folder dated 2025-10-29; the workbook itself is undated and
unattributed.

**Why it matters.** The FCC health check found that "Activities are not always added to Work
Orders, and when they are, labour and parts are not reliably allocated to the correct activity"
([fcc-nexgen-health-check-2025-12-16.md](fcc-nexgen-health-check-2025-12-16.md)), and recommended
enabling **"Require Activity on WO"**. This is the list that requirement operates on — and the
list a replacement maintenance module would need an equivalent of.

> **Reference data, not a specification.** No source says these codes must be carried into the new
> platform, or that TCG uses all of them. The `2011 DOT Inspection`, `2015 Monthly Wire Rope
> Inspection (OSHA)` and `2016 Monthly Crane Inspection (OSHA)` entries are regulatory in origin;
> the rest are FCC's scheme.

---

## The four code bands

| Band | Meaning | Codes present |
| --- | --- | --- |
| **1000s** | Critical documentation | 1000–1003 (4 codes) |
| **2000s** | Preventative maintenance — **crane / aerial** | 2000–2016 (17 codes) |
| **3000s** | Preventative maintenance — **trucks / trailers / misc vehicles** | 3000–3006 populated, 3007–3010 reserved but blank |
| **4000s** | General repairs | 4000–4062 (63 codes) |

### 1000s — critical documentation

`1000` New Equipment / In-Service Inspection · `1001` PIPs / Campaigns / Service Bulletins /
Updates · `1002` Warranty — Parts and/or Labor · `1003` Oil Analysis.

### 2000s — crane and aerial preventative maintenance

Paired hour-based services split **Lower** and **Upper** — `2000/2001` 250 Hour, `2002/2003` 500
Hour, `2004/2005` 1000 Hour, `2006/2007` 2000 Hour, `2008/2009` 4000 Hour — then the compliance
inspections: `2010` Annual Crane Inspection · `2011` DOT Inspection · `2012` Manbasket Annual
Inspection · `2013` Rigging Annual Inspection · `2014` Preventative Maintenance Grease Machine ·
`2015` Monthly Wire Rope Inspection (OSHA) · `2016` Monthly Crane Inspection (OSHA).

> The Lower/Upper split is the crane's carrier versus its superstructure — the same distinction the
> repair codes make with `4010 Carrier / Lowerworks` and `4050 Superstructure / Upperworks`.

### 3000s — truck, trailer and vehicle preventative maintenance

Mileage-based: `3000` 3,000 Mile · `3001` 5,000 Mile · `3002` 8,000 Mile · `3003` 10,000 Mile ·
`3004` 25,000 Mile · `3005` 100,000 Mile · `3006` Trailer — 90 Day Inspection.

### 4000s — general repairs

63 codes, `4000`–`4062`, alphabetical by description from `4000 A2B / LMI Repair/Replace` to
`4062 Wire Rope Cable Repair / Replace`. They divide into three kinds:

- **Component repair/replace** — the bulk of them: air system, alternator, axle, battery/charging,
  block/ball/becket, boom, brakes, cab, carrier/lowerworks, clutch, computer system, coolant,
  crawler/track, differential, drivetrain, electrical, engine, exhaust, fifth wheel, final drive,
  frame/sheet metal, fuel system, glass, hoist, hour meter/mileage gauge, hydraulic, jib/boom
  extension, landing gear, luffing jib, outrigger/jacking, PTO, pendants/boom straps, planetary,
  rigging, rotec/turntable, sheave, starter, steering, superstructure, suspension, swing, swivel,
  tires/wheels/rims, torque converter, trailer deck, transmission, undercarriage, wire rope cable.
- **Crane operations rather than repairs** — `4015` Crane Reconfiguration, `4016` Crane Set Up,
  `4017` Crane Tear Down.
- **Non-repair labour and inspection** — `4011` Clean / Pressure Wash Machine, `4028` General
  Machine Inspection, `4033` Inbound Inspection, `4039` Outbound Inspection, `4038` NDT
  Inspection, `4042` Painting / Decal Replacement, `4061` Weld Shop Repairs, `4037` Miscellaneous
  Repairs, and — notably for costing — **`4058` Travel Mileage** and **`4059` Travel Time**.

> `4058`/`4059` mean travel is recorded as a maintenance *activity*, not only as a job line item.
> The source does not say how the two relate.

## The equipment groups

Each 4000-series repair code is tagged with the groups it applies to, A–F:

| Group | Equipment |
| --- | --- |
| **A** | Crane, hydraulic boom, RT carrier, single engine, transmission, carrydeck |
| **B** | Crane, hydraulic boom, all-terrain carrier, truck chassis, boom truck, single or dual engine, transmission |
| **C** | Crane, lattice boom, crawler/track system lowerworks, single engine, final drive |
| **D** | Aerial equipment, telehandlers, forklifts, scissor lifts, single engine |
| **E** | Tractors, pick-up trucks, mobile vehicles, single engine, transmission |
| **F** | Trailers, dollys, floats |

The applicability is what makes the list a matrix rather than a flat code table. Examples as coded:
`4018 Crawler / Track System` is **C only**; `4056 Trailer Deck` is **F only**; `4024 Fifth Wheel`
and `4035 Landing Gear` carry **no groups at all**; `4034 Jib / Boom Extension` and `4036 Luffing
Jib` are marked **OPTION** for A, B and C rather than a plain applicability; and the general
codes — `4011`, `4021`, `4026`, `4028`, `4032`, `4037`, `4039`, `4042`, `4058`, `4059`, `4061` —
apply to **all six groups**.

> The **OPTION** marker is used only for jib and luffing-jib work. The workbook does not define it.
> Nor does it explain the codes with no group at all — whether that means "applies to none",
> "applies to all", or simply an unfinished row.

---

## Source

`1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Activity Code Master List.xlsx` —
5.4 KB as converted text. Three sheets, of which **only `Sheet1` has content** (`A2:K105`);
`Sheet2` and `Sheet3` are empty. The sheet is laid out as several side-by-side blocks rather than
one table — 1000s and 2000s in the left columns, 3000s beside the 2000s, the 4000s with a group
matrix in columns C–I, and the group legend in column K — so the reading above is a
reconstruction from cell position. **Every code and description in the sheet is reproduced or
summarised here; no rows were omitted.** Several typographical errors in the source are preserved
in spirit but not repeated here (`Repalce`, `Ventalation`, `Micellaneous`, `Dollys`).
