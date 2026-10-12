# Units — TCG-73 My Labor reliability

## Unit ledger

| Unit | User-visible outcome | Scope | Dependencies | Branch |
| --- | --- | --- | --- | --- |
| U1 | My Labor communicates loading/failure, stays interactive, and retains timestamped KPIs offline within the login session | Existing mobile HTTP services, hooks, AuthGate and My Labor UI; regression cases | User’s recorded cache/scope answers and 2026-10-12 instruction to start implementation | fix/TCG-73-my-labor-reliability |

## U1 — Honest My Labor request states and session-only KPI retention

One vertical mobile unit: background request intent, authentication-time query observation, in-memory lifetime, independent presentation and focused regression coverage ship together. No schema, API contract, dependency or new exported component/function. The two earlier proposed slices are combined because the state display and login-retained snapshot form one bounded, user-visible outcome; source change remains below the PR budget.

### Slice contents

- Existing performanceHttp.get and laborHttp.get use BACKGROUND_REQUEST.
- Existing usePerformanceStats accepts an enabled flag, sets infinite in-memory garbage-collection time and suppresses global error toasts; AuthGate enables it for authenticated field workers.
- Existing session clearing/cancellation and HTTP epoch guards protect account transitions; performance remains excluded from disk persistence.
- Existing My Labor shows request states independently, keeps successful values on refresh failure, supports independent retries and labels offline KPI values with the successful-fetch timestamp.
- Offline state uses QueryProvider’s onlineManager connectivity signal, including internet reachability.
- Existing KPI formulas and Home remain unchanged.

### Reviewable as

A field worker signs in; the performance request starts in the background before opening My Labor. My Labor remains usable while either request loads/fails; valid zero KPI values are displayed. After a successful fetch, going offline retains the same KPI values and timestamp. Logout/account switch clears the old cache; process restart does not restore it. Quick actions are absent from this unit and remain pending their own specification.

### Risk

AuthGate’s new query consumer requires adaptation of routing tests. Connectivity must match QueryProvider rather than merely Wi-Fi connection. A failed labor request must not become a misleading “no shifts” message. Successful cached values must outlive the default five-minute garbage-collection window without going to disk.

### Ripple

AuthGate auth-routing tests; My Labor screen and existing tests; performance query/cache; global loader; session cache clearing; persistence allowlist. No other performance screen consumer found. Regression assertions authored for these paths, but execution is explicitly disabled by the user.

### Deliberately not in this unit

Metric selection/formulas, payroll calculation, Home KPIs, quick actions, disk caching, new freshness thresholds and new API contracts.

## Sequencing

U1 only. No stacked dependency needed. Implementation is uncommitted in /tmp/tcg73-implementation. Do not claim deployment/readiness or passing test gates. No publication requested.
