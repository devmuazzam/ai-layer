---
title: Legacy Payroll App - rules extracted from the actual source code
source: user-supplied/projects.rar (tcg-payroll-api Program.cs 2296 lines + tcg-payroll-ui Next.js app, files dated Feb-Jul 2026)
migrated: 2026-08-13
updated: 2026-08-13
status: reference
conflicts_with: []
jira: []
topics: [payroll, legacy-payroll-app, payroll-rule, adp-integration, craft-code, wtl, guaranteed-hours, rest-period, subsistence]
entities: [payroll-rule, pay-component, craft-code, adp-file-number, payroll-group, guaranteed-hours, wtl, subsistence, shift-differential]
part_of: payroll/INDEX.md
---

# Legacy Payroll App — what the source code actually implements

**What this is:** rules extracted from the legacy Payroll App's real source, supplied by the
client 2026-08-13 as `projects.rar`. Two projects: `tcg-payroll-api` (single-file .NET 9 minimal
API, `Program.cs`, 2,296 lines) and `tcg-payroll-ui` (Next.js 15). This is more recent than the
Jun-2026 knowledge pack in [payroll-app-current-state/](payroll-app-current-state/INDEX.md)
(files dated through **Jul 21, 2026**) and it is *code*, not a description of code.

**One caveat that bounds everything here:** the calculation engine itself is SQL Server —
`api.tvf_*` functions and `usp_*` procedures — and **the SQL is not in this repo**. The archive
holds the API layer (which names every rule's inputs and outputs) and the UI (which names every
rule's presentation). Rule *shapes* below are code-verified; numeric *thresholds* mostly live in
the missing SQL and stay unverified except where noted.

---

## 1. The ADP footprint of the entire legacy system is one field

Searched both projects: the only ADP surface is **`ADP_FileNumber`** — stored via a generic
external-identifier procedure (`api.usp_UI_SaveEmployeeExternalIdentifier` with
`ExternalSystemCode`), displayed on the worklist with `Missing` / `Invalid` / `Review` flags,
editable only by roles `payrollmanager` and `itadmin`.

**There is no ADP export code anywhere.** No pay-data POST, no EPIP/CSV writer, no API client.
The app computes and displays; the Excel/Power Query/VBA process in
[adp-sop-v3.8.md](adp-sop-v3.8.md) is the *only* bridge to ADP. "The system being replaced never
talked to ADP" is now a code-verified fact, not an inference.

### The File Number validation bug, root cause found

`tcg-payroll-ui/app/worklist/page.tsx` (`validateAdpFileNumber`):

```ts
if (!adpFileNumber) return "ADP File Number is required.";
if (adpFileNumber.length > 6) return "ADP File Number must be 1 to 6 characters.";
if (!/^[0-9A-Z]+$/.test(adpFileNumber))
  return "ADP File Number must contain only uppercase letters and numbers.";
```

**Uppercase letters and numbers, 1–6 chars.** This is where the crosswalk's "uppercase
alphanumeric" claim came from — it describes the legacy app, not ADP. The live ADP worker schema
([adp-api-responses/workers-meta.md](adp-api-responses/workers-meta.md)) requires
`^0*(5[1-9]|[6-9][0-9]|[1-9][0-9]{2,5})$` — **digits only, minimum value 51**. The legacy app
accepts `AB123` and `7`; ADP rejects both. The ERP must validate with ADP's regex, and any
migrated File Numbers containing letters are bad data.

---

## 2. Rule applicability by payroll group — answered, in code, for current behaviour

The vault's "biggest unknown" has a concrete answer for what the system *does today*. The
week-detail query builds a non-union branch (`NonUnionLaborBuckets`) that, when an entry belongs
to a non-union employee, **forces every union-rule column to 0.00**:

```sql
NU_Rule_Hrs_Gap      = ... ELSE CONVERT(decimal(10,2), 0.00) END,
NU_Rule_Hrs_ShiftAdd = ... 0.00, NU_Rule_Hrs_WTL_Net = ... 0.00,
NU_Rest_Premium_Hrs_Affected = ... 0.00, NU_Bucket_Hrs_H2x = ... 0.00, H3x = ... 0.00
```

| Rule family | Union (L12) entries | Non-union CA non-exempt entries |
| --- | --- | --- |
| ST/OT/DT buckets | ✓ | ✓ (own component set below) |
| Holiday H2x/H3x | ✓ | **forced 0** |
| Guaranteed hours (gap) | ✓ | **forced 0** |
| Shift differential | ✓ | **forced 0** |
| Worked-through-lunch | ✓ | **forced 0** |
| Rest-period premium | ✓ | **forced 0** |
| Boom premium | ✓ | **forced 0** |
| Subsistence | ✓ | **forced 0** |

Non-union hourly staff get exactly six components — full California non-exempt bucketing
**including seventh-day rules**, computed ERP-side, not by ADP:

```
NONUNION_CA_NONEXEMPT_ST            NONUNION_CA_NONEXEMPT_WEEKLY_OT
NONUNION_CA_NONEXEMPT_DAILY_OT      NONUNION_CA_NONEXEMPT_7TH_DAY_OT
NONUNION_CA_NONEXEMPT_DAILY_DT      NONUNION_CA_NONEXEMPT_7TH_DAY_DT
```

This is *current behaviour*, not necessarily *correct policy* — the vault's warning ("do not
infer the answer from what the legacy system does; that is the thing being questioned") still
stands for the ERP design. But the question "what does the current system apply to whom" is
closed.

## 3. Rate resolution — a reconciliation engine, with ADP nowhere in it

Per labor entry the API exposes **three competing craft/rate sources**, cross-checked:

- `Employee_CraftCode` / `Employee_CraftBaseRate` — from the employee master
- `Labor_CraftCode` / `Labor_CraftPayRate` + `Labor_CraftModifierCode` /
  `Labor_CraftModifierPayRateAdjustment` — from the labor entry
- `CraftCodeFromTimeline` — from the reconstructed shift timeline

Resolved into `PayrollBaseRate` (+source) + `PayrollModifierRate` (+source) =
`PayrollCombinedRate`, then compared against the FMS/NexGen source rate:
`SourceRateLooksLikePayrollBase`, `SourceRateLooksLikePayrollCombined`,
`SourceRateDifferenceFromPayrollBase/Combined`, with human-review flags
`CraftCodeMismatchFlag` + message and `RateResolutionReviewFlag` + message.

Confirms two artifact claims at code level: **craft and rates live entirely in the legacy DB**
(ADP appears in zero rate fields), and **the double-count trap is real** — the system explicitly
tests whether the source rate already includes the modifier (`LooksLikePayrollCombined`) before
adding it again.

## 4. The rule engines, as implemented

**Guaranteed hours** (`api.usp_UI_Payroll_EmployeeWeek_Guarantees`, `GuaranteeGroup` /
`GuaranteeAllocation` types): each group carries `RuleCode`/`RuleName`, `ScopeBasis`,
`ActualQualifyingHours`, `MinimumHours`, `GapHours`, `MultiplierUsed`,
`TriggeredFlag`/`SatisfiedFlag`; gap hours are allocated to entries by
**`LastLaborEntryInShift`** or **`LastEligibleBoomEntryInShift`**, with pay-component basis
**`BaseShift`** or **`BoomOnly`**. So the FRD's "allocate to last entry of shift" is
code-verified — and there is a **boom-only guarantee variant** no design document mentions.

**Rest period** (`api.usp_UI_RestPeriod_SliceDetail`): per half-hour slice —
`NormalMultiplier`, `RestChainHoursBeforeSlice`, `RestMultiplier`,
`FinalEffectiveMultiplier`, `RestReason`, `RestPremiumDelta`, plus `Rest_IsForced`,
`Rest_Policy`, `Rest_Gap_Hrs_FromPrevChain`, `Rest_IsOverlap` at entry level. The slice-level
"prove the number" audit is real legacy behaviour, not an ERP invention.

**Boom**: `BoomEligible`, `Boom_Window_Start/End` vs `Act_BoomStart/End`,
`Slice_Boom_Hrs`, and three amounts — `Boom_Actual_Add_Amt`, `Boom_Gap_Add_Amt`,
`Boom_Total_Add_Amt`. Boom premium = additive rate on hours inside a boom window, and the
craft-modifier mechanism (`CraftModifierPayRateAdjustment`) is how it attaches.

**Shift differential — captured from free text.** `app.v_LaborPayroll_CommentTokens` parses FCC
labor comments into tokens `SHIFT_2`, `SHIFT_3`, `SUB_SHORT`, `SUB_LONG`, `WTL`, with
`Has_ConflictingShiftTokens` as an error path. Components: `ACTUAL_SHIFT_DIFFERENTIAL` (rate
add) and `SHIFT_2_HOURS_ADD`/`SHIFT_3_HOURS_ADD` (hours add). **Today, whether someone worked
second shift is determined by parsing a comment string.** The ERP capturing this structurally
in the mobile app removes an entire failure class.

**Subsistence — also comment-token-driven**, components `SUB_SHORT`, `SUB_LONG_WEEKDAY`,
`SUB_LONG_WEEKEND`, `ComponentGroup='SUBSISTENCE'`, and — important — carried as
**`PayableOnlyAmount`**: included in payable gross, excluded from labor gross.

**WTL**: `EntryExpectedMealCount` and `WTL_Token_MissedMeals` from the engine; **taken meals
produce `WTL_MEAL_DEDUCT` (time deducted), worked-through meals produce a paid add**;
`WTLAddAmount` and `WTLMealDeductAmount` tracked separately; `WTL_ErrorCount` +
`Has_ConflictingWTLTokens` error paths. Four meals modeled. **The threshold values are in the
SQL, not this repo — the 16.5 vs 16:01 conflict in [payroll/gaps.md](gaps.md) remains open.** (The
UI paints meal markers at a flat 5-hour cadence — `sliceIndex = mealNo * 10` — but that is
display placement, not the engine threshold.)

**Two grosses, reconciled.** Every entry resolves `LaborGross_BeforeWTL` → `WTLAdjustment` →
`LaborGross_AfterWTL` (labor gross), then `+ PayableOnlyAmount` (subsistence) →
`TotalPayableGross`. The component ledger ties out per entry: `LedgerTieOutStatus='Balanced'`
or a signed `LedgerTieOutDifference`. Every component row carries `ComponentCode`,
`ComponentGroup`, `SourceRuleCode`/`SourceRuleName`, `RateBaseUsed`/`RateShiftUsed`/
`RateBoomUsed`/`MultiplierUsed`, `IncludedInFinalGross`, `IncludedInPayableGross`, and a
free-text `Explanation`. The FRD's "every dollar is an explainable pay component" principle is
implemented, with reconciliation on top.

## 5. Data-quality engine — the issue codes

From `lib/payrollIssues.ts` (the UI's authoritative label table):

| Code | Meaning |
| --- | --- |
| `Warn_Overlap` / `RestPeriod_Overlap` | entry overlaps a previous entry for the same employee |
| `Warn_DuplicateWindow` | same employee/time window more than once |
| `Warn_Reconstruction_Possible24Plus` | reconstructed shift may exceed 24 hours |
| `Shift_Assumed` | labor times invalid/missing → fallback shift timing used |
| `Warn_Reconstruction_ShiftMismatch` | labor times disagree with reconstructed timeline |
| `RateBaseMissing` / `HasZeroRateBase` | payable entry with no usable / zero base rate |
| `RestPeriod_RateMissing` | rest premium required but no usable rate |
| `MissingExpectedJobTicket` / `UnexpectedJobTicketPresent` | ticket-expectation model by labor type |

Maps directly onto rule-matrix PR-028/PR-029 (duplicate/overlap detection) and adds the
reconstruction and ticket-expectation checks the matrix doesn't list.

## 6. Process model

- `api.usp_EnsurePayPeriod_ForDate(@AnyDateInWeek)` — periods are *ensured*, created on demand
  from any date; Saturday–Friday boundaries computed in SQL.
- `POST /payroll/refresh-from-nexgen` → `usp_UI_RefreshPayroll_FromNexGen` — full RawFMS refresh
  takes **~2.5 minutes** (comment in code; timeout raised to 600s); refuses processed periods
  unless `@AllowProcessed=1`.
- `POST /payroll/process` → `app.usp_ProcessPayroll_PayPeriod` — a **snapshot** with
  `ProcessedBy` and `SnapshotNote`.
- Notes at three levels: pay period / employee-period / employee-day — matches the ERP mock's
  note badges.

## 7. What is NOT in the code — confirmed by search

Searched both projects for `foreman|military|apprentice|certified|epip|paydata|export`:

- **No Foreman premium. No Military Base premium.** The codes exist in ADP
  (`FR*`, `ML*` — [adp-api-responses/pay-data-input-meta.md](adp-api-responses/pay-data-input-meta.md))
  and the rules exist in Brian Petros's chat message
  ([foreman-and-military-premiums.md](foreman-and-military-premiums.md)) — **but no system has
  ever computed them**. They are handled inside the manual Excel step today, or not at all.
  For the ERP these are new builds, not ports.
- **No apprentice-step logic** visible at the API/UI layer.
- **No certified-payroll output** — only pass-through employee flags `UseCertifiedPayroll` /
  `CertPay`.
- **No ADP export** (§1).

## Where this changes existing vault documents

- [adp-bucket-crosswalk.md](adp-bucket-crosswalk.md) — its File Number format row is now
  *explained* (copied from legacy validation) and *corrected* (live schema wins).
- [payroll-app-current-state/04](payroll-app-current-state/04-payroll-group-and-rule-applicability.md)
  — rule applicability now has a code-verified current-behaviour table (§2 above).
- [payroll/gaps.md](gaps.md) — WTL thresholds still open (values in SQL we don't have);
  foreman/military premiums confirmed never-implemented.
