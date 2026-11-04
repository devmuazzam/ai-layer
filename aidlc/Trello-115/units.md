# Units — Trello-115 Version control

Three stacked units, one PR each (D13). Status and test results: `implementation.md`.

## Unit ledger

| Unit | Branch | Base | Source lines / files (excl. tests) | Budget |
| --- | --- | --- | --- | --- |
| U1 — shared contract + API | `feat/trello-115-u1-app-version-api` | `origin/main` `859dee4cc` | 506 / 25 | **over** (~400) — §12 Q1 |
| U2a — mobile headers, check, 426, force screen | `feat/trello-115-u2a-mobile-force-update` | U1 | 346 / 9 | within |
| U2b — soft dialog, persisted dismissal, per-platform interval | `feat/trello-115-u2b-mobile-soft-update` | U2a | 230 / 3 | within |

## U1 — shared contract + API

### Slice contents

| File | Change |
| --- | --- |
| `packages/shared/src/constants/app-version.ts` | headers, 426 code/status, platforms, default messages, interval bounds, `isMobilePlatform` |
| `packages/shared/src/utils/compare-app-versions.ts` | `parseAppVersion`, `compareAppVersions`, `isAppVersionBelow` |
| `packages/shared/src/types/app-version.types.ts` | `AppVersionStatus`, `AppUpdateRequiredError` |
| `apps/api/src/config/env.validation.ts` | 12 keys + object-level min ≤ latest rule |
| `apps/api/src/config/mobile-app.config.ts` | `registerAs('mobileApp')`, blank → default normalisation |
| `apps/api/src/utility/app-version-policy.ts` | pure `resolveAppVersionStatus`, `buildAppUpdateRequiredError` |
| `apps/api/src/guard/app-version.guard.ts` | global guard, first in `APP_GUARD` |
| `apps/api/src/usecase/app-version/*`, `presentation/app-version/*` | `GET /app-version` |
| `apps/api/src/decorator/skip-app-version-check.decorator.ts` | exemption; applied to health + the endpoint |
| `apps/api/src/filter/all-exceptions.filter.ts` | forwards the three 426 fields for `APP_UPDATE_REQUIRED` only |
| `deploy/README.md` | env table + release runbook |

### Ripple

Every HTTP route (guard first; header-less requests unchanged); every error body (filter change
scoped to one code); `public-route-allowlist.spec.ts` count.

## U2a — mobile force update

### Slice contents

| File | Change |
| --- | --- |
| `apps/mobile/lib/app-version.ts` | headers, 426 detection, store opening with fallback |
| `apps/mobile/lib/app-update-store.ts` | zustand store `none / required / available` |
| `apps/mobile/lib/base-api.ts` | headers on requests and refresh; 426 → store, no refresh |
| `apps/mobile/lib/query-client.ts` | no toast / no retry on 426 |
| `apps/mobile/lib/env.ts` | optional `EXPO_PUBLIC_STORE_URL_IOS/_ANDROID` fallback |
| `apps/mobile/hooks/use-app-version-check.ts` | launch + foreground check, 5 s timeout, fails open, ≤ 3 s splash hold |
| `apps/mobile/components/app-update/force-update-screen.tsx` | the force screen |
| `apps/mobile/components/splash/animated-splash.tsx` | `holdExit` prop |
| `apps/mobile/app/_layout.tsx` | wiring |

## U2b — mobile soft update

### Slice contents

| File | Change |
| --- | --- |
| `apps/mobile/lib/app-update-reminder.ts` | persisted dismissal + in-process session flag |
| `apps/mobile/components/app-update/soft-update-dialog.tsx` | centred dialog (E2) |
| `apps/mobile/app/_layout.tsx` | render after the splash |

### Deliberately not in this unit

Push announcements (D12); ECS task-definition keys (§12 Q2).

## Sequencing

U1 → U2a → U2b, each PR targeting the previous branch; GitHub retargets on merge.
