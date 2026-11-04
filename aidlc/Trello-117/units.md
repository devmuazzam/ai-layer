# Units — Trello-117 Job Walk Web Tab

## Gate baseline

**Not yet run.** Run before U1 starts and record here: `pnpm nx run @tcg/api:prisma:generate`, then `pnpm lint`, `pnpm typecheck`, `pnpm build`, `pnpm test`. (On 2026-11-02 the API build failed locally only because the Prisma client was not generated.)

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Admin can configure Job Walk permissions per role; API rejects unauthorized requests | REQ-01, REQ-02, REQ-08, REQ-09 | shared, api, web | — | ~100 lines / 5 files | built, uncommitted — developer testing |
| U2 | Job Walk changes are logged with field diffs; web cannot change signature fields | REQ-05, REQ-06 | api, schema | U1 | ~150 lines / 8 files | built, uncommitted — developer testing |
| U3 | Web users see the read-only Job Walk tab, and edit it from Edit Quotation (if permitted) | REQ-03, REQ-04, REQ-07 | web | U2 | ~800 lines / 15 files | built, uncommitted — developer testing |

- Requirements covered: REQ-01..REQ-09 (all)
- Units blocked on an open question: none (Q1 non-blocking — percentage subtitle left out; Q2 no impact)

---

## U1 — Permission module + API guards

- **Outcome:** An admin can configure `job-walks` permission per department role; the API rejects unauthorized Job Walk requests with 403.
- **Kind:** vertical
- **Requirements covered:** REQ-01, REQ-02, REQ-08, REQ-09
- **Depends on:** —
- **Branch / PR base:** `feat/trello-117-u1-job-walk-permissions` from `origin/staging`
- **Size estimate:** ~100 source lines, 9 source files

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | Data-only migration `20261102150000_grant_job_walks_permission` (DS3): step 1 `view` on non-empty maps with quotation access; step 2 `edit` on roles with `mobile-quotations` edit/full | Precedent: `20261020210000_grant_salesperson_permission`. G2 — run on a staging copy first |
| API (`apps/api`) | `@RequirePermission` on all 7 endpoints per REQ-02 table — `POST /job-walks` uses `mobile-quotations: edit`, reads use `job-walks: view`, writes use `job-walks: edit`. Seeds per DS8 | `job-walk-reports.controller.ts`, `seed-data.ts` |
| Web (`apps/web`) | Add `job-walks` to `MODULE_PERMISSIONS` with icon and template defaults | `role-permissions.ts` |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | Add `'job-walks'` to `PERMISSION_MODULES`; rebuild `@tcg/shared` | `permissions.ts` |
| Tests | `not requested` | |

### Reviewable as

- **Demo:** Admin → Settings → Departments → any role → "Job Walks" configurable. User without `job-walks: view` → `GET /job-walks?quoteNo=…` returns 403. Operator → `POST /job-walks` returns 403. Salesperson on mobile → create, edit, sign, complete all still work.
- **Acceptance:** REQ-01, REQ-02, REQ-08, REQ-09
- **Reviewer can verify without:** U2, U3

### Risk

- **Weakest source:** `[UNVERIFIED]`
- **Migration reversible:** yes — remove the `job-walks` key from `permissions` JSON
- **Behind a flag:** no
- **Touches existing data:** yes — two-step migration: (1) `job-walks: view` to ALL existing roles, (2) `job-walks: edit` only to roles with `mobile-quotations`
- **Blast radius:** if step 2 or the Salesperson seed is missing, mobile edit/sign/complete returns 403 (`resolveEffectiveLevel` returns `'none'` for a missing key on a non-empty role map)

### Ripple

| Existing consumer | Reached via | How we know it still works | Source |
| --- | --- | --- | --- |
| Mobile Job Walk create | `POST /job-walks` — `mobile-quotations: edit` | Salesperson already holds it (`seed-data.ts:244`) | REQ-02, REQ-08 |
| Mobile Job Walk update / complete / signatures | `job-walks: edit` guards | Seed + migration step 2 | REQ-08, REQ-09 |
| Settings → Departments UI | New module in `MODULE_PERMISSIONS` | Existing modules unaffected | REQ-01 |

### Deliberately not in this unit

- Audit logging and signature stripping — U2
- Web Job Walk tab — U3

---

## U2 — Audit logging + signature protection

- **Outcome:** Every Job Walk create, field change, completion and signature change is logged with a field diff (empty diffs skipped); a web PATCH cannot change signature names or dates.
- **Kind:** vertical
- **Requirements covered:** REQ-05, REQ-06
- **Depends on:** U1
- **Branch / PR base:** `feat/trello-117-u2-job-walk-audit` stacked on U1's branch **and** on Trello-115 U1 + U2a (`APP_PLATFORM_HEADER`, mobile `appVersionHeaders()`) — DS9
- **Size estimate:** ~80 source lines, 6 source files

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | Logs use the existing `QUOTATION` entity (D17) |
| API (`apps/api`) | Log create / update / complete / signature events through `QuotationActivityLogger` with tab `Job Walk`; empty diffs skipped; strip signature name/date fields from PATCH per DS2; signature PUT/DELETE 403 without the mobile header | `job-walk-reports.service.ts`, `job-walk-reports.repository.ts`, `job-walk-reports.module.ts`, `quotations.module.ts`, `create-quotation.dto.ts`, controller |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | N/A | |
| Tests | `not requested` | |

### Reviewable as

- **Demo:** `PATCH /job-walks/JWR-00001` with a changed field → one `QUOTATION` activity row with tab `Job Walk` and `{ field: { from, to } }`. Same PATCH with identical values → no new row. PATCH with `operatorPrintedName` and no mobile platform header → field not updated.
- **Acceptance:** REQ-05, REQ-06
- **Reviewer can verify without:** U3

### Risk

- **Weakest source:** `[UNVERIFIED]`
- **Migration reversible:** no — Postgres enum `ADD VALUE` cannot be dropped, but an unused value is harmless
- **Behind a flag:** no
- **Touches existing data:** no
- **Blast radius:** logging wrapped in `safeActivityLog()`, never blocks the write. Signature protection depends on `x-app-platform` (DS2/DS9), which only the Trello-115 mobile build sends — **merge order: Trello-115 U1 + U2a and its mobile build live first, then U2.** Older builds keep working for survey fields but lose signature name/date edits and get 403 on signature upload/delete until updated.
- **DI check:** the module's `imports` change — boot the API once (`pnpm api:dev`) before opening the PR (`apps/api/CLAUDE.md`).

### Ripple

| Existing consumer | Reached via | How we know it still works | Source |
| --- | --- | --- | --- |
| Existing activity-log queries | Enum gains a value | Existing types unchanged | REQ-06 |
| Mobile signature names/dates | PATCH stripping | Manual test on device after the DS2 dependency is settled | REQ-05, REQ-08 |

### Deliberately not in this unit

- Web UI — U3

---

## U3 — Web Job Walk tab

- **Outcome:** Web users see the read-only Job Walk tab on quotation detail, matching the approved design, and users with `job-walks: edit` edit survey fields from the Job Walk step of Edit Quotation.
- **Kind:** vertical
- **Requirements covered:** REQ-03, REQ-04, REQ-07
- **Depends on:** U2
- **Branch / PR base:** `feat/trello-117-u3-job-walk-web-tab` stacked on U2's branch
- **Size estimate:** ~320 source lines, 5 source files

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | N/A | |
| Web (`apps/web`) | New: `job-walks.service.ts`, `use-job-walks.ts`, `use-wizard-job-walk.ts`, `detail-job-walk-tab.tsx`, `detail-job-walk-cards.tsx`, `detail-job-walk-fields.ts`. Modified: `view-quotation.tsx`, `view-quotation.helpers.ts`, `quotations.tsx`, `create-quotation.tsx`, `create-quotation-actions.ts`, `create-quotation-form-model.ts`, `create-quotation-save.ts`, `create-quotation-tab-content.tsx`, `create-quotation-wizard-nav.tsx` | No Edit button or history section on the tab |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | N/A | |
| Tests | `not requested` | |

### Reviewable as

- **Demo:** Quote with a Job Walk → Job Walk tab → cards, pills and signature panels match the design, including "% of net capacity". Edit Quotation with `job-walks: edit` → Job Walk step → change Boom Length → Update → value updates and the Activity Log shows it under Job Walk. `job-walks: view` user → no step. Quote without a Job Walk → no tab and no step.
- **Acceptance:** REQ-03, REQ-04, REQ-07
- **Reviewer can verify without:** none (needs U1–U2)

### Risk

- **Weakest source:** `[UNVERIFIED]`
- **Migration reversible:** yes (code only)
- **Behind a flag:** no
- **Touches existing data:** no
- **Blast radius:** a crash in the tab could break quotation detail — wrap the tab in an error boundary

### Ripple

| Existing consumer | Reached via | How we know it still works | Source |
| --- | --- | --- | --- |
| Quotation detail tabs | New entry in `TABS` | Additive | REQ-03 |
| Quotation `?tab=` URL param | New tab value | Existing values unchanged | REQ-03 |

### Deliberately not in this unit

- "% of net capacity" subtitle — waiting on Q1

---

## Sequencing

```
U1 ──▶ U2 ──▶ U3
```

- **Parallelisable:** none — strict linear dependency
- **Merge order constraint:** U1 (shared package + permission migration), then U2 (enum migration), then U3
- **First unit to ship:** U1 — proves the permission system works and mobile is not broken
