---
title: Payroll rules by source family — attribution and conflict register
source: derived from payroll/ (all four source families) + meetings/transcripts/ full scan
migrated: 2026-08-19
updated: 2026-08-19
status: reference
conflicts_with: []
jira: []
topics: [payroll, provenance, conflict-register, source-attribution]
entities: [craft-code, craft-modifier, lattice, subsistence, wtl, rest-period, shift-premium]
---

# Payroll rules by source family — attribution and conflict register

Every rule we hold about TCG payroll, tagged with **which kind of source says it**, and every place two
sources disagree. Built 2026-08-19 from a full read of the four families plus a line-by-line scan of all
56 meeting transcripts (through 2026-08-13).

> **Addendum, 2026-08-19 (later same day):** the 2026-08-18 Accounting Process transcript was added
> to the vault after this scan and is **not** covered by the full-corpus pass above — only its two
> payroll-relevant mentions were checked, marked ⚠️ inline where they land. It is otherwise a new
> topic area (ERP/QuickBooks boundary, invoicing, AR/AP, subcontractor billing) with no prior
> coverage in this document.

**Why this exists.** "The contract says X", "TCG said X on a call", "ADP has a code for X" and "the
application computes X" are four different kinds of true. Blurring them is how a rule that nobody ever
agreed to ends up in a build. This page keeps them apart.

**This page adds no gaps and settles nothing.** It is a map of what is claimed and by whom. Anything
here that needs a decision goes through `tcg-scrum` and `decisions/` in the normal way.

## The four families, and what each can prove

| Family | Proves | Cannot prove | Where |
| --- | --- | --- | --- |
| **CLIENT DOCUMENTS** | what TCG signed or wrote | that it is implemented | MLA, SOP v3.8, ERP FRD, WTL charts, rule matrix, foreman/military note |
| **CLIENT MEETINGS** | that a person said it once | that it is agreed, or correctly transcribed | `meetings/transcripts/`, `meetings/*.md` |
| **ADP** | that a code exists and a payload validates | **entitlement** — a code is capability, not a rule | `adp-*.md`, `adp-api-responses/` |
| **CLIENT APPLICATION** | what the SQL computes today | that it is contractually right | `legacy-payroll-app-db-extract/`, `payroll-app-current-state/` |

**Evidence hierarchy, strongest first:** the ADP `/meta` response (a live production payload) → the
application extract (read-only dump with line anchors and executed tests) → client documents (MLA is
`unverified`; ERP FRD is Draft 0.1 with 24 open decisions; rule matrix has an open-decision column
populated on all 68 rules) → meetings (`status: reference`).

### Two caveats that weaken every meetings citation

1. **Speaker labels are wrong and were deliberately left wrong.** `meetings/transcripts/NORMALIZATION.md`
   — room-mic recordings mislabel **Lisette, Dylan, Liz, Ryan and Wes as "Brian Petros"**. A line
   attributed to Brian may not be Brian.
2. **The lattice discussion is reconstructed text** — 4 instances of `lettuce` → `lattice`. Correct, but
   reconstructed.

Also load-bearing: neither the FRD nor the rule matrix is legal advice, and both say so. **A contract
question is not resolvable by reading the contract harder.**

---

## Part 1 — Attribution by topic

Condensed. `—` means that family is silent.

| Topic | CLIENT DOCUMENTS | CLIENT MEETINGS | ADP | CLIENT APPLICATION |
| --- | --- | --- | --- | --- |
| **Wage groups / base rate** | MLA Art. IV: G1–G9, $66.03→$71.16; apprentice steps 60–90 % of **Group 5** | groups are "based on the crane"; rates change every 1 July; apprentice 1–6. ⚠️ **2026-08-18** (Brian, to abdulrehman): "**there are no craft codes in ADP** in the same way. It's a **base rate that's identified for each employee**… ADP only accepts **like 1 base rate for every employee**. And that's why if there's anything different than that base rate, then we… submit a **separate row**… and put a rate in the **temp rate column** as a temporary rate." — TCG's own side **corroborating** the ADP-family finding, independent of the API scan | **no craft field anywhere in the schema**; `job-titles` collapses six operator classes into one `OPERATOR` | `FMS_UNION_CRAFT.PayRate` by craft; `-B`/`-C` variants ignored, engine prices `-A` |
| **Which craft wins on mismatch** | MLA Art. III: the craft worked with, **"if more advantageous to the employee"**; higher rate applies all day | **answered explicitly** — dispatched rate always; secondary only if higher | — | **labor row wins, unconditionally, on 27 % of rows** |
| **Over-scale** | — | **a per-employee $/hr bump on top of scale, floats with scale, lives in the profile; exists today in FCC + ADP** | — | — |
| **ST/OT/DT ladder** | MLA Art. III: 8 h between **06:00–17:00**, 40 h/wk straight, DT after **12 h**, all Sundays/holidays; **no pyramiding**; time reckoned in ½ h | window confirmed twice, two speakers; weekday=ST, Sat=OT, Sun=DT "by default"; ½-hour increments | codes only: `R`, `O`, `DT`, `CAO`. **`premiumRateMultipliers` absent on every worker** — ERP owns multiplication | `cfg.Union_Master_Rules`: 06:00–17:00, 8.0, 12.0, ×1.5/×2.0, Sat 1.5, Sun 2.0, Hol 3.0 |
| **Sat / Sun / holiday / special Sat** | MLA: 9 holidays at **×3 min 8 h**; special Sat = first Sat after the first Fri of **June and December**, **×2 min 8 h** | special Sat = **the Local 12 union meeting**, two a year; H2x=union, H3x=federal | `HDD` Holiday Double, `HOL` Holiday Triple. **No special-Saturday code** (crosswalk D-005 open) | `dim.LU12_Holiday` 44 rows 2025–28 with observed-date logic; `HOLIDAY_MIN_8` ×3, `SPECIAL_SAT_MIN_8` ×2 |
| **Long boom** | MLA: **$0.75 operator / $0.25 oiler** at 80–100 ft, **+same per 20 ft**; **travel and curfew excluded**; **4 h minimum, not to exceed time worked**; adder **becomes base for OT** | starts at 80 ft, 20-ft steps, oiler 25¢ / operator 75¢, "up to like 600 feet"; **only oiler and operator qualify, not third man**; **longest length overrides** mid-shift; travel/standby excluded (stated 3×). **2026-08-18** (Brian): self-reported by the employee at time entry, then payroll runs "**a common sense check**" — (1) is the employee **eligible** to select the modifier, (2) does the extension **exceed the max the crane can operate at** ⚠️ **a validation rule in no other family** — the app extract says explicitly "no feet arithmetic" exists in the engine, so this check, if real, is a **manual** one Corrina/payroll performs, not a system rule. Also new: abdulrehman (CC) proposed auto-deriving the modifier from **asset type + boom length**; Brian: cranes are **extendable**, so length is **job-specific, not crane-specific** and can't be inferred from the asset alone; Wes: **"we usually quote the jobs with the crane config"** — i.e. boom length is typically known at **quote time**, which is what would make automation possible. Directly extends the lattice-automation question (C-18) to long boom generally | `LBH`/`LBO`/`LBD`/`LBT` as **Temp Rate + Hours 4** pairs, one row per rate | 4 conditions; adder into rate then multiplied; **18 operator / 15 oiler brackets, max 421–440 ft**; `LONG_BOOM_MIN_4`; **no travel/curfew carve-out, no jib, no feet arithmetic** |
| **Lattice** | MLA: **$1.00 operator / $0.50 oiler**, **Groups 6–9 only** — the only group-gated premium. FRD PR-027: avoid combining with long boom | crawler crane **only** (others are "jib extensions or luffing jibs"); **stacks with boom pay**; premium on the **whole job**, not boom time; oiler quoted **$0.75** | **eight codes live**: `LPR/LPO/LPD/LPT`, `LOR/LOO/LOD/LOT`. ⚠️ `LPR`/`LPO` **also exist as deduction codes** ("Life Post") | **nothing.** No `LATT*` token, no branch, no code — zero matches across all 141 definitions |
| **Shift differential** | MLA: 2nd = **7 worked / 8 paid +$3.00**; 3rd = **6½ worked / 8 paid +$4.00**; becomes base for the shift; 3+ consecutive days and **written Union notice** | union letter before the job; night work paid **regular not OT**, compensated by the adder — "the give and take"; **whole crew swaps**; extra hour of pay; $4 third shift | `S2R/S2O/S2D/S2T`, `S3R/S3O/S3D/S3T`; a **Shift tag** field, values 2–9 | token-driven; both tokens = conflict → day shift; **rate add + hours add (+1.0 / +1.5 h)**; used **3 times in all history** |
| **Foreman** | ⚠️ **not in the MLA** — only "Shop Foreman" as a *Group 7 classification*. Sole source is a **Google Chat message**: $3/h into base, company rule, union employees only, per-job, `(PAY:FOREMAN)` token typed by a clerk | $3/h, "**I'm not sure exactly how the ERP is going to be capturing these**" | `FRR/FRO/FRD/FRT` live | **nothing** — no foreman logic in the app or in `projects.rar` |
| **Military base** | ⚠️ claimed "a Labor Union rule" in the same chat message; **the MLA contains no such rule**. $10/h into base, all hours all employees on the job, Davis-Bacon list, adjacency settled by phoning the Business Agent | $10/h; **"first time I heard about the $10 increase"** (Brian); *"it's not 100%… Union loves the gray area"* (Corrina); confirmed it **multiplies** through OT/DT/TT | `MLR/MLO/MLD/MLT` live — **never sent to us; found by calling the API** | **nothing** |
| **Subsistence** | MLA Art. V: **$85/scheduled work day** when required to remain away overnight; trigger = equipment **≥45 mi** from home yard and remains on job; **$200/day for the weekend** over **77½ mi**; employer **may elect** weekend subsistence *or* portal | short = 44.5–77.5 mi, long = over 77.5 mi; **$85 / $200**; **permitted-route mileage, not Google**; holdover jobs only; short/long/**custom** per employment agreement; **per job, not per craft code** | `SUB` = Substpay NT, dollars not hours. ⚠️ `SUB` also a deduction code. ADP location list has **two values** — cannot express home yard | token-driven; `SUB_SHORT` $85 any day; `SUB_LONG` **$85 Mon–Fri / $200 Sat-Sun**, weekend from the work date; amounts hard-coded; excluded from Final Gross |
| **Rest period** | MLA Art. III: **8 h** between the end of overtime and the next straight-time shift; otherwise **overtime rate for every hour until 8 h rest is received** | rate **continues** rather than restarting — "their double time continues"; **rolls across pay periods**; unpaid gap; Corrina watches it manually | **no code.** Crosswalk D-003 "TBD, dedicated code required" — open, blocking | chains ≤30 min; forced when prior chain had OT/DT and gap < 8 h; **persists until 8 h off**; floor ×1.5 → ×2.0 past 12 h; only the increase is paid |
| **Worked-through-lunch** | MLA: no more than **5 consecutive hours** without a ½ h meal; worked meals at **double time**; ⚠️ on **Sat/Sun/holidays** an extra ½ h **"at the applicable wage rate"**. Charts: markers **5:01 / 10.5:01 / 16:01 / 21.5:01**; "Saturday WTL are OVERTIME until 12.5 h" | **5.5 / 11 / 16.5 / 22**; 1st lunch included, 2nd and 3rd additional; weekend = **every** missed lunch additional; foreman signs off because **it is also billed**; third lunch **cannot be skipped** (stated as belief) | **no code.** D-004 "TBD, do not reuse shift or rest codes" — open, blocking | expected meals by span; opportunities at **5.0 / 10.5 / 16.0 / 21.5**; `AddMultiplier` **2.00** with `SaturdayMode`/`SundayMode`/`HolidayMode` **all** `WTL_APPLICABLE_ADD`; missing token ⇒ **assume zero, warn** |
| **Guarantees** | MLA: **4 h** reported-and-worked; **2 h reporting pay** when no work provided; crane-remains-on-job **4/6/8** tree; **no 8 h guarantee if only travelling/assembling**, first day; holiday min 8; special-Sat min 8 | 4 h/day confirmed, **union only** — explicitly excluded for non-union; holiday **8 h**; "we would never pay 8" when converting 2 h DT → 4 h DT | **no codes.** D-002, three TBD codes; "**do not hide guarantee hours inside Reg Hours**" | `DAILY_MIN_4`, `HOLIDAY_MIN_8` ×3, `SPECIAL_SAT_MIN_8` ×2 — **values hard-coded in the proc**, `cfg…MinimumHours` never read. `ADMIN-*` exempt |
| **Into the rate vs on top** | MLA states it **three times**: boom adder "shall be the base rate when computing overtime"; shift premium "will become the base rate for the entire shift"; hazmat "shall become the basic hourly rate" | the clearest statement anywhere — premiums ($3+$3+$1) go **into** base, $70→$77, then multiplied; craft modifiers go **on top** flat. ⚠️ **confirmation never obtained — Corrina had left the call** | structurally **on top**: premiums ride Temp Rate + Hours 4 rows separate from Reg/OT/DT | `slice_pay = 0.5 × (Rate_Base + Rate_Shift + Rate_Boom) × multiplier` — everything in the bracket is into the rate; guarantees, rest, WTL, subsistence, shift-hours-add are separate lines |
| **HDR** | MLA Art. IV: **Group 9, $71.16, "Heavy Duty Repairman and/or Welder … Long Boom pay applicable"** | "heavy duty repairman, AKA mechanics… highest pay is group 9" (06-09), then ⚠️ **"HDR is not used anymore"** (07-09) | **silent and incapable** — no craft field | `HDR-A/B/C` at **71.16**, in the craft table but **not `L12%`** ⇒ boom hours counted, **$0 premium**. The **only failing check** in the client's regression suite |
| **Non-union / CA OT** | FRD PR-041 + ten L12 rules that must not apply; rule matrix says **legal confirmation required**; the workbook's cited source is the **California DIR FAQ**, not a contract | only the union/non-union split and exempt/non-exempt; **no threshold stated on any call** | `CAO` — CA OT exists, **and the crosswalk deliberately reuses generic `O/T Hours` instead** | daily 8→12 OT, >12 DT; weekly >40 → OT from the latest ST hours; **7th consecutive day: no ST at all**; six `NONUNION_CA_NONEXEMPT_*` lines; thresholds hard-coded. **Salary: no rule exists anywhere** |

---

## Part 2 — Conflict register

Each written so **one sentence from TCG closes it.** Ranked by money at risk.

### Tier 1 — money may be moving wrongly now

**C-01 · Is a Heavy Duty Repairman entitled to long-boom pay?**
DOCUMENTS say yes — MLA Art. IV puts HDR in Group 9 at $71.16 with *"Long Boom pay applicable"*, and
`HDR-A` prices at exactly $71.16. APPLICATION says no — the adder fires only on `CraftCode LIKE 'L12%'`.
Proven by the **single failing check** in TCG's own regression suite (`BoomBreakdown_Tests` 7/9,
scenarios 82951 and 83282, both `HDR-A` + `OP-BP-07` @ $5.25/h). **$94.50 unpaid on one day, one
employee**; 4,728 `HDR-A` rows in the extract.
⚠️ **But first ask whether HDR is still live at all** — Brian said on 07-09 *"HDR is not used anymore"*,
contradicting his own 06-09 walkthrough. If it is retired, this is historical, not current.

**C-02 · Which craft prices the row — the dispatched rate, or the labor row's?**
MEETINGS answered this **explicitly and against the app**. Kyle: *"whatever their dispatch has, they had
to stay at that rate."* Corrina: *"$70… even if he goes out on a job as a rigger, he still has to be paid
the $70."* Brian: *"any secondary must be a higher rate than the primary"* → Kyle: *"Yes, correct."*
DOCUMENTS agree in spirit — MLA Art. III gives the craft worked with *"if more advantageous to the
employee"*. APPLICATION does the opposite: labor row wins unconditionally, on **27 % of rows**.

**C-03 · Lattice oiler — $0.50 or $0.75 per hour?**
MLA says **$0.50**. Brian on 08-13 says **$0.75**. The operator figure ($1.00) matches both sides, so this
is one number, not a systematic misreading. 50 % overpayment on every lattice oiler hour, ×3 on holidays.

**C-04 · Does anything other than a manual Excel dropdown pay lattice today?**
DOCUMENTS (SOP): a dropdown on each employee sheet, *"not connected to FCC"*. ADP: eight codes live in
production. APPLICATION: **nothing** — zero matches for `lattice|LATT` across all 141 definitions.
⚠️ **And the crosswalk misdescribes it.** `adp-bucket-crosswalk.md` marks all eight lattice rows
**"CURRENT - implemented"** driven by `LATT_OPER`/`LATT_OILER` tokens. Those tokens are **ignored** by the
app — only `SHIFT_2, SHIFT_3, SUB_SHORT, SUB_LONG, WTL_0..4` are read. `meetings/2026-08-05-…` repeats the
crosswalk's claim as fact. **A developer reading the crosswalk first will build against a token nothing
emits.** Both predate the 2026-08-18 extract that disproved them.

**C-05 · Weekday long-subsistence — $85 or $200?**
APPLICATION hard-codes `SUBSISTENCE_LONG_WEEKDAY_85` = $85 Mon–Fri. Observed practice pays **$200 on
weekdays** — $115/day/employee. MLA reads with the app ($85 per scheduled work day; $200 *"for the
weekend"*).
⚠️ **But no call anywhere distinguishes weekday from weekend subsistence — silent across all 56
transcripts.** The weekday/weekend split may be a system invention. TCG's own axes are *overnight*,
*45 mi*, *77½ mi*, *permitted route*, and *custom per employment agreement*.

**C-06 · What is the longest boom bracket TCG actually pays?**
APPLICATION: `OP-BP-01…18`, max **421–440 ft**. Workbook: **26 brackets to 600 ft**. MEETINGS: *"we just
happen to be going up to like 600 feet."* **A 500-ft boom has no engine bracket at all** — adder would be
$16.50/h against an engine ceiling of $13.50.

### Tier 2 — will move money as soon as the rule is built

**C-07 · Are foreman $3 and military $10 flat, or multiplied?**
ADP implies multiplied — **`FRT` and `MLT` (TRI) are live**, and a triple-time variant of a flat adder is
meaningless. MEETINGS agree: Brian confirms the $10 *"would be utilized for overtime and double time and
triple time"*, Corrina: *"Yes. Yes."* DOCUMENTS: *"nobody has stated this… the largest unpriced
assumption in either rule."* **×3 error: $10 → $30/h on a holiday, for every employee on the job.**

**C-08 · Do premiums stack, and does no-pyramiding forbid it?**
MEETINGS-only, one speaker, one call: *"$3 plus $3 plus a dollar… $7 per hour added to their base rate…
$70 per hour… would change their base rate to $77."* MLA Art. III: *"There shall be no pyramiding of
overtime."* Foreman is a **company** rule while Military is claimed a **union** rule, so whether the
union's restriction binds is a question for counsel.

**C-09 · The into-rate vs on-top rule was never confirmed.**
This is the distinction the whole model rests on. Brian states it, then asks Corrina to confirm — **she had
already left the call**. Ehtesham: *"She's not here."* Meeting ended. It agrees with the MLA (which states
it three times) and with the application formula, so it is very likely right — but it has **never been
confirmed by TCG**, and the transcript's speaker labels are known-unreliable.
Practical consequence: **the workbook pre-multiplies the adder, ADP does not.** Sending ADP a raw adder
and expecting it to multiply would underpay every OT and DT boom hour.

**C-10 · Worked meals on Saturday, Sunday and holidays — three different answers.**
MLA: on Sat/Sun/holidays an extra ½ h *"at the applicable wage rate"* (weekday rule is double time).
Charts: *"Saturday WTL are OVERTIME until 12.5 hours."* APPLICATION: `AddMultiplier` **2.00** flat on every
day type. **On a holiday the engine may pay ×2 where the contract says ×3 — a 50 % underpayment on every
missed holiday meal.**

**C-11 · Lunch thresholds 3 and 4 — and the engine is the outlier.**
MEETINGS (Corrina, and Ryan reading back): **5.5 / 11 / 16.5 / 22**. Field-ops mobile app: **16.5 / 22** —
**matches the client**. Payroll charts: 16:01 / 21.5:01. APPLICATION: **16.0 / 21.5**. So the payroll
engine, not the mobile app, is the one out of step. Half an hour of double time either way, and the mobile
app is what fires the alert — **the wrong threshold causes the penalty it exists to prevent.**

**C-12 · Over-scale exists and is modelled nowhere.**
MEETINGS-only, but stated by three people and confirmed to be live today in both FCC and ADP: a
per-employee $/hr bump **on top of** the group rate, which **floats when scale increases**, held in the
employee profile. Kyle: *"eight guys on the job site and they all have different pay rates."*
**No document, no ADP field, no application logic.** Any ERP that prices from craft code alone will
underpay every over-scale employee.

### Tier 3 — correctness and auditability

**C-13 · Travel and curfew are inside the boom window.** MLA excludes them explicitly; TCG restated the
rule **three times** on calls (*"on-site hook time… no driving, no standby"*). APPLICATION: *"Travel /
curfew exclusion: none."* This one **overpays**, which is why it has attracted less attention.

**C-14 · Three pay rules have no route into ADP.** Rest premium, WTL and guarantee top-ups have no earning
code — crosswalk decisions **D-002, D-003, D-004**, all open and blocking. Anything they produce is
absorbed into a hand-keyed hours figure or not paid.

**C-15 · Day-type priority — four documents, three orderings.** FRD puts special Sat **above** Sunday; the
app puts Sunday above special Sat; the current-state catalogue puts special Sat **above Holiday**. Same
dollar (both ×2), different **bucket** — H2x routes to `HDD`, DT routes to `DT`, and D-005 wants a third
code again.

**C-16 · The FRD attributes a Sunday minimum to an app that has none.** FRD: *"The current Payroll App has
also used Sunday minimum-pay behavior in configuration."* `cfg.GuaranteedHoursRule` has **exactly four
rows**, none of them Sunday.

**C-17 · Three contract minimums exist in no system.** **2-hour reporting pay**, the **crane-remains-on-job
4/6/8 tree**, and the **first-day travel/assembly exception**. Also silent on every call — neither
"show up pay" nor "reporting pay" appears anywhere in the transcripts.

**C-18 · Lattice trigger — asset or salesperson?** Joe: *"You do not want it triggered from the
salesperson… It should be what they're dispatched to, which is tied to the asset."* Melissa and Brian had
both said the salesperson sets it on the crane configuration. Same transcript. Curated minutes still say
**Unresolved**.

**C-19 · `LPR` / `LPO` / `SUB` collide across ADP arrays.** As earnings they are lattice and subsistence;
as **deductions** `LPR` is **"Life Post"** life insurance. Send the wrong array and **ADP returns
`200 OK` while deducting instead of paying**. Store each code *with its target array*.

**C-20 · Boom window definition, inside one family.** `open-questions.md` says
`StartWorkTime→EndWorkTime` with `ArrivedJob→LeftJob` as fallback; `rules-plain-language.md` says
"in practice `ArrivedJob → LeftJob`". Same extract, same date. Changes which slices earn boom.

**C-21 · Is the keyed boom figure actual or post-guarantee?** No observed row falls below 4 boom hours and
exact `4.0` repeats. If the clerk keys post-guarantee figures, actual boom time is recorded nowhere and
`LONG_BOOM_MIN_4` double-applies. **Inferred, not verified.**

---

## Part 3 — Claims resting on a single family

**MEETINGS-only** — weakest evidence, and the speaker label may be wrong:

| Claim | Note |
| --- | --- |
| Premiums stack: foreman + shift + lattice = **$7/h into base**, then multiplied | one call, one speaker |
| Lattice oiler = **$0.75/h** | contradicts the MLA's $0.50 |
| Boom brackets run **up to ~600 ft** | engine stops at 440 |
| **Over-scale** — per-employee bump above scale, floats with scale | three speakers, live in FCC + ADP today |
| A **base-rate override** exists | *"sometimes the base rate is changed to a different than the default"* |
| Subsistence short/long from **permitted-route mileage** | contradicts nothing; simply unwritten |
| **Custom** subsistence per employment agreement | a third value beyond short/long |
| Lattice = **crawler crane only**; others are "jib extensions or luffing jibs" | Joe, and it closes three questions at once |
| Lattice **stacks with** boom pay | Corrina, correcting Ehtesham |
| Lattice premium applies to the **whole job**, not boom time | Corrina + Brian |
| **Longest boom length overrides** the whole shift | Kyle **and** Corrina — well attested |
| **Only oiler and operator** qualify for boom; third man does not | Corrina, twice |
| Shift-2 exists because night work is paid **regular not OT** — "the give and take" | the business rationale, recorded nowhere else |
| Union notification is **a letter before the job starts**, office-side only | no data source anywhere |
| Special Saturday exists because of the **Local 12 union meeting** | the only record of *why* |
| Third lunch **cannot be skipped** | stated as belief by two people, not certainty |

**CHAT-only** — one Google Chat message, 2026-08-09: the entire foreman and military premium
specification, including the claim that Military is *"a Labor Union rule"* which **the MLA does not
corroborate**, and day-level granularity stated by the author **as an assumption**.

**DOCUMENTS-only, computed by nothing:** hazmat +$2/h; apprentice step progression (the app has *"no
step-progression logic"*); every fringe/trust contribution; mileage $0.60/mi, tolls, parking, $30/mo cell
phone; injury-day full pay; vacation; final-wages waiting time.

**APPLICATION-only, in no document and on no call:** the 27 % craft-mismatch rate;
`ASSUME_WTL_0_WARN` (a missing token silently means zero missed meals — a **payment decision made by a
config default**); `SuppressPay_WhenSourceRateMissing` zeroing **5,725 rows** to $0.00 while keeping the
hours; the cross-midnight `CalendarDay` policy chosen *"Default until Payroll Manager confirms
otherwise"*; guarantee values as **hard-coded literals** with `cfg…MinimumHours` **never read**.

**ADP-only, in no TCG document:** `CAO`, `MLR/MLO/MLD/MLT`, `1XQ`, `1XX`, `VT1`; and the **Ventura company
`4RY`** — every payroll document in the vault assumes a single company.

---

## Part 4 — Confirmed silences

Searched and genuinely absent, so nobody re-derives them:

- **"Show up pay" / "reporting pay"** — neither phrase occurs in any transcript.
- **California daily-8 / daily-12 / 7th-consecutive-day** — no call states a threshold; only the generic
  exempt/non-exempt distinction and a link to the CA DIR FAQ.
- **Subsistence weekday vs weekend** — no call distinguishes them.
- **Curfew exclusion from boom pay** — curfew appears once, about permitted routes during travel, never
  tied to boom pay.
- **8-hour special-Saturday minimum** — the only trace is Brian reading a config row label aloud.
- **Second-shift dollar figure from a TCG operator** — Corrina gives $4 for third shift only; the $3 for
  second shift comes solely from Brian's config table.
- **"Group 6"** — never mentioned; groups appear only as the 1–9 range, with 8 and 9 as worked examples.
- **A rest-period *premium* as a separate amount or code** — only rate-continuation is described.
- **`meetings/summaries/`** — silent on every payroll topic; all seven are March sales/pricing/roles.

---

## Part 5 — The structural finding

The families are not four opinions about one system. They are **four systems, and only one of them
computes anything:**

- The **MLA** is the only thing with legal force, and it is `unverified`, extracted from a `.docx` summary
  because three source PDFs are unreadable scans.
- The **ERP FRD** is Draft 0.1 with 24 open decisions and disclaims being legal advice.
- The **application** computes 14 rules, of which the MLA supports maybe 9, and computes **zero** of
  foreman, military, lattice, hazmat, reporting pay, crane-remains-on-job, jib, travel/curfew exclusion,
  over-scale and apprentice progression.
- The **workbook** is where lattice, shift-flagging and foreman actually happen — and every hour figure in
  it is **hand-keyed**.

So the production payroll rule engine is **a human plus a spreadsheet**, and the SQL app is a partial
second opinion. Brian says so himself: *"there's a bug in the code that I provided you"*, and he calls
**Corrina's Excel "the gold standard"**, not the application.

**When two families disagree, the question is almost never "which document is right." It is "which of
these has ever actually paid anybody."** For lattice, foreman and military that answer is the
spreadsheet. For HDR boom pay, nothing has.

One more line worth keeping, from Brian on the record: *"there's probably **over half a million
combinations**, literally."* And from Corrina, on the contract itself: *"the book is so gray, has so many
gray areas."*

## Where to read next

1. `legacy-payroll-app-db-extract/rules-plain-language.md` — the 14 rules as built, with formulas and line anchors
2. `legacy-payroll-app-db-extract/open-questions.md` — direct answers to the 11 hardest questions, including the HDR failure
3. `mcog-l12-mla-2025-2028/01-article-iii-working-rules.md` and `02-article-iv-classifications-and-wage-rates.md` — contract text verbatim
4. `adp-api-responses/pay-data-input-meta.md` — the only production-verified artefact in the domain
5. `meetings/transcripts/2026-08-13-payroll-process.md` lines 340–460 — the densest statement of payroll rules on any recording
6. `adp-workbook-column-rules.md` — the weekly workbook, column by column
