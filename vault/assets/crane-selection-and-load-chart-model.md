---
title: Crane selection workbook — the load-chart data model TCG has already designed
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/New Updated Crane Chart Sheet.xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/quotations, kind/source, lift-plans, reference-data, architecture, safety, provenance, requirements]
entities: []
---

# Crane selection workbook — the load-chart data model TCG has already designed

**What this is.** `New Updated Crane Chart Sheet.xlsx` — 30 sheets, build-stamped **2026-06-02
15:51**, delivered by **Ryan Adams** in the 2026-08-06 sales-process folder. On its face it is a
spreadsheet that picks a crane for a job. Underneath it is **fourteen revisions of someone working
out how load-chart data has to be modelled** — and the last four (v11 → v14) state that model as
explicit rules, gates and a normalised schema. If TCG ever asks the ERP to recommend a crane, or
to hold load-chart data at all, this file is the requirement, written by the client, before anyone
asked for it.

> **It is not a lift-planning tool and says so, repeatedly.** *"This is a quoting/intake estimator.
> It is NOT an operating load chart and must not be used to operate a crane."* (`QA Check`). Every
> recommendation carries *"Use recommendation for quoting only; verify final chart, rigging
> deductions, mats, setup and route."* Nothing here has been adjudicated for the ERP.

The fleet it covers — 16 models, class tonnage, boom and setup dimensions — is tabulated in
[crane-fleet-reference.md](crane-fleet-reference.md) §2.

---

## 1. What the tool does

`Intake & Recommendation` is the front sheet. Yellow input cells; a live recommendation block;
then a pass/fail table over all 16 cranes.

**Inputs:** customer/caller, phone/email, project/jobsite, salesperson, estimator · **load weight
(lb)** · rigging / hook-block allowance (lb) · **required radius from centre pin (ft)** ·
required hook height (ft) · available setup width / outrigger space (ft) · access width to site
(ft) · overhead clearance on route (ft) · ground condition · multiple picks? · long-reach /
over-200-ft-radius? · notes.

**Outputs:** total lifted weight · exact tons (`lb ÷ 2000`) · **recommended crane** · crane class ·
required configuration · published chart capacity used · capacity margin · nearest chart radius
used · outrigger/setup status · warning flags · required boom angle · angle band · jib/fly needed? ·
long-reach review · final estimator action.

Worked example carried in the file as delivered: 63,000 lb at 30 ft radius, 24 ft setup width →
**Liebherr LTM 1100-5.3**, class 110, main boom, chart capacity 65,000 lb, margin 2,000 lb,
boom angle ~90°, *"Full setup available"*, warning *"Ground/mat review"*.

**Selection method, in the workbook's words:** *"Smallest crane class where sampled capacity >=
load + rigging and radius/hook/setup pass."*

**The 85% warning, twice.** The intake sheet: *"The uploaded charts are already ASME/manufacturer
85% rated where noted, so the tool does NOT apply another 85% reduction."* `QA Check`: *"Most
published charts are already based on ASME/manufacturer 85% stability limits. Do not blindly apply
another 85% reduction unless company policy requires it."* This is **not** the same 85% as the
sales de-rating rule in [crane-fleet-reference.md](crane-fleet-reference.md) §7, which is about
which class to charge for. Nothing in either document relates the two.

---

## 2. The data model — what a capacity row must be

`Max Chart Config Rules` (7 rules) and `3DLP Config Rules` (7 rules) both state the same core idea:
**capacity belongs to a configuration, never to a crane.**

> `Configuration ID = Crane + carrier + outrigger + counterweight + boom length + attachment +
> offset + rotation chart.`

The rules, condensed, each with the reason the workbook gives:

| Rule | Why the workbook gives |
| --- | --- |
| Store the maximum published chart **separately** from reduced/alternate charts | *"A 100% outrigger + max counterweight chart is not valid for partial setup or lower counterweight."* |
| **All capacities stay in pounds**; exact tons = lb ÷ 2,000 | *"Avoids rounding error when rigging, block, and deductions are added."* Keep formulas in pounds until display |
| **Separate rows** for main boom, each jib/fly/luffing family, each counterweight package, each outrigger/support state | *"One generic 'jib' row can overstate or understate capacity."* |
| Baseline = **heaviest counterweight + fully extended outriggers + 360°/full chart + main boom only** | apples-to-apples comparison; *"Avoids 90-ton vs 100-ton chart-base mismatch"* |
| **Partial setup blocks the max chart.** If available setup width < full setup width, the recommendation is preliminary and the exact reduced-support chart is required | the workbook admits its own earlier versions *"used full chart capacities even after flagging partial setup"* |
| Hook height, radius, boom length and boom angle must be **feasible together** | *"Max hook height alone does not prove the lift works at the requested radius."* |
| **Every capacity row carries a source URL + page/section + reviewer** | *"No citation = unverified."* |
| Capacity should **decline as radius increases**; a quality flag catches rows where it does not | engineering sanity check |

`v14 Chart Data Schema` normalises this into tables and fields with required-flags, examples and
validation rules — e.g. `Crane ID` (*"Do not use display name as key"*, example `LTM1220-5.2`) and
`Manufacturer` as a dropdown of **Liebherr / Grove / Link-Belt / Manitex / Other**, because the
manufacturer *routes which source is authoritative* (§4).

`v14 Exact Capacity Entry` is the resulting row shape — 23 columns, one row per
crane/configuration/radius/boom-length/chart value:

```
Crane · Manufacturer · Configuration ID · Source Engine · Chart Authority · Trust Status ·
Counterweight/Ballast · Outrigger/Support Base · Rotation · Boom System · Main Boom Length ft ·
Attachment Type · Attachment Length ft · Offset deg · Radius ft · Capacity lb ·
85% Planning Capacity lb · Hook Height ft · Deductions Included? · Source URL/Document ·
Source Page/Section · Reviewer · Review Date
```

Sample Configuration IDs from the sheet: `LTM1220|MAIN|97K|FULLSUPPORT|360|BOOM197` ·
`LTM1220|LUFFER|EXACT|FULLSUPPORT|360` · `HTC86100|MAIN|39500CW|FULLOUTRIGGERS|360`. Reviewer on
every sample row: *"Ryan / TCG reviewer"*, dated 2026-06-02.

---

## 3. The eight recommendation gates

`v14 Recommendation Gates` — *"only exact trusted chart configurations may drive the estimator."*
Each gate has a pass condition, a fail condition, an action, and pseudo-logic. Reproduced because
they are the closest thing in the drop to acceptance criteria for a lift-data feature:

| Gate | Rule | Fails when | Action |
| --- | --- | --- | --- |
| **G01** | Exact chart source required | Source URL, section or reviewer missing | **Block** recommendation |
| **G02** | Baseline must be apples-to-apples | Partial outriggers, lighter counterweight, on-rubber, unknown setup | Exclude from baseline matrix |
| **G03** | No generic attachment row | A generic Jib/Fly/Luffing row without exact length, offset and boom length | **Block** recommendation |
| **G04** | Liebherr routing | A Liebherr row sourced only from an unverified third party | Needs manager/engineer review |
| **G05** | Capacity cannot exceed the chart family max | Capacity > config maximum, or an obvious reverse trend | Flag for audit |
| **G06** | Attachment sanity | Attachment capacity compared against unrelated shorter-radius main-boom values | **Block** the attachment row |
| **G07** | Radius and boom geometry present | Radius-only row taken from a multi-boom chart | Needs transcription completion |
| **G08** | Final lift-plan disclaimer | Output presented as a final engineered lift plan | Require formal validation |

G08's pseudo-logic is unconditional: *"Always preliminary unless FinalValidation = Approved."*

---

## 4. Source authority is per manufacturer

`v14 Source Priority` assigns a source of truth by make and states what may not be done:

| Make / case | Source of truth | Secondary aid | May recommend? | Blocked example given |
| --- | --- | --- | --- | --- |
| Liebherr LTM / LRT / LR | **Liebherr Crane Planner 2.0** or official Liebherr load chart | 3D Lift Plan if the model/config exists | after chart row verified | one generic LTM luffer row; using VarioBase partially |
| Grove / Manitowoc / National | OEM chart PDF / chart revision | 3D Lift Plan for selection, geometry, visual planning | after OEM chart row verified | MegaWingLift value in a normal main-boom row |
| Link-Belt | Official Link-Belt chart or exact rating manual | 3DLP as planning aid only | after exact row verified | mixing 8,500 lb and 39,500 lb counterweight rows |
| Manitex boom trucks | Official Manitex chart for the exact truck/outrigger package | 3DLP if available, else manual entry | after chart row verified | on-rubber or partial-outrigger data in a full-outrigger baseline |
| Unsupported / rare crane | OEM or owner's manual chart only | none unless manually validated | **NO until verified** | using the nearest model; interpolating from another manufacturer |

`v13 3DLP Rebuild` is explicit about what the workbook is *not*: *"3D Lift Plan load chart database
is proprietary/login based. This workbook mirrors the configuration model and uses public chart
sources where available; it does not claim to copy 3D Lift Plan proprietary data."*

`Load Chart Source Map` (16 rows, one per crane) carries the primary and secondary URLs, the max
chart basis, the *"combinations that must stay separate"*, and a per-crane estimator note.
Several notes are themselves modelling requirements: *"MegaWingLift must be a separate config
because it changes mob/setup and capacity"* (GMK7550) · *"Multiple counterweight packages cannot be
collapsed for transport/setup cost"* (HTC-8690) · *"The workbook should distinguish GMK6300L vs
GMK6300L-1 when fleet-specific chart is attached"* · *"VarioBase/support base cannot use
full-support max chart when setup width is constrained"* (LTM 1300-6.2).

---

## 5. How far the data itself can be trusted — the workbook's own answer: not far

This matters more than anything above, because the numbers look authoritative and are not.

- `Capacity Matrix` holds a 5-ft-interval radius grid from **10 ft to 320 ft** for each
  crane × configuration. Every crane has a `Main` row and a `Jib/Fly/Luffing` row.
- **Every `Jib/Fly/Luffing` row is zeroed and disabled.** Basis note: *"Disabled: generic
  attachment row is unsafe."* `Capacity Quality Flags` marks them *"Blocked from recommendation
  engine."*
- Every `Main` row is marked *"Existing row retained; needs full source re-transcription before
  use as final baseline"*, and its quality-flag status is *"Trusted only if exact chart section is
  cited."*
- `Loaded Max Chart Audit` says of every crane: *"YES - preliminary estimator only"* for
  recommendation, *"NO - require exact reduced setup chart"* for reduced setup, and lists
  what is still missing as *"full per-chart transcription by counterweight / outrigger / boom
  length / jib angle / fly / luffing combination."*
- `v14 Build Notes` opens with: *"Capacity Matrix remains unsafe unless fed by trusted exact chart
  rows."*
- `Exact Chart Data Template` and `v14 Exact Capacity Entry` are **templates** — their capacity
  cells read `TO BE TRANSCRIBED`, verification status `Pending`.
- `Estimator Source Register` records one provenance TCG should know about: for the Manitex
  40124SHL the source is *"Current ChatGPT upload from prior workbook build"*, and the Manitex
  3051T note reads *"Internet-seeded missing 30T chart."*

**So: the rules are the deliverable; the numbers are not.** A migration that lifts capacity values
out of this workbook would be importing values the author has flagged as untranscribed.

`Angle & Jib Rating Data` (4,135 rows) and `Capacity Curves` (2,015 rows) are the sampled
geometry behind the screen — crane, configuration, radius, boom/jib angle, approximate hook
height, sampled capacity, height-fit yes/no, source key. **Row data not copied**; it carries the
same trust caveats.

---

## 6. Other sheets, and what they hold

| Sheet | Rows | Holds |
| --- | ---: | --- |
| `Intake & Recommendation` | — | the front screen (§1) |
| `Selection Engine` | 16 | the per-crane decision row: main/ext column and capacity, `Main OK`/`Ext OK`, best capacity, config, eligible, rank, radius used, setup status, warnings, required angle, angle band, jib decision, chart source status, `Final Chart Required?`, source URL, logic note |
| `Capacity Matrix` | 32 | radius grid 10→320 ft, main + (disabled) attachment rows |
| `Capacity Curves` | 2,015 | sampled curve points |
| `Crane Database` | 16 | the fleet spec table — see [crane-fleet-reference.md](crane-fleet-reference.md) §2 |
| `Estimator Source Register` | 16 | source key → source type → URL/upload reference → notes |
| `QA Check` | — | build stamp, purpose, limitations, selection method, chart-rating note |
| `Angle & Jib Rating Data` | 4,135 | radius × angle × hook height × sampled capacity |
| `Jib Angle Guide` | 16 | per crane: main boom range, attachments available, published offsets, when a jib is needed, max reference height, estimator notes. E.g. LTM 1040-2.1 — 31 ft folding jib at **0°, 20°, 40°, 60°**; RTC-8090 II — 35 ft or 35–58 ft fly plus optional 16 ft extensions at **2°, 15°, 30°, 45°** |
| `Published Capacity Summary` | 16 | max main chart capacity, radius at max, max loaded radius, attachment status, policy, v11 status |
| `Load Chart Source Map` | 16 | source authority per crane (§4) |
| `Max Chart Config Rules` | 7 | the chart-basis rules (§2) |
| `Loaded Max Chart Audit` | 16 | what is loaded, what is missing, may it recommend |
| `Max Published Capacity Basis` | 16 | the basis behind each max value |
| `v11 / v12 / v13 / v14` note sheets | — | the correction log across revisions |
| `3DLP Config Rules` / `3DLP Config Catalog` / `3DLP Source Notes` | 7 / 79 / — | the configuration model (§2) |
| `Capacity Quality Flags` | 32 | per-row trust status |
| `Exact Chart Data Template` | 59 | the 22-column transcription template |
| `v14 Hybrid Planner Model` / `Source Priority` / `Chart Data Schema` / `Hybrid Config Master` / `Recommendation Gates` / `Exact Capacity Entry` / `Build Notes` | — | the final model (§2–§4) |

---

## 7. Open, from the file itself

Recorded here as observations, not as vault questions:

1. The workbook is a **sales-admin artefact**, not a product decision. Nothing says TCG wants crane
   selection in the ERP — only that Ryan built one in Excel and it needed this data model to be
   safe.
2. `v14 Build Notes` names the next action as *"Rebuild actual capacities from v14 Exact Capacity
   Entry"* — i.e. the transcription work had not started as of 2026-06-02.
3. The two "85%" rules (ASME chart rating vs the sales de-rating threshold) are never related to
   each other in any source in this drop.

---

## 8. The formulas — how the recommendation is computed (read 2026-09-04)

649 formulas, all on three sheets; the rest of the workbook is data.

**`Intake & Recommendation`.** `H5 = load + rigging (B9 + B10)`; `H6 = H5 / 2000` (tons).
Boom angle `H15 = DEGREES(ATAN2(radius B11, height B12))`, rounded up to the nearest 10° in
`H16`. `H7` picks the crane: the `Selection Engine` row with the **lowest rank in column R**;
if every rank is 9999 → *"NO CRANE FOUND – escalate/manual review"*. `H17` says whether an
attachment is needed: *YES* if the passing config is Jib/Fly/Luffing, *REVIEW – height/radius
near main limits* if radius or height exceeds the crane's main-boom limits in `Crane Database`
(columns 5 and 6), else *NO – main boom candidate*. `H18`: radius > 200 ft → *"use expanded
angle/jib data and site visit"*.

**`Selection Engine`** (one row per crane, 16 rows). `I` finds the **radius column** in
`Capacity Matrix` by approximate match, stepping up one column when the matched radius is
*below* the requested one (i.e. it rounds the radius *up* to the next chart column — the
conservative direction). `J` reads the main-boom capacity there. **`M` = YES** when capacity ≥
gross load **and** height ≤ the crane's max main-boom height (`D`) **and** the available setup
width (`B13`) ≥ the crane's minimum (`F`). `N` is the same test for the extension row. `P`
labels the passing config *Main boom* / *Jib/Fly/Luffing* / *No passing config*; `Q` = eligible;
**`R` = the crane's tonnage class (`B`) if eligible, else 9999** — so the recommendation is
simply **the smallest eligible crane by tonnage**. `T` grades setup: width below minimum → *Too
narrow*; below full-outrigger width (`G`) → *Partial/reduced setup – verify chart*; else *Full
setup available*. `U` concatenates advisories: non-concrete ground → *Ground/mat review*; radius
> 200 → *Long radius*; jib → *required*; ineligible → *Capacity/height/setup fail*; **tonnage ≥
200 → *Permit/support trucks likely***. `Y` bands the boom angle: ≥ 70° *High boom angle*, ≤ 30°
*Low boom angle / long radius*, else *Mid angle*.

**`v14 Exact Capacity Entry`.** `Q = P × 0.85` on every row — the workbook derives a **usable
capacity of 85% of the published chart value**. This is the second 85% in the vault (the
de-rating page has 75% standard / 85% by exception); here it is applied unconditionally to the
exact-chart entries.

Nothing in the engine reads the `Angle & Jib Rating Data`, `Capacity Curves` or the `3DLP`
sheets; they are reference only. The engine is exactly: rank eligible cranes by tonnage, pick
the lightest.

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/New Updated Crane Chart
Sheet.xlsx` — 30 sheets, converted by per-sheet row dump; build timestamp inside the file is
2026-06-02 15:51. Bulk capacity rows (`Capacity Matrix`, `Capacity Curves`, `Angle & Jib Rating
Data`, `3DLP Config Catalog`) were **not** copied — structure, rules and worked examples only.
This workbook appears **only** in the sales folder; it is not part of the load-chart library
duplicated into `3.4.1_MODULE-FLEET-MAINTENANCE`.
