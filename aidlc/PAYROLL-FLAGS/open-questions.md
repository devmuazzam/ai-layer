# PAYROLL-FLAGS — open questions, parked with a default

The developer's instruction (2026-09-30): **do not stop to ask**. Any question that comes up while
building U1–U21 is written here, the safest default that fits the written sources is built, and work
continues. Each entry names who should answer it. Answering one means changing the default in code
and marking the entry `answered` here.

Format: question · default built · why that default · who answers · status.

---

## From the developer's own review of U1–U3 (PR #709, 2026-09-30)

### OQ-1 — Does a payroll void touch dispatch?
- **Question:** U3 voided a ticket by setting it `CANCELLED`, which dispatch reads as "slot free":
  after a void, dispatch could send a new ticket for the same allocation.
- **Default built:** a void is a **payroll-only closure**. `JobTicket.payrollClosedAction = VOIDED`
  (+ at / by / note) is recorded, and the ticket's `status` is **not** changed. So dispatch, billing and
  invoicing are untouched. Payroll (the incomplete-ticket gate, the overlay) and mobile (the crew's list)
  read `payrollClosedAction` instead.
- **Why:** the only written direction says "billing, invoicing and dispatch are untouched" (spec-u6-u13
  Q22 / vault developer-answers note K4). The review marked the CANCELLED reuse as *contradicted*.
- **Who answers:** Lisette Anzaldo (dispatch). Corrina Bustos ratifies C8.
- **Status:** open (default built)

### OQ-2 — Must Void / Remind refuse a ticket outside period `:id`'s week? (spec.md Q13, Q15)
- **Default built:** **yes.** The API checks that the ticket belongs to the period's incomplete-ticket
  set (the same set the overlay shows: Start Ticket week, Pacific; a ticket not started yet goes by its
  scheduled date) and refuses otherwise. A future-scheduled ticket can no longer be voided through
  another week's period.
- **Why:** the review found the API voided any PENDING/SENT/IN_PROGRESS ticket in the tenant; only the
  UI limited it.
- **Who answers:** developer (mechanics). Corrina ratifies the void rule (C8).
- **Status:** open (default built)

### OQ-3 — Approve / Export buttons for users without `payroll-admin`
- **Default built:** the web **hides** Approve Week, bulk Approve, Export to ADP and per-employee Export
  unless `useCan('payroll-admin', 'edit')`. Instead of a button that answers 403, the user sees
  "Approving and exporting need the Payroll Admin permission".
- **Why:** after U1, every Payroll Manager would otherwise click and get a 403 until the grant is made.
- **Who answers:** developer (UI wording).
- **Status:** open (default built)

## From the U3/U4 builders (spec.md §12)

### OQ-4 — A voided ticket still showing on the crew's phone (spec.md Q12)
- **Default built:** mobile drops any ticket with `payrollClosedAction` set from the crew's active list,
  same-day and started tickets included.
- **Why:** the developer's Q5 answer: "on mobile it drops off the crew's list like a cancelled ticket".
- **Who answers:** developer.
- **Status:** open (default built)

### OQ-5 — May the period auto-advance to APPROVED while an employee with no priced week has an incomplete ticket? (spec.md Q14)
- **Default built:** **no.** The period does not auto-advance while any ticket in it is incomplete.
- **Why:** Corrina (verified): "all tickets must be completed before the payroll can be processed/approved".
- **Who answers:** Corrina Bustos.
- **Status:** open (default built)

---

## Added while building U6–U21

(Builders append below in the same format: question · default built · why · who answers · status.)

### OQ-6 — A payroll-voided ticket keeps its status: may the crew still work it, and does Calculate pay it if they do? (fix pass on PR #709)
- **Question:** Under OQ-1 a void no longer sets `CANCELLED`, so the server's terminal-status guards
  (`job-tickets.service.ts`) no longer refuse a step or submit on a voided ticket, as they did when
  U3 cancelled it. The crew's lists drop it (OQ-4), but a ticket opened another way (a notice tap,
  `use-notification-ticket-navigation.ts`; an old cached list) can still be stepped and completed.
  If it is completed, it becomes `COMPLETE` with `payrollClosedAction = VOIDED` still on it. Should
  field steps refuse a payroll-closed ticket, and should Calculate price a `COMPLETE` ticket payroll
  had voided? Related: the field list route's per-tab counts still count a voided ticket.
- **Default built:** **no field-side refusal, Calculate unchanged.** Job progress is untouched, as
  OQ-1 requires (it reads `status`). `findCompleteTicketsInRange` still prices every `COMPLETE`
  ticket, voided or not — work the crew actually submitted is paid, and the void record stays on the
  ticket. The void itself still refuses a ticket that is no longer `PENDING`/`SENT`/`IN_PROGRESS`, and
  every payroll reader of incomplete tickets ignores a voided one. The field list counts are
  unchanged (server side); the app drops voided tickets from its lists only.
- **Why:** OQ-1's written direction is that dispatch, job progress, billing and invoicing stay
  untouched, which rules out a new field-side guard. Not paying submitted work would be the riskier
  error (unpaid wages) than paying a ticket payroll had once voided.
- **Who answers:** developer (field behaviour), with Corrina Bustos (whether a voided-then-completed
  ticket is paid).
- **Status:** open (default built)

### OQ-7 — Where does the sidebar's open-flag count live, what does it count, and who sees it? (U5, REQ-14)
- **Question:** REQ-14 asks for "a count for Payroll Admin/Manager holders in navigation" and no source
  says which period it counts, where it sits, or whether a portal ADMIN/SUPER_ADMIN (who passes every
  permission check) sees it. The spec's API table (§4) also lists no route for it.
- **Default built:** a new read route `GET /v1/payroll/flags/summary` → `{ openCount }` (every `OPEN`
  flag in the tenant, all periods), gated `payroll-admin: view`, `@SkipThrottle()`, polled every 60 s
  — the same shape as the existing Returned Entries badge (`/payroll-corrections/summary`). Drawn as a
  count on the **Payroll Management** sidebar group header (a dot on the collapsed rail), shown to
  whoever passes `useCan('payroll-admin','view')` while the count is above zero — portal admins
  included, like every other `payroll-admin` gate in the web. Notifications still exclude the bypass
  (REQ-02's Notes); the badge is not a recipient list.
- **Why:** the units row says to reuse the app's existing nav-count mechanism rather than invent one;
  counting all periods means a flag left open on an older week is not hidden.
- **Who answers:** developer (UI placement and scope).
- **Status:** open (default built)

### OQ-8 — Should the in-app "payroll flags raised" notice open the worklist when clicked? (U5, REQ-13)
- **Question:** `payroll.flags_raised` carries the worklist URL in its context as `link`, and the email
  has an "Open payroll" button, but the web's notification navigator (`resolveNotificationHref`) only
  follows `quotationLink` / `jobLink` / `ticketLink` / `attachmentLink` and entity types — so the in-app
  row does not navigate. The existing `payroll.entry_corrected` notice behaves the same way.
- **Default built:** left as is — the notice is delivered in-app and by email (REQ-13's acceptance);
  the notifications feature is not changed by this unit.
- **Why:** no source asks for click-through, and changing the shared navigator is outside U5's slice.
- **Who answers:** developer.
- **Status:** open (default built)

### OQ-9 — Schema details spec §3 does not state: the event table's tenant column, its flag index, the unique key's name (U5, REQ-09)
- **Question:** three choices in the applied `20260930200000_payroll_flags` migration go beyond spec §3's
  Prisma block. (1) `payroll_flag_events` carries `tenant_company_id`, which §3 does not list. (2) No
  index on `payroll_flag_events.flag_id` (the panel and audit log read events by flag ids) and none on
  `payroll_flags (tenant_company_id, status)` (the sidebar count). (3) The unique key keeps Prisma's
  derived name (`payroll_flags_tenant_company_id_period_id_code_employee_id__key`) rather than the
  `uq_<table>_<what>` convention in `contexts/prisma.md`.
- **Default built:** (1) kept — `units.md` U5 requires both tables in the tenant-scoping allowlist, and
  the extension injects `tenantCompanyId` into every query of an allowlisted model. (2) no extra
  indexes — §3 lists none and §11 leaves performance `NOT SPECIFIED`. (3) Prisma's derived name, which
  the live schema and the migration agree on (`migrate diff` shows no drift for these tables). Any
  change is a new additive migration, not an edit of the applied one.
- **Why:** smallest change that satisfies the allowlist requirement; the rest is unspecified.
- **Who answers:** developer.
- **Status:** open (default built)

### OQ-10 — An overnight entry is two timesheet rows: does each row carry the open-flag mark, or only one? (U5 review fix, REQ-14)
- **Question:** REQ-14 asks for "flag indicators in the timesheet" and leaves layout `NOT SPECIFIED`.
  The timesheet now draws a shift that crosses midnight as one row per date, all with the same
  ticket (see OQ-11), so the mark rendered once per row showed twice for one ticket, with two
  elements carrying the same `data-testid` (`payroll-flags-ticket-chip-<code>`). The developer's
  fifth-addendum direction (`decisions/2026-09-28-flagged-entries-…md`, *Addendum 2026-09-30,
  fifth*, items A and C) has ticket-wide badges on every date row, which points the other way.
- **Default built:** **once per ticket**, on the first row of that ticket among the rows shown
  (`flagMarkRowIds` in `apps/web/src/features/payroll-flags/lib/payroll-flags.ts`). With the Daily
  Summary filtered to the later date, that date's row carries the mark. The flags panel above the
  table lists every open flag either way.
- **Why:** the review asked for one mark per ticket, and a repeated `data-testid` breaks the
  `qa-automation` contract (`getByTestId` matches two elements). Computing it over the shown rows
  means a date filter never hides the mark.
- **Who answers:** developer (timesheet layout).
- **Status:** open (default built)

### OQ-11 — Which ticket owns the one-row-per-date timesheet split that landed in the U6–U13 commit? (U5 review, containment)
- **Question:** commit `b4414f8e7` ("PAYROLL-FLAGS U6-U13", which also carries U5's web slice)
  added `TableJobDay` / `splitJobDaysForTable` (`payroll-job-day-dates.ts`) and wired it through
  `payroll-employee-table.{tsx,cells.tsx,cell-parts.tsx}` and `use-payroll-employee.ts`. No
  PAYROLL-FLAGS unit lists it, and `units-u6-u13.md` (*Findings* #4, U8's *Not brought over*) keeps
  the multi-day-row feature out of this ticket. It follows the developer's 2026-09-30 fifth-addendum
  direction (independent rows per date, same ticket code) but is not in any unit's slice table.
- **Default built:** **left in place, not reverted, not changed by this fix pass.** The working tree
  also holds uncommitted edits to it (`payroll-employee-table.tsx`, `payroll-job-day-dates.ts`,
  `lib/payroll-calendar-split.ts`) that this fix pass did not make. Splitting it into its own commit
  needs a history rewrite this builder may not do.
- **Why:** reverting would undo developer-directed work that is still being edited. Keeping it
  without a record would leave an unplanned feature in a PAYROLL-FLAGS PR.
- **Who answers:** developer. Move it to its own commit (or ticket) before the PR, or drop it. Check
  the row money against the fifth addendum's item B, which says rows add up to the entry and
  nothing is counted twice. The boom-range mark `payroll-entry-flag-<code>` also repeats on each
  date row.
- **Status:** open (default built)

### OQ-12 — The U5 and U6–U13 commits carry an AI `Co-Authored-By` trailer (U5 review, must-fix)
- **Question:** `d8ea31f04` and `b4414f8e7` both end with `Co-Authored-By: Claude Opus 4.6`.
  `CLAUDE.md` forbids AI attribution trailers on commits and PRs.
- **Default built:** **not rewritten.** Builders on this ticket may not amend, rebase or reset, so
  the trailer stays until the developer strips it. The branch has not been pushed.
- **Why:** rewriting shared history is the developer's call, and the review itself says to flag it
  rather than do it unasked.
- **Who answers:** developer. Reword both commits before the first push, and make sure the commit
  of this fix pass carries no trailer.
- **Status:** open (default built)

### OQ-13 — Whose is the uncommitted payroll-corrections rework in the working tree, and does it belong in PAYROLL-FLAGS at all? (PR #709 fix-pass review, containment)
- **Question:** after commit `929501926`, four files under
  `apps/web/src/features/payroll-corrections/components/` carry edits that no PAYROLL-FLAGS unit,
  no item of the PR #709 fix brief, and no builder report names:
  `returned-entries-list.tsx` (modified, regrouped by employee, rows open a dialog instead of the
  `/payroll-corrections/[id]` page), `correction-dialog.tsx` (new, untracked, 297 lines),
  `correction-times-section.tsx` (client-side "Must be between Start Work and End Work time"
  checks and a "Total payable hours" banner) and `correction-times-fields.tsx` (an `error` prop
  on `TimeField`). `units-u6-u13.md` U8 says these components are "reused, not modified" as U8's
  base. U9 (REQ-23) deletes the whole `features/payroll-corrections/` folder apart from what U8
  salvages. Both the error copy and the banner are new and have no written source.
- **Default built:** **left untouched in the working tree, not reverted, not stashed, and kept
  out of the PAYROLL-FLAGS fix-pass commit.** The commit step stages by explicit path and leaves
  out these four files, as it already leaves out the two OQ-11 row-split files
  (`payroll-job-day-dates.ts`, `lib/payroll-calendar-split.ts`). The files have to move in
  pairs. The modified `returned-entries-list.tsx` imports the untracked `correction-dialog.tsx`,
  so committing one without the other breaks the build. `correction-times-section.tsx` passes the
  new `error` prop, so it needs `correction-times-fields.tsx`. After this, the client repo's
  working tree holds no PAYROLL-FLAGS code. (OQ-11's mention of uncommitted
  `payroll-employee-table.tsx` edits is out of date: that file has no diff against `HEAD` now.)
- **Why:** reverting would destroy work whose owner is unknown, and builders on this ticket may
  not stash or check out. Committing it under PAYROLL-FLAGS would ship an unplanned feature that
  invents its own error copy and edits files U8 must keep as they are and U9 deletes. The rework
  also fails ESLint as it stands, with 9 errors the `HEAD` versions do not have:
  `returned-entries-list.tsx` (`max-lines` 362/300, two `no-duplicate-imports`),
  `correction-dialog.tsx` (`max-lines-per-function` 223/200, `complexity` 29/20) and
  `correction-times-section.tsx` (`max-lines-per-function` 231/200, three `no-magic-numbers`). So
  the `lint-staged` pre-commit hook would refuse a commit that included them. `tsc` passes.
- **Who answers:** developer. Say whose work this is and where it goes: its own branch or ticket,
  or folded into U8's entry-fix feature. If it stays in this tree, it conflicts with U9's
  deletion of the folder.
- **Status:** open (default built)

### OQ-14 — What the `REST_UNDER_8H` flag names, what counts as "a premium was paid", and what reopens a reviewed one (U6, REQ-15)
- **Question:** REQ-15 says the flag names "the previous ticket, the gap in hours, and whether
  `restForcedHours`/`restFloorMult` were non-null for that entry", and stops there. Five details
  are not stated: (1) which tickets go in `detail.tickets`, which is what the generic flags panel
  lists and where the timesheet draws its mark; (2) whether "a premium was paid" is judged on the
  chain's first day only or on the whole chain, since every day of a chain shares one gap;
  (3) what the fingerprint holds, which decides when a "Reviewed, no change" flag reopens;
  (4) the message copy; (5) units-u6-u13 U6 says the detector "reads persisted `PayrollJobDay`
  rows", but those rows carry no start or end time to order a rest chain by, and the prior-week
  context days that can start one are never persisted.
- **Default built:** (1) **both**: the previous ticket first, then the chain's first, in the same
  `{ticketId, ticketCode, startedAt, endedAt}` shape `OVERLAPPING_JOBS` uses, so the web needs no
  per-code branch. A previous ticket from last week is listed in the panel and has no row to mark.
  (2) **the whole chain**: `premiumPaid` is true when any priced day of the chain had forced
  hours. `detail` also carries the chain's `restForcedHours` and highest `restFloorMultiplier`.
  (3) previous ticket id, chain-first ticket id, gap hours, and premium paid yes/no. A change in
  any of them reopens a reviewed flag. (4) "Ticket X started 5.5h after the paid end of ticket Y —
  under 8 hours' rest. A rest-period premium was paid." / "No rest-period premium was paid."
  (5) the detector reads the engine's per-day result inside the run (`withPricedRest`), which is
  the same object `persistRun` writes to `PayrollJobDay`, plus the run's context days. Subject:
  the chain-first ticket. `jobTicketId`/`workDate`: the chain-first day's.
- **Why:** (1) REQ-15's demo says the flag names both tickets, and the U5 renderer reads only
  `detail.tickets`. (2) The flag is about the gap, and the premium for that gap can land on a
  later day of the chain. (3) These are the values a reviewer judged. Reopening on a premium change
  is the more cautious side. (4) Spec §5: copy is functional only. (5) The values are identical,
  and only this reading can order the chain and name a prior-week ticket.
- **Related, no new default:** "previous paid work" follows the run. Calculate loads `COMPLETE`
  tickets only, so a cancelled ticket, or one payroll voided before it was completed, is looked
  through, as REQ-15 says. A ticket payroll voided and the crew later completed is priced under
  OQ-6, so it counts as previous paid work.
- **Who answers:** developer (1)–(5). Corrina Bustos, with OQ-6, on whether a voided-then-completed
  ticket is paid work.
- **Status:** open (default built)

### OQ-15 — Send-back schema details spec §3 does not state: the group and reminder indexes, the responder's foreign key, the old supervisor index (U11, U12; REQ-25, REQ-29)
- **Question:** spec-u6-u13 §3 lists the new `PayrollSendBack` columns and nothing else. Three
  choices go beyond it. (1) Two new indexes. `idx_payroll_send_backs_tenant_return_group` on
  `(tenant_company_id, return_group_id)` serves the group hold, close and withdraw, which act on
  every row of a group. `idx_payroll_send_backs_status_next_reminder` on `(status,
  next_reminder_at)` serves the reminder cron, which scans every tenant from outside a request.
  (2) §3 types `respondedByUserId` only as `String? @db.Uuid`. It now also has a `User` relation,
  `ON DELETE SET NULL`, like `sentBy` and `correctedBy`. (3) `idx_payroll_send_backs_tenant_sent_to_status`
  is kept, although crew-wide rows leave `sentToEmployeeId` null.
- **Default built:** all three, in `20261005140000_payroll_send_back_crew_wide` and
  `20261005150000_payroll_send_back_reminders`.
- **Why:** (1) neither lookup has an index that leads with its columns, and one runs on every
  approval hold check, the other every 15 minutes. (2) a reply keeps its text when the replying
  user is deleted, the same as a send or a correction. (3) the supervisor queries that use it
  (`listForSupervisor`, `countOpenForSupervisor`) go when U9 retires that routing. Dropping the
  index belongs with that change.
- **Who answers:** developer.
- **Status:** open (default built)

### OQ-16 — Send-back statuses: what a "closed" group is stored as, and where `RESUBMITTED` lives (U11, U12, U13; REQ-25, REQ-29, REQ-30)
- **Question:** (1) REQ-25 adds `POST /v1/payroll/send-backs/:id/close` ("after a REQ-19 fix, or
  after accepting a worker's reply"), and REQ-29 stops reminders "once the row is `RESPONDED`,
  closed, or `WITHDRAWN`". Neither names a status for closed, and §3 adds only `WITHDRAWN` and
  `RESPONDED`. (2) REQ-30's Notes leave `RESUBMITTED`'s model `NOT SPECIFIED` and ask the builder to
  document the choice.
- **Default built:** (1) no `CLOSED` value. `PayrollSendBackStatus` is `SENT_BACK`, `CORRECTED`,
  `WITHDRAWN`, `RESPONDED`, `RESUBMITTED`. The resolved state available for a closed group is
  `CORRECTED`, with `correctedAt` and `correctedByUserId` recording when it was closed and by whom.
  A separate `CLOSED` value needs its own migration. (2) `RESUBMITTED` is a `PayrollSendBackStatus`
  value (`20261005160000_payroll_send_back_resubmitted`), REQ-30's stated default home.
  `JobTicket.status` is untouched.
- **Why:** (1) a status no source names would settle U11's design from the schema side.
  `CORRECTED` already means "resolved, kept as history" and has the who and when columns.
  (2) resubmission is what ends a return group's wait for the crew, so it belongs on the group's
  rows. No stronger existing home was found.
- **Who answers:** developer (U11 and U13 design).
- **Status:** open (default built)

### OQ-17 — May a ticket time adjustment have no "before" or no "after" time? (U14, REQ-41)
- **Question:** REQ-41 audits every lunch add, remove and switch on a returned ticket with "who,
  when, before/after, reason". REQ-40's Notes propose the existing `TicketTimeAdjustment` table for
  that audit (option (a)). Its `initialTime` and `adjustedTime` were `NOT NULL`, so an add (no
  before) or a remove (no after) could only be recorded with an invented time. `units-u14-u21.md`
  U14 says "Schema: None", which is now out of date.
- **Default built:** both columns are nullable (`20261005180000_payroll_schema_alignment`, `DROP
  NOT NULL` only, no data change). Null `initialTime` means the capture was added, and null
  `adjustedTime` means it was removed. The only writer today, `recordTicketStep`, still sets both,
  and the repository's create input still requires both. Nothing changes until U14 widens that
  input. How U14 keys a switch (same times, different kind) and a lunch's two ends in `stepKey`
  stays open, as REQ-40/41's Notes say.
- **Why:** the table could not hold the audit REQ-41 asks for, and U14's builder may not change the
  schema. A second audit table (REQ-40's option (b)) would split one trail in two.
- **Who answers:** developer.
- **Status:** open (default built)

### OQ-18 — `TicketEmployeeTimeOverride` details spec §3 does not state (U19, REQ-47)
- **Question:** four choices go beyond spec-u14-u21 §3's block. (1) An index on
  `(tenant_company_id, ticket_employee_id)`, `idx_ticket_employee_time_overrides_tenant_member`.
  (2) A partial unique index, `uq_ticket_employee_time_overrides_member_type_no_seq` on
  `(ticket_employee_id, type) WHERE sequence IS NULL`. Postgres treats NULLs as distinct, so the §3
  key `(ticket_employee_id, type, sequence)` does not stop two overrides of a single-row type
  (`WORK_TIME`, `YARD_TIME` and the others with a null `sequence`) for one member. (3) Delete
  rules: `ticketEmployee` `CASCADE`, `createdBy` `RESTRICT` (like
  `TicketTimeAdjustment.adjustedByUser`), `tenantCompany` the default `RESTRICT`. (4) `map:` gives
  the unique key the §3 name in the database too. Related: with these keys, REQ-47's proposed "new
  row each time" cannot hold a second correction for the same `(member, type, sequence)`. U19's
  slice already proposes refusing it with a 409.
- **Default built:** all four, in `20261005170000_ticket_employee_time_overrides`.
  `ticketemployeetimeoverride` is in the tenant-scoping allowlist, as U19's slice asks.
- **Why:** (2) REQ-47's acceptance says "the same combination cannot hold two active overrides at
  once". Without the partial index that holds only for numbered types. Prisma does not diff partial
  indexes, so `migrate diff` stays clean (same as `uq_job_permit_type_assignment_no_asset`).
  (3) an override is an audit fact. Deleting its author must not delete or orphan it, and deleting
  the roster row takes the member's corrections with it. As with OQ-19, a hard user delete now
  fails for a user who made an override. (4) keeps the name stable under a later `migrate dev`.
- **Who answers:** developer. Whoever confirms U19's 409 also settles update-in-place against
  append-only (REQ-47's Notes).
- **Status:** open (default built)

### OQ-19 — `PayrollEntryFix.fixedByUserId` is required: what happens when its user is deleted? (PR #709 schema alignment, REQ-18)
- **Question:** spec-u6-u13 §3 types `fixedByUserId` as required, but the applied
  `20261005100000_payroll_entry_fixes` made it nullable with `ON DELETE SET NULL`. §3 gives no
  delete rule, and a required column cannot be set to null.
- **Default built:** `fixed_by_user_id` is `NOT NULL` with `ON DELETE RESTRICT`
  (`20261005180000_payroll_schema_alignment`). The only create path,
  `PayrollEntryFixesController.create` → `PayrollEntryFixesService.create` →
  `PayrollEntryFixesRepository.create`, always sets it from the signed-in user. The migration fails on a database that already holds a fix with no author.
  Prisma's warning says so at the top of the file.
- **Why:** a fix is the audit record of a pay change. `RESTRICT` keeps it, as
  `TicketTimeAdjustment.adjustedByUser` and `TicketTimeEntry.capturedByUser` already do. `CASCADE`
  would delete the audit with the user. Side effect: deleting a user in Admin → Users
  (`AdminUsersService.remove`, a hard delete) now fails with a foreign-key error for anyone who
  made an entry fix, as it already does for anyone who captured ticket times. `REVOKED` stays the
  way to withdraw access.
- **Who answers:** developer.
- **Status:** open (default built)
