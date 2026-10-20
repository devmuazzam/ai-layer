---
title: "Departments and roles: nine departments; one main role per person plus a can-also-fill list, the main role decides access; Job Foreman is a per-job pick; only the Crane Superintendent joins field crew and HDRs on a ticket; Payroll Admin sits in HR; who may change roles (Corrina Bustos, 2026-10-20) — decision"
source: decision/Corrina Bustos (TCG HR Manager) — Microsoft Teams reply to Syed Haris, 2026-10-20
decided: 2026-10-20
decided_by: >-
  Corrina Bustos (TCG, HR Manager per the unverified admin/engagement-directory-and-org-charts.md;
  also the payroll owner in earlier decision notes), in writing, in a Microsoft Teams reply on
  2026-10-20 to an eight-question message from Syed Haris (CodingCops), sent the same day. She
  answered all eight, tersely. Clause 7 names a second approver, Lisette Anzaldo (Dispatch Manager),
  who is not on record agreeing. Brian Petros, named on 2026-09-01 as assembling the role list with
  her, has not commented. The questions and her reply were relayed to tcg-scrum verbatim by the
  Claude Code session of Syed Haris on 2026-10-20; tcg-scrum did not see the Teams thread itself.
  Recorded by tcg-scrum on 2026-10-20.
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

## Decision — each answer, her words beside the reading

| Q | Her words | Reading | Settled? |
| --- | --- | --- | --- |
| 1 | *"yes"* | **The departments are the nine named:** Field Operations, Shop, Yard, Dispatch, Sales, Accounting, Safety, HR, Management. Her "yes" also accepts the examples given with the list: Operators, Oilers and Riggers under Field Operations; Mechanics under Shop; Wes and the owners under Management. | **Yes** — the department list. The full role list *within* each department was not asked, beyond those examples. |
| 2 | *"yes to both"* | **One main role per person, plus a "can also fill" list of other positions.** The main role decides what the person can see in the system (portal access). The examples treat the "other positions" as entries of the same role list (Oiler, Rigger, 3rd Man), so a person's can-also-fill list is drawn from the roles. | **Yes.** How it is stored is a developer decision. |
| 3 | *"yes sometimes. ex: HDR Mechanic can also be called out into the field to be a 3rd man or rigger. i am unsure about the sales coordinator part"* | Her example answers **slot filling, not access**. It extends Q2: an HDR mechanic's can-also-fill list may include **Rigger**, not only 3rd Man. Whether an individual can get access beyond their role's default is **not answered**. She said she was unsure about the Sales Coordinator quote-approval example. Her *"yes sometimes"* is not read as a yes to per-person access, because the example she gave for it is not about access. | **No.** Open in [../admin/gaps.md → *Per-person access beyond the role default*](../admin/gaps.md#per-person-access-beyond-the-role-default-and-the-approval-flow-for-role-and-permission-changes). |
| 4 | *"Job Foreman is something they are picked and assigned PER job"* | **Job Foreman is a per-job designation, not a role.** This agrees with [../payroll/foreman-and-military-premiums.md](../payroll/foreman-and-military-premiums.md) (`unverified`), *"The job foreman is chosen by the crane superintendent … per job"*. So FCC's `Job Foreman` employee type (id 15, created 2026-02-18 by `corrinab`, per [../payroll/fcc-employee-types-and-crafts.md](../payroll/fcc-employee-types-and-crafts.md)) **should not become a role**. Her reply does not say who does the picking. | **Yes** — designation, not role. |
| 5 | *"only crane superintendent would also qualify to get a job ticket. NEVER yard techs."* | **Who may go on a job ticket:** field crew; HDRs (through their can-also-fill list, per Q2–Q3); and, besides those, **only the Crane Superintendent**. **Yard techs never.** By the same "only", nobody in Sales, Accounting, Safety, HR or Dispatch goes on a ticket. | **Yes**, with one remainder: see *What this does not settle*, item 2. |
| 6 | *"right now, Micaela's Payroll Admin is still under HR"* | **The Payroll Administrator role sits in the HR department**, "right now". The holder is Micaela Slykhuis per [2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md) clause 2. "Right now" and "still" say the placement may change. Nothing in the reply says when or how. | **Yes**, as the current placement. |
| 7 | *"Sales Coordinator and Dispatch should be able to change roles and permissions, Dispatch Manager (Lisette) and myself approve."* | **Sales Coordinator and Dispatch may change roles and permissions. A change is approved by the Dispatch Manager (Lisette Anzaldo) and Corrina Bustos.** No request/approval flow exists in the ERP today, so this answer **implies one is built**. It matches an earlier ask: Ryan Adams (Sales Manager), 2026-03-19 roles demo 29:52–31:39, a request/approval step for extra access with a record of who approved what ([../meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md](../meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md) lines 156–164). | **Yes, as stated**, but it describes behaviour that does not exist, and four details are open (see *What this does not settle*, item 4). |
| 8 | *"yes and yes"* | **A temp fill-in uses the same role as a regular employee in that job:** the same pay setup and the same access. | **Yes.** |

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
- **Who may go on a job ticket**: field crew, HDRs through their can-also-fill list, and the Crane
  Superintendent. Never yard techs (Q5).
- **Payroll Administrator** sits in HR, for now (Q6).
- **Who may change roles and permissions**: Sales Coordinator and Dispatch, approved by Lisette
  Anzaldo and Corrina Bustos (Q7, with the remainders below).
- **Temps** use the regular role for that job: same pay setup, same access (Q8).

## What this does not settle

1. **Per-person access beyond the role default (Q3).** Whether two people with the same main role
   can ever have different access. Her example was about slot filling, and she was unsure about the
   Sales Coordinator quote-approval case. **Do not build per-person access from this reply.** Open in
   [../admin/gaps.md → *Per-person access beyond the role default*](../admin/gaps.md#per-person-access-beyond-the-role-default-and-the-approval-flow-for-role-and-permission-changes).
2. **Managers who operate (Q5 remainder).** The question offered *"a manager who operates"* as an
   example, and her reply names only the Crane Superintendent. Read literally, "only" excludes
   managers. But FCC holds **three `Management`-type employees who also hold `Operator`** (ADP file
   §4), and she did not speak to them directly. Whether those three may go on a ticket is unconfirmed.
3. **What each role may do.** The capabilities of each role are still unwritten. So is the full role
   list inside each department, beyond the Q1 examples. This is the main remaining half of the admin
   gap.
4. **The Q7 approval flow is unbuilt, and four details are open:**
   - **"Dispatch":** the whole Dispatch department, the Dispatcher role (Liz Lopez per the
     unverified org chart), or the Dispatch Manager?
   - **"change roles and permissions":** assigning a person's role, editing what a role may do, or
     both?
   - **The approvers:** must both Lisette Anzaldo and Corrina Bustos approve, or does either one?
   - **Self-approval:** does a change made by an approver also need the other's approval?

   Lisette Anzaldo is not on record agreeing to be an approver.
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
- **Ticket eligibility:** a field-crew role, an HDR with that position in their can-also-fill list,
  or the Crane Superintendent. Yard roles never. Where this attribute lives is a developer decision.
- Nothing grants access to an individual outside their role until Q3 is answered.
- The Q7 approval flow is new behaviour. It is Path A work, not part of the fold.

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

Not done, because file bodies are outside the recording agent's write scope:

- **[../admin/INDEX.md](../admin/INDEX.md) → *Decisions*:** needs a row for this note — *Nine
  departments; one main role plus a can-also-fill list, the main role decides access; Job Foreman is
  per job; only the Crane Superintendent joins field crew and HDRs on a ticket; Payroll Admin in HR;
  Sales Coordinator and Dispatch change roles, Lisette Anzaldo and Corrina Bustos approve.
  `status: verified` (Corrina Bustos, 2026-10-20). Role capabilities and per-person access are not
  settled.*
