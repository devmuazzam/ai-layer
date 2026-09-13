---
title: "Work chains stitch only when there is no gap — the 30-minute stitch is a bug, not a rule — decision"
source: decision/client message (Brian Petros → Ehtesham Anwar, 2026-09-09), written, unprompted, correcting his own application
decided: 2026-09-09
decided_by: Brian Petros (TCG — author and owner of the legacy Payroll App, the system of record this parameter was copied from), in writing. Self-reported after reconciling his app against the exhibits he sent on 2026-09-09.
status: verified
resolves: [PAY-045, PAY-023, PAY-046, PAY-047]
tags: [module/payroll, kind/decision, payroll-rules, rest-period, wtl, legacy-payroll-app]
---

# Decision

**Two labor entries belong to the same work chain only when they are back-to-back — no gap.
A 30-minute tolerance was never a payroll entitlement rule, and it must not survive into the ERP.**

Brian Petros, 2026-09-09:

> Somehow, along the way, I introduced logic that was stitching together labor entries that are
> <=30 minutes apart from each other. I don't recall why I did that … But, really, the only reason
> to "stitch" together two labor entries for an employee is if they are "back-to-back" (no gap
> between them).

On why the tolerance was probably introduced — lunch breaks, job-to-job transitions, split FCC
labor entries, short gaps between tickets not looking like a new shift — he is explicit that the
motive does not make it a rule:

> But it is **not itself a payroll entitlement rule**.

## What it broke, in his app

The rest-period premium stopped triggering. His exhibit: **Thu 2026-04-09**, employee on
`L12-G4-A`, ticket `43767` `3:30 AM–5:30 PM` then ticket `43770` `6:00 PM–11:00 PM` — a **30-minute
gap**. The two entries stitched into one chain, so the 8-hour rest rule never evaluated against the
second, and the **Rest period badge is absent** where the following day's entries (`43829`,
`43828`) both carry one (`Rest floor hrs 8.0` and `9.0`).

## Scope — this is the REST chain, not the meal chain

The 30 lives in **one** place in the extract, and it is not the one Brian's message assumes:

| Config row | `StitchGapMinutes` | Consumed by |
| --- | --- | --- |
| `cfg.RestPeriod_Rule` — `PunitiveUntil8Off` | **30** | `usp_Apply_RestPeriod_Premium`, `usp_Prototype_RestPeriod_SliceChain` |
| `cfg.WTL_Rule` — `L12_WTL_2025` | **0** | `usp_Apply_WTL_MealPeriods`, `usp_Preview_WTL_PayComponents`, `usp_Diagnose_WTL_ReviewGroups` |

So **meal/lunch grouping was never affected** — the WTL path already stitches gaplessly. His
message says the bug "has an effect on the meal/lunch break calculations"; against the 2026-08-18
extract it does not. The fix is the one `cfg.RestPeriod_Rule` value, `30 → 0`.

Two hard-coded fallbacks will silently reintroduce it if that row is ever missing —
`usp_Apply_RestPeriod_Premium.PROC.sql:77` and `usp_Prototype_RestPeriod_SliceChain.PROC.sql:65`,
both `IF @StitchGapMin IS NULL SET @StitchGapMin = 30`.

## The comparison is `>`, so 0 is exactly right

Both procs break a chain on `DATEDIFF(MINUTE, prevEnd, start) > @StitchGapMin`. At **0**: a
zero-minute gap (back-to-back) still stitches, any gap of a minute or more starts a new chain, and
FCC's overlapping entries — negative difference — still stitch. That is precisely the rule as
stated, with no further code change.

## Pricing chains are a different grouping, and they are NOT gapless

Brian's second issue is that his pricing engine restarts ST/OT/DT at each `LaborPayrollID` instead
of carrying the accumulation across the chain — his `43770` prices `5.0 OT` where the employee had
already worked 14 hours that chain and it should be `DT`. **The chain the pricing engine carries
across is the 8-hour shift chain (PAY-023 `ChainGroup`), not this 30-minute stitch.** His own
example requires it: the `43767 → 43770` gap is 30 minutes, which is under 8 hours, so the two must
price as one continuous accumulation *whatever* the rest-stitch value is. Setting the rest stitch to
0 must not be carried across into the pricing chain.

## Consequences for the ERP — do NOT mirror this yet

`REST_STITCH_MINUTES = 30` in `packages/shared/src/constants/payroll.ts:36` was copied from
`cfg.RestPeriod_Rule` and is consumed at `packages/payroll-engine/src/rest-period.ts:106` with the
same `>` semantics, so our engine reproduces the missing-badge behaviour exactly.

**This decision does not settle whether ours should change.** Brian decided a question about *his*
application; the ERP question is a different one, and [PAY-045](../payroll/rules/PAY-045-rest-period-premium.md)
already has it open — *"Confirm both thresholds are intended for the ERP."* Two reasons to hold:

1. **His stated rationale does not cover the case he is removing.** Brian lists *"job-to-job
   transitions"* and *"short gaps between tickets"* among the reasons he probably introduced the
   tolerance. In the ERP every job is its own ticket, so a job-to-job transition **always** produces
   an entry boundary. At `0`, two consecutive jobs a minute apart become separate rest chains, the
   gap is under 8 hours, and the second job is rest-forced — a punitive premium for an employee who
   never left the job. That is the rule firing on continuous work, which is the opposite of what
   *"returns after OT without eight hours off"* is for.
2. **On his own exhibit the change moves no money.** By ticket `43770` the chain stands at 14 hours,
   past `REST_DOUBLE_AFTER_CHAIN_HOURS = 12`, so the forced floor is `REST_DOUBLE_FLOOR_MULTIPLIER`
   = **2.0**. His issue #2 fix independently prices those hours at DT = 2.0 by ordinary accumulation.
   Floor and bucket coincide: the premium is **$0**, and what the fix restores is the badge, not pay.
   His exhibit therefore does not demonstrate the value of the change, and cannot be used to size it.

**Update 2026-09-13 — Corrina has now confirmed it, and Brian is removing the code.** Brian, in
writing: *"I vaguely remember Corrina mentioning something about that in the past... but recently
confirmed with her that we should not be doing that. Labor entries should only be 'stitched'
together if they are 'back-to-back'... or in some strange cases where they overlap."* So the rule
is no longer only his self-correction — it carries the Payroll Manager — and it gains a clause:
**overlapping entries stitch too.**

**This resolves hold-reason 1 above, once one detail is fixed with it.** The ERP's rest chain
measures the gap on the *raw* `shiftStartedAt` / `shiftEndedAt` (`calculate.ts:737`), while pay
is priced on the PAY-020 rounded window (start down, end up, 30 min). Measured on the rounded
window, "back-to-back" means what the priced slices say: a raw 11:29→11:31 handover rounds to
11:30→11:30 and touches; a raw 11:31→11:59 gap rounds to 12:00→11:30 and *overlaps*. Only a gap
that leaves a whole empty half-hour slice splits the chain — which is a real break, not a
job-to-job handover. The "two jobs a minute apart get rest-forced" objection was an artefact of
measuring raw minutes against a rounded ladder. **Recommended ERP change:** `REST_STITCH_MINUTES`
30 → 0 **and** `toWorkChains` compares rounded boundaries (overlap or touch ⇒ one chain).
Audit item A7 closes with it. Not yet built.

The live question is not *30 or 0* but **what the rest chain is for**: a fatigue rule about genuinely
going home and returning, or a literal reading of "eight hours off" that fires between two jobs on one
continuous day. Registered in [../payroll/gaps.md](../payroll/gaps.md).

Our pricing chain (`CHAIN_GAP_HOURS = 8`, `packages/payroll-engine/src/calculate.ts:456`) already
carries cumulative hours across entries, so **Brian's issue #2 does not exist in the ERP** — we price
his `43770` at DT today.

## Still open

Overlapping FCC labor entries. Brian: *"in FCC sometimes there are overlapping labor entries as
well... not sure if/how we will handle overlapping labor entries in ERP yet... we can discuss next
meeting."* Registered in [../payroll/gaps.md](../payroll/gaps.md).
