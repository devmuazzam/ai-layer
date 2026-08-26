# Spec — SCRUM-817 Ticket & Shift Reschedule Email Templates & Notifications

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-817` |
| Intent | `.ai/aidlc/SCRUM-817/intent.md`, captured 2026-08-24 |
| Elaborated on | 2026-08-24 |
| Vault state at elaboration | 151 files; six `domain/` files verified |
| Open questions raised by this spec | none |
| Rules consulted | `.ai/claude/contexts/api.md`, `.ai/claude/contexts/prisma.md`, `.ai/claude/contexts/web.md` |

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Ticket Email Layout Helper & Branding Standardization | api | `[VERIFIED]` | `SCRUM-817`, `apps/api/src/usecase/notifications/templates/` | no |
| REQ-02 | Ticket Assignment Email & In-App Notification | api / shared | `[VERIFIED]` | `SCRUM-817`, Figma Node `7348:217715` | no |
| REQ-03 | Shift Reschedule Email & Notification in DAS | api / web / shared | `[VERIFIED]` | `SCRUM-817`, Figma Node `7348:217787` | no |
| REQ-04 | 1-Day Pre-Job Ticket Reminder Cron Job | api | `[VERIFIED]` | `SCRUM-817`, Figma Node `7353:217909` | no |
| REQ-05 | Ticket Completion Email & Notification | api / shared | `[VERIFIED]` | `SCRUM-817`, Figma Node `7358:101717` | no |
| REQ-06 | DAS Allocation Shift Change Audit Trail | schema / api | `[VERIFIED]` | `SCRUM-817` | no |

Counts: 6 total — 6 verified, 0 unverified, 0 conflicted, 0 open.

## 2. Requirements

### REQ-01 — Ticket Email Layout Helper & Branding Standardization `[UNVERIFIED]`

- **Statement:** The system shall provide reusable email layout helpers (`buildTicketEmailHtml`, header, footer, details table, point of contact card) matching Figma brand standards and existing quotation email layouts.
- **Surface:** api
- **Sources:**
  - `SCRUM-817` — `[UNVERIFIED]` — kind: jira — *Use reusable email template functions matching Figma design specs.*
  - `apps/api/src/usecase/notifications/templates/quotation-delivery-email-layout.ts` — `[UNVERIFIED]` — kind: code — *Reference implementation for branded email layouts.*
- **Conflict:** none
- **Open question:** none
- **Acceptance:** HTML email templates render consistently with brand header, footer, job details, and CTA buttons across all email clients.
- **Notes for the executor:** Place ticket email layout functions in `apps/api/src/usecase/notifications/templates/ticket-email-layout.ts`.

### REQ-02 — Ticket Assignment Email & In-App Notification `[UNVERIFIED]`

- **Statement:** When an employee is assigned to a ticket, the system shall dispatch a `das.job_ticket_assigned` notification with in-app, push, and branded email channels.
- **Surface:** api / shared
- **Sources:**
  - `SCRUM-817` — `[UNVERIFIED]` — kind: jira — *Send employee ticket assignment notification.*
  - Figma Node `7348:217715` — `[UNVERIFIED]` — kind: design — *New Ticket Assignment email design.*
- **Conflict:** none
- **Open question:** none
- **Acceptance:** Notification catalog renders `das.job_ticket_assigned` email HTML matching Figma Node `7348:217715` with job site, schedule, equipment details, and view ticket CTA.
- **Notes for the executor:** Wire into ticket assignment service.

### REQ-03 — Shift Reschedule Email & Notification in DAS `[UNVERIFIED]`

- **Statement:** When a dispatcher reassigns an employee from one shift slot to another (e.g., Shift 1 → Shift 2) in DAS, the system shall update the ticket allocation, record audit history, and dispatch a `das.job_ticket_rescheduled` notification.
- **Surface:** api / web / shared
- **Sources:**
  - `SCRUM-817` — `[UNVERIFIED]` — kind: jira — *Employee shift reschedule notification and ticket update.*
  - Figma Node `7348:217787` — `[UNVERIFIED]` — kind: design — *Schedule Changed email template.*
- **Conflict:** none
- **Open question:** none
- **Acceptance:** Reassigning shift in DAS triggers `das.job_ticket_rescheduled` email showing old vs. new shift timing + in-app alert.
- **Notes for the executor:** Triggered from `das-allocations.service.ts`.

### REQ-04 — 1-Day Pre-Job Ticket Reminder Cron Job `[UNVERIFIED]`

- **Statement:** A scheduled cron job shall run daily to identify tickets starting in 24 hours and send a `das.job_ticket_reminder_1d` notification to assigned crew members.
- **Surface:** api
- **Sources:**
  - `SCRUM-817` — `[UNVERIFIED]` — kind: jira — *A ticket reminder sent one day before the scheduled start date, triggered via cron job.*
  - Figma Node `7353:217909` — `[UNVERIFIED]` — kind: design — *Ticket Job Reminder email template.*
- **Conflict:** none
- **Open question:** none
- **Acceptance:** Cron task selects active tickets with `startedWorkAt` within [NOW + 24h, NOW + 25h] (avoiding duplicates via notification reminder log) and sends reminder emails.
- **Notes for the executor:** Implement in `apps/api/src/usecase/das/ticket-reminder-cron.service.ts` using `@nestjs/schedule`.

### REQ-05 — Ticket Completion Email & Notification `[UNVERIFIED]`

- **Statement:** Upon completion of a job ticket, the system shall dispatch a `das.job_ticket_completed` notification with summary details.
- **Surface:** api / shared
- **Sources:**
  - `SCRUM-817` — `[UNVERIFIED]` — kind: jira — *Ticket completion notification.*
  - Figma Node `7358:101717` — `[UNVERIFIED]` — kind: design — *Ticket Completion email template.*
- **Conflict:** none
- **Open question:** none
- **Acceptance:** Triggering ticket completion dispatches email matching Figma Node `7358:101717`.
- **Notes for the executor:** Add `das.job_ticket_completed` entry to `NOTIFICATION_CATALOG`.

### REQ-06 — DAS Allocation Shift Change Audit Trail `[UNVERIFIED]`

- **Statement:** The system shall log shift reallocation events in `DasAllocationAuditLog` to record shift transitions (previous shift ID, new shift ID, changed by user, timestamp).
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-817` — `[UNVERIFIED]` — kind: jira — *Maintain proper audit trail of allocation changes per-day basis.*
- **Conflict:** none
- **Open question:** none
- **Acceptance:** Every shift change action creates a corresponding audit log row accessible by dispatch managers.
- **Notes for the executor:** Ensure shift change audit records include `previousShiftId`, `newShiftId`, `reallocatedByUserId`.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes
- **Migration required:** yes — `pnpm db:migrate`
- **Data backfill required:** no

```prisma
model DasAllocationAuditLog {
  id               String   @id @default(uuid()) @db.Uuid
  tenantCompanyId String   @map("tenant_company_id") @db.Uuid
  allocationId     String   @map("allocation_id") @db.Uuid
  jobTicketId      String?  @map("job_ticket_id") @db.Uuid
  employeeId       String?  @map("employee_id") @db.Uuid
  action           String   @db.VarChar(50) // 'ASSIGNED', 'RESCHEDULED', 'REMOVED'
  previousShiftId  String?  @map("previous_shift_id") @db.Uuid
  newShiftId       String?  @map("new_shift_id") @db.Uuid
  changedByUserId  String   @map("changed_by_user_id") @db.Uuid
  notes            String?  @db.Text
  createdAt        DateTime @default(now()) @map("created_at") @db.Timestamptz

  tenantCompany    TenantCompany @relation(fields: [tenantCompanyId], references: [id], onDelete: Cascade)
  changedByUser    User          @relation(fields: [changedByUserId], references: [id], onDelete: Restrict)

  @@index([tenantCompanyId], name: "idx_das_allocation_audit_tenant")
  @@index([allocationId], name: "idx_das_allocation_audit_allocation")
  @@index([jobTicketId], name: "idx_das_allocation_audit_ticket")
  @@map("das_allocation_audit_logs")
}
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `DasAllocationAuditLog` | N/A (UUID PK) | N/A | Direct UUID creation | REQ-06 |

- **New prefix introduced:** no
- **Child relations:** FKs reference UUID primary keys.

## 4. API surface — `apps/api`

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/api/v1/das-allocations/:id/reschedule` | `das-allocations.controller.ts` | `das-allocations.service.ts` | `das-allocations.repository.ts` | REQ-03, REQ-06 |
| `GET` | `/api/v1/das-allocations/:id/audit-history` | `das-allocations.controller.ts` | `das-allocations.service.ts` | `das-allocations.repository.ts` | REQ-06 |

## 5. Web surface — `apps/web`

- **Routes:** `/das`, `/tickets/[code]`
- **Existing components to reuse:** `StatusBadge`, `InfoRow`, `SectionCard`, `CommonTable`
- **Forms:** react-hook-form + Zod v4 for shift reschedule modal.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `/(crew)/tickets/[id]`
- **Push / notifications involvement:** Catalog entries for `das.job_ticket_assigned`, `das.job_ticket_rescheduled`, `das.job_ticket_reminder_1d`, `das.job_ticket_completed`.

## 7. Shared package — `packages/shared`

- **Types added / changed:** `NotificationType` enum additions:
  - `das.job_ticket_assigned`
  - `das.job_ticket_rescheduled`
  - `das.job_ticket_reminder_1d`
  - `das.job_ticket_completed`

## 8. Permissions and tenancy

- **Roles permitted:** `Dispatcher`, `Admin` for shift reschedule; `Field Crew` for ticket notifications.
- **Tenant isolation:** Standard Prisma tenant scoping.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `newShiftId` | Must be a valid active shift ID within the same tenant | `SCRUM-817` | `[UNVERIFIED]` |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | Email layout builder HTML snapshot & tag tests | REQ-01 |
| Unit | Catalog rendering for 4 new ticket notification types | REQ-02, REQ-03, REQ-04, REQ-05 |
| Integration (API) | DAS shift reschedule service logs audit entry & sends notification | REQ-03, REQ-06 |
| Integration (API) | Ticket reminder cron task triggers notifications 24h prior to start | REQ-04 |

## 11. Non-functional

- **Performance:** Cron task executes efficiently using indexed queries (`startedWorkAt`).
- **Audit:** All shift reallocations logged to `DasAllocationAuditLog`.

## 12. Open questions — the stop-and-ask list

*None.* All technical and product requirements are covered by SCRUM-817 and existing notification patterns.

## 13. What this spec deliberately does not specify

- Mobile push gateway providers (handled by existing `NotificationModule`).

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered
- [x] Every `[CONFLICT]` requirement addressed
- [x] Decomposed into vertical units — `units.md`

Answered by: devmohsinakram Date: 2026-08-24
