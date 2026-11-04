# Units — Trello-128 Configure OTA

Three stacked code units, one PR each, base `staging` (DS5). Nothing is built yet. The earlier **U0
(EAS dashboard variables) is withdrawn** — the developer decided not to configure any (DS8).

> No blocker. Domains are locked (DS7, confirmed by Ali Ghazi): staging `app.craneguys.com`, production
> `portal.craneguys.com`. A1–A10 are approved and L3, L4, L11, L12, L16, L17 and L18 are accepted (2026-10-30). A11–A13 revised for Option A (DS21 — Independent Publishing; DS17, DS18, DS20 superseded). Only the word to begin remains.

## Unit ledger

| Unit | Branch | Base | Source lines / files (excl. tests) | Status |
| --- | --- | --- | --- | --- |
| U1 — `expo-updates`, five profiles, channels, per-profile API URL | `feat/trello-128-u1-ota-setup` | `origin/staging` | ~100 / 6 | not started — waits for the word to begin |
| U2 — guarded manual publish script for staging and production | `feat/trello-128-u2-ota-publish-scripts` | U1 | ~300 / 4 | not started |
| U3 — Crashlytics attributes `channel` and `updateId` | `feat/trello-128-u3-ota-crash-attributes` | U2 | ~10 / 1 | not started |

Commit messages:

- U1: `feat(mobile): add expo-updates and five build profiles with matching OTA channels (Trello-128 U1)`
- U2: `feat(mobile): add guarded manual OTA publish scripts for staging and production (Trello-128 U2)`
- U3: `feat(mobile): report the OTA channel and update id to Crashlytics (Trello-128 U3)`

## Profile and channel mapping (the one table all three files share)

| Profile | API | OTA channel | Dashboard `environment` | Distribution | Purpose | Script target |
| --- | --- | --- | --- | --- | --- | --- |
| `development` | staging | `development` | `development` | dev client | developer testing | **refused** |
| `preview-staging` | staging | `staging` | `preview` | internal, Android APK | Android staging build, installed directly | `staging` |
| `testflight-staging` | staging | `staging` | `preview` | store | TestFlight staging testing | `staging` |
| `preview-production` | production | `production` | `production` | internal, Android APK | internal production testing | `production` |
| `production` | production | `production` | `production` | store | TestFlight, App Store, Google Play | `production` |

| Environment | API URL |
| --- | --- |
| Staging | `https://app.craneguys.com/api/v1` |
| Production | `https://portal.craneguys.com/api/v1` |

Removed: `testflight-production`, and the old `preview`. Google Play submission is manual (DS14).

## U1 — `expo-updates`, five profiles, channels, per-profile API URL

### Slice contents

| File | Change |
| --- | --- |
| `apps/mobile/package.json` + `pnpm-lock.yaml` | `expo-updates` at the SDK 57 version (`npx expo install expo-updates`); the lockfile must contain **only** this change, so build U1 in a clean worktree from `origin/staging` |
| `apps/mobile/app.json` | `updates` (`url`, `checkAutomatically: ON_LOAD`, `fallbackToCacheTimeout: 0`) and `runtimeVersion: { policy: appVersion }` |
| `apps/mobile/eas.json` | `EXPO_PUBLIC_API_URL` removed from `base`; exactly the five profiles above, each with its API URL, `channel` and `environment`; `android.buildType: apk` on the two preview profiles; `submit.testflight-staging` with the same `ascAppId` as `submit.production`. Credentials and the EAS project are not touched |
| `apps/mobile/app.config.ts` and `apps/mobile/scripts/collect-crash-artifacts.js` | release detection becomes "any profile except `development`" (A9), so the new profile names keep requiring the Firebase files |

### Ripple

- Needs new builds before any OTA can reach a device; **until then no OTA is possible**. The old
  `preview` profile no longer exists — use `preview-staging` or `preview-production`.
- Today every profile uses `portal.craneguys.com`, which is production. After U1 `production` and
  `preview-production` keep it; `development`, `preview-staging` and `testflight-staging` move to
  `app.craneguys.com`.
- The TestFlight builds that exist now already talk to the production API and get no OTA (`spec.md` L8).
- To put a **staging** build on TestFlight: `testflight-staging`, not `production`.
- The existing `app.config.test.ts` cases (`preview`, `production`, unset) stay valid.

### Build commands the runbook will list

| To make | Command |
| --- | --- |
| an Android APK on staging | `eas build --profile preview-staging --platform android` |
| a TestFlight build on staging | `eas build --profile testflight-staging --platform ios`, then `eas submit --profile testflight-staging` |
| a build on production for TestFlight, App Store or Google Play | `eas build --profile production`, then `eas submit --profile production` (iOS); Google Play upload is manual |
| an internal Android APK on production | `eas build --profile preview-production --platform android` |

### Verification (nothing run yet)

1. `pnpm nx run @tcg/mobile:typecheck`, `:lint`, `:test` (includes `app.config.test.ts`).
2. `npx expo config --type public` shows `updates.url` and `runtimeVersion`.
3. A `preview-staging` APK and a `preview-production` APK, so a build exists on each channel before the first
   publish. Never use a store profile as a throwaway test.

## U2 — guarded manual publish script

### Slice contents

| File | Change |
| --- | --- |
| `apps/mobile/scripts/ota.mjs` | the script below; Node, no new dependency |
| `apps/mobile/package.json` | scripts `ota:check`, `ota:staging`, `ota:production`, `ota:rollback`, `ota:status` |
| ~~`.gitignore`~~ | ~~one entry for `apps/mobile/.ota/`~~ **removed (DS21)**: no local cache needed |
| `deploy/README.md` | "Mobile OTA updates" section: the profile table, the commands, the checklist for native changes, rollback and staged rollout, never run `eas update` by hand |

### Commands (exact invocation settled at implementation; Nx targets)

```text
ota:check                                  # offline: eas.json and app.json are consistent
ota:staging    -m "message"                # checks + test export only
ota:staging    -m "message" --publish      # then publishes to the staging channel
ota:production -m "message" --publish      # checks + asks you to type: production <host>
ota:rollback   staging|production          # guarded wrapper of: eas update:rollback <GROUPID> --non-interactive
ota:status                                 # prints the last publish per channel (from EAS)
```

### What the script does, in order — it stops at the first failure

| # | Step | Prevents |
| --- | --- | --- |
| 1 | Target is exactly `staging` or `production`; `-m` message required; `development` is refused | publishing to a guessed or development target |
| 2 | `eas whoami` and the project in `app.json` are the Crane Guys account | publishing to the Fittish account |
| 3 | Tracked files clean; HEAD pushed to `origin` (equal to `origin/<branch>`); **staging only from the `staging` branch, production only from `main`** (A7) | an OTA nobody can reproduce; a publish from an unreviewed branch |
| 4 | ~~**Production only — release gates**~~ **Removed (DS21):** no staging-first prerequisite. Each target publishes independently | — |
| 5 | `eas.json` is consistent: every profile on channel `staging` has the staging URL, every profile on channel `production` has the production URL; the script's two constants are compared with it | a channel that serves the wrong API; a typo in either file |
| 6 | `expo.version` is the runtime. For the target channel and runtime, `eas build:list --channel <c> --runtime-version <v> --json` per platform returns ≥ 1 build, and **every** build's profile is allowed for that channel (`testflight-staging` or `preview-staging`; `production` or `preview-production`) and its `eas.json` at the build's git commit had the target API URL; `eas channel:view <c>` succeeds | an update that reaches nobody; an update that reaches a build on another API |
| 7 | The process environment is rebuilt: shell `EXPO_PUBLIC_*` and `REACT_NATIVE_PACKAGER_HOSTNAME` dropped, `EXPO_NO_DOTENV=1`, the target profile's `env` from `eas.json` added, `NODE_ENV=production` | `.env.local` or a shell variable leaking a local IP |
| 8 | Test export in a temp folder; must contain the expected API URL and none of: `http://10.`, `http://192.168.`, `http://172.16–31.`, `localhost`, `127.0.0.1`, `10.0.2.2`, the code's fallback `10.10.90.250` | a local URL in the bundle |
| 9 | Without `--publish`, stop here. Otherwise print the target, channel and API URL; **production needs the typed phrase** `production <api host>` (A12) | an accidental production publish; a wrong host going unnoticed (limit L17) |
| 10 | `eas update --channel <c> --environment <preview\|production> -m … --non-interactive` with the same environment | — |
| 11 | Scan the exported folder again. **On failure:** exit non-zero, print the rollback command. **On success:** print the update group id and the `eas update:view` command | a wrong bundle staying live unnoticed (limit L3) |

`ota:rollback` runs `eas update:rollback <GROUPID> --non-interactive` on the latest update of the chosen
channel (it republishes the previous update, or the embedded one when there is none). Each target's rollback
is independent (DS21).

The 11 variables come only from `eas.json`; the script also checks that none of them is defined in the EAS
environment it passes to `--environment` (limit L2). Nothing in the dashboard is added or changed.

### Verification (nothing run yet)

1. `ota:check` passes; break `eas.json` on purpose (staging URL under channel `production`) and see it fail.
2. With `.env.local` holding the laptop IP and a shell `EXPO_PUBLIC_API_URL` exported, `ota:staging`
   (no `--publish`) still reports the staging URL and no local IP.
3. Pretend a `production`-profile build sits on the `staging` channel (a stub of the `--json` output) and
   see step 5 refuse; try `development` as a target and see step 1 refuse.
4. The scan is validated first against a known-good export (limit L5).
5. First real publish is **staging** only, from the `staging` branch once U1 and U2 are merged there (A7), then a device check: open the app (still old), close it fully, open it again (new); airplane mode at start still opens the app. The same run confirms limit L4's two assumptions (the bundle holds the staging URL; `eas build:list --json` gives the profile and commit).
6. **Rehearse the rollback on staging** with `ota:rollback staging`; the app returns to the embedded or previous bundle on the next cold launch. Rollback is tested independently per target.
7. `ota:production` publishes independently; fail a scan on purpose and see it exit non-zero with the rollback command.

## U3 — Crashlytics attributes `channel` and `updateId`

### Slice contents

| File | Change |
| --- | --- |
| `apps/mobile/providers/crashlytics-provider.tsx` | in the existing mount effect, `setCrashAttribute('channel', …)` and `setCrashAttribute('updateId', …)` beside `appVersion` and `appBuild`; `none` / `embedded` when the build has no channel or runs its own bundle (A10) |

One existing Firebase project (DS12). No UI, no reload. The existing `crashlytics-provider.test.tsx` mocks
`@/lib/env`; it may also need an `expo-updates` mock — the AI will not add new tests, only keep that one green.
Depends on U1 (`expo-updates` installed); its crash attributes show real values only on builds from U1.

### Deliberately not in these units

EAS dashboard variables (DS8); CI publishing (DS4); a banner, popup or Restart button (REQ-05); a
foreground update check (DS1); a native-fingerprint guard (L7); side-by-side staging and production
installs (DS15); deep links for the staging host (Q2); automated Google Play submission (DS14); a second
Firebase project (DS12); version labels in screens; an iOS internal build.

## Sequencing

U1 → U2 → U3, each PR targeting the previous branch. New builds from U1 are the prerequisite for any OTA.
Implementation has not started and waits for the developer's word to begin.
