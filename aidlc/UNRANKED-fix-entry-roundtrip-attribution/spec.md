# Spec — UNRANKED-fix-entry-roundtrip-attribution: PM/PA round-trip on Fix entry, every change attributed

> Written by the elaborator. No Jira ticket and no `intent.md` exist: the intent is a
> developer's inline direction (Ali Riaz, Claude Code session, 2026-10-13). Folder name
> `UNRANKED-…` was given by the caller; `GUIDE.md` §10 only defines `SCRUM-###/`, so this is a
> convention deviation, flagged for the developer. Rename when a ticket id exists.
> Every requirement carries sources and status. A requirement with no source is `[OPEN]`.

## Source tagging used here

Sources for the *want*: (1) the inline direction, cited as `inline-direction`, (2) the
developer's answers to Q1-Q11 of the first draft, cited as `dev-answer-2026-10-13` (kind: other),
and (3) the developer's final answers to Q12-Q17 the same day, cited as `dev-final-2026-10-13`
(kind: other, same named human, same Q9 caveat).
Both are one named human (Ali Riaz); (2) is tagged `[VERIFIED]` below because a named human
adjudicated each point, **but it is not yet in `vault/decisions/`** (Q9 - the durable record is
still to be written by `tcg-scrum`), so it is weaker than a `decisions/` note. Where the first
draft's text follows, it is kept as history. It is a developer direction, not a TCG product decision — the same category as
`decisions/2026-10-06-returned-entries-correction-flow-and-send-back.md`, which says of itself
"This is a developer direction, not a client-side product decision". Nothing in the vault
specifies a PM-to-PA hand-off or round-trip.

Direction, verbatim: "this will open fix entry popup and in that popup he will be able to adjust
the all entries and all changes will be visible in popup — if payroll manager send entry back to
payroll admin he adjust the entries and send them to payroll payroll manager payroll manager will
also be able to do some changes and in changes section it will show append the payroll manager
changes in changes section with payroll admin one just in that case just add indicator who make
what changes"

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | none (`UNRANKED-fix-entry-roundtrip-attribution`) |
| Intent | none captured; inline direction 2026-10-13, quoted above |
| Elaborated on | 2026-10-13; revised twice 2026-10-13 (first, then final developer answers) |
| Vault state at elaboration | not counted; six `domain/` files verified; `payroll/gaps.md` 109 `Status: open` lines (grep) |
| Open questions raised by this spec | 17 in §12: Q1-Q8, Q10-Q17 resolved; **Q9 is the only one open** (bookkeeping, blocks nothing) |
| Already-shipped behaviour reached | 13 consumers in §11a; every row now has a source or a §11b developer decision (row 2 and the legacy-history read are D1) |
| Rules consulted | `.ai/claude/contexts/api.md`, `prisma.md`, `web.md`, `patterns.md` (named, not re-read in full; see §11b) |

**Scope boundary vs Stage 1 (already shipped, not re-specified).** `canFixEntry = useCan('payroll','edit')` plumbing; Fix entry
button for `canAdminister || canFixEntry`; click routing (sendBack exists then Correction Dialog
in `fix-entry` mode, else `/payroll/[employeeId]/entries/[ticketId]`); `readOnly` relaxed in
`fix-entry` mode; `/payroll-corrections/:id`, `/preview`, `PATCH` and the four entry-fix endpoints
at `payroll:edit`. Confirmed present in code (`payroll-corrections.controller.ts:54-66`,
`payroll-entry-fixes.controller.ts:28-80`). **Not in scope here:** all of that. In scope: only the
PM-to-PA-and-back hand-off, multi-round, and per-change authorship (both `PayrollSendBack` and `PayrollEntryFix` paths).

**Premise the spec could not source.** Stage 1's code comments cite "decision 2026-10-13" (PM edits
from Weekly Payroll, PA from Returned Entries). `ls .ai/vault/decisions | grep 2026-10-1` shows no
2026-10-13 note. The Stage 1 gate change therefore rests on an unrecorded decision (Q9).

## 1. Requirements ledger

Tag `[VERIFIED*]` = `[VERIFIED]` on the strength of a named human's answer (Ali Riaz; `dev-answer-2026-10-13`
and `dev-final-2026-10-13`), decision note pending (Q9). Still `[UNVERIFIED]` in the vault sense:
nothing under `.ai/vault/` states any of it.

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Popup Changes list is one unified timeline per entry (employee x ticket x period), across every round, both paths, all authors, oldest first | web, api, schema | `[VERIFIED*]` | dev-answer Q6a; dev-final Q14 | no (D1 structure) |
| REQ-02 | Each change shows author full name + role (snapshotted at write time) and date/time | web, api | `[VERIFIED*]` | dev-answer Q10a; dev-final Q16 | no |
| REQ-03 | Round-trip uses existing `PayrollSendBackStatus`; no new states | schema, api | `[VERIFIED*]` | dev-answer Q1; dev-final Q15 | no |
| REQ-04 | PM routes an entry to PA via the existing "Send Back To Payroll Admin" button; send-back + preview gated `payroll:edit` | web, api | `[VERIFIED*]` | dev-answer Q2, Q3; dev-final Q12 | no |
| REQ-05 | PM is locked out while status is `SENT_BACK`, `RESPONDED` or `RESUBMITTED`; enforced server-side | web, api | `[VERIFIED*]` | dev-answer Q4a, Q4b; dev-final Q13, Q16 | no |
| REQ-06 | `CORRECTED` is not final; the cycle repeats indefinitely | api, web | `[VERIFIED*]` | dev-answer Q5 | no |
| REQ-07 | PA never initiates; PM has two options (Fix entry / Send Back) | web, api | `[VERIFIED*]` | dev-answer Q7, Q8 | no |
| REQ-08 | Fix entry button visibility rule | web | `[VERIFIED*]` | dev-answer Q4b + clarification; dev-final Q13 | no |
| REQ-09 | PM may withdraw a send-back at any time; withdraw gated `payroll:edit`; Close stays PA-only | web, api | `[VERIFIED*]` | dev-answer Q4; dev-final Q12 | no |
| REQ-10 | PM may re-edit after `CORRECTED` (service must accept it) | api, web | `[VERIFIED*]` | dev-answer Q5; dev-final Q17 | no |
| REQ-11 | Change log is append-only; repeat edits to one field are separate rows; rows keyed on the entry triple | api, schema | `[VERIFIED*]` | dev-answer Q6a, Q6b; dev-final Q14 | no (D1 structure) |
| REQ-12 | Rows with no stored author render a grey "Legacy" chip | web | `[VERIFIED*]` | dev-answer Q10b | no |
| REQ-13 | `EntryFixView` (`PayrollEntryFix`) gets author attribution and shows the same unified timeline; no round-trip | web, api | `[VERIFIED*]` | dev-answer Q11; dev-final Q14 | no |
| REQ-14 | Server resolves the author's role label at write time and snapshots it on every change row | api | `[VERIFIED*]` | dev-final Q16 | no |

Counts: 14 total - 14 sourced to a developer answer (`[VERIFIED*]`), 0 conflicted, 0 `[OPEN]`, **0 carrying an
open product sub-point**. What remains is not product: §11b developer decisions (D1, D1b, D3, D5, D6, D7)
and Q9 (bookkeeping).

## 2. Requirements

### REQ-01 - Changes list is one unified timeline per entry `[VERIFIED*]`

- **Statement:** The Changes list of an entry shows, oldest first, every change made to that entry (employee x job ticket x payroll period): every change from every historical `PayrollSendBack` on it across every round, and every change from every `PayrollEntryFix` on it, by every author. Nothing from an earlier round or the other path is dropped when a later one is written. The list is the same whether PM or PA opens it, and whether it is opened from the Correction Dialog or `EntryFixView` (REQ-13). Each row carries author, role and timestamp (REQ-02).
- **Surface:** web, api, schema
- **Sources:**
  - `dev-final-2026-10-13` Q14 - `[VERIFIED*]` - "YES, unified timeline across both correction and direct-fix paths. Key the log on entry (employeeId x ticketId x periodId), not on sendBackId", every round, both sources, oldest-first, author + role + timestamp on every row.
  - `dev-answer-2026-10-13` Q6a - `[VERIFIED*]` - "Cumulative. Every change from every round visible in the popup's Changes list, oldest first."
  - `inline-direction` - "append the payroll manager changes in changes section with payroll admin one".
  - `apps/api/src/service/payroll-send-backs/payroll-send-backs.repository.ts:884-889` - kind: code - current behaviour only: `correctionChanges: params.changes` is a whole-column write (what this requirement replaces).
- **Conflict:** none
- **Open question:** none. Storage shape and the read of pre-feature history are developer decisions: D1, D1b.
- **Ripple:** see §11a rows 1-4.
- **Acceptance:** After a PM direct-fix (`PayrollEntryFix`) changes Start Work 7:00 -> 7:30, the PM sends the entry back, PA changes 7:30 -> 7:45, and a second round follows, the Changes list on that entry lists every one of those rows, oldest first, each with author, role and timestamp, from either screen.
- **Notes for the executor:** A new send-back is a new `PayrollSendBack` row (per roster member, `returnGroupId`-shared; `payroll-send-backs.service.ts` header, REQ-25). "Cumulative" is therefore keyed on the entry triple, never on `sendBackId` (Q14). Reads join on the triple. Each stored row also references its source (a send-back or an entry-fix) as a discriminated reference (D1).

### REQ-02 - Each change shows who made it `[VERIFIED*]`

- **Statement:** Every change row shows its author as full name plus role, e.g. "Jordan Blake (Payroll Admin)" / "Jordan Blake (Payroll Manager)", and the date/time of the change. One row per change; the author is shown on each row, not only when two authors contributed. The role shown is the one stored on the row at write time (REQ-14), not one recomputed from the author's current permissions.
- **Surface:** web, api
- **Sources:** `dev-answer-2026-10-13` Q10a - `[VERIFIED*]`; `dev-final-2026-10-13` Q16 - `[VERIFIED*]` (snapshot at write time). Supersedes the inline direction's ambiguous "just in that case".
- **Conflict:** none
- **Open question:** none.
- **Ripple:** `correction-dialog-sidebar.tsx:179`, `payroll-entry-send-back-state.tsx:115,155` read the row shape; they gain author + role + time. Source: this requirement.
- **Acceptance:** each rendered change row contains the author's name, role in brackets, and a timestamp; after the author's permissions are later changed, old rows still show the role they were written with. Exact visual: `NOT SPECIFIED` beyond that; the format string above is the developer's.
- **Notes for the executor:** `fixedByUserId` / `correctedByUserId` are row-level today, not per change.

### REQ-03 - Round-trip uses the existing statuses `[VERIFIED*]`

- **Statement:** No new `PayrollSendBackStatus` member. Flow: PM clicks Send Back To Payroll Admin -> `SENT_BACK` (PA holds it, PM locked). PA edits and submits -> `CORRECTED` (back with PM). PM may then re-edit (Fix entry) or send back again (a new send-back row begins a new round). "Closing" a send-back means transitioning it to `CORRECTED`; there is no `CLOSED` enum member.
- **Surface:** api (schema enum unchanged)
- **Sources:** `dev-answer-2026-10-13` Q1 - `[VERIFIED*]`; `dev-final-2026-10-13` Q15 - settled: `CLOSED` is not an enum member.
  - Checked against code (kind: code, current behaviour): `submitCorrection` moves `SENT_BACK`/`RESUBMITTED` -> `CORRECTED` directly (`payroll-send-backs.repository.ts:884`; guard at `payroll-send-backs.service.ts:874-876`). So PA's submit already lands on `CORRECTED`.
  - Enum as it stands (`schema.prisma:5415`): `SENT_BACK, CORRECTED, WITHDRAWN, RESPONDED, RESUBMITTED`. `RESPONDED` = the crew member replied; `RESUBMITTED` = the ticket's primary resubmitted to payroll (employee leg, `service:444`).
- **Conflict:** none
- **Open question:** none.
- **Ripple:** enum unchanged, so switch/badge/filter maps are unaffected.
- **Acceptance:** an end-to-end PM -> PA -> PM -> PA cycle leaves the enum unchanged and each loop appears as a new send-back row.
- **Notes for the executor:** the existing send-back is crew-wide (one row per roster member) and its `SENT_BACK` holds each member's week from approval. PM-originated send-backs inherit that; the Q12 answer lowers only who may press the controls and does not change the hold.

### REQ-04 - PM routes an entry to PA via the existing button `[VERIFIED*]`

- **Statement:** PM routes an entry to PA with the existing "Send Back To Payroll Admin" button on the Weekly Payroll expanded row (`payroll-employee-table.expanded.tsx:404-411`). PA finds it on the existing Returned Entries page (`/payroll/corrections`). No new button, no new page. The button is shown to any user with `payroll:edit`, not only `canAdminister` (`payroll-admin:edit`). The send-back and its preview endpoints are gated `payroll:edit`.
- **Surface:** web, api
- **Sources:** `dev-answer-2026-10-13` Q2, Q3 - `[VERIFIED*]`; `dev-final-2026-10-13` Q12 - `[VERIFIED*]` - "Yes to both ... API gates to lower: send back -> `payroll:edit`, preview -> `payroll:edit`."
  - Code (current only): button renders only when `canAdminister` = `useCan('payroll-admin','edit')` (`payroll-employee-timesheet.tsx:106,186`); preview `GET payroll/periods/:id/tickets/:ticketId/send-back` (`payroll-send-backs.controller.ts:42-43`) and send `POST` on the same path (`:55-56`) are `payroll-admin:edit`. Seed: `payroll-admin` is `'none'` for every role by default (`seed-data.ts:237`).
  - Route naming: the developer's answer wrote the routes as `POST /payroll/send-backs` and `POST /payroll/send-backs/:id/preview`. Neither exists; the intent (the existing send-back and its preview endpoints) is unambiguous, so this spec names the routes as they are in code. `POST payroll-corrections/:id/preview` (a different endpoint) is already `payroll:edit`.
- **Conflict:** none
- **Open question:** none.
- **Ripple:** gate change reaches every holder of `payroll:edit` on those two endpoints and the button; `payroll-employee-timesheet.tsx:106` `canActOnTickets`. Source: dev-final Q12 (deliberate).
- **Acceptance:** a user holding `payroll:edit` but not `payroll-admin:edit` sees the button, can open its preview and send; the entry goes `SENT_BACK` and appears on Returned Entries for PA.
- **Notes for the executor:** the dialog's "Who to notify" is a Payroll Admin picker (`payroll-send-back-dialog.tsx:238-247`); the picker's own endpoint `GET payroll/admins` is already `payroll:view`.

### REQ-05 - PM lock while PA holds the entry `[VERIFIED*]`

- **Statement:** While the entry's send-back status is `SENT_BACK`, `RESPONDED` or `RESUBMITTED`, PM cannot edit it. `RESPONDED` is treated exactly like `SENT_BACK`: PM is locked out and PA has it via Returned Entries, acting on the employee's reply. The Fix entry button is hidden entirely (not disabled) in all three. The Withdraw send-back button stays visible (REQ-09). The lock is enforced by the server as well as the UI.
- **Surface:** web, api
- **Sources:** `dev-answer-2026-10-13` Q4a, Q4b - `[VERIFIED*]`; `dev-final-2026-10-13` Q13 - `[VERIFIED*]` (`RESPONDED` = `SENT_BACK`); Q16 (role resolution, REQ-14).
  - Status names checked against `schema.prisma:5415`: the employee-reply status is `RESPONDED`; `RESUBMITTED` is the primary's resubmission and was already in the Q4 lock. The lock set is therefore all three.
- **Conflict:** none
- **Open question:** none.
- **Ripple:** Stage 1 made `fix-entry` mode editable regardless of status (`correction-dialog.tsx:160-167` relaxes `readOnly`); this requirement re-narrows it for PM. `PATCH payroll-corrections/:id` (`payroll:edit`) is the write path to guard. `correction-dialog-sections.tsx:193` editability by status.
- **Acceptance:** with a send-back in `SENT_BACK`, `RESPONDED` or `RESUBMITTED`, a user who has `payroll:edit` and not `payroll-admin:edit` sees no Fix entry button and a direct `PATCH` is refused; a user with `payroll-admin:edit` can still submit from Returned Entries.
- **Notes for the executor:** UI-only hiding is not a lock; the server check is required. "PM" for the lock means `payroll:edit` without `payroll-admin:edit`, by the same resolution as REQ-14 (a user holding both is PA). That the lock follows the label's rule is this spec's reading of Q16, not a separate quote. Whether PA may submit from `RESPONDED` itself (today `submitCorrection` accepts only `SENT_BACK`/`RESUBMITTED`) is unchanged by the answer ("via Returned Entries as today") and is listed in §13.

### REQ-06 - `CORRECTED` is not final `[VERIFIED*]`

- **Statement:** `CORRECTED` returns the entry to PM. PM can Fix entry again (direct edit) or Send Back To Payroll Admin again (new round). The cycle can repeat indefinitely. No round limit.
- **Sources:** `dev-answer-2026-10-13` Q5 - `[VERIFIED*]`.
- **Conflict:** none. **Open question:** none. **Ripple:** the "ticket already returned" 409 applies only to unresolved sends (`send-back-statuses.ts`), so a new send-back after `CORRECTED` is not blocked by it (not tested; executor to confirm).
- **Acceptance:** two consecutive rounds on one entry succeed.
- **Notes for the executor:** none.

### REQ-07 - PA never initiates `[VERIFIED*]`

- **Statement:** PA works only on entries returned to it. PA never creates a fresh correction. PM has two options on an entry: Fix entry (direct, immediate) or Send Back To Payroll Admin (hand to PA; PM locked until `CORRECTED`). This supplements Corrina's "either may adjust" (`decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md` cl. 2) with a routed option.
- **Sources:** `dev-answer-2026-10-13` Q7, Q8 - `[VERIFIED*]`.
- **Conflict:** the 10-06 decision's "to Payroll Admin" vs crew-wide schema is no longer a spec conflict: the developer designates the existing button and Returned Entries page. (Kept as note; no action.)
- **Open question:** none. **Ripple:** PA's fresh `PayrollEntryFix` path (`/payroll/[employeeId]/entries/[ticketId]`, `payroll-admin:edit`-gated today) is outside this requirement; whether PA keeps it is not addressed by any answer; left unchanged and listed in §13.
- **Acceptance:** no PA-side control creates a PM-bound round.

### REQ-08 - Fix entry button visibility `[VERIFIED*]`

- **Statement:** Show Fix entry when `user has payroll:edit OR payroll-admin:edit` AND (`no send-back exists` OR `send-back status is CORRECTED or WITHDRAWN`). Hide when status is `SENT_BACK`, `RESPONDED` or `RESUBMITTED`. (The developer wrote "CORRECTED/CLOSED/WITHDRAWN"; `CLOSED` is not an enum member and means `CORRECTED` - REQ-03.)
- **Sources:** `dev-answer-2026-10-13` Q4b and clarification - `[VERIFIED*]`; `dev-final-2026-10-13` Q13 - `[VERIFIED*]`. Current gate: `canAdminister || canFixEntry` (`payroll-employee-table.expanded.tsx:375`).
- **Open question:** none.
- **Ripple:** `payroll-employee-table.expanded.tsx`, `payroll-employee-table.tsx`, `payroll-employee-timesheet.tsx`.
- **Acceptance:** the table of (permission x status) -> visible/hidden above, tested for each of `SENT_BACK`, `RESPONDED`, `RESUBMITTED` (hidden) and `CORRECTED`, `WITHDRAWN`, none (shown).

### REQ-09 - PM may withdraw at any time `[VERIFIED*]`

- **Statement:** PM can withdraw a send-back at any time to reclaim the entry, with the existing Withdraw send-back button, visible to any user with `payroll:edit`, not only `canAdminister`. `POST payroll/send-backs/:id/withdraw` is gated `payroll:edit`. **Close send-back stays PA-only:** `POST payroll/send-backs/:id/close` remains `payroll-admin:edit`, and its button remains `canAdminister`.
- **Sources:** `dev-answer-2026-10-13` Q4 - `[VERIFIED*]`; `dev-final-2026-10-13` Q12 - `[VERIFIED*]`.
  - Code (current only): button shows when `canResolve = canAdminister && onResolve && isUnresolved` (`payroll-entry-send-back-state.tsx:283`); `POST send-backs/:id/withdraw` is `payroll-admin:edit` (`payroll-send-backs.controller.ts:82`); close is `:71`. Withdraw needs both the web and the API change; the web change alone yields a 403. `canResolve` currently gates close and withdraw together, so the two buttons need separate conditions.
- **Open question:** none.
- **Ripple:** withdraw releases every crew member's week hold (REQ-25) - PM gets that power (deliberate, dev-final Q12). `payroll-entry-send-back-state.tsx:283` `canResolve` splits in two.
- **Acceptance:** a PM-only user sees Withdraw while `SENT_BACK`/`RESPONDED`/`RESUBMITTED`; the call succeeds; status -> `WITHDRAWN`; Fix entry reappears. The same user sees no Close button and a direct call to close is refused.
- **Notes for the executor:** a PA mid-edit then gets a 409 on submit with the message "already corrected" (`service:878`), which is wrong for a withdrawn entry - UX copy is `NOT SPECIFIED`.

### REQ-10 - PM may re-edit after `CORRECTED` `[VERIFIED*]`

- **Statement:** After `CORRECTED`, PM's Fix entry opens the Correction Dialog and a submit succeeds. The case of two PMs re-editing after `CORRECTED` is accepted as a tolerable edge: the change log honestly records whichever PM wrote last, and no stale-write rejection is required.
- **Sources:** `dev-answer-2026-10-13` Q5 - `[VERIFIED*]`; `dev-final-2026-10-13` Q17 - accepted. Code (current only): `submitCorrection` throws 409 "already corrected" unless status is `SENT_BACK`/`RESUBMITTED` (`service:874-879`), so today this path fails server-side. The rule change is therefore required.
- **Open question:** none.
- **Ripple:** the 409 guard is also what stops double-submits by two users today (see §11 Concurrency).
- **Acceptance:** PM submits twice on one entry after one PA correction; both appear in the log.

### REQ-11 - Append-only change log, keyed on the entry `[VERIFIED*]`

- **Statement:** Changes are stored append-only, one row per change, never edited or collapsed. Setting a field twice by two people yields two rows, in order. Each row is keyed on the entry triple (`employeeId`, `ticketId`, `periodId`, plus `tenantCompanyId`) and references its source - a `PayrollSendBack` or a `PayrollEntryFix` - as a nullable discriminated reference. Each row carries `round`, `authorId`, `authorName`, `authorRole` (REQ-14), `changedAt`, `field`, `label`, `before`, `after`. Reads for an entry select on the triple, never on `sendBackId`.
- **Sources:** `dev-answer-2026-10-13` Q6a, Q6b - `[VERIFIED*]`; `dev-final-2026-10-13` Q14 - `[VERIFIED*]` (the row shape above is the developer's, as written in the answer). Final names, types, nullability, constraints and the exact form of the discriminator are the developer's: D1.
- **Open question:** none. What `round` means on a `PayrollEntryFix`-sourced row is `NOT SPECIFIED` (D1).
- **Ripple:** §11a rows 1-2.
- **Acceptance:** repeated same-field edits show as separate ordered rows; a direct fix and a later send-back round on the same entry both appear when the log is read by the triple.

### REQ-12 - Legacy chip `[VERIFIED*]`

- **Statement:** A change row with no stored author renders a grey "Legacy" chip in the author slot.
- **Sources:** `dev-answer-2026-10-13` Q10b - `[VERIFIED*]`.
- **Open question:** none. **Acceptance:** an existing `correctionChanges` row renders the chip; no backfill is required.
- **Notes for the executor:** this means no data backfill of authorship (§3). Whether pre-feature history is surfaced in the unified timeline by a read-time union or otherwise is D1b.

### REQ-13 - `EntryFixView` attribution and unified timeline `[VERIFIED*]`

- **Statement:** The `EntryFixView` page (`PayrollEntryFix`) shows author (name + role) and time on its change rows, and shows the same unified timeline as REQ-01, including send-back changes. No round-trip applies there: Fix entry on a never-returned entry is a one-shot direct fix.
- **Sources:** `dev-answer-2026-10-13` Q11 - `[VERIFIED*]`; `dev-final-2026-10-13` Q14 - `[VERIFIED*]` (both directions: send-back history appears wherever the entry's Changes list is opened). Code (current only): `entry-fix-view.tsx:91` already renders `fix.fixedBy?.name` and `fixedAt` per fix group; role is not shown.
- **Open question:** none. **Ripple:** `entry-fix-plan.ts:116` and the entry-fix write endpoints now also append log rows (REQ-11, REQ-14); `PayrollEntryFix.changes` is not removed by this spec (D1b).
- **Acceptance:** role shown beside the existing name; fixes from before this feature render correctly (they always have `fixedByUserId`, `Restrict` FK - so the Legacy chip is not needed on this path).

### REQ-14 - Server-side role resolution, snapshotted per row `[VERIFIED*]`

- **Statement:** When the server writes a change row (every submit on the send-back path and every entry-fix on the direct path), it resolves the author's role label from the author's effective permissions at that moment and persists the label on each row. Resolution: has `payroll-admin:edit` -> `"Payroll Admin"`; else has `payroll:edit` -> `"Payroll Manager"`; else (should not occur, the gate blocks it) -> the author's primary department role name. The client never supplies the label. History is not recomputed when permissions later change.
- **Surface:** api
- **Sources:** `dev-final-2026-10-13` Q16 - `[VERIFIED*]` - "Snapshot the user's role string at write time ... The write path (POST/PATCH endpoints) must do this role resolution and persist the label on each change row."
- **Conflict:** none
- **Open question:** none. Where "primary department role name" is read from (`User`/`Role` models) is a code lookup for the executor; if it is ambiguous there, that is a D7 row, not a product question.
- **Ripple:** none beyond REQ-02, 05, 11, 13 (the same resolution defines "PM" for the REQ-05 lock). Existing rows have no label (REQ-12).
- **Acceptance:** a user with both permissions writing a change is stored as "Payroll Admin"; with only `payroll:edit`, "Payroll Manager"; changing that user's permissions afterwards leaves earlier rows unchanged.
- **Notes for the executor:** the 3rd branch is the developer's wording; no other fallback text is specified.

## 3. Data model - `apps/api/prisma/schema.prisma`

- **Schema change required:** yes - REQ-11 needs one append-only per-change table keyed on the entry triple, with a discriminated reference to the source (`PayrollSendBack` or `PayrollEntryFix`), author, snapshotted role, round and time (exact shape = D1). This touches the `PayrollEntryFix` write path as well as `PayrollSendBack` (REQ-13, REQ-14). `PayrollSendBackStatus` enum unchanged (REQ-03).
- **Migration required:** yes (committed migration, `prisma.md`).
- **Data backfill required:** no for authorship (REQ-12 Legacy chip). Whether pre-feature `correctionChanges` / `PayrollEntryFix.changes` JSON is shown in the unified timeline by read-time union or by a backfill is D1b; Q14's "every historical" is the want, the mechanism is the developer's.
- **Existing models considered:**
  - `PayrollSendBack` (`schema.prisma:5434`): one author per correction (`correctedByUserId`); `correctionChanges` Json whole-column write; also carries the final submitted-times snapshot.
  - `PayrollEntryFix` (`schema.prisma:~5491`): `changes` Json + `fixedByUserId` (required, `Restrict`); one row per fix = history already append-only.
  - `PayrollFlagEvent` - possible precedent for an event-row shape; not read in full.
- **Fields whose type/precision no source states:** author-role storage, round number, timestamp source - `NOT SPECIFIED` (D1, D7).

## 4. API surface - `apps/api`

- **Pattern:** `NOT SPECIFIED` - D5.
- **Existing functions/services to reuse:** `PayrollSendBacksService.submitCorrection` (`usecase/payroll-send-backs/payroll-send-backs.service.ts:~865`), `withdrawGroup` (:360), `resolveGroup` (:~353), `previewSendBack`/`sendBack` (controller :43,:56); repository CORRECTED write (`payroll-send-backs.repository.ts:884`); `entry-fix-plan.ts:116`; `PayrollSendBacksController` (`payroll-send-backs.controller.ts`), `PayrollCorrectionsController`.
- **Required behaviour changes (sourced above):** append change rows on every send-back submit and every entry-fix (REQ-11, REQ-13); resolve and persist the role label server-side on each row (REQ-14); `submitCorrection` accepts `CORRECTED` for PM re-edit (REQ-10); refuse PM-only (`payroll:edit` without `payroll-admin:edit`) submits while `SENT_BACK`/`RESPONDED`/`RESUBMITTED` (REQ-05); lower to `payroll:edit` the gates on send-back preview (`GET payroll/periods/:id/tickets/:ticketId/send-back`), send-back (`POST` same path) and `POST payroll/send-backs/:id/withdraw`; `POST payroll/send-backs/:id/close` stays `payroll-admin:edit` (REQ-04, REQ-09); return the entry's unified timeline, each row with author + role + time (REQ-01, REQ-02).
- **New exported functions/services, endpoints, DTOs:** `NOT SPECIFIED` - developer's (D1-D4).

## 5. Web surface - `apps/web`

- **Existing components considered:** `correction-dialog.tsx` (:160-167 editability), `correction-dialog-sidebar.tsx:179` (Changes list), `payroll-entry-send-back-state.tsx:115,155,283` (banner changes, `canResolve`), `payroll-employee-table.expanded.tsx:375-411` (Fix entry / Send Back buttons), `payroll-employee-table.tsx`, `payroll-employee-timesheet.tsx:106,186`, `entry-fix-view.tsx:91`, `returned-entries-list.tsx`, `payroll-send-back-dialog.tsx`. Run `find-component` for the chip (an existing `Badge`/chip likely exists; do not create).
- **New components proposed:** none. "Legacy" chip: grey, text "Legacy". Other visuals `NOT SPECIFIED`.
- **Copy:** author format "Name (Role)" and chip text "Legacy" only; all other copy `NOT SPECIFIED`.

## 6. Mobile surface - `apps/mobile`

`N/A` - established by `git grep -ln 'correctionChanges' -- apps/mobile packages/shared`, no hits. The employee leg (`RESPONDED`/`RESUBMITTED`) already reaches mobile; this spec does not alter it.

## 7. Shared package - `packages/shared`

`N/A` - same grep, no hits. Web declares its own change type in `features/payroll/services/payroll-send-backs.service.ts`; API in `payroll-send-backs.service.ts:~1207`.

## 8. Permissions and tenancy

- **Roles:** PM = `payroll:edit` (seed role `ROLE-ACCOUNTS-PM`, `seed-data.ts:303`); PA = `payroll-admin:edit` (`'none'` by default for every role, `seed-data.ts:237`); a user with both is PA (REQ-14). Gates: send-back, preview, withdraw -> `payroll:edit`; close stays `payroll-admin:edit` (Q12 answered). The `send-to-employee` route stays `payroll-admin:edit` (no answer changes it).
- **Tenant isolation:** standard; the new change-log record is a tenant entity (`prisma.md`; `tcg-prisma-guardian` required).

## 9. Validation rules

No new rule is sourced. Existing: a correction note is required (`service:~881`). Round limit: none (REQ-06). Anything else `NOT SPECIFIED`.

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| API unit | `submitCorrection` appends rows, never overwrites; accepts `CORRECTED` for PM; refuses PM-only while `SENT_BACK`/`RESPONDED`/`RESUBMITTED` | REQ-05, 10, 11 |
| API unit | send-back, preview and withdraw succeed for `payroll:edit`; close is refused for `payroll:edit`-only | REQ-04, 09 |
| API unit | role label resolved server-side (both permissions -> PA; `payroll:edit` only -> PM; fallback -> department role name) and unchanged after a permission change | REQ-02, 14 |
| API unit | the read by entry triple returns rows from several send-backs and entry-fixes, oldest first | REQ-01, 11, 13 |
| Web | button visibility table (permission x status, incl. `RESPONDED`); Withdraw visible to `payroll:edit`, Close not | REQ-08, 09 |
| Web | author "Name (Role)", time, Legacy chip, oldest-first order | REQ-01, 02, 12, 13 |
| Manual | PM -> PA -> PM -> PA cycle, two edits to one field | REQ-03, 06, 11 |

## 11. Non-functional

- **Concurrency:** (a) change rows - append-only removes the whole-column overwrite at `repository.ts:884` for the log itself. (b) The `PayrollSendBack` submitted-times snapshot (and the `ticketEmployee` times written in the same transaction, repository :860-880) is still last-writer-wins. **Accepted** as a trade-off given the lock in REQ-05, for the PM<->PA hand-off. **Residual risk, not covered by the lock:** two PMs (or PM + PA with a lock hole) re-editing after `CORRECTED` (REQ-10, no lock exists then) compute each change's `before` from the state they loaded; the log can then record contradictory rows (A: 7:00->7:30, B: 7:00->7:45) while the snapshot keeps only B. **Accepted by the developer** (dev-final Q17): the change log honestly records whichever PM wrote last; no stale-write rejection required (D6). Withdraw mid-edit: PA's submit gets 409 (REQ-09 notes).
- **Audit:** the append-only log with author + time is the audit trail; retention `NOT SPECIFIED`.
- **Notifications:** how PA learns of a PM send-back: existing `notifyTicketReturned` notifies the picked Payroll Admins; nothing else is specified or changed.

## 11a. Ripple - already-shipped behaviour these requirements reach

Enumerated with: `git grep -n 'correctionChanges\|PayrollSendBackStatus' -- apps packages`, `git grep -n "Fix entry" -- apps/web/src`, `git grep -n "payroll-admin', 'edit'" -- apps/api/src/presentation/payroll-send-backs`, controller reads (run 2026-10-13).

| # | Existing consumer | Reached via | Req | What happens | Source |
| --- | --- | --- | --- | --- | --- |
| 1 | `repository.ts:884` correction write | overwrite -> append | 01, 11 | changed deliberately | dev-answer Q6a |
| 2 | `repository.ts:623-643` (query `correctionChanges not null`) | the column | 01 | unchanged unless D1 moves the data - D1/D1b must preserve this query's meaning | **D1 (developer; no product question)** |
| 3 | `correction-dialog-sidebar.tsx:179`, `payroll-entry-send-back-state.tsx:115,155` | row shape | 01, 02, 12 | changed: unified timeline; author + role + time + Legacy chip | dev-answer Q10; dev-final Q14, Q16 |
| 4 | `PayrollEntryFix.changes` / `entry-fix-plan.ts:116` / `entry-fix-view.tsx:91` + entry-fix write endpoints (`payroll-entry-fixes.controller.ts`) | separate model | 11, 13, 14 | role added; entry-fix writes also append log rows; view shows send-back history too; `changes` JSON kept or retired = D1b | dev-final Q14, Q16 |
| 5 | `PayrollSendBackStatus` switch/badge/label maps, reminder cron, `returned-entries-list.tsx`, approval-hold rule | enum | 03 | unchanged (no new members) | dev-answer Q1 |
| 6 | `payroll-employee-table.expanded.tsx:375` Fix entry gate | visibility rule | 08 | changed to REQ-08 table | dev-answer |
| 7 | `payroll-employee-table.expanded.tsx:404-411` Send Back button + `payroll-employee-timesheet.tsx:106` `canActOnTickets` | `payroll-admin:edit` gate | 04 | changed: visible to `payroll:edit` | dev-final Q12 |
| 8 | `payroll-send-backs.controller.ts:43,56` preview + POST send-back | `payroll-admin:edit` | 04 | changed: `payroll:edit` | dev-final Q12 |
| 9 | `payroll-send-backs.controller.ts:71,82` close + withdraw | `payroll-admin:edit` | 09 | withdraw: `payroll:edit`; close: unchanged, `payroll-admin:edit` | dev-final Q12 |
| 10 | `payroll-entry-send-back-state.tsx:283` `canResolve` | `canAdminister` | 09 | split: withdraw visible to `payroll:edit`; close stays `canAdminister` | dev-final Q12 |
| 11 | `service.ts:874-879` submit status guard | `SENT_BACK`/`RESUBMITTED` only | 05, 10 | changed: also `CORRECTED` for PM; PM-only refused while `SENT_BACK`/`RESPONDED`/`RESUBMITTED` | dev-answer Q4a, Q5; dev-final Q13 |
| 12 | `correction-dialog.tsx:160-167`, `correction-dialog-sections.tsx:193` | editability by status | 05, 08 | `RESPONDED` treated like `SENT_BACK` for PM; PA unchanged | dev-final Q13 |
| 13 | `payroll-flags-panel.tsx:79` "Fix entry" link, `POST :id/send-to-employee` | separate flows | 13 | unchanged (no answer changes them) | dev-answer Q11 (scope) |

- **No existing behaviour in this area:** mobile, `packages/shared`.
- **Consumers with no source:** none. Row 2 is a developer structural decision (D1/D1b), not a product gap.

## 11b. Developer decisions - structure is the developer's call

*AI fills Decision and Options. Chosen / Decided by left blank on purpose.*

| ID | Decision | Options (with existing code found) | AI note | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Change-log schema: Q14 fixes the model - one append-only table keyed on the entry triple, a row per change, referencing its source | **(a)** new table (e.g. `payroll_correction_change_log`): `tenantCompanyId`, `periodId`, `employeeId`, `ticketId` (entry triple), `round`, `authorId`, `authorName`, `authorRole`, `changedAt`, `field`, `label`, `before`, `after`, plus a source reference that is `sendBackId` XOR `entryFixId`. Remaining structural choices: (i) the discriminator form - two nullable FKs with a CHECK that exactly one is set, vs a `sourceType` + `sourceId` pair (the pair cannot be an FK); (ii) `round` on entry-fix rows - null vs a counter; (iii) index `(tenantCompanyId, periodId, employeeId, ticketId, changedAt)` for the read; (iv) `employeeId`/`ticketId` as UUID FKs per the identity convention, not codes. UUID PK, `@db.Timestamptz`, tenant-scoped. Precedents: `PayrollFlagEvent`, `PayrollEntryFix`. Former option (b) (extend the JSON in `PayrollSendBack.correctionChanges`) is withdrawn: it cannot key on the entry across send-back rows or span `PayrollEntryFix`. | Q14 leaves one option. The developer's answer states the shape; this row stays open until a developer fills *Chosen*/*Decided by* (the elaborator never does). Recommendation on (i): two nullable FKs + CHECK keeps referential integrity; trade-off is two columns. Needs `tcg-prisma-guardian`. | | | |
| D1b | Pre-feature history in the unified timeline (Q14 says "every change from every historical" send-back and entry-fix; REQ-12 says no authorship backfill) | **(a)** read-time union of legacy `PayrollSendBack.correctionChanges` and `PayrollEntryFix.changes` JSON with the new table, legacy rows shown with the Legacy chip (send-back rows) or `fixedBy` (entry-fix rows); **(b)** one-off backfill into the new table (conflicts with "no backfill" in REQ-12 unless the developer lifts it); **(c)** new table only, pre-feature history stays visible only where it is today. Also: do the entry-fix and send-back writes keep writing their JSON columns alongside the log rows (dual-write) or stop? | (a) honours Q14 and REQ-12 without a data migration but needs a union reader and a stable ordering across the two JSON shapes; `repository.ts:623-643` reads the column and must keep its meaning. (c) contradicts Q14 for old entries. | | | |
| D2 | `PayrollSendBackStatus`: confirmed reuse (REQ-03) | enum `schema.prisma:5415` | closed by Q1; no row needed except confirming | | | |
| D3 | How the gate change and the server lock are built: lower the gate on the existing routes (send-back preview + POST, withdraw) vs duplicate routes; where the PM-only lock check sits (in `submitCorrection` vs a guard) | `payroll-send-backs.controller.ts:43,56,82`, `payroll-corrections.controller.ts:63-66`, `service.ts:874-879` | the product side is settled (dev-final Q12/Q13/Q16): `payroll:edit` on send-back, preview, withdraw; close stays `payroll-admin:edit`. Lowering on existing routes avoids new endpoints and changes who may use them for all roles | | | |
| D4 | PA queue: reuse `listReturned` (`service:~723`, status-only) as-is | `returned-entries-list.tsx` | developer chose the existing page (Q3); the decision is only whether a filter is needed | | | |
| D5 | Pattern reference in `patterns.md` for send-back / event log | `.ai/claude/contexts/patterns.md` | check for `UNDECIDED` | | | |
| D6 | Stale-`before` mitigation for post-`CORRECTED` concurrent edits (REQ-10): none vs reject-if-changed-since-load | `service.ts` submit | Developer accepted the edge case (dev-final Q17): "the change log honestly records whichever PM wrote last". Recommended choice is therefore *none*; a developer still records it in *Chosen* | | | |
| D7 | Role on a change row | `User`, `Role` | decided as product behaviour: snapshot at write time (dev-final Q16, REQ-14). Left for a developer: the column type (free string vs reference), and where the fallback "primary department role name" is read from | | | |

## 11c. Siblings - same pattern, same change?

| Sibling | Pattern | Same change? | Decided by | Enumerated by |
| --- | --- | --- | --- | --- |
| `PayrollEntryFix` change rows (`entry-fix-view.tsx`) | change list | **yes for attribution** (REQ-13, per Q11); round-trip: no (Q11) | Ali Riaz (dev-answer Q11) - confirm in sign-off | `git grep -n 'entry-fixes' -- apps` |
| Flags panel "Fix entry" link (`payroll-flags-panel.tsx:79`) | Fix entry entry point | not stated - does it follow REQ-08's visibility rule? (it opens `EntryFixView`, which has no send-back state) | | `git grep -n "Fix entry" -- apps/web/src` |
| Employee-leg `send-to-employee` (`payroll-corrections.controller.ts:74-75`, `payroll-admin:edit`) | send-back flow | no change specified; stays `payroll-admin:edit` | | controller read |
| Sibling endpoints of the lowered gates, same controller: `GET payroll/admins` (`payroll:view`), `POST send-backs/:id/close` (`payroll-admin:edit`) | send-back controller | admins: no change. **close: deliberately stays PA-only** (dev-final Q12) - confirm it is not meant to follow | | `grep -n RequirePermission apps/api/src/presentation/payroll-send-backs/payroll-send-backs.controller.ts` |
| Write paths that must now append log rows and resolve the role: `PATCH payroll-corrections/:id`, `POST` and `PATCH` on the entry-fix route (`payroll-entry-fixes.controller.ts:39,59`; the `/preview` and the two `GET`s do not write) | change-log writers | yes (REQ-11, 13, 14) | | `grep -n '@Post\|@Patch\|@Put\|@Delete' apps/api/src/presentation/payroll-entry-fixes/payroll-entry-fixes.controller.ts` |
| Returned Entries list / banner (`returned-entries-list.tsx`, `payroll-entry-send-back-state.tsx`) | change-list render sites | gets the author row (REQ-02) | | `git grep -n correctionChanges -- apps/web` |

## 12. Open questions - the stop-and-ask list

Resolved items keep the question for the record. Source for every resolution: `dev-answer-2026-10-13`
(Ali Riaz, Claude Code session). Per CLAUDE.md only `tcg-scrum` flips a **Status:** in the same pass as a
decision note, so resolved questions are marked **Status:** answered (decision note pending, Q9), not "closed".

### Q1 - State machine
- **Answer:** Reuse existing statuses. PM Send Back -> `SENT_BACK`; PA submit -> `CORRECTED`; PM re-edit or re-send (new send-back); no new states. Folded into REQ-03.
- **Status:** answered (RESOLVED 2026-10-13)

### Q2 - How PM routes to PA
- **Answer:** the existing "Send Back To Payroll Admin" button on the Weekly Payroll expanded row. Folded into REQ-04. Follow-on gate problem: Q12.
- **Status:** answered (RESOLVED 2026-10-13)

### Q3 - How PA sees PM-routed entries
- **Answer:** existing Returned Entries page (`/payroll/corrections`). REQ-04.
- **Status:** answered (RESOLVED 2026-10-13)

### Q4 - Editability in the other role's queue
- **Answer:** PM cannot edit while `SENT_BACK` or `RESUBMITTED`; Fix entry hidden; Withdraw stays visible to PM and may be used at any time. REQ-05, REQ-09. Follow-ons: Q12, Q13, Q16.
- **Status:** answered (RESOLVED 2026-10-13)

### Q5 - Terminal state
- **Answer:** `CORRECTED` is not final; PM re-edits or re-sends; unlimited rounds. REQ-06, REQ-10.
- **Status:** answered (RESOLVED 2026-10-13)

### Q6 - Change-log semantics
- **Answer:** cumulative, oldest first, author per row; repeat edits are separate rows, no collapsing; append-only table (shape = D1). REQ-01, REQ-11. Follow-on: Q14.
- **Status:** answered (RESOLVED 2026-10-13)

### Q7 - Does PA initiate?
- **Answer:** no. REQ-07.
- **Status:** answered (RESOLVED 2026-10-13)

### Q8 - Is a PM-to-PA hand-off wanted?
- **Answer:** yes, as a second option beside direct Fix entry. REQ-07.
- **Status:** answered (RESOLVED 2026-10-13)

### Q9 - Missing decision note 2026-10-13
- **Question:** `tcg-scrum` to record the 2026-10-13 decision (Stage 1 gate lowering + this round-trip design: all answers above) in `.ai/vault/decisions/` with a named decider. Code comments already cite "decision 2026-10-13"; none exists.
- **Why:** `ls .ai/vault/decisions | grep 2026-10-1` showed none after 2026-10-09.
- **Blocked:** nothing for build per developer ("don't block on it"); sign-off item in §14 and the reason the tags are `[VERIFIED*]`, not `[VERIFIED]`.
- **Owner:** Ali Riaz runs `tcg-scrum`.
- **Workaround, if any:** none needed.
- **Status:** open

### Q10 - Indicator scope and legacy rows
- **Answer:** shown on every row, "Name (Role)" + date/time; legacy rows get a grey "Legacy" chip. REQ-02, REQ-12. Follow-on: Q16.
- **Status:** answered (RESOLVED 2026-10-13)

### Q11 - Reach into entry-fix flow and employee leg
- **Answer:** attribution applies to both the Correction Dialog and `EntryFixView`; round-trip applies to send-back-based corrections only. REQ-13. The employee leg and the flags-panel link are unchanged.
- **Status:** answered (RESOLVED 2026-10-13)

### Q12 - Permission gates on the routing and withdraw controls
- **Answer (dev-final-2026-10-13):** Yes to both. PM (`payroll:edit`) can Send Back To Payroll Admin and can Withdraw. Close stays PA-only. Gates: send-back -> `payroll:edit`; preview -> `payroll:edit`; withdraw -> `payroll:edit`; close stays `payroll-admin:edit`. The Send Back and Withdraw buttons show to anyone with `payroll:edit`, not only `canAdminister`. Folded into REQ-04, REQ-09. Route names: the answer wrote `POST /payroll/send-backs` and `POST /payroll/send-backs/:id/preview`; the code's routes are `GET`/`POST payroll/periods/:id/tickets/:ticketId/send-back` and `POST payroll/send-backs/:id/withdraw` - the intent is unambiguous, so the spec names the code's routes.
- **Status:** answered (RESOLVED 2026-10-13)

### Q13 - `RESPONDED` status
- **Answer (dev-final-2026-10-13):** `RESPONDED` is treated exactly like `SENT_BACK`: PM locked out, PA has it via Returned Entries, acting on the employee's reply. Fix entry hidden for PM in `SENT_BACK`, `RESPONDED` and `RESUBMITTED`. Enum checked (`schema.prisma:5415`): the employee reply is `RESPONDED`; `RESUBMITTED` is the primary's resubmission and was already locked by Q4. Folded into REQ-05, REQ-08.
- **Status:** answered (RESOLVED 2026-10-13)

### Q14 - Does cumulative include `PayrollEntryFix` history?
- **Answer (dev-final-2026-10-13):** Yes. One unified timeline across the correction and direct-fix paths, keyed on the entry (employeeId x ticketId x periodId), not `sendBackId`: every change from every historical `PayrollSendBack` (every round) and every `PayrollEntryFix`, oldest first, author + role + timestamp on every row. Row shape: `(tenantCompanyId, periodId, employeeId, ticketId, round, authorId, authorName, authorRole, changedAt, field, label, before, after)` plus a nullable discriminated reference to the source (`sendBackId` or `entryFixId`). Folded into REQ-01, REQ-11, REQ-13, D1. Follow-on is a developer decision, not a question: D1b (pre-feature history).
- **Status:** answered (RESOLVED 2026-10-13)

### Q15 - `CLOSED` is not a status
- **Answer (dev-final-2026-10-13):** settled. `CLOSED` is not an enum member; "closing" a send-back means transitioning it to `CORRECTED`. The spec uses that term. REQ-03, REQ-08.
- **Status:** answered (RESOLVED 2026-10-13)

### Q16 - Role labelling and the lock's PM/PA test
- **Answer (dev-final-2026-10-13):** snapshot the role string on every change row at write time, resolved server-side from effective permissions: has `payroll-admin:edit` -> "Payroll Admin"; else `payroll:edit` -> "Payroll Manager"; else the primary department role name. The write path (POST/PATCH) resolves and persists it. Folded into REQ-14, REQ-02. The REQ-05 lock uses the same split (a user with both is PA); the answer states the label rule only, so that reuse is this spec's reading, marked as such in REQ-05.
- **Status:** answered (RESOLVED 2026-10-13)

### Q17 - Accept the snapshot overwrite / two PMs after `CORRECTED`
- **Answer (dev-final-2026-10-13):** accepted as a tolerable edge case given the send-back lock covers the primary workflow: "the change log honestly records whichever PM wrote last". Recorded in REQ-10, §11 and D6.
- **Status:** answered (RESOLVED 2026-10-13)

### Q18 - Role source: server-resolved (REQ-14) vs client-sent page role
- **Question:** REQ-14 and Q16 say the server resolves the role label from effective permissions and "the client never supplies the label"; a user with both permissions is PA. A later developer decision (caller to the decomposer, 2026-10-13) says the role is page-derived: the client sends `role: 'PM' | 'PA'` on every write, the server validates it (`PA` needs `payroll-admin:edit`, `PM` needs `payroll:edit`) and stores the resolved label. Under the new rule a user holding both permissions acting from the Weekly Payroll page is stored as Payroll Manager and is subject to the PM lock. Which text governs?
- **Why:** REQ-02, REQ-05 (lock test) and REQ-14 acceptance ("both permissions -> Payroll Admin") are written to the old rule. Units U1-U4 follow the newer developer decision.
- **Blocked:** nothing; spec text needs re-sync before sign-off.
- **Owner:** Ali Riaz / elaborator to update REQ-02, REQ-05, REQ-14.
- **Status:** open

### Q19 - Stopping the `correctionChanges` write breaks the approval hold
- **Question:** D1b (caller) says the old JSON columns stop being written for new changes. `payroll-send-backs.repository.ts:643` (`countBlockingByEmployee`) holds the week for a `CORRECTED` row only when `correctionChanges` is not null. If the write stops, a post-run correction no longer holds approval. Keep writing the column (dual-write), or change that query to another signal (e.g. `correctedAt` / existence of log rows)? Same question for `PayrollEntryFix.changes`.
- **Why:** spec §11a row 2 says this query's meaning must be preserved.
- **Blocked:** the stop-writing part of D1b only. U1 leaves the write untouched.
- **Owner:** developer (Ali Riaz).
- **Status:** open

### Q20 - D1b contradicts REQ-12: "unread" legacy rows vs a Legacy chip
- **Question:** D1b: "existing rows remain unread" and "the Legacy chip covers display of pre-ship data that will never populate the new table". A chip needs a reader that reads the old `correctionChanges` / `PayrollEntryFix.changes` JSON. Is there a read-time fallback to the old JSON (then the chip shows), or are pre-ship changes not shown at all (then REQ-12 and Q14's "every historical" are narrowed)?
- **Blocked:** U5 (REQ-12).
- **Owner:** developer (Ali Riaz).
- **Status:** open

### Q21 - Does the PM lock cover the entry-fix endpoints?
- **Question:** REQ-05 says a PM cannot edit an entry while `SENT_BACK`/`RESPONDED`/`RESUBMITTED`, enforced server-side, but §4 names only `submitCorrection`. `POST`/`PATCH` on the entry-fix route (`payroll-entry-fixes.controller.ts:39,59`) are gated `payroll:edit` and do not look at the send-back status. Should they refuse a PM in those statuses?
- **Blocked:** the entry-fix half of REQ-05 (cut from U4).
- **Owner:** developer (Ali Riaz).
- **Status:** open

## 13. What this spec deliberately does not specify

Indicator visual beyond "Name (Role)" + time + grey "Legacy" chip, notifications beyond today's, round limit, retention, copy for the withdraw-during-edit 409, whether PA keeps its fresh `PayrollEntryFix` entry point (`/payroll/[employeeId]/entries/[ticketId]`, `payroll-admin:edit`), the flags-panel link behaviour, and whether PA may submit a correction from `RESPONDED` itself (the answer says "via Returned Entries as today"; `submitCorrection` accepts only `SENT_BACK`/`RESUBMITTED` today and this spec does not change that), the unified timeline's per-row visual, and the `PayrollEntryFix.changes` JSON's fate (D1b).

## 14. Sign-off before build

- [x] Q12-Q17 answered (dev-final-2026-10-13)
- [ ] Q9: decision note recorded by `tcg-scrum` (flips `[VERIFIED*]` to `[VERIFIED]`)
- [x] Answers written back with new sources and flags
- [x] Every §11a ripple row has a source or a developer decision
- [ ] Every §11b row has Chosen and Decided by filled by a developer (D1, D1b, D3, D5, D6, D7 are blank)
- [ ] Every §11c sibling has a developer's yes / no / follow-up
- [ ] Re-diff REQ acceptance lines against their executor notes (SCRUM-926 SD-1/SD-2) before decomposition
- [ ] Decomposed into vertical units - `units.md`

Answered by: ______________  Date: ______________
