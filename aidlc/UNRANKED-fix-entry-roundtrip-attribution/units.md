# Units — UNRANKED-fix-entry-roundtrip-attribution: PM/PA round-trip on Fix entry, every change attributed

> Written to `.ai/aidlc/UNRANKED-fix-entry-roundtrip-attribution/units.md` from the approved `spec.md` beside it.
> Decomposer output. Nothing here has been built. Consumed by an executor, one unit at a time.
> Developer decisions folded in (from the caller, 2026-10-13): D1 = two nullable FKs
> (`sendBackId`, `entryFixId`) + DB CHECK exactly-one; D1b = new table only, no backfill; role =
> page-derived, client sends `role: 'PM' | 'PA'` on every write, server validates and stores the
> resolved label; PM lock = `SENT_BACK`, `RESPONDED`, `RESUBMITTED`.
> Those decisions were made after the spec was frozen, and three of them disagree with its text.
> The disagreements are spec.md §12 Q18-Q21 (appended by this run). Read them first.

## Blocked / cut first

- **U5 (Legacy rows + chip) is blocked on Q20.** D1b says "existing rows remain unread" and also
  says "the Legacy chip covers display of pre-ship data". Both cannot hold: a chip needs a reader
  that reads the old JSON. REQ-12 is uncovered until a developer answers.
- **"Stop writing `correctionChanges`" is cut from every unit, blocked on Q19.**
  `payroll-send-backs.repository.ts:643` (`countBlockingByEmployee`) treats a `CORRECTED` row with
  `correctionChanges not null` as an approval hold. If new corrections stop writing that column,
  a corrected-after-run entry silently stops holding the week. U1 therefore leaves line 888
  (`correctionChanges: params.changes`) exactly as it is (dual-write by non-change). That is not a
  decision to dual-write; it is the absence of the part nobody can safely decide yet.
- **U4 is cut down:** the server lock covers `PATCH payroll-corrections/:id` only. Whether it also
  covers `POST`/`PATCH` on the entry-fix route is Q21 (REQ-05 says "PM cannot edit it"; §4 names
  only `submitCorrection`). Recorded in U4 *Deliberately not*.
- **Pre-build developer rows still blank in spec §11b that bind U1:** D1(ii) `round` on entry-fix
  rows (null vs counter), D7 role column type, D5 pattern reference. The executor stops on them;
  it does not pick. `tcg-prisma-guardian` is required on U1 (new tenant entity, migration, CHECK).

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | A correction submitted from Fix entry / Returned Entries is logged change-by-change with author, role and time, and the Correction Dialog shows the cumulative timeline across rounds | REQ-01 (send-back source), REQ-02, REQ-11 (send-back source), REQ-14 (send-back path) | schema, api, web | — | M (~370 lines, ~17 files; tight) | not started |
| U2 | A direct entry fix is logged and attributed too, and `EntryFixView` and the sent-back banner show the same unified timeline with role | REQ-01, REQ-02, REQ-11, REQ-13, REQ-14 (entry-fix path) | api, web | U1 | M (~210 lines, ~11 files) | not started |
| U3 | A Payroll Manager (`payroll:edit` only) can preview, send an entry back to Payroll Admin, and withdraw it; Close stays PA-only | REQ-04, REQ-07, REQ-09 | api, web | U1 | M (~150 lines, ~10 files) | not started |
| U4 | PM is locked out while PA holds the entry (hidden button + server refusal) and can re-edit after `CORRECTED` | REQ-03, REQ-05 (PATCH path), REQ-06, REQ-08, REQ-10 | api, web | U1 | M (~130 lines, ~8 files) | not started |
| U5 | Pre-ship corrections render in the timeline with a grey "Legacy" chip | REQ-12 | api, web | U1 | S (~90 lines, ~5 files) | **blocked — Q20** |

- Totals: 5 units — 5 vertical, 0 foundation. Buildable now: U1-U4, ~860 source lines. With U5, ~950.
- **Requirements: 14 in spec, 13 covered by U1-U4, 1 uncovered (REQ-12, U5, Q20).** Partly covered: REQ-05
  (PATCH path only, entry-fix endpoints = Q21), REQ-01 (new-table history only; pre-ship history = Q20).
  Count check: REQ-01..14 all appear below; nothing appears without a REQ.
- Units blocked on an open question: **U5 — Q20.** Parts of U4 — Q21. The "stop writing
  `correctionChanges`" half of D1b — Q19. Q18 (role-source disagreement) does not block; it needs
  the spec text re-synced to the developer's decision before sign-off.
- No `foundation` unit was used. Schema ships inside U1 together with the first write and the first
  read, so the reviewer can check the table against a real row on a real screen.
- **`[UNVERIFIED]` + hard to undo:** none. U1's migration is a new table, droppable, and touches no
  existing row. The only persisted shape that outlives it is the role label string (D7) —
  re-confirm D7 with the developer before U1 merges, not after rows exist.

---

## U1 — Send-back changes logged and attributed; cumulative timeline in the Correction Dialog

- **Outcome:** After a Payroll Admin (from Returned Entries) or a Payroll Manager (from Weekly
  Payroll Fix entry) submits a correction, the dialog's Changes list shows every change from every
  round, oldest first, each as "Name (Role)" with date/time.
- **Kind:** vertical.
- **Requirements covered:** REQ-01 (send-back source only), REQ-02 (Correction Dialog only), REQ-11
  (send-back source), REQ-14 (send-back submit path, with the client-supplied `role` per Q18).
- **Depends on:** —
- **Branch / PR base:** `feat/UNRANKED-fix-entry-roundtrip-attribution-u1-change-log` from `origin/main`.
  Stage 1 (the uncommitted `payroll:edit` gate / Fix entry work in the primary checkout) must be
  merged first; this unit edits the same files. If it is not, stack on its branch.
- **Size estimate:** ~370 source lines, ~17 source files. **Tight.** Executor measures before
  push; over 400 / 25 means stop and ask for a split, do not push.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma/schema.prisma`) | New model (name = developer's; e.g. `PayrollChangeLog`): UUID PK, `tenantCompanyId`, `periodId`, `employeeId`, `ticketId`, `round`, `authorId`, `authorName`, `authorRole`, `changedAt` (`@db.Timestamptz`), `field`, `label`, `before`, `after`, `sendBackId?`, `entryFixId?`; relations to `PayrollSendBack` and `PayrollEntryFix`; index `(tenantCompanyId, periodId, employeeId, ticketId, changedAt)` | `@map`/`@@map` snake_case. Both FKs exist from this unit so U2 needs no second migration. D1(ii), D7 types from the developer. `tcg-prisma-guardian` review |
| Schema (migration) | One committed migration: create table + `CHECK ((send_back_id IS NULL) <> (entry_fix_id IS NULL))` | Prisma cannot express the CHECK: hand-edit the SQL. Reversible (drop table). Excluded from size |
| API `service/` | New `payroll-change-log.repository.ts` (+ barrel export): `appendMany(tx?, rows)`, `listByEntry(tenant, periodId, employeeId, ticketId)` ordered `changedAt, id` | Reuse the `$transaction` array form `applyCorrection` already uses (`repository.ts:~840-890`); check `contexts/prisma.md` tenant-extension allowlist for the new model |
| API `service/` | `payroll-send-backs.repository.ts` `applyCorrection` (:~884): add the log inserts inside the existing transaction; **leave `correctionChanges: params.changes` untouched** | Q19: stop-writing is cut. Same transaction so a failed log insert rolls back the correction |
| API `usecase/` | New `payroll-author-role` resolver: given `userId` + client `role`, returns `"Payroll Manager"` / `"Payroll Admin"`; `role:'PA'` requires `payroll-admin:edit`, `role:'PM'` requires `payroll:edit`, else 403 | Shared by U2, U3, U4. Find the existing permission lookup (the `RequirePermission` guard's source) and reuse it; do not create a second permission reader. Fallback "primary department role name" (REQ-14 third branch) = D7 lookup |
| API `usecase/` | `payroll-send-backs.service.ts` `submitCorrection` (:~865): resolve role, map `plan.changes` + the `craftModifier` change to log rows with `round` (count of prior send-backs for the triple + 1; the rule is D1(ii)'s sibling decision, executor asks), call repository | `allChanges` already exists at :~890 — map it, do not recompute |
| API `usecase/` | `toView` / `getOne` (:~1190-1215): add `timeline` (log rows by the triple, oldest first, author name + role + `changedAt`) beside the existing `correctionChanges` field | Existing field stays: banner and other readers keep working until U2 |
| API `presentation/` | `SubmitCorrectionDto` + controller `PATCH payroll-corrections/:id`: required `role` (`'PM' \| 'PA'`), passed through | New request field = developer decision, taken (caller 2026-10-13). `PreviewCorrectionDto` stays unchanged here, role on previews moves to U4 |
| API module wiring | Provider/barrel for the new repository and resolver | Barrel `index.ts` at each layer boundary |
| Web `features/payroll/services/payroll-send-backs.service.ts` | Add `timeline` row type (`authorName`, `authorRole`, `changedAt`, `field`, `label`, `before`, `after`); add `role` to the submit payload | Web declares its own types (spec §7) |
| Web `features/payroll-corrections/components/correction-dialog.tsx` | Derive `role` from the entry route: opened from Returned Entries = `'PA'`, from Weekly Payroll Fix entry = `'PM'`; send on submit | Page-based, not permission-based (caller decision). Entry mode is already known at :160-167 (`fix-entry` vs returned) |
| Web `correction-dialog-sidebar.tsx` (:179) | Render `timeline` rows "Name (Role)" + time instead of `correctionChanges` when present | Run `find-component` before adding anything; no new component planned. Row visual beyond the format is `NOT SPECIFIED` |
| Tests | API: `submitCorrection` appends rows and never overwrites; two rounds on one triple read back in order; resolver label for each role and 403 on mismatch; log insert and correction commit/roll back together; migration CHECK rejects both-null and both-set. Web: sidebar renders "Name (Role)" + time, oldest first | Per spec §10 rows 1, 3, 4, 6 |

### Reviewable as

- **Demo:** Returned Entries -> open a returned entry as PA -> change Start Work -> submit. Reopen the
  dialog: the Changes list shows one row "Jordan Blake (Payroll Admin)" with time. Weekly Payroll ->
  Fix entry as PM on a `CORRECTED` entry is not yet possible (U4); a PM can still submit on a
  `SENT_BACK` entry today (Stage 1) and the row reads "(Payroll Manager)".
- **Acceptance:** REQ-02 (name + bracketed role + time; role unchanged after permissions change),
  REQ-11 (repeat same-field edits are separate ordered rows), REQ-01 send-back half, REQ-14 (label
  snapshotted; per Q18 chosen from the client `role`, validated server-side).
- **Reviewer can verify without:** U2-U4, the PM send-back button, or seed data for entry fixes.

### Risk

- **Weakest source:** `[VERIFIED*]` (developer answer; vault-side still `[UNVERIFIED]`, decision note pending Q9).
- **Migration reversible:** yes — new table, no existing row touched.
- **Behind a flag:** no.
- **Touches existing data:** no. No backfill (D1b).
- **Blast radius:** a wrong log insert rolls back every correction submit (same transaction). New required `role` field on `PATCH payroll-corrections/:id`: only web calls it (`git grep` in `apps/mobile`/`qa-automation` found no caller; executor re-runs). Tenant leak if the new model is missing from the `$extends` allowlist — the guardian's first check.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `payroll-send-backs.repository.ts:643` `countBlockingByEmployee` (approval hold on `correctionChanges not null`) | the column, untouched | existing `payroll-send-backs.repository.spec.ts:166`, `payroll-send-backs.hold.spec.ts` stay green; add one case: a `CORRECTED` submit still holds after the unit | spec §11a row 2 (D1/D1b); Q19 |
| `payroll-send-backs.service.ts:1207` `toView` consumers (banner `payroll-entry-send-back-state.tsx:115,155`) | `correctionChanges` field, kept | `payroll-send-backs.service.spec.ts` case asserting `correctionChanges` still returned alongside `timeline` | spec §11a row 3; unchanged until U2 |
| Notifications / reminder cron reading `PayrollSendBack` rows | `notification-scheduled-jobs.service.spec.ts:165` fixtures | none needed: no column added to `PayrollSendBack` (relations only) — executor confirms with `git grep -n 'payrollSendBack.update' apps/api/src` | spec §11a row 5 |
| `PATCH payroll-corrections/:id` web caller | `role` now required | web service test in the touched file | caller decision (role from page) |

### Deliberately not in this unit

- Entry-fix writes, `EntryFixView`, banner — U2.
- `role` on preview / send-back / withdraw — U3, U4.
- Stopping the `correctionChanges` write — blocked, Q19.
- Legacy rows and chip — U5, Q20.
- `CORRECTED` re-edit and the lock — U4.

---

## U2 — Direct entry fixes logged and attributed; unified timeline everywhere

- **Outcome:** A direct Fix entry by PM or PA adds attributed rows to the same timeline, and
  `EntryFixView` and the sent-back banner show send-back history and fix history together with
  "Name (Role)".
- **Kind:** vertical.
- **Requirements covered:** REQ-01 (entry-fix source, both screens), REQ-02 (remaining screens),
  REQ-11 (entry-fix source), REQ-13, REQ-14 (entry-fix path).
- **Depends on:** U1
- **Branch / PR base:** `feat/UNRANKED-fix-entry-roundtrip-attribution-u2-fix-timeline`, stacked on U1's branch while its PR is open.
- **Size estimate:** ~210 source lines, ~11 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | `entryFixId` FK and CHECK already shipped in U1 |
| API `presentation/` | `payroll-entry-fixes.controller.ts` `POST`/`PATCH`/`/preview` (:39, :59, preview): DTOs (`fix-entry.dto.ts`, `preview-entry-fix.dto.ts`) gain required `role` | Reuses U1's resolver. The two `GET`s do not write |
| API `usecase/` | `payroll-entry-fixes.service.ts` `create`/`amend` (:242-300): resolve role, append log rows from `plan.changes` (`entry-fix-plan.ts:116` shape) in the same write as the `PayrollEntryFix` row; `getFix` returns `timeline` | `PayrollEntryFix.changes` JSON stays written (D1b: not stopped). `round` for entry-fix rows per the D1(ii) answer |
| API `service/` | `payroll-entry-fixes.repository.ts`: accept log rows in the create transaction | Reuse U1's `appendMany` |
| Web `entry-fix-view.tsx` (:91) | Role beside the existing `fixedBy` name; render the unified `timeline`; send `role` (`'PM'` when routed from Weekly Payroll, `'PA'` when from `/payroll/[employeeId]/entries/[ticketId]` under PA) | Page-derived role. Existing name/time rendering must not regress |
| Web `payroll-entry-send-back-state.tsx` (:115, :155) | Banner changes list reads `timeline` | `canResolve` at :283 belongs to U3, do not touch here |
| Web `features/payroll/services` (entry-fix service) | `role` in fix/amend/preview payloads; `timeline` type | Reuses U1's row type |
| Tests | API: create + amend append rows, amend does not rewrite earlier rows; a send-back round then a direct fix read back as one ordered list; web: `EntryFixView` shows role, shows send-back rows | Spec §10 rows 4, 6 |

### Reviewable as

- **Demo:** PM Fix entry on a never-returned entry (`/payroll/[employeeId]/entries/[ticketId]`) ->
  change a time -> save; the view lists "Name (Payroll Manager)". Then send that entry back, PA
  corrects, and the same list shows both rows in order.
- **Acceptance:** REQ-13 acceptance (role beside name, older fixes still render); REQ-01 acceptance
  scenario (direct fix, send-back, second change, all rows oldest first, from either screen).
- **Reviewer can verify without:** U3, U4.

### Risk

- **Weakest source:** `[VERIFIED*]`.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** a bad append fails `create`/`amend` of an entry fix (same transaction): payroll cannot fix entries. New required `role` field on four entry-fix routes: web is the only caller (executor greps `qa-automation/e2e` for the routes; `data-testid`s on `EntryFixView` are a contract, so no renames).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `entry-fix-view.tsx:91` fixedBy/fixedAt per fix group | same component | `payroll-entry-fixes.service.spec.ts` + a web render case with a pre-feature fix (no log rows) still showing name and time | spec REQ-13 |
| `payroll-flags-panel.tsx:79` "Fix entry" link into `EntryFixView` | the view it opens | smoke: view renders with and without a timeline | spec §11a row 13 (unchanged) |
| `GET periods/:id/entry-fixes` (`listForPeriod`) and `entry-fix-plan.ts` consumers | `PayrollEntryFix.changes` still written | `entry-fix-plan.spec.ts`, `payroll-entry-fixes-permission.spec.ts` stay green | spec §11a row 4 |
| Banner `payroll-entry-send-back-state.tsx:115,155` | `timeline` replaces `correctionChanges` | web case: banner renders for a `CORRECTED` row that has only legacy `correctionChanges` and no log rows (falls back to today's behaviour, no chip). **Q20 decides whether the chip is added** | spec §11a row 3; Q20 |

### Deliberately not in this unit

- Lock and `CORRECTED` re-edit — U4. Gates/buttons — U3. Legacy chip — U5 / Q20.
- Stopping the `PayrollEntryFix.changes` JSON write — Q19 (same decision as `correctionChanges`).

---

## U3 — Payroll Manager can send back and withdraw

- **Outcome:** A user with `payroll:edit` only sees "Send Back To Payroll Admin" and "Withdraw
  send-back" on Weekly Payroll, can preview and send an entry back, and can withdraw it; Close
  stays Payroll-Admin-only.
- **Kind:** vertical.
- **Requirements covered:** REQ-04, REQ-09, REQ-07 (acceptance: no PA-side control creates a
  PM-bound round — asserted by test, no code).
- **Depends on:** U1 (role resolver / validator)
- **Branch / PR base:** `feat/UNRANKED-fix-entry-roundtrip-attribution-u3-pm-send-back`, stacked on U1.
- **Size estimate:** ~150 source lines, ~10 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | none |
| API `presentation/` | `payroll-send-backs.controller.ts`: preview `GET` (:43), send `POST` (:56), withdraw `POST` (:82) -> `RequirePermission('payroll','edit')`; `close` (:71) unchanged; `role` accepted on each (query param on the `GET` and the bodiless `withdraw`, body on `POST`) | Existing routes lowered, no new routes (D3 leaning, developer confirms). Param location is the developer's; the executor asks |
| API `usecase/` | `payroll-send-backs.service.ts` `previewSendBack`/`sendBack`/`withdrawGroup`: call U1's resolver with the client `role` | `role:'PM'` needs `payroll:edit`; `role:'PA'` needs `payroll-admin:edit` |
| Web `payroll-employee-timesheet.tsx` (:106, :186) | `canActOnTickets` -> `payroll:edit` for the Send Back button | |
| Web `payroll-employee-table.expanded.tsx` (:404-411) | Send Back button visible to `payroll:edit` | Fix entry gate at :375 is U4's hunk: same file, different lines |
| Web `payroll-entry-send-back-state.tsx` (:283) | Split `canResolve`: Withdraw visible to `payroll:edit`, Close stays `canAdminister` | Two separate conditions (spec REQ-09 notes) |
| Web `payroll-send-back-dialog.tsx` + send-back service | Send `role: 'PM'` from Weekly Payroll, preview and send; withdraw sends role | Page-derived, as U1 |
| Tests | API: `payroll:edit`-only user previews, sends, withdraws; `close` refused 403 for them; `role:'PA'` without `payroll-admin:edit` refused. Web: Withdraw visible and Close hidden for `payroll:edit`-only | Spec §10 rows 2, 5 |

### Reviewable as

- **Demo:** log in as a `payroll:edit`-only user (seed `ROLE-ACCOUNTS-PM`) -> Weekly Payroll
  expanded row -> Send Back To Payroll Admin -> pick an admin -> sent; the entry appears on
  Returned Entries for a PA; Withdraw it from the banner; Close is absent.
- **Acceptance:** REQ-04 and REQ-09 acceptance lines; REQ-07 (no PA control starts a PM-bound round).
- **Reviewer can verify without:** U2, U4.

### Risk

- **Weakest source:** `[VERIFIED*]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** every `payroll:edit` holder gains send-back and withdraw. Withdraw releases every crew member's week hold (REQ-25) — deliberate (dev-final Q12). A PA mid-edit gets a 409 "already corrected" on submit after a PM withdraw; copy is `NOT SPECIFIED` (spec §13).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `payroll-send-backs.controller.ts` PA callers (Weekly Payroll as PA, Returned Entries) | lowered `RequirePermission` | permission spec case: `payroll-admin:edit` holder still passes | dev-final Q12 |
| `payroll-employee-timesheet.tsx:106` `canActOnTickets` other users | one flag, several buttons | web case: PA still sees all buttons; the same flag does not unlock any other control (executor reads the file's use sites) | spec §11a row 7 |
| `payroll-entry-send-back-state.tsx:283` `canResolve` -> Close / Withdraw | split | web case: PA sees both; PM sees Withdraw only | spec §11a row 10 |
| `POST :id/send-to-employee` (`payroll-corrections.controller.ts:74-75`) | same flows | unchanged — assert still `payroll-admin:edit` | spec §11c, §8 |

### Deliberately not in this unit

- Hiding Fix entry, the server lock, `CORRECTED` re-edit — U4.
- Role label on change rows — U1/U2 (this unit only validates `role`).

---

## U4 — PM lock while PA holds the entry; PM re-edit after `CORRECTED`

- **Outcome:** While an entry is `SENT_BACK`, `RESPONDED` or `RESUBMITTED` the PM sees no Fix entry
  button and the server refuses a PM submit; once PA closes it (`CORRECTED`) the PM can Fix entry
  again, repeatedly.
- **Kind:** vertical.
- **Requirements covered:** REQ-05 (PATCH path only), REQ-08, REQ-10, REQ-06, REQ-03 (acceptance: a
  PM->PA->PM->PA cycle leaves the enum unchanged and adds one send-back row per loop).
- **Depends on:** U1 (`role` on `PATCH payroll-corrections/:id`, resolver)
- **Branch / PR base:** `feat/UNRANKED-fix-entry-roundtrip-attribution-u4-pm-lock`, stacked on U1.
- **Size estimate:** ~130 source lines, ~8 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | enum unchanged (REQ-03) |
| API `usecase/` | `submitCorrection` status guard (:874-879): allowed set by validated role — `PA`: `SENT_BACK`, `RESUBMITTED` (as today); `PM`: `CORRECTED` only; `PM` while `SENT_BACK`/`RESPONDED`/`RESUBMITTED` -> 409/403 | `PA` on `CORRECTED` stays 409 (REQ-07: PA never initiates — executor's reading of REQ-10 "for PM"; flag if the developer disagrees). `PA` on `RESPONDED` unchanged (spec §13) |
| API `usecase/` | Same check on `POST payroll-corrections/:id/preview`: accept `role`, refuse the PM lock | Closes the preview half of the lock; `PreviewCorrectionDto` gains `role` |
| Web `payroll-employee-table.expanded.tsx` (:375) | Fix entry shown when (`payroll:edit` or `payroll-admin:edit`) and (no send-back, or status `CORRECTED`/`WITHDRAWN`); hidden otherwise | Status already on the row via the send-back state; hide, not disable (REQ-05) |
| Web `payroll-employee-table.tsx`, `payroll-employee-timesheet.tsx` | Pass the three-status lock input if not already available | Only if the expanded row lacks the status |
| Web `correction-dialog.tsx` (:160-167), `correction-dialog-sections.tsx` (:193) | `fix-entry` mode for PM editable only on `CORRECTED`; `RESPONDED` treated like `SENT_BACK` | Re-narrows Stage 1's relaxation for PM only; PA unchanged |
| Web submit/preview payloads | `role` on preview | `role` on submit already shipped in U1 |
| Tests | API: PM refused in each of the three statuses; PM accepted on `CORRECTED` twice with both appearing in the log (REQ-10 acceptance); PA unchanged on `SENT_BACK`/`RESUBMITTED`; PA on `CORRECTED` -> 409. Web: Fix entry visibility table, permission x `SENT_BACK`/`RESPONDED`/`RESUBMITTED` (hidden) and `CORRECTED`/`WITHDRAWN`/none (shown) | Spec §10 rows 1, 5 |

### Reviewable as

- **Demo:** as PM, send an entry back (U3) -> Fix entry disappears; `PATCH` it directly with curl as
  PM -> refused. As PA, correct and submit -> status `CORRECTED` -> PM sees Fix entry, edits twice;
  both appear in the Changes list.
- **Acceptance:** REQ-05, REQ-08 (full table), REQ-10 (submit twice, both logged), REQ-06 (two
  consecutive rounds succeed), REQ-03.
- **Reviewer can verify without:** U2, U3 (a PA-created send-back plus Stage 1 is enough to see the lock).

### Risk

- **Weakest source:** `[VERIFIED*]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** the 409 guard is also what stops double submits today; widening it to `CORRECTED` for PM removes that protection after `CORRECTED` — accepted (dev-final Q17, D6). Wrong status test locks PM out or lets PA through.
- **Open sub-decision — locked visual:** none is specified. Spec says the button is hidden, nothing replaces it, and copy for the PM-refused 409 is `NOT SPECIFIED`. This unit builds no "locked" indicator; if product wants one, that is a new requirement for spec §12, not a unit row.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Stage 1 PM `fix-entry` submit on `SENT_BACK` (`correction-dialog.tsx:160-167`) | `readOnly` relaxation | web case: PM on `SENT_BACK` read-only, PA editable | spec §11a row 12; dev-final Q13 |
| `submitCorrection` PA submit from Returned Entries | status guard | existing `payroll-send-backs.service.spec.ts` PA cases stay green; add PA `RESUBMITTED` case | spec §11a row 11 |
| `countBlockingByEmployee` hold (`CORRECTED` + `correctionChanges not null`, `correctedAt > latestRun`) | a PM re-edit on `CORRECTED` rewrites `correctedAt`/`correctionChanges` | case: a PM re-edit after a Calculate re-holds the week (the existing query's meaning) | spec §11a row 2; executor confirms the intended behaviour with the developer, not a spec line |
| "Ticket already returned" 409 (`send-back-statuses.ts`) | new send-back after `CORRECTED` | case: a second send-back after `CORRECTED` is not blocked (REQ-06 says "not tested") | spec REQ-06 |
| `RESPONDED`/`RESUBMITTED` employee leg (mobile) | status maps | none — enum unchanged; `git grep -n correctionChanges apps/mobile packages/shared` returned no hits | spec §6, §11a row 5 |

### Deliberately not in this unit

- Lock on `POST`/`PATCH` of the entry-fix route (`payroll-entry-fixes.controller.ts:39,59`) for a PM while the entry is `SENT_BACK`/`RESPONDED`/`RESUBMITTED` — **Q21**. Until answered, a PM calling the entry-fix API directly bypasses the lock; the UI routes to `EntryFixView` only when no send-back exists.
- Copy for refusals — `NOT SPECIFIED` (spec §13).

---

## U5 — Legacy rows and the grey "Legacy" chip   **BLOCKED — Q20**

- **Outcome:** An entry corrected before this ships still shows what changed, with a grey "Legacy" chip where the author would be.
- **Kind:** vertical.
- **Requirements covered:** REQ-12.
- **Depends on:** U1 (and U2 for the other screens)
- **Branch / PR base:** `feat/UNRANKED-fix-entry-roundtrip-attribution-u5-legacy-chip` stacked on U1/U2 — not to be created until Q20 is answered.
- **Size estimate:** ~90 source lines, ~5 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | no backfill (D1b) |
| API `usecase/` | Timeline reader: for a triple with `PayrollSendBack.correctionChanges` and no log rows, return those as rows with null author | **The part Q20 decides.** D1b currently says legacy rows are "unread" |
| Web | Grey "Legacy" chip in the author slot of null-author rows (existing `Badge`; `find-component` first) | Chip text "Legacy" is the only sourced copy |
| Tests | Reader returns legacy rows for a pre-ship send-back; chip renders; ordering with new rows | REQ-12 acceptance |

### Reviewable as

- **Demo:** open an entry corrected before the migration; its changes appear with a "Legacy" chip.
- **Acceptance:** REQ-12 ("an existing `correctionChanges` row renders the chip; no backfill").
- **Reviewer can verify without:** U3, U4.

### Risk

- **Weakest source:** `[VERIFIED*]`; the mechanism is contradicted inside D1b itself.
- **Migration reversible:** N/A. **Behind a flag:** no. **Touches existing data:** reads only. **Blast radius:** low.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Banner / sidebar readers of `correctionChanges` | the column read at read time | **none — unbuilt until Q20** | **OPEN — Q20** |

### Deliberately not in this unit

- Whether `PayrollEntryFix.changes` pre-ship JSON also shows (its fixes always had an author, so no chip) — Q20.

---

## Sequencing

```
U1 ──▶ U2
  ├──▶ U3
  ├──▶ U4
  └──▶ U5 (blocked, Q20)
```

- **Parallelisable after U1:** U2, U3, U4, as stacked PRs each on U1's branch. Collisions are by file, not table (U1 owns the only schema/migration change):
  - U2 owns `payroll-entry-fixes.*` (controller, service, repository, DTOs) and `entry-fix-view.tsx`.
  - U3 owns `payroll-send-backs.controller.ts`, `payroll-send-back-dialog.tsx`, `payroll-employee-timesheet.tsx`.
  - U4 owns `submitCorrection`'s guard, `correction-dialog-sections.tsx`.
  - **Shared files (different hunks, expect a trivial rebase for whoever merges second):** `payroll-employee-table.expanded.tsx` — U3 at :404-411, U4 at :375; `payroll-entry-send-back-state.tsx` — U2 at :115/:155, U3 at :283; `payroll-send-backs.service.ts` — U3 (`sendBack`/`withdrawGroup`) vs U4 (`submitCorrection` guard), both after U1's edits to `submitCorrection`.
  - U2 and U4 have no shared file; they are the safest pair. U3 shares a file with each of them.
- **Merge order constraint:** U1 first. It carries the only migration and the shared resolver. No other unit has a migration, so there is no migration ordering after that.
- **Cross-surface window:** none introduced. `packages/shared` and mobile are untouched. Between U1 and U2, the banner (`payroll-entry-send-back-state.tsx`) still reads `correctionChanges`, so it shows no author or role until U2 merges. That is a missing feature, not a break.
- **Window between U3 and U4:** if U3 merges alone, a PM can send an entry back and still Fix-entry it (the Stage 1 behaviour; U4 closes it). Ship U3 and U4 together or U4 first if that matters.
- **First unit to ship: U1.** It tests the riskiest assumption in the plan: the new tenant-scoped table with a hand-written CHECK, the client-`role` validation, and the append-inside-the-correction-transaction, all against a real screen. If the log shape (D1(ii), D7) or the dual-write interplay with the approval hold (Q19) is wrong, it shows here, before any permission change is exposed to a second role.
