# Intent — SCRUM-PROGRESS

Job detail's **Progress Tracking** tab: from the office, see how each crew member's field ticket
is going on each scheduled day of a job.

No Jira ticket exists. The folder is named `SCRUM-PROGRESS` so the `SCRUM-*` open-question sweep
(`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md`) still finds it — the same device
as `SCRUM-PENDING` and `SCRUM-TZ`.

---

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-PROGRESS` — no Jira issue; folder name only |
| Title | Implement Projects → Job → Progress Tracking |
| Type | Story |
| Status | Not tracked in Jira |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | Syed Haris (`syedharis14@gmail.com`) — stated directly in a working session |
| Assignee | `NOT ON TICKET` |
| Captured on | `2026-09-11` |
| Captured by | Claude Code session run by Syed Haris (client-repo git identity `devmohsinakram`) |

Requested in-session, not through Jira. Everything below is a snapshot of that request.

## 2. Business intent

The request, verbatim, together with a design file:

> we need to implement projects=>job=>progress tracking

- Intent: `NOT ON TICKET` in business terms. The most likely reading — **a reading, not a sourced
  requirement** — is that dispatch wants to see, without phoning the crew, where each crew
  member is in the day's field flow and what they captured: signatures, checklists and
  deficiencies, incidents, boom and billable hours. The one vault line on the subject says the
  same thing more thinly: *"Progress Tracking shows status updates from crew check-in to
  completion steps"* ([`vault/projects-jobs/project-module/07-create-and-manage-jobs-excluded.md`](../../vault/projects-jobs/project-module/07-create-and-manage-jobs-excluded.md):51
  — `status: unverified`, and from a story titled *Excluded*).
- Who benefits (role): dispatcher / operations. `NOT ON TICKET` beyond the design's framing.
- What is worse today without it:
  - the tab exists and renders `Progress Tracking — coming soon`
    (`apps/web/src/features/projects/jobs/job-details/view-job.tsx`, the tab list's fall-through
    branch);
  - every ticket capture the mobile app makes is readable **only by the employee who owns the
    ticket** — each `/field/tickets/*` read calls `getTicketForEmployeeAction`
    (`apps/api/src/usecase/job-tickets/job-tickets.service.ts`) and 403s anyone else. The office
    has no read path at all.

## 3. Definition of done, as the ticket states it

```
we need to implement projects=>job=>progress tracking
```

…plus the design file (see §9) and the four answers in *Session decisions* below.

- Acceptance criteria present on the ticket: **no**
- `OPEN — no acceptance criteria; per domain/jira-sop.md this does not meet Definition of Ready.`
  The design and the four session decisions are the nearest thing to criteria and are all the
  elaborator has to source from.

## 4. In scope

Per *Session decisions* D1–D4.

- [ ] Job detail → **Progress Tracking** tab replaces the "coming soon" empty state.
- [ ] Left rail: the job's **scheduled dates**, each with its day status, expandable to that
      day's tickets (ticket code + ticket status badge).
- [ ] Nothing selected → empty state. Date selected → one card per ticket. Ticket selected →
      ticket detail.
- [ ] Ticket detail — **timeline** of the steps the ticket's role actually has (14 for an Oiler,
      9 for every other role), each step expandable to what was captured at it; incidents shown
      where they were filed; End Work shown from its captured time.
- [ ] Ticket detail — **scheduled on-site and scheduled end times shown beside the actuals**,
      display only (D2).
- [ ] Ticket detail — **checklists** section (Pre-Trip per asset, JSA, Post-Trip per asset) with
      each answer and each deficiency's reason / priority / photo.
- [ ] Ticket detail — side column: **employee details** with call / email links, and a **shift
      summary** (current phase, step *n* of *N*, progress bar, boom hours, net billable,
      incidents, deficiencies).
- [ ] Ticket and step **status rules** per D3, including *Incomplete* (which ships last — see D3).
- [ ] **Comments thread**: the ticket's existing comments, readable and postable from the web (D4).
- [ ] New **web-facing read endpoint(s)** for another employee's ticket, and a web-facing
      **comment post**.
- [ ] The `qa-automation` spec that asserts the "coming soon" text, updated in the same change
      (`qa-automation/e2e/specs/projects/1-lifecycle.spec.ts`, the Progress Tracking tab check).

## 5. Out of scope

- [ ] The **top-level "Daily Progress Tracking" sidebar module** — date navigator, project rail,
      job accordions, full-ticket page, **printable ticket report / Download PDF** (D1). The ticket
      detail is to be built so that module can reuse it later.
- [ ] **Send Reminder** — by email or push (D4).
- [ ] **Live Tracking map**, odometer, drive ETA / distance, geofence notice, GPS on steps, GPS on
      deficiencies (D2 — none of it is captured).
- [ ] **Flagging late arrival or overrun** against the schedule — the scheduled times are display
      only (D2); the design's variance colouring is not in scope.
- [ ] The design's **ticket info modal** (`PT_TICKET_INFO`) and **status-count KPI card**
      (`ptTicketSummary`) — both unreachable in the design itself (`design/README.md`).
- [ ] Any change to the **mobile app** or to what it captures.
- [ ] **Editing or correcting** any captured value from the web.
- [ ] The design's four-question **Compliance checklist** — the real Compliance step is a
      signature row (per-diem + one attestation); the design's questions have no capture.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | New read endpoint(s) for a job's schedule days → tickets → ticket progress; a web-facing comment post; possibly a socket event |
| `apps/api/prisma` (schema + migration) | ? | Believed **no** — every value in scope is already captured. The elaborator should confirm |
| `apps/web` (Next.js) | yes | The Progress Tracking tab and the reusable ticket-progress components |
| `apps/mobile` (Expo Router) | no | Out of scope (§5) |
| `packages/shared` (types shared across apps) | yes | The new response contract, so web is compile-checked against it |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `Job` | `jobId` / `JOB-#####` | reads (route param, as on job detail) |
| `JobTicket` | `ticketCode` | reads |
| `JobScheduleInterval` / `SubJob` / `JobResourceAllocation` | UUID only | reads |
| `Employee` / `EmployeeType` | — | reads (name, phone, email, role) |
| `TicketStepCompletion`, `TicketTimeEntry`, `TicketSignature`, `TicketIncidentReport`, `ChecklistAssignment`, `ChecklistItemAnswer` | UUID only | reads |
| `TicketComment` | UUID only | **creates** (web post, D4) and reads |
| `Attachment` | — | reads (signature, identity, checklist and incident images) |

- New entity introduced by this ticket: no (believed)
- New code prefix introduced: no
- Existing rows affected (backfill / migration of data): no

## 8. Roles and permissions

- Roles that can perform this: `NOT ON TICKET`.
- Roles explicitly excluded: `NOT ON TICKET`.
- Tenant scope: standard per-tenant isolation.
- `OPEN — who may read another employee's ticket from the web, and who may post a comment on it?`
  Today jobs routes carry no `@RequirePermission` at all, and a plain `USER` with no department
  role is granted `jobs:view` by default (`guard/permissions.guard.ts`) — so gating on
  `jobs:view` alone would let a field-worker account read every colleague's ticket.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | [`design/`](design/README.md) — extract of `TCG Platform (standalone) for pregress tracking.html`, with provenance and a line index. **Section A only** is in scope |
| Jira attachments | `N/A — no Jira issue` |
| Related tickets | `SCRUM-PENDING` — payroll overlay of unfinished tickets; wrote `deriveTicketProgress` and the 2026-09-10 decisions this view must agree with · `SCRUM-TZ` — tenant business timezone, which *Incomplete* depends on (not on `main` as of 2026-09-11: `origin/fix/timezone-business-day`) · `SCRUM-877` — Labor & Unit fields |
| Existing repo docs | `apps/api/src/usecase/job-tickets/ticket-step.constants.ts` (step → time-entry edge map, with the window diagram) |
| Vault area the reader thinks is relevant | `vault/projects-jobs/project-module/02-view-manage-job-details.md` (lists the tab); `…/07-create-and-manage-jobs-excluded.md`:51; `vault/decisions/2026-09-10-current-phase-is-the-latest-open-capture-else-the-last-closed.md`; `…/2026-09-10-unstarted-tickets-date-by-schedule-interval-and-go-overdue-at-estimated-end.md`; `…/2026-09-10-locked-hours-are-elapsed-clock-time-unpriced.md`; `…/2026-09-09-business-timezone-is-a-tenant-property.md`; `…/2026-09-09-business-day-starts-at-midnight-local.md` |

## 10. Terms used that may not be defined

- **Opened / Not opened** — design badge, `ptOpenBadge`. No capture records a ticket being opened.
- **Flagged**, **Incomplete**, **Blocked** — design ticket and step states (`ptVis`, `ptTicketStatus`).
- **Ticket Sent / Allocation Completed / Open** — the design's per-date statuses (`PT_SCHEDULES`);
  resemble the DAS sub-job stages (`SubJob.dasStage`).
- `tailboard-jsa`, `boom-time`, `build-up` — on the vault's known-undefined list; the design uses
  all three.
- **Net billable**, **boom hours** — design shift-summary fields.

## 11. Numbers, thresholds and enumerated values

| Value | Where it came from |
| --- | --- |
| **15-step** field flow | Design (`PT_STEP_META`, `ptAllPending`). **Superseded by D2** — the real flow is 14 / 9 steps |
| 7 step states (done, progress, pending, skipped, flagged, incident, incomplete) | Design (`ptVis`) |
| Ticket badge precedence INCOMPLETE → FLAGGED → COMPLETED → Opened / NOT OPENED | Design (`ptStatusBadge`) |
| `pct = step / total` | Design (`ptTicketStatus`); D3 makes it *steps done ÷ steps for that role* |
| "within **500 m** of the job site" geofence | Design (`ptStepDetail`, driving). Out of scope (§5) |
| "Per-diem eligible (**≥ 50 mi**)" | Design (`PT_CK_DEFS` compliance). Not captured; out of scope (§5) |
| Checklist item counts (Crane 17, Tractor 26, Trailer 4; JSA 6) | Design mock copy — **the real items are the tenant's `Checklist` rows**, not these |
| Deficiency priorities Low / Medium / High / EMERGENCY — Blocking | Design (`ptPriorityTone`); the schema enum is `LOW / MEDIUM / HIGH / EMERGENCY` |
| Shift estimated end, 5:00 PM etc. | Design mock; D3 reads it from `JobScheduleInterval.estimatedEndTime` / `secondShiftEstimatedEndTime` |

## Session decisions

Asked by the capturing session on 2026-09-11 and answered by Syed Haris, who picked one option
per question. Recorded verbatim — question, the option chosen, and that option's description as
it was shown. `tcg-scrum` records each as a decision note (filenames below). **Syed Haris is a
developer/owner, not the client-side product owner** — the same attribution basis as the
2026-09-10 `SCRUM-PENDING` notes.

### D1 — Scope

> **Q:** Which surfaces should this build cover?
> **Chosen:** *Job tab first (Recommended)* — "Projects → Job → Progress Tracking tab, as you
> described. The ticket timeline is built as its own reusable feature, so the top-level Daily
> Progress Tracking module can reuse it in a follow-up."
> **Not chosen:** *Job tab + Daily module* — "Also build the top-level sidebar module now: date
> navigator, project rail, job accordions, and the full-ticket view with the printable PDF report."

Note: `vault/decisions/2026-09-11-progress-tracking-ships-as-the-job-tab-first.md`

### D2 — Timeline shape

> **Q:** The field app captures less than the design shows. How should the timeline handle that?
> **Chosen:** *Real flow + schedule times (Recommended)* — "Role-based steps (14 for an Oiler, 9
> for everyone else). End Work comes from its captured time, incidents appear where they were
> filed, and scheduled on-site and end times are shown next to the actuals, display only. Data
> the app never captures is left out: odometer, ETA/distance, geofence, per-step GPS, live map."
> **Not chosen:** *Real flow only* (same, without the schedule times) · *Design's fixed 15 steps*
> ("All 15 design steps for every ticket. Oiler-only steps show 'N/A' for other roles, and fields
> with no data show '—'.")

Note: `vault/decisions/2026-09-11-progress-timeline-follows-the-real-mobile-flow-with-schedule-times.md`

### D3 — Status rules

> **Q:** Approve these ticket status rules? The design uses them, but no source defines them.
> **Chosen:** *Approve as proposed (Recommended)* — "All the rules in the preview. Incomplete ships
> last, once the tenant-timezone branch reaches main, because the check has to run in the
> tenant's zone."
>
> The preview shown with it, verbatim:
>
> ```
> Not opened   PENDING/SENT and nothing captured yet
> In progress  something captured, not yet submitted
> Completed    Review & Complete submitted (COMPLETE)
> Flagged      an incident filed, OR any checklist item
>              marked Deficiency, OR customer unavailable
>              at the final signature
> Rejected     shown with its reason; CANCELLED (superseded
>              by a reassignment) is hidden
> Incomplete   not COMPLETE once the shift's estimated end
>              has passed, in the tenant timezone (shift 2
>              uses the second-shift end). No end time on
>              the schedule → end of that business day
> Progress %   steps done ÷ steps for that role (9 or 14)
> Current step the existing 'Currently: … / Completed: …'
>              phase rule (2026-09-10 decision)
> ```
>
> **Not chosen:** *Approve, never Incomplete w/o end* ("a schedule with no estimated end time never
> makes the ticket Incomplete") · *Raw status only* ("No derived Flagged or Incomplete…").

Note: `vault/decisions/2026-09-11-progress-tracking-ticket-status-rules.md`

What D3 does **not** say, for the elaborator to carry rather than settle: how *Flagged* combines
with *Incomplete* and *Completed* (precedence); whether an incident or a deficiency on an already
**Completed** ticket still reads *Flagged*; how step-level states (done / current / flagged /
not reached) are derived; and whether the null-end-time clause here is meant to answer — or only
to sit beside — the identical question still open on `SCRUM-PENDING` (§12 of that spec, from
`2026-09-10-unstarted-tickets-date-by-schedule-interval-and-go-overdue-at-estimated-end.md` →
*The half that stays open*), which is scoped to the payroll overlay.

### D4 — Actions

> **Q:** What should the design's action buttons do (Send Reminder via Email, Contact, Chat)?
> **Chosen:** *Contact + comments (Recommended)* — "Contact is a call/email link from the employee
> record. Chat opens the ticket's existing Comments thread, the one the crew already see on
> mobile, and the web can read and post to it. Send Reminder is left out for now."
> **Not chosen:** *Read-only* · *All three* (adds Send Reminder as a push notification — "needs a
> new notification type") · *No actions*.

Note: `vault/decisions/2026-09-11-progress-tracking-actions-are-contact-links-and-ticket-comments.md`

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 5 — Epic, Sprint, Assignee, business intent, roles.
- Fields left as `OPEN`: 2 — no acceptance criteria (§3); read/post permission (§8).
- Is this ticket, as written, buildable without a product answer? **No** — the permission
  question (§8) and the gaps D3 leaves (above) block parts of it.
- The blocking questions: §8 permission; D3's precedence and step-state derivation. The elaborator
  carries each into `spec.md` §12.

---

## Appendix — session research, for the elaborator to verify rather than trust

Gathered by three read-only searches on 2026-09-11 against `origin/main` @ `25185b04f`. Paths
are as read that day; **re-verify before citing** — line numbers move.

### A. The real mobile flow

Order: `RAW_STEPS` in `apps/mobile/data/mock/fixtures.ts` (a **mock fixture** is the only ordered
list). `getVisibleSteps` (`apps/mobile/data/compose-ticket-detail.ts`) removes the Oiler-only
steps for other roles and **renumbers** — key on the step string, never on `n`. Oiler test:
`employeeType.name === OILER_TYPE_NAME` (`packages/shared/src/constants/employee-types.ts`). A
ticket stores **no role**; it is the ticket employee's allocation slot `JobResource.employeeType`.

| # | Mobile key | Oiler only | What it persists | Timestamp available |
| --- | --- | --- | --- | --- |
| 1 | `pretrip` | yes | `ChecklistAssignment` (PRE_TRIP) per matched asset → SUBMITTED + `ChecklistItemAnswer`s; `TicketStepCompletion('pretrip')` | `ChecklistAssignment.submittedAt` |
| 2 | `leftYard` | | `YARD_TIME.startedAt`; `JobTicket.leftYardComment` | `YARD_TIME.startedAt` |
| 3 | `driving` | | `TicketStepCompletion('driving')` only | its `completedAt` |
| 4 | `arriveJob` | | `JOB_SITE_TIME.startedAt` + `WORK_AT_JOB_SITE_TIME.startedAt` | `JOB_SITE_TIME.startedAt` |
| 5 | `sig1` | | `TicketSignature` sig1 — signer, signature + identity-photo attachments, GPS, `termsAccepted` | `capturedAt` |
| 6 | `jsa` | yes | `ChecklistAssignment` (JSA) + answers | `submittedAt` |
| 7 | `startWork` (Start Build Up) | | `BUILDUP_TIME`, `BOOM_TIME` (server-derived), `BREAKDOWN_TIME`, `LUNCH` / `WTL` (+ `wtl:<n>` consent signature) | per row |
| — | *End Work* — no screen | | `WORK_AT_JOB_SITE_TIME.endedAt`, sent when break-down completes | that edge |
| — | *Incident* — not a step; SOS overlay, any time | | `TicketIncidentReport` (type, severity, description) + `incident:<uuid>` signature + attachments | `createdAt` |
| 8 | `sig2` | | `TicketSignature` sig2 — 3 approvals, `earlySignOff`, `unavailable` + reason, comments | `capturedAt` |
| 9 | `leftJob` | | `JOB_SITE_TIME.endedAt` | that edge |
| 10 | `arriveYard` | | `YARD_TIME.endedAt` | that edge |
| 11 | `posttrip` | yes | `ChecklistAssignment` (POST_TRIP) + answers | `submittedAt` |
| 12 | `compliance` | yes | `TicketSignature` compliance — `perDiem`, `complianceAttestation`. **Not a checklist** | `capturedAt` |
| 13 | `labor` | yes | `JobTicket.craftModifierBracket` / `craftModifierId` / `laborComments`; optional `WORK_TIME` override | `TicketStepCompletion('labor').completedAt` |
| 14 | `review` | | `WORK_TIME.endedAt`; `POST /submit` → `COMPLETE` | `WORK_TIME.endedAt` |

`startWork` means two things: on `PATCH /steps` it is the **punch-in on the ticket card, before
Left Yard** (opens `WORK_TIME`); on `PATCH /step-progress` it is the Start Build Up screen being
finished. See `ticket-step.constants.ts` (`TICKET_STEP_KEYS`, `UNTRACKED_STEP_KEYS`,
`TICKET_STEP_TIME_ENTRY_TARGETS`).

### B. What the design shows that nothing captures

GPS exists **only** on `TicketSignature` (sig1, sig2, compliance, `wtl:<n>`; incident signatures
store null; the client sends `0,0` for "no fix"). Nothing else in the design's step bodies is
captured: estimated / variance (except what D2 reads from the schedule), odometer, drive time as a
figure (derivable only as arrive − leave), ETA, distance, geofence (simulated on mobile by a
timer), per-deficiency GPS and timestamp, live location (the only live location in the platform
is Samsara **vehicle** telematics), "opened" (no capture), the customer *refusing* to sign (the
nearest capture is sig2 `unavailable` + `unavailableReason`), OSHA reference on incidents.
`ChecklistItemAnswer` has `reason`, `priority`, `photoAttachmentId` — no description, time or GPS
of its own.

### C. Backend facts that shape the build

- **No web read path.** All ticket reads are owner-gated (§2). Closest prior art: the payroll
  overlay (`usecase/payroll/payroll-week-overlay.ts`, `service/payroll/payroll.repository.ts`)
  and `deriveTicketProgress` (`usecase/ticket-time-entries/derive-ticket-progress.ts`) — already
  the implementation of the 2026-09-10 phase rule. Also `deriveTicketTimes`, `computeLaborHours`
  (`usecase/ticket-labor-entries/compute-labor-hours.ts`).
- **Ticket → day.** `JobTicket.allocationId` → `JobResourceAllocation.jobScheduleIntervalId` →
  `JobScheduleInterval.date` (`@db.Date`), `onSiteTime` / `estimatedEndTime` (+ `secondShift…`),
  `HH:mm` strings; `shiftNumber` on the allocation. Job detail already returns
  `schedule.intervals[].subJob{ id, dasStage }`.
- **Several tickets per allocation over time** — a reassignment cancels the old and sends a new
  one; a partial unique index keeps at most one non-CANCELLED per allocation.
- **Checklist assignments are created lazily by the mobile GET** (`findOrCreateAssignment`). A web
  read must query assignments directly, never through those methods, or it will create rows.
- **Tenant scoping.** `jobticket`, `ticketstepcompletion`, `ticketcomment`, `ticketsignature`,
  `ticketincidentreport`, `tickettimeentry`, `checklistassignment` are in the `$extends` allowlist
  (`orm/prisma.service.ts`); `checklistitemanswer`, `checklistgroup`, `checklistitem` and
  `jobscheduleinterval` are not (they inherit through a parent). **Note:** the 2026-09-10
  current-phase decision states `TicketTimeEntry` is *not* in the allowlist; the 2026-09-11 read
  found it *is*. Re-check before relying on either.
- **Attachments** stream through the API (no signed URLs). `GET /attachments/:id/download` checks
  tenant ownership only; ticket attachments carry `featureId = ticketCode` and feature types
  `TICKET_SIGNATURE`, `CHECKLIST`, `TICKET_INCIDENT`, `JOB_TICKET`. Web helper
  `useAttachmentImageUrl` (`apps/web/src/features/assets/tools-riggings/hooks/`).
- **Live updates.** Only `das:sub-job-updated` (room `das:<yyyy-mm-dd>`) fires on ticket writes,
  and only from the milestone route and submit. Step-progress, signatures, checklists, labor,
  incidents and comments emit nothing. The `/jobs` gateway (room `job:<JOB-code>`) emits only
  `jobs:tools-changed`.
- **Routes.** Job detail is `GET /jobs/:jobId` by business code; `GET /jobs/:jobId/progress-tracking`
  fits. Global throttle is 30 req/min.
- **Timezone.** DB session pinned to UTC. Tenant timezone (`TenantCompany.timezone`,
  `startOfBusinessToday(tz)`, `TenantContextService.getTimeZone()`) exists only on
  `origin/fix/timezone-business-day` — 23 commits ahead of `main` on 2026-09-11.

### D. Web facts that shape the build

- Tabs: `view-job.tsx` — `JOB_DETAIL_TABS`, `useUrlTab`, `JobTabContent` `if` chain; Progress
  Tracking falls through to `EmptyState` ("— coming soon").
- **`data-testid` contract:** `qa-automation/e2e/specs/projects/1-lifecycle.spec.ts` opens
  `section-tab-progress-tracking` and asserts `empty-state-title` = `Progress Tracking — coming
  soon`; `…/projects/jobs.page.ts` pins the label. Scheme `<module>-<flow>-<element>`; the jobs
  module uses `jobs-`.
- Reusable: `Collapsible`, `Drawer`, `Dialog`, `StatusBadge`, `SectionCard`, `EmptyState`,
  skeleton panels, avatar, `useAttachmentImageUrl`, the `use-job-tools-socket` pattern. **No
  shared progress bar or accordion** exists.
- Colours: tokens only (`styles/theme.css`); the design's hex values must be mapped.
