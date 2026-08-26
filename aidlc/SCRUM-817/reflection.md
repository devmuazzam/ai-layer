# Reflection — SCRUM-817 Ticket & Shift Reschedule Email Templates & Notifications

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-817` |
| Spec | `.ai/aidlc/SCRUM-817/spec.md` |
| Units | U1, U2, U3 — *all shipped* |
| Reflected on | `2026-08-25` |
| Reviewer(s) | devmohsinakram |
| Open questions at build time | 0 |
| `[UNVERIFIED]` requirements built | 0 |
| Unverified × irreversible | 0 |

## 1. Spec defects — what the spec missed

### SD-1 — RecipientSpec type mapping for Employee Notifications

- **Where:** REQ-02, REQ-03 (Notification dispatching to employees)
- **What the executor needed to know:** The exact shape of `RecipientSpec` expected by `NotificationService.notify` when targeting an employee.
- **What the spec said:** `{ type: 'EMPLOYEE', id: employeeId }` in generic context notes.
- **What was decided instead, and by whom:** Used `{ employeeId: string }` as mandated by `RecipientResolverService` and `RecipientSpec` union type in `recipient-resolver.service.ts`.
- **Was the decision right:** Yes — aligns with existing `RecipientResolverService` design.
- **Cost:** 1 build error during nest build, resolved in same turn.
- **Class:** contract-drift
- **Fix:** Document `RecipientSpec` shapes in API context for notification dispatches.

## 2. Executor defects — what was built against the spec

### ED-1 — Test Mock Constructor Injection in DasAllocationsService

- **Where:** `apps/api/src/usecase/das-allocations/das-allocations.service.spec.ts`
- **Spec said:** N/A (unit testing rail)
- **Built:** Initial constructor injection of `NotificationService` in `DasAllocationsService` broke unit tests because `NotificationService` was missing in `das-allocations.service.spec.ts` `buildService` helper.
- **Caught by:** `pnpm nx run @tcg/api:test`.
- **Class:** test-mock-drift
- **Fix:** Added `notificationService`, `findAllocationBySlot`, and `createAuditLog` mock functions to `das-allocations.service.spec.ts`.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:** None.
- **Conflicts that surfaced only during build:** None.
- **Questions answered by a named human during the build:** None.
- **`gaps.md` entries this ticket should close:** None.
- **`gaps.md` entries this ticket opened:** None.
- **Undefined terms hit:** None.

## 4. Rule changes proposed

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/claude/contexts/api.md` | `Notifications` | Always use `{ employeeId }` or `{ userId }` spec format when calling `NotificationService.notify` | SD-1 | applied |

## 5. Recurrence check

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | contract-drift | none | 1st | N/A |
| ED-1 | test-mock-drift | none | 1st | N/A |

- **Escalate:** None.
- **New class added to the index?** No.

## 6. Kept as-is

- Advisory locks for cron execution (`4815162349`) and `NotificationReminderLogRepository` for deduplication.
