# Spec — FIELD-MENU-TRIM Trim field Menu to My Certifications

> Path A: removing client-facing behaviour (G1). Source of every requirement is the
> developer's request (`intent.md`), tag `[DEV-REQUEST]`. Code facts below were read on
> 2026-10-26 from `main` at `8bdf47652`.

## 0. Provenance

Developer request in chat 2026-10-26. Vault was not consulted for intent: removal needs no
product behaviour. Vault pages that describe the removed screens are listed in §13.

## 1. Requirements ledger

| ID | Requirement | Source |
| --- | --- | --- |
| REQ-01 | Menu lists My Certifications only | `[DEV-REQUEST]` |
| REQ-02 | Remove My Labor, My Tasks, Checklist History screens and routes | `[DEV-REQUEST]` |
| REQ-03 | Remove mobile code used only by those screens | `[DEV-REQUEST]` |
| REQ-04 | Remove API endpoints used only by those screens | `[DEV-REQUEST]` |
| REQ-05 | Remove DB objects used only by those screens, if any | `[DEV-REQUEST]` |

## 2. Requirements

### REQ-01 — Menu shows only My Certifications
`menu.tsx` `rows` keeps the `certifications` row. Profile header, version line, sign-out and
crash-test button stay. Certifications badge logic stays.

### REQ-02 — Remove screens
Delete from `apps/mobile/app/(field)/menu/`: `labor.tsx`, `tasks.tsx`,
`checklist-history.tsx` and each `.test.tsx`. Drop `STATIC_OPEN_TASKS_COUNT` and its comment
in `menu.tsx`. Update `menu.test.tsx`, `sub-header.tsx` comment, `shell-chrome.test.ts` and
`persona-shell.test.tsx` (both use `menu/labor` as the sub-screen example; point them at
`menu/certifications`).

### REQ-03 — Remove mobile code used only by them
Verified single-consumer:
- `data/hooks/use-my-labor.ts` (+test), `data/contracts/my-labor.contract.ts` (+test),
  `data/services/labor/*`, `queryKeys.myLabor`, exports in `hooks/index.ts` and
  `services/index.ts`.
- `data/hooks/use-performance-stats.ts` (+test), `data/contracts/performance.contract.ts`,
  `data/services/performance/*`, `queryKeys.performanceStats`,
  `components/field/performance-section.tsx` (+test).
- `components/session/auth-gate.tsx`: remove the `usePerformanceStats` prefetch and its test
  case (`auth-gate.test.tsx`).
- Generated `apps/mobile/.expo/types/router.d.ts`: regenerates, do not hand-edit.
Executor must re-grep each symbol before deleting; `LaborBody.tsx` and `ReviewBody.tsx`
matched `labor-hours` only (in-ticket labor, out of scope).

### REQ-04 — Remove API endpoints
`GET /me/labor` and `GET /me/performance` (`me.controller.ts`), `getMyLabor` /
`getMyPerformance` and helpers in `me.service.ts` (`ticketLaborHours`, `sumLaborHours`,
`buildShiftRows`, `Api*` interfaces), the matching `me.repository.ts` methods that nothing
else calls (e.g. `findLaborProfile`, shift-ticket reads — executor greps each), and their
cases in `me.service.spec.ts` (delete only; no new tests). `GET /me/certifications` stays.
Tasks and Checklist History have no endpoint: they are local fixtures (`INITIAL_TASKS`,
static list).

### REQ-05 — DB
Nothing to remove. Labor/performance read existing `tickets`, time-entry, employee and
payroll tables that payroll, tickets and web use. Tasks and Checklist History never had
tables. G2 is not triggered: no data destroyed, no migration.

## 3. Data model
No change. `tcg-prisma-guardian` not required (no schema diff).

## 4. API surface
Remove two routes (REQ-04). Response-shape change class: removal → `tcg-contract-tracer`
required (G5). Web: no callers found by grep of `apps/web/src`, `packages`, `qa-automation`.

## 5. Web surface
None.

## 6. Mobile surface
REQ-01..03. Expo Router groups unchanged; `menu/` keeps `certifications`.

## 7. Shared package
None found.

## 8. Permissions and tenancy
N/A — no new queries.

## 9. Validation rules
N/A.

## 10. Tests
`not requested`. Delete tests of removed code only; update the three existing tests named in
REQ-02. Run existing: `pnpm nx test mobile`, API `me` specs.

## 11. Non-functional
Old installed app builds still call `/me/labor` and `/me/performance` (see Q1).

## 11a. Ripple
- Old mobile builds: Labor screen and the post-login performance prefetch get 404.
- Employees lose in-app view of hours, pay class, hourly rate, gross pay. Payroll data is
  unaffected.
- `PAYROLL-FLAGS` REQ-20/REQ-33 text says Labor & Unit screen agrees with `/me/labor`; the
  in-ticket Labor step still computes the same hours via `labor-hours`.

## 11b. AI decisions — reviewed by a developer

| # | Decision | Why |
| --- | --- | --- |
| D1 | Interpret "My Labour" as the `My Labor` row | Only labor row in the menu |
| D2 | Also remove `GET /me/performance` and `PerformanceSection` | Single consumer is the Labor screen (+ login prefetch) |
| D3 | Two units: mobile first, API second, stacked | Contract removal must not precede the callers (G5) |
| D4 | No DB change | §2 REQ-05 |
| D5 | Delete tests of removed code, add none | CLAUDE.md: no new tests |

## 11c. Siblings
`menu.tsx` rows pattern: no sibling menu in other personas (checked `app/` groups by name
only; executor to confirm `grep -rn "menu/" apps/mobile/app`).

## 12. Open questions

### Q1 — When may the API endpoints go? (blocks U2 only)
Installed field apps will break on Labor after U2. Options: A) ship U2 after U1 is the
minimum supported build, B) ship U1 and U2 together, accepting broken old builds, C) keep
the endpoints (U2 dropped). Recommended: A. **Answer:** _pending_

### Q2 — Is "My Labour" the "My Labor" row?
Assumed yes (D1). **Answer:** _pending_ (veto only)

## 13. What this spec deliberately does not specify
- Vault edits: pages `vault/field-ops/field-app-demo-2026-06.md`,
  `atom-mobile-app-user-stories/05-compliance-labor-and-review.md` and
  `01-authentication-and-dashboard.md` describe these screens; update via `tcg-scrum` after
  merge.
- Whether the in-ticket Labor step keeps its hours display.

## 14. Sign-off before build
- [ ] Q1 answered by a named developer.
