---
title: Payroll — open questions
status: reference
kind: gaps
updated: 2026-09-08
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
- **Status:** open
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
- **Status:** open
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
- **Status:** open
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

- **Status:** open
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

## Field role vs portal role — one list in FCC, three representations in TCG

- **Status:** open
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

- **Status:** open
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

