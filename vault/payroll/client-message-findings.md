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

