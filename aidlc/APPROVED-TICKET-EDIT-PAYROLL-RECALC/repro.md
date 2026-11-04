# Reproduction — APPROVED-TICKET-EDIT-PAYROLL-RECALC

## Classification and evidence

- AI-DLC Path B: missing recalculation after completing an authorized edit to an already-COMPLETE ticket.
- Working ID only; no external ticket supplied. Parent: `TICKET-FLOW-SLOTS-HOLDOVER`, REQ-20/REQ-21.
- Client checkout inspected: `main`, `86359f88e`, 2026-10-22. Overlay: `0278e53`, existing branch `fix/mobile-edit-approved-ticket-window`.
- Evidence level: **INFERRED from source inspection**. No runtime reproduction or test result is claimed.
- This is narrower than the previous whole-workflow requirements audit; it does not reopen its other findings.

## Expected behavior and source status

The user explicitly requested: "So, we also need to do (submission queues recalculation for its pay week.) for **Completed ticket:** approval → edit → Save changes → close request" and asked to plan using AI-DLC. This is the direct authority for this fix.

Existing `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` REQ-20 says approved submitted-ticket edits re-queue payroll on resubmission. That parent requirement cites a `status: reference` developer decision and is tagged `[UNVERIFIED]`; it is supporting history, not client ratification. The user's current direction supplies the behavior for this specific completion path.

## Source trace

| Step | Current code | Observation |
| --- | --- | --- |
| Save changes | `apps/mobile/features/field-ticket/flow/ticket-step-screen.tsx`, `onFinishEdit` | Drains pending writes under the existing ticket sync lock, then calls `services.tickets.completeEditRequest`; no submit call. |
| HTTP request | `apps/mobile/data/services/tickets/tickets.http.ts`, `completeEditRequest` | POST `/field/tickets/:id/edit-requests/complete`. |
| Controller | `apps/api/src/presentation/field-tickets/field-tickets.controller.ts`, `completeEditRequest` | Delegates to `TicketEditRequestsService.completeForWorker`; returns HTTP 204. |
| Completion | `apps/api/src/usecase/ticket-edit-requests/ticket-edit-requests.service.ts`, `completeForWorker` | Authorizes primary worker; finds active approved request; checks requester and lifetime; expires it. No payroll enqueue call. |
| Existing enqueue path | `apps/api/src/usecase/job-tickets/job-tickets.service.ts`, `submitTicket` | A COMPLETE ticket with a live SUBMITTED_EDIT approval queues payroll and sends the approved-edit notice when resubmitted. First submission also queues payroll. |
| Existing pay-week resolution | `apps/api/src/usecase/payroll/payroll-calc-enqueue.service.ts`, `enqueueForTicket` | Uses actual Start Ticket placement in the payroll timezone, with the existing schedule fallback and historical cut-over behavior. |

## Runtime reproduction to perform during construction

1. Use a disposable tenant and a COMPLETE ticket belonging to an internal primary employee. Its pay week has an existing, unsettled payroll period and an existing calculation.
2. Raise a SUBMITTED_EDIT request within the currently allowed request deadline. Approve with an authorized `payroll-admin:edit` holder; keep the four-hour window live.
3. Change a time field in the mobile approved-edit flow so that the expected payroll result differs.
4. Tap Save changes. Observe the edited field reach the API and the completion request return successfully.
5. Check the request is closed, then inspect `payroll_calculation_queue` for that tenant/pay period and compare the run history and payroll figures.
6. Before the fix: the completion path creates no new recalculation trigger. Control for unrelated queue producers; if a pending job already exists, inspect its trigger/update timestamp rather than only counting rows.
7. After the fix: successful completion enqueues or folds a trigger for that ticket's pricing week; the worker subsequently recalculates it. The ticket remains COMPLETE and the request closes.

Queue persistence and worker calculation are separate observations. A 204 response alone is not proof that calculation completed.
