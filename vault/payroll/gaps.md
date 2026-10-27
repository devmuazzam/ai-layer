---
title: Payroll — open questions
status: reference
kind: gaps
updated: 2026-10-07
tags: [module/payroll, kind/gaps, open-questions]
---

# Payroll — open questions

Live register per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*. Ticket-raised
questions do **not** go here — they belong in that ticket's `spec.md` §12.

Entry format (unchanged from the retired registers, so the global sweep still works):

```markdown
## <question title>
- **Status:** open
- **Asked:** YYYY-MM-DD — by whom / which work raised it
- **Question:** one paragraph
- **Sources checked:** what was read before declaring this open
```

## Payroll rule applicability by Payroll Group

- Question: which payroll rules apply to which of the five Payroll Groups?
- Candidates: none — this is unanswered, not contested.
- Note: **this is the single largest open area in payroll, and both independent sources say so.**
  The legacy Payroll App grew from an L12 union baseline, so its current behaviour reflects
  "what was built first", not a decision. `payroll/payroll-app-current-state/08-known-issues-and-next-decisions.md`
  names it "the highest priority next design area"; `payroll/erp-payroll-module-frd/11-security-decisions-and-acceptance.md`
  lists eight of its 24 required decisions under it. Specifically unresolved: which L12 rules
  apply to **mechanics** (the applicability matrix says "Confirm" on eleven separate rows); the
  final **non-union hourly** overtime matrix; whether **non-union salary** rows should be
  payroll-calculated, audit-only, or excluded entirely; whether WTL tokens should be required
  only for L12 union rows; and whether subsistence applicability varies by group.
  **Do not infer the answer from what the legacy system does — that is the thing being questioned.**
- Blocked: any payroll rule implementation that is not L12-Field-only.
- Owner: TCG management, payroll leadership, and labor counsel — named as such in both documents.
- Update 2026-09-07: the **non-union hourly** half of this question now has a written client rule set
  — [non-union-hourly-rules-2026-09-07.md](non-union-hourly-rules-2026-09-07.md) (daily 8/12, weekly
  > 40, seventh day, order, components, no union minimums, nine acceptance tests). Still open from
  the same message, in the client's own words: holidays/PTO/sick/shift differential/minimums for
  non-union (§14, next entry), and how salary is paid (§15, PAY-013). Mechanics and subsistence
  applicability are untouched by it.
- **Status:** open
- Legacy behaviour (2026-08-18, code-verified — not a policy answer): the engine applies every L12
  rule to any labor row whose `CraftCode LIKE 'L12%'` (Field and Mechanic identically); Non-Union
  Admin Hourly rows are repriced by `app.usp_Apply_CA_NonUnionAdminHourly_OT` (daily 8/12, weekly
  40, 7th day) with every union field zeroed; `ADMIN-*` crafts are the only ones exempt from
  minimum pay. No salary-specific rule exists (the CA proc applies only to PayType `H`). Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).
- **Rules:** [PAY-009](rules/PAY-009-payroll-group-classification.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#payroll-rule-applicability-by-payroll-group](gaps-2026-08-20-retired.md#payroll-rule-applicability-by-payroll-group)

## The 24 decisions required before the payroll rule catalog is final

- Question: the ERP requirements document's section 25 list, in full.
- Candidates: none.
- Note: reproduced in `payroll/erp-payroll-module-frd/11-security-decisions-and-acceptance.md`.
  Beyond the payroll-group questions above, they include: the **half-hour rounding method**;
  **source priority** between labor times and job-ticket times; **cross-midnight day-type
  policy**; whether a **Sunday minimum** applies; the exact **reporting-time and
  crane-remains-on-job decision tree**; **long-boom and lattice-boom** source-data requirements;
  the **higher-rate-for-the-entire-day** interpretation; **worked-meal calculation for weekdays
  vs weekends and holidays**; replacing **WTL comment tokens with structured meal records**;
  **subsistence distance calculation** and the employer-election workflow; the **apprentice-hour
  accumulation source**; **fringe-benefit treatment per paid component**; **which errors block
  payroll approval**; **who may reopen a processed period**; and the **record-retention period**.
- Note also: the document is **Draft 0.1** and states it "should not be interpreted as final
  legal advice". The rule matrix carries a per-rule "Confirmation / Open Decision" column that is
  populated for all 68 rules, and leaves all ten implementation-tracking columns blank.
- Blocked: treating any payroll rule as specified.
- Owner: TCG management, payroll team, labor counsel, union representatives.
- **Status:** open
- **From (frozen original):** [gaps-2026-08-20-retired.md#the-24-decisions-required-before-the-payroll-rule-catalog-is-final](gaps-2026-08-20-retired.md#the-24-decisions-required-before-the-payroll-rule-catalog-is-final)
- Update 2026-09-04 (Project Repository ingest): the list is numbered 1–24 in [erp-payroll-module-frd/11](erp-payroll-module-frd/11-security-decisions-and-acceptance.md) §25, and the record now settles or bears on several of them without anyone having swept the list. **Decided (decision notes):** #6 half-hour rounding — [decisions/2026-08-24-payroll-time-rounding-method.md](../decisions/2026-08-24-payroll-time-rounding-method.md) (start down, end up, 30 min, all employees; `verified`); #8 cross-midnight day-type — [decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md) (Corrina Bustos in writing: higher rate governs after midnight, spill into a holiday owes the 8-hour minimum; `verified`); part of #15 — [decisions/2026-09-01-subsistence-not-a-craft-attribute.md](../decisions/2026-09-01-subsistence-not-a-craft-attribute.md) (eligibility is a property of the trip, distance computed per job; the employer-election workflow is not decided). **Contract text now in the vault, not an interpretation:** #12 — the full Truck Crane MLA ([mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md) Art. III *Payment of Wages* §5 and Art. IV §3: the higher rate applies to *all time worked on that job during that day*). **Recommended by one TCG-side author, adjudicated by nobody:** #7, #13, #14 and #22 are each answered as proposals in [payroll-rule-dependency-matrix.md](payroll-rule-dependency-matrix.md) (reconstruct the timeline from labor intervals rather than FCC hours; freeze the day-type WTL premium only after the Payroll Manager confirms; replace `WTL:0` with an explicit *Lunch Taken* indicator; closed payroll immutable with a retro delta) — §15 lists them as unadjudicated collisions. **Evidence of practice, not decisions:** #20 — the live ADP mapping is now read from the workbook's own engine ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §3–§4); #17 — TCG's annotated FCC deck says apprentice level is *based on number of hours worked* and must be manually modifiable ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §8), which names the driver but not the source system; FCC's L12 *Payroll Defaults* slide encodes OT after 8 / DT after 12 / Saturday all-OT / 30-minute rounding as the incumbent's configuration (same page, *Union Codes* slides). The remaining items — #1–#5, #9–#11, #16, #18, #19, #21, #23, #24 — have nothing new; the list as a whole still needs TCG management, counsel and the union to sign it off.

## ADP export mapping — 9 open decisions, 6 blocking

- Question: which ADP codes, tax treatments and import methods do the new pay components use?
- Candidates: none.
- Note: enumerated as D-001…D-009 in `payroll/adp-bucket-crosswalk.md`, which marks six of them
  **"Blocks CodingCops: Yes"**. The blocking six: a complete live **ADP validation-table export**
  (D-001); codes for **guaranteed hours** ST/OT/DT (D-002); a code for the **rest-period premium**
  (D-003); a code for the **WTL/missed-meal premium** (D-004); a dedicated **Special Saturday**
  code (D-005); confirmation that **HDD means Holiday Double and HOL means Holiday Triple** in the
  live ADP setup (D-006); plus accumulator/hours-flag settings for every new code (D-009).
- **D-001 and D-006 RESOLVED 2026-08-13** by a live call to
  `GET /events/payroll/v1/pay-data-input.modify/meta` —
  [payroll/adp-api-responses/pay-data-input-meta.md](adp-api-responses/pay-data-input-meta.md).
  - **The company codes are `4RZ` (THE CRANE GUYS LLC) and `4RY` (The Crane Guys, LLC - Ventura).
    `631` is not a company code at all.** The standing instruction to treat 631 and 4RZ as
    different identifiers is discharged — they were never the same *kind* of identifier.
  - **Every "missing" code exists.** `LPR/LPO/LPD/LPT`, `LOR/LOO/LOD/LOT`, `S2R/S2O/S2D/S2T`,
    `S3R/S3O/S3D/S3T` and `LBT` are all live under 4RZ. The 2026-06-04 export was partial, not
    evidence of absence. D-001 no longer blocks.
  - **D-006 answered:** ADP's own `longName` gives `HDD` = *Holiday Double*, `HOL` = *Holiday
    Triple*, exactly as the crosswalk hoped.
- **Still blocking: D-002 (guaranteed hours), D-003 (rest premium), D-004 (WTL/meal premium),
  D-005 (Special Saturday), D-009 (accumulators / include-in-total-hours).** None of those codes
  exist in the live table, which confirms they must be created — a manual Workforce Now UI task,
  since no API can create an Hours & Earnings code.
- Blocked: the ADP export rule (`PR-067` in the rule matrix, `PR-055` in the requirements
  document — see the id warning).
- Owner: payroll manager, ADP administrator, HR/accounting depending on the decision.
- **Status:** **partially resolved** — 2 of 9 decisions closed by live API evidence; 5 still blocking.
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#adp-export-mapping-9-open-decisions-6-blocking](gaps-2026-08-20-retired.md#adp-export-mapping-9-open-decisions-6-blocking)

## Union agreement — three source PDFs are unreadable scans

- Question: not a product question — a retrieval gap worth recording.
- Note: three of the five full copies of the Local 12 Master Labor Agreement in the source drop
  are **scanned images with no text layer**. `pdftotext` returns zero characters. They are
  `MCOG-O. E. Local 12 Truck Crane Master Labor Agreement 2025-2028.pdf` (3.4 MB),
  `07.01.2025 truck crane MLA (1).pdf` (2.6 MB), and `OE-Local-12-MLA-25-28-Comp.pdf` (2.4 MB).
  The payroll-relevant articles are available via the extract in
  `payroll/mcog-l12-mla-2025-2028/`, so this blocks nothing today — but **any question that
  reaches outside the payroll articles cannot currently be answered from the vault**, and would
  need OCR or the SCCA-hosted copy.
- Note also: the workbook that cites the SCCA copy warns its own text extraction "may [contain]
  some minor (but important) errors when converting".
- Blocked: nothing today.
- Owner: whoever next needs a non-payroll article of the agreement.
- **Status:** resolved 2026-09-04 — answered from the record, no client question needed. All three scans were OCR'd on 2026-09-04 and turned out to be three different documents; the complete Truck Crane MLA is now in the vault as clean Word text, so every article — payroll or not — is citable.
- Resolution: (a) The retrieval gap is closed by the vault's own record, not by a client statement. [mcog-l12-mla-2025-2028/INDEX.md](mcog-l12-mla-2025-2028/INDEX.md) → *The scanned PDFs — OCR'd 2026-09-04*: the 40-page `MCOG-O. E. Local 12 Truck Crane Master Labor Agreement 2025-2028.pdf` is the Truck Crane MLA itself → [ocr-truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/ocr-truck-crane-mla-2025-2028-full-text.md); the 108-page `OE-Local-12-MLA-25-28-Comp.pdf` is the **SCCA Southern California MLA**, a different and broader agreement → [ocr-southern-california-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/ocr-southern-california-mla-2025-2028-full-text.md); the 4-page `07.01.2025 truck crane MLA (1).pdf` is Local 12's **wage and fringe notice of 2025-08-15**, not the agreement → [local-12-wage-notice-2025-08-15.md](mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md), transcribed figure by figure against the image.
- Resolution: (b) The OCR is no longer the best copy. The `MCOG … 2025-2028 EXTRACTED.docx` that the 2026-08-13 pass dispositioned as a duplicate of the payroll summary is the *whole* Truck Crane agreement as clean text — 17 articles, Appendix A, the in-cab camera MOU and the executed signature page (TCG a party through Wesley Staley, signed 2025-09-10 / 2025-10-31) → [truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md). [source-manifest.md](source-manifest.md) → *Scanned images* and *Full agreement text* record both corrections.
- Resolution: (c) What stays true: the human-transcribed parts 01–05 remain the citable text for payroll clauses; the workbook's warning that its own text conversion may carry *minor (but important) errors* still applies to the OCR pages, which is why the Word-text page supersedes them; and whether any TCG work falls under the SCCA agreement is unestablished — a product question for the register, not a retrieval gap.
- Sources checked: mcog-l12-mla-2025-2028/INDEX.md; the three full-text pages and the wage notice; source-manifest.md (2026-09-04 re-share note); sync/project-repository-2026-09-04.md.
- Owner: answered; no client action outstanding.
- **From (frozen original):** [gaps-2026-08-20-retired.md#union-agreement-three-source-pdfs-are-unreadable-scans](gaps-2026-08-20-retired.md#union-agreement-three-source-pdfs-are-unreadable-scans)

## Field-ops lunch capture vs payroll WTL

- Question: the mobile app captures lunch events and the payroll module prices them, but the two
  document sets were written independently and disagree. Which side is right on each point, and
  who owns the reconciliation?
- Candidates: not a choice between documents — a seam between two modules, both specified,
  neither citing the other.
  - Capture side: `brs.md` (BRS-LUNCH-001…005, BRS-PAY-003), plus `FR-FOP-013`
    Lunch Monitoring / Lunch Timer and Alerts, `FR-FOP-014` Lunch Recording, `FR-FOP-015` Work
    Through Lunch, `FR-FOP-023` Labor Details. **The `FR-FOP-NNN` ids are themselves ambiguous
    across the two field-ops FRDs** — see *Field operations mobile app* above.
  - Pricing side: `payroll/wtl-charts.md`, `payroll/mcog-l12-mla-2025-2028/01-article-iii-working-rules.md`
    (Meal Periods, Rest Periods), `payroll/payroll-app-current-state/03-payroll-rule-catalog.md`
    (`WTL_MEAL_DEDUCT`, `WTL_DT_FLOOR`, `WTL_APPLICABLE_ADD`, `REST_PERIOD_PREMIUM`).
- **Updated 2026-08-13 after the Confluence drift re-migration.** The Atom user-stories page
  (Confluence v10, updated 2026-08-11) now states lunch thresholds explicitly for the first time,
  which turns a silence into a **numeric contradiction**:

  | Lunch | Atom mobile app (v10) | Payroll WTL charts (rev. 2026-01-23) | |
  | --- | --- | --- | --- |
  | 1 | before **5** hours | marker at **5:01** | consistent |
  | 2 | before **10.5** hours | marker at **10.5:01** | consistent |
  | 3 | before **16.5** hours | marker at **16:01** | **disagree by 0.5 h** |
  | 4 | before **22** hours | marker at **21.5:01** | **disagree by 0.5 h** |

  The payroll charts cite the L12 Master Labor Agreement, page 26 section F, and were revised by
  Danny Bryan and Mike Vlaming. The Atom page is a CodingCops-authored user story with no cited
  source. **A missed third or fourth meal is a double-time penalty, so this is a money
  difference.** An alert fired on the wrong threshold causes the penalty it exists to prevent.
  **Code check 2026-08-13** ([payroll/legacy-payroll-app-code-extract.md](legacy-payroll-app-code-extract.md)):
  the legacy source confirms the *mechanics* — four meals, taken meal = `WTL_MEAL_DEDUCT`, missed
  meal = paid add — but the threshold values live in SQL procedures not present in the archive.
  Still open.
  Neither value should be implemented until reconciled.

- Three further discrepancies:
  1. **How many lunch thresholds exist.** `BRS-LUNCH-002` lists **three** (First, Second, Third)
     and is marked **✓ Confirmed**. The payroll charts define **four**, and the Atom page (v10)
     now also defines **four** (Lunch 1–4). Two independent sources say four; the ✓ Confirmed BRS
     rule says three. **The BRS is now the outlier** and is most likely simply stale.
  2. **Lunch threshold values.** `BRS-LUNCH-005` is marked **📄 Needs Supporting Documentation**.
     The payroll drop supplies exactly that documentation — but it arrived four months later from
     a different source, and a payroll chart is not the same thing as a validated business rule.
     The charts are also hand-built and contain arithmetic that does not always reconcile (noted
     in `payroll/wtl-charts.md`).
  3. **Previous-day rest.** `BRS-PAY-003` is marked **⚠ Needs Client Validation** and mentions
     "eight-hour rest periods, double-time implications". This is contract text in MLA Article III
     and is already implemented (`app.usp_Apply_RestPeriod_Premium`, punitive until 8 hours rest
     is received). The validation the BRS asks for may already exist in a form nobody connected.
- Partially closed 2026-08-13: `BRS-LUNCH-003` (*Lunch Notification Timing*, ⚠ Needs Client
  Validation) now has a candidate answer — the Atom page v10 specifies a notification **1 hour
  before** each lunch is due. Nothing states that this page constitutes the client validation the
  BRS asked for, so the status is not changed here.
- Note: there is also a **silence**, not a disagreement. The payroll module's anchor-date rule —
  a cross-midnight labor entry belongs to its *start* date — is stated only in
  `payroll/payroll-concepts-shift-job-labor-entry.md`. **No field-ops requirement states it.**
  So whether the capture side assigns cross-midnight entries the same way is unspecified, and the
  ERP requirements document separately lists cross-midnight day-type policy among its 24 open
  decisions. Getting this wrong puts hours in the wrong pay period, at the wrong multiplier.
- Note also: this seam is why `payroll/` is not simply a sibling of `product/`. Payroll consumes
  field-ops output. A change to lunch capture is a payroll change.
- Blocked: nothing today — no ticket has reached the WTL/meal rule. It will block the first one
  that does, and it will block any field-ops work that changes lunch capture.
- Owner: product team to reconcile the BRS against the payroll sources; the three-vs-four
  threshold count needs a payroll-team or union answer, not a product decision.
- **Status:** open

---

**From the client meeting minutes of 2026-08-05 / 07 / 12** — named, owed deliverables and
ADP behaviours discovered while testing the API. Every action item is outstanding unless
someone has confirmed otherwise.
- Legacy behaviour (2026-08-18, code-verified): the payroll app's meal entitlement is
  `cfg.WTL_MaxMealThreshold` — shift span 0.5–5.0 h → 0 meals, 5.5–10.5 → 1, **11.0–16.0 → 2,
  16.5–21.5 → 3**, 22.0–27.0 → 4 (30-minute granularity, so "16.5" is the first span in the 3-meal
  bracket and 16.0 the last in the 2-meal bracket — the 16:01 wording does not appear in the
  code); opportunities modelled at 5.0 / 10.5 / 16.0 / 21.5 h; token `(PAY:WTL_n)` = meals worked
  through, no token ⇒ 0 with a warning; taken meal deducts the full priced slice incl. boom,
  worked-through adds 0.5 h × (base+shift) × 2.0 (or × (2.0 − mult) on weekday ST-start blocks).
  Which of these the ERP should keep is still the open question. Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md) calculations B7.
- **Rules:** [PAY-046](rules/PAY-046-meal-opportunity.md), [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#field-ops-lunch-capture-vs-payroll-wtl](gaps-2026-08-20-retired.md#field-ops-lunch-capture-vs-payroll-wtl)
- Update 2026-09-04 (Project Repository ingest): four new pieces of evidence, no reconciliation. (a) **Payroll side, a further independent source for the thresholds:** [payroll-rule-dependency-matrix.md](payroll-rule-dependency-matrix.md) §11 states 0 meals through 5.0 h, 1 at 5.5–10.5, 2 at 11.0–16.0, 3 at 16.5–21.5, 4 at 22.0–27.0 — the legacy `cfg.WTL_MaxMealThreshold` brackets exactly — so the payroll-side numbers now have three sources and the Atom values (16.5 / 22 at lunches 3–4) remain the outlier. The same paper **disowns the engine's no-token default** — *"Absence of a payroll lunch/WTL code should not cause the ERP to invent a meal"* — and proposes an explicit *Lunch Taken* indicator in place of `WTL:0`; it is a TCG-side recommendation with no stated author and has not been adjudicated (§15 collisions 1–4). (b) **Capture side, as FCC does it today:** the *Work Through Lunch* checklist carries four lunch-time slots plus a signed attestation that a 30-minute meal was taken on any day over five hours ([tcg-rawfms-staging-database/data/fcc-checklist-templates.md](tcg-rawfms-staging-database/data/fcc-checklist-templates.md) → *Work Through Lunch*), and the *Time Stamps* checklist's four-slot copy sits on 55 units against a one-slot copy on 31 ([../field-ops/gaps.md](../field-ops/gaps.md) → lunch-slot count update). Four slots is FCC practice, not a rule. (c) One missed-meal event is now traceable end to end — customer-signed WTL authorization *"Didnt take first or second lunch"* → labor modifier note `0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL` ([../field-ops/e-ticket-worked-example-44944.md](../field-ops/e-ticket-worked-example-44944.md)). (d) [../meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md](../meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md) §5: Brian flagged that TCG is designing a **new payroll process that needs the actual lunch time captured**, deferred to the 9 September call with Corrina. Still needs the client: the 16.0-vs-16.5 / 21.5-vs-22 reconciliation, whether the no-token default flips, and who owns the seam.
- Update 2026-09-07 (2026-09-03 payroll call, [../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md](../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md) §1): the seam narrowed from
  the top. (a) TCG now wants **both** a lunch-taken and a lunch-worked-through signal, and *no
  signal means nothing is added or deducted* (Corrina Bustos 6:46) — the ERP's per-lunch prompt
  (take / work through with WTL authorization) already captures both. (b) Brian Petros 19:03,
  40:38: the load-bearing datum is **when** the lunch fell, because the half-hour prices differently
  in ST/OT/DT/holiday; the five-hour step-by-step prompt is *"essential"*. (c) The third scenario
  TCG described — *"paid straight through"*, all lunches marked taken, no times, no signature, no
  penalty — is **not to be built in the ERP in any form**: Wes Staley, [../decisions/2026-09-03-paid-straight-through-not-in-erp.md](../decisions/2026-09-03-paid-straight-through-not-in-erp.md).
  (d) Self-signed WTL only with a stated reason (customer not on site, driving) — Corrina 12:59.
  What this entry still holds open: the threshold numbers and the fourth-lunch question, unchanged.
- Update 2026-09-10 (Brian Petros, Teams message + screenshot of TCG's internal agenda, relayed 2026-09-11): TCG held an
  **internal** meal/break working session on **2026-09-09** and worked through roughly half of a
  four-item list — `#0` *Employee break Start/End times?*, `#1` *Employee takes all available breaks*,
  `#2` *Employee works all available breaks*, `#3` *Employee takes only some available breaks*.
  (a) `#0` is answered on the screenshot itself — **"yes need to know"**: the ERP must capture the
  **start and end time of each break**, not merely a taken/worked flag. That is the same requirement
  Brian stated on the 2026-09-03 call (19:03, 40:38 — the *when* prices differently in ST/OT/DT/holiday)
  and in [../meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md](../meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md) §5, now confirmed by TCG
  internally; **end time as well as start is new** — every prior source asks only for the time the
  lunch was taken. (b) `#1` — Brian: *"we now have decisive instructions on how to handle all scenarios
  related to #1"*. **The instructions themselves were not shared.** Nothing about scenario #1 may be
  treated as specified until TCG sends them; this bullet records that they exist, not what they say.
  (c) `#2` and `#3` — *"more complicated"*, not reached; TCG resumes with `#2` on **Monday 2026-09-14**.
  (d) Terminology to confirm when the instructions arrive: Brian's list says *break*, and in this vault
  *rest period* is the eight-hour between-shift chain (PAY-045), not a within-shift break — read here as
  the meal/lunch periods of PAY-046/PAY-047, but nothing in the message says so.
  What this entry still holds open: unchanged — the threshold numbers and the fourth-lunch question —
  plus the content of the `#1` ruling and whether break **end** times change the capture contract.
- Update 2026-09-11b (Brian Petros sent `___LUNCH-BREAK_SCENARIOS.xlsx`, sheet *#1 example (2)*):
  the **first client-authored pricing example for scenario `#1`** — full worked example in
  [lunch-break-scenarios-2026-09-11.md](lunch-break-scenarios-2026-09-11.md). What it asserts, on a
  12.0 h weekday shift with two meals: a **taken** meal is deducted **from the bucket the meal falls
  in** (ST 8.0→7.5, OT 4.0→3.5), at the **whole priced slice including boom** ($42.00 at 10:30 AM
  ST+boom; $60.00 at 4:00 PM OT after boom ended) — the legacy `WTL_MEAL_DEDUCT` basis, now stated
  by the client; and the grid prices an OT-with-boom slot at $62.00, confirming
  [../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md](../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md) from the client side. **The sheet's stated
  Total pay $1,012.00 does not follow from its own method** — it deducts the first break twice; both
  independent routes give **$1,054.00**. **Confirmed as a spreadsheet defect by Brian Petros in
  writing, 2026-09-11** — *"you are absolutely correct… that is a problem with the scenario in the
  Excel"*, and he will correct the formula. The method is therefore client-confirmed; only the
  printed total was wrong. **Our WTL rules were run against the example and reproduce both meal
  deductions to the cent** ($42.00 ST+boom, $60.00 OT no-boom), so PAY-046/PAY-047 are not implicated
  — the only engine-vs-workbook difference on this example is $3.00 of OT boom, which belongs to the
  boom-multiplier question, not to WTL. Still not settled by it: the
  threshold numbers and three-vs-four lunches (12.0 h is a value every source agrees on), whether
  boom is multiplied *inside* the deduction (the example never puts a meal in an OT/DT slot while
  boom runs), and whether the DT-after-12 and weekly-40 clocks read the pre- or post-deduction hours.
  Brian's caveat stands: the scenarios were derived assuming the times are unknown, and the ERP will
  know them — so each placement above is the **entitlement schedule**, not observed data.
## ADP codes — TCG owes an updated export

- **Partially delivered 2026-08-09.** Brian Petros supplied **four** codes by chat —
  `FRR`/`FRO`/`FRD`/`FRT` (Foreman REG/OT/DT/TRI), recorded in
  [payroll/foreman-and-military-premiums.md](foreman-and-military-premiums.md).
  **The Military Base premium in the same message has no codes at all.** Roughly twelve of the
  promised sixteen are still outstanding, as is the comprehensive rules documentation.
- **ANSWERED 2026-08-13 — CodingCops pulled the table itself.**
  [payroll/adp-api-responses/pay-data-input-meta.md](adp-api-responses/pay-data-input-meta.md)
  holds the complete live list: **52 Hours & Earnings codes, 65 deduction codes, 16 memo codes**.
  The export TCG owed no longer has to be requested — the API returns it on demand, scoped to a
  company code.
- **The Military Base premium codes existed all along: `MLR`/`MLO`/`MLD`/`MLT`** (Military
  REG/OT/DT/TRI). Brian's 2026-08-09 message said none had been supplied. They were already set
  up in ADP. Nobody told CodingCops, and nobody would have, because the request was framed as
  "send us an export" rather than "give us read access".
- **Codes live in ADP that appear in no TCG document:** `CAO` (CA OT), `1XQ` (CA SPSL 22),
  `1XX` (CA SUP AVAIL), `VT1` (Voting Tim), and the four `ML*` codes.
- **What is still owed is different from what was asked for.** The export is solved; the
  **comprehensive payroll rules documentation** promised at the 2026-08-05 meeting is not, and no
  API can supply it. Neither can the API say which codes are *current*, which are legacy, or what
  each one's accumulator and include-in-total-hours settings are (crosswalk **D-009**).
- Blocked: nothing on the export any more. Rules documentation still blocks rule design.
- Owner: TCG team (payroll / ADP administrator) for the rules; the export is self-serve.
- **Status:** **export resolved**; rules documentation open.
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#adp-codes-tcg-owes-an-updated-export](gaps-2026-08-20-retired.md#adp-codes-tcg-owes-an-updated-export)

## `CAO — CA OT` exists, but the crosswalk reuses generic overtime

- Question: should non-union California overtime map to the dedicated **`CAO`** code rather than
  the generic `O/T Hours` field?
- Candidates: the crosswalk marks three non-union CA overtime rules — daily, weekly and
  seventh-day — as *"APPROVED DESIGN - reuse O/T Hours"*. But the live ADP table contains
  `CAO — CA OT`, which somebody created deliberately.
- Note: this was invisible before 2026-08-13 because `CAO` is absent from the 2026-06-04 export.
  The crosswalk's decision was made without knowing the code existed.
- Note also: if `CAO` is the right target, the same question applies to `1XQ` (CA SPSL 22) and
  `1XX` (CA SUP AVAIL) — California supplemental paid sick leave, which no vault document
  mentions and which the ERP's paid-leave scope (**D-007**) does not cover.
- Blocked: the non-union California overtime mapping.
- Owner: payroll manager / ADP administrator.
- **Status:** open
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#cao-ca-ot-exists-but-the-crosswalk-reuses-generic-overtime](gaps-2026-08-20-retired.md#cao-ca-ot-exists-but-the-crosswalk-reuses-generic-overtime)
- Update 2026-09-04 (Project Repository ingest): current practice is now readable from the workbook's own engine, and it sends non-union overtime as generic `O/T Hours`. The roster query pulls every FCC employee with a craft except `SYS%` — `ADMIN` crafts and salaried staff included — and `qPayrollComponents` maps the sheet's `OT` column to the ADP *O/T Hours* field for every row; there is no `CAO` component anywhere in the ledger, and the export validation knows only `DT/HDD/HOL/SIC/SUB` plus the twenty temp-rate codes ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §1, §3, §6). The ADP Worksheet screenshot shows the same column set with no CA-OT column ([sources/screenshot of ADP labor entry screen.png.md](sources/screenshot%20of%20ADP%20labor%20entry%20screen.png.md)). The legacy app computes CA non-union daily/weekly/seventh-day OT (procedures dated 2026-06-09, [legacy-payroll-app-db-backup-2026-06-23.md](legacy-payroll-app-db-backup-2026-06-23.md)) but formats no ADP feed. This is evidence that `CAO` is unused by the current process, not a decision that it should stay unused; who created it and what `1XQ`/`1XX` are for still need the payroll manager / ADP administrator.

## Ventura — a second ADP company nobody has mentioned

- Question: does **`4RY` — The Crane Guys, LLC - Ventura** have employees, run its own payroll
  cycle, and need its own ERP submission?
- Candidates: none. Every payroll document in this vault assumes a single company. Ventura appears
  in no requirements document, no rule matrix row, no meeting minute, and no Payroll Group
  definition.
- Note: `payrollGroupCode` is **required** on every pay-data submission and *is* the company code,
  so the ERP cannot avoid the question — it must pick one per batch. The 12-department list, the
  52 earning codes and every other code list captured so far are scoped to **4RZ only**; the 4RY
  equivalents have not been pulled and may differ.
- Note also: a wrong company code and a closed payroll cycle return the **identical** error —
  `eventContext/payrollGroupCode is invalid`. A misrouted Ventura batch will not announce itself.
- **Sharpened 2026-08-13.** Ventura exists in ADP in **two** shapes: company code **`4RY`** and
  location **`VEN`**. It is **not** a business unit — that table returned `204`.
- **Largely answered 2026-08-13: `4RY` appears dormant.**
  `GET /payroll/v1/pay-schedule/payroll-groups/4RY` fails with *"No payroll schedules found for
  company code: 4RY"*
  ([payroll/adp-api-responses/pay-schedule.md](adp-api-responses/pay-schedule.md)).
  **A company with no pay schedule cannot run payroll.** No worker carries
  `payrollGroupCode: 4RY`, and none sits on location `VEN`.
- **Consequence: the ERP does not need multi-company submission.** Exactly one company can accept
  pay data, and it is `4RZ`. Design for one, but do not hardcode it — the code list has two
  entries and a dormant company can be activated by a configuration change nobody tells
  development about.
- Residual question for TCG: is `4RY` intended for future use, or legacy? Cheap to ask, and the
  answer decides whether the ERP models company as a field or a constant.
- Blocked: nothing now.
- Owner: TCG payroll.
- **Status:** **largely resolved** — residual question open
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#ventura-a-second-adp-company-nobody-has-mentioned](gaps-2026-08-20-retired.md#ventura-a-second-adp-company-nobody-has-mentioned)
- Update 2026-09-30 (Jay (ADP implementation project manager), email to Brian Petros and Syed Haris, 2026-09-30, after Josie forwarded Brian's request): ADP confirms `4RY` *"is assigned, it is not set up so it will not work as a test code"*. It will not become a test company. The single-company design stands.
- Update 2026-09-28 (ADP Integration Sync, [../meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md](../meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md) §1.1): Corrina answered the residual question. `4RY` *"is a dead code … made because we were going to use it for something else, but they're deleting it"* (6:43). She did not call it Ventura. At the dev team's request she asked ADP to keep it as a possible test company. As set up today it can't take a new hire. The single-company design stands, though `4RY` may reappear as a test target.

## ADP returns two incompatible error envelopes, and one has no machine-readable code

- Question: how does the ERP parse ADP errors uniformly?
- **It cannot.** Two shapes observed, and they disagree on every field name
  ([payroll/adp-api-responses/pay-schedule.md](adp-api-responses/pay-schedule.md) §6):
  - **Code-list family** — root `confirmMessage`, nested
    `resourceMessages[].processMessages[].processMessageID.idValue` carries a machine-readable code
    (`API_AccessDeniedFeature`), ISO 8601 UTC timestamps.
  - **Pay-schedule family** — root **`_confirmMessage`** (leading underscore), flat `messages[]`,
    **`messageCode: null`**, timestamp in `Thu Aug 13 12:47:29 EDT 2026` format.
- **This corrects earlier guidance in this vault.** "Branch on `processMessageID`" holds only for
  the code-list family. Elsewhere the only discriminator is `messageText`, which is prose and will
  change without notice.
- Note: both wrap the real message in the boilerplate prefix `"Label not found, missing following
  key: "`. Strip it before display.
- Note also: both leak the internal ADP host `pulsar-marketplace-prod.es.oneadp.com` in
  `links[].href`. Do not persist or display it.
- **Still unknown: which envelope `pay-data-input.modify` uses on failure.** That is the one that
  matters most, and it has not been observed — the guide only quotes a bare `messageText`.
- Blocked: the ERP's ADP error-handling design.
- Owner: CodingCops.
- **Status:** open
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#adp-returns-two-incompatible-error-envelopes-and-one-has-no-machine-readable-code](gaps-2026-08-20-retired.md#adp-returns-two-incompatible-error-envelopes-and-one-has-no-machine-readable-code)

## Home yard cannot come from ADP — subsistence has no upstream source

- Question: where does the ERP get **home yard / reporting location**, required by
  [payroll/erp-payroll-module-frd/02-payroll-period-and-source-data.md](erp-payroll-module-frd/02-payroll-period-and-source-data.md)
  and by **PR-048 Standard Subsistence**?
- Candidates: not ADP. `GET /codelists/hr/v3/worker-management/locations/WFN/1` returns exactly
  **two** values — `DEF — DEFAULT LOCATION` and `VEN — Ventura`
  ([payroll/adp-api-responses/codelist-worker-management.md](adp-api-responses/codelist-worker-management.md)).
- Note: PR-048 turns on *home yard, job, distance, overnight and equipment status*. A two-value
  list, one of which is literally "DEFAULT", expresses none of that. Home yard must be mastered in
  the ERP, sourced from FCC.
- Blocked: subsistence rule design; the employee-master migration scope.
- Owner: CodingCops, with TCG payroll to confirm the FCC field.
- **Status:** open
- **Rules:** [PAY-048](rules/PAY-048-standard-subsistence.md), [PAY-049](rules/PAY-049-weekend-subsistence.md), [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#home-yard-cannot-come-from-adp-subsistence-has-no-upstream-source](gaps-2026-08-20-retired.md#home-yard-cannot-come-from-adp-subsistence-has-no-upstream-source)
- Update 2026-09-04 (Project Repository ingest): the FCC field is now on record, and there are three of them. `stg.FMS_EMPLOYEES_Raw` carries `YardCode char(2)` ([tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql](tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql):18), and so do `FMS_UNITS` (`YardCode`, plus `YardCodePL`) and `FMS_JOB_MASTER` (`YardCode`); FCC's employee import template makes `Yard` a **required** field per employee ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §7). Two things complicate "copy the employee's yard": TCG's annotated deck asks for employee ↔ yard **many-to-many** (*"Some Employees may be working/associated with more than one Yard"*, same page §8), and the full MLA text ties subsistence distance to the **equipment's** identified home location, not the person's — Art. V §2, *"forty-five miles or more from yard location in which Employer's equipment in question is identified as home location"*, with a 60-day rule when a new home location is established and a *Multiple Yard Locations* clause ([mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md) → Article V). [decisions/2026-09-01-subsistence-not-a-craft-attribute.md](../decisions/2026-09-01-subsistence-not-a-craft-attribute.md) already moves the distance calculation to the job (yard-to-job on the permitted route). FCC holding a yard code is evidence of practice, not a TCG decision; which yard — employee's, unit's or job's — PR-048 measures from still needs TCG payroll.

## Union codes — one value, so the CRUD question mostly dissolves

- Question: does the ERP need the ability to add union codes, as asked in
  [meetings/2026-06-26-discussion-points-with-tcg-team.md](../meetings/2026-06-26-discussion-points-with-tcg-team.md)?
- Candidates: ADP holds exactly **one** union code — `L12 — Local 12`.
- Note: with one value that changes only if TCG signs a second labour agreement, a CRUD screen is
  hard to justify. The narrower live question is whether the ERP masters `L12` or reads it from
  ADP.
- Note also: **union code cannot derive the Payroll Group.** `L12 Labor Union Field` and
  `L12 Labor Union Mechanic` both carry `L12`; the split is `Employee.EmpTypeID = 3`. The existing
  derivation rule is confirmed, not replaceable.
- Blocked: nothing. Scope reduction only.
- Owner: CodingCops / TCG product.
- **Status:** open, but narrowed
- **Rules:** [PAY-003](rules/PAY-003-employee-master-import.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#union-codes-one-value-so-the-crud-question-mostly-dissolves](gaps-2026-08-20-retired.md#union-codes-one-value-so-the-crud-question-mostly-dissolves)
- Update 2026-09-04 (Project Repository ingest): a client-authored statement now exists, but its audience is unclear. TCG's annotations on the FCC *Maintain Employees* deck say *"We currently only work with one Union; however, need the ability to have multiple Labor Unions"* ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §8) — written on FCC screens, and the page records it as a request to FCC rather than an ERP requirement. The same deck's *Union Codes* slides show what a union code carries in FCC: the L12 record is the parent of the fringe lines (7 funds, $35.50/h), the 31-row craft rate table, the 52 craft modifiers and the payroll defaults (OT after 8, DT after 12, Saturday all-OT, 30-minute rounding), so in the incumbent "adding a union" means adding a whole rule set, not a code (same page, *Union Codes — TCG's live L12 configuration*; `FMS_EMPLOYEES.UnionCode varchar(10)` on the employee). Evidence of how FCC is shaped, not a TCG decision for the ERP. Whether the multi-union ask applies to the ERP, and whether the ERP masters `L12` or reads it from ADP, still need TCG product.

## ADP's error envelope is now known — but the success envelope is not

- Question: does a **successful** `pay-data-input.modify` return a `confirmMessage` with a
  `confirmMessageID` GUID, the way a failure does?
- Candidates: unknown — no successful pay-data write has been made, and none should be made
  casually against production payroll.
- Note: a `403` from `eligibility-classes` returned the full ADP envelope for the first time —
  `confirmMessage` with `protocolStatusCode`, `requestStatusCode`, a per-request
  `confirmMessageID` GUID, and `resourceMessages[].processMessages[].processMessageID` as the
  machine-readable error code
  ([payroll/adp-api-responses/codelist-worker-management.md](adp-api-responses/codelist-worker-management.md)).
  The ERP must branch on `processMessageID`, never on `userMessage.messageTxt`.
- **Why it matters:** the Payroll Data Input guide documents success as `200 OK` with
  `messageText: NA` and no identifier, which is the basis for the finding that ADP gives no
  receipt. **If a success also carries a `confirmMessageID` GUID, that finding is partly wrong** —
  there would be a correlation handle after all. Nothing in ADP's documentation settles it.
- Note also: `requestLink.href` leaks an internal ADP host
  (`pulsar-marketplace-prod.es.oneadp.com`). Do not persist or display it.
- Blocked: the ERP's ADP error-handling design; the "no receipt" architecture finding.
- Owner: CodingCops — resolvable by inspecting any successful `200` response body from a read
  endpoint first, before ever writing.
- **Status:** resolved 2026-10-09 — **no receipt.** A successful `pay-data-input.modify` returns `events[0].data.output.payDataInput`, an echo of the input padded with empty arrays and `"links": []`, with **no `confirmMessage`, no `confirmMessageID` and no ADP batch name** (the echoed `payrollProcessingJobID` is the client-supplied one, without the characters ADP appends). The *no receipt* finding stands. Observed on the first live POST: [adp-api-test-2026-10-09.md](adp-api-test-2026-10-09.md) §3.
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#adps-error-envelope-is-now-known-but-the-success-envelope-is-not](gaps-2026-08-20-retired.md#adps-error-envelope-is-now-known-but-the-success-envelope-is-not)

## Non-union pay rates have no upstream source — ADP will not return them

- Question: where does the ERP get the **non-union hourly rate** that **PR-009** sources from
  *"Employee master PayRate"*?
- **Not from ADP.** `baseRemuneration` returns `nameCode`, `currencyCode` and `effectiveDate`, but
  **`amountValue` is absent on every rate for every worker** — hourly, annual, pay-period salary
  and every `additionalRemunerations` entry
  ([payroll/adp-api-responses/workers-list.md](adp-api-responses/workers-list.md)).
  Almost certainly a use-case entitlement boundary: the API Central project is scoped to Payroll
  Input, not compensation.
- Note: union rates were always going to come from the craft table, so this was assumed solved.
  It is not — **non-union rates now have no readable source either** and must be mastered in the
  ERP, migrated from FCC alongside `CraftRates` / `CraftModRates`.
- Note also: `effectiveDate` **is** returned, and many active workers show `2026-07-01` — evidence
  the MLA wage increase was applied on schedule, even though the amount is invisible.
- Blocked: PR-009; the employee-master migration scope.
- Owner: CodingCops (design), TCG payroll (confirm whether a second API Central project scoped to
  compensation is wanted).
- **Status:** resolved 2026-09-04 — answered from the record, no client question needed. The ERP masters it — `Employee.hourlyRate`, one rate per person, migrated from FCC's `FMS_EMPLOYEES.PayRate`; ADP was never going to be the source.
- Resolution: (a) The design answer is an existing decision note: [decisions/2026-08-25-non-union-base-rate-per-person.md](../decisions/2026-08-25-non-union-base-rate-per-person.md) (`verified`) — the base-rate resolver branches on the craft's union kind; `NON_UNION` → `Employee.hourlyRate` at its current value, *"one rate per person, as in FCC today"*, converging with Brian Petros's written client statement of 2026-06-09 carried in [rules/PAY-012](rules/PAY-012-non-union-hourly-rate.md) (*use employee-master hourly rate; do not use union craft rate*). [decisions/2026-06-30-adp-erp-employee-data-ownership.md](../decisions/2026-06-30-adp-erp-employee-data-ownership.md) (Brian and Ehtesham, agreed on the thread) is consistent: ADP owns the *official* payroll rate, and the ERP may hold an operational rate its own calculations need.
- Resolution: (b) The upstream column is a system fact, now on record from FCC's own schema: `stg.FMS_EMPLOYEES_Raw` holds `PayRate numeric(16,3)`, `PayRateOT`, `PayRateDB` (plus the billing trio) — [tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql](tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql):24–27; FCC's import template exposes the same six non-union rate fields ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §7); and the live workbook roster shows the practice — `CraftType ADMIN` employees carry `EmployeePayRate` from FCC with blank FY craft-rate columns, L12 employees the reverse ([adp-sop-v3.8.md](adp-sop-v3.8.md) → *PAYROLL_START*).
- Resolution: (c) The owner line's sub-item — a second API Central project scoped to compensation — is not needed for the rate source and nobody has said it is wanted for anything else; it stays an unasked, non-blocking item, not part of this question.
- Sources checked: decisions/2026-08-25-non-union-base-rate-per-person.md; decisions/2026-06-30-adp-erp-employee-data-ownership.md; rules/PAY-012; tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql; fcc-employee-master-reference-data.md §7; adp-sop-v3.8.md screenshots section; adp-api-responses/workers-list.md.
- Owner: answered; no client action outstanding.
- Legacy behaviour (2026-08-18): the payroll app takes the non-union rate from
  `FMS_EMPLOYEES.PayRate` (NexGen employee master) — `api.v_UI_Employee_TypeRate`,
  `BaseHourlyRateSource = 'Employee.PayRate'`; union rates from `FMS_UNION_CRAFT.PayRate` by the
  labor row's craft. So the upstream today is NexGen, not ADP. Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).
- **Rules:** [PAY-012](rules/PAY-012-non-union-hourly-rate.md), [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#non-union-pay-rates-have-no-upstream-source-adp-will-not-return-them](gaps-2026-08-20-retired.md#non-union-pay-rates-have-no-upstream-source-adp-will-not-return-them)

## `payrollCustomArea4` — a per-worker code nobody has documented

- Question: what is `workAssignments/customFieldGroup/stringFields/payrollCustomArea4`?
- Candidates: a varying 3–4 digit number, unique-ish per worker, present on most older records and
  absent on recent ones. Its sibling `payrollCustomArea3` is the constant `A8906799` on every
  record — plausibly a policy or account number.
- Note: undocumented per-worker codes held in a payroll system are exactly the kind of thing that
  turns out to be load-bearing. Worth one question to Payroll before the employee-master migration
  is designed.
- Blocked: nothing yet.
- Owner: TCG payroll.
- **Status:** open
- **Rules:** [PAY-003](rules/PAY-003-employee-master-import.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#payrollcustomarea4-a-per-worker-code-nobody-has-documented](gaps-2026-08-20-retired.md#payrollcustomarea4-a-per-worker-code-nobody-has-documented)

## `eligibility-classes` is 403 — an entitlement question, not a data question

- Question: does TCG need benefits-eligibility data in the ERP, and if so does it need a second
  API Central project?
- Candidates: the current project is scoped to the **Payroll Input (Read/Write)** use case.
  `eligibility-classes` returns `403 API_AccessDeniedFeature` — *"You do not have access to this
  feature."* That is a licensing boundary, **not** an empty table.
- Note: this is the first observed evidence of what the use-case selection actually gates. It also
  means a `403` and a `204` must be handled differently by any ERP sync — one is "not entitled",
  the other is "nothing configured".
- Note also: **the certificate covers all projects**, so adding a second project (e.g. Employee
  Sync) costs a form, not a new credential. Worth doing to discover what else is reachable.
- Blocked: any ERP feature depending on benefits or eligibility data.
- Owner: CodingCops (project creation), TCG (scope decision).
- **Status:** open
- **From (frozen original):** [gaps-2026-08-20-retired.md#eligibility-classes-is-403-an-entitlement-question-not-a-data-question](gaps-2026-08-20-retired.md#eligibility-classes-is-403-an-entitlement-question-not-a-data-question)

## Labor allocation — department today, cost number if TCG wants job attribution

- Question: should TCG switch Workforce Now Labor Distribution from **Department** to **Cost
  Number** so the ERP can attribute hours to jobs in ADP?
- Candidates: today it is Department. Evidence:
  `GET /codelists/hr/v3/worker-management/cost-numbers/WFN/1?companyCode=4RZ` returns **`204 No
  Content`** while `departments` returns 12 org units —
  [payroll/adp-api-responses/codelist-departments.md](adp-api-responses/codelist-departments.md).
- Note: the 12 departments are org units — Operators, Oilers/Drivers, Mechanics, Yard, Field,
  Safety, Sales, Dispatch, Accounting, Management, Salary Admin, Officer. They say *what kind of
  worker*, never *which job*. TCG runs far more jobs than twelve.
- Note also: the ERP **could** mint cost numbers as job numbers —
  `POST /hcm/v1/validation-tables/cost-centers` exists. But switching Labor Distribution is a
  company-wide payroll configuration change affecting every existing labour-distribution report,
  and it belongs to Payroll, not development.
- **Consequence either way: certified payroll cannot come from ADP.** Davis-Bacon needs job plus
  craft classification per worker; ADP carries neither, and payroll-output APIs are not sold to
  Workforce Now clients. Certified payroll is an ERP report. This closes an assumption both
  architecture drafts left open.
- Blocked: the job-attribution design; the certified-payroll module's data source.
- Owner: TCG payroll (configuration) and CodingCops (ERP design).
- **Status:** open
- **Rules:** [PAY-004](rules/PAY-004-labor-entry-import.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#labor-allocation-department-today-cost-number-if-tcg-wants-job-attribution](gaps-2026-08-20-retired.md#labor-allocation-department-today-cost-number-if-tcg-wants-job-attribution)
- Update 2026-09-04 (Project Repository ingest): the file TCG actually sends carries **no allocation field at all**. The paydata CSV is `Co Code · Batch ID · File # · Reg Hours · O/T Hours · Temp Rate` plus code/amount pairs — no department, cost number or job on any row ([adp-workbook-vba-macros.md](adp-workbook-vba-macros.md) §2, [adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §4), and the ADP Worksheet the batch lands in has the same column set ([sources/screenshot of ADP labor entry screen.png.md](sources/screenshot%20of%20ADP%20labor%20entry%20screen.png.md)). So job attribution does not reach ADP today by any route; whatever Labor Distribution setting WFN holds is filled by the worker's home department, not by the batch. Separately, the 2026-09-02 demo has Joe placing the federal / certified-payroll flag **at the quoting stage or on the job** ([../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) §3), which is where an ERP-side job attribution would originate. Evidence of practice; the Department-vs-Cost-Number switch is still TCG payroll's to make.

## ADP code strings collide between the earning and deduction arrays

- Question: how does the ERP's ADP mapping configuration prevent a code being sent to the wrong
  input array?
- Candidates: none — the crosswalk's recommended configuration table is keyed on `ADPCode` with an
  `ADPFieldGroup` column describing *Excel* column positions, which no longer exist on the API.
- Note: the live code lists collide. `LPR` is **LATT OP REG** as an earning and **Life Post** as a
  deduction. `LPO` is **LATT OP OT** or **Life Post**. `ONC` and `SUB` collide too. Sending a code
  to the wrong array pays or deducts the wrong thing **and returns `200 OK`** — ADP validates that
  the code exists in the target list, not that it was the intended one.
- Note also: the API has **two** earning arrays — `earningInputs` and `codedHoursEarningInputs` —
  which accept the same code list but are separate structures. Which one each ERP component
  targets is an unmade design decision.
- Blocked: the ADP mapping configuration schema; crosswalk implementation rules 3, 4 and 5.
- Owner: CodingCops.
- **Status:** open
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#adp-code-strings-collide-between-the-earning-and-deduction-arrays](gaps-2026-08-20-retired.md#adp-code-strings-collide-between-the-earning-and-deduction-arrays)
- Update 2026-09-04 (Project Repository ingest): the workbook solves the same problem for the CSV path with **fixed slots and a blocking validation**, which is worth copying in spirit. Every code has one place: `DT·HDD·HOL·SIC` are Hours-3 pairs 01–04, `SUB` is Earnings-3 pair 01, and the twenty temp-rate codes sit in Hours-4 slots 01–20 by code (`LBH…LBT`, `LPR…LPT`, `LOR…LOT`, `S2R…S2T`, `S3R…S3T`); `qADPImportValidation` raises an `ERROR` for *Hours-4 code in the wrong slot*, *DT/HDD/HOL/SIC/SUB in the wrong place* and *unpaired code/amount fields*, and the VBA exporter refuses to write on any `ERROR` ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §4, §6; [adp-workbook-vba-macros.md](adp-workbook-vba-macros.md) §2). The CSV never carries a deduction column, so the `LPR`/`LPO` earning-vs-deduction collision cannot occur on that path — it is an API-only hazard. Evidence of the incumbent's mechanism, not a design decision; the ERP's mapping schema and the `earningInputs` vs `codedHoursEarningInputs` choice remain CodingCops'.

## Payroll calculation logic — Brian owes a revised version

- Question: has the payroll calculation logic changed since the documents in `payroll/`?
- Candidates: the vault holds the 2026-08-05 rule matrix and the 2026-06-23 rule catalog. Brian
  (TCG) undertook on 2026-08-05 to share **revised** calculation logic, plus comprehensive
  documentation of all payroll rules, plus Corrina's Value Engineering / Payroll Workflow
  documentation. **None has arrived.**
- Note: until it does, the migrated payroll documents stand as written. **Do not assume a rule has
  changed because a revision was promised.** When it arrives it may supersede parts of
  [payroll/codingcops-rule-matrix.md](codingcops-rule-matrix.md) — treat that as a
  re-migration, not an edit.
- Blocked: nothing yet; it will block rule implementation that the revision touches.
- Owner: Brian Petros (TCG); Corrina (TCG) for the Value Engineering workflow.
- **Status:** open
- **From (frozen original):** [gaps-2026-08-20-retired.md#payroll-calculation-logic-brian-owes-a-revised-version](gaps-2026-08-20-retired.md#payroll-calculation-logic-brian-owes-a-revised-version)
- Update 2026-09-04 (Project Repository ingest): something has arrived, and it is not the promised documentation. The drop's one file absent from the 2026-08-13 manifest is `Payroll-rule dependency matrix.docx` → [payroll-rule-dependency-matrix.md](payroll-rule-dependency-matrix.md): a ~9,000-word TCG-side position paper, **no author line, no date**, whose content matches the 2026-09-04 Brian ↔ Ehtesham exchange point for point ([client-message-findings.md](client-message-findings.md#2026-09-04--rule-lookback-windows-and-recalculation-across-an-approved-week-brian-petros--ehteshamanwar)). It explicitly supersedes parts of the as-built engine — the no-token WTL default (*"latest Payroll Manager direction supersedes some of our earlier WTL assumptions"*), the payroll period as a calculation boundary, guarantees stacking, and closed-period handling (immutable, retro delta) — and its §15 lists sixteen collisions with the vault, none adjudicated. So the calculation logic **has** moved since the `payroll/` documents, at least in those places, but as one person's recommendation rather than a re-migration of the rule matrix. The *Value Engineering / Payroll Workflow* documents turn out to be the 2025 Visio charts in [payroll-value-engines.md](payroll-value-engines.md) — people and hand-offs, not calculation. Still owed by Brian: confirmation that he authored the paper, and the comprehensive rules documentation; still owed by Corrina: nothing further on the workflow charts unless they have changed since 2025.

## Lattice Crane identification

- Question: can Lattice Crane work be identified automatically, or must it be entered manually?
- Candidates: today it is **manual** — the ADP crosswalk drives `LPR/LPO/LPD/LPT` and
  `LOR/LOO/LOD/LOT` from `LATT_OPER` and `LATT_OILER` comment tokens.
- Note: Brian raised on 2026-08-05 that this needs discussion with business stakeholders (Kyle and
  Joe) to determine whether automatic identification is possible. Related but not identical:
  `PR-044` *Lattice-boom premium* in the rule matrix is marked **New ERP requirement**, with
  "Confirm interaction with long boom" outstanding.
- Blocked: `PR-044`, and the lattice earning-code mappings.
- Owner: Kyle and Joe (TCG business stakeholders), via Brian.
- **Status:** open
- **2026-08-19:** the 2026-08-04 "Payroll Process" recording has **Joe answering this directly** —
  crawler crane only, every dispatch qualifies, lattice on any other crane is a jib extension /
  luffing jib earning boom pay only; Corrina adds operator-and-oiler-only and that lattice **stacks**
  with boom pay. Not written up as a decision (a transcript is not minutes). See
  §*Lattice — Joe settled it on the recording, nothing records it* for the wording and the
  confirmation question.
- Legacy behaviour (2026-08-18): the payroll app has **no lattice concept at all** — no `LATT*`
  comment token, no branch, no code; the only boom concept is the craft-modifier bracket
  (`OP-BP/OI-BP`) adder. Lattice identification is a new build. Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).
- **Rules:** [PAY-044](rules/PAY-044-lattice-boom-premium.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#lattice-crane-identification](gaps-2026-08-20-retired.md#lattice-crane-identification)
- **2026-08-24 (message batch):** Corrina's 5/18 Teams citation (**$1 op / $0.50 oiler, Group 6+,
  MLA p.39**) matches the vault's contract extraction verbatim — rates settled. **Reopened
  sub-question: luffers.** Jeff Stricker says add-on luffers are "technically lattice"; Joe's
  08-04 answer classed luffing jibs as boom-pay-only. **Owner: Kyle.** Identification design
  candidate on the table: Boom Type on the asset subcategory.
- **2026-08-24, Kyle's answers (message 20):** Group 6+ confirmed as a *qualification* constraint;
  boom configuration is per-job and stable → identification = **job-level "Boom Configuration"
  field** (supersedes the subcategory idea); lattice jobs ≥ 1 week. **Corrina: the premium covers
  the entire job, not boom time.** The identification question is effectively answered in design;
  **the luffer sub-question remains open** — Kyle's relay did not address it.
- Update 2026-09-04 (Project Repository ingest): the contract text is now complete and the trigger was restated on a recording, but the luffer question is still Kyle's. (a) The full Truck Crane MLA carries the lattice clause verbatim — *"One Dollar ($1.00) per hour over and above the hourly wage rate for the operator for lattice boom crane for Group 6 and above and fifty cents ($0.50) per hour … for the oiler"* — and, at Groups 5, 7, 8 and 9, puts mobile tower cranes under **Long Boom pay "including combined total mast and Luffing Boom"** ([mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md) → Article IV; the 2025-08-15 wage notice repeats both figures). That is the contract reading the parked build default (question 21) rests on; it is CodingCops' reading of contract text, not Kyle's confirmation. (b) [../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) §3 — Brian: the adders *"need to be at the job level"*; Joe: *"a crawler on the job populates lattice pay"* — consistent with Kyle's 08-24 job-level *Boom Configuration* answer, still minutes rather than a decision note. (c) Practice today: lattice is a per-day dropdown on the employee sheet, expanded to `LPR…LOT` at $1.00 / $0.50 × 1 / 1.5 / 2 / 3 and sent as temp-rate rows ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §3); FCC's labor row has no lattice field — `CraftModifierCode` and `ShiftInfo` only ([tcg-rawfms-staging-database/ddl/stg.FMS_LABOR_PAYROLL_Raw.sql](tcg-rawfms-staging-database/ddl/stg.FMS_LABOR_PAYROLL_Raw.sql)). Evidence of practice, not a decision.

## Foreman premium — granularity, multiplier and capture

- Question: does the $3/hr foreman premium attach to an **employee-day** or to a **labor entry**,
  and is it multiplied by OT/DT/TRI or flat?
- Candidates: [payroll/foreman-and-military-premiums.md](foreman-and-military-premiums.md)
  is the only source. Brian Petros states the day-level granularity **as an assumption in his own
  words** — "it is assumed that this will be for all hours for that day/row" — and adds that a
  split day needs a separate row.
- Note: the code set includes **`FRT` — Foreman TRI**. A triple-time variant of a premium strongly
  implies the $3 is multiplied, not flat. Nobody has said so. Getting this wrong is a 3x error on
  every foreman hour.
- Note also: **there is no foreman field in FCC.** Capture today is a payroll clerk typing the
  literal token `(PAY:FOREMAN)` into labor-entry payroll comments, after the employee tells them.
  Same pattern as `LATT_OPER`/`LATT_OILER`. An ERP replacing FCC must decide what replaces the
  token and what happens to historical entries carrying it.
- **Code check 2026-08-13:** searched the legacy Payroll App source (`projects.rar`) — **no
  foreman logic exists anywhere**. The premium has never been computed by any system; it is
  handled inside the manual Excel step or not at all. For the ERP this is a new build, not a port.
- Blocked: implementation of the foreman premium; the ADP export rows for `FRR`/`FRO`/`FRD`/`FRT`.
- Owner: Brian Petros (TCG); Jeff Kelley (crane superintendent) for how foreman assignment is
  actually decided and recorded per job.
- **Status:** open
- Legacy behaviour (2026-08-18): confirmed again against the full database — no object, column
  or config row for a foreman premium in any of the 141 definitions. Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).
- **Rules:** [PAY-070](rules/PAY-070-foreman-premium.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#foreman-premium-granularity-multiplier-and-capture](gaps-2026-08-20-retired.md#foreman-premium-granularity-multiplier-and-capture)
- Update 2026-09-04 (Project Repository ingest): three findings, none a decision. (a) **The premium has no route into ADP from the live workbook either.** `(PAY:FOREMAN)` is in the token vocabulary the sheets recognise, but `qPayrollComponents` expands only `LATT_*` and `SHIFT_*`; no foreman component reaches the export, so whatever is paid is folded into hand-typed hours or not paid ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) → *What the code reveals*, item 1). The `FRR/FRO/FRD/FRT` codes exist in ADP with nothing feeding them. (b) **"Shop Foreman" in the Truck Crane MLA is a Group 7 classification, not a premium** ([mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md) → Article IV) — a different thing from Brian's $3/hr company rule, and the only foreman the L12 truck-crane agreement knows. (c) The only contract language on foreman pay *treatment* in the vault is in the **SCCA Southern California MLA** §R: $2.00/hr over the highest supervised classification, *"added to the regular rate and become the base rate for the entire shift"* — i.e. into the rate, multiplied ([mcog-l12-mla-2025-2028/ocr-southern-california-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/ocr-southern-california-mla-2025-2028-full-text.md) → *R. Foreman*). Whether any TCG work falls under that agreement is unestablished, so this is a reference point, not a rule. FCC's labor row has no foreman column. Granularity, multiplier and the capture mechanism still need Brian / Jeff Kelley.
- Update 2026-09-08 (ADP workbook v5.1, [adp-workbook-v5.1-engine.md](adp-workbook-v5.1-engine.md)):
  **the multiplier and capture halves are now answered by practice, not by a decision.** `ADP
  TempRates` configures `FOREMAN` → `FRR/FRO/FRD/FRT` at **$3.00 / 4.50 / 6.00 / 9.00** — multiplied,
  the reading `FRT` implied; capture is a `Foreman` dropdown per sheet row (a day, or a split row),
  which matches Brian's day-level assumption; and the premium now has a route into ADP as temp-rate
  rows. None shipped in week 36. The client's own mapping sheet still marks foreman
  `NOT_IMPLEMENTED` in the app's rules. **Still open:** who decides foreman assignment per job and
  where it is recorded (Jeff Kelley), and what replaces the token in the ERP. Granularity and
  multiplier can be built on the practice reading until a decision note says otherwise.
## Military Base premium — job-level scope, Davis-Bacon list, and the phone call

- Question: how does a job get flagged as a military-base job site, and where does the qualifying-
  location list live?
- Candidates: [payroll/foreman-and-military-premiums.md](foreman-and-military-premiums.md)
  only. **No ADP codes were supplied for this premium.**
- Note: this is the **first premium in the vault that attaches to the job, not the worker** —
  "$10/hr added to ALL hours for ALL employees on the job". Nothing in the payroll data model
  carries a job-level premium. It must be set once on the job and fan out to every labor entry
  against it.
- Note: the determination is **Davis-Bacon's list of qualifying job site locations**, but Brian
  flags that some official job-site locations are *adjacent* to bases and may not qualify — and
  that **the Local 12 Business Agent is phoned to verify when necessary**. That human verification
  has to be modelled as a state with a person and a date, or the ERP will silently guess.
- Cross-link: this makes **Corrina's Davis-Bacon business rules** (owed to Ryan per the
  [7 Aug minutes](../meetings/2026-08-07-labor-compliance-certified-payroll.md)) **a payroll blocker
  as well as a Labor Compliance one.** The same determination drives both Certified Payroll
  eligibility and a $10/hr premium for every worker on the job.
- **Code check 2026-08-13:** no military-premium logic exists in the legacy source either —
  never computed by any system.
- Blocked: implementation of the military premium; job-site data model; Davis-Bacon identification.
- Owner: Corrina (TCG) for Davis-Bacon criteria; Brian Petros for the ADP codes.
- **Status:** open
- Legacy behaviour (2026-08-18): confirmed against the full database — nothing for military /
  Davis-Bacon / prevailing wage in the calculation; certified payroll exists only as a label flag
  (`UseCertifiedPayroll`). Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).
- **Rules:** [PAY-071](rules/PAY-071-military-base-premium.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#military-base-premium-job-level-scope-davis-bacon-list-and-the-phone-call](gaps-2026-08-20-retired.md#military-base-premium-job-level-scope-davis-bacon-list-and-the-phone-call)
- Update 2026-09-04 (Project Repository ingest): the job-level shape was restated by the client on a recording; the qualifying-location list is still nowhere. (a) [../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) §3 — Brian: military, lattice and shift adders *"need to be at the job level"*; Joe: federal wages populate only when **certified payroll / federal job is checked at the quoting stage or on the job**, not as a dispatch-time pop-up. Minutes, not a decision note. (b) The live workbook knows `(PAY:MILITARY)` as a token but exports no military component — the `ML*` codes in ADP have nothing feeding them ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) → *What the code reveals*). (c) The Davis-Bacon companion playbook added today names the **federal funders** whose presence triggers Davis-Bacon — USACE, NAVFAC, FHWA, FAA, FEMA, HUD, DOE — as a sales-side identification aid ([certified-payroll-playbook.md](certified-payroll-playbook.md) §10); it is not a list of qualifying job-site locations and does not address adjacency. The SCCA MLA's Davis-Bacon amendment (bid-time wage rate prevails on wholly federally funded jobs) is a different agreement. (d) FCC carries the concept at two levels — `UseCertifiedPayroll` per classification and `Certified Pay` Y/N per employee — while TCG's deck asks for it **per job / job site**; the three-level collision is recorded in [fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §8 and is the same identification this premium depends on. Still Corrina's: the Davis-Bacon criteria and the location list; still to be modelled: the Business Agent verification as a state with a person and a date.
- Update 2026-09-08 (ADP workbook v5.1, [adp-workbook-v5.1-engine.md](adp-workbook-v5.1-engine.md);
  `EPI4RZ36.csv`): **the premium is paid today, multiplied.** `ADP TempRates` configures `MILITARY`
  → `MLR/MLO/MLD/MLT` at **$10 / 15 / 20 / 30**, and the week-36 export carries `MLR/MLO/MLD` rows
  at 10 / 15 / 20 for one employee. Capture is a `Military` dropdown on the sheet row, keyed by the
  clerk — i.e. still per employee-row, not set once on the job; the "all employees on the job"
  fan-out is done by hand. The app marks military `NOT_IMPLEMENTED`. **Still open, unchanged:** how
  a job is identified as a military-base site, the Davis-Bacon list, and the phone-call state.
## Premium stacking and no-pyramiding

- Question: can a foreman on a military-base job draw both premiums — $13/hr over base?
- Candidates: nothing states it either way. Both premiums are described in isolation.
- Note: the L12 agreement's **no-pyramiding** clause
  ([payroll/mcog-l12-mla-2025-2028/01](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md))
  is exactly the kind of provision that restricts stacked premiums. Note also that Foreman is a
  **company** rule and Military is a **union** rule — whether a company rule is subject to the
  union's pyramiding restriction is a question for labor counsel, not for the codebase.
- Blocked: any implementation where both premiums could apply to the same hour.
- Owner: TCG management / payroll, with labor counsel and the union rep.
- **Status:** open
- Legacy behaviour (2026-08-18, code-verified): the engine prices each 30-min slice as
  `0.5 × (Rate_Base + Rate_Shift + boom?Rate_Boom) × Final_Multiplier` — the shift and boom
  **adders are multiplied by the OT/DT/Sat/Sun/Holiday multiplier**, and one multiplier controls a
  slice (holiday > Sunday > special-Sat > DT > outside-window OT > OT > Saturday). Rest premium
  pays only the delta up to a ×1.5/×2 floor. That is the current stacking rule; whether it is
  the contract's is the open question. Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md) calculations B2.
- **Rules:** [PAY-027](rules/PAY-027-no-pyramiding.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#premium-stacking-and-no-pyramiding](gaps-2026-08-20-retired.md#premium-stacking-and-no-pyramiding)
- Update 2026-09-04 (Project Repository ingest): practice and contract text are now both readable; neither answers the foreman-plus-military case. (a) **Practice:** the workbook exports lattice, shift and boom as *separate* temp-rate rows, each pre-multiplied ×1 / 1.5 / 2 / 3 (`LPR…LOT` at $1.00/$0.50, `S2R…S3T` at $3/$4, `LBH…LBT` at the bracket adder) — so today lattice, shift and boom all stack with one another and all multiply ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §3). That is new evidence against the working decision [decisions/2026-08-25-boom-adder-on-top-unmultiplied.md](../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md), which the note itself says awaits TCG payroll and counsel. Foreman and military have no component in the export, so practice shows nothing about them. (b) **Contract:** the full MLA's clause is *"There shall be no pyramiding of **overtime**"* — Art. III §1 ([mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md)) — a restriction on multipliers, silent on stacking flat premiums; the same article's *Payment of Wages* §5 and Art. IV §3 say a higher rate applies to all time that day; the 2025-08-15 notice and Art. III say shift and hazmat premiums *become the base rate*; the SCCA MLA §R says the same of its foreman rate. (c) [payroll-rule-dependency-matrix.md](payroll-rule-dependency-matrix.md) §15 collision 6 proposes that **guarantees** do not stack — a different question, unadjudicated. Whether a company premium is subject to the union's pyramiding restriction is still one for labor counsel and the union rep.
- Update 2026-09-08 (ADP workbook v5.1): practice now covers foreman and military too —
  `qPayrollComponents` expands `FOREMAN` and `MILITARY` through the same temp-rate table as lattice
  and shift, each as its own pre-multiplied row, and nothing in the validation forbids both on one
  row. So **if a clerk keys both dropdowns, the workbook exports $13/hr × multiplier**. Whether that
  is contract-correct is still the question; no week seen has both.
## ADP product, API Central entitlement and sandbox

- **Product resolved 2026-08-13: ADP Workforce Now (classic).** Confirmed from a screenshot of a
  live practitioner session at `workforcenow.adp.com/theme/admin.html#/home` — classic WFN nav, not
  WFN Next Generation. The documentation set in
  [payroll/adp-integration-capabilities.md](adp-integration-capabilities.md) is therefore
  the correct one.
- **RESOLVED 2026-08-13: TCG already has ADP API Central.** Confirmed from the Marketplace
  `My Apps` screen — **ADP® API Central for ADP Workforce Now® [Launchpad]** and **ADP® API
  Central Help Center** are both entitled, with live `Launch App` buttons. No purchase, no
  procurement, no lead time. Credentials are obtainable today.
- Remaining under this heading: only the "Company Code 631" vs "Co Code 4RZ" identifier conflict.
- **Resolved by the same client statement:** not two identifiers — a **rename in time**
  (631 → 4RZ, July 2026). The conflict dissolves; see §*What `631` actually is* for the evidence.
- **2026-08-24, via client team exchange — Patrick:** *"For adp. We are with workforce but
  upgrading to next level soon."* Product confirmation ✅ (matches the 2026-08-13 resolution).
  **New sub-question — the upgrade:** WFN **Next Generation** timing, scope, and whether API
  Central entitlements/endpoints carry over. Every ADP document in this vault is keyed to
  *classic* WFN; an undated upgrade puts a validity timer on all of it. Owner: Patrick (TCG),
  via Brian.
- Note: the "Company Code 631" vs "Co Code 4RZ" conflict flagged in the crosswalk is **not**
  resolved by this — the product is settled, the company code is not.
- Note: API access is a **separate paid purchase** (ADP API Central), not part of a Workforce Now
  subscription, and its price is not public. The sandbox, the client certificate and the Postman
  collections are **all provisioned with the API Central project** — they are not publicly
  available and cannot be obtained by having an ADP account alone.
- **Sandbox — RESOLVED 2026-08-17: there is no client sandbox on API Central.** Sourced:
  1. ADP's *Marketplace Partner Development Learning Guide*, ch. 2 (last modified 2026-06-22):
     the test sandbox is requested via the **Partner Self Service Portal** ("integration projects
     (DEV and PROD), request a test sandbox instance"; "Click into your Development project …
     click on Test Instance … Request A Test Instance"). That portal and that sandbox belong to
     Marketplace **partners**; TCG is an API Central **client** on the Launchpad.
  2. API Central's own overview / features / adp.com product pages list certificate and
     credential management, use-case templates and ticketed support — **no sandbox, test
     environment or test data**.
  3. The Postman collection ADP generated for the *TCG ERP Integration* project contains 32
     request URLs, **all `https://api.adp.com`** — no test host.
  4. Third-party confirmation (JobsPipe ADP API guide, Jul 2026): clients get credentials via
     their ADP rep; partners "integrate against ADP's sandbox"; "no public self-serve testing
     tier". (Fern, May 2026, mentions a sandbox "tied to API Central registration" — the partner
     one.)
  **Consequence:** the only safe write target for a client is a **test company code inside TCG's
  own WFN instance, created by ADP on TCG's request**. Whether `4RY` (Ventura — no pay schedule)
  is or could become that is a question for TCG/ADP. Whether an API credential can be scoped to
  one company code is **unknown** — ask ADP; do not assert it.
  Until then: read-only calls only; validate payloads locally against the captured
  `pay-data-input.modify/meta`; a mock endpoint for ERP integration tests; any live write only
  as a supervised, immediately-deleted batch with TCG payroll present — a TCG decision.
- Blocked: write-path testing, until a test company exists.
- Owner: TCG (ADP account administrator), with ADP.
- **Status:** open — product and entitlement resolved; **test company requested from TCG 2026-08-17**
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#adp-product-api-central-entitlement-and-sandbox](gaps-2026-08-20-retired.md#adp-product-api-central-entitlement-and-sandbox)
- Update 2026-09-04 (Project Repository ingest): the write path is now sequenced and confirmed blocked. [../meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md](../meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md) §2 and §5: internal scope to 15 September ends at **CSV export for manual ADP import**, ADP API automation starts *after* the 15th, and **API write access appears not to be granted** (read tested, write not) — Ehtesham to send Patrick the exact permissions. The workbook's own parameters settle the identifiers the SOP screenshots only implied: Co Code `4RZ` / `THE CRANE GUYS LLC` in `__hiddenParams`, file name `EPI4RZnn` (counter restarts each payroll year), Batch ID = `YrMoWk` ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §2), while the ADP Worksheet screenshot shows company **`631 - The Crane Gu…`**, batch `ROLL` ([sources/screenshot of ADP labor entry screen.png.md](sources/screenshot%20of%20ADP%20labor%20entry%20screen.png.md)) — consistent with the rename-in-time reading, not new evidence for it. Nothing in the drop touches the test company, credential scoping or the WFN Next Generation date; those remain with TCG (ADP administrator) and Patrick.
- Update 2026-09-28 (ADP Integration Sync, [../meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md](../meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md) §1.1, §2, §5.3): the test-company request has a partial answer, and no test company exists yet. (a) abdulrehman reports that ADP support confirmed there is no separate sandbox. (b) `4RY` was offered as the test company. Corrina asked ADP not to cancel it, but it isn't set up to accept a new hire (no pay codes, *"not set up on the back end"*), so the test hire was made in **live `4RZ`**. (c) The working agreement is to test in `4RZ` with **test employees**: abdulrehman as a union oiler, syed.haris as operator, and Ehtesham as rigger or third man. Brian expects a test POST to appear as a separate worksheet under *Manage payroll*, which Corrina deletes, with her warned in advance (*"we might as well test it"*, 1:05:50), once ADP support is consulted. Brian is to contact Josie at ADP. That is a stated plan, not a recorded decision on live writes. (d) **Screens:** Corrina runs payroll from *Process → Payroll → Payroll Dashboard → Manage payroll*, the new screens that ADP's 2022 *Payroll Dashboard vs Payroll Cycle* guide maps from the classic *Payroll Cycle*. The Next-Generation sub-question above is still open: new screens inside classic WFN, or the upgrade?
- Update 2026-09-30 (Jay (ADP implementation project manager), email to Brian Petros and Syed Haris, 2026-09-30, after Josie forwarded Brian's request): **ADP answered: no test company, test in live `4RZ`.** Verbatim points: *"While code 4RY is assigned, it is not set up so it will not work as a test code. Also, we are not able to set up a test company code."* Instead ADP hires **test employees in the live company**, named **"Emily Employee"** and **"Marty Manager"** so any ADP employee can see they are not real, and *"as long as we never actually pay one of those test employees, we can purge them from the system"*. ADP can also *"manually hire in some test employees that you could connect to in order to synch up File Numbers"*. For pay data: *"we can import this into our live system to create the worksheet in Workforce Now, and we can actually calculate that payroll to view the Payroll Register … Then we can delete that batch. As long as we do not actually Accept or Approve that payroll, we can delete your test data and it will not impact Corrina"*, coordinated with Corrina so it never overlaps a live payroll. **This closes the test-company half of this entry.** Still open: (a) calculating the live week calculates **every** worksheet in that cycle, including Corrina's, so the test must run when her week has no live worksheets or she must "Correct Payroll" afterwards: timing to agree with her and Jay; (b) the test employees' pay type and union setup (a union hourly operator and oiler are needed for the field flow); (c) whether API Central credentials can be scoped (still unasked); (d) the technical API questions (read back or delete a batch via API, batch id, temp-rate input, events, payroll results) have not been sent to ADP.
- Update 2026-10-01 (Brian Petros, email reply to Jay at ADP, undated, text relayed by syed.haris 2026-10-01): **TCG's proposed test plan.** Brian asks Jay to **create the test employees**, because *"I don't think we can create employees via API since we need valid SSNs and need to complete the employee onboarding process to make employee status active"* (Brian's belief, not an ADP statement). **Step 1:** Jay creates six test employees in the **live `4RZ`** company, using ADP's naming convention: **Employee, Emily01–Emily04** and **Manager, Marty01–Marty02**. *"All test employee status needs to be 'active' for payroll testing via API."* **Step 2:** TCG checks in live ADP that they are active and *"configured for CodingCops to test"*. **Step 3:** CodingCops runs the API testing *"in coordination with Corrina"*. *"Next payroll processing will most likely be on Tuesday next week but should be confirmed with Corrina and/or Micaela."* He also forwards to Jay *"questions in email below from CodingCops"*. Their text isn't in the relayed copy, so it is unconfirmed whether they are the technical questions in (d) below. **This replaces the 2026-09-28 meeting's plan** to use abdulrehman, syed.haris and Ehtesham as the test hires. **Effect on the 2026-09-30 open items:** (a) **timing: sharpened, not settled.** Brian proposes testing around next Tuesday's live payroll run. Jay's warning was that calculating a week calculates **every** worksheet in it, Corrina's included. So a test run tied to a live processing day needs either Corrina's worksheet held back until the test batch is deleted, or a *Correct Payroll* afterwards. Still to agree with Corrina and Jay. (b) **test-employee setup: still open.** The plan names the employees but gives no pay type, union status, craft code or position. "Configured for CodingCops to test" is undefined. The field flow needs at least a union hourly operator and oiler. What the two *Manager* employees are for (salaried? approval role?) is unstated. (c) credential scoping: still unasked. (d) the API questions: **possibly sent via Brian**, and no answer is recorded. Also open: **whether ADP can create these employees without SSNs.** Brian's email assumes ADP can. On 2026-09-28 Corrina said an SSN is required to hire (the meeting notes, §1.1), and Brian posted the SSA's never-issued test SSNs.
  - Follow-up, same thread (short *"Just FYI … if SSNs are needed for testing"* email; sender not shown in the relayed copy, presumably Brian; relayed by syed.haris 2026-10-01). It proposes SSNs that break SSA's reserved-number rules, so they can never belong to a real person: `000-12-3456` (area 000), `666-12-3456` (area 666), `900-12-3456`–`999-12-3456` (area 900–999), `123-00-4567` (group 00) and `123-45-0000` (serial 0000). *"SSA explicitly says numbers with those patterns are invalid/unassigned."* This bears on the SSN sub-question above. **Not yet known: whether ADP Workforce Now accepts them.** ADP may validate SSN structure at hire, and then the 000, 666, 00 and 0000 patterns would be rejected. The **9xx range is also the format of an IRS ITIN** (Individual Taxpayer Identification Number), so ADP might store such a number as an ITIN rather than reject it. Jay should say which pattern his team uses. No test SSN is recorded anywhere in the ERP.
- Update 2026-10-01 (Jay, ADP, reply to the team, undated, text relayed by syed.haris 2026-10-01): **API questions go to ADP's API team, not to Jay.** *"My role here is Payroll centric, so API's are outside my wheelhouse."* The API team works with CodingCops directly, and the route is a **ticket through ADP client support**: https://clientsupport.adp.com/hc/en-us/requests/new. **Jay will help with Workforce Now setup that the API needs**, which by implication covers the Emily/Marty test employees, though he doesn't name them. That help lasts only **until TCG moves to its full-time ADP Service Team**. After that, TCG's assigned **Payroll Support Specialist** and their team handle WFN setup. *"As Corrina is out of office, we have a week or so before that transition"*: roughly **until 2026-10-08**. **Effect on the open items:** (d) the **API questions are not with anyone who will answer them**. Brian's forward reached Jay, so they must be re-filed as a client-support ticket; owner: CodingCops. (b) and the SSN sub-question: whatever test-employee setup is needed (pay type, union, craft code, which SSN pattern) should be **settled with Jay inside that week**. After the handover it goes to a support specialist who has no context. (a) timing: **Corrina is out of office**, and Brian's Step 3 runs *"in coordination with Corrina"*. So a test around next Tuesday's payroll needs Micaela, or it waits for Corrina's return. Still unanswered: whether Jay will create the six test employees as Brian asked. The reply neither confirms nor refuses it.
- Update 2026-10-01 (syed.haris): **the API questions are filed with ADP API Central Support as request `672204`** (clientsupport.adp.com; category *API Consulting*). Subject: *"The Crane Guys (4RZ) – Payroll Data Input API: testing in live company, batch lifecycle and events"*. It asks ten questions: (1) whether an API-posted batch lands as its own worksheet, and whether it can be read back or deleted through the API; (2) whether a test batch is calculated along with the live worksheets; (3) credential scoping to a company code or to employees; (4) Batch ID rules; (5) whether `rate/rateValue` overrides the rate on file for one earning line, and which `rateCode` values are valid; (6) `workDate` support; (7) validation-table coverage and `autoGenerateMemoCode`; (8) an event when a batch is edited in WFN (question 7 in adp-integration-capabilities.md); (9) a payroll-results API (question 8 there); (10) whether an employee can be hired through the API without a valid SSN. **This moves item (d) from 'not sent' to 'filed, awaiting ADP'**. Credential scoping, item (c), was asked as question 3. ADP's auto-reply asks for the ADP-CorrelationID, client name, API, request timestamp, **client OrganizationOID** and payloads; these apply to failing calls, and there is none. Test-employee setup stays with Jay (see above), not with this ticket.
- Update 2026-10-07 (Nate, ADP API Central Support, reply to request `672204` addressed to Syed, undated, text relayed by syed.haris 2026-10-07). He cites the [Payroll Data Input API guide for WFN](https://developers.adp.com/guides/api-guides/payroll-data-input-api--guide-for-adp-workforce-now). **Answers, in ticket order:** (1) *"By default, it will post a new pay data batch/worksheet. If you use the 'append' method it will update an existing batch. **Currently batches cannot be read or deleted via API.**"* (2) *"Yes, any existing batches will be included. The only way to exclude it is to delete it."* (3) *"Yes. The API project user can be limited by company code and/or employees."* (4) *"Batch ID accepts alphanumeric characters. Uniqueness is not required as the system appends unique characters to it."* (5) *"Yes, rateValue (Temp Rate) overrides the rate for that entry. Rate codes missing from the meta response is a known gap. For now, you must refer to the UI for codes."* (6) *"There is no support for a 'workDate' field."* (7) *"Codes must be setup for the company codes to be used for them. See the meta requests in the guide for pulling values by company code."* (8) *"Event notifications are not supported at this time."* (9) *"The Payroll Output API can be used for getting details for preview complete for final payrolls"*, guide: [Payroll Output API](https://developers.adp.com/guides/api-guides/payroll-output-api-guide-turbo-api-for-midsized-to-enterprise-businesses). (10) *"See the Applicant Onboard API. A paid employee does require a valid SSN. The hire must be completed and active to include in a payroll"*, guide: [Applicant Onboard V2 for WFN](https://developers.adp.com/guides/api-guides/applicant-onboard-v2-api-guide-for-workforce-now). He also offers paid **project consulting** sessions. **Effect on the open items:** (a) **timing: harder, not easier.** A test batch can only be removed by a practitioner deleting it in the WFN UI, and any batch still present when the week is calculated is calculated with Corrina's. Every live write test therefore needs Corrina or Micaela to delete the batch by hand before the live calculation. The ERP also cannot confirm through the API that its batch landed or was deleted. (c) **credential scoping: answered, yes.** The API project user can be limited to company `4RZ` and to named employees, so it could be limited to the Emily/Marty test employees for the test. Whether to do that, and who sets it (TCG's ADP administrator or Jay), is a TCG decision not yet asked. (d) **the API questions: answered**, except that `autoGenerateMemoCode` (question 7, second half) got no direct answer. Batch ID (inference, not ADP's words): because ADP appends its own characters and nothing reads a batch back, the ERP never learns the batch's final ADP identifier, so it cannot be the ERP's correlation key. Question 10 confirms what *Employee master* already recorded about the mechanism (Applicant Onboard V2) and adds that a **paid** employee needs a valid SSN. Test employees are never paid (the batch is deleted before approval), so whether WFN accepts Brian's SSA-invalid SSNs at hire is **still Jay's question**. Settled elsewhere by this reply: `workDate` (no), pay-data edit events (none), the round trip (manual), and the output side (a WFN Payroll Output API exists; entitlement on TCG's project unchecked). See those entries.
- Update 2026-10-09 (Teams chat with Micaela Dipane, 2026-10-07 → 10-09, relayed by syed.haris 2026-10-15; full record [adp-api-test-2026-10-09.md](adp-api-test-2026-10-09.md)): **the first live write ran.** Micaela named **three live employees** (files `000288`, `000105`, `000459`) instead of the Emily/Marty hires Brian asked ADP for on 2026-10-01, so neither earlier test-employee plan was used. syed.haris posted batch `TCGAPITEST20261009` to `4RZ` with their week-41 figures at 7:29 PM PKT; it landed as its own worksheet in open period `2026-42` (10/03–10/09, pay date 2026-10-15), and Micaela replied *"Everything looks good!"*. **Effect on the open items:** (a) **timing: done once, by chat, no call.** (b) **test-employee setup: superseded** — real employees, so pay type and union setup were whatever they already have. (c) credential scoping: still not applied; the credentials could see all 461 `4RZ` workers. **The worksheet was deleted** by payroll in the WFN UI (syed.haris has no delete access, and the API cannot), confirmed by syed.haris 2026-10-15, so it never reached the 2026-10-15 pay date. Every future test needs the same manual delete.

## ERP↔ADP round trip — what happens when a practitioner edits the batch

- Question: if a payroll practitioner edits a pay-data batch inside ADP after the ERP pushed it,
  how does the ERP find out?
- Candidates: ADP's own Payroll Data Input guide says the opposite of what both TCG architecture
  drafts assume — *"To keep your data in sync with what's on the Paydata page in ADP Workforce Now,
  data must be adjusted in your data connector application."* i.e. **manual re-entry.** ADP does
  support webhooks for data-change events, but **no event for pay-data-batch edits was found** in
  the documentation.
- Note: the TPM architecture diagram (`payroll-architecture.html`) and the design-team prototype
  (`TCG Platform (4).html`) both show payroll results and check status returning from ADP. A
  *Payroll Output API* exists for **ADP Link**, a different product; **no Workforce Now equivalent
  was found.** Until confirmed, the "checks received / distributed" states are manual ERP states,
  not ADP data — which is a fine design, but the architecture should say so rather than imply an
  integration.
- Blocked: finalising either architecture document; any claim that the ERP is the system of record
  for what was *paid* (as opposed to what *should be* paid).
- Owner: whoever opens the ADP support ticket — question 7 in
  [adp-integration-capabilities.md](adp-integration-capabilities.md).
- **Status:** open
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#erpadp-round-trip-what-happens-when-a-practitioner-edits-the-batch](gaps-2026-08-20-retired.md#erpadp-round-trip-what-happens-when-a-practitioner-edits-the-batch)
- Update 2026-09-04 (Project Repository ingest): current practice is manual re-entry in both
  directions, and the client's own documents say so. (a) ADP SOP v3.8 §6.2
  ([adp-sop-v3.8.md](adp-sop-v3.8.md)) ends the weekly close-out with *"Import the CSV file and
  review information in ADP before submitting — Note any changes/modifications needed so we can
  update this Excel process"*: anything corrected on the ADP side is carried back to the workbook by
  hand, and §5.3.1 states the workbook is *"not directly connected to ADP"*. (b) The payroll
  playbook's exception path ([payroll-value-engines.md](payroll-value-engines.md) §2): a post-run
  dispute resolves as **Update Payroll Excel & in FCC → Process Retro Check through ADP → Email
  Accounting Check Info** (SOP #8–#9) — ADP-side changes are keyed into ADP and the source systems
  are updated separately by the same person. (c) FCC's vendor manual
  ([fcc-nexgen-payroll-processing.md](fcc-nexgen-payroll-processing.md) §2): after Export *"a labor
  entry cannot be modified in any way"* except through a management-only post-export procedure, so
  the incumbent has no inbound path either. Legacy-system and process facts — evidence of what TCG
  lives with, not a TCG decision on the ERP. Whether `pay-data-input.modify` fires on a practitioner
  edit (the test described under *Where do webhook events live*) is still the only thing that
  answers the question as asked.
- Update 2026-10-07 (ADP API Central Support, request `672204`; full text under *ADP product, API
  Central entitlement and sandbox*): **answered — the ERP does not find out.** *"Event notifications
  are not supported at this time"*, and *"batches cannot be read or deleted via API"*. ADP's documented
  position stands: the sync is one-way and a practitioner's edit must be re-entered by hand in the
  source system. **The output side has changed, though:** ADP points to a **Payroll Output API** for
  Workforce Now (*"details for preview complete for final payrolls"*), which contradicts the Note
  above that only ADP Link has one. So the ERP may be able to read *what was paid* after the fact,
  even though it is never told about an edit. Not yet checked: whether that API is entitled on the
  *TCG ERP Integration* project, and what its responses contain. Owner: CodingCops.
- Update 2026-10-17 ([adp-api-test-2026-10-09.md](adp-api-test-2026-10-09.md) §7): **checked — not entitled, and no event either.** The edit test
  confirmed no event fires when payroll edits a posted worksheet. `GET /payroll/v2/payroll-output`,
  `/payroll/v1/payroll-output` and `/payroll/v1/workers/{aoid}/pay-statements` all return **403
  `Invalid Scope`**, and *Discover APIs* lists no payroll-output or pay-statement API in any domain —
  the 2026-08-18 *Marketplace-partner-only* reading holds. syed.haris asked ADP (request `672204`,
  2026-10-17) whether it can be enabled or what else shows a worksheet's status, and forwarded the
  thread to Brian Petros. **Until ADP answers, the question as asked has no technical answer: the
  ERP does not find out.** What remains is a **process decision for Brian Petros / Corrina Bustos,
  not yet asked or made**: (a) corrections happen only in the ERP and are re-sent (`Append` updates
  an existing batch, request `672204` point 1), or (b) payroll marks the week approved and records
  any ADP-side change in the ERP after approving. Owner: syed.haris to put (a)/(b) to the client.
- Update 2026-10-22 (Nate, ADP, request `672204`; [adp-api-test-2026-10-09.md](adp-api-test-2026-10-09.md) §9):
  **Payroll Output and Pay Statements can be enabled — by ADP support only, never in API Central** —
  once the ticket has a clear "Yes", **a TCG security master on it (Corrina Bustos or Melissa
  McNutt)**, and the project name (*TCG ERP Integration*). Both return all payroll data unfiltered,
  executive pay included. That would give the ERP the read side (what was calculated/paid) and so a
  way to detect ADP-side edits by comparison. **TCG's decision; not yet asked.**

## Excel or API — the ADP submission path is not decided

- Question: does TCG submit payroll to ADP by **spreadsheet import** (today's process) or by the
  **Pay Data Input API**?
- Candidates: [payroll/adp-sop-v3.8.md](adp-sop-v3.8.md) documents the Excel/Power
  Query/VBA process the ERP is meant to replace.
  [payroll/adp-integration-capabilities.md](adp-integration-capabilities.md) documents the
  API.
- **Interim path stated (client, 2026-08-24 exchange):** while deciding, TCG is setting up
  **manual CSV upload through the ADP browser UI** — the bridge process, not the decision.
- Note: **these are alternatives, not stages.** A spreadsheet imported through the ADP UI produces
  no machine-readable response at all — the only feedback is what the practitioner sees on their
  own screen. Every ERP screen that displays an ADP response, confirmation ID or API status
  presupposes the API path. The design prototype (`TCG Platform (4).html`) shows exactly such
  screens, including a raw-JSON ADP reply, while the 5 Aug minutes still describe a
  *"Payroll for ADP Excel file"* with a new column for the Foreman premium — **the two are
  describing different integrations.**
- Blocked: the ADP Payroll Files screen; any estimate of the ADP work; the Foreman premium's
  delivery mechanism (special Excel column vs earning code).
- Owner: TCG payroll + CodingCops, jointly. Needs an explicit decision.
- **Status:** open
- Observed 2026-08-18 (ADP Workforce Now screenshots, company 4RZ, weekly #31, 07/18–07/24):
  the batches ROLL (Field Roll, 85 people) and SALARY (29) are marked **Manual Entry**; PTO001
  is Paid Time Off. ROLL columns: Reg / OT / DT / Holiday 2x / Holiday 3x hours, Shift Diff 2/3
  code+amount, **Temporary Rate + LB REG/OT/DBL/TRI** (one row per boom adder), SUB PAY, Sick,
  PTO. The legacy app produces no file — the sheet is keyed/imported outside it. Layout recorded in
  [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#excel-or-api-the-adp-submission-path-is-not-decided](gaps-2026-08-20-retired.md#excel-or-api-the-adp-submission-path-is-not-decided)
- Update 2026-09-04 (Project Repository ingest): three client-authored sources, none of which
  decides it. (a) TCG's own RFP of 2026-02-26
  ([../admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md) → *Required
  integrations*) lists **"ADP / Paychex — Payroll export from approved labor records — High"**: the
  client framed the requirement as an *export*, vendor-agnostic, with nothing about an API or an
  inbound response. (b) The Excel path is now specified as a file contract:
  [adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §2, §4 and §6 give the
  `EPI4RZnn` file name (the counter restarts every payroll year, so names repeat), the `Payroll
  YrMoWk` batch id, one primary row plus one temp-rate row per code-and-rate, the fixed Hours-4 slot
  map and the fifteen validation checks the exporter refuses on;
  [adp-workbook-vba-macros.md](adp-workbook-vba-macros.md) §2 is the exporter itself. If the interim
  CSV path is kept, this is what the ERP must reproduce. (c) ADP SOP v3.8 §6.2 confirms the CSV is
  imported through the ADP Payroll Dashboard and reviewed on screen before submission — no
  machine-readable response, as this entry already notes. Still needs the client: the explicit
  Excel-vs-API decision — the RFP's *export* wording is not it.
- Update 2026-09-08 (ADP workbook v5.1, [adp-workbook-v5.1-engine.md](adp-workbook-v5.1-engine.md)):
  the Excel path is **in production and evolving** — three weeks on v5, the file contract now has three
  row types (`PRIMARY`, `BASE_RATE_OVERRIDE`, `TEMP_RATE`), 28 Hours-4 slots including `FRR–FRT` and
  `MLR–MLT`, `Temp Rate` emitted on override rows, 22 validation codes and an explicit sort. The
  workbook also *reads* the legacy app's calculated recommendations but sends the typed rows. And the
  client says the CSV is **not the whole payroll**: Corrina edits and adds in ADP after import
  (below, *Post-import ADP entry*) and keys salary separately. Still undecided by anyone.
- Update 2026-10-09 ([adp-api-test-2026-10-09.md](adp-api-test-2026-10-09.md)): **the API path works end to end for the boom/OT shape.** One `POST pay-data-input.modify` built from `EPI4RZ41.csv` rows (`R`/`O`/`DT` hours, `LBH`/`LBO`/`LBD` with temp rates) created a worksheet the payroll department accepted as correct. Evidence that the API is viable, not a decision between the two paths. Micaela Dipane also described the step both paths share before submission: *Validation Pending* → check the worksheet against the *ADP_Preview Batch Totals* → *Auto Balance*, *Save*, *Done* → *In Balance*.

## Employee master — who creates a worker, ERP or ADP

- Question: if an employee is created in the ERP, should it create the worker in ADP?
- Candidates: [payroll/adp-integration-capabilities.md](adp-integration-capabilities.md).
- Note: **ADP mints worker identity** — `associateOID`, `workerID`, `positionID` and the File
  Number are all ADP-generated, and the pay-data API validates `payrollFileNumber` against ADP's
  own master. The ERP cannot invent them. Inbound (ADP → ERP) is well supported via `GET workers`
  plus the `Worker Hire` event webhook. Outbound is narrower: the **Worker Hire Event API is being
  deprecated** in favour of Applicant Onboard V2, and its documented limitations include that
  **a new hire record is sometimes created even when the call returns an error** — a duplicate-
  worker hazard in the payroll system of record.
- Suggested position, not yet a decision: **ADP masters worker identity; the ERP masters
  operational employee data** (craft, yard, certifications, crew). No requirement in the vault has
  asked for ERP-originated hiring.
- Blocked: employee module ↔ payroll integration design.
- Owner: TCG (payroll + HR), with CodingCops.
- **Status:** resolved 2026-09-04 — answered from the record, no client question needed. **Yes — the ERP
  initiates the worker in ADP through the integration; ADP mints the identity and completes
  onboarding; the ERP stores the file number it gets back and never generates one.**
- Resolution (a):
  [../decisions/2026-06-30-adp-erp-employee-data-ownership.md](../decisions/2026-06-30-adp-erp-employee-data-ownership.md)
  (`status: verified` — Brian Petros proposed, Ehtesham Anwar refined, Brian agreed 2026-06-30,
  nobody dissented on the thread) → *Where the lifecycle starts*: *"1. The ERP creates the
  operational employee record (a pending / pre-hire). 2. The ERP initiates employee creation in ADP
  through the integration. 3. ADP completes the HR and payroll onboarding… 4. The ERP automatically
  captures the ADP Employee ID / file number that comes back."* — and under *Why this matters*: *"It
  settles that our onboarding integration is a push from the ERP, not a manual ADP entry that the
  ERP watches."* A client decision, on the record since 06-30; this entry was written before the
  note was captured and never linked to it. The *suggested position* above (ADP masters identity,
  ERP masters operational data) is the decision's ownership table verbatim.
- Resolution (b): the ingest corroborates the manual practice the decision replaces, as system facts
  only. HR's ADP-setup playbook (Corrina Bustos, 2026-05-11 —
  [hr-onboarding-and-employee-forms.md](hr-onboarding-and-employee-forms.md) §2): the employee is
  *born in ADP* via **Process → HR Dashboard → Hire Someone** from six fields, then the new hire
  completes ADP's own link. ADP SOP v3.8 §5.3.1: *"FCC does not have employees' ADP IDs"* — the
  FCC↔ADP file-number mapping lives in an Excel sheet (`tblCfgEmpInfoDetails`,
  [adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §1).
- Resolution (c): what stays open is tracked elsewhere and does not reopen *who creates*: the API
  mechanism (`applicant.onboard` V2 vs the deprecated `worker.hire`, the duplicate-on-error hazard)
  and the onboarding-complete signal — the decision note's own open-questions table and the *Fill-in
  field employees* entry below.
- Sources checked: decisions/2026-06-30 note in full;
  [adp-integration-capabilities.md](adp-integration-capabilities.md);
  [adp-read-write-boundary-2026-08-18.md](adp-read-write-boundary-2026-08-18.md);
  hr-onboarding-and-employee-forms §2–§3; adp-sop-v3.8 §5.3.1; adp-workbook-power-query-engine §1;
  fcc-employee-master-reference-data §7 (FCC import template).
- Owner: answered; no client action outstanding. Owed:
  [PAY-003](rules/PAY-003-employee-master-import.md) should cite the decision.
- **Rules:** [PAY-003](rules/PAY-003-employee-master-import.md), [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#employee-master-who-creates-a-worker-erp-or-adp](gaps-2026-08-20-retired.md#employee-master-who-creates-a-worker-erp-or-adp)

## Earning-code setup in ADP — a manual prerequisite nobody owns

- Question: who creates TCG's earning codes inside ADP Workforce Now, and when?
- Candidates: [payroll/adp-integration-capabilities.md](adp-integration-capabilities.md).
- **2026-08-24, from the client-message batch:** Brian (June-era) — the new import workbook
  needs "a few more fields in ADP"; a **meeting with the ADP rep** was planned to confirm.
  Owner emerging: **Brian + the ADP rep**. **Largely closed 2026-08-24:** the additions are enumerated (S2/S3 diff, LBT, lattice
  op/oiler) and confirmed present in the 8-18 pull. Residual: the *removed* code's identity,
  the *changed* holiday code's identity, and the backend-calc opacity (ADP-support ask).
  Reconcile against the **52 live codes** captured
  2026-08-18 (`adp-api-responses/pay-data-input-meta.md`) to enumerate what is still missing —
  and ask what the rep meeting concluded.
- Note: **ADP supplies no unified or standard code set.** It reserves only `R` (Regular) and `O`
  (Overtime), plus Memo Code `5` / Earnings Code `T` as structural requirements. Every other code
  — `FRR`/`FRO`/`FRD`/`FRT`, `LPR`, `LOO`, the shift differentials — is **client-defined and
  created by TCG** at `Setup > Tools > Validation Tables > Payroll > Paydata > Hours & Earnings
  Codes`. There is no Davis-Bacon or government standard code list.
- **This is a hard sequencing dependency.** The API rejects any code not already in the validation
  table (`codedHoursEarning: VV is invalid`). Code creation is a manual practitioner task that must
  complete *before* the first API call carrying that code — including for premiums that do not yet
  exist in ADP, such as the four new Foreman codes and whatever the Military premium uses.
- Blocked: first successful API submission; the Foreman and Military premium rollout.
- Owner: TCG payroll practitioner (has `Setup` access). Needs a named person and a checklist.
- **Status:** open
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#earning-code-setup-in-adp-a-manual-prerequisite-nobody-owns](gaps-2026-08-20-retired.md#earning-code-setup-in-adp-a-manual-prerequisite-nobody-owns)
- Update 2026-09-04 (Project Repository ingest): the workbook's Power Query
  ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §4–§6) is the first
  complete statement of **which client-defined codes the live import already depends on** — and
  since the CSV imports today, each must already exist in TCG's validation table: Hours-3 `DT · HDD
  · HOL · SIC` (slots 01–04), Earnings-3 `SUB` (slot 01), and twenty Hours-4 codes in fixed slots
  `LBH LBO LBD LBT · LPR LPO LPD LPT · LOR LOO LOD LOT · S2R S2O S2D S2T · S3R S3O S3D S3T` (boom,
  lattice operator/oiler, 2nd/3rd shift, each at ×1 / ×1.5 / ×2 / ×3); a code in the wrong slot is
  an export `ERROR`. Two consequences: (a) the residual *removed / changed holiday code* question
  now has concrete candidates to reconcile against the 08-18 pull — `HDD` and `HOL` are the holiday
  pair the sheet sends; (b) **no WTL, foreman or military code exists anywhere in the export path**
  (§*What the code reveals*, item 1) — those premiums are folded into ST/OT/DT hours before the
  ledger sees them, so the four Foreman codes and whatever Military uses are still uncreated,
  exactly as this entry says. System facts (workbook code), not a decision. Still needs the client:
  a named owner and date for creating the new codes — no ingested document names one, and SOP §6.2
  simply assumes the codes exist.
- Update 2026-10-08 (four imported files, `EPI4RZ38`–`41`, from Micaela Dipane; read, not stored):
  **Foreman and Military codes do reach ADP today.** Week 38 imports `FRR · FRO · FRD` and week 41
  `MLR · MLO · MLD`, each on a Temp-Rate row (foreman `3 · 4.5 · 6`, military `10 · 15 · 20`), so
  those six codes exist in the validation table; item (b) above is out of date for them. Also from
  the files, against the workbook description: **columns are not in fixed slots.** Each file carries
  only the Hours-4 pairs that week uses, in first-use order (16, 24 and 36 columns), as Corrina said
  on 2026-09-28 (47:17); `SIC` sits in a trailing Hours-3 pair after `SUB`. No `LBT`, 2nd/3rd shift,
  `HDD` or `HOL` appears in these weeks. **Temp rates carry three decimals** (`1.875`, `10.125`,
  `16.875` — the ×1.5 of a quarter-dollar adder); the pay-data API's money fields allow two
  ([adp-api-responses/pay-data-input-meta.md](adp-api-responses/pay-data-input-meta.md)), and
  whether `rate/rateValue` is one of them is untested — first API test is 2026-10-09.
- Update 2026-10-09 (first live POST, [adp-api-test-2026-10-09.md](adp-api-test-2026-10-09.md) §3): **`rate/rateValue` accepts three decimals.** `4.875`, `7.875` and `10.125` were sent on `LBO`/`LBD` lines, accepted, and echoed unchanged; Micaela Dipane found nothing off on the worksheet. Foreman (`FR*`) and military (`ML*`) lines were not in the three employees' rows, so their codes were not exercised through the API.

## Certified payroll generation — is there already an ADP Marketplace connector?

- **ANSWERED 2026-08-13: no, TCG has no certified-payroll connector.** The Marketplace `My Apps`
  screen lists exactly two entitled apps — API Central Launchpad and API Central Help Center.
  No Points North, no allGeo, nothing in that category. **WH-347 generation is genuinely unbuilt**,
  the Labor Compliance module is greenfield, and the TPM architecture's separate SMG Compliance box
  duplicates nothing already licensed.
- Remaining question: does TCG intend to **buy** such a connector, or build it? The Marketplace
  option exists and is the conventional route.
- Candidates: nothing in the vault. The
  [7 Aug minutes](../meetings/2026-08-07-labor-compliance-certified-payroll.md) name **SMG Compliance**
  and **LCP Tracker** as the external systems, and the TPM architecture draft shows SMG generating
  WH-347s.
- Note: **certified payroll is not native to Workforce Now.** WH-347 generation is served by
  Marketplace partners — Points North Certified Payroll Reporting, allGeo Construction Connector —
  which read hours-by-day, rates and paycheck data out of WFN. So a third system doing this is the
  normal shape, and the TPM's SMG box is architecturally sound. But **if TCG already licenses such
  a connector, part of the Labor Compliance scope may already be bought and paid for.**
- Note also: prevailing-wage work needs **job attribution**, not just pay buckets — ADP's
  Temporary Cost Number / Temporary Department Number / Allocations (`…/payInputs/payAllocation`).
  Nothing in the ERP payroll design currently carries job attribution into the ADP payload.
- Blocked: Labor Compliance scoping; the ADP payload design for Davis-Bacon jobs.
- Owner: TCG (ADP account administrator + Corrina for compliance).
- **Status:** open
- **Rules:** [PAY-072](rules/PAY-072-certified-payroll-davis-bacon-reporting.md), [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#certified-payroll-generation-is-there-already-an-adp-marketplace-connector](gaps-2026-08-20-retired.md#certified-payroll-generation-is-there-already-an-adp-marketplace-connector)
- Update 2026-09-04 (Project Repository ingest): no connector anywhere in the client's own record,
  and the manual process is now documented end to end. (a) TCG's RFP of 2026-02-26
  ([../admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md) → *Required
  integrations*) lists QuickBooks Online, Samsara, Microsoft 365, ADP/Paychex export and FCC
  migration — no certified-payroll product, no LCP Tracker, no SMG. (b) The certified-payroll value
  engine of 2025-09-12 ([payroll-value-engines.md](payroll-value-engines.md) §3) runs **Run
  Certified Payroll Report (SOP #3) → Report Weekly Labor & Internal Tracker (#4) → Generate CPR
  Report & Request Check Stubs (#5)** against a **CPR Tracker** — check stubs are *requested*, i.e.
  pay evidence comes out of ADP by hand, which is what a Marketplace connector would automate. The
  playbook's native `.docx` (Ryan, 2026-08-06), its Davis-Bacon companion and the Pre-Job Labor
  Compliance form ([certified-payroll-playbook.md](certified-payroll-playbook.md) §10–§12) cover
  intake only. (c) The June-2026 org chart
  ([../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md)
  → *The org charts*) has **Certified Payroll (Rose Aguilera)** as a named box under HR — a business
  owner for the buy-or-build call. (d) FCC carries `CertPay` on the employee
  (`stg.FMS_EMPLOYEES_Raw`) and on every labor row (`stg.FMS_LABOR_PAYROLL_Raw`), so job-level
  prevailing-wage attribution exists in the incumbent data. Process and system facts; **buy vs build
  is still TCG's call**, and nothing ingested makes it.

## API Central access for the people actually building it

- Question: who at CodingCops can reach an ADP credential, certificate or project?
- **Answer today: the project manager, and nobody else.** The API Central tenant
  (`THE CRANE GUYS LLC`) has three members as of 2026-08-13 — Corrina Bustos (TCG),
  Melissa Mcnutt (TCG) and **Ehtesham Anwar (CodingCops, project manager)** — each holding all
  three roles (Project / Certificate / Member).
- **The cross-organisation route is already proven**, not just documented: Ehtesham is external to
  TCG and is in the tenant with full roles. All three IDs share the `@blsr1` realm, so external
  members are issued an ADP identity inside TCG's tenant.
- **The remaining gap is that no implementing developer has access** — and CodingCops can close it
  without asking TCG. Ehtesham's **M (Member user)** role is defined as *"manage access and roles
  for internal and external users"*. No procurement step, no licensing question, no approval cycle.
- **Blocked until resolved: all hands-on ADP work.** No credential means no token, no certificate,
  no sandbox, no Postman run, no first API call.
- Owner: Ehtesham Anwar (CodingCops) — has the role to do it directly.
- **Status:** open — and the cheapest item on this entire list to close.
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#api-central-access-for-the-people-actually-building-it](gaps-2026-08-20-retired.md#api-central-access-for-the-people-actually-building-it)
- **2026-08-24, client big-summary message:** Brian has been granted access to the **production**
  account ("the actual account… I don't think the dev account for ADP has been created yet");
  Wes is checking with Melissa and Corrina to get CodingCops access. Consistent with the open
  test-company request of 2026-08-17. Dev/sandbox creation is the blocking half.

## Where do webhook events live in API Central, and what fires?

- Question: does API Central expose an event that fires when a pay-data batch is edited by a
  practitioner?
- Note: **`Events` is not a top-level item**, and **Integration Services is now ruled out** — that
  page is marketing only, listing three consultancies (Flexspring, DataBlend, Aquera). Events are
  therefore per-project, matching ADP's webhook guide (`Projects > Select a Project > APIs >
  Events > Add Events`). **The catalogue cannot be read until a project exists**, and as of
  2026-08-13 there are zero projects.
- **This is the question that decides the ERP↔ADP round trip.** If no event fires on pay-data
  changes, ADP's documented position stands — the sync is one-way and reconciliation is manual —
  and both architecture drafts need their inbound arrows relabelled. The event catalogue inside a
  project answers it definitively, without needing an ADP support ticket.
- **Progressed 2026-08-13. The queue exists and is reachable — it is simply empty.**
  `GET /core/v1/event-notification-messages` returns **`204 No Content`**, *not* `403`. So the
  polling mechanism is entitled to this project and functioning; there is nothing in it.
- **What that does and does not mean.** It rules out "the endpoint is not licensed" (compare
  `eligibility-classes`, which returns `403 API_AccessDeniedFeature`). It does **not** show that
  anything will ever arrive. Two reasons the queue could be legitimately empty:
  1. **Nothing is subscribed.** The Credentials page offered *"Configure your event delivery
     method (optional)"* as step 4, and it was never completed. Events may require explicit
     subscription per project before they are produced.
  2. **Pay data does not emit events at all.** The Payroll Data Input guide's own Known Issues
     states *"Event notification is not supported"* for that API.
- **Catalogue opened 2026-08-13 — it exists, and it is large.** `APIs > Events` shows
  **Events (0) subscribed** against **147 events available** to subscribe, across 10 domains and
  249 sub-categories. Full detail in
  [payroll/adp-event-notifications.md](adp-event-notifications.md).
- **The `204` is now fully explained**: the queue is entitled and functioning, and nothing is
  subscribed. It was never going to contain anything.
- **A pay-data event EXISTS, found 2026-08-13.** Filtering API Domain → Payroll returns **12
  events**, one of which is **`pay-data-input.modify`** ("Pay Data Input Modify"). The other
  eleven are tax-instruction and direct-deposit events, outside ERP scope.
- **This appears to contradict the Payroll Data Input guide's Known Issue** — *"Event notification
  is not supported"* — which is either stale or narrower than it reads.
- **But the semantics are unverified, and they decide everything.** The event name is
  character-for-character the API operation name, which allows two readings:
  - **Echo** — fires only when the API is called, i.e. on the ERP's own submission. Low value,
    though it might carry the identifier the `200 OK` withholds.
  - **Change notification** — fires whenever the batch changes, *including a practitioner editing
    the Paydata page*. **This closes the loop.**
- **The test, and it needs no `POST` to production:** subscribe to the event, ask a TCG
  practitioner to make a trivial edit on the Paydata page during their normal work, then poll
  `GET /core/v1/event-notification-messages`. A message means change notification; another `204`
  means echo-only. Acknowledge with `DELETE .../{adp-msg-msgid}` afterwards.
- **Schema read 2026-08-13, and it tilts strongly toward change notification.** The event carries
  `originator`, `actor`, `actAsParty` and `onBehalfOfParty` — with `formattedName`, `deviceID`,
  `deviceUserAgentID`, `geoCoordinate`, and an explicit description of *"An ADP Support User …
  views data within an ADP Application as a client employee … and can take action on that person's
  behalf."* **Those fields describe a human in a screen, not an HTTP call.** Inference, not proof —
  the schema is ADP's canonical model and WFN may implement only part of it.
- **If it fires, the ERP gets an audit trail, not just a receipt:** `eventID` (*"set by the system
  of record once an event is recorded"* — the correlation handle the `200 OK` withholds),
  `actor.formattedName` (**which practitioner changed the batch**), `eventStatusCode`,
  `recordDateTime` vs `effectiveDateTime`, `eventReasonCode`.
- **What is absent either way: there is no "payroll processed" or "pay statement available"
  event.** None of the twelve announce that payroll ran or that anyone was paid. Events could make
  the *input* side of the loop trustworthy; they do not open the *output* side. The formulation
  stands — **ERP is the system of record for what should be paid; ADP for what was paid, and it
  will not tell you.**
- **New lead: `payrollProcessingJob.initiate`.** The schema describes `payrollProcessingJobID` as
  *"generated as the result of the `payrollProcessingJob.initiate` event"* — conceptually *"a
  payroll run was started"*, the closest thing yet to output-side visibility. It is **not** among
  the 12 Payroll-domain events, so probably not available to WFN clients, but the catalogue has ten
  domains. Worth one search.
- Update 2026-10-07 (ADP API Central Support, request `672204`): asked directly whether an event
  fires when a practitioner edits a submitted pay-data batch, ADP answered *"Event notifications are
  not supported at this time."* That backs the Payroll Data Input guide's Known Issue over the
  catalogue's `pay-data-input.modify` entry. Treat the event as unavailable; the subscribe-and-edit
  test above would only show whether ADP's answer is out of date. **Output side:** ADP points to a
  WFN **Payroll Output API**. See the round-trip entry above.
- Update 2026-10-15 (syed.haris, Teams message to Micaela Dipane): **the subscribe-and-edit test is
  requested for 2026-10-16 8am PT**, on the same three live employees as the first POST. Micaela to
  edit then delete a test worksheet; payroll to give a heads-up before approving the real weekly
  payroll so the queue can be watched for an approval notice. Delivery by polling (the active
  method). Expected empty, per ADP. Plan and message:
  [adp-api-test-2026-10-09.md](adp-api-test-2026-10-09.md) §6. Still open until it runs.
  Micaela Dipane agreed the same day: edit/delete on **2026-10-16 morning**; the approval check
  moves to the next payroll, *"uploaded and approved on Tuesday"* (**2026-10-20**), and she will
  message once it is approved in ADP. syed.haris confirmed the upload for about the same time as
  the first test (~7:30 AM PT / 7:30 PM PKT, 2026-10-16).
- Update 2026-10-17 (the test ran, [adp-api-test-2026-10-09.md](adp-api-test-2026-10-09.md) §7): **answered — no event fires on an edit.** With
  `pay-data-input.modify` subscribed and polling active, batch `TCGAPITEST20261016` was posted and
  Micaela Dipane edited and **saved** two lines (`000459` R 23.5 → 21.5, `000288` R 40 → 30); the queue
  returned **204** on every poll for ~35 minutes after. ADP's Known Issue and request `672204` point 8
  stand; the catalogue's `pay-data-input.modify` entry is never delivered for Workforce Now. The new
  lead above is also closed: **no event path in the 147 contains `payroll`** (all 10 domains searched),
  so there is no payroll-run, payroll-job-status or approval event on this project. The 2026-10-20
  approval poll is a formality. **The delete was silent too:** Micaela Dipane deleted the worksheet
  and the queue stayed 204 (polled 02:20 and 02:27 PKT). ADP has no *reject* for a worksheet — an
  edit or a delete is what rejecting means — so a rejected entry is invisible to the ERP as well.
- Update 2026-10-21 (approval check, [adp-api-test-2026-10-09.md](adp-api-test-2026-10-09.md) §8):
  week 43 was **processed** (ADP's app told Micaela Dipane at 4:15 PM PT, 2026-10-20) and the queue
  stayed **204**. A documented event, `payrollGroup.payPeriodStatus.change`, exists in ADP's NextGen
  pay-periods guide but is **not** among this project's 147; enablement asked of ADP (request
  `672204`, 2026-10-21). Interim lead: poll `GET /payroll/v1/pay-schedule/payroll-groups/4RZ` for
  `OPEN` → `COMPLETE` (timing of the flip unconfirmed). ADP has not answered the 2026-10-17 follow-up.
- Update 2026-10-22 (Nate, ADP, request `672204`; [adp-api-test-2026-10-09.md](adp-api-test-2026-10-09.md) §9):
  **`payPeriodStatus.change` added to the *TCG ERP Integration* project** (polling). Not yet
  observed firing: at the first poll (2026-10-23 PKT) `2026-43` was still `OPEN` on its pay date,
  so whether it signals *processed* or *next week opened* is open.
- **Status:** resolved 2026-10-17 — no pay-data event reaches the ERP; a pay-period status event is
  now subscribed (2026-10-22), timing unconfirmed.
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#where-do-webhook-events-live-in-api-central-and-what-fires](gaps-2026-08-20-retired.md#where-do-webhook-events-live-in-api-central-and-what-fires)

## Does WFN support `workDate` and the FLSA date fields on pay data?

- Question: does the Workforce Now implementation of `pay-data-input.modify` accept **`workDate`**
  and **`earnedPayPeriodStartDate` / `earnedPayPeriodEndDate`**?
- Candidates: the event's JSON Schema defines them —
  `workDate` = *"the date on which the worker clocked overtime"*,
  `earnedPayPeriodStartDate/EndDate` = *"used for FLSA in CA in the US"*. **But the WFN
  `pay-data-input.modify/meta` response does not expose either**
  ([payroll/adp-api-responses/pay-data-input-meta.md](adp-api-responses/pay-data-input-meta.md)).
  The schema is ADP's generic cross-product model; `/meta` is what WFN actually accepts.
- **Why it matters:** TCG's California daily overtime, seventh-consecutive-day and FLSA rules are
  all **date-attributed**. If WFN accepted `workDate`, the ERP could send per-day attribution
  rather than weekly totals — which would make ADP's own record of the week auditable against the
  ERP's day-level ledger. Without it, ADP receives aggregates and the day-level reasoning exists
  only in the ERP.
- Other generic-schema fields absent from WFN's `/meta`, same caveat: `modifierCode`,
  `earnedPayPeriodWeekNumber`, `workWeekDatePeriod`, **`additionalPayAllocations[]`** (an *array*
  of allocations versus WFN's single `payAllocation`), `payTypeCode`, per-payee
  `payPeriodStartDate`/`EndDate`, and `memoInputs` nested inside `earningInputs`.
- Note: `_modificationTypeCode` is documented in the schema as `add` / `change` / `remove`, while
  ADP's WFN examples use `Add` and `Append`. **Trust `/meta` over the generic schema.**
- Blocked: nothing today — the design works on weekly aggregates. This is an improvement
  opportunity, and a question worth asking before the ADP export rule is finalised.
- Owner: CodingCops to ask ADP.
- **Status:** resolved 2026-10-07 — **no.** ADP API Central Support, request `672204`: *"There is no
  support for a 'workDate' field."* That matches `/meta`. ADP receives weekly aggregates; the
  day-level reasoning lives only in the ERP. The FLSA period fields
  (`earnedPayPeriodStartDate/EndDate`) were not asked. `/meta` does not list them either, so treat
  them as unsupported too.
- **From (frozen original):** [gaps-2026-08-20-retired.md#does-wfn-support-workdate-and-the-flsa-date-fields-on-pay-data](gaps-2026-08-20-retired.md#does-wfn-support-workdate-and-the-flsa-date-fields-on-pay-data)

## Polling or webhooks — a per-project architectural choice, not a preference

- Question: does the ERP receive ADP events by **polling a queue** or by **exposing a webhook
  endpoint**?
- **They are mutually exclusive.** ADP: *"There can only be one event delivery method selected per
  project. If webhooks is activated, polling will be immediately disabled."* Using both requires
  going through an ADP Marketplace Technical Advisor.
- Current state: **Polling active, Webhook inactive.**
- **The choice has real consequences the architecture drafts do not account for:**
  - **Webhook** requires the ERP to expose a public HTTPS endpoint ADP can reach, with OAuth 2.0 /
    API Key / Basic auth **and mandatory signature verification**. That is a deployment and
    security workstream.
  - **Polling** requires a scheduled job plus a `DELETE` acknowledgement loop.
  - **The payloads differ.** ADP: *"An event body sent through webhooks differs slightly from that
    which is received through polling. There are additional items in a meta structure."* Switching
    later means rewriting the parser — this is not a late-binding decision.
- Blocked: the ERP's integration deployment shape.
- Owner: CodingCops, with TCG security sign-off if webhooks are chosen.
- **Status:** open — polling is the current default and the lower-risk one
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#polling-or-webhooks-a-per-project-architectural-choice-not-a-preference](gaps-2026-08-20-retired.md#polling-or-webhooks-a-per-project-architectural-choice-not-a-preference)

## One ADP certificate covers development *and* production

- Question: how are development and production separated on the ADP integration, and where does
  the private key live?
- **Constraint, stated by ADP itself** on the API Central Certificate page: *"A certificate created
  here will be used across all projects you create in **both development and production**."*
  There is no separate dev certificate.
- **Consequence: a developer cannot be issued a dev-only credential at the certificate layer.**
  Anyone holding the certificate plus client credentials can reach production payroll. Environment
  separation, if it exists at all, must come from the *project* — which makes "does a sandbox /
  test company exist?" a question to answer while creating the first project, not after.
- Note: two issuance routes are offered — request one from **ADP's CA**, or **upload an existing
  signed certificate** (CSR flow). The second keeps the private key inside TCG/CodingCops
  infrastructure and is the stronger posture. Choosing between them is a decision, not a default.
- Note also: the private key is a **production payroll credential from the moment it is issued** —
  it needs a secret manager and a rotation plan before the request is made, not after. ADP offers
  expiry tracking on the same page.
- **Certificate ISSUED 2026-08-13** via ADP's `Request certificate` wizard, which generates the
  keypair in-browser, displays the private key once for copy/paste, and returns a signed `.pem`.
  Artifacts held: private key, CSR, signed `.pem`. DN values used: `THE CRANE GUYS LLC` / `IT` /
  `United States` / `California` / `Los Alamitos`.
- **Still open, and now urgent because the key exists:**
  1. **Key custody** — which secret manager holds it, and who can read it. It is a production
     payroll credential with no dev-only equivalent.
  2. **Expiry date and rotation owner** — not yet recorded. A lapsed certificate stops payroll
     submission outright. ADP offers expiry tracking on the Certificate page.
  3. **Environment separation** — unchanged by issuance. One certificate still covers all projects
     in both development and production, so a developer cannot be given a scoped-down credential.
- Blocked: developer onboarding that assumes a safe sandbox credential; any deployment that needs
  the key present.
- Owner: CodingCops (Ehtesham holds the **C** role) with TCG security sign-off on key custody.
- **Status:** open — issuance done, **custody and rotation undecided**.
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#one-adp-certificate-covers-development-and-production](gaps-2026-08-20-retired.md#one-adp-certificate-covers-development-and-production)

## Confluence payroll user stories — first payroll pages in Confluence, unmigrated

- Question: do the two new Confluence pages `Payroll management` (page id 150110210,
  `PAY-WP-01`…`04`) and `Craft codes` (page id 151388161, `PAY-CC-01`…`02`) — both by Umair
  Khan, both edited the evening of 2026-08-18, found by the 2026-08-19 drift check — supersede,
  restate or contradict the payroll documents in this folder?
- Candidates: **not migrated.** Under 24 hours old at the check, so held per the sync rule
  (`README.md` → *Re-migrate only what is stable*). Until a human re-migrates them, the
  OneDrive-sourced documents stand as written. This entry records what the pages *say* so nobody
  reads them as settled and nobody misses them either.
- What `Payroll management` adds that is **in no vault document**:
  - A **third `PAY-` id scheme** beside the two `PR-###` schemes already flagged in
    [payroll/INDEX.md](INDEX.md) caveat 1. `PAY-WP-` (weekly payroll) and `PAY-CC-` (craft codes)
    do not collide with `PR-###`, but they are epic-scoped user stories, not rules — do not
    cite them as rules.
  - Weekly-payroll **week statuses**: *In Progress, Needs Processing, Submitted to ADP, Closed*
    (`PAY-WP-04` AC 7).
  - **Send Back** targets *Crane Super or Worker*, worker gets a mobile notification and may edit
    the ticket after send-back (`PAY-WP-03` AC 3–4); Crane Super may *Approve* or *Override*;
    *Approve the Week* is a week-level action (`PAY-WP-04`).
  - Employee profile calculation panel: *pay breakdown, rate resolution, pricing slices, granted
    hours, rest-period audit* (`PAY-WP-02` AC 9) — vocabulary that matches the legacy
    [db-extract](legacy-payroll-app-db-extract/INDEX.md) slice model, which suggests the page
    is written against that engine.
  - Each of these is a *specific* the 2026-08-05 minutes
    ([meetings/2026-08-05-payroll-module-design-review.md](../meetings/2026-08-05-payroll-module-design-review.md))
    only discuss in general terms (Edit/Override, send to Crane Supervisor, ticket status).
- What `Craft codes` adds:
  - The first written definition candidate for **`craft-code`**, one of the seven undefined
    domain terms in the main README: *the group/pay classification at which employees are paid*;
    groups are *Apprentice 1–6 and Groups 1–9*; carries the **base rate only** (OT/DT derive from
    it); rates vary **by fiscal year**; kept **separate from Craft Code Modifiers** (`PAY-CC-01`).
    This is consistent with the legacy `FMS_UNION_CRAFT` + craft-modifier split in the db-extract,
    and with the closed entry *ADP job titles are not craft codes* above. It is **not** a
    `domain/` glossary entry until re-migrated or sourced to a person.
  - An **employee-specific additional rate on top of the craft rate**, maintained on the employee
    profile, that does not change the craft rate (`PAY-CC-02` AC 4–6). Check against the legacy
    `v_UI_Employee_TypeRate` resolution in the db-extract before treating as new.
- Note: `payroll/INDEX.md` and the main `INDEX.md` said Confluence had no payroll content. That
  was true on 2026-08-13 and is not true now; the main index line was corrected 2026-08-19.
- Blocked: nothing yet — but any payroll unit that builds week statuses, send-back targets or
  the craft-code shape should cite these pages *as unverified Confluence*, not as the vault.
- Owner: whoever re-migrates (human, per README *Who does what*); Umair Khan for whether the pages
  are finished.
- **Status:** open — **partly answered provisionally, pending ratification**: [../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md) (developer decision, no ticket id known, 2026-09-28, `status: reference`). Clause 1 says what flags an entry: the boom bracket lies wholly outside the crane's min–max boom length (ft), which warns and does not block. Clause 3 says Send Back goes to one Crane Supervisor (an active Employee with the `supervisor` flag and a login), with a required reason, and an uncorrected send-back blocks approval of the week. The *Worker* send-back target, the 3-hour reminder, and whether these pages supersede the vault **stay open**. Brian Petros / Corrina Bustos and the field-ops owner to ratify. *(Was: open, 2026-08-19 – 2026-09-28.)* **Update 2026-09-29: clause 3's provisional answer is overruled by the client.** Corrina Bustos, Teams, in writing: *"please update all flags to go to the payroll admin and payroll manager. not the crane superintendent"*. See [../decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md](../decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md) (`status: verified`, partial). Send Back no longer has a sanctioned target. What replaces it is open in [*Flagged entries go to payroll, not the crane superintendent*](#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives). This entry's main question stays open. (Also stale above: clause 3 was revised on 2026-09-28 from the `supervisor` flag to a `crane-supervisor` role permission.)
- **From (frozen original):** [gaps-2026-08-20-retired.md#confluence-payroll-user-stories-first-payroll-pages-in-confluence-unmigrated](gaps-2026-08-20-retired.md#confluence-payroll-user-stories-first-payroll-pages-in-confluence-unmigrated)

## Meeting recordings disagree with the vault — 2026-08-19 review

- Question: which side is right, in each of the pairs below?
- Candidates: the OneDrive drop `OneDrive_1_8-19-2026` (55 TCG–CodingCops meeting recordings,
  2026-01-15 → 2026-08-13) was read in full on 2026-08-19 and every product ask checked against
  the vault and all 902 SCRUM issues. Full report (1,501 items; 502 with no ticket and no
  vault coverage, 348 in the vault with no ticket):
  https://claude.ai/code/artifact/8d4b706b-9eaa-4369-a9b2-d78fe26233db . The rows below are the
  ones where a recording **contradicts** a vault file or a ticket. Product ones are in
  `gaps.md` under the same heading.
- **Recency is not authority.** A recording is a data point inside the conflict, not its
  resolution — several of these are TCG changing its mind between meetings. Do not pick a side.
- **Confluence and Jira are CodingCops' record, not the client's.** TCG does not use Confluence.
  A recording that disagrees with a vault file or a ticket is therefore first a defect in *our*
  write-up of what the client said; it becomes a client question only where TCG itself said two
  different things, or where CC agreed to something on the call and never wrote it down.
- Note: room-mic recordings label Lisette, Dylan, Liz and Wes as "Brian Petros"; speakers below
  are inferred from content.
- Pairs:
  - **2026-05-21** — Subsistence for report-to-site: based on yard-to-job distance (not employee
    home): short subsistence $85 (~45 miles), long subsistence $200 per day over ~44.5 miles. —
    *vault/ticket:* CONTRADICTS: payroll/erp-payroll-module-frd/07-rest-meal-and-subsistence.md
    and payroll/payroll-app-current-state/03-payroll-rule-catalog.md say long subsistence is $85
    on weekdays (SUBSISTENCE_LONG_WEEKDAY_85) and $200 only on weekends (PR-038 Long-Distanc… —
    *jira:* SCRUM-876 (compliance checklist captures Long/Short Sub)
  - **2026-05-26** — Lunch thresholds: 1st lunch by 5 h (penalty from 5.5 h because union pays
    in 30-min increments), 2nd by 10.5 h, 3rd by 16.5 h, 4th at 22 h; notification one hour
    before each (first at the 4-h mark) — *vault/ticket:* ATOM/03-work-execution-and-lunch.md
    (5/10.5/16.5/22, 1 h before — matches); gaps.md → "Lunch thresholds and work-through-lunch
    authorization" says the numbers "cite no origin" — this meeting IS the origin (Corrina +
    Ryan). CONTRADICTS: payroll/wtl-charts.md… — *jira:* SCRUM-864
  - **2026-05-26** — Times captured to the minute but payroll/billing rounds to 30-min
    increments company-wide; halfway rule (9:15+ → 9:30, below → 9:00) — *vault/ticket:*
    FOP1/fr-fop-038-time-rounding.md, BRS BRS-TIME-004 ("30-minute increments,
    employee-favorable" — Needs Client Validation). CONTRADICTS:
    payroll/legacy-payroll-app-db-extract/rules-plain-language.md (start rounded DOWN, end UP —
    not nearest half-hour); also …
  - **2026-05-28** — Wes: all HR functionality must live in-house in the ERP; keep ADP only for
    cheque processing, payroll taxes/fees "at their most basic function" — *vault/ticket:*
    CONTRADICTS: decisions/2026-06-30-adp-erp-employee-data-ownership.md — ADP remains owner of
    legal HR record and performs onboarding; "rebuilding ADP's onboarding inside the ERP"
    explicitly rejected (Brian, 2026-06-30)
  - **2026-06-09** — Mobile: show one lunch button per allowed lunch (from BRS rules),
    auto-highlighted 30 minutes before the threshold; tap logs a fixed 30-min lunch (Corrina
    confirms lunch is always 30 min) — *vault/ticket:*
    field-ops/atom-mobile-app-user-stories/03-work-execution-and-lunch.md ("notification 1 hour
    before"); brs.md BRS-LUNCH-003 (⚠ Needs Client Validation) — *jira:* SCRUM-864 ("1
    hour before")
  - **2026-06-23** — ADP import layout: company code 631 (Crane Guys), file number = ADP
    employee ID (6 digits, leading zeros), Reg/OT/DT hours, extra lines per boom rate with rate,
    sub pay, holiday DT and holiday triple hours, sick pay (non-union … — *vault/ticket:*
    payroll/adp-bucket-crosswalk.md; CONTRADICTS: payroll/gaps.md:74 says "631 is not a company
    code at all" (Co Code 4RZ), and §"ADP File Number — the crosswalk's format rule is wrong"
  - **2026-06-25** — Owners want the ERP to be the system where employee data and onboarding
    live, pushing to ADP (not ADP → ERP as Joe's workflows showed) — *vault/ticket:*
    CONTRADICTS: decisions/2026-06-30-adp-erp-employee-data-ownership.md says ADP stays owner of
    legal/payroll fields; ERP *initiates* onboarding, ADP *performs* it; "rebuilding ADP's
    onboarding inside the ERP" explicitly rejected (superseded 5 days later)
  - **2026-07-09** — Fill-in field employees need basic info in ERP so they can do tickets/labor
    before ADP onboarding completes (Corrina gives them until Sunday) — *vault/ticket:*
    dispatch/daily-allocation-system.md (Temp employee management: "Fill In" placeholder);
    decisions/2026-06-30-… step 5 says ERP blocks scheduling until ADP onboarding complete —
    CONTRADICTS Brian's ask here — *jira:* SCRUM-254 (Temporary Employee management in DAS),
    SCRUM-304
  - **2026-08-04** — Lattice pay: crawler crane is the only lattice unit; only operator and
    oiler qualify (third man does not); it is an hourly base-rate adder for the whole job, not
    boom pay; it stacks with boom pay; Joe: trigger it from the asset… — *vault/ticket:*
    CONTRADICTS: M-0805 says lattice identification "requires further discussion with Kyle and
    Joe" and `payroll/gaps.md` §"Lattice Crane identification" is open, owner Kyle/Joe — the
    recording shows Joe settling it (asset-based, crawler only); also `payroll/co…
  - **2026-08-13** — Correction: pay rate does NOT follow the role worked — an employee
    dispatched at $70 as operator stays at $70 even if allocated as rigger; rule: a secondary
    craft code must carry a higher rate than the primary; effectively pay … — *vault/ticket:*
    CONTRADICTS: payroll/erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md
    PR-007 — "L12 base rate = union craft rate for the labor-entry CraftCode" (rate from the
    role on the labor entry, no floor at the employee-master craft)
  - **2026-08-13** — Per-employee week statuses: In Progress (current week), Submitted (hours
    sent to ADP), Processing (ADP accepted), Received (checks received by payroll), Paid (checks
    distributed); statuses cascade from the payroll module — *vault/ticket:* CONTRADICTS:
    payroll/gaps.md → "Confluence payroll user stories" PAY-WP-04 AC 7 lists week statuses In
    Progress / Needs Processing / Submitted to ADP / Closed — no Processing / Received / Paid
- **Disposition, 2026-08-19 (`tcg-scrum` pass).** Each pair was retrieved in full — `INDEX.md`,
  `payroll/INDEX.md`, the cited vault files, `decisions/`, the named Jira issues, and the plain-text
  transcript passage. **The list above contains 11 pairs, not 10** (`2026-05-26` appears twice —
  lunch thresholds and time rounding); the main `INDEX.md` conflict table already says 11. Three
  states, and no pair was resolved from a transcript:
  - `2026-05-28` Wes / all HR in-house — **superseded by
    [../decisions/2026-06-30-adp-erp-employee-data-ownership.md](../decisions/2026-06-30-adp-erp-employee-data-ownership.md)**
    (Brian Petros + Ehtesham Anwar, agreed 2026-06-30, 33 days later). Kept as record; not open.
  - `2026-06-25` owners want ERP to own onboarding — **superseded by the same decision note**
    (5 days later). Kept as record; not open.
  - `2026-06-23` ADP import layout, company code 631 — **resolved by live API observation, not by a
    human decision**; see §*ADP export mapping* (D-001, 2026-08-13) and §*ADP File Number*
    (**closed**). One residual: §*What `631` actually is*.
  - `2026-05-21` subsistence — open → §*Subsistence — the recording and the engine disagree on both the amount and the trigger*
  - `2026-05-26` lunch thresholds — needs confirmation → §*Lunch thresholds — the recording is the origin, and it disagrees with the WTL charts*
  - `2026-05-26` time rounding — needs confirmation → §*Time rounding — nearest half hour, or start-down/end-up?*
  - `2026-06-09` lunch alert lead time — open → §*Lunch alert lead time — one hour or thirty minutes?*
  - `2026-07-09` fill-in employees — open, and it **post-dates** the 06-30 decision → §*Fill-in field employees vs the ADP-onboarding dispatch block*
  - `2026-08-04` lattice — needs confirmation → §*Lattice — Joe settled it on the recording, nothing records it*
  - `2026-08-13` rate does not follow role — needs confirmation → §*Pay rate follows the employee, not the role worked — Kyle and Corrina, unrecorded*
  - `2026-08-13` week statuses — open → §*Weekly payroll week statuses — two CodingCops sources, no TCG statement*
- Blocked: nothing yet — each pair blocks the unit that touches it.
- Owner: `tcg-scrum` to put each pair to the named TCG person; the answer goes to `decisions/`.
- **Status:** **partly disposed** — 2 superseded by `decisions/2026-06-30-adp-erp-employee-data-ownership.md`, 1 resolved by live ADP observation, 8 still open or awaiting confirmation, each with its own entry below.
- **From (frozen original):** [gaps-2026-08-20-retired.md#meeting-recordings-disagree-with-the-vault-2026-08-19-review](gaps-2026-08-20-retired.md#meeting-recordings-disagree-with-the-vault-2026-08-19-review)

## Subsistence — the recording and the engine disagree on both the amount and the trigger

- Question: for **long** subsistence on a **weekday**, is the allowance **$85** (what the legacy
  engine pays) or **$200 per day** (what Melissa described), and is eligibility computed from
  **yard-to-job distance** or entered manually as a `SUB_SHORT` / `SUB_LONG` comment token?
- Candidates:
  - Recording **2026-05-21 "Crane-Configurations / Job-Tickets"**, Melissa McNutt at 55:53:
    *"if it's like 45 and a half miles, they get short subsistence, which is $85. And then if it's
    over 44 and a half miles, and it goes to long subsistence, and it's $200 per day."* At 56:34
    she confirms the distance measured is **yard location to job location**, not the employee's
    home. No weekday/weekend split is mentioned. **The two mileage figures as spoken (45.5 / 44.5)
    overlap and cannot both be the cut-off** — the threshold itself is unrecovered.
  - `payroll/legacy-payroll-app-db-extract/rules-plain-language.md` §11 and
    `payroll/legacy-payroll-app-db-extract/sql/app/usp_Apply_SubsistencePay.PROC.sql:92-95` —
    the engine as built: `SUBSISTENCE_SHORT_85` **$85 any day**, `SUBSISTENCE_LONG_WEEKDAY_85`
    **$85 Mon–Fri**, `SUBSISTENCE_LONG_WEEKEND_200` **$200 Sat/Sun**. Driven by the `SUB_SHORT` /
    `SUB_LONG` comment token, **not by any distance calculation** — there is no mileage input.
  - `payroll/erp-payroll-module-frd/07-rest-meal-and-subsistence.md` PR-037 / PR-038 (note the
    `PR-###` ambiguity, `payroll/INDEX.md` caveat 1) — PR-037 ties the **$85** to an *overnight
    stay away from home* plus distance and equipment-remains-on-job; PR-038 ties **$200/day** to
    **weekend** long-distance work, with an employer election to pay portal travel instead.
    PR-037 lists *employee home base* **and** *equipment home yard* among required inputs, which
    the recording says is wrong.
  - `payroll/payroll-app-current-state/03-payroll-rule-catalog.md:147-157` — same three tokens,
    "comment-token driven and payable-only".
  - `SCRUM-876` *Compliance Checklist & Attestation* (**QA**, reporter Umair Khan, created
    2026-08-11) — the employee selects *"Long Sub, Short Sub or N/A"*. It carries **no amounts and
    no distance rule**, so it does not settle this; it does mean the capture side is already built
    as a manual employee selection, matching the legacy token, not a computed distance.
- Note: three separate disagreements, and they should be answered separately — (a) the weekday
  long amount, (b) distance-computed vs manually flagged, (c) whether employee home base is an
  input at all. Melissa is the only named source for the distance model; the engine is the only
  source for the amounts. **Do not reconcile by preferring the recording: it is one speaker,
  unminuted, and internally inconsistent on the mileage.**
- Blocked: PR-037 / PR-038 in `payroll/erp-payroll-module-frd/`, the subsistence pay components,
  and the ADP **SUB PAY** mapping in `payroll/adp-bucket-crosswalk.md`.
- Owner: Melissa McNutt (she stated the distance model); Corrina Bustos to confirm what is
  actually paid today.
- **Status:** **answered** — 08-20 SME statement, corroborated 08-21
- **Rules:** [PAY-048](rules/PAY-048-standard-subsistence.md), [PAY-049](rules/PAY-049-weekend-subsistence.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#subsistence-the-recording-and-the-engine-disagree-on-both-the-amount-and-the-trigger](gaps-2026-08-20-retired.md#subsistence-the-recording-and-the-engine-disagree-on-both-the-amount-and-the-trigger)
- **Answer:** short = **$85/day, 45–77.5 mi, worked days only**; long = **$200/day,
  > 77.5 mi, every calendar day of the holdover, worked or not**. The engine's $85-Mon-Fri
  hard-coding is the defect; C-05 in the conflict register is answered the $200 way.
- **Corroborated 2026-09-01, contractually.** Quote OM-35140 p.3, supplied by Melissa McNutt
  2026-08-31, states the same rule in a **customer-facing contract** rather than a recording:
  *"Subsistence will be charged at $85.00 per man when equipment is to be operated by crew who
  would travel **from yard to job, forty-five miles or more** from yard location… When equipment /
  employees… are working in a subsistence area **over 77.5 miles** from home base location they
  shall receive **$200.00 per man per day** subsistence **for the week and weekend**."* This
  independently confirms all three parts of the recorded answer — the two amounts, the 45 / 77.5
  mile thresholds, and *for the week and weekend* matching "every calendar day of the holdover".
  It also settles sub-question **(c)**: the distance is measured **yard to job**, and the employee's
  home is not an input — the phrase *"home base location"* refers to the equipment's home yard, as
  the same sentence's *"yard location in which equipment in question is identified as home base"*
  makes explicit.
  **Sub-question (b) now leans the other way, though.** The e-ticket's Time Stamps checklist item 8
  reads *"If Subsistence is applicable please click deficiency and note long or short sub in the
  comments"* — capture in the field is a **manual flag plus a comment token**, with no mileage
  input, exactly as the legacy engine does it. So the *entitlement* is distance-based per the
  contract, while the *capture* is a token. Whether the ERP should compute distance and pre-fill
  that flag is still unasked. Sources:
  [quotations/quote-terms-and-rate-card.md](../quotations/quote-terms-and-rate-card.md) §3,
  [field-ops/e-ticket-worked-example.md](../field-ops/e-ticket-worked-example.md) §5.

## Lunch thresholds — the recording is the origin, and it disagrees with the WTL charts

- Question: are the lunch deadlines **5 / 10.5 / 16.5 / 22** hours (recording and `SCRUM-864`) or
  **5:01 / 10.5:01 / 16:01 / 21.5:01** (`payroll/wtl-charts.md`)? Lunches 3 and 4 differ by half an
  hour, which is a double-time penalty either way.
- Candidates:
  - Recording **2026-05-26 "Job-Tickets / mobile-app demo"** — Corrina Bustos explains first lunch
    (29:00 area: *"the first lunch is going to have to be before 5.5 hours… the union is in half
    hour increments, so even if they only work 5 hours and one minute, technically we still have to
    pay 5 and a half"*); **Ryan Adams at 29:07**: *"first lunch, 5 hours within the ship, second
    lunch, 10.5, and third, 16.5"*; at 29:23, fourth = *"22 hours"*. Ehtesham proposes at 28:0x:
    *"whenever the lunch needs to be due, we send them notification one hour before that time"* —
    unopposed. **This meeting is the origin of the numbers** that `../gaps.md` §*Lunch thresholds and
    work-through-lunch authorization* records as citing no origin.
  - `SCRUM-864` *Lunch & Work Through Lunch Management* — **QA** (not "In Progress"; reporter Umair
    Khan, created 2026-08-06, updated 2026-08-12). AC: Lunch 1 before 5 h, Lunch 2 before 10.5 h,
    Lunch 3 before 16.5 h, Lunch 4 before 22 h, notification **1 hour before** each. **Matches the
    recording exactly** and is already through build.
  - `field-ops/atom-mobile-app-user-stories/03-work-execution-and-lunch.md` — 5 / 10.5 / 16.5 / 22,
    1 hour before. Matches.
  - `payroll/wtl-charts.md:34-37` — the payroll team's own charts: first **5:01**, second
    **10.5:01**, third **16:01**, fourth **21.5:01**. **Third and fourth are half an hour earlier.**
  - `brs.md` BRS-LUNCH-002 lists **three** lunches and is marked ✓ Confirmed; BRS-LUNCH-005
    *Lunch Threshold Values* is 📄 Needs Supporting Documentation. Both FRDs list the thresholds as
    an open question (`field-ops/field-ops-frd/11-open-questions-future-considerations.md` Q1;
    `field-ops/frd-new-format-draft/08-open-questions.md` Q4, owner Corrina).
- Note: this is state (c) — a named TCG person stated the values on a recording, and no minutes or
  decision note record it. **A decision note has not been written**, because "Ryan said it on a call
  while Corrina was explaining something adjacent" is not the same as Corrina adjudicating the
  charts she owns. The charts are the payroll team's own artefact, so the recording does not
  automatically beat them.
- Blocked: nothing hard — both FRDs require the thresholds to be configurable without a code change,
  so building them as server-driven config keeps the answer a config change. But `SCRUM-864` has
  shipped one side of an unresolved disagreement.
- Owner: Corrina Bustos (owns the WTL charts and Q4 in FR-TCG-FOP-001); Ryan Adams stated the values.
- **Status:** open — needs confirmation
- **Rules:** [PAY-046](rules/PAY-046-meal-opportunity.md), [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#lunch-thresholds-the-recording-is-the-origin-and-it-disagrees-with-the-wtl-charts](gaps-2026-08-20-retired.md#lunch-thresholds-the-recording-is-the-origin-and-it-disagrees-with-the-wtl-charts)
- Update 2026-09-04 (Project Repository ingest): the contract text and the legacy configuration both
  point at the WTL-chart values, and nobody at TCG has said so. (a) **Contract** — Truck Crane MLA
  Article III → *Meal Periods* §1
  ([mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md)):
  *"No employee shall be required to work more than five (5) hours consecutively without a one-half
  (½) hour meal period."* With each meal taken as the fixed half hour that runs 5 → 10.5 → 16 →
  21.5, the `wtl-charts.md` sequence; no arithmetic reaches the recording's 16.5 / 22. The MLA
  states the 5-hour rule, not the list — the derivation is this note's, not the contract's. (b)
  **Legacy engine config**, already in the vault and not cited here before:
  `cfg.WTL_MaxMealThreshold`
  ([legacy-payroll-app-db-extract/config-values.md](legacy-payroll-app-db-extract/config-values.md))
  bands the shift span **0.5–5 / 5.5–10.5 / 11–16 / 16.5–21.5 / 22–27 h → 0/1/2/3/4 meal periods**,
  loaded 2026-05-25 — the same sequence, built by CodingCops. (c) The June-2026 demo build
  ([../field-ops/field-app-demo-2026-06.md](../field-ops/field-app-demo-2026-06.md) §3) unlocks each
  break **5 h after the previous one was resolved** — rolling, which also gives 5 / 10.5 / 16 / 21.5
  when breaks are taken — but models **three** lunches, not four. (d) The paper ticket's customer
  terms §15 ([../field-ops/field-paper-forms.md](../field-ops/field-paper-forms.md) §1) and FCC's
  *Work Through Lunch* attestation
  ([tcg-rawfms-staging-database/data/fcc-checklist-templates.md](tcg-rawfms-staging-database/data/fcc-checklist-templates.md)
  → *What stands out*) restate only the 5-hour rule. Still needs the client: Corrina confirming 16 /
  21.5 (or the recording's 16.5 / 22) as the third and fourth thresholds — `SCRUM-864` shipped the
  recording's values.

## Time rounding — nearest half hour, or start-down/end-up?

- Question: does payroll round every time event to the **nearest** 30 minutes (9:15 and later → 9:30,
  before 9:15 → 9:00), or does it round the entry **start down and the end up** as the legacy engine
  does?
- Candidates:
  - Recording **2026-05-26 "Job-Tickets / mobile-app demo"**, Corrina Bustos at 1:08:49 →
    *"is there a way that you can make it to where the time automatically is in 30 minute
    increments… if it's 904, it would actually be 9:00 because that's how we pay and bill"*; at
    1:09:11 *"that's company-wide, not just payroll. So it's billing, everything. Yeah, union
    rule."*; at 1:09:32–1:09:46 Ehtesham asks whether 9:24 counts as 9:00 or 9:30, Corrina answers
    **"930"**, and confirms *"correct"* to *"915 onwards is 930, if 915 below it's 9 o'clock"*.
    Ehtesham commits: exact times are logged, **payroll uses 30-minute increments**.
  - `payroll/legacy-payroll-app-db-extract/rules-plain-language.md:208` — the engine as built:
    *"the entry's start is rounded **down** and end **up** to 30 minutes, then cut into 30-minute
    slices"* (`app.usp_Prepare_Continuous_Labor`). **This is employee-favourable and is not
    nearest-half-hour** — a 9:24 start rounds to 9:00 under the engine and to 9:30 under Corrina.
  - `field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-038-time-rounding.md`
    (FR-TCG-FOP-**001** — cite the document, `INDEX.md` caveat 3) — requires both exact and rounded
    times to be stored and says *"rounding rules are configurable"*. It **does not state the rule**,
    so it cannot arbitrate.
  - `brs.md` BRS-TIME-004 *Union Rounding Rules* — ⚠ Needs Client Validation.
- Note: state (c). Corrina is the right person and she answered a direct question with a worked
  example, but nothing records it as a decision, and the difference is systematic, not marginal —
  under nearest-half-hour an employee loses up to 15 minutes at the start of every shift, which is
  exactly the outcome the legacy engine's down/up rule was built to avoid. Ask whether the legacy
  behaviour is the intended rule or a legacy artefact before implementing either.
- Blocked: the slice formula in the ERP pricing engine, every downstream hour bucket, and billing —
  Corrina states the rule is company-wide, not payroll-only.
- Owner: Corrina Bustos.
- **Status:** resolved 2026-09-04 — answered from the record, no client question needed. **Start down,
  end up, to 30-minute increments, for all employees, union and non-union** — Brian Petros's written
  statement, recorded as
  [../decisions/2026-08-24-payroll-time-rounding-method.md](../decisions/2026-08-24-payroll-time-rounding-method.md)
  (`status: verified`).
- Resolution (a): the decision note quotes the client statement directly — *"starting times get
  rounded down/back to 30 minute increments… ending times get rounded up/forward… that's for all
  Union and non-union"* (Brian Petros, payroll summary message, backlog batch) — and records that
  the as-built engine (`usp_Prepare_Continuous_Labor`) and the MLA's half-hour reckoning agree with
  it. That is the start-down/end-up reading, not Corrina's nearest-half-hour worked example; the
  note post-dates this entry and was never linked back to it.
- Resolution (b): the ingest corroborates and nothing in it contradicts: the ADP workbook's `Total
  Hrs` column is *"entry start rounds down, end up, to 30 min"*
  ([adp-workbook-column-rules.md](adp-workbook-column-rules.md) → *Column by column*); the June-2026
  field-app demo rounds *Left Yard down, Arrive Job up* — *"Rounded down/up to 30 min in your
  favor"* ([../field-ops/field-app-demo-2026-06.md](../field-ops/field-app-demo-2026-06.md) §2); the
  paper ticket's customer terms §13 bill in 30-minute increments
  ([../field-ops/field-paper-forms.md](../field-ops/field-paper-forms.md) §1). The Truck Crane MLA
  text has no rounding clause at all (`grep -i round` finds none), so the contract does not
  arbitrate and does not object.
- Resolution (c): one FCC fact worth carrying, not a reopening: FCC's L12 *Union Payroll Defaults*
  hold **`Time Round To 30 Mins`**, and that field rounds **down only**
  ([fcc-union-code-configuration.md](fcc-union-code-configuration.md) §5, note 2;
  [fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) → *Union Codes*,
  slide 19) — the incumbent cannot express the asymmetric rule, so either TCG does not rely on that
  field or the end-up half happens in the workbook. That is a question about FCC's mechanism,
  already logged on the union-code page, not about the rule.
- Sources checked: decisions/2026-08-24 note; adp-workbook-column-rules → *Column by column*;
  field-app-demo-2026-06 §2; field-paper-forms §1; fcc-union-code-configuration §5;
  fcc-employee-master-reference-data → *Union Codes*;
  [rules-plain-language.md](legacy-payroll-app-db-extract/rules-plain-language.md):208; Truck Crane
  MLA full text (no rounding clause); [PAY-020](rules/PAY-020-half-hour-reckoning.md).
- Owner: answered; no client action outstanding. Owed: PAY-020 and `fr-fop-038` should cite the
  decision; the `SCRUM-864` / field-app rounding already matches it.
- **Rules:** [PAY-020](rules/PAY-020-half-hour-reckoning.md), [PAY-069](rules/PAY-069-money-rounding-and-rounding-adjustment-components.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#time-rounding-nearest-half-hour-or-start-downend-up](gaps-2026-08-20-retired.md#time-rounding-nearest-half-hour-or-start-downend-up)

## Lunch alert lead time — one hour or thirty minutes?

- Question: is the lunch reminder sent **1 hour** before the lunch is due, or **30 minutes** before?
- Candidates:
  - Recording **2026-05-26**, Ehtesham Anwar: *"as a rule of thumb, let's say whenever the lunch
    needs to be due, we send them notification one hour before that time"* — nobody objects. Earlier
    in the same call Brian Petros asks for prompts *"at 4.5 hours"* against a 5-hour first lunch,
    which is also a 30-minute lead.
  - Recording **2026-06-09 "Payroll-App demo-01"**, Ehtesham at 54:42: *"they are going to be
    automatically highlighted whenever the time comes. So we decided **30 minutes** before the time
    hits, right? So we are going to highlight them. They are required to just click on that and it
    automatically logs for half an hour."* Corrina Bustos answers **"Yes."** Two lines later, asked
    *"is it always half an hour or can the time change for lunch?"*, Corrina: **"Always half hour."**
  - `SCRUM-864` (**QA**) — *"System sends a notification **1 hour before** each applicable lunch is
    due."* Built to the 05-26 figure.
  - `field-ops/atom-mobile-app-user-stories/03-work-execution-and-lunch.md` — 1 hour before.
  - `brs.md` BRS-LUNCH-003 — ⚠ Needs Client Validation.
- Note: the two recordings are two weeks apart and the second one says *"we decided"*, so this looks
  like TCG (or CodingCops) changing the number between meetings rather than a documentation error.
  Corrina's **"Yes"** is to a compound statement (highlight 30 min before **+** one tap logs a fixed
  half hour), so it is not safe to read it as ratifying the lead time specifically — which is why no
  decision note was written. **The 30-minute fixed lunch duration is a separate fact and is not in
  dispute**: Corrina states it unprompted and no vault file contradicts it.
- Blocked: the mobile lunch reminder in `SCRUM-864`, already in QA at 1 hour.
- Owner: Corrina Bustos.
- **Status:** open
- **Rules:** [PAY-046](rules/PAY-046-meal-opportunity.md), [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#lunch-alert-lead-time-one-hour-or-thirty-minutes](gaps-2026-08-20-retired.md#lunch-alert-lead-time-one-hour-or-thirty-minutes)
- Update 2026-09-04 (Project Repository ingest): the June-2026 demo build CodingCops walked TCG
  through on 2026-06-16
  ([../field-ops/field-app-demo-2026-06.md](../field-ops/field-app-demo-2026-06.md) §3) hard-codes
  `LUNCH_WARN_MS = 1 hour` — a reminder one hour before each break unlocks — and writes a fixed
  30-minute break on tap. So a week *after* the 06-09 *"we decided 30 minutes"* exchange the shipped
  prototype was still at one hour, making it a third CodingCops artefact at that figure alongside
  `SCRUM-864` and the Atom user stories. It corroborates the fixed 30-minute duration; no TCG
  statement on the lead time appears in anything ingested. Still needs Corrina.

## What `631` actually is

- Question: `631` is not an ADP company code — so what is it? A Workforce Now **batch** or client
  identifier, the old FCC/NexGen company number, or something else?
- Candidates:
  - Recording **2026-06-23 "Mobile App / Payroll ADP and draft workflows"**, Brian Petros at 41:32:
    *"the company code is, this is going to be always **631**, which is crane guys"*, describing the
    paydata import layout; *"file number is ADP's version of employee ID… it's really a six-digit
    code. So there's three zeros and then this is the employee ID."*
  - `payroll/gaps.md` §*ADP export mapping* (D-001, resolved 2026-08-13 by a live call to
    `GET /events/payroll/v1/pay-data-input.modify/meta`,
    `payroll/adp-api-responses/pay-data-input-meta.md`): **the company codes are `4RZ` (THE CRANE
    GUYS LLC) and `4RY` (The Crane Guys, LLC – Ventura). `631` is not a company code at all.**
  - `payroll/gaps.md` §*ADP File Number — the crosswalk's format rule is wrong* (**closed**): ADP's
    own validation is `^0*(5[1-9]|[6-9][0-9]|[1-9][0-9]{2,5})$` — digits only, minimum value 51,
    leading zeros allowed and not counted toward the 6-character limit. Brian's "six digits with
    leading zeros" is compatible; his implied fixed width is not a rule ADP enforces.
- Note: **this pair is resolved against the recording, but by live API evidence, not by a decision
  from a named human** — do not record it in `decisions/`. The rest of Brian's layout description
  (Reg/OT/DT lines, extra lines per boom rate carrying their own rate, base rate assumed from the
  employee's union group, sub pay, holiday DT/triple, sick pay) is **not** contradicted by anything
  in the vault and is corroborated by
  `payroll/legacy-payroll-app-db-extract/` (the observed ADP worksheet layout). Only the company
  code is wrong. The residual question matters because whatever `631` is, it is what payroll types
  today, and the ERP export must not carry it into the API payload.
- Blocked: nothing — the export must use `4RZ` / `4RY`. This entry exists so nobody re-derives `631`
  from the recording.
- Owner: Brian Petros (he supplied the layout and holds the ADP file facts).
- **Status:** **answered** — client statement ~2026-07-28 (message batch, captured 2026-08-24)
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#what-631-actually-is](gaps-2026-08-20-retired.md#what-631-actually-is)
- **Answer:** `631` was TCG's **previous ADP company code**, renamed to **`4RZ`** during the
  July ADP updates ("our company code changed from 631 to 4RZ"; still Workforce Now). The
  sample-export filenames corroborate exactly: `EPI63100.CSV` = EPI + old code 631, `EPI4RZ32.csv`
  = EPI + new code 4RZ. Dashboard screenshot shows "4RZ - THE CRANE GUYS LLC", payroll week
  Completed. Anything still referencing 631 (workbooks, Power Query, crosswalk rows) is stale.

## Fill-in field employees vs the ADP-onboarding dispatch block

- Question: may a **fill-in field employee** be dispatched, allocated to a job and file tickets and
  labor from a basic ERP record **before** ADP onboarding completes — or does step 5 of the
  2026-06-30 decision (ERP blocks scheduling, equipment assignment and job allocation until ADP
  reports onboarding complete) apply to them too?
- Candidates:
  - Recording **2026-07-09 "ADP and Data Migration"**, Brian Petros at 34:43: *"they would be
    entered in the ERP, but maybe the ADP information isn't completed yet. So maybe we would want to
    identify like the basic information for field employees to be entered in the ERP so that they
    can fill in their job tickets, information, their labor, and then… it still gives them a few
    days to get the documents into ADP. Right. So that's one special process."* Corrina Bustos at
    35:10 confirms the current practice: *"right now with the fill-ins I give them until like Sunday
    to fill out all the ADP stuff because the payroll is generated every Monday, Tuesday."*
  - `../decisions/2026-06-30-adp-erp-employee-data-ownership.md` step 5 — *"Until ADP reports
    onboarding **complete**, the ERP treats the employee as pending and **blocks scheduling,
    equipment assignment and job allocation**."* `status: verified`, Brian Petros + Ehtesham Anwar.
  - `dispatch/daily-allocation-system.md` §*Temporary Employee management in DAS* — temps are
    assignable *"without creating full HR profiles"*, get a "Temp" tag, a "Fill In" placeholder, a
    secure link, and *"payroll and billing teams can see the temp employee assignment"*. No ADP
    gating anywhere in the story.
  - `SCRUM-254` *Temporary Employee management in DAS* (**Done**, created 2026-05-01) and
    `SCRUM-304` *Temporary employees* (**Done**, created 2026-05-06) — both shipped before the
    decision note and neither mentions ADP onboarding status.
- Note: **the sharpest of the eleven, and the only one where the recording post-dates the decision
  it contradicts** — Brian raised this on 07-09, nine days *after* he agreed to step 5 on 06-30. So
  it reads as an amendment request from the same person, not as a statement the decision supersedes.
  Do not resolve it by recency in either direction. Two shipped tickets already implement the
  unblocked behaviour, so the ERP today does **not** enforce step 5 for temps; whichever way this
  goes, one side needs changing.
- Blocked: `SCRUM-254` / `SCRUM-304` are Done and may need reopening; any ERP↔ADP onboarding-status
  gate; the employee-creation push described in `payroll/adp-read-write-boundary-2026-08-18.md`.
- Owner: Brian Petros (raised it, and co-owns the 06-30 decision); Corrina Bustos for the
  until-Sunday practice.
- **Status:** open
- **Rules:** [PAY-003](rules/PAY-003-employee-master-import.md), [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#fill-in-field-employees-vs-the-adp-onboarding-dispatch-block](gaps-2026-08-20-retired.md#fill-in-field-employees-vs-the-adp-onboarding-dispatch-block)
- Update 2026-09-04 (Project Repository ingest): three facts about current practice, none an
  amendment to the 06-30 decision. (a) **Fill-ins are a dispatch tier**: Melissa's union-rules list
  of 2026-04-08 ([../erp-review-log.md](../erp-review-log.md) → *#4 — Union rules to enforce*) sets
  the call-out order **Tier 1 Operators → Tier 2 Oilers → Tier 3 Apprentices → Tier 4 Fill-ins**,
  repeated in the dispatch playbook
  ([../dispatch/dispatch-value-engine-and-playbooks.md](../dispatch/dispatch-value-engine-and-playbooks.md)
  §4) — a client statement that fill-ins are dispatched, silent on whether they may go out before
  ADP is complete. (b) HR's onboarding checklist (Corrina, 2026-05-11 —
  [hr-onboarding-and-employee-forms.md](hr-onboarding-and-employee-forms.md) §3) lists **ADP as item
  5 and the FCC profile as item 8**, with *"Field Availability List given to Dispatch"* at item 13 —
  an ordered list, not a gate; nothing says dispatch waits for ADP. (c) **The mechanism behind the
  Sunday deadline**: the weekly roster is pulled from FCC (`src_FccEmployees`,
  [adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §1) and the ADP file
  number is keyed by hand in Excel; a roster employee with no file number is an `ERROR` — *"missing
  or invalid ADP file numbers"* — that blocks the whole week's CSV (§6). So today a fill-in can work
  and file tickets in FCC with no ADP record, and the cost lands at payroll close-out, which is why
  Corrina gives them *"until Sunday"*. Legacy-process facts, not a decision. Still needs Brian and
  Corrina: whether step 5 applies to fill-ins or is amended for them.
- Update 2026-09-28 (ADP Integration Sync, [../meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md](../meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md) §1.2, §2): (a) Fill-ins are onboarded in ADP **exactly like everyone else**, and ADP doesn't distinguish them (*"They look the same"*). Fill-in status exists only in TCG's own records. (b) Today Corrina **hires and terminates a fill-in in ADP every time they start and stop working** (23:03). (c) She asked for the ERP to **activate / deactivate the profile and have that reach ADP**, and abdulrehman said *"we can do that"*. That is a new integration requirement (ADP `worker.rehire` / `worker.terminate`, still open in the 06-30 decision's edge-case row), not an answer to step 5. (d) The call also moved *where onboarding starts*. See *Where the employee lifecycle starts — ERP-initiated (06-30) or ADP-first (09-28)?*. If the ERP no longer creates the employee, step 5's "pending until ADP completes" gate needs rethinking with it.

## Lattice — Joe settled it on the recording, nothing records it

- Question: is the lattice-pay trigger settled as **the crawler crane only, every time it is
  dispatched**, with lattice on any other crane treated as a jib extension / luffing jib that earns
  boom pay only — as Joe Schacatano stated on 2026-08-04?
- Candidates:
  - Recording **2026-08-04 "Payroll Process"**, 56:45–57:40. Brian Petros: *"So every time the
    crawler crane gets dispatched, then it is qualifying for lattice. Is that correct?"* **Joe
    Schacatano: "Yes."** Brian asks about the other cranes; Joe: *"Don't even worry… That's all that
    would be applicable to boom pay. That's it."* and *"We're not going to call them lattices on the
    other one. We're going to call them jib extensions or luffing jibs… we're talking two different
    things. We're talking boom pay and then the lattice adder pay for the hourly rate."*
  - Same recording, 52:15 — **Corrina Bustos**: *"only the oiler and the operator qualify for it.
    The third man does not. And there have been times where the third men have tried to get the pay,
    and I've had to take it off."* At 58:17, asked whether boom pay and lattice are mutually
    exclusive, Corrina: *"No, it's on top of… if they are using the crawler, they can also qualify
    for BoomPay."* — **lattice stacks with boom pay.**
  - Same recording, 53:11 — Melissa McNutt proposes the mechanism: the salesman marks lattice in the
    crane configuration, and if the person is assigned as third man the option does not appear on
    the labor side. Ehtesham suggests holding it on the **asset configuration**; Brian: *"it can be
    based on the crane."* **The asset-based trigger is a CodingCops/Brian suggestion, not Joe's
    words** — Joe settled *which crane*, not *which table*.
  - `payroll/gaps.md` §*Lattice Crane identification* — **still open**, owner Kyle and Joe via
    Brian, recording M-0805's *"requires further discussion with Kyle and Joe"*. Legacy behaviour
    (2026-08-18): the payroll app has **no lattice concept at all**; identification is a new build.
  - `payroll/codingcops-rule-matrix.md` PR-044 *Lattice-boom premium* — marked **New ERP
    requirement**, "Confirm interaction with long boom" outstanding. Corrina's 58:17 answer appears
    to settle that interaction; nothing records it.
- Note: state (c). Joe is the named person the open gap names as owner, and he answered a direct
  yes/no question. **No decision note has been written, because a transcript is not minutes** — and
  the recording is a room mic, so speaker attribution is inferred in places (see the combined entry's
  attribution caveat). A one-line "yes" on the confirmation question below is enough to write it up.
- Blocked: PR-044 in `payroll/codingcops-rule-matrix.md`; the `LPR/LPO/LPD/LPT` and `LOR/LOO/LOD/LOT`
  ADP mappings; the crane-configuration / asset field that would carry the flag.
- Owner: Joe Schacatano (stated it), with Kyle Harlow — the two named on the open gap.
- **Status:** open — needs confirmation
- **Rules:** [PAY-044](rules/PAY-044-lattice-boom-premium.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#lattice-joe-settled-it-on-the-recording-nothing-records-it](gaps-2026-08-20-retired.md#lattice-joe-settled-it-on-the-recording-nothing-records-it)
- Update 2026-09-04 (Project Repository ingest): the contract's own wording is now in the vault, and
  it is keyed neither on *crawler* nor on *every dispatch*. (a) Truck Crane MLA Article IV
  *Classifications and Wage Rates*
  ([mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md)):
  *"One Dollar ($1.00) per hour over and above the hourly wage rate for the operator for **lattice
  boom crane for Group 6 and above** and fifty cents ($0.50) per hour… for the oiler for lattice
  boom for Group 6 and above"* — restated in the Local 12 notice of 2025-08-15
  ([mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md](mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md)).
  Two things Joe's answer did not carry: the trigger is **boom type**, and it is **group-gated** —
  `L12-G6`…`G9` only, nothing for G1–G5 or apprentices
  ([adp-workbook-column-rules.md](adp-workbook-column-rules.md) → *Lattice*). The same Article's
  crew provisions (¶5) speak of *"Telescopic Boom Crawler Cranes"*, so *crawler* and *lattice* are
  not synonyms in the contract's vocabulary; *"the crawler, every time"* squares with the MLA only
  if every TCG crawler is lattice-boomed and its crew is G6 or above. (b) **Current mechanism**: the
  ADP workbook's per-row *Lattice Oper / Lattice Oiler* dropdowns are the entire trigger — a payroll
  clerk's judgement per day — feeding eight ADP codes `LPR/LPO/LPD/LPT`, `LOR/LOO/LOD/LOT` at $1.00
  / $0.50 × 1 / 1.5 / 2 / 3
  ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §3); the legacy payroll
  app computes no lattice at all. (c) Stacking: column-rules records *"whether they stack is
  unresolved"* against Corrina's 58:17 *"on top of"*; the contract lists both adders with no
  exclusion. Contract and workbook facts. **Joe's crawler-only trigger still needs the one-line
  confirmation this entry asks for — now with the G6+ gate added to the question.**

## Pay rate follows the employee, not the role worked — Kyle and Corrina, unrecorded

- Question: when an employee dispatched as an operator at $70/h is allocated to a job as a **rigger**,
  is he paid **$70** (his own rate, per Kyle and Corrina) or the **union craft rate for the rigger
  craft code on the labor entry** (per PR-007 and the legacy engine)?
- Candidates:
  - Recording **2026-08-13 "Payroll Process"**, 23:57–24:42. **Kyle Harlow**: *"Even if they fill a
    different position, we have to keep it at that rate."* **Corrina Bustos**: *"everybody is
    allocated at one base rate. So say he gets paid 70 bucks an hour as an operator and he's
    dispatched to us at that rate. Even if he goes out on a job as a rigger, he still has to be paid
    as… the $70.00."* **Brian Petros** then proposes the rule: *"any secondary must be a higher rate
    than the primary, because… that's the only time that they are paid out at a different rate is
    when it's a higher, they're working at a higher capacity, right, Corrina?"* — **Kyle: "Yes, yes.
    Correct. That would make good sense."** Effectively a floor at the employee's primary rate.
  - `payroll/erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md` PR-007 *L12 Union
    Base Rate* (note the `PR-###` ambiguity) — *"The current ERP target design is: **L12 base rate =
    union craft rate for the labor-entry CraftCode**"*, obtained by joining the labor-entry CraftCode
    to the effective-dated union craft rate. **No floor at the employee's own craft.** It also
    records that a later TCG design decision moved the target model away from `Source_Rate_Raw`.
  - `payroll/legacy-payroll-app-db-extract/rules-plain-language.md:208-218` — the engine as built
    agrees with PR-007: *"If the labor craft and the employee's craft differ, **the labor row's craft
    wins**."* So **both written sources say the opposite of the recording.**
  - **Client message 2026-06-09** (Brian Petros, payroll-group determination): *"This uses the Craft
    Code RATE in FCC on each labor entry… NOT the Craft Code on the Employee profile screen."*
    A third written source on the labor-craft side — and the earliest. Chronology now reads:
    June 9 (app behaviour, written) → Aug 13 (Kyle/Corrina describe practice as employee-rate,
    Brian proposes higher-of). Frame for the client as **app says / practice says / which rule
    ships** — see `rules/PAY-010-l12-union-base-rate.md`.
  - Same recording, 25:13–25:18 — Kyle adds that operators are **not** all on one rate (*"different
    groups… different agreements"*) and asks for an **over-scale** box on the employee profile,
    which `payroll/gaps.md` §*Confluence payroll user stories* also finds in `PAY-CC-02` AC 4–6 as
    an employee-specific additional rate on top of the craft rate. That part is corroborated.
    At 54:40–54:49 Corrina gives the counter-case that keeps this from being trivial: someone paid
    at group 9 can go out as an oiler and **qualify for oiler long boom**, or as a third man and
    **not** qualify — so the role still governs *premium eligibility* even if it does not govern the
    base rate.
- Note: state (c), and the highest-value of the eleven — it inverts rate resolution, which every
  downstream pay component multiplies. **No decision note written**: Kyle and Corrina described
  current practice rather than adjudicating PR-007, and the "secondary must be higher" rule was
  Brian's proposal with Kyle agreeing, which is a design suggestion in a working call, not a
  recorded product decision. Confirm the rule *and* whether it applies to L12 only or to all five
  payroll groups.
- Blocked: PR-007 in `payroll/erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md`;
  the ERP rate-resolution service; every premium that multiplies the base rate; the secondary
  craft-code UI demoed at 21:50 in the same call.
- Owner: Kyle Harlow (stated it) and Corrina Bustos (worked the example); Brian Petros proposed the
  higher-rate-secondary rule.
- **Status:** **resolved** — decisions/2026-08-20-craft-locked-rate-override.md
- **Rules:** [PAY-010](rules/PAY-010-l12-union-base-rate.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#pay-rate-follows-the-employee-not-the-role-worked-kyle-and-corrina-unrecorded](gaps-2026-08-20-retired.md#pay-rate-follows-the-employee-not-the-role-worked-kyle-and-corrina-unrecorded)
- **Resolution (2026-08-24 sweep):** decided on the 2026-08-20 call — day-level deviations
  **locked to craft-code amounts**, assigned only by the crane superintendent or payroll,
  via a secondary craft code for that day. Reconciles the recording (practice) with the
  engine (mechanics). Decision note written.

## Weekly payroll week statuses — two CodingCops sources, no TCG statement

- Question: what are the week statuses on the weekly payroll screen — **In Progress / Submitted /
  Processing / Received / Paid** (demoed 2026-08-13) or **In Progress / Needs Processing / Submitted
  to ADP / Closed** (`PAY-WP-04` AC 7)?
- Candidates:
  - Recording **2026-08-13 "Payroll Process"**, 30:42–33:39 — the five statuses and their meanings
    are described by **Ehtesham Anwar (CodingCops)**, demoing the screen: *Submitted* = hours sent to
    ADP; *Processing* = ADP accepted and is creating checks; *Received* = payroll has the checks but
    has not distributed them; *Paid* = checks distributed; *In Progress* = the current week, nothing
    submitted. He states the statuses **cascade** from the payroll module to each employee profile.
    The only TCG response in the passage is Corrina Bustos asking an unrelated question about open
    tickets. **No TCG person accepts or rejects the status set on the recording.**
  - `payroll/gaps.md` §*Confluence payroll user stories* — Confluence page `Payroll management`
    (page id 150110210, `PAY-WP-04` AC 7), **by Umair Khan (CodingCops)**, edited 2026-08-18,
    **unmigrated**: *In Progress, Needs Processing, Submitted to ADP, Closed*.
  - `../meetings/2026-08-05-payroll-module-design-review.md` — discusses ticket status, Edit/Override
    and send-to-Crane-Supervisor in general terms only; **does not name week statuses**.
- Note: **both sides of this pair are CodingCops artefacts** — a demo narration and an unmigrated
  Confluence page by two different CodingCops authors, six days apart. It is therefore an internal
  inconsistency rather than a recording-vs-TCG contradiction, and neither side carries TCG
  ratification. It still needs a TCG answer because the status set encodes an operational fact only
  payroll knows: whether *checks received but not distributed* is a state they need to see. Cite
  `PAY-WP-04` as **unverified Confluence**, not as the vault, per the entry above.
- Blocked: the weekly payroll screen and the per-employee week status cascade; any ERP→ADP
  submission state machine.
- Owner: Corrina Bustos (whether *Received* and *Paid* are states payroll needs); Umair Khan for
  whether the Confluence page is finished.
- **Status:** open
- **Rules:** [PAY-002](rules/PAY-002-pay-period-status-workflow.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#weekly-payroll-week-statuses-two-codingcops-sources-no-tcg-statement](gaps-2026-08-20-retired.md#weekly-payroll-week-statuses-two-codingcops-sources-no-tcg-statement)
- Update 2026-09-04 (Project Repository ingest): two legacy status vocabularies, neither of them
  either candidate set, and still no TCG statement. (a) The legacy Payroll App's `app.PayPeriod`
  ([legacy-payroll-app-db-backup-2026-06-23.md](legacy-payroll-app-db-backup-2026-06-23.md) → *Pay
  periods*) knows **`Open` and `Processed`** — 32 Sat–Fri weeks, every production week `Open`, the
  only two `Processed` rows from API smoke tests. (b) FCC's lifecycle is **Approved → Processed →
  Exported** on the labor row (`Approval`, `Processed`, `ProcessedDate` in
  `stg.FMS_LABOR_PAYROLL_Raw`; the locks in
  [fcc-nexgen-payroll-processing.md](fcc-nexgen-payroll-processing.md) §2), with no week-level state
  at all. (c) The Excel SOP calls the week-ending step *"closing out"* the payroll (ADP SOP v3.8
  §6.2) and the playbook runs **Process Payroll in ADP → Process Payroll in FCC → Handout Checks**
  ([payroll-value-engines.md](payroll-value-engines.md) §2) — so *Closed* and *checks handed out*
  are both real steps today, which is the operational fact the two candidate sets disagree on.
  System and process facts; whether payroll needs *Received* / *Paid* as ERP states is still
  Corrina's to say.
- **Update 2026-09-24 (TCG-170 audit):** still **open**. The status set is untouched (five values, `schema.prisma:206-212` and `@tcg/shared`), as TCG-170 AC1 requires until Corrina answers.
  - **What shipped.** App PR #655 (merged 2026-09-23, 0 reviews) removed the web's derived "Closed" and its hand-written status union. It also added a period-level audit of the **latest** change only: `payroll_periods.status_changed_at` / `status_changed_by_id`.
  - **Two questions nothing written answers.** Same owner:
    1. **History or latest only?** PAY-002 asks for user and timestamp on status changes. As built, once a period moves APPROVED → EXPORTED, nothing records who approved it. Is a per-transition history required?
    2. **Display.** Should the payroll screen show who changed the status and when? The web type carries the fields, but no component reads them.

## Labor Compliance module — no vault coverage

- Question: what is the Labor Compliance module, end to end?
- Candidates: [meetings/2026-08-07-labor-compliance-certified-payroll.md](../meetings/2026-08-07-labor-compliance-certified-payroll.md)
  is the **only source in the vault**. There is no FRD, no user stories, no BRS section.
- Note: the module name was **agreed in that meeting** — "Labor Compliance" chosen as the primary
  name because it encompasses Certified Payroll, Davis-Bacon and related requirements. It spans
  quotation (a compliance indicator captured at quote time), payroll (Certified Payroll reports
  generated from payroll data), and billing (processing fees, recurring compliance charges,
  Non-Performance reporting). It also has an external integration, the **LCP Tracker**, linked by
  project name.
- The stated failure mode is worth repeating: **if a job is not marked as a Labor Compliance job
  it will never appear in Certified Payroll reports.** Missed compliance reporting delays customer
  payment. That argues the flag cannot be a field added later.
- Blocked: any Labor Compliance work; also the Compliance Checklist action item on CC, which
  cannot be specified before Corrina supplies the Davis-Bacon identification criteria.
- Owner: Corrina (TCG) for the Davis-Bacon business rules and identification criteria; TCG for the
  Labor Compliance setup form and Tracking Register; CC for the checklist evaluation.
- **Status:** open
- **From (frozen original):** [gaps.md#labor-compliance-module-no-vault-coverage](../gaps.md#labor-compliance-module-no-vault-coverage)
- **2026-08-24: no longer zero coverage.** The [Certified Payroll Playbook](certified-payroll-playbook.md)
  documents the intake-to-gate business process (Sales Coordinator → Labor Compliance → NO-GO
  until reviewed), names WH-347/DIR/wage determinations, and ties to the FCC Certified Pay flag.
  Remaining open: ERP scope split (intake workflow vs report generation), the module's owner,
  and what "Ready to Schedule Value Engine" is.
- Update 2026-09-04 (Project Repository ingest): coverage is now substantial, and a business owner
  has a name. (a) The playbook's native `.docx` (Ryan, 2026-08-06) matched the photo transcription
  with no corrections, and the drop adds a sibling **Davis-Bacon & federally funded jobs** playbook,
  the **Pre-Job Labor Compliance & Payroll Information Request Form** the checklist refers to, and
  the **certified-payroll value engine** (2025-09-12) with seven numbered SOPs, a **CPR Tracker**,
  an internal weekly-labor tracker, a weekly non-performance loop and a customer-chases-us recovery
  path — [certified-payroll-playbook.md](certified-payroll-playbook.md) §10–§12 and
  [payroll-value-engines.md](payroll-value-engines.md) §3. (b) The June-2026 org chart
  ([../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md)
  → *The org charts*) has **Certified Payroll — Rose Aguilera** as a named box under HR (Corrina
  Bustos). (c) TCG's RFP puts *Safety & Compliance* in Phase 3 and names no certified-payroll system
  ([../admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md)); FCC carries `CertPay`
  per employee and per labor row plus the import template's *Certified Pay*, with the
  job-vs-employee-vs-classification collision recorded in
  [fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §8. (d) *"Ready to
  Schedule Value Engine"* is now a page:
  [../projects-jobs/scheduling/ready-to-schedule.md](../projects-jobs/scheduling/ready-to-schedule.md)
  — the sales-coordinator gate before dispatch is contacted. Client process documents, but none of
  them is an ERP scope statement. Still needs the client: the intake-vs-reporting scope split, the
  module owner (Rose or Corrina), and the Davis-Bacon identification criteria.

## Employee ↔ yard and company cardinality — the ask exists in exactly one place

- Question: may an employee be assigned to **multiple yards and multiple companies** (with a yard
  only selectable within a company the employee belongs to), or is the single default yard correct?
- Candidates:
  - Recording **2026-03-20**, transcript lines 194–197 (**unattributable — no speaker labels**):
    *"We in fcc. We are assigning each employee to like a default company and a default yard. But
    wouldn't we be able to assign them to multiple companies or multiple yards? What do you guys
    think? Like, should this be a drop down with just one?"* → *"I think you should be able to assign
    them to multiple."* → *"Right? Yeah, Multiple yards. Multiple companies. I mean, **obviously a
    yard only if they are for that company**, but multiple. Right. Okay."* **The nesting constraint
    in that last line is dropped by the Fireflies summary** and is part of the requirement.
  - Same recording, lines 157–164, on the Yards screen — the use cases: *"employee count per yard.
    Who's assigned to what yard"*, and a certification consequence attributed in-text to **Melissa**:
    *"if they have a certification that's applicable for California, but if they're also working in
    Arizona, that certification doesn't apply to that yard."* Line 164 attributes the reporting point
    to **Joe**. Both are third-person references (*"like Melissa saying"*, *"that's what Joe was
    saying"*), so they identify who said something earlier, not who is speaking.
  - `SCRUM-468` *Yard Field in Employee Creation* — **Done**, reporter Umair Khan, created
    **2026-05-25** (two months *after* the meeting). Description in full: *"Add a 'Yard' field when
    creating employees. **This will associate employees with a specific yard.**"* Singular. **No AC,
    no requester.**
  - `SCRUM-638` *Employee* (2026-07-08 punch list) item 14 lists **Yard** among single-select
    dropdowns — four months after the meeting, unchallenged.
  - **Vault: nothing.** `assets/user-story-and-tasks.md` is the only yard-management source and its
    yard content covers lease documents and a contact list only — employee is not even in its
    `entities:`. `dispatch/yard-operations-jz.md` (`conflicts_with: []`) has one employee line, :19
    *"Employee - unasisgned – weird ghost employees"*, which is a bug report, not cardinality.
- Note: **built: no; ticketed: no; written: nowhere.** `model Employee` carries a single nullable
  `yardId` with no junction table, and — worth stating plainly — **there is no company field on
  `Employee` at all**; the only company-shaped column is `tenantCompanyId`, the multi-tenancy
  discriminator. So "multiple companies" is not merely unbuilt: *single* company assignment was never
  modelled either, and the meeting's premise (FCC assigns a default company **and** a default yard)
  describes a capability the new system **reduced** rather than expanded. Unlike the Tasks pair this
  is not a reversal — it looks like an ask that never reached whoever wrote `SCRUM-468`. It is the
  cleanest contradiction of the 21 and the most expensive to fix later: a junction table plus a data
  migration. Check any answer against
  `decisions/2026-06-30-adp-erp-employee-data-ownership.md`, which assigns the legal employee record
  to ADP but says nothing about yard assignment.
- Blocked: `SCRUM-468` (Done, singular) would need reopening; employee-per-yard reporting; the
  yard-scoped certification validity Melissa raised, which has no ticket at all.
- Owner: Dylan Masterson (yard) with Brian Petros (cross-cutting/IT, for the company dimension);
  Melissa McNutt for the certification-validity consequence.
- **Status:** open
- **From (frozen original):** [gaps.md#employee-yard-and-company-cardinality-the-ask-exists-in-exactly-one-place](../gaps.md#employee-yard-and-company-cardinality-the-ask-exists-in-exactly-one-place)
- Update 2026-09-04 (Project Repository ingest): **the ask now exists in a second place, in writing,
  from TCG — but only the yard half.** (a) TCG's annotated FCC deck `FCC_MAINTAIN_EMPLOYEES
  (reviewed by TCG).pptx`
  ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §8, and the
  slide-2 *Yard association* annotation under → *The Employees window*): *"Be able to
  assign/associate Employees to each Yard… Some Employees may be working/associated with more than
  one Yard."* A written client statement, undated on the slide, for per-yard reporting — it confirms
  the 2026-03-20 recording's *multiple yards* and gives the ask an author. It says **nothing about
  multiple companies** or the yard-within-company nesting, so the second half of the question stays
  unsourced. (b) What FCC holds: one `CompanyCode` and one `YardCode` per employee
  (`tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql`); the import template requires
  exactly one *Company* and one *Yard*, each validated against the `Companies` / `Yards` sheets
  (§7); the Employees window has *Company* and *Yard* as single dropdowns. So FCC does model the
  company dimension the ERP dropped — singular — which is the premise the recording started from.
  (c) Melissa's certification-validity consequence already has an FCC shape: the Certifications
  lookup carries a **Yard Restrictions** tab — *"Any Yard Listed will not Apply to this Yard"* — so
  a certificate requirement is switched off per yard today (→ *Employee Types and Certifications
  lookups*). (d) One contract constraint for whoever models it: subsistence is measured from the
  employee's **home base** and the MLA forbids reassigning employees to a new home base to avoid it
  (Truck Crane MLA Article V —
  [mcog-l12-mla-2025-2028/03-article-v-subsistence-allowance.md](mcog-l12-mla-2025-2028/03-article-v-subsistence-allowance.md)),
  so a multi-yard employee still needs one designated home yard for pay. Client ask plus legacy
  facts, not a decision; still needs Dylan and Brian for the company dimension and the nesting rule,
  and whether `SCRUM-468` reopens.

## Employee ↔ ADP position — one person, possibly several File Numbers

- **Status:** open
- **Asked:** 2026-08-27 — Brian Petros's written message to Ehtesham & Abdul ("Regarding the IDs
  in ADP"), following the 2026-08-25 accounting call (transcript 51:19–54:47, where two IDs per
  person in ADP was first noticed). Logged in
  [client-message-findings.md](client-message-findings.md#2026-08-27--adp-identifiers-associate-id-vs-position-id-vs-file-number-brian-petros-relayed-ai-research-sender-inferred-from-the-2026-08-25-transcript-at-5447).
- **Question:** ADP keys the *person* by `associateOID` / `workerID` and the *paid position* by
  `positionID = Company Code + File Number`; one associate can hold several positions, each with
  its own File #. The paydata import posts by `Co Code + File #`. The ERP's `model Employee` has
  one nullable `adpFileNumber` and no Associate ID, Position ID or Company Code. Does the ERP need
  an `EmployeePosition` (work-assignment) table with payroll transactions resolving to a position —
  as the message proposes — or is one File # per employee an acceptable day-one constraint?
- **Candidates:** the message's proposed model (`Employee{ADPAssociateOID, ADPAssociateID}` +
  `EmployeePosition{ADPPositionID, ADPCompanyCode, ADPPayrollFileNumber, IsPrimary, effective
  dates, ADPJobCode, ADPPayGroup}`); [adp-read-write-boundary-2026-08-18.md](adp-read-write-boundary-2026-08-18.md)
  (worker.hire carries `payrollGroupCode` + `payrollFileNumber` per work assignment);
  §*Ventura — a second ADP company nobody has mentioned* (the realistic multi-position case,
  `4RZ` vs `4RY`); `decisions/2026-06-30-adp-erp-employee-data-ownership.md`.
- **Note:** the message is a *recommendation* forwarded by the client, not a signed decision —
  no `decisions/` note is written for it. Whether anyone at TCG holds two paid positions today
  is unknown and decides the cost (schema allowance vs data migration).
- **Blocked:** PAY-003 field mapping; PAY-067 export row identity; employee-module ↔ ADP sync
  design (gap §*Employee master — who creates a worker*).
- **Owner:** Brian Petros (to confirm the requirement is signed) with Corrina Bustos (whether
  multi-position employees exist in TCG's ADP); CodingCops for the schema.
- **Rules:** [PAY-003](rules/PAY-003-employee-master-import.md), [PAY-067](rules/PAY-067-adp-export.md)
- **Update 2026-09-04 (Project Repository ingest):** every incumbent system on record assumes
  **one ADP File Number per employee**, and none holds an Associate ID, Position ID or a second
  Company Code. (a) The legacy Payroll App's `app.EmployeeExternalIdentifier`
  ([legacy-payroll-app-db-extract/ddl/app.EmployeeExternalIdentifier.sql](legacy-payroll-app-db-extract/ddl/app.EmployeeExternalIdentifier.sql))
  is unique on `EmpID × ExternalSystemCode × ExternalIdentifierName` and carries two further unique
  indexes named `…_ADP_FILE_NUMBER_EmpID_Active` (on `EmpID`) and `…_Value_Active` (on the value),
  so one employee has at most one live File # and one File # belongs to at most one employee;
  `api.usp_UI_SaveEmployeeExternalIdentifier`
  ([legacy-payroll-app-db-extract/sql/api/usp_UI_SaveEmployeeExternalIdentifier.PROC.sql](legacy-payroll-app-db-extract/sql/api/usp_UI_SaveEmployeeExternalIdentifier.PROC.sql))
  hard-codes `ExternalSystemCode = 'ADP'` and `ExternalIdentifierName = 'FILE_NUMBER'`, refuses a
  value already held by another `EmpID` (error 51005), and on a change **deactivates the old row
  rather than overwriting it** — a history of File #s, never two live at once. 108 rows on
  2026-06-23 ([legacy-payroll-app-db-backup-2026-06-23.md](legacy-payroll-app-db-backup-2026-06-23.md)).
  (b) The ADP workbook keeps the same one-to-one mapping by hand: `Emp_ADP#s and SheetNames` is
  *"One row (on table below) per employee"* with a single three-digit `ADPFileNo`
  ([adp-sop-v3.8.md](adp-sop-v3.8.md) → *What the SOP's screenshots show*); the Power Query builds
  **one primary row per employee per week** and the export refuses *"missing or duplicate primary
  rows"*; the only Company Code anywhere is `4RZ` in `__hiddenParams`
  ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §2, §4, §6). (c) FCC's
  `stg.FMS_EMPLOYEES_Raw` carries `CompanyCode` (`CG` on the sampled rows) and a `PayrollNo
  varchar(15)` whose purpose no document states
  ([tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql](tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql)).
  (d) The HR ADP-setup playbook has the worker **born in ADP**, with `Company Code` entered at
  hire ([hr-onboarding-and-employee-forms.md](hr-onboarding-and-employee-forms.md) §2). These are
  facts about the incumbent systems — evidence that one File # per person is today's working
  assumption — **not a TCG decision** on the `EmployeePosition` proposal. Still needed from the
  client: whether any TCG associate holds two paid positions in ADP, and whether the 2026-08-27
  message is a signed requirement.

## Employee certifications — types and scope (per job, per unit, other)

- **Status:** open
- **Asked:** 2026-08-27 — Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros)
- **Question:** Brian wants "more details regarding requirements for Employee certifications (and
  types: per Job, per Unit, other types?)". Is a certification a property of the person (a licence
  with an expiry), a qualification to operate a *unit class* (NCCCO by crane type), or a
  requirement a *job* imposes on whoever is assigned (site-specific badges)? Each implies a
  different table and a different validation point (assignment vs dispatch vs payroll).
- **Candidates:** the annotated migration brief, [meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md) — FCC `FMS_CERTIFICATES` (14 catalog rows, "Need discussion with TCG Team"; has don't-prompt-expiry + time period, `validityPeriodMonths` unfilled) and `FMS_EMP_CERTIFICATES` (446 rows, **certificate number not stored** by the seeder). The 2026-03 recording referenced in this register under *Employee yard and
  company cardinality* (Melissa: a certification may not apply at another yard — a *yard*-scoped
  validity, a fourth candidate scope); customers/gaps.md notes Certifications were once a
  customer-creation tab. Asset-side counterpart: assets → *Unit / asset certifications*.
- **Blocked:** employee-detail design; job-assignment validation; any certified-payroll linkage.
- **Owner:** TCG (Melissa McNutt for compliance, Brian Petros for the list); CodingCops to bring
  the FCC certification field inventory.
- **Update 2026-09-04 (Project Repository ingest):** the FCC certification field inventory
  CodingCops owed is now on record, and FCC's own typology has **three scopes**, not one.
  `FMS_CERTIFICATES.CertificationType` is `G` general (the person — NCCCO, DL, CPR, Medical, MSHA,
  NBIS, First Aid, Harassment, Forklift), `C` customer/location (**Bechtel Passport**, **MSHA
  Vulcan** — a badge a specific customer or site imposes) or `U` unit; the import template spells
  it out as *"Unit (U), General (G), or Customer/Location (C)"*. The catalogue also carries
  `LinkTo`, `UnitCertificateType`, `MaintEvery` / `TimePeriod` and `DontPromptExpCert`, and the
  Certifications lookup has a **Yard Restrictions** tab (*"Any Yard Listed will not Apply to this
  Yard"*) that switches a requirement off per yard — Melissa's yard-scoped validity, already in FCC
  ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §6 and
  *Employee Types and Certifications lookups (slides 11–13)*). Per employee, FCC stores
  `Certificate Numb · Issue Date · Expire Date · Link To · Certificate Type · Status` plus
  attached files with a per-file *Include in E-Documents* switch (*Certifications (slide 5)*).
  TCG's annotated deck adds two asks that are **not** certifications in FCC: **"Cranes Qualified to
  Operate"** / asset types allowed — the unit-class qualification, requested as its own block — and
  **trainings** recorded beside certificates (§8). Certifications reach the FCC profile through the
  Dispatch Assistant and are duplicated into Dropbox
  ([hr-onboarding-and-employee-forms.md](hr-onboarding-and-employee-forms.md) §3, item 8);
  unit-side compliance (annual crane certification, quad) is modelled as interval-bearing **unit
  activities**, not certificates
  ([../assets/asset-record-requested-additions.md](../assets/asset-record-requested-additions.md)).
  All of this is what the incumbent holds and what TCG annotated on it — **not a decision** on
  which scope the ERP validates, or where (assignment, dispatch, payroll). Brian's question stands;
  it can now be asked against FCC's G / C / U + yard model rather than from a blank page.

## Payroll premium catalog — configured per tenant, or constants in the engine

- **Status:** open
- **Asked:** 2026-08-27 — PR #421 review (branch `refactor/explicit-tenant-seeding`, no ticket); tcg-scrum escalation
- **Question:** Two halves, each answerable in a line. **(a) Must a premium row exist per tenant
  before payroll can run** — i.e. is the six-code catalog (`FOREMAN`, `MILITARY`, `LATTICE_OP`,
  `LATTICE_OI`, `SHIFT_2`, `SHIFT_3`) *configuration a tenant must hold*, seeded at tenant
  creation, or admin-entered like `CraftCode`? **(b) When the table is empty, is a hardcoded
  amount an acceptable fallback, or must the run fail/flag?** Today
  `apps/api/src/usecase/payroll/payroll.service.ts:424` reads the table and silently falls back to
  `?? 3 / ?? 10 / ?? 1 / ?? 0.5 / ?? 1 / ?? 1.5`, and PR #421 removes the auto-seed that used to
  guarantee the rows existed — so after that PR every tenant prices premiums from code constants
  until someone runs a script that does not yet exist.
- **Direction is sourced; the two halves above are not.** The FRD is explicit that rates of this
  kind are configuration: [erp-payroll-module-frd/01-purpose-scope-and-design-principles.md](erp-payroll-module-frd/01-purpose-scope-and-design-principles.md)
  §2.1 *"Payroll rules must not be embedded exclusively in application code"*, requiring
  effective-dated configuration tables for — among others — **shift premiums**, craft modifiers
  and craft rates, and *"a payroll rule change should normally be accomplished by updating an
  effective-dated configuration record rather than changing program code"* (Draft 0.1,
  `status: unverified`). Brian Petros says the same in his own words on 2026-08-13:
  *"as far as like the configuration table or whatnot, I think we're going to definitely need to
  have some sort of configuration table for additional premium rates"*
  (`meetings/transcripts/2026-08-13-payroll-process.md`:452, with :440–:446 asking for start/end
  effective dates on those rates; a transcript is `status: reference`, not minutes). `PAY-008`
  carries the matching **blocking** item *"Confirm configuration ownership"*. **Neither source
  says whether the catalog is per-tenant, nor what an empty table means.** Precedent, for a
  different table: `SCRUM-925` — *"No data migration, no seed. `CraftCode` starts empty; admins
  create every craft and its rates through the API."*
- **⚠️ Two of the six hardcoded fallbacks contradict the vault, and the PR makes them the live
  values.** `SHIFT_2 ?? 1` and `SHIFT_3 ?? 1.5` are wrong against four independent sources:
  [rules/PAY-036-second-shift.md](rules/PAY-036-second-shift.md) — *"seven hours worked/eight
  paid; add **$3**/hour to base"* — and [rules/PAY-037-third-shift.md](rules/PAY-037-third-shift.md)
  — *"6.5 hours worked/eight paid; add **$4**/hour"* — each corroborated by the MLA
  ([mcog-l12-mla-2025-2028/01-article-iii-working-rules.md](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)),
  the legacy engine (`legacy-payroll-app-db-extract/` rules §8) and a client screenshot showing the
  $3.00 adder inside a priced slice ((66.03 + 3.00 + 5.25) × 1.5). The 2026-08-05 minutes carry the
  same +$3.00/+$4.00. The other four constants do match the record: Foreman $3 and Military $10
  ([foreman-and-military-premiums.md](foreman-and-military-premiums.md)), lattice operator $1 and
  oiler $0.50, Group 6+ (Corrina 2026-05-18, MLA p.39 — settled four ways, see §*Lattice Crane
  identification*). This makes the fallback question urgent independently of the tenancy
  question: a silent `??` default is currently shipping two known-wrong rates.
- **Sources checked:** `payroll/INDEX.md`; `payroll/gaps.md` (this register — §*Foreman premium*,
  §*Military Base premium*, §*Premium stacking and no-pyramiding*, §*Lattice Crane
  identification*, §*The 24 decisions*); `rules/PAY-008`, `PAY-036`, `PAY-037`, `PAY-044`,
  `PAY-070`, `PAY-071`; `erp-payroll-module-frd/01`; `payroll-app-current-state/04` (*"avoid
  hard-coded branching; add/extend configuration tables"*); `adp-bucket-crosswalk.md`:114
  (*"configuration over code — persist the crosswalk in an effective-dated configuration table"*);
  `decisions/` (none on premiums); full `meetings/` sweep. **Jira: no ticket exists for the
  premium catalog** — a search of every summary and description for `premium`, `foreman`,
  `military` and `shift differential` returns nothing but one empty issue (`SCRUM-929`, summary
  `--`). The six rows and their amounts have never been specified by a ticket.
- **Blocked:** PR #421 (`refactor/explicit-tenant-seeding`) — after it, premium amounts come from
  code constants in every tenant, two of them contradicting the vault. Also blocked: the settings
  surface for premiums that `PAY-008` and FRD §2.1 imply but no ticket covers, and the
  effective-dating those rates need (union rates change every fiscal year — `PAY-008`).
- **Owner:** Brian Petros (the only recorded voice on premium rates and the one who asked for the
  configuration table), with Corrina Bustos for the shift amounts; Fouzan Shakil for whether
  premiums are per-tenant configuration or product constants.
- **Rules:** [PAY-008](rules/PAY-008-effective-dated-configuration.md), [PAY-036](rules/PAY-036-second-shift.md), [PAY-037](rules/PAY-037-third-shift.md), [PAY-044](rules/PAY-044-lattice-boom-premium.md), [PAY-070](rules/PAY-070-foreman-premium.md), [PAY-071](rules/PAY-071-military-base-premium.md)
- **Cross-link:** admin/gaps.md → *What a newly created tenant must contain*
- **Update 2026-09-04 (Project Repository ingest):** two more independent sources for the amounts,
  one for what an *unpriced* premium does in the incumbent, and nothing on tenancy. (a) The ADP
  workbook's hidden `tblCfgADPTempRates` prices `SHIFT_2` at **$3.00**, `SHIFT_3` at **$4.00**,
  `LATT_OPER` **$1.00** and `LATT_OILER` **$0.50** per ST hour (×1.5 / ×2 / ×3 for OT / DT+H2x /
  H3x), sent to ADP as separate temp-rate rows
  ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §3); Local 12's own
  2025-08-15 notice states second shift +$3.00, third shift +$4.00, lattice $1.00 / $0.50
  ([mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md](mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md)
  p.3). The `?? 1` / `?? 1.5` fallbacks now contradict every source on record. (b) On the
  fallback half: the workbook's export validation raises an **`ERROR` that blocks the CSV** for
  *"a temp-rate component that had hours but never received a rate"* (§6) — the incumbent's answer
  to a premium with no configured amount is *stop*, not *default*. A legacy-system fact, not a TCG
  decision. (c) Where the catalog lives today is split: FCC's Union Codes → `L12` holds **all six
  shift-premium cells at $0.00**
  ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) → *Union Codes —
  TCG's live L12 configuration*), so the shift adder is workbook configuration, not FCC's; and the
  workbook's premium vocabulary is a fixed token list in `__hiddenParams` (`FOREMAN`, `MILITARY`,
  `LATT_*`, `SHIFT_*`, `SUB_*`, `WTL_*`), of which **only `LATT_*` and `SHIFT_*` reach the ADP
  export** — foreman and military have no export path at all (*What the code reveals*). **Still
  needed:** whether the six-code catalog is per-tenant configuration seeded at tenant creation or
  admin-entered, and whether an empty table fails the run — neither source speaks to a
  multi-tenant product.

## Pointers — departments archive (owned by admin)

- **Status:** open
- **Asked:** 2026-08-31 — PR #422 review (branch `feat/SCRUM-648`, Path B, no ticket folder); tcg-scrum escalation
- **Question:** [STRUCTURE.md](../STRUCTURE.md):40 routes the `departments` usecase to this module, and one of the three open sub-questions turns on **employees** — whether a department may be archived while employees are still assigned to it, now that PR #422 removed the hard delete that used to block on `countEmployeesByDepartmentId`. The full entry, including whether `DELETE /departments/:code` should have gone and what an archived department may still be selected in, lives at [admin/gaps.md](../admin/gaps.md#departments--does-archive-replace-delete-outright-and-what-may-an-archived-department-still-be-used-for). Admin owns the answer: it already holds the sibling departments question (*What a newly created tenant must contain*) and owns department roles and permissions.
- **Owner:** see the owning entry.
## Employee types — FCC holds several per employee; we store one

- **Status:** open — **first half answered 2026-10-20 by Corrina Bustos** ([../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md](../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md), `verified`): one main role per person plus a can-also-fill list (*"yes to both"*). **The second half is still open:** whether `CraftRoleType` derives from the role. It was not asked. *(Was: open in full, 2026-08-31 – 2026-10-20.)*
- **Asked:** 2026-08-31 — reading `OneDrive_1_8-31-2026` into the vault
- **Question:** `FMS_EMPLOYEE_TYPE_DETAILS` is a join table — 781 rows over ~354
  employees, `EmpID` × `EmpTypeID` with a `PrimaryType` flag (EmpID 5073 is Operator
  primary, plus Driver and Rigger). The seeder extracts all of it including
  `primaryType` (`linked-seed-files.ts:302`), then `seed-all.ts:666-675` collapses it to
  one type per employee because `Employee.employeeTypeId` is a single nullable FK. So the
  secondary roles are pulled on every sync and dropped. Should TCG hold many types per
  employee with one primary, matching FCC and the UAT request for an Operator/Rigger
  multi-select? And if so, does `EmployeeType` become the single source of truth for a
  field role, with `CraftRoleType` deriving from it?
- **Sources checked:** `payroll/fcc-employee-types-and-crafts.md`, `schema.prisma`
  (`Employee`, `EmployeeType`), `fcc-seeder/src/linked-seed-files.ts`,
  `fcc-seeder/src/seed-all.ts`, `packages/shared/src/enums/index.ts`.
- **Update 2026-09-04 (Project Repository ingest):** the multi-type model is **FCC vendor policy
  and TCG live practice**, not a local accident. The import template's guidance states *"Each
  employee needs to have at least one employee type assigned as the primary employee type"* and
  *"Unlimited secondary employee types can be added to each employee profile"*; each type also
  carries a **`Dispatchable on`** attribute (`Jobs/Quotes · Work Orders · Both · None`, stored as
  `FMS_EMPLOYEE_TYPES.Type`, `B` on all 15 rows)
  ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §2). TCG's own
  annotated Maintain-Employees deck shows a real record with **five types — 3rd Man, Driver, Oiler,
  Operator (Primary), Rigger** — and asks, on that tab, to relate types to the asset types an
  employee may operate (*Emp Types (slide 4)*). The 2026-05-05 review extraction records the ask
  to *"clarify system roles vs work/job roles"*
  ([../erp-review-log.md](../erp-review-log.md) → *Employees, HR and permissions*). All of this
  is evidence of what FCC holds and what TCG asked for; **no TCG decision** says the ERP adopts
  many-types-with-primary, and nothing addresses the second half — whether `EmployeeType` becomes
  the source of truth that `CraftRoleType` derives from. Still needs the client.

- **Cross-reference 2026-09-19 (UAT register):** two UAT 6 rows — *"Primary craft code should match the employee type"* and
  *"Option to change craft code in DAS"* — depend on the second half of this entry (whether `EmployeeType` is the source of truth
  a craft code derives from), but ask a **behaviour** question rather than a data-model one. Logged separately at
  [*Primary craft code constrained to the employee type, and changing a craft code in DAS*](#primary-craft-code-constrained-to-the-employee-type-and-changing-a-craft-code-in-das)
  so the DAS half is not lost inside this one. **Answer this entry first** — there is no employee-type→craft-code relation to
  constrain a picker by until it is answered. Also downstream of this entry:
  [../dispatch/gaps.md → *Sales Persons in the DAS Employees tab…*](../dispatch/gaps.md#sales-persons-in-the-das-employees-tab--dispatchability-is-an-employee-type-attribute-we-do-not-have),
  which needs the per-type `Dispatchable on` attribute this entry's 2026-09-04 update describes.
- **Update 2026-10-20 (Corrina Bustos, Teams, in writing — first half answered):** see
  [../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md](../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md)
  (`verified`). Asked whether each person can have *"one main role, plus a list of other positions
  they're allowed to fill"* (examples: an Operator who can also fill Oiler, Rigger or 3rd Man; an
  HDR mechanic who can also fill 3rd Man), she replied *"yes to both"*. To a later question she
  added that an HDR mechanic *"can also be called out into the field to be a 3rd man or rigger"*.
  - **Answered:** the ERP holds **one main role per employee plus a can-also-fill list** of other
    positions. That is FCC's primary-plus-secondary model, now adopted by the client.
  - **For the work that folds `EmployeeType` into `DepartmentRole`:** the list draws on the same
    role list. How it is stored is a developer decision.
  - **Also answered:** FCC's `Job Foreman` type (id 15) is **not** a role. *"Job Foreman is
    something they are picked and assigned PER job."*
  - **Still open:** the second half, whether `CraftRoleType` derives from the role. It was not
    asked. [*Primary craft code constrained to the employee type…*](#primary-craft-code-constrained-to-the-employee-type-and-changing-a-craft-code-in-das)
    still waits on it.

## Field role vs portal role — one list in FCC, three representations in TCG

- **Status:** open — **partly answered 2026-10-20 by Corrina Bustos** ([../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md](../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md), `verified`): the person's main role is their job, **and it decides what they can see**. So the field role and the portal role are one thing, which supports folding `EmployeeType` into `DepartmentRole`. **Still open:** how `CraftRoleType` relates to that role. It was not asked. *(Was: open in full, 2026-08-31 – 2026-10-20.)*
- **Asked:** 2026-08-31 — departments-and-roles discussion, plus the FCC employees report
- **Question:** FCC's `FMS_EMPLOYEE_TYPES` is one flat list mixing field roles (Operator,
  Oiler, Mechanic, Yard Man, Rigger, Driver, Shop) with portal roles (Management, Sales
  Admin, Accounting Admin, Dispatch Admin, Safety Admin). TCG has split them — but into
  *three* places, not two: `DepartmentRole` (permissions), `EmployeeType` (a name only),
  and `CraftRoleType` (payroll, and the only one carrying `THIRD_MAN`). SCRUM-914 would
  add a fourth as sub-categories under an Employee category. Which is the source of
  truth, and what do the others derive from? The DAS card colour resolver currently
  substring-matches the employee type name, so any answer that leaves that in place keeps
  mislabelling every role that is not Oiler or Apprentice as Operator.
- **Sources checked:** `payroll/fcc-employee-types-and-crafts.md`, SCRUM-914 description,
  `schema.prisma` (`DepartmentRole`, `EmployeeType`), `packages/shared/src/enums/index.ts`,
  `apps/web/src/features/das/right-section/components/employee-card.helpers.ts`.
- **Update 2026-09-04 (Project Repository ingest):** FCC does carry a field-vs-office axis — just
  not on the employee-type list. (a) `FMS_EMPLOYEE_TYPES.Type` is the vendor's **`Dispatchable
  on`** attribute (`J` jobs/quotes · `W` work orders · `B` both · `N` none — *"for example, office
  employees"*); TCG has it set to `B` on all fifteen rows, Sales Admin and Accounting Admin
  included, so the distinction exists and is unused
  ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §2 and slide 11).
  (b) The employee record itself has **`InOffice`**, `Supervisor`, a `Type` dropdown (`Scheduling &
  Maintenance` on the example), `Classification` and `Class ID` beside `Employee Type`
  ([tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql](tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql);
  *The Employees window* in the same page) — and the legacy Payroll App used `InOffice = 'Y'` as
  its office-staff exclusion
  ([legacy-payroll-app-db-extract/sql/app/v_Base_Employees.VIEW.sql](legacy-payroll-app-db-extract/sql/app/v_Base_Employees.VIEW.sql):36).
  (c) The 2026-05-05 review extraction asks to *"clarify system roles vs work/job roles — current
  'roles' appear tied to permissions rather than employee work functions"*, and Corrina's
  2026-05-04 note asks to *"add more departments to Employee Type"*
  ([../erp-review-log.md](../erp-review-log.md) §12 and *Employees, HR and permissions*). These
  are the incumbent's fields and the client's asks — evidence, **not a decision** on which of
  `DepartmentRole`, `EmployeeType`, `CraftRoleType` (or SCRUM-914's sub-categories) is the source
  of truth. Still needs the client.
- **Update 2026-10-20 (Corrina Bustos, Teams, in writing — partly answered):** see
  [../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md](../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md)
  (`verified`). The question put to her said a person's main role *"would also decide what they
  can see in the system"*. She answered *"yes to both"*.
  - **Answered:** in TCG, a person's **main role is their job and also their portal access**. There
    are not two lists. That settles `DepartmentRole` vs `EmployeeType`: they are one concept.
  - **Departments answered:** the nine departments a role belongs to are Field Operations, Shop,
    Yard, Dispatch, Sales, Accounting, Safety, HR and Management.
  - **Still open:**
    - how `CraftRoleType` relates to the role (not asked);
    - SCRUM-914's sub-categories;
    - whether the DAS card colour resolver keeps substring-matching a name.

    The `CraftRoleType` relationship is the same open half as the [*Employee types*](#employee-types--fcc-holds-several-per-employee-we-store-one) entry.

## Premium catalog CRUD — the engine reads six literal codes, not the catalog

- **Status:** open
- **Asked:** 2026-08-31 — building CRUD for payroll premium types (no ticket; the premium
  catalog has never been specified by one, per §*Payroll premium catalog* above)
- **Question:** Two consequences of the engine binding to codes rather than to the table, each
  newly reachable now that the catalog has a create/archive surface. **(a) Should archiving a
  premium stop it pricing payroll?** `PayrollRepository.listPremiums()` applies no `status`
  filter, and `PayrollService.premiumRates()` consumes that same unfiltered list — so a row
  archived through the UI keeps its amount in the next calculate, and if it were filtered out it
  would fall to the hardcoded `??` default rather than to zero. Neither "archived still pays",
  "archived pays the code default" nor "archived pays nothing" is written anywhere.
  **(b) What is a premium created under a new code supposed to do?** `premiumRates()` reads
  exactly `FOREMAN`, `MILITARY`, `LATTICE_OP`, `LATTICE_OI`, `SHIFT_2`, `SHIFT_3`; a seventh row
  is stored, listed and editable but priced by nothing. Either the create surface needs a
  constraint saying so, or the engine needs to consume the catalog generically — which is a rule
  question (what does a premium *do*: base-rate adder, on-top adder, per-day flat?), not a
  refactor.
- **Sources checked:** `payroll/INDEX.md`; this register — §*Payroll premium catalog —
  configured per tenant, or constants in the engine* (same root cause, different half: it asks
  what an **empty** table means, this asks what a **non-matching** row means); `rules/PAY-008`,
  `PAY-036`, `PAY-037`, `PAY-044`, `PAY-070`, `PAY-071`; `erp-payroll-module-frd/01` §2.1;
  `decisions/` (none on premiums). **Ticket sweep:** `SCRUM-926`'s `spec.md` and `units.md`
  mention no premium CRUD, no `PayrollPremiumType` and no premium settings screen — the list and
  amount-edit that shipped were never specified either.
- **Note:** the CRUD built on 2026-08-31 deliberately left `premiumRates()` untouched, so no
  calculated pay changes. Delete is a soft archive (`status: INACTIVE`), matching every other
  tenant reference list (craft codes, union codes, work-comp codes, billing code types).
- **Blocked:** whether the premiums settings screen can be described as "turning a premium off";
  generic premium evaluation; the effective-dating `PAY-008` wants on these rates.
- **Owner:** Brian Petros (what a premium is allowed to be), with Fouzan Shakil for whether the
  engine should consume the catalog generically.
- **Rules:** [PAY-008](rules/PAY-008-effective-dated-configuration.md), [PAY-036](rules/PAY-036-second-shift.md), [PAY-037](rules/PAY-037-third-shift.md), [PAY-044](rules/PAY-044-lattice-boom-premium.md), [PAY-070](rules/PAY-070-foreman-premium.md), [PAY-071](rules/PAY-071-military-base-premium.md)
- **Update 2026-09-04 (Project Repository ingest):** the incumbent answers (b), and half of (a),
  as practice rather than policy. (a) FCC's craft modifiers — its model for boom, lattice,
  military and similar adders — carry a per-union **`Status`** plus **`StartDate` / `EndDate`**
  ([tcg-rawfms-staging-database/ddl/stg.FMS_UNION_CRAFT_MODIFIER_Raw.sql](tcg-rawfms-staging-database/ddl/stg.FMS_UNION_CRAFT_MODIFIER_Raw.sql);
  all 52 rows active, effective 2020-04 with no end date —
  [tcg-rawfms-staging-database/data/fcc-craft-modifiers-full-master.md](tcg-rawfms-staging-database/data/fcc-craft-modifiers-full-master.md)),
  so "archive" in FCC is inactive-per-union and effective-dated; what FCC pays for a labor row
  whose modifier has since been inactivated is stated nowhere. (b) The ADP workbook's premium set
  is a **closed token vocabulary** in `__hiddenParams`, expanded through a fixed
  `tblCfgADPTempRates` (token × bucket → ADP code + rate) and a fixed 20-slot code map; a token
  the table does not price is not silently defaulted — the export validation raises an **`ERROR`**
  for *"a temp-rate component that had hours but never received a rate"* and for *"missing or
  invalid temp-rate codes"*, and the CSV cannot be written
  ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §3, §4, §6). In the
  incumbent, a premium the engine does not know **blocks payroll** rather than pricing at zero or
  at a default. The same page shows `FOREMAN` and `MILITARY` are tokens the sheets accept but that
  never reach ADP — the workbook already lives with "stored, editable, priced by nothing" codes.
  Legacy-system facts, **not a TCG decision** on what an archived or a seventh premium should do
  in the ERP. Still needs Brian (what a premium may be) and Fouzan (generic evaluation).

## L12 holiday list — the engine is missing "Day After Independence Day"

- Question: does I.U.O.E. Local 12 recognise **ten** paid holidays or **nine**? Quote OM-35140's
  terms name ten; the legacy engine's holiday dimension carries nine per year and has **no row for
  Day After Independence Day in any year**. If ten is right, every 5 July since the engine was
  built has been paid and billed at straight/overtime instead of triple-time.
- Candidates:
  - [quotations/quote-terms-and-rate-card.md](../quotations/quote-terms-and-rate-card.md) §5, from
    [assets/2026-08-31_quote-OM-35140.pdf](../quotations/assets/2026-08-31_quote-OM-35140.pdf) p.2 —
    *"New Year's Day - Presidents' Day - Memorial Day - Independence Day-Day After Independence Day
    - Labor Day - Veterans Day - Thanksgiving Day - Day After Thanksgiving - Christmas Day"*. **Ten.**
    A customer-facing contractual document, supplied by Melissa McNutt 2026-08-31.
  - `legacy-payroll-app-db-extract/config-values.md:165-194` (`dim.LU12_Holiday`) — **nine** per
    year, at `3.00` multiplier, consistently across 2025, 2026, 2027 and 2028: New Year's,
    Presidents', Memorial, Independence, Labor, Veterans', Thanksgiving, Day after Thanksgiving,
    Christmas. The table models observed-date shifting (`Observed (Sunday Rule)`,
    `Observed (Sat Rule)`), so it is maintained — the omission is not staleness of the whole table.
    `grep -ri "day after independence"` over the entire vault returns nothing.
- Note: the two lists agree on nine names and differ by exactly one. Do **not** assume the quote is
  right because it is newer — it is a sales document and the engine is what actually paid people.
  Either the quote over-promises the customer a triple-time day, or the engine has under-paid a
  holiday for years. Both are worth knowing before the ERP inherits either list.
- Blocked: the payroll holiday calendar, the triple-time rule, and whatever quoting uses to price
  holiday work.
- Owner: Corrina Bustos (payroll) to confirm what is actually paid on 5 July; Melissa McNutt owns
  the quote terms.
- **Status:** open — needs confirmation
- **Asked:** 2026-09-01 — processing the quote and e-ticket Melissa supplied 2026-08-31.

## Union general membership meeting days — the quote contradicts itself, twice

- Question: are the two I.U.O.E. Local 12 general membership meeting days **triple-time or
  double-time**, and are they in the ERP's holiday calendar at all?
- Candidates:
  - Quote OM-35140 p.2, **Triple-time Charges** — *"Work performed on any of the holidays listed
    below… **Including general membership meeting days (Union Holidays) per I.U.O.E.**"*
  - Quote OM-35140 p.2, the very next paragraph — *"If any work is performed on the (1st) Saturday
    following the (1st) Friday in the months of June and December then **Double-time** rates shall
    apply and crew shall be guaranteed no less than (8) hours"*. **The same document, two
    paragraphs apart, prices the same days at 3× and 2×.**
  - `legacy-payroll-app-db-extract/config-values.md` `dim.LU12_Holiday` — these days are **absent**;
    the table holds only the nine named calendar holidays. So the engine treats them as ordinary
    Saturdays (overtime), matching neither reading.
  - `mcog-l12-mla-2025-2028/04-articles-vi-to-xv-funds-and-contributions.md:37` mentions
    *"Semi-Annual Membership Meeting or a special called General Membership Meeting"* — but only in
    the context of amending fund contributions. **The MLA extract we hold says nothing about pay
    rates on those days.**
- Note: three sources, three answers (3× / 2× / not a holiday). The 8-hour guarantee appears in the
  double-time paragraph only. The date rule itself — first Saturday following the first Friday in
  June and December — is unambiguous and worth capturing regardless of which multiplier wins.
- Blocked: holiday calendar seeding, the triple-time rule, holiday guarantee hours.
- Owner: Corrina Bustos; Melissa McNutt for the quote wording, which needs fixing either way.
- **Status:** open — needs confirmation
- **Asked:** 2026-09-01 — processing the quote Melissa supplied 2026-08-31.

## Missed meal period — three documents, three different charges

- Question: when a crew works through a required meal period, what exactly is billed — **crew time
  only, or crew time plus equipment**? And at what rate?
- Candidates:
  - Quote OM-35140 p.3 **Meal Periods** — *"customer will be charged one-half (1/2) hour of Crew
    time Double-time **at the rate $270/hour per crew member** for every missed meal period."*
    Crew only, named rate. Note $270 is not twice the $150 Crew & Standby rate quoted on the same
    page, so it is an independent figure, not a derived one.
  - **LEM ticket Terms and Conditions of Contract (CA) §15**, supplied by Melissa 2026-08-31 —
    *"If meal periods are worked then customer will be charged one-half (1/2) hour of Crew time
    Double-time."* Crew only, **no rate, no equipment**.
  - **E-ticket 45954, Work Through Lunch Authorization** (the one the customer actually signs on
    the job) — *"customer will be charged one-half (1/2) hour of Crew time Double-time **& one-half
    (1/2) hour for all cranes and equipment**."* **Adds an equipment charge the other two omit.**
    See [field-ops/e-ticket-worked-example.md](../field-ops/e-ticket-worked-example.md) §6.
- Note: the document the **customer signs in the field** is the most expensive of the three, and it
  is the only one that charges equipment. That is the version with a signature against it, which
  makes it the strongest contractually and the one billing should probably follow — but the quote
  is what the customer agreed to at order time, and it says something narrower. This is a billing
  question with a payroll shadow: the WTL adjustment on the pay side
  ([PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md)) is separate and is **not** what is
  in dispute here.
- Blocked: WTL billing on quotations/invoices; the printed text of the WTL authorization the ERP
  will render for signature.
- Owner: Melissa McNutt (owns the quote and LEM T&Cs); Corrina Bustos to confirm what is invoiced.
- **Status:** open — needs confirmation
- **Asked:** 2026-09-01 — processing the quote and e-ticket Melissa supplied 2026-08-31.

## Boom pay rates cannot hold a second union — and the failure is silent

- **Status:** open — **remainder only: the multi-union boom shape** (see *Open remainder* at the end of this entry). The union link and the one-union-per-company limit are **resolved** — see [../decisions/2026-09-25-boom-adders-single-union-per-company.md](../decisions/2026-09-25-boom-adders-single-union-per-company.md) (`status: reference` — Brian Petros / Corrina Bustos to ratify). *(Was: open in full, 2026-09-01 – 2026-09-25.)*
- **Asked:** 2026-09-01 — reviewing the craft-modifier configuration screen while setting up a
  fresh tenant. Not a ticket question: no ticket asks for a second union, and the defect only
  appears when one is added.
- **Question:** `CraftModifier` (the boom pay rate brackets) is scoped to the **tenant**, not to
  a union code. If TCG ever bargains with a second local whose long-boom schedule differs from
  L12's $0.75-per-20-ft, there is nowhere to put the second set of numbers. Should the model
  carry a nullable `unionCodeId` — null meaning "any union", so existing rows keep working —
  or is one boom schedule per tenant a deliberate simplification we are content to keep?
- **Why it matters more than it looks:** the two failure modes are both quiet.
  **At configuration**, the overlap guard blocks the second set with a message about data entry
  rather than modelling: *"That range overlaps existing brackets: OP-BP-06 (181-200 ft). Remove
  them first…"* — `findOverlapping`
  (`apps/api/src/service/craft-modifiers/craft-modifiers.repository.ts:55-71`) filters on
  `tenantCompanyId` + `status: ACTIVE` with **no union term**, so the guard that is correct for
  one union is exactly what prevents a second. The only way past it is deactivating the first
  union's brackets, which breaks that union.
  **At calculation**, nothing errors at all.
  `CraftRateResolverService.resolveBoomAdder` (`apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts:210-230`)
  takes `unionKind` (`UNION` / `NON_UNION`) but **never the union's identity**, and fetches
  `craftModifiers.findAll(scope)` where scope is the tenant. A second local's operator resolves
  cleanly against the first local's bracket and is paid a confident, wrong number. `ResolvedRate`
  carries `unionKind` but not which union's table the adder came from, so the ledger line cannot
  show it either. Silent wrong pay under a collective bargaining agreement.
- **Sources checked:** `apps/api/prisma/schema.prisma` `model CraftModifier` — columns are
  `code, label, minFt, maxFt, operatorAdder, oilerAdder, status` plus audit; the only constraint
  is `@@unique([tenantCompanyId, code])`, no `unionCodeId` anywhere. The two code sites above.
  **FCC already models this correctly** — `FMS_UNION_CRAFT_MODIFIER` carries a `UnionCode`
  column (every row `L12`), so `fcc-seeder`'s `resolveCraftModifierBrackets` is dropping
  information the source already holds. `mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md`
  → *Additional rate for high booms* is one agreement's schedule and says nothing about others.
  No `decisions/` note covers per-union boom rates.
- **Not urgent, deliberately:** `FMS_UNION_MASTER` has exactly one row and TCG bargains with one
  local, so this is theoretical today. Logged because the trigger — someone adding a second union
  code — is invisible: nothing in the schema or the UI warns that doing so makes boom pay wrong.
- **Owner:** product, with payroll. A schema question, not a payroll-rules question.
- **Related:** the same screen gives no hint that boom rates apply to **union crafts only** —
  `resolveBoomAdder` returns no adder when `unionKind !== 'UNION'`, which is correct and matches
  the legacy rule (*"the labor row's craft is a union craft (`L12…`)"*), but a tenant with both
  `L12` and `NON-UNION` codes would reasonably expect the brackets to cover everyone. That one is
  copy, not schema.
- **Update 2026-09-04 (Project Repository ingest):** the staging database confirms the FCC shape
  exactly, and the client has asked for multiple unions in writing. `stg.FMS_UNION_CRAFT_MODIFIER_Raw`
  is keyed `UnionCraftModifierID` with **`UnionCode`**, `CraftModifierCode`, `PayRateChange` /
  `…OT` / `…DB`, `Status`, `StartDate`, `EndDate`
  ([tcg-rawfms-staging-database/ddl/stg.FMS_UNION_CRAFT_MODIFIER_Raw.sql](tcg-rawfms-staging-database/ddl/stg.FMS_UNION_CRAFT_MODIFIER_Raw.sql)):
  the bracket master (`FMS_CRAFT_MODIFIER`, 52 codes) is union-neutral and the **money is per
  union**, all 52 rate rows `L12`
  ([tcg-rawfms-staging-database/data/fcc-craft-modifiers-full-master.md](tcg-rawfms-staging-database/data/fcc-craft-modifiers-full-master.md));
  `FMS_UNION_CRAFT` (base rates) is keyed the same way. TCG's annotated Maintain-Employees deck
  states the requirement — *"We currently only work with one Union; however, need the ability to
  have multiple Labor Unions"* — and FCC's Employees → Unions tab already allows several unions
  per employee with a primary
  ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §8 and *Unions
  (slide 9)*). So "one boom schedule per tenant" contradicts both the source system's model and a
  written client ask — but the ask is about unions generally: **no source says a second local's
  boom schedule must differ, and no decision scopes `CraftModifier` to a union.** Still needs
  product to accept the `unionCodeId` (or equivalent) shape.
- **Update 2026-09-17 (Brian Petros, written note after the 2026-09-15 demo):** Brian asked
  whether craft codes and craft modifier codes are tied to a union, and said they should be,
  *"for when/if there is more than one Union"*. Craft codes already are (`CraftCode.unionCodeId`
  is required); craft modifiers are not. CodingCops' drafted reply (Syed Haris, 2026-09-17) says
  *"we will add the union link on the modifiers"*. **[Date corrected 2026-09-25:** the reply is
  dated **2026-09-16 19:09 PKT** in the stored note (section header, line 261 of the file linked
  below); 2026-09-17 was when it was logged here, not when it was sent.**]** That is a commitment in a reply, not a
  decision note: once Brian confirms in writing, `tcg-scrum` records the decision and this entry
  closes. The note itself is stored at [crew-assignment-and-rate-derivation-brian-2026-09-16.md](crew-assignment-and-rate-derivation-brian-2026-09-16.md).

- **Update 2026-09-19 (UAT register) — UAT 6 raised the same thing independently, two days before Brian's note was logged here.**
  [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Craft modifiers need a union attached*, from the
  **17 Sep internal UAT** session: *"No way to associate a union with a craft modifier."*
  That is this entry, reached from a different direction — Brian Petros asked for it in writing after the 2026-09-15 demo
  (*"for when/if there is more than one Union"*), and the 17 Sep session surfaced it again from the screen.
  **No new entry opened; this one covers it.** What the second raising adds is corroboration, not a new question: the ask is now
  on record from **two independent sources**, one of them a named TCG person. It does not change the status. The commitment in
  CodingCops' drafted reply (*"we will add the union link on the modifiers"*) is still a reply, not a decision note, and this entry
  still closes only when Brian confirms in writing and `tcg-scrum` records it.
  **⚠️ Register caveat:** this is one of the **38 UAT 6 rows**, which the register entered as NOT DONE *without checking the code* —
  their status is **assumed**. So the row is evidence that it was **asked**, not evidence that it is still **unbuilt**; the modelling
  answer above is what actually settles that. A UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md).
  Adjacent row from the same session, deliberately **not** folded in: *Remove the add-row control from the top* on the craft-modifier
  screen is UI chrome on the same page, not this question.

- **Update 2026-09-24 (TCG-140 audit): built before it was confirmed. Still open.**
  - **What was built.** App PR #660 (`feat/craft-modifier-union-link`, merged 2026-09-24 with 0 reviews, body marked *"DO NOT MERGE"*) built the **FCC split** (union-neutral brackets plus a `CraftModifierRate` row per union), not a `unionCodeId` on each bracket. It also added `payroll_job_days.boom_union_code`. Brian Petros has **not** confirmed in writing, so this entry still closes only on his confirmation and `tcg-scrum`'s decision note. If he picks a union id on each bracket instead, #660's migration has to be reworked.
  - **Mobile regression from #660**, fixed in app PR #665 (open). Mobile read `/craft-modifiers` without a union, and the API now returns null flat adders in that case, so the Labor step lost its `(+$x/hr)` suffix. #665 prices each crew card from that member's own local.
  - **Questions nothing written answers**, all for the same owners:
    1. **Migration default.** The #660 migration assigned every existing tenant's adders to one union: local 12 first, else a code starting `L12`, else the oldest union code. Nobody has confirmed that choice. Record it with Brian's shape decision.
       **→ Answered 2026-09-25 (clause 2):** not "Local 12 first" — existing adders belong to the ACTIVE `UNION`-kind code referenced by the most union craft codes; a follow-up data migration moves them. (The default seed creates `UNION`, not `L12`, so #660's ranking could strand the adders.)
    2. **Ledger display.** `boomUnionCode` is saved per job day, but no requirement says whether the ledger or review screen shows which union's table priced the adder.
       **→ Answered 2026-09-25 (clause 4):** the payroll review screen shows it, from `payroll_job_days.boom_union_code`.
    3. **Approval blocking.** Should the resolver's `NO_UNION_MODIFIER_RATE` (a union has not priced this bracket) block approval under PAY-065? See TCG-164; owner Corrina Bustos.
       **→ Answered 2026-09-25 (clause 3):** no — a review flag, not an approval block; removed from the default seed and from any tenant it was seeded into. Corrina Bustos to ratify.
    4. **Mixed-union crew on mobile.** #665 shows each member their own local's adder. That is consistent with payroll, but the UX is not written anywhere.
       **→ Answered 2026-09-25 (clause 4):** keep #665's per-member behaviour; with one union per company it shows the same figure for everyone. (#665 merged 2026-09-24.)

- **Resolution 2026-09-25 (partial):** Syed Haris (CodingCops), [../decisions/2026-09-25-boom-adders-single-union-per-company.md](../decisions/2026-09-25-boom-adders-single-union-per-company.md) (`status: reference`):
  1. **One union only.** Keep #660's structure (union-neutral brackets + a `CraftModifierRate` per (bracket, union)), but a company's boom adders may belong to **one** union code; the API refuses to price brackets for a second union while another already has adders. This is the union link Brian Petros asked for on 2026-09-16, with multi-union deferred — the *"a union id on each bracket"* alternative is not taken, so #660's migration does not need reworking for shape.
  2. **Existing data** → the ACTIVE `UNION`-kind code most union crafts reference (follow-up data migration).
  3. **`RATE_NO_UNION_MODIFIER_RATE`** is a review flag, not a PAY-065 approval block.
  4. **Review screen** shows `boom_union_code`; mobile keeps #665.
  The silent-failure concern in the original question is closed by clause 1 for as long as the limit holds: a second union cannot receive adders, so it cannot be priced from the first union's table.
- **Open remainder (still open, not decided by the note above):** when TCG signs a second labour agreement, does its boom schedule differ in **ft brackets**, in **amounts only**, or not at all? CodingCops' 2026-09-16 reply predicted *"its own brackets and amounts"*; nothing written from TCG says so, and no meeting has discussed boom pay per union. The answer decides whether lifting clause 1 is only removing the API guard (amounts only — the current table already supports it) or also scoping brackets to a union. **Owner:** Brian Petros, with Corrina Bustos. **Not urgent** — one union today (`FMS_UNION_MASTER` one row; ADP one code, `L12`). Effective-dating of boom adders is separate and stays with TCG-168.

## A labor-entry edit can reprice an approved week — and the ERP has no path for it

- Update 2026-09-07: the client's own answer, in code — the 2026-09-07 backup
  ([legacy-payroll-app-db-backup-2026-09-07/INDEX.md](legacy-payroll-app-db-backup-2026-09-07/INDEX.md) §5): interactive recalculation is an **exact Saturday–Friday week**, the prior
  week is **read-only context**, and the run is **blocked** when a prior-week calculation is stale
  against its source row or a prior-week eligible entry has no calculation (`@RequireFreshPriorContext`).
  Nothing reprices an earlier week silently; it refuses. Still no retro-delta path on their side either.

- **Status:** open
- **Asked:** 2026-09-04 — Brian Petros, Teams message to ehtesham.anwar on payroll-rule lookback
  windows; logged in [client-message-findings.md](client-message-findings.md#2026-09-04--rule-lookback-windows-and-recalculation-across-an-approved-week-brian-petros--ehteshamanwar)
  as questions (25)–(28). **Rules:** PAY-068, PAY-066, PAY-002; window half touches PAY-026,
  PAY-045, PAY-046.
- **Question:** payroll rules read *surrounding* labor entries, so an edit to one entry changes
  the result of others — *"there could be no change to the data of that individual labor entry,
  and yet the surrounding labor entries impact its calculated results"* — including entries in a
  week already processed, approved and closed. His example: a 48-hour entry whose end falls at the
  very start of a payroll week, or whose start falls at the very end. **When that happens, does
  the ERP reopen the period, post a delta adjustment into the current period, or refuse — and who
  is allowed to trigger it?** Both the automatic case (a recalculation reaches backwards on its
  own) and the manual case (payroll deliberately amends a closed week) need an answer.
- **Built state, verified:** the ERP currently **refuses**. `PayrollPeriodStatus` is
  `OPEN · CALCULATED · REVIEW · APPROVED · EXPORTED` (`apps/api/prisma/schema.prisma:200-206`) —
  **no `CLOSED`, no `REOPENED`**, against the seven PAY-002 names — and
  `apps/api/src/usecase/payroll/payroll.service.ts:139-148` throws
  *"Cannot recalculate a period that is already approved/exported"*, citing PAY-066. Recalculation
  is manual-only and never fires on a ticket edit (SCRUM-921 AC5). So a change that ought to
  reprice a closed week silently does not, and there is no delta path. **This is a specification
  hole, not a defect** — PAY-068's blocking item is *"Confirm correction workflow"* and PAY-066's
  is *"Confirm reopen/correction policy"*, both unanswered since 2026-08-24.
- **The second half — the calculate window.** `payroll.service.ts:151-155` selects
  `findCompleteTicketsInRange(weekStart, weekEnd + 1 day)`: the period and nothing else. The
  legacy engine deliberately reaches outside it — **4 days back and 4 days forward** for WTL
  meal-period groups, **7 days back** for the rest period (Brian's summary card; he calls both
  overshoot). Ehtesham's narrower reading is right for the *rule* — 8-hour rest looks back 8 hours
  — but the ERP must still be able to *see* the prior day to apply it. **Not currently wrong by
  luck:** the three rules that need cross-boundary data — PAY-026 seventh consecutive day,
  PAY-045 rest period, PAY-046 meal opportunity — are not implemented in
  `packages/payroll-engine/src`. The day any of them is, this window is a bug.
- **Sources checked:** [rules/PAY-068](rules/PAY-068-retroactive-correction.md),
  [PAY-066](rules/PAY-066-payroll-snapshot.md), [PAY-002](rules/PAY-002-pay-period-status-workflow.md),
  [PAY-045](rules/PAY-045-rest-period-premium.md) (8-hour gap, 30-minute stitch — a rule window,
  not a selection window), [PAY-026](rules/PAY-026-seventh-consecutive-day.md),
  [PAY-046](rules/PAY-046-meal-opportunity.md), [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md);
  the engine's implemented-rule set; `decisions/` holds no note on reopen, close or retroactive
  correction.
- **Blocked:** any close/reopen UI; the ADP re-export story for an amended week; and the decision
  on whether the calculate window widens — all three are the same question asked at different
  layers.
- **Owner:** TCG payroll (Brian Petros, Corrina for practice) for the correction policy;
  CodingCops for the window. Brian has offered to walk through it in a meeting — that meeting is
  where PAY-068 and PAY-066 close.
- **Update 2026-09-04 (Project Repository ingest):** four sources now bear on the correction
  question; none is a decision. (a) **The first written answer**: the client-side
  [payroll-rule-dependency-matrix.md](payroll-rule-dependency-matrix.md) §13 (author inferred
  from voice, unsigned, `unverified`) says — *open* period after a correction: automatically
  invalidate and recalculate every impacted group and *"return the period to the appropriate
  review state"*; *closed* period: *"Do not rewrite posted history. Preserve the closed result.
  Recalculate the corrected result separately, compare Posted vs Corrected by component, and
  generate the difference as a retro/payroll-adjustment transaction for approval and a future or
  off-cycle payroll"*; a rate-table change touching a closed period uses the same retro
  mechanism; a snapshot of source ids, classification, rates and rule versions is retained at
  close. It does not say who may trigger any of it. (b) **What TCG lives with now**: FCC locks in
  three stages — after *Processed*, *"business rules will need to be applied manually"*; after
  *Exported*, *"a labor entry cannot be modified in any way"* and management follows an
  undisclosed post-export procedure; a new entry against an exported period is **refused**
  ([fcc-nexgen-payroll-processing.md](fcc-nexgen-payroll-processing.md) §2). (c) **A retro path
  exists in practice**: the payroll playbook chart ends its dispute branch in *Update Payroll
  Excel & in FCC → Process Retro Check through ADP → Email Accounting Check Info* (SOP #8–#9),
  without saying how the retro amount is computed
  ([payroll-value-engines.md](payroll-value-engines.md) §2). (d) **The automatic case, in the
  legacy app**: `cfg.Nightly_RunSettings.LookbackDays = 210` — the nightly re-prices the trailing
  30 weeks every night by design, so a backward-reaching recalculation was the norm there; but
  **no production pay period was ever processed** (32 periods, all `Open` bar two API smoke
  tests), so the app never met a closed week
  ([legacy-payroll-app-db-backup-2026-06-23.md](legacy-payroll-app-db-backup-2026-06-23.md)); its
  role model gives `canRefreshFromNexGen` to `payroll_manager` and `it_admin` only, and
  `/payroll/process` has no UI route
  ([legacy-payroll-app-source-tree-2026-06-10.md](legacy-payroll-app-source-tree-2026-06-10.md)).
  (a) is a recommendation; (b)–(d) are facts about the incumbent. **Still needed:** someone with
  authority to accept the immutable-close + retro-delta policy, and the trigger/permission rule —
  the meeting Brian offered.
- **Update 2026-10-07: Melissa McNutt's provisional answers. Not a policy.**
  - In written Teams answers posted on or before 2026-10-06
    ([../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md),
    `reference`, T7), on a ticket already approved, invoiced or processed for payroll:
    - *"They will need to submit a edit request to their manager or payroll."*
    - *"It will need to have approval."*
    - Asked whether a change after billing or accounting has processed it should *"trigger a
      re-approval or update"*: *"yes!"*.
    - Also: *"Payroll will need the ability to edit at all times."*
  - This names **who approves**: a manager or payroll. It does not say **how** a closed week
    absorbs the change: reopen and re-approve the posted week, or keep it immutable and post a retro
    adjustment (dependency matrix §13, unverified).
  - TCG asked to hold the answers until an updated version is sent.
  - The trigger and permission half of this entry has a candidate answer to put to Brian and
    Corrina. The policy half is unchanged.

## The union-classified employee who must not be paid on union rules

- **Status:** open
- **Asked:** 2026-09-01 — Brian Petros, in the accounting/onboarding call
  ([meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md](../meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md) §4;
  transcript 32:49–34:30). **Rules:** PAY-009, and it is a concrete instance of
  *Payroll rule applicability by Payroll Group* above.
- **Question:** TCG has at least one live employee who is **union by classification but must not
  be processed on union rules** — hourly, and admin/management. Brian walked the three obvious
  selectors and showed each one fails: *"all labor union employees"* catches him; *"exclude admin"*
  drops legitimate field staff; *"hourly only"* does not separate him either. Corrina recalls Kyle
  being told a **special classification** would exist for cases like this. **Brian's preference is
  the opposite of a special case:** *"instead of having those special classification types, I'd
  like to be able to handle it with the initial setup of employees based on the primary class."*
  So: does the ERP add an escape-hatch classification, or is the group predicate rebuilt so the
  primary class alone decides? And how many such outliers exist — one, or a category?
- **Sources checked:** [rules/PAY-009](rules/PAY-009-payroll-group-classification.md) — the
  2026-06-09 client message gives the five groups' exact predicates (`L12%` + `EmpTypeID`,
  `ADMIN%` + `PayType`, `SYS%` hidden) and **none of them expresses this case**; the group
  applicability entry above; `PayrollGroup` in `apps/api/prisma/schema.prisma:192-198` is a fixed
  five-value enum (`L12_FIELD`, `L12_MECHANIC`, `NON_UNION_HOURLY`, `NON_UNION_SALARY`, `SYS`)
  with no override field anywhere.
- **Blocked:** the final ERP mapping in PAY-009 — it cannot close while a known employee falls
  outside every predicate.
- **Owner:** Corrina Bustos and Brian Petros for how many, and which policy; CodingCops for the
  model once told.
- **Update 2026-09-04 (Project Repository ingest):** the legacy Payroll App already carried
  **three escape hatches** for exactly this case, and one of them is an FCC field the three
  selectors Brian walked did not use. `api.tvf_Employees_Active_FieldOnly_ForPayPeriodDate`
  ([legacy-payroll-app-db-extract/sql/api/tvf_Employees_Active_FieldOnly_ForPayPeriodDate.TVF.sql](legacy-payroll-app-db-extract/sql/api/tvf_Employees_Active_FieldOnly_ForPayPeriodDate.TVF.sql):22-30)
  takes the L12 population (`UnionCode = 'L12'` or craft `L12-%` / `HDR-%`) and then removes
  (1) any `EmpID` in `cfg.PayrollUI_ExcludedEmpID` — a per-employee exclusion table with a
  `Reason` column, holding two test/system users on 2026-06-23
  ([legacy-payroll-app-db-extract/config-values.md](legacy-payroll-app-db-extract/config-values.md));
  (2) craft `ADMIN-A`; (3) **FCC's `InOffice = 'Y'`**, surfaced as `Is_OfficeStaff` by
  [legacy-payroll-app-db-extract/sql/app/v_Base_Employees.VIEW.sql](legacy-payroll-app-db-extract/sql/app/v_Base_Employees.VIEW.sql):36.
  `InOffice` is a column of `stg.FMS_EMPLOYEES_Raw` (`N` on the sampled field rows), and the same
  record carries `Supervisor`, `Classification` and a `Type` dropdown (`Scheduling & Maintenance`
  on the deck's example)
  ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) → *The
  Employees window*). The ADP workbook handles the case by hand instead: the FCC roster pulls
  every craft-coded employee, salary included, and union processing happens only for rows the
  clerk gives a `SheetName` ([adp-sop-v3.8.md](adp-sop-v3.8.md) → *Emp_ADP#s and SheetNames*;
  [adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §1). Legacy-system
  facts — they show a union-classified office employee has been kept off union rules by an
  employee-level flag or an exclusion list, **not** by the primary class alone, which is the
  opposite of Brian's stated preference. **Still needed:** the policy (flag, list, or primary
  class) and the head-count of outliers.

## Premiums are attached to employees; they belong to the job

- **Status:** open
- **Asked:** 2026-09-02 — Brian Petros in the sprint demo, with Joe Schacatano supplying the
  trigger rules ([meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) §3;
  transcript 43:35–45:08). **Rules:** PAY-043, PAY-044, PAY-071, PAY-070.
- **Question:** the demoed premium configuration reads as **per employee** — *"anything that
  employee did, it would be added"* — and Brian's correction is that lattice, military and shift
  adders are properties of **the job**: *"it needs to be at the job level."* Joe then gave the
  triggers he expects, and they are automatic, not a dispatcher prompt: **a crawler assigned to
  the job populates lattice pay**, and federal/prevailing wages populate **only when certified
  payroll or federal job is checked at the quoting stage or on the job** — explicitly *"as opposed
  to it being a pop up every time you dispatch."* Ehtesham added that some of this may also belong
  on the **customer profile**. So: what is the authoritative carrier of each premium — asset,
  job, quotation flag, customer, or employee — and which are derived rather than chosen?
- **Sources checked:** [rules/PAY-044](rules/PAY-044-lattice-boom-premium.md) — lattice already
  reads *"job flagged lattice + employee Group ≥ 6 → premium on all job hours"*, i.e. **the rule
  register already says job-level**, so the demo UI and the rule disagree;
  [PAY-043](rules/PAY-043-long-boom-premium.md) (boom-window slices, asset-derived);
  [PAY-071](rules/PAY-071-military-base-premium.md); `Quotation.certifiedPayroll` exists as a
  boolean (`schema.prisma`), which is the flag Joe describes; `PayrollPremiumType` +
  `PayrollPremiumAppliesTo` are the built catalog.
- **Blocked:** the premium-selection UI on DAS ticket send, and any spec that fixes where a
  premium is stored.
- **Owner:** Joe Schacatano for the trigger rules (he stated them; they need writing down as a
  decision), Corrina for payroll practice.
- **Update 2026-09-04 (Project Repository ingest):** the incumbent carries each premium on a
  different level, and the client's own deck states one of them. (a) **Certified pay** — FCC
  holds a `CertPay` bit on the **employee** (`stg.FMS_EMPLOYEES_Raw`, ticked on the deck's
  example), on the **job** (`stg.FMS_JOB_MASTER_Raw`) and on every **labor row**
  (`stg.FMS_LABOR_PAYROLL_Raw`), plus `UseCertifiedPayroll` per classification; TCG's annotation
  says *"Certified Pay: This should be 'Job specific'… per Job or defaulted per Job Site"* — a
  written client statement that the carrier is the job
  ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §3, §8). The
  customer packet forms ask *prevailing wage Y/N* at intake, twice
  ([../customers/new-customer-packet.md](../customers/new-customer-packet.md)). (b) **Shift and
  boom/lattice** — per **labor row** in FCC (`ShiftInfo`, `CraftModifierCode`,
  `UnionCraftModifierID` on `FMS_LABOR_PAYROLL`, with `NotifyShiftInfoChg` /
  `NotifyCraftModifierChg` flags) and a default `CraftModifierCode` on the **employee**
  ([tcg-rawfms-staging-database/ddl/stg.FMS_LABOR_PAYROLL_Raw.sql](tcg-rawfms-staging-database/ddl/stg.FMS_LABOR_PAYROLL_Raw.sql),
  [tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql](tcg-rawfms-staging-database/ddl/stg.FMS_EMPLOYEES_Raw.sql));
  the ADP workbook keys lattice and shift as **per-day dropdowns on the employee sheet**
  ([adp-sop-v3.8.md](adp-sop-v3.8.md) §6.1). No lattice, military or shift flag exists on
  `stg.FMS_JOB_MASTER_Raw`. (c) **Lattice** is contractually a property of the crane — *"lattice
  boom crane for Group 6 and above"* — which is Joe's crawler trigger in the MLA's words
  ([mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md](mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md)
  p.3). (d) **Foreman and military** have no carrier in FCC and no path to ADP in the workbook
  ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) → *What the code
  reveals*). Facts about the incumbent plus one client statement on certified pay — **not a
  decision** on the authoritative carrier per premium, and Joe's trigger rules remain unwritten.
- **Update 2026-09-09 (PR review of `fix/quotation-permits-plans`, no ticket, no `processed.log` row):** the branch **removes the job-level premium surface entirely**, leaving the DAS ticket-send modal as the only place a premium can be ticked. Commit `d30f90eaa` drops `<JobPayrollFlagsCard>` from the job detail **Main** tab (`apps/web/src/features/projects/jobs/job-details/main/job-main-tab.tsx`), and a grep of `apps/web/src` now finds exactly one render left — `features/das/middle-section/jobs/tickets/components/send-ticket-modal.tsx:145`. The **storage** is unchanged and still job-level (the modal passes `jobId={job.parentJobId}`), so this is a surface change, not a data change — but it is the surface this entry's **Blocked** line already names, and it moves the only editing point to dispatch time, which is the shape **Joe Schacatano explicitly ruled out**: federal/prevailing wages should populate from a flag checked *"at the quoting stage or on the job"*, *"as opposed to it being a pop up every time you dispatch"* ([../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) §3; transcript 43:35-45:08), and against **Brian Petros's** correction in the same session that the adders *"need to be at the job level."* The branch's stated reason is cosmetic — *"hide payroll premiums on the job Main sidebar so the panel only shows live links and schedule"*. **Not an adjudication either way**; recorded because this entry's question is now being answered by default in the build. The related quotation flag Joe named is still `Quotation.certifiedPayroll`, still `Boolean?`, and still carries the open web-type mismatch at [../quotations/gaps.md](../quotations/gaps.md#q-27--certifiedpayroll-nullable-on-api-required-in-web-types).

## Annual craft-rate change — nine codes, one rule, no bulk path

- **Status:** resolved 2026-09-07 — Corrina Bustos confirmed the rule on the 2026-09-03 call, in her own words; build committed on the same call.
- **Asked:** 2026-09-02 — Corrina Bustos in the sprint demo (§4; transcript 23:55–25:25).
  **Rules:** PAY-008, PAY-010.
- **Question:** effective-dated craft rates are built and demoed — adding a rate auto-ends the
  previous one the day before — but each of **Local 12's nine craft codes** must be edited
  individually. Corrina: *"per the union handbook, every July 1st, the rate changes… can we lump
  sum and do it to every single one?"* Ehtesham's condition is exact: buildable **if there is a
  written rule** (e.g. one group moves by an amount and the others follow by a fixed delta or
  percentage). Corrina offered to send the handbook verbiage — **it has not arrived**. So: what
  is the July-1 rule, in the handbook's own words, and does it derive the other eight codes from
  one, or are all nine independent values published each year?
- **Sources checked:** [rules/PAY-008](rules/PAY-008-effective-dated-configuration.md),
  [PAY-010](rules/PAY-010-l12-union-base-rate.md) (settled: labor-entry craft prices the row);
  `CraftCodeRate` with effective dating is built (`schema.prisma`);
  [mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md](mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md)
  carries the wage schedule but no statement of how a year's increase is distributed across groups.
- **Owner:** Corrina Bustos — the handbook verbiage is the whole answer.
- **Update 2026-09-04 (Project Repository ingest):** the handbook verbiage is now in the vault,
  read from the scans. **In the agreement's words** (MLA Article IV, *Classifications and Wage
  Rates* —
  [mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md)
  → *ARTICLE IV*): one **"Increase Effective Dates"** line over the whole classification table —
  **7-01-25 $6.00 · 7-01-26 $5.00 · 7-01-27 $4.50** — with the footnote *"The Union may elect at
  its option, upon at least sixty (60) days' written notice to allocate an increase indicated to:
  (1) Hourly Wage Rates, (2) Health and Welfare, (3) Pension, (4) Vacation-Holiday and/or
  Supplemental Dues, (5) Joint Apprenticeship and Journeyman Retraining Trust, (6) P.A.C. and
  (7) Defined Contribution Plan (Annuity)"*; apprentice rates are *"Based on Group 5 rate"* at
  60 / 65 / 70 / 75 / 80 / 90 % by hours worked. Local 12's 2025-08-15 notice then publishes the
  split — **$5.00 to wages, $1.00 to Health & Welfare** — and prints **all nine group rates**,
  every one exactly **+$5.00** on its 7-01-24 figure (61.03→66.03 … 66.16→71.16); the 2026 and
  2027 wage columns are **blank** on that notice (the 2026 one is filled by the *Revised June 2026* rate sheet — see the correction at the end of this bullet)
  ([mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md](mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md)
  pp.1–3). So nine values *are* published each year, but in the record they move by **one common
  wage allocation**, and the six apprentice steps derive from Group 5. Practice matches: FCC's
  `FMS_UNION_CRAFT` on 2026-07-01 shows every `L12-G` straight-time rate exactly **+$1.00** over
  the deck's earlier screenshot, `-B` / `-C` re-stored at 1.5× / 2×, and `APP1` = 60 % of G5
  ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §5 and *Pay
  Rates (slide 17)*); the ADP workbook carries FY26-27 as +$1.00 on every group
  ([adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §5). **Still
  needed:** Corrina's confirmation that the bulk path may be *"add the published wage allocation
  to all nine groups and recompute APP1–6 from G5"* — the contract prints nine figures and never
  says the delta is uniform — (the 2026-07-01 allocation itself **is** in the vault — the union's rate sheet *Revised June 2026*
  puts $1.00 of the $5.00 package on wages for all nine groups, 67.03 … 72.16, and leaves only the
  2027-07-01 $4.50 package unsplit: [mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md](mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md);
  the workbook and FCC both match it, so the "uniform delta" rule has now held for two consecutive
  years in the published figures — what remains is Corrina's word that the bulk path is the rule).
- Resolution (a): Corrina Bustos, 2026-09-03 call at 56:42, asked whether a rule sits behind a bulk
  update — *"Yes, because all of the groups, so groups one through 9, they always increase in the
  same dollar amount."* That is the word this entry was waiting for; the published record already
  showed the uniform delta for two consecutive years (bullets above). Decision note:
  [../decisions/2026-09-03-l12-bulk-rate-update-uniform-delta.md](../decisions/2026-09-03-l12-bulk-rate-update-uniform-delta.md).
- Resolution (b): the bulk path as agreed — one add-amount applied to every selected craft rate,
  with a **future effective date** (Brian Petros 57:21: set the rates in advance, *"so we don't have
  to be up at like 11:59 at night"*); the previous rates are auto-ended the day before the new
  effective date (Ehtesham 58:07). Apprentice steps were not discussed on the call; the "derive
  APP1–6 from G5" half of the earlier question stays as recorded, unconfirmed. Curated notes:
  [../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md](../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md) §4; transcript [../meetings/transcripts/2026-09-03-payroll-lunch-rules-and-dispatch-times.md](../meetings/transcripts/2026-09-03-payroll-lunch-rules-and-dispatch-times.md).
- Owner: answered; CodingCops to build (PAY-008 / PAY-010).
## Craft assignment has no history

- **Status:** open
- **Asked:** 2026-09-02 — Brian Petros, endorsed by Corrina Bustos (§5; transcript 25:28–26:29).
  **Rules:** PAY-003, PAY-027 (assignment), PAY-064.
- **Question:** *"at the employee level, to say okay, they were this craft code from this date to
  this date."* Corrina compares it to ADP, which records **what changed and when** automatically.
  Craft **rates** are effective-dated; a craft **assignment** to an employee is not. Does an
  employee's craft assignment become effective-dated (so a historical payroll reprices on the
  craft in force on the work date), or is a change-log audit trail enough? The two answers cost
  very different things, and only the first is safe for retroactive correction (PAY-068).
- **Sources checked:** `EmployeeCraftAssignment` in `apps/api/prisma/schema.prisma:2544` — carries
  the assignment and primary/secondary, **no effective dates**; `CraftCodeRate` does have them;
  [rules/PAY-068](rules/PAY-068-retroactive-correction.md), which needs the historical answer.
- **Owner:** Corrina Bustos / Brian Petros for the requirement; CodingCops for the model.
- **Update 2026-09-04 (Project Repository ingest):** FCC has no craft-assignment history either —
  and the client-side dependency paper asks for one. `stg.FMS_EMPLOYEES_Raw.CraftCode` is a single
  current value (stored with its `-A` suffix); none of the 40 staged tables is an employee-craft
  history ([tcg-rawfms-staging-database/INDEX.md](tcg-rawfms-staging-database/INDEX.md)). What
  FCC does keep is the craft **as used**: `CraftCode` on every labor row
  (`stg.FMS_LABOR_PAYROLL_Raw`, with a `NotifyCraftChg` flag) and on every job assignment
  (`stg.FMS_JOB_EMPLOYEES_Raw`) — which is why the legacy engine prices from the *labor row's*
  craft and finds it disagreeing with the employee's current craft on 27 % of rows
  ([legacy-payroll-app-db-extract/INDEX.md](legacy-payroll-app-db-extract/INDEX.md), finding 9).
  The union **rate** table is effective-dated in schema (`FMS_UNION_CRAFT.StartDate` / `EndDate`)
  but not consistently in data
  ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §5). The
  [payroll-rule-dependency-matrix.md](payroll-rule-dependency-matrix.md) §13 states the
  requirement outright — *"Employee classification must be effective-dated; a correction can
  change the whole rule path… Recalculate all affected dates from the classification's effective
  date"* — but it is an unsigned recommendation (`unverified`, author inferred). So the record
  holds one client-side voice for effective-dating and a source system that manages without it by
  stamping the craft on each labor row. **Not a decision**; still needs Corrina / Brian.

## Field staff are told to inflate reported hours so minimum-pay rules come out right

- **Status:** open
- **Asked:** 2026-09-02 — Brian Petros, closing the sprint demo (§8; transcript 1:01:03–1:02:05).
  **Rules:** PAY-039, PAY-040, PAY-029, PAY-062.
- **Question:** Brian states current practice plainly — in some situations employees are
  *"instructing them currently to modify their time for minimum pay hours, so they actually are
  artificially bumping up their time"* — and proposes the opposite for the ERP: the system records
  **actual** hours, the rules produce the payable result, and nobody edits the clock. *"Maybe it
  might be a shift in how we instruct the field employees to create their time."* Two things need
  deciding: **(a)** is that shift adopted, i.e. does the ERP refuse inflated actuals and pay the
  minimum as a computed component instead; **(b)** if so, what changes in the field instructions
  and in what payroll reviewers see, since a week's numbers will no longer match how the same week
  looked in FCC.
- **Why it matters beyond payroll:** actual-hours integrity is what makes GPS verification,
  overlap detection and billing-vs-payroll reconciliation meaningful. The vault already carries
  the doctrine on the *output* side — added hours exist as ledger components and `Gap_Hrs`
  columns, never as time windows (`PAY-029`) — but nothing says the *input* must be untouched.
- **Sources checked:** [rules/PAY-039](rules/PAY-039-reporting-pay-no-work.md),
  [PAY-040](rules/PAY-040-work-provided-minimum.md), [PAY-029](rules/PAY-029-overlapping-labor-detection.md)
  (phantom-hours invariant), [PAY-062](rules/PAY-062-labor-entry-detail.md); no `decisions/` note
  on time-entry integrity.
- **Owner:** TCG payroll leadership — this is a practice change, not a build option.
- **Update 2026-09-04 (Project Repository ingest):** the ingest shows *why* the practice exists,
  and that Brian's proposed direction is already how the legacy Payroll App works. The ADP
  workbook has **no guarantee or minimum-pay column**: each employee-day row is `Total Hrs · ST ·
  OT · DT · H2x · H3x` (+ lattice/shift dropdowns, boom hours, subsistence, sick), checked only by
  `Hrs_Match` (the buckets must sum to `Total Hrs`), and the component ledger the export builds
  from it has no minimum component — so a 4-hour or 8-hour minimum can reach ADP **only as keyed
  hours** ([adp-sop-v3.8.md](adp-sop-v3.8.md) §6.1;
  [adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) §3). The payroll
  playbook chart likewise has the clerk *"Separate Hours / Boom Pay & Union Rules in Payroll
  Excel"* after times are verified ([payroll-value-engines.md](payroll-value-engines.md) §2). The
  legacy Payroll App does the opposite: guarantees are computed from actuals as `Gap_Hrs`
  components (`DAILY_MIN_4`, `HOLIDAY_MIN_8`, `LONG_BOOM_MIN_4`, `SPECIAL_SAT_MIN_8`), with
  `cfg.Craft_MinimumPayPolicy` — 39 rows, set 2026-03-03 by Brian Petros, *"Admin staff: minimum
  pay does not apply (per Payroll Manager)"* — deciding which crafts they apply to
  ([legacy-payroll-app-db-extract/config-values.md](legacy-payroll-app-db-extract/config-values.md);
  [legacy-payroll-app-db-extract/INDEX.md](legacy-payroll-app-db-extract/INDEX.md)), and the
  client-side [payroll-rule-dependency-matrix.md](payroll-rule-dependency-matrix.md) §8 restates
  it: `GapHours = MAX(RequiredMinimum − QualifyingActualHours, 0)`, *"Do not give each individual
  labor entry its own four-hour minimum."* None of this is the practice decision (a) or the
  field-instruction change (b); it is evidence that the incumbent workbook *forces* the inflation
  and the successor engine already removes the need for it. **Still needs TCG payroll
  leadership.**

## Long-boom day breakdowns — drive time, cross-midnight, and the 20-hour day

- **Status:** resolved 2026-09-04 — **both questions answered by Corrina Bustos the same day.**
  See the resolution notes below. One **new** open question falls out of her holiday answer,
  registered separately below.
- **Asked:** 2026-09-04 — Corrina Bustos posted two hand-worked long-boom day breakdowns on Teams
  (one job, and two jobs in one day) *"to make sure drive time is computed"*; verified segment by
  segment against `usp_Run_Pricing_Engine` and two questions were sent back.
  **Rules:** PAY-019, PAY-021, PAY-022, PAY-023, PAY-024, PAY-033, PAY-043, PAY-046, PAY-047.
- **Question (1):** the **two-job** day runs 6:30am to 1:30am, **19 clock hours**, but the buckets
  summed to **20 paid hours** (8 ST, 4 OT, 8 DBL), the `5:30pm-6:30pm` drive line reading
  *"1 ot, 1 dbl"*. The engine gives **8 / 4 / 7**: the ST bank runs out at 2:30pm and the 12-hour
  mark lands at 6:30pm, so that hour is OT and double time starts at 6:30pm. Working hypothesis at
  the time was worked-through-lunch double time folded into the drive line.
- **Resolution (1) — Corrina, 2026-09-04:** *"Thank you for bringing the 20 hours to my attention.
  I have updated it and the extra hour was an error."* **Not WTL.** A transcription slip in the
  hand-worked example; the engine's 8 / 4 / 7 stands, and the WTL-folded-into-buckets hypothesis is
  dead. WTL premium continues to live only in the ledger (`WTL_MEAL_DEDUCT` / `WTL_APPLICABLE_ADD`),
  never inside the hour buckets.
- **Question (2):** that day's last drive crosses midnight between two weekdays, so no rate
  changes. If it ran into a Saturday, Sunday or holiday, do the hours after midnight pay at the new
  day's rate, or does the whole shift stay on the rate for the day it started? This was the parked
  **PAY-019** decision, put to the person the engine's own config note names as its owner.
- **Resolution (2) — Corrina, 2026-09-04:** *"the question would remain irrelevant if they worked
  into Saturday or Sunday due to the fact that they were already on Double time. if they were to
  work into a holiday they would be owned an additional 8 hours at triple time as the rule is that
  the ee is owed a minimum of 8 hours."* Two things settled. **(a) The higher rate governs, never a
  downgrade** — a shift already at DT does not drop to Saturday x1.5 after midnight. That is the
  as-built `CalendarDay` policy read through the no-pyramiding precedence chain (`DT` outranks
  `SATURDAY`), and it is also what the inactive `AnchorFloor` (`max`) would give. Brian's
  pure-anchor summary — *"the entire job is associated with the date in which the labor started"* —
  is the only reading her answer rules out. **(b) Spilling into a holiday is holiday work**, so the
  post-midnight slices price at x3 *and* the MLA's 8-hour holiday minimum fires: *"A minimum of
  eight (8) hours at triple (3) time... shall be paid for all work performed... on the following
  holidays"* (Article III, Holidays §1). The engine agrees: §7 groups the holiday minimum by
  **calendar day**, so slices > 0 on the holiday trigger `gap = 8 - hours worked that day` at x3.
- **What the same message settled without being asked:** the **one-job** breakdown ties to the
  engine **exactly**, segment by segment, and is the first named-human corroboration of the
  **pre-6AM straight-time-bank rule** (`calculations.md:248`): pre-6AM slices price as
  outside-window OT at x1.5 **and** do not consume the 8-hour ST bank, while still counting toward
  the 12-hour DT threshold. Her `4am-8am` drive splitting as *"2 ot, 2 st"* while the day still
  pays a full 8 ST is only reproducible under that rule. It also corroborates PAY-043's boom-window
  scope: long boom pay is marked on build-up / work / breakdown only, never on drive time. And it
  is the **first written source anywhere in the vault that treats drive time as a payroll concept**
  at all.
- **Sources checked:** [rules/PAY-019](rules/PAY-019-cross-midnight-processing.md),
  [PAY-021](rules/PAY-021-l12-standard-work-window.md), [PAY-022](rules/PAY-022-daily-straight-time.md),
  [PAY-023](rules/PAY-023-daily-overtime.md), [PAY-024](rules/PAY-024-daily-double-time.md),
  [PAY-033](rules/PAY-033-holiday-pay.md), [PAY-043](rules/PAY-043-long-boom-premium.md),
  [PAY-046](rules/PAY-046-meal-opportunity.md), [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md);
  [legacy-payroll-app-db-extract/calculations.md](legacy-payroll-app-db-extract/calculations.md)
  STEP D-E and the `CrossMidnightDayTypePolicy` config row;
  [rules-plain-language.md](legacy-payroll-app-db-extract/rules-plain-language.md) §2, §3, §7, §10;
  [MLA Article III](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md) §A.1 and Holidays §1.
- **Owner:** Corrina Bustos. **Owed:** a `decisions/` note for the cross-midnight adjudication, and
  the `cfg.CrossMidnightDayTypePolicy` question can now be closed.
- **Full verification:** [client-message-findings.md](client-message-findings.md#2026-09-04--long-boom-day-breakdowns-drive-time-included-corrina-bustos-teams)

## Holiday 8-hour minimum on a shift that only spills past midnight into the holiday

- **Status:** resolved 2026-09-04 — **answered from the record, no client question needed.** Once
  per employee **per calendar date**, summing every entry that touches the day. See below.
- **Asked:** 2026-09-04 — fell out of Corrina's cross-midnight answer.
  **Rules:** PAY-033, PAY-019, PAY-032.
- **Question:** Corrina stated that a shift working into a holiday owes *"an additional 8 hours at
  triple time as the rule is that the ee is owed a minimum of 8 hours"*. Three things followed that
  were unstated: **(a)** does a mere *spillover* past midnight trigger it; **(b)** if the crew then
  works the holiday properly later the same day, is the minimum owed once per calendar day or once
  per shift; **(c)** is the holiday minimum's calendar-day grouping deliberate when every other
  guarantee groups on `ShiftAnchorDate`?
- **Resolution (a):** **yes.** The MLA is unconditional — *"A minimum of eight (8) hours at triple
  (3) time... shall be paid for all work performed under this Agreement on the following holidays"*
  (Article III, Holidays §1), with no minimum duration — Corrina stated it directly on 2026-09-04,
  and the engine has **no spillover suppression**. The only thing that can switch the minimum off
  is `cfg.Craft_MinimumPayPolicy.ApplyMinimumPay` (`usp_Apply_GuaranteedHours:140, 464`), a
  **per-craft** flag, which is the mechanism that exempts admin crafts. Nothing keys on how the
  holiday hours were arrived at.
- **Resolution (b): once per employee per calendar date, not per shift.** Two independent sources.
  **Code** (`sql/app/usp_Apply_GuaranteedHours.PROC.sql:443-487`): the `HolidayGroups` CTE declares
  `ScopeBasis = 'CalendarDate'`, `GroupScope = 'EmployeeCalendarDate'`, sets
  `ShiftAnchorDate = CONVERT(date, NULL)` explicitly, and closes `GROUP BY EmpID, CalendarDate`;
  the gap is `8.00 - SUM(Slice_Hours)` over **all** of that employee's holiday slices that date,
  allocated to the latest holiday-slice entry (`AllocationMethod = 'LastHolidaySliceEntry'`, `:742`).
  So a 0.5-hour spillover plus a later 6-hour holiday shift is one day at 6.5 hours and a 1.5-hour
  gap, not two minimums; reach 8 hours across the day by any combination and no gap is paid.
  **Recording** — 2026-06-11 *Payroll-App demo-02*, Corrina Bustos at 19:11: *"Put 8 hours per day
  guaranteed on a holiday"*, and at 19:16 on the non-holiday case *"it's a four-hour minimum per day
  or their true time."* Brian Petros describes the grouping at 19:21 in the same exchange: *"there's
  another labor entry that same day, and so that's where this grouping kicks in, so it's like
  looking at the entire day for the employee… they actually work 6 hours that day, so the rule
  didn't apply."* Code and client agree.
- **Resolution (c): deliberate.** `ScopeBasis` / `GroupScope` are **named, emitted columns**, and the
  calendar-date holiday group sits in the same CTE block as the shift-anchored groups, each
  declaring its own basis. It is a modelled distinction, not an artefact. ⚠️ **Worth carrying into
  the ERP as a known asymmetry:** in plain language Corrina says "per day" for both the 4-hour and
  the 8-hour minimum, but the engine means **`ShiftAnchorDate`** for the daily/long-boom minimums
  (§5, §6) and **`CalendarDate`** for the holiday and special-Saturday minimums (§7). The two
  definitions diverge only on a cross-midnight shift, and on such a shift the holiday date is
  exactly what is in dispute — so the asymmetry is load-bearing precisely where it is least visible.
- **Sources checked:** `sql/app/usp_Apply_GuaranteedHours.PROC.sql:140, 353, 402, 443-487, 742-768`;
  [rules-plain-language.md](legacy-payroll-app-db-extract/rules-plain-language.md) §5, §6, §7;
  [rules/PAY-033](rules/PAY-033-holiday-pay.md), [PAY-032](rules/PAY-032-l12-holiday-calendar.md),
  [PAY-019](rules/PAY-019-cross-midnight-processing.md);
  [MLA Article III](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md) Holidays §1;
  63 meeting transcripts swept for holiday-minimum scope — 2026-06-11 is the only one that reaches
  it, and it reaches it directly.
- **Owner:** answered; no client action outstanding. **Owed:** fold into the PAY-033 decision note
  alongside the PAY-019 cross-midnight adjudication.

## Rest-period premium — ×1.5 floor, or double time from the first forced hour?

- **Status:** open
- **Asked:** 2026-09-07 — Brian Petros' comparison of the payroll department's manual calculations
  against his Payroll App (message to Ehtesham); logged in
  [client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham](../payroll/client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham)
- **Question:** when an employee returns without 8 hours off, at what multiplier are the forced hours
  paid? The register (PAY-045) and the 2026-08-18 config say a **×1.5 floor** (×2.0 only past 12 chain
  hours), paying only the increase over the slice's normal multiplier. The 2026-09-07 exhibit — both
  the payroll department's manual Excel sheet and the updated app — prices every forced hour at
  **×2.0 from the first hour** (Anthony Albergo, week 2026-08-22: 08-25 17.5 DT, 08-26 18.0 DT,
  08-27 12.0 DT; premiums decompose exactly to a 2.0 floor at $69.66). The contract says only *"the
  applicable overtime rate"*. A second, smaller question rides with it: is the trigger *"prior chain
  contained OT/DT"* (`HrsOTDTPositive`, as extracted) or *"prior chain ended in an overtime period"*
  (the contract's words, and what the exhibit's 08-24 evening entry implies)?
- **Sources checked:** `rules/PAY-045-rest-period-premium.md`;
  `mcog-l12-mla-2025-2028/01-article-iii-working-rules.md` → *Rest Periods*;
  `legacy-payroll-app-db-extract/rules-plain-language.md` §9 and `config-values.md`
  (`cfg.RestPeriod_Rule`); `payroll-rule-dependency-matrix.md` §10 (explicitly declines to state the
  rate — *"copy this part from the approved current L12 contract/Payroll App procedure"*);
  `2026-08-20-payroll-rules-meeting-notes.md` → *Rest period premium* ("extends the prior job's
  OT/DT progression" — a third reading, neither floor nor flat DT); `erp-payroll-module-frd/07` PR-034.
- Blocked: PAY-045 implementation in `packages/payroll-engine` (not started). Nothing shipped is
  wrong today.
- Owner: Brian Petros / payroll leadership (Corrina Bustos for the manual practice).
- **Status:** resolved 2026-09-07 — answered by Brian Petros in writing the same day, and the answer is
  **the register as it stood**: *"no change to the way the '8-hour rest' rule should be calculated"*.
  Floor ×1.5; **×2.0 once the rest chain (entries grouped across gaps < 8 h) reaches 12 cumulative
  hours**; only the delta is paid. The exhibit decomposes exactly under that rule (Aug 24 = 11.0 h,
  Aug 25's first hour reaches 12, the remaining 7.0 h × $69.66 × 1.0 = $487.62). The "DT from the
  first hour" reading was ours, not the client's. The trigger sub-question is withdrawn for the same
  reason.
- Resolution: [client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham](../payroll/client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham) → *Correction — Brian's reply*; `rules/PAY-045` carries
  the withdrawal. What remains is a WTL question, registered separately below.
- Owner: answered; no client action outstanding.

## Do WTL added hours count toward the rest chain's 12-hour double-time threshold?

- **Status:** open
- **Asked:** 2026-09-07 — Brian Petros' reply explaining the Aug 25 rest-rule walk-through; logged in
  [client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham](../payroll/client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham) → *Correction*
- **Question:** the rest rule escalates forced hours from the ×1.5 floor to ×2.0 once the rest chain
  reaches 12 cumulative hours. The payroll department's manual sheet counts the WTL 0.5 h **penalty**
  (hours not actually worked) toward those 12; Brian's app counts actual hours only, so the app
  reaches DT half an hour later than the sheet on Anthony's Aug 25. Which is intended? Brian: *"still
  need to talk through more of the WTL scenarios internally… hopefully get more clarification from our
  Labor Union"*; Corrina to review and approve. **Do not ask — the client has promised an update.**
- **Sources checked:** `rules/PAY-045`, `rules/PAY-047`,
  `legacy-payroll-app-db-extract/rules-plain-language.md` §9–10, `wtl-charts.md`; the 2026-09-07
  exhibit (manual sheet 8/25: OT 1.0 / DT 17.5 on 18.5 h; app: OT 1.0 / DT 18.0 on 19.0 h).
- Blocked: the PAY-045 implementation's hour counter (actual vs payable) — a one-line choice, but
  it changes which hour flips to DT on every long chain.
- Owner: Corrina Bustos (approval), Brian Petros (engine); CodingCops waits.
- Build default (stated to Brian in writing, 2026-09-07): **actual hours only** — the engine matches
  Brian's app until Corrina rules otherwise; flipping to payable hours is a one-line change in the
  chain's hour counter.

## Non-union hourly — holidays, PTO, sick, vacation, shift differential, minimums: unspecified, by the client's own account

- **Status:** open
- **Asked:** 2026-09-07 — Brian Petros' non-union rules summary, §14 ([non-union-hourly-rules-2026-09-07.md](non-union-hourly-rules-2026-09-07.md)); logged in [client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros](client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros)
- **Question:** what, if anything, applies to Non-Union Admin Hourly for paid holidays, holiday
  eligibility, holiday-worked premiums, PTO, vacation, sick pay, minimum-hours rules, shift
  differential, bonuses, allowances and other administrative premiums? Brian states these are **not
  finalized** and must **not** be inferred from the union rules; they are *"separate
  configuration/policy items requiring confirmation from Payroll/Management"*, and he proposes
  discussing them. The engine today pays non-union hourly ST/OT/DT only, classifies the day type
  (PAY-032) but adds no holiday premium — which is the correct default until this is answered.
- **Sources checked:** the summary itself; `rules/PAY-033` (holiday pay — L12), `rules/PAY-073`
  (sick/PTO/on-call), `rules/PAY-036/037` (shift — L12), `rules/PAY-012`;
  `legacy-payroll-app-db-extract/rules-plain-language.md` §12 (zeroes every union extra, adds none of
  these); `hr-onboarding-and-employee-forms.md` (non-union onboarding lists no pay policies).
- Blocked: non-union holiday/PTO/sick pricing in the engine; the ADP export codes for those hours on
  non-union rows.
- Owner: TCG payroll and management (Brian Petros to bring to the next payroll meeting — findings
  question 38).

## Employee-module rules the E2E suite asserts with no written source — PR #488

- **Status:** open
- **Asked:** 2026-09-07 — raised reviewing **PR #488** (`qa-automation-employees`). The specs under
  `qa-automation/e2e/specs/employees/` (`temp-employees.spec.ts`, `duplicates.spec.ts`,
  `invitations.spec.ts`, `lifecycle.spec.ts`, `status.spec.ts`, `validation.spec.ts`,
  `create.spec.ts`, `references.spec.ts`) assert rules **reverse-engineered from the running
  build** — their case docs say *"verified against the live API on 2026-09-07"*, which verifies them
  against the code, not against anyone's intent. Merging freezes current behaviour as expected
  behaviour.
- **Why this register:** there is no `employees/` module. Per
  [../STRUCTURE.md](../STRUCTURE.md) → *The modules*, `payroll/` rolls up `employee*, departments`,
  so employee questions belong here. The portal-invite half (item **c**) is `admin/`'s by the same
  table (auth, users, invitations) and is kept with the rest because the answer travels with the
  employee record; `admin/gaps.md` carries a pointer.
- **Question:** six rules, each answerable in a line. **(a)** Is a **temporary** employee created
  through a **3-step wizard omitting Managed Assets**, sharing the `EMP-#####` sequence with
  `employeeStatus = TEMPORARY`? **(b)** Are **email**, **work cell** and **employee ID** each unique
  per tenant (409 on duplicate), and does archiving **not** free them? **(c)** Does a portal invite
  create a `User` at `PENDING_INVITE` / role `USER` with a **64-character token**, rotated on
  resend, nulled on revoke, re-invitable after? **(d)** Do `DRAFT` employees need only identity
  fields, and is **finalize one-way** (revert → 403)? **(e)** What is the **required-field set** at
  finalize — is a payroll **craft** required, is SSN exactly 9 digits, must joining ≥ hiring, does
  `Terminated` require a termination date, and is the reason capped at **400 characters**?
  **(f)** Do **leave requests** carry an `LVR-#####` sequence, 400 on start &gt; end, 409 on overlap,
  never delete, block deleting the employee, and apply to **permanent staff only**?
- **Sources checked:** **The vault has no product specification for the ERP's employee-module CRUD
  at all.** `EMP-`, `employeeStatus`, `Managed Asset`, `LVR-` and `leave request` return **zero
  hits vault-wide**, transcripts included. Per item: **(a)** the nearest is
  [../dispatch/daily-allocation-system.md](../dispatch/daily-allocation-system.md) §*Temporary
  Employee management in DAS* (`status: unverified`) — temps are assigned *"**without creating full
  HR profiles**"* — which says the record is thinner but names no step count, no omitted step, no
  sequence and no status enum. **(b)** the only written tenant-uniqueness rule in the vault is for
  **sub-categories**, and it leaves the archive-reuse half open:
  [../decisions/2026-09-02-sub-category-names-tenant-unique.md](../decisions/2026-09-02-sub-category-names-tenant-unique.md)
  §*Scope* (`status: reference`) — an archived sub-category *"keeps its name reserved forever…
  **That is shipped behaviour, not a ratified rule**"*. It does not generalise to employees.
  **(c)** `PENDING_INVITE` occurs once, in
  [../quotations/gaps.md](../quotations/gaps.md):1512, about **quotation approvers**; the only
  "Invite Employee" button described anywhere is on the **vendor** record
  ([../vendors-agencies/vendors.md](../vendors-agencies/vendors.md):84), with no token, status or
  role semantics. **(d)** draft appears only as a generic UI affordance —
  [../customers/customer.md](../customers/customer.md):34 *"Add draft functionality (across the app)
  todo"* — never with employee semantics or reversibility. **(e) is the one item with adjacent
  material, and the source disclaims itself.**
  [fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) (`status:
  unverified`) §7 lists required fields including *"Social Security Number (9 digits)"* and
  *"Default Craft Code"*, and §*validation rules* gives *"SSN exactly 9 digits… craft code must
  exist"* — but the same page states *"**Nothing here is TCG data; it is what FCC will accept**"*.
  It is the **legacy vendor's Excel import contract**, not the ERP's finalize validation, and it
  lists **Term dates and Term Reason as *optional***, **contradicting** the specs' *Terminated
  requires a termination date*. No 400-character cap exists anywhere. The date rule survives only as
  a bare punch-list line, [../customers/customer.md](../customers/customer.md):103 — *"Hiring and
  joining date validation"* — which names the fields and **not the direction of the comparison**.
  **(f)** leave exists in the vault only as a **paper** form and a DAS chip:
  [hr-onboarding-and-employee-forms.md](hr-onboarding-and-employee-forms.md) §4.1 describes an
  *"Absence Request"* form with a two-week-notice header and two signatures, and that same file
  registers the ERP question as open — *"**Is the absence request an ERP workflow?** … Nothing says
  where an approved absence is recorded"*; DAS shows an *"On Leave"* KPI and lets a manager mark
  employees on leave, a **state on a chip**, not a request record.
  Also read: [../decisions/2026-06-30-adp-erp-employee-data-ownership.md](../decisions/2026-06-30-adp-erp-employee-data-ownership.md)
  (`status: verified`) — it covers ADP-vs-ERP **field ownership** and the onboarding block, not CRUD
  validation, and settles none of the six. `payroll/rules/` (PAY-001…PAY-073) is entirely payroll
  **calculation** rules; no employee-CRUD rule exists in it.
- **Blocked:** merging PR #488's employee specs as a behavioural contract. Item **(e)** additionally
  blocks the migration cut — if the ERP's required set is not FCC's, the extracts were shaped to the
  wrong contract.
- **Owner:** product team — Corrina Bustos and Brian Petros (HR onboarding and the employee master),
  with Lisette Anzaldo for the DAS temp/fill-in population.

## Post-import ADP entry — what Corrina changes or adds after the CSV, and the salary batch

- **Status:** open
- **Asked:** 2026-09-08 — Brian Petros' covering message with the v5.1 workbook; logged in
  [client-message-findings.md#2026-09-08--payroll-for-adp-v51-the-adp-workbook-now-shows-the-payroll-apps-recommendations-brian-petros-inferred--the-sops-data-engineer-and-the-sender-of-every-prior-workbook-message](client-message-findings.md#2026-09-08--payroll-for-adp-v51-the-adp-workbook-now-shows-the-payroll-apps-recommendations-brian-petros-inferred--the-sops-data-engineer-and-the-sender-of-every-prior-workbook-message)
  (questions 39 and 41)
- **Question:** the client states, in writing, that after `EPI4RZnn.csv` is imported there are
  *"modifications and additional payroll data entered into ADP"* that he still needs to clarify with
  Corrina Bustos, and that **salary employees are not in the Excel process at all** — *"Corrina
  currently enters Salary employee payroll into ADP separately."* So the import file is a subset of
  the payroll actually submitted. What is edited (which rows, which codes, why), what is added
  (PTO? bonuses? the `SALARY` batch? prior-period corrections `PPD`/`PPO`?), and from what source is
  each keyed? For salary: the amount, the frequency, where the figure lives, and whether the ERP is
  expected to produce that batch or leave it manual.
- **Sources checked:** [adp-sop-v5.1.md](adp-sop-v5.1.md) (ends at ADP's Worksheet review — *"note
  any changes needed so we can update this Excel process"*); the 2026-08-18 ADP screenshots
  ([legacy-payroll-app-db-extract/INDEX.md](legacy-payroll-app-db-extract/INDEX.md) — `ROLL` and
  `SALARY` batches both *Manual Entry*, `PTO001` separate); `rules/PAY-013` (salary — scope open);
  `rules/PAY-067`; [adp-hour-earning-codes.md](adp-hour-earning-codes.md) (codes such as `PTO`,
  `PTP`, `BN`, `RET`, `PPD`/`PPO` exist in ADP and appear in no export the vault has seen);
  `non-union-hourly-rules-2026-09-07.md` §15.
- Blocked: any claim that the ERP's ADP output is complete; PAY-013's amount and frequency; the
  scope of the parallel-run comparison (which ADP totals the ERP is expected to match).
- Owner: Brian Petros to clarify with Corrina Bustos (his own action item); CodingCops asks for the
  list, not the answer.

## `BASE RATE OVERRIDE` — a per-row base-rate mechanism in the live workbook, purpose unstated

- **Status:** open
- **Asked:** 2026-09-08 — reading the v5.1 workbook code
  ([adp-workbook-v5.1-engine.md](adp-workbook-v5.1-engine.md) §2); findings question 40
- **Question:** the v5.1 employee sheet has a `BASE RATE OVERRIDE` column. A dollar value there sends
  that row's ST/OT/DT/H2x/H3x hours to ADP on a separate `BASE_RATE_OVERRIDE` row with the override
  as `Temp Rate`, guarded by seven validation codes. Week 36 shipped one such row at `72.16`, the L12
  Group-9 FY26-27 base rate. **What is the override for?** If it is "this employee worked a higher
  craft group that day", it is the practice answer to the open labor-entry-craft vs employee-craft
  question (PAY-010, findings question 1) — pay the employee's own rate on the primary row and the
  job's rate on an override row. If it is a fiscal-year or rate-change correction, it is PAY-008's
  retro path. If it is a non-union rate keyed by hand, it is the missing upstream source for
  non-union rates. Each implies a different ERP field.
- **Sources checked:** the v5.1 SOP (does not mention the column); `qADPPrimaryRows`,
  `qADPImportValidation`, `TEMPLATE` rows 29–33 (the mechanism, not the purpose);
  `rules/PAY-010`, `rules/PAY-008`; [adp-workbook-column-rules.md](adp-workbook-column-rules.md)
  → *Which fiscal-year rate applies is a human decision*; the 2026-09-07 exhibit's *"Base Rate
  Override"* column on the app's recommendation row (PAY-010 / decision 2026-08-20 override — the
  same words, possibly the same thing).
- Blocked: the labor-entry rate-resolution design (PAY-010) if this is the practice; the ADP file
  contract's third row type either way.
- Owner: Brian Petros (one sentence); Corrina Bustos if it is a payroll-department convention.
- Update 2026-10-08 (four imported files, `EPI4RZ38`–`41`, weeks 38–41, shared by Micaela Dipane in
  the ADP-testing Teams chat; read, not stored — they carry real pay data): **the override row is
  routine, and has at least two purposes.** Every week has 3–4 primary rows carrying a `Temp Rate`
  (ST/OT/DT on the row, no Hours-4 code); one employee has three primary rows at three different
  rates in the same week. Most values are L12 group rates (`67.03`, `67.18`, `68.87`, `69.41`,
  `69.75`, `72.16`), which fits the "worked a higher craft group / job rate" reading. One is not:
  `135.14` on 25 regular hours (week 38). Asked about that row, **Micaela Dipane (2026-10-08, Teams):
  *"That is a special agreement for that employee."*** So a per-employee special-agreement rate is
  one purpose, sent through the same mechanism. Still open: what the group-rate overrides are for
  (the question above), and where a special agreement is recorded — the ERP has no field for it.
  This is the case Brian Petros described on 2026-08-13 (payroll-process transcript, 28:31–29:46:
  *"the individual employee may have a special arrangement where they have a bump up … applied to
  their base rate … across all hours"*, Corrina: *"it's in ADP and it's in FCC"*), which became
  Confluence `PAY-CC-03` / `SCRUM-928` *Support Employee-Specific Rate Adjustments* — unadjudicated
  and out of scope of `SCRUM-926` (its intent §5; the resolver leaves an extension point only). The
  week-38 row does not obviously match that shape: it is a full rate (about twice a group rate) on
  regular hours only, not a bump across all hours. Unverified, one-line chat answer; not a decision.

## Boom window as built — the ERP pays the adder across the whole paid shift, not build-up→breakdown

- **Status:** open
- **Asked:** 2026-09-08 — reading the engine against the verified 2026-09-03 decision while answering
  a build question about the long-boom window
- **Question:** this is a **defect to schedule, not a question for the client** — the answer is already
  decided and `status: verified`. [../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md)
  says the boom window is **build-up through breakdown, all hook work inside, travel excluded**
  (Kyle Harlow 45:31, Corrina Bustos confirming current practice). What is built gives the boom adder
  to **every half-hour slice of the payable window**, Start Work → Review & Complete. The field app's
  `BUILDUP_TIME` / `BOOM_TIME` / `BREAKDOWN_TIME` captures exist and are **not consumed by payroll**.
  Consequence: boom is paid on travel and on any non-hook time inside the paid shift — money the MLA
  explicitly excludes (Art. IV: *"Long boom pay does not apply to travel and curfew hours from yard to
  job or job to yard"*). What needs deciding is only the **fallback**: when a ticket carries no
  build-up or breakdown row (a holdover crane, always the case on tower-crane jobs, per the same
  decision), is the window the `BOOM_TIME` sessions, or the whole payable window as today?
- **Sources checked:** the decision note; `rules/PAY-043`;
  `apps/api/src/usecase/payroll/payroll.service.ts:657-658` (window source),
  `packages/payroll-engine/src/calculate.ts:107` (adder per slice),
  `apps/api/src/usecase/ticket-time-entries/derive-ticket-times.ts` (captures returned, boom sessions
  unused); `mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md` §1;
  [adp-workbook-column-rules.md](adp-workbook-column-rules.md) → *Boom pay — the four conditions*.
- Blocked: nothing external. It is a build item — every long-boom figure the ERP produces is high
  until it lands, so any parallel-run comparison against Brian's app or the manual sheet will
  disagree on boom for reasons that are ours, not theirs.
- Owner: CodingCops (build). Only the holdover fallback needs a client line, and it can ride the next
  payroll meeting rather than block.

- **Wording hazard logged 2026-09-19 — the UAT row that set this behaviour says "Break Time", and read literally it means the opposite of the rule.**
  [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → **DONE** *Build-Up to Break Time counts as Boom*, [UAT 2]:
  *"Build-up, boom and breakdown are summed as boom duration, with the client instruction recorded in the code comment."* sha `a7961b6b9`.
  The session sheet's exact words: *"**From Build-Up to Break Time, everything should be considered Boom.**"*
  **"Break Time" here must mean *breakdown*, and the code read it that way** — it sums build-up + boom + breakdown, which is exactly
  the window in [../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md)
  (`status: verified`): *"**Boom window = first moment of build-up → last moment of breakdown, all hook work inside.**"* Kyle Harlow at
  45:31: *"building the machine up and hook work is a boom time. **So build up and break down.**"*
  **Read literally, "Break Time" means a meal or rest break** — and that reading would put a **paid meal break inside the boom
  premium window**, which the same decision excludes by construction (boom is *"a premium window inside the paid day"*, and the
  contract excludes travel and curfew hours). It would also collide with the WTL rules (PAY-046, PAY-047), which exist precisely
  because break time is a separate, differently-treated interval.
  **Nothing needs changing — the build already follows the decision, not the literal wording.** This is recorded so the ambiguity
  does not resurface the next time someone re-derives the window from the UAT sheet rather than from the decision. **Cite the
  decision, never the UAT row, for what counts as boom.** A UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md).

## WTL worked-through meals — the incumbent's two modes are MLA §1 and §2; ours implements only §1

- **Status:** open
- **Asked:** 2026-09-09; **twice corrected.** v1 said our engine was wrong and his right. v2 said the
  reverse — that `WTL_APPLICABLE_ADD` pays triple time and is a bug. **Both were wrong, and the second
  nearly went to the client as a defect report.** The cause of both: reasoning from the legacy code and
  a single transcript line without reading the contract clause underneath it.
- **What the MLA actually says** ([mcog-l12-mla-2025-2028/01-article-iii-working-rules.md](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)
  → *Meal Periods*) — **two clauses, not one:**
  - **§1** — *"If meal periods are worked, they shall be paid at double (2) time the straight hourly
    rate, in addition to the minimum pay requirements, Article III, Section G."*
  - **§2** — *"When employees … are required to work through the meal periods **on Saturday, Sundays
    and/or holidays**, the employee shall receive an **additional one-half (½) hour pay at the
    applicable wage rate** for each meal period that is missed."*
- **The incumbent's two modes map onto them exactly.** `cfg.WTL_Rule` sets `SaturdayMode`,
  `SundayMode`, `SpecialSaturdayMode` and `HolidayMode` to `WTL_APPLICABLE_ADD` — a flat additional
  half hour, which is §2 read literally — and `WeekdaySTStartMode` to `WTL_DT_FLOOR`, which tops the
  half hour up to double time, which is §1. **This is not a bug and must not be reported as one.**
- **The premise that broke both readings:** Article III *Shifts* §1 defines a shift as eight hours
  *"exclusive of meal period"*. Under the contract the meal period sits **outside** the paid shift, so
  paying a worked one is an addition by construction. Our engine's deduct-then-add assumes the half
  hour is already **inside** the paid hours — true of TCG's yard-to-yard practice
  ([../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md))
  but not of the agreement the rule is drawn from. **Which of those two frames governs is the actual
  open question**, and it decides the arithmetic for every worked-through meal.
- **What is genuinely unresolved, both narrow:**
  1. `NonSTStartMode = WTL_APPLICABLE_ADD` gives §2 treatment to a **weekday** shift whose first slice
     is OT or DT. §2 names only Saturday, Sunday and holidays. No clause found for it yet.
  2. §2 says *"at the applicable wage rate"*; `AddMultiplier` is a flat **2.00**. On a holiday the
     applicable rate is **3×** (Holidays §1), so a flat 2.00 may **under**pay. Our
     `max(2.0, multiplier)` covers that case and the incumbent's flat 2.00 does not — the one place
     ours may be the more correct of the two, and the opposite of what v2 claimed.
- **Ours implements §1 only.** We have no equivalent of §2 — no Saturday/Sunday/holiday branch that
  adds a half hour on top. That is the real gap on our side, and it is a build item once the frame
  question above is settled.
- **Sources checked:** MLA Article III *Meal Periods* §1–§2 and *Shifts* §1;
  `cfg.WTL_Rule` in [config-values.md](legacy-payroll-app-db-extract/config-values.md);
  `usp_Apply_WTL_MealPeriods.PROC.sql:481-490, 795-820`;
  `packages/payroll-engine/src/meal-periods.ts`; `rules/PAY-046`, `rules/PAY-047`;
  transcript `2026-09-03-payroll-lunch-rules-and-dispatch-times.md:631-632`.
- **Rule for this register, learned the hard way:** a claim that the incumbent is wrong is not
  reportable until the contract clause has been read in full. The legacy code plus a transcript line
  is enough to raise a question, never enough to assert a defect.
- Blocked: the WTL half of any parallel run; our §2 branch.
- Owner: Corrina Bustos or the labor-counsel review for the frame question (is a worked meal inside or
  outside the paid shift, given TCG pays yard to yard). CodingCops for the §2 branch once it lands.

## Entry 43694's WTL token never parsed — is the payroll department correcting these by hand?

- **Status:** open — needs confirmation
- **Asked:** 2026-09-09 — same reconciliation. This is the **only** part of that exhibit that the
  record cannot answer, and it is a practice question, not a rule question.
- **Question:** on entry 43694 the crew wrote *"(NO LUNCH TAKEN - 0.5 DBL 1st WTL + 0.5 DBL 2nd WTL +
  0.5 DBL 3rd WTL)"* as prose. `app.v_LaborPayroll_CommentTokens` matches only the literals
  `(WTL_0)`…`(WTL_4)`, `(PAY:WTL_n)` and `(WTL)`, so the count parsed as **zero**,
  `MissingTokenBehavior = ASSUME_WTL_0_WARN` fired, and the app deducted 1.5 h and $158.99 for three
  lunches the crew say they did not take. Against the app's own configured rule the entry is
  **$367.22 light** (`$2,315.84` owed, `$1,948.62` shown). **Was Rafa paid $1,948.62, or does someone
  catch the `ASSUME_WTL_0_WARN` warning and fix it before the ADP file?** And how often does the
  warning fire — is prose the norm and the token the exception?
- **Why it matters beyond one entry:** it sets what the parallel run is comparing *to*. If these are
  hand-corrected, the app's stored output is not the pay of record and matching it would be matching
  the wrong number. It also sizes the ERP's benefit from capturing WTL as structured data on the
  ticket — which it now does, so this class of miss cannot recur on our side.
- **Sources checked:** the exhibit; `app.v_LaborPayroll_CommentTokens.VIEW.sql:110-190`;
  `cfg.WTL_Rule.MissingTokenBehavior`; `v_UI_WTL_Exceptions_LatestRun.VIEW.sql` (the warning has a
  UI surface, so someone was meant to see it); [adp-sop-v5.1.md](adp-sop-v5.1.md) (no step mentions
  reviewing WTL exceptions).
- Blocked: the scope of the parallel-run comparison; question 43's sibling — whether WTL dollars reach
  ADP at all, given they have no earning code and no sheet column.
- Owner: Brian Petros, one sentence; Corrina Bustos if it is a payroll-department habit. **Client
  question #44** — ask with the entry number and the two figures attached.

## Rest chain — is a job-to-job gap a "rest period" at all? `REST_STITCH_MINUTES` cannot be set from Brian's retraction alone

- **Status:** open — needs confirmation
- **Asked:** 2026-09-09; **reframed 2026-09-10.** The first version of this entry called it a defect
  and said the constant "must become 0", on the strength of
  [../decisions/2026-09-09-work-chains-stitch-only-when-there-is-no-gap.md](../decisions/2026-09-09-work-chains-stitch-only-when-there-is-no-gap.md).
  That over-read the decision: Brian settled a question about **his** application, and the ERP
  question is not the same one. [PAY-045](rules/PAY-045-rest-period-premium.md) already carries it —
  *"Confirm both thresholds are intended for the ERP."*
- **Question:** the rest premium triggers when an employee *"returns after OT without eight hours
  off"*. Read literally, a **30-minute gap between two jobs** is a return without eight hours off, and
  the second job is rest-forced. Read as a fatigue rule, an employee who never left the job has not
  "returned" at all and nothing is owed. `REST_STITCH_MINUTES` is the switch between those two
  readings, and **the ERP makes the choice sharper than FCC does**: every job is its own ticket here,
  so a job-to-job transition *always* produces an entry boundary. At `0`, two consecutive jobs a
  minute apart are separate rest chains and the second is forced.
- **Brian's exhibit cannot settle it, and this is the part worth keeping.** On ticket `43770` the
  chain already stands at 14 h, past `REST_DOUBLE_AFTER_CHAIN_HOURS = 12`, so the forced floor is
  `REST_DOUBLE_FLOOR_MULTIPLIER` = **2.0**. His own issue #2 fix prices those hours at DT = 2.0 by
  ordinary accumulation. **Floor and bucket coincide: the premium is $0.** What his fix restores is
  the badge, not pay — so the exhibit shows the rule not firing, but not that it should have.
- **Where the money actually is:** the two readings diverge only when a forced chain's hours are
  **not already at 2.0×** — a first stint that reached OT but not DT, a gap under 8 h, then more work
  that would otherwise price at ST or OT. That is the shape to price both ways before choosing, and it
  is not the shape of his exhibit.
- **Sources checked:** `rules/PAY-045` → *Two distinct chain concepts* (already open);
  `packages/payroll-engine/src/rest-period.ts:96-140`;
  `packages/shared/src/constants/payroll.ts:35-39`; `cfg.RestPeriod_Rule` in
  [config-values.md](legacy-payroll-app-db-extract/config-values.md);
  `usp_Apply_RestPeriod_Premium.PROC.sql:77,141`; MLA
  [Article III](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md).
- **Do not change the constant on this evidence.** It is documented at `rest-period.ts:16-19` as
  client-confirmed on 2026-09-07 and as *"NOT tunable guesses"*; that confirmation is now in doubt for
  this one field, which is a reason to ask, not a licence to edit.
- Blocked: rest-period parallel-run comparison either way — his build still stitches at 30 and ours
  does too, so the two currently agree and the comparison proves nothing.
- Owner: Corrina Bustos or Kyle Harlow — this is a fatigue-rule intent question, not Brian's to answer
  about his own code. Fold into the next payroll meeting with a worked example of the divergent shape.

## Meal thresholds — we count per labor entry, the incumbent counts per stitched group

- **Status:** open
- **Asked:** 2026-09-09 — reading our meal path against `usp_Apply_WTL_MealPeriods` while confirming
  the stitch retraction did not touch the WTL side
- **Question:** how many meal periods a day owes is a function of **span**, and the two engines measure
  a different span. Legacy joins `cfg.WTL_MaxMealThreshold` on `GroupSpanHours` — the span of the
  **stitched WTL group**, gapless (`StitchGapMinutes = 0`), possibly several labor entries. Ours reads
  `actualHours = round2(slices.length * 0.5)` for **one job-day**
  (`packages/payroll-engine/src/calculate.ts:262`) and never widens it to the chain. Back-to-back
  entries therefore diverge: two gapless 4-hour entries are one 8-hour group owing **1 meal** in the
  legacy engine, and two 4-hour entries owing **0** in ours (the first band is `0.50–5.00 → 0 meals`).
  Two gapless 8-hour entries are a 16-hour group owing **3** against our `1 + 1 = 2`.
- **Why it has not shown up:** the common shape — one long entry, or entries separated by a real gap —
  agrees under both. It is specifically the **split FCC labor entry** that breaks, which is one of the
  four reasons Brian gives for having introduced the stitch in the first place. So the case exists in
  their data by his own account.
- **Sources checked:** `usp_Apply_WTL_MealPeriods.PROC.sql:481-500` (the threshold join on
  `GroupSpanHours`); `cfg.WTL_MaxMealThreshold` (5 rows) in
  [config-values.md](legacy-payroll-app-db-extract/config-values.md);
  `packages/payroll-engine/src/calculate.ts:262-269`, `meal-periods.ts` `MEAL_OPPORTUNITY_HOURS`;
  `rules/PAY-046`, `rules/PAY-047`. Related and separate:
  *WTL worked-through meals — we deduct a half hour, the incumbent never does*, above.
- Blocked: the WTL half of any parallel run on a day with split entries.
- Owner: CodingCops (build) for the fix. One client line only if we want the group span confirmed as
  the intended basis rather than inferred from the incumbent — worth folding into the next meeting
  alongside the overlapping-entries question below.

## Overlapping FCC labor entries — no rule, and Brian has none either

- **Status:** open — needs confirmation
- **Asked:** 2026-09-09 — Brian raised it himself while retracting the 30-minute stitch
- **Question:** *"in FCC sometimes there are overlapping labor entries as well... not sure if/how we
  will handle overlapping labor entries in ERP yet... we can discuss next meeting."* Two entries for
  one employee whose times overlap: is that double-paid, merged into one span, or an exception a human
  resolves? It changes ST/OT/DT accumulation, the meal-period span and the rest chain, so it cannot be
  left to fall out of whichever grouping code runs first.
- **What the incumbent does today, for reference, is stitch them silently:** every chain break is
  `DATEDIFF(MINUTE, prevEnd, start) > @StitchGapMin`, and an overlap gives a negative difference, so
  overlapping entries always land in one chain regardless of the setting. That is behaviour, not a
  decision — no config field and no comment addresses overlap.
- Blocked: nothing yet. It becomes blocking the first time FCC migration lands overlapping entries in
  a pay period we calculate.
- Owner: Brian Petros — **he asked for the next meeting himself**, so it is agenda, not a message.

## payroll-engine test debt — the 43770 chain case is unwritten, and three PAY-043 boom tests fail on main

- **Status:** open
- **Asked:** 2026-09-10 — verifying a claim before it went to the client, in the 2026-09-09 Brian
  Petros thread ([client-message-findings.md](client-message-findings.md))
- **This is build debt, not a client question.** Filed so neither half is re-derived.

### 1. The 43767 → 43770 chain case has no regression test

> **Restored 2026-09-11** as `PAY-023: Brian Petros 43767 → 43770 carries the ladder across a
> 30-minute gap` in `calculate.spec.ts`, passing (8 / 4 / 2 then 0 / 0 / 5). §1 is closed; §2 stands.

Brian's own counter-example is the sharpest test we have for PAY-023 chain accumulation, and nothing
in the suite covers it. **It was written and run on 2026-09-10, passed, and was then reverted** — so
it is known-good rather than speculative, and this entry exists so it can be restored without
rebuilding the inputs. Add to `packages/payroll-engine/src/calculate.spec.ts`, using the file's
existing `l12Employee()` / `l12JobDay()` helpers:

| | Ticket 43767 | Ticket 43770 |
| --- | --- | --- |
| `shiftStartedAt` | `2026-04-09T10:30:00.000Z` (03:30 Pacific) | `2026-04-10T01:00:00.000Z` (18:00 Pacific) |
| `shiftEndedAt` | `2026-04-10T00:30:00.000Z` (17:30 Pacific) | `2026-04-10T06:00:00.000Z` (23:00 Pacific) |
| span | 14.0 h | 5.0 h |

`periodStart: '2026-04-04'` (the period on Brian's screenshot is Apr 4–10; April 2026 is PDT, UTC−7).
Distinct `jobId` per entry. Set `lunchesTaken: 0` and `wtlCount: 0` so the assertions read the hour
buckets alone. The gap between them is **30 minutes**, under `CHAIN_GAP_HOURS`, so the two chain.

Expected — 43767 is the control and matches his screenshot's pre-WTL figures, 43770 is the assertion
that matters:

- **43767** — `stHours 8`, `otHours 4`, `dtHours 2`. (03:30–06:00 OT under the pre-6AM rule, which
  does not spend the ST bank; 06:00–14:00 ST; 14:00–15:30 OT; 15:30–17:30 DT once the chain passes 12
  hours.)
- **43770** — `dtHours 5`, `otHours 0`, `stHours 0`. **His Payroll App prices this as 5.0 OT**, which
  is the issue #2 he reported: the ladder restarting at each `LaborPayrollID` instead of carrying.

### 2. Three PAY-043 boom tests fail on `main`, and predate this work

Verified by stashing: **44 pass / 3 fail** without the new case, 45 / 3 with it — the same three
either way, so they are not collateral from anything in this thread.

- `PAY-043: several boom sessions in one shift all count` — expected `3.5`, actual `4`
- `PAY-043: a boom session spanning OT splits the adder across buckets` — expected `3`, actual `4`
- `PAY-043: a slice straddling the boom edge is not boom time` — expected `1`, actual `4`

All three now get **more** boom hours than they assert, and all three land on `4`. That is the
signature of commit **`1ad99687d`** *"fix: fixed 1 hours mismatch issue"* (2026-09-08), which moved
the boom window from the whole payable shift to the captured build-up / boom / break-down segments
(`apps/api/src/usecase/payroll/payroll.service.ts:662-669`) — the change discussed under
*Boom window as built*, above. **Which side is wrong is not established:** either the tests encode the
old whole-shift window and should have been updated with the fix, or the fix widened boom hours
somewhere it should not have. Settle that before touching either.

- **Sources checked:** `pnpm nx run @tcg/payroll-engine:test --skip-nx-cache` on `main` at `b1639820`,
  with and without the new case; `git log -S` on `payroll.service.ts`;
  `packages/payroll-engine/src/calculate.spec.ts`.
- Blocked: any use of a green payroll-engine suite as a merge gate, until §2 is resolved.
- Owner: CodingCops (build).

## Paper Job Tickets — pointer, owned by field-ops

- **Status:** open
- **Asked:** 2026-09-10 — Brian Petros, Teams message ahead of that day's call (relayed 2026-09-11).
- **Question:** **Pointer only — the question lives in
  [../field-ops/gaps.md](../field-ops/gaps.md) → *Paper Job Tickets — will they remain an option,
  and how does the ERP price and pay one?*** Registered here because the payroll consequence is
  the sharp end: TCG is still sometimes processing paper Job Tickets, and the paper ticket's crew
  row carries `Lunch ☐Yes ☐No` — **a taken/not-taken flag with no times**. That is precisely the
  input the 2026-09-03 call ruled insufficient (Brian at 19:03, 40:38: the *when* prices the
  half-hour at ST/OT/DT/holiday) and the input Brian's own 2026-09-10 scenario list answers `#0`
  on with *"yes need to know"*. So a paper ticket cannot supply what PAY-046/PAY-047 have just
  been told they require, and no rule says what the engine should do when it arrives anyway —
  the retired `no token ⇒ assume lunch taken, deduct` default is exactly what Corrina asked to
  stop doing.
- **Sources checked:** see the field-ops entry — it carries the full source list.
- **Blocked:** nothing today. It will block the first payroll ticket that has to accept a
  job-day with no mobile capture.
- **Owner:** TCG — Corrina Bustos and Brian Petros for what payroll can accept; Melissa McNutt
  and Kyle Harlow for the field practice.

## Anniversary Checks — the L12 vacation payout, live in FCC and specified nowhere

- **Status:** open
- **Asked:** 2026-09-10 — Brian Petros, Teams message ahead of that day's call (relayed to us 2026-09-11), with an FCC
  screenshot: *"Anniversary Checks. Here is an example in FCC of one of these..."*
- **Question:** How does the ERP produce an anniversary check — who is eligible, at which rate, on
  which date, and how does the 40-hour row interact with every other payroll rule? The register has
  a rule id for this ([rules/PAY-057-vacation-eligibility-pay.md](rules/PAY-057-vacation-eligibility-pay.md)) and nothing behind it:
  matrix baseline *"New ERP requirement"*, no FRD counterpart, no legacy-engine counterpart,
  blocking on *"HR/union confirmation"*. [client-message-findings.md](client-message-findings.md) recorded on 2026-09-09 that
  **anniversary pay appears in no vault document at all** and sat in Brian's *"miscellaneous"*
  remainder of the app's ~5% inaccuracy. **This screenshot supersedes that: it is not miscellaneous,
  it is a contract entitlement, and it is being paid today.**
- **What the screenshot shows** ([assets/2026-09-11-fcc-anniversary-check-example.png](assets/2026-09-11-fcc-anniversary-check-example.png), FCC
  *Labor for Payroll Pre-Processor*): The Crane Guys, LLC · Main Yard · employee Garrett, Russell ·
  Work Date **08/29/2026** · Union L12 · Craft Code **L12-G9-A** (*OP & Tower OP >550T, HDR-R*) ·
  Hours **40** · Rate **$79.660** · Amount **$3,186.40** · Class **`L12 Anniversary`** · Work Comp
  `OPERATOR RAT` · Burden `STD` · **WTL unchecked** · Start Time 06:00 AM = End Time 06:00 AM ·
  **Actual Time 00.00 Hrs** · **no Job, no Work Order, no Unit Code, no Activity, no Comments** ·
  Approved by `corrinab` 9/8/2026 2:26:36 PM · totals **ST 40.00 / OT 0.00 / DT 0.00**.
  40 × $79.660 = $3,186.40 exactly.
- **It is the MLA vacation entitlement, and the contract states it precisely.**
  [mcog-l12-mla-2025-2028/04-articles-vi-to-xv-funds-and-contributions.md](mcog-l12-mla-2025-2028/04-articles-vi-to-xv-funds-and-contributions.md) §1: an employee who
  has completed *"one (1) year of continuous work… or after his anniversary date, whichever comes
  first"* and in that year worked *"at least twelve hundred (1200) hours, shall be entitled to one
  (1) week's vacation with pay for **forty (40) hours at the employee's regular rate of pay**."*
  Forty hours at a rate is exactly what the row pays. So `PAY-057`'s *"service and annual-hour
  thresholds"* are **1 year and 1200 hours**, from the contract — that part need not wait on HR.
- **What the row proves about the mechanism — it bypasses the entire time engine.**
  1. **08/29/2026 is a Saturday**, and the row is **40.00 ST hours with 0.00 OT** —
     [rules/PAY-030-ordinary-saturday.md](rules/PAY-030-ordinary-saturday.md) would make an ordinary Saturday all-OT. The
     anniversary class is not day-typed.
  2. **Start = End = 06:00 AM, Actual Time 00.00 Hrs.** No span, so nothing for
     [PAY-020](rules/PAY-020-half-hour-reckoning.md) to round, [PAY-021](rules/PAY-021-l12-standard-work-window.md) to
     window, or [PAY-046](rules/PAY-046-meal-opportunity.md) to find a meal in. The `WTL` box is
     unchecked and the hours are a quantity, not a duration.
  3. **No Job / Work Order / Unit Code.** It is not billable to anyone; it is pure labor cost.
  4. It is a **classification, not an earning rule**: `ANNIVERSAR` — *"L12 Anniversary"*, created
     by `corrinab` 2026-01-15, one of only **two** codes with `UseCertifiedPayroll = 0`
     ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §3 — where this register already noted it *"is
     not a concept the register has"*). Excluding it from certified payroll feeds
     [PAY-072](rules/PAY-072-certified-payroll-davis-bacon-reporting.md).
  5. **ADP already carries it:** earning code `ANV` / *Anniversary*, bucket B, category 3, ADP code
     `ANNIVE` ([adp-hour-earning-codes.md](adp-hour-earning-codes.md); [adp-api-responses/pay-data-input-meta.md](adp-api-responses/pay-data-input-meta.md)).
     The export side is solved; the *derivation* side is what is missing.
- **The four things nobody has written down:**
  1. **Which rate is "the employee's regular rate"?** The row pays `L12-G9-A` at $79.660 — a
     specific craft group. An operator who worked several groups across the anniversary year has
     several regular rates. Highest worked? Most recent? Most frequent? Their assigned default
     craft? The contract says *"regular rate of pay"* and does not disambiguate, and this is a
     four-figure difference per check.
  2. **Does the ERP compute eligibility, or does a human?** The 1-year and 1200-hour tests are
     nowhere in the row — it was created and approved by hand (`corrinab`, 9/8/2026). Whether the
     ERP should evaluate the two thresholds and propose the check, or accept it as a manual entry,
     is undecided. If it computes: from which hours — all paid hours, worked hours only, does
     the anniversary row itself count toward the next year's 1200?
  3. **Which date, and how does it land in a payroll week?** 08/29/2026 is the **first day of a
     Saturday–Friday payroll week** ([PAY-001](rules/PAY-001-saturday-friday-payroll-week.md)),
     not the employee's actual hire anniversary. Whether the date is the anniversary, the week
     start, or the processor's choice is unstated.
  4. **Does the 40 hours consume the weekly overtime threshold?** [PAY-025](rules/PAY-025-weekly-overtime.md)
     works off 40 hours; the MLA's is *"forty (40) hours, Monday through Friday… at straight-time"*.
     If an employee works a normal week and the anniversary 40 lands in it, a naive weekly-OT clock
     puts every worked hour into OT. Nothing says the anniversary hours are excluded from that
     clock, and nothing says they are included. **This is the one that silently produces a wrong
     cheque.**
- **Sources checked:** [rules/PAY-057-vacation-eligibility-pay.md](rules/PAY-057-vacation-eligibility-pay.md) (rule shell, no content);
  [codingcops-rule-matrix.md](codingcops-rule-matrix.md) `PR-057`; [mcog-l12-mla-2025-2028/04-articles-vi-to-xv-funds-and-contributions.md](mcog-l12-mla-2025-2028/04-articles-vi-to-xv-funds-and-contributions.md)
  §1–§2 (§2 also gives a **prorated** payout on layoff or quit after >10 consecutive days, at an
  average of 100 hours/month — a second, unbuilt path);
  [fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §3; [adp-hour-earning-codes.md](adp-hour-earning-codes.md);
  [client-message-findings.md](client-message-findings.md) (the "no vault document" line this entry answers);
  [erp-payroll-module-frd/](erp-payroll-module-frd/INDEX.md) — no anniversary/vacation section;
  `grep -rn -i anniversar .ai/aidlc/SCRUM-*/` — no ticket.
- **Blocked:** nothing today. It will block the first payroll ticket that has to produce or import
  a non-worked pay row, and it is already a known component of the parallel run's residual error.
- **Update 2026-09-11b — Brian Petros published how he is building it, and it answers all four
  questions above. As a proposal, by him, for his app: nobody has adjudicated it.** Message: *"The
  way I am programming our internal Payroll App to find/process these… Payroll App will
  process/apply **roughly** as follows"*, with a fourteen-bullet spec
  ([assets/2026-09-11-brian-anniversary-processing-spec.png](assets/2026-09-11-brian-anniversary-processing-spec.png)). **Identification:** he keys off the
  **`Class` field** — payroll selection *"L12 Anniversary"* — exactly the `ANNIVERSAR`
  classification in [fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §3. **Processing, verbatim:**
  keep the FCC `WorkDate` for assigning/reporting; **preserve the 40.00 source hours for
  audit/display but do not treat them as actual worked hours**; preserve Source Rate / Source Amount
  *"exactly as Payroll entered them — I would not recalculate the amount using our union pricing
  rules"*; do not feed the 40 hours into ST/OT/DT accumulation; **exclude completely** from weekly
  >40 and seventh-day, and from rest-period continuity; exclude WTL, guaranteed hours, Special
  Saturday / holiday rules, and shift differential; do not independently recalculate boom/craft
  modifiers; do not require valid start/end times — *"the `06:00 → 06:00` values are effectively
  irrelevant for this type of entry"*; do not require a JobCode or JobTicket; **it should not create
  `Invalid_Labor_Time_Interval`**; and audit it as `ANNIVERSARY / SPECIAL EARNING / SEPARATE CHECK`.
  **Mapped onto the four questions this entry asked:** (1) *which rate* — **the ERP never picks
  one**; it preserves what a human entered, so the question moves from derivation to policy (what
  should the clerk enter?) and stays open there; (2) *compute eligibility or accept a manual row* —
  **manual**, the 1-year/1200-hour tests are not evaluated; (3) *which date* — **whatever WorkDate
  payroll entered**, not a derived anniversary; (4) *weekly-OT threshold* — **excluded completely**,
  which is the answer that stops the silent wrong cheque. **Why the `Invalid_Labor_Time_Interval`
  bullet is the load-bearing one:** the 2026-09-07 backup turned `@StrictLaborTimes` on by default,
  so entries with missing or **equal** start/end become exceptions — *but only when
  `HoursWorked_Raw > 0`* ([legacy-payroll-app-db-backup-2026-09-07/INDEX.md](legacy-payroll-app-db-backup-2026-09-07/INDEX.md) §4). An anniversary row
  is start = end = 06:00 with Hours = 40, so it trips that exception the moment source hours are
  read as worked hours. FCC already keeps the two apart — the screenshot shows **Hours 40** beside
  **Actual Time 00.00 Hrs** — and Brian's *source hours ≠ worked hours* rule is the same separation
  stated as a design. **Still open even if TCG adopts all of it:** what the clerk should enter as
  the rate (question 1's policy half); whether the ERP should nonetheless *propose* eligibility from
  the contract's 1-year/1200-hour test rather than leaving it entirely to memory; the MLA §2
  prorated-on-layoff path, which this spec does not mention; and whether *"separate check"* in the
  audit tag means a genuinely separate ADP payment or only a label. **Note who has and has not
  spoken:** this is Brian Petros describing his own build. The Payroll Manager, Corrina Bustos, has
  not stated it, and Brian himself defers to her for the adjacent cases — see the generalization
  entry below.
- **Owner:** TCG — Corrina Bustos and Brian Petros for the rate and eligibility rules; the union
  and HR for the contract reading the matrix already asks for.

## Special earnings — a pay row the rule engine must not touch, and the payroll department's manual-entry path

- **Status:** open
- **Asked:** 2026-09-11 — Brian Petros, generalizing from the anniversary-check spec: *"In general…
  I'm thinking this type of payroll processing can be abstracted to apply to other scenarios (for
  both Union and non-Union). This example is Union employee 'Anniversary' checks. There are other
  scenarios Corrina can help us better understand for other types of employees as well… like sales
  commission checks and other 'bonus' type checks. This is related to the need for our payroll
  department to be able to manually enter and/or modify information/entries that affect payroll."*
- **Question:** Is there a **general class of pay row that carries hours, rate and amount as data
  and is exempt from the entire calculation engine** — and if so, what is its full member list,
  which exemptions are per-class rather than universal, who may create one, and what does the ERP
  validate on it? The anniversary check is the first worked instance
  (see *Anniversary Checks* above); Brian names **sales commissions** and **bonuses** as further
  members, spanning **union and non-union**, and Corrina Bustos as the person who can enumerate the
  rest. Nobody has enumerated them.
- **Why this is an architecture question, not a feature request:** every rule in `rules/` assumes a
  labor row is a **span of worked time** — [PAY-017](rules/PAY-017-time-source-selection.md) selects
  a time source, [PAY-018](rules/PAY-018-assumed-shift.md) reconstructs a shift when times are
  missing, [PAY-020](rules/PAY-020-half-hour-reckoning.md) rounds it,
  [PAY-021](rules/PAY-021-l12-standard-work-window.md) windows it,
  [PAY-022](rules/PAY-022-daily-straight-time.md)–[PAY-024](rules/PAY-024-daily-double-time.md)
  bucket it, [PAY-025](rules/PAY-025-weekly-overtime.md) and
  [PAY-026](rules/PAY-026-seventh-consecutive-day.md) accumulate it,
  [PAY-045](rules/PAY-045-rest-period-premium.md) chains it,
  [PAY-046](rules/PAY-046-meal-opportunity.md) finds meals in it. A special earning is **hours that
  are not time**. Brian's spec is a list of fourteen exemptions precisely because there is no such
  concept in the model today — the row has to be excused from each rule individually. Whether the
  ERP models this as (a) a flag on the labor row that short-circuits the pipeline, (b) a separate
  entity that never enters it, or (c) a pay component written straight to the ledger
  ([PAY-059](rules/PAY-059-pay-component-ledger.md)) is undecided and is the decision that shapes
  everything else here.
- **What is already on record and can be reused:**
  - **The exemption list**, from the anniversary spec —
    [assets/2026-09-11-brian-anniversary-processing-spec.png](assets/2026-09-11-brian-anniversary-processing-spec.png). Whether it is identical for a
    commission or a bonus is unstated; a non-union bonus has no boom modifier or WTL to exclude,
    but does have a **CA regular-rate-of-pay problem a union anniversary check does not**: under
    California law a non-discretionary bonus is generally retroactively included in the regular
    rate for overtime already worked. Brian's *"exclude weekly >40 completely"* is safe for a
    contractual vacation payout and is **not obviously safe for a production bonus**. Nothing in
    the vault addresses this, and it is the same class of exposure as
    [../decisions/2026-09-03-paid-straight-through-not-in-erp.md](../decisions/2026-09-03-paid-straight-through-not-in-erp.md).
  - **The classification mechanism** — FCC identifies the row by its `Class` field, and the
    classification table already carries members beyond anniversary: `ADMIN PTO`, `BER`
    (Bereavement), `SICK`, `DRUG` (Drug Testing), `ON CALL`, the three subsistence codes, and
    `NO 8 HR GP` ([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §3). **Some of those are almost
    certainly special earnings under this definition and have never been examined as a group.**
    `UseCertifiedPayroll` is already per-classification, which is a second per-class exemption
    switch that exists today.
  - **Rules that already half-cover this and should be reconciled, not duplicated:**
    [PAY-063](rules/PAY-063-manual-adjustment.md) *Manual adjustment* — *"add separate adjustment
    without overwriting original calculation"*, blocking on *"confirm approval levels"*, which is
    Brian's *"manually enter and/or modify"* ask;
    [PAY-073](rules/PAY-073-sick-pto-on-call-pay.md) *Sick / PTO / on-call* — amounts that exist
    **only on the ADP sheet** today, blocking on an explicit in/out decision, and a strong candidate
    to be the same mechanism; [PAY-057](rules/PAY-057-vacation-eligibility-pay.md);
    [PAY-013](rules/PAY-013-non-union-salary-rate.md), whose *"not calculated from labor"* salary
    exclusion is **already enforced at the front of the pipeline** in the 2026-09-07 backup
    (`v_UI_Employee_TypeRate` classifies `PayType S` ahead of the L12 predicates and asserts zero
    calculated and zero exception rows) — **a working precedent for exactly the short-circuit this
    entry is about**; [PAY-060](rules/PAY-060-missing-data-issues.md) for the exception-suppression
    half; [PAY-067](rules/PAY-067-adp-export.md) for whether *"separate check"* is a real separate
    payment.
  - **Manual-entry precedent in production:** the ADP batches `ROLL` (Field Roll, 85 people) and
    `SALARY` (29) are already marked **Manual Entry**, with `PTO001` separate — so a manual path
    exists today outside the engine entirely.
- **The questions to put to Corrina Bustos:** the full list of check types that behave this way,
  union and non-union; for each, which of the fourteen exemptions apply and which do not; who is
  allowed to create one and who approves it (PAY-063's blocking item); whether *"separate check"*
  means a separate ADP payment or a label; and whether any of them is a **non-discretionary bonus**
  in the California sense, because that one cannot simply be excluded from the overtime base.
- **Sources checked:** the anniversary spec image and screenshot (both in `assets/`);
  [fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §3; [rules/PAY-063](rules/PAY-063-manual-adjustment.md),
  [PAY-073](rules/PAY-073-sick-pto-on-call-pay.md), [PAY-013](rules/PAY-013-non-union-salary-rate.md),
  [PAY-059](rules/PAY-059-pay-component-ledger.md), [PAY-060](rules/PAY-060-missing-data-issues.md);
  [legacy-payroll-app-db-backup-2026-09-07/INDEX.md](legacy-payroll-app-db-backup-2026-09-07/INDEX.md) §3–§4;
  [codingcops-rule-matrix.md](codingcops-rule-matrix.md); [erp-payroll-module-frd/](erp-payroll-module-frd/INDEX.md) — no section on
  special earnings or manual entry; `grep -rn -i 'commission\|bonus' .ai/aidlc/SCRUM-*/spec.md` — no
  ticket. Sales commissions are documented on the **quotations** side
  ([../quotations/sales-commissions.md](../quotations/sales-commissions.md)) with no payroll-side counterpart.
- **Blocked:** nothing today. It will block the first ticket that has to put a non-worked amount on
  a payroll run, and it should be decided **before** anniversary checks are built, because building
  anniversary alone bakes in a single-purpose path.
- **Owner:** TCG — Corrina Bustos to enumerate the scenarios and the approval levels; Brian Petros
  owns the processing spec; CodingCops owes the modelling decision (flag vs entity vs ledger
  component); California counsel for the bonus / regular-rate question, on the same footing as the
  2026-09-03 referral.

## Boom and craft adders — into the rate or on top? ✅ CLOSED 2026-09-10 — into the rate

- **Status:** closed
- **Asked:** 2026-09-11 — raised while curating the 2026-09-10 payroll call, where Brian Petros
  stated the rule the other way round from the decision it was believed the ERP was built on.
- **✅ CLOSED 2026-09-10, decision note [../decisions/2026-09-10-craft-adders-are-into-the-rate-multiplied.md](../decisions/2026-09-10-craft-adders-are-into-the-rate-multiplied.md).**
  The adder goes into the base rate and the multiplier applies to the sum — an OT half hour with
  boom is **$63.00**. Brian Petros said so unprompted and at length on the recorded call, Corrina
  Bustos concurred, the MLA's literal clause says the same, and the engine has always done it. Brian
  confirmed our reading in writing on 2026-09-11 (*"you understand it correctly"*); TCG chose not to
  re-ask, on the evidence of the recording plus that message. **No code change.** The
  2026-08-25 note is superseded and `SCRUM-920`'s confirmation obligation is discharged. **What
  carries forward, not as a question but as a caution:** Brian's scenario workbook still prices boom
  flat at $62.00, and he corrected only the Final-column formula — expect scenarios #2 and #3 to
  arrive with the same grid, and reconcile them to the decision rather than to the sheet.
- **Question:** Is a craft adder (**long boom, lattice, foreman, military base**) **(a)** added to
  the base rate so that the OT/DT/holiday multiplier applies to the sum, or **(b)** paid flat on top
  of the already-multiplied rate? A single long-boom hour at double time pays the adder twice under
  (a) and once under (b). **Corrected 2026-09-11 by reading the code rather than the decision note:
  the ERP is built on (a) — `calculate.ts:299` prices the adder at
  `boomAdderPerHour * multiplierOf(bucket)`, and `calculate.spec.ts:578` asserts
  `ot.rate === BOOM_ADDER * 1.5` under the comment "PAY-011: the adder rides the multiplier". It has
  been that way since the module's first commit (`61d0fd7d`), so
  [../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md](../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md) — which rules (b) and states
  `SCRUM-926` was built on it — describes behaviour the engine has never had. The shipped code
  agrees with what Brian said on the call; the outliers are the decision note and Brian's own
  workbook.**
- **What changed on 2026-09-10** ([../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md](../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md) §2).
  Brian Petros, **21:48–22:09**, explaining *no pyramiding*: *"there's only one multiplier being
  applied… the long boom is just an addition to the base rate, like the lattice pay or the foreman
  pay or the military base pay, **it gets added to the base rate, and then at the end, the multiplier
  that's applied gets applied to the whole thing**."* Ehtesham Anwar had put the same shape to
  Corrina Bustos at 18:43 — *"12 OT long boom and 4 DT long boom, right?"* — and she answered
  **"Correct."** (18:49, 19:14).
- **Why this is not just another data point — it is the confirmation the working decision asked
  for, arriving against it.** [../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md](../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md) rules
  (b): *"a flat dollars-per-hour figure × boom hours… **not multiplied** by OT / DT / holiday
  multipliers… **not folded into the base rate** for computing overtime."* That note is
  `status: reference`, was decided by **Syed Haris (CodingCops, acting product owner)** — not by
  TCG — and says on its face that it *"sides with a cleaned-up meeting transcript against a literal
  clause of the Master Labor Agreement"*, that **TCG payroll and labor counsel must confirm it**,
  and that the confirmation obligation travels to `SCRUM-920`. It also warns exactly what is at
  stake: *"getting this wrong underpays overtime on every long-boom hour — a wage-and-hour exposure,
  not a rounding difference."*
- **The evidence now points four ways, and two of them are Brian.**
  | Source | Reading |
  | --- | --- |
  | **MLA Art. IV** — *"The additional rate added to the regular rate shall be the base rate when computing overtime pay"* ([mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md](mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md)) | **(a) into the rate** |
  | **SCCA Southern California MLA §R (Foreman)** — *"added to the regular rate and become the base rate for the entire shift"* (this register, *Foreman premium* entry) | **(a) into the rate** |
  | **Brian Petros, recorded call 2026-09-10 21:48**, with Corrina concurring at 18:49 | **(a) into the rate** |
  | **Brian Petros' own scenario workbook**, sent the same day — an OT-with-boom half-hour priced at **$62.00** = $60.00 OT base + $2.00 flat boom, not ($40 + $2) × 1.5 = $63.00 ([lunch-break-scenarios-2026-09-11.md](lunch-break-scenarios-2026-09-11.md)) | **(b) on top** |
  | **2026-08-20 payroll rules meeting notes** (`status: unverified`, cleaned from a transcript) — *"Boom-time premiums are unaffected — they add on top of whichever rate applies"* | **(b) on top** |
  | **The ERP as built** — `calculate.ts:299`, `calculate.spec.ts:578`, unchanged since `61d0fd7d` | **(a) into the rate** |
  | **The 2026-08-25 decision note** — never implemented, despite claiming `SCRUM-926` was built on it | **(b) on top** |
  **Brian's spreadsheet and Brian's spoken explanation, produced the same day, disagree with each
  other.** That is the first thing to resolve, and it can be resolved by asking him one question.
  **Worked against the workbook's own example** (05:30–17:30, base $80.00, boom $4.00, boom window
  06:30–15:30 → 7.5 boom hours in ST and 1.5 in OT): the engine pays boom **$39.00**, the workbook
  **$36.00**, so gross is **$1,159.00** against the workbook's **$1,156.00**. The whole $3.00 is
  1.5 h × $4.00 × 0.5. **The meal deductions are identical** — $42.00 at 10:30 (ST + boom) and
  $60.00 at 16:00 (OT, boom ended) — because neither meal lands in a premium bucket *while boom is
  running*, which is exactly the untested case named below.
- **What makes the call evidence weaker than it looks, and why this is not yet a decision note:**
  Brian was explaining *no pyramiding* in general, not answering a question about the adder, and
  nobody put the two competing readings to him side by side. Corrina's "Correct" answered
  *"12 OT long boom and 4 DT long boom"* — which is unambiguous about **which slices** carry boom
  and only implicitly about **the multiplier**. Neither was shown the $62-vs-$63 arithmetic. A
  decision note needs the question asked directly, with both numbers on the screen.
- **Sources checked:** [../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md](../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md);
  [rules/PAY-011-l12-modifier-boom-rate.md](rules/PAY-011-l12-modifier-boom-rate.md) (*"Decision note pending"*, reads the contract
  as into-the-rate with two carve-outs); [rules/PAY-043-long-boom-premium.md](rules/PAY-043-long-boom-premium.md),
  [PAY-044](rules/PAY-044-lattice-boom-premium.md), [PAY-070](rules/PAY-070-foreman-premium.md),
  [PAY-071](rules/PAY-071-military-base-premium.md), [PAY-027](rules/PAY-027-no-pyramiding.md);
  [source-attribution-and-conflicts.md](source-attribution-and-conflicts.md) → *Into the rate vs on top*;
  [lunch-break-scenarios-2026-09-11.md](lunch-break-scenarios-2026-09-11.md);
  [../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md](../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md) §2.
  **Also now checked: the meal deduction multiplies boom too.** `meal-periods.ts:173` —
  `deductRate = (hourly + (onBoom ? boomAdderPerHour : 0)) * multiplier` — so the engine is
  internally consistent, into-the-rate on both the earning and the deducting side. Under reading (b)
  it would be inconsistent: a half hour *earned* at $62.00 would be *deducted* at $63.00. Whichever
  way this settles, both sites move together.
- **Blocked:** `SCRUM-920` already carries the confirmation obligation. Every long-boom, lattice,
  foreman and military-base hour priced at OT or above is exposed until this is settled, and
  **re-pricing shipped payroll is the expensive path** — settle it before the parallel run is used
  to sign anything off.
- **Owner:** TCG — Brian Petros and Corrina Bustos to answer the direct question; **labor counsel**,
  because the 2026-08-25 note is explicit that a planning decision cannot amend a collective
  bargaining agreement.

## Payroll has three populations, and the ERP has scoped one — work orders, yard techs and salaried staff

- **Status:** open
- **Asked:** 2026-09-11 — raised on the 2026-09-10 call by Ehtesham Anwar once Corrina Bustos
  confirmed non-union payroll is real and in scope.
- **Question:** What does the ERP do for the **two payroll populations it has not modelled** — the
  work-order employees and the salaried employees — and how does labor cross between a work order
  and a job ticket in a single day?
- **The boundary, stated plainly for the first time**
  ([../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md](../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md) §5, 36:54–51:41):
  - **Every dispatched job is L12.** Corrina 38:20: *"any job that's quoted is going to be L12."*
    So every rule the call spent an hour settling applies to job-ticket labor only.
  - **Non-union = California Labor Law**, and those employees are *"admin people, so that's not in
    the field — they wouldn't get a job that's correlated to Local 12 rules"* (Corrina 38:37).
    Corrina 40:52, asked whether she processes any California payroll: **"Yes, we do. It's all the
    salary and then there's a few hourly employees."** Ehtesham 41:19: *"we haven't focused on the
    office employees. We need to figure out what that is, how you are doing that, and how we need to
    calculate that for the ADP."*
  - **Three populations, three mechanisms** (Brian 42:30): job codes → job tickets (union field);
    **work orders** → labor entries (non-union hourly *and* union mechanics); **salaried**, for whom
    *"we don't have labor entered in"* at all.
  - **Work orders** attach to a **PO or a piece of equipment**, not a job (Corrina 42:12) — mechanic
    work orders roll up per equipment so *"if there's a certain project like the engine rebuild on a
    certain crane, it all goes under that work order"* and labor and materials can be reported
    against it (47:12). Used by **yard technicians — California Labor Law** — and **mechanics/HDRs —
    Local 12, same payroll logic as the field** (43:33, 50:23). **There is no such thing as a
    non-union mechanic**: Corrina 50:43 *"we don't have non-union mechanic"*, Kyle *"we can't have
    that position."*
  - **Yard-technician work is partly billable** — Kyle 47:51: loading/unloading specialty equipment
    for specific jobs, deliveries, and driving a **pilot truck** where a permit requires one, *"and
    we need to be able to attach those hours to the field job… so that we can bill for it
    accordingly."*
- **The crossover is the sharp edge, and it is manual today.** Corrina 49:07: *"it would be nice if
  they would be able to have access to work orders and job tickets, because **right now it's one or
  the other**."* Kyle 49:39: an HDR from the shop may go third man on a job — *"otherwise, it's a
  manual entry. And so that needs to be all automated."* It happens **within a single day**
  (Corrina 51:15: shop work order in the morning, emergency job ticket that afternoon). This is one
  of the three named causes of paper tickets — see
  [../field-ops/gaps.md](../field-ops/gaps.md) → *Paper Job Tickets*.
- **Craft code is the routing key, and it is effective-dated.** Brian 39:23, 50:58: the craft code
  lives on the **employee**, flows onto the labor entry, and is **overridable on the entry**;
  effective dates matter *"because they may transition from one craft code to another and it needs
  to know when the labor happened and what the craft code was during that period."* **Union →
  non-union on a single entry does not happen** — Corrina 40:36: *"No, that doesn't happen."* That
  is a clean negative and worth keeping: the override is within-union (apprentice step, group), not
  across the union boundary.
- **What is missing:** the California hourly rules themselves (Corrina 39:19 offered to send them,
  Brian 39:23 says he already has — nothing in the vault is confirmed as that set beyond
  [non-union-hourly-rules-2026-09-07.md](non-union-hourly-rules-2026-09-07.md)); how salaried payroll reaches ADP;
  whether work-order labor is priced by the same engine; how billable yard/mechanic hours reach a
  job ticket for invoicing; and the whole shop/maintenance structure, which Kyle 46:49 calls *"a
  whole other beast when we get to that point."*
- **Sources checked:** [rules/PAY-012-non-union-hourly-rate.md](rules/PAY-012-non-union-hourly-rate.md),
  [PAY-013](rules/PAY-013-non-union-salary-rate.md) (*scope open*), [PAY-009](rules/PAY-009-payroll-group-classification.md),
  [PAY-008](rules/PAY-008-effective-dated-configuration.md); [non-union-hourly-rules-2026-09-07.md](non-union-hourly-rules-2026-09-07.md);
  [fcc-employee-types-and-crafts.md](fcc-employee-types-and-crafts.md); [erp-payroll-module-frd/](erp-payroll-module-frd/INDEX.md) — field/union
  throughout; `grep -rn -i 'work order' .ai/aidlc/SCRUM-*/spec.md` — nothing on work-order payroll.
- **Blocked:** nothing today, but it bounds what the parallel run can prove — matching Brian's app
  on field labor says nothing about two of the three populations.
- **Owner:** TCG — Corrina Bustos for the California hourly and salaried rules; Kyle Harlow for the
  shop and yard structure; CodingCops to decide whether work-order labor runs through the same
  pricing engine.

- Update 2026-09-28 (ADP Integration Sync, [../meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md](../meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md) §1.4, §2): how the other populations reach ADP today. **Three worksheets a week:** (1) a **salary sheet** covering all office/admin staff, salaried *and* hourly, keyed by Corrina with PTO, sick, bereavement, on-call and subsistence; (2) a **time-off worksheet** for those who qualify, added by hand every week; (3) the **field worksheet** from the CSV, which carries **union field and non-union yard** employees. **Union employees get no PTO or sick leave.** Salaried staff are not in FCC at all (*"factored … into the burden rate"*). Corrina called whether the new ERP holds them *"an ownership question"*. **Phase 1 was stated as union field employees only** (abdulrehman 42:42, Brian *"I think so"*), with union mechanics excluded as well (1:07:43), and everything else stays with Corrina in ADP. Whether the ERP tracks PTO depends on how far the HR module goes, which is Ehtesham's call. The work-order population is not addressed.

## The before-midnight bucket rule — we were given it, we had it right, and `ad9041bc` changed away from it

- **Status:** open
- **Asked:** 2026-09-11 — checking whether Corrina Bustos' 2026-09-10 correction had been available
  to us beforehand. **It had been.** No TCG person ever said it out loud, but the rule was in a
  source this register cites, the engine once implemented it correctly, and a fix on 2026-09-09
  changed away from it.
- **The rule, first stated 2026-09-10.** Corrina Bustos, 16:33: *"if they start on overtime before
  midnight, they have to work 12 hours of OT and then everything else is doubled. **They don't, it
  doesn't start over at 6 A.M.**"*; 17:22: *"That 6 A.M. rule is a wash and the 12 hours of overtime
  rule hits."* A 22:00→14:00 shift is **12 OT + 4 DT**, with **no straight time at all**.
- **Never *stated* — but given to us, in a source this rule already cites.**
  [legacy-payroll-app-db-extract/rules-plain-language.md](legacy-payroll-app-db-extract/rules-plain-language.md) §2 is listed as the **Legacy
  engine** source on [PAY-022](rules/PAY-022-daily-straight-time.md),
  [PAY-023](rules/PAY-023-daily-overtime.md) and [PAY-024](rules/PAY-024-daily-double-time.md), and it
  states the rule: cumulative hours count **from the shift's actual start**, *"a shift that crosses
  midnight keeps counting"*; slices 1–16 → ×1.0, 17–24 → ×1.5, 25+ → ×2.0; and *"any slice starting
  before 06:00 or at/after 17:00 → **at least** ×1.5"*. For 22:00→14:00 that yields **12 OT + 4 DT**
  — Corrina's answer. The parameters are machine-readable in the same extract:
  `cfg.Union_Master_Rules` row 1, L12, `Standard_Start_Time 06:00 · Standard_End_Time 17:00 ·
  Standard_Hours_Daily 8.0 · DoubleTime_Threshold_Daily 12.0 · OT 1.50 · DT 2.00`
  ([config-values.md](legacy-payroll-app-db-extract/config-values.md)) — extracted from TCG's production engine, not
  inferred. The MLA points the same way without settling it: *"Eight (8) consecutive hours shall
  constitute a day's work, **between the hours of 6:00 A.M. and 5:00 P.M.**… All overtime work
  performed outside of regular working hours shall not be less than one and one-half"*
  ([mcog-l12-mla-2025-2028/01-article-iii-working-rules.md](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md) Art. III §1) — a shift beginning
  at 22:00 never has its day's work inside that window.
  **So the honest statement is not that we lacked the rule. We had it, we implemented it, and we
  changed away from it** — see the table below: before `ad9041bc` the engine returned Corrina's
  answer for the before-midnight case.
- **What was genuinely missing was the *reconciliation*, and it still is.** The legacy formula
  reaches 12 OT + 4 DT by a different mechanism from Corrina's words: for the engine the first eight
  cumulative hours *are* the ST bank, merely floored to ×1.5 for falling outside the window; for
  Corrina a before-midnight start categorically forfeits straight time. The two disagree on
  04:00→23:30 — the legacy formula gives **6 ST** where Corrina confirmed **8 ST** (24:16–24:49) —
  which is precisely the case `ad9041bc` was written to fix.
- **PAY-019 is not this rule, and reading it as such is the trap.**
  [rules/PAY-019-cross-midnight-processing.md](rules/PAY-019-cross-midnight-processing.md) governs *day type* across 00:00
  (weekday → Saturday/Sunday/holiday), settled by Corrina 2026-09-04. It says nothing about ST/OT/DT
  bucket assignment, and `grep -rn -i "before midnight" .ai/vault/` returns nothing outside the
  2026-09-10 ingest. **Nor was it clear to TCG's own people** — Brian Petros and Abdul Rehman
  modelled the shift as 8 OT + 4 ST + 4 DT on the call; Kyle Harlow 16:13: *"that's the rule that I
  missed and I apologize"*; Brian 16:30: *"Oh, I forgot about that."*
- **⚠️ Live divergence in shipped code.** `packages/payroll-engine/src/day-type.ts` →
  `bucketForSlice` has **no before-midnight branch**; its ladder is holiday → Sunday → special
  Saturday → `cumulative ≥ 12` → outside 06:00–17:00 → `stHours ≥ 8` → Saturday → ST. Run against
  the call's own worked examples:
  | Case | pre-`ad9041bc` | shipped today | Corrina 2026-09-10 |
  | --- | --- | --- | --- |
  | 22:00 → 14:00 (16 h) | **0 ST / 12 OT / 4 DT** ✅ | 4 ST / 8 OT / 4 DT ❌ | 0 ST / 12 OT / 4 DT |
  | 00:00 → 14:00 (14 h) | 2 ST / 10 OT / 2 DT ❌ | **6 ST / 6 OT / 2 DT** ✅ | 6 ST / 6 OT / 2 DT |
  | 04:00 → 23:30 (19.5 h) | 6 ST / 6 OT / 7.5 DT ❌ | **8 ST / 4 OT / 7.5 DT** ✅ | 8 ST / 4 OT / 7.5 DT |
  **`ad9041bc` (2026-09-09, *"give every shift a full straight-time allowance before daily OT"*)
  fixed two cases and regressed the third — the day before the client corrected exactly that case.**
  Its own commit message names the driver: *"the client's worked example… a 04:00-23:30 shift"*, and
  that example is the one Corrina confirmed. The fix is right for the cases it was built from; it
  gave shifts that begin before midnight a straight-time allowance the client says they never earn.
  **The process point, not the arithmetic one:** the change deviated from a cited rule source
  (§2 above, listed on PAY-022/023/024) on the strength of a single worked example, and shipped with
  **no decision note, no `processed.log` row, and no reflection** — `grep -rn "ad9041bc\|stHoursBeforeSlice" .ai/`
  returns nothing but this entry. Had the deviation been written down, the second case it moved would
  have had to be named.
  On a $80/h base that is 4 hours moved from ST to OT — **$160 per cross-midnight shift**, in TCG's
  favour, i.e. an **underpayment**.
- **What still has to be asked, because the call did not settle it.** Corrina stated a categorical
  rule (*started before midnight ⇒ no ST*), and the legacy engine implements a mechanical one
  (*outside-window slices are floored to ×1.5 but still spend the cumulative bank*). They coincide on
  22:00→14:00 only because 22:00 + 8 h lands exactly on 06:00. They diverge on, for instance,
  **23:00 → 13:00**: the legacy formula gives 1 h of ST at 06:00–07:00, Corrina's rule gives none;
  today's engine gives 5 ST. **Which of the two is the rule** determines the fix — a
  `startedBeforeMidnight` short-circuit, or making outside-window slices spend the allowance while
  the 04:00 case keeps its full eight. **Do not implement from this entry.** Put the 23:00→13:00
  case to Corrina; it is the one example that separates the two readings.
- **Sources checked:** [../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md](../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md) §1;
  [rules/PAY-019](rules/PAY-019-cross-midnight-processing.md), [PAY-021](rules/PAY-021-l12-standard-work-window.md),
  [PAY-022](rules/PAY-022-daily-straight-time.md), [PAY-023](rules/PAY-023-daily-overtime.md),
  [PAY-024](rules/PAY-024-daily-double-time.md), [PAY-027](rules/PAY-027-no-pyramiding.md);
  [legacy-payroll-app-db-extract/rules-plain-language.md](legacy-payroll-app-db-extract/rules-plain-language.md) §2 and `cfg.Union_Master_Rules`;
  `packages/payroll-engine/src/day-type.ts`, `calculate.ts:195-238`; commit `ad9041bc` (2026-09-09);
  the whole `decisions/` folder — no note on ST/OT bucket assignment by start time.
- **Blocked:** any payroll ticket that prices a shift starting before midnight, and the parallel-run
  comparison, which will now disagree with Brian's app on exactly these shifts.
- **Owner:** TCG — Corrina Bustos, one question (the 23:00→13:00 case). CodingCops owns the fix and
  the regression test once she answers.

## Cross-midnight OT carryover — the incumbent pays no ST after midnight, and the ERP now does the same

- **Status:** open — **built to the incumbent 2026-09-11, awaiting one human confirmation.**
- **Asked:** 2026-09-11 — a developer's question on a 22:00 → 14:00 shift; the rule was found in the
  incumbent's pricer while answering it. **Rules:** PAY-019, PAY-021, PAY-023, PAY-027.
- **Question:** a weekday shift runs past midnight and back into 06:00–17:00 on the next calendar
  date. Are those in-window hours straight time, or do they stay overtime? Confirm the incumbent's
  answer (**overtime**) is the rule and not an artefact.
- **What the incumbent does:** `Is_PrevDay_ST_Reentry_Block` in `usp_Run_Pricing_Engine` (extract
  `sql/app/usp_Run_Pricing_Engine.PROC.sql:1001-1011`, precedence `:1163`; still present in the
  2026-09-07 backup at `:1037`, `:1189`) forces ×1.5 on any slice of a weekday entry that falls inside
  06:00–17:00 on a later date than the entry's start, ranked below the 12-hour DT rung. Separately,
  all three `OT_Daily` branches require the slice to sit on the start date, so the 8-hour rung never
  fires after midnight either. The 2026-09-07 backup's payroll-facing narrative names it
  (`sql/api/v_UI_Payroll_LaborEntry_AppliedRuleDetail.VIEW.sql:140-160, 557-562`): *"Cross-midnight
  OT carryover: …h remained OT after re-entering the regular work window"*, with the comment
  *"UX-RULE-7 validated this against all 5,691 current pricing slices with zero multiplier
  mismatches."* Payroll has been reviewing and approving it — it is not dead code.
- **What the vault was missing:** the rule is in no `rules/PAY-###` file, not in
  [rules-plain-language.md](legacy-payroll-app-db-extract/rules-plain-language.md) §2 (which lists
  only > 8 h, > 12 h and outside-window), in [calculations.md](legacy-payroll-app-db-extract/calculations.md)
  only as a four-word mention (`:259`, *"prev-day ST re-entry block"*), and in no client message.
  The ERP engine did not implement it.
- **Worked example — 22:00 Tue → 14:00 Wed, 16.0 h, L12-G7 $69.66:**

  | | 22:00–06:00 | 06:00–10:00 | 10:00–14:00 | ST / OT / DT | hour-equivalents |
  | --- | --- | --- | --- | --- | --- |
  | ERP before 2026-09-11 | OT (outside window) | **ST** (fresh 8-h bank) | DT (> 12 h) | 4 / 8 / 4 | 24 |
  | Incumbent, and the ERP now | OT | **OT** (carryover) | DT | **0 / 12 / 4** | 26 |

  4 h × 0.5 × $69.66 = **$139.32 per shift**, which the ERP underpaid before the change.
- **ERP change (2026-09-11, not yet merged):** a carryover rung in `bucketForSlice` and
  `reasonForSlice` (`packages/payroll-engine/src/day-type.ts`), fed `afterStartDate` by
  `priceL12JobDay` and `explainSlices`; the review-panel reason reads *"Cross-midnight OT
  carryover"*. Regression tests in `calculate.spec.ts` / `explain.spec.ts`. Scoped as the incumbent
  scopes it: **weekday-start entries only, judged against the entry's own start date, never the
  chain's.** One consequence worth knowing: a chained second ticket that *starts* after midnight
  (e.g. 00:30) still earns ST from 06:00. In the incumbent that case is caught by the rest premium
  (PAY-045), not by this rule. Unchanged by design: the client's 04:00–23:30 example (8 / 4 / 7.5) and
  incumbent entry 80274, 07:30 → 06:30 (8 / 4 / 11). Non-union hourly is untouched, because it has no
  time-of-day window (PAY-012).
- **Recommended ask (Corrina Bustos, one line):** *"On a weekday night shift, 10 PM to 2 PM the next
  day, your Payroll App pays 6 AM–10 AM as overtime rather than straight time ('Cross-midnight OT
  carryover'). Is that the rule?"* A *no* reverts one line in `bucketForSlice`.
- **Sources checked:** both `usp_Run_Pricing_Engine` snapshots;
  `sql/calc/v_Calc_Pricing_Slices_API_Legacy_Pre51K.VIEW.sql:146, 231`;
  `v_UI_Payroll_LaborEntry_AppliedRuleDetail.VIEW.sql` (2026-09-07 backup);
  [rules-plain-language.md](legacy-payroll-app-db-extract/rules-plain-language.md) §2, §3;
  [calculations.md](legacy-payroll-app-db-extract/calculations.md) STEP D–E;
  [worked-examples.md](legacy-payroll-app-db-extract/worked-examples.md) D12;
  [client-message-findings.md](client-message-findings.md), the 2026-08-24 and 2026-09-04
  cross-midnight rows (none reaches the re-entry case); `grep -rn "re-entry\|reentry"` across `.ai/`.
- **Owner:** Corrina Bustos (confirmation); CodingCops (build).

## Cross-midnight day type — the 2026-09-04 decision assumes a per-slice flip that neither engine performs

- **Status:** open — **upward direction and the holiday minimum built 2026-09-11; only the downgrade
  direction remains.** See *ERP change* below.
- **Asked:** 2026-09-11 — found while checking the carryover entry above against both pricers.
  **Rules:** PAY-019, PAY-032, PAY-033, PAY-034.
- **Question:** the [2026-09-04 decision](../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md)
  settles the *rule*: after midnight the higher rate governs, and spilling into a holiday pays ×3
  plus the 8-hour minimum. It then concludes *"No config flip is required and no engine change is
  needed"*, on the reading that `CalendarDay` rates each slice by its own calendar day. **That reading
  holds for the test harness only.** Should the ERP rate day type per slice, as the decision assumes?
  And does "never a downgrade" also cover the opposite direction (Sunday or holiday into a weekday)?
- **Finding — the incumbent:** `usp_Run_Pricing_Engine` sets `Week_Day`, `Holiday_Name` and
  `Is_Special_Saturday` once per entry from `P.WorkDateDate` (extract `:915`, `:930-936`), and the
  slice `Day_Type` reads those (`:1116-1122`). That is one day type per entry, the start date's.
  `cfg.CrossMidnightDayTypePolicy` is read by exactly two objects,
  `test.v_CrossMidnight_DayType_Actual` and `test.usp_Test_CrossMidnight_DayTypePolicy`. Neither
  is the pricer. The view computes minutes from a ten-row case table
  (`test.Case_CrossMidnight_DayType`), never from pricing slices, so its passing cases say nothing
  about production. [calculations.md](legacy-payroll-app-db-extract/calculations.md) → *Cross-midnight
  day-type policy* states per-slice, but the proc does not implement it.
- **Finding — the ERP:** the same. `classifyDay(slices[0].workDate)` is computed once per entry
  (`packages/payroll-engine/src/calculate.ts:163`, `explain.ts:92-93`).
- **What prices differently from the decision today:**

  | Crossing | Per slice (the decision) | Both engines (per entry, start date) |
  | --- | --- | --- |
  | Friday → Saturday | ×1.5, higher if already OT/DT | OT, then DT at 12 h — **coincides**, and only because of the carryover rung above |
  | Friday → special Saturday (first Sat of June/Dec) | ×2 | weekday ladder, OT until 12 h — **underpaid** |
  | Saturday → Sunday | ×2 | ×1.5 until 12 h — **underpaid** |
  | Weekday or Sunday → holiday | ×3, plus the 8-h minimum | start day's rates, no minimum — **underpaid** |
  | Sunday or holiday → weekday | weekday ladder after midnight | start day's premium all shift — **above** per slice; the decision does not say whether that downgrade is intended |

- **Also not built:** the PAY-033 8-hour holiday minimum does not exist in the ERP engine at all.
  `calculate.ts` prices the ×3 bucket (`:295`); `guarantee.ts` exports only
  `applyDailyMinimumGuarantee` and `applyLongBoomMinimum`. The decision's calendar-date grouping has
  nothing to attach to yet.
- **Sources checked:** extract `sql/app/usp_Run_Pricing_Engine.PROC.sql:905-936, 1116-1122,
  1152-1167`; `sql/test/v_CrossMidnight_DayType_Actual.VIEW.sql`;
  `sql/test/usp_Test_CrossMidnight_DayTypePolicy.PROC.sql`;
  [data/test-results.md](legacy-payroll-app-db-extract/data/test-results.md) cases 1–8;
  `grep -rln CrossMidnightDayTypePolicy` over both SQL snapshots;
  `packages/payroll-engine/src/{calculate,explain,day-type,guarantee}.ts`.
- **ERP change (2026-09-11, not yet merged):** each slice is now priced under the **higher** of its
  start day's type and its own calendar day's type (`sliceDayType`,
  `packages/payroll-engine/src/day-type.ts`). That settles every *underpaid* row of the table
  above — Friday → special Saturday, Saturday → Sunday, weekday or Sunday → holiday — exactly as the
  decision rules. The PAY-033 / PAY-034 eight-hour minimum is built (`applyPremiumDayMinimums`,
  `guarantee.ts`): per employee per calendar date, summed across every entry and chain, at base +
  shift × the day's multiplier, on the entry holding the date's last slice. The *overpaid* row —
  Sunday or holiday → weekday — is **deliberately unchanged**: it keeps the start day's premium, as
  the incumbent pays today. Moving it to `CalendarDay` would cut pay against current practice on the
  strength of a premise (per-slice production pricing) that turned out false.
- **Still open — ask Corrina Bustos, one line:** *"A Sunday or holiday shift that runs past midnight
  into a weekday — do the hours after midnight keep the Sunday / holiday rate, or drop to the weekday
  rate?"*
- **Owner:** Corrina Bustos (the downgrade direction only); CodingCops (build) — done for the rest.

## Payroll engine verification 2026-09-11 — what was wrong, what changed, and two deliberate departures from the incumbent

- **Status:** open — **two confirmations owed** (items A and B below); everything else is built.
- **Asked:** 2026-09-11 — a verification pass of `packages/payroll-engine` against every quantified,
  reproducible case in the vault. **Rules:** PAY-019, PAY-023, PAY-025, PAY-026, PAY-032, PAY-033,
  PAY-034, PAY-040, PAY-012.
- **Baseline — 46 cases**, each run through `calculatePayPeriod` from source:
  16 `test.Case_CorePayrollScenario` rows and the D1–D9 traces
  ([worked-examples.md](legacy-payroll-app-db-extract/worked-examples.md)), the catalog rows with
  enough times to reproduce ([rule-examples-catalog.md](rule-examples-catalog.md)), Corrina Bustos'
  two 2026-09-04 long-boom days, Brian Petros' 43767 → 43770, the Garcia 43694 screenshot
  (client-message-findings 2026-09-09), the [2026-09-04 cross-midnight decision](../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md),
  and Brian's nine non-union scenarios ([non-union-hourly-rules-2026-09-07.md](non-union-hourly-rules-2026-09-07.md)).
  **`main` passed 30 / 46; the change passes 46 / 46.** The engine suite is 60 / 63 — the three
  failures are the PAY-043 boom tests in *payroll-engine test debt* §2, identical on `main`.
- **What was wrong on `main`, and the fix — every one traced to a written, human-settled rule:**

  | Defect on `main` | Source that settles it | Fix |
  | --- | --- | --- |
  | No holiday or special-Saturday 8-hour minimum at all; a 3.5 h holiday paid a PAY-040 half hour instead | Decision 2026-09-04 (Corrina); MLA Holidays §1, §4 | `applyPremiumDayMinimums` — per employee per calendar date |
  | Hours after midnight into a Saturday, Sunday, special Saturday or holiday priced at the start day's rate | Decision 2026-09-04 (a), (b) | `sliceDayType` — the higher of the two days |
  | A shift split over two tickets lost ST: 04:00–10:00 + 10:00–18:00 paid 6 / 6 / 2 instead of 8 / 4 / 2 | Corrina 2026-09-04: pre-06:00 OT keeps the 8 h bank, and the ladder runs across jobs | ST allowance carried across the chain as its own figure |
  | Weekday shift re-entering 06:00–17:00 after midnight paid ST | Incumbent `Is_PrevDay_ST_Reentry_Block` — see *Cross-midnight OT carryover* above | carryover rung |
  | New Year's Day missed whenever it falls mid-period (2027-01-01 is a Friday in the 2026-12-26 period) | PAY-032 calendar | `holidaysForPeriod` — start year and the next |
  | Non-union: daily 8 / 12 per **ticket**, no weekly OT, no seventh day, no reason on the component | Brian 2026-09-07 §4–§8, confirmed as source of truth the same day | `classifyNonUnionWeek` — workday, seventh day, then weekly; six reason-labelled PAY-012 components |

- **A — the holiday minimum and the 4-hour daily minimum do not stack.** On a holiday the
  incumbent runs `DAILY_MIN_4` and `HOLIDAY_MIN_8` independently (`usp_Apply_GuaranteedHours`,
  no exclusion between them), so 3.5 h on Thanksgiving pays 3.5 + 0.5 + 4.5 = **8.5** hours. The
  ERP counts the holiday top-up toward the four, paying **8.0**. Basis: both of Corrina's statements
  describe hours paid — *"Put 8 hours per day guaranteed on a holiday"*, *"a four-hour minimum per
  day or their true time"* (2026-06-11 demo, 19:11 and 19:16) — and the MLA's "minimum of eight"
  is a total. Only a holiday shift under 4 hours is affected. **Confirm with Corrina:** *"On a
  holiday worked for under 4 hours, is the pay 8 hours at triple time, or 8 at triple plus the
  4-hour-minimum top-up on top?"*
- **B — the special Saturday is the MLA's day, not the incumbent's.** MLA Holidays §4: *"the first
  (1st) Saturday following the first (1st) Friday"* — the 2nd–8th of June / December. The incumbent
  tests `DAY <= 7`. They differ only when the month opens on a Saturday — next **December 2029**
  and **June 2030** — where the contract's day is the 8th. Low urgency; confirm when convenient.
- **Seen and deliberately not touched:**
  - *PAY-043 boom tests* — test-debt §2 above says settle which side is wrong first.
  - *Boom adder multiplied per bucket* — matches the MLA and the incumbent (Garcia 43694 ties to
    the cent at $25.31); the flat reading is [a reference-only working decision](../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md).
  - *WTL* — Brian's update is pending; *meal thresholds per entry vs per stitched group* — open above.
  - *Guarantee hours have no ADP workbook column* (PAY-040's already, now PAY-033 / PAY-034's too) —
    [adp-workbook-column-rules.md](adp-workbook-column-rules.md) open questions.
  - *A holiday that falls on a period's first day (a Saturday)*: a Friday-night shift priced in the
    previous period that spills into it, plus a shift on the day itself, each earn a minimum —
    each period sees only its own entries. Rare; not modelled.
- **Not reproducible:** the Albergo week (2026-08-22 → 08-28) — the vault holds every bucket and
  premium but no entry times. `rest-period.spec.ts`'s Albergo-shaped fixture uses invented times and
  asserts a $522.45 day where the client's figure is $487.62; the gap is plausibly the invented first
  hour (the client row prices it at a normal ×1.0–1.5), but that cannot be judged without the times,
  which live in the restored `TCG_PayrollAPP_20260907` database.
- **Sources checked:** as listed in the baseline; `usp_Apply_GuaranteedHours.PROC.sql:175-215,
  330-372, 443-533, 600-700`; `usp_Run_Pricing_Engine.PROC.sql:905-1167`; MLA Article III Holidays
  §1, §4; `packages/payroll-engine/src/*`.
- **Owner:** Corrina Bustos (A, B); CodingCops (build — done).

## Mis-set payroll setup calculates and warns — the 2026-09-11 build instruction, unconfirmed by TCG

- **Status:** open — **built 2026-09-11 on a CodingCops instruction; TCG payroll has not confirmed it.**
- **Asked:** 2026-09-11 — instruction in the payroll build session: setup applied in the wrong place
  (the example given: a non-union craft on a union employee) must **warn on the frontend while it is
  entered**, and **payroll must calculate it and warn, not error**. **Rules:** PAY-009, PAY-014,
  PAY-029, PAY-060.
- **What was built (not yet merged):**
  - **One rule set,** `payrollSetupWarnings` / `craftSetupWarnings` in `@tcg/shared`
    (`packages/shared/src/utils/payroll-setup-warnings.ts`), used by the forms and the engine so the
    screen that sets a value and the week that pays it say the same thing: union craft on a
    non-union group, non-union craft on a union group, mechanic craft on the field group and the
    reverse, a craft that disagrees with the employee's Union Status, a non-union craft with no
    hourly rate, an inactive craft; and for a craft itself, the MLA classifications (Groups 1–2
    oiler, 3–8 operator, 9 operator or HDR), a union craft with no wage group, a non-union craft
    with one.
  - **Frontend, warn-never-block:** the employee form (Payroll & Rates), the employee's Manage
    Craft Code card (current primary, and the craft being assigned), and the craft-code form. The
    `WarningList` molecule is the amber sibling of `ErrorAlert`.
  - **Payroll:** the rate resolver no longer blocks two mismatch cases — a craft the employee is
    not assigned (was `SECONDARY_NOT_ASSIGNED`, priced $0) and an inactive craft (was
    `CRAFT_INACTIVE`, priced $0). Both now price at the craft's own rate and raise
    `CRAFT_NOT_ASSIGNED` / `CRAFT_INACTIVE` as warnings. The engine raises the group/craft
    mismatches as warnings on the week. `OVERLAPPING_LABOR` displays as a warning. A flagged week is
    still approvable — none of these blocks anything.
  - **Still errors, deliberately — there is nothing to price with:** `NO_PRIMARY_CRAFT`,
    `CRAFT_NOT_FOUND`, `NO_RATE_IN_FORCE`, `NO_EMPLOYEE_RATE`, `NO_ACTIVE_MODIFIER_SCALE`.
- **The tension:** [PAY-014](rules/PAY-014-rate-comparison-and-validation.md) (conflicted) holds that a
  blocked resolution *"prices at a flat $0 … instead of quietly substituting"* a plausible rate. Pricing
  at the dispatched craft's own configured rate is not a guessed rate — but it does pay an employee a
  craft they are not assigned, or a craft someone deactivated.
- **Question for Corrina Bustos / Brian Petros:** *"When a job is worked on a craft the employee is not
  assigned, or on an inactive craft, should payroll pay it at that craft's rate and flag the week for
  review — or hold it at $0 until someone corrects it?"* A *hold* reverses two branches in
  `craft-rate-resolver.service.ts`.
- **Sources checked:** `apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts`
  (before/after), `usp_Run_Pricing_Engine` (no equivalent rule — the incumbent prices the craft on the
  labor row), [non-union-hourly-rules-2026-09-07.md](non-union-hourly-rules-2026-09-07.md) §11 (*flag,
  don't silently produce*), *The union-classified employee who must not be paid on union rules* above.
- **Owner:** Corrina Bustos / Brian Petros (confirm); CodingCops (build — done).

## Mis-set payroll setup calculates and warns — no longer an error or a $0 entry

- **Status:** open — **built 2026-09-11 on a build-session instruction; needs TCG payroll to confirm**
  the two pricing changes (items 1–2), because they change what an unassigned-craft day pays.
- **Asked:** 2026-09-11 — instruction in the payroll build session: *"payroll should not give error
  if he is apply then just calculate them instead of giving error, just give warnings"*, and warn in
  the UI whenever something is applied in the wrong place (*"like applying non-union craft code to
  union employee"*). **Rules:** PAY-009, PAY-014, PAY-029.
- **What changed:**
  1. **A craft the employee is not assigned** (was `SECONDARY_NOT_ASSIGNED`: entry priced $0 + error)
     is now priced at **that craft's own rate** with warning `CRAFT_NOT_ASSIGNED`.
  2. **An inactive craft** (was `CRAFT_INACTIVE`: $0 + error) is priced at its rate with warning
     `CRAFT_INACTIVE`.
  3. **Group-versus-craft mismatches** — union craft on a non-union group, non-union craft on a union
     group, mechanic craft on the field group and the reverse — price as the group says and raise a
     warning on the week. One definition, `payrollSetupWarnings` in `@tcg/shared`, drives the
     warning on the employee form, the employee's craft card, the craft picker dispatch uses, and the
     payroll week. The craft-code form warns on MLA-classification mismatches (`craftSetupWarnings`:
     Groups 1–2 oiler, 3–8 operator, 9 operator/HDR; union craft without a group).
  4. **Overlapping labor** shows as a warning, not an error — both entries were always priced.
  5. **Only an entry priced at $0 flags a week** (a rate that could not resolve, `RATE_*`). Every
     other issue — including a missing ADP file number — leaves the week `NEEDS_REVIEW` with the
     warning listed, and the calculate summary reads *"N warning(s) to review"*, errors counted
     separately.
- **Still errors, deliberately** — each is missing data, not a mis-set value, and there is nothing
  to calculate with: no rate in force for the craft on the date, a non-union craft on an employee
  with no hourly rate, no primary craft and no job craft, a craft or employee that no longer exists,
  no boom-modifier scale for the tenant, and a missing ADP file number (export cannot run).
- **Why items 1–2 are consistent with the record:** the [2026-08-20 craft-locked rate
  decision](../decisions/2026-08-20-craft-locked-rate-override.md) locks a day's rate to a
  **craft-code amount chosen by the superintendent or payroll**, never a free-text override. Pricing
  the craft dispatch actually put on the allocation keeps that; requiring it to be pre-listed as an
  employee secondary was stricter than the decision. PAY-014's *"prices at a flat $0 … instead of
  quietly substituting … any other plausible-looking guessed amount"* is not engaged: nothing is
  guessed, the rate is the dispatched craft's own.
- **Ask (Corrina Bustos / Brian Petros, one line):** *"When a job is dispatched on a craft the
  employee isn't set up for, or on an inactive craft, should payroll pay that craft's rate and flag
  it for review, or hold the entry at $0 until someone corrects it?"*
- **Sources checked:** `apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts`
  (before and after); `rules/PAY-014-rate-comparison-and-validation.md` (`status: conflicted`);
  the 2026-08-20 decision above and its 2026-08-25 union-scope reading;
  `gaps.md` → *The union-classified employee who must not be paid on union rules* (why no
  combination can be rejected outright).
- **Owner:** Corrina Bustos / Brian Petros (confirmation); CodingCops (build — done).

## Holiday shift-start continuation and the 8-total-vs-8-additional minimum — ✅ CLOSED 2026-09-12; guarantee hours count toward the 12-hour mark

- **Status:** closed — all three questions answered; the engine change is the open item, tracked
  under the audit's A4 and the decision note
- **✅ Question 3 confirmed 2026-09-12.** Corrina Bustos, on the 10pm–10am version (8 TRI / 4 OT /
  6 DT): *"hello, yes your example is correct."* The guaranteed holiday hours advance the 12-hour
  double-time mark. **Brian Petros was on the message** and has the ruling; his app's 8 TRI + 10 OT
  is now the one that needs to move.
- **Asked:** 2026-09-11 — the first by Corrina Bustos herself on the 2026-09-10 call (34:02, 34:10:
  *"I'll double check with our rep"*); the second raised by Brian Petros in writing the same day as
  *"a bit controversial"*.
- **✅ Answered 2026-09-12 by the union business agent, relayed in writing by Corrina — decision note
  [../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md](../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md).** Worked breakdown for holiday 22:00 → 06:00: *"10pm-12am- 8 hours Triple / 12am-4am-
  4 Overtime / 4am-6am- Dbl time… it follows the same 12 hours working then double time pay rule.
  Because they started on a prior date so after midnight would start at the applicable rate."*
  **Q1 — reverts at midnight**, continuous shift preserved; no holiday shift-start rule. Brian's
  structure confirmed, reading (a). **Q2 — 8 hours total**: 2 worked → 8 TRI. Brian's flag answered
  his way.
- **⚠️ Question 3, opened by the same breakdown — the guaranteed holiday hours count toward the
  12-hour double-time mark.** DT at 04:00 on six actual hours is only reachable as 8 guaranteed +
  4 OT = 12. That contradicts Brian's written concept of 2026-09-11 (*"That guarantee is not worked
  time. It should not advance OT/DT thresholds"*), his app (8 TRI + 10 OT on a 22:00→10:00), the
  legacy `Gap_*` design, and the ERP. **Money:** $240.00 per 22:00→10:00 shift at $80 (6 h DT vs
  OT). **Scope the BA did not rule on:** whether the guarantee hours also advance the 8-hour rest
  trigger (client has twice said no), weekly OT, or meal spans — leave those on Brian's reading
  until asked. **Owner:** Brian Petros needs to see the ruling and reconcile his app; CodingCops
  owns the engine change.
- **⚠️ Engine defect surfaced by running her example against `015136f79`:** yesterday's A4 fix
  (`bucketForSliceAnchored` = `max(anchor day type, slice day type)`) floors a holiday-start shift
  at ×3 for every post-midnight slice — the exact rule the BA ruled out — and then adds the 6-hour
  top-up on top. **22:00→06:00 pays 14 TRI = $3,360.00 against the BA's $2,720.00; 22:00→10:00
  pays 18 TRI = $4,320.00 against $3,360.00.** Overpays. The never-downgrade principle applies to
  the cumulative-hours bucket, not the anchor day's premium; post-midnight slices must price as
  `max(cumulative bucket, own calendar day type)`. Audit A4 reopened.
- **Question 1 — does a shift that starts on a holiday stay at the holiday rate after midnight?**
  Worked case sent to Corrina: Wed Nov 11 (Veterans' Day) 22:00 → Thu Nov 12 10:00, one job, full
  rest before. Two readings: **(a) 8 TRI + 10 OT** — the 2 holiday hours top up to 8 TRI, the
  Thursday hours price as a weekday, and because the shift started before midnight there is no ST
  and OT runs to the 12-hour mark, which lands exactly at 10:00; **(b) 12 TRI** — a *holiday
  shift-start* rule keeps the whole continuous shift at the holiday rate. **Brian Petros, in
  writing, chooses (a)** as what his app does and what the ERP should do — *"split the worked
  timeline at midnight for day-type pricing while preserving the continuous shift for OT/DT
  accumulation"* — and names (b) as the one thing the rep must rule in or out: *"whether the
  agreement contains a special rule stating that a shift that begins on a holiday remains at the
  holiday rate for the entire continuous shift even after midnight."* Corrina has not answered.
  **Money:** at an $80 base, (a) pays $3,120.00 and (b) $2,880.00 — (a) is the *higher* figure,
  because the six phantom guarantee hours sit on top of ten real OT hours.
- **Question 2 — is the holiday minimum 8 hours *total* or 8 hours *additional*?** Brian: *"8
  hours total, not 8 additional hours. If 2 hours were actually worked on the holiday, PayrollAPP
  adds a 6-hour guarantee/top-up."* Corrina, 2026-09-04, verbatim: *"owed an **additional** 8 hours
  at triple time as the rule is that the ee is owed a minimum of 8 hours"* — the two halves of her
  own sentence point different ways. **Every engine implements "total"**: the ERP
  (`packages/payroll-engine/src/guarantee.ts` → `applyPremiumDayMinimums`, top-up = 8 − hours
  worked that date), the legacy `HOLIDAY_MIN_8`, and Brian's app. **Money:** $480.00 per
  spill-over at an $80 base (2 TRI hours), and it also changes Question 1's (a) from 8 TRI to
  10 TRI. Corrina to confirm which she meant; the MLA's *"a minimum of eight (8) hours at triple
  (3) time… shall be paid for all work performed… on the following holidays"* reads as a floor,
  i.e. total.
- **Settled on the way, by Brian in writing and consistent with the vault:** the guarantee hours
  are **not worked time** and do not advance OT/DT, rest or WTL (why (a) is 10 OT and not
  4 OT + 6 DT); midnight changes day type without breaking the continuous shift; long-boom pay
  never decides the bucket. All three scenarios sent to Corrina — whole shift on the holiday
  (19.5 TRI), 2-hour spill-in (1 ST / 7 OT / 8 TRI), and the holiday start — *"look correct"* to
  him against the app.
- **Update 2026-09-11 — Brian's structural recommendation for the ERP, and where the engine already
  has it.** In writing: *"I recommend keeping these as separate concepts: (1) actual worked-hour
  timeline and continuous-shift accumulation; (2) calendar day type for each worked segment
  (weekday, Saturday, Sunday, holiday, etc.); (3) ST/OT/DT/TRI controlling multiplier for each
  worked segment; (4) holiday 8-hour minimum as a separate guarantee/top-up component; (5) long-boom
  and other applicable rate modifiers on only the qualifying work segments. That structure is
  consistent with how our current Payroll App is designed and prevents the holiday guarantee from
  accidentally affecting worked-hour calculations."* **The ERP engine is already built on exactly
  these five separations** — `packages/payroll-engine/src/`: (1) `slices.ts` builds the half-hour
  timeline; `calculate.ts` carries `cumulative` / `startingCumulative` across a chain, with the
  8-hour chain break in `explain.ts` (`CHAIN_GAP_MS`); (2) `day-type.ts` classifies each slice by its
  own calendar day, and `bucketForSliceAnchored` (branch `fix/timezone-business-day`) applies the
  anchor-floor so a day-type change never downgrades; (3) `bucketForSlice` + `multiplierOf` give one
  controlling bucket per slice — PAY-027 no-pyramiding; (4) `guarantee.ts` →
  `applyPremiumDayMinimums` emits the holiday/special-Saturday minimum as its own `PayComponent`,
  measured per calendar date, never as worked hours, and `rest-period.ts:79` explicitly keeps
  guarantee hours out of the rest trigger; (5) `boomWindows` / `sliceIsOnBoom` in `calculate.ts`
  attach the adder only to slices fully inside a captured build-up/work/breakdown window (PAY-043).
  So this is **confirmation of the architecture, not a change request**. The one place the engine
  and his description diverge is inside (1)+(3): the before-midnight ST-allowance regression
  (`ad9041bc`) — see *The before-midnight bucket rule* entry above — which is a bucket-assignment
  defect, not a structural one.
- **Sources checked:** [../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md](../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md) §4;
  [../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md) (now carries a
  wording caveat); [rules/PAY-033-holiday-pay.md](rules/PAY-033-holiday-pay.md), [PAY-019](rules/PAY-019-cross-midnight-processing.md),
  [PAY-040](rules/PAY-040-work-provided-minimum.md); [mcog-l12-mla-2025-2028/01-article-iii-working-rules.md](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md) → *Holidays* §1;
  [legacy-payroll-app-db-extract/rules-plain-language.md](legacy-payroll-app-db-extract/rules-plain-language.md) §7; `guarantee.ts`, `rest-period.ts:79`.
- **Blocked:** nothing today — the ERP already implements reading (a) and "total". If the rep
  confirms a holiday shift-start rule, `bucketForSliceAnchored` needs a HOLIDAY-carries-forward
  branch; if Corrina meant "additional", `applyPremiumDayMinimums` changes from `8 − worked` to
  `+8`. Both are small; both are money.
- **Owner:** Corrina Bustos, via the union rep for Question 1; Corrina alone for Question 2 — it
  is her sentence.

## PAY-069's rounding-adjustment component — architecturally inapplicable to this engine

- **Status:** resolved 2026-09-11 — answered from the record, no client question needed.
- **Asked:** 2026-09-11 — the implementation-audit's B7 item (`payroll/implementation-
  audit-2026-09-11.md`), reprising `rules/PAY-069-money-rounding-and-rounding-adjustment-
  components.md` (`status: open`).
- **Question:** should this engine insert a `PAY_COMPONENT_ROUNDING_ADJUSTMENT` ledger line
  the way the legacy `usp_Normalize_PayComponentLedger_Rounding` /
  `usp_Finalize_PayComponentLedger_Reconciliation` do?
- **Why it does not apply here:** the legacy line exists because the incumbent computes a
  day's total TWO independent ways — an aggregate `Pay_Actual_Gross`/`Final_Gross_Pay`
  formula, and the sum of individually-`ROUND(x,2)`'d ledger rows — and the two can disagree
  by a cent or more, so a reconciling row forces them to agree
  (`legacy-payroll-app-db-extract/rules-plain-language.md` §14). This engine only computes a
  day's total ONE way: `addComponent` (`money.ts`) rounds every component to cents at the
  moment it is created, and `CalculatedJobDay.totalAmount` (`calculate.ts`, the final
  "restate every touched day's total from its ledger" pass) is always exactly
  `round2(components.reduce(sum amount))` — the same already-rounded numbers the caller
  sees. There is no second, independently-computed figure to disagree with, so a rounding
  adjustment can never be non-zero, and `addComponent`'s own zero-amount filter would drop
  it every time. Adding the component would be dead code standing in for a bug this
  architecture cannot have.
- **Sources checked:** `packages/payroll-engine/src/money.ts` (`addComponent`, `round2`);
  `calculate.ts` (`priceL12JobDay`'s `totalAmount`, and the per-employee loop's final
  totals-restate pass); `rules/PAY-069-...md`; `legacy-payroll-app-db-extract/
  rules-plain-language.md` §14 and `calculations.md:2774-2943` (`usp_Normalize_
  PayComponentLedger_Rounding`, `usp_Finalize_PayComponentLedger_Reconciliation`).
- **Owner:** none — closed by inspection, not awaiting a client answer. Revisit only if the
  engine is ever changed to compute a day's total by a second, independent formula.

## WTL scenarios `#2` and `#3` — TCG resumes internally Monday 2026-09-14; the app's WTL messages are provisional

- **Status:** open — pointer; the substantive questions live under *Field-ops lunch capture vs
  payroll WTL* and the `#1` workbook entry above.
- **Asked:** 2026-09-13 — Brian Petros, FYI with screenshots of his app's *Lunch / WTL Review* and
  *WTL Code Review* warnings: *"that screenshot above shows some wild notes about WTL... but that
  is because we are still in discussions about how to properly handle all the various types of WTL
  scenarios. We have an internal scheduled meeting on Monday to continue our discussions on this."*
- **What it means:** anything his app currently says about WTL — the `WTL_0` fallback warnings,
  the *"multiple or conflicting WTL tokens"* review flags, the `WTL ±0.5` rule adjustments visible
  on the labor rows — is **not yet a rule** and must not be read as one from a screenshot or from
  the 2026-09-07 backup. The `#1` (all breaks taken) method is client-confirmed; `#2` (all breaks
  worked) and `#3` (some taken) are what Monday is for. The written `#1` instructions are still
  owed. Expect a further app copy after Monday.
- **Owner:** Brian Petros / Corrina Bustos, internal, 2026-09-14.

## Added hours — which rules' phantom hours reach which thresholds? Brian vs the union BA

- **Status:** open
- **Asked:** 2026-09-11 (Friday), Brian Petros in writing — the same message as his five-concept list, so the objection predates Corrina's 12 September confirmation; logged here 2026-09-13 — contesting ruling (c) of
  [../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md](../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md)
  and widening it: *"it depends on if the employee 'actually' worked those hours."*
- **Question:** For each payroll rule that **adds hours the employee did not work**, do those hours
  advance any threshold? Brian's answer is a flat no for all of them: *"That guarantee is not
  worked time. It should not advance OT/DT thresholds, rest calculations, WTL, etc. It is
  effectively a separate pay component."* The union BA's breakdown, confirmed by Corrina, says
  yes for one cell of the grid. Nobody has filled in the rest.
- **The grid — what is decided (✅), what the engine does today, and what is open (?):**
  | Added hours from… | 12-hour DT rung | 8-hour rest trigger | Weekly 40 | Meal spans |
  | --- | --- | --- | --- | --- |
  | **Holiday / Special-Saturday 8-h minimum** | ✅ **yes** — union BA via Corrina 2026-09-12, confirmed on 22:00→10:00; **contested by Brian 2026-09-11, before that confirmation**. Engine: yes (`premiumDayTopUpHours`) | ✅ **no** — Brian, verified into the log 2026-08-24 (send date unrecorded; *"added hours would not affect the 8-hour rest rule"*) and restated verbatim 2026-09-11 (*"a separate pay component"*), unopposed; engine: gap measured from the actual end, trigger reads actual OT/DT slices only (`rest-period.ts:79-85`, `:137`) | ? Engine: no | ? Engine: no |
  | **Daily 4-h minimum** (PAY-040) | ? — never asked. Engine: no | ✅ **no** — same statement; **Brian's 2026-09-13 scenario** (3 h worked + 1 h minimum, then exactly 8 h off → rest *not* forced) is exactly this cell, and the engine already does it his way | ? | ? |
  | **Long-boom 4-h minimum** (PAY-043) | ? Engine: no | ? Engine: no | — | — |
  | **WTL penalty half-hours** — 2nd+ missed meals (PAY-047) | ? — already registered: *do WTL added hours count toward the rest chain's 12-hour threshold*. Engine: no | ? Engine: no | ? | n/a |
  | **Shift hours-add** +1.0 / +1.5 (PAY-036/037) | placed at shift end, so moot within the shift. Engine: no | ? Engine: no | ? | — |
- **Brian's 2026-09-13 worked scenario, and where it lands:** *"Employee works for 3 hours. That
  labor entry gets the 4-hour minimum applied… Now, let's say that there is an 8-hour gap between
  labor entry #1 and the next labor entry… So the next labor entry does not have the '8-hour
  rest' rule applied???… or should it?… even though the employee did not work that extra hour."*
  That is the **rest-trigger column**, not the 12-hour rung — and it is **already settled his
  way, by him**: his statement (logged 2026-08-24, restated 2026-09-11) that added hours do not affect the rest rule, built
  into `rest-period.ts` (gap from the actual end of the last slice; trigger reads actual OT/DT
  slices; guarantee hours are components and cannot reach either). The 8-hour gap in his example
  is measured from the 3-hour mark, so rest is *not* forced. The same holds for WTL penalty adds
  and the shift hours-add. **The BA's ruling did not touch this column and the engine change did
  not generalise it** — one cell moved, and it is not this one.
- **Brian, 2026-09-13, after being told the ERP keeps added hours out of worked time everywhere but
  the 12-hour rung:** *"You also bring up a good point about ADP reported hours. I don't think I
  have discussed this enough with Corrina. That would be a good one to discuss in our next
  meeting."* So the practical question is now **agenda'd for the next payroll call**, and it is
  the right one: not whether phantom hours are "worked" inside the engine, but **how they reach
  ADP** — folded into the REG/OT/DT/TRI hours columns (which is what "claims the employee was
  working" in the record that matters), or as their own earning codes. **What the engine does
  today:** the export ([`xlsx-rows.ts`](../../packages/payroll-engine/src/xlsx-rows.ts)) sends
  `totalHrs = actualHours` and the five worked-hour buckets plus boom hours; **the guarantee
  top-ups, rest premium, WTL adds and the shift hours-add have no hours column at all** — their
  money is in `totalAmount` via components, but no hours ride with it. So the ERP already does
  not report phantom hours as worked to ADP, by omission rather than by design, and the dollars
  currently have nowhere to land. That is gaps **D-002 (guaranteed hours), D-003 (rest premium),
  D-004 (WTL/meal premium)** — the ADP codes TCG has owed since August — seen from the other end.
  The legacy app folds them in: holiday gap hours *"reported as DT hours"*, daily-minimum gap
  added to `Pay_Total_Hrs`. **For the meeting:** the ERP can report added hours under separate
  codes if ADP has them; Corrina's answer on D-002/3/4 is the same answer as Brian's question.
  **Asked of Corrina, 2026-09-13 (Haris → Brian, Teams):** bring a real ADP week with a
  guaranteed-hours entry in it, so the meeting can see which columns those hours land in today.
  The ERP-side rows (3 h + 1 h minimum → export `ST 3`; holiday 22:00→10:00 → export
  `OT 4 · DT 6 · 3X 2`, six top-up hours in no column) are on record here for the comparison.
- **The distinction that matters, which neither side has stated:** *counting toward a threshold*
  and *being reported as worked* are different things, and the ERP already separates them.
  Every phantom hour is its own pay component; `actualHours`, the timesheet, certified payroll and
  ADP carry worked time only; the holiday top-up touches exactly one thing — the ladder's 12-hour
  counter — because the BA's 8 + 4 = 12 arithmetic requires it. Brian's legal concern (*"claiming
  that the employee was working when the employee was actually not"*) is therefore already met.
  What is left is purely which cells of the grid above are "yes", and that is the union's and
  Corrina's to say, not a modelling choice.
- **Money:** the one decided cell is worth $240 per 22:00→10:00 holiday start at $80 (6 h DT vs
  OT). The undecided cells are mostly moot within a shift (adds land at the end) and bite only on
  weekly OT and rest — small per occurrence, but they decide whether the parallel run against
  Brian's app can ever match on those weeks.
- **Sources checked:** the decision note; [rules/PAY-033](rules/PAY-033-holiday-pay.md),
  [PAY-040](rules/PAY-040-work-provided-minimum.md), [PAY-043](rules/PAY-043-long-boom-premium.md),
  [PAY-045](rules/PAY-045-rest-period-premium.md) (the "added hours would not affect the 8-hour
  rest rule" client statements), [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md),
  [PAY-036](rules/PAY-036-second-shift.md); `packages/payroll-engine/src/{guarantee,rest-period,
  calculate}.ts` as of `6491b6db8`; the existing entry *Do WTL added hours count toward the rest
  chain's 12-hour double-time threshold*.
- **Blocked:** the engine change for the decided cell is built and tested. Nothing else should be
  built from this entry. **The parallel run will diverge from Brian's app on every holiday-start
  shift until he adopts the ruling or Corrina reverses it.**
- **Put to both, 2026-09-13 (Haris, Teams):** the arithmetic stated plainly — *"Double time
  starting at 4am is only reachable if the 8 guaranteed hours count toward the 12 — at 4am the
  employee has actually worked 6. That's the only place we treat added hours as reaching a
  threshold. Everywhere else the engine does what you describe."* — and one question to Corrina:
  *"the 8-hour holiday minimum reaches the 12-hour double-time mark, but is not otherwise treated
  as time worked?"* Awaiting her answer.
- **See also (2026-09-14):** Brian's holiday-guarantee workbook — [*Holiday-start guarantee — Brian's 2026-09-14 workbook…*](#holiday-start-guarantee--brians-2026-09-14-workbook-calls-the-union-reading-a-1440-overpayment-and-prices-the-post-midnight-hours-at-triple). It widens his objection beyond ruling (c) to ruling (b), and does not settle this entry.
- **Owner:** Corrina Bustos — to re-confirm (c) with the arithmetic in front of her and Brian's
  objection on the table, and to fill the rest of the grid with the BA if he will; Brian Petros
  to align his app or to make the case to Corrina, not to us.

## Higher rate for the day (MLA Art. IV-C) — never walked through with TCG

- **Status:** open
- **Asked:** 2026-09-17 — raised by Brian Petros in his [written note after the 2026-09-15 demo](crew-assignment-and-rate-derivation-brian-2026-09-16.md)
  (point 5, with a proposed 5-step order); logged by Syed Haris while drafting the reply.
- **Question:** Article IV-C says that when an employee works at a higher rate than the minimum at
  any point in a calendar day, *"the higher rate of pay shall apply on all time worked during that
  day"*, except the long-boom increment (IV-B-2), which stays on boom hours with the 4-hour
  minimum; Art. III-I.5 says something similar per job. Which rates propagate (base craft rate
  only, a secondary craft picked on an allocation, lattice or other adders)? Does it propagate to
  the whole day or only to hours on that job? Brian's proposed order: classify each segment →
  premiums/overrides → highest rate reached that day → apply the higher-day rule → ST/OT/DT.
- **Sources checked:** [rules/PAY-015](rules/PAY-015-higher-rate-for-day-job.md) (`open`,
  "union/legal interpretation required"); [codingcops-rule-matrix.md](codingcops-rule-matrix.md)
  `PR-015` ("new ERP requirement"); the FRD decision list item #12 in the first entry of this file
  (contract text only); [payroll-engine-status-2026-09-12.md](payroll-engine-status-2026-09-12.md),
  which parks PAY-015. No meeting note, transcript, client message or decision discusses it. The
  engine has no day-level true-up.
- **Owner:** Corrina Bustos (interpretation), with Brian Petros. Proposed for the next payroll call.

## Relief employee paid at the relieved employee's rate (MLA Art. III-H.1(a)) — not modelled

- **Status:** open
- **Asked:** 2026-09-17 — raised by Brian Petros in his [written note after the 2026-09-15 demo](crew-assignment-and-rate-derivation-brian-2026-09-16.md)
  (point 3); logged by Syed Haris.
- **Question:** when an employee has worked over 16 hours without an 8-hour break and the employer
  calls in a replacement for safety, the replacement *"shall be paid at the same rate of pay as the
  relieved employees at the time of relief for all hours worked on the job"*
  ([mcog-l12-mla-2025-2028/01-article-iii-working-rules.md](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)).
  It applies to any employee, not only Oilers. How often does this happen, and how does payroll
  handle it today? Does "rate" include the relieved employee's premiums (long boom, lattice)?
  Under the craft-locked model ([decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md))
  a relief allocation that inherits the relieved allocation's craft is the likely shape, but
  nothing is designed.
- **Sources checked:** the MLA text above and
  [mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md](mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md);
  no PAY rule, no gap entry, no meeting, transcript or decision mentions it. No schema field.
- **Owner:** Corrina Bustos, with Brian Petros.

## Same pay as the craft worked with (MLA Art. III-C) — not modelled

- **Status:** open
- **Asked:** 2026-09-17 — raised by Brian Petros in his [written note after the 2026-09-15 demo](crew-assignment-and-rate-derivation-brian-2026-09-16.md)
  (point 4); logged by Syed Haris.
- **Question:** Art. III-C says covered employees get the same pay as the craft they work with
  when that craft's agreement is more advantageous. Brian reads it as work alongside another
  building-trades union, not the Operator/Oiler pairing, and suggests a separate craft-rate
  override. This is different from a secondary craft: the rate comes from another trade's
  agreement, not from any L12 craft the employee holds, so the current resolver cannot express it.
  Does this happen at TCG, and where would the other trade's rate come from?
- **Sources checked:** MLA text in `mcog-l12-mla-2025-2028/`; no PAY rule, gap entry, meeting,
  transcript or decision mentions it.
- **Owner:** Corrina Bustos, with Brian Petros.

## Is a secondary craft paid only when it is higher than the primary?

- **Status:** open — **answered provisionally, pending ratification**: [../decisions/2026-09-28-boom-union-follows-the-worked-craft.md](../decisions/2026-09-28-boom-union-follows-the-worked-craft.md) clause 6 (developer decision, TCG-140, 2026-09-28, `status: reference`) makes the primary base a floor — the higher of worked and primary base on the work date, day stays on the worked craft, issue `PRIMARY_RATE_FLOOR` (info). It departs from the verified 2026-08-20 note's "a validation warning, not a rate rule"; Brian Petros / Corrina Bustos to ratify. *(Was: open, 2026-09-17 – 2026-09-28.)*
- **Asked:** 2026-09-17 — Syed Haris, while replying to Brian Petros's post-demo note on the
  Oiler's Operator craft code.
- **Question:** the reply drafted for Brian says an employee on a secondary-craft allocation is paid
  the secondary rate when it is higher than the primary, otherwise the primary (a floor at the
  employee's own rate). That is Brian's proposal from the 2026-08-13 call, which Kyle Harlow agreed
  with (entry *Pay rate follows the employee, not the role worked*, above). But
  [decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md)
  calls that floor unnecessary under controlled assignment and says that if TCG still wants it,
  *"it is a validation warning, not a rate rule"*. The code follows the decision:
  `CraftRateResolverService` pays whichever craft is on the allocation and never compares rates
  (`apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts:328-353`,
  `apps/api/src/usecase/payroll/payroll-secondary-craft.ts`). Should the floor be enforced as a
  rate rule, shown as a warning, or left out?
- **Sources checked:** the two entries and the decision above; `PAY-010`; the resolver and
  `das-allocations.service.ts:1120-1183` (dispatch must pick a SECONDARY craft of the seat's role on
  a mismatch).
- **Owner:** Brian Petros and Corrina Bustos. If the reply goes out as drafted, their answer
  settles this; until then, don't describe the floor as built.

## Holiday-start guarantee — Brian's 2026-09-14 workbook calls the union reading a $1,440 overpayment, and prices the post-midnight hours at triple

- **Status:** open
- **Asked:** 2026-09-14 — Brian Petros, two Teams messages (05:02 and 05:11 PKT) with
  `___holidayGuaranteeScenario.xlsx`: *"I definitely do not want to 'fix' our Payroll App
  calculations/logic with that interpretation. It conflicts with what the Labor Union contract
  language specifically/clearly explains/requires. Needs to be reviewed."* He proposed discussing
  it at the next meeting. No outcome is on record. Logged 2026-09-17; the workbook is transcribed
  and its arithmetic checked in [holiday-guarantee-scenario-2026-09-14.md](holiday-guarantee-scenario-2026-09-14.md).
- **Question:** The pink column is labelled *"Union Rep wrong interpretation"*. It pays
  00:00–06:00 at triple **and** adds a 6-hour TRI top-up. That is not the BA breakdown recorded in
  [../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md](../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md), where the post-midnight hours are 4 OT then DT, and 8 TRI is reached as 2 worked
  hours plus 6 top-up hours. So three questions, each answerable in a line:
  - **(a)** Brian: which union-rep explanation does the pink column model — the 2026-09-12 relay,
    or something the rep said later that the vault does not have?
  - **(b)** Brian: does the "contract" row replace your 2026-09-11 reading (a)? That reading was
    2 worked + 6 top-up = 8 TRI, then 10 OT, and it is what your app does. The new row instead
    meets the 8-hour minimum by paying worked Tuesday hours (00:00–06:00) at triple, which also
    reverses ruling (b), "reverts at midnight", a ruling nobody had disputed.
  - **(c)** Corrina / the BA: with both sheets in front of you, is the 2026-09-12 breakdown
    (8 TRI · 4 OT · 6 DT on 22:00→10:00) still the ruling?
- **Money at $80, one 22:00→10:00 Labor Day shift, before meal deductions:**

  | Reading | Pay |
  | --- | --- |
  | BA via Corrina | **$3,360** |
  | Brian's app (2026-09-11) | $3,120 |
  | Brian's "contract" row | **$2,400** |
  | Brian's "union rep" column | $3,840 |

  The $1,440 per employee is the 6-hour top-up alone. It is measured against a reading no named
  person has stated. Against the ruling on record, Brian's new row **underpays by $960** per
  employee ($3,840 for his four-person example).
- **Sheet arithmetic, for whoever replies:**
  - The 05:02 version's "Final" ($1,500) starts from the *without-guarantee* total.
  - The 05:11 version and the downloaded file deduct the two breaks twice in the union column
    (`SUM(26:26)` already excludes the lunch cells). Priced consistently, that column is $3,660,
    not $3,480.
  - The downloaded file's own column is consistent: 7.5 TRI + 3.5 OT = $2,220.

  Details in [holiday-guarantee-scenario-2026-09-14.md](holiday-guarantee-scenario-2026-09-14.md).
- **Sources checked:**
  - [../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md](../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md): rulings (a) total, (b) reverts at midnight, (c) guarantee hours reach the
    12-hour mark, including its *Contested by Brian Petros, 2026-09-11* section.
  - *Holiday shift-start continuation…* (closed) above, which holds Brian's 2026-09-11 reading
    (a) and his five-concept list.
  - *Added hours — which rules' phantom hours reach which thresholds?* above.
  - [rules/PAY-033-holiday-pay.md](rules/PAY-033-holiday-pay.md).
  - MLA Art. III *Holidays* §1 ([mcog-l12-mla-2025-2028/01-article-iii-working-rules.md](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)):
    *"…shall be paid for all work performed… on the following holidays"*. It says nothing about
    post-midnight hours on a non-holiday.
  - The 2026-09-15 and 2026-09-16 transcripts: neither mentions a holiday.
- **Blocked:** nothing new in the ERP. Per the decision note, the engine follows the BA
  breakdown (PR #565). The parallel run against Brian's app now diverges on every holiday-start
  shift **in the opposite direction** from before if his app adopts the workbook row: the app
  would pay less than the ERP, not more.
- **Owner:** Brian Petros for (a) and (b); Corrina Bustos, with the BA, for (c). Agenda item for
  the next payroll call alongside WTL.

## The payroll rules sheet promised to Brian for Monday 2026-09-21 — a CodingCops commitment with no ticket

- **Status:** open — a deliverable, not a question
- **Asked:** 2026-09-19 — Syed Haris told Brian Petros in Teams that CodingCops is preparing *"a
  list of the payroll rules we've implemented and the ones that have been decided"*, to be shared
  **Monday 2026-09-21**, to serve as the single source of truth and to be expanded from there.
  Brian accepted: *"Oh... that is going to be great... Love it."* No ticket, no owner recorded
  anywhere else.
- **What was promised, in the same message:** the two systems may implement a rule differently —
  his app follows FCC's constraints, the ERP does not carry them — but *"the underlying rules
  should be identical"*. Brian was asked to update the sheet whenever something is settled,
  **including after his calls with Corrina Bustos**, and to say what changed.
- **What it has to be built from, and the trap in it:** the vault already holds the content —
  [rules/INDEX.md](rules/INDEX.md) (73 `PAY-###` rules), [payroll-rules-provenance.md](payroll-rules-provenance.md)
  (each rule's status and source), [payroll-engine-status-2026-09-12.md](payroll-engine-status-2026-09-12.md)
  and [implementation-audit-2026-09-11.md](implementation-audit-2026-09-11.md) (what the engine
  actually does). **"Implemented" and "decided" are not the same column**: a rule the engine runs
  is not necessarily one a named TCG person has confirmed, and this register exists because of
  that difference. A sheet that collapses the two would launder unverified rules into a "source of
  truth" the client then edits.
- **Two open points the sheet itself raises:** where it lives (a shared-folder file Brian edits in
  place, or a copy that comes back as messages — the second recreates the scatter it is meant to
  fix), and how its updates get back into the vault, which is the actual memory.
- **Live disagreements it must not paper over:** the holiday-guarantee dispute
  ([holiday-guarantee-scenario-2026-09-14.md](holiday-guarantee-scenario-2026-09-14.md)) and the
  added-hours grid — both are cases where his app and the ERP deliberately differ today.
- **Update 2026-09-23 — built and sent.** Built as a Word file,
  `TCG-Payroll-Rules-Status-2026-09-23.docx`, from [rules/](rules/INDEX.md),
  [payroll-rules-provenance.md](payroll-rules-provenance.md) and this register. Two days past the
  promised Monday. **It is written as a joint working document, not as a CodingCops
  deliverable addressed to Brian** — no byline, no second person, both sides named in the third
  person, and a maintenance section asking whoever settles a row to change its state and record
  on whose word. That shape was a deliberate correction: a document addressed *to* the client is
  one the client receives, and this one has to be one both sides edit. It honours the trap above by keeping **decided** and **built** apart in writing
  rather than in a column: a "how to read this" section says in as many words that a rule marked
  *Decided* may not be built and a rule the ERP runs may never have been confirmed. Six states —
  *Decided · Decided (contract) · Partly discussed · Working assumption · Contested · Open* — carried
  over from this register's own vocabulary and **grouped into three buckets on the page** — decided,
  discussed but still needing a final decision, and open. Per Brian's ask it carries **no per-rule sources**; the
  traceability stays here, which is the point of the vault. The four live disagreements get a
  section of their own so none of them can be read as settled: the holiday guarantee, the
  added-hours grid, the meal thresholds / worked-through modes, and the luffer classification.
  Corrina's 2026-09-14 luffer note is in it with its six unknowns.
- **Sent to Brian Petros on Teams, 2026-09-23, with the covering message.** The message states the
  three buckets and the 46 / 11 / 5 split; states in as many words that the document tracks
  *decisions, not what is built*; says that where the Payroll App and the ERP differ the difference
  is written down rather than resolved toward either one, *"nothing has been quietly resolved in
  code"*; asks Brian to update the row, change its state and record what changed and who decided it
  whenever something is settled, **especially after a call with Corrina Bustos**; names **luffer pay
  and its six unknowns** as the first thing to look at; and closes by asking him to flag any row
  marked *Decided* he would not recognise. It also carries the question below, put to him directly.
- **Where it lives — ANSWERED 2026-09-23, same day: Teams.** Brian Petros will add the document to
  Teams and edit it there. That is the home; every other copy is a transfer artefact or a stale
  read. **Delivery path:** Syed Haris uploaded the file to Google Docs and sent Brian the link; Brian
  downloads from it and puts the result in Teams. So the Google Doc is a **one-time transfer, not a
  second home** — the moment Brian's first Teams edit lands it is out of date, and so is the local
  `.docx` it was made from.
- **What that leaves, and it is small but real:** the Teams copy is the only current one, and
  CodingCops does not have a link to it — **ask Brian for the Teams location once it is up**, or the
  side that maintains the vault is reading a copy that stopped being true at his first edit. The
  Google Doc and the local file should be retired, or marked as the 2026-09-23 snapshot they are,
  so neither is opened later and mistaken for the register. Three copies of a rules document is the
  scatter this whole entry exists to prevent.
- **Brian's response, 2026-09-23 (two Teams messages, 04:57 and 07:42 Pakistan time — his
  afternoon and evening, so he read it the same working day).** Accepted and committed to
  maintaining it: *"this looks like it's going to be good… I'll spend some time taking a closer
  look at it… and save to our shared folder"*, and later *"This document is really good, Haris!…
  I'm only halfway through it… I'll keep you updated as I work my way through it."* Three things
  to carry forward. **(1) The shared folder is confirmed as the home** — he will put it there
  himself, which closes (a) in practice; the link back is still owed. **(2) He plans to change it:**
  *"I might redesign the layout and/or wording a bit, but I get the overall idea."* Welcomed in the
  reply, with one thing asked to survive a rewrite — the three states, and specifically the
  **decided vs built** line, because a rule the ERP runs that nobody confirmed surfaces nowhere
  else. If a later version of the document has lost that distinction, this entry is the record that
  it was deliberate once. **(3) He has not edited it yet** — he is still reading. The closing signal
  for this entry stays the first edit from his side, not the acceptance.
- **Review workflow set by Brian, 2026-09-24 00:07 Pakistan time.** The document is **saved to the
  shared folder**, which closes (a) properly: that is the home, and he is running it. Two identical
  copies sit there, **one Word and one PDF**, so Corrina Bustos can mark up whichever she prefers.
  The order is **Corrina first, then Brian, then wider circulation**: *"I have several things I
  would like to comment on, but think it's best to have Corrina review first… After her comments,
  then I'll add mine and send to other for review/comments."* He has told only Corrina so far. On
  versioning, unprompted and before anyone raised it with him: *"I'll be careful to not make too
  many copies and keep it controlled with new dated versions… Try to keep it a nice and clean
  working document… it will be important for us to keep track of things."* He also withdrew the
  redesign: *"not much change is needed to the layout."*
- **Why the order matters more than it looks.** Corrina owns the answer to most of what is still
  open in this register — luffer pay (a)–(e), the meal thresholds, the holiday guarantee with the
  BA, and the three MLA rules never discussed. A pass by her is worth more than any other single
  review, and it is the first time the open list has been put in front of her as one list rather
  than as scattered questions. **CodingCops is holding its copy unedited until her round returns**,
  so the two sides do not edit in parallel.
- **Still open after delivery:** (a) is answered — what remains of it is the Teams link, above.
  (b) How updates return to the vault
  — the document asks for a row to be marked and the change noted, which is a convention, not a
  mechanism; nothing reports a divergence if he edits and the vault does not follow. Closing this
  entry needs (a) settled and Brian actually maintaining it — the first edit from his side is the
  signal, not the acceptance.
- **Owner:** Brian Petros — the commitment is delivered, so maintenance is his from here. CodingCops
  (Syed Haris) to fold his edits back into this vault, and to chase (a) if it goes quiet.

## Employee Billing Code and Employee Pay — asked in UAT 1, never answered, and the schema keeps them independent

- **Status:** open
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. The underlying question was put to the client in **UAT 1** and has never come back.
- **Question:** is there **any relationship** between an employee's **billing code** and their **pay**? Three readings, and the answer is one line in each direction: does a billing code constrain the pay rate, does the pay rate constrain which billing codes the employee may be billed under, or are they genuinely independent as built?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Relationship between Employee Billing Code and Employee Pay*, [UAT 1]. The session sheet: *"**Confirm with the client** whether there is any relationship between **Employee Billing Code and Employee Pay**."* The register's finding: *"Still pending with the client. **Today's independence between the two is provisional until they answer.** … Billing codes and pay rates are independent in the schema today; whether they should be linked is undecided."*
  - [../decisions/](../decisions/) — **nothing.** A grep of every decision note and every module register for an employee-billing-code ↔ pay rule returns no substantive hit. The closest artefact is a set of **fields, not a rule**: [../decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md](../decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md) *Q10 — the nineteen unhoused fields* places *Pay Rate OT · Pay Rate DB · **Billing Rate** · Billing Rate OT · Billing Rate DB* together on the Payroll Profile → *Advanced* disclosure. **No note says what a Billing Rate on an employee does, or how it relates to a billing code.**
  - **What *is* decided, and is a different axis — do not let it stand in for this:** [../decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md) (Corrina Bustos, confirmed Brian Petros, `status: verified`) settles **pay rate vs role worked** — the rate comes from the employee's craft code, and a different day's craft is set by a secondary craft code, *"locked to a craft-code amount"*. That is craft↔pay, not billing-code↔pay. Scope carve-outs: [../decisions/2026-08-25-craft-locked-rate-override-scoped-to-union.md](../decisions/2026-08-25-craft-locked-rate-override-scoped-to-union.md), [../decisions/2026-08-25-non-union-base-rate-per-person.md](../decisions/2026-08-25-non-union-base-rate-per-person.md).
  - Evidence that a zero-valued employee billing rate exists upstream and means nothing there: FCC's `UNION_CRAFT.BillingRate` is *"0.000 on every sampled row — a dead path; billing actually comes from pricing sheets"* ([../quotations/gaps.md → *Billing-rate effective dating for pricing sheets*](../quotations/gaps.md#billing-rate-effective-dating-for-pricing-sheets--raised-by-the-client-no-design-yet)). **So the incumbent answers "no relationship" by neglect, which is not the same as TCG answering it.**
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). This row is unusual and useful: it is a **question put to the client**, so the register is recording an unanswered question rather than an unbuilt feature. The build's current independence is therefore a default, not a decision — which is exactly the state this register exists to make visible.
- **Blocked:** nothing hard today. What it blocks is any future work that assumes the two are linked (or that they are not) — employee billing rates on the payroll profile, and anything that derives a bill rate from an employee rather than a price list.
- **Owner:** the client, as the sheet says — Brian Petros / Corrina Bustos for pay, Joe Schacatano for what a billing code means. One line from any of them closes it.
- **Pointer:** [../quotations/gaps.md](../quotations/gaps.md) → *Employee Billing Code and Employee Pay — pointer, owned by payroll*.

## Lattice boom premium — UAT 6 asks to validate it against craft code groups; PAY-044 gates on payroll Group 6 and above

- **Status:** open
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. **Rules:** PAY-044, and PAY-043 / PAY-009 by adjacency.
- **Question:** what does *"validate the lattice boom premium with craft code groups"* mean against the rule as written? [rules/PAY-044-lattice-boom-premium.md](rules/PAY-044-lattice-boom-premium.md) keys eligibility on the **payroll group** — *"Eligible **Group 6+** employees"*, $1.00/h operator and $0.50/h oiler, four-way confirmed — not on a **craft code group**. Either the UAT row is naming the same thing loosely, or it is asking for a second gate nobody has specified. Which?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Validate the lattice boom premium against craft code groups*, [UAT 6]. Its whole comment is a restatement: *"The lattice boom premium needs validating against craft code groups."* **⚠️ Register caveat: this is one of the 38 UAT 6 rows, which were entered NOT DONE *without a code check* — the register says to treat their status as assumed.** So "not done" here means "not checked", and it is possible the rule already does what the row wants.
  - [rules/PAY-044-lattice-boom-premium.md](rules/PAY-044-lattice-boom-premium.md) (`status: open`) — the trigger is *"Eligible Group 6+ employees… Qualifying lattice boom is used"*, requiring *"Equipment group; employee role"*. **Kyle Harlow's answer, recorded there**, makes the group a real-world gate rather than a pay threshold: *"**Group 6+ is a qualification reality, not just a pay threshold** — only Group 6+ field employees are qualified to work lattice cranes, so dispatch self-enforces the premium's condition."* Also recorded there: Corrina, *"lattice pay applies to the **ENTIRE JOB**"*, not just boom-operating time; and identification belongs at the **job** level via a *Boom Configuration* field, superseding the asset-subcategory idea.
  - **Still unruled on that rule, and it is the live one:** the **luffer** classification — Jeff Stricker (via Brian) says add-on luffers are *"technically lattice"*; Joe (2026-08-04) says lattice on a non-crawler is a jib extension earning **boom pay only**. The MLA text found since (*"Long Boom pay including combined total mast and Luffing Boom applicable"*) sides with Joe. **Kyle adjudicates; he has not.** If the UAT row is really about which *equipment* qualifies rather than which *employees*, it is this question and should be answered there, not opened twice.
  - Payroll group vs craft code are distinct objects in the vault: craft codes carry a required `CraftCode.unionCodeId` and the group is a payroll classification (PAY-009). Nothing anywhere defines a *"craft code group"* as a term.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). One line from whoever raised it settles which of three things they meant: (a) confirm the existing Group 6+ gate is implemented, (b) add a craft-code-based gate alongside it, or (c) the luffer/equipment question above wearing different words.
- **Blocked:** closing PAY-044; the lattice premium's implementation gate.
- **Owner:** Kyle Harlow (he already owns the luffer adjudication on PAY-044) with Corrina Bustos; whoever raised the UAT 6 row for what *"craft code groups"* meant.
- **Update 2026-09-24 (TCG-141 audit):** still **open**.
  - **Reading (a) is built end to end.** The Group 6+ gate is on origin/main (PR #462 `1faf90eba`, with the wage-group field from PR #446). Checked by reading: `calculate.ts` raises `PREMIUM_GROUP_INELIGIBLE`, and `payroll-premium-form-dialog.tsx` has the premium's minimum group. It has **not been demoed**. `claude/skills/demo-walkthrough/WALKTHROUGH.md` has been corrected so it no longer calls it a defect.
  - **A consequence nothing written covers.** The code gates on the wage group of the **craft the day's rate resolved to**, not the employee's payroll group. So a Group 6+ employee working a Group 4 *secondary* craft for the day loses the premium. The PAY-044 rule says *"Eligible Group 6+ employees"*. Whether that means the employee's group or the day's craft group is the same question as reading (a) vs (b). Kyle's *"qualification reality"* note suggests the employee's group, but it does not rule on it.

## Adding a rate when the previous one has no effective-to date — back-fill it, or error

- **Status:** resolved (craft code rates) — see [../decisions/2026-09-25-craft-rate-succession-day-before-auto-end.md](../decisions/2026-09-25-craft-rate-succession-day-before-auto-end.md). Other rate types stay open under [*Effective-dating the rest of payroll's rates (PAY-008, TCG-168)*](#effective-dating-the-rest-of-payrolls-rates-pay-008-tcg-168). *(Was: open, 2026-09-19 – 2026-09-25.)*
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. **Rules:** PAY-008.
- **Question:** when a new rate is added and the **previous** rate has **no effective-to date**, should the system **back-fill** the old rate's end date (closing it the day before the new one starts) or **refuse** with an error, as it does now? And if back-filling: to what date exactly, and does the same rule apply to wage rates, billing rates and craft modifiers alike?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Adding a rate when the previous one has no effective date*, [UAT 6]: *"Where the previous rate has no effective-to date, adding a new rate should back-fill that date on the old rate instead of raising an error."* **⚠️ Register caveat: a UAT 6 row — the 38 rows from the 17 Sep internal session were entered NOT DONE without a code check, so its status is assumed.**
  - [rules/PAY-008-effective-dated-configuration.md](rules/PAY-008-effective-dated-configuration.md) (`status: open`) — *"Historical recalculation must use rules effective on the work date"*, requiring *"Effective from/to; rule version; approver"*. Its **Blocking (matrix)** item is *"Confirm configuration ownership"*, which is adjacent to this: whoever owns the configuration owns whether an open-ended rate may be silently closed.
  - **Why an open-ended previous rate is the normal case, not an edge case:** the same rule records that FCC *"has `StartDate`/`EndDate` columns but uses neither — **rates are overwritten in place**"*, one row per craft, no history. So every rate migrated from FCC arrives with no effective-to date, and the first ERP rate change on any of them hits this path.
  - [../decisions/](../decisions/) — nothing on rate-row succession, back-fill or the error. [../decisions/2026-09-03-l12-bulk-rate-update-uniform-delta.md](../decisions/2026-09-03-l12-bulk-rate-update-uniform-delta.md) covers a uniform bulk increase, not the dating of the row it replaces.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). This one reads as a UX complaint and is a **data-history rule**: silently writing an end date onto an existing rate row changes what a historical recalculation will produce for every week in the overlap, which is the entire point of PAY-008. It needs the owner named in PAY-008's blocking item, not a front-end fix.
- **Blocked:** closing PAY-008; any bulk rate rollover run against FCC-imported rates.
- **Owner:** Corrina Bustos / Brian Petros (they roll the rates over each fiscal year); PAY-008's *configuration ownership* question needs answering with it.
- **Update 2026-09-24 (TCG-138 audit):** still **open**. The code went ahead before this question was answered. It still needs the owners' ruling.
  - **What shipped.** App PR #659 (`fix/craft-rate-backfill-open-ended`, merged 2026-09-24 without review) makes craft-code **Add Rate** back-fill an open-ended previous rate instead of erroring. It shares `findPreviousRate` with Bulk Rate Update (`bulk-rate-plan.ts`). The *"refuse with an error, as it does now"* above is no longer what the product does. #659 changed **craft-code rates only**; wage rates, billing rates and craft modifiers were not touched.
  - **The end date conflicts between written sources. Not adjudicated here.**
    - [../decisions/2026-09-03-l12-bulk-rate-update-uniform-delta.md](../decisions/2026-09-03-l12-bulk-rate-update-uniform-delta.md) (`status: verified`, lines 68–73) ends the previous rate **the day before** the new one starts: *"added from 10th… the previous rates get the date 9th"*.
    - The TCG-138 ticket text, #659 and `bulk-rate-plan.ts` end it **on** the new rate's start date, with the new rate winning the shared day.
    - Both paths already ship the same-day behaviour. The owners must say which is right.
  - **Correction to a reason given on TCG-138.** The rate date columns are `@db.Date`, and `findRateInForce` includes the end date. So ending on *start − 1* would **not** leave a $0 gap day. The written "not the day before" rule on the ticket stands or falls on the owners' answer, not on that reason.
  - **New question: a rate closed under an open period.** Payroll recomputes only on an explicit Recalculate (`payroll.service.ts` `calculate`), which is refused only for APPROVED/EXPORTED. So a CALCULATED or REVIEW period keeps its stored results after a rate under it is added or closed. The next Recalculate silently reprices every work date on or after the new start, and nothing warns that the stored results are stale. Should adding a rate that affects a CALCULATED/REVIEW period warn, block, or do nothing? Same owners; cross-reference TCG-168.
  - **Still owed:** Fouzan Shakil, what the UAT 6 row meant.
- **Resolution 2026-09-25 (craft code rates only):** Syed Haris (CodingCops), [../decisions/2026-09-25-craft-rate-succession-day-before-auto-end.md](../decisions/2026-09-25-craft-rate-succession-day-before-auto-end.md) (`status: reference` — Corrina Bustos / Brian Petros to ratify):
  1. **Back-fill, no error.** An open-ended previous craft code rate is ended automatically; an end date already set is never rewritten.
  2. **Day before.** Previous effective-to = new effective-from − 1 day, for Add Rate and Bulk Rate Update alike. **Affirms** the 2026-09-03 bulk-rate note; **supersedes** the same-day rule in the TCG-138 ticket, `f1e1d0a27` and PR #659. Existing rows sharing a boundary day are to be corrected to the day before. Pay is identical either way (`effectiveTo` inclusive, `@db.Date`).
  3. **Scope:** craft code rates only. Employee, billing and craft-modifier rates stay with TCG-168 (below).
  4. **Rate closed under an open period (the 2026-09-24 question):** a rate added, ended or changed whose window overlaps a `CALCULATED`/`REVIEW` week after that week's latest completed calculation → the week shows a *rates changed since calculated, recalculate* warning. Approve and export are **not** blocked.
  5. **Ownership:** current access kept — craft-code write permission may create/end rates, no second approver. PAY-008's *approver* requirement stays open for the client.
  - **Still open from this entry:** what Fouzan Shakil's UAT row meant beyond the back-fill; PAY-008's configuration-ownership item.

## Primary craft code constrained to the employee type, and changing a craft code in DAS

- **Status:** open — **(b) answered provisionally, pending ratification**: [../decisions/2026-09-28-boom-union-follows-the-worked-craft.md](../decisions/2026-09-28-boom-union-follows-the-worked-craft.md) clause 5 (developer decision, TCG-140, 2026-09-28, `status: reference`) — dispatch sets the day's craft in DAS when seating (SECONDARY assignments only), crane superintendent and payroll may correct it afterwards; this adds dispatch to the verified 2026-08-20 list, Corrina Bustos / Brian Petros to ratify. **(a) stays open.** *(Was: open in full, 2026-09-19 – 2026-09-28.)*
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. Two UAT 6 rows, kept together because one is unanswerable without the other. **Rules:** PAY-009, PAY-010, PAY-015.
- **Question:** **(a)** should the **primary craft code** offered for an employee be constrained to that employee's **employee type** — and if so, by what mapping, given that nothing today relates the two objects? **(b)** may a dispatcher **change an allocated employee's craft code in DAS**, and if so does that change the day's **pay rate**?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Primary craft code should match the employee type*, [UAT 6] (*"The primary craft code offered should be constrained to the employee's type."*) and NOT DONE *Option to change craft code in DAS*, [UAT 6] (*"DAS needs a way to change an allocated employee's craft code."*). **⚠️ Register caveat: both are UAT 6 rows — entered NOT DONE without a code check, status assumed.**
  - **(b) runs straight into a `verified` decision.** [../decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md) (Corrina Bustos, confirmed Brian Petros, `status: verified`): the day's rate is driven by *"a **secondary craft code assigned for that day**"*, and *"**Only the crane superintendent or payroll** may set the day's craft/rate — never the employee ('would create extra double-checking')."* **It does not name the dispatcher.** So a DAS craft-code control is not forbidden by it and is not permitted by it: whether Lisette Anzaldo counts as "the crane superintendent or payroll" for this purpose is precisely what is unwritten. A control that changes the employee's *primary* craft rather than assigning a *secondary craft for the day* would contradict it outright.
  - **(a) has no mapping to constrain against.** [*Employee types — FCC holds several per employee; we store one*](#employee-types--fcc-holds-several-per-employee-we-store-one) asks whether an employee may hold several types with one primary, **and its second half is this question**: *"does `EmployeeType` become the single source of truth for a field role, with `CraftRoleType` deriving from it?"* Until that is answered there is no employee-type→craft-code relation to filter a picker by. See also [*Field role vs portal role — one list in FCC, three representations in TCG*](#field-role-vs-portal-role--one-list-in-fcc-three-representations-in-tcg): the same role concept exists in `DepartmentRole`, `EmployeeType` **and** `CraftRoleType`, and nothing says which derives from which. **A cross-reference has been added to the *Employee types* entry pointing here.**
  - Kept separate from that entry deliberately: *Employee types* is a **data-model** question (how many types per employee, which object is authoritative). This is a **behaviour** question (what a picker offers, and who may change a rate-bearing field on the board). They share a dependency; they are not the same ask, and merging them would hide (b) entirely.
  - Craft/premium context that survives whatever (a) decides: [*Pay rate follows the employee, not the role worked — Kyle and Corrina, unrecorded*](#pay-rate-follows-the-employee-not-the-role-worked--kyle-and-corrina-unrecorded) (**resolved**) records that role still governs **premium eligibility** even where it does not govern the base rate — *"someone paid at group 9 can go out as an oiler and qualify for oiler long boom, or as a third man and not"*.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). (b) is the one to be careful with: a craft-code control on the DAS board is a **pay-rate control**, and the only `verified` rule on the subject restricts who may operate one.
- **Blocked:** both UAT 6 rows; any employee-type→craft-code filtering; the DAS allocation panel's field set.
- **Owner:** Corrina Bustos / Brian Petros (they own who may set a day's craft) with Lisette Anzaldo for the DAS affordance.
- **Pointer:** [../dispatch/gaps.md](../dispatch/gaps.md) → *Changing an employee's craft code in DAS — pointer, owned by payroll*.
- Update 2026-10-15 — **(b) has a slot-type half nobody has answered.** Raised reviewing DAS work by Jahanzaib Nadeem (branch `fix/14-oct-uat`, no ticket). The DAS craft pill now shows on every employee slot, the employee's PRIMARY when the allocation stores none (what `pay-week-assembly.ts` prices the base rate under). Question for Corrina Bustos / Brian Petros, with Lisette Anzaldo for DAS: *"When dispatch seats an employee in a **non-Operator/Oiler** slot (rigger, third man, apprentice, driver), may dispatch set that day's craft to one of the employee's SECONDARY assignments — changing the day's pay — or is that only for Operator/Oiler seats, with the crane superintendent / payroll handling the rest?"* Clause 5 of [../decisions/2026-09-28-boom-union-follows-the-worked-craft.md](../decisions/2026-09-28-boom-union-follows-the-worked-craft.md) (`reference`, provisional) is silent on slot type. The `verified` [../decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md) reasons through the rigger case the other way (*"a $70 operator stays $70 unless the super deliberately assigns otherwise"*), as does the resolved [*Pay rate follows the employee, not the role worked*](#pay-rate-follows-the-employee-not-the-role-worked--kyle-and-corrina-unrecorded). **Built meanwhile, developer decision (Jahanzaib Nadeem, 2026-10-15):** on those slots the pill is display-only; only Operator/Oiler seats open the change dialog. A "yes" is a small web change in `job-allocation-sections.tsx` — `canChangeCraft` drops its seat-role test, and the dialog's `requiredRole` needs a value for a seat with no craft role; the API already accepts any requested craft on those slots (`resolveCraftForSlot`).

## DAS dispatchability is an employee-type attribute — pointer, owned by dispatch

- **Status:** open — **answer owned by dispatch**, per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*.
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register.
- **Why it lands here too:** the attribute the answer needs belongs to this module's objects. [fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §2 records FCC's `Dispatchable on: Jobs/Quotes (J), Work Orders (W), Both (B), or None (N)` as an attribute of the **employee type**, and states that it is *"a field the ERP has nowhere"*. Two open entries here are upstream of it: [*Employee types — FCC holds several per employee; we store one*](#employee-types--fcc-holds-several-per-employee-we-store-one) and [*Field role vs portal role — one list in FCC, three representations in TCG*](#field-role-vs-portal-role--one-list-in-fcc-three-representations-in-tcg).
- **Read:** [../dispatch/gaps.md → *Sales Persons in the DAS Employees tab…*](../dispatch/gaps.md#sales-persons-in-the-das-employees-tab--dispatchability-is-an-employee-type-attribute-we-do-not-have)

## Luffer pay — the oiler is paid the operator rate for base and long boom

- **Status:** open
- **Asked:** 2026-09-23 — logging Corrina Bustos's 2026-09-14 Teams message, relayed by Brian Petros. **Rules:** PAY-010, PAY-011, PAY-015, PAY-043; PAY-044 by adjacency.
- **Question:** Corrina, in full: *"**Luffer Pay-** Oiler gets paid operator rate for base rate AND long boom"*. Six things it does not say, and the build cannot proceed past any of them by guessing. **(a) Which operator rate?** The operator craft code that the oiler's own MLA group maps to, the rate of the operator actually on that crane that day, or a distinct luffer craft code? **(b) What scope?** The **entire job**, as lattice is (PAY-044, Corrina's own earlier ruling), or only the boom-window slices, as long boom is (PAY-043)? **(c) Is it a rate or a premium?** If the oiler's *base rate* really changes, fringes, pension, OT/DT and the ADP export all move with it; if it is a premium wearing the word *rate*, they do not. **(d) Oiler only?** Or does any other crew role on a luffer job — third man, apprentice — lift the same way? **(e) Does lattice flip too?** The message names base rate and long boom and is silent on the $1.00/$0.50 lattice split. **(f) How is a luffer job identified,** and who sets it?
- **Sources checked:**
  - [client-message-findings.md → *2026-09-14 — Luffer pay*](client-message-findings.md#2026-09-14--luffer-pay-the-oiler-is-paid-the-operator-rate-corrina-bustos-teams-relayed-by-brian-petros-2026-09-23) — the message verbatim, its screenshot ([assets/2026-09-14-corrina-luffer-pay-oiler-operator-rate.png](assets/2026-09-14-corrina-luffer-pay-oiler-operator-rate.png)) and the claim-by-claim verdicts. **This is the whole written source. There is no second one.**
  - [rules/PAY-043-long-boom-premium.md](rules/PAY-043-long-boom-premium.md) (`status: open`) — the long-boom adder is **two bracket sets**, MLA $0.75 operator / $0.25 oiler at 80–100 ft stepping every 20 ft; the workbook carries **18 operator and 15 oiler brackets**. [source-attribution-and-conflicts.md](source-attribution-and-conflicts.md) → *Long boom* records *"only oiler and operator qualify, not third man"*. Nothing anywhere pays an oiler out of the operator set.
  - **The resolver cannot express this today.** [../../aidlc/SCRUM-961/spec.md](../../aidlc/SCRUM-961/spec.md) §13 records that bracket choice is binary on role — `roleType === 'OPERATOR' ? operatorAdder : oilerAdder` — which is already known to mis-pay a `MECHANIC` craft. **Verified in code 2026-09-23:** `apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts:153` reads `const adder = roleType === 'OPERATOR' ? row.operatorAdder : row.oilerAdder;` — one ternary, no third branch, and `CraftModifier` carries exactly the two columns (`craft-modifiers.repository.ts:11-12`). "Oiler role, operator bracket" is a third case the model has no room for.
  - **It crosses a `verified` decision on base rates.** [../decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md): the rate comes from the employee's craft code, a different day's rate is a **secondary craft code**, and *"only the crane superintendent or payroll"* may set it. Scope carve-outs: [../decisions/2026-08-25-craft-locked-rate-override-scoped-to-union.md](../decisions/2026-08-25-craft-locked-rate-override-scoped-to-union.md). If luffer pay is implemented as an automatic configuration-driven lift, it sets a day's rate with **no human in that loop** — which is either a deliberate exception or a contradiction, and nobody has said which. The neighbouring resolved entry [*Pay rate follows the employee, not the role worked*](#pay-rate-follows-the-employee-not-the-role-worked--kyle-and-corrina-unrecorded) points the other way again: role governs **premium** eligibility, not the base rate. Corrina's line moves *both*.
  - **Contract:** the full MLA ([mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md) → Article IV) puts mobile tower cranes under *"Long Boom pay including combined total mast and Luffing Boom applicable"* at Groups 5, 7, 8 and 9 — it explains why a luffer earns **long boom**, and says **nothing** about an oiler drawing the operator figure. So this is TCG practice, not contract text, and cannot be derived from the agreement. (An agreement is a floor; TCG may pay above it.)
  - [rules/PAY-044-lattice-boom-premium.md](rules/PAY-044-lattice-boom-premium.md) and [*Lattice boom premium — UAT 6…*](#lattice-boom-premium--uat-6-asks-to-validate-it-against-craft-code-groups-pay-044-gates-on-payroll-group-6-and-above) — the **luffer classification** question (Jeff Stricker *"technically lattice"* vs Joe 2026-08-04 *"boom pay only"*) is still Kyle's and still unanswered. Corrina writing *"long boom"* for a luffer **corroborates the parked default** (question 21 in [client-message-findings.md](client-message-findings.md#parked--2026-08-24-build-proceeds-on-defaults)) but does not close it — she is answering *which rate*, not *which premium family*. **Kept as a separate entry deliberately:** that one asks which premium a luffer earns; this one asks who is paid at what rate once it does.
  - **(f) already has a home, and now a second consumer.** [../projects-jobs/gaps.md → *Job-level "Boom Configuration" field*](../projects-jobs/gaps.md#job-level-boom-configuration-field--schema-ask-from-payroll-kyle) carries Kyle's ask (configuration is per-job and stable for the job's duration). Brian's note proposes the same object serve luffer-pay eligibility, and ties it to the *crane configurations* resource-type work with Joe — [../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md](../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md) (FCC resource type 76 *360 Ton All Terrain w/Luffer*; *"after this job, we made separate ones for the different configurations"*), and [../assets/gaps.md → *One asset, one type — but one crane in several configurations*](../assets/gaps.md#one-asset-one-type--but-one-crane-in-several-configurations-how-does-an-asset-stand-for-more-than-one-resource-type). **⚠️ Brian's proposal is explicitly unconfirmed** — *"Can check with Kyle, Joe, and Corrina… but I think we can determine…"*. It is a hypothesis about a mechanism, not an answer.
- **Note:** the message is a **rule statement from the person who runs payroll**, which is the strongest kind of source this register gets — but it is one sentence, and every one of (a)–(f) changes what gets built. Do not let the sentence's confidence stand in for the six answers. In particular, **do not build (c) as a base-rate change on a guess**: it is the difference between a $4 premium and a rate that propagates through fringes, pension and every multiplier.
- **Blocked:** any luffer handling in `packages/payroll-engine` (and the pay-rule change it would need in [payroll-rules-provenance.md](payroll-rules-provenance.md), same commit); closing PAY-043's *Blocking — confirm equipment source data*; the field set of whatever carries crane configuration on a job.
- **Routed to its owner, 2026-09-24.** Brian Petros is running a review of the payroll rules
  document with **Corrina first** (see [*The payroll rules sheet promised to Brian*](#the-payroll-rules-sheet-promised-to-brian-for-monday-2026-09-21--a-codingcops-commitment-with-no-ticket)),
  and CodingCops asked in writing that she be pointed at these six questions while she is in it,
  naming this as the one open item actually holding work up. **So (a)–(e) are now in front of the
  person who owns them for the first time, as one list rather than scattered.** If her pass comes
  back without touching them, that is itself an answer worth recording here: it means the questions
  need asking directly rather than through a document.
- **Owner:** Corrina Bustos for (a)–(e) — it is her rule and her practice; Kyle Harlow with Joe Schacatano for (f) and for the still-open luffer classification. Brian Petros relays.
- **Pointer:** [../projects-jobs/gaps.md](../projects-jobs/gaps.md) → *Job-level "Boom Configuration" field* — payroll now has a second rule depending on it.

## A rule file's `status:` records the product question, not whether the rule is built — so build status in the register drifts silently

- **Status:** open
- **Asked:** 2026-09-24 — raised while correcting PAY-025, PAY-026 and PAY-061, all three of which
  were wrong at HEAD and had been for roughly two weeks with nothing reporting it.
- **Question:** the `status:` field in `payroll/rules/*.md` has exactly four values in use —
  `open`, `settled`, `conflicted`, `reference` (`grep -h '^status:' vault/payroll/rules/*.md | sort | uniq -c`:
  67 open, 4 settled, 2 conflicted, 1 reference) — and every one of them describes **the product
  question**: is the requirement agreed, contested, or still owed an answer. **None of them says
  anything about whether the rule is implemented.** `vault/STRUCTURE.md` line 103 documents a
  different vocabulary again (`verified` / `unverified` / `reference` / `superseded`) for the
  vault at large. So a rule can be fully built, tested and shipped while its register entry still
  reads `status: open` and its body still asserts "Not built" — which is exactly what happened.
  Two questions follow, and they are separable. **(a) Should a rule file carry build status at
  all?** Its body prose already does, informally and in free text, which is what drifted; and
  `payroll-engine-status-2026-09-12.md` already carries a per-rule ✅/🟡/❌ column that stayed
  correct throughout. If that table is the register of record for implementation, the rule files
  should point at it rather than restate it. **(b) If rule files are going to carry it, what keeps
  it true?** A second frontmatter axis (e.g. `implementation:` alongside `status:`) is only worth
  adding if something updates it — a `close-ticket` step, a check that greps a rule's cited
  `file:line` targets and fails when they no longer resolve, or a named human pass. Adding the
  field without the mechanism reproduces the present defect with more ceremony.
- **Why it is not a ticket question:** it is a property of how the vault records rules, spanning all
  73 `PAY-###` files (and the other modules' rule registers by the same shape). No single ticket
  owns it, so per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes* it belongs here.
- **Sources checked:**
  - [rules/INDEX.md](rules/INDEX.md) — the register's own summary line, *"Status: **4 settled · 67
    open · 2 conflicted**"*, and the per-section Status columns. Every value is a product-question
    value; the index has no implementation column.
  - [../STRUCTURE.md](../STRUCTURE.md) line 103 — *"`status:` stays a plain frontmatter key
    (verified/unverified/reference/superseded), not a tag"*. The rules register does not use this
    vocabulary, and nothing reconciles the two.
  - [payroll-engine-status-2026-09-12.md](payroll-engine-status-2026-09-12.md) line 60 — the row
    *"Non-union hourly: daily 8/12 → 7th day → weekly 40, in that order, reasons preserved | Brian
    2026-09-07, written, 9 scenarios | ✅ | Audit re-run A9"*. **This row was right the whole
    time.** So the information existed in the vault; it simply was not wired to the rule files.
  - [rules/PAY-025-weekly-overtime.md](rules/PAY-025-weekly-overtime.md) and
    [rules/PAY-026-seventh-consecutive-day.md](rules/PAY-026-seventh-consecutive-day.md) — the two
    drifted files. Both said "Not built"; both are built in
    `packages/payroll-engine/src/non-union.ts`, added by commit `56091e98f` (2026-09-11). PAY-025
    additionally cited an engine signal that does not exist (`WEEKLY_OT_APPLIED` — only occurrence
    repo-wide is `apps/web/src/features/payroll/components/payroll-issue-catalog.ts:84`, a web
    display catalog) and a line range (`calculate.ts:444-452`) that has since become unrelated
    code. **A stale citation is the failure mode worth noting: the line number kept resolving to
    *something*, so nothing looked broken.**
  - [rules/PAY-061-employee-payroll-worklist.md](rules/PAY-061-employee-payroll-worklist.md) — a
    different drift with the same root: the rule carried a 2026-06-09 client clause that a
    2026-09-15 decision had overturned, and nothing propagated the decision back into the rule.
    A `status:` axis for implementation would not have caught this one; the general problem is
    that **rule files are written forward and never re-read against their own citations.**
- **Blocked:** nothing is blocked on the answer — but every future reader of a `PAY-###` file is
  exposed to the same defect until it is settled, and the correction of PAY-025/026/061 fixed three
  instances without fixing the cause.
- **Owner:** CodingCops — this is a vault-mechanics question (how we record), not a product
  question, so it needs no client input. Pairs with whatever owns `close-ticket`'s writeback steps.
- **Rules:** all of [rules/INDEX.md](rules/INDEX.md); [PAY-025](rules/PAY-025-weekly-overtime.md),
  [PAY-026](rules/PAY-026-seventh-consecutive-day.md),
  [PAY-061](rules/PAY-061-employee-payroll-worklist.md) as the instances that raised it.

## Which payroll issues block approval (PAY-065) — a provisional list is live in every tenant

- **Status:** open — **partly answered 2026-09-30.**
  - **Answered for the nine flags:** they block (Corrina, verified). A flag is cleared as "reviewed,
    no change", and those mechanics are now settled (see the developer-answer line below).
  - **Still open:**
    - the provisional `NO_ADP_FILE` + `RATE_*` list;
    - (b) product list vs tenant setting, and (c) approval levels;
    - sub-questions 1–3;
    - the developer's readings on Calculate and on a never-completed ticket, which wait on Corrina.
- **Asked:** 2026-09-24. This is the TCG-164 audit. The question itself dates from the TCG-164 ticket (2026-09-23), which recorded it only in Linear and in code comments. **Rules:** PAY-065; PAY-063 shares the blocking item.
- **Question:**
  - **(a)** Which `PayrollIssue` codes block approval of an employee-week or a period?
  - **(b)** Is that a fixed product list or a per-company setting?
  - **(c)** At which approval levels does it apply? FRD PR-053 lists four: labor entry, employee/day, employee/pay period, and complete pay period. Only employee-week and period approval exist.
- **Why it is urgent, not theoretical:**
  - TCG-164 says *"No one has said which errors are critical … **Do not guess the list**."*
  - App PR #661 (merged 2026-09-24 with 0 reviews; body *"WIP … DO NOT MERGE"*) shipped the gate. Its migration `20260924000000_payroll_approval_blocking_issues` **backfilled every existing tenant** with a list its own code calls *"PROVISIONAL — a developer's conservative guess"*: `NO_ADP_FILE` plus the five `RATE_*` codes.
  - New tenants get the same six codes from `DEFAULT_PAYROLL_APPROVAL_BLOCKING_ISSUES` (`packages/shared/src/constants/payroll-issue-severity.ts`) through `seedPayrollApprovalBlockingIssues`.
    **[Corrected 2026-09-25:** not the same six — **seven**. The seed maps every key of `PAYROLL_RATE_ISSUE_REASONS`, which since #660 includes `NO_UNION_MODIFIER_RATE`; the migration's backfill is a literal list of six. So new tenants blocked on `RATE_NO_UNION_MODIFIER_RATE` and existing tenants did not — found by a test run on 2026-09-24. [2026-09-25-boom-adders-single-union-per-company.md](../decisions/2026-09-25-boom-adders-single-union-per-company.md) clause 3 aligns both on non-blocking.**]**
  - So approvals are already being blocked on an unratified list.
- **Sources checked:**
  - [payroll-rules-provenance.md](payroll-rules-provenance.md) PAY-065 row: still *Pending — Approval levels*.
  - `rules/PAY-065-payroll-approval.md`: *"Block approval for configured critical errors"*; blocking item *Management confirmation*.
  - `decisions/`: nothing on which codes are critical.
  - **Decision cited but not on overlay main:** the code cites `decisions/2026-09-10-an-open-overlay-entry-warns-before-approval-and-never-blocks.md`. That file exists only on the unmerged overlay branch `feat/payroll-pending-ticket-visibility` (commit `5a535fc`, one of ten SCRUM-PENDING decisions stranded there).
    - The decision that *is* on main, [../decisions/2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md](../decisions/2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md) clause 6, says *"whether it also blocks is explicitly not settled"*.
- **Sub-questions nothing written answers:**
  1. **Who may change a tenant's list?** There is no API or UI for `payroll_approval_blocking_issues`; today it takes a direct DB update.
  2. **Already approved weeks.** If an APPROVED employee-week gains a blocking issue later (for example after a Recalculate below APPROVED on another week), is it re-gated?
  3. **Run-level codes.** Should codes not tied to a week ever block period approval? Examples: `EMPLOYEE_ON_PAYROLL_HOLD`, `TICKET_MISSING_PAYABLE_WINDOW`. The gate reads week-level issues only.
  4. **`NO_UNION_MODIFIER_RATE`.** Should it block? See *Boom pay rates cannot hold a second union*, TCG-140.
     **→ Answered 2026-09-25 for this one code:** no — [../decisions/2026-09-25-boom-adders-single-union-per-company.md](../decisions/2026-09-25-boom-adders-single-union-per-company.md) clause 3 (`status: reference`, Corrina Bustos to ratify). `RATE_NO_UNION_MODIFIER_RATE` is a review flag; it is removed from the default seed and from any tenant it was seeded into. Source: FRD PR-011 (*"missing modifier rate"* is a review issue; *"Rate differences should normally be warnings or review items"*). Sub-questions 1–3 and (a)–(c) for every other code stay open.
- **When answered:**
  - `tcg-scrum` records the decision.
  - The provenance PAY-065 row is updated.
  - A data migration replaces the provisional rows in existing tenants, and the seed constant is changed to match.
- **Update 2026-09-30 — the payroll flags block (Corrina Bustos, Teams, `verified`):** [../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md). *"yes all of these will need to be adjusted and fixed before the payroll can be approved"*, said of the nine flags: boom out of range, overlapping jobs, under 8 h rest, missing notes, invalid times, invalid long boom time, Samsara more than 30 min off, crew Left Yard / Arrived Yard mismatch, asset not back at its departure yard. **These nine now block**, as client policy. The provisional `NO_ADP_FILE` + `RATE_*` list, (b) product-vs-tenant, (c) approval levels, and sub-questions 1–3 **stay open** for every other code. **New sub-question 5:** how a flag is cleared when nothing needs changing, given that every flag must be *"fixed"*. **→ Answered 2026-09-30** ([../decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md](../decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md)): payroll can mark a flag **"reviewed, no change"** and the week can be approved. Open: whether a note is required, who may do it, and the audit trail. **Also 2026-09-30, same note:** *"all tickets must be completed before the payroll can be processed/approved"*. **An incomplete ticket blocks**, which supersedes the warn-only in the 2026-09-10 overlay decision's clause 6. Open: whether Calculate is blocked too; an escape path for a cancelled or never-completed ticket.
- **Developer answer 2026-09-30** (git user `devmohsinakram`, `reference`):
  [../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md).
  - **Every flag blocks weekly approval** (item C1). This agrees with Corrina and adds nothing.
    **Settled.**
  - **Sub-question 5, "reviewed, no change": answered** (item C2).
    - A note is required, and the action is audited.
    - Only the Payroll Admin / Payroll Manager may do it.
    - It is available for every flag type.

    Corrina said yes to the action, and the developer set the mechanics. **Settled.**
  - **Flag 9 (asset not back at its departure yard) blocks that ticket's crew's weeks** (item C5).
    **Settled**, as mechanics of her rule that every flag blocks.
  - **An incomplete ticket blocks Approve only. Calculate stays allowed** (item C7). This is the
    developer's reading of her *"processed/approved"*. **Pending Corrina.**
  - **A never-completed ticket** (item C8). The Payroll Admin / Manager may complete it, entering
    the missing times, or void it. Either way a note is required, and the action is audited.
    **Pending Corrina.** Voiding reaches dispatch and billing, and nobody has asked either.
  - **The over-24 h review flag** (item A7) fires at 24 h or more. It blocks like every other flag.
- **Owner:** **Corrina Bustos** (named on TCG-164 and as the approval-levels owner).

## Calculation-run log (PAY-064): who "the payroll manager" is, and what "pay settings in effect" covers

- **Status:** open
- **Asked:** 2026-09-24, from the TCG-171 audit of app PR #656. **Rules:** PAY-064.
- **Question (a): who may confirm going ahead after a failed recalculation?**
  - [../decisions/2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md](../decisions/2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md) says approve/export stay blocked until the recalculation succeeds or *"the payroll manager **explicitly confirms**"*.
  - The shipped route `POST periods/:id/runs/:runId/acknowledge-failure` requires only `@RequirePermission('payroll', 'edit')`. That is the same permission that runs a calculation. So anyone who can recalculate can also lift the hold.
  - Nothing written says whether "payroll manager" is a distinct role or permission, or just anyone with payroll edit.
  - Related, but not the same question: who may reopen a processed period.
- **Question (b): what does "pay settings in effect" cover?**
  - [../decisions/2026-09-24-payroll-run-records-configuration-and-source-data-used.md](../decisions/2026-09-24-payroll-run-records-configuration-and-source-data-used.md) asks a run to record *"the union/craft rates and pay settings that were in effect"*.
  - The shipped `configurationSnapshot` holds rates, boom adders and premiums.
  - Is that all "pay settings" means, or does it also include OT/DT thresholds, holiday calendars, per-diem/subsistence amounts, or the approval-blocking list (PAY-065)?
- **Question (c), vault mechanics: does a rounding change count as a "pay-rule change"?**
  - `packages/payroll-engine/src/version.ts` says to bump `PAYROLL_ENGINE_VERSION` for any change to *"how money rounds"*. It defines `1.0.0` as the rule set *including* PAY-069's rounding.
  - PAY-069 (#657) merged **after** #656, so any run calculated in between is stamped `1.0.0` with the old rounding. The window is narrow and is real only if an environment ran a calculation in it.
  - The bump rule is written only in `version.ts` and the PAY-064 rule file, not in `.ai/claude/contexts/payroll-engine.md`, which is where #656's review asked for it. Adding a convention to `contexts/` is a human's call, from an accepted reflection.
- **Owners:**
  - (a) and (b): Syed Haris, who recorded both decisions, with **Corrina Bustos** for the payroll-manager role.
  - (c): CodingCops.

## Lattice oiler premium lands in the ADP "Lattice Oper" column (TCG-163)

- **Status:** open (known mis-mapping, logged on purpose)
- **Asked:** 2026-09-24. Logged as syed haris ruled on TCG-163 (2026-09-22): *"log the mis-mapping … leave the code alone here, and let's scope the split separately."* **Rules:** PAY-044, PAY-067.
- **What happens:**
  - `LATTICE_OP` ($1.00/h) and `LATTICE_OI` ($0.50/h) are both seeded with `ruleId: 'PAY-044'` (`apps/api/src/utility/seed-data.ts`).
  - `PayComponent` carries only `ruleId` and `label`.
  - So `packages/payroll-engine/src/xlsx-rows.ts` sums the **oiler's** lattice hours into "Lattice Oper", and "Lattice Oiler" is hardcoded 0.
  - Oiler hours reach ADP, but under the wrong column. The code now carries a comment saying so (app PR #668).
- **Settled, per haris's sourcing on TCG-163:** the two columns are the client's intended shape.
  - Corrina, `meetings/transcripts/2026-08-04-payroll-process.md` at 1:09:08.
  - Brian, `crew-assignment-and-rate-derivation-brian-2026-09-16.md`.
  - The oiler rate is **$0.50**, not the 75¢ said on the 13 Aug recording.
- **What is open:**
  - **The split is ours.** It needs a `PayComponent` modelling change plus a provenance row. It needs **its own ticket**, which is not yet filed.
  - **Which cranes trigger the premium** is a separate question for Joe and Kyle. See *what does "validate the lattice boom premium with craft code groups" mean*.
- **Owner:** CodingCops (to file and scope the split ticket).

## ADP file number — uniqueness, change policy, and a format conflict (PAY-006, TCG-169)

- **Status:** open
- **Asked:** 2026-09-24, from scoping TCG-169. Nothing is built: `Employee.adpFileNumber` is `String? @db.VarChar(50)` with no uniqueness rule, and the DTOs accept any 50 characters. **Rules:** PAY-006.
- **The written sources disagree on format. Not adjudicated here.**
  - TCG-169 ("Done when": *"a 7-character number is refused"*), `rules/PAY-006`, the matrix, the FRD and the crosswalk all say **at most 6 letters or numbers**.
  - The closed gap *ADP File Number — the crosswalk's format rule is wrong* (`gaps-2026-08-20-retired.md`, observed 2026-08-13) records ADP's own regex `^0*(5[1-9]|[6-9][0-9]|[1-9][0-9]{2,5})$`: digits only, value 51 or more, and leading zeros allowed that do not count toward the 6.
  - [client-message-findings.md](client-message-findings.md) records that **the client concurs in writing**.
  - So TCG-169 as written would refuse `0001234`, which ADP accepts, and would admit letters, which ADP rejects at submission.
  - `rules/PAY-006` has no `conflicts_with` pointing at this.
- **Questions TCG-169 itself leaves to its owners:**
  1. The ADP mapping, and what happens when a file number changes: overwrite, or deactivate the old one as legacy did.
  2. Does "unique within a company" mean the TCG tenant or the ADP company code (4RZ vs 4RY)?
  3. Does an archived or terminated employee keep their number reserved? The FRD says "unique among **active** mappings"; the ticket says a plain unique index.
  4. If duplicates exist today, who decides which employee keeps the number?
  5. Should the field stay freely editable? The FRD limits it to payroll manager and IT admin, and the 2026-06-30 decision says the ERP never mints the number.
- **Engineering notes for whoever builds it:**
  - `qa-automation` uses fixed, non-numeric values (`ADP-4417`, `ADP-2000`, `ADP-9001`, `ADP-9002` in `lifecycle.spec.ts` / `temp-employees.spec.ts`) with no cleanup. They fail the ADP format, and any database those tests ran against likely already holds duplicates.
  - Empty strings must be normalised to null before any unique index is added.
  - `create-employee-payload.ts` sends `|| undefined` on edit, so a number cannot currently be cleared.
- **Owner:** **Brian Petros** with **Corrina Bustos** (named on TCG-169); **Brian Petros** for the format conflict.

## Effective-dating the rest of payroll's rates (PAY-008, TCG-168)

- **Status:** open
- **Asked:** 2026-09-24, from scoping TCG-168. **Rules:** PAY-008, PAY-013, PAY-068.
- **What is dated today:** only the union craft base rate (`findRateInForce`). Everything else is read at its current value, so recalculating an old week uses today's amounts:
  - non-union `Employee.hourlyRate`;
  - the salaried amount (`hourlyRate`; `salaryAmount` is never read);
  - Foreman and 2nd/3rd-shift premiums, read once per run;
  - job-flag premiums such as lattice and military;
  - boom adders (`CraftModifierRate`, no date columns);
  - subsistence, which is a code constant.

  Archiving a premium or a bracket also changes old weeks on recalculation.
- **Questions nothing written answers:**
  1. **Start date for existing rows.** What effective-from date do existing premium and boom-adder rows get when dating is added? No source, no owner.
  2. **Archived amounts.** Should an archived premium or bracket still pay old weeks at its old amount?
  3. **Employee rate history.** TCG-168's AC2 cannot be built as written. `hourlyRateEffectiveFrom/To` is kept only for Hourly Non-Craft employees, whom payroll never prices, and `hourlyRate` is overwritten in place. A rate-history model was deferred by the 2026-08-25 decision to PAY-068 / SCRUM-920. Owner: **Syed Haris** with **Brian Petros**.
  4. **"Boom adders change every year."** TCG-168 gives this as the reason, but it has no source. The L12 wage notice records Long Boom Pay $0.75 "since 2001-07-01". PAY-008 still requires dating; only the stated reason is unsupported.
  5. **UI and subsistence scope.** Is a UI for entering dated rates in scope? Should subsistence amounts become dated configuration?
- **Also blocked by:** *Adding a rate when the previous one has no effective-to date* (the day-before vs same-day end date, and whether the back-fill applies to every rate type). Adding more dated tables before that is answered would copy the same ambiguity into each one.
- **Update 2026-09-25:** the craft code half of that blocker is answered — [../decisions/2026-09-25-craft-rate-succession-day-before-auto-end.md](../decisions/2026-09-25-craft-rate-succession-day-before-auto-end.md) (day-before auto-end; open `CALCULATED`/`REVIEW` weeks warn, not block). It **explicitly does not** extend the rule to the rate types listed here; whether each newly dated table follows the same day-before succession is still this entry's question. **Status stays open.**
- **Owner:** **Corrina Bustos / Brian Petros** (configuration ownership, PAY-008's blocking item).

## Recording which time source paid a job day (PAY-017, TCG-178)

- **Status:** open
- **Asked:** 2026-09-24, from scoping TCG-178. **Rules:** PAY-017, PAY-004, PAY-005, PAY-018.
- **What the code does now:** TCG-178 says there is "exactly one source, hardcoded". That was true before TCG-25. Since then, `payroll.service.ts` `buildJobDay` prices from the roster row's own `workStartedAt/workEndedAt` when the Oiler entered one, and otherwise from the ticket's shared `WORK_TIME` pair. The CHECK in migration `20260921020000` keeps the two from being mixed. Nothing records which one was used (`payroll_job_days` has no such column).
- **Questions nothing written answers:**
  1. **Priority when sources disagree.** PAY-017 names it; the FRD's order is unverified. Owner: **Brian Petros** (ticket 45888, the 0.00 / 0.98 / 24.00-hour example).
  2. **Pay from dispatch start?** The verified 2026-09-03 decision says pay starts at dispatch start; the code pays from the punch (audit A11). Changing it is a pay-rule change needing provenance. Owners: **Kyle Harlow / Joe Schacatano**.
  3. **End boundary.** The same decision ends paid time when the crane is "back in the yard, fuelled, parked, paperwork done"; the code ends at Review & Complete. Nobody has checked they are the same moment. Owners: **Kyle Harlow / Joe Schacatano**.
  4. **Backfill.** Should the source be recorded on historical `payroll_job_days`, or only on new runs? Rebuilding it from today's roster may not match what was actually paid. Owner: **Syed Haris**.
  5. **Naming and export.** What are the names and screen labels for the sources, and should the ADP export carry them too?
- **Related, 2026-09-29, resolved the same day:** a developer briefly chose to end the correction page's payable span at End Work (break-down end, on site) instead of Review & Complete. Their final definition is Start Ticket → End Ticket. That is `WORK_TIME`, the span the code prices, so nothing here changed. See [*Payable time — Start Work to End Work, or yard to yard*](#payable-time--start-work-to-end-work-or-yard-to-yard) (resolved). Questions 2 and 3 above are unchanged and still open.
- **Update 2026-10-07: a holdover case for items 2–3, provisional.**
  - In written Teams answers posted on or before 2026-10-06, Melissa McNutt said a holdover crew on
    days 2+ reports straight to the job site, and their time starts when they *"arrive at the job
    site"*
    ([../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md),
    `reference`, T4).
  - The verified yard-to-yard span has no such exception.
  - TCG asked to hold the answers until an updated version is sent.
  - Filed once:
    [*Holdover days 2+ — does paid time start on arrival at the job site, and where does each day end?*](#holdover-days-2--does-paid-time-start-on-arrival-at-the-job-site-and-where-does-each-day-end).
    Items 2–3 here stay open.

## Pointer — leave-page warning and value rewriting on open (employee edit)

- **Pointer (2026-09-28):** the leave-page "unsaved changes" warning sticking after a no-op edit, and forms rewriting stored values on open, is filed once in [customers/gaps.md](../customers/gaps.md) → *Leave-page warning — does undoing an edit count as a change, and may opening a record rewrite its stored values?* It covers employee edit specifically: `emergencyContact` defaults, and OT/DT rates rewritten by `payroll-advanced-fields.tsx`.

## Where the employee lifecycle starts — ERP-initiated (06-30) or ADP-first (09-28)?

- **Status:** open
- **Asked:** 2026-09-28, from the ADP Integration Sync ([../meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md](../meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md) §2, §5.1).
- **Question:** When a new employee is hired, does the ERP create them and push creation to ADP, as
  the verified 2026-06-30 decision says? Or does the employee **originate in ADP** and the ERP only
  link to it by file number, as the 2026-09-28 call assumed?
- **Candidates:**
  - [../decisions/2026-06-30-adp-erp-employee-data-ownership.md](../decisions/2026-06-30-adp-erp-employee-data-ownership.md)
    *Where the lifecycle starts*, `status: verified`, Brian Petros and Ehtesham Anwar: *"The ERP
    **initiates**, ADP **performs**, the ERP **records the result**."* The ERP creates a pending
    record, initiates ADP creation, captures the file number and blocks dispatch until ADP completes.
  - 2026-09-28, Brian Petros 22:04: *"It seems more natural for the employee information to
    originate in ADP. First … ADP is going to have more information than the ERP does on the
    employee level."* Corrina Bustos 23:03: *"keep it ADP based because it does house more
    information"*, with an ERP-side activate/deactivate trigger. abdulrehman 31:22 restated it as
    the working assumption: *"there would be always an employee present in the ADP and we just need
    to bind their file number in our ERP."* Corrina: *"Yes, yes."*
- **Note:** the ownership table in the 06-30 decision is **not** contested. ADP owns the legal
  record, and the ERP stores the file number and never generates it. Only the **direction and
  trigger of creation** moved. This is the same person changing position, so don't resolve it by
  recency. It needs Brian and Ehtesham together, recorded by `tcg-scrum` as a superseding decision or
  a confirmation.
- **Blocked:** the employee-creation push in
  [adp-read-write-boundary-2026-08-18.md](adp-read-write-boundary-2026-08-18.md); step 5's pending
  gate and the fill-in entry that depends on it (*Fill-in field employees vs the ADP-onboarding
  dispatch block*); how an ERP employee record gets its file number (manual entry vs lookup by
  associate ID).
- **Owner:** Brian Petros and Ehtesham Anwar (the decision's co-owners); Corrina Bustos for the
  onboarding practice.
- **Rules:** [PAY-003](rules/PAY-003-employee-master-import.md), [PAY-067](rules/PAY-067-adp-export.md)

- Update 2026-10-23 (syed.haris; [adp-integration-capabilities.md](adp-integration-capabilities.md) → *Project scope as of 2026-10-23*):
  the API side now supports **either** answer. `applicant.onboard`, `worker.rehire` and
  `worker.work-assignment.terminate` were added to *TCG ERP Integration*, plus the `worker.hire` /
  `worker.rehire` / `worker.terminate` events. ADP's collection also shows a third shape that may
  reconcile the 06-30 and 09-28 positions: `applicant.onboard` can **start** a hire in an
  *in-progress* state (minimal payload, or *pre-hire*) that the practitioner **completes in ADP**,
  then `worker.hire` tells the ERP it is done — the ERP initiates, ADP performs, the ERP records
  the file number. A technical option, not a decision; still needs Brian Petros and Ehtesham
  Anwar, with Corrina Bustos for the practice. Nothing called yet (every call hits live `4RZ`).
## Flagged entries go to payroll, not the crane superintendent — who corrects them, who the payroll admin is, and whether Send Back survives

- **Status:** open — **partly answered 2026-09-29 by Corrina Bustos's second reply**, recorded in [../decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](../decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md) (`status: verified`). Answered: 1, 2, 5(a)–(c), 5(d) sources half, 5(e) adjust half. **Third reply, same day** ([../decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md](../decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md), `verified`): C1 answered in her voice; Q7/Q8 partly answered; Q9's tolerance answered. Still open: 3, 4, 5(d) manual half, 5(f), 6, the remainders of 7–9, C1's confirmation trail, and C2–C6. **2026-09-30 messages** ([../decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md](../decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md), `verified`): C2 closed; a crew-time mismatch flag added (Q10); a Samsara start-of-ticket check requested (Q11); an asset-not-home flag requested and filed in assets (see *Related*). **Flag list confirmed 2026-09-30** ([../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)): nine flags, **all blocking** until fixed; Send Back to the worker with a 3-hour reminder; Q10's Left Yard / Arrived Yard ratified. **Q6 is still unanswered.** New open points: ~~how payroll clears a flag where nothing is wrong~~ **answered: "reviewed, no change"** ([../decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md](../decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md)); ~~whose week an asset flag blocks~~ **answered 2026-09-30: that ticket's crew's weeks** (developer mechanics); 24 vs 23.5 h **→ developer 2026-09-30: 24, at or above** (the `>=` boundary is pending Corrina). **Developer answers 2026-09-30** ([../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md), `reference`): Q3's open remainder and Q5(f) are answered as mechanics of Corrina's rule; see the dated line below. **The entry stays open** for Q4, Q5(d)'s manual half, Q6, the remainders of Q7–Q9, Q10(c)(d), Q11, C1's confirmation trail, and C3–C6. **Round 9, 2026-09-30** (developer, [same note, section *Round 9*](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30)): **C4 answered** (CodingCops design: a per-employee override table). Q6, Q7 (AM/PM detection, labor vs ticket), Q8, Q9, Q10(c)(d) and Q11 now have developer readings, **pending Corrina's ratification**. See the dated lines under each. **Open after round 9:** Q4, Q5(d)'s manual half, Q6–Q11 (ratification, plus the remainders named under each), C1's confirmation trail, C3, C5 and C6. **Rounds 10–11, 2026-09-30** (developer, [same note, section *Rounds 10 and 11*](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#rounds-10-and-11--flag-details-for-payroll-flags-u14u21-2026-09-30), `reference`): developer readings for Q5(d)'s *missing notes* (what counts as a note), Q7 (AM/PM replaces out-of-order; the 30 minutes is on the total difference) and Q10(c)(d) (only the mismatching workers are held, which narrows round 9), **pending Corrina's ratification**. C1's rest-start mechanics (per rest chain, across chains) are **pay-affecting, pending Corrina Bustos / Brian Petros**. Nothing is closed. *(Was: open in full, 2026-09-29.)*
- **Asked:** 2026-09-29, by Syed Haris (CodingCops) to Corrina Bustos on Teams. The eight-question message described the 2026-09-28 review design. Her first reply answered only routing: [../decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md](../decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md). A six-question follow-up the same day got the second reply.
- **Settled, for context:** flags go to the **payroll admin and payroll manager**, not the crane superintendent. That overrules clauses 3 and 5 of [../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md). The second reply overrules clause 4 (who corrects; whole crew → individual).
- **Questions**, each phrased so a one-line reply settles it:
  1. ~~**Who corrects a flagged entry?**~~ **Answered:** *"Payroll Admin/Manager adjusts"*. Payroll corrects directly.
  2. ~~**Who is the "payroll admin"?**~~ **Answered:** *"Right now the Payroll Administrator is Micaela Slykhuis"*. The assignment must be adjustable, so it is a role, not a hardcoded person. Both roles *"need to get all of the flags and be able to adjust"*. **Left open:** whether it is a new ERP role/permission beside `ROLE-ACCOUNTS-PM`, which is design work, not a client question. Also who Micaela Slykhuis is (C5).
     - **Update 2026-10-20 — which department the role sits in: answered.** Corrina Bustos, Teams, in writing: *"right now, Micaela's Payroll Admin is still under HR"* ([../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md](../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md), `verified`). The Payroll Administrator role belongs to the **HR** department, not Accounting, for now. "Right now" and "still" say the placement may change. Whether it is a new role beside `ROLE-ACCOUNTS-PM` is still design work. C5 (Slykhuis vs Dipane) is **not** settled: her reply says only "Micaela".
  3. **Does Send Back survive?** Now that payroll corrects directly, is there still any send-back? If yes, to whom: the worker on mobile (Confluence US-03 AC 3 and 10; Ehtesham Anwar 2026-08-04 20:24 and 34:11)? **→ Answered 2026-09-30** ([../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)): yes. The target is **the worker**, with a reminder after 3 hours. Payroll may also fix any time itself. **Open:** the worker's mobile screen and edit rights, who the reminder goes to, and whether it repeats. **→ Answered 2026-09-30 as mechanics** (developer, items C3–C4 of [../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md)): the worker **edits the ticket times on mobile and resubmits**, and payroll recalculates. The reminder goes **to the worker, every 3 h, until they respond**. **Q3 is answered.** The one exception is the crew extension, a shared ticket sent back to every worker on it. That is pending Corrina under [*Send Back of a multi-crew ticket*](#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket).
  4. **Does "all flags" include the field-ops ticket progress *Flagged*** (incident / deficiency / customer unavailable), or only payroll review flags? — **open**
  5. **The rest of the first 2026-09-29 message:**
     - (a) ~~Whole crew on a shared Start Work / End Job edit?~~ **Answered:** *"individual"*.
     - (b) ~~Which times are editable?~~ **Answered:** *"all times"*.
     - (c) ~~Is rest measured on rounded or actual times?~~ **Answered:** from the **rounded paid** time, and paid time includes the WTL penalty (11:00 PM + 30 min → 11:30 PM). This is a pay rule, and it is contested (C1, C2).
     - (d) Auto-flag sources: **answered:** overlapping jobs, under 8 hours' rest, missing notes, invalid time entries, invalid long boom time entries, time not matching Samsara. **Open:** can a flag be raised manually?
       - **Developer answer 2026-09-30 (rounds 10–11)** ([note, H1](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#rounds-10-and-11--flag-details-for-payroll-flags-u14u21-2026-09-30), `reference`), on *missing notes*: **any note on the ticket** satisfies "a note is required": the labor comment, the left-yard comment, a ticket comment, the signature comment, or a time-adjustment reason. When a note is required is round 9's [F5](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30): an adjusted time, a worked-through lunch, any flag on the entry, a ticket over 12 h, or a checklist issue. **Still open**, for Corrina Bustos to ratify. Whether a flag can be raised manually is not addressed.
     - (e) Approve or override: **answered in part:** both roles *"be able to adjust"*. Whether a flag can be approved as-is without adjusting is assumed by the 09-28 clause 6 (flag warns only), and not restated.
     - (f) **Reminder** for an unhandled flag, and after how long? Corrina asked for one herself, 2026-08-04 15:50 ([../meetings/transcripts/2026-08-04-payroll-process.md](../meetings/transcripts/2026-08-04-payroll-process.md) line 78). Confluence US-03 AC 9 says 3 hours. Now the recipients are payroll itself, so is a reminder still wanted? **→ Answered 2026-09-30:** a reminder after **3 hours** on a Send Back to the worker ([../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)). It repeats every 3 h until the worker responds (developer, 2026-09-30, item C4).
  6. **What does the boom flag compare against?** The crew's bracket vs (a) the crane's physical min–max boom length (2026-09-28 rule, clause 1), or (b) the job's crane configuration set by sales? Melissa McNutt described (b) on 2026-05-28 at 46:05 ([../meetings/transcripts/2026-05-28-mobile-app-payroll.md](../meetings/transcripts/2026-05-28-mobile-app-payroll.md) line 276). — **open**. **2026-09-30:** asked as an either/or and **not answered**. **Asked again later on 2026-09-30 and again not answered** ([../decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md](../decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md)). Suggest routing it to Brian Petros or raising it at the demo. Her *"all of those are correct"* confirmed item 1 as worded (*"the crane's boom range"*) but did not address the choice. Recorded as unanswered, not as a choice.
     - **Developer answer 2026-09-30 (round 9)** ([note, F1](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`): **(a), the crane's min–max boom range**. That is what is built, and clause 1 of the 2026-09-28 rule. The job's sales configuration (b) is not used. `RANGE_MISSING` (no range recorded) blocks, like every flag (C1). This is the developer's reading, **not Corrina's choice**. **Still open**, for Corrina Bustos (or Brian Petros) to ratify.
  7. **What is an "invalid time entry"?** **Partly answered (third reply):** *"incorrect use of AM/PM … times out of order, etc"*, and identical start and end (*"start work 1am, end work 1am. we see that often"*). **Open:** the rest of "etc" — a missing milestone, an over-long window, a future time? And how is "incorrect AM/PM" detected: a 12-hour offset that would fix order, an implausible hour, or something else? **2026-09-30, confirmed by assent** ([../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)): the list also includes duplicate entries, a missing start or end, shifts over **24** hours (vs PAY-004 / the 09-28 correction's **23.5** h: which applies?), and labor not matching the ticket. **→ Developer 2026-09-30 (item A7): 24 h, at or above.** The correction's 23.5 h refusal was lifted on 2026-09-29 (second addendum, item A), and PAY-004's 23.5 h cap covers imported FCC rows only. The `>=` boundary differs from her *"over 24"* only at exactly 24.0 h, and is pending Corrina.
     - **Developer answer 2026-09-30 (round 9)** ([note, F2–F3](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`):
       - **Wrong AM/PM:** flag an out-of-order time that adding or removing 12 hours would put in order.
       - **Labor not matching the ticket:** compare the worker's **own** work window with the ticket's Start Ticket → End Ticket (see [*Payable time*](#payable-time--start-work-to-end-work-or-yard-to-yard)). Flag when they differ by **more than 30 minutes**. The 30 minutes is a new figure here, reusing the Samsara tolerance. Not stated: whether it is measured at each end or on the total.
       - **Still open**, for Corrina Bustos to ratify. The rest of *"etc"* is not addressed.
     - **Developer answer 2026-09-30 (rounds 10–11)** ([note, H3–H4](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#rounds-10-and-11--flag-details-for-payroll-flags-u14u21-2026-09-30), `reference`):
       - **Wrong AM/PM replaces out-of-order.** Where adding or removing 12 hours would put a pair in order, only the AM/PM flag fires. It replaces the generic out-of-order flag for that pair. Other out-of-order pairs keep the generic flag.
       - **Labor vs ticket, round 11: the total difference.** Flag when |own start − Start Ticket| + |own end − End Ticket| is more than 30 minutes. It is not measured per edge. 20 minutes at the start and 20 at the end (40 in total) flags. This answers round 9's *not stated*.
       - **Still open**, for Corrina Bustos to ratify. The rest of *"etc"* is still not addressed.
  8. **What is an "invalid long boom time entry"?** **Partly answered (third reply):** boom start equal to boom end, out of order, wrong AM/PM. **Open:** is a boom session outside Start Work → End Job invalid? She was offered that example and did not repeat it. What about boom hours without a long-boom bracket? (PAY-043 long-boom 4-hour minimum is the nearby rule.)
     - **Developer answer 2026-09-30 (round 9)** ([note, F4](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`): **yes.** A boom session that starts before Start Work, or ends after End Job, is invalid. This is in addition to her three checks. **Still open**, for Corrina Bustos to ratify. Boom hours with no long-boom bracket: not answered.
  9. **How does the Samsara comparison work?** **Tolerance answered (third reply):** flag when a ticket time is *"further than 30 minutes outside of geotag time"*. **Open:** which ticket events are compared with which geotag events (leave yard / arrive site / leave site / arrive yard); and what happens when Samsara has no data — flag, no flag, or its own status? Untracked or silent cranes: [../assets/gaps.md](../assets/gaps.md) → *A Samsara link that has gone silent*, *One Asset ↔ one Samsara asset*, *Samsara vehicle tracking*.
     - **Developer answer 2026-09-30 (round 9)** ([note, F8–F11](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`):
       - **Left Yard** is compared with the moment the asset **leaves the yard's location**, and **Arrived at Yard** with the moment it **re-enters** it. This needs yard geofences, with a **500 m** radius around a yard's address coordinates.
       - Only those two points are compared, at the start and end of the day. Arriving at and leaving the job site are not compared.
       - **No Samsara data → no flag.** So an untracked or silent crane never raises this flag.
       - **Still open**, for Corrina Bustos to ratify.
  10. **Crew time mismatch flag (2026-09-30).** **Answered:** flag when crew times differ, with *"any difference"* and no tolerance. **Scope answered (later reply, [../decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md](../decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md)):** *"all members"* of the job, **across their separate tickets**. **Times replaced by the same reply:** *"Start time (very start of job) and End time (back at yard)"*, no longer *"Start work and End Work"*. (a)/(b) **ratified 2026-09-30** (flag list: *"Left Yard or Arrived at Yard different for anyone on the job"*), first developer-decided ([../decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md](../decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md), `reference`): "very start of job" = **Left Yard**, "back at yard" = **Arrived at Yard**. Both are per ticket, so the flag fires across a job's separate tickets. The rejected candidates were the shift-clock tap, the Start Work step, and Review & Complete. **Open:** (c) how a job's tickets are grouped (job + date? DAS allocation?); (d) ticket flag, per-employee payroll flag, or both. It bears on [*Recording which time source paid a job day*](#recording-which-time-source-paid-a-job-day-pay-017-tcg-178) items 2–3.
     - **Developer answer 2026-09-30 (round 9)** ([note, F6–F7](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`):
       - **(c)** A job's tickets are grouped by **same job + same date**, not by the DAS allocation.
       - **(d)** **The ticket only.** It is one ticket-level flag, not a per-employee payroll flag.
       - **Session reading, to confirm:** it blocks the weeks of **everyone on that ticket**, as flag 9 does.
       - **Not stated:** which ticket of the group carries it. A Left Yard / Arrived at Yard difference is always between two tickets.
       - **Still open**, for Corrina Bustos to ratify.
     - **Developer answer 2026-09-30 (rounds 10–11)** ([note, H2](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#rounds-10-and-11--flag-details-for-payroll-flags-u14u21-2026-09-30), `reference`): only the **mismatching workers** are held, those whose Left Yard or Arrived at Yard differs from the rest of the crew. Workers whose times match are not held.
       - **This narrows round 9's (d).** Its session reading, marked *to confirm*, was that the flag blocks the weeks of everyone on that ticket, as flag 9 does. The developer did not confirm that reading, and this answer replaces it.
       - Left Yard and Arrived at Yard are per ticket, so the held workers are the crew of the ticket whose times differ from the rest of the group. That also answers round 9's *which ticket carries it*.
       - **Not stated:** a group that splits evenly (two tickets, two different times), where no ticket differs from "the rest".
       - **Still open**, for Corrina Bustos to ratify.
  11. **Samsara at the start of the ticket (2026-09-30, requested).** Her example: leave time 6:30 AM, Samsara engine-on 7:30 AM → flag. *"the same rules as the end of the ticket for the start of the ticket."* **Open:** (a) which "end of ticket" rule. The 30-minute geotag tolerance (Q9) is **our inference**, not her words. (b) Which Samsara signal stands for leaving: first engine-on, trip start, or leaving the yard's coordinates? The integration has engine-state events and trips, and no geofences. (c) What happens with untracked or silent assets?
     - **Developer answer 2026-09-30 (round 9)** ([note, F8–F10](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`):
       - **(a)** The points are Left Yard and Arrived at Yard only. That is the scope of item 7 of the verified flag list (30 minutes, *"at the start or end of the day"*, confirmed by assent).
       - **(b)** The signal is the asset **leaving the yard's location**, not engine-on. Her own example named engine-on.
       - **(c)** No Samsara data → **no flag**. This was given for this flag only. For the asset-not-home flag, the handling is still open in assets/gaps.md Q7.
       - **Still open**, for Corrina Bustos to ratify.
- **Conflicts raised by the second reply — recorded, not resolved** (detail in the decision note's *Conflicts*):
  - **C1.** Rest gap extended by the WTL penalty vs *"Added hours must not affect the 8-hour rest rule"* (Brian Petros 2026-08-24), PAY-045 *Phantom hours…*, and the PAY-029 invariant that added hours never become time windows. **Answered by Corrina, third reply, with Brian's statement put to her:** *"yes, the WTL penalty effect the rest starts. this was confirmed last friday in our meeting with the union business agent"* ([../decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md](../decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md)). For the WTL penalty and the rest start, Brian's 08-24 line is superseded. **Not closed:** (i) the 2026-09-25 union BA meeting is not in the vault (searched meetings/, transcripts, decisions/, client-message-findings.md, this file); (ii) Brian Petros, asked jointly, has not confirmed; (iii) no MLA text is on file for it. The rest of the added-hours doctrine (the rest trigger, PAY-029 windows) is untouched.
    - **Developer answer 2026-09-30 (rounds 10–11)** ([note, J1–J2](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#rounds-10-and-11--flag-details-for-payroll-flags-u14u21-2026-09-30), `reference`). **Pay-affecting, pending Corrina Bustos / Brian Petros.** Both are what PAYROLL-FLAGS U2 built:
      - **Per rest chain** (ticket spec Q9): the 2nd missed meal that moves the gap start is counted across the whole rest chain, as stitched by `REST_STITCH_MINUTES`, not per gapless meal group. Two tickets 1–30 minutes apart, with one worked-through meal each: the second moves the start 30 min.
      - **Across chains** (ticket spec Q10): the gap is measured from the rounded paid end plus the WTL extension across a `chainJobDays` (OT/DT reset) boundary too. That decides which runs get the rest premium at all.
      - The provenance row *8-hour rest — gap start* ([payroll-rules-provenance.md](payroll-rules-provenance.md), line 103) already records both as pending. **C1 is not closed.**
  - **C2.** Her WTL example adds 30 minutes. PAY-047 absorbs the **first** missed meal's half-hour, and only further missed meals add time. Which meal was her example? **Still open after the third reply.** Does a first missed lunch, which adds no hours, also move the rest start? **→ Closed 2026-09-30:** *"no, only the 2nd and onward"* ([../decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md](../decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md)). The first missed lunch does not move the rest start; the 2nd and later do. This agrees with PAY-047.
  - **C3.** Bears on, and does not settle, [*Do WTL added hours count toward the rest chain's 12-hour double-time threshold?*](#do-wtl-added-hours-count-toward-the-rest-chains-12-hour-double-time-threshold). Her paid-time reasoning points to payable hours; the build default is actual.
  - **C4 — answered 2026-09-30 (round 9), see below.** Individual corrections vs the verified [../decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md](../decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md) clause 4 (`TicketTimeEntry` per ticket, crew-wide). Needs a per-employee home for corrected times; its clause 7 left that undecided. Design question for CodingCops, not the client.
    - **Developer answer 2026-09-30 (round 9) — answered, CodingCops design** ([note, G1](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30)): a **per-employee override table**. Each row holds the ticket, employee, step, corrected time, reason, and who made it and when. The shared ticket times stay as captured. Pricing and payroll read an employee's override where one exists. **C4 is closed.** It does not settle what a **worker's** mobile edit of a shared time does; that conflict with Corrina is pending (C6, refined, in the same note).
  - **C5.** **"Micaela Slykhuis" vs "Micaela Dipane".** The transcripts label a payroll/accounting participant *Micaela Dipane* (13 transcript files, e.g. 2026-07-23, 2026-07-28, 2026-09-28 ADP sync). The unverified org chart ([../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md) l. 131) lists *Micaela Slykhuis* as an **Accounts Receivable Specialist**, not payroll. Kyle Harlow 2026-08-13 40:33: *"It's gonna be Micaela soon"* (payroll alerts). One person or two? — **open**
  - **C6.** The verified [../decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md) lets *"the crane superintendent or payroll"* set the day's craft. The boom bracket is a craft modifier. Payroll now corrects flags. May the superintendent still set craft outside the flag flow? — **open** (carried from the first reply)
- **Sources checked:**
  - all three decision notes above;
  - transcripts 2026-05-28 (l. 276), 2026-06-23 (l. 216, 243, 261), 2026-08-04 (l. 77–78, 101–102, 106, 116–117, 141, 184) and 2026-08-13 (l. 278, 394–396);
  - [../sync/.conflict/2026-08-24-bootstrap/payroll-management.md](../sync/.conflict/2026-08-24-bootstrap/payroll-management.md) US-01 AC 7, US-03;
  - the Confluence `Craft codes` conflict copy (*Payroll Administrator* persona);
  - [rules/PAY-045-rest-period-premium.md](rules/PAY-045-rest-period-premium.md), [rules/PAY-047-worked-through-lunch-adjustment.md](rules/PAY-047-worked-through-lunch-adjustment.md), [payroll-rules-provenance.md](payroll-rules-provenance.md) §4, [client-message-findings.md](client-message-findings.md) 2026-08-24 batches;
  - `apps/api/src/utility/seed-data.ts`.
- **Related:** [*Calculation-run log (PAY-064): who "the payroll manager" is*](#calculation-run-log-pay-064-who-the-payroll-manager-is-and-what-pay-settings-in-effect-covers) — same role question, other side. [*Which payroll issues block approval (PAY-065)*](#which-payroll-issues-block-approval-pay-065--a-provisional-list-is-live-in-every-tenant) — whether any of the six new flag sources block. [*Confluence payroll user stories*](#confluence-payroll-user-stories--first-payroll-pages-in-confluence-unmigrated) is the parent. [*Asset not returned to its home yard at end of shift*](../assets/gaps.md#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end) — Corrina's 2026-09-30 asset flag idea, filed in assets because it is not a payroll-entry flag.
- **Blocked:**
  - rework of PR #690 / #691 on `main`, three things: the Crane Supervisor corrects (payroll should); a shared Start Work / End Job edit moves the whole crew (it should be individual); boom range is the only flag source (six more named);
  - the clause-6 approval block, which depends on Send Back having a target (Q3);
  - any PAY-045 change to where the gap starts. The direction is now answered (C1); first-meal scope (C2) is not;
  - the crew-time mismatch flag (Q10) and the Samsara start-of-ticket check (Q11). Neither is built;
  - the Samsara and invalid-entry flag sources. **None is in PR #690 / #691**, including the 30-minute tolerance and the AM/PM, same-time and out-of-order checks.
- **Developer answer 2026-09-30** (git user `devmohsinakram`, `reference`):
  [../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md).
  - **Settled.** Each is a verified client rule, with only the mechanics set by the developer.
    - **Q3 / Q5(f), Send Back** (items C3–C4): the worker edits the ticket times on mobile and
      resubmits. The reminder goes to the worker, every 3 h, until they respond.
    - **Whose week an asset flag blocks** (item C5): the weeks of that ticket's crew.
    - **"Reviewed, no change"** (item C2): a note is required, and the action is audited. Only the
      Payroll Admin / Manager may do it, for every flag type.
  - **Pending Corrina:**
    - **24 vs 23.5 h** (item A7): 24, at or above.
    - **A shared ticket sent back to every worker on it** (item C6): see
      [*Send Back of a multi-crew ticket*](#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket).
  - **Not answered by it:** Q4, Q5(d)'s manual half, Q6 (boom basis), the remainders of Q7–Q9,
    Q10(c)(d), Q11, C1's confirmation trail, and C3–C6.
  - **Round 9, later the same day** ([same note, section *Round 9*](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30)): developer readings for Q6–Q11, pending Corrina; C4 answered. See the dated lines under each.
  - **Rounds 10–11, later the same day** ([same note, section *Rounds 10 and 11*](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#rounds-10-and-11--flag-details-for-payroll-flags-u14u21-2026-09-30)): developer readings for Q5(d)'s missing notes, Q7 and Q10(c)(d), pending Corrina; C1's rest-start mechanics, pay-affecting, pending Corrina / Brian. See the dated lines under each.
- **Owner:** Corrina Bustos (payroll), with Brian Petros for C1–C3 (engine / rest rule). CodingCops for Q2's role design and C4.

## Should a Crane Supervisor see an employee's pay in the correction preview without payroll view

- **Status:** open
- **Asked:** 2026-09-29, while recording the addendum to
  [../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#addendum-2026-09-29--build-up-and-break-down-live-totals-and-a-pay-estimate)
  (item D). No ticket covers Send Back (the decision names none), so it is filed here, not in a
  `spec.md` §12.
- **Question:** A user holds `crane-supervisor` at `edit` or `full` but does **not** hold
  `payroll:view`. When they preview a Send Back correction, may they see the employee's pay?
  That means the rate lines, the week total, this entry's share, and the before → after amounts.
  - **Yes:** keep it as built.
  - **No:** show them hours only, and show the pay estimate only to users who also hold
    `payroll:view`.
- **Update 2026-09-29, interim developer direction. The status stays open.**
  - The session wrote the options, and the developer (git user `devmohsinakram`) chose **"Only with
    payroll view"**. The chosen option's text is the direction: *"The preview shows hours for
    everyone. Pay lines and totals only appear if the user also has the payroll:view permission.
    This is safest until Brian and Corrina answer."*
  - That is the **No** answer above, adopted as an interim default. It is not a ruling. Brian Petros
    and Corrina Bustos still decide. If they answer **Yes**, the gate can be removed.
  - **Build status:** being built on `fix/payroll-correction-page-ui`, and not built when this was
    recorded. On 2026-09-29, a grep of the correction controller, the send-back usecase and the web
    feature found no `payroll:view` check.
  - **Not recorded:** whether the gate is in the API response, the page, or both. The **Blocked**
    line below still applies: both need it, or the API still sends pay to a user without
    `payroll:view`.
  - Recorded in the decision note's first addendum, item D:
    [*Pay in the preview only with `payroll:view`*](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#d-pay-in-the-preview-only-with-payrollview-interim-direction-open-needs-ratification).
- **What is built:** the developer directed the pay estimate on 2026-09-29, in their words
  *"preview should also show the all rates total amount"*.
  - The preview route, `POST payroll-corrections/:id/preview`, requires only
    `@RequirePermission('crane-supervisor', 'edit')`
    (`apps/api/src/presentation/payroll-corrections/payroll-corrections.controller.ts`).
  - Before this change the preview showed hours only.
  - The change is uncommitted on the platform branch `fix/payroll-correction-page-ui`.
- **Sources checked:**
  - The decision note, clause 3: it defines the permission (`view` = see the entries sent to you;
    `edit`/`full` = correct and resubmit them). It says nothing about whether that includes seeing
    pay.
  - [erp-payroll-module-frd/11-security-decisions-and-acceptance.md](erp-payroll-module-frd/11-security-decisions-and-acceptance.md)
    §24, `status: unverified`. Its recommended-roles table gives *Payroll Team* "View calculations"
    and *Operations Manager* "Review labor/job information and resolve operational issues". No row
    names a Crane Supervisor, and none gives an operations role pay visibility. It does not settle
    the question.
  - `decisions/`: nothing on who may see pay amounts.
- **Blocked:** nothing in the build, because it is already built. But merging
  `fix/payroll-correction-page-ui` shows pay to every user with `crane-supervisor` edit. If the
  answer is **no**, the estimate has to be gated on `payroll:view` in both the API response and the
  page before merging.
- **Owner:** **Brian Petros** and **Corrina Bustos**, the payroll-side ratifiers the decision names.

## Multi-day entry — which pay period owns the hours after Saturday 00:00

- **Status:** open — the developer's 2026-09-30 answer is **superseded** by Corrina's verified
  completion rule (see *Developer answer* below). Anchor vs split is still unanswered.
- **Asked:** 2026-09-29, while recording the
  [second 2026-09-29 addendum (multi-day tickets)](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#addendum-2026-09-29-second--multi-day-tickets).
  The developer (git user `devmohsinakram`) said a job can now run over several days, including as
  **one ticket of 24 h or more**. No ticket covers Send Back, so this is filed here, not in a
  `spec.md` §12. **This is a pay rule.** The engine will not change until the answer is written in
  [payroll-rules-provenance.md](payroll-rules-provenance.md).
- **Question:** One labor entry starts before Saturday 00:00 and runs past it, into the next
  Saturday–Friday week. Which pay period owns the hours after Saturday 00:00?
  - **Anchor:** the whole entry belongs to the period its Start Work falls in.
  - **Split:** slices from Saturday 00:00 on belong to the next period.
- **What the engine does today: anchor.**
  - A completed ticket is loaded into the period whose range contains its `WORK_TIME` start
    (`apps/api/src/service/payroll/payroll.repository.ts:506-513`).
  - Every slice of that entry is then priced in that period. Nothing splits an entry across two
    periods.
  - **Related, not this question:** the range edges are **UTC** midnight
    (`packages/payroll-engine/src/period.ts:5-9`), not 00:00 in the tenant's zone. The vault
    already records this as one of the competing day definitions
    ([../decisions/2026-09-09-business-day-starts-at-midnight-local.md](../decisions/2026-09-09-business-day-starts-at-midnight-local.md):224).
    It moves the same boundary.
- **Sources checked:**
  - [payroll-concepts-shift-job-labor-entry.md](payroll-concepts-shift-job-labor-entry.md),
    `status: unverified`. Its anchor-date rule (:44-52) says the anchor date is always the start,
    and (:69) *"The Saturday–Friday pay period is assigned from the anchor date, not from where the
    hours fall."* It is not confirmed by anyone. Its example is 22:30 → 02:00, and it never
    considers an entry of 24 h or more.
  - [rules/PAY-001](rules/PAY-001-saturday-friday-payroll-week.md) (settled) makes the week
    Saturday–Friday.
    [../decisions/2026-09-09-business-day-starts-at-midnight-local.md](../decisions/2026-09-09-business-day-starts-at-midnight-local.md)
    (`reference`) opens it at 00:00 Saturday, local (§4). Neither says who owns an entry that
    crosses that line.
  - [../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md)
    (`verified`) settles day type per slice. It does not assign slices to periods.
- **Blocked:** nothing built yet. But one entry across the week line is now possible. The answer
  decides which week's run pays those hours, and, for non-union, which week's 40-hour and
  seventh-day counts see them.
- **Related, 2026-09-29 (not an answer):** a Send Back correction that moves Start Ticket across the
  week line now moves the **whole entry** into the other period. The send-back's `periodId` and
  `workDate` follow it, and both periods are flagged for recalculation. That is the entry's anchor
  moving, not a split, so this question is unchanged. See the decision note's
  [second addendum, item F](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#f-a-correction-may-move-an-entry-into-another-pay-week-amends-clause-4-added-later-on-2026-09-29).
- **Developer answer 2026-09-30 — superseded, not built.** [../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md), item D1.
  - The developer's round-1 rule, verbatim: *"if its done on time of payroll calculation all of it
    will process with previous week otherwise if ticket is not complete then move that ticket to
    next week payroll"*. Clarified in round 2 as "Week 1, until approved", never split.
  - **Superseded** by Corrina Bustos, verified, the same day: *"all tickets must be completed before
    the payroll can be processed/approved"*
    ([../decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md](../decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md)).
    The developer chose her rule. An incomplete ticket blocks its week and never rolls forward.
  - Recorded as superseded only. Nothing is built from it.
  - **This question stays open:** anchor or split for a *completed* ticket that crosses Saturday
    00:00. Corrina's note asks the same thing as its open item 3. The superseded answer is not a
    source for the anchor.
- **Owner:** **Brian Petros** and **Corrina Bustos**.
- **Rules:** [PAY-001](rules/PAY-001-saturday-friday-payroll-week.md),
  [PAY-019](rules/PAY-019-cross-midnight-processing.md)

## Multi-day entry — does the 8-hour OT and 12-hour DT ladder ever reset inside one entry

- **Status:** open — developer answered 2026-09-30 (never resets, as today); **pending Brian
  Petros / Corrina Bustos**.
- **Asked:** 2026-09-29, same origin as
  [*Multi-day entry — which pay period owns the hours after Saturday 00:00*](#multi-day-entry--which-pay-period-owns-the-hours-after-saturday-0000).
  **A pay rule**, so the engine will not change without a source in
  [payroll-rules-provenance.md](payroll-rules-provenance.md).
- **Question:** One continuous labor entry runs longer than 24 hours. Does the daily ladder (8 ST,
  OT to 12, DT after 12) ever start again inside it?
  - **Never:** one entry is one shift. After the 12th hour, every hour is DT or higher, however long
    it runs.
  - **It resets:** then say when, for example after an off-shift interval of some length. One entry
    cannot show time off, so those intervals would have to be captured, as separate entries or as
    breaks.
- **What the engine does today: never, inside one entry.**
  - `cumulative` and `stAccrued` carry through every slice of the entry
    (`packages/payroll-engine/src/calculate.ts:190-255`).
  - At midnight, the only change is that a premium date's top-up hours join the count (:205-207).
  - Once `cumulative` reaches 12, every slice is DT or higher (`day-type.ts:200`).
  - The ladder resets only **between** entries, when the gap between them is 8 hours or more
    (`CHAIN_GAP_HOURS`, `calculate.ts:632-660`; the reset is at :1103).
- **Sources checked:**
  - [*Cross-midnight OT carryover*](#cross-midnight-ot-carryover--the-incumbent-pays-no-st-after-midnight-and-the-erp-now-does-the-same)
    (open, built to the incumbent 2026-09-11). The ladder carries over midnight, with no fresh
    8-hour bank. That covers entries under 24 h. It does not consider an entry that goes on into
    another day.
  - *Rest chain — is a job-to-job gap a "rest period" at all?* (open). It is about the gap between
    entries, and a single entry has none.
  - [../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md)
    (`verified`): day type per slice, and the cumulative bucket never downgrades. It says nothing on
    resets. Its resolved companion entry, *Long-boom day breakdowns — drive time, cross-midnight,
    and the 20-hour day*, reaches a 20-hour day, not beyond 24.
- **Blocked:** nothing built yet. Today the engine prices a 24 h+ entry as never resetting.
- **Related, 2026-09-29 (interim, not an answer):** until this is answered, a ticket over 24 h is
  priced as the engine prices it today, and its week shows a review flag, *"ticket over 24 h, check
  pay rules"*. This is the developer's interim direction. See the decision note's
  [second addendum, item G](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#g-a-single-ticket-over-24-h-price-it-flag-it-for-review-amends-clause-6-added-later-on-2026-09-29).
- **Developer answer 2026-09-30** ([../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md), item A1, `reference`): **never resets** inside one
  entry. That keeps today's behaviour, so there is no engine change. It is a pay rule, so it stays
  **open** until Brian Petros and Corrina Bustos ratify.
- **Owner:** **Brian Petros** and **Corrina Bustos**.
- **Rules:** [PAY-022](rules/PAY-022-daily-straight-time.md),
  [PAY-023](rules/PAY-023-daily-overtime.md), [PAY-024](rules/PAY-024-daily-double-time.md),
  [PAY-045](rules/PAY-045-rest-period-premium.md)

## Daily and long-boom 4-hour minimums — grouped on the shift anchor date or on each calendar date

- **Status:** open. **Written sources conflict.** This is not only a gap. Developer answer
  2026-09-30: the anchor date, siding with the verified note; **pending Corrina Bustos / Brian
  Petros**.
- **Asked:** 2026-09-29, same origin as
  [*Multi-day entry — which pay period owns the hours after Saturday 00:00*](#multi-day-entry--which-pay-period-owns-the-hours-after-saturday-0000).
  **A pay rule.**
- **Question:** Are PAY-040's daily 4-hour minimum and PAY-043's long-boom 4-hour minimum owed once
  per **shift anchor date** (the date the entry started), or once per **calendar date** the work
  touches?
  - **Anchor date:** an entry's hours after midnight count toward its start date's minimum.
  - **Calendar date:** each date the entry touches is its own group.
  - Both give the same answer for an entry on one date. They differ on every cross-midnight entry.
    Example: Monday 06:00 → Wednesday 01:00. By calendar date, Wednesday holds 1 hour and is owed a
    3-hour top-up. By anchor date, nothing is owed.
- **The sources:**
  - **Anchor date:**
    [../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md):92-102,
    `status: verified`.
    - Its table puts the daily and long-boom minimums on `ShiftAnchorDate`, and the holiday and
      special-Saturday minimums on `CalendarDate`. It warns that collapsing both onto one "day" is
      wrong.
    - That table comes from the legacy engine (`usp_Apply_GuaranteedHours`). Corrina's own words in
      that note were about the holiday minimum.
  - **Calendar date:** [payroll-rules-provenance.md](payroll-rules-provenance.md):89-90
    (`status: reference`) says *"per calendar day"* for both minimums. It cites Brian Petros,
    2026-09-10, 35:46–36:28, with Corrina agreeing.
    - The meeting record
      ([../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md](../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md):138-141,
      `status: unverified`) quotes *"based on the calendar work day"* for the holiday 8-hour, 4-hour
      shift and 4-hour boom minimums.
    - **Its point was per day versus per labor entry.** It does not say which date an hour after
      midnight belongs to. The two sources may differ only in wording. Nobody has said so.
  - **Engine:** `applyCalendarDayMinimums` (`packages/payroll-engine/src/calculate.ts:756-779`).
    - Its doc comment says *"per calendar work day"* and quotes 2026-09-10.
    - It actually groups by `entry.day.workDate`, the date of the entry's first slice (:157, :392).
      So in effect it groups on the **anchor date**.
    - The holiday minimum is grouped per calendar date, separately (:1085-1095), as the verified
      note says.
- **Blocked:** nothing built yet. The engine's comment and its code disagree. Multi-day entries make
  the difference common.
- **Developer answer 2026-09-30** ([../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md), item A2, `reference`): the **start (anchor) date**, as
  the engine groups today.
  - **It takes a side in the conflict:** with the verified 2026-09-04 note (:92-102), against the
    provenance rows :89-90 (*"per calendar day"*).
  - A developer cannot settle a disagreement between two client-sourced records, so the entry
    stays **open**.
  - A one-line "yes, the anchor date" from Corrina or Brian would close it. The provenance rows'
    *"per calendar day"* would then need a clarifying note.
  - The engine's code already groups on the anchor date. Only its doc comment says *"per calendar
    work day"*.
- **Owner:** **Brian Petros** and **Corrina Bustos**. Corrina decided the verified note, so
  changing it needs her.
- **Rules:** [PAY-040](rules/PAY-040-work-provided-minimum.md),
  [PAY-043](rules/PAY-043-long-boom-premium.md)

## Multi-day entry — subsistence on a date reached only by a spill past midnight

- **Status:** open — developer answered 2026-09-30 (start date only, as today); **pending Brian
  Petros / Corrina Bustos**. For the $200 long tier the answer sits against a Confirmed row.
- **Asked:** 2026-09-29, same origin as
  [*Multi-day entry — which pay period owns the hours after Saturday 00:00*](#multi-day-entry--which-pay-period-owns-the-hours-after-saturday-0000).
  **A pay rule.**
- **Question:** An entry on a subsistence job runs past midnight into the next date or dates. Does
  a date the entry reaches only by running past midnight earn a subsistence day?
  - **Yes:** every date the entry touches earns one.
  - **No:** only the date it started.
  - Both tiers need the answer:
    - **Short, $85/day, "days worked":** is a spill-only date a day worked?
    - **Long, $200/day, "every day of the holdover":** is every date one entry touches a holdover
      day?
- **What the engine does today: start date only.**
  - `applySubsistence` (`packages/payroll-engine/src/calculate.ts:923-968`) keys on `jobId` plus
    `entry.day.workDate`, the entry's start date (:944). It pays once per key.
  - One entry from Monday 06:00 to Wednesday 10:00 pays one day, Monday.
  - The same work as one ticket per day pays three.
- **Sources checked:**
  - [payroll-rules-provenance.md](payroll-rules-provenance.md):128, **Confirmed**: *"$200/day
    beyond 77.5 mi, every day of the holdover"*.
  - [*Subsistence — the recording and the engine disagree*](#subsistence--the-recording-and-the-engine-disagree-on-both-the-amount-and-the-trigger)
    (answered): *"every calendar day of the holdover, worked or not"* (:1348).
  - [../decisions/2026-09-01-subsistence-not-a-craft-attribute.md](../decisions/2026-09-01-subsistence-not-a-craft-attribute.md).
  - None of these considers one entry over several dates.
- **Blocked:** nothing built yet. A multi-day single ticket pays fewer subsistence days than the
  same work as one ticket per day.
- **Related, 2026-09-29 (interim, not an answer):** until this is answered, a ticket over 24 h is
  priced as the engine prices it today, which pays the start date only. Its week shows a review
  flag, *"ticket over 24 h, check pay rules"*. This is the developer's interim direction. See the
  decision note's
  [second addendum, item G](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#g-a-single-ticket-over-24-h-price-it-flag-it-for-review-amends-clause-6-added-later-on-2026-09-29).
  The flag covers only tickets over 24 h. An overnight ticket shorter than 24 h also reaches a
  second date, and it gets no flag.
- **Developer answer 2026-09-30** ([../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md), item A4, `reference`): **the start date only**, as
  today. Pending ratification.
  - **For the $200 long tier, this sits against a Confirmed rule:**
    [payroll-rules-provenance.md](payroll-rules-provenance.md):130 (*"every day of the holdover"*)
    and the answered entry above (*"every calendar day of the holdover, worked or not"*).
    - The later dates of one multi-date entry on a holdover job are calendar days of the holdover.
      Start-date-only pays none of them.
    - A developer answer cannot override a Confirmed rule, so for the long tier it is **not to be
      relied on**.
  - **For the $85 tier** (*"days worked"*): is a spill-only date a day worked? That stays the open
    question. The developer says no.
- **Owner:** **Brian Petros** and **Corrina Bustos**.
- **Rules:** [PAY-048](rules/PAY-048-standard-subsistence.md),
  [PAY-049](rules/PAY-049-weekend-subsistence.md)

## Multi-day entry — meal and WTL opportunities after 27 hours

- **Status:** open — developer answered 2026-09-30 (continue every 5.5 h). **That changes pay:
  not to be built until Brian Petros / Corrina Bustos ratify.**
- **Asked:** 2026-09-29, same origin as
  [*Multi-day entry — which pay period owns the hours after Saturday 00:00*](#multi-day-entry--which-pay-period-owns-the-hours-after-saturday-0000).
  **A pay rule.**
- **Question:** On one entry longer than 27 hours, is a fifth meal period due, and more after it?
  - **Continue the cadence:** one every 5.5 hours, so the fifth at 27 h, the sixth at 32.5 h, and so
    on.
  - **Cap at four.**
- **What the engine does today: caps at four.**
  - `MEAL_OPPORTUNITY_HOURS = [5, 10.5, 16, 21.5]`
    (`packages/payroll-engine/src/meal-periods.ts:35`), counted at :151.
  - The WTL check uses `WTL_TRIGGERS = [5.01, 10.51, 16.01, 21.51]`
    (`calculate.ts:43`, :101-112).
  - After 21.5 h, no further meal is due and no WTL issue is raised, however long the entry runs.
  - Capture has four lunch slots to match (`calculate.ts:105`:
    `VISIBLE_LUNCH_BREAKS === WTL_TRIGGERS.length`).
- **Sources checked:**
  - MLA *Meal Periods* §1, quoted in
    [*Lunch thresholds*](#lunch-thresholds--the-recording-is-the-origin-and-it-disagrees-with-the-wtl-charts):
    *"No employee shall be required to work more than five (5) hours consecutively without a
    one-half (½) hour meal period."* It sets no upper limit.
  - In the same entry: the legacy config `cfg.WTL_MaxMealThreshold` stops at the band
    *22–27 h → 4*.
  - The open entries [*Lunch thresholds*](#lunch-thresholds--the-recording-is-the-origin-and-it-disagrees-with-the-wtl-charts)
    (the third and fourth thresholds) and
    [*Meal thresholds — we count per labor entry*](#meal-thresholds--we-count-per-labor-entry-the-incumbent-counts-per-stitched-group).
    Neither goes past four.
- **Blocked:** nothing built yet. A 30-hour entry today owes no meal after 21.5 h.
- **Related, 2026-09-29 (interim, not an answer):** until this is answered, a ticket over 24 h is
  priced as the engine prices it today, with no meal due after 21.5 h. Its week shows a review flag,
  *"ticket over 24 h, check pay rules"*. This is the developer's interim direction. See the decision
  note's
  [second addendum, item G](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#g-a-single-ticket-over-24-h-price-it-flag-it-for-review-amends-clause-6-added-later-on-2026-09-29).
- **Developer answer 2026-09-30** ([../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md), item B1, `reference`): **continue the cadence**, one
  every 5.5 h: the fifth at 27 h, the sixth at 32.5 h, and so on. WTL is checked at each.
  - **This changes pay. Not to be built until ratified.**
  - Building it needs:
    - an engine change;
    - more lunch slots in capture (`VISIBLE_LUNCH_BREAKS === WTL_TRIGGERS.length`);
    - a row in [payroll-rules-provenance.md](payroll-rules-provenance.md), in the same commit.
  - The fifth's position follows the first four, which are still contested (16.0 vs 16.5 h,
    21.5 vs 22 h). With 22, the fifth falls at 27.5 h.
- **Owner:** **Brian Petros** and **Corrina Bustos**.
- **Rules:** [PAY-046](rules/PAY-046-meal-opportunity.md),
  [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md)

## Multi-day entry — the non-union workday for an entry longer than 24 hours

- **Status:** open — developer answered 2026-09-30 (split at each midnight). **That changes pay:
  not to be built until Brian Petros / Corrina Bustos ratify.**
- **Asked:** 2026-09-29, same origin as
  [*Multi-day entry — which pay period owns the hours after Saturday 00:00*](#multi-day-entry--which-pay-period-owns-the-hours-after-saturday-0000).
  **A pay rule.**
- **Question:** For Non-Union Admin Hourly, one entry runs longer than 24 hours. Do all its hours
  stay in the workday it started on? Or does each calendar date become its own workday, for daily
  OT/DT and the seventh-day count?
  - **The start workday owns every hour.**
  - **Split at each midnight.**
- **What the engine does today: the start workday owns every hour.**
  - `packages/payroll-engine/src/non-union.ts:12-13`: *"Every entry belongs to one workday: the
    calendar date it started on."* The entry's workday is its first slice's date (:44-45).
  - A 30-hour entry lands in one workday: at most 8 ST, then 4 daily OT, then 18 daily DT.
  - The next date shows no hours from it. So that date is not a worked day for the seventh-day rule
    (:73-75).
- **Sources checked:**
  - [non-union-hourly-rules-2026-09-07.md](non-union-hourly-rules-2026-09-07.md) §10 (:104-109),
    `status: unverified`.
    - Its example is 7:00 PM → 1:30 AM. It says the workday *"must remain available"*, so hours do
      not land in the wrong day or week.
    - It does not say how long a workday is, or what happens past 24 hours.
  - [*Non-union hourly — holidays, PTO, sick…*](#non-union-hourly--holidays-pto-sick-vacation-shift-differential-minimums-unspecified-by-the-clients-own-account)
    (open) does not cover this.
- **Blocked:** nothing built yet.
- **Developer answer 2026-09-30** ([../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md), item B2, `reference`): **split at each midnight.**
  Each calendar date is its own workday:
  - the daily 8/12 ladder restarts on each date;
  - each date counts toward the seventh-day rule.

  **This changes pay. Not to be built until ratified.** When it is built, it needs a row in
  [payroll-rules-provenance.md](payroll-rules-provenance.md) in the same commit.
  - **Not asked, and needed before building:** does the split fall at the first midnight too?
    - If so, a 25 h entry is cut where a 23 h entry is not; under §10, the 23 h entry stays in its
      start workday.
    - Or does the split apply only after the first 24 h?
- **Owner:** **Brian Petros**, who wrote the non-union rules, and **Corrina Bustos**.
- **Rules:** [PAY-012](rules/PAY-012-non-union-hourly-rate.md)

## Multi-day entry — DAILY catalog premiums once per ticket or once per calendar date

- **Status:** open — developer answered 2026-09-30 (once per ticket, as today); **pending Brian
  Petros / Corrina Bustos**.
- **Asked:** 2026-09-29, same origin as
  [*Multi-day entry — which pay period owns the hours after Saturday 00:00*](#multi-day-entry--which-pay-period-owns-the-hours-after-saturday-0000).
  **A pay rule.**
- **Question:** A payroll premium with basis `DAILY` applies to one entry that runs over several
  dates. Is it paid once for the ticket, or once for each calendar date the entry touches?
  - **Once per ticket.**
  - **Once per calendar date.**
- **What the engine does today: once per entry.**
  - `packages/payroll-engine/src/calculate.ts:372-373` adds one flat component per priced entry:
    `addComponent(components, premium.ruleId, premium.label, 1, premium.amount)`.
  - Its comment says *"DAILY pays once for the day, flat"*. The "day" it means is the entry.
  - One 30-hour ticket pays it once. The same work as one ticket per day pays it two or three times.
- **Sources checked:**
  - The basis is `PayrollPremiumBasis.DAILY` (`apps/api/prisma/schema.prisma:237-240`).
  - The open entries
    [*Payroll premium catalog — configured per tenant, or constants in the engine*](#payroll-premium-catalog--configured-per-tenant-or-constants-in-the-engine)
    and [*Premium catalog CRUD*](#premium-catalog-crud--the-engine-reads-six-literal-codes-not-the-catalog)
    are about where premiums are configured. They do not say how often a DAILY one pays.
  - No written rule defines "day" for a DAILY premium.
- **Blocked:** nothing built yet.
- **Developer answer 2026-09-30** ([../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md), item A3, `reference`): **once per ticket**, as today.
  No engine change. Pending ratification.
- **Owner:** **Brian Petros** and **Corrina Bustos**.
- **Rules:** none of its own. It is a property of the premium catalog.

## Multi-day entry — a craft rate change that takes effect inside one entry

- **Status:** open — developer answered 2026-09-30 (the start rate, as today); **pending Brian
  Petros / Corrina Bustos**.
- **Asked:** 2026-09-29, same origin as
  [*Multi-day entry — which pay period owns the hours after Saturday 00:00*](#multi-day-entry--which-pay-period-owns-the-hours-after-saturday-0000).
  **A pay rule.**
- **Question:** A craft code's base rate changes on a date that falls inside one running entry, for
  example the July 1 union increase. Do the hours after the change take the new rate? Or does the
  whole entry keep the rate in force when it started?
  - **Start rate for the whole entry.**
  - **Split at the effective date:** slices on or after it take the new rate.
- **What the API and engine do today: the start rate, for the whole entry.**
  - Pricing resolves one rate per entry: `rates.resolve({ workDate: shiftStartedAt, … })`.
    - Working tree: `apps/api/src/usecase/payroll-pricing/payroll-week-pricing.service.ts:473-482`,
      uncommitted on `fix/payroll-correction-page-ui`.
    - `main`: `apps/api/src/usecase/payroll/payroll.service.ts:1333-1335`.
  - The engine prices every slice at that one `baseRate` (`calculate.ts:285-295`).
  - **Noticed, not investigated, not a pay-rule question:** the resolver cuts `shiftStartedAt` to
    its **UTC** date (`asWorkDate`,
    `apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts:160-165`, used at
    :279). An entry starting at or after 17:00 PDT (16:00 PST) looks up the next date's rate. On the
    evening before a rate change, that affects entries of any length.
- **Sources checked:**
  - [*Annual craft-rate change*](#annual-craft-rate-change--nine-codes-one-rule-no-bulk-path)
    (resolved 2026-09-07): rates change every July 1 (Corrina). It does not say what happens to an
    entry running across the change.
  - [rules/PAY-010](rules/PAY-010-l12-union-base-rate.md): the labor entry's craft prices the row.
    It says nothing about time within the entry.
- **Blocked:** nothing built yet.
- **Developer answer 2026-09-30** ([../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md), item A5, `reference`): **the start rate for the whole
  ticket**, as today. No engine change. Pending ratification. It does not touch the UTC
  `asWorkDate` cut noticed above.
- **Owner:** **Brian Petros** and **Corrina Bustos**.
- **Rules:** [PAY-010](rules/PAY-010-l12-union-base-rate.md)

## Payable time — Start Work to End Work, or yard to yard

- **Status:** resolved 2026-09-29 — **the developer's final definition withdrew the conflicting
  direction, and it matches the verified decision.** Payable time is Start Ticket → End Ticket. That
  is `WORK_TIME`, the span the engine prices, and the span the verified 2026-09-03 decision is built
  as. The verified decision stands, unchanged. No pay rule, engine code or provenance row changes.
  See the
  [third 2026-09-29 addendum](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#addendum-2026-09-29-third--payable-window-on-the-correction-page).
  The rest of this entry is kept as the record of what was in question.
- **Resolution:**
  - The developer's final words, 2026-09-29, same session: *"the payable time will be when i came
    from home to start and click on start ticket on clicking on start ticket to till end ticket all
    that time should be payable not let yard to arrived yard time"*.
  - **Start Ticket** is the Start Work button on mobile's ticket card: the punch-in that opens
    `WORK_TIME` (`apps/mobile/components/field/ticket-card.tsx:361`, `:506`;
    `apps/mobile/components/field/work-time-banner.tsx:39`, *"Start work to begin recording paid
    hours"*).
  - **End Ticket** is Submit ticket on the Review step, which closes `WORK_TIME`
    (`apps/mobile/features/field-ticket/steps/review/ReviewBody.tsx:553-555`, `:635`).
  - The correction page's *Paid window* and *Labor Total* (+30 min per WTL) now show that span,
    the same one payroll prices. The earlier End Work reading below is superseded.
  - **This resolution rests on the verified note, not on the developer's authority.** The developer
    withdrew a reading that contradicted it.
  - **Still open, elsewhere:**
    [*Recording which time source paid a job day (PAY-017, TCG-178)*](#recording-which-time-source-paid-a-job-day-pay-017-tcg-178),
    questions 2 and 3. Is the punch-in the verified note's dispatch start? Is Review & Complete its
    yard return?
- **Asked:** 2026-09-29, while recording the
  [third 2026-09-29 addendum (payable window on the correction page)](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#addendum-2026-09-29-third--payable-window-on-the-correction-page).
  The developer (git user `devmohsinakram`) chose Start Work → End Work as the payable time. By
  their own definition, that is **punch-in → End Work (break-down end)**. No ticket covers Send
  Back, so this is filed here, not in a `spec.md` §12. **This is a pay rule.** The engine will not
  change until the answer is written in [payroll-rules-provenance.md](payroll-rules-provenance.md).
- **Question:** Is payable time **Start Work → End Work** (punch-in → break-down end), or **yard to
  yard** (punch-in → Review & Complete)?
  - **Both start at the punch-in.** The only question is where paid time ends.
  - **Yard to yard:** the verified 2026-09-03 decision stands, and the engine stays as built. The
    correction page's *Paid window* and *Labor Total* go back to punch-in → Review & Complete.
  - **Start Work → End Work:** the verified 2026-09-03 decision is superseded, and what every
    employee is paid changes. Everything after break-down ends falls outside paid time: the
    customer sign-off, leaving the site, the drive back, and the post-trip and sign-off at the yard.
- **The one-line reply that settles it:** *"Paid time ends (a) at Review & Complete, back at the
  yard, as decided on 2026-09-03, or (b) at End Work, when break-down ends on site."*
- **The sources:**
  - **Yard to yard:**
    [../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md),
    **`status: verified`**. Kyle Harlow and Joe Schacatano decided it; Corrina Bustos concurred.
    - Kyle Harlow, 47:57, on the pre-trip before the crane leaves the yard: *"They're paid the
      whole entire time, yes."*
    - Kyle Harlow, 53:54: *"Yes"*, to paid hours ending *"whenever they leave with all of the
      paperwork done and leave the equipment back at the yard"*.
    - The note itself (:101-102): *"The return leg is paid time, and so is the post-trip work at
      the yard. Paid span is yard to yard, not yard to job to job-exit."*
    - [payroll-rules-provenance.md](payroll-rules-provenance.md):61, *Paid time — start and end*,
      **Confirmed**.
  - **Start Work → End Work:** the developer, 2026-09-29, in a Syed Haris Claude Code session.
    - **Their definition of the two words:** *"start work is always first entery when we atsrt
      ticket and endworking is last entery of job then we get back at yard and siging off from yard
      it should auto udgest when we increase the time anything between them"*.
      - The ticket's first entry is the punch-in on the ticket's card, which opens `WORK_TIME`
        (`apps/api/src/usecase/job-tickets/ticket-step.constants.ts:7`, `:73`, `:88`).
      - The job's last entry is End Work, before the return to the yard and the sign-off.
    - Also: *"on mobile app time logging main time is Start Work Time to End Work Time but i think
      you are getting Left Yard Time to End Job Time … you are getting confused because of names
      but functionality is diff fix them"*.
    - Then they were asked explicitly, with the verified decision quoted. They chose "Start Work →
      End Work" over *"Punch-in → Review & Complete (recommended)"*.
    - The option they chose read: *"Pay only the build-up start → break-down end span. That changes
      what every employee is paid, contradicts the verified 2026-09-03 decision, and needs a
      written ruling from Kyle Harlow and Corrina Bustos plus a payroll-engine change. I would
      record the question and not change pay until they answer."*
      - **"Build-up start → break-down end" was the session's gloss, not the developer's.** Their
        own definition, above, supersedes it: the span starts at the punch-in, not at build-up.
      - They were not asked again after choosing.
    - It is a developer's `reference` decision. Nobody at TCG has ratified it.
    - **It is not mobile's Labor Total.**
      - Mobile's Labor Total is the boom timer plus 30 min per WTL, and it starts at build-up
        (`apps/mobile/features/field-ticket/steps/shared/payable-time/labor-hours.ts:74-96`;
        SCRUM-877 REQ-01 `[VERIFIED]`,
        [../../aidlc/SCRUM-877/spec.md](../../aidlc/SCRUM-877/spec.md):145-150).
      - The SCRUM-877 decision does not make its Labor Total the paid span. It calls Labor Total
        *"a field-ops-local figure that may not equal whatever payroll's future engine
        eventually computes"*
        ([../decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md](../decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md):209-212,
        `verified`).
- **What is built:**
  - **The engine prices `WORK_TIME`: punch-in → Review & Complete.** When the member has their own
    TCG-25 window, it prices that instead.
    - `apps/api/src/usecase/payroll/payroll.service.ts:1286-1293` on `main`.
    - `apps/api/src/usecase/payroll-pricing/payroll-week-pricing.service.ts:467-474` in the working
      tree of `fix/payroll-correction-page-ui`, uncommitted.
    - `payableWindow` is `WORK_TIME`
      (`apps/api/src/usecase/ticket-time-entries/derive-ticket-times.ts:311`). The punch-in opens
      it and Review & Complete closes it
      (`apps/api/src/usecase/job-tickets/ticket-step.constants.ts:73`, `:77`).
  - **The correction page displays punch-in → End Work**, per the developer.
    - Its *Paid window* is that span. Its *Labor Total* is that span plus 30 min per WTL.
    - **Start:** the page's *Start Work Time*, which is the punch-in, or the member's own window
      start (`apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:379`).
    - **End:** *End Work Time*, `WORK_AT_JOB_SITE_TIME` end, which mobile closes when the break-down
      timer ends (`payroll-send-backs.service.ts:380`; `ticket-step.constants.ts:74`;
      `apps/mobile/features/field-ticket/steps/start-work/StartWorkBody.tsx:261-274`).
    - Its pay estimate is priced by the engine on `WORK_TIME`, and is labelled that way.
    - Uncommitted on `fix/payroll-correction-page-ui`, and not yet built when this was recorded.
  - **Mobile's in-flow `startWork` capture is a different instant.** It is the start of build-up,
    not the punch-in. It is not the page's Start Work.
  - **Until this is answered, the page's *Paid window* is not what payroll pays.** It is shorter by
    everything after break-down ends.
- **Changing the engine is a pay-rule change.** Its source must be written into
  [payroll-rules-provenance.md](payroll-rules-provenance.md) **in the same commit** as the code. It
  replaces the *Paid time — start and end* row (:61).
  - The rule is `CLAUDE.md`'s `packages/payroll-engine/` row, and
    `.ai/claude/contexts/payroll-engine.md`.
  - The window itself is chosen in `apps/api`, at the pricing service above.
  - Answer (b) also needs a decision note naming who decided. That note would supersede the
    2026-09-03 decision.
- **Blocked:**
  - Any change to the paid span.
  - Merging `fix/payroll-correction-page-ui` as directed puts a figure labelled *Paid window* in
    front of Crane Supervisors that disagrees with what payroll pays.
- **Related:**
  - [*Recording which time source paid a job day (PAY-017, TCG-178)*](#recording-which-time-source-paid-a-job-day-pay-017-tcg-178),
    question 3. It asks whether the code's Review & Complete is the verified decision's yard
    return. This entry asks whether paid time reaches the yard at all.
- **Owner:** **Kyle Harlow** and **Corrina Bustos**, who must rule in writing, with **Brian
  Petros**. The verified note's end boundary is Kyle Harlow's (50:33, 53:54). Joe Schacatano
  co-decided the note.
- **Rules:** [PAY-017](rules/PAY-017-time-source-selection.md),
  [PAY-021](rules/PAY-021-l12-standard-work-window.md)

## Send Back of a multi-crew ticket — does sending a ticket back also return it for the other crew members on that ticket?

- **Status:** open — developer answered 2026-09-30: **(c), plus a hold on every worker's week**.
  It extends Corrina's verified worker-target rule, so it is **pending Corrina Bustos**.
- **Asked:** 2026-09-30, while recording the
  [fifth addendum (independent date rows on the weekly timesheet)](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#addendum-2026-09-30-fifth--independent-date-rows-on-the-weekly-timesheet),
  item D. No ticket covers Send Back (the decision names none), so it is filed here, not in a
  `spec.md` §12.
  - The developer (git user `devmohsinakram`, PR #699) said on 2026-09-30: *"when send that ticket
    back for corrrection like for 27 or 28 it should send all ticket back not jut 27 or 28 one
    entry"*.
  - The session read "all ticket" as **every date of this employee's entry** on that ticket. That
    is how Send Back already worked. It did not read it as every crew member on the ticket, and
    the developer was not asked.
- **Question:** Payroll sends back one employee's entry on a ticket that has other crew members.
  What happens to the other crew members' entries on that ticket?
  - **(a) Left alone (as built):** only this employee's entry is returned and held. The others'
    pay changes when the period is recalculated, with no send-back of their own.
  - **(b) Held:** the other crew members' weeks are held from approval until the correction is
    priced, but not returned.
  - **(c) Returned too:** the send-back covers every crew member's entry on that ticket.
- **The one-line reply that settles it:** *"When one crew member's entry is sent back, the other
  crew members on that ticket are (a) left alone until the period is recalculated, (b) held from
  approval until it is, or (c) sent back too."*
- **What the code does today: (a).** `apps/api` is unchanged in the working tree, so these lines
  are as of commit `b3c992f10`.
  - **A send-back is per (period, job ticket, employee).** `sendBack` creates one row per selected
    ticket for the one employee
    (`apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:258-268`). It refuses a
    second open one by period, employee and ticket (`:246-256`). The model is *"A payroll entry (one
    employee on one job ticket)"* (`apps/api/prisma/schema.prisma:5307`).
  - **A correction writes the ticket's shared time captures**, which every crew member's pay is
    priced from
    (`apps/api/src/service/payroll-send-backs/payroll-send-backs.repository.ts:541-574`). Only
    Start Work and End Job with the member's own TCG-25 window are per member (decision clause 4).
  - **Holds are per employee.**
    - `countBlockingByEmployee` counts only the send-back's own `employeeId`
      (`payroll-send-backs.repository.ts:614-676`).
    - Approving one week checks only that week's employee
      (`apps/api/src/usecase/payroll/payroll.service.ts:659-671`).
    - So **another crew member's week carries no send-back and no approval hold.** Its figures in
      force predate the correction until the period is recalculated, and this check does not stop
      that week being approved in between.
    - Approving the **whole period** is refused, because the sent-back employee's hold counts there.
  - **The one cross-crew guard protects settled pay only.** A correction that moves shared times is
    refused while another crew member's pay on that ticket is already approved or exported
    (`payroll-send-backs.service.ts:756-767`; `findSettledCrewPay`,
    `payroll-send-backs.repository.ts:678`). It does not cover a week still awaiting approval.
  - **The other crew members are checked, not told.** The correction runs the overlap and rest
    checks for each crew member (decision clause 4). The only notification on correction,
    `payroll.entry_corrected`, goes to whoever sent the entry back
    (`payroll-send-backs.service.ts:518-532`).
- **Sources checked:**
  - [../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md),
    `status: reference`.
    - Clause 3: Send Back goes to one Crane Supervisor.
    - Clause 4: shared Start Work and End Job edits apply to the **whole crew**; the whole crew is
      checked for overlap and rest; settled crew pay is protected; a corrected entry holds approval
      until the period is recalculated.
    - Clause 6: an uncorrected send-back blocks that employee's week and the whole period.
    - None says whether the other crew members are returned or held.
  - The Confluence story `Payroll management` US-03, `unverified`, never migrated
    ([../sync/.conflict/2026-08-24-bootstrap/payroll-management.md](../sync/.conflict/2026-08-24-bootstrap/payroll-management.md)
    :112-127). It sends back an *entry*, lets several entries be selected (AC 14), and lets the
    Worker edit *"the specified ticket"* (AC 4). It says nothing about other crew members.
  - `decisions/`: no other note mentions Send Back.
- **Blocked:** nothing built waits on it. But:
  - if the answer is **(b)** or **(c)**, the API must extend the hold or the send-back to the
    crew (`countBlockingByEmployee`, `sendBack`);
  - until then, a co-crew member's week can be approved on figures that a shared-time correction
    has made stale.
- **Developer answer 2026-09-30** ([../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md), item C6, `reference`, pending Corrina Bustos):
  - Round 3: *return it for everyone*. That is option (c).
  - Round 6, verbatim, after Corrina's worker-target rule was put to the developer: *"we have rule
    if any job have oiler and oprator both then oiler and oprator have one tickt so if we send oiler
    or oprator ticket back it should send other employee as well and block both employees
    payroll"*.
  - **So:** sending back one worker's entry on a shared ticket sends the ticket back to **every
    worker on it**, and **blocks every one of their weeks** until it is resolved. That is (c), with
    (b)'s hold.
  - The shared ticket is the verified shape in
    [../decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md](../decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md)
    clause 2. The Oiler is primary and fills the ticket; the Operator is a second employee on it.
  - **Why it stays open:**
    - Since 2026-09-30, Send Back goes to the **worker**, and payroll fixes entries itself
      (Corrina, verified —
      [../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)).
      The developer's rule extends that from one worker to all of them, and it needs her OK.
    - It is in tension with her verified *"individual"*
      ([../decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](../decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md)
      clause 3). If the Oiler edits the shared ticket on mobile, does the Operator's pay move too?
      Not stated.
  - **Build:** an API change, not built (`sendBack`, `countBlockingByEmployee`).
  - **Ratifier:** Corrina Bustos, whose rule it extends.
- **Stale lines above, corrected 2026-09-30:**
  - *Sources checked*, *"`decisions/`: no other note mentions Send Back"*: out of date. Send Back is
    addressed by the 2026-09-29 routing note and by the 2026-09-30 flag-list note, which gives the
    worker as target and a reminder after 3 h.
  - *Sources checked*, clause 3's Crane Supervisor target: overruled since 2026-09-29.
- **Owner:** **Brian Petros** and **Corrina Bustos**, the payroll-side ratifiers the decision
  names for clauses 3 and 6 (who is sent an entry, and what blocks approval). The decision gives
  clause 4, that shared edits move the whole crew, to **the TCG field-ops owner**. No field-ops
  owner is named for this question.
- **Related:**
  - [*Should a Crane Supervisor see an employee's pay in the correction preview without payroll view*](#should-a-crane-supervisor-see-an-employees-pay-in-the-correction-preview-without-payroll-view),
    the other open Send Back question.
  - [*Confluence payroll user stories*](#confluence-payroll-user-stories--first-payroll-pages-in-confluence-unmigrated),
    where the *Worker* send-back target stays open.
- **Update 2026-10-07: Melissa McNutt's provisional answers bear on the superintendent's role.**
  - In written Teams answers posted on or before 2026-10-06
    ([../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md),
    `reference`, T2–T3):
    - To *"should supervisors/dispatchers also be able to complete or correct tickets on their
      behalf?"* she answered *"Yes"*.
    - Late and post-submit edits are approved by *"manager or payroll"*. Which manager is not said.
    - Managers and payroll get the late-completion notices and the overdue report.
  - This touches C6 (may the superintendent still act outside the flag flow?) and this entry's
    routing.
  - TCG asked to hold the answers until an updated version is sent.
  - Filed once:
    [*Who may complete or correct a ticket on a worker's behalf, and who approves a late or post-submit edit*](#who-may-complete-or-correct-a-ticket-on-a-workers-behalf-and-who-approves-a-late-or-post-submit-edit--manager-or-payroll).

## DAS holdover vs subsistence holdover — pointer, owned by dispatch

- **Status:** open
- **Asked:** 2026-09-29 — building Make Holdover (branch `feat/schedule-datetime-holdover`, not merged).
- **Question:** **Pointer only — the question lives in
  [../dispatch/gaps.md](../dispatch/gaps.md) → *Is the DAS holdover the same thing as payroll's
  subsistence holdover?*** Dispatch now marks held items per job line (`JobResource.isHoldover`);
  payroll's `Job.subsistenceHoldover` is unchanged and unlinked. Whether they are one fact decides
  whether PAY-049's "every day of the holdover, worked or not" can be fed from dispatch.
- **Owner:** Lisette Anzaldo with Corrina Bustos.
- **Rules:** [PAY-048](rules/PAY-048-standard-subsistence.md), [PAY-049](rules/PAY-049-weekend-subsistence.md)

## A shift longer than 24 hours — how is it paid?

- **Status:** open
- **Asked:** 2026-10-01 — a job schedule shift may now run past 24 hours
  ([../decisions/2026-09-30-schedule-shift-may-run-past-24-hours.md](../decisions/2026-09-30-schedule-shift-may-run-past-24-hours.md),
  syed.haris, CodingCops, `reference`; built on tcg branch `feat/schedule-datetime-holdover`, not
  merged). syed.haris asked to check the vault for how such a shift is paid.
- **What the vault says:** nothing rules on one entry past 24 hours. Up to about 24 hours,
  union time counts from the shift's start across midnight and every hour past 12 is double time
  (MLA Art. III *Shifts* §1, unverified; Corrina 2026-09-10, PAY-024 open; legacy
  `legacy-payroll-app-db-extract/rules-plain-language.md` §2). Day type is per calendar day and
  the higher rate wins
  ([../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md),
  verified, one midnight only). Brian splits imported FCC entries at 23.5 h and the halves chain
  into one shift (PAY-004 / PAY-023, open). The only worked example past 24 h is the WTL chart's
  26-hour Monday ([wtl-charts.md](wtl-charts.md), unverified, arithmetic not trusted). Every
  dispatched job is L12, so a scheduled crew shift is a union case.
- **What the engine does today:** union — after the start date every weekday half-hour is
  overtime and everything past 12 hours is double time, with no reset
  (`packages/payroll-engine/src/day-type.ts`); non-union — the whole entry is one workday, its
  start date (`src/non-union.ts`), so later days never count toward the seventh-day rule; a
  Friday-to-Sunday entry lands entirely in the week ending Friday.
- **It also contradicts two existing answers.** Kyle Harlow, 2026-06-18
  (`meetings/transcripts/2026-06-18-dispatch-permits.md` 1:35:04, reference): *"not ever going
  over 24 hours"*. And the confirmed flag list
  ([../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md),
  verified) blocks approval of any shift over 24 hours, with the 24 vs 23.5 h threshold still
  open (Q7 above); the correction form refuses windows over 23.5 h.
- **Questions for Corrina Bustos / Brian Petros:**
  1. Union: on one continuous shift over 24 h with no 8-hour break, is every hour after 12
     double time to the end, or does the 8/12 count restart at midnight or at 24 h?
  2. Union: on the third and later calendar days of such a shift, are weekday 06:00–17:00 hours
     overtime (the incumbent's carryover) or straight time?
  3. Non-union (admin/yard): is each calendar day of a multi-day entry its own 8/12 workday that
     counts toward the seventh-day rule, or does the whole entry sit on its start date?
  4. A Friday 20:00 → Sunday entry: are the hours after Friday midnight paid in the next
     Saturday–Friday week, or the whole entry in the week it started?
  5. Is the invalid-time flag "over 24 hours" or "over 23.5 hours", and does a genuine long shift
     clear it with "reviewed, no change"?
  6. Should the ERP refuse, flag, or allow a scheduled shift over 24 hours at all? (With Kyle and
     Lisette — see [../dispatch/gaps.md](../dispatch/gaps.md) → *Schedule times on a later day* (f).)
  7. After the 4th meal (21.5 h), when are the 5th and later meals owed on a shift over 27 h?
  8. When the last calendar day of a multi-day shift has under 4 h, does the daily 4-hour minimum
     apply to that day?
- **Blocked:** merging the >24-hour schedule picker to `main` (recommended), and any payroll
  change for multi-day entries.
- **Owner:** Corrina Bustos (payroll) with Brian Petros (engine); Kyle Harlow and Lisette
  Anzaldo for question 6.

## Holdover days 2+ — does paid time start on arrival at the job site, and where does each day end?

- **Status:** partially resolved — see [../decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md](../decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md) (H7, S3: step flow and payroll flag exemptions decided; the pay-start question — does pay start at arrival on site vs the verified yard-to-yard boundary — remains open with TCG)
- **Asked:** 2026-10-07 — recording Melissa McNutt's provisional holdover answers
  ([../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md),
  `reference`, T4). TCG asked on 2026-10-06 to hold those answers until an updated version is sent.
  **Rules:** PAY-017, PAY-021, PAY-004.
- **What she wrote:**
  - On days 2+ the crew *"just reports to the job site"*, *"99% of the time"* in a personal car.
    *"Certain one off situations if the job is far we'd let them take a company truck."*
  - Asked when the oiler's *"billable time"* starts on such a day: *"Arrives at the job site"*.
  - Last day: *"If they break down on the last day only then the end of that day is when they leave
    the site. The end of the job will be when the equipment returns back to our yard."*
  - She also said yes to a post-trip, breakdown and return to the yard at the end of the final day.
- **Conflict, recorded not resolved:**
  - The verified
    [../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md)
    starts paid time at the dispatch start time at the yard and ends it back at the yard, with **no
    holdover exception**.
  - The verified crew-time flag compares the job's start and the return to the yard
    ([../decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md](../decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md)).
    That was ratified as Left Yard / Arrived at Yard. A holdover day 2+ has no Left Yard.
  - Her answer agrees with the 2026-05-21 record:
    [../meetings/transcripts/2026-05-21-crane-configurations-job-tickets.md](../meetings/transcripts/2026-05-21-crane-configurations-job-tickets.md),
    54:14–54:44. The journey on holdover days starts at the job and ends at *left job*, *"unless we
    need them back in the yard"*. So this reads as a missing holdover case, not a reversal. TCG has
    to say so.
- **Questions**, each phrased so a one-line reply settles it:
  1. **Pay or billing?** The question said *"billable"*. On a holdover day 2+, does **pay** start on
     arrival at the job site? Customer billing is a separate question:
     [../accounting/gaps.md → *Billable hours*](../accounting/gaps.md#billable-hours--the-recordings-say-portal-to-portal-the-jira-decision-says-boom-time-plus-wtl).
  2. **Company-truck day.** When the crew takes a company truck from the yard (her *"one off"*;
     Wes Staley 2026-05-21 1:11:59), does pay start at the yard as on a normal day, or still on
     arrival at the site?
  3. **Day 1 end.** The crane stays built on site. Does the crew's Day 1 end when they leave the
     site, or back at the yard (for example, returning the tractor)?
  4. **Days 2+ end.** Does each day in between end on leaving the site (*left job*)?
  5. **Last day end.** Does the last day end when they leave the site (A11, first sentence), or when
     the equipment is back at the yard (A11, second sentence; A12; the verified rule)?
  6. **Crew-time flag.** On a holdover day with no yard leg, which captures does the flag compare?
     Or is the day exempt?
- **Sources checked:** the notes above;
  [rules/PAY-017-time-source-selection.md](rules/PAY-017-time-source-selection.md);
  [rules/PAY-021-l12-standard-work-window.md](rules/PAY-021-l12-standard-work-window.md);
  [../dispatch/crane-configuration-rules.md](../dispatch/crane-configuration-rules.md) §10;
  [../dispatch/gaps.md → *Is the DAS holdover the same thing as payroll's subsistence holdover?*](../dispatch/gaps.md#is-the-das-holdover-the-same-thing-as-payrolls-subsistence-holdover)
  (which days and employees are on holdover).
- **Blocked:** pricing a holdover day 2+; the crew-time flag on holdover days.
- **Owner:** Kyle Harlow and Joe Schacatano (who set the yard-to-yard rule), with Corrina Bustos.
  Melissa McNutt's updated answers may settle 1, 2 and 5.

## Who may complete or correct a ticket on a worker's behalf, and who approves a late or post-submit edit — "manager" or payroll

- **Status:** resolved — see [../decisions/2026-10-15-late-and-incomplete-tickets.md](../decisions/2026-10-15-late-and-incomplete-tickets.md) (L5, L7: only the worker and payroll-admin:edit holders; no dispatcher or supervisor). **Update 2026-10-21:** the *approver* answer still holds — a `payroll-admin:edit` holder approves — but L5's **seeded default holder** is deferred and E2 kept during the TICKET-FLOW-SLOTS-HOLDOVER Part 3 rebase: no role gets the permission by default; it is granted by hand in Departments until a TCG-237 role is chosen to hold it. See [../decisions/2026-10-21-defer-l5-payroll-admin-edit-default-holder.md](../decisions/2026-10-21-defer-l5-payroll-admin-edit-default-holder.md).
- **Asked:** 2026-10-07 — recording Melissa McNutt's provisional incomplete-ticket answers
  ([../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md),
  `reference`, T2, T3, T13). TCG asked on 2026-10-06 to hold those answers until an updated version
  is sent.
- **What she wrote:**
  - Asked *"should supervisors/dispatchers also be able to complete or correct tickets on their
    behalf?"*: *"Yes"*.
  - Managers and admins can override after the deadline: *"Yes!"*.
  - After 24 hours, and after submission, an edit needs *"Manager approval or Payroll approval"*.
    The worker requests it in the app, and it is a *"quick click"* for the approver.
  - Notices of late completion and the overdue report go to *"Managers and Payroll"*.
  - *"Payroll will need the ability to edit at all times."*
- **Conflict and gaps, recorded not resolved:**
  - The verified
    [../decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md](../decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md)
    takes the crane superintendent out of the **flag** flow.
  - The verified
    [../decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md](../decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md)
    leaves open who may complete a never-completed ticket (*Not decided*, item 2).
  - The developer's direction makes that **payroll-only**: the Payroll Admin or Payroll Manager.
    That is C8 and K4 in `2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`
    (`reference`), which is on overlay branch `feat/PAYROLL-FLAGS-foundation` and not on main.
  - Her *"Yes"* answered an either/or question and does not pick a side. Read literally, it admits
    supervisors and dispatchers.
- **Questions**, each phrased so a one-line reply settles it:
  1. Who may **complete** a worker's incomplete ticket on their behalf: dispatch, the crane
     superintendent or supervisor, payroll only, or all of them?
  2. Who may **correct** a submitted ticket on a worker's behalf: the same people, or payroll only?
  3. Who is the **"manager"** who approves a late or post-submit edit: the worker's line manager or
     crane superintendent, an operations manager, or the Payroll Manager?
  4. Is the worker's in-app **edit request** the same flow as Send Back to the worker (verified
     2026-09-30 flag list, 3-hour reminder), or a separate one?
  5. A ticket waiting on that approval, and then its 4 hours, holds the whole payroll week (verified
     2026-09-30: every ticket complete before processing). Is that intended, or may payroll complete
     it to release the week?
- **Sources checked:** the notes above;
  [../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)
  (verified: *"Payroll may fix any time, for one person"*, which agrees with her last line);
  [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md)
  (unverified: field employees report to Crane Superintendent Jeff Kelley, then Kyle Harlow).
- **Related:**
  [*Flagged entries go to payroll, not the crane superintendent*](#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives)
  (C6);
  [*A labor-entry edit can reprice an approved week*](#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it);
  [../field-ops/gaps.md → *Late and incomplete tickets*](../field-ops/gaps.md#late-and-incomplete-tickets--where-the-24-hour-window-starts-what-it-allows-and-how-reminders-are-anchored).
- **Blocked:** edit and complete permissions for anyone other than the worker and payroll; the
  approval-request flow; notification recipients for late completion.
- **Owner:** Corrina Bustos (payroll) and Melissa McNutt, with Lisette Anzaldo for dispatch.

## Payroll week overlay — which craft does a pending crew row show?

- **Status:** open
- **Asked:** 2026-10-16 — review of DAS craft-pill work by Jahanzaib Nadeem (tcg branch
  `fix/14-oct-uat`, no ticket). Found while checking siblings; nothing was changed here.
- **Question:** the week overlay (pending / sent / in-progress / rejected tickets) shows a
  craft code on each row. Which craft should a crew member's row show? Today it shows
  `ticket.allocation.craftCode` — **the ticket's one allocation**, so every member of a shared
  crew ticket (SCRUM-CREW-TICKET) shows the same craft, the one stored for the slot the ticket
  was sent from. And when the allocation stores no craft (every non-Operator/Oiler slot), the
  row shows **none**, while DAS now shows the employee's PRIMARY for the same allocation.
- **What the code does:** `apps/api/src/service/payroll/payroll.repository.ts`
  `WEEK_OVERLAY_INCLUDE` selects `allocation.craftCode.code`; `expandRosterOverlay` copies the
  ticket (allocation included) onto one row per roster member;
  `apps/api/src/usecase/payroll/payroll-week-overlay.ts:162` reads
  `ticket.allocation?.craftCode?.code ?? null`. The crew card and labor step use
  `pickPayrollCraft` instead (`ticket-labor-entries.repository.ts`): the allocation's craft
  only when it is one of **this member's** SECONDARY assignments, else this member's PRIMARY.
- **Sources checked:** [../decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md)
  (`verified`: the day's craft is the employee's, a different one only by a deliberate
  secondary assignment). Nothing written says what the overlay should display; its decisions
  (`2026-09-10-*`) cover which tickets appear, not the craft column.
- **Proposal, not decided:** show `pickPayrollCraft(member.craftAssignments,
  allocation.craftCodeId)` per member — what the crew sees and what pricing resolves for boom.
  It changes what a crew teammate's row shows today, so it is its own PR.
- **Owner:** Corrina Bustos (payroll).

## When an employee's PRIMARY craft changes, do already-dispatched days follow it?

- **Status:** open
- **Asked:** 2026-10-16 — same review. Pre-existing behaviour, not introduced by it.
- **Question:** an allocation either stores a craft (`job_resource_allocations.craft_code_id`)
  or stores none. Operator/Oiler allocations **always** store one — the API writes the PRIMARY
  explicitly when it matches the seat (`resolveCraftForSlot`,
  `apps/api/src/usecase/das-allocations/das-allocations.service.ts`). Other slots store none.
  If HR later changes the employee's PRIMARY (say G9 → G8), the days with **no stored craft**
  price under the new G8, and the Operator/Oiler days that stored G9 **keep G9** — including
  G9's union for the boom adder. Is that intended (the dispatched craft is a snapshot) or should
  a stored craft that was only ever "the PRIMARY at the time" follow the change?
- **Two rules already exist for "the day's craft":**
  - base rate — `apps/api/src/usecase/payroll-pricing/pay-week-assembly.ts:506-507`:
    `allocation craft ?? PRIMARY`. It trusts **any** stored craft, even one that is no longer
    among the employee's assignments.
  - boom union / crew card — `pickPayrollCraft` and `secondaryCraftCodeIdForRateResolve`
    (`payroll-secondary-craft.ts`): the stored craft **only if it is a SECONDARY assignment**,
    else the PRIMARY.

  So after a PRIMARY change, one day can price its base rate under the old craft and its boom
  under the new one.
- **Sources checked:** [../decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md)
  (`verified`) and [../decisions/2026-09-28-boom-union-follows-the-worked-craft.md](../decisions/2026-09-28-boom-union-follows-the-worked-craft.md)
  clauses 1–3 (`reference`): both assume one craft per day; neither covers a PRIMARY changing
  after dispatch.
- **Owner:** Corrina Bustos / Brian Petros.
