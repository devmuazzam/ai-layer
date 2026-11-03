# Analysis — TICKET-EDIT-AFTER-24H Unit 1

**Verdict: do not ship as complete.** The core age-cutoff removal matches the contract, but
three explicit mobile slice requirements remain incomplete.

Reviewed 2026-11-03 by an independent `tcg-analyst` against `plan.md` / `units.md`:
client `ea1e22d80`, base `9966b2c56`. Review was read-only. No application files changed.

## Findings

1. **[INFERRED] Expired approval can hide the fresh-request action.**
   `apps/mobile/app/(field)/ticket/index.tsx:255-260` hides the banner for any raw
   `editRequest.status === 'APPROVED'`, even when the computed editability state correctly
   becomes WINDOW_CLOSED_NEEDS_REQUEST after `windowEndsAt`. The repository includes
   APPROVED rows without a deadline filter (`apps/api/src/service/job-tickets/job-tickets.repository.ts:120-126`)
   and the mapper forwards them (`apps/api/src/usecase/field-tickets/field-ticket.mapper.ts:430-435`).
   Until expiry processing updates the row, the required re-request action can disappear.
   This predates the commit but is reached by, and explicitly covered by, Unit 1's
   expiry/re-request acceptance. Let the computed state govern banner visibility; remove
   the raw-status shortcut. Reasoned from source, not reproduced on a device.

2. **[INFERRED] A live approval takes precedence over a payroll void lock.**
   `apps/mobile/data/ticket-editability.ts:119-133` returns APPROVED_WINDOW_OPEN before
   `isPayrollVoidedFieldTicket`; overview `isReadOnlyTicket` at
   `apps/mobile/app/(field)/ticket/index.tsx:225` then allows editing. This ordering predates
   the commit, but `units.md` explicitly requires ensuring a stale approval never exposes
   an unusable editor. Evaluate the existing void lock before request states. Server payroll
   settlement checks still exist (`apps/api/src/usecase/ticket-edit-requests/ticket-edit-requests.service.ts:87-92`);
   this is not evidence of a server authorization bypass. A separate mobile settlement-state
   signal was not established. Reasoned from source, not a runtime reproduction.

3. **[INFERRED] Submitted corrections use late-completion copy.**
   `apps/mobile/components/field/edit-request-sheet.tsx:113-122` asks the worker to
   “finish this ticket” and “Why are you completing this late?” for SUBMITTED_EDIT too.
   The sheet already receives `kind`; Unit 1 expressly requires correction wording.
   Select the intro and placeholder by that existing kind. The overview banner at
   `apps/mobile/app/(field)/ticket/index.tsx:292` also calls the completion window closed
   for a COMPLETE ticket even within its original 24h window; align that copy with the
   correction flow while preserving the existing test IDs. Reasoned from rendered strings
   and their unconditional source branches.

## Gates and limits

The analyst ran no lint/build/tests. Recovered executor gate output is recorded in
`implementation.md`: API lint/build, mobile lint/typecheck, 8 existing suites / 116 tests
passed. That evidence belongs to committed `ea1e22d80`, not to future review fixes.
There is no pre-edit baseline, no demonstrated live device flow and no proof that the
existing tests cover the three UI findings. No new tests were requested or added.

## Scope, sources and ripples

- **[VERIFIED]** `git diff 9966b2c56 ea1e22d80 --numstat` shows four files: two policy edits
  and two existing assertion updates. No schema, dependency, endpoint or response-shape
  changes. No G3/G5 delegation trigger.
- **[INFERRED]** Completed history reaches the request UI: `apps/mobile/app/(field)/jobs.tsx:234-258`
  → `handleOpenTicket:120-131` → overview banner at `ticket/index.tsx:911-912`;
  request kind at `ticket/index.tsx:234-237` selects SUBMITTED_EDIT for COMPLETE.
  Completed tickets were not injected into the incomplete list.
- **[INFERRED]** API tenant/ownership resolution, payroll lock, send-back, duplicate-request
  and approval-kind write enforcement remain intact. The API age rejection is removed;
  mobile COMPLETE now needs approval regardless of age.
- **[INFERRED]** Existing expiry, write-window, payroll-completion and audit consumers are
  unchanged; their existing suites are included in the recovered gate evidence. This does
  not substitute for a live save → payroll recalculation demonstration.
- **[INFERRED]** Behavior traces to Unit 1 / `plan.md` and TICKET-FLOW-SLOTS-HOLDOVER
  REQ-19–21, with the late-ticket decision carrying `reference` and requirements
  `[UNVERIFIED]`. No new unsourced behavior identified. The general field-ops conflict stub
  was read; its three competing FRDs were not adjudicated by this review.

Complete: **no**, the findings above remain. Contained: **yes**, the commit is one unit.
Demo works: **unverified**, not executed.

## Maintainability

**[VERIFIED]** `git show <base>:<file> | wc -l` and `wc -l <file>` show production files
shrinking: API service 434 → 413 lines, mobile helper 170 → 162. No 1,000-line crossing.
**[INFERRED]** Thermo-nuclear and ponytail passes found no structural regression in the
submitted diff; deleting the age branches simplifies both policies. No unrelated cleanup
is proposed for this unit.

## Next handoff

An executor should resolve the three findings within the existing slice, preserve test IDs,
run affected existing mobile suites/lint/typecheck, and return for analyst review. Keep
original completed status, the 4h deadline, other server guards and finalized-payroll policy.
Execute the configured-tenant demo before release. Unit 2 remains blocked on `plan.md` §6 Q1;
no new product questions were raised by this review. No reflection/closure yet: the unit is
not accepted as shipped.

Least confident about: device behavior under cache refresh and cron timing; findings are
source inferences. Most likely longer-term failure: consumers continue reading raw request
status instead of the deadline-aware editability projection.
