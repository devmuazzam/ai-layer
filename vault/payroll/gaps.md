---
title: Payroll — open questions
status: reference
kind: gaps
updated: 2026-08-24
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
- Status: open
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
- Status: open
- **From (frozen original):** [gaps-2026-08-20-retired.md#the-24-decisions-required-before-the-payroll-rule-catalog-is-final](gaps-2026-08-20-retired.md#the-24-decisions-required-before-the-payroll-rule-catalog-is-final)

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
- Status: open
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
- **Rules:** [PAY-046](rules/PAY-046-meal-opportunity.md), [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#field-ops-lunch-capture-vs-payroll-wtl](gaps-2026-08-20-retired.md#field-ops-lunch-capture-vs-payroll-wtl)

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
- Status: open
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#cao-ca-ot-exists-but-the-crosswalk-reuses-generic-overtime](gaps-2026-08-20-retired.md#cao-ca-ot-exists-but-the-crosswalk-reuses-generic-overtime)

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
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#ventura-a-second-adp-company-nobody-has-mentioned](gaps-2026-08-20-retired.md#ventura-a-second-adp-company-nobody-has-mentioned)

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
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#adp-returns-two-incompatible-error-envelopes-and-one-has-no-machine-readable-code](gaps-2026-08-20-retired.md#adp-returns-two-incompatible-error-envelopes-and-one-has-no-machine-readable-code)

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
- **Rules:** [PAY-048](rules/PAY-048-standard-subsistence.md), [PAY-049](rules/PAY-049-weekend-subsistence.md), [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#home-yard-cannot-come-from-adp-subsistence-has-no-upstream-source](gaps-2026-08-20-retired.md#home-yard-cannot-come-from-adp-subsistence-has-no-upstream-source)

## Union codes — one value, so the CRUD question mostly dissolves

- Question: does the ERP need the ability to add union codes, as asked in
  [meetings/2026-06-26-discussion-points-with-tcg-team.md](meetings/2026-06-26-discussion-points-with-tcg-team.md)?
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
- **Rules:** [PAY-003](rules/PAY-003-employee-master-import.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#union-codes-one-value-so-the-crud-question-mostly-dissolves](gaps-2026-08-20-retired.md#union-codes-one-value-so-the-crud-question-mostly-dissolves)

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
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#adps-error-envelope-is-now-known-but-the-success-envelope-is-not](gaps-2026-08-20-retired.md#adps-error-envelope-is-now-known-but-the-success-envelope-is-not)

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
- Status: open
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
- Status: open
- **From (frozen original):** [gaps-2026-08-20-retired.md#eligibility-classes-is-403-an-entitlement-question-not-a-data-question](gaps-2026-08-20-retired.md#eligibility-classes-is-403-an-entitlement-question-not-a-data-question)

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
- **Rules:** [PAY-004](rules/PAY-004-labor-entry-import.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#labor-allocation-department-today-cost-number-if-tcg-wants-job-attribution](gaps-2026-08-20-retired.md#labor-allocation-department-today-cost-number-if-tcg-wants-job-attribution)

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
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#adp-code-strings-collide-between-the-earning-and-deduction-arrays](gaps-2026-08-20-retired.md#adp-code-strings-collide-between-the-earning-and-deduction-arrays)

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
- **From (frozen original):** [gaps-2026-08-20-retired.md#payroll-calculation-logic-brian-owes-a-revised-version](gaps-2026-08-20-retired.md#payroll-calculation-logic-brian-owes-a-revised-version)

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
- **Rules:** [PAY-070](rules/PAY-070-foreman-premium.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#foreman-premium-granularity-multiplier-and-capture](gaps-2026-08-20-retired.md#foreman-premium-granularity-multiplier-and-capture)

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
- **Rules:** [PAY-071](rules/PAY-071-military-base-premium.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#military-base-premium-job-level-scope-davis-bacon-list-and-the-phone-call](gaps-2026-08-20-retired.md#military-base-premium-job-level-scope-davis-bacon-list-and-the-phone-call)

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
- **Rules:** [PAY-027](rules/PAY-027-no-pyramiding.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#premium-stacking-and-no-pyramiding](gaps-2026-08-20-retired.md#premium-stacking-and-no-pyramiding)

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
- Status: open — product and entitlement resolved; **test company requested from TCG 2026-08-17**
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#adp-product-api-central-entitlement-and-sandbox](gaps-2026-08-20-retired.md#adp-product-api-central-entitlement-and-sandbox)

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
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#erpadp-round-trip-what-happens-when-a-practitioner-edits-the-batch](gaps-2026-08-20-retired.md#erpadp-round-trip-what-happens-when-a-practitioner-edits-the-batch)

## Excel or API — the ADP submission path is not decided

- Question: does TCG submit payroll to ADP by **spreadsheet import** (today's process) or by the
  **Pay Data Input API**?
- Candidates: [payroll/adp-sop-v3.8.md](payroll/adp-sop-v3.8.md) documents the Excel/Power
  Query/VBA process the ERP is meant to replace.
  [payroll/adp-integration-capabilities.md](payroll/adp-integration-capabilities.md) documents the
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
- Status: open
- Observed 2026-08-18 (ADP Workforce Now screenshots, company 4RZ, weekly #31, 07/18–07/24):
  the batches ROLL (Field Roll, 85 people) and SALARY (29) are marked **Manual Entry**; PTO001
  is Paid Time Off. ROLL columns: Reg / OT / DT / Holiday 2x / Holiday 3x hours, Shift Diff 2/3
  code+amount, **Temporary Rate + LB REG/OT/DBL/TRI** (one row per boom adder), SUB PAY, Sick,
  PTO. The legacy app produces no file — the sheet is keyed/imported outside it. Layout recorded in
  [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md).
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#excel-or-api-the-adp-submission-path-is-not-decided](gaps-2026-08-20-retired.md#excel-or-api-the-adp-submission-path-is-not-decided)

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
- **Rules:** [PAY-003](rules/PAY-003-employee-master-import.md), [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#employee-master-who-creates-a-worker-erp-or-adp](gaps-2026-08-20-retired.md#employee-master-who-creates-a-worker-erp-or-adp)

## Earning-code setup in ADP — a manual prerequisite nobody owns

- Question: who creates TCG's earning codes inside ADP Workforce Now, and when?
- Candidates: [payroll/adp-integration-capabilities.md](payroll/adp-integration-capabilities.md).
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
- Status: open
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#earning-code-setup-in-adp-a-manual-prerequisite-nobody-owns](gaps-2026-08-20-retired.md#earning-code-setup-in-adp-a-manual-prerequisite-nobody-owns)

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
- **Rules:** [PAY-072](rules/PAY-072-certified-payroll-davis-bacon-reporting.md), [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#certified-payroll-generation-is-there-already-an-adp-marketplace-connector](gaps-2026-08-20-retired.md#certified-payroll-generation-is-there-already-an-adp-marketplace-connector)

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
- **Rules:** [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#where-do-webhook-events-live-in-api-central-and-what-fires](gaps-2026-08-20-retired.md#where-do-webhook-events-live-in-api-central-and-what-fires)

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
- Status: open — polling is the current default and the lower-risk one
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
- Status: open — issuance done, **custody and rotation undecided**.
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
- Status: open
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
- Status: **partly disposed** — 2 superseded by `decisions/2026-06-30-adp-erp-employee-data-ownership.md`, 1 resolved by live ADP observation, 8 still open or awaiting confirmation, each with its own entry below.
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
- Status: open
- **Rules:** [PAY-048](rules/PAY-048-standard-subsistence.md), [PAY-049](rules/PAY-049-weekend-subsistence.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#subsistence-the-recording-and-the-engine-disagree-on-both-the-amount-and-the-trigger](gaps-2026-08-20-retired.md#subsistence-the-recording-and-the-engine-disagree-on-both-the-amount-and-the-trigger)

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
- Status: open — needs confirmation
- **Rules:** [PAY-046](rules/PAY-046-meal-opportunity.md), [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#lunch-thresholds-the-recording-is-the-origin-and-it-disagrees-with-the-wtl-charts](gaps-2026-08-20-retired.md#lunch-thresholds-the-recording-is-the-origin-and-it-disagrees-with-the-wtl-charts)

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
- Status: open — needs confirmation
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
- Status: open
- **Rules:** [PAY-046](rules/PAY-046-meal-opportunity.md), [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#lunch-alert-lead-time-one-hour-or-thirty-minutes](gaps-2026-08-20-retired.md#lunch-alert-lead-time-one-hour-or-thirty-minutes)

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
- Status: **answered** — client statement ~2026-07-28 (message batch, captured 2026-08-24)
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
- Status: open
- **Rules:** [PAY-003](rules/PAY-003-employee-master-import.md), [PAY-067](rules/PAY-067-adp-export.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#fill-in-field-employees-vs-the-adp-onboarding-dispatch-block](gaps-2026-08-20-retired.md#fill-in-field-employees-vs-the-adp-onboarding-dispatch-block)

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
- Status: open — needs confirmation
- **Rules:** [PAY-044](rules/PAY-044-lattice-boom-premium.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#lattice-joe-settled-it-on-the-recording-nothing-records-it](gaps-2026-08-20-retired.md#lattice-joe-settled-it-on-the-recording-nothing-records-it)

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
- Status: open — needs confirmation
- **Rules:** [PAY-010](rules/PAY-010-l12-union-base-rate.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#pay-rate-follows-the-employee-not-the-role-worked-kyle-and-corrina-unrecorded](gaps-2026-08-20-retired.md#pay-rate-follows-the-employee-not-the-role-worked-kyle-and-corrina-unrecorded)

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
- Status: open
- **Rules:** [PAY-002](rules/PAY-002-pay-period-status-workflow.md)
- **From (frozen original):** [gaps-2026-08-20-retired.md#weekly-payroll-week-statuses-two-codingcops-sources-no-tcg-statement](gaps-2026-08-20-retired.md#weekly-payroll-week-statuses-two-codingcops-sources-no-tcg-statement)

## Labor Compliance module — no vault coverage

- Question: what is the Labor Compliance module, end to end?
- Candidates: [meetings/2026-08-07-labor-compliance-certified-payroll.md](meetings/2026-08-07-labor-compliance-certified-payroll.md)
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
- Status: open
- **From (frozen original):** [gaps.md#labor-compliance-module-no-vault-coverage](../gaps.md#labor-compliance-module-no-vault-coverage)
- **2026-08-24: no longer zero coverage.** The [Certified Payroll Playbook](certified-payroll-playbook.md)
  documents the intake-to-gate business process (Sales Coordinator → Labor Compliance → NO-GO
  until reviewed), names WH-347/DIR/wage determinations, and ties to the FCC Certified Pay flag.
  Remaining open: ERP scope split (intake workflow vs report generation), the module's owner,
  and what "Ready to Schedule Value Engine" is.

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
- Status: open
- **From (frozen original):** [gaps.md#employee-yard-and-company-cardinality-the-ask-exists-in-exactly-one-place](../gaps.md#employee-yard-and-company-cardinality-the-ask-exists-in-exactly-one-place)
