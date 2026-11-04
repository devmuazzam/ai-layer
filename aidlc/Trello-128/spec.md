# Spec — Trello-128 Configure OTA

> Ticket: Trello card #128 (`VZ571QGa`), "Configure OTA" —
> https://trello.com/c/VZ571QGa/128-configure-ota.
> Path A. Written 2026-10-30 and finalised the same day from the developer's decisions (§11b DS1–DS16; A1–A13 approved 2026-10-30; limits accepted 2026-10-30, §11b DS17–DS21):
> five build profiles, two channels, silent OTA, one Firebase project with two new crash attributes.
> The Trello card body was **not read** by the AI (the page returned only a loading error), so every
> requirement comes from the developer's stated direction. Nothing is built yet.
>
> **Domains are locked (§11b DS7):** staging `app.craneguys.com`, production `portal.craneguys.com`,
> confirmed by Ali Ghazi and relayed by the developer. Four deploy files in this repo say the opposite —
> recorded as a non-blocking follow-up (§12 Q1), not as a blocker. A direct consequence is in §2: the
> existing TestFlight builds already point at the production host.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | Trello #128 `VZ571QGa` (no SCRUM/TCG id; folder named `Trello-128`) |
| Intent | developer direction in chat, 2026-10-29 → 2026-10-30 |
| Elaborated on | 2026-10-30 (finalised) |
| Vault state at elaboration | no vault module covers OTA. One related note: `aidlc/SCRUM-OFFLINE-SYNC/design/plan.md` records that a native module needs a new EAS build and an OTA update will not carry it |
| Verified in this repo (read, not run end to end) | `eas update --help` (eas-cli 26.0.0): `--environment` is **required for Expo SDK 55+**; `--skip-bundler`, `--input-dir`, `--channel`, `--emit-metadata`, `--rollout-percentage` exist. `eas build:list --help`: `--channel`, `--runtime-version`, `--build-profile`, `--git-commit-hash`, `--json`, `--limit`. `@expo/env@2.4.3`: `EXPO_NO_DOTENV` switches `.env` loading off, and `.env` files never override variables already in the process environment. `.gitignore`: `.env` and `.env*.local` are ignored. Profile names are read in `apps/mobile/app.config.ts:13` and `apps/mobile/scripts/collect-crash-artifacts.js:8`. `eas.json` has one `submit.production.ios` entry and no Android submit entry; the old `preview` profile sets `android.buildType: apk`. `GET /api/v1/health` reports only `status` and the database, not the environment |
| Open questions raised by this spec | 2 (§12), neither blocks |
| Already-shipped behaviour reached | mobile `app.json`, `eas.json`, `app.config.ts`; the TestFlight submit path; the Crashlytics provider |
| Rules consulted | `CLAUDE.md`, `.claude/CLAUDE.md`, `apps/mobile/CLAUDE.md` |

## 1. Requirements ledger

All sources are `developer` direction (chat), status `[UNVERIFIED]` — no vault or product document exists for this feature.

| Req | Title | Surface | Flag | Blocks build? |
| --- | --- | --- | --- | --- |
| REQ-01 | The app checks for an OTA update when it starts | mobile | `[UNVERIFIED]` | no |
| REQ-02 | An available update downloads silently in the background | mobile | `[UNVERIFIED]` | no |
| REQ-03 | The running session is never reloaded or interrupted | mobile | `[UNVERIFIED]` | no |
| REQ-04 | The downloaded update applies automatically on the next cold launch | mobile | `[UNVERIFIED]` | no |
| REQ-05 | No banner, popup, notification or Restart button; no foreground update check | mobile | `[UNVERIFIED]` | no |
| REQ-06 | Exactly two publishable channels, `staging` and `production`, named by the API they serve; **a staging update never reaches a production build and the reverse** | eas | `[UNVERIFIED]` | no |
| REQ-07 | Staging = `https://app.craneguys.com/api/v1`, production = `https://portal.craneguys.com/api/v1` (confirmed by Ali Ghazi) | eas | `[UNVERIFIED]` | no |
| REQ-08 | Publishing is manual and local: no CI, no `EXPO_TOKEN` in CI, **no EAS dashboard variables added or changed** | process | `[UNVERIFIED]` | no |
| REQ-09 | The publisher names `staging` or `production` explicitly every time; there is no default | process | `[UNVERIFIED]` | no |
| REQ-10 | The correct API URL is embedded in the OTA bundle, and local development URLs cannot reach a published bundle | process | `[UNVERIFIED]` | no |
| REQ-11 | Before publishing, every build on the target channel is checked for channel, runtime version **and API URL** | process | `[UNVERIFIED]` | no |
| REQ-12 | Exactly five build profiles — `development`, `preview-staging`, `testflight-staging`, `preview-production`, `production` — with the mappings in §2; `production` is the one profile for TestFlight, App Store and Google Play | eas | `[UNVERIFIED]` | no |
| REQ-13 | Simple, guarded commands for staging and production publishing | process | `[UNVERIFIED]` | no |
| REQ-14 | `development` builds never receive a manually published OTA | eas | `[UNVERIFIED]` | no |
| REQ-15 | The API URL of every profile is consistent with its channel | eas | `[UNVERIFIED]` | no |
| REQ-16 | Crashlytics gets two custom attributes, `channel` and `updateId`, in the one existing Firebase project | mobile | `[UNVERIFIED]` | no |
| REQ-17 | `preview-staging` produces an Android APK for direct installation, on the staging API and the staging channel | eas | `[UNVERIFIED]` | no |

| REQ-18 | Each target (staging, production) is published independently with its own safety checks; no staging-first prerequisite | process | `[UNVERIFIED]` | no |
| REQ-19 | The rollback command is documented and available for each target independently | process | `[UNVERIFIED]` | no |
| REQ-20 | A failed bundle verification exits non-zero and prints the rollback command for that target; it does not block the other target | process | `[UNVERIFIED]` | no |

Counts: 20 total — 0 verified, 20 unverified, 0 conflicted, 0 open.

## 2. Requirements

**What OTA carries.** JS and assets only. A new native module, a permission, native `app.json` config
or an Expo SDK change needs a new store build. OTA reaches only builds that already contain
`expo-updates`, so **one new build per profile is the prerequisite**.

**Silent behaviour (REQ-01 to REQ-05).** `expo-updates`' own default, so it needs **no application code**:
`updates.checkAutomatically: "ON_LOAD"`, `updates.fallbackToCacheTimeout: 0`; the app starts at once on
the bundle it has, a newer one downloads in the background and is used on the next cold launch;
application code never calls `Updates.reloadAsync()` and renders no update UI; no foreground check
(§11b DS1).

**Runtime version (§11b DS3).** `runtimeVersion: { "policy": "appVersion" }` = `app.json` `version`
(`1.0.0` today). **Whenever a change needs a new native build, `version` must be bumped first.**

**The five profiles (REQ-12, REQ-14, REQ-15, REQ-17).** A profile's API is set **per profile** in the
committed `eas.json` (the single source, §11d L1), and its channel is named after that API.
`EXPO_PUBLIC_API_URL` is removed from `build.base.env`, so no profile can inherit the wrong one. The old
`preview` profile is replaced; no other profile exists.

| Profile | API | OTA channel | Dashboard `environment` | Distribution | Purpose |
| --- | --- | --- | --- | --- | --- |
| `development` | staging | `development` — **never published** | `development` | dev client | developer testing |
| `preview-staging` | staging | `staging` | `preview` | internal, **Android APK** | Android staging build, installed directly |
| `testflight-staging` | staging | `staging` | `preview` | store | TestFlight staging testing |
| `preview-production` | production | `production` | `production` | internal, **Android APK** | internal production testing |
| `production` | production | `production` | `production` | store | TestFlight, App Store, Google Play |

| Environment | API URL | Host |
| --- | --- | --- |
| Staging | `https://app.craneguys.com/api/v1` | `app.craneguys.com` |
| Production | `https://portal.craneguys.com/api/v1` | `portal.craneguys.com` |

Both preview profiles are meant for Android (`android.buildType: apk`, as the old `preview` profile). An iOS
internal build would need registered ad hoc devices and is not asked for, so the preview profiles are built
with `--platform android`. Removed: `testflight-production` (never created) and the old `preview`.
`eas submit --profile production` targets App Store Connect and the TestFlight-or-release choice is made
there; `testflight-staging` submits to the **same** App Store Connect app (`ascAppId` unchanged). **Google
Play submission stays manual** (§11b DS14).

**Existing TestFlight builds — a consequence of DS7.** Today every profile in `eas.json` points at
`https://portal.craneguys.com/api/v1`, which is **production**. So the TestFlight builds that exist now
**talk to the production API**, not staging. They have no `expo-updates`, hence no channel, and can never
receive any OTA until replaced (§11d L8). U1 changes only the staging profiles (`development`,
`preview-staging`, `testflight-staging`) to `app.craneguys.com`; `production` and `preview-production` keep
today's URL.

**Never mixing environments (REQ-06, REQ-14, REQ-15).** Protection happens at four points, all at publish
time (§11d L14, L17):
1. `eas.json` is internally consistent: every profile on channel `staging` has the staging URL and every
   profile on channel `production` has the production URL.
2. Only two targets exist, chosen explicitly; `development` is refused.
3. Every build that would receive the update is checked against that target (below).
4. The bundle is scanned before and after publishing.

**Publishing workflow (REQ-08 to REQ-11, REQ-13).** One script (`units.md` U2), always run from `apps/mobile`:

1. Target is `staging` or `production`, required. Without `--publish` it only runs the checks and a
   test export. Before publishing it prints the target, channel and API URL; production then requires the
   typed confirmation phrase of §11b A12 (the word `production` and the API host).
2. Identity: `eas whoami` and the project in `app.json` are `the-crane-guys` — never Fittish.
3. Git: tracked files clean; HEAD pushed to `origin` (equal to `origin/<branch>`); **staging only from the `staging` branch, production only from `main`** (§11b A7).
4. Config: the script's two constants (channel ↔ API URL) are compared with `eas.json`.
5. **Builds that would receive this update.** The runtime is `expo.version`. For the target channel and
   runtime the script lists builds with `eas build:list --channel <channel> --runtime-version <v> --json`
   per platform. It requires at least one build, and for **every** build:
   - its build profile is allowed for that channel: `testflight-staging` or `preview-staging` for `staging`;
     `production` or `preview-production` for `production`;
   - `eas.json` **as it was at that build's git commit** (`git show <hash>:apps/mobile/eas.json`) gave
     that profile the target API URL — so a profile edited after the build was made is still caught.
   Any build on the other environment, or on an unknown profile, stops the publish. The exact JSON field
   names are confirmed at implementation (`--build-profile` and `--git-commit-hash` filters exist).
   `eas channel:view <channel>` must succeed too.
6. Environment: the process environment is **rebuilt**, not inherited — every `EXPO_PUBLIC_*` and
   `REACT_NATIVE_PACKAGER_HOSTNAME` from the shell is dropped, `EXPO_NO_DOTENV=1` stops `.env` and
   `.env.local` from being read, and the target profile's `env` from `eas.json` (`testflight-staging` for
   staging, `production` for production) is the only source.
7. Test export with that environment; the bundle must contain the expected API URL and none of the
   forbidden ones (private IPs, `localhost`, `10.0.2.2`, the code's own fallback IP).
8. `eas update --channel <channel> --environment <preview|production> -m <message> --non-interactive`
   with the same environment (staging uses the EAS environment named `preview`).
9. The exported bundle folder is scanned again; if it fails, the script exits non-zero and prints
   the rollback command.

**Independent publishing (REQ-18 to REQ-20, §11b DS21).** Each target is published independently.
There is no staging-first prerequisite, no shared verification record, and no cross-target gate.
Safety checks that remain per target:

1. **All pre-publish checks (steps 1–7 in the workflow above)** run for every publish, regardless of target.
2. **Target confirmed.** Production prints target, channel and API URL and needs the typed phrase (A12).
3. **Verify after every publish.** The exported bundle is scanned (step 9). A failure exits non-zero
   and prints the rollback command. It does not block the other target.
4. **Rollback available.** `ota:rollback staging` and `ota:rollback production` are independent commands.

**Environment values (REQ-10).** The 11 `EXPO_PUBLIC_*` variables already in `eas.json` come from there
and from nowhere else. `eas update` **requires** `--environment` on SDK 57, so EAS also loads the 5
variables that already exist in the dashboard (`EXPO_PUBLIC_APPLE_TEAM_ID`, `EXPO_PUBLIC_CLARITY_PROJECT_ID`,
`EXPO_PUBLIC_GOOGLE_MAPS_API_KEY` and the two Google file variables). Nothing is added or changed there, and
the Maps key and Clarity id still reach the bundle — they are marked Sensitive, so they cannot be pulled to
the laptop (§11d L3). The script checks that none of the 11 names is also defined in that EAS environment.

**Crashlytics attributes (REQ-16, §11b DS12, DS13).** The existing single Firebase project stays; none is
created. `providers/crashlytics-provider.tsx` already sets `appVersion` and `appBuild`; it also sets
`channel` (the running build's channel, `none` when it has none, e.g. in development) and `updateId` (the
running update, `embedded` when the build is running its own bundle). A crash then says whether it came from
a staging or production OTA. The first seven characters of the `updateId` can be displayed in the
field menu and sales settings (approved). This is application code and is built in U3, not now.

## 3. Data model

N/A.

## 4. API surface

N/A. API base = domain + `/api/v1`, verified in code: `apps/api/src/main.ts:72-76` (`setGlobalPrefix('api')`
and URI versioning, default `1`) and `apps/web/next.config.ts:81`.

## 5. Web surface

N/A.

## 6. Mobile surface

No screen changes. U3 adds two Crashlytics attributes and no UI.

## 7. Shared package

N/A.

## 8. Permissions and tenancy

N/A. EAS account and project: `the-crane-guys`. The script refuses any other account or project id.

## 9. Validation rules

`pnpm nx run @tcg/mobile:typecheck`, `:lint`, `:test` (including `app.config.test.ts`) stay green.
`npx expo config --type public` shows `updates.url` and `runtimeVersion`.

## 10. Tests

Not requested (CLAUDE.md rule). Verification is the device check in `units.md`.

## 11. Non-functional

Offline or no network at start: the app opens on the cached or embedded bundle. Rollback and a staged
rollout are available through `eas update:rollback`, `eas update:republish` and `--rollout-percentage`
(flags to be checked with `--help` when the runbook is written).

## 11a. Ripple

- `apps/mobile/package.json` + `pnpm-lock.yaml`: one new dependency (approved, G5).
- `eas.json` today gives **every** profile the URL `https://portal.craneguys.com/api/v1` (production under
  DS7). After U1: `production` and `preview-production` keep it; `development`, `preview-staging` and
  `testflight-staging` use `https://app.craneguys.com/api/v1`. The old `preview` is replaced by
  `preview-staging` and `preview-production`.
- **Profile names are read in code:** `app.config.ts:13` and `scripts/collect-crash-artifacts.js:8` treat only
  `preview` and `production` as release builds. With the new names the new profiles would silently stop
  requiring the Firebase files. Both change to "any profile except `development`" (A9). Existing
  `app.config.test.ts` cases (`preview`, `production`, unset) keep passing.
- To put a **staging** build on TestFlight: `testflight-staging`. `production` is production data.
- Trello-115 headers are unaffected: OTA does not change the native version.

## 11b. Developer decisions

*Decided by* is the developer (Haris), chat 2026-10-30, unless a name is given.

| ID | Decision | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- |
| DS1 | Update behaviour | silent: check on start, background download, apply on next cold launch; no UI, no reload, no foreground check | developer | 2026-10-30 |
| DS2 | New dependency `expo-updates` | approved | developer | 2026-10-30 |
| DS3 | Runtime version policy | `appVersion` (not `fingerprint`) | developer | 2026-10-30 |
| DS4 | Publishing | manual; no GitHub Actions, no `EXPO_TOKEN` in CI | developer | 2026-10-30 |
| DS5 | PR base | `staging` | developer | 2026-10-30 |
| DS7 | **Domains, locked:** staging = `https://app.craneguys.com`, production = `https://portal.craneguys.com`; API base = domain + `/api/v1`. **Confirmed by Ali Ghazi**, relayed by the developer. `deploy/README.md`, `deploy/env/production.sh`, `deploy.yml` and the web `staging` script say the opposite — §12 Q1, non-blocking | locked | developer, confirmed by Ali Ghazi | 2026-10-30 |
| DS8 | No EAS dashboard variables are configured or changed; API URLs are managed on the developer's machine; the developer picks the target environment explicitly at every publish | decided | developer | 2026-10-30 |
| DS9 | Final profile set, five profiles: `development`, `preview-staging`, `testflight-staging`, `preview-production`, `production`; `testflight-production` removed; `production` serves TestFlight, App Store and Google Play | decided | developer | 2026-10-30 |
| DS10 | Two publishable channels, `staging` and `production`; `development` builds get no manual OTA; the two environments never share a channel | decided | developer | 2026-10-30 |
| DS11 | Publishing safety checks are kept | decided | developer | 2026-10-30 |
| DS12 | Keep the single existing Firebase/Crashlytics setup; no second Firebase project | decided | developer | 2026-10-30 |
| DS13 | Add Crashlytics attributes `channel` and `updateId` | decided | developer | 2026-10-30 |
| DS14 | Google Play submission stays manual for now; automated submission is configured later, when the apps are public | decided | developer | 2026-10-30 |
| DS15 | Keep the single bundle id and single TestFlight app. Staging and production builds cannot be installed side by side; to switch, uninstall the app and install the other environment | decided | developer | 2026-10-30 |
| DS16 | `preview-staging` is added back: an Android APK for direct installation, staging API, channel `staging` | decided | developer | 2026-10-30 |
| DS17 | ~~**L3 accepted**, with these rules: staging OTA is published and verified first; API URL and target channel are confirmed before a production publish; the bundle is verified after every publish; the rollback command is documented and tested; a failed verification stops the production publish process~~ | **superseded by DS21** | developer | 2026-10-30 |
| DS18 | ~~**L4 accepted**; verification on staging is mandatory (it confirms the two assumptions in L4 before any production publish)~~ | **superseded by DS21** | developer | 2026-10-30 |
| DS19 | L11, L12, L16, L18 accepted; **L17 accepted as a future backend improvement** (an environment field on `/health`, not in this ticket) | decided | developer | 2026-10-30 |
| DS20 | ~~**A11 approved with shared state:** the verification record is shared across authorized machines via a dedicated orphan branch `ota-state` in the main repo, removing the single-laptop limitation (L19 resolved). Local cache is kept for performance. No GitHub Actions, no EXPO_TOKEN, no secrets in Git~~ | **superseded by DS21** | developer | 2026-10-30 |
| DS21 | **Option A — Independent Publishing:** staging and production publish independently with their own safety checks. No staging-first prerequisite, no shared verification record (`ota-state` branch removed), no cross-target gate. All per-target safety checks (pre-publish checks, bundle scan, typed production confirmation, rollback) remain. Supersedes DS17, DS18, DS20 | decided | developer | 2026-11-02 |
| A1 | `updates.url` = `https://u.expo.dev/<app.json extra.eas.projectId>` | AI proposal — **approved** | developer | 2026-10-30 |
| A2 | Why `appVersion`, not `fingerprint`: `app.config.ts` adds the Firebase plugins and `googleServicesFile` only when the profile is a release one or the files exist locally, so a laptop's fingerprint could differ from the EAS-built app's and the update would silently not match. Inferred from reading the file, **not run** | rationale for DS3 — **approved** | developer | 2026-10-30 |
| A3 | Allowed build profiles per channel: `staging` ← `testflight-staging`, `preview-staging`; `production` ← `production`, `preview-production` | follows from DS9 and DS10 — **approved** | developer | 2026-10-30 |
| A4 | `EXPO_PUBLIC_API_URL` set per profile, removed from `base`; `eas.json` is the single source | AI proposal — **approved** | developer | 2026-10-30 |
| A5 | `submit.testflight-staging.ios.ascAppId` = the same `6809459658` as `submit.production`; `autoIncrement: true` on `testflight-staging` too; the two preview profiles have no `submit` entry | AI proposal — **approved** | developer | 2026-10-30 |
| A6 | Dashboard `environment` follows the API: staging profiles → `preview`, production profiles → `production`, `development` → `development` (the dashboard has only these three) | AI proposal — **approved** | developer | 2026-10-30 |
| A7 | Script guards: dry run unless `--publish`; prints target, channel and API URL; **explicit production confirmation** (type `production`); tracked files clean; HEAD pushed to `origin`; **staging OTA only from the `staging` branch**; **production OTA only from `main`** | approved with these rules | developer | 2026-10-30 |
| A8 | Runbook lives in `deploy/README.md`, a new "Mobile OTA updates" section | AI proposal — **approved** | developer | 2026-10-30 |
| A9 | Release detection in `app.config.ts` and `collect-crash-artifacts.js` becomes "any profile except `development`" | AI proposal — **approved** | developer | 2026-10-30 |
| A10 | `channel` is `none` and `updateId` is `embedded` when the build has no channel or is running its own bundle | AI proposal — **approved** | developer | 2026-10-30 |
| A11 | ~~The verification record is shared across machines via a dedicated orphan branch `ota-state`.~~ **Superseded by DS21:** no shared verification record. Each target publishes independently with its own per-publish safety checks | **revised** | developer | 2026-11-02 |
| A12 | The production confirmation phrase is the word `production` followed by the API host (for example `production portal.craneguys.com`), so the URL has to be read to be typed | **approved** | developer | 2026-10-30 |
| A13 | A failed verification exits non-zero and prints the rollback command for that target. No cross-target block. Helper commands `ota:rollback` (a guarded wrapper of `eas update:rollback`) and `ota:status` (prints the last publish per channel) | **revised** | developer | 2026-11-02 |

## 11c. Siblings

None — no existing OTA pattern in `patterns.md` (not opened; ❓).

## 11d. Technical limitations (to know before implementation)

| # | Limitation | Consequence |
| --- | --- | --- |
| L1 | EAS cloud builds cannot read files on the developer's laptop, and `.env` / `.env*.local` are gitignored so they are never uploaded | Build-time API URLs **must** live in the committed `eas.json`. If OTA URLs lived only on the laptop, an OTA and its build could point at different APIs. So "managed locally" means: the copy of `eas.json` on the laptop; the script reads it and compares it with its own constants |
| L2 | `eas update` **requires `--environment`** on SDK 57 | EAS still loads the existing dashboard variables of that environment. Nothing is added there, but the dashboard is not out of the loop |
| L3 | The Maps key, Clarity id and Apple team id exist only in the dashboard and are Sensitive, so they cannot be pulled to the laptop | The bundle cannot be exported on the laptop and uploaded with `--skip-bundler` without losing them. `eas update` must do the bundling itself, so there is no pause between bundling and upload. Mitigation: a test export first (with the 11 variables), then a scan of the real export after publishing and a printed rollback command. A small window remains in which a wrong bundle is live |
| L4 | Two things are assumed, not verified: `eas update` passes the script's process environment to the bundler; and `eas build:list --json` exposes the build profile and git commit under names the script can read | Both are confirmed on the first `staging` publish and with `--json` output at implementation |
| L5 | The exported bundle is Hermes bytecode and may not contain the URL as plain text | The scan must be validated against a known-good export first; third-party libraries may add false positives for `localhost` |
| L6 | Anyone can still run `eas update` by hand and skip the script | Documented as forbidden; not technically blocked |
| L7 | `appVersion` cannot detect a native change | The runbook checklist (bump `version` first) is the only guard. An optional native-fingerprint guard needs a new dependency and is **not included** unless approved |
| L8 | Existing TestFlight builds have no `expo-updates`, and they point at `portal.craneguys.com`, which is **production** under DS7 | They receive no OTA, including bug fixes, until replaced by a new build, and they are production-data builds today |
| L9 | A channel can be re-pointed on the EAS server by anyone with access | The script checks `eas channel:view` before publishing; it cannot prevent a change afterwards |
| L10 | The script is Node (`.mjs`), not bash — the machine is Windows | None; stated so nobody ports it to shell |
| L11 | One bundle id, one TestFlight app — **accepted (DS15)**: staging and production builds cannot be installed side by side | To switch, uninstall the app and install the other build; uninstalling also clears the stored sign-in tokens and offline cache. Side by side would need a second bundle id, App Store Connect app and Firebase, push and associated-domain setup — **not in this ticket** |
| L12 | The two environments report to the same Firebase app — **accepted (DS12)** | Crash reports mix; the `channel` and `updateId` attributes (DS13) tell them apart |
| L13 | `apps/mobile` universal links are registered for `portal.craneguys.com` only (`app.json`: `applinks:portal.craneguys.com`; the SMS invite link) | That is the **production** host under DS7, so staging builds cannot open activation links on `app.craneguys.com`. §12 Q2 |
| L14 | All protections are at publish time; the running app does not check that its bundle matches its channel | A hand-run `eas update` (L6) could still cross environments, and the app would not notice |
| L15 | ~~No installable staging build for Android~~ | **Resolved by DS16** (`preview-staging`) |
| L16 | `eas.json` has no Android `submit` entry; DS9 makes `production` the Google Play profile | **Accepted (DS14):** Play uploads stay manual until the apps are public |
| L18 | Staging OTA publishes only from the `staging` branch (A7) | A change cannot be tried by OTA from a feature branch: it must be merged into `staging` first, and U1 and U2 must be merged there before the first publish. A broken change merged into `staging` is therefore the thing that reaches staging builds |
| L17 | The API does not report which environment it is (`/health` returns only status and database), so the script cannot ask a server which environment it is talking to | The mapping in DS7 can only be checked against people and files. The script therefore prints the target, channel and API URL before publishing and makes production require typing the word `production`. An optional later hardening is an environment field on `/health` — a backend change, not in this ticket |
| L19 | ~~The record behind the gates lives on the publisher's laptop~~ | **Removed (DS21):** no shared verification record exists under Option A. Each target publishes independently |

**Accepted by the developer on 2026-10-30:** L3 (with the five rules of DS17), L4 (staging verification mandatory),
L11, L12, L16, L17 (future backend improvement) and L18. L1, L2, L5–L10, L13 and L14 are facts, and L15 is resolved;
they stand as written. L19 is removed (DS21: no shared record under Option A).

## 12. Open questions

Nothing in this section blocks building. Resolved by the developer on 2026-10-30: the domain mapping (DS7, Ali Ghazi),
the Android staging APK (DS16), manual Google Play submission (DS14), the single bundle id (DS15).

### Q1 — Deploy files still describe the opposite mapping

- **Question:** `deploy/README.md` (Environments table: staging host `portal`, production host `app`),
  `deploy/env/production.sh` (`DOMAIN_NAME=app.craneguys.com`), `.github/workflows/deploy.yml` (`portal` → the
  `staging` GitHub Environment, default `app`) and the `staging` script in `apps/web/package.json` (proxies to
  `portal`) all say staging is `portal` and production is `app`. DS7 says the reverse. Who owns correcting them,
  and is it possible that the deploy tooling and the DNS are really arranged the way those files say?
- **Blocked:** nothing in this ticket. The OTA script follows DS7 and prints the host before it publishes, so a
  wrong mapping would be seen at the typed confirmation. Anyone running `deploy/deploy.sh` meanwhile should
  know the files disagree with DS7.
- **Owner:** Ali Ghazi / developer
- **Status:** open, not blocking

### Q2 — Universal links for the staging host

- **Question:** L13. Should `app.craneguys.com` (staging under DS7) also be registered for universal links
  (`applinks:` in `app.json`, Android intent filters, and the `apple-app-site-association` and `assetlinks.json`
  files on that host)? Recommended: a separate ticket, because part of it is on the web host.
- **Blocked:** nothing in this ticket. Staging builds work except for opening activation links.
- **Owner:** developer / Asfad
- **Status:** open, not blocking

## 13. What this spec deliberately does not specify

- CI publishing (DS4), code signing, web, the EAS dashboard variables (DS8).
- An update banner, popup, notification or Restart button (REQ-05).
- Any host other than the two named in DS7.
- Moving or adding mobile deep links (§12 Q2).
- Installing staging and production builds side by side (DS15, L11).
- Automated Google Play submission (DS14).
- A native-fingerprint guard (L7).
- Update ids or channels shown in screens (a version-label change was dropped).
- A second Firebase project (DS12).
- An iOS internal (ad hoc) build.

**Follow-ups outside this ticket:** an environment field on `/health` (L17); correcting the deploy files (§12 Q1);
universal links for the staging host (§12 Q2); automated Google Play submission (DS14); installing staging and
production side by side (DS15); a native-fingerprint guard (L7).

## 14. Sign-off before build

- [x] No `[OPEN]` requirement
- [x] No `[CONFLICT]` requirement
- [x] No blocking question (§12 Q1 and Q2 do not block)
- [x] A1–A10 approved individually by the developer (2026-10-30; A7 with the branch rules)
- [x] L3 (with DS17), L4 (DS18), L11, L12, L16, L17 and L18 accepted by the developer (2026-10-30)
- [x] A11–A13 revised (2026-11-02; DS21 Option A — Independent Publishing; DS17, DS18, DS20 superseded; L19 removed)
