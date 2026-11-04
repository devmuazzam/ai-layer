# Trello-115 implementation status — 2026-10-27

Labels: ✅ run and passed · ❌ run and failed · 🔍 read in code · ❓ not run.

## Where it is

Isolated worktree `.worktrees/trello-115` (main checkout untouched), base `origin/main` `859dee4cc`.
Commits are **local only — nothing pushed, no PR opened** (blocked on spec §12 Q1, U1 size).

| Unit | Branch | Commit | Status |
| --- | --- | --- | --- |
| U1 | `feat/trello-115-u1-app-version-api` | `e418beeb9` | implemented, tests pass, over size budget |
| U2a | `feat/trello-115-u2a-mobile-force-update` | `a9e9e89f8` | implemented, tests pass |
| U2b | `feat/trello-115-u2b-mobile-soft-update` | `6506696ed` | implemented, tests pass |

## Test results

| Check | Result |
| --- | --- |
| `@tcg/shared` build | ✅ |
| Shared comparator tests (`compare-app-versions.test.mjs`) | ✅ 8/8 |
| New API specs (env schema, config, policy, guard over real HTTP + real filter, filter passthrough) | ✅ 66/66 |
| Full API jest (`pnpm nx run @tcg/api:test`) | ✅ 3448 passed; 1 failed (`public-route-allowlist.spec.ts`, caused by the new public route) → allowlisted with justification, spec re-run ✅ 3/3. The full suite was not re-run after that one-line change ❓ |
| `@tcg/api:build` | ✅ |
| API lint on changed files | ✅ 0 errors; 1 pre-existing warning in `health.controller.ts` (unused `HttpCode`) |
| Built API boot, refused cases (min 1.2.0 / latest 1.1.0; min set, latest unset; interval 721) | ✅ each exits 1 naming the variables. Run from the main checkout's `apps/api` (its `.env` read in place, not copied), `express` resolved from the main checkout (see T115-1) |
| Built API boot, happy path + curl `/app-version` | ❓ not run — a full boot against the local `.env` starts cron jobs that may send real email/SMS. Covered instead by the guard spec on a real HTTP server |
| `@tcg/mobile:typecheck` | ✅ (U2a and U2b) |
| Mobile lint on changed files | ✅ 0 errors, 0 warnings |
| Mobile feature tests (headers, 426, store, hook, force screen, splash hold, reminder, soft dialog) | ✅ 81/81 (Windows `transformIgnorePatterns` override, PROJECT_CONTEXT V-11) |
| Full mobile jest on U2b | ❌ 20 failed / 3214 passed. 19 of the 20 also fail on clean `origin/main` (same suites, verified in a baseline worktree) — pre-existing. The 20th (`quotes/create.test.tsx`) timed out under full-suite load and passes alone ✅ 50/50 |
| Device / emulator QA (force on launch / foreground / 426, soft dialog + restart, offline launch, store links, offline ticket sync after update) | ❓ not run — no device available to the AI |
| Staging / production | not touched |

## Implementation choices awaiting confirmation (spec §11b I1–I3)

- I1 — `AllExceptionsFilter` forwards `minSupportedVersion`, `latestVersion`, `storeUrl` only for `code: APP_UPDATE_REQUIRED` (the filter otherwise drops them, which would break the planned 426 contract).
- I2 — Android back on the soft dialog = "Maybe later".
- I3 — splash hold implemented as a `holdExit` prop on `AnimatedSplash`; capped at 3 s. In mock-mode dev builds with an unreachable API the splash now waits the full 3 s.

## Remaining

- Q1: U1 506 source lines (budget ~400) — `size-exception` label or split into shared + API PRs.
- Q2: `MOBILE_*` keys are not in `deploy/task-definitions/api.json`; the feature stays off in ECS until added.
- `apps/api/.env.example` not updated — the AI's permissions deny reading env files. The keys are documented in `deploy/README.md`.
- `EXPO_PUBLIC_STORE_URL_IOS/_ANDROID` fallback is optional and not set in `eas.json` (real store URLs were not supplied).
- Device QA matrix (plan §14) before release.
- These `.ai/` files are local; not committed to the overlay repo.
