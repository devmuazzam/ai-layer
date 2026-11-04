---
title: "Departments and roles: nine departments; one main role per person plus a can-also-fill list, the main role decides access; Job Foreman is a per-job pick; who goes on a job ticket (field crew, HDRs, the Crane Superintendent, and Local 12 managers, in the position they fill); Payroll Admin sits in HR; the Dispatcher assigns roles with Dispatch Manager approval, four named people edit what a role can do (Corrina Bustos, 2026-10-20, two replies) — decision"
source: decision/Corrina Bustos (TCG HR Manager) — two Microsoft Teams replies to Syed Haris, 2026-10-20
decided: 2026-10-20
decided_by: >-
  Corrina Bustos (TCG, HR Manager per the unverified admin/engagement-directory-and-org-charts.md;
  also the payroll owner in earlier decision notes), in writing, in two Microsoft Teams replies on
  2026-10-20 to Syed Haris (CodingCops). The first answered an eight-question message sent the same
  day, tersely. The second answered a four-question follow-up, also sent the same day. The
  follow-up narrows clause 7: the Dispatcher assigns roles, and the Dispatch Manager (Lisette
  Anzaldo) approves an assignment. Lisette Anzaldo is not on record agreeing to either role. The
  follow-up's clause 2 also names "Melissa" and "Joe" as role editors, read as Melissa McNutt
  (President) and Joe Schacatano; neither is on record agreeing. Follow-up clause 1 is deferred to Ryan Adams (Sales
  Manager), who has not replied. Brian Petros, named on 2026-09-01 as assembling the role list with
  her, has not commented. Both exchanges were relayed to tcg-scrum verbatim by the Claude Code
  session of Syed Haris on 2026-10-20. tcg-scrum did not see the Teams thread itself. Recorded by
  tcg-scrum on 2026-10-20. The follow-up was added the same day, after the first version was
  committed (overlay 4530c79).
status: verified
conflicts_with: []
resolves:
  - "admin/gaps.md#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten (department list and who may change roles; partial — role capabilities still open)"
  - "payroll/gaps.md#employee-types--fcc-holds-several-per-employee-we-store-one (first half; partial — the CraftRoleType half was not asked)"
  - "payroll/gaps.md#field-role-vs-portal-role--one-list-in-fcc-three-representations-in-tcg (partial — the role is the job and decides access; CraftRoleType not asked)"
  - "dispatch/gaps.md#sales-persons-in-the-das-employees-tab--dispatchability-is-an-employee-type-attribute-we-do-not-have (answered in substance — who may go on a job ticket; the mechanism is a developer decision)"
  - "payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives (Q2's department remainder only)"
related_decisions:
  - 2026-09-04-system-departments-and-roles-carry-no-restrictions.md
  - 2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md
  - 2026-09-15-employee-profile-compensation-type-and-statuses.md
jira: []
tags: [module/admin, module/payroll, module/dispatch, kind/decision, permissions-roles, reference-data, data-migration]
---

# Departments and roles: nine departments, one main role plus a can-also-fill list

**Context.** No ticket yet. The work in progress (Syed Haris, CodingCops) folds `EmployeeType` into
`DepartmentRole`, so one role list carries both the job and the portal permissions. The evidence
gathered before asking is
[../payroll/adp-api-responses/workers-departments-2026-10-20.md](../payroll/adp-api-responses/workers-departments-2026-10-20.md)
(`status: reference`) and the *Update 2026-10-20* bullet on
[../admin/gaps.md → *Departments, roles and their capabilities*](../admin/gaps.md#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten).

## The exchange

Syed Haris to Corrina Bustos, Microsoft Teams, 2026-10-20, exactly as sent:

1. Is this the right list of departments? Field Operations, Shop, Yard, Dispatch, Sales, Accounting,
   Safety, HR, Management. (For example: Operators, Oilers and Riggers under Field Operations,
   Mechanics under Shop, Wes and the owners under Management.)
2. Can each person have one main role, plus a list of other positions they're allowed to fill? (For
   example: Operator, can also fill Oiler, Rigger or 3rd Man. Or an HDR mechanic who can also fill
   3rd Man on a job.) Their main role would also decide what they can see in the system.
3. Do two people with the same job ever need different access? (For example: two Operators, but
   only one can see the dispatch board. Or two Sales Coordinators, but only one can approve quotes.)
4. Is Job Foreman something a person *is*, or something they're *picked as* on a particular job?
5. Apart from field crew and HDRs, does anyone else ever go on a job ticket? (For example: yard
   techs as driver or 3rd man, the crane superintendent, or a manager who operates.)
6. Which department does Micaela's Payroll Administrator role belong in, HR or Accounting?
7. Who should be allowed to change roles and permissions, and does a change need someone to approve
   it?
8. If there's time: does a temp fill-in get the same role as a regular employee in that job? (For
   example: a temp Operator uses the Operator role, so they get the same pay setup and the same
   access.)

Corrina Bustos, Microsoft Teams, 2026-10-20, verbatim:

> ```
> yes
> 2. yes to both
> 3. yes sometimes. ex: HDR Mechanic can also be called out into the field to be a 3rd man or rigger. i am unsure about the sales coordinator part
> 4.Job Foreman is something they are picked and assigned PER job
> 5. only crane superintendent would also qualify to get a job ticket. NEVER yard techs.
> 6. right now, Micaela's Payroll Admin is still under HR
> 7. Sales Coordinator and Dispatch should be able to change roles and permissions, Dispatch Manager (Lisette) and myself approve.
> 8. yes and yes
> ```

Her first line carries no number. It is read as the answer to Q1, because her numbering starts at 2.

### The follow-up, same day

Syed Haris to Corrina Bustos, Microsoft Teams, 2026-10-20, exactly as sent:

1. Can one person get extra access on top of their role, without changing it for everyone in that
   role? (For example: one Sales Coordinator who can also approve quotes, while the others can't.)
   If not, we'd make that a separate role.
2. On who changes roles and permissions: is it the Dispatcher or the Dispatch Manager? Does it mean
   assigning someone's role, editing what a role can do, or both? And does a change need both you
   and Lisette to approve, or either one?
3. When Jeff (crane superintendent) goes on a job ticket, what is he on it as? (Operator, rigger, or
   as superintendent?)
4. Can a manager who also operates go on a job ticket? (FCC has three managers who are also set up
   as Operators.)

Corrina Bustos, Microsoft Teams, 2026-10-20, verbatim:

> ```
> 1. I have asked Ryan about the sales coordinator. Will let you know when he responds.
> 2. Dispatcher can assign someone's role. A change needs approval from Dispatch Manager. Editing what a role can do would be myself, Melissa, Joe, or Lisette.
> 3. Crane super would be assigned in what position he was for that particular job.
> 4. Yes. Reason being, Jeff Kelley and Kyle Harlow are managers but are also in the local 12 union so they are allowed to operate.
> ```

**Why this is the same note, not a second one.** Both replies came the same day, in the same
thread. The follow-up only asks about what the first reply left open: Q3, Q5 and Q7. The first
reply's readings stay in the table below as the record of what was said. Where the follow-up
narrows or answers a row, that row says so and points to the follow-up table.

## Decision — each answer, her words beside the reading

| Q | Her words | Reading | Settled? |
| --- | --- | --- | --- |
| 1 | *"yes"* | **The departments are the nine named:** Field Operations, Shop, Yard, Dispatch, Sales, Accounting, Safety, HR, Management. Her "yes" also accepts the examples given with the list: Operators, Oilers and Riggers under Field Operations; Mechanics under Shop; Wes and the owners under Management. | **Yes** — the department list. The full role list *within* each department was not asked, beyond those examples. |
| 2 | *"yes to both"* | **One main role per person, plus a "can also fill" list of other positions.** The main role decides what the person can see in the system (portal access). The examples treat the "other positions" as entries of the same role list (Oiler, Rigger, 3rd Man), so a person's can-also-fill list is drawn from the roles. | **Yes.** How it is stored is a developer decision. |
| 3 | *"yes sometimes. ex: HDR Mechanic can also be called out into the field to be a 3rd man or rigger. i am unsure about the sales coordinator part"* | Her example answers **slot filling, not access**. It extends Q2: an HDR mechanic's can-also-fill list may include **Rigger**, not only 3rd Man. Whether an individual can get access beyond their role's default is **not answered**. She said she was unsure about the Sales Coordinator quote-approval example. Her *"yes sometimes"* is not read as a yes to per-person access, because the example she gave for it is not about access. | **No.** Open in [../admin/gaps.md → *Per-person access beyond the role default*](../admin/gaps.md#per-person-access-beyond-the-role-default-and-the-approval-flow-for-role-and-permission-changes). **Follow-up F1:** still open; she has asked Ryan Adams. |
| 4 | *"Job Foreman is something they are picked and assigned PER job"* | **Job Foreman is a per-job designation, not a role.** This agrees with [../payroll/foreman-and-military-premiums.md](../payroll/foreman-and-military-premiums.md) (`unverified`), *"The job foreman is chosen by the crane superintendent … per job"*. So FCC's `Job Foreman` employee type (id 15, created 2026-02-18 by `corrinab`, per [../payroll/fcc-employee-types-and-crafts.md](../payroll/fcc-employee-types-and-crafts.md)) **should not become a role**. Her reply does not say who does the picking. | **Yes** — designation, not role. |
| 5 | *"only crane superintendent would also qualify to get a job ticket. NEVER yard techs."* | **Who may go on a job ticket:** field crew; HDRs (through their can-also-fill list, per Q2–Q3); and, besides those, **only the Crane Superintendent**. **Yard techs never.** By the same "only", nobody in Sales, Accounting, Safety, HR or Dispatch goes on a ticket. | **Yes.** **Follow-up F3–F4** settle what was left: the Crane Superintendent goes on the ticket in the position he fills on that job, and managers who are Local 12 members may also go on a ticket. The "only" above is therefore **narrowed**, not the whole rule. |
| 6 | *"right now, Micaela's Payroll Admin is still under HR"* | **The Payroll Administrator role sits in the HR department**, "right now". The holder is Micaela Slykhuis per [2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md) clause 2. "Right now" and "still" say the placement may change. Nothing in the reply says when or how. | **Yes**, as the current placement. |
| 7 | *"Sales Coordinator and Dispatch should be able to change roles and permissions, Dispatch Manager (Lisette) and myself approve."* | **Sales Coordinator and Dispatch may change roles and permissions. A change is approved by the Dispatch Manager (Lisette Anzaldo) and Corrina Bustos.** No request/approval flow exists in the ERP today, so this answer **implies one is built**. It matches an earlier ask: Ryan Adams (Sales Manager), 2026-03-19 roles demo 29:52–31:39, a request/approval step for extra access with a record of who approved what ([../meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md](../meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md) lines 156–164). | **Narrowed by follow-up F2.** Three of its four open details are answered there. The first reply's "Sales Coordinator" is not in F2. That is recorded as a tension, not resolved (see *What this does not settle*, item 4). |
| 8 | *"yes and yes"* | **A temp fill-in uses the same role as a regular employee in that job:** the same pay setup and the same access. | **Yes.** |

### Follow-up — each answer

| F | Her words | Reading | Settled? |
| --- | --- | --- | --- |
| F1 | *"I have asked Ryan about the sales coordinator. Will let you know when he responds."* | Per-person access beyond the role default (Q3) is **deferred to Ryan Adams** (Sales Manager, per the unverified org chart). No answer yet. | **No.** Awaiting Ryan Adams. |
| F2 | *"Dispatcher can assign someone's role. A change needs approval from Dispatch Manager. Editing what a role can do would be myself, Melissa, Joe, or Lisette."* | Two different actions, with two different sets of people. **(a) Assigning a person's role:** done by the **Dispatcher**, and the change **needs approval from the Dispatch Manager** (Lisette Anzaldo). That is one approver; Corrina is not a second one. **(b) Editing what a role can do** (its permissions): done by **Corrina Bustos, Melissa McNutt, Joe Schacatano or Lisette Anzaldo**. The surnames are our reading against the unverified [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md). Melissa McNutt is the President. "Joe" is read as **Joe Schacatano**, of the executive tier, who is listed as VP of Operations in one table there and as VP of Sales on the 16 June 2026 chart. The directory also lists a **Joe Deitrick** (Sales Team), so the reading is ours, not her words. **No approval step was stated for role edits.** The question asked about "a change" generally, and her approval sentence sits with the assignment sentence. | **Yes**, for who assigns, who approves an assignment, and who edits a role. **Open:** whether Sales Coordinators still assign roles (the first reply named them); self-approval; whether role edits need any approval (none stated). |
| F3 | *"Crane super would be assigned in what position he was for that particular job."* | **The Crane Superintendent goes on a ticket in the position he actually fills on that job**: Operator, Rigger, and so on. "Crane Superintendent" is **not a ticket slot type of its own**. In the role model, that means the positions he may fill are on his can-also-fill list. | **Yes.** |
| F4 | *"Yes. Reason being, Jeff Kelley and Kyle Harlow are managers but are also in the local 12 union so they are allowed to operate."* | **A manager who operates may go on a job ticket.** She names **Jeff Kelley** (Crane Superintendent) and **Kyle Harlow** (VP of Fleet; VP of Fleet and Field Operations on the 16 June 2026 chart, both per the unverified org chart). **The basis she states is Local 12 union membership**: they are allowed to operate because they are in the union. This closes the Q5 "managers who operate" remainder. | **Yes**, for the two she named. FCC holds **three** `Management`-type employees with `Operator`. She named two, and the ADP file records counts only, not names, so the third is not identified. Whether the third qualifies is unconfirmed. |

## Why

She gave no reasons. These are the HR Manager stating how TCG is organised and how she wants access
handled. The written context she was answering against:

- **The nine departments** follow the candidate list in the 2026-10-20 update of the admin gap,
  built from FCC's populated *classification* field, ADP's job titles and the 16 June 2026 org chart
  ([../payroll/adp-api-responses/workers-departments-2026-10-20.md](../payroll/adp-api-responses/workers-departments-2026-10-20.md);
  [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md)).
  ADP's twelve departments are not used for this; only three hold anyone.
- **One main role plus can-also-fill** is what FCC already holds: one primary employee type plus
  unlimited secondary types, and 56 of 67 active field crew hold all five field types (same ADP
  file, §4; [../payroll/fcc-employee-master-reference-data.md](../payroll/fcc-employee-master-reference-data.md) §2).
  Her answer makes that the ERP's model, not just the incumbent's.
- **The main role decides access** answers the 2026-05-05 review ask to *"clarify system roles vs
  work/job roles"* ([../erp-review-log.md](../erp-review-log.md)): in TCG they are one thing.

## What this settles

- The **department list**: nine, as named in Q1.
- The **person-to-role shape**: one main role, plus a can-also-fill list of other positions. The main
  role decides portal access (Q2). An HDR mechanic's list may hold 3rd Man and Rigger (Q2–Q3).
- **Job Foreman** is chosen per job. It is not a role, and FCC's `Job Foreman` type is not migrated
  as one (Q4).
- **Who may go on a job ticket:**
  - field crew;
  - HDRs, through their can-also-fill list;
  - the Crane Superintendent;
  - managers who are Local 12 members and so may operate. She named Jeff Kelley and Kyle Harlow
    (F4).

  Never yard techs (Q5). Each person goes on a ticket **in the position they fill on that job**. The
  Crane Superintendent is not a ticket slot type of his own (F3).
- **Payroll Administrator** sits in HR, for now (Q6).
- **Who changes roles and permissions** (Q7, narrowed by F2):
  - **assigning a person's role:** the **Dispatcher**, with approval from the **Dispatch Manager**
    (Lisette Anzaldo), one approver;
  - **editing what a role can do:** Corrina Bustos, Melissa McNutt, Joe Schacatano or Lisette
    Anzaldo. No approval step was stated for this.
- **Temps** use the regular role for that job: same pay setup, same access (Q8).

## What this does not settle

1. **Per-person access beyond the role default (Q3, F1).** Whether two people with the same main
   role can ever have different access. Her first example was about slot filling. In the follow-up
   she said she had **asked Ryan Adams** and would pass on his reply. **Do not build per-person
   access from either reply.** Open in
   [../admin/gaps.md → *Per-person access beyond the role default*](../admin/gaps.md#per-person-access-beyond-the-role-default-and-the-approval-flow-for-role-and-permission-changes).
2. **Managers who operate — closed by F4, with two remainders:**
   - **The third manager.** FCC holds **three** `Management`-type employees who also hold
     `Operator` (ADP file §4). She named two, Jeff Kelley and Kyle Harlow. The third is not
     identified in the vault (the ADP file records counts only), and nothing says whether that
     person is a Local 12 member.
   - **Is union membership a rule the ERP checks?** Her stated reason is Local 12 membership. That
     reason could become a check the ERP enforces, or simply explain whose can-also-fill list holds
     `Operator`. That choice is not stated. Treating it as the second is the smaller build; it is a
     developer decision, not a product rule.
3. **What each role may do.** The capabilities of each role are still unwritten. So is the full role
   list inside each department, beyond the Q1 examples. This is the main remaining half of the admin
   gap.
4. **The Q7 approval flow is unbuilt.** The follow-up (F2) answers three of the four details the
   first reply left open:
   - ~~"Dispatch"~~: **the Dispatcher** assigns roles (Liz Lopez, per the unverified org chart).
   - ~~"change roles and permissions"~~: **both**, split between two sets of people. The
     Dispatcher assigns a person's role. Corrina Bustos, Melissa McNutt, Joe Schacatano or Lisette
     Anzaldo edit what a role can do.
   - ~~The approvers~~: an assignment needs approval from the **Dispatch Manager** alone. The first
     reply's *"Dispatch Manager (Lisette) and myself approve"* is **narrowed** to one approver.

   **Still open:**
   - **Tension — do Sales Coordinators still assign roles?** The first reply said *"Sales
     Coordinator and Dispatch should be able to change roles and permissions"*. The follow-up names
     only the Dispatcher for assignment and does not mention Sales Coordinators. The second reply
     is not read as removing them silently. Recorded, not resolved; a confirmation has been sent.
   - **Self-approval:** Lisette Anzaldo is both the assignment approver and a role editor. May she
     approve an assignment she made, or one that touches her own role?
   - **Do role edits need approval?** None was stated, and it was not asked separately.
   - **"Joe"** is read as Joe Schacatano; the directory also has a Joe Deitrick.

   Lisette Anzaldo, Melissa McNutt and Joe Schacatano are not on record agreeing to these duties.
5. **Whether `CraftRoleType` derives from the role.** Not asked. The second half of
   [../payroll/gaps.md → *Employee types*](../payroll/gaps.md#employee-types--fcc-holds-several-per-employee-we-store-one)
   and the DAS craft-code entries that depend on it stay open.
6. **Not asked either:**
   - who picks the Job Foreman on each job (the unverified foreman page says the crane
     superintendent);
   - work-order dispatchability: FCC's `Dispatchable on` also covers work orders, and Q5 covers job
     tickets only;
   - how ADP's `PPEDEP` / `SADMIN` / `SALOFF` export value is derived;
   - whether "Micaela Slykhuis" and the transcripts' "Micaela Dipane" are one person (C5 in the
     payroll flagged-entries gap).

## Build impact

No code is changed by this note. For the `EmployeeType` → `DepartmentRole` fold:

- A role belongs to one of the nine departments.
- An employee has **one main role** (decides portal access) and a **can-also-fill list** of roles.
  Today `Employee.employeeTypeId` is a single nullable FK, and the FCC seeder drops the secondary
  types (`seed-all.ts:666-675`, per the payroll gap). How the list is stored is a structural choice
  for the developer: a new table or relation.
- `Job Foreman` (FCC type 15) is not seeded as a role.
- **Ticket eligibility** (Q5, F3, F4) follows from the positions a person may fill, not from their
  main role's name:
  - A person goes on a ticket **in a position**: Operator, Oiler, Rigger, 3rd Man, and so on.
    They are eligible if that position is their main role or is on their can-also-fill list.
  - The Crane Superintendent and Local 12 managers (Jeff Kelley, Kyle Harlow) are eligible through
    the field positions on their can-also-fill list. There is **no "Crane Superintendent" slot
    type**.
  - Yard roles are never eligible.
  - Where this attribute lives is a developer decision.
- Nothing grants access to an individual outside their role until Q3 / F1 is answered (awaiting
  Ryan Adams).
- **Two permissions, not one** (F2):
  - *assign a person's role*, held by the Dispatcher, with each assignment waiting for the Dispatch
    Manager's approval;
  - *edit what a role can do*, held by Corrina Bustos, Melissa McNutt, Joe Schacatano and Lisette
    Anzaldo, with no approval stated.

  The assignment approval is new behaviour. It is Path A work, not part of the fold. Whether Sales
  Coordinators also hold *assign* is open (item 4).

## Effect on the vault

No content file's `status:` changes. This note settles open questions; it supersedes no document.
No frontmatter edits.

Gap entries, done in the same pass:

- [../admin/gaps.md → *Departments, roles and their capabilities*](../admin/gaps.md#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten):
  status now *open — partly answered*. The department list and who may change roles are answered;
  role capabilities stay open. **Done.**
- [../admin/gaps.md → *Per-person access beyond the role default*](../admin/gaps.md#per-person-access-beyond-the-role-default-and-the-approval-flow-for-role-and-permission-changes):
  new open entry for Q3 and the Q7 approval flow. **Done.**
- [../payroll/gaps.md → *Employee types*](../payroll/gaps.md#employee-types--fcc-holds-several-per-employee-we-store-one):
  first half answered; the `CraftRoleType` half stays open. **Done.**
- [../payroll/gaps.md → *Field role vs portal role*](../payroll/gaps.md#field-role-vs-portal-role--one-list-in-fcc-three-representations-in-tcg):
  partly answered. **Done.**
- [../payroll/gaps.md → *Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives):
  Q2's department remainder answered (HR). The entry stays open for its other items. **Done.**
- [../dispatch/gaps.md → *Sales Persons in the DAS Employees tab*](../dispatch/gaps.md#sales-persons-in-the-das-employees-tab--dispatchability-is-an-employee-type-attribute-we-do-not-have):
  answered in substance; the mechanism is left to the developer. **Done.**

The [../admin/INDEX.md](../admin/INDEX.md) *Decisions* row for this note was added by the developer
session that committed the first version (overlay 4530c79).

**Follow-up reply (same day), done in the same pass:**

- [../admin/gaps.md → *Per-person access beyond the role default*](../admin/gaps.md#per-person-access-beyond-the-role-default-and-the-approval-flow-for-role-and-permission-changes):
  part 1 dated *asked Ryan Adams, awaiting*. Part 2(a)–(c) answered; (d) self-approval stays open.
  The Sales Coordinator tension and the unstated approval for role edits are added. Still open.
  **Done.**
- [../admin/gaps.md → *Departments, roles and their capabilities*](../admin/gaps.md#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten):
  dated line for who assigns roles and who edits them. Role capabilities stay open. **Done.**
- [../dispatch/gaps.md → *Sales Persons in the DAS Employees tab*](../dispatch/gaps.md#sales-persons-in-the-das-employees-tab--dispatchability-is-an-employee-type-attribute-we-do-not-have):
  the managers-who-operate remainder is closed (Local 12), and the superintendent's position is
  answered. **Done.**

Not done, because file bodies are outside the recording agent's write scope:

- **[../admin/INDEX.md](../admin/INDEX.md) → *Decisions*:** the row added with 4530c79 says only
  the Crane Superintendent joins field crew and HDRs on a ticket, and that Sales Coordinator and
  Dispatch change roles with Lisette Anzaldo and Corrina Bustos approving. Both are now **narrowed**
  by the follow-up. The row needs to say:
  - Local 12 managers may also go on a ticket, everyone in the position they fill;
  - the Dispatcher assigns roles, approved by the Dispatch Manager;
  - Corrina, Melissa, Joe or Lisette edit what a role can do;
  - per-person access is awaiting Ryan Adams.
