# Intent — SCRUM-OFFLINE-SYNC

Field-ticket steps must keep every value the crew enters on the device as it is entered,
work offline end to end, and prove every step reached the backend before the ticket
completes.

No Jira ticket exists — Jira was unavailable when this was requested (2026-09-24). The
folder is named `SCRUM-OFFLINE-SYNC` so the `SCRUM-*` open-question sweep still finds it,
the same device as `SCRUM-PENDING` / `SCRUM-TZ`. Rename the folder if a Jira issue is
created later.

---

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-OFFLINE-SYNC` — no Jira issue; folder name only |
| Title | Persist ticket step data locally as captured; offline sync and pre-submit verification |
| Type | Story |
| Status | Not tracked in Jira |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | Session user (`mohsin.ali@codingcops.com`) — stated directly in a working session |
| Assignee | `NOT ON TICKET` |
| Captured on | `2026-09-24` |
| Captured by | Claude Code session, from the request below |

## 2. Business intent

- Intent: a crew member who fills part of a step, leaves the ticket flow, and comes back
  must find what they entered, not a blank step. A crew working in a remote area with no
  signal must be able to complete every step on the device, and nothing may be lost between
  the device and the backend before the ticket is marked complete.
- Who benefits (role): field crew; downstream payroll/dispatch, which read the backend copy
- What is worse today without it: most step fields live in React state only and are wiped
  on exit; photos upload at capture and are lost if the upload is interrupted; offline
  Next is blocked; `submitTicket` completes a ticket without checking any step reached the
  server.

## 3. Definition of done, as the ticket states it

Verbatim from the session request:

```
Right now we are not persisting  all the information that is filled on each step in local
storage, and are only persisting to backend and local only when we click on the button that
move the ticket to next step

We also need to update and persist all the data as soon as that is captured in all ticket
steps in local storagae so that if employee fill the data but has not moved to next step and
exit teh ticket flow and then comes back. The data he filled should still be populated
instead of wiped out and he is required to fill that again!

On each step when moving to next step then we are pwersisting that ticket step data to
backend which is correct.

Now, before submitting the ticket to backend at last step after the work time save in DB and
before teh ticket gets compeleted. We need to add a new layer which scans all the previous
steps and comparies the locally persisted data with that of server side persisted data. We
need to make sure that all teh ticket steps data is persisted on backend before the actual
ticket gets completed

The photo upload will work on this same exact principle that when we upload a photo or
attachment it will be upload in loacl mobile storage firrst with single green ticket. And it
should be persisted to backend and S3 only when we click on the ticket that moves to the next
step
```

Decisions given in the same session, in answer to the review (verbatim):

```
1. We need to keep as it is for now
2. agree with you that if offline in a remote area, we need to recod all steps data locally
   and on ticket submit we need ctach it up and make sure all data is saved at backedn
   before the ticket gets completed
3. I do not get your point
4. In this ticket
5. There is no Jira ticket for this as Jira is not working atm
```

What each answer refers to:
1. Start Work lunch / build-up / boom / breakdown / End Work writes keep going to the
   backend on each tap while online (not deferred to Next).
2. Offline, Next completes the step locally; everything is caught up before the ticket completes.
3. Unanswered: whether a verification mismatch is re-sent automatically or the employee
   is asked. See §12.
4. The server-side submit check is in scope for this ticket.
5. No Jira issue.

Decision given 2026-09-25 regarding photo and attachment uploads (verbatim):

```
We need to revert back to how we were uploading the images before this branch change
which is that we upload to first mobile local storage and then roght away upload the
image to backedn and S3 bucket and use S3 preview URL to display the image!

This chnage we need to do is for only photos and attchments. Nothing else needs to be change!
```

What this changes:
- Photos and attachments in ticket steps are uploaded immediately to the backend and S3 upon
  capture, displaying the authenticated S3 preview URL (single tick in-flight, double tick
  once uploaded).
- This applies ONLY to photos and attachments.
- Drawn signatures remain deferred/local-first until step Next or offline catch-up.
- The pre-submit data verification layer and offline step sync behavior remain active.

Decision given 2026-09-25 regarding offline submit and background sync (verbatim):

```
What we need to do is that if the mobile app is offline then we need to sync all the data
on mobile local device including the images uploads and even if ticket is submitted when
internet connectivity is offline then we do not need to block the ticket submit. We need to
complete that ticket and save it in mobile local storge. And in the background we need to
listen to the internet, as soon as the internt comes back we need to scan the tickets that
are completly or partually residing on mobile local storage and auto save them to backend
without affacting main thread/ mobile UI.
```

What this changes:
- Reverses online-only submit (Decision D1): offline submit is NO LONGER blocked at the Review screen.
- When offline, ticket submission completes locally:
  - Generates offline submit ref (`OFFLINE-{timestamp}`), marks `submitState: 'submitted'`, sets `active: TICKET_TOTAL + 1`.
  - Persists full ticket draft to local storage (`AsyncStorage`).
  - Does NOT delete local photo files or wipe the draft while unsynced.
  - Displays `SubmitSuccessModal` so the crew member can proceed.
- Background sync engine (`background-sync.ts`):
  - Listens to `NetInfo` connectivity events across the mobile app.
  - As soon as connectivity returns, scans all drafts stored in local storage (`ticket:*`).
  - For partially completed tickets: uploads pending local attachments and drains pending step ops without blocking UI.
  - For completely completed/offline-submitted tickets: drains pending step ops (including `review` work time punch), submits the ticket payload to the backend, deletes local photo files, and removes the draft from storage upon confirmed backend success.
  - Uses asynchronous cooperative yielding (`setTimeout(0)`) between each write/upload step to guarantee zero UI jank or main-thread freezing.
  - Invalidates React Query tickets and checklists caches once synchronization succeeds.

Decision given 2026-09-25 regarding warning notifications and local-first saves (verbatim):

```
When submitting the ticket I get this warning that ticket data is saved on local device. and it
will save on server when onlie. But my device and server is online. And it saved to backend
successfully! We should not have this notification. Pleae review.

Same thing is happening for Breakdown and build Up when their timer stops. These warning
notifications are displayed there as well. That these are saved on local mobile storage and is
not saved on server. We do not need to show any warning that data saved on local and is not on
server. We need to first save it on local mobile async storage and sync with server behind the
scenes.
```

What this changes:
- All warnings indicating that data is saved locally on the device and will sync later are eliminated across the entire mobile flow.
- Local mobile AsyncStorage persistence happens first, silently and immediately.
- Positive confirmation toasts are displayed for timer and user actions (`Build up started`, `Build up complete · boom time started`, `Break-down started · boom time closed`).
- Backend synchronization runs behind the scenes without noisy failure toasts for transient connectivity or deferred sync states.
- Handled PostgreSQL serialization conflicts (`P2034` / `40P01` deadlock) with automatic jittered retry in `TicketTimeEntriesRepository.runSerializable`.
- Prevented breakdown and work segment timing inversion errors (`Break-down cannot start after it ends`): ensured client enforces minimum 1-second gap (`Math.max(rawEnd, start + 1000)`), and backend auto-advances identical start and end timestamps by 1 second rather than throwing false inversions.

- Acceptance criteria present on the ticket: no (behaviour described, no AC list)
- `OPEN — no acceptance criteria; the elaborator should propose them from §3 for sign-off`

## 4. In scope

- [ ] Every user-editable value on every ticket step is written to the on-device draft as it changes, and restored when the step is reopened
- [ ] Photos and attachments: uploaded immediately when online; saved to device local storage with `local:<id>` references when offline
- [ ] Next while online saves the step to the backend before advancing (as today)
- [ ] Next while offline completes the step locally and marks it as waiting to sync
- [ ] Submitting offline completes the ticket locally, saves to AsyncStorage, and displays completion UI without blocking
- [ ] Background sync engine listens to NetInfo and automatically syncs pending step ops, uploads offline photos, and submits offline-completed tickets when connectivity returns, without affecting the main thread or UI responsiveness
- [ ] Before the ticket completes online: all queued step data is caught up, Work Time is closed, then every step's device copy is compared with the server copy; the ticket completes only if all steps match
- [ ] The backend `POST /field/tickets/:id/submit` refuses to complete a ticket whose required step data is missing
- [ ] The ticket flow can be reopened offline after an app restart
- [ ] A checklist records the time the crew actually finished it, including when it syncs later from offline

## 5. Out of scope

- [ ] Moving Start Work's per-tap backend writes to Next (decision 1, "for now")
- [ ] Showing "pending sync" state to dispatch on web
- [ ] Ticket comments, incident/SOS reports and the ticket attachments sheet, which are not step data (they stay online-only)
- [ ] Conflict resolution between two devices editing one ticket

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | submit guard; idempotent attachment upload; signature/lunch attachment delete |
| `apps/api/prisma` (schema + migration) | yes | `attachments.client_upload_id` (idempotent upload); no change for checklist time — `checklist_assignments.submitted_at` already exists |
| `apps/web` (Next.js) | no | |
| `apps/mobile` (Expo Router) | yes | store, every step body, capture/upload hooks, sync engine, query-cache persistence |
| `packages/shared` (types shared across apps) | yes | the ticket step catalogue and per-persona visible/required step list move here (decision 2026-09-24, §12), consumed by mobile and the API submit guard |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `JobTicket` | `ticketCode` | reads; submit gains a precondition |
| `Attachment` | none | creates (upload), possibly a new idempotency column |
| `TicketTimeEntry`, `TicketSignature`, `TicketStepCompletion`, `ChecklistItemAnswer`, `TicketEmployee` | none | written by replayed step syncs; no schema change expected |

- New entity introduced by this ticket: no
- New code prefix introduced: no
- Existing rows affected: no

## 8. Roles and permissions

- Roles that can perform this: the ticket's primary crew member (existing `getTicketForEmployeeAction` rule)
- Roles explicitly excluded: secondary crew (read-only today, unchanged)
- Tenant scope: standard per-tenant isolation

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` |
| Jira attachments | N/A — no Jira issue |
| Related tickets | `NOT ON TICKET` |
| Existing repo docs | `design/plan.md` in this folder (session review + plan, 2026-09-24) |
| Vault area the reader thinks is relevant | `field-ops/field-ops-frd/08-functional-requirements/fr-fop-007-ticket-draft-management.md` (FOP-002 v2.0, unverified, has conflicts); `field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-039-auto-save.md` and `07-non-functional-requirements.md` → Auto-save (FOP-001 v1.1, unverified) |

## 10. Terms used that may not be defined

- "single green tick" — used as: "upload in local mobile storage first with single green ticket". Read as: the existing `SyncStatusBadge` `local` state, with `server` as the uploaded state. To confirm.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| none | — |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 5 — epic, sprint, assignee, design handoff, related tickets
- Fields left as `OPEN`: 1 — acceptance criteria
- Is this ticket, as written, buildable without a product answer? yes, once the default below is confirmed
- Answered in session, 2026-09-24 (session user):
  - **Required steps per persona:** "yes, move to shared". The step catalogue and
    the per-persona list go into `@tcg/shared`, and the API submit guard and mobile both read them.
  - **Checklist completion time:** "No checklists must record the time the crew actually
    finishes it". `submittedAt` must be the device finish time, not the server's sync time.
  - **New mobile dependencies:** "Yes, its ok to install them". The three are
    `@tanstack/react-query-persist-client`, `@tanstack/query-async-storage-persister` and `expo-crypto`.
- Still to confirm (the plan proceeds on the default):
  - **A verification mismatch before completion:** the plan resends the step from the
    device automatically, and blocks with a per-step list only if the resend fails. The
    question was explained in session; it was not objected to, and not explicitly confirmed.

---

**Next step:** run the elaborator against this file to produce `spec.md`.
