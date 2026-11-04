# Spec — SLOT-DRIVEN-TICKET-ACCESS

Construction authorized by the requesting user on 2026-10-22: "start the implementation using AI DLC". U1 begins with existing §12 boundary exclusions. Original review snapshot is retained below; construction base is fetched origin/main fc1ef4b17.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | No external ticket supplied; named working folder SLOT-DRIVEN-TICKET-ACCESS |
| Intent | intent.md, captured 2026-10-22 |
| Elaborated on | 2026-10-22 |
| Reviewed source revision | Local HEAD 7fe8b58809fc5379eb75b480885a191fdc68cca4; deployed parity unknown |
| Vault state | Root index routing and field-ops conflict stub consulted; no global source counts remeasured |
| Open questions | Three boundary cases in §12; normal valid, populated assignments have explicit direction |
| Existing behavior reached | Seven consumer groups in §11a |
| Rules consulted | AGENTS.md; AI DLC GUIDE; api.md, mobile.md, web.md, patterns.md; intent/spec/units/state templates |

Source identifiers:

- **USER:** This chat request, captured in intent.md §3. `[VERIFIED]` means the user explicitly requested it in this session; it does not claim TCG client ratification of older vault sources.
- **SLOT:** `.ai/vault/decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md`, D1–D5 and D10, `status: reference`, developer direction `[UNVERIFIED]` as a vault source. Describes slot-first FULL/STANDARD and crew context.
- **CREW:** `.ai/vault/decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md`, `status: verified`, and the companion crew-ticket-shape decision. One Oiler/Operator crew ticket; separate employee labor/payroll records.
- **PRIOR:** `.ai/aidlc/TCG-237/spec.md` Q47–Q49, developer working assumptions of 2026-10-20. Adds own inspections for 3rd Man/Driver. USER now explicitly asks for no checklist extras on other assigned slots; this draft adopts that current instruction for assigned tickets and records the policy change rather than presenting the old behavior as a bug with no history.
- **CONFLICT-STUB:** `.ai/vault/field-ops/field-ops-mobile-INDEX.md`. The three legacy FRD/user-story sources remain mutually unadjudicated. This plan does not choose between them; the behavior here comes from USER and CREW.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Source | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Known assignment slot governs ticket policy | api, shared, mobile, web | [VERIFIED] | USER | No, within valid populated assignments |
| REQ-02 | Oiler-slot occupant owns full crew workflow | api, mobile | [VERIFIED] | USER | No, for normal new/open assignment lifecycle |
| REQ-03 | Operator primary only without Oiler in crew | api, shared, mobile, web | [VERIFIED] | USER | No; historical/vacant cases limited by §12 |
| REQ-04 | Other assigned employee slots have STANDARD without checklist extras | api, shared, mobile, web | [VERIFIED] | USER | No; expressly changes PRIOR |
| REQ-05 | All ticket paths honor the same assignment policy | api, mobile, shared, web | [VERIFIED] | USER's ownership/steps rule | No, within current assignment lifecycle |
| REQ-06 | Retain shared ticket with separate employee labor/payroll records | api, mobile, payroll consumers | [VERIFIED] | USER and CREW | No; no historic rewrite included |

Counts: 6 requirements; 6 explicitly sourced, 0 unsourced core requirements. Three edge questions remain open and are excluded from executable scope, not silently answered.

## 2. Requirements

### REQ-01 — Known slot governs policy [VERIFIED]

- **Statement:** Resolve behavior from the occupied job slot and its crew, irrespective of the assignee's main role.
- **Surface:** API, shared, mobile, office progress.
- **Sources:** USER; SLOT is corroborating prior developer direction, not upgraded in status.
- **Conflict:** No unresolved conflict for this core direction. The unrelated legacy mobile document conflict remains at CONFLICT-STUB.
- **Open question:** §12 Q2 for vacant slots; Q3 for missing/unresolvable slot data.
- **Ripple:** Crew planner, viewer mapper, submit guard, labor access, progress and mobile consumers in §11a.
- **Acceptance:** Swapping main roles between an Oiler and Operator slot leaves ticket permissions and steps attached to the positions. An Oiler-profile person in a Rigger slot gets Rigger-slot behavior.
- **Edges:**
  - **Reached by:** Ticket creation/ensure, send, reassign, list/detail, direct step/deep link, submit, offline replay and progress reads.
  - **Does not apply when:** No valid slot can be resolved; do not silently redefine legacy behavior in this change.
  - **When an input is absent:** Record the missing-role/slot condition in diagnosis; Q3 covers the future policy. Preserve existing fallback for excluded legacy tickets pending that answer.
  - **Trust boundary:** Server resolves tenant, allocation, slot role and roster; client profile or a client-supplied FULL flag cannot grant write access.
  - **Read time:** Current assignment context for new/open tickets; historic transition policy is Q1.
  - **Matrix:** Slot assignee/profile change => policy follows slot after existing reassignment lifecycle; main-role label change alone => no override; reordering allocations => same result.
- **Notes for executor:** Reuse existing role/crew semantics. Resolve viewer within ticket anchor set/shift before choosing by employee ID. Do not introduce a global role-name check.

### REQ-02 — Oiler-slot occupant owns full workflow [VERIFIED]

- **Statement:** The person assigned to the Oiler slot is the primary and can complete all applicable FULL steps, including checklists, customer signatures and the existing crew labor workflow. The Oiler-slot input must be usable; paired Operator labor keeps its existing automatic handling. A solo Operator must be able to fill its own labor input.
- **Surface:** API, mobile.
- **Sources:** USER. CREW governs the one-ticket/two-employee structure.
- **Conflict:** None for clean assignments. Existing started/finished exceptions need Q1 rather than data loss.
- **Open question:** Q1 for existing contradictory historical records.
- **Ripple:** `toPlanAllocation`, `planCrewTickets`, roster creation/sync, mapper, mobile labor and inspector identity.
- **Acceptance:** With employee A (main Operator) in Oiler slot and B in Operator slot, A is primary, has FULL steps and can fill and submit; B sees the same ticket read-only and API denies B's direct writes.
- **Edges:**
  - **Reached by:** Initial ensure/send and a supported reassignment before work; overview, each step and labor write API.
  - **Does not apply when:** Actor is secondary, outside roster, outside tenant, or ticket is otherwise locked.
  - **When an input is absent:** Missing Oiler assignee belongs to Q2; no fabricated owner.
  - **Trust boundary:** Server `TicketEmployee.isPrimary` authorizes mutations; mobile mirrors it.
  - **Read time:** Current roster for valid open lifecycle; do not overwrite historical primary as a rendering fix.
  - **Matrix:** Main Operator -> Oiler slot: editable FULL; main Oiler -> Oiler slot: same; eligible other main role -> Oiler slot: same. Secondary has no write access in all cases.
- **Notes for executor:** Fix the main-role-derived labor gate and signer siblings; changing only stepFlow cannot repair roster permissions.

### REQ-03 — Operator depends on Oiler in same crew [VERIFIED]

- **Statement:** An Operator-slot assignee gets FULL and owns its ticket when no Oiler is in its crew; with an Oiler slot occupied in that crew it is secondary on the Oiler-slot ticket.
- **Surface:** API, shared, mobile, office progress.
- **Sources:** USER; existing crew scope from SLOT D2 is an explicit retained implementation boundary.
- **Conflict:** None for ordinary populated crews; Q1/Q2 reserve transitions and vacancy.
- **Open question:** Q1, Q2 only for those boundary cases.
- **Ripple:** Crew grouping, step resolver, read-only cards, direct-write authorization and step evidence.
- **Acceptance:** Oiler in another set or shift does not suppress this Operator's FULL workflow. Same-crew Oiler produces one ticket with Operator secondary. Two Operators without Oiler retain their existing separate FULL tickets, as prior SLOT D3 directs; no new lead-Operator selection.
- **Edges:**
  - **Reached by:** Ensure/send/reassign, list/detail, direct steps, submit and sync.
  - **Does not apply when:** Oiler belongs to another sub-job/day, set, shift or tenant; or person occupies another slot type.
  - **When an input is absent:** Explicitly missing Oiler allocation in a valid populated crew => solo Operator FULL; vacant configured Oiler is Q2.
  - **Trust boundary:** Crew existence comes from server assignment data.
  - **Read time:** Current crew for open assignments; preserved started standalone tickets are Q1.
  - **Matrix:** Add Oiler before starting work => existing crew planning lifecycle yields Oiler primary; remove/reassign occupied slots => existing supported lifecycle and fresh ticket state; post-start merging => Q1, not an implicit extension.
- **Notes for executor:** Avoid first-match lookup when one employee fills more than one shift/set. Retain tenant + sub-job + set + shift grouping.

### REQ-04 — Other assigned slots use plain STANDARD [VERIFIED]

- **Statement:** Rigger, 3rd Man, Apprentice and all other non-Oiler/non-Operator assigned employee slots use STANDARD without Pre-Trip, JSA, Post-Trip, Compliance, Start Work or Labor & Unit extras, even if the person is an Oiler or Operator.
- **Surface:** API, shared, mobile and office progress.
- **Sources:** USER, including "rest of all other employee type/role slot". This deliberately supersedes PRIOR's own-inspections working assumption for assigned tickets.
- **Conflict:** Earlier working assumption described above; resolved for this proposed scope by current explicit USER direction. This does not adjudicate unrelated field-ops FRDs or standalone inspections.
- **Open question:** None for known assigned slots; Q3 only for legacy slot-less tickets.
- **Ripple:** `hasOwnInspections` callers, submit evidence, mobile step builders/prefetch/verify and office progress.
- **Acceptance:** A normal assigned Rigger/3rd Man/Apprentice ticket shows the existing 8-step STANDARD workflow; ownInspections cannot add four steps. Main-role changes do not alter it. Existing sig1 and sig2 remain.
- **Edges:**
  - **Reached by:** Main route/deep links, step catalog, submit validation, background verification and progress.
  - **Does not apply when:** Oiler slot, solo Operator slot, or a separate standalone inspection workflow.
  - **When an input is absent:** Missing slot => Q3; no global deletion of runsInspections data.
  - **Trust boundary:** Slot-derived server policy controls required steps. Hiding UI cannot leave API submit requiring hidden checklist steps.
  - **Read time:** Consistent with resolved assignment and existing holdover day variant.
  - **Matrix:** Main Oiler/Operator in other slot => STANDARD; ownInspections=true role setting on that other slot => no ticket extras; customer signature steps => preserved.
- **Notes for executor:** Limit change to assigned ticket policy. Do not globally erase runsInspections or modify boom-pay/rate settings to hide steps.

### REQ-05 — One policy across ticket paths [VERIFIED]

- **Statement:** Role substitution must work through online screens, labor/checklist actions and ordinary offline ticket use without a profile-role gate reappearing.
- **Surface:** API, mobile, shared, web.
- **Sources:** USER's explicit complete/fillable ticket and assignment-slot step requirements; offline specifics below are recorded implementation choices, not new product timing rules.
- **Conflict:** None; existing offline capture/window policies remain in force.
- **Open question:** Q1 for queued writes spanning a historical ownership change.
- **Ripple:** §11a consumers; checklist signer has three sibling implementations.
- **Acceptance:** Primary Operator-on-Oiler can warm checklist/labor data online, open it offline, capture steps and sync under existing rules. Secondary cannot gain write access through deep link or queued payload. Checklist capture attributes the acting primary, not whichever roster main-role label says Oiler.
- **Edges:**
  - **Reached by:** Home prefetch, overview, step router, LaborBody, checklist body/engine/submission, store hydration and sync verification.
  - **Does not apply when:** Ownership was revoked; status/window permits no write; offline attachments/operations fail their normal checks.
  - **When an input is absent:** Draft with no flow uses a matching current server ticket before legacy fallback; no matching resolved server context remains within Q3.
  - **Trust boundary:** Offline state never bypasses server roster/window authorization. Reassignment does not authorize replay against an obsolete ticket.
  - **Read time:** Use matching ticket/allocation context. Refresh policy on sync; do not silently delete queued captured work.
  - **Matrix:** Online -> offline -> reconnect: same policy for same assignment; stale different assignment: refresh/deny via existing lifecycle, no auto-transfer of captured records; main-role rename: no effect.
- **Notes for executor:** Prefer server-resolved values and explicit primary identity; retain legacy fallback only at its documented boundary.

### REQ-06 — Preserve shared payroll source [VERIFIED]

- **Statement:** The paired Oiler/Operator crew uses one JobTicket, with each employee's labor and payroll attribution retained separately even when their main roles differ from the slots.
- **Surface:** API, mobile labor and existing payroll consumers.
- **Sources:** USER's single-ticket payroll description; CREW verified decisions.
- **Conflict:** None. Changes to rates/pricing are outside this request.
- **Open question:** Q1 for repair of existing duplicate or submitted records.
- **Ripple:** TicketEmployee roster/labor, crew labor cards, payroll input/job-day consumers and office progress.
- **Acceptance:** Both employees reference the same ticket; both retain distinct labor records; authorized primary can complete the required labor step, preserving paired-Operator auto-population and solo-Operator input; secondary cannot submit an independent duplicate. No pay formula/rate changes.
- **Edges:**
  - **Reached by:** Ticket creation, reassignment, crew labor save and existing payroll preparation.
  - **Does not apply when:** Other employee slots that already have their own tickets; vendor crews outside the current pairing rules.
  - **When an input is absent:** Missing member cannot manufacture an employee/payroll row; inspect existing lifecycle rather than invent a pay rule.
  - **Trust boundary:** Tenant and employee roster membership govern labor targets.
  - **Read time:** Ticket employee records remain the payroll source; historic changes require Q1.
  - **Matrix:** Paired employees swapped main roles => same shared-ticket structure; other employee slots => independent; historical merge => deferred Q1.
- **Notes for executor:** Retain `ticket_employees` design and existing payroll consumers. If implementation reaches an actual pay rule, follow AGENTS G4 and payroll provenance before changing it.

## 3. Data model — apps/api/prisma/schema.prisma

- **Schema change required:** No new schema proposed.
- **Migration required:** No schema migration currently proposed.
- **Data backfill required:** No automatic backfill in U1/U2. Candidate repair is Q1 and G2.
- **Existing models considered:** DepartmentRole (:4240) already has crew/inspection settings; JobResource (:3455) carries roleId; JobResourceAllocation (:3777) carries employee/set/shift; JobTicket (:4504) anchors allocation; TicketEmployee (:4600) carries primary membership and per-employee labor. Reuse these.
- **New entities/code prefixes:** None. Existing UUID relations and business ticket codes remain.
- **Child relations:** No FK/onDelete change proposed.
- **Fields whose precision/type is unspecified:** N/A; no new stored values proposed.

## 4. API surface — apps/api

- **Pattern:** None of CRUD/reference patterns P1/P2 applies; reuse existing ticket lifecycle and guards.
- **Existing functions to reuse:** toPlanAllocation, planCrewTickets, rosterFor, syncTicketRosters, getTicketForEmployeeAction, resolveStepFlowForViewer, resolveTicketStepFlow, findSubmitEvidence and existing labor target resolution.
- **New exported services:** None committed in this draft. A small reusable internal policy helper is proposed only if it replaces divergent resolution rather than adding a parallel source of truth; record final choice in §11b.
- **Routes:** Existing field-ticket list/detail/step/checklist/signature/labor/submit routes; no new endpoint proposed. Capture actual route manifest from the controllers during implementation rather than introducing guessed URLs here.
- **Request DTO / response shape:** Prefer unchanged requests and existing `employees[].isPrimary`, `stepFlow`, `ownInspections`. Do not rename roster main-role label silently.
- **Guards/roles:** Retain existing session/module permissions, tenant scope, roster primary and write-window enforcement.
- **Route identity:** Existing ticket identifiers/codes; no new identifier mapping.
- **Errors/pagination:** Retain existing behavior; no new limits or error contract specified.
- **Module registration/DI:** No new provider dependency proposed. A constructor change requires enumerating every supplying module.

## 5. Web surface — apps/web

Existing ticket/progress views consume the same step list and primary display. Reuse existing components; no new route, form, table or visual design proposed. Preserve data-testid contracts. Review any ownInspections/shared helper change across office-progress rendering in U2.

## 6. Mobile surface — apps/mobile

Screens: existing field Home/Jobs, ticket overview, ticket step router and labor/checklist views. Reuse ticket cards and current step bodies. No new component required. Touch targets unchanged. Push/notification delivery architecture unchanged; verify reassignment notices identify the actual assigned position. Offline: replace profile-only warmup and verification decisions; hydrate resolved policy from matching server ticket and retain server authorization at replay. No new grace period or operation-transfer behavior.

## 7. Shared package — packages/shared

Reuse TicketStepFlow FULL/STANDARD. Assigned non-primary read-only remains represented by membership, not a third flow enum. Resolve assigned other slots with no own-inspections extras; preserve standalone/no-slot APIs until Q3. Rebuild dist before checking both web and mobile.

## 8. Permissions and tenancy

Eligible employee assigned Oiler slot: primary FULL. Operator slot: primary FULL only without Oiler in crew; otherwise secondary. Other slots: primary STANDARD on own ticket. Main role never elevates a known slot. Existing status locks still apply. No cross-tenant reads/writes. Tenant-wide data audits/repairs must follow Prisma guardian and G2 safeguards if later undertaken.

## 9. Validation rules

Known crew context and server roster identity must agree. Secondary direct writes remain forbidden. API submit requires exactly the steps the resolved policy exposes. No invented numeric, text-length, date, pay or eligibility validations.

## 10. Tests

New tests: **not requested**. No cases added and no suites run during this static review. Existing tests to run and manual acceptance cases appear in units.md. Establish actual baseline before construction; do not mark gates green from documentation. Existing assertions encoding the superseded own-inspections rule need explicit review; obtain test-update authorization if required by repository policy.

## 11. Non-functional

Performance: resolve crew in batched selects; avoid per-ticket lookups when mapping lists. Concurrency: preserve existing transaction/idempotency rules. Audit: retain existing reassignment/status activity logs; diagnose before data repair. Rollout: preserve contracts, deploy coordinated API/mobile changes, verify installed build behavior and existing drafts. No mass data transformation or new dependency is proposed.

## 11a. Ripple — existing consumers

Enumeration used `rg -n 'isPrimary|stepFlow|ownInspections|resolveTicketStepFlow|isOiler|slotRole'` across API/mobile/shared and job-progress, plus `rg --files apps/mobile` to locate existing suites.

| Consumer | Reached via | Req | Intended result/source |
| --- | --- | --- | --- |
| ensure/send/reassign/roster sync | Allocation seat and primary | 1–3,6 | User's Oiler-slot ownership; retain history boundary Q1 |
| API field mapper and roster DTO | Viewer allocation and isPrimary | 1–3,5 | Slot-resolved policy; matching set/shift; USER |
| API submit/milestone/labor/checklist guards | Resolved flow and primary | 1–6 | Enforce same policy; USER and CREW |
| Mobile composition/cards/router/labor | stepFlow, primary, profile fallback | 1–5 | Remove main-role override for known slots; USER |
| Checklist body/engine/submission | Inspector identity | 2,5 | Acting primary fills/signs; USER |
| Mobile warmup/store/background verification | Flow and policy freshness | 1,4,5 | Same slot-based policy through ordinary offline lifecycle; USER |
| Office progress / payroll inputs | Shared flow + employee roster | 1,3,4,6 | Reflect assigned steps and preserve shared ticket/separate employee records; USER/CREW |

Historical exceptions are not declared unchanged forever; they are explicitly deferred in Q1.

## 11b. AI decisions — for developer review

| ID | Decision | Chosen | Why / alternatives | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | How to recognize assigned crew positions | Reuse existing slot-role crew classification (dispatchable boomPay OILER/OPERATOR), reconcile flow resolution against those positions; no role-name or logged-in-profile checks | Current crew planner already uses this classification. Audit inspection-order/crew-setting disagreement first. Do not modify any pay value or rate to change permissions. Arbitrary inspection rank must not grant FULL to a different slot type. | Review structural choice; no data rewrite approved | Pending | 2026-10-22 |
| D2 | How to send policy | Keep primary + FULL/STANDARD + ownInspections contracts | Current mobile already parses them; a new enum breaks installed clients. Known assigned non-Oiler slots must not gain ownInspections extras. | No, unless contract changes become necessary | Pending | 2026-10-22 |
| D3 | Viewer allocation lookup | Anchor ID first; otherwise same set/shift/sub-job plus employee, before legacy fallback | Current employee-first find is ambiguous across multiple assignments. | No | Pending | 2026-10-22 |
| D4 | Checklist signer | Select actual acting primary/authorized inspector instead of employee role text | Three sibling heuristics can select the wrong employee on swapped profiles. Avoid repurposing main-role label data. | No | Pending | 2026-10-22 |
| D5 | Data repair | Read-only exception inventory before any repair | Existing started/complete tickets are protected; bulk recomputation can alter payroll sources. | G2 if repair later proposed | Pending | 2026-10-22 |
| D6 | Offline freshness | Match ticket/allocation and prefer current server policy when draft lacks it; do not transfer/delete queued work | Existing outbox authorization remains authoritative on replay. New historical transfer behavior is Q1. | No within existing lifecycle | Pending | 2026-10-22 |

## 11c. Siblings

| Sibling | Same change? | Unit | Enumerated by |
| --- | --- | --- | --- |
| ChecklistBody, ChecklistEngine, checklist-submission | Yes, primary signer identity | U1 | rg 'oiler' apps/mobile/features/field-ticket/steps/shared/checklist |
| Home prefetch, route, LaborBody, background-sync | Yes, replace profile-only eligibility | U1 | rg 'isOiler|craneInspectionOrder|stepFlow' apps/mobile |
| API submit, mobile step catalog/verification, office progress | Yes, assigned STANDARD/no-checklist policy | U2 | rg 'hasOwnInspections|ownInspections|resolveTicketStepFlow' apps packages |
| Payroll calculation engine | No pay-rule change; verify input identity only | U1/U2 regression | Existing roster/labor consumer search |

## 12. Open questions — boundary cases

These do not reopen the user's clear rules for ordinary valid populated assignments.

### Q1 — Existing started/submitted tickets and captured work

- **Question:** If an Operator has already started or completed its own ticket before an Oiler joins or ownership changes, should its work stay on that ticket or be transferred?
- **Options:** A. Preserve existing started/submitted ticket; apply new policy through the next supported assignment lifecycle. B. Reconcile affected open tickets, with a separate policy for transferring captured work. X. Other — say what.
- **Answer:** Not supplied.
- **Why unresolved:** Current planner excludes IN_PROGRESS/COMPLETE from absorption; prior SCRUM-CREW-TICKET §12 Q7 and TICKET-FLOW-SLOTS-HOLDOVER transition questions already record this edge. USER defines the normal ownership rule without specifying historical transfer.
- **Blocked:** Historical repair/retroactive merging only; not clean new-ticket flow U1/U2.
- **Candidates:** CREW; `.ai/aidlc/SCRUM-CREW-TICKET/spec.md` Q7; existing crew planner/sync (observations only).
- **Owner:** Requesting developer/product owner.
- **Workaround:** None newly implemented. Existing history preservation remains outside this plan's changed scope.
- **Status:** open.

### Q2 — Configured but unfilled Oiler slot

- **Question:** Does an empty Oiler position block the assigned Operator's FULL ticket?
- **Options:** A. Only an occupied Oiler allocation counts; Operator fills FULL while Oiler is empty. B. Configured Oiler slot counts even when empty. X. Other — say what.
- **Answer:** Not supplied for vacancy.
- **Why unresolved:** USER says "Oiler type slot in the set"; SLOT D2 currently reads employee allocations, not every configured empty position. Both statements agree for populated crews.
- **Blocked:** Changed vacancy semantics only.
- **Candidates:** SLOT D1/D2; current mobileTicketSelect's employee-allocation filter.
- **Owner:** Requesting developer/product owner.
- **Workaround:** Preserve existing occupied-allocation behavior for the excluded vacancy case; do not silently broaden crew queries.
- **Status:** open.

### Q3 — Missing slot/role on a legacy ticket

- **Question:** Should legacy tickets without a resolvable assignment slot retain their profile fallback or require dispatch to correct the assignment before filling?
- **Options:** A. Keep existing profile fallback only for those legacy tickets. B. Require assignment correction before filling. X. Other — say what.
- **Answer:** Not supplied.
- **Why unresolved:** USER defines assigned-slot behavior; existing resolver intentionally falls back when slot role is absent.
- **Blocked:** Changing legacy missing-slot behavior only.
- **Candidates:** SLOT spec REQ-01 no-slot acceptance; TCG-237 Q48/Q49; current shared fallback.
- **Owner:** Requesting developer/product owner.
- **Workaround:** Preserve existing fallback in this excluded case; never use it to override a known slot.
- **Status:** open.

## 13. Deliberately not specified

Historical data transfer/repair, new behavior for vacant Oiler slots and legacy missing-slot records, standalone inspection workflows, employee assignment eligibility, pay rates/formulas, notification-channel redesign and custom role-configuration administration are not redesigned here. No full-project gate baseline has been measured.

## 14. Sign-off before build

- [x] Core normal-assignment requirements traced to current user instruction.
- [x] Earlier own-inspections working assumption called out explicitly.
- [x] Boundary questions recorded without inventing historical/vacancy/legacy behavior.
- [x] Draft vertical units and ripple checks recorded in units.md.
- [ ] Developer reviews scope, §11b decisions and boundary exclusions.
- [ ] Measure gates on intended construction base and record deployed reproduction.
- [ ] Approve executable units; no implementation has begun.

Answered by: Pending. Date: Pending.

## Construction authorization and base delta — 2026-10-22

The current user authorized implementation of this plan. AI DLC executes U1 first and stops after its review. Current origin/main does not include commit 7fe8b5880 from the primary checkout. On main, LaborStepBody ignores isOiler and LaborBody has no profile-dependent Oiler-only editable-card gate. Do not copy that unrelated unmerged feature into U1. Replace the profile-derived flow passed by the router with the resolved ticket flow so integration with that branch will not reintroduce the restriction. Preserve main's existing labor behavior and document the compatibility point. No live data repair or changes to Q1–Q3 behavior are authorized.
