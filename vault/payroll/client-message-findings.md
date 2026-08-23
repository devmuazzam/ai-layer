---
title: Client message verification — running findings
status: reference
kind: reference
updated: 2026-08-24
tags: [module/payroll, kind/reference, payroll-rules, open-questions]
---

# Client message verification — running findings

One section per verified client message. Each claim: **agrees / contradicts / new** against
the rule register (`rules/`), the live gaps register, and the meeting record. The meeting
sheet ("in this meeting you said X, the rule says Y, your message says Z") is assembled from
the ⚠️ rows.

## 2026-06-09 — Payroll-group determination (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| 5 payroll groups, exact predicates (`L12%`, `EmpTypeID=3`, `ADMIN%`+`H/S`, `SYS%`) | ✅ agrees, row-for-row with current-state + extract | PAY-009 |
| Labor-entry craft (not employee craft) prices L12 rows | ✅ agrees with rule + engine — **⚠️ but the 2026-08-13 recording says the opposite; message is the earliest written source. CLIENT QUESTION #1** | PAY-010 |
| Modifier only when selected on labor entry; `PayRateChange` amount | ✅ agrees; adds the selection condition. Into-rate vs on-top still open | PAY-011 |
| `Source_Rate_Raw` audit-only; duration-based fallback with warning | ✅ agrees; confirms extract §13 semantics (fallback → suppress). Which survives in ERP still open | PAY-014 |
| Admin Hourly: `Employee.PayRate`, CA DIR rules, ×40/×2080 approximations | ✅ agrees (approximations verified in `v_UI_Employee_TypeRate.VIEW.sql`) | PAY-012, PAY-025 |
| Admin Salary: may lack PayRate, scope "still undecided" | ✅ matches the rule's open scope | PAY-013 |
| `SYS%` hidden | ✅ agrees — 🆕 written exclusion pattern; current-state describes a broader set (fake/default) — confirm which | PAY-007 |
| Worklist: Active + Inactive-with-labor for the week | 🆕 new detail, consistent with extract | PAY-061 |
| FCC profile screenshot: **"Certified Pay" checkbox** | 🆕 **in no vault document** — certified-pay flag exists upstream today | PAY-072 |
| Union field greyed on profile; union comes via craft | ✅ consistent | PAY-009 |

**Client questions from this message:** (1) rate resolution — app prices by labor-entry
craft (your 2026-06-09 message), practice pays the employee's own rate (Kyle/Corrina,
2026-08-13), Brian proposed higher-of: which ships? (2) exclusion set — `SYS%` only, or
also fake/default? (3) what does the FCC "Certified Pay" checkbox drive today?

## 2026-06-09 — FCC time-trust FYI + ticket exhibit (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| "Can't trust the date/time values in FCC" | ✅ agrees — it is the documented premise of the whole time-reconstruction family | PAY-017/018/019/020 |
| "Payroll App uses creative-magic to reconstruct" | ✅ **already decoded in the DB extract**: punches → 30-min slices; no usable start/end → assume 06:00 + hours, flag `Shift_Assumed`. No need to wait for "I can explain later" — confirm our reading | PAY-018 |
| Ticket 45888 exhibit: 0.00 vs 0.98 vs 48.00 hours | 🆕 new exhibit, now cited on the rules; sharpens PAY-017 — the legacy engine has **no configured source priority**; that mechanism is a new ERP design needing exactly this case adjudicated | PAY-017, PAY-060 |
| Workflow timestamps roll 6/6 → 6/7 | ✅ live cross-midnight case | PAY-019 |

**Client questions from this message:** (4) for ticket 45888's three disagreeing sources —
which should the ERP have priced, and are 24.00-h/person rows flag-and-price or block?
(5) confirm our decoded reading of the reconstruction (assumed 06:00 + hours) so "explain
later" is closed in writing.

**ERP-side note:** the workflow column in this exhibit is the data the Atom field app will
own natively (timestamped Left Yard → signatures → Arrive Yard). The reconstruction rules
remain necessary for FCC-migrated history and any parallel-run period — not for tickets
born in the new app.

## 2026-06-09 — 23.5-hour cap + split convention (Brian Petros, follow-up)

| Claim | Verdict | Register |
| --- | --- | --- |
| App handles ≤ 23.5 h per labor entry | 🆕 new fact, in no vault document; explains the exhibit's 24.00-h rows | PAY-004, PAY-018 |
| ">23.5 h reconstruction logically impossible" | ✅ consistent — 23.5 = 24 h minus one half-hour slice; (date, duration) reconstruction can't disambiguate ≥ 24 h. Our derivation, to confirm | PAY-018, PAY-020 |
| Remedy: back-to-back entries, each < 23.5 h | ✅ convention now recorded | PAY-004 |
| "Programmed to handle that for all of the rules" | ✅ **verified against the extract**: `ChainGroup` (< 8 h apart → one shift), `ShiftAnchorDate` grouping for guarantees/daily rules, cumulative OT/DT across midnight, `Rest_ChainId` (≤ 30 min) for rest. WTL charts band to 25 h — long *shifts* via chained *entries* were always the design | PAY-023, PAY-045 |

**Client questions from this message:** (6) should the ERP inherit the 23.5-h entry cap and
split convention (needed for FCC-migrated data) or represent long spans natively for
ERP-born entries — or both, with the cap applying only to reconstructed/imported rows?
(7) the extract shows **two** chain thresholds — shift chain < 8 h apart, rest chain ≤ 30 min
apart. A split gap between them (e.g. 45 min) chains the shift but breaks the rest chain.
Confirm both thresholds and that interaction are intended.

## 2026-06-10 — post-demo reflections + WTL double-time realization (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| "WTL is priced automatically at double time" | ✅ agrees — and the vault is **more precise**: add = 0.5 × (base + shift) × 2.0, boom excluded (`BASE_PLUS_SHIFT_EXCLUDE_BOOM`), plus the `WTL_DT_FLOOR` top-up nuance for weekday ST-start blocks | PAY-047 |
| Screenshot slice grid | ✅ decomposes to the cent: base 66.03 + shift-2 3.00 + boom OP-BP-07 5.25 → $111.42 @1.5; the +$69.03 add **is the extract's own worked example (entry 84393)** | PAY-047, PAY-036, PAY-011, PAY-021 |
| Deduct −$55.71 vs add +$69.03 | ✅ documented, deliberate asymmetry — deduct loaded incl. boom, add excludes boom. ⚠️ contract question: is boom-exclusion MLA-compliant/intended? | PAY-047 |
| "Couldn't explain why WTL was higher" (June-9 demo) | ✅ on tape — demo-01 33:20 / 41:51 / 43:19 / 44:00 | — |
| Takeaway 2: "explain the configuration tables for migration" | ✅ **satisfied since** — the 2026-08-18 extract captured every config row (`cfg.WTL_Rule`, `cfg.Union_Master_Rules`, …); confirm nothing moved after 2026-08-18 | — |

**Client question from this message:** (8) the WTL add excludes the boom adder while the
deduct includes it — deliberate per config; confirm it is *intended* and MLA-compliant, and
state the composition rule per component in the adjudicated into-rate-vs-on-top decision.

**Meta, worth saying in the meeting:** Brian's "nearly impossible for a human mind to
remember all of it" is the problem the rule register now solves — each `PAY-###` file joins
the rule, the engine behaviour, the config row, and the open question. His takeaway #1
(explain from user experience) and #2 (config tables) are both standing answers now, not
presentation work.

## 2026-08-24 — ADP product identity (team exchange; Patrick via client)

| Claim | Verdict | Register |
| --- | --- | --- |
| "We are with workforce" | ✅ agrees — gap already resolved 2026-08-13 as **classic WFN**, from a live practitioner-session screenshot | PAY-067, gaps → *ADP product…* |
| "…upgrading to next level soon" (WFN **Next Generation**) | 🆕 **material new fact** — the 2026-08-13 resolution explicitly ruled *"classic WFN, not Next Generation — the documentation set is therefore the correct one."* Every ADP reference doc now carries a validity caveat; an undated upgrade is a timer on all of it | PAY-067; caveats on adp-api-responses/, adp-read-write-boundary |
| Interim: manual CSV upload in the ADP browser UI | 🆕 stated bridge process — refines, does not decide, the open **Excel-or-API** submission gap | PAY-067, gaps → *Excel or API* |
| Patrick | TCG systems/IT side (transcripts: "it's kind of more of a Patrick thing"); now the named owner of the upgrade question | — |

**Client questions from this message:** (9) WFN Next Generation upgrade — **date, scope, and
whether API Central entitlements/endpoints carry over**, in writing from Patrick; agree that
the ADP integration research gets re-validated at upgrade, and ideally that the upgrade is
sequenced *around* the ERP integration build, not into the middle of it.

## 2026-08-24 batch — weekly Sat–Fri payroll, both groups (client)

| Claim | Verdict | Register |
| --- | --- | --- |
| Weekly, Union and non-Union, always Saturday–Friday | ✅ **full agreement, quadruple-sourced** — matrix (the register's only settled rule), live ADP schedule (27/27 periods), engine hard-coding, FCC profile (Pay Cycle: Weekly) | PAY-001, PAY-025 |

**Client questions from this message: none** — first message to verify completely clean.
One design note carried forward: build ERP periods from ADP's `payPeriodID` rather than
computing weeks, so the two systems can never disagree.

## 2026-08-24 batch — "custom AI agent" pack + labor tables + buckets (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| "I built a custom AI agent… 00–11 + checklist" | ✅ **already in the vault** — it is the 2026-06-23 knowledge pack, migrated 2026-08-13 as `payroll-app-current-state/` (9 files), with every skipped file declared and reasoned. The 2026-08-18 DB extract **supersedes** it by the pack's own source ranking (extract = rank 1, pack = rank 3) | — |
| `PayrollAPP_0.5` in `OneDrive_1_8-11-2026 (2)` | ✅ inspected — **byte-identical** to drop (1) except a `.DS_Store`. Zip fully unpacked and accounted for: nothing to update *from* it; the vault is 8 weeks fresher *than* it | — |
| `LABOR_PAYROLL` (raw) is the source; `LABOR_DETAILS` (FCC-processed) "is not good" | ✅ source confirmed (extract feeds from `src.FMS_LABOR_PAYROLL_Raw`); 🆕 the **rejection rationale** was undocumented — now on PAY-004. ERP must read raw labor, never FCC's processed output | PAY-004 |
| Five buckets (after the 6→5 correction): ST/OT/DT/H2×/H3× + LB set + rule-added hours | ✅ matches the extract's ADP sheet columns exactly | PAY-059 |
| "I don't think there is triple time for long boom in the contract — I'll ask Corrina" | ⚠️ **unresolved doubt vs implemented code**: crosswalk ships LBT (boom triple) as CURRENT. Under the MLA into-the-rate clause LB TRI would be *correct* — the answer rides on the into-rate adjudication | PAY-043, PAY-011 |

**Client questions from this message:** (10) did Corrina ever answer the long-boom-triple
question? The crosswalk implements LBT while your message doubts the contract supports it —
and the into-the-rate clause decides which is right.

**Meta for the meeting:** the "custom AI agent" offer is appreciated and already absorbed —
the vault ingested the pack in August and went past it (all 141 SQL definitions, every
config row, live ADP responses). The useful ask is not the pack; it is answers to the ten
questions in this log.

## 2026-08-24 batch — drug-test ticket exhibit: payroll ≠ billing hours (Brian Petros)

| Claim / observable | Verdict | Register |
| --- | --- | --- |
| Payroll hours ≠ customer-billed hours on one ticket | ✅ principle already encoded in Atom **US-18**; exhibit is the canonical payroll-side case — seam now explicit on the rule | PAY-004 |
| Incident 6am → drug test → paid through 1pm return | 🆕 **first live PAY-056 case** (injury/incident-day pay continuation — a "New ERP requirement" with zero prior examples) | PAY-056 |
| Comment: "(NO LUNCH TAKEN - 0.5 DBL 1st WTL + 0.5 DBL 2nd WTL)" | ⚠️ **the finding of the batch** — prose, not `(PAY:WTL_n)`; engine would assume WTL_0 and **deduct** two meals the man worked through. Production: 9,297 no-token warnings; deducts 16,106 (−$669k) vs adds 411 (+$27k) | PAY-047 |
| Hours Worked 15.00 vs Derived Hours 14.50 | 🆕 entered-vs-derived mismatch — concept previously undocumented | PAY-004, PAY-060 |
| 14.5-h span → 2 expected meals; comment says 2 WTL | ✅ bracket math agrees (11–16 h → 2) | PAY-046 |
| Cross-midnight 10:30 PM → 1:00 PM; started before scheduled 12:00 AM | ✅ live PAY-019/PAY-021 context; craft L12-G3-A matches extract worked examples | PAY-019 |

**Client questions from this message:** (11) the WTL numbers — 9,297 no-token warnings and a
16,106-vs-411 deduct/add ratio: does payroll manually correct these tickets today, or have
worked-through meals been systematically deducted? Either answer matters — one is a hidden
manual workload the ERP must absorb, the other is an underpayment pattern to quantify.
(12) incident/drug-test days — confirm the pay-continuation rule (through return-to-yard?
full day? straight time?) so PAY-056 stops being example-free, and confirm the billing side
excludes those hours automatically rather than by hand-edit.

## 2026-08-24 batch — PAYROLL_CURRENT workbooks + ADP fields (Brian Petros; 3.7.1 zip inspected)

| Claim / observable | Verdict | Register |
| --- | --- | --- |
| New Excel (NEW_PAYROLL v1.1) structured for ADP import; Corrina testing the partial sample | ✅ both files migrated 2026-08-19 and **byte-identical** in the newer 2026-08-19 zip — `adp-workbook-column-rules.md` remains current | PAY-067 |
| "Power Query backend not fully developed" | 🆕 status fact, previously unrecorded | PAY-067 |
| "Meeting ADP rep… need to create a few more fields in ADP" | ✅ corroborates the open **earning-code-setup** gap ("a manual prerequisite nobody owns") — owner now emerging (Brian + rep). ADP held **52 live codes** at 2026-08-18: the reconciliation baseline | gaps → *Earning-code setup* |
| 3.7.1 zip (2026-08-19, 349 MB) vs migrated drop | ✅ fully inspected: everything byte-identical **except** the live `July 25-31` week and the **v3.7 Mac master template** (both drifted 2026-08-19 03:0x — drift notes added to their source pages) | sources ×2 |

**Client questions from this message:** (13) what did the ADP-rep meeting conclude, and
which fields/earning codes were actually created? We can pre-compute the missing list by
diffing the crosswalk's required codes against the 52 live codes from 2026-08-18 — then the
question becomes "confirm this exact list", not "tell us everything."

## 2026-08-24 batch — rate changes over time / fiscal-year rollover (Brian Petros, ≈2026-06-30)

| Claim | Verdict | Register |
| --- | --- | --- |
| ERP must manage rate change over time, wages **and** billing | ✅ is PAY-008 ("New ERP requirement") — message supplies the missing *why* | PAY-008, PAY-012 |
| "FCC has no effective dates for union base rates" | ✅ **verified, refined**: `StartDate`/`EndDate` columns exist but are vestigial — rates **overwritten in place** (`corrinab, 2025-08-26`), one row per craft | PAY-008 |
| Historical rates only via previous labor records | ✅ — and better: `Source_Rate_Raw` per-row audit (now load-bearing) **plus** the vault's extract holds the complete **pre-rollover FY25-26 table** (06-23 backup) that FCC can no longer produce | PAY-014, PAY-008 |
| Fiscal-year (July–June) change per group/type; "changing rates tonight at midnight" | ✅ MLA increase table confirms 7/1 cadence; three-way tie-out (MLA $66.03/$67.87 = FCC rows = extract examples). ⚠️ **FY2026-27 per-group rates are underivable** — MLA shows the $5.00 total, allocation column blank | PAY-010 |
| Billing rates for invoicing — "not sure yet" | 🆕 `UNION_CRAFT.BillingRate` is a dead path (0.000 everywhere); pricing-sheet effective-dating has **no design** — new quotations-side gap entry | quotations/gaps.md |

**Client questions from this message:** (14) the **FY2026-27 rate sheet** — per-group wage
allocation of the $5.00 increase, in writing, plus the updated craft-modifier amounts; confirm
our reading that the 06-23 extract snapshot is the authoritative FY25-26 historical table for
migration-era recalculation. And the billing side: where should pricing-sheet rates be
versioned in the ERP (the quotations gap)?

## 2026-08-24 batch — the big summary (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| Rounding: start **down**, end **up**, 30-min, everyone | ✅ **three-way agreement** — client = engine (`usp_Prepare_Continuous_Labor`) = MLA. FRD approval item collapses to a confirm-in-writing | PAY-020 |
| Cross-midnight: "entire job associated with the start date" | ⚠️ **contradicts the engine**, which flips day-type at 00:00 per slice (anchor governs grouping/guarantees only). Fri 10 PM → Sat 4 AM: Saturday premium after midnight, or not? **PAY-019 escalated to conflicted** | PAY-019 |
| Wed completion deadline, Thu checks | 🆕 operational window; consistent with the live ADP six-day close-to-pay gap | PAY-002 |
| ST/OT/DT boundaries, 6–5 window, Sat OT / Sun DT, >8/>12 consecutive, holiday ×3, June+Dec specials ×2, 4-h/8-h guarantees, 5-h lunch cadence, shift-diff pay+time adds, subsistence | ✅ all agree with the register and engine — nine rules re-confirmed in one message | PAY-021/023/024/030/031/033/034/040/046 |
| "Rarely ever work under a different craft code" | ✅ context — softens the practical frequency of the PAY-010 rate conflict, resolves nothing | PAY-010 |
| 8-h rest: "<8 h between labor = one labor" | ✅ describes the **shift chain**; the rest-*premium* (PAY-045) is a separate mechanism his summary omits. Three grouping thresholds now explicit (any-gap WTL / 30-min rest / 8-h shift) | PAY-023, PAY-045, PAY-046 |
| "Know which lunches worked through **and at what time**" | ✅ wish already exceeds tokens — exactly what Atom US-11 structured capture provides | PAY-046/047 |
| ADP import scope (buckets + temp-rate rows + SUB dollars + non-union sick) | ✅ matches the crosswalk row-for-row; PAY-073's as-is now precise | PAY-067, PAY-073 |
| ADP access: prod granted to Brian, **dev account not created**, rep meeting next week (Corrina) | ✅ consistent with the 2026-08-17 test-company request; join/recording requested | PAY-067, gaps |

**Client questions from this message:** (15) rounding — client and engine agree (start down,
end up, everyone): turn it into a written decision so PAY-020 settles. (16) cross-midnight
day-type — your summary says anchor-date, your engine flips at midnight: which ships? (A
Friday-night crew's Saturday hours hang on it.) Plus: (13-update) Corrina's ADP-rep meeting —
we'd like to join, or at minimum receive the recording.

