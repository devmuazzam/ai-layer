# Spec — SCRUM-PROGRESS Implement Projects → Job → Progress Tracking

> Written to `.ai/aidlc/SCRUM-PROGRESS/spec.md` by the elaborator from `intent.md` beside it.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-PROGRESS` — no Jira issue; folder name only |
| Intent | `.ai/aidlc/SCRUM-PROGRESS/intent.md`, captured `2026-09-11` |
| Elaborated on | `2026-09-11` |
| Vault state at elaboration | 151 content files, 6 `domain/` verified; `projects-jobs/gaps.md` (108 KB) has no entry naming progress tracking/tickets beyond the `ON_HOLD`/status items noted below; `field-ops/gaps.md` (64.7 KB) has a conflict stub (`field-ops-mobile-INDEX.md`) covering the mobile flow generally, settled for this ticket by D2 |
| Open questions raised by this spec | 6, all in §12 — Q1–Q4 and Q6 resolved 2026-09-11; Q5 open |
| Already-shipped behaviour reached | 9 consumers in §11a; all sourced since Q1 was resolved 2026-09-11 |
| Rules consulted | `.ai/claude/contexts/api.md`, `.ai/claude/contexts/prisma.md`, `.ai/claude/contexts/web.md`, `CLAUDE.md` → Architecture, Identity Convention, Test IDs |

**A finding, not a restatement.** Three decision-note files this ticket's brief told me to cite as "existing" —
`2026-09-10-current-phase-is-the-latest-open-capture-else-the-last-closed.md`,
`2026-09-10-locked-hours-are-elapsed-clock-time-unpriced.md`,
`2026-09-10-unstarted-tickets-date-by-schedule-interval-and-go-overdue-at-estimated-end.md` — **do not exist on
disk** in `.ai/vault/decisions/` (checked directly). They are quoted **verbatim** in shipping code
(`derive-ticket-progress.ts:14-19,128-136`, `payroll.repository.ts:255-258`, `payroll-week-overlay.ts:115-118`),
by exact filename. Likely explanation per `CLAUDE.md`'s worktree model: the notes live on `SCRUM-PENDING`'s own
overlay branch, not yet merged into this one. Every citation to these three files below is tagged `[UNVERIFIED]`
/ kind `decision+code` with this caveat, not `[VERIFIED]` — a code comment's quotation, not a read of the
document itself. The four **D1–D4** notes the brief names are equally absent from disk; the brief authorizes
treating `intent.md`'s verbatim D1–D4 text as their content, so those are cited as `decision` per instruction,
same absent-file caveat.

**On the design file.** `design/progress-tracking.design-extract.js` is a decoded clickable-prototype mock
(`design/README.md`:3-5): *"Mock data and mock behaviour throughout... it does not establish that any value in
it is captured, computed or allowed."* Cited kind `design`, `[UNVERIFIED]`, used only for **screen shape**,
never as a source for what data exists. Cited as `design-extract.js:<line>` per the brief.

**Gates.** `tcg-contract-tracer` is **mandatory** — this ticket adds new response DTOs to `packages/shared`
consumed by `apps/web` (§7). `tcg-prisma-guardian` is **not required** — §3 finds no schema change.

---

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Job-detail tab: replace "coming soon" with the Progress Tracking feature | web | `[UNVERIFIED]` | intent D1; code | no |
| REQ-02 | Left rail: scheduled dates with per-date status | web, api | `[UNVERIFIED]` | code (`SubJob.dasStage`); design shape | no |
| REQ-03 | Left rail: expand a date → its tickets (code + badge) | web, api | `[UNVERIFIED]` | design shape; code | no |
| REQ-04 | Selection states — none / date / ticket | web | `[UNVERIFIED]` | design shape; D1 | no |
| REQ-05 | Ticket timeline: role-based step set (14 Oiler / 9 other), real order | mobile-data, api, web | `[UNVERIFIED]` | D2; code | no |
| REQ-06 | Step detail bodies: capture-to-field mapping per step | api, web | `[UNVERIFIED]` | D2; code; decision (Q4) | no |
| REQ-07 | Scheduled vs. actual on-site/end times, display only | api, web | `[UNVERIFIED]` | D2 | no |
| REQ-08 | Checklists section — 3 real checklists (Pre-Trip, JSA, Post-Trip) | api, web | `[UNVERIFIED]` | code; D2 | no |
| REQ-09 | Compliance step body — signature row, not a checklist | api, web | `[UNVERIFIED]` | intent §5; design README; code | no |
| REQ-10 | Employee details column — call/email links | web | `[UNVERIFIED]` | D4; code | no |
| REQ-11 | Shift summary card | api, web | `[UNVERIFIED]` | design shape; code; decision (Q6) | no |
| REQ-12 | Ticket & step status — core derivation rules | api, shared | `[UNVERIFIED]` | D3; code; decision (Q2–Q4) | no |
| REQ-13 | Incomplete status | api | `[OPEN]` | D3; SCRUM-TZ (not on `main`) | **yes** |
| REQ-14 | Comments thread — read + post from web — **superseded 2026-09-11**: Chat renders disabled | api, web, shared | `[SUPERSEDED]` | decision (chat-and-reminders-shown-disabled) | no |
| REQ-15 | New API: progress-tracking summary endpoint | api | `[UNVERIFIED]` | rule (api.md); code precedent; decision (Q1) | no — Q1 resolved |
| REQ-16 | New API: ticket-detail endpoint | api | `[UNVERIFIED]` | rule (api.md); code precedent; decision (Q1) | no — Q1 resolved |
| REQ-17 | New API: web comment endpoints — **superseded 2026-09-11**: not built | api | `[SUPERSEDED]` | decision (chat-and-reminders-shown-disabled) | no |
| REQ-18 | Response contract types in `packages/shared` | shared | `[UNVERIFIED]` | rule (`CLAUDE.md` import aliases) | no |
| REQ-19 | Permission gating for the new endpoints | api | `[UNVERIFIED]` | decision (Q1); code | no |
| REQ-20 | `qa-automation` spec update for the tab | qa | `[UNVERIFIED]` | intent §4; web.md Test IDs | no |

Counts: **20 total** — 0 verified, 19 unverified, 0 conflicted, 1 open (REQ-13). Updated 2026-09-11: Q1–Q4 and Q6
were resolved by two `reference` decisions (§12). REQ-19 is no longer `[OPEN]`, and REQ-14–17 are no longer blocked
on Q1.

## 2. Requirements

### REQ-01 — Job-detail tab: replace "coming soon" `[UNVERIFIED]`

- **Statement:** The Job detail page's Progress Tracking tab renders the real feature (left rail + selection
  area) instead of falling through to the generic `EmptyState` "coming soon" branch.
- **Surface:** web
- **Sources:**
  - `intent.md` D1 — `[UNVERIFIED]` — kind: decision — *"Job tab first... The ticket timeline is built as its
    own reusable feature, so the top-level Daily Progress Tracking module can reuse it in a follow-up."* Note
    filed as `vault/decisions/2026-09-11-progress-tracking-ships-as-the-job-tab-first.md` — not found on disk;
    see §0.
  - `apps/web/src/features/projects/jobs/job-details/view-job.tsx:37-48` — `[UNVERIFIED]` — kind: code —
    `JOB_DETAIL_TABS` already lists `'Progress Tracking'`; `useUrlTab` (line 82) drives `activeTab`.
  - `apps/web/src/features/projects/jobs/job-details/view-job.tsx:174-229` — `[UNVERIFIED]` — kind: code —
    `JobTabContent` is an if-chain with branches for `Main`/`Resources`/`Schedule`/`Tool/Rigging`/`Additional
    Info`/`Permits / Plans`/`Attachments`/`Activity Log`. **No branch for `'Progress Tracking'`** — it falls to
    the final `return` (lines 225-229), rendering `<EmptyState title={`${activeTab} — coming soon`} />`.
- **Conflict:** none
- **Open question:** none
- **Ripple:** New `JobTabContent` branch for `'Progress Tracking'`. Existing branches for every other tab are
  unchanged (enumerated by reading `view-job.tsx:174-229` directly). See §11a.
- **Acceptance:** Opening a job's Progress Tracking tab no longer shows "Progress Tracking — coming soon"; it
  shows the left rail described in REQ-02–04.
- **Notes for the executor:** Add the branch before the generic fallback, not by editing the fallback itself —
  the fallback still needs to serve any future unbranched tab.

### REQ-02 — Left rail: scheduled dates with per-date status `[UNVERIFIED]`

- **Statement:** The left rail lists the job's scheduled dates (one row per `JobScheduleInterval`), each showing
  a status derived from that day's `SubJob.dasStage`.
- **Surface:** web, api
- **Sources:**
  - `design-extract.js:215-292,304-321` — `[UNVERIFIED]` — kind: design — `PT_SCHEDULES` mock: a date, a
    `status`/`tone` pair (`Ticket Sent`/blue, `Allocation Completed`/amber, `Open`/slate), a ticket array;
    `ptSidebar()` renders one button per date, badge showing `sc.status`.
  - `apps/api/prisma/schema.prisma:1672-1682` — `[UNVERIFIED]` — kind: code — `enum SubJobStage { OPEN,
    ALLOCATION_COMPLETED, TICKET_SENT, LOADOUT, EMPLOYEE_LEFT_YARD, WORK_IN_PROGRESS, COMPLETED,
    TICKET_SUBMITTED, CANCELLED }` — the design's 3 mock statuses are a strict subset of the real 9-value enum.
  - `apps/api/src/service/jobs/jobs.repository.ts:45-54` — `[UNVERIFIED]` — kind: code — job detail's
    `JOB_DETAIL_INCLUDE` **already** selects `schedule.intervals[].subJob{ id, dasStage, cancellationReason }` —
    confirms the intent appendix's claim, with exact citation.
  - `apps/api/prisma/schema.prisma:3572-3600` — `[UNVERIFIED]` — kind: code — `JobScheduleInterval` fields:
    `date DateTime @db.Date`, `onSiteTime/estimatedEndTime String? @db.VarChar(8)`,
    `hasSecondShift/secondShiftOnSiteTime/secondShiftEstimatedEndTime`.
- **Conflict:** none
- **Open question:** none for the 3 statuses the design shows; **`NOT SPECIFIED`** for the other 6 real
  `SubJobStage` values (`LOADOUT`, `EMPLOYEE_LEFT_YARD`, `WORK_IN_PROGRESS`, `COMPLETED`, `TICKET_SUBMITTED`,
  `CANCELLED`) — no source gives a label/tone for these on this rail. See §13.
- **Ripple:** `SubJob.dasStage` is already read by `jobs.repository.ts` for job-completion checks
  (`jobs.service.ts:146,171,176,183-184`, enumerated by `grep -rln "dasStage" apps/api/src/usecase/jobs/`). This
  is an **additional read of the same field for a new purpose** — unchanged for existing consumers.
- **Acceptance:** Each scheduled date renders with a status pill; the status matches `SubJob.dasStage` for that
  interval.
- **Notes for the executor:** Map all 9 `SubJobStage` values to a label/tone even though only 3 have design
  precedent; treat the other 6 as `NOT SPECIFIED` styling choices, not inventions of new business meaning.

### REQ-03 — Left rail: expand a date → its tickets `[UNVERIFIED]`

- **Statement:** Expanding a scheduled date lists that day's tickets, each showing `ticketCode` and a status
  badge (REQ-12).
- **Surface:** web, api
- **Sources:**
  - `design-extract.js:304-321` — `[UNVERIFIED]` — kind: design — `ptSidebar()` ticket-row rendering.
  - `apps/api/prisma/schema.prisma:3733-3801` — `[UNVERIFIED]` — kind: code — `JobResourceAllocation` carries
    `jobScheduleIntervalId`; `JobTicket.allocationId` → `JobResourceAllocation` (schema.prisma:4405-4414) is the
    path from a schedule interval to its tickets.
- **Conflict:** none
- **Open question:** none
- **Ripple:** none — new read, no existing consumer of "tickets grouped by schedule interval" was found
  (`grep -rln "jobScheduleIntervalId" apps/api/src/usecase/job-tickets/` returns nothing — job-tickets reads by
  `subJobId`/`allocationId`, never by interval directly today).
- **Acceptance:** Each expanded date shows one row per ticket on that interval, with code + badge.
- **Notes for the executor:** A `JobTicket` reaches its interval only via `allocationId →
  JobResourceAllocation.jobScheduleIntervalId` — there is no direct FK. Per intent §7, several tickets can exist
  per allocation over time (reassignment); only the one non-`CANCELLED` ticket (partial unique index) should
  normally show, but a `CANCELLED` one may still be relevant to "Rejected... CANCELLED... is hidden" (REQ-12) —
  confirm the query excludes `CANCELLED` tickets from this list, matching D3.

### REQ-04 — Selection states — none / date / ticket `[UNVERIFIED]`

- **Statement:** With nothing selected the pane shows an empty state; with a date selected (no ticket) it shows
  one card per ticket on that date; with a ticket selected it shows the ticket detail (REQ-05–11).
- **Surface:** web
- **Sources:**
  - `design-extract.js:323-334,905-920` — `[UNVERIFIED]` — kind: design — `ptTicketCard()`,
    `progressTracking()` — the 3-way `right` branch (no schedule/no tickets → "No data found · Select any date";
    tickets, no selection → card grid; ticket selected → `ptDetail()`).
  - `intent.md` §4 — `[UNVERIFIED]` — kind: decision (D1 scope framing) — confirms this 3-state shape is in
    scope.
- **Conflict:** none
- **Open question:** none
- **Ripple:** none — new UI, no existing consumer.
- **Acceptance:** All three states render correctly for a date with 0 tickets, a date with tickets, and no date
  selected.
- **Notes for the executor:** The design's `ptTicketCard()` (design-extract.js:323-334) includes a *Send
  Reminder via Email* button — **out of scope, D4**. Only the *Contact `<role>`* button carries over (REQ-10).
  *2026-09-11:* the button is now rendered, disabled, as the design draws it
  (`2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md`) — still no reminder is sent.

### REQ-05 — Ticket timeline: role-based step set `[UNVERIFIED]`

- **Statement:** The ticket-detail timeline shows the steps the ticket's role actually has — 14 for an Oiler, 9
  for every other role — in the mobile app's real order, not the design's fixed 15.
- **Surface:** mobile-data (read only), api, web
- **Sources:**
  - `intent.md` D2 — `[UNVERIFIED]` — kind: decision — *"Role-based steps (14 for an Oiler, 9 for everyone
    else)."* Note filed as `2026-09-11-progress-timeline-follows-the-real-mobile-flow-with-schedule-times.md` —
    not found on disk; see §0.
  - `apps/mobile/data/mock/fixtures.ts:74-323` — `[UNVERIFIED]` — kind: code — `RAW_STEPS`, 14 entries:
    `pretrip, leftYard, driving, arriveJob, sig1, jsa, startWork, sig2, leftJob, arriveYard, posttrip,
    compliance, labor, review`.
  - `apps/mobile/data/compose-ticket-detail.ts:25-31,70-78` — `[UNVERIFIED]` — kind: code —
    `CHECKLIST_ONLY_FOR_OILER_KEYS = new Set(['pretrip','jsa','posttrip','compliance','labor'])`;
    `getVisibleSteps` filters these out for non-Oilers and renumbers by array index (keys on the string `key`,
    not on `n`).
  - `packages/shared/src/constants/employee-types.ts:16` — `[UNVERIFIED]` — kind: code —
    `OILER_TYPE_NAME = 'Oiler'`.
  - `apps/api/prisma/schema.prisma:4405-4474,3733-3801,3427-3471` — `[UNVERIFIED]` — kind: code — role path:
    `JobTicket.allocationId → JobResourceAllocation.jobResourceId → JobResource.employeeTypeId →
    EmployeeType`. `JobTicket` itself carries no role field.
- **Conflict:** none — this **supersedes** the design's `PT_STEP_META`/`ptAllPending()` 15-step fixed list
  (`design-extract.js:4-17`), which D2 explicitly rejected (*"Not chosen: Design's fixed 15 steps"*).
- **Open question:** none
- **Ripple:** none — read-only reuse of mobile constants/logic; nothing in mobile changes (intent §5 — mobile is
  explicitly out of scope).
- **Acceptance:** An Oiler ticket's timeline shows 14 rows in `RAW_STEPS` order; every other role's shows 9 (the
  5 Oiler-only keys removed), same order.
- **Notes for the executor:** **Key-name mismatch, executor pitfall.** The design's `PT_STEP_META` uses
  `arrivedJob`/`custFirstSig`/`custSig`/`postInsp` — the real code uses `arriveJob`/`sig1`/`sig2`/`posttrip`.
  Do not reuse the design's step-meta object; author fresh labels/icons keyed to the **real** step keys. The
  real step set also has no `incident` entry (incident is not a step — see REQ-06) and no `endWork` entry (End
  Work has no mobile screen — it closes `WORK_AT_JOB_SITE_TIME` when the crew leaves the job site, not its own
  step; see REQ-06 "endWork" row).

### REQ-06 — Step detail bodies: capture-to-field mapping `[UNVERIFIED]`

- **Statement:** Expanding a timeline step shows only the data the mobile app actually captures for that step —
  no odometer, ETA, distance, geofence, drive-time figure, per-step GPS beyond signatures, live map, or "opened"
  flag.
- **Surface:** api, web
- **Sources:**
  - `intent.md` D2 + Appendix A/B — `[UNVERIFIED]` — kind: decision + code — the full capture table below is
    the intent's Appendix A, independently re-verified against code (Agent research, 2026-09-11) and confirmed
    accurate with one refinement (Oiler-only-ness is not a field on `RAW_STEPS` rows; it's the separate
    `CHECKLIST_ONLY_FOR_OILER_KEYS` set — REQ-05).
  - `apps/api/src/usecase/job-tickets/ticket-step.constants.ts` (whole file, 108 lines) — `[UNVERIFIED]` — kind:
    code — `TICKET_STEP_TIME_ENTRY_TARGETS`, `UNTRACKED_STEP_KEYS`.
  - `apps/api/prisma/schema.prisma:4485-4501,4539-4595,4645-4667` — `[UNVERIFIED]` — kind: code —
    `TicketStepCompletion`, `TicketSignature`, `TicketIncidentReport` field lists (full, confirmed by direct
    read).

  | Step key | Persists | Source model.field |
  | --- | --- | --- |
  | `pretrip` | Checklist answers per matched asset | `ChecklistAssignment`(PRE_TRIP) + `ChecklistItemAnswer` (REQ-08) |
  | `leftYard` | Yard-departure edge | `TicketTimeEntry`(YARD_TIME).startedAt |
  | `driving` | Step-reached ack only | `TicketStepCompletion`('driving').completedAt |
  | `arriveJob` | Job-site arrival edges | `TicketTimeEntry`(JOB_SITE_TIME + WORK_AT_JOB_SITE_TIME).startedAt |
  | `sig1` | Customer first signature | `TicketSignature`(stepKey='sig1') — signerName, gps, termsAccepted, comments |
  | `jsa` | Checklist answers | `ChecklistAssignment`(JSA) + `ChecklistItemAnswer` (REQ-08) |
  | `startWork` | Build-up/boom/breakdown/lunch/WTL windows | `TicketTimeEntry`(BUILDUP_TIME, BOOM_TIME, BREAKDOWN_TIME, LUNCH/WTL rows) |
  | *(no step)* `incident` | Filed any time via SOS overlay | `TicketIncidentReport` + synthetic `TicketSignature`(stepKey=`incident:<uuid>`) |
  | *(no step)* End Work | Job-site work end | `TicketTimeEntry`(WORK_AT_JOB_SITE_TIME).endedAt |
  | `sig2` | Customer final signature | `TicketSignature`(stepKey='sig2') — 3 approval booleans, earlySignOff, unavailable/unavailableReason, comments |
  | `leftJob` | Job-site departure edge | `TicketTimeEntry`(JOB_SITE_TIME).endedAt |
  | `arriveYard` | Yard-return edge | `TicketTimeEntry`(YARD_TIME).endedAt |
  | `posttrip` | Checklist answers | `ChecklistAssignment`(POST_TRIP) + `ChecklistItemAnswer` (REQ-08) |
  | `compliance` | Per-diem + attestation, **not a checklist** | `TicketSignature`(stepKey='compliance') — see REQ-09 |
  | `labor` | Boom bracket + comments | `JobTicket.craftModifierBracket/craftModifierId/laborComments` |
  | `review` | Ticket completion | `TicketTimeEntry`(WORK_TIME).endedAt; `JobTicket.status` → COMPLETE |

- **Conflict:** none
- **Open question:** none — step-**state** derivation was resolved 2026-09-11 (Q4,
  `decisions/2026-09-11-progress-tracking-status-precedence-step-states-and-boom-hours.md`, `reference`). A step is
  **done** when the table's source exists for it, or when a later step's does. An inferred step shows no time of
  its own. **Current** is the first step that is neither; later steps are **not reached**. **Flagged** means that
  step's own capture shows a deficiency, incident or refusal.
- **Ripple:** none — read-only.
- **Acceptance:** Every step body shows exactly the fields in the table above and nothing the design mocks that
  has no capture (odometer, ETA, distance, geofence text, per-deficiency GPS/timestamp beyond `createdAt`, OSHA
  reference, live map, ETA/drive-time as anything other than arrive − leave). Step rows follow Q4's rule. For
  example, a ticket with a `sig1` capture but no `driving` completion shows `driving` as done with no time.
- **Notes for the executor:** GPS exists **only** on `TicketSignature` rows (sig1, sig2, compliance, `wtl:<n>`;
  incident signatures store null; the client sends `0,0` for "no fix" — treat `0,0` as absent, not verified).
  Drive time, if shown at all, is derivable only as `arriveJob.startedAt − leftYard.startedAt`, never a captured
  figure.

### REQ-07 — Scheduled vs. actual on-site/end times, display only `[UNVERIFIED]`

- **Statement:** The ticket detail shows the schedule's on-site and estimated-end times beside the actual
  captured times, with no variance colouring, no late/overrun flag, and no computation beyond the display.
- **Surface:** api, web
- **Sources:**
  - `intent.md` D2 — `[UNVERIFIED]` — kind: decision — *"scheduled on-site and end times are shown next to the
    actuals, display only"*; §5 out-of-scope: *"Flagging late arrival or overrun against the schedule — the
    scheduled times are display only (D2); the design's variance colouring is not in scope."*
  - `apps/api/prisma/schema.prisma:3572-3600` — `[UNVERIFIED]` — kind: code — `onSiteTime`, `estimatedEndTime`,
    `secondShiftOnSiteTime`, `secondShiftEstimatedEndTime`, all `VarChar(8)` clock strings, plus
    `hasSecondShift`; which shift's pair applies is `JobResourceAllocation.shiftNumber`
    (schema.prisma:3733-3801, field `shiftNumber Int`).
- **Conflict:** none
- **Open question:** none
- **Ripple:** none — additive display of already-fetched fields.
- **Acceptance:** Each relevant step (arriveJob, endWork/review) shows the scheduled clock time beside the
  actual, with no colour or badge indicating early/late.
- **Notes for the executor:** Do **not** reuse `design-extract.js:352-357` (`ptDelta`, the design's "+24 min
  late"/"−15 min early" chip) or `design-extract.js:223-224,237,244,259,274,277` `varMin`/`overdue` fields — both
  are explicitly out of scope per D2/§5.

### REQ-08 — Checklists section — 3 real checklists `[UNVERIFIED]`

- **Statement:** A CHECKLISTS section under the timeline shows the ticket's real checklist assignments
  (Pre-Trip, JSA, Post-Trip — not Compliance, REQ-09), each with its answers and any deficiency's reason,
  priority and photo.
- **Surface:** api, web
- **Sources:**
  - `intent.md` §4 — `[UNVERIFIED]` — kind: decision — in-scope bullet, explicitly "(Pre-Trip per asset, JSA,
    Post-Trip per asset)".
  - `apps/api/prisma/schema.prisma:4823-4936,4957-4984` — `[UNVERIFIED]` — kind: code — `Checklist` (id,
    tenantCompanyId, checklistCode, type, name, categoryId/subCategoryId, version, isActive),
    `ChecklistGroup`(checklistId, name, position), `ChecklistItem`(groupId, kind, title, description, isRequired,
    position), `ChecklistAssignment`(id, tenantCompanyId, jobTicketId, checklistId, assetId, status,
    submittedAt), unique on `[jobTicketId, checklistId]`; `ChecklistItemAnswer`(checklistAssignmentId,
    checklistItemId, result: PASS/DEFICIENCY/NA, reason, priority, photoAttachmentId, createdAt/updatedAt) —
    **no free-text description beyond `reason`, no GPS, no answer-specific time beyond `createdAt`.**
  - `apps/api/src/service/checklist-assignments/checklist-assignments.repository.ts:179-205` — `[UNVERIFIED]` —
    kind: code — `findOrCreateAssignment` (used by mobile) creates a row as a side effect; a plain,
    non-creating `findAssignment(jobTicketId, checklistId)` exists but is per-(ticket, checklist) — **no
    `findMany`-by-ticket method exists today.**
- **Conflict:** none
- **Open question:** none
- **Ripple:** `ChecklistAssignment`/`ChecklistItemAnswer` are read today only by the mobile flow
  (`checklist-assignments.service.ts`) via the creating path. Unchanged for that consumer; this adds a
  **new, separate, non-creating** read path. See §11a.
- **Acceptance:** The CHECKLISTS section shows exactly 3 checklists (not 4), each rolling up answered/total and
  flagging any deficiency, matching real `Checklist.type` rows for the ticket's matched assets.
- **Notes for the executor:** **Mandatory — checklist assignments must be read directly, never via
  `findOrCreateAssignment` or any method that calls it.** A new repository method (e.g. `findManyByTicket`
  returning all `ChecklistAssignment` rows for a `jobTicketId` with `answers`/`checklist`/`asset` included) must
  be added; calling the existing creating path from a web-read endpoint would silently create checklist rows for
  every office view. `PT_CK_DEFS`'s mock item counts (Crane 17, Tractor 26, Trailer 4, JSA 6 —
  `design-extract.js:18-24`) are **not** the real item set; the real items are the tenant's `ChecklistItem` rows
  under the ticket's matched `ChecklistGroup`s.

### REQ-09 — Compliance step body — signature row, not a checklist `[UNVERIFIED]`

- **Statement:** The `compliance` step's body shows a per-diem selection and one attestation, sourced from
  `TicketSignature`, not from a 4-question checklist.
- **Surface:** api, web
- **Sources:**
  - `intent.md` §5 — `[UNVERIFIED]` — kind: decision — *"The design's four-question Compliance checklist — the
    real Compliance step is a signature row (per-diem + one attestation). The design's questions have no
    capture."*
  - `design/README.md`:65-66 — `[UNVERIFIED]` — kind: design (reading note) — same statement.
  - `apps/api/src/usecase/ticket-signatures/ticket-signature-step.constants.ts` (whole file, 14 lines) —
    `[UNVERIFIED]` — kind: code — `TICKET_SIGNATURE_PER_DIEM_TYPES = ['LONG_SUB','SHORT_SUB','NA']` — a
    3-value categorical select, **not** the design's Yes/No/N/A boolean-style mock (`design-extract.js:37`).
  - `apps/api/src/usecase/ticket-signatures/ticket-signatures.service.ts` (per verified report) —
    `[UNVERIFIED]` — kind: code — `TicketSignatureResponse` includes `perDiem`, `complianceAttestation` fields
    on the `compliance`-stepKey row.
- **Conflict:** none
- **Open question:** none
- **Ripple:** none — read-only.
- **Acceptance:** The compliance step body shows the per-diem selection (`LONG_SUB`/`SHORT_SUB`/`NA`) and the
  attestation flag; it does not render `PT_CK_DEFS`'s compliance question set
  (`design-extract.js:36-41`) at all.
- **Notes for the executor:** The `compliance` key is **excluded** from the CHECKLISTS section's 3-item count
  (REQ-08) and from `PT_CK_STEP_GATE`-style gating — it never appears there.

### REQ-10 — Employee details column — call/email links `[UNVERIFIED]`

- **Statement:** The ticket-detail side column shows the assigned employee's name, role, and call/email contact
  links, sourced from the employee record.
- **Surface:** web
- **Sources:**
  - `intent.md` D4 — `[UNVERIFIED]` — kind: decision — *"Contact is a call/email link from the employee
    record."* Note filed as `2026-09-11-progress-tracking-actions-are-contact-links-and-ticket-comments.md` —
    not found on disk; see §0.
  - `design-extract.js:882-890` — `[UNVERIFIED]` — kind: design — `ptDetail()` EMPLOYEE DETAILS block: avatar,
    name, role, *Contact `<role>`* button (phone icon).
- **Conflict:** none
- **Open question:** none
- **Ripple:** none — new UI, reads existing `Employee` fields (name/phone/email — allowlisted per §5 of this
  spec).
- **Acceptance:** The column shows the employee's name, role, and working `tel:`/`mailto:` links.
- **Notes for the executor:** The design's *Send Reminder via Email* button (`design-extract.js:888`) is
  **out of scope** — D4 says *"Send Reminder is left out for now."* Only Contact carries over. The design's
  *Chat with `<role>`* button (`design-extract.js:890`) becomes the Comments-thread action — REQ-14, not a
  separate chat feature. *Superseded 2026-09-11:* Send Reminder and Chat are both rendered **disabled**
  (`2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md`); REQ-14 is not built.

### REQ-11 — Shift summary card `[UNVERIFIED]`

- **Statement:** The side column shows a shift-summary card: current step text, step *n*/*N*, a progress bar,
  boom hours, net billable, incident count, deficiency count.
- **Surface:** api, web
- **Sources:**
  - `intent.md` §4 — `[UNVERIFIED]` — kind: decision — in-scope bullet.
  - `design-extract.js:829-843` — `[UNVERIFIED]` — kind: design — `ptSummaryCard()` shape (current step, Step
    n/N, progress bar, boom hours, net billable, incidents, deficiencies).
  - `apps/api/src/usecase/ticket-time-entries/derive-ticket-progress.ts:35-44,116-138,147-181` —
    `[UNVERIFIED]` — kind: code — `TicketPhase.text` is exactly the *"Currently: … / Completed: …"* string D3
    names as the current-step rule.
  - `apps/api/src/usecase/ticket-labor-entries/compute-labor-hours.ts` (per verified report) — `[UNVERIFIED]` —
    kind: code — `computeLaborHours` returns `netBillableHours` (no "boom hours" field).
  - `apps/api/src/usecase/ticket-time-entries/derive-ticket-times.ts` (per verified report) — `[UNVERIFIED]` —
    kind: code — `deriveTicketTimes` returns `boomWindows`/`boomSegments` (typed windows, "for reporting only"
    per its own comment) — the raw material for a boom-hours figure, but no function names it "boom hours."
- **Conflict:** none
- **Open question:** none — Q6 resolved 2026-09-11: boom hours are the **closed** `BUILDUP_TIME` + `BOOM_TIME` +
  `BREAKDOWN_TIME` windows (`BOOM_PAY_TYPES`), in hours to 1 decimal. Residual, non-blocking: sum or union when
  windows overlap (Q6).
- **Ripple:** none — read-only, new UI.
- **Acceptance:** Current-step text matches `deriveTicketProgress(entries).phase.text` exactly. Net billable
  matches `computeLaborHours(...).netBillableHours`. Incident/deficiency counts match REQ-06/REQ-08 data. Boom
  hours equal the closed `BOOM_PAY_TYPES` windows (an open window adds nothing).
- **Notes for the executor:** "Step *n*/*N*" (`su.step`/`su.total` in the design) is **not** the same concept as
  "current step text" — D3 keeps *Progress %* (steps done ÷ 9 or 14) separate from the phase-text rule. *N* is 9
  or 14 per REQ-05; *n* ("steps done") counts done steps per Q4's rule, inferred ones included. The timeline's
  current row (Q4) and this card's current-step text (D3 phase rule) can differ — Q4 residual.

### REQ-12 — Ticket & step status — core derivation rules `[UNVERIFIED]`

- **Statement:** A ticket's status is one of: Not opened, In progress, Completed, Flagged, Rejected, Incomplete
  (REQ-13), derived per the rules below; progress % is steps done ÷ steps for the role (9 or 14).
- **Surface:** api, shared
- **Sources:**
  - `intent.md` D3 — `[UNVERIFIED]` — kind: decision — the full preview table, verbatim:
    ```
    Not opened   PENDING/SENT and nothing captured yet
    In progress  something captured, not yet submitted
    Completed    Review & Complete submitted (COMPLETE)
    Flagged      an incident filed, OR any checklist item
                 marked Deficiency, OR customer unavailable
                 at the final signature
    Rejected     shown with its reason; CANCELLED (superseded
                 by a reassignment) is hidden
    Incomplete   [see REQ-13]
    Progress %   steps done ÷ steps for that role (9 or 14)
    Current step the existing 'Currently: … / Completed: …'
                 phase rule (2026-09-10 decision)
    ```
    Note filed as `2026-09-11-progress-tracking-ticket-status-rules.md` — not found on disk; see §0.
  - `apps/api/prisma/schema.prisma` — `[UNVERIFIED]` — kind: code — `JobTicketStatus` enum: `PENDING, SENT,
    IN_PROGRESS, COMPLETE, REJECTED, CANCELLED` (per SCRUM-PENDING's independently-sourced grep); `JobTicket`
    carries `status`, `rejectReason` (schema.prisma:4419,4422).
  - `apps/api/src/usecase/ticket-time-entries/derive-ticket-progress.ts:183-205` — `[UNVERIFIED]` — kind: code —
    `deriveTicketProgress(entries).started` is `rows.length > 0` — the mechanical test for "nothing captured
    yet" vs. "something captured."
- **Conflict:** none. The precedence gaps D3 left were carried to §12 (Q2–Q4) and resolved on 2026-09-11.
- **Open question:** none for this REQ. The three parts D3 left unsettled were resolved 2026-09-11
  (`decisions/2026-09-11-progress-tracking-status-precedence-step-states-and-boom-hours.md`, `reference`):
  - **Precedence (Q2):** `INCOMPLETE → FLAGGED → REJECTED → COMPLETED → IN_PROGRESS → NOT_OPENED`.
  - **Flagged on a Completed ticket (Q3):** yes, it reads Flagged.
  - **Step states (Q4):** see REQ-06.

  Incomplete itself stays with REQ-13 and Q5.
- **Ripple:** `derive-ticket-progress.ts`'s `deriveTicketProgress`/`TicketPhase` are already consumed by the
  payroll overlay (`payroll-week-overlay.ts`). This reuses the same pure function for a second, independent
  consumer — unchanged for the payroll overlay (enumerated by
  `grep -rln "deriveTicketProgress" apps/api/src/`).
- **Acceptance:** Not opened / In progress / Completed / Rejected render correctly against their triggers in
  isolation (single-condition test cases). When several conditions hold at once, the badge follows Q2's order.
  For example, a `COMPLETE` ticket with an incident reads Flagged (Q3), and a Flagged ticket that is also
  Rejected reads Flagged. Incomplete is not produced until REQ-13 ships.
- **Notes for the executor:** `CANCELLED` tickets are hidden entirely, not shown with a badge — this affects
  REQ-03's ticket list, not just the badge.

### REQ-13 — Incomplete status `[OPEN]`

- **Statement:** `OPEN — the intent asks for an Incomplete status ("not COMPLETE once the shift's estimated end
  has passed, in the tenant timezone... shift 2 uses the second-shift end. No end time on the schedule → end of
  that business day"), but the tenant-timezone concept this rule depends on does not exist on `main`.`
- **Surface:** api
- **Sources:** none that can be built against today.
  - `intent.md` D3 — `[UNVERIFIED]` — kind: decision — states the rule (quoted in REQ-12): *"Incomplete ships
    last, once the tenant-timezone branch reaches main, because the check has to run in the tenant's zone."*
  - `das-loadout-schedule-lock.util.ts:46-85` — `[UNVERIFIED]` — kind: code — the only existing "has the shift
    ended" comparison (`isShiftEndTimeInPast`/`resolveShiftEndAtUtc`) computes the shift end **in UTC**,
    treating the `HH:mm` clock string as a UTC instant, not the tenant's zone — a placeholder, acknowledged by
    its own caller (`payroll-week-overlay.ts:115-118`: *"that zone does not exist on `main` yet... reuses the
    UTC comparison... rather than inventing a third answer"*).
  - `.ai/aidlc/SCRUM-TZ/intent.md:17` — `[UNVERIFIED]` — kind: jira (synthetic ticket) — *"Status: In progress —
    code for the prerequisite work already exists on `fix/timezone-business-day`"* — 23 commits ahead of `main`.
- **Conflict:** n/a
- **Open question:** *Does the Incomplete rule's null-end-time clause ("no end time → end of that business day")
  answer, or only sit beside, the identical open question on `SCRUM-PENDING`?* — Q5.
- **Ripple:** `OPEN — cannot be stated until Q5 and SCRUM-TZ's landing are resolved.` The existing UTC-placeholder
  util (`das-loadout-schedule-lock.util.ts`) has other consumers (`isMarkAvailableScheduleBlocked`,
  `isStartLoadoutScheduleBlocked`) — whether Incomplete should reuse the *same* placeholder now (matching
  `payroll-week-overlay.ts`'s precedent) or wait for the real tenant-zone comparison is part of the sequencing
  decision, not a data question.
- **Acceptance:** `OPEN — cannot be stated until SCRUM-TZ reaches `main` and Q5 is answered.`
- **Notes for the executor:** **Ship this as its own last unit**, after every other REQ in this spec, per the
  ticket's explicit instruction. Until then, tickets that would be Incomplete should render whatever status they
  hold otherwise (In progress/Not opened) — do not fabricate an Incomplete badge from the UTC placeholder without
  an explicit decision to do so (that decision is Q5).

### REQ-14 — Comments thread — read + post from web `[SUPERSEDED]`

> **Superseded 2026-09-11** by `vault/decisions/2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md`:
> the design's *Chat with `<role>`* button renders disabled ("Chat is not available yet.") and the web neither
> reads nor posts comments. Kept below as written, for the record.

- **Statement:** The ticket detail's Comments thread shows the ticket's existing comments and lets a web user
  post a new one.
- **Surface:** api, web, shared
- **Sources:**
  - `intent.md` D4 — `[UNVERIFIED]` — kind: decision — *"Chat opens the ticket's existing Comments thread, the
    one the crew already see on mobile, and the web can read and post to it."*
  - `apps/api/prisma/schema.prisma:4511-4527` — `[UNVERIFIED]` — kind: code — `TicketComment`(id,
    tenantCompanyId, jobTicketId, authorUserId, text, createdAt, updatedAt) — append-only, multi-author.
  - `apps/api/src/usecase/ticket-comments/ticket-comments.service.ts` (per verified report) —
    `[UNVERIFIED]` — kind: code — `listForTicket`/`addComment`, both gated via
    `JobTicketsService.getTicketForEmployeeAction` (owner-only) — the exact gate a web caller (no `employeeId`)
    would fail today (`ForbiddenException('Employee profile required')`).
  - `apps/api/src/presentation/field-tickets/field-tickets.controller.ts:293-311` — `[UNVERIFIED]` — kind: code
    — the only existing comment routes, `@Controller('field/tickets')` `GET/POST :id/comments`, mobile-only in
    practice because of the gate above.
- **Conflict:** none
- **Open question:** none — Q1 resolved 2026-09-11: reading needs `jobs:view`, posting needs `jobs:edit`
  (REQ-19).
- **Ripple:** The existing `field/tickets/:id/comments` routes and `TicketCommentsService` are **unchanged** —
  this adds new, parallel routes (REQ-17) rather than modifying the owner-gated ones, so mobile is unaffected.
  See §11a.
- **Acceptance:** A web user with `jobs:view` can read a ticket's comment history; with `jobs:edit` can post a
  new comment that immediately appears (REQ-19); mobile's own comment thread for the same ticket is unaffected.
- **Notes for the executor:** No socket emits on a comment write (`grep -rln "Gateway\|\.emit(" apps/api/src/usecase/ticket-comments/` returns nothing) — a new comment will not push to another open web session; refetch-on-mutate (TanStack Query), not a socket subscription, matching existing precedent elsewhere in the web app.

### REQ-15 — New API: progress-tracking summary endpoint `[UNVERIFIED]`

- **Statement:** `GET /api/v1/jobs/:jobId/progress-tracking` returns the job's scheduled dates with per-date
  status and a per-date ticket summary (code, employee, role, badge) — the data behind REQ-02/03/04.
- **Surface:** api
- **Sources:**
  - `intent.md` §9 Appendix C — `[UNVERIFIED]` — kind: jira (this ticket's own intent, backend-facts section) —
    *"Job detail is `GET /jobs/:jobId` by business code; `GET /jobs/:jobId/progress-tracking` fits."*
  - `apps/api/src/presentation/jobs/jobs.controller.ts:44-48` — `[UNVERIFIED]` — kind: code — confirmed: `GET
    :jobId` resolves `jobId` as the business code (`Job.jobId VarChar(50)`, not the UUID PK), no guard/role
    decorator beyond the global `AccessTokenGuard`.
  - `.ai/claude/contexts/api.md` → *Layers*, *Adding a feature* — `[UNVERIFIED]` — kind: rule — route shape
    follows `presentation → usecase → service → orm`; a new module registered in `app.module.ts`.
- **Conflict:** none
- **Open question:** none — Q1 resolved 2026-09-11: callers need `jobs:view` (REQ-19).
- **Ripple:** `none — new surface only (established by: grep -rln "progress-tracking" apps/api/src/presentation/apps/api/src/usecase/)`. No existing route serves this shape.
- **Acceptance:** For a valid job code, returns every scheduled date with `dasStage` and per-ticket summaries;
  404 for an unknown job code; tenant-scoped (a job from another tenant 404s, matching the existing `GET
  :jobId` behaviour).
- **Notes for the executor:** The exact route path is a **proposal following existing convention**
  (`jobs.controller.ts`'s other sub-resource routes, e.g. `PUT :jobId/schedule`), not itself sourced from a
  product document — routing shape is a "how," not a "what," per this repo's rule hierarchy.

### REQ-16 — New API: ticket-detail endpoint `[UNVERIFIED]`

- **Statement:** `GET /api/v1/jobs/:jobId/progress-tracking/tickets/:ticketCode` returns one ticket's full
  detail — timeline with captures (REQ-06), checklists (REQ-08), employee (REQ-10), shift summary (REQ-11),
  status (REQ-12).
- **Surface:** api
- **Sources:** same as REQ-15, plus:
  - `.ai/claude/contexts/prisma.md` → *Tenant scoping is conditional* — `[UNVERIFIED]` — kind: rule — governs
    §5's tenant-scoping table below.
- **Conflict:** none
- **Open question:** none — Q1 resolved 2026-09-11: callers need `jobs:view` (REQ-19).
- **Ripple:** `none — new surface only`. Aggregates existing per-model reads (signatures, incidents, checklist
  assignments, time entries) that today are only reachable per-ticket **by the ticket's own employee**
  (`getTicketForEmployeeAction`) — this endpoint is the first cross-employee read path for any of them. See
  §11a.
- **Acceptance:** For a ticket belonging to the named job, returns every field in REQ-06's table, REQ-08's
  checklist rollups, and REQ-12's status; 403 for a caller without `jobs:view` (REQ-19), 404 for an unknown
  job/ticket code.
- **Notes for the executor:** Do **not** reuse `getTicketForEmployeeAction` for this endpoint's authorization —
  that method is specifically "is this the ticket's own employee," the opposite of what this endpoint needs.
  Resolve the ticket by `(tenant, ticketCode) → id` once, per the Identity Convention, then read every child
  table directly.

### REQ-17 — New API: web comment endpoints `[SUPERSEDED]`

> **Superseded 2026-09-11** with REQ-14 — see its note. The two `…/comments` routes in §4 are not built, and
> `TicketCommentsService` is unchanged. Kept below as written, for the record.

- **Statement:** `GET`/`POST /api/v1/jobs/:jobId/progress-tracking/tickets/:ticketCode/comments` list and create
  comments from the web, independent of the mobile owner-gated routes.
- **Surface:** api
- **Sources:** same as REQ-14 and REQ-15.
- **Conflict:** none
- **Open question:** none — Q1 resolved 2026-09-11: `GET` needs `jobs:view`, `POST` needs `jobs:edit` (REQ-19).
- **Ripple:** see REQ-14's Ripple — the existing mobile routes are unaffected.
- **Acceptance:** A comment posted via this route appears in both this endpoint's read and the mobile
  `field/tickets/:id/comments` read for the same ticket (same underlying `TicketComment` rows).
- **Notes for the executor:** Reuse `TicketCommentsService.listForTicket`/`addComment` directly — only the
  authorization wrapper differs from the mobile controller.

### REQ-18 — Response contract types in `packages/shared` `[UNVERIFIED]`

- **Statement:** The new endpoints' response shapes are typed in `packages/shared` so `apps/web` is
  compile-checked against them.
- **Surface:** shared
- **Sources:**
  - `intent.md` §6 — `[UNVERIFIED]` — kind: decision (ticket scope table) — *"`packages/shared` — yes — The new
    response contract, so web is compile-checked against it."*
  - `CLAUDE.md` → *Import Aliases*, *Stack* — `[UNVERIFIED]` — kind: rule — `@tcg/shared` consumed by every app
    as its built `dist/`.
- **Conflict:** none
- **Open question:** none
- **Ripple:** New types only — `tcg-contract-tracer` is mandatory to trace every web consumer once these land
  (§0).
- **Acceptance:** `apps/web`'s progress-tracking feature imports its response types from `@tcg/shared`, not
  locally re-declared.
- **Notes for the executor:** Type the REQ-06 capture table's per-step shapes as a discriminated union keyed on
  the real step key (not the design's), so a step body's fields are only accessible for the steps that actually
  have them.

### REQ-19 — Permission gating for the new endpoints `[UNVERIFIED]`

- **Statement:** Every new read (REQ-15, REQ-16, REQ-17 `GET`) requires `jobs:view`; the REQ-17 comment `POST`
  requires `jobs:edit`. No new permission key.
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-11-progress-tracking-reads-need-jobs-view-and-posts-need-jobs-edit.md` — `[UNVERIFIED]` —
    kind: decision (`reference`; Syed Haris, Lisette Anzaldo to ratify) — *"Read needs jobs:view, the same
    audience as the job detail page. Posting a comment needs jobs:edit. No admin setup is needed."*
  - `packages/shared/src/constants/permissions.ts:84-133` — `[UNVERIFIED]` — kind: code — `USER_DEFAULTS` gives a
    `USER` with no department role `view` on `jobs` (not in `USER_RESTRICTED_MODULES`); `resolveEffectiveLevel`
    gives `none` for a module a department role omits; ADMIN/SUPER_ADMIN bypass.
  - `apps/api/src/decorator/require-permission.decorator.ts`, `apps/api/src/guard/permissions.guard.ts:22-29` —
    `[UNVERIFIED]` — kind: code — `@RequirePermission(module, level)` is the enforcement point; a no-op on a route
    without it.
- **Conflict:** none
- **Open question:** none — Q1 resolved 2026-09-11.
- **Ripple:** the new routes are the first jobs-area routes to carry `@RequirePermission`; every existing
  `jobs.controller.ts` route stays ungated (§11a). So a user whose department role omits `jobs` can open the job
  but gets 403 on this tab. That is known, and the decision note leaves it outside Q1.
- **Acceptance:** a `USER` with no department role reads (200) and cannot post (403). A department role with
  `jobs: edit` or `full` reads and posts. A department role that omits `jobs` gets 403 on every new route.
  ADMIN/SUPER_ADMIN pass.
- **Notes for the executor:** the decider accepted the exposure `intent.md` §8 named: a field-worker account with
  no department role can read colleagues' captures, including signatures and identity photos. **Completed job:**
  refuse the post whatever the caller's `jobs` level, and hide the web composer when the job is read-only. That
  is the implementation default, reading the verified `decisions/2026-08-25-completed-job-view-only.md` hard
  block literally. It is not part of the Q1 answer. Do not reuse `getTicketForEmployeeAction` (REQ-16).

### REQ-20 — `qa-automation` spec update `[UNVERIFIED]`

- **Statement:** `qa-automation/e2e/specs/projects/1-lifecycle.spec.ts`'s Progress Tracking assertion is updated
  in the same change, since the tab no longer shows "coming soon."
- **Surface:** qa
- **Sources:**
  - `intent.md` §4 — `[UNVERIFIED]` — kind: decision — explicit in-scope bullet naming this file.
  - `qa-automation/e2e/specs/projects/1-lifecycle.spec.ts:333-340` — `[UNVERIFIED]` — kind: code — current
    assertion: `jobDetail.openTab('progress-tracking')` then `expect(page.getByTestId('empty-state-title'))
    .toHaveText('Progress Tracking — coming soon')`.
  - `qa-automation/e2e/specs/projects/jobs.page.ts:23-33,69-76` — `[UNVERIFIED]` — kind: code —
    `JOB_DETAIL_TABS` page-object constant pins `{ label: 'Progress Tracking', slug: 'progress-tracking' }`;
    `tab(slug)`/`openTab(slug)` helpers, unaffected by this change (the tab itself still opens the same way).
  - `.ai/claude/contexts/web.md` → *Test IDs* — `[UNVERIFIED]` — kind: rule — *"Before you rename or remove
    one: `grep -rn '<the-id>' qa-automation/e2e`. Updating the spec in the same commit is part of the change,
    not a follow-up."*
- **Conflict:** none
- **Open question:** none
- **Ripple:** This is itself a ripple entry — see §11a row for `1-lifecycle.spec.ts`.
- **Acceptance:** The spec asserts real Progress Tracking content (e.g. the left rail renders, per REQ-02)
  instead of the "coming soon" empty state; `pnpm` CI is unaffected since `qa-automation` is outside the Nx
  workspace (`CLAUDE.md` → *`data-testid` in `apps/web` is a contract*).
- **Notes for the executor:** New interactive elements need `data-testid`s in the existing `jobs-` prefix scheme
  — confirmed as the live convention by `grep -rhon "data-testid=[\"'][a-z0-9-]*[\"']"
  apps/web/src/features/projects/jobs/` (e.g. `jobs-pos-tab`, `jobs-schedule-row`,
  `jobs-quick-access-customer-po`), even though `.ai/claude/contexts/web.md`'s Test IDs section does not itself
  special-case the jobs module — the module-level prefix is established by existing code, not by that doc.
  Propose e.g. `jobs-progress-tracking-date-row`, `jobs-progress-tracking-ticket-card`,
  `jobs-progress-tracking-step-row`, `jobs-progress-tracking-comment-input`. The tab strip's own testid
  (`section-tab-progress-tracking`) is auto-generated by `SectionTabs` (`section-tabs.tsx:112`) and needs no
  change.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no — every value in scope is already captured (confirmed per REQ-06's table;
  intent §6 "Believed no — the elaborator should confirm" is now confirmed).
- **Migration required:** no.
- **Data backfill required:** no.

No new/changed models. `tcg-prisma-guardian` is not required for this spec as written.

- **New prefix introduced:** no.
- **Child relations:** n/a — no new relations.
- **Fields whose type/precision no source states:** n/a.

## 4. API surface — `apps/api`

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/v1/jobs/:jobId/progress-tracking` | `progress-tracking.controller.ts` (new) | `progress-tracking.service.ts` (new) | reuses `jobs.repository.ts` + a new interval→tickets query | REQ-15 |
| `GET` | `/api/v1/jobs/:jobId/progress-tracking/tickets/:ticketCode` | same controller | same service, aggregating existing per-model services | new repository reads across `TicketStepCompletion`/`TicketTimeEntry`/`TicketSignature`/`TicketIncidentReport`/`ChecklistAssignment` | REQ-16 |
| `GET` | `/api/v1/jobs/:jobId/progress-tracking/tickets/:ticketCode/comments` — **superseded 2026-09-11, not built** | same controller | reuses `TicketCommentsService.listForTicket` | `ticket-comments.repository.ts` (existing) | REQ-17 |
| `POST` | `/api/v1/jobs/:jobId/progress-tracking/tickets/:ticketCode/comments` — **superseded 2026-09-11, not built** | same controller | reuses `TicketCommentsService.addComment` | same | REQ-17 |

Per endpoint:

- **Request DTO:** the comment-post DTO already exists in shape (`ticket-comments.service.ts addComment(ticketId,
  userId, text)`) — a new `post-comment.dto.ts` with `text: string` (existing validation, if any, `NOT
  SPECIFIED` — no source states a max length).
- **Response shape:** per REQ-15/16/17's Statement fields; concrete TypeScript shapes belong in REQ-18.
- **Guards / roles:** `AccessTokenGuard` (global, always). Beyond that: `@RequirePermission('jobs', 'view')` on
  the three `GET`s, `@RequirePermission('jobs', 'edit')` on the `POST` — REQ-19.
- **Route param identity:** `:jobId` resolves as `Job.jobId` (business code) exactly as the existing `GET
  :jobId` does; `:ticketCode` resolves as `JobTicket.ticketCode` — resolve `(tenant, code) → id` once per the
  Identity Convention, then operate by UUID.
- **Errors:** `NOT SPECIFIED` beyond the existing pattern (404 for an unknown job/ticket code, matching `GET
  :jobId`'s behaviour) — no source states a distinct error message for this feature.
- **Module registration:** new `ProgressTrackingModule` registered in `app.module.ts`; barrel `index.ts`.

### Tenant-scoping notes per model (re-verified `$extends` allowlist, `apps/api/src/orm/prisma.service.ts:116-243`)

| Model | In allowlist? | Note |
| --- | --- | --- |
| `Job`, `JobSchedule` | yes | scoped directly |
| `JobScheduleInterval` | **no** | inherits scope through `JobSchedule` |
| `JobResource`, `JobResourceAllocation` | yes | scoped directly |
| `JobTicket` | yes | scoped directly |
| `TicketStepCompletion` | yes | scoped directly |
| `TicketTimeEntry` | **yes — resolved disagreement.** The intent appendix flagged a conflict between the (unwritten) 2026-09-10 decision note, reportedly saying *not* in the allowlist, and a 2026-09-11 finding it *is*. Direct re-read of `prisma.service.ts:231` confirms **present** — rationale comment :225-230: written cross-employee by the set's Oiler, so it stays allowlisted rather than relying on inherited scope. |
| `TicketSignature` | yes | scoped directly |
| `TicketIncidentReport` | yes | scoped directly |
| `TicketComment` | yes | scoped directly |
| `Checklist` | yes | scoped directly |
| `ChecklistAssignment` | yes | scoped directly |
| `ChecklistGroup`, `ChecklistItem`, `ChecklistItemAnswer` | **no** | inherit scope through `Checklist`/`ChecklistAssignment` (comment at `prisma.service.ts:166-170`) |
| `Employee` | yes | scoped directly |
| `EmployeeType` | `NOT SPECIFIED` — not confirmed in this elaboration | executor should `grep -n "'employeetype'" apps/api/src/orm/prisma.service.ts` before relying on automatic scoping, per `contexts/prisma.md`'s own instruction to never assume |
| `Attachment` | yes | scoped directly |

## 5. Web surface — `apps/web`

- **Routes:** no new top-level route — this renders inside the existing `Job` detail page's tab content
  (`/projects/.../jobs/:jobId?tab=Progress+Tracking`, matching `useUrlTab`'s existing pattern).
- **Existing components to reuse** *(checked before proposing anything new)*: `Collapsible`
  (`components/ui/collapsible.tsx`), `Drawer`/`Dialog` (`components/ui/`), `StatusBadge`
  (`components/ui/status-badge.tsx`, canonical, 97 importers), `SectionCard` (two variants exist —
  `molecules/section-card.tsx` and `patterns/section-card.tsx`; **`NOT SPECIFIED`** which — match the
  surrounding jobs feature), `EmptyState` (`components/molecules/empty-state.tsx`), skeleton panels
  (`components/molecules/skeleton-panels/`), an avatar component (two exist, same duplication as
  `SectionCard`), `useAttachmentImageUrl` (`features/assets/tools-riggings/hooks/use-attachment-image-url.ts`).
- **New components proposed:** a step-timeline/accordion component (feature-local — **confirmed no shared
  accordion exists**, `grep -rni "accordion" apps/web/src` returns zero hits) and a progress-bar component
  (**confirmed no shared one exists**; nearest precedent `features/vehicle-tracking/components/fuel-bar.tsx`,
  itself feature-local by design, per its own doc comment — follow the same pattern rather than add a tenth
  shared primitive for one feature).
- **Table (if any):** `N/A` — no table in this feature; the left rail and ticket cards are not a `WorkspaceTable`/
  `CommonTable` shape.
- **Forms:** the comment-post input is the only form surface — `NOT SPECIFIED` whether it goes through
  react-hook-form + Zod (the app convention) or a simpler controlled input matching the design's chat-style box;
  no source specifies validation beyond "non-empty" (confirmed server-side in `ticket-comments.service.ts`).
- **Server state:** TanStack Query v5 — query keys `NOT SPECIFIED` in any source; propose
  `progressTrackingKeys.summary(jobId)` / `.ticket(jobId, ticketCode)` / `.comments(jobId, ticketCode)`,
  invalidating the comments key on a successful post.
- **Colors / spacing:** CSS variables only, from `apps/web/src/styles/theme.css`
  (`--color-<domain>-<semantic>-<variant>`, e.g. `--color-text-error-primary`, `--color-text-warning-primary`,
  `--color-text-success-primary`). The design's hex values (e.g. `#b42318` for incomplete/flagged red,
  `#067647` for done green, `#175cd3` for in-progress blue) must be mapped to the nearest existing token —
  **`NOT SPECIFIED`** which exact token each maps to; no source gives a design-hex-to-token table.
- **Responsive:** mobile-first; 44px touch targets, per `web.md` baseline.
- **Copy:** Banner copy ("Ticket Incomplete — Allocated Time Expired", "Ticket Flagged — Incident Reported") is
  design mock copy only (`design-extract.js:851,862`) — **`NOT SPECIFIED`** as approved product copy; treat as a
  placeholder pending REQ-13/Q2's resolution, not as final text to ship.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `N/A — out of scope` (intent §5: *"Any change to the mobile app or to what it
  captures."*). This spec reads mobile-authored data only.
- **Components:** n/a
- **Offline / sync behavior:** n/a
- **Touch targets:** n/a
- **Push / notifications involvement:** `N/A` — Send Reminder (push or email) is explicitly out of scope, D4.

## 7. Shared package — `packages/shared`

- **Types added / changed:** Response contract types for REQ-15/16/17 (job-schedule summary, ticket detail,
  comment list/create) — see REQ-18.
- **Nothing shared:** n/a — REQ-18 adds types.

## 8. Permissions and tenancy

- **Roles permitted:** an effective `jobs` level of `view` or higher reads; `edit` or higher posts (REQ-19). That
  includes a `USER` with no department role (read only) and ADMIN/SUPER_ADMIN (bypass).
- **Roles denied:** a user whose department role omits `jobs` (effective `none`) is denied everything. A user
  below `jobs:edit` cannot post.
- **Tenant isolation:** standard, via the `$extends` allowlist — see §4's table. `JobScheduleInterval` and the
  checklist-definition models inherit scope through their parents; confirm the new repository queries join
  through a scoped parent rather than querying those models bare.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Comment `text` | non-empty | `ticket-comments.service.ts` `addComment` (per verified report) | `[UNVERIFIED]` |
| Comment `text` max length | `NOT SPECIFIED` — no source states a limit | — | — |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | Step-set derivation (14 vs 9), status-rule single-condition cases | REQ-05, REQ-12 |
| Integration (API) | New endpoints return correct data for seeded tickets across all captured-data states (not-opened, in-progress, completed, flagged, rejected); tenant isolation (a job/ticket from another tenant 404s); permission levels per REQ-19's acceptance | REQ-15–17, REQ-19, §8 |
| E2E / manual script | `qa-automation` Progress Tracking tab renders real content; comment post round-trips to mobile's own comment read | REQ-20, REQ-14 |

- Requirements with no testable acceptance criterion: REQ-13 (`[OPEN]`).

## 11. Non-functional

- **Performance:** `NOT SPECIFIED` — no source states a target. Note: global throttle is 30 req/min
  (`app.module.ts:155`, `ThrottlerModule.forRoot([{ ttl: 60_000, limit: 30 }])`) — the ticket-detail endpoint
  aggregates several child-table reads per call; consider whether the left rail's per-date ticket summaries
  need their own lighter read vs. reusing the full ticket-detail shape (`NOT SPECIFIED` which).
- **Concurrency:** n/a — read-heavy feature; the one write (comment post) is append-only, no contention.
- **Audit / activity log:** `NOT SPECIFIED` — no source states whether a web-posted comment or a web ticket-read
  should write an `ActivityLog` entry.
- **Migration/rollout order:** REQ-01–12 and 14–20 can ship together; REQ-19/Q1 was answered 2026-09-11. **REQ-13
  (Incomplete) ships last, as its own unit, after `SCRUM-TZ` reaches `main`** — explicit instruction, also
  matches D3's own sequencing statement.
- **Real-time updates:** confirmed **no socket event exists** for any write this feature reads (step-progress,
  signatures, checklists, labor, incidents, comments) — only `das:sub-job-updated` and `jobs:tools-changed`
  exist, neither relevant here (confirmed by direct search, §11a). Live-ness is refetch-on-focus/-mutate at
  best; `NOT SPECIFIED` whether a socket subscription should be added.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `view-job.tsx` `JobTabContent` if-chain | new tab branch | REQ-01 | changes deliberately | code | `view-job.tsx:174-229` |
| `qa-automation/e2e/specs/projects/1-lifecycle.spec.ts` + `jobs.page.ts` | `data-testid` contract | REQ-20 | changes deliberately (same commit, per `web.md`) | code + rule | `1-lifecycle.spec.ts:333-340`, `jobs.page.ts:23-33` |
| `SubJob.dasStage` (read by `jobs.repository.ts` for completion checks) | same field, new read | REQ-02 | unchanged | code | `grep -rln "dasStage" apps/api/src/usecase/jobs/` |
| `ChecklistAssignment`/`ChecklistItemAnswer` mobile read path (`findOrCreateAssignment`) | new, separate non-creating read | REQ-08 | unchanged | code | `checklist-assignments.repository.ts:187-205` |
| `field/tickets/:id/comments` (mobile, owner-gated) | `TicketCommentsService` reused by new web routes | REQ-14, REQ-17 | unchanged | code | `field-tickets.controller.ts:293-311` |
| `getTicketForEmployeeAction` (owner gate) | not reused by the new endpoints | REQ-16 | unchanged for its existing 12+ callers; a **new**, separate authorization path is introduced rather than modifying this one | code | `job-tickets.service.ts:934-943` + 12 call sites |
| `deriveTicketProgress`/`TicketPhase` (payroll overlay's current-phase text) | same pure function, second consumer | REQ-11, REQ-12 | unchanged | code | `grep -rln "deriveTicketProgress" apps/api/src/` |
| `das:sub-job-updated` / `jobs:tools-changed` sockets | not reached — confirmed no emit on any read/write this feature touches | REQ-11, REQ-14 | unaffected — this feature emits nothing new and consumes nothing existing | code | `grep -rln "Gateway\|\.emit(" apps/api/src/usecase/{ticket-signatures,ticket-incidents,checklist-assignments,ticket-labor-entries,ticket-comments,job-tickets}/` |
| `jobs.controller.ts` — no route currently permission-gated | REQ-15–17 add routes to the same ungated pattern unless REQ-19 changes it | REQ-15–17, REQ-19 | changes deliberately: the new routes carry `@RequirePermission('jobs', …)`; existing routes stay ungated (REQ-19) | decision (Q1) + code | `grep -rln "@RequirePermission\|@Roles(" apps/api/src/presentation/{jobs,job-tickets,sub-jobs,field-tickets,das}` |

- **Surfaces with no existing behaviour in this area:** ticket reads grouped by schedule interval (confirmed
  absent: `grep -rln "jobScheduleIntervalId" apps/api/src/usecase/job-tickets/` returns nothing); a
  `findMany`-by-ticket checklist-assignment read (confirmed absent in
  `checklist-assignments.repository.ts`).
- **Consumers with no source for what happens to them:** none. The one there was, the permission model for the
  new endpoints, was answered 2026-09-11 (REQ-19, Q1).

## 12. Open questions — the stop-and-ask list

```bash
grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md
```

### Q1 — Who may read another employee's ticket, and who may post a comment, from the web?

- **Question:** Gate REQ-15–17 behind a new `progress-tracking:view`/`:comment` permission pair, or an existing
  role/department check? Defaults per role?
- **Why it cannot be answered from what is written:** `intent.md` §8 raises it, answers nothing. Confirmed live
  risk: a plain `USER` gets `jobs:view` by default; no jobs route carries `@RequirePermission` today.
- **Blocked:** REQ-14, REQ-15, REQ-16, REQ-17, REQ-19 — none should ship without this.
- **Candidates:** `intent.md` §8 (problem, no answer); `packages/shared/src/constants/permissions.ts` (no
  `progress-tracking` module in the scheme); `apps/api/src/guard/permissions.guard.ts` (confirmed no-op without
  `@RequirePermission`) — none settle the role list.
- **Owner:** product team.
- **Workaround, if any:** Build behind a **new** permission key with a restrictive default (dispatcher/admin
  only) instead of `jobs:view` — contains the exposure, doesn't answer who should ultimately have it.
- **Answer (2026-09-11, Syed Haris — `reference`, Lisette Anzaldo to ratify):** reads need `jobs:view` ("the
  same audience as the job detail page"); posting a comment needs `jobs:edit`. No new permission key, no admin
  setup — the new-key workaround above was offered and **not chosen**. Accepted with it: a `USER` with no
  department role can read colleagues' tickets, captures included. Posting on a Completed job is refused
  whatever the caller's `jobs` level. That is the implementation's literal reading of the verified
  `decisions/2026-08-25-completed-job-view-only.md`, not part of this answer. Folded into REQ-19.
- **Status:** resolved — see decisions/2026-09-11-progress-tracking-reads-need-jobs-view-and-posts-need-jobs-edit.md

### Q2 — How does Flagged combine with Incomplete and Completed in badge precedence?

- **Question:** D3 approves 6 status values but the design's badge-precedence function orders only 4
  (`INCOMPLETE → FLAGGED → COMPLETED → Opened/NOT OPENED`), omitting In progress and Rejected. Full order?
- **Why it cannot be answered from what is written:** `intent.md` D3's *"What D3 does not say"* names this gap
  and leaves it; the design (`design-extract.js:297-303`) covers only 4 of 6 values.
- **Blocked:** REQ-12 (precedence), REQ-03 (badge rendering).
- **Candidates:** `design-extract.js:297-303` (partial); `intent.md` D3 (names, doesn't fill) — nothing gives
  the full order.
- **Owner:** product team.
- **Workaround, if any:** `INCOMPLETE → FLAGGED → REJECTED → COMPLETED → IN_PROGRESS → NOT_OPENED` — extends
  the design's chain by placing Rejected beside Flagged (both exceptions) and In progress as the default active
  state. Proposed, not sourced.
- **Answer (2026-09-11, Syed Haris — `reference`):** the workaround is adopted as written. Incomplete does not
  apply until REQ-13 ships.
- **Status:** resolved — see decisions/2026-09-11-progress-tracking-status-precedence-step-states-and-boom-hours.md

### Q3 — Does an incident or deficiency on an already-Completed ticket still read Flagged?

- **Question:** Once `COMPLETE` is set, does a subsequent (or previously unsurfaced) incident/deficiency still
  render Flagged, or does Completed suppress it?
- **Why it cannot be answered from what is written:** named in `intent.md` D3's *"What D3 does not say"*,
  unresolved there.
- **Blocked:** REQ-12 (precedence), REQ-11 (incident/deficiency counts on a completed ticket's card).
- **Candidates:** `intent.md` D3 only — names the gap, does not resolve it.
- **Owner:** product team.
- **Workaround, if any:** Default **yes** — D3 lists Flagged as a trigger condition, not a status transition,
  so it should persist independent of Completed. Proposed, not sourced.
- **Answer (2026-09-11, Syed Haris — `reference`):** **yes**. A Completed ticket with an incident or deficiency
  reads Flagged, since Flagged outranks Completed in Q2's order.
- **Status:** resolved — see decisions/2026-09-11-progress-tracking-status-precedence-step-states-and-boom-hours.md

### Q4 — How are step-level timeline states (done / current / flagged / not-reached) derived?

- **Question:** For each real step, what rule assigns done / current / not-reached / flagged to that row
  (distinct from the ticket-level status in Q2/Q3)?
- **Why it cannot be answered from what is written:** named in `intent.md` D3's *"What D3 does not say"*. A
  candidate exists but is unverified here: `ticket-step.constants.ts` references a mobile function
  `deriveResumeFloor` used to resume an interrupted flow — a plausible precedent for "current step," not read
  in this pass.
- **Blocked:** REQ-06 (step-row visual state), REQ-11 ("steps done" numerator).
- **Candidates:** `ticket-step.constants.ts` (references `deriveResumeFloor`, unread); `intent.md` D3 (names
  the gap). No vault or decision source.
- **Owner:** product team.
- **Workaround, if any:** **done** = a capture/completion record exists for that step key; **current** = the
  first step in the role's ordered list with none; every later step = **not reached**; **flagged** (per-step) =
  that step's own capture shows a deficiency/incident/refusal. Proposed — check against `deriveResumeFloor`
  first.
- **Answer (2026-09-11, Syed Haris — `reference`):** adopted **with inference**, which goes further than the
  workaround above. A step is **done** when a capture exists for it (REQ-06's source for that step) **or** a
  later step has one. An inferred step shows no time of its own and counts toward progress %. **Current** is
  the first step that is neither; later steps are **not reached**. "Adopt, but no inference" (a *Not recorded*
  row) was offered and **not chosen**. Per-step **flagged** carries over from the workaround by reference — the
  summary shown did not include it.
- **Residual (non-blocking):** the timeline's current row (this rule) and the summary card's current-step text
  (D3's phase rule) can name different things. An incident is not a step, so the flagged clause names no row
  for it.
- **Status:** resolved — see decisions/2026-09-11-progress-tracking-status-precedence-step-states-and-boom-hours.md

### Q5 — Does the Incomplete rule's null-end-time clause answer, or only sit beside, `SCRUM-PENDING`'s identical open question?

- **Question:** `SCRUM-PENDING`'s own Q5 ("when has ticket end time passed?") covers the identical
  `estimatedEndTime`/`secondShiftEstimatedEndTime` comparison, scoped to the payroll overlay. One rule for
  both, or could they diverge?
- **Why it cannot be answered from what is written:** `intent.md` D3 raises it explicitly, unsettled;
  `SCRUM-PENDING` has no `spec.md` yet to check against (only `intent.md`, as of 2026-09-11).
- **Blocked:** REQ-13, and by extension `SCRUM-PENDING`'s equivalent item.
- **Candidates:** `intent.md` D3; `.ai/aidlc/SCRUM-PENDING/intent.md`:200-217 (same question, unresolved);
  `das-loadout-schedule-lock.util.ts` (the one implemented comparison, UTC-placeholder).
- **Owner:** product team.
- **Workaround, if any:** Treat as **one rule** for both features — both already read the same fields through
  the same `isShiftEndTimeInPast` helper; divergence would need an explicit reason neither source gives.
  Proposed, not sourced.
- **Note (2026-09-11):** left open on purpose by Syed Haris: "Q5 … stays open, since it only matters once
  Incomplete ships" (`decisions/2026-09-11-progress-tracking-status-precedence-step-states-and-boom-hours.md`).
  This is a deferral by a named person, for §14's first checkbox. It is not an answer.
- **Status:** open

### Q6 — What is "boom hours" on the shift-summary card, precisely?

- **Question:** Sum of `boomSegments` window durations, the design mock's own formula ("elapsed − paused
  break-down time"), or something else? What rounding?
- **Why it cannot be answered from what is written:** `compute-labor-hours.ts` has no "boom hours" field (only
  `netBillableHours`); `derive-ticket-times.ts`'s `boomSegments`/`boomWindows` are "for reporting only" per
  their own comment, named nowhere as a single output. `design-extract.js:636`'s formula is mock UI copy.
- **Blocked:** REQ-11's boom-hours field only — non-blocking otherwise.
- **Candidates:** `derive-ticket-times.ts` (`boomSegments`, field list confirmed, aggregation unverified);
  `design-extract.js:636` (mock, not a data source).
- **Owner:** product team.
- **Workaround, if any:** Sum of `boomSegments` durations in hours, rounded to 1 decimal (matches the design's
  "3.6"-style display). Proposed, not sourced.
- **Answer (2026-09-11, Syed Haris — `reference`):** boom hours are the **closed** windows of all three
  `BOOM_PAY_TYPES`: `BUILDUP_TIME`, `BOOM_TIME` and `BREAKDOWN_TIME` (`derive-ticket-times.ts`). That is
  payroll's PAY-043 set, not the design's "elapsed − paused". Open windows count nothing, which is narrower
  than the workaround's `boomSegments` sum. The 1-decimal rounding carries over from the workaround by
  reference.
- **Residual (non-blocking):** sum or union when windows overlap. Payroll credits an overlapped slice once; the
  answer does not say which.
- **Status:** resolved — see decisions/2026-09-11-progress-tracking-status-precedence-step-states-and-boom-hours.md

### Q7 — A date with several schedule intervals: one rail row, and which stage pill?

- **Question:** REQ-02 says one rail row per `JobScheduleInterval`, but a job can schedule several intervals on
  one date (`sortOrder`), each with its own `SubJob.dasStage`. On 2026-09-12 the developer asked, against
  screenshots, for one row per date with every ticket under it. The duplicate rows also highlighted together,
  because selection is keyed by date. When a merged date's intervals disagree, which single pill should it show?
- **Why it cannot be answered from what is written:** REQ-02 assumes one interval per date, and the design's
  `ptSidebar()` mocks one status per date. No source covers several intervals on one date.
- **Blocked:** nothing — shipped with the workaround below.
- **Candidates:** REQ-02 (one row per interval, `[UNVERIFIED]`); `design-extract.js` `ptSidebar()` (one row per
  date, keyed by date); the `SubJobStage` enum order in `schema.prisma`.
- **Owner:** product team — Lisette Anzaldo, per `decisions/2026-09-11-progress-tracking-ticket-status-rules.md`.
- **Workaround, if any:** web only, in `progress-tracking/group-progress-days.ts`; the API response is unchanged.
  Same-date intervals merge into one row, and their tickets sort by shift, then name, then code. The pill is the
  least advanced `SubJobStage` among the date's live intervals, in DAS order, so `OPEN` beats
  `TICKET_SUBMITTED`. Cancelled intervals, and ones DAS has not picked up, count only when nothing else that
  date is live.
- **Status:** open

## 13. What this spec deliberately does not specify

- Labels/tones for the 6 real `SubJobStage` values the design doesn't mock (`LOADOUT`, `EMPLOYEE_LEFT_YARD`,
  `WORK_IN_PROGRESS`, `COMPLETED`, `TICKET_SUBMITTED`, `CANCELLED`) — no source; see REQ-02.
- Exact design-hex-to-`theme.css`-token mapping — no source gives a table; see §5.
- Banner copy for Incomplete/Flagged states — design mock copy only, not approved product text; see §5.
- Comment `text` max length — no source states a limit; see §9.
- Query-key naming for the new TanStack Query hooks — no source; a proposal only, see §5.
- *Removed 2026-09-11, now specified:* boom-hours aggregation (Q6), step-level states (Q4), full badge
  precedence (Q2), Flagged surviving Completed (Q3), and who may read or comment (Q1). See §12 and the two
  2026-09-11 decision notes cited there.
- Boom hours when windows overlap — sum or union; not said (Q6 residual).
- Whether the timeline's current row may disagree with the summary card's current-step text — not said (Q4
  residual).
- Whether the Incomplete null-end-time clause is the same rule as `SCRUM-PENDING`'s — no source; see REQ-13 and Q5.

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement (REQ-13, REQ-19) is answered, or explicitly deferred by a named person
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — n/a, none flagged `[CONFLICT]`
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] Decomposed into vertical units — `units.md` — **REQ-13 (Incomplete) as its own last unit**, after
      `SCRUM-TZ` reaches `main`

Answered by: ______________  Date: ______________
