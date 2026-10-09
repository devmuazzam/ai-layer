# Units — PAYROLL-FLAGS Flagged-entries rework, units U6–U13

> Written to `.ai/aidlc/PAYROLL-FLAGS/units-u6-u13.md` from the approved
> `.ai/aidlc/PAYROLL-FLAGS/spec-u6-u13.md`, as a **new, separate file** — `spec.md`,
> `units.md` and `spec-u6-u13.md` are **not edited** by this pass. A build of U3–U5 is
> running against those three files right now; this file only reads them.
>
> **Nothing here has been implemented.** The decomposer produced this file and stopped.

**Spec revision this file was cut from:** `spec-u6-u13.md` as it stood 2026-09-30, second
pass — **19 requirements (REQ-15–REQ-33), 0 verified, 18 unverified, 1 conflicted
(REQ-31), 0 open.** All six §12 questions (Q20–Q25) are `Status: resolved` — Q20, Q21,
Q22, Q25 without qualification; **Q23 and Q24 resolved as "which design to build," not as
client ratification**, both still explicitly pending Corrina Bustos. REQ-31 keeps its
`[CONFLICT]` tag for exactly that reason; this decomposition does not clear it — see U13.

**File paths and line numbers below were independently re-verified against the codebase on
`feat/PAYROLL-FLAGS-foundation` on 2026-09-30 — not trusted from `spec-u6-u13.md`'s own
text, even though that spec's own citations were themselves verified the same day.** Most
of it checked out exactly or within a line or two. Six things did not, all recorded under
*Findings from path verification* below, because they change how confidently a unit can be
built, not what to build.

## Git layout — same branch, same PR as U1–U5, one commit per unit, developer's choice

Per the same standing instruction `units.md` records for U1–U5 (`spec.md` §0's *Scope
note*, sourced to
`decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` round 8):
**U6–U13 ship on the same single branch `feat/PAYROLL-FLAGS-foundation`, as the same PR,
one commit per unit**, in dependency order. This overrides the project's usual
one-unit-per-branch convention for this ticket only, exactly as `units.md` already
established for U1–U5.

**Each unit's commit must stand alone**: build, typecheck and pass its own new tests on
top of every commit the branch already carries — U1–U5 plus whichever of U6–U13 came
before it. Checking out the branch at unit *N*'s commit tip must be a green, shippable
state for every unit up to and including *N*.

**Commit order — U6, U7, U8, U9, U10, U11, U12, U13** (REQ numeric order), chosen because
it satisfies every dependency the task gave without reordering:

| Unit | Needs | Why this slot works |
| --- | --- | --- |
| U6 | U5 | Nothing in U6–U13 needs U6. |
| U7 | U5 | Nothing in U6–U13 needs U7. Could swap with U6 — see *Sequencing*. |
| U8 | U1 | Unblocks the longest chain (U8→U9→U11→U12/U13). |
| U9 | U8 | REQ-22's own Notes: "sequence U9 before U11." |
| U10 | U3, U8 | Does **not** need U9 — could move earlier or later relative to it; kept here to match REQ order. |
| U11 | U1, U9 | REQ-25's schema and REQ-22's schema both touch `PayrollSendBack` — U9's migration (nullable `sentToEmployeeId`, `WITHDRAWN`) must land first. |
| U12 | U11 | Needs `PayrollSendBack` rows and the return-group shape U11 adds. |
| U13 | U11 | Needs the return-group/hold mechanism U11 adds. Could swap with U12 — see *Sequencing*. |

This is the developer's/decomposer's choice, not the only valid order — see *Sequencing*
at the end for which pairs are genuinely interchangeable and which are not.

## What a unit is

Same test `units.md` states in full: a **vertical shippable slice** — schema → API → web
and/or mobile → tests, for one piece of behavior, reviewable on its own. *"If the unit
ships alone, what can someone do that they could not do before? If the answer is 'nothing,
it's the backend half', it is not a unit."* Full text, including the two narrow foundation
exceptions: `units.md` → *What a unit is*. Nothing below claims a foundation exception —
every unit here is vertical, including the five-requirement U8 and four-requirement U11,
sized `L` honestly rather than split by layer (see §6 reasoning inline at each).

## Gates convention (applies to every unit below, stated once)

The developer approved **targeted** gates, not whole-suite runs. Per unit:

- **eslint:** run directly against that unit's own changed/new files, e.g.
  `pnpm --filter @tcg/api exec eslint <files…>`, `pnpm --filter @tcg/web exec eslint
  <files…>`, `pnpm --filter @tcg/mobile exec eslint <files…>` — each app's `lint` script
  (`eslint src/`, `eslint src/`, `eslint app/ … theme/`) already accepts an explicit file
  list in place of its default globs.
- **typecheck:** `apps/api` has no standalone `typecheck` script — its type errors surface
  through `pnpm nx run @tcg/api:build` (`nest build`); there is no lighter per-file mode.
  `apps/web`/`apps/mobile` do have one (`next typegen && tsc --noEmit`, `tsc --noEmit`) but
  it is whole-project — there is no per-file `tsc` mode that respects path aliases in this
  repo. Run the project's own typecheck target for every surface the unit touches and
  attribute only errors on that unit's own changed files to that unit, per the developer's
  own targeted-not-whole-suite framing.
- **tests:** run only the unit's own new/changed spec files — `pnpm nx run @tcg/api:test --
  <pattern>` (Jest) for API specs; `node --experimental-strip-types --test <specific
  path(s)>` for web `.test.mjs` files, **after** adding each new one to the explicit
  whitelist array in `apps/web/package.json`'s `test` script (confirmed today: every file
  is enumerated by path, not globbed — a file left out silently never runs); `pnpm nx run
  @tcg/mobile:test -- <pattern>` (Jest) for mobile.

Each unit's own entry below names the specific files for each of these three, once, under
*Gates*.

## Findings from path verification

Six things the independent re-check surfaced that `spec-u6-u13.md`'s own (same-day)
verification did not carry, or that have moved since. None changes a requirement; all
change how a unit should be built or reviewed.

1. **`plan-correction.ts`'s own-window branch is at lines 176–203 today, not 266–296** as
   `spec-u6-u13.md`'s REQ-19 Sources cite. Independently read in full: the file is 353
   lines (matching the spec's own line-count claim), but the
   `if (params.member.workStartedAt && params.member.workEndedAt) { … } else {
   setWindow(TicketTimeEntryType.WORK_TIME, startWork, endJob); }` branch sits at 176–203,
   not 266–296. The logic itself is exactly as described — only the line numbers are
   stale. Re-grep before U8 is built.
2. **`findSettledCrewPay` is at `apps/api/src/service/payroll-send-backs/
   payroll-send-backs.repository.ts:540`, not `:678`** as REQ-19's own Notes cite — the
   file is 583 lines total, so line 678 does not exist in it. It is called from
   `apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:542`, **not**
   from `correction-rules.ts` as §11a row 6's phrasing implies (`correction-rules.ts` holds
   the milestone/gap/order/rest checks; the whole-crew settled-pay check is a separate
   function, called directly by the service). Affects U8's Notes.
3. **`apps/api/src/usecase/payroll/payroll.service.ts`'s internal line numbers have
   drifted** from `spec-u6-u13.md`'s citations by 10–90 lines (`executeRun` now at :387,
   cited :377; `assertNoRecalculationHold` now at :644, cited :627; `approveEmployee`/
   `approvePeriod` now at :865/:902, cited :857/:896; the four `assertNoRecalculationHold`
   call sites now include :1142/:1173, cited :1050/:1081) — expected, since U2's rest-gap
   work and U3's void-ticket work both touch this same file and are mid-build/uncommitted.
   Re-grep at build time for every unit that touches this file (U8, U10, U11, U13) rather
   than trusting either spec's numbers.
4. **PR #699's salvage-relevant subset is 27 files, +5,302/−416** (`payroll-pricing/*`,
   `week-move.ts`(+spec), `correction-rules.ts`(+spec), `plan-correction.ts`(+spec),
   `correction-preview.ts`(+spec), `compute-labor-hours.ts`, `ticket-time-totals.ts`(+spec),
   `packages/shared/src/utils/index.ts`, the three `payroll-corrections/lib/*.ts` files,
   `correction-preview-card.tsx`), independently measured via `git diff
   origin/main...origin/fix/payroll-correction-page-ui --stat` scoped to those paths — not
   the "+3,550/−265 across 22 files" `spec-u6-u13.md`'s own Provenance section cites for
   the same branch. The discrepancy doesn't change what to build; it is flagged because the
   **closed branch also bundles a second, unrelated feature** — a multi-day-entry-per-date-
   row timesheet rework (`payroll-employee-table.split.tsx`, `payroll-entry-split.ts`,
   `payroll-date-rows.ts`, `payroll-employee-table.{nested,primitives,row,dates}.tsx` and
   their tests — confirmed present in the full 134-file, +14,167/−1,955 diff, none of it
   cited by any REQ-18–21/33 source) — a real risk of pulling in the wrong half of the
   branch when copying files out of it. See U8's Slice contents for the exact file list
   this decomposition brings over and the exact list it deliberately leaves behind.
5. **U3 is further along than "in progress, no schema yet."** `apps/api/prisma/
   schema.prisma` already carries `enum PayrollTicketClosure { VOIDED COMPLETED }` (lines
   201–204) and all four of `JobTicket.payrollClosedAction/At/ByUserId/CloseNote` (lines
   4681–4684) — uncommitted (`git status`: modified `schema.prisma`; untracked migration
   `20260930190000_payroll_ticket_void/`), but on disk. U10 (REQ-24) can build directly
   against `COMPLETED` once U3 merges — no enum migration of its own — matching
   `spec-u6-u13.md`'s own §3 note, now confirmed rather than assumed.
6. **U5 (`PayrollFlag`, `PayrollFlagEvent`, `PayrollFlagDetectionService`,
   `PAYROLL_FLAG_CATALOG`) is confirmed not started** — no trace anywhere in
   `schema.prisma`, `apps/api/src`, or `packages/shared/src` (`grep -rn "PayrollFlag\b"`,
   no hits). Every U6/U7 row below that plugs into it cites `units.md`'s own U5 section as
   the design source, not code, and is marked **"introduced by U5"**.

New migrations in this file use placeholder timestamps later than the latest existing
folder, `20260930190000_payroll_ticket_void` (U3's, uncommitted) — `20261001100000` onward,
an hour apart, in this file's own commit order. **These are placeholders.** U4 adds no
migration; U5's own migration timestamp is unknown until U5 actually ships — re-verify
every timestamp here does not collide with whatever U4/U5 land on before cutting any of
these migrations for real.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U6 | Calculate raises `REST_UNDER_8H` on any sub-8h rest gap, regardless of whether a PAY-045 premium fired | REQ-15 | api, shared | U5 | S | not started |
| U7 | Calculate raises five `INVALID_TIME_*` codes plus `INVALID_LONG_BOOM_TIME`; web renders labels for all six | REQ-16, REQ-17 | api, shared, web | U5 | M | not started |
| U8 | Payroll fixes one employee's Start Work/End Job (own window, never the shared row) or, on a one-person ticket, any field; a before/after preview; the worker's own `/me/labor` shows it | REQ-18, REQ-19, REQ-20, REQ-21, REQ-33 | schema, api, shared, web | U1 | L | not started |
| U9 | The Crane Supervisor permission, role and routing are removed; `PayrollSendBack` reshaped for U11 | REQ-22, REQ-23 | schema, api, shared, seed, web | U8 | M | not started |
| U10 | Payroll completes a never-completed ticket, entering the missing times | REQ-24 | schema (reuses U3's enum), api, web, mobile | U3, U8 | M | not started |
| U11 | Sending back one crew member's entry returns and holds every roster member's week; the worker sees it and can reply on mobile; payroll's dialog shows the whole crew | REQ-25, REQ-26, REQ-27, REQ-28 | schema, api, shared, mobile, web | U1, U9 | L | not started |
| U12 | A `SENT_BACK` row reminds its worker every 3 hours until answered; a rotated push token keeps receiving it | REQ-29 | schema, api, mobile | U11 | S | not started |
| U13 | The primary on a returned ticket can edit and resubmit; Start Work/End Job stay individual, six other field types move (and hold) the whole crew — `[CONFLICT]`, built on one side, not resolved | REQ-30, REQ-31, REQ-32 | api, mobile | U11 | L | not started |

- **Requirements not covered by any unit:** none. **19 requirements in `spec-u6-u13.md` §1
  — 19 covered.** 1 + 2 + 5 + 2 + 1 + 4 + 1 + 3 = 19. REQ-33 lands in U8 per
  `spec-u6-u13.md` §14's own explicit instruction ("the decomposer should decide where
  REQ-33 lands (U8, per this file's own note at REQ-33)"), not U13, even though REQ-33's
  own text calls U13 a secondary, weaker fit.
- **Units blocked on an open question:** none. No requirement in this file is `[OPEN]`.
  REQ-31 is `[CONFLICT]` — not the same thing — and is built as the spec states (U13), tag
  kept, not treated as a blocker.

---

## U6 — `REST_UNDER_8H` flag detector

- **Outcome:** Calculate (via U5's `PayrollFlagDetectionService`) raises an `OPEN`
  `REST_UNDER_8H` flag on the first job day of each rest chain whose gap from the
  employee's previous paid work is under 8 hours — regardless of whether that gap actually
  triggered a PAY-045 premium. The flag names the previous ticket, the gap in hours, and
  whether a premium was paid.
- **Kind:** vertical
- **Requirements covered:** REQ-15 — fully.
- **Depends on:** U5 (the `PayrollFlag`/`PayrollFlagEvent` schema, the detection-pass hook,
  the reconciliation logic, and the generic flags panel/timesheet chips/worklist KPI this
  unit's flag renders through, per *Findings* #6 — none of it exists yet; every citation
  below to a U5-owned name is **introduced by U5**, cited from `units.md`'s own U5 slice
  table, not code).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | None. | Reads `PayrollJobDay.restGapHours`/`restForcedHours`/`restFloorMult` — confirmed already on disk today at `schema.prisma:5540-5543` (independently re-verified, near-exact match to `spec-u6-u13.md`'s own citation) — a read, not a write. No new column or enum value: U5's `PayrollFlag.code` is a plain `String`, generic enough for this detector's code with no migration of its own. |
| API (`apps/api`) | New detector, in whatever module U5 registers its own `OVERLAPPING_JOBS` check under — **introduced by U5**, cited as `apps/api/src/usecase/payroll-flags/payroll-flag-detection.service.ts` per `units.md`'s U5 slice table. Reads persisted `PayrollJobDay` rows per employee, ordered by start time; needs the same chain-boundary grouping U2's `toWorkChains`/`REST_STITCH_MINUTES` uses — if U2 does not expose a chain id on the persisted row (per `spec-u6-u13.md` REQ-15's own Notes), this detector re-derives the boundary itself, over the API layer's own rows, not inside `packages/payroll-engine` (`RestEntry` has no ticket id — confirmed by REQ-15's Sources — this cannot be written by reading engine output directly). Hooked onto whichever detection pass U5 wires onto `executeRun` (`payroll.service.ts`, currently at line 387 — drifted from `spec-u6-u13.md`'s cited 377, see *Findings* #3; will move again once U3/U4/U5 land — re-grep). | "The employee's previous paid work," when the previous ticket was itself `VOIDED` (U3) or `CANCELLED`: `NOT SPECIFIED` by any source; build the smallest default (the chain looks straight through it to whatever precedes it, matching the engine's existing chain-stitching for any ticket the loader already excludes) — per REQ-15's own text, not raised as a blocking question. |
| Shared (`packages/shared`) | `packages/shared/src/constants/payroll-flags.ts` — **introduced by U5** (`PAYROLL_FLAG_CATALOG`, confirmed absent from disk today, `grep -rn "PAYROLL_FLAG_CATALOG" packages/shared/src`, no hits) — gains one `REST_UNDER_8H` entry (title/subject). | Do not pre-build entries for any other U6–U13 flag here — one entry per unit that owns its own code, matching U5's own stated discipline (`units.md` U5 Deliberately-not: "no future detector's logic is stubbed or half-built here"). |
| Web (`apps/web`) | None beyond the catalog entry above. U5's flags panel/timesheet chips render any code present in the catalog generically (per U5's own `PayrollFlag.detail`/`.message` shape, "human-readable text plus structured detail"). | Confirm at build time whether the generic renderer truly needs no per-code branch for this one — if U5 ships a renderer that special-cases codes, this row changes; flag, don't assume. |
| Mobile (`apps/mobile`) | None. | `N/A` — REQ-15's surface list is `api, web` only. |
| Tests | **Unit (API):** `REST_UNDER_8H` fires on a sub-8h gap with no PAY-045 premium applied, and on one with a premium applied (both cases, per `spec-u6-u13.md` §10); a gap of exactly 8h or a null gap (no prior context ticket, first entry of the period) does not flag; a chain whose immediately preceding ticket is `VOIDED`/`CANCELLED` looks through it to the one before, per this unit's own default. | New spec file alongside U5's own detection-service spec, e.g. `payroll-flag-detection.service.spec.ts` (existing file once U5 ships — append, don't duplicate). |

**Gates:** eslint on the new detector file + `payroll-flags.ts`; api typecheck via
`pnpm nx run @tcg/api:build`; tests via `pnpm nx run @tcg/api:test -- REST_UNDER_8H` (or
the new spec file's own path).

### Reviewable as

- **Demo:** two chained tickets for one employee with a sub-8h gap between them → run
  Calculate → `GET periods/:id/flags` shows one `OPEN` `REST_UNDER_8H` flag naming both
  tickets and the gap.
- **Acceptance:** REQ-15's Acceptance line in `spec-u6-u13.md` §2.
- **Reviewer can verify without:** U7–U13; **not** without U5 — there is no flag table, no
  detection pass, and no rendering surface until U5 ships.

### Risk

- **Weakest source:** `[UNVERIFIED]` — the base flag-list item (Corrina, verified) does not
  itself say whether the flag fires only when a premium was paid; the "fires regardless"
  design fact (E3) is developer reference-status.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by any migration; Calculate begins raising
  this flag against existing tenant data from its first post-ship run.
- **Blast radius:** inherits U5's own unconditional-blocking design — a tenant with an
  existing sub-8h gap in live data is blocked the moment this ships, layered onto whatever
  `OVERLAPPING_JOBS` (U5) already causes, with the same "no per-tenant opt-out" property.

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source |
| --- | --- | --- | --- |
| `PayrollJobDay.restGapHours` (existing, engine-written) | new, read-only API-layer consumer | none needed — a new reader, not a new writer; nothing about how the column is computed or written changes | `spec-u6-u13.md` §11a row 1; `schema.prisma:5540-5543` |

### Deliberately not in this unit

- **Any UI beyond the catalog entry** — U5's generic flags panel/chips render it; no
  bespoke component.
- **Fixing the engine's `RestEntry`-has-no-ticket-id gap** — flagged for U2/U5's executor
  per REQ-15's own Notes, not built here (this detector works around it at the API layer
  instead).

---

## U7 — Invalid-time detectors and `INVALID_LONG_BOOM_TIME`, web labels

- **Outcome:** Calculate raises one blocking `OPEN` flag per condition, per roster member:
  `INVALID_TIME_SAME_START_END`, `INVALID_TIME_OUT_OF_ORDER`, `INVALID_TIME_DUPLICATE`,
  `INVALID_TIME_MISSING_START_OR_END`, `INVALID_TIME_24H_OR_MORE` (REQ-16), and
  `INVALID_LONG_BOOM_TIME` (REQ-17 — same-start/end on a boom session, out-of-order, or
  outside the ticket's `WORK_TIME` window). Web renders labels for all six codes in U5's
  flags panel/timesheet chips, with a link to U8's fix screen once REQ-21 ships.
- **Kind:** vertical
- **Requirements covered:** REQ-16, REQ-17 — fully.
- **Depends on:** U5 (same as U6 — every `PayrollFlag`-framework name below is **introduced
  by U5**, cited from `units.md`'s U5 slice table).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | None. | Reads `TicketTimeEntry`, `TicketEmployee.workStartedAt`/`workEndedAt` — all existing. |
| API (`apps/api`) | Six new detectors, sibling functions/file to U6's and U5's own, in the **U5-introduced** `apps/api/src/usecase/payroll-flags/` module. `INVALID_TIME_SAME_START_END`: a `WORK_TIME` row, a member's own window, or a `BOOM_TIME` session whose start equals its end — confirmed live at `apps/api/src/usecase/ticket-work-segments/ticket-work-segments.service.ts:145-150,170-173` that a same-instant boom session is silently bumped `+1` second at write time, **never refused** — independently re-verified exact match — so this check is real, not dead code. `INVALID_TIME_OUT_OF_ORDER`: reuses `findWindowOrderViolation` (`apps/api/src/usecase/ticket-time-entries/validate-step-times.ts:253`, independently re-verified exact match). `INVALID_TIME_DUPLICATE`: **new in full** — confirmed by grep (`DuplicateWindow`, no hits anywhere in `apps/api/src`, `packages`, `apps/web/src`, or the vault) that no duplicate-entry detection exists today; compares the same employee's two tickets' PAY-020-rounded `WORK_TIME` start/end (rounding must match the engine's own convention, not raw captured instants — per REQ-16's own Notes). `INVALID_TIME_MISSING_START_OR_END`: a milestone type present with no closing row, or an open `BOOM_TIME` segment — a **parallel**, per-employee counterpart to the existing, unchanged, run-level `TICKET_MISSING_PAYABLE_WINDOW` (`payroll.service.ts`/`payroll.repository.ts:668`). `INVALID_TIME_24H_OR_MORE`: `WORK_TIME` span `>=` 24h — coordinate the threshold value with U8's `LONG_WORK_WINDOW_HOURS = 24` constant (salvaged from PR #699 in U8): share one named constant, or keep two at the same value — `NOT SPECIFIED` which, flagged so U7's and U8's executors do not silently drift (per REQ-20's own Ripple note). `INVALID_LONG_BOOM_TIME`: **pick one owner** for the same-start/end-on-boom case — either fold it entirely into this code (matching Corrina's own item-6 naming) and drop it from `INVALID_TIME_SAME_START_END`'s boom case, or the reverse — `NOT SPECIFIED` which; document the choice in the detector's own comment, do not raise two flags for one boom session (per REQ-17's own Notes). Also covers out-of-order-on-boom and a boom session starting before `WORK_TIME`'s start or ending after its end — this last part is a developer's reading (round 9) of a silence, not Corrina's own confirmed words (she was offered the exact example on 2026-09-29 and did not repeat it). | Suppressing `OVERLAPPING_JOBS` (U5) for a pair `INVALID_TIME_DUPLICATE` already caught — `NOT SPECIFIED`, proposed by the plan, not asked for or against by any source; build as proposed, since it costs nothing to change later (a detector-ordering choice, not a schema commitment), per REQ-16's own Open question note. |
| Shared (`packages/shared`) | `payroll-flags.ts` (**introduced by U5**) gains six entries: the five `INVALID_TIME_*` plus `INVALID_LONG_BOOM_TIME`. | |
| Web (`apps/web`) | U5's flags panel/timesheet chips render all six new codes (generic). REQ-17's own text additionally calls for explicit labels for "both U7 codes" and a link to U8's `/payroll/[employeeId]/entries/[ticketId]` fix screen once REQ-21 ships. | The link's target does not exist if U7 ships before U8 (this file's own commit order has U7 before U8) — build the flag row without the link, or a disabled one, until U8 lands; `NOT SPECIFIED` by any source how it should degrade, flagged for the executor since this file's own ordering makes the gap real for at least one review cycle. |
| Mobile (`apps/mobile`) | None. | `N/A`. |
| Tests | **Unit (API):** each of the five `INVALID_TIME_*` detectors, a matching and a non-matching row (per `spec-u6-u13.md` §10); `INVALID_LONG_BOOM_TIME` against same-start/end, out-of-order, and outside-work-window boom sessions (per §10); a `WORK_TIME` span of exactly 24.0h flags (`>=`), 23.9h does not. | New spec file(s) alongside U5's/U6's own detection-service specs. |

**Gates:** eslint on the six new detector functions/file + `payroll-flags.ts` + the web
label/link change; api typecheck via `pnpm nx run @tcg/api:build`; web typecheck via
`pnpm nx run @tcg/web:typecheck`; tests via the new API spec file(s) and any new web test.

### Reviewable as

- **Demo:** a ticket with a `BOOM_TIME` session whose start equals its end → Calculate →
  the flags panel shows the code the executor chose to own that case, naming the session.
- **Acceptance:** REQ-16/REQ-17's Acceptance lines in `spec-u6-u13.md` §2.
- **Reviewer can verify without:** U6, U8–U13; **not** without U5.

### Risk

- **Weakest source:** `[UNVERIFIED]` — same-start/end and out-of-order are Corrina's own
  verified words (2026-09-29 clause 1); the four sub-checks under her own item 5, the
  `>=`24h inclusivity, and the boom-outside-work-window reading are all developer
  reference-status, the last one built on a silence she was offered and did not repeat.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by any migration; every existing tenant's next
  Calculate run may raise these six flags against live data, unconditionally, same as U5/U6.
- **Blast radius:** the duplicate-entry and 24h+ checks are **genuinely new** — no code or
  vault document has ever flagged either condition before (confirmed by grep) — so a
  tenant's very first exposure to either being called out at all is this unit.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| `TICKET_MISSING_PAYABLE_WINDOW` (existing, run-level `PayrollIssue`) | separate, parallel mechanism | none needed — unchanged; this unit adds a parallel, per-employee flag for the same underlying condition | `spec-u6-u13.md` §11a row 2 |
| `PayrollEmployeeWeekStatus.FLAGGED` relabel (`spec.md` REQ-09) | shared enum, display copy only | none needed — unaffected, this unit only adds catalog entries | `spec-u6-u13.md` §11a row 3 |

### Deliberately not in this unit

- **Wrong-AM/PM detection, labor-vs-ticket mismatch** — U16, out of scope.
- **Resolving which of REQ-16/REQ-17 "owns" the boom same-start/end check** beyond
  documenting the executor's choice — `NOT SPECIFIED` by any source which is correct.
- **Unifying `LONG_WORK_WINDOW_HOURS` with U8's own constant** — flagged, not decided.

---

## U8 — Per-person entry fix: schema, API, pricing preview, web, `/me/labor` override

- **Outcome:** A Payroll Admin/Manager fixes one employee's Start Work/End Job on a ticket
  — always the employee's TCG-25 own window, creating one if needed, **never** the shared
  `WORK_TIME` row, on every ticket regardless of roster size. On a one-person-roster
  ticket, every other captured field is directly editable too (the ticket's one shared row
  already belongs to that person alone); on a crew ticket the other six field types stay
  read-only ("needs a per-person home"). A required note is audited in a new
  `PayrollEntryFix` row, which holds the employee's week from approval — generalizing the
  existing `PayrollSendBack`-only hold mechanism — until the next completed Calculate. The
  fix preview shows a whole-week before/after pay estimate, computed in memory, salvaged
  from the closed PR #699, never persisted; a fix moving `WORK_TIME`'s start across a
  pay-week boundary prices in the **currently open week**. A new web route lets Payroll
  open, edit and preview a fix, with a "Fix entry" action and a recalculation-hold banner.
  `/me/labor`/`/me/performance` read the employee's own-window override once one exists, so
  the worker sees the corrected hours, not the stale shared-window figure.
- **Kind:** vertical
- **Requirements covered:** REQ-18, REQ-19, REQ-20, REQ-21, REQ-33 — fully. REQ-33 lands
  here per `spec-u6-u13.md` §14's own explicit instruction, not because it is the tidiest
  fit — its own text calls U13 a secondary, weaker one. **Why five requirements stay one
  unit, not a layer split:** REQ-18/19/20 (schema+api+shared) have nothing to demo without
  REQ-21 (web) — there is no other surface a reviewer could exercise the fix through; REQ-21
  has nothing to build a screen for without REQ-18–20. REQ-33 is the smallest possible tail
  on the same feature (it is what makes REQ-19's fix visible to the worker it corrects, per
  its own placement note) — splitting it out would recreate the exact "where does REQ-33
  go" ambiguity `spec-u6-u13.md` §14 already resolved. Sized `L` honestly, not by layer.
- **Depends on:** U1 (every new route is `payroll-admin`-gated).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New `PayrollEntryFix` table, exactly per `spec-u6-u13.md` §3's Prisma block: `id`, `tenantCompanyId`, `periodId`, `jobTicketId`, `employeeId`, `changes Json` (`{field, label, before, after}[]`, matching `PayrollSendBack.correctionChanges`'s own shape), `note String @db.Text`, `fixedByUserId`, `fixedAt`; `@@index([tenantCompanyId, periodId, employeeId])`. No business code, no per-tenant prefix — same `PayrollSendBack` precedent `spec.md`'s own U5 already used for `PayrollFlag`. Migration `apps/api/prisma/migrations/20261001100000_payroll_entry_fixes/migration.sql` — purely additive, one new table, no backfill. `apps/api/src/orm/prisma.service.ts`'s `$extends` allowlist gains `payrollentryfix` in the **same commit** — confirmed today's allowlist already holds `payrollsendback`/`payrollissue`; `payrollflag`/`payrollflagevent` will already be there once U5 ships. | |
| API (`apps/api`) | New `apps/api/src/presentation/payroll-entry-fixes/payroll-entry-fixes.controller.ts` (+ `dto/fix-entry.dto.ts {changes, note}`, `@IsNotEmpty()` on `note`) — four routes per `spec-u6-u13.md` §4: `GET`/`PATCH .../fix`, `POST .../fix/preview`, all `@RequirePermission('payroll-admin','edit')`. New `apps/api/src/usecase/payroll-entry-fixes/` — module + service, writing the employee's TCG-25 own window (`ticket_employees.workStartedAt`/`workEndedAt`) for Start Work/End Job on every ticket, and (one-person ticket only) the other six field types directly. **Salvage from the closed branch `fix/payroll-correction-page-ui` (PR #699) — read each with `git show fix/payroll-correction-page-ui:<path>`:** `apps/api/src/usecase/payroll-pricing/payroll-week-pricing.service.ts` (net-new on `main`, 783 lines added — `priceEmployeeWeekBeforeAfter(params)`), `apps/api/src/usecase/payroll-pricing/pay-week-bounds.ts` (net-new, 82 lines — `payrollDateOf`, `payWeekBounds`), `apps/api/src/usecase/payroll-send-backs/week-move.ts` (net-new, 61 lines — `payWeekOf`, `findWeekMove`, `weekMoveWarning`, `weekMoveRefusal`; does **not** itself reference `TICKET_PRICED_IN_OTHER_PERIOD`/`latestRunId` — those live in `payroll-ingest.ts:147`, `payroll-week-pricing.service.ts:89`, `payroll.service.ts:139` (drifted, re-grep per *Findings* #3), `payroll-issue-severity.ts:87`, `payroll-send-backs.repository.ts:618` — wire the settled-week refusal through all of those, not just `week-move.ts` itself). **Access change on salvage:** `apps/api/src/usecase/payroll-send-backs/plan-correction.ts` (confirmed **live on `main` today**, 353 lines — its own-window branch is at **lines 176–203**, not 266–296 as `spec-u6-u13.md`'s own citation states, see *Findings* #1) — reuse or fork its own-window logic for this new payroll-fix caller (`NOT SPECIFIED` which, per §11a row 5 — flag, don't decide); the crew-wide checks it also touches — `correction-rules.ts`'s milestone/gap/order checks stay; the separate whole-crew `findSettledCrewPay` check (confirmed defined at `apps/api/src/service/payroll-send-backs/payroll-send-backs.repository.ts:540`, **not** `:678`, called from `payroll-send-backs.service.ts:542`, see *Findings* #2) — **dropped** for this new per-person path, kept unchanged for the existing crane-supervisor-gated feature until U9 removes it. `apps/web/src/features/payroll-corrections/lib/{correction-ripple,correction-time-rows,correction-work-dates}.ts` (PR #699-only, confirmed absent from `main` today, 277/148/121 lines — confirmed none references `crane-supervisor`) brought over as-is. `apps/web/src/features/payroll-corrections/components/correction-preview-card.tsx` (PR #699-only, 159 lines) — the before/after preview UI, reused for REQ-21's screen. **Not brought over** (present in the closed branch but not cited by any REQ-18–21/33 source, and part of the second, unrelated multi-day-entry feature bundled in the same branch, per *Findings* #4): `payroll-ingest.ts`, `payroll-periods.service.ts`, `payroll-pricing.module.ts`, `week-pricing-override.ts`, and every `payroll-employee-table.{split,nested,primitives,row,dates}.tsx`/`payroll-entry-split.ts`/`payroll-date-rows.ts` file. `apps/api/src/usecase/ticket-labor-entries/compute-labor-hours.ts` (existing, live) becomes a re-export from the relocated shared util (below) rather than holding its own copy. `apps/api/src/usecase/payroll/payroll.service.ts`'s private `assertNoRecalculationHold` (confirmed today at line 644, drifted from `spec-u6-u13.md`'s cited 627 — see *Findings* #3) extended to also read open `PayrollEntryFix` rows, alongside its existing `PayrollSendBack` read, at its four call sites (`approveEmployee`/`approvePeriod`/two export-adjacent paths, now around 865–1173, re-grep). `apps/api/src/usecase/me/me.service.ts`'s `sumLaborHours` (confirmed today at :74-88, doc comment :67-72, call sites :240,276 — independently re-verified, exact match) gains an `ownWindow` parameter, reusing `computeTicketTimeTotals`'s own precedence rather than a second formula. `apps/api/src/service/me/me.repository.ts` (`MeTicketTimeEntryRow`, `MeShiftTicketRow`, confirmed today at :7,38,158,188, exact match) extended to also read `ticket_employees.workStartedAt`/`workEndedAt` for the signed-in employee. | No notification exists for a payroll fix in any REQ-18–21/33 source — the affected worker only learns of it via `/me/labor` (REQ-33) or noticing the ticket's own captured times changed; `NOT SPECIFIED` whether one should exist, none built here. |
| Shared (`packages/shared`) | `packages/shared/src/utils/ticket-time-totals.ts` (net-new to `packages/shared`, 338 lines, salvaged) — `computeTicketTimeTotals(rows, ownWindow?)`, `computeLaborHours`; `packages/shared/src/utils/index.ts` exports it. | |
| Web (`apps/web`) | New route `/payroll/[employeeId]/entries/[ticketId]`, feature folder `apps/web/src/features/payroll/entry-fix/`, built from the **existing, live** `features/payroll-corrections` components (`correction-form`, `correction-times-section`, `build-correction-payload`, all confirmed present on `main` today) repointed at REQ-19's new endpoints, plus the salvaged `correction-preview-card.tsx`. A "Fix entry" action in `payroll-employee-table.expanded.tsx` (confirmed exists) and on each U5/U6/U7 flag row — the latter has nothing to hook into if U8 ships before U7 (this file's own order has U7 before U8, so the flag-row link is buildable by the time U8 lands; confirm at build time regardless). Fixes appear in `/payroll/audit` — existence of that screen **not independently verified in this pass**, flag for the executor. `payroll-recalculation-hold-banner.tsx`/`payroll-recalculation-hold.helpers.ts` (both confirmed existing today) extended to also key off an open `PayrollEntryFix`. `correction-form.tsx`'s `can('crane-supervisor','edit')` (confirmed today at **line 44**, not 55 as `spec-u6-u13.md`'s own citation states — minor drift) repointed to `payroll-admin` **only in whatever copy/fork this unit's own entry-fix feature makes** — the existing correction screen's own instance stays untouched, gated `crane-supervisor`, until U9 removes it entirely; if the executor shares the component in place instead of forking, this repoint touches the live screen too — same "shared vs forked" question as the service layer, flag, don't decide. New `data-testid`s throughout. | |
| Mobile (`apps/mobile`) | None. | `N/A` — REQ-33's mobile consumers (`apps/mobile/app/(field)/menu/labor.tsx`, `my-labor.contract.ts`, `{labor,performance}.http.ts`) are unchanged readers — the response's computed value changes, not its shape, so no mobile edit is needed. |
| Tests | **Unit (API):** a fix creates an own window when none exists, edits it thereafter, leaves the shared `WORK_TIME` row untouched, on a crew **and** a one-person ticket; a fix to a non-Start-Work/End-Job field on a multi-person ticket is refused; the same field on a one-person ticket succeeds; nothing this unit writes changes `WORK_AT_JOB_SITE_TIME`-derived billing figures. **Integration (API):** a fix newer than the latest completed run holds the week; the next completed Calculate clears the hold; the preview's before/after matches a full recalculation's resulting figures (per §10); a fix moving `WORK_TIME` start across a Saturday 00:00 boundary prices in the period open at fix time, not the period the corrected start falls in. **Unit (API, REQ-33):** an employee with a fix sees `hrsWeek`/the ticket's `shifts` row reflect the own window; an employee with none sees unchanged figures. **Web:** the entry-fix route lets a Payroll Admin/Manager open, edit, preview and submit with a required note; the recalculation-hold banner shows while a fix is newer than the latest completed run. | New API spec files under `apps/api/src/usecase/payroll-entry-fixes/`. New web `.test.mjs` files added to the explicit whitelist in `apps/web/package.json`'s `test` script. |

**Gates:** eslint on every new/changed file listed above, per app; api typecheck via
`pnpm nx run @tcg/api:build`; web typecheck via `pnpm nx run @tcg/web:typecheck`; tests via
the new `payroll-entry-fixes` spec files, `me.service.spec.ts`'s new cases, and the new web
`.test.mjs` files (after whitelisting).

### Reviewable as

- **Demo:** open a crew ticket's Start Work for one employee via the new fix screen →
  preview shows before/after → submit with a note → that employee's TCG-25 own window is
  set, the shared `WORK_TIME` row is untouched → the week shows the recalculation-hold
  banner → `GET /me/labor` for that employee shows the corrected hours → run Calculate →
  the hold clears.
- **Acceptance:** REQ-18–21, REQ-33's Acceptance lines in `spec-u6-u13.md` §2.
- **Reviewer can verify without:** U6, U7, U9–U13; **not** without U1.

### Risk

- **Weakest source:** `[UNVERIFIED]` across all five. REQ-19's "individual" mandate is
  Corrina's own verified word (clause 3) — the strongest single source in this unit — but
  the own-window mechanism it is built on, the one-person-ticket answer, and the
  no-billing-effect answer (all Q20) are developer reference-status. **REQ-20's C9
  ("current open week" pricing rule) is explicitly `pending` Brian Petros/Corrina
  ratification, not merely unconfirmed reference-status like the rest** — a pay-rule
  content decision on a live pricing path. Though `week-move.ts` sits outside
  `packages/payroll-engine` and so is not literally covered by `.ai/claude/contexts/
  payroll-engine.md`'s same-commit-provenance rule, the underlying concern — an unconfirmed
  rule about to price real pay differently — is the same one that rule exists for.
- **Migration reversible:** yes — one new table, no drops, no backfill.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by the migration; the fix action writes to
  `ticket_employees` only when explicitly submitted.
- **Blast radius:** every existing tenant's Approve/Export flow gains a new hold source the
  moment this ships — narrower than U5/U6/U7's, since nothing holds until someone actually
  uses the fix feature.

`[UNVERIFIED]` + reversible migration — routine for the schema itself. Three things still
want a name before this reaches a real tenant:

1. **C9's "current open week" rule is pending ratification on a live pricing path** — same
   standing as `spec.md`'s own U2 gap (REQ-04's cumulative WTL extension); recommend the
   same provenance-row discipline even though the mechanism lives outside
   `packages/payroll-engine`.
2. **`plan-correction.ts`'s shared-vs-forked question** (§11a row 5) is unresolved by any
   source — flag for the executor, don't decide.
3. **No notification exists for a payroll fix** — the worker learns of it only via
   `/me/labor` or noticing the ticket changed; `NOT SPECIFIED`, not built here.

### Ripple

| Existing consumer | Reached via | Regression proof in this unit | Source |
| --- | --- | --- | --- |
| `assertNoRecalculationHold`/`countBlockingByEmployee` (existing, `PayrollSendBack`-scoped) | generalised to also read `PayrollEntryFix` | this unit's own integration test re-runs the existing send-back-hold case alongside a new fix-hold case, asserting both work independently | `spec-u6-u13.md` §11a row 4 |
| `plan-correction.ts`'s shared-`WORK_TIME`-move path (existing, live) | replaced for this new caller only | the existing correction feature's own tests (`plan-correction.spec.ts`, live on `main`) pass unmodified | §11a row 5 |
| `correction-rules.ts`'s whole-crew checks (existing, live) | dropped for the new per-person path only | existing `correction-rules.spec.ts` passes unmodified | §11a row 6 |
| `compute-labor-hours.ts` (existing, live) | re-exports from the relocated shared util | every existing caller keeps the same name/result, confirmed by grep before/after | §11a row 7 |
| `features/payroll-corrections` form components (existing, live) | reused, not modified, as this unit's base | none needed if forked; if shared in place, the executor must add a regression test for the existing screen (flag, don't decide which) | §11a row 8 |
| `me.service.ts`'s `sumLaborHours` (existing, live, read by mobile's `menu/labor.tsx` and in-flow labor/review steps) | own-window precedence added | this unit's own REQ-33 test explicitly asserts the no-own-window case is unchanged | §11a row 22 |

### Deliberately not in this unit

- **Any UI hook beyond the timesheet-row "Fix entry" action** if U7's own flag-row surface
  is not yet reachable when this unit builds (this file's order avoids that, but confirm).
- **Retiring the crane-supervisor-gated correction screen** — U9's job; both coexist after
  U8 ships, same pattern `spec.md`'s own U5/Send-Back coexistence already established.
- **A per-person override mechanism for the six non-Start-Work/End-Job field types on a
  crew ticket** — U19, out of scope, named in REQ-19's own Statement.
- **Any notification on a payroll fix** — no source asks for one.
- **Unifying `PayrollEntryFix`/`TicketTimeAdjustment`/`PayrollFlagEvent` into one audit
  feed** — flagged in `spec-u6-u13.md` §11/§13, not decided, not this unit's job.

---

## U9 — Retire the Crane Supervisor routing

- **Outcome:** The `crane-supervisor` permission, its seeded `OPS-CS` role, its API surface
  (`GET /v1/payroll/supervisors`, `PayrollCorrectionsController`, `findSupervisor`/
  `searchSupervisors`), and every open `SENT_BACK` row are retired.
  `PayrollSendBack.sentToEmployeeId` becomes nullable (U11 reuses the table with a
  different shape); `PayrollSendBackStatus` gains `WITHDRAWN`; every currently-`SENT_BACK`
  row is migrated to `WITHDRAWN` with a retirement note. On web, the `/payroll-corrections`
  routes and the `features/payroll-corrections` tree (except what U8 already salvaged) are
  removed, along with the "Returned Entries" sidebar item; any in-flight
  `PAYROLL_SEND_BACK` notification re-routes to `/payroll/[employeeId]`.
- **Kind:** vertical
- **Requirements covered:** REQ-22, REQ-23 — fully.
- **Depends on:** U8 (whatever REQ-19/20/21 already salvaged out of the code this unit is
  about to delete must be safely out first, or U9 deletes code U8 still needs).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `PayrollSendBack.sentToEmployeeId String @db.Uuid` → `String? @db.Uuid` (nullable); `PayrollSendBackStatus` gains `WITHDRAWN`. Migration `apps/api/prisma/migrations/20261001110000_retire_crane_supervisor_routing/migration.sql` — **not purely additive**: every row with `status: SENT_BACK` is `UPDATE`d to `WITHDRAWN`, with `correctionNote` (the existing free-text field — no new note column is specified) set to the literal retirement note. `NOT SPECIFIED` whether `CORRECTED` rows are also touched — REQ-22's own Acceptance names `SENT_BACK` only; leave `CORRECTED` rows as historical, unchanged. | **This is the one migration in U6–U13 that both alters a column's nullability and backfills data** — flag for extra `tcg-prisma-guardian`-style scrutiny; every other migration in this file is purely additive. |
| API (`apps/api`) | Remove `apps/api/src/presentation/payroll-corrections/{index.ts,payroll-corrections.controller.ts,dto/}` entirely (confirmed live today). Remove `GET /v1/payroll/supervisors`, `findSupervisor`/`searchSupervisors` (on `payroll.controller.ts` — re-grep the current line, U1–U8's own edits will have shifted it). `packages/shared/src/constants/permissions.ts`: remove `'crane-supervisor'` from `PERMISSION_MODULES` and `USER_RESTRICTED_MODULES`. `apps/api/src/utility/seed-data.ts`: remove the `OPS-CS` role block (confirmed today at :1120-1126, near-exact match) and its comment (confirmed at :233-240 — **do not** remove the adjacent `'payroll-admin'` clause U1 added at the same line, only the `'crane-supervisor'` one). `notification-catalog.ts`: remove `'payroll.entry_sent_back'`/`'payroll.entry_corrected'` (confirmed today at :415,429, exact match). `packages/shared/src/types/notification.types.ts`: remove the same two from `NOTIFICATION_TYPES` (confirmed today at lines 43-44 — U3 already appended `'payroll.ticket_voided'` right after them at line 45, uncommitted; removing 43-44 while U11/U12 later append their own new types needs a careful rebase, flag for the executor). `payroll-send-backs.service.ts`'s `sendBack()` (confirmed today at :143) needs **no** change yet — U9 touches schema/permission/routing only; U11 rewrites `sendBack()`'s own logic. | |
| Shared (`packages/shared`) | `PERMISSION_MODULES`/`USER_RESTRICTED_MODULES` lose `crane-supervisor` (above). | |
| Web (`apps/web`) | Delete `apps/web/src/app/(protected)/payroll-corrections/{page.tsx,[id]/page.tsx}` (confirmed live today), **redirecting** to `/payroll` (a Next.js redirect, not a 404 — deliberately different from the API side's own hard-404 removal, per both requirements' own separate Acceptance wording). Delete `apps/web/src/features/payroll-corrections/{hooks/use-payroll-corrections.ts, lib/build-correction-payload.ts, lib/correction-times.ts, components/returned-entries-list.tsx, components/correction-times-section.tsx, components/correction-times-fields.tsx, components/correction-form.tsx, components/correction-form.parts.tsx, components/correction-review-panels.tsx}` and `apps/web/src/hooks/use-payroll-corrections-summary.ts` (confirmed this summary hook lives at `hooks/`, not under `features/payroll-corrections/` — correcting the plan's assumed path) — **except** whatever U8 forked out for its own entry-fix feature; if U8 shared these files in place instead of forking, U9 cannot simply delete them — a real sequencing dependency, confirm at build time. Remove the "Returned Entries" `SidebarItem` (confirmed today at `sidebar-nav-items.tsx:227-235`, gated on `corrections?.isSupervisor`, and its `usePayrollCorrectionsSummary()` call at :91 — both exact matches). `notification-navigation.ts`'s `PAYROLL_SEND_BACK` case (confirmed today at :76-77, `` `/payroll-corrections/${id}` ``, exact match) retargets to `/payroll/[employeeId]` — confirm the notification's data payload actually carries an `employeeId`, or extend it, at build time. | |
| Mobile (`apps/mobile`) | None. | `N/A`. |
| Tests | **Integration (API):** after migration, no seeded role holds `crane-supervisor` (iterate every seeded role); `GET /v1/payroll/supervisors` and `POST /v1/payroll-corrections/*` return 404; every pre-existing `SENT_BACK` row is now `WITHDRAWN` with the retirement note; `payroll.entry_sent_back`/`payroll.entry_corrected` no longer dispatch. **Web:** sidebar shows no "Returned Entries" item for any role; `/payroll-corrections` redirects to `/payroll`; build/typecheck are the real proof no removed-but-still-imported component breaks anything (a real risk given U8 may still import from the same tree). **qa-automation:** `grep -rn '<removed-testid>' qa-automation/e2e` for every `data-testid` this unit removes — independently re-run: **confirmed empty today**, no `qa-automation/e2e` reference to `payroll-corrections`, `crane-supervisor`, or any `correction-*` test id — re-run the same grep at build time in case a spec was added in the meantime. | |

**Gates:** eslint on every changed file above; api typecheck via
`pnpm nx run @tcg/api:build`; web typecheck via `pnpm nx run @tcg/web:typecheck`; tests via
the new integration/web specs plus the qa-automation grep (not a test run, since
`qa-automation` is outside the workspace and not Nx-linted).

### Reviewable as

- **Demo:** `GET /v1/payroll/supervisors` as any role → 404. A pre-existing `SENT_BACK` row
  → now `WITHDRAWN` with the retirement note. `/payroll-corrections` → redirected to
  `/payroll`. No seeded role holds `crane-supervisor`.
- **Acceptance:** REQ-22/23's Acceptance lines in `spec-u6-u13.md` §2.
- **Reviewer can verify without:** U6, U7, U10, U12, U13; **not** without U8.

### Risk

- **Weakest source:** `[UNVERIFIED]` — the routing-overrule decision and the flag-list's
  "Build impact" note are `[VERIFIED]` (Corrina's own words), but the instruction to
  actually **remove** the code, versus merely stop routing to it, is this ticket's own
  inference, per REQ-22's own Sources framing.
- **Migration reversible:** **no clean rollback for the `SENT_BACK`→`WITHDRAWN` backfill**
  — the original status is lost once overwritten, unlike every other migration in U6–U13,
  which are purely additive.
- **Behind a flag:** no.
- **Touches existing data:** yes — every existing `SENT_BACK` row is rewritten.
- **Blast radius:** any tenant with an `OPEN` `SENT_BACK` row today loses that row's live
  hold the moment this ships, with **no replacement mechanism yet in place** — U11 hasn't
  shipped. `NOT SPECIFIED` by any source how large this gap should be at real deploy time;
  flag for whoever schedules it to minimize the window between U9's and U11's migrations.

`[UNVERIFIED]` + a **non-reversible data migration** — the one migration in this file that
most deserves a pre-build raise, not because a client hasn't spoken on the routing itself
(she has), but because the removal instruction and the exact backfill mechanics are this
ticket's own reading, and losing the original `SENT_BACK`/`CORRECTED` distinction on a
backfilled row cannot be undone. Confirm the retirement note text and the backfill's exact
scope before running this against real tenant data.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| `crane-supervisor` permission, `OPS-CS` role (existing, live) | removed entirely | this unit's own integration test iterates every seeded role | §11a row 9 |
| `/payroll-corrections` route + sidebar entry (existing, live) | removed | this unit's own web test | §11a row 10 |
| `payroll.entry_sent_back`/`entry_corrected` templates (existing, live) | removed, replaced by U11's own two types | this unit's own integration test asserts the old types no longer dispatch; U11 proves the new ones do | §11a row 11 |

### Deliberately not in this unit

- **Building U11's crew-wide Send Back replacement** — U11's own job; U9 only clears the
  ground.
- **Touching `CORRECTED`-status `PayrollSendBack` rows** — REQ-22's Acceptance names
  `SENT_BACK` only.
- **Anything under the multi-day-entry-per-date-row feature bundled in the same closed PR
  #699 branch** — unrelated, never built on `main`, not this ticket's to retire.

---

## U10 — Payroll completes a never-completed ticket

- **Outcome:** `POST /v1/payroll/periods/:id/tickets/:ticketId/complete {times, note}`,
  gated `payroll-admin`, lets a Payroll Admin/Manager enter a never-completed ticket's
  missing `WORK_TIME` start/end (yard/site optional) and mark it `COMPLETE` with
  `payrollClosedAction: COMPLETED` — U3's own pre-included enum member, confirmed already
  on disk today (uncommitted). The action bypasses `TICKET_STEPS_MISSING`, records that it
  did, writes a status-log entry, and notifies the crew. On mobile, a payroll-completed
  ticket shows "Completed by payroll" instead of inventing "Signed by `<name>`"
  placeholders.
- **Kind:** vertical
- **Requirements covered:** REQ-24 — fully.
- **Depends on:** U3 (the `PayrollTicketClosure` enum and the four `payrollClosed*` columns
  on `JobTicket` — confirmed on disk today via U3's own uncommitted work, migration
  `20260930190000_payroll_ticket_void`, **must actually merge** before this unit starts —
  this is a real, not merely formal, blocker) and U8 (REQ-24's own Notes suggest modelling
  this action's audit trail as a `PayrollEntryFix` row rather than a second path — "build
  whichever keeps one audit trail rather than two" — making U8 a real dependency if the
  executor takes that reading; if the executor instead builds a standalone trail, U10 would
  not strictly need U8 — the spec leaves this choice open, this file follows the task's own
  stated `U10 needs U3 and U8`).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | None — reuses `PayrollTicketClosure.COMPLETED` and `JobTicket.payrollClosedAction/At/ByUserId/CloseNote`, all four already present on the branch (confirmed, *Findings* #5). If the executor models this as a `PayrollEntryFix` row instead of a standalone trail, no additional schema is needed either — `PayrollEntryFix` (U8) is already generic enough (`jobTicketId` + `employeeId` + `changes` + `note`). | Confirm U3 has actually merged before this unit starts. |
| API (`apps/api`) | New `completeTicket(periodId, ticketId, times, note, userId)` — refuse any ticket not in `{PENDING, SENT, IN_PROGRESS}`, matching `spec.md` REQ-06's Q6 resolution that `REJECTED` needs void, not completion. **Reuse U3's own narrower status constant** (`units.md` U3 Slice contents: "do not reuse `WEEK_OVERLAY_TICKET_STATUSES` verbatim... define a distinct, narrower constant") — do not define a third copy. Sets `status: COMPLETE`, `payrollClosedAction: COMPLETED`, the other three columns, writes the given `WORK_TIME` start/end (and yard/site if given) via the existing ticket-time-entries write path. Bypasses `TICKET_STEPS_MISSING` and records that it did — `NOT SPECIFIED` exactly how "records" (a boolean, a note, folding into `payrollCloseNote`); flag. Writes a `JobTicketActivityLogger` `STATUS_CHANGED` entry, following U3's own exact convention — no new `ActivityLogEntityType`/`ActivityLogAction` needed, same reasoning U3 already established. Dispatches a new notification to the ticket's crew — `NOT SPECIFIED` exact type name; propose `payroll.ticket_completed`, mirroring U3's `payroll.ticket_voided` naming exactly (`IN_APP`+`EMAIL`, same recipient path) — a proposed name, not a decision. | |
| Shared (`packages/shared`) | `NOTIFICATION_TYPES` gains the new crew-notification type (name `NOT SPECIFIED`, proposed above). | |
| Web (`apps/web`) | `NOT SPECIFIED` beyond "payroll can trigger this action" — unlike U3's void action, REQ-24 never names a web component or file. Build a Complete action alongside U3's own Void action, on the same surface U4 already built (`PayrollIncompleteBanner`/`payroll-employee-daily.tsx`, per `units.md`'s own U3/U4 pattern) — the natural reading, flagged as an inference since no source names it directly. | |
| Mobile (`apps/mobile`) | `ticket-flow.store.ts`'s `openTicket` (confirmed today at :468,472,476, near-exact match to `spec-u6-u13.md`'s own citation) — exempt `sig1`/`sig2`/`compliance` invention for a `payrollClosedAction: COMPLETED` ticket; show "Completed by payroll" instead. `NOT SPECIFIED` exact copy/placement. | |
| Tests | **Integration (API):** complete refuses a `REJECTED` or already-`COMPLETE` ticket (matching `spec.md` REQ-06's Q6 resolution, per `spec-u6-u13.md` §10's own test row); succeeds on `PENDING`/`SENT`/`IN_PROGRESS`; on success the ticket is `COMPLETE` with `payrollClosedAction: COMPLETED` and the missing times set; a status-log entry exists; no billing/invoicing/dispatch call occurs (assert the mock is never invoked, mirroring U3's own no-billing-effect test); the crew is notified. **Mobile:** a payroll-completed ticket's `openTicket` does not invent signature placeholders and shows "Completed by payroll" — confirm at build time whether a same-day-dashboard-partition question applies here too, the way `units.md`'s own *Findings* #2 caught for U3's void (not independently checked in this pass, flag for the executor). | |

**Gates:** eslint on the new API/web/mobile files above; api typecheck via
`pnpm nx run @tcg/api:build`; web typecheck via `pnpm nx run @tcg/web:typecheck`; mobile
typecheck via `pnpm nx run @tcg/mobile:typecheck`; tests via the new integration spec plus
the new mobile test case.

### Reviewable as

- **Demo:** `POST .../complete {times, note}` on a `PENDING` ticket as a `payroll-admin`
  holder → 200, ticket `COMPLETE`, `payrollClosedAction: COMPLETED`. Same call on a
  `REJECTED` ticket → refused. Mobile view of that ticket → "Completed by payroll," no
  invented signatures.
- **Acceptance:** REQ-24's Acceptance lines in `spec-u6-u13.md` §2.
- **Reviewer can verify without:** U6, U7, U9, U11–U13; **not** without U3, and, depending
  on the audit-trail choice, possibly not without U8.

### Risk

- **Weakest source:** `[UNVERIFIED]` — the escape-path's existence is verified (the same
  incomplete-tickets decision note names it); who may complete it and the no-billing/
  dispatch answer are both developer reference-status, explicitly "nobody has asked either
  of them" per the note's own words — the identical caveat U3's void already shipped with.
- **Migration reversible:** N/A if no new schema (the likely path); yes if the executor
  adds any.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by any migration; the action writes to
  existing `JobTicket` rows only when explicitly triggered, same as U3.
- **Blast radius:** same shape as U3's void — silent to billing/dispatch by design, and
  nobody there has been told this action exists either.

`[UNVERIFIED]` + reversible/no migration — routine. One thing worth naming: billing/
dispatch have never been asked whether either voiding **or** completing a ticket matters to
them (Q22 reconfirms Q5's gap, not a new one) — a single `tcg-scrum` follow-up closes both
at once.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| `ticket-flow.store.ts`'s "Signed by `<name>`" invention | exempted for a payroll-completed ticket only | this unit's own mobile test; every other ticket's logic unchanged | §11a row 12 |
| `spec.md` REQ-06's void action / `PayrollTicketClosure` enum | unchanged, extended | this unit's own integration test does not touch `VOIDED`'s own behaviour; U3's existing void tests re-run unmodified | §11a row 13 |

### Deliberately not in this unit

- **Any billing/invoicing/dispatch integration** — Q22, explicitly none.
- **A web UI beyond reusing U3/U4's existing incomplete-ticket surface** — inferred, not
  specified, flagged.
- **Unifying this action's audit trail with `PayrollEntryFix`** if the executor chooses the
  standalone path instead — either is buildable, REQ-24's own Notes leave it open.

---

## U11 — Crew-wide Send Back: schema, API core, field visibility+respond, mobile, web dialog

- **Outcome:** Sending back one crew member's entry on a shared ticket returns and holds
  **every** roster member's week — the developer's Q23 answer, pending Corrina's
  ratification, not her own verified rule (which names only "the worker," singular, never
  asked about a multi-person ticket). `PayrollSendBack` gains a `returnGroupId`,
  `RESPONDED` status, `responseNote`/`respondedAt`/`respondedByUserId`.
  `countBlockingByEmployee` (already generalized once by U8) counts by `returnGroupId`
  membership too. Close/withdraw release the whole group's hold. `GET /v1/field/tickets`
  carries an additive `sendBack` summary per ticket; a new `GET /v1/field/tickets/:id`
  exists; a `'returned'` filter is added; any returned member can `POST .../respond
  {note}`. Payroll-admin holders are notified on a reply; every affected member is notified
  `payroll.ticket_returned`. On mobile, a returned ticket shows a banner, a filter chip, a
  Home "Needs your attention" section, and a respond sheet — still read-only for editing
  (that's U13). On web, the Send Back dialog lists every crew member who will be returned
  and held, and chips/reply display update accordingly.
- **Kind:** vertical
- **Requirements covered:** REQ-25, REQ-26, REQ-27, REQ-28 — fully. **Why four requirements
  stay one unit:** shipping REQ-25 alone gives no way to demo that a crew-wide send-back
  does what it claims — neither the field ticket (REQ-26/27) nor a human (REQ-28) ever
  sees the second name without the other three. Same reasoning `spec.md`'s own six-
  requirement U5 used. Sized `L` honestly, not by layer.
- **Depends on:** U1 (`payroll-admin` gate) and U9 (`sentToEmployeeId` must already be
  nullable and `WITHDRAWN` must already exist before this unit's own migration runs — per
  REQ-22's own Notes: "sequence U9 before U11... confirm the `WITHDRAWN` value... is still
  present after REQ-25's own migration runs").

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `PayrollSendBack` gains `returnGroupId String? @db.Uuid`, `responseNote String? @db.Text`, `respondedAt DateTime? @db.Timestamptz()`, `respondedByUserId String? @db.Uuid`; `PayrollSendBackStatus` gains `RESPONDED`. Migration `apps/api/prisma/migrations/20261001120000_payroll_send_back_crew_wide/migration.sql` — purely additive, no backfill. | `$extends` allowlist already carries `payrollsendback` — no allowlist change needed, the table isn't new. |
| API (`apps/api`) | `payroll-send-backs.service.ts`'s `sendBack(periodId, employeeId, input, userId)` (confirmed today's signature at :143 — a genuine breaking change to the method's own contract) rewritten to `sendBack(periodId, ticketId, input, userId)`, expanding to every `ticket_employees` roster member, creating one `PayrollSendBack` row per member sharing one `returnGroupId`; refused if **any** member's week is `APPROVED` (not partially). Isolate the crew-expansion step in its own function (`expandTicketToRoster` or similar, per REQ-25's own Notes, "so a later 'no, only the targeted worker' answer is a small revert, not a rewrite"). `countBlockingByEmployee` (twice-generalized now — U8 for `PayrollEntryFix`, this unit for `returnGroupId`) extended again. New `POST /v1/payroll/send-backs/:id/close` and `.../withdraw`, both release the whole group's hold. New `GET /v1/field/tickets/:id` (confirmed absent today, only `:id/time-entries` etc. exist — independently re-verified exact match to spec). `GET /v1/field/tickets` gains additive `sendBack: {id, reason, sentAt, sentByName, status} \| null`; a `'returned'` filter. New `POST /v1/field/tickets/:id/send-back/respond {note}`, open to any returned member. `payroll.ticket_returned` (`IN_APP`+`PUSH`) to every affected member; `payroll.send_back_responded` (`IN_APP`) to payroll-admin holders on reply, routed via U1's `{permission:{module,minLevel}}` variant (confirmed live today at `recipient-resolver.service.ts:26-41`, exact match). | The `.../respond {note}` required-note rule is itself a non-blocking, `[OPEN]`, design inference (`spec-u6-u13.md` §9: "`NOT SPECIFIED` explicitly for this one field by any source; build required, since an empty reply is not a response") — carried here as a build instruction, not re-raised as a blocker. |
| Shared (`packages/shared`) | `NOTIFICATION_TYPES` gains `payroll.ticket_returned` (`IN_APP`+`PUSH`), `payroll.send_back_responded` (`IN_APP`) — additive, alongside whatever U9 removed and U3 added; confirm no merge-order collision on this same file, per U9's own note. `FieldTicketSchema` (`apps/mobile/data/contracts/ticket.contract.ts`, confirmed today has **no** `sendBack` field) gains the optional `sendBack` field. | |
| Web (`apps/web`) | The existing (still-live, currently crane-supervisor-era-shaped) Send Back dialog is extended to list every crew member the send-back will return and hold — "do not build a second dialog component from scratch," per REQ-28's own Notes. Worklist/banner chips read "Returned to crew"/"Worker responded." A member's reply is shown on the entry. New `data-testid`s. | |
| Mobile (`apps/mobile`) | `ticket.contract.ts` gains `sendBack` (above). A banner (reason, sender) on the ticket card and overview; a "Returned" `StatusPill` and filter chip (`apps/mobile/features/field-ticket/ticket-status-filter.ts`, confirmed exists today); a Home "Needs your attention" section listing returned tickets not yet responded/resubmitted; a respond sheet modelled on `apps/mobile/components/field/ticket-comments-sheet.tsx` (confirmed exists today, exact match). The ticket stays read-only in this unit — `isStepReadOnly`/`isReadOnlyTicket` (confirmed today at `ticket-step-screen.tsx:191` and `app/(field)/ticket/index.tsx:170/308`, exact matches) are **not** touched here; U13 changes them. | |
| Tests | **Integration (API):** sending back one member of a two-person ticket creates two `PayrollSendBack` rows, one `returnGroupId`, holds both weeks (per §10); approving either week alone is refused; closing/withdrawing releases both holds in one action (per §10); sending back a ticket where any member's week is already `APPROVED` is refused outright. A returned ticket's `GET /v1/field/tickets` entry carries `sendBack`; `GET .../:id` returns it regardless of pagination; `POST .../respond` succeeds for any returned member and notifies payroll-admin holders without changing any ticket time. **Mobile:** every crew member on a returned ticket sees the banner and can open the respond sheet; the Home section lists exactly the right tickets. **Web:** opening Send Back on a two-person ticket shows both names before confirming. | |

**Gates:** eslint on every changed file above, per app; api typecheck via
`pnpm nx run @tcg/api:build`; web typecheck via `pnpm nx run @tcg/web:typecheck`; mobile
typecheck via `pnpm nx run @tcg/mobile:typecheck`; tests via the new/changed API specs
(including `payroll-send-backs.service.spec.ts`'s existing suite, since `sendBack()`'s
signature changes), the new mobile tests, and the new web test, after whitelisting.

### Reviewable as

- **Demo:** send back one member's entry on a two-person ticket via the web dialog
  (showing both names) → both weeks held → each member's `GET /v1/field/tickets` shows the
  summary and a push/in-app notification → one member replies via the respond sheet →
  payroll-admin holders are notified → close the group → both holds release.
- **Acceptance:** REQ-25–28's Acceptance lines in `spec-u6-u13.md` §2.
- **Reviewer can verify without:** U6, U7, U10, U12, U13; **not** without U1, U9.

### Risk

- **Weakest source:** `[UNVERIFIED]` — the base "target is the worker" rule is
  `[VERIFIED]` (Corrina, 2026-09-30); **the central extension this unit builds — that a
  send-back on any roster member returns and holds every member — is developer
  reference-status, "pending Corrina Bustos... it needs her OK"** per the vault's own gaps
  entry, resolved only as "which design to build" (Q23), not her ratification. Largest
  unratified blast radius in this file after REQ-31/U13.
- **Migration reversible:** yes — additive columns, one new status value, no drops, no
  backfill.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by the migration; `sendBack()` itself is a
  breaking change to its own method contract — every existing caller must update in the
  same commit.
- **Blast radius:** every multi-person ticket's send-back behavior changes at once — a
  payroll admin used to sending back one name now holds every crew member's week, with no
  way to target just one.

`[UNVERIFIED]` + a non-additive behavior change on top of an unratified design — worth a
pre-build raise. The crew-expansion rule is the one thing here a reviewer should treat as
"built, not settled" — recommend `tcg-scrum` record Q23 explicitly, since it is the one
design choice in REQ-25 with the largest blast radius across every multi-person ticket.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| `sendBack` (existing, live, single-employee) | rewritten to expand to the roster; breaking change | this unit's own integration test is the only proof needed, since U9 already retired the old (only) caller | §11a row 14 |
| `NOTIFICATION_TYPES` array (existing, live) | additive, three new entries | none needed — purely additive | §11a row 15 |
| Existing (live, still crane-supervisor-era-shaped until this unit) Send Back dialog | reused, extended to crew-list framing | this unit's own web test; if Corrina's ratification later comes back "no," this reverts | §11a row 16 |

### Deliberately not in this unit

- **The 3-hour reminder cron** — U12's own job.
- **The worker's own edit-and-resubmit** — U13's own job; this unit's respond sheet is
  reply-only, no ticket-time editing.
- **Corrina Bustos's ratification of the crew-wide extension** — `tcg-scrum`/`close-ticket`
  territory, not a unit.

---

## U12 — 3-hour reminder cron + mobile push-token re-registration

- **Outcome:** A `SENT_BACK` `PayrollSendBack` row with no response gets a push reminder 3
  hours after send-back and every 3 hours thereafter until `RESPONDED`, closed, or
  `WITHDRAWN` — per row (per member), reusing the existing `@Cron`/`runWithCronGuard`/
  `NotificationReminderLog` pattern. Mobile's push-token registration re-registers on a
  changed Expo token so reminders keep arriving after a rotation.
- **Kind:** vertical
- **Requirements covered:** REQ-29 — fully. **Why this is its own unit, not folded into
  U11:** before it, a send-back sits open with no reminder ever firing — a worker could
  ignore it indefinitely. After it ships alone on top of U11, an ignored return now nudges
  every 3 hours — a demonstrable, independently reviewable behavior change with its own
  acceptance criteria (§10), touching schema+api+mobile together as one slice.
- **Depends on:** U11 (`PayrollSendBack` rows and the return-group/`RESPONDED` status must
  already exist).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `PayrollSendBack` gains `nextReminderAt DateTime? @map("next_reminder_at")`, `reminderCount Int @default(0) @map("reminder_count")`, `lastRemindedAt DateTime? @map("last_reminded_at")`. Migration `apps/api/prisma/migrations/20261001130000_payroll_send_back_reminders/migration.sql` — purely additive, no backfill. | |
| API (`apps/api`) | New `@Cron` job in `notification-scheduled-jobs.service.ts` (every 15 minutes, following the confirmed-live `ticketReminders` pattern at :208-213 exactly) selects `SENT_BACK` rows with `nextReminderAt <= now`, sends a push reminder **per row/member** (not per ticket — U11 already holds every crew member as a separate row), reschedules `nextReminderAt` 3 hours out, stops once `RESPONDED`/closed/`WITHDRAWN`. Idempotency key `payroll-send-back:<returnGroupId>:<n>` via `NotificationReminderLog` (confirmed live today, unique on `[tenantCompanyId, reminderKey]`, directly reusable). Add to `MANUAL_CRON_TRIGGER_JOBS` (confirmed live registry at :46-53) for `/dev/cron/:jobName`. | `NOT SPECIFIED` whether the very first reminder is skipped if the member already responded within the original 3-hour window — build the straightforward reading (stop the moment `RESPONDED` is set), per REQ-29's own Notes. |
| Shared (`packages/shared`) | `NOTIFICATION_TYPES` gains `payroll.ticket_reminder` (`PUSH`). New `notification-catalog.ts` entry, following the `ticketReminders` job's own template pattern. | |
| Web (`apps/web`) | None. | `N/A`. |
| Mobile (`apps/mobile`) | `apps/mobile/hooks/use-register-push-token.ts` (confirmed today, 123 lines, `useRegisterPushToken(enabled)` at line 61, no token-refresh listener today — exact match) gains a token-change listener that re-registers on rotation. | |
| Tests | **Integration (API):** a `SENT_BACK` row with no response gets a push reminder 3 hours after send-back and every 3 hours after, until `RESPONDED`/closed/`WITHDRAWN` (per §10 Acceptance); the idempotency key prevents a duplicate in the same window. **Unit (mobile):** a rotated Expo push token triggers re-registration. | |

**Gates:** eslint on the new cron job, catalog entry, and mobile hook; api typecheck via
`pnpm nx run @tcg/api:build`; mobile typecheck via `pnpm nx run @tcg/mobile:typecheck`;
tests via the new cron spec and the new mobile hook test.

### Reviewable as

- **Demo:** manually trigger the cron via `/dev/cron/<jobName>` against a 3-hour-stale
  `SENT_BACK` row → a push reminder fires, `nextReminderAt` reschedules 3 hours out; mark
  the row `RESPONDED` → the next cron run does not remind it.
- **Acceptance:** REQ-29's Acceptance line in `spec-u6-u13.md` §2.
- **Reviewer can verify without:** U6, U7, U9, U10, U13; **not** without U11.

### Risk

- **Weakest source:** `[UNVERIFIED]` — the base "3 hours" cadence is `[VERIFIED]` (matches
  Corrina's own 2026-08-04 ask); the recipient and "until they respond, uncapped" framing
  are developer reference-status (C4).
- **Migration reversible:** yes, additive.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by the migration; the cron writes only to
  existing `SENT_BACK` rows.
- **Blast radius:** every existing open send-back created after U11 ships and left
  unanswered for 3+ hours starts receiving reminders the moment this ships — routine,
  additive, no existing flow disrupted.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| `use-register-push-token.ts` (existing, live) | gains a listener | this unit's own mobile test confirms the existing on-mount registration is unchanged | §11a row 17 |
| `notification-scheduled-jobs.service.ts`'s existing `@Cron` jobs / registry (existing, live) | one more job added | none needed — purely additive | §11a row 18 |

### Deliberately not in this unit

- **The crew-wide send-back mechanism itself** — U11's job.
- **The worker's edit-and-resubmit** — U13's job.
- **Capping the reminder count** — REQ-29's own text: "until they respond," a deliberate
  absence, not a follow-up.

---

## U13 — Worker edit-and-resubmit on a returned ticket

- **Outcome:** A `COMPLETE` ticket with an open send-back becomes writable, **for the
  primary employee only**, for time steps sent with `isAdjustment` and a `reason` —
  extending `TicketTimeAdjustment`'s `requiresReason` set to also cover `startWork` and
  `review`, with a terminal-guard exemption carved into `recordTicketStep`/
  `recordStepProgress` for exactly this case. `POST /v1/field/tickets/:id/resubmit`
  (primary only) moves the ticket's rows to `RESUBMITTED` while the ticket stays
  `COMPLETE`; payroll-admin holders are notified; the affected weeks hold until the next
  completed Calculate (matching U8's REQ-18 fix-hold pattern exactly — no lightweight
  re-evaluation, per Q25). **On a returned crew ticket, the worker's edit writes that
  employee's own TCG-25 window for Start Work/End Job (individual — same mechanism U8's
  REQ-19 uses), and the ticket's ONE shared row for the other six captured types, reaching
  and holding every crew member — built to the developer's Candidate B answer (Q24),
  directly against Corrina Bustos's own verified "individual" rule. The `[CONFLICT]` tag on
  REQ-31 is kept, not cleared, by building this.** On mobile, the primary can open and edit
  every field this scope names and resubmit; a non-primary sees "Returned; `<name>` is
  correcting it"; an offline draft in flight does not silently overwrite a returned ticket
  on reconnect.
- **Kind:** vertical
- **Requirements covered:** REQ-30, REQ-31, REQ-32 — fully. **REQ-31 is `[CONFLICT]` — not
  resolved by this decomposition, and not resolved by building it.** It is built exactly as
  `spec-u6-u13.md` states (Candidate B), and the conflict note travels with it into this
  unit's own Risk section below, verbatim in substance.
- **Depends on:** U11 (the return-group/hold mechanism this unit's resubmit and
  terminal-guard exemption plug into must already exist).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `TicketTimeAdjustment` already exists — **no change needed for REQ-30 itself.** `RESUBMITTED`'s model home is `NOT SPECIFIED` by any source (REQ-30's own Notes): "a new column on `PayrollSendBack`, reusing REQ-25's group, is the most direct reading... build it there unless the executor finds a stronger existing home." If the executor takes that reading, `PayrollSendBackStatus` gains `RESUBMITTED` — a **fourth** migration touching this same table, after U9/U11/U12's three: `apps/api/prisma/migrations/20261001140000_payroll_send_back_resubmitted/migration.sql`, purely additive if so. **This is the one schema decision in U13 left to the executor** — an alternative reading (a flag on `JobTicket` itself, or `TicketTimeAdjustment` rows' own presence as the signal) might need no migration at all; confirm the model choice before writing any migration, and only create one if it is actually needed. | |
| API (`apps/api`) | `job-tickets.service.ts`'s `recordTicketStep` terminal guard (confirmed today at :764-772, still an inline array, not routed through the shared util) and `recordStepProgress`'s own, independently duplicated guard (confirmed today at :986-994, exact match) both need the **same** exemption — consolidate onto `ticket-terminal-status.util.ts`'s `assertTicketNotTerminal` (confirmed today, 17 lines, confirmed **not called by either site today**) with a new parameter, rather than leaving one exempted and one not (per REQ-30's own Notes: "would silently reintroduce the terminal refusal on whichever path the mobile edit actually calls"). Widen `requiresReason` (confirmed today at :813, `Set(['leftYard','arriveJob','leftJob','arriveYard'])`) to also include `'startWork'` and `'review'`. New `POST /v1/field/tickets/:id/resubmit`, primary-only (via `TicketEmployee.isPrimary`, confirmed today at `schema.prisma:4731`), gated by the existing field-ticket auth, not `payroll-admin` — a worker-facing route. On resubmit: rows move to `RESUBMITTED` (model TBD, see Schema row); `JobTicket.status` stays `COMPLETE`; notify payroll-admin holders (U1's recipient-spec variant); hold the affected week(s), reusing U8's REQ-18 generalized hold — a **third** read added to `assertNoRecalculationHold`/`countBlockingByEmployee` (after U8's own and U11's `returnGroupId` one), or reused directly if `RESUBMITTED` is modelled as a `PayrollSendBack`-group state U11's hold logic already covers — flag, don't decide. Does **not** re-evaluate any flag (Q25) — a flag raised on old data stays `OPEN` until the next completed Calculate. **REQ-31's field-write logic:** Start Work/End Job → the employee's own TCG-25 window, via the **same** mechanism U8's REQ-19 uses (confirm whether shared or forked — now a **third** caller of the same own-window-write logic, after payroll's own fix and whatever U8 itself chose); the other six field types (Left Yard, Arrived Site, Left Site, Arrived Yard, lunches, boom sessions, build-up, break-down) → the ticket's **one shared** `TicketTimeEntry` row, reaching and holding every crew member (consistent with U11's crew-wide hold). | |
| Shared (`packages/shared`) | None. | `N/A` — REQ-30–32's surfaces are `api`, `mobile` only (REQ-31 is `api` only). |
| Web (`apps/web`) | None. | `N/A`. |
| Mobile (`apps/mobile`) | `ticket-step-screen.tsx`'s `isStepReadOnly` (confirmed today at :191) and `app/(field)/ticket/index.tsx`'s `isReadOnlyTicket`/`computeOverviewSteps` (confirmed today at :170/:308) treat a returned ticket as editable for its primary, exactly per REQ-31's field list. `ticket-flow.store` gains a reopen action (reset `submitState`/`active`; re-read photos from the server). `background-sync.ts`'s `finalizeSubmittedTicket` (confirmed today at :201) must not auto-resubmit an `OFFLINE` draft once the server reports the ticket returned — **actively verify** the existing `COMPLETE`-status short-circuit still holds once `RESUBMITTED` exists as a status the draft-reconciliation logic must also recognise (REQ-32's own Notes flag this as "an accident that stops holding" once `RESUBMITTED` is introduced — do not assume it, test it). `ReviewBody` gains "Resubmit to payroll" with a confirm sheet. Non-primary members see "Returned; `<Oiler>` is correcting it." | |
| Tests | **Integration (API):** a non-primary's resubmit/adjust attempt is refused; the primary's succeeds with a reason (per §10); a worker's edit to Start Work/End Job writes only that employee's own window; a worker's edit to any of the other six field types writes the shared row and holds every crew member's week; resubmit does not re-evaluate any flag. **Mobile:** the primary can open and edit every field REQ-31 names, each requiring a reason, and resubmit; a non-primary sees the read-only notice; an offline draft in flight when the ticket is returned does not silently overwrite the returned state on reconnect. | |

**Gates:** eslint on every changed file above; api typecheck via
`pnpm nx run @tcg/api:build`; mobile typecheck via `pnpm nx run @tcg/mobile:typecheck`;
tests via the new API integration specs and the new mobile tests (`background-sync`'s
`RESUBMITTED`-recognition case especially — this is the one test in U13 whose absence would
let a real defect ship silently, per its own Notes).

### Reviewable as

- **Demo:** as the primary on a returned two-person ticket, edit Start Work (own window
  only — verify co-worker's pay unaffected) and Left Yard (shared row — verify co-worker's
  week now also held) → resubmit → payroll-admin holders notified, both weeks held, no flag
  auto-clears → payroll runs Calculate → the flag reconciles and the hold clears. As the
  non-primary, confirm the ticket shows read-only with the "is correcting it" notice.
- **Acceptance:** REQ-30–32's Acceptance lines in `spec-u6-u13.md` §2.
- **Reviewer can verify without:** U6, U7, U9, U10, U12; **not** without U11.

### Risk

- **Weakest source:** REQ-30's own mechanics are `[UNVERIFIED]`, developer reference-status
  throughout. **REQ-31 is `[CONFLICT]` — the weakest tag anywhere in U6–U13** — built to the
  developer's Candidate B answer, directly against Corrina Bustos's own verified
  "individual" rule, which was never asked about a worker's own edit. **The tag is kept
  verbatim, not cleared by this build** — per REQ-31's own Notes: "flag prominently in code
  review as 'built on an unratified answer, not a settled design.'"
- **Migration reversible:** yes if the executor adds the `RESUBMITTED` schema (additive);
  N/A if not.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by any migration; the write paths touch
  `TicketTimeEntry` (shared, crew-wide) and `ticket_employees` (own window) only when a
  primary explicitly submits an adjustment.
- **Blast radius:** **every existing reader of `TicketTimeEntry`** — the engine, the web
  timesheet, every crew member's mobile ticket view — now sees whichever crew member's edit
  landed last, for six of eight editable field types, the moment a worker on a returned
  ticket edits one of them. §11a row 20 itself flags the consumer surface as "not run in
  full" by the elaborator; **this decomposition did not run it either** — carried forward
  as this unit's own unfinished obligation (`grep -rln "TicketTimeEntry" apps/api/src
  apps/web/src apps/mobile` before building).

`[CONFLICT]` + a change reaching every crew member's pay on a live, high-traffic table —
**the single item in all of U6–U13 that most warrants a pre-build raise**, and the spec is
explicit this decomposition is not the place to resolve it: build it as the spec states
(Candidate B), keep the `[CONFLICT]` tag verbatim in the unit and in code review, and record
Q24's outstanding ratification need (recommend `tcg-scrum`, per REQ-31's own Sources —
"record both this Statement and the still-open ratification"). If Corrina later disagrees,
or U19 ships, this unit's shared-write path for the six field types is what changes — not
REQ-30's own mechanics or REQ-19's own-window mechanism, both of which hold either way.

### Ripple

| Existing consumer | Reached via | Regression proof | Source |
| --- | --- | --- | --- |
| `recordTicketStep`/`recordStepProgress`'s terminal guard (existing, live, every mobile ticket-step write) | exempted for one specific case | this unit's own integration test asserts every non-exempted case still refuses | §11a row 19 |
| `TicketTimeEntry`'s crew-wide storage (existing, live, read by every pricing pass, every mobile view, every existing correction) | written by this unit's mechanism, deliberately, on an unratified basis | **not independently re-verified in this pass** — `grep -rln "TicketTimeEntry" apps/api/src apps/web/src apps/mobile` was flagged, not run, by the elaborator, and not run here either; this unit's own obligation to discharge before building | §11a row 20 |
| `isStepReadOnly`/`isReadOnlyTicket` (existing, live, gates every mobile ticket-step screen) | extended with a returned-and-primary exemption | this unit's own mobile test | §11a row 21 |

### Deliberately not in this unit

- **A per-person override table for the six shared field types** — U19, out of scope;
  "the decomposer should treat U19 as REQ-31's named successor, not an independent unit,"
  per `spec-u6-u13.md` §13.
- **Re-running flags immediately on resubmit** — Q25's resolution explicitly rejects this,
  matches U8's REQ-18 pattern.
- **Corrina Bustos's ratification of Candidate B** — `tcg-scrum`/`close-ticket` territory.

---

## Sequencing

```
U5 (from units.md) ──┬──▶ U6
                      └──▶ U7

U1 ──▶ U8 ──┬──▶ U9 ──▶ U11 ──┬──▶ U12
            │                 └──▶ U13
U3 ─────────┴──▶ U10
```

- **Parallelisable:**
  - **U6 and U7** both depend only on U5 — but are **not** file-parallel the way U1/U2 were
    in `units.md`: both add detectors to the same U5-introduced detection module and the
    same `payroll-flags.ts` catalog file. Sequential commits, either order — this file's own
    order (U6 before U7) is the decomposer's choice, not a hard requirement.
  - **U9 and U10** both depend on U8 (U10 also on U3); they touch almost entirely disjoint
    files (U9: `PayrollSendBack`'s nullability + the whole crane-supervisor removal; U10:
    `JobTicket`'s already-present columns + a new complete endpoint + `ticket-flow.store.ts`)
    — **could commit in either order once U8 (and, for U10, U3) are on the branch.** U11
    needs U9 specifically, not U10, so U9 must land before U11 regardless of where U10
    falls. This file's order (U9 before U10) matches REQ numbering, not a dependency.
  - **U12 and U13** both depend only on U11 and touch disjoint files (U12:
    `PayrollSendBack`'s three reminder columns + `notification-scheduled-jobs.service.ts` +
    `use-register-push-token.ts`; U13: `job-tickets.service.ts`'s terminal guard +
    `ticket-terminal-status.util.ts` + the mobile ticket-flow/step-screen files + possibly a
    fourth `PayrollSendBack` migration) — **could commit in either order, or be developed in
    parallel, once U11 is on the branch.** If U13's executor does add the `RESUBMITTED`
    schema, sequence its migration after U12's, per the same migration-per-commit discipline
    `units.md`'s own U3/U5 note establishes.
- **Merge order constraint:** this file's five migrations (U8's new table; U9, U11, U12, and
  possibly U13, all against `PayrollSendBack`) are not freely reorderable the way several of
  `units.md`'s own U3/U5 migrations were — **U9's migration must be the first of the
  `PayrollSendBack` chain**, because it makes `sentToEmployeeId` nullable and adds
  `WITHDRAWN`, both of which U11/U12/(U13) build additive columns on top of. This is a real
  technical necessity, not just the stated order.
- **First unit to ship (within U6–U13):** recommend **U8** — it proves the per-person fix
  mechanism (schema, hold generalization, the PR #699 salvage) that U9's retirement and
  U10's completion both build on, and unblocks the longest chain in this file
  (U8→U9→U11→U12/U13). **U6 or U7 are the safe lead if U5 lands before U1/U3's own
  downstream units are ready** — they depend on nothing in this file besides U5, mirroring
  how `units.md` named U2 as its own fallback lead for U1–U5.
