# Slot-driven ticket access — review and proposed plan

Reviewed 2026-10-22. Planning only; application code, database, repository branches and external systems were not changed.

## Conclusion

The requested rule is **assignment slot first**. An employee's main role does not decide ticket ownership, editability, checklist eligibility, or step list when a valid assignment slot exists.

The current implementation already applies this in the main step resolver and crew planner, but it is **not consistent end to end**. Mobile still uses the employee profile in labor editing, offline preparation and some checklist signer selection. The current 3rd Man own-inspections flow also differs from the requested behavior.

The reported read-only card has **not been reproduced against the affected account**. In the inspected code a read-only card comes from `employees[].isPrimary`, not from the logged-in role or `stepFlow`. A bad roster, mismatched slot-role settings, stale assignment/draft, or a different deployed version must be distinguished before calling one of them the root cause.

## Required behavior

Within one job day/sub-job, set and shift:

| Assignment slot | Person's main role | Editable? | Ticket steps | Ticket relationship |
| --- | --- | --- | --- | --- |
| Oiler | Operator, Oiler, or another eligible employee | Yes, as primary | FULL, including checklists, JSA, customer signatures, compliance and labor; applicable holdover variant | Owns the crew ticket |
| Operator, with an Oiler slot in that crew | Any eligible employee | No | Status/read-only card; no independent completion actions | Secondary on the Oiler-slot ticket |
| Operator, with no Oiler slot in that crew | Any eligible employee | Yes, as primary | FULL; applicable holdover variant | Owns its ticket |
| Rigger / 3rd Man / Apprentice / any other employee slot | Including someone whose main role is Oiler or Operator | Yes, on its own ticket, subject to normal status/window restrictions | STANDARD; no checklists/JSA/compliance/labor extras | Own ticket; not absorbed into the Oiler/Operator pair |

STANDARD currently retains the initial and final customer signatures. The request removes checklist/full-flow extras from other slots; it does not explicitly remove those two signatures. Preserve them.

FULL describes a workflow, not permanent edit permission. Completed tickets, payroll locks, completion windows, send-backs and reassignment still apply.

## Review evidence

All paths below are relative to `/home/codingcops/craneguys-platform`. Line references are from local HEAD `7fe8b58809fc5379eb75b480885a191fdc68cca4`, branch `feat/mobile-labor-craft-modifier-oiler-only-and-autopopulate`. The working tree was clean when inspected. This is a local checkout review, not confirmation of production/staging/mobile build parity.

| Finding | Evidence | Assessment |
| --- | --- | --- |
| Crew ownership already prefers the assignment slot | `apps/api/src/usecase/job-tickets/job-tickets.service.ts:176–205`, `crew-roster.ts:51–79` | Verified by static inspection. Slot role's dispatchable `boomPay` classifies the crew seat; employee role is a fallback only when slot role is absent. Oiler seat anchors and Operator seat is absorbed. Do not replace this with a logged-in-role check. |
| Read-only follows roster primary status | API `job-tickets.service.ts:1742–1767`; mobile `data/ticket-crew.ts:21–39`, `components/field/ticket-card.tsx:610–617`, `app/(field)/ticket/index.tsx:199–221`, `features/field-ticket/flow/ticket-step-screen.tsx:240–260` | Verified statically. A FULL flow alone cannot make a secondary member editable. The affected payload/roster needs inspection. |
| Main step display already prefers API flow | `apps/mobile/data/compose-ticket-detail.ts:73–90`; API `usecase/field-tickets/field-ticket.mapper.ts:294–300` | Verified statically. The API derives viewer flow from slot role settings; profile is a no-slot fallback. Existing tests cover profile/flow mismatches. |
| Labor still checks the logged-in profile | `apps/mobile/features/field-ticket/flow/ticket-step-screen.tsx:542,1501`; `steps/labor/LaborBody.tsx:663` | Confirmed defect path. An Operator-profile primary on an Oiler slot can reach FULL but still have the Oiler labor card disabled. The same expression also requires an Oiler crew card, so a solo Operator FULL ticket has no editable card under that expression. These labor gates do not themselves explain the overview's read-only card. |
| Offline warmup still checks profile | `apps/mobile/app/(field)/field.tsx:78–108` | Confirmed defect path. Operator-on-Oiler can miss checklist/labor cache preparation; a main Oiler on a STANDARD slot can prepare unnecessary data. |
| Checklist signer chooses an Oiler label before primary | `apps/mobile/features/field-ticket/steps/shared/checklist/ChecklistBody.tsx:73–92`, `ChecklistEngine.tsx:628–646`, `checklist-submission.ts:16–37` | Verified heuristic; incorrect signer under swapped assignments is inferred from the data flow. API `field-ticket.mapper.ts:333–337` emits main-role labels. The acting primary should determine the signer. |
| Legacy offline verification can fall back to profile | `apps/mobile/features/field-ticket/sync/background-sync.ts:334–346` | Confirmed fallback path. When a draft has no flow, verification ignores the current server ticket's resolved flow. Stale drafts with an old flow also need assignment freshness handling. |
| Non-Oiler slots can receive checklist steps today | `packages/shared/src/constants/ticket-flow-steps.ts:96–113,173–200`; `apps/api/src/utility/seed-data.ts:321–325` | Confirmed mismatch with this request. Seeded 3rd Man/Driver runs-inspections settings expand STANDARD to 12 steps. This came from TCG-237 Q47–Q49's earlier developer working assumption. |
| Viewer slot lookup is not anchored first | `apps/api/src/usecase/job-tickets/ticket-step-flow.ts:56–70` | Confirmed ambiguous lookup. First allocation matching employee wins even if that employee has multiple sets/shifts on the sub-job. The later same-set fallback repeats a failed employee match and cannot correct a wrong first match. Actual wrong-flow occurrence depends on allocation data. |
| Different readers have different crew context | Mobile viewer resolver reads same-set/shift roles; API `job-tickets.service.ts:1134–1136,1492–1495` and web progress `job-progress.service.ts:128–140` resolve from anchor slot without set neighbors | Confirmed implementation difference. Normally harmless with correctly anchored shared tickets, but breaks that assumption for preserved standalone Operator tickets when an Oiler joins later. Keep this transition explicit. |
| Existing history is deliberately protected | `crew-roster.ts:37–46,73–74`; `job-tickets.service.ts:1900–1965` | Started/completed Operator tickets are not automatically absorbed. Roster sync does not replace an existing primary merely because the allocation now names another employee. Never bulk rewrite these records as a side effect of fixing rendering. |

## Proposed execution

Use working identifier `SLOT-DRIVEN-TICKET-ACCESS`; no tracker ID was supplied. This is a Path A **planning package** because the request also changes the earlier own-inspections policy. The reported incorrect read-only card is a bug investigation within that scope. No construction or sign-off is implied by this review.

1. **Trace the reported case before changing ownership logic.** Capture deployed API/mobile versions, tenant, ticket/allocation IDs, job day, set, shift, slot role settings, current roster primary, and the mobile ticket payload. Inspect ensure/send/reassign history and whether the device is using an old draft. Expected primary is the employee occupying the Oiler slot, even when their main role is Operator. If the payload is correct, inspect local state/build parity; if wrong, fix the demonstrated source.
2. **U1 — make cross-role crew tickets work end to end.** Anchor slot lookup to the ticket's crew, reconcile valid new/open assignments through existing lifecycle paths, keep server primary authorization, and replace profile-based labor/prefetch/signer/verification decisions with resolved assignment policy. Operator-slot employee remains secondary when paired. Preserve one shared ticket and separate employee labor/payroll rows. Fix the Oiler-slot primary input and solo-Operator primary input; retain current paired-Operator auto-population rather than unlocking all crew cards.
3. **U2 — make other assigned slots use STANDARD consistently.** Apply the requested no-checklist rule to assigned Rigger, 3rd Man, Apprentice and other employee slots, including main Oilers/Operators assigned there. Align API submit requirements, mobile screens, offline preparation/verification and office progress in the same unit. Do not remove their customer signatures. Keep unrelated standalone inspection features separate.
4. **Review existing affected records separately.** Produce a read-only exception report. Historical ticket/roster repair or transfer of started work requires an explicit policy and a guarded repair plan; do not include a silent data rewrite in U1/U2.

## Verification and rollout

No new tests requested; no test cases were added. This review used source inspection and existing test inspection only. No lint/build/test suite or live mobile session was run; there is no measured green baseline.

Before construction, establish the required lint/typecheck/build/existing-test baseline on the intended base revision through `pnpm nx`. Run existing crew-roster, slot-flow, mapper, authorization, submit-guard, mobile composition/crew/card/labor/sync and office-progress suites after each affected unit. Build `@tcg/shared` before consumers; consumers use its `dist` output. Existing tests encoding 12-step own-inspections behavior will need an explicit policy-change review; the repository currently requires developer authorization for new test cases.

Manual acceptance must include both swapped profiles, solo Operator, Rigger/3rd Man/Apprentice, identical employee on distinct shifts/sets, cross-set Oiler isolation, offline cold start, reconnect, reassignment and direct secondary write attempts. Inspect one shared payroll source ticket with separate employee labor records; do not change pay rates or pricing formulas.

Keep API response compatibility where possible (`employees[].isPrimary`, `stepFlow`, `ownInspections`). If a new field is needed, run the AI DLC contract tracer and update all callers in that unit. Coordinate the API policy and mobile release: an installed old app may keep its old checklist/labor/profile behavior. Do not assume an additive API field hotfixes an installed app.

See `intent.md`, `spec.md`, `units.md`, and `state.md` for the AI DLC artifacts. They are staged in this chat's outputs directory, not installed or committed into the repository's `.ai` overlay.
