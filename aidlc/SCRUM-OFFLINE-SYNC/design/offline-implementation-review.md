# Current offline implementation — correctness review

Reviewed 2026-10-02 at application commit `2e3fd102f`. Read-only application review;
temporary reproduction tests were removed. This follows
[the UI isolation review](nonblocking-sync-plan.md).

**Original review conclusion: the offline foundation was implemented, but the full flow was not correct.**
There are confirmed data-loss and replay defects in addition to the foreground loader
problem. Passing existing tests does not demonstrate end-to-end offline correctness.

## Remediation status — 2026-10-02

The original findings below describe the reviewed implementation before remediation.
Commit `c43b0f14d` fixed findings 3, 4, 5 and 9 and the second-verification null result.
Application commit `6f90f37eb` adds the remaining fixes and permanent regression coverage.

| Finding | Current implementation |
| --- | --- |
| 1 — first-step draft loss | Reset detection uses completed progress, preserving checklist metadata and unfinished answers. |
| 2 — local save failure | Offline Next and Submit require a durable save; storage errors retain editable work and surface an error. Authoritative draft reads also reject storage failures instead of overwriting work with a blank draft. |
| 5 related P2 — incomplete discrepancy repair | Completed payloads remain in `replayOps`; background repair sends signature, checklist, timer/lunch and labor inputs. Older captures can rebuild supported payloads. Missing legacy labor/checklist data blocks completion with a review error. |
| 6 — duplicate timers | Serializable close replay reconciles the existing nonrepeatable row by tenant, ticket and timer type before inserting. Repeatable timers keep separate identities. |
| 7 — account mixing | Drafts, clocks, files and query caches use user/tenant partitions. Owner metadata retains the employee identifier. Session generations guard requests, refreshes, cache reads, acknowledgments and UI continuations; logout clears live state while preserving each owner's work. |
| 8 — duplicate adjustment audits | Adjusted captures persist an operation UUID before dispatch. Replays reuse one immutable audit row; conflicting reuse is rejected before milestone writes. A new user adjustment receives a new UUID. No database migration is needed. |

Additional reconnect safeguards: automatic profile revalidation remains silent; concurrent
scanner callers await the same worker; same-owner revalidation preserves open tickets and
clocks; lost shift-start punches retain a durable replay operation. Wrapped authentication
rejections cannot authenticate an unrelated/stale cached profile.

**Rollout limitation:** older drafts and query caches without trustworthy owner metadata
remain untouched under their legacy keys. They are quarantined, not automatically assigned
to whoever signs in next. An explicit owner-verification/recovery process is still needed
for that historical data; current-account attribution would reintroduce finding 7. Older
labor captures without full saved inputs likewise require review rather than a false repair.
Physical-device lifecycle, flapping-network and frame-time validation remains pending.

**Remediation validation:** 306 mobile sync/storage/session regression tests passed across
16 suites; 79 API time-entry/adjustment tests passed across 5 suites. The signature and
checklist dispatchers passed 15 tests, including durable-save failure/retry coverage;
ticket/job deep-link screens passed 10 tests, including stale-account and read-failure
coverage. Targeted notification/drain/storage checks also passed (overlapping core coverage).
Mobile Nx lint and typecheck and API Nx lint/build passed. Focused Jest runs disabled
Watchman because the sandbox cannot access its socket; the initial Nx test attempts did
not provide a usable runner result, so the direct package Jest runners were used.

An additional legacy Review dispatcher test still fails: its mocked server setup does
not reach submission. Comparison against application HEAD `c43b0f14d` in an isolated
tracked-file copy reproduced the same failure before these changes. That baseline also
reproduced six signature/checklist fixture/assertion failures; those six are corrected
in the now-passing dispatcher suites. This does not claim a clean whole-repository test run.

## Scope and authority

Reviewed local drafts, step capture/queues, document-directory files, reconnect scheduling,
server comparison/final submit, offline session restore, account switching and backend
replay behavior. Product intent comes from this ticket's `intent.md` section 3, including
the 2026-09-25 revisions: preserve captured values locally, permit local completion offline,
catch up partial and completed tickets after reconnect, verify before backend completion,
and avoid blocking the UI. Vault/module indexes and the field-ops conflict stub were read;
this review does not adjudicate the conflicting FRDs.

P1 findings affect durable data, mandatory synchronization, or interaction. P2 findings
affect recovery or audit history. References below are relative to the repository root.

## Confirmed findings

### 1. P1 — Unfinished first-step checklist data is erased on normal reopen

- `apps/mobile/features/field-ticket/steps/shared/checklist/ChecklistBody.tsx:129`
- `apps/mobile/features/field-ticket/ticket-flow.store.ts:283` and `:393`

The checklist saves entry-time metadata under `data.pretrip`, while unfinished answers
are under `pretrip:draft`. Reset detection counts any non-`:draft` data key as completed
local progress. If the current server ticket still has no completed steps, reopening it
with a fresh cached response treats that ordinary state as a reset and wipes the draft.
No queued completion or unsynced photo is needed for this case.

**Reproduction:** actual store, fresh unchanged server ticket, first-step metadata plus
stamped unfinished answers, reopen as Oiler. Stored answers existed before reopen; the
live data became `{}` afterward. A temporary regression probe confirmed the behavior.

**Fix:** distinguish genuine completed progress from entry metadata. An unchanged server
with no completion must not delete unfinished drafts. Add the actual checklist wrapper
metadata to the reopen regression test, rather than testing only a pure `*:draft` entry.

### 2. P1 — Failed local persistence still reports offline completion

- `apps/mobile/features/field-ticket/ticket-flow.store.ts:516`
- Same file `:749` and `:838`

`writeDraft` returns false on failure. `persistCurrent` only sets `persistFailed`; it does
not reject. Offline Next advances, and offline Submit sets `submitted` and an offline
reference before awaiting this helper, then returns normally. No application component
reads `persistFailed`. Review therefore displays success despite a failed durable save.
A disk-full or storage-write failure followed by app restart can lose the only copy.

**Evidence:** direct control-flow trace and search for all non-test `persistFailed`
consumers. The existing store test explicitly verifies that write failure does not throw.

**Fix:** awaited completion/submission persistence must return a failure result or throw,
and the caller must not report successful durable completion until the write succeeds.
Keep captured data available in memory for retry and handle this actual storage failure
separately from the intentional silence around deferred network synchronization.

### 3. P1 — Upload catch-up overwrites edits saved during the upload

- `apps/mobile/features/field-ticket/sync/background-sync.ts:43` and `:60`

The scanner reads a draft, waits for a photo upload, updates the live attachment ledger,
then writes the previously read full draft. A user edit persisted during the wait is
replaced on disk by that old snapshot. Storage serialization orders the writes but does
not merge their contents. Live memory can still show the newer value, hiding the loss
until reopen/restart. Closed-draft step replay has the same snapshot/ownership concern
if that draft opens while a write is pending.

**Reproduction:** actual scanner/store with an upload paused by a deferred promise;
edit and flush `pretrip:draft.notes`, then release upload. Live memory kept the edit;
the disk draft reverted to `original`. The safety assertion failed at the expected value.

**Fix:** merge acknowledgments into the latest live/disk draft, with ownership and revision
checks. Never replace a concurrently edited draft with a pre-request snapshot.

### 4. P1 — Reconnect submission bypasses the complete verification sequence

- `apps/mobile/app/(field)/ticket/_layout.tsx:23`
- `apps/mobile/features/field-ticket/use-ticket-sync.ts:41`

The mounted ticket layout passes only a drain check to `useTicketSync`. The hook then
calls foreground `submitTicket(true, submitFn)` before invoking the scanner. Draining
successfully does not establish that the server snapshot has every required capture,
checklist, signature, labor entry and review/work-time closure. The scanner's verification
does not protect a submit that happened through this independent hook first. This path
also changes foreground `submitState` to `submitting`, contributing to UI coupling.

**Fix:** one automatic finalization path must own upload, ordered replay, review punch,
snapshot verification, eligible resend, re-verification and submit. Foreground and
automatic callers can share that UI-free sequence while keeping their loading states
separate.

**Related P2:** `apps/mobile/features/field-ticket/flow/ticket-step-screen.tsx:486` uses
`(await verify()) ?? []` for the second verification. If the ticket becomes unavailable
after resend, null is converted to “no discrepancies” and manual submit continues.
Treat null as failure on every verification pass.

### 5. P1 — A verification failure can strand a closed offline-submitted ticket

- `apps/mobile/features/field-ticket/sync/background-sync.ts:238`
- `apps/mobile/features/field-ticket/ticket-flow.store.ts:236`

The scanner changes a submitted draft to `error` on a verification discrepancy. Once
step and attachment ledgers are fully synced, `ticketNeedsSync` no longer selects that
draft: `error` is neither pending submission nor an offline-submitted state. Future
scans skip it even if the server discrepancy is later resolved. The separate mounted
ticket hook attempts error submissions, but cannot recover a ticket the user has left
closed in the background.

**Reproduction:** mismatch on the first scan, clear the mocked server discrepancy, run
the actual scanner again. Only the original review punch was called; no submit occurred.

**Fix:** retain a durable pending-finalization intent independently of foreground error
state, record discrepancy details, and schedule controlled retries. A corrected server
snapshot must make a closed ticket eligible again without requiring the ticket screen.

**Related P2:** `background-sync.ts:161` rebuilds missing writes using `derivedOps` after
synced entries have discarded their original ops. For checklists/signatures/labor and
Start Work this falls back to a completion marker, not the actual payload. Extract and
reuse the capture-to-operation builder instead of sending acknowledgments as data repair.

### 6. P1 — Lost timer-start responses can create duplicate backend rows

- `apps/mobile/features/field-ticket/steps/start-work/StartWorkBody.tsx:804` and `:814`
- Same file `:868` and `:882`
- `apps/api/src/service/ticket-time-entries/ticket-time-entries.repository.ts:459`

The phone creates a local UUID for a build-up/breakdown, but the online start request
sends only `startedAt`. If the server commits the start and its response is lost, the
phone keeps its different local UUID. Closing/replaying with that UUID causes
`upsertClosedSegment` to insert another row, because it looks up only the supplied ID.
The original server row remains open. Subsequent recovery/edits can select inconsistent
rows; correct payroll input can no longer be assumed from this replay path.

**Reproduction:** actual transpiled repository with an in-memory Prisma adapter, existing
server-ID start, then local-ID close. Result: two build-up rows, one open and one closed.
This demonstrates repository behavior; no live database or payroll run was exercised.

**Fix:** carry the same client-generated identity into start and close, or atomically
reconcile the existing single-instance timer row by tenant/ticket/type before creating.

### 7. P1, conditional on account switching — Drafts are replayed without owner isolation

- `apps/mobile/features/field-ticket/ticket-flow.store.ts:23`
- `apps/mobile/session/store.ts:152`
- `apps/mobile/features/field-ticket/sync/background-sync.ts:339`

Draft keys contain only ticket UUID/business code. Sign-out clears session credentials
and query memory but leaves the live ticket store, drafts and pending work. A newly
authenticated field user starts a scan of all `ticket:*` drafts using current credentials.
Code-based keys are also tenant-local business codes and can collide across tenants.

This proves client-side account mixing; it does not prove every wrong-account write
will be accepted. Backend roster/tenant authorization rejects many such requests. The
remaining problem includes stale visible data and inability to safely associate pending
work with its original owner. `clearPersistedQueryCache()` exists but has no call sites,
despite its comment claiming sign-out calls it.

**Fix:** record and partition tenant/employee ownership, scan only matching drafts, cancel
old-session work and reset live flow state on identity changes. Preserve pending work
under its original owner rather than deleting it indiscriminately. Wire explicit persisted
query-cache clearing into sign-out and identity-change handling.

### 8. P2 — Adjusted milestone replay duplicates audit events

- `apps/api/src/usecase/job-tickets/job-tickets.service.ts:805` and `:891`

Replaying the same milestone with `initialAt` different from `at` still meets the
adjustment condition after its first success. The service creates another adjustment
history row for each retry. Time-entry upsert does not make the separate audit insert
idempotent. A lost response or a later operation failure can therefore manufacture
additional adjustment events.

**Fix:** use a persisted operation identity and idempotent audit insertion, or another
explicit deduplication key consistent with legitimate repeated adjustments.

### 9. P1 — Background requests still activate the touch-blocking global loader

Previously confirmed in [the UI isolation review](nonblocking-sync-plan.md): background
writes, verification reads and broad cache refetches do not consistently use
`backgroundRequest: true`. This review does not change that conclusion. The fix must
cover the complete request chain and avoid foreground submit state during reconnect.

## Safeguards verified in the implementation

- Draft reads/writes/removals are serialized; step operations and pending states are persisted.
- The open-ticket drain sends operations in flow order, stops on failure, shares concurrent
  runs and checks both ticket ownership and revision before acknowledging success.
- Photos/signatures are copied into the document directory. References still carried by
  queued operations are protected from premature cleanup.
- Attachment replay carries `clientUploadId`; backend uniqueness, ticket/feature validation
  and duplicate-upload cleanup support idempotent retries.
- Signatures and checklist answers use upserts; numbered lunch/WTL slots reconcile
  atomically. Time writes use serializable transactions with conflict retries.
- Offline cold restore can recover identity from persisted query cache after a transient
  network failure. Transient token-refresh failure does not automatically destroy credentials.
- The scanner retains unsynced files/drafts and blocks its own finalization when pending
  ledgers or snapshot discrepancies remain.
- Backend final submit handles COMPLETE idempotently and changes status conditionally,
  avoiding duplicate completion notifications from concurrent successful submits.

These safeguards are useful, but they do not cover the failure paths listed above.

## Validation and limits

- Controlled actual-code probes confirmed stuck finalization, stale upload overwrite,
  first-step draft erasure and duplicate timer-row insertion.
- Reproduction dependencies substituted storage/network or Prisma adapters; no production
  requests, live DB writes or device frame-time measurements were performed.
- The earlier existing background-sync target passed; its mocks hide HTTP loader behavior.
- Broader existing field-ticket tests: 815 passed and 7 failed across five existing
  suites. The failures were Sig1 render timeout; Start Work's ambiguous `Adjust time`
  selector; Review's date-display expectation; checklist answer shape/photo-URI
  expectation; and three checklist autofill wiring failures, including a missing query
  provider. They are not all evidence of offline runtime defects.
- That broad run also discovered a temporary reproduction file before its separate run
  removed it, resulting in one additional ENOENT suite error with no tests executed.
  That review-harness artifact is excluded from the existing-test counts above. The
  process did not exit after writing its JSON report and was interrupted. Its result
  therefore cannot be presented as a clean Nx gate.
- Temporary upload/retry probes asserted the intended safety behavior and failed at the
  expected application result. An initial upload probe had a Jest dynamic-import harness
  error; it was corrected to a static import and rerun before accepting that finding.
  The first-step probe instead asserted the observed erasure and passed. Backend duplicate
  timer replay was checked with the actual transpiled repository and a substituted adapter.
- The server completeness guard is conditional on `TICKET_SUBMIT_STEP_GUARD=true`.
  Defaults/examples are false; production configuration was not inspected, so this review
  does not claim whether it is enabled in production.
- The existing listener is JS mounted in the field layout. It is not evidence of reliable
  synchronization while the operating system suspends or terminates the app. That lifecycle
  expectation needs separate validation if required; foreground app background-sync is
  the explicitly reviewed behavior here.

## Recommended sequence

Fix durable-write handling, first-step reset detection and stale-snapshot writes first.
Then consolidate verified automatic finalization, preserve retry intent and apply the
UI isolation plan. Repair timer identity/replay and account ownership before certifying
the complete flow. Add permanent regression tests for each confirmed trigger, then test
slow/flapping connectivity, storage rejection, lost responses, reopen/restart and account
switching on devices.
