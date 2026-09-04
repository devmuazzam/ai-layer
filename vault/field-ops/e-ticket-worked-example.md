---
title: E-ticket worked example — job 45954, every checklist a real ticket carries
source: client-message/Melissa McNutt — "Job E-Ticket Checklist - 45954" supplied 2026-08-31; cross-checked 2026-09-04 against shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/job ticket - time card - equipment checklists/ (ticket 44944)
migrated: 2026-09-01
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/payroll, module/assets, module/dispatch, kind/reference, inspections, time-tracking, signatures, lunch, subsistence]
entities: [job-ticket, checklist, deficiency, employee, asset, unit, job, job-site, customer, signature]
---

# E-ticket worked example — job 45954

PDF: [assets/2026-08-31_job-e-ticket-checklist-45954.pdf](assets/2026-08-31_job-e-ticket-checklist-45954.pdf).
Air Boss Mechanical, 28365 Constellation Rd Valencia, worked 2026-06-10 with crane `10003`.
Melissa supplied it as *"a sample of the pre-trip"* alongside the quote in
[quotations/quote-terms-and-rate-card.md](../quotations/quote-terms-and-rate-card.md).

> **A second completed ticket arrived in the 2026-09-04 Project Repository drop.**
> [e-ticket-worked-example-44944.md](e-ticket-worked-example-44944.md) is ticket **44944** —
> Southern California Edison, 2026-05-12 — and it is the **complete three-part set**: the
> customer-facing e-ticket, the checklist report, *and* the internal **Labor & Unit Details**
> report, which this page does not have. Read that page for the union code, craft code, craft
> modifier, and the two parallel time records (`As recorded for the customer` vs `As recorded by
> the workflow`). It **corroborates every structural observation below** on a different crane, crew
> and customer — including the four-versus-one lunch-slot difference in §5, which now looks like a
> template difference rather than drift. The FCC feature behind each of these sections is
> documented in [fcc-e-ticket-and-atom-guides.md](fcc-e-ticket-and-atom-guides.md).

The FRD already specifies pre-trip behaviour —
[fr-fop-009-pre-trip-checklist.md](frd-new-format-draft/05-functional-requirements/fr-fop-009-pre-trip-checklist.md)
and [fr-fop-007](frd-new-format-draft/05-functional-requirements/fr-fop-007-guided-ticket-workflow.md).
**This is the first completed instance we hold**, so it shows what the requirement produces rather
than what it asks for. Where the two agree it is corroboration; where the artifact contains
something the FRD never mentions, that is flagged below.

---

## 1. Four phases, printed as headers

`Before Left Yard` → `After Arrived Job` → `Before Left Job` → `Ad-hoc Checklist`.

The ticket is organised by **phase of the day**, and each phase carries a different mix of unit
checklists, job checklists and signatures. That matches the FRD's workflow position model
(`FR-FOP-008 Leave Yard` → `FR-FOP-009 Pre-Trip`).

## 2. Checklists are per unit, and the operator load gets its own

Four unit checklists on one ticket:

| Checklist | Unit | Items |
| --- | --- | ---: |
| Crane Pre-Trip Inspection | `10003` | 17 |
| Trailer 30 Day Check List | **`10003 OL`** | 4 |
| AT - Tractors Pre-Trip Inspections | `AT15` | 26 |
| Tractor 30 Day Check List | `AT15` | 6 |

Two things follow. **`10003 OL` — the operator load — carries its own checklist**, which is direct
field confirmation of the unit convention in
[dispatch/crane-configurations.md](../dispatch/crane-configurations.md): the OL is a real unit,
not a line on the crane's ticket. And **pre-trip and 30-day inspections ride the same ticket**
side by side — the 30-day is not a separate workflow, it surfaces on the daily ticket for the
same unit. The FRD describes pre-trip checklists only; nothing in it mentions a 30-day cycle.

## 3. Three-state answers, not a checkbox

Every row answers **Completed · Deficiency · N/A**. The FRD calls for *"deficiency selection with
mandatory comment and priority"*, which matches — but the printed form has no priority column,
and `N/A` is used heavily (row 17 *Additional Comments* is `N/A` on both pre-trips).

## 4. Signatures are per checklist block, timestamped to the minute

Not one signature per ticket — one signature block per completed section, each with a printed
name and a timestamp:

| Block | Signers | Time |
| --- | --- | --- |
| Before Left Yard (tractor pre-trip) | Jonathen A | 05:58 |
| After Arrived Job — JSA | Robert F, Dana G, Jonathen A | 10:15–10:16 |
| Before Left Job — crane time stamps | Jonathen A | 14:27 |
| Tractor time stamps | Jonathen A | 14:28 |
| **Ad-hoc — Work Through Lunch** | **Robert F** (customer) | 10:26 |

The WTL authorization is signed by the **customer's** representative, mid-day, before the missed
meal happens. That is a customer signature captured on a crew device — a different actor from
every other signature on the ticket.

## 5. The Time Stamps checklist is the labour record

Crane `10003`, as filled:

| # | Event | Recorded |
| ---: | --- | --- |
| 1 | Leave Yard | 6am |
| 2 | Arrive Job | 9am |
| 3 | Build Up | 9–9:30am |
| 4 | Work | 9:30–10:30am |
| 5 | Break Down | 10:30–11am |
| 6 | Leave Job | 11am |
| 7 | Arrive Yard | 1:30pm |

**Times are free text in a `Comments` field**, not structured times — `9-9:30am` is one string in
one box. Build Up, Work and Break Down are recorded as *ranges*; the other four as instants.

Then:

- **8 — Subsistence.** *"If Subsistence is applicable please click deficiency and note long or
  short sub in the comments."* Subsistence is captured as a **Deficiency checkbox plus a comment
  token** — no distance, no mileage input. This independently corroborates the legacy
  `SUB_SHORT` / `SUB_LONG` token model in
  [payroll/legacy-payroll-app-db-extract](../payroll/legacy-payroll-app-db-extract/rules-plain-language.md)
  over any computed-distance reading; see the subsistence entry in
  [payroll/gaps.md](../payroll/gaps.md).
- **9–12 — Lunch Time, 2nd, 3rd, 4th.** Four slots, confirming four lunches exist (`brs.md`
  BRS-LUNCH-002 lists three). No threshold hours appear, so this does **not** settle the
  5 / 10.5 / 16.5 / 22 vs 5:01 / 10.5:01 / 16:01 / 21.5:01 disagreement. Format is free text:
  *"example: Lunch 12 pm to 12:30 pm"*.
- **13 — inspection attestation.** *"By signing this check list I am also signing that I performed
  and completed my Pre Trip Inspection, Rigging Inspection and Post Trip Inspection."*
- **14 — California meal-and-rest attestation**, a full paragraph the employee certifies: 30-minute
  meal by the end of the fifth hour, one 10-minute paid rest per four hours, contact HR if not.

**The tractor's Time Stamps checklist has one lunch slot, the crane's has four**, and the tractor
omits items 10–12 entirely. Whether lunch-slot count varies by unit type or the two templates
have simply drifted is unknown — registered in [gaps.md](gaps.md).

_Added 2026-09-04:_ **ticket 44944 shows exactly the same split** — crane `10002` has four lunch
slots, tractor `AT25` has one and omits the same rows. Two independent tickets, two months apart,
with different units. Drift on a single ticket is no longer the likely explanation; which template
is intended is still unanswered.

## 6. Job-level checklists sit alongside unit checklists

- **`Job Checklist - JSA 12.18.25`** — a Job Safety Analysis, 6 items, dated in its own title
  (a versioned template). Covers working near cranes and suspended loads, PPE, site conditions
  (including street permits, lane closures, FAA permit, pedestrian control), rigging, electrical
  > 4001 AMPS, and *"Safety Meeting Performed"*. Signed by three people.
- **`Job Checklist - Work Through Lunch Authorization`** — filed under `Ad-hoc Checklist`,
  reproducing the meal-period charge terms and taking the customer signature.

So a ticket carries **unit checklists, job checklists and ad-hoc checklists** as three distinct
kinds. `FMS_RESOURCE_CHECKLIST_ADHOC` (239 rows in FCC) is presumably the third —
it is one of the tables absent from the migration brief, per
[meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md).

## 7. Header repeats on every page

`Job Site Information` · `Report To` · `Customer Information` — including `Ordered By`, phone,
email and `Terms: NEW CUSTOMER`. The customer's payment terms are printed on the field ticket.

## Related — added 2026-09-04

- Every question on every FCC checklist, by phase code (`BLY`/`AAJ`/`BLJ`/`AAY`), from the restored 2026-06-23 database: [../payroll/tcg-rawfms-staging-database/data/fcc-checklist-templates.md](../payroll/tcg-rawfms-staging-database/data/fcc-checklist-templates.md).
- The section / sub-section rows that lay the ticket out, including the three-state answer grid: [../payroll/tcg-rawfms-staging-database/data/fcc-eticket-layout-tables.md](../payroll/tcg-rawfms-staging-database/data/fcc-eticket-layout-tables.md).
