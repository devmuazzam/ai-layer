# Spec — TCG-62 Send Ticket: show where the contact / invitations went

> Written by the elaborator from `intent.md` beside it. **Spec only — nothing was built, no
> units were produced.** Every requirement carries its sources and status. The ticket is
> marked blocked by its own author; the requester has not answered, so the load-bearing
> requirements are `[OPEN]`.

## Fill rules / source tagging

As in `.ai/aidlc/templates/spec.md`. Two statuses only. One extra provenance used here and
flagged each time: **developer-direction** — Jahanzaib Nadeem's statement in session
2026-10-14, relayed in the elaboration brief. It is a developer's choice about how to
build, not a product agreement; it is therefore `[UNVERIFIED]` and never lifts a requirement
above that. `Linear TCG-62` is `[UNVERIFIED]` by default (kind: jira, tracker is Linear).

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-62` (Linear; assignee Fouzan Shakil; Todo) |
| Intent | `.ai/aidlc/TCG-62/intent.md`, captured `2026-10-14` |
| Elaborated on | `2026-10-14` |
| Vault state at elaboration | six `domain/` files verified; gaps registers not counted. Only `admin/gaps.md` (Sign-in identity) and `dispatch/gaps.md` (ticket-email field set) were opened, by anchor |
| Open questions raised by this spec | 8, all in §12 |
| Already-shipped behaviour reached | 7 consumers in §11a; 3 with no source for what happens to them |
| Rules consulted | `CLAUDE.md`, `.ai/claude/contexts/api.md`, `web.md` (Test IDs), `patterns.md` (headings only; no P1/P2 entry fits) |

**Ticket re-read against live Linear on 2026-10-14** (`updatedAt` 2026-10-13). Description and
single comment quoted in `intent.md` are the live text; no earlier snapshot existed to diff.

**Stale premise, flagged.** The ticket comment (2026-09-23) says tickets "mostly reach field
crew by SMS to the work cell" and that selection includes "SMS only if a phone resolves".
At HEAD (`5635752` overlay; app repo `17474ab2c`) that is **no longer true**:
`apps/api/src/usecase/job-tickets/job-ticket-notification.service.ts:112-160` passes
`channels = [PUSH, IN_APP]` if the employee has a user account plus `EMAIL` if
`employee.email ?? user.email`, and a code comment says SMS was removed from ticket dispatch
on purpose (cost), reserved for the invite text and forgot-password code. (The catalog
`das.job_ticket_sent` in `notification-catalog.ts:371` still lists `SMS` in
`defaultChannels`; the service overrides it.) The ticket's argument for "work cell is the
stronger candidate than email" therefore rests on a premise that has changed — see Q4. Also
stale: the ticket cites `admin/gaps.md:1149`; the entry is the *Sign-in identity — Microsoft
365 (Entra) credentials, or phone number and SMS code, and for whom?* heading at
`admin/gaps.md:1175`, part (b) at `:1179`; line 1149 is an unrelated resolved entry.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Pre-send Contact column on Send Ticket table | web, api | `[OPEN]` | none sufficient | **yes** |
| REQ-02 | Send endpoint returns per-employee `recipients` | api, shared, web | `[UNVERIFIED]` | developer-direction; `TCG-62` | partly (Q4, Q5, Q7, Q8) |
| REQ-03 | Success toast with "View recipients" dialog | web | `[UNVERIFIED]` | developer-direction | partly (Q6, Q8) |
| REQ-04 | Flag employees who could not be reached | api, web | `[OPEN]` | none sufficient | **yes** |
| REQ-05 | Recipients on the idempotent re-send path | api | `[OPEN]` | none | **yes** |
| REQ-06 | Which contact values are shown, and to whom | api, web | `[OPEN]` | none | **yes** |

Counts: 6 total — 0 verified, 2 unverified, 0 conflicted, 4 open.

## 2. Requirements

### REQ-01 — Pre-send Contact column on the Send Ticket table `[OPEN]`

- **Statement:** `OPEN — the ticket asks for a Contact column; no source says whether it is email, work cell or both, whether it means "on file" or "where it was sent", or whether it is still wanted now that the developer wants a post-send report.`
- **Surface:** web, api
- **Sources:** none sufficient. Searched: `uat/sessions/uat-session-3.md:59` (one line, under `### Atom Mobile App`, after the Job Reminder Email bullet; no field, no screen name); `uat/register-2026-09-18.md:239` (register routes it to the web Send Ticket table — a register's reading, not the reporter's); `TCG-62` description + comment (explicitly blocked; nothing in `dispatch/` or `field-ops/` specifies a contact column); `dispatch/daily-allocation-system.md` (only Send Tickets lines are the bulk/individual send, status chips and the button flip to "See Progress"; no contact). Nothing written settles it.
- **Conflict:** n/a (the DAS topic has a conflict stub, `dispatch/daily-allocation-INDEX.md`, which describes its two files as complementary; neither speaks to this)
- **Open question:** Q1, Q2, Q3
- **Ripple:** `OPEN — see Q1.` Reaches `ticket-table.tsx` (render site), `send-ticket-modal.tsx` row mapping, `EnsuredTicketRow` on both sides (`job-tickets.service.ts:194`, web `jobs/tickets/types/index.ts`). Whether the `ensure` row carries contact is part of the question.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. Vendor rows show a dash and the column carries a `data-testid` per the ticket's technical comment — but those are conditions on a column that may not be built.

### REQ-02 — Send endpoint returns per-employee `recipients` `[UNVERIFIED]`

- **Statement:** `POST /api/v1/das/sub-jobs/:subJobId/tickets/send` returns, in addition to `{ sent, ticketsSentAt }`, a `recipients` list with, per employee: name, employeeCode, email (optional), phone (optional), channels used, whether an invitation was sent (`invited`), and a reason when not reached (`notReached`, optional).
- **Surface:** api, shared, web
- **Sources:**
  - developer-direction (Jahanzaib Nadeem, session 2026-10-14) — `[UNVERIFIED]` — kind: developer-direction — field list as given in D1 (§11b); channel values given as `EMAIL | PUSH | SMS…`.
  - `TCG-62` — `[UNVERIFIED]` — kind: jira — wants the employee contact visible; asks for it pre-send, not in the send response.
- **Conflict:** none — but the direction lists `SMS` as a channel while current ticket notifications never use it (see §0; Q4).
- **Open question:** what `channels used` and `phone` mean (Q4); attempted vs delivered (Q5); shown values (Q8). The shape above is the developer's direction; the meaning of its fields is not settled.
- **Ripple:** consumers of the send response, enumerated by `git grep -n "sendTickets\|tickets/send" -- apps packages qa-automation`: web `das-allocations.service.ts:74` (inline return type `{ sent; ticketsSentAt }`, no shared type), `use-send-job-tickets.ts`, `send-ticket-modal.tsx:96`, API `demo-flows.service.ts:649` (reads `sent.sent` only). Additive field: existing callers keep working. No mobile consumer found. See §11a.
- **Acceptance:** after a send, the response contains one `recipients` entry per employee allocation the send tried to notify, with the fields above; existing `sent` and `ticketsSentAt` unchanged. Which employees are listed (vendors? crew riding another ticket?) and the field meanings are blocked on Q4–Q6.
- **Notes for the executor:** `NotificationService.notify()` returns `void` (`notification.service.ts:50`) and soft-fails per channel, so the service cannot currently tell what happened — see D5. `InvitationsService.invite()` already returns `{ channel, maskedDestination }` (`invitations.service.ts:47`) but the send path currently discards it. Rule: shared type in `@tcg/shared` consumed as built `dist/`.

### REQ-03 — Success toast with "View recipients" dialog `[UNVERIFIED]`

- **Statement:** after a successful send, the web app shows a success toast reading "Tickets sent to N employees" with a "View recipients" action that opens a small dialog listing each person, where it went (email / phone / app), and anyone not reached.
- **Surface:** web
- **Sources:**
  - developer-direction (Jahanzaib Nadeem, session 2026-10-14) — `[UNVERIFIED]` — kind: developer-direction — "probably in the toaster"; copy and "View recipients" given as D2 (§11b).
- **Conflict:** none
- **Open question:** what N counts (Q6); full or masked values (Q8); whether this replaces or complements the REQ-01 column (Q1).
- **Ripple:** the existing success copy `'Job tickets sent to field employees'` at `use-send-job-tickets.ts:18` is replaced; `grep` of `qa-automation` for the old string, `das-tickets`, `send-ticket` returned no hits, so no E2E asserts it. Modal closes on success (`send-ticket-modal.tsx:97-98`), so the dialog must outlive the modal. `lib/toast` already exposes `action?: ToastAction` (`toast.ts:10`).
- **Acceptance:** a send that succeeds shows the toast with the action; activating it opens a dialog with one row per `recipients` entry. Exact copy beyond the two strings above: `NOT SPECIFIED`.
- **Notes for the executor:** search all nine `components/` directories before creating a dialog (`web.md`); new controls ship with `data-testid` (`<module>-<flow>-<element>`). Colours from theme variables.

### REQ-04 — Flag employees who could not be reached `[OPEN]`

- **Statement:** `OPEN — the developer wants unreachable employees flagged (e.g. no contact on file; invitation failed). No source defines "could not be reached".`
- **Surface:** api, web
- **Sources:** none sufficient. developer-direction D3 states the intent only. Code facts, descriptive: invite failure is only logged (`job-tickets.service.ts` auto-invite `catch` writes `logger.warn`); `notify()` swallows per-channel failures and skips channels that are unavailable (`notification.service.ts:120-200`); `sendEmployeeTicketNotification` silently returns when there is no phone, user or email (`job-ticket-notification.service.ts` early `return`). Nothing written says which of these a dispatcher must be told about.
- **Conflict:** n/a
- **Open question:** Q5, Q6
- **Ripple:** `OPEN — see Q5.`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. Workaround not offered: any criterion chosen here is an invention.

### REQ-05 — Recipients on the idempotent re-send path `[OPEN]`

- **Statement:** `OPEN — when tickets were already sent, sendTickets returns { sent, ticketsSentAt } early without re-notifying; what recipients it returns (none, the original report, or a recomputed one) is not specified.`
- **Surface:** api
- **Sources:** none. Descriptive code fact: early return at `job-tickets.service.ts` (`if (subJob.ticketsSentAt)`), also back-fills sent status and DAS stage. No stored record of the first send's outcome exists beyond `notification_deliveries` rows.
- **Conflict:** n/a
- **Open question:** Q7
- **Ripple:** `OPEN — see Q7.` The UI normally cannot reach this path (the button becomes "See Progress"), so it is a retry/race/API-client case.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked on Q7; the response type must allow `recipients` to be absent or empty if that is the answer.

### REQ-06 — Which contact values are shown, and to whom `[OPEN]`

- **Statement:** `OPEN — email and phone are personal contact data that the dialog would show to the dispatcher; no source says whether to show them whole or masked, or which employee phone field counts as "the phone".`
- **Surface:** api, web
- **Sources:** none. Descriptive: invite results already return a masked destination "safe to show back to the admin" (`invitations.service.ts:47-50`) and `maskPhoneE164` exists in `phone-e164.util.ts`; `resolveEmployeeSmsPhone` orders `workCellPhone → phone → personalCellPhone → homePhone`. Existing practice is not a decision for this screen.
- **Conflict:** n/a
- **Open question:** Q8
- **Ripple:** `OPEN — see Q8.`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no (none asked; D5 may decide to read existing delivery rows)
- **Migration required:** no
- **Data backfill required:** no
- **Existing models considered:** `Employee` (`email` String NOT NULL `:4154`, `workCellPhone` String NOT NULL `:4172`, `phone`, `personalCellPhone`, `homePhone` nullable) holds all contact values. `NotificationDelivery` (`:4610`: channel, status PENDING/SENT/FAILED, `recipientAddress`, `error`) already records per-channel outcomes and could back D5 without a new table. `JobTicket.sentAt` / `SubJob.ticketsSentAt` (`:3847`) records only that a send happened. No new table is implied by anything asked; a stored send report would be one (history of the first send) and is a §11b decision, not proposed.
- New prefix introduced: no. Child relations / precision: `N/A`.

## 4. API surface — `apps/api`

- **Pattern:** none — `patterns.md` P1/P2 are CRUD / reference list; this is an action endpoint.
- **Existing functions/services to reuse:** `JobTicketsService.sendTickets` (`job-tickets.service.ts:401`); `JobTicketNotificationService.sendEmployeeTicketNotification` (`job-ticket-notification.service.ts:91`, returns `void`); `InvitationsService.invite` (returns `InviteDelivery`) and `resolveInviteChannel` (`invitations.service.ts:82`); `resolveEmployeeSmsPhone`, `parsePhoneToE164`, `maskPhoneE164` (`@utility/phone-e164.util`); `NotificationDelivery` repository (`notificationsRepository.createDelivery/updateDelivery`).
- **New exported functions/services proposed:** none by the elaborator. Developer-direction implies a new response type (shared) and a changed return type of the notification service or a new reader — D5/D6.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/api/v1/das/sub-jobs/:subJobId/tickets/send` (exists) | `das-allocations.controller.ts:93-98` | `job-tickets.service.ts` `sendTickets` | `job-tickets.repository.ts` | REQ-02, 04, 05 |

- **Request DTO:** unchanged (no body).
- **Response shape:** `{ sent, ticketsSentAt, recipients[] }` per D1; element field meanings `OPEN` (Q4–Q8).
- **Guards / roles:** global `AccessTokenGuard`; no `@Roles` found on the controller class in the first 40 lines read — role requirement `NOT SPECIFIED`.
- **Route param identity:** `subJobId` as today.
- **Errors:** unchanged (404 sub-job, 400 not allocated / locked / no personnel). Failure of an individual notification must not fail the send — existing behaviour, comment in code.
- **Module registration:** unchanged.

## 5. Web surface — `apps/web`

- **Routes:** none new (DAS jobs list; `SendTicketModal` opened from `job-list-item.tsx`).
- **Existing components to reuse:** `Dialog*` primitives already used by `send-ticket-modal.tsx`; `toastMutationSuccess(message, options)` with `ToastAction`; `TicketTable`/`Th`/`TableCell`. Search of the other `components/` directories for an existing recipients/list dialog: **not yet run** — executor to run `find-component` first.
- **New components proposed:** none by the elaborator; a recipients dialog is implied by REQ-03 (§11b D8).
- **Table (if any):** `ticket-table.tsx` columns today (read at HEAD): Employee, Shift, Start Time, End Time, Ticket Number, plus an icon column. Column work only if REQ-01 survives Q1.
- **Forms / Server state:** `useSendJobTickets` mutation; on success it already invalidates `dasSubJobKeys.all`, `subJobsByJobKeys` and `dasAllocationKeys.bySubJob`.
- **Copy:** only the two strings in REQ-03. Everything else `NOT SPECIFIED`.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `N/A unless Q2 resolves to the mobile ticket view` — not investigated; nothing in this spec specifies mobile.
- **Offline / sync / touch targets:** `NOT SPECIFIED`
- **Push / notifications involvement:** the thing being reported on is the `das.job_ticket_sent` catalog entry (PUSH + IN_APP + EMAIL today); no change to it is asked.

## 7. Shared package — `packages/shared`

- **Types added / changed:** a shared `recipients` response type (D1). Both web and mobile are downstream by construction. Placement (new file under `types/` vs extend `das-map.types.ts`): developer decision (D6).

## 8. Permissions and tenancy

- **Roles permitted / denied:** `NOT SPECIFIED`
- **Tenant isolation:** standard. The send already runs under `TenantContextService.getTenantCompanyId()`.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `recipients[].email` / `phone` | optional per D1; format, masking `NOT SPECIFIED` | developer-direction | `[UNVERIFIED]` |
| `recipients[].channels` | values `EMAIL | PUSH | SMS…` per D1; allowed set `NOT SPECIFIED` | developer-direction | `[UNVERIFIED]` |
| `notReached` reason | enum or free text `NOT SPECIFIED` | — | — |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | recipients built correctly for: employee with account, without account (invited), invite failure, vendor, no contact | REQ-02 (cases blocked by Q4-Q6) |
| Integration (API) | send response includes `recipients`; additive keys leave `sent`/`ticketsSentAt` unchanged | REQ-02 |
| E2E / manual | toast action opens dialog listing recipients | REQ-03 |

- Requirements with no testable acceptance criterion: REQ-01, REQ-04, REQ-05, REQ-06.

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`. Reading delivery rows per employee (D5 option b) adds queries per send.
- **Concurrency:** `sendTickets` sets `ticketsSentAt` after the loop; two concurrent sends could both pass the idempotency check — existing behaviour, relevant to REQ-05.
- **Audit / activity log:** `N/A` — not asked; creation is already logged per ticket.
- **Rollout order:** shared type -> API (additive) -> web.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `apps/web/.../services/das-allocations.service.ts:74` | send response type (inline) | REQ-02 | OPEN — see Q7 for early-return shape; otherwise additive | — | `git grep -n "sendTickets\|tickets/send" -- apps packages qa-automation` |
| `apps/web/.../hooks/use-send-job-tickets.ts:18` | success toast copy | REQ-03 | changes deliberately (copy replaced) | developer-direction | same |
| `apps/web/.../tickets/components/send-ticket-modal.tsx:96-98` | closes on success | REQ-03 | OPEN — dialog must outlive modal; no source on where it lives | — | same |
| `apps/api/src/usecase/demo-data/demo-flows.service.ts:649` | `sendTickets` return | REQ-02 | unchanged (reads `sent.sent`) | `N/A` additive | same |
| `job-tickets.service.ts` `reassignTicket` (`:661`) | `sendEmployeeTicketNotification` if its return type changes | REQ-02 | OPEN — Q for siblings in §11c | — | `git grep -n "sendEmployeeTicketNotification" -- apps/api/src` |
| `job-ticket-notification.service.ts` `renotifyForScheduleIntervals` (`:270`) | same | REQ-02 | OPEN — as above | — | same |
| `qa-automation/e2e` | old toast string / `das-tickets-*` ids | REQ-03, 01 | unchanged — no hits found | `git grep` over `qa-automation` | `git grep -n "Job tickets sent\|das-tickets\|send-ticket" -- qa-automation apps/web` |

- **Surfaces with no existing behaviour in this area:** mobile — `git grep` for the send endpoint under `apps/mobile` returned no hits; whether the mobile ticket view or reminder email shows a contact was not investigated (Q2).
- **Consumers with no source for what happens to them:** the idempotent-return consumer (Q7); the two other notification call sites (§11c); the modal-closes-on-success flow (Q1/D8).

## 11b. Developer decisions — structure is the developer's call

D1-D3 are the developer's direction **relayed in the elaboration brief by the invoking agent**, recorded here as decided by the named developer. The elaborator did not choose them; Jahanzaib Nadeem should confirm the rows are transcribed as he meant them. D5-D8 are open.

| ID | Decision | Options (with existing code found) | AI note | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | API shape of the send response | extend `POST .../tickets/send`; or a new GET for the send report | recipients per employee: name, employeeCode, email?, phone?, channels (EMAIL/PUSH/SMS…), invited (bool), notReached? (reason); shared type in `@tcg/shared`; run contract-tracer on callers; idempotent path currently returns `{sent, ticketsSentAt}` early — what it returns is **open (Q7)** | extend the existing POST response with `recipients` as listed | Jahanzaib Nadeem (relayed) | 2026-10-14 |
| D2 | UI | toast only; toast + dialog; panel in the modal | "probably in the toaster" was the first wording | success toast "Tickets sent to N employees" + "View recipients" action opening a small dialog (person, where it went email/phone/app, anyone not reached) | Jahanzaib Nadeem (relayed) | 2026-10-14 |
| D3 | Unreachable employees | flag in response + dialog; log only (today) | invite failure is only a `logger.warn` today | flag employees who could not be reached (no contact on file; invitation failed) — criteria **open (Q5)** | Jahanzaib Nadeem (relayed) | 2026-10-14 |
| D4 | Process | full loop; triage-only | — | run the full AI-DLC loop (Path A) | Jahanzaib Nadeem (relayed) | 2026-10-14 |
| D5 | How the send learns per-channel outcome | (a) change `NotificationService.notify()` from `void` to a result and thread it through `sendEmployeeTicketNotification`; (b) after `notify`, read `NotificationDelivery` rows for the ticket (`notification.service.ts` `createDelivery`); (c) report eligibility only, derived from the same inputs as the channel list (no delivery truth) | (c) is cheapest but cannot honour "failed"; (a) touches every `notify` caller (`git grep -n "notify("`); (b) adds queries and reads `PENDING` rows if timing races. Recommendation deferred until Q5 says which truth is wanted | | | |
| D6 | Where the type and builder live | shared type: new file in `packages/shared/src/types/` vs `das-map.types.ts`; builder: inside `JobTicketsService.sendTickets` vs a method on `JobTicketNotificationService` | — | | | |
| D7 | Auto-invite result | keep `catch` -> `logger.warn` and also record the failure for the report; capture the returned `InviteDelivery` (`channel`, `maskedDestination`) | reuse of existing return value, no new service | | | |
| D8 | Recipients dialog | reuse an existing dialog/list component (search all nine `components/` dirs first); new feature component under `features/das/.../tickets/` | `Dialog` primitives are already imported by `send-ticket-modal.tsx` | n/a — no dialog, superseded by D9 | Jahanzaib Nadeem | 2026-10-15 |
| D9 | UI, revised (supersedes D2's dialog) | toast with a short list cut at N + "+N more"; keep the Send Ticket modal open on a results step; dialog behind "View recipients" | — | toast with a short list; "+N more" expands in place | Jahanzaib Nadeem | 2026-10-15 |
| D10 | How the list gets into the toast | extend the shared `lib/toast-core.ts` / `lib/toast.ts` with `items` + `visibleItems`; a DAS-only React toast | the app toast is hand-rolled DOM (title + message only) | extend the shared toast | Jahanzaib Nadeem | 2026-10-15 |
| D11 | Toast defaults | 3 rows, success 10s, warning sticky; 3 rows, 4.5s; 5 rows, 10s / sticky | expanding also pins the toast | 3 rows; success 10s (hover or expand pauses); warning stays until closed | Jahanzaib Nadeem | 2026-10-15 |
| D12 | Where the full invite destination comes from | add `destination` to `InviteDelivery`; re-derive via `resolveInviteChannel()` in `sendTickets` | adding it also exposes it on the admin invite/resend responses, which no consumer reads (contract-tracer) — whether to strip it there is **open** | add to `InviteDelivery` | Jahanzaib Nadeem | 2026-10-15 |
| D13 | Where the ticket's own delivery comes from (answers D5) | `sendEmployeeTicketNotification` returns `{ email?, push } \| null`; re-derive in `sendTickets` | D5's (a)/(b) not taken: reports eligible channels attempted, not provider outcome | notifier returns its delivery | Jahanzaib Nadeem | 2026-10-15 |
| D14 | Where the types live (D6) | `@tcg/shared`; API usecase exports + a web mirror in `features/das/.../tickets/types` | built as API exports (`SendTicketsResult`, `SendTicketRecipient`) + a hand-mirrored web type — **chosen by the AI while building, not asked**; mirror is not compile-checked against the API | | | |

Pattern: none (`patterns.md` has no action-endpoint entry).

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Decided by | Enumerated by |
| --- | --- | --- | --- | --- |
| `reassignTicket` — new occupant notified (`job-tickets.service.ts:661`) | none | **open — asked 2026-10-15, unanswered (Q10)**; not done in `1cacbbafe` | | `git grep -n "sendEmployeeTicketNotification" -- apps/api/src` |
| `renotifyForScheduleIntervals` — re-notify on schedule change (`job-ticket-notification.service.ts:270`) | none | **open — asked 2026-10-15, unanswered (Q10)**; not done in `1cacbbafe` | | same |
| Admin invite / resend (`InvitationsService.invite/resend`) — already returns masked `InviteDelivery` | none | | | `git grep -n "InviteDelivery" -- apps/api/src` |
| Mobile ticket view / Job Reminder Email | none | depends on Q2 | | not enumerated — Q2 first |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until answered.

### Q1 — Does the post-send report replace or sit beside the ticket's pre-send Contact column?

- **Question:** Do we build (a) only the post-send report (toast + "View recipients"), (b) only the pre-send Contact column, or (c) both? Option (c) means the column must be labelled "email on file" and the dialog says where it actually went.
- **Why it cannot be answered from what is written:** the ticket asks for the column; the developer asked for the report. The requester has answered neither. Nothing in `dispatch/` specifies either.
- **Blocked:** REQ-01 (whether it exists), scope of REQ-02/03.
- **Candidates:** `uat/sessions/uat-session-3.md` (4.7 KB, source_last_modified 2026-09-14); `uat/register-2026-09-18.md`; `dispatch/daily-allocation-system.md` (9.6 KB, 2026-04-30, unverified); Linear TCG-62. None specifies.
- **Owner:** the UAT 3 reporter (unnamed on the ticket; page author Umair Khan), via Fouzan Shakil as ticket assignee; Syed Haris as ticket creator.
- **Workaround, if any:** the REQ-02 additive response field is independent of the column; it could proceed alone as a labelled workaround, only after Q4-Q8 settle its field meanings.
- **Developer answer (Jahanzaib Nadeem, 2026-10-15):** Built: the post-send report only (commit `1cacbbafe`). The pre-send column is not built; this question stays with the requester. Product-owner confirmation not recorded; status left open until it is.
- **Status:** open

### Q2 — Which surface did the UAT bullet mean?

- **Question:** "On the Send Ticket, the email should be shown" sat under `### Atom Mobile App` after a Job Reminder Email bullet — is it the web DAS Send Ticket modal, the mobile ticket view, or the reminder email?
- **Why it cannot be answered from what is written:** the page gives one line with no screen name; the register's routing to web is an interpretation.
- **Blocked:** REQ-01 and the surface of REQ-03; §6.
- **Candidates:** `uat/sessions/uat-session-3.md:55-59`; `uat/register-2026-09-18.md:239`; `dispatch/gaps.md` entry *Branch fix/12-sep-uat — ticket assignment/reschedule/reminder emails* (open; asks the reminder email's field set; does not list a contact).
- **Owner:** the UAT 3 reporter, via Fouzan Shakil.
- **Workaround, if any:** none.
- **Status:** open

### Q3 — Pre-send column: which contact, and on file or used?

- **Question:** If the column survives Q1: email, work cell, or both — and is it "on file" or "the channel the ticket actually uses"?
- **Why it cannot be answered from what is written:** the ticket leaves it to the requester; `Employee.email` and `workCellPhone` are both NOT NULL, so both always have a value regardless of deliverability.
- **Blocked:** REQ-01.
- **Candidates:** `schema.prisma:4154,4172`; `admin/gaps.md` *Sign-in identity...* (open, owner Patrick McKiernan / Brian Petros / Kyle Harlow — field employees have no Microsoft mailbox, work cell mandatory?).
- **Owner:** the UAT 3 reporter; deliverability facts: Brian Petros (named on the Sign-in identity entry).
- **Workaround, if any:** none.
- **Status:** open

### Q4 — What does "phone" and "channels used" mean when ticket notifications never use SMS?

- **Question:** At HEAD ticket notifications go PUSH + IN_APP (user account) and EMAIL only; SMS is sent only for the account invite (first dispatch, by `resolveInviteChannel`: field crew with a +1 work cell get a text, everyone else an email). Should the dialog show (a) the number an *invite text* went to, only for newly invited people; (b) the work cell on file for everyone; or (c) no phone at all? And should "SMS" appear in the channels vocabulary?
- **Why it cannot be answered from what is written:** the ticket's premise (SMS to work cell) predates the removal of SMS from ticket dispatch (code comment, cost); D1 lists SMS as a channel. No vault note records the SMS decision. This is a stale premise, not a code bug.
- **Blocked:** REQ-02, REQ-04, REQ-06.
- **Candidates:** `job-ticket-notification.service.ts:112-160`; `invitations.service.ts:75-100, 286`; `notification-catalog.ts:371`; `decisions/` — no note on ticket SMS found by filename search.
- **Owner:** product team; Jahanzaib Nadeem for intent of "invitations" in his wording.
- **Workaround, if any:** none.
- **Developer answer (Jahanzaib Nadeem, 2026-10-15):** (a) — a phone appears only as the number an invite text went to; tickets themselves show email and "in app". No SMS in the ticket vocabulary. Product-owner confirmation not recorded; status left open until it is.
- **Status:** open

### Q5 — Attempted, eligible, or delivered — and what counts as "not reached"?

- **Question:** Should the report say what each person was *eligible for* (derived), what was *attempted*, or what *actually succeeded* (email/push provider result)? Which of these makes someone "not reached": no contact at all; auto-invite threw (no email, seat limit, duplicate email); every channel failed or was skipped as unconfigured?
- **Why it cannot be answered from what is written:** `notify()` returns `void`, soft-fails each channel and skips unconfigured ones silently; only `notification_deliveries` rows hold outcomes. Nothing says which outcome a dispatcher must be told.
- **Blocked:** REQ-02, REQ-04, D5.
- **Candidates:** `notification.service.ts:50-200`; `schema.prisma:4610`; `job-tickets.service.ts` auto-invite block (invite failure only `logger.warn`).
- **Owner:** product team (dispatch: Lisette Anzaldo is the named DAS owner on `dispatch/gaps.md`).
- **Workaround, if any:** none.
- **Developer answer (Jahanzaib Nadeem, 2026-10-15):** Eligible channels attempted, not provider delivery. "Follow up" = vendor crew, no email and no account, or auto-invite threw (its message shown). Product-owner confirmation not recorded; status left open until it is.
- **Status:** open

### Q6 — What is "N employees", and are vendors / riding crew listed?

- **Question:** `sent` is `tickets.length` — tickets, not people (one crew set shares an anchor ticket; vendor allocations also get tickets). Should "N" count employees notified, tickets, or all personnel; and are vendor allocations (never notified) and crew who ride another person's ticket listed in the dialog — and how?
- **Why it cannot be answered from what is written:** only code describes `sent` and the crew rule (decisions `2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md`, `2026-09-21-crew-ticket-not-absorbed-operator-and-per-employee-progress.md` fix the ticket shape, not the report).
- **Blocked:** REQ-03, REQ-02.
- **Candidates:** `job-tickets.service.ts:540-560` (`sent: tickets.length`); the two decision notes above.
- **Owner:** product team.
- **Workaround, if any:** none.
- **Developer answer (Jahanzaib Nadeem, 2026-10-15):** N = crew members reached on at least one channel. Vendor crew and riding crew are listed per person; vendors under "Follow up". Product-owner confirmation not recorded; status left open until it is.
- **Status:** open

### Q7 — What does an idempotent re-send return for `recipients`?

- **Question:** When `ticketsSentAt` is already set, should `recipients` be absent/empty, replay the first send's report, or be recomputed from current state?
- **Why it cannot be answered from what is written:** the early return carries no outcome; the first send's result is not stored except as `notification_deliveries` rows.
- **Blocked:** REQ-05; response type in REQ-02.
- **Candidates:** `job-tickets.service.ts` early-return block; `schema.prisma:4610`.
- **Owner:** Jahanzaib Nadeem (developer) with product team for replay semantics.
- **Workaround, if any:** return `recipients: []` on that path — labelled workaround pending the answer; it can mislead a caller into reading "nobody notified".
- **Developer answer (Jahanzaib Nadeem, 2026-10-15):** `alreadySent: true`, `recipients: []`, and the web shows an info toast "Tickets were already sent — Sent <time>. No one was notified again." Product-owner confirmation not recorded; status left open until it is.
- **Status:** open

### Q8 — Show email and phone whole, or masked, and to which roles?

- **Question:** Does the dialog show full addresses/numbers, or masked ones like the admin invite result (`s***@example.com`, `***-***-2210`), and may every user who can send tickets see them?
- **Why it cannot be answered from what is written:** only the invite endpoint sets a precedent; nothing is written for this screen. The send route has no `@Roles` visible in the part read.
- **Blocked:** REQ-06, REQ-03.
- **Candidates:** `invitations.service.ts:47-50`; `phone-e164.util.ts` `maskPhoneE164`.
- **Owner:** product team.
- **Workaround, if any:** none.
- **Developer answer (Jahanzaib Nadeem, 2026-10-15):** Full, not masked. Roles not separately decided — everyone who can send tickets sees them. Product-owner confirmation not recorded; status left open until it is.
- **Status:** open

### Q9 — Strip the full invite destination from the admin invite / resend responses?

- **Question:** D12 added `destination` (full E.164 or email) to `InviteDelivery`, which `POST /employee/:employeeCode/invite` and `/resend-invite` return unfiltered. Before, those routes returned only `maskedDestination`. Strip it there (keep it internal to `sendTickets`), or leave it since only `@Roles(Role.ADMIN)` reaches them?
- **Why it cannot be answered from what is written:** a side effect of D12, found by `tcg-contract-tracer` after the build; nothing written covers PII on those responses. No consumer reads it — web types the body as `{ message: string }` (`features/employees/api/invite-employee.ts`), mobile and qa-automation do not read it.
- **Blocked:** nothing functional; the PR's review of D12.
- **Candidates:** `invitations.service.ts:47-53`; `employee.controller.ts:203-215`.
- **Owner:** Jahanzaib Nadeem (developer). AI recommendation: strip it from those two routes.
- **Workaround, if any:** none needed — it ships as is until answered.
- **Status:** open

### Q10 — Do reassignment and schedule-change notifications get the same "who was reached" report?

- **Question:** `reassignTicket` (new slot occupant) and `renotifyForScheduleIntervals` (time change after send) call the same notifier, which now returns its delivery, but both discard it and raise no recipients report. Should either show one?
- **Why it cannot be answered from what is written:** sibling question from §11c; asked twice in the 2026-10-15 session, unanswered.
- **Blocked:** §11c rows 1-2.
- **Candidates:** `job-tickets.service.ts` `reassignTicket`; `job-ticket-notification.service.ts` `renotifyForScheduleIntervals`.
- **Owner:** Jahanzaib Nadeem (developer).
- **Workaround, if any:** none needed — they behave exactly as before.
- **Status:** open

### Q11 — TCG-62 ships on a three-ticket branch

- **Question:** `1cacbbafe` sits on `fix/14-oct-uat` with TCG-49 (`17474ab2c`) and TCG-58 (`ba66ee705`). Root `CLAUDE.md` → *One unit, or one independent task, per PR* wants it alone: cherry-pick onto `feat/TCG-62-send-ticket-recipients` from `origin/main`, or keep the batch with a written reason?
- **Why it cannot be answered from what is written:** the rule is written; whether to apply it to this UAT batch branch is the developer's call. TCG-62 alone is 352 source lines / 12 files (measured with the CLAUDE.md `git diff --numstat` command against HEAD~), within budget.
- **Blocked:** the PR.
- **Candidates:** root `CLAUDE.md`; `commit` skill §1.
- **Owner:** Jahanzaib Nadeem (developer).
- **Workaround, if any:** none.
- **Status:** open

## 13. What this spec deliberately does not specify

- The pre-send Contact column — no source; Q1-Q3.
- The meaning of `phone` / `channels` / `invited` / `notReached` — Q4-Q6.
- Recipients on re-send — Q7.
- Masking and role visibility — Q8.
- Mobile or reminder-email contact display — Q2.
- Any change to which channels ticket notifications use (not asked).

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [ ] Every `[CONFLICT]` requirement has a decision note (none)
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every §11a ripple row has a source or a §12 question
- [ ] Every §11b row has _Chosen_ and _Decided by_ filled by a developer (D5-D8 blank)
- [ ] Every §11c sibling has a developer's yes / no / follow-up
- [ ] Decomposed into vertical units — `units.md` (not started; not part of this run)

Answered by: ______________  Date: ______________
