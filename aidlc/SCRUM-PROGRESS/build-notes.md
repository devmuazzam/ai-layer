# Build notes — SCRUM-PROGRESS

What was built for the job Progress Tracking tab, where it departs from `spec.md` and the design,
and what is still owed. Written by the building sessions so `tcg-analyst` and `tcg-reflector` have
the facts without reconstructing them from the diff.

**Process note — read first.** Implementation started while the elaborator was still running, so
the loop ran **intent → spec → build**, with **no `units.md`**: `tcg-decomposer` did not run, and
every requirement except REQ-13 landed on one branch rather than one branch per unit (`commit`
skill §1). Split it before review if the one-unit-per-PR rule is to hold.

## Branches

| Branch | Worktree | State |
| --- | --- | --- |
| `feat/SCRUM-PROGRESS-job-progress-tracking` | `.worktrees/scrum-progress` | First build (session 1, Syed Haris). Uncommitted. **Left untouched**; superseded by the branch below |
| `feat/SCRUM-PROGRESS-job-progress-tracking-design` | `.worktrees/scrum-progress-design` | Session 1's uncommitted work carried over (same base, `origin/main` @ `25185b04f`), then rebuilt to the design (session 2). Uncommitted |

## Session 2 — rebuilt to the design

The request, verbatim: *"from this file read code of projects=> job=> progress tracking and
implement it in to tc · ui should be same as provided design · use reuseable components · ui
should be integrated with backend · if any functionality is missing in our current system like
chat make these button disabled · you should do all of these changes into new work tree"*.

Answers taken in session:

- **Worktree:** a new worktree that reuses session 1's code.
- **Chat:** disabled. This supersedes D4's Chat clause and is recorded in
  `vault/decisions/2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md`.
- **Timeline:** the real 14/9-step flow with the design's styling. This re-confirms D2.

What changed:

- **UI rebuilt on the design's layout** (`design/progress-tracking.design-extract.js`, Section A),
  one component per design function:
  - `ptSidebar` → `progress-date-rail.tsx`
  - `ptTicketCard` → `progress-ticket-card.tsx`
  - `ptStepRow` → `ticket-timeline.tsx`
  - `ptStepDetail` → `step-details.tsx` + `step-bodies/*`
  - `ptChecklistsSection` / `ptCkCard` / `ptCkBody` → `checklists-section.tsx` + `checklist-results.tsx`
  - EMPLOYEE DETAILS → `employee-card.tsx`
  - `ptSummaryCard` → `shift-summary-card.tsx`
  - Live Tracking → `live-tracking-card.tsx`
  - `ptIncompleteBanner` / `ptIncidentBanner` → `ticket-banners.tsx`
  - `ptDetail` → `ticket-progress-detail.tsx`
  - `progressTracking` → `job-progress-tracking-tab.tsx`
- **Reusable pieces** (in `features/ticket-progress/components/`):
  - `ProgressChip` (`ptChip`) and `MiniPill` (`ptMiniPill`);
  - `TicketStatusBadge` (`ptStatusBadge`);
  - `CrewAvatar` / `CrewIdentity`, built on the shared `components/base/avatar`;
  - `UnavailableActionButton`, built on the shared `Button` + `components/base/tooltip`;
  - `ContactCrewButton`;
  - `DetailGrid` / `StepBody` / `DetailSubSection` / `DetailNote` / `DetailCallout` (`ptGrid` / `ptKV` / `ptSubSection`);
  - `GpsRow` (`ptGpsRow`), `AttachmentThumbnail` (`ptPhotoTile` / `ptSigBox`), `ProgressBar`.

  Shared components reused as-is: `EmptyState`, `Skeleton`, `Collapsible`, and the DAS stage
  labels and styles.
- **Shown disabled**, with the reason on hover:
  - Send Reminder via Email, on the ticket card and the employee card;
  - Send Reminder, on the *Incomplete* banner;
  - Chat with &lt;role&gt;;
  - the Live Tracking card, which shows no map and reads "Not available".
- **Removed:**
  - the web comment routes (`GET`/`POST …/tickets/:ticketCode/comments`) and their DTO;
  - `JobProgressService.listComments` / `addComment`, `JobProgressRepository.findTicketRef`, and
    `_count.comments`;
  - the shared `ProgressTicketComment` type and `ProgressTicketDetail.commentCount`;
  - the comments drawer and its hooks;
  - the Refresh button and the "back to all tickets" link, neither of which is in the design;
  - session 1's `TicketCommentsService` / `TicketCommentsRepository` changes, **reverted**, so
    mobile's comment code is as it is on `main`.

### Design elements left out or changed, and why

| Design | Here | Why |
| --- | --- | --- |
| Fixed 15-step list | Real 14 (Oiler) / 9 steps; End Work and incidents as events | D2 |
| Arrival / end-work variance pills (`ptDelta`) | Left out; scheduled time shown in the grid as *Est.* | D2 — schedule times are display only |
| Odometer, ETA, distance, geofence, per-step GPS | Left out | D2 — no capture |
| GPS rows | Only on signatures, pill reads **Captured** (design: *Verified*) | GPS exists only on signatures; nothing verifies it against the site |
| Compliance as a 4-question checklist | Signature row: per-diem + breaks attestation | REQ-09 |
| "Boom paused" pill; break-down as a pause | Break-down shown as the closing work phase | It counts towards boom hours (2026-09-11 precedence/boom-hours decision) |
| "Total boom = elapsed − paused break-down" | "Total boom = build-up + boom + break-down time" | Same decision |
| Checklist gate "Ticket cannot be completed until every checklist is answered" | "Not yet answered: …" / "All checklists answered." | No source says completion is gated on them |
| Incomplete banner "…excluded from completed-ticket totals until resolved" | Dropped | No source |
| Incident banner "Ticket is currently blocked at <step>" | Dropped; type · severity · filed time instead | No blocking state is captured |
| Ticket info modal, status-count KPI card | Not built | Unreachable in the design itself (`design/README.md`) |
| Empty state's file icon | The shared `EmptyState` illustration, same copy ("No data found · Select any date") | Reuse |
| Chat drawer | Not built; Chat button disabled | 2026-09-11 chat-and-reminders decision |

### Values chosen in session 2 (no source states them)

- **Colours** come from theme tokens, never hex:
  - green / blue / amber / red → `--color-utility-{green,blue,amber,red}-*`;
  - slate greys → `--color-ws-{faint,ghost,border-strong,surface-*,canvas}`;
  - the design's `--blue` → `--color-ws-accent`, which has the same value (`#2563eb`);
  - ink / text2 / text3 → `--color-text-{primary,tertiary,quaternary}`.
- **Checklist answer labels** use the design's wording: Completed / Deficiency / N/A for unit
  checklists, OK / Issue / N/A for JSA. Mobile shows "Pass" / "Deficiency".
- **Ticket badge** for `IN_PROGRESS` is the design's green "Opened" dot pill; the status label
  elsewhere stays "In progress".
- **Avatar tint** is picked by hashing the person's id over the design's six `TINTS`. Role bar
  colours: Oiler indigo, Operator pink, Rigger sky, 3rd-man amber, others accent.
- **Timeline rows** start collapsed, as in the design. Session 1 opened the current step.
- **"Select any date"** picks today, else the latest past day with tickets, else the first day.

## Built — by requirement

| REQ | Where |
| --- | --- |
| REQ-01 tab wired | `apps/web/.../job-details/view-job.tsx` → `progress-tracking/job-progress-tracking-tab.tsx` |
| REQ-02/03 date rail (DAS stage label + styles reused from `features/das`) | `progress-tracking/progress-date-rail.tsx` |
| REQ-04 selection in the URL (`?day=` / `?ticket=`) | `progress-tracking/use-progress-selection.ts` |
| REQ-05/06/07 timeline, step bodies, scheduled times | `features/ticket-progress/components/ticket-timeline.tsx`, `step-details.tsx`, `step-bodies/*` |
| REQ-08 checklists (read directly — never `findOrCreateAssignment`) | `components/checklists-section.tsx`, `checklist-results.tsx`; `service/job-progress/job-progress.repository.ts` |
| REQ-09 compliance as a signature row | `step-bodies/signatures.tsx` (`ComplianceBody`) |
| REQ-10 call / email links | `components/action-buttons.tsx` (`ContactCrewButton`) |
| REQ-11 shift summary | `components/shift-summary-card.tsx` |
| REQ-12 status, flags, steps, precedence | `usecase/job-progress/derive-ticket-progress-view.ts` (pure) + `.spec.ts`; badge order `lib/progress-display.ts` `ticketBadgeKind` |
| REQ-14/17 comments | **Superseded** — not built (2026-09-11 chat-and-reminders decision) |
| REQ-15/16 endpoints | `presentation/job-progress/job-progress.controller.ts` — paths exactly as spec §4 |
| REQ-18 contract | `packages/shared/src/types/job-progress.types.ts` |
| REQ-19 gates | `@RequirePermission('jobs','view')` on both GETs (no write route any more) |
| REQ-20 QA contract | `qa-automation/e2e/specs/projects/1-lifecycle.spec.ts` — asserts `jobs-progress-tracking-tab`, `-empty`, `-day-<yyyy-mm-dd>`; all three IDs kept |

## Not built

- **REQ-13 Incomplete.** In the contract (`ProgressTicketStatus`) and rendered by the web
  (badge, banner, step state), never emitted by the API. The rule belongs in
  `deriveStatus` in `derive-ticket-progress-view.ts` once SCRUM-TZ puts the tenant timezone on
  `main`. The existing `isShiftEndTimeInPast` was deliberately **not** reused: it reads schedule
  clock strings as UTC, so a Los Angeles shift ending 17:00 would read *Incomplete* at 10:00
  local. Q5 is still open.

## Departures from `spec.md`

1. **File names** are `job-progress.*`, not the spec's `progress-tracking.*`.
2. **Test IDs** use the prefix `jobs-progress-tracking-` (REQ-20's suggestion), supplied by
   `ProgressTestIdProvider` so the Daily module can mount the same components under its own
   module prefix. Step keys and checklist types are kebab-cased in IDs
   (`jobs-progress-tracking-step-left-yard`, `…-checklist-pre-trip`).
3. **Freshness is refetch-on-focus**, not a socket. Only `das:sub-job-updated` fires on ticket
   writes today, and only from milestones and submit.
4. *(Session 1's `TicketCommentsService` change and its "posting refused on a Completed job"
   default are gone with the comment routes.)*

## Values chosen in session 1 (no source states them) — still in force

- The Oiler flow is decided by the **employee's own** `EmployeeType` (what mobile uses —
  `identity.employeeType`), while the displayed role is the **allocation slot's** label.
- End Work and incident entries are timeline events; neither counts towards *Step n of N*.
- An incident is placed after the last entry captured at or before it was filed.
- Boom hours: closed build-up + boom + break-down, 2 dp from the API, 1 dp on screen.
- A signature GPS of exactly `0,0` is treated as no fix (the device's own sentinel).

## Verification done (session 2)

All checks ran with `@tcg/shared` mapped to this worktree's `packages/shared/src`, using scratch
tsconfigs outside the repo. See *Worktree hazard*.

- **API:** `tsc --noEmit` over `job-progress/*`, `ticket-comments/*` and `app.module.ts`, which
  pulls in the whole API graph, with spec files and jest types — **0 errors**.
- **Web:** `tsc --noEmit` over `features/ticket-progress`, `job-details/progress-tracking` and
  `view-job.tsx`, plus everything they import:
  - **0 errors in any touched file**;
  - 5 errors in untouched files (`base-api.ts`, `create-socket.ts`, `address-map-picker.tsx`),
    all `Cannot find name 'process'`. These come from the scratch config's type roots, not from
    this change.
- **ESLint**, scoped to the changed files (web + api): **0 errors, 0 warnings** after `--fix`.
  Prettier was applied to every changed file.
- **Not run:** jest, the full lint / typecheck / build gates, Playwright, and the app itself.
  **Nobody has checked the UI against the design in a browser.**

## Worktree hazard — for whoever pushes this

`.worktrees/scrum-progress-design` was made with `pnpm worktree:add`, so its `node_modules`
(root and per-project) are **symlinks into the primary checkout**. That means `@tcg/shared`
resolves to the *primary's* `packages/shared` and its `dist/`, which lack
`job-progress.types.ts`. So:

- the worktree's own `pnpm typecheck` / `build` / pre-push gate will fail on those types, and
  `pnpm api:dev` (tsc) will too;
- `web:dev` is unaffected, because the web imports only types from it.

Before pushing or running the API here, replace the symlinks with a real `pnpm install` in the
worktree, as was done in `.worktrees/scrum-progress`. Also: `.gitignore`'s `node_modules/`
matches directories only, so the symlinks show as untracked. Stage explicit paths, never
`git add .`.
