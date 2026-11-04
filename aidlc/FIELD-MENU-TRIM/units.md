# Units — FIELD-MENU-TRIM Trim field Menu to My Certifications

**Gate baseline:** `2026-10-26`, `main` at `8bdf47652` — not run by the decomposer. Executor
runs `pnpm nx lint mobile`, `pnpm typecheck`, `pnpm nx test mobile` first and records the
baseline here.

## Unit ledger

| Unit | Name | Branch | Depends on | Status |
| --- | --- | --- | --- | --- |
| U1 | Remove Labor, Tasks, Checklist History from mobile | `refactor/FIELD-MENU-TRIM-u1-remove-menu-screens` | — | planned |
| U2 | Remove `/me/labor` and `/me/performance` from API | `refactor/FIELD-MENU-TRIM-u2-remove-me-endpoints` | U1 (stacked); Q1 | planned, blocked on Q1 |

## U1 — Remove Labor, Tasks, Checklist History from mobile

### Slice contents

| Row | Change |
| --- | --- |
| Menu | `menu.tsx`: keep certifications row only; drop `STATIC_OPEN_TASKS_COUNT`, unused imports |
| Routes | delete `menu/labor`, `menu/tasks`, `menu/checklist-history` (+ tests) |
| Hooks/contracts | delete `use-my-labor`, `use-performance-stats`, `my-labor.contract`, `performance.contract` (+ tests); prune `hooks/index.ts`, `query-keys.ts` |
| Services | delete `data/services/labor/`, `data/services/performance/`; prune `services/index.ts` |
| Component | delete `performance-section.tsx` (+test) |
| Prefetch | `auth-gate.tsx` + `auth-gate.test.tsx`: drop performance prefetch |
| Existing tests | update `menu.test.tsx`, `shell-chrome.test.ts`, `persona-shell.test.tsx`, `sub-header` comment |
| Tests added | `not requested` |

### Reviewable as
One mobile-only deletion PR. Expect large negative diff.

### Risk
Old API still serves the two endpoints: safe. Dangling imports: caught by `pnpm typecheck`
and `pnpm nx lint mobile`.

### Ripple
`@/data` barrel consumers; `.expo/types/router.d.ts` regenerates.

### Deliberately not in this unit
API, DB, vault.

## U2 — Remove `/me/labor` and `/me/performance` from API

### Slice contents

| Row | Change |
| --- | --- |
| Controller | `me.controller.ts`: drop two routes |
| Service | `me.service.ts`: drop `getMyLabor`, `getMyPerformance`, helpers, `Api*` types |
| Repository | `me.repository.ts`: drop methods no one else calls (grep each) |
| Specs | `me.service.spec.ts`: delete the removed cases only |
| Tracer | run `tcg-contract-tracer`; callers must be zero |
| Tests added | `not requested` |

### Risk
Old app builds 404 (Q1). Run `tcg-contract-tracer` before build.

### Deliberately not in this unit
Any schema change (none needed), certifications endpoint.

## Sequencing
U1 → U2. U2 PR targets U1's branch (draft) and merges only after Q1's condition holds.
