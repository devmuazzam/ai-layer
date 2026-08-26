# Intent — SCRUM-817

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-817` |
| Title | Ticket & Shift Reschedule Email Templates & Notifications |
| Type | Story |
| Status | In Progress |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | Iqra Irshad |
| Assignee | tcgproject12 |
| Captured on | 2026-08-24 |
| Captured by | devmohsinakram |

## 2. Business intent

To standardize ticket notification emails and shift reschedule handling across the Crane rental platform by creating reusable email templates matching Figma brand guidelines, automating a 1-day pre-job reminder cron task, tracking employee shift reallocations in the Daily Allocation System (DAS) with full audit history, and dispatching in-app and email notifications when ticket shifts change.

- Intent: Refactor ticket email templates to match Figma designs, implement cron-based 1-day job start reminders, and log/notify shift reschedules in DAS.
- Who benefits (role): *field crew / dispatcher / admin*
- What is worse today without it: Existing email templates do not follow Figma design specs, shift reschedules in DAS lack an audit log, and crew members do not receive automated pre-job start reminders or shift change notifications.

## 3. Definition of done, as the ticket states it

```
We need to reuse these existing email template designs to create new ticket-related email templates and integrate them with the following flows:
1. Employee ticket assignment and ticket completion.
2. A ticket reminder sent one day before the scheduled ticket start date, triggered via a cron job.
3. Handling employee shift rescheduling—for example, when an employee is moved from Shift 1 to Shift 2—so the relevant ticket notifications and schedules are updated accordingly.

We need to update email templates to align with Figma designs and leverage generic, reusable functions as part of our usability principles (since the same design is used for quotation emails).

For Daily Allocation System (DAS):
- When an employee is initially assigned to Shift 1 and the Dispatch Manager removes them from Shift 1 and assigns them to Shift 2, this should be treated as an employee reschedule.
- Maintain a proper audit trail of these allocation changes to determine whether an employee was previously assigned to Shift 1 and subsequently moved to Shift 2.
- Update the employee's ticket to reflect the new Shift 2 assignment.
- Trigger an employee reschedule email notification along with an in-app notification.
```

- Acceptance criteria present on the ticket: yes

## 4. In scope

- [ ] Refactor ticket email rendering to use generic, reusable email layout helpers matching Quotation email design (Figma Node `7172-217364`).
- [ ] Implement `New Ticket Assignment` email template (Figma Node `7348-217715`).
- [ ] Implement `Schedule Changed / Reschedule` email template (Figma Node `7348-217787`).
- [ ] Implement `Ticket Job Reminder` email template (Figma Node `7353-217909`).
- [ ] Implement `Ticket Completion` email template (Figma Node `7358-101717`).
- [ ] Implement NestJS Cron job running daily to dispatch ticket reminders 1 day prior to scheduled ticket `startedWorkAt`.
- [ ] Implement shift reschedule logic in DAS / Dispatch service when an employee is moved between shifts.
- [ ] Maintain an audit trail (e.g. `AllocationAuditLog` / `TicketShiftAudit` entity or relation) tracking shift allocation transitions.
- [ ] Trigger email + in-app notification on employee ticket assignment, ticket completion, shift reschedule, and 1-day reminder.

## 5. Out of scope

- [ ] Mobile app push notification gateway alterations outside existing NestJS notification module.
- [ ] Quotation design changes (quotation templates serve as reference only).

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | Add email templates, cron service, DAS shift reschedule handling & notifications |
| `apps/api/prisma` (schema + migration) | yes | Audit trail table / shift change tracking schema additions if required |
| `apps/web` (Next.js — atoms → pages) | yes | Trigger shift reschedule in DAS UI / view allocation audit history |
| `apps/mobile` (Expo Router) | no | Receives existing notification payload |
| `packages/shared` (types shared across apps) | yes | Notification and allocation audit type definitions |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `JobTicket` | `ticketCode` / `TICK-#####` | reads / updates |
| `AllocationAuditLog` | `id` / UUID | creates (new audit trail entity if needed) |
| `UserNotification` | `id` / UUID | creates |

- New entity introduced by this ticket: yes (`AllocationAuditLog` or shift history model if not present)
- New code prefix introduced: no
- Existing rows affected: no

## 8. Roles and permissions

- Roles that can perform this: *Dispatcher, Admin*
- Roles explicitly excluded: *Field crew (read-only for assigned tickets)*
- Tenant scope: standard per-tenant isolation

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | Figma File `Y2CvlUpG8XyVZzYbUE9OQb` — Nodes `7348-217715`, `7348-217787`, `7353-217909`, `7358-101717` |
| Jira attachments | None |
| Related tickets | `SCRUM-817` |
| Existing repo docs | `apps/api/src/service/mail/` / `apps/api/src/service/notification/` |
| Vault area | `vault/tickets/` / `vault/das/` |

## 10. Terms used that may not be defined

- `das` — Daily Allocation System used by Dispatchers to schedule and assign crew/equipment to shifts.
- `shift reschedule` — Reassigning an employee from one shift slot to another for a given ticket date.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| `1 day before start date` | Cron schedule trigger threshold for ticket job reminders |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 2 (Epic, Sprint)
- Fields left as `OPEN`: 0
- Is this ticket, as written, buildable without a product answer? yes
