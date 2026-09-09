---
title: Payroll module - vault index
source: onedrive/OneDrive_1_8-11-2026/; extended 2026-09-04 from shared-folder/Project-Repository-2026-09-04/
migrated: 2026-08-13
updated: 2026-09-09
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, union-agreement, adp]
entities: [payroll-rule, payroll-group, pay-component, adp-export, guaranteed-hours, wtl, subsistence]
---

# Payroll

**Read this before opening anything under `payroll/`.** Migrated 2026-08-13 from a OneDrive
drop dated 2026-08-11 — a different source and a different date from the Confluence migration
that produced the rest of the vault. **Extended 2026-09-04** from the SharePoint "Project
Repository" drop: six new pages (routed below), a correction to
[fcc-employee-types-and-crafts.md](fcc-employee-types-and-crafts.md), and Davis-Bacon plus the
pre-job labor-compliance form folded into
[certified-payroll-playbook.md](certified-payroll-playbook.md). That drop re-shared the whole
2026-08-11 payroll folder — **33 of its 34 files were already migrated**
([source-manifest.md](source-manifest.md)); the exception was
[payroll-rule-dependency-matrix.md](payroll-rule-dependency-matrix.md), whose content postdates
the 2026-08-11 snapshot.

## Five things that change how you read everything here

1. **Two documents number their rules `PR-###`, independently.** The
   [ERP requirements document](erp-payroll-module-frd/INDEX.md) and the
   [CodingCops rule matrix](codingcops-rule-matrix.md) both start at `PR-001` — 55 ids in the
   first, 68 in the second. `PR-010` is *Non-Union Salary Rate* in one and *L12 union base
   rate* in the other; both are rate rules, which is exactly how the confusion goes unnoticed.
   **A bare `PR-010` identifies nothing — always cite the document too.** Same failure
   mode as `FR-FOP-NNN` in the main index.
2. **Almost none of this is settled.** The ERP requirements document is **Draft 0.1** and lists
   **24 decisions** required before the rule catalog is final. The rule matrix marks **68 rules**
   with a per-rule "Confirmation / Open Decision" and leaves every implementation-tracking column
   blank. The ADP crosswalk carries **9 open decisions, 6 of them blocking**. Every one of these
   is in [payroll/gaps.md](gaps.md).
3. **Neither the requirements document nor the rule matrix is legal advice, and both say so.**
   Union contract interpretation and California payroll law need TCG management, the payroll team,
   labor counsel and union representatives. Do not resolve a contract question by reading the
   contract harder.
4. **Three systems, not two.** Alongside the ERP target and the legacy TCG Payroll App there is
   the **incumbent FCC/NexGen system** TCG runs today — a third set of behaviours, documented by
   its vendor in [fcc-nexgen-payroll-processing.md](fcc-nexgen-payroll-processing.md) and
   [fcc-union-code-configuration.md](fcc-union-code-configuration.md) (added 2026-09-04). Where a
   question is *"what happens when X changes after payroll is processed?"*, all three answer
   differently and none of them well. Do not read an FCC behaviour as a requirement.
5. **The legacy Payroll App is a different stack.** SQL Server + C# + Next.js, SQL-first. This
   repo is NestJS + Prisma + PostgreSQL. Read
   [payroll-app-current-state/](payroll-app-current-state/INDEX.md) for *which rules exist and
   which cases are real*, never for *how to build it here*.

## Start here

| If you're asked… | Read |
| --- | --- |
| **what the payroll module must do** | [erp-payroll-module-frd/INDEX.md](erp-payroll-module-frd/INDEX.md) — the requirements catalog, 11 parts |
| **which rule to build, and its status** | [rules/INDEX.md](rules/INDEX.md) — **the canonical register, 73 `PAY-###` rules**, each joining matrix + FRD + legacy + contract + conflicts. The [matrix](codingcops-rule-matrix.md) stays the source spine |
| what the union contract actually says | [mcog-l12-mla-2025-2028/INDEX.md](mcog-l12-mla-2025-2028/INDEX.md) — contract text, payroll articles — **since 2026-09-04 also the full OCR text of the Truck Crane MLA and the SCCA MLA, plus the 2025-08-15 wage notice** |
| how the current system behaves | [payroll-app-current-state/INDEX.md](payroll-app-current-state/INDEX.md) — legacy app, 9 files |
| **how the legacy app actually calculates pay** | [legacy-payroll-app-db-extract/INDEX.md](legacy-payroll-app-db-extract/INDEX.md) — **the full database extract, 2026-08-18**: all 141 SQL definitions, every config row, the slice formula, every rule with its code, worked examples, the observed ADP worksheet layout. **Where any older payroll-app document disagrees, this wins** |
| **what is the difference between payable and billable hours** | [payable-vs-billable-hours.md](payable-vs-billable-hours.md) — same yard-to-yard span and rounding; payroll adds rule hours, billing applies minimums and downtime deductions; boom time is boom pay, not billing; what is still open (added 2026-09-07) |
| **what changed in the legacy app between 2026-08-18 and 2026-09-07** — the rest-slice DT bucket layer, the non-union bucket-source fix, salary excluded before pricing, strict labor times, the whole-week recalculation guard | [legacy-payroll-app-db-backup-2026-09-07/INDEX.md](legacy-payroll-app-db-backup-2026-09-07/INDEX.md) — Brian's 2026-09-07 backup restored and diffed: **rule procedures unchanged**, 16 new + 16 changed objects with their definitions and diffs |
| **what the legacy app's database looked like on 2026-06-23** (pay periods, run logs, the *Refresh from NexGen* history) | [legacy-payroll-app-db-backup-2026-06-23.md](legacy-payroll-app-db-backup-2026-06-23.md) — the SharePoint `.bak`, restored 2026-09-04; its code is identical to the 2026-08-18 extract |
| **the FCC tables the legacy app reads — real DDL, the nightly ETL, the reference rows** | [tcg-rawfms-staging-database/INDEX.md](tcg-rawfms-staging-database/INDEX.md) — `TCG_RawFMS`, 44 tables / 98 objects, restored from the same backup; ticket-status matrix, checklist questions, craft-modifier master live under its `data/` |
| what the legacy API/UI implements | [legacy-payroll-app-code-extract.md](legacy-payroll-app-code-extract.md) — the C#/Next.js layer (`projects.rar`, Jul 2026): rule shapes, the ADP File # validation bug, no ADP export. Its "SQL not in repo" caveat is now closed by the db-extract |
| what the legacy app's source tree, stack and **role model** look like | [legacy-payroll-app-source-tree-2026-06-10.md](legacy-payroll-app-source-tree-2026-06-10.md) — the 2026-06-10 `.7z` backup, opened 2026-09-04: .NET 9 + Next.js, all 15 API endpoints (3 absent from the knowledge-pack contract guide), and the three-role / four-permission model, written down nowhere else |
| how payroll reaches ADP | [adp-bucket-crosswalk.md](adp-bucket-crosswalk.md), then [adp-hour-earning-codes.md](adp-hour-earning-codes.md) |
| **what we can read / write in ADP, and the weekly JSON** | [adp-read-write-boundary-2026-08-18.md](adp-read-write-boundary-2026-08-18.md) — payroll output is Marketplace-partner-only; static vs dynamic codes; which validation tables/worker fields are writable (no API for earning codes; no craft field); the `pay-data-input.modify` body; `applicant.onboard` V2 fields; connection prerequisites |
| **the dev-facing calculation reference** | artifact *Crane Payroll Calculation Reference* (https://claude.ai/code/artifact/37f949e0-2c7a-4921-80c2-772c556f8e62) — groups/modifiers/WTL/premiums/rules/certified, **reconciled 2026-08-24 to the register** (PAY-### ids cited); update it whenever a rule settles |
| the rendered legacy-app findings | artifacts *TCG Payroll Engine* (https://claude.ai/code/artifact/74b7f0dc-34b4-4415-9839-0281ea3d7878) and *TCG Pay Rules, One at a Time* (https://claude.ai/code/artifact/1a754dab-82d4-4736-b23c-d51593c34c6c) — both derived from [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md) |
| **what ADP's API actually permits** | [adp-integration-capabilities.md](adp-integration-capabilities.md) — researched 2026-08-13. **Read before designing any ERP↔ADP sync** |
| **how ADP events work** | [adp-event-notifications.md](adp-event-notifications.md) — 147 subscribable events, polling vs webhook is exclusive, and notifications fire on **issue** date not effective date |
| **which ADP codes actually exist** | [adp-api-responses/](adp-api-responses/INDEX.md) — **live responses from production ADP**, captured 2026-08-13. The real code table, the real company codes. Where this and a design document disagree, this wins |
| **the non-union hourly rules, in the client's words, with acceptance tests** | [non-union-hourly-rules-2026-09-07.md](non-union-hourly-rules-2026-09-07.md) — Brian Petros 2026-09-07: daily/weekly/seventh-day, calculation order, component taxonomy, the unfinalized §14 list, nine validation scenarios with ERP status |
| the Foreman and Military Base premiums | [foreman-and-military-premiums.md](foreman-and-military-premiums.md) — **in no other document**; supplied by Brian Petros 2026-08-09 |
| how payroll is produced *today* | [adp-sop-v5.1.md](adp-sop-v5.1.md) — **SOP v5.1, effective 2026-09-06, in production since ~week 34**: the workbook now loads the legacy Payroll App's calculated *recommendations* under each employee sheet, carries Foreman and Military columns, and still sends the hand-keyed rows to ADP. Sheet layouts and lineage stay on [adp-sop-v3.8.md](adp-sop-v3.8.md) |
| what the **v5.1** workbook's Power Query and VBA do, and what changed since v3.8 | [adp-workbook-v5.1-engine.md](adp-workbook-v5.1-engine.md) — the 21 queries and 5 modules supplied as plain text 2026-09-08, diffed against the v3.8 pages below |
| what the ADP workbook's macros actually do | [adp-workbook-vba-macros.md](adp-workbook-vba-macros.md) — the four VBA modules: per-employee sheet builder (`tbl___<ADPFileNo>`, File # = 1–6 alphanumerics), synchronous Power Query refresh, and the ADP paydata CSV exporter (`Co Code · Batch ID · File # · Reg Hours · O/T Hours · Temp Rate · Hours 3/4 Code+Amount` pairs, zeros blanked). Read 2026-09-04 |
| what the ADP workbook's **Power Query** actually computes | [adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) — the FCC roster SQL, the Saturday–Friday week and Batch ID, the component ledger (ST/OT/DT/H2x/H3x/SUB/SIC + boom + lattice/shift temp rates), the ADP slot map, the 15 export checks, and the config tables. Read 2026-09-04 |
| what Shift vs Job vs Labor Entry means | [payroll-concepts-shift-job-labor-entry.md](payroll-concepts-shift-job-labor-entry.md) — **read before any time-based rule** |
| how worked-through-lunch actually lands | [wtl-charts.md](wtl-charts.md) — the payroll team's own lookup charts |
| a test case for a specific rule | [rule-examples-catalog.md](rule-examples-catalog.md) — 28 real labor entries, one per rule variation |
| a payroll term nobody has defined | [payroll-app-current-state/09-glossary.md](payroll-app-current-state/09-glossary.md) |
| whether a source file was migrated | [source-manifest.md](source-manifest.md) — all 33 files, including the 3 that could not be read, plus the 2026-09-08 v5.1 set |
| **a specific filename from the drop** | [sources/](sources/INDEX.md) — **one page per file, named after the file**, so any filename resolves |
| what a column in the weekly ADP workbook means | [adp-workbook-column-rules.md](adp-workbook-column-rules.md) — the rules the workbook implements, no employee data |
| **who says a rule, and where sources disagree** | [source-attribution-and-conflicts.md](source-attribution-and-conflicts.md) — every rule tagged by source family, plus a 21-item conflict register |
| **a NEW payroll question (no ticket)** | [gaps.md](gaps.md) — the **live register**, 63 open entries incl. the recordings-vs-vault pairs, each cross-linked to its `PAY-###` rule |
| closed/resolved historical questions | [gaps-2026-08-20-retired.md](gaps-2026-08-20-retired.md) — frozen snapshot |
| **what is still unanswered** about payroll or ADP | [gaps.md](gaps.md) — the payroll half of the open-question register, 41 entries. `grep -n '^## '` first; read only your section |
| what a payroll SME said verbally, not yet in the rule matrix | [2026-08-20-payroll-rules-meeting-notes.md](2026-08-20-payroll-rules-meeting-notes.md) — WTL, rest period, subsistence, craft-code rate overrides. `status: unverified`, cleaned from a call transcript |
| **what FCC holds for an employee** | [fcc-employee-types-and-crafts.md](fcc-employee-types-and-crafts.md) — the 16-type list mixing field and portal roles, the **multi-type join we extract then discard on seed**, and the craft-code update sheets |
| **whether a payroll rule may read labor outside the week** | [payroll-rule-dependency-matrix.md](payroll-rule-dependency-matrix.md) — **the client's per-rule dependency-scope architecture, 2026-09-04**: calculation period vs calculation context vs recalculation impact, the immutable-closed-payroll + retro-delta proposal, and an 18-step engine order. **Carries 16 stated collisions with the register and the as-built code — none adjudicated** |
| how the **incumbent** FCC system processes payroll | [fcc-nexgen-payroll-processing.md](fcc-nexgen-payroll-processing.md) — vendor Payroll Guide v1.0 (2017): the Atom→pre-processor→process→export pipeline and its three lifecycle locks. *"Once exported, a labor entry cannot be modified in any way"* |
| **where FCC keeps a union's pay rules** | [fcc-union-code-configuration.md](fcc-union-code-configuration.md) — vendor Union Codes guide: the five tabs (shift premiums, benefits, craft rates, craft modifiers, payroll defaults). **Union defaults beat employee defaults beat company defaults** |
| **the real FCC code lists** — crafts, classifications, certificates | [fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) — live tables at 2026-07-02, the import schema and enumerations, the migration SQL. Corrects the employee-type count to **15**, and `3rd Man` **is** one of them |
| how payroll actually runs, step by step, today | [payroll-value-engines.md](payroll-value-engines.md) — three 2025 flowcharts: Samsara GPS verification, the payroll-manager audit, the ADP **retro-check** path, and the certified-payroll weekly loop |
| what has to exist on an employee before they can be paid | [hr-onboarding-and-employee-forms.md](hr-onboarding-and-employee-forms.md) — the union/non-union onboarding value engines, the 19-item checklist and its eleven destinations, and the DOT/FMCSA forms |

## The spine of the domain

Four facts that recur in every document and are worth holding in memory:

- **The pay period is Saturday–Friday.** Legal and operational. Every accumulation is within it.
- **There are five Payroll Groups**, and rule eligibility hangs off them:
  `L12 Labor Union Field`, `L12 Labor Union Mechanic`, `Non-Union Admin Hourly`,
  `Non-Union Admin Salary`, `System-Testing-VendorAccess` (excluded from payroll UI entirely).
- **A labor entry's anchor date is its *start* time**, even when it crosses midnight. Get this
  wrong and the entry lands in the wrong period, the wrong day type, and the wrong daily
  accumulation.
- **Every calculated dollar must be a separate, explainable pay component.** Not a total —
  a ledger row naming the rule that produced it. This is the one design principle both the
  legacy system and the ERP requirements agree on unconditionally.

## Where this came from, and how it relates to Confluence

**Confluence contains no payroll documentation.** Searched 2026-08-13: six pages mention
"payroll", all six are field-ops or project pages already in the vault, none specifies a payroll
rule. This folder is the only payroll knowledge the team has written down anywhere.

But Confluence *does* point at it. The field-ops FRD section 10, *BRS References*
([field-ops/field-ops-frd/10-brs-references.md](../field-ops/field-ops-frd/10-brs-references.md)),
defers four topics to documents held on SharePoint — and all four are files in this drop:

| BRS topic | SharePoint file | Here |
| --- | --- | --- |
| Lunch threshold values | `Worked Through Lunch Charts- Payroll_Billing.pdf` | [wtl-charts.md](wtl-charts.md) |
| Payroll processing rules & labor calculation logic | `PayrollAPP_LABOR-LOGIC-EXAMPLES.xlsx` | [rule-examples-catalog.md](rule-examples-catalog.md) |
| ADP mappings | `wfn_importing_paydata.pdf` | in the drop, not migrated — see [source-manifest.md](source-manifest.md) |
| L12 Labor Union Master Agreement | `OE-Local-12-MLA-25-28-Comp.pdf` | in the drop but an unreadable scan; extract at [mcog-l12-mla-2025-2028/](mcog-l12-mla-2025-2028/INDEX.md) |

That table was omitted by the 2026-08-10 migration ("outside the scope of this vault") and
restored on 2026-08-13. **So `payroll/` is a declared dependency of the field-ops FRD, not a
neighbouring module.**

## Decisions that bind this module

Seven `decisions/` notes carry `module/payroll`. None is `verified` — all are `reference`,
meaning a named person on the team decided them and they bind implementation until TCG says
otherwise.

- [2026-09-01-subsistence-not-a-craft-attribute.md](../decisions/2026-09-01-subsistence-not-a-craft-attribute.md) — subsistence is a property of the trip, not the trade; supersedes the per-craft modifier shown on 2026-08-13
- [2026-08-25-non-union-base-rate-per-person.md](../decisions/2026-08-25-non-union-base-rate-per-person.md) — non-union base rate comes from `Employee.hourlyRate`
- [2026-09-09-work-chains-stitch-only-when-there-is-no-gap.md](../decisions/2026-09-09-work-chains-stitch-only-when-there-is-no-gap.md) — entries stitch only when back-to-back; Brian retracts the 30-minute tolerance as a bug, and we copied it
- [2026-08-25-boom-adder-on-top-unmultiplied.md](../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md) — **working** decision, not confirmed by labor counsel — **and contradicted 2026-09-09** by a real Payroll App entry and by our own shipped engine; see its appendix
- [2026-08-25-craft-locked-rate-override-scoped-to-union.md](../decisions/2026-08-25-craft-locked-rate-override-scoped-to-union.md) — **working** reading of the note below
- [2026-08-24-payroll-time-rounding-method.md](../decisions/2026-08-24-payroll-time-rounding-method.md) — start down, end up, 30-minute increments
- [2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md) — day-level deviations locked to craft-code amounts
- [2026-06-30-adp-erp-employee-data-ownership.md](../decisions/2026-06-30-adp-erp-employee-data-ownership.md) — which employee field is owned by ADP, the ERP, or QuickBooks

## Where payroll meets the rest of the vault

**Payroll does not capture its own inputs.** The mobile field-ops app does — lunch events,
labor detail, work-through-lunch authorizations — and those documents were migrated a month
earlier, from Confluence, by people writing about a different module. Neither side cites the
other. Three seams are load-bearing:

| Seam | Field-ops side | Payroll side |
| --- | --- | --- |
| **Lunch threshold values** | The Atom mobile app (Confluence v10, 2026-08-11) states **5 / 10.5 / 16.5 / 22** hours ([atom .../03-work-execution-and-lunch.md](../field-ops/atom-mobile-app-user-stories/03-work-execution-and-lunch.md)). `BRS-LUNCH-005` separately marks the values **📄 Needs Supporting Documentation** | [wtl-charts.md](wtl-charts.md) gives **5:01 / 10.5:01 / 16:01 / 21.5:01**. **Lunches 3 and 4 disagree by half an hour** — a double-time penalty either way. Neither should be implemented until reconciled |
| **How many lunches exist** | `BRS-LUNCH-002` lists **three** and is ✓ Confirmed. The Atom page v10 says **four** | Payroll models **four** — `WTL_0`…`WTL_4`. Two sources say four; **the ✓ Confirmed BRS rule is the outlier** |
| **Previous-day rest** | `BRS-PAY-003` *Previous Day Rest Validation* — status **⚠ Needs Client Validation**, mentions "eight-hour rest periods, double-time implications" | [mcog-l12-mla-2025-2028/01](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md) Rest Periods, and the implemented `REST_PERIOD_PREMIUM` / `app.usp_Apply_RestPeriod_Premium` |

Also relevant, though less sharp: `FR-FOP-013` (Lunch Monitoring / Lunch Timer and Alerts — the
id is ambiguous, see the main index), `FR-FOP-014` Lunch Recording, `FR-FOP-015` Work Through
Lunch, and `FR-FOP-023` Labor Details all specify the capture side of data payroll consumes.

The payroll documents in this folder are **not** an approved answer to those open BRS items —
they are a source that was not available when the BRS was written. Someone has to decide whether
they resolve it. See [payroll/gaps.md](gaps.md) → *Field-ops lunch capture vs payroll WTL*.

## Where the biggest unknown is

Both the requirements document and the legacy system's own known-issues file name the same
thing as the largest open design area: **rule applicability by Payroll Group.** The current
system grew from an L12 union baseline, and which of those rules apply to L12 mechanics, to
non-union hourly, and to salaried staff is *not settled* — it needs management, payroll and
legal confirmation. Nine of the rule matrix's open decisions and eight of the ERP document's
24 come back to this.

Do not infer an answer from what the legacy system currently does. That is the thing being
questioned.
