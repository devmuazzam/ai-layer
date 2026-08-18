# Payroll and ADP gaps

The payroll half of the open-question register. Product and process gaps are in
[`../gaps.md`](../gaps.md); the entry format and the rules — never pick a winner, cite all
candidates, phrase every question so a one-line reply resolves it — are the same. Append
payroll and ADP questions **here**.

**Read by section, never whole.** `grep -n '^## ' .ai/vault/payroll/gaps.md` lists every entry;
read only the ones for the rule, code or integration in front of you.

**From the OneDrive payroll migration (2026-08-13).** Unlike the product entries in `../gaps.md`, these are
**not** conflicts between competing documents — the payroll sources agree with each other. They
are questions the source documents themselves mark as unanswered, and in most cases name the
person or function who has to answer them.

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
- Status: open
- Legacy behaviour (2026-08-18, code-verified — not a policy answer): the engine applies every L12
  rule to any labor row whose `CraftCode LIKE 'L12%'` (Field and Mechanic identically); Non-Union
  Admin Hourly rows are repriced by `app.usp_Apply_CA_NonUnionAdminHourly_OT` (daily 8/12, weekly
  40, 7th day) with every union field zeroed; `ADMIN-*` crafts are the only ones exempt from
  minimum pay. Salary rows are never priced. Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).

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
- Status: open

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
  [payroll/adp-api-responses/pay-data-input-meta.md](payroll/adp-api-responses/pay-data-input-meta.md).
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
- Status: **partially resolved** — 2 of 9 decisions closed by live API evidence; 5 still blocking.

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
- Status: open

## Field-ops lunch capture vs payroll WTL

- Question: the mobile app captures lunch events and the payroll module prices them, but the two
  document sets were written independently and disagree. Which side is right on each point, and
  who owns the reconciliation?
- Candidates: not a choice between documents — a seam between two modules, both specified,
  neither citing the other.
  - Capture side: `product/brs.md` (BRS-LUNCH-001…005, BRS-PAY-003), plus `FR-FOP-013`
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
  **Code check 2026-08-13** ([payroll/legacy-payroll-app-code-extract.md](payroll/legacy-payroll-app-code-extract.md)):
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
- Status: open

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

## ADP codes — TCG owes an updated export

- **Partially delivered 2026-08-09.** Brian Petros supplied **four** codes by chat —
  `FRR`/`FRO`/`FRD`/`FRT` (Foreman REG/OT/DT/TRI), recorded in
  [payroll/foreman-and-military-premiums.md](payroll/foreman-and-military-premiums.md).
  **The Military Base premium in the same message has no codes at all.** Roughly twelve of the
  promised sixteen are still outstanding, as is the comprehensive rules documentation.
- **ANSWERED 2026-08-13 — CodingCops pulled the table itself.**
  [payroll/adp-api-responses/pay-data-input-meta.md](payroll/adp-api-responses/pay-data-input-meta.md)
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
- Status: **export resolved**; rules documentation open.

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
- Status: open

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
  ([payroll/adp-api-responses/pay-schedule.md](payroll/adp-api-responses/pay-schedule.md)).
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
- Status: **largely resolved** — residual question open

## ADP returns two incompatible error envelopes, and one has no machine-readable code

- Question: how does the ERP parse ADP errors uniformly?
- **It cannot.** Two shapes observed, and they disagree on every field name
  ([payroll/adp-api-responses/pay-schedule.md](payroll/adp-api-responses/pay-schedule.md) §6):
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
- Status: open

## Home yard cannot come from ADP — subsistence has no upstream source

- Question: where does the ERP get **home yard / reporting location**, required by
  [payroll/erp-payroll-module-frd/02-payroll-period-and-source-data.md](payroll/erp-payroll-module-frd/02-payroll-period-and-source-data.md)
  and by **PR-048 Standard Subsistence**?
- Candidates: not ADP. `GET /codelists/hr/v3/worker-management/locations/WFN/1` returns exactly
  **two** values — `DEF — DEFAULT LOCATION` and `VEN — Ventura`
  ([payroll/adp-api-responses/codelist-worker-management.md](payroll/adp-api-responses/codelist-worker-management.md)).
- Note: PR-048 turns on *home yard, job, distance, overnight and equipment status*. A two-value
  list, one of which is literally "DEFAULT", expresses none of that. Home yard must be mastered in
  the ERP, sourced from FCC.
- Blocked: subsistence rule design; the employee-master migration scope.
- Owner: CodingCops, with TCG payroll to confirm the FCC field.
- Status: open

## ADP job titles are not craft codes — and the gap is priced

- Question: none open — this records a **closed** question so nobody reopens it.
- **ADP cannot represent craft classification.** `job-titles` returns **10** values, of which
  `OPERATOR` is one. The Local 12 agreement prices **six** operator classifications (Groups 3, 4,
  6, 7, 8, 9) spanning **$67.87 to $71.16** — a $3.29/hour range collapsed into a single ADP
  value. `OILDRV` similarly collapses Groups 1 and 2. Nothing in ADP expresses apprentice steps,
  craft modifiers or boom tiers.
- Note: `job-titles` also near-duplicates `departments` — nine of ten map one-to-one
  (`OPERATOR`/`OPRDEP`, `MECHANIC`/`MECDEP`, and so on). **The ERP should treat them as one
  concept with two ADP encodings**, not as independent attributes, or they will drift.
- Consequence: craft stays in `FMS_UNION_CRAFT` and must migrate to the ERP. Reinforces that
  certified payroll is an ERP report.
- Owner: n/a — resolved by observation.
- Status: **closed 2026-08-13**.

## Union codes — one value, so the CRUD question mostly dissolves

- Question: does the ERP need the ability to add union codes, as asked in
  [product/discussion-points-with-tcg-team.md](product/discussion-points-with-tcg-team.md)?
- Candidates: ADP holds exactly **one** union code — `L12 — Local 12`.
- Note: with one value that changes only if TCG signs a second labour agreement, a CRUD screen is
  hard to justify. The narrower live question is whether the ERP masters `L12` or reads it from
  ADP.
- Note also: **union code cannot derive the Payroll Group.** `L12 Labor Union Field` and
  `L12 Labor Union Mechanic` both carry `L12`; the split is `Employee.EmpTypeID = 3`. The existing
  derivation rule is confirmed, not replaceable.
- Blocked: nothing. Scope reduction only.
- Owner: CodingCops / TCG product.
- Status: open, but narrowed

## ADP's error envelope is now known — but the success envelope is not

- Question: does a **successful** `pay-data-input.modify` return a `confirmMessage` with a
  `confirmMessageID` GUID, the way a failure does?
- Candidates: unknown — no successful pay-data write has been made, and none should be made
  casually against production payroll.
- Note: a `403` from `eligibility-classes` returned the full ADP envelope for the first time —
  `confirmMessage` with `protocolStatusCode`, `requestStatusCode`, a per-request
  `confirmMessageID` GUID, and `resourceMessages[].processMessages[].processMessageID` as the
  machine-readable error code
  ([payroll/adp-api-responses/codelist-worker-management.md](payroll/adp-api-responses/codelist-worker-management.md)).
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
- Status: open

## ADP holds per-worker premium rate multipliers — does TCG use them?

- Question: is `workAssignments/premiumRateMultipliers/premiumRateMultiplierItem/rateMultiplier`
  populated for any TCG worker?
- **ANSWERED 2026-08-13: no.** Absent from every record in
  [payroll/adp-api-responses/workers-list.md](payroll/adp-api-responses/workers-list.md). ADP is
  not holding per-worker multipliers, so the ERP can own OT/DT/TRI multiplication without
  contention and without silent double-multiplication.
- Note: worth re-checking if anyone configures it later. The field exists; it is simply unused.
- Owner: n/a.
- Status: **closed**

## Non-union pay rates have no upstream source — ADP will not return them

- Question: where does the ERP get the **non-union hourly rate** that **PR-009** sources from
  *"Employee master PayRate"*?
- **Not from ADP.** `baseRemuneration` returns `nameCode`, `currencyCode` and `effectiveDate`, but
  **`amountValue` is absent on every rate for every worker** — hourly, annual, pay-period salary
  and every `additionalRemunerations` entry
  ([payroll/adp-api-responses/workers-list.md](payroll/adp-api-responses/workers-list.md)).
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
- Status: open
- Legacy behaviour (2026-08-18): the payroll app takes the non-union rate from
  `FMS_EMPLOYEES.PayRate` (NexGen employee master) — `api.v_UI_Employee_TypeRate`,
  `BaseHourlyRateSource = 'Employee.PayRate'`; union rates from `FMS_UNION_CRAFT.PayRate` by the
  labor row's craft. So the upstream today is NexGen, not ADP. Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).

## Union membership is recorded twice in ADP, and the two disagree

- Question: none open on the design — this records **why the ERP must not sync union membership
  inbound**.
- ADP holds "Local 12" in two independent places: `workAssignments/workerTypeCode` and
  `workAssignments/laborUnion/laborUnionCode`. Across real records **all four combinations occur**,
  including field workers in the `PPEDEP` department with `OILDRV`/`OPERATOR` job codes and the
  Mobile Crane workers-comp class who carry **no union marker at all**
  ([payroll/adp-api-responses/workers-list.md](payroll/adp-api-responses/workers-list.md)).
- Note: `workerTypeCode` doubles as employment type (`F — Full Time`) and union membership (`L12`)
  in a single mutually-exclusive enum, which is presumably how the inconsistency arose.
- Consequence: the existing derivation stands unchanged — Payroll Group comes from `CraftCode`
  prefix plus `EmpTypeID` plus `PayType`, all FCC-side. Syncing union membership from ADP would be
  wrong for a meaningful fraction of the workforce.
- Owner: n/a — resolved by observation. TCG payroll may wish to clean the ADP data separately.
- Status: **closed as a design decision**

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
- Status: open

## ADP File Number — the crosswalk's format rule is wrong

- Question: none open — this records a **correction** so the wrong rule is not implemented.
- [payroll/adp-bucket-crosswalk.md](payroll/adp-bucket-crosswalk.md) implementation rule 8 says
  the ADP File Number *"allows uppercase alphanumeric characters, has a maximum length of 6"*.
  ADP's own validation says otherwise:
  `pattern: ^0*(5[1-9]|[6-9][0-9]|[1-9][0-9]{2,5})$`
- **Digits only** — no letters are accepted. **Minimum value 51** — 1 to 50 are invalid.
  Leading zeros are allowed and do not count toward the 6-character limit, so the crosswalk is
  right that it must be stored as text.
- Consequence: the ERP must validate against this regex *before* submitting. A bad File Number
  returns `payrollFileNumber:NNNN is invalid` without saying which rule failed, and one bad row
  is indistinguishable from a closed payroll cycle at a glance.
- Owner: n/a — resolved by observation 2026-08-13.
- Status: **closed**

## Worker data must be fetched with `$select`, not whole records

- Question: none open — this records a **design constraint** discovered from the schema.
- The worker API exposes SSN (`person/governmentIDs`, `\d{9}`), birth date, home address, race,
  gender, marital status, military status, personal email and phone. The ERP needs exactly two
  fields: `associateOID` and `payrollFileNumber`.
- **`$select` is supported** over ~130 paths, so the ERP can request only the join key. Pulling
  full records would put payroll-grade PII into the ERP with no functional benefit.
- Note: **the `/meta` response itself contains personal data** — the `$filter` code list for
  `reportsTo/positionID` enumerates named supervisors. Anyone sharing meta output should treat it
  as PII, not structure. `positionID` format is company code plus six digits (`4RZ000000`).
- Owner: CodingCops.
- Status: **closed as a decision** — `$select` mandatory on every worker read.

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
- Status: open

## Labor allocation — department today, cost number if TCG wants job attribution

- Question: should TCG switch Workforce Now Labor Distribution from **Department** to **Cost
  Number** so the ERP can attribute hours to jobs in ADP?
- Candidates: today it is Department. Evidence:
  `GET /codelists/hr/v3/worker-management/cost-numbers/WFN/1?companyCode=4RZ` returns **`204 No
  Content`** while `departments` returns 12 org units —
  [payroll/adp-api-responses/codelist-departments.md](payroll/adp-api-responses/codelist-departments.md).
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
- Status: open

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
- Status: open

## Payroll calculation logic — Brian owes a revised version

- Question: has the payroll calculation logic changed since the documents in `payroll/`?
- Candidates: the vault holds the 2026-08-05 rule matrix and the 2026-06-23 rule catalog. Brian
  (TCG) undertook on 2026-08-05 to share **revised** calculation logic, plus comprehensive
  documentation of all payroll rules, plus Corrina's Value Engineering / Payroll Workflow
  documentation. **None has arrived.**
- Note: until it does, the migrated payroll documents stand as written. **Do not assume a rule has
  changed because a revision was promised.** When it arrives it may supersede parts of
  [payroll/codingcops-rule-matrix.md](payroll/codingcops-rule-matrix.md) — treat that as a
  re-migration, not an edit.
- Blocked: nothing yet; it will block rule implementation that the revision touches.
- Owner: Brian Petros (TCG); Corrina (TCG) for the Value Engineering workflow.
- Status: open

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
- Status: open
- Legacy behaviour (2026-08-18): the payroll app has **no lattice concept at all** — no `LATT*`
  comment token, no branch, no code; the only boom concept is the craft-modifier bracket
  (`OP-BP/OI-BP`) adder. Lattice identification is a new build. Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).

## Foreman premium — granularity, multiplier and capture

- Question: does the $3/hr foreman premium attach to an **employee-day** or to a **labor entry**,
  and is it multiplied by OT/DT/TRI or flat?
- Candidates: [payroll/foreman-and-military-premiums.md](payroll/foreman-and-military-premiums.md)
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
- Status: open
- Legacy behaviour (2026-08-18): confirmed again against the full database — no object, column
  or config row for a foreman premium in any of the 141 definitions. Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).

## Military Base premium — job-level scope, Davis-Bacon list, and the phone call

- Question: how does a job get flagged as a military-base job site, and where does the qualifying-
  location list live?
- Candidates: [payroll/foreman-and-military-premiums.md](payroll/foreman-and-military-premiums.md)
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
  [7 Aug minutes](meetings/2026-08-07-labor-compliance-certified-payroll.md)) **a payroll blocker
  as well as a Labor Compliance one.** The same determination drives both Certified Payroll
  eligibility and a $10/hr premium for every worker on the job.
- **Code check 2026-08-13:** no military-premium logic exists in the legacy source either —
  never computed by any system.
- Blocked: implementation of the military premium; job-site data model; Davis-Bacon identification.
- Owner: Corrina (TCG) for Davis-Bacon criteria; Brian Petros for the ADP codes.
- Status: open
- Legacy behaviour (2026-08-18): confirmed against the full database — nothing for military /
  Davis-Bacon / prevailing wage in the calculation; certified payroll exists only as a label flag
  (`UseCertifiedPayroll`). Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).

## Premium stacking and no-pyramiding

- Question: can a foreman on a military-base job draw both premiums — $13/hr over base?
- Candidates: nothing states it either way. Both premiums are described in isolation.
- Note: the L12 agreement's **no-pyramiding** clause
  ([payroll/mcog-l12-mla-2025-2028/01](payroll/mcog-l12-mla-2025-2028/01-article-iii-working-rules.md))
  is exactly the kind of provision that restricts stacked premiums. Note also that Foreman is a
  **company** rule and Military is a **union** rule — whether a company rule is subject to the
  union's pyramiding restriction is a question for labor counsel, not for the codebase.
- Blocked: any implementation where both premiums could apply to the same hour.
- Owner: TCG management / payroll, with labor counsel and the union rep.
- Status: open
- Legacy behaviour (2026-08-18, code-verified): the engine prices each 30-min slice as
  `0.5 × (Rate_Base + Rate_Shift + boom?Rate_Boom) × Final_Multiplier` — the shift and boom
  **adders are multiplied by the OT/DT/Sat/Sun/Holiday multiplier**, and one multiplier controls a
  slice (holiday > Sunday > special-Sat > DT > outside-window OT > OT > Saturday). Rest premium
  pays only the delta up to a ×1.5/×2 floor. That is the current stacking rule; whether it is
  the contract's is the open question. Source: [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md) calculations B2.

## ADP product, API Central entitlement and sandbox

- **Product resolved 2026-08-13: ADP Workforce Now (classic).** Confirmed from a screenshot of a
  live practitioner session at `workforcenow.adp.com/theme/admin.html#/home` — classic WFN nav, not
  WFN Next Generation. The documentation set in
  [payroll/adp-integration-capabilities.md](payroll/adp-integration-capabilities.md) is therefore
  the correct one.
- **RESOLVED 2026-08-13: TCG already has ADP API Central.** Confirmed from the Marketplace
  `My Apps` screen — **ADP® API Central for ADP Workforce Now® [Launchpad]** and **ADP® API
  Central Help Center** are both entitled, with live `Launch App` buttons. No purchase, no
  procurement, no lead time. Credentials are obtainable today.
- Remaining under this heading: only the "Company Code 631" vs "Co Code 4RZ" identifier conflict.
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
- Status: open — product and entitlement resolved; **test company requested from TCG 2026-08-17**

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
  [adp-integration-capabilities.md](payroll/adp-integration-capabilities.md).
- Status: open

## Excel or API — the ADP submission path is not decided

- Question: does TCG submit payroll to ADP by **spreadsheet import** (today's process) or by the
  **Pay Data Input API**?
- Candidates: [payroll/adp-sop-v3.8.md](payroll/adp-sop-v3.8.md) documents the Excel/Power
  Query/VBA process the ERP is meant to replace.
  [payroll/adp-integration-capabilities.md](payroll/adp-integration-capabilities.md) documents the
  API.
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
- Status: open
- Observed 2026-08-18 (ADP Workforce Now screenshots, company 4RZ, weekly #31, 07/18–07/24):
  the batches ROLL (Field Roll, 85 people) and SALARY (29) are marked **Manual Entry**; PTO001
  is Paid Time Off. ROLL columns: Reg / OT / DT / Holiday 2x / Holiday 3x hours, Shift Diff 2/3
  code+amount, **Temporary Rate + LB REG/OT/DBL/TRI** (one row per boom adder), SUB PAY, Sick,
  PTO. The legacy app produces no file — the sheet is keyed/imported outside it. Layout recorded in
  [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).

## Employee master — who creates a worker, ERP or ADP

- Question: if an employee is created in the ERP, should it create the worker in ADP?
- Candidates: [payroll/adp-integration-capabilities.md](payroll/adp-integration-capabilities.md).
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
- Status: open

## Earning-code setup in ADP — a manual prerequisite nobody owns

- Question: who creates TCG's earning codes inside ADP Workforce Now, and when?
- Candidates: [payroll/adp-integration-capabilities.md](payroll/adp-integration-capabilities.md).
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
- Status: open

## Certified payroll generation — is there already an ADP Marketplace connector?

- **ANSWERED 2026-08-13: no, TCG has no certified-payroll connector.** The Marketplace `My Apps`
  screen lists exactly two entitled apps — API Central Launchpad and API Central Help Center.
  No Points North, no allGeo, nothing in that category. **WH-347 generation is genuinely unbuilt**,
  the Labor Compliance module is greenfield, and the TPM architecture's separate SMG Compliance box
  duplicates nothing already licensed.
- Remaining question: does TCG intend to **buy** such a connector, or build it? The Marketplace
  option exists and is the conventional route.
- Candidates: nothing in the vault. The
  [7 Aug minutes](meetings/2026-08-07-labor-compliance-certified-payroll.md) name **SMG Compliance**
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
- Status: open

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
- Status: open — and the cheapest item on this entire list to close.

## `invalid_client` from ADP does not mean the credentials are wrong — RESOLVED 2026-08-17

- Question (as first written 2026-08-13): does changing an API Central project's entitlements
  invalidate the credential? **No. Retracted.**
- **What was observed.** Right after subscribing to the `pay-data-input.modify` event, a Postman
  token request began returning
  `{"error": "invalid_client", "error_description": "The given client credentials were not valid"}`.
  It was recorded here as a credential lapse caused by the project change.
- **What it actually was (2026-08-17).** The failing Postman was on a **different machine
  (Windows)** using a key file named `private.txt`; the working calls (curl, and the earlier
  Postman) were on the Mac using `private.key` — the file that verifiably matches the project
  certificate (public-key hashes compared 2026-08-17). Same client ID, same secret, same
  certificate: only the private key file differed. The credential was never invalid; the event
  subscription had nothing to do with it. Proven by a clean token from the Mac on 2026-08-17 with
  unchanged credentials.
- **The lesson that survives, and it is a sharper one:** ADP answers a *wrong or unusable client
  key* with the **same** `invalid_client` message it uses for a wrong secret — a full HTTP 401 with
  ADP headers (`Adp-Correlationid`, `X-Ca-Err: 3003201`), not a TLS failure. So `invalid_client`
  means "the identity I saw does not match this client ID", and the identity is
  **secret + certificate + private key together**. Check the key file before resetting anything.
- **The earlier reasoning error, so nobody repeats it:** "a clean JSON error proves the mTLS
  handshake succeeded, therefore it is not a certificate problem" — the handshake did succeed, but
  that only proves *a* key/cert pair (or none) was presented, not that it was the *right* one.
- **Consequences for the build (still valid, re-based on the real cause):**
  1. The ERP must hold cert + key + secret as one unit in a secret manager, and log which
     certificate serial it presented — so an `invalid_client` can be diagnosed in one look.
  2. `invalid_client` is a configuration failure, not a transient one: alert a human, do not retry
     blindly, never silently drop a batch. (Unchanged.)
  3. Treating API Central project changes as scheduled deployment events remains sensible
     hygiene, but it is no longer backed by an observed failure.
- Owner: CodingCops.
- Status: **closed** — cause found; the operational rails above are recorded in
  [payroll/adp-integration-capabilities.md](payroll/adp-integration-capabilities.md).

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
  [payroll/adp-event-notifications.md](payroll/adp-event-notifications.md).
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

## Does WFN support `workDate` and the FLSA date fields on pay data?

- Question: does the Workforce Now implementation of `pay-data-input.modify` accept **`workDate`**
  and **`earnedPayPeriodStartDate` / `earnedPayPeriodEndDate`**?
- Candidates: the event's JSON Schema defines them —
  `workDate` = *"the date on which the worker clocked overtime"*,
  `earnedPayPeriodStartDate/EndDate` = *"used for FLSA in CA in the US"*. **But the WFN
  `pay-data-input.modify/meta` response does not expose either**
  ([payroll/adp-api-responses/pay-data-input-meta.md](payroll/adp-api-responses/pay-data-input-meta.md)).
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
- Status: open

## Manual and voided cheques cannot be issued through the API

- Question: none — this records a **hard limit**.
- The `pay-data-input.modify` schema states plainly: *"Manual and voided checks are not supported
  in this context."*
- Consequence: off-cycle corrections, manual cheques and voids are a Workforce Now UI task
  performed by a practitioner. **The ERP cannot issue them, and must not present a UI implying it
  can.** Any correction workflow in the ERP ends at "tell Payroll", not at an API call.
- Owner: n/a — resolved by observation.
- Status: **closed as a constraint**
- Note: the Postman collection ships only the `GET`. **The `DELETE` exists** —
  `/core/v1/event-notification-messages/{adp-msg-msgid}` — and is how a consumer acknowledges a
  message. A poller that never deletes will re-read or stall.
- **Worker events do exist**, which partly answers the employee-sync question from another angle:
  the ERP could learn of new hires by subscription rather than by polling the full roster, avoiding
  the bulk personal-data pull.

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
- Status: open — polling is the current default and the lower-risk one

## Event notifications fire on issue date, not effective date

- Question: none open — this records a **hard constraint** on any ERP event consumer.
- ADP: *"when a change has an effective date, the notification is generated **at the time when the
  change is issued, and not on the effective date**. Your application should be able to look up the
  effective date in the notification response payload."*
- **Payroll is where this bites.** Worker records already show
  `baseRemuneration.effectiveDate: 2026-07-01` — the MLA wage-increase date — which was entered
  weeks earlier. A consumer that applies changes on receipt would apply a July rate in May.
- Second ADP rule from the same screen: *"use event notifications as a **trigger** instead of the
  true source of real-time data… your application should do `GET /hr/v2/workers/{aoid}` to retrieve
  the real-time data."* **Never persist values straight from an event payload** — extract the
  identifier, re-read the resource, then act.
- Consequence: the existing effective-dating requirement in
  [payroll/erp-payroll-module-frd/01-purpose-scope-and-design-principles.md](payroll/erp-payroll-module-frd/01-purpose-scope-and-design-principles.md)
  is now a hard requirement of the **integration**, not only of the payroll rules.
- Owner: n/a — resolved by observation.
- Status: **closed as a design constraint**
- Blocked: finalising `payroll-architecture.html` and the ADP screens in `TCG Platform (4).html`.
- Owner: anyone with the **P (Project user)** role — all three current members qualify.
- Status: open

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
- Status: open — issuance done, **custody and rotation undecided**.
