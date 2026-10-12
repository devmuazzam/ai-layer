# Spec — TCG-73 My Labor performance reliability

Status: Reduced reliability scope authorized for implementation by the session user on 2026-10-12 (“start the implementation”). Metric-definition changes remain excluded. units.md records U1.

## 0. Provenance

- Intent: intent.md, captured 2026-10-12.
- Elaborated: 2026-10-12.
- Sources: TCG-73 description and technical comment; session user's scope correction; current code; field-ops vault index/conflict stub and KPI gap entry.
- Source tags: ticket and code are [UNVERIFIED] per the spec template, even when inspected. The session instruction is an explicit scope direction; its speaker's human identity is not established for a named decision record.
- Vault state: field-ops sources remain conflicted/unverified. Candidates: field-ops/frd-new-format-draft/INDEX.md, field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md. This plan adjudicates none of them.
- Questions: §12 records Q3/Q5 still open; Q1 is resolved, Q2 retained pending a separate specification, and Q4 resolved by explicit session direction.
- Rules: .ai/aidlc/GUIDE.md §2; .ai/claude/AGENTS.md; contexts/mobile.md; contexts/patterns.md. No P1/P2 pattern applies.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Source | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Keep KPIs off Home | mobile | [UNVERIFIED] | session instruction | no |
| REQ-02 | Visible performance request states | mobile | [UNVERIFIED] | TCG-73 technical AC5 | exact presentation needs sign-off |
| REQ-03 | Nonblocking performance fetch | mobile | [UNVERIFIED] | TCG-73 technical AC7 | no |
| REQ-04 | Session-only last-known KPIs and login fetch | mobile | [UNVERIFIED] | session answers, 2026-10-12 | implementation sign-off only |
| REQ-05 | Approved metric set and meaning | mobile | [OPEN] | TCG-73 technical AC1 | yes, for any metric changes |
| REQ-06 | Quick-action scope | mobile | [OPEN] | TCG-73 technical AC10 | yes, for quick actions |

## 2. Requirements

### REQ-01 — No Home KPIs [UNVERIFIED]
- Statement: Do not add performance KPIs to Home.
- Surface: mobile.
- Sources: session user, 2026-10-12 — “We do not need KPIs in home screen.” Explicit scope direction, not vault adjudication.
- Conflict: Supersedes the ticket's Home-placement requirement for this plan only; description stays untouched.
- Open question: None for exclusion; named attribution Q5.
- Ripple: FieldHome remains unchanged; existing My Labor section remains the implementation target.
- Acceptance: No new KPI query or component on FieldHome.
- Notes for executor: Reuse the current screen; do not migrate the section.

### REQ-02 — Visible request states [UNVERIFIED]
- Statement: A performance failure must not silently remove the section; loading and failure must be distinguishable from legitimate zero values.
- Surface: mobile.
- Sources: TCG-73 [UNVERIFIED], kind: ticket — technical AC5; current labor.tsx [UNVERIFIED], kind: repo — conditional stats rendering hides failures.
- Conflict: None for this defect; broader field-ops sources remain unresolved as noted in §0.
- Open question: Exact presentation/retry behavior Q5; cached-data failure behavior Q1. Both requests are included by the session follow-up.
- Ripple: Existing My Labor and performance hook.
- Acceptance: Reviewer can distinguish initial loading, HTTP/parse failure, and a successful response containing zero metrics.
- Notes for executor: Existing usePerformanceStats query state and design-system primitives are candidates. Do not invent a new exported component or hook without a developer decision.

### REQ-03 — Background performance request [UNVERIFIED]
- Statement: Performance fetching must not dim or block the screen.
- Surface: mobile.
- Sources: TCG-73 [UNVERIFIED], kind: ticket — technical AC7; BACKGROUND_REQUEST [UNVERIFIED], kind: repo — existing request intent.
- Conflict: None.
- Open question: None for sibling inclusion — Q4 resolved; D1 implementation details remain pending.
- Ripple: All performanceHttp.get callers (currently usePerformanceStats → My Labor).
- Acceptance: Starting or refetching performance data does not increment global loader activity; errors still reach query/UI state.
- Notes for executor: Propose passing existing BACKGROUND_REQUEST to api.get inside performanceHttp.get and laborHttp.get. Keep public service signature and response schema unchanged.

### REQ-04 — Session-only last-known KPIs [UNVERIFIED]
- Statement: Fetch fresh performance KPIs on each new login and retain the last successful values, with a timestamp, while offline during that app session. Do not persist KPI values across app restarts.
- Surface: mobile.
- Sources: Explicit session answers, 2026-10-12 — “No—keep them only for the current app session” and “We need to fetch them and retain them on new login and in case of offline mode we need to retain those.” These are scope instructions; named attribution remains Q5.
- Conflict: None between these answers when retention is limited to the current app session. They do not authorize restoring KPI values from disk.
- Open question: No numeric age cutoff stated. Retention is bounded by the app/login session; do not invent a maximum age. State presentation/retry choice remains Q5.
- Ripple: Login/session lifecycle, existing performance query, My Labor display. Disk persistence remains unchanged. Do not reuse values from a previous login or another user/tenant.
- Acceptance: A new login initiates a background performance fetch; a successful fetch records its values and timestamp. Going offline after success displays the retained values and timestamp with offline status. Logout/account switch clears the previous login’s KPI values. A fresh process without a successful fetch shows unavailable/loading state as appropriate, never fabricated zero values. A failed fetch is visibly reported without presenting older-session values as fresh.
- Notes for executor: Reuse the existing performance query key/query client, existing session epoch/account cache-clearing machinery, and existing login/bootstrap integration where possible. The fetch must run on login, not wait for My Labor to mount. Resolve D3 before selecting the integration point. No KPI persistence allowlist expansion.

### REQ-05 — Metric approval [OPEN]
- Statement: OPEN — which current metrics and time periods crew should see is not approved by a named TCG person in the retrieved record.
- Surface: mobile.
- Sources: TCG-73 technical AC1 [UNVERIFIED], kind: ticket; field-ops/gaps.md#my-labor--my-performance-kpi-card [UNVERIFIED], kind: vault, records missing definitions for other metrics.
- Conflict: Do not select among the three field-ops candidates in §0.
- Open question: Q3 in §12.
- Ripple: PerformanceSection, My Labor; no computed metric changes authorized.
- Acceptance: OPEN for selection changes; existing calculations remain untouched.
- Notes for executor: Do not add safety score, on-time rate, or target percentage.

### REQ-06 — Quick actions [OPEN]
- Statement: The user retained quick actions pending a separate specification on 2026-10-12. OPEN — their behavior remains unspecified; implementation is excluded from these reliability fixes.
- Surface: mobile.
- Sources: TCG-73 technical AC10 [UNVERIFIED], kind: ticket.
- Conflict: N/A.
- Open question: Q2 in §12.
- Ripple: Home only if separately authorized.
- Acceptance: OPEN — scope decision required.
- Notes for executor: No quick-action implementation in these reliability fixes; keep the request pending a separate specification.

## 3. Data model — apps/api/prisma/schema.prisma

Schema change: no. Migration: no. Backfill: no. Existing models are read by the existing endpoint only. New entity/code/prefix/relations: N/A. Field precision: N/A — unchanged.

## 4. API surface — apps/api

No new endpoint, DTO, response shape, module, guard, or export. Reuse GET /me/performance → MeService.getMyPerformance → MeRepository. No backend changes planned. Both existing mobile performance and labor requests are included in reliability fixes by the session user’s 2026-10-12 follow-up. Existing tenant/user scoping retained. A later contract change requires tcg-contract-tracer and developer approval.

## 5. Web surface — apps/web

N/A — mobile-only; no web routes, components, forms, tables, or query changes.

## 6. Mobile surface — apps/mobile

- Screen: /(field)/menu/labor; Home unchanged.
- Reuse: usePerformanceStats, PerformanceSection, Card/AppText, existing activity indicator, useOnline, BACKGROUND_REQUEST.
- New exports: none proposed. Exact state/retry copy: NOT SPECIFIED — Q5.
- Offline/sync: Session-only in-memory last-known KPIs, fetched on each new login, timestamped and retained offline; no disk persistence or numeric age cutoff. See REQ-04.
- Touch targets: at least 48px for any approved action.
- Push/notifications: N/A.

## 7. Shared package — packages/shared

N/A — existing hours computation and contracts remain unchanged.

## 8. Permissions and tenancy

Existing authenticated field access and signed-in employee/tenant scope retained. No new roles or cross-tenant reads. New permission rules: N/A.

## 9. Validation rules

Reuse PerformanceStatsSchema. Valid zeros remain zeros. Optional unsupported metrics remain omitted. No new numeric limits, scoring formula, or freshness threshold authorized.

## 10. Tests

Planned, not run: background-request configuration/global-loader regression; successful zero metrics; loading state; HTTP and schema failure states; session-only offline/cache/login transitions under REQ-04; optional-metric omission. Extend existing service/hook/screen tests. Manual validation: My Labor stays interactive while performance loads and communicates failure/offline correctly. No tests/build/typecheck execution in this planning session.

## 11. Non-functional

Performance: background request must not contribute to touch-blocking global loader. Concurrency: use existing TanStack Query behavior; do not invent polling/retry policy. Audit: N/A — read-only UI. Privacy: no new telemetry/payload. Numeric performance target: NOT SPECIFIED.

## 11a. Ripple — already-shipped behavior

| Existing consumer | Reached via | Planned behavior | Source/evidence |
| --- | --- | --- | --- |
| My Labor | usePerformanceStats / performanceHttp.get | Visible states and background fetch | TCG-73; rg -n 'usePerformanceStats' apps/mobile |
| FieldHome | scope | Unchanged | session instruction; field.tsx has no KPI consumer |
| /me/labor fetch | adjacent screen query | Include background fetching and visible failure states | rg -n 'useMyLabor' apps/mobile; same My Labor screen |
| Query persistence | cache scope | Unchanged: performance remains excluded from disk persistence | user selected session-only; query-persistence.ts:isPersistedQueryKey |
| Login/session lifecycle | fresh performance fetch and cache clearing | Background fetch on each new login; no previous-login cache reuse | REQ-04; existing session/store.ts and session-scope.ts |
| Global loader | request configuration | Performance request excluded | base-api.ts backgroundRequest handling |

## 11b. Developer decisions — structure

| ID | Decision | Options with existing candidates | AI proposal | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Request implementation | Reuse BACKGROUND_REQUEST directly in existing performanceHttp.get and laborHttp.get; extend service signatures only if needed | Direct reuse avoids public-contract change | pending | pending | pending |
| D2 | State presentation | Extend labor.tsx using existing primitives; new shared state component only if reuse is needed | Extend existing screen | pending | pending | pending |
| D3 | Login fetch integration | Reuse existing authenticated bootstrap/session lifecycle and query client; do not create a new exported hook/provider without developer approval | Existing integration point, with session epoch protection | pending | pending | pending |

## 11c. Siblings

| Sibling | Pattern | Same change? | Decided by | Evidence |
| --- | --- | --- | --- | --- |
| useMyLabor / laborHttp.get | Same read-only summary screen; no registered P1/P2 | yes — user explicitly included both requests on 2026-10-12 | Named attribution pending Q5; explicit session answer recorded | labor.tsx imports both hooks |
| Sales/dispatch dashboards | Different persona/data flow | No change proposed; keep outside this ticket | pending scope sign-off | app persona routes |

## 12. Open questions

All questions belong to this ticket; no module gap entry is created.

- Q1 — Offline: resolved by session answers on 2026-10-12. Fetch fresh KPIs on each new login; keep the last successful values and timestamp only in memory for the current app/login session; retain them while offline. No disk persistence, restart restoration, numeric age threshold, or previous-login reuse is authorized. Display offline age honestly; new-process/no-success behavior is unavailable, not zero. Labor reliability inclusion does not authorize persistent pay caching.
- Q2 — Quick actions: user selected “Keep quick actions pending a separate specification” on 2026-10-12. Status: scope resolved; product specification pending separately. No quick-action implementation in these fixes.
- Q3 — Metrics: who at TCG approves weekly live-estimate hours, all-time completed tickets, and all-time personally filed incidents? No recalculation is proposed. Status: open.
- Q4 — Sibling: user selected “Include both requests in the fixes” on 2026-10-12. Status: resolved by explicit session instruction. Include background fetching and visible failure states for /me/labor as well as /me/performance; calculations stay unchanged.
- Q5 — Developer: confirm named attribution for scope, approve D1/D2 and state presentation/retry behavior and login integration D3. Status: open.

## 13. Deliberately not specified

New KPI formulas; payroll changes; safety scoring; target policy; on-time policy; quick-action behavior; unresolved caching thresholds; new endpoints/components/dependencies.

## 14. Sign-off before build

- [ ] Product questions answered or explicitly deferred by a named person.
- [ ] Developer decisions D1/D2/D3 and sibling scope recorded.
- [ ] Session-only offline retention and per-login fetch captured without invented thresholds; exact presentation approved.
- [ ] Approved spec decomposed into vertical units (units.md).
- [ ] One unit per branch/PR, within 400 changed source lines/25 source files or explicit size exception.

Answered by: pending. Date: pending. No implementation authorized by this artifact.

Session decisions above record the actual answers without inventing a named TCG approver or filling developer structural sign-off on the user’s behalf.

Scope clarification recorded 2026-10-12: KPI cache persistence/freshness no longer blocks planning. Retention lasts within the current app/login session; the timestamp communicates data age. Developer integration/sign-off and named metric approval remain separately tracked.

## Execution authorization — 2026-10-12

The user explicitly requested implementation after choosing no Home KPIs, session-only retention, fetching on new login, both request fixes and separate quick-action specification. This authorizes extending the existing request methods, hook, authentication bootstrap and screen within the accepted scope. No new exported component/function/dependency/API/schema is introduced. D1 uses existing BACKGROUND_REQUEST; D2 extends the existing screen; D3 observes the existing query in AuthGate. Human-name attribution columns are not fabricated by the AI. Q3 concerns future metric-definition changes and is excluded from U1; no new metric selection is made.
