# TCG-73 — proposed execution sequence

2026-10-12. Implementation authorized by the user after the recorded scope/cache decisions. Read intent.md, spec.md and units.md first. The proposed sequence below is retained as planning history; units.md is the current execution boundary.

## Triage

Path A draft: the remaining loading/error/background defects are specified, but choosing offline behavior is new product intent (GUIDE.md §2 escalation). No implementation branch created; processed.log is appended at branch creation, not simulated during planning.

## Current baseline

Fake API constants and the contract mismatch are already fixed. PerformanceSection is only on My Labor. Real metrics are weekly live-estimate labor hours, all-time completed tickets and incidents personally filed. Safety/on-time/target fields are optional and omitted by the real API. /me/labor now uses real employee/payroll data. Sample mock fixtures remain intentional mock-mode data, not HTTP error fallbacks.

## Proposed slices — not approved units

1. **My Labor stays usable while performance and labor data load or fail.** The user included both requests on 2026-10-12. Extend the existing performance and labor requests to use BACKGROUND_REQUEST and the existing screen to distinguish loading, failure, valid zero metrics and success independently; failure of one must not hide the other’s successful result. Extend existing tests. Reuse existing exports; unchanged API/schema/formulas. Final slice boundary and retry/copy depend on D1/D2/Q5. This is independently user-visible.
2. **My Labor retains last-known KPIs offline for the current session.** The user chose no restart persistence, fresh fetching on each new login, and retention of fetched values offline. Include a background performance fetch in the existing login/bootstrap lifecycle so it does not depend on opening My Labor. Reuse query-client in-memory values and their successful-fetch timestamp; preserve them offline until the app/login session ends. Clear previous-login values on logout/account switch and protect against late responses through the existing session epoch machinery. Keep performance excluded from disk persistence. No numeric expiry is invented. After process restart with no fresh successful fetch, show unavailable/loading as appropriate. Tests cover login fetch, successful timestamp, offline retention, failed fetch state, account switching and no disk persistence. Stack on slice 1 if unmerged. D3/Q5 must approve the integration/presentation before execution.
3. **Sibling /me/labor reliability** is now explicitly included (Q4 resolved) and belongs in slice 1 rather than a separate implementation unit. Do not extend this into pay calculations or persistent pay caching without a separate decision.

Quick actions remain pending a separate specification by the user’s Q2 answer, not a build unit in these fixes. Metric selection/definition changes remain pending Q3 and require separate specification if requested.

## Delivery discipline

After sign-off, create units.md with approved vertical slices, one implementation branch/PR per unit; append processed.log at branch creation. Executor implements one unit, analyst reviews its acceptance and ripple, reflection records relevant causes after delivery. Do not mark gates passed without running them. The session's no-build/test/typecheck constraint remains in force until changed.

## Validation plan

Source/contract inspection confirms no backend or shared changes; no guardian/contract tracer needed unless that scope changes. Proposed focused regressions: background fetch does not trigger global loader; zero metrics render honestly; rejected/invalid response creates visible error; initial loading is visible; optional unsupported tiles stay omitted; approved offline/cache/reconnect transitions work. Preserve My Labor summary/shift rendering and Home behavior. Native builds are not needed to decide the plan; no checks run here.

## Outstanding

The remaining parts of spec.md §12 Q3 and Q5 must be answered or explicitly scoped out before the dependent slices become build-ready. This file proposes sequence only; it does not substitute for approved units.md.

## Confirmed cache direction — 2026-10-12

Session-only storage; fetch on every new login; retain successful values with timestamp offline. No disk cache, no prior-login reuse, no arbitrary freshness cutoff. Q1 is resolved for the plan. Exact developer integration/sign-off is still pending; no implementation started.

## Execution update — 2026-10-12

The user instructed “start the implementation.” The accepted reliability scope is U1 in units.md, implemented on isolated branch fix/TCG-73-my-labor-reliability at /tmp/tcg73-implementation. Source changes extend existing primitives only; no metric decisions or backend changes. Focused regression tests are authored but not run. Formatting and git diff --check are permitted non-runtime checks. Existing current-checkout work remains untouched.
