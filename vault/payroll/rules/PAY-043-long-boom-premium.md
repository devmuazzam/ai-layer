---
id: PAY-043
title: PAY-043 — Long-boom premium
section: E-guarantees-special-pay
status: open
updated: 2026-09-07
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-043 — Long-boom premium

**Rule:** Apply tiered premium and qualifying minimum.

**Applies to:** Eligible operators/oilers. **Trigger:** Qualifying boom length is used.
**Requires:** Boom length; crane type; classification; time window.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-043` — baseline: *Partial baseline*
- **FRD** (target design): [06-boom-equipment-and-guaranteed-hours.md](../erp-payroll-module-frd/06-boom-equipment-and-guaranteed-hours.md) `PR-026` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §5
- **Contract**: [02-article-iv-classifications-and-wage-rates.md](../mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md)
- **Test cases**: [rule-examples-catalog.md](../rule-examples-catalog.md) — long-boom rows

## Open

- **Blocking (matrix):** Confirm equipment source data
- **Conflict:** Into-the-rate vs on-top (see PAY-011); boom-length arithmetic not in the legacy engine.
- **Open contract doubt from the client's own message:** *"I don't think there is triple time for long boom mentioned in the labor union contract. I'll have to ask Corrina."* — never resolved in the thread. Yet the crosswalk implements **LBT (boom triple, Temp Rate = 3× premium) as CURRENT**, and the ADP sheet has an LB TRI column. Note: under the MLA's *into-the-rate* clause (boom adder "shall be the base rate when computing overtime"), holiday ×3 would naturally produce boom-at-3× — so LB TRI's legitimacy rides on the PAY-011 into-rate adjudication. Ask: did Corrina ever answer?
- **Nuance vs the client's blanket "as if actually worked":** the long-boom gap pays the **boom adder only** (not base + adder) at the boom slices' multiplier — the base hours were already paid; the guarantee tops up boom alone. His doctrine simplifies here; the engine's version is the precise one.
- **LB triple operationalized (July):** TCG **added the "long boom holiday (triple time)" code** (`LBT`) to ADP — after Brian's message doubting the contract supports it. Practice has now committed; the open ask flips from "does it exist?" to "**show the contract basis / Corrina's confirmation that motivated adding it**" — which also feeds the into-the-rate adjudication (PAY-011).
- **Time-scope contrast now explicit:** long-boom premium = **boom-window slices**; lattice premium (PAY-044) = **the entire job** (Corrina, message 20). Different scopes, and they stack — the ERP must not share one eligibility window between them.
- **Contract basis for LB TRI located:** the MLA's into-the-rate clause (boom adder becomes base when computing overtime — quoted verbatim in the attribution register) makes holiday ×3 apply to base+boom, so `LBT` is contract-derivable; the July code addition operationalized it. Question closed; the composition decision note will cite this.
- **Boom-window scope corroborated by Corrina in a worked example, 2026-09-04:** both of her
  hand-worked long-boom days mark **(Long boom pay)** on the `build up, work, breakdown` segment
  only, never on the drive segments either side of it — including the drive *of the long-boom crane
  itself*. Direct confirmation of the `ArrivedJob → LeftJob` window, and it sharpens the contrast
  with PAY-044 (lattice = the entire job) she drew in message 20. Also note her two-job example
  carries **two separate boom windows in one shift** (`8am-5:30pm` and `7:30-11:30pm`), which the
  engine handles per labor row — but the **4-hour long-boom minimum groups per `ShiftAnchorDate`,
  not per job** (§5), so a two-job day gets one minimum, not two. Both windows exceed 4 hours in
  her example so it never fires; unasked and unrecorded for the case where one of them does.
  Source: [client-message-findings.md](../client-message-findings.md#2026-09-04--long-boom-day-breakdowns-drive-time-included-corrina-bustos-teams).
- **Boom window, Operations' words (2026-09-03 call, Kyle Harlow 45:31–46:02; Corrina Bustos
  45:32 confirms current practice):** boom pay runs **from build-up through breakdown, including all
  hook work**; travel and meeting the customer / walking the job before the machine is set are not
  boom time. A crane already built on arrival is a **holdover** (tower-crane jobs always are) and
  has no build-up. **Multi-job day (Corrina 59:07):** the ST/OT/DT bucket a boom hour falls into is
  decided against the **whole day's work**, not the boom job alone — her worked examples are the
  2026-09-04 breakdowns in `client-message-findings.md`. Decision note [../../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md).
- **On a holiday (e.g. Labor Day 2026-09-07, in `dim.LU12_Holiday`):** every boom-window slice is
  H3x, and the adder is paid × 3 on each of them — Brian's engine, the ADP workbook's `LB 3X Rate`,
  Corrina 2026-06-11 55:25, and `calculate.ts:157` all agree (see PAY-011's 2026-09-07 bullet). The
  window is unchanged: build-up through breakdown incl. hook work, travel excluded. The 8-hour
  holiday minimum's gap hours carry **no** boom (§7 of the legacy rules); the 4-hour long-boom
  minimum still applies but never exceeds time worked. Contract note: *"No work shall be performed on
  Labor Day, except in cases of extreme urgency"* (Art. III Holidays §3) — a Labor Day ticket is
  itself an exception case.
- **The four-hour minimum's gap hours — how the legacy engine buckets them (verified 2026-09-08).**
  The rule pays the shortfall "at the multiplier of the boom slices", which only discriminates when
  boom work straddles two buckets. `app.usp_Apply_GuaranteedHours` sets
  `BoomMultiplierUsed = MAX(Final_Multiplier)` across slices carrying a modifier and a non-zero boom
  rate (l.283–291, 310), and the guarantee row takes `MAX(BoomMultiplierUsed)` (l.426–427): **the
  highest multiplier on any boom-paid slice prices the whole gap.** The 2026-09-07 backup's
  `api.usp_Excel_PayrollRecommendations` then buckets the gap hours by that multiplier
  (1.00 → `Guaranteed_LB_ST_Hours`, 1.50 → `_LB_OT_`, 2.00 → `_LB_DT_`, 3.00 → `_LB_3X_`, l.1331–1360)
  and **adds them to the actual LB hours** in the same column (l.1701–1720). Worked: 1 h ST + 1 h OT
  of boom on an 80–100 ft operator bracket → gap 2 h at adder × 1.5 → sheet shows LB ST 1.0,
  LB OT 3.0, LB Total 4.0. The legacy worked example (entry 81827) is single-bucket and does not
  discriminate, so this is read from the code, not from an exhibit. **Client has never confirmed it**;
  build it as the default and flip on a decision note.
- **Special-Saturday boom hours have no ADP slot of their own.** A special Saturday (June/December,
  PAY-034) pays ×2 and is a distinct day type from DT, so boom on one is "Long boom H2X" at adder × 2 —
  but ADP's long-boom family is only `LBH`/`LBO`/`LBD`/`LBT`. The live v5.1 workbook has **no LB 2X
  column**, and every premium family collapses `DT + H2x` into one bucket
  ([adp-workbook-power-query-engine.md](../adp-workbook-power-query-engine.md) §3), so these hours are
  keyed into LB DT and export as **`LBD` at adder × 2** — identical money. If our review sheet keeps a
  separate LB 2X column, it maps to `LBD` on export. Practice, not a decision; blocks nothing while
  PAY-067 is unbuilt.
- **ERP status, verified in code 2026-09-08 — the built boom window is WIDER than the decision.**
  `PayrollService.buildJobDay` sets the engine's boom window to the **payable window**, Start Work →
  Review & Complete (`apps/api/src/usecase/payroll/payroll.service.ts:657-658`), and
  `priceL12JobDay` gives the boom adder to **every slice in it** when a bracket resolves
  (`packages/payroll-engine/src/calculate.ts:107`). The `BUILDUP_TIME`, `BOOM_TIME` and
  `BREAKDOWN_TIME` captures the field app records are **never read by payroll** — `deriveTicketTimes`
  surfaces breakdown windows for the ticket views only. So the ERP currently pays boom across travel
  inside the paid shift, which the MLA excludes (*"Long boom pay does not apply to travel and curfew
  hours from yard to job or job to yard"*) and which the verified 2026-09-03 decision excludes.
  **Fix:** bound the boom slices to first `BUILDUP_TIME` start → last `BREAKDOWN_TIME` end, falling
  back to the `BOOM_TIME` sessions. Registered in [../gaps.md](../gaps.md) → *Boom window as built*.
- **The four-hour minimum is not built in the ERP at all.** `guarantee.ts` implements PAY-040 (daily
  minimum) only; nothing adds a boom shortfall. Spec for whoever builds it:
  `gap = min(4, shift hours) − boom hours`, priced at adder × the highest boom-slice multiplier,
  bucketed to that LB column, pinned to the last boom-paid entry of the shift.

