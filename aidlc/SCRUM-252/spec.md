# Spec — SCRUM-252 DAS Map View

> **Backfilled 2026-09-10, after the code was written and reviewed.** This is not a pre-build
> spec and must not be read as one. The branch `scrum-252` shipped 57 files with no ticket
> folder and no `processed.log` row — it never ran the loop. The folder and this file were
> created retrospectively, at the reviewer's request, so the five product questions the work
> raised have a durable home and the three that were settled have a traceable answer.
>
> **Why it should have been path A from the start:** the only written source for this feature
> is one `status: unverified` user story, and three of its seven acceptance criteria are
> contradicted or unmet by what shipped. That is the escalation rule in `GUIDE.md` §2 firing
> — *"any path becomes Path A the moment you have to decide something nobody specified"* —
> and it fired at review time instead of at build time.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-252` — Jira unreadable at review time (`403 Tenant is restricted: suspended-payment`); vault records note the map tickets carry `description: null` |
| Path | A, backfilled — ran as C |
| Branch | `scrum-252` — does not follow `feat/SCRUM-###-…` |
| Commits | `b69d5406` (reviewed), `fbaebb9f` (current head) |
| PR | *pending* |
| Review | `my-docs/scrum-252-map-view-review.md`, 2026-09-09 — verdict *do not ship yet*: one defect, one regression, and five product questions gating merge |
| Vault state | Only source: `dispatch/daily-allocation-system.md` → *USER STORY : Live Asset Map View*, `status: unverified`, updated 2026-04-30 |
| Open questions raised | 5 in §12 plus 2 sub-questions — **all 7 resolved by decision notes**; 1 defect, fixed. Nothing left open that this ticket raised |
| Rules consulted | `contexts/api.md`, `contexts/web.md`, `contexts/prisma.md` |

## 1. What shipped

A Map View toggle on the DAS header. On, the board is replaced by a live map of every asset
allocated to a job on the selected date that is linked to a Samsara device, plus a sidebar
listing those units and a detail panel for the selected one.

| Change | Where |
| --- | --- |
| `GET /das/map/assets?date=` — the day's Samsara-linked allocations, with job, customer, site, shift times, job stage and the asset's resource set | `apps/api/src/usecase/das/das-map.service.ts`, `presentation/das/das.controller.ts` |
| Two repository queries, both tenant-scoped via the `$extends` allowlist (`jobresourceallocation` is in it — verified, not assumed) | `apps/api/src/service/das/das.repository.ts`:839, :895 |
| `snapshot(only?)` narrows the Samsara feed by **intersecting** the caller's ids with `linkedIds()`, so a filter can only narrow, never widen | `apps/api/src/service/samsara/` |
| Client-side join of allocations to the live feed on `samsaraAssetId`; one marker per unit, named after `assetCode` | `apps/web/src/features/das/map-section/hooks/use-das-map-vehicles.ts` |
| Map panel, sidebar, hover card, detail panel, empty/error/skeleton states | `apps/web/src/features/das/map-section/` |
| Job-stage badge reusing the DAS jobs board's own labels and colours | `map-section/components/das-map-job-stage-badge.tsx` |
| `dasMapKeys` invalidated by every mutation that can move a `dasStage` or an allocation, plus two socket events | across `features/das`, `features/projects/jobs` |
| The same panel mounted on the Yard Operations / Dylen dashboard | `features/dylen-dashboard/` — **no requirement asked for this**, see §12 Q4 |

**Gates at review:** build and lint pass on all four projects; api tests pass including new
specs; two pre-existing failures excluded (`@tcg/mobile` typecheck, one web settings-modal
test) — neither belongs to this branch.

## 2. Acceptance criteria — against what shipped

The seven criteria of [`daily-allocation-system.md`](../../vault/dispatch/daily-allocation-system.md)
→ *USER STORY : Live Asset Map View* (`[UNVERIFIED]`, kind: vault, updated 2026-04-30). This
is the whole written brief.

| # | Criterion | Status | Disposition |
| --- | --- | --- | --- |
| 1 | Toggle switches the **centre panel** from job list to map | **Overruled** — replaces all three panels | Decided — [`2026-09-10-das-map-replaces-the-full-das-board.md`](../../vault/decisions/2026-09-10-das-map-replaces-the-full-das-board.md) |
| 2 | Assets shown as **crane-specific icons** | **Not met** — one generic truck | Decided, deferred — [`2026-09-10-das-map-generic-asset-marker-crane-icons-deferred.md`](../../vault/decisions/2026-09-10-das-map-generic-asset-marker-crane-icons-deferred.md) |
| 3 | Hover shows asset name, assigned job, status | Met | — |
| 4 | **Clicking** an icon opens the detail sidebar | **Diverges, deliberately** — click opens the hover card; sidebar is behind a *View Details* link | Decided — [`2026-09-10-das-map-marker-click-opens-the-hover-card.md`](../../vault/decisions/2026-09-10-das-map-marker-click-opens-the-hover-card.md) |
| 5 | In-transit assets show **path and estimated arrival time** | **Not implemented** | Decided, deferred — [`2026-09-10-das-map-transit-path-and-eta-deferred.md`](../../vault/decisions/2026-09-10-das-map-transit-path-and-eta-deferred.md) |
| 6 | KPI counters remain visible in map view | N/A | DAS renders no KPI counters today; `DasSummary` is accepted as a prop and used nowhere. Pre-existing gap, not this branch's |
| 7 | Toggling off returns to the jobs list | Met | — |

Two behaviours ship that **no criterion mentions**, both now decided: the Yard Operations
mount (§12 Q4) and the job-stage badge taxonomy (§12 Q5).

## 11. The decisions this ticket made

Three, all `status: reference` — binding on implementation, open to being overruled by TCG.
Each carries its own reasoning, its counter-argument, and what it deliberately leaves open.

1. **The map replaces the full board, and stays a header toggle** —
   [`decisions/2026-09-10-das-map-replaces-the-full-das-board.md`](../../vault/decisions/2026-09-10-das-map-replaces-the-full-das-board.md).
   Knowingly overrules AC 1.
2. **One generic marker now; crane icons deferred to their own ticket** —
   [`decisions/2026-09-10-das-map-generic-asset-marker-crane-icons-deferred.md`](../../vault/decisions/2026-09-10-das-map-generic-asset-marker-crane-icons-deferred.md).
   AC 2 knowingly unmet.
3. **The map shows all nine `dasStage` values, not the Yard Ops four buckets** —
   [`decisions/2026-09-10-das-map-shows-all-nine-job-stages.md`](../../vault/decisions/2026-09-10-das-map-shows-all-nine-job-stages.md).
   Changed during the branch; fixes the map half of the cancelled-job divergence.
4. **Transit path and ETA are deferred out of this ticket** —
   [`decisions/2026-09-10-das-map-transit-path-and-eta-deferred.md`](../../vault/decisions/2026-09-10-das-map-transit-path-and-eta-deferred.md).
   AC 5 knowingly unmet. Defers the work; does not decide TCG never buys routing.
5. **The Yard Operations / Dylen dashboard keeps the Map View toggle, same panel** —
   [`decisions/2026-09-10-map-view-ships-on-the-yard-operations-dashboard.md`](../../vault/decisions/2026-09-10-map-view-ships-on-the-yard-operations-dashboard.md).
   **Made against the written record**, which specifies Dylan's dashboard without a map —
   recorded so he can be shown it and say no.
6. **No wall-display variant in this ticket** —
   [`decisions/2026-09-10-no-wall-display-variant-in-scrum-252.md`](../../vault/decisions/2026-09-10-no-wall-display-variant-in-scrum-252.md).
   A wall display is a visibility-policy question, not a layout one.
7. **Clicking a marker opens the hover card; the sidebar is one link further** —
   [`decisions/2026-09-10-das-map-marker-click-opens-the-hover-card.md`](../../vault/decisions/2026-09-10-das-map-marker-click-opens-the-hover-card.md).
   AC 4 satisfied in two steps, deliberately.

## 12. Open questions — the stop-and-ask list

Numbered to match the 2026-09-09 review's *Questions for the product owner*.

### Q1 — Does Map View replace the centre panel, or the whole board?

- **Question:** AC 1 says centre panel; the branch replaces all three.
- **Why it cannot be answered from what is written:** the criterion is the only source, it is
  `unverified`, four months old, and the same user story's AC 6 describes KPI counters that
  DAS has never rendered — so it is not a faithful record of a built screen.
- **Blocked:** nothing — shipped and reversible in one JSX file (`das-view.tsx`).
- **Owner:** Lisette Anzaldo.
- **Status:** **resolved — see [`decisions/2026-09-10-das-map-replaces-the-full-das-board.md`](../../vault/decisions/2026-09-10-das-map-replaces-the-full-das-board.md).** Full board. Confirmation from Lisette still wanted; the decision note records why it does not block.

#### Q1a — Should a wall-display / big-screen variant exist as its own route?

- **Question:** the reviewer's second half of Q1. If a wall display is wanted, is it a
  separate route (no login, auto-refresh, non-interactive) rather than a toggle?
- **Why it cannot be answered from what is written:** Brian Petros, 2026-04-09
  ([transcript](../../vault/meetings/transcripts/2026-04-09-dispatch-scheduling-figma-demo.md):79,
  :83), describes the dispatch room wall as already carrying **Samsara's own map** on a
  separate tracker, and the DAS board as *"too much information"* for a wall operators walk
  past. That is evidence the wall display is already a different product — it is not a
  decision that ours should or should not replace it.
- **Blocked:** nothing in this ticket. It is a new feature if wanted.
- **Owner:** Lisette Anzaldo, with Brian Petros.
- **Status:** **resolved — see [`decisions/2026-09-10-no-wall-display-variant-in-scrum-252.md`](../../vault/decisions/2026-09-10-no-wall-display-variant-in-scrum-252.md).** No wall-display route in this ticket. The decisive point is that a wall display is a **visibility-policy** question — who may see crew locations on a screen operators walk past — not a layout one, and that policy is unowned (`brs.md` OD-012). Whether TCG wants one at all stays open for Lisette and Brian, as a new ticket.

#### Q1b — Must clicking a marker open the detail sidebar directly?

- **Question:** AC 4 says click opens the sidebar. The branch opens a hover card carrying a
  *View Details* link; the sidebar is one further click.
- **Why it cannot be answered from what is written:** the criterion says *"opens a detail
  sidebar with full job and asset information"* and names no intermediate step. Whether the
  hover card counts as satisfying it, or as an extra click a dispatcher does not want, is a
  usability judgement nobody has made. It compounds with the open question of what the
  sidebar must contain at all ([`dispatch/gaps.md`](../../vault/dispatch/gaps.md) → *DAS map
  detail sidebar*).
- **Blocked:** the click behaviour only.
- **Owner:** Lisette Anzaldo.
- **Status:** **resolved — see [`decisions/2026-09-10-das-map-marker-click-opens-the-hover-card.md`](../../vault/decisions/2026-09-10-das-map-marker-click-opens-the-hover-card.md).** Click opens the hover card; the sidebar is one link further. AC 4 satisfied in two steps, deliberately, because the common question on this screen is identification and the rare one costs map width. **Untested counter-argument recorded there: on a touch device hover does not exist**, and nothing records whether this board is used on one.

### Q2 — Are crane-specific icons required for this ticket?

- **Question:** AC 2 requires crane-specific icons; every asset draws as one generic truck.
- **Why it cannot be answered from what is written:** the same 2026-04-02 demo that the
  criterion was written from calls the truck a placeholder in the same breath — *"For now we
  have just added the track icons"*. And the two inputs the work needs — an icon set, and a
  sub-category → icon mapping — exist nowhere.
- **Blocked:** nothing; deferred.
- **Owner:** either side. Settled by the developer.
- **Status:** **resolved — see [`decisions/2026-09-10-das-map-generic-asset-marker-crane-icons-deferred.md`](../../vault/decisions/2026-09-10-das-map-generic-asset-marker-crane-icons-deferred.md).** Generic marker ships; crane icons become their own ticket, which cannot be written until the icon families and their mapping are decided.

### Q3 — Does transit path + ETA ship in SCRUM-252, or is it deferred?

- **Question:** AC 5 — *"If an asset is in transit, its path and estimated arrival time are
  displayed"*. Neither is implemented.
- **Why it cannot be answered from what is written:** the criterion states the outcome and
  names no mechanism, and **the mechanism does not exist**. An ETA needs a destination and a
  route: Samsara reports where a vehicle *is*, not where it is *going*, so an arrival time
  requires (a) the job site's coordinates — `jobSite` is carried as a **name string** on the
  map payload, not a lat/lng — and (b) a routing service, which would be a new external
  dependency, a new key and a new cost. None of that is in this ticket or in any source.
  A straight-line-distance approximation would be worse than nothing, because a dispatcher
  would act on it.
- **Blocked:** AC 5 only. Everything else on the map is independent of it.
- **Candidates:** [`daily-allocation-system.md`](../../vault/dispatch/daily-allocation-system.md)
  → *USER STORY : Live Asset Map View* (9.6 KB, 2026-04-30) is the only written source.
  [`2026-04-02 transcript`](../../vault/meetings/transcripts/2026-04-02-dispatch-scheduling-figma-demo.md):79
  is where it was demonstrated — *"then it's going to show the path and also the information
  estimated time"* — CodingCops narrating a prototype, not a commitment. This is the DAS half
  of the larger unsourced area recorded at [`assets/gaps.md`](../../vault/assets/gaps.md) →
  *Samsara vehicle tracking — what was committed is "vehicle locations in real time"*, which
  establishes that **no named person with product authority appears anywhere in the record for
  the whole Samsara module.**
- **Owner:** Brian Petros — he owns the Samsara scope question this hangs off.
- **Workaround:** none needed. The map ships without it; the criterion is recorded here as
  knowingly unmet rather than silently missing.
- **Status:** **resolved — see [`decisions/2026-09-10-das-map-transit-path-and-eta-deferred.md`](../../vault/decisions/2026-09-10-das-map-transit-path-and-eta-deferred.md).** Deferred out of SCRUM-252; AC 5 knowingly unmet. **The decision defers the work, it does not decide TCG never buys routing** — that stays Brian's call. The note records the blocker precisely: a job site reaches the map as a **name string**, so there is no destination to route toward before the routing provider is even reached.

### Q4 — Does the map view belong on the Yard Operations / Dylen dashboard at all?

- **Question:** the branch mounts the identical `DasMapPanel` on Dylan's board. No requirement
  asks for it.
- **Why it cannot be answered from what is written:** the map user story is voiced *"As a
  Dispatch Manager"* and places the toggle *"in the DAS header"*; none of its seven criteria
  mention the yard, Dylan, or a second host surface. The only written specification of that
  dashboard — [`assets/tool-and-rigging.md`](../../vault/assets/tool-and-rigging.md) →
  *Story 5 : Dylan's Yard Dashboard*, nine criteria — **mentions no map, location or asset
  position at all**. The sole support is one Figma exchange where Brian asked what a map on
  Dylan's board would do and was told *"the same view that we are going to show Dispatch"*,
  which is a demo answer, not a commitment.
- **Blocked:** whether the Dylen map ships at all; if it does, whether it must be yard-scoped
  rather than fleet-wide.
- **Owner:** Dylan Masterson, with Brian Petros.
- **Status:** **resolved — see [`decisions/2026-09-10-map-view-ships-on-the-yard-operations-dashboard.md`](../../vault/decisions/2026-09-10-map-view-ships-on-the-yard-operations-dashboard.md).** **Yes** — the toggle ships on Dylan's board, and it is the same panel, on the ground that the two screens are one workflow driven by the same sub-jobs, allocations and stages, so a yard-scoped variant would mean maintaining two answers to "where is unit 104".
  **This one is decided against the written record, and the note says so in those words.**
  `assets/tool-and-rigging.md` → *Story 5 : Dylan's Yard Dashboard* is the only specification
  of that screen and none of its nine criteria mention a map; the two user stories have
  different actors. It is recorded rather than left silent **precisely so Dylan can be shown
  it and say no** — a toggle he ignores costs nothing, a toggle nobody told him about is how a
  screen grows features its owner never wanted. Full search record stays at
  [`dispatch/gaps.md`](../../vault/dispatch/gaps.md).

### Q5 — Nine stages or four on the dispatcher's map?

- **Question:** does the DAS map show all nine `dasStage` values, or the Yard Ops four?
- **Why it cannot be answered from what is written:** the four-bucket collapse is written
  down only for Dylan, and for a stated reason — *"All of those statuses are for Dylan.
  That's in progress. He doesn't need to do anything"*
  ([2026-05-12](../../vault/meetings/transcripts/2026-05-12-loading-figma-demo.md):315) —
  that is an argument about the yard manager having no action to take, not a taxonomy. The
  DAS record says the opposite for the dispatcher's own board: *"all statuses (Open → Ticket
  Submitted)"* ([daily-allocation-system.md](../../vault/dispatch/daily-allocation-system.md):33).
- **Blocked:** the map's badge; not its markers or filters.
- **Owner:** Lisette Anzaldo.
- **Status:** **resolved for the DAS map — see [`decisions/2026-09-10-das-map-shows-all-nine-job-stages.md`](../../vault/decisions/2026-09-10-das-map-shows-all-nine-job-stages.md).** All nine, reusing the jobs board's own constants. **The Yard Operations bucket set stays open** — [`dispatch/gaps.md`](../../vault/dispatch/gaps.md) → *DAS map job status buckets* (note: that entry cites the superseded `b69d5406` implementation).

#### Q5a — Yard Operations board shows a cancelled job as "Pending Loadout" `[DEFECT]`

- **Not a product question.** `map-das-job-to-dylen-card.ts` has no `CANCELLED` case and falls
  through to `default: return 'pending-loadout'`; `DYLEN_JOB_FILTERS` has no Cancelled entry.
  So a cancelled sub-job tells the yard to load a crane that is not going out.
- Removing the map's bucketing (Q5) fixed the map, **not Dylan's board**. Whichever way the
  Yard Ops bucket question is answered, the two screens must not disagree about a cancelled
  job.
- **Fix:** add a `CANCELLED` case and a Cancelled filter to the Yard Operations board.
- **Status:** **fixed 2026-09-10.** `DylenJobDisplayStatus` and `DylenJobFilter` gain a
  `cancelled` member; the mapper maps `CANCELLED` to it; the badge reuses the DAS legend's own
  cancelled colours so the stage reads identically on the DAS jobs panel, the map and Dylan's
  board; the filter row gains a Cancelled entry and the counts a `cancelled` bucket. Two
  hardening changes went with it: `resolveJobDisplayStatus` and `resolveJobStatusLabel` check
  `cancelled` **before** they read the loadout, so leftover loadout or offload rows on a job
  cancelled mid-flight cannot relabel it as work still owed; and the mapper's `default` arm now
  returns `completed` rather than `pending-loadout`, because falling back to "the yard owes work
  on this" is what caused this defect and is the wrong default for any future `SubJobStage`.
  Gates: `@tcg/web:typecheck` passes; eslint 0 errors on all eight touched files; web tests
  252/253 — the one failure is the pre-existing `settings editor modal close animation content`.
- **What was NOT wrong, contrary to the first reading:** the loadout **actions** were already
  refused for a cancelled job — `isJobPrimaryActionDisabled` calls `isDasStageLoadoutLocked`,
  whose `LOADOUT_LOCKED_DAS_STAGES` set has always contained `CANCELLED`, mirroring the API's
  own `LOCKED_STAGES`. So Dylan could not actually have marked a cancelled job available. The
  defect was entirely in what the board **said**: the badge read *Pending Loadout*, the dead
  button read *Mark Available for Loadout*, the job was counted in the Pending Loadout filter,
  and there was no way to filter for it.
- **Note — this expands the bucket set, which is itself an open question.** Dylan's board now has
  five display statuses, not four. That is unavoidable: leaving `CANCELLED` inside
  `pending-loadout` is untenable whichever way the other four are decided, which is the
  reviewer's own position. It does **not** answer
  [`dispatch/gaps.md`](../../vault/dispatch/gaps.md) → *DAS map job status buckets*, which
  still asks whether `LOADOUT` belongs in *Pending Loadout* or *In Progress*.

## 13. What this spec deliberately does not specify

Listed once, plainly, so nobody mistakes silence for simplicity.

- **Transit path and ETA** — AC 5, deferred by decision. Blocked twice over before anyone
  reaches the routing question: a job site arrives as a **name string**, so there is no
  destination; and *"in transit to this job"* is not a state the system defines at all.
- **Crane-specific icons** — AC 2, no artwork and no mapping; deferred by decision. **A
  follow-up ticket cannot be written until the icon families and the sub-category → icon
  mapping are decided** — that, not the drawing, is the blocker.
- **KPI counters in map view** — AC 6. DAS renders none anywhere today; pre-existing.
- **A wall-display variant** — not in this ticket, by decision; whether one should exist at
  all is open, and is a visibility-policy question rather than a layout one. See Q1a.
- **Whether the Yard Operations map should be yard-scoped**, if Dylan keeps it. The toggle
  ships showing the same fleet as DAS; nobody has stated a scope for his view.
- **Touch behaviour on the map.** The click decision (Q1b) assumes a pointer. Nothing records
  whether this board is used on a touch device, where hover does not exist.
- **What the detail sidebar must contain** — [`dispatch/gaps.md`](../../vault/dispatch/gaps.md) → *DAS map detail sidebar*.
- **Whether a cancelled job is drawn on the map at all** — [`dispatch/gaps.md`](../../vault/dispatch/gaps.md) → *Cancelled sub-jobs on the DAS map*.
- **Overnight shifts on the board** — [`dispatch/gaps.md`](../../vault/dispatch/gaps.md) → *Overnight DAS shifts*.
- **Selected-marker treatment on the fleet tracking map**, changed as a side effect of this branch — [`assets/gaps.md`](../../vault/assets/gaps.md) → *Fleet tracking map*.
- **Who may see the map / GPS at all.** No permission layer exists on either map. `brs.md` **OD-012** *GPS enforcement behavior* is `❓ Decision Needed`, and nothing anywhere assigns an owner to who may see the Tracking menu. Not raised by this branch, not fixed by it.

## 14. Sign-off before merge

- [x] **Every question this ticket raised is answered** — 7 decision notes, all
      `status: reference`, all written 2026-09-10. Nothing in §12 is left open.
- [ ] **Shown to the named people.** The notes bind the code, not TCG. Each says who should
      still see it, and one is flagged as decided *against* the written record:
      - **Dylan Masterson** — Q4, the map on his dashboard. His board's own specification has
        no map in it. **This is the one to raise first.**
      - **Brian Petros** — Q3, whether TCG wants transit paths and ETAs at all.
      - **Lisette Anzaldo** — Q1 (full board), Q1a (wall display), Q1b (click behaviour), Q5
        (nine stages).
- [x] **Q5a defect fixed** — `CANCELLED` on the Yard Operations board *(2026-09-10)*
- [x] Review blocking item 2 — empty-list `reload()` now returns early on `!enabled`
      (`use-vehicles.ts`), so "Try again" can no longer send an unfiltered full-fleet request
- [x] Review item 3 — selection cue restored as a **size step** (46 → 58px) on `TruckMarker`,
      and the ring deliberately not restored, documented in place. The dead
      `ROUTE_TOKENS.selected` token and its comment describing a ring that no longer exists were
      removed from `map-settings.ts` (2026-09-10) — nothing referenced it. Whether a ring is the
      right cue at all stays open at [`assets/gaps.md`](../../vault/assets/gaps.md) →
      *Fleet tracking map — how a selected vehicle must be indicated is written nowhere*
- [x] `processed.log` row updated with the PR number — PR **522**, appended as a second
      SCRUM-252 row *(2026-09-10)*. The ledger is append-only, so the original row stands;
      the new one records the PR and corrects two things that row got wrong — it called Q3
      and Q4 still open when both have decision notes, and called the cancelled-sub-job
      defect unfixed when `3733a11e` fixed it
- [x] Overlay committed and pushed *(2026-09-10)*

Answered by: ______________  Date: ______________
