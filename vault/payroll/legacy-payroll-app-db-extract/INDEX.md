---
title: Legacy Payroll App - the full database extract (how pay is actually calculated)
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (read-only extract of TCG_PayrollAPP, 2026-08-18) + projects.rar (tcg-payroll-api, tcg-payroll-ui) + 4 ADP Workforce Now screenshots (2026-08-18)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, pricing, payroll-rules, boom, craft-modifier, shift-differential, guaranteed-hours, rest-period, wtl, subsistence, overtime, adp]
entities: [pricing-engine, pay-component, craft-modifier, guaranteed-hours, rest-period, wtl, subsistence, payroll-group, adp-file-number, nightly-run]
part_of: payroll/INDEX.md
---

# Legacy Payroll App — the full database extract

> **Superseded in part on 2026-09-07.** Brian's 2026-09-07 backup was restored and diffed against
> this extract: the rule procedures are unchanged, but 16 objects were added and 16 changed around
> them (rest-slice DT buckets, non-union bucket source, salary exclusion, strict labor times,
> whole-week recalculation). For those objects read
> [../legacy-payroll-app-db-backup-2026-09-07/INDEX.md](../legacy-payroll-app-db-backup-2026-09-07/INDEX.md)
> first; every other line anchor here still holds.

**What this is.** On 2026-08-18 the AI tool on the client machine ran the extraction prompt
against the live legacy database `TCG_PayrollAPP` (`localhost\SQLEXPRESS`, SQL Server 2025
Express) and returned `PAYROLL_CALC_EXTRACT.zip`: **all 141 programmable object definitions
verbatim** (61 procs, 67 views, 10 TVFs, 3 functions), DDL for all 38 tables, every `cfg.*` /
`dim.*` row, distinct code values, the source-feed shape, live regression results, and 13 real
labor entries traced end to end. It was produced read-only; nothing that writes was executed.

**Why it matters.** Until now the pricing logic was in "the SQL we don't have"
([../legacy-payroll-app-code-extract.md](../legacy-payroll-app-code-extract.md) §caveat;
[../payroll-app-current-state/INDEX.md](../payroll-app-current-state/INDEX.md) "ranks 1–2 are
unreachable"). Both caveats are now closed: this folder *is* rank 1 and 2 of the knowledge
pack's own source-of-truth order. **Where this folder and any older payroll-app document
disagree, this folder wins** — it is the code.

The readable renderings: the artifact *TCG Payroll Engine*
(https://claude.ai/code/artifact/74b7f0dc-34b4-4415-9839-0281ea3d7878) and its plain-language companion
*TCG Pay Rules, One at a Time* (https://claude.ai/code/artifact/1a754dab-82d4-4736-b23c-d51593c34c6c) — the
latter is [rules-plain-language.md](rules-plain-language.md) rendered.

## Files

| File | Answers |
| --- | --- |
| [rules-plain-language.md](rules-plain-language.md) | **Start here if you are not reading SQL** — who is who (union / non-union, payroll groups, L12 wage groups, apprentice steps, boom brackets) and then every rule separately: when it applies, how, the formula, one number, where in code |
| [calculations.md](calculations.md) | **How every rule is computed**, B1–B12, with verbatim SQL and `sql/…:line` anchors. The primary document |
| [open-questions.md](open-questions.md) | The 11 direct answers: boom length, minimums, shift/rest/CA values, base-rate sources, foreman/military/lattice/hazmat, ADP, week/day, tests |
| [worked-examples.md](worked-examples.md) | 13 real masked entries: plain day, boom actual, boom-window-no-modifier, boom minimum, rest forced/overlap, WTL, subsistence, Sat/Sun/holiday/special-Sat, CA non-union, missing rate, cross-midnight, shift 2 |
| [config-values.md](config-values.md) | **Every rule row**: `cfg.Union_Master_Rules`, `Union_Shift_Rules`, `GuaranteedHoursRule`, `RestPeriod_Rule`, `WTL_Rule`, `WTL_MaxMealThreshold`, `Craft_MinimumPayPolicy`, `CrossMidnightDayTypePolicy`, `LaborType_TicketPolicy`, `Nightly_RunSettings`, `dim.LU12_Holiday` |
| [outputs.md](outputs.md) | The 15 API endpoints (JSON only, no file), the 13 `rpt.*` views, and the ADP hand-off search (nothing on the machine) |
| [data/craft-modifiers-and-boom-status.md](data/craft-modifiers-and-boom-status.md) | The 33 boom-bracket modifier codes and their $/h adders; craft codes; rate sources; the boom display statuses; exception templates |
| [data/distinct-codes.md](data/distinct-codes.md) | Every pay-component code with lifetime rows/hours/$; every exception reason; guarantee/rest/ticket values |
| [data/source-feed.md](data/source-feed.md) | The 40 `src.*` synonyms into `TCG_RawFMS`: columns, row counts, masked samples |
| [data/test-results.md](data/test-results.md), [data/test-case-core-payroll-scenario.md](data/test-case-core-payroll-scenario.md) | Live regression results and the fixture table |
| [sql-object-index.md](sql-object-index.md), [sql/](sql/), [ddl/](ddl/) | One row per object; the definitions themselves; the table DDL |
| [sql-agent-jobs.md](sql-agent-jobs.md) | Express edition — no usable Agent, one system job |
| [extract-readme.md](extract-readme.md) | The extract's own README (counts, what was skipped) |

## The calculation in one paragraph

Raw NexGen labor rows are re-anchored to `WorkDate` (time-of-day only; end &lt; start ⇒ next
day), rounded start-down / end-up to 30 minutes, chained when &lt; 8 h apart
(`app.usp_Prepare_Continuous_Labor`). Ticket boom windows come from
`ArrivedJob→LeftJob` in practice (`calc.TicketTimeline`). `app.usp_Run_Pricing_Engine` cuts each
entry into 30-minute slices and prices each as

```
slice_pay = 0.5 h × (Rate_Base + Rate_Shift + [boom-active ? Rate_Boom : 0]) × Final_Multiplier
```

`Rate_Base` = `FMS_UNION_CRAFT.PayRate` by the *labor row's* craft when `L12%`, else the raw
source rate (non-union admin = `Employee.PayRate`); `Rate_Shift` = +3.00 / +4.00 for shift 2 / 3
from a comment token; `Rate_Boom` = `FMS_UNION_CRAFT_MODIFIER.PayRateChange` for the craft-modifier
code (a 20-ft boom-length bracket, operator 0.75…13.50, oiler 0.25…3.75), only inside the ticket
boom window and only for `L12%` crafts. `Final_Multiplier` = Holiday ×3 → Sunday ×2 → Special
Saturday ×2 → &gt;12 h ×2 → weekday outside 06:00–17:00 ×1.5 → &gt;8 h ×1.5 → Saturday ×1.5 → 1.0.
**Shift and boom adders are therefore multiplied by the day/OT/DT multiplier.** Then
`app.usp_FinalizePayrollOutputs_AfterPricing` runs twelve post-processors in fixed order: base-pay
fallback → guaranteed hours → rest premium → suppress-missing-rate → CA non-union OT → ledger
rebuild → CA ledger → shift-hours add → WTL → reconciliation → subsistence → rounding. Every dollar
ends up as a named line in `fms.Payroll_PayComponent`.

## Rule values in force (2026-08-18)

| Rule | Value | Read live or hard-coded |
| --- | --- | --- |
| L12 standard day / ST / DT threshold | 06:00–17:00 · 8 h · 12 h | read (`cfg.Union_Master_Rules`) |
| OT / DT / Sat / Sun / Holiday | ×1.5 / ×2.0 / ×1.5 / ×2.0 / ×3.0 | read; Special Saturday = June/Dec first Saturday (day ≤ 7) ×2, computed in-engine |
| Shift 2 / 3 rate add | +$3.00 / +$4.00 per h | read (`cfg.Union_Shift_Rules`) |
| Shift 2 / 3 hours add | +1.0 h / +1.5 h paid at (base+shift) × last-slice multiplier, no boom | **hard-coded** in `usp_Apply_ShiftDifferentialHoursAdd` |
| Guarantees | DAILY_MIN_4 = 4 h ×1; HOLIDAY_MIN_8 = 8 h ×3; LONG_BOOM_MIN_4 = 4 boom-h (capped at shift length) at boom adder × boom-slice multiplier; SPECIAL_SAT_MIN_8 = 8 h ×2 | **hard-coded**; table read only for `IsEnabled` and `BoomNoModifierTreatment = EXCLUDE_NO_MODIFIER`; `ADMIN-*` crafts exempt via `cfg.Craft_MinimumPayPolicy` |
| Rest period | 8 h required off; forced when the previous chain (≤ 30 min stitch) had OT/DT and the gap &lt; 8 h; forced slices floored to ×1.5 (×2 past 12 h); only the delta is paid | read (`cfg.RestPeriod_Rule`, `PunitiveUntil8Off`) |
| WTL | 0.5 h meals; expected count by shift span 0.5–5.0→0, 5.5–10.5→1, 11–16→2, 16.5–21.5→3, 22–27→4; opportunities at 5.0/10.5/16.0/21.5 h; token `(PAY:WTL_n)` = meals worked through; no token ⇒ 0 (warning); taken meal = −full priced slice (incl. boom); worked-through = 0.5 h × (base+shift) × 2.0 (`WTL_APPLICABLE_ADD`) or × (2.0 − mult) on weekday ST-start blocks (`WTL_DT_FLOOR`) | read (`cfg.WTL_Rule`, `cfg.WTL_MaxMealThreshold`); `app.LaborBreakOverride` **not** read |
| Subsistence | SUB_SHORT $85 any day; SUB_LONG $85 weekday / $200 Sat–Sun; payable-only (`IncludedInFinalGross = 0`) | **hard-coded** in `usp_Apply_SubsistencePay` |
| CA non-union admin hourly | daily ≤8 ST, &gt;8–12 OT ×1.5, &gt;12 DT ×2; weekly &gt;40 ST → OT ×1.5 (Sat–Fri week, from latest ST hours); 7th consecutive day: first 8 h OT, &gt;8 h DT; rate `Employee.PayRate`; every union field zeroed | **hard-coded** in `usp_Apply_CA_NonUnionAdminHourly_OT`; group = `CraftCode LIKE 'ADMIN%' AND PayType='H'` |
| Base-rate fallback / suppress | `Source_Rate_Raw × (ST + 1.5·OT + 2·DT)` when priced hours but $0; all pay → 0 when no source rate | — |
| Nightly window | 210 days ending yesterday | read (`cfg.Nightly_RunSettings`) |
| Buckets | `Hrs_ST` = ×1.0 slices, `Hrs_OT` = ×1.5, `Hrs_DT` = ≥ ×2.0 — Sunday, Special Sat, Holiday all report as DT; the UI splits H2x/H3x | — |

## Findings that change what we knew

1. **The boom formula is a bracket adder × multiplier, nothing more.** No feet arithmetic, no
   jib, no lattice branch, no operator/oiler branch (only the adder differs), no travel/curfew
   exclusion. `LONG_BOOM_MIN_4` really is 4 boom hours.
2. **Non-`L12%` crafts with a modifier (e.g. `HDR-A` + `OP-BP-07`) accrue boom hours but $0 boom
   premium** — the one failing regression check (2 of 9 in `test.usp_Run_BoomBreakdown_Tests`).
3. **Guarantee minimums, shift hours-add, subsistence dollars and all CA thresholds are literals
   in procedure bodies.** Editing `cfg.GuaranteedHoursRule` or `cfg.Union_Shift_Rules` values
   would change nothing.
4. **The UI's "Refresh from NexGen" is a full 210-day recalc**, not the selected week; blocked
   when the period is Processed. Raw pull is a cross-DB `EXEC TCG_RawFMS.etl.usp_RunNightly_RawFMS`
   — no linked server, SSIS or Agent job.
5. **No scheduler in the database.** Express edition; the nightly must be triggered externally.
   Not inspected on the machine.
6. **The snapshot (`app.usp_ProcessPayroll_PayPeriod`) freezes the calc row, not the ledger.**
   `POST /payroll/process` exists in the API but no UI button calls it.
7. **`Hrs_DT` is overloaded** (Sunday/Special-Sat/Holiday); H2x/H3x are UI-only concepts.
8. **Boom windows always fall back**: `StartWorkTime/EndWorkTime` unused in practice — every one
   of 28,799 tickets uses `ArrivedJob→LeftJob`.
9. **Labor craft wins over employee craft** for rates (27% of rows disagree; mismatch is a flag).
10. **Rest premium and WTL have no home on the ADP worksheets** (see below).

## The ADP hand-off, as observed (screenshots, 2026-08-18)

ADP Workforce Now, company **4RZ**, *Manage Regular Payroll · Weekly #31*, period 07/18–07/24,
pay date 07/30/2026 — three worksheets, all keyed by ADP File #:

| Worksheet | Source | People | Columns |
| --- | --- | ---: | --- |
| ROLL · Field Roll | Manual Entry | 85 | Reg Hours · OT Hours · DT Hours · Holiday 2x Hours · Holiday 3x Hours · Shift Diff 2 (code, amount) · Shift Diff 3 (code, amount) · **Temporary Rate · LB REG · LB OT · LB DBL · LB TRI** · SUB PAY · Sick · P.T.O. · Other Earnings-OT |
| SALARY | Manual Entry | 29 | Other Earnings · Commission · Tax Frequency · Temporary Rate · P.T.O. · Substpay · On Call NT · Reg Hours · Sick · Bereavement · O/T Hours · Double Time · Reg Earnings · O/T Earnings |
| PTO001 · Time Off | Paid Time Off | 25 | PTO Hours · SIC Hours 3 · Memo SHA · Memo PHA |

Shape: one row per employee with the hour buckets, then **one extra row per distinct boom
adder** with `Temporary Rate` = the $/h adder and boom hours in `LB REG / LB OT / LB DBL / LB TRI`
by multiplier. File 000480's five temporary rates (0.25 / 1.00 / 1.25 / 1.50 / 1.75) are exactly
the oiler brackets `OI-BP-01/04/05/06/07`, and ADP multiplies the temp rate by 1 / 1.5 / 2 / 3 —
consistent with the engine's adder-×-multiplier design. Batch "Total Gross Pay" for ROLL
($4,438.85) equals the SUB PAY column total; hour columns are priced by ADP from the rate on file.
**"Manual Entry"** confirms the numbers are re-keyed or imported outside the application (the
Excel path in [../adp-sop-v3.8.md](../adp-sop-v3.8.md)).

## Confirmed absent from the code and database

Foreman premium · Military base / Davis-Bacon / prevailing wage · Lattice boom (no `LATT*` token)
· Hazardous material · boom-length arithmetic / jib / travel / curfew · any file export, ADP
paydata, linked server or Agent job · comment tokens other than
`SHIFT_2, SHIFT_3, SUB_SHORT, SUB_LONG, WTL_0..4, WTL`. Full-text search over all 141
definitions and every config row.

## Still open after this extract

- ~~Where the nightly is scheduled on the client machine (Task Scheduler not inspected).~~ **Answered by the client (2026-08-24 batch): Windows Task Scheduler on Brian's work desktop** — Express has no Agent, so the refresh/nightly procedures are OS-scheduled there.
- Where the ADP paydata workbook lives (not on the machine; the SOP describes it).
- `test.usp_RunAll_PricingEngine_Tests` was not run (its children execute the engine, a write).
- How rest premium and WTL reach ADP — no column on the observed worksheets.

## Where this changes existing vault documents

> **Cross-check, 2026-09-04.** The client's 2026-06-23 full backup of this database (in the
> SharePoint drop) was restored and every one of the 141 definitions compared with [sql/](sql/):
> **all identical**, same 38 tables, same 40 synonyms. The extract stands. What the backup adds —
> pay-period state, the nightly run log, the *Refresh from NexGen* history — is in
> [../legacy-payroll-app-db-backup-2026-06-23.md](../legacy-payroll-app-db-backup-2026-06-23.md);
> the `TCG_RawFMS` side of the feed is in
> [../tcg-rawfms-staging-database/INDEX.md](../tcg-rawfms-staging-database/INDEX.md).

- [../legacy-payroll-app-code-extract.md](../legacy-payroll-app-code-extract.md) — its "SQL not
  in this repo" caveat and "WTL thresholds unknown" note are superseded (banner added there).
- [../payroll-app-current-state/](../payroll-app-current-state/INDEX.md) — ranks 1–2 of its own
  source-of-truth order are now reachable here; the "Potential components" in 03 and the
  "Confirm" cells for L12 Mechanic in 04 have current-behaviour answers (banners added).
- [../gaps.md](../gaps.md) — legacy-behaviour notes appended to: rule applicability, WTL 16.5 vs
  16:01, lattice, foreman/military, premium stacking, non-union pay rates, Excel-or-API.
- [../adp-bucket-crosswalk.md](../adp-bucket-crosswalk.md) — the observed WFN worksheet columns
  (LB REG/OT/DBL/TRI with Temporary Rate) are the on-screen form of its "Hours 3/4 Code + Temp
  Rate" rows; no conflict, cross-reference added.

---

> **Client validity statement (2026-08-24 batch):** Brian — *"I haven't made many changes since
> that backup"* (the 2026-06-23 backup this extract was built from). The extract remains ≈
> as-built current per the client's own word; residual deltas are UI-display fixes, not logic.
