# Intent — SLOT-DRIVEN-TICKET-ACCESS

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | None supplied; working ID SLOT-DRIVEN-TICKET-ACCESS |
| Title | Slot-driven ticket ownership, editability and steps |
| Type | Review and plan; bug investigation plus workflow-policy correction |
| Status | Planning requested; construction not requested |
| Epic | NOT ON TICKET |
| Sprint | NOT ON TICKET |
| Reporter | Requesting user; name NOT ON TICKET |
| Assignee | NOT ON TICKET |
| Captured on | 2026-10-22, Asia/Karachi |
| Captured by | Current review session |

## 2. Business intent

- Intent: A worker completes the ticket for the position they actually fill that day. The Oiler-slot assignee manages the shared Oiler/Operator ticket and its full workflow, irrespective of main employee role. Payroll continues to use one ticket for those two employees.
- Who benefits: Field crew, dispatch and payroll.
- What is worse today: The user reports an Operator assigned to an Oiler slot sees a read-only card and cannot complete the ticket.

## 3. Definition of done, as stated

Direct excerpts from the request, spelling preserved:

> "the ticket should be editable and fillablke by this operator just as oiler role and the employee that is assigned on the operator slot should only see the ticket in read only mode."

> "we are showing the ticket steps to employees based on the assigment slot type not by logged in employee role!"

> "ticket should be editable and have full steps including the checklists + customer signature steps etc"

> "if oiler or operator is assigned to a rigger/3rd man/ apprentice type slot then when they open their ticket then it should show ticket steps without checklists etc"

> "Only oiler type slot has access to all the ticket steps. And an opertaor type slot as well only if there is no oiler type slot in the set."

> "if a set on job has both oiler and operator type slots then only ticket will be managed by oielr snd opertor will see the ready only card of the ticket"

- Acceptance criteria present: Yes, in this chat rather than a linked tracker issue.

## 4. In scope

- Review current crew ownership, primary/secondary authorization and mobile read-only behavior.
- Plan FULL versus STANDARD by actual assignment slot and crew context.
- Include labor, checklists, signer identity, offline use and office-progress siblings in the plan.
- Preserve the shared-ticket payroll model.

## 5. Out of scope

- Application implementation, deployment, PRs or external tracker changes during this request.
- New pay rules, wage calculations, permissions to assign an otherwise ineligible employee.
- Automatic rewrite/merge of started, submitted or payroll-used historical tickets.
- Unrelated quote, attendance, standalone vehicle-inspection or payroll feature work.

## 6. Surfaces touched

| Surface | Planned | What changes |
| --- | --- | --- |
| apps/api | Yes | Assignment context, ownership diagnosis, flow/submit/labor consistency |
| apps/api/prisma | No new schema currently proposed | Read existing roles, allocations, tickets and roster |
| apps/web | Yes, regression/flow consumers | Office progress reflects the same resolved steps |
| apps/mobile | Yes | Remaining profile-role gates and offline consistency |
| packages/shared | Yes | Assigned-slot step/inspection policy |

## 7. Entities and business codes

Existing JobResource, JobResourceAllocation, DepartmentRole, JobTicket and TicketEmployee. Read existing IDs/codes; no new entity or prefix. Existing-row repair is not authorized by this planning request and is separately gated.

## 8. Roles and permissions

The occupied slot controls ticket behavior. Main employee role remains relevant to assignment eligibility and application access, but cannot override a known slot's ticket policy. A secondary roster member cannot write. Tenant scope remains unchanged.

## 9. Designs and references

No design handoff or ticket attachment supplied. Sources: this request; `.ai/aidlc/GUIDE.md`; prior slot-flow and shared crew-ticket specs; vault decision notes cited in spec.md; current API/mobile/shared implementations.

## 10. Terms

Slot = the assigned job resource position, represented by allocation -> jobResource -> role. Crew context = tenant + sub-job/day + set + shift. FULL/STANDARD refer to ticket workflows, not the user's application permission role. Main role and slot role can differ.

## 11. Numbers and values

The request names Oiler, Operator, Rigger, 3rd Man and Apprentice. Eight STANDARD steps and fourteen non-holdover FULL steps are existing implementation observations, not numbers stated by the user. Holdover variants already exist. No new numeric thresholds requested.

## 12. Capture completeness

Tracker ID, named reporter, assignee, epic, sprint, affected account/ticket, deployed versions and handling of historical transitions are not supplied. The requested normal-assignment behavior is explicit. Edge questions are recorded in spec.md §12; none prevents a complete review and proposed plan.
