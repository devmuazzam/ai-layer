# Intent — SCRUM-LOADOUT-UNASSIGNED

Yard Operations (Dylen dashboard): a resource slot that has **no asset or employee assigned**
must not be loadable, and the job card must warn that the shift is not fully staffed before
anyone presses *Mark Available for Loadout*.

No Jira ticket exists. The folder is named `SCRUM-LOADOUT-UNASSIGNED` so the `SCRUM-*`
open-question sweep (`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md`) still finds
it — the same device as `SCRUM-PROGRESS`, `SCRUM-PENDING` and `SCRUM-TZ`.

---

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-LOADOUT-UNASSIGNED` — no Jira issue; folder name only |
| Title | Yard Operations — unassigned slots are not loadable; card warns before Mark Available |
| Type | Bug (against the July 2026 yard punch list) / Story (the card warning) |
| Status | Not tracked in Jira |
| Epic | `NOT ON TICKET` — the loadout feature itself pre-dates the AI-DLC loop and has no ticket folder; nearest Jira epics are `SCRUM-453` / `SCRUM-457` (Yard Ops, Done) |
| Sprint | `NOT ON TICKET` |
| Reporter | Syed Haris (git identity `hariscops`) — stated directly in a working session while UAT-testing `JOB-00009` |
| Assignee | `NOT ON TICKET` |
| Captured on | `2026-09-14` |
| Captured by | Claude Code session run by Syed Haris |

Requested in-session, not through Jira. Everything below is a snapshot of that request.

## 2. Business intent

The request, verbatim (two messages in one session):

> when i start loadout there's nothing allocated to it, but still i am able to loadout, what
> should be the behaviour if nothing is available and i mark available for loadout, and start
> loadout

> well for now we've same schedule for all, but when we do mark available at loadout only those
> are selected which are assigned, and on the card we should get the warning as well

What was observed on `JOB-00009` (screenshot in session): the job carries resource slots from
its quotation — one *100 Ton Hydraulic Truck Crane* set with two operator slots, an *Operator
Load Trailer* and an *AT – Tractor* — none of which DAS has allocated to. *Mark Available for
Loadout* accepted the job with no warning. *Start Loadout* opened the Phase-1 modal with every
slot rendered as an **"Unassigned"** card, every row **pre-ticked**, and the **Loadout** button
enabled. Pressing it would have recorded a crane that does not exist and two unnamed people as
having left the yard.

- Intent: the yard must not be able to "load out" a placeholder. A slot nobody has been
  assigned to is a dispatch gap, not a thing that can leave the yard; the system should say so
  on the card, and refuse to treat it as loaded.
- Who benefits (role): yard manager (Dylan) — sees at a glance which shifts dispatch has not
  finished; dispatcher — gets the gap surfaced before the truck is supposed to leave; anyone
  reading loadout history — no phantom loadouts.
- What is worse today without it: a job can reach *In Progress* / *Completed* with nothing real
  ever assigned; the loadout record and the tool In-Use counts are then built on placeholders,
  and nobody is told the shift was never staffed.

## 3. Definition of done, as the ticket states it

Quote the ticket. There is no ticket; the reporter's acceptance statement is the second message
above, plus their acceptance of a four-point behaviour proposed back to them in the same session.
Quoted as agreed:

```
when we do mark available at loadout only those are selected which are assigned,
and on the card we should get the warning as well
```

Behaviour the reporter agreed to (proposed in-session, accepted with "well for now we've same
schedule for all, but …" — i.e. per-asset leave times are explicitly *not* wanted now):

```
1. Card warning — when a shift has resource slots with no allocation, the job card (and the
   expanded shift row) shows an amber chip "<n> unassigned" with a tooltip listing the slots.
   Visible before Mark Available.
2. Mark Available — still allowed when at least one item is assigned; the confirm modal lists
   the unassigned slots under "needs review" alongside the quantity warnings. If nothing is
   assigned, the button is disabled with the same message.
3. Start Loadout modal — unassigned rows are not pre-selected. Only assigned rows are.
   If nothing selectable remains, Loadout is disabled with "Nothing assigned to load out."
4. API — complete-loadout rejects item keys whose slot has no allocation, and rejects an empty
   selection (mirror of the SCRUM-812 offload guard), so 3 holds even if the UI is bypassed.
```

- Acceptance criteria present on the ticket: no (no ticket) — the block above is the reporter's
  words plus an in-session agreement, not Jira acceptance criteria
- `OPEN — no Jira ticket; per domain/jira-sop.md it does not meet Definition of Ready. The reporter
  chose to proceed under a synthetic folder; a Jira key should be attached before merge.`

## 4. In scope

- [ ] Job card + expanded shift section: unassigned-slot count chip with tooltip, per shift
- [ ] Mark Available confirm modal: unassigned slots listed as review items
- [ ] Mark Available disabled when a shift has zero assigned assets/employees/tools
- [ ] Phase-1 (Start Loadout) modal: unassigned rows not pre-selected
- [ ] Phase-1 modal: Loadout button disabled when nothing selectable is selected (already true
      for an *empty* selection — must also hold when the only rows are unassigned)
- [ ] API `POST das/sub-jobs/:subJobId/loadout/complete-loadout`: reject unassigned item keys;
      reject empty selection
- [ ] Tests for the API guard and the web button/pre-selection rules
- [ ] `data-testid`s on the new chip and disabled states (qa-automation contract)

## 5. Out of scope

- [ ] Per-asset planned leave times ("different assets leave at different times" as a
      *schedule*) — reporter: "for now we've same schedule for all"
- [ ] Flagging items that were assigned but never loaded out before offload completed
- [ ] A "no equipment required" flag / hiding jobs with nothing to load from the yard board
      (Dylan 2026-05-12; Melissa 2026-07-01) — separate product decision
- [ ] Whether a job that never goes through the yard should auto-complete (SCRUM-903 Q3)
- [ ] Blocking the quotation from requesting more stock than exists (`assets/gaps.md` →
      *a quote may request more tools than exist*)
- [ ] Hiding the *Mark Available* button entirely for unstaffed jobs (it is disabled, not hidden)
- [ ] Any change to offload (Phase 3) behaviour
- [ ] Role gating of the loadout endpoints (currently any authenticated tenant user)

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | `das-loadout.service.ts` `completeLoadout`: reject unassigned resource item keys and empty selection; possibly `das-loadout-catalog.util.ts` to mark catalog entries assigned/unassigned |
| `apps/api/prisma` (schema + migration) | no | assignment state is derivable from existing DAS allocation rows |
| `apps/web` (Next.js — atoms → pages) | yes | `features/dylen-dashboard`: card/shift chip, confirm-modal review list, Phase-1 pre-selection (`dylen-phase-handover-modal-init.util.ts`), `canSubmit`, Mark Available disable rule |
| `apps/mobile` (Expo Router) | no | mobile has no loadout surface |
| `packages/shared` (types shared across apps) | ? | only if the loadout item DTO gains an `isAssigned` flag that web reads; check whether `DasSubJobLoadout` types live in shared or in `features/das/.../das-loadout.api.ts` |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `SubJob` / `SubJobLoadout` / `SubJobLoadoutItem` | `N/A` — no business code | reads; writes `SubJobLoadoutItem.loadoutAt` only for assigned items |
| `JobResource` (resource slots) + DAS allocation rows | `N/A` | reads — "assigned" = an allocation exists for the slot on that shift |
| `Job` | `jobCode` / `JOB-#####` | reads (display only) |

- New entity introduced by this ticket: no
- New code prefix introduced: no
- Existing rows affected (backfill / migration of data, not just schema): no — existing
  loadout rows that were recorded against unassigned slots are left as they are

## 8. Roles and permissions

- Roles that can perform this: `NOT ON TICKET` — the Yard Operations route and the loadout
  endpoints carry no role or permission gate today; this ticket does not add one
- Roles explicitly excluded: `NOT ON TICKET`
- Tenant scope: standard per-tenant isolation (`SubJobLoadout` is in the `$extends` allowlist)

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` — screenshot of the current Phase-1 modal on `JOB-00009` only |
| Jira attachments | `N/A — no ticket` |
| Related tickets | `SCRUM-812` — schedule-date / shift-end locks and the *"Nothing to offload for this shift."* guard this ticket mirrors; `SCRUM-903` — completion rollup that an empty loadout can currently trigger; `SCRUM-252` — Yard Ops bucket for `LOADOUT` (open, adjacent) |
| Existing repo docs | `.ai/vault/dispatch/yard-operations-jz.md` (2026-07-15 yard punch list, `status: unverified`): *"if assets / people are not assigned – we should not be able to loadout that particular item"*, *"Employee - unassigned – weird ghost employees"* |
| Vault area the reader thinks is relevant | `dispatch/` (yard operations, DAS allocation), `assets/tool-and-rigging.md` Story 5 — **a guess; the elaborator verifies it** |

## 10. Terms used that may not be defined

- `loadout` — used as: *"when i start loadout there's nothing allocated to it, but still i am able to loadout"* (known-undefined in the vault)
- `mark available` — used as: *"when we do mark available at loadout only those are selected which are assigned"*; the reporter uses it for the whole gate, not only the button
- `assigned` / `allocated` — used interchangeably by the reporter for "DAS has put a real asset or employee into the slot"; the codebase says *allocation* (DAS) and renders the absence as *Unassigned*
- `slot` — not a reporter term; used here for a `JobResource` row the quotation minted that an allocation may or may not fill

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| "at least one assigned item" as the threshold for allowing Mark Available | in-session proposal accepted by the reporter — `NOT ON TICKET — no origin cited` beyond that agreement |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 6 — Epic, Sprint, Assignee, Roles ×2, Design handoff
- Fields left as `OPEN`: 3 —
  1. `OPEN — In the Phase-1 modal, are unassigned rows shown greyed and unselectable, or hidden? (reporter's wording "only those are selected which are assigned" reads as shown-but-unselected; not confirmed)`
  2. `OPEN — May Dylan manually tick an unassigned row anyway (override), or is it never selectable? The July punch list says never; the reporter has not said.`
  3. `OPEN — Does a tool/rigging row count as "assigned" by existing (it has no allocation concept), or only asset/employee slots drive the warning?`
- Is this ticket, as written, buildable without a product answer? **yes, with defaults** — the
  elaborator should carry the three OPEN items into `spec.md` §12 and build to: (1) greyed,
  (2) never selectable, (3) tools always count as assigned; each default reversible in one file
- If no, the blocking questions are: none blocking; three defaults flagged above

---

**Next step:** run the elaborator (`.ai/aidlc/agents/inception/tcg-elaborator.md`) against this file.
It produces `spec.md` beside it and then stops to ask its questions. It will not implement.
