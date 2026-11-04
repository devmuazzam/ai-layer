# Intent — TCG-62

> Captured from Linear TCG-62 (description + first comment) and the developer's direction in
> session 2026-10-14. Not a spec; nothing here is sourced from the vault yet.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-62` |
| Title | Send Ticket: show the employee's contact (email or work cell) |
| Type | NOT ON TICKET (labels: frontend, backend, dispatch, Improvement, UAT) |
| Status | Todo (Backlog -> Todo 2026-10-05); ticket last updated 2026-10-13 |
| Epic | `TCG-9` (parent) — name NOT ON TICKET |
| Sprint | NOT ON TICKET (cycle id `919e22db-ed77-4e94-a573-aefc90c68758`, name not retrieved) |
| Reporter | syed haris (created by) |
| Assignee | Fouzan Shakil |
| Captured on | `2026-10-14` |
| Captured by | tcg-elaborator, from Linear MCP + session statement of Jahanzaib Nadeem |

Priority Low. Ticket description is marked **"Blocked / needs decision"**.

## 2. Business intent

- Intent: UAT 3 asked that "On the Send Ticket, the email should be shown." The ticket turns
  this into a **Contact** column on the DAS Send Ticket table (pre-send). The underlying
  business reason (what decision the dispatcher makes from seeing the contact) is
  `NOT ON TICKET`.
- Who benefits (role): dispatcher (implied; `NOT ON TICKET`).
- What is worse today without it: the table shows no email or phone, so a dispatcher cannot
  see how an employee will be reached. The ticket's own premise ("tickets mostly reach them
  by text to their work cell") is unverified — see spec §0 and Q4.

**Developer direction, session 2026-10-14 (Jahanzaib Nadeem, git `Jz-Nd`) — differs from
the ticket.** Verbatim: *"When a ticket is sent from DAS, the employee emails must be shown
somewhere, probably in the toaster, showing the user on which employee emails/phone numbers
the invitations were sent."* This is a **post-send report** of where notifications and
invitations went, not a pre-send "on file" column. It is a developer's direction, not an
answer from the requester; the ticket's blocking questions are unanswered.

## 3. Definition of done, as the ticket states it

```
Done when
* The agreed contact shows for each employee on the agreed screen.
* Vendor rows show a dash.

What should happen
* Add a Contact column to the Send Ticket table, showing the contact agreed below.
* If it is email, label it so it reads as "email on file", not "where the ticket was sent".
* Vendor rows should show a dash. Vendors are not sent tickets.

Blocked / needs decision
Ask the person who raised it: email, work cell phone, or both? Also confirm the screen. The
note was under Mobile App on the UAT sheet, so it may mean the mobile ticket view or the
reminder email, not the web Send Ticket popup.
```

Technical comment (2026-09-23) adds acceptance items: confirm contact field (work cell /
email / both); confirm surface; if work cell, `EnsuredTicketRow` + employee select carry
`workCellPhone`; if email, same with `employee.email` labelled as "address on file"; vendor
rows show an em-dash, not blank; new column ships with a `data-testid`, grep
`qa-automation/e2e` first.

- Acceptance criteria present on the ticket: yes, but both are conditional on an unanswered
  question ("the agreed contact", "the agreed screen").

## 4. In scope

- [ ] Ticket: Contact column on the web DAS Send Ticket table — **contingent on Q1/Q2**
- [ ] Ticket: vendor rows show a dash
- [ ] Developer direction D1: `POST /das/sub-jobs/:subJobId/tickets/send` also returns `recipients`
- [ ] Developer direction D2: success toast "Tickets sent to N employees" + "View recipients" dialog
- [ ] Developer direction D3: flag employees who could not be reached

## 5. Out of scope

- [ ] `NOT ON TICKET` — the ticket states no boundaries.
- [ ] *(adjacent, not assumed in or out)* mobile ticket view and Job Reminder Email — only
      ruled in/out by Q2.
- [ ] *(adjacent, not assumed in)* changing which channels ticket notifications use (e.g.
      restoring SMS); changing field-employee sign-in identity (`admin/gaps.md` Sign-in identity).

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` | yes (D1) / ? (ticket column needs the `ensure` row) | send response gains `recipients`; possibly `ensure` row gains contact |
| `apps/api/prisma` | ? | none implied; whether delivery outcome is read from `notification_deliveries` is a developer decision (spec D3) |
| `apps/web` | yes | `send-ticket-modal.tsx`, `ticket-table.tsx`, `use-send-job-tickets.ts`, `das-allocations.service.ts` |
| `apps/mobile` | ? | only if Q2 resolves to the mobile ticket view |
| `packages/shared` | yes (D1) | shared recipients type — web and mobile both downstream |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket... |
| --- | --- | --- |
| `Employee` | `employeeCode` | reads (name, email, phone) |
| `JobTicket` | `ticketCode` | reads |
| `NotificationDelivery` | none | possibly reads (D3) |

- New entity introduced by this ticket: no (none asked)
- New code prefix introduced: no
- Existing rows affected (backfill): no

## 8. Roles and permissions

- Roles that can perform this: NOT ON TICKET (the send endpoint is used by dispatchers in DAS)
- Roles explicitly excluded: NOT ON TICKET
- Tenant scope: standard per-tenant isolation (nothing stated otherwise)

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | NOT ON TICKET |
| Jira attachments | none (Linear: attachments empty) |
| Related tickets | `TCG-9` parent; none other linked |
| Existing repo docs | NOT ON TICKET |
| Vault area the reader thinks is relevant | `uat/sessions/uat-session-3.md:59`, `uat/register-2026-09-18.md:239`, `dispatch/daily-allocation-system.md`, `admin/gaps.md` (Sign-in identity) |

## 10. Terms used that may not be defined

- `DAS` — "The Send Ticket table in DAS" (undefined in vault glossary; known-undefined term)
- "Contact" — "showing the contact agreed below" (which field is exactly the open question)
- "email on file" vs "where the ticket was sent" — ticket's own distinction, not defined elsewhere
- "invitations" — developer: "on which employee emails/phone numbers the invitations were sent"
  (ambiguous: account invites vs ticket notifications; see Q4)

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| Channels `EMAIL | PUSH | SMS…` (developer direction D1) | NOT ON TICKET — no origin cited; SMS is not a ticket-notification channel in code today |
| "Tickets mostly reach field crew by SMS to the work cell" (ticket comment) | NOT ON TICKET — no origin cited; contradicted by current code |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 9 (type, sprint name, epic name, design, roles permitted,
  roles excluded, out of scope, ticket's business reason, number origins)
- Fields left as `OPEN`: 2 (contact field, surface)
- Buildable without a product answer: **no**
- Blocking questions: which contact (email / work cell / both) and on-file vs actually-used;
  which surface; whether the developer's post-send report replaces or sits beside the column.
  Carried into `spec.md` §12.

---

**Next step:** `spec.md` beside this file. The elaborator stops after it.
