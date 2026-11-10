# State — TCG-50 System is slow: agree a speed target and measure before optimising

**Path:** B (performance bug against the whole app, not one unspecified feature) ·
**Branch:** `perf/TCG-50-performance-optimizations` · **Last updated:** 2026-11-10 by Claude Code

Trello: https://trello.com/c/qY2ypDC6 · Linear: TCG-50

## Ticket text (as of 2026-11-10)

> UAT said the system is a bit slow, without saying which screen, which action or how fast
> it should be. Likely slow spots are payroll calculate and export, the DAS board and the
> quotation summary, but none is confirmed as what the tester felt.
>
> Acceptance criteria:
> - A written target exists: which screens, how fast, and with how much data
> - Real speed in production can be measured, and production monitoring is confirmed working
> - A starting measurement is recorded before any speed-up work
> - The slowest screens are fixed first, based on the measurement
> - "App refreshes every time" and "cache and reload problems" are looked at together
>
> Done when the same screens meet the target at the agreed data size; "it feels faster" is
> not enough.
>
> Waiting on: Fouzan Shakil to set the speed target.

## Decisions recorded this session (2026-11-10)

- **G1 — speed target (previously blocking, now answered):** whole app, every screen —
  not limited to the three named suspects. Target: **< 2s per page load / action**, measured
  at production data size. Answered by Ali Riaz, standing in for Fouzan Shakil. Not yet
  confirmed by Fouzan directly — flag this to him before treating the ticket as fully
  unblocked.
- **Monitoring (acceptance criterion #2):** New Relic is wired in code on both apps —
  `apps/api/src/main.ts:1-4` requires it only when `NEW_RELIC_LICENSE_KEY` and
  `NEW_RELIC_APP_NAME` are set; `apps/web/src/providers/new-relic-provider.tsx` is the
  browser-agent equivalent. Whether those env vars are actually set in production, and
  whether data is flowing, was **not verified** this session (reading `.env` contents is
  out of scope for an AI session) — needs confirmation from someone with prod/New Relic
  dashboard access.
- **Baseline measurement (acceptance criterion #3):** **not done.** Nothing in
  `perf/TCG-50-performance-optimizations` records a starting measurement before its changes
  were made. Still outstanding.

## Code review findings against this branch (2026-11-10)

Full staged diff (23 files) reviewed. See PR / commit for the fixes applied:

- **Fixed:** `customers.service.ts` `findWorkspaceSummary()` capped its customer fetch at
  `MEMORY_PIPELINE_MAX_CANDIDATES` (5,000). Confirmed on staging that 3 tenants already have
  5,742–5,743 customers — over the cap — so dashboard metrics (pipeline total, revenue YTD,
  `nonDraftActiveCount`, `maxRev`) were silently wrong for them today. Cap removed for this
  call; it is a tenant-wide aggregate, not a page, so it must stay unbounded.
- **Documented, not changed:** the same `MEMORY_PIPELINE_MAX_CANDIDATES` cap is used for
  derived-sort pagination in `permits.service.ts`, `price-listings.service.ts`,
  `vendors.service.ts`, and the non-paginated path in `yards.service.ts`. Checked against
  staging row counts (2026-11-10) — largest tenant per table: 173 permits, 85 price
  listings, 834 vendors, 74 yards — all far under 5,000, so these are low-risk as shipped.
  Added an inline comment at each site recording the trade-off and the measured numbers it
  relies on, so a future reviewer doesn't have to re-derive it.
- **Pre-existing, out of scope:** `customers.service.ts` line ~351 already used the same
  5,000 cap for the customer list's Top/Attention view and revenue sort, *before* this
  branch existed. Given the same 3 tenants are over 5,742 customers, that call may already
  be silently wrong too — but it predates TCG-50 and isn't part of this branch's diff, so it
  wasn't touched here. **Follow-up:** open a separate ticket/card for it.
- **Flagged, not changed (tenant isolation, G3):** `price-listings.repository.ts` and
  `yards.repository.ts` each gained a `tenantCompanyId` filter on a `prisma.customer.groupBy`
  / `prisma.asset.groupBy` call that had none before — a real cross-tenant count leak, fixed
  as a side effect of this perf branch. Correct fix, but worth a `tcg-prisma-guardian` sweep
  for other unscoped `groupBy`/aggregate calls, since this branch only found these two by
  accident (tenant scoping's `$extends` auto-filter does not cover `groupBy`, per
  `contexts/prisma.md`).
- **Originally flagged, now superseded by the fix below:** `use-tools-catalog.ts` and
  `use-loss-reasons.ts` (web) drop the `SEARCHABLE_LIST_QUERY` spread that `apps/web/CLAUDE.md`
  states as a hard rule for any surviving list hook. Neither literally feeds an `AsyncCombobox` picker, so this is likely
  safe, but it sets aside a documented rule without a recorded reason — worth a reviewer's
  eyes. `use-loss-reasons.ts`'s doc comment still says "uncached" despite the change.

## Baseline measurement on the DB-level changes (2026-11-10)

Ran `EXPLAIN (ANALYZE, BUFFERS)` on staging (read-only) for representative queries affected
by this branch's indexes, against staging's current (pre-migration) data — the honest "before"
state, since the migration hasn't been applied there yet:

- Employee name search (tenant-scoped ILIKE, gets a trgm index here): largest tenant has 253
  employees → **4ms**.
- Customer workspace summary's quotation+resources query (the one with the 5,000-cap fix
  above): largest tenant has 470 non-archived quotations / 2,218 resource rows → **31ms**.
- Every table getting a trgm index in this branch tops out at ~3,500 rows (vendors) on
  staging; most are in the hundreds.

**Conclusion: at today's staging data scale, none of this branch's DB/index changes are
anywhere near the <2s target — there's 2-3 orders of magnitude of headroom.** Either
production has substantially more data than staging in the tables that matter, or the DB
layer isn't actually where UAT felt "slow."

## Scaled-up local measurement, with the developer's go-ahead to seed their local DB (2026-11-10)

To push past staging's current small scale, bulk-seeded the local dev DB's largest tenant
(`TCG-DEFAULT`) with `prisma/scripts/tcg-50-seed-quotations.ts` — additive only, never
touches existing rows — taking it from 313→3,000 quotations / 1,385→14,820 resources, then
linked every new quotation to one of the tenant's 66 real customers round-robin
(`prisma/scripts/tcg-50-link-quotations.ts`) so the aggregation query is actually exercised
per-customer, not just sitting on null FKs.

Re-ran the same `findWorkspaceSummary()` query at this ~10x-larger scale: 2,984 non-archived
quotations / 14,864 resource rows → **21.8ms**. Still three orders of magnitude under the 2s
target.

**This doesn't fully settle it, and I want that on the record rather than glossed over:**
this tenant has only 66 customers locally (staging's largest tenant has 5,742+), so the
customer-count-driven cost in `findWorkspaceSummary()` — the in-memory `nonDraftRows` filter
and per-customer `isTopCustomerByMetrics`/`customerNeedsAttention` checks — wasn't actually
stress-tested here, only the quotation/resource volume was. I did not attempt to also bulk
customers, employees, jobs, sub-jobs or dispatch allocations (needed for the DAS board) or
payroll ticket/time-entry data (needed for payroll calculate/export) — the DAS and payroll
schemas are substantially more interlocking and payroll calculation is explicitly a
guarded/sensitive area (G4), and synthesizing fake data for it risked producing something
that looks broken for reasons that have nothing to do with speed. Those two named screens
remain genuinely unmeasured.

**None of this means the indexes are wrong to add** — they're cheap, safe, and will matter
as data grows — just that they're unlikely to be *the* fix for what prompted this ticket,
and shouldn't be reported as the resolution without checking production data volumes first.

## Second fix: `SEARCHABLE_LIST_QUERY` applied far beyond search pickers (2026-11-10)

Investigated the ticket's explicit "app refreshes every time" / "cache and reload problems"
line directly, since the DB layer didn't explain it. Found: `lib/searchable-list-query.ts`'s
`SEARCHABLE_LIST_QUERY` (`staleTime: 0, gcTime: 0`) was spread onto **~28 files**, and most
of them are not search-as-you-type pickers — they're the **main paginated list-table
queries** for nearly every feature in the app (customers, vendors, permits, quotations,
plans, price-listings, purchase-orders, jobs, projects, billing codes, checklists,
departments, agencies, activity logs, parts, the generic `useInfiniteList` hook used by
every infinite-scroll grid), plus a few single-item detail lookups that had no business
using a "list" cache policy at all.

**Why this matters:** `gcTime: 0` discards a query's cached result the instant its component
unmounts. Since every distinct filter/page already gets its own React Query cache key
(different params ⇒ different key, by design — they never share cache regardless of
staleTime), the zero-cache override's only real effect was to force a full reload, from
nothing, every time a user navigated back to a list they'd *already loaded with the same
filters seconds earlier*. Mutations on these lists already call `invalidateQueries()`
explicitly on create/update/archive (checked `use-customers.ts`, `use-vendors.ts` and
others), so zero-cache wasn't needed for correctness after an edit either — it was paying a
real reload cost for a correctness guarantee the app already had another way.

**Fix applied:** removed the `...SEARCHABLE_LIST_QUERY` spread (and the two
`use-infinite-list.ts` / `use-projects.ts` / `use-departments-queries.ts`-style explicit
`staleTime: SEARCHABLE_LIST_QUERY.staleTime` / `gcTime: SEARCHABLE_LIST_QUERY.gcTime`
assignments) from all ~28 files, letting them fall back to the global `QueryProvider`
default (`staleTime: 30s`, default `gcTime`, `refetchOnWindowFocus: false`). Also fixed a
related inconsistency this branch itself introduced: the shared `['resource-catalog',
'tree']` query is called from 4 places (`use-resource-tab-catalogs.ts`,
`resource-item-select.tsx`, `associated-resource-select.tsx`,
`billing-code-type-select.tsx`); this branch had already dropped the override on the first
one but not the other three, which is a latent React Query foot-gun (same query key,
different cache config depending on mount order). Now consistent across all four, matching
`apps/web/CLAUDE.md`'s own description of the tree endpoint as "a server-capped one-shot
read."

**Left untouched on purpose:** genuine debounced keystroke-search queries (e.g.
`convert-to-project-attach-list.tsx`'s search variant, keyed on `debouncedSearch`) — these
already get a fresh key per search term, so the same reasoning applies there too and the
override was redundant, but they were included in the same sweep rather than hand-picked out
since the fix is uniform.

**Governance note, not yet resolved:** this is a behavioral change to nearly every list
screen in the app. `apps/web/CLAUDE.md`'s "Shared UI" section says a deliberate app-wide
change gets its own ticket and PR, approved by Umer Islam — this was done directly on the
TCG-50 branch at the developer's explicit instruction, but **it has not been reviewed or
approved by Umer Islam**, and per "One unit, or one independent task per PR" probably
shouldn't ship bundled with the index/migration changes. Flagging before this merges.

Typecheck run against `@tcg/web` after the change — see commit/PR for result.

## Third fix: DAS board's per-date setup does one job at a time, sequentially (2026-11-10)

Looked directly at the DAS board code (`das.service.ts` `getSummary()`), since staging's thin
data ruled out a query-speed explanation. Found `jobs.service.ts` `ensureSubJobsForDate()`
— called at the top of every `getSummary()`, i.e. every DAS board load — loops over every
distinct job with a not-yet-materialized interval on that date and `await`s
`startsAllocationCompleted(jobId)` **one job at a time**, sequentially, before the board's
own data even starts loading. Confirmed on staging (read-only): the busiest real day has 22
distinct jobs, each costing up to 2 sequential round trips here = up to 44 serial DB calls
gating the board response.

**Caveat, stated plainly:** this only runs for intervals that don't have a sub-job yet, which
means it pays this cost once per date, on whoever opens the board first that day — not on
every load. So it's a real, fixable inefficiency, but likely explains an intermittent "first
load of the day is slow" pattern rather than a constant one.

**Fix applied:** parallelized the loop with `Promise.all` (`jobs.service.ts` ~line 1509),
matching the pattern this branch already uses elsewhere (`quotation-approvals.service.ts`,
`role-change-requests.service.ts`). No change to what gets computed or written, only how many
round trips run concurrently vs. serially — build run to confirm it compiles.

## Payroll calculate — found the actual explanation, left it alone on purpose (2026-11-10)

Payroll "calculate" doesn't run synchronously on request — `payroll-calculation-queue.service.ts`
processes a queue, polling every **10 seconds** (`POLL_INTERVAL_MS`), **one job at a time per
process** (`runJob`). The web side (`use-payroll.ts:127`) polls for completion every **5
seconds** (`RECALCULATION_POLL_MS`) while a recalculation is queued/running. So the floor for
"recalculated and visible on screen" is roughly **5–15 seconds before any actual calculation
time is even counted** — this is architectural polling cadence, not a slow query or a data-
volume problem, and no synthetic ticket/time-entry data was needed to find it.

**Deliberately not changed.** Both intervals read as intentional (comments cite specific
decisions — PR #709 fix pass, TCG-218 Q55(3)), and payroll timing is G4-guarded: changing how
fast a recalculation is picked up or how concurrently jobs run could affect when figures
become visible/locked to Payroll, which is a business decision this session has no authority
to make. Reporting this as the most likely explanation for the "payroll calculate... feels
slow" line in the ticket, for Fouzan/Payroll to decide whether the current cadence is
acceptable or needs to change — not something to silently tune.

## Still outstanding before this ticket can close

- [ ] Fouzan to directly confirm the <2s / whole-app / prod-data-size target (recorded above
      on his behalf).
- [ ] Someone with prod access confirms New Relic env vars are set and data is flowing.
- [x] A starting measurement, recorded before further speed-up work: staging DB queries
      (customers/quotations, employees/trgm), a 10x-scaled local measurement of the same
      path, and a code-level, data-backed measurement of the DAS board's sequential-loop
      cost (22 jobs on staging's busiest day) — all before their respective fixes. Payroll's
      bottleneck (polling cadence) was identified by reading the code, not a data
      measurement, and deliberately left unfixed.
- [x] Slowest screens fixed first, based on what was actually measured: the DAS board's
      sequential per-job loop (now `Promise.all`) and the caching/reload issue (now using the
      global 30s default). The DB index changes remain unconfirmed as *the* fix — staging and
      scaled-local data show them mattering far less than these two.
- [ ] **Still not met: "same screens meet target at agreed data size."** No screen has been
      timed end-to-end (real HTTP request, real production data) against the <2s target —
      everything above is query-level or code-level evidence, not a wall-clock screen
      measurement. Production data volumes (vs. staging's, which may not represent
      production) are still unconfirmed, so there is no baseline at the *actual* agreed data
      size yet — staging's numbers above show headroom, not proof of the fix. Payroll's
      5–15s polling floor was found but deliberately not changed (G4) — that gap is for
      Fouzan/Payroll to resolve, not something this session can close.
- [ ] `apps/web/CLAUDE.md` "Shared UI" sign-off from Umer Islam on the `SEARCHABLE_LIST_QUERY`
      change (~28 files) before merge, and a decision on whether it ships as its own PR
      rather than bundled with the DB/index changes.
- [ ] Separate follow-up card for the pre-existing (not this branch's) `customers.service.ts`
      Top/Attention cap.
- [ ] A decision from Fouzan/Payroll on whether the payroll queue's 10s/5s polling cadence is
      acceptable, given it's the most likely source of the "payroll calculate... feels slow"
      complaint.
