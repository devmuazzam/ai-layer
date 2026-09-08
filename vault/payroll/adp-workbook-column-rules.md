---
title: PAYROLL for ADP workbook — column rules
source: derived from onedrive/OneDrive_1_8-11-2026/ (workbook structure + SOP v3.8), MCOG L12 MLA, and legacy-payroll-app-db-extract
migrated: 2026-08-19
updated: 2026-09-08
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, adp, boom, craft-modifier, subsistence]
entities: [craft-code, craft-modifier, pay-component, adp-code]
---

# PAYROLL for ADP workbook — column rules

What every column in the weekly `PAYROLL for ADP` workbook means, which rule governs it, and how it
reaches ADP. **No employee data appears here** — the workbooks themselves are excluded from the vault
under the redaction rule ([source-manifest.md](source-manifest.md)); this is the specification they
implement.

## The thing to understand first

**The workbook does not calculate.** SOP v3.8 §6.1: *"First type in total number of hours in the*
***Total Hrs*** *field"* … *"Then type in the total number of boom hours for that day."*

`Total Hrs`, `ST`, `OT`, `DT`, `H2x`, `H3x`, `LB Total` and all four `LB` buckets are **hand-keyed**.
The only formulas are lookups (craft rate, modifier rate, employee master) and two internal sum-checks.
Everything below is what *should* govern those numbers — **none of it is enforced by the sheet.**

## The multiplier ladder

`ST` / `OT` / `DT` are not "first 8 / next 4 / rest". They are **rate buckets**: ST = ×1.0 hours,
OT = ×1.5, DT = ≥×2.0. Each 30-minute slice takes the **single highest** multiplier that applies —
the L12 agreement forbids pyramiding.

```
Holiday ×3 → Sunday ×2 → Special Saturday ×2 → >12 h ×2
  → weekday outside 06:00–17:00 ×1.5 → >8 h ×1.5 → Saturday ×1.5 → else ×1.0
```

Two consequences that look like errors and are not:

- **Saturday can never show ST** — every slice is ×1.5, so a Saturday row is all OT (plus DT past 12 h).
- **Sunday can never show ST or OT** — every slice is ×2.0.
- A weekday shift worked entirely **outside 06:00–17:00** is all OT with **no ST at all**.

## Column by column

| Column | Origin | Rule |
| --- | --- | --- |
| `File #`, `Employee` | formula | from the employee master by sheet name |
| `Unit_Asset` | typed | free text. Intended for the unit/asset used; in practice used almost only for `NO WORK` — see [gaps](#open-questions) |
| `Date`, `Day` | formula | from the pay-period start; the week runs **Saturday → Friday** |
| `Total Hrs` | **typed** | hours worked that day; entry start rounds **down**, end **up**, to 30 min |
| `Hrs Match` | formula | ✓ only when `Total = ST+OT+DT+H2x+H3x`. **Checks nothing else** |
| `ST` | **typed** | ×1.0 — weekday, inside 06:00–17:00, within the first 8 cumulative hours |
| `OT` | **typed** | ×1.5 — hours 8→12, any slice outside 06:00–17:00, or all Saturday hours |
| `DT` | **typed** | ×2.0 — beyond 12 h, or all Sunday hours |
| `H2x` | **typed** | special Saturday (first Saturday of June and December) ×2 |
| `H3x` | **typed** | the 9 L12 holidays ×3 |
| `Lattice Oper` / `Lattice Oiler` | dropdown | see [lattice](#lattice) |
| `2nd Shift` / `3rd Shift` | dropdown | see [shift differential](#shift-differential) |
| `Craft Modifier` | dropdown | the 20-ft boom bracket for that day's crane; **changes per day** |
| `LB Total` | **typed** | boom-active hours = 0.5 × slices fully inside the ticket's boom window |
| `LB Match` | formula | ✓ only when `LB Total = LB ST+OT+DT+3X`. **Does not compare against `Total Hrs`** |
| `LB ST/OT/DT/3X` | **typed** | the boom hours split by which multiplier bucket they fell in |
| `LB ST Rate` | formula | `VLOOKUP(modifier) → BaseRateAdd`, ×1 |
| `LB OT Rate` | formula | same lookup **× 1.5** |
| `LB DT Rate` | formula | same lookup **× 2** |
| `LB 3X Rate` | formula | same lookup **× 3** |
| `Subsistence` | **typed** | flat $; see [subsistence](#subsistence) |
| `Sick Hrs` | **typed** | non-union only; not modelled in the payroll engine at all |
| `Holiday` | formula | auto-flags when the date matches the `Holidays` sheet |

Each `LB … Rate` is wrapped in `IF(N([LB <bucket>])=0,"",…)` so it blanks itself when that bucket is
empty. **The workbook pre-multiplies the adder; ADP does not.** Sending ADP a raw adder and expecting
it to apply the multiplier would underpay every OT and DT boom hour.

## Boom pay — the four conditions

All four must hold for a slice to earn boom pay:

1. the labor row carries a modifier code — `OP-BP-nn` (operator) or `OI-BP-nn` (oiler)
2. the row's craft is union (`L12…`) — a non-union craft counts boom *hours* but pays **$0**
3. the job ticket has a boom window — in practice `ArrivedJob → LeftJob`, rounded to 30 min
4. the slice lies **fully inside** that window

So **boom hours are a subset of worked hours**, and the contract says why:
*"Long boom pay **does not apply to travel and curfew hours** from yard to job or job to yard."*
(MLA Article IV). Travel, yard time, rigging and waiting are paid but not boom.

`LB ST` means "boom hours that fell in straight time", `LB OT` "boom hours that fell in overtime".
They re-slice the *same* hours by multiplier — they are never extra hours. Each bucket must be **≤**
its clock bucket: `LB ST ≤ ST`, `LB OT ≤ OT`, `LB DT ≤ DT`.

### The bracket ladder is a formula, not a table

MLA Article IV: *"Eighty (80) feet up to one hundred (100) feet … **$0.75 per hour**. Thereafter …
an **additional $0.75 per hour** … **for each additional twenty (20) feet**. … the **Oilers** …
shall receive **$0.25 per hour**."*

```
bracket n counts from 1 at 080–100 ft
Operator adder = n × $0.75          Oiler adder = n × $0.25
```

Verified against all 26 brackets / 52 codes in `CraftModRates`: the formula reproduces every one, and
the **operator adder is exactly 3× the oiler adder at every bracket**.

### The 4-hour long-boom minimum

MLA: *"a minimum guarantee of four (4) hours for each job worked with a long boom, **not to exceed
total time worked**."* The engine implements it as `LONG_BOOM_MIN_4` — the shortfall is paid **at the
adder only** (no base), at the multiplier of the boom slices.

## What is added *into* the rate vs *on top of* it

```
slice_pay = 0.5 h × ( Rate_Base + Rate_Shift + Rate_Boom ) × multiplier
                    └──────── added INTO the rate ────────┘
```

The MLA is explicit for boom: *"The additional rate added to the regular rate **shall be the base rate
when computing overtime pay**."*

| Component | Treatment |
| --- | --- |
| Craft modifier / boom | **into the rate** — grows with OT/DT/weekends |
| Shift differential $3 / $4 | **into the rate** |
| Foreman $3 · Military $10 | **into the rate** (stated as "added to the base rate") |
| Shift hours-add (+1.0 / +1.5 h) | **on top** — extra hours at (base + shift), **no boom** |
| Guarantees (daily min 4, boom min 4, holiday/special-Sat min 8) | **on top** — at base + shift, no boom; the boom minimum pays the adder *only* |
| Rest-period premium | **on top** — pays only the *increase* to a ×1.5 floor |
| Worked-through-lunch | **on top** — a deduct for a taken meal, an add at 2× for one worked through |
| Subsistence | **on top**, and **excluded from Final Gross** — payable but not wages |

## Subsistence

Driven by `(PAY:SUB_SHORT)` / `(PAY:SUB_LONG)` comment tokens in the source system.
**Short = $85 any day. Long = $85 Mon–Fri, $200 Sat/Sun** — the weekend is decided from the work
date, not the token. Flat dollars; `IncludedInFinalGross = 0`, `IncludedInPayableGross = 1`.

## Lattice

Flat hourly, and the **only group-gated premium in the agreement**: *"**$1.00 per hour** … for the
**operator** for lattice boom crane **for Group 6 and above** and **$0.50 per hour** … for the
**oiler** …"* — i.e. `L12-G6`, `L12-G7`, `L12-G8`, `L12-G9` only. Groups 1–5 and all apprentices
(struck as a percentage of Group 5) get nothing.

**Lattice is not long-boom pay.** Long boom is paid on boom *length* in 20-ft brackets at any group;
lattice is paid on boom *type* as a flat amount from G6 up. Whether they stack is unresolved.

The workbook carries two dropdown columns and eight ADP codes (`LPR/LPO/LPD/LPT`,
`LOR/LOO/LOD/LOT`, each = the base amount × 1 / 1.5 / 2 / 3). **The payroll application computes no
lattice at all** — no `LATT*` token, no branch, no code. The Excel dropdown is the entire mechanism.

## Shift differential

Driven by `(PAY:SHIFT_2)` / `(PAY:SHIFT_3)`. Does **two** things: adds $3/$4 into every slice's rate,
**and** grants extra paid hours — **+1.0 h** (shift 2) or **+1.5 h** (shift 3). ADP codes
`S2R/S2O/S2D/S2T` and `S3R/S3O/S3D/S3T`.

## How it reaches ADP

The close-out writes an ADP paydata CSV: **one summary row per employee, then one further row per
distinct boom rate.**

```
Co Code, Batch ID, File #, Reg Hours, O/T Hours, Hours 3 Code, Hours 3 Amount,
Temp Rate, Hours 4 Code, Hours 4 Amount, … , Earnings 3 Code, Earnings 3 Amount
```

| ADP code | Carries |
| --- | --- |
| `LBH` | `LB ST` hours, at the raw adder |
| `LBO` | `LB OT` hours, at adder × 1.5 |
| `LBD` | `LB DT` hours, at adder × 2 |
| `LBT` | `LB 3X` hours, at adder × 3 |

Boom lines group by **adder, not by date** — two days on the same bracket merge into one row.

The engine computes boom *into* the rate; ADP receives it split in two. The two are identical:

```
(base + adder) × mult × hrs  ≡  base × mult × hrs  +  adder × mult × hrs
└──────── the engine ───────┘    └── Reg/OT/DT ──┘   └── LBH/LBO/LBD ──┘
```

## v5.1 additions — 2026-09-08

Three columns joined the employee sheet in v5.1: **`BASE RATE OVERRIDE`** (a dollar rate that sends the
row's base hours to ADP on their own row — purpose unstated, see [gaps.md](gaps.md)), and the
**`Foreman`** and **`Military`** dropdowns, which map to `FRR–FRT` ($3 × 1/1.5/2/3) and `MLR–MLT`
($10 × 1/1.5/2/3) temp-rate rows. Sheets also carry extra rows for a second craft modifier on the same
day, and a read-only block of the legacy app's recommended figures under the typed row. The first
bullet below is now half-answered: foreman and military have a route; **rest premium and WTL still do
not** — the app computes both as dollars marked `SQL_READY_ADP_PENDING`. Detail:
[adp-workbook-v5.1-engine.md](adp-workbook-v5.1-engine.md).

## Open questions {#open-questions}

Raised by reading a real week against these rules. All are **observations about the process**, not
about any individual.

- **Rest premium and worked-through-lunch have no column in the workbook and no ADP earning code.**
  Together with the guarantee top-ups, **three of the engine's eleven pay rules have no route into
  payroll through this file.** Anything they would produce is either absorbed into a hand-typed
  hours figure or not paid.
- **Weekday DT below 12 hours appears frequently**, in 0.5 h and 1.0 h steps. The ladder cannot
  produce it. The shape matches a skipped 30-minute meal paid at 2× being folded into `DT` because
  there is nowhere else to put it. **Inferred, not verified.**
- **$200 long-subsistence is being paid on weekdays**, which contradicts
  `SUBSISTENCE_LONG_WEEKDAY_85` in the application. Either the rule or the practice is wrong.
- **Boom hours may be post-guarantee, not actual.** No row observed falls below 4 boom hours, and
  exact `4.0` repeats. If the clerk keys the figure after `LONG_BOOM_MIN_4`, actual boom time is not
  recorded anywhere.
- **Which fiscal-year rate applies is a human decision.** Both FY columns sit on every tab, neither
  is marked active, and nothing records which was used.
- **`Unit_Asset` records no crane on a worked day.** So the craft modifier cannot be validated
  against the machine actually dispatched.
- **`LB Match` does not compare boom hours to worked hours**, so `LB Total > Total Hrs` — impossible
  in reality — would pass silently.
- **`HDR` (Heavy Duty Repairman) gets $0 boom pay** because the engine tests `CraftCode LIKE 'L12%'`
  and `HDR-A` does not match — while the MLA says *"Long Boom pay applicable"* for that
  classification. This is the single failing check in the client's own regression suite.

## Sources

Workbook structure and formulas: the weekly `PAYROLL for ADP` workbook and its master template
(see [sources/](sources/INDEX.md)). Operating procedure: [adp-sop-v3.8.md](adp-sop-v3.8.md).
Contract: [mcog-l12-mla-2025-2028/](mcog-l12-mla-2025-2028/INDEX.md) Article IV.
Engine behaviour: [legacy-payroll-app-db-extract/rules-plain-language.md](legacy-payroll-app-db-extract/rules-plain-language.md)
§1–§14. ADP codes: [adp-hour-earning-codes.md](adp-hour-earning-codes.md),
[adp-bucket-crosswalk.md](adp-bucket-crosswalk.md).

- **The workbook's VBA** (sheet-per-employee builder and the ADP CSV exporter) is read in [adp-workbook-vba-macros.md](adp-workbook-vba-macros.md), 2026-09-04.
- **The Power Query engine** that turns these columns into ADP rows — component codes, temp-rate table, slot map, validation — is in [adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md), 2026-09-04. It confirms the 52-row `CraftModRates` table and adds the lattice/shift temp-rate values.
