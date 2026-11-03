# Units — TICKET-EDIT-AFTER-24H: approved edits on completed tickets after 24h

> Written from `plan.md` beside it (no separate `spec.md`; this is a Path B fix against
> TICKET-FLOW-SLOTS-HOLDOVER REQ-18–21). Unit 2 (Payroll-at-all-times, Path A) is out of
> scope here and is blocked on `plan.md` §6 Q1.
> Consumed by `tcg-executor`, one unit at a time.

## What this change is

Path B. The current API and mobile add a scheduled-end+24h cutoff on completed-ticket edit
requests that TICKET-FLOW-SLOTS-HOLDOVER REQ-20/21 never mandated (approval age, not ticket
age, is what governs the grant). Unit 1 removes that cutoff on both surfaces so an eligible
worker can request an approved correction on an old completed ticket. No schema, no new
dependency, no new behaviour beyond lifting the age gate.

---

## Gate baseline

**Gate baseline:** *NOT CAPTURED — environment blocker.* `origin/main` at `261db413e`
(PR #967). `plan.md` §5: installed pnpm 12 vs pinned 10.30.2, dependency sync errors, missing
Nx package files — earlier audit could not run the suites. **Executor must restore the pinned
pnpm 10.30.2 runtime from the existing lockfile and capture a real green baseline before any
edit**, then report its gates vs that baseline. Do not upgrade packages or rewrite config as
part of this fix. If the runtime still cannot be restored, stop and report the blocker — do
not build blind.

**Execution update — 2026-11-03:** the original blocker was absent in the executor's runtime
(pnpm 10.30.2, Node 22.23.3). The core fix was already committed as client `ea1e22d80` on
arrival, so no pre-edit baseline was captured. API lint/build, mobile lint/typecheck and
116 existing tests passed on that committed state. These results do not retroactively
establish a baseline or prove the device demo. See `implementation.md` for commands and
`analysis.md` for the independent review's remaining mobile slice findings.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | A worker can request an approved correction on a completed ticket older than 24h, same request→approve→edit(4h)→save→re-request flow as a recent one | REQ-19, REQ-20, REQ-21 (age-cutoff correction) | api, mobile | — | ~small; 2 behaviour edits + consumers + copy + test-assertion updates | built — `fix/TICKET-EDIT-AFTER-24H-u1-completed-age-cutoff` (`ea1e22d80`); gates passed; analyst: do not ship pending `analysis.md` findings |

- Requirements covered: the completed-ticket age-cutoff removal within TICKET-FLOW-SLOTS-HOLDOVER
  REQ-19/20/21, counted 2026-11-02. Weakest source `[UNVERIFIED]` (developer direction in
  `vault/decisions/2026-10-15-late-and-incomplete-tickets.md`; client answers recorded
  `reference`, not relabelled verified).
- Not covered (deliberate): Payroll-at-all-times / finalized-record correction → Unit 2,
  blocked on `plan.md` §6 **Q1**. Supervisor/dispatcher on-behalf edits, leave-yard reminder,
  audit scope beyond time entries — not in this ticket; raise separately.
- Units blocked on an open question: none in Unit 1. Unit 2 is blocked on Q1.

---

## U1 — remove the completed-ticket age cutoff (API + mobile)

- **Outcome:** an eligible worker opens a completed ticket that is more than 24h past its
  scheduled shift end, requests an edit, and — once a `payroll-admin:edit` approver approves —
  saves within the four-hour grant and can request again after expiry; identical to the flow
  that already works on a ticket inside 24h. Submission stays read-only until approval even
  inside the first 24h; the ticket stays `COMPLETE` throughout.
- **Kind:** vertical
- **Requirements covered:** TICKET-FLOW-SLOTS-HOLDOVER REQ-19/20/21 — the age-eligibility part
  only; the request/approval/4h/expiry contract itself is unchanged.
- **Depends on:** —
- **Branch / PR base:** `fix/TICKET-EDIT-AFTER-24H-u1-completed-age-cutoff` from `origin/main`.
  One unit, one branch, one PR. Use a fresh isolated worktree — the primary checkout holds
  unrelated `feat/yard-ops-ticket-start-gate` changes (`M apps/api/prisma/schema.dbml`); do
  not stage or revert them.
- **Size estimate:** small — two behaviour sites, their consumers, mobile copy, and existing
  test-assertion updates.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | no schema change expected; reassess only if code proves otherwise |
| API (`apps/api`) | Remove the scheduled-end+24h rejection of `SUBMITTED_EDIT` / `COMPLETE` requests in [`ticket-edit-requests.service.ts:106-125`](../../../apps/api/src/usecase/ticket-edit-requests/ticket-edit-requests.service.ts). **Keep** every other guard: payroll-lock (L91-96), open send-back (L100-104), one-open-request (L127), primary ownership + tenant, request-kind matching in `ticket-write-window.util.ts`. `grep` every producer/consumer of `TICKET_WINDOW_CLOSED` + the "within 24 hours of the scheduled end time" string so no parallel enforcement survives on the request path. | The 72h `CAPTURE_GRACE_HOURS` offline-capture guard and the LATE_COMPLETION (incomplete) path are unaffected — the cutoff block is gated `kind === SUBMITTED_EDIT || status === COMPLETE`, so incomplete tickets never entered it. Do not touch `ticketCompletionWindow`'s 24h window itself; it still governs direct completion of incomplete tickets. |
| Web (`apps/web`) | N/A — verify only | No completed-ticket edit-request UI on web. Grep to confirm before claiming none; record the grep. |
| Mobile (`apps/mobile`) | In [`ticket-editability.ts:139-150`](../../../apps/mobile/data/ticket-editability.ts): a `COMPLETE` ticket past its completion window must become `WINDOW_CLOSED_NEEDS_REQUEST` (approval path), **not** permanent `LOCKED`. Retain genuine payroll-void/settlement `LOCKED`. Check approved-window precedence (L119-124) against void/settlement so a stale approval never shows an unusable edit screen. Ensure the request sheet + "Request approval" button ([`incomplete-ticket-card.tsx:162-195`](../../../apps/mobile/components/field/incomplete-ticket-card.tsx)) are reachable from completed-ticket history — adjust copy for "correction" vs "finish incomplete". **Do not** inject completed tickets into the incomplete list to expose the action. `find-component` before any new component; preserve `data-testid`/test IDs. | Mobile holds no 24h literal — it reads server `completionWindow.state`/`windowEndsAt`. Once the API stops reporting `closed` as terminal for requests, verify what the contract now returns and that `ticket-editability.ts` branches on it correctly. |
| Shared (`packages/shared`) | N/A expected | `ticket-completion-window.ts` constants (`COMPLETION_WINDOW_HOURS=24`, `APPROVAL_WINDOW_HOURS=4`) stay as-is. Reassess only if the contract shape must change — if it does, run `tcg-contract-tracer` and fix all consumers in this unit. |
| Tests | `not requested` — update, don't add | Update existing assertions that encode the old completed-ticket cutoff (esp. `ticket-edit-requests.service.spec.ts`, `ticket-editability.test.ts`). No new spec files/cases. |

### Reviewable as

- **Demo:** on a configured tenant, take a completed ticket whose scheduled shift end is >24h
  ago → mobile shows "Request approval" (not a dead LOCKED card) → request → approve as a
  `payroll-admin:edit` user → edit within 4h → Save changes → confirm Payroll recalc enqueued
  → let the grant expire → confirm saved values kept and a fresh request is allowed.
- **Acceptance:** `plan.md` §5 matrix rows "Completed beyond 24h", "Approval at any later age",
  "Approval reaches exactly four hours", "Completed approval expires after original 24h".
- **Reviewer can verify without:** Unit 2, without finalized/invoiced data (payroll-locked
  stays blocked here by design).

### Risk

- **Weakest source:** `[UNVERIFIED]` — developer direction; client answers held `reference`.
  Not a blocker on its own; this is the normal case. Removing a cutoff is reversible.
- **Migration reversible:** yes — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no — eligibility logic only; no backfill.
- **Blast radius:** if the removal is too broad it could let requests through on
  payroll-locked or send-back tickets, or let an incomplete ticket skip the completion-window
  rule. Contained by keeping the other four guards and re-running the write-window + edit-request
  suites.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `ticket-edit-requests.service.spec.ts` | the removed cutoff assertion | update the assertion; run suite green vs baseline | `plan.md` §5 |
| Write-window guard `ticket-write-window.util.ts` + `.spec.ts` | request-kind matching unchanged | run existing suite; LATE_COMPLETION path untouched | `ticket-write-window.util.spec.ts` |
| Lazy + cron 4h expiry (`notification-scheduled-jobs.service.ts`, repository expiry spec) | approval window unchanged | run existing expiry suites | `ticket-edit-requests.repository.expiry.spec.ts` |
| Payroll recalc on `completeForWorker` | unchanged enqueue path | run `payroll-complete-ticket.spec.ts`; verify enqueue in demo | `job-tickets.service.ts:1684-1696` |
| Mobile editability + request UI | `ticket-editability.ts` state change | run `ticket-editability.test.ts`, `incomplete-ticket-card.test.tsx` | `apps/mobile` suites |
| Audit interceptor (time entries only) | unchanged | run `edit-under-approval-audit.interceptor.spec.ts` | note: audit scope is time-entries-only; broader-field audit is out of scope, raise if an approved edit touches non-time fields |

**A pre-existing consumer nobody checked is an unbuilt part of this unit.** The API and mobile
eligibility/copy changes must BOTH ship for the action to be usable — do not merge one without
the other.

### Deliberately not in this unit

- Payroll-at-all-times / finalized-record correction — Unit 2, blocked on `plan.md` §6 Q1.
- Supervisor/dispatcher on-behalf edits, leave-yard reminder, audit scope beyond time entries —
  not in this ticket; Kyle asked for them, raise as separate tickets.
- Any field-specific post-submit edit question found during build — record in `plan.md` §6
  before implementing unsourced behaviour; do not blanket-remove terminal write guards.

---

## Sequencing

```
U1  (ships alone)
```

- **Parallelisable:** single unit.
- **Merge order constraint:** none.
- **First unit to ship:** U1 proves the age cutoff was the only thing standing between the
  existing approval machinery and old completed tickets — it reuses that machinery untouched.
