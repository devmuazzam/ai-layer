---
title: "A holiday-start shift reverts at midnight, the minimum is 8 hours total, and the guaranteed hours count toward the 12-hour double-time mark — union ruling via the Payroll Manager"
source: decision/union business agent, relayed in writing by Corrina Bustos (TCG Payroll Manager), 2026-09-12
decided: 2026-09-12
decided_by: The Local 12 union business agent, on the specific question Corrina Bustos undertook on the recorded 2026-09-10 call (34:02, 34:10) to put to him; relayed by Corrina in writing with a worked breakdown. On contract interpretation the union's own agent outranks every other source in this vault, including the consultant's app.
status: verified
supersedes: []
resolves: [PAY-033, payroll/gaps.md#holiday-shift-start-continuation-and-the-8-total-vs-8-additional-minimum--two-questions-for-the-union-rep]
tags: [module/payroll, kind/decision, holidays, guaranteed-hours, overtime, union-agreement, payroll-rules]
---

# Decision

Corrina Bustos, verbatim:

> I spoke to our union BA. He clarified if they work on a holiday into a non holiday.
>
> example:
> start time- 10pm (holiday)
> end time- 6am (non holiday)
>
> 10pm-12am- 8 hours Triple
> 12am-4am- 4 Overtime
> 4am-6am- Dbl time
>
> Reason for the breakdown is it follows the same 12 hours working then double time pay rule.
> Because they started on a prior date so after midnight would start at the applicable rate.

Three rulings follow from eight lines.

## (a) The holiday minimum is 8 hours **total**, not 8 additional

Two hours worked on the holiday (22:00–00:00) pay as **8 hours triple** — a 6-hour top-up, not
8 on top of 2. This settles the wording Brian Petros flagged on 2026-09-11 as *"a bit
controversial"* and is the reading his app, the legacy engine and the ERP all implement. The
*"additional 8 hours"* phrase in
[2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](2026-09-04-cross-midnight-day-type-and-holiday-minimum.md)
means *the minimum fires*, not *eight more*.

## (b) There is no "holiday shift-start" rule — the shift reverts at midnight

*"after midnight would start at the applicable rate."* The post-midnight hours price by their own
calendar day — a Thursday, so weekday rates — while the **continuous shift is preserved**: no new
straight-time bank at midnight, overtime until the 12-hour mark, double time after. This is the
exception Brian asked the rep to rule in or out (2026-09-11: *"whether the agreement contains a
special rule stating that a shift that begins on a holiday remains at the holiday rate for the
entire continuous shift even after midnight"*). **Ruled out.** Brian's structural reading — split
the timeline at midnight for day type, keep the continuous shift for OT/DT — is confirmed.

## (c) ⚠️ The guaranteed holiday hours **count toward the 12-hour double-time mark**

Double time begins at **04:00**. Actual hours at 04:00 are six. The only arithmetic that puts
double time there is **8 guaranteed holiday hours + 4 overtime = 12** — *"it follows the same 12
hours working then double time pay rule."* So for the daily ladder, the six phantom hours of the
holiday minimum are treated as hours worked.

**This contradicts three things, all of which must change:**

1. **Brian Petros, in writing, 2026-09-11:** *"That guarantee is not worked time. It should not
   advance OT/DT thresholds, rest calculations, WTL, etc. It is effectively a separate pay
   component."* His app prices the same shift as 8 TRI + 6 OT, and a 22:00→10:00 shift as
   8 TRI + 10 OT. The BA says 8 TRI + 4 OT + 2 DT and 8 TRI + 4 OT + 6 DT.
2. **The legacy engine**, whose guarantee hours live in `Gap_*` columns and never reach
   cumulative accumulation
   ([../payroll/legacy-payroll-app-db-extract/rules-plain-language.md](../payroll/legacy-payroll-app-db-extract/rules-plain-language.md) §7).
3. **The ERP** — `packages/payroll-engine/src/guarantee.ts` → `applyPremiumDayMinimums` emits the
   minimum as a separate component that advances nothing.

**What this does *not* say.** The BA ruled on the **12-hour daily ladder**. Whether the guarantee
hours also count toward the **8-hour rest trigger** (PAY-045 — where the client has twice said
added hours *"would not affect the 8-hour rest rule"*), **weekly overtime**, or **meal opportunity
spans** (PAY-046) was not asked and is not decided here. Treat those as still following Brian's
"not worked time" reading until someone asks.

## Confirmed on the longer example, 2026-09-12

Put back to Corrina in writing, to fix the reason rather than the one case: *"Same start, running to
10am: 10pm to 12am: 8 hours triple / 12am to 4am: 4 overtime / 4am to 10am: 6 double time."*
Corrina Bustos: **"hello, yes your example is correct."** So (c) is not a slip in the relay — six
hours of double time on a 12-hour shift is only reachable if the guaranteed holiday hours sit on
the 12-hour ladder. The ruling is complete.

## ⚠️ Contested by Brian Petros, 2026-09-11 — ruling (c) only

Brian, in writing, on **Friday 11 September** — in the same message as his five-concept list,
i.e. **before** Corrina's 12 September confirmation, not after it (corrected 2026-09-13; an
earlier draft of this section dated the passage the 13th, having seen the message only in part):

> That guarantee is not worked time. It should not advance OT/DT thresholds, rest calculations,
> WTL, etc. It is effectively a separate pay component. I currently/still believe it should not be
> reported/handled in the system/rules as hours "actually" worked… if the employee did not
> "actually" work the hours added (for any payroll rule).
>
> My last conversations with Corrina… I remember her explaining that we might need to consider
> those "added" hours as time "actually" worked by the employee… but that doesn't make sense to
> me, because the employee did not "actually" work during those hours added.
>
> If we are to treat those non-working hours added as "actually" worked… then that makes things
> much more difficult for the system to handle all of the other payroll rules that could interact
> with it… not to mention the legal issues that arise when claiming that the employee was working
> (when the employee was actually not working).
>
> I don't think we have received confirmation from Corrina regarding this.

He names **three rules that add hours not actually worked**: the guaranteed-hours rules (daily
4-h, holiday 8-h, special-Saturday 8-h, long-boom 4-h); the WTL rules that add a penalty
half-hour (the *second and later* missed meals — PAY-047's "each additional missed lunch adds a
new half-hour at DT on top"); and the shift-differential hours-add (+1.0 / +1.5 h). His position
is one rule for all three: **added hours are never "actually worked" — they never advance a
threshold, never feed rest or WTL, and are a separate component.**

**Where this stands against the record.** Corrina confirmed the 10am case in writing on the
12th — 8 TRI · 4 OT · 6 DT, only reachable if the six phantom hours sit on the ladder — **with
Brian's objection already in the thread from the day before.** Whether she read the two together
is not known: she confirmed a breakdown, not the principle behind it, and Brian may not have done
the 8 + 4 = 12 arithmetic on the BA's example. **Rulings (a) and (b) are not in
dispute. Ruling (c) is now contested by TCG's payroll consultant and app author**, against TCG's
Payroll Manager relaying the union's business agent. The union outranks the consultant on
contract interpretation; the consultant is the one who has to make his app agree with ours.
Both need to see the same number.

**The point that may reconcile them — and how the ERP already does it.** Brian's objection has
two halves. The *legal/reporting* half — the system must never *claim* the employee was working
when they were not — is satisfied by the build as shipped: `actualHours`, the timesheet, certified
payroll and the ADP export all carry 12 worked hours; the 6-hour top-up is its own `PAY-033`
component; **only the ladder's 12-hour counter is advanced**, and nothing else reads the phantom
hours (rest trigger, weekly OT, meal spans all count actual time). The *rule* half — whether the
ladder counter should move — is the union's call, and the BA's own breakdown moves it. So the
question to put back is narrow: not "are guarantee hours worked time" (no — and the ERP does not
say so anywhere) but "**does the 8-hour holiday guarantee reach the 12-hour double-time mark**".
Brian's own `NORMAL_WORK` / special-earning policy design draws exactly this line elsewhere.

**Scope Brian widens that the BA did not rule on:** the daily 4-h and long-boom 4-h guarantees,
the WTL penalty adds, and the shift hours-add — and, for each, the rest trigger, weekly OT and
meal spans. None of those was in the BA's example. The engine treats **all of them as Brian
says** today; only the holiday / special-Saturday top-up, and only on the 12-hour rung, follows
the BA. Registered as an open question with the three categories and four thresholds laid out:
[../payroll/gaps.md](../payroll/gaps.md) → *Added hours — which rules' phantom hours reach which
thresholds*.

## ⚠️ Contested again by Brian Petros, 2026-09-14 — the workbook

Brian sent `___holidayGuaranteeScenario.xlsx` and called *"how our Labor Union rep explained to
us"* a **$1,440-per-employee overpayment** on a Labor Day 22:00→10:00 shift. His "contract" row
pays 00:00–06:00 at triple with no top-up, which departs from ruling **(b)** as well. His "union
rep" column is not the breakdown recorded above. This note is unchanged by the workbook; it
stands until Corrina or the BA says otherwise. Transcription and arithmetic:
[../payroll/holiday-guarantee-scenario-2026-09-14.md](../payroll/holiday-guarantee-scenario-2026-09-14.md).
Open question: [../payroll/gaps.md](../payroll/gaps.md) → *Holiday-start guarantee — Brian's
2026-09-14 workbook…*.

# Worked outcomes, at an $80.00 base

| Shift | Union BA | Brian's app | ERP as of `015136f79` |
| --- | --- | --- | --- |
| Hol 22:00 → 06:00 (8 h) | 8 TRI · 4 OT · 2 DT = **$2,720.00** | 8 TRI · 6 OT = $2,640.00 | 14 TRI = **$3,360.00** — overpays $640.00 |
| Hol 22:00 → 10:00 (12 h) | 8 TRI · 4 OT · 6 DT = **$3,360.00** | 8 TRI · 10 OT = $3,120.00 | 18 TRI = **$4,320.00** — overpays $960.00 |
| Tue 16:00 → Hol 02:00 (10 h) | 1 ST · 7 OT · 8 TRI = $2,840.00 | same | same ✅ |
| Hol 04:00 → 23:30 (19.5 h) | 19.5 TRI = $4,680.00 | same | same ✅ |

# Effect on the ERP

**Implemented 2026-09-12; merged to app `main` 2026-09-13 as PR #565 (`e9d45ecbf`)** — both changes below, plus the per-ticket
hours-add (audit N2), with the two breakdowns above as regression tests. What follows is the
design as written before the change; it describes what was built.


Two changes, both in `packages/payroll-engine/src/`:

- **`day-type.ts` → `bucketForSliceAnchored`** currently takes `max(anchor day type, slice day
  type)`, which floors a holiday-start shift at ×3 for every post-midnight slice — the rule the BA
  has just said does not exist. The never-downgrade principle from the 2026-09-04 decision applies
  to the **cumulative-hours bucket** (DT earned by hours does not drop to Saturday ×1.5), not to
  the **anchor day's premium**. Post-midnight slices must price as `max(cumulative bucket, own
  calendar day type)`. That is what `CalendarDay` in the legacy engine always meant.
- **`applyPremiumDayMinimums` / the 12-hour rung** — the holiday top-up hours must feed the
  cumulative counter that drives `DAILY_DT_AFTER_HOURS`, at the point in the timeline the
  holiday ends, and nothing else.

Regression cases: the four rows above, plus 23:00→13:00 (still open under the before-midnight
entry) and a Sunday 22:00 → Monday 10:00 to confirm Sunday ×2 does not carry either.

# Effect on the vault

- [`payroll/gaps.md`](../payroll/gaps.md) → *Holiday shift-start continuation and the
  8-total-vs-8-additional minimum* — Questions 1 and 2 **closed**; a third finding recorded there.
- [`payroll/rules/PAY-033-holiday-pay.md`](../payroll/rules/PAY-033-holiday-pay.md) — ruling appended.
- [`2026-09-04-cross-midnight-day-type-and-holiday-minimum.md`](2026-09-04-cross-midnight-day-type-and-holiday-minimum.md)
  — its wording caveat is answered (total), and its *never a downgrade* ruling is narrowed to the
  cumulative bucket.
- [`payroll/implementation-audit-2026-09-11.md`](../payroll/implementation-audit-2026-09-11.md)
  A4 — the fix that closed it implements the wrong floor; reopened.
- **Brian Petros must see this.** His app and his written recommendation of 2026-09-11 both
  price the guarantee as non-worked time; the union says otherwise for the daily ladder.
