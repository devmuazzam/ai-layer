---
title: FCC checklist templates — every question on every checklist FCC ran, by phase
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z → TCG_RawFMS_20260623.bak, restored 2026-09-04 and read from stg.FMS_CHECK_LIST_Raw, stg.FMS_CHECK_LIST_DETAILS_Raw, stg.FMS_UNIT_CHECK_LIST_Raw
migrated: 2026-09-04
updated: 2026-09-04
status: reference
conflicts_with: []
jira: []
tags: [module/field-ops, module/assets, kind/reference, inspections, safety, wtl, signatures, reference-data]
part_of: payroll/tcg-rawfms-staging-database/INDEX.md
---

> Read from the 2026-06-23 nightly copy of FCC NexGen. This is what FCC's checklists **asked**,
> item by item — the content behind the ticket example in
> [../../../field-ops/e-ticket-worked-example.md](../../../field-ops/e-ticket-worked-example.md)
> and the paper forms in
> [../../../field-ops/field-paper-forms.md](../../../field-ops/field-paper-forms.md). It is a
> record of the legacy system, not a specification for the ERP.

# FCC checklist templates

## How FCC stores a checklist

Three tables. `FMS_UNIT_CHECK_LIST` (14 rows) is the short list of checklist *kinds* a unit can
carry. `FMS_CHECK_LIST` (630 rows) is one row per checklist **per unit** — the same *Crane
Pre-Trip Inspection* exists 82 times, once for each crane it was assigned to, plus a handful
of template rows with no `UnitCode`. `FMS_CHECK_LIST_DETAILS` (7,728 rows, 589 distinct lists)
holds the questions, again copied per unit. Every question is `Type = C` (check item); the
answer grid (*Completed / Deficiency / N/A*) comes from the e-ticket layout tables
([fcc-eticket-layout-tables.md](fcc-eticket-layout-tables.md)), not from here.

Each question carries a **phase code** in `Sections` — the four phases the ticket prints as
headers (the e-ticket example calls the last one *Ad-hoc Checklist*; here it is the yard
return):

| Code | Phase | Questions |
| --- | --- | --- |
| `BLY` | Before Left Yard | 2,690 |
| `AAJ` | After Arrived Job | 1,736 |
| `BLJ` | Before Left Job | 1,197 |
| `AAY` | After Arrived Yard | 2,050 |
| `NA` | no phase | 55 |

The tables below collapse the per-unit copies: one row per distinct
(checklist, phase, line, question). *Copies* is how many unit-level checklists carry that
question; *active* how many of those copies are switched on. Signature-required and
comment-required flags are per question.

## The checklist kinds — `FMS_UNIT_CHECK_LIST`

| UnitCheckListID | CheckList | Status | EligibleToEmail |
|---|---|---|---|
| 1 | Pre-Trip Inspection | 0 | 0 |
| 2 | Post-Trip Inspection | 1 | 0 |
| 3 | Crane Pre-Trip Inspection | 1 | 1 |
| 4 | AT - Tractors Pre-Trip Inspections | 1 | 1 |
| 5 | CWT and Flatbed Trailers Pre- Trip Inspection | 1 | 1 |
| 6 | St-Stakebeds and UT Pre- Trip Inspections | 1 | 1 |
| 7 | Rigging Inspection | 1 | 1 |
| 8 | Build Up/Breakdown Time Stamps | 1 | 1 |
| 9 | Time Stamps | 1 | 1 |
| 10 | Work Through Lunch | 1 | 1 |
| 11 | Crane 30 Check List | 1 | 1 |
| 12 | Tractor 30 Day Check List | 1 | 1 |
| 13 | Trailer 30 Day Check List | 1 | 1 |
| 14 | Small Truck 30 Day Checklist | 1 | 1 |

## The checklists — `FMS_CHECK_LIST`, grouped

| Checklist | Unit-level copies | Template rows (no unit) |
| --- | --- | --- |

| Time Stamps | 184 | 0 |
| Crane Pre-Trip Inspection | 82 | 0 |
| Work Through Lunch | 51 | 0 |
| Rigging Inspection | 50 | 0 |
| Post-Trip Inspection | 48 | 0 |
| Build Up/Breakdown Time Stamps | 44 | 0 |
| AT - Tractors Pre-Trip Inspections | 36 | 0 |
| Crane 30 Check List | 35 | 0 |
| Trailer 30 Day Check List | 31 | 0 |
| Tractor 30 Day Check List | 28 | 0 |
| CWT and Flatbed Trailers Pre- Trip Inspection | 15 | 0 |
| Small Truck 30 Day Checklist | 11 | 0 |
| St-Stakebeds and UT Pre- Trip Inspections | 8 | 0 |
| Job Safety Analysis | 1 | 0 |
| Pre Trip Inspection | 1 | 0 |
| Crane Pre- Trip Inspection | 1 | 0 |
| AT- Tractors Pre- Trip Inspection | 1 | 0 |
| St- Stakebeds and UT Pre-Trip Inspection | 1 | 0 |
| JSA | 1 | 0 |
| JSA  12.18.25 | 1 | 0 |

## The questions, by checklist and phase

### Crane Pre-Trip Inspection — 132 distinct questions

**AAJ · After Arrived Job**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Load Line/ Hook |  |  |  | 33 | 33 |
| 2 | Chains / Binders |  |  |  | 33 | 33 |
| 3 | Straps/ Shackles |  |  |  | 33 | 33 |
| 4 | Sheaves |  |  |  | 33 | 33 |
| 5 | Hydraulic  Hoses |  |  |  | 33 | 33 |
| 6 | Pump Controls |  |  |  | 33 | 33 |
| 7 | Spill and Clean Kits |  |  |  | 33 | 33 |
| 8 | Inspection Stickers |  |  |  | 33 | 33 |
| 9 | PPE |  |  |  | 33 | 33 |
| 10 | Auxiliary Lights |  |  |  | 33 | 33 |
| 11 | Safety Chains and Tape |  |  |  | 33 | 33 |
| 12 | Tag Line |  |  |  | 33 | 33 |
| 13 | Airport Flag |  |  |  | 33 | 33 |
| 14 | Boom / Hoist / Levers |  |  |  | 33 | 33 |
| 15 | Warning Labels |  |  |  | 33 | 33 |
| 16 | Coolant  Level |  |  |  | 33 | 33 |
| 17 | Engine Oil |  |  |  | 33 | 33 |
| 18 | Belts and Pulleys |  |  |  | 33 | 33 |
| 19 | Seat Belts |  |  |  | 33 | 33 |
| 20 | Hydraulic Oil Level |  |  |  | 33 | 33 |
| 21 | Power Steering Fluid |  |  |  | 33 | 33 |
| 22 | Tire and Lugnuts |  |  |  | 33 | 33 |
| 23 | Mud Flats and Rims |  |  |  | 33 | 33 |
| 24 | Windows and Mirrors |  |  |  | 33 | 33 |
| 25 | Lights and Signals |  |  |  | 33 | 33 |
| 26 | Brake Operation |  |  |  | 33 | 33 |
| 27 | Registration and Tags |  |  |  | 33 | 33 |
| 28 | Annual Permits |  |  |  | 33 | 33 |
| 29 | Fuel Cap Secured |  |  |  | 33 | 33 |
| 30 | Additional Comments |  |  |  | 33 | 33 |

**AAY · After Arrived Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Load Line / Hook |  |  |  | 1 | 1 |
| 2 | Chains / Binders |  |  |  | 1 | 1 |
| 3 | Straps / Shackes |  |  |  | 1 | 1 |
| 4 | Sheaves |  |  |  | 1 | 1 |
| 5 | Hydraulic Hoses |  |  |  | 1 | 1 |
| 6 | Pump Controls |  |  |  | 1 | 1 |
| 7 | Sprill and Clean Kits |  |  |  | 1 | 1 |
| 8 | Inspection Stickers |  |  |  | 1 | 1 |
| 9 | PPE |  |  |  | 1 | 1 |
| 10 | Auxiliary Lights |  |  |  | 1 | 1 |
| 11 | Safety Chains and Tape |  |  |  | 1 | 1 |
| 12 | Tag Line |  |  |  | 1 | 1 |
| 13 | Airport Flag |  |  |  | 1 | 1 |
| 14 | Boom / Hoist / Levers |  |  |  | 1 | 1 |
| 15 | Warning Labels |  |  |  | 1 | 1 |
| 16 | Coolant Levels |  |  |  | 1 | 1 |
| 17 | Engine Oil |  |  |  | 1 | 1 |
| 18 | Belts and Pulleys |  |  |  | 1 | 1 |
| 19 | Seat Belts |  |  |  | 1 | 1 |
| 20 | Hydraulic Oil Level |  |  |  | 1 | 1 |
| 21 | Power Steering Fluid |  |  |  | 1 | 1 |
| 22 | Tire and Lugnuts |  |  |  | 1 | 1 |
| 23 | Mud Flaps and Rims |  |  |  | 1 | 1 |
| 24 | Windows and Mirrors |  |  |  | 1 | 1 |
| 25 | Lights and Signals |  |  |  | 1 | 1 |
| 26 | Brake Operation |  |  |  | 1 | 1 |
| 27 | Fuel Cap Secured |  |  |  | 1 | 1 |
| 28 | Additional Comments |  |  |  | 1 | 1 |

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Load Line/ Hook |  |  |  | 15 | 15 |
| 1 | Load Line/ Hook | ✓ |  |  | 3 | 3 |
| 1 | Load Line/ Hook / Sheaves |  |  |  | 1 | 1 |
| 1 | Load Line/ Hook / Sheaves | ✓ |  |  | 29 | 29 |
| 2 | Chains / Binders |  |  |  | 15 | 15 |
| 2 | Chains / Binders | ✓ |  |  | 3 | 3 |
| 3 | Straps/ Shackles |  |  |  | 15 | 15 |
| 3 | Straps/ Shackles | ✓ |  |  | 3 | 3 |
| 3 | Straps/ Shackles / Tag Line / Air Port Flag / Safety Chains / Rope |  |  |  | 1 | 1 |
| 3 | Straps/ Shackles / Tag Line / Air Port Flag / Safety Chains / Rope | ✓ |  |  | 29 | 29 |
| 4 | Sheaves |  |  |  | 15 | 15 |
| 4 | Sheaves | ✓ |  |  | 3 | 3 |
| 5 | Hydraulic  Hoses |  |  |  | 15 | 15 |
| 5 | Hydraulic  Hoses | ✓ |  |  | 3 | 3 |
| 6 | Pump Controls |  |  |  | 15 | 15 |
| 6 | Pump Controls | ✓ |  |  | 3 | 3 |
| 7 | Spill and Clean Kits |  |  |  | 15 | 15 |
| 7 | Spill and Clean Kits | ✓ |  |  | 3 | 3 |
| 7 | Spill and Clean Kits / Cones / Wheel Chalks / Fire Extinguisher |  |  |  | 1 | 1 |
| 7 | Spill and Clean Kits / Cones / Wheel Chalks / Fire Extinguisher | ✓ |  |  | 29 | 29 |
| 8 | Crane Annual and Quad Certification Stickers |  |  |  | 1 | 1 |
| 8 | Crane Annual and Quad Certification Stickers | ✓ |  |  | 19 | 19 |
| 8 | Inspection Stickers |  |  |  | 15 | 15 |
| 8 | Inspection Stickers | ✓ |  |  | 13 | 13 |
| 9 | PPE |  |  |  | 15 | 15 |
| 9 | PPE | ✓ |  |  | 3 | 3 |
| 10 | Auxiliary Lights |  |  |  | 15 | 15 |
| 10 | Auxiliary Lights | ✓ |  |  | 3 | 3 |
| 10 | Head Lights / Running Lighs / Auxiliary Lights |  |  |  | 1 | 1 |
| 10 | Head Lights / Running Lighs / Auxiliary Lights | ✓ |  |  | 29 | 29 |
| 11 | Safety Chains and Tape |  |  |  | 15 | 15 |
| 11 | Safety Chains and Tape | ✓ |  |  | 3 | 3 |
| 12 | Tag Line |  |  |  | 15 | 15 |
| 12 | Tag Line | ✓ |  |  | 3 | 3 |
| 13 | Airport Flag |  |  |  | 15 | 15 |
| 13 | Airport Flag | ✓ |  |  | 3 | 3 |
| 14 | Boom / Hoist / Levers |  |  |  | 15 | 15 |
| 14 | Boom / Hoist / Levers | ✓ |  |  | 3 | 3 |
| 15 | Warning Labels |  |  |  | 16 | 16 |
| 15 | Warning Labels | ✓ |  |  | 32 | 32 |
| 16 | Coolant  Level |  |  |  | 16 | 16 |
| 16 | Coolant  Level | ✓ |  |  | 32 | 32 |
| 17 | Engine Oil |  |  |  | 16 | 16 |
| 17 | Engine Oil | ✓ |  |  | 32 | 32 |
| 18 | Belts and Pulleys |  |  |  | 16 | 16 |
| 18 | Belts and Pulleys | ✓ |  |  | 32 | 32 |
| 19 | Seat Belts |  |  |  | 16 | 16 |
| 19 | Seat Belts | ✓ |  |  | 32 | 32 |
| 20 | Hydraulic Oil Level |  |  |  | 15 | 15 |
| 20 | Hydraulic Oil Level | ✓ |  |  | 3 | 3 |
| 21 | Power Steering Fluid |  |  |  | 15 | 15 |
| 21 | Power Steering Fluid | ✓ |  |  | 3 | 3 |
| 22 | Tire and Lugnuts |  |  |  | 16 | 16 |
| 22 | Tire and Lugnuts | ✓ |  |  | 32 | 32 |
| 23 | Mud Flats |  |  |  | 1 | 1 |
| 23 | Mud Flats | ✓ |  |  | 29 | 29 |
| 23 | Mud Flats and Rims |  |  |  | 15 | 15 |
| 23 | Mud Flats and Rims | ✓ |  |  | 3 | 3 |
| 24 | Windows and Mirrors |  |  |  | 16 | 16 |
| 24 | Windows and Mirrors | ✓ |  |  | 32 | 32 |
| 25 | Lights and Signals |  |  |  | 15 | 15 |
| 25 | Lights and Signals | ✓ |  |  | 3 | 3 |
| 26 | Brake Operation |  |  |  | 16 | 16 |
| 26 | Brake Operation | ✓ |  |  | 32 | 32 |
| 27 | Compliance: Registration / Tags / Annual Permits / Operating Manual / Load Chart |  |  |  | 1 | 1 |
| 27 | Compliance: Registration / Tags / Annual Permits / Operating Manual / Load Chart | ✓ |  |  | 29 | 29 |
| 27 | Registration and Tags |  |  |  | 15 | 15 |
| 27 | Registration and Tags | ✓ |  |  | 3 | 3 |
| 28 | Annual Permits |  |  |  | 16 | 16 |
| 28 | Annual Permits | ✓ |  |  | 32 | 32 |
| 29 | Fuel Cap Secured |  |  |  | 15 | 15 |
| 29 | Fuel Cap Secured | ✓ |  |  | 3 | 3 |
| 30 | Additional Comments |  |  |  | 16 | 16 |
| 30 | Additional Comments | ✓ |  |  | 32 | 32 |

### Time Stamps — 97 distinct questions

**AAJ · After Arrived Job**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Leave Yard |  |  |  | 4 | 4 |
| 1 | Leave Yard | ✓ |  |  | 26 | 26 |
| 2 | Arrive Job |  |  |  | 4 | 4 |
| 2 | Arrive Job | ✓ |  |  | 26 | 26 |
| 3 | Build Up |  |  |  | 4 | 4 |
| 3 | Build Up | ✓ |  |  | 26 | 26 |
| 4 | Work |  |  |  | 4 | 4 |
| 4 | Work | ✓ |  |  | 26 | 26 |
| 5 | Break Down |  |  |  | 4 | 4 |
| 5 | Break Down | ✓ |  |  | 26 | 26 |
| 6 | Leave Job |  |  |  | 4 | 4 |
| 6 | Leave Job | ✓ |  |  | 26 | 26 |
| 7 | Arrive Yard |  |  |  | 4 | 4 |
| 7 | Arrive Yard | ✓ |  |  | 26 | 26 |
| 8 | If Subsistence is applicable please click deficiency and note long or short sub in the comments |  |  |  | 4 | 4 |
| 8 | If Subsistence is applicable please click deficiency and note long or short sub in the comments | ✓ |  |  | 25 | 25 |
| 8 | Lunch Time |  |  |  | 4 | 4 |
| 8 | Lunch Time | ✓ |  |  | 26 | 26 |
| 9 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. |  |  |  | 4 | 4 |
| 9 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. | ✓ |  |  | 25 | 25 |
| 9 | If Subsistence is applicable please click deficiency and note long or short sub in the comments | ✓ |  |  | 1 | 1 |
| 10 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. | ✓ |  |  | 1 | 1 |
| 11 | I certify that the work time that I entered and submitted on my labor tab / timesheet is correct to the best of my knowledge. I further confirm that, in the event that I worked more than five hours in one workday, I have taken one or more thirty minute mea |  |  |  | 4 | 4 |
| 11 | I certify that the work time that I entered and submitted on my labor tab / timesheet is correct to the best of my knowledge. I further confirm that, in the event that I worked more than five hours in one workday, I have taken one or more thirty minute mea | ✓ |  |  | 26 | 26 |

**AAY · After Arrived Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Leave Yard |  |  |  | 12 | 12 |
| 1 | Leave Yard | ✓ |  |  | 52 | 52 |
| 2 | Arrive Job |  |  |  | 12 | 12 |
| 2 | Arrive Job | ✓ |  |  | 52 | 52 |
| 3 | Build Up |  |  |  | 12 | 12 |
| 3 | Build Up | ✓ |  |  | 52 | 52 |
| 4 | Work |  |  |  | 12 | 12 |
| 4 | Work | ✓ |  |  | 52 | 52 |
| 5 | Break Down |  |  |  | 12 | 12 |
| 5 | Break Down | ✓ |  |  | 52 | 52 |
| 6 | Leave Job |  |  |  | 12 | 12 |
| 6 | Leave Job | ✓ |  |  | 52 | 52 |
| 7 | Arrive Yard |  |  |  | 12 | 12 |
| 7 | Arrive Yard | ✓ |  |  | 52 | 52 |
| 8 | If Subsistence is applicable please click deficiency and note long or short sub in the comments |  |  |  | 12 | 12 |
| 8 | If Subsistence is applicable please click deficiency and note long or short sub in the comments | ✓ |  |  | 52 | 52 |
| 9 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. |  |  |  | 12 | 12 |
| 9 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. | ✓ |  |  | 52 | 52 |
| 10 | I certify that the work time that I entered and submitted on my labor tab / timesheet is correct to the best of my knowledge. I further confirm that, in the event that I worked more than five hours in one workday, I have taken one or more thirty minute mea |  |  |  | 11 | 11 |
| 10 | I certify that the work time that I entered and submitted on my labor tab / timesheet is correct to the best of my knowledge. I further confirm that, in the event that I worked more than five hours in one workday, I have taken one or more thirty minute mea | ✓ |  |  | 15 | 15 |

**BLJ · Before Left Job**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Leave Yard |  |  |  | 1 | 1 |
| 1 | Leave Yard | ✓ |  |  | 81 | 81 |
| 2 | Arrive Job |  |  |  | 1 | 1 |
| 2 | Arrive Job | ✓ |  |  | 81 | 81 |
| 3 | Build Up |  |  |  | 1 | 1 |
| 3 | Build Up | ✓ |  |  | 81 | 81 |
| 4 | Work |  |  |  | 1 | 1 |
| 4 | Work | ✓ |  |  | 81 | 81 |
| 5 | Break Down |  |  |  | 1 | 1 |
| 5 | Break Down | ✓ |  |  | 81 | 81 |
| 6 | Leave Job |  |  |  | 1 | 1 |
| 6 | Leave Job | ✓ |  |  | 81 | 81 |
| 7 | Arrive Yard |  |  |  | 1 | 1 |
| 7 | Arrive Yard | ✓ |  |  | 81 | 81 |
| 8 | If Subsistence is applicable please click deficiency and note long or short sub in the comments |  |  |  | 1 | 1 |
| 8 | If Subsistence is applicable please click deficiency and note long or short sub in the comments | ✓ |  |  | 81 | 81 |
| 8 | Lunch Time | ✓ |  |  | 5 | 5 |
| 8 | Lunch Time ( If lunch is taken enter time here, example: Lunch 12 pm to 12:30 pm) |  |  |  | 1 | 1 |
| 8 | Lunch Time ( If lunch is taken enter time here, example: Lunch 12 pm to 12:30 pm) | ✓ |  |  | 76 | 76 |
| 9 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. | ✓ |  |  | 27 | 27 |
| 9 | Lunch Time: 2nd Lunch |  |  |  | 1 | 1 |
| 9 | Lunch Time: 2nd Lunch | ✓ |  |  | 54 | 54 |
| 11 | I certify that the work time that I entered and submitted on my labor tab / timesheet is correct to the best of my knowledge. I further confirm that, in the event that I worked more than five hours in one workday, I have taken one or more thirty minute mea | ✓ |  |  | 27 | 27 |
| 11 | Lunch Time: 3rd Lunch |  |  |  | 1 | 1 |
| 11 | Lunch Time: 3rd Lunch | ✓ |  |  | 54 | 54 |
| 12 | Lunch Time: 4th Lunch |  |  |  | 1 | 1 |
| 12 | Lunch Time: 4th Lunch | ✓ |  |  | 54 | 54 |
| 13 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. |  |  |  | 1 | 1 |
| 13 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. | ✓ |  |  | 54 | 54 |
| 14 | I certify that the work time that I entered and submitted on my labor tab / timesheet is correct to the best of my knowledge. I further confirm that, in the event that I worked more than five hours in one workday, I have taken one or more thirty minute mea |  |  |  | 1 | 1 |
| 14 | I certify that the work time that I entered and submitted on my labor tab / timesheet is correct to the best of my knowledge. I further confirm that, in the event that I worked more than five hours in one workday, I have taken one or more thirty minute mea | ✓ |  |  | 54 | 54 |

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Leave Yard | ✓ |  |  | 1 | 1 |
| 2 | Arrive Job | ✓ |  |  | 1 | 1 |
| 3 | Build Up | ✓ |  |  | 1 | 1 |
| 4 | Work | ✓ |  |  | 1 | 1 |
| 5 | Break Down | ✓ |  |  | 1 | 1 |
| 6 | Leave Job | ✓ |  |  | 1 | 1 |
| 7 | Arrive Yard | ✓ |  |  | 1 | 1 |
| 8 | If Subsistence is applicable please click deficiency and note long or short sub in the comments | ✓ |  |  | 1 | 1 |
| 8 | Lunch Time ( If lunch is taken enter time here, example: Lunch 12 pm to 12:30 pm) | ✓ |  |  | 1 | 1 |
| 9 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. | ✓ |  |  | 1 | 1 |
| 11 | I certify that the work time that I entered and submitted on my labor tab / timesheet is correct to the best of my knowledge. I further confirm that, in the event that I worked more than five hours in one workday, I have taken one or more thirty minute mea | ✓ |  |  | 1 | 1 |

**NA · No section**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Leave Yard | ✓ |  |  | 5 | 5 |
| 2 | Arrive Job | ✓ |  |  | 5 | 5 |
| 3 | Build Up | ✓ |  |  | 5 | 5 |
| 4 | Work | ✓ |  |  | 5 | 5 |
| 5 | Break Down | ✓ |  |  | 5 | 5 |
| 6 | Leave Job | ✓ |  |  | 5 | 5 |
| 7 | Arrive Yard | ✓ |  |  | 5 | 5 |
| 8 | If Subsistence is applicable please click deficiency and note long or short sub in the comments | ✓ |  |  | 5 | 5 |
| 8 | Lunch Time | ✓ |  |  | 5 | 5 |
| 9 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. | ✓ |  |  | 5 | 5 |
| 11 | I certify that the work time that I entered and submitted on my labor tab / timesheet is correct to the best of my knowledge. I further confirm that, in the event that I worked more than five hours in one workday, I have taken one or more thirty minute mea | ✓ |  |  | 5 | 5 |

### Job Safety Analysis — 76 distinct questions

**AAJ · After Arrived Job**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Hazard Identification: Falling Objects | ✓ |  |  | 1 | 1 |
| 2 | Poor Lighting | ✓ |  |  | 1 | 1 |
| 3 | Sliperrey Surfaces | ✓ |  |  | 1 | 1 |
| 4 | Multiple Electrical Feeds | ✓ |  |  | 1 | 1 |
| 5 | Trip Hazards | ✓ |  |  | 1 | 1 |
| 6 | Electrical Hazards | ✓ |  |  | 1 | 1 |
| 7 | Electrical > 4001 Amps | ✓ |  |  | 1 | 1 |
| 8 | Manual Handling | ✓ |  |  | 1 | 1 |
| 9 | Sharp Materials | ✓ |  |  | 1 | 1 |
| 10 | Ladders Used | ✓ |  |  | 1 | 1 |
| 11 | Working at Heights | ✓ |  |  | 1 | 1 |
| 12 | Working Near Cranes | ✓ |  |  | 1 | 1 |
| 13 | Flammable Materials in Area | ✓ |  |  | 1 | 1 |
| 14 | Pressurized Fluids | ✓ |  |  | 1 | 1 |
| 15 | Suspended Loads | ✓ |  |  | 1 | 1 |
| 16 | Poor Visibility | ✓ |  |  | 1 | 1 |
| 17 | Inhalable Dust / Fibers | ✓ |  |  | 1 | 1 |
| 18 | High Noise Area | ✓ |  |  | 1 | 1 |
| 19 | Elevated Work Area | ✓ |  |  | 1 | 1 |
| 20 | Communication Difficulties | ✓ |  |  | 1 | 1 |
| 21 | Moving Machinery | ✓ |  |  | 1 | 1 |
| 22 | Tools and Equipment | ✓ |  |  | 1 | 1 |
| 23 | Shackles, Chains and Slings | ✓ |  |  | 1 | 1 |
| 24 | Radiation | ✓ |  |  | 1 | 1 |
| 25 | Precautions: Gloves | ✓ |  |  | 1 | 1 |
| 26 | Goggles | ✓ |  |  | 1 | 1 |
| 27 | Full Face Shields | ✓ |  |  | 1 | 1 |
| 28 | High Visibility Vest | ✓ |  |  | 1 | 1 |
| 29 | Fall Arrest System | ✓ |  |  | 1 | 1 |
| 30 | Fire Extinguishers | ✓ |  |  | 1 | 1 |
| 31 | Harness | ✓ |  |  | 1 | 1 |
| 32 | Erect Warning Signs | ✓ |  |  | 1 | 1 |
| 33 | Tag Lines | ✓ |  |  | 1 | 1 |
| 34 | Barricades | ✓ |  |  | 1 | 1 |
| 35 | Permits- Job Site Requirements: Street Permits | ✓ |  |  | 1 | 1 |
| 36 | Lane Closures | ✓ |  |  | 1 | 1 |
| 37 | FAA | ✓ |  |  | 1 | 1 |
| 38 | Equipment Grounded | ✓ |  |  | 1 | 1 |

**AAY · After Arrived Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Hazard Identification: Falling Objects |  |  |  | 1 | 1 |
| 2 | Poor Lighting |  |  |  | 1 | 1 |
| 3 | Sliperrery Surfaces |  |  |  | 1 | 1 |
| 4 | Multiple Electrical Feeds |  |  |  | 1 | 1 |
| 5 | Trip Hazards |  |  |  | 1 | 1 |
| 6 | Electrical Hazards |  |  |  | 1 | 1 |
| 7 | Electrical > 4001 Amps |  |  |  | 1 | 1 |
| 8 | Manual Handling |  |  |  | 1 | 1 |
| 9 | Sharp Materials |  |  |  | 1 | 1 |
| 10 | Ladders Used |  |  |  | 1 | 1 |
| 11 | Working at Heights |  |  |  | 1 | 1 |
| 12 | Working Near Cranes |  |  |  | 1 | 1 |
| 13 | Flammable Materials in Area |  |  |  | 1 | 1 |
| 14 | Pressurized Fluids |  |  |  | 1 | 1 |
| 15 | Suspended Loads |  |  |  | 1 | 1 |
| 16 | Poor Visibility |  |  |  | 1 | 1 |
| 17 | Inhalable Dust/Fibers |  |  |  | 1 | 1 |
| 18 | High Noise Areas |  |  |  | 1 | 1 |
| 19 | Elevated Work Area |  |  |  | 1 | 1 |
| 20 | Communication Difficulties |  |  |  | 1 | 1 |
| 21 | Moving Machinery |  |  |  | 1 | 1 |
| 22 | Tools and Equipment |  |  |  | 1 | 1 |
| 23 | Shackles, Chains, Slings |  |  |  | 1 | 1 |
| 24 | Radiation |  |  |  | 1 | 1 |
| 25 | Precautions: Gloves |  |  |  | 1 | 1 |
| 26 | Goggles |  |  |  | 1 | 1 |
| 27 | Full Face Shield |  |  |  | 1 | 1 |
| 28 | High Visibility Vest |  |  |  | 1 | 1 |
| 29 | Fall Arrest Systems |  |  |  | 1 | 1 |
| 30 | Fire Extinquishers |  |  |  | 1 | 1 |
| 31 | Harness |  |  |  | 1 | 1 |
| 32 | Erect Warning Signs |  |  |  | 1 | 1 |
| 33 | Tag Lines |  |  |  | 1 | 1 |
| 34 | Barricades |  |  |  | 1 | 1 |
| 35 | Permits - Jobsite Requirements: Street Permits |  |  |  | 1 | 1 |
| 36 | Lane Closures |  |  |  | 1 | 1 |
| 37 | FAA |  |  |  | 1 | 1 |
| 38 | Equipment Grounded |  |  |  | 1 | 1 |

### Crane Pre- Trip Inspection — 75 distinct questions

**AAY · After Arrived Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 44 | Hazard Identification: Falling Objects |  |  |  | 1 | 1 |
| 45 | Poor Lighting |  |  |  | 1 | 1 |
| 46 | Sliperrery Surfaces |  |  |  | 1 | 1 |
| 47 | Multiple Electrical Feeds |  |  |  | 1 | 1 |
| 48 | Trip Hazards |  |  |  | 1 | 1 |
| 49 | Electrical Hazards |  |  |  | 1 | 1 |
| 50 | Electrical > 4001 Amps |  |  |  | 1 | 1 |
| 51 | Manual Handling |  |  |  | 1 | 1 |
| 52 | Sharp Materials |  |  |  | 1 | 1 |
| 53 | Ladders Used |  |  |  | 1 | 1 |
| 54 | Working at Heights |  |  |  | 1 | 1 |
| 55 | Working Near Cranes |  |  |  | 1 | 1 |
| 56 | Flammable Materials in Area |  |  |  | 1 | 1 |
| 57 | Pressurized Fluids |  |  |  | 1 | 1 |
| 58 | Suspended Loads |  |  |  | 1 | 1 |
| 59 | Poor Visibility |  |  |  | 1 | 1 |
| 60 | Inhalable Dust/Fibers |  |  |  | 1 | 1 |
| 61 | High Noise Areas |  |  |  | 1 | 1 |
| 62 | Elevated Work Area |  |  |  | 1 | 1 |
| 63 | Communication Difficulties |  |  |  | 1 | 1 |
| 64 | Moving Machinery |  |  |  | 1 | 1 |
| 65 | Tools and Equipment |  |  |  | 1 | 1 |
| 66 | Shackles, Chains, Slings |  |  |  | 1 | 1 |
| 67 | Radiation |  |  |  | 1 | 1 |
| 68 | Precautions: Gloves |  |  |  | 1 | 1 |
| 69 | Goggles |  |  |  | 1 | 1 |
| 70 | Full Face Shield |  |  |  | 1 | 1 |
| 71 | High Visibility Vest |  |  |  | 1 | 1 |
| 72 | Fall Arrest Systems |  |  |  | 1 | 1 |
| 73 | Fire Extinquishers |  |  |  | 1 | 1 |
| 74 | Harness |  |  |  | 1 | 1 |
| 75 | Erect Warning Signs |  |  |  | 1 | 1 |
| 76 | Tag Lines |  |  |  | 1 | 1 |
| 77 | Barricades |  |  |  | 1 | 1 |
| 78 | Permits - Jobsite Requirements: Street Permits |  |  |  | 1 | 1 |
| 79 | Lane Closures |  |  |  | 1 | 1 |
| 80 | FAA |  |  |  | 1 | 1 |
| 81 | Equipment Grounded |  |  |  | 1 | 1 |

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 7 | Load Line / Hook | ✓ |  |  | 1 | 1 |
| 8 | Chains / Binders | ✓ |  |  | 1 | 1 |
| 9 | Straps / Shackles | ✓ |  |  | 1 | 1 |
| 10 | Sheaves | ✓ |  |  | 1 | 1 |
| 11 | Hydraulic Hoses | ✓ |  |  | 1 | 1 |
| 12 | Pump Controls | ✓ |  |  | 1 | 1 |
| 13 | Spill and Clean Kits | ✓ |  |  | 1 | 1 |
| 14 | Insepction Stickers | ✓ |  |  | 1 | 1 |
| 15 | PPE | ✓ |  |  | 1 | 1 |
| 16 | Auxiliary Lights | ✓ |  |  | 1 | 1 |
| 17 | Safety Chains and Tape | ✓ |  |  | 1 | 1 |
| 18 | Tag Line | ✓ |  |  | 1 | 1 |
| 19 | Airport Flag | ✓ |  |  | 1 | 1 |
| 20 | Boom / Hoist / Levers | ✓ |  |  | 1 | 1 |
| 21 | Warning Labels | ✓ |  |  | 1 | 1 |
| 22 | Coolant Level | ✓ |  |  | 1 | 1 |
| 23 | Engine oil | ✓ |  |  | 1 | 1 |
| 24 | Belts and Pulleys | ✓ |  |  | 1 | 1 |
| 25 | Seat Belts | ✓ |  |  | 1 | 1 |
| 26 | Hydraulic Oil Level | ✓ |  |  | 1 | 1 |
| 27 | Power Steering Fluid | ✓ |  |  | 1 | 1 |
| 28 | Tires and Lugnuts | ✓ |  |  | 1 | 1 |
| 29 | Mud Flats and Rims | ✓ |  |  | 1 | 1 |
| 30 | Windowns and Mirrors | ✓ |  |  | 1 | 1 |
| 31 | Lights and Signals | ✓ |  |  | 1 | 1 |
| 32 | Brake Operation | ✓ |  |  | 1 | 1 |
| 33 | Registration and Tags | ✓ |  |  | 1 | 1 |
| 34 | Annual Permits | ✓ |  |  | 1 | 1 |
| 35 | Fuel Cap Secured | ✓ |  |  | 1 | 1 |
| 36 | Odometer Start | ✓ |  |  | 1 | 1 |
| 37 | Odometer End | ✓ |  |  | 1 | 1 |
| 38 | Hours Start | ✓ |  |  | 1 | 1 |
| 39 | Hours End | ✓ |  |  | 1 | 1 |
| 40 | Total Hours | ✓ |  |  | 1 | 1 |
| 41 | Fuel Start | ✓ |  |  | 1 | 1 |
| 42 | Fuel End | ✓ |  |  | 1 | 1 |
| 43 | Additional Equip/ Rigging | ✓ |  |  | 1 | 1 |

### Post-Trip Inspection — 56 distinct questions

**AAY · After Arrived Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Load Line / Hook |  |  |  | 47 | 47 |
| 1 | Load Line / Hook | ✓ |  |  | 1 | 1 |
| 2 | Chains / Binders |  |  |  | 47 | 47 |
| 2 | Chains / Binders | ✓ |  |  | 1 | 1 |
| 3 | Straps / Shackes |  |  |  | 47 | 47 |
| 3 | Straps / Shackes | ✓ |  |  | 1 | 1 |
| 4 | Sheaves |  |  |  | 47 | 47 |
| 4 | Sheaves | ✓ |  |  | 1 | 1 |
| 5 | Hydraulic Hoses |  |  |  | 47 | 47 |
| 5 | Hydraulic Hoses | ✓ |  |  | 1 | 1 |
| 6 | Pump Controls |  |  |  | 47 | 47 |
| 6 | Pump Controls | ✓ |  |  | 1 | 1 |
| 7 | Sprill and Clean Kits |  |  |  | 47 | 47 |
| 7 | Sprill and Clean Kits | ✓ |  |  | 1 | 1 |
| 8 | Inspection Stickers |  |  |  | 47 | 47 |
| 8 | Inspection Stickers | ✓ |  |  | 1 | 1 |
| 9 | PPE |  |  |  | 47 | 47 |
| 9 | PPE | ✓ |  |  | 1 | 1 |
| 10 | Auxiliary Lights |  |  |  | 47 | 47 |
| 10 | Auxiliary Lights | ✓ |  |  | 1 | 1 |
| 11 | Safety Chains and Tape |  |  |  | 47 | 47 |
| 11 | Safety Chains and Tape | ✓ |  |  | 1 | 1 |
| 12 | Tag Line |  |  |  | 47 | 47 |
| 12 | Tag Line | ✓ |  |  | 1 | 1 |
| 13 | Airport Flag |  |  |  | 47 | 47 |
| 13 | Airport Flag | ✓ |  |  | 1 | 1 |
| 14 | Boom / Hoist / Levers |  |  |  | 47 | 47 |
| 14 | Boom / Hoist / Levers | ✓ |  |  | 1 | 1 |
| 15 | Warning Labels |  |  |  | 47 | 47 |
| 15 | Warning Labels | ✓ |  |  | 1 | 1 |
| 16 | Coolant Levels |  |  |  | 47 | 47 |
| 16 | Coolant Levels | ✓ |  |  | 1 | 1 |
| 17 | Engine Oil |  |  |  | 47 | 47 |
| 17 | Engine Oil | ✓ |  |  | 1 | 1 |
| 18 | Belts and Pulleys |  |  |  | 47 | 47 |
| 18 | Belts and Pulleys | ✓ |  |  | 1 | 1 |
| 19 | Seat Belts |  |  |  | 47 | 47 |
| 19 | Seat Belts | ✓ |  |  | 1 | 1 |
| 20 | Hydraulic Oil Level |  |  |  | 47 | 47 |
| 20 | Hydraulic Oil Level | ✓ |  |  | 1 | 1 |
| 21 | Power Steering Fluid |  |  |  | 47 | 47 |
| 21 | Power Steering Fluid | ✓ |  |  | 1 | 1 |
| 22 | Tire and Lugnuts |  |  |  | 47 | 47 |
| 22 | Tire and Lugnuts | ✓ |  |  | 1 | 1 |
| 23 | Mud Flaps and Rims |  |  |  | 47 | 47 |
| 23 | Mud Flaps and Rims | ✓ |  |  | 1 | 1 |
| 24 | Windows and Mirrors |  |  |  | 47 | 47 |
| 24 | Windows and Mirrors | ✓ |  |  | 1 | 1 |
| 25 | Lights and Signals |  |  |  | 47 | 47 |
| 25 | Lights and Signals | ✓ |  |  | 1 | 1 |
| 26 | Brake Operation |  |  |  | 47 | 47 |
| 26 | Brake Operation | ✓ |  |  | 1 | 1 |
| 27 | Fuel Cap Secured |  |  |  | 47 | 47 |
| 27 | Fuel Cap Secured | ✓ |  |  | 1 | 1 |
| 28 | Additional Comments |  |  |  | 47 | 47 |
| 28 | Additional Comments | ✓ |  |  | 1 | 1 |

### Pre Trip Inspection — 36 distinct questions

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Load Line / Hook | ✓ |  |  | 1 | 1 |
| 2 | Chain Rigging/Straps/Shackles | ✓ |  |  | 1 | 1 |
| 3 | Sheaves | ✓ |  |  | 1 | 1 |
| 4 | Hydraulic Hoses, Pump Controls | ✓ |  |  | 1 | 1 |
| 5 | Spill Kit | ✓ |  |  | 1 | 1 |
| 6 | Current Inspection Sticker | ✓ |  |  | 1 | 1 |
| 7 | Load Charts | ✓ |  |  | 1 | 1 |
| 8 | PPE | ✓ |  |  | 1 | 1 |
| 9 | Auxillary Lights | ✓ |  |  | 1 | 1 |
| 10 | Tag Line | ✓ |  |  | 1 | 1 |
| 11 | Air Port Flag | ✓ |  |  | 1 | 1 |
| 12 | Boom/ Hoist/ Levers | ✓ |  |  | 1 | 1 |
| 13 | Warning Labels | ✓ |  |  | 1 | 1 |
| 14 | Coolant | ✓ |  |  | 1 | 1 |
| 15 | Engine Oil | ✓ |  |  | 1 | 1 |
| 16 | Belts | ✓ |  |  | 1 | 1 |
| 17 | Seatbelts | ✓ |  |  | 1 | 1 |
| 18 | Hydraulic Oil | ✓ |  |  | 1 | 1 |
| 19 | Power Steering Oil | ✓ |  |  | 1 | 1 |
| 20 | Tires/ Lugnuts | ✓ |  |  | 1 | 1 |
| 21 | Fuel Cap Secure | ✓ |  |  | 1 | 1 |
| 22 | Mudflaps | ✓ |  |  | 1 | 1 |
| 23 | Windows/ Mirrors | ✓ |  |  | 1 | 1 |
| 24 | Lights/ Signals | ✓ |  |  | 1 | 1 |
| 25 | Brake Operation | ✓ |  |  | 1 | 1 |
| 26 | Current Insruance | ✓ |  |  | 1 | 1 |
| 27 | Quarter/ Annual Crane Cert | ✓ |  |  | 1 | 1 |
| 28 | Current Registration | ✓ |  |  | 1 | 1 |
| 29 | Trailer Connection Air/ Electric/ Hitch | ✓ |  |  | 1 | 1 |
| 30 | Odometer Start | ✓ |  |  | 1 | 1 |
| 31 | Odometer Start | ✓ |  |  | 1 | 1 |
| 32 | Hours Start | ✓ |  |  | 1 | 1 |
| 33 | Hours End | ✓ |  |  | 1 | 1 |
| 34 | Fuel Start | ✓ |  |  | 1 | 1 |
| 35 | Fuel End | ✓ |  |  | 1 | 1 |
| 36 | Total Hours | ✓ |  |  | 1 | 1 |

### JSA — 34 distinct questions

**AAJ · After Arrived Job**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Working Near Cranes | ✓ |  |  | 1 | 1 |
| 2 | Falling Objects | ✓ |  |  | 1 | 1 |
| 3 | Poor Lighting | ✓ |  |  | 1 | 1 |
| 4 | Sliperrery Surfaces | ✓ |  |  | 1 | 1 |
| 5 | Multipule Electrical Feeds | ✓ |  |  | 1 | 1 |
| 6 | Trip Hazards | ✓ |  |  | 1 | 1 |
| 7 | Electrical > 4001 Amps | ✓ |  |  | 1 | 1 |
| 8 | Manual Handling | ✓ |  |  | 1 | 1 |
| 9 | Sharp Materials | ✓ |  |  | 1 | 1 |
| 10 | Ladders Used | ✓ |  |  | 1 | 1 |
| 11 | Working at Heights | ✓ |  |  | 1 | 1 |
| 12 | Flammable Materials in area | ✓ |  |  | 1 | 1 |
| 13 | Pressurized Fluids | ✓ |  |  | 1 | 1 |
| 14 | Suspended Loads | ✓ |  |  | 1 | 1 |
| 15 | Poor Visibility | ✓ |  |  | 1 | 1 |
| 16 | Inhalable Dust/Fibers | ✓ |  |  | 1 | 1 |
| 17 | High Noise Areas | ✓ |  |  | 1 | 1 |
| 18 | Communication Difficulties | ✓ |  |  | 1 | 1 |
| 19 | Moving Machinery | ✓ |  |  | 1 | 1 |
| 20 | Tools and Equipment | ✓ |  |  | 1 | 1 |
| 21 | Shackles, Chains, Slings | ✓ |  |  | 1 | 1 |
| 22 | Gloves | ✓ |  |  | 1 | 1 |
| 23 | High Visibility Vest | ✓ |  |  | 1 | 1 |
| 24 | Safety Glasses | ✓ |  |  | 1 | 1 |
| 25 | Fall Arrest Systems | ✓ |  |  | 1 | 1 |
| 26 | Fire Extinguisher | ✓ |  |  | 1 | 1 |
| 27 | Equipment Grounded | ✓ |  |  | 1 | 1 |
| 28 | Erect Warning Signs | ✓ |  |  | 1 | 1 |
| 29 | Tag Lines | ✓ |  |  | 1 | 1 |
| 30 | Barricades | ✓ |  |  | 1 | 1 |
| 31 | Street Permits | ✓ |  |  | 1 | 1 |
| 32 | Lane Closures | ✓ |  |  | 1 | 1 |
| 33 | FAA | ✓ |  |  | 1 | 1 |
| 34 | Safety Meeting Performed | ✓ |  |  | 1 | 1 |

### AT - Tractors Pre-Trip Inspections — 33 distinct questions

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Chains / Binders | ✓ |  |  | 25 | 25 |
| 1 | Chains / Binders / Load is Secure | ✓ |  |  | 1 | 1 |
| 2 | Straps / Shackles | ✓ |  |  | 26 | 26 |
| 3 | Spill and Clean Kits | ✓ |  |  | 25 | 25 |
| 3 | Spill and Clean Kits / Cones / Wheel Chocks / Fire Extinguisher | ✓ |  |  | 1 | 1 |
| 4 | Air Hoses | ✓ |  |  | 25 | 25 |
| 4 | Air Hoses / Trailer Connection | ✓ |  |  | 1 | 1 |
| 5 | Head Lights / Running Lights/ Auxiliary Lights | ✓ |  |  | 1 | 1 |
| 5 | Inspection Stickers | ✓ |  |  | 25 | 25 |
| 6 | PPE | ✓ |  |  | 25 | 25 |
| 7 | Auxiliary Lights | ✓ |  |  | 25 | 25 |
| 7 | Coolant Level | ✓ |  |  | 1 | 1 |
| 8 | Safety Chains and Tape | ✓ |  |  | 25 | 25 |
| 9 | Warning Labels | ✓ |  |  | 25 | 25 |
| 10 | Coolant Level | ✓ |  |  | 25 | 25 |
| 11 | Engine Oil | ✓ |  |  | 26 | 26 |
| 12 | Belts and Pulleys | ✓ |  |  | 25 | 25 |
| 13 | Seat Belts | ✓ |  |  | 26 | 26 |
| 14 | Hydraulic Oil Level | ✓ |  |  | 25 | 25 |
| 15 | Power Steering Fluid | ✓ |  |  | 26 | 26 |
| 16 | Tires and Lugnuts | ✓ |  |  | 26 | 26 |
| 17 | Mud Flaps and Rims | ✓ |  |  | 25 | 25 |
| 18 | Windows and Mirrors | ✓ |  |  | 26 | 26 |
| 19 | Lights and Signals | ✓ |  |  | 25 | 25 |
| 20 | Brake Operation | ✓ |  |  | 26 | 26 |
| 21 | Compliance: Registration , Tags , Insurance Cards , Travel Permits | ✓ |  |  | 1 | 1 |
| 21 | Registration and Tags | ✓ |  |  | 25 | 25 |
| 22 | Insurance Cards | ✓ |  |  | 25 | 25 |
| 23 | Travel Permits | ✓ |  |  | 25 | 25 |
| 24 | Trailer Connections | ✓ |  |  | 25 | 25 |
| 25 | Additional Comments | ✓ |  |  | 1 | 1 |
| 25 | Load Strapped Down | ✓ |  |  | 25 | 25 |
| 26 | Additional Comments | ✓ |  |  | 25 | 25 |

### AT- Tractors Pre- Trip Inspection — 31 distinct questions

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Chains / Binders | ✓ |  |  | 1 | 1 |
| 2 | Straps / Shackles | ✓ |  |  | 1 | 1 |
| 3 | Spill and Clean Kits | ✓ |  |  | 1 | 1 |
| 4 | Air Hoses | ✓ |  |  | 1 | 1 |
| 5 | Inspection Stickers | ✓ |  |  | 1 | 1 |
| 6 | PPE | ✓ |  |  | 1 | 1 |
| 7 | Auxiliary Lights | ✓ |  |  | 1 | 1 |
| 8 | Safety Chains and Tape | ✓ |  |  | 1 | 1 |
| 9 | Warning Labels | ✓ |  |  | 1 | 1 |
| 10 | Coolant Level | ✓ |  |  | 1 | 1 |
| 11 | Engine Oil | ✓ |  |  | 1 | 1 |
| 12 | Belts and Pulleys | ✓ |  |  | 1 | 1 |
| 13 | Seat Belts | ✓ |  |  | 1 | 1 |
| 14 | Hydraulic Oil Level | ✓ |  |  | 1 | 1 |
| 15 | Power Steering Fluid | ✓ |  |  | 1 | 1 |
| 16 | Tires and Lugnuts | ✓ |  |  | 1 | 1 |
| 17 | Mud Flaps and Rims | ✓ |  |  | 1 | 1 |
| 18 | Windows and Mirrors | ✓ |  |  | 1 | 1 |
| 19 | Lights and Signals | ✓ |  |  | 1 | 1 |
| 20 | Brake Operation | ✓ |  |  | 1 | 1 |
| 21 | Registration and Tags | ✓ |  |  | 1 | 1 |
| 22 | Insurance Cards | ✓ |  |  | 1 | 1 |
| 23 | Travel Permits | ✓ |  |  | 1 | 1 |
| 24 | Tailer Connections | ✓ |  |  | 1 | 1 |
| 25 | Load Strapped Down | ✓ |  |  | 1 | 1 |
| 26 | Odometer Start | ✓ |  |  | 1 | 1 |
| 27 | Odometer End | ✓ |  |  | 1 | 1 |
| 28 | Total Hours | ✓ |  |  | 1 | 1 |
| 29 | Fuel Start | ✓ |  |  | 1 | 1 |
| 30 | Fuel End | ✓ |  |  | 1 | 1 |
| 31 | Additional Rigging and Equipment | ✓ |  |  | 1 | 1 |

### St- Stakebeds and UT Pre-Trip Inspection — 29 distinct questions

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 9 | Clean Kits | ✓ |  |  | 1 | 1 |
| 10 | Chains and Binders | ✓ |  |  | 1 | 1 |
| 11 | Straps and Shackles | ✓ |  |  | 1 | 1 |
| 12 | Inspections Stickers | ✓ |  |  | 1 | 1 |
| 13 | PPE | ✓ |  |  | 1 | 1 |
| 14 | Auxiliary Lights | ✓ |  |  | 1 | 1 |
| 15 | Warning Labels | ✓ |  |  | 1 | 1 |
| 16 | Coolant  Level | ✓ |  |  | 1 | 1 |
| 17 | Engine Oil | ✓ |  |  | 1 | 1 |
| 18 | Belts and Pulleys | ✓ |  |  | 1 | 1 |
| 19 | Seat Belts | ✓ |  |  | 1 | 1 |
| 20 | Hydraulic Oil Level | ✓ |  |  | 1 | 1 |
| 21 | Power Steeting Fluid | ✓ |  |  | 1 | 1 |
| 22 | Tires and Lugnuts | ✓ |  |  | 1 | 1 |
| 23 | Mud Flaps and Rims | ✓ |  |  | 1 | 1 |
| 24 | Windows and Mirrors | ✓ |  |  | 1 | 1 |
| 25 | Registration and Tags | ✓ |  |  | 1 | 1 |
| 26 | Insurance Cards | ✓ |  |  | 1 | 1 |
| 27 | Travel Permit | ✓ |  |  | 1 | 1 |
| 28 | Fuel Cap Secured | ✓ |  |  | 1 | 1 |
| 29 | Trailer Connections | ✓ |  |  | 1 | 1 |
| 30 | Odometer Start | ✓ |  |  | 1 | 1 |
| 31 | Odometer End | ✓ |  |  | 1 | 1 |
| 32 | Hours Start | ✓ |  |  | 1 | 1 |
| 33 | Hours End | ✓ |  |  | 1 | 1 |
| 34 | Total Hours | ✓ |  |  | 1 | 1 |
| 35 | Fuel Start | ✓ |  |  | 1 | 1 |
| 36 | Fuel End | ✓ |  |  | 1 | 1 |
| 37 | Additional Equipment and Rigging | ✓ |  |  | 1 | 1 |

### Crane 30 Check List — 24 distinct questions

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | First Aid Kit |  |  |  | 6 | 6 |
| 1 | First Aid Kit | ✓ |  |  | 29 | 29 |
| 2 | Fire Extinguisher |  |  |  | 6 | 6 |
| 2 | Fire Extinguisher | ✓ |  |  | 29 | 29 |
| 3 | Accident Binder Kit |  |  |  | 6 | 6 |
| 3 | Accident Binder Kit | ✓ |  |  | 29 | 29 |
| 4 | Insurance & Registration |  |  |  | 6 | 6 |
| 4 | Insurance & Registration | ✓ |  |  | 29 | 29 |
| 5 | Operators Manual |  |  |  | 6 | 6 |
| 5 | Operators Manual | ✓ |  |  | 29 | 29 |
| 6 | Crane Certifications |  |  |  | 6 | 6 |
| 6 | Crane Certifications | ✓ |  |  | 29 | 29 |
| 7 | FAA Flag |  |  |  | 6 | 6 |
| 7 | FAA Flag | ✓ |  |  | 29 | 29 |
| 8 | Spill Kit |  |  |  | 6 | 6 |
| 8 | Spill Kit | ✓ |  |  | 29 | 29 |
| 9 | Clean Kit |  |  |  | 6 | 6 |
| 9 | Clean Kit | ✓ |  |  | 29 | 29 |
| 10 | Crib Block |  |  |  | 6 | 6 |
| 10 | Crib Block | ✓ |  |  | 29 | 29 |
| 11 | Outrigger Pad |  |  |  | 6 | 6 |
| 11 | Outrigger Pad | ✓ |  |  | 29 | 29 |
| 12 | Interior Condition |  |  |  | 6 | 6 |
| 12 | Interior Condition | ✓ |  |  | 29 | 29 |

### CWT and Flatbed Trailers Pre- Trip Inspection — 18 distinct questions

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Spill and Clean Kits | ✓ |  |  | 1 | 1 |
| 2 | Chains and Binders | ✓ |  |  | 1 | 1 |
| 3 | Straps and Shackles | ✓ |  |  | 1 | 1 |
| 4 | Inspections Stickers | ✓ |  |  | 1 | 1 |
| 5 | PPE | ✓ |  |  | 1 | 1 |
| 6 | Auziliary Lights | ✓ |  |  | 1 | 1 |
| 7 | Warning Labels | ✓ |  |  | 1 | 1 |
| 8 | Tires and Lugnuts | ✓ |  |  | 1 | 1 |
| 9 | Mud Flats and Rims | ✓ |  |  | 1 | 1 |
| 10 | Chalks and Blocks | ✓ |  |  | 1 | 1 |
| 11 | Landing Gear | ✓ |  |  | 1 | 1 |
| 12 | Lights and Signals | ✓ |  |  | 1 | 1 |
| 13 | Brake Operation | ✓ |  |  | 1 | 1 |
| 14 | Registration and Tags | ✓ |  |  | 1 | 1 |
| 15 | Insurance Cards | ✓ |  |  | 1 | 1 |
| 16 | Travel Permits | ✓ |  |  | 1 | 1 |
| 17 | Traliler Connections | ✓ |  |  | 1 | 1 |
| 18 | Additional Equipment and Rigging | ✓ |  |  | 1 | 1 |

### Build Up/Breakdown Time Stamps — 15 distinct questions

**BLJ · Before Left Job**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Build Up Time |  |  |  | 32 | 32 |
| 2 | Hook Time ( Start Time and End Time Example- 10 am - 2 pm ) |  |  |  | 42 | 42 |
| 3 | Break Down Time |  |  |  | 42 | 42 |

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | First Aid Kit | ✓ |  |  | 2 | 2 |
| 2 | Fire Extinguisher | ✓ |  |  | 2 | 2 |
| 3 | Accident Binder Kit | ✓ |  |  | 2 | 2 |
| 4 | Insurance & Registration | ✓ |  |  | 2 | 2 |
| 5 | Operators Manual | ✓ |  |  | 2 | 2 |
| 6 | Crane Certifications | ✓ |  |  | 2 | 2 |
| 7 | FAA Flag | ✓ |  |  | 2 | 2 |
| 8 | Spill Kit | ✓ |  |  | 2 | 2 |
| 9 | Clean Kit | ✓ |  |  | 2 | 2 |
| 10 | Crib Block | ✓ |  |  | 2 | 2 |
| 11 | Outrigger Pad | ✓ |  |  | 2 | 2 |
| 12 | Interior Condition | ✓ |  |  | 2 | 2 |

### Work Through Lunch — 14 distinct questions

**BLJ · Before Left Job**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Leave Yard | ✓ |  |  | 1 | 1 |
| 2 | Arrive Job | ✓ |  |  | 1 | 1 |
| 3 | Build Up | ✓ |  |  | 1 | 1 |
| 4 | Work | ✓ |  |  | 1 | 1 |
| 5 | Break Down | ✓ |  |  | 1 | 1 |
| 6 | Leave Job | ✓ |  |  | 1 | 1 |
| 7 | Arrive Yard | ✓ |  |  | 1 | 1 |
| 8 | If Subsistence is applicable please click deficiency and note long or short sub in the comments | ✓ |  |  | 1 | 1 |
| 8 | Lunch Time ( If lunch is taken enter time here, example: Lunch 12 pm to 12:30 pm) | ✓ |  |  | 1 | 1 |
| 9 | Lunch Time: 2nd Lunch | ✓ |  |  | 1 | 1 |
| 11 | Lunch Time: 3rd Lunch | ✓ |  |  | 1 | 1 |
| 12 | Lunch Time: 4th Lunch | ✓ |  |  | 1 | 1 |
| 13 | By signing this check list I am also signing that I performed and completed  my Pre Trip Inspection, Rigging  Inspection and Post Trip Inspection. | ✓ |  |  | 1 | 1 |
| 14 | I certify that the work time that I entered and submitted on my labor tab / timesheet is correct to the best of my knowledge. I further confirm that, in the event that I worked more than five hours in one workday, I have taken one or more thirty minute mea | ✓ |  |  | 1 | 1 |

### Rigging Inspection — 12 distinct questions

**AAJ · After Arrived Job**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Wire Rope |  |  |  | 47 | 47 |
| 1 | Wire Rope | ✓ |  |  | 2 | 2 |
| 2 | Web Slings |  |  |  | 47 | 47 |
| 2 | Web Slings | ✓ |  |  | 2 | 2 |
| 3 | Shackles |  |  |  | 47 | 47 |
| 3 | Shackles | ✓ |  |  | 2 | 2 |
| 4 | Additional Rigging |  |  |  | 47 | 47 |
| 4 | Additional Rigging | ✓ |  |  | 2 | 2 |
| 5 | Additional Rigging |  |  |  | 47 | 47 |
| 5 | Additional Rigging | ✓ |  |  | 2 | 2 |
| 6 | Additional Rigging |  |  |  | 47 | 47 |
| 6 | Additional Rigging | ✓ |  |  | 2 | 2 |

### Small Truck 30 Day Checklist — 7 distinct questions

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | First Aid Kit |  |  |  | 11 | 11 |
| 2 | Fire Extinguisher |  |  |  | 11 | 11 |
| 3 | Accident Binder |  |  |  | 11 | 11 |
| 4 | Insurance and Registration |  |  |  | 11 | 11 |
| 5 | Owners Manual |  |  |  | 11 | 11 |
| 6 | Wheel Chalks |  |  |  | 11 | 11 |
| 7 | Interior Condition |  |  |  | 11 | 11 |

### JSA  12.18.25 — 6 distinct questions

**AAJ · After Arrived Job**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Working Near Cranes / Suspended Loads / Falling Objects / Moving Machinery / Tag Lines / Lift Barricdes / Ladders Used / Tools and Equipment / Sharp Metals | ✓ |  |  | 1 | 1 |
| 2 | PPE: Gloves / High Visibility Vests/ Safety Glasses / Fall Arrest Systems | ✓ |  |  | 1 | 1 |
| 3 | Site Conditions: Poor Lighting / Poor Visibility  / Slippery Surfaces / Trip Hazards / Working at Heights / Flammable and Pressurized Fluids and Materials in Area / Inhalable Dust or Fibers / High Noise Area / Communication Difficulities / Street Permits / | ✓ |  |  | 1 | 1 |
| 4 | Rigging: Shackles / Chains/ Slings/ Cables / Spreader Bar | ✓ |  |  | 1 | 1 |
| 5 | Electrical > 4001 AMPS / Mulitpule Electrial Feeds / Equipment Grounded | ✓ |  |  | 1 | 1 |
| 6 | Safety Meeting Performed | ✓ |  |  | 1 | 1 |

### Tractor 30 Day Check List — 6 distinct questions

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | First Aid Kit |  |  |  | 28 | 28 |
| 2 | Fire Extinguisher |  |  |  | 28 | 28 |
| 3 | Accident Binder |  |  |  | 28 | 28 |
| 4 | Insurance and Registration |  |  |  | 28 | 28 |
| 5 | Owners Manual |  |  |  | 28 | 28 |
| 6 | Interior Condition |  |  |  | 28 | 28 |

### Trailer 30 Day Check List — 4 distinct questions

**BLY · Before Left Yard**

| # | Question | Sig | Cmt | Deficiency code | Copies | Active |
|---|---|---|---|---|---|---|
| 1 | Insurance and Registration |  |  |  | 31 | 31 |
| 2 | Wheel Chalks |  |  |  | 31 | 31 |
| 3 | DOT Tape |  |  |  | 31 | 31 |
| 4 | Deck Condition |  |  |  | 31 | 31 |

## What stands out

- **The lunch attestation is a checklist item, not a form.** *Work Through Lunch* ends with two
  signature-required statements: that the pre-trip, rigging and post-trip inspections were
  performed, and that the submitted work time is correct and, for a day over five hours, a
  30-minute meal was taken or a waiver applies. That is the WTL evidence the payroll app's
  `usp_Apply_WTL_MealPeriods` looks for
  ([../../legacy-payroll-app-db-extract/calculations.md](../../legacy-payroll-app-db-extract/calculations.md) B7).
- **Time Stamps is a checklist** — the labour record itself is captured as check items with
  signatures per phase, which is why the e-ticket example calls it "the labour record"
  ([../../../field-ops/e-ticket-worked-example.md](../../../field-ops/e-ticket-worked-example.md) §5).
- **Two spellings of the same checklist coexist** (*Crane Pre-Trip Inspection* / *Crane Pre- Trip
  Inspection*, *AT - Tractors…* / *AT- Tractors…*, *JSA* / *JSA 12.18.25* / *Job Safety
  Analysis*). The later-dated variants are the live templates; the older names survive on
  units that were never re-assigned. A migration keyed on checklist name will double-count.
- **Deficiency codes** are populated only on a minority of questions; most inspections rely on
  the free-text comment.

## Source

`TCG_SQL_backup_2026-06-23.7z` → `TCG_RawFMS_20260623.bak`, tables `stg.FMS_CHECK_LIST_Raw`,
`stg.FMS_CHECK_LIST_DETAILS_Raw`, `stg.FMS_UNIT_CHECK_LIST_Raw`; queried 2026-09-04 with the
grouping described above. Full DDL in [../ddl/](../ddl/).
