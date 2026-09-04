---
title: Payroll-rule dependency matrix — calculation period, calculation context, recalculation impact
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/Payroll-rule dependency matrix.docx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/source, payroll-rules, architecture, wtl, rest-period, overtime, guaranteed-hours, subsistence, craft-modifier, shift-differential, open-questions]
entities: []
---

# Payroll-rule dependency matrix

**What this is.** A ~9,000-word TCG-side position paper on how the ERP should scope payroll
calculation. It is written as a reply — the author accepts an "8-hour rest looks back eight hours,
not seven days" correction, then generalises it into an architecture: **every payroll rule declares
its own dependency scope, the payroll period is not a calculation boundary, and changing one labor
entry has a forward recalculation impact on entries nobody edited.** The second half is a
rule-by-rule instruction list addressed to CodingCops covering foundation/time rules, CA non-union
hourly, L12 multipliers, L12 shifts, L12 guarantees, rates and modifiers, the 8-hour rest rule,
WTL/meal periods, subsistence, retroactivity, and a recommended engine calculation order.

> ## The two things in this document that matter most
>
> **1. It disowns the WTL default the engine runs today.** *"Absence of a payroll lunch/WTL code
> should not cause the ERP to invent a meal… pay the complete reconstructed Start→End span and make
> no automatic WTL add or lunch deduction merely because the code is absent."* The as-built legacy
> engine does the opposite — *no token found → assume `WTL_0` → deduct a meal* — at a production
> scale this vault has measured: **9,297** no-token warnings, **16,106** meal deducts
> (−$669,283.56) against **411** worked-through adds (+$27,493.92)
> ([PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md)). The document presents the reversal
> as *"the latest Payroll Manager direction supersedes some of our earlier WTL assumptions."*
> **Nobody has adjudicated this.** See collision 1.
>
> **2. It rejects the calculation boundary the ERP is built on.** *"**The payroll period is not a
> calculation boundary.**"* Each rule is to fetch its own dependency scope, before and after the
> week. The built ERP loads `findCompleteTicketsInRange(weekStart, weekEnd + 1 day)` and nothing
> else — no lookback, no lookahead. **Nobody has adjudicated this either.** See collision 11.

**Provenance — inferred from voice, not stated.** The extracted text carries **no author line, no
date and no salutation**. Authorship is inferred, and the inference is this: the voice is TCG-side
— *"our current data-warehouse-based Payroll App"*, *"the union rules we have built"*, *"an
important design decision we recently made in Payroll App"* — and it refers to **CodingCops in the
third person** (*"I would have CodingCops treat those as configuration"*) while addressing a second
person who wrote *"your original matrix"* and *"your original message"*. Its content matches the
exchange recorded in
[client-message-findings.md → 2026-09-04](client-message-findings.md#2026-09-04--rule-lookback-windows-and-recalculation-across-an-approved-week-brian-petros--ehteshamanwar)
(Brian Petros ↔ ehtesham.anwar) point for point. **The document does not say who wrote it or when.
Do not cite it as Brian Petros's without confirming.**

**Why it is not in the 2026-08-13 manifest — the source moved, the migration did not miss it.**
This file sits in `3.7.1_MODULE-HR-LABOR-PAYROLL/` beside the 33 files migrated on 2026-08-13, but
it is in neither [source-manifest.md](source-manifest.md) nor [sources/](sources/INDEX.md). Two
pieces of evidence date its content **after** the 2026-08-11 OneDrive snapshot: it uses **Saturday
8/22 through Friday 8/28** as its worked payroll week, and it replies to an exchange this vault
files under **2026-09-04**. The conclusion drawn here is that the file was **added to the
SharePoint folder after the 2026-08-11 snapshot was taken**, not that the migration overlooked it.
That distinction matters: the 2026-08-13 pass is not known to have a hole. It arrived with the
2026-09-04 Project Repository drop and is migrated here.

> **Status caveat.** This is one person's recommendation, not an approved specification. It is
> `unverified`. Several items **explicitly supersede** things this vault records as as-built legacy
> behaviour — all sixteen are listed under *§15 Collisions*. **Nothing here has been written into
> [rules/](rules/INDEX.md); the register still says exactly what it said.** No collision below has
> been adjudicated by anyone.

---

## 1. The core argument: rule scope, not lookback buffers

The opening concession: the 8-hour rest rule *"only needs to determine whether qualifying work
occurred during the eight hours preceding the next job/shift. The seven-day lookback I mentioned is
not part of the rule itself; it is simply an **oversized source-data window** used by our current
data-warehouse-based Payroll App."*

The recommendation follows:

> *"For the ERP, I don't think we should use arbitrary 7-day or 4-day buffers. Since the ERP has the
> complete labor history available, I recommend that each payroll rule define its actual dependency
> scope."*

The declared scopes:

| Rule | Its actual dependency scope |
| --- | --- |
| CA daily OT/DT | employee / workday |
| CA weekly OT | the entire Saturday–Friday workweek |
| CA seventh-day rules | the entire workweek |
| 8-hour rest | qualifying work overlapping the eight hours before the next job/shift |
| WTL / meal rules | the complete applicable meal/work chain — **potentially records before and after the payroll boundary** |
| Shift rules / differentials | the complete employee shift/work chain |
| Daily minimum | the complete employee shift |
| Holiday minimum | employee + calendar date |
| Special Saturday minimum | employee + calendar date |
| Long-boom minimum | qualifying boom labor within the employee shift |
| Other union guarantees/premiums | the applicable rule grouping |

And: *"Labor intervals also need to be evaluated by actual Start/End timestamps, including
cross-midnight and multi-day entries. A labor interval may begin before the payroll period and
overlap it, or begin during the payroll period and continue into the following period."*

## 2. The three concepts

The document's central proposal — **in no other vault document**:

1. **Calculation period** — *"what Payroll is currently reviewing/paying"* (worked example:
   Saturday 8/22 through Friday 8/28).
2. **Calculation context** — *"surrounding labor necessary to correctly calculate that period"*.
   Rule-dependent: previous 8 hours for rest; the rest of the same workday for daily OT; the whole
   Sat–Fri workweek for weekly OT; the prior six days for seventh-day; adjoining labor records for
   shift/chain calculations; previous/next records in the same meal-period/WTL chain.
3. **Recalculation impact** — the opposite direction, and *"arguably even more important"*: *"If
   someone changes a labor record, ask: what previously calculated records might now be wrong
   because this record changed?"* — records later that day, later that week, on the next job, in
   the next shift, in the next payroll, or *"in a payroll period that has already been closed."*

The asymmetry is stated with the rest rule as the example: *"the current entry has a **backward
dependency**, while modifying that entry creates a **forward recalculation impact**."*

**Closed-payroll policy proposed:**

> *"If a labor change affects an already approved/closed payroll, I recommend that the original
> posted payroll remain immutable. The system should recalculate what the corrected result would
> have been and create the difference as a retroactive payroll-adjustment transaction for Payroll
> to review/apply."*
>
> *"We should also store the rule/rate version and detailed payroll components used when a payroll
> is closed so that the historical result can always be reproduced and audited."*
>
> *"This avoids making payroll-period start/end dates artificial calculation boundaries and
> prevents historical changes from silently altering previously posted payroll."*

## 3. The dependency/impact matrix

The document's own table — **information needed beyond the individual labor entry**, and
**recommended recalculation scope after a change**:

| Payroll rule | Information needed outside the labor entry | Recalculation scope after a change |
| --- | --- | --- |
| CA daily OT / DT | All employee labor within the applicable workday | The employee's entire affected workday |
| CA weekly OT | Employee labor for the whole Saturday–Friday workweek | The affected workweek |
| CA seventh-day rule | Whether the employee worked the preceding days of the same workweek, plus seventh-day hours | The affected workweek |
| Cross-midnight labor | Actual start/end timestamps, not merely `WorkDate` | Re-segment the interval; recalculate every affected day/week |
| Multi-day labor entry | Same; one entry may span days or payroll periods | All periods/time segments the interval touches |
| 8-hour rest | Actual work/on-job activity in the 8 hours preceding the next job/shift start | Subsequent entries whose 8-hour lookback overlaps the changed interval |
| WTL / meal-period grouping | Adjacent labor forming the applicable work/meal chain | Rebuild the complete affected meal group, backward and forward |
| Shift determination | Labor in the same employee shift/work chain | The complete affected shift |
| Shift differential | Shift determination plus contract/rule configuration | The affected shift |
| Daily minimum / 4-hour guarantee | Total qualifying hours within the employee shift | The complete shift |
| Holiday minimum / 8-hour guarantee | Employee qualifying labor for that calendar date | The entire holiday/day |
| Special Saturday minimum / 8-hour guarantee | Qualifying labor for that Saturday | The entire affected day/group |
| Long-boom minimum | All qualifying boom labor in the applicable shift | The affected shift/boom group |
| Boom/lattice and similar rate modifiers | Entry attributes plus contract/rate configuration; minimum rules can make them group-dependent | The entry and any guarantee/group consuming that modifier |
| Union craft/base rate | Effective employee, union, craft and rate configuration | Reprice affected entries for the effective period |
| Temporary / base-rate override | Entry override plus any premium whose basis includes base rate | Reprice all components derived from that rate |
| Subsistence | Applicable union rule and qualifying work/day/job grouping | The applicable day/group |
| Guaranteed hours generally | Total actual qualifying hours for the guarantee's grouping level | The entire guarantee group, not merely the changed entry |
| Holiday / special calendar classification | Effective payroll calendar and all relevant work that date | The affected day |
| Gap / continuous-work chain | Previous and next labor intervals and the break between them | Rebuild the chain until a definite break/reset boundary |
| WTL premiums/deductions | Meal grouping plus already-determined pricing components / rate basis | Reprice the affected WTL group and dependent components |
| Manual labor correction | Every rule above that consumes the changed field | Run dependency/impact analysis automatically |
| Employee union/craft/pay-type correction | Potentially every labor entry within the corrected classification's effective date | Affected historical/open periods |
| Effective-dated rule/rate change | Entries governed by that rule/rate version | Impact analysis across affected effective dates |

**The union-grouping table it gives alongside** — *"the current L12 configuration"*:

| Rule | Current grouping concept |
| --- | --- |
| Daily minimum | Employee Shift |
| Holiday minimum | Employee + Calendar Date |
| Long-boom minimum | Employee Shift + Boom |
| Special Saturday minimum | Employee + Calendar Date |
| Shift differential | Employee Shift |
| WTL | Meal/work grouping |
| Rest | Relationship between adjoining labor intervals |

Configured guarantees named: **`DAILY_MIN_4`** (4-hour employee-shift minimum), **`HOLIDAY_MIN_8`**,
**`LONG_BOOM_MIN_4`** (4-hour boom-only), **`SPECIAL_SAT_MIN_8`**. The consequence stated:
*"something as simple as changing one job from 2.0 hours to 3.0 hours can change the amount of
guarantee pay assigned somewhere else in the group… the other labor rows themselves haven't
changed. Their **calculated payroll result** has changed."*

---

## 4. Section A — foundational time and calculation rules

Items marked **ADD** are new relative to the matrix the document is commenting on.

- **Workday definition (ADD).** Every employee/rule set must carry an explicit **`WorkdayStartTime`**
  defining the fixed 24-hour workday. *"Do not assume that a shift start, payroll date, or midnight
  automatically defines the legal workday."* California requires a consistently recurring 24-hour
  workday.
- **Workweek definition (ADD).** Saturday through Friday, stored as an explicit fixed 168-hour
  workweek **including its exact start time**. All weekly OT and seventh-day calculations use that
  workweek, *"not the dates currently displayed on a payroll screen."*
- **Authoritative labor time source (ADD).** Duration is reconstructed from labor Start/End
  date-time. *"Do not manufacture the payroll interval from an already-entered Hours Worked
  value."* The manual Hours Worked field may remain for FCC/operational reporting.
- **30-minute rounding/slicing (ADD).** Normalise per the approved rounding rules, then evaluate in
  **30-minute slices**; each slice knows its employee, source labor id, actual timestamp, workday,
  workweek, day type, shift, rates/modifiers and controlling multiplier.
- **Cross-midnight labor.** End earlier than start normalises into the following calendar day; one
  labor entry can hold slices belonging to different calendar dates or workdays.
- **Multi-day labor entry.** A 24/36/48-hour interval stays **one auditable source record** but is
  segmented into slices for daily, weekly, calendar, meal and rest rules. Never forced into a single
  payroll date because of the row's source `WorkDate`.
- **Pay-period boundary handling (ADD).** *"**The payroll period is not a calculation boundary.**"*
  An interval starting in the prior period and ending in the current one must be visible to the
  current calculation, and vice versa.
- **Gap / continuous-work chains.** Sort actual intervals chronologically; measure the elapsed gap
  from the previous qualifying interval's end to the next one's start; *"continue traversing
  backward/forward until the rule-specific reset boundary is found — not until a payroll-period
  boundary is found."*
- **Overlapping labor (ADD).** Two overlapping intervals for one employee are **not** simply added;
  flag as a payroll exception and apply the approved overlap treatment.
- **Missing/invalid times (ADD).** Create an explicit payroll blocker or review condition. *"Do
  **not** fabricate a shift using Hours Worked."* Described as a recent Payroll App design decision.
- **Holiday / special calendar classification.** Day types come from an **effective-dated Payroll
  Calendar**, not date logic scattered through procedures. Holiday, Special Saturday and future
  special dates are configuration data.
- **No pyramiding / one controlling multiplier (ADD).** Use the contract-defined **single controlling
  time multiplier** rather than adding OT multipliers. *"Our L12 engine currently stores one
  `Final_Multiplier` per 30-minute slice."* Additive rate premiums (shift, boom) stay separate
  components.
- **Payroll group / rule-set routing (ADD).** Resolve the effective-dated rule set first — L12 Labor
  Union Field, L12 Labor Union Mechanic, Non-Union Admin Hourly, Non-Union Admin Salary, plus
  excluded/system groups. *"Do not run L12 rules against non-union hourly employees or CA hourly
  rules against salary/exempt employees simply because they share a labor table."*

## 5. Section B — California non-union hourly

Scoped explicitly to **Non-Union Admin Hourly / CA NONEXEMPT**; the document states that
L12-specific WTL, boom, guarantees, rest and subsistence **do not apply to this group**.

- **CA daily OT/DT.** Within the established workday: first 8 hours straight time; over 8 through 12
  at **1.5×**; over 12 at **2.0×**. Accumulate all the employee's qualifying labor **across all
  jobs/entries** in that workday before deciding.
- **CA weekly OT.** After daily/seventh-day classification, accumulate remaining straight-time hours
  across the fixed Sat–Fri workweek; past 40 straight-time hours the rest become **1.5×**. Hours
  already at daily OT/DT are not counted again. *"Our current engine deterministically converts the
  later chronological straight-time slices."*
- **CA seventh-day rule.** All seven consecutive days in the same workweek → first 8 hours on day
  seven at **1.5×**, beyond 8 at **2.0×**, computed from the complete workweek.
- **CA regular rate of pay (ADD).** OT should be based on the legally applicable **regular rate of
  pay**, not automatically the bare hourly rate. For simple Admin Hourly cases `Employee.PayRate`
  may equal it, *"but the ERP data model should support other remuneration that must be
  incorporated"* — citing California DIR that regular rate can include multiple forms of
  remuneration.
- **Daily/weekly anti-double-counting (ADD).** An hour must not become 1.5× daily OT **plus** 1.5×
  weekly OT; weekly OT upgrades only remaining straight-time hours.
- **Non-Union Admin Salary (ADD).** Salary/exempt employees take a **different calculation route**;
  do not push them through the hourly ST/OT/DT path just because labor data exists.

**Test case the document asks for explicitly:** an employee with multiple jobs on the same day —
*"changing Job A from 6 hours to 8 hours can make part of Job B overtime **even though Job B was
never changed**."*

## 6. Section C — L12 time classification and multipliers

Described as *"a major category missing from your original matrix."*

- **L12 weekday/Saturday/Sunday classification (ADD).** The current L12 configuration uses a weekday
  standard window of approximately **06:00–17:00**, an **8-hour standard day**, **1.5× OT** and
  **2.0× DT after 12 hours**. Saturday qualifying work **1.5×**, Sunday **2.0×**, Holiday **3.0×**,
  configured Special Saturday **2.0×**. One controlling multiplier per actual 30-minute slice.
- **Time outside the regular L12 window (ADD).** Work outside the contractual regular window may
  become OT *"even if the employee has not simply crossed a calendar-day row threshold"* — another
  reason to process by actual timestamps. The exact current window/rule configuration *"should be
  migrated into an effective-dated rule table."*
- **Union no-pyramiding (ADD).** Saturday OT / daily OT / Sunday DT / Holiday 3× multipliers are not
  added together; apply the controlling contractual classification. Shift differential and boom
  remain separate additive rate components.

Explicit build instruction: *"I would have CodingCops treat those as **configuration**, rather than
embedding `IF Union='L12' AND Saturday…` throughout the ERP code."*

## 7. Section D — L12 shift rules

- **Shift determination.** Resolve an explicit effective `ShiftCode` before pricing. The current
  Payroll App identifies Shift 2/3 from structured payroll/comment codes, Shift 1 being the default.
  *"In the ERP, this should ideally become a **real structured field**, not text parsing."* Shift
  identity stays attached to the work chain across midnight.
- **Shift 1.** **$0 differential; 8 worked / 8 paid.** No shift-rate or shift-hours add; other
  day-type, OT and boom rules still apply.
- **Shift 2.** **+$3.00/hour** on every actual worked slice classified Shift 2 — a rate premium
  separate from the time multiplier, so it follows the slice's applicable multiplier. Plus the
  contractual **7 worked / 8 paid** concept implemented as **+1.00 paid hour**, priced at **Base +
  Shift, explicitly excluding Boom**, using the multiplier of the **last actual worked slice**.
  *"The 7-hour value is a normal-work reference, not a cap on actual work."*
- **Shift 3.** **+$4.00/hour**; **6.5 worked / 8 paid** implemented as **+1.50 paid hours**, same
  Base + Shift, boom-excluded, ending-multiplier pricing. 6.5 is not a cap on actual work.
- **Interaction with day type.** Shift 2/3 rate and paid-hour adds remain applicable on weekday,
  Saturday, Sunday, Special Saturday and Holiday labor; the day/time multiplier still controls.

The document flags this as needing explicit documentation *"because it is **not the same thing as an
ordinary $3/$4 shift differential**."*

## 8. Section E — L12 guarantees and minimums

- **Daily minimum / `DAILY_MIN_4`.** Group **all qualifying labor for the employee's applicable
  shift**, including multiple jobs. Below 4.00 qualifying base hours, add only the deficiency (3.50
  → 0.50 guarantee hour). *"Do not give each individual labor entry its own four-hour minimum."*
- **Reporting / show-up minimum (ADD / confirm).** The L12 material distinguishes roughly **2 hours
  for report/no-work** from **4 hours when work is provided**. Because a report/no-work situation
  *"may produce no ordinary labor interval at all"*, the ERP should **model a reporting event
  separately** rather than infer it from labor. The document asks for this branch to be re-confirmed
  against the current CBA / Payroll Manager before sign-off, and notes their own four-rule guarantee
  implementation focused on the 4-hour work-provided case.
- **Holiday minimum / `HOLIDAY_MIN_8`.** Combine all qualifying work on the actual holiday calendar
  date; holiday work is **3.0×**; below **8.00** hours add the difference as holiday guarantee pay at
  the 3× treatment (6.50 → 1.50 guarantee hours).
- **Special Saturday minimum / `SPECIAL_SAT_MIN_8`.** The documented L12 rule identifies the **first
  Saturday following the first Friday in June and December**; treat the date through the payroll
  calendar; work is **2.0×** with an **8-hour minimum** (6.00 → 2.00 guarantee hours at 2×).
- **Long-boom minimum / `LONG_BOOM_MIN_4`.** Group all eligible long-boom work for the employee's
  **entire shift**, not per job. The rule guarantees *"the **boom premium** on up to 4 qualifying
  hours, **not** four additional base-pay hours."* Boom gap = amount required to reach
  `MIN(4.00, total actual shift hours)`; pay only the missing boom premium × the applicable
  multiplier.
- **Guaranteed hours generally.** A guarantee is a **top-up**, never a duplicate set of worked hours:
  `GapHours = MAX(RequiredMinimum − QualifyingActualHours, 0)`. Actual work and guarantee pay are
  stored as **separate ledger components**.
- **Guarantee stacking (ADD).** Daily 4, Holiday 8 and Special Saturday 8 *"should not independently
  stack duplicate base hours unless the contract explicitly requires that result. Apply the
  applicable/highest contractual base minimum."* **Long-boom is different** — a boom-premium-only
  guarantee that can coexist with base-hour pay.

Stated consequence: *"an employee working two 2-hour jobs on the same shift generally has **four
actual hours for the shift**, not two separate four-hour guarantees."*

## 9. Section F — rates, boom, lattice, modifiers

- **Union craft/base rate.** Resolve effective **UnionCode + CraftCode + date**, then the effective
  `UNION_CRAFT` base rate. *"The craft rate — not an arbitrary source amount — is the authoritative
  base-rate component."*
- **Boom/lattice and similar modifiers.** Separate, effective-dated **modifier components** keyed to
  the craft/modifier code. Conceptually `HourlyRate = Base + Shift + ApplicableModifier(s)`, then the
  controlling time multiplier as the rule requires. Amounts and eligibility for lattice, boom,
  military etc. live in **configuration, not calculation procedures**.
- **Boom actual pay.** Current logic is essentially `Boom Hours × Boom Modifier Rate × Final
  Multiplier`; boom stays a separately auditable pay component.
- **Do not double-count imported rates (ADD).** *"We found real FCC cases where `Source_Rate_Raw`
  already contained **craft base + modifier**. If the ERP then treated that amount as base and added
  the modifier again, the employee was over-priced."* Store base and modifiers separately; never
  assume an imported gross hourly rate is a clean base rate.
- **Job-ticket modifier window (ADD).** LaborPayroll time remains the authoritative worked interval;
  job-ticket information can *support or audit* modifier eligibility (such as a boom window) but must
  not replace the employee's actual labor interval.
- **Temporary / base-rate override.** `BASE RATE OVERRIDE` is a distinct concept from shift, lattice,
  military and boom. An authorised override substitutes the base rate and then **recalculates all
  components whose rate basis includes base**, without erasing the separately configured modifier
  components. *"Preserve who entered the override, why, and its effective scope."*

## 10. Section G — the 8-hour rest rule

- **8-hour rest.** Walk the employee's chronological work intervals; before a new interval begins,
  determine whether the employee received **8 continuous hours off** after the previous qualifying
  work chain. *"This does **not** mean 'look back seven days.' It means the engine must find the
  prior work interval/continuous chain and determine the actual off-duty gap."*
- **Rest-rule continuation (ADD).** The Payroll App carries a policy equivalent to
  **`PunitiveUntil8Off`**: a short rest interval does not start a clean chain merely because the
  calendar date or payroll week changed. **A valid 8 continuous hours off is the reset boundary.**
- **Rest overlap (ADD).** An actual overlap with the previous interval is *"stronger than merely
  having <8 hours rest"* — flag it as an overlap/data-quality condition rather than treating it as a
  normal positive gap.
- **Rest pay component.** Keep rest-related compensation as its own component
  (`Pay_Rest_Add`/equivalent), not buried in base pay.
- **Exact punitive/rest rate.** Deliberately **not** specified here: *"I would have CodingCops copy
  this part from the **approved current L12 contract/Payroll App procedure**, not derive it from the
  discussion about lookup windows… I would not give them a new rate/multiplier formula from memory if
  the current CBA/procedure can be used as the authoritative specification."*

The two questions the document says were being conflated:

- **Calculation:** `CurrentStart − prior qualifying work → did the employee receive 8 continuous hours off?`
- **Recalculation:** after an older job's End Time changes, *"which later jobs now have a different
  rest result?"*

## 11. Section H — WTL / lunch / meal periods

Prefaced: *"the **latest Payroll Manager direction supersedes some of our earlier WTL
assumptions**."*

- **WTL / meal-period grouping.** Form the applicable continuous work/meal chain from actual
  Start/End intervals and adjacency. *"Do not stop the group just because payroll week Friday ended
  or because a new source row/job was created."*
- **Current meal-count thresholds** (stated as configurable): **0 meals through 5.0 hours; 1 meal at
  5.5–10.5; 2 at 11.0–16.0; 3 at 16.5–21.5; 4 at 22.0–27.0.** A meal period is **0.50 hour**. These
  *"should be configuration rows rather than nested code"*, and longer-duration cases should also be
  configurable.
- **Explicit Lunch Taken — latest direction.** Replace the old **WTL:0** concept with an explicit
  **Lunch Taken** indicator/code. When a lunch is explicitly recorded as taken, apply the
  **0.50-hour lunch deduction** per the approved meal-assignment logic.
- **No WTL/Lunch code — latest direction.** *"**Absence of a payroll lunch/WTL code should not cause
  the ERP to invent a meal.** Under the latest Payroll Manager direction, pay the complete
  reconstructed Start→End span and make **no automatic WTL add or lunch deduction** merely because
  the code is absent."*
- **WTL premiums/deductions.** Separate ledger components; a taken-lunch deduction and a
  missed-meal/WTL premium are different events. Notes the Payroll App has used 0.50-hour components
  and a rate basis of **Base + Shift with Boom excluded** for certain WTL additions — and that
  because the Lunch Taken design changed recently, the final weekday/Saturday/Sunday/Holiday premium
  treatment should be **frozen only after Payroll Manager confirms the final WTL specification**.
- **Do not use FCC Hours Worked for WTL (ADD).** Determine eligibility/duration from the
  reconstructed labor timeline. *"Otherwise WTL is using the result of a payroll adjustment as an
  input to payroll itself."*

Closing instruction: *"tell CodingCops **not to copy our old 4-day WTL source buffer as a business
rule**. Their ERP should traverse the applicable work chain until the true WTL reset boundary is
found."*

## 12. Section I — subsistence

- Qualifying subsistence attaches to work sufficiently distant from home base; *"our documented rule
  context uses **over 77.5 miles**."* Components: **$85** short/weekday-type subsistence and **$200**
  qualifying weekend long subsistence.
- **Triggering.** The Payroll App recognises structured tokens `SUB_SHORT` / `SUB_LONG`; for the ERP
  the author prefers eligibility **derived from structured job location + home base + employee/union
  rule + day type**, retaining an authorised override.
- **Treatment.** Subsistence is a **fixed pay component/allowance, not worked hours subject to an
  hourly multiplier**; keep it separately identifiable in the ledger and in ADP/output mapping.
- **Applicability caution.** Used for **L12 Labor Union Field**. Applicability to other populations
  *"such as L12 Mechanic should be explicitly confirmed rather than assumed."* Non-Union Admin Hourly
  does not receive it.

## 13. Section J — corrections, retroactivity, versioning

Described as *"not contractual pay formulas, but I consider them **mandatory payroll-engine rules**."*

- **Manual labor correction.** Any edit to start, end, employee, job, craft, modifier, shift, lunch,
  comments/codes, rate override or calendar classification must first determine **which calculations
  depend on the changed data**, then recalculate all affected open calculation groups — *"not merely
  the edited labor row."*
- **Employee union/craft/pay-type correction.** Employee classification must be **effective-dated**;
  a correction can change the whole rule path, base rate, modifiers, guarantees and WTL/rest
  eligibility. Recalculate all affected dates from the classification's effective date.
- **Effective-dated rule/rate change.** All rates and rules carry effective start/end dates or version
  ids. *"Recalculating February payroll in September should use the **February rule/rate version**,
  unless the transaction being entered is an explicitly retroactive contractual change."*
- **Zero/missing rate validation (ADD).** Every payable hourly component must resolve to a valid rate
  before posting. *"We have already encountered real zero-rate source labor rows while a valid craft
  rate existed in Payroll App."* Resolve the authoritative configured rate or raise a hard payroll
  exception — **never silently calculate at $0**.
- **Open payroll after correction (ADD).** Automatically invalidate and recalculate every impacted
  group, then return the period to the appropriate review state.
- **Closed payroll after correction (ADD).** *"**Do not rewrite posted history.** Preserve the closed
  result. Recalculate the corrected result separately, compare Posted vs Corrected by component, and
  generate the difference as a retro/payroll-adjustment transaction for approval and a future or
  off-cycle payroll."*
- **Rule/rate change affecting closed periods (ADD).** Same retro mechanism. *"A rate table update
  should never silently change what the ERP says was actually paid last month."*
- **Calculation snapshot/version (ADD).** At close, retain source labor ids/times, employee
  classification, craft/rate, rule/calendar versions, calculated components, overrides and
  calculation-run/version information, *"so Payroll can reproduce exactly why a historical check was
  calculated as it was."*

## 14. Section K — the recommended engine calculation order

Quoted as a single ordered flow, on the ground that *"downstream rules consume the results of earlier
rules"*:

1. Resolve employee payroll group and effective rule version
2. Validate employee / union / craft / pay type
3. Normalise actual Start/End timestamps
4. Apply approved rounding
5. Build 30-minute slices
6. Assign workday, workweek, calendar day type, shift and continuous-work chains
7. Resolve base rate plus separate shift / boom / lattice / etc. modifiers
8. Calculate actual ST/OT/DT/day-type pay using **one controlling multiplier**
9. Apply Shift 2/3 rate and paid-hour components
10. Calculate base-hour guarantees
11. Calculate boom-premium guarantees
12. Evaluate 8-hour rest
13. Evaluate WTL / Lunch Taken rules
14. Calculate subsistence and other fixed allowances
15. Build the detailed pay-component ledger
16. Validate / reconcile totals
17. Determine recalculation / retro impact
18. Post an immutable payroll snapshot when approved

And: *"That order should itself be documented and version-controlled. CodingCops should not have one
procedure calculate a guarantee before actual OT while another route calculates it afterward."*

---

## 15. Collisions — sixteen places this meets the existing record

**These are stated collisions, not resolutions. Both sides are named and cited. None has been
adjudicated by anyone, and nothing here has been written into
[rules/](rules/INDEX.md) or any `gaps.md`.**

| # | This document says | The vault currently records | Status |
| --- | --- | --- | --- |
| **1** | **Absence of a WTL/lunch code must not invent a meal** — pay the full reconstructed span, no automatic add or deduction; `Lunch Taken` becomes an explicit indicator | The legacy engine's as-built rule is *"no WTL token found; assuming `WTL_0`"* → **meal deduct**: **9,297** no-token warnings, **16,106** deducts (**−$669,283.56**) against **411** adds (+$27,493.92) — [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md), [client-message-findings.md](client-message-findings.md) | **Direct contradiction — the most consequential item in the drop.** The document knows it is one: it is offered as *"latest Payroll Manager direction supersedes some of our earlier WTL assumptions."* The as-built default is disowned by the side that built it. **Not adjudicated.** PAY-047 unchanged and still carries the old behaviour |
| **2** | Explicit **`Lunch Taken`** indicator replaces the `WTL:0` concept | PAY-047 records comment-token parsing `(PAY:WTL_n)` and the ERP's mobile-captured `wtlCount`; "Lunch Taken" appears nowhere as a named indicator | **New data-contract requirement.** Consistent in spirit with the Atom app's Take Lunch / WTL capture (US-11) but stated here as a payroll-side obligation. **Not adjudicated** |
| **3** | **Do not copy the 4-day WTL buffer or the 7-day rest buffer as business rules** — both are data-warehouse selection artefacts | [client-message-findings.md 2026-09-04](client-message-findings.md) records both windows as facts of the legacy procedure; question 27 asks what a WTL meal-period group even is | **Retraction by the source that supplied them.** Answers the vault's open question 26 and reframes 27 — but as a recommendation. **Not adjudicated** |
| **4** | Meal thresholds **0 → ≤5.0 · 1 → 5.5–10.5 · 2 → 11.0–16.0 · 3 → 16.5–21.5 · 4 → 22.0–27.0**, meal = 0.50 h | [PAY-046](rules/PAY-046-meal-opportunity.md) records the same brackets, opportunities at 5.0 / 10.5 / 16.0 / 21.5 h; [wtl-charts.md](wtl-charts.md) gives 5:01 / 10.5:01 / 16:01 / 21.5:01 | **Confirms** the payroll-side numbers — an additional independent source. Still disagrees with the field-ops Atom values (5 / 10.5 / **16.5** / **22**) at lunches 3 and 4. That older conflict **stays open** |
| **5** | **Long-boom guarantee pays the boom premium only** on up to 4 qualifying hours — not 4 base-pay hours; gap = `MIN(4.00, total actual shift hours)` | [PAY-043](rules/PAY-043-long-boom-premium.md) already flags this as *"Nuance vs the client's blanket 'as if actually worked'… the engine's version is the precise one"* | **Self-correction.** The client now states the precise version himself, superseding his own earlier blanket doctrine. PAY-043 unchanged |
| **6** | **Guarantees do not stack** — Daily 4 / Holiday 8 / Special Sat 8 apply the highest contractual base minimum; long-boom coexists because it is premium-only | No stacking rule exists anywhere in the register — PAY-033, PAY-034, PAY-040 and PAY-043 each stand alone | **New rule, never previously asked.** Offered *"unless the contract explicitly requires that result"* — **the contract basis is not given.** Needs the MLA read against it |
| **7** | **Reporting/show-up must be modelled as a separate event**, because report-and-no-work may produce no labor interval at all; the 2h-vs-4h branch needs CBA re-confirmation | [PAY-039](rules/PAY-039-reporting-pay-no-work.md) says "pay two hours unless a contractual exception applies", blocking on *"confirm structured source fields"* | **Refines PAY-039 and explains why its source fields are missing** — there is no labor row to carry them. Also an admission that their own build covered only the 4-hour work-provided case ([PAY-040](rules/PAY-040-work-provided-minimum.md)). **Not adjudicated** |
| **8** | `Source_Rate_Raw` in real FCC data **already contained craft base + modifier**; adding the modifier again over-priced the employee | [PAY-014](rules/PAY-014-rate-comparison-and-validation.md) is `conflicted`; PAY-008 references `Source_Rate_Raw` | **Confirms and sharpens** the PAY-014 conflict with a named, observed failure mode |
| **9** | **Never calculate at $0** — resolve the configured rate or raise a hard exception; real zero-rate source rows exist | [PAY-060](rules/PAY-060-missing-data-issues.md) covers missing data generally; zero-rate appears only in [rule-examples-catalog.md](rule-examples-catalog.md) | **New explicit blocker requirement.** Not in any rule |
| **10** | **Closed payroll is immutable**; corrections post as a retro delta transaction, with a rule/rate-version snapshot at close | [PAY-068](rules/PAY-068-retroactive-correction.md)'s blocking item is literally *"Confirm correction workflow"*; [PAY-066](rules/PAY-066-payroll-snapshot.md)'s is *"Confirm reopen/correction policy"*; the built ERP **refuses** recalculation of `APPROVED`/`EXPORTED` and has no reopen or delta path (`payroll.service.ts:139-148`) | **The first written answer in the record to PAY-068's and PAY-066's blocking questions**, and to client question 25. It is a recommendation from one person. **PAY-068 and PAY-066 stay open** until someone with authority accepts it |
| **11** | **"The payroll period is not a calculation boundary."** Each rule fetches its own dependency scope, before and after the week | The built ERP loads `findCompleteTicketsInRange(weekStart, weekEnd + 1 day)` and nothing else — no lookback, no lookahead (recorded 2026-09-04) | **Direct architectural contradiction with the as-built ERP** — the second most consequential item in the drop, and the answer to open question 26. **Not adjudicated.** The mitigation noted in client-message-findings still holds: the three rules that most need cross-boundary data (PAY-026, PAY-045, PAY-046) are not implemented yet, so the period-scoped window is not producing wrong numbers *today* |
| **12** | A 24/36/48-hour interval stays **one source record**, segmented into slices across days and periods | [PAY-004](rules/PAY-004-labor-entry-import.md) carries a 23.5-hour cap; [PAY-019](rules/PAY-019-cross-midnight-processing.md) is `conflicted` | **Answers open question 28** — a 48-hour entry straddling Sat–Fri is neither split into two records nor priced whole into one period: **one record, many slices.** Bears directly on the 23.5-hour cap, which the document never mentions and may be incompatible with. **Not adjudicated** |
| **13** | Shift determination *"should ideally become a **real structured field**, not text parsing"*; Shift 2 = +$3.00/h and +1.00 paid hour, Shift 3 = +$4.00/h and +1.50 paid hours, both at Base + Shift excluding boom, at the last worked slice's multiplier | [PAY-018](rules/PAY-018-assumed-shift.md) records comment-code parsing as the legacy mechanism; [PAY-036](rules/PAY-036-second-shift.md) / [PAY-037](rules/PAY-037-third-shift.md) record exactly these amounts and this placement doctrine | **Confirms** — the amounts and the placement doctrine match PAY-036/037 to the letter, a further independent source. The structured-field recommendation is **new** |
| **14** | An explicit **`WorkdayStartTime`** per employee/rule set; the workweek is a fixed 168-hour window **including its exact start time** | [PAY-001](rules/PAY-001-saturday-friday-payroll-week.md) is settled for the Sat–Fri *week*. **No workday-start concept exists anywhere in the vault** | **Genuinely new requirement, and load-bearing.** Every daily-OT rule in the register presumes a workday boundary nobody has defined |
| **15** | OT should use the **legally applicable regular rate of pay**, not automatically the bare hourly rate | Appears only in passing in [adp-workbook-column-rules.md](adp-workbook-column-rules.md); no rule states it | **New requirement**, flagged by the author as a data-model concern rather than a present defect |
| **16** | Subsistence applicability to **L12 Mechanic** must be confirmed, not assumed | [PAY-048](rules/PAY-048-standard-subsistence.md) / [PAY-049](rules/PAY-049-weekend-subsistence.md) — the 77.5-mile / $85 / $200 figures match; [decisions/2026-09-01-subsistence-not-a-craft-attribute.md](../decisions/2026-09-01-subsistence-not-a-craft-attribute.md) already settles that subsistence is a property of the trip | **Confirms** the amounts and distance; **adds** an applicability question about the Mechanic group that the register does not ask |

Two further items the vault has no home for at all: the **calculation-order contract** (§14 — that
the engine's rule sequence is itself a versioned, documented artefact) and the **overlapping-labor
treatment** — [PAY-029](rules/PAY-029-overlapping-labor-detection.md) detects overlaps but says
nothing about how rest-rule evaluation should handle one, which this document says is *"stronger
than merely having <8 hours rest."*

## Source

`3.7.1_MODULE-HR-LABOR-PAYROLL/Payroll-rule dependency matrix.docx` — 46 KB `.docx`, converted by
pandoc to GitHub-flavoured Markdown, 351 lines / ~35 KB of text. Eleven lettered sections (A–K) plus
three untitled lead sections and two summary tables. **No author, date or salutation in the
extracted text** — authorship inferred from voice only (see *Provenance* above). Not present in
[source-manifest.md](source-manifest.md)'s 33 files from the 2026-08-11 OneDrive drop; its content
postdates that snapshot.
