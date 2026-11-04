# Spec — Trello-115 Version control

> Ticket: Trello card #115 (`XCKkawhU`), "Add version control in the mobile app" —
> https://trello.com/c/XCKkawhU/115-add-version-control-in-the-mobile-app.
> Path A. Written 2026-10-27 from the approved plan
> (`~/.claude/plans/tender-moseying-crown.md`, developer-approved 2026-10-27) and the developer's
> direction in the planning session. The Trello card body was **not read** by the AI; every
> requirement below comes from the developer's stated direction.
> Actual build and test status: `implementation.md` beside this file.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | Trello #115 `XCKkawhU` (no SCRUM/TCG id; folder named `Trello-115` by the developer) |
| Intent | developer direction in chat, 2026-10-26 → 2026-10-27 |
| Elaborated on | 2026-10-27 |
| Vault state at elaboration | not consulted — no vault module covers mobile version control (`grep -ril "force update\|app version" .ai/vault` not run; ❓) |
| Open questions raised by this spec | 2 (§12) |
| Already-shipped behaviour reached | every API route (global guard), the shared exception filter, mobile `base-api` / `query-client` / splash |
| Rules consulted | `CLAUDE.md`, `.claude/CLAUDE.md`, `apps/api/CLAUDE.md`, `apps/mobile/CLAUDE.md` |

## 1. Requirements ledger

All sources are `developer` direction (Asfad, chat), status `[UNVERIFIED]` — no vault or product document exists for this feature.

| Req | Title | Surface | Flag | Blocks build? |
| --- | --- | --- | --- | --- |
| REQ-01 | Per-platform min / latest versions from env; defaults turn every gate off | api | `[UNVERIFIED]` | no |
| REQ-02 | API refuses to start when min > 0.0.0 and latest < min; error names both vars | api | `[UNVERIFIED]` | no |
| REQ-03 | Mobile sends `x-app-version` + `x-app-platform` on every request | mobile | `[UNVERIFIED]` | no |
| REQ-04 | `GET /api/v1/app-version` returns `AppVersionStatus` | api, shared | `[UNVERIFIED]` | no |
| REQ-05 | Global guard answers 426 `APP_UPDATE_REQUIRED` to below-minimum builds | api | `[UNVERIFIED]` | no |
| REQ-06 | Non-dismissible force screen: rocket, "Update required", sentence, only "Latest version: X", "Update now" | mobile | `[UNVERIFIED]` | no |
| REQ-07 | Optional soft dialog behind per-platform toggles, default off | mobile, api | `[UNVERIFIED]` | no |
| REQ-08 | "Maybe later" persisted on device for the active reminder interval (per platform, 0–720 h, default 24; 0 = next cold start) | mobile, api | `[UNVERIFIED]` | no |
| REQ-09 | A newer latest version invalidates a dismissal; a required update always overrides it | mobile | `[UNVERIFIED]` | no |
| REQ-10 | Builds released before this feature are not blocked (accepted limitation) | — | `[UNVERIFIED]` | no |

Counts: 10 total — 0 verified, 10 unverified, 0 conflicted, 0 open.

## 2. Requirements

The full behaviour (contract, env table, policy matrix, force screen copy, dismissal rules,
runbook, acceptance criteria) is the approved plan, sections 3–11, which this spec adopts
unchanged except where §11b records a later decision. Summary of the parts an executor needs:

- **Env (api):** `MOBILE_MIN_VERSION_<OS>`, `MOBILE_LATEST_VERSION_<OS>` (default `0.0.0`),
  `MOBILE_SOFT_UPDATE_ENABLED_<OS>` (default `false`), `MOBILE_SOFT_UPDATE_REMIND_AFTER_HOURS_<OS>`
  (default 24, 0–720), `MOBILE_STORE_URL_<OS>`, `MOBILE_FORCE_UPDATE_MESSAGE`,
  `MOBILE_SOFT_UPDATE_MESSAGE`; `<OS>` = `IOS` | `ANDROID`.
- **Policy:** required = current < min (unparseable current fails a real min); available =
  not required && soft toggle && current < latest; required always wins; no / unknown
  platform header → neither.
- **Copy:** force default "A new version of the app is available. Please update to continue.";
  soft default "A new version of the app is available with the latest improvements.";
  backend message used when non-blank.

## 3. Data model

N/A — no schema change. Dismissal lives on the device (`kv`, key `app-update:soft-dismissed`).

## 4. API surface

`GET /api/v1/app-version` (`@Public`, `@SkipThrottle`, exempt from the version guard);
global `AppVersionGuard` registered first in `APP_GUARD`; 426 body
`{ statusCode, code: 'APP_UPDATE_REQUIRED', message, minSupportedVersion, latestVersion, storeUrl }`.

## 5. Web surface

N/A — web sends no headers and is never gated.

## 6. Mobile surface

Headers on every request and on the refresh call; 426 → force screen, no refresh, no retry,
no toast; check on launch and foreground (5 s timeout, fails open, splash held ≤ 3 s);
force screen (`ForceUpdateScreen`), soft dialog (`SoftUpdateDialog`, centred fade Modal).

## 7. Shared package

`constants/app-version.ts`, `utils/compare-app-versions.ts`, `types/app-version.types.ts`.

## 8. Permissions and tenancy

Endpoint is public and tenant-free (env config only). Added to
`presentation/public-route-allowlist.spec.ts` with that justification.

## 9. Validation rules

Joi per key (§4.1 of the plan) plus the object-level min ≤ latest rule (REQ-02).

## 10. Tests

See `implementation.md` for what ran and its results.

## 11. Non-functional

No DB access on the hot path; the guard is a pure function of headers + config.

## 11a. Ripple

- Every HTTP route: guard runs first. Requests without a mobile platform header pass unchanged.
- `AllExceptionsFilter`: now forwards `minSupportedVersion`, `latestVersion`, `storeUrl` **only**
  when `code === 'APP_UPDATE_REQUIRED'`; every other body unchanged.
- Mobile `AnimatedSplash`: gains `holdExit`; existing behaviour unchanged when it is false.
- Mobile React Query defaults: `retry` becomes a function equal to the old `2`, except 426.

## 11b. Developer decisions

*Decided by* recorded **at the developer's explicit instruction** ("Update the Decided by column … to
Asfad for the decisions approved by me", chat 2026-10-27). The AI did not choose these.

| ID | Decision | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- |
| D1 | Where versions live | per-platform env vars, defaults off | Asfad | 2026-10-26 |
| D2 | Enforcement | `GET /app-version` + global 426 guard (minimum only) | Asfad | 2026-10-26 |
| D3 | Soft update | in scope, per-platform toggles default `false` | Asfad | 2026-10-26 |
| D4 | Headers | `x-app-version`, `x-app-platform` | Asfad | 2026-10-26 |
| D5 | Contract location | `@tcg/shared` | Asfad | 2026-10-26 |
| DA | Pre-feature builds | cannot be blocked — accepted | Asfad | 2026-10-27 |
| DB | Config consistency | API fails fast at startup (min > 0.0.0 && latest < min) | Asfad | 2026-10-27 |
| DC | Reminder interval | backend-controlled, per platform, 0–720 h, default 24; 0 = next cold start, never on foreground | Asfad | 2026-10-27 |
| DD | Spec folder | `.ai/aidlc/Trello-115/`, title "Version control" | Asfad | 2026-10-27 |
| DE | Soft dialog / rocket | E2 centred fade Modal; `@expo/vector-icons` Ionicons `rocket-outline` | Asfad | 2026-10-27 |
| DF | Newer release | invalidates an active dismissal | Asfad | 2026-10-27 |
| DG | Force message | `MOBILE_FORCE_UPDATE_MESSAGE` optional, agreed sentence default | Asfad | 2026-10-27 |
| D10 | Force screen content | rocket, title, sentence, only "Latest version: X"; no installed/required version, no "Maybe later" | Asfad | 2026-10-27 |
| D11 | Dismissal storage | existing `kv` helper, no backend storage | Asfad | 2026-10-27 |
| D12 | Push announcements | out of scope | Asfad | 2026-10-27 |
| D13 | PR split | three stacked PRs U1 / U2a / U2b | Asfad | 2026-10-27 |
| I1 | 426 body passes through `AllExceptionsFilter` (allowlisted fields, that code only) | implemented this way — **awaiting developer confirmation** | | |
| I2 | Android back on the soft dialog behaves as "Maybe later" | implemented this way — **awaiting developer confirmation** | | |
| I3 | Splash hold via new `holdExit` prop on `AnimatedSplash` | implemented this way — **awaiting developer confirmation** | | |

## 11c. Siblings

None — no existing version-gate or reminder pattern in `patterns.md` (not opened; ❓).

## 12. Open questions

### Q1 — U1 is over the PR size budget

- **Question:** U1 is 506 source lines / 25 files (budget ~400 / 25). Add the `size-exception` label, or split U1 into shared + API PRs?
- **Blocked:** pushing U1.
- **Owner:** Asfad
- **Status:** open

### Q2 — How the `MOBILE_*` keys reach staging and production

- **Question:** `deploy/task-definitions/api.json` lists every injected key; the new keys are not there, so the feature is off in ECS. Add them as `environment` values or as `tcg/app-secrets` `valueFrom` entries (which fail the task if the secret key is missing)?
- **Blocked:** turning the feature on outside local dev. Nothing else.
- **Owner:** Asfad (needs deployment authorization)
- **Status:** open

## 13. What this spec deliberately does not specify

- Push announcements of a new release — out of scope (D12).
- Store URLs and real version numbers — operator-supplied; no value is invented here.

## 14. Sign-off before build

- [x] No `[OPEN]` requirement
- [x] No `[CONFLICT]` requirement
- [ ] I1–I3 confirmed by the developer
- [ ] Q1, Q2 answered
