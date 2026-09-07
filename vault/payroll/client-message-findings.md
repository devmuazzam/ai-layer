---
title: Client message verification — running findings
status: reference
kind: reference
updated: 2026-09-07
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

## 2026-08-24 batch — architecture + status (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| RawFMS = warehouse copy of **40** FCC-NexGen tables; PayrollAPP db = the logic | ✅ **exact** — source-feed.md documents precisely 40 `src.*` tables; architecture doc has the same two-db diagram and the no-write-back rule | — |
| Refresh flow (Web → API → PayrollAPP procs → check NexGen → update RawFMS → process → return) | ✅ matches `api.usp_UI_RefreshPayroll_FromNexGen` + the documented flow | — |
| "Haven't made many changes since that backup" | ✅ **validity statement for the extract** — our 06-23-backup-based extract is ≈ as-built current, per the client's own word | extract INDEX |
| Known issues: hours display in some rule scenarios | ✅ corroborates 08-known-issues; status = still open upstream | PAY-062 |
| "~30 basic scenarios identified"; Corrina robust testing planned | ✅ almost certainly our 28-row rule-examples catalog — proposed as the joint ERP acceptance baseline | rule-examples-catalog |

**Client question from this message:** (17) share the exact ~30-scenario list and the current
known-issues delta since the June pack — we'll reconcile against our 28-row catalog and
propose the union as the joint ERP acceptance baseline, with Corrina's robust-testing pass as
the sign-off fixture.

### Follow-up — raw extract zip (`PAYROLL_CALC_EXTRACT.zip`, first use of the DB folder)

**Question 16 sharpens dramatically.** The cross-midnight day-type behavior is a **config
switch with both policies implemented and a 10-case test harness**: `CalendarDay` active
("default **until Payroll Manager confirms otherwise**"), `AnchorFloor` built and waiting
("use if Payroll Manager wants…"). Brian's summary described the inactive policy — loosely:
`AnchorFloor` is a max, so even it pays Saturday premiums post-midnight on a Weekday→Saturday
shift, which his pure-anchor summary would deny. **The ask is no longer a design debate — it
is one question to Corrina and one config flip**, and the harness's 10 cases enumerate every
consequence (case 2: Holiday→Weekday = 240 vs 420 premium minutes between the policies).
Bonus: `cfg.RestPeriod_Rule` shows the 30-min rest-stitch gap is config, with `TriggerMode`
deliberately changed from its default — folded into question 7.

**Note for question 14:** all local backups predate the July-1 rollover. A **post-July pull**
of `UNION_CRAFT` (or the new rate sheet) is the artifact that answers the FY2026-27 rates.

## 2026-08-24 batch — added-hours doctrine (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| WTL / guarantees / shift-diff add hours, priced "as if worked", placement matters | ✅ doctrine confirmed — **verbatim** for shift adds (last-slice multiplier, appended at end); holiday gaps at the day's multiplier; daily-min coincides at ×1.0 | PAY-033/036/037/040 |
| WTL Type 1 placement: actual time if known, else 5-hour schedule | ✅ exactly the engine's opportunity placement | PAY-046/047 |
| Deduct-then-add-back framing; Type 1 → double | ✅ literally the engine's model (`WTL_DT_FLOOR`) | PAY-047 |
| **Type 2 penalty → triple during triple-time periods** | ⚠️ **contradicts the engine**: flat ×2.0 in formula and config, no ×3 branch. Client-stated intent vs as-built | PAY-047 |
| "As if worked" for long-boom gap | ⚠️ nuance: engine pays **boom adder only**, not full rate | PAY-043 |
| Added hours invisible to overlap/back-to-back logic | ✅ by construction (components, not windows) — now an explicit ERP invariant | PAY-029 |
| Per-rule componentized reporting | ✅ the ledger's design goal, already exercised by this very log | PAY-059 |

**Client question from this message:** (18) the holiday WTL penalty — your message says the
30-minute add becomes **triple** in triple-time periods; the engine pays a **flat ×2.0**
(config `cfg.WTL_Rule`, no ×3 branch). Which is the rule? (The WTL charts and the MLA meal
clause should decide; on 9 holidays a year the difference is real money.)

## 2026-08-24 batch — phantom-hours re-emphasis (Brian Petros)

Standalone re-send of the added-hours exclusion passage — no new content, but the repetition
is signal: **PAY-029's invariant (added hours are ledger components, never time windows) is
now marked client-emphasized** and should carry its own acceptance test. For reference, the
engine's complete hours-adder inventory with production totals is pinned in the chat record:
WTL adds (542 uses), long-boom min (4,107 — the most frequent), daily min (509), special-Sat
min (32), holiday min (8), shift hours-add (3). Reporting-time (PAY-039) has **no** ledger
component — a matrix-only rule the legacy never implemented.

## 2026-08-24 batch — rest-rule exclusion + infrastructure reality (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| Added hours must not affect the 8-hour rest rule | ✅ by construction (windows vs components) — with one precise residual check: does `HrsOTDTPositive` read actual or payable OT/DT? (holiday gap hours report as DT) — folded into question 7 | PAY-045 |
| SQL Express → no Agent → Windows Task Scheduler | ✅ **answers an open item the extract itself recorded** ("Task Scheduler not inspected"); `cfg.Nightly_RunSettings`: 210-day lookback | extract INDEX |
| Everything runs on Brian's desktop, free-tier, firewall to backups | 🆕 full blast radius now explicit; "someday, maybe, Patrick" gates proper hosting | architecture doc |

**Client question from this message:** (19) hosting & parallel-run risk — confirm the ERP
carries **no on-prem custom-app dependency** (fully cloud-hosted sidesteps the Patrick gate
entirely), and for the parallel-run period: what is the backup cadence and off-machine copy
policy for the desktop that currently *is* production payroll?

## Cross-module note — accounting wishlist (July 2026, captured 2026-08-24)

Not a payroll message; captured to [accounting/2026-07-accounting-team-erp-wishlist.md](../accounting/2026-07-accounting-team-erp-wishlist.md)
with its module INDEX routing and a scoping gap for the ~Oct–Nov kickoff. Payroll-relevant
spillover: **certified payroll / Davis-Bacon / prevailing wage named a third time** (PAY-072
strengthened); per diem, shift differential, multiple rates, OT all already in the register.

## Cross-module — invoicing-adjustment taxonomy (Tia & Micaela, ~2026-07-28)

Captured to [accounting/2026-07-invoicing-adjustment-taxonomy.md](../accounting/2026-07-invoicing-adjustment-taxonomy.md)
with live ticket exhibits (flat tire 46126, hydraulic leak OM60120, damaged slings, THUMS
training OM58898). Completes the **payable ≠ billable seam from both sides** (message 8's
drug-test case is on the deduct list). Payroll spillover recorded: e-ticket already collects
lunch **times** (checklist, not data — strengthening the PAY-047 structural-capture case) and
subsistence enters as deficiency-click + long/short comment (the token origin, PAY-048).

**Client question:** (20) is the taxonomy complete enough to encode — cause-coded downtime →
automatic invoice disposition (deduct / document-only / fee / crew-time)? Auto-invoicing from
actuals (the accounting wishlist) requires it. Sub-parts: who adjudicates "incorrect leave
time"; where does the damaged-rigging replacement price come from; and should "crew time"
(training) be a first-class billing category instead of an Equipment-field note?

## ~2026-07-28 — ADP progress: company code + earning codes (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| Company code changed **631 → 4RZ**, still Workforce Now | ✅ **closes two open gaps at once** — "What `631` actually is" (answered) and the 631-vs-4RZ identifier conflict (a rename, not two entities). Filename corroboration: `EPI63100.CSV` old vs `EPI4RZ32.csv` new | gaps ×2, PAY-067 |
| Hours & Earnings codes updated/added on the Validation Table | ✅ the message-9 "few more fields" **were created** — and the 2026-08-18 52-code pull post-dates the update, so our reconciliation baseline is current | PAY-067 |
| Met Corrina + ADP rep several times; next meeting Thu Jul 30 3 PM PST, CC invited | ✅ question 13's meetings happened; remaining ask: recording/notes + exact added-code list | PAY-067 |
| Focusing on payroll ~2 weeks, pre-ERP automation | status fact — consistent with the Aug 4/6/12/13 payroll-meeting cadence in the vault | — |

**Question 13 partially closed.** Remaining sub-asks folded in: (a) July-30 meeting recording
or notes; (b) the exact list of added codes (or we run the crosswalk-vs-52 diff and hand them
the delta to confirm); (c) confirm every downstream artifact was updated for 4RZ — the
workbooks' Power Query and any hardcoded 631.

## ~2026-07-29 — validation-table walkthrough + code changes (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| Added: shift-diff 2/3, **long-boom holiday triple**, lattice oiler/operator | ✅ **vault had already detected it**: these exact families were June-absent and are present in the 8-18 pull. The LBT addition flips question 10 — practice committed to LB triple *after* Brian doubted the contract; get the confirmation that motivated it | PAY-067, PAY-043 |
| Removed one unused code; changed a holiday code "to add to total hours" | 🆕 identities unknown — residual of the earning-code gap | PAY-067 |
| Code calculations hidden in ADP's backend (rep statement) | 🆕 **design constraint**: ERP computes everything; ADP codes are labeled buckets; verification = ADP-support ask | PAY-067 |
| Download exists but incomplete | ✅ noted — our live API pull post-dates the changes and is the better artifact; fresh download only as a re-baseline before the export build | PAY-067 |

Holiday-triple practice extension also strengthens the client's WTL ×3 claim (question 18) —
the engine's flat ×2 increasingly reads as the defect.

## ~2026-08 — lattice pay details (Brian Petros + Corrina's 5/18 citation + page-39 scan)

| Claim | Verdict | Register |
| --- | --- | --- |
| $1/hr operator, $0.50/hr oiler, Group 6+ (MLA p.39) | ✅ **verbatim, four ways**: Corrina's citation = the client's own scan = the vault's MLA extraction = the register's existing Group-6+ trigger. Also closes the attribution register's "Group 6 never mentioned in recordings" hole | PAY-044 |
| Only one lattice crane — the Crawler | ✅ matches Joe's 08-04 answer | PAY-044 |
| Jeff Stricker: luffers are "technically lattice" | ⚠️ **contradicts Joe's 08-04 classification** (luffing jib = boom pay only). Kyle adjudicates | PAY-044, gaps |
| Boom Type via asset subcategory | 🆕 identification design candidate, asset-driven — consistent with "every dispatch qualifies" | PAY-044 |
| Lattice absent from the app code; two ADP codes added | ✅ both already established (extract; message 18) | PAY-043/044 |

**Client question:** (21) luffer classification — Jeff says lattice, Joe said boom-pay-only:
Kyle's ruling, in writing; and confirm Boom-Type-on-subcategory as the identification
mechanism (or name the per-job alternative).

## 2026-08-24 batch — Kyle's lattice answers (via Brian)

| Claim | Verdict | Register |
| --- | --- | --- |
| Only Group 6+ work lattice (qualification) | ✅ confirms the encoded Group-6+ trigger *and* explains it — dispatch self-enforces | PAY-044 |
| Lattice jobs ≥ 1 week, month+; config per-job, stable | 🆕 operational facts → **job-level "Boom Configuration" field** (supersedes asset-subcategory idea); schema ask filed in projects-jobs/gaps.md | PAY-044, projects-jobs |
| **Lattice pay covers the entire job** (Corrina, contract) | 🆕 decisive scope clarification — contrasts with long-boom's window scope; they stack; implementation collapses to job-flag + group ≥ 6 → all hours | PAY-044, PAY-043 |
| Luffer ruling | ⚠️ **not addressed** — Kyle engaged but the Jeff-vs-Joe question wasn't relayed. Question 21 narrows to exactly this | PAY-044 |

**Question 21 (narrowed):** Kyle is already on the topic — one more ask: luffers, lattice
premium or boom-pay-only? Plus confirm the "Boom Configuration" field's home (job vs
quotation) and values.

## 2026-08-24 batch — workbook updated for new ADP codes (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| Payroll Excel updated for the new ADP codes; auto-generates the import file | ✅ **explains the exact drift message 9 detected** (July week + v3.7 Mac template, both saved 2026-08-19 03:0x) — drift notes on the source pages now carry the why | sources ×2, PAY-067 |
| Files in "PAYROLL for ADP v3.0 - current" | ✅ already inspected (message 9); sample export verified: `4RZ` throughout, Temp-Rate/Hours-4 architecture live, new codes event-driven-absent | EPI4RZ32 source page |

Stale-631 audit (question 13 residual) largely resolves for the active pipeline; remaining:
v3.7-Mac internals and crosswalk rows.

## 2026-08-24 batch — "review these four documents; too many details?" (Brian Petros)

The four root-level documents (Rule Matrix, ERP Payroll Module PDF, ADP Bucket Crosswalk,
MCOG payroll-specific summary) are the **already-migrated core** of the payroll vault —
byte-identical in the shared folder to the migrated copies (message-9 comparison). Status of
each: matrix → the spine of the 73-rule register; PDF → the 11-part FRD (its PR-### ids
reconciled against the matrix's independent numbering); crosswalk → reconciled against the
live 8-18 ADP pull (9 open decisions tracked); MCOG summary → cross-checked against the
full MLA extraction (lattice paragraph verified verbatim against the client's page scan).

**Answer to his questions, recorded:** the details are not too many — they are the
requirements; his own June message said no human mind can hold them. The fix was
organization, not reduction: one page per rule, every source joined. His "80%" estimate is
about right — the register identified the missing ~20% as five uncatalogued rules
(money rounding, foreman, military-base, certified-payroll scope, sick/PTO scope), 13
conflicted items, and 21 concrete questions. **Meeting design implication: do not page
through the documents** — most details are already verified three+ ways (client statements =
engine = contract). Adjudicate the question list instead; each item is pre-reduced to
"confirm A or B, here is what each costs."

## 2026-08-24 batch — "most recent payroll processing" pointer (Brian Petros)

Pointer to the already-inventoried `PAYROLL for ADP v3.0 - current` folder (July 25–31 week
workbook + `EPI4RZ32.csv`). No new content; confirms intent — a **reference copy of a real
processed week**. Marked as the natural **golden-week acceptance fixture**: replay July 25–31
through the ERP engine, expect the same export (joins the 28-row scenario catalog as the
second leg of the acceptance baseline, question 17).

## Backlog — v3.8 template + SOP announcement (Brian Petros)

Announcement of artifacts the vault already holds: the v3.8 master template (sources page)
and **SOP v3.8** ([adp-sop-v3.8.md](adp-sop-v3.8.md) — the documented current process). Both
byte-identical across drops. Value: dates the v3.7 → v3.8 transition and the SOP's creation;
the workbook lineage in the vault is now v3.7-Mac (live-updated 8-19) · v3.8 master + SOP
(stable) · NEW_PAYROLL v1.1 (the successor input workbook).

## Backlog — Certified Payroll Playbook (photographed, ~post-08-04 meeting)

| Claim / content | Verdict | Register |
| --- | --- | --- |
| Full intake-to-gate certified-payroll process | 🆕 **first coverage ever** — PAY-072 goes from "no vault coverage" to process-documented; captured as [certified-payroll-playbook.md](certified-payroll-playbook.md) | PAY-072, gaps |
| "Mark Labor compliance in FCC" | ✅ connects to the FCC "Certified Pay" checkbox (message 1) — the flag's purpose identified | PAY-072 |
| WH-347, DIR Project ID, wage determinations, agency list | 🆕 concrete deliverable + triggers named | PAY-072 |
| "Labor Compliance" function; NO-GO scheduling gate | 🆕 business owner candidate exists; the ERP question narrows to the automation split (intake → quotations/jobs; reporting → PAY-072) | PAY-072 |
| "Ready to Schedule Value Engine" | 🆕 undefined pipeline term — glossary candidate | — |

**Question 72-family (updated):** with the business process now documented, the ask becomes —
who owns Labor Compliance (name), and which playbook steps does the ERP automate vs keep
manual? Plus: define "Ready to Schedule Value Engine."

## Backlog — Foreman & Military premium specification (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| Full two-premium spec (rates, eligibility, Jeff Kelley, tokens, Excel convention, ADP codes) | ✅ **this is the origin message of `foreman-and-military-premiums.md`** — already captured faithfully on 2026-08-09 | PAY-070/071 |
| ADP code families FR*/ML* | ✅ live in the 8-18 pull; closes its "ML* in no TCG document" flag; **TRI buckets prove the premiums multiply** (into-rate) | PAY-011 |
| "Payroll App finds the token" | ⚠️ **contradicts the extract** (whitelist ignores unknown tokens; "not calculated anywhere") — either post-backup change or intent-as-current. Verify | PAY-070/071 |
| Foreman = company rule (union employees only); Military = union rule, job-scoped all-hours-all-employees | ✅/🆕 rule-character distinction recorded; military mirrors lattice's job-level shape | PAY-070/071 |

**Question (22):** verify the app's actual FOREMAN/MILITARY token handling against the live
database (one re-extract or one query); and confirm the ERP capture design — military as a
job-level flag beside Boom Configuration, foreman as a dispatch crew-role assignment — both
replacing comment tokens.

---

# SELF-CLOSURE SWEEP — 2026-08-24

Per instruction: close the questions from the record itself (recordings, folders, SQL,
contract, workbooks) before asking the client. Result: **22 → 5.**

| # | Question | Outcome |
| --- | --- | --- |
| 1 | Rate resolution | **CLOSED — decided 2026-08-20 on-call** (craft-locked overrides, super/payroll-assigned). Decision note written; PAY-010 **settled** |
| 2 | SYS exclusion set | **CLOSED as-built** — `SYS%` predicate + 2-row `cfg.PayrollUI_ExcludedEmpID` |
| 3 | Certified Pay flag | **CLOSED** — playbook identified its purpose (labor-compliance population) |
| 4 | Ticket 45888 | **CLOSED as design** — beyond-cap rows reject at import for splitting |
| 5 | Reconstruction reading | **CLOSED** — verified against the extract's own documentation |
| 6 | 23.5-h cap inherit/native | **CLOSED as design** — native for ERP-born, cap+split for imported rows |
| 7 | Chain thresholds + trigger lineage | **CLOSED** — lineage code-verified (actual-only, phantom-proof); thresholds deliberate per config |
| 8 | WTL boom exclusion MLA-compliant | **CLOSED** — MLA: "double time **the straight hourly rate**"; config is contract-consistent |
| 9 | WFN Next-Gen timing/scope | **REMAINS — Patrick** |
| 10 | LB triple contract basis | **CLOSED** — into-the-rate clause makes holiday ×3 apply to base+boom; LBT operationalized |
| 11 | −$669k: manual fix or underpayment | **CLOSED** — 08-20: the app is **shadow-mode**; manual entry ships. No underpayment |
| 12 | Incident/drug-test pay rule | **CLOSED** — MLA verbatim: drug-test time *is work time* (DOT clause); injury = full day straight-time, physician determines |
| 13 | ADP-rep outcomes + code identities | **CLOSED** — meetings happened; removed = `SD` (+`LOB` stub); changed = `HOL` → "Holiday Triple"; additions enumerated & live |
| 14 | FY2026-27 rates | **CLOSED** — extracted from TCG's own `CraftRates` sheet: G1–G9 **+$1.00** (wage share of the $5.00), apprentices +0.60–0.90 |
| 15 | Rounding decision note | **CLOSED** — note written (client = engine = MLA); PAY-020 **settled** |
| 16 | Cross-midnight policy flip | **REMAINS — Corrina** (the config's own note awaits the Payroll Manager; one ask, one flip, harness ready) |
| 17 | Scenario-list reconcile | **CLOSED** — his `Examples_Catalog` sheet *is* the vault's 28-row catalog; baseline agreed by construction |
| 18 | Holiday WTL ×2 vs ×3 | **CLOSED — engine was right**: flat 2× penalty (MLA + charts + engine + 08-20 SME); message 13 conflated Type 1's stays-at-triple |
| 19 | Desktop backup / hosting | **REMAINS (ops half)** — ERP-side no-on-prem stance recorded; backup cadence is TCG's to answer |
| 20 | Encode invoicing taxonomy | **CLOSED as design**; two client sub-parts remain (who adjudicates "incorrect leave time"; rigging replacement price source) |
| 21 | Luffer classification | **NARROWED to formality** — MLA Groups 5/7 put luffing boom under **Long Boom pay**; Kyle confirms against text |
| 22 | Token implementation | **CLOSED** — zero FOREMAN/MILITARY in the extract SQL; spec was target-state |

**The 5 that genuinely need the client:** (9) Next-Gen upgrade date/scope — Patrick ·
(16) cross-midnight config confirmation — Corrina · (19) desktop backup cadence for the
parallel-run · (20a/b) late-leave adjudicator + rigging replacement price source ·
(21) luffer confirmation — Kyle, contract text attached. Plus three courtesy FYIs (the two
decision notes and the FY26-27 extraction) for the client to wave through.

**Register after the sweep: 3 settled · 67 open · 3 conflicted.**

## 2026-08-27 — ADP identifiers: Associate ID vs Position ID vs File Number (Brian Petros, relayed AI research; sender inferred from the 2026-08-25 transcript at 54:47)

Message to Ehtesham & Abdul, "Regarding the IDs in ADP… here is the best technical explanation I
have", forwarding an AI-assisted read of ADP's Worker API docs, *GUIDE – ADP Importing Paydata*,
`qADPImportValidation` and our own `Payroll_ADP_Bucket_Crosswalk`. Five screenshots; not a
decision by a named human — the message *recommends* a formal requirement, it does not sign one.

| Claim | Verdict | Register |
| --- | --- | --- |
| ADP identifier hierarchy: `associateOID` (person, unique across ADP) → `workerID` / Associate ID (person, unique within client) → `positionID` (one per position) → Payroll File Number + Company Code (paid position) | ✅ agrees with `adp-read-write-boundary-2026-08-18.md` and gaps → *Employee master* ("ADP mints worker identity"); 🆕 first written statement of the **hierarchy** and of File # belonging to the *position*, not the person | PAY-003, PAY-067 |
| For a paid WFN position, `Position ID = Company Code + File Number` (`ABC` + `123456` → `ABC123456`), system-generated | 🆕 new fact; consistent with ADP samples. Company codes here are `4RZ`/`4RY`, not `ABC` | PAY-067 |
| **One employee may hold several positions, each with its own Position ID / File Number** — ERP must not assume one File # per employee | 🆕 **material**: `model Employee` carries a single nullable `adpFileNumber` and nothing else ADP-shaped. Contradicts the built shape, not any written rule → **new gap** below | PAY-003 |
| Proposed ERP model: `Employee{ADPAssociateOID, ADPAssociateID}` + `EmployeePosition{ADPPositionID, ADPCompanyCode, ADPPayrollFileNumber, IsPrimary, status, effective dates, ADPJobCode, ADPPayGroup}`; payroll transactions reference the **position**, not the employee | 🆕 proposal; unbuilt, unticketed. Converges with `decisions/2026-06-30-adp-erp-employee-data-ownership.md` (ADP masters the legal record) | PAY-003 |
| Current Excel/Power Query export identifies rows by `Co Code + Batch ID + File #`, first three fields per ADP's guide; no Associate/Position ID is sent | ✅ agrees — `EPI4RZ32.csv` verified 2026-08-24; crosswalk §4 temp-rate rows keyed by File # | PAY-067 |
| Paydata API mirrors this: `payrollFileNumber` under the payroll profile, `associateOID` on the worker | ✅ agrees with `pay-data-input.modify/meta` (`adp-api-responses/`) | PAY-067 |
| **Crosswalk correction:** implementation note 8 ("File Number… allows uppercase alphanumeric") is wrong; File # is numeric, 51–999999, six positions, enforced by `qADPImportValidation` | ✅ agrees with the **already-closed** gap *ADP File Number — the crosswalk's format rule is wrong* (ADP regex `^0*(5[1-9]|[6-9][0-9]|[1-9][0-9]{2,5})$`). Client now concurs in writing; `adp-bucket-crosswalk.md` §8 text still uncorrected | PAY-067 |
| Associate ID must be stored and "must not be replaced by the payroll File Number" | 🆕 requirement-shaped; not in any FRD/matrix row | PAY-003 |

**Client questions from this message:** (23) does TCG's own ADP data actually contain any
employee with more than one paid position today (Ventura `4RY` vs `4RZ` is the obvious case) —
this decides whether `EmployeePosition` is a day-one migration or a schema allowance; (24) is
the message's requirement block to be treated as **signed** — if so a decision note is owed and
PAY-003's field mapping can close against it.

## Cross-module — 2026-08-27 follow-ups after the FCC migration first pass (Brian Petros)

Message to the TCG team after the 2026-08-26 sprint review. FYI half: CodingCops has imported
"a lot of information from FCC" into the ERP (first pass — contact emails/phones redacted, SSNs
skipped, per the transcript); Brian will say when it is viewable. Six follow-ups for future
meetings, none payroll-owned; each is now an entry (or an update) in its owning module:

| Item | Owning register |
| --- | --- |
| Patrick to explain customer data synced with HubSpot & Microsoft | admin → *Integrations* (updated) |
| Ask owners about "customer-owned assets" | assets → *Customer-owned assets* (new) |
| Employee certification requirements and types (per job / per unit / other) | payroll → *Employee certifications* (new) |
| Unit/asset certifications: registrations, insurance, loan, maintenance, permits | assets → *Unit / asset certifications* (new) |
| Permits can be asset-specific **or** job-specific | projects-jobs → *Asset on a permit* (updated) |
| GL codes in FCC/ERP vs QuickBooks | accounting → *GL codes* (new) |

No claim in it contradicts a written rule; the material new fact is the two-scope permit.

## 2026-09-04 — rule lookback windows, and recalculation across an approved week (Brian Petros ↔ ehtesham.anwar)

Brian, refining the legacy payroll refresh, on why he cannot select a payroll week's dates alone:
*"the payroll rules required labor entries before and after."* His summary card: the non-union CA
procedure calculates **daily OT/DT, weekly OT and seventh-day rules across a Saturday–Friday
workweek**; the **WTL procedure looks 4 days backward and 4 days forward** when forming
meal-period groups; the **rest-period procedure looks 7 days backward**. He volunteers that the
windows are deliberate overshoot — 8-hour rest *"doesn't need a full 7 days… maybe 3–4"*.
Ehtesham replies that 8-hour rest should look back **8 hours**, not 7 days. Brian agrees that is
what his engine does when it *evaluates*, and draws the distinction the thread turns on: his
window is the **initial select** of candidate labor dates out of a data warehouse, *"whereas the
erp will have all labor entries available to it."* He then asks the question that matters.

| Claim | Verdict | Register |
| --- | --- | --- |
| Daily OT/DT, weekly OT and seventh-day run across a **Saturday–Friday** workweek | ✅ agrees — now a fifth independent source | PAY-001 (settled), PAY-023/024/025/026 |
| **Payroll rules need labor entries outside the week being processed** | 🆕 stated as a principle for the first time. **The build does not do this:** `payroll.service.ts:151-155` loads `findCompleteTicketsInRange(weekStart, weekEnd + 1 day)` — the period and nothing else, no lookback, no lookahead | PAY-026, PAY-045, PAY-046 |
| WTL forms **meal-period groups** with a **4-day backward / 4-day forward** window | 🆕 **in no vault document.** Our engine has no grouping at all: WTL fires per job-day off `WTL_TRIGGERS = [5.01, 10.51, 16.01, 21.51]` hours against the mobile-captured `wtlCount` (`packages/payroll-engine/src/calculate.ts:22,56-81`). Either the legacy grouping is a data-warehouse selection artefact, or the ERP's WTL is a different rule wearing the same name | PAY-046, PAY-047 |
| Rest-period procedure looks **7 days backward** | 🆕 as a *selection* window, and Brian calls it overshoot. Not a rule change: PAY-045's rule is an **8-hour gap** with a 30-minute stitch (`RequiredRestHours=8.00`, `StitchGapMinutes=30`) | PAY-045 |
| Ehtesham: look back **8 hours** before the job start; on-job time in that window triggers the rule | ✅ agrees with PAY-045 as recorded, and Brian confirms his app evaluates the same way | PAY-045 |
| **Selection window ≠ rule window** — the pre-select exists because the legacy app reads a warehouse; the ERP holds every labor entry | ✅ sound, ⚠️ **but not automatic**: the ERP's calculate is period-scoped today, so "has all entries available" is a property of the database, not of the code. A rule needing yesterday's entry still cannot see it | PAY-026, PAY-045 |
| Editing a labor entry during review can change **other** entries in the same week — and in a **previously processed/approved/closed** week — with no change to the edited entry's own data | 🆕 **the load-bearing question of the message.** It is not a defect report; nothing has been built for it. `PAY-068` (retroactive correction) is matrix-only, its blocking item literally *"Confirm correction workflow"*; `PAY-066`'s is *"Confirm reopen/correction policy"* | PAY-068, PAY-066, PAY-002 |
| Worked example: a **48-hour labor entry** ending at the very start of a week, or starting at the very end | 🆕 concrete boundary case, unaddressed. Related but not identical to PAY-004's 23.5-hour cap and PAY-019's cross-midnight policy | PAY-004, PAY-019 |

**The ERP's answer to his question today, verified in code — worth sending back to him:**

- `PayrollPeriodStatus` is **`OPEN · CALCULATED · REVIEW · APPROVED · EXPORTED`**
  (`schema.prisma:200-206`). There is **no `CLOSED` and no `REOPENED`** — PAY-002 names seven
  statuses, five are built.
- `calculate()` **refuses outright** once a period is `APPROVED` or `EXPORTED`
  (`payroll.service.ts:139-148`), citing PAY-066: an approved week's snapshot must never move.
  Recalculation is the only path that recomputes anything and it is manual only, never triggered
  by a ticket edit (SCRUM-921 AC5).
- So the honest answer is: **it cannot happen at all right now.** A change that ought to reprice a
  closed week silently does not, there is no reopen, and there is no delta-adjustment path — which
  is exactly the hole PAY-068 was written to fill and nobody has specified.
- One mitigation, and it is luck rather than design: the three rules that most need cross-boundary
  data — **PAY-026 seventh consecutive day, PAY-045 rest period, PAY-046 meal opportunity** — are
  **not implemented in the engine** (`packages/payroll-engine/src` references 007, 012, 013, 020,
  022–025, 027, 032–034, 036, 037, 043, 047, 070). The period-scoped window is therefore not
  currently producing wrong numbers for them; it will the day any of the three is built.

**Client questions from this message:** (25) when a labor entry changes after its week is
approved or exported, does the ERP **reopen** the period, issue a **delta adjustment** into the
current period, or refuse — and who may do it? That is PAY-068 and PAY-066's blocking item, now
asked by the client in his own words. (26) does the ERP's calculate window widen to include
adjacent days, and by how much — or does each cross-boundary rule fetch what it needs? (27) what
*is* a WTL meal-period group, and does the ERP need one, given our WTL is per-day and slot-based?
(28) how is a 48-hour labor entry straddling the Sat–Fri boundary assigned — split at the
boundary, or priced whole into one period?

## 2026-09-04 — long-boom day breakdowns, drive time included (Corrina Bustos, Teams)

Corrina posted two hand-worked day breakdowns to ehtesham.anwar *"to make sure drive time is
computed"*, one for a single job and one for two jobs in one day. **This is the first written
source anywhere in the vault that treats drive time as a payroll concept** — before this,
"drive time" appears once in the whole vault, in
[quotations/mobilization-and-demobilization.md](../quotations/mobilization-and-demobilization.md),
on the billing side. Each day is split into `drive out` / `build up, work, breakdown` / `drive
back`, with **(Long boom pay)** marked on the middle segment only.

**One job — 4:00am to 11:30pm.** Drive `4am-8am`: 2 OT, 2 ST. Work `8am-9:30pm`: 6 ST, 2 OT,
5.5 DBL. Drive `9:30pm-11:30pm`: 2 DBL. Totals **8 / 4 / 7.5 = 19.5**, ties to the clock.

**Two jobs — 6:30am to 1:30am.** J1 drive `6:30-8am`: 1.5 ST. J1 work `8am-5:30pm`: 6.5 ST, 3 OT.
J1 drive `5:30-6:30pm`: **1 OT, 1 DBL**. J2 drive `6:30-7:30pm`: 1 DBL. J2 work `7:30-11:30pm`:
4 DBL. J2 drive `11:30pm-1:30am`: 2 DBL. Totals **8 / 4 / 8 = 20.0** against **19** clock hours.

| Claim | Verdict | Register |
| --- | --- | --- |
| Drive time is **paid** and accumulates toward the 8-hour and 12-hour thresholds exactly like on-job time | 🆕 **first written source.** No payroll rule, FRD part or gap entry had ever stated it. Consistent with the engine by construction (it prices labor windows, not activity types) but never asserted | PAY-022, PAY-023, PAY-024 |
| Hours before 6:00am pay as OT (the `4am-8am` drive splits 2 OT + 2 ST) | ✅ agrees, MLA Article III §A.1 *"outside of regular working hours"*, window 06:00-17:00 | PAY-021 |
| Those pre-6AM OT hours **do not consume the 8-hour straight-time bank** — the day still pays a full 8 ST despite a 4:00am start | ✅ agrees, and this is the **first named-human corroboration** of the engine's *"special pre-6AM ST-bank rule"* (`calculations.md:248`, `...PROC.sql:1056-1114`). The rule had been code-only; `rules-plain-language.md` §2's slice-index prose reads the other way and its own worked example (entry 83338, 04:00-17:00 → 8/4/1) agrees with Corrina. Her breakdown is the tiebreak | PAY-021, PAY-022, PAY-023 |
| The 8 / 12-hour ladder runs **continuously from shift start, across both jobs**, and does not reset for job 2 | ✅ agrees, `ChainGroup` chains entries < 8h apart into one shift | PAY-023 |
| Accumulation keeps counting **past midnight** (the last drive runs to 1:30am and prices as DBL) | ✅ agrees. The example itself does not discriminate `CalendarDay` from `AnchorFloor` (both calendar days are weekdays), but **her reply the same day settles PAY-019** — see the resolution below | PAY-019 |
| **Long boom pay is marked on build-up / work / breakdown only, never on drive time** | ✅ agrees, and corroborates the boom-window scope (`ArrivedJob → LeftJob`) direct from Corrina. Sharpens the PAY-043 vs PAY-044 contrast she drew in message 20: long boom = boom-window slices, lattice = the entire job | PAY-043, PAY-044 |
| Two-job day pays **20 hours against 19 clock hours** — the `5:30-6:30pm` drive carries *"1 ot, 1 dbl"* | ✅ **resolved same day: an error in the hand-worked example**, which she has corrected. Engine's 8 / 4 / **7** stands (ST bank ends 2:30pm, 12-hour mark at 6:30pm). The WTL-folded-into-buckets hypothesis is **dead**: WTL premium stays in the ledger, never in the hour buckets | PAY-046, PAY-047 |
| Neither breakdown shows a **meal deduction** on spans of 19.5 h and 19 h, both in the 3-meal bracket | ℹ️ not a finding. With the extra hour explained as an error, both breakdowns are simply **gross clock spans before meal handling** — they were sent to show drive time, not lunches | PAY-046, PAY-047 |

**Verified against:** `usp_Run_Pricing_Engine` STEP D-E via
[calculations.md](legacy-payroll-app-db-extract/calculations.md);
[rules-plain-language.md](legacy-payroll-app-db-extract/rules-plain-language.md) §2, §4, §5, §10;
[MLA Article III](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md).

**Two questions were sent to Corrina on Teams, 2026-09-04. She answered both the same day.**

**(29) The 19-hour day that totalled 20 paid hours.** Corrina: *"Thank you for bringing the 20
hours to my attention. I have updated it and the extra hour was an error."* A transcription slip,
not a rule. The engine's 8 / 4 / 7 stands and the example has been corrected at her end.

**(30) Crossing midnight into a Saturday, Sunday or holiday.** Corrina: *"the question would remain
irrelevant if they worked into Saturday or Sunday due to the fact that they were already on Double
time. if they were to work into a holiday they would be owned an additional 8 hours at triple time
as the rule is that the ee is owed a minimum of 8 hours."* **This closes PAY-019**, the decision
the engine's own config row parked for the Payroll Manager. Two things settled:

- **The higher rate governs, never a downgrade.** A shift already at DT does not drop to Saturday
  x1.5 after midnight. That is the as-built `CalendarDay` policy read through the no-pyramiding
  precedence chain (`DT` outranks `SATURDAY`), and equally what the inactive `AnchorFloor` (`max`)
  would give. The only reading her answer rules out is Brian's pure-anchor summary, *"the entire
  job is associated with the date in which the labor started"* — which would have paid Friday
  rates straight through a Saturday morning.
- **Spilling into a holiday is holiday work.** Post-midnight slices price at x3 **and** the 8-hour
  holiday minimum fires. The MLA is unconditional on this — *"A minimum of eight (8) hours at
  triple (3) time... shall be paid for all work performed under this Agreement on the following
  holidays"* (Article III, Holidays §1) — and the engine agrees, because §7 groups the holiday
  minimum by **calendar day**, so any slices > 0 on the holiday trigger `gap = 8 - hours worked
  that day` at x3.

**The question her holiday answer raised was answered from the record rather than sent back to
her** (registered and closed in
[gaps.md](gaps.md#holiday-8-hour-minimum-on-a-shift-that-only-spills-past-midnight-into-the-holiday)):
the minimum is owed **once per employee per calendar date**, summing every entry that touches the
day. `usp_Apply_GuaranteedHours.PROC.sql:443-487` groups `BY EmpID, CalendarDate` with
`ShiftAnchorDate` explicitly nulled, and Corrina had already said it on the **2026-06-11** demo
recording at 19:11: *"Put 8 hours per day guaranteed on a holiday."* A 0.5-hour spillover plus a
later 6-hour holiday shift is one day at 6.5 hours and a 1.5-hour gap, not two minimums.

**Corrected example 2, as she reissued it 2026-09-04.** J1 drive `6:30-8am` 1.5 ST; J1 work
`8am-5:30pm` 6.5 ST + 3 OT (long boom); J1 drive `5:30-6:30pm` **1 OT**; J2 drive `6:30-7:30pm`
1 DBL; J2 work `7:30-11:30pm` 4 DBL (long boom); J2 drive `11:30pm-1:30am` 2 DBL. Totals
**8 ST / 4 OT / 7 DBL = 19.0**, ties to the clock and matches `usp_Run_Pricing_Engine` slice for
slice. **Both breakdowns are now clean engine-agreeing reference cases** and belong in
[rule-examples-catalog.md](rule-examples-catalog.md) as the drive-time and two-job rows, which it
currently has none of.

**Owed:** a `decisions/` note for the cross-midnight adjudication (PAY-019 moves from `conflicted`
to settled), and `cfg.CrossMidnightDayTypePolicy` can stay on `CalendarDay` with the question
closed rather than parked.

**Not asked, deliberately:** the pre-6AM ST-bank reading and the long-boom/drive-time exclusion
are settled by this message rather than opened by it, so nothing was sent back restating them.

## 2026-09-07 — legacy-app comparison run: rest rule now moves hours to DT, non-union separated, WTL still open (Brian Petros → Ehtesham)

Brian ran the payroll department's **manual** calculations against his Payroll App to find what the
app gets wrong, and reports four discrepancies: **WTL** (still being discussed internally — an update
is promised), the **8-hour rest rule** (the app *"was not calculating the ST/OT/DT hour buckets for
this rule"* — now fixed), **non-union rules** (the app *"was mixing up the logic/calculations for
these with the Labor Union payroll rules"* — now fixed), and **labor entries longer than 23.5 hours**
(FCC-only; *"I don't think this will be a problem with our new ERP"*). He assumes the ERP's
calculation has diverged from the code he sent and offers an updated SQL instance. The exhibit is
Anthony Albergo (L12-G7, ADP file 292), payroll week **2026-08-22 → 08-28**, payday 09-03: the
manual Excel sheet, the app's "Recommendations" row, and the app's weekly review screens.

| Claim | Verdict | Register |
| --- | --- | --- |
| Rest rule: forced hours now land in a bucket, and the bucket is **DT** | ⚠️ **contradicts the register.** PAY-045 records *"apply OT floor"*, `cfg.RestPeriod_Rule.OTFloorMultiplier=1.50` (×2.0 only past 12 chain hours). The exhibit prices every forced hour at **×2.0 from the first hour**: rest premium $487.62 = 7.0 h × $69.66 × (2.0 − 1.0); $348.30 = 10.0 h × $69.66 × (2.0 − 1.5); $679.19 = 8.0 h × $69.66 × 1.0 + 3.5 h × $69.66 × 0.5. The **manual sheet agrees with the app** (08-25: 17.5 DT; 08-26: 18.0 DT; 08-27: 12.0 DT), so DT is the payroll department's practice, not an app artefact. The contract says only *"the applicable overtime rate"* | PAY-045 |
| Rest rule trigger | 🆕 **inferred from the exhibit, unconfirmed:** 08-24 evening (5:30 PM start, 6.0 h after a chain that held 0.5 h of outside-window OT) was **not** forced, while every entry after a chain that *ended* in OT/DT was. The 2026-08-18 config (`TriggerMode='HrsOTDTPositive'` — any OT/DT in the prior chain) would have forced 08-24 evening. Either the trigger now reads the contract literally (*"end of any overtime period"*) or something else excludes it | PAY-045 |
| Rest rule stitch/continuation as built | ✅ consistent: 08-26 22:30 → 08-27 04:00 (30-minute gap) stays one rest chain and the whole 11.5 h day is forced; 08-28 after 14 h off is clean | PAY-045 |
| Non-union rules were entangled with union logic in some procedures; now separated | 🆕 a defect in the **source we cite** (`usp_Apply_CA_NonUnionAdminHourly_OT`, plain-language §12). Which steps were wrong is not stated. **ERP status, verified in code:** non-union hourly already has its own path — `priceNonUnionHourly` (`packages/payroll-engine/src/calculate.ts:241-253`) prices ST ≤ 8 / OT 8–12 / DT > 12 with no union extras, and `applyWtl` exits for non-L12 groups (`calculate.ts:66`). Three seams are open on our side regardless of Brian's fix: the daily thresholds run **per ticket**, not per workday (two tickets on one day each get a fresh 8 h of ST); weekly > 40 only raises `WEEKLY_OT_APPLIED` and never reclassifies (`calculate.ts:444-452`); no seventh-day rule | PAY-012, PAY-025, PAY-026 |
| Entries > 23.5 h are impossible for the FCC-fed app; *"we probably won't have to worry about it in the ERP"* | ✅ agrees with PAY-004's cap design (ERP-born entries span natively; cap + split applies to imported FCC rows) and with the ticket-45888 adjudication. **Not built:** nothing in `apps/api` or the engine validates entry duration (no 23.5 or 24 h check anywhere). Findings question (6) can be treated as answered by the client's own framing; the migration-side flag is still owed | PAY-004 |
| WTL is the largest discrepancy and is unresolved internally | ✅ matches the state of the register (PAY-046/047 open, `wtl-charts.md` vs recording conflict) — and the exhibit shows *what* they disagree on. Every manual-vs-app total difference this week is a WTL half-hour: 08-24 11.0 vs 11.5, 08-25 18.5 vs 19.0, 08-26 18.0 vs 16.5, 08-27 12.0 vs 12.5, 08-28 7.5 vs 8.0; 08-22 identical. On the two weekday **ST-start** days the manual sheet **adds no hours** and moves 0.5 h from ST to DT (08-24: 11.0 = 5.0/5.5/0.5; 08-28: 7.5 = 6.5/0.5/0.5), while on OT/DT days it **adds** 0.5 h at DT. That is the legacy `WTL_DT_FLOOR` behaviour (findings 2026-06-10). Brian's app adds 0.5 h everywhere — and so does **our engine** (`calculate.ts:50-81`, the "four-source-verified" add). On 08-26 the app's meal-period grouping nets +0.5 / 0 / −0.5 across three entries (16.5) where the manual sheet adds three lunches (18.0) and flags it for review | PAY-046, PAY-047 |
| Rate on the exhibit: L12-G7 FY2025-26 $68.66, FY2026-27 **$69.66**, and the August week prices at $69.66 | ✅ agrees with `mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md` (Group VII 69.66) and the 7/1 rollover in PAY-010. The app's "Base Rate Override" column is the PAY-010/decision 2026-08-20 override | PAY-010, PAY-008 |
| ERP calculation has diverged from the code Brian sent | ✅ true in kind: the ERP engine is a TypeScript re-implementation (`packages/payroll-engine`), not his SQL. But the register **cites his procedures as a source** for every rule, and the extract is the 2026-08-18 snapshot — the rest-rule and non-union changes he describes are exactly the procedures we cite. An updated instance is worth taking for those two | PAY-045, PAY-012, extract INDEX |

**What this changes for the build:** nothing is wrong in shipped numbers today, because PAY-045 is
not implemented and non-union already runs on its own path. What changes is the **spec** for the
rest rule when it is built — DT from the first forced hour, per the client's own manual practice —
and the WTL formula, which the manual sheet contradicts on weekday ST-start days. Neither is a
decision yet.

**Client questions from this message:** (33) the rest-rule rate — is the forced multiplier now
**×2.0 from the first hour** (as both the manual sheet and the app show), and was
`cfg.RestPeriod_Rule.OTFloorMultiplier` changed from 1.50, or is 1.5 still the floor and DT arises
some other way? Same rule, the trigger: 08-24 evening had 6 h off after a chain containing OT and was
not forced — is the trigger now *"prior chain ended in OT/DT"* rather than *"prior chain contained
OT/DT"*? (34) non-union — which procedures/steps were applying union logic, and what is the corrected
list of rules that apply to non-union hourly (daily 8/12, weekly 40, seventh day, holidays, anything
else)? (35) WTL on a weekday ST-start day — the manual sheet reclassifies 0.5 h ST → DT with no added
hours, the app adds 0.5 h; which is the intended rule? *Not to ask now* — Brian says an update is
coming; hold the engine's add formula until it lands. (36) **Yes to the updated SQL instance** —
the recommended reply — scoped to what moved since 2026-08-18: `usp_Apply_RestPeriod_Premium`,
`cfg.RestPeriod_Rule`, `usp_Apply_CA_NonUnionAdminHourly_OT`, and any WTL change once their
internal discussion closes.

**Asked 2026-09-07** (Ehtesham's reply to Brian, sent as drafted): (33) rate and trigger, (34)
non-union corrected rule set, (36) updated SQL instance requested. (35) deliberately held for
Brian's WTL update. Answers land here and in PAY-045 / PAY-012 when they arrive.

### Correction — Brian's reply, same day (2026-09-07)

Brian: *"There has been no change to the way the '8-hour rest' rule should be calculated… and no
change to how the non-Union rules should be calculated. The only change is how our internal Payroll
App is displaying the results."* The descriptions he sent months ago are *"our source of truth… not
the results in the version of the Payroll App"*. He then walks Aug 25 through: the rule looks at the
previous entry, groups it if the gap is under 8 hours, and keeps walking back until it finds an
8-hour gap; the grouped hours accumulate, and **DT is forced once the group reaches ~12 hours**.

| Claim | Verdict | Register |
| --- | --- | --- |
| Rest rule unchanged: group entries across gaps < 8 h, accumulate, force DT at 12 h | ✅ **agrees with the register as it stood** — this *is* plain-language §9 and `cfg.RestPeriod_Rule`: floor ×1.5, **×2.0 once cumulative hours in the rest chain reach 12**. The 2026-09-07 row above (*"contradicts the register… ×2.0 from the first hour"*) was **our misreading**: Aug 24 contributes 6.0 + 5.0 = 11.0 h across two sub-8-hour gaps, the first hour of Aug 25 brings the chain to 12.0, and the remaining 7.0 h are floored to ×2.0 — $487.62 exactly. Aug 24 evening was in the chain but below 12 h and already at ×1.5, so the floor added nothing. **Verdict withdrawn; question (33) answered, no rule change** | PAY-045 |
| Trigger inference ("prior chain *ended* in OT") | ❌ **withdrawn** — the 12-hour escalation explains Aug 24 evening without any trigger change | PAY-045 |
| Non-union: no change to the rules; the app's *results* were wrong and are now fixed | ✅ the descriptions (plain-language §12, PAY-012's client statement) stand as the source of truth; only the extracted procedure's *output* was defective. **Question (34) answered** in principle; which steps were wrong is still unstated, and no longer matters if the descriptions govern | PAY-012 |
| Payroll department counts hours *not worked* (the WTL 0.5 h penalty) toward the 12-hour DT threshold; the app counts actual hours only | 🆕 the one genuinely new fact. It is a WTL question, not a rest-rule one: does a WTL add count as "hours worked" for the rest chain's 12-hour escalation? Brian: still being worked through internally and with the union; Corrina to review/approve. **Do not ask; wait for the update** | PAY-045, PAY-047 |
| App display: the "Rest floor" badge should also show on the Aug 24 evening row | 🆕 a display defect in Brian's app, his own note. No ERP consequence | — |

**For the ERP:** PAY-045 as written is correct and complete for the rate — build it from the register
(×1.5 floor, ×2.0 at 12 cumulative rest-chain hours, only the delta paid). The open item is whether
WTL adds count toward the 12. (36) the SQL instance is not addressed in the reply.

**Closed out 2026-09-07** (Ehtesham's second reply, sent): acknowledged no rule change on rest and
non-union; **build default stated to the client — the rest chain's 12-hour counter uses actual hours,
to be flipped if Corrina rules that WTL adds count**; SQL instance still requested. Nothing else
outstanding from this thread.

**(36) answered 2026-09-07:** Brian is uploading *"our most recent/updated Payroll App (web app and
API)… and databases (data warehouse and payroll app calculation engine)"* as one zip. When it lands:
it supersedes the 2026-08-18 extract for `usp_Apply_RestPeriod_Premium`, `cfg.RestPeriod_Rule`,
`usp_Apply_CA_NonUnionAdminHourly_OT` and the UI; register it in [source-manifest.md](source-manifest.md),
diff it against [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md) and
[legacy-payroll-app-source-tree-2026-06-10.md](legacy-payroll-app-source-tree-2026-06-10.md) rather
than re-extracting from scratch, and note in `rules/PAY-045` and `rules/PAY-012` what actually
changed in the procedures.

**Ingested 2026-09-07** — [legacy-payroll-app-db-backup-2026-09-07/INDEX.md](legacy-payroll-app-db-backup-2026-09-07/INDEX.md). Verdict on the message, now from the code: **the rule
procedures did not change.** `usp_Apply_RestPeriod_Premium` is identical to the 2026-08-18 extract;
`usp_Apply_CA_NonUnionAdminHourly_OT` gained only a `@ReturnResults` switch; no `cfg.*` row moved.
What changed is around them: (1) a post-pricing **rest-slice adjustment** table and *effective*
slice views that re-source the ST/OT/DT buckets, so forced slices count in DT — the exhibit's rows
read *"Rest chain over 12 hrs"*, RestMultiplier 1.5 → 2.0 exactly where the chain passes 12 h, deltas
$487.62 / $348.30 / $679.19; (2) the **bucket source** for non-union rows is now the CA classifier
and never union day-type buckets (*"the mixing-up"*); (3) **salary excluded before pricing** with a
regression test; (4) `@StrictLaborTimes = 1` — the assumed-06:00 shift fallback is **off**, missing
times become exceptions; (5) interactive recalculation is an exact Sat–Fri week with a
**fresh-prior-week guard**, RunId on every output row; (6) Excel/rule-narrative procs. Two register
consequences worth a line: WTL now reads rest-adjusted slice pay (rest before WTL), and PAY-018's
assumption is disabled in production.

## 2026-09-07 — non-union hourly rules summary and nine validation scenarios (Brian Petros)

Following his "no rule change" reply, Brian sends a summary of the non-union rules (*"nothing
different… just a summary"*): the Sat–Fri workweek, daily 8/12, weekly > 40 with no double counting,
seventh consecutive day, a nine-step calculation order, the six-component audit taxonomy, no union
minimums, cross-midnight, data-quality controls, an explicit list of **unfinalized** non-union items
(holidays, PTO, sick, shift differential, minimums…), the salary group, and **nine validation
scenarios** the ERP must demonstrate. Transcribed in full, with per-test ERP status, at
[non-union-hourly-rules-2026-09-07.md](non-union-hourly-rules-2026-09-07.md).

| Claim | Verdict | Register |
| --- | --- | --- |
| Sat–Fri workweek for weekly OT and seventh day | ✅ agrees (sixth source) | PAY-001, PAY-025, PAY-026 |
| Daily 8 ST / 8–12 OT / > 12 DT, $560.00 example | ✅ agrees with plain-language §12 and the engine's thresholds. ⚠️ **engine applies them per ticket, not per workday** (`calculate.ts:241-253`) — his step 3 ("combine the employee's hours for that workday") is not what we do | PAY-012, PAY-023/024 |
| Weekly OT converts only otherwise-ST hours after daily and seventh-day; never double counts | ✅ agrees with §12 ("taken from the latest straight-time hours") and PAY-027's no-pyramiding intent. ❌ **not built**: weekly > 40 only flags (`WEEKLY_OT_APPLIED`) | PAY-025, PAY-027 |
| Seventh consecutive day = **all seven days of the Sat–Fri week** worked; first 8 h OT, over 8 DT; a missed day means no trigger | ✅ agrees with §12. 🆕 the "all seven days of *this* week" framing is now explicit — the count does not carry across weeks. ❌ not built | PAY-026 |
| Nine-step calculation order; "do not total the week and calculate OT afterward" | 🆕 first written order for non-union. Consistent with the dependency-matrix paper's engine order (§ non-union). The engine has no weekly stage at all, so order is moot until 4–7 are built | PAY-012, PAY-025, PAY-026 |
| Six explicit components; ERP must preserve *why* hours became OT (daily / weekly / seventh) | ✅ agrees with PAY-059's confirmed reporting purpose. ❌ engine emits `PAY-012` "Overtime" with no reason — a component-taxonomy gap, same shape as the legacy ledger names | PAY-059 |
| No union minimums/guarantees for non-union hourly | ✅ agrees with §12 ("every union extra is zeroed"); ✅ engine emits none | PAY-039/040/041, PAY-043, PAY-012 |
| Cross-midnight: positive duration, workday preserved, correct week | ✅ agrees with PAY-019 and the 2026-09-04 decision; `sliceWindow` handles it | PAY-019 |
| Data-quality flags (missing/invalid/duplicate/overlap) apply to non-union too | ✅ agrees with PAY-028/029/060; ❌ neither 028 nor 029 is in the engine | PAY-028, PAY-029, PAY-060 |
| Holidays, PTO, sick, vacation, shift differential, minimums, bonuses, allowances for non-union: **not finalized**, not to be inferred from union rules | 🆕 the client saying in writing that the spec is incomplete here. Registered as an open question owned by TCG | PAY-033, PAY-073, PAY-036/037 |
| Salary group: generate no ST/OT/DT from labor; pay from configured salary; no boom | ✅ agrees with PAY-013 and the engine (one "Salary period amount", `SALARY_AMOUNT_ASSUMED` because it reads `hourlyRate`) — the salary field and frequency remain unconfirmed, and Brian wants to discuss | PAY-013 |
| Nine validation scenarios | 🆕 the first client-supplied acceptance list for any payroll group. **Today: 1–3 pass for single-ticket days, 9 passes, 8 is partial, 4–7 fail** — see the transcription's status table | PAY-012, PAY-025, PAY-026, PAY-019 |

**For the build:** the non-union hourly gap is now precisely bounded — per-workday combining, weekly
OT reclass, seventh-day, and reason-carrying components — and the acceptance tests are written by
the client. Sections 1–3, 12 and 13 of his document were not sent.

**Client questions from this message:** (37) the full document — sections 1–3, 12 and 13 are missing
from the screenshots; ask for the file rather than more images. (38) the §14 list and §15 salary:
Brian proposes discussing both — put them on the next payroll meeting agenda rather than asking
in writing; the register's blocking items for PAY-013, PAY-033 and PAY-073 are exactly these.

## Parked — 2026-08-24 (build proceeds on defaults)

Per the build lead: the five remaining questions are **not asked now** — the build is
underway and they resolve naturally in future meetings. Each has a safe working default the
build uses until the answer lands:

| # | Parked question | Build default (evidence-backed) |
| --- | --- | --- |
| 9 | WFN Next-Gen timing | Build against **classic WFN** (the resolved product); re-validate the ADP layer at upgrade — caveats already on the docs |
| 16 | Cross-midnight policy | Build **`CalendarDay`** (the active config, the engine's own default) **and keep the policy switch + 10-case harness** — flipping later is config, not code |
| 19 | Desktop backup cadence | Treat the desktop as fragile during parallel-run; ERP itself carries no on-prem dependency |
| 20a/b | Late-leave adjudicator · rigging price source | Build the cause→disposition taxonomy with these two as **manual-review dispositions** until named |
| 21 | Luffer classification | Build the **contract reading**: luffing boom counts toward **Long Boom pay** (mast+jib combined length), not the lattice premium |

None blocks a `PAY-###` rule build. When an answer arrives in a meeting, it lands as a
decision note and flips the default — the rule files already say where.

