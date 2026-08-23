# Spec — SCRUM-900 Update Tool and Rigging Usage Logic After Job Completion

> Written to `.ai/aidlc/SCRUM-900/spec.md` by the elaborator on 2026-08-21.
>
> This is the document an executor builds from. **Every requirement in it carries its
> sources, and every source carries its status.** A requirement with no source is not a
> requirement — it is an open question, and it stays marked as one.

---

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-900` |
| Intent | `.ai/aidlc/SCRUM-900/intent.md`, captured `2026-08-21` |
| Elaborated on | `2026-08-21` |
| Vault state at elaboration | 151 product files; six `domain/` files verified; `gaps.md` historical entries only (retired 2026-08-20) |
| Open questions raised by this spec | 3 — Q1, Q2, Q3 — all in §12 |
| Rules consulted | `.ai/claude/contexts/api.md`, `.ai/claude/contexts/web.md`, `CLAUDE.md` → Architecture |

---

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Tool detail In Use must not count completed-job assignments | api / web | `[UNVERIFIED]` | `SCRUM-900`; `decisions/2026-08-20-job-completed-on-last-day-offload.md` | partial — behavior is clear; see Q1 for filter granularity |
| REQ-02 | Completion filter granularity (job-level vs. sub-job/day-level) | api | `[OPEN]` | none | **yes** |
| REQ-03 | Historical date semantics after job completion | api / web | `[OPEN]` | none | **yes** |

Counts: 3 total — 0 verified, 1 unverified, 0 conflicted, 2 open.

---

## 2. Requirements

### REQ-01 — Tool detail In Use must not count completed-job assignments `[UNVERIFIED]`

- **Statement:** When the Tool and Rigging detail page displays the In Use count for a tool, assignments belonging to a job that has reached the Completed status must not contribute to that count.
- **Surface:** api (utilization query in `apps/api/src/service/asset-management/tools/tools.repository.ts` — `findUtilizationByDateRange`), web (Utilization card on the tool detail page, `apps/web/src/features/assets/tools-riggings/components/tool-detail-view.tsx`)
- **Sources:**
  - `SCRUM-900` — `[UNVERIFIED]` — kind: jira — "On the Tool and Rigging detail page, the **In Use** count should reset after the associated job is completed."
  - `decisions/2026-08-20-job-completed-on-last-day-offload.md` — `[VERIFIED]` — kind: decision — Defines when a job reaches Completed: parent `Job.status → COMPLETED` when the last scheduled day's yard offload is done (settled by Umair Khan on SCRUM-903).
- **Conflict:** none
- **Open question:** REQ-01 establishes *what* must change; Q1 settles *how* to identify a "completed" assignment (job-level `Job.status = COMPLETED` vs. per-schedule-day sub-job stage). Q3 settles historical date behavior.
- **Acceptance:** On the tool detail utilization card, after the associated job's `Job.status` becomes `COMPLETED`, the In Use count for that tool returns to 0 (assuming no other active jobs claim the same tool on that date). Verified by: (a) completing a job via the SCRUM-903 path and then reloading the tool detail page, (b) confirming the utilization donut shows the released quantity as available.
- **Notes for the executor:** The existing `findUtilizationByDateRange` sums all `JobToolAssignment` rows in a date range with no filter on job or sub-job status — this is the query that must be changed. The Dylan yard-dashboard panel's `resolveJobToolInUseQuantity` already excludes completed stages client-side; this ticket targets the API-served utilization on the tool *detail* page, not the Dylan panel (see §13). No new Prisma model is introduced; the fix is a query-level filter. Which relation to filter on (parent `Job.status` vs. `SubJob.dasStage` / loadout phase) is blocked by Q1. Web change is display-only: if the API returns the correct value, the donut re-renders without change.

---

### REQ-02 — Completion filter granularity `[OPEN]`

- **Statement:** `OPEN — the ticket asks for In Use to reset "after the associated job is completed." Two distinct filter levels exist in the codebase: (a) parent Job.status = COMPLETED (set by SCRUM-903 on last-day offload) and (b) per-schedule-day sub-job dasStage / loadout phase (already used by the Dylan panel). No source states which the utilization API for the tool detail page must use.`
- **Surface:** api
- **Sources:** none — searched: `SCRUM-900` (ticket description only, no AC); `product/tool-and-rigging.md` (3.7 KB, 2026-05-26, UNVERIFIED — lists the availability chart on the detail page but does not specify the completion boundary); `SCRUM-453` (Done — detail page AC does not specify filter logic); `SCRUM-457` (Done — Dylan's dashboard AC #9 says "tools become unavailable to other jobs" once the crew loads, but says nothing about completion reset); `decisions/2026-08-20-job-completed-on-last-day-offload.md` (defines when Job.status → COMPLETED; does not address utilization API behavior); code at `apps/api/src/service/asset-management/tools/tools.repository.ts::findUtilizationByDateRange` (no completion filter at all today). Nothing settles which granularity this ticket requires.
- **Conflict:** n/a
- **Open question:** Q1 below — blocks REQ-02 entirely.
- **Acceptance:** `OPEN — cannot be stated until Q1 is answered.`
- **Notes for the executor:** Two candidate approaches, stated as questions only — (a) filter `JobToolAssignment` rows where the parent `Job.status != COMPLETED`; simple, one join, but means a multi-day job's earlier-day tools stay "in use" until the whole job finishes; (b) filter by sub-job `dasStage NOT IN (COMPLETED, TICKET_SUBMITTED, CANCELLED)` and loadout `phase != COMPLETED`, mirroring the Dylan panel; finer-grained but more joins. The choice is a product question, not a technical one. **Blocked — do not implement either path until Q1 is answered.**

---

### REQ-03 — Historical date behavior after job completion `[OPEN]`

- **Statement:** `OPEN — the ticket does not state what the utilization display should show for a past date on which a tool was assigned to a job that has since completed. Two readings exist: (A) always return 0 for completed-job assignments regardless of the queried date (the tool was "returned"), or (B) show the historical in-use peak for the date the assignment was active (what was true at the time).`
- **Surface:** api / web
- **Sources:** none — searched: `SCRUM-900` (no AC, no date-picker semantics mentioned); `product/tool-and-rigging.md` (availability chart mentioned, no historical semantics); `SCRUM-453` (availability chart AC, no semantics); nothing in the vault addresses per-date vs. point-in-time utilization history.
- **Conflict:** n/a
- **Open question:** Q3 below — blocks REQ-03 entirely.
- **Acceptance:** `OPEN — cannot be stated until Q3 is answered.`
- **Notes for the executor:** The tool detail page already has a date picker (`utilizationDate` state, `DateTimeInput` component) that the user can set to any past date. The current query returns the sum for that date without filtering on status. If reading A is chosen, the implementation is the same filter applied to all queries regardless of date. If reading B is chosen, filter logic must be conditional: only exclude completed jobs when querying today or a future date, but not historical dates. **Blocked — do not implement either path until Q3 is answered.**

---

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no — no new model or column. The utilization is derived from existing `JobToolAssignment`, `SubJob`, `SubJobLoadout`, and `Job` records. SCRUM-903 already writes `Job.status = COMPLETED` via existing fields.
- **Migration required:** no
- **Data backfill required:** no — forward-looking only (consistent with SCRUM-903's scope decision: `decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md`). Historical jobs already showing incorrect In Use counts are accepted debt pending a follow-up if product chooses to address them.

```prisma
// No schema changes for this ticket.
// Existing models used (read-only for this ticket):
//   Job { status JobStatus ... }
//   JobToolAssignment { jobTool JobTool; jobScheduleInterval JobScheduleInterval; quantity Int; ... }
//   SubJob { dasStage DasStage; ... }
//   SubJobLoadout { phase String; offloadCompletedAt DateTime?; forceCompletedAt DateTime?; ... }
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| N/A — no new entity | N/A | N/A | N/A | N/A |

- **New prefix introduced:** no
- **Child relations:** N/A — no new relationships
- **Fields whose type/precision no source states:** N/A

---

## 4. API surface — `apps/api`

Layering is `presentation → usecase → service → orm`, never upward.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/v1/asset-management/tools/:toolCode/utilization` (existing) | `tools.controller.ts` | `tools.service.ts` | `tools.repository.ts` → `findUtilizationByToolIdAndDate` → `findUtilizationByDateRange` | REQ-01 (blocked by Q1, Q3) |

No new endpoint. The existing utilization endpoint is modified in-place.

Per endpoint:

- **Request DTO:** no change — date query param is already present
- **Response shape:** no change — `{ available, total, inUse }` shape is unchanged; the numeric values change
- **Guards / roles:** no change — inherits existing `AccessTokenGuard` (global)
- **Route param identity:** no change — `toolCode` resolved to UUID in existing service
- **Errors:** no change — existing 404 for unknown tool code
- **Module registration:** no new module; existing `asset-management` module

---

## 5. Web surface — `apps/web`

- **Routes:** no new routes — existing tool detail at `/asset-management/tools-riggings/<toolCode>`
- **Existing components to reuse:** `AvailabilityDonut` (already renders `available` / `total` from the utilization query); `DateTimeInput` (already present for date picker). No new components needed — the donut re-renders from corrected API data.
- **New components proposed:** none
- **Table (if any):** N/A
- **Forms:** N/A
- **Server state:** TanStack Query v5 — query key `['tools', toolId, 'utilization', utilizationDate]` already in place; no change needed if API returns correct values
- **Colors / spacing:** no change
- **Responsive:** no change
- **Copy:** no change — existing labels "In Use", "Available", "Total" are unchanged; no source states new copy

---

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** N/A — intent explicitly states mobile is NOT ON TICKET
- **Components:** N/A
- **Offline / sync behavior:** N/A
- **Touch targets:** N/A
- **Push / notifications involvement:** N/A

---

## 7. Shared package — `packages/shared`

- **Nothing shared:** `N/A — no new types needed; the utilization shape is unchanged; the fix is in API query logic only`

---

## 8. Permissions and tenancy

- **Roles permitted:** NOT SPECIFIED — ticket does not name roles; existing endpoint is protected by `AccessTokenGuard` (global); no role change implied
- **Roles denied:** NOT SPECIFIED
- **Tenant isolation:** standard — `findUtilizationByDateRange` operates via the tenant-scoped Prisma client extension (`$extends`); the completion filter must remain within tenant scope (filter by `Job.status`, which is already a field on the tenant-scoped `Job` relation)
- **Cross-tenant reads:** none

---

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `date` query param | Must be a valid ISO 8601 date string | existing behavior | `[UNVERIFIED]` |
| — | No new validation rules introduced by this ticket | — | — |

---

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | `findUtilizationByDateRange` returns `inUse: 0` for a tool whose only assignment belongs to a job with `status = COMPLETED` (or whatever filter Q1 settles) | REQ-01 |
| Integration (API) | `GET /utilization?date=<date>` returns correct `inUse` after a job transitions to COMPLETED | REQ-01 |
| E2E / manual script | Load tool detail page → verify utilization donut shows 0 In Use after associated job reaches Completed status via SCRUM-903 path | REQ-01 |

- Requirements with no testable acceptance criterion: REQ-02, REQ-03 (blocked by Q1 and Q3 respectively)

---

## 11. Non-functional

- **Performance:** NOT SPECIFIED — the existing `findUtilizationByDateRange` query already does two Prisma queries (tools list + assignment rows). Adding a join to `Job.status` (Q1 option A) or to `SubJob.dasStage` (Q1 option B) adds one join. No source states a performance requirement. The change should not materially degrade a query that already spans multiple tables.
- **Concurrency:** NOT SPECIFIED — no code-minting, no write path introduced
- **Audit / activity log:** NOT SPECIFIED — ticket mentions no activity log requirement; none exists today for utilization reads
- **Migration/rollout order:** API filter change only → web reflects new values automatically on next page load. No coordinated rollout needed. Consistent with "forward-only" scope from `decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md`.

---

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered.

### Q1 — Completion filter granularity: job-level or sub-job/day-level?

- **Question:** Should the utilization API exclude tool assignments by filtering on the parent `Job.status = COMPLETED`, or by filtering on the per-schedule-day sub-job stage (`dasStage IN (COMPLETED, TICKET_SUBMITTED, CANCELLED)` or loadout `phase = COMPLETED`) as the Dylan panel does?
- **Why it cannot be answered from what is written:** `SCRUM-900` states the behavior but not the mechanism. `decisions/2026-08-20-job-completed-on-last-day-offload.md` defines when `Job.status → COMPLETED` (last-day offload done) but does not address which level the utilization filter should use. The Dylan panel (`resolve-job-tool-in-use-quantity.ts`) uses sub-job/loadout stage — but that is client-side logic for the live yard view, and it does not constitute a product decision for the tool detail page's API. No vault file specifies the filter level for the detail page's utilization endpoint. The two approaches produce different results for multi-day jobs: a job with days 1 and 2 where day 1 offload is done but day 2 has not yet started — under job-level filtering the tool stays In Use (job is still ACTIVE); under sub-job/day-level filtering the tool is released on day 1 but still In Use on day 2.
- **Blocked:** REQ-02 (implementation choice), REQ-03 (historical date semantics depend on which filter applies)
- **Candidates:**
  - `SCRUM-900` (Jira, 2026-08-17) — description only
  - `product/tool-and-rigging.md` (3.7 KB, 2026-05-26, UNVERIFIED) — availability chart mentioned, no filter semantics
  - `SCRUM-453` (Done, 2026-05-21) — availability chart AC, no filter semantics
  - `SCRUM-457` (Done, 2026-05-21) — Dylan dashboard AC, no detail page semantics
  - `decisions/2026-08-20-job-completed-on-last-day-offload.md` — settles when Job.status → COMPLETED; silent on utilization filter level
  - `apps/web/src/features/dylen-dashboard/utils/resolve-job-tool-in-use-quantity.ts` — kind: code — Dylan panel uses sub-job/loadout stage client-side; does not settle the API question
- **Owner:** product team (Umair Khan or Aiman Farooq — same people on SCRUM-903)
- **Workaround, if any:** If a decision is needed before the answer arrives, the simplest workaround is to filter by `Job.status = COMPLETED` (option A — one join, mirrors the SCRUM-903 completion event). Label explicitly as a workaround pending confirmation. Do not pick this path silently.
- **Status:** open

---

### Q2 — Does this ticket cover Dylan's yard dashboard In Use counters?

- **Question:** Is the scope of "In Use count should reset" limited to the Tool and Rigging detail page's utilization card, or does it also include the live Total / In Use / Available counters shown on Dylan's yard dashboard (SCRUM-457)?
- **Why it cannot be answered from what is written:** The intent explicitly notes "Dylan yard-dashboard In Use counters — NOT ON TICKET whether this ticket covers them." The ticket description mentions only "the Tool and Rigging detail page." Dylan's panel already applies its own client-side completion logic (`resolveJobToolInUseQuantity`) which excludes completed stages — but that logic lives in the web client, not in the utilization API. If the API's `findUtilizationByDateRange` is also consumed by the Dylan panel to set the "Total" / "Available" stock numbers (not the live per-job demand), a change to it might have side effects there. No source says whether this is intended.
- **Blocked:** does not block REQ-01 for the detail page, but blocks claiming Dylan's panel is in scope for this ticket
- **Candidates:**
  - `SCRUM-900` (Jira, 2026-08-17) — "Tool and Rigging detail page" only
  - `SCRUM-457` (Done, 2026-05-21) — Dylan dashboard AC; no mention of SCRUM-900's behavior
  - `apps/web/src/features/dylen-dashboard/` — kind: code — uses separate client-side resolution, not the same API call
- **Owner:** product team
- **Workaround, if any:** Treat the tool detail page as the only explicit scope (matching the ticket's literal text). If the utilization API is also called by the Dylan panel, a change to it will affect both surfaces — flag this explicitly in the PR description so a reviewer can confirm whether the side effect is intended.
- **Status:** open

---

### Q3 — Historical date behavior: after job completes, past dates show 0 or historical peak?

- **Question:** When the user sets the utilization date picker on the tool detail page to a past date on which the tool was assigned to a now-completed job, should In Use show 0 (job completed, tool released) or the historical assignment quantity (what was true when the date was current)?
- **Why it cannot be answered from what is written:** `SCRUM-900` does not mention the date picker. No vault file specifies point-in-time vs. current-status semantics for the utilization endpoint. The current implementation reads `JobToolAssignment` quantities for the queried date regardless of current job status, so it shows the historical peak — but this is the behavior being changed, not the intended behavior.
- **Blocked:** REQ-03; also affects whether the Q1 filter is date-conditional
- **Candidates:**
  - `SCRUM-900` (Jira, 2026-08-17) — no mention of date picker semantics
  - `product/tool-and-rigging.md` (3.7 KB, 2026-05-26, UNVERIFIED) — availability chart mentioned; no semantics for historical dates
  - `SCRUM-453` (Done, 2026-05-21) — availability chart in AC; no date picker semantics
  - `apps/web/src/features/assets/tools-riggings/components/tool-detail-view.tsx` — kind: code — date picker exists today; current query has no completion filter
- **Owner:** product team
- **Workaround, if any:** If pressed, the simplest path (option A from Q3 perspective) is to apply the completion filter regardless of the queried date — i.e., a completed job's assignments always return 0 on any date. This is the least work and matches the literal "reset" language. Label it as a workaround pending a product answer.
- **Status:** open

---

## 13. What this spec deliberately does not specify

- **Dylan's yard dashboard In Use counters** — not named in the ticket; see Q2. The Dylan panel already uses its own client-side logic to exclude completed demand.
- **`Tool.availableQuantity` field mutation** — the ticket describes a display fix (In Use count); SCRUM-903 does not write `Tool.availableQuantity`, and this ticket does not specify whether that field should be updated. No source says to change it. Excluded as not specified.
- **Historical backfill of past utilization readings** — excluded, consistent with SCRUM-903's forward-only scope decision (`decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md`). Jobs that were already completed before this change will not be retroactively re-evaluated.
- **Vendor-only / no-yard jobs** — jobs that never go through yard offload (and therefore never reach `Job.status = COMPLETED` via the SCRUM-903 path) are out of scope, consistent with `decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md`.
- **Filter granularity (job vs. sub-job level)** — see Q1. Not specified.
- **Historical date semantics** — see Q3. Not specified.

---

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` *(none in this spec)*
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________
