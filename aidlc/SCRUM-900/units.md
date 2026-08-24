# Units — SCRUM-900 Update Tool and Rigging Usage Logic After Job Completion

> Written to `.ai/aidlc/SCRUM-900/units.md` from the approved `spec.md` beside it.
> Decomposed 2026-08-24. All three spec questions (Q1–Q3) are resolved; zero open requirements.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Tool detail In Use no longer counts completed schedule-day assignments for today/future dates | REQ-01, REQ-02, REQ-03 | api | — | S | built — c0e8d227 |

- Requirements not covered by any unit: none — all 3 requirements covered fully by U1.
- Units blocked on an open question: none — all questions resolved.

---

## U1 — Live-release filter for tool utilization

- **Outcome:** After a schedule day's sub-job is closed (stage COMPLETED / TICKET_SUBMITTED / CANCELLED, or loadout offload/force-complete / phase COMPLETED), that day's tool assignments no longer appear in In Use on the Tool & Rigging detail page for today or future dates. Past-date picks still show the historical assignment quantity.
- **Kind:** vertical
- **Requirements covered:** REQ-01 (fully), REQ-02 (fully), REQ-03 (fully)
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | None | No schema change; no migration |
| API (`apps/api`) | Modify `findUtilizationByDateRange` in `apps/api/src/service/asset-management/tools/tools.repository.ts` | Extend the `jobScheduleInterval` select to include `subJob { dasStage, loadout { phase, offloadCompletedAt, forceCompletedAt } }`. After fetching assignment rows, compute `startOfTodayUtc` (same UTC boundary used in `findToolIdsBlockedFromArchive`). For each assignment row, skip it in the in-use tally when (a) its `jobScheduleInterval.date >= startOfTodayUtc` AND (b) its sub-job is closed by the `closedStages` set or its loadout is offload/force/phase-COMPLETED. Missing subJob on a today/future row → treat as still in use (mirror archive helper). Past-date rows are accumulated unconditionally. |
| Web (`apps/web`) | None | Display-only; API response shape unchanged; TanStack Query key unchanged. No files need to change. |
| Mobile (`apps/mobile`) | N/A — mobile out of scope (spec §6) | |
| Shared (`packages/shared`) | N/A — no new types; utilization shape unchanged (spec §7) | |
| Tests | New `apps/api/src/service/asset-management/tools/tools.repository.spec.ts` (no existing repo spec; service spec is in `usecase/`). Unit cases: (1) past-date assignment on a closed-stage job → inUse reflects historical qty; (2) today/future assignment, sub-job stage COMPLETED → inUse 0; (3) today/future, sub-job stage COMPLETED on one day only in a multi-day range → excluded day's qty not counted, open days still counted; (4) missing subJob on today/future assignment → treated as in use. Integration: `GET /api/v1/asset-management/tools/:toolCode/utilization?date=<today>` returns correct `inUse` after schedule-day sub-job transitions to COMPLETED. | All mocks hand-rolled without a database, consistent with pattern in `tools.service.spec.ts`. |

### Reviewable as

- **Demo:** `GET /api/v1/asset-management/tools/:toolCode/utilization?date=<today-iso>` — before the fix returns inUse > 0 after the day's offload completes; after the fix returns the reduced inUse. Alternatively, open the Tool & Rigging detail page, set date picker to today, complete the associated job's schedule day, refresh — In Use donut updates.
- **Acceptance:** REQ-01 (a) today/future inUse excludes closed-day assignments; (b) past-date still shows historical qty; (c) Dylan yard panel unchanged. REQ-02: multi-day job, day-1 offload complete while day-2 open → day-1 qty excluded for today's utilization, day-2 still counts. REQ-03: yesterday's picker after day closed → still shows historical assignment qty; today's picker after day closed → 0.
- **Reviewer can verify without:** U2 (none exists), seed data beyond a single tool + job + schedule interval with a sub-job, a real tenant (hand-rolled mocks in unit spec suffice for logic; integration test needs a running API + DB).

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-01's Jira source is `[UNVERIFIED]`; the decision `decisions/2026-08-24-tool-in-use-after-completion.md` is `[VERIFIED]` and resolves the interpretation. The Jira ticket text is corroborative, not contradicted.
- **Migration reversible:** N/A — no migration
- **Behind a flag:** no
- **Touches existing data:** no — read-only query logic change; no writes, no backfill
- **Blast radius:** Tool utilization `inUse` values on the detail page for today/future dates. If the filter predicate is inverted or the UTC boundary is wrong: tools could show 0 in use when a schedule day is still open (availability inflation) or continue to count closed days (the bug stays). The existing `findToolIdsBlockedFromArchive` uses an identical predicate and boundary — the executor should extract the check into a shared helper to keep the two in sync and reduce blast radius.

**`[UNVERIFIED]` + not reversible check:** The change is code-only (no schema, no data writes). It is trivially reversible by reverting the file. The `[UNVERIFIED]` source is not a concern for undo cost; no special pre-build confirmation required.

### Deliberately not in this unit

- **Dylan yard dashboard rewiring** — out of scope per Q2:C; named follow-up to share one server-side utilization computation.
- **Partial mid-day remaining qty on detail API** — closed-day full exclusion only; parity with Dylan's remaining-qty release not in this ticket (spec §13).
- **`Tool.availableQuantity` field mutation** — explicitly excluded (spec §2 REQ-01 notes).
- **Historical backfill** — past dates intentionally keep historical quantities; no backfill (spec §3).
- **Vendor-only / no-yard job closure handling** — same SCRUM-903 scope limit; missing subJob defaults to in-use (spec REQ-02 notes).

---

## Sequencing

```
U1
```

- **Parallelisable:** N/A — single unit.
- **Merge order constraint:** N/A — no migration; no ordering constraint.
- **First unit to ship:** U1 — proves the complete fix end-to-end: the correct `inUse` value flows from the updated repository query through the unchanged controller to the unchanged web component. If the first (and only) unit ships correctly, the ticket is done.
