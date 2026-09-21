---
title: Who fills the ticket — one job ticket per asset group per day; the Oiler is primary and fills it, the Operator is a second employee on the same ticket with their own labor record — decision
source: decision/TCG dispatch and operations (Lisette Anzaldo, Melissa McNutt, Brian Petros), recorded 2026-09-14
decided: 2026-09-14
decided_by: >-
  The rule is TCG's, stated on the record by three named TCG people between 2026-05-14 and
  2026-06-04 and never contradicted since: Lisette Anzaldo (dispatch — the practice described
  first-person on the 2026-05-14 call, and the approver of the `ASSETS_DISPATCH_(Lisette-approved).xlsx`
  sheet walked through on 2026-05-21), Melissa McNutt (2026-05-19 42:09, 2026-06-04 15:00–15:55),
  Brian Petros (2026-05-19 24:20, 2026-05-21 8:27–9:27). The forward-looking confirmation for the
  ERP is 2026-05-14 13:06→14:06 (Ehtesham Anwar: "if we send oilers the tickets by default and make
  them responsible" → "Yes"). The 2026-09-14 act is the adjudication: Syed Haris (CodingCops,
  git identity `hariscops`) requested in-session that the record above be taken as settling the
  gap over SCRUM-249 AC 2 and the 9:41 slip, and that the read-only-copy shape shipped
  provisionally on 2026-09-12 be superseded. No TCG person has answered the 2026-09-12 demo
  question in so many words; what closes the gap is that every TCG statement on the record
  already says the same thing, and the only REVIEWED field-ops document agrees.
status: verified
conflicts_with: []
resolves: field-ops/gaps.md#who-fills-the-ticket--the-schema-has-already-picked-a-side-against-the-only-reviewed-document
jira: [SCRUM-249]
tags: [module/field-ops, module/dispatch, module/payroll, kind/decision, ticket-workflow, labor-record, oiler, operator]
---

# One job ticket per asset group per day. The Oiler fills it; the Operator is on it.

## Decision

1. **A job ticket is per asset group per day, not per employee.** An asset group is either the
   main mobile crane with its primary tractor/trailer, or an additional tractor/trailer combo
   (a support / counterweight load). One ticket per group per "day", where the day can run past
   midnight. (Sheet `ASSETS_DISPATCH_(Lisette-approved).xlsx`, tab `ASSETS_DISPATCH_May21`, cell
   AA3, verbatim: *"Asset 'grouping' is either the 'main' mobile crane (with primary
   tractor/trailor) or additional tractor/trailer combo (one ticket per 'day'… where 'day' can
   extend past midnight)"*.)

2. **When the crane set has an Oiler seat, the Oiler is the ticket's primary employee.** The
   Oiler fills in and completes the ticket — checklists, labor, customer signatures, WTL,
   submit. **The Operator is a second employee on that same ticket**, with a **separate labor
   record** that the Oiler enters (the Oiler selects which employee an entry is for). The
   Operator has **no fill, complete, sign or submit step** of their own. (Sheet rows RT9001,
   9001, 10001, 11001, 14001, 19001, 20001, 26502, 27501, 35001, 36001, 55001: crane row →
   *ticket #1 / Oiler / Fills In-Completes Ticket ✅ / Has Separate Labor Hours ✅*; the
   *Operator Load* row on the **same ticket #1** → *Operator / fills ☐ / separate hours ✅*.)

3. **When the set has no Oiler seat, the Operator is primary and fills the ticket.** (Sheet
   rows 22T boom truck 2204, self-loaders SL01–SL04, 40T 4001–4004, 45T AT 4005–4006, 60T HTC
   6002: *ticket #1 / Operator / ✅ / ✅*.)

4. **Every support / counterweight load is its own asset group with its own ticket**, filled
   and completed by the 3rd man or rigger who drives it, with their own labor hours. (Sheet:
   every *Support Load 1–4* / *Load 1–2* row → *ticket #2 … #5 / 3rd man or rigger / ✅ / ✅*.)

5. **FR-TCG-FOP-001 open question 11** — *"Should Operator have any active approval or
   confirmation step in the shared Operator/Oiler ticket flow?"*
   ([`../field-ops/frd-new-format-draft/08-open-questions.md`](../field-ops/frd-new-format-draft/08-open-questions.md):27)
   — is answered by (2): **no active Operator step.** The Oiler's WTL signature covers the
   crew (Melissa McNutt 2026-06-04 15:55).

## Why

**Every TCG voice on the record says the same thing, across four calls and one approved
sheet, and the only REVIEWED field-ops document already says it.**

- **2026-05-14 Loading/Scheduling Pre-Ticketing**
  ([`../meetings/transcripts/2026-05-14-loading-scheduling-pre-ticketing.md`](../meetings/transcripts/2026-05-14-loading-scheduling-pre-ticketing.md):82–114;
  `status: reference`, a record not a commitment). The speaker is labelled *Brian Petros* but
  does dispatch work in the first person — the gap entry infers Lisette Anzaldo. **9:07**:
  *"when it's just crane plus one truck only, it's the oiler. He does all the paperwork for the
  operator. So he includes both of their timing… each other driver will do their own ticket."*
  **14:58**: *"in his ticket, it should include the crane, his tractor, and the trailer… and
  then his name and the operator's name."* **13:06 → 14:06**: Ehtesham Anwar proposes *"if we
  send oilers the tickets by default and make them responsible"* — answer *"If we send the
  tickets, yes."* That is the one forward-looking ERP confirmation on the record.
- **2026-05-19 Crane Configurations / Job Tickets**
  ([`../meetings/transcripts/2026-05-19-crane-configurations-job-tickets.md`](../meetings/transcripts/2026-05-19-crane-configurations-job-tickets.md):140–144, 273).
  Brian Petros **24:20**: *"Only the oiler would do the operator's ticket… Lisette will
  generate the job ticket for that first group of operator and oiler… that's just one ticket,
  and then she'll attach both."* He adds *"I'm not 100% sure until we talk more about it with
  others"* — which the two later sources then did. Melissa McNutt **42:09**: *"the oiler does
  the paperwork for the operator, their time ticket. That's why everything's sent together…
  Anybody else… they do their own individual labor."*
- **2026-05-21 Crane Configurations / Job Tickets**
  ([`../meetings/transcripts/2026-05-21-crane-configurations-job-tickets.md`](../meetings/transcripts/2026-05-21-crane-configurations-job-tickets.md):64–72)
  — Brian Petros walking the sheet with Lisette's corrections: **8:27** *"the oiler fills out
  the ticket"*; **8:35** *"like Lisette pointed out… the Oiler's filling out the ticket and
  filling out the hours on the ticket"*; **8:59** *"there's still separate labor hours for the
  operator, even though… the oiler actually inputs the operator's hours, but it's still a
  separate entry"*; **9:27**, asked whether the Oiler picks which employee an entry is for:
  *"Right, there's a separate field."*
- **`ASSETS_DISPATCH_(Lisette-approved).xlsx`**, tab `ASSETS_DISPATCH_May21` — **not in the
  vault**; in the requester's Downloads. Columns *Job Ticket (for each asset group) / Employee
  Type / Fills In-Completes Ticket / Has Separate Labor Hours* per crane set; header AA2
  *"Current FCC Job Ticketing Method (asset and employee labor activity)"*. Lisette Anzaldo's
  approval is the file name. Rows quoted in *Decision* above.
- **2026-06-04 Mobile App / Job LEM Tickets**
  ([`../meetings/transcripts/2026-06-04-mobile-app-job-lem-tickets.md`](../meetings/transcripts/2026-06-04-mobile-app-job-lem-tickets.md):117–121).
  Melissa McNutt **15:00**: *"for the operator and oiler, they're signed one ticket, and the
  oiler is responsible for doing all the paperwork for the operator"*; **15:22**: *"any other
  person on the job site gets their own… ticket where they have to do that process
  themselves"*; **15:55**: the customer signs the Oiler's WTL and *"we just go all based off
  the operator and oilers"*.
- **FR-TCG-FOP-001 §4.1**
  ([`../field-ops/frd-new-format-draft/04-role-responsibility-model.md`](../field-ops/frd-new-format-draft/04-role-responsibility-model.md):17,
  v1.1 REVIEWED — the only reviewed field-ops document, still `status: unverified` in the
  vault): *"The Oiler owns the main ticket. The Operator's labor is captured within the shared
  ticket but the Operator does not process paperwork or collect signatures."* Matches (2)
  exactly.
- **The legacy system already holds this shape**, so migration and payroll have a precedent:
  FCC's `FMS_JOB_TICKET` + `FMS_JOB_TICKET_EMP_UNIT` (one ticket, many employee/unit rows, a
  `PrimaryEmp` bit) — see the 2026-09-04 update in the gap entry for the DDL citations.

### The 9:41 trap — do not re-litigate it

At **9:41** on 2026-05-14 the same speaker says *"It will be 1 ticket. per employee. on the
same job."* Fifteen seconds later, asked directly *"for a crane, oiler and operator are going,
we will have two tickets?"* (Ehtesham 9:47), the answer at **9:56** is *"One. Wine [one] with
both of them in it."* and at **10:12** *"I can just do one ticket with both of them on that
ticket and then one of them can complete it."* **9:41 was a slip, corrected on the spot.**
Anyone quoting 9:41 alone gets the opposite answer; it is the only utterance on the record
for one-per-employee, and its own speaker withdrew it.

### The only other counter-evidence

`SCRUM-249` *DAS Per day job ticket creation and assignment* (Done 2026-06-30, created
2026-05-01 — before the 2026-05-14 call) AC 2: tickets are created *"against all employees that
had allocations"*. No requester is named on it, and it predates every TCG statement above. It
is superseded in substance by this decision; Jira is read-only to `tcg-scrum`, so the ticket
itself is not annotated.

## What this supersedes in the code

Main carried PR #561 `feat/crew-ticket-read-only-copy` (merged 2026-09-12) and PR #568: one
`JobTicket` row per allocation, with a `primaryTicketId` self-FK linking the Operator's row to
the Oiler's as a read-only mirrored copy. That mechanism has since been retired by
SCRUM-CREW-TICKET (the link column, the mirroring and its linking service are removed), so it
is no longer cited by line number. The mechanism was built **provisionally, to get the verdict** (gap entry, update
2026-09-12). This decision supersedes that shape. **Target:** one ticket row per asset group
per day, with a ticket-employees join carrying a primary flag and per-employee labor entries
— FCC's `FMS_JOB_TICKET` + `FMS_JOB_TICKET_EMP_UNIT` shape. The link column and the mirrors
are the parts to retire. The build is tracked in `.ai/aidlc/SCRUM-CREW-TICKET/` (created
2026-09-14).

## What this does not settle — deliberately left open

None of the following is decided here; do not read them into it.

- **(a) Customer-signature steps on 3rd-man tickets.** Melissa McNutt says third men do not
  collect customer signatures today (2026-05-19 42:09; 2026-06-04 15:22). The requester said
  leave the ticket flow as-is for now. Open.
- **(b) Dispatcher option for two people in one truck / a separate ticket when one reports to
  site directly** (2026-05-14 10:12, 12:17, 14:47). Discussed as a dispatcher choice; not
  decided.
- **(c) The Oiler adding fill-in / temporary crew to their ticket** (2026-06-04 1:00:53,
  1:02:28 — Melissa: *"add an additional crew member to their ticket"*, *"we can add fill-ins
  on the Oiler's LEM"*). Asked for; not decided.
- Vendor crews; whether signatures/checklists are visible to the Operator on the shared ticket;
  notification wording — the items the 2026-09-12 update listed as left open by the build.

## Effect on the vault

All edits below were applied in this pass by `tcg-scrum`.

- **`field-ops/gaps.md` → *Who fills the ticket — the schema has already picked a side against
  the only REVIEWED document*** — `- **Status:** open` flipped to
  `- **Status:** resolved 2026-09-14 — see decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md`,
  and a dated resolution update appended. History untouched. **Done.**
- **`field-ops/frd-new-format-draft/04-role-responsibility-model.md`** — `provenance_note:`
  added pointing here: §4.1 is confirmed by this decision. **`status:` left `unverified`, and
  `conflicts_with:` left as-is, on purpose.** The file is one part of a split FRD whose
  `conflicts_with:` names the two other field-ops FRDs as wholes; this decision settles one
  section's one question, not the FRD-versus-FRD conflict, and §4.2's *"Main customer signature
  capture — "* row for Third Man sits inside open item (a) above. Flipping the file to
  `verified` would claim more than was decided. This follows the
  `2026-08-25-craft-locked-rate-override-scoped-to-union.md` precedent (pointer in frontmatter,
  status unchanged). **Done.**
- **`field-ops/frd-new-format-draft/08-open-questions.md`** — `provenance_note:` added:
  open question 11 is answered by this decision. **The table row itself (`| 11 | … | Open |`)
  is a body edit and is not touched** — the file's owners (Wes + Client per the row) or a
  human with body-edit rights should update it; this note is the citable source. **Done
  (frontmatter only).**
- **Not superseded:** `field-ops/field-ops-frd/05-role-definitions.md` (FR-TCG-FOP-002 v2.0
  DRAFT) hedges with *"completes the primary ticket completion workflow"*. It is not wrong
  under this decision (there *is* a primary), and it is one part of a whole-FRD conflict set
  this decision does not adjudicate. Frontmatter unchanged.
- **Not edited:** the frozen original at
  `gaps.md#who-fills-the-ticket--the-schema-has-already-picked-a-side-against-the-only-reviewed-document`
  (retired 2026-08-20, dispositioned 2026-08-24; the live entry carries the *From (frozen
  original)* backlink). Historical snapshot, per `STRUCTURE.md`.
- **Jira `SCRUM-249`** — read-only to this role; AC 2 stands as written on the ticket and is
  superseded only by this note.
