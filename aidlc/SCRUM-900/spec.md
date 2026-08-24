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
| Open questions raised by this spec | 0 open — Q1–Q3 resolved 2026-08-24 (see §12) |
| Rules consulted | `.ai/claude/contexts/api.md`, `.ai/claude/contexts/web.md`, `CLAUDE.md` → Architecture |

---

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Tool detail In Use must not count closed schedule-day assignments (today/future) | api / web | `[UNVERIFIED]` | `SCRUM-900`; `decisions/2026-08-24-tool-in-use-after-completion.md` | no |
| REQ-02 | Completion filter = per schedule-day sub-job / loadout (not parent Job only) | api | `[VERIFIED]` | `decisions/2026-08-24-tool-in-use-after-completion.md` | no |
| REQ-03 | Past dates = historical assignment qty; today/future = live-release filter | api / web | `[VERIFIED]` | `decisions/2026-08-24-tool-in-use-after-completion.md` | no |

Counts: 3 total — 2 verified, 1 unverified, 0 conflicted, 0 open.

---

## 2. Requirements

### REQ-01 — Tool detail In Use must not count closed schedule-day assignments (today/future) `[UNVERIFIED]`

- **Statement:** When the Tool and Rigging detail page displays In Use for **today or a future date**, assignments whose schedule-day sub-job is closed (completed / ticket-submitted / cancelled, or loadout offload complete) must not contribute to that count. Past dates keep historical assignment quantities (REQ-03).
- **Surface:** api (utilization query in `apps/api/src/service/asset-management/tools/tools.repository.ts` — `findUtilizationByDateRange`), web (Utilization card on the tool detail page — no logic change if API is correct)
- **Sources:**
  - `SCRUM-900` — `[UNVERIFIED]` — kind: jira — "On the Tool and Rigging detail page, the **In Use** count should reset after the associated job is completed."
  - `decisions/2026-08-24-tool-in-use-after-completion.md` — `[VERIFIED]` — kind: decision — Q1:B / Q2:C / Q3:B accepted by Fouzan Shakil on SCRUM-900.
- **Conflict:** none
- **Open question:** none
- **Acceptance:** (a) For today's date, after a schedule day's offload/stage completion for a job that assigned the tool, that day's qty no longer appears in In Use (other open assignments still count). (b) Past date on the picker still shows the historical assignment sum for that date. (c) Dylan yard panel unchanged in this ticket.
- **Notes for the executor:** Change `findUtilizationByDateRange` only. Reuse the closed-stage / completed-loadout exclusion already in `findToolIdsBlockedFromArchive` (same file). Apply that exclusion only when the assignment's schedule `date` is **today or future** (UTC date boundary consistent with existing archive helper). Do not mutate `Tool.availableQuantity`. Do not change Dylan client code. Web is display-only.

---

### REQ-02 — Completion filter = per schedule-day sub-job / loadout `[VERIFIED]`

- **Statement:** Utilization live-release uses **per-schedule-day** closure: exclude an assignment when its interval's sub-job `dasStage` is `COMPLETED`, `TICKET_SUBMITTED`, or `CANCELLED`, or when that sub-job's loadout has `offloadCompletedAt`, `forceCompletedAt`, or `phase === 'COMPLETED'`. Do **not** gate release solely on parent `Job.status = COMPLETED`.
- **Surface:** api
- **Sources:**
  - `decisions/2026-08-24-tool-in-use-after-completion.md` — `[VERIFIED]` — kind: decision — Q1:B
  - `decisions/2026-08-20-job-completed-on-last-day-offload.md` — `[VERIFIED]` — kind: decision — day-level completion reading (supporting, not sole)
- **Conflict:** none
- **Open question:** none
- **Acceptance:** Multi-day job: after day-1 offload complete while day-2 still open, utilization for **today** (if today is day-1 or later) must not count day-1's assignment qty; day-2's assignment still counts until day-2 closes.
- **Notes for the executor:** Mirror `findToolIdsBlockedFromArchive` closed-stage set. Missing subJob → treat as still in use (same as archive helper). This ticket does **not** require partial mid-day remaining-qty math on the detail API (Dylan's client does that); closed-day full exclusion is enough.

---

### REQ-03 — Past dates historical; today/future live-release `[VERIFIED]`

- **Statement:** When the utilization query's date range is entirely in the **past** (before today UTC), count assignment quantities without the completion filter (historical / audit). When querying **today or future** dates, apply REQ-02 live-release. For a range spanning past and today/future, apply the filter only to assignment rows whose schedule date is today or future.
- **Surface:** api / web
- **Sources:**
  - `decisions/2026-08-24-tool-in-use-after-completion.md` — `[VERIFIED]` — kind: decision — Q3:B
- **Conflict:** none
- **Open question:** none
- **Acceptance:** Pick yesterday on tool detail after that day's job completed → In Use still reflects yesterday's assignment qty. Pick today after that day closed → those assignments excluded.
- **Notes for the executor:** Define "today" the same way as `findToolIdsBlockedFromArchive` (UTC start-of-day). List utilization endpoint that uses a date range must apply the same rule per assignment date.

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

### Q1 — Completion filter granularity: job-level or sub-job/day-level?

- **Question:** Should the utilization API exclude tool assignments by filtering on the parent `Job.status = COMPLETED`, or by filtering on the per-schedule-day sub-job stage (`dasStage IN (COMPLETED, TICKET_SUBMITTED, CANCELLED)` or loadout `phase = COMPLETED`) as the Dylan panel does?
- **Answer (2026-08-24, Fouzan Shakil):** **B — per schedule day** (sub-job / loadout closure), same boundary as Dylan's panel and SCRUM-813 archive-block. Not parent `Job.status` alone.
- **Status:** resolved — see `decisions/2026-08-24-tool-in-use-after-completion.md`

---

### Q2 — Does this ticket cover Dylan's yard dashboard In Use counters?

- **Question:** Is the scope of "In Use count should reset" limited to the Tool and Rigging detail page's utilization card, or does it also include Dylan's yard dashboard?
- **Answer (2026-08-24, Fouzan Shakil):** **C — detail page this ticket.** Dylan unchanged here. Follow-up: converge on one server-side utilization both surfaces consume.
- **Status:** resolved — see `decisions/2026-08-24-tool-in-use-after-completion.md`

---

### Q3 — Historical date behavior: after job completes, past dates show 0 or historical peak?

- **Question:** When the user sets the utilization date picker to a past date on which the tool was assigned to a now-completed job, should In Use show 0 or the historical assignment quantity?
- **Answer (2026-08-24, Fouzan Shakil):** **B — historical** for past dates; live-release (Q1) for today and future.
- **Status:** resolved — see `decisions/2026-08-24-tool-in-use-after-completion.md`

---

## 13. What this spec deliberately does not specify

- **Dylan's yard dashboard rewiring** — out of this ticket (Q2:C); named follow-up to share the API utilization.
- **Partial mid-day remaining qty on detail utilization** — Dylan client releases remaining not-offloaded; detail API uses **closed-day full exclusion** only unless a later ticket asks for parity.
- **`Tool.availableQuantity` field mutation** — not specified; do not change.
- **Historical backfill of past utilization readings** — N/A under Q3:B (past stays historical by design).
- **Vendor-only / no-yard jobs** — same as SCRUM-903 scope limits.

---

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [x] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` *(none in this spec)*
- [x] Answers written back into `spec.md` with their new sources and flags
- [x] Every §12 question updated to `Status: resolved — see decisions/2026-08-24-tool-in-use-after-completion.md`
- [x] Decomposed into vertical units — `units.md` (U1 built on `scrum-900`)

Answered by: Fouzan Shakil  Date: 2026-08-24
