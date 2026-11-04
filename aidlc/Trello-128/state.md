# State — Trello-128 Configure OTA

**Path:** A · **Branch(es):** `feat/trello-128-u1-ota-setup`, `feat/trello-128-u2-ota-publish-scripts`, `feat/trello-128-u3-ota-crash-attributes` (none created) · **Last updated:** 2026-11-02 by the AI, Option A — Independent Publishing (DS21)

## Phases

- [S] Intent — no `intent.md`; the developer's direction is recorded in `spec.md` §0 and §11b
- [x] Spec — `spec.md`, final: five profiles, two channels, silent OTA, Crashlytics attributes, domains locked, A1–A13 (revised for DS21 Option A), limits accepted, L19 removed
- [x] Sign-off — `spec.md` §14: all items checked. A11–A13 revised for DS21 (Option A — Independent Publishing)
- [x] Units — `units.md` (U0 withdrawn; U1 setup and profiles, U2 publish script with release gates, U3 Crashlytics attributes)
- [ ] Build — not started; the developer said not to implement, branch, commit, push or publish yet
- [ ] Analyse
- [ ] Merged
- [ ] Reflect
- [ ] Closed

## Final profile and channel mapping

| Profile | API | OTA channel | Purpose |
| --- | --- | --- | --- |
| `development` | staging | `development` (never published) | developer testing |
| `preview-staging` | staging | `staging` | Android staging APK, installed directly |
| `testflight-staging` | staging | `staging` | TestFlight staging testing |
| `preview-production` | production | `production` | internal production testing (Android APK) |
| `production` | production | `production` | TestFlight, App Store, Google Play |

Staging `https://app.craneguys.com/api/v1`; production `https://portal.craneguys.com/api/v1` — **locked, confirmed
by Ali Ghazi** (DS7). Removed: `testflight-production`, and the old `preview`.

## Accepted on 2026-10-30

- **A1–A13 (A11, A13 revised for DS21).** A7 rules: staging OTA only from the `staging` branch; production OTA only from `main`;
  clean working tree; commit pushed to `origin`; explicit production confirmation.
  A11: revised — no shared verification record (DS21). A12: typed phrase `production portal.craneguys.com`.
  A13: revised — failure exits non-zero per target, no cross-target block; `ota:rollback` and `ota:status` helpers.
- **L3 accepted (DS17)** with: staging OTA published and verified first; API URL and target channel confirmed before
  production; bundle verified after every publish; rollback documented **and tested**; a failed verification stops
  the production publish process.
- **L4 accepted, staging verification mandatory (DS18).** L11, L12, L16, L18 accepted; **L17 accepted as a future
  backend improvement** (DS19). Earlier: DS14 Google Play manual; DS15 single bundle id; DS16 `preview-staging`.

## How the new rules are carried (U2)

**Option A — Independent Publishing (DS21).** Staging and production publish independently. There is no
staging-first prerequisite, no shared verification record, and no `ota-state` orphan branch. All per-target
safety checks remain: pre-publish checks (identity, git, config, builds, environment, bundle scan), the typed
production confirmation phrase (`production <api host>`), post-publish bundle scan, and independent rollback
per target. A failure on one target does not block the other.

## Remaining items (none blocks)

1. **§12 Q1:** `deploy/README.md`, `deploy/env/production.sh`, `deploy.yml` and the web `staging` script still describe
   the opposite mapping; someone owns correcting them. Owner: Ali Ghazi / developer.
2. **§12 Q2:** universal links are registered for `portal.craneguys.com` only, the production host; staging builds
   cannot open activation links.
3. **Consequence of DS7:** the TestFlight builds that exist now already talk to `portal.craneguys.com`, which is
   **production**, not staging (`spec.md` L8).

## Resume

The specification is final. All decisions (A1–A13, DS1–DS21) are approved/revised and all limits are accepted or resolved. DS21 (Option A — Independent Publishing) supersedes DS17, DS18, DS20. Units now carry the release gates: U2 is simplified to about 250 lines
in 3 files (the script, the package scripts and the runbook; the `.gitignore` entry for `.ota/` is removed). No code,
dashboard, branch, commit, push or publish has happened. Build starts only when the developer says so: branch from
`origin/staging`, implement, no commit, no push, and give the commit message.
