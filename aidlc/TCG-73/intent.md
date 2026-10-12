# Intent — TCG-73

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | TCG-73 — https://linear.app/the-crane-guys/issue/TCG-73 |
| Title | Mobile Home: add KPIs, but current KPI numbers are fake |
| Type | Feature; remaining work includes defect remediation |
| Status | In Progress; blocked label present |
| Epic | TCG-5 — title NOT ON TICKET snapshot |
| Sprint | NOT ON TICKET — cycle ID supplied without a name |
| Reporter | syed haris |
| Assignee | abdulmuazzam@codingcops.org |
| Captured on | 2026-10-12 |
| Captured by | Codex, on the session user's request; not a human decision-maker |

## 2. Business intent

- Intent: Give field crew honest performance information and visible request failures. The session user explicitly removed Home KPIs from scope and requested that this update be posted as a comment, without changing the description.
- Who benefits: Field crew viewing Menu → My Labor.
- What is worse today: Performance failures hide the section; performance requests contribute to the global loader; offline KPI behavior is undefined.

## 3. Definition of done, as the ticket states it

> A new employee sees 0 jobs, not 42.
> Every KPI on Home matches real data.
> Loading KPIs does not dim the whole screen.

Acceptance criteria present: yes. The second original criterion is superseded for this plan by the session user's explicit statement: “We do not need KPIs in home screen.” The description must remain unchanged; the updated comment and this capture preserve the scope correction.

## 4. In scope

- Plan visible performance loading/failure/offline states on My Labor.
- Plan background performance fetching without changing metric computations.
- Identify unresolved metric semantics, offline policy, quick actions, and sibling scope before execution.
- Reuse the current API, contract, hook, and performance component.

## 5. Out of scope

- Adding KPIs to Home; changing the ticket description.
- Rebuilding already-fixed fake data and contract mismatch.
- Changing pay calculations, payroll approval, or metric definitions without a decision.
- Adding safety score, on-time percentage, or hours targets.
- Implementation, commits, publication, builds, tests, and typechecking in this planning session.
- Quick-action implementation: excluded from these reliability fixes; the user retained it pending a separate specification (2026-10-12).

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| apps/api | no | Existing /me/performance data reused |
| apps/api/prisma | no | No schema, migration, or backfill |
| apps/web | no | Mobile-only scope |
| apps/mobile | yes | Existing performance fetch and My Labor presentation |
| packages/shared | no | Existing hours calculations unchanged |

## 7. Entities and business codes

Existing endpoint reads Employee, JobTicket, TicketEmployee, ticket time entries and TicketIncidentReport. This plan introduces no entity, prefix, code generation, or data mutation. Exact business-code prefixes: N/A — unchanged endpoint-owned reads.

## 8. Roles and permissions

- Roles: Existing authenticated field crew access; no permission expansion.
- Explicit exclusions: NOT ON TICKET.
- Tenant scope: Existing signed-in employee and tenant scope retained.

## 9. Designs and references

- Design: Existing PerformanceSection; design port is not approval of its original six metrics.
- Attachments: None on ticket.
- Related: TCG-64 (loading/offline behavior), TCG-63 (sample data); technical comment excludes fabricated pay remediation from this ticket.
- Repo: apps/mobile/app/(field)/menu/labor.tsx; data/hooks/use-performance-stats.ts; data/services/performance/performance.http.ts; apps/api/src/usecase/me/me.service.ts.
- Vault: field-ops/INDEX.md; field-ops/field-ops-mobile-INDEX.md; field-ops/gaps.md → My Labor / My Performance KPI card.

## 10. Terms used that may not be defined

“KPIs”, “hours”, “quick actions”: selection and product definitions remain open. Current code computes weekly live labor hours, all-time completed-ticket count, and all-time incidents personally filed by the user. Code establishes current behavior, not product approval.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Origin |
| --- | --- |
| 0 jobs instead of 42 | TCG-73 acceptance criteria; 42 was the removed fake fallback |
| No new thresholds | Offline freshness/retention policy NOT ON TICKET |

## 12. Capture completeness

- NOT ON TICKET: sprint name, epic title, role exclusions, offline freshness/retention.
- OPEN: Q1 persistence/freshness and failed-refresh behavior; Q3 metric selection/semantics; Q5 named decision attribution and implementation choices. Q2 is retained pending a separate specification; Q4 includes both requests by explicit session direction.
- Fully buildable without product answers: no.
- Triage: Path A draft because offline behavior and scope decisions are unresolved. Once narrowed and approved, the specified loading/error/background defects can be executed without changing data contracts.
- processed.log: not appended; no implementation branch was created. The guide appends at branch creation.

## Session follow-up — 2026-10-12

Explicit user answers: show last-known KPIs with a timestamp, with persistence and freshness defined before implementation; include both performance and /me/labor requests in background-fetch/error-state fixes; retain quick actions pending a separate specification. These answers narrow the plan without approving metric formulas or cache thresholds.

## Cache clarification — 2026-10-12

User selected no restart persistence: keep KPIs only for the current app session. User further directed fresh fetching on each new login and retaining the fetched values in offline mode. Interpret together: in-memory last-successful KPI values scoped to the current authenticated session; no disk persistence or reuse of another login’s values. No numeric age cutoff was specified. Offline values retain their successful-fetch timestamp; an app restart without a fresh successful fetch has no KPI snapshot.
