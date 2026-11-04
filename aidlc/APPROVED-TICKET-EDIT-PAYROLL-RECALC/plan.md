# Plan — APPROVED-TICKET-EDIT-PAYROLL-RECALC

## 1. Intent, sources and path

**User direction, verbatim:**

> So, we also need to do (submission queues recalculation for its pay week.) for **Completed ticket:** approval → edit → Save changes → close request
>
> Plan this change using AI DLC

**Outcome:** after a worker successfully finishes an approved edit to a COMPLETE ticket, payroll recalculation is requested for the pay week that prices that ticket. Approval by itself still opens an editing window; it does not calculate payroll.

**Path B**, per `GUIDE.md` §2: this repairs a missing trigger against an existing specified outcome. No external ticket was supplied; `APPROVED-TICKET-EDIT-PAYROLL-RECALC` is a working ID linked to `TICKET-FLOW-SLOTS-HOLDOVER` REQ-20/REQ-21. Path A spec/decomposition artifacts are intentionally skipped. `repro.md` supplies the deviation and source trace. No implementation is authorized by this planning request.

Source standing: the user's current request is the authority for the desired outcome. The parent specification and `vault/decisions/2026-10-15-late-and-incomplete-tickets.md` are supporting developer direction marked `[UNVERIFIED]` / `reference`. The general field-ops conflict stub remains unresolved; this fix does not decide among its three candidate FRDs/user-story sources. Payroll index caveats were consulted; no wage, overtime, union, earning or ADP rule changes are proposed.

## 2. Acceptance checks

| ID | Observable result | Basis |
| --- | --- | --- |
| AC1 | COMPLETE ticket + live SUBMITTED_EDIT approval + successful Save changes causes an enqueue attempt for the ticket's pricing pay week before request closure is acknowledged. | User direction; parent REQ-20; implementation ordering D2 below. |
| AC2 | The ticket remains COMPLETE; the existing request closes and the mobile saved state follows the successful completion response. | Existing approved-edit lifecycle, parent REQ-20/REQ-21. |
| AC3 | Approval alone, invalid/unauthorized completion, or completion without an eligible active request does not trigger this new calculation path. | Existing authorization/lifecycle boundaries; preserve current no-op/refusal behavior. |
| AC4 | An incomplete ticket finished under LATE_COMPLETION continues to queue through normal ticket submission. Finishing that request must not add a second trigger from this fix. | Existing submission behavior; explicit scope distinction in this conversation. |
| AC5 | Queue insertion failure does not report successful finalization or intentionally close the live request; the existing mobile error/retry path remains usable while its window is open. | Reliability decision D2; no new product permission or deadline. |
| AC6 | Week selection, queue coalescing, missing-period handling and settled-period policy come from existing payroll services, with no new calculation formula or automatic reopening. | Reuse decision D3; existing payroll boundaries. |

## 3. One independent implementation task / one PR

**Reviewable behavior:** a worker edits a previously completed ticket, taps the existing Save changes action, and payroll's current queue processes the affected week after finalization.

### API orchestration

1. Extend `TicketEditRequestsService.completeForWorker`; keep its primary-worker ownership check, requester check, approved-state check and four-hour lifetime check.
2. Retain the resolved ticket so the new branch can require both `ticket.status === COMPLETE` and `request.kind === SUBMITTED_EDIT`. No recalculation from the generic `expire` helper: lazy expiry and cron use that helper too.
3. Before queueing/finalizing the eligible submitted edit, reuse `TicketEditRequestsRepository.findTicketPayrollLock` to refuse a ticket whose payroll has settled since approval. Use the existing `TICKET_PAYROLL_LOCKED` conflict; do not reopen a period or clear employee approvals.
4. Reuse `PayrollCalcEnqueueService.enqueueForTicket(tenantCompanyId, ticketId, TICKET_COMPLETE)`. Await the enqueue operation before closing the request; do not calculate synchronously in the HTTP handler and do not copy week-resolution logic.
5. After enqueue succeeds (or returns the existing documented no-period/settled-period no-op), use the existing conditional expiry/closure and audit behavior. Preserve HTTP 204 and the current request status representation.
6. Let enqueue exceptions reach the existing save-error path; do not log-and-swallow them followed by successful closure. Actual worker failures after enqueue continue through the current queue retry/failure/approval-hold machinery.
7. Register the enqueue service and `PayrollCalculationQueueRepository` as bare providers in `TicketEditRequestsModule`, following `JobTicketsModule`. Do not import all of `PayrollModule`, whose dependency graph can cycle through ticket/return modules.
8. Update public JSDoc/controller descriptions to state that successful submitted-edit completion requests payroll recalculation. No new endpoint, DTO, response field, status, migration, trigger enum or dependency.

### Mobile integration

Keep the existing order: `drainTicket` → `completeEditRequest` → cache invalidation/saved state. The existing completion request now owns the enqueue operation server-side, so no extra client submit call is needed. Refresh comments describing completion so they no longer imply that it only closes the request. Preserve offline refusal, session checks and the per-ticket synchronization lock.

### Verification and review

- Run the existing relevant API suites: ticket-edit-request service; submitted-ticket resubmission; pay-week enqueue service; calculation queue repository; existing request-expiry coverage. Adapt constructor fixtures as required without adding test cases.
- Run existing mobile approved-edit wiring coverage; inspect the Save changes handler and its error path manually. Existing wiring tests do not fully exercise the save-to-payroll integration, so the runtime reproduction is required.
- Run affected API/mobile lint and mobile typecheck through `pnpm nx`; build the API. Boot the API once because a provider constructor/module changes. Use `lint-triage` if a gate fails.
- Have an independent `tcg-analyst` validate the Path B reproduction and acceptance checks; review sibling/ripple outcomes below. Construction and analysis have not run in this planning task.
- **New tests: not requested.** No new test files or cases are planned, per the standing repository instruction.

## 4. AI decisions

These are proposed implementation choices, not approvals attributed to the developer.

| ID | Choice | Reason / alternative considered |
| --- | --- | --- |
| D1 | Put the trigger in API edit-request completion. | This is the existing Save changes boundary and covers every caller of that endpoint. An extra mobile submit call would split finalization across two HTTP operations and leave other clients dependent on the same wiring. |
| D2 | Await enqueue before closure; propagate insertion errors. | Closing first can lose the trigger when enqueue fails and a retry sees no active request. Reusing first-submit's fire-and-forget behavior would preserve that failure mode. This waits for queue persistence, not payroll calculation. |
| D3 | Reuse `enqueueForTicket`, existing TICKET_COMPLETE trigger and existing queue. | Preserves actual-start pay-week selection, tenant isolation, pending-job coalescing and processing-job follow-ups. No new event enum or scheduler needed. |
| D4 | Recheck the existing payroll lock during finalization. | Approval and Save changes can occur hours apart. Prevent this finalization action from intentionally overriding an intervening settlement. It is not a retroactive repair of edits already saved before finalization. |
| D5 | Preserve first-submit, approved-resubmit and LATE_COMPLETION paths. | They already enqueue. Only the missing completed-edit finalization branch gets the new trigger. A shared extraction across those paths is unnecessary for this fix. |
| D6 | Keep existing audit/notification behavior. | The requested fix is payroll recalculation. Adding edit notifications, new audit actions or a new completed-request status would expand the task. |

## 5. Siblings and ripple

| Existing consumer/path | Treatment and validation |
| --- | --- |
| Mobile Save changes / `services.tickets.completeEditRequest` | Same endpoint and response; gains server enqueue before success. Verify drain failure prevents completion, and completion failure prevents saved state. |
| Direct calls to edit-request completion | Same new behavior for valid COMPLETE/SUBMITTED_EDIT finalization, independent of mobile version. Ownership and request checks remain authoritative. |
| First submit after LATE_COMPLETION approval | Keep the existing normal-submit enqueue; no enqueue in the new completion branch for this kind. |
| COMPLETE ticket resubmitted through `/submit` | Keep existing enqueue and notification behavior. If a caller uses both paths while an approval is live, pending queue triggers may coalesce; do not claim exactly-once calculation. |
| Cron/lazy expiry and request-list reads | No enqueue. Do not add side effects to `expire`, `markExpired` or the scheduler. |
| Existing payroll queue and worker | Consume the existing trigger. Confirm a PENDING job absorbs it, and a PROCESSING job receives a PENDING follow-up. |
| Existing service test constructors and Nest DI | Update fixture wiring only; run existing suites and boot the API. |

No schema or external contract change is planned; no new tenant model or access shape is introduced. Keep tenant IDs explicit on reused service calls. If implementation changes schema or a response shape after all, run the corresponding Prisma guardian/contract-tracer review before expanding this plan.

## 6. Manual acceptance matrix

| Scenario | Expected observation |
| --- | --- |
| Valid submitted edit, existing unsettled period | Changed values stored; pay-week job inserted/folded before closure is acknowledged; ticket remains COMPLETE; request closes; subsequent worker run uses edited values. |
| Scheduled date differs from actual Start Ticket week | Existing enqueue helper targets the actual-start pricing week, including existing cut-over rules. |
| No payroll period yet | Preserve existing no-period log/no-op. Opening the week later queues PERIOD_OPENED and includes the edited COMPLETE ticket. No period is created by this fix. |
| Pending/processing calculation already exists | Pending job updated or processing job gets pending follow-up; no concurrent calculation for one period. |
| Queue insertion throws | Save shows an error; closure is not attempted after that failure; retry remains possible while approval is live. |
| Closure fails after enqueue / lost response / repeat save | Existing saved edits remain; retry is safe through queue coalescing and conditional closure. A later extra recalculation is possible; never promise distributed exactly-once behavior. |
| Approval expired, wrong requester, non-primary, wrong tenant | No new enqueue; existing authorization/no-op/refusal rules apply. |
| Payroll settles between approval and finalization | Existing payroll-lock conflict from finalization; no automatic reopening or clearing of approvals. Concurrent settlement still belongs to existing queue/worker guards. |
| Incomplete late ticket finishes and submits | Existing submission enqueue still works; no second trigger from request completion. |
| Offline or step drain fails | No successful completion request; queued edits remain local and the existing reconnect/retry behavior applies. |
| Approval or automatic four-hour expiry only | No trigger from this change. |

## 7. Boundaries, risks and execution handoff

- In scope: the new enqueue side effect of successful COMPLETE/SUBMITTED_EDIT request completion, its DI wiring, comments and existing-fixture compatibility.
- Out of scope: pay formulas, deadlines, inspection policies, approver provisioning, invoice/ADP reapproval, universal audit history, new notifications, expired-window recovery, and recalculation on every individual step write.
- Existing limitation: `enqueueForTicket` resolves current ticket placement. Moving a ticket from one pay week into another may require invalidating the former week too; this plan does not invent a cross-week amendment policy or claim this existing limitation is solved.
- Existing limitation: edits are saved before finalization. Rechecking a settled week at finalization does not undo earlier writes or globally close the approval-versus-settlement race. The queue's existing worker guards remain in effect.
- Enqueue and closure are separate database operations. Ordering them enqueue-first avoids closing before an insertion error, but provides at-least-once scheduling rather than atomic exactly-once finalization. No outbox/new schema is proposed.
- A four-hour window can expire while a failed save is being retried. Preserve the existing expiry behavior; automatic recovery or queueing on expiry is outside this request.
- Validation has not run. Earlier audit attempts encountered package-manager startup/lockfile compatibility problems; resolve or report the actual environment blocker before claiming validation, without changing unrelated dependencies.
- No code changes, runtime reproduction, test execution, branch, commit, push or PR in this planning task. On construction, use one `codex/` fix branch and one PR, append Path B to `processed.log` at branch creation, record these decisions/siblings in the PR, and run independent analysis. Do not alter the existing overlay branch or tooling files as part of planning.

**Open product questions blocking this scoped fix:** none. Implementation and reliability choices above are explicit and reviewable; adjacent unresolved business rules stay outside this task.
