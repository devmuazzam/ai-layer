# Units — SCRUM-817 Ticket & Shift Reschedule Email Templates & Notifications

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Standardized ticket notification email templates matching Figma designs with catalog registration | REQ-01, REQ-02, REQ-05 | api, shared | — | M | complete |
| U2 | DAS shift reallocation audit logging, ticket shift updates, and reschedule notifications | REQ-03, REQ-06 | schema, api, web, shared | U1 | M | complete |
| U3 | Automated 1-day pre-job start reminder cron job and completion notification dispatching | REQ-04 | api | U1 | S | complete |

- Requirements not covered by any unit: none
- Units blocked on an open question: none

---

## U1 — Branded Ticket Notification Email Layouts & Catalog Setup

- **Outcome:** System can generate branded HTML emails for ticket assignment, reschedule, 1-day start reminder, and completion matching Figma design specifications.
- **Kind:** vertical
- **Requirements covered:** REQ-01, REQ-02, REQ-05
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | Add `ticket-email-layout.ts`, update `notification-catalog.ts` and `notification-templates.ts` | HTML email builders for 4 ticket notification types |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | Add notification type enum constants | `@tcg/shared` notification type definitions |
| Tests | Add layout spec tests in `ticket-email-layout.spec.ts` | Unit tests for email layout rendering |

### Reviewable as

- **Demo:** Run unit tests for `ticket-email-layout.spec.ts` to inspect generated HTML snapshots matching Figma nodes `7348:217715`, `7348:217787`, `7353:217909`, and `7358:101717`.
- **Acceptance:** `pnpm test apps/api/src/usecase/notifications/templates/ticket-email-layout.spec.ts` passes.

---

## U2 — DAS Shift Reallocation Audit Logging & Notifications

- **Outcome:** Dispatchers can reassign crew shift allocations in DAS while automatically recording an audit history and notifying crew members of schedule changes.
- **Kind:** vertical
- **Requirements covered:** REQ-03, REQ-06
- **Depends on:** U1

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | Add `DasAllocationAuditLog` model and migration `das_allocation_audit_logs` | Audit trail table |
| API (`apps/api`) | Update `das-allocations.service.ts` to record audit logs and trigger `das.job_ticket_rescheduled` | Service logic |
| Web (`apps/web`) | Update DAS allocation UI to support shift reassignments | Dispatcher shift change action |
| Mobile (`apps/mobile`) | N/A | Receives standard notification |
| Shared (`packages/shared`) | Add audit log interface types | Audit DTOs |
| Tests | Integration test for shift reschedule service action | Verify audit DB insertion & notification dispatch |

---

## U3 — 1-Day Pre-Job Ticket Reminder Cron Task & Completion Flows

- **Outcome:** Automatically send crew members a ticket job reminder 1 day prior to ticket start and notify upon completion.
- **Kind:** vertical
- **Requirements covered:** REQ-04
- **Depends on:** U1

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | Add `ticket-reminder-cron.service.ts` using NestJS Schedule | Cron task running daily |
| Web (`apps/web`) | N/A | |
| Shared (`packages/shared`) | N/A | |
| Tests | Unit test `ticket-reminder-cron.service.spec.ts` | Cron job query & deduplication test |

---

## Sequencing

```
U1 ──▶ U2
 └──▶ U3
```

- **Parallelisable:** U2 and U3 can run in parallel after U1 completes.
- **Merge order constraint:** Land U1 first, followed by U2 & U3.
- **First unit to ship:** U1 establishes core email templates & notification catalog.
