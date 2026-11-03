# Plan — ticket edits after the 24-hour completion window

## 1. Intent, sources, and triage

User request, 2 November 2026: “plan this out!” following the comparison that completed tickets should remain eligible for approved edits after 24 hours, and Payroll should be able to correct tickets regardless of age.

No external ticket was supplied. Working ID: TICKET-EDIT-AFTER-24H.

Unit 1 is **Path B**, a fix against existing TICKET-FLOW-SLOTS-HOLDOVER REQ-20/21: submission locks immediately, edits use SUBMITTED_EDIT, approval grants four hours, expiry allows another request. The current API and mobile introduce an additional age cutoff. Unit 2 is **Path A**, because the supplied Payroll-at-all-times requirement contradicts the recorded finalized-payroll lock and does not define downstream correction mechanics.

Sources:

- User-supplied client answers and this conversation: comparison target. The attachment is recorded in `vault/decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md`, status `reference`, previously held by TCG pending updated answers. This plan does not relabel it verified.
- `vault/decisions/2026-10-15-late-and-incomplete-tickets.md`, status `reference`: L2 scheduled shift end +24h; L3 four-hour approval and repeat requests; L4 immediate submission lock; L8 finalized-payroll prohibition. Developer direction, not ratified client policy.
- `TICKET-FLOW-SLOTS-HOLDOVER/spec.md`, sections REQ-18–21: existing window, request and lock contract.
- `APPROVED-TICKET-EDIT-PAYROLL-RECALC/`: related save/finalize/recalculation work. Inspect its actual integration before changing finalization; do not assume its state record proves deployment.

## 2. Target behavior

For eligible tickets whose payroll/accounting is still open:

| State | Before scheduled shift end +24h | After scheduled shift end +24h |
|---|---|---|
| Incomplete | Worker completes directly | Request LATE_COMPLETION approval |
| Complete/submitted | Request SUBMITTED_EDIT approval | Request SUBMITTED_EDIT approval |
| Request pending | Show waiting; prevent duplicate requests | Same |
| Approved | Edit for four hours from approval | Same; original 24h deadline does not truncate approval |
| Approval expires | Preserve saved information; use ordinary eligibility rules | Read-only; allow a new request |

Submission stays locked until approval even within the initial 24h. A completed ticket stays COMPLETE during corrections. Expiry revokes editing permission, never rolls back saved edits. Incomplete tickets remain incomplete until actually submitted. If an incomplete ticket's approval expires while its original completion window is still open, direct completion remains allowed.

Keep the scheduled shift-end anchor, permission-based approvers, ownership rules, request reasons, one-open-request constraint, and existing reminders. The completed-ticket age fix does not itself change finalized-payroll policy; Unit 2 addresses that separate requirement.

## 3. Unit 1 — remove the completed-ticket age cutoff, one PR

Concrete outcome: an eligible worker can open an old completed ticket, request an approved correction, save within the four-hour grant, and request again after expiry.

1. **API request eligibility:** remove the scheduled-end+24h rejection of SUBMITTED_EDIT / COMPLETE requests in `apps/api/src/usecase/ticket-edit-requests/ticket-edit-requests.service.ts:106`. Keep request-kind validation, primary ownership, tenant checks, pending/live-approval checks, send-back ownership and finalized-payroll checks. Search every producer/consumer of the cutoff/error text so no parallel enforcement survives.
2. **Mobile eligibility:** update `apps/mobile/data/ticket-editability.ts:136` so COMPLETE requires approval regardless of age instead of becoming permanently LOCKED. Retain actual payroll void/settlement restrictions. Check approved-window precedence against settlement/void state so a stale approval cannot present an unusable edit screen.
3. **Reachable request UI:** use the existing ticket overview and request sheet. Check `apps/mobile/app/(field)/ticket/index.tsx:268`, `components/field/edit-request-sheet.tsx`, completed-ticket history in `app/(field)/jobs.tsx`, incomplete/needs-attention cards, and approved-edit cards. Existing history must reach ticket details and Request approval after 24h. Do not put completed tickets into the incomplete list merely to expose the action. Adjust copy for completed corrections versus finishing incomplete work. Preserve test IDs and use find-component before adding any UI component.
4. **Four-hour grant end to end:** enumerate all write endpoints exposed during an approved edit. Audit existing terminal guards on labor, signatures, incidents, checklists and attachments as well as time milestones. An allowed correction must honor the grant; a prohibited field needs a stated requirement and clear UI. Do not blanket-remove terminal guards: CANCELLED/REJECTED and unauthorized writes must remain refused. Record field-specific product questions before expanding what may be changed.
5. **Expiry and repeat requests:** reuse current lazy/cron expiry, decision timestamp and partial unique constraint. Preserve saved values and keep completed status. Ensure a fresh SUBMITTED_EDIT request works after expiry even when ticket age exceeds 24h. Avoid resetting the original 24h deadline.
6. **Save, recalculation, audit and notices:** verify both Save changes finalization and resubmission paths on old tickets. Eligible corrections must enqueue existing Payroll recalculation for affected weeks, retain original completion metadata, record request/change actor and times, notify existing recipients, and close the grant through the existing completion flow. A failed finalization/recalculation enqueue must remain visible/retryable; never report successful closure while needed work was dropped. Check the related APPROVED-TICKET-EDIT-PAYROLL-RECALC implementation before duplicating orchestration.
7. **Record decisions/siblings:** capture the reused workflow, touched consumers and any field restrictions in the PR AI decisions/Siblings tables. No schema or dependency change is expected for age eligibility; reassess if code proves otherwise.

Implementation should use a suitable existing isolated worktree or create one after checking attachments. The primary checkout currently contains unrelated ongoing yard-gate changes; do not stage/revert them. One independent fix per PR.

## 4. Unit 2 — Payroll corrections after approval/export/invoicing, separate PR(s)

Concrete outcome: Payroll can initiate an authorized correction regardless of ticket age while downstream payroll/accounting receives the required reviewed adjustment.

**Not a simple deletion of the lock.** Existing L8/REQ-19 explicitly prohibits changing finalized payroll, and the attachment requires approval and re-approval/update after processing.

Before implementation:

- Resolve Q1 below and write a Path A intent/spec/units for the selected finalized-record workflow, referencing the conflict with L8/REQ-19.
- Trace employee-week approval, period approval/export, ADP export/submission, invoice issuance, source snapshots and recalculation queue behavior. Enumerate existing correction mechanisms and permissions before designing another.
- Specify who may initiate, who approves, affected fields, whether a second approval is needed for Payroll's own correction, the resulting payroll/invoice states, and retry behavior when downstream updates fail.
- Plan actor/reason/from/to audit, correction links to originals, affected-worker/week/invoice recalculation, re-approval, notifications, and downstream adjustment/re-export rules.
- Use tcg-prisma-guardian for tenant/schema work and tcg-contract-tracer for any response shape changes. If pay calculations change, include G4 provenance in the same commit. New dependencies require approval. Any rewrite of existing finalized data requires G2 approval and a staging-copy guard run.

Slice vertical units after the product decision; one independent task/unit per PR. Unit 1 can ship separately and must not be described as delivering Payroll-at-all-times.

## 5. Acceptance and verification

| Scenario | Expected |
|---|---|
| Incomplete inside 24h | Edit/submit without a request |
| Incomplete at/after 24h | Direct writes refused; late-completion request offered |
| Completed inside 24h | Direct writes refused; submitted-edit request offered |
| Completed beyond 24h, e.g. seven days old | Same request/approve/correct/save workflow as a recent completed ticket |
| Pending request | Waiting shown; duplicate request rejected |
| Approval at 23h59m after shift end | Full four-hour grant from approval, even across original deadline |
| Approval at any later age | Full four-hour grant from approval |
| Approval reaches exactly four hours | Writes refused; saved values kept; another request allowed if otherwise eligible |
| Completed approval expires after original 24h deadline | COMPLETE retained; another submitted-edit request allowed |
| Incomplete approval expires inside original 24h window | Ordinary direct-edit eligibility restored |
| Denied request | Read-only where approval required; allow a new request with reason |
| Wrong employee/tenant or wrong grant kind | Refused |
| Payroll settled or ticket void/cancelled/rejected | Existing applicable restrictions honored in Unit 1; Unit 2 has its separately specified correction path |
| Old-ticket edits saved | Applicable values persisted; finalization/recalculation/audit/notices verified |
| Offline replay and duplicate submit | Existing idempotency/capture-time behavior retained; no approval extension from device time |

**New tests: not requested.** Update existing assertions that encode the old completed-ticket cutoff, without adding test files/cases. Run existing suites for edit requests, write windows, mapper, mobile editability/request UI, expiry, finalization and offline sync. Use the matrix above for manual checks not covered by existing suites. Run affected API/mobile/web lint, typecheck/build targets through `pnpm nx` as applicable. Inspect existing web test-ID consumers before changing IDs.

Execution prerequisite: restore the project's pinned pnpm/dependency runtime using the existing lockfile. Earlier audit attempts could not run tests: installed pnpm 12 versus pinned pnpm 10.30.2, dependency sync errors and missing Nx package files. Do not upgrade packages or rewrite configuration as part of this fix. Capture a runnable baseline before edits and report any environment blocker honestly.

Release verification needs a configured tenant, an authorized approver and a device/app build. Exercise both a recent completed ticket and an old one through request → approve → edit → save → Payroll update. Exercise expiry/re-request with controlled timestamps in a development environment; never modify production dates to simulate expiry. API and mobile eligibility/copy changes must both be released for the action to be usable.

## 6. AI decisions and open questions

Proposed implementation choices:

| Choice | Reason |
|---|---|
| Reuse LATE_COMPLETION and SUBMITTED_EDIT | Already model the two distinct workflows; no new age-based kind |
| Reuse four-hour grants and existing expiry | Approval age, not ticket age, controls temporary access |
| Keep ticket COMPLETE during approved corrections | Existing REQ-20 contract; avoids corrupting completion/reporting state |
| Treat finalized-record correction as a separate unit | Explicit policy conflict and downstream money/accounting effects |

**Q1 — Finalized records:** When Payroll corrects approved/exported payroll or an invoiced ticket, should the system preserve finalized records and create an approved adjustment, or reopen the originals and require re-approval/re-export/reissue? Asked asynchronously in this chat on 2026-11-02. Status: open. Recommended proposal: preserve finalized records and create linked corrections requiring review and the applicable downstream adjustment; this is a proposal, not an approved requirement. Blocks Unit 2 specification/execution, not Unit 1.

**Q1 closeout disposition (2026-11-03):** remains open and is deferred to the separate Path A finalized-record work; the Unit 1 merge does not answer it. Routing owner: requesting developer, devmuazzam, to obtain the Payroll/accounting policy owner's choice between linked adjustments and reopening originals. No policy decision maker has yet been named in this record.

Any field-specific post-submit edit question found during Unit 1 belongs here before implementing unsourced behavior. The plan does not claim full alignment of unrelated holdover/inspection/reminder requirements from the earlier 33-check audit.
